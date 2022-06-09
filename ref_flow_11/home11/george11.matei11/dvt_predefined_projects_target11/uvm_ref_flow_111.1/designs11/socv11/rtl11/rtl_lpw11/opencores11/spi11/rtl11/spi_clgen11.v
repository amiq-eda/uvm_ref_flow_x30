//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_clgen11.v                                                 ////
////                                                              ////
////  This11 file is part of the SPI11 IP11 core11 project11                ////
////  http11://www11.opencores11.org11/projects11/spi11/                      ////
////                                                              ////
////  Author11(s):                                                  ////
////      - Simon11 Srot11 (simons11@opencores11.org11)                     ////
////                                                              ////
////  All additional11 information is avaliable11 in the Readme11.txt11   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright11 (C) 2002 Authors11                                   ////
////                                                              ////
//// This11 source11 file may be used and distributed11 without         ////
//// restriction11 provided that this copyright11 statement11 is not    ////
//// removed from the file and that any derivative11 work11 contains11  ////
//// the original copyright11 notice11 and the associated disclaimer11. ////
////                                                              ////
//// This11 source11 file is free software11; you can redistribute11 it   ////
//// and/or modify it under the terms11 of the GNU11 Lesser11 General11   ////
//// Public11 License11 as published11 by the Free11 Software11 Foundation11; ////
//// either11 version11 2.1 of the License11, or (at your11 option) any   ////
//// later11 version11.                                               ////
////                                                              ////
//// This11 source11 is distributed11 in the hope11 that it will be       ////
//// useful11, but WITHOUT11 ANY11 WARRANTY11; without even11 the implied11   ////
//// warranty11 of MERCHANTABILITY11 or FITNESS11 FOR11 A PARTICULAR11      ////
//// PURPOSE11.  See the GNU11 Lesser11 General11 Public11 License11 for more ////
//// details11.                                                     ////
////                                                              ////
//// You should have received11 a copy of the GNU11 Lesser11 General11    ////
//// Public11 License11 along11 with this source11; if not, download11 it   ////
//// from http11://www11.opencores11.org11/lgpl11.shtml11                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines11.v"
`include "timescale.v"

module spi_clgen11 (clk_in11, rst11, go11, enable, last_clk11, divider11, clk_out11, pos_edge11, neg_edge11); 

  parameter Tp11 = 1;
  
  input                            clk_in11;   // input clock11 (system clock11)
  input                            rst11;      // reset
  input                            enable;   // clock11 enable
  input                            go11;       // start transfer11
  input                            last_clk11; // last clock11
  input     [`SPI_DIVIDER_LEN11-1:0] divider11;  // clock11 divider11 (output clock11 is divided11 by this value)
  output                           clk_out11;  // output clock11
  output                           pos_edge11; // pulse11 marking11 positive11 edge of clk_out11
  output                           neg_edge11; // pulse11 marking11 negative edge of clk_out11
                            
  reg                              clk_out11;
  reg                              pos_edge11;
  reg                              neg_edge11;
                            
  reg       [`SPI_DIVIDER_LEN11-1:0] cnt;      // clock11 counter 
  wire                             cnt_zero11; // conter11 is equal11 to zero
  wire                             cnt_one11;  // conter11 is equal11 to one
  
  
  assign cnt_zero11 = cnt == {`SPI_DIVIDER_LEN11{1'b0}};
  assign cnt_one11  = cnt == {{`SPI_DIVIDER_LEN11-1{1'b0}}, 1'b1};
  
  // Counter11 counts11 half11 period11
  always @(posedge clk_in11 or posedge rst11)
  begin
    if(rst11)
      cnt <= #Tp11 {`SPI_DIVIDER_LEN11{1'b1}};
    else
      begin
        if(!enable || cnt_zero11)
          cnt <= #Tp11 divider11;
        else
          cnt <= #Tp11 cnt - {{`SPI_DIVIDER_LEN11-1{1'b0}}, 1'b1};
      end
  end
  
  // clk_out11 is asserted11 every11 other half11 period11
  always @(posedge clk_in11 or posedge rst11)
  begin
    if(rst11)
      clk_out11 <= #Tp11 1'b0;
    else
      clk_out11 <= #Tp11 (enable && cnt_zero11 && (!last_clk11 || clk_out11)) ? ~clk_out11 : clk_out11;
  end
   
  // Pos11 and neg11 edge signals11
  always @(posedge clk_in11 or posedge rst11)
  begin
    if(rst11)
      begin
        pos_edge11  <= #Tp11 1'b0;
        neg_edge11  <= #Tp11 1'b0;
      end
    else
      begin
        pos_edge11  <= #Tp11 (enable && !clk_out11 && cnt_one11) || (!(|divider11) && clk_out11) || (!(|divider11) && go11 && !enable);
        neg_edge11  <= #Tp11 (enable && clk_out11 && cnt_one11) || (!(|divider11) && !clk_out11 && enable);
      end
  end
endmodule
 
