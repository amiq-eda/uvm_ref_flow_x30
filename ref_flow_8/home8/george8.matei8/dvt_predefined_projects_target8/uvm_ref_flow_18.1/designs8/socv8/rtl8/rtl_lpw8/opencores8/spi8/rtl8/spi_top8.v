//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_top8.v                                                   ////
////                                                              ////
////  This8 file is part of the SPI8 IP8 core8 project8                ////
////  http8://www8.opencores8.org8/projects8/spi8/                      ////
////                                                              ////
////  Author8(s):                                                  ////
////      - Simon8 Srot8 (simons8@opencores8.org8)                     ////
////                                                              ////
////  All additional8 information is avaliable8 in the Readme8.txt8   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright8 (C) 2002 Authors8                                   ////
////                                                              ////
//// This8 source8 file may be used and distributed8 without         ////
//// restriction8 provided that this copyright8 statement8 is not    ////
//// removed from the file and that any derivative8 work8 contains8  ////
//// the original copyright8 notice8 and the associated disclaimer8. ////
////                                                              ////
//// This8 source8 file is free software8; you can redistribute8 it   ////
//// and/or modify it under the terms8 of the GNU8 Lesser8 General8   ////
//// Public8 License8 as published8 by the Free8 Software8 Foundation8; ////
//// either8 version8 2.1 of the License8, or (at your8 option) any   ////
//// later8 version8.                                               ////
////                                                              ////
//// This8 source8 is distributed8 in the hope8 that it will be       ////
//// useful8, but WITHOUT8 ANY8 WARRANTY8; without even8 the implied8   ////
//// warranty8 of MERCHANTABILITY8 or FITNESS8 FOR8 A PARTICULAR8      ////
//// PURPOSE8.  See the GNU8 Lesser8 General8 Public8 License8 for more ////
//// details8.                                                     ////
////                                                              ////
//// You should have received8 a copy of the GNU8 Lesser8 General8    ////
//// Public8 License8 along8 with this source8; if not, download8 it   ////
//// from http8://www8.opencores8.org8/lgpl8.shtml8                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////


`include "spi_defines8.v"
`include "timescale.v"

