//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_clgen1.v                                                 ////
////                                                              ////
////  This1 file is part of the SPI1 IP1 core1 project1                ////
////  http1://www1.opencores1.org1/projects1/spi1/                      ////
////                                                              ////
////  Author1(s):                                                  ////
////      - Simon1 Srot1 (simons1@opencores1.org1)                     ////
////                                                              ////
////  All additional1 information is avaliable1 in the Readme1.txt1   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright1 (C) 2002 Authors1                                   ////
////                                                              ////
//// This1 source1 file may be used and distributed1 without         ////
//// restriction1 provided that this copyright1 statement1 is not    ////
//// removed from the file and that any derivative1 work1 contains1  ////
//// the original copyright1 notice1 and the associated disclaimer1. ////
////                                                              ////
//// This1 source1 file is free software1; you can redistribute1 it   ////
//// and/or modify it under the terms1 of the GNU1 Lesser1 General1   ////
//// Public1 License1 as published1 by the Free1 Software1 Foundation1; ////
//// either1 version1 2.1 of the License1, or (at your1 option) any   ////
//// later1 version1.                                               ////
////                                                              ////
//// This1 source1 is distributed1 in the hope1 that it will be       ////
//// useful1, but WITHOUT1 ANY1 WARRANTY1; without even1 the implied1   ////
//// warranty1 of MERCHANTABILITY1 or FITNESS1 FOR1 A PARTICULAR1      ////
//// PURPOSE1.  See the GNU1 Lesser1 General1 Public1 License1 for more ////
//// details1.                                                     ////
////                                                              ////
//// You should have received1 a copy of the GNU1 Lesser1 General1    ////
//// Public1 License1 along1 with this source1; if not, download1 it   ////
//// from http1://www1.opencores1.org1/lgpl1.shtml1                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines1.v"
`include "timescale.v"

module spi_clgen1 (clk_in1, rst1, go1, enable, last_clk1, divider1, clk_out1, pos_edge1, neg_edge1); 

  parameter Tp1 = 1;
  
  input                            clk_in1;   // input clock1 (system clock1)
  input                            rst1;      // reset
  input                            enable;   // clock1 enable
  input                            go1;       // start transfer1
  input                            last_clk1; // last clock1
  input     [`SPI_DIVIDER_LEN1-1:0] divider1;  // clock1 divider1 (output clock1 is divided1 by this value)
  output                           clk_out1;  // output clock1
  output                           pos_edge1; // pulse1 marking1 positive1 edge of clk_out1
  output                           neg_edge1; // pulse1 marking1 negative edge of clk_out1
                            
  reg                              clk_out1;
  reg                              pos_edge1;
  reg                              neg_edge1;
                            
  reg       [`SPI_DIVIDER_LEN1-1:0] cnt;      // clock1 counter 
  wire                             cnt_zero1; // conter1 is equal1 to zero
  wire                             cnt_one1;  // conter1 is equal1 to one
  
  
  assign cnt_zero1 = cnt == {`SPI_DIVIDER_LEN1{1'b0}};
  assign cnt_one1  = cnt == {{`SPI_DIVIDER_LEN1-1{1'b0}}, 1'b1};
  
  // Counter1 counts1 half1 period1
  always @(posedge clk_in1 or posedge rst1)
  begin
    if(rst1)
      cnt <= #Tp1 {`SPI_DIVIDER_LEN1{1'b1}};
    else
      begin
        if(!enable || cnt_zero1)
          cnt <= #Tp1 divider1;
        else
          cnt <= #Tp1 cnt - {{`SPI_DIVIDER_LEN1-1{1'b0}}, 1'b1};
      end
  end
  
  // clk_out1 is asserted1 every1 other half1 period1
  always @(posedge clk_in1 or posedge rst1)
  begin
    if(rst1)
      clk_out1 <= #Tp1 1'b0;
    else
      clk_out1 <= #Tp1 (enable && cnt_zero1 && (!last_clk1 || clk_out1)) ? ~clk_out1 : clk_out1;
  end
   
  // Pos1 and neg1 edge signals1
  always @(posedge clk_in1 or posedge rst1)
  begin
    if(rst1)
      begin
        pos_edge1  <= #Tp1 1'b0;
        neg_edge1  <= #Tp1 1'b0;
      end
    else
      begin
        pos_edge1  <= #Tp1 (enable && !clk_out1 && cnt_one1) || (!(|divider1) && clk_out1) || (!(|divider1) && go1 && !enable);
        neg_edge1  <= #Tp1 (enable && clk_out1 && cnt_one1) || (!(|divider1) && !clk_out1 && enable);
      end
  end
endmodule
 
