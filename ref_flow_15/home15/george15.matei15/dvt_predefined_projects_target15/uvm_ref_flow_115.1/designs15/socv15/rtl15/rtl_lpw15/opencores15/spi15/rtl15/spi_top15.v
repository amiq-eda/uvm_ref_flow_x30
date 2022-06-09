//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_top15.v                                                   ////
////                                                              ////
////  This15 file is part of the SPI15 IP15 core15 project15                ////
////  http15://www15.opencores15.org15/projects15/spi15/                      ////
////                                                              ////
////  Author15(s):                                                  ////
////      - Simon15 Srot15 (simons15@opencores15.org15)                     ////
////                                                              ////
////  All additional15 information is avaliable15 in the Readme15.txt15   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright15 (C) 2002 Authors15                                   ////
////                                                              ////
//// This15 source15 file may be used and distributed15 without         ////
//// restriction15 provided that this copyright15 statement15 is not    ////
//// removed from the file and that any derivative15 work15 contains15  ////
//// the original copyright15 notice15 and the associated disclaimer15. ////
////                                                              ////
//// This15 source15 file is free software15; you can redistribute15 it   ////
//// and/or modify it under the terms15 of the GNU15 Lesser15 General15   ////
//// Public15 License15 as published15 by the Free15 Software15 Foundation15; ////
//// either15 version15 2.1 of the License15, or (at your15 option) any   ////
//// later15 version15.                                               ////
////                                                              ////
//// This15 source15 is distributed15 in the hope15 that it will be       ////
//// useful15, but WITHOUT15 ANY15 WARRANTY15; without even15 the implied15   ////
//// warranty15 of MERCHANTABILITY15 or FITNESS15 FOR15 A PARTICULAR15      ////
//// PURPOSE15.  See the GNU15 Lesser15 General15 Public15 License15 for more ////
//// details15.                                                     ////
////                                                              ////
//// You should have received15 a copy of the GNU15 Lesser15 General15    ////
//// Public15 License15 along15 with this source15; if not, download15 it   ////
//// from http15://www15.opencores15.org15/lgpl15.shtml15                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////


`include "spi_defines15.v"
`include "timescale.v"

