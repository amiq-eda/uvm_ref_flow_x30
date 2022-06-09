//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_shift9.v                                                 ////
////                                                              ////
////  This9 file is part of the SPI9 IP9 core9 project9                ////
////  http9://www9.opencores9.org9/projects9/spi9/                      ////
////                                                              ////
////  Author9(s):                                                  ////
////      - Simon9 Srot9 (simons9@opencores9.org9)                     ////
////                                                              ////
////  All additional9 information is avaliable9 in the Readme9.txt9   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright9 (C) 2002 Authors9                                   ////
////                                                              ////
//// This9 source9 file may be used and distributed9 without         ////
//// restriction9 provided that this copyright9 statement9 is not    ////
//// removed from the file and that any derivative9 work9 contains9  ////
//// the original copyright9 notice9 and the associated disclaimer9. ////
////                                                              ////
//// This9 source9 file is free software9; you can redistribute9 it   ////
//// and/or modify it under the terms9 of the GNU9 Lesser9 General9   ////
//// Public9 License9 as published9 by the Free9 Software9 Foundation9; ////
//// either9 version9 2.1 of the License9, or (at your9 option) any   ////
//// later9 version9.                                               ////
////                                                              ////
//// This9 source9 is distributed9 in the hope9 that it will be       ////
//// useful9, but WITHOUT9 ANY9 WARRANTY9; without even9 the implied9   ////
//// warranty9 of MERCHANTABILITY9 or FITNESS9 FOR9 A PARTICULAR9      ////
//// PURPOSE9.  See the GNU9 Lesser9 General9 Public9 License9 for more ////
//// details9.                                                     ////
////                                                              ////
//// You should have received9 a copy of the GNU9 Lesser9 General9    ////
//// Public9 License9 along9 with this source9; if not, download9 it   ////
//// from http9://www9.opencores9.org9/lgpl9.shtml9                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines9.v"
`include "timescale.v"

module spi_shift9 (clk9, rst9, latch9, byte_sel9, len, lsb, go9,
                  pos_edge9, neg_edge9, rx_negedge9, tx_negedge9,
                  tip9, last, 
                  p_in9, p_out9, s_clk9, s_in9, s_out9);

  parameter Tp9 = 1;
  
  input                          clk9;          // system clock9
  input                          rst9;          // reset
  input                    [3:0] latch9;        // latch9 signal9 for storing9 the data in shift9 register
  input                    [3:0] byte_sel9;     // byte select9 signals9 for storing9 the data in shift9 register
  input [`SPI_CHAR_LEN_BITS9-1:0] len;          // data len in bits (minus9 one)
  input                          lsb;          // lbs9 first on the line
  input                          go9;           // start stansfer9
  input                          pos_edge9;     // recognize9 posedge of sclk9
  input                          neg_edge9;     // recognize9 negedge of sclk9
  input                          rx_negedge9;   // s_in9 is sampled9 on negative edge 
  input                          tx_negedge9;   // s_out9 is driven9 on negative edge
  output                         tip9;          // transfer9 in progress9
  output                         last;         // last bit
  input                   [31:0] p_in9;         // parallel9 in
  output     [`SPI_MAX_CHAR9-1:0] p_out9;        // parallel9 out
  input                          s_clk9;        // serial9 clock9
  input                          s_in9;         // serial9 in
  output                         s_out9;        // serial9 out
                                               
  reg                            s_out9;        
  reg                            tip9;
                              
  reg     [`SPI_CHAR_LEN_BITS9:0] cnt;          // data bit count
  reg        [`SPI_MAX_CHAR9-1:0] data;         // shift9 register
  wire    [`SPI_CHAR_LEN_BITS9:0] tx_bit_pos9;   // next bit position9
  wire    [`SPI_CHAR_LEN_BITS9:0] rx_bit_pos9;   // next bit position9
  wire                           rx_clk9;       // rx9 clock9 enable
  wire                           tx_clk9;       // tx9 clock9 enable
  
  assign p_out9 = data;
  
  assign tx_bit_pos9 = lsb ? {!(|len), len} - cnt : cnt - {{`SPI_CHAR_LEN_BITS9{1'b0}},1'b1};
  assign rx_bit_pos9 = lsb ? {!(|len), len} - (rx_negedge9 ? cnt + {{`SPI_CHAR_LEN_BITS9{1'b0}},1'b1} : cnt) : 
                            (rx_negedge9 ? cnt : cnt - {{`SPI_CHAR_LEN_BITS9{1'b0}},1'b1});
  
  assign last = !(|cnt);
  
  assign rx_clk9 = (rx_negedge9 ? neg_edge9 : pos_edge9) && (!last || s_clk9);
  assign tx_clk9 = (tx_negedge9 ? neg_edge9 : pos_edge9) && !last;
  
  // Character9 bit counter
  always @(posedge clk9 or posedge rst9)
  begin
    if(rst9)
      cnt <= #Tp9 {`SPI_CHAR_LEN_BITS9+1{1'b0}};
    else
      begin
        if(tip9)
          cnt <= #Tp9 pos_edge9 ? (cnt - {{`SPI_CHAR_LEN_BITS9{1'b0}}, 1'b1}) : cnt;
        else
          cnt <= #Tp9 !(|len) ? {1'b1, {`SPI_CHAR_LEN_BITS9{1'b0}}} : {1'b0, len};
      end
  end
  
  // Transfer9 in progress9
  always @(posedge clk9 or posedge rst9)
  begin
    if(rst9)
      tip9 <= #Tp9 1'b0;
  else if(go9 && ~tip9)
    tip9 <= #Tp9 1'b1;
  else if(tip9 && last && pos_edge9)
    tip9 <= #Tp9 1'b0;
  end
  
  // Sending9 bits to the line
  always @(posedge clk9 or posedge rst9)
  begin
    if (rst9)
      s_out9   <= #Tp9 1'b0;
    else
      s_out9 <= #Tp9 (tx_clk9 || !tip9) ? data[tx_bit_pos9[`SPI_CHAR_LEN_BITS9-1:0]] : s_out9;
  end
  
  // Receiving9 bits from the line
  always @(posedge clk9 or posedge rst9)
  begin
    if (rst9)
      data   <= #Tp9 {`SPI_MAX_CHAR9{1'b0}};
`ifdef SPI_MAX_CHAR_1289
    else if (latch9[0] && !tip9)
      begin
        if (byte_sel9[3])
          data[31:24] <= #Tp9 p_in9[31:24];
        if (byte_sel9[2])
          data[23:16] <= #Tp9 p_in9[23:16];
        if (byte_sel9[1])
          data[15:8] <= #Tp9 p_in9[15:8];
        if (byte_sel9[0])
          data[7:0] <= #Tp9 p_in9[7:0];
      end
    else if (latch9[1] && !tip9)
      begin
        if (byte_sel9[3])
          data[63:56] <= #Tp9 p_in9[31:24];
        if (byte_sel9[2])
          data[55:48] <= #Tp9 p_in9[23:16];
        if (byte_sel9[1])
          data[47:40] <= #Tp9 p_in9[15:8];
        if (byte_sel9[0])
          data[39:32] <= #Tp9 p_in9[7:0];
      end
    else if (latch9[2] && !tip9)
      begin
        if (byte_sel9[3])
          data[95:88] <= #Tp9 p_in9[31:24];
        if (byte_sel9[2])
          data[87:80] <= #Tp9 p_in9[23:16];
        if (byte_sel9[1])
          data[79:72] <= #Tp9 p_in9[15:8];
        if (byte_sel9[0])
          data[71:64] <= #Tp9 p_in9[7:0];
      end
    else if (latch9[3] && !tip9)
      begin
        if (byte_sel9[3])
          data[127:120] <= #Tp9 p_in9[31:24];
        if (byte_sel9[2])
          data[119:112] <= #Tp9 p_in9[23:16];
        if (byte_sel9[1])
          data[111:104] <= #Tp9 p_in9[15:8];
        if (byte_sel9[0])
          data[103:96] <= #Tp9 p_in9[7:0];
      end
`else
`ifdef SPI_MAX_CHAR_649
    else if (latch9[0] && !tip9)
      begin
        if (byte_sel9[3])
          data[31:24] <= #Tp9 p_in9[31:24];
        if (byte_sel9[2])
          data[23:16] <= #Tp9 p_in9[23:16];
        if (byte_sel9[1])
          data[15:8] <= #Tp9 p_in9[15:8];
        if (byte_sel9[0])
          data[7:0] <= #Tp9 p_in9[7:0];
      end
    else if (latch9[1] && !tip9)
      begin
        if (byte_sel9[3])
          data[63:56] <= #Tp9 p_in9[31:24];
        if (byte_sel9[2])
          data[55:48] <= #Tp9 p_in9[23:16];
        if (byte_sel9[1])
          data[47:40] <= #Tp9 p_in9[15:8];
        if (byte_sel9[0])
          data[39:32] <= #Tp9 p_in9[7:0];
      end
`else
    else if (latch9[0] && !tip9)
      begin
      `ifdef SPI_MAX_CHAR_89
        if (byte_sel9[0])
          data[`SPI_MAX_CHAR9-1:0] <= #Tp9 p_in9[`SPI_MAX_CHAR9-1:0];
      `endif
      `ifdef SPI_MAX_CHAR_169
        if (byte_sel9[0])
          data[7:0] <= #Tp9 p_in9[7:0];
        if (byte_sel9[1])
          data[`SPI_MAX_CHAR9-1:8] <= #Tp9 p_in9[`SPI_MAX_CHAR9-1:8];
      `endif
      `ifdef SPI_MAX_CHAR_249
        if (byte_sel9[0])
          data[7:0] <= #Tp9 p_in9[7:0];
        if (byte_sel9[1])
          data[15:8] <= #Tp9 p_in9[15:8];
        if (byte_sel9[2])
          data[`SPI_MAX_CHAR9-1:16] <= #Tp9 p_in9[`SPI_MAX_CHAR9-1:16];
      `endif
      `ifdef SPI_MAX_CHAR_329
        if (byte_sel9[0])
          data[7:0] <= #Tp9 p_in9[7:0];
        if (byte_sel9[1])
          data[15:8] <= #Tp9 p_in9[15:8];
        if (byte_sel9[2])
          data[23:16] <= #Tp9 p_in9[23:16];
        if (byte_sel9[3])
          data[`SPI_MAX_CHAR9-1:24] <= #Tp9 p_in9[`SPI_MAX_CHAR9-1:24];
      `endif
      end
`endif
`endif
    else
      data[rx_bit_pos9[`SPI_CHAR_LEN_BITS9-1:0]] <= #Tp9 rx_clk9 ? s_in9 : data[rx_bit_pos9[`SPI_CHAR_LEN_BITS9-1:0]];
  end
  
endmodule

