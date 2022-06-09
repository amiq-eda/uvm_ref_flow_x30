//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_clgen18.v                                                 ////
////                                                              ////
////  This18 file is part of the SPI18 IP18 core18 project18                ////
////  http18://www18.opencores18.org18/projects18/spi18/                      ////
////                                                              ////
////  Author18(s):                                                  ////
////      - Simon18 Srot18 (simons18@opencores18.org18)                     ////
////                                                              ////
////  All additional18 information is avaliable18 in the Readme18.txt18   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright18 (C) 2002 Authors18                                   ////
////                                                              ////
//// This18 source18 file may be used and distributed18 without         ////
//// restriction18 provided that this copyright18 statement18 is not    ////
//// removed from the file and that any derivative18 work18 contains18  ////
//// the original copyright18 notice18 and the associated disclaimer18. ////
////                                                              ////
//// This18 source18 file is free software18; you can redistribute18 it   ////
//// and/or modify it under the terms18 of the GNU18 Lesser18 General18   ////
//// Public18 License18 as published18 by the Free18 Software18 Foundation18; ////
//// either18 version18 2.1 of the License18, or (at your18 option) any   ////
//// later18 version18.                                               ////
////                                                              ////
//// This18 source18 is distributed18 in the hope18 that it will be       ////
//// useful18, but WITHOUT18 ANY18 WARRANTY18; without even18 the implied18   ////
//// warranty18 of MERCHANTABILITY18 or FITNESS18 FOR18 A PARTICULAR18      ////
//// PURPOSE18.  See the GNU18 Lesser18 General18 Public18 License18 for more ////
//// details18.                                                     ////
////                                                              ////
//// You should have received18 a copy of the GNU18 Lesser18 General18    ////
//// Public18 License18 along18 with this source18; if not, download18 it   ////
//// from http18://www18.opencores18.org18/lgpl18.shtml18                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines18.v"
`include "timescale.v"

module spi_clgen18 (clk_in18, rst18, go18, enable, last_clk18, divider18, clk_out18, pos_edge18, neg_edge18); 

  parameter Tp18 = 1;
  
  input                            clk_in18;   // input clock18 (system clock18)
  input                            rst18;      // reset
  input                            enable;   // clock18 enable
  input                            go18;       // start transfer18
  input                            last_clk18; // last clock18
  input     [`SPI_DIVIDER_LEN18-1:0] divider18;  // clock18 divider18 (output clock18 is divided18 by this value)
  output                           clk_out18;  // output clock18
  output                           pos_edge18; // pulse18 marking18 positive18 edge of clk_out18
  output                           neg_edge18; // pulse18 marking18 negative edge of clk_out18
                            
  reg                              clk_out18;
  reg                              pos_edge18;
  reg                              neg_edge18;
                            
  reg       [`SPI_DIVIDER_LEN18-1:0] cnt;      // clock18 counter 
  wire                             cnt_zero18; // conter18 is equal18 to zero
  wire                             cnt_one18;  // conter18 is equal18 to one
  
  
  assign cnt_zero18 = cnt == {`SPI_DIVIDER_LEN18{1'b0}};
  assign cnt_one18  = cnt == {{`SPI_DIVIDER_LEN18-1{1'b0}}, 1'b1};
  
  // Counter18 counts18 half18 period18
  always @(posedge clk_in18 or posedge rst18)
  begin
    if(rst18)
      cnt <= #Tp18 {`SPI_DIVIDER_LEN18{1'b1}};
    else
      begin
        if(!enable || cnt_zero18)
          cnt <= #Tp18 divider18;
        else
          cnt <= #Tp18 cnt - {{`SPI_DIVIDER_LEN18-1{1'b0}}, 1'b1};
      end
  end
  
  // clk_out18 is asserted18 every18 other half18 period18
  always @(posedge clk_in18 or posedge rst18)
  begin
    if(rst18)
      clk_out18 <= #Tp18 1'b0;
    else
      clk_out18 <= #Tp18 (enable && cnt_zero18 && (!last_clk18 || clk_out18)) ? ~clk_out18 : clk_out18;
  end
   
  // Pos18 and neg18 edge signals18
  always @(posedge clk_in18 or posedge rst18)
  begin
    if(rst18)
      begin
        pos_edge18  <= #Tp18 1'b0;
        neg_edge18  <= #Tp18 1'b0;
      end
    else
      begin
        pos_edge18  <= #Tp18 (enable && !clk_out18 && cnt_one18) || (!(|divider18) && clk_out18) || (!(|divider18) && go18 && !enable);
        neg_edge18  <= #Tp18 (enable && clk_out18 && cnt_one18) || (!(|divider18) && !clk_out18 && enable);
      end
  end
endmodule
 
