//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_shift20.v                                                 ////
////                                                              ////
////  This20 file is part of the SPI20 IP20 core20 project20                ////
////  http20://www20.opencores20.org20/projects20/spi20/                      ////
////                                                              ////
////  Author20(s):                                                  ////
////      - Simon20 Srot20 (simons20@opencores20.org20)                     ////
////                                                              ////
////  All additional20 information is avaliable20 in the Readme20.txt20   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright20 (C) 2002 Authors20                                   ////
////                                                              ////
//// This20 source20 file may be used and distributed20 without         ////
//// restriction20 provided that this copyright20 statement20 is not    ////
//// removed from the file and that any derivative20 work20 contains20  ////
//// the original copyright20 notice20 and the associated disclaimer20. ////
////                                                              ////
//// This20 source20 file is free software20; you can redistribute20 it   ////
//// and/or modify it under the terms20 of the GNU20 Lesser20 General20   ////
//// Public20 License20 as published20 by the Free20 Software20 Foundation20; ////
//// either20 version20 2.1 of the License20, or (at your20 option) any   ////
//// later20 version20.                                               ////
////                                                              ////
//// This20 source20 is distributed20 in the hope20 that it will be       ////
//// useful20, but WITHOUT20 ANY20 WARRANTY20; without even20 the implied20   ////
//// warranty20 of MERCHANTABILITY20 or FITNESS20 FOR20 A PARTICULAR20      ////
//// PURPOSE20.  See the GNU20 Lesser20 General20 Public20 License20 for more ////
//// details20.                                                     ////
////                                                              ////
//// You should have received20 a copy of the GNU20 Lesser20 General20    ////
//// Public20 License20 along20 with this source20; if not, download20 it   ////
//// from http20://www20.opencores20.org20/lgpl20.shtml20                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines20.v"
`include "timescale.v"

module spi_shift20 (clk20, rst20, latch20, byte_sel20, len, lsb, go20,
                  pos_edge20, neg_edge20, rx_negedge20, tx_negedge20,
                  tip20, last, 
                  p_in20, p_out20, s_clk20, s_in20, s_out20);

  parameter Tp20 = 1;
  
  input                          clk20;          // system clock20
  input                          rst20;          // reset
  input                    [3:0] latch20;        // latch20 signal20 for storing20 the data in shift20 register
  input                    [3:0] byte_sel20;     // byte select20 signals20 for storing20 the data in shift20 register
  input [`SPI_CHAR_LEN_BITS20-1:0] len;          // data len in bits (minus20 one)
  input                          lsb;          // lbs20 first on the line
  input                          go20;           // start stansfer20
  input                          pos_edge20;     // recognize20 posedge of sclk20
  input                          neg_edge20;     // recognize20 negedge of sclk20
  input                          rx_negedge20;   // s_in20 is sampled20 on negative edge 
  input                          tx_negedge20;   // s_out20 is driven20 on negative edge
  output                         tip20;          // transfer20 in progress20
  output                         last;         // last bit
  input                   [31:0] p_in20;         // parallel20 in
  output     [`SPI_MAX_CHAR20-1:0] p_out20;        // parallel20 out
  input                          s_clk20;        // serial20 clock20
  input                          s_in20;         // serial20 in
  output                         s_out20;        // serial20 out
                                               
  reg                            s_out20;        
  reg                            tip20;
                              
  reg     [`SPI_CHAR_LEN_BITS20:0] cnt;          // data bit count
  reg        [`SPI_MAX_CHAR20-1:0] data;         // shift20 register
  wire    [`SPI_CHAR_LEN_BITS20:0] tx_bit_pos20;   // next bit position20
  wire    [`SPI_CHAR_LEN_BITS20:0] rx_bit_pos20;   // next bit position20
  wire                           rx_clk20;       // rx20 clock20 enable
  wire                           tx_clk20;       // tx20 clock20 enable
  
  assign p_out20 = data;
  
  assign tx_bit_pos20 = lsb ? {!(|len), len} - cnt : cnt - {{`SPI_CHAR_LEN_BITS20{1'b0}},1'b1};
  assign rx_bit_pos20 = lsb ? {!(|len), len} - (rx_negedge20 ? cnt + {{`SPI_CHAR_LEN_BITS20{1'b0}},1'b1} : cnt) : 
                            (rx_negedge20 ? cnt : cnt - {{`SPI_CHAR_LEN_BITS20{1'b0}},1'b1});
  
  assign last = !(|cnt);
  
  assign rx_clk20 = (rx_negedge20 ? neg_edge20 : pos_edge20) && (!last || s_clk20);
  assign tx_clk20 = (tx_negedge20 ? neg_edge20 : pos_edge20) && !last;
  
  // Character20 bit counter
  always @(posedge clk20 or posedge rst20)
  begin
    if(rst20)
      cnt <= #Tp20 {`SPI_CHAR_LEN_BITS20+1{1'b0}};
    else
      begin
        if(tip20)
          cnt <= #Tp20 pos_edge20 ? (cnt - {{`SPI_CHAR_LEN_BITS20{1'b0}}, 1'b1}) : cnt;
        else
          cnt <= #Tp20 !(|len) ? {1'b1, {`SPI_CHAR_LEN_BITS20{1'b0}}} : {1'b0, len};
      end
  end
  
  // Transfer20 in progress20
  always @(posedge clk20 or posedge rst20)
  begin
    if(rst20)
      tip20 <= #Tp20 1'b0;
  else if(go20 && ~tip20)
    tip20 <= #Tp20 1'b1;
  else if(tip20 && last && pos_edge20)
    tip20 <= #Tp20 1'b0;
  end
  
  // Sending20 bits to the line
  always @(posedge clk20 or posedge rst20)
  begin
    if (rst20)
      s_out20   <= #Tp20 1'b0;
    else
      s_out20 <= #Tp20 (tx_clk20 || !tip20) ? data[tx_bit_pos20[`SPI_CHAR_LEN_BITS20-1:0]] : s_out20;
  end
  
  // Receiving20 bits from the line
  always @(posedge clk20 or posedge rst20)
  begin
    if (rst20)
      data   <= #Tp20 {`SPI_MAX_CHAR20{1'b0}};
`ifdef SPI_MAX_CHAR_12820
    else if (latch20[0] && !tip20)
      begin
        if (byte_sel20[3])
          data[31:24] <= #Tp20 p_in20[31:24];
        if (byte_sel20[2])
          data[23:16] <= #Tp20 p_in20[23:16];
        if (byte_sel20[1])
          data[15:8] <= #Tp20 p_in20[15:8];
        if (byte_sel20[0])
          data[7:0] <= #Tp20 p_in20[7:0];
      end
    else if (latch20[1] && !tip20)
      begin
        if (byte_sel20[3])
          data[63:56] <= #Tp20 p_in20[31:24];
        if (byte_sel20[2])
          data[55:48] <= #Tp20 p_in20[23:16];
        if (byte_sel20[1])
          data[47:40] <= #Tp20 p_in20[15:8];
        if (byte_sel20[0])
          data[39:32] <= #Tp20 p_in20[7:0];
      end
    else if (latch20[2] && !tip20)
      begin
        if (byte_sel20[3])
          data[95:88] <= #Tp20 p_in20[31:24];
        if (byte_sel20[2])
          data[87:80] <= #Tp20 p_in20[23:16];
        if (byte_sel20[1])
          data[79:72] <= #Tp20 p_in20[15:8];
        if (byte_sel20[0])
          data[71:64] <= #Tp20 p_in20[7:0];
      end
    else if (latch20[3] && !tip20)
      begin
        if (byte_sel20[3])
          data[127:120] <= #Tp20 p_in20[31:24];
        if (byte_sel20[2])
          data[119:112] <= #Tp20 p_in20[23:16];
        if (byte_sel20[1])
          data[111:104] <= #Tp20 p_in20[15:8];
        if (byte_sel20[0])
          data[103:96] <= #Tp20 p_in20[7:0];
      end
`else
`ifdef SPI_MAX_CHAR_6420
    else if (latch20[0] && !tip20)
      begin
        if (byte_sel20[3])
          data[31:24] <= #Tp20 p_in20[31:24];
        if (byte_sel20[2])
          data[23:16] <= #Tp20 p_in20[23:16];
        if (byte_sel20[1])
          data[15:8] <= #Tp20 p_in20[15:8];
        if (byte_sel20[0])
          data[7:0] <= #Tp20 p_in20[7:0];
      end
    else if (latch20[1] && !tip20)
      begin
        if (byte_sel20[3])
          data[63:56] <= #Tp20 p_in20[31:24];
        if (byte_sel20[2])
          data[55:48] <= #Tp20 p_in20[23:16];
        if (byte_sel20[1])
          data[47:40] <= #Tp20 p_in20[15:8];
        if (byte_sel20[0])
          data[39:32] <= #Tp20 p_in20[7:0];
      end
`else
    else if (latch20[0] && !tip20)
      begin
      `ifdef SPI_MAX_CHAR_820
        if (byte_sel20[0])
          data[`SPI_MAX_CHAR20-1:0] <= #Tp20 p_in20[`SPI_MAX_CHAR20-1:0];
      `endif
      `ifdef SPI_MAX_CHAR_1620
        if (byte_sel20[0])
          data[7:0] <= #Tp20 p_in20[7:0];
        if (byte_sel20[1])
          data[`SPI_MAX_CHAR20-1:8] <= #Tp20 p_in20[`SPI_MAX_CHAR20-1:8];
      `endif
      `ifdef SPI_MAX_CHAR_2420
        if (byte_sel20[0])
          data[7:0] <= #Tp20 p_in20[7:0];
        if (byte_sel20[1])
          data[15:8] <= #Tp20 p_in20[15:8];
        if (byte_sel20[2])
          data[`SPI_MAX_CHAR20-1:16] <= #Tp20 p_in20[`SPI_MAX_CHAR20-1:16];
      `endif
      `ifdef SPI_MAX_CHAR_3220
        if (byte_sel20[0])
          data[7:0] <= #Tp20 p_in20[7:0];
        if (byte_sel20[1])
          data[15:8] <= #Tp20 p_in20[15:8];
        if (byte_sel20[2])
          data[23:16] <= #Tp20 p_in20[23:16];
        if (byte_sel20[3])
          data[`SPI_MAX_CHAR20-1:24] <= #Tp20 p_in20[`SPI_MAX_CHAR20-1:24];
      `endif
      end
`endif
`endif
    else
      data[rx_bit_pos20[`SPI_CHAR_LEN_BITS20-1:0]] <= #Tp20 rx_clk20 ? s_in20 : data[rx_bit_pos20[`SPI_CHAR_LEN_BITS20-1:0]];
  end
  
endmodule

