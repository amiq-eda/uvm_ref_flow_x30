//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_top4.v                                                   ////
////                                                              ////
////  This4 file is part of the SPI4 IP4 core4 project4                ////
////  http4://www4.opencores4.org4/projects4/spi4/                      ////
////                                                              ////
////  Author4(s):                                                  ////
////      - Simon4 Srot4 (simons4@opencores4.org4)                     ////
////                                                              ////
////  All additional4 information is avaliable4 in the Readme4.txt4   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright4 (C) 2002 Authors4                                   ////
////                                                              ////
//// This4 source4 file may be used and distributed4 without         ////
//// restriction4 provided that this copyright4 statement4 is not    ////
//// removed from the file and that any derivative4 work4 contains4  ////
//// the original copyright4 notice4 and the associated disclaimer4. ////
////                                                              ////
//// This4 source4 file is free software4; you can redistribute4 it   ////
//// and/or modify it under the terms4 of the GNU4 Lesser4 General4   ////
//// Public4 License4 as published4 by the Free4 Software4 Foundation4; ////
//// either4 version4 2.1 of the License4, or (at your4 option) any   ////
//// later4 version4.                                               ////
////                                                              ////
//// This4 source4 is distributed4 in the hope4 that it will be       ////
//// useful4, but WITHOUT4 ANY4 WARRANTY4; without even4 the implied4   ////
//// warranty4 of MERCHANTABILITY4 or FITNESS4 FOR4 A PARTICULAR4      ////
//// PURPOSE4.  See the GNU4 Lesser4 General4 Public4 License4 for more ////
//// details4.                                                     ////
////                                                              ////
//// You should have received4 a copy of the GNU4 Lesser4 General4    ////
//// Public4 License4 along4 with this source4; if not, download4 it   ////
//// from http4://www4.opencores4.org4/lgpl4.shtml4                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////


`include "spi_defines4.v"
`include "timescale.v"

