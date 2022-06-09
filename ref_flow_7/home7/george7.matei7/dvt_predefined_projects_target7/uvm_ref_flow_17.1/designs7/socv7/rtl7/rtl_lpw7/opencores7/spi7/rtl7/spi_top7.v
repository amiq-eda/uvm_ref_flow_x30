//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_top7.v                                                   ////
////                                                              ////
////  This7 file is part of the SPI7 IP7 core7 project7                ////
////  http7://www7.opencores7.org7/projects7/spi7/                      ////
////                                                              ////
////  Author7(s):                                                  ////
////      - Simon7 Srot7 (simons7@opencores7.org7)                     ////
////                                                              ////
////  All additional7 information is avaliable7 in the Readme7.txt7   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright7 (C) 2002 Authors7                                   ////
////                                                              ////
//// This7 source7 file may be used and distributed7 without         ////
//// restriction7 provided that this copyright7 statement7 is not    ////
//// removed from the file and that any derivative7 work7 contains7  ////
//// the original copyright7 notice7 and the associated disclaimer7. ////
////                                                              ////
//// This7 source7 file is free software7; you can redistribute7 it   ////
//// and/or modify it under the terms7 of the GNU7 Lesser7 General7   ////
//// Public7 License7 as published7 by the Free7 Software7 Foundation7; ////
//// either7 version7 2.1 of the License7, or (at your7 option) any   ////
//// later7 version7.                                               ////
////                                                              ////
//// This7 source7 is distributed7 in the hope7 that it will be       ////
//// useful7, but WITHOUT7 ANY7 WARRANTY7; without even7 the implied7   ////
//// warranty7 of MERCHANTABILITY7 or FITNESS7 FOR7 A PARTICULAR7      ////
//// PURPOSE7.  See the GNU7 Lesser7 General7 Public7 License7 for more ////
//// details7.                                                     ////
////                                                              ////
//// You should have received7 a copy of the GNU7 Lesser7 General7    ////
//// Public7 License7 along7 with this source7; if not, download7 it   ////
//// from http7://www7.opencores7.org7/lgpl7.shtml7                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////


`include "spi_defines7.v"
`include "timescale.v"

