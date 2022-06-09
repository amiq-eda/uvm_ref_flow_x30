//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_shift8.v                                                 ////
////                                                              ////
////  This8 file is part of the SPI8 IP8 core8 project8                ////
////  http8://www8.opencores8.org8/projects8/spi8/                      ////
////                                                              ////
////  Author8(s):                                                  ////
////      - Simon8 Srot8 (simons8@opencores8.org8)                     ////
////                                                              ////
////  All additional8 information is avaliable8 in the Readme8.txt8   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright8 (C) 2002 Authors8                                   ////
////                                                              ////
//// This8 source8 file may be used and distributed8 without         ////
//// restriction8 provided that this copyright8 statement8 is not    ////
//// removed from the file and that any derivative8 work8 contains8  ////
//// the original copyright8 notice8 and the associated disclaimer8. ////
////                                                              ////
//// This8 source8 file is free software8; you can redistribute8 it   ////
//// and/or modify it under the terms8 of the GNU8 Lesser8 General8   ////
//// Public8 License8 as published8 by the Free8 Software8 Foundation8; ////
//// either8 version8 2.1 of the License8, or (at your8 option) any   ////
//// later8 version8.                                               ////
////                                                              ////
//// This8 source8 is distributed8 in the hope8 that it will be       ////
//// useful8, but WITHOUT8 ANY8 WARRANTY8; without even8 the implied8   ////
//// warranty8 of MERCHANTABILITY8 or FITNESS8 FOR8 A PARTICULAR8      ////
//// PURPOSE8.  See the GNU8 Lesser8 General8 Public8 License8 for more ////
//// details8.                                                     ////
////                                                              ////
//// You should have received8 a copy of the GNU8 Lesser8 General8    ////
//// Public8 License8 along8 with this source8; if not, download8 it   ////
//// from http8://www8.opencores8.org8/lgpl8.shtml8                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines8.v"
`include "timescale.v"

module spi_shift8 (clk8, rst8, latch8, byte_sel8, len, lsb, go8,
                  pos_edge8, neg_edge8, rx_negedge8, tx_negedge8,
                  tip8, last, 
                  p_in8, p_out8, s_clk8, s_in8, s_out8);

  parameter Tp8 = 1;
  
  input                          clk8;          // system clock8
  input                          rst8;          // reset
  input                    [3:0] latch8;        // latch8 signal8 for storing8 the data in shift8 register
  input                    [3:0] byte_sel8;     // byte select8 signals8 for storing8 the data in shift8 register
  input [`SPI_CHAR_LEN_BITS8-1:0] len;          // data len in bits (minus8 one)
  input                          lsb;          // lbs8 first on the line
  input                          go8;           // start stansfer8
  input                          pos_edge8;     // recognize8 posedge of sclk8
  input                          neg_edge8;     // recognize8 negedge of sclk8
  input                          rx_negedge8;   // s_in8 is sampled8 on negative edge 
  input                          tx_negedge8;   // s_out8 is driven8 on negative edge
  output                         tip8;          // transfer8 in progress8
  output                         last;         // last bit
  input                   [31:0] p_in8;         // parallel8 in
  output     [`SPI_MAX_CHAR8-1:0] p_out8;        // parallel8 out
  input                          s_clk8;        // serial8 clock8
  input                          s_in8;         // serial8 in
  output                         s_out8;        // serial8 out
                                               
  reg                            s_out8;        
  reg                            tip8;
                              
  reg     [`SPI_CHAR_LEN_BITS8:0] cnt;          // data bit count
  reg        [`SPI_MAX_CHAR8-1:0] data;         // shift8 register
  wire    [`SPI_CHAR_LEN_BITS8:0] tx_bit_pos8;   // next bit position8
  wire    [`SPI_CHAR_LEN_BITS8:0] rx_bit_pos8;   // next bit position8
  wire                           rx_clk8;       // rx8 clock8 enable
  wire                           tx_clk8;       // tx8 clock8 enable
  
  assign p_out8 = data;
  
  assign tx_bit_pos8 = lsb ? {!(|len), len} - cnt : cnt - {{`SPI_CHAR_LEN_BITS8{1'b0}},1'b1};
  assign rx_bit_pos8 = lsb ? {!(|len), len} - (rx_negedge8 ? cnt + {{`SPI_CHAR_LEN_BITS8{1'b0}},1'b1} : cnt) : 
                            (rx_negedge8 ? cnt : cnt - {{`SPI_CHAR_LEN_BITS8{1'b0}},1'b1});
  
  assign last = !(|cnt);
  
  assign rx_clk8 = (rx_negedge8 ? neg_edge8 : pos_edge8) && (!last || s_clk8);
  assign tx_clk8 = (tx_negedge8 ? neg_edge8 : pos_edge8) && !last;
  
  // Character8 bit counter
  always @(posedge clk8 or posedge rst8)
  begin
    if(rst8)
      cnt <= #Tp8 {`SPI_CHAR_LEN_BITS8+1{1'b0}};
    else
      begin
        if(tip8)
          cnt <= #Tp8 pos_edge8 ? (cnt - {{`SPI_CHAR_LEN_BITS8{1'b0}}, 1'b1}) : cnt;
        else
          cnt <= #Tp8 !(|len) ? {1'b1, {`SPI_CHAR_LEN_BITS8{1'b0}}} : {1'b0, len};
      end
  end
  
  // Transfer8 in progress8
  always @(posedge clk8 or posedge rst8)
  begin
    if(rst8)
      tip8 <= #Tp8 1'b0;
  else if(go8 && ~tip8)
    tip8 <= #Tp8 1'b1;
  else if(tip8 && last && pos_edge8)
    tip8 <= #Tp8 1'b0;
  end
  
  // Sending8 bits to the line
  always @(posedge clk8 or posedge rst8)
  begin
    if (rst8)
      s_out8   <= #Tp8 1'b0;
    else
      s_out8 <= #Tp8 (tx_clk8 || !tip8) ? data[tx_bit_pos8[`SPI_CHAR_LEN_BITS8-1:0]] : s_out8;
  end
  
  // Receiving8 bits from the line
  always @(posedge clk8 or posedge rst8)
  begin
    if (rst8)
      data   <= #Tp8 {`SPI_MAX_CHAR8{1'b0}};
`ifdef SPI_MAX_CHAR_1288
    else if (latch8[0] && !tip8)
      begin
        if (byte_sel8[3])
          data[31:24] <= #Tp8 p_in8[31:24];
        if (byte_sel8[2])
          data[23:16] <= #Tp8 p_in8[23:16];
        if (byte_sel8[1])
          data[15:8] <= #Tp8 p_in8[15:8];
        if (byte_sel8[0])
          data[7:0] <= #Tp8 p_in8[7:0];
      end
    else if (latch8[1] && !tip8)
      begin
        if (byte_sel8[3])
          data[63:56] <= #Tp8 p_in8[31:24];
        if (byte_sel8[2])
          data[55:48] <= #Tp8 p_in8[23:16];
        if (byte_sel8[1])
          data[47:40] <= #Tp8 p_in8[15:8];
        if (byte_sel8[0])
          data[39:32] <= #Tp8 p_in8[7:0];
      end
    else if (latch8[2] && !tip8)
      begin
        if (byte_sel8[3])
          data[95:88] <= #Tp8 p_in8[31:24];
        if (byte_sel8[2])
          data[87:80] <= #Tp8 p_in8[23:16];
        if (byte_sel8[1])
          data[79:72] <= #Tp8 p_in8[15:8];
        if (byte_sel8[0])
          data[71:64] <= #Tp8 p_in8[7:0];
      end
    else if (latch8[3] && !tip8)
      begin
        if (byte_sel8[3])
          data[127:120] <= #Tp8 p_in8[31:24];
        if (byte_sel8[2])
          data[119:112] <= #Tp8 p_in8[23:16];
        if (byte_sel8[1])
          data[111:104] <= #Tp8 p_in8[15:8];
        if (byte_sel8[0])
          data[103:96] <= #Tp8 p_in8[7:0];
      end
`else
`ifdef SPI_MAX_CHAR_648
    else if (latch8[0] && !tip8)
      begin
        if (byte_sel8[3])
          data[31:24] <= #Tp8 p_in8[31:24];
        if (byte_sel8[2])
          data[23:16] <= #Tp8 p_in8[23:16];
        if (byte_sel8[1])
          data[15:8] <= #Tp8 p_in8[15:8];
        if (byte_sel8[0])
          data[7:0] <= #Tp8 p_in8[7:0];
      end
    else if (latch8[1] && !tip8)
      begin
        if (byte_sel8[3])
          data[63:56] <= #Tp8 p_in8[31:24];
        if (byte_sel8[2])
          data[55:48] <= #Tp8 p_in8[23:16];
        if (byte_sel8[1])
          data[47:40] <= #Tp8 p_in8[15:8];
        if (byte_sel8[0])
          data[39:32] <= #Tp8 p_in8[7:0];
      end
`else
    else if (latch8[0] && !tip8)
      begin
      `ifdef SPI_MAX_CHAR_88
        if (byte_sel8[0])
          data[`SPI_MAX_CHAR8-1:0] <= #Tp8 p_in8[`SPI_MAX_CHAR8-1:0];
      `endif
      `ifdef SPI_MAX_CHAR_168
        if (byte_sel8[0])
          data[7:0] <= #Tp8 p_in8[7:0];
        if (byte_sel8[1])
          data[`SPI_MAX_CHAR8-1:8] <= #Tp8 p_in8[`SPI_MAX_CHAR8-1:8];
      `endif
      `ifdef SPI_MAX_CHAR_248
        if (byte_sel8[0])
          data[7:0] <= #Tp8 p_in8[7:0];
        if (byte_sel8[1])
          data[15:8] <= #Tp8 p_in8[15:8];
        if (byte_sel8[2])
          data[`SPI_MAX_CHAR8-1:16] <= #Tp8 p_in8[`SPI_MAX_CHAR8-1:16];
      `endif
      `ifdef SPI_MAX_CHAR_328
        if (byte_sel8[0])
          data[7:0] <= #Tp8 p_in8[7:0];
        if (byte_sel8[1])
          data[15:8] <= #Tp8 p_in8[15:8];
        if (byte_sel8[2])
          data[23:16] <= #Tp8 p_in8[23:16];
        if (byte_sel8[3])
          data[`SPI_MAX_CHAR8-1:24] <= #Tp8 p_in8[`SPI_MAX_CHAR8-1:24];
      `endif
      end
`endif
`endif
    else
      data[rx_bit_pos8[`SPI_CHAR_LEN_BITS8-1:0]] <= #Tp8 rx_clk8 ? s_in8 : data[rx_bit_pos8[`SPI_CHAR_LEN_BITS8-1:0]];
  end
  
endmodule

