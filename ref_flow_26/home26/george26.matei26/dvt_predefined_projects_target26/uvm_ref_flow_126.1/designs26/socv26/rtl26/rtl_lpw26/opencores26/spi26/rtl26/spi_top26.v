//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_top26.v                                                   ////
////                                                              ////
////  This26 file is part of the SPI26 IP26 core26 project26                ////
////  http26://www26.opencores26.org26/projects26/spi26/                      ////
////                                                              ////
////  Author26(s):                                                  ////
////      - Simon26 Srot26 (simons26@opencores26.org26)                     ////
////                                                              ////
////  All additional26 information is avaliable26 in the Readme26.txt26   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright26 (C) 2002 Authors26                                   ////
////                                                              ////
//// This26 source26 file may be used and distributed26 without         ////
//// restriction26 provided that this copyright26 statement26 is not    ////
//// removed from the file and that any derivative26 work26 contains26  ////
//// the original copyright26 notice26 and the associated disclaimer26. ////
////                                                              ////
//// This26 source26 file is free software26; you can redistribute26 it   ////
//// and/or modify it under the terms26 of the GNU26 Lesser26 General26   ////
//// Public26 License26 as published26 by the Free26 Software26 Foundation26; ////
//// either26 version26 2.1 of the License26, or (at your26 option) any   ////
//// later26 version26.                                               ////
////                                                              ////
//// This26 source26 is distributed26 in the hope26 that it will be       ////
//// useful26, but WITHOUT26 ANY26 WARRANTY26; without even26 the implied26   ////
//// warranty26 of MERCHANTABILITY26 or FITNESS26 FOR26 A PARTICULAR26      ////
//// PURPOSE26.  See the GNU26 Lesser26 General26 Public26 License26 for more ////
//// details26.                                                     ////
////                                                              ////
//// You should have received26 a copy of the GNU26 Lesser26 General26    ////
//// Public26 License26 along26 with this source26; if not, download26 it   ////
//// from http26://www26.opencores26.org26/lgpl26.shtml26                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////


`include "spi_defines26.v"
`include "timescale.v"

