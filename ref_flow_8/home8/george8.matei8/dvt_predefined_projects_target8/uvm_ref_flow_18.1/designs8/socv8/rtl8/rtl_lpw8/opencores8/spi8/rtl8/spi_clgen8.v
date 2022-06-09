//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_clgen8.v                                                 ////
////                                                              ////
////  This8 file is part of the SPI8 IP8 core8 project8                ////
////  http8://www8.opencores8.org8/projects8/spi8/                      ////
////                                                              ////
////  Author8(s):                                                  ////
////      - Simon8 Srot8 (simons8@opencores8.org8)                     ////
////                                                              ////
////  All additional8 information is avaliable8 in the Readme8.txt8   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright8 (C) 2002 Authors8                                   ////
////                                                              ////
//// This8 source8 file may be used and distributed8 without         ////
//// restriction8 provided that this copyright8 statement8 is not    ////
//// removed from the file and that any derivative8 work8 contains8  ////
//// the original copyright8 notice8 and the associated disclaimer8. ////
////                                                              ////
//// This8 source8 file is free software8; you can redistribute8 it   ////
//// and/or modify it under the terms8 of the GNU8 Lesser8 General8   ////
//// Public8 License8 as published8 by the Free8 Software8 Foundation8; ////
//// either8 version8 2.1 of the License8, or (at your8 option) any   ////
//// later8 version8.                                               ////
////                                                              ////
//// This8 source8 is distributed8 in the hope8 that it will be       ////
//// useful8, but WITHOUT8 ANY8 WARRANTY8; without even8 the implied8   ////
//// warranty8 of MERCHANTABILITY8 or FITNESS8 FOR8 A PARTICULAR8      ////
//// PURPOSE8.  See the GNU8 Lesser8 General8 Public8 License8 for more ////
//// details8.                                                     ////
////                                                              ////
//// You should have received8 a copy of the GNU8 Lesser8 General8    ////
//// Public8 License8 along8 with this source8; if not, download8 it   ////
//// from http8://www8.opencores8.org8/lgpl8.shtml8                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines8.v"
`include "timescale.v"

module spi_clgen8 (clk_in8, rst8, go8, enable, last_clk8, divider8, clk_out8, pos_edge8, neg_edge8); 

  parameter Tp8 = 1;
  
  input                            clk_in8;   // input clock8 (system clock8)
  input                            rst8;      // reset
  input                            enable;   // clock8 enable
  input                            go8;       // start transfer8
  input                            last_clk8; // last clock8
  input     [`SPI_DIVIDER_LEN8-1:0] divider8;  // clock8 divider8 (output clock8 is divided8 by this value)
  output                           clk_out8;  // output clock8
  output                           pos_edge8; // pulse8 marking8 positive8 edge of clk_out8
  output                           neg_edge8; // pulse8 marking8 negative edge of clk_out8
                            
  reg                              clk_out8;
  reg                              pos_edge8;
  reg                              neg_edge8;
                            
  reg       [`SPI_DIVIDER_LEN8-1:0] cnt;      // clock8 counter 
  wire                             cnt_zero8; // conter8 is equal8 to zero
  wire                             cnt_one8;  // conter8 is equal8 to one
  
  
  assign cnt_zero8 = cnt == {`SPI_DIVIDER_LEN8{1'b0}};
  assign cnt_one8  = cnt == {{`SPI_DIVIDER_LEN8-1{1'b0}}, 1'b1};
  
  // Counter8 counts8 half8 period8
  always @(posedge clk_in8 or posedge rst8)
  begin
    if(rst8)
      cnt <= #Tp8 {`SPI_DIVIDER_LEN8{1'b1}};
    else
      begin
        if(!enable || cnt_zero8)
          cnt <= #Tp8 divider8;
        else
          cnt <= #Tp8 cnt - {{`SPI_DIVIDER_LEN8-1{1'b0}}, 1'b1};
      end
  end
  
  // clk_out8 is asserted8 every8 other half8 period8
  always @(posedge clk_in8 or posedge rst8)
  begin
    if(rst8)
      clk_out8 <= #Tp8 1'b0;
    else
      clk_out8 <= #Tp8 (enable && cnt_zero8 && (!last_clk8 || clk_out8)) ? ~clk_out8 : clk_out8;
  end
   
  // Pos8 and neg8 edge signals8
  always @(posedge clk_in8 or posedge rst8)
  begin
    if(rst8)
      begin
        pos_edge8  <= #Tp8 1'b0;
        neg_edge8  <= #Tp8 1'b0;
      end
    else
      begin
        pos_edge8  <= #Tp8 (enable && !clk_out8 && cnt_one8) || (!(|divider8) && clk_out8) || (!(|divider8) && go8 && !enable);
        neg_edge8  <= #Tp8 (enable && clk_out8 && cnt_one8) || (!(|divider8) && !clk_out8 && enable);
      end
  end
endmodule
 
