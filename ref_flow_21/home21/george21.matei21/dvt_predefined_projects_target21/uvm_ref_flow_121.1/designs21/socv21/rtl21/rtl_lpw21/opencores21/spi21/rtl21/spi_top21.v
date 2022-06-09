//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_top21.v                                                   ////
////                                                              ////
////  This21 file is part of the SPI21 IP21 core21 project21                ////
////  http21://www21.opencores21.org21/projects21/spi21/                      ////
////                                                              ////
////  Author21(s):                                                  ////
////      - Simon21 Srot21 (simons21@opencores21.org21)                     ////
////                                                              ////
////  All additional21 information is avaliable21 in the Readme21.txt21   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright21 (C) 2002 Authors21                                   ////
////                                                              ////
//// This21 source21 file may be used and distributed21 without         ////
//// restriction21 provided that this copyright21 statement21 is not    ////
//// removed from the file and that any derivative21 work21 contains21  ////
//// the original copyright21 notice21 and the associated disclaimer21. ////
////                                                              ////
//// This21 source21 file is free software21; you can redistribute21 it   ////
//// and/or modify it under the terms21 of the GNU21 Lesser21 General21   ////
//// Public21 License21 as published21 by the Free21 Software21 Foundation21; ////
//// either21 version21 2.1 of the License21, or (at your21 option) any   ////
//// later21 version21.                                               ////
////                                                              ////
//// This21 source21 is distributed21 in the hope21 that it will be       ////
//// useful21, but WITHOUT21 ANY21 WARRANTY21; without even21 the implied21   ////
//// warranty21 of MERCHANTABILITY21 or FITNESS21 FOR21 A PARTICULAR21      ////
//// PURPOSE21.  See the GNU21 Lesser21 General21 Public21 License21 for more ////
//// details21.                                                     ////
////                                                              ////
//// You should have received21 a copy of the GNU21 Lesser21 General21    ////
//// Public21 License21 along21 with this source21; if not, download21 it   ////
//// from http21://www21.opencores21.org21/lgpl21.shtml21                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////


`include "spi_defines21.v"
`include "timescale.v"

