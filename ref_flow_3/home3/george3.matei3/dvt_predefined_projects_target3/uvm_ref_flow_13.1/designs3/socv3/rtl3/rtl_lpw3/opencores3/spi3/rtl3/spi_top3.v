//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_top3.v                                                   ////
////                                                              ////
////  This3 file is part of the SPI3 IP3 core3 project3                ////
////  http3://www3.opencores3.org3/projects3/spi3/                      ////
////                                                              ////
////  Author3(s):                                                  ////
////      - Simon3 Srot3 (simons3@opencores3.org3)                     ////
////                                                              ////
////  All additional3 information is avaliable3 in the Readme3.txt3   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright3 (C) 2002 Authors3                                   ////
////                                                              ////
//// This3 source3 file may be used and distributed3 without         ////
//// restriction3 provided that this copyright3 statement3 is not    ////
//// removed from the file and that any derivative3 work3 contains3  ////
//// the original copyright3 notice3 and the associated disclaimer3. ////
////                                                              ////
//// This3 source3 file is free software3; you can redistribute3 it   ////
//// and/or modify it under the terms3 of the GNU3 Lesser3 General3   ////
//// Public3 License3 as published3 by the Free3 Software3 Foundation3; ////
//// either3 version3 2.1 of the License3, or (at your3 option) any   ////
//// later3 version3.                                               ////
////                                                              ////
//// This3 source3 is distributed3 in the hope3 that it will be       ////
//// useful3, but WITHOUT3 ANY3 WARRANTY3; without even3 the implied3   ////
//// warranty3 of MERCHANTABILITY3 or FITNESS3 FOR3 A PARTICULAR3      ////
//// PURPOSE3.  See the GNU3 Lesser3 General3 Public3 License3 for more ////
//// details3.                                                     ////
////                                                              ////
//// You should have received3 a copy of the GNU3 Lesser3 General3    ////
//// Public3 License3 along3 with this source3; if not, download3 it   ////
//// from http3://www3.opencores3.org3/lgpl3.shtml3                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////


`include "spi_defines3.v"
`include "timescale.v"

