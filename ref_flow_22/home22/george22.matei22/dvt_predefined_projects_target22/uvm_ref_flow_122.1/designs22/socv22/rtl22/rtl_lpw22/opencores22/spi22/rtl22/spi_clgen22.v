//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_clgen22.v                                                 ////
////                                                              ////
////  This22 file is part of the SPI22 IP22 core22 project22                ////
////  http22://www22.opencores22.org22/projects22/spi22/                      ////
////                                                              ////
////  Author22(s):                                                  ////
////      - Simon22 Srot22 (simons22@opencores22.org22)                     ////
////                                                              ////
////  All additional22 information is avaliable22 in the Readme22.txt22   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright22 (C) 2002 Authors22                                   ////
////                                                              ////
//// This22 source22 file may be used and distributed22 without         ////
//// restriction22 provided that this copyright22 statement22 is not    ////
//// removed from the file and that any derivative22 work22 contains22  ////
//// the original copyright22 notice22 and the associated disclaimer22. ////
////                                                              ////
//// This22 source22 file is free software22; you can redistribute22 it   ////
//// and/or modify it under the terms22 of the GNU22 Lesser22 General22   ////
//// Public22 License22 as published22 by the Free22 Software22 Foundation22; ////
//// either22 version22 2.1 of the License22, or (at your22 option) any   ////
//// later22 version22.                                               ////
////                                                              ////
//// This22 source22 is distributed22 in the hope22 that it will be       ////
//// useful22, but WITHOUT22 ANY22 WARRANTY22; without even22 the implied22   ////
//// warranty22 of MERCHANTABILITY22 or FITNESS22 FOR22 A PARTICULAR22      ////
//// PURPOSE22.  See the GNU22 Lesser22 General22 Public22 License22 for more ////
//// details22.                                                     ////
////                                                              ////
//// You should have received22 a copy of the GNU22 Lesser22 General22    ////
//// Public22 License22 along22 with this source22; if not, download22 it   ////
//// from http22://www22.opencores22.org22/lgpl22.shtml22                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines22.v"
`include "timescale.v"

module spi_clgen22 (clk_in22, rst22, go22, enable, last_clk22, divider22, clk_out22, pos_edge22, neg_edge22); 

  parameter Tp22 = 1;
  
  input                            clk_in22;   // input clock22 (system clock22)
  input                            rst22;      // reset
  input                            enable;   // clock22 enable
  input                            go22;       // start transfer22
  input                            last_clk22; // last clock22
  input     [`SPI_DIVIDER_LEN22-1:0] divider22;  // clock22 divider22 (output clock22 is divided22 by this value)
  output                           clk_out22;  // output clock22
  output                           pos_edge22; // pulse22 marking22 positive22 edge of clk_out22
  output                           neg_edge22; // pulse22 marking22 negative edge of clk_out22
                            
  reg                              clk_out22;
  reg                              pos_edge22;
  reg                              neg_edge22;
                            
  reg       [`SPI_DIVIDER_LEN22-1:0] cnt;      // clock22 counter 
  wire                             cnt_zero22; // conter22 is equal22 to zero
  wire                             cnt_one22;  // conter22 is equal22 to one
  
  
  assign cnt_zero22 = cnt == {`SPI_DIVIDER_LEN22{1'b0}};
  assign cnt_one22  = cnt == {{`SPI_DIVIDER_LEN22-1{1'b0}}, 1'b1};
  
  // Counter22 counts22 half22 period22
  always @(posedge clk_in22 or posedge rst22)
  begin
    if(rst22)
      cnt <= #Tp22 {`SPI_DIVIDER_LEN22{1'b1}};
    else
      begin
        if(!enable || cnt_zero22)
          cnt <= #Tp22 divider22;
        else
          cnt <= #Tp22 cnt - {{`SPI_DIVIDER_LEN22-1{1'b0}}, 1'b1};
      end
  end
  
  // clk_out22 is asserted22 every22 other half22 period22
  always @(posedge clk_in22 or posedge rst22)
  begin
    if(rst22)
      clk_out22 <= #Tp22 1'b0;
    else
      clk_out22 <= #Tp22 (enable && cnt_zero22 && (!last_clk22 || clk_out22)) ? ~clk_out22 : clk_out22;
  end
   
  // Pos22 and neg22 edge signals22
  always @(posedge clk_in22 or posedge rst22)
  begin
    if(rst22)
      begin
        pos_edge22  <= #Tp22 1'b0;
        neg_edge22  <= #Tp22 1'b0;
      end
    else
      begin
        pos_edge22  <= #Tp22 (enable && !clk_out22 && cnt_one22) || (!(|divider22) && clk_out22) || (!(|divider22) && go22 && !enable);
        neg_edge22  <= #Tp22 (enable && clk_out22 && cnt_one22) || (!(|divider22) && !clk_out22 && enable);
      end
  end
endmodule
 
