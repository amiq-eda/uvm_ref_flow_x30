//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_top5.v                                                   ////
////                                                              ////
////  This5 file is part of the SPI5 IP5 core5 project5                ////
////  http5://www5.opencores5.org5/projects5/spi5/                      ////
////                                                              ////
////  Author5(s):                                                  ////
////      - Simon5 Srot5 (simons5@opencores5.org5)                     ////
////                                                              ////
////  All additional5 information is avaliable5 in the Readme5.txt5   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright5 (C) 2002 Authors5                                   ////
////                                                              ////
//// This5 source5 file may be used and distributed5 without         ////
//// restriction5 provided that this copyright5 statement5 is not    ////
//// removed from the file and that any derivative5 work5 contains5  ////
//// the original copyright5 notice5 and the associated disclaimer5. ////
////                                                              ////
//// This5 source5 file is free software5; you can redistribute5 it   ////
//// and/or modify it under the terms5 of the GNU5 Lesser5 General5   ////
//// Public5 License5 as published5 by the Free5 Software5 Foundation5; ////
//// either5 version5 2.1 of the License5, or (at your5 option) any   ////
//// later5 version5.                                               ////
////                                                              ////
//// This5 source5 is distributed5 in the hope5 that it will be       ////
//// useful5, but WITHOUT5 ANY5 WARRANTY5; without even5 the implied5   ////
//// warranty5 of MERCHANTABILITY5 or FITNESS5 FOR5 A PARTICULAR5      ////
//// PURPOSE5.  See the GNU5 Lesser5 General5 Public5 License5 for more ////
//// details5.                                                     ////
////                                                              ////
//// You should have received5 a copy of the GNU5 Lesser5 General5    ////
//// Public5 License5 along5 with this source5; if not, download5 it   ////
//// from http5://www5.opencores5.org5/lgpl5.shtml5                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////


`include "spi_defines5.v"
`include "timescale.v"

