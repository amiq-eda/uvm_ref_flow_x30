//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_clgen24.v                                                 ////
////                                                              ////
////  This24 file is part of the SPI24 IP24 core24 project24                ////
////  http24://www24.opencores24.org24/projects24/spi24/                      ////
////                                                              ////
////  Author24(s):                                                  ////
////      - Simon24 Srot24 (simons24@opencores24.org24)                     ////
////                                                              ////
////  All additional24 information is avaliable24 in the Readme24.txt24   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright24 (C) 2002 Authors24                                   ////
////                                                              ////
//// This24 source24 file may be used and distributed24 without         ////
//// restriction24 provided that this copyright24 statement24 is not    ////
//// removed from the file and that any derivative24 work24 contains24  ////
//// the original copyright24 notice24 and the associated disclaimer24. ////
////                                                              ////
//// This24 source24 file is free software24; you can redistribute24 it   ////
//// and/or modify it under the terms24 of the GNU24 Lesser24 General24   ////
//// Public24 License24 as published24 by the Free24 Software24 Foundation24; ////
//// either24 version24 2.1 of the License24, or (at your24 option) any   ////
//// later24 version24.                                               ////
////                                                              ////
//// This24 source24 is distributed24 in the hope24 that it will be       ////
//// useful24, but WITHOUT24 ANY24 WARRANTY24; without even24 the implied24   ////
//// warranty24 of MERCHANTABILITY24 or FITNESS24 FOR24 A PARTICULAR24      ////
//// PURPOSE24.  See the GNU24 Lesser24 General24 Public24 License24 for more ////
//// details24.                                                     ////
////                                                              ////
//// You should have received24 a copy of the GNU24 Lesser24 General24    ////
//// Public24 License24 along24 with this source24; if not, download24 it   ////
//// from http24://www24.opencores24.org24/lgpl24.shtml24                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines24.v"
`include "timescale.v"

module spi_clgen24 (clk_in24, rst24, go24, enable, last_clk24, divider24, clk_out24, pos_edge24, neg_edge24); 

  parameter Tp24 = 1;
  
  input                            clk_in24;   // input clock24 (system clock24)
  input                            rst24;      // reset
  input                            enable;   // clock24 enable
  input                            go24;       // start transfer24
  input                            last_clk24; // last clock24
  input     [`SPI_DIVIDER_LEN24-1:0] divider24;  // clock24 divider24 (output clock24 is divided24 by this value)
  output                           clk_out24;  // output clock24
  output                           pos_edge24; // pulse24 marking24 positive24 edge of clk_out24
  output                           neg_edge24; // pulse24 marking24 negative edge of clk_out24
                            
  reg                              clk_out24;
  reg                              pos_edge24;
  reg                              neg_edge24;
                            
  reg       [`SPI_DIVIDER_LEN24-1:0] cnt;      // clock24 counter 
  wire                             cnt_zero24; // conter24 is equal24 to zero
  wire                             cnt_one24;  // conter24 is equal24 to one
  
  
  assign cnt_zero24 = cnt == {`SPI_DIVIDER_LEN24{1'b0}};
  assign cnt_one24  = cnt == {{`SPI_DIVIDER_LEN24-1{1'b0}}, 1'b1};
  
  // Counter24 counts24 half24 period24
  always @(posedge clk_in24 or posedge rst24)
  begin
    if(rst24)
      cnt <= #Tp24 {`SPI_DIVIDER_LEN24{1'b1}};
    else
      begin
        if(!enable || cnt_zero24)
          cnt <= #Tp24 divider24;
        else
          cnt <= #Tp24 cnt - {{`SPI_DIVIDER_LEN24-1{1'b0}}, 1'b1};
      end
  end
  
  // clk_out24 is asserted24 every24 other half24 period24
  always @(posedge clk_in24 or posedge rst24)
  begin
    if(rst24)
      clk_out24 <= #Tp24 1'b0;
    else
      clk_out24 <= #Tp24 (enable && cnt_zero24 && (!last_clk24 || clk_out24)) ? ~clk_out24 : clk_out24;
  end
   
  // Pos24 and neg24 edge signals24
  always @(posedge clk_in24 or posedge rst24)
  begin
    if(rst24)
      begin
        pos_edge24  <= #Tp24 1'b0;
        neg_edge24  <= #Tp24 1'b0;
      end
    else
      begin
        pos_edge24  <= #Tp24 (enable && !clk_out24 && cnt_one24) || (!(|divider24) && clk_out24) || (!(|divider24) && go24 && !enable);
        neg_edge24  <= #Tp24 (enable && clk_out24 && cnt_one24) || (!(|divider24) && !clk_out24 && enable);
      end
  end
endmodule
 
