//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_shift12.v                                                 ////
////                                                              ////
////  This12 file is part of the SPI12 IP12 core12 project12                ////
////  http12://www12.opencores12.org12/projects12/spi12/                      ////
////                                                              ////
////  Author12(s):                                                  ////
////      - Simon12 Srot12 (simons12@opencores12.org12)                     ////
////                                                              ////
////  All additional12 information is avaliable12 in the Readme12.txt12   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright12 (C) 2002 Authors12                                   ////
////                                                              ////
//// This12 source12 file may be used and distributed12 without         ////
//// restriction12 provided that this copyright12 statement12 is not    ////
//// removed from the file and that any derivative12 work12 contains12  ////
//// the original copyright12 notice12 and the associated disclaimer12. ////
////                                                              ////
//// This12 source12 file is free software12; you can redistribute12 it   ////
//// and/or modify it under the terms12 of the GNU12 Lesser12 General12   ////
//// Public12 License12 as published12 by the Free12 Software12 Foundation12; ////
//// either12 version12 2.1 of the License12, or (at your12 option) any   ////
//// later12 version12.                                               ////
////                                                              ////
//// This12 source12 is distributed12 in the hope12 that it will be       ////
//// useful12, but WITHOUT12 ANY12 WARRANTY12; without even12 the implied12   ////
//// warranty12 of MERCHANTABILITY12 or FITNESS12 FOR12 A PARTICULAR12      ////
//// PURPOSE12.  See the GNU12 Lesser12 General12 Public12 License12 for more ////
//// details12.                                                     ////
////                                                              ////
//// You should have received12 a copy of the GNU12 Lesser12 General12    ////
//// Public12 License12 along12 with this source12; if not, download12 it   ////
//// from http12://www12.opencores12.org12/lgpl12.shtml12                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines12.v"
`include "timescale.v"

module spi_shift12 (clk12, rst12, latch12, byte_sel12, len, lsb, go12,
                  pos_edge12, neg_edge12, rx_negedge12, tx_negedge12,
                  tip12, last, 
                  p_in12, p_out12, s_clk12, s_in12, s_out12);

  parameter Tp12 = 1;
  
  input                          clk12;          // system clock12
  input                          rst12;          // reset
  input                    [3:0] latch12;        // latch12 signal12 for storing12 the data in shift12 register
  input                    [3:0] byte_sel12;     // byte select12 signals12 for storing12 the data in shift12 register
  input [`SPI_CHAR_LEN_BITS12-1:0] len;          // data len in bits (minus12 one)
  input                          lsb;          // lbs12 first on the line
  input                          go12;           // start stansfer12
  input                          pos_edge12;     // recognize12 posedge of sclk12
  input                          neg_edge12;     // recognize12 negedge of sclk12
  input                          rx_negedge12;   // s_in12 is sampled12 on negative edge 
  input                          tx_negedge12;   // s_out12 is driven12 on negative edge
  output                         tip12;          // transfer12 in progress12
  output                         last;         // last bit
  input                   [31:0] p_in12;         // parallel12 in
  output     [`SPI_MAX_CHAR12-1:0] p_out12;        // parallel12 out
  input                          s_clk12;        // serial12 clock12
  input                          s_in12;         // serial12 in
  output                         s_out12;        // serial12 out
                                               
  reg                            s_out12;        
  reg                            tip12;
                              
  reg     [`SPI_CHAR_LEN_BITS12:0] cnt;          // data bit count
  reg        [`SPI_MAX_CHAR12-1:0] data;         // shift12 register
  wire    [`SPI_CHAR_LEN_BITS12:0] tx_bit_pos12;   // next bit position12
  wire    [`SPI_CHAR_LEN_BITS12:0] rx_bit_pos12;   // next bit position12
  wire                           rx_clk12;       // rx12 clock12 enable
  wire                           tx_clk12;       // tx12 clock12 enable
  
  assign p_out12 = data;
  
  assign tx_bit_pos12 = lsb ? {!(|len), len} - cnt : cnt - {{`SPI_CHAR_LEN_BITS12{1'b0}},1'b1};
  assign rx_bit_pos12 = lsb ? {!(|len), len} - (rx_negedge12 ? cnt + {{`SPI_CHAR_LEN_BITS12{1'b0}},1'b1} : cnt) : 
                            (rx_negedge12 ? cnt : cnt - {{`SPI_CHAR_LEN_BITS12{1'b0}},1'b1});
  
  assign last = !(|cnt);
  
  assign rx_clk12 = (rx_negedge12 ? neg_edge12 : pos_edge12) && (!last || s_clk12);
  assign tx_clk12 = (tx_negedge12 ? neg_edge12 : pos_edge12) && !last;
  
  // Character12 bit counter
  always @(posedge clk12 or posedge rst12)
  begin
    if(rst12)
      cnt <= #Tp12 {`SPI_CHAR_LEN_BITS12+1{1'b0}};
    else
      begin
        if(tip12)
          cnt <= #Tp12 pos_edge12 ? (cnt - {{`SPI_CHAR_LEN_BITS12{1'b0}}, 1'b1}) : cnt;
        else
          cnt <= #Tp12 !(|len) ? {1'b1, {`SPI_CHAR_LEN_BITS12{1'b0}}} : {1'b0, len};
      end
  end
  
  // Transfer12 in progress12
  always @(posedge clk12 or posedge rst12)
  begin
    if(rst12)
      tip12 <= #Tp12 1'b0;
  else if(go12 && ~tip12)
    tip12 <= #Tp12 1'b1;
  else if(tip12 && last && pos_edge12)
    tip12 <= #Tp12 1'b0;
  end
  
  // Sending12 bits to the line
  always @(posedge clk12 or posedge rst12)
  begin
    if (rst12)
      s_out12   <= #Tp12 1'b0;
    else
      s_out12 <= #Tp12 (tx_clk12 || !tip12) ? data[tx_bit_pos12[`SPI_CHAR_LEN_BITS12-1:0]] : s_out12;
  end
  
  // Receiving12 bits from the line
  always @(posedge clk12 or posedge rst12)
  begin
    if (rst12)
      data   <= #Tp12 {`SPI_MAX_CHAR12{1'b0}};
`ifdef SPI_MAX_CHAR_12812
    else if (latch12[0] && !tip12)
      begin
        if (byte_sel12[3])
          data[31:24] <= #Tp12 p_in12[31:24];
        if (byte_sel12[2])
          data[23:16] <= #Tp12 p_in12[23:16];
        if (byte_sel12[1])
          data[15:8] <= #Tp12 p_in12[15:8];
        if (byte_sel12[0])
          data[7:0] <= #Tp12 p_in12[7:0];
      end
    else if (latch12[1] && !tip12)
      begin
        if (byte_sel12[3])
          data[63:56] <= #Tp12 p_in12[31:24];
        if (byte_sel12[2])
          data[55:48] <= #Tp12 p_in12[23:16];
        if (byte_sel12[1])
          data[47:40] <= #Tp12 p_in12[15:8];
        if (byte_sel12[0])
          data[39:32] <= #Tp12 p_in12[7:0];
      end
    else if (latch12[2] && !tip12)
      begin
        if (byte_sel12[3])
          data[95:88] <= #Tp12 p_in12[31:24];
        if (byte_sel12[2])
          data[87:80] <= #Tp12 p_in12[23:16];
        if (byte_sel12[1])
          data[79:72] <= #Tp12 p_in12[15:8];
        if (byte_sel12[0])
          data[71:64] <= #Tp12 p_in12[7:0];
      end
    else if (latch12[3] && !tip12)
      begin
        if (byte_sel12[3])
          data[127:120] <= #Tp12 p_in12[31:24];
        if (byte_sel12[2])
          data[119:112] <= #Tp12 p_in12[23:16];
        if (byte_sel12[1])
          data[111:104] <= #Tp12 p_in12[15:8];
        if (byte_sel12[0])
          data[103:96] <= #Tp12 p_in12[7:0];
      end
`else
`ifdef SPI_MAX_CHAR_6412
    else if (latch12[0] && !tip12)
      begin
        if (byte_sel12[3])
          data[31:24] <= #Tp12 p_in12[31:24];
        if (byte_sel12[2])
          data[23:16] <= #Tp12 p_in12[23:16];
        if (byte_sel12[1])
          data[15:8] <= #Tp12 p_in12[15:8];
        if (byte_sel12[0])
          data[7:0] <= #Tp12 p_in12[7:0];
      end
    else if (latch12[1] && !tip12)
      begin
        if (byte_sel12[3])
          data[63:56] <= #Tp12 p_in12[31:24];
        if (byte_sel12[2])
          data[55:48] <= #Tp12 p_in12[23:16];
        if (byte_sel12[1])
          data[47:40] <= #Tp12 p_in12[15:8];
        if (byte_sel12[0])
          data[39:32] <= #Tp12 p_in12[7:0];
      end
`else
    else if (latch12[0] && !tip12)
      begin
      `ifdef SPI_MAX_CHAR_812
        if (byte_sel12[0])
          data[`SPI_MAX_CHAR12-1:0] <= #Tp12 p_in12[`SPI_MAX_CHAR12-1:0];
      `endif
      `ifdef SPI_MAX_CHAR_1612
        if (byte_sel12[0])
          data[7:0] <= #Tp12 p_in12[7:0];
        if (byte_sel12[1])
          data[`SPI_MAX_CHAR12-1:8] <= #Tp12 p_in12[`SPI_MAX_CHAR12-1:8];
      `endif
      `ifdef SPI_MAX_CHAR_2412
        if (byte_sel12[0])
          data[7:0] <= #Tp12 p_in12[7:0];
        if (byte_sel12[1])
          data[15:8] <= #Tp12 p_in12[15:8];
        if (byte_sel12[2])
          data[`SPI_MAX_CHAR12-1:16] <= #Tp12 p_in12[`SPI_MAX_CHAR12-1:16];
      `endif
      `ifdef SPI_MAX_CHAR_3212
        if (byte_sel12[0])
          data[7:0] <= #Tp12 p_in12[7:0];
        if (byte_sel12[1])
          data[15:8] <= #Tp12 p_in12[15:8];
        if (byte_sel12[2])
          data[23:16] <= #Tp12 p_in12[23:16];
        if (byte_sel12[3])
          data[`SPI_MAX_CHAR12-1:24] <= #Tp12 p_in12[`SPI_MAX_CHAR12-1:24];
      `endif
      end
`endif
`endif
    else
      data[rx_bit_pos12[`SPI_CHAR_LEN_BITS12-1:0]] <= #Tp12 rx_clk12 ? s_in12 : data[rx_bit_pos12[`SPI_CHAR_LEN_BITS12-1:0]];
  end
  
endmodule

