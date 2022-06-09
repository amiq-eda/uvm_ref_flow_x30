//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_top20.v                                                   ////
////                                                              ////
////  This20 file is part of the SPI20 IP20 core20 project20                ////
////  http20://www20.opencores20.org20/projects20/spi20/                      ////
////                                                              ////
////  Author20(s):                                                  ////
////      - Simon20 Srot20 (simons20@opencores20.org20)                     ////
////                                                              ////
////  All additional20 information is avaliable20 in the Readme20.txt20   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright20 (C) 2002 Authors20                                   ////
////                                                              ////
//// This20 source20 file may be used and distributed20 without         ////
//// restriction20 provided that this copyright20 statement20 is not    ////
//// removed from the file and that any derivative20 work20 contains20  ////
//// the original copyright20 notice20 and the associated disclaimer20. ////
////                                                              ////
//// This20 source20 file is free software20; you can redistribute20 it   ////
//// and/or modify it under the terms20 of the GNU20 Lesser20 General20   ////
//// Public20 License20 as published20 by the Free20 Software20 Foundation20; ////
//// either20 version20 2.1 of the License20, or (at your20 option) any   ////
//// later20 version20.                                               ////
////                                                              ////
//// This20 source20 is distributed20 in the hope20 that it will be       ////
//// useful20, but WITHOUT20 ANY20 WARRANTY20; without even20 the implied20   ////
//// warranty20 of MERCHANTABILITY20 or FITNESS20 FOR20 A PARTICULAR20      ////
//// PURPOSE20.  See the GNU20 Lesser20 General20 Public20 License20 for more ////
//// details20.                                                     ////
////                                                              ////
//// You should have received20 a copy of the GNU20 Lesser20 General20    ////
//// Public20 License20 along20 with this source20; if not, download20 it   ////
//// from http20://www20.opencores20.org20/lgpl20.shtml20                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////


`include "spi_defines20.v"
`include "timescale.v"

