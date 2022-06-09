//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_shift23.v                                                 ////
////                                                              ////
////  This23 file is part of the SPI23 IP23 core23 project23                ////
////  http23://www23.opencores23.org23/projects23/spi23/                      ////
////                                                              ////
////  Author23(s):                                                  ////
////      - Simon23 Srot23 (simons23@opencores23.org23)                     ////
////                                                              ////
////  All additional23 information is avaliable23 in the Readme23.txt23   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright23 (C) 2002 Authors23                                   ////
////                                                              ////
//// This23 source23 file may be used and distributed23 without         ////
//// restriction23 provided that this copyright23 statement23 is not    ////
//// removed from the file and that any derivative23 work23 contains23  ////
//// the original copyright23 notice23 and the associated disclaimer23. ////
////                                                              ////
//// This23 source23 file is free software23; you can redistribute23 it   ////
//// and/or modify it under the terms23 of the GNU23 Lesser23 General23   ////
//// Public23 License23 as published23 by the Free23 Software23 Foundation23; ////
//// either23 version23 2.1 of the License23, or (at your23 option) any   ////
//// later23 version23.                                               ////
////                                                              ////
//// This23 source23 is distributed23 in the hope23 that it will be       ////
//// useful23, but WITHOUT23 ANY23 WARRANTY23; without even23 the implied23   ////
//// warranty23 of MERCHANTABILITY23 or FITNESS23 FOR23 A PARTICULAR23      ////
//// PURPOSE23.  See the GNU23 Lesser23 General23 Public23 License23 for more ////
//// details23.                                                     ////
////                                                              ////
//// You should have received23 a copy of the GNU23 Lesser23 General23    ////
//// Public23 License23 along23 with this source23; if not, download23 it   ////
//// from http23://www23.opencores23.org23/lgpl23.shtml23                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines23.v"
`include "timescale.v"

module spi_shift23 (clk23, rst23, latch23, byte_sel23, len, lsb, go23,
                  pos_edge23, neg_edge23, rx_negedge23, tx_negedge23,
                  tip23, last, 
                  p_in23, p_out23, s_clk23, s_in23, s_out23);

  parameter Tp23 = 1;
  
  input                          clk23;          // system clock23
  input                          rst23;          // reset
  input                    [3:0] latch23;        // latch23 signal23 for storing23 the data in shift23 register
  input                    [3:0] byte_sel23;     // byte select23 signals23 for storing23 the data in shift23 register
  input [`SPI_CHAR_LEN_BITS23-1:0] len;          // data len in bits (minus23 one)
  input                          lsb;          // lbs23 first on the line
  input                          go23;           // start stansfer23
  input                          pos_edge23;     // recognize23 posedge of sclk23
  input                          neg_edge23;     // recognize23 negedge of sclk23
  input                          rx_negedge23;   // s_in23 is sampled23 on negative edge 
  input                          tx_negedge23;   // s_out23 is driven23 on negative edge
  output                         tip23;          // transfer23 in progress23
  output                         last;         // last bit
  input                   [31:0] p_in23;         // parallel23 in
  output     [`SPI_MAX_CHAR23-1:0] p_out23;        // parallel23 out
  input                          s_clk23;        // serial23 clock23
  input                          s_in23;         // serial23 in
  output                         s_out23;        // serial23 out
                                               
  reg                            s_out23;        
  reg                            tip23;
                              
  reg     [`SPI_CHAR_LEN_BITS23:0] cnt;          // data bit count
  reg        [`SPI_MAX_CHAR23-1:0] data;         // shift23 register
  wire    [`SPI_CHAR_LEN_BITS23:0] tx_bit_pos23;   // next bit position23
  wire    [`SPI_CHAR_LEN_BITS23:0] rx_bit_pos23;   // next bit position23
  wire                           rx_clk23;       // rx23 clock23 enable
  wire                           tx_clk23;       // tx23 clock23 enable
  
  assign p_out23 = data;
  
  assign tx_bit_pos23 = lsb ? {!(|len), len} - cnt : cnt - {{`SPI_CHAR_LEN_BITS23{1'b0}},1'b1};
  assign rx_bit_pos23 = lsb ? {!(|len), len} - (rx_negedge23 ? cnt + {{`SPI_CHAR_LEN_BITS23{1'b0}},1'b1} : cnt) : 
                            (rx_negedge23 ? cnt : cnt - {{`SPI_CHAR_LEN_BITS23{1'b0}},1'b1});
  
  assign last = !(|cnt);
  
  assign rx_clk23 = (rx_negedge23 ? neg_edge23 : pos_edge23) && (!last || s_clk23);
  assign tx_clk23 = (tx_negedge23 ? neg_edge23 : pos_edge23) && !last;
  
  // Character23 bit counter
  always @(posedge clk23 or posedge rst23)
  begin
    if(rst23)
      cnt <= #Tp23 {`SPI_CHAR_LEN_BITS23+1{1'b0}};
    else
      begin
        if(tip23)
          cnt <= #Tp23 pos_edge23 ? (cnt - {{`SPI_CHAR_LEN_BITS23{1'b0}}, 1'b1}) : cnt;
        else
          cnt <= #Tp23 !(|len) ? {1'b1, {`SPI_CHAR_LEN_BITS23{1'b0}}} : {1'b0, len};
      end
  end
  
  // Transfer23 in progress23
  always @(posedge clk23 or posedge rst23)
  begin
    if(rst23)
      tip23 <= #Tp23 1'b0;
  else if(go23 && ~tip23)
    tip23 <= #Tp23 1'b1;
  else if(tip23 && last && pos_edge23)
    tip23 <= #Tp23 1'b0;
  end
  
  // Sending23 bits to the line
  always @(posedge clk23 or posedge rst23)
  begin
    if (rst23)
      s_out23   <= #Tp23 1'b0;
    else
      s_out23 <= #Tp23 (tx_clk23 || !tip23) ? data[tx_bit_pos23[`SPI_CHAR_LEN_BITS23-1:0]] : s_out23;
  end
  
  // Receiving23 bits from the line
  always @(posedge clk23 or posedge rst23)
  begin
    if (rst23)
      data   <= #Tp23 {`SPI_MAX_CHAR23{1'b0}};
`ifdef SPI_MAX_CHAR_12823
    else if (latch23[0] && !tip23)
      begin
        if (byte_sel23[3])
          data[31:24] <= #Tp23 p_in23[31:24];
        if (byte_sel23[2])
          data[23:16] <= #Tp23 p_in23[23:16];
        if (byte_sel23[1])
          data[15:8] <= #Tp23 p_in23[15:8];
        if (byte_sel23[0])
          data[7:0] <= #Tp23 p_in23[7:0];
      end
    else if (latch23[1] && !tip23)
      begin
        if (byte_sel23[3])
          data[63:56] <= #Tp23 p_in23[31:24];
        if (byte_sel23[2])
          data[55:48] <= #Tp23 p_in23[23:16];
        if (byte_sel23[1])
          data[47:40] <= #Tp23 p_in23[15:8];
        if (byte_sel23[0])
          data[39:32] <= #Tp23 p_in23[7:0];
      end
    else if (latch23[2] && !tip23)
      begin
        if (byte_sel23[3])
          data[95:88] <= #Tp23 p_in23[31:24];
        if (byte_sel23[2])
          data[87:80] <= #Tp23 p_in23[23:16];
        if (byte_sel23[1])
          data[79:72] <= #Tp23 p_in23[15:8];
        if (byte_sel23[0])
          data[71:64] <= #Tp23 p_in23[7:0];
      end
    else if (latch23[3] && !tip23)
      begin
        if (byte_sel23[3])
          data[127:120] <= #Tp23 p_in23[31:24];
        if (byte_sel23[2])
          data[119:112] <= #Tp23 p_in23[23:16];
        if (byte_sel23[1])
          data[111:104] <= #Tp23 p_in23[15:8];
        if (byte_sel23[0])
          data[103:96] <= #Tp23 p_in23[7:0];
      end
`else
`ifdef SPI_MAX_CHAR_6423
    else if (latch23[0] && !tip23)
      begin
        if (byte_sel23[3])
          data[31:24] <= #Tp23 p_in23[31:24];
        if (byte_sel23[2])
          data[23:16] <= #Tp23 p_in23[23:16];
        if (byte_sel23[1])
          data[15:8] <= #Tp23 p_in23[15:8];
        if (byte_sel23[0])
          data[7:0] <= #Tp23 p_in23[7:0];
      end
    else if (latch23[1] && !tip23)
      begin
        if (byte_sel23[3])
          data[63:56] <= #Tp23 p_in23[31:24];
        if (byte_sel23[2])
          data[55:48] <= #Tp23 p_in23[23:16];
        if (byte_sel23[1])
          data[47:40] <= #Tp23 p_in23[15:8];
        if (byte_sel23[0])
          data[39:32] <= #Tp23 p_in23[7:0];
      end
`else
    else if (latch23[0] && !tip23)
      begin
      `ifdef SPI_MAX_CHAR_823
        if (byte_sel23[0])
          data[`SPI_MAX_CHAR23-1:0] <= #Tp23 p_in23[`SPI_MAX_CHAR23-1:0];
      `endif
      `ifdef SPI_MAX_CHAR_1623
        if (byte_sel23[0])
          data[7:0] <= #Tp23 p_in23[7:0];
        if (byte_sel23[1])
          data[`SPI_MAX_CHAR23-1:8] <= #Tp23 p_in23[`SPI_MAX_CHAR23-1:8];
      `endif
      `ifdef SPI_MAX_CHAR_2423
        if (byte_sel23[0])
          data[7:0] <= #Tp23 p_in23[7:0];
        if (byte_sel23[1])
          data[15:8] <= #Tp23 p_in23[15:8];
        if (byte_sel23[2])
          data[`SPI_MAX_CHAR23-1:16] <= #Tp23 p_in23[`SPI_MAX_CHAR23-1:16];
      `endif
      `ifdef SPI_MAX_CHAR_3223
        if (byte_sel23[0])
          data[7:0] <= #Tp23 p_in23[7:0];
        if (byte_sel23[1])
          data[15:8] <= #Tp23 p_in23[15:8];
        if (byte_sel23[2])
          data[23:16] <= #Tp23 p_in23[23:16];
        if (byte_sel23[3])
          data[`SPI_MAX_CHAR23-1:24] <= #Tp23 p_in23[`SPI_MAX_CHAR23-1:24];
      `endif
      end
`endif
`endif
    else
      data[rx_bit_pos23[`SPI_CHAR_LEN_BITS23-1:0]] <= #Tp23 rx_clk23 ? s_in23 : data[rx_bit_pos23[`SPI_CHAR_LEN_BITS23-1:0]];
  end
  
endmodule

