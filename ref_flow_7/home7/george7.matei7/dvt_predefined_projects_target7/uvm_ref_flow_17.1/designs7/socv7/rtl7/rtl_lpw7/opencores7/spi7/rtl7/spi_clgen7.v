//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_clgen7.v                                                 ////
////                                                              ////
////  This7 file is part of the SPI7 IP7 core7 project7                ////
////  http7://www7.opencores7.org7/projects7/spi7/                      ////
////                                                              ////
////  Author7(s):                                                  ////
////      - Simon7 Srot7 (simons7@opencores7.org7)                     ////
////                                                              ////
////  All additional7 information is avaliable7 in the Readme7.txt7   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright7 (C) 2002 Authors7                                   ////
////                                                              ////
//// This7 source7 file may be used and distributed7 without         ////
//// restriction7 provided that this copyright7 statement7 is not    ////
//// removed from the file and that any derivative7 work7 contains7  ////
//// the original copyright7 notice7 and the associated disclaimer7. ////
////                                                              ////
//// This7 source7 file is free software7; you can redistribute7 it   ////
//// and/or modify it under the terms7 of the GNU7 Lesser7 General7   ////
//// Public7 License7 as published7 by the Free7 Software7 Foundation7; ////
//// either7 version7 2.1 of the License7, or (at your7 option) any   ////
//// later7 version7.                                               ////
////                                                              ////
//// This7 source7 is distributed7 in the hope7 that it will be       ////
//// useful7, but WITHOUT7 ANY7 WARRANTY7; without even7 the implied7   ////
//// warranty7 of MERCHANTABILITY7 or FITNESS7 FOR7 A PARTICULAR7      ////
//// PURPOSE7.  See the GNU7 Lesser7 General7 Public7 License7 for more ////
//// details7.                                                     ////
////                                                              ////
//// You should have received7 a copy of the GNU7 Lesser7 General7    ////
//// Public7 License7 along7 with this source7; if not, download7 it   ////
//// from http7://www7.opencores7.org7/lgpl7.shtml7                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines7.v"
`include "timescale.v"

module spi_clgen7 (clk_in7, rst7, go7, enable, last_clk7, divider7, clk_out7, pos_edge7, neg_edge7); 

  parameter Tp7 = 1;
  
  input                            clk_in7;   // input clock7 (system clock7)
  input                            rst7;      // reset
  input                            enable;   // clock7 enable
  input                            go7;       // start transfer7
  input                            last_clk7; // last clock7
  input     [`SPI_DIVIDER_LEN7-1:0] divider7;  // clock7 divider7 (output clock7 is divided7 by this value)
  output                           clk_out7;  // output clock7
  output                           pos_edge7; // pulse7 marking7 positive7 edge of clk_out7
  output                           neg_edge7; // pulse7 marking7 negative edge of clk_out7
                            
  reg                              clk_out7;
  reg                              pos_edge7;
  reg                              neg_edge7;
                            
  reg       [`SPI_DIVIDER_LEN7-1:0] cnt;      // clock7 counter 
  wire                             cnt_zero7; // conter7 is equal7 to zero
  wire                             cnt_one7;  // conter7 is equal7 to one
  
  
  assign cnt_zero7 = cnt == {`SPI_DIVIDER_LEN7{1'b0}};
  assign cnt_one7  = cnt == {{`SPI_DIVIDER_LEN7-1{1'b0}}, 1'b1};
  
  // Counter7 counts7 half7 period7
  always @(posedge clk_in7 or posedge rst7)
  begin
    if(rst7)
      cnt <= #Tp7 {`SPI_DIVIDER_LEN7{1'b1}};
    else
      begin
        if(!enable || cnt_zero7)
          cnt <= #Tp7 divider7;
        else
          cnt <= #Tp7 cnt - {{`SPI_DIVIDER_LEN7-1{1'b0}}, 1'b1};
      end
  end
  
  // clk_out7 is asserted7 every7 other half7 period7
  always @(posedge clk_in7 or posedge rst7)
  begin
    if(rst7)
      clk_out7 <= #Tp7 1'b0;
    else
      clk_out7 <= #Tp7 (enable && cnt_zero7 && (!last_clk7 || clk_out7)) ? ~clk_out7 : clk_out7;
  end
   
  // Pos7 and neg7 edge signals7
  always @(posedge clk_in7 or posedge rst7)
  begin
    if(rst7)
      begin
        pos_edge7  <= #Tp7 1'b0;
        neg_edge7  <= #Tp7 1'b0;
      end
    else
      begin
        pos_edge7  <= #Tp7 (enable && !clk_out7 && cnt_one7) || (!(|divider7) && clk_out7) || (!(|divider7) && go7 && !enable);
        neg_edge7  <= #Tp7 (enable && clk_out7 && cnt_one7) || (!(|divider7) && !clk_out7 && enable);
      end
  end
endmodule
 
