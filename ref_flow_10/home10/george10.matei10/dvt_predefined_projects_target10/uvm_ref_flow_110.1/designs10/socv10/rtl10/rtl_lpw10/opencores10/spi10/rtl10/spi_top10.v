//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_top10.v                                                   ////
////                                                              ////
////  This10 file is part of the SPI10 IP10 core10 project10                ////
////  http10://www10.opencores10.org10/projects10/spi10/                      ////
////                                                              ////
////  Author10(s):                                                  ////
////      - Simon10 Srot10 (simons10@opencores10.org10)                     ////
////                                                              ////
////  All additional10 information is avaliable10 in the Readme10.txt10   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright10 (C) 2002 Authors10                                   ////
////                                                              ////
//// This10 source10 file may be used and distributed10 without         ////
//// restriction10 provided that this copyright10 statement10 is not    ////
//// removed from the file and that any derivative10 work10 contains10  ////
//// the original copyright10 notice10 and the associated disclaimer10. ////
////                                                              ////
//// This10 source10 file is free software10; you can redistribute10 it   ////
//// and/or modify it under the terms10 of the GNU10 Lesser10 General10   ////
//// Public10 License10 as published10 by the Free10 Software10 Foundation10; ////
//// either10 version10 2.1 of the License10, or (at your10 option) any   ////
//// later10 version10.                                               ////
////                                                              ////
//// This10 source10 is distributed10 in the hope10 that it will be       ////
//// useful10, but WITHOUT10 ANY10 WARRANTY10; without even10 the implied10   ////
//// warranty10 of MERCHANTABILITY10 or FITNESS10 FOR10 A PARTICULAR10      ////
//// PURPOSE10.  See the GNU10 Lesser10 General10 Public10 License10 for more ////
//// details10.                                                     ////
////                                                              ////
//// You should have received10 a copy of the GNU10 Lesser10 General10    ////
//// Public10 License10 along10 with this source10; if not, download10 it   ////
//// from http10://www10.opencores10.org10/lgpl10.shtml10                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////


`include "spi_defines10.v"
`include "timescale.v"