module spi_top7
(
  // Wishbone7 signals7
  wb_clk_i7, wb_rst_i7, wb_adr_i7, wb_dat_i7, wb_dat_o7, wb_sel_i7,
  wb_we_i7, wb_stb_i7, wb_cyc_i7, wb_ack_o7, wb_err_o7, wb_int_o7,

  // SPI7 signals7
  ss_pad_o7, sclk_pad_o7, mosi_pad_o7, miso_pad_i7
);

  parameter Tp7 = 1;

  // Wishbone7 signals7
  input                            wb_clk_i7;         // master7 clock7 input
  input                            wb_rst_i7;         // synchronous7 active high7 reset
  input                      [4:0] wb_adr_i7;         // lower7 address bits
  input                   [32-1:0] wb_dat_i7;         // databus7 input
  output                  [32-1:0] wb_dat_o7;         // databus7 output
  input                      [3:0] wb_sel_i7;         // byte select7 inputs7
  input                            wb_we_i7;          // write enable input
  input                            wb_stb_i7;         // stobe7/core7 select7 signal7
  input                            wb_cyc_i7;         // valid bus cycle input
  output                           wb_ack_o7;         // bus cycle acknowledge7 output
  output                           wb_err_o7;         // termination w/ error
  output                           wb_int_o7;         // interrupt7 request signal7 output
                                                     
  // SPI7 signals7                                     
  output          [`SPI_SS_NB7-1:0] ss_pad_o7;         // slave7 select7
  output                           sclk_pad_o7;       // serial7 clock7
  output                           mosi_pad_o7;       // master7 out slave7 in
  input                            miso_pad_i7;       // master7 in slave7 out
                                                     
  reg                     [32-1:0] wb_dat_o7;
  reg                              wb_ack_o7;
  reg                              wb_int_o7;
                                               
  // Internal signals7
  reg       [`SPI_DIVIDER_LEN7-1:0] divider7;          // Divider7 register
  reg       [`SPI_CTRL_BIT_NB7-1:0] ctrl7;             // Control7 and status register
  reg             [`SPI_SS_NB7-1:0] ss;               // Slave7 select7 register
  reg                     [32-1:0] wb_dat7;           // wb7 data out
  wire         [`SPI_MAX_CHAR7-1:0] rx7;               // Rx7 register
  wire                             rx_negedge7;       // miso7 is sampled7 on negative edge
  wire                             tx_negedge7;       // mosi7 is driven7 on negative edge
  wire    [`SPI_CHAR_LEN_BITS7-1:0] char_len7;         // char7 len
  wire                             go7;               // go7
  wire                             lsb;              // lsb first on line
  wire                             ie7;               // interrupt7 enable
  wire                             ass7;              // automatic slave7 select7
  wire                             spi_divider_sel7;  // divider7 register select7
  wire                             spi_ctrl_sel7;     // ctrl7 register select7
  wire                       [3:0] spi_tx_sel7;       // tx_l7 register select7
  wire                             spi_ss_sel7;       // ss register select7
  wire                             tip7;              // transfer7 in progress7
  wire                             pos_edge7;         // recognize7 posedge of sclk7
  wire                             neg_edge7;         // recognize7 negedge of sclk7
  wire                             last_bit7;         // marks7 last character7 bit
  
  // Address decoder7
  assign spi_divider_sel7 = wb_cyc_i7 & wb_stb_i7 & (wb_adr_i7[`SPI_OFS_BITS7] == `SPI_DEVIDE7);
  assign spi_ctrl_sel7    = wb_cyc_i7 & wb_stb_i7 & (wb_adr_i7[`SPI_OFS_BITS7] == `SPI_CTRL7);
  assign spi_tx_sel7[0]   = wb_cyc_i7 & wb_stb_i7 & (wb_adr_i7[`SPI_OFS_BITS7] == `SPI_TX_07);
  assign spi_tx_sel7[1]   = wb_cyc_i7 & wb_stb_i7 & (wb_adr_i7[`SPI_OFS_BITS7] == `SPI_TX_17);
  assign spi_tx_sel7[2]   = wb_cyc_i7 & wb_stb_i7 & (wb_adr_i7[`SPI_OFS_BITS7] == `SPI_TX_27);
  assign spi_tx_sel7[3]   = wb_cyc_i7 & wb_stb_i7 & (wb_adr_i7[`SPI_OFS_BITS7] == `SPI_TX_37);
  assign spi_ss_sel7      = wb_cyc_i7 & wb_stb_i7 & (wb_adr_i7[`SPI_OFS_BITS7] == `SPI_SS7);
  
  // Read from registers
  always @(wb_adr_i7 or rx7 or ctrl7 or divider7 or ss)
  begin
    case (wb_adr_i7[`SPI_OFS_BITS7])
`ifdef SPI_MAX_CHAR_1287
      `SPI_RX_07:    wb_dat7 = rx7[31:0];
      `SPI_RX_17:    wb_dat7 = rx7[63:32];
      `SPI_RX_27:    wb_dat7 = rx7[95:64];
      `SPI_RX_37:    wb_dat7 = {{128-`SPI_MAX_CHAR7{1'b0}}, rx7[`SPI_MAX_CHAR7-1:96]};
`else
`ifdef SPI_MAX_CHAR_647
      `SPI_RX_07:    wb_dat7 = rx7[31:0];
      `SPI_RX_17:    wb_dat7 = {{64-`SPI_MAX_CHAR7{1'b0}}, rx7[`SPI_MAX_CHAR7-1:32]};
      `SPI_RX_27:    wb_dat7 = 32'b0;
      `SPI_RX_37:    wb_dat7 = 32'b0;
`else
      `SPI_RX_07:    wb_dat7 = {{32-`SPI_MAX_CHAR7{1'b0}}, rx7[`SPI_MAX_CHAR7-1:0]};
      `SPI_RX_17:    wb_dat7 = 32'b0;
      `SPI_RX_27:    wb_dat7 = 32'b0;
      `SPI_RX_37:    wb_dat7 = 32'b0;
`endif
`endif
      `SPI_CTRL7:    wb_dat7 = {{32-`SPI_CTRL_BIT_NB7{1'b0}}, ctrl7};
      `SPI_DEVIDE7:  wb_dat7 = {{32-`SPI_DIVIDER_LEN7{1'b0}}, divider7};
      `SPI_SS7:      wb_dat7 = {{32-`SPI_SS_NB7{1'b0}}, ss};
      default:      wb_dat7 = 32'bx;
    endcase
  end
  
  // Wb7 data out
  always @(posedge wb_clk_i7 or posedge wb_rst_i7)
  begin
    if (wb_rst_i7)
      wb_dat_o7 <= #Tp7 32'b0;
    else
      wb_dat_o7 <= #Tp7 wb_dat7;
  end
  
  // Wb7 acknowledge7
  always @(posedge wb_clk_i7 or posedge wb_rst_i7)
  begin
    if (wb_rst_i7)
      wb_ack_o7 <= #Tp7 1'b0;
    else
      wb_ack_o7 <= #Tp7 wb_cyc_i7 & wb_stb_i7 & ~wb_ack_o7;
  end
  
  // Wb7 error
  assign wb_err_o7 = 1'b0;
  
  // Interrupt7
  always @(posedge wb_clk_i7 or posedge wb_rst_i7)
  begin
    if (wb_rst_i7)
      wb_int_o7 <= #Tp7 1'b0;
    else if (ie7 && tip7 && last_bit7 && pos_edge7)
      wb_int_o7 <= #Tp7 1'b1;
    else if (wb_ack_o7)
      wb_int_o7 <= #Tp7 1'b0;
  end
  
  // Divider7 register
  always @(posedge wb_clk_i7 or posedge wb_rst_i7)
  begin
    if (wb_rst_i7)
        divider7 <= #Tp7 {`SPI_DIVIDER_LEN7{1'b0}};
    else if (spi_divider_sel7 && wb_we_i7 && !tip7)
      begin
      `ifdef SPI_DIVIDER_LEN_87
        if (wb_sel_i7[0])
          divider7 <= #Tp7 wb_dat_i7[`SPI_DIVIDER_LEN7-1:0];
      `endif
      `ifdef SPI_DIVIDER_LEN_167
        if (wb_sel_i7[0])
          divider7[7:0] <= #Tp7 wb_dat_i7[7:0];
        if (wb_sel_i7[1])
          divider7[`SPI_DIVIDER_LEN7-1:8] <= #Tp7 wb_dat_i7[`SPI_DIVIDER_LEN7-1:8];
      `endif
      `ifdef SPI_DIVIDER_LEN_247
        if (wb_sel_i7[0])
          divider7[7:0] <= #Tp7 wb_dat_i7[7:0];
        if (wb_sel_i7[1])
          divider7[15:8] <= #Tp7 wb_dat_i7[15:8];
        if (wb_sel_i7[2])
          divider7[`SPI_DIVIDER_LEN7-1:16] <= #Tp7 wb_dat_i7[`SPI_DIVIDER_LEN7-1:16];
      `endif
      `ifdef SPI_DIVIDER_LEN_327
        if (wb_sel_i7[0])
          divider7[7:0] <= #Tp7 wb_dat_i7[7:0];
        if (wb_sel_i7[1])
          divider7[15:8] <= #Tp7 wb_dat_i7[15:8];
        if (wb_sel_i7[2])
          divider7[23:16] <= #Tp7 wb_dat_i7[23:16];
        if (wb_sel_i7[3])
          divider7[`SPI_DIVIDER_LEN7-1:24] <= #Tp7 wb_dat_i7[`SPI_DIVIDER_LEN7-1:24];
      `endif
      end
  end
  
  // Ctrl7 register
  always @(posedge wb_clk_i7 or posedge wb_rst_i7)
  begin
    if (wb_rst_i7)
      ctrl7 <= #Tp7 {`SPI_CTRL_BIT_NB7{1'b0}};
    else if(spi_ctrl_sel7 && wb_we_i7 && !tip7)
      begin
        if (wb_sel_i7[0])
          ctrl7[7:0] <= #Tp7 wb_dat_i7[7:0] | {7'b0, ctrl7[0]};
        if (wb_sel_i7[1])
          ctrl7[`SPI_CTRL_BIT_NB7-1:8] <= #Tp7 wb_dat_i7[`SPI_CTRL_BIT_NB7-1:8];
      end
    else if(tip7 && last_bit7 && pos_edge7)
      ctrl7[`SPI_CTRL_GO7] <= #Tp7 1'b0;
  end
  
  assign rx_negedge7 = ctrl7[`SPI_CTRL_RX_NEGEDGE7];
  assign tx_negedge7 = ctrl7[`SPI_CTRL_TX_NEGEDGE7];
  assign go7         = ctrl7[`SPI_CTRL_GO7];
  assign char_len7   = ctrl7[`SPI_CTRL_CHAR_LEN7];
  assign lsb        = ctrl7[`SPI_CTRL_LSB7];
  assign ie7         = ctrl7[`SPI_CTRL_IE7];
  assign ass7        = ctrl7[`SPI_CTRL_ASS7];
  
  // Slave7 select7 register
  always @(posedge wb_clk_i7 or posedge wb_rst_i7)
  begin
    if (wb_rst_i7)
      ss <= #Tp7 {`SPI_SS_NB7{1'b0}};
    else if(spi_ss_sel7 && wb_we_i7 && !tip7)
      begin
      `ifdef SPI_SS_NB_87
        if (wb_sel_i7[0])
          ss <= #Tp7 wb_dat_i7[`SPI_SS_NB7-1:0];
      `endif
      `ifdef SPI_SS_NB_167
        if (wb_sel_i7[0])
          ss[7:0] <= #Tp7 wb_dat_i7[7:0];
        if (wb_sel_i7[1])
          ss[`SPI_SS_NB7-1:8] <= #Tp7 wb_dat_i7[`SPI_SS_NB7-1:8];
      `endif
      `ifdef SPI_SS_NB_247
        if (wb_sel_i7[0])
          ss[7:0] <= #Tp7 wb_dat_i7[7:0];
        if (wb_sel_i7[1])
          ss[15:8] <= #Tp7 wb_dat_i7[15:8];
        if (wb_sel_i7[2])
          ss[`SPI_SS_NB7-1:16] <= #Tp7 wb_dat_i7[`SPI_SS_NB7-1:16];
      `endif
      `ifdef SPI_SS_NB_327
        if (wb_sel_i7[0])
          ss[7:0] <= #Tp7 wb_dat_i7[7:0];
        if (wb_sel_i7[1])
          ss[15:8] <= #Tp7 wb_dat_i7[15:8];
        if (wb_sel_i7[2])
          ss[23:16] <= #Tp7 wb_dat_i7[23:16];
        if (wb_sel_i7[3])
          ss[`SPI_SS_NB7-1:24] <= #Tp7 wb_dat_i7[`SPI_SS_NB7-1:24];
      `endif
      end
  end
  
  assign ss_pad_o7 = ~((ss & {`SPI_SS_NB7{tip7 & ass7}}) | (ss & {`SPI_SS_NB7{!ass7}}));
  
  spi_clgen7 clgen7 (.clk_in7(wb_clk_i7), .rst7(wb_rst_i7), .go7(go7), .enable(tip7), .last_clk7(last_bit7),
                   .divider7(divider7), .clk_out7(sclk_pad_o7), .pos_edge7(pos_edge7), 
                   .neg_edge7(neg_edge7));
  
  spi_shift7 shift7 (.clk7(wb_clk_i7), .rst7(wb_rst_i7), .len(char_len7[`SPI_CHAR_LEN_BITS7-1:0]),
                   .latch7(spi_tx_sel7[3:0] & {4{wb_we_i7}}), .byte_sel7(wb_sel_i7), .lsb(lsb), 
                   .go7(go7), .pos_edge7(pos_edge7), .neg_edge7(neg_edge7), 
                   .rx_negedge7(rx_negedge7), .tx_negedge7(tx_negedge7),
                   .tip7(tip7), .last(last_bit7), 
                   .p_in7(wb_dat_i7), .p_out7(rx7), 
                   .s_clk7(sclk_pad_o7), .s_in7(miso_pad_i7), .s_out7(mosi_pad_o7));
endmodule
  
