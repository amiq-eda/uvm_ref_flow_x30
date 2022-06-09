//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_shift29.v                                                 ////
////                                                              ////
////  This29 file is part of the SPI29 IP29 core29 project29                ////
////  http29://www29.opencores29.org29/projects29/spi29/                      ////
////                                                              ////
////  Author29(s):                                                  ////
////      - Simon29 Srot29 (simons29@opencores29.org29)                     ////
////                                                              ////
////  All additional29 information is avaliable29 in the Readme29.txt29   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright29 (C) 2002 Authors29                                   ////
////                                                              ////
//// This29 source29 file may be used and distributed29 without         ////
//// restriction29 provided that this copyright29 statement29 is not    ////
//// removed from the file and that any derivative29 work29 contains29  ////
//// the original copyright29 notice29 and the associated disclaimer29. ////
////                                                              ////
//// This29 source29 file is free software29; you can redistribute29 it   ////
//// and/or modify it under the terms29 of the GNU29 Lesser29 General29   ////
//// Public29 License29 as published29 by the Free29 Software29 Foundation29; ////
//// either29 version29 2.1 of the License29, or (at your29 option) any   ////
//// later29 version29.                                               ////
////                                                              ////
//// This29 source29 is distributed29 in the hope29 that it will be       ////
//// useful29, but WITHOUT29 ANY29 WARRANTY29; without even29 the implied29   ////
//// warranty29 of MERCHANTABILITY29 or FITNESS29 FOR29 A PARTICULAR29      ////
//// PURPOSE29.  See the GNU29 Lesser29 General29 Public29 License29 for more ////
//// details29.                                                     ////
////                                                              ////
//// You should have received29 a copy of the GNU29 Lesser29 General29    ////
//// Public29 License29 along29 with this source29; if not, download29 it   ////
//// from http29://www29.opencores29.org29/lgpl29.shtml29                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines29.v"
`include "timescale.v"

module spi_shift29 (clk29, rst29, latch29, byte_sel29, len, lsb, go29,
                  pos_edge29, neg_edge29, rx_negedge29, tx_negedge29,
                  tip29, last, 
                  p_in29, p_out29, s_clk29, s_in29, s_out29);

  parameter Tp29 = 1;
  
  input                          clk29;          // system clock29
  input                          rst29;          // reset
  input                    [3:0] latch29;        // latch29 signal29 for storing29 the data in shift29 register
  input                    [3:0] byte_sel29;     // byte select29 signals29 for storing29 the data in shift29 register
  input [`SPI_CHAR_LEN_BITS29-1:0] len;          // data len in bits (minus29 one)
  input                          lsb;          // lbs29 first on the line
  input                          go29;           // start stansfer29
  input                          pos_edge29;     // recognize29 posedge of sclk29
  input                          neg_edge29;     // recognize29 negedge of sclk29
  input                          rx_negedge29;   // s_in29 is sampled29 on negative edge 
  input                          tx_negedge29;   // s_out29 is driven29 on negative edge
  output                         tip29;          // transfer29 in progress29
  output                         last;         // last bit
  input                   [31:0] p_in29;         // parallel29 in
  output     [`SPI_MAX_CHAR29-1:0] p_out29;        // parallel29 out
  input                          s_clk29;        // serial29 clock29
  input                          s_in29;         // serial29 in
  output                         s_out29;        // serial29 out
                                               
  reg                            s_out29;        
  reg                            tip29;
                              
  reg     [`SPI_CHAR_LEN_BITS29:0] cnt;          // data bit count
  reg        [`SPI_MAX_CHAR29-1:0] data;         // shift29 register
  wire    [`SPI_CHAR_LEN_BITS29:0] tx_bit_pos29;   // next bit position29
  wire    [`SPI_CHAR_LEN_BITS29:0] rx_bit_pos29;   // next bit position29
  wire                           rx_clk29;       // rx29 clock29 enable
  wire                           tx_clk29;       // tx29 clock29 enable
  
  assign p_out29 = data;
  
  assign tx_bit_pos29 = lsb ? {!(|len), len} - cnt : cnt - {{`SPI_CHAR_LEN_BITS29{1'b0}},1'b1};
  assign rx_bit_pos29 = lsb ? {!(|len), len} - (rx_negedge29 ? cnt + {{`SPI_CHAR_LEN_BITS29{1'b0}},1'b1} : cnt) : 
                            (rx_negedge29 ? cnt : cnt - {{`SPI_CHAR_LEN_BITS29{1'b0}},1'b1});
  
  assign last = !(|cnt);
  
  assign rx_clk29 = (rx_negedge29 ? neg_edge29 : pos_edge29) && (!last || s_clk29);
  assign tx_clk29 = (tx_negedge29 ? neg_edge29 : pos_edge29) && !last;
  
  // Character29 bit counter
  always @(posedge clk29 or posedge rst29)
  begin
    if(rst29)
      cnt <= #Tp29 {`SPI_CHAR_LEN_BITS29+1{1'b0}};
    else
      begin
        if(tip29)
          cnt <= #Tp29 pos_edge29 ? (cnt - {{`SPI_CHAR_LEN_BITS29{1'b0}}, 1'b1}) : cnt;
        else
          cnt <= #Tp29 !(|len) ? {1'b1, {`SPI_CHAR_LEN_BITS29{1'b0}}} : {1'b0, len};
      end
  end
  
  // Transfer29 in progress29
  always @(posedge clk29 or posedge rst29)
  begin
    if(rst29)
      tip29 <= #Tp29 1'b0;
  else if(go29 && ~tip29)
    tip29 <= #Tp29 1'b1;
  else if(tip29 && last && pos_edge29)
    tip29 <= #Tp29 1'b0;
  end
  
  // Sending29 bits to the line
  always @(posedge clk29 or posedge rst29)
  begin
    if (rst29)
      s_out29   <= #Tp29 1'b0;
    else
      s_out29 <= #Tp29 (tx_clk29 || !tip29) ? data[tx_bit_pos29[`SPI_CHAR_LEN_BITS29-1:0]] : s_out29;
  end
  
  // Receiving29 bits from the line
  always @(posedge clk29 or posedge rst29)
  begin
    if (rst29)
      data   <= #Tp29 {`SPI_MAX_CHAR29{1'b0}};
`ifdef SPI_MAX_CHAR_12829
    else if (latch29[0] && !tip29)
      begin
        if (byte_sel29[3])
          data[31:24] <= #Tp29 p_in29[31:24];
        if (byte_sel29[2])
          data[23:16] <= #Tp29 p_in29[23:16];
        if (byte_sel29[1])
          data[15:8] <= #Tp29 p_in29[15:8];
        if (byte_sel29[0])
          data[7:0] <= #Tp29 p_in29[7:0];
      end
    else if (latch29[1] && !tip29)
      begin
        if (byte_sel29[3])
          data[63:56] <= #Tp29 p_in29[31:24];
        if (byte_sel29[2])
          data[55:48] <= #Tp29 p_in29[23:16];
        if (byte_sel29[1])
          data[47:40] <= #Tp29 p_in29[15:8];
        if (byte_sel29[0])
          data[39:32] <= #Tp29 p_in29[7:0];
      end
    else if (latch29[2] && !tip29)
      begin
        if (byte_sel29[3])
          data[95:88] <= #Tp29 p_in29[31:24];
        if (byte_sel29[2])
          data[87:80] <= #Tp29 p_in29[23:16];
        if (byte_sel29[1])
          data[79:72] <= #Tp29 p_in29[15:8];
        if (byte_sel29[0])
          data[71:64] <= #Tp29 p_in29[7:0];
      end
    else if (latch29[3] && !tip29)
      begin
        if (byte_sel29[3])
          data[127:120] <= #Tp29 p_in29[31:24];
        if (byte_sel29[2])
          data[119:112] <= #Tp29 p_in29[23:16];
        if (byte_sel29[1])
          data[111:104] <= #Tp29 p_in29[15:8];
        if (byte_sel29[0])
          data[103:96] <= #Tp29 p_in29[7:0];
      end
`else
`ifdef SPI_MAX_CHAR_6429
    else if (latch29[0] && !tip29)
      begin
        if (byte_sel29[3])
          data[31:24] <= #Tp29 p_in29[31:24];
        if (byte_sel29[2])
          data[23:16] <= #Tp29 p_in29[23:16];
        if (byte_sel29[1])
          data[15:8] <= #Tp29 p_in29[15:8];
        if (byte_sel29[0])
          data[7:0] <= #Tp29 p_in29[7:0];
      end
    else if (latch29[1] && !tip29)
      begin
        if (byte_sel29[3])
          data[63:56] <= #Tp29 p_in29[31:24];
        if (byte_sel29[2])
          data[55:48] <= #Tp29 p_in29[23:16];
        if (byte_sel29[1])
          data[47:40] <= #Tp29 p_in29[15:8];
        if (byte_sel29[0])
          data[39:32] <= #Tp29 p_in29[7:0];
      end
`else
    else if (latch29[0] && !tip29)
      begin
      `ifdef SPI_MAX_CHAR_829
        if (byte_sel29[0])
          data[`SPI_MAX_CHAR29-1:0] <= #Tp29 p_in29[`SPI_MAX_CHAR29-1:0];
      `endif
      `ifdef SPI_MAX_CHAR_1629
        if (byte_sel29[0])
          data[7:0] <= #Tp29 p_in29[7:0];
        if (byte_sel29[1])
          data[`SPI_MAX_CHAR29-1:8] <= #Tp29 p_in29[`SPI_MAX_CHAR29-1:8];
      `endif
      `ifdef SPI_MAX_CHAR_2429
        if (byte_sel29[0])
          data[7:0] <= #Tp29 p_in29[7:0];
        if (byte_sel29[1])
          data[15:8] <= #Tp29 p_in29[15:8];
        if (byte_sel29[2])
          data[`SPI_MAX_CHAR29-1:16] <= #Tp29 p_in29[`SPI_MAX_CHAR29-1:16];
      `endif
      `ifdef SPI_MAX_CHAR_3229
        if (byte_sel29[0])
          data[7:0] <= #Tp29 p_in29[7:0];
        if (byte_sel29[1])
          data[15:8] <= #Tp29 p_in29[15:8];
        if (byte_sel29[2])
          data[23:16] <= #Tp29 p_in29[23:16];
        if (byte_sel29[3])
          data[`SPI_MAX_CHAR29-1:24] <= #Tp29 p_in29[`SPI_MAX_CHAR29-1:24];
      `endif
      end
`endif
`endif
    else
      data[rx_bit_pos29[`SPI_CHAR_LEN_BITS29-1:0]] <= #Tp29 rx_clk29 ? s_in29 : data[rx_bit_pos29[`SPI_CHAR_LEN_BITS29-1:0]];
  end
  
endmodule