module spi_top15
(
  // Wishbone15 signals15
  wb_clk_i15, wb_rst_i15, wb_adr_i15, wb_dat_i15, wb_dat_o15, wb_sel_i15,
  wb_we_i15, wb_stb_i15, wb_cyc_i15, wb_ack_o15, wb_err_o15, wb_int_o15,

  // SPI15 signals15
  ss_pad_o15, sclk_pad_o15, mosi_pad_o15, miso_pad_i15
);

  parameter Tp15 = 1;

  // Wishbone15 signals15
  input                            wb_clk_i15;         // master15 clock15 input
  input                            wb_rst_i15;         // synchronous15 active high15 reset
  input                      [4:0] wb_adr_i15;         // lower15 address bits
  input                   [32-1:0] wb_dat_i15;         // databus15 input
  output                  [32-1:0] wb_dat_o15;         // databus15 output
  input                      [3:0] wb_sel_i15;         // byte select15 inputs15
  input                            wb_we_i15;          // write enable input
  input                            wb_stb_i15;         // stobe15/core15 select15 signal15
  input                            wb_cyc_i15;         // valid bus cycle input
  output                           wb_ack_o15;         // bus cycle acknowledge15 output
  output                           wb_err_o15;         // termination w/ error
  output                           wb_int_o15;         // interrupt15 request signal15 output
                                                     
  // SPI15 signals15                                     
  output          [`SPI_SS_NB15-1:0] ss_pad_o15;         // slave15 select15
  output                           sclk_pad_o15;       // serial15 clock15
  output                           mosi_pad_o15;       // master15 out slave15 in
  input                            miso_pad_i15;       // master15 in slave15 out
                                                     
  reg                     [32-1:0] wb_dat_o15;
  reg                              wb_ack_o15;
  reg                              wb_int_o15;
                                               
  // Internal signals15
  reg       [`SPI_DIVIDER_LEN15-1:0] divider15;          // Divider15 register
  reg       [`SPI_CTRL_BIT_NB15-1:0] ctrl15;             // Control15 and status register
  reg             [`SPI_SS_NB15-1:0] ss;               // Slave15 select15 register
  reg                     [32-1:0] wb_dat15;           // wb15 data out
  wire         [`SPI_MAX_CHAR15-1:0] rx15;               // Rx15 register
  wire                             rx_negedge15;       // miso15 is sampled15 on negative edge
  wire                             tx_negedge15;       // mosi15 is driven15 on negative edge
  wire    [`SPI_CHAR_LEN_BITS15-1:0] char_len15;         // char15 len
  wire                             go15;               // go15
  wire                             lsb;              // lsb first on line
  wire                             ie15;               // interrupt15 enable
  wire                             ass15;              // automatic slave15 select15
  wire                             spi_divider_sel15;  // divider15 register select15
  wire                             spi_ctrl_sel15;     // ctrl15 register select15
  wire                       [3:0] spi_tx_sel15;       // tx_l15 register select15
  wire                             spi_ss_sel15;       // ss register select15
  wire                             tip15;              // transfer15 in progress15
  wire                             pos_edge15;         // recognize15 posedge of sclk15
  wire                             neg_edge15;         // recognize15 negedge of sclk15
  wire                             last_bit15;         // marks15 last character15 bit
  
  // Address decoder15
  assign spi_divider_sel15 = wb_cyc_i15 & wb_stb_i15 & (wb_adr_i15[`SPI_OFS_BITS15] == `SPI_DEVIDE15);
  assign spi_ctrl_sel15    = wb_cyc_i15 & wb_stb_i15 & (wb_adr_i15[`SPI_OFS_BITS15] == `SPI_CTRL15);
  assign spi_tx_sel15[0]   = wb_cyc_i15 & wb_stb_i15 & (wb_adr_i15[`SPI_OFS_BITS15] == `SPI_TX_015);
  assign spi_tx_sel15[1]   = wb_cyc_i15 & wb_stb_i15 & (wb_adr_i15[`SPI_OFS_BITS15] == `SPI_TX_115);
  assign spi_tx_sel15[2]   = wb_cyc_i15 & wb_stb_i15 & (wb_adr_i15[`SPI_OFS_BITS15] == `SPI_TX_215);
  assign spi_tx_sel15[3]   = wb_cyc_i15 & wb_stb_i15 & (wb_adr_i15[`SPI_OFS_BITS15] == `SPI_TX_315);
  assign spi_ss_sel15      = wb_cyc_i15 & wb_stb_i15 & (wb_adr_i15[`SPI_OFS_BITS15] == `SPI_SS15);
  
  // Read from registers
  always @(wb_adr_i15 or rx15 or ctrl15 or divider15 or ss)
  begin
    case (wb_adr_i15[`SPI_OFS_BITS15])
`ifdef SPI_MAX_CHAR_12815
      `SPI_RX_015:    wb_dat15 = rx15[31:0];
      `SPI_RX_115:    wb_dat15 = rx15[63:32];
      `SPI_RX_215:    wb_dat15 = rx15[95:64];
      `SPI_RX_315:    wb_dat15 = {{128-`SPI_MAX_CHAR15{1'b0}}, rx15[`SPI_MAX_CHAR15-1:96]};
`else
`ifdef SPI_MAX_CHAR_6415
      `SPI_RX_015:    wb_dat15 = rx15[31:0];
      `SPI_RX_115:    wb_dat15 = {{64-`SPI_MAX_CHAR15{1'b0}}, rx15[`SPI_MAX_CHAR15-1:32]};
      `SPI_RX_215:    wb_dat15 = 32'b0;
      `SPI_RX_315:    wb_dat15 = 32'b0;
`else
      `SPI_RX_015:    wb_dat15 = {{32-`SPI_MAX_CHAR15{1'b0}}, rx15[`SPI_MAX_CHAR15-1:0]};
      `SPI_RX_115:    wb_dat15 = 32'b0;
      `SPI_RX_215:    wb_dat15 = 32'b0;
      `SPI_RX_315:    wb_dat15 = 32'b0;
`endif
`endif
      `SPI_CTRL15:    wb_dat15 = {{32-`SPI_CTRL_BIT_NB15{1'b0}}, ctrl15};
      `SPI_DEVIDE15:  wb_dat15 = {{32-`SPI_DIVIDER_LEN15{1'b0}}, divider15};
      `SPI_SS15:      wb_dat15 = {{32-`SPI_SS_NB15{1'b0}}, ss};
      default:      wb_dat15 = 32'bx;
    endcase
  end
  
  // Wb15 data out
  always @(posedge wb_clk_i15 or posedge wb_rst_i15)
  begin
    if (wb_rst_i15)
      wb_dat_o15 <= #Tp15 32'b0;
    else
      wb_dat_o15 <= #Tp15 wb_dat15;
  end
  
  // Wb15 acknowledge15
  always @(posedge wb_clk_i15 or posedge wb_rst_i15)
  begin
    if (wb_rst_i15)
      wb_ack_o15 <= #Tp15 1'b0;
    else
      wb_ack_o15 <= #Tp15 wb_cyc_i15 & wb_stb_i15 & ~wb_ack_o15;
  end
  
  // Wb15 error
  assign wb_err_o15 = 1'b0;
  
  // Interrupt15
  always @(posedge wb_clk_i15 or posedge wb_rst_i15)
  begin
    if (wb_rst_i15)
      wb_int_o15 <= #Tp15 1'b0;
    else if (ie15 && tip15 && last_bit15 && pos_edge15)
      wb_int_o15 <= #Tp15 1'b1;
    else if (wb_ack_o15)
      wb_int_o15 <= #Tp15 1'b0;
  end
  
  // Divider15 register
  always @(posedge wb_clk_i15 or posedge wb_rst_i15)
  begin
    if (wb_rst_i15)
        divider15 <= #Tp15 {`SPI_DIVIDER_LEN15{1'b0}};
    else if (spi_divider_sel15 && wb_we_i15 && !tip15)
      begin
      `ifdef SPI_DIVIDER_LEN_815
        if (wb_sel_i15[0])
          divider15 <= #Tp15 wb_dat_i15[`SPI_DIVIDER_LEN15-1:0];
      `endif
      `ifdef SPI_DIVIDER_LEN_1615
        if (wb_sel_i15[0])
          divider15[7:0] <= #Tp15 wb_dat_i15[7:0];
        if (wb_sel_i15[1])
          divider15[`SPI_DIVIDER_LEN15-1:8] <= #Tp15 wb_dat_i15[`SPI_DIVIDER_LEN15-1:8];
      `endif
      `ifdef SPI_DIVIDER_LEN_2415
        if (wb_sel_i15[0])
          divider15[7:0] <= #Tp15 wb_dat_i15[7:0];
        if (wb_sel_i15[1])
          divider15[15:8] <= #Tp15 wb_dat_i15[15:8];
        if (wb_sel_i15[2])
          divider15[`SPI_DIVIDER_LEN15-1:16] <= #Tp15 wb_dat_i15[`SPI_DIVIDER_LEN15-1:16];
      `endif
      `ifdef SPI_DIVIDER_LEN_3215
        if (wb_sel_i15[0])
          divider15[7:0] <= #Tp15 wb_dat_i15[7:0];
        if (wb_sel_i15[1])
          divider15[15:8] <= #Tp15 wb_dat_i15[15:8];
        if (wb_sel_i15[2])
          divider15[23:16] <= #Tp15 wb_dat_i15[23:16];
        if (wb_sel_i15[3])
          divider15[`SPI_DIVIDER_LEN15-1:24] <= #Tp15 wb_dat_i15[`SPI_DIVIDER_LEN15-1:24];
      `endif
      end
  end
  
  // Ctrl15 register
  always @(posedge wb_clk_i15 or posedge wb_rst_i15)
  begin
    if (wb_rst_i15)
      ctrl15 <= #Tp15 {`SPI_CTRL_BIT_NB15{1'b0}};
    else if(spi_ctrl_sel15 && wb_we_i15 && !tip15)
      begin
        if (wb_sel_i15[0])
          ctrl15[7:0] <= #Tp15 wb_dat_i15[7:0] | {7'b0, ctrl15[0]};
        if (wb_sel_i15[1])
          ctrl15[`SPI_CTRL_BIT_NB15-1:8] <= #Tp15 wb_dat_i15[`SPI_CTRL_BIT_NB15-1:8];
      end
    else if(tip15 && last_bit15 && pos_edge15)
      ctrl15[`SPI_CTRL_GO15] <= #Tp15 1'b0;
  end
  
  assign rx_negedge15 = ctrl15[`SPI_CTRL_RX_NEGEDGE15];
  assign tx_negedge15 = ctrl15[`SPI_CTRL_TX_NEGEDGE15];
  assign go15         = ctrl15[`SPI_CTRL_GO15];
  assign char_len15   = ctrl15[`SPI_CTRL_CHAR_LEN15];
  assign lsb        = ctrl15[`SPI_CTRL_LSB15];
  assign ie15         = ctrl15[`SPI_CTRL_IE15];
  assign ass15        = ctrl15[`SPI_CTRL_ASS15];
  
  // Slave15 select15 register
  always @(posedge wb_clk_i15 or posedge wb_rst_i15)
  begin
    if (wb_rst_i15)
      ss <= #Tp15 {`SPI_SS_NB15{1'b0}};
    else if(spi_ss_sel15 && wb_we_i15 && !tip15)
      begin
      `ifdef SPI_SS_NB_815
        if (wb_sel_i15[0])
          ss <= #Tp15 wb_dat_i15[`SPI_SS_NB15-1:0];
      `endif
      `ifdef SPI_SS_NB_1615
        if (wb_sel_i15[0])
          ss[7:0] <= #Tp15 wb_dat_i15[7:0];
        if (wb_sel_i15[1])
          ss[`SPI_SS_NB15-1:8] <= #Tp15 wb_dat_i15[`SPI_SS_NB15-1:8];
      `endif
      `ifdef SPI_SS_NB_2415
        if (wb_sel_i15[0])
          ss[7:0] <= #Tp15 wb_dat_i15[7:0];
        if (wb_sel_i15[1])
          ss[15:8] <= #Tp15 wb_dat_i15[15:8];
        if (wb_sel_i15[2])
          ss[`SPI_SS_NB15-1:16] <= #Tp15 wb_dat_i15[`SPI_SS_NB15-1:16];
      `endif
      `ifdef SPI_SS_NB_3215
        if (wb_sel_i15[0])
          ss[7:0] <= #Tp15 wb_dat_i15[7:0];
        if (wb_sel_i15[1])
          ss[15:8] <= #Tp15 wb_dat_i15[15:8];
        if (wb_sel_i15[2])
          ss[23:16] <= #Tp15 wb_dat_i15[23:16];
        if (wb_sel_i15[3])
          ss[`SPI_SS_NB15-1:24] <= #Tp15 wb_dat_i15[`SPI_SS_NB15-1:24];
      `endif
      end
  end
  
  assign ss_pad_o15 = ~((ss & {`SPI_SS_NB15{tip15 & ass15}}) | (ss & {`SPI_SS_NB15{!ass15}}));
  
  spi_clgen15 clgen15 (.clk_in15(wb_clk_i15), .rst15(wb_rst_i15), .go15(go15), .enable(tip15), .last_clk15(last_bit15),
                   .divider15(divider15), .clk_out15(sclk_pad_o15), .pos_edge15(pos_edge15), 
                   .neg_edge15(neg_edge15));
  
  spi_shift15 shift15 (.clk15(wb_clk_i15), .rst15(wb_rst_i15), .len(char_len15[`SPI_CHAR_LEN_BITS15-1:0]),
                   .latch15(spi_tx_sel15[3:0] & {4{wb_we_i15}}), .byte_sel15(wb_sel_i15), .lsb(lsb), 
                   .go15(go15), .pos_edge15(pos_edge15), .neg_edge15(neg_edge15), 
                   .rx_negedge15(rx_negedge15), .tx_negedge15(tx_negedge15),
                   .tip15(tip15), .last(last_bit15), 
                   .p_in15(wb_dat_i15), .p_out15(rx15), 
                   .s_clk15(sclk_pad_o15), .s_in15(miso_pad_i15), .s_out15(mosi_pad_o15));
endmodule
  
