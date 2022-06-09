//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_top22.v                                                   ////
////                                                              ////
////  This22 file is part of the SPI22 IP22 core22 project22                ////
////  http22://www22.opencores22.org22/projects22/spi22/                      ////
////                                                              ////
////  Author22(s):                                                  ////
////      - Simon22 Srot22 (simons22@opencores22.org22)                     ////
////                                                              ////
////  All additional22 information is avaliable22 in the Readme22.txt22   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright22 (C) 2002 Authors22                                   ////
////                                                              ////
//// This22 source22 file may be used and distributed22 without         ////
//// restriction22 provided that this copyright22 statement22 is not    ////
//// removed from the file and that any derivative22 work22 contains22  ////
//// the original copyright22 notice22 and the associated disclaimer22. ////
////                                                              ////
//// This22 source22 file is free software22; you can redistribute22 it   ////
//// and/or modify it under the terms22 of the GNU22 Lesser22 General22   ////
//// Public22 License22 as published22 by the Free22 Software22 Foundation22; ////
//// either22 version22 2.1 of the License22, or (at your22 option) any   ////
//// later22 version22.                                               ////
////                                                              ////
//// This22 source22 is distributed22 in the hope22 that it will be       ////
//// useful22, but WITHOUT22 ANY22 WARRANTY22; without even22 the implied22   ////
//// warranty22 of MERCHANTABILITY22 or FITNESS22 FOR22 A PARTICULAR22      ////
//// PURPOSE22.  See the GNU22 Lesser22 General22 Public22 License22 for more ////
//// details22.                                                     ////
////                                                              ////
//// You should have received22 a copy of the GNU22 Lesser22 General22    ////
//// Public22 License22 along22 with this source22; if not, download22 it   ////
//// from http22://www22.opencores22.org22/lgpl22.shtml22                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////


`include "spi_defines22.v"
`include "timescale.v"

