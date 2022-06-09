//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_top14.v                                                   ////
////                                                              ////
////  This14 file is part of the SPI14 IP14 core14 project14                ////
////  http14://www14.opencores14.org14/projects14/spi14/                      ////
////                                                              ////
////  Author14(s):                                                  ////
////      - Simon14 Srot14 (simons14@opencores14.org14)                     ////
////                                                              ////
////  All additional14 information is avaliable14 in the Readme14.txt14   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright14 (C) 2002 Authors14                                   ////
////                                                              ////
//// This14 source14 file may be used and distributed14 without         ////
//// restriction14 provided that this copyright14 statement14 is not    ////
//// removed from the file and that any derivative14 work14 contains14  ////
//// the original copyright14 notice14 and the associated disclaimer14. ////
////                                                              ////
//// This14 source14 file is free software14; you can redistribute14 it   ////
//// and/or modify it under the terms14 of the GNU14 Lesser14 General14   ////
//// Public14 License14 as published14 by the Free14 Software14 Foundation14; ////
//// either14 version14 2.1 of the License14, or (at your14 option) any   ////
//// later14 version14.                                               ////
////                                                              ////
//// This14 source14 is distributed14 in the hope14 that it will be       ////
//// useful14, but WITHOUT14 ANY14 WARRANTY14; without even14 the implied14   ////
//// warranty14 of MERCHANTABILITY14 or FITNESS14 FOR14 A PARTICULAR14      ////
//// PURPOSE14.  See the GNU14 Lesser14 General14 Public14 License14 for more ////
//// details14.                                                     ////
////                                                              ////
//// You should have received14 a copy of the GNU14 Lesser14 General14    ////
//// Public14 License14 along14 with this source14; if not, download14 it   ////
//// from http14://www14.opencores14.org14/lgpl14.shtml14                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////


`include "spi_defines14.v"
`include "timescale.v"

