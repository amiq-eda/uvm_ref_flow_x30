//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_clgen25.v                                                 ////
////                                                              ////
////  This25 file is part of the SPI25 IP25 core25 project25                ////
////  http25://www25.opencores25.org25/projects25/spi25/                      ////
////                                                              ////
////  Author25(s):                                                  ////
////      - Simon25 Srot25 (simons25@opencores25.org25)                     ////
////                                                              ////
////  All additional25 information is avaliable25 in the Readme25.txt25   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright25 (C) 2002 Authors25                                   ////
////                                                              ////
//// This25 source25 file may be used and distributed25 without         ////
//// restriction25 provided that this copyright25 statement25 is not    ////
//// removed from the file and that any derivative25 work25 contains25  ////
//// the original copyright25 notice25 and the associated disclaimer25. ////
////                                                              ////
//// This25 source25 file is free software25; you can redistribute25 it   ////
//// and/or modify it under the terms25 of the GNU25 Lesser25 General25   ////
//// Public25 License25 as published25 by the Free25 Software25 Foundation25; ////
//// either25 version25 2.1 of the License25, or (at your25 option) any   ////
//// later25 version25.                                               ////
////                                                              ////
//// This25 source25 is distributed25 in the hope25 that it will be       ////
//// useful25, but WITHOUT25 ANY25 WARRANTY25; without even25 the implied25   ////
//// warranty25 of MERCHANTABILITY25 or FITNESS25 FOR25 A PARTICULAR25      ////
//// PURPOSE25.  See the GNU25 Lesser25 General25 Public25 License25 for more ////
//// details25.                                                     ////
////                                                              ////
//// You should have received25 a copy of the GNU25 Lesser25 General25    ////
//// Public25 License25 along25 with this source25; if not, download25 it   ////
//// from http25://www25.opencores25.org25/lgpl25.shtml25                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines25.v"
`include "timescale.v"

module spi_clgen25 (clk_in25, rst25, go25, enable, last_clk25, divider25, clk_out25, pos_edge25, neg_edge25); 

  parameter Tp25 = 1;
  
  input                            clk_in25;   // input clock25 (system clock25)
  input                            rst25;      // reset
  input                            enable;   // clock25 enable
  input                            go25;       // start transfer25
  input                            last_clk25; // last clock25
  input     [`SPI_DIVIDER_LEN25-1:0] divider25;  // clock25 divider25 (output clock25 is divided25 by this value)
  output                           clk_out25;  // output clock25
  output                           pos_edge25; // pulse25 marking25 positive25 edge of clk_out25
  output                           neg_edge25; // pulse25 marking25 negative edge of clk_out25
                            
  reg                              clk_out25;
  reg                              pos_edge25;
  reg                              neg_edge25;
                            
  reg       [`SPI_DIVIDER_LEN25-1:0] cnt;      // clock25 counter 
  wire                             cnt_zero25; // conter25 is equal25 to zero
  wire                             cnt_one25;  // conter25 is equal25 to one
  
  
  assign cnt_zero25 = cnt == {`SPI_DIVIDER_LEN25{1'b0}};
  assign cnt_one25  = cnt == {{`SPI_DIVIDER_LEN25-1{1'b0}}, 1'b1};
  
  // Counter25 counts25 half25 period25
  always @(posedge clk_in25 or posedge rst25)
  begin
    if(rst25)
      cnt <= #Tp25 {`SPI_DIVIDER_LEN25{1'b1}};
    else
      begin
        if(!enable || cnt_zero25)
          cnt <= #Tp25 divider25;
        else
          cnt <= #Tp25 cnt - {{`SPI_DIVIDER_LEN25-1{1'b0}}, 1'b1};
      end
  end
  
  // clk_out25 is asserted25 every25 other half25 period25
  always @(posedge clk_in25 or posedge rst25)
  begin
    if(rst25)
      clk_out25 <= #Tp25 1'b0;
    else
      clk_out25 <= #Tp25 (enable && cnt_zero25 && (!last_clk25 || clk_out25)) ? ~clk_out25 : clk_out25;
  end
   
  // Pos25 and neg25 edge signals25
  always @(posedge clk_in25 or posedge rst25)
  begin
    if(rst25)
      begin
        pos_edge25  <= #Tp25 1'b0;
        neg_edge25  <= #Tp25 1'b0;
      end
    else
      begin
        pos_edge25  <= #Tp25 (enable && !clk_out25 && cnt_one25) || (!(|divider25) && clk_out25) || (!(|divider25) && go25 && !enable);
        neg_edge25  <= #Tp25 (enable && clk_out25 && cnt_one25) || (!(|divider25) && !clk_out25 && enable);
      end
  end
endmodule
 
