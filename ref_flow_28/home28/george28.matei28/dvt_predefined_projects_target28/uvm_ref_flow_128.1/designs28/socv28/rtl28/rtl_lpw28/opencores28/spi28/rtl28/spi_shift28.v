//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_shift28.v                                                 ////
////                                                              ////
////  This28 file is part of the SPI28 IP28 core28 project28                ////
////  http28://www28.opencores28.org28/projects28/spi28/                      ////
////                                                              ////
////  Author28(s):                                                  ////
////      - Simon28 Srot28 (simons28@opencores28.org28)                     ////
////                                                              ////
////  All additional28 information is avaliable28 in the Readme28.txt28   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright28 (C) 2002 Authors28                                   ////
////                                                              ////
//// This28 source28 file may be used and distributed28 without         ////
//// restriction28 provided that this copyright28 statement28 is not    ////
//// removed from the file and that any derivative28 work28 contains28  ////
//// the original copyright28 notice28 and the associated disclaimer28. ////
////                                                              ////
//// This28 source28 file is free software28; you can redistribute28 it   ////
//// and/or modify it under the terms28 of the GNU28 Lesser28 General28   ////
//// Public28 License28 as published28 by the Free28 Software28 Foundation28; ////
//// either28 version28 2.1 of the License28, or (at your28 option) any   ////
//// later28 version28.                                               ////
////                                                              ////
//// This28 source28 is distributed28 in the hope28 that it will be       ////
//// useful28, but WITHOUT28 ANY28 WARRANTY28; without even28 the implied28   ////
//// warranty28 of MERCHANTABILITY28 or FITNESS28 FOR28 A PARTICULAR28      ////
//// PURPOSE28.  See the GNU28 Lesser28 General28 Public28 License28 for more ////
//// details28.                                                     ////
////                                                              ////
//// You should have received28 a copy of the GNU28 Lesser28 General28    ////
//// Public28 License28 along28 with this source28; if not, download28 it   ////
//// from http28://www28.opencores28.org28/lgpl28.shtml28                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines28.v"
`include "timescale.v"

module spi_shift28 (clk28, rst28, latch28, byte_sel28, len, lsb, go28,
                  pos_edge28, neg_edge28, rx_negedge28, tx_negedge28,
                  tip28, last, 
                  p_in28, p_out28, s_clk28, s_in28, s_out28);

  parameter Tp28 = 1;
  
  input                          clk28;          // system clock28
  input                          rst28;          // reset
  input                    [3:0] latch28;        // latch28 signal28 for storing28 the data in shift28 register
  input                    [3:0] byte_sel28;     // byte select28 signals28 for storing28 the data in shift28 register
  input [`SPI_CHAR_LEN_BITS28-1:0] len;          // data len in bits (minus28 one)
  input                          lsb;          // lbs28 first on the line
  input                          go28;           // start stansfer28
  input                          pos_edge28;     // recognize28 posedge of sclk28
  input                          neg_edge28;     // recognize28 negedge of sclk28
  input                          rx_negedge28;   // s_in28 is sampled28 on negative edge 
  input                          tx_negedge28;   // s_out28 is driven28 on negative edge
  output                         tip28;          // transfer28 in progress28
  output                         last;         // last bit
  input                   [31:0] p_in28;         // parallel28 in
  output     [`SPI_MAX_CHAR28-1:0] p_out28;        // parallel28 out
  input                          s_clk28;        // serial28 clock28
  input                          s_in28;         // serial28 in
  output                         s_out28;        // serial28 out
                                               
  reg                            s_out28;        
  reg                            tip28;
                              
  reg     [`SPI_CHAR_LEN_BITS28:0] cnt;          // data bit count
  reg        [`SPI_MAX_CHAR28-1:0] data;         // shift28 register
  wire    [`SPI_CHAR_LEN_BITS28:0] tx_bit_pos28;   // next bit position28
  wire    [`SPI_CHAR_LEN_BITS28:0] rx_bit_pos28;   // next bit position28
  wire                           rx_clk28;       // rx28 clock28 enable
  wire                           tx_clk28;       // tx28 clock28 enable
  
  assign p_out28 = data;
  
  assign tx_bit_pos28 = lsb ? {!(|len), len} - cnt : cnt - {{`SPI_CHAR_LEN_BITS28{1'b0}},1'b1};
  assign rx_bit_pos28 = lsb ? {!(|len), len} - (rx_negedge28 ? cnt + {{`SPI_CHAR_LEN_BITS28{1'b0}},1'b1} : cnt) : 
                            (rx_negedge28 ? cnt : cnt - {{`SPI_CHAR_LEN_BITS28{1'b0}},1'b1});
  
  assign last = !(|cnt);
  
  assign rx_clk28 = (rx_negedge28 ? neg_edge28 : pos_edge28) && (!last || s_clk28);
  assign tx_clk28 = (tx_negedge28 ? neg_edge28 : pos_edge28) && !last;
  
  // Character28 bit counter
  always @(posedge clk28 or posedge rst28)
  begin
    if(rst28)
      cnt <= #Tp28 {`SPI_CHAR_LEN_BITS28+1{1'b0}};
    else
      begin
        if(tip28)
          cnt <= #Tp28 pos_edge28 ? (cnt - {{`SPI_CHAR_LEN_BITS28{1'b0}}, 1'b1}) : cnt;
        else
          cnt <= #Tp28 !(|len) ? {1'b1, {`SPI_CHAR_LEN_BITS28{1'b0}}} : {1'b0, len};
      end
  end
  
  // Transfer28 in progress28
  always @(posedge clk28 or posedge rst28)
  begin
    if(rst28)
      tip28 <= #Tp28 1'b0;
  else if(go28 && ~tip28)
    tip28 <= #Tp28 1'b1;
  else if(tip28 && last && pos_edge28)
    tip28 <= #Tp28 1'b0;
  end
  
  // Sending28 bits to the line
  always @(posedge clk28 or posedge rst28)
  begin
    if (rst28)
      s_out28   <= #Tp28 1'b0;
    else
      s_out28 <= #Tp28 (tx_clk28 || !tip28) ? data[tx_bit_pos28[`SPI_CHAR_LEN_BITS28-1:0]] : s_out28;
  end
  
  // Receiving28 bits from the line
  always @(posedge clk28 or posedge rst28)
  begin
    if (rst28)
      data   <= #Tp28 {`SPI_MAX_CHAR28{1'b0}};
`ifdef SPI_MAX_CHAR_12828
    else if (latch28[0] && !tip28)
      begin
        if (byte_sel28[3])
          data[31:24] <= #Tp28 p_in28[31:24];
        if (byte_sel28[2])
          data[23:16] <= #Tp28 p_in28[23:16];
        if (byte_sel28[1])
          data[15:8] <= #Tp28 p_in28[15:8];
        if (byte_sel28[0])
          data[7:0] <= #Tp28 p_in28[7:0];
      end
    else if (latch28[1] && !tip28)
      begin
        if (byte_sel28[3])
          data[63:56] <= #Tp28 p_in28[31:24];
        if (byte_sel28[2])
          data[55:48] <= #Tp28 p_in28[23:16];
        if (byte_sel28[1])
          data[47:40] <= #Tp28 p_in28[15:8];
        if (byte_sel28[0])
          data[39:32] <= #Tp28 p_in28[7:0];
      end
    else if (latch28[2] && !tip28)
      begin
        if (byte_sel28[3])
          data[95:88] <= #Tp28 p_in28[31:24];
        if (byte_sel28[2])
          data[87:80] <= #Tp28 p_in28[23:16];
        if (byte_sel28[1])
          data[79:72] <= #Tp28 p_in28[15:8];
        if (byte_sel28[0])
          data[71:64] <= #Tp28 p_in28[7:0];
      end
    else if (latch28[3] && !tip28)
      begin
        if (byte_sel28[3])
          data[127:120] <= #Tp28 p_in28[31:24];
        if (byte_sel28[2])
          data[119:112] <= #Tp28 p_in28[23:16];
        if (byte_sel28[1])
          data[111:104] <= #Tp28 p_in28[15:8];
        if (byte_sel28[0])
          data[103:96] <= #Tp28 p_in28[7:0];
      end
`else
`ifdef SPI_MAX_CHAR_6428
    else if (latch28[0] && !tip28)
      begin
        if (byte_sel28[3])
          data[31:24] <= #Tp28 p_in28[31:24];
        if (byte_sel28[2])
          data[23:16] <= #Tp28 p_in28[23:16];
        if (byte_sel28[1])
          data[15:8] <= #Tp28 p_in28[15:8];
        if (byte_sel28[0])
          data[7:0] <= #Tp28 p_in28[7:0];
      end
    else if (latch28[1] && !tip28)
      begin
        if (byte_sel28[3])
          data[63:56] <= #Tp28 p_in28[31:24];
        if (byte_sel28[2])
          data[55:48] <= #Tp28 p_in28[23:16];
        if (byte_sel28[1])
          data[47:40] <= #Tp28 p_in28[15:8];
        if (byte_sel28[0])
          data[39:32] <= #Tp28 p_in28[7:0];
      end
`else
    else if (latch28[0] && !tip28)
      begin
      `ifdef SPI_MAX_CHAR_828
        if (byte_sel28[0])
          data[`SPI_MAX_CHAR28-1:0] <= #Tp28 p_in28[`SPI_MAX_CHAR28-1:0];
      `endif
      `ifdef SPI_MAX_CHAR_1628
        if (byte_sel28[0])
          data[7:0] <= #Tp28 p_in28[7:0];
        if (byte_sel28[1])
          data[`SPI_MAX_CHAR28-1:8] <= #Tp28 p_in28[`SPI_MAX_CHAR28-1:8];
      `endif
      `ifdef SPI_MAX_CHAR_2428
        if (byte_sel28[0])
          data[7:0] <= #Tp28 p_in28[7:0];
        if (byte_sel28[1])
          data[15:8] <= #Tp28 p_in28[15:8];
        if (byte_sel28[2])
          data[`SPI_MAX_CHAR28-1:16] <= #Tp28 p_in28[`SPI_MAX_CHAR28-1:16];
      `endif
      `ifdef SPI_MAX_CHAR_3228
        if (byte_sel28[0])
          data[7:0] <= #Tp28 p_in28[7:0];
        if (byte_sel28[1])
          data[15:8] <= #Tp28 p_in28[15:8];
        if (byte_sel28[2])
          data[23:16] <= #Tp28 p_in28[23:16];
        if (byte_sel28[3])
          data[`SPI_MAX_CHAR28-1:24] <= #Tp28 p_in28[`SPI_MAX_CHAR28-1:24];
      `endif
      end
`endif
`endif
    else
      data[rx_bit_pos28[`SPI_CHAR_LEN_BITS28-1:0]] <= #Tp28 rx_clk28 ? s_in28 : data[rx_bit_pos28[`SPI_CHAR_LEN_BITS28-1:0]];
  end
  
endmodule

