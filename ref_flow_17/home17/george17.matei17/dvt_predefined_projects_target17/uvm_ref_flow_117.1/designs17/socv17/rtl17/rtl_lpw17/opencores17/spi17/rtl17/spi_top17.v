//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_top17.v                                                   ////
////                                                              ////
////  This17 file is part of the SPI17 IP17 core17 project17                ////
////  http17://www17.opencores17.org17/projects17/spi17/                      ////
////                                                              ////
////  Author17(s):                                                  ////
////      - Simon17 Srot17 (simons17@opencores17.org17)                     ////
////                                                              ////
////  All additional17 information is avaliable17 in the Readme17.txt17   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright17 (C) 2002 Authors17                                   ////
////                                                              ////
//// This17 source17 file may be used and distributed17 without         ////
//// restriction17 provided that this copyright17 statement17 is not    ////
//// removed from the file and that any derivative17 work17 contains17  ////
//// the original copyright17 notice17 and the associated disclaimer17. ////
////                                                              ////
//// This17 source17 file is free software17; you can redistribute17 it   ////
//// and/or modify it under the terms17 of the GNU17 Lesser17 General17   ////
//// Public17 License17 as published17 by the Free17 Software17 Foundation17; ////
//// either17 version17 2.1 of the License17, or (at your17 option) any   ////
//// later17 version17.                                               ////
////                                                              ////
//// This17 source17 is distributed17 in the hope17 that it will be       ////
//// useful17, but WITHOUT17 ANY17 WARRANTY17; without even17 the implied17   ////
//// warranty17 of MERCHANTABILITY17 or FITNESS17 FOR17 A PARTICULAR17      ////
//// PURPOSE17.  See the GNU17 Lesser17 General17 Public17 License17 for more ////
//// details17.                                                     ////
////                                                              ////
//// You should have received17 a copy of the GNU17 Lesser17 General17    ////
//// Public17 License17 along17 with this source17; if not, download17 it   ////
//// from http17://www17.opencores17.org17/lgpl17.shtml17                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////


`include "spi_defines17.v"
`include "timescale.v"

