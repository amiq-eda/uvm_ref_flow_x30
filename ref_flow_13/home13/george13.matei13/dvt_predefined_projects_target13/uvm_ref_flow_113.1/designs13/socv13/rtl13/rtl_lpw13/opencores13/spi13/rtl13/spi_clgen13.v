//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_clgen13.v                                                 ////
////                                                              ////
////  This13 file is part of the SPI13 IP13 core13 project13                ////
////  http13://www13.opencores13.org13/projects13/spi13/                      ////
////                                                              ////
////  Author13(s):                                                  ////
////      - Simon13 Srot13 (simons13@opencores13.org13)                     ////
////                                                              ////
////  All additional13 information is avaliable13 in the Readme13.txt13   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright13 (C) 2002 Authors13                                   ////
////                                                              ////
//// This13 source13 file may be used and distributed13 without         ////
//// restriction13 provided that this copyright13 statement13 is not    ////
//// removed from the file and that any derivative13 work13 contains13  ////
//// the original copyright13 notice13 and the associated disclaimer13. ////
////                                                              ////
//// This13 source13 file is free software13; you can redistribute13 it   ////
//// and/or modify it under the terms13 of the GNU13 Lesser13 General13   ////
//// Public13 License13 as published13 by the Free13 Software13 Foundation13; ////
//// either13 version13 2.1 of the License13, or (at your13 option) any   ////
//// later13 version13.                                               ////
////                                                              ////
//// This13 source13 is distributed13 in the hope13 that it will be       ////
//// useful13, but WITHOUT13 ANY13 WARRANTY13; without even13 the implied13   ////
//// warranty13 of MERCHANTABILITY13 or FITNESS13 FOR13 A PARTICULAR13      ////
//// PURPOSE13.  See the GNU13 Lesser13 General13 Public13 License13 for more ////
//// details13.                                                     ////
////                                                              ////
//// You should have received13 a copy of the GNU13 Lesser13 General13    ////
//// Public13 License13 along13 with this source13; if not, download13 it   ////
//// from http13://www13.opencores13.org13/lgpl13.shtml13                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines13.v"
`include "timescale.v"

module spi_clgen13 (clk_in13, rst13, go13, enable, last_clk13, divider13, clk_out13, pos_edge13, neg_edge13); 

  parameter Tp13 = 1;
  
  input                            clk_in13;   // input clock13 (system clock13)
  input                            rst13;      // reset
  input                            enable;   // clock13 enable
  input                            go13;       // start transfer13
  input                            last_clk13; // last clock13
  input     [`SPI_DIVIDER_LEN13-1:0] divider13;  // clock13 divider13 (output clock13 is divided13 by this value)
  output                           clk_out13;  // output clock13
  output                           pos_edge13; // pulse13 marking13 positive13 edge of clk_out13
  output                           neg_edge13; // pulse13 marking13 negative edge of clk_out13
                            
  reg                              clk_out13;
  reg                              pos_edge13;
  reg                              neg_edge13;
                            
  reg       [`SPI_DIVIDER_LEN13-1:0] cnt;      // clock13 counter 
  wire                             cnt_zero13; // conter13 is equal13 to zero
  wire                             cnt_one13;  // conter13 is equal13 to one
  
  
  assign cnt_zero13 = cnt == {`SPI_DIVIDER_LEN13{1'b0}};
  assign cnt_one13  = cnt == {{`SPI_DIVIDER_LEN13-1{1'b0}}, 1'b1};
  
  // Counter13 counts13 half13 period13
  always @(posedge clk_in13 or posedge rst13)
  begin
    if(rst13)
      cnt <= #Tp13 {`SPI_DIVIDER_LEN13{1'b1}};
    else
      begin
        if(!enable || cnt_zero13)
          cnt <= #Tp13 divider13;
        else
          cnt <= #Tp13 cnt - {{`SPI_DIVIDER_LEN13-1{1'b0}}, 1'b1};
      end
  end
  
  // clk_out13 is asserted13 every13 other half13 period13
  always @(posedge clk_in13 or posedge rst13)
  begin
    if(rst13)
      clk_out13 <= #Tp13 1'b0;
    else
      clk_out13 <= #Tp13 (enable && cnt_zero13 && (!last_clk13 || clk_out13)) ? ~clk_out13 : clk_out13;
  end
   
  // Pos13 and neg13 edge signals13
  always @(posedge clk_in13 or posedge rst13)
  begin
    if(rst13)
      begin
        pos_edge13  <= #Tp13 1'b0;
        neg_edge13  <= #Tp13 1'b0;
      end
    else
      begin
        pos_edge13  <= #Tp13 (enable && !clk_out13 && cnt_one13) || (!(|divider13) && clk_out13) || (!(|divider13) && go13 && !enable);
        neg_edge13  <= #Tp13 (enable && clk_out13 && cnt_one13) || (!(|divider13) && !clk_out13 && enable);
      end
  end
endmodule
 
