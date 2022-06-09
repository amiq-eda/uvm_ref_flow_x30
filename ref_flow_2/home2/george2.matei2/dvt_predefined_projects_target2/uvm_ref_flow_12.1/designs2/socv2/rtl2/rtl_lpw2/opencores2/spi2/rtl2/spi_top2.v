//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_top2.v                                                   ////
////                                                              ////
////  This2 file is part of the SPI2 IP2 core2 project2                ////
////  http2://www2.opencores2.org2/projects2/spi2/                      ////
////                                                              ////
////  Author2(s):                                                  ////
////      - Simon2 Srot2 (simons2@opencores2.org2)                     ////
////                                                              ////
////  All additional2 information is avaliable2 in the Readme2.txt2   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright2 (C) 2002 Authors2                                   ////
////                                                              ////
//// This2 source2 file may be used and distributed2 without         ////
//// restriction2 provided that this copyright2 statement2 is not    ////
//// removed from the file and that any derivative2 work2 contains2  ////
//// the original copyright2 notice2 and the associated disclaimer2. ////
////                                                              ////
//// This2 source2 file is free software2; you can redistribute2 it   ////
//// and/or modify it under the terms2 of the GNU2 Lesser2 General2   ////
//// Public2 License2 as published2 by the Free2 Software2 Foundation2; ////
//// either2 version2 2.1 of the License2, or (at your2 option) any   ////
//// later2 version2.                                               ////
////                                                              ////
//// This2 source2 is distributed2 in the hope2 that it will be       ////
//// useful2, but WITHOUT2 ANY2 WARRANTY2; without even2 the implied2   ////
//// warranty2 of MERCHANTABILITY2 or FITNESS2 FOR2 A PARTICULAR2      ////
//// PURPOSE2.  See the GNU2 Lesser2 General2 Public2 License2 for more ////
//// details2.                                                     ////
////                                                              ////
//// You should have received2 a copy of the GNU2 Lesser2 General2    ////
//// Public2 License2 along2 with this source2; if not, download2 it   ////
//// from http2://www2.opencores2.org2/lgpl2.shtml2                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////


`include "spi_defines2.v"
`include "timescale.v"

