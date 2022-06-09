//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_clgen20.v                                                 ////
////                                                              ////
////  This20 file is part of the SPI20 IP20 core20 project20                ////
////  http20://www20.opencores20.org20/projects20/spi20/                      ////
////                                                              ////
////  Author20(s):                                                  ////
////      - Simon20 Srot20 (simons20@opencores20.org20)                     ////
////                                                              ////
////  All additional20 information is avaliable20 in the Readme20.txt20   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright20 (C) 2002 Authors20                                   ////
////                                                              ////
//// This20 source20 file may be used and distributed20 without         ////
//// restriction20 provided that this copyright20 statement20 is not    ////
//// removed from the file and that any derivative20 work20 contains20  ////
//// the original copyright20 notice20 and the associated disclaimer20. ////
////                                                              ////
//// This20 source20 file is free software20; you can redistribute20 it   ////
//// and/or modify it under the terms20 of the GNU20 Lesser20 General20   ////
//// Public20 License20 as published20 by the Free20 Software20 Foundation20; ////
//// either20 version20 2.1 of the License20, or (at your20 option) any   ////
//// later20 version20.                                               ////
////                                                              ////
//// This20 source20 is distributed20 in the hope20 that it will be       ////
//// useful20, but WITHOUT20 ANY20 WARRANTY20; without even20 the implied20   ////
//// warranty20 of MERCHANTABILITY20 or FITNESS20 FOR20 A PARTICULAR20      ////
//// PURPOSE20.  See the GNU20 Lesser20 General20 Public20 License20 for more ////
//// details20.                                                     ////
////                                                              ////
//// You should have received20 a copy of the GNU20 Lesser20 General20    ////
//// Public20 License20 along20 with this source20; if not, download20 it   ////
//// from http20://www20.opencores20.org20/lgpl20.shtml20                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines20.v"
`include "timescale.v"

module spi_clgen20 (clk_in20, rst20, go20, enable, last_clk20, divider20, clk_out20, pos_edge20, neg_edge20); 

  parameter Tp20 = 1;
  
  input                            clk_in20;   // input clock20 (system clock20)
  input                            rst20;      // reset
  input                            enable;   // clock20 enable
  input                            go20;       // start transfer20
  input                            last_clk20; // last clock20
  input     [`SPI_DIVIDER_LEN20-1:0] divider20;  // clock20 divider20 (output clock20 is divided20 by this value)
  output                           clk_out20;  // output clock20
  output                           pos_edge20; // pulse20 marking20 positive20 edge of clk_out20
  output                           neg_edge20; // pulse20 marking20 negative edge of clk_out20
                            
  reg                              clk_out20;
  reg                              pos_edge20;
  reg                              neg_edge20;
                            
  reg       [`SPI_DIVIDER_LEN20-1:0] cnt;      // clock20 counter 
  wire                             cnt_zero20; // conter20 is equal20 to zero
  wire                             cnt_one20;  // conter20 is equal20 to one
  
  
  assign cnt_zero20 = cnt == {`SPI_DIVIDER_LEN20{1'b0}};
  assign cnt_one20  = cnt == {{`SPI_DIVIDER_LEN20-1{1'b0}}, 1'b1};
  
  // Counter20 counts20 half20 period20
  always @(posedge clk_in20 or posedge rst20)
  begin
    if(rst20)
      cnt <= #Tp20 {`SPI_DIVIDER_LEN20{1'b1}};
    else
      begin
        if(!enable || cnt_zero20)
          cnt <= #Tp20 divider20;
        else
          cnt <= #Tp20 cnt - {{`SPI_DIVIDER_LEN20-1{1'b0}}, 1'b1};
      end
  end
  
  // clk_out20 is asserted20 every20 other half20 period20
  always @(posedge clk_in20 or posedge rst20)
  begin
    if(rst20)
      clk_out20 <= #Tp20 1'b0;
    else
      clk_out20 <= #Tp20 (enable && cnt_zero20 && (!last_clk20 || clk_out20)) ? ~clk_out20 : clk_out20;
  end
   
  // Pos20 and neg20 edge signals20
  always @(posedge clk_in20 or posedge rst20)
  begin
    if(rst20)
      begin
        pos_edge20  <= #Tp20 1'b0;
        neg_edge20  <= #Tp20 1'b0;
      end
    else
      begin
        pos_edge20  <= #Tp20 (enable && !clk_out20 && cnt_one20) || (!(|divider20) && clk_out20) || (!(|divider20) && go20 && !enable);
        neg_edge20  <= #Tp20 (enable && clk_out20 && cnt_one20) || (!(|divider20) && !clk_out20 && enable);
      end
  end
endmodule
 
