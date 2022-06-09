//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_clgen16.v                                                 ////
////                                                              ////
////  This16 file is part of the SPI16 IP16 core16 project16                ////
////  http16://www16.opencores16.org16/projects16/spi16/                      ////
////                                                              ////
////  Author16(s):                                                  ////
////      - Simon16 Srot16 (simons16@opencores16.org16)                     ////
////                                                              ////
////  All additional16 information is avaliable16 in the Readme16.txt16   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright16 (C) 2002 Authors16                                   ////
////                                                              ////
//// This16 source16 file may be used and distributed16 without         ////
//// restriction16 provided that this copyright16 statement16 is not    ////
//// removed from the file and that any derivative16 work16 contains16  ////
//// the original copyright16 notice16 and the associated disclaimer16. ////
////                                                              ////
//// This16 source16 file is free software16; you can redistribute16 it   ////
//// and/or modify it under the terms16 of the GNU16 Lesser16 General16   ////
//// Public16 License16 as published16 by the Free16 Software16 Foundation16; ////
//// either16 version16 2.1 of the License16, or (at your16 option) any   ////
//// later16 version16.                                               ////
////                                                              ////
//// This16 source16 is distributed16 in the hope16 that it will be       ////
//// useful16, but WITHOUT16 ANY16 WARRANTY16; without even16 the implied16   ////
//// warranty16 of MERCHANTABILITY16 or FITNESS16 FOR16 A PARTICULAR16      ////
//// PURPOSE16.  See the GNU16 Lesser16 General16 Public16 License16 for more ////
//// details16.                                                     ////
////                                                              ////
//// You should have received16 a copy of the GNU16 Lesser16 General16    ////
//// Public16 License16 along16 with this source16; if not, download16 it   ////
//// from http16://www16.opencores16.org16/lgpl16.shtml16                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines16.v"
`include "timescale.v"

module spi_clgen16 (clk_in16, rst16, go16, enable, last_clk16, divider16, clk_out16, pos_edge16, neg_edge16); 

  parameter Tp16 = 1;
  
  input                            clk_in16;   // input clock16 (system clock16)
  input                            rst16;      // reset
  input                            enable;   // clock16 enable
  input                            go16;       // start transfer16
  input                            last_clk16; // last clock16
  input     [`SPI_DIVIDER_LEN16-1:0] divider16;  // clock16 divider16 (output clock16 is divided16 by this value)
  output                           clk_out16;  // output clock16
  output                           pos_edge16; // pulse16 marking16 positive16 edge of clk_out16
  output                           neg_edge16; // pulse16 marking16 negative edge of clk_out16
                            
  reg                              clk_out16;
  reg                              pos_edge16;
  reg                              neg_edge16;
                            
  reg       [`SPI_DIVIDER_LEN16-1:0] cnt;      // clock16 counter 
  wire                             cnt_zero16; // conter16 is equal16 to zero
  wire                             cnt_one16;  // conter16 is equal16 to one
  
  
  assign cnt_zero16 = cnt == {`SPI_DIVIDER_LEN16{1'b0}};
  assign cnt_one16  = cnt == {{`SPI_DIVIDER_LEN16-1{1'b0}}, 1'b1};
  
  // Counter16 counts16 half16 period16
  always @(posedge clk_in16 or posedge rst16)
  begin
    if(rst16)
      cnt <= #Tp16 {`SPI_DIVIDER_LEN16{1'b1}};
    else
      begin
        if(!enable || cnt_zero16)
          cnt <= #Tp16 divider16;
        else
          cnt <= #Tp16 cnt - {{`SPI_DIVIDER_LEN16-1{1'b0}}, 1'b1};
      end
  end
  
  // clk_out16 is asserted16 every16 other half16 period16
  always @(posedge clk_in16 or posedge rst16)
  begin
    if(rst16)
      clk_out16 <= #Tp16 1'b0;
    else
      clk_out16 <= #Tp16 (enable && cnt_zero16 && (!last_clk16 || clk_out16)) ? ~clk_out16 : clk_out16;
  end
   
  // Pos16 and neg16 edge signals16
  always @(posedge clk_in16 or posedge rst16)
  begin
    if(rst16)
      begin
        pos_edge16  <= #Tp16 1'b0;
        neg_edge16  <= #Tp16 1'b0;
      end
    else
      begin
        pos_edge16  <= #Tp16 (enable && !clk_out16 && cnt_one16) || (!(|divider16) && clk_out16) || (!(|divider16) && go16 && !enable);
        neg_edge16  <= #Tp16 (enable && clk_out16 && cnt_one16) || (!(|divider16) && !clk_out16 && enable);
      end
  end
endmodule
 
