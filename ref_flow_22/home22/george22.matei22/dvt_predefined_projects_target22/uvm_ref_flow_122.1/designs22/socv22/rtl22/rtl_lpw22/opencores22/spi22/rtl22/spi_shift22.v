//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_shift22.v                                                 ////
////                                                              ////
////  This22 file is part of the SPI22 IP22 core22 project22                ////
////  http22://www22.opencores22.org22/projects22/spi22/                      ////
////                                                              ////
////  Author22(s):                                                  ////
////      - Simon22 Srot22 (simons22@opencores22.org22)                     ////
////                                                              ////
////  All additional22 information is avaliable22 in the Readme22.txt22   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright22 (C) 2002 Authors22                                   ////
////                                                              ////
//// This22 source22 file may be used and distributed22 without         ////
//// restriction22 provided that this copyright22 statement22 is not    ////
//// removed from the file and that any derivative22 work22 contains22  ////
//// the original copyright22 notice22 and the associated disclaimer22. ////
////                                                              ////
//// This22 source22 file is free software22; you can redistribute22 it   ////
//// and/or modify it under the terms22 of the GNU22 Lesser22 General22   ////
//// Public22 License22 as published22 by the Free22 Software22 Foundation22; ////
//// either22 version22 2.1 of the License22, or (at your22 option) any   ////
//// later22 version22.                                               ////
////                                                              ////
//// This22 source22 is distributed22 in the hope22 that it will be       ////
//// useful22, but WITHOUT22 ANY22 WARRANTY22; without even22 the implied22   ////
//// warranty22 of MERCHANTABILITY22 or FITNESS22 FOR22 A PARTICULAR22      ////
//// PURPOSE22.  See the GNU22 Lesser22 General22 Public22 License22 for more ////
//// details22.                                                     ////
////                                                              ////
//// You should have received22 a copy of the GNU22 Lesser22 General22    ////
//// Public22 License22 along22 with this source22; if not, download22 it   ////
//// from http22://www22.opencores22.org22/lgpl22.shtml22                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines22.v"
`include "timescale.v"

module spi_shift22 (clk22, rst22, latch22, byte_sel22, len, lsb, go22,
                  pos_edge22, neg_edge22, rx_negedge22, tx_negedge22,
                  tip22, last, 
                  p_in22, p_out22, s_clk22, s_in22, s_out22);

  parameter Tp22 = 1;
  
  input                          clk22;          // system clock22
  input                          rst22;          // reset
  input                    [3:0] latch22;        // latch22 signal22 for storing22 the data in shift22 register
  input                    [3:0] byte_sel22;     // byte select22 signals22 for storing22 the data in shift22 register
  input [`SPI_CHAR_LEN_BITS22-1:0] len;          // data len in bits (minus22 one)
  input                          lsb;          // lbs22 first on the line
  input                          go22;           // start stansfer22
  input                          pos_edge22;     // recognize22 posedge of sclk22
  input                          neg_edge22;     // recognize22 negedge of sclk22
  input                          rx_negedge22;   // s_in22 is sampled22 on negative edge 
  input                          tx_negedge22;   // s_out22 is driven22 on negative edge
  output                         tip22;          // transfer22 in progress22
  output                         last;         // last bit
  input                   [31:0] p_in22;         // parallel22 in
  output     [`SPI_MAX_CHAR22-1:0] p_out22;        // parallel22 out
  input                          s_clk22;        // serial22 clock22
  input                          s_in22;         // serial22 in
  output                         s_out22;        // serial22 out
                                               
  reg                            s_out22;        
  reg                            tip22;
                              
  reg     [`SPI_CHAR_LEN_BITS22:0] cnt;          // data bit count
  reg        [`SPI_MAX_CHAR22-1:0] data;         // shift22 register
  wire    [`SPI_CHAR_LEN_BITS22:0] tx_bit_pos22;   // next bit position22
  wire    [`SPI_CHAR_LEN_BITS22:0] rx_bit_pos22;   // next bit position22
  wire                           rx_clk22;       // rx22 clock22 enable
  wire                           tx_clk22;       // tx22 clock22 enable
  
  assign p_out22 = data;
  
  assign tx_bit_pos22 = lsb ? {!(|len), len} - cnt : cnt - {{`SPI_CHAR_LEN_BITS22{1'b0}},1'b1};
  assign rx_bit_pos22 = lsb ? {!(|len), len} - (rx_negedge22 ? cnt + {{`SPI_CHAR_LEN_BITS22{1'b0}},1'b1} : cnt) : 
                            (rx_negedge22 ? cnt : cnt - {{`SPI_CHAR_LEN_BITS22{1'b0}},1'b1});
  
  assign last = !(|cnt);
  
  assign rx_clk22 = (rx_negedge22 ? neg_edge22 : pos_edge22) && (!last || s_clk22);
  assign tx_clk22 = (tx_negedge22 ? neg_edge22 : pos_edge22) && !last;
  
  // Character22 bit counter
  always @(posedge clk22 or posedge rst22)
  begin
    if(rst22)
      cnt <= #Tp22 {`SPI_CHAR_LEN_BITS22+1{1'b0}};
    else
      begin
        if(tip22)
          cnt <= #Tp22 pos_edge22 ? (cnt - {{`SPI_CHAR_LEN_BITS22{1'b0}}, 1'b1}) : cnt;
        else
          cnt <= #Tp22 !(|len) ? {1'b1, {`SPI_CHAR_LEN_BITS22{1'b0}}} : {1'b0, len};
      end
  end
  
  // Transfer22 in progress22
  always @(posedge clk22 or posedge rst22)
  begin
    if(rst22)
      tip22 <= #Tp22 1'b0;
  else if(go22 && ~tip22)
    tip22 <= #Tp22 1'b1;
  else if(tip22 && last && pos_edge22)
    tip22 <= #Tp22 1'b0;
  end
  
  // Sending22 bits to the line
  always @(posedge clk22 or posedge rst22)
  begin
    if (rst22)
      s_out22   <= #Tp22 1'b0;
    else
      s_out22 <= #Tp22 (tx_clk22 || !tip22) ? data[tx_bit_pos22[`SPI_CHAR_LEN_BITS22-1:0]] : s_out22;
  end
  
  // Receiving22 bits from the line
  always @(posedge clk22 or posedge rst22)
  begin
    if (rst22)
      data   <= #Tp22 {`SPI_MAX_CHAR22{1'b0}};
`ifdef SPI_MAX_CHAR_12822
    else if (latch22[0] && !tip22)
      begin
        if (byte_sel22[3])
          data[31:24] <= #Tp22 p_in22[31:24];
        if (byte_sel22[2])
          data[23:16] <= #Tp22 p_in22[23:16];
        if (byte_sel22[1])
          data[15:8] <= #Tp22 p_in22[15:8];
        if (byte_sel22[0])
          data[7:0] <= #Tp22 p_in22[7:0];
      end
    else if (latch22[1] && !tip22)
      begin
        if (byte_sel22[3])
          data[63:56] <= #Tp22 p_in22[31:24];
        if (byte_sel22[2])
          data[55:48] <= #Tp22 p_in22[23:16];
        if (byte_sel22[1])
          data[47:40] <= #Tp22 p_in22[15:8];
        if (byte_sel22[0])
          data[39:32] <= #Tp22 p_in22[7:0];
      end
    else if (latch22[2] && !tip22)
      begin
        if (byte_sel22[3])
          data[95:88] <= #Tp22 p_in22[31:24];
        if (byte_sel22[2])
          data[87:80] <= #Tp22 p_in22[23:16];
        if (byte_sel22[1])
          data[79:72] <= #Tp22 p_in22[15:8];
        if (byte_sel22[0])
          data[71:64] <= #Tp22 p_in22[7:0];
      end
    else if (latch22[3] && !tip22)
      begin
        if (byte_sel22[3])
          data[127:120] <= #Tp22 p_in22[31:24];
        if (byte_sel22[2])
          data[119:112] <= #Tp22 p_in22[23:16];
        if (byte_sel22[1])
          data[111:104] <= #Tp22 p_in22[15:8];
        if (byte_sel22[0])
          data[103:96] <= #Tp22 p_in22[7:0];
      end
`else
`ifdef SPI_MAX_CHAR_6422
    else if (latch22[0] && !tip22)
      begin
        if (byte_sel22[3])
          data[31:24] <= #Tp22 p_in22[31:24];
        if (byte_sel22[2])
          data[23:16] <= #Tp22 p_in22[23:16];
        if (byte_sel22[1])
          data[15:8] <= #Tp22 p_in22[15:8];
        if (byte_sel22[0])
          data[7:0] <= #Tp22 p_in22[7:0];
      end
    else if (latch22[1] && !tip22)
      begin
        if (byte_sel22[3])
          data[63:56] <= #Tp22 p_in22[31:24];
        if (byte_sel22[2])
          data[55:48] <= #Tp22 p_in22[23:16];
        if (byte_sel22[1])
          data[47:40] <= #Tp22 p_in22[15:8];
        if (byte_sel22[0])
          data[39:32] <= #Tp22 p_in22[7:0];
      end
`else
    else if (latch22[0] && !tip22)
      begin
      `ifdef SPI_MAX_CHAR_822
        if (byte_sel22[0])
          data[`SPI_MAX_CHAR22-1:0] <= #Tp22 p_in22[`SPI_MAX_CHAR22-1:0];
      `endif
      `ifdef SPI_MAX_CHAR_1622
        if (byte_sel22[0])
          data[7:0] <= #Tp22 p_in22[7:0];
        if (byte_sel22[1])
          data[`SPI_MAX_CHAR22-1:8] <= #Tp22 p_in22[`SPI_MAX_CHAR22-1:8];
      `endif
      `ifdef SPI_MAX_CHAR_2422
        if (byte_sel22[0])
          data[7:0] <= #Tp22 p_in22[7:0];
        if (byte_sel22[1])
          data[15:8] <= #Tp22 p_in22[15:8];
        if (byte_sel22[2])
          data[`SPI_MAX_CHAR22-1:16] <= #Tp22 p_in22[`SPI_MAX_CHAR22-1:16];
      `endif
      `ifdef SPI_MAX_CHAR_3222
        if (byte_sel22[0])
          data[7:0] <= #Tp22 p_in22[7:0];
        if (byte_sel22[1])
          data[15:8] <= #Tp22 p_in22[15:8];
        if (byte_sel22[2])
          data[23:16] <= #Tp22 p_in22[23:16];
        if (byte_sel22[3])
          data[`SPI_MAX_CHAR22-1:24] <= #Tp22 p_in22[`SPI_MAX_CHAR22-1:24];
      `endif
      end
`endif
`endif
    else
      data[rx_bit_pos22[`SPI_CHAR_LEN_BITS22-1:0]] <= #Tp22 rx_clk22 ? s_in22 : data[rx_bit_pos22[`SPI_CHAR_LEN_BITS22-1:0]];
  end
  
endmodule

