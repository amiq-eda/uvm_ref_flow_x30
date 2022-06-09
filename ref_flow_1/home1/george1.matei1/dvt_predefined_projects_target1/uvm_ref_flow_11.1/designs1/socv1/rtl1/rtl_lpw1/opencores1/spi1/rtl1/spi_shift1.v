//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_shift1.v                                                 ////
////                                                              ////
////  This1 file is part of the SPI1 IP1 core1 project1                ////
////  http1://www1.opencores1.org1/projects1/spi1/                      ////
////                                                              ////
////  Author1(s):                                                  ////
////      - Simon1 Srot1 (simons1@opencores1.org1)                     ////
////                                                              ////
////  All additional1 information is avaliable1 in the Readme1.txt1   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright1 (C) 2002 Authors1                                   ////
////                                                              ////
//// This1 source1 file may be used and distributed1 without         ////
//// restriction1 provided that this copyright1 statement1 is not    ////
//// removed from the file and that any derivative1 work1 contains1  ////
//// the original copyright1 notice1 and the associated disclaimer1. ////
////                                                              ////
//// This1 source1 file is free software1; you can redistribute1 it   ////
//// and/or modify it under the terms1 of the GNU1 Lesser1 General1   ////
//// Public1 License1 as published1 by the Free1 Software1 Foundation1; ////
//// either1 version1 2.1 of the License1, or (at your1 option) any   ////
//// later1 version1.                                               ////
////                                                              ////
//// This1 source1 is distributed1 in the hope1 that it will be       ////
//// useful1, but WITHOUT1 ANY1 WARRANTY1; without even1 the implied1   ////
//// warranty1 of MERCHANTABILITY1 or FITNESS1 FOR1 A PARTICULAR1      ////
//// PURPOSE1.  See the GNU1 Lesser1 General1 Public1 License1 for more ////
//// details1.                                                     ////
////                                                              ////
//// You should have received1 a copy of the GNU1 Lesser1 General1    ////
//// Public1 License1 along1 with this source1; if not, download1 it   ////
//// from http1://www1.opencores1.org1/lgpl1.shtml1                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines1.v"
`include "timescale.v"

module spi_shift1 (clk1, rst1, latch1, byte_sel1, len, lsb, go1,
                  pos_edge1, neg_edge1, rx_negedge1, tx_negedge1,
                  tip1, last, 
                  p_in1, p_out1, s_clk1, s_in1, s_out1);

  parameter Tp1 = 1;
  
  input                          clk1;          // system clock1
  input                          rst1;          // reset
  input                    [3:0] latch1;        // latch1 signal1 for storing1 the data in shift1 register
  input                    [3:0] byte_sel1;     // byte select1 signals1 for storing1 the data in shift1 register
  input [`SPI_CHAR_LEN_BITS1-1:0] len;          // data len in bits (minus1 one)
  input                          lsb;          // lbs1 first on the line
  input                          go1;           // start stansfer1
  input                          pos_edge1;     // recognize1 posedge of sclk1
  input                          neg_edge1;     // recognize1 negedge of sclk1
  input                          rx_negedge1;   // s_in1 is sampled1 on negative edge 
  input                          tx_negedge1;   // s_out1 is driven1 on negative edge
  output                         tip1;          // transfer1 in progress1
  output                         last;         // last bit
  input                   [31:0] p_in1;         // parallel1 in
  output     [`SPI_MAX_CHAR1-1:0] p_out1;        // parallel1 out
  input                          s_clk1;        // serial1 clock1
  input                          s_in1;         // serial1 in
  output                         s_out1;        // serial1 out
                                               
  reg                            s_out1;        
  reg                            tip1;
                              
  reg     [`SPI_CHAR_LEN_BITS1:0] cnt;          // data bit count
  reg        [`SPI_MAX_CHAR1-1:0] data;         // shift1 register
  wire    [`SPI_CHAR_LEN_BITS1:0] tx_bit_pos1;   // next bit position1
  wire    [`SPI_CHAR_LEN_BITS1:0] rx_bit_pos1;   // next bit position1
  wire                           rx_clk1;       // rx1 clock1 enable
  wire                           tx_clk1;       // tx1 clock1 enable
  
  assign p_out1 = data;
  
  assign tx_bit_pos1 = lsb ? {!(|len), len} - cnt : cnt - {{`SPI_CHAR_LEN_BITS1{1'b0}},1'b1};
  assign rx_bit_pos1 = lsb ? {!(|len), len} - (rx_negedge1 ? cnt + {{`SPI_CHAR_LEN_BITS1{1'b0}},1'b1} : cnt) : 
                            (rx_negedge1 ? cnt : cnt - {{`SPI_CHAR_LEN_BITS1{1'b0}},1'b1});
  
  assign last = !(|cnt);
  
  assign rx_clk1 = (rx_negedge1 ? neg_edge1 : pos_edge1) && (!last || s_clk1);
  assign tx_clk1 = (tx_negedge1 ? neg_edge1 : pos_edge1) && !last;
  
  // Character1 bit counter
  always @(posedge clk1 or posedge rst1)
  begin
    if(rst1)
      cnt <= #Tp1 {`SPI_CHAR_LEN_BITS1+1{1'b0}};
    else
      begin
        if(tip1)
          cnt <= #Tp1 pos_edge1 ? (cnt - {{`SPI_CHAR_LEN_BITS1{1'b0}}, 1'b1}) : cnt;
        else
          cnt <= #Tp1 !(|len) ? {1'b1, {`SPI_CHAR_LEN_BITS1{1'b0}}} : {1'b0, len};
      end
  end
  
  // Transfer1 in progress1
  always @(posedge clk1 or posedge rst1)
  begin
    if(rst1)
      tip1 <= #Tp1 1'b0;
  else if(go1 && ~tip1)
    tip1 <= #Tp1 1'b1;
  else if(tip1 && last && pos_edge1)
    tip1 <= #Tp1 1'b0;
  end
  
  // Sending1 bits to the line
  always @(posedge clk1 or posedge rst1)
  begin
    if (rst1)
      s_out1   <= #Tp1 1'b0;
    else
      s_out1 <= #Tp1 (tx_clk1 || !tip1) ? data[tx_bit_pos1[`SPI_CHAR_LEN_BITS1-1:0]] : s_out1;
  end
  
  // Receiving1 bits from the line
  always @(posedge clk1 or posedge rst1)
  begin
    if (rst1)
      data   <= #Tp1 {`SPI_MAX_CHAR1{1'b0}};
`ifdef SPI_MAX_CHAR_1281
    else if (latch1[0] && !tip1)
      begin
        if (byte_sel1[3])
          data[31:24] <= #Tp1 p_in1[31:24];
        if (byte_sel1[2])
          data[23:16] <= #Tp1 p_in1[23:16];
        if (byte_sel1[1])
          data[15:8] <= #Tp1 p_in1[15:8];
        if (byte_sel1[0])
          data[7:0] <= #Tp1 p_in1[7:0];
      end
    else if (latch1[1] && !tip1)
      begin
        if (byte_sel1[3])
          data[63:56] <= #Tp1 p_in1[31:24];
        if (byte_sel1[2])
          data[55:48] <= #Tp1 p_in1[23:16];
        if (byte_sel1[1])
          data[47:40] <= #Tp1 p_in1[15:8];
        if (byte_sel1[0])
          data[39:32] <= #Tp1 p_in1[7:0];
      end
    else if (latch1[2] && !tip1)
      begin
        if (byte_sel1[3])
          data[95:88] <= #Tp1 p_in1[31:24];
        if (byte_sel1[2])
          data[87:80] <= #Tp1 p_in1[23:16];
        if (byte_sel1[1])
          data[79:72] <= #Tp1 p_in1[15:8];
        if (byte_sel1[0])
          data[71:64] <= #Tp1 p_in1[7:0];
      end
    else if (latch1[3] && !tip1)
      begin
        if (byte_sel1[3])
          data[127:120] <= #Tp1 p_in1[31:24];
        if (byte_sel1[2])
          data[119:112] <= #Tp1 p_in1[23:16];
        if (byte_sel1[1])
          data[111:104] <= #Tp1 p_in1[15:8];
        if (byte_sel1[0])
          data[103:96] <= #Tp1 p_in1[7:0];
      end
`else
`ifdef SPI_MAX_CHAR_641
    else if (latch1[0] && !tip1)
      begin
        if (byte_sel1[3])
          data[31:24] <= #Tp1 p_in1[31:24];
        if (byte_sel1[2])
          data[23:16] <= #Tp1 p_in1[23:16];
        if (byte_sel1[1])
          data[15:8] <= #Tp1 p_in1[15:8];
        if (byte_sel1[0])
          data[7:0] <= #Tp1 p_in1[7:0];
      end
    else if (latch1[1] && !tip1)
      begin
        if (byte_sel1[3])
          data[63:56] <= #Tp1 p_in1[31:24];
        if (byte_sel1[2])
          data[55:48] <= #Tp1 p_in1[23:16];
        if (byte_sel1[1])
          data[47:40] <= #Tp1 p_in1[15:8];
        if (byte_sel1[0])
          data[39:32] <= #Tp1 p_in1[7:0];
      end
`else
    else if (latch1[0] && !tip1)
      begin
      `ifdef SPI_MAX_CHAR_81
        if (byte_sel1[0])
          data[`SPI_MAX_CHAR1-1:0] <= #Tp1 p_in1[`SPI_MAX_CHAR1-1:0];
      `endif
      `ifdef SPI_MAX_CHAR_161
        if (byte_sel1[0])
          data[7:0] <= #Tp1 p_in1[7:0];
        if (byte_sel1[1])
          data[`SPI_MAX_CHAR1-1:8] <= #Tp1 p_in1[`SPI_MAX_CHAR1-1:8];
      `endif
      `ifdef SPI_MAX_CHAR_241
        if (byte_sel1[0])
          data[7:0] <= #Tp1 p_in1[7:0];
        if (byte_sel1[1])
          data[15:8] <= #Tp1 p_in1[15:8];
        if (byte_sel1[2])
          data[`SPI_MAX_CHAR1-1:16] <= #Tp1 p_in1[`SPI_MAX_CHAR1-1:16];
      `endif
      `ifdef SPI_MAX_CHAR_321
        if (byte_sel1[0])
          data[7:0] <= #Tp1 p_in1[7:0];
        if (byte_sel1[1])
          data[15:8] <= #Tp1 p_in1[15:8];
        if (byte_sel1[2])
          data[23:16] <= #Tp1 p_in1[23:16];
        if (byte_sel1[3])
          data[`SPI_MAX_CHAR1-1:24] <= #Tp1 p_in1[`SPI_MAX_CHAR1-1:24];
      `endif
      end
`endif
`endif
    else
      data[rx_bit_pos1[`SPI_CHAR_LEN_BITS1-1:0]] <= #Tp1 rx_clk1 ? s_in1 : data[rx_bit_pos1[`SPI_CHAR_LEN_BITS1-1:0]];
  end
  
endmodule

