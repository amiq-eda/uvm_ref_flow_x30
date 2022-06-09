//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_top19.v                                                   ////
////                                                              ////
////  This19 file is part of the SPI19 IP19 core19 project19                ////
////  http19://www19.opencores19.org19/projects19/spi19/                      ////
////                                                              ////
////  Author19(s):                                                  ////
////      - Simon19 Srot19 (simons19@opencores19.org19)                     ////
////                                                              ////
////  All additional19 information is avaliable19 in the Readme19.txt19   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright19 (C) 2002 Authors19                                   ////
////                                                              ////
//// This19 source19 file may be used and distributed19 without         ////
//// restriction19 provided that this copyright19 statement19 is not    ////
//// removed from the file and that any derivative19 work19 contains19  ////
//// the original copyright19 notice19 and the associated disclaimer19. ////
////                                                              ////
//// This19 source19 file is free software19; you can redistribute19 it   ////
//// and/or modify it under the terms19 of the GNU19 Lesser19 General19   ////
//// Public19 License19 as published19 by the Free19 Software19 Foundation19; ////
//// either19 version19 2.1 of the License19, or (at your19 option) any   ////
//// later19 version19.                                               ////
////                                                              ////
//// This19 source19 is distributed19 in the hope19 that it will be       ////
//// useful19, but WITHOUT19 ANY19 WARRANTY19; without even19 the implied19   ////
//// warranty19 of MERCHANTABILITY19 or FITNESS19 FOR19 A PARTICULAR19      ////
//// PURPOSE19.  See the GNU19 Lesser19 General19 Public19 License19 for more ////
//// details19.                                                     ////
////                                                              ////
//// You should have received19 a copy of the GNU19 Lesser19 General19    ////
//// Public19 License19 along19 with this source19; if not, download19 it   ////
//// from http19://www19.opencores19.org19/lgpl19.shtml19                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////


`include "spi_defines19.v"
`include "timescale.v"