module spi_top8
(
  // Wishbone8 signals8
  wb_clk_i8, wb_rst_i8, wb_adr_i8, wb_dat_i8, wb_dat_o8, wb_sel_i8,
  wb_we_i8, wb_stb_i8, wb_cyc_i8, wb_ack_o8, wb_err_o8, wb_int_o8,

  // SPI8 signals8
  ss_pad_o8, sclk_pad_o8, mosi_pad_o8, miso_pad_i8
);

  parameter Tp8 = 1;

  // Wishbone8 signals8
  input                            wb_clk_i8;         // master8 clock8 input
  input                            wb_rst_i8;         // synchronous8 active high8 reset
  input                      [4:0] wb_adr_i8;         // lower8 address bits
  input                   [32-1:0] wb_dat_i8;         // databus8 input
  output                  [32-1:0] wb_dat_o8;         // databus8 output
  input                      [3:0] wb_sel_i8;         // byte select8 inputs8
  input                            wb_we_i8;          // write enable input
  input                            wb_stb_i8;         // stobe8/core8 select8 signal8
  input                            wb_cyc_i8;         // valid bus cycle input
  output                           wb_ack_o8;         // bus cycle acknowledge8 output
  output                           wb_err_o8;         // termination w/ error
  output                           wb_int_o8;         // interrupt8 request signal8 output
                                                     
  // SPI8 signals8                                     
  output          [`SPI_SS_NB8-1:0] ss_pad_o8;         // slave8 select8
  output                           sclk_pad_o8;       // serial8 clock8
  output                           mosi_pad_o8;       // master8 out slave8 in
  input                            miso_pad_i8;       // master8 in slave8 out
                                                     
  reg                     [32-1:0] wb_dat_o8;
  reg                              wb_ack_o8;
  reg                              wb_int_o8;
                                               
  // Internal signals8
  reg       [`SPI_DIVIDER_LEN8-1:0] divider8;          // Divider8 register
  reg       [`SPI_CTRL_BIT_NB8-1:0] ctrl8;             // Control8 and status register
  reg             [`SPI_SS_NB8-1:0] ss;               // Slave8 select8 register
  reg                     [32-1:0] wb_dat8;           // wb8 data out
  wire         [`SPI_MAX_CHAR8-1:0] rx8;               // Rx8 register
  wire                             rx_negedge8;       // miso8 is sampled8 on negative edge
  wire                             tx_negedge8;       // mosi8 is driven8 on negative edge
  wire    [`SPI_CHAR_LEN_BITS8-1:0] char_len8;         // char8 len
  wire                             go8;               // go8
  wire                             lsb;              // lsb first on line
  wire                             ie8;               // interrupt8 enable
  wire                             ass8;              // automatic slave8 select8
  wire                             spi_divider_sel8;  // divider8 register select8
  wire                             spi_ctrl_sel8;     // ctrl8 register select8
  wire                       [3:0] spi_tx_sel8;       // tx_l8 register select8
  wire                             spi_ss_sel8;       // ss register select8
  wire                             tip8;              // transfer8 in progress8
  wire                             pos_edge8;         // recognize8 posedge of sclk8
  wire                             neg_edge8;         // recognize8 negedge of sclk8
  wire                             last_bit8;         // marks8 last character8 bit
  
  // Address decoder8
  assign spi_divider_sel8 = wb_cyc_i8 & wb_stb_i8 & (wb_adr_i8[`SPI_OFS_BITS8] == `SPI_DEVIDE8);
  assign spi_ctrl_sel8    = wb_cyc_i8 & wb_stb_i8 & (wb_adr_i8[`SPI_OFS_BITS8] == `SPI_CTRL8);
  assign spi_tx_sel8[0]   = wb_cyc_i8 & wb_stb_i8 & (wb_adr_i8[`SPI_OFS_BITS8] == `SPI_TX_08);
  assign spi_tx_sel8[1]   = wb_cyc_i8 & wb_stb_i8 & (wb_adr_i8[`SPI_OFS_BITS8] == `SPI_TX_18);
  assign spi_tx_sel8[2]   = wb_cyc_i8 & wb_stb_i8 & (wb_adr_i8[`SPI_OFS_BITS8] == `SPI_TX_28);
  assign spi_tx_sel8[3]   = wb_cyc_i8 & wb_stb_i8 & (wb_adr_i8[`SPI_OFS_BITS8] == `SPI_TX_38);
  assign spi_ss_sel8      = wb_cyc_i8 & wb_stb_i8 & (wb_adr_i8[`SPI_OFS_BITS8] == `SPI_SS8);
  
  // Read from registers
  always @(wb_adr_i8 or rx8 or ctrl8 or divider8 or ss)
  begin
    case (wb_adr_i8[`SPI_OFS_BITS8])
`ifdef SPI_MAX_CHAR_1288
      `SPI_RX_08:    wb_dat8 = rx8[31:0];
      `SPI_RX_18:    wb_dat8 = rx8[63:32];
      `SPI_RX_28:    wb_dat8 = rx8[95:64];
      `SPI_RX_38:    wb_dat8 = {{128-`SPI_MAX_CHAR8{1'b0}}, rx8[`SPI_MAX_CHAR8-1:96]};
`else
`ifdef SPI_MAX_CHAR_648
      `SPI_RX_08:    wb_dat8 = rx8[31:0];
      `SPI_RX_18:    wb_dat8 = {{64-`SPI_MAX_CHAR8{1'b0}}, rx8[`SPI_MAX_CHAR8-1:32]};
      `SPI_RX_28:    wb_dat8 = 32'b0;
      `SPI_RX_38:    wb_dat8 = 32'b0;
`else
      `SPI_RX_08:    wb_dat8 = {{32-`SPI_MAX_CHAR8{1'b0}}, rx8[`SPI_MAX_CHAR8-1:0]};
      `SPI_RX_18:    wb_dat8 = 32'b0;
      `SPI_RX_28:    wb_dat8 = 32'b0;
      `SPI_RX_38:    wb_dat8 = 32'b0;
`endif
`endif
      `SPI_CTRL8:    wb_dat8 = {{32-`SPI_CTRL_BIT_NB8{1'b0}}, ctrl8};
      `SPI_DEVIDE8:  wb_dat8 = {{32-`SPI_DIVIDER_LEN8{1'b0}}, divider8};
      `SPI_SS8:      wb_dat8 = {{32-`SPI_SS_NB8{1'b0}}, ss};
      default:      wb_dat8 = 32'bx;
    endcase
  end
  
  // Wb8 data out
  always @(posedge wb_clk_i8 or posedge wb_rst_i8)
  begin
    if (wb_rst_i8)
      wb_dat_o8 <= #Tp8 32'b0;
    else
      wb_dat_o8 <= #Tp8 wb_dat8;
  end
  
  // Wb8 acknowledge8
  always @(posedge wb_clk_i8 or posedge wb_rst_i8)
  begin
    if (wb_rst_i8)
      wb_ack_o8 <= #Tp8 1'b0;
    else
      wb_ack_o8 <= #Tp8 wb_cyc_i8 & wb_stb_i8 & ~wb_ack_o8;
  end
  
  // Wb8 error
  assign wb_err_o8 = 1'b0;
  
  // Interrupt8
  always @(posedge wb_clk_i8 or posedge wb_rst_i8)
  begin
    if (wb_rst_i8)
      wb_int_o8 <= #Tp8 1'b0;
    else if (ie8 && tip8 && last_bit8 && pos_edge8)
      wb_int_o8 <= #Tp8 1'b1;
    else if (wb_ack_o8)
      wb_int_o8 <= #Tp8 1'b0;
  end
  
  // Divider8 register
  always @(posedge wb_clk_i8 or posedge wb_rst_i8)
  begin
    if (wb_rst_i8)
        divider8 <= #Tp8 {`SPI_DIVIDER_LEN8{1'b0}};
    else if (spi_divider_sel8 && wb_we_i8 && !tip8)
      begin
      `ifdef SPI_DIVIDER_LEN_88
        if (wb_sel_i8[0])
          divider8 <= #Tp8 wb_dat_i8[`SPI_DIVIDER_LEN8-1:0];
      `endif
      `ifdef SPI_DIVIDER_LEN_168
        if (wb_sel_i8[0])
          divider8[7:0] <= #Tp8 wb_dat_i8[7:0];
        if (wb_sel_i8[1])
          divider8[`SPI_DIVIDER_LEN8-1:8] <= #Tp8 wb_dat_i8[`SPI_DIVIDER_LEN8-1:8];
      `endif
      `ifdef SPI_DIVIDER_LEN_248
        if (wb_sel_i8[0])
          divider8[7:0] <= #Tp8 wb_dat_i8[7:0];
        if (wb_sel_i8[1])
          divider8[15:8] <= #Tp8 wb_dat_i8[15:8];
        if (wb_sel_i8[2])
          divider8[`SPI_DIVIDER_LEN8-1:16] <= #Tp8 wb_dat_i8[`SPI_DIVIDER_LEN8-1:16];
      `endif
      `ifdef SPI_DIVIDER_LEN_328
        if (wb_sel_i8[0])
          divider8[7:0] <= #Tp8 wb_dat_i8[7:0];
        if (wb_sel_i8[1])
          divider8[15:8] <= #Tp8 wb_dat_i8[15:8];
        if (wb_sel_i8[2])
          divider8[23:16] <= #Tp8 wb_dat_i8[23:16];
        if (wb_sel_i8[3])
          divider8[`SPI_DIVIDER_LEN8-1:24] <= #Tp8 wb_dat_i8[`SPI_DIVIDER_LEN8-1:24];
      `endif
      end
  end
  
  // Ctrl8 register
  always @(posedge wb_clk_i8 or posedge wb_rst_i8)
  begin
    if (wb_rst_i8)
      ctrl8 <= #Tp8 {`SPI_CTRL_BIT_NB8{1'b0}};
    else if(spi_ctrl_sel8 && wb_we_i8 && !tip8)
      begin
        if (wb_sel_i8[0])
          ctrl8[7:0] <= #Tp8 wb_dat_i8[7:0] | {7'b0, ctrl8[0]};
        if (wb_sel_i8[1])
          ctrl8[`SPI_CTRL_BIT_NB8-1:8] <= #Tp8 wb_dat_i8[`SPI_CTRL_BIT_NB8-1:8];
      end
    else if(tip8 && last_bit8 && pos_edge8)
      ctrl8[`SPI_CTRL_GO8] <= #Tp8 1'b0;
  end
  
  assign rx_negedge8 = ctrl8[`SPI_CTRL_RX_NEGEDGE8];
  assign tx_negedge8 = ctrl8[`SPI_CTRL_TX_NEGEDGE8];
  assign go8         = ctrl8[`SPI_CTRL_GO8];
  assign char_len8   = ctrl8[`SPI_CTRL_CHAR_LEN8];
  assign lsb        = ctrl8[`SPI_CTRL_LSB8];
  assign ie8         = ctrl8[`SPI_CTRL_IE8];
  assign ass8        = ctrl8[`SPI_CTRL_ASS8];
  
  // Slave8 select8 register
  always @(posedge wb_clk_i8 or posedge wb_rst_i8)
  begin
    if (wb_rst_i8)
      ss <= #Tp8 {`SPI_SS_NB8{1'b0}};
    else if(spi_ss_sel8 && wb_we_i8 && !tip8)
      begin
      `ifdef SPI_SS_NB_88
        if (wb_sel_i8[0])
          ss <= #Tp8 wb_dat_i8[`SPI_SS_NB8-1:0];
      `endif
      `ifdef SPI_SS_NB_168
        if (wb_sel_i8[0])
          ss[7:0] <= #Tp8 wb_dat_i8[7:0];
        if (wb_sel_i8[1])
          ss[`SPI_SS_NB8-1:8] <= #Tp8 wb_dat_i8[`SPI_SS_NB8-1:8];
      `endif
      `ifdef SPI_SS_NB_248
        if (wb_sel_i8[0])
          ss[7:0] <= #Tp8 wb_dat_i8[7:0];
        if (wb_sel_i8[1])
          ss[15:8] <= #Tp8 wb_dat_i8[15:8];
        if (wb_sel_i8[2])
          ss[`SPI_SS_NB8-1:16] <= #Tp8 wb_dat_i8[`SPI_SS_NB8-1:16];
      `endif
      `ifdef SPI_SS_NB_328
        if (wb_sel_i8[0])
          ss[7:0] <= #Tp8 wb_dat_i8[7:0];
        if (wb_sel_i8[1])
          ss[15:8] <= #Tp8 wb_dat_i8[15:8];
        if (wb_sel_i8[2])
          ss[23:16] <= #Tp8 wb_dat_i8[23:16];
        if (wb_sel_i8[3])
          ss[`SPI_SS_NB8-1:24] <= #Tp8 wb_dat_i8[`SPI_SS_NB8-1:24];
      `endif
      end
  end
  
  assign ss_pad_o8 = ~((ss & {`SPI_SS_NB8{tip8 & ass8}}) | (ss & {`SPI_SS_NB8{!ass8}}));
  
  spi_clgen8 clgen8 (.clk_in8(wb_clk_i8), .rst8(wb_rst_i8), .go8(go8), .enable(tip8), .last_clk8(last_bit8),
                   .divider8(divider8), .clk_out8(sclk_pad_o8), .pos_edge8(pos_edge8), 
                   .neg_edge8(neg_edge8));
  
  spi_shift8 shift8 (.clk8(wb_clk_i8), .rst8(wb_rst_i8), .len(char_len8[`SPI_CHAR_LEN_BITS8-1:0]),
                   .latch8(spi_tx_sel8[3:0] & {4{wb_we_i8}}), .byte_sel8(wb_sel_i8), .lsb(lsb), 
                   .go8(go8), .pos_edge8(pos_edge8), .neg_edge8(neg_edge8), 
                   .rx_negedge8(rx_negedge8), .tx_negedge8(tx_negedge8),
                   .tip8(tip8), .last(last_bit8), 
                   .p_in8(wb_dat_i8), .p_out8(rx8), 
                   .s_clk8(sclk_pad_o8), .s_in8(miso_pad_i8), .s_out8(mosi_pad_o8));
endmodule
  
