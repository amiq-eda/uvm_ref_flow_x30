//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_clgen21.v                                                 ////
////                                                              ////
////  This21 file is part of the SPI21 IP21 core21 project21                ////
////  http21://www21.opencores21.org21/projects21/spi21/                      ////
////                                                              ////
////  Author21(s):                                                  ////
////      - Simon21 Srot21 (simons21@opencores21.org21)                     ////
////                                                              ////
////  All additional21 information is avaliable21 in the Readme21.txt21   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright21 (C) 2002 Authors21                                   ////
////                                                              ////
//// This21 source21 file may be used and distributed21 without         ////
//// restriction21 provided that this copyright21 statement21 is not    ////
//// removed from the file and that any derivative21 work21 contains21  ////
//// the original copyright21 notice21 and the associated disclaimer21. ////
////                                                              ////
//// This21 source21 file is free software21; you can redistribute21 it   ////
//// and/or modify it under the terms21 of the GNU21 Lesser21 General21   ////
//// Public21 License21 as published21 by the Free21 Software21 Foundation21; ////
//// either21 version21 2.1 of the License21, or (at your21 option) any   ////
//// later21 version21.                                               ////
////                                                              ////
//// This21 source21 is distributed21 in the hope21 that it will be       ////
//// useful21, but WITHOUT21 ANY21 WARRANTY21; without even21 the implied21   ////
//// warranty21 of MERCHANTABILITY21 or FITNESS21 FOR21 A PARTICULAR21      ////
//// PURPOSE21.  See the GNU21 Lesser21 General21 Public21 License21 for more ////
//// details21.                                                     ////
////                                                              ////
//// You should have received21 a copy of the GNU21 Lesser21 General21    ////
//// Public21 License21 along21 with this source21; if not, download21 it   ////
//// from http21://www21.opencores21.org21/lgpl21.shtml21                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines21.v"
`include "timescale.v"

module spi_clgen21 (clk_in21, rst21, go21, enable, last_clk21, divider21, clk_out21, pos_edge21, neg_edge21); 

  parameter Tp21 = 1;
  
  input                            clk_in21;   // input clock21 (system clock21)
  input                            rst21;      // reset
  input                            enable;   // clock21 enable
  input                            go21;       // start transfer21
  input                            last_clk21; // last clock21
  input     [`SPI_DIVIDER_LEN21-1:0] divider21;  // clock21 divider21 (output clock21 is divided21 by this value)
  output                           clk_out21;  // output clock21
  output                           pos_edge21; // pulse21 marking21 positive21 edge of clk_out21
  output                           neg_edge21; // pulse21 marking21 negative edge of clk_out21
                            
  reg                              clk_out21;
  reg                              pos_edge21;
  reg                              neg_edge21;
                            
  reg       [`SPI_DIVIDER_LEN21-1:0] cnt;      // clock21 counter 
  wire                             cnt_zero21; // conter21 is equal21 to zero
  wire                             cnt_one21;  // conter21 is equal21 to one
  
  
  assign cnt_zero21 = cnt == {`SPI_DIVIDER_LEN21{1'b0}};
  assign cnt_one21  = cnt == {{`SPI_DIVIDER_LEN21-1{1'b0}}, 1'b1};
  
  // Counter21 counts21 half21 period21
  always @(posedge clk_in21 or posedge rst21)
  begin
    if(rst21)
      cnt <= #Tp21 {`SPI_DIVIDER_LEN21{1'b1}};
    else
      begin
        if(!enable || cnt_zero21)
          cnt <= #Tp21 divider21;
        else
          cnt <= #Tp21 cnt - {{`SPI_DIVIDER_LEN21-1{1'b0}}, 1'b1};
      end
  end
  
  // clk_out21 is asserted21 every21 other half21 period21
  always @(posedge clk_in21 or posedge rst21)
  begin
    if(rst21)
      clk_out21 <= #Tp21 1'b0;
    else
      clk_out21 <= #Tp21 (enable && cnt_zero21 && (!last_clk21 || clk_out21)) ? ~clk_out21 : clk_out21;
  end
   
  // Pos21 and neg21 edge signals21
  always @(posedge clk_in21 or posedge rst21)
  begin
    if(rst21)
      begin
        pos_edge21  <= #Tp21 1'b0;
        neg_edge21  <= #Tp21 1'b0;
      end
    else
      begin
        pos_edge21  <= #Tp21 (enable && !clk_out21 && cnt_one21) || (!(|divider21) && clk_out21) || (!(|divider21) && go21 && !enable);
        neg_edge21  <= #Tp21 (enable && clk_out21 && cnt_one21) || (!(|divider21) && !clk_out21 && enable);
      end
  end
endmodule
 
