//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_clgen3.v                                                 ////
////                                                              ////
////  This3 file is part of the SPI3 IP3 core3 project3                ////
////  http3://www3.opencores3.org3/projects3/spi3/                      ////
////                                                              ////
////  Author3(s):                                                  ////
////      - Simon3 Srot3 (simons3@opencores3.org3)                     ////
////                                                              ////
////  All additional3 information is avaliable3 in the Readme3.txt3   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright3 (C) 2002 Authors3                                   ////
////                                                              ////
//// This3 source3 file may be used and distributed3 without         ////
//// restriction3 provided that this copyright3 statement3 is not    ////
//// removed from the file and that any derivative3 work3 contains3  ////
//// the original copyright3 notice3 and the associated disclaimer3. ////
////                                                              ////
//// This3 source3 file is free software3; you can redistribute3 it   ////
//// and/or modify it under the terms3 of the GNU3 Lesser3 General3   ////
//// Public3 License3 as published3 by the Free3 Software3 Foundation3; ////
//// either3 version3 2.1 of the License3, or (at your3 option) any   ////
//// later3 version3.                                               ////
////                                                              ////
//// This3 source3 is distributed3 in the hope3 that it will be       ////
//// useful3, but WITHOUT3 ANY3 WARRANTY3; without even3 the implied3   ////
//// warranty3 of MERCHANTABILITY3 or FITNESS3 FOR3 A PARTICULAR3      ////
//// PURPOSE3.  See the GNU3 Lesser3 General3 Public3 License3 for more ////
//// details3.                                                     ////
////                                                              ////
//// You should have received3 a copy of the GNU3 Lesser3 General3    ////
//// Public3 License3 along3 with this source3; if not, download3 it   ////
//// from http3://www3.opencores3.org3/lgpl3.shtml3                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines3.v"
`include "timescale.v"

module spi_clgen3 (clk_in3, rst3, go3, enable, last_clk3, divider3, clk_out3, pos_edge3, neg_edge3); 

  parameter Tp3 = 1;
  
  input                            clk_in3;   // input clock3 (system clock3)
  input                            rst3;      // reset
  input                            enable;   // clock3 enable
  input                            go3;       // start transfer3
  input                            last_clk3; // last clock3
  input     [`SPI_DIVIDER_LEN3-1:0] divider3;  // clock3 divider3 (output clock3 is divided3 by this value)
  output                           clk_out3;  // output clock3
  output                           pos_edge3; // pulse3 marking3 positive3 edge of clk_out3
  output                           neg_edge3; // pulse3 marking3 negative edge of clk_out3
                            
  reg                              clk_out3;
  reg                              pos_edge3;
  reg                              neg_edge3;
                            
  reg       [`SPI_DIVIDER_LEN3-1:0] cnt;      // clock3 counter 
  wire                             cnt_zero3; // conter3 is equal3 to zero
  wire                             cnt_one3;  // conter3 is equal3 to one
  
  
  assign cnt_zero3 = cnt == {`SPI_DIVIDER_LEN3{1'b0}};
  assign cnt_one3  = cnt == {{`SPI_DIVIDER_LEN3-1{1'b0}}, 1'b1};
  
  // Counter3 counts3 half3 period3
  always @(posedge clk_in3 or posedge rst3)
  begin
    if(rst3)
      cnt <= #Tp3 {`SPI_DIVIDER_LEN3{1'b1}};
    else
      begin
        if(!enable || cnt_zero3)
          cnt <= #Tp3 divider3;
        else
          cnt <= #Tp3 cnt - {{`SPI_DIVIDER_LEN3-1{1'b0}}, 1'b1};
      end
  end
  
  // clk_out3 is asserted3 every3 other half3 period3
  always @(posedge clk_in3 or posedge rst3)
  begin
    if(rst3)
      clk_out3 <= #Tp3 1'b0;
    else
      clk_out3 <= #Tp3 (enable && cnt_zero3 && (!last_clk3 || clk_out3)) ? ~clk_out3 : clk_out3;
  end
   
  // Pos3 and neg3 edge signals3
  always @(posedge clk_in3 or posedge rst3)
  begin
    if(rst3)
      begin
        pos_edge3  <= #Tp3 1'b0;
        neg_edge3  <= #Tp3 1'b0;
      end
    else
      begin
        pos_edge3  <= #Tp3 (enable && !clk_out3 && cnt_one3) || (!(|divider3) && clk_out3) || (!(|divider3) && go3 && !enable);
        neg_edge3  <= #Tp3 (enable && clk_out3 && cnt_one3) || (!(|divider3) && !clk_out3 && enable);
      end
  end
endmodule
 
