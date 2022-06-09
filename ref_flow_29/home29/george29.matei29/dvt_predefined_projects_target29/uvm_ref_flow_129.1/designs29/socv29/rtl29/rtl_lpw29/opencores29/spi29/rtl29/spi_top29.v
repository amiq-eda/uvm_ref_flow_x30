//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_top29.v                                                   ////
////                                                              ////
////  This29 file is part of the SPI29 IP29 core29 project29                ////
////  http29://www29.opencores29.org29/projects29/spi29/                      ////
////                                                              ////
////  Author29(s):                                                  ////
////      - Simon29 Srot29 (simons29@opencores29.org29)                     ////
////                                                              ////
////  All additional29 information is avaliable29 in the Readme29.txt29   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright29 (C) 2002 Authors29                                   ////
////                                                              ////
//// This29 source29 file may be used and distributed29 without         ////
//// restriction29 provided that this copyright29 statement29 is not    ////
//// removed from the file and that any derivative29 work29 contains29  ////
//// the original copyright29 notice29 and the associated disclaimer29. ////
////                                                              ////
//// This29 source29 file is free software29; you can redistribute29 it   ////
//// and/or modify it under the terms29 of the GNU29 Lesser29 General29   ////
//// Public29 License29 as published29 by the Free29 Software29 Foundation29; ////
//// either29 version29 2.1 of the License29, or (at your29 option) any   ////
//// later29 version29.                                               ////
////                                                              ////
//// This29 source29 is distributed29 in the hope29 that it will be       ////
//// useful29, but WITHOUT29 ANY29 WARRANTY29; without even29 the implied29   ////
//// warranty29 of MERCHANTABILITY29 or FITNESS29 FOR29 A PARTICULAR29      ////
//// PURPOSE29.  See the GNU29 Lesser29 General29 Public29 License29 for more ////
//// details29.                                                     ////
////                                                              ////
//// You should have received29 a copy of the GNU29 Lesser29 General29    ////
//// Public29 License29 along29 with this source29; if not, download29 it   ////
//// from http29://www29.opencores29.org29/lgpl29.shtml29                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////


`include "spi_defines29.v"
`include "timescale.v"

