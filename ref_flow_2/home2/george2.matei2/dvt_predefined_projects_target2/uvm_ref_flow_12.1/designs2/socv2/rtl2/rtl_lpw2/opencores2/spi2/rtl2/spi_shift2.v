//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_shift2.v                                                 ////
////                                                              ////
////  This2 file is part of the SPI2 IP2 core2 project2                ////
////  http2://www2.opencores2.org2/projects2/spi2/                      ////
////                                                              ////
////  Author2(s):                                                  ////
////      - Simon2 Srot2 (simons2@opencores2.org2)                     ////
////                                                              ////
////  All additional2 information is avaliable2 in the Readme2.txt2   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright2 (C) 2002 Authors2                                   ////
////                                                              ////
//// This2 source2 file may be used and distributed2 without         ////
//// restriction2 provided that this copyright2 statement2 is not    ////
//// removed from the file and that any derivative2 work2 contains2  ////
//// the original copyright2 notice2 and the associated disclaimer2. ////
////                                                              ////
//// This2 source2 file is free software2; you can redistribute2 it   ////
//// and/or modify it under the terms2 of the GNU2 Lesser2 General2   ////
//// Public2 License2 as published2 by the Free2 Software2 Foundation2; ////
//// either2 version2 2.1 of the License2, or (at your2 option) any   ////
//// later2 version2.                                               ////
////                                                              ////
//// This2 source2 is distributed2 in the hope2 that it will be       ////
//// useful2, but WITHOUT2 ANY2 WARRANTY2; without even2 the implied2   ////
//// warranty2 of MERCHANTABILITY2 or FITNESS2 FOR2 A PARTICULAR2      ////
//// PURPOSE2.  See the GNU2 Lesser2 General2 Public2 License2 for more ////
//// details2.                                                     ////
////                                                              ////
//// You should have received2 a copy of the GNU2 Lesser2 General2    ////
//// Public2 License2 along2 with this source2; if not, download2 it   ////
//// from http2://www2.opencores2.org2/lgpl2.shtml2                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines2.v"
`include "timescale.v"

module spi_shift2 (clk2, rst2, latch2, byte_sel2, len, lsb, go2,
                  pos_edge2, neg_edge2, rx_negedge2, tx_negedge2,
                  tip2, last, 
                  p_in2, p_out2, s_clk2, s_in2, s_out2);

  parameter Tp2 = 1;
  
  input                          clk2;          // system clock2
  input                          rst2;          // reset
  input                    [3:0] latch2;        // latch2 signal2 for storing2 the data in shift2 register
  input                    [3:0] byte_sel2;     // byte select2 signals2 for storing2 the data in shift2 register
  input [`SPI_CHAR_LEN_BITS2-1:0] len;          // data len in bits (minus2 one)
  input                          lsb;          // lbs2 first on the line
  input                          go2;           // start stansfer2
  input                          pos_edge2;     // recognize2 posedge of sclk2
  input                          neg_edge2;     // recognize2 negedge of sclk2
  input                          rx_negedge2;   // s_in2 is sampled2 on negative edge 
  input                          tx_negedge2;   // s_out2 is driven2 on negative edge
  output                         tip2;          // transfer2 in progress2
  output                         last;         // last bit
  input                   [31:0] p_in2;         // parallel2 in
  output     [`SPI_MAX_CHAR2-1:0] p_out2;        // parallel2 out
  input                          s_clk2;        // serial2 clock2
  input                          s_in2;         // serial2 in
  output                         s_out2;        // serial2 out
                                               
  reg                            s_out2;        
  reg                            tip2;
                              
  reg     [`SPI_CHAR_LEN_BITS2:0] cnt;          // data bit count
  reg        [`SPI_MAX_CHAR2-1:0] data;         // shift2 register
  wire    [`SPI_CHAR_LEN_BITS2:0] tx_bit_pos2;   // next bit position2
  wire    [`SPI_CHAR_LEN_BITS2:0] rx_bit_pos2;   // next bit position2
  wire                           rx_clk2;       // rx2 clock2 enable
  wire                           tx_clk2;       // tx2 clock2 enable
  
  assign p_out2 = data;
  
  assign tx_bit_pos2 = lsb ? {!(|len), len} - cnt : cnt - {{`SPI_CHAR_LEN_BITS2{1'b0}},1'b1};
  assign rx_bit_pos2 = lsb ? {!(|len), len} - (rx_negedge2 ? cnt + {{`SPI_CHAR_LEN_BITS2{1'b0}},1'b1} : cnt) : 
                            (rx_negedge2 ? cnt : cnt - {{`SPI_CHAR_LEN_BITS2{1'b0}},1'b1});
  
  assign last = !(|cnt);
  
  assign rx_clk2 = (rx_negedge2 ? neg_edge2 : pos_edge2) && (!last || s_clk2);
  assign tx_clk2 = (tx_negedge2 ? neg_edge2 : pos_edge2) && !last;
  
  // Character2 bit counter
  always @(posedge clk2 or posedge rst2)
  begin
    if(rst2)
      cnt <= #Tp2 {`SPI_CHAR_LEN_BITS2+1{1'b0}};
    else
      begin
        if(tip2)
          cnt <= #Tp2 pos_edge2 ? (cnt - {{`SPI_CHAR_LEN_BITS2{1'b0}}, 1'b1}) : cnt;
        else
          cnt <= #Tp2 !(|len) ? {1'b1, {`SPI_CHAR_LEN_BITS2{1'b0}}} : {1'b0, len};
      end
  end
  
  // Transfer2 in progress2
  always @(posedge clk2 or posedge rst2)
  begin
    if(rst2)
      tip2 <= #Tp2 1'b0;
  else if(go2 && ~tip2)
    tip2 <= #Tp2 1'b1;
  else if(tip2 && last && pos_edge2)
    tip2 <= #Tp2 1'b0;
  end
  
  // Sending2 bits to the line
  always @(posedge clk2 or posedge rst2)
  begin
    if (rst2)
      s_out2   <= #Tp2 1'b0;
    else
      s_out2 <= #Tp2 (tx_clk2 || !tip2) ? data[tx_bit_pos2[`SPI_CHAR_LEN_BITS2-1:0]] : s_out2;
  end
  
  // Receiving2 bits from the line
  always @(posedge clk2 or posedge rst2)
  begin
    if (rst2)
      data   <= #Tp2 {`SPI_MAX_CHAR2{1'b0}};
`ifdef SPI_MAX_CHAR_1282
    else if (latch2[0] && !tip2)
      begin
        if (byte_sel2[3])
          data[31:24] <= #Tp2 p_in2[31:24];
        if (byte_sel2[2])
          data[23:16] <= #Tp2 p_in2[23:16];
        if (byte_sel2[1])
          data[15:8] <= #Tp2 p_in2[15:8];
        if (byte_sel2[0])
          data[7:0] <= #Tp2 p_in2[7:0];
      end
    else if (latch2[1] && !tip2)
      begin
        if (byte_sel2[3])
          data[63:56] <= #Tp2 p_in2[31:24];
        if (byte_sel2[2])
          data[55:48] <= #Tp2 p_in2[23:16];
        if (byte_sel2[1])
          data[47:40] <= #Tp2 p_in2[15:8];
        if (byte_sel2[0])
          data[39:32] <= #Tp2 p_in2[7:0];
      end
    else if (latch2[2] && !tip2)
      begin
        if (byte_sel2[3])
          data[95:88] <= #Tp2 p_in2[31:24];
        if (byte_sel2[2])
          data[87:80] <= #Tp2 p_in2[23:16];
        if (byte_sel2[1])
          data[79:72] <= #Tp2 p_in2[15:8];
        if (byte_sel2[0])
          data[71:64] <= #Tp2 p_in2[7:0];
      end
    else if (latch2[3] && !tip2)
      begin
        if (byte_sel2[3])
          data[127:120] <= #Tp2 p_in2[31:24];
        if (byte_sel2[2])
          data[119:112] <= #Tp2 p_in2[23:16];
        if (byte_sel2[1])
          data[111:104] <= #Tp2 p_in2[15:8];
        if (byte_sel2[0])
          data[103:96] <= #Tp2 p_in2[7:0];
      end
`else
`ifdef SPI_MAX_CHAR_642
    else if (latch2[0] && !tip2)
      begin
        if (byte_sel2[3])
          data[31:24] <= #Tp2 p_in2[31:24];
        if (byte_sel2[2])
          data[23:16] <= #Tp2 p_in2[23:16];
        if (byte_sel2[1])
          data[15:8] <= #Tp2 p_in2[15:8];
        if (byte_sel2[0])
          data[7:0] <= #Tp2 p_in2[7:0];
      end
    else if (latch2[1] && !tip2)
      begin
        if (byte_sel2[3])
          data[63:56] <= #Tp2 p_in2[31:24];
        if (byte_sel2[2])
          data[55:48] <= #Tp2 p_in2[23:16];
        if (byte_sel2[1])
          data[47:40] <= #Tp2 p_in2[15:8];
        if (byte_sel2[0])
          data[39:32] <= #Tp2 p_in2[7:0];
      end
`else
    else if (latch2[0] && !tip2)
      begin
      `ifdef SPI_MAX_CHAR_82
        if (byte_sel2[0])
          data[`SPI_MAX_CHAR2-1:0] <= #Tp2 p_in2[`SPI_MAX_CHAR2-1:0];
      `endif
      `ifdef SPI_MAX_CHAR_162
        if (byte_sel2[0])
          data[7:0] <= #Tp2 p_in2[7:0];
        if (byte_sel2[1])
          data[`SPI_MAX_CHAR2-1:8] <= #Tp2 p_in2[`SPI_MAX_CHAR2-1:8];
      `endif
      `ifdef SPI_MAX_CHAR_242
        if (byte_sel2[0])
          data[7:0] <= #Tp2 p_in2[7:0];
        if (byte_sel2[1])
          data[15:8] <= #Tp2 p_in2[15:8];
        if (byte_sel2[2])
          data[`SPI_MAX_CHAR2-1:16] <= #Tp2 p_in2[`SPI_MAX_CHAR2-1:16];
      `endif
      `ifdef SPI_MAX_CHAR_322
        if (byte_sel2[0])
          data[7:0] <= #Tp2 p_in2[7:0];
        if (byte_sel2[1])
          data[15:8] <= #Tp2 p_in2[15:8];
        if (byte_sel2[2])
          data[23:16] <= #Tp2 p_in2[23:16];
        if (byte_sel2[3])
          data[`SPI_MAX_CHAR2-1:24] <= #Tp2 p_in2[`SPI_MAX_CHAR2-1:24];
      `endif
      end
`endif
`endif
    else
      data[rx_bit_pos2[`SPI_CHAR_LEN_BITS2-1:0]] <= #Tp2 rx_clk2 ? s_in2 : data[rx_bit_pos2[`SPI_CHAR_LEN_BITS2-1:0]];
  end
  
endmodule

