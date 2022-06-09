//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_clgen6.v                                                 ////
////                                                              ////
////  This6 file is part of the SPI6 IP6 core6 project6                ////
////  http6://www6.opencores6.org6/projects6/spi6/                      ////
////                                                              ////
////  Author6(s):                                                  ////
////      - Simon6 Srot6 (simons6@opencores6.org6)                     ////
////                                                              ////
////  All additional6 information is avaliable6 in the Readme6.txt6   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright6 (C) 2002 Authors6                                   ////
////                                                              ////
//// This6 source6 file may be used and distributed6 without         ////
//// restriction6 provided that this copyright6 statement6 is not    ////
//// removed from the file and that any derivative6 work6 contains6  ////
//// the original copyright6 notice6 and the associated disclaimer6. ////
////                                                              ////
//// This6 source6 file is free software6; you can redistribute6 it   ////
//// and/or modify it under the terms6 of the GNU6 Lesser6 General6   ////
//// Public6 License6 as published6 by the Free6 Software6 Foundation6; ////
//// either6 version6 2.1 of the License6, or (at your6 option) any   ////
//// later6 version6.                                               ////
////                                                              ////
//// This6 source6 is distributed6 in the hope6 that it will be       ////
//// useful6, but WITHOUT6 ANY6 WARRANTY6; without even6 the implied6   ////
//// warranty6 of MERCHANTABILITY6 or FITNESS6 FOR6 A PARTICULAR6      ////
//// PURPOSE6.  See the GNU6 Lesser6 General6 Public6 License6 for more ////
//// details6.                                                     ////
////                                                              ////
//// You should have received6 a copy of the GNU6 Lesser6 General6    ////
//// Public6 License6 along6 with this source6; if not, download6 it   ////
//// from http6://www6.opencores6.org6/lgpl6.shtml6                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines6.v"
`include "timescale.v"

module spi_clgen6 (clk_in6, rst6, go6, enable, last_clk6, divider6, clk_out6, pos_edge6, neg_edge6); 

  parameter Tp6 = 1;
  
  input                            clk_in6;   // input clock6 (system clock6)
  input                            rst6;      // reset
  input                            enable;   // clock6 enable
  input                            go6;       // start transfer6
  input                            last_clk6; // last clock6
  input     [`SPI_DIVIDER_LEN6-1:0] divider6;  // clock6 divider6 (output clock6 is divided6 by this value)
  output                           clk_out6;  // output clock6
  output                           pos_edge6; // pulse6 marking6 positive6 edge of clk_out6
  output                           neg_edge6; // pulse6 marking6 negative edge of clk_out6
                            
  reg                              clk_out6;
  reg                              pos_edge6;
  reg                              neg_edge6;
                            
  reg       [`SPI_DIVIDER_LEN6-1:0] cnt;      // clock6 counter 
  wire                             cnt_zero6; // conter6 is equal6 to zero
  wire                             cnt_one6;  // conter6 is equal6 to one
  
  
  assign cnt_zero6 = cnt == {`SPI_DIVIDER_LEN6{1'b0}};
  assign cnt_one6  = cnt == {{`SPI_DIVIDER_LEN6-1{1'b0}}, 1'b1};
  
  // Counter6 counts6 half6 period6
  always @(posedge clk_in6 or posedge rst6)
  begin
    if(rst6)
      cnt <= #Tp6 {`SPI_DIVIDER_LEN6{1'b1}};
    else
      begin
        if(!enable || cnt_zero6)
          cnt <= #Tp6 divider6;
        else
          cnt <= #Tp6 cnt - {{`SPI_DIVIDER_LEN6-1{1'b0}}, 1'b1};
      end
  end
  
  // clk_out6 is asserted6 every6 other half6 period6
  always @(posedge clk_in6 or posedge rst6)
  begin
    if(rst6)
      clk_out6 <= #Tp6 1'b0;
    else
      clk_out6 <= #Tp6 (enable && cnt_zero6 && (!last_clk6 || clk_out6)) ? ~clk_out6 : clk_out6;
  end
   
  // Pos6 and neg6 edge signals6
  always @(posedge clk_in6 or posedge rst6)
  begin
    if(rst6)
      begin
        pos_edge6  <= #Tp6 1'b0;
        neg_edge6  <= #Tp6 1'b0;
      end
    else
      begin
        pos_edge6  <= #Tp6 (enable && !clk_out6 && cnt_one6) || (!(|divider6) && clk_out6) || (!(|divider6) && go6 && !enable);
        neg_edge6  <= #Tp6 (enable && clk_out6 && cnt_one6) || (!(|divider6) && !clk_out6 && enable);
      end
  end
endmodule
 