module spi_top29
(
  // Wishbone29 signals29
  wb_clk_i29, wb_rst_i29, wb_adr_i29, wb_dat_i29, wb_dat_o29, wb_sel_i29,
  wb_we_i29, wb_stb_i29, wb_cyc_i29, wb_ack_o29, wb_err_o29, wb_int_o29,

  // SPI29 signals29
  ss_pad_o29, sclk_pad_o29, mosi_pad_o29, miso_pad_i29
);

  parameter Tp29 = 1;

  // Wishbone29 signals29
  input                            wb_clk_i29;         // master29 clock29 input
  input                            wb_rst_i29;         // synchronous29 active high29 reset
  input                      [4:0] wb_adr_i29;         // lower29 address bits
  input                   [32-1:0] wb_dat_i29;         // databus29 input
  output                  [32-1:0] wb_dat_o29;         // databus29 output
  input                      [3:0] wb_sel_i29;         // byte select29 inputs29
  input                            wb_we_i29;          // write enable input
  input                            wb_stb_i29;         // stobe29/core29 select29 signal29
  input                            wb_cyc_i29;         // valid bus cycle input
  output                           wb_ack_o29;         // bus cycle acknowledge29 output
  output                           wb_err_o29;         // termination w/ error
  output                           wb_int_o29;         // interrupt29 request signal29 output
                                                     
  // SPI29 signals29                                     
  output          [`SPI_SS_NB29-1:0] ss_pad_o29;         // slave29 select29
  output                           sclk_pad_o29;       // serial29 clock29
  output                           mosi_pad_o29;       // master29 out slave29 in
  input                            miso_pad_i29;       // master29 in slave29 out
                                                     
  reg                     [32-1:0] wb_dat_o29;
  reg                              wb_ack_o29;
  reg                              wb_int_o29;
                                               
  // Internal signals29
  reg       [`SPI_DIVIDER_LEN29-1:0] divider29;          // Divider29 register
  reg       [`SPI_CTRL_BIT_NB29-1:0] ctrl29;             // Control29 and status register
  reg             [`SPI_SS_NB29-1:0] ss;               // Slave29 select29 register
  reg                     [32-1:0] wb_dat29;           // wb29 data out
  wire         [`SPI_MAX_CHAR29-1:0] rx29;               // Rx29 register
  wire                             rx_negedge29;       // miso29 is sampled29 on negative edge
  wire                             tx_negedge29;       // mosi29 is driven29 on negative edge
  wire    [`SPI_CHAR_LEN_BITS29-1:0] char_len29;         // char29 len
  wire                             go29;               // go29
  wire                             lsb;              // lsb first on line
  wire                             ie29;               // interrupt29 enable
  wire                             ass29;              // automatic slave29 select29
  wire                             spi_divider_sel29;  // divider29 register select29
  wire                             spi_ctrl_sel29;     // ctrl29 register select29
  wire                       [3:0] spi_tx_sel29;       // tx_l29 register select29
  wire                             spi_ss_sel29;       // ss register select29
  wire                             tip29;              // transfer29 in progress29
  wire                             pos_edge29;         // recognize29 posedge of sclk29
  wire                             neg_edge29;         // recognize29 negedge of sclk29
  wire                             last_bit29;         // marks29 last character29 bit
  
  // Address decoder29
  assign spi_divider_sel29 = wb_cyc_i29 & wb_stb_i29 & (wb_adr_i29[`SPI_OFS_BITS29] == `SPI_DEVIDE29);
  assign spi_ctrl_sel29    = wb_cyc_i29 & wb_stb_i29 & (wb_adr_i29[`SPI_OFS_BITS29] == `SPI_CTRL29);
  assign spi_tx_sel29[0]   = wb_cyc_i29 & wb_stb_i29 & (wb_adr_i29[`SPI_OFS_BITS29] == `SPI_TX_029);
  assign spi_tx_sel29[1]   = wb_cyc_i29 & wb_stb_i29 & (wb_adr_i29[`SPI_OFS_BITS29] == `SPI_TX_129);
  assign spi_tx_sel29[2]   = wb_cyc_i29 & wb_stb_i29 & (wb_adr_i29[`SPI_OFS_BITS29] == `SPI_TX_229);
  assign spi_tx_sel29[3]   = wb_cyc_i29 & wb_stb_i29 & (wb_adr_i29[`SPI_OFS_BITS29] == `SPI_TX_329);
  assign spi_ss_sel29      = wb_cyc_i29 & wb_stb_i29 & (wb_adr_i29[`SPI_OFS_BITS29] == `SPI_SS29);
  
  // Read from registers
  always @(wb_adr_i29 or rx29 or ctrl29 or divider29 or ss)
  begin
    case (wb_adr_i29[`SPI_OFS_BITS29])
`ifdef SPI_MAX_CHAR_12829
      `SPI_RX_029:    wb_dat29 = rx29[31:0];
      `SPI_RX_129:    wb_dat29 = rx29[63:32];
      `SPI_RX_229:    wb_dat29 = rx29[95:64];
      `SPI_RX_329:    wb_dat29 = {{128-`SPI_MAX_CHAR29{1'b0}}, rx29[`SPI_MAX_CHAR29-1:96]};
`else
`ifdef SPI_MAX_CHAR_6429
      `SPI_RX_029:    wb_dat29 = rx29[31:0];
      `SPI_RX_129:    wb_dat29 = {{64-`SPI_MAX_CHAR29{1'b0}}, rx29[`SPI_MAX_CHAR29-1:32]};
      `SPI_RX_229:    wb_dat29 = 32'b0;
      `SPI_RX_329:    wb_dat29 = 32'b0;
`else
      `SPI_RX_029:    wb_dat29 = {{32-`SPI_MAX_CHAR29{1'b0}}, rx29[`SPI_MAX_CHAR29-1:0]};
      `SPI_RX_129:    wb_dat29 = 32'b0;
      `SPI_RX_229:    wb_dat29 = 32'b0;
      `SPI_RX_329:    wb_dat29 = 32'b0;
`endif
`endif
      `SPI_CTRL29:    wb_dat29 = {{32-`SPI_CTRL_BIT_NB29{1'b0}}, ctrl29};
      `SPI_DEVIDE29:  wb_dat29 = {{32-`SPI_DIVIDER_LEN29{1'b0}}, divider29};
      `SPI_SS29:      wb_dat29 = {{32-`SPI_SS_NB29{1'b0}}, ss};
      default:      wb_dat29 = 32'bx;
    endcase
  end
  
  // Wb29 data out
  always @(posedge wb_clk_i29 or posedge wb_rst_i29)
  begin
    if (wb_rst_i29)
      wb_dat_o29 <= #Tp29 32'b0;
    else
      wb_dat_o29 <= #Tp29 wb_dat29;
  end
  
  // Wb29 acknowledge29
  always @(posedge wb_clk_i29 or posedge wb_rst_i29)
  begin
    if (wb_rst_i29)
      wb_ack_o29 <= #Tp29 1'b0;
    else
      wb_ack_o29 <= #Tp29 wb_cyc_i29 & wb_stb_i29 & ~wb_ack_o29;
  end
  
  // Wb29 error
  assign wb_err_o29 = 1'b0;
  
  // Interrupt29
  always @(posedge wb_clk_i29 or posedge wb_rst_i29)
  begin
    if (wb_rst_i29)
      wb_int_o29 <= #Tp29 1'b0;
    else if (ie29 && tip29 && last_bit29 && pos_edge29)
      wb_int_o29 <= #Tp29 1'b1;
    else if (wb_ack_o29)
      wb_int_o29 <= #Tp29 1'b0;
  end
  
  // Divider29 register
  always @(posedge wb_clk_i29 or posedge wb_rst_i29)
  begin
    if (wb_rst_i29)
        divider29 <= #Tp29 {`SPI_DIVIDER_LEN29{1'b0}};
    else if (spi_divider_sel29 && wb_we_i29 && !tip29)
      begin
      `ifdef SPI_DIVIDER_LEN_829
        if (wb_sel_i29[0])
          divider29 <= #Tp29 wb_dat_i29[`SPI_DIVIDER_LEN29-1:0];
      `endif
      `ifdef SPI_DIVIDER_LEN_1629
        if (wb_sel_i29[0])
          divider29[7:0] <= #Tp29 wb_dat_i29[7:0];
        if (wb_sel_i29[1])
          divider29[`SPI_DIVIDER_LEN29-1:8] <= #Tp29 wb_dat_i29[`SPI_DIVIDER_LEN29-1:8];
      `endif
      `ifdef SPI_DIVIDER_LEN_2429
        if (wb_sel_i29[0])
          divider29[7:0] <= #Tp29 wb_dat_i29[7:0];
        if (wb_sel_i29[1])
          divider29[15:8] <= #Tp29 wb_dat_i29[15:8];
        if (wb_sel_i29[2])
          divider29[`SPI_DIVIDER_LEN29-1:16] <= #Tp29 wb_dat_i29[`SPI_DIVIDER_LEN29-1:16];
      `endif
      `ifdef SPI_DIVIDER_LEN_3229
        if (wb_sel_i29[0])
          divider29[7:0] <= #Tp29 wb_dat_i29[7:0];
        if (wb_sel_i29[1])
          divider29[15:8] <= #Tp29 wb_dat_i29[15:8];
        if (wb_sel_i29[2])
          divider29[23:16] <= #Tp29 wb_dat_i29[23:16];
        if (wb_sel_i29[3])
          divider29[`SPI_DIVIDER_LEN29-1:24] <= #Tp29 wb_dat_i29[`SPI_DIVIDER_LEN29-1:24];
      `endif
      end
  end
  
  // Ctrl29 register
  always @(posedge wb_clk_i29 or posedge wb_rst_i29)
  begin
    if (wb_rst_i29)
      ctrl29 <= #Tp29 {`SPI_CTRL_BIT_NB29{1'b0}};
    else if(spi_ctrl_sel29 && wb_we_i29 && !tip29)
      begin
        if (wb_sel_i29[0])
          ctrl29[7:0] <= #Tp29 wb_dat_i29[7:0] | {7'b0, ctrl29[0]};
        if (wb_sel_i29[1])
          ctrl29[`SPI_CTRL_BIT_NB29-1:8] <= #Tp29 wb_dat_i29[`SPI_CTRL_BIT_NB29-1:8];
      end
    else if(tip29 && last_bit29 && pos_edge29)
      ctrl29[`SPI_CTRL_GO29] <= #Tp29 1'b0;
  end
  
  assign rx_negedge29 = ctrl29[`SPI_CTRL_RX_NEGEDGE29];
  assign tx_negedge29 = ctrl29[`SPI_CTRL_TX_NEGEDGE29];
  assign go29         = ctrl29[`SPI_CTRL_GO29];
  assign char_len29   = ctrl29[`SPI_CTRL_CHAR_LEN29];
  assign lsb        = ctrl29[`SPI_CTRL_LSB29];
  assign ie29         = ctrl29[`SPI_CTRL_IE29];
  assign ass29        = ctrl29[`SPI_CTRL_ASS29];
  
  // Slave29 select29 register
  always @(posedge wb_clk_i29 or posedge wb_rst_i29)
  begin
    if (wb_rst_i29)
      ss <= #Tp29 {`SPI_SS_NB29{1'b0}};
    else if(spi_ss_sel29 && wb_we_i29 && !tip29)
      begin
      `ifdef SPI_SS_NB_829
        if (wb_sel_i29[0])
          ss <= #Tp29 wb_dat_i29[`SPI_SS_NB29-1:0];
      `endif
      `ifdef SPI_SS_NB_1629
        if (wb_sel_i29[0])
          ss[7:0] <= #Tp29 wb_dat_i29[7:0];
        if (wb_sel_i29[1])
          ss[`SPI_SS_NB29-1:8] <= #Tp29 wb_dat_i29[`SPI_SS_NB29-1:8];
      `endif
      `ifdef SPI_SS_NB_2429
        if (wb_sel_i29[0])
          ss[7:0] <= #Tp29 wb_dat_i29[7:0];
        if (wb_sel_i29[1])
          ss[15:8] <= #Tp29 wb_dat_i29[15:8];
        if (wb_sel_i29[2])
          ss[`SPI_SS_NB29-1:16] <= #Tp29 wb_dat_i29[`SPI_SS_NB29-1:16];
      `endif
      `ifdef SPI_SS_NB_3229
        if (wb_sel_i29[0])
          ss[7:0] <= #Tp29 wb_dat_i29[7:0];
        if (wb_sel_i29[1])
          ss[15:8] <= #Tp29 wb_dat_i29[15:8];
        if (wb_sel_i29[2])
          ss[23:16] <= #Tp29 wb_dat_i29[23:16];
        if (wb_sel_i29[3])
          ss[`SPI_SS_NB29-1:24] <= #Tp29 wb_dat_i29[`SPI_SS_NB29-1:24];
      `endif
      end
  end
  
  assign ss_pad_o29 = ~((ss & {`SPI_SS_NB29{tip29 & ass29}}) | (ss & {`SPI_SS_NB29{!ass29}}));
  
  spi_clgen29 clgen29 (.clk_in29(wb_clk_i29), .rst29(wb_rst_i29), .go29(go29), .enable(tip29), .last_clk29(last_bit29),
                   .divider29(divider29), .clk_out29(sclk_pad_o29), .pos_edge29(pos_edge29), 
                   .neg_edge29(neg_edge29));
  
  spi_shift29 shift29 (.clk29(wb_clk_i29), .rst29(wb_rst_i29), .len(char_len29[`SPI_CHAR_LEN_BITS29-1:0]),
                   .latch29(spi_tx_sel29[3:0] & {4{wb_we_i29}}), .byte_sel29(wb_sel_i29), .lsb(lsb), 
                   .go29(go29), .pos_edge29(pos_edge29), .neg_edge29(neg_edge29), 
                   .rx_negedge29(rx_negedge29), .tx_negedge29(tx_negedge29),
                   .tip29(tip29), .last(last_bit29), 
                   .p_in29(wb_dat_i29), .p_out29(rx29), 
                   .s_clk29(sclk_pad_o29), .s_in29(miso_pad_i29), .s_out29(mosi_pad_o29));
endmodule
  
