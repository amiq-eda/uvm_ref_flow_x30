//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_shift5.v                                                 ////
////                                                              ////
////  This5 file is part of the SPI5 IP5 core5 project5                ////
////  http5://www5.opencores5.org5/projects5/spi5/                      ////
////                                                              ////
////  Author5(s):                                                  ////
////      - Simon5 Srot5 (simons5@opencores5.org5)                     ////
////                                                              ////
////  All additional5 information is avaliable5 in the Readme5.txt5   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright5 (C) 2002 Authors5                                   ////
////                                                              ////
//// This5 source5 file may be used and distributed5 without         ////
//// restriction5 provided that this copyright5 statement5 is not    ////
//// removed from the file and that any derivative5 work5 contains5  ////
//// the original copyright5 notice5 and the associated disclaimer5. ////
////                                                              ////
//// This5 source5 file is free software5; you can redistribute5 it   ////
//// and/or modify it under the terms5 of the GNU5 Lesser5 General5   ////
//// Public5 License5 as published5 by the Free5 Software5 Foundation5; ////
//// either5 version5 2.1 of the License5, or (at your5 option) any   ////
//// later5 version5.                                               ////
////                                                              ////
//// This5 source5 is distributed5 in the hope5 that it will be       ////
//// useful5, but WITHOUT5 ANY5 WARRANTY5; without even5 the implied5   ////
//// warranty5 of MERCHANTABILITY5 or FITNESS5 FOR5 A PARTICULAR5      ////
//// PURPOSE5.  See the GNU5 Lesser5 General5 Public5 License5 for more ////
//// details5.                                                     ////
////                                                              ////
//// You should have received5 a copy of the GNU5 Lesser5 General5    ////
//// Public5 License5 along5 with this source5; if not, download5 it   ////
//// from http5://www5.opencores5.org5/lgpl5.shtml5                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines5.v"
`include "timescale.v"

module spi_shift5 (clk5, rst5, latch5, byte_sel5, len, lsb, go5,
                  pos_edge5, neg_edge5, rx_negedge5, tx_negedge5,
                  tip5, last, 
                  p_in5, p_out5, s_clk5, s_in5, s_out5);

  parameter Tp5 = 1;
  
  input                          clk5;          // system clock5
  input                          rst5;          // reset
  input                    [3:0] latch5;        // latch5 signal5 for storing5 the data in shift5 register
  input                    [3:0] byte_sel5;     // byte select5 signals5 for storing5 the data in shift5 register
  input [`SPI_CHAR_LEN_BITS5-1:0] len;          // data len in bits (minus5 one)
  input                          lsb;          // lbs5 first on the line
  input                          go5;           // start stansfer5
  input                          pos_edge5;     // recognize5 posedge of sclk5
  input                          neg_edge5;     // recognize5 negedge of sclk5
  input                          rx_negedge5;   // s_in5 is sampled5 on negative edge 
  input                          tx_negedge5;   // s_out5 is driven5 on negative edge
  output                         tip5;          // transfer5 in progress5
  output                         last;         // last bit
  input                   [31:0] p_in5;         // parallel5 in
  output     [`SPI_MAX_CHAR5-1:0] p_out5;        // parallel5 out
  input                          s_clk5;        // serial5 clock5
  input                          s_in5;         // serial5 in
  output                         s_out5;        // serial5 out
                                               
  reg                            s_out5;        
  reg                            tip5;
                              
  reg     [`SPI_CHAR_LEN_BITS5:0] cnt;          // data bit count
  reg        [`SPI_MAX_CHAR5-1:0] data;         // shift5 register
  wire    [`SPI_CHAR_LEN_BITS5:0] tx_bit_pos5;   // next bit position5
  wire    [`SPI_CHAR_LEN_BITS5:0] rx_bit_pos5;   // next bit position5
  wire                           rx_clk5;       // rx5 clock5 enable
  wire                           tx_clk5;       // tx5 clock5 enable
  
  assign p_out5 = data;
  
  assign tx_bit_pos5 = lsb ? {!(|len), len} - cnt : cnt - {{`SPI_CHAR_LEN_BITS5{1'b0}},1'b1};
  assign rx_bit_pos5 = lsb ? {!(|len), len} - (rx_negedge5 ? cnt + {{`SPI_CHAR_LEN_BITS5{1'b0}},1'b1} : cnt) : 
                            (rx_negedge5 ? cnt : cnt - {{`SPI_CHAR_LEN_BITS5{1'b0}},1'b1});
  
  assign last = !(|cnt);
  
  assign rx_clk5 = (rx_negedge5 ? neg_edge5 : pos_edge5) && (!last || s_clk5);
  assign tx_clk5 = (tx_negedge5 ? neg_edge5 : pos_edge5) && !last;
  
  // Character5 bit counter
  always @(posedge clk5 or posedge rst5)
  begin
    if(rst5)
      cnt <= #Tp5 {`SPI_CHAR_LEN_BITS5+1{1'b0}};
    else
      begin
        if(tip5)
          cnt <= #Tp5 pos_edge5 ? (cnt - {{`SPI_CHAR_LEN_BITS5{1'b0}}, 1'b1}) : cnt;
        else
          cnt <= #Tp5 !(|len) ? {1'b1, {`SPI_CHAR_LEN_BITS5{1'b0}}} : {1'b0, len};
      end
  end
  
  // Transfer5 in progress5
  always @(posedge clk5 or posedge rst5)
  begin
    if(rst5)
      tip5 <= #Tp5 1'b0;
  else if(go5 && ~tip5)
    tip5 <= #Tp5 1'b1;
  else if(tip5 && last && pos_edge5)
    tip5 <= #Tp5 1'b0;
  end
  
  // Sending5 bits to the line
  always @(posedge clk5 or posedge rst5)
  begin
    if (rst5)
      s_out5   <= #Tp5 1'b0;
    else
      s_out5 <= #Tp5 (tx_clk5 || !tip5) ? data[tx_bit_pos5[`SPI_CHAR_LEN_BITS5-1:0]] : s_out5;
  end
  
  // Receiving5 bits from the line
  always @(posedge clk5 or posedge rst5)
  begin
    if (rst5)
      data   <= #Tp5 {`SPI_MAX_CHAR5{1'b0}};
`ifdef SPI_MAX_CHAR_1285
    else if (latch5[0] && !tip5)
      begin
        if (byte_sel5[3])
          data[31:24] <= #Tp5 p_in5[31:24];
        if (byte_sel5[2])
          data[23:16] <= #Tp5 p_in5[23:16];
        if (byte_sel5[1])
          data[15:8] <= #Tp5 p_in5[15:8];
        if (byte_sel5[0])
          data[7:0] <= #Tp5 p_in5[7:0];
      end
    else if (latch5[1] && !tip5)
      begin
        if (byte_sel5[3])
          data[63:56] <= #Tp5 p_in5[31:24];
        if (byte_sel5[2])
          data[55:48] <= #Tp5 p_in5[23:16];
        if (byte_sel5[1])
          data[47:40] <= #Tp5 p_in5[15:8];
        if (byte_sel5[0])
          data[39:32] <= #Tp5 p_in5[7:0];
      end
    else if (latch5[2] && !tip5)
      begin
        if (byte_sel5[3])
          data[95:88] <= #Tp5 p_in5[31:24];
        if (byte_sel5[2])
          data[87:80] <= #Tp5 p_in5[23:16];
        if (byte_sel5[1])
          data[79:72] <= #Tp5 p_in5[15:8];
        if (byte_sel5[0])
          data[71:64] <= #Tp5 p_in5[7:0];
      end
    else if (latch5[3] && !tip5)
      begin
        if (byte_sel5[3])
          data[127:120] <= #Tp5 p_in5[31:24];
        if (byte_sel5[2])
          data[119:112] <= #Tp5 p_in5[23:16];
        if (byte_sel5[1])
          data[111:104] <= #Tp5 p_in5[15:8];
        if (byte_sel5[0])
          data[103:96] <= #Tp5 p_in5[7:0];
      end
`else
`ifdef SPI_MAX_CHAR_645
    else if (latch5[0] && !tip5)
      begin
        if (byte_sel5[3])
          data[31:24] <= #Tp5 p_in5[31:24];
        if (byte_sel5[2])
          data[23:16] <= #Tp5 p_in5[23:16];
        if (byte_sel5[1])
          data[15:8] <= #Tp5 p_in5[15:8];
        if (byte_sel5[0])
          data[7:0] <= #Tp5 p_in5[7:0];
      end
    else if (latch5[1] && !tip5)
      begin
        if (byte_sel5[3])
          data[63:56] <= #Tp5 p_in5[31:24];
        if (byte_sel5[2])
          data[55:48] <= #Tp5 p_in5[23:16];
        if (byte_sel5[1])
          data[47:40] <= #Tp5 p_in5[15:8];
        if (byte_sel5[0])
          data[39:32] <= #Tp5 p_in5[7:0];
      end
`else
    else if (latch5[0] && !tip5)
      begin
      `ifdef SPI_MAX_CHAR_85
        if (byte_sel5[0])
          data[`SPI_MAX_CHAR5-1:0] <= #Tp5 p_in5[`SPI_MAX_CHAR5-1:0];
      `endif
      `ifdef SPI_MAX_CHAR_165
        if (byte_sel5[0])
          data[7:0] <= #Tp5 p_in5[7:0];
        if (byte_sel5[1])
          data[`SPI_MAX_CHAR5-1:8] <= #Tp5 p_in5[`SPI_MAX_CHAR5-1:8];
      `endif
      `ifdef SPI_MAX_CHAR_245
        if (byte_sel5[0])
          data[7:0] <= #Tp5 p_in5[7:0];
        if (byte_sel5[1])
          data[15:8] <= #Tp5 p_in5[15:8];
        if (byte_sel5[2])
          data[`SPI_MAX_CHAR5-1:16] <= #Tp5 p_in5[`SPI_MAX_CHAR5-1:16];
      `endif
      `ifdef SPI_MAX_CHAR_325
        if (byte_sel5[0])
          data[7:0] <= #Tp5 p_in5[7:0];
        if (byte_sel5[1])
          data[15:8] <= #Tp5 p_in5[15:8];
        if (byte_sel5[2])
          data[23:16] <= #Tp5 p_in5[23:16];
        if (byte_sel5[3])
          data[`SPI_MAX_CHAR5-1:24] <= #Tp5 p_in5[`SPI_MAX_CHAR5-1:24];
      `endif
      end
`endif
`endif
    else
      data[rx_bit_pos5[`SPI_CHAR_LEN_BITS5-1:0]] <= #Tp5 rx_clk5 ? s_in5 : data[rx_bit_pos5[`SPI_CHAR_LEN_BITS5-1:0]];
  end
  
endmodule

