//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_top11.v                                                   ////
////                                                              ////
////  This11 file is part of the SPI11 IP11 core11 project11                ////
////  http11://www11.opencores11.org11/projects11/spi11/                      ////
////                                                              ////
////  Author11(s):                                                  ////
////      - Simon11 Srot11 (simons11@opencores11.org11)                     ////
////                                                              ////
////  All additional11 information is avaliable11 in the Readme11.txt11   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright11 (C) 2002 Authors11                                   ////
////                                                              ////
//// This11 source11 file may be used and distributed11 without         ////
//// restriction11 provided that this copyright11 statement11 is not    ////
//// removed from the file and that any derivative11 work11 contains11  ////
//// the original copyright11 notice11 and the associated disclaimer11. ////
////                                                              ////
//// This11 source11 file is free software11; you can redistribute11 it   ////
//// and/or modify it under the terms11 of the GNU11 Lesser11 General11   ////
//// Public11 License11 as published11 by the Free11 Software11 Foundation11; ////
//// either11 version11 2.1 of the License11, or (at your11 option) any   ////
//// later11 version11.                                               ////
////                                                              ////
//// This11 source11 is distributed11 in the hope11 that it will be       ////
//// useful11, but WITHOUT11 ANY11 WARRANTY11; without even11 the implied11   ////
//// warranty11 of MERCHANTABILITY11 or FITNESS11 FOR11 A PARTICULAR11      ////
//// PURPOSE11.  See the GNU11 Lesser11 General11 Public11 License11 for more ////
//// details11.                                                     ////
////                                                              ////
//// You should have received11 a copy of the GNU11 Lesser11 General11    ////
//// Public11 License11 along11 with this source11; if not, download11 it   ////
//// from http11://www11.opencores11.org11/lgpl11.shtml11                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////


`include "spi_defines11.v"
`include "timescale.v"

