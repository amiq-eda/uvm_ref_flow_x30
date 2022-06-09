//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_clgen15.v                                                 ////
////                                                              ////
////  This15 file is part of the SPI15 IP15 core15 project15                ////
////  http15://www15.opencores15.org15/projects15/spi15/                      ////
////                                                              ////
////  Author15(s):                                                  ////
////      - Simon15 Srot15 (simons15@opencores15.org15)                     ////
////                                                              ////
////  All additional15 information is avaliable15 in the Readme15.txt15   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright15 (C) 2002 Authors15                                   ////
////                                                              ////
//// This15 source15 file may be used and distributed15 without         ////
//// restriction15 provided that this copyright15 statement15 is not    ////
//// removed from the file and that any derivative15 work15 contains15  ////
//// the original copyright15 notice15 and the associated disclaimer15. ////
////                                                              ////
//// This15 source15 file is free software15; you can redistribute15 it   ////
//// and/or modify it under the terms15 of the GNU15 Lesser15 General15   ////
//// Public15 License15 as published15 by the Free15 Software15 Foundation15; ////
//// either15 version15 2.1 of the License15, or (at your15 option) any   ////
//// later15 version15.                                               ////
////                                                              ////
//// This15 source15 is distributed15 in the hope15 that it will be       ////
//// useful15, but WITHOUT15 ANY15 WARRANTY15; without even15 the implied15   ////
//// warranty15 of MERCHANTABILITY15 or FITNESS15 FOR15 A PARTICULAR15      ////
//// PURPOSE15.  See the GNU15 Lesser15 General15 Public15 License15 for more ////
//// details15.                                                     ////
////                                                              ////
//// You should have received15 a copy of the GNU15 Lesser15 General15    ////
//// Public15 License15 along15 with this source15; if not, download15 it   ////
//// from http15://www15.opencores15.org15/lgpl15.shtml15                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines15.v"
`include "timescale.v"

module spi_clgen15 (clk_in15, rst15, go15, enable, last_clk15, divider15, clk_out15, pos_edge15, neg_edge15); 

  parameter Tp15 = 1;
  
  input                            clk_in15;   // input clock15 (system clock15)
  input                            rst15;      // reset
  input                            enable;   // clock15 enable
  input                            go15;       // start transfer15
  input                            last_clk15; // last clock15
  input     [`SPI_DIVIDER_LEN15-1:0] divider15;  // clock15 divider15 (output clock15 is divided15 by this value)
  output                           clk_out15;  // output clock15
  output                           pos_edge15; // pulse15 marking15 positive15 edge of clk_out15
  output                           neg_edge15; // pulse15 marking15 negative edge of clk_out15
                            
  reg                              clk_out15;
  reg                              pos_edge15;
  reg                              neg_edge15;
                            
  reg       [`SPI_DIVIDER_LEN15-1:0] cnt;      // clock15 counter 
  wire                             cnt_zero15; // conter15 is equal15 to zero
  wire                             cnt_one15;  // conter15 is equal15 to one
  
  
  assign cnt_zero15 = cnt == {`SPI_DIVIDER_LEN15{1'b0}};
  assign cnt_one15  = cnt == {{`SPI_DIVIDER_LEN15-1{1'b0}}, 1'b1};
  
  // Counter15 counts15 half15 period15
  always @(posedge clk_in15 or posedge rst15)
  begin
    if(rst15)
      cnt <= #Tp15 {`SPI_DIVIDER_LEN15{1'b1}};
    else
      begin
        if(!enable || cnt_zero15)
          cnt <= #Tp15 divider15;
        else
          cnt <= #Tp15 cnt - {{`SPI_DIVIDER_LEN15-1{1'b0}}, 1'b1};
      end
  end
  
  // clk_out15 is asserted15 every15 other half15 period15
  always @(posedge clk_in15 or posedge rst15)
  begin
    if(rst15)
      clk_out15 <= #Tp15 1'b0;
    else
      clk_out15 <= #Tp15 (enable && cnt_zero15 && (!last_clk15 || clk_out15)) ? ~clk_out15 : clk_out15;
  end
   
  // Pos15 and neg15 edge signals15
  always @(posedge clk_in15 or posedge rst15)
  begin
    if(rst15)
      begin
        pos_edge15  <= #Tp15 1'b0;
        neg_edge15  <= #Tp15 1'b0;
      end
    else
      begin
        pos_edge15  <= #Tp15 (enable && !clk_out15 && cnt_one15) || (!(|divider15) && clk_out15) || (!(|divider15) && go15 && !enable);
        neg_edge15  <= #Tp15 (enable && clk_out15 && cnt_one15) || (!(|divider15) && !clk_out15 && enable);
      end
  end
endmodule
 