module spi_top21
(
  // Wishbone21 signals21
  wb_clk_i21, wb_rst_i21, wb_adr_i21, wb_dat_i21, wb_dat_o21, wb_sel_i21,
  wb_we_i21, wb_stb_i21, wb_cyc_i21, wb_ack_o21, wb_err_o21, wb_int_o21,

  // SPI21 signals21
  ss_pad_o21, sclk_pad_o21, mosi_pad_o21, miso_pad_i21
);

  parameter Tp21 = 1;

  // Wishbone21 signals21
  input                            wb_clk_i21;         // master21 clock21 input
  input                            wb_rst_i21;         // synchronous21 active high21 reset
  input                      [4:0] wb_adr_i21;         // lower21 address bits
  input                   [32-1:0] wb_dat_i21;         // databus21 input
  output                  [32-1:0] wb_dat_o21;         // databus21 output
  input                      [3:0] wb_sel_i21;         // byte select21 inputs21
  input                            wb_we_i21;          // write enable input
  input                            wb_stb_i21;         // stobe21/core21 select21 signal21
  input                            wb_cyc_i21;         // valid bus cycle input
  output                           wb_ack_o21;         // bus cycle acknowledge21 output
  output                           wb_err_o21;         // termination w/ error
  output                           wb_int_o21;         // interrupt21 request signal21 output
                                                     
  // SPI21 signals21                                     
  output          [`SPI_SS_NB21-1:0] ss_pad_o21;         // slave21 select21
  output                           sclk_pad_o21;       // serial21 clock21
  output                           mosi_pad_o21;       // master21 out slave21 in
  input                            miso_pad_i21;       // master21 in slave21 out
                                                     
  reg                     [32-1:0] wb_dat_o21;
  reg                              wb_ack_o21;
  reg                              wb_int_o21;
                                               
  // Internal signals21
  reg       [`SPI_DIVIDER_LEN21-1:0] divider21;          // Divider21 register
  reg       [`SPI_CTRL_BIT_NB21-1:0] ctrl21;             // Control21 and status register
  reg             [`SPI_SS_NB21-1:0] ss;               // Slave21 select21 register
  reg                     [32-1:0] wb_dat21;           // wb21 data out
  wire         [`SPI_MAX_CHAR21-1:0] rx21;               // Rx21 register
  wire                             rx_negedge21;       // miso21 is sampled21 on negative edge
  wire                             tx_negedge21;       // mosi21 is driven21 on negative edge
  wire    [`SPI_CHAR_LEN_BITS21-1:0] char_len21;         // char21 len
  wire                             go21;               // go21
  wire                             lsb;              // lsb first on line
  wire                             ie21;               // interrupt21 enable
  wire                             ass21;              // automatic slave21 select21
  wire                             spi_divider_sel21;  // divider21 register select21
  wire                             spi_ctrl_sel21;     // ctrl21 register select21
  wire                       [3:0] spi_tx_sel21;       // tx_l21 register select21
  wire                             spi_ss_sel21;       // ss register select21
  wire                             tip21;              // transfer21 in progress21
  wire                             pos_edge21;         // recognize21 posedge of sclk21
  wire                             neg_edge21;         // recognize21 negedge of sclk21
  wire                             last_bit21;         // marks21 last character21 bit
  
  // Address decoder21
  assign spi_divider_sel21 = wb_cyc_i21 & wb_stb_i21 & (wb_adr_i21[`SPI_OFS_BITS21] == `SPI_DEVIDE21);
  assign spi_ctrl_sel21    = wb_cyc_i21 & wb_stb_i21 & (wb_adr_i21[`SPI_OFS_BITS21] == `SPI_CTRL21);
  assign spi_tx_sel21[0]   = wb_cyc_i21 & wb_stb_i21 & (wb_adr_i21[`SPI_OFS_BITS21] == `SPI_TX_021);
  assign spi_tx_sel21[1]   = wb_cyc_i21 & wb_stb_i21 & (wb_adr_i21[`SPI_OFS_BITS21] == `SPI_TX_121);
  assign spi_tx_sel21[2]   = wb_cyc_i21 & wb_stb_i21 & (wb_adr_i21[`SPI_OFS_BITS21] == `SPI_TX_221);
  assign spi_tx_sel21[3]   = wb_cyc_i21 & wb_stb_i21 & (wb_adr_i21[`SPI_OFS_BITS21] == `SPI_TX_321);
  assign spi_ss_sel21      = wb_cyc_i21 & wb_stb_i21 & (wb_adr_i21[`SPI_OFS_BITS21] == `SPI_SS21);
  
  // Read from registers
  always @(wb_adr_i21 or rx21 or ctrl21 or divider21 or ss)
  begin
    case (wb_adr_i21[`SPI_OFS_BITS21])
`ifdef SPI_MAX_CHAR_12821
      `SPI_RX_021:    wb_dat21 = rx21[31:0];
      `SPI_RX_121:    wb_dat21 = rx21[63:32];
      `SPI_RX_221:    wb_dat21 = rx21[95:64];
      `SPI_RX_321:    wb_dat21 = {{128-`SPI_MAX_CHAR21{1'b0}}, rx21[`SPI_MAX_CHAR21-1:96]};
`else
`ifdef SPI_MAX_CHAR_6421
      `SPI_RX_021:    wb_dat21 = rx21[31:0];
      `SPI_RX_121:    wb_dat21 = {{64-`SPI_MAX_CHAR21{1'b0}}, rx21[`SPI_MAX_CHAR21-1:32]};
      `SPI_RX_221:    wb_dat21 = 32'b0;
      `SPI_RX_321:    wb_dat21 = 32'b0;
`else
      `SPI_RX_021:    wb_dat21 = {{32-`SPI_MAX_CHAR21{1'b0}}, rx21[`SPI_MAX_CHAR21-1:0]};
      `SPI_RX_121:    wb_dat21 = 32'b0;
      `SPI_RX_221:    wb_dat21 = 32'b0;
      `SPI_RX_321:    wb_dat21 = 32'b0;
`endif
`endif
      `SPI_CTRL21:    wb_dat21 = {{32-`SPI_CTRL_BIT_NB21{1'b0}}, ctrl21};
      `SPI_DEVIDE21:  wb_dat21 = {{32-`SPI_DIVIDER_LEN21{1'b0}}, divider21};
      `SPI_SS21:      wb_dat21 = {{32-`SPI_SS_NB21{1'b0}}, ss};
      default:      wb_dat21 = 32'bx;
    endcase
  end
  
  // Wb21 data out
  always @(posedge wb_clk_i21 or posedge wb_rst_i21)
  begin
    if (wb_rst_i21)
      wb_dat_o21 <= #Tp21 32'b0;
    else
      wb_dat_o21 <= #Tp21 wb_dat21;
  end
  
  // Wb21 acknowledge21
  always @(posedge wb_clk_i21 or posedge wb_rst_i21)
  begin
    if (wb_rst_i21)
      wb_ack_o21 <= #Tp21 1'b0;
    else
      wb_ack_o21 <= #Tp21 wb_cyc_i21 & wb_stb_i21 & ~wb_ack_o21;
  end
  
  // Wb21 error
  assign wb_err_o21 = 1'b0;
  
  // Interrupt21
  always @(posedge wb_clk_i21 or posedge wb_rst_i21)
  begin
    if (wb_rst_i21)
      wb_int_o21 <= #Tp21 1'b0;
    else if (ie21 && tip21 && last_bit21 && pos_edge21)
      wb_int_o21 <= #Tp21 1'b1;
    else if (wb_ack_o21)
      wb_int_o21 <= #Tp21 1'b0;
  end
  
  // Divider21 register
  always @(posedge wb_clk_i21 or posedge wb_rst_i21)
  begin
    if (wb_rst_i21)
        divider21 <= #Tp21 {`SPI_DIVIDER_LEN21{1'b0}};
    else if (spi_divider_sel21 && wb_we_i21 && !tip21)
      begin
      `ifdef SPI_DIVIDER_LEN_821
        if (wb_sel_i21[0])
          divider21 <= #Tp21 wb_dat_i21[`SPI_DIVIDER_LEN21-1:0];
      `endif
      `ifdef SPI_DIVIDER_LEN_1621
        if (wb_sel_i21[0])
          divider21[7:0] <= #Tp21 wb_dat_i21[7:0];
        if (wb_sel_i21[1])
          divider21[`SPI_DIVIDER_LEN21-1:8] <= #Tp21 wb_dat_i21[`SPI_DIVIDER_LEN21-1:8];
      `endif
      `ifdef SPI_DIVIDER_LEN_2421
        if (wb_sel_i21[0])
          divider21[7:0] <= #Tp21 wb_dat_i21[7:0];
        if (wb_sel_i21[1])
          divider21[15:8] <= #Tp21 wb_dat_i21[15:8];
        if (wb_sel_i21[2])
          divider21[`SPI_DIVIDER_LEN21-1:16] <= #Tp21 wb_dat_i21[`SPI_DIVIDER_LEN21-1:16];
      `endif
      `ifdef SPI_DIVIDER_LEN_3221
        if (wb_sel_i21[0])
          divider21[7:0] <= #Tp21 wb_dat_i21[7:0];
        if (wb_sel_i21[1])
          divider21[15:8] <= #Tp21 wb_dat_i21[15:8];
        if (wb_sel_i21[2])
          divider21[23:16] <= #Tp21 wb_dat_i21[23:16];
        if (wb_sel_i21[3])
          divider21[`SPI_DIVIDER_LEN21-1:24] <= #Tp21 wb_dat_i21[`SPI_DIVIDER_LEN21-1:24];
      `endif
      end
  end
  
  // Ctrl21 register
  always @(posedge wb_clk_i21 or posedge wb_rst_i21)
  begin
    if (wb_rst_i21)
      ctrl21 <= #Tp21 {`SPI_CTRL_BIT_NB21{1'b0}};
    else if(spi_ctrl_sel21 && wb_we_i21 && !tip21)
      begin
        if (wb_sel_i21[0])
          ctrl21[7:0] <= #Tp21 wb_dat_i21[7:0] | {7'b0, ctrl21[0]};
        if (wb_sel_i21[1])
          ctrl21[`SPI_CTRL_BIT_NB21-1:8] <= #Tp21 wb_dat_i21[`SPI_CTRL_BIT_NB21-1:8];
      end
    else if(tip21 && last_bit21 && pos_edge21)
      ctrl21[`SPI_CTRL_GO21] <= #Tp21 1'b0;
  end
  
  assign rx_negedge21 = ctrl21[`SPI_CTRL_RX_NEGEDGE21];
  assign tx_negedge21 = ctrl21[`SPI_CTRL_TX_NEGEDGE21];
  assign go21         = ctrl21[`SPI_CTRL_GO21];
  assign char_len21   = ctrl21[`SPI_CTRL_CHAR_LEN21];
  assign lsb        = ctrl21[`SPI_CTRL_LSB21];
  assign ie21         = ctrl21[`SPI_CTRL_IE21];
  assign ass21        = ctrl21[`SPI_CTRL_ASS21];
  
  // Slave21 select21 register
  always @(posedge wb_clk_i21 or posedge wb_rst_i21)
  begin
    if (wb_rst_i21)
      ss <= #Tp21 {`SPI_SS_NB21{1'b0}};
    else if(spi_ss_sel21 && wb_we_i21 && !tip21)
      begin
      `ifdef SPI_SS_NB_821
        if (wb_sel_i21[0])
          ss <= #Tp21 wb_dat_i21[`SPI_SS_NB21-1:0];
      `endif
      `ifdef SPI_SS_NB_1621
        if (wb_sel_i21[0])
          ss[7:0] <= #Tp21 wb_dat_i21[7:0];
        if (wb_sel_i21[1])
          ss[`SPI_SS_NB21-1:8] <= #Tp21 wb_dat_i21[`SPI_SS_NB21-1:8];
      `endif
      `ifdef SPI_SS_NB_2421
        if (wb_sel_i21[0])
          ss[7:0] <= #Tp21 wb_dat_i21[7:0];
        if (wb_sel_i21[1])
          ss[15:8] <= #Tp21 wb_dat_i21[15:8];
        if (wb_sel_i21[2])
          ss[`SPI_SS_NB21-1:16] <= #Tp21 wb_dat_i21[`SPI_SS_NB21-1:16];
      `endif
      `ifdef SPI_SS_NB_3221
        if (wb_sel_i21[0])
          ss[7:0] <= #Tp21 wb_dat_i21[7:0];
        if (wb_sel_i21[1])
          ss[15:8] <= #Tp21 wb_dat_i21[15:8];
        if (wb_sel_i21[2])
          ss[23:16] <= #Tp21 wb_dat_i21[23:16];
        if (wb_sel_i21[3])
          ss[`SPI_SS_NB21-1:24] <= #Tp21 wb_dat_i21[`SPI_SS_NB21-1:24];
      `endif
      end
  end
  
  assign ss_pad_o21 = ~((ss & {`SPI_SS_NB21{tip21 & ass21}}) | (ss & {`SPI_SS_NB21{!ass21}}));
  
  spi_clgen21 clgen21 (.clk_in21(wb_clk_i21), .rst21(wb_rst_i21), .go21(go21), .enable(tip21), .last_clk21(last_bit21),
                   .divider21(divider21), .clk_out21(sclk_pad_o21), .pos_edge21(pos_edge21), 
                   .neg_edge21(neg_edge21));
  
  spi_shift21 shift21 (.clk21(wb_clk_i21), .rst21(wb_rst_i21), .len(char_len21[`SPI_CHAR_LEN_BITS21-1:0]),
                   .latch21(spi_tx_sel21[3:0] & {4{wb_we_i21}}), .byte_sel21(wb_sel_i21), .lsb(lsb), 
                   .go21(go21), .pos_edge21(pos_edge21), .neg_edge21(neg_edge21), 
                   .rx_negedge21(rx_negedge21), .tx_negedge21(tx_negedge21),
                   .tip21(tip21), .last(last_bit21), 
                   .p_in21(wb_dat_i21), .p_out21(rx21), 
                   .s_clk21(sclk_pad_o21), .s_in21(miso_pad_i21), .s_out21(mosi_pad_o21));
endmodule
  
