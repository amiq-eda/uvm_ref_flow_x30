//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_top28.v                                                   ////
////                                                              ////
////  This28 file is part of the SPI28 IP28 core28 project28                ////
////  http28://www28.opencores28.org28/projects28/spi28/                      ////
////                                                              ////
////  Author28(s):                                                  ////
////      - Simon28 Srot28 (simons28@opencores28.org28)                     ////
////                                                              ////
////  All additional28 information is avaliable28 in the Readme28.txt28   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright28 (C) 2002 Authors28                                   ////
////                                                              ////
//// This28 source28 file may be used and distributed28 without         ////
//// restriction28 provided that this copyright28 statement28 is not    ////
//// removed from the file and that any derivative28 work28 contains28  ////
//// the original copyright28 notice28 and the associated disclaimer28. ////
////                                                              ////
//// This28 source28 file is free software28; you can redistribute28 it   ////
//// and/or modify it under the terms28 of the GNU28 Lesser28 General28   ////
//// Public28 License28 as published28 by the Free28 Software28 Foundation28; ////
//// either28 version28 2.1 of the License28, or (at your28 option) any   ////
//// later28 version28.                                               ////
////                                                              ////
//// This28 source28 is distributed28 in the hope28 that it will be       ////
//// useful28, but WITHOUT28 ANY28 WARRANTY28; without even28 the implied28   ////
//// warranty28 of MERCHANTABILITY28 or FITNESS28 FOR28 A PARTICULAR28      ////
//// PURPOSE28.  See the GNU28 Lesser28 General28 Public28 License28 for more ////
//// details28.                                                     ////
////                                                              ////
//// You should have received28 a copy of the GNU28 Lesser28 General28    ////
//// Public28 License28 along28 with this source28; if not, download28 it   ////
//// from http28://www28.opencores28.org28/lgpl28.shtml28                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////


`include "spi_defines28.v"
`include "timescale.v"

