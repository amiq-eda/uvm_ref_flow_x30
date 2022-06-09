//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_top24.v                                                   ////
////                                                              ////
////  This24 file is part of the SPI24 IP24 core24 project24                ////
////  http24://www24.opencores24.org24/projects24/spi24/                      ////
////                                                              ////
////  Author24(s):                                                  ////
////      - Simon24 Srot24 (simons24@opencores24.org24)                     ////
////                                                              ////
////  All additional24 information is avaliable24 in the Readme24.txt24   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright24 (C) 2002 Authors24                                   ////
////                                                              ////
//// This24 source24 file may be used and distributed24 without         ////
//// restriction24 provided that this copyright24 statement24 is not    ////
//// removed from the file and that any derivative24 work24 contains24  ////
//// the original copyright24 notice24 and the associated disclaimer24. ////
////                                                              ////
//// This24 source24 file is free software24; you can redistribute24 it   ////
//// and/or modify it under the terms24 of the GNU24 Lesser24 General24   ////
//// Public24 License24 as published24 by the Free24 Software24 Foundation24; ////
//// either24 version24 2.1 of the License24, or (at your24 option) any   ////
//// later24 version24.                                               ////
////                                                              ////
//// This24 source24 is distributed24 in the hope24 that it will be       ////
//// useful24, but WITHOUT24 ANY24 WARRANTY24; without even24 the implied24   ////
//// warranty24 of MERCHANTABILITY24 or FITNESS24 FOR24 A PARTICULAR24      ////
//// PURPOSE24.  See the GNU24 Lesser24 General24 Public24 License24 for more ////
//// details24.                                                     ////
////                                                              ////
//// You should have received24 a copy of the GNU24 Lesser24 General24    ////
//// Public24 License24 along24 with this source24; if not, download24 it   ////
//// from http24://www24.opencores24.org24/lgpl24.shtml24                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////


`include "spi_defines24.v"
`include "timescale.v"

