//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_top18.v                                                   ////
////                                                              ////
////  This18 file is part of the SPI18 IP18 core18 project18                ////
////  http18://www18.opencores18.org18/projects18/spi18/                      ////
////                                                              ////
////  Author18(s):                                                  ////
////      - Simon18 Srot18 (simons18@opencores18.org18)                     ////
////                                                              ////
////  All additional18 information is avaliable18 in the Readme18.txt18   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright18 (C) 2002 Authors18                                   ////
////                                                              ////
//// This18 source18 file may be used and distributed18 without         ////
//// restriction18 provided that this copyright18 statement18 is not    ////
//// removed from the file and that any derivative18 work18 contains18  ////
//// the original copyright18 notice18 and the associated disclaimer18. ////
////                                                              ////
//// This18 source18 file is free software18; you can redistribute18 it   ////
//// and/or modify it under the terms18 of the GNU18 Lesser18 General18   ////
//// Public18 License18 as published18 by the Free18 Software18 Foundation18; ////
//// either18 version18 2.1 of the License18, or (at your18 option) any   ////
//// later18 version18.                                               ////
////                                                              ////
//// This18 source18 is distributed18 in the hope18 that it will be       ////
//// useful18, but WITHOUT18 ANY18 WARRANTY18; without even18 the implied18   ////
//// warranty18 of MERCHANTABILITY18 or FITNESS18 FOR18 A PARTICULAR18      ////
//// PURPOSE18.  See the GNU18 Lesser18 General18 Public18 License18 for more ////
//// details18.                                                     ////
////                                                              ////
//// You should have received18 a copy of the GNU18 Lesser18 General18    ////
//// Public18 License18 along18 with this source18; if not, download18 it   ////
//// from http18://www18.opencores18.org18/lgpl18.shtml18                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////


`include "spi_defines18.v"
`include "timescale.v"

