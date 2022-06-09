//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_shift19.v                                                 ////
////                                                              ////
////  This19 file is part of the SPI19 IP19 core19 project19                ////
////  http19://www19.opencores19.org19/projects19/spi19/                      ////
////                                                              ////
////  Author19(s):                                                  ////
////      - Simon19 Srot19 (simons19@opencores19.org19)                     ////
////                                                              ////
////  All additional19 information is avaliable19 in the Readme19.txt19   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright19 (C) 2002 Authors19                                   ////
////                                                              ////
//// This19 source19 file may be used and distributed19 without         ////
//// restriction19 provided that this copyright19 statement19 is not    ////
//// removed from the file and that any derivative19 work19 contains19  ////
//// the original copyright19 notice19 and the associated disclaimer19. ////
////                                                              ////
//// This19 source19 file is free software19; you can redistribute19 it   ////
//// and/or modify it under the terms19 of the GNU19 Lesser19 General19   ////
//// Public19 License19 as published19 by the Free19 Software19 Foundation19; ////
//// either19 version19 2.1 of the License19, or (at your19 option) any   ////
//// later19 version19.                                               ////
////                                                              ////
//// This19 source19 is distributed19 in the hope19 that it will be       ////
//// useful19, but WITHOUT19 ANY19 WARRANTY19; without even19 the implied19   ////
//// warranty19 of MERCHANTABILITY19 or FITNESS19 FOR19 A PARTICULAR19      ////
//// PURPOSE19.  See the GNU19 Lesser19 General19 Public19 License19 for more ////
//// details19.                                                     ////
////                                                              ////
//// You should have received19 a copy of the GNU19 Lesser19 General19    ////
//// Public19 License19 along19 with this source19; if not, download19 it   ////
//// from http19://www19.opencores19.org19/lgpl19.shtml19                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines19.v"
`include "timescale.v"

module spi_shift19 (clk19, rst19, latch19, byte_sel19, len, lsb, go19,
                  pos_edge19, neg_edge19, rx_negedge19, tx_negedge19,
                  tip19, last, 
                  p_in19, p_out19, s_clk19, s_in19, s_out19);

  parameter Tp19 = 1;
  
  input                          clk19;          // system clock19
  input                          rst19;          // reset
  input                    [3:0] latch19;        // latch19 signal19 for storing19 the data in shift19 register
  input                    [3:0] byte_sel19;     // byte select19 signals19 for storing19 the data in shift19 register
  input [`SPI_CHAR_LEN_BITS19-1:0] len;          // data len in bits (minus19 one)
  input                          lsb;          // lbs19 first on the line
  input                          go19;           // start stansfer19
  input                          pos_edge19;     // recognize19 posedge of sclk19
  input                          neg_edge19;     // recognize19 negedge of sclk19
  input                          rx_negedge19;   // s_in19 is sampled19 on negative edge 
  input                          tx_negedge19;   // s_out19 is driven19 on negative edge
  output                         tip19;          // transfer19 in progress19
  output                         last;         // last bit
  input                   [31:0] p_in19;         // parallel19 in
  output     [`SPI_MAX_CHAR19-1:0] p_out19;        // parallel19 out
  input                          s_clk19;        // serial19 clock19
  input                          s_in19;         // serial19 in
  output                         s_out19;        // serial19 out
                                               
  reg                            s_out19;        
  reg                            tip19;
                              
  reg     [`SPI_CHAR_LEN_BITS19:0] cnt;          // data bit count
  reg        [`SPI_MAX_CHAR19-1:0] data;         // shift19 register
  wire    [`SPI_CHAR_LEN_BITS19:0] tx_bit_pos19;   // next bit position19
  wire    [`SPI_CHAR_LEN_BITS19:0] rx_bit_pos19;   // next bit position19
  wire                           rx_clk19;       // rx19 clock19 enable
  wire                           tx_clk19;       // tx19 clock19 enable
  
  assign p_out19 = data;
  
  assign tx_bit_pos19 = lsb ? {!(|len), len} - cnt : cnt - {{`SPI_CHAR_LEN_BITS19{1'b0}},1'b1};
  assign rx_bit_pos19 = lsb ? {!(|len), len} - (rx_negedge19 ? cnt + {{`SPI_CHAR_LEN_BITS19{1'b0}},1'b1} : cnt) : 
                            (rx_negedge19 ? cnt : cnt - {{`SPI_CHAR_LEN_BITS19{1'b0}},1'b1});
  
  assign last = !(|cnt);
  
  assign rx_clk19 = (rx_negedge19 ? neg_edge19 : pos_edge19) && (!last || s_clk19);
  assign tx_clk19 = (tx_negedge19 ? neg_edge19 : pos_edge19) && !last;
  
  // Character19 bit counter
  always @(posedge clk19 or posedge rst19)
  begin
    if(rst19)
      cnt <= #Tp19 {`SPI_CHAR_LEN_BITS19+1{1'b0}};
    else
      begin
        if(tip19)
          cnt <= #Tp19 pos_edge19 ? (cnt - {{`SPI_CHAR_LEN_BITS19{1'b0}}, 1'b1}) : cnt;
        else
          cnt <= #Tp19 !(|len) ? {1'b1, {`SPI_CHAR_LEN_BITS19{1'b0}}} : {1'b0, len};
      end
  end
  
  // Transfer19 in progress19
  always @(posedge clk19 or posedge rst19)
  begin
    if(rst19)
      tip19 <= #Tp19 1'b0;
  else if(go19 && ~tip19)
    tip19 <= #Tp19 1'b1;
  else if(tip19 && last && pos_edge19)
    tip19 <= #Tp19 1'b0;
  end
  
  // Sending19 bits to the line
  always @(posedge clk19 or posedge rst19)
  begin
    if (rst19)
      s_out19   <= #Tp19 1'b0;
    else
      s_out19 <= #Tp19 (tx_clk19 || !tip19) ? data[tx_bit_pos19[`SPI_CHAR_LEN_BITS19-1:0]] : s_out19;
  end
  
  // Receiving19 bits from the line
  always @(posedge clk19 or posedge rst19)
  begin
    if (rst19)
      data   <= #Tp19 {`SPI_MAX_CHAR19{1'b0}};
`ifdef SPI_MAX_CHAR_12819
    else if (latch19[0] && !tip19)
      begin
        if (byte_sel19[3])
          data[31:24] <= #Tp19 p_in19[31:24];
        if (byte_sel19[2])
          data[23:16] <= #Tp19 p_in19[23:16];
        if (byte_sel19[1])
          data[15:8] <= #Tp19 p_in19[15:8];
        if (byte_sel19[0])
          data[7:0] <= #Tp19 p_in19[7:0];
      end
    else if (latch19[1] && !tip19)
      begin
        if (byte_sel19[3])
          data[63:56] <= #Tp19 p_in19[31:24];
        if (byte_sel19[2])
          data[55:48] <= #Tp19 p_in19[23:16];
        if (byte_sel19[1])
          data[47:40] <= #Tp19 p_in19[15:8];
        if (byte_sel19[0])
          data[39:32] <= #Tp19 p_in19[7:0];
      end
    else if (latch19[2] && !tip19)
      begin
        if (byte_sel19[3])
          data[95:88] <= #Tp19 p_in19[31:24];
        if (byte_sel19[2])
          data[87:80] <= #Tp19 p_in19[23:16];
        if (byte_sel19[1])
          data[79:72] <= #Tp19 p_in19[15:8];
        if (byte_sel19[0])
          data[71:64] <= #Tp19 p_in19[7:0];
      end
    else if (latch19[3] && !tip19)
      begin
        if (byte_sel19[3])
          data[127:120] <= #Tp19 p_in19[31:24];
        if (byte_sel19[2])
          data[119:112] <= #Tp19 p_in19[23:16];
        if (byte_sel19[1])
          data[111:104] <= #Tp19 p_in19[15:8];
        if (byte_sel19[0])
          data[103:96] <= #Tp19 p_in19[7:0];
      end
`else
`ifdef SPI_MAX_CHAR_6419
    else if (latch19[0] && !tip19)
      begin
        if (byte_sel19[3])
          data[31:24] <= #Tp19 p_in19[31:24];
        if (byte_sel19[2])
          data[23:16] <= #Tp19 p_in19[23:16];
        if (byte_sel19[1])
          data[15:8] <= #Tp19 p_in19[15:8];
        if (byte_sel19[0])
          data[7:0] <= #Tp19 p_in19[7:0];
      end
    else if (latch19[1] && !tip19)
      begin
        if (byte_sel19[3])
          data[63:56] <= #Tp19 p_in19[31:24];
        if (byte_sel19[2])
          data[55:48] <= #Tp19 p_in19[23:16];
        if (byte_sel19[1])
          data[47:40] <= #Tp19 p_in19[15:8];
        if (byte_sel19[0])
          data[39:32] <= #Tp19 p_in19[7:0];
      end
`else
    else if (latch19[0] && !tip19)
      begin
      `ifdef SPI_MAX_CHAR_819
        if (byte_sel19[0])
          data[`SPI_MAX_CHAR19-1:0] <= #Tp19 p_in19[`SPI_MAX_CHAR19-1:0];
      `endif
      `ifdef SPI_MAX_CHAR_1619
        if (byte_sel19[0])
          data[7:0] <= #Tp19 p_in19[7:0];
        if (byte_sel19[1])
          data[`SPI_MAX_CHAR19-1:8] <= #Tp19 p_in19[`SPI_MAX_CHAR19-1:8];
      `endif
      `ifdef SPI_MAX_CHAR_2419
        if (byte_sel19[0])
          data[7:0] <= #Tp19 p_in19[7:0];
        if (byte_sel19[1])
          data[15:8] <= #Tp19 p_in19[15:8];
        if (byte_sel19[2])
          data[`SPI_MAX_CHAR19-1:16] <= #Tp19 p_in19[`SPI_MAX_CHAR19-1:16];
      `endif
      `ifdef SPI_MAX_CHAR_3219
        if (byte_sel19[0])
          data[7:0] <= #Tp19 p_in19[7:0];
        if (byte_sel19[1])
          data[15:8] <= #Tp19 p_in19[15:8];
        if (byte_sel19[2])
          data[23:16] <= #Tp19 p_in19[23:16];
        if (byte_sel19[3])
          data[`SPI_MAX_CHAR19-1:24] <= #Tp19 p_in19[`SPI_MAX_CHAR19-1:24];
      `endif
      end
`endif
`endif
    else
      data[rx_bit_pos19[`SPI_CHAR_LEN_BITS19-1:0]] <= #Tp19 rx_clk19 ? s_in19 : data[rx_bit_pos19[`SPI_CHAR_LEN_BITS19-1:0]];
  end
  
endmodule