module spi_top26
(
  // Wishbone26 signals26
  wb_clk_i26, wb_rst_i26, wb_adr_i26, wb_dat_i26, wb_dat_o26, wb_sel_i26,
  wb_we_i26, wb_stb_i26, wb_cyc_i26, wb_ack_o26, wb_err_o26, wb_int_o26,

  // SPI26 signals26
  ss_pad_o26, sclk_pad_o26, mosi_pad_o26, miso_pad_i26
);

  parameter Tp26 = 1;

  // Wishbone26 signals26
  input                            wb_clk_i26;         // master26 clock26 input
  input                            wb_rst_i26;         // synchronous26 active high26 reset
  input                      [4:0] wb_adr_i26;         // lower26 address bits
  input                   [32-1:0] wb_dat_i26;         // databus26 input
  output                  [32-1:0] wb_dat_o26;         // databus26 output
  input                      [3:0] wb_sel_i26;         // byte select26 inputs26
  input                            wb_we_i26;          // write enable input
  input                            wb_stb_i26;         // stobe26/core26 select26 signal26
  input                            wb_cyc_i26;         // valid bus cycle input
  output                           wb_ack_o26;         // bus cycle acknowledge26 output
  output                           wb_err_o26;         // termination w/ error
  output                           wb_int_o26;         // interrupt26 request signal26 output
                                                     
  // SPI26 signals26                                     
  output          [`SPI_SS_NB26-1:0] ss_pad_o26;         // slave26 select26
  output                           sclk_pad_o26;       // serial26 clock26
  output                           mosi_pad_o26;       // master26 out slave26 in
  input                            miso_pad_i26;       // master26 in slave26 out
                                                     
  reg                     [32-1:0] wb_dat_o26;
  reg                              wb_ack_o26;
  reg                              wb_int_o26;
                                               
  // Internal signals26
  reg       [`SPI_DIVIDER_LEN26-1:0] divider26;          // Divider26 register
  reg       [`SPI_CTRL_BIT_NB26-1:0] ctrl26;             // Control26 and status register
  reg             [`SPI_SS_NB26-1:0] ss;               // Slave26 select26 register
  reg                     [32-1:0] wb_dat26;           // wb26 data out
  wire         [`SPI_MAX_CHAR26-1:0] rx26;               // Rx26 register
  wire                             rx_negedge26;       // miso26 is sampled26 on negative edge
  wire                             tx_negedge26;       // mosi26 is driven26 on negative edge
  wire    [`SPI_CHAR_LEN_BITS26-1:0] char_len26;         // char26 len
  wire                             go26;               // go26
  wire                             lsb;              // lsb first on line
  wire                             ie26;               // interrupt26 enable
  wire                             ass26;              // automatic slave26 select26
  wire                             spi_divider_sel26;  // divider26 register select26
  wire                             spi_ctrl_sel26;     // ctrl26 register select26
  wire                       [3:0] spi_tx_sel26;       // tx_l26 register select26
  wire                             spi_ss_sel26;       // ss register select26
  wire                             tip26;              // transfer26 in progress26
  wire                             pos_edge26;         // recognize26 posedge of sclk26
  wire                             neg_edge26;         // recognize26 negedge of sclk26
  wire                             last_bit26;         // marks26 last character26 bit
  
  // Address decoder26
  assign spi_divider_sel26 = wb_cyc_i26 & wb_stb_i26 & (wb_adr_i26[`SPI_OFS_BITS26] == `SPI_DEVIDE26);
  assign spi_ctrl_sel26    = wb_cyc_i26 & wb_stb_i26 & (wb_adr_i26[`SPI_OFS_BITS26] == `SPI_CTRL26);
  assign spi_tx_sel26[0]   = wb_cyc_i26 & wb_stb_i26 & (wb_adr_i26[`SPI_OFS_BITS26] == `SPI_TX_026);
  assign spi_tx_sel26[1]   = wb_cyc_i26 & wb_stb_i26 & (wb_adr_i26[`SPI_OFS_BITS26] == `SPI_TX_126);
  assign spi_tx_sel26[2]   = wb_cyc_i26 & wb_stb_i26 & (wb_adr_i26[`SPI_OFS_BITS26] == `SPI_TX_226);
  assign spi_tx_sel26[3]   = wb_cyc_i26 & wb_stb_i26 & (wb_adr_i26[`SPI_OFS_BITS26] == `SPI_TX_326);
  assign spi_ss_sel26      = wb_cyc_i26 & wb_stb_i26 & (wb_adr_i26[`SPI_OFS_BITS26] == `SPI_SS26);
  
  // Read from registers
  always @(wb_adr_i26 or rx26 or ctrl26 or divider26 or ss)
  begin
    case (wb_adr_i26[`SPI_OFS_BITS26])
`ifdef SPI_MAX_CHAR_12826
      `SPI_RX_026:    wb_dat26 = rx26[31:0];
      `SPI_RX_126:    wb_dat26 = rx26[63:32];
      `SPI_RX_226:    wb_dat26 = rx26[95:64];
      `SPI_RX_326:    wb_dat26 = {{128-`SPI_MAX_CHAR26{1'b0}}, rx26[`SPI_MAX_CHAR26-1:96]};
`else
`ifdef SPI_MAX_CHAR_6426
      `SPI_RX_026:    wb_dat26 = rx26[31:0];
      `SPI_RX_126:    wb_dat26 = {{64-`SPI_MAX_CHAR26{1'b0}}, rx26[`SPI_MAX_CHAR26-1:32]};
      `SPI_RX_226:    wb_dat26 = 32'b0;
      `SPI_RX_326:    wb_dat26 = 32'b0;
`else
      `SPI_RX_026:    wb_dat26 = {{32-`SPI_MAX_CHAR26{1'b0}}, rx26[`SPI_MAX_CHAR26-1:0]};
      `SPI_RX_126:    wb_dat26 = 32'b0;
      `SPI_RX_226:    wb_dat26 = 32'b0;
      `SPI_RX_326:    wb_dat26 = 32'b0;
`endif
`endif
      `SPI_CTRL26:    wb_dat26 = {{32-`SPI_CTRL_BIT_NB26{1'b0}}, ctrl26};
      `SPI_DEVIDE26:  wb_dat26 = {{32-`SPI_DIVIDER_LEN26{1'b0}}, divider26};
      `SPI_SS26:      wb_dat26 = {{32-`SPI_SS_NB26{1'b0}}, ss};
      default:      wb_dat26 = 32'bx;
    endcase
  end
  
  // Wb26 data out
  always @(posedge wb_clk_i26 or posedge wb_rst_i26)
  begin
    if (wb_rst_i26)
      wb_dat_o26 <= #Tp26 32'b0;
    else
      wb_dat_o26 <= #Tp26 wb_dat26;
  end
  
  // Wb26 acknowledge26
  always @(posedge wb_clk_i26 or posedge wb_rst_i26)
  begin
    if (wb_rst_i26)
      wb_ack_o26 <= #Tp26 1'b0;
    else
      wb_ack_o26 <= #Tp26 wb_cyc_i26 & wb_stb_i26 & ~wb_ack_o26;
  end
  
  // Wb26 error
  assign wb_err_o26 = 1'b0;
  
  // Interrupt26
  always @(posedge wb_clk_i26 or posedge wb_rst_i26)
  begin
    if (wb_rst_i26)
      wb_int_o26 <= #Tp26 1'b0;
    else if (ie26 && tip26 && last_bit26 && pos_edge26)
      wb_int_o26 <= #Tp26 1'b1;
    else if (wb_ack_o26)
      wb_int_o26 <= #Tp26 1'b0;
  end
  
  // Divider26 register
  always @(posedge wb_clk_i26 or posedge wb_rst_i26)
  begin
    if (wb_rst_i26)
        divider26 <= #Tp26 {`SPI_DIVIDER_LEN26{1'b0}};
    else if (spi_divider_sel26 && wb_we_i26 && !tip26)
      begin
      `ifdef SPI_DIVIDER_LEN_826
        if (wb_sel_i26[0])
          divider26 <= #Tp26 wb_dat_i26[`SPI_DIVIDER_LEN26-1:0];
      `endif
      `ifdef SPI_DIVIDER_LEN_1626
        if (wb_sel_i26[0])
          divider26[7:0] <= #Tp26 wb_dat_i26[7:0];
        if (wb_sel_i26[1])
          divider26[`SPI_DIVIDER_LEN26-1:8] <= #Tp26 wb_dat_i26[`SPI_DIVIDER_LEN26-1:8];
      `endif
      `ifdef SPI_DIVIDER_LEN_2426
        if (wb_sel_i26[0])
          divider26[7:0] <= #Tp26 wb_dat_i26[7:0];
        if (wb_sel_i26[1])
          divider26[15:8] <= #Tp26 wb_dat_i26[15:8];
        if (wb_sel_i26[2])
          divider26[`SPI_DIVIDER_LEN26-1:16] <= #Tp26 wb_dat_i26[`SPI_DIVIDER_LEN26-1:16];
      `endif
      `ifdef SPI_DIVIDER_LEN_3226
        if (wb_sel_i26[0])
          divider26[7:0] <= #Tp26 wb_dat_i26[7:0];
        if (wb_sel_i26[1])
          divider26[15:8] <= #Tp26 wb_dat_i26[15:8];
        if (wb_sel_i26[2])
          divider26[23:16] <= #Tp26 wb_dat_i26[23:16];
        if (wb_sel_i26[3])
          divider26[`SPI_DIVIDER_LEN26-1:24] <= #Tp26 wb_dat_i26[`SPI_DIVIDER_LEN26-1:24];
      `endif
      end
  end
  
  // Ctrl26 register
  always @(posedge wb_clk_i26 or posedge wb_rst_i26)
  begin
    if (wb_rst_i26)
      ctrl26 <= #Tp26 {`SPI_CTRL_BIT_NB26{1'b0}};
    else if(spi_ctrl_sel26 && wb_we_i26 && !tip26)
      begin
        if (wb_sel_i26[0])
          ctrl26[7:0] <= #Tp26 wb_dat_i26[7:0] | {7'b0, ctrl26[0]};
        if (wb_sel_i26[1])
          ctrl26[`SPI_CTRL_BIT_NB26-1:8] <= #Tp26 wb_dat_i26[`SPI_CTRL_BIT_NB26-1:8];
      end
    else if(tip26 && last_bit26 && pos_edge26)
      ctrl26[`SPI_CTRL_GO26] <= #Tp26 1'b0;
  end
  
  assign rx_negedge26 = ctrl26[`SPI_CTRL_RX_NEGEDGE26];
  assign tx_negedge26 = ctrl26[`SPI_CTRL_TX_NEGEDGE26];
  assign go26         = ctrl26[`SPI_CTRL_GO26];
  assign char_len26   = ctrl26[`SPI_CTRL_CHAR_LEN26];
  assign lsb        = ctrl26[`SPI_CTRL_LSB26];
  assign ie26         = ctrl26[`SPI_CTRL_IE26];
  assign ass26        = ctrl26[`SPI_CTRL_ASS26];
  
  // Slave26 select26 register
  always @(posedge wb_clk_i26 or posedge wb_rst_i26)
  begin
    if (wb_rst_i26)
      ss <= #Tp26 {`SPI_SS_NB26{1'b0}};
    else if(spi_ss_sel26 && wb_we_i26 && !tip26)
      begin
      `ifdef SPI_SS_NB_826
        if (wb_sel_i26[0])
          ss <= #Tp26 wb_dat_i26[`SPI_SS_NB26-1:0];
      `endif
      `ifdef SPI_SS_NB_1626
        if (wb_sel_i26[0])
          ss[7:0] <= #Tp26 wb_dat_i26[7:0];
        if (wb_sel_i26[1])
          ss[`SPI_SS_NB26-1:8] <= #Tp26 wb_dat_i26[`SPI_SS_NB26-1:8];
      `endif
      `ifdef SPI_SS_NB_2426
        if (wb_sel_i26[0])
          ss[7:0] <= #Tp26 wb_dat_i26[7:0];
        if (wb_sel_i26[1])
          ss[15:8] <= #Tp26 wb_dat_i26[15:8];
        if (wb_sel_i26[2])
          ss[`SPI_SS_NB26-1:16] <= #Tp26 wb_dat_i26[`SPI_SS_NB26-1:16];
      `endif
      `ifdef SPI_SS_NB_3226
        if (wb_sel_i26[0])
          ss[7:0] <= #Tp26 wb_dat_i26[7:0];
        if (wb_sel_i26[1])
          ss[15:8] <= #Tp26 wb_dat_i26[15:8];
        if (wb_sel_i26[2])
          ss[23:16] <= #Tp26 wb_dat_i26[23:16];
        if (wb_sel_i26[3])
          ss[`SPI_SS_NB26-1:24] <= #Tp26 wb_dat_i26[`SPI_SS_NB26-1:24];
      `endif
      end
  end
  
  assign ss_pad_o26 = ~((ss & {`SPI_SS_NB26{tip26 & ass26}}) | (ss & {`SPI_SS_NB26{!ass26}}));
  
  spi_clgen26 clgen26 (.clk_in26(wb_clk_i26), .rst26(wb_rst_i26), .go26(go26), .enable(tip26), .last_clk26(last_bit26),
                   .divider26(divider26), .clk_out26(sclk_pad_o26), .pos_edge26(pos_edge26), 
                   .neg_edge26(neg_edge26));
  
  spi_shift26 shift26 (.clk26(wb_clk_i26), .rst26(wb_rst_i26), .len(char_len26[`SPI_CHAR_LEN_BITS26-1:0]),
                   .latch26(spi_tx_sel26[3:0] & {4{wb_we_i26}}), .byte_sel26(wb_sel_i26), .lsb(lsb), 
                   .go26(go26), .pos_edge26(pos_edge26), .neg_edge26(neg_edge26), 
                   .rx_negedge26(rx_negedge26), .tx_negedge26(tx_negedge26),
                   .tip26(tip26), .last(last_bit26), 
                   .p_in26(wb_dat_i26), .p_out26(rx26), 
                   .s_clk26(sclk_pad_o26), .s_in26(miso_pad_i26), .s_out26(mosi_pad_o26));
endmodule
  
