//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_top6.v                                                   ////
////                                                              ////
////  This6 file is part of the SPI6 IP6 core6 project6                ////
////  http6://www6.opencores6.org6/projects6/spi6/                      ////
////                                                              ////
////  Author6(s):                                                  ////
////      - Simon6 Srot6 (simons6@opencores6.org6)                     ////
////                                                              ////
////  All additional6 information is avaliable6 in the Readme6.txt6   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright6 (C) 2002 Authors6                                   ////
////                                                              ////
//// This6 source6 file may be used and distributed6 without         ////
//// restriction6 provided that this copyright6 statement6 is not    ////
//// removed from the file and that any derivative6 work6 contains6  ////
//// the original copyright6 notice6 and the associated disclaimer6. ////
////                                                              ////
//// This6 source6 file is free software6; you can redistribute6 it   ////
//// and/or modify it under the terms6 of the GNU6 Lesser6 General6   ////
//// Public6 License6 as published6 by the Free6 Software6 Foundation6; ////
//// either6 version6 2.1 of the License6, or (at your6 option) any   ////
//// later6 version6.                                               ////
////                                                              ////
//// This6 source6 is distributed6 in the hope6 that it will be       ////
//// useful6, but WITHOUT6 ANY6 WARRANTY6; without even6 the implied6   ////
//// warranty6 of MERCHANTABILITY6 or FITNESS6 FOR6 A PARTICULAR6      ////
//// PURPOSE6.  See the GNU6 Lesser6 General6 Public6 License6 for more ////
//// details6.                                                     ////
////                                                              ////
//// You should have received6 a copy of the GNU6 Lesser6 General6    ////
//// Public6 License6 along6 with this source6; if not, download6 it   ////
//// from http6://www6.opencores6.org6/lgpl6.shtml6                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////


`include "spi_defines6.v"
`include "timescale.v"