module spi_top14
(
  // Wishbone14 signals14
  wb_clk_i14, wb_rst_i14, wb_adr_i14, wb_dat_i14, wb_dat_o14, wb_sel_i14,
  wb_we_i14, wb_stb_i14, wb_cyc_i14, wb_ack_o14, wb_err_o14, wb_int_o14,

  // SPI14 signals14
  ss_pad_o14, sclk_pad_o14, mosi_pad_o14, miso_pad_i14
);

  parameter Tp14 = 1;

  // Wishbone14 signals14
  input                            wb_clk_i14;         // master14 clock14 input
  input                            wb_rst_i14;         // synchronous14 active high14 reset
  input                      [4:0] wb_adr_i14;         // lower14 address bits
  input                   [32-1:0] wb_dat_i14;         // databus14 input
  output                  [32-1:0] wb_dat_o14;         // databus14 output
  input                      [3:0] wb_sel_i14;         // byte select14 inputs14
  input                            wb_we_i14;          // write enable input
  input                            wb_stb_i14;         // stobe14/core14 select14 signal14
  input                            wb_cyc_i14;         // valid bus cycle input
  output                           wb_ack_o14;         // bus cycle acknowledge14 output
  output                           wb_err_o14;         // termination w/ error
  output                           wb_int_o14;         // interrupt14 request signal14 output
                                                     
  // SPI14 signals14                                     
  output          [`SPI_SS_NB14-1:0] ss_pad_o14;         // slave14 select14
  output                           sclk_pad_o14;       // serial14 clock14
  output                           mosi_pad_o14;       // master14 out slave14 in
  input                            miso_pad_i14;       // master14 in slave14 out
                                                     
  reg                     [32-1:0] wb_dat_o14;
  reg                              wb_ack_o14;
  reg                              wb_int_o14;
                                               
  // Internal signals14
  reg       [`SPI_DIVIDER_LEN14-1:0] divider14;          // Divider14 register
  reg       [`SPI_CTRL_BIT_NB14-1:0] ctrl14;             // Control14 and status register
  reg             [`SPI_SS_NB14-1:0] ss;               // Slave14 select14 register
  reg                     [32-1:0] wb_dat14;           // wb14 data out
  wire         [`SPI_MAX_CHAR14-1:0] rx14;               // Rx14 register
  wire                             rx_negedge14;       // miso14 is sampled14 on negative edge
  wire                             tx_negedge14;       // mosi14 is driven14 on negative edge
  wire    [`SPI_CHAR_LEN_BITS14-1:0] char_len14;         // char14 len
  wire                             go14;               // go14
  wire                             lsb;              // lsb first on line
  wire                             ie14;               // interrupt14 enable
  wire                             ass14;              // automatic slave14 select14
  wire                             spi_divider_sel14;  // divider14 register select14
  wire                             spi_ctrl_sel14;     // ctrl14 register select14
  wire                       [3:0] spi_tx_sel14;       // tx_l14 register select14
  wire                             spi_ss_sel14;       // ss register select14
  wire                             tip14;              // transfer14 in progress14
  wire                             pos_edge14;         // recognize14 posedge of sclk14
  wire                             neg_edge14;         // recognize14 negedge of sclk14
  wire                             last_bit14;         // marks14 last character14 bit
  
  // Address decoder14
  assign spi_divider_sel14 = wb_cyc_i14 & wb_stb_i14 & (wb_adr_i14[`SPI_OFS_BITS14] == `SPI_DEVIDE14);
  assign spi_ctrl_sel14    = wb_cyc_i14 & wb_stb_i14 & (wb_adr_i14[`SPI_OFS_BITS14] == `SPI_CTRL14);
  assign spi_tx_sel14[0]   = wb_cyc_i14 & wb_stb_i14 & (wb_adr_i14[`SPI_OFS_BITS14] == `SPI_TX_014);
  assign spi_tx_sel14[1]   = wb_cyc_i14 & wb_stb_i14 & (wb_adr_i14[`SPI_OFS_BITS14] == `SPI_TX_114);
  assign spi_tx_sel14[2]   = wb_cyc_i14 & wb_stb_i14 & (wb_adr_i14[`SPI_OFS_BITS14] == `SPI_TX_214);
  assign spi_tx_sel14[3]   = wb_cyc_i14 & wb_stb_i14 & (wb_adr_i14[`SPI_OFS_BITS14] == `SPI_TX_314);
  assign spi_ss_sel14      = wb_cyc_i14 & wb_stb_i14 & (wb_adr_i14[`SPI_OFS_BITS14] == `SPI_SS14);
  
  // Read from registers
  always @(wb_adr_i14 or rx14 or ctrl14 or divider14 or ss)
  begin
    case (wb_adr_i14[`SPI_OFS_BITS14])
`ifdef SPI_MAX_CHAR_12814
      `SPI_RX_014:    wb_dat14 = rx14[31:0];
      `SPI_RX_114:    wb_dat14 = rx14[63:32];
      `SPI_RX_214:    wb_dat14 = rx14[95:64];
      `SPI_RX_314:    wb_dat14 = {{128-`SPI_MAX_CHAR14{1'b0}}, rx14[`SPI_MAX_CHAR14-1:96]};
`else
`ifdef SPI_MAX_CHAR_6414
      `SPI_RX_014:    wb_dat14 = rx14[31:0];
      `SPI_RX_114:    wb_dat14 = {{64-`SPI_MAX_CHAR14{1'b0}}, rx14[`SPI_MAX_CHAR14-1:32]};
      `SPI_RX_214:    wb_dat14 = 32'b0;
      `SPI_RX_314:    wb_dat14 = 32'b0;
`else
      `SPI_RX_014:    wb_dat14 = {{32-`SPI_MAX_CHAR14{1'b0}}, rx14[`SPI_MAX_CHAR14-1:0]};
      `SPI_RX_114:    wb_dat14 = 32'b0;
      `SPI_RX_214:    wb_dat14 = 32'b0;
      `SPI_RX_314:    wb_dat14 = 32'b0;
`endif
`endif
      `SPI_CTRL14:    wb_dat14 = {{32-`SPI_CTRL_BIT_NB14{1'b0}}, ctrl14};
      `SPI_DEVIDE14:  wb_dat14 = {{32-`SPI_DIVIDER_LEN14{1'b0}}, divider14};
      `SPI_SS14:      wb_dat14 = {{32-`SPI_SS_NB14{1'b0}}, ss};
      default:      wb_dat14 = 32'bx;
    endcase
  end
  
  // Wb14 data out
  always @(posedge wb_clk_i14 or posedge wb_rst_i14)
  begin
    if (wb_rst_i14)
      wb_dat_o14 <= #Tp14 32'b0;
    else
      wb_dat_o14 <= #Tp14 wb_dat14;
  end
  
  // Wb14 acknowledge14
  always @(posedge wb_clk_i14 or posedge wb_rst_i14)
  begin
    if (wb_rst_i14)
      wb_ack_o14 <= #Tp14 1'b0;
    else
      wb_ack_o14 <= #Tp14 wb_cyc_i14 & wb_stb_i14 & ~wb_ack_o14;
  end
  
  // Wb14 error
  assign wb_err_o14 = 1'b0;
  
  // Interrupt14
  always @(posedge wb_clk_i14 or posedge wb_rst_i14)
  begin
    if (wb_rst_i14)
      wb_int_o14 <= #Tp14 1'b0;
    else if (ie14 && tip14 && last_bit14 && pos_edge14)
      wb_int_o14 <= #Tp14 1'b1;
    else if (wb_ack_o14)
      wb_int_o14 <= #Tp14 1'b0;
  end
  
  // Divider14 register
  always @(posedge wb_clk_i14 or posedge wb_rst_i14)
  begin
    if (wb_rst_i14)
        divider14 <= #Tp14 {`SPI_DIVIDER_LEN14{1'b0}};
    else if (spi_divider_sel14 && wb_we_i14 && !tip14)
      begin
      `ifdef SPI_DIVIDER_LEN_814
        if (wb_sel_i14[0])
          divider14 <= #Tp14 wb_dat_i14[`SPI_DIVIDER_LEN14-1:0];
      `endif
      `ifdef SPI_DIVIDER_LEN_1614
        if (wb_sel_i14[0])
          divider14[7:0] <= #Tp14 wb_dat_i14[7:0];
        if (wb_sel_i14[1])
          divider14[`SPI_DIVIDER_LEN14-1:8] <= #Tp14 wb_dat_i14[`SPI_DIVIDER_LEN14-1:8];
      `endif
      `ifdef SPI_DIVIDER_LEN_2414
        if (wb_sel_i14[0])
          divider14[7:0] <= #Tp14 wb_dat_i14[7:0];
        if (wb_sel_i14[1])
          divider14[15:8] <= #Tp14 wb_dat_i14[15:8];
        if (wb_sel_i14[2])
          divider14[`SPI_DIVIDER_LEN14-1:16] <= #Tp14 wb_dat_i14[`SPI_DIVIDER_LEN14-1:16];
      `endif
      `ifdef SPI_DIVIDER_LEN_3214
        if (wb_sel_i14[0])
          divider14[7:0] <= #Tp14 wb_dat_i14[7:0];
        if (wb_sel_i14[1])
          divider14[15:8] <= #Tp14 wb_dat_i14[15:8];
        if (wb_sel_i14[2])
          divider14[23:16] <= #Tp14 wb_dat_i14[23:16];
        if (wb_sel_i14[3])
          divider14[`SPI_DIVIDER_LEN14-1:24] <= #Tp14 wb_dat_i14[`SPI_DIVIDER_LEN14-1:24];
      `endif
      end
  end
  
  // Ctrl14 register
  always @(posedge wb_clk_i14 or posedge wb_rst_i14)
  begin
    if (wb_rst_i14)
      ctrl14 <= #Tp14 {`SPI_CTRL_BIT_NB14{1'b0}};
    else if(spi_ctrl_sel14 && wb_we_i14 && !tip14)
      begin
        if (wb_sel_i14[0])
          ctrl14[7:0] <= #Tp14 wb_dat_i14[7:0] | {7'b0, ctrl14[0]};
        if (wb_sel_i14[1])
          ctrl14[`SPI_CTRL_BIT_NB14-1:8] <= #Tp14 wb_dat_i14[`SPI_CTRL_BIT_NB14-1:8];
      end
    else if(tip14 && last_bit14 && pos_edge14)
      ctrl14[`SPI_CTRL_GO14] <= #Tp14 1'b0;
  end
  
  assign rx_negedge14 = ctrl14[`SPI_CTRL_RX_NEGEDGE14];
  assign tx_negedge14 = ctrl14[`SPI_CTRL_TX_NEGEDGE14];
  assign go14         = ctrl14[`SPI_CTRL_GO14];
  assign char_len14   = ctrl14[`SPI_CTRL_CHAR_LEN14];
  assign lsb        = ctrl14[`SPI_CTRL_LSB14];
  assign ie14         = ctrl14[`SPI_CTRL_IE14];
  assign ass14        = ctrl14[`SPI_CTRL_ASS14];
  
  // Slave14 select14 register
  always @(posedge wb_clk_i14 or posedge wb_rst_i14)
  begin
    if (wb_rst_i14)
      ss <= #Tp14 {`SPI_SS_NB14{1'b0}};
    else if(spi_ss_sel14 && wb_we_i14 && !tip14)
      begin
      `ifdef SPI_SS_NB_814
        if (wb_sel_i14[0])
          ss <= #Tp14 wb_dat_i14[`SPI_SS_NB14-1:0];
      `endif
      `ifdef SPI_SS_NB_1614
        if (wb_sel_i14[0])
          ss[7:0] <= #Tp14 wb_dat_i14[7:0];
        if (wb_sel_i14[1])
          ss[`SPI_SS_NB14-1:8] <= #Tp14 wb_dat_i14[`SPI_SS_NB14-1:8];
      `endif
      `ifdef SPI_SS_NB_2414
        if (wb_sel_i14[0])
          ss[7:0] <= #Tp14 wb_dat_i14[7:0];
        if (wb_sel_i14[1])
          ss[15:8] <= #Tp14 wb_dat_i14[15:8];
        if (wb_sel_i14[2])
          ss[`SPI_SS_NB14-1:16] <= #Tp14 wb_dat_i14[`SPI_SS_NB14-1:16];
      `endif
      `ifdef SPI_SS_NB_3214
        if (wb_sel_i14[0])
          ss[7:0] <= #Tp14 wb_dat_i14[7:0];
        if (wb_sel_i14[1])
          ss[15:8] <= #Tp14 wb_dat_i14[15:8];
        if (wb_sel_i14[2])
          ss[23:16] <= #Tp14 wb_dat_i14[23:16];
        if (wb_sel_i14[3])
          ss[`SPI_SS_NB14-1:24] <= #Tp14 wb_dat_i14[`SPI_SS_NB14-1:24];
      `endif
      end
  end
  
  assign ss_pad_o14 = ~((ss & {`SPI_SS_NB14{tip14 & ass14}}) | (ss & {`SPI_SS_NB14{!ass14}}));
  
  spi_clgen14 clgen14 (.clk_in14(wb_clk_i14), .rst14(wb_rst_i14), .go14(go14), .enable(tip14), .last_clk14(last_bit14),
                   .divider14(divider14), .clk_out14(sclk_pad_o14), .pos_edge14(pos_edge14), 
                   .neg_edge14(neg_edge14));
  
  spi_shift14 shift14 (.clk14(wb_clk_i14), .rst14(wb_rst_i14), .len(char_len14[`SPI_CHAR_LEN_BITS14-1:0]),
                   .latch14(spi_tx_sel14[3:0] & {4{wb_we_i14}}), .byte_sel14(wb_sel_i14), .lsb(lsb), 
                   .go14(go14), .pos_edge14(pos_edge14), .neg_edge14(neg_edge14), 
                   .rx_negedge14(rx_negedge14), .tx_negedge14(tx_negedge14),
                   .tip14(tip14), .last(last_bit14), 
                   .p_in14(wb_dat_i14), .p_out14(rx14), 
                   .s_clk14(sclk_pad_o14), .s_in14(miso_pad_i14), .s_out14(mosi_pad_o14));
endmodule
  
