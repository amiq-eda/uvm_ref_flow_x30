//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_shift3.v                                                 ////
////                                                              ////
////  This3 file is part of the SPI3 IP3 core3 project3                ////
////  http3://www3.opencores3.org3/projects3/spi3/                      ////
////                                                              ////
////  Author3(s):                                                  ////
////      - Simon3 Srot3 (simons3@opencores3.org3)                     ////
////                                                              ////
////  All additional3 information is avaliable3 in the Readme3.txt3   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright3 (C) 2002 Authors3                                   ////
////                                                              ////
//// This3 source3 file may be used and distributed3 without         ////
//// restriction3 provided that this copyright3 statement3 is not    ////
//// removed from the file and that any derivative3 work3 contains3  ////
//// the original copyright3 notice3 and the associated disclaimer3. ////
////                                                              ////
//// This3 source3 file is free software3; you can redistribute3 it   ////
//// and/or modify it under the terms3 of the GNU3 Lesser3 General3   ////
//// Public3 License3 as published3 by the Free3 Software3 Foundation3; ////
//// either3 version3 2.1 of the License3, or (at your3 option) any   ////
//// later3 version3.                                               ////
////                                                              ////
//// This3 source3 is distributed3 in the hope3 that it will be       ////
//// useful3, but WITHOUT3 ANY3 WARRANTY3; without even3 the implied3   ////
//// warranty3 of MERCHANTABILITY3 or FITNESS3 FOR3 A PARTICULAR3      ////
//// PURPOSE3.  See the GNU3 Lesser3 General3 Public3 License3 for more ////
//// details3.                                                     ////
////                                                              ////
//// You should have received3 a copy of the GNU3 Lesser3 General3    ////
//// Public3 License3 along3 with this source3; if not, download3 it   ////
//// from http3://www3.opencores3.org3/lgpl3.shtml3                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines3.v"
`include "timescale.v"

module spi_shift3 (clk3, rst3, latch3, byte_sel3, len, lsb, go3,
                  pos_edge3, neg_edge3, rx_negedge3, tx_negedge3,
                  tip3, last, 
                  p_in3, p_out3, s_clk3, s_in3, s_out3);

  parameter Tp3 = 1;
  
  input                          clk3;          // system clock3
  input                          rst3;          // reset
  input                    [3:0] latch3;        // latch3 signal3 for storing3 the data in shift3 register
  input                    [3:0] byte_sel3;     // byte select3 signals3 for storing3 the data in shift3 register
  input [`SPI_CHAR_LEN_BITS3-1:0] len;          // data len in bits (minus3 one)
  input                          lsb;          // lbs3 first on the line
  input                          go3;           // start stansfer3
  input                          pos_edge3;     // recognize3 posedge of sclk3
  input                          neg_edge3;     // recognize3 negedge of sclk3
  input                          rx_negedge3;   // s_in3 is sampled3 on negative edge 
  input                          tx_negedge3;   // s_out3 is driven3 on negative edge
  output                         tip3;          // transfer3 in progress3
  output                         last;         // last bit
  input                   [31:0] p_in3;         // parallel3 in
  output     [`SPI_MAX_CHAR3-1:0] p_out3;        // parallel3 out
  input                          s_clk3;        // serial3 clock3
  input                          s_in3;         // serial3 in
  output                         s_out3;        // serial3 out
                                               
  reg                            s_out3;        
  reg                            tip3;
                              
  reg     [`SPI_CHAR_LEN_BITS3:0] cnt;          // data bit count
  reg        [`SPI_MAX_CHAR3-1:0] data;         // shift3 register
  wire    [`SPI_CHAR_LEN_BITS3:0] tx_bit_pos3;   // next bit position3
  wire    [`SPI_CHAR_LEN_BITS3:0] rx_bit_pos3;   // next bit position3
  wire                           rx_clk3;       // rx3 clock3 enable
  wire                           tx_clk3;       // tx3 clock3 enable
  
  assign p_out3 = data;
  
  assign tx_bit_pos3 = lsb ? {!(|len), len} - cnt : cnt - {{`SPI_CHAR_LEN_BITS3{1'b0}},1'b1};
  assign rx_bit_pos3 = lsb ? {!(|len), len} - (rx_negedge3 ? cnt + {{`SPI_CHAR_LEN_BITS3{1'b0}},1'b1} : cnt) : 
                            (rx_negedge3 ? cnt : cnt - {{`SPI_CHAR_LEN_BITS3{1'b0}},1'b1});
  
  assign last = !(|cnt);
  
  assign rx_clk3 = (rx_negedge3 ? neg_edge3 : pos_edge3) && (!last || s_clk3);
  assign tx_clk3 = (tx_negedge3 ? neg_edge3 : pos_edge3) && !last;
  
  // Character3 bit counter
  always @(posedge clk3 or posedge rst3)
  begin
    if(rst3)
      cnt <= #Tp3 {`SPI_CHAR_LEN_BITS3+1{1'b0}};
    else
      begin
        if(tip3)
          cnt <= #Tp3 pos_edge3 ? (cnt - {{`SPI_CHAR_LEN_BITS3{1'b0}}, 1'b1}) : cnt;
        else
          cnt <= #Tp3 !(|len) ? {1'b1, {`SPI_CHAR_LEN_BITS3{1'b0}}} : {1'b0, len};
      end
  end
  
  // Transfer3 in progress3
  always @(posedge clk3 or posedge rst3)
  begin
    if(rst3)
      tip3 <= #Tp3 1'b0;
  else if(go3 && ~tip3)
    tip3 <= #Tp3 1'b1;
  else if(tip3 && last && pos_edge3)
    tip3 <= #Tp3 1'b0;
  end
  
  // Sending3 bits to the line
  always @(posedge clk3 or posedge rst3)
  begin
    if (rst3)
      s_out3   <= #Tp3 1'b0;
    else
      s_out3 <= #Tp3 (tx_clk3 || !tip3) ? data[tx_bit_pos3[`SPI_CHAR_LEN_BITS3-1:0]] : s_out3;
  end
  
  // Receiving3 bits from the line
  always @(posedge clk3 or posedge rst3)
  begin
    if (rst3)
      data   <= #Tp3 {`SPI_MAX_CHAR3{1'b0}};
`ifdef SPI_MAX_CHAR_1283
    else if (latch3[0] && !tip3)
      begin
        if (byte_sel3[3])
          data[31:24] <= #Tp3 p_in3[31:24];
        if (byte_sel3[2])
          data[23:16] <= #Tp3 p_in3[23:16];
        if (byte_sel3[1])
          data[15:8] <= #Tp3 p_in3[15:8];
        if (byte_sel3[0])
          data[7:0] <= #Tp3 p_in3[7:0];
      end
    else if (latch3[1] && !tip3)
      begin
        if (byte_sel3[3])
          data[63:56] <= #Tp3 p_in3[31:24];
        if (byte_sel3[2])
          data[55:48] <= #Tp3 p_in3[23:16];
        if (byte_sel3[1])
          data[47:40] <= #Tp3 p_in3[15:8];
        if (byte_sel3[0])
          data[39:32] <= #Tp3 p_in3[7:0];
      end
    else if (latch3[2] && !tip3)
      begin
        if (byte_sel3[3])
          data[95:88] <= #Tp3 p_in3[31:24];
        if (byte_sel3[2])
          data[87:80] <= #Tp3 p_in3[23:16];
        if (byte_sel3[1])
          data[79:72] <= #Tp3 p_in3[15:8];
        if (byte_sel3[0])
          data[71:64] <= #Tp3 p_in3[7:0];
      end
    else if (latch3[3] && !tip3)
      begin
        if (byte_sel3[3])
          data[127:120] <= #Tp3 p_in3[31:24];
        if (byte_sel3[2])
          data[119:112] <= #Tp3 p_in3[23:16];
        if (byte_sel3[1])
          data[111:104] <= #Tp3 p_in3[15:8];
        if (byte_sel3[0])
          data[103:96] <= #Tp3 p_in3[7:0];
      end
`else
`ifdef SPI_MAX_CHAR_643
    else if (latch3[0] && !tip3)
      begin
        if (byte_sel3[3])
          data[31:24] <= #Tp3 p_in3[31:24];
        if (byte_sel3[2])
          data[23:16] <= #Tp3 p_in3[23:16];
        if (byte_sel3[1])
          data[15:8] <= #Tp3 p_in3[15:8];
        if (byte_sel3[0])
          data[7:0] <= #Tp3 p_in3[7:0];
      end
    else if (latch3[1] && !tip3)
      begin
        if (byte_sel3[3])
          data[63:56] <= #Tp3 p_in3[31:24];
        if (byte_sel3[2])
          data[55:48] <= #Tp3 p_in3[23:16];
        if (byte_sel3[1])
          data[47:40] <= #Tp3 p_in3[15:8];
        if (byte_sel3[0])
          data[39:32] <= #Tp3 p_in3[7:0];
      end
`else
    else if (latch3[0] && !tip3)
      begin
      `ifdef SPI_MAX_CHAR_83
        if (byte_sel3[0])
          data[`SPI_MAX_CHAR3-1:0] <= #Tp3 p_in3[`SPI_MAX_CHAR3-1:0];
      `endif
      `ifdef SPI_MAX_CHAR_163
        if (byte_sel3[0])
          data[7:0] <= #Tp3 p_in3[7:0];
        if (byte_sel3[1])
          data[`SPI_MAX_CHAR3-1:8] <= #Tp3 p_in3[`SPI_MAX_CHAR3-1:8];
      `endif
      `ifdef SPI_MAX_CHAR_243
        if (byte_sel3[0])
          data[7:0] <= #Tp3 p_in3[7:0];
        if (byte_sel3[1])
          data[15:8] <= #Tp3 p_in3[15:8];
        if (byte_sel3[2])
          data[`SPI_MAX_CHAR3-1:16] <= #Tp3 p_in3[`SPI_MAX_CHAR3-1:16];
      `endif
      `ifdef SPI_MAX_CHAR_323
        if (byte_sel3[0])
          data[7:0] <= #Tp3 p_in3[7:0];
        if (byte_sel3[1])
          data[15:8] <= #Tp3 p_in3[15:8];
        if (byte_sel3[2])
          data[23:16] <= #Tp3 p_in3[23:16];
        if (byte_sel3[3])
          data[`SPI_MAX_CHAR3-1:24] <= #Tp3 p_in3[`SPI_MAX_CHAR3-1:24];
      `endif
      end
`endif
`endif
    else
      data[rx_bit_pos3[`SPI_CHAR_LEN_BITS3-1:0]] <= #Tp3 rx_clk3 ? s_in3 : data[rx_bit_pos3[`SPI_CHAR_LEN_BITS3-1:0]];
  end
  
endmodule

