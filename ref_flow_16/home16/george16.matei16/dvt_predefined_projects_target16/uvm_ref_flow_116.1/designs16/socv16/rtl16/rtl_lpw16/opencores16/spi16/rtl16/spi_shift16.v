//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_shift16.v                                                 ////
////                                                              ////
////  This16 file is part of the SPI16 IP16 core16 project16                ////
////  http16://www16.opencores16.org16/projects16/spi16/                      ////
////                                                              ////
////  Author16(s):                                                  ////
////      - Simon16 Srot16 (simons16@opencores16.org16)                     ////
////                                                              ////
////  All additional16 information is avaliable16 in the Readme16.txt16   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright16 (C) 2002 Authors16                                   ////
////                                                              ////
//// This16 source16 file may be used and distributed16 without         ////
//// restriction16 provided that this copyright16 statement16 is not    ////
//// removed from the file and that any derivative16 work16 contains16  ////
//// the original copyright16 notice16 and the associated disclaimer16. ////
////                                                              ////
//// This16 source16 file is free software16; you can redistribute16 it   ////
//// and/or modify it under the terms16 of the GNU16 Lesser16 General16   ////
//// Public16 License16 as published16 by the Free16 Software16 Foundation16; ////
//// either16 version16 2.1 of the License16, or (at your16 option) any   ////
//// later16 version16.                                               ////
////                                                              ////
//// This16 source16 is distributed16 in the hope16 that it will be       ////
//// useful16, but WITHOUT16 ANY16 WARRANTY16; without even16 the implied16   ////
//// warranty16 of MERCHANTABILITY16 or FITNESS16 FOR16 A PARTICULAR16      ////
//// PURPOSE16.  See the GNU16 Lesser16 General16 Public16 License16 for more ////
//// details16.                                                     ////
////                                                              ////
//// You should have received16 a copy of the GNU16 Lesser16 General16    ////
//// Public16 License16 along16 with this source16; if not, download16 it   ////
//// from http16://www16.opencores16.org16/lgpl16.shtml16                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines16.v"
`include "timescale.v"

module spi_shift16 (clk16, rst16, latch16, byte_sel16, len, lsb, go16,
                  pos_edge16, neg_edge16, rx_negedge16, tx_negedge16,
                  tip16, last, 
                  p_in16, p_out16, s_clk16, s_in16, s_out16);

  parameter Tp16 = 1;
  
  input                          clk16;          // system clock16
  input                          rst16;          // reset
  input                    [3:0] latch16;        // latch16 signal16 for storing16 the data in shift16 register
  input                    [3:0] byte_sel16;     // byte select16 signals16 for storing16 the data in shift16 register
  input [`SPI_CHAR_LEN_BITS16-1:0] len;          // data len in bits (minus16 one)
  input                          lsb;          // lbs16 first on the line
  input                          go16;           // start stansfer16
  input                          pos_edge16;     // recognize16 posedge of sclk16
  input                          neg_edge16;     // recognize16 negedge of sclk16
  input                          rx_negedge16;   // s_in16 is sampled16 on negative edge 
  input                          tx_negedge16;   // s_out16 is driven16 on negative edge
  output                         tip16;          // transfer16 in progress16
  output                         last;         // last bit
  input                   [31:0] p_in16;         // parallel16 in
  output     [`SPI_MAX_CHAR16-1:0] p_out16;        // parallel16 out
  input                          s_clk16;        // serial16 clock16
  input                          s_in16;         // serial16 in
  output                         s_out16;        // serial16 out
                                               
  reg                            s_out16;        
  reg                            tip16;
                              
  reg     [`SPI_CHAR_LEN_BITS16:0] cnt;          // data bit count
  reg        [`SPI_MAX_CHAR16-1:0] data;         // shift16 register
  wire    [`SPI_CHAR_LEN_BITS16:0] tx_bit_pos16;   // next bit position16
  wire    [`SPI_CHAR_LEN_BITS16:0] rx_bit_pos16;   // next bit position16
  wire                           rx_clk16;       // rx16 clock16 enable
  wire                           tx_clk16;       // tx16 clock16 enable
  
  assign p_out16 = data;
  
  assign tx_bit_pos16 = lsb ? {!(|len), len} - cnt : cnt - {{`SPI_CHAR_LEN_BITS16{1'b0}},1'b1};
  assign rx_bit_pos16 = lsb ? {!(|len), len} - (rx_negedge16 ? cnt + {{`SPI_CHAR_LEN_BITS16{1'b0}},1'b1} : cnt) : 
                            (rx_negedge16 ? cnt : cnt - {{`SPI_CHAR_LEN_BITS16{1'b0}},1'b1});
  
  assign last = !(|cnt);
  
  assign rx_clk16 = (rx_negedge16 ? neg_edge16 : pos_edge16) && (!last || s_clk16);
  assign tx_clk16 = (tx_negedge16 ? neg_edge16 : pos_edge16) && !last;
  
  // Character16 bit counter
  always @(posedge clk16 or posedge rst16)
  begin
    if(rst16)
      cnt <= #Tp16 {`SPI_CHAR_LEN_BITS16+1{1'b0}};
    else
      begin
        if(tip16)
          cnt <= #Tp16 pos_edge16 ? (cnt - {{`SPI_CHAR_LEN_BITS16{1'b0}}, 1'b1}) : cnt;
        else
          cnt <= #Tp16 !(|len) ? {1'b1, {`SPI_CHAR_LEN_BITS16{1'b0}}} : {1'b0, len};
      end
  end
  
  // Transfer16 in progress16
  always @(posedge clk16 or posedge rst16)
  begin
    if(rst16)
      tip16 <= #Tp16 1'b0;
  else if(go16 && ~tip16)
    tip16 <= #Tp16 1'b1;
  else if(tip16 && last && pos_edge16)
    tip16 <= #Tp16 1'b0;
  end
  
  // Sending16 bits to the line
  always @(posedge clk16 or posedge rst16)
  begin
    if (rst16)
      s_out16   <= #Tp16 1'b0;
    else
      s_out16 <= #Tp16 (tx_clk16 || !tip16) ? data[tx_bit_pos16[`SPI_CHAR_LEN_BITS16-1:0]] : s_out16;
  end
  
  // Receiving16 bits from the line
  always @(posedge clk16 or posedge rst16)
  begin
    if (rst16)
      data   <= #Tp16 {`SPI_MAX_CHAR16{1'b0}};
`ifdef SPI_MAX_CHAR_12816
    else if (latch16[0] && !tip16)
      begin
        if (byte_sel16[3])
          data[31:24] <= #Tp16 p_in16[31:24];
        if (byte_sel16[2])
          data[23:16] <= #Tp16 p_in16[23:16];
        if (byte_sel16[1])
          data[15:8] <= #Tp16 p_in16[15:8];
        if (byte_sel16[0])
          data[7:0] <= #Tp16 p_in16[7:0];
      end
    else if (latch16[1] && !tip16)
      begin
        if (byte_sel16[3])
          data[63:56] <= #Tp16 p_in16[31:24];
        if (byte_sel16[2])
          data[55:48] <= #Tp16 p_in16[23:16];
        if (byte_sel16[1])
          data[47:40] <= #Tp16 p_in16[15:8];
        if (byte_sel16[0])
          data[39:32] <= #Tp16 p_in16[7:0];
      end
    else if (latch16[2] && !tip16)
      begin
        if (byte_sel16[3])
          data[95:88] <= #Tp16 p_in16[31:24];
        if (byte_sel16[2])
          data[87:80] <= #Tp16 p_in16[23:16];
        if (byte_sel16[1])
          data[79:72] <= #Tp16 p_in16[15:8];
        if (byte_sel16[0])
          data[71:64] <= #Tp16 p_in16[7:0];
      end
    else if (latch16[3] && !tip16)
      begin
        if (byte_sel16[3])
          data[127:120] <= #Tp16 p_in16[31:24];
        if (byte_sel16[2])
          data[119:112] <= #Tp16 p_in16[23:16];
        if (byte_sel16[1])
          data[111:104] <= #Tp16 p_in16[15:8];
        if (byte_sel16[0])
          data[103:96] <= #Tp16 p_in16[7:0];
      end
`else
`ifdef SPI_MAX_CHAR_6416
    else if (latch16[0] && !tip16)
      begin
        if (byte_sel16[3])
          data[31:24] <= #Tp16 p_in16[31:24];
        if (byte_sel16[2])
          data[23:16] <= #Tp16 p_in16[23:16];
        if (byte_sel16[1])
          data[15:8] <= #Tp16 p_in16[15:8];
        if (byte_sel16[0])
          data[7:0] <= #Tp16 p_in16[7:0];
      end
    else if (latch16[1] && !tip16)
      begin
        if (byte_sel16[3])
          data[63:56] <= #Tp16 p_in16[31:24];
        if (byte_sel16[2])
          data[55:48] <= #Tp16 p_in16[23:16];
        if (byte_sel16[1])
          data[47:40] <= #Tp16 p_in16[15:8];
        if (byte_sel16[0])
          data[39:32] <= #Tp16 p_in16[7:0];
      end
`else
    else if (latch16[0] && !tip16)
      begin
      `ifdef SPI_MAX_CHAR_816
        if (byte_sel16[0])
          data[`SPI_MAX_CHAR16-1:0] <= #Tp16 p_in16[`SPI_MAX_CHAR16-1:0];
      `endif
      `ifdef SPI_MAX_CHAR_1616
        if (byte_sel16[0])
          data[7:0] <= #Tp16 p_in16[7:0];
        if (byte_sel16[1])
          data[`SPI_MAX_CHAR16-1:8] <= #Tp16 p_in16[`SPI_MAX_CHAR16-1:8];
      `endif
      `ifdef SPI_MAX_CHAR_2416
        if (byte_sel16[0])
          data[7:0] <= #Tp16 p_in16[7:0];
        if (byte_sel16[1])
          data[15:8] <= #Tp16 p_in16[15:8];
        if (byte_sel16[2])
          data[`SPI_MAX_CHAR16-1:16] <= #Tp16 p_in16[`SPI_MAX_CHAR16-1:16];
      `endif
      `ifdef SPI_MAX_CHAR_3216
        if (byte_sel16[0])
          data[7:0] <= #Tp16 p_in16[7:0];
        if (byte_sel16[1])
          data[15:8] <= #Tp16 p_in16[15:8];
        if (byte_sel16[2])
          data[23:16] <= #Tp16 p_in16[23:16];
        if (byte_sel16[3])
          data[`SPI_MAX_CHAR16-1:24] <= #Tp16 p_in16[`SPI_MAX_CHAR16-1:24];
      `endif
      end
`endif
`endif
    else
      data[rx_bit_pos16[`SPI_CHAR_LEN_BITS16-1:0]] <= #Tp16 rx_clk16 ? s_in16 : data[rx_bit_pos16[`SPI_CHAR_LEN_BITS16-1:0]];
  end
  
endmodule

