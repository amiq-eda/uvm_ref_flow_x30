//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_clgen30.v                                                 ////
////                                                              ////
////  This30 file is part of the SPI30 IP30 core30 project30                ////
////  http30://www30.opencores30.org30/projects30/spi30/                      ////
////                                                              ////
////  Author30(s):                                                  ////
////      - Simon30 Srot30 (simons30@opencores30.org30)                     ////
////                                                              ////
////  All additional30 information is avaliable30 in the Readme30.txt30   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright30 (C) 2002 Authors30                                   ////
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

`include "spi_defines30.v"
`include "timescale.v"

module spi_clgen30 (clk_in30, rst30, go30, enable, last_clk30, divider30, clk_out30, pos_edge30, neg_edge30); 

  parameter Tp30 = 1;
  
  input                            clk_in30;   // input clock30 (system clock30)
  input                            rst30;      // reset
  input                            enable;   // clock30 enable
  input                            go30;       // start transfer30
  input                            last_clk30; // last clock30
  input     [`SPI_DIVIDER_LEN30-1:0] divider30;  // clock30 divider30 (output clock30 is divided30 by this value)
  output                           clk_out30;  // output clock30
  output                           pos_edge30; // pulse30 marking30 positive30 edge of clk_out30
  output                           neg_edge30; // pulse30 marking30 negative edge of clk_out30
                            
  reg                              clk_out30;
  reg                              pos_edge30;
  reg                              neg_edge30;
                            
  reg       [`SPI_DIVIDER_LEN30-1:0] cnt;      // clock30 counter 
  wire                             cnt_zero30; // conter30 is equal30 to zero
  wire                             cnt_one30;  // conter30 is equal30 to one
  
  
  assign cnt_zero30 = cnt == {`SPI_DIVIDER_LEN30{1'b0}};
  assign cnt_one30  = cnt == {{`SPI_DIVIDER_LEN30-1{1'b0}}, 1'b1};
  
  // Counter30 counts30 half30 period30
  always @(posedge clk_in30 or posedge rst30)
  begin
    if(rst30)
      cnt <= #Tp30 {`SPI_DIVIDER_LEN30{1'b1}};
    else
      begin
        if(!enable || cnt_zero30)
          cnt <= #Tp30 divider30;
        else
          cnt <= #Tp30 cnt - {{`SPI_DIVIDER_LEN30-1{1'b0}}, 1'b1};
      end
  end
  
  // clk_out30 is asserted30 every30 other half30 period30
  always @(posedge clk_in30 or posedge rst30)
  begin
    if(rst30)
      clk_out30 <= #Tp30 1'b0;
    else
      clk_out30 <= #Tp30 (enable && cnt_zero30 && (!last_clk30 || clk_out30)) ? ~clk_out30 : clk_out30;
  end
   
  // Pos30 and neg30 edge signals30
  always @(posedge clk_in30 or posedge rst30)
  begin
    if(rst30)
      begin
        pos_edge30  <= #Tp30 1'b0;
        neg_edge30  <= #Tp30 1'b0;
      end
    else
      begin
        pos_edge30  <= #Tp30 (enable && !clk_out30 && cnt_one30) || (!(|divider30) && clk_out30) || (!(|divider30) && go30 && !enable);
        neg_edge30  <= #Tp30 (enable && clk_out30 && cnt_one30) || (!(|divider30) && !clk_out30 && enable);
      end
  end
endmodule
 
