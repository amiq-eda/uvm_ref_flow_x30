//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_shift26.v                                                 ////
////                                                              ////
////  This26 file is part of the SPI26 IP26 core26 project26                ////
////  http26://www26.opencores26.org26/projects26/spi26/                      ////
////                                                              ////
////  Author26(s):                                                  ////
////      - Simon26 Srot26 (simons26@opencores26.org26)                     ////
////                                                              ////
////  All additional26 information is avaliable26 in the Readme26.txt26   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright26 (C) 2002 Authors26                                   ////
////                                                              ////
//// This26 source26 file may be used and distributed26 without         ////
//// restriction26 provided that this copyright26 statement26 is not    ////
//// removed from the file and that any derivative26 work26 contains26  ////
//// the original copyright26 notice26 and the associated disclaimer26. ////
////                                                              ////
//// This26 source26 file is free software26; you can redistribute26 it   ////
//// and/or modify it under the terms26 of the GNU26 Lesser26 General26   ////
//// Public26 License26 as published26 by the Free26 Software26 Foundation26; ////
//// either26 version26 2.1 of the License26, or (at your26 option) any   ////
//// later26 version26.                                               ////
////                                                              ////
//// This26 source26 is distributed26 in the hope26 that it will be       ////
//// useful26, but WITHOUT26 ANY26 WARRANTY26; without even26 the implied26   ////
//// warranty26 of MERCHANTABILITY26 or FITNESS26 FOR26 A PARTICULAR26      ////
//// PURPOSE26.  See the GNU26 Lesser26 General26 Public26 License26 for more ////
//// details26.                                                     ////
////                                                              ////
//// You should have received26 a copy of the GNU26 Lesser26 General26    ////
//// Public26 License26 along26 with this source26; if not, download26 it   ////
//// from http26://www26.opencores26.org26/lgpl26.shtml26                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines26.v"
`include "timescale.v"

module spi_shift26 (clk26, rst26, latch26, byte_sel26, len, lsb, go26,
                  pos_edge26, neg_edge26, rx_negedge26, tx_negedge26,
                  tip26, last, 
                  p_in26, p_out26, s_clk26, s_in26, s_out26);

  parameter Tp26 = 1;
  
  input                          clk26;          // system clock26
  input                          rst26;          // reset
  input                    [3:0] latch26;        // latch26 signal26 for storing26 the data in shift26 register
  input                    [3:0] byte_sel26;     // byte select26 signals26 for storing26 the data in shift26 register
  input [`SPI_CHAR_LEN_BITS26-1:0] len;          // data len in bits (minus26 one)
  input                          lsb;          // lbs26 first on the line
  input                          go26;           // start stansfer26
  input                          pos_edge26;     // recognize26 posedge of sclk26
  input                          neg_edge26;     // recognize26 negedge of sclk26
  input                          rx_negedge26;   // s_in26 is sampled26 on negative edge 
  input                          tx_negedge26;   // s_out26 is driven26 on negative edge
  output                         tip26;          // transfer26 in progress26
  output                         last;         // last bit
  input                   [31:0] p_in26;         // parallel26 in
  output     [`SPI_MAX_CHAR26-1:0] p_out26;        // parallel26 out
  input                          s_clk26;        // serial26 clock26
  input                          s_in26;         // serial26 in
  output                         s_out26;        // serial26 out
                                               
  reg                            s_out26;        
  reg                            tip26;
                              
  reg     [`SPI_CHAR_LEN_BITS26:0] cnt;          // data bit count
  reg        [`SPI_MAX_CHAR26-1:0] data;         // shift26 register
  wire    [`SPI_CHAR_LEN_BITS26:0] tx_bit_pos26;   // next bit position26
  wire    [`SPI_CHAR_LEN_BITS26:0] rx_bit_pos26;   // next bit position26
  wire                           rx_clk26;       // rx26 clock26 enable
  wire                           tx_clk26;       // tx26 clock26 enable
  
  assign p_out26 = data;
  
  assign tx_bit_pos26 = lsb ? {!(|len), len} - cnt : cnt - {{`SPI_CHAR_LEN_BITS26{1'b0}},1'b1};
  assign rx_bit_pos26 = lsb ? {!(|len), len} - (rx_negedge26 ? cnt + {{`SPI_CHAR_LEN_BITS26{1'b0}},1'b1} : cnt) : 
                            (rx_negedge26 ? cnt : cnt - {{`SPI_CHAR_LEN_BITS26{1'b0}},1'b1});
  
  assign last = !(|cnt);
  
  assign rx_clk26 = (rx_negedge26 ? neg_edge26 : pos_edge26) && (!last || s_clk26);
  assign tx_clk26 = (tx_negedge26 ? neg_edge26 : pos_edge26) && !last;
  
  // Character26 bit counter
  always @(posedge clk26 or posedge rst26)
  begin
    if(rst26)
      cnt <= #Tp26 {`SPI_CHAR_LEN_BITS26+1{1'b0}};
    else
      begin
        if(tip26)
          cnt <= #Tp26 pos_edge26 ? (cnt - {{`SPI_CHAR_LEN_BITS26{1'b0}}, 1'b1}) : cnt;
        else
          cnt <= #Tp26 !(|len) ? {1'b1, {`SPI_CHAR_LEN_BITS26{1'b0}}} : {1'b0, len};
      end
  end
  
  // Transfer26 in progress26
  always @(posedge clk26 or posedge rst26)
  begin
    if(rst26)
      tip26 <= #Tp26 1'b0;
  else if(go26 && ~tip26)
    tip26 <= #Tp26 1'b1;
  else if(tip26 && last && pos_edge26)
    tip26 <= #Tp26 1'b0;
  end
  
  // Sending26 bits to the line
  always @(posedge clk26 or posedge rst26)
  begin
    if (rst26)
      s_out26   <= #Tp26 1'b0;
    else
      s_out26 <= #Tp26 (tx_clk26 || !tip26) ? data[tx_bit_pos26[`SPI_CHAR_LEN_BITS26-1:0]] : s_out26;
  end
  
  // Receiving26 bits from the line
  always @(posedge clk26 or posedge rst26)
  begin
    if (rst26)
      data   <= #Tp26 {`SPI_MAX_CHAR26{1'b0}};
`ifdef SPI_MAX_CHAR_12826
    else if (latch26[0] && !tip26)
      begin
        if (byte_sel26[3])
          data[31:24] <= #Tp26 p_in26[31:24];
        if (byte_sel26[2])
          data[23:16] <= #Tp26 p_in26[23:16];
        if (byte_sel26[1])
          data[15:8] <= #Tp26 p_in26[15:8];
        if (byte_sel26[0])
          data[7:0] <= #Tp26 p_in26[7:0];
      end
    else if (latch26[1] && !tip26)
      begin
        if (byte_sel26[3])
          data[63:56] <= #Tp26 p_in26[31:24];
        if (byte_sel26[2])
          data[55:48] <= #Tp26 p_in26[23:16];
        if (byte_sel26[1])
          data[47:40] <= #Tp26 p_in26[15:8];
        if (byte_sel26[0])
          data[39:32] <= #Tp26 p_in26[7:0];
      end
    else if (latch26[2] && !tip26)
      begin
        if (byte_sel26[3])
          data[95:88] <= #Tp26 p_in26[31:24];
        if (byte_sel26[2])
          data[87:80] <= #Tp26 p_in26[23:16];
        if (byte_sel26[1])
          data[79:72] <= #Tp26 p_in26[15:8];
        if (byte_sel26[0])
          data[71:64] <= #Tp26 p_in26[7:0];
      end
    else if (latch26[3] && !tip26)
      begin
        if (byte_sel26[3])
          data[127:120] <= #Tp26 p_in26[31:24];
        if (byte_sel26[2])
          data[119:112] <= #Tp26 p_in26[23:16];
        if (byte_sel26[1])
          data[111:104] <= #Tp26 p_in26[15:8];
        if (byte_sel26[0])
          data[103:96] <= #Tp26 p_in26[7:0];
      end
`else
`ifdef SPI_MAX_CHAR_6426
    else if (latch26[0] && !tip26)
      begin
        if (byte_sel26[3])
          data[31:24] <= #Tp26 p_in26[31:24];
        if (byte_sel26[2])
          data[23:16] <= #Tp26 p_in26[23:16];
        if (byte_sel26[1])
          data[15:8] <= #Tp26 p_in26[15:8];
        if (byte_sel26[0])
          data[7:0] <= #Tp26 p_in26[7:0];
      end
    else if (latch26[1] && !tip26)
      begin
        if (byte_sel26[3])
          data[63:56] <= #Tp26 p_in26[31:24];
        if (byte_sel26[2])
          data[55:48] <= #Tp26 p_in26[23:16];
        if (byte_sel26[1])
          data[47:40] <= #Tp26 p_in26[15:8];
        if (byte_sel26[0])
          data[39:32] <= #Tp26 p_in26[7:0];
      end
`else
    else if (latch26[0] && !tip26)
      begin
      `ifdef SPI_MAX_CHAR_826
        if (byte_sel26[0])
          data[`SPI_MAX_CHAR26-1:0] <= #Tp26 p_in26[`SPI_MAX_CHAR26-1:0];
      `endif
      `ifdef SPI_MAX_CHAR_1626
        if (byte_sel26[0])
          data[7:0] <= #Tp26 p_in26[7:0];
        if (byte_sel26[1])
          data[`SPI_MAX_CHAR26-1:8] <= #Tp26 p_in26[`SPI_MAX_CHAR26-1:8];
      `endif
      `ifdef SPI_MAX_CHAR_2426
        if (byte_sel26[0])
          data[7:0] <= #Tp26 p_in26[7:0];
        if (byte_sel26[1])
          data[15:8] <= #Tp26 p_in26[15:8];
        if (byte_sel26[2])
          data[`SPI_MAX_CHAR26-1:16] <= #Tp26 p_in26[`SPI_MAX_CHAR26-1:16];
      `endif
      `ifdef SPI_MAX_CHAR_3226
        if (byte_sel26[0])
          data[7:0] <= #Tp26 p_in26[7:0];
        if (byte_sel26[1])
          data[15:8] <= #Tp26 p_in26[15:8];
        if (byte_sel26[2])
          data[23:16] <= #Tp26 p_in26[23:16];
        if (byte_sel26[3])
          data[`SPI_MAX_CHAR26-1:24] <= #Tp26 p_in26[`SPI_MAX_CHAR26-1:24];
      `endif
      end
`endif
`endif
    else
      data[rx_bit_pos26[`SPI_CHAR_LEN_BITS26-1:0]] <= #Tp26 rx_clk26 ? s_in26 : data[rx_bit_pos26[`SPI_CHAR_LEN_BITS26-1:0]];
  end
  
endmodule