module spi_top19
(
  // Wishbone19 signals19
  wb_clk_i19, wb_rst_i19, wb_adr_i19, wb_dat_i19, wb_dat_o19, wb_sel_i19,
  wb_we_i19, wb_stb_i19, wb_cyc_i19, wb_ack_o19, wb_err_o19, wb_int_o19,

  // SPI19 signals19
  ss_pad_o19, sclk_pad_o19, mosi_pad_o19, miso_pad_i19
);

  parameter Tp19 = 1;

  // Wishbone19 signals19
  input                            wb_clk_i19;         // master19 clock19 input
  input                            wb_rst_i19;         // synchronous19 active high19 reset
  input                      [4:0] wb_adr_i19;         // lower19 address bits
  input                   [32-1:0] wb_dat_i19;         // databus19 input
  output                  [32-1:0] wb_dat_o19;         // databus19 output
  input                      [3:0] wb_sel_i19;         // byte select19 inputs19
  input                            wb_we_i19;          // write enable input
  input                            wb_stb_i19;         // stobe19/core19 select19 signal19
  input                            wb_cyc_i19;         // valid bus cycle input
  output                           wb_ack_o19;         // bus cycle acknowledge19 output
  output                           wb_err_o19;         // termination w/ error
  output                           wb_int_o19;         // interrupt19 request signal19 output
                                                     
  // SPI19 signals19                                     
  output          [`SPI_SS_NB19-1:0] ss_pad_o19;         // slave19 select19
  output                           sclk_pad_o19;       // serial19 clock19
  output                           mosi_pad_o19;       // master19 out slave19 in
  input                            miso_pad_i19;       // master19 in slave19 out
                                                     
  reg                     [32-1:0] wb_dat_o19;
  reg                              wb_ack_o19;
  reg                              wb_int_o19;
                                               
  // Internal signals19
  reg       [`SPI_DIVIDER_LEN19-1:0] divider19;          // Divider19 register
  reg       [`SPI_CTRL_BIT_NB19-1:0] ctrl19;             // Control19 and status register
  reg             [`SPI_SS_NB19-1:0] ss;               // Slave19 select19 register
  reg                     [32-1:0] wb_dat19;           // wb19 data out
  wire         [`SPI_MAX_CHAR19-1:0] rx19;               // Rx19 register
  wire                             rx_negedge19;       // miso19 is sampled19 on negative edge
  wire                             tx_negedge19;       // mosi19 is driven19 on negative edge
  wire    [`SPI_CHAR_LEN_BITS19-1:0] char_len19;         // char19 len
  wire                             go19;               // go19
  wire                             lsb;              // lsb first on line
  wire                             ie19;               // interrupt19 enable
  wire                             ass19;              // automatic slave19 select19
  wire                             spi_divider_sel19;  // divider19 register select19
  wire                             spi_ctrl_sel19;     // ctrl19 register select19
  wire                       [3:0] spi_tx_sel19;       // tx_l19 register select19
  wire                             spi_ss_sel19;       // ss register select19
  wire                             tip19;              // transfer19 in progress19
  wire                             pos_edge19;         // recognize19 posedge of sclk19
  wire                             neg_edge19;         // recognize19 negedge of sclk19
  wire                             last_bit19;         // marks19 last character19 bit
  
  // Address decoder19
  assign spi_divider_sel19 = wb_cyc_i19 & wb_stb_i19 & (wb_adr_i19[`SPI_OFS_BITS19] == `SPI_DEVIDE19);
  assign spi_ctrl_sel19    = wb_cyc_i19 & wb_stb_i19 & (wb_adr_i19[`SPI_OFS_BITS19] == `SPI_CTRL19);
  assign spi_tx_sel19[0]   = wb_cyc_i19 & wb_stb_i19 & (wb_adr_i19[`SPI_OFS_BITS19] == `SPI_TX_019);
  assign spi_tx_sel19[1]   = wb_cyc_i19 & wb_stb_i19 & (wb_adr_i19[`SPI_OFS_BITS19] == `SPI_TX_119);
  assign spi_tx_sel19[2]   = wb_cyc_i19 & wb_stb_i19 & (wb_adr_i19[`SPI_OFS_BITS19] == `SPI_TX_219);
  assign spi_tx_sel19[3]   = wb_cyc_i19 & wb_stb_i19 & (wb_adr_i19[`SPI_OFS_BITS19] == `SPI_TX_319);
  assign spi_ss_sel19      = wb_cyc_i19 & wb_stb_i19 & (wb_adr_i19[`SPI_OFS_BITS19] == `SPI_SS19);
  
  // Read from registers
  always @(wb_adr_i19 or rx19 or ctrl19 or divider19 or ss)
  begin
    case (wb_adr_i19[`SPI_OFS_BITS19])
`ifdef SPI_MAX_CHAR_12819
      `SPI_RX_019:    wb_dat19 = rx19[31:0];
      `SPI_RX_119:    wb_dat19 = rx19[63:32];
      `SPI_RX_219:    wb_dat19 = rx19[95:64];
      `SPI_RX_319:    wb_dat19 = {{128-`SPI_MAX_CHAR19{1'b0}}, rx19[`SPI_MAX_CHAR19-1:96]};
`else
`ifdef SPI_MAX_CHAR_6419
      `SPI_RX_019:    wb_dat19 = rx19[31:0];
      `SPI_RX_119:    wb_dat19 = {{64-`SPI_MAX_CHAR19{1'b0}}, rx19[`SPI_MAX_CHAR19-1:32]};
      `SPI_RX_219:    wb_dat19 = 32'b0;
      `SPI_RX_319:    wb_dat19 = 32'b0;
`else
      `SPI_RX_019:    wb_dat19 = {{32-`SPI_MAX_CHAR19{1'b0}}, rx19[`SPI_MAX_CHAR19-1:0]};
      `SPI_RX_119:    wb_dat19 = 32'b0;
      `SPI_RX_219:    wb_dat19 = 32'b0;
      `SPI_RX_319:    wb_dat19 = 32'b0;
`endif
`endif
      `SPI_CTRL19:    wb_dat19 = {{32-`SPI_CTRL_BIT_NB19{1'b0}}, ctrl19};
      `SPI_DEVIDE19:  wb_dat19 = {{32-`SPI_DIVIDER_LEN19{1'b0}}, divider19};
      `SPI_SS19:      wb_dat19 = {{32-`SPI_SS_NB19{1'b0}}, ss};
      default:      wb_dat19 = 32'bx;
    endcase
  end
  
  // Wb19 data out
  always @(posedge wb_clk_i19 or posedge wb_rst_i19)
  begin
    if (wb_rst_i19)
      wb_dat_o19 <= #Tp19 32'b0;
    else
      wb_dat_o19 <= #Tp19 wb_dat19;
  end
  
  // Wb19 acknowledge19
  always @(posedge wb_clk_i19 or posedge wb_rst_i19)
  begin
    if (wb_rst_i19)
      wb_ack_o19 <= #Tp19 1'b0;
    else
      wb_ack_o19 <= #Tp19 wb_cyc_i19 & wb_stb_i19 & ~wb_ack_o19;
  end
  
  // Wb19 error
  assign wb_err_o19 = 1'b0;
  
  // Interrupt19
  always @(posedge wb_clk_i19 or posedge wb_rst_i19)
  begin
    if (wb_rst_i19)
      wb_int_o19 <= #Tp19 1'b0;
    else if (ie19 && tip19 && last_bit19 && pos_edge19)
      wb_int_o19 <= #Tp19 1'b1;
    else if (wb_ack_o19)
      wb_int_o19 <= #Tp19 1'b0;
  end
  
  // Divider19 register
  always @(posedge wb_clk_i19 or posedge wb_rst_i19)
  begin
    if (wb_rst_i19)
        divider19 <= #Tp19 {`SPI_DIVIDER_LEN19{1'b0}};
    else if (spi_divider_sel19 && wb_we_i19 && !tip19)
      begin
      `ifdef SPI_DIVIDER_LEN_819
        if (wb_sel_i19[0])
          divider19 <= #Tp19 wb_dat_i19[`SPI_DIVIDER_LEN19-1:0];
      `endif
      `ifdef SPI_DIVIDER_LEN_1619
        if (wb_sel_i19[0])
          divider19[7:0] <= #Tp19 wb_dat_i19[7:0];
        if (wb_sel_i19[1])
          divider19[`SPI_DIVIDER_LEN19-1:8] <= #Tp19 wb_dat_i19[`SPI_DIVIDER_LEN19-1:8];
      `endif
      `ifdef SPI_DIVIDER_LEN_2419
        if (wb_sel_i19[0])
          divider19[7:0] <= #Tp19 wb_dat_i19[7:0];
        if (wb_sel_i19[1])
          divider19[15:8] <= #Tp19 wb_dat_i19[15:8];
        if (wb_sel_i19[2])
          divider19[`SPI_DIVIDER_LEN19-1:16] <= #Tp19 wb_dat_i19[`SPI_DIVIDER_LEN19-1:16];
      `endif
      `ifdef SPI_DIVIDER_LEN_3219
        if (wb_sel_i19[0])
          divider19[7:0] <= #Tp19 wb_dat_i19[7:0];
        if (wb_sel_i19[1])
          divider19[15:8] <= #Tp19 wb_dat_i19[15:8];
        if (wb_sel_i19[2])
          divider19[23:16] <= #Tp19 wb_dat_i19[23:16];
        if (wb_sel_i19[3])
          divider19[`SPI_DIVIDER_LEN19-1:24] <= #Tp19 wb_dat_i19[`SPI_DIVIDER_LEN19-1:24];
      `endif
      end
  end
  
  // Ctrl19 register
  always @(posedge wb_clk_i19 or posedge wb_rst_i19)
  begin
    if (wb_rst_i19)
      ctrl19 <= #Tp19 {`SPI_CTRL_BIT_NB19{1'b0}};
    else if(spi_ctrl_sel19 && wb_we_i19 && !tip19)
      begin
        if (wb_sel_i19[0])
          ctrl19[7:0] <= #Tp19 wb_dat_i19[7:0] | {7'b0, ctrl19[0]};
        if (wb_sel_i19[1])
          ctrl19[`SPI_CTRL_BIT_NB19-1:8] <= #Tp19 wb_dat_i19[`SPI_CTRL_BIT_NB19-1:8];
      end
    else if(tip19 && last_bit19 && pos_edge19)
      ctrl19[`SPI_CTRL_GO19] <= #Tp19 1'b0;
  end
  
  assign rx_negedge19 = ctrl19[`SPI_CTRL_RX_NEGEDGE19];
  assign tx_negedge19 = ctrl19[`SPI_CTRL_TX_NEGEDGE19];
  assign go19         = ctrl19[`SPI_CTRL_GO19];
  assign char_len19   = ctrl19[`SPI_CTRL_CHAR_LEN19];
  assign lsb        = ctrl19[`SPI_CTRL_LSB19];
  assign ie19         = ctrl19[`SPI_CTRL_IE19];
  assign ass19        = ctrl19[`SPI_CTRL_ASS19];
  
  // Slave19 select19 register
  always @(posedge wb_clk_i19 or posedge wb_rst_i19)
  begin
    if (wb_rst_i19)
      ss <= #Tp19 {`SPI_SS_NB19{1'b0}};
    else if(spi_ss_sel19 && wb_we_i19 && !tip19)
      begin
      `ifdef SPI_SS_NB_819
        if (wb_sel_i19[0])
          ss <= #Tp19 wb_dat_i19[`SPI_SS_NB19-1:0];
      `endif
      `ifdef SPI_SS_NB_1619
        if (wb_sel_i19[0])
          ss[7:0] <= #Tp19 wb_dat_i19[7:0];
        if (wb_sel_i19[1])
          ss[`SPI_SS_NB19-1:8] <= #Tp19 wb_dat_i19[`SPI_SS_NB19-1:8];
      `endif
      `ifdef SPI_SS_NB_2419
        if (wb_sel_i19[0])
          ss[7:0] <= #Tp19 wb_dat_i19[7:0];
        if (wb_sel_i19[1])
          ss[15:8] <= #Tp19 wb_dat_i19[15:8];
        if (wb_sel_i19[2])
          ss[`SPI_SS_NB19-1:16] <= #Tp19 wb_dat_i19[`SPI_SS_NB19-1:16];
      `endif
      `ifdef SPI_SS_NB_3219
        if (wb_sel_i19[0])
          ss[7:0] <= #Tp19 wb_dat_i19[7:0];
        if (wb_sel_i19[1])
          ss[15:8] <= #Tp19 wb_dat_i19[15:8];
        if (wb_sel_i19[2])
          ss[23:16] <= #Tp19 wb_dat_i19[23:16];
        if (wb_sel_i19[3])
          ss[`SPI_SS_NB19-1:24] <= #Tp19 wb_dat_i19[`SPI_SS_NB19-1:24];
      `endif
      end
  end
  
  assign ss_pad_o19 = ~((ss & {`SPI_SS_NB19{tip19 & ass19}}) | (ss & {`SPI_SS_NB19{!ass19}}));
  
  spi_clgen19 clgen19 (.clk_in19(wb_clk_i19), .rst19(wb_rst_i19), .go19(go19), .enable(tip19), .last_clk19(last_bit19),
                   .divider19(divider19), .clk_out19(sclk_pad_o19), .pos_edge19(pos_edge19), 
                   .neg_edge19(neg_edge19));
  
  spi_shift19 shift19 (.clk19(wb_clk_i19), .rst19(wb_rst_i19), .len(char_len19[`SPI_CHAR_LEN_BITS19-1:0]),
                   .latch19(spi_tx_sel19[3:0] & {4{wb_we_i19}}), .byte_sel19(wb_sel_i19), .lsb(lsb), 
                   .go19(go19), .pos_edge19(pos_edge19), .neg_edge19(neg_edge19), 
                   .rx_negedge19(rx_negedge19), .tx_negedge19(tx_negedge19),
                   .tip19(tip19), .last(last_bit19), 
                   .p_in19(wb_dat_i19), .p_out19(rx19), 
                   .s_clk19(sclk_pad_o19), .s_in19(miso_pad_i19), .s_out19(mosi_pad_o19));
endmodule
  