module spi_top28
(
  // Wishbone28 signals28
  wb_clk_i28, wb_rst_i28, wb_adr_i28, wb_dat_i28, wb_dat_o28, wb_sel_i28,
  wb_we_i28, wb_stb_i28, wb_cyc_i28, wb_ack_o28, wb_err_o28, wb_int_o28,

  // SPI28 signals28
  ss_pad_o28, sclk_pad_o28, mosi_pad_o28, miso_pad_i28
);

  parameter Tp28 = 1;

  // Wishbone28 signals28
  input                            wb_clk_i28;         // master28 clock28 input
  input                            wb_rst_i28;         // synchronous28 active high28 reset
  input                      [4:0] wb_adr_i28;         // lower28 address bits
  input                   [32-1:0] wb_dat_i28;         // databus28 input
  output                  [32-1:0] wb_dat_o28;         // databus28 output
  input                      [3:0] wb_sel_i28;         // byte select28 inputs28
  input                            wb_we_i28;          // write enable input
  input                            wb_stb_i28;         // stobe28/core28 select28 signal28
  input                            wb_cyc_i28;         // valid bus cycle input
  output                           wb_ack_o28;         // bus cycle acknowledge28 output
  output                           wb_err_o28;         // termination w/ error
  output                           wb_int_o28;         // interrupt28 request signal28 output
                                                     
  // SPI28 signals28                                     
  output          [`SPI_SS_NB28-1:0] ss_pad_o28;         // slave28 select28
  output                           sclk_pad_o28;       // serial28 clock28
  output                           mosi_pad_o28;       // master28 out slave28 in
  input                            miso_pad_i28;       // master28 in slave28 out
                                                     
  reg                     [32-1:0] wb_dat_o28;
  reg                              wb_ack_o28;
  reg                              wb_int_o28;
                                               
  // Internal signals28
  reg       [`SPI_DIVIDER_LEN28-1:0] divider28;          // Divider28 register
  reg       [`SPI_CTRL_BIT_NB28-1:0] ctrl28;             // Control28 and status register
  reg             [`SPI_SS_NB28-1:0] ss;               // Slave28 select28 register
  reg                     [32-1:0] wb_dat28;           // wb28 data out
  wire         [`SPI_MAX_CHAR28-1:0] rx28;               // Rx28 register
  wire                             rx_negedge28;       // miso28 is sampled28 on negative edge
  wire                             tx_negedge28;       // mosi28 is driven28 on negative edge
  wire    [`SPI_CHAR_LEN_BITS28-1:0] char_len28;         // char28 len
  wire                             go28;               // go28
  wire                             lsb;              // lsb first on line
  wire                             ie28;               // interrupt28 enable
  wire                             ass28;              // automatic slave28 select28
  wire                             spi_divider_sel28;  // divider28 register select28
  wire                             spi_ctrl_sel28;     // ctrl28 register select28
  wire                       [3:0] spi_tx_sel28;       // tx_l28 register select28
  wire                             spi_ss_sel28;       // ss register select28
  wire                             tip28;              // transfer28 in progress28
  wire                             pos_edge28;         // recognize28 posedge of sclk28
  wire                             neg_edge28;         // recognize28 negedge of sclk28
  wire                             last_bit28;         // marks28 last character28 bit
  
  // Address decoder28
  assign spi_divider_sel28 = wb_cyc_i28 & wb_stb_i28 & (wb_adr_i28[`SPI_OFS_BITS28] == `SPI_DEVIDE28);
  assign spi_ctrl_sel28    = wb_cyc_i28 & wb_stb_i28 & (wb_adr_i28[`SPI_OFS_BITS28] == `SPI_CTRL28);
  assign spi_tx_sel28[0]   = wb_cyc_i28 & wb_stb_i28 & (wb_adr_i28[`SPI_OFS_BITS28] == `SPI_TX_028);
  assign spi_tx_sel28[1]   = wb_cyc_i28 & wb_stb_i28 & (wb_adr_i28[`SPI_OFS_BITS28] == `SPI_TX_128);
  assign spi_tx_sel28[2]   = wb_cyc_i28 & wb_stb_i28 & (wb_adr_i28[`SPI_OFS_BITS28] == `SPI_TX_228);
  assign spi_tx_sel28[3]   = wb_cyc_i28 & wb_stb_i28 & (wb_adr_i28[`SPI_OFS_BITS28] == `SPI_TX_328);
  assign spi_ss_sel28      = wb_cyc_i28 & wb_stb_i28 & (wb_adr_i28[`SPI_OFS_BITS28] == `SPI_SS28);
  
  // Read from registers
  always @(wb_adr_i28 or rx28 or ctrl28 or divider28 or ss)
  begin
    case (wb_adr_i28[`SPI_OFS_BITS28])
`ifdef SPI_MAX_CHAR_12828
      `SPI_RX_028:    wb_dat28 = rx28[31:0];
      `SPI_RX_128:    wb_dat28 = rx28[63:32];
      `SPI_RX_228:    wb_dat28 = rx28[95:64];
      `SPI_RX_328:    wb_dat28 = {{128-`SPI_MAX_CHAR28{1'b0}}, rx28[`SPI_MAX_CHAR28-1:96]};
`else
`ifdef SPI_MAX_CHAR_6428
      `SPI_RX_028:    wb_dat28 = rx28[31:0];
      `SPI_RX_128:    wb_dat28 = {{64-`SPI_MAX_CHAR28{1'b0}}, rx28[`SPI_MAX_CHAR28-1:32]};
      `SPI_RX_228:    wb_dat28 = 32'b0;
      `SPI_RX_328:    wb_dat28 = 32'b0;
`else
      `SPI_RX_028:    wb_dat28 = {{32-`SPI_MAX_CHAR28{1'b0}}, rx28[`SPI_MAX_CHAR28-1:0]};
      `SPI_RX_128:    wb_dat28 = 32'b0;
      `SPI_RX_228:    wb_dat28 = 32'b0;
      `SPI_RX_328:    wb_dat28 = 32'b0;
`endif
`endif
      `SPI_CTRL28:    wb_dat28 = {{32-`SPI_CTRL_BIT_NB28{1'b0}}, ctrl28};
      `SPI_DEVIDE28:  wb_dat28 = {{32-`SPI_DIVIDER_LEN28{1'b0}}, divider28};
      `SPI_SS28:      wb_dat28 = {{32-`SPI_SS_NB28{1'b0}}, ss};
      default:      wb_dat28 = 32'bx;
    endcase
  end
  
  // Wb28 data out
  always @(posedge wb_clk_i28 or posedge wb_rst_i28)
  begin
    if (wb_rst_i28)
      wb_dat_o28 <= #Tp28 32'b0;
    else
      wb_dat_o28 <= #Tp28 wb_dat28;
  end
  
  // Wb28 acknowledge28
  always @(posedge wb_clk_i28 or posedge wb_rst_i28)
  begin
    if (wb_rst_i28)
      wb_ack_o28 <= #Tp28 1'b0;
    else
      wb_ack_o28 <= #Tp28 wb_cyc_i28 & wb_stb_i28 & ~wb_ack_o28;
  end
  
  // Wb28 error
  assign wb_err_o28 = 1'b0;
  
  // Interrupt28
  always @(posedge wb_clk_i28 or posedge wb_rst_i28)
  begin
    if (wb_rst_i28)
      wb_int_o28 <= #Tp28 1'b0;
    else if (ie28 && tip28 && last_bit28 && pos_edge28)
      wb_int_o28 <= #Tp28 1'b1;
    else if (wb_ack_o28)
      wb_int_o28 <= #Tp28 1'b0;
  end
  
  // Divider28 register
  always @(posedge wb_clk_i28 or posedge wb_rst_i28)
  begin
    if (wb_rst_i28)
        divider28 <= #Tp28 {`SPI_DIVIDER_LEN28{1'b0}};
    else if (spi_divider_sel28 && wb_we_i28 && !tip28)
      begin
      `ifdef SPI_DIVIDER_LEN_828
        if (wb_sel_i28[0])
          divider28 <= #Tp28 wb_dat_i28[`SPI_DIVIDER_LEN28-1:0];
      `endif
      `ifdef SPI_DIVIDER_LEN_1628
        if (wb_sel_i28[0])
          divider28[7:0] <= #Tp28 wb_dat_i28[7:0];
        if (wb_sel_i28[1])
          divider28[`SPI_DIVIDER_LEN28-1:8] <= #Tp28 wb_dat_i28[`SPI_DIVIDER_LEN28-1:8];
      `endif
      `ifdef SPI_DIVIDER_LEN_2428
        if (wb_sel_i28[0])
          divider28[7:0] <= #Tp28 wb_dat_i28[7:0];
        if (wb_sel_i28[1])
          divider28[15:8] <= #Tp28 wb_dat_i28[15:8];
        if (wb_sel_i28[2])
          divider28[`SPI_DIVIDER_LEN28-1:16] <= #Tp28 wb_dat_i28[`SPI_DIVIDER_LEN28-1:16];
      `endif
      `ifdef SPI_DIVIDER_LEN_3228
        if (wb_sel_i28[0])
          divider28[7:0] <= #Tp28 wb_dat_i28[7:0];
        if (wb_sel_i28[1])
          divider28[15:8] <= #Tp28 wb_dat_i28[15:8];
        if (wb_sel_i28[2])
          divider28[23:16] <= #Tp28 wb_dat_i28[23:16];
        if (wb_sel_i28[3])
          divider28[`SPI_DIVIDER_LEN28-1:24] <= #Tp28 wb_dat_i28[`SPI_DIVIDER_LEN28-1:24];
      `endif
      end
  end
  
  // Ctrl28 register
  always @(posedge wb_clk_i28 or posedge wb_rst_i28)
  begin
    if (wb_rst_i28)
      ctrl28 <= #Tp28 {`SPI_CTRL_BIT_NB28{1'b0}};
    else if(spi_ctrl_sel28 && wb_we_i28 && !tip28)
      begin
        if (wb_sel_i28[0])
          ctrl28[7:0] <= #Tp28 wb_dat_i28[7:0] | {7'b0, ctrl28[0]};
        if (wb_sel_i28[1])
          ctrl28[`SPI_CTRL_BIT_NB28-1:8] <= #Tp28 wb_dat_i28[`SPI_CTRL_BIT_NB28-1:8];
      end
    else if(tip28 && last_bit28 && pos_edge28)
      ctrl28[`SPI_CTRL_GO28] <= #Tp28 1'b0;
  end
  
  assign rx_negedge28 = ctrl28[`SPI_CTRL_RX_NEGEDGE28];
  assign tx_negedge28 = ctrl28[`SPI_CTRL_TX_NEGEDGE28];
  assign go28         = ctrl28[`SPI_CTRL_GO28];
  assign char_len28   = ctrl28[`SPI_CTRL_CHAR_LEN28];
  assign lsb        = ctrl28[`SPI_CTRL_LSB28];
  assign ie28         = ctrl28[`SPI_CTRL_IE28];
  assign ass28        = ctrl28[`SPI_CTRL_ASS28];
  
  // Slave28 select28 register
  always @(posedge wb_clk_i28 or posedge wb_rst_i28)
  begin
    if (wb_rst_i28)
      ss <= #Tp28 {`SPI_SS_NB28{1'b0}};
    else if(spi_ss_sel28 && wb_we_i28 && !tip28)
      begin
      `ifdef SPI_SS_NB_828
        if (wb_sel_i28[0])
          ss <= #Tp28 wb_dat_i28[`SPI_SS_NB28-1:0];
      `endif
      `ifdef SPI_SS_NB_1628
        if (wb_sel_i28[0])
          ss[7:0] <= #Tp28 wb_dat_i28[7:0];
        if (wb_sel_i28[1])
          ss[`SPI_SS_NB28-1:8] <= #Tp28 wb_dat_i28[`SPI_SS_NB28-1:8];
      `endif
      `ifdef SPI_SS_NB_2428
        if (wb_sel_i28[0])
          ss[7:0] <= #Tp28 wb_dat_i28[7:0];
        if (wb_sel_i28[1])
          ss[15:8] <= #Tp28 wb_dat_i28[15:8];
        if (wb_sel_i28[2])
          ss[`SPI_SS_NB28-1:16] <= #Tp28 wb_dat_i28[`SPI_SS_NB28-1:16];
      `endif
      `ifdef SPI_SS_NB_3228
        if (wb_sel_i28[0])
          ss[7:0] <= #Tp28 wb_dat_i28[7:0];
        if (wb_sel_i28[1])
          ss[15:8] <= #Tp28 wb_dat_i28[15:8];
        if (wb_sel_i28[2])
          ss[23:16] <= #Tp28 wb_dat_i28[23:16];
        if (wb_sel_i28[3])
          ss[`SPI_SS_NB28-1:24] <= #Tp28 wb_dat_i28[`SPI_SS_NB28-1:24];
      `endif
      end
  end
  
  assign ss_pad_o28 = ~((ss & {`SPI_SS_NB28{tip28 & ass28}}) | (ss & {`SPI_SS_NB28{!ass28}}));
  
  spi_clgen28 clgen28 (.clk_in28(wb_clk_i28), .rst28(wb_rst_i28), .go28(go28), .enable(tip28), .last_clk28(last_bit28),
                   .divider28(divider28), .clk_out28(sclk_pad_o28), .pos_edge28(pos_edge28), 
                   .neg_edge28(neg_edge28));
  
  spi_shift28 shift28 (.clk28(wb_clk_i28), .rst28(wb_rst_i28), .len(char_len28[`SPI_CHAR_LEN_BITS28-1:0]),
                   .latch28(spi_tx_sel28[3:0] & {4{wb_we_i28}}), .byte_sel28(wb_sel_i28), .lsb(lsb), 
                   .go28(go28), .pos_edge28(pos_edge28), .neg_edge28(neg_edge28), 
                   .rx_negedge28(rx_negedge28), .tx_negedge28(tx_negedge28),
                   .tip28(tip28), .last(last_bit28), 
                   .p_in28(wb_dat_i28), .p_out28(rx28), 
                   .s_clk28(sclk_pad_o28), .s_in28(miso_pad_i28), .s_out28(mosi_pad_o28));
endmodule
  
