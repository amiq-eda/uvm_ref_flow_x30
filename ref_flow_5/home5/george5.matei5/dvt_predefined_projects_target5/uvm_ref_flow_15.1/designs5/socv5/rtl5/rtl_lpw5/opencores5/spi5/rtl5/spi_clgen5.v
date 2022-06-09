//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_clgen5.v                                                 ////
////                                                              ////
////  This5 file is part of the SPI5 IP5 core5 project5                ////
////  http5://www5.opencores5.org5/projects5/spi5/                      ////
////                                                              ////
////  Author5(s):                                                  ////
////      - Simon5 Srot5 (simons5@opencores5.org5)                     ////
////                                                              ////
////  All additional5 information is avaliable5 in the Readme5.txt5   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright5 (C) 2002 Authors5                                   ////
////                                                              ////
//// This5 source5 file may be used and distributed5 without         ////
//// restriction5 provided that this copyright5 statement5 is not    ////
//// removed from the file and that any derivative5 work5 contains5  ////
//// the original copyright5 notice5 and the associated disclaimer5. ////
////                                                              ////
//// This5 source5 file is free software5; you can redistribute5 it   ////
//// and/or modify it under the terms5 of the GNU5 Lesser5 General5   ////
//// Public5 License5 as published5 by the Free5 Software5 Foundation5; ////
//// either5 version5 2.1 of the License5, or (at your5 option) any   ////
//// later5 version5.                                               ////
////                                                              ////
//// This5 source5 is distributed5 in the hope5 that it will be       ////
//// useful5, but WITHOUT5 ANY5 WARRANTY5; without even5 the implied5   ////
//// warranty5 of MERCHANTABILITY5 or FITNESS5 FOR5 A PARTICULAR5      ////
//// PURPOSE5.  See the GNU5 Lesser5 General5 Public5 License5 for more ////
//// details5.                                                     ////
////                                                              ////
//// You should have received5 a copy of the GNU5 Lesser5 General5    ////
//// Public5 License5 along5 with this source5; if not, download5 it   ////
//// from http5://www5.opencores5.org5/lgpl5.shtml5                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines5.v"
`include "timescale.v"

module spi_clgen5 (clk_in5, rst5, go5, enable, last_clk5, divider5, clk_out5, pos_edge5, neg_edge5); 

  parameter Tp5 = 1;
  
  input                            clk_in5;   // input clock5 (system clock5)
  input                            rst5;      // reset
  input                            enable;   // clock5 enable
  input                            go5;       // start transfer5
  input                            last_clk5; // last clock5
  input     [`SPI_DIVIDER_LEN5-1:0] divider5;  // clock5 divider5 (output clock5 is divided5 by this value)
  output                           clk_out5;  // output clock5
  output                           pos_edge5; // pulse5 marking5 positive5 edge of clk_out5
  output                           neg_edge5; // pulse5 marking5 negative edge of clk_out5
                            
  reg                              clk_out5;
  reg                              pos_edge5;
  reg                              neg_edge5;
                            
  reg       [`SPI_DIVIDER_LEN5-1:0] cnt;      // clock5 counter 
  wire                             cnt_zero5; // conter5 is equal5 to zero
  wire                             cnt_one5;  // conter5 is equal5 to one
  
  
  assign cnt_zero5 = cnt == {`SPI_DIVIDER_LEN5{1'b0}};
  assign cnt_one5  = cnt == {{`SPI_DIVIDER_LEN5-1{1'b0}}, 1'b1};
  
  // Counter5 counts5 half5 period5
  always @(posedge clk_in5 or posedge rst5)
  begin
    if(rst5)
      cnt <= #Tp5 {`SPI_DIVIDER_LEN5{1'b1}};
    else
      begin
        if(!enable || cnt_zero5)
          cnt <= #Tp5 divider5;
        else
          cnt <= #Tp5 cnt - {{`SPI_DIVIDER_LEN5-1{1'b0}}, 1'b1};
      end
  end
  
  // clk_out5 is asserted5 every5 other half5 period5
  always @(posedge clk_in5 or posedge rst5)
  begin
    if(rst5)
      clk_out5 <= #Tp5 1'b0;
    else
      clk_out5 <= #Tp5 (enable && cnt_zero5 && (!last_clk5 || clk_out5)) ? ~clk_out5 : clk_out5;
  end
   
  // Pos5 and neg5 edge signals5
  always @(posedge clk_in5 or posedge rst5)
  begin
    if(rst5)
      begin
        pos_edge5  <= #Tp5 1'b0;
        neg_edge5  <= #Tp5 1'b0;
      end
    else
      begin
        pos_edge5  <= #Tp5 (enable && !clk_out5 && cnt_one5) || (!(|divider5) && clk_out5) || (!(|divider5) && go5 && !enable);
        neg_edge5  <= #Tp5 (enable && clk_out5 && cnt_one5) || (!(|divider5) && !clk_out5 && enable);
      end
  end
endmodule
 
