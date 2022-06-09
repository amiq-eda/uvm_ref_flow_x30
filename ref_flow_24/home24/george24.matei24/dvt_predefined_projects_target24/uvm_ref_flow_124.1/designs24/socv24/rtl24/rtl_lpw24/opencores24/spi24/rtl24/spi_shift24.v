//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_shift24.v                                                 ////
////                                                              ////
////  This24 file is part of the SPI24 IP24 core24 project24                ////
////  http24://www24.opencores24.org24/projects24/spi24/                      ////
////                                                              ////
////  Author24(s):                                                  ////
////      - Simon24 Srot24 (simons24@opencores24.org24)                     ////
////                                                              ////
////  All additional24 information is avaliable24 in the Readme24.txt24   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright24 (C) 2002 Authors24                                   ////
////                                                              ////
//// This24 source24 file may be used and distributed24 without         ////
//// restriction24 provided that this copyright24 statement24 is not    ////
//// removed from the file and that any derivative24 work24 contains24  ////
//// the original copyright24 notice24 and the associated disclaimer24. ////
////                                                              ////
//// This24 source24 file is free software24; you can redistribute24 it   ////
//// and/or modify it under the terms24 of the GNU24 Lesser24 General24   ////
//// Public24 License24 as published24 by the Free24 Software24 Foundation24; ////
//// either24 version24 2.1 of the License24, or (at your24 option) any   ////
//// later24 version24.                                               ////
////                                                              ////
//// This24 source24 is distributed24 in the hope24 that it will be       ////
//// useful24, but WITHOUT24 ANY24 WARRANTY24; without even24 the implied24   ////
//// warranty24 of MERCHANTABILITY24 or FITNESS24 FOR24 A PARTICULAR24      ////
//// PURPOSE24.  See the GNU24 Lesser24 General24 Public24 License24 for more ////
//// details24.                                                     ////
////                                                              ////
//// You should have received24 a copy of the GNU24 Lesser24 General24    ////
//// Public24 License24 along24 with this source24; if not, download24 it   ////
//// from http24://www24.opencores24.org24/lgpl24.shtml24                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines24.v"
`include "timescale.v"

module spi_shift24 (clk24, rst24, latch24, byte_sel24, len, lsb, go24,
                  pos_edge24, neg_edge24, rx_negedge24, tx_negedge24,
                  tip24, last, 
                  p_in24, p_out24, s_clk24, s_in24, s_out24);

  parameter Tp24 = 1;
  
  input                          clk24;          // system clock24
  input                          rst24;          // reset
  input                    [3:0] latch24;        // latch24 signal24 for storing24 the data in shift24 register
  input                    [3:0] byte_sel24;     // byte select24 signals24 for storing24 the data in shift24 register
  input [`SPI_CHAR_LEN_BITS24-1:0] len;          // data len in bits (minus24 one)
  input                          lsb;          // lbs24 first on the line
  input                          go24;           // start stansfer24
  input                          pos_edge24;     // recognize24 posedge of sclk24
  input                          neg_edge24;     // recognize24 negedge of sclk24
  input                          rx_negedge24;   // s_in24 is sampled24 on negative edge 
  input                          tx_negedge24;   // s_out24 is driven24 on negative edge
  output                         tip24;          // transfer24 in progress24
  output                         last;         // last bit
  input                   [31:0] p_in24;         // parallel24 in
  output     [`SPI_MAX_CHAR24-1:0] p_out24;        // parallel24 out
  input                          s_clk24;        // serial24 clock24
  input                          s_in24;         // serial24 in
  output                         s_out24;        // serial24 out
                                               
  reg                            s_out24;        
  reg                            tip24;
                              
  reg     [`SPI_CHAR_LEN_BITS24:0] cnt;          // data bit count
  reg        [`SPI_MAX_CHAR24-1:0] data;         // shift24 register
  wire    [`SPI_CHAR_LEN_BITS24:0] tx_bit_pos24;   // next bit position24
  wire    [`SPI_CHAR_LEN_BITS24:0] rx_bit_pos24;   // next bit position24
  wire                           rx_clk24;       // rx24 clock24 enable
  wire                           tx_clk24;       // tx24 clock24 enable
  
  assign p_out24 = data;
  
  assign tx_bit_pos24 = lsb ? {!(|len), len} - cnt : cnt - {{`SPI_CHAR_LEN_BITS24{1'b0}},1'b1};
  assign rx_bit_pos24 = lsb ? {!(|len), len} - (rx_negedge24 ? cnt + {{`SPI_CHAR_LEN_BITS24{1'b0}},1'b1} : cnt) : 
                            (rx_negedge24 ? cnt : cnt - {{`SPI_CHAR_LEN_BITS24{1'b0}},1'b1});
  
  assign last = !(|cnt);
  
  assign rx_clk24 = (rx_negedge24 ? neg_edge24 : pos_edge24) && (!last || s_clk24);
  assign tx_clk24 = (tx_negedge24 ? neg_edge24 : pos_edge24) && !last;
  
  // Character24 bit counter
  always @(posedge clk24 or posedge rst24)
  begin
    if(rst24)
      cnt <= #Tp24 {`SPI_CHAR_LEN_BITS24+1{1'b0}};
    else
      begin
        if(tip24)
          cnt <= #Tp24 pos_edge24 ? (cnt - {{`SPI_CHAR_LEN_BITS24{1'b0}}, 1'b1}) : cnt;
        else
          cnt <= #Tp24 !(|len) ? {1'b1, {`SPI_CHAR_LEN_BITS24{1'b0}}} : {1'b0, len};
      end
  end
  
  // Transfer24 in progress24
  always @(posedge clk24 or posedge rst24)
  begin
    if(rst24)
      tip24 <= #Tp24 1'b0;
  else if(go24 && ~tip24)
    tip24 <= #Tp24 1'b1;
  else if(tip24 && last && pos_edge24)
    tip24 <= #Tp24 1'b0;
  end
  
  // Sending24 bits to the line
  always @(posedge clk24 or posedge rst24)
  begin
    if (rst24)
      s_out24   <= #Tp24 1'b0;
    else
      s_out24 <= #Tp24 (tx_clk24 || !tip24) ? data[tx_bit_pos24[`SPI_CHAR_LEN_BITS24-1:0]] : s_out24;
  end
  
  // Receiving24 bits from the line
  always @(posedge clk24 or posedge rst24)
  begin
    if (rst24)
      data   <= #Tp24 {`SPI_MAX_CHAR24{1'b0}};
`ifdef SPI_MAX_CHAR_12824
    else if (latch24[0] && !tip24)
      begin
        if (byte_sel24[3])
          data[31:24] <= #Tp24 p_in24[31:24];
        if (byte_sel24[2])
          data[23:16] <= #Tp24 p_in24[23:16];
        if (byte_sel24[1])
          data[15:8] <= #Tp24 p_in24[15:8];
        if (byte_sel24[0])
          data[7:0] <= #Tp24 p_in24[7:0];
      end
    else if (latch24[1] && !tip24)
      begin
        if (byte_sel24[3])
          data[63:56] <= #Tp24 p_in24[31:24];
        if (byte_sel24[2])
          data[55:48] <= #Tp24 p_in24[23:16];
        if (byte_sel24[1])
          data[47:40] <= #Tp24 p_in24[15:8];
        if (byte_sel24[0])
          data[39:32] <= #Tp24 p_in24[7:0];
      end
    else if (latch24[2] && !tip24)
      begin
        if (byte_sel24[3])
          data[95:88] <= #Tp24 p_in24[31:24];
        if (byte_sel24[2])
          data[87:80] <= #Tp24 p_in24[23:16];
        if (byte_sel24[1])
          data[79:72] <= #Tp24 p_in24[15:8];
        if (byte_sel24[0])
          data[71:64] <= #Tp24 p_in24[7:0];
      end
    else if (latch24[3] && !tip24)
      begin
        if (byte_sel24[3])
          data[127:120] <= #Tp24 p_in24[31:24];
        if (byte_sel24[2])
          data[119:112] <= #Tp24 p_in24[23:16];
        if (byte_sel24[1])
          data[111:104] <= #Tp24 p_in24[15:8];
        if (byte_sel24[0])
          data[103:96] <= #Tp24 p_in24[7:0];
      end
`else
`ifdef SPI_MAX_CHAR_6424
    else if (latch24[0] && !tip24)
      begin
        if (byte_sel24[3])
          data[31:24] <= #Tp24 p_in24[31:24];
        if (byte_sel24[2])
          data[23:16] <= #Tp24 p_in24[23:16];
        if (byte_sel24[1])
          data[15:8] <= #Tp24 p_in24[15:8];
        if (byte_sel24[0])
          data[7:0] <= #Tp24 p_in24[7:0];
      end
    else if (latch24[1] && !tip24)
      begin
        if (byte_sel24[3])
          data[63:56] <= #Tp24 p_in24[31:24];
        if (byte_sel24[2])
          data[55:48] <= #Tp24 p_in24[23:16];
        if (byte_sel24[1])
          data[47:40] <= #Tp24 p_in24[15:8];
        if (byte_sel24[0])
          data[39:32] <= #Tp24 p_in24[7:0];
      end
`else
    else if (latch24[0] && !tip24)
      begin
      `ifdef SPI_MAX_CHAR_824
        if (byte_sel24[0])
          data[`SPI_MAX_CHAR24-1:0] <= #Tp24 p_in24[`SPI_MAX_CHAR24-1:0];
      `endif
      `ifdef SPI_MAX_CHAR_1624
        if (byte_sel24[0])
          data[7:0] <= #Tp24 p_in24[7:0];
        if (byte_sel24[1])
          data[`SPI_MAX_CHAR24-1:8] <= #Tp24 p_in24[`SPI_MAX_CHAR24-1:8];
      `endif
      `ifdef SPI_MAX_CHAR_2424
        if (byte_sel24[0])
          data[7:0] <= #Tp24 p_in24[7:0];
        if (byte_sel24[1])
          data[15:8] <= #Tp24 p_in24[15:8];
        if (byte_sel24[2])
          data[`SPI_MAX_CHAR24-1:16] <= #Tp24 p_in24[`SPI_MAX_CHAR24-1:16];
      `endif
      `ifdef SPI_MAX_CHAR_3224
        if (byte_sel24[0])
          data[7:0] <= #Tp24 p_in24[7:0];
        if (byte_sel24[1])
          data[15:8] <= #Tp24 p_in24[15:8];
        if (byte_sel24[2])
          data[23:16] <= #Tp24 p_in24[23:16];
        if (byte_sel24[3])
          data[`SPI_MAX_CHAR24-1:24] <= #Tp24 p_in24[`SPI_MAX_CHAR24-1:24];
      `endif
      end
`endif
`endif
    else
      data[rx_bit_pos24[`SPI_CHAR_LEN_BITS24-1:0]] <= #Tp24 rx_clk24 ? s_in24 : data[rx_bit_pos24[`SPI_CHAR_LEN_BITS24-1:0]];
  end
  
endmodule

