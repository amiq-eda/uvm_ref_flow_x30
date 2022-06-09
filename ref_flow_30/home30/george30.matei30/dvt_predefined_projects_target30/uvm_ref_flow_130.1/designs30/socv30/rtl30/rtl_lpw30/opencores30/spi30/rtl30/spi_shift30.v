//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_shift30.v                                                 ////
////                                                              ////
////  This30 file is part of the SPI30 IP30 core30 project30                ////
////  http30://www30.opencores30.org30/projects30/spi30/                      ////
////                                                              ////
////  Author30(s):                                                  ////
////      - Simon30 Srot30 (simons30@opencores30.org30)                     ////
////                                                              ////
////  All additional30 information is avaliable30 in the Readme30.txt30   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright30 (C) 2002 Authors30                                   ////
////                                                              ////
//// This30 source30 file may be used and distributed30 without         ////
//// restriction30 provided that this copyright30 statement30 is not    ////
//// removed from the file and that any derivative30 work30 contains30  ////
//// the original copyright30 notice30 and the associated disclaimer30. ////
////                                                              ////
//// This30 source30 file is free software30; you can redistribute30 it   ////
//// and/or modify it under the terms30 of the GNU30 Lesser30 General30   ////
//// Public30 License30 as published30 by the Free30 Software30 Foundation30; ////
//// either30 version30 2.1 of the License30, or (at your30 option) any   ////
//// later30 version30.                                               ////
////                                                              ////
//// This30 source30 is distributed30 in the hope30 that it will be       ////
//// useful30, but WITHOUT30 ANY30 WARRANTY30; without even30 the implied30   ////
//// warranty30 of MERCHANTABILITY30 or FITNESS30 FOR30 A PARTICULAR30      ////
//// PURPOSE30.  See the GNU30 Lesser30 General30 Public30 License30 for more ////
//// details30.                                                     ////
////                                                              ////
//// You should have received30 a copy of the GNU30 Lesser30 General30    ////
//// Public30 License30 along30 with this source30; if not, download30 it   ////
//// from http30://www30.opencores30.org30/lgpl30.shtml30                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines30.v"
`include "timescale.v"

module spi_shift30 (clk30, rst30, latch30, byte_sel30, len, lsb, go30,
                  pos_edge30, neg_edge30, rx_negedge30, tx_negedge30,
                  tip30, last, 
                  p_in30, p_out30, s_clk30, s_in30, s_out30);

  parameter Tp30 = 1;
  
  input                          clk30;          // system clock30
  input                          rst30;          // reset
  input                    [3:0] latch30;        // latch30 signal30 for storing30 the data in shift30 register
  input                    [3:0] byte_sel30;     // byte select30 signals30 for storing30 the data in shift30 register
  input [`SPI_CHAR_LEN_BITS30-1:0] len;          // data len in bits (minus30 one)
  input                          lsb;          // lbs30 first on the line
  input                          go30;           // start stansfer30
  input                          pos_edge30;     // recognize30 posedge of sclk30
  input                          neg_edge30;     // recognize30 negedge of sclk30
  input                          rx_negedge30;   // s_in30 is sampled30 on negative edge 
  input                          tx_negedge30;   // s_out30 is driven30 on negative edge
  output                         tip30;          // transfer30 in progress30
  output                         last;         // last bit
  input                   [31:0] p_in30;         // parallel30 in
  output     [`SPI_MAX_CHAR30-1:0] p_out30;        // parallel30 out
  input                          s_clk30;        // serial30 clock30
  input                          s_in30;         // serial30 in
  output                         s_out30;        // serial30 out
                                               
  reg                            s_out30;        
  reg                            tip30;
                              
  reg     [`SPI_CHAR_LEN_BITS30:0] cnt;          // data bit count
  reg        [`SPI_MAX_CHAR30-1:0] data;         // shift30 register
  wire    [`SPI_CHAR_LEN_BITS30:0] tx_bit_pos30;   // next bit position30
  wire    [`SPI_CHAR_LEN_BITS30:0] rx_bit_pos30;   // next bit position30
  wire                           rx_clk30;       // rx30 clock30 enable
  wire                           tx_clk30;       // tx30 clock30 enable
  
  assign p_out30 = data;
  
  assign tx_bit_pos30 = lsb ? {!(|len), len} - cnt : cnt - {{`SPI_CHAR_LEN_BITS30{1'b0}},1'b1};
  assign rx_bit_pos30 = lsb ? {!(|len), len} - (rx_negedge30 ? cnt + {{`SPI_CHAR_LEN_BITS30{1'b0}},1'b1} : cnt) : 
                            (rx_negedge30 ? cnt : cnt - {{`SPI_CHAR_LEN_BITS30{1'b0}},1'b1});
  
  assign last = !(|cnt);
  
  assign rx_clk30 = (rx_negedge30 ? neg_edge30 : pos_edge30) && (!last || s_clk30);
  assign tx_clk30 = (tx_negedge30 ? neg_edge30 : pos_edge30) && !last;
  
  // Character30 bit counter
  always @(posedge clk30 or posedge rst30)
  begin
    if(rst30)
      cnt <= #Tp30 {`SPI_CHAR_LEN_BITS30+1{1'b0}};
    else
      begin
        if(tip30)
          cnt <= #Tp30 pos_edge30 ? (cnt - {{`SPI_CHAR_LEN_BITS30{1'b0}}, 1'b1}) : cnt;
        else
          cnt <= #Tp30 !(|len) ? {1'b1, {`SPI_CHAR_LEN_BITS30{1'b0}}} : {1'b0, len};
      end
  end
  
  // Transfer30 in progress30
  always @(posedge clk30 or posedge rst30)
  begin
    if(rst30)
      tip30 <= #Tp30 1'b0;
  else if(go30 && ~tip30)
    tip30 <= #Tp30 1'b1;
  else if(tip30 && last && pos_edge30)
    tip30 <= #Tp30 1'b0;
  end
  
  // Sending30 bits to the line
  always @(posedge clk30 or posedge rst30)
  begin
    if (rst30)
      s_out30   <= #Tp30 1'b0;
    else
      s_out30 <= #Tp30 (tx_clk30 || !tip30) ? data[tx_bit_pos30[`SPI_CHAR_LEN_BITS30-1:0]] : s_out30;
  end
  
  // Receiving30 bits from the line
  always @(posedge clk30 or posedge rst30)
  begin
    if (rst30)
      data   <= #Tp30 {`SPI_MAX_CHAR30{1'b0}};
`ifdef SPI_MAX_CHAR_12830
    else if (latch30[0] && !tip30)
      begin
        if (byte_sel30[3])
          data[31:24] <= #Tp30 p_in30[31:24];
        if (byte_sel30[2])
          data[23:16] <= #Tp30 p_in30[23:16];
        if (byte_sel30[1])
          data[15:8] <= #Tp30 p_in30[15:8];
        if (byte_sel30[0])
          data[7:0] <= #Tp30 p_in30[7:0];
      end
    else if (latch30[1] && !tip30)
      begin
        if (byte_sel30[3])
          data[63:56] <= #Tp30 p_in30[31:24];
        if (byte_sel30[2])
          data[55:48] <= #Tp30 p_in30[23:16];
        if (byte_sel30[1])
          data[47:40] <= #Tp30 p_in30[15:8];
        if (byte_sel30[0])
          data[39:32] <= #Tp30 p_in30[7:0];
      end
    else if (latch30[2] && !tip30)
      begin
        if (byte_sel30[3])
          data[95:88] <= #Tp30 p_in30[31:24];
        if (byte_sel30[2])
          data[87:80] <= #Tp30 p_in30[23:16];
        if (byte_sel30[1])
          data[79:72] <= #Tp30 p_in30[15:8];
        if (byte_sel30[0])
          data[71:64] <= #Tp30 p_in30[7:0];
      end
    else if (latch30[3] && !tip30)
      begin
        if (byte_sel30[3])
          data[127:120] <= #Tp30 p_in30[31:24];
        if (byte_sel30[2])
          data[119:112] <= #Tp30 p_in30[23:16];
        if (byte_sel30[1])
          data[111:104] <= #Tp30 p_in30[15:8];
        if (byte_sel30[0])
          data[103:96] <= #Tp30 p_in30[7:0];
      end
`else
`ifdef SPI_MAX_CHAR_6430
    else if (latch30[0] && !tip30)
      begin
        if (byte_sel30[3])
          data[31:24] <= #Tp30 p_in30[31:24];
        if (byte_sel30[2])
          data[23:16] <= #Tp30 p_in30[23:16];
        if (byte_sel30[1])
          data[15:8] <= #Tp30 p_in30[15:8];
        if (byte_sel30[0])
          data[7:0] <= #Tp30 p_in30[7:0];
      end
    else if (latch30[1] && !tip30)
      begin
        if (byte_sel30[3])
          data[63:56] <= #Tp30 p_in30[31:24];
        if (byte_sel30[2])
          data[55:48] <= #Tp30 p_in30[23:16];
        if (byte_sel30[1])
          data[47:40] <= #Tp30 p_in30[15:8];
        if (byte_sel30[0])
          data[39:32] <= #Tp30 p_in30[7:0];
      end
`else
    else if (latch30[0] && !tip30)
      begin
      `ifdef SPI_MAX_CHAR_830
        if (byte_sel30[0])
          data[`SPI_MAX_CHAR30-1:0] <= #Tp30 p_in30[`SPI_MAX_CHAR30-1:0];
      `endif
      `ifdef SPI_MAX_CHAR_1630
        if (byte_sel30[0])
          data[7:0] <= #Tp30 p_in30[7:0];
        if (byte_sel30[1])
          data[`SPI_MAX_CHAR30-1:8] <= #Tp30 p_in30[`SPI_MAX_CHAR30-1:8];
      `endif
      `ifdef SPI_MAX_CHAR_2430
        if (byte_sel30[0])
          data[7:0] <= #Tp30 p_in30[7:0];
        if (byte_sel30[1])
          data[15:8] <= #Tp30 p_in30[15:8];
        if (byte_sel30[2])
          data[`SPI_MAX_CHAR30-1:16] <= #Tp30 p_in30[`SPI_MAX_CHAR30-1:16];
      `endif
      `ifdef SPI_MAX_CHAR_3230
        if (byte_sel30[0])
          data[7:0] <= #Tp30 p_in30[7:0];
        if (byte_sel30[1])
          data[15:8] <= #Tp30 p_in30[15:8];
        if (byte_sel30[2])
          data[23:16] <= #Tp30 p_in30[23:16];
        if (byte_sel30[3])
          data[`SPI_MAX_CHAR30-1:24] <= #Tp30 p_in30[`SPI_MAX_CHAR30-1:24];
      `endif
      end
`endif
`endif
    else
      data[rx_bit_pos30[`SPI_CHAR_LEN_BITS30-1:0]] <= #Tp30 rx_clk30 ? s_in30 : data[rx_bit_pos30[`SPI_CHAR_LEN_BITS30-1:0]];
  end
  
endmodule

