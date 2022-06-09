//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_shift25.v                                                 ////
////                                                              ////
////  This25 file is part of the SPI25 IP25 core25 project25                ////
////  http25://www25.opencores25.org25/projects25/spi25/                      ////
////                                                              ////
////  Author25(s):                                                  ////
////      - Simon25 Srot25 (simons25@opencores25.org25)                     ////
////                                                              ////
////  All additional25 information is avaliable25 in the Readme25.txt25   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright25 (C) 2002 Authors25                                   ////
////                                                              ////
//// This25 source25 file may be used and distributed25 without         ////
//// restriction25 provided that this copyright25 statement25 is not    ////
//// removed from the file and that any derivative25 work25 contains25  ////
//// the original copyright25 notice25 and the associated disclaimer25. ////
////                                                              ////
//// This25 source25 file is free software25; you can redistribute25 it   ////
//// and/or modify it under the terms25 of the GNU25 Lesser25 General25   ////
//// Public25 License25 as published25 by the Free25 Software25 Foundation25; ////
//// either25 version25 2.1 of the License25, or (at your25 option) any   ////
//// later25 version25.                                               ////
////                                                              ////
//// This25 source25 is distributed25 in the hope25 that it will be       ////
//// useful25, but WITHOUT25 ANY25 WARRANTY25; without even25 the implied25   ////
//// warranty25 of MERCHANTABILITY25 or FITNESS25 FOR25 A PARTICULAR25      ////
//// PURPOSE25.  See the GNU25 Lesser25 General25 Public25 License25 for more ////
//// details25.                                                     ////
////                                                              ////
//// You should have received25 a copy of the GNU25 Lesser25 General25    ////
//// Public25 License25 along25 with this source25; if not, download25 it   ////
//// from http25://www25.opencores25.org25/lgpl25.shtml25                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines25.v"
`include "timescale.v"

module spi_shift25 (clk25, rst25, latch25, byte_sel25, len, lsb, go25,
                  pos_edge25, neg_edge25, rx_negedge25, tx_negedge25,
                  tip25, last, 
                  p_in25, p_out25, s_clk25, s_in25, s_out25);

  parameter Tp25 = 1;
  
  input                          clk25;          // system clock25
  input                          rst25;          // reset
  input                    [3:0] latch25;        // latch25 signal25 for storing25 the data in shift25 register
  input                    [3:0] byte_sel25;     // byte select25 signals25 for storing25 the data in shift25 register
  input [`SPI_CHAR_LEN_BITS25-1:0] len;          // data len in bits (minus25 one)
  input                          lsb;          // lbs25 first on the line
  input                          go25;           // start stansfer25
  input                          pos_edge25;     // recognize25 posedge of sclk25
  input                          neg_edge25;     // recognize25 negedge of sclk25
  input                          rx_negedge25;   // s_in25 is sampled25 on negative edge 
  input                          tx_negedge25;   // s_out25 is driven25 on negative edge
  output                         tip25;          // transfer25 in progress25
  output                         last;         // last bit
  input                   [31:0] p_in25;         // parallel25 in
  output     [`SPI_MAX_CHAR25-1:0] p_out25;        // parallel25 out
  input                          s_clk25;        // serial25 clock25
  input                          s_in25;         // serial25 in
  output                         s_out25;        // serial25 out
                                               
  reg                            s_out25;        
  reg                            tip25;
                              
  reg     [`SPI_CHAR_LEN_BITS25:0] cnt;          // data bit count
  reg        [`SPI_MAX_CHAR25-1:0] data;         // shift25 register
  wire    [`SPI_CHAR_LEN_BITS25:0] tx_bit_pos25;   // next bit position25
  wire    [`SPI_CHAR_LEN_BITS25:0] rx_bit_pos25;   // next bit position25
  wire                           rx_clk25;       // rx25 clock25 enable
  wire                           tx_clk25;       // tx25 clock25 enable
  
  assign p_out25 = data;
  
  assign tx_bit_pos25 = lsb ? {!(|len), len} - cnt : cnt - {{`SPI_CHAR_LEN_BITS25{1'b0}},1'b1};
  assign rx_bit_pos25 = lsb ? {!(|len), len} - (rx_negedge25 ? cnt + {{`SPI_CHAR_LEN_BITS25{1'b0}},1'b1} : cnt) : 
                            (rx_negedge25 ? cnt : cnt - {{`SPI_CHAR_LEN_BITS25{1'b0}},1'b1});
  
  assign last = !(|cnt);
  
  assign rx_clk25 = (rx_negedge25 ? neg_edge25 : pos_edge25) && (!last || s_clk25);
  assign tx_clk25 = (tx_negedge25 ? neg_edge25 : pos_edge25) && !last;
  
  // Character25 bit counter
  always @(posedge clk25 or posedge rst25)
  begin
    if(rst25)
      cnt <= #Tp25 {`SPI_CHAR_LEN_BITS25+1{1'b0}};
    else
      begin
        if(tip25)
          cnt <= #Tp25 pos_edge25 ? (cnt - {{`SPI_CHAR_LEN_BITS25{1'b0}}, 1'b1}) : cnt;
        else
          cnt <= #Tp25 !(|len) ? {1'b1, {`SPI_CHAR_LEN_BITS25{1'b0}}} : {1'b0, len};
      end
  end
  
  // Transfer25 in progress25
  always @(posedge clk25 or posedge rst25)
  begin
    if(rst25)
      tip25 <= #Tp25 1'b0;
  else if(go25 && ~tip25)
    tip25 <= #Tp25 1'b1;
  else if(tip25 && last && pos_edge25)
    tip25 <= #Tp25 1'b0;
  end
  
  // Sending25 bits to the line
  always @(posedge clk25 or posedge rst25)
  begin
    if (rst25)
      s_out25   <= #Tp25 1'b0;
    else
      s_out25 <= #Tp25 (tx_clk25 || !tip25) ? data[tx_bit_pos25[`SPI_CHAR_LEN_BITS25-1:0]] : s_out25;
  end
  
  // Receiving25 bits from the line
  always @(posedge clk25 or posedge rst25)
  begin
    if (rst25)
      data   <= #Tp25 {`SPI_MAX_CHAR25{1'b0}};
`ifdef SPI_MAX_CHAR_12825
    else if (latch25[0] && !tip25)
      begin
        if (byte_sel25[3])
          data[31:24] <= #Tp25 p_in25[31:24];
        if (byte_sel25[2])
          data[23:16] <= #Tp25 p_in25[23:16];
        if (byte_sel25[1])
          data[15:8] <= #Tp25 p_in25[15:8];
        if (byte_sel25[0])
          data[7:0] <= #Tp25 p_in25[7:0];
      end
    else if (latch25[1] && !tip25)
      begin
        if (byte_sel25[3])
          data[63:56] <= #Tp25 p_in25[31:24];
        if (byte_sel25[2])
          data[55:48] <= #Tp25 p_in25[23:16];
        if (byte_sel25[1])
          data[47:40] <= #Tp25 p_in25[15:8];
        if (byte_sel25[0])
          data[39:32] <= #Tp25 p_in25[7:0];
      end
    else if (latch25[2] && !tip25)
      begin
        if (byte_sel25[3])
          data[95:88] <= #Tp25 p_in25[31:24];
        if (byte_sel25[2])
          data[87:80] <= #Tp25 p_in25[23:16];
        if (byte_sel25[1])
          data[79:72] <= #Tp25 p_in25[15:8];
        if (byte_sel25[0])
          data[71:64] <= #Tp25 p_in25[7:0];
      end
    else if (latch25[3] && !tip25)
      begin
        if (byte_sel25[3])
          data[127:120] <= #Tp25 p_in25[31:24];
        if (byte_sel25[2])
          data[119:112] <= #Tp25 p_in25[23:16];
        if (byte_sel25[1])
          data[111:104] <= #Tp25 p_in25[15:8];
        if (byte_sel25[0])
          data[103:96] <= #Tp25 p_in25[7:0];
      end
`else
`ifdef SPI_MAX_CHAR_6425
    else if (latch25[0] && !tip25)
      begin
        if (byte_sel25[3])
          data[31:24] <= #Tp25 p_in25[31:24];
        if (byte_sel25[2])
          data[23:16] <= #Tp25 p_in25[23:16];
        if (byte_sel25[1])
          data[15:8] <= #Tp25 p_in25[15:8];
        if (byte_sel25[0])
          data[7:0] <= #Tp25 p_in25[7:0];
      end
    else if (latch25[1] && !tip25)
      begin
        if (byte_sel25[3])
          data[63:56] <= #Tp25 p_in25[31:24];
        if (byte_sel25[2])
          data[55:48] <= #Tp25 p_in25[23:16];
        if (byte_sel25[1])
          data[47:40] <= #Tp25 p_in25[15:8];
        if (byte_sel25[0])
          data[39:32] <= #Tp25 p_in25[7:0];
      end
`else
    else if (latch25[0] && !tip25)
      begin
      `ifdef SPI_MAX_CHAR_825
        if (byte_sel25[0])
          data[`SPI_MAX_CHAR25-1:0] <= #Tp25 p_in25[`SPI_MAX_CHAR25-1:0];
      `endif
      `ifdef SPI_MAX_CHAR_1625
        if (byte_sel25[0])
          data[7:0] <= #Tp25 p_in25[7:0];
        if (byte_sel25[1])
          data[`SPI_MAX_CHAR25-1:8] <= #Tp25 p_in25[`SPI_MAX_CHAR25-1:8];
      `endif
      `ifdef SPI_MAX_CHAR_2425
        if (byte_sel25[0])
          data[7:0] <= #Tp25 p_in25[7:0];
        if (byte_sel25[1])
          data[15:8] <= #Tp25 p_in25[15:8];
        if (byte_sel25[2])
          data[`SPI_MAX_CHAR25-1:16] <= #Tp25 p_in25[`SPI_MAX_CHAR25-1:16];
      `endif
      `ifdef SPI_MAX_CHAR_3225
        if (byte_sel25[0])
          data[7:0] <= #Tp25 p_in25[7:0];
        if (byte_sel25[1])
          data[15:8] <= #Tp25 p_in25[15:8];
        if (byte_sel25[2])
          data[23:16] <= #Tp25 p_in25[23:16];
        if (byte_sel25[3])
          data[`SPI_MAX_CHAR25-1:24] <= #Tp25 p_in25[`SPI_MAX_CHAR25-1:24];
      `endif
      end
`endif
`endif
    else
      data[rx_bit_pos25[`SPI_CHAR_LEN_BITS25-1:0]] <= #Tp25 rx_clk25 ? s_in25 : data[rx_bit_pos25[`SPI_CHAR_LEN_BITS25-1:0]];
  end
  
endmodule