module spi_top6
(
  // Wishbone6 signals6
  wb_clk_i6, wb_rst_i6, wb_adr_i6, wb_dat_i6, wb_dat_o6, wb_sel_i6,
  wb_we_i6, wb_stb_i6, wb_cyc_i6, wb_ack_o6, wb_err_o6, wb_int_o6,

  // SPI6 signals6
  ss_pad_o6, sclk_pad_o6, mosi_pad_o6, miso_pad_i6
);

  parameter Tp6 = 1;

  // Wishbone6 signals6
  input                            wb_clk_i6;         // master6 clock6 input
  input                            wb_rst_i6;         // synchronous6 active high6 reset
  input                      [4:0] wb_adr_i6;         // lower6 address bits
  input                   [32-1:0] wb_dat_i6;         // databus6 input
  output                  [32-1:0] wb_dat_o6;         // databus6 output
  input                      [3:0] wb_sel_i6;         // byte select6 inputs6
  input                            wb_we_i6;          // write enable input
  input                            wb_stb_i6;         // stobe6/core6 select6 signal6
  input                            wb_cyc_i6;         // valid bus cycle input
  output                           wb_ack_o6;         // bus cycle acknowledge6 output
  output                           wb_err_o6;         // termination w/ error
  output                           wb_int_o6;         // interrupt6 request signal6 output
                                                     
  // SPI6 signals6                                     
  output          [`SPI_SS_NB6-1:0] ss_pad_o6;         // slave6 select6
  output                           sclk_pad_o6;       // serial6 clock6
  output                           mosi_pad_o6;       // master6 out slave6 in
  input                            miso_pad_i6;       // master6 in slave6 out
                                                     
  reg                     [32-1:0] wb_dat_o6;
  reg                              wb_ack_o6;
  reg                              wb_int_o6;
                                               
  // Internal signals6
  reg       [`SPI_DIVIDER_LEN6-1:0] divider6;          // Divider6 register
  reg       [`SPI_CTRL_BIT_NB6-1:0] ctrl6;             // Control6 and status register
  reg             [`SPI_SS_NB6-1:0] ss;               // Slave6 select6 register
  reg                     [32-1:0] wb_dat6;           // wb6 data out
  wire         [`SPI_MAX_CHAR6-1:0] rx6;               // Rx6 register
  wire                             rx_negedge6;       // miso6 is sampled6 on negative edge
  wire                             tx_negedge6;       // mosi6 is driven6 on negative edge
  wire    [`SPI_CHAR_LEN_BITS6-1:0] char_len6;         // char6 len
  wire                             go6;               // go6
  wire                             lsb;              // lsb first on line
  wire                             ie6;               // interrupt6 enable
  wire                             ass6;              // automatic slave6 select6
  wire                             spi_divider_sel6;  // divider6 register select6
  wire                             spi_ctrl_sel6;     // ctrl6 register select6
  wire                       [3:0] spi_tx_sel6;       // tx_l6 register select6
  wire                             spi_ss_sel6;       // ss register select6
  wire                             tip6;              // transfer6 in progress6
  wire                             pos_edge6;         // recognize6 posedge of sclk6
  wire                             neg_edge6;         // recognize6 negedge of sclk6
  wire                             last_bit6;         // marks6 last character6 bit
  
  // Address decoder6
  assign spi_divider_sel6 = wb_cyc_i6 & wb_stb_i6 & (wb_adr_i6[`SPI_OFS_BITS6] == `SPI_DEVIDE6);
  assign spi_ctrl_sel6    = wb_cyc_i6 & wb_stb_i6 & (wb_adr_i6[`SPI_OFS_BITS6] == `SPI_CTRL6);
  assign spi_tx_sel6[0]   = wb_cyc_i6 & wb_stb_i6 & (wb_adr_i6[`SPI_OFS_BITS6] == `SPI_TX_06);
  assign spi_tx_sel6[1]   = wb_cyc_i6 & wb_stb_i6 & (wb_adr_i6[`SPI_OFS_BITS6] == `SPI_TX_16);
  assign spi_tx_sel6[2]   = wb_cyc_i6 & wb_stb_i6 & (wb_adr_i6[`SPI_OFS_BITS6] == `SPI_TX_26);
  assign spi_tx_sel6[3]   = wb_cyc_i6 & wb_stb_i6 & (wb_adr_i6[`SPI_OFS_BITS6] == `SPI_TX_36);
  assign spi_ss_sel6      = wb_cyc_i6 & wb_stb_i6 & (wb_adr_i6[`SPI_OFS_BITS6] == `SPI_SS6);
  
  // Read from registers
  always @(wb_adr_i6 or rx6 or ctrl6 or divider6 or ss)
  begin
    case (wb_adr_i6[`SPI_OFS_BITS6])
`ifdef SPI_MAX_CHAR_1286
      `SPI_RX_06:    wb_dat6 = rx6[31:0];
      `SPI_RX_16:    wb_dat6 = rx6[63:32];
      `SPI_RX_26:    wb_dat6 = rx6[95:64];
      `SPI_RX_36:    wb_dat6 = {{128-`SPI_MAX_CHAR6{1'b0}}, rx6[`SPI_MAX_CHAR6-1:96]};
`else
`ifdef SPI_MAX_CHAR_646
      `SPI_RX_06:    wb_dat6 = rx6[31:0];
      `SPI_RX_16:    wb_dat6 = {{64-`SPI_MAX_CHAR6{1'b0}}, rx6[`SPI_MAX_CHAR6-1:32]};
      `SPI_RX_26:    wb_dat6 = 32'b0;
      `SPI_RX_36:    wb_dat6 = 32'b0;
`else
      `SPI_RX_06:    wb_dat6 = {{32-`SPI_MAX_CHAR6{1'b0}}, rx6[`SPI_MAX_CHAR6-1:0]};
      `SPI_RX_16:    wb_dat6 = 32'b0;
      `SPI_RX_26:    wb_dat6 = 32'b0;
      `SPI_RX_36:    wb_dat6 = 32'b0;
`endif
`endif
      `SPI_CTRL6:    wb_dat6 = {{32-`SPI_CTRL_BIT_NB6{1'b0}}, ctrl6};
      `SPI_DEVIDE6:  wb_dat6 = {{32-`SPI_DIVIDER_LEN6{1'b0}}, divider6};
      `SPI_SS6:      wb_dat6 = {{32-`SPI_SS_NB6{1'b0}}, ss};
      default:      wb_dat6 = 32'bx;
    endcase
  end
  
  // Wb6 data out
  always @(posedge wb_clk_i6 or posedge wb_rst_i6)
  begin
    if (wb_rst_i6)
      wb_dat_o6 <= #Tp6 32'b0;
    else
      wb_dat_o6 <= #Tp6 wb_dat6;
  end
  
  // Wb6 acknowledge6
  always @(posedge wb_clk_i6 or posedge wb_rst_i6)
  begin
    if (wb_rst_i6)
      wb_ack_o6 <= #Tp6 1'b0;
    else
      wb_ack_o6 <= #Tp6 wb_cyc_i6 & wb_stb_i6 & ~wb_ack_o6;
  end
  
  // Wb6 error
  assign wb_err_o6 = 1'b0;
  
  // Interrupt6
  always @(posedge wb_clk_i6 or posedge wb_rst_i6)
  begin
    if (wb_rst_i6)
      wb_int_o6 <= #Tp6 1'b0;
    else if (ie6 && tip6 && last_bit6 && pos_edge6)
      wb_int_o6 <= #Tp6 1'b1;
    else if (wb_ack_o6)
      wb_int_o6 <= #Tp6 1'b0;
  end
  
  // Divider6 register
  always @(posedge wb_clk_i6 or posedge wb_rst_i6)
  begin
    if (wb_rst_i6)
        divider6 <= #Tp6 {`SPI_DIVIDER_LEN6{1'b0}};
    else if (spi_divider_sel6 && wb_we_i6 && !tip6)
      begin
      `ifdef SPI_DIVIDER_LEN_86
        if (wb_sel_i6[0])
          divider6 <= #Tp6 wb_dat_i6[`SPI_DIVIDER_LEN6-1:0];
      `endif
      `ifdef SPI_DIVIDER_LEN_166
        if (wb_sel_i6[0])
          divider6[7:0] <= #Tp6 wb_dat_i6[7:0];
        if (wb_sel_i6[1])
          divider6[`SPI_DIVIDER_LEN6-1:8] <= #Tp6 wb_dat_i6[`SPI_DIVIDER_LEN6-1:8];
      `endif
      `ifdef SPI_DIVIDER_LEN_246
        if (wb_sel_i6[0])
          divider6[7:0] <= #Tp6 wb_dat_i6[7:0];
        if (wb_sel_i6[1])
          divider6[15:8] <= #Tp6 wb_dat_i6[15:8];
        if (wb_sel_i6[2])
          divider6[`SPI_DIVIDER_LEN6-1:16] <= #Tp6 wb_dat_i6[`SPI_DIVIDER_LEN6-1:16];
      `endif
      `ifdef SPI_DIVIDER_LEN_326
        if (wb_sel_i6[0])
          divider6[7:0] <= #Tp6 wb_dat_i6[7:0];
        if (wb_sel_i6[1])
          divider6[15:8] <= #Tp6 wb_dat_i6[15:8];
        if (wb_sel_i6[2])
          divider6[23:16] <= #Tp6 wb_dat_i6[23:16];
        if (wb_sel_i6[3])
          divider6[`SPI_DIVIDER_LEN6-1:24] <= #Tp6 wb_dat_i6[`SPI_DIVIDER_LEN6-1:24];
      `endif
      end
  end
  
  // Ctrl6 register
  always @(posedge wb_clk_i6 or posedge wb_rst_i6)
  begin
    if (wb_rst_i6)
      ctrl6 <= #Tp6 {`SPI_CTRL_BIT_NB6{1'b0}};
    else if(spi_ctrl_sel6 && wb_we_i6 && !tip6)
      begin
        if (wb_sel_i6[0])
          ctrl6[7:0] <= #Tp6 wb_dat_i6[7:0] | {7'b0, ctrl6[0]};
        if (wb_sel_i6[1])
          ctrl6[`SPI_CTRL_BIT_NB6-1:8] <= #Tp6 wb_dat_i6[`SPI_CTRL_BIT_NB6-1:8];
      end
    else if(tip6 && last_bit6 && pos_edge6)
      ctrl6[`SPI_CTRL_GO6] <= #Tp6 1'b0;
  end
  
  assign rx_negedge6 = ctrl6[`SPI_CTRL_RX_NEGEDGE6];
  assign tx_negedge6 = ctrl6[`SPI_CTRL_TX_NEGEDGE6];
  assign go6         = ctrl6[`SPI_CTRL_GO6];
  assign char_len6   = ctrl6[`SPI_CTRL_CHAR_LEN6];
  assign lsb        = ctrl6[`SPI_CTRL_LSB6];
  assign ie6         = ctrl6[`SPI_CTRL_IE6];
  assign ass6        = ctrl6[`SPI_CTRL_ASS6];
  
  // Slave6 select6 register
  always @(posedge wb_clk_i6 or posedge wb_rst_i6)
  begin
    if (wb_rst_i6)
      ss <= #Tp6 {`SPI_SS_NB6{1'b0}};
    else if(spi_ss_sel6 && wb_we_i6 && !tip6)
      begin
      `ifdef SPI_SS_NB_86
        if (wb_sel_i6[0])
          ss <= #Tp6 wb_dat_i6[`SPI_SS_NB6-1:0];
      `endif
      `ifdef SPI_SS_NB_166
        if (wb_sel_i6[0])
          ss[7:0] <= #Tp6 wb_dat_i6[7:0];
        if (wb_sel_i6[1])
          ss[`SPI_SS_NB6-1:8] <= #Tp6 wb_dat_i6[`SPI_SS_NB6-1:8];
      `endif
      `ifdef SPI_SS_NB_246
        if (wb_sel_i6[0])
          ss[7:0] <= #Tp6 wb_dat_i6[7:0];
        if (wb_sel_i6[1])
          ss[15:8] <= #Tp6 wb_dat_i6[15:8];
        if (wb_sel_i6[2])
          ss[`SPI_SS_NB6-1:16] <= #Tp6 wb_dat_i6[`SPI_SS_NB6-1:16];
      `endif
      `ifdef SPI_SS_NB_326
        if (wb_sel_i6[0])
          ss[7:0] <= #Tp6 wb_dat_i6[7:0];
        if (wb_sel_i6[1])
          ss[15:8] <= #Tp6 wb_dat_i6[15:8];
        if (wb_sel_i6[2])
          ss[23:16] <= #Tp6 wb_dat_i6[23:16];
        if (wb_sel_i6[3])
          ss[`SPI_SS_NB6-1:24] <= #Tp6 wb_dat_i6[`SPI_SS_NB6-1:24];
      `endif
      end
  end
  
  assign ss_pad_o6 = ~((ss & {`SPI_SS_NB6{tip6 & ass6}}) | (ss & {`SPI_SS_NB6{!ass6}}));
  
  spi_clgen6 clgen6 (.clk_in6(wb_clk_i6), .rst6(wb_rst_i6), .go6(go6), .enable(tip6), .last_clk6(last_bit6),
                   .divider6(divider6), .clk_out6(sclk_pad_o6), .pos_edge6(pos_edge6), 
                   .neg_edge6(neg_edge6));
  
  spi_shift6 shift6 (.clk6(wb_clk_i6), .rst6(wb_rst_i6), .len(char_len6[`SPI_CHAR_LEN_BITS6-1:0]),
                   .latch6(spi_tx_sel6[3:0] & {4{wb_we_i6}}), .byte_sel6(wb_sel_i6), .lsb(lsb), 
                   .go6(go6), .pos_edge6(pos_edge6), .neg_edge6(neg_edge6), 
                   .rx_negedge6(rx_negedge6), .tx_negedge6(tx_negedge6),
                   .tip6(tip6), .last(last_bit6), 
                   .p_in6(wb_dat_i6), .p_out6(rx6), 
                   .s_clk6(sclk_pad_o6), .s_in6(miso_pad_i6), .s_out6(mosi_pad_o6));
endmodule
  
