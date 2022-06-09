//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_clgen17.v                                                 ////
////                                                              ////
////  This17 file is part of the SPI17 IP17 core17 project17                ////
////  http17://www17.opencores17.org17/projects17/spi17/                      ////
////                                                              ////
////  Author17(s):                                                  ////
////      - Simon17 Srot17 (simons17@opencores17.org17)                     ////
////                                                              ////
////  All additional17 information is avaliable17 in the Readme17.txt17   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright17 (C) 2002 Authors17                                   ////
////                                                              ////
//// This17 source17 file may be used and distributed17 without         ////
//// restriction17 provided that this copyright17 statement17 is not    ////
//// removed from the file and that any derivative17 work17 contains17  ////
//// the original copyright17 notice17 and the associated disclaimer17. ////
////                                                              ////
//// This17 source17 file is free software17; you can redistribute17 it   ////
//// and/or modify it under the terms17 of the GNU17 Lesser17 General17   ////
//// Public17 License17 as published17 by the Free17 Software17 Foundation17; ////
//// either17 version17 2.1 of the License17, or (at your17 option) any   ////
//// later17 version17.                                               ////
////                                                              ////
//// This17 source17 is distributed17 in the hope17 that it will be       ////
//// useful17, but WITHOUT17 ANY17 WARRANTY17; without even17 the implied17   ////
//// warranty17 of MERCHANTABILITY17 or FITNESS17 FOR17 A PARTICULAR17      ////
//// PURPOSE17.  See the GNU17 Lesser17 General17 Public17 License17 for more ////
//// details17.                                                     ////
////                                                              ////
//// You should have received17 a copy of the GNU17 Lesser17 General17    ////
//// Public17 License17 along17 with this source17; if not, download17 it   ////
//// from http17://www17.opencores17.org17/lgpl17.shtml17                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines17.v"
`include "timescale.v"

module spi_clgen17 (clk_in17, rst17, go17, enable, last_clk17, divider17, clk_out17, pos_edge17, neg_edge17); 

  parameter Tp17 = 1;
  
  input                            clk_in17;   // input clock17 (system clock17)
  input                            rst17;      // reset
  input                            enable;   // clock17 enable
  input                            go17;       // start transfer17
  input                            last_clk17; // last clock17
  input     [`SPI_DIVIDER_LEN17-1:0] divider17;  // clock17 divider17 (output clock17 is divided17 by this value)
  output                           clk_out17;  // output clock17
  output                           pos_edge17; // pulse17 marking17 positive17 edge of clk_out17
  output                           neg_edge17; // pulse17 marking17 negative edge of clk_out17
                            
  reg                              clk_out17;
  reg                              pos_edge17;
  reg                              neg_edge17;
                            
  reg       [`SPI_DIVIDER_LEN17-1:0] cnt;      // clock17 counter 
  wire                             cnt_zero17; // conter17 is equal17 to zero
  wire                             cnt_one17;  // conter17 is equal17 to one
  
  
  assign cnt_zero17 = cnt == {`SPI_DIVIDER_LEN17{1'b0}};
  assign cnt_one17  = cnt == {{`SPI_DIVIDER_LEN17-1{1'b0}}, 1'b1};
  
  // Counter17 counts17 half17 period17
  always @(posedge clk_in17 or posedge rst17)
  begin
    if(rst17)
      cnt <= #Tp17 {`SPI_DIVIDER_LEN17{1'b1}};
    else
      begin
        if(!enable || cnt_zero17)
          cnt <= #Tp17 divider17;
        else
          cnt <= #Tp17 cnt - {{`SPI_DIVIDER_LEN17-1{1'b0}}, 1'b1};
      end
  end
  
  // clk_out17 is asserted17 every17 other half17 period17
  always @(posedge clk_in17 or posedge rst17)
  begin
    if(rst17)
      clk_out17 <= #Tp17 1'b0;
    else
      clk_out17 <= #Tp17 (enable && cnt_zero17 && (!last_clk17 || clk_out17)) ? ~clk_out17 : clk_out17;
  end
   
  // Pos17 and neg17 edge signals17
  always @(posedge clk_in17 or posedge rst17)
  begin
    if(rst17)
      begin
        pos_edge17  <= #Tp17 1'b0;
        neg_edge17  <= #Tp17 1'b0;
      end
    else
      begin
        pos_edge17  <= #Tp17 (enable && !clk_out17 && cnt_one17) || (!(|divider17) && clk_out17) || (!(|divider17) && go17 && !enable);
        neg_edge17  <= #Tp17 (enable && clk_out17 && cnt_one17) || (!(|divider17) && !clk_out17 && enable);
      end
  end
endmodule
 
