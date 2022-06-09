//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_top1.v                                                   ////
////                                                              ////
////  This1 file is part of the SPI1 IP1 core1 project1                ////
////  http1://www1.opencores1.org1/projects1/spi1/                      ////
////                                                              ////
////  Author1(s):                                                  ////
////      - Simon1 Srot1 (simons1@opencores1.org1)                     ////
////                                                              ////
////  All additional1 information is avaliable1 in the Readme1.txt1   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright1 (C) 2002 Authors1                                   ////
////                                                              ////
//// This1 source1 file may be used and distributed1 without         ////
//// restriction1 provided that this copyright1 statement1 is not    ////
//// removed from the file and that any derivative1 work1 contains1  ////
//// the original copyright1 notice1 and the associated disclaimer1. ////
////                                                              ////
//// This1 source1 file is free software1; you can redistribute1 it   ////
//// and/or modify it under the terms1 of the GNU1 Lesser1 General1   ////
//// Public1 License1 as published1 by the Free1 Software1 Foundation1; ////
//// either1 version1 2.1 of the License1, or (at your1 option) any   ////
//// later1 version1.                                               ////
////                                                              ////
//// This1 source1 is distributed1 in the hope1 that it will be       ////
//// useful1, but WITHOUT1 ANY1 WARRANTY1; without even1 the implied1   ////
//// warranty1 of MERCHANTABILITY1 or FITNESS1 FOR1 A PARTICULAR1      ////
//// PURPOSE1.  See the GNU1 Lesser1 General1 Public1 License1 for more ////
//// details1.                                                     ////
////                                                              ////
//// You should have received1 a copy of the GNU1 Lesser1 General1    ////
//// Public1 License1 along1 with this source1; if not, download1 it   ////
//// from http1://www1.opencores1.org1/lgpl1.shtml1                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////


`include "spi_defines1.v"
`include "timescale.v"

