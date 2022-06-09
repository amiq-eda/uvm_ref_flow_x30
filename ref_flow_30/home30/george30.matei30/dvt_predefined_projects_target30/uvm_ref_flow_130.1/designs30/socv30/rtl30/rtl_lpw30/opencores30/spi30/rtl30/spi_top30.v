//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_top30.v                                                   ////
////                                                              ////
////  This30 file is part of the SPI30 IP30 core30 project30                ////
////  http30://www30.opencores30.org30/projects30/spi30/                      ////
////                                                              ////
////  Author30(s):                                                  ////
////      - Simon30 Srot30 (simons30@opencores30.org30)                     ////
////                                                              ////
////  All additional30 information is avaliable30 in the Readme30.txt30   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright30 (C) 2002 Authors30                                   ////
////                                                              ////
//// This30 source30 file may be used and distributed30 without         ////
//// restriction30 provided that this copyright30 statement30 is not    ////
//// removed from the file and that any derivative30 work30 contains30  ////
//// the original copyright30 notice30 and the associated disclaimer30. ////
////                                                              ////
//// This30 source30 file is free software30; you can redistribute30 it   ////
//// and/or modify it under the terms30 of the GNU30 Lesser30 General30   ////
//// Public30 License30 as published30 by the Free30 Software30 Foundation30; ////
//// either30 version30 2.1 of the License30, or (at your30 option) any   ////
//// later30 version30.                                               ////
////                                                              ////
//// This30 source30 is distributed30 in the hope30 that it will be       ////
//// useful30, but WITHOUT30 ANY30 WARRANTY30; without even30 the implied30   ////
//// warranty30 of MERCHANTABILITY30 or FITNESS30 FOR30 A PARTICULAR30      ////
//// PURPOSE30.  See the GNU30 Lesser30 General30 Public30 License30 for more ////
//// details30.                                                     ////
////                                                              ////
//// You should have received30 a copy of the GNU30 Lesser30 General30    ////
//// Public30 License30 along30 with this source30; if not, download30 it   ////
//// from http30://www30.opencores30.org30/lgpl30.shtml30                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////


`include "spi_defines30.v"
`include "timescale.v"

