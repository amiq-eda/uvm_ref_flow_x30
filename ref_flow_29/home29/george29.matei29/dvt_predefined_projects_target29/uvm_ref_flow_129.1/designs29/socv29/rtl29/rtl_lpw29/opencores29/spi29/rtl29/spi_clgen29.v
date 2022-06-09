//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_clgen29.v                                                 ////
////                                                              ////
////  This29 file is part of the SPI29 IP29 core29 project29                ////
////  http29://www29.opencores29.org29/projects29/spi29/                      ////
////                                                              ////
////  Author29(s):                                                  ////
////      - Simon29 Srot29 (simons29@opencores29.org29)                     ////
////                                                              ////
////  All additional29 information is avaliable29 in the Readme29.txt29   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright29 (C) 2002 Authors29                                   ////
////                                                              ////
//// This29 source29 file may be used and distributed29 without         ////
//// restriction29 provided that this copyright29 statement29 is not    ////
//// removed from the file and that any derivative29 work29 contains29  ////
//// the original copyright29 notice29 and the associated disclaimer29. ////
////                                                              ////
//// This29 source29 file is free software29; you can redistribute29 it   ////
//// and/or modify it under the terms29 of the GNU29 Lesser29 General29   ////
//// Public29 License29 as published29 by the Free29 Software29 Foundation29; ////
//// either29 version29 2.1 of the License29, or (at your29 option) any   ////
//// later29 version29.                                               ////
////                                                              ////
//// This29 source29 is distributed29 in the hope29 that it will be       ////
//// useful29, but WITHOUT29 ANY29 WARRANTY29; without even29 the implied29   ////
//// warranty29 of MERCHANTABILITY29 or FITNESS29 FOR29 A PARTICULAR29      ////
//// PURPOSE29.  See the GNU29 Lesser29 General29 Public29 License29 for more ////
//// details29.                                                     ////
////                                                              ////
//// You should have received29 a copy of the GNU29 Lesser29 General29    ////
//// Public29 License29 along29 with this source29; if not, download29 it   ////
//// from http29://www29.opencores29.org29/lgpl29.shtml29                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines29.v"
`include "timescale.v"

module spi_clgen29 (clk_in29, rst29, go29, enable, last_clk29, divider29, clk_out29, pos_edge29, neg_edge29); 

  parameter Tp29 = 1;
  
  input                            clk_in29;   // input clock29 (system clock29)
  input                            rst29;      // reset
  input                            enable;   // clock29 enable
  input                            go29;       // start transfer29
  input                            last_clk29; // last clock29
  input     [`SPI_DIVIDER_LEN29-1:0] divider29;  // clock29 divider29 (output clock29 is divided29 by this value)
  output                           clk_out29;  // output clock29
  output                           pos_edge29; // pulse29 marking29 positive29 edge of clk_out29
  output                           neg_edge29; // pulse29 marking29 negative edge of clk_out29
                            
  reg                              clk_out29;
  reg                              pos_edge29;
  reg                              neg_edge29;
                            
  reg       [`SPI_DIVIDER_LEN29-1:0] cnt;      // clock29 counter 
  wire                             cnt_zero29; // conter29 is equal29 to zero
  wire                             cnt_one29;  // conter29 is equal29 to one
  
  
  assign cnt_zero29 = cnt == {`SPI_DIVIDER_LEN29{1'b0}};
  assign cnt_one29  = cnt == {{`SPI_DIVIDER_LEN29-1{1'b0}}, 1'b1};
  
  // Counter29 counts29 half29 period29
  always @(posedge clk_in29 or posedge rst29)
  begin
    if(rst29)
      cnt <= #Tp29 {`SPI_DIVIDER_LEN29{1'b1}};
    else
      begin
        if(!enable || cnt_zero29)
          cnt <= #Tp29 divider29;
        else
          cnt <= #Tp29 cnt - {{`SPI_DIVIDER_LEN29-1{1'b0}}, 1'b1};
      end
  end
  
  // clk_out29 is asserted29 every29 other half29 period29
  always @(posedge clk_in29 or posedge rst29)
  begin
    if(rst29)
      clk_out29 <= #Tp29 1'b0;
    else
      clk_out29 <= #Tp29 (enable && cnt_zero29 && (!last_clk29 || clk_out29)) ? ~clk_out29 : clk_out29;
  end
   
  // Pos29 and neg29 edge signals29
  always @(posedge clk_in29 or posedge rst29)
  begin
    if(rst29)
      begin
        pos_edge29  <= #Tp29 1'b0;
        neg_edge29  <= #Tp29 1'b0;
      end
    else
      begin
        pos_edge29  <= #Tp29 (enable && !clk_out29 && cnt_one29) || (!(|divider29) && clk_out29) || (!(|divider29) && go29 && !enable);
        neg_edge29  <= #Tp29 (enable && clk_out29 && cnt_one29) || (!(|divider29) && !clk_out29 && enable);
      end
  end
endmodule
 
