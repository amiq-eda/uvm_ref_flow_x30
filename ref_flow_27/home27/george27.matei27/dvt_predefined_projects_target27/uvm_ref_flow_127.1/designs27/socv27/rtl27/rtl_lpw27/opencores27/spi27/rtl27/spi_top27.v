//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_top27.v                                                   ////
////                                                              ////
////  This27 file is part of the SPI27 IP27 core27 project27                ////
////  http27://www27.opencores27.org27/projects27/spi27/                      ////
////                                                              ////
////  Author27(s):                                                  ////
////      - Simon27 Srot27 (simons27@opencores27.org27)                     ////
////                                                              ////
////  All additional27 information is avaliable27 in the Readme27.txt27   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright27 (C) 2002 Authors27                                   ////
////                                                              ////
//// This27 source27 file may be used and distributed27 without         ////
//// restriction27 provided that this copyright27 statement27 is not    ////
//// removed from the file and that any derivative27 work27 contains27  ////
//// the original copyright27 notice27 and the associated disclaimer27. ////
////                                                              ////
//// This27 source27 file is free software27; you can redistribute27 it   ////
//// and/or modify it under the terms27 of the GNU27 Lesser27 General27   ////
//// Public27 License27 as published27 by the Free27 Software27 Foundation27; ////
//// either27 version27 2.1 of the License27, or (at your27 option) any   ////
//// later27 version27.                                               ////
////                                                              ////
//// This27 source27 is distributed27 in the hope27 that it will be       ////
//// useful27, but WITHOUT27 ANY27 WARRANTY27; without even27 the implied27   ////
//// warranty27 of MERCHANTABILITY27 or FITNESS27 FOR27 A PARTICULAR27      ////
//// PURPOSE27.  See the GNU27 Lesser27 General27 Public27 License27 for more ////
//// details27.                                                     ////
////                                                              ////
//// You should have received27 a copy of the GNU27 Lesser27 General27    ////
//// Public27 License27 along27 with this source27; if not, download27 it   ////
//// from http27://www27.opencores27.org27/lgpl27.shtml27                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////


`include "spi_defines27.v"
`include "timescale.v"

