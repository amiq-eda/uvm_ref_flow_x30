//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_clgen9.v                                                 ////
////                                                              ////
////  This9 file is part of the SPI9 IP9 core9 project9                ////
////  http9://www9.opencores9.org9/projects9/spi9/                      ////
////                                                              ////
////  Author9(s):                                                  ////
////      - Simon9 Srot9 (simons9@opencores9.org9)                     ////
////                                                              ////
////  All additional9 information is avaliable9 in the Readme9.txt9   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright9 (C) 2002 Authors9                                   ////
////                                                              ////
//// This9 source9 file may be used and distributed9 without         ////
//// restriction9 provided that this copyright9 statement9 is not    ////
//// removed from the file and that any derivative9 work9 contains9  ////
//// the original copyright9 notice9 and the associated disclaimer9. ////
////                                                              ////
//// This9 source9 file is free software9; you can redistribute9 it   ////
//// and/or modify it under the terms9 of the GNU9 Lesser9 General9   ////
//// Public9 License9 as published9 by the Free9 Software9 Foundation9; ////
//// either9 version9 2.1 of the License9, or (at your9 option) any   ////
//// later9 version9.                                               ////
////                                                              ////
//// This9 source9 is distributed9 in the hope9 that it will be       ////
//// useful9, but WITHOUT9 ANY9 WARRANTY9; without even9 the implied9   ////
//// warranty9 of MERCHANTABILITY9 or FITNESS9 FOR9 A PARTICULAR9      ////
//// PURPOSE9.  See the GNU9 Lesser9 General9 Public9 License9 for more ////
//// details9.                                                     ////
////                                                              ////
//// You should have received9 a copy of the GNU9 Lesser9 General9    ////
//// Public9 License9 along9 with this source9; if not, download9 it   ////
//// from http9://www9.opencores9.org9/lgpl9.shtml9                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines9.v"
`include "timescale.v"

module spi_clgen9 (clk_in9, rst9, go9, enable, last_clk9, divider9, clk_out9, pos_edge9, neg_edge9); 

  parameter Tp9 = 1;
  
  input                            clk_in9;   // input clock9 (system clock9)
  input                            rst9;      // reset
  input                            enable;   // clock9 enable
  input                            go9;       // start transfer9
  input                            last_clk9; // last clock9
  input     [`SPI_DIVIDER_LEN9-1:0] divider9;  // clock9 divider9 (output clock9 is divided9 by this value)
  output                           clk_out9;  // output clock9
  output                           pos_edge9; // pulse9 marking9 positive9 edge of clk_out9
  output                           neg_edge9; // pulse9 marking9 negative edge of clk_out9
                            
  reg                              clk_out9;
  reg                              pos_edge9;
  reg                              neg_edge9;
                            
  reg       [`SPI_DIVIDER_LEN9-1:0] cnt;      // clock9 counter 
  wire                             cnt_zero9; // conter9 is equal9 to zero
  wire                             cnt_one9;  // conter9 is equal9 to one
  
  
  assign cnt_zero9 = cnt == {`SPI_DIVIDER_LEN9{1'b0}};
  assign cnt_one9  = cnt == {{`SPI_DIVIDER_LEN9-1{1'b0}}, 1'b1};
  
  // Counter9 counts9 half9 period9
  always @(posedge clk_in9 or posedge rst9)
  begin
    if(rst9)
      cnt <= #Tp9 {`SPI_DIVIDER_LEN9{1'b1}};
    else
      begin
        if(!enable || cnt_zero9)
          cnt <= #Tp9 divider9;
        else
          cnt <= #Tp9 cnt - {{`SPI_DIVIDER_LEN9-1{1'b0}}, 1'b1};
      end
  end
  
  // clk_out9 is asserted9 every9 other half9 period9
  always @(posedge clk_in9 or posedge rst9)
  begin
    if(rst9)
      clk_out9 <= #Tp9 1'b0;
    else
      clk_out9 <= #Tp9 (enable && cnt_zero9 && (!last_clk9 || clk_out9)) ? ~clk_out9 : clk_out9;
  end
   
  // Pos9 and neg9 edge signals9
  always @(posedge clk_in9 or posedge rst9)
  begin
    if(rst9)
      begin
        pos_edge9  <= #Tp9 1'b0;
        neg_edge9  <= #Tp9 1'b0;
      end
    else
      begin
        pos_edge9  <= #Tp9 (enable && !clk_out9 && cnt_one9) || (!(|divider9) && clk_out9) || (!(|divider9) && go9 && !enable);
        neg_edge9  <= #Tp9 (enable && clk_out9 && cnt_one9) || (!(|divider9) && !clk_out9 && enable);
      end
  end
endmodule
 
