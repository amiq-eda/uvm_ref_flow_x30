//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_shift18.v                                                 ////
////                                                              ////
////  This18 file is part of the SPI18 IP18 core18 project18                ////
////  http18://www18.opencores18.org18/projects18/spi18/                      ////
////                                                              ////
////  Author18(s):                                                  ////
////      - Simon18 Srot18 (simons18@opencores18.org18)                     ////
////                                                              ////
////  All additional18 information is avaliable18 in the Readme18.txt18   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright18 (C) 2002 Authors18                                   ////
////                                                              ////
//// This18 source18 file may be used and distributed18 without         ////
//// restriction18 provided that this copyright18 statement18 is not    ////
//// removed from the file and that any derivative18 work18 contains18  ////
//// the original copyright18 notice18 and the associated disclaimer18. ////
////                                                              ////
//// This18 source18 file is free software18; you can redistribute18 it   ////
//// and/or modify it under the terms18 of the GNU18 Lesser18 General18   ////
//// Public18 License18 as published18 by the Free18 Software18 Foundation18; ////
//// either18 version18 2.1 of the License18, or (at your18 option) any   ////
//// later18 version18.                                               ////
////                                                              ////
//// This18 source18 is distributed18 in the hope18 that it will be       ////
//// useful18, but WITHOUT18 ANY18 WARRANTY18; without even18 the implied18   ////
//// warranty18 of MERCHANTABILITY18 or FITNESS18 FOR18 A PARTICULAR18      ////
//// PURPOSE18.  See the GNU18 Lesser18 General18 Public18 License18 for more ////
//// details18.                                                     ////
////                                                              ////
//// You should have received18 a copy of the GNU18 Lesser18 General18    ////
//// Public18 License18 along18 with this source18; if not, download18 it   ////
//// from http18://www18.opencores18.org18/lgpl18.shtml18                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

`include "spi_defines18.v"
`include "timescale.v"

