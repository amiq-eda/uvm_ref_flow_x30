//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_clgen19.v                                                 ////
////                                                              ////
////  This19 file is part of the SPI19 IP19 core19 project19                ////
////  http19://www19.opencores19.org19/projects19/spi19/                      ////
////                                                              ////
////  Author19(s):                                                  ////
////      - Simon19 Srot19 (simons19@opencores19.org19)                     ////
////                                                              ////
////  All additional19 information is avaliable19 in the Readme19.txt19   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright19 (C) 2002 Authors19                                   ////
////                                                              ////
//// This19 source19 file may be used and distributed19 without         ////
//// restriction19 provided that this copyright19 statement19 is not    ////
//// removed from the file and that any derivative19 work19 contains19  ////
//// the original copyright19 notice19 and the associated disclaimer19. ////
////                                                              ////
//// This19 source19 file is free software19; you can redistribute19 it   ////
//// and/or modify it under the terms19 of the GNU19 Lesser19 General19   ////
//// Public19 License19 as published19 by the Free19 Software19 Foundation19; ////
//// either19 version19 2.1 of the License19, or (at your19 option) any   ////
//// later19 version19.                                               ////
////                                                              ////
//// This19 source19 is distributed19 in the hope19 that it will be       ////
//// useful19, but WITHOUT19 ANY19 WARRANTY19; without even19 the implied19   ////
//// warranty19 of MERCHANTABILITY19 or FITNESS19 FOR19 A PARTICULAR19      ////
//// PURPOSE19.  See the GNU19 Lesser19 General19 Public19 License19 for more ////
//// details19.                                                     ////
////                                                              ////
//// You should have received19 a copy of the GNU19 Lesser19 General19    ////
//// Public19 License19 along19 with this source19; if not, download19 it   ////
//// from http19://www19.opencores19.org19/lgpl19.shtml19                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines19.v"
`include "timescale.v"

module spi_clgen19 (clk_in19, rst19, go19, enable, last_clk19, divider19, clk_out19, pos_edge19, neg_edge19); 

  parameter Tp19 = 1;
  
  input                            clk_in19;   // input clock19 (system clock19)
  input                            rst19;      // reset
  input                            enable;   // clock19 enable
  input                            go19;       // start transfer19
  input                            last_clk19; // last clock19
  input     [`SPI_DIVIDER_LEN19-1:0] divider19;  // clock19 divider19 (output clock19 is divided19 by this value)
  output                           clk_out19;  // output clock19
  output                           pos_edge19; // pulse19 marking19 positive19 edge of clk_out19
  output                           neg_edge19; // pulse19 marking19 negative edge of clk_out19
                            
  reg                              clk_out19;
  reg                              pos_edge19;
  reg                              neg_edge19;
                            
  reg       [`SPI_DIVIDER_LEN19-1:0] cnt;      // clock19 counter 
  wire                             cnt_zero19; // conter19 is equal19 to zero
  wire                             cnt_one19;  // conter19 is equal19 to one
  
  
  assign cnt_zero19 = cnt == {`SPI_DIVIDER_LEN19{1'b0}};
  assign cnt_one19  = cnt == {{`SPI_DIVIDER_LEN19-1{1'b0}}, 1'b1};
  
  // Counter19 counts19 half19 period19
  always @(posedge clk_in19 or posedge rst19)
  begin
    if(rst19)
      cnt <= #Tp19 {`SPI_DIVIDER_LEN19{1'b1}};
    else
      begin
        if(!enable || cnt_zero19)
          cnt <= #Tp19 divider19;
        else
          cnt <= #Tp19 cnt - {{`SPI_DIVIDER_LEN19-1{1'b0}}, 1'b1};
      end
  end
  
  // clk_out19 is asserted19 every19 other half19 period19
  always @(posedge clk_in19 or posedge rst19)
  begin
    if(rst19)
      clk_out19 <= #Tp19 1'b0;
    else
      clk_out19 <= #Tp19 (enable && cnt_zero19 && (!last_clk19 || clk_out19)) ? ~clk_out19 : clk_out19;
  end
   
  // Pos19 and neg19 edge signals19
  always @(posedge clk_in19 or posedge rst19)
  begin
    if(rst19)
      begin
        pos_edge19  <= #Tp19 1'b0;
        neg_edge19  <= #Tp19 1'b0;
      end
    else
      begin
        pos_edge19  <= #Tp19 (enable && !clk_out19 && cnt_one19) || (!(|divider19) && clk_out19) || (!(|divider19) && go19 && !enable);
        neg_edge19  <= #Tp19 (enable && clk_out19 && cnt_one19) || (!(|divider19) && !clk_out19 && enable);
      end
  end
endmodule
 
