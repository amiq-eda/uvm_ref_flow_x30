//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_clgen27.v                                                 ////
////                                                              ////
////  This27 file is part of the SPI27 IP27 core27 project27                ////
////  http27://www27.opencores27.org27/projects27/spi27/                      ////
////                                                              ////
////  Author27(s):                                                  ////
////      - Simon27 Srot27 (simons27@opencores27.org27)                     ////
////                                                              ////
////  All additional27 information is avaliable27 in the Readme27.txt27   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright27 (C) 2002 Authors27                                   ////
////                                                              ////
//// This27 source27 file may be used and distributed27 without         ////
//// restriction27 provided that this copyright27 statement27 is not    ////
//// removed from the file and that any derivative27 work27 contains27  ////
//// the original copyright27 notice27 and the associated disclaimer27. ////
////                                                              ////
//// This27 source27 file is free software27; you can redistribute27 it   ////
//// and/or modify it under the terms27 of the GNU27 Lesser27 General27   ////
//// Public27 License27 as published27 by the Free27 Software27 Foundation27; ////
//// either27 version27 2.1 of the License27, or (at your27 option) any   ////
//// later27 version27.                                               ////
////                                                              ////
//// This27 source27 is distributed27 in the hope27 that it will be       ////
//// useful27, but WITHOUT27 ANY27 WARRANTY27; without even27 the implied27   ////
//// warranty27 of MERCHANTABILITY27 or FITNESS27 FOR27 A PARTICULAR27      ////
//// PURPOSE27.  See the GNU27 Lesser27 General27 Public27 License27 for more ////
//// details27.                                                     ////
////                                                              ////
//// You should have received27 a copy of the GNU27 Lesser27 General27    ////
//// Public27 License27 along27 with this source27; if not, download27 it   ////
//// from http27://www27.opencores27.org27/lgpl27.shtml27                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines27.v"
`include "timescale.v"

module spi_clgen27 (clk_in27, rst27, go27, enable, last_clk27, divider27, clk_out27, pos_edge27, neg_edge27); 

  parameter Tp27 = 1;
  
  input                            clk_in27;   // input clock27 (system clock27)
  input                            rst27;      // reset
  input                            enable;   // clock27 enable
  input                            go27;       // start transfer27
  input                            last_clk27; // last clock27
  input     [`SPI_DIVIDER_LEN27-1:0] divider27;  // clock27 divider27 (output clock27 is divided27 by this value)
  output                           clk_out27;  // output clock27
  output                           pos_edge27; // pulse27 marking27 positive27 edge of clk_out27
  output                           neg_edge27; // pulse27 marking27 negative edge of clk_out27
                            
  reg                              clk_out27;
  reg                              pos_edge27;
  reg                              neg_edge27;
                            
  reg       [`SPI_DIVIDER_LEN27-1:0] cnt;      // clock27 counter 
  wire                             cnt_zero27; // conter27 is equal27 to zero
  wire                             cnt_one27;  // conter27 is equal27 to one
  
  
  assign cnt_zero27 = cnt == {`SPI_DIVIDER_LEN27{1'b0}};
  assign cnt_one27  = cnt == {{`SPI_DIVIDER_LEN27-1{1'b0}}, 1'b1};
  
  // Counter27 counts27 half27 period27
  always @(posedge clk_in27 or posedge rst27)
  begin
    if(rst27)
      cnt <= #Tp27 {`SPI_DIVIDER_LEN27{1'b1}};
    else
      begin
        if(!enable || cnt_zero27)
          cnt <= #Tp27 divider27;
        else
          cnt <= #Tp27 cnt - {{`SPI_DIVIDER_LEN27-1{1'b0}}, 1'b1};
      end
  end
  
  // clk_out27 is asserted27 every27 other half27 period27
  always @(posedge clk_in27 or posedge rst27)
  begin
    if(rst27)
      clk_out27 <= #Tp27 1'b0;
    else
      clk_out27 <= #Tp27 (enable && cnt_zero27 && (!last_clk27 || clk_out27)) ? ~clk_out27 : clk_out27;
  end
   
  // Pos27 and neg27 edge signals27
  always @(posedge clk_in27 or posedge rst27)
  begin
    if(rst27)
      begin
        pos_edge27  <= #Tp27 1'b0;
        neg_edge27  <= #Tp27 1'b0;
      end
    else
      begin
        pos_edge27  <= #Tp27 (enable && !clk_out27 && cnt_one27) || (!(|divider27) && clk_out27) || (!(|divider27) && go27 && !enable);
        neg_edge27  <= #Tp27 (enable && clk_out27 && cnt_one27) || (!(|divider27) && !clk_out27 && enable);
      end
  end
endmodule
 