module spi_top20
(
  // Wishbone20 signals20
  wb_clk_i20, wb_rst_i20, wb_adr_i20, wb_dat_i20, wb_dat_o20, wb_sel_i20,
  wb_we_i20, wb_stb_i20, wb_cyc_i20, wb_ack_o20, wb_err_o20, wb_int_o20,

  // SPI20 signals20
  ss_pad_o20, sclk_pad_o20, mosi_pad_o20, miso_pad_i20
);

  parameter Tp20 = 1;

  // Wishbone20 signals20
  input                            wb_clk_i20;         // master20 clock20 input
  input                            wb_rst_i20;         // synchronous20 active high20 reset
  input                      [4:0] wb_adr_i20;         // lower20 address bits
  input                   [32-1:0] wb_dat_i20;         // databus20 input
  output                  [32-1:0] wb_dat_o20;         // databus20 output
  input                      [3:0] wb_sel_i20;         // byte select20 inputs20
  input                            wb_we_i20;          // write enable input
  input                            wb_stb_i20;         // stobe20/core20 select20 signal20
  input                            wb_cyc_i20;         // valid bus cycle input
  output                           wb_ack_o20;         // bus cycle acknowledge20 output
  output                           wb_err_o20;         // termination w/ error
  output                           wb_int_o20;         // interrupt20 request signal20 output
                                                     
  // SPI20 signals20                                     
  output          [`SPI_SS_NB20-1:0] ss_pad_o20;         // slave20 select20
  output                           sclk_pad_o20;       // serial20 clock20
  output                           mosi_pad_o20;       // master20 out slave20 in
  input                            miso_pad_i20;       // master20 in slave20 out
                                                     
  reg                     [32-1:0] wb_dat_o20;
  reg                              wb_ack_o20;
  reg                              wb_int_o20;
                                               
  // Internal signals20
  reg       [`SPI_DIVIDER_LEN20-1:0] divider20;          // Divider20 register
  reg       [`SPI_CTRL_BIT_NB20-1:0] ctrl20;             // Control20 and status register
  reg             [`SPI_SS_NB20-1:0] ss;               // Slave20 select20 register
  reg                     [32-1:0] wb_dat20;           // wb20 data out
  wire         [`SPI_MAX_CHAR20-1:0] rx20;               // Rx20 register
  wire                             rx_negedge20;       // miso20 is sampled20 on negative edge
  wire                             tx_negedge20;       // mosi20 is driven20 on negative edge
  wire    [`SPI_CHAR_LEN_BITS20-1:0] char_len20;         // char20 len
  wire                             go20;               // go20
  wire                             lsb;              // lsb first on line
  wire                             ie20;               // interrupt20 enable
  wire                             ass20;              // automatic slave20 select20
  wire                             spi_divider_sel20;  // divider20 register select20
  wire                             spi_ctrl_sel20;     // ctrl20 register select20
  wire                       [3:0] spi_tx_sel20;       // tx_l20 register select20
  wire                             spi_ss_sel20;       // ss register select20
  wire                             tip20;              // transfer20 in progress20
  wire                             pos_edge20;         // recognize20 posedge of sclk20
  wire                             neg_edge20;         // recognize20 negedge of sclk20
  wire                             last_bit20;         // marks20 last character20 bit
  
  // Address decoder20
  assign spi_divider_sel20 = wb_cyc_i20 & wb_stb_i20 & (wb_adr_i20[`SPI_OFS_BITS20] == `SPI_DEVIDE20);
  assign spi_ctrl_sel20    = wb_cyc_i20 & wb_stb_i20 & (wb_adr_i20[`SPI_OFS_BITS20] == `SPI_CTRL20);
  assign spi_tx_sel20[0]   = wb_cyc_i20 & wb_stb_i20 & (wb_adr_i20[`SPI_OFS_BITS20] == `SPI_TX_020);
  assign spi_tx_sel20[1]   = wb_cyc_i20 & wb_stb_i20 & (wb_adr_i20[`SPI_OFS_BITS20] == `SPI_TX_120);
  assign spi_tx_sel20[2]   = wb_cyc_i20 & wb_stb_i20 & (wb_adr_i20[`SPI_OFS_BITS20] == `SPI_TX_220);
  assign spi_tx_sel20[3]   = wb_cyc_i20 & wb_stb_i20 & (wb_adr_i20[`SPI_OFS_BITS20] == `SPI_TX_320);
  assign spi_ss_sel20      = wb_cyc_i20 & wb_stb_i20 & (wb_adr_i20[`SPI_OFS_BITS20] == `SPI_SS20);
  
  // Read from registers
  always @(wb_adr_i20 or rx20 or ctrl20 or divider20 or ss)
  begin
    case (wb_adr_i20[`SPI_OFS_BITS20])
`ifdef SPI_MAX_CHAR_12820
      `SPI_RX_020:    wb_dat20 = rx20[31:0];
      `SPI_RX_120:    wb_dat20 = rx20[63:32];
      `SPI_RX_220:    wb_dat20 = rx20[95:64];
      `SPI_RX_320:    wb_dat20 = {{128-`SPI_MAX_CHAR20{1'b0}}, rx20[`SPI_MAX_CHAR20-1:96]};
`else
`ifdef SPI_MAX_CHAR_6420
      `SPI_RX_020:    wb_dat20 = rx20[31:0];
      `SPI_RX_120:    wb_dat20 = {{64-`SPI_MAX_CHAR20{1'b0}}, rx20[`SPI_MAX_CHAR20-1:32]};
      `SPI_RX_220:    wb_dat20 = 32'b0;
      `SPI_RX_320:    wb_dat20 = 32'b0;
`else
      `SPI_RX_020:    wb_dat20 = {{32-`SPI_MAX_CHAR20{1'b0}}, rx20[`SPI_MAX_CHAR20-1:0]};
      `SPI_RX_120:    wb_dat20 = 32'b0;
      `SPI_RX_220:    wb_dat20 = 32'b0;
      `SPI_RX_320:    wb_dat20 = 32'b0;
`endif
`endif
      `SPI_CTRL20:    wb_dat20 = {{32-`SPI_CTRL_BIT_NB20{1'b0}}, ctrl20};
      `SPI_DEVIDE20:  wb_dat20 = {{32-`SPI_DIVIDER_LEN20{1'b0}}, divider20};
      `SPI_SS20:      wb_dat20 = {{32-`SPI_SS_NB20{1'b0}}, ss};
      default:      wb_dat20 = 32'bx;
    endcase
  end
  
  // Wb20 data out
  always @(posedge wb_clk_i20 or posedge wb_rst_i20)
  begin
    if (wb_rst_i20)
      wb_dat_o20 <= #Tp20 32'b0;
    else
      wb_dat_o20 <= #Tp20 wb_dat20;
  end
  
  // Wb20 acknowledge20
  always @(posedge wb_clk_i20 or posedge wb_rst_i20)
  begin
    if (wb_rst_i20)
      wb_ack_o20 <= #Tp20 1'b0;
    else
      wb_ack_o20 <= #Tp20 wb_cyc_i20 & wb_stb_i20 & ~wb_ack_o20;
  end
  
  // Wb20 error
  assign wb_err_o20 = 1'b0;
  
  // Interrupt20
  always @(posedge wb_clk_i20 or posedge wb_rst_i20)
  begin
    if (wb_rst_i20)
      wb_int_o20 <= #Tp20 1'b0;
    else if (ie20 && tip20 && last_bit20 && pos_edge20)
      wb_int_o20 <= #Tp20 1'b1;
    else if (wb_ack_o20)
      wb_int_o20 <= #Tp20 1'b0;
  end
  
  // Divider20 register
  always @(posedge wb_clk_i20 or posedge wb_rst_i20)
  begin
    if (wb_rst_i20)
        divider20 <= #Tp20 {`SPI_DIVIDER_LEN20{1'b0}};
    else if (spi_divider_sel20 && wb_we_i20 && !tip20)
      begin
      `ifdef SPI_DIVIDER_LEN_820
        if (wb_sel_i20[0])
          divider20 <= #Tp20 wb_dat_i20[`SPI_DIVIDER_LEN20-1:0];
      `endif
      `ifdef SPI_DIVIDER_LEN_1620
        if (wb_sel_i20[0])
          divider20[7:0] <= #Tp20 wb_dat_i20[7:0];
        if (wb_sel_i20[1])
          divider20[`SPI_DIVIDER_LEN20-1:8] <= #Tp20 wb_dat_i20[`SPI_DIVIDER_LEN20-1:8];
      `endif
      `ifdef SPI_DIVIDER_LEN_2420
        if (wb_sel_i20[0])
          divider20[7:0] <= #Tp20 wb_dat_i20[7:0];
        if (wb_sel_i20[1])
          divider20[15:8] <= #Tp20 wb_dat_i20[15:8];
        if (wb_sel_i20[2])
          divider20[`SPI_DIVIDER_LEN20-1:16] <= #Tp20 wb_dat_i20[`SPI_DIVIDER_LEN20-1:16];
      `endif
      `ifdef SPI_DIVIDER_LEN_3220
        if (wb_sel_i20[0])
          divider20[7:0] <= #Tp20 wb_dat_i20[7:0];
        if (wb_sel_i20[1])
          divider20[15:8] <= #Tp20 wb_dat_i20[15:8];
        if (wb_sel_i20[2])
          divider20[23:16] <= #Tp20 wb_dat_i20[23:16];
        if (wb_sel_i20[3])
          divider20[`SPI_DIVIDER_LEN20-1:24] <= #Tp20 wb_dat_i20[`SPI_DIVIDER_LEN20-1:24];
      `endif
      end
  end
  
  // Ctrl20 register
  always @(posedge wb_clk_i20 or posedge wb_rst_i20)
  begin
    if (wb_rst_i20)
      ctrl20 <= #Tp20 {`SPI_CTRL_BIT_NB20{1'b0}};
    else if(spi_ctrl_sel20 && wb_we_i20 && !tip20)
      begin
        if (wb_sel_i20[0])
          ctrl20[7:0] <= #Tp20 wb_dat_i20[7:0] | {7'b0, ctrl20[0]};
        if (wb_sel_i20[1])
          ctrl20[`SPI_CTRL_BIT_NB20-1:8] <= #Tp20 wb_dat_i20[`SPI_CTRL_BIT_NB20-1:8];
      end
    else if(tip20 && last_bit20 && pos_edge20)
      ctrl20[`SPI_CTRL_GO20] <= #Tp20 1'b0;
  end
  
  assign rx_negedge20 = ctrl20[`SPI_CTRL_RX_NEGEDGE20];
  assign tx_negedge20 = ctrl20[`SPI_CTRL_TX_NEGEDGE20];
  assign go20         = ctrl20[`SPI_CTRL_GO20];
  assign char_len20   = ctrl20[`SPI_CTRL_CHAR_LEN20];
  assign lsb        = ctrl20[`SPI_CTRL_LSB20];
  assign ie20         = ctrl20[`SPI_CTRL_IE20];
  assign ass20        = ctrl20[`SPI_CTRL_ASS20];
  
  // Slave20 select20 register
  always @(posedge wb_clk_i20 or posedge wb_rst_i20)
  begin
    if (wb_rst_i20)
      ss <= #Tp20 {`SPI_SS_NB20{1'b0}};
    else if(spi_ss_sel20 && wb_we_i20 && !tip20)
      begin
      `ifdef SPI_SS_NB_820
        if (wb_sel_i20[0])
          ss <= #Tp20 wb_dat_i20[`SPI_SS_NB20-1:0];
      `endif
      `ifdef SPI_SS_NB_1620
        if (wb_sel_i20[0])
          ss[7:0] <= #Tp20 wb_dat_i20[7:0];
        if (wb_sel_i20[1])
          ss[`SPI_SS_NB20-1:8] <= #Tp20 wb_dat_i20[`SPI_SS_NB20-1:8];
      `endif
      `ifdef SPI_SS_NB_2420
        if (wb_sel_i20[0])
          ss[7:0] <= #Tp20 wb_dat_i20[7:0];
        if (wb_sel_i20[1])
          ss[15:8] <= #Tp20 wb_dat_i20[15:8];
        if (wb_sel_i20[2])
          ss[`SPI_SS_NB20-1:16] <= #Tp20 wb_dat_i20[`SPI_SS_NB20-1:16];
      `endif
      `ifdef SPI_SS_NB_3220
        if (wb_sel_i20[0])
          ss[7:0] <= #Tp20 wb_dat_i20[7:0];
        if (wb_sel_i20[1])
          ss[15:8] <= #Tp20 wb_dat_i20[15:8];
        if (wb_sel_i20[2])
          ss[23:16] <= #Tp20 wb_dat_i20[23:16];
        if (wb_sel_i20[3])
          ss[`SPI_SS_NB20-1:24] <= #Tp20 wb_dat_i20[`SPI_SS_NB20-1:24];
      `endif
      end
  end
  
  assign ss_pad_o20 = ~((ss & {`SPI_SS_NB20{tip20 & ass20}}) | (ss & {`SPI_SS_NB20{!ass20}}));
  
  spi_clgen20 clgen20 (.clk_in20(wb_clk_i20), .rst20(wb_rst_i20), .go20(go20), .enable(tip20), .last_clk20(last_bit20),
                   .divider20(divider20), .clk_out20(sclk_pad_o20), .pos_edge20(pos_edge20), 
                   .neg_edge20(neg_edge20));
  
  spi_shift20 shift20 (.clk20(wb_clk_i20), .rst20(wb_rst_i20), .len(char_len20[`SPI_CHAR_LEN_BITS20-1:0]),
                   .latch20(spi_tx_sel20[3:0] & {4{wb_we_i20}}), .byte_sel20(wb_sel_i20), .lsb(lsb), 
                   .go20(go20), .pos_edge20(pos_edge20), .neg_edge20(neg_edge20), 
                   .rx_negedge20(rx_negedge20), .tx_negedge20(tx_negedge20),
                   .tip20(tip20), .last(last_bit20), 
                   .p_in20(wb_dat_i20), .p_out20(rx20), 
                   .s_clk20(sclk_pad_o20), .s_in20(miso_pad_i20), .s_out20(mosi_pad_o20));
endmodule
  
