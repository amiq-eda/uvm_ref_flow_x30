//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_clgen10.v                                                 ////
////                                                              ////
////  This10 file is part of the SPI10 IP10 core10 project10                ////
////  http10://www10.opencores10.org10/projects10/spi10/                      ////
////                                                              ////
////  Author10(s):                                                  ////
////      - Simon10 Srot10 (simons10@opencores10.org10)                     ////
////                                                              ////
////  All additional10 information is avaliable10 in the Readme10.txt10   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright10 (C) 2002 Authors10                                   ////
////                                                              ////
//// This10 source10 file may be used and distributed10 without         ////
//// restriction10 provided that this copyright10 statement10 is not    ////
//// removed from the file and that any derivative10 work10 contains10  ////
//// the original copyright10 notice10 and the associated disclaimer10. ////
////                                                              ////
//// This10 source10 file is free software10; you can redistribute10 it   ////
//// and/or modify it under the terms10 of the GNU10 Lesser10 General10   ////
//// Public10 License10 as published10 by the Free10 Software10 Foundation10; ////
//// either10 version10 2.1 of the License10, or (at your10 option) any   ////
//// later10 version10.                                               ////
////                                                              ////
//// This10 source10 is distributed10 in the hope10 that it will be       ////
//// useful10, but WITHOUT10 ANY10 WARRANTY10; without even10 the implied10   ////
//// warranty10 of MERCHANTABILITY10 or FITNESS10 FOR10 A PARTICULAR10      ////
//// PURPOSE10.  See the GNU10 Lesser10 General10 Public10 License10 for more ////
//// details10.                                                     ////
////                                                              ////
//// You should have received10 a copy of the GNU10 Lesser10 General10    ////
//// Public10 License10 along10 with this source10; if not, download10 it   ////
//// from http10://www10.opencores10.org10/lgpl10.shtml10                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines10.v"
`include "timescale.v"

module spi_clgen10 (clk_in10, rst10, go10, enable, last_clk10, divider10, clk_out10, pos_edge10, neg_edge10); 

  parameter Tp10 = 1;
  
  input                            clk_in10;   // input clock10 (system clock10)
  input                            rst10;      // reset
  input                            enable;   // clock10 enable
  input                            go10;       // start transfer10
  input                            last_clk10; // last clock10
  input     [`SPI_DIVIDER_LEN10-1:0] divider10;  // clock10 divider10 (output clock10 is divided10 by this value)
  output                           clk_out10;  // output clock10
  output                           pos_edge10; // pulse10 marking10 positive10 edge of clk_out10
  output                           neg_edge10; // pulse10 marking10 negative edge of clk_out10
                            
  reg                              clk_out10;
  reg                              pos_edge10;
  reg                              neg_edge10;
                            
  reg       [`SPI_DIVIDER_LEN10-1:0] cnt;      // clock10 counter 
  wire                             cnt_zero10; // conter10 is equal10 to zero
  wire                             cnt_one10;  // conter10 is equal10 to one
  
  
  assign cnt_zero10 = cnt == {`SPI_DIVIDER_LEN10{1'b0}};
  assign cnt_one10  = cnt == {{`SPI_DIVIDER_LEN10-1{1'b0}}, 1'b1};
  
  // Counter10 counts10 half10 period10
  always @(posedge clk_in10 or posedge rst10)
  begin
    if(rst10)
      cnt <= #Tp10 {`SPI_DIVIDER_LEN10{1'b1}};
    else
      begin
        if(!enable || cnt_zero10)
          cnt <= #Tp10 divider10;
        else
          cnt <= #Tp10 cnt - {{`SPI_DIVIDER_LEN10-1{1'b0}}, 1'b1};
      end
  end
  
  // clk_out10 is asserted10 every10 other half10 period10
  always @(posedge clk_in10 or posedge rst10)
  begin
    if(rst10)
      clk_out10 <= #Tp10 1'b0;
    else
      clk_out10 <= #Tp10 (enable && cnt_zero10 && (!last_clk10 || clk_out10)) ? ~clk_out10 : clk_out10;
  end
   
  // Pos10 and neg10 edge signals10
  always @(posedge clk_in10 or posedge rst10)
  begin
    if(rst10)
      begin
        pos_edge10  <= #Tp10 1'b0;
        neg_edge10  <= #Tp10 1'b0;
      end
    else
      begin
        pos_edge10  <= #Tp10 (enable && !clk_out10 && cnt_one10) || (!(|divider10) && clk_out10) || (!(|divider10) && go10 && !enable);
        neg_edge10  <= #Tp10 (enable && clk_out10 && cnt_one10) || (!(|divider10) && !clk_out10 && enable);
      end
  end
endmodule
 
