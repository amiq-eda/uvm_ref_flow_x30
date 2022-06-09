//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_clgen14.v                                                 ////
////                                                              ////
////  This14 file is part of the SPI14 IP14 core14 project14                ////
////  http14://www14.opencores14.org14/projects14/spi14/                      ////
////                                                              ////
////  Author14(s):                                                  ////
////      - Simon14 Srot14 (simons14@opencores14.org14)                     ////
////                                                              ////
////  All additional14 information is avaliable14 in the Readme14.txt14   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright14 (C) 2002 Authors14                                   ////
////                                                              ////
//// This14 source14 file may be used and distributed14 without         ////
//// restriction14 provided that this copyright14 statement14 is not    ////
//// removed from the file and that any derivative14 work14 contains14  ////
//// the original copyright14 notice14 and the associated disclaimer14. ////
////                                                              ////
//// This14 source14 file is free software14; you can redistribute14 it   ////
//// and/or modify it under the terms14 of the GNU14 Lesser14 General14   ////
//// Public14 License14 as published14 by the Free14 Software14 Foundation14; ////
//// either14 version14 2.1 of the License14, or (at your14 option) any   ////
//// later14 version14.                                               ////
////                                                              ////
//// This14 source14 is distributed14 in the hope14 that it will be       ////
//// useful14, but WITHOUT14 ANY14 WARRANTY14; without even14 the implied14   ////
//// warranty14 of MERCHANTABILITY14 or FITNESS14 FOR14 A PARTICULAR14      ////
//// PURPOSE14.  See the GNU14 Lesser14 General14 Public14 License14 for more ////
//// details14.                                                     ////
////                                                              ////
//// You should have received14 a copy of the GNU14 Lesser14 General14    ////
//// Public14 License14 along14 with this source14; if not, download14 it   ////
//// from http14://www14.opencores14.org14/lgpl14.shtml14                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines14.v"
`include "timescale.v"

module spi_clgen14 (clk_in14, rst14, go14, enable, last_clk14, divider14, clk_out14, pos_edge14, neg_edge14); 

  parameter Tp14 = 1;
  
  input                            clk_in14;   // input clock14 (system clock14)
  input                            rst14;      // reset
  input                            enable;   // clock14 enable
  input                            go14;       // start transfer14
  input                            last_clk14; // last clock14
  input     [`SPI_DIVIDER_LEN14-1:0] divider14;  // clock14 divider14 (output clock14 is divided14 by this value)
  output                           clk_out14;  // output clock14
  output                           pos_edge14; // pulse14 marking14 positive14 edge of clk_out14
  output                           neg_edge14; // pulse14 marking14 negative edge of clk_out14
                            
  reg                              clk_out14;
  reg                              pos_edge14;
  reg                              neg_edge14;
                            
  reg       [`SPI_DIVIDER_LEN14-1:0] cnt;      // clock14 counter 
  wire                             cnt_zero14; // conter14 is equal14 to zero
  wire                             cnt_one14;  // conter14 is equal14 to one
  
  
  assign cnt_zero14 = cnt == {`SPI_DIVIDER_LEN14{1'b0}};
  assign cnt_one14  = cnt == {{`SPI_DIVIDER_LEN14-1{1'b0}}, 1'b1};
  
  // Counter14 counts14 half14 period14
  always @(posedge clk_in14 or posedge rst14)
  begin
    if(rst14)
      cnt <= #Tp14 {`SPI_DIVIDER_LEN14{1'b1}};
    else
      begin
        if(!enable || cnt_zero14)
          cnt <= #Tp14 divider14;
        else
          cnt <= #Tp14 cnt - {{`SPI_DIVIDER_LEN14-1{1'b0}}, 1'b1};
      end
  end
  
  // clk_out14 is asserted14 every14 other half14 period14
  always @(posedge clk_in14 or posedge rst14)
  begin
    if(rst14)
      clk_out14 <= #Tp14 1'b0;
    else
      clk_out14 <= #Tp14 (enable && cnt_zero14 && (!last_clk14 || clk_out14)) ? ~clk_out14 : clk_out14;
  end
   
  // Pos14 and neg14 edge signals14
  always @(posedge clk_in14 or posedge rst14)
  begin
    if(rst14)
      begin
        pos_edge14  <= #Tp14 1'b0;
        neg_edge14  <= #Tp14 1'b0;
      end
    else
      begin
        pos_edge14  <= #Tp14 (enable && !clk_out14 && cnt_one14) || (!(|divider14) && clk_out14) || (!(|divider14) && go14 && !enable);
        neg_edge14  <= #Tp14 (enable && clk_out14 && cnt_one14) || (!(|divider14) && !clk_out14 && enable);
      end
  end
endmodule
 
