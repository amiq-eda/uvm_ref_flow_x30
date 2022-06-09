//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_shift6.v                                                 ////
////                                                              ////
////  This6 file is part of the SPI6 IP6 core6 project6                ////
////  http6://www6.opencores6.org6/projects6/spi6/                      ////
////                                                              ////
////  Author6(s):                                                  ////
////      - Simon6 Srot6 (simons6@opencores6.org6)                     ////
////                                                              ////
////  All additional6 information is avaliable6 in the Readme6.txt6   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright6 (C) 2002 Authors6                                   ////
////                                                              ////
//// This6 source6 file may be used and distributed6 without         ////
//// restriction6 provided that this copyright6 statement6 is not    ////
//// removed from the file and that any derivative6 work6 contains6  ////
//// the original copyright6 notice6 and the associated disclaimer6. ////
////                                                              ////
//// This6 source6 file is free software6; you can redistribute6 it   ////
//// and/or modify it under the terms6 of the GNU6 Lesser6 General6   ////
//// Public6 License6 as published6 by the Free6 Software6 Foundation6; ////
//// either6 version6 2.1 of the License6, or (at your6 option) any   ////
//// later6 version6.                                               ////
////                                                              ////
//// This6 source6 is distributed6 in the hope6 that it will be       ////
//// useful6, but WITHOUT6 ANY6 WARRANTY6; without even6 the implied6   ////
//// warranty6 of MERCHANTABILITY6 or FITNESS6 FOR6 A PARTICULAR6      ////
//// PURPOSE6.  See the GNU6 Lesser6 General6 Public6 License6 for more ////
//// details6.                                                     ////
////                                                              ////
//// You should have received6 a copy of the GNU6 Lesser6 General6    ////
//// Public6 License6 along6 with this source6; if not, download6 it   ////
//// from http6://www6.opencores6.org6/lgpl6.shtml6                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines6.v"
`include "timescale.v"

module spi_shift6 (clk6, rst6, latch6, byte_sel6, len, lsb, go6,
                  pos_edge6, neg_edge6, rx_negedge6, tx_negedge6,
                  tip6, last, 
                  p_in6, p_out6, s_clk6, s_in6, s_out6);

  parameter Tp6 = 1;
  
  input                          clk6;          // system clock6
  input                          rst6;          // reset
  input                    [3:0] latch6;        // latch6 signal6 for storing6 the data in shift6 register
  input                    [3:0] byte_sel6;     // byte select6 signals6 for storing6 the data in shift6 register
  input [`SPI_CHAR_LEN_BITS6-1:0] len;          // data len in bits (minus6 one)
  input                          lsb;          // lbs6 first on the line
  input                          go6;           // start stansfer6
  input                          pos_edge6;     // recognize6 posedge of sclk6
  input                          neg_edge6;     // recognize6 negedge of sclk6
  input                          rx_negedge6;   // s_in6 is sampled6 on negative edge 
  input                          tx_negedge6;   // s_out6 is driven6 on negative edge
  output                         tip6;          // transfer6 in progress6
  output                         last;         // last bit
  input                   [31:0] p_in6;         // parallel6 in
  output     [`SPI_MAX_CHAR6-1:0] p_out6;        // parallel6 out
  input                          s_clk6;        // serial6 clock6
  input                          s_in6;         // serial6 in
  output                         s_out6;        // serial6 out
                                               
  reg                            s_out6;        
  reg                            tip6;
                              
  reg     [`SPI_CHAR_LEN_BITS6:0] cnt;          // data bit count
  reg        [`SPI_MAX_CHAR6-1:0] data;         // shift6 register
  wire    [`SPI_CHAR_LEN_BITS6:0] tx_bit_pos6;   // next bit position6
  wire    [`SPI_CHAR_LEN_BITS6:0] rx_bit_pos6;   // next bit position6
  wire                           rx_clk6;       // rx6 clock6 enable
  wire                           tx_clk6;       // tx6 clock6 enable
  
  assign p_out6 = data;
  
  assign tx_bit_pos6 = lsb ? {!(|len), len} - cnt : cnt - {{`SPI_CHAR_LEN_BITS6{1'b0}},1'b1};
  assign rx_bit_pos6 = lsb ? {!(|len), len} - (rx_negedge6 ? cnt + {{`SPI_CHAR_LEN_BITS6{1'b0}},1'b1} : cnt) : 
                            (rx_negedge6 ? cnt : cnt - {{`SPI_CHAR_LEN_BITS6{1'b0}},1'b1});
  
  assign last = !(|cnt);
  
  assign rx_clk6 = (rx_negedge6 ? neg_edge6 : pos_edge6) && (!last || s_clk6);
  assign tx_clk6 = (tx_negedge6 ? neg_edge6 : pos_edge6) && !last;
  
  // Character6 bit counter
  always @(posedge clk6 or posedge rst6)
  begin
    if(rst6)
      cnt <= #Tp6 {`SPI_CHAR_LEN_BITS6+1{1'b0}};
    else
      begin
        if(tip6)
          cnt <= #Tp6 pos_edge6 ? (cnt - {{`SPI_CHAR_LEN_BITS6{1'b0}}, 1'b1}) : cnt;
        else
          cnt <= #Tp6 !(|len) ? {1'b1, {`SPI_CHAR_LEN_BITS6{1'b0}}} : {1'b0, len};
      end
  end
  
  // Transfer6 in progress6
  always @(posedge clk6 or posedge rst6)
  begin
    if(rst6)
      tip6 <= #Tp6 1'b0;
  else if(go6 && ~tip6)
    tip6 <= #Tp6 1'b1;
  else if(tip6 && last && pos_edge6)
    tip6 <= #Tp6 1'b0;
  end
  
  // Sending6 bits to the line
  always @(posedge clk6 or posedge rst6)
  begin
    if (rst6)
      s_out6   <= #Tp6 1'b0;
    else
      s_out6 <= #Tp6 (tx_clk6 || !tip6) ? data[tx_bit_pos6[`SPI_CHAR_LEN_BITS6-1:0]] : s_out6;
  end
  
  // Receiving6 bits from the line
  always @(posedge clk6 or posedge rst6)
  begin
    if (rst6)
      data   <= #Tp6 {`SPI_MAX_CHAR6{1'b0}};
`ifdef SPI_MAX_CHAR_1286
    else if (latch6[0] && !tip6)
      begin
        if (byte_sel6[3])
          data[31:24] <= #Tp6 p_in6[31:24];
        if (byte_sel6[2])
          data[23:16] <= #Tp6 p_in6[23:16];
        if (byte_sel6[1])
          data[15:8] <= #Tp6 p_in6[15:8];
        if (byte_sel6[0])
          data[7:0] <= #Tp6 p_in6[7:0];
      end
    else if (latch6[1] && !tip6)
      begin
        if (byte_sel6[3])
          data[63:56] <= #Tp6 p_in6[31:24];
        if (byte_sel6[2])
          data[55:48] <= #Tp6 p_in6[23:16];
        if (byte_sel6[1])
          data[47:40] <= #Tp6 p_in6[15:8];
        if (byte_sel6[0])
          data[39:32] <= #Tp6 p_in6[7:0];
      end
    else if (latch6[2] && !tip6)
      begin
        if (byte_sel6[3])
          data[95:88] <= #Tp6 p_in6[31:24];
        if (byte_sel6[2])
          data[87:80] <= #Tp6 p_in6[23:16];
        if (byte_sel6[1])
          data[79:72] <= #Tp6 p_in6[15:8];
        if (byte_sel6[0])
          data[71:64] <= #Tp6 p_in6[7:0];
      end
    else if (latch6[3] && !tip6)
      begin
        if (byte_sel6[3])
          data[127:120] <= #Tp6 p_in6[31:24];
        if (byte_sel6[2])
          data[119:112] <= #Tp6 p_in6[23:16];
        if (byte_sel6[1])
          data[111:104] <= #Tp6 p_in6[15:8];
        if (byte_sel6[0])
          data[103:96] <= #Tp6 p_in6[7:0];
      end
`else
`ifdef SPI_MAX_CHAR_646
    else if (latch6[0] && !tip6)
      begin
        if (byte_sel6[3])
          data[31:24] <= #Tp6 p_in6[31:24];
        if (byte_sel6[2])
          data[23:16] <= #Tp6 p_in6[23:16];
        if (byte_sel6[1])
          data[15:8] <= #Tp6 p_in6[15:8];
        if (byte_sel6[0])
          data[7:0] <= #Tp6 p_in6[7:0];
      end
    else if (latch6[1] && !tip6)
      begin
        if (byte_sel6[3])
          data[63:56] <= #Tp6 p_in6[31:24];
        if (byte_sel6[2])
          data[55:48] <= #Tp6 p_in6[23:16];
        if (byte_sel6[1])
          data[47:40] <= #Tp6 p_in6[15:8];
        if (byte_sel6[0])
          data[39:32] <= #Tp6 p_in6[7:0];
      end
`else
    else if (latch6[0] && !tip6)
      begin
      `ifdef SPI_MAX_CHAR_86
        if (byte_sel6[0])
          data[`SPI_MAX_CHAR6-1:0] <= #Tp6 p_in6[`SPI_MAX_CHAR6-1:0];
      `endif
      `ifdef SPI_MAX_CHAR_166
        if (byte_sel6[0])
          data[7:0] <= #Tp6 p_in6[7:0];
        if (byte_sel6[1])
          data[`SPI_MAX_CHAR6-1:8] <= #Tp6 p_in6[`SPI_MAX_CHAR6-1:8];
      `endif
      `ifdef SPI_MAX_CHAR_246
        if (byte_sel6[0])
          data[7:0] <= #Tp6 p_in6[7:0];
        if (byte_sel6[1])
          data[15:8] <= #Tp6 p_in6[15:8];
        if (byte_sel6[2])
          data[`SPI_MAX_CHAR6-1:16] <= #Tp6 p_in6[`SPI_MAX_CHAR6-1:16];
      `endif
      `ifdef SPI_MAX_CHAR_326
        if (byte_sel6[0])
          data[7:0] <= #Tp6 p_in6[7:0];
        if (byte_sel6[1])
          data[15:8] <= #Tp6 p_in6[15:8];
        if (byte_sel6[2])
          data[23:16] <= #Tp6 p_in6[23:16];
        if (byte_sel6[3])
          data[`SPI_MAX_CHAR6-1:24] <= #Tp6 p_in6[`SPI_MAX_CHAR6-1:24];
      `endif
      end
`endif
`endif
    else
      data[rx_bit_pos6[`SPI_CHAR_LEN_BITS6-1:0]] <= #Tp6 rx_clk6 ? s_in6 : data[rx_bit_pos6[`SPI_CHAR_LEN_BITS6-1:0]];
  end
  
endmodule