module spi_top10
(
  // Wishbone10 signals10
  wb_clk_i10, wb_rst_i10, wb_adr_i10, wb_dat_i10, wb_dat_o10, wb_sel_i10,
  wb_we_i10, wb_stb_i10, wb_cyc_i10, wb_ack_o10, wb_err_o10, wb_int_o10,

  // SPI10 signals10
  ss_pad_o10, sclk_pad_o10, mosi_pad_o10, miso_pad_i10
);

  parameter Tp10 = 1;

  // Wishbone10 signals10
  input                            wb_clk_i10;         // master10 clock10 input
  input                            wb_rst_i10;         // synchronous10 active high10 reset
  input                      [4:0] wb_adr_i10;         // lower10 address bits
  input                   [32-1:0] wb_dat_i10;         // databus10 input
  output                  [32-1:0] wb_dat_o10;         // databus10 output
  input                      [3:0] wb_sel_i10;         // byte select10 inputs10
  input                            wb_we_i10;          // write enable input
  input                            wb_stb_i10;         // stobe10/core10 select10 signal10
  input                            wb_cyc_i10;         // valid bus cycle input
  output                           wb_ack_o10;         // bus cycle acknowledge10 output
  output                           wb_err_o10;         // termination w/ error
  output                           wb_int_o10;         // interrupt10 request signal10 output
                                                     
  // SPI10 signals10                                     
  output          [`SPI_SS_NB10-1:0] ss_pad_o10;         // slave10 select10
  output                           sclk_pad_o10;       // serial10 clock10
  output                           mosi_pad_o10;       // master10 out slave10 in
  input                            miso_pad_i10;       // master10 in slave10 out
                                                     
  reg                     [32-1:0] wb_dat_o10;
  reg                              wb_ack_o10;
  reg                              wb_int_o10;
                                               
  // Internal signals10
  reg       [`SPI_DIVIDER_LEN10-1:0] divider10;          // Divider10 register
  reg       [`SPI_CTRL_BIT_NB10-1:0] ctrl10;             // Control10 and status register
  reg             [`SPI_SS_NB10-1:0] ss;               // Slave10 select10 register
  reg                     [32-1:0] wb_dat10;           // wb10 data out
  wire         [`SPI_MAX_CHAR10-1:0] rx10;               // Rx10 register
  wire                             rx_negedge10;       // miso10 is sampled10 on negative edge
  wire                             tx_negedge10;       // mosi10 is driven10 on negative edge
  wire    [`SPI_CHAR_LEN_BITS10-1:0] char_len10;         // char10 len
  wire                             go10;               // go10
  wire                             lsb;              // lsb first on line
  wire                             ie10;               // interrupt10 enable
  wire                             ass10;              // automatic slave10 select10
  wire                             spi_divider_sel10;  // divider10 register select10
  wire                             spi_ctrl_sel10;     // ctrl10 register select10
  wire                       [3:0] spi_tx_sel10;       // tx_l10 register select10
  wire                             spi_ss_sel10;       // ss register select10
  wire                             tip10;              // transfer10 in progress10
  wire                             pos_edge10;         // recognize10 posedge of sclk10
  wire                             neg_edge10;         // recognize10 negedge of sclk10
  wire                             last_bit10;         // marks10 last character10 bit
  
  // Address decoder10
  assign spi_divider_sel10 = wb_cyc_i10 & wb_stb_i10 & (wb_adr_i10[`SPI_OFS_BITS10] == `SPI_DEVIDE10);
  assign spi_ctrl_sel10    = wb_cyc_i10 & wb_stb_i10 & (wb_adr_i10[`SPI_OFS_BITS10] == `SPI_CTRL10);
  assign spi_tx_sel10[0]   = wb_cyc_i10 & wb_stb_i10 & (wb_adr_i10[`SPI_OFS_BITS10] == `SPI_TX_010);
  assign spi_tx_sel10[1]   = wb_cyc_i10 & wb_stb_i10 & (wb_adr_i10[`SPI_OFS_BITS10] == `SPI_TX_110);
  assign spi_tx_sel10[2]   = wb_cyc_i10 & wb_stb_i10 & (wb_adr_i10[`SPI_OFS_BITS10] == `SPI_TX_210);
  assign spi_tx_sel10[3]   = wb_cyc_i10 & wb_stb_i10 & (wb_adr_i10[`SPI_OFS_BITS10] == `SPI_TX_310);
  assign spi_ss_sel10      = wb_cyc_i10 & wb_stb_i10 & (wb_adr_i10[`SPI_OFS_BITS10] == `SPI_SS10);
  
  // Read from registers
  always @(wb_adr_i10 or rx10 or ctrl10 or divider10 or ss)
  begin
    case (wb_adr_i10[`SPI_OFS_BITS10])
`ifdef SPI_MAX_CHAR_12810
      `SPI_RX_010:    wb_dat10 = rx10[31:0];
      `SPI_RX_110:    wb_dat10 = rx10[63:32];
      `SPI_RX_210:    wb_dat10 = rx10[95:64];
      `SPI_RX_310:    wb_dat10 = {{128-`SPI_MAX_CHAR10{1'b0}}, rx10[`SPI_MAX_CHAR10-1:96]};
`else
`ifdef SPI_MAX_CHAR_6410
      `SPI_RX_010:    wb_dat10 = rx10[31:0];
      `SPI_RX_110:    wb_dat10 = {{64-`SPI_MAX_CHAR10{1'b0}}, rx10[`SPI_MAX_CHAR10-1:32]};
      `SPI_RX_210:    wb_dat10 = 32'b0;
      `SPI_RX_310:    wb_dat10 = 32'b0;
`else
      `SPI_RX_010:    wb_dat10 = {{32-`SPI_MAX_CHAR10{1'b0}}, rx10[`SPI_MAX_CHAR10-1:0]};
      `SPI_RX_110:    wb_dat10 = 32'b0;
      `SPI_RX_210:    wb_dat10 = 32'b0;
      `SPI_RX_310:    wb_dat10 = 32'b0;
`endif
`endif
      `SPI_CTRL10:    wb_dat10 = {{32-`SPI_CTRL_BIT_NB10{1'b0}}, ctrl10};
      `SPI_DEVIDE10:  wb_dat10 = {{32-`SPI_DIVIDER_LEN10{1'b0}}, divider10};
      `SPI_SS10:      wb_dat10 = {{32-`SPI_SS_NB10{1'b0}}, ss};
      default:      wb_dat10 = 32'bx;
    endcase
  end
  
  // Wb10 data out
  always @(posedge wb_clk_i10 or posedge wb_rst_i10)
  begin
    if (wb_rst_i10)
      wb_dat_o10 <= #Tp10 32'b0;
    else
      wb_dat_o10 <= #Tp10 wb_dat10;
  end
  
  // Wb10 acknowledge10
  always @(posedge wb_clk_i10 or posedge wb_rst_i10)
  begin
    if (wb_rst_i10)
      wb_ack_o10 <= #Tp10 1'b0;
    else
      wb_ack_o10 <= #Tp10 wb_cyc_i10 & wb_stb_i10 & ~wb_ack_o10;
  end
  
  // Wb10 error
  assign wb_err_o10 = 1'b0;
  
  // Interrupt10
  always @(posedge wb_clk_i10 or posedge wb_rst_i10)
  begin
    if (wb_rst_i10)
      wb_int_o10 <= #Tp10 1'b0;
    else if (ie10 && tip10 && last_bit10 && pos_edge10)
      wb_int_o10 <= #Tp10 1'b1;
    else if (wb_ack_o10)
      wb_int_o10 <= #Tp10 1'b0;
  end
  
  // Divider10 register
  always @(posedge wb_clk_i10 or posedge wb_rst_i10)
  begin
    if (wb_rst_i10)
        divider10 <= #Tp10 {`SPI_DIVIDER_LEN10{1'b0}};
    else if (spi_divider_sel10 && wb_we_i10 && !tip10)
      begin
      `ifdef SPI_DIVIDER_LEN_810
        if (wb_sel_i10[0])
          divider10 <= #Tp10 wb_dat_i10[`SPI_DIVIDER_LEN10-1:0];
      `endif
      `ifdef SPI_DIVIDER_LEN_1610
        if (wb_sel_i10[0])
          divider10[7:0] <= #Tp10 wb_dat_i10[7:0];
        if (wb_sel_i10[1])
          divider10[`SPI_DIVIDER_LEN10-1:8] <= #Tp10 wb_dat_i10[`SPI_DIVIDER_LEN10-1:8];
      `endif
      `ifdef SPI_DIVIDER_LEN_2410
        if (wb_sel_i10[0])
          divider10[7:0] <= #Tp10 wb_dat_i10[7:0];
        if (wb_sel_i10[1])
          divider10[15:8] <= #Tp10 wb_dat_i10[15:8];
        if (wb_sel_i10[2])
          divider10[`SPI_DIVIDER_LEN10-1:16] <= #Tp10 wb_dat_i10[`SPI_DIVIDER_LEN10-1:16];
      `endif
      `ifdef SPI_DIVIDER_LEN_3210
        if (wb_sel_i10[0])
          divider10[7:0] <= #Tp10 wb_dat_i10[7:0];
        if (wb_sel_i10[1])
          divider10[15:8] <= #Tp10 wb_dat_i10[15:8];
        if (wb_sel_i10[2])
          divider10[23:16] <= #Tp10 wb_dat_i10[23:16];
        if (wb_sel_i10[3])
          divider10[`SPI_DIVIDER_LEN10-1:24] <= #Tp10 wb_dat_i10[`SPI_DIVIDER_LEN10-1:24];
      `endif
      end
  end
  
  // Ctrl10 register
  always @(posedge wb_clk_i10 or posedge wb_rst_i10)
  begin
    if (wb_rst_i10)
      ctrl10 <= #Tp10 {`SPI_CTRL_BIT_NB10{1'b0}};
    else if(spi_ctrl_sel10 && wb_we_i10 && !tip10)
      begin
        if (wb_sel_i10[0])
          ctrl10[7:0] <= #Tp10 wb_dat_i10[7:0] | {7'b0, ctrl10[0]};
        if (wb_sel_i10[1])
          ctrl10[`SPI_CTRL_BIT_NB10-1:8] <= #Tp10 wb_dat_i10[`SPI_CTRL_BIT_NB10-1:8];
      end
    else if(tip10 && last_bit10 && pos_edge10)
      ctrl10[`SPI_CTRL_GO10] <= #Tp10 1'b0;
  end
  
  assign rx_negedge10 = ctrl10[`SPI_CTRL_RX_NEGEDGE10];
  assign tx_negedge10 = ctrl10[`SPI_CTRL_TX_NEGEDGE10];
  assign go10         = ctrl10[`SPI_CTRL_GO10];
  assign char_len10   = ctrl10[`SPI_CTRL_CHAR_LEN10];
  assign lsb        = ctrl10[`SPI_CTRL_LSB10];
  assign ie10         = ctrl10[`SPI_CTRL_IE10];
  assign ass10        = ctrl10[`SPI_CTRL_ASS10];
  
  // Slave10 select10 register
  always @(posedge wb_clk_i10 or posedge wb_rst_i10)
  begin
    if (wb_rst_i10)
      ss <= #Tp10 {`SPI_SS_NB10{1'b0}};
    else if(spi_ss_sel10 && wb_we_i10 && !tip10)
      begin
      `ifdef SPI_SS_NB_810
        if (wb_sel_i10[0])
          ss <= #Tp10 wb_dat_i10[`SPI_SS_NB10-1:0];
      `endif
      `ifdef SPI_SS_NB_1610
        if (wb_sel_i10[0])
          ss[7:0] <= #Tp10 wb_dat_i10[7:0];
        if (wb_sel_i10[1])
          ss[`SPI_SS_NB10-1:8] <= #Tp10 wb_dat_i10[`SPI_SS_NB10-1:8];
      `endif
      `ifdef SPI_SS_NB_2410
        if (wb_sel_i10[0])
          ss[7:0] <= #Tp10 wb_dat_i10[7:0];
        if (wb_sel_i10[1])
          ss[15:8] <= #Tp10 wb_dat_i10[15:8];
        if (wb_sel_i10[2])
          ss[`SPI_SS_NB10-1:16] <= #Tp10 wb_dat_i10[`SPI_SS_NB10-1:16];
      `endif
      `ifdef SPI_SS_NB_3210
        if (wb_sel_i10[0])
          ss[7:0] <= #Tp10 wb_dat_i10[7:0];
        if (wb_sel_i10[1])
          ss[15:8] <= #Tp10 wb_dat_i10[15:8];
        if (wb_sel_i10[2])
          ss[23:16] <= #Tp10 wb_dat_i10[23:16];
        if (wb_sel_i10[3])
          ss[`SPI_SS_NB10-1:24] <= #Tp10 wb_dat_i10[`SPI_SS_NB10-1:24];
      `endif
      end
  end
  
  assign ss_pad_o10 = ~((ss & {`SPI_SS_NB10{tip10 & ass10}}) | (ss & {`SPI_SS_NB10{!ass10}}));
  
  spi_clgen10 clgen10 (.clk_in10(wb_clk_i10), .rst10(wb_rst_i10), .go10(go10), .enable(tip10), .last_clk10(last_bit10),
                   .divider10(divider10), .clk_out10(sclk_pad_o10), .pos_edge10(pos_edge10), 
                   .neg_edge10(neg_edge10));
  
  spi_shift10 shift10 (.clk10(wb_clk_i10), .rst10(wb_rst_i10), .len(char_len10[`SPI_CHAR_LEN_BITS10-1:0]),
                   .latch10(spi_tx_sel10[3:0] & {4{wb_we_i10}}), .byte_sel10(wb_sel_i10), .lsb(lsb), 
                   .go10(go10), .pos_edge10(pos_edge10), .neg_edge10(neg_edge10), 
                   .rx_negedge10(rx_negedge10), .tx_negedge10(tx_negedge10),
                   .tip10(tip10), .last(last_bit10), 
                   .p_in10(wb_dat_i10), .p_out10(rx10), 
                   .s_clk10(sclk_pad_o10), .s_in10(miso_pad_i10), .s_out10(mosi_pad_o10));
endmodule
  