module spi_top2
(
  // Wishbone2 signals2
  wb_clk_i2, wb_rst_i2, wb_adr_i2, wb_dat_i2, wb_dat_o2, wb_sel_i2,
  wb_we_i2, wb_stb_i2, wb_cyc_i2, wb_ack_o2, wb_err_o2, wb_int_o2,

  // SPI2 signals2
  ss_pad_o2, sclk_pad_o2, mosi_pad_o2, miso_pad_i2
);

  parameter Tp2 = 1;

  // Wishbone2 signals2
  input                            wb_clk_i2;         // master2 clock2 input
  input                            wb_rst_i2;         // synchronous2 active high2 reset
  input                      [4:0] wb_adr_i2;         // lower2 address bits
  input                   [32-1:0] wb_dat_i2;         // databus2 input
  output                  [32-1:0] wb_dat_o2;         // databus2 output
  input                      [3:0] wb_sel_i2;         // byte select2 inputs2
  input                            wb_we_i2;          // write enable input
  input                            wb_stb_i2;         // stobe2/core2 select2 signal2
  input                            wb_cyc_i2;         // valid bus cycle input
  output                           wb_ack_o2;         // bus cycle acknowledge2 output
  output                           wb_err_o2;         // termination w/ error
  output                           wb_int_o2;         // interrupt2 request signal2 output
                                                     
  // SPI2 signals2                                     
  output          [`SPI_SS_NB2-1:0] ss_pad_o2;         // slave2 select2
  output                           sclk_pad_o2;       // serial2 clock2
  output                           mosi_pad_o2;       // master2 out slave2 in
  input                            miso_pad_i2;       // master2 in slave2 out
                                                     
  reg                     [32-1:0] wb_dat_o2;
  reg                              wb_ack_o2;
  reg                              wb_int_o2;
                                               
  // Internal signals2
  reg       [`SPI_DIVIDER_LEN2-1:0] divider2;          // Divider2 register
  reg       [`SPI_CTRL_BIT_NB2-1:0] ctrl2;             // Control2 and status register
  reg             [`SPI_SS_NB2-1:0] ss;               // Slave2 select2 register
  reg                     [32-1:0] wb_dat2;           // wb2 data out
  wire         [`SPI_MAX_CHAR2-1:0] rx2;               // Rx2 register
  wire                             rx_negedge2;       // miso2 is sampled2 on negative edge
  wire                             tx_negedge2;       // mosi2 is driven2 on negative edge
  wire    [`SPI_CHAR_LEN_BITS2-1:0] char_len2;         // char2 len
  wire                             go2;               // go2
  wire                             lsb;              // lsb first on line
  wire                             ie2;               // interrupt2 enable
  wire                             ass2;              // automatic slave2 select2
  wire                             spi_divider_sel2;  // divider2 register select2
  wire                             spi_ctrl_sel2;     // ctrl2 register select2
  wire                       [3:0] spi_tx_sel2;       // tx_l2 register select2
  wire                             spi_ss_sel2;       // ss register select2
  wire                             tip2;              // transfer2 in progress2
  wire                             pos_edge2;         // recognize2 posedge of sclk2
  wire                             neg_edge2;         // recognize2 negedge of sclk2
  wire                             last_bit2;         // marks2 last character2 bit
  
  // Address decoder2
  assign spi_divider_sel2 = wb_cyc_i2 & wb_stb_i2 & (wb_adr_i2[`SPI_OFS_BITS2] == `SPI_DEVIDE2);
  assign spi_ctrl_sel2    = wb_cyc_i2 & wb_stb_i2 & (wb_adr_i2[`SPI_OFS_BITS2] == `SPI_CTRL2);
  assign spi_tx_sel2[0]   = wb_cyc_i2 & wb_stb_i2 & (wb_adr_i2[`SPI_OFS_BITS2] == `SPI_TX_02);
  assign spi_tx_sel2[1]   = wb_cyc_i2 & wb_stb_i2 & (wb_adr_i2[`SPI_OFS_BITS2] == `SPI_TX_12);
  assign spi_tx_sel2[2]   = wb_cyc_i2 & wb_stb_i2 & (wb_adr_i2[`SPI_OFS_BITS2] == `SPI_TX_22);
  assign spi_tx_sel2[3]   = wb_cyc_i2 & wb_stb_i2 & (wb_adr_i2[`SPI_OFS_BITS2] == `SPI_TX_32);
  assign spi_ss_sel2      = wb_cyc_i2 & wb_stb_i2 & (wb_adr_i2[`SPI_OFS_BITS2] == `SPI_SS2);
  
  // Read from registers
  always @(wb_adr_i2 or rx2 or ctrl2 or divider2 or ss)
  begin
    case (wb_adr_i2[`SPI_OFS_BITS2])
`ifdef SPI_MAX_CHAR_1282
      `SPI_RX_02:    wb_dat2 = rx2[31:0];
      `SPI_RX_12:    wb_dat2 = rx2[63:32];
      `SPI_RX_22:    wb_dat2 = rx2[95:64];
      `SPI_RX_32:    wb_dat2 = {{128-`SPI_MAX_CHAR2{1'b0}}, rx2[`SPI_MAX_CHAR2-1:96]};
`else
`ifdef SPI_MAX_CHAR_642
      `SPI_RX_02:    wb_dat2 = rx2[31:0];
      `SPI_RX_12:    wb_dat2 = {{64-`SPI_MAX_CHAR2{1'b0}}, rx2[`SPI_MAX_CHAR2-1:32]};
      `SPI_RX_22:    wb_dat2 = 32'b0;
      `SPI_RX_32:    wb_dat2 = 32'b0;
`else
      `SPI_RX_02:    wb_dat2 = {{32-`SPI_MAX_CHAR2{1'b0}}, rx2[`SPI_MAX_CHAR2-1:0]};
      `SPI_RX_12:    wb_dat2 = 32'b0;
      `SPI_RX_22:    wb_dat2 = 32'b0;
      `SPI_RX_32:    wb_dat2 = 32'b0;
`endif
`endif
      `SPI_CTRL2:    wb_dat2 = {{32-`SPI_CTRL_BIT_NB2{1'b0}}, ctrl2};
      `SPI_DEVIDE2:  wb_dat2 = {{32-`SPI_DIVIDER_LEN2{1'b0}}, divider2};
      `SPI_SS2:      wb_dat2 = {{32-`SPI_SS_NB2{1'b0}}, ss};
      default:      wb_dat2 = 32'bx;
    endcase
  end
  
  // Wb2 data out
  always @(posedge wb_clk_i2 or posedge wb_rst_i2)
  begin
    if (wb_rst_i2)
      wb_dat_o2 <= #Tp2 32'b0;
    else
      wb_dat_o2 <= #Tp2 wb_dat2;
  end
  
  // Wb2 acknowledge2
  always @(posedge wb_clk_i2 or posedge wb_rst_i2)
  begin
    if (wb_rst_i2)
      wb_ack_o2 <= #Tp2 1'b0;
    else
      wb_ack_o2 <= #Tp2 wb_cyc_i2 & wb_stb_i2 & ~wb_ack_o2;
  end
  
  // Wb2 error
  assign wb_err_o2 = 1'b0;
  
  // Interrupt2
  always @(posedge wb_clk_i2 or posedge wb_rst_i2)
  begin
    if (wb_rst_i2)
      wb_int_o2 <= #Tp2 1'b0;
    else if (ie2 && tip2 && last_bit2 && pos_edge2)
      wb_int_o2 <= #Tp2 1'b1;
    else if (wb_ack_o2)
      wb_int_o2 <= #Tp2 1'b0;
  end
  
  // Divider2 register
  always @(posedge wb_clk_i2 or posedge wb_rst_i2)
  begin
    if (wb_rst_i2)
        divider2 <= #Tp2 {`SPI_DIVIDER_LEN2{1'b0}};
    else if (spi_divider_sel2 && wb_we_i2 && !tip2)
      begin
      `ifdef SPI_DIVIDER_LEN_82
        if (wb_sel_i2[0])
          divider2 <= #Tp2 wb_dat_i2[`SPI_DIVIDER_LEN2-1:0];
      `endif
      `ifdef SPI_DIVIDER_LEN_162
        if (wb_sel_i2[0])
          divider2[7:0] <= #Tp2 wb_dat_i2[7:0];
        if (wb_sel_i2[1])
          divider2[`SPI_DIVIDER_LEN2-1:8] <= #Tp2 wb_dat_i2[`SPI_DIVIDER_LEN2-1:8];
      `endif
      `ifdef SPI_DIVIDER_LEN_242
        if (wb_sel_i2[0])
          divider2[7:0] <= #Tp2 wb_dat_i2[7:0];
        if (wb_sel_i2[1])
          divider2[15:8] <= #Tp2 wb_dat_i2[15:8];
        if (wb_sel_i2[2])
          divider2[`SPI_DIVIDER_LEN2-1:16] <= #Tp2 wb_dat_i2[`SPI_DIVIDER_LEN2-1:16];
      `endif
      `ifdef SPI_DIVIDER_LEN_322
        if (wb_sel_i2[0])
          divider2[7:0] <= #Tp2 wb_dat_i2[7:0];
        if (wb_sel_i2[1])
          divider2[15:8] <= #Tp2 wb_dat_i2[15:8];
        if (wb_sel_i2[2])
          divider2[23:16] <= #Tp2 wb_dat_i2[23:16];
        if (wb_sel_i2[3])
          divider2[`SPI_DIVIDER_LEN2-1:24] <= #Tp2 wb_dat_i2[`SPI_DIVIDER_LEN2-1:24];
      `endif
      end
  end
  
  // Ctrl2 register
  always @(posedge wb_clk_i2 or posedge wb_rst_i2)
  begin
    if (wb_rst_i2)
      ctrl2 <= #Tp2 {`SPI_CTRL_BIT_NB2{1'b0}};
    else if(spi_ctrl_sel2 && wb_we_i2 && !tip2)
      begin
        if (wb_sel_i2[0])
          ctrl2[7:0] <= #Tp2 wb_dat_i2[7:0] | {7'b0, ctrl2[0]};
        if (wb_sel_i2[1])
          ctrl2[`SPI_CTRL_BIT_NB2-1:8] <= #Tp2 wb_dat_i2[`SPI_CTRL_BIT_NB2-1:8];
      end
    else if(tip2 && last_bit2 && pos_edge2)
      ctrl2[`SPI_CTRL_GO2] <= #Tp2 1'b0;
  end
  
  assign rx_negedge2 = ctrl2[`SPI_CTRL_RX_NEGEDGE2];
  assign tx_negedge2 = ctrl2[`SPI_CTRL_TX_NEGEDGE2];
  assign go2         = ctrl2[`SPI_CTRL_GO2];
  assign char_len2   = ctrl2[`SPI_CTRL_CHAR_LEN2];
  assign lsb        = ctrl2[`SPI_CTRL_LSB2];
  assign ie2         = ctrl2[`SPI_CTRL_IE2];
  assign ass2        = ctrl2[`SPI_CTRL_ASS2];
  
  // Slave2 select2 register
  always @(posedge wb_clk_i2 or posedge wb_rst_i2)
  begin
    if (wb_rst_i2)
      ss <= #Tp2 {`SPI_SS_NB2{1'b0}};
    else if(spi_ss_sel2 && wb_we_i2 && !tip2)
      begin
      `ifdef SPI_SS_NB_82
        if (wb_sel_i2[0])
          ss <= #Tp2 wb_dat_i2[`SPI_SS_NB2-1:0];
      `endif
      `ifdef SPI_SS_NB_162
        if (wb_sel_i2[0])
          ss[7:0] <= #Tp2 wb_dat_i2[7:0];
        if (wb_sel_i2[1])
          ss[`SPI_SS_NB2-1:8] <= #Tp2 wb_dat_i2[`SPI_SS_NB2-1:8];
      `endif
      `ifdef SPI_SS_NB_242
        if (wb_sel_i2[0])
          ss[7:0] <= #Tp2 wb_dat_i2[7:0];
        if (wb_sel_i2[1])
          ss[15:8] <= #Tp2 wb_dat_i2[15:8];
        if (wb_sel_i2[2])
          ss[`SPI_SS_NB2-1:16] <= #Tp2 wb_dat_i2[`SPI_SS_NB2-1:16];
      `endif
      `ifdef SPI_SS_NB_322
        if (wb_sel_i2[0])
          ss[7:0] <= #Tp2 wb_dat_i2[7:0];
        if (wb_sel_i2[1])
          ss[15:8] <= #Tp2 wb_dat_i2[15:8];
        if (wb_sel_i2[2])
          ss[23:16] <= #Tp2 wb_dat_i2[23:16];
        if (wb_sel_i2[3])
          ss[`SPI_SS_NB2-1:24] <= #Tp2 wb_dat_i2[`SPI_SS_NB2-1:24];
      `endif
      end
  end
  
  assign ss_pad_o2 = ~((ss & {`SPI_SS_NB2{tip2 & ass2}}) | (ss & {`SPI_SS_NB2{!ass2}}));
  
  spi_clgen2 clgen2 (.clk_in2(wb_clk_i2), .rst2(wb_rst_i2), .go2(go2), .enable(tip2), .last_clk2(last_bit2),
                   .divider2(divider2), .clk_out2(sclk_pad_o2), .pos_edge2(pos_edge2), 
                   .neg_edge2(neg_edge2));
  
  spi_shift2 shift2 (.clk2(wb_clk_i2), .rst2(wb_rst_i2), .len(char_len2[`SPI_CHAR_LEN_BITS2-1:0]),
                   .latch2(spi_tx_sel2[3:0] & {4{wb_we_i2}}), .byte_sel2(wb_sel_i2), .lsb(lsb), 
                   .go2(go2), .pos_edge2(pos_edge2), .neg_edge2(neg_edge2), 
                   .rx_negedge2(rx_negedge2), .tx_negedge2(tx_negedge2),
                   .tip2(tip2), .last(last_bit2), 
                   .p_in2(wb_dat_i2), .p_out2(rx2), 
                   .s_clk2(sclk_pad_o2), .s_in2(miso_pad_i2), .s_out2(mosi_pad_o2));
endmodule
  