module spi_top4
(
  // Wishbone4 signals4
  wb_clk_i4, wb_rst_i4, wb_adr_i4, wb_dat_i4, wb_dat_o4, wb_sel_i4,
  wb_we_i4, wb_stb_i4, wb_cyc_i4, wb_ack_o4, wb_err_o4, wb_int_o4,

  // SPI4 signals4
  ss_pad_o4, sclk_pad_o4, mosi_pad_o4, miso_pad_i4
);

  parameter Tp4 = 1;

  // Wishbone4 signals4
  input                            wb_clk_i4;         // master4 clock4 input
  input                            wb_rst_i4;         // synchronous4 active high4 reset
  input                      [4:0] wb_adr_i4;         // lower4 address bits
  input                   [32-1:0] wb_dat_i4;         // databus4 input
  output                  [32-1:0] wb_dat_o4;         // databus4 output
  input                      [3:0] wb_sel_i4;         // byte select4 inputs4
  input                            wb_we_i4;          // write enable input
  input                            wb_stb_i4;         // stobe4/core4 select4 signal4
  input                            wb_cyc_i4;         // valid bus cycle input
  output                           wb_ack_o4;         // bus cycle acknowledge4 output
  output                           wb_err_o4;         // termination w/ error
  output                           wb_int_o4;         // interrupt4 request signal4 output
                                                     
  // SPI4 signals4                                     
  output          [`SPI_SS_NB4-1:0] ss_pad_o4;         // slave4 select4
  output                           sclk_pad_o4;       // serial4 clock4
  output                           mosi_pad_o4;       // master4 out slave4 in
  input                            miso_pad_i4;       // master4 in slave4 out
                                                     
  reg                     [32-1:0] wb_dat_o4;
  reg                              wb_ack_o4;
  reg                              wb_int_o4;
                                               
  // Internal signals4
  reg       [`SPI_DIVIDER_LEN4-1:0] divider4;          // Divider4 register
  reg       [`SPI_CTRL_BIT_NB4-1:0] ctrl4;             // Control4 and status register
  reg             [`SPI_SS_NB4-1:0] ss;               // Slave4 select4 register
  reg                     [32-1:0] wb_dat4;           // wb4 data out
  wire         [`SPI_MAX_CHAR4-1:0] rx4;               // Rx4 register
  wire                             rx_negedge4;       // miso4 is sampled4 on negative edge
  wire                             tx_negedge4;       // mosi4 is driven4 on negative edge
  wire    [`SPI_CHAR_LEN_BITS4-1:0] char_len4;         // char4 len
  wire                             go4;               // go4
  wire                             lsb;              // lsb first on line
  wire                             ie4;               // interrupt4 enable
  wire                             ass4;              // automatic slave4 select4
  wire                             spi_divider_sel4;  // divider4 register select4
  wire                             spi_ctrl_sel4;     // ctrl4 register select4
  wire                       [3:0] spi_tx_sel4;       // tx_l4 register select4
  wire                             spi_ss_sel4;       // ss register select4
  wire                             tip4;              // transfer4 in progress4
  wire                             pos_edge4;         // recognize4 posedge of sclk4
  wire                             neg_edge4;         // recognize4 negedge of sclk4
  wire                             last_bit4;         // marks4 last character4 bit
  
  // Address decoder4
  assign spi_divider_sel4 = wb_cyc_i4 & wb_stb_i4 & (wb_adr_i4[`SPI_OFS_BITS4] == `SPI_DEVIDE4);
  assign spi_ctrl_sel4    = wb_cyc_i4 & wb_stb_i4 & (wb_adr_i4[`SPI_OFS_BITS4] == `SPI_CTRL4);
  assign spi_tx_sel4[0]   = wb_cyc_i4 & wb_stb_i4 & (wb_adr_i4[`SPI_OFS_BITS4] == `SPI_TX_04);
  assign spi_tx_sel4[1]   = wb_cyc_i4 & wb_stb_i4 & (wb_adr_i4[`SPI_OFS_BITS4] == `SPI_TX_14);
  assign spi_tx_sel4[2]   = wb_cyc_i4 & wb_stb_i4 & (wb_adr_i4[`SPI_OFS_BITS4] == `SPI_TX_24);
  assign spi_tx_sel4[3]   = wb_cyc_i4 & wb_stb_i4 & (wb_adr_i4[`SPI_OFS_BITS4] == `SPI_TX_34);
  assign spi_ss_sel4      = wb_cyc_i4 & wb_stb_i4 & (wb_adr_i4[`SPI_OFS_BITS4] == `SPI_SS4);
  
  // Read from registers
  always @(wb_adr_i4 or rx4 or ctrl4 or divider4 or ss)
  begin
    case (wb_adr_i4[`SPI_OFS_BITS4])
`ifdef SPI_MAX_CHAR_1284
      `SPI_RX_04:    wb_dat4 = rx4[31:0];
      `SPI_RX_14:    wb_dat4 = rx4[63:32];
      `SPI_RX_24:    wb_dat4 = rx4[95:64];
      `SPI_RX_34:    wb_dat4 = {{128-`SPI_MAX_CHAR4{1'b0}}, rx4[`SPI_MAX_CHAR4-1:96]};
`else
`ifdef SPI_MAX_CHAR_644
      `SPI_RX_04:    wb_dat4 = rx4[31:0];
      `SPI_RX_14:    wb_dat4 = {{64-`SPI_MAX_CHAR4{1'b0}}, rx4[`SPI_MAX_CHAR4-1:32]};
      `SPI_RX_24:    wb_dat4 = 32'b0;
      `SPI_RX_34:    wb_dat4 = 32'b0;
`else
      `SPI_RX_04:    wb_dat4 = {{32-`SPI_MAX_CHAR4{1'b0}}, rx4[`SPI_MAX_CHAR4-1:0]};
      `SPI_RX_14:    wb_dat4 = 32'b0;
      `SPI_RX_24:    wb_dat4 = 32'b0;
      `SPI_RX_34:    wb_dat4 = 32'b0;
`endif
`endif
      `SPI_CTRL4:    wb_dat4 = {{32-`SPI_CTRL_BIT_NB4{1'b0}}, ctrl4};
      `SPI_DEVIDE4:  wb_dat4 = {{32-`SPI_DIVIDER_LEN4{1'b0}}, divider4};
      `SPI_SS4:      wb_dat4 = {{32-`SPI_SS_NB4{1'b0}}, ss};
      default:      wb_dat4 = 32'bx;
    endcase
  end
  
  // Wb4 data out
  always @(posedge wb_clk_i4 or posedge wb_rst_i4)
  begin
    if (wb_rst_i4)
      wb_dat_o4 <= #Tp4 32'b0;
    else
      wb_dat_o4 <= #Tp4 wb_dat4;
  end
  
  // Wb4 acknowledge4
  always @(posedge wb_clk_i4 or posedge wb_rst_i4)
  begin
    if (wb_rst_i4)
      wb_ack_o4 <= #Tp4 1'b0;
    else
      wb_ack_o4 <= #Tp4 wb_cyc_i4 & wb_stb_i4 & ~wb_ack_o4;
  end
  
  // Wb4 error
  assign wb_err_o4 = 1'b0;
  
  // Interrupt4
  always @(posedge wb_clk_i4 or posedge wb_rst_i4)
  begin
    if (wb_rst_i4)
      wb_int_o4 <= #Tp4 1'b0;
    else if (ie4 && tip4 && last_bit4 && pos_edge4)
      wb_int_o4 <= #Tp4 1'b1;
    else if (wb_ack_o4)
      wb_int_o4 <= #Tp4 1'b0;
  end
  
  // Divider4 register
  always @(posedge wb_clk_i4 or posedge wb_rst_i4)
  begin
    if (wb_rst_i4)
        divider4 <= #Tp4 {`SPI_DIVIDER_LEN4{1'b0}};
    else if (spi_divider_sel4 && wb_we_i4 && !tip4)
      begin
      `ifdef SPI_DIVIDER_LEN_84
        if (wb_sel_i4[0])
          divider4 <= #Tp4 wb_dat_i4[`SPI_DIVIDER_LEN4-1:0];
      `endif
      `ifdef SPI_DIVIDER_LEN_164
        if (wb_sel_i4[0])
          divider4[7:0] <= #Tp4 wb_dat_i4[7:0];
        if (wb_sel_i4[1])
          divider4[`SPI_DIVIDER_LEN4-1:8] <= #Tp4 wb_dat_i4[`SPI_DIVIDER_LEN4-1:8];
      `endif
      `ifdef SPI_DIVIDER_LEN_244
        if (wb_sel_i4[0])
          divider4[7:0] <= #Tp4 wb_dat_i4[7:0];
        if (wb_sel_i4[1])
          divider4[15:8] <= #Tp4 wb_dat_i4[15:8];
        if (wb_sel_i4[2])
          divider4[`SPI_DIVIDER_LEN4-1:16] <= #Tp4 wb_dat_i4[`SPI_DIVIDER_LEN4-1:16];
      `endif
      `ifdef SPI_DIVIDER_LEN_324
        if (wb_sel_i4[0])
          divider4[7:0] <= #Tp4 wb_dat_i4[7:0];
        if (wb_sel_i4[1])
          divider4[15:8] <= #Tp4 wb_dat_i4[15:8];
        if (wb_sel_i4[2])
          divider4[23:16] <= #Tp4 wb_dat_i4[23:16];
        if (wb_sel_i4[3])
          divider4[`SPI_DIVIDER_LEN4-1:24] <= #Tp4 wb_dat_i4[`SPI_DIVIDER_LEN4-1:24];
      `endif
      end
  end
  
  // Ctrl4 register
  always @(posedge wb_clk_i4 or posedge wb_rst_i4)
  begin
    if (wb_rst_i4)
      ctrl4 <= #Tp4 {`SPI_CTRL_BIT_NB4{1'b0}};
    else if(spi_ctrl_sel4 && wb_we_i4 && !tip4)
      begin
        if (wb_sel_i4[0])
          ctrl4[7:0] <= #Tp4 wb_dat_i4[7:0] | {7'b0, ctrl4[0]};
        if (wb_sel_i4[1])
          ctrl4[`SPI_CTRL_BIT_NB4-1:8] <= #Tp4 wb_dat_i4[`SPI_CTRL_BIT_NB4-1:8];
      end
    else if(tip4 && last_bit4 && pos_edge4)
      ctrl4[`SPI_CTRL_GO4] <= #Tp4 1'b0;
  end
  
  assign rx_negedge4 = ctrl4[`SPI_CTRL_RX_NEGEDGE4];
  assign tx_negedge4 = ctrl4[`SPI_CTRL_TX_NEGEDGE4];
  assign go4         = ctrl4[`SPI_CTRL_GO4];
  assign char_len4   = ctrl4[`SPI_CTRL_CHAR_LEN4];
  assign lsb        = ctrl4[`SPI_CTRL_LSB4];
  assign ie4         = ctrl4[`SPI_CTRL_IE4];
  assign ass4        = ctrl4[`SPI_CTRL_ASS4];
  
  // Slave4 select4 register
  always @(posedge wb_clk_i4 or posedge wb_rst_i4)
  begin
    if (wb_rst_i4)
      ss <= #Tp4 {`SPI_SS_NB4{1'b0}};
    else if(spi_ss_sel4 && wb_we_i4 && !tip4)
      begin
      `ifdef SPI_SS_NB_84
        if (wb_sel_i4[0])
          ss <= #Tp4 wb_dat_i4[`SPI_SS_NB4-1:0];
      `endif
      `ifdef SPI_SS_NB_164
        if (wb_sel_i4[0])
          ss[7:0] <= #Tp4 wb_dat_i4[7:0];
        if (wb_sel_i4[1])
          ss[`SPI_SS_NB4-1:8] <= #Tp4 wb_dat_i4[`SPI_SS_NB4-1:8];
      `endif
      `ifdef SPI_SS_NB_244
        if (wb_sel_i4[0])
          ss[7:0] <= #Tp4 wb_dat_i4[7:0];
        if (wb_sel_i4[1])
          ss[15:8] <= #Tp4 wb_dat_i4[15:8];
        if (wb_sel_i4[2])
          ss[`SPI_SS_NB4-1:16] <= #Tp4 wb_dat_i4[`SPI_SS_NB4-1:16];
      `endif
      `ifdef SPI_SS_NB_324
        if (wb_sel_i4[0])
          ss[7:0] <= #Tp4 wb_dat_i4[7:0];
        if (wb_sel_i4[1])
          ss[15:8] <= #Tp4 wb_dat_i4[15:8];
        if (wb_sel_i4[2])
          ss[23:16] <= #Tp4 wb_dat_i4[23:16];
        if (wb_sel_i4[3])
          ss[`SPI_SS_NB4-1:24] <= #Tp4 wb_dat_i4[`SPI_SS_NB4-1:24];
      `endif
      end
  end
  
  assign ss_pad_o4 = ~((ss & {`SPI_SS_NB4{tip4 & ass4}}) | (ss & {`SPI_SS_NB4{!ass4}}));
  
  spi_clgen4 clgen4 (.clk_in4(wb_clk_i4), .rst4(wb_rst_i4), .go4(go4), .enable(tip4), .last_clk4(last_bit4),
                   .divider4(divider4), .clk_out4(sclk_pad_o4), .pos_edge4(pos_edge4), 
                   .neg_edge4(neg_edge4));
  
  spi_shift4 shift4 (.clk4(wb_clk_i4), .rst4(wb_rst_i4), .len(char_len4[`SPI_CHAR_LEN_BITS4-1:0]),
                   .latch4(spi_tx_sel4[3:0] & {4{wb_we_i4}}), .byte_sel4(wb_sel_i4), .lsb(lsb), 
                   .go4(go4), .pos_edge4(pos_edge4), .neg_edge4(neg_edge4), 
                   .rx_negedge4(rx_negedge4), .tx_negedge4(tx_negedge4),
                   .tip4(tip4), .last(last_bit4), 
                   .p_in4(wb_dat_i4), .p_out4(rx4), 
                   .s_clk4(sclk_pad_o4), .s_in4(miso_pad_i4), .s_out4(mosi_pad_o4));
endmodule
  
