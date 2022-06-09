//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_shift15.v                                                 ////
////                                                              ////
////  This15 file is part of the SPI15 IP15 core15 project15                ////
////  http15://www15.opencores15.org15/projects15/spi15/                      ////
////                                                              ////
////  Author15(s):                                                  ////
////      - Simon15 Srot15 (simons15@opencores15.org15)                     ////
////                                                              ////
////  All additional15 information is avaliable15 in the Readme15.txt15   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright15 (C) 2002 Authors15                                   ////
////                                                              ////
//// This15 source15 file may be used and distributed15 without         ////
//// restriction15 provided that this copyright15 statement15 is not    ////
//// removed from the file and that any derivative15 work15 contains15  ////
//// the original copyright15 notice15 and the associated disclaimer15. ////
////                                                              ////
//// This15 source15 file is free software15; you can redistribute15 it   ////
//// and/or modify it under the terms15 of the GNU15 Lesser15 General15   ////
//// Public15 License15 as published15 by the Free15 Software15 Foundation15; ////
//// either15 version15 2.1 of the License15, or (at your15 option) any   ////
//// later15 version15.                                               ////
////                                                              ////
//// This15 source15 is distributed15 in the hope15 that it will be       ////
//// useful15, but WITHOUT15 ANY15 WARRANTY15; without even15 the implied15   ////
//// warranty15 of MERCHANTABILITY15 or FITNESS15 FOR15 A PARTICULAR15      ////
//// PURPOSE15.  See the GNU15 Lesser15 General15 Public15 License15 for more ////
//// details15.                                                     ////
////                                                              ////
//// You should have received15 a copy of the GNU15 Lesser15 General15    ////
//// Public15 License15 along15 with this source15; if not, download15 it   ////
//// from http15://www15.opencores15.org15/lgpl15.shtml15                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines15.v"
`include "timescale.v"

module spi_shift15 (clk15, rst15, latch15, byte_sel15, len, lsb, go15,
                  pos_edge15, neg_edge15, rx_negedge15, tx_negedge15,
                  tip15, last, 
                  p_in15, p_out15, s_clk15, s_in15, s_out15);

  parameter Tp15 = 1;
  
  input                          clk15;          // system clock15
  input                          rst15;          // reset
  input                    [3:0] latch15;        // latch15 signal15 for storing15 the data in shift15 register
  input                    [3:0] byte_sel15;     // byte select15 signals15 for storing15 the data in shift15 register
  input [`SPI_CHAR_LEN_BITS15-1:0] len;          // data len in bits (minus15 one)
  input                          lsb;          // lbs15 first on the line
  input                          go15;           // start stansfer15
  input                          pos_edge15;     // recognize15 posedge of sclk15
  input                          neg_edge15;     // recognize15 negedge of sclk15
  input                          rx_negedge15;   // s_in15 is sampled15 on negative edge 
  input                          tx_negedge15;   // s_out15 is driven15 on negative edge
  output                         tip15;          // transfer15 in progress15
  output                         last;         // last bit
  input                   [31:0] p_in15;         // parallel15 in
  output     [`SPI_MAX_CHAR15-1:0] p_out15;        // parallel15 out
  input                          s_clk15;        // serial15 clock15
  input                          s_in15;         // serial15 in
  output                         s_out15;        // serial15 out
                                               
  reg                            s_out15;        
  reg                            tip15;
                              
  reg     [`SPI_CHAR_LEN_BITS15:0] cnt;          // data bit count
  reg        [`SPI_MAX_CHAR15-1:0] data;         // shift15 register
  wire    [`SPI_CHAR_LEN_BITS15:0] tx_bit_pos15;   // next bit position15
  wire    [`SPI_CHAR_LEN_BITS15:0] rx_bit_pos15;   // next bit position15
  wire                           rx_clk15;       // rx15 clock15 enable
  wire                           tx_clk15;       // tx15 clock15 enable
  
  assign p_out15 = data;
  
  assign tx_bit_pos15 = lsb ? {!(|len), len} - cnt : cnt - {{`SPI_CHAR_LEN_BITS15{1'b0}},1'b1};
  assign rx_bit_pos15 = lsb ? {!(|len), len} - (rx_negedge15 ? cnt + {{`SPI_CHAR_LEN_BITS15{1'b0}},1'b1} : cnt) : 
                            (rx_negedge15 ? cnt : cnt - {{`SPI_CHAR_LEN_BITS15{1'b0}},1'b1});
  
  assign last = !(|cnt);
  
  assign rx_clk15 = (rx_negedge15 ? neg_edge15 : pos_edge15) && (!last || s_clk15);
  assign tx_clk15 = (tx_negedge15 ? neg_edge15 : pos_edge15) && !last;
  
  // Character15 bit counter
  always @(posedge clk15 or posedge rst15)
  begin
    if(rst15)
      cnt <= #Tp15 {`SPI_CHAR_LEN_BITS15+1{1'b0}};
    else
      begin
        if(tip15)
          cnt <= #Tp15 pos_edge15 ? (cnt - {{`SPI_CHAR_LEN_BITS15{1'b0}}, 1'b1}) : cnt;
        else
          cnt <= #Tp15 !(|len) ? {1'b1, {`SPI_CHAR_LEN_BITS15{1'b0}}} : {1'b0, len};
      end
  end
  
  // Transfer15 in progress15
  always @(posedge clk15 or posedge rst15)
  begin
    if(rst15)
      tip15 <= #Tp15 1'b0;
  else if(go15 && ~tip15)
    tip15 <= #Tp15 1'b1;
  else if(tip15 && last && pos_edge15)
    tip15 <= #Tp15 1'b0;
  end
  
  // Sending15 bits to the line
  always @(posedge clk15 or posedge rst15)
  begin
    if (rst15)
      s_out15   <= #Tp15 1'b0;
    else
      s_out15 <= #Tp15 (tx_clk15 || !tip15) ? data[tx_bit_pos15[`SPI_CHAR_LEN_BITS15-1:0]] : s_out15;
  end
  
  // Receiving15 bits from the line
  always @(posedge clk15 or posedge rst15)
  begin
    if (rst15)
      data   <= #Tp15 {`SPI_MAX_CHAR15{1'b0}};
`ifdef SPI_MAX_CHAR_12815
    else if (latch15[0] && !tip15)
      begin
        if (byte_sel15[3])
          data[31:24] <= #Tp15 p_in15[31:24];
        if (byte_sel15[2])
          data[23:16] <= #Tp15 p_in15[23:16];
        if (byte_sel15[1])
          data[15:8] <= #Tp15 p_in15[15:8];
        if (byte_sel15[0])
          data[7:0] <= #Tp15 p_in15[7:0];
      end
    else if (latch15[1] && !tip15)
      begin
        if (byte_sel15[3])
          data[63:56] <= #Tp15 p_in15[31:24];
        if (byte_sel15[2])
          data[55:48] <= #Tp15 p_in15[23:16];
        if (byte_sel15[1])
          data[47:40] <= #Tp15 p_in15[15:8];
        if (byte_sel15[0])
          data[39:32] <= #Tp15 p_in15[7:0];
      end
    else if (latch15[2] && !tip15)
      begin
        if (byte_sel15[3])
          data[95:88] <= #Tp15 p_in15[31:24];
        if (byte_sel15[2])
          data[87:80] <= #Tp15 p_in15[23:16];
        if (byte_sel15[1])
          data[79:72] <= #Tp15 p_in15[15:8];
        if (byte_sel15[0])
          data[71:64] <= #Tp15 p_in15[7:0];
      end
    else if (latch15[3] && !tip15)
      begin
        if (byte_sel15[3])
          data[127:120] <= #Tp15 p_in15[31:24];
        if (byte_sel15[2])
          data[119:112] <= #Tp15 p_in15[23:16];
        if (byte_sel15[1])
          data[111:104] <= #Tp15 p_in15[15:8];
        if (byte_sel15[0])
          data[103:96] <= #Tp15 p_in15[7:0];
      end
`else
`ifdef SPI_MAX_CHAR_6415
    else if (latch15[0] && !tip15)
      begin
        if (byte_sel15[3])
          data[31:24] <= #Tp15 p_in15[31:24];
        if (byte_sel15[2])
          data[23:16] <= #Tp15 p_in15[23:16];
        if (byte_sel15[1])
          data[15:8] <= #Tp15 p_in15[15:8];
        if (byte_sel15[0])
          data[7:0] <= #Tp15 p_in15[7:0];
      end
    else if (latch15[1] && !tip15)
      begin
        if (byte_sel15[3])
          data[63:56] <= #Tp15 p_in15[31:24];
        if (byte_sel15[2])
          data[55:48] <= #Tp15 p_in15[23:16];
        if (byte_sel15[1])
          data[47:40] <= #Tp15 p_in15[15:8];
        if (byte_sel15[0])
          data[39:32] <= #Tp15 p_in15[7:0];
      end
`else
    else if (latch15[0] && !tip15)
      begin
      `ifdef SPI_MAX_CHAR_815
        if (byte_sel15[0])
          data[`SPI_MAX_CHAR15-1:0] <= #Tp15 p_in15[`SPI_MAX_CHAR15-1:0];
      `endif
      `ifdef SPI_MAX_CHAR_1615
        if (byte_sel15[0])
          data[7:0] <= #Tp15 p_in15[7:0];
        if (byte_sel15[1])
          data[`SPI_MAX_CHAR15-1:8] <= #Tp15 p_in15[`SPI_MAX_CHAR15-1:8];
      `endif
      `ifdef SPI_MAX_CHAR_2415
        if (byte_sel15[0])
          data[7:0] <= #Tp15 p_in15[7:0];
        if (byte_sel15[1])
          data[15:8] <= #Tp15 p_in15[15:8];
        if (byte_sel15[2])
          data[`SPI_MAX_CHAR15-1:16] <= #Tp15 p_in15[`SPI_MAX_CHAR15-1:16];
      `endif
      `ifdef SPI_MAX_CHAR_3215
        if (byte_sel15[0])
          data[7:0] <= #Tp15 p_in15[7:0];
        if (byte_sel15[1])
          data[15:8] <= #Tp15 p_in15[15:8];
        if (byte_sel15[2])
          data[23:16] <= #Tp15 p_in15[23:16];
        if (byte_sel15[3])
          data[`SPI_MAX_CHAR15-1:24] <= #Tp15 p_in15[`SPI_MAX_CHAR15-1:24];
      `endif
      end
`endif
`endif
    else
      data[rx_bit_pos15[`SPI_CHAR_LEN_BITS15-1:0]] <= #Tp15 rx_clk15 ? s_in15 : data[rx_bit_pos15[`SPI_CHAR_LEN_BITS15-1:0]];
  end
  
endmodule