module spi_top18
(
  // Wishbone18 signals18
  wb_clk_i18, wb_rst_i18, wb_adr_i18, wb_dat_i18, wb_dat_o18, wb_sel_i18,
  wb_we_i18, wb_stb_i18, wb_cyc_i18, wb_ack_o18, wb_err_o18, wb_int_o18,

  // SPI18 signals18
  ss_pad_o18, sclk_pad_o18, mosi_pad_o18, miso_pad_i18
);

  parameter Tp18 = 1;

  // Wishbone18 signals18
  input                            wb_clk_i18;         // master18 clock18 input
  input                            wb_rst_i18;         // synchronous18 active high18 reset
  input                      [4:0] wb_adr_i18;         // lower18 address bits
  input                   [32-1:0] wb_dat_i18;         // databus18 input
  output                  [32-1:0] wb_dat_o18;         // databus18 output
  input                      [3:0] wb_sel_i18;         // byte select18 inputs18
  input                            wb_we_i18;          // write enable input
  input                            wb_stb_i18;         // stobe18/core18 select18 signal18
  input                            wb_cyc_i18;         // valid bus cycle input
  output                           wb_ack_o18;         // bus cycle acknowledge18 output
  output                           wb_err_o18;         // termination w/ error
  output                           wb_int_o18;         // interrupt18 request signal18 output
                                                     
  // SPI18 signals18                                     
  output          [`SPI_SS_NB18-1:0] ss_pad_o18;         // slave18 select18
  output                           sclk_pad_o18;       // serial18 clock18
  output                           mosi_pad_o18;       // master18 out slave18 in
  input                            miso_pad_i18;       // master18 in slave18 out
                                                     
  reg                     [32-1:0] wb_dat_o18;
  reg                              wb_ack_o18;
  reg                              wb_int_o18;
                                               
  // Internal signals18
  reg       [`SPI_DIVIDER_LEN18-1:0] divider18;          // Divider18 register
  reg       [`SPI_CTRL_BIT_NB18-1:0] ctrl18;             // Control18 and status register
  reg             [`SPI_SS_NB18-1:0] ss;               // Slave18 select18 register
  reg                     [32-1:0] wb_dat18;           // wb18 data out
  wire         [`SPI_MAX_CHAR18-1:0] rx18;               // Rx18 register
  wire                             rx_negedge18;       // miso18 is sampled18 on negative edge
  wire                             tx_negedge18;       // mosi18 is driven18 on negative edge
  wire    [`SPI_CHAR_LEN_BITS18-1:0] char_len18;         // char18 len
  wire                             go18;               // go18
  wire                             lsb;              // lsb first on line
  wire                             ie18;               // interrupt18 enable
  wire                             ass18;              // automatic slave18 select18
  wire                             spi_divider_sel18;  // divider18 register select18
  wire                             spi_ctrl_sel18;     // ctrl18 register select18
  wire                       [3:0] spi_tx_sel18;       // tx_l18 register select18
  wire                             spi_ss_sel18;       // ss register select18
  wire                             tip18;              // transfer18 in progress18
  wire                             pos_edge18;         // recognize18 posedge of sclk18
  wire                             neg_edge18;         // recognize18 negedge of sclk18
  wire                             last_bit18;         // marks18 last character18 bit
  
  // Address decoder18
  assign spi_divider_sel18 = wb_cyc_i18 & wb_stb_i18 & (wb_adr_i18[`SPI_OFS_BITS18] == `SPI_DEVIDE18);
  assign spi_ctrl_sel18    = wb_cyc_i18 & wb_stb_i18 & (wb_adr_i18[`SPI_OFS_BITS18] == `SPI_CTRL18);
  assign spi_tx_sel18[0]   = wb_cyc_i18 & wb_stb_i18 & (wb_adr_i18[`SPI_OFS_BITS18] == `SPI_TX_018);
  assign spi_tx_sel18[1]   = wb_cyc_i18 & wb_stb_i18 & (wb_adr_i18[`SPI_OFS_BITS18] == `SPI_TX_118);
  assign spi_tx_sel18[2]   = wb_cyc_i18 & wb_stb_i18 & (wb_adr_i18[`SPI_OFS_BITS18] == `SPI_TX_218);
  assign spi_tx_sel18[3]   = wb_cyc_i18 & wb_stb_i18 & (wb_adr_i18[`SPI_OFS_BITS18] == `SPI_TX_318);
  assign spi_ss_sel18      = wb_cyc_i18 & wb_stb_i18 & (wb_adr_i18[`SPI_OFS_BITS18] == `SPI_SS18);
  
  // Read from registers
  always @(wb_adr_i18 or rx18 or ctrl18 or divider18 or ss)
  begin
    case (wb_adr_i18[`SPI_OFS_BITS18])
`ifdef SPI_MAX_CHAR_12818
      `SPI_RX_018:    wb_dat18 = rx18[31:0];
      `SPI_RX_118:    wb_dat18 = rx18[63:32];
      `SPI_RX_218:    wb_dat18 = rx18[95:64];
      `SPI_RX_318:    wb_dat18 = {{128-`SPI_MAX_CHAR18{1'b0}}, rx18[`SPI_MAX_CHAR18-1:96]};
`else
`ifdef SPI_MAX_CHAR_6418
      `SPI_RX_018:    wb_dat18 = rx18[31:0];
      `SPI_RX_118:    wb_dat18 = {{64-`SPI_MAX_CHAR18{1'b0}}, rx18[`SPI_MAX_CHAR18-1:32]};
      `SPI_RX_218:    wb_dat18 = 32'b0;
      `SPI_RX_318:    wb_dat18 = 32'b0;
`else
      `SPI_RX_018:    wb_dat18 = {{32-`SPI_MAX_CHAR18{1'b0}}, rx18[`SPI_MAX_CHAR18-1:0]};
      `SPI_RX_118:    wb_dat18 = 32'b0;
      `SPI_RX_218:    wb_dat18 = 32'b0;
      `SPI_RX_318:    wb_dat18 = 32'b0;
`endif
`endif
      `SPI_CTRL18:    wb_dat18 = {{32-`SPI_CTRL_BIT_NB18{1'b0}}, ctrl18};
      `SPI_DEVIDE18:  wb_dat18 = {{32-`SPI_DIVIDER_LEN18{1'b0}}, divider18};
      `SPI_SS18:      wb_dat18 = {{32-`SPI_SS_NB18{1'b0}}, ss};
      default:      wb_dat18 = 32'bx;
    endcase
  end
  
  // Wb18 data out
  always @(posedge wb_clk_i18 or posedge wb_rst_i18)
  begin
    if (wb_rst_i18)
      wb_dat_o18 <= #Tp18 32'b0;
    else
      wb_dat_o18 <= #Tp18 wb_dat18;
  end
  
  // Wb18 acknowledge18
  always @(posedge wb_clk_i18 or posedge wb_rst_i18)
  begin
    if (wb_rst_i18)
      wb_ack_o18 <= #Tp18 1'b0;
    else
      wb_ack_o18 <= #Tp18 wb_cyc_i18 & wb_stb_i18 & ~wb_ack_o18;
  end
  
  // Wb18 error
  assign wb_err_o18 = 1'b0;
  
  // Interrupt18
  always @(posedge wb_clk_i18 or posedge wb_rst_i18)
  begin
    if (wb_rst_i18)
      wb_int_o18 <= #Tp18 1'b0;
    else if (ie18 && tip18 && last_bit18 && pos_edge18)
      wb_int_o18 <= #Tp18 1'b1;
    else if (wb_ack_o18)
      wb_int_o18 <= #Tp18 1'b0;
  end
  
  // Divider18 register
  always @(posedge wb_clk_i18 or posedge wb_rst_i18)
  begin
    if (wb_rst_i18)
        divider18 <= #Tp18 {`SPI_DIVIDER_LEN18{1'b0}};
    else if (spi_divider_sel18 && wb_we_i18 && !tip18)
      begin
      `ifdef SPI_DIVIDER_LEN_818
        if (wb_sel_i18[0])
          divider18 <= #Tp18 wb_dat_i18[`SPI_DIVIDER_LEN18-1:0];
      `endif
      `ifdef SPI_DIVIDER_LEN_1618
        if (wb_sel_i18[0])
          divider18[7:0] <= #Tp18 wb_dat_i18[7:0];
        if (wb_sel_i18[1])
          divider18[`SPI_DIVIDER_LEN18-1:8] <= #Tp18 wb_dat_i18[`SPI_DIVIDER_LEN18-1:8];
      `endif
      `ifdef SPI_DIVIDER_LEN_2418
        if (wb_sel_i18[0])
          divider18[7:0] <= #Tp18 wb_dat_i18[7:0];
        if (wb_sel_i18[1])
          divider18[15:8] <= #Tp18 wb_dat_i18[15:8];
        if (wb_sel_i18[2])
          divider18[`SPI_DIVIDER_LEN18-1:16] <= #Tp18 wb_dat_i18[`SPI_DIVIDER_LEN18-1:16];
      `endif
      `ifdef SPI_DIVIDER_LEN_3218
        if (wb_sel_i18[0])
          divider18[7:0] <= #Tp18 wb_dat_i18[7:0];
        if (wb_sel_i18[1])
          divider18[15:8] <= #Tp18 wb_dat_i18[15:8];
        if (wb_sel_i18[2])
          divider18[23:16] <= #Tp18 wb_dat_i18[23:16];
        if (wb_sel_i18[3])
          divider18[`SPI_DIVIDER_LEN18-1:24] <= #Tp18 wb_dat_i18[`SPI_DIVIDER_LEN18-1:24];
      `endif
      end
  end
  
  // Ctrl18 register
  always @(posedge wb_clk_i18 or posedge wb_rst_i18)
  begin
    if (wb_rst_i18)
      ctrl18 <= #Tp18 {`SPI_CTRL_BIT_NB18{1'b0}};
    else if(spi_ctrl_sel18 && wb_we_i18 && !tip18)
      begin
        if (wb_sel_i18[0])
          ctrl18[7:0] <= #Tp18 wb_dat_i18[7:0] | {7'b0, ctrl18[0]};
        if (wb_sel_i18[1])
          ctrl18[`SPI_CTRL_BIT_NB18-1:8] <= #Tp18 wb_dat_i18[`SPI_CTRL_BIT_NB18-1:8];
      end
    else if(tip18 && last_bit18 && pos_edge18)
      ctrl18[`SPI_CTRL_GO18] <= #Tp18 1'b0;
  end
  
  assign rx_negedge18 = ctrl18[`SPI_CTRL_RX_NEGEDGE18];
  assign tx_negedge18 = ctrl18[`SPI_CTRL_TX_NEGEDGE18];
  assign go18         = ctrl18[`SPI_CTRL_GO18];
  assign char_len18   = ctrl18[`SPI_CTRL_CHAR_LEN18];
  assign lsb        = ctrl18[`SPI_CTRL_LSB18];
  assign ie18         = ctrl18[`SPI_CTRL_IE18];
  assign ass18        = ctrl18[`SPI_CTRL_ASS18];
  
  // Slave18 select18 register
  always @(posedge wb_clk_i18 or posedge wb_rst_i18)
  begin
    if (wb_rst_i18)
      ss <= #Tp18 {`SPI_SS_NB18{1'b0}};
    else if(spi_ss_sel18 && wb_we_i18 && !tip18)
      begin
      `ifdef SPI_SS_NB_818
        if (wb_sel_i18[0])
          ss <= #Tp18 wb_dat_i18[`SPI_SS_NB18-1:0];
      `endif
      `ifdef SPI_SS_NB_1618
        if (wb_sel_i18[0])
          ss[7:0] <= #Tp18 wb_dat_i18[7:0];
        if (wb_sel_i18[1])
          ss[`SPI_SS_NB18-1:8] <= #Tp18 wb_dat_i18[`SPI_SS_NB18-1:8];
      `endif
      `ifdef SPI_SS_NB_2418
        if (wb_sel_i18[0])
          ss[7:0] <= #Tp18 wb_dat_i18[7:0];
        if (wb_sel_i18[1])
          ss[15:8] <= #Tp18 wb_dat_i18[15:8];
        if (wb_sel_i18[2])
          ss[`SPI_SS_NB18-1:16] <= #Tp18 wb_dat_i18[`SPI_SS_NB18-1:16];
      `endif
      `ifdef SPI_SS_NB_3218
        if (wb_sel_i18[0])
          ss[7:0] <= #Tp18 wb_dat_i18[7:0];
        if (wb_sel_i18[1])
          ss[15:8] <= #Tp18 wb_dat_i18[15:8];
        if (wb_sel_i18[2])
          ss[23:16] <= #Tp18 wb_dat_i18[23:16];
        if (wb_sel_i18[3])
          ss[`SPI_SS_NB18-1:24] <= #Tp18 wb_dat_i18[`SPI_SS_NB18-1:24];
      `endif
      end
  end
  
  assign ss_pad_o18 = ~((ss & {`SPI_SS_NB18{tip18 & ass18}}) | (ss & {`SPI_SS_NB18{!ass18}}));
  
  spi_clgen18 clgen18 (.clk_in18(wb_clk_i18), .rst18(wb_rst_i18), .go18(go18), .enable(tip18), .last_clk18(last_bit18),
                   .divider18(divider18), .clk_out18(sclk_pad_o18), .pos_edge18(pos_edge18), 
                   .neg_edge18(neg_edge18));
  
  spi_shift18 shift18 (.clk18(wb_clk_i18), .rst18(wb_rst_i18), .len(char_len18[`SPI_CHAR_LEN_BITS18-1:0]),
                   .latch18(spi_tx_sel18[3:0] & {4{wb_we_i18}}), .byte_sel18(wb_sel_i18), .lsb(lsb), 
                   .go18(go18), .pos_edge18(pos_edge18), .neg_edge18(neg_edge18), 
                   .rx_negedge18(rx_negedge18), .tx_negedge18(tx_negedge18),
                   .tip18(tip18), .last(last_bit18), 
                   .p_in18(wb_dat_i18), .p_out18(rx18), 
                   .s_clk18(sclk_pad_o18), .s_in18(miso_pad_i18), .s_out18(mosi_pad_o18));
endmodule
  
