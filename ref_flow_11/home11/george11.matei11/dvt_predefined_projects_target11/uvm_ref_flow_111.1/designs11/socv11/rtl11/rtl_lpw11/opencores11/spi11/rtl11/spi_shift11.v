//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_shift11.v                                                 ////
////                                                              ////
////  This11 file is part of the SPI11 IP11 core11 project11                ////
////  http11://www11.opencores11.org11/projects11/spi11/                      ////
////                                                              ////
////  Author11(s):                                                  ////
////      - Simon11 Srot11 (simons11@opencores11.org11)                     ////
////                                                              ////
////  All additional11 information is avaliable11 in the Readme11.txt11   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright11 (C) 2002 Authors11                                   ////
////                                                              ////
//// This11 source11 file may be used and distributed11 without         ////
//// restriction11 provided that this copyright11 statement11 is not    ////
//// removed from the file and that any derivative11 work11 contains11  ////
//// the original copyright11 notice11 and the associated disclaimer11. ////
////                                                              ////
//// This11 source11 file is free software11; you can redistribute11 it   ////
//// and/or modify it under the terms11 of the GNU11 Lesser11 General11   ////
//// Public11 License11 as published11 by the Free11 Software11 Foundation11; ////
//// either11 version11 2.1 of the License11, or (at your11 option) any   ////
//// later11 version11.                                               ////
////                                                              ////
//// This11 source11 is distributed11 in the hope11 that it will be       ////
//// useful11, but WITHOUT11 ANY11 WARRANTY11; without even11 the implied11   ////
//// warranty11 of MERCHANTABILITY11 or FITNESS11 FOR11 A PARTICULAR11      ////
//// PURPOSE11.  See the GNU11 Lesser11 General11 Public11 License11 for more ////
//// details11.                                                     ////
////                                                              ////
//// You should have received11 a copy of the GNU11 Lesser11 General11    ////
//// Public11 License11 along11 with this source11; if not, download11 it   ////
//// from http11://www11.opencores11.org11/lgpl11.shtml11                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines11.v"
`include "timescale.v"

module spi_shift11 (clk11, rst11, latch11, byte_sel11, len, lsb, go11,
                  pos_edge11, neg_edge11, rx_negedge11, tx_negedge11,
                  tip11, last, 
                  p_in11, p_out11, s_clk11, s_in11, s_out11);

  parameter Tp11 = 1;
  
  input                          clk11;          // system clock11
  input                          rst11;          // reset
  input                    [3:0] latch11;        // latch11 signal11 for storing11 the data in shift11 register
  input                    [3:0] byte_sel11;     // byte select11 signals11 for storing11 the data in shift11 register
  input [`SPI_CHAR_LEN_BITS11-1:0] len;          // data len in bits (minus11 one)
  input                          lsb;          // lbs11 first on the line
  input                          go11;           // start stansfer11
  input                          pos_edge11;     // recognize11 posedge of sclk11
  input                          neg_edge11;     // recognize11 negedge of sclk11
  input                          rx_negedge11;   // s_in11 is sampled11 on negative edge 
  input                          tx_negedge11;   // s_out11 is driven11 on negative edge
  output                         tip11;          // transfer11 in progress11
  output                         last;         // last bit
  input                   [31:0] p_in11;         // parallel11 in
  output     [`SPI_MAX_CHAR11-1:0] p_out11;        // parallel11 out
  input                          s_clk11;        // serial11 clock11
  input                          s_in11;         // serial11 in
  output                         s_out11;        // serial11 out
                                               
  reg                            s_out11;        
  reg                            tip11;
                              
  reg     [`SPI_CHAR_LEN_BITS11:0] cnt;          // data bit count
  reg        [`SPI_MAX_CHAR11-1:0] data;         // shift11 register
  wire    [`SPI_CHAR_LEN_BITS11:0] tx_bit_pos11;   // next bit position11
  wire    [`SPI_CHAR_LEN_BITS11:0] rx_bit_pos11;   // next bit position11
  wire                           rx_clk11;       // rx11 clock11 enable
  wire                           tx_clk11;       // tx11 clock11 enable
  
  assign p_out11 = data;
  
  assign tx_bit_pos11 = lsb ? {!(|len), len} - cnt : cnt - {{`SPI_CHAR_LEN_BITS11{1'b0}},1'b1};
  assign rx_bit_pos11 = lsb ? {!(|len), len} - (rx_negedge11 ? cnt + {{`SPI_CHAR_LEN_BITS11{1'b0}},1'b1} : cnt) : 
                            (rx_negedge11 ? cnt : cnt - {{`SPI_CHAR_LEN_BITS11{1'b0}},1'b1});
  
  assign last = !(|cnt);
  
  assign rx_clk11 = (rx_negedge11 ? neg_edge11 : pos_edge11) && (!last || s_clk11);
  assign tx_clk11 = (tx_negedge11 ? neg_edge11 : pos_edge11) && !last;
  
  // Character11 bit counter
  always @(posedge clk11 or posedge rst11)
  begin
    if(rst11)
      cnt <= #Tp11 {`SPI_CHAR_LEN_BITS11+1{1'b0}};
    else
      begin
        if(tip11)
          cnt <= #Tp11 pos_edge11 ? (cnt - {{`SPI_CHAR_LEN_BITS11{1'b0}}, 1'b1}) : cnt;
        else
          cnt <= #Tp11 !(|len) ? {1'b1, {`SPI_CHAR_LEN_BITS11{1'b0}}} : {1'b0, len};
      end
  end
  
  // Transfer11 in progress11
  always @(posedge clk11 or posedge rst11)
  begin
    if(rst11)
      tip11 <= #Tp11 1'b0;
  else if(go11 && ~tip11)
    tip11 <= #Tp11 1'b1;
  else if(tip11 && last && pos_edge11)
    tip11 <= #Tp11 1'b0;
  end
  
  // Sending11 bits to the line
  always @(posedge clk11 or posedge rst11)
  begin
    if (rst11)
      s_out11   <= #Tp11 1'b0;
    else
      s_out11 <= #Tp11 (tx_clk11 || !tip11) ? data[tx_bit_pos11[`SPI_CHAR_LEN_BITS11-1:0]] : s_out11;
  end
  
  // Receiving11 bits from the line
  always @(posedge clk11 or posedge rst11)
  begin
    if (rst11)
      data   <= #Tp11 {`SPI_MAX_CHAR11{1'b0}};
`ifdef SPI_MAX_CHAR_12811
    else if (latch11[0] && !tip11)
      begin
        if (byte_sel11[3])
          data[31:24] <= #Tp11 p_in11[31:24];
        if (byte_sel11[2])
          data[23:16] <= #Tp11 p_in11[23:16];
        if (byte_sel11[1])
          data[15:8] <= #Tp11 p_in11[15:8];
        if (byte_sel11[0])
          data[7:0] <= #Tp11 p_in11[7:0];
      end
    else if (latch11[1] && !tip11)
      begin
        if (byte_sel11[3])
          data[63:56] <= #Tp11 p_in11[31:24];
        if (byte_sel11[2])
          data[55:48] <= #Tp11 p_in11[23:16];
        if (byte_sel11[1])
          data[47:40] <= #Tp11 p_in11[15:8];
        if (byte_sel11[0])
          data[39:32] <= #Tp11 p_in11[7:0];
      end
    else if (latch11[2] && !tip11)
      begin
        if (byte_sel11[3])
          data[95:88] <= #Tp11 p_in11[31:24];
        if (byte_sel11[2])
          data[87:80] <= #Tp11 p_in11[23:16];
        if (byte_sel11[1])
          data[79:72] <= #Tp11 p_in11[15:8];
        if (byte_sel11[0])
          data[71:64] <= #Tp11 p_in11[7:0];
      end
    else if (latch11[3] && !tip11)
      begin
        if (byte_sel11[3])
          data[127:120] <= #Tp11 p_in11[31:24];
        if (byte_sel11[2])
          data[119:112] <= #Tp11 p_in11[23:16];
        if (byte_sel11[1])
          data[111:104] <= #Tp11 p_in11[15:8];
        if (byte_sel11[0])
          data[103:96] <= #Tp11 p_in11[7:0];
      end
`else
`ifdef SPI_MAX_CHAR_6411
    else if (latch11[0] && !tip11)
      begin
        if (byte_sel11[3])
          data[31:24] <= #Tp11 p_in11[31:24];
        if (byte_sel11[2])
          data[23:16] <= #Tp11 p_in11[23:16];
        if (byte_sel11[1])
          data[15:8] <= #Tp11 p_in11[15:8];
        if (byte_sel11[0])
          data[7:0] <= #Tp11 p_in11[7:0];
      end
    else if (latch11[1] && !tip11)
      begin
        if (byte_sel11[3])
          data[63:56] <= #Tp11 p_in11[31:24];
        if (byte_sel11[2])
          data[55:48] <= #Tp11 p_in11[23:16];
        if (byte_sel11[1])
          data[47:40] <= #Tp11 p_in11[15:8];
        if (byte_sel11[0])
          data[39:32] <= #Tp11 p_in11[7:0];
      end
`else
    else if (latch11[0] && !tip11)
      begin
      `ifdef SPI_MAX_CHAR_811
        if (byte_sel11[0])
          data[`SPI_MAX_CHAR11-1:0] <= #Tp11 p_in11[`SPI_MAX_CHAR11-1:0];
      `endif
      `ifdef SPI_MAX_CHAR_1611
        if (byte_sel11[0])
          data[7:0] <= #Tp11 p_in11[7:0];
        if (byte_sel11[1])
          data[`SPI_MAX_CHAR11-1:8] <= #Tp11 p_in11[`SPI_MAX_CHAR11-1:8];
      `endif
      `ifdef SPI_MAX_CHAR_2411
        if (byte_sel11[0])
          data[7:0] <= #Tp11 p_in11[7:0];
        if (byte_sel11[1])
          data[15:8] <= #Tp11 p_in11[15:8];
        if (byte_sel11[2])
          data[`SPI_MAX_CHAR11-1:16] <= #Tp11 p_in11[`SPI_MAX_CHAR11-1:16];
      `endif
      `ifdef SPI_MAX_CHAR_3211
        if (byte_sel11[0])
          data[7:0] <= #Tp11 p_in11[7:0];
        if (byte_sel11[1])
          data[15:8] <= #Tp11 p_in11[15:8];
        if (byte_sel11[2])
          data[23:16] <= #Tp11 p_in11[23:16];
        if (byte_sel11[3])
          data[`SPI_MAX_CHAR11-1:24] <= #Tp11 p_in11[`SPI_MAX_CHAR11-1:24];
      `endif
      end
`endif
`endif
    else
      data[rx_bit_pos11[`SPI_CHAR_LEN_BITS11-1:0]] <= #Tp11 rx_clk11 ? s_in11 : data[rx_bit_pos11[`SPI_CHAR_LEN_BITS11-1:0]];
  end
  
endmodule

