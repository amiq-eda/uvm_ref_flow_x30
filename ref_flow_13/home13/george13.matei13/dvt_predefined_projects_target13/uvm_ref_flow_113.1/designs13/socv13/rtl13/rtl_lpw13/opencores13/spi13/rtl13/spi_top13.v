//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_top13.v                                                   ////
////                                                              ////
////  This13 file is part of the SPI13 IP13 core13 project13                ////
////  http13://www13.opencores13.org13/projects13/spi13/                      ////
////                                                              ////
////  Author13(s):                                                  ////
////      - Simon13 Srot13 (simons13@opencores13.org13)                     ////
////                                                              ////
////  All additional13 information is avaliable13 in the Readme13.txt13   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright13 (C) 2002 Authors13                                   ////
////                                                              ////
//// This13 source13 file may be used and distributed13 without         ////
//// restriction13 provided that this copyright13 statement13 is not    ////
//// removed from the file and that any derivative13 work13 contains13  ////
//// the original copyright13 notice13 and the associated disclaimer13. ////
////                                                              ////
//// This13 source13 file is free software13; you can redistribute13 it   ////
//// and/or modify it under the terms13 of the GNU13 Lesser13 General13   ////
//// Public13 License13 as published13 by the Free13 Software13 Foundation13; ////
//// either13 version13 2.1 of the License13, or (at your13 option) any   ////
//// later13 version13.                                               ////
////                                                              ////
//// This13 source13 is distributed13 in the hope13 that it will be       ////
//// useful13, but WITHOUT13 ANY13 WARRANTY13; without even13 the implied13   ////
//// warranty13 of MERCHANTABILITY13 or FITNESS13 FOR13 A PARTICULAR13      ////
//// PURPOSE13.  See the GNU13 Lesser13 General13 Public13 License13 for more ////
//// details13.                                                     ////
////                                                              ////
//// You should have received13 a copy of the GNU13 Lesser13 General13    ////
//// Public13 License13 along13 with this source13; if not, download13 it   ////
//// from http13://www13.opencores13.org13/lgpl13.shtml13                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////


`include "spi_defines13.v"
`include "timescale.v"

