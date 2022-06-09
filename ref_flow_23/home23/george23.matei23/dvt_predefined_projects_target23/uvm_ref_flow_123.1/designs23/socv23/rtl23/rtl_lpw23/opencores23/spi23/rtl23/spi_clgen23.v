//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_clgen23.v                                                 ////
////                                                              ////
////  This23 file is part of the SPI23 IP23 core23 project23                ////
////  http23://www23.opencores23.org23/projects23/spi23/                      ////
////                                                              ////
////  Author23(s):                                                  ////
////      - Simon23 Srot23 (simons23@opencores23.org23)                     ////
////                                                              ////
////  All additional23 information is avaliable23 in the Readme23.txt23   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright23 (C) 2002 Authors23                                   ////
////                                                              ////
//// This23 source23 file may be used and distributed23 without         ////
//// restriction23 provided that this copyright23 statement23 is not    ////
//// removed from the file and that any derivative23 work23 contains23  ////
//// the original copyright23 notice23 and the associated disclaimer23. ////
////                                                              ////
//// This23 source23 file is free software23; you can redistribute23 it   ////
//// and/or modify it under the terms23 of the GNU23 Lesser23 General23   ////
//// Public23 License23 as published23 by the Free23 Software23 Foundation23; ////
//// either23 version23 2.1 of the License23, or (at your23 option) any   ////
//// later23 version23.                                               ////
////                                                              ////
//// This23 source23 is distributed23 in the hope23 that it will be       ////
//// useful23, but WITHOUT23 ANY23 WARRANTY23; without even23 the implied23   ////
//// warranty23 of MERCHANTABILITY23 or FITNESS23 FOR23 A PARTICULAR23      ////
//// PURPOSE23.  See the GNU23 Lesser23 General23 Public23 License23 for more ////
//// details23.                                                     ////
////                                                              ////
//// You should have received23 a copy of the GNU23 Lesser23 General23    ////
//// Public23 License23 along23 with this source23; if not, download23 it   ////
//// from http23://www23.opencores23.org23/lgpl23.shtml23                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines23.v"
`include "timescale.v"

module spi_clgen23 (clk_in23, rst23, go23, enable, last_clk23, divider23, clk_out23, pos_edge23, neg_edge23); 

  parameter Tp23 = 1;
  
  input                            clk_in23;   // input clock23 (system clock23)
  input                            rst23;      // reset
  input                            enable;   // clock23 enable
  input                            go23;       // start transfer23
  input                            last_clk23; // last clock23
  input     [`SPI_DIVIDER_LEN23-1:0] divider23;  // clock23 divider23 (output clock23 is divided23 by this value)
  output                           clk_out23;  // output clock23
  output                           pos_edge23; // pulse23 marking23 positive23 edge of clk_out23
  output                           neg_edge23; // pulse23 marking23 negative edge of clk_out23
                            
  reg                              clk_out23;
  reg                              pos_edge23;
  reg                              neg_edge23;
                            
  reg       [`SPI_DIVIDER_LEN23-1:0] cnt;      // clock23 counter 
  wire                             cnt_zero23; // conter23 is equal23 to zero
  wire                             cnt_one23;  // conter23 is equal23 to one
  
  
  assign cnt_zero23 = cnt == {`SPI_DIVIDER_LEN23{1'b0}};
  assign cnt_one23  = cnt == {{`SPI_DIVIDER_LEN23-1{1'b0}}, 1'b1};
  
  // Counter23 counts23 half23 period23
  always @(posedge clk_in23 or posedge rst23)
  begin
    if(rst23)
      cnt <= #Tp23 {`SPI_DIVIDER_LEN23{1'b1}};
    else
      begin
        if(!enable || cnt_zero23)
          cnt <= #Tp23 divider23;
        else
          cnt <= #Tp23 cnt - {{`SPI_DIVIDER_LEN23-1{1'b0}}, 1'b1};
      end
  end
  
  // clk_out23 is asserted23 every23 other half23 period23
  always @(posedge clk_in23 or posedge rst23)
  begin
    if(rst23)
      clk_out23 <= #Tp23 1'b0;
    else
      clk_out23 <= #Tp23 (enable && cnt_zero23 && (!last_clk23 || clk_out23)) ? ~clk_out23 : clk_out23;
  end
   
  // Pos23 and neg23 edge signals23
  always @(posedge clk_in23 or posedge rst23)
  begin
    if(rst23)
      begin
        pos_edge23  <= #Tp23 1'b0;
        neg_edge23  <= #Tp23 1'b0;
      end
    else
      begin
        pos_edge23  <= #Tp23 (enable && !clk_out23 && cnt_one23) || (!(|divider23) && clk_out23) || (!(|divider23) && go23 && !enable);
        neg_edge23  <= #Tp23 (enable && clk_out23 && cnt_one23) || (!(|divider23) && !clk_out23 && enable);
      end
  end
endmodule
 