module spi_top11
(
  // Wishbone11 signals11
  wb_clk_i11, wb_rst_i11, wb_adr_i11, wb_dat_i11, wb_dat_o11, wb_sel_i11,
  wb_we_i11, wb_stb_i11, wb_cyc_i11, wb_ack_o11, wb_err_o11, wb_int_o11,

  // SPI11 signals11
  ss_pad_o11, sclk_pad_o11, mosi_pad_o11, miso_pad_i11
);

  parameter Tp11 = 1;

  // Wishbone11 signals11
  input                            wb_clk_i11;         // master11 clock11 input
  input                            wb_rst_i11;         // synchronous11 active high11 reset
  input                      [4:0] wb_adr_i11;         // lower11 address bits
  input                   [32-1:0] wb_dat_i11;         // databus11 input
  output                  [32-1:0] wb_dat_o11;         // databus11 output
  input                      [3:0] wb_sel_i11;         // byte select11 inputs11
  input                            wb_we_i11;          // write enable input
  input                            wb_stb_i11;         // stobe11/core11 select11 signal11
  input                            wb_cyc_i11;         // valid bus cycle input
  output                           wb_ack_o11;         // bus cycle acknowledge11 output
  output                           wb_err_o11;         // termination w/ error
  output                           wb_int_o11;         // interrupt11 request signal11 output
                                                     
  // SPI11 signals11                                     
  output          [`SPI_SS_NB11-1:0] ss_pad_o11;         // slave11 select11
  output                           sclk_pad_o11;       // serial11 clock11
  output                           mosi_pad_o11;       // master11 out slave11 in
  input                            miso_pad_i11;       // master11 in slave11 out
                                                     
  reg                     [32-1:0] wb_dat_o11;
  reg                              wb_ack_o11;
  reg                              wb_int_o11;
                                               
  // Internal signals11
  reg       [`SPI_DIVIDER_LEN11-1:0] divider11;          // Divider11 register
  reg       [`SPI_CTRL_BIT_NB11-1:0] ctrl11;             // Control11 and status register
  reg             [`SPI_SS_NB11-1:0] ss;               // Slave11 select11 register
  reg                     [32-1:0] wb_dat11;           // wb11 data out
  wire         [`SPI_MAX_CHAR11-1:0] rx11;               // Rx11 register
  wire                             rx_negedge11;       // miso11 is sampled11 on negative edge
  wire                             tx_negedge11;       // mosi11 is driven11 on negative edge
  wire    [`SPI_CHAR_LEN_BITS11-1:0] char_len11;         // char11 len
  wire                             go11;               // go11
  wire                             lsb;              // lsb first on line
  wire                             ie11;               // interrupt11 enable
  wire                             ass11;              // automatic slave11 select11
  wire                             spi_divider_sel11;  // divider11 register select11
  wire                             spi_ctrl_sel11;     // ctrl11 register select11
  wire                       [3:0] spi_tx_sel11;       // tx_l11 register select11
  wire                             spi_ss_sel11;       // ss register select11
  wire                             tip11;              // transfer11 in progress11
  wire                             pos_edge11;         // recognize11 posedge of sclk11
  wire                             neg_edge11;         // recognize11 negedge of sclk11
  wire                             last_bit11;         // marks11 last character11 bit
  
  // Address decoder11
  assign spi_divider_sel11 = wb_cyc_i11 & wb_stb_i11 & (wb_adr_i11[`SPI_OFS_BITS11] == `SPI_DEVIDE11);
  assign spi_ctrl_sel11    = wb_cyc_i11 & wb_stb_i11 & (wb_adr_i11[`SPI_OFS_BITS11] == `SPI_CTRL11);
  assign spi_tx_sel11[0]   = wb_cyc_i11 & wb_stb_i11 & (wb_adr_i11[`SPI_OFS_BITS11] == `SPI_TX_011);
  assign spi_tx_sel11[1]   = wb_cyc_i11 & wb_stb_i11 & (wb_adr_i11[`SPI_OFS_BITS11] == `SPI_TX_111);
  assign spi_tx_sel11[2]   = wb_cyc_i11 & wb_stb_i11 & (wb_adr_i11[`SPI_OFS_BITS11] == `SPI_TX_211);
  assign spi_tx_sel11[3]   = wb_cyc_i11 & wb_stb_i11 & (wb_adr_i11[`SPI_OFS_BITS11] == `SPI_TX_311);
  assign spi_ss_sel11      = wb_cyc_i11 & wb_stb_i11 & (wb_adr_i11[`SPI_OFS_BITS11] == `SPI_SS11);
  
  // Read from registers
  always @(wb_adr_i11 or rx11 or ctrl11 or divider11 or ss)
  begin
    case (wb_adr_i11[`SPI_OFS_BITS11])
`ifdef SPI_MAX_CHAR_12811
      `SPI_RX_011:    wb_dat11 = rx11[31:0];
      `SPI_RX_111:    wb_dat11 = rx11[63:32];
      `SPI_RX_211:    wb_dat11 = rx11[95:64];
      `SPI_RX_311:    wb_dat11 = {{128-`SPI_MAX_CHAR11{1'b0}}, rx11[`SPI_MAX_CHAR11-1:96]};
`else
`ifdef SPI_MAX_CHAR_6411
      `SPI_RX_011:    wb_dat11 = rx11[31:0];
      `SPI_RX_111:    wb_dat11 = {{64-`SPI_MAX_CHAR11{1'b0}}, rx11[`SPI_MAX_CHAR11-1:32]};
      `SPI_RX_211:    wb_dat11 = 32'b0;
      `SPI_RX_311:    wb_dat11 = 32'b0;
`else
      `SPI_RX_011:    wb_dat11 = {{32-`SPI_MAX_CHAR11{1'b0}}, rx11[`SPI_MAX_CHAR11-1:0]};
      `SPI_RX_111:    wb_dat11 = 32'b0;
      `SPI_RX_211:    wb_dat11 = 32'b0;
      `SPI_RX_311:    wb_dat11 = 32'b0;
`endif
`endif
      `SPI_CTRL11:    wb_dat11 = {{32-`SPI_CTRL_BIT_NB11{1'b0}}, ctrl11};
      `SPI_DEVIDE11:  wb_dat11 = {{32-`SPI_DIVIDER_LEN11{1'b0}}, divider11};
      `SPI_SS11:      wb_dat11 = {{32-`SPI_SS_NB11{1'b0}}, ss};
      default:      wb_dat11 = 32'bx;
    endcase
  end
  
  // Wb11 data out
  always @(posedge wb_clk_i11 or posedge wb_rst_i11)
  begin
    if (wb_rst_i11)
      wb_dat_o11 <= #Tp11 32'b0;
    else
      wb_dat_o11 <= #Tp11 wb_dat11;
  end
  
  // Wb11 acknowledge11
  always @(posedge wb_clk_i11 or posedge wb_rst_i11)
  begin
    if (wb_rst_i11)
      wb_ack_o11 <= #Tp11 1'b0;
    else
      wb_ack_o11 <= #Tp11 wb_cyc_i11 & wb_stb_i11 & ~wb_ack_o11;
  end
  
  // Wb11 error
  assign wb_err_o11 = 1'b0;
  
  // Interrupt11
  always @(posedge wb_clk_i11 or posedge wb_rst_i11)
  begin
    if (wb_rst_i11)
      wb_int_o11 <= #Tp11 1'b0;
    else if (ie11 && tip11 && last_bit11 && pos_edge11)
      wb_int_o11 <= #Tp11 1'b1;
    else if (wb_ack_o11)
      wb_int_o11 <= #Tp11 1'b0;
  end
  
  // Divider11 register
  always @(posedge wb_clk_i11 or posedge wb_rst_i11)
  begin
    if (wb_rst_i11)
        divider11 <= #Tp11 {`SPI_DIVIDER_LEN11{1'b0}};
    else if (spi_divider_sel11 && wb_we_i11 && !tip11)
      begin
      `ifdef SPI_DIVIDER_LEN_811
        if (wb_sel_i11[0])
          divider11 <= #Tp11 wb_dat_i11[`SPI_DIVIDER_LEN11-1:0];
      `endif
      `ifdef SPI_DIVIDER_LEN_1611
        if (wb_sel_i11[0])
          divider11[7:0] <= #Tp11 wb_dat_i11[7:0];
        if (wb_sel_i11[1])
          divider11[`SPI_DIVIDER_LEN11-1:8] <= #Tp11 wb_dat_i11[`SPI_DIVIDER_LEN11-1:8];
      `endif
      `ifdef SPI_DIVIDER_LEN_2411
        if (wb_sel_i11[0])
          divider11[7:0] <= #Tp11 wb_dat_i11[7:0];
        if (wb_sel_i11[1])
          divider11[15:8] <= #Tp11 wb_dat_i11[15:8];
        if (wb_sel_i11[2])
          divider11[`SPI_DIVIDER_LEN11-1:16] <= #Tp11 wb_dat_i11[`SPI_DIVIDER_LEN11-1:16];
      `endif
      `ifdef SPI_DIVIDER_LEN_3211
        if (wb_sel_i11[0])
          divider11[7:0] <= #Tp11 wb_dat_i11[7:0];
        if (wb_sel_i11[1])
          divider11[15:8] <= #Tp11 wb_dat_i11[15:8];
        if (wb_sel_i11[2])
          divider11[23:16] <= #Tp11 wb_dat_i11[23:16];
        if (wb_sel_i11[3])
          divider11[`SPI_DIVIDER_LEN11-1:24] <= #Tp11 wb_dat_i11[`SPI_DIVIDER_LEN11-1:24];
      `endif
      end
  end
  
  // Ctrl11 register
  always @(posedge wb_clk_i11 or posedge wb_rst_i11)
  begin
    if (wb_rst_i11)
      ctrl11 <= #Tp11 {`SPI_CTRL_BIT_NB11{1'b0}};
    else if(spi_ctrl_sel11 && wb_we_i11 && !tip11)
      begin
        if (wb_sel_i11[0])
          ctrl11[7:0] <= #Tp11 wb_dat_i11[7:0] | {7'b0, ctrl11[0]};
        if (wb_sel_i11[1])
          ctrl11[`SPI_CTRL_BIT_NB11-1:8] <= #Tp11 wb_dat_i11[`SPI_CTRL_BIT_NB11-1:8];
      end
    else if(tip11 && last_bit11 && pos_edge11)
      ctrl11[`SPI_CTRL_GO11] <= #Tp11 1'b0;
  end
  
  assign rx_negedge11 = ctrl11[`SPI_CTRL_RX_NEGEDGE11];
  assign tx_negedge11 = ctrl11[`SPI_CTRL_TX_NEGEDGE11];
  assign go11         = ctrl11[`SPI_CTRL_GO11];
  assign char_len11   = ctrl11[`SPI_CTRL_CHAR_LEN11];
  assign lsb        = ctrl11[`SPI_CTRL_LSB11];
  assign ie11         = ctrl11[`SPI_CTRL_IE11];
  assign ass11        = ctrl11[`SPI_CTRL_ASS11];
  
  // Slave11 select11 register
  always @(posedge wb_clk_i11 or posedge wb_rst_i11)
  begin
    if (wb_rst_i11)
      ss <= #Tp11 {`SPI_SS_NB11{1'b0}};
    else if(spi_ss_sel11 && wb_we_i11 && !tip11)
      begin
      `ifdef SPI_SS_NB_811
        if (wb_sel_i11[0])
          ss <= #Tp11 wb_dat_i11[`SPI_SS_NB11-1:0];
      `endif
      `ifdef SPI_SS_NB_1611
        if (wb_sel_i11[0])
          ss[7:0] <= #Tp11 wb_dat_i11[7:0];
        if (wb_sel_i11[1])
          ss[`SPI_SS_NB11-1:8] <= #Tp11 wb_dat_i11[`SPI_SS_NB11-1:8];
      `endif
      `ifdef SPI_SS_NB_2411
        if (wb_sel_i11[0])
          ss[7:0] <= #Tp11 wb_dat_i11[7:0];
        if (wb_sel_i11[1])
          ss[15:8] <= #Tp11 wb_dat_i11[15:8];
        if (wb_sel_i11[2])
          ss[`SPI_SS_NB11-1:16] <= #Tp11 wb_dat_i11[`SPI_SS_NB11-1:16];
      `endif
      `ifdef SPI_SS_NB_3211
        if (wb_sel_i11[0])
          ss[7:0] <= #Tp11 wb_dat_i11[7:0];
        if (wb_sel_i11[1])
          ss[15:8] <= #Tp11 wb_dat_i11[15:8];
        if (wb_sel_i11[2])
          ss[23:16] <= #Tp11 wb_dat_i11[23:16];
        if (wb_sel_i11[3])
          ss[`SPI_SS_NB11-1:24] <= #Tp11 wb_dat_i11[`SPI_SS_NB11-1:24];
      `endif
      end
  end
  
  assign ss_pad_o11 = ~((ss & {`SPI_SS_NB11{tip11 & ass11}}) | (ss & {`SPI_SS_NB11{!ass11}}));
  
  spi_clgen11 clgen11 (.clk_in11(wb_clk_i11), .rst11(wb_rst_i11), .go11(go11), .enable(tip11), .last_clk11(last_bit11),
                   .divider11(divider11), .clk_out11(sclk_pad_o11), .pos_edge11(pos_edge11), 
                   .neg_edge11(neg_edge11));
  
  spi_shift11 shift11 (.clk11(wb_clk_i11), .rst11(wb_rst_i11), .len(char_len11[`SPI_CHAR_LEN_BITS11-1:0]),
                   .latch11(spi_tx_sel11[3:0] & {4{wb_we_i11}}), .byte_sel11(wb_sel_i11), .lsb(lsb), 
                   .go11(go11), .pos_edge11(pos_edge11), .neg_edge11(neg_edge11), 
                   .rx_negedge11(rx_negedge11), .tx_negedge11(tx_negedge11),
                   .tip11(tip11), .last(last_bit11), 
                   .p_in11(wb_dat_i11), .p_out11(rx11), 
                   .s_clk11(sclk_pad_o11), .s_in11(miso_pad_i11), .s_out11(mosi_pad_o11));
endmodule
  
