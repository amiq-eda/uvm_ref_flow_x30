//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_shift14.v                                                 ////
////                                                              ////
////  This14 file is part of the SPI14 IP14 core14 project14                ////
////  http14://www14.opencores14.org14/projects14/spi14/                      ////
////                                                              ////
////  Author14(s):                                                  ////
////      - Simon14 Srot14 (simons14@opencores14.org14)                     ////
////                                                              ////
////  All additional14 information is avaliable14 in the Readme14.txt14   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright14 (C) 2002 Authors14                                   ////
////                                                              ////
//// This14 source14 file may be used and distributed14 without         ////
//// restriction14 provided that this copyright14 statement14 is not    ////
//// removed from the file and that any derivative14 work14 contains14  ////
//// the original copyright14 notice14 and the associated disclaimer14. ////
////                                                              ////
//// This14 source14 file is free software14; you can redistribute14 it   ////
//// and/or modify it under the terms14 of the GNU14 Lesser14 General14   ////
//// Public14 License14 as published14 by the Free14 Software14 Foundation14; ////
//// either14 version14 2.1 of the License14, or (at your14 option) any   ////
//// later14 version14.                                               ////
////                                                              ////
//// This14 source14 is distributed14 in the hope14 that it will be       ////
//// useful14, but WITHOUT14 ANY14 WARRANTY14; without even14 the implied14   ////
//// warranty14 of MERCHANTABILITY14 or FITNESS14 FOR14 A PARTICULAR14      ////
//// PURPOSE14.  See the GNU14 Lesser14 General14 Public14 License14 for more ////
//// details14.                                                     ////
////                                                              ////
//// You should have received14 a copy of the GNU14 Lesser14 General14    ////
//// Public14 License14 along14 with this source14; if not, download14 it   ////
//// from http14://www14.opencores14.org14/lgpl14.shtml14                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines14.v"
`include "timescale.v"

module spi_shift14 (clk14, rst14, latch14, byte_sel14, len, lsb, go14,
                  pos_edge14, neg_edge14, rx_negedge14, tx_negedge14,
                  tip14, last, 
                  p_in14, p_out14, s_clk14, s_in14, s_out14);

  parameter Tp14 = 1;
  
  input                          clk14;          // system clock14
  input                          rst14;          // reset
  input                    [3:0] latch14;        // latch14 signal14 for storing14 the data in shift14 register
  input                    [3:0] byte_sel14;     // byte select14 signals14 for storing14 the data in shift14 register
  input [`SPI_CHAR_LEN_BITS14-1:0] len;          // data len in bits (minus14 one)
  input                          lsb;          // lbs14 first on the line
  input                          go14;           // start stansfer14
  input                          pos_edge14;     // recognize14 posedge of sclk14
  input                          neg_edge14;     // recognize14 negedge of sclk14
  input                          rx_negedge14;   // s_in14 is sampled14 on negative edge 
  input                          tx_negedge14;   // s_out14 is driven14 on negative edge
  output                         tip14;          // transfer14 in progress14
  output                         last;         // last bit
  input                   [31:0] p_in14;         // parallel14 in
  output     [`SPI_MAX_CHAR14-1:0] p_out14;        // parallel14 out
  input                          s_clk14;        // serial14 clock14
  input                          s_in14;         // serial14 in
  output                         s_out14;        // serial14 out
                                               
  reg                            s_out14;        
  reg                            tip14;
                              
  reg     [`SPI_CHAR_LEN_BITS14:0] cnt;          // data bit count
  reg        [`SPI_MAX_CHAR14-1:0] data;         // shift14 register
  wire    [`SPI_CHAR_LEN_BITS14:0] tx_bit_pos14;   // next bit position14
  wire    [`SPI_CHAR_LEN_BITS14:0] rx_bit_pos14;   // next bit position14
  wire                           rx_clk14;       // rx14 clock14 enable
  wire                           tx_clk14;       // tx14 clock14 enable
  
  assign p_out14 = data;
  
  assign tx_bit_pos14 = lsb ? {!(|len), len} - cnt : cnt - {{`SPI_CHAR_LEN_BITS14{1'b0}},1'b1};
  assign rx_bit_pos14 = lsb ? {!(|len), len} - (rx_negedge14 ? cnt + {{`SPI_CHAR_LEN_BITS14{1'b0}},1'b1} : cnt) : 
                            (rx_negedge14 ? cnt : cnt - {{`SPI_CHAR_LEN_BITS14{1'b0}},1'b1});
  
  assign last = !(|cnt);
  
  assign rx_clk14 = (rx_negedge14 ? neg_edge14 : pos_edge14) && (!last || s_clk14);
  assign tx_clk14 = (tx_negedge14 ? neg_edge14 : pos_edge14) && !last;
  
  // Character14 bit counter
  always @(posedge clk14 or posedge rst14)
  begin
    if(rst14)
      cnt <= #Tp14 {`SPI_CHAR_LEN_BITS14+1{1'b0}};
    else
      begin
        if(tip14)
          cnt <= #Tp14 pos_edge14 ? (cnt - {{`SPI_CHAR_LEN_BITS14{1'b0}}, 1'b1}) : cnt;
        else
          cnt <= #Tp14 !(|len) ? {1'b1, {`SPI_CHAR_LEN_BITS14{1'b0}}} : {1'b0, len};
      end
  end
  
  // Transfer14 in progress14
  always @(posedge clk14 or posedge rst14)
  begin
    if(rst14)
      tip14 <= #Tp14 1'b0;
  else if(go14 && ~tip14)
    tip14 <= #Tp14 1'b1;
  else if(tip14 && last && pos_edge14)
    tip14 <= #Tp14 1'b0;
  end
  
  // Sending14 bits to the line
  always @(posedge clk14 or posedge rst14)
  begin
    if (rst14)
      s_out14   <= #Tp14 1'b0;
    else
      s_out14 <= #Tp14 (tx_clk14 || !tip14) ? data[tx_bit_pos14[`SPI_CHAR_LEN_BITS14-1:0]] : s_out14;
  end
  
  // Receiving14 bits from the line
  always @(posedge clk14 or posedge rst14)
  begin
    if (rst14)
      data   <= #Tp14 {`SPI_MAX_CHAR14{1'b0}};
`ifdef SPI_MAX_CHAR_12814
    else if (latch14[0] && !tip14)
      begin
        if (byte_sel14[3])
          data[31:24] <= #Tp14 p_in14[31:24];
        if (byte_sel14[2])
          data[23:16] <= #Tp14 p_in14[23:16];
        if (byte_sel14[1])
          data[15:8] <= #Tp14 p_in14[15:8];
        if (byte_sel14[0])
          data[7:0] <= #Tp14 p_in14[7:0];
      end
    else if (latch14[1] && !tip14)
      begin
        if (byte_sel14[3])
          data[63:56] <= #Tp14 p_in14[31:24];
        if (byte_sel14[2])
          data[55:48] <= #Tp14 p_in14[23:16];
        if (byte_sel14[1])
          data[47:40] <= #Tp14 p_in14[15:8];
        if (byte_sel14[0])
          data[39:32] <= #Tp14 p_in14[7:0];
      end
    else if (latch14[2] && !tip14)
      begin
        if (byte_sel14[3])
          data[95:88] <= #Tp14 p_in14[31:24];
        if (byte_sel14[2])
          data[87:80] <= #Tp14 p_in14[23:16];
        if (byte_sel14[1])
          data[79:72] <= #Tp14 p_in14[15:8];
        if (byte_sel14[0])
          data[71:64] <= #Tp14 p_in14[7:0];
      end
    else if (latch14[3] && !tip14)
      begin
        if (byte_sel14[3])
          data[127:120] <= #Tp14 p_in14[31:24];
        if (byte_sel14[2])
          data[119:112] <= #Tp14 p_in14[23:16];
        if (byte_sel14[1])
          data[111:104] <= #Tp14 p_in14[15:8];
        if (byte_sel14[0])
          data[103:96] <= #Tp14 p_in14[7:0];
      end
`else
`ifdef SPI_MAX_CHAR_6414
    else if (latch14[0] && !tip14)
      begin
        if (byte_sel14[3])
          data[31:24] <= #Tp14 p_in14[31:24];
        if (byte_sel14[2])
          data[23:16] <= #Tp14 p_in14[23:16];
        if (byte_sel14[1])
          data[15:8] <= #Tp14 p_in14[15:8];
        if (byte_sel14[0])
          data[7:0] <= #Tp14 p_in14[7:0];
      end
    else if (latch14[1] && !tip14)
      begin
        if (byte_sel14[3])
          data[63:56] <= #Tp14 p_in14[31:24];
        if (byte_sel14[2])
          data[55:48] <= #Tp14 p_in14[23:16];
        if (byte_sel14[1])
          data[47:40] <= #Tp14 p_in14[15:8];
        if (byte_sel14[0])
          data[39:32] <= #Tp14 p_in14[7:0];
      end
`else
    else if (latch14[0] && !tip14)
      begin
      `ifdef SPI_MAX_CHAR_814
        if (byte_sel14[0])
          data[`SPI_MAX_CHAR14-1:0] <= #Tp14 p_in14[`SPI_MAX_CHAR14-1:0];
      `endif
      `ifdef SPI_MAX_CHAR_1614
        if (byte_sel14[0])
          data[7:0] <= #Tp14 p_in14[7:0];
        if (byte_sel14[1])
          data[`SPI_MAX_CHAR14-1:8] <= #Tp14 p_in14[`SPI_MAX_CHAR14-1:8];
      `endif
      `ifdef SPI_MAX_CHAR_2414
        if (byte_sel14[0])
          data[7:0] <= #Tp14 p_in14[7:0];
        if (byte_sel14[1])
          data[15:8] <= #Tp14 p_in14[15:8];
        if (byte_sel14[2])
          data[`SPI_MAX_CHAR14-1:16] <= #Tp14 p_in14[`SPI_MAX_CHAR14-1:16];
      `endif
      `ifdef SPI_MAX_CHAR_3214
        if (byte_sel14[0])
          data[7:0] <= #Tp14 p_in14[7:0];
        if (byte_sel14[1])
          data[15:8] <= #Tp14 p_in14[15:8];
        if (byte_sel14[2])
          data[23:16] <= #Tp14 p_in14[23:16];
        if (byte_sel14[3])
          data[`SPI_MAX_CHAR14-1:24] <= #Tp14 p_in14[`SPI_MAX_CHAR14-1:24];
      `endif
      end
`endif
`endif
    else
      data[rx_bit_pos14[`SPI_CHAR_LEN_BITS14-1:0]] <= #Tp14 rx_clk14 ? s_in14 : data[rx_bit_pos14[`SPI_CHAR_LEN_BITS14-1:0]];
  end
  
endmodule

