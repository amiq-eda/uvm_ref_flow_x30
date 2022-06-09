//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_shift13.v                                                 ////
////                                                              ////
////  This13 file is part of the SPI13 IP13 core13 project13                ////
////  http13://www13.opencores13.org13/projects13/spi13/                      ////
////                                                              ////
////  Author13(s):                                                  ////
////      - Simon13 Srot13 (simons13@opencores13.org13)                     ////
////                                                              ////
////  All additional13 information is avaliable13 in the Readme13.txt13   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright13 (C) 2002 Authors13                                   ////
////                                                              ////
//// This13 source13 file may be used and distributed13 without         ////
//// restriction13 provided that this copyright13 statement13 is not    ////
//// removed from the file and that any derivative13 work13 contains13  ////
//// the original copyright13 notice13 and the associated disclaimer13. ////
////                                                              ////
//// This13 source13 file is free software13; you can redistribute13 it   ////
//// and/or modify it under the terms13 of the GNU13 Lesser13 General13   ////
//// Public13 License13 as published13 by the Free13 Software13 Foundation13; ////
//// either13 version13 2.1 of the License13, or (at your13 option) any   ////
//// later13 version13.                                               ////
////                                                              ////
//// This13 source13 is distributed13 in the hope13 that it will be       ////
//// useful13, but WITHOUT13 ANY13 WARRANTY13; without even13 the implied13   ////
//// warranty13 of MERCHANTABILITY13 or FITNESS13 FOR13 A PARTICULAR13      ////
//// PURPOSE13.  See the GNU13 Lesser13 General13 Public13 License13 for more ////
//// details13.                                                     ////
////                                                              ////
//// You should have received13 a copy of the GNU13 Lesser13 General13    ////
//// Public13 License13 along13 with this source13; if not, download13 it   ////
//// from http13://www13.opencores13.org13/lgpl13.shtml13                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines13.v"
`include "timescale.v"

module spi_shift13 (clk13, rst13, latch13, byte_sel13, len, lsb, go13,
                  pos_edge13, neg_edge13, rx_negedge13, tx_negedge13,
                  tip13, last, 
                  p_in13, p_out13, s_clk13, s_in13, s_out13);

  parameter Tp13 = 1;
  
  input                          clk13;          // system clock13
  input                          rst13;          // reset
  input                    [3:0] latch13;        // latch13 signal13 for storing13 the data in shift13 register
  input                    [3:0] byte_sel13;     // byte select13 signals13 for storing13 the data in shift13 register
  input [`SPI_CHAR_LEN_BITS13-1:0] len;          // data len in bits (minus13 one)
  input                          lsb;          // lbs13 first on the line
  input                          go13;           // start stansfer13
  input                          pos_edge13;     // recognize13 posedge of sclk13
  input                          neg_edge13;     // recognize13 negedge of sclk13
  input                          rx_negedge13;   // s_in13 is sampled13 on negative edge 
  input                          tx_negedge13;   // s_out13 is driven13 on negative edge
  output                         tip13;          // transfer13 in progress13
  output                         last;         // last bit
  input                   [31:0] p_in13;         // parallel13 in
  output     [`SPI_MAX_CHAR13-1:0] p_out13;        // parallel13 out
  input                          s_clk13;        // serial13 clock13
  input                          s_in13;         // serial13 in
  output                         s_out13;        // serial13 out
                                               
  reg                            s_out13;        
  reg                            tip13;
                              
  reg     [`SPI_CHAR_LEN_BITS13:0] cnt;          // data bit count
  reg        [`SPI_MAX_CHAR13-1:0] data;         // shift13 register
  wire    [`SPI_CHAR_LEN_BITS13:0] tx_bit_pos13;   // next bit position13
  wire    [`SPI_CHAR_LEN_BITS13:0] rx_bit_pos13;   // next bit position13
  wire                           rx_clk13;       // rx13 clock13 enable
  wire                           tx_clk13;       // tx13 clock13 enable
  
  assign p_out13 = data;
  
  assign tx_bit_pos13 = lsb ? {!(|len), len} - cnt : cnt - {{`SPI_CHAR_LEN_BITS13{1'b0}},1'b1};
  assign rx_bit_pos13 = lsb ? {!(|len), len} - (rx_negedge13 ? cnt + {{`SPI_CHAR_LEN_BITS13{1'b0}},1'b1} : cnt) : 
                            (rx_negedge13 ? cnt : cnt - {{`SPI_CHAR_LEN_BITS13{1'b0}},1'b1});
  
  assign last = !(|cnt);
  
  assign rx_clk13 = (rx_negedge13 ? neg_edge13 : pos_edge13) && (!last || s_clk13);
  assign tx_clk13 = (tx_negedge13 ? neg_edge13 : pos_edge13) && !last;
  
  // Character13 bit counter
  always @(posedge clk13 or posedge rst13)
  begin
    if(rst13)
      cnt <= #Tp13 {`SPI_CHAR_LEN_BITS13+1{1'b0}};
    else
      begin
        if(tip13)
          cnt <= #Tp13 pos_edge13 ? (cnt - {{`SPI_CHAR_LEN_BITS13{1'b0}}, 1'b1}) : cnt;
        else
          cnt <= #Tp13 !(|len) ? {1'b1, {`SPI_CHAR_LEN_BITS13{1'b0}}} : {1'b0, len};
      end
  end
  
  // Transfer13 in progress13
  always @(posedge clk13 or posedge rst13)
  begin
    if(rst13)
      tip13 <= #Tp13 1'b0;
  else if(go13 && ~tip13)
    tip13 <= #Tp13 1'b1;
  else if(tip13 && last && pos_edge13)
    tip13 <= #Tp13 1'b0;
  end
  
  // Sending13 bits to the line
  always @(posedge clk13 or posedge rst13)
  begin
    if (rst13)
      s_out13   <= #Tp13 1'b0;
    else
      s_out13 <= #Tp13 (tx_clk13 || !tip13) ? data[tx_bit_pos13[`SPI_CHAR_LEN_BITS13-1:0]] : s_out13;
  end
  
  // Receiving13 bits from the line
  always @(posedge clk13 or posedge rst13)
  begin
    if (rst13)
      data   <= #Tp13 {`SPI_MAX_CHAR13{1'b0}};
`ifdef SPI_MAX_CHAR_12813
    else if (latch13[0] && !tip13)
      begin
        if (byte_sel13[3])
          data[31:24] <= #Tp13 p_in13[31:24];
        if (byte_sel13[2])
          data[23:16] <= #Tp13 p_in13[23:16];
        if (byte_sel13[1])
          data[15:8] <= #Tp13 p_in13[15:8];
        if (byte_sel13[0])
          data[7:0] <= #Tp13 p_in13[7:0];
      end
    else if (latch13[1] && !tip13)
      begin
        if (byte_sel13[3])
          data[63:56] <= #Tp13 p_in13[31:24];
        if (byte_sel13[2])
          data[55:48] <= #Tp13 p_in13[23:16];
        if (byte_sel13[1])
          data[47:40] <= #Tp13 p_in13[15:8];
        if (byte_sel13[0])
          data[39:32] <= #Tp13 p_in13[7:0];
      end
    else if (latch13[2] && !tip13)
      begin
        if (byte_sel13[3])
          data[95:88] <= #Tp13 p_in13[31:24];
        if (byte_sel13[2])
          data[87:80] <= #Tp13 p_in13[23:16];
        if (byte_sel13[1])
          data[79:72] <= #Tp13 p_in13[15:8];
        if (byte_sel13[0])
          data[71:64] <= #Tp13 p_in13[7:0];
      end
    else if (latch13[3] && !tip13)
      begin
        if (byte_sel13[3])
          data[127:120] <= #Tp13 p_in13[31:24];
        if (byte_sel13[2])
          data[119:112] <= #Tp13 p_in13[23:16];
        if (byte_sel13[1])
          data[111:104] <= #Tp13 p_in13[15:8];
        if (byte_sel13[0])
          data[103:96] <= #Tp13 p_in13[7:0];
      end
`else
`ifdef SPI_MAX_CHAR_6413
    else if (latch13[0] && !tip13)
      begin
        if (byte_sel13[3])
          data[31:24] <= #Tp13 p_in13[31:24];
        if (byte_sel13[2])
          data[23:16] <= #Tp13 p_in13[23:16];
        if (byte_sel13[1])
          data[15:8] <= #Tp13 p_in13[15:8];
        if (byte_sel13[0])
          data[7:0] <= #Tp13 p_in13[7:0];
      end
    else if (latch13[1] && !tip13)
      begin
        if (byte_sel13[3])
          data[63:56] <= #Tp13 p_in13[31:24];
        if (byte_sel13[2])
          data[55:48] <= #Tp13 p_in13[23:16];
        if (byte_sel13[1])
          data[47:40] <= #Tp13 p_in13[15:8];
        if (byte_sel13[0])
          data[39:32] <= #Tp13 p_in13[7:0];
      end
`else
    else if (latch13[0] && !tip13)
      begin
      `ifdef SPI_MAX_CHAR_813
        if (byte_sel13[0])
          data[`SPI_MAX_CHAR13-1:0] <= #Tp13 p_in13[`SPI_MAX_CHAR13-1:0];
      `endif
      `ifdef SPI_MAX_CHAR_1613
        if (byte_sel13[0])
          data[7:0] <= #Tp13 p_in13[7:0];
        if (byte_sel13[1])
          data[`SPI_MAX_CHAR13-1:8] <= #Tp13 p_in13[`SPI_MAX_CHAR13-1:8];
      `endif
      `ifdef SPI_MAX_CHAR_2413
        if (byte_sel13[0])
          data[7:0] <= #Tp13 p_in13[7:0];
        if (byte_sel13[1])
          data[15:8] <= #Tp13 p_in13[15:8];
        if (byte_sel13[2])
          data[`SPI_MAX_CHAR13-1:16] <= #Tp13 p_in13[`SPI_MAX_CHAR13-1:16];
      `endif
      `ifdef SPI_MAX_CHAR_3213
        if (byte_sel13[0])
          data[7:0] <= #Tp13 p_in13[7:0];
        if (byte_sel13[1])
          data[15:8] <= #Tp13 p_in13[15:8];
        if (byte_sel13[2])
          data[23:16] <= #Tp13 p_in13[23:16];
        if (byte_sel13[3])
          data[`SPI_MAX_CHAR13-1:24] <= #Tp13 p_in13[`SPI_MAX_CHAR13-1:24];
      `endif
      end
`endif
`endif
    else
      data[rx_bit_pos13[`SPI_CHAR_LEN_BITS13-1:0]] <= #Tp13 rx_clk13 ? s_in13 : data[rx_bit_pos13[`SPI_CHAR_LEN_BITS13-1:0]];
  end
  
endmodule

