//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_top16.v                                                   ////
////                                                              ////
////  This16 file is part of the SPI16 IP16 core16 project16                ////
////  http16://www16.opencores16.org16/projects16/spi16/                      ////
////                                                              ////
////  Author16(s):                                                  ////
////      - Simon16 Srot16 (simons16@opencores16.org16)                     ////
////                                                              ////
////  All additional16 information is avaliable16 in the Readme16.txt16   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright16 (C) 2002 Authors16                                   ////
////                                                              ////
//// This16 source16 file may be used and distributed16 without         ////
//// restriction16 provided that this copyright16 statement16 is not    ////
//// removed from the file and that any derivative16 work16 contains16  ////
//// the original copyright16 notice16 and the associated disclaimer16. ////
////                                                              ////
//// This16 source16 file is free software16; you can redistribute16 it   ////
//// and/or modify it under the terms16 of the GNU16 Lesser16 General16   ////
//// Public16 License16 as published16 by the Free16 Software16 Foundation16; ////
//// either16 version16 2.1 of the License16, or (at your16 option) any   ////
//// later16 version16.                                               ////
////                                                              ////
//// This16 source16 is distributed16 in the hope16 that it will be       ////
//// useful16, but WITHOUT16 ANY16 WARRANTY16; without even16 the implied16   ////
//// warranty16 of MERCHANTABILITY16 or FITNESS16 FOR16 A PARTICULAR16      ////
//// PURPOSE16.  See the GNU16 Lesser16 General16 Public16 License16 for more ////
//// details16.                                                     ////
////                                                              ////
//// You should have received16 a copy of the GNU16 Lesser16 General16    ////
//// Public16 License16 along16 with this source16; if not, download16 it   ////
//// from http16://www16.opencores16.org16/lgpl16.shtml16                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////


`include "spi_defines16.v"
`include "timescale.v"

