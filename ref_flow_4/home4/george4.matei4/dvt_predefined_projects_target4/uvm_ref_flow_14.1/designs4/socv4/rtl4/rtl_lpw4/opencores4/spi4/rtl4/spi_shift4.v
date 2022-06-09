//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_shift4.v                                                 ////
////                                                              ////
////  This4 file is part of the SPI4 IP4 core4 project4                ////
////  http4://www4.opencores4.org4/projects4/spi4/                      ////
////                                                              ////
////  Author4(s):                                                  ////
////      - Simon4 Srot4 (simons4@opencores4.org4)                     ////
////                                                              ////
////  All additional4 information is avaliable4 in the Readme4.txt4   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright4 (C) 2002 Authors4                                   ////
////                                                              ////
//// This4 source4 file may be used and distributed4 without         ////
//// restriction4 provided that this copyright4 statement4 is not    ////
//// removed from the file and that any derivative4 work4 contains4  ////
//// the original copyright4 notice4 and the associated disclaimer4. ////
////                                                              ////
//// This4 source4 file is free software4; you can redistribute4 it   ////
//// and/or modify it under the terms4 of the GNU4 Lesser4 General4   ////
//// Public4 License4 as published4 by the Free4 Software4 Foundation4; ////
//// either4 version4 2.1 of the License4, or (at your4 option) any   ////
//// later4 version4.                                               ////
////                                                              ////
//// This4 source4 is distributed4 in the hope4 that it will be       ////
//// useful4, but WITHOUT4 ANY4 WARRANTY4; without even4 the implied4   ////
//// warranty4 of MERCHANTABILITY4 or FITNESS4 FOR4 A PARTICULAR4      ////
//// PURPOSE4.  See the GNU4 Lesser4 General4 Public4 License4 for more ////
//// details4.                                                     ////
////                                                              ////
//// You should have received4 a copy of the GNU4 Lesser4 General4    ////
//// Public4 License4 along4 with this source4; if not, download4 it   ////
//// from http4://www4.opencores4.org4/lgpl4.shtml4                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines4.v"
`include "timescale.v"

module spi_shift4 (clk4, rst4, latch4, byte_sel4, len, lsb, go4,
                  pos_edge4, neg_edge4, rx_negedge4, tx_negedge4,
                  tip4, last, 
                  p_in4, p_out4, s_clk4, s_in4, s_out4);

  parameter Tp4 = 1;
  
  input                          clk4;          // system clock4
  input                          rst4;          // reset
  input                    [3:0] latch4;        // latch4 signal4 for storing4 the data in shift4 register
  input                    [3:0] byte_sel4;     // byte select4 signals4 for storing4 the data in shift4 register
  input [`SPI_CHAR_LEN_BITS4-1:0] len;          // data len in bits (minus4 one)
  input                          lsb;          // lbs4 first on the line
  input                          go4;           // start stansfer4
  input                          pos_edge4;     // recognize4 posedge of sclk4
  input                          neg_edge4;     // recognize4 negedge of sclk4
  input                          rx_negedge4;   // s_in4 is sampled4 on negative edge 
  input                          tx_negedge4;   // s_out4 is driven4 on negative edge
  output                         tip4;          // transfer4 in progress4
  output                         last;         // last bit
  input                   [31:0] p_in4;         // parallel4 in
  output     [`SPI_MAX_CHAR4-1:0] p_out4;        // parallel4 out
  input                          s_clk4;        // serial4 clock4
  input                          s_in4;         // serial4 in
  output                         s_out4;        // serial4 out
                                               
  reg                            s_out4;        
  reg                            tip4;
                              
  reg     [`SPI_CHAR_LEN_BITS4:0] cnt;          // data bit count
  reg        [`SPI_MAX_CHAR4-1:0] data;         // shift4 register
  wire    [`SPI_CHAR_LEN_BITS4:0] tx_bit_pos4;   // next bit position4
  wire    [`SPI_CHAR_LEN_BITS4:0] rx_bit_pos4;   // next bit position4
  wire                           rx_clk4;       // rx4 clock4 enable
  wire                           tx_clk4;       // tx4 clock4 enable
  
  assign p_out4 = data;
  
  assign tx_bit_pos4 = lsb ? {!(|len), len} - cnt : cnt - {{`SPI_CHAR_LEN_BITS4{1'b0}},1'b1};
  assign rx_bit_pos4 = lsb ? {!(|len), len} - (rx_negedge4 ? cnt + {{`SPI_CHAR_LEN_BITS4{1'b0}},1'b1} : cnt) : 
                            (rx_negedge4 ? cnt : cnt - {{`SPI_CHAR_LEN_BITS4{1'b0}},1'b1});
  
  assign last = !(|cnt);
  
  assign rx_clk4 = (rx_negedge4 ? neg_edge4 : pos_edge4) && (!last || s_clk4);
  assign tx_clk4 = (tx_negedge4 ? neg_edge4 : pos_edge4) && !last;
  
  // Character4 bit counter
  always @(posedge clk4 or posedge rst4)
  begin
    if(rst4)
      cnt <= #Tp4 {`SPI_CHAR_LEN_BITS4+1{1'b0}};
    else
      begin
        if(tip4)
          cnt <= #Tp4 pos_edge4 ? (cnt - {{`SPI_CHAR_LEN_BITS4{1'b0}}, 1'b1}) : cnt;
        else
          cnt <= #Tp4 !(|len) ? {1'b1, {`SPI_CHAR_LEN_BITS4{1'b0}}} : {1'b0, len};
      end
  end
  
  // Transfer4 in progress4
  always @(posedge clk4 or posedge rst4)
  begin
    if(rst4)
      tip4 <= #Tp4 1'b0;
  else if(go4 && ~tip4)
    tip4 <= #Tp4 1'b1;
  else if(tip4 && last && pos_edge4)
    tip4 <= #Tp4 1'b0;
  end
  
  // Sending4 bits to the line
  always @(posedge clk4 or posedge rst4)
  begin
    if (rst4)
      s_out4   <= #Tp4 1'b0;
    else
      s_out4 <= #Tp4 (tx_clk4 || !tip4) ? data[tx_bit_pos4[`SPI_CHAR_LEN_BITS4-1:0]] : s_out4;
  end
  
  // Receiving4 bits from the line
  always @(posedge clk4 or posedge rst4)
  begin
    if (rst4)
      data   <= #Tp4 {`SPI_MAX_CHAR4{1'b0}};
`ifdef SPI_MAX_CHAR_1284
    else if (latch4[0] && !tip4)
      begin
        if (byte_sel4[3])
          data[31:24] <= #Tp4 p_in4[31:24];
        if (byte_sel4[2])
          data[23:16] <= #Tp4 p_in4[23:16];
        if (byte_sel4[1])
          data[15:8] <= #Tp4 p_in4[15:8];
        if (byte_sel4[0])
          data[7:0] <= #Tp4 p_in4[7:0];
      end
    else if (latch4[1] && !tip4)
      begin
        if (byte_sel4[3])
          data[63:56] <= #Tp4 p_in4[31:24];
        if (byte_sel4[2])
          data[55:48] <= #Tp4 p_in4[23:16];
        if (byte_sel4[1])
          data[47:40] <= #Tp4 p_in4[15:8];
        if (byte_sel4[0])
          data[39:32] <= #Tp4 p_in4[7:0];
      end
    else if (latch4[2] && !tip4)
      begin
        if (byte_sel4[3])
          data[95:88] <= #Tp4 p_in4[31:24];
        if (byte_sel4[2])
          data[87:80] <= #Tp4 p_in4[23:16];
        if (byte_sel4[1])
          data[79:72] <= #Tp4 p_in4[15:8];
        if (byte_sel4[0])
          data[71:64] <= #Tp4 p_in4[7:0];
      end
    else if (latch4[3] && !tip4)
      begin
        if (byte_sel4[3])
          data[127:120] <= #Tp4 p_in4[31:24];
        if (byte_sel4[2])
          data[119:112] <= #Tp4 p_in4[23:16];
        if (byte_sel4[1])
          data[111:104] <= #Tp4 p_in4[15:8];
        if (byte_sel4[0])
          data[103:96] <= #Tp4 p_in4[7:0];
      end
`else
`ifdef SPI_MAX_CHAR_644
    else if (latch4[0] && !tip4)
      begin
        if (byte_sel4[3])
          data[31:24] <= #Tp4 p_in4[31:24];
        if (byte_sel4[2])
          data[23:16] <= #Tp4 p_in4[23:16];
        if (byte_sel4[1])
          data[15:8] <= #Tp4 p_in4[15:8];
        if (byte_sel4[0])
          data[7:0] <= #Tp4 p_in4[7:0];
      end
    else if (latch4[1] && !tip4)
      begin
        if (byte_sel4[3])
          data[63:56] <= #Tp4 p_in4[31:24];
        if (byte_sel4[2])
          data[55:48] <= #Tp4 p_in4[23:16];
        if (byte_sel4[1])
          data[47:40] <= #Tp4 p_in4[15:8];
        if (byte_sel4[0])
          data[39:32] <= #Tp4 p_in4[7:0];
      end
`else
    else if (latch4[0] && !tip4)
      begin
      `ifdef SPI_MAX_CHAR_84
        if (byte_sel4[0])
          data[`SPI_MAX_CHAR4-1:0] <= #Tp4 p_in4[`SPI_MAX_CHAR4-1:0];
      `endif
      `ifdef SPI_MAX_CHAR_164
        if (byte_sel4[0])
          data[7:0] <= #Tp4 p_in4[7:0];
        if (byte_sel4[1])
          data[`SPI_MAX_CHAR4-1:8] <= #Tp4 p_in4[`SPI_MAX_CHAR4-1:8];
      `endif
      `ifdef SPI_MAX_CHAR_244
        if (byte_sel4[0])
          data[7:0] <= #Tp4 p_in4[7:0];
        if (byte_sel4[1])
          data[15:8] <= #Tp4 p_in4[15:8];
        if (byte_sel4[2])
          data[`SPI_MAX_CHAR4-1:16] <= #Tp4 p_in4[`SPI_MAX_CHAR4-1:16];
      `endif
      `ifdef SPI_MAX_CHAR_324
        if (byte_sel4[0])
          data[7:0] <= #Tp4 p_in4[7:0];
        if (byte_sel4[1])
          data[15:8] <= #Tp4 p_in4[15:8];
        if (byte_sel4[2])
          data[23:16] <= #Tp4 p_in4[23:16];
        if (byte_sel4[3])
          data[`SPI_MAX_CHAR4-1:24] <= #Tp4 p_in4[`SPI_MAX_CHAR4-1:24];
      `endif
      end
`endif
`endif
    else
      data[rx_bit_pos4[`SPI_CHAR_LEN_BITS4-1:0]] <= #Tp4 rx_clk4 ? s_in4 : data[rx_bit_pos4[`SPI_CHAR_LEN_BITS4-1:0]];
  end
  
endmodule

