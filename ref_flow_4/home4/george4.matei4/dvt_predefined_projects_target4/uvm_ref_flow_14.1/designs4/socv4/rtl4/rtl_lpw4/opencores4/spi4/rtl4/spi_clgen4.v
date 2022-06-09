//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_clgen4.v                                                 ////
////                                                              ////
////  This4 file is part of the SPI4 IP4 core4 project4                ////
////  http4://www4.opencores4.org4/projects4/spi4/                      ////
////                                                              ////
////  Author4(s):                                                  ////
////      - Simon4 Srot4 (simons4@opencores4.org4)                     ////
////                                                              ////
////  All additional4 information is avaliable4 in the Readme4.txt4   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright4 (C) 2002 Authors4                                   ////
////                                                              ////
//// This4 source4 file may be used and distributed4 without         ////
//// restriction4 provided that this copyright4 statement4 is not    ////
//// removed from the file and that any derivative4 work4 contains4  ////
//// the original copyright4 notice4 and the associated disclaimer4. ////
////                                                              ////
//// This4 source4 file is free software4; you can redistribute4 it   ////
//// and/or modify it under the terms4 of the GNU4 Lesser4 General4   ////
//// Public4 License4 as published4 by the Free4 Software4 Foundation4; ////
//// either4 version4 2.1 of the License4, or (at your4 option) any   ////
//// later4 version4.                                               ////
////                                                              ////
//// This4 source4 is distributed4 in the hope4 that it will be       ////
//// useful4, but WITHOUT4 ANY4 WARRANTY4; without even4 the implied4   ////
//// warranty4 of MERCHANTABILITY4 or FITNESS4 FOR4 A PARTICULAR4      ////
//// PURPOSE4.  See the GNU4 Lesser4 General4 Public4 License4 for more ////
//// details4.                                                     ////
////                                                              ////
//// You should have received4 a copy of the GNU4 Lesser4 General4    ////
//// Public4 License4 along4 with this source4; if not, download4 it   ////
//// from http4://www4.opencores4.org4/lgpl4.shtml4                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines4.v"
`include "timescale.v"

module spi_clgen4 (clk_in4, rst4, go4, enable, last_clk4, divider4, clk_out4, pos_edge4, neg_edge4); 

  parameter Tp4 = 1;
  
  input                            clk_in4;   // input clock4 (system clock4)
  input                            rst4;      // reset
  input                            enable;   // clock4 enable
  input                            go4;       // start transfer4
  input                            last_clk4; // last clock4
  input     [`SPI_DIVIDER_LEN4-1:0] divider4;  // clock4 divider4 (output clock4 is divided4 by this value)
  output                           clk_out4;  // output clock4
  output                           pos_edge4; // pulse4 marking4 positive4 edge of clk_out4
  output                           neg_edge4; // pulse4 marking4 negative edge of clk_out4
                            
  reg                              clk_out4;
  reg                              pos_edge4;
  reg                              neg_edge4;
                            
  reg       [`SPI_DIVIDER_LEN4-1:0] cnt;      // clock4 counter 
  wire                             cnt_zero4; // conter4 is equal4 to zero
  wire                             cnt_one4;  // conter4 is equal4 to one
  
  
  assign cnt_zero4 = cnt == {`SPI_DIVIDER_LEN4{1'b0}};
  assign cnt_one4  = cnt == {{`SPI_DIVIDER_LEN4-1{1'b0}}, 1'b1};
  
  // Counter4 counts4 half4 period4
  always @(posedge clk_in4 or posedge rst4)
  begin
    if(rst4)
      cnt <= #Tp4 {`SPI_DIVIDER_LEN4{1'b1}};
    else
      begin
        if(!enable || cnt_zero4)
          cnt <= #Tp4 divider4;
        else
          cnt <= #Tp4 cnt - {{`SPI_DIVIDER_LEN4-1{1'b0}}, 1'b1};
      end
  end
  
  // clk_out4 is asserted4 every4 other half4 period4
  always @(posedge clk_in4 or posedge rst4)
  begin
    if(rst4)
      clk_out4 <= #Tp4 1'b0;
    else
      clk_out4 <= #Tp4 (enable && cnt_zero4 && (!last_clk4 || clk_out4)) ? ~clk_out4 : clk_out4;
  end
   
  // Pos4 and neg4 edge signals4
  always @(posedge clk_in4 or posedge rst4)
  begin
    if(rst4)
      begin
        pos_edge4  <= #Tp4 1'b0;
        neg_edge4  <= #Tp4 1'b0;
      end
    else
      begin
        pos_edge4  <= #Tp4 (enable && !clk_out4 && cnt_one4) || (!(|divider4) && clk_out4) || (!(|divider4) && go4 && !enable);
        neg_edge4  <= #Tp4 (enable && clk_out4 && cnt_one4) || (!(|divider4) && !clk_out4 && enable);
      end
  end
endmodule
 