module spi_top5
(
  // Wishbone5 signals5
  wb_clk_i5, wb_rst_i5, wb_adr_i5, wb_dat_i5, wb_dat_o5, wb_sel_i5,
  wb_we_i5, wb_stb_i5, wb_cyc_i5, wb_ack_o5, wb_err_o5, wb_int_o5,

  // SPI5 signals5
  ss_pad_o5, sclk_pad_o5, mosi_pad_o5, miso_pad_i5
);

  parameter Tp5 = 1;

  // Wishbone5 signals5
  input                            wb_clk_i5;         // master5 clock5 input
  input                            wb_rst_i5;         // synchronous5 active high5 reset
  input                      [4:0] wb_adr_i5;         // lower5 address bits
  input                   [32-1:0] wb_dat_i5;         // databus5 input
  output                  [32-1:0] wb_dat_o5;         // databus5 output
  input                      [3:0] wb_sel_i5;         // byte select5 inputs5
  input                            wb_we_i5;          // write enable input
  input                            wb_stb_i5;         // stobe5/core5 select5 signal5
  input                            wb_cyc_i5;         // valid bus cycle input
  output                           wb_ack_o5;         // bus cycle acknowledge5 output
  output                           wb_err_o5;         // termination w/ error
  output                           wb_int_o5;         // interrupt5 request signal5 output
                                                     
  // SPI5 signals5                                     
  output          [`SPI_SS_NB5-1:0] ss_pad_o5;         // slave5 select5
  output                           sclk_pad_o5;       // serial5 clock5
  output                           mosi_pad_o5;       // master5 out slave5 in
  input                            miso_pad_i5;       // master5 in slave5 out
                                                     
  reg                     [32-1:0] wb_dat_o5;
  reg                              wb_ack_o5;
  reg                              wb_int_o5;
                                               
  // Internal signals5
  reg       [`SPI_DIVIDER_LEN5-1:0] divider5;          // Divider5 register
  reg       [`SPI_CTRL_BIT_NB5-1:0] ctrl5;             // Control5 and status register
  reg             [`SPI_SS_NB5-1:0] ss;               // Slave5 select5 register
  reg                     [32-1:0] wb_dat5;           // wb5 data out
  wire         [`SPI_MAX_CHAR5-1:0] rx5;               // Rx5 register
  wire                             rx_negedge5;       // miso5 is sampled5 on negative edge
  wire                             tx_negedge5;       // mosi5 is driven5 on negative edge
  wire    [`SPI_CHAR_LEN_BITS5-1:0] char_len5;         // char5 len
  wire                             go5;               // go5
  wire                             lsb;              // lsb first on line
  wire                             ie5;               // interrupt5 enable
  wire                             ass5;              // automatic slave5 select5
  wire                             spi_divider_sel5;  // divider5 register select5
  wire                             spi_ctrl_sel5;     // ctrl5 register select5
  wire                       [3:0] spi_tx_sel5;       // tx_l5 register select5
  wire                             spi_ss_sel5;       // ss register select5
  wire                             tip5;              // transfer5 in progress5
  wire                             pos_edge5;         // recognize5 posedge of sclk5
  wire                             neg_edge5;         // recognize5 negedge of sclk5
  wire                             last_bit5;         // marks5 last character5 bit
  
  // Address decoder5
  assign spi_divider_sel5 = wb_cyc_i5 & wb_stb_i5 & (wb_adr_i5[`SPI_OFS_BITS5] == `SPI_DEVIDE5);
  assign spi_ctrl_sel5    = wb_cyc_i5 & wb_stb_i5 & (wb_adr_i5[`SPI_OFS_BITS5] == `SPI_CTRL5);
  assign spi_tx_sel5[0]   = wb_cyc_i5 & wb_stb_i5 & (wb_adr_i5[`SPI_OFS_BITS5] == `SPI_TX_05);
  assign spi_tx_sel5[1]   = wb_cyc_i5 & wb_stb_i5 & (wb_adr_i5[`SPI_OFS_BITS5] == `SPI_TX_15);
  assign spi_tx_sel5[2]   = wb_cyc_i5 & wb_stb_i5 & (wb_adr_i5[`SPI_OFS_BITS5] == `SPI_TX_25);
  assign spi_tx_sel5[3]   = wb_cyc_i5 & wb_stb_i5 & (wb_adr_i5[`SPI_OFS_BITS5] == `SPI_TX_35);
  assign spi_ss_sel5      = wb_cyc_i5 & wb_stb_i5 & (wb_adr_i5[`SPI_OFS_BITS5] == `SPI_SS5);
  
  // Read from registers
  always @(wb_adr_i5 or rx5 or ctrl5 or divider5 or ss)
  begin
    case (wb_adr_i5[`SPI_OFS_BITS5])
`ifdef SPI_MAX_CHAR_1285
      `SPI_RX_05:    wb_dat5 = rx5[31:0];
      `SPI_RX_15:    wb_dat5 = rx5[63:32];
      `SPI_RX_25:    wb_dat5 = rx5[95:64];
      `SPI_RX_35:    wb_dat5 = {{128-`SPI_MAX_CHAR5{1'b0}}, rx5[`SPI_MAX_CHAR5-1:96]};
`else
`ifdef SPI_MAX_CHAR_645
      `SPI_RX_05:    wb_dat5 = rx5[31:0];
      `SPI_RX_15:    wb_dat5 = {{64-`SPI_MAX_CHAR5{1'b0}}, rx5[`SPI_MAX_CHAR5-1:32]};
      `SPI_RX_25:    wb_dat5 = 32'b0;
      `SPI_RX_35:    wb_dat5 = 32'b0;
`else
      `SPI_RX_05:    wb_dat5 = {{32-`SPI_MAX_CHAR5{1'b0}}, rx5[`SPI_MAX_CHAR5-1:0]};
      `SPI_RX_15:    wb_dat5 = 32'b0;
      `SPI_RX_25:    wb_dat5 = 32'b0;
      `SPI_RX_35:    wb_dat5 = 32'b0;
`endif
`endif
      `SPI_CTRL5:    wb_dat5 = {{32-`SPI_CTRL_BIT_NB5{1'b0}}, ctrl5};
      `SPI_DEVIDE5:  wb_dat5 = {{32-`SPI_DIVIDER_LEN5{1'b0}}, divider5};
      `SPI_SS5:      wb_dat5 = {{32-`SPI_SS_NB5{1'b0}}, ss};
      default:      wb_dat5 = 32'bx;
    endcase
  end
  
  // Wb5 data out
  always @(posedge wb_clk_i5 or posedge wb_rst_i5)
  begin
    if (wb_rst_i5)
      wb_dat_o5 <= #Tp5 32'b0;
    else
      wb_dat_o5 <= #Tp5 wb_dat5;
  end
  
  // Wb5 acknowledge5
  always @(posedge wb_clk_i5 or posedge wb_rst_i5)
  begin
    if (wb_rst_i5)
      wb_ack_o5 <= #Tp5 1'b0;
    else
      wb_ack_o5 <= #Tp5 wb_cyc_i5 & wb_stb_i5 & ~wb_ack_o5;
  end
  
  // Wb5 error
  assign wb_err_o5 = 1'b0;
  
  // Interrupt5
  always @(posedge wb_clk_i5 or posedge wb_rst_i5)
  begin
    if (wb_rst_i5)
      wb_int_o5 <= #Tp5 1'b0;
    else if (ie5 && tip5 && last_bit5 && pos_edge5)
      wb_int_o5 <= #Tp5 1'b1;
    else if (wb_ack_o5)
      wb_int_o5 <= #Tp5 1'b0;
  end
  
  // Divider5 register
  always @(posedge wb_clk_i5 or posedge wb_rst_i5)
  begin
    if (wb_rst_i5)
        divider5 <= #Tp5 {`SPI_DIVIDER_LEN5{1'b0}};
    else if (spi_divider_sel5 && wb_we_i5 && !tip5)
      begin
      `ifdef SPI_DIVIDER_LEN_85
        if (wb_sel_i5[0])
          divider5 <= #Tp5 wb_dat_i5[`SPI_DIVIDER_LEN5-1:0];
      `endif
      `ifdef SPI_DIVIDER_LEN_165
        if (wb_sel_i5[0])
          divider5[7:0] <= #Tp5 wb_dat_i5[7:0];
        if (wb_sel_i5[1])
          divider5[`SPI_DIVIDER_LEN5-1:8] <= #Tp5 wb_dat_i5[`SPI_DIVIDER_LEN5-1:8];
      `endif
      `ifdef SPI_DIVIDER_LEN_245
        if (wb_sel_i5[0])
          divider5[7:0] <= #Tp5 wb_dat_i5[7:0];
        if (wb_sel_i5[1])
          divider5[15:8] <= #Tp5 wb_dat_i5[15:8];
        if (wb_sel_i5[2])
          divider5[`SPI_DIVIDER_LEN5-1:16] <= #Tp5 wb_dat_i5[`SPI_DIVIDER_LEN5-1:16];
      `endif
      `ifdef SPI_DIVIDER_LEN_325
        if (wb_sel_i5[0])
          divider5[7:0] <= #Tp5 wb_dat_i5[7:0];
        if (wb_sel_i5[1])
          divider5[15:8] <= #Tp5 wb_dat_i5[15:8];
        if (wb_sel_i5[2])
          divider5[23:16] <= #Tp5 wb_dat_i5[23:16];
        if (wb_sel_i5[3])
          divider5[`SPI_DIVIDER_LEN5-1:24] <= #Tp5 wb_dat_i5[`SPI_DIVIDER_LEN5-1:24];
      `endif
      end
  end
  
  // Ctrl5 register
  always @(posedge wb_clk_i5 or posedge wb_rst_i5)
  begin
    if (wb_rst_i5)
      ctrl5 <= #Tp5 {`SPI_CTRL_BIT_NB5{1'b0}};
    else if(spi_ctrl_sel5 && wb_we_i5 && !tip5)
      begin
        if (wb_sel_i5[0])
          ctrl5[7:0] <= #Tp5 wb_dat_i5[7:0] | {7'b0, ctrl5[0]};
        if (wb_sel_i5[1])
          ctrl5[`SPI_CTRL_BIT_NB5-1:8] <= #Tp5 wb_dat_i5[`SPI_CTRL_BIT_NB5-1:8];
      end
    else if(tip5 && last_bit5 && pos_edge5)
      ctrl5[`SPI_CTRL_GO5] <= #Tp5 1'b0;
  end
  
  assign rx_negedge5 = ctrl5[`SPI_CTRL_RX_NEGEDGE5];
  assign tx_negedge5 = ctrl5[`SPI_CTRL_TX_NEGEDGE5];
  assign go5         = ctrl5[`SPI_CTRL_GO5];
  assign char_len5   = ctrl5[`SPI_CTRL_CHAR_LEN5];
  assign lsb        = ctrl5[`SPI_CTRL_LSB5];
  assign ie5         = ctrl5[`SPI_CTRL_IE5];
  assign ass5        = ctrl5[`SPI_CTRL_ASS5];
  
  // Slave5 select5 register
  always @(posedge wb_clk_i5 or posedge wb_rst_i5)
  begin
    if (wb_rst_i5)
      ss <= #Tp5 {`SPI_SS_NB5{1'b0}};
    else if(spi_ss_sel5 && wb_we_i5 && !tip5)
      begin
      `ifdef SPI_SS_NB_85
        if (wb_sel_i5[0])
          ss <= #Tp5 wb_dat_i5[`SPI_SS_NB5-1:0];
      `endif
      `ifdef SPI_SS_NB_165
        if (wb_sel_i5[0])
          ss[7:0] <= #Tp5 wb_dat_i5[7:0];
        if (wb_sel_i5[1])
          ss[`SPI_SS_NB5-1:8] <= #Tp5 wb_dat_i5[`SPI_SS_NB5-1:8];
      `endif
      `ifdef SPI_SS_NB_245
        if (wb_sel_i5[0])
          ss[7:0] <= #Tp5 wb_dat_i5[7:0];
        if (wb_sel_i5[1])
          ss[15:8] <= #Tp5 wb_dat_i5[15:8];
        if (wb_sel_i5[2])
          ss[`SPI_SS_NB5-1:16] <= #Tp5 wb_dat_i5[`SPI_SS_NB5-1:16];
      `endif
      `ifdef SPI_SS_NB_325
        if (wb_sel_i5[0])
          ss[7:0] <= #Tp5 wb_dat_i5[7:0];
        if (wb_sel_i5[1])
          ss[15:8] <= #Tp5 wb_dat_i5[15:8];
        if (wb_sel_i5[2])
          ss[23:16] <= #Tp5 wb_dat_i5[23:16];
        if (wb_sel_i5[3])
          ss[`SPI_SS_NB5-1:24] <= #Tp5 wb_dat_i5[`SPI_SS_NB5-1:24];
      `endif
      end
  end
  
  assign ss_pad_o5 = ~((ss & {`SPI_SS_NB5{tip5 & ass5}}) | (ss & {`SPI_SS_NB5{!ass5}}));
  
  spi_clgen5 clgen5 (.clk_in5(wb_clk_i5), .rst5(wb_rst_i5), .go5(go5), .enable(tip5), .last_clk5(last_bit5),
                   .divider5(divider5), .clk_out5(sclk_pad_o5), .pos_edge5(pos_edge5), 
                   .neg_edge5(neg_edge5));
  
  spi_shift5 shift5 (.clk5(wb_clk_i5), .rst5(wb_rst_i5), .len(char_len5[`SPI_CHAR_LEN_BITS5-1:0]),
                   .latch5(spi_tx_sel5[3:0] & {4{wb_we_i5}}), .byte_sel5(wb_sel_i5), .lsb(lsb), 
                   .go5(go5), .pos_edge5(pos_edge5), .neg_edge5(neg_edge5), 
                   .rx_negedge5(rx_negedge5), .tx_negedge5(tx_negedge5),
                   .tip5(tip5), .last(last_bit5), 
                   .p_in5(wb_dat_i5), .p_out5(rx5), 
                   .s_clk5(sclk_pad_o5), .s_in5(miso_pad_i5), .s_out5(mosi_pad_o5));
endmodule
  
