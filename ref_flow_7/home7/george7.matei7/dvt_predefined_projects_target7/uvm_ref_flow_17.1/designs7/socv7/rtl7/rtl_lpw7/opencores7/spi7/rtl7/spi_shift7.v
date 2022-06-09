//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_shift7.v                                                 ////
////                                                              ////
////  This7 file is part of the SPI7 IP7 core7 project7                ////
////  http7://www7.opencores7.org7/projects7/spi7/                      ////
////                                                              ////
////  Author7(s):                                                  ////
////      - Simon7 Srot7 (simons7@opencores7.org7)                     ////
////                                                              ////
////  All additional7 information is avaliable7 in the Readme7.txt7   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright7 (C) 2002 Authors7                                   ////
////                                                              ////
//// This7 source7 file may be used and distributed7 without         ////
//// restriction7 provided that this copyright7 statement7 is not    ////
//// removed from the file and that any derivative7 work7 contains7  ////
//// the original copyright7 notice7 and the associated disclaimer7. ////
////                                                              ////
//// This7 source7 file is free software7; you can redistribute7 it   ////
//// and/or modify it under the terms7 of the GNU7 Lesser7 General7   ////
//// Public7 License7 as published7 by the Free7 Software7 Foundation7; ////
//// either7 version7 2.1 of the License7, or (at your7 option) any   ////
//// later7 version7.                                               ////
////                                                              ////
//// This7 source7 is distributed7 in the hope7 that it will be       ////
//// useful7, but WITHOUT7 ANY7 WARRANTY7; without even7 the implied7   ////
//// warranty7 of MERCHANTABILITY7 or FITNESS7 FOR7 A PARTICULAR7      ////
//// PURPOSE7.  See the GNU7 Lesser7 General7 Public7 License7 for more ////
//// details7.                                                     ////
////                                                              ////
//// You should have received7 a copy of the GNU7 Lesser7 General7    ////
//// Public7 License7 along7 with this source7; if not, download7 it   ////
//// from http7://www7.opencores7.org7/lgpl7.shtml7                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines7.v"
`include "timescale.v"

module spi_shift7 (clk7, rst7, latch7, byte_sel7, len, lsb, go7,
                  pos_edge7, neg_edge7, rx_negedge7, tx_negedge7,
                  tip7, last, 
                  p_in7, p_out7, s_clk7, s_in7, s_out7);

  parameter Tp7 = 1;
  
  input                          clk7;          // system clock7
  input                          rst7;          // reset
  input                    [3:0] latch7;        // latch7 signal7 for storing7 the data in shift7 register
  input                    [3:0] byte_sel7;     // byte select7 signals7 for storing7 the data in shift7 register
  input [`SPI_CHAR_LEN_BITS7-1:0] len;          // data len in bits (minus7 one)
  input                          lsb;          // lbs7 first on the line
  input                          go7;           // start stansfer7
  input                          pos_edge7;     // recognize7 posedge of sclk7
  input                          neg_edge7;     // recognize7 negedge of sclk7
  input                          rx_negedge7;   // s_in7 is sampled7 on negative edge 
  input                          tx_negedge7;   // s_out7 is driven7 on negative edge
  output                         tip7;          // transfer7 in progress7
  output                         last;         // last bit
  input                   [31:0] p_in7;         // parallel7 in
  output     [`SPI_MAX_CHAR7-1:0] p_out7;        // parallel7 out
  input                          s_clk7;        // serial7 clock7
  input                          s_in7;         // serial7 in
  output                         s_out7;        // serial7 out
                                               
  reg                            s_out7;        
  reg                            tip7;
                              
  reg     [`SPI_CHAR_LEN_BITS7:0] cnt;          // data bit count
  reg        [`SPI_MAX_CHAR7-1:0] data;         // shift7 register
  wire    [`SPI_CHAR_LEN_BITS7:0] tx_bit_pos7;   // next bit position7
  wire    [`SPI_CHAR_LEN_BITS7:0] rx_bit_pos7;   // next bit position7
  wire                           rx_clk7;       // rx7 clock7 enable
  wire                           tx_clk7;       // tx7 clock7 enable
  
  assign p_out7 = data;
  
  assign tx_bit_pos7 = lsb ? {!(|len), len} - cnt : cnt - {{`SPI_CHAR_LEN_BITS7{1'b0}},1'b1};
  assign rx_bit_pos7 = lsb ? {!(|len), len} - (rx_negedge7 ? cnt + {{`SPI_CHAR_LEN_BITS7{1'b0}},1'b1} : cnt) : 
                            (rx_negedge7 ? cnt : cnt - {{`SPI_CHAR_LEN_BITS7{1'b0}},1'b1});
  
  assign last = !(|cnt);
  
  assign rx_clk7 = (rx_negedge7 ? neg_edge7 : pos_edge7) && (!last || s_clk7);
  assign tx_clk7 = (tx_negedge7 ? neg_edge7 : pos_edge7) && !last;
  
  // Character7 bit counter
  always @(posedge clk7 or posedge rst7)
  begin
    if(rst7)
      cnt <= #Tp7 {`SPI_CHAR_LEN_BITS7+1{1'b0}};
    else
      begin
        if(tip7)
          cnt <= #Tp7 pos_edge7 ? (cnt - {{`SPI_CHAR_LEN_BITS7{1'b0}}, 1'b1}) : cnt;
        else
          cnt <= #Tp7 !(|len) ? {1'b1, {`SPI_CHAR_LEN_BITS7{1'b0}}} : {1'b0, len};
      end
  end
  
  // Transfer7 in progress7
  always @(posedge clk7 or posedge rst7)
  begin
    if(rst7)
      tip7 <= #Tp7 1'b0;
  else if(go7 && ~tip7)
    tip7 <= #Tp7 1'b1;
  else if(tip7 && last && pos_edge7)
    tip7 <= #Tp7 1'b0;
  end
  
  // Sending7 bits to the line
  always @(posedge clk7 or posedge rst7)
  begin
    if (rst7)
      s_out7   <= #Tp7 1'b0;
    else
      s_out7 <= #Tp7 (tx_clk7 || !tip7) ? data[tx_bit_pos7[`SPI_CHAR_LEN_BITS7-1:0]] : s_out7;
  end
  
  // Receiving7 bits from the line
  always @(posedge clk7 or posedge rst7)
  begin
    if (rst7)
      data   <= #Tp7 {`SPI_MAX_CHAR7{1'b0}};
`ifdef SPI_MAX_CHAR_1287
    else if (latch7[0] && !tip7)
      begin
        if (byte_sel7[3])
          data[31:24] <= #Tp7 p_in7[31:24];
        if (byte_sel7[2])
          data[23:16] <= #Tp7 p_in7[23:16];
        if (byte_sel7[1])
          data[15:8] <= #Tp7 p_in7[15:8];
        if (byte_sel7[0])
          data[7:0] <= #Tp7 p_in7[7:0];
      end
    else if (latch7[1] && !tip7)
      begin
        if (byte_sel7[3])
          data[63:56] <= #Tp7 p_in7[31:24];
        if (byte_sel7[2])
          data[55:48] <= #Tp7 p_in7[23:16];
        if (byte_sel7[1])
          data[47:40] <= #Tp7 p_in7[15:8];
        if (byte_sel7[0])
          data[39:32] <= #Tp7 p_in7[7:0];
      end
    else if (latch7[2] && !tip7)
      begin
        if (byte_sel7[3])
          data[95:88] <= #Tp7 p_in7[31:24];
        if (byte_sel7[2])
          data[87:80] <= #Tp7 p_in7[23:16];
        if (byte_sel7[1])
          data[79:72] <= #Tp7 p_in7[15:8];
        if (byte_sel7[0])
          data[71:64] <= #Tp7 p_in7[7:0];
      end
    else if (latch7[3] && !tip7)
      begin
        if (byte_sel7[3])
          data[127:120] <= #Tp7 p_in7[31:24];
        if (byte_sel7[2])
          data[119:112] <= #Tp7 p_in7[23:16];
        if (byte_sel7[1])
          data[111:104] <= #Tp7 p_in7[15:8];
        if (byte_sel7[0])
          data[103:96] <= #Tp7 p_in7[7:0];
      end
`else
`ifdef SPI_MAX_CHAR_647
    else if (latch7[0] && !tip7)
      begin
        if (byte_sel7[3])
          data[31:24] <= #Tp7 p_in7[31:24];
        if (byte_sel7[2])
          data[23:16] <= #Tp7 p_in7[23:16];
        if (byte_sel7[1])
          data[15:8] <= #Tp7 p_in7[15:8];
        if (byte_sel7[0])
          data[7:0] <= #Tp7 p_in7[7:0];
      end
    else if (latch7[1] && !tip7)
      begin
        if (byte_sel7[3])
          data[63:56] <= #Tp7 p_in7[31:24];
        if (byte_sel7[2])
          data[55:48] <= #Tp7 p_in7[23:16];
        if (byte_sel7[1])
          data[47:40] <= #Tp7 p_in7[15:8];
        if (byte_sel7[0])
          data[39:32] <= #Tp7 p_in7[7:0];
      end
`else
    else if (latch7[0] && !tip7)
      begin
      `ifdef SPI_MAX_CHAR_87
        if (byte_sel7[0])
          data[`SPI_MAX_CHAR7-1:0] <= #Tp7 p_in7[`SPI_MAX_CHAR7-1:0];
      `endif
      `ifdef SPI_MAX_CHAR_167
        if (byte_sel7[0])
          data[7:0] <= #Tp7 p_in7[7:0];
        if (byte_sel7[1])
          data[`SPI_MAX_CHAR7-1:8] <= #Tp7 p_in7[`SPI_MAX_CHAR7-1:8];
      `endif
      `ifdef SPI_MAX_CHAR_247
        if (byte_sel7[0])
          data[7:0] <= #Tp7 p_in7[7:0];
        if (byte_sel7[1])
          data[15:8] <= #Tp7 p_in7[15:8];
        if (byte_sel7[2])
          data[`SPI_MAX_CHAR7-1:16] <= #Tp7 p_in7[`SPI_MAX_CHAR7-1:16];
      `endif
      `ifdef SPI_MAX_CHAR_327
        if (byte_sel7[0])
          data[7:0] <= #Tp7 p_in7[7:0];
        if (byte_sel7[1])
          data[15:8] <= #Tp7 p_in7[15:8];
        if (byte_sel7[2])
          data[23:16] <= #Tp7 p_in7[23:16];
        if (byte_sel7[3])
          data[`SPI_MAX_CHAR7-1:24] <= #Tp7 p_in7[`SPI_MAX_CHAR7-1:24];
      `endif
      end
`endif
`endif
    else
      data[rx_bit_pos7[`SPI_CHAR_LEN_BITS7-1:0]] <= #Tp7 rx_clk7 ? s_in7 : data[rx_bit_pos7[`SPI_CHAR_LEN_BITS7-1:0]];
  end
  
endmodule