module spi_top13
(
  // Wishbone13 signals13
  wb_clk_i13, wb_rst_i13, wb_adr_i13, wb_dat_i13, wb_dat_o13, wb_sel_i13,
  wb_we_i13, wb_stb_i13, wb_cyc_i13, wb_ack_o13, wb_err_o13, wb_int_o13,

  // SPI13 signals13
  ss_pad_o13, sclk_pad_o13, mosi_pad_o13, miso_pad_i13
);

  parameter Tp13 = 1;

  // Wishbone13 signals13
  input                            wb_clk_i13;         // master13 clock13 input
  input                            wb_rst_i13;         // synchronous13 active high13 reset
  input                      [4:0] wb_adr_i13;         // lower13 address bits
  input                   [32-1:0] wb_dat_i13;         // databus13 input
  output                  [32-1:0] wb_dat_o13;         // databus13 output
  input                      [3:0] wb_sel_i13;         // byte select13 inputs13
  input                            wb_we_i13;          // write enable input
  input                            wb_stb_i13;         // stobe13/core13 select13 signal13
  input                            wb_cyc_i13;         // valid bus cycle input
  output                           wb_ack_o13;         // bus cycle acknowledge13 output
  output                           wb_err_o13;         // termination w/ error
  output                           wb_int_o13;         // interrupt13 request signal13 output
                                                     
  // SPI13 signals13                                     
  output          [`SPI_SS_NB13-1:0] ss_pad_o13;         // slave13 select13
  output                           sclk_pad_o13;       // serial13 clock13
  output                           mosi_pad_o13;       // master13 out slave13 in
  input                            miso_pad_i13;       // master13 in slave13 out
                                                     
  reg                     [32-1:0] wb_dat_o13;
  reg                              wb_ack_o13;
  reg                              wb_int_o13;
                                               
  // Internal signals13
  reg       [`SPI_DIVIDER_LEN13-1:0] divider13;          // Divider13 register
  reg       [`SPI_CTRL_BIT_NB13-1:0] ctrl13;             // Control13 and status register
  reg             [`SPI_SS_NB13-1:0] ss;               // Slave13 select13 register
  reg                     [32-1:0] wb_dat13;           // wb13 data out
  wire         [`SPI_MAX_CHAR13-1:0] rx13;               // Rx13 register
  wire                             rx_negedge13;       // miso13 is sampled13 on negative edge
  wire                             tx_negedge13;       // mosi13 is driven13 on negative edge
  wire    [`SPI_CHAR_LEN_BITS13-1:0] char_len13;         // char13 len
  wire                             go13;               // go13
  wire                             lsb;              // lsb first on line
  wire                             ie13;               // interrupt13 enable
  wire                             ass13;              // automatic slave13 select13
  wire                             spi_divider_sel13;  // divider13 register select13
  wire                             spi_ctrl_sel13;     // ctrl13 register select13
  wire                       [3:0] spi_tx_sel13;       // tx_l13 register select13
  wire                             spi_ss_sel13;       // ss register select13
  wire                             tip13;              // transfer13 in progress13
  wire                             pos_edge13;         // recognize13 posedge of sclk13
  wire                             neg_edge13;         // recognize13 negedge of sclk13
  wire                             last_bit13;         // marks13 last character13 bit
  
  // Address decoder13
  assign spi_divider_sel13 = wb_cyc_i13 & wb_stb_i13 & (wb_adr_i13[`SPI_OFS_BITS13] == `SPI_DEVIDE13);
  assign spi_ctrl_sel13    = wb_cyc_i13 & wb_stb_i13 & (wb_adr_i13[`SPI_OFS_BITS13] == `SPI_CTRL13);
  assign spi_tx_sel13[0]   = wb_cyc_i13 & wb_stb_i13 & (wb_adr_i13[`SPI_OFS_BITS13] == `SPI_TX_013);
  assign spi_tx_sel13[1]   = wb_cyc_i13 & wb_stb_i13 & (wb_adr_i13[`SPI_OFS_BITS13] == `SPI_TX_113);
  assign spi_tx_sel13[2]   = wb_cyc_i13 & wb_stb_i13 & (wb_adr_i13[`SPI_OFS_BITS13] == `SPI_TX_213);
  assign spi_tx_sel13[3]   = wb_cyc_i13 & wb_stb_i13 & (wb_adr_i13[`SPI_OFS_BITS13] == `SPI_TX_313);
  assign spi_ss_sel13      = wb_cyc_i13 & wb_stb_i13 & (wb_adr_i13[`SPI_OFS_BITS13] == `SPI_SS13);
  
  // Read from registers
  always @(wb_adr_i13 or rx13 or ctrl13 or divider13 or ss)
  begin
    case (wb_adr_i13[`SPI_OFS_BITS13])
`ifdef SPI_MAX_CHAR_12813
      `SPI_RX_013:    wb_dat13 = rx13[31:0];
      `SPI_RX_113:    wb_dat13 = rx13[63:32];
      `SPI_RX_213:    wb_dat13 = rx13[95:64];
      `SPI_RX_313:    wb_dat13 = {{128-`SPI_MAX_CHAR13{1'b0}}, rx13[`SPI_MAX_CHAR13-1:96]};
`else
`ifdef SPI_MAX_CHAR_6413
      `SPI_RX_013:    wb_dat13 = rx13[31:0];
      `SPI_RX_113:    wb_dat13 = {{64-`SPI_MAX_CHAR13{1'b0}}, rx13[`SPI_MAX_CHAR13-1:32]};
      `SPI_RX_213:    wb_dat13 = 32'b0;
      `SPI_RX_313:    wb_dat13 = 32'b0;
`else
      `SPI_RX_013:    wb_dat13 = {{32-`SPI_MAX_CHAR13{1'b0}}, rx13[`SPI_MAX_CHAR13-1:0]};
      `SPI_RX_113:    wb_dat13 = 32'b0;
      `SPI_RX_213:    wb_dat13 = 32'b0;
      `SPI_RX_313:    wb_dat13 = 32'b0;
`endif
`endif
      `SPI_CTRL13:    wb_dat13 = {{32-`SPI_CTRL_BIT_NB13{1'b0}}, ctrl13};
      `SPI_DEVIDE13:  wb_dat13 = {{32-`SPI_DIVIDER_LEN13{1'b0}}, divider13};
      `SPI_SS13:      wb_dat13 = {{32-`SPI_SS_NB13{1'b0}}, ss};
      default:      wb_dat13 = 32'bx;
    endcase
  end
  
  // Wb13 data out
  always @(posedge wb_clk_i13 or posedge wb_rst_i13)
  begin
    if (wb_rst_i13)
      wb_dat_o13 <= #Tp13 32'b0;
    else
      wb_dat_o13 <= #Tp13 wb_dat13;
  end
  
  // Wb13 acknowledge13
  always @(posedge wb_clk_i13 or posedge wb_rst_i13)
  begin
    if (wb_rst_i13)
      wb_ack_o13 <= #Tp13 1'b0;
    else
      wb_ack_o13 <= #Tp13 wb_cyc_i13 & wb_stb_i13 & ~wb_ack_o13;
  end
  
  // Wb13 error
  assign wb_err_o13 = 1'b0;
  
  // Interrupt13
  always @(posedge wb_clk_i13 or posedge wb_rst_i13)
  begin
    if (wb_rst_i13)
      wb_int_o13 <= #Tp13 1'b0;
    else if (ie13 && tip13 && last_bit13 && pos_edge13)
      wb_int_o13 <= #Tp13 1'b1;
    else if (wb_ack_o13)
      wb_int_o13 <= #Tp13 1'b0;
  end
  
  // Divider13 register
  always @(posedge wb_clk_i13 or posedge wb_rst_i13)
  begin
    if (wb_rst_i13)
        divider13 <= #Tp13 {`SPI_DIVIDER_LEN13{1'b0}};
    else if (spi_divider_sel13 && wb_we_i13 && !tip13)
      begin
      `ifdef SPI_DIVIDER_LEN_813
        if (wb_sel_i13[0])
          divider13 <= #Tp13 wb_dat_i13[`SPI_DIVIDER_LEN13-1:0];
      `endif
      `ifdef SPI_DIVIDER_LEN_1613
        if (wb_sel_i13[0])
          divider13[7:0] <= #Tp13 wb_dat_i13[7:0];
        if (wb_sel_i13[1])
          divider13[`SPI_DIVIDER_LEN13-1:8] <= #Tp13 wb_dat_i13[`SPI_DIVIDER_LEN13-1:8];
      `endif
      `ifdef SPI_DIVIDER_LEN_2413
        if (wb_sel_i13[0])
          divider13[7:0] <= #Tp13 wb_dat_i13[7:0];
        if (wb_sel_i13[1])
          divider13[15:8] <= #Tp13 wb_dat_i13[15:8];
        if (wb_sel_i13[2])
          divider13[`SPI_DIVIDER_LEN13-1:16] <= #Tp13 wb_dat_i13[`SPI_DIVIDER_LEN13-1:16];
      `endif
      `ifdef SPI_DIVIDER_LEN_3213
        if (wb_sel_i13[0])
          divider13[7:0] <= #Tp13 wb_dat_i13[7:0];
        if (wb_sel_i13[1])
          divider13[15:8] <= #Tp13 wb_dat_i13[15:8];
        if (wb_sel_i13[2])
          divider13[23:16] <= #Tp13 wb_dat_i13[23:16];
        if (wb_sel_i13[3])
          divider13[`SPI_DIVIDER_LEN13-1:24] <= #Tp13 wb_dat_i13[`SPI_DIVIDER_LEN13-1:24];
      `endif
      end
  end
  
  // Ctrl13 register
  always @(posedge wb_clk_i13 or posedge wb_rst_i13)
  begin
    if (wb_rst_i13)
      ctrl13 <= #Tp13 {`SPI_CTRL_BIT_NB13{1'b0}};
    else if(spi_ctrl_sel13 && wb_we_i13 && !tip13)
      begin
        if (wb_sel_i13[0])
          ctrl13[7:0] <= #Tp13 wb_dat_i13[7:0] | {7'b0, ctrl13[0]};
        if (wb_sel_i13[1])
          ctrl13[`SPI_CTRL_BIT_NB13-1:8] <= #Tp13 wb_dat_i13[`SPI_CTRL_BIT_NB13-1:8];
      end
    else if(tip13 && last_bit13 && pos_edge13)
      ctrl13[`SPI_CTRL_GO13] <= #Tp13 1'b0;
  end
  
  assign rx_negedge13 = ctrl13[`SPI_CTRL_RX_NEGEDGE13];
  assign tx_negedge13 = ctrl13[`SPI_CTRL_TX_NEGEDGE13];
  assign go13         = ctrl13[`SPI_CTRL_GO13];
  assign char_len13   = ctrl13[`SPI_CTRL_CHAR_LEN13];
  assign lsb        = ctrl13[`SPI_CTRL_LSB13];
  assign ie13         = ctrl13[`SPI_CTRL_IE13];
  assign ass13        = ctrl13[`SPI_CTRL_ASS13];
  
  // Slave13 select13 register
  always @(posedge wb_clk_i13 or posedge wb_rst_i13)
  begin
    if (wb_rst_i13)
      ss <= #Tp13 {`SPI_SS_NB13{1'b0}};
    else if(spi_ss_sel13 && wb_we_i13 && !tip13)
      begin
      `ifdef SPI_SS_NB_813
        if (wb_sel_i13[0])
          ss <= #Tp13 wb_dat_i13[`SPI_SS_NB13-1:0];
      `endif
      `ifdef SPI_SS_NB_1613
        if (wb_sel_i13[0])
          ss[7:0] <= #Tp13 wb_dat_i13[7:0];
        if (wb_sel_i13[1])
          ss[`SPI_SS_NB13-1:8] <= #Tp13 wb_dat_i13[`SPI_SS_NB13-1:8];
      `endif
      `ifdef SPI_SS_NB_2413
        if (wb_sel_i13[0])
          ss[7:0] <= #Tp13 wb_dat_i13[7:0];
        if (wb_sel_i13[1])
          ss[15:8] <= #Tp13 wb_dat_i13[15:8];
        if (wb_sel_i13[2])
          ss[`SPI_SS_NB13-1:16] <= #Tp13 wb_dat_i13[`SPI_SS_NB13-1:16];
      `endif
      `ifdef SPI_SS_NB_3213
        if (wb_sel_i13[0])
          ss[7:0] <= #Tp13 wb_dat_i13[7:0];
        if (wb_sel_i13[1])
          ss[15:8] <= #Tp13 wb_dat_i13[15:8];
        if (wb_sel_i13[2])
          ss[23:16] <= #Tp13 wb_dat_i13[23:16];
        if (wb_sel_i13[3])
          ss[`SPI_SS_NB13-1:24] <= #Tp13 wb_dat_i13[`SPI_SS_NB13-1:24];
      `endif
      end
  end
  
  assign ss_pad_o13 = ~((ss & {`SPI_SS_NB13{tip13 & ass13}}) | (ss & {`SPI_SS_NB13{!ass13}}));
  
  spi_clgen13 clgen13 (.clk_in13(wb_clk_i13), .rst13(wb_rst_i13), .go13(go13), .enable(tip13), .last_clk13(last_bit13),
                   .divider13(divider13), .clk_out13(sclk_pad_o13), .pos_edge13(pos_edge13), 
                   .neg_edge13(neg_edge13));
  
  spi_shift13 shift13 (.clk13(wb_clk_i13), .rst13(wb_rst_i13), .len(char_len13[`SPI_CHAR_LEN_BITS13-1:0]),
                   .latch13(spi_tx_sel13[3:0] & {4{wb_we_i13}}), .byte_sel13(wb_sel_i13), .lsb(lsb), 
                   .go13(go13), .pos_edge13(pos_edge13), .neg_edge13(neg_edge13), 
                   .rx_negedge13(rx_negedge13), .tx_negedge13(tx_negedge13),
                   .tip13(tip13), .last(last_bit13), 
                   .p_in13(wb_dat_i13), .p_out13(rx13), 
                   .s_clk13(sclk_pad_o13), .s_in13(miso_pad_i13), .s_out13(mosi_pad_o13));
endmodule
  
