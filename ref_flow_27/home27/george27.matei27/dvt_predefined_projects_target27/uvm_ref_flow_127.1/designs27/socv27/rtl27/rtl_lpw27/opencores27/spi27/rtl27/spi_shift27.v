//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_shift27.v                                                 ////
////                                                              ////
////  This27 file is part of the SPI27 IP27 core27 project27                ////
////  http27://www27.opencores27.org27/projects27/spi27/                      ////
////                                                              ////
////  Author27(s):                                                  ////
////      - Simon27 Srot27 (simons27@opencores27.org27)                     ////
////                                                              ////
////  All additional27 information is avaliable27 in the Readme27.txt27   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright27 (C) 2002 Authors27                                   ////
////                                                              ////
//// This27 source27 file may be used and distributed27 without         ////
//// restriction27 provided that this copyright27 statement27 is not    ////
//// removed from the file and that any derivative27 work27 contains27  ////
//// the original copyright27 notice27 and the associated disclaimer27. ////
////                                                              ////
//// This27 source27 file is free software27; you can redistribute27 it   ////
//// and/or modify it under the terms27 of the GNU27 Lesser27 General27   ////
//// Public27 License27 as published27 by the Free27 Software27 Foundation27; ////
//// either27 version27 2.1 of the License27, or (at your27 option) any   ////
//// later27 version27.                                               ////
////                                                              ////
//// This27 source27 is distributed27 in the hope27 that it will be       ////
//// useful27, but WITHOUT27 ANY27 WARRANTY27; without even27 the implied27   ////
//// warranty27 of MERCHANTABILITY27 or FITNESS27 FOR27 A PARTICULAR27      ////
//// PURPOSE27.  See the GNU27 Lesser27 General27 Public27 License27 for more ////
//// details27.                                                     ////
////                                                              ////
//// You should have received27 a copy of the GNU27 Lesser27 General27    ////
//// Public27 License27 along27 with this source27; if not, download27 it   ////
//// from http27://www27.opencores27.org27/lgpl27.shtml27                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines27.v"
`include "timescale.v"

module spi_shift27 (clk27, rst27, latch27, byte_sel27, len, lsb, go27,
                  pos_edge27, neg_edge27, rx_negedge27, tx_negedge27,
                  tip27, last, 
                  p_in27, p_out27, s_clk27, s_in27, s_out27);

  parameter Tp27 = 1;
  
  input                          clk27;          // system clock27
  input                          rst27;          // reset
  input                    [3:0] latch27;        // latch27 signal27 for storing27 the data in shift27 register
  input                    [3:0] byte_sel27;     // byte select27 signals27 for storing27 the data in shift27 register
  input [`SPI_CHAR_LEN_BITS27-1:0] len;          // data len in bits (minus27 one)
  input                          lsb;          // lbs27 first on the line
  input                          go27;           // start stansfer27
  input                          pos_edge27;     // recognize27 posedge of sclk27
  input                          neg_edge27;     // recognize27 negedge of sclk27
  input                          rx_negedge27;   // s_in27 is sampled27 on negative edge 
  input                          tx_negedge27;   // s_out27 is driven27 on negative edge
  output                         tip27;          // transfer27 in progress27
  output                         last;         // last bit
  input                   [31:0] p_in27;         // parallel27 in
  output     [`SPI_MAX_CHAR27-1:0] p_out27;        // parallel27 out
  input                          s_clk27;        // serial27 clock27
  input                          s_in27;         // serial27 in
  output                         s_out27;        // serial27 out
                                               
  reg                            s_out27;        
  reg                            tip27;
                              
  reg     [`SPI_CHAR_LEN_BITS27:0] cnt;          // data bit count
  reg        [`SPI_MAX_CHAR27-1:0] data;         // shift27 register
  wire    [`SPI_CHAR_LEN_BITS27:0] tx_bit_pos27;   // next bit position27
  wire    [`SPI_CHAR_LEN_BITS27:0] rx_bit_pos27;   // next bit position27
  wire                           rx_clk27;       // rx27 clock27 enable
  wire                           tx_clk27;       // tx27 clock27 enable
  
  assign p_out27 = data;
  
  assign tx_bit_pos27 = lsb ? {!(|len), len} - cnt : cnt - {{`SPI_CHAR_LEN_BITS27{1'b0}},1'b1};
  assign rx_bit_pos27 = lsb ? {!(|len), len} - (rx_negedge27 ? cnt + {{`SPI_CHAR_LEN_BITS27{1'b0}},1'b1} : cnt) : 
                            (rx_negedge27 ? cnt : cnt - {{`SPI_CHAR_LEN_BITS27{1'b0}},1'b1});
  
  assign last = !(|cnt);
  
  assign rx_clk27 = (rx_negedge27 ? neg_edge27 : pos_edge27) && (!last || s_clk27);
  assign tx_clk27 = (tx_negedge27 ? neg_edge27 : pos_edge27) && !last;
  
  // Character27 bit counter
  always @(posedge clk27 or posedge rst27)
  begin
    if(rst27)
      cnt <= #Tp27 {`SPI_CHAR_LEN_BITS27+1{1'b0}};
    else
      begin
        if(tip27)
          cnt <= #Tp27 pos_edge27 ? (cnt - {{`SPI_CHAR_LEN_BITS27{1'b0}}, 1'b1}) : cnt;
        else
          cnt <= #Tp27 !(|len) ? {1'b1, {`SPI_CHAR_LEN_BITS27{1'b0}}} : {1'b0, len};
      end
  end
  
  // Transfer27 in progress27
  always @(posedge clk27 or posedge rst27)
  begin
    if(rst27)
      tip27 <= #Tp27 1'b0;
  else if(go27 && ~tip27)
    tip27 <= #Tp27 1'b1;
  else if(tip27 && last && pos_edge27)
    tip27 <= #Tp27 1'b0;
  end
  
  // Sending27 bits to the line
  always @(posedge clk27 or posedge rst27)
  begin
    if (rst27)
      s_out27   <= #Tp27 1'b0;
    else
      s_out27 <= #Tp27 (tx_clk27 || !tip27) ? data[tx_bit_pos27[`SPI_CHAR_LEN_BITS27-1:0]] : s_out27;
  end
  
  // Receiving27 bits from the line
  always @(posedge clk27 or posedge rst27)
  begin
    if (rst27)
      data   <= #Tp27 {`SPI_MAX_CHAR27{1'b0}};
`ifdef SPI_MAX_CHAR_12827
    else if (latch27[0] && !tip27)
      begin
        if (byte_sel27[3])
          data[31:24] <= #Tp27 p_in27[31:24];
        if (byte_sel27[2])
          data[23:16] <= #Tp27 p_in27[23:16];
        if (byte_sel27[1])
          data[15:8] <= #Tp27 p_in27[15:8];
        if (byte_sel27[0])
          data[7:0] <= #Tp27 p_in27[7:0];
      end
    else if (latch27[1] && !tip27)
      begin
        if (byte_sel27[3])
          data[63:56] <= #Tp27 p_in27[31:24];
        if (byte_sel27[2])
          data[55:48] <= #Tp27 p_in27[23:16];
        if (byte_sel27[1])
          data[47:40] <= #Tp27 p_in27[15:8];
        if (byte_sel27[0])
          data[39:32] <= #Tp27 p_in27[7:0];
      end
    else if (latch27[2] && !tip27)
      begin
        if (byte_sel27[3])
          data[95:88] <= #Tp27 p_in27[31:24];
        if (byte_sel27[2])
          data[87:80] <= #Tp27 p_in27[23:16];
        if (byte_sel27[1])
          data[79:72] <= #Tp27 p_in27[15:8];
        if (byte_sel27[0])
          data[71:64] <= #Tp27 p_in27[7:0];
      end
    else if (latch27[3] && !tip27)
      begin
        if (byte_sel27[3])
          data[127:120] <= #Tp27 p_in27[31:24];
        if (byte_sel27[2])
          data[119:112] <= #Tp27 p_in27[23:16];
        if (byte_sel27[1])
          data[111:104] <= #Tp27 p_in27[15:8];
        if (byte_sel27[0])
          data[103:96] <= #Tp27 p_in27[7:0];
      end
`else
`ifdef SPI_MAX_CHAR_6427
    else if (latch27[0] && !tip27)
      begin
        if (byte_sel27[3])
          data[31:24] <= #Tp27 p_in27[31:24];
        if (byte_sel27[2])
          data[23:16] <= #Tp27 p_in27[23:16];
        if (byte_sel27[1])
          data[15:8] <= #Tp27 p_in27[15:8];
        if (byte_sel27[0])
          data[7:0] <= #Tp27 p_in27[7:0];
      end
    else if (latch27[1] && !tip27)
      begin
        if (byte_sel27[3])
          data[63:56] <= #Tp27 p_in27[31:24];
        if (byte_sel27[2])
          data[55:48] <= #Tp27 p_in27[23:16];
        if (byte_sel27[1])
          data[47:40] <= #Tp27 p_in27[15:8];
        if (byte_sel27[0])
          data[39:32] <= #Tp27 p_in27[7:0];
      end
`else
    else if (latch27[0] && !tip27)
      begin
      `ifdef SPI_MAX_CHAR_827
        if (byte_sel27[0])
          data[`SPI_MAX_CHAR27-1:0] <= #Tp27 p_in27[`SPI_MAX_CHAR27-1:0];
      `endif
      `ifdef SPI_MAX_CHAR_1627
        if (byte_sel27[0])
          data[7:0] <= #Tp27 p_in27[7:0];
        if (byte_sel27[1])
          data[`SPI_MAX_CHAR27-1:8] <= #Tp27 p_in27[`SPI_MAX_CHAR27-1:8];
      `endif
      `ifdef SPI_MAX_CHAR_2427
        if (byte_sel27[0])
          data[7:0] <= #Tp27 p_in27[7:0];
        if (byte_sel27[1])
          data[15:8] <= #Tp27 p_in27[15:8];
        if (byte_sel27[2])
          data[`SPI_MAX_CHAR27-1:16] <= #Tp27 p_in27[`SPI_MAX_CHAR27-1:16];
      `endif
      `ifdef SPI_MAX_CHAR_3227
        if (byte_sel27[0])
          data[7:0] <= #Tp27 p_in27[7:0];
        if (byte_sel27[1])
          data[15:8] <= #Tp27 p_in27[15:8];
        if (byte_sel27[2])
          data[23:16] <= #Tp27 p_in27[23:16];
        if (byte_sel27[3])
          data[`SPI_MAX_CHAR27-1:24] <= #Tp27 p_in27[`SPI_MAX_CHAR27-1:24];
      `endif
      end
`endif
`endif
    else
      data[rx_bit_pos27[`SPI_CHAR_LEN_BITS27-1:0]] <= #Tp27 rx_clk27 ? s_in27 : data[rx_bit_pos27[`SPI_CHAR_LEN_BITS27-1:0]];
  end
  
endmodule

