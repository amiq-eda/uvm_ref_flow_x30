//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_top25.v                                                   ////
////                                                              ////
////  This25 file is part of the SPI25 IP25 core25 project25                ////
////  http25://www25.opencores25.org25/projects25/spi25/                      ////
////                                                              ////
////  Author25(s):                                                  ////
////      - Simon25 Srot25 (simons25@opencores25.org25)                     ////
////                                                              ////
////  All additional25 information is avaliable25 in the Readme25.txt25   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright25 (C) 2002 Authors25                                   ////
////                                                              ////
//// This25 source25 file may be used and distributed25 without         ////
//// restriction25 provided that this copyright25 statement25 is not    ////
//// removed from the file and that any derivative25 work25 contains25  ////
//// the original copyright25 notice25 and the associated disclaimer25. ////
////                                                              ////
//// This25 source25 file is free software25; you can redistribute25 it   ////
//// and/or modify it under the terms25 of the GNU25 Lesser25 General25   ////
//// Public25 License25 as published25 by the Free25 Software25 Foundation25; ////
//// either25 version25 2.1 of the License25, or (at your25 option) any   ////
//// later25 version25.                                               ////
////                                                              ////
//// This25 source25 is distributed25 in the hope25 that it will be       ////
//// useful25, but WITHOUT25 ANY25 WARRANTY25; without even25 the implied25   ////
//// warranty25 of MERCHANTABILITY25 or FITNESS25 FOR25 A PARTICULAR25      ////
//// PURPOSE25.  See the GNU25 Lesser25 General25 Public25 License25 for more ////
//// details25.                                                     ////
////                                                              ////
//// You should have received25 a copy of the GNU25 Lesser25 General25    ////
//// Public25 License25 along25 with this source25; if not, download25 it   ////
//// from http25://www25.opencores25.org25/lgpl25.shtml25                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////


`include "spi_defines25.v"
`include "timescale.v"