module spi_top17
(
  // Wishbone17 signals17
  wb_clk_i17, wb_rst_i17, wb_adr_i17, wb_dat_i17, wb_dat_o17, wb_sel_i17,
  wb_we_i17, wb_stb_i17, wb_cyc_i17, wb_ack_o17, wb_err_o17, wb_int_o17,

  // SPI17 signals17
  ss_pad_o17, sclk_pad_o17, mosi_pad_o17, miso_pad_i17
);

  parameter Tp17 = 1;

  // Wishbone17 signals17
  input                            wb_clk_i17;         // master17 clock17 input
  input                            wb_rst_i17;         // synchronous17 active high17 reset
  input                      [4:0] wb_adr_i17;         // lower17 address bits
  input                   [32-1:0] wb_dat_i17;         // databus17 input
  output                  [32-1:0] wb_dat_o17;         // databus17 output
  input                      [3:0] wb_sel_i17;         // byte select17 inputs17
  input                            wb_we_i17;          // write enable input
  input                            wb_stb_i17;         // stobe17/core17 select17 signal17
  input                            wb_cyc_i17;         // valid bus cycle input
  output                           wb_ack_o17;         // bus cycle acknowledge17 output
  output                           wb_err_o17;         // termination w/ error
  output                           wb_int_o17;         // interrupt17 request signal17 output
                                                     
  // SPI17 signals17                                     
  output          [`SPI_SS_NB17-1:0] ss_pad_o17;         // slave17 select17
  output                           sclk_pad_o17;       // serial17 clock17
  output                           mosi_pad_o17;       // master17 out slave17 in
  input                            miso_pad_i17;       // master17 in slave17 out
                                                     
  reg                     [32-1:0] wb_dat_o17;
  reg                              wb_ack_o17;
  reg                              wb_int_o17;
                                               
  // Internal signals17
  reg       [`SPI_DIVIDER_LEN17-1:0] divider17;          // Divider17 register
  reg       [`SPI_CTRL_BIT_NB17-1:0] ctrl17;             // Control17 and status register
  reg             [`SPI_SS_NB17-1:0] ss;               // Slave17 select17 register
  reg                     [32-1:0] wb_dat17;           // wb17 data out
  wire         [`SPI_MAX_CHAR17-1:0] rx17;               // Rx17 register
  wire                             rx_negedge17;       // miso17 is sampled17 on negative edge
  wire                             tx_negedge17;       // mosi17 is driven17 on negative edge
  wire    [`SPI_CHAR_LEN_BITS17-1:0] char_len17;         // char17 len
  wire                             go17;               // go17
  wire                             lsb;              // lsb first on line
  wire                             ie17;               // interrupt17 enable
  wire                             ass17;              // automatic slave17 select17
  wire                             spi_divider_sel17;  // divider17 register select17
  wire                             spi_ctrl_sel17;     // ctrl17 register select17
  wire                       [3:0] spi_tx_sel17;       // tx_l17 register select17
  wire                             spi_ss_sel17;       // ss register select17
  wire                             tip17;              // transfer17 in progress17
  wire                             pos_edge17;         // recognize17 posedge of sclk17
  wire                             neg_edge17;         // recognize17 negedge of sclk17
  wire                             last_bit17;         // marks17 last character17 bit
  
  // Address decoder17
  assign spi_divider_sel17 = wb_cyc_i17 & wb_stb_i17 & (wb_adr_i17[`SPI_OFS_BITS17] == `SPI_DEVIDE17);
  assign spi_ctrl_sel17    = wb_cyc_i17 & wb_stb_i17 & (wb_adr_i17[`SPI_OFS_BITS17] == `SPI_CTRL17);
  assign spi_tx_sel17[0]   = wb_cyc_i17 & wb_stb_i17 & (wb_adr_i17[`SPI_OFS_BITS17] == `SPI_TX_017);
  assign spi_tx_sel17[1]   = wb_cyc_i17 & wb_stb_i17 & (wb_adr_i17[`SPI_OFS_BITS17] == `SPI_TX_117);
  assign spi_tx_sel17[2]   = wb_cyc_i17 & wb_stb_i17 & (wb_adr_i17[`SPI_OFS_BITS17] == `SPI_TX_217);
  assign spi_tx_sel17[3]   = wb_cyc_i17 & wb_stb_i17 & (wb_adr_i17[`SPI_OFS_BITS17] == `SPI_TX_317);
  assign spi_ss_sel17      = wb_cyc_i17 & wb_stb_i17 & (wb_adr_i17[`SPI_OFS_BITS17] == `SPI_SS17);
  
  // Read from registers
  always @(wb_adr_i17 or rx17 or ctrl17 or divider17 or ss)
  begin
    case (wb_adr_i17[`SPI_OFS_BITS17])
`ifdef SPI_MAX_CHAR_12817
      `SPI_RX_017:    wb_dat17 = rx17[31:0];
      `SPI_RX_117:    wb_dat17 = rx17[63:32];
      `SPI_RX_217:    wb_dat17 = rx17[95:64];
      `SPI_RX_317:    wb_dat17 = {{128-`SPI_MAX_CHAR17{1'b0}}, rx17[`SPI_MAX_CHAR17-1:96]};
`else
`ifdef SPI_MAX_CHAR_6417
      `SPI_RX_017:    wb_dat17 = rx17[31:0];
      `SPI_RX_117:    wb_dat17 = {{64-`SPI_MAX_CHAR17{1'b0}}, rx17[`SPI_MAX_CHAR17-1:32]};
      `SPI_RX_217:    wb_dat17 = 32'b0;
      `SPI_RX_317:    wb_dat17 = 32'b0;
`else
      `SPI_RX_017:    wb_dat17 = {{32-`SPI_MAX_CHAR17{1'b0}}, rx17[`SPI_MAX_CHAR17-1:0]};
      `SPI_RX_117:    wb_dat17 = 32'b0;
      `SPI_RX_217:    wb_dat17 = 32'b0;
      `SPI_RX_317:    wb_dat17 = 32'b0;
`endif
`endif
      `SPI_CTRL17:    wb_dat17 = {{32-`SPI_CTRL_BIT_NB17{1'b0}}, ctrl17};
      `SPI_DEVIDE17:  wb_dat17 = {{32-`SPI_DIVIDER_LEN17{1'b0}}, divider17};
      `SPI_SS17:      wb_dat17 = {{32-`SPI_SS_NB17{1'b0}}, ss};
      default:      wb_dat17 = 32'bx;
    endcase
  end
  
  // Wb17 data out
  always @(posedge wb_clk_i17 or posedge wb_rst_i17)
  begin
    if (wb_rst_i17)
      wb_dat_o17 <= #Tp17 32'b0;
    else
      wb_dat_o17 <= #Tp17 wb_dat17;
  end
  
  // Wb17 acknowledge17
  always @(posedge wb_clk_i17 or posedge wb_rst_i17)
  begin
    if (wb_rst_i17)
      wb_ack_o17 <= #Tp17 1'b0;
    else
      wb_ack_o17 <= #Tp17 wb_cyc_i17 & wb_stb_i17 & ~wb_ack_o17;
  end
  
  // Wb17 error
  assign wb_err_o17 = 1'b0;
  
  // Interrupt17
  always @(posedge wb_clk_i17 or posedge wb_rst_i17)
  begin
    if (wb_rst_i17)
      wb_int_o17 <= #Tp17 1'b0;
    else if (ie17 && tip17 && last_bit17 && pos_edge17)
      wb_int_o17 <= #Tp17 1'b1;
    else if (wb_ack_o17)
      wb_int_o17 <= #Tp17 1'b0;
  end
  
  // Divider17 register
  always @(posedge wb_clk_i17 or posedge wb_rst_i17)
  begin
    if (wb_rst_i17)
        divider17 <= #Tp17 {`SPI_DIVIDER_LEN17{1'b0}};
    else if (spi_divider_sel17 && wb_we_i17 && !tip17)
      begin
      `ifdef SPI_DIVIDER_LEN_817
        if (wb_sel_i17[0])
          divider17 <= #Tp17 wb_dat_i17[`SPI_DIVIDER_LEN17-1:0];
      `endif
      `ifdef SPI_DIVIDER_LEN_1617
        if (wb_sel_i17[0])
          divider17[7:0] <= #Tp17 wb_dat_i17[7:0];
        if (wb_sel_i17[1])
          divider17[`SPI_DIVIDER_LEN17-1:8] <= #Tp17 wb_dat_i17[`SPI_DIVIDER_LEN17-1:8];
      `endif
      `ifdef SPI_DIVIDER_LEN_2417
        if (wb_sel_i17[0])
          divider17[7:0] <= #Tp17 wb_dat_i17[7:0];
        if (wb_sel_i17[1])
          divider17[15:8] <= #Tp17 wb_dat_i17[15:8];
        if (wb_sel_i17[2])
          divider17[`SPI_DIVIDER_LEN17-1:16] <= #Tp17 wb_dat_i17[`SPI_DIVIDER_LEN17-1:16];
      `endif
      `ifdef SPI_DIVIDER_LEN_3217
        if (wb_sel_i17[0])
          divider17[7:0] <= #Tp17 wb_dat_i17[7:0];
        if (wb_sel_i17[1])
          divider17[15:8] <= #Tp17 wb_dat_i17[15:8];
        if (wb_sel_i17[2])
          divider17[23:16] <= #Tp17 wb_dat_i17[23:16];
        if (wb_sel_i17[3])
          divider17[`SPI_DIVIDER_LEN17-1:24] <= #Tp17 wb_dat_i17[`SPI_DIVIDER_LEN17-1:24];
      `endif
      end
  end
  
  // Ctrl17 register
  always @(posedge wb_clk_i17 or posedge wb_rst_i17)
  begin
    if (wb_rst_i17)
      ctrl17 <= #Tp17 {`SPI_CTRL_BIT_NB17{1'b0}};
    else if(spi_ctrl_sel17 && wb_we_i17 && !tip17)
      begin
        if (wb_sel_i17[0])
          ctrl17[7:0] <= #Tp17 wb_dat_i17[7:0] | {7'b0, ctrl17[0]};
        if (wb_sel_i17[1])
          ctrl17[`SPI_CTRL_BIT_NB17-1:8] <= #Tp17 wb_dat_i17[`SPI_CTRL_BIT_NB17-1:8];
      end
    else if(tip17 && last_bit17 && pos_edge17)
      ctrl17[`SPI_CTRL_GO17] <= #Tp17 1'b0;
  end
  
  assign rx_negedge17 = ctrl17[`SPI_CTRL_RX_NEGEDGE17];
  assign tx_negedge17 = ctrl17[`SPI_CTRL_TX_NEGEDGE17];
  assign go17         = ctrl17[`SPI_CTRL_GO17];
  assign char_len17   = ctrl17[`SPI_CTRL_CHAR_LEN17];
  assign lsb        = ctrl17[`SPI_CTRL_LSB17];
  assign ie17         = ctrl17[`SPI_CTRL_IE17];
  assign ass17        = ctrl17[`SPI_CTRL_ASS17];
  
  // Slave17 select17 register
  always @(posedge wb_clk_i17 or posedge wb_rst_i17)
  begin
    if (wb_rst_i17)
      ss <= #Tp17 {`SPI_SS_NB17{1'b0}};
    else if(spi_ss_sel17 && wb_we_i17 && !tip17)
      begin
      `ifdef SPI_SS_NB_817
        if (wb_sel_i17[0])
          ss <= #Tp17 wb_dat_i17[`SPI_SS_NB17-1:0];
      `endif
      `ifdef SPI_SS_NB_1617
        if (wb_sel_i17[0])
          ss[7:0] <= #Tp17 wb_dat_i17[7:0];
        if (wb_sel_i17[1])
          ss[`SPI_SS_NB17-1:8] <= #Tp17 wb_dat_i17[`SPI_SS_NB17-1:8];
      `endif
      `ifdef SPI_SS_NB_2417
        if (wb_sel_i17[0])
          ss[7:0] <= #Tp17 wb_dat_i17[7:0];
        if (wb_sel_i17[1])
          ss[15:8] <= #Tp17 wb_dat_i17[15:8];
        if (wb_sel_i17[2])
          ss[`SPI_SS_NB17-1:16] <= #Tp17 wb_dat_i17[`SPI_SS_NB17-1:16];
      `endif
      `ifdef SPI_SS_NB_3217
        if (wb_sel_i17[0])
          ss[7:0] <= #Tp17 wb_dat_i17[7:0];
        if (wb_sel_i17[1])
          ss[15:8] <= #Tp17 wb_dat_i17[15:8];
        if (wb_sel_i17[2])
          ss[23:16] <= #Tp17 wb_dat_i17[23:16];
        if (wb_sel_i17[3])
          ss[`SPI_SS_NB17-1:24] <= #Tp17 wb_dat_i17[`SPI_SS_NB17-1:24];
      `endif
      end
  end
  
  assign ss_pad_o17 = ~((ss & {`SPI_SS_NB17{tip17 & ass17}}) | (ss & {`SPI_SS_NB17{!ass17}}));
  
  spi_clgen17 clgen17 (.clk_in17(wb_clk_i17), .rst17(wb_rst_i17), .go17(go17), .enable(tip17), .last_clk17(last_bit17),
                   .divider17(divider17), .clk_out17(sclk_pad_o17), .pos_edge17(pos_edge17), 
                   .neg_edge17(neg_edge17));
  
  spi_shift17 shift17 (.clk17(wb_clk_i17), .rst17(wb_rst_i17), .len(char_len17[`SPI_CHAR_LEN_BITS17-1:0]),
                   .latch17(spi_tx_sel17[3:0] & {4{wb_we_i17}}), .byte_sel17(wb_sel_i17), .lsb(lsb), 
                   .go17(go17), .pos_edge17(pos_edge17), .neg_edge17(neg_edge17), 
                   .rx_negedge17(rx_negedge17), .tx_negedge17(tx_negedge17),
                   .tip17(tip17), .last(last_bit17), 
                   .p_in17(wb_dat_i17), .p_out17(rx17), 
                   .s_clk17(sclk_pad_o17), .s_in17(miso_pad_i17), .s_out17(mosi_pad_o17));
endmodule
  