module spi_top22
(
  // Wishbone22 signals22
  wb_clk_i22, wb_rst_i22, wb_adr_i22, wb_dat_i22, wb_dat_o22, wb_sel_i22,
  wb_we_i22, wb_stb_i22, wb_cyc_i22, wb_ack_o22, wb_err_o22, wb_int_o22,

  // SPI22 signals22
  ss_pad_o22, sclk_pad_o22, mosi_pad_o22, miso_pad_i22
);

  parameter Tp22 = 1;

  // Wishbone22 signals22
  input                            wb_clk_i22;         // master22 clock22 input
  input                            wb_rst_i22;         // synchronous22 active high22 reset
  input                      [4:0] wb_adr_i22;         // lower22 address bits
  input                   [32-1:0] wb_dat_i22;         // databus22 input
  output                  [32-1:0] wb_dat_o22;         // databus22 output
  input                      [3:0] wb_sel_i22;         // byte select22 inputs22
  input                            wb_we_i22;          // write enable input
  input                            wb_stb_i22;         // stobe22/core22 select22 signal22
  input                            wb_cyc_i22;         // valid bus cycle input
  output                           wb_ack_o22;         // bus cycle acknowledge22 output
  output                           wb_err_o22;         // termination w/ error
  output                           wb_int_o22;         // interrupt22 request signal22 output
                                                     
  // SPI22 signals22                                     
  output          [`SPI_SS_NB22-1:0] ss_pad_o22;         // slave22 select22
  output                           sclk_pad_o22;       // serial22 clock22
  output                           mosi_pad_o22;       // master22 out slave22 in
  input                            miso_pad_i22;       // master22 in slave22 out
                                                     
  reg                     [32-1:0] wb_dat_o22;
  reg                              wb_ack_o22;
  reg                              wb_int_o22;
                                               
  // Internal signals22
  reg       [`SPI_DIVIDER_LEN22-1:0] divider22;          // Divider22 register
  reg       [`SPI_CTRL_BIT_NB22-1:0] ctrl22;             // Control22 and status register
  reg             [`SPI_SS_NB22-1:0] ss;               // Slave22 select22 register
  reg                     [32-1:0] wb_dat22;           // wb22 data out
  wire         [`SPI_MAX_CHAR22-1:0] rx22;               // Rx22 register
  wire                             rx_negedge22;       // miso22 is sampled22 on negative edge
  wire                             tx_negedge22;       // mosi22 is driven22 on negative edge
  wire    [`SPI_CHAR_LEN_BITS22-1:0] char_len22;         // char22 len
  wire                             go22;               // go22
  wire                             lsb;              // lsb first on line
  wire                             ie22;               // interrupt22 enable
  wire                             ass22;              // automatic slave22 select22
  wire                             spi_divider_sel22;  // divider22 register select22
  wire                             spi_ctrl_sel22;     // ctrl22 register select22
  wire                       [3:0] spi_tx_sel22;       // tx_l22 register select22
  wire                             spi_ss_sel22;       // ss register select22
  wire                             tip22;              // transfer22 in progress22
  wire                             pos_edge22;         // recognize22 posedge of sclk22
  wire                             neg_edge22;         // recognize22 negedge of sclk22
  wire                             last_bit22;         // marks22 last character22 bit
  
  // Address decoder22
  assign spi_divider_sel22 = wb_cyc_i22 & wb_stb_i22 & (wb_adr_i22[`SPI_OFS_BITS22] == `SPI_DEVIDE22);
  assign spi_ctrl_sel22    = wb_cyc_i22 & wb_stb_i22 & (wb_adr_i22[`SPI_OFS_BITS22] == `SPI_CTRL22);
  assign spi_tx_sel22[0]   = wb_cyc_i22 & wb_stb_i22 & (wb_adr_i22[`SPI_OFS_BITS22] == `SPI_TX_022);
  assign spi_tx_sel22[1]   = wb_cyc_i22 & wb_stb_i22 & (wb_adr_i22[`SPI_OFS_BITS22] == `SPI_TX_122);
  assign spi_tx_sel22[2]   = wb_cyc_i22 & wb_stb_i22 & (wb_adr_i22[`SPI_OFS_BITS22] == `SPI_TX_222);
  assign spi_tx_sel22[3]   = wb_cyc_i22 & wb_stb_i22 & (wb_adr_i22[`SPI_OFS_BITS22] == `SPI_TX_322);
  assign spi_ss_sel22      = wb_cyc_i22 & wb_stb_i22 & (wb_adr_i22[`SPI_OFS_BITS22] == `SPI_SS22);
  
  // Read from registers
  always @(wb_adr_i22 or rx22 or ctrl22 or divider22 or ss)
  begin
    case (wb_adr_i22[`SPI_OFS_BITS22])
`ifdef SPI_MAX_CHAR_12822
      `SPI_RX_022:    wb_dat22 = rx22[31:0];
      `SPI_RX_122:    wb_dat22 = rx22[63:32];
      `SPI_RX_222:    wb_dat22 = rx22[95:64];
      `SPI_RX_322:    wb_dat22 = {{128-`SPI_MAX_CHAR22{1'b0}}, rx22[`SPI_MAX_CHAR22-1:96]};
`else
`ifdef SPI_MAX_CHAR_6422
      `SPI_RX_022:    wb_dat22 = rx22[31:0];
      `SPI_RX_122:    wb_dat22 = {{64-`SPI_MAX_CHAR22{1'b0}}, rx22[`SPI_MAX_CHAR22-1:32]};
      `SPI_RX_222:    wb_dat22 = 32'b0;
      `SPI_RX_322:    wb_dat22 = 32'b0;
`else
      `SPI_RX_022:    wb_dat22 = {{32-`SPI_MAX_CHAR22{1'b0}}, rx22[`SPI_MAX_CHAR22-1:0]};
      `SPI_RX_122:    wb_dat22 = 32'b0;
      `SPI_RX_222:    wb_dat22 = 32'b0;
      `SPI_RX_322:    wb_dat22 = 32'b0;
`endif
`endif
      `SPI_CTRL22:    wb_dat22 = {{32-`SPI_CTRL_BIT_NB22{1'b0}}, ctrl22};
      `SPI_DEVIDE22:  wb_dat22 = {{32-`SPI_DIVIDER_LEN22{1'b0}}, divider22};
      `SPI_SS22:      wb_dat22 = {{32-`SPI_SS_NB22{1'b0}}, ss};
      default:      wb_dat22 = 32'bx;
    endcase
  end
  
  // Wb22 data out
  always @(posedge wb_clk_i22 or posedge wb_rst_i22)
  begin
    if (wb_rst_i22)
      wb_dat_o22 <= #Tp22 32'b0;
    else
      wb_dat_o22 <= #Tp22 wb_dat22;
  end
  
  // Wb22 acknowledge22
  always @(posedge wb_clk_i22 or posedge wb_rst_i22)
  begin
    if (wb_rst_i22)
      wb_ack_o22 <= #Tp22 1'b0;
    else
      wb_ack_o22 <= #Tp22 wb_cyc_i22 & wb_stb_i22 & ~wb_ack_o22;
  end
  
  // Wb22 error
  assign wb_err_o22 = 1'b0;
  
  // Interrupt22
  always @(posedge wb_clk_i22 or posedge wb_rst_i22)
  begin
    if (wb_rst_i22)
      wb_int_o22 <= #Tp22 1'b0;
    else if (ie22 && tip22 && last_bit22 && pos_edge22)
      wb_int_o22 <= #Tp22 1'b1;
    else if (wb_ack_o22)
      wb_int_o22 <= #Tp22 1'b0;
  end
  
  // Divider22 register
  always @(posedge wb_clk_i22 or posedge wb_rst_i22)
  begin
    if (wb_rst_i22)
        divider22 <= #Tp22 {`SPI_DIVIDER_LEN22{1'b0}};
    else if (spi_divider_sel22 && wb_we_i22 && !tip22)
      begin
      `ifdef SPI_DIVIDER_LEN_822
        if (wb_sel_i22[0])
          divider22 <= #Tp22 wb_dat_i22[`SPI_DIVIDER_LEN22-1:0];
      `endif
      `ifdef SPI_DIVIDER_LEN_1622
        if (wb_sel_i22[0])
          divider22[7:0] <= #Tp22 wb_dat_i22[7:0];
        if (wb_sel_i22[1])
          divider22[`SPI_DIVIDER_LEN22-1:8] <= #Tp22 wb_dat_i22[`SPI_DIVIDER_LEN22-1:8];
      `endif
      `ifdef SPI_DIVIDER_LEN_2422
        if (wb_sel_i22[0])
          divider22[7:0] <= #Tp22 wb_dat_i22[7:0];
        if (wb_sel_i22[1])
          divider22[15:8] <= #Tp22 wb_dat_i22[15:8];
        if (wb_sel_i22[2])
          divider22[`SPI_DIVIDER_LEN22-1:16] <= #Tp22 wb_dat_i22[`SPI_DIVIDER_LEN22-1:16];
      `endif
      `ifdef SPI_DIVIDER_LEN_3222
        if (wb_sel_i22[0])
          divider22[7:0] <= #Tp22 wb_dat_i22[7:0];
        if (wb_sel_i22[1])
          divider22[15:8] <= #Tp22 wb_dat_i22[15:8];
        if (wb_sel_i22[2])
          divider22[23:16] <= #Tp22 wb_dat_i22[23:16];
        if (wb_sel_i22[3])
          divider22[`SPI_DIVIDER_LEN22-1:24] <= #Tp22 wb_dat_i22[`SPI_DIVIDER_LEN22-1:24];
      `endif
      end
  end
  
  // Ctrl22 register
  always @(posedge wb_clk_i22 or posedge wb_rst_i22)
  begin
    if (wb_rst_i22)
      ctrl22 <= #Tp22 {`SPI_CTRL_BIT_NB22{1'b0}};
    else if(spi_ctrl_sel22 && wb_we_i22 && !tip22)
      begin
        if (wb_sel_i22[0])
          ctrl22[7:0] <= #Tp22 wb_dat_i22[7:0] | {7'b0, ctrl22[0]};
        if (wb_sel_i22[1])
          ctrl22[`SPI_CTRL_BIT_NB22-1:8] <= #Tp22 wb_dat_i22[`SPI_CTRL_BIT_NB22-1:8];
      end
    else if(tip22 && last_bit22 && pos_edge22)
      ctrl22[`SPI_CTRL_GO22] <= #Tp22 1'b0;
  end
  
  assign rx_negedge22 = ctrl22[`SPI_CTRL_RX_NEGEDGE22];
  assign tx_negedge22 = ctrl22[`SPI_CTRL_TX_NEGEDGE22];
  assign go22         = ctrl22[`SPI_CTRL_GO22];
  assign char_len22   = ctrl22[`SPI_CTRL_CHAR_LEN22];
  assign lsb        = ctrl22[`SPI_CTRL_LSB22];
  assign ie22         = ctrl22[`SPI_CTRL_IE22];
  assign ass22        = ctrl22[`SPI_CTRL_ASS22];
  
  // Slave22 select22 register
  always @(posedge wb_clk_i22 or posedge wb_rst_i22)
  begin
    if (wb_rst_i22)
      ss <= #Tp22 {`SPI_SS_NB22{1'b0}};
    else if(spi_ss_sel22 && wb_we_i22 && !tip22)
      begin
      `ifdef SPI_SS_NB_822
        if (wb_sel_i22[0])
          ss <= #Tp22 wb_dat_i22[`SPI_SS_NB22-1:0];
      `endif
      `ifdef SPI_SS_NB_1622
        if (wb_sel_i22[0])
          ss[7:0] <= #Tp22 wb_dat_i22[7:0];
        if (wb_sel_i22[1])
          ss[`SPI_SS_NB22-1:8] <= #Tp22 wb_dat_i22[`SPI_SS_NB22-1:8];
      `endif
      `ifdef SPI_SS_NB_2422
        if (wb_sel_i22[0])
          ss[7:0] <= #Tp22 wb_dat_i22[7:0];
        if (wb_sel_i22[1])
          ss[15:8] <= #Tp22 wb_dat_i22[15:8];
        if (wb_sel_i22[2])
          ss[`SPI_SS_NB22-1:16] <= #Tp22 wb_dat_i22[`SPI_SS_NB22-1:16];
      `endif
      `ifdef SPI_SS_NB_3222
        if (wb_sel_i22[0])
          ss[7:0] <= #Tp22 wb_dat_i22[7:0];
        if (wb_sel_i22[1])
          ss[15:8] <= #Tp22 wb_dat_i22[15:8];
        if (wb_sel_i22[2])
          ss[23:16] <= #Tp22 wb_dat_i22[23:16];
        if (wb_sel_i22[3])
          ss[`SPI_SS_NB22-1:24] <= #Tp22 wb_dat_i22[`SPI_SS_NB22-1:24];
      `endif
      end
  end
  
  assign ss_pad_o22 = ~((ss & {`SPI_SS_NB22{tip22 & ass22}}) | (ss & {`SPI_SS_NB22{!ass22}}));
  
  spi_clgen22 clgen22 (.clk_in22(wb_clk_i22), .rst22(wb_rst_i22), .go22(go22), .enable(tip22), .last_clk22(last_bit22),
                   .divider22(divider22), .clk_out22(sclk_pad_o22), .pos_edge22(pos_edge22), 
                   .neg_edge22(neg_edge22));
  
  spi_shift22 shift22 (.clk22(wb_clk_i22), .rst22(wb_rst_i22), .len(char_len22[`SPI_CHAR_LEN_BITS22-1:0]),
                   .latch22(spi_tx_sel22[3:0] & {4{wb_we_i22}}), .byte_sel22(wb_sel_i22), .lsb(lsb), 
                   .go22(go22), .pos_edge22(pos_edge22), .neg_edge22(neg_edge22), 
                   .rx_negedge22(rx_negedge22), .tx_negedge22(tx_negedge22),
                   .tip22(tip22), .last(last_bit22), 
                   .p_in22(wb_dat_i22), .p_out22(rx22), 
                   .s_clk22(sclk_pad_o22), .s_in22(miso_pad_i22), .s_out22(mosi_pad_o22));
endmodule
  
