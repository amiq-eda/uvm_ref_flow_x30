//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_clgen2.v                                                 ////
////                                                              ////
////  This2 file is part of the SPI2 IP2 core2 project2                ////
////  http2://www2.opencores2.org2/projects2/spi2/                      ////
////                                                              ////
////  Author2(s):                                                  ////
////      - Simon2 Srot2 (simons2@opencores2.org2)                     ////
////                                                              ////
////  All additional2 information is avaliable2 in the Readme2.txt2   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright2 (C) 2002 Authors2                                   ////
////                                                              ////
//// This2 source2 file may be used and distributed2 without         ////
//// restriction2 provided that this copyright2 statement2 is not    ////
//// removed from the file and that any derivative2 work2 contains2  ////
//// the original copyright2 notice2 and the associated disclaimer2. ////
////                                                              ////
//// This2 source2 file is free software2; you can redistribute2 it   ////
//// and/or modify it under the terms2 of the GNU2 Lesser2 General2   ////
//// Public2 License2 as published2 by the Free2 Software2 Foundation2; ////
//// either2 version2 2.1 of the License2, or (at your2 option) any   ////
//// later2 version2.                                               ////
////                                                              ////
//// This2 source2 is distributed2 in the hope2 that it will be       ////
//// useful2, but WITHOUT2 ANY2 WARRANTY2; without even2 the implied2   ////
//// warranty2 of MERCHANTABILITY2 or FITNESS2 FOR2 A PARTICULAR2      ////
//// PURPOSE2.  See the GNU2 Lesser2 General2 Public2 License2 for more ////
//// details2.                                                     ////
////                                                              ////
//// You should have received2 a copy of the GNU2 Lesser2 General2    ////
//// Public2 License2 along2 with this source2; if not, download2 it   ////
//// from http2://www2.opencores2.org2/lgpl2.shtml2                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines2.v"
`include "timescale.v"

module spi_clgen2 (clk_in2, rst2, go2, enable, last_clk2, divider2, clk_out2, pos_edge2, neg_edge2); 

  parameter Tp2 = 1;
  
  input                            clk_in2;   // input clock2 (system clock2)
  input                            rst2;      // reset
  input                            enable;   // clock2 enable
  input                            go2;       // start transfer2
  input                            last_clk2; // last clock2
  input     [`SPI_DIVIDER_LEN2-1:0] divider2;  // clock2 divider2 (output clock2 is divided2 by this value)
  output                           clk_out2;  // output clock2
  output                           pos_edge2; // pulse2 marking2 positive2 edge of clk_out2
  output                           neg_edge2; // pulse2 marking2 negative edge of clk_out2
                            
  reg                              clk_out2;
  reg                              pos_edge2;
  reg                              neg_edge2;
                            
  reg       [`SPI_DIVIDER_LEN2-1:0] cnt;      // clock2 counter 
  wire                             cnt_zero2; // conter2 is equal2 to zero
  wire                             cnt_one2;  // conter2 is equal2 to one
  
  
  assign cnt_zero2 = cnt == {`SPI_DIVIDER_LEN2{1'b0}};
  assign cnt_one2  = cnt == {{`SPI_DIVIDER_LEN2-1{1'b0}}, 1'b1};
  
  // Counter2 counts2 half2 period2
  always @(posedge clk_in2 or posedge rst2)
  begin
    if(rst2)
      cnt <= #Tp2 {`SPI_DIVIDER_LEN2{1'b1}};
    else
      begin
        if(!enable || cnt_zero2)
          cnt <= #Tp2 divider2;
        else
          cnt <= #Tp2 cnt - {{`SPI_DIVIDER_LEN2-1{1'b0}}, 1'b1};
      end
  end
  
  // clk_out2 is asserted2 every2 other half2 period2
  always @(posedge clk_in2 or posedge rst2)
  begin
    if(rst2)
      clk_out2 <= #Tp2 1'b0;
    else
      clk_out2 <= #Tp2 (enable && cnt_zero2 && (!last_clk2 || clk_out2)) ? ~clk_out2 : clk_out2;
  end
   
  // Pos2 and neg2 edge signals2
  always @(posedge clk_in2 or posedge rst2)
  begin
    if(rst2)
      begin
        pos_edge2  <= #Tp2 1'b0;
        neg_edge2  <= #Tp2 1'b0;
      end
    else
      begin
        pos_edge2  <= #Tp2 (enable && !clk_out2 && cnt_one2) || (!(|divider2) && clk_out2) || (!(|divider2) && go2 && !enable);
        neg_edge2  <= #Tp2 (enable && clk_out2 && cnt_one2) || (!(|divider2) && !clk_out2 && enable);
      end
  end
endmodule
 
