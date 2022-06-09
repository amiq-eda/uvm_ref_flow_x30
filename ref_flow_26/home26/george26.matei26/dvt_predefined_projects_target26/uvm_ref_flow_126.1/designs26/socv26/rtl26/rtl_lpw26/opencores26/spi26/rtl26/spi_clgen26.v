//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_clgen26.v                                                 ////
////                                                              ////
////  This26 file is part of the SPI26 IP26 core26 project26                ////
////  http26://www26.opencores26.org26/projects26/spi26/                      ////
////                                                              ////
////  Author26(s):                                                  ////
////      - Simon26 Srot26 (simons26@opencores26.org26)                     ////
////                                                              ////
////  All additional26 information is avaliable26 in the Readme26.txt26   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright26 (C) 2002 Authors26                                   ////
////                                                              ////
//// This26 source26 file may be used and distributed26 without         ////
//// restriction26 provided that this copyright26 statement26 is not    ////
//// removed from the file and that any derivative26 work26 contains26  ////
//// the original copyright26 notice26 and the associated disclaimer26. ////
////                                                              ////
//// This26 source26 file is free software26; you can redistribute26 it   ////
//// and/or modify it under the terms26 of the GNU26 Lesser26 General26   ////
//// Public26 License26 as published26 by the Free26 Software26 Foundation26; ////
//// either26 version26 2.1 of the License26, or (at your26 option) any   ////
//// later26 version26.                                               ////
////                                                              ////
//// This26 source26 is distributed26 in the hope26 that it will be       ////
//// useful26, but WITHOUT26 ANY26 WARRANTY26; without even26 the implied26   ////
//// warranty26 of MERCHANTABILITY26 or FITNESS26 FOR26 A PARTICULAR26      ////
//// PURPOSE26.  See the GNU26 Lesser26 General26 Public26 License26 for more ////
//// details26.                                                     ////
////                                                              ////
//// You should have received26 a copy of the GNU26 Lesser26 General26    ////
//// Public26 License26 along26 with this source26; if not, download26 it   ////
//// from http26://www26.opencores26.org26/lgpl26.shtml26                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines26.v"
`include "timescale.v"

module spi_clgen26 (clk_in26, rst26, go26, enable, last_clk26, divider26, clk_out26, pos_edge26, neg_edge26); 

  parameter Tp26 = 1;
  
  input                            clk_in26;   // input clock26 (system clock26)
  input                            rst26;      // reset
  input                            enable;   // clock26 enable
  input                            go26;       // start transfer26
  input                            last_clk26; // last clock26
  input     [`SPI_DIVIDER_LEN26-1:0] divider26;  // clock26 divider26 (output clock26 is divided26 by this value)
  output                           clk_out26;  // output clock26
  output                           pos_edge26; // pulse26 marking26 positive26 edge of clk_out26
  output                           neg_edge26; // pulse26 marking26 negative edge of clk_out26
                            
  reg                              clk_out26;
  reg                              pos_edge26;
  reg                              neg_edge26;
                            
  reg       [`SPI_DIVIDER_LEN26-1:0] cnt;      // clock26 counter 
  wire                             cnt_zero26; // conter26 is equal26 to zero
  wire                             cnt_one26;  // conter26 is equal26 to one
  
  
  assign cnt_zero26 = cnt == {`SPI_DIVIDER_LEN26{1'b0}};
  assign cnt_one26  = cnt == {{`SPI_DIVIDER_LEN26-1{1'b0}}, 1'b1};
  
  // Counter26 counts26 half26 period26
  always @(posedge clk_in26 or posedge rst26)
  begin
    if(rst26)
      cnt <= #Tp26 {`SPI_DIVIDER_LEN26{1'b1}};
    else
      begin
        if(!enable || cnt_zero26)
          cnt <= #Tp26 divider26;
        else
          cnt <= #Tp26 cnt - {{`SPI_DIVIDER_LEN26-1{1'b0}}, 1'b1};
      end
  end
  
  // clk_out26 is asserted26 every26 other half26 period26
  always @(posedge clk_in26 or posedge rst26)
  begin
    if(rst26)
      clk_out26 <= #Tp26 1'b0;
    else
      clk_out26 <= #Tp26 (enable && cnt_zero26 && (!last_clk26 || clk_out26)) ? ~clk_out26 : clk_out26;
  end
   
  // Pos26 and neg26 edge signals26
  always @(posedge clk_in26 or posedge rst26)
  begin
    if(rst26)
      begin
        pos_edge26  <= #Tp26 1'b0;
        neg_edge26  <= #Tp26 1'b0;
      end
    else
      begin
        pos_edge26  <= #Tp26 (enable && !clk_out26 && cnt_one26) || (!(|divider26) && clk_out26) || (!(|divider26) && go26 && !enable);
        neg_edge26  <= #Tp26 (enable && clk_out26 && cnt_one26) || (!(|divider26) && !clk_out26 && enable);
      end
  end
endmodule
 