module spi_top3
(
  // Wishbone3 signals3
  wb_clk_i3, wb_rst_i3, wb_adr_i3, wb_dat_i3, wb_dat_o3, wb_sel_i3,
  wb_we_i3, wb_stb_i3, wb_cyc_i3, wb_ack_o3, wb_err_o3, wb_int_o3,

  // SPI3 signals3
  ss_pad_o3, sclk_pad_o3, mosi_pad_o3, miso_pad_i3
);

  parameter Tp3 = 1;

  // Wishbone3 signals3
  input                            wb_clk_i3;         // master3 clock3 input
  input                            wb_rst_i3;         // synchronous3 active high3 reset
  input                      [4:0] wb_adr_i3;         // lower3 address bits
  input                   [32-1:0] wb_dat_i3;         // databus3 input
  output                  [32-1:0] wb_dat_o3;         // databus3 output
  input                      [3:0] wb_sel_i3;         // byte select3 inputs3
  input                            wb_we_i3;          // write enable input
  input                            wb_stb_i3;         // stobe3/core3 select3 signal3
  input                            wb_cyc_i3;         // valid bus cycle input
  output                           wb_ack_o3;         // bus cycle acknowledge3 output
  output                           wb_err_o3;         // termination w/ error
  output                           wb_int_o3;         // interrupt3 request signal3 output
                                                     
  // SPI3 signals3                                     
  output          [`SPI_SS_NB3-1:0] ss_pad_o3;         // slave3 select3
  output                           sclk_pad_o3;       // serial3 clock3
  output                           mosi_pad_o3;       // master3 out slave3 in
  input                            miso_pad_i3;       // master3 in slave3 out
                                                     
  reg                     [32-1:0] wb_dat_o3;
  reg                              wb_ack_o3;
  reg                              wb_int_o3;
                                               
  // Internal signals3
  reg       [`SPI_DIVIDER_LEN3-1:0] divider3;          // Divider3 register
  reg       [`SPI_CTRL_BIT_NB3-1:0] ctrl3;             // Control3 and status register
  reg             [`SPI_SS_NB3-1:0] ss;               // Slave3 select3 register
  reg                     [32-1:0] wb_dat3;           // wb3 data out
  wire         [`SPI_MAX_CHAR3-1:0] rx3;               // Rx3 register
  wire                             rx_negedge3;       // miso3 is sampled3 on negative edge
  wire                             tx_negedge3;       // mosi3 is driven3 on negative edge
  wire    [`SPI_CHAR_LEN_BITS3-1:0] char_len3;         // char3 len
  wire                             go3;               // go3
  wire                             lsb;              // lsb first on line
  wire                             ie3;               // interrupt3 enable
  wire                             ass3;              // automatic slave3 select3
  wire                             spi_divider_sel3;  // divider3 register select3
  wire                             spi_ctrl_sel3;     // ctrl3 register select3
  wire                       [3:0] spi_tx_sel3;       // tx_l3 register select3
  wire                             spi_ss_sel3;       // ss register select3
  wire                             tip3;              // transfer3 in progress3
  wire                             pos_edge3;         // recognize3 posedge of sclk3
  wire                             neg_edge3;         // recognize3 negedge of sclk3
  wire                             last_bit3;         // marks3 last character3 bit
  
  // Address decoder3
  assign spi_divider_sel3 = wb_cyc_i3 & wb_stb_i3 & (wb_adr_i3[`SPI_OFS_BITS3] == `SPI_DEVIDE3);
  assign spi_ctrl_sel3    = wb_cyc_i3 & wb_stb_i3 & (wb_adr_i3[`SPI_OFS_BITS3] == `SPI_CTRL3);
  assign spi_tx_sel3[0]   = wb_cyc_i3 & wb_stb_i3 & (wb_adr_i3[`SPI_OFS_BITS3] == `SPI_TX_03);
  assign spi_tx_sel3[1]   = wb_cyc_i3 & wb_stb_i3 & (wb_adr_i3[`SPI_OFS_BITS3] == `SPI_TX_13);
  assign spi_tx_sel3[2]   = wb_cyc_i3 & wb_stb_i3 & (wb_adr_i3[`SPI_OFS_BITS3] == `SPI_TX_23);
  assign spi_tx_sel3[3]   = wb_cyc_i3 & wb_stb_i3 & (wb_adr_i3[`SPI_OFS_BITS3] == `SPI_TX_33);
  assign spi_ss_sel3      = wb_cyc_i3 & wb_stb_i3 & (wb_adr_i3[`SPI_OFS_BITS3] == `SPI_SS3);
  
  // Read from registers
  always @(wb_adr_i3 or rx3 or ctrl3 or divider3 or ss)
  begin
    case (wb_adr_i3[`SPI_OFS_BITS3])
`ifdef SPI_MAX_CHAR_1283
      `SPI_RX_03:    wb_dat3 = rx3[31:0];
      `SPI_RX_13:    wb_dat3 = rx3[63:32];
      `SPI_RX_23:    wb_dat3 = rx3[95:64];
      `SPI_RX_33:    wb_dat3 = {{128-`SPI_MAX_CHAR3{1'b0}}, rx3[`SPI_MAX_CHAR3-1:96]};
`else
`ifdef SPI_MAX_CHAR_643
      `SPI_RX_03:    wb_dat3 = rx3[31:0];
      `SPI_RX_13:    wb_dat3 = {{64-`SPI_MAX_CHAR3{1'b0}}, rx3[`SPI_MAX_CHAR3-1:32]};
      `SPI_RX_23:    wb_dat3 = 32'b0;
      `SPI_RX_33:    wb_dat3 = 32'b0;
`else
      `SPI_RX_03:    wb_dat3 = {{32-`SPI_MAX_CHAR3{1'b0}}, rx3[`SPI_MAX_CHAR3-1:0]};
      `SPI_RX_13:    wb_dat3 = 32'b0;
      `SPI_RX_23:    wb_dat3 = 32'b0;
      `SPI_RX_33:    wb_dat3 = 32'b0;
`endif
`endif
      `SPI_CTRL3:    wb_dat3 = {{32-`SPI_CTRL_BIT_NB3{1'b0}}, ctrl3};
      `SPI_DEVIDE3:  wb_dat3 = {{32-`SPI_DIVIDER_LEN3{1'b0}}, divider3};
      `SPI_SS3:      wb_dat3 = {{32-`SPI_SS_NB3{1'b0}}, ss};
      default:      wb_dat3 = 32'bx;
    endcase
  end
  
  // Wb3 data out
  always @(posedge wb_clk_i3 or posedge wb_rst_i3)
  begin
    if (wb_rst_i3)
      wb_dat_o3 <= #Tp3 32'b0;
    else
      wb_dat_o3 <= #Tp3 wb_dat3;
  end
  
  // Wb3 acknowledge3
  always @(posedge wb_clk_i3 or posedge wb_rst_i3)
  begin
    if (wb_rst_i3)
      wb_ack_o3 <= #Tp3 1'b0;
    else
      wb_ack_o3 <= #Tp3 wb_cyc_i3 & wb_stb_i3 & ~wb_ack_o3;
  end
  
  // Wb3 error
  assign wb_err_o3 = 1'b0;
  
  // Interrupt3
  always @(posedge wb_clk_i3 or posedge wb_rst_i3)
  begin
    if (wb_rst_i3)
      wb_int_o3 <= #Tp3 1'b0;
    else if (ie3 && tip3 && last_bit3 && pos_edge3)
      wb_int_o3 <= #Tp3 1'b1;
    else if (wb_ack_o3)
      wb_int_o3 <= #Tp3 1'b0;
  end
  
  // Divider3 register
  always @(posedge wb_clk_i3 or posedge wb_rst_i3)
  begin
    if (wb_rst_i3)
        divider3 <= #Tp3 {`SPI_DIVIDER_LEN3{1'b0}};
    else if (spi_divider_sel3 && wb_we_i3 && !tip3)
      begin
      `ifdef SPI_DIVIDER_LEN_83
        if (wb_sel_i3[0])
          divider3 <= #Tp3 wb_dat_i3[`SPI_DIVIDER_LEN3-1:0];
      `endif
      `ifdef SPI_DIVIDER_LEN_163
        if (wb_sel_i3[0])
          divider3[7:0] <= #Tp3 wb_dat_i3[7:0];
        if (wb_sel_i3[1])
          divider3[`SPI_DIVIDER_LEN3-1:8] <= #Tp3 wb_dat_i3[`SPI_DIVIDER_LEN3-1:8];
      `endif
      `ifdef SPI_DIVIDER_LEN_243
        if (wb_sel_i3[0])
          divider3[7:0] <= #Tp3 wb_dat_i3[7:0];
        if (wb_sel_i3[1])
          divider3[15:8] <= #Tp3 wb_dat_i3[15:8];
        if (wb_sel_i3[2])
          divider3[`SPI_DIVIDER_LEN3-1:16] <= #Tp3 wb_dat_i3[`SPI_DIVIDER_LEN3-1:16];
      `endif
      `ifdef SPI_DIVIDER_LEN_323
        if (wb_sel_i3[0])
          divider3[7:0] <= #Tp3 wb_dat_i3[7:0];
        if (wb_sel_i3[1])
          divider3[15:8] <= #Tp3 wb_dat_i3[15:8];
        if (wb_sel_i3[2])
          divider3[23:16] <= #Tp3 wb_dat_i3[23:16];
        if (wb_sel_i3[3])
          divider3[`SPI_DIVIDER_LEN3-1:24] <= #Tp3 wb_dat_i3[`SPI_DIVIDER_LEN3-1:24];
      `endif
      end
  end
  
  // Ctrl3 register
  always @(posedge wb_clk_i3 or posedge wb_rst_i3)
  begin
    if (wb_rst_i3)
      ctrl3 <= #Tp3 {`SPI_CTRL_BIT_NB3{1'b0}};
    else if(spi_ctrl_sel3 && wb_we_i3 && !tip3)
      begin
        if (wb_sel_i3[0])
          ctrl3[7:0] <= #Tp3 wb_dat_i3[7:0] | {7'b0, ctrl3[0]};
        if (wb_sel_i3[1])
          ctrl3[`SPI_CTRL_BIT_NB3-1:8] <= #Tp3 wb_dat_i3[`SPI_CTRL_BIT_NB3-1:8];
      end
    else if(tip3 && last_bit3 && pos_edge3)
      ctrl3[`SPI_CTRL_GO3] <= #Tp3 1'b0;
  end
  
  assign rx_negedge3 = ctrl3[`SPI_CTRL_RX_NEGEDGE3];
  assign tx_negedge3 = ctrl3[`SPI_CTRL_TX_NEGEDGE3];
  assign go3         = ctrl3[`SPI_CTRL_GO3];
  assign char_len3   = ctrl3[`SPI_CTRL_CHAR_LEN3];
  assign lsb        = ctrl3[`SPI_CTRL_LSB3];
  assign ie3         = ctrl3[`SPI_CTRL_IE3];
  assign ass3        = ctrl3[`SPI_CTRL_ASS3];
  
  // Slave3 select3 register
  always @(posedge wb_clk_i3 or posedge wb_rst_i3)
  begin
    if (wb_rst_i3)
      ss <= #Tp3 {`SPI_SS_NB3{1'b0}};
    else if(spi_ss_sel3 && wb_we_i3 && !tip3)
      begin
      `ifdef SPI_SS_NB_83
        if (wb_sel_i3[0])
          ss <= #Tp3 wb_dat_i3[`SPI_SS_NB3-1:0];
      `endif
      `ifdef SPI_SS_NB_163
        if (wb_sel_i3[0])
          ss[7:0] <= #Tp3 wb_dat_i3[7:0];
        if (wb_sel_i3[1])
          ss[`SPI_SS_NB3-1:8] <= #Tp3 wb_dat_i3[`SPI_SS_NB3-1:8];
      `endif
      `ifdef SPI_SS_NB_243
        if (wb_sel_i3[0])
          ss[7:0] <= #Tp3 wb_dat_i3[7:0];
        if (wb_sel_i3[1])
          ss[15:8] <= #Tp3 wb_dat_i3[15:8];
        if (wb_sel_i3[2])
          ss[`SPI_SS_NB3-1:16] <= #Tp3 wb_dat_i3[`SPI_SS_NB3-1:16];
      `endif
      `ifdef SPI_SS_NB_323
        if (wb_sel_i3[0])
          ss[7:0] <= #Tp3 wb_dat_i3[7:0];
        if (wb_sel_i3[1])
          ss[15:8] <= #Tp3 wb_dat_i3[15:8];
        if (wb_sel_i3[2])
          ss[23:16] <= #Tp3 wb_dat_i3[23:16];
        if (wb_sel_i3[3])
          ss[`SPI_SS_NB3-1:24] <= #Tp3 wb_dat_i3[`SPI_SS_NB3-1:24];
      `endif
      end
  end
  
  assign ss_pad_o3 = ~((ss & {`SPI_SS_NB3{tip3 & ass3}}) | (ss & {`SPI_SS_NB3{!ass3}}));
  
  spi_clgen3 clgen3 (.clk_in3(wb_clk_i3), .rst3(wb_rst_i3), .go3(go3), .enable(tip3), .last_clk3(last_bit3),
                   .divider3(divider3), .clk_out3(sclk_pad_o3), .pos_edge3(pos_edge3), 
                   .neg_edge3(neg_edge3));
  
  spi_shift3 shift3 (.clk3(wb_clk_i3), .rst3(wb_rst_i3), .len(char_len3[`SPI_CHAR_LEN_BITS3-1:0]),
                   .latch3(spi_tx_sel3[3:0] & {4{wb_we_i3}}), .byte_sel3(wb_sel_i3), .lsb(lsb), 
                   .go3(go3), .pos_edge3(pos_edge3), .neg_edge3(neg_edge3), 
                   .rx_negedge3(rx_negedge3), .tx_negedge3(tx_negedge3),
                   .tip3(tip3), .last(last_bit3), 
                   .p_in3(wb_dat_i3), .p_out3(rx3), 
                   .s_clk3(sclk_pad_o3), .s_in3(miso_pad_i3), .s_out3(mosi_pad_o3));
endmodule
  