module spi_top27
(
  // Wishbone27 signals27
  wb_clk_i27, wb_rst_i27, wb_adr_i27, wb_dat_i27, wb_dat_o27, wb_sel_i27,
  wb_we_i27, wb_stb_i27, wb_cyc_i27, wb_ack_o27, wb_err_o27, wb_int_o27,

  // SPI27 signals27
  ss_pad_o27, sclk_pad_o27, mosi_pad_o27, miso_pad_i27
);

  parameter Tp27 = 1;

  // Wishbone27 signals27
  input                            wb_clk_i27;         // master27 clock27 input
  input                            wb_rst_i27;         // synchronous27 active high27 reset
  input                      [4:0] wb_adr_i27;         // lower27 address bits
  input                   [32-1:0] wb_dat_i27;         // databus27 input
  output                  [32-1:0] wb_dat_o27;         // databus27 output
  input                      [3:0] wb_sel_i27;         // byte select27 inputs27
  input                            wb_we_i27;          // write enable input
  input                            wb_stb_i27;         // stobe27/core27 select27 signal27
  input                            wb_cyc_i27;         // valid bus cycle input
  output                           wb_ack_o27;         // bus cycle acknowledge27 output
  output                           wb_err_o27;         // termination w/ error
  output                           wb_int_o27;         // interrupt27 request signal27 output
                                                     
  // SPI27 signals27                                     
  output          [`SPI_SS_NB27-1:0] ss_pad_o27;         // slave27 select27
  output                           sclk_pad_o27;       // serial27 clock27
  output                           mosi_pad_o27;       // master27 out slave27 in
  input                            miso_pad_i27;       // master27 in slave27 out
                                                     
  reg                     [32-1:0] wb_dat_o27;
  reg                              wb_ack_o27;
  reg                              wb_int_o27;
                                               
  // Internal signals27
  reg       [`SPI_DIVIDER_LEN27-1:0] divider27;          // Divider27 register
  reg       [`SPI_CTRL_BIT_NB27-1:0] ctrl27;             // Control27 and status register
  reg             [`SPI_SS_NB27-1:0] ss;               // Slave27 select27 register
  reg                     [32-1:0] wb_dat27;           // wb27 data out
  wire         [`SPI_MAX_CHAR27-1:0] rx27;               // Rx27 register
  wire                             rx_negedge27;       // miso27 is sampled27 on negative edge
  wire                             tx_negedge27;       // mosi27 is driven27 on negative edge
  wire    [`SPI_CHAR_LEN_BITS27-1:0] char_len27;         // char27 len
  wire                             go27;               // go27
  wire                             lsb;              // lsb first on line
  wire                             ie27;               // interrupt27 enable
  wire                             ass27;              // automatic slave27 select27
  wire                             spi_divider_sel27;  // divider27 register select27
  wire                             spi_ctrl_sel27;     // ctrl27 register select27
  wire                       [3:0] spi_tx_sel27;       // tx_l27 register select27
  wire                             spi_ss_sel27;       // ss register select27
  wire                             tip27;              // transfer27 in progress27
  wire                             pos_edge27;         // recognize27 posedge of sclk27
  wire                             neg_edge27;         // recognize27 negedge of sclk27
  wire                             last_bit27;         // marks27 last character27 bit
  
  // Address decoder27
  assign spi_divider_sel27 = wb_cyc_i27 & wb_stb_i27 & (wb_adr_i27[`SPI_OFS_BITS27] == `SPI_DEVIDE27);
  assign spi_ctrl_sel27    = wb_cyc_i27 & wb_stb_i27 & (wb_adr_i27[`SPI_OFS_BITS27] == `SPI_CTRL27);
  assign spi_tx_sel27[0]   = wb_cyc_i27 & wb_stb_i27 & (wb_adr_i27[`SPI_OFS_BITS27] == `SPI_TX_027);
  assign spi_tx_sel27[1]   = wb_cyc_i27 & wb_stb_i27 & (wb_adr_i27[`SPI_OFS_BITS27] == `SPI_TX_127);
  assign spi_tx_sel27[2]   = wb_cyc_i27 & wb_stb_i27 & (wb_adr_i27[`SPI_OFS_BITS27] == `SPI_TX_227);
  assign spi_tx_sel27[3]   = wb_cyc_i27 & wb_stb_i27 & (wb_adr_i27[`SPI_OFS_BITS27] == `SPI_TX_327);
  assign spi_ss_sel27      = wb_cyc_i27 & wb_stb_i27 & (wb_adr_i27[`SPI_OFS_BITS27] == `SPI_SS27);
  
  // Read from registers
  always @(wb_adr_i27 or rx27 or ctrl27 or divider27 or ss)
  begin
    case (wb_adr_i27[`SPI_OFS_BITS27])
`ifdef SPI_MAX_CHAR_12827
      `SPI_RX_027:    wb_dat27 = rx27[31:0];
      `SPI_RX_127:    wb_dat27 = rx27[63:32];
      `SPI_RX_227:    wb_dat27 = rx27[95:64];
      `SPI_RX_327:    wb_dat27 = {{128-`SPI_MAX_CHAR27{1'b0}}, rx27[`SPI_MAX_CHAR27-1:96]};
`else
`ifdef SPI_MAX_CHAR_6427
      `SPI_RX_027:    wb_dat27 = rx27[31:0];
      `SPI_RX_127:    wb_dat27 = {{64-`SPI_MAX_CHAR27{1'b0}}, rx27[`SPI_MAX_CHAR27-1:32]};
      `SPI_RX_227:    wb_dat27 = 32'b0;
      `SPI_RX_327:    wb_dat27 = 32'b0;
`else
      `SPI_RX_027:    wb_dat27 = {{32-`SPI_MAX_CHAR27{1'b0}}, rx27[`SPI_MAX_CHAR27-1:0]};
      `SPI_RX_127:    wb_dat27 = 32'b0;
      `SPI_RX_227:    wb_dat27 = 32'b0;
      `SPI_RX_327:    wb_dat27 = 32'b0;
`endif
`endif
      `SPI_CTRL27:    wb_dat27 = {{32-`SPI_CTRL_BIT_NB27{1'b0}}, ctrl27};
      `SPI_DEVIDE27:  wb_dat27 = {{32-`SPI_DIVIDER_LEN27{1'b0}}, divider27};
      `SPI_SS27:      wb_dat27 = {{32-`SPI_SS_NB27{1'b0}}, ss};
      default:      wb_dat27 = 32'bx;
    endcase
  end
  
  // Wb27 data out
  always @(posedge wb_clk_i27 or posedge wb_rst_i27)
  begin
    if (wb_rst_i27)
      wb_dat_o27 <= #Tp27 32'b0;
    else
      wb_dat_o27 <= #Tp27 wb_dat27;
  end
  
  // Wb27 acknowledge27
  always @(posedge wb_clk_i27 or posedge wb_rst_i27)
  begin
    if (wb_rst_i27)
      wb_ack_o27 <= #Tp27 1'b0;
    else
      wb_ack_o27 <= #Tp27 wb_cyc_i27 & wb_stb_i27 & ~wb_ack_o27;
  end
  
  // Wb27 error
  assign wb_err_o27 = 1'b0;
  
  // Interrupt27
  always @(posedge wb_clk_i27 or posedge wb_rst_i27)
  begin
    if (wb_rst_i27)
      wb_int_o27 <= #Tp27 1'b0;
    else if (ie27 && tip27 && last_bit27 && pos_edge27)
      wb_int_o27 <= #Tp27 1'b1;
    else if (wb_ack_o27)
      wb_int_o27 <= #Tp27 1'b0;
  end
  
  // Divider27 register
  always @(posedge wb_clk_i27 or posedge wb_rst_i27)
  begin
    if (wb_rst_i27)
        divider27 <= #Tp27 {`SPI_DIVIDER_LEN27{1'b0}};
    else if (spi_divider_sel27 && wb_we_i27 && !tip27)
      begin
      `ifdef SPI_DIVIDER_LEN_827
        if (wb_sel_i27[0])
          divider27 <= #Tp27 wb_dat_i27[`SPI_DIVIDER_LEN27-1:0];
      `endif
      `ifdef SPI_DIVIDER_LEN_1627
        if (wb_sel_i27[0])
          divider27[7:0] <= #Tp27 wb_dat_i27[7:0];
        if (wb_sel_i27[1])
          divider27[`SPI_DIVIDER_LEN27-1:8] <= #Tp27 wb_dat_i27[`SPI_DIVIDER_LEN27-1:8];
      `endif
      `ifdef SPI_DIVIDER_LEN_2427
        if (wb_sel_i27[0])
          divider27[7:0] <= #Tp27 wb_dat_i27[7:0];
        if (wb_sel_i27[1])
          divider27[15:8] <= #Tp27 wb_dat_i27[15:8];
        if (wb_sel_i27[2])
          divider27[`SPI_DIVIDER_LEN27-1:16] <= #Tp27 wb_dat_i27[`SPI_DIVIDER_LEN27-1:16];
      `endif
      `ifdef SPI_DIVIDER_LEN_3227
        if (wb_sel_i27[0])
          divider27[7:0] <= #Tp27 wb_dat_i27[7:0];
        if (wb_sel_i27[1])
          divider27[15:8] <= #Tp27 wb_dat_i27[15:8];
        if (wb_sel_i27[2])
          divider27[23:16] <= #Tp27 wb_dat_i27[23:16];
        if (wb_sel_i27[3])
          divider27[`SPI_DIVIDER_LEN27-1:24] <= #Tp27 wb_dat_i27[`SPI_DIVIDER_LEN27-1:24];
      `endif
      end
  end
  
  // Ctrl27 register
  always @(posedge wb_clk_i27 or posedge wb_rst_i27)
  begin
    if (wb_rst_i27)
      ctrl27 <= #Tp27 {`SPI_CTRL_BIT_NB27{1'b0}};
    else if(spi_ctrl_sel27 && wb_we_i27 && !tip27)
      begin
        if (wb_sel_i27[0])
          ctrl27[7:0] <= #Tp27 wb_dat_i27[7:0] | {7'b0, ctrl27[0]};
        if (wb_sel_i27[1])
          ctrl27[`SPI_CTRL_BIT_NB27-1:8] <= #Tp27 wb_dat_i27[`SPI_CTRL_BIT_NB27-1:8];
      end
    else if(tip27 && last_bit27 && pos_edge27)
      ctrl27[`SPI_CTRL_GO27] <= #Tp27 1'b0;
  end
  
  assign rx_negedge27 = ctrl27[`SPI_CTRL_RX_NEGEDGE27];
  assign tx_negedge27 = ctrl27[`SPI_CTRL_TX_NEGEDGE27];
  assign go27         = ctrl27[`SPI_CTRL_GO27];
  assign char_len27   = ctrl27[`SPI_CTRL_CHAR_LEN27];
  assign lsb        = ctrl27[`SPI_CTRL_LSB27];
  assign ie27         = ctrl27[`SPI_CTRL_IE27];
  assign ass27        = ctrl27[`SPI_CTRL_ASS27];
  
  // Slave27 select27 register
  always @(posedge wb_clk_i27 or posedge wb_rst_i27)
  begin
    if (wb_rst_i27)
      ss <= #Tp27 {`SPI_SS_NB27{1'b0}};
    else if(spi_ss_sel27 && wb_we_i27 && !tip27)
      begin
      `ifdef SPI_SS_NB_827
        if (wb_sel_i27[0])
          ss <= #Tp27 wb_dat_i27[`SPI_SS_NB27-1:0];
      `endif
      `ifdef SPI_SS_NB_1627
        if (wb_sel_i27[0])
          ss[7:0] <= #Tp27 wb_dat_i27[7:0];
        if (wb_sel_i27[1])
          ss[`SPI_SS_NB27-1:8] <= #Tp27 wb_dat_i27[`SPI_SS_NB27-1:8];
      `endif
      `ifdef SPI_SS_NB_2427
        if (wb_sel_i27[0])
          ss[7:0] <= #Tp27 wb_dat_i27[7:0];
        if (wb_sel_i27[1])
          ss[15:8] <= #Tp27 wb_dat_i27[15:8];
        if (wb_sel_i27[2])
          ss[`SPI_SS_NB27-1:16] <= #Tp27 wb_dat_i27[`SPI_SS_NB27-1:16];
      `endif
      `ifdef SPI_SS_NB_3227
        if (wb_sel_i27[0])
          ss[7:0] <= #Tp27 wb_dat_i27[7:0];
        if (wb_sel_i27[1])
          ss[15:8] <= #Tp27 wb_dat_i27[15:8];
        if (wb_sel_i27[2])
          ss[23:16] <= #Tp27 wb_dat_i27[23:16];
        if (wb_sel_i27[3])
          ss[`SPI_SS_NB27-1:24] <= #Tp27 wb_dat_i27[`SPI_SS_NB27-1:24];
      `endif
      end
  end
  
  assign ss_pad_o27 = ~((ss & {`SPI_SS_NB27{tip27 & ass27}}) | (ss & {`SPI_SS_NB27{!ass27}}));
  
  spi_clgen27 clgen27 (.clk_in27(wb_clk_i27), .rst27(wb_rst_i27), .go27(go27), .enable(tip27), .last_clk27(last_bit27),
                   .divider27(divider27), .clk_out27(sclk_pad_o27), .pos_edge27(pos_edge27), 
                   .neg_edge27(neg_edge27));
  
  spi_shift27 shift27 (.clk27(wb_clk_i27), .rst27(wb_rst_i27), .len(char_len27[`SPI_CHAR_LEN_BITS27-1:0]),
                   .latch27(spi_tx_sel27[3:0] & {4{wb_we_i27}}), .byte_sel27(wb_sel_i27), .lsb(lsb), 
                   .go27(go27), .pos_edge27(pos_edge27), .neg_edge27(neg_edge27), 
                   .rx_negedge27(rx_negedge27), .tx_negedge27(tx_negedge27),
                   .tip27(tip27), .last(last_bit27), 
                   .p_in27(wb_dat_i27), .p_out27(rx27), 
                   .s_clk27(sclk_pad_o27), .s_in27(miso_pad_i27), .s_out27(mosi_pad_o27));
endmodule
  