module spi_top16
(
  // Wishbone16 signals16
  wb_clk_i16, wb_rst_i16, wb_adr_i16, wb_dat_i16, wb_dat_o16, wb_sel_i16,
  wb_we_i16, wb_stb_i16, wb_cyc_i16, wb_ack_o16, wb_err_o16, wb_int_o16,

  // SPI16 signals16
  ss_pad_o16, sclk_pad_o16, mosi_pad_o16, miso_pad_i16
);

  parameter Tp16 = 1;

  // Wishbone16 signals16
  input                            wb_clk_i16;         // master16 clock16 input
  input                            wb_rst_i16;         // synchronous16 active high16 reset
  input                      [4:0] wb_adr_i16;         // lower16 address bits
  input                   [32-1:0] wb_dat_i16;         // databus16 input
  output                  [32-1:0] wb_dat_o16;         // databus16 output
  input                      [3:0] wb_sel_i16;         // byte select16 inputs16
  input                            wb_we_i16;          // write enable input
  input                            wb_stb_i16;         // stobe16/core16 select16 signal16
  input                            wb_cyc_i16;         // valid bus cycle input
  output                           wb_ack_o16;         // bus cycle acknowledge16 output
  output                           wb_err_o16;         // termination w/ error
  output                           wb_int_o16;         // interrupt16 request signal16 output
                                                     
  // SPI16 signals16                                     
  output          [`SPI_SS_NB16-1:0] ss_pad_o16;         // slave16 select16
  output                           sclk_pad_o16;       // serial16 clock16
  output                           mosi_pad_o16;       // master16 out slave16 in
  input                            miso_pad_i16;       // master16 in slave16 out
                                                     
  reg                     [32-1:0] wb_dat_o16;
  reg                              wb_ack_o16;
  reg                              wb_int_o16;
                                               
  // Internal signals16
  reg       [`SPI_DIVIDER_LEN16-1:0] divider16;          // Divider16 register
  reg       [`SPI_CTRL_BIT_NB16-1:0] ctrl16;             // Control16 and status register
  reg             [`SPI_SS_NB16-1:0] ss;               // Slave16 select16 register
  reg                     [32-1:0] wb_dat16;           // wb16 data out
  wire         [`SPI_MAX_CHAR16-1:0] rx16;               // Rx16 register
  wire                             rx_negedge16;       // miso16 is sampled16 on negative edge
  wire                             tx_negedge16;       // mosi16 is driven16 on negative edge
  wire    [`SPI_CHAR_LEN_BITS16-1:0] char_len16;         // char16 len
  wire                             go16;               // go16
  wire                             lsb;              // lsb first on line
  wire                             ie16;               // interrupt16 enable
  wire                             ass16;              // automatic slave16 select16
  wire                             spi_divider_sel16;  // divider16 register select16
  wire                             spi_ctrl_sel16;     // ctrl16 register select16
  wire                       [3:0] spi_tx_sel16;       // tx_l16 register select16
  wire                             spi_ss_sel16;       // ss register select16
  wire                             tip16;              // transfer16 in progress16
  wire                             pos_edge16;         // recognize16 posedge of sclk16
  wire                             neg_edge16;         // recognize16 negedge of sclk16
  wire                             last_bit16;         // marks16 last character16 bit
  
  // Address decoder16
  assign spi_divider_sel16 = wb_cyc_i16 & wb_stb_i16 & (wb_adr_i16[`SPI_OFS_BITS16] == `SPI_DEVIDE16);
  assign spi_ctrl_sel16    = wb_cyc_i16 & wb_stb_i16 & (wb_adr_i16[`SPI_OFS_BITS16] == `SPI_CTRL16);
  assign spi_tx_sel16[0]   = wb_cyc_i16 & wb_stb_i16 & (wb_adr_i16[`SPI_OFS_BITS16] == `SPI_TX_016);
  assign spi_tx_sel16[1]   = wb_cyc_i16 & wb_stb_i16 & (wb_adr_i16[`SPI_OFS_BITS16] == `SPI_TX_116);
  assign spi_tx_sel16[2]   = wb_cyc_i16 & wb_stb_i16 & (wb_adr_i16[`SPI_OFS_BITS16] == `SPI_TX_216);
  assign spi_tx_sel16[3]   = wb_cyc_i16 & wb_stb_i16 & (wb_adr_i16[`SPI_OFS_BITS16] == `SPI_TX_316);
  assign spi_ss_sel16      = wb_cyc_i16 & wb_stb_i16 & (wb_adr_i16[`SPI_OFS_BITS16] == `SPI_SS16);
  
  // Read from registers
  always @(wb_adr_i16 or rx16 or ctrl16 or divider16 or ss)
  begin
    case (wb_adr_i16[`SPI_OFS_BITS16])
`ifdef SPI_MAX_CHAR_12816
      `SPI_RX_016:    wb_dat16 = rx16[31:0];
      `SPI_RX_116:    wb_dat16 = rx16[63:32];
      `SPI_RX_216:    wb_dat16 = rx16[95:64];
      `SPI_RX_316:    wb_dat16 = {{128-`SPI_MAX_CHAR16{1'b0}}, rx16[`SPI_MAX_CHAR16-1:96]};
`else
`ifdef SPI_MAX_CHAR_6416
      `SPI_RX_016:    wb_dat16 = rx16[31:0];
      `SPI_RX_116:    wb_dat16 = {{64-`SPI_MAX_CHAR16{1'b0}}, rx16[`SPI_MAX_CHAR16-1:32]};
      `SPI_RX_216:    wb_dat16 = 32'b0;
      `SPI_RX_316:    wb_dat16 = 32'b0;
`else
      `SPI_RX_016:    wb_dat16 = {{32-`SPI_MAX_CHAR16{1'b0}}, rx16[`SPI_MAX_CHAR16-1:0]};
      `SPI_RX_116:    wb_dat16 = 32'b0;
      `SPI_RX_216:    wb_dat16 = 32'b0;
      `SPI_RX_316:    wb_dat16 = 32'b0;
`endif
`endif
      `SPI_CTRL16:    wb_dat16 = {{32-`SPI_CTRL_BIT_NB16{1'b0}}, ctrl16};
      `SPI_DEVIDE16:  wb_dat16 = {{32-`SPI_DIVIDER_LEN16{1'b0}}, divider16};
      `SPI_SS16:      wb_dat16 = {{32-`SPI_SS_NB16{1'b0}}, ss};
      default:      wb_dat16 = 32'bx;
    endcase
  end
  
  // Wb16 data out
  always @(posedge wb_clk_i16 or posedge wb_rst_i16)
  begin
    if (wb_rst_i16)
      wb_dat_o16 <= #Tp16 32'b0;
    else
      wb_dat_o16 <= #Tp16 wb_dat16;
  end
  
  // Wb16 acknowledge16
  always @(posedge wb_clk_i16 or posedge wb_rst_i16)
  begin
    if (wb_rst_i16)
      wb_ack_o16 <= #Tp16 1'b0;
    else
      wb_ack_o16 <= #Tp16 wb_cyc_i16 & wb_stb_i16 & ~wb_ack_o16;
  end
  
  // Wb16 error
  assign wb_err_o16 = 1'b0;
  
  // Interrupt16
  always @(posedge wb_clk_i16 or posedge wb_rst_i16)
  begin
    if (wb_rst_i16)
      wb_int_o16 <= #Tp16 1'b0;
    else if (ie16 && tip16 && last_bit16 && pos_edge16)
      wb_int_o16 <= #Tp16 1'b1;
    else if (wb_ack_o16)
      wb_int_o16 <= #Tp16 1'b0;
  end
  
  // Divider16 register
  always @(posedge wb_clk_i16 or posedge wb_rst_i16)
  begin
    if (wb_rst_i16)
        divider16 <= #Tp16 {`SPI_DIVIDER_LEN16{1'b0}};
    else if (spi_divider_sel16 && wb_we_i16 && !tip16)
      begin
      `ifdef SPI_DIVIDER_LEN_816
        if (wb_sel_i16[0])
          divider16 <= #Tp16 wb_dat_i16[`SPI_DIVIDER_LEN16-1:0];
      `endif
      `ifdef SPI_DIVIDER_LEN_1616
        if (wb_sel_i16[0])
          divider16[7:0] <= #Tp16 wb_dat_i16[7:0];
        if (wb_sel_i16[1])
          divider16[`SPI_DIVIDER_LEN16-1:8] <= #Tp16 wb_dat_i16[`SPI_DIVIDER_LEN16-1:8];
      `endif
      `ifdef SPI_DIVIDER_LEN_2416
        if (wb_sel_i16[0])
          divider16[7:0] <= #Tp16 wb_dat_i16[7:0];
        if (wb_sel_i16[1])
          divider16[15:8] <= #Tp16 wb_dat_i16[15:8];
        if (wb_sel_i16[2])
          divider16[`SPI_DIVIDER_LEN16-1:16] <= #Tp16 wb_dat_i16[`SPI_DIVIDER_LEN16-1:16];
      `endif
      `ifdef SPI_DIVIDER_LEN_3216
        if (wb_sel_i16[0])
          divider16[7:0] <= #Tp16 wb_dat_i16[7:0];
        if (wb_sel_i16[1])
          divider16[15:8] <= #Tp16 wb_dat_i16[15:8];
        if (wb_sel_i16[2])
          divider16[23:16] <= #Tp16 wb_dat_i16[23:16];
        if (wb_sel_i16[3])
          divider16[`SPI_DIVIDER_LEN16-1:24] <= #Tp16 wb_dat_i16[`SPI_DIVIDER_LEN16-1:24];
      `endif
      end
  end
  
  // Ctrl16 register
  always @(posedge wb_clk_i16 or posedge wb_rst_i16)
  begin
    if (wb_rst_i16)
      ctrl16 <= #Tp16 {`SPI_CTRL_BIT_NB16{1'b0}};
    else if(spi_ctrl_sel16 && wb_we_i16 && !tip16)
      begin
        if (wb_sel_i16[0])
          ctrl16[7:0] <= #Tp16 wb_dat_i16[7:0] | {7'b0, ctrl16[0]};
        if (wb_sel_i16[1])
          ctrl16[`SPI_CTRL_BIT_NB16-1:8] <= #Tp16 wb_dat_i16[`SPI_CTRL_BIT_NB16-1:8];
      end
    else if(tip16 && last_bit16 && pos_edge16)
      ctrl16[`SPI_CTRL_GO16] <= #Tp16 1'b0;
  end
  
  assign rx_negedge16 = ctrl16[`SPI_CTRL_RX_NEGEDGE16];
  assign tx_negedge16 = ctrl16[`SPI_CTRL_TX_NEGEDGE16];
  assign go16         = ctrl16[`SPI_CTRL_GO16];
  assign char_len16   = ctrl16[`SPI_CTRL_CHAR_LEN16];
  assign lsb        = ctrl16[`SPI_CTRL_LSB16];
  assign ie16         = ctrl16[`SPI_CTRL_IE16];
  assign ass16        = ctrl16[`SPI_CTRL_ASS16];
  
  // Slave16 select16 register
  always @(posedge wb_clk_i16 or posedge wb_rst_i16)
  begin
    if (wb_rst_i16)
      ss <= #Tp16 {`SPI_SS_NB16{1'b0}};
    else if(spi_ss_sel16 && wb_we_i16 && !tip16)
      begin
      `ifdef SPI_SS_NB_816
        if (wb_sel_i16[0])
          ss <= #Tp16 wb_dat_i16[`SPI_SS_NB16-1:0];
      `endif
      `ifdef SPI_SS_NB_1616
        if (wb_sel_i16[0])
          ss[7:0] <= #Tp16 wb_dat_i16[7:0];
        if (wb_sel_i16[1])
          ss[`SPI_SS_NB16-1:8] <= #Tp16 wb_dat_i16[`SPI_SS_NB16-1:8];
      `endif
      `ifdef SPI_SS_NB_2416
        if (wb_sel_i16[0])
          ss[7:0] <= #Tp16 wb_dat_i16[7:0];
        if (wb_sel_i16[1])
          ss[15:8] <= #Tp16 wb_dat_i16[15:8];
        if (wb_sel_i16[2])
          ss[`SPI_SS_NB16-1:16] <= #Tp16 wb_dat_i16[`SPI_SS_NB16-1:16];
      `endif
      `ifdef SPI_SS_NB_3216
        if (wb_sel_i16[0])
          ss[7:0] <= #Tp16 wb_dat_i16[7:0];
        if (wb_sel_i16[1])
          ss[15:8] <= #Tp16 wb_dat_i16[15:8];
        if (wb_sel_i16[2])
          ss[23:16] <= #Tp16 wb_dat_i16[23:16];
        if (wb_sel_i16[3])
          ss[`SPI_SS_NB16-1:24] <= #Tp16 wb_dat_i16[`SPI_SS_NB16-1:24];
      `endif
      end
  end
  
  assign ss_pad_o16 = ~((ss & {`SPI_SS_NB16{tip16 & ass16}}) | (ss & {`SPI_SS_NB16{!ass16}}));
  
  spi_clgen16 clgen16 (.clk_in16(wb_clk_i16), .rst16(wb_rst_i16), .go16(go16), .enable(tip16), .last_clk16(last_bit16),
                   .divider16(divider16), .clk_out16(sclk_pad_o16), .pos_edge16(pos_edge16), 
                   .neg_edge16(neg_edge16));
  
  spi_shift16 shift16 (.clk16(wb_clk_i16), .rst16(wb_rst_i16), .len(char_len16[`SPI_CHAR_LEN_BITS16-1:0]),
                   .latch16(spi_tx_sel16[3:0] & {4{wb_we_i16}}), .byte_sel16(wb_sel_i16), .lsb(lsb), 
                   .go16(go16), .pos_edge16(pos_edge16), .neg_edge16(neg_edge16), 
                   .rx_negedge16(rx_negedge16), .tx_negedge16(tx_negedge16),
                   .tip16(tip16), .last(last_bit16), 
                   .p_in16(wb_dat_i16), .p_out16(rx16), 
                   .s_clk16(sclk_pad_o16), .s_in16(miso_pad_i16), .s_out16(mosi_pad_o16));
endmodule
  