module spi_top25
(
  // Wishbone25 signals25
  wb_clk_i25, wb_rst_i25, wb_adr_i25, wb_dat_i25, wb_dat_o25, wb_sel_i25,
  wb_we_i25, wb_stb_i25, wb_cyc_i25, wb_ack_o25, wb_err_o25, wb_int_o25,

  // SPI25 signals25
  ss_pad_o25, sclk_pad_o25, mosi_pad_o25, miso_pad_i25
);

  parameter Tp25 = 1;

  // Wishbone25 signals25
  input                            wb_clk_i25;         // master25 clock25 input
  input                            wb_rst_i25;         // synchronous25 active high25 reset
  input                      [4:0] wb_adr_i25;         // lower25 address bits
  input                   [32-1:0] wb_dat_i25;         // databus25 input
  output                  [32-1:0] wb_dat_o25;         // databus25 output
  input                      [3:0] wb_sel_i25;         // byte select25 inputs25
  input                            wb_we_i25;          // write enable input
  input                            wb_stb_i25;         // stobe25/core25 select25 signal25
  input                            wb_cyc_i25;         // valid bus cycle input
  output                           wb_ack_o25;         // bus cycle acknowledge25 output
  output                           wb_err_o25;         // termination w/ error
  output                           wb_int_o25;         // interrupt25 request signal25 output
                                                     
  // SPI25 signals25                                     
  output          [`SPI_SS_NB25-1:0] ss_pad_o25;         // slave25 select25
  output                           sclk_pad_o25;       // serial25 clock25
  output                           mosi_pad_o25;       // master25 out slave25 in
  input                            miso_pad_i25;       // master25 in slave25 out
                                                     
  reg                     [32-1:0] wb_dat_o25;
  reg                              wb_ack_o25;
  reg                              wb_int_o25;
                                               
  // Internal signals25
  reg       [`SPI_DIVIDER_LEN25-1:0] divider25;          // Divider25 register
  reg       [`SPI_CTRL_BIT_NB25-1:0] ctrl25;             // Control25 and status register
  reg             [`SPI_SS_NB25-1:0] ss;               // Slave25 select25 register
  reg                     [32-1:0] wb_dat25;           // wb25 data out
  wire         [`SPI_MAX_CHAR25-1:0] rx25;               // Rx25 register
  wire                             rx_negedge25;       // miso25 is sampled25 on negative edge
  wire                             tx_negedge25;       // mosi25 is driven25 on negative edge
  wire    [`SPI_CHAR_LEN_BITS25-1:0] char_len25;         // char25 len
  wire                             go25;               // go25
  wire                             lsb;              // lsb first on line
  wire                             ie25;               // interrupt25 enable
  wire                             ass25;              // automatic slave25 select25
  wire                             spi_divider_sel25;  // divider25 register select25
  wire                             spi_ctrl_sel25;     // ctrl25 register select25
  wire                       [3:0] spi_tx_sel25;       // tx_l25 register select25
  wire                             spi_ss_sel25;       // ss register select25
  wire                             tip25;              // transfer25 in progress25
  wire                             pos_edge25;         // recognize25 posedge of sclk25
  wire                             neg_edge25;         // recognize25 negedge of sclk25
  wire                             last_bit25;         // marks25 last character25 bit
  
  // Address decoder25
  assign spi_divider_sel25 = wb_cyc_i25 & wb_stb_i25 & (wb_adr_i25[`SPI_OFS_BITS25] == `SPI_DEVIDE25);
  assign spi_ctrl_sel25    = wb_cyc_i25 & wb_stb_i25 & (wb_adr_i25[`SPI_OFS_BITS25] == `SPI_CTRL25);
  assign spi_tx_sel25[0]   = wb_cyc_i25 & wb_stb_i25 & (wb_adr_i25[`SPI_OFS_BITS25] == `SPI_TX_025);
  assign spi_tx_sel25[1]   = wb_cyc_i25 & wb_stb_i25 & (wb_adr_i25[`SPI_OFS_BITS25] == `SPI_TX_125);
  assign spi_tx_sel25[2]   = wb_cyc_i25 & wb_stb_i25 & (wb_adr_i25[`SPI_OFS_BITS25] == `SPI_TX_225);
  assign spi_tx_sel25[3]   = wb_cyc_i25 & wb_stb_i25 & (wb_adr_i25[`SPI_OFS_BITS25] == `SPI_TX_325);
  assign spi_ss_sel25      = wb_cyc_i25 & wb_stb_i25 & (wb_adr_i25[`SPI_OFS_BITS25] == `SPI_SS25);
  
  // Read from registers
  always @(wb_adr_i25 or rx25 or ctrl25 or divider25 or ss)
  begin
    case (wb_adr_i25[`SPI_OFS_BITS25])
`ifdef SPI_MAX_CHAR_12825
      `SPI_RX_025:    wb_dat25 = rx25[31:0];
      `SPI_RX_125:    wb_dat25 = rx25[63:32];
      `SPI_RX_225:    wb_dat25 = rx25[95:64];
      `SPI_RX_325:    wb_dat25 = {{128-`SPI_MAX_CHAR25{1'b0}}, rx25[`SPI_MAX_CHAR25-1:96]};
`else
`ifdef SPI_MAX_CHAR_6425
      `SPI_RX_025:    wb_dat25 = rx25[31:0];
      `SPI_RX_125:    wb_dat25 = {{64-`SPI_MAX_CHAR25{1'b0}}, rx25[`SPI_MAX_CHAR25-1:32]};
      `SPI_RX_225:    wb_dat25 = 32'b0;
      `SPI_RX_325:    wb_dat25 = 32'b0;
`else
      `SPI_RX_025:    wb_dat25 = {{32-`SPI_MAX_CHAR25{1'b0}}, rx25[`SPI_MAX_CHAR25-1:0]};
      `SPI_RX_125:    wb_dat25 = 32'b0;
      `SPI_RX_225:    wb_dat25 = 32'b0;
      `SPI_RX_325:    wb_dat25 = 32'b0;
`endif
`endif
      `SPI_CTRL25:    wb_dat25 = {{32-`SPI_CTRL_BIT_NB25{1'b0}}, ctrl25};
      `SPI_DEVIDE25:  wb_dat25 = {{32-`SPI_DIVIDER_LEN25{1'b0}}, divider25};
      `SPI_SS25:      wb_dat25 = {{32-`SPI_SS_NB25{1'b0}}, ss};
      default:      wb_dat25 = 32'bx;
    endcase
  end
  
  // Wb25 data out
  always @(posedge wb_clk_i25 or posedge wb_rst_i25)
  begin
    if (wb_rst_i25)
      wb_dat_o25 <= #Tp25 32'b0;
    else
      wb_dat_o25 <= #Tp25 wb_dat25;
  end
  
  // Wb25 acknowledge25
  always @(posedge wb_clk_i25 or posedge wb_rst_i25)
  begin
    if (wb_rst_i25)
      wb_ack_o25 <= #Tp25 1'b0;
    else
      wb_ack_o25 <= #Tp25 wb_cyc_i25 & wb_stb_i25 & ~wb_ack_o25;
  end
  
  // Wb25 error
  assign wb_err_o25 = 1'b0;
  
  // Interrupt25
  always @(posedge wb_clk_i25 or posedge wb_rst_i25)
  begin
    if (wb_rst_i25)
      wb_int_o25 <= #Tp25 1'b0;
    else if (ie25 && tip25 && last_bit25 && pos_edge25)
      wb_int_o25 <= #Tp25 1'b1;
    else if (wb_ack_o25)
      wb_int_o25 <= #Tp25 1'b0;
  end
  
  // Divider25 register
  always @(posedge wb_clk_i25 or posedge wb_rst_i25)
  begin
    if (wb_rst_i25)
        divider25 <= #Tp25 {`SPI_DIVIDER_LEN25{1'b0}};
    else if (spi_divider_sel25 && wb_we_i25 && !tip25)
      begin
      `ifdef SPI_DIVIDER_LEN_825
        if (wb_sel_i25[0])
          divider25 <= #Tp25 wb_dat_i25[`SPI_DIVIDER_LEN25-1:0];
      `endif
      `ifdef SPI_DIVIDER_LEN_1625
        if (wb_sel_i25[0])
          divider25[7:0] <= #Tp25 wb_dat_i25[7:0];
        if (wb_sel_i25[1])
          divider25[`SPI_DIVIDER_LEN25-1:8] <= #Tp25 wb_dat_i25[`SPI_DIVIDER_LEN25-1:8];
      `endif
      `ifdef SPI_DIVIDER_LEN_2425
        if (wb_sel_i25[0])
          divider25[7:0] <= #Tp25 wb_dat_i25[7:0];
        if (wb_sel_i25[1])
          divider25[15:8] <= #Tp25 wb_dat_i25[15:8];
        if (wb_sel_i25[2])
          divider25[`SPI_DIVIDER_LEN25-1:16] <= #Tp25 wb_dat_i25[`SPI_DIVIDER_LEN25-1:16];
      `endif
      `ifdef SPI_DIVIDER_LEN_3225
        if (wb_sel_i25[0])
          divider25[7:0] <= #Tp25 wb_dat_i25[7:0];
        if (wb_sel_i25[1])
          divider25[15:8] <= #Tp25 wb_dat_i25[15:8];
        if (wb_sel_i25[2])
          divider25[23:16] <= #Tp25 wb_dat_i25[23:16];
        if (wb_sel_i25[3])
          divider25[`SPI_DIVIDER_LEN25-1:24] <= #Tp25 wb_dat_i25[`SPI_DIVIDER_LEN25-1:24];
      `endif
      end
  end
  
  // Ctrl25 register
  always @(posedge wb_clk_i25 or posedge wb_rst_i25)
  begin
    if (wb_rst_i25)
      ctrl25 <= #Tp25 {`SPI_CTRL_BIT_NB25{1'b0}};
    else if(spi_ctrl_sel25 && wb_we_i25 && !tip25)
      begin
        if (wb_sel_i25[0])
          ctrl25[7:0] <= #Tp25 wb_dat_i25[7:0] | {7'b0, ctrl25[0]};
        if (wb_sel_i25[1])
          ctrl25[`SPI_CTRL_BIT_NB25-1:8] <= #Tp25 wb_dat_i25[`SPI_CTRL_BIT_NB25-1:8];
      end
    else if(tip25 && last_bit25 && pos_edge25)
      ctrl25[`SPI_CTRL_GO25] <= #Tp25 1'b0;
  end
  
  assign rx_negedge25 = ctrl25[`SPI_CTRL_RX_NEGEDGE25];
  assign tx_negedge25 = ctrl25[`SPI_CTRL_TX_NEGEDGE25];
  assign go25         = ctrl25[`SPI_CTRL_GO25];
  assign char_len25   = ctrl25[`SPI_CTRL_CHAR_LEN25];
  assign lsb        = ctrl25[`SPI_CTRL_LSB25];
  assign ie25         = ctrl25[`SPI_CTRL_IE25];
  assign ass25        = ctrl25[`SPI_CTRL_ASS25];
  
  // Slave25 select25 register
  always @(posedge wb_clk_i25 or posedge wb_rst_i25)
  begin
    if (wb_rst_i25)
      ss <= #Tp25 {`SPI_SS_NB25{1'b0}};
    else if(spi_ss_sel25 && wb_we_i25 && !tip25)
      begin
      `ifdef SPI_SS_NB_825
        if (wb_sel_i25[0])
          ss <= #Tp25 wb_dat_i25[`SPI_SS_NB25-1:0];
      `endif
      `ifdef SPI_SS_NB_1625
        if (wb_sel_i25[0])
          ss[7:0] <= #Tp25 wb_dat_i25[7:0];
        if (wb_sel_i25[1])
          ss[`SPI_SS_NB25-1:8] <= #Tp25 wb_dat_i25[`SPI_SS_NB25-1:8];
      `endif
      `ifdef SPI_SS_NB_2425
        if (wb_sel_i25[0])
          ss[7:0] <= #Tp25 wb_dat_i25[7:0];
        if (wb_sel_i25[1])
          ss[15:8] <= #Tp25 wb_dat_i25[15:8];
        if (wb_sel_i25[2])
          ss[`SPI_SS_NB25-1:16] <= #Tp25 wb_dat_i25[`SPI_SS_NB25-1:16];
      `endif
      `ifdef SPI_SS_NB_3225
        if (wb_sel_i25[0])
          ss[7:0] <= #Tp25 wb_dat_i25[7:0];
        if (wb_sel_i25[1])
          ss[15:8] <= #Tp25 wb_dat_i25[15:8];
        if (wb_sel_i25[2])
          ss[23:16] <= #Tp25 wb_dat_i25[23:16];
        if (wb_sel_i25[3])
          ss[`SPI_SS_NB25-1:24] <= #Tp25 wb_dat_i25[`SPI_SS_NB25-1:24];
      `endif
      end
  end
  
  assign ss_pad_o25 = ~((ss & {`SPI_SS_NB25{tip25 & ass25}}) | (ss & {`SPI_SS_NB25{!ass25}}));
  
  spi_clgen25 clgen25 (.clk_in25(wb_clk_i25), .rst25(wb_rst_i25), .go25(go25), .enable(tip25), .last_clk25(last_bit25),
                   .divider25(divider25), .clk_out25(sclk_pad_o25), .pos_edge25(pos_edge25), 
                   .neg_edge25(neg_edge25));
  
  spi_shift25 shift25 (.clk25(wb_clk_i25), .rst25(wb_rst_i25), .len(char_len25[`SPI_CHAR_LEN_BITS25-1:0]),
                   .latch25(spi_tx_sel25[3:0] & {4{wb_we_i25}}), .byte_sel25(wb_sel_i25), .lsb(lsb), 
                   .go25(go25), .pos_edge25(pos_edge25), .neg_edge25(neg_edge25), 
                   .rx_negedge25(rx_negedge25), .tx_negedge25(tx_negedge25),
                   .tip25(tip25), .last(last_bit25), 
                   .p_in25(wb_dat_i25), .p_out25(rx25), 
                   .s_clk25(sclk_pad_o25), .s_in25(miso_pad_i25), .s_out25(mosi_pad_o25));
endmodule
  
