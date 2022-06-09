//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_shift10.v                                                 ////
////                                                              ////
////  This10 file is part of the SPI10 IP10 core10 project10                ////
////  http10://www10.opencores10.org10/projects10/spi10/                      ////
////                                                              ////
////  Author10(s):                                                  ////
////      - Simon10 Srot10 (simons10@opencores10.org10)                     ////
////                                                              ////
////  All additional10 information is avaliable10 in the Readme10.txt10   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright10 (C) 2002 Authors10                                   ////
////                                                              ////
//// This10 source10 file may be used and distributed10 without         ////
//// restriction10 provided that this copyright10 statement10 is not    ////
//// removed from the file and that any derivative10 work10 contains10  ////
//// the original copyright10 notice10 and the associated disclaimer10. ////
////                                                              ////
//// This10 source10 file is free software10; you can redistribute10 it   ////
//// and/or modify it under the terms10 of the GNU10 Lesser10 General10   ////
//// Public10 License10 as published10 by the Free10 Software10 Foundation10; ////
//// either10 version10 2.1 of the License10, or (at your10 option) any   ////
//// later10 version10.                                               ////
////                                                              ////
//// This10 source10 is distributed10 in the hope10 that it will be       ////
//// useful10, but WITHOUT10 ANY10 WARRANTY10; without even10 the implied10   ////
//// warranty10 of MERCHANTABILITY10 or FITNESS10 FOR10 A PARTICULAR10      ////
//// PURPOSE10.  See the GNU10 Lesser10 General10 Public10 License10 for more ////
//// details10.                                                     ////
////                                                              ////
//// You should have received10 a copy of the GNU10 Lesser10 General10    ////
//// Public10 License10 along10 with this source10; if not, download10 it   ////
//// from http10://www10.opencores10.org10/lgpl10.shtml10                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines10.v"
`include "timescale.v"

module spi_shift10 (clk10, rst10, latch10, byte_sel10, len, lsb, go10,
                  pos_edge10, neg_edge10, rx_negedge10, tx_negedge10,
                  tip10, last, 
                  p_in10, p_out10, s_clk10, s_in10, s_out10);

  parameter Tp10 = 1;
  
  input                          clk10;          // system clock10
  input                          rst10;          // reset
  input                    [3:0] latch10;        // latch10 signal10 for storing10 the data in shift10 register
  input                    [3:0] byte_sel10;     // byte select10 signals10 for storing10 the data in shift10 register
  input [`SPI_CHAR_LEN_BITS10-1:0] len;          // data len in bits (minus10 one)
  input                          lsb;          // lbs10 first on the line
  input                          go10;           // start stansfer10
  input                          pos_edge10;     // recognize10 posedge of sclk10
  input                          neg_edge10;     // recognize10 negedge of sclk10
  input                          rx_negedge10;   // s_in10 is sampled10 on negative edge 
  input                          tx_negedge10;   // s_out10 is driven10 on negative edge
  output                         tip10;          // transfer10 in progress10
  output                         last;         // last bit
  input                   [31:0] p_in10;         // parallel10 in
  output     [`SPI_MAX_CHAR10-1:0] p_out10;        // parallel10 out
  input                          s_clk10;        // serial10 clock10
  input                          s_in10;         // serial10 in
  output                         s_out10;        // serial10 out
                                               
  reg                            s_out10;        
  reg                            tip10;
                              
  reg     [`SPI_CHAR_LEN_BITS10:0] cnt;          // data bit count
  reg        [`SPI_MAX_CHAR10-1:0] data;         // shift10 register
  wire    [`SPI_CHAR_LEN_BITS10:0] tx_bit_pos10;   // next bit position10
  wire    [`SPI_CHAR_LEN_BITS10:0] rx_bit_pos10;   // next bit position10
  wire                           rx_clk10;       // rx10 clock10 enable
  wire                           tx_clk10;       // tx10 clock10 enable
  
  assign p_out10 = data;
  
  assign tx_bit_pos10 = lsb ? {!(|len), len} - cnt : cnt - {{`SPI_CHAR_LEN_BITS10{1'b0}},1'b1};
  assign rx_bit_pos10 = lsb ? {!(|len), len} - (rx_negedge10 ? cnt + {{`SPI_CHAR_LEN_BITS10{1'b0}},1'b1} : cnt) : 
                            (rx_negedge10 ? cnt : cnt - {{`SPI_CHAR_LEN_BITS10{1'b0}},1'b1});
  
  assign last = !(|cnt);
  
  assign rx_clk10 = (rx_negedge10 ? neg_edge10 : pos_edge10) && (!last || s_clk10);
  assign tx_clk10 = (tx_negedge10 ? neg_edge10 : pos_edge10) && !last;
  
  // Character10 bit counter
  always @(posedge clk10 or posedge rst10)
  begin
    if(rst10)
      cnt <= #Tp10 {`SPI_CHAR_LEN_BITS10+1{1'b0}};
    else
      begin
        if(tip10)
          cnt <= #Tp10 pos_edge10 ? (cnt - {{`SPI_CHAR_LEN_BITS10{1'b0}}, 1'b1}) : cnt;
        else
          cnt <= #Tp10 !(|len) ? {1'b1, {`SPI_CHAR_LEN_BITS10{1'b0}}} : {1'b0, len};
      end
  end
  
  // Transfer10 in progress10
  always @(posedge clk10 or posedge rst10)
  begin
    if(rst10)
      tip10 <= #Tp10 1'b0;
  else if(go10 && ~tip10)
    tip10 <= #Tp10 1'b1;
  else if(tip10 && last && pos_edge10)
    tip10 <= #Tp10 1'b0;
  end
  
  // Sending10 bits to the line
  always @(posedge clk10 or posedge rst10)
  begin
    if (rst10)
      s_out10   <= #Tp10 1'b0;
    else
      s_out10 <= #Tp10 (tx_clk10 || !tip10) ? data[tx_bit_pos10[`SPI_CHAR_LEN_BITS10-1:0]] : s_out10;
  end
  
  // Receiving10 bits from the line
  always @(posedge clk10 or posedge rst10)
  begin
    if (rst10)
      data   <= #Tp10 {`SPI_MAX_CHAR10{1'b0}};
`ifdef SPI_MAX_CHAR_12810
    else if (latch10[0] && !tip10)
      begin
        if (byte_sel10[3])
          data[31:24] <= #Tp10 p_in10[31:24];
        if (byte_sel10[2])
          data[23:16] <= #Tp10 p_in10[23:16];
        if (byte_sel10[1])
          data[15:8] <= #Tp10 p_in10[15:8];
        if (byte_sel10[0])
          data[7:0] <= #Tp10 p_in10[7:0];
      end
    else if (latch10[1] && !tip10)
      begin
        if (byte_sel10[3])
          data[63:56] <= #Tp10 p_in10[31:24];
        if (byte_sel10[2])
          data[55:48] <= #Tp10 p_in10[23:16];
        if (byte_sel10[1])
          data[47:40] <= #Tp10 p_in10[15:8];
        if (byte_sel10[0])
          data[39:32] <= #Tp10 p_in10[7:0];
      end
    else if (latch10[2] && !tip10)
      begin
        if (byte_sel10[3])
          data[95:88] <= #Tp10 p_in10[31:24];
        if (byte_sel10[2])
          data[87:80] <= #Tp10 p_in10[23:16];
        if (byte_sel10[1])
          data[79:72] <= #Tp10 p_in10[15:8];
        if (byte_sel10[0])
          data[71:64] <= #Tp10 p_in10[7:0];
      end
    else if (latch10[3] && !tip10)
      begin
        if (byte_sel10[3])
          data[127:120] <= #Tp10 p_in10[31:24];
        if (byte_sel10[2])
          data[119:112] <= #Tp10 p_in10[23:16];
        if (byte_sel10[1])
          data[111:104] <= #Tp10 p_in10[15:8];
        if (byte_sel10[0])
          data[103:96] <= #Tp10 p_in10[7:0];
      end
`else
`ifdef SPI_MAX_CHAR_6410
    else if (latch10[0] && !tip10)
      begin
        if (byte_sel10[3])
          data[31:24] <= #Tp10 p_in10[31:24];
        if (byte_sel10[2])
          data[23:16] <= #Tp10 p_in10[23:16];
        if (byte_sel10[1])
          data[15:8] <= #Tp10 p_in10[15:8];
        if (byte_sel10[0])
          data[7:0] <= #Tp10 p_in10[7:0];
      end
    else if (latch10[1] && !tip10)
      begin
        if (byte_sel10[3])
          data[63:56] <= #Tp10 p_in10[31:24];
        if (byte_sel10[2])
          data[55:48] <= #Tp10 p_in10[23:16];
        if (byte_sel10[1])
          data[47:40] <= #Tp10 p_in10[15:8];
        if (byte_sel10[0])
          data[39:32] <= #Tp10 p_in10[7:0];
      end
`else
    else if (latch10[0] && !tip10)
      begin
      `ifdef SPI_MAX_CHAR_810
        if (byte_sel10[0])
          data[`SPI_MAX_CHAR10-1:0] <= #Tp10 p_in10[`SPI_MAX_CHAR10-1:0];
      `endif
      `ifdef SPI_MAX_CHAR_1610
        if (byte_sel10[0])
          data[7:0] <= #Tp10 p_in10[7:0];
        if (byte_sel10[1])
          data[`SPI_MAX_CHAR10-1:8] <= #Tp10 p_in10[`SPI_MAX_CHAR10-1:8];
      `endif
      `ifdef SPI_MAX_CHAR_2410
        if (byte_sel10[0])
          data[7:0] <= #Tp10 p_in10[7:0];
        if (byte_sel10[1])
          data[15:8] <= #Tp10 p_in10[15:8];
        if (byte_sel10[2])
          data[`SPI_MAX_CHAR10-1:16] <= #Tp10 p_in10[`SPI_MAX_CHAR10-1:16];
      `endif
      `ifdef SPI_MAX_CHAR_3210
        if (byte_sel10[0])
          data[7:0] <= #Tp10 p_in10[7:0];
        if (byte_sel10[1])
          data[15:8] <= #Tp10 p_in10[15:8];
        if (byte_sel10[2])
          data[23:16] <= #Tp10 p_in10[23:16];
        if (byte_sel10[3])
          data[`SPI_MAX_CHAR10-1:24] <= #Tp10 p_in10[`SPI_MAX_CHAR10-1:24];
      `endif
      end
`endif
`endif
    else
      data[rx_bit_pos10[`SPI_CHAR_LEN_BITS10-1:0]] <= #Tp10 rx_clk10 ? s_in10 : data[rx_bit_pos10[`SPI_CHAR_LEN_BITS10-1:0]];
  end
  
endmodule

