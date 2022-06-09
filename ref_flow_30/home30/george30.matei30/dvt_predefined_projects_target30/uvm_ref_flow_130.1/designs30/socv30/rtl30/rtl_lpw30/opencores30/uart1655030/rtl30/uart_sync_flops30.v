//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_sync_flops30.v                                             ////
////                                                              ////
////                                                              ////
////  This30 file is part of the "UART30 16550 compatible30" project30    ////
////  http30://www30.opencores30.org30/cores30/uart1655030/                   ////
////                                                              ////
////  Documentation30 related30 to this project30:                      ////
////  - http30://www30.opencores30.org30/cores30/uart1655030/                 ////
////                                                              ////
////  Projects30 compatibility30:                                     ////
////  - WISHBONE30                                                  ////
////  RS23230 Protocol30                                              ////
////  16550D uart30 (mostly30 supported)                              ////
////                                                              ////
////  Overview30 (main30 Features30):                                   ////
////  UART30 core30 receiver30 logic                                    ////
////                                                              ////
////  Known30 problems30 (limits30):                                    ////
////  None30 known30                                                  ////
////                                                              ////
////  To30 Do30:                                                      ////
////  Thourough30 testing30.                                          ////
////                                                              ////
////  Author30(s):                                                  ////
////      - Andrej30 Erzen30 (andreje30@flextronics30.si30)                 ////
////      - Tadej30 Markovic30 (tadejm30@flextronics30.si30)                ////
////                                                              ////
////  Created30:        2004/05/20                                  ////
////  Last30 Updated30:   2004/05/20                                  ////
////                  (See log30 for the revision30 history30)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright30 (C) 2000, 2001 Authors30                             ////
////                                                              ////
//// This30 source30 file may be used and distributed30 without         ////
//// restriction30 provided that this copyright30 statement30 is not    ////
//// removed from the file and that any derivative30 work30 contains30  ////
//// the original copyright30 notice30 and the associated disclaimer30. ////
////                                                              ////
//// This30 source30 file is free software30; you can redistribute30 it   ////
//// and/or modify it under the terms30 of the GNU30 Lesser30 General30   ////
//// Public30 License30 as published30 by the Free30 Software30 Foundation30; ////
//// either30 version30 2.1 of the License30, or (at your30 option) any   ////
//// later30 version30.                                               ////
////                                                              ////
//// This30 source30 is distributed30 in the hope30 that it will be       ////
//// useful30, but WITHOUT30 ANY30 WARRANTY30; without even30 the implied30   ////
//// warranty30 of MERCHANTABILITY30 or FITNESS30 FOR30 A PARTICULAR30      ////
//// PURPOSE30.  See the GNU30 Lesser30 General30 Public30 License30 for more ////
//// details30.                                                     ////
////                                                              ////
//// You should have received30 a copy of the GNU30 Lesser30 General30    ////
//// Public30 License30 along30 with this source30; if not, download30 it   ////
//// from http30://www30.opencores30.org30/lgpl30.shtml30                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS30 Revision30 History30
//
// $Log: not supported by cvs2svn30 $
//


`include "timescale.v"


module uart_sync_flops30
(
  // internal signals30
  rst_i30,
  clk_i30,
  stage1_rst_i30,
  stage1_clk_en_i30,
  async_dat_i30,
  sync_dat_o30
);

parameter Tp30            = 1;
parameter width         = 1;
parameter init_value30    = 1'b0;

input                           rst_i30;                  // reset input
input                           clk_i30;                  // clock30 input
input                           stage1_rst_i30;           // synchronous30 reset for stage30 1 FF30
input                           stage1_clk_en_i30;        // synchronous30 clock30 enable for stage30 1 FF30
input   [width-1:0]             async_dat_i30;            // asynchronous30 data input
output  [width-1:0]             sync_dat_o30;             // synchronous30 data output


//
// Interal30 signal30 declarations30
//

reg     [width-1:0]             sync_dat_o30;
reg     [width-1:0]             flop_030;


// first stage30
always @ (posedge clk_i30 or posedge rst_i30)
begin
    if (rst_i30)
        flop_030 <= #Tp30 {width{init_value30}};
    else
        flop_030 <= #Tp30 async_dat_i30;    
end

// second stage30
always @ (posedge clk_i30 or posedge rst_i30)
begin
    if (rst_i30)
        sync_dat_o30 <= #Tp30 {width{init_value30}};
    else if (stage1_rst_i30)
        sync_dat_o30 <= #Tp30 {width{init_value30}};
    else if (stage1_clk_en_i30)
        sync_dat_o30 <= #Tp30 flop_030;       
end

endmodule