module spi_top1
(
  // Wishbone1 signals1
  wb_clk_i1, wb_rst_i1, wb_adr_i1, wb_dat_i1, wb_dat_o1, wb_sel_i1,
  wb_we_i1, wb_stb_i1, wb_cyc_i1, wb_ack_o1, wb_err_o1, wb_int_o1,

  // SPI1 signals1
  ss_pad_o1, sclk_pad_o1, mosi_pad_o1, miso_pad_i1
);

  parameter Tp1 = 1;

  // Wishbone1 signals1
  input                            wb_clk_i1;         // master1 clock1 input
  input                            wb_rst_i1;         // synchronous1 active high1 reset
  input                      [4:0] wb_adr_i1;         // lower1 address bits
  input                   [32-1:0] wb_dat_i1;         // databus1 input
  output                  [32-1:0] wb_dat_o1;         // databus1 output
  input                      [3:0] wb_sel_i1;         // byte select1 inputs1
  input                            wb_we_i1;          // write enable input
  input                            wb_stb_i1;         // stobe1/core1 select1 signal1
  input                            wb_cyc_i1;         // valid bus cycle input
  output                           wb_ack_o1;         // bus cycle acknowledge1 output
  output                           wb_err_o1;         // termination w/ error
  output                           wb_int_o1;         // interrupt1 request signal1 output
                                                     
  // SPI1 signals1                                     
  output          [`SPI_SS_NB1-1:0] ss_pad_o1;         // slave1 select1
  output                           sclk_pad_o1;       // serial1 clock1
  output                           mosi_pad_o1;       // master1 out slave1 in
  input                            miso_pad_i1;       // master1 in slave1 out
                                                     
  reg                     [32-1:0] wb_dat_o1;
  reg                              wb_ack_o1;
  reg                              wb_int_o1;
                                               
  // Internal signals1
  reg       [`SPI_DIVIDER_LEN1-1:0] divider1;          // Divider1 register
  reg       [`SPI_CTRL_BIT_NB1-1:0] ctrl1;             // Control1 and status register
  reg             [`SPI_SS_NB1-1:0] ss;               // Slave1 select1 register
  reg                     [32-1:0] wb_dat1;           // wb1 data out
  wire         [`SPI_MAX_CHAR1-1:0] rx1;               // Rx1 register
  wire                             rx_negedge1;       // miso1 is sampled1 on negative edge
  wire                             tx_negedge1;       // mosi1 is driven1 on negative edge
  wire    [`SPI_CHAR_LEN_BITS1-1:0] char_len1;         // char1 len
  wire                             go1;               // go1
  wire                             lsb;              // lsb first on line
  wire                             ie1;               // interrupt1 enable
  wire                             ass1;              // automatic slave1 select1
  wire                             spi_divider_sel1;  // divider1 register select1
  wire                             spi_ctrl_sel1;     // ctrl1 register select1
  wire                       [3:0] spi_tx_sel1;       // tx_l1 register select1
  wire                             spi_ss_sel1;       // ss register select1
  wire                             tip1;              // transfer1 in progress1
  wire                             pos_edge1;         // recognize1 posedge of sclk1
  wire                             neg_edge1;         // recognize1 negedge of sclk1
  wire                             last_bit1;         // marks1 last character1 bit
  
  // Address decoder1
  assign spi_divider_sel1 = wb_cyc_i1 & wb_stb_i1 & (wb_adr_i1[`SPI_OFS_BITS1] == `SPI_DEVIDE1);
  assign spi_ctrl_sel1    = wb_cyc_i1 & wb_stb_i1 & (wb_adr_i1[`SPI_OFS_BITS1] == `SPI_CTRL1);
  assign spi_tx_sel1[0]   = wb_cyc_i1 & wb_stb_i1 & (wb_adr_i1[`SPI_OFS_BITS1] == `SPI_TX_01);
  assign spi_tx_sel1[1]   = wb_cyc_i1 & wb_stb_i1 & (wb_adr_i1[`SPI_OFS_BITS1] == `SPI_TX_11);
  assign spi_tx_sel1[2]   = wb_cyc_i1 & wb_stb_i1 & (wb_adr_i1[`SPI_OFS_BITS1] == `SPI_TX_21);
  assign spi_tx_sel1[3]   = wb_cyc_i1 & wb_stb_i1 & (wb_adr_i1[`SPI_OFS_BITS1] == `SPI_TX_31);
  assign spi_ss_sel1      = wb_cyc_i1 & wb_stb_i1 & (wb_adr_i1[`SPI_OFS_BITS1] == `SPI_SS1);
  
  // Read from registers
  always @(wb_adr_i1 or rx1 or ctrl1 or divider1 or ss)
  begin
    case (wb_adr_i1[`SPI_OFS_BITS1])
`ifdef SPI_MAX_CHAR_1281
      `SPI_RX_01:    wb_dat1 = rx1[31:0];
      `SPI_RX_11:    wb_dat1 = rx1[63:32];
      `SPI_RX_21:    wb_dat1 = rx1[95:64];
      `SPI_RX_31:    wb_dat1 = {{128-`SPI_MAX_CHAR1{1'b0}}, rx1[`SPI_MAX_CHAR1-1:96]};
`else
`ifdef SPI_MAX_CHAR_641
      `SPI_RX_01:    wb_dat1 = rx1[31:0];
      `SPI_RX_11:    wb_dat1 = {{64-`SPI_MAX_CHAR1{1'b0}}, rx1[`SPI_MAX_CHAR1-1:32]};
      `SPI_RX_21:    wb_dat1 = 32'b0;
      `SPI_RX_31:    wb_dat1 = 32'b0;
`else
      `SPI_RX_01:    wb_dat1 = {{32-`SPI_MAX_CHAR1{1'b0}}, rx1[`SPI_MAX_CHAR1-1:0]};
      `SPI_RX_11:    wb_dat1 = 32'b0;
      `SPI_RX_21:    wb_dat1 = 32'b0;
      `SPI_RX_31:    wb_dat1 = 32'b0;
`endif
`endif
      `SPI_CTRL1:    wb_dat1 = {{32-`SPI_CTRL_BIT_NB1{1'b0}}, ctrl1};
      `SPI_DEVIDE1:  wb_dat1 = {{32-`SPI_DIVIDER_LEN1{1'b0}}, divider1};
      `SPI_SS1:      wb_dat1 = {{32-`SPI_SS_NB1{1'b0}}, ss};
      default:      wb_dat1 = 32'bx;
    endcase
  end
  
  // Wb1 data out
  always @(posedge wb_clk_i1 or posedge wb_rst_i1)
  begin
    if (wb_rst_i1)
      wb_dat_o1 <= #Tp1 32'b0;
    else
      wb_dat_o1 <= #Tp1 wb_dat1;
  end
  
  // Wb1 acknowledge1
  always @(posedge wb_clk_i1 or posedge wb_rst_i1)
  begin
    if (wb_rst_i1)
      wb_ack_o1 <= #Tp1 1'b0;
    else
      wb_ack_o1 <= #Tp1 wb_cyc_i1 & wb_stb_i1 & ~wb_ack_o1;
  end
  
  // Wb1 error
  assign wb_err_o1 = 1'b0;
  
  // Interrupt1
  always @(posedge wb_clk_i1 or posedge wb_rst_i1)
  begin
    if (wb_rst_i1)
      wb_int_o1 <= #Tp1 1'b0;
    else if (ie1 && tip1 && last_bit1 && pos_edge1)
      wb_int_o1 <= #Tp1 1'b1;
    else if (wb_ack_o1)
      wb_int_o1 <= #Tp1 1'b0;
  end
  
  // Divider1 register
  always @(posedge wb_clk_i1 or posedge wb_rst_i1)
  begin
    if (wb_rst_i1)
        divider1 <= #Tp1 {`SPI_DIVIDER_LEN1{1'b0}};
    else if (spi_divider_sel1 && wb_we_i1 && !tip1)
      begin
      `ifdef SPI_DIVIDER_LEN_81
        if (wb_sel_i1[0])
          divider1 <= #Tp1 wb_dat_i1[`SPI_DIVIDER_LEN1-1:0];
      `endif
      `ifdef SPI_DIVIDER_LEN_161
        if (wb_sel_i1[0])
          divider1[7:0] <= #Tp1 wb_dat_i1[7:0];
        if (wb_sel_i1[1])
          divider1[`SPI_DIVIDER_LEN1-1:8] <= #Tp1 wb_dat_i1[`SPI_DIVIDER_LEN1-1:8];
      `endif
      `ifdef SPI_DIVIDER_LEN_241
        if (wb_sel_i1[0])
          divider1[7:0] <= #Tp1 wb_dat_i1[7:0];
        if (wb_sel_i1[1])
          divider1[15:8] <= #Tp1 wb_dat_i1[15:8];
        if (wb_sel_i1[2])
          divider1[`SPI_DIVIDER_LEN1-1:16] <= #Tp1 wb_dat_i1[`SPI_DIVIDER_LEN1-1:16];
      `endif
      `ifdef SPI_DIVIDER_LEN_321
        if (wb_sel_i1[0])
          divider1[7:0] <= #Tp1 wb_dat_i1[7:0];
        if (wb_sel_i1[1])
          divider1[15:8] <= #Tp1 wb_dat_i1[15:8];
        if (wb_sel_i1[2])
          divider1[23:16] <= #Tp1 wb_dat_i1[23:16];
        if (wb_sel_i1[3])
          divider1[`SPI_DIVIDER_LEN1-1:24] <= #Tp1 wb_dat_i1[`SPI_DIVIDER_LEN1-1:24];
      `endif
      end
  end
  
  // Ctrl1 register
  always @(posedge wb_clk_i1 or posedge wb_rst_i1)
  begin
    if (wb_rst_i1)
      ctrl1 <= #Tp1 {`SPI_CTRL_BIT_NB1{1'b0}};
    else if(spi_ctrl_sel1 && wb_we_i1 && !tip1)
      begin
        if (wb_sel_i1[0])
          ctrl1[7:0] <= #Tp1 wb_dat_i1[7:0] | {7'b0, ctrl1[0]};
        if (wb_sel_i1[1])
          ctrl1[`SPI_CTRL_BIT_NB1-1:8] <= #Tp1 wb_dat_i1[`SPI_CTRL_BIT_NB1-1:8];
      end
    else if(tip1 && last_bit1 && pos_edge1)
      ctrl1[`SPI_CTRL_GO1] <= #Tp1 1'b0;
  end
  
  assign rx_negedge1 = ctrl1[`SPI_CTRL_RX_NEGEDGE1];
  assign tx_negedge1 = ctrl1[`SPI_CTRL_TX_NEGEDGE1];
  assign go1         = ctrl1[`SPI_CTRL_GO1];
  assign char_len1   = ctrl1[`SPI_CTRL_CHAR_LEN1];
  assign lsb        = ctrl1[`SPI_CTRL_LSB1];
  assign ie1         = ctrl1[`SPI_CTRL_IE1];
  assign ass1        = ctrl1[`SPI_CTRL_ASS1];
  
  // Slave1 select1 register
  always @(posedge wb_clk_i1 or posedge wb_rst_i1)
  begin
    if (wb_rst_i1)
      ss <= #Tp1 {`SPI_SS_NB1{1'b0}};
    else if(spi_ss_sel1 && wb_we_i1 && !tip1)
      begin
      `ifdef SPI_SS_NB_81
        if (wb_sel_i1[0])
          ss <= #Tp1 wb_dat_i1[`SPI_SS_NB1-1:0];
      `endif
      `ifdef SPI_SS_NB_161
        if (wb_sel_i1[0])
          ss[7:0] <= #Tp1 wb_dat_i1[7:0];
        if (wb_sel_i1[1])
          ss[`SPI_SS_NB1-1:8] <= #Tp1 wb_dat_i1[`SPI_SS_NB1-1:8];
      `endif
      `ifdef SPI_SS_NB_241
        if (wb_sel_i1[0])
          ss[7:0] <= #Tp1 wb_dat_i1[7:0];
        if (wb_sel_i1[1])
          ss[15:8] <= #Tp1 wb_dat_i1[15:8];
        if (wb_sel_i1[2])
          ss[`SPI_SS_NB1-1:16] <= #Tp1 wb_dat_i1[`SPI_SS_NB1-1:16];
      `endif
      `ifdef SPI_SS_NB_321
        if (wb_sel_i1[0])
          ss[7:0] <= #Tp1 wb_dat_i1[7:0];
        if (wb_sel_i1[1])
          ss[15:8] <= #Tp1 wb_dat_i1[15:8];
        if (wb_sel_i1[2])
          ss[23:16] <= #Tp1 wb_dat_i1[23:16];
        if (wb_sel_i1[3])
          ss[`SPI_SS_NB1-1:24] <= #Tp1 wb_dat_i1[`SPI_SS_NB1-1:24];
      `endif
      end
  end
  
  assign ss_pad_o1 = ~((ss & {`SPI_SS_NB1{tip1 & ass1}}) | (ss & {`SPI_SS_NB1{!ass1}}));
  
  spi_clgen1 clgen1 (.clk_in1(wb_clk_i1), .rst1(wb_rst_i1), .go1(go1), .enable(tip1), .last_clk1(last_bit1),
                   .divider1(divider1), .clk_out1(sclk_pad_o1), .pos_edge1(pos_edge1), 
                   .neg_edge1(neg_edge1));
  
  spi_shift1 shift1 (.clk1(wb_clk_i1), .rst1(wb_rst_i1), .len(char_len1[`SPI_CHAR_LEN_BITS1-1:0]),
                   .latch1(spi_tx_sel1[3:0] & {4{wb_we_i1}}), .byte_sel1(wb_sel_i1), .lsb(lsb), 
                   .go1(go1), .pos_edge1(pos_edge1), .neg_edge1(neg_edge1), 
                   .rx_negedge1(rx_negedge1), .tx_negedge1(tx_negedge1),
                   .tip1(tip1), .last(last_bit1), 
                   .p_in1(wb_dat_i1), .p_out1(rx1), 
                   .s_clk1(sclk_pad_o1), .s_in1(miso_pad_i1), .s_out1(mosi_pad_o1));
endmodule
  