module spi_top24
(
  // Wishbone24 signals24
  wb_clk_i24, wb_rst_i24, wb_adr_i24, wb_dat_i24, wb_dat_o24, wb_sel_i24,
  wb_we_i24, wb_stb_i24, wb_cyc_i24, wb_ack_o24, wb_err_o24, wb_int_o24,

  // SPI24 signals24
  ss_pad_o24, sclk_pad_o24, mosi_pad_o24, miso_pad_i24
);

  parameter Tp24 = 1;

  // Wishbone24 signals24
  input                            wb_clk_i24;         // master24 clock24 input
  input                            wb_rst_i24;         // synchronous24 active high24 reset
  input                      [4:0] wb_adr_i24;         // lower24 address bits
  input                   [32-1:0] wb_dat_i24;         // databus24 input
  output                  [32-1:0] wb_dat_o24;         // databus24 output
  input                      [3:0] wb_sel_i24;         // byte select24 inputs24
  input                            wb_we_i24;          // write enable input
  input                            wb_stb_i24;         // stobe24/core24 select24 signal24
  input                            wb_cyc_i24;         // valid bus cycle input
  output                           wb_ack_o24;         // bus cycle acknowledge24 output
  output                           wb_err_o24;         // termination w/ error
  output                           wb_int_o24;         // interrupt24 request signal24 output
                                                     
  // SPI24 signals24                                     
  output          [`SPI_SS_NB24-1:0] ss_pad_o24;         // slave24 select24
  output                           sclk_pad_o24;       // serial24 clock24
  output                           mosi_pad_o24;       // master24 out slave24 in
  input                            miso_pad_i24;       // master24 in slave24 out
                                                     
  reg                     [32-1:0] wb_dat_o24;
  reg                              wb_ack_o24;
  reg                              wb_int_o24;
                                               
  // Internal signals24
  reg       [`SPI_DIVIDER_LEN24-1:0] divider24;          // Divider24 register
  reg       [`SPI_CTRL_BIT_NB24-1:0] ctrl24;             // Control24 and status register
  reg             [`SPI_SS_NB24-1:0] ss;               // Slave24 select24 register
  reg                     [32-1:0] wb_dat24;           // wb24 data out
  wire         [`SPI_MAX_CHAR24-1:0] rx24;               // Rx24 register
  wire                             rx_negedge24;       // miso24 is sampled24 on negative edge
  wire                             tx_negedge24;       // mosi24 is driven24 on negative edge
  wire    [`SPI_CHAR_LEN_BITS24-1:0] char_len24;         // char24 len
  wire                             go24;               // go24
  wire                             lsb;              // lsb first on line
  wire                             ie24;               // interrupt24 enable
  wire                             ass24;              // automatic slave24 select24
  wire                             spi_divider_sel24;  // divider24 register select24
  wire                             spi_ctrl_sel24;     // ctrl24 register select24
  wire                       [3:0] spi_tx_sel24;       // tx_l24 register select24
  wire                             spi_ss_sel24;       // ss register select24
  wire                             tip24;              // transfer24 in progress24
  wire                             pos_edge24;         // recognize24 posedge of sclk24
  wire                             neg_edge24;         // recognize24 negedge of sclk24
  wire                             last_bit24;         // marks24 last character24 bit
  
  // Address decoder24
  assign spi_divider_sel24 = wb_cyc_i24 & wb_stb_i24 & (wb_adr_i24[`SPI_OFS_BITS24] == `SPI_DEVIDE24);
  assign spi_ctrl_sel24    = wb_cyc_i24 & wb_stb_i24 & (wb_adr_i24[`SPI_OFS_BITS24] == `SPI_CTRL24);
  assign spi_tx_sel24[0]   = wb_cyc_i24 & wb_stb_i24 & (wb_adr_i24[`SPI_OFS_BITS24] == `SPI_TX_024);
  assign spi_tx_sel24[1]   = wb_cyc_i24 & wb_stb_i24 & (wb_adr_i24[`SPI_OFS_BITS24] == `SPI_TX_124);
  assign spi_tx_sel24[2]   = wb_cyc_i24 & wb_stb_i24 & (wb_adr_i24[`SPI_OFS_BITS24] == `SPI_TX_224);
  assign spi_tx_sel24[3]   = wb_cyc_i24 & wb_stb_i24 & (wb_adr_i24[`SPI_OFS_BITS24] == `SPI_TX_324);
  assign spi_ss_sel24      = wb_cyc_i24 & wb_stb_i24 & (wb_adr_i24[`SPI_OFS_BITS24] == `SPI_SS24);
  
  // Read from registers
  always @(wb_adr_i24 or rx24 or ctrl24 or divider24 or ss)
  begin
    case (wb_adr_i24[`SPI_OFS_BITS24])
`ifdef SPI_MAX_CHAR_12824
      `SPI_RX_024:    wb_dat24 = rx24[31:0];
      `SPI_RX_124:    wb_dat24 = rx24[63:32];
      `SPI_RX_224:    wb_dat24 = rx24[95:64];
      `SPI_RX_324:    wb_dat24 = {{128-`SPI_MAX_CHAR24{1'b0}}, rx24[`SPI_MAX_CHAR24-1:96]};
`else
`ifdef SPI_MAX_CHAR_6424
      `SPI_RX_024:    wb_dat24 = rx24[31:0];
      `SPI_RX_124:    wb_dat24 = {{64-`SPI_MAX_CHAR24{1'b0}}, rx24[`SPI_MAX_CHAR24-1:32]};
      `SPI_RX_224:    wb_dat24 = 32'b0;
      `SPI_RX_324:    wb_dat24 = 32'b0;
`else
      `SPI_RX_024:    wb_dat24 = {{32-`SPI_MAX_CHAR24{1'b0}}, rx24[`SPI_MAX_CHAR24-1:0]};
      `SPI_RX_124:    wb_dat24 = 32'b0;
      `SPI_RX_224:    wb_dat24 = 32'b0;
      `SPI_RX_324:    wb_dat24 = 32'b0;
`endif
`endif
      `SPI_CTRL24:    wb_dat24 = {{32-`SPI_CTRL_BIT_NB24{1'b0}}, ctrl24};
      `SPI_DEVIDE24:  wb_dat24 = {{32-`SPI_DIVIDER_LEN24{1'b0}}, divider24};
      `SPI_SS24:      wb_dat24 = {{32-`SPI_SS_NB24{1'b0}}, ss};
      default:      wb_dat24 = 32'bx;
    endcase
  end
  
  // Wb24 data out
  always @(posedge wb_clk_i24 or posedge wb_rst_i24)
  begin
    if (wb_rst_i24)
      wb_dat_o24 <= #Tp24 32'b0;
    else
      wb_dat_o24 <= #Tp24 wb_dat24;
  end
  
  // Wb24 acknowledge24
  always @(posedge wb_clk_i24 or posedge wb_rst_i24)
  begin
    if (wb_rst_i24)
      wb_ack_o24 <= #Tp24 1'b0;
    else
      wb_ack_o24 <= #Tp24 wb_cyc_i24 & wb_stb_i24 & ~wb_ack_o24;
  end
  
  // Wb24 error
  assign wb_err_o24 = 1'b0;
  
  // Interrupt24
  always @(posedge wb_clk_i24 or posedge wb_rst_i24)
  begin
    if (wb_rst_i24)
      wb_int_o24 <= #Tp24 1'b0;
    else if (ie24 && tip24 && last_bit24 && pos_edge24)
      wb_int_o24 <= #Tp24 1'b1;
    else if (wb_ack_o24)
      wb_int_o24 <= #Tp24 1'b0;
  end
  
  // Divider24 register
  always @(posedge wb_clk_i24 or posedge wb_rst_i24)
  begin
    if (wb_rst_i24)
        divider24 <= #Tp24 {`SPI_DIVIDER_LEN24{1'b0}};
    else if (spi_divider_sel24 && wb_we_i24 && !tip24)
      begin
      `ifdef SPI_DIVIDER_LEN_824
        if (wb_sel_i24[0])
          divider24 <= #Tp24 wb_dat_i24[`SPI_DIVIDER_LEN24-1:0];
      `endif
      `ifdef SPI_DIVIDER_LEN_1624
        if (wb_sel_i24[0])
          divider24[7:0] <= #Tp24 wb_dat_i24[7:0];
        if (wb_sel_i24[1])
          divider24[`SPI_DIVIDER_LEN24-1:8] <= #Tp24 wb_dat_i24[`SPI_DIVIDER_LEN24-1:8];
      `endif
      `ifdef SPI_DIVIDER_LEN_2424
        if (wb_sel_i24[0])
          divider24[7:0] <= #Tp24 wb_dat_i24[7:0];
        if (wb_sel_i24[1])
          divider24[15:8] <= #Tp24 wb_dat_i24[15:8];
        if (wb_sel_i24[2])
          divider24[`SPI_DIVIDER_LEN24-1:16] <= #Tp24 wb_dat_i24[`SPI_DIVIDER_LEN24-1:16];
      `endif
      `ifdef SPI_DIVIDER_LEN_3224
        if (wb_sel_i24[0])
          divider24[7:0] <= #Tp24 wb_dat_i24[7:0];
        if (wb_sel_i24[1])
          divider24[15:8] <= #Tp24 wb_dat_i24[15:8];
        if (wb_sel_i24[2])
          divider24[23:16] <= #Tp24 wb_dat_i24[23:16];
        if (wb_sel_i24[3])
          divider24[`SPI_DIVIDER_LEN24-1:24] <= #Tp24 wb_dat_i24[`SPI_DIVIDER_LEN24-1:24];
      `endif
      end
  end
  
  // Ctrl24 register
  always @(posedge wb_clk_i24 or posedge wb_rst_i24)
  begin
    if (wb_rst_i24)
      ctrl24 <= #Tp24 {`SPI_CTRL_BIT_NB24{1'b0}};
    else if(spi_ctrl_sel24 && wb_we_i24 && !tip24)
      begin
        if (wb_sel_i24[0])
          ctrl24[7:0] <= #Tp24 wb_dat_i24[7:0] | {7'b0, ctrl24[0]};
        if (wb_sel_i24[1])
          ctrl24[`SPI_CTRL_BIT_NB24-1:8] <= #Tp24 wb_dat_i24[`SPI_CTRL_BIT_NB24-1:8];
      end
    else if(tip24 && last_bit24 && pos_edge24)
      ctrl24[`SPI_CTRL_GO24] <= #Tp24 1'b0;
  end
  
  assign rx_negedge24 = ctrl24[`SPI_CTRL_RX_NEGEDGE24];
  assign tx_negedge24 = ctrl24[`SPI_CTRL_TX_NEGEDGE24];
  assign go24         = ctrl24[`SPI_CTRL_GO24];
  assign char_len24   = ctrl24[`SPI_CTRL_CHAR_LEN24];
  assign lsb        = ctrl24[`SPI_CTRL_LSB24];
  assign ie24         = ctrl24[`SPI_CTRL_IE24];
  assign ass24        = ctrl24[`SPI_CTRL_ASS24];
  
  // Slave24 select24 register
  always @(posedge wb_clk_i24 or posedge wb_rst_i24)
  begin
    if (wb_rst_i24)
      ss <= #Tp24 {`SPI_SS_NB24{1'b0}};
    else if(spi_ss_sel24 && wb_we_i24 && !tip24)
      begin
      `ifdef SPI_SS_NB_824
        if (wb_sel_i24[0])
          ss <= #Tp24 wb_dat_i24[`SPI_SS_NB24-1:0];
      `endif
      `ifdef SPI_SS_NB_1624
        if (wb_sel_i24[0])
          ss[7:0] <= #Tp24 wb_dat_i24[7:0];
        if (wb_sel_i24[1])
          ss[`SPI_SS_NB24-1:8] <= #Tp24 wb_dat_i24[`SPI_SS_NB24-1:8];
      `endif
      `ifdef SPI_SS_NB_2424
        if (wb_sel_i24[0])
          ss[7:0] <= #Tp24 wb_dat_i24[7:0];
        if (wb_sel_i24[1])
          ss[15:8] <= #Tp24 wb_dat_i24[15:8];
        if (wb_sel_i24[2])
          ss[`SPI_SS_NB24-1:16] <= #Tp24 wb_dat_i24[`SPI_SS_NB24-1:16];
      `endif
      `ifdef SPI_SS_NB_3224
        if (wb_sel_i24[0])
          ss[7:0] <= #Tp24 wb_dat_i24[7:0];
        if (wb_sel_i24[1])
          ss[15:8] <= #Tp24 wb_dat_i24[15:8];
        if (wb_sel_i24[2])
          ss[23:16] <= #Tp24 wb_dat_i24[23:16];
        if (wb_sel_i24[3])
          ss[`SPI_SS_NB24-1:24] <= #Tp24 wb_dat_i24[`SPI_SS_NB24-1:24];
      `endif
      end
  end
  
  assign ss_pad_o24 = ~((ss & {`SPI_SS_NB24{tip24 & ass24}}) | (ss & {`SPI_SS_NB24{!ass24}}));
  
  spi_clgen24 clgen24 (.clk_in24(wb_clk_i24), .rst24(wb_rst_i24), .go24(go24), .enable(tip24), .last_clk24(last_bit24),
                   .divider24(divider24), .clk_out24(sclk_pad_o24), .pos_edge24(pos_edge24), 
                   .neg_edge24(neg_edge24));
  
  spi_shift24 shift24 (.clk24(wb_clk_i24), .rst24(wb_rst_i24), .len(char_len24[`SPI_CHAR_LEN_BITS24-1:0]),
                   .latch24(spi_tx_sel24[3:0] & {4{wb_we_i24}}), .byte_sel24(wb_sel_i24), .lsb(lsb), 
                   .go24(go24), .pos_edge24(pos_edge24), .neg_edge24(neg_edge24), 
                   .rx_negedge24(rx_negedge24), .tx_negedge24(tx_negedge24),
                   .tip24(tip24), .last(last_bit24), 
                   .p_in24(wb_dat_i24), .p_out24(rx24), 
                   .s_clk24(sclk_pad_o24), .s_in24(miso_pad_i24), .s_out24(mosi_pad_o24));
endmodule
  