module spi_shift18 (clk18, rst18, latch18, byte_sel18, len, lsb, go18,
                  pos_edge18, neg_edge18, rx_negedge18, tx_negedge18,
                  tip18, last, 
                  p_in18, p_out18, s_clk18, s_in18, s_out18);

  parameter Tp18 = 1;
  
  input                          clk18;          // system clock18
  input                          rst18;          // reset
  input                    [3:0] latch18;        // latch18 signal18 for storing18 the data in shift18 register
  input                    [3:0] byte_sel18;     // byte select18 signals18 for storing18 the data in shift18 register
  input [`SPI_CHAR_LEN_BITS18-1:0] len;          // data len in bits (minus18 one)
  input                          lsb;          // lbs18 first on the line
  input                          go18;           // start stansfer18
  input                          pos_edge18;     // recognize18 posedge of sclk18
  input                          neg_edge18;     // recognize18 negedge of sclk18
  input                          rx_negedge18;   // s_in18 is sampled18 on negative edge 
  input                          tx_negedge18;   // s_out18 is driven18 on negative edge
  output                         tip18;          // transfer18 in progress18
  output                         last;         // last bit
  input                   [31:0] p_in18;         // parallel18 in
  output     [`SPI_MAX_CHAR18-1:0] p_out18;        // parallel18 out
  input                          s_clk18;        // serial18 clock18
  input                          s_in18;         // serial18 in
  output                         s_out18;        // serial18 out
                                               
  reg                            s_out18;        
  reg                            tip18;
                              
  reg     [`SPI_CHAR_LEN_BITS18:0] cnt;          // data bit count
  reg        [`SPI_MAX_CHAR18-1:0] data;         // shift18 register
  wire    [`SPI_CHAR_LEN_BITS18:0] tx_bit_pos18;   // next bit position18
  wire    [`SPI_CHAR_LEN_BITS18:0] rx_bit_pos18;   // next bit position18
  wire                           rx_clk18;       // rx18 clock18 enable
  wire                           tx_clk18;       // tx18 clock18 enable
  
  assign p_out18 = data;
  
  assign tx_bit_pos18 = lsb ? {!(|len), len} - cnt : cnt - {{`SPI_CHAR_LEN_BITS18{1'b0}},1'b1};
  assign rx_bit_pos18 = lsb ? {!(|len), len} - (rx_negedge18 ? cnt + {{`SPI_CHAR_LEN_BITS18{1'b0}},1'b1} : cnt) : 
                            (rx_negedge18 ? cnt : cnt - {{`SPI_CHAR_LEN_BITS18{1'b0}},1'b1});
  
  assign last = !(|cnt);
  
  assign rx_clk18 = (rx_negedge18 ? neg_edge18 : pos_edge18) && (!last || s_clk18);
  assign tx_clk18 = (tx_negedge18 ? neg_edge18 : pos_edge18) && !last;
  
  // Character18 bit counter
  always @(posedge clk18 or posedge rst18)
  begin
    if(rst18)
      cnt <= #Tp18 {`SPI_CHAR_LEN_BITS18+1{1'b0}};
    else
      begin
        if(tip18)
          cnt <= #Tp18 pos_edge18 ? (cnt - {{`SPI_CHAR_LEN_BITS18{1'b0}}, 1'b1}) : cnt;
        else
          cnt <= #Tp18 !(|len) ? {1'b1, {`SPI_CHAR_LEN_BITS18{1'b0}}} : {1'b0, len};
      end
  end
  
  // Transfer18 in progress18
  always @(posedge clk18 or posedge rst18)
  begin
    if(rst18)
      tip18 <= #Tp18 1'b0;
  else if(go18 && ~tip18)
    tip18 <= #Tp18 1'b1;
  else if(tip18 && last && pos_edge18)
    tip18 <= #Tp18 1'b0;
  end
  
  // Sending18 bits to the line
  always @(posedge clk18 or posedge rst18)
  begin
    if (rst18)
      s_out18   <= #Tp18 1'b0;
    else
      s_out18 <= #Tp18 (tx_clk18 || !tip18) ? data[tx_bit_pos18[`SPI_CHAR_LEN_BITS18-1:0]] : s_out18;
  end
  
  // Receiving18 bits from the line
  always @(posedge clk18 or posedge rst18)
  begin
    if (rst18)
      data   <= #Tp18 {`SPI_MAX_CHAR18{1'b0}};
`ifdef SPI_MAX_CHAR_12818
    else if (latch18[0] && !tip18)
      begin
        if (byte_sel18[3])
          data[31:24] <= #Tp18 p_in18[31:24];
        if (byte_sel18[2])
          data[23:16] <= #Tp18 p_in18[23:16];
        if (byte_sel18[1])
          data[15:8] <= #Tp18 p_in18[15:8];
        if (byte_sel18[0])
          data[7:0] <= #Tp18 p_in18[7:0];
      end
    else if (latch18[1] && !tip18)
      begin
        if (byte_sel18[3])
          data[63:56] <= #Tp18 p_in18[31:24];
        if (byte_sel18[2])
          data[55:48] <= #Tp18 p_in18[23:16];
        if (byte_sel18[1])
          data[47:40] <= #Tp18 p_in18[15:8];
        if (byte_sel18[0])
          data[39:32] <= #Tp18 p_in18[7:0];
      end
    else if (latch18[2] && !tip18)
      begin
        if (byte_sel18[3])
          data[95:88] <= #Tp18 p_in18[31:24];
        if (byte_sel18[2])
          data[87:80] <= #Tp18 p_in18[23:16];
        if (byte_sel18[1])
          data[79:72] <= #Tp18 p_in18[15:8];
        if (byte_sel18[0])
          data[71:64] <= #Tp18 p_in18[7:0];
      end
    else if (latch18[3] && !tip18)
      begin
        if (byte_sel18[3])
          data[127:120] <= #Tp18 p_in18[31:24];
        if (byte_sel18[2])
          data[119:112] <= #Tp18 p_in18[23:16];
        if (byte_sel18[1])
          data[111:104] <= #Tp18 p_in18[15:8];
        if (byte_sel18[0])
          data[103:96] <= #Tp18 p_in18[7:0];
      end
`else
`ifdef SPI_MAX_CHAR_6418
    else if (latch18[0] && !tip18)
      begin
        if (byte_sel18[3])
          data[31:24] <= #Tp18 p_in18[31:24];
        if (byte_sel18[2])
          data[23:16] <= #Tp18 p_in18[23:16];
        if (byte_sel18[1])
          data[15:8] <= #Tp18 p_in18[15:8];
        if (byte_sel18[0])
          data[7:0] <= #Tp18 p_in18[7:0];
      end
    else if (latch18[1] && !tip18)
      begin
        if (byte_sel18[3])
          data[63:56] <= #Tp18 p_in18[31:24];
        if (byte_sel18[2])
          data[55:48] <= #Tp18 p_in18[23:16];
        if (byte_sel18[1])
          data[47:40] <= #Tp18 p_in18[15:8];
        if (byte_sel18[0])
          data[39:32] <= #Tp18 p_in18[7:0];
      end
`else
    else if (latch18[0] && !tip18)
      begin
      `ifdef SPI_MAX_CHAR_818
        if (byte_sel18[0])
          data[`SPI_MAX_CHAR18-1:0] <= #Tp18 p_in18[`SPI_MAX_CHAR18-1:0];
      `endif
      `ifdef SPI_MAX_CHAR_1618
        if (byte_sel18[0])
          data[7:0] <= #Tp18 p_in18[7:0];
        if (byte_sel18[1])
          data[`SPI_MAX_CHAR18-1:8] <= #Tp18 p_in18[`SPI_MAX_CHAR18-1:8];
      `endif
      `ifdef SPI_MAX_CHAR_2418
        if (byte_sel18[0])
          data[7:0] <= #Tp18 p_in18[7:0];
        if (byte_sel18[1])
          data[15:8] <= #Tp18 p_in18[15:8];
        if (byte_sel18[2])
          data[`SPI_MAX_CHAR18-1:16] <= #Tp18 p_in18[`SPI_MAX_CHAR18-1:16];
      `endif
      `ifdef SPI_MAX_CHAR_3218
        if (byte_sel18[0])
          data[7:0] <= #Tp18 p_in18[7:0];
        if (byte_sel18[1])
          data[15:8] <= #Tp18 p_in18[15:8];
        if (byte_sel18[2])
          data[23:16] <= #Tp18 p_in18[23:16];
        if (byte_sel18[3])
          data[`SPI_MAX_CHAR18-1:24] <= #Tp18 p_in18[`SPI_MAX_CHAR18-1:24];
      `endif
      end
`endif
`endif
    else
      data[rx_bit_pos18[`SPI_CHAR_LEN_BITS18-1:0]] <= #Tp18 rx_clk18 ? s_in18 : data[rx_bit_pos18[`SPI_CHAR_LEN_BITS18-1:0]];
  end
  
endmodule

