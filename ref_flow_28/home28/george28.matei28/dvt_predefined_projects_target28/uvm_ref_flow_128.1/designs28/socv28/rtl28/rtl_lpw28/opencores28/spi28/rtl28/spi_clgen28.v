//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_clgen28.v                                                 ////
////                                                              ////
////  This28 file is part of the SPI28 IP28 core28 project28                ////
////  http28://www28.opencores28.org28/projects28/spi28/                      ////
////                                                              ////
////  Author28(s):                                                  ////
////      - Simon28 Srot28 (simons28@opencores28.org28)                     ////
////                                                              ////
////  All additional28 information is avaliable28 in the Readme28.txt28   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright28 (C) 2002 Authors28                                   ////
////                                                              ////
//// This28 source28 file may be used and distributed28 without         ////
//// restriction28 provided that this copyright28 statement28 is not    ////
//// removed from the file and that any derivative28 work28 contains28  ////
//// the original copyright28 notice28 and the associated disclaimer28. ////
////                                                              ////
//// This28 source28 file is free software28; you can redistribute28 it   ////
//// and/or modify it under the terms28 of the GNU28 Lesser28 General28   ////
//// Public28 License28 as published28 by the Free28 Software28 Foundation28; ////
//// either28 version28 2.1 of the License28, or (at your28 option) any   ////
//// later28 version28.                                               ////
////                                                              ////
//// This28 source28 is distributed28 in the hope28 that it will be       ////
//// useful28, but WITHOUT28 ANY28 WARRANTY28; without even28 the implied28   ////
//// warranty28 of MERCHANTABILITY28 or FITNESS28 FOR28 A PARTICULAR28      ////
//// PURPOSE28.  See the GNU28 Lesser28 General28 Public28 License28 for more ////
//// details28.                                                     ////
////                                                              ////
//// You should have received28 a copy of the GNU28 Lesser28 General28    ////
//// Public28 License28 along28 with this source28; if not, download28 it   ////
//// from http28://www28.opencores28.org28/lgpl28.shtml28                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines28.v"
`include "timescale.v"

module spi_clgen28 (clk_in28, rst28, go28, enable, last_clk28, divider28, clk_out28, pos_edge28, neg_edge28); 

  parameter Tp28 = 1;
  
  input                            clk_in28;   // input clock28 (system clock28)
  input                            rst28;      // reset
  input                            enable;   // clock28 enable
  input                            go28;       // start transfer28
  input                            last_clk28; // last clock28
  input     [`SPI_DIVIDER_LEN28-1:0] divider28;  // clock28 divider28 (output clock28 is divided28 by this value)
  output                           clk_out28;  // output clock28
  output                           pos_edge28; // pulse28 marking28 positive28 edge of clk_out28
  output                           neg_edge28; // pulse28 marking28 negative edge of clk_out28
                            
  reg                              clk_out28;
  reg                              pos_edge28;
  reg                              neg_edge28;
                            
  reg       [`SPI_DIVIDER_LEN28-1:0] cnt;      // clock28 counter 
  wire                             cnt_zero28; // conter28 is equal28 to zero
  wire                             cnt_one28;  // conter28 is equal28 to one
  
  
  assign cnt_zero28 = cnt == {`SPI_DIVIDER_LEN28{1'b0}};
  assign cnt_one28  = cnt == {{`SPI_DIVIDER_LEN28-1{1'b0}}, 1'b1};
  
  // Counter28 counts28 half28 period28
  always @(posedge clk_in28 or posedge rst28)
  begin
    if(rst28)
      cnt <= #Tp28 {`SPI_DIVIDER_LEN28{1'b1}};
    else
      begin
        if(!enable || cnt_zero28)
          cnt <= #Tp28 divider28;
        else
          cnt <= #Tp28 cnt - {{`SPI_DIVIDER_LEN28-1{1'b0}}, 1'b1};
      end
  end
  
  // clk_out28 is asserted28 every28 other half28 period28
  always @(posedge clk_in28 or posedge rst28)
  begin
    if(rst28)
      clk_out28 <= #Tp28 1'b0;
    else
      clk_out28 <= #Tp28 (enable && cnt_zero28 && (!last_clk28 || clk_out28)) ? ~clk_out28 : clk_out28;
  end
   
  // Pos28 and neg28 edge signals28
  always @(posedge clk_in28 or posedge rst28)
  begin
    if(rst28)
      begin
        pos_edge28  <= #Tp28 1'b0;
        neg_edge28  <= #Tp28 1'b0;
      end
    else
      begin
        pos_edge28  <= #Tp28 (enable && !clk_out28 && cnt_one28) || (!(|divider28) && clk_out28) || (!(|divider28) && go28 && !enable);
        neg_edge28  <= #Tp28 (enable && clk_out28 && cnt_one28) || (!(|divider28) && !clk_out28 && enable);
      end
  end
endmodule
 
