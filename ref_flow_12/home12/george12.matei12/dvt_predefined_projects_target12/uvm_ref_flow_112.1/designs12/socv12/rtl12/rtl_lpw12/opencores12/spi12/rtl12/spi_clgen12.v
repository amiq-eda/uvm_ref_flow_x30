//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_clgen12.v                                                 ////
////                                                              ////
////  This12 file is part of the SPI12 IP12 core12 project12                ////
////  http12://www12.opencores12.org12/projects12/spi12/                      ////
////                                                              ////
////  Author12(s):                                                  ////
////      - Simon12 Srot12 (simons12@opencores12.org12)                     ////
////                                                              ////
////  All additional12 information is avaliable12 in the Readme12.txt12   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright12 (C) 2002 Authors12                                   ////
////                                                              ////
//// This12 source12 file may be used and distributed12 without         ////
//// restriction12 provided that this copyright12 statement12 is not    ////
//// removed from the file and that any derivative12 work12 contains12  ////
//// the original copyright12 notice12 and the associated disclaimer12. ////
////                                                              ////
//// This12 source12 file is free software12; you can redistribute12 it   ////
//// and/or modify it under the terms12 of the GNU12 Lesser12 General12   ////
//// Public12 License12 as published12 by the Free12 Software12 Foundation12; ////
//// either12 version12 2.1 of the License12, or (at your12 option) any   ////
//// later12 version12.                                               ////
////                                                              ////
//// This12 source12 is distributed12 in the hope12 that it will be       ////
//// useful12, but WITHOUT12 ANY12 WARRANTY12; without even12 the implied12   ////
//// warranty12 of MERCHANTABILITY12 or FITNESS12 FOR12 A PARTICULAR12      ////
//// PURPOSE12.  See the GNU12 Lesser12 General12 Public12 License12 for more ////
//// details12.                                                     ////
////                                                              ////
//// You should have received12 a copy of the GNU12 Lesser12 General12    ////
//// Public12 License12 along12 with this source12; if not, download12 it   ////
//// from http12://www12.opencores12.org12/lgpl12.shtml12                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines12.v"
`include "timescale.v"

module spi_clgen12 (clk_in12, rst12, go12, enable, last_clk12, divider12, clk_out12, pos_edge12, neg_edge12); 

  parameter Tp12 = 1;
  
  input                            clk_in12;   // input clock12 (system clock12)
  input                            rst12;      // reset
  input                            enable;   // clock12 enable
  input                            go12;       // start transfer12
  input                            last_clk12; // last clock12
  input     [`SPI_DIVIDER_LEN12-1:0] divider12;  // clock12 divider12 (output clock12 is divided12 by this value)
  output                           clk_out12;  // output clock12
  output                           pos_edge12; // pulse12 marking12 positive12 edge of clk_out12
  output                           neg_edge12; // pulse12 marking12 negative edge of clk_out12
                            
  reg                              clk_out12;
  reg                              pos_edge12;
  reg                              neg_edge12;
                            
  reg       [`SPI_DIVIDER_LEN12-1:0] cnt;      // clock12 counter 
  wire                             cnt_zero12; // conter12 is equal12 to zero
  wire                             cnt_one12;  // conter12 is equal12 to one
  
  
  assign cnt_zero12 = cnt == {`SPI_DIVIDER_LEN12{1'b0}};
  assign cnt_one12  = cnt == {{`SPI_DIVIDER_LEN12-1{1'b0}}, 1'b1};
  
  // Counter12 counts12 half12 period12
  always @(posedge clk_in12 or posedge rst12)
  begin
    if(rst12)
      cnt <= #Tp12 {`SPI_DIVIDER_LEN12{1'b1}};
    else
      begin
        if(!enable || cnt_zero12)
          cnt <= #Tp12 divider12;
        else
          cnt <= #Tp12 cnt - {{`SPI_DIVIDER_LEN12-1{1'b0}}, 1'b1};
      end
  end
  
  // clk_out12 is asserted12 every12 other half12 period12
  always @(posedge clk_in12 or posedge rst12)
  begin
    if(rst12)
      clk_out12 <= #Tp12 1'b0;
    else
      clk_out12 <= #Tp12 (enable && cnt_zero12 && (!last_clk12 || clk_out12)) ? ~clk_out12 : clk_out12;
  end
   
  // Pos12 and neg12 edge signals12
  always @(posedge clk_in12 or posedge rst12)
  begin
    if(rst12)
      begin
        pos_edge12  <= #Tp12 1'b0;
        neg_edge12  <= #Tp12 1'b0;
      end
    else
      begin
        pos_edge12  <= #Tp12 (enable && !clk_out12 && cnt_one12) || (!(|divider12) && clk_out12) || (!(|divider12) && go12 && !enable);
        neg_edge12  <= #Tp12 (enable && clk_out12 && cnt_one12) || (!(|divider12) && !clk_out12 && enable);
      end
  end
endmodule
 
