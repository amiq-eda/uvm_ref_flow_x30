//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_shift21.v                                                 ////
////                                                              ////
////  This21 file is part of the SPI21 IP21 core21 project21                ////
////  http21://www21.opencores21.org21/projects21/spi21/                      ////
////                                                              ////
////  Author21(s):                                                  ////
////      - Simon21 Srot21 (simons21@opencores21.org21)                     ////
////                                                              ////
////  All additional21 information is avaliable21 in the Readme21.txt21   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright21 (C) 2002 Authors21                                   ////
////                                                              ////
//// This21 source21 file may be used and distributed21 without         ////
//// restriction21 provided that this copyright21 statement21 is not    ////
//// removed from the file and that any derivative21 work21 contains21  ////
//// the original copyright21 notice21 and the associated disclaimer21. ////
////                                                              ////
//// This21 source21 file is free software21; you can redistribute21 it   ////
//// and/or modify it under the terms21 of the GNU21 Lesser21 General21   ////
//// Public21 License21 as published21 by the Free21 Software21 Foundation21; ////
//// either21 version21 2.1 of the License21, or (at your21 option) any   ////
//// later21 version21.                                               ////
////                                                              ////
//// This21 source21 is distributed21 in the hope21 that it will be       ////
//// useful21, but WITHOUT21 ANY21 WARRANTY21; without even21 the implied21   ////
//// warranty21 of MERCHANTABILITY21 or FITNESS21 FOR21 A PARTICULAR21      ////
//// PURPOSE21.  See the GNU21 Lesser21 General21 Public21 License21 for more ////
//// details21.                                                     ////
////                                                              ////
//// You should have received21 a copy of the GNU21 Lesser21 General21    ////
//// Public21 License21 along21 with this source21; if not, download21 it   ////
//// from http21://www21.opencores21.org21/lgpl21.shtml21                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines21.v"
`include "timescale.v"

module spi_shift21 (clk21, rst21, latch21, byte_sel21, len, lsb, go21,
                  pos_edge21, neg_edge21, rx_negedge21, tx_negedge21,
                  tip21, last, 
                  p_in21, p_out21, s_clk21, s_in21, s_out21);

  parameter Tp21 = 1;
  
  input                          clk21;          // system clock21
  input                          rst21;          // reset
  input                    [3:0] latch21;        // latch21 signal21 for storing21 the data in shift21 register
  input                    [3:0] byte_sel21;     // byte select21 signals21 for storing21 the data in shift21 register
  input [`SPI_CHAR_LEN_BITS21-1:0] len;          // data len in bits (minus21 one)
  input                          lsb;          // lbs21 first on the line
  input                          go21;           // start stansfer21
  input                          pos_edge21;     // recognize21 posedge of sclk21
  input                          neg_edge21;     // recognize21 negedge of sclk21
  input                          rx_negedge21;   // s_in21 is sampled21 on negative edge 
  input                          tx_negedge21;   // s_out21 is driven21 on negative edge
  output                         tip21;          // transfer21 in progress21
  output                         last;         // last bit
  input                   [31:0] p_in21;         // parallel21 in
  output     [`SPI_MAX_CHAR21-1:0] p_out21;        // parallel21 out
  input                          s_clk21;        // serial21 clock21
  input                          s_in21;         // serial21 in
  output                         s_out21;        // serial21 out
                                               
  reg                            s_out21;        
  reg                            tip21;
                              
  reg     [`SPI_CHAR_LEN_BITS21:0] cnt;          // data bit count
  reg        [`SPI_MAX_CHAR21-1:0] data;         // shift21 register
  wire    [`SPI_CHAR_LEN_BITS21:0] tx_bit_pos21;   // next bit position21
  wire    [`SPI_CHAR_LEN_BITS21:0] rx_bit_pos21;   // next bit position21
  wire                           rx_clk21;       // rx21 clock21 enable
  wire                           tx_clk21;       // tx21 clock21 enable
  
  assign p_out21 = data;
  
  assign tx_bit_pos21 = lsb ? {!(|len), len} - cnt : cnt - {{`SPI_CHAR_LEN_BITS21{1'b0}},1'b1};
  assign rx_bit_pos21 = lsb ? {!(|len), len} - (rx_negedge21 ? cnt + {{`SPI_CHAR_LEN_BITS21{1'b0}},1'b1} : cnt) : 
                            (rx_negedge21 ? cnt : cnt - {{`SPI_CHAR_LEN_BITS21{1'b0}},1'b1});
  
  assign last = !(|cnt);
  
  assign rx_clk21 = (rx_negedge21 ? neg_edge21 : pos_edge21) && (!last || s_clk21);
  assign tx_clk21 = (tx_negedge21 ? neg_edge21 : pos_edge21) && !last;
  
  // Character21 bit counter
  always @(posedge clk21 or posedge rst21)
  begin
    if(rst21)
      cnt <= #Tp21 {`SPI_CHAR_LEN_BITS21+1{1'b0}};
    else
      begin
        if(tip21)
          cnt <= #Tp21 pos_edge21 ? (cnt - {{`SPI_CHAR_LEN_BITS21{1'b0}}, 1'b1}) : cnt;
        else
          cnt <= #Tp21 !(|len) ? {1'b1, {`SPI_CHAR_LEN_BITS21{1'b0}}} : {1'b0, len};
      end
  end
  
  // Transfer21 in progress21
  always @(posedge clk21 or posedge rst21)
  begin
    if(rst21)
      tip21 <= #Tp21 1'b0;
  else if(go21 && ~tip21)
    tip21 <= #Tp21 1'b1;
  else if(tip21 && last && pos_edge21)
    tip21 <= #Tp21 1'b0;
  end
  
  // Sending21 bits to the line
  always @(posedge clk21 or posedge rst21)
  begin
    if (rst21)
      s_out21   <= #Tp21 1'b0;
    else
      s_out21 <= #Tp21 (tx_clk21 || !tip21) ? data[tx_bit_pos21[`SPI_CHAR_LEN_BITS21-1:0]] : s_out21;
  end
  
  // Receiving21 bits from the line
  always @(posedge clk21 or posedge rst21)
  begin
    if (rst21)
      data   <= #Tp21 {`SPI_MAX_CHAR21{1'b0}};
`ifdef SPI_MAX_CHAR_12821
    else if (latch21[0] && !tip21)
      begin
        if (byte_sel21[3])
          data[31:24] <= #Tp21 p_in21[31:24];
        if (byte_sel21[2])
          data[23:16] <= #Tp21 p_in21[23:16];
        if (byte_sel21[1])
          data[15:8] <= #Tp21 p_in21[15:8];
        if (byte_sel21[0])
          data[7:0] <= #Tp21 p_in21[7:0];
      end
    else if (latch21[1] && !tip21)
      begin
        if (byte_sel21[3])
          data[63:56] <= #Tp21 p_in21[31:24];
        if (byte_sel21[2])
          data[55:48] <= #Tp21 p_in21[23:16];
        if (byte_sel21[1])
          data[47:40] <= #Tp21 p_in21[15:8];
        if (byte_sel21[0])
          data[39:32] <= #Tp21 p_in21[7:0];
      end
    else if (latch21[2] && !tip21)
      begin
        if (byte_sel21[3])
          data[95:88] <= #Tp21 p_in21[31:24];
        if (byte_sel21[2])
          data[87:80] <= #Tp21 p_in21[23:16];
        if (byte_sel21[1])
          data[79:72] <= #Tp21 p_in21[15:8];
        if (byte_sel21[0])
          data[71:64] <= #Tp21 p_in21[7:0];
      end
    else if (latch21[3] && !tip21)
      begin
        if (byte_sel21[3])
          data[127:120] <= #Tp21 p_in21[31:24];
        if (byte_sel21[2])
          data[119:112] <= #Tp21 p_in21[23:16];
        if (byte_sel21[1])
          data[111:104] <= #Tp21 p_in21[15:8];
        if (byte_sel21[0])
          data[103:96] <= #Tp21 p_in21[7:0];
      end
`else
`ifdef SPI_MAX_CHAR_6421
    else if (latch21[0] && !tip21)
      begin
        if (byte_sel21[3])
          data[31:24] <= #Tp21 p_in21[31:24];
        if (byte_sel21[2])
          data[23:16] <= #Tp21 p_in21[23:16];
        if (byte_sel21[1])
          data[15:8] <= #Tp21 p_in21[15:8];
        if (byte_sel21[0])
          data[7:0] <= #Tp21 p_in21[7:0];
      end
    else if (latch21[1] && !tip21)
      begin
        if (byte_sel21[3])
          data[63:56] <= #Tp21 p_in21[31:24];
        if (byte_sel21[2])
          data[55:48] <= #Tp21 p_in21[23:16];
        if (byte_sel21[1])
          data[47:40] <= #Tp21 p_in21[15:8];
        if (byte_sel21[0])
          data[39:32] <= #Tp21 p_in21[7:0];
      end
`else
    else if (latch21[0] && !tip21)
      begin
      `ifdef SPI_MAX_CHAR_821
        if (byte_sel21[0])
          data[`SPI_MAX_CHAR21-1:0] <= #Tp21 p_in21[`SPI_MAX_CHAR21-1:0];
      `endif
      `ifdef SPI_MAX_CHAR_1621
        if (byte_sel21[0])
          data[7:0] <= #Tp21 p_in21[7:0];
        if (byte_sel21[1])
          data[`SPI_MAX_CHAR21-1:8] <= #Tp21 p_in21[`SPI_MAX_CHAR21-1:8];
      `endif
      `ifdef SPI_MAX_CHAR_2421
        if (byte_sel21[0])
          data[7:0] <= #Tp21 p_in21[7:0];
        if (byte_sel21[1])
          data[15:8] <= #Tp21 p_in21[15:8];
        if (byte_sel21[2])
          data[`SPI_MAX_CHAR21-1:16] <= #Tp21 p_in21[`SPI_MAX_CHAR21-1:16];
      `endif
      `ifdef SPI_MAX_CHAR_3221
        if (byte_sel21[0])
          data[7:0] <= #Tp21 p_in21[7:0];
        if (byte_sel21[1])
          data[15:8] <= #Tp21 p_in21[15:8];
        if (byte_sel21[2])
          data[23:16] <= #Tp21 p_in21[23:16];
        if (byte_sel21[3])
          data[`SPI_MAX_CHAR21-1:24] <= #Tp21 p_in21[`SPI_MAX_CHAR21-1:24];
      `endif
      end
`endif
`endif
    else
      data[rx_bit_pos21[`SPI_CHAR_LEN_BITS21-1:0]] <= #Tp21 rx_clk21 ? s_in21 : data[rx_bit_pos21[`SPI_CHAR_LEN_BITS21-1:0]];
  end
  
endmodule

