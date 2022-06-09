//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_shift17.v                                                 ////
////                                                              ////
////  This17 file is part of the SPI17 IP17 core17 project17                ////
////  http17://www17.opencores17.org17/projects17/spi17/                      ////
////                                                              ////
////  Author17(s):                                                  ////
////      - Simon17 Srot17 (simons17@opencores17.org17)                     ////
////                                                              ////
////  All additional17 information is avaliable17 in the Readme17.txt17   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright17 (C) 2002 Authors17                                   ////
////                                                              ////
//// This17 source17 file may be used and distributed17 without         ////
//// restriction17 provided that this copyright17 statement17 is not    ////
//// removed from the file and that any derivative17 work17 contains17  ////
//// the original copyright17 notice17 and the associated disclaimer17. ////
////                                                              ////
//// This17 source17 file is free software17; you can redistribute17 it   ////
//// and/or modify it under the terms17 of the GNU17 Lesser17 General17   ////
//// Public17 License17 as published17 by the Free17 Software17 Foundation17; ////
//// either17 version17 2.1 of the License17, or (at your17 option) any   ////
//// later17 version17.                                               ////
////                                                              ////
//// This17 source17 is distributed17 in the hope17 that it will be       ////
//// useful17, but WITHOUT17 ANY17 WARRANTY17; without even17 the implied17   ////
//// warranty17 of MERCHANTABILITY17 or FITNESS17 FOR17 A PARTICULAR17      ////
//// PURPOSE17.  See the GNU17 Lesser17 General17 Public17 License17 for more ////
//// details17.                                                     ////
////                                                              ////
//// You should have received17 a copy of the GNU17 Lesser17 General17    ////
//// Public17 License17 along17 with this source17; if not, download17 it   ////
//// from http17://www17.opencores17.org17/lgpl17.shtml17                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines17.v"
`include "timescale.v"

module spi_shift17 (clk17, rst17, latch17, byte_sel17, len, lsb, go17,
                  pos_edge17, neg_edge17, rx_negedge17, tx_negedge17,
                  tip17, last, 
                  p_in17, p_out17, s_clk17, s_in17, s_out17);

  parameter Tp17 = 1;
  
  input                          clk17;          // system clock17
  input                          rst17;          // reset
  input                    [3:0] latch17;        // latch17 signal17 for storing17 the data in shift17 register
  input                    [3:0] byte_sel17;     // byte select17 signals17 for storing17 the data in shift17 register
  input [`SPI_CHAR_LEN_BITS17-1:0] len;          // data len in bits (minus17 one)
  input                          lsb;          // lbs17 first on the line
  input                          go17;           // start stansfer17
  input                          pos_edge17;     // recognize17 posedge of sclk17
  input                          neg_edge17;     // recognize17 negedge of sclk17
  input                          rx_negedge17;   // s_in17 is sampled17 on negative edge 
  input                          tx_negedge17;   // s_out17 is driven17 on negative edge
  output                         tip17;          // transfer17 in progress17
  output                         last;         // last bit
  input                   [31:0] p_in17;         // parallel17 in
  output     [`SPI_MAX_CHAR17-1:0] p_out17;        // parallel17 out
  input                          s_clk17;        // serial17 clock17
  input                          s_in17;         // serial17 in
  output                         s_out17;        // serial17 out
                                               
  reg                            s_out17;        
  reg                            tip17;
                              
  reg     [`SPI_CHAR_LEN_BITS17:0] cnt;          // data bit count
  reg        [`SPI_MAX_CHAR17-1:0] data;         // shift17 register
  wire    [`SPI_CHAR_LEN_BITS17:0] tx_bit_pos17;   // next bit position17
  wire    [`SPI_CHAR_LEN_BITS17:0] rx_bit_pos17;   // next bit position17
  wire                           rx_clk17;       // rx17 clock17 enable
  wire                           tx_clk17;       // tx17 clock17 enable
  
  assign p_out17 = data;
  
  assign tx_bit_pos17 = lsb ? {!(|len), len} - cnt : cnt - {{`SPI_CHAR_LEN_BITS17{1'b0}},1'b1};
  assign rx_bit_pos17 = lsb ? {!(|len), len} - (rx_negedge17 ? cnt + {{`SPI_CHAR_LEN_BITS17{1'b0}},1'b1} : cnt) : 
                            (rx_negedge17 ? cnt : cnt - {{`SPI_CHAR_LEN_BITS17{1'b0}},1'b1});
  
  assign last = !(|cnt);
  
  assign rx_clk17 = (rx_negedge17 ? neg_edge17 : pos_edge17) && (!last || s_clk17);
  assign tx_clk17 = (tx_negedge17 ? neg_edge17 : pos_edge17) && !last;
  
  // Character17 bit counter
  always @(posedge clk17 or posedge rst17)
  begin
    if(rst17)
      cnt <= #Tp17 {`SPI_CHAR_LEN_BITS17+1{1'b0}};
    else
      begin
        if(tip17)
          cnt <= #Tp17 pos_edge17 ? (cnt - {{`SPI_CHAR_LEN_BITS17{1'b0}}, 1'b1}) : cnt;
        else
          cnt <= #Tp17 !(|len) ? {1'b1, {`SPI_CHAR_LEN_BITS17{1'b0}}} : {1'b0, len};
      end
  end
  
  // Transfer17 in progress17
  always @(posedge clk17 or posedge rst17)
  begin
    if(rst17)
      tip17 <= #Tp17 1'b0;
  else if(go17 && ~tip17)
    tip17 <= #Tp17 1'b1;
  else if(tip17 && last && pos_edge17)
    tip17 <= #Tp17 1'b0;
  end
  
  // Sending17 bits to the line
  always @(posedge clk17 or posedge rst17)
  begin
    if (rst17)
      s_out17   <= #Tp17 1'b0;
    else
      s_out17 <= #Tp17 (tx_clk17 || !tip17) ? data[tx_bit_pos17[`SPI_CHAR_LEN_BITS17-1:0]] : s_out17;
  end
  
  // Receiving17 bits from the line
  always @(posedge clk17 or posedge rst17)
  begin
    if (rst17)
      data   <= #Tp17 {`SPI_MAX_CHAR17{1'b0}};
`ifdef SPI_MAX_CHAR_12817
    else if (latch17[0] && !tip17)
      begin
        if (byte_sel17[3])
          data[31:24] <= #Tp17 p_in17[31:24];
        if (byte_sel17[2])
          data[23:16] <= #Tp17 p_in17[23:16];
        if (byte_sel17[1])
          data[15:8] <= #Tp17 p_in17[15:8];
        if (byte_sel17[0])
          data[7:0] <= #Tp17 p_in17[7:0];
      end
    else if (latch17[1] && !tip17)
      begin
        if (byte_sel17[3])
          data[63:56] <= #Tp17 p_in17[31:24];
        if (byte_sel17[2])
          data[55:48] <= #Tp17 p_in17[23:16];
        if (byte_sel17[1])
          data[47:40] <= #Tp17 p_in17[15:8];
        if (byte_sel17[0])
          data[39:32] <= #Tp17 p_in17[7:0];
      end
    else if (latch17[2] && !tip17)
      begin
        if (byte_sel17[3])
          data[95:88] <= #Tp17 p_in17[31:24];
        if (byte_sel17[2])
          data[87:80] <= #Tp17 p_in17[23:16];
        if (byte_sel17[1])
          data[79:72] <= #Tp17 p_in17[15:8];
        if (byte_sel17[0])
          data[71:64] <= #Tp17 p_in17[7:0];
      end
    else if (latch17[3] && !tip17)
      begin
        if (byte_sel17[3])
          data[127:120] <= #Tp17 p_in17[31:24];
        if (byte_sel17[2])
          data[119:112] <= #Tp17 p_in17[23:16];
        if (byte_sel17[1])
          data[111:104] <= #Tp17 p_in17[15:8];
        if (byte_sel17[0])
          data[103:96] <= #Tp17 p_in17[7:0];
      end
`else
`ifdef SPI_MAX_CHAR_6417
    else if (latch17[0] && !tip17)
      begin
        if (byte_sel17[3])
          data[31:24] <= #Tp17 p_in17[31:24];
        if (byte_sel17[2])
          data[23:16] <= #Tp17 p_in17[23:16];
        if (byte_sel17[1])
          data[15:8] <= #Tp17 p_in17[15:8];
        if (byte_sel17[0])
          data[7:0] <= #Tp17 p_in17[7:0];
      end
    else if (latch17[1] && !tip17)
      begin
        if (byte_sel17[3])
          data[63:56] <= #Tp17 p_in17[31:24];
        if (byte_sel17[2])
          data[55:48] <= #Tp17 p_in17[23:16];
        if (byte_sel17[1])
          data[47:40] <= #Tp17 p_in17[15:8];
        if (byte_sel17[0])
          data[39:32] <= #Tp17 p_in17[7:0];
      end
`else
    else if (latch17[0] && !tip17)
      begin
      `ifdef SPI_MAX_CHAR_817
        if (byte_sel17[0])
          data[`SPI_MAX_CHAR17-1:0] <= #Tp17 p_in17[`SPI_MAX_CHAR17-1:0];
      `endif
      `ifdef SPI_MAX_CHAR_1617
        if (byte_sel17[0])
          data[7:0] <= #Tp17 p_in17[7:0];
        if (byte_sel17[1])
          data[`SPI_MAX_CHAR17-1:8] <= #Tp17 p_in17[`SPI_MAX_CHAR17-1:8];
      `endif
      `ifdef SPI_MAX_CHAR_2417
        if (byte_sel17[0])
          data[7:0] <= #Tp17 p_in17[7:0];
        if (byte_sel17[1])
          data[15:8] <= #Tp17 p_in17[15:8];
        if (byte_sel17[2])
          data[`SPI_MAX_CHAR17-1:16] <= #Tp17 p_in17[`SPI_MAX_CHAR17-1:16];
      `endif
      `ifdef SPI_MAX_CHAR_3217
        if (byte_sel17[0])
          data[7:0] <= #Tp17 p_in17[7:0];
        if (byte_sel17[1])
          data[15:8] <= #Tp17 p_in17[15:8];
        if (byte_sel17[2])
          data[23:16] <= #Tp17 p_in17[23:16];
        if (byte_sel17[3])
          data[`SPI_MAX_CHAR17-1:24] <= #Tp17 p_in17[`SPI_MAX_CHAR17-1:24];
      `endif
      end
`endif
`endif
    else
      data[rx_bit_pos17[`SPI_CHAR_LEN_BITS17-1:0]] <= #Tp17 rx_clk17 ? s_in17 : data[rx_bit_pos17[`SPI_CHAR_LEN_BITS17-1:0]];
  end
  
endmodule