module spi_top30
(
  // Wishbone30 signals30
  wb_clk_i30, wb_rst_i30, wb_adr_i30, wb_dat_i30, wb_dat_o30, wb_sel_i30,
  wb_we_i30, wb_stb_i30, wb_cyc_i30, wb_ack_o30, wb_err_o30, wb_int_o30,

  // SPI30 signals30
  ss_pad_o30, sclk_pad_o30, mosi_pad_o30, miso_pad_i30
);

  parameter Tp30 = 1;

  // Wishbone30 signals30
  input                            wb_clk_i30;         // master30 clock30 input
  input                            wb_rst_i30;         // synchronous30 active high30 reset
  input                      [4:0] wb_adr_i30;         // lower30 address bits
  input                   [32-1:0] wb_dat_i30;         // databus30 input
  output                  [32-1:0] wb_dat_o30;         // databus30 output
  input                      [3:0] wb_sel_i30;         // byte select30 inputs30
  input                            wb_we_i30;          // write enable input
  input                            wb_stb_i30;         // stobe30/core30 select30 signal30
  input                            wb_cyc_i30;         // valid bus cycle input
  output                           wb_ack_o30;         // bus cycle acknowledge30 output
  output                           wb_err_o30;         // termination w/ error
  output                           wb_int_o30;         // interrupt30 request signal30 output
                                                     
  // SPI30 signals30                                     
  output          [`SPI_SS_NB30-1:0] ss_pad_o30;         // slave30 select30
  output                           sclk_pad_o30;       // serial30 clock30
  output                           mosi_pad_o30;       // master30 out slave30 in
  input                            miso_pad_i30;       // master30 in slave30 out
                                                     
  reg                     [32-1:0] wb_dat_o30;
  reg                              wb_ack_o30;
  reg                              wb_int_o30;
                                               
  // Internal signals30
  reg       [`SPI_DIVIDER_LEN30-1:0] divider30;          // Divider30 register
  reg       [`SPI_CTRL_BIT_NB30-1:0] ctrl30;             // Control30 and status register
  reg             [`SPI_SS_NB30-1:0] ss;               // Slave30 select30 register
  reg                     [32-1:0] wb_dat30;           // wb30 data out
  wire         [`SPI_MAX_CHAR30-1:0] rx30;               // Rx30 register
  wire                             rx_negedge30;       // miso30 is sampled30 on negative edge
  wire                             tx_negedge30;       // mosi30 is driven30 on negative edge
  wire    [`SPI_CHAR_LEN_BITS30-1:0] char_len30;         // char30 len
  wire                             go30;               // go30
  wire                             lsb;              // lsb first on line
  wire                             ie30;               // interrupt30 enable
  wire                             ass30;              // automatic slave30 select30
  wire                             spi_divider_sel30;  // divider30 register select30
  wire                             spi_ctrl_sel30;     // ctrl30 register select30
  wire                       [3:0] spi_tx_sel30;       // tx_l30 register select30
  wire                             spi_ss_sel30;       // ss register select30
  wire                             tip30;              // transfer30 in progress30
  wire                             pos_edge30;         // recognize30 posedge of sclk30
  wire                             neg_edge30;         // recognize30 negedge of sclk30
  wire                             last_bit30;         // marks30 last character30 bit
  
  // Address decoder30
  assign spi_divider_sel30 = wb_cyc_i30 & wb_stb_i30 & (wb_adr_i30[`SPI_OFS_BITS30] == `SPI_DEVIDE30);
  assign spi_ctrl_sel30    = wb_cyc_i30 & wb_stb_i30 & (wb_adr_i30[`SPI_OFS_BITS30] == `SPI_CTRL30);
  assign spi_tx_sel30[0]   = wb_cyc_i30 & wb_stb_i30 & (wb_adr_i30[`SPI_OFS_BITS30] == `SPI_TX_030);
  assign spi_tx_sel30[1]   = wb_cyc_i30 & wb_stb_i30 & (wb_adr_i30[`SPI_OFS_BITS30] == `SPI_TX_130);
  assign spi_tx_sel30[2]   = wb_cyc_i30 & wb_stb_i30 & (wb_adr_i30[`SPI_OFS_BITS30] == `SPI_TX_230);
  assign spi_tx_sel30[3]   = wb_cyc_i30 & wb_stb_i30 & (wb_adr_i30[`SPI_OFS_BITS30] == `SPI_TX_330);
  assign spi_ss_sel30      = wb_cyc_i30 & wb_stb_i30 & (wb_adr_i30[`SPI_OFS_BITS30] == `SPI_SS30);
  
  // Read from registers
  always @(wb_adr_i30 or rx30 or ctrl30 or divider30 or ss)
  begin
    case (wb_adr_i30[`SPI_OFS_BITS30])
`ifdef SPI_MAX_CHAR_12830
      `SPI_RX_030:    wb_dat30 = rx30[31:0];
      `SPI_RX_130:    wb_dat30 = rx30[63:32];
      `SPI_RX_230:    wb_dat30 = rx30[95:64];
      `SPI_RX_330:    wb_dat30 = {{128-`SPI_MAX_CHAR30{1'b0}}, rx30[`SPI_MAX_CHAR30-1:96]};
`else
`ifdef SPI_MAX_CHAR_6430
      `SPI_RX_030:    wb_dat30 = rx30[31:0];
      `SPI_RX_130:    wb_dat30 = {{64-`SPI_MAX_CHAR30{1'b0}}, rx30[`SPI_MAX_CHAR30-1:32]};
      `SPI_RX_230:    wb_dat30 = 32'b0;
      `SPI_RX_330:    wb_dat30 = 32'b0;
`else
      `SPI_RX_030:    wb_dat30 = {{32-`SPI_MAX_CHAR30{1'b0}}, rx30[`SPI_MAX_CHAR30-1:0]};
      `SPI_RX_130:    wb_dat30 = 32'b0;
      `SPI_RX_230:    wb_dat30 = 32'b0;
      `SPI_RX_330:    wb_dat30 = 32'b0;
`endif
`endif
      `SPI_CTRL30:    wb_dat30 = {{32-`SPI_CTRL_BIT_NB30{1'b0}}, ctrl30};
      `SPI_DEVIDE30:  wb_dat30 = {{32-`SPI_DIVIDER_LEN30{1'b0}}, divider30};
      `SPI_SS30:      wb_dat30 = {{32-`SPI_SS_NB30{1'b0}}, ss};
      default:      wb_dat30 = 32'bx;
    endcase
  end
  
  // Wb30 data out
  always @(posedge wb_clk_i30 or posedge wb_rst_i30)
  begin
    if (wb_rst_i30)
      wb_dat_o30 <= #Tp30 32'b0;
    else
      wb_dat_o30 <= #Tp30 wb_dat30;
  end
  
  // Wb30 acknowledge30
  always @(posedge wb_clk_i30 or posedge wb_rst_i30)
  begin
    if (wb_rst_i30)
      wb_ack_o30 <= #Tp30 1'b0;
    else
      wb_ack_o30 <= #Tp30 wb_cyc_i30 & wb_stb_i30 & ~wb_ack_o30;
  end
  
  // Wb30 error
  assign wb_err_o30 = 1'b0;
  
  // Interrupt30
  always @(posedge wb_clk_i30 or posedge wb_rst_i30)
  begin
    if (wb_rst_i30)
      wb_int_o30 <= #Tp30 1'b0;
    else if (ie30 && tip30 && last_bit30 && pos_edge30)
      wb_int_o30 <= #Tp30 1'b1;
    else if (wb_ack_o30)
      wb_int_o30 <= #Tp30 1'b0;
  end
  
  // Divider30 register
  always @(posedge wb_clk_i30 or posedge wb_rst_i30)
  begin
    if (wb_rst_i30)
        divider30 <= #Tp30 {`SPI_DIVIDER_LEN30{1'b0}};
    else if (spi_divider_sel30 && wb_we_i30 && !tip30)
      begin
      `ifdef SPI_DIVIDER_LEN_830
        if (wb_sel_i30[0])
          divider30 <= #Tp30 wb_dat_i30[`SPI_DIVIDER_LEN30-1:0];
      `endif
      `ifdef SPI_DIVIDER_LEN_1630
        if (wb_sel_i30[0])
          divider30[7:0] <= #Tp30 wb_dat_i30[7:0];
        if (wb_sel_i30[1])
          divider30[`SPI_DIVIDER_LEN30-1:8] <= #Tp30 wb_dat_i30[`SPI_DIVIDER_LEN30-1:8];
      `endif
      `ifdef SPI_DIVIDER_LEN_2430
        if (wb_sel_i30[0])
          divider30[7:0] <= #Tp30 wb_dat_i30[7:0];
        if (wb_sel_i30[1])
          divider30[15:8] <= #Tp30 wb_dat_i30[15:8];
        if (wb_sel_i30[2])
          divider30[`SPI_DIVIDER_LEN30-1:16] <= #Tp30 wb_dat_i30[`SPI_DIVIDER_LEN30-1:16];
      `endif
      `ifdef SPI_DIVIDER_LEN_3230
        if (wb_sel_i30[0])
          divider30[7:0] <= #Tp30 wb_dat_i30[7:0];
        if (wb_sel_i30[1])
          divider30[15:8] <= #Tp30 wb_dat_i30[15:8];
        if (wb_sel_i30[2])
          divider30[23:16] <= #Tp30 wb_dat_i30[23:16];
        if (wb_sel_i30[3])
          divider30[`SPI_DIVIDER_LEN30-1:24] <= #Tp30 wb_dat_i30[`SPI_DIVIDER_LEN30-1:24];
      `endif
      end
  end
  
  // Ctrl30 register
  always @(posedge wb_clk_i30 or posedge wb_rst_i30)
  begin
    if (wb_rst_i30)
      ctrl30 <= #Tp30 {`SPI_CTRL_BIT_NB30{1'b0}};
    else if(spi_ctrl_sel30 && wb_we_i30 && !tip30)
      begin
        if (wb_sel_i30[0])
          ctrl30[7:0] <= #Tp30 wb_dat_i30[7:0] | {7'b0, ctrl30[0]};
        if (wb_sel_i30[1])
          ctrl30[`SPI_CTRL_BIT_NB30-1:8] <= #Tp30 wb_dat_i30[`SPI_CTRL_BIT_NB30-1:8];
      end
    else if(tip30 && last_bit30 && pos_edge30)
      ctrl30[`SPI_CTRL_GO30] <= #Tp30 1'b0;
  end
  
  assign rx_negedge30 = ctrl30[`SPI_CTRL_RX_NEGEDGE30];
  assign tx_negedge30 = ctrl30[`SPI_CTRL_TX_NEGEDGE30];
  assign go30         = ctrl30[`SPI_CTRL_GO30];
  assign char_len30   = ctrl30[`SPI_CTRL_CHAR_LEN30];
  assign lsb        = ctrl30[`SPI_CTRL_LSB30];
  assign ie30         = ctrl30[`SPI_CTRL_IE30];
  assign ass30        = ctrl30[`SPI_CTRL_ASS30];
  
  // Slave30 select30 register
  always @(posedge wb_clk_i30 or posedge wb_rst_i30)
  begin
    if (wb_rst_i30)
      ss <= #Tp30 {`SPI_SS_NB30{1'b0}};
    else if(spi_ss_sel30 && wb_we_i30 && !tip30)
      begin
      `ifdef SPI_SS_NB_830
        if (wb_sel_i30[0])
          ss <= #Tp30 wb_dat_i30[`SPI_SS_NB30-1:0];
      `endif
      `ifdef SPI_SS_NB_1630
        if (wb_sel_i30[0])
          ss[7:0] <= #Tp30 wb_dat_i30[7:0];
        if (wb_sel_i30[1])
          ss[`SPI_SS_NB30-1:8] <= #Tp30 wb_dat_i30[`SPI_SS_NB30-1:8];
      `endif
      `ifdef SPI_SS_NB_2430
        if (wb_sel_i30[0])
          ss[7:0] <= #Tp30 wb_dat_i30[7:0];
        if (wb_sel_i30[1])
          ss[15:8] <= #Tp30 wb_dat_i30[15:8];
        if (wb_sel_i30[2])
          ss[`SPI_SS_NB30-1:16] <= #Tp30 wb_dat_i30[`SPI_SS_NB30-1:16];
      `endif
      `ifdef SPI_SS_NB_3230
        if (wb_sel_i30[0])
          ss[7:0] <= #Tp30 wb_dat_i30[7:0];
        if (wb_sel_i30[1])
          ss[15:8] <= #Tp30 wb_dat_i30[15:8];
        if (wb_sel_i30[2])
          ss[23:16] <= #Tp30 wb_dat_i30[23:16];
        if (wb_sel_i30[3])
          ss[`SPI_SS_NB30-1:24] <= #Tp30 wb_dat_i30[`SPI_SS_NB30-1:24];
      `endif
      end
  end
  
  assign ss_pad_o30 = ~((ss & {`SPI_SS_NB30{tip30 & ass30}}) | (ss & {`SPI_SS_NB30{!ass30}}));
  
  spi_clgen30 clgen30 (.clk_in30(wb_clk_i30), .rst30(wb_rst_i30), .go30(go30), .enable(tip30), .last_clk30(last_bit30),
                   .divider30(divider30), .clk_out30(sclk_pad_o30), .pos_edge30(pos_edge30), 
                   .neg_edge30(neg_edge30));
  
  spi_shift30 shift30 (.clk30(wb_clk_i30), .rst30(wb_rst_i30), .len(char_len30[`SPI_CHAR_LEN_BITS30-1:0]),
                   .latch30(spi_tx_sel30[3:0] & {4{wb_we_i30}}), .byte_sel30(wb_sel_i30), .lsb(lsb), 
                   .go30(go30), .pos_edge30(pos_edge30), .neg_edge30(neg_edge30), 
                   .rx_negedge30(rx_negedge30), .tx_negedge30(tx_negedge30),
                   .tip30(tip30), .last(last_bit30), 
                   .p_in30(wb_dat_i30), .p_out30(rx30), 
                   .s_clk30(sclk_pad_o30), .s_in30(miso_pad_i30), .s_out30(mosi_pad_o30));
endmodule
  
