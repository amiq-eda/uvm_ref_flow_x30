//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_top9.v                                                   ////
////                                                              ////
////  This9 file is part of the SPI9 IP9 core9 project9                ////
////  http9://www9.opencores9.org9/projects9/spi9/                      ////
////                                                              ////
////  Author9(s):                                                  ////
////      - Simon9 Srot9 (simons9@opencores9.org9)                     ////
////                                                              ////
////  All additional9 information is avaliable9 in the Readme9.txt9   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright9 (C) 2002 Authors9                                   ////
////                                                              ////
//// This9 source9 file may be used and distributed9 without         ////
//// restriction9 provided that this copyright9 statement9 is not    ////
//// removed from the file and that any derivative9 work9 contains9  ////
//// the original copyright9 notice9 and the associated disclaimer9. ////
////                                                              ////
//// This9 source9 file is free software9; you can redistribute9 it   ////
//// and/or modify it under the terms9 of the GNU9 Lesser9 General9   ////
//// Public9 License9 as published9 by the Free9 Software9 Foundation9; ////
//// either9 version9 2.1 of the License9, or (at your9 option) any   ////
//// later9 version9.                                               ////
////                                                              ////
//// This9 source9 is distributed9 in the hope9 that it will be       ////
//// useful9, but WITHOUT9 ANY9 WARRANTY9; without even9 the implied9   ////
//// warranty9 of MERCHANTABILITY9 or FITNESS9 FOR9 A PARTICULAR9      ////
//// PURPOSE9.  See the GNU9 Lesser9 General9 Public9 License9 for more ////
//// details9.                                                     ////
////                                                              ////
//// You should have received9 a copy of the GNU9 Lesser9 General9    ////
//// Public9 License9 along9 with this source9; if not, download9 it   ////
//// from http9://www9.opencores9.org9/lgpl9.shtml9                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////


`include "spi_defines9.v"
`include "timescale.v"

module spi_top9
(
  // Wishbone9 signals9
  wb_clk_i9, wb_rst_i9, wb_adr_i9, wb_dat_i9, wb_dat_o9, wb_sel_i9,
  wb_we_i9, wb_stb_i9, wb_cyc_i9, wb_ack_o9, wb_err_o9, wb_int_o9,

  // SPI9 signals9
  ss_pad_o9, sclk_pad_o9, mosi_pad_o9, miso_pad_i9
);

  parameter Tp9 = 1;

  // Wishbone9 signals9
  input                            wb_clk_i9;         // master9 clock9 input
  input                            wb_rst_i9;         // synchronous9 active high9 reset
  input                      [4:0] wb_adr_i9;         // lower9 address bits
  input                   [32-1:0] wb_dat_i9;         // databus9 input
  output                  [32-1:0] wb_dat_o9;         // databus9 output
  input                      [3:0] wb_sel_i9;         // byte select9 inputs9
  input                            wb_we_i9;          // write enable input
  input                            wb_stb_i9;         // stobe9/core9 select9 signal9
  input                            wb_cyc_i9;         // valid bus cycle input
  output                           wb_ack_o9;         // bus cycle acknowledge9 output
  output                           wb_err_o9;         // termination w/ error
  output                           wb_int_o9;         // interrupt9 request signal9 output
                                                     
  // SPI9 signals9                                     
  output          [`SPI_SS_NB9-1:0] ss_pad_o9;         // slave9 select9
  output                           sclk_pad_o9;       // serial9 clock9
  output                           mosi_pad_o9;       // master9 out slave9 in
  input                            miso_pad_i9;       // master9 in slave9 out
                                                     
  reg                     [32-1:0] wb_dat_o9;
  reg                              wb_ack_o9;
  reg                              wb_int_o9;
                                               
  // Internal signals9
  reg       [`SPI_DIVIDER_LEN9-1:0] divider9;          // Divider9 register
  reg       [`SPI_CTRL_BIT_NB9-1:0] ctrl9;             // Control9 and status register
  reg             [`SPI_SS_NB9-1:0] ss;               // Slave9 select9 register
  reg                     [32-1:0] wb_dat9;           // wb9 data out
  wire         [`SPI_MAX_CHAR9-1:0] rx9;               // Rx9 register
  wire                             rx_negedge9;       // miso9 is sampled9 on negative edge
  wire                             tx_negedge9;       // mosi9 is driven9 on negative edge
  wire    [`SPI_CHAR_LEN_BITS9-1:0] char_len9;         // char9 len
  wire                             go9;               // go9
  wire                             lsb;              // lsb first on line
  wire                             ie9;               // interrupt9 enable
  wire                             ass9;              // automatic slave9 select9
  wire                             spi_divider_sel9;  // divider9 register select9
  wire                             spi_ctrl_sel9;     // ctrl9 register select9
  wire                       [3:0] spi_tx_sel9;       // tx_l9 register select9
  wire                             spi_ss_sel9;       // ss register select9
  wire                             tip9;              // transfer9 in progress9
  wire                             pos_edge9;         // recognize9 posedge of sclk9
  wire                             neg_edge9;         // recognize9 negedge of sclk9
  wire                             last_bit9;         // marks9 last character9 bit
  
  // Address decoder9
  assign spi_divider_sel9 = wb_cyc_i9 & wb_stb_i9 & (wb_adr_i9[`SPI_OFS_BITS9] == `SPI_DEVIDE9);
  assign spi_ctrl_sel9    = wb_cyc_i9 & wb_stb_i9 & (wb_adr_i9[`SPI_OFS_BITS9] == `SPI_CTRL9);
  assign spi_tx_sel9[0]   = wb_cyc_i9 & wb_stb_i9 & (wb_adr_i9[`SPI_OFS_BITS9] == `SPI_TX_09);
  assign spi_tx_sel9[1]   = wb_cyc_i9 & wb_stb_i9 & (wb_adr_i9[`SPI_OFS_BITS9] == `SPI_TX_19);
  assign spi_tx_sel9[2]   = wb_cyc_i9 & wb_stb_i9 & (wb_adr_i9[`SPI_OFS_BITS9] == `SPI_TX_29);
  assign spi_tx_sel9[3]   = wb_cyc_i9 & wb_stb_i9 & (wb_adr_i9[`SPI_OFS_BITS9] == `SPI_TX_39);
  assign spi_ss_sel9      = wb_cyc_i9 & wb_stb_i9 & (wb_adr_i9[`SPI_OFS_BITS9] == `SPI_SS9);
  
  // Read from registers
  always @(wb_adr_i9 or rx9 or ctrl9 or divider9 or ss)
  begin
    case (wb_adr_i9[`SPI_OFS_BITS9])
`ifdef SPI_MAX_CHAR_1289
      `SPI_RX_09:    wb_dat9 = rx9[31:0];
      `SPI_RX_19:    wb_dat9 = rx9[63:32];
      `SPI_RX_29:    wb_dat9 = rx9[95:64];
      `SPI_RX_39:    wb_dat9 = {{128-`SPI_MAX_CHAR9{1'b0}}, rx9[`SPI_MAX_CHAR9-1:96]};
`else
`ifdef SPI_MAX_CHAR_649
      `SPI_RX_09:    wb_dat9 = rx9[31:0];
      `SPI_RX_19:    wb_dat9 = {{64-`SPI_MAX_CHAR9{1'b0}}, rx9[`SPI_MAX_CHAR9-1:32]};
      `SPI_RX_29:    wb_dat9 = 32'b0;
      `SPI_RX_39:    wb_dat9 = 32'b0;
`else
      `SPI_RX_09:    wb_dat9 = {{32-`SPI_MAX_CHAR9{1'b0}}, rx9[`SPI_MAX_CHAR9-1:0]};
      `SPI_RX_19:    wb_dat9 = 32'b0;
      `SPI_RX_29:    wb_dat9 = 32'b0;
      `SPI_RX_39:    wb_dat9 = 32'b0;
`endif
`endif
      `SPI_CTRL9:    wb_dat9 = {{32-`SPI_CTRL_BIT_NB9{1'b0}}, ctrl9};
      `SPI_DEVIDE9:  wb_dat9 = {{32-`SPI_DIVIDER_LEN9{1'b0}}, divider9};
      `SPI_SS9:      wb_dat9 = {{32-`SPI_SS_NB9{1'b0}}, ss};
      default:      wb_dat9 = 32'bx;
    endcase
  end
  
  // Wb9 data out
  always @(posedge wb_clk_i9 or posedge wb_rst_i9)
  begin
    if (wb_rst_i9)
      wb_dat_o9 <= #Tp9 32'b0;
    else
      wb_dat_o9 <= #Tp9 wb_dat9;
  end
  
  // Wb9 acknowledge9
  always @(posedge wb_clk_i9 or posedge wb_rst_i9)
  begin
    if (wb_rst_i9)
      wb_ack_o9 <= #Tp9 1'b0;
    else
      wb_ack_o9 <= #Tp9 wb_cyc_i9 & wb_stb_i9 & ~wb_ack_o9;
  end
  
  // Wb9 error
  assign wb_err_o9 = 1'b0;
  
  // Interrupt9
  always @(posedge wb_clk_i9 or posedge wb_rst_i9)
  begin
    if (wb_rst_i9)
      wb_int_o9 <= #Tp9 1'b0;
    else if (ie9 && tip9 && last_bit9 && pos_edge9)
      wb_int_o9 <= #Tp9 1'b1;
    else if (wb_ack_o9)
      wb_int_o9 <= #Tp9 1'b0;
  end
  
  // Divider9 register
  always @(posedge wb_clk_i9 or posedge wb_rst_i9)
  begin
    if (wb_rst_i9)
        divider9 <= #Tp9 {`SPI_DIVIDER_LEN9{1'b0}};
    else if (spi_divider_sel9 && wb_we_i9 && !tip9)
      begin
      `ifdef SPI_DIVIDER_LEN_89
        if (wb_sel_i9[0])
          divider9 <= #Tp9 wb_dat_i9[`SPI_DIVIDER_LEN9-1:0];
      `endif
      `ifdef SPI_DIVIDER_LEN_169
        if (wb_sel_i9[0])
          divider9[7:0] <= #Tp9 wb_dat_i9[7:0];
        if (wb_sel_i9[1])
          divider9[`SPI_DIVIDER_LEN9-1:8] <= #Tp9 wb_dat_i9[`SPI_DIVIDER_LEN9-1:8];
      `endif
      `ifdef SPI_DIVIDER_LEN_249
        if (wb_sel_i9[0])
          divider9[7:0] <= #Tp9 wb_dat_i9[7:0];
        if (wb_sel_i9[1])
          divider9[15:8] <= #Tp9 wb_dat_i9[15:8];
        if (wb_sel_i9[2])
          divider9[`SPI_DIVIDER_LEN9-1:16] <= #Tp9 wb_dat_i9[`SPI_DIVIDER_LEN9-1:16];
      `endif
      `ifdef SPI_DIVIDER_LEN_329
        if (wb_sel_i9[0])
          divider9[7:0] <= #Tp9 wb_dat_i9[7:0];
        if (wb_sel_i9[1])
          divider9[15:8] <= #Tp9 wb_dat_i9[15:8];
        if (wb_sel_i9[2])
          divider9[23:16] <= #Tp9 wb_dat_i9[23:16];
        if (wb_sel_i9[3])
          divider9[`SPI_DIVIDER_LEN9-1:24] <= #Tp9 wb_dat_i9[`SPI_DIVIDER_LEN9-1:24];
      `endif
      end
  end
  
  // Ctrl9 register
  always @(posedge wb_clk_i9 or posedge wb_rst_i9)
  begin
    if (wb_rst_i9)
      ctrl9 <= #Tp9 {`SPI_CTRL_BIT_NB9{1'b0}};
    else if(spi_ctrl_sel9 && wb_we_i9 && !tip9)
      begin
        if (wb_sel_i9[0])
          ctrl9[7:0] <= #Tp9 wb_dat_i9[7:0] | {7'b0, ctrl9[0]};
        if (wb_sel_i9[1])
          ctrl9[`SPI_CTRL_BIT_NB9-1:8] <= #Tp9 wb_dat_i9[`SPI_CTRL_BIT_NB9-1:8];
      end
    else if(tip9 && last_bit9 && pos_edge9)
      ctrl9[`SPI_CTRL_GO9] <= #Tp9 1'b0;
  end
  
  assign rx_negedge9 = ctrl9[`SPI_CTRL_RX_NEGEDGE9];
  assign tx_negedge9 = ctrl9[`SPI_CTRL_TX_NEGEDGE9];
  assign go9         = ctrl9[`SPI_CTRL_GO9];
  assign char_len9   = ctrl9[`SPI_CTRL_CHAR_LEN9];
  assign lsb        = ctrl9[`SPI_CTRL_LSB9];
  assign ie9         = ctrl9[`SPI_CTRL_IE9];
  assign ass9        = ctrl9[`SPI_CTRL_ASS9];
  
  // Slave9 select9 register
  always @(posedge wb_clk_i9 or posedge wb_rst_i9)
  begin
    if (wb_rst_i9)
      ss <= #Tp9 {`SPI_SS_NB9{1'b0}};
    else if(spi_ss_sel9 && wb_we_i9 && !tip9)
      begin
      `ifdef SPI_SS_NB_89
        if (wb_sel_i9[0])
          ss <= #Tp9 wb_dat_i9[`SPI_SS_NB9-1:0];
      `endif
      `ifdef SPI_SS_NB_169
        if (wb_sel_i9[0])
          ss[7:0] <= #Tp9 wb_dat_i9[7:0];
        if (wb_sel_i9[1])
          ss[`SPI_SS_NB9-1:8] <= #Tp9 wb_dat_i9[`SPI_SS_NB9-1:8];
      `endif
      `ifdef SPI_SS_NB_249
        if (wb_sel_i9[0])
          ss[7:0] <= #Tp9 wb_dat_i9[7:0];
        if (wb_sel_i9[1])
          ss[15:8] <= #Tp9 wb_dat_i9[15:8];
        if (wb_sel_i9[2])
          ss[`SPI_SS_NB9-1:16] <= #Tp9 wb_dat_i9[`SPI_SS_NB9-1:16];
      `endif
      `ifdef SPI_SS_NB_329
        if (wb_sel_i9[0])
          ss[7:0] <= #Tp9 wb_dat_i9[7:0];
        if (wb_sel_i9[1])
          ss[15:8] <= #Tp9 wb_dat_i9[15:8];
        if (wb_sel_i9[2])
          ss[23:16] <= #Tp9 wb_dat_i9[23:16];
        if (wb_sel_i9[3])
          ss[`SPI_SS_NB9-1:24] <= #Tp9 wb_dat_i9[`SPI_SS_NB9-1:24];
      `endif
      end
  end
  
  assign ss_pad_o9 = ~((ss & {`SPI_SS_NB9{tip9 & ass9}}) | (ss & {`SPI_SS_NB9{!ass9}}));
  
  spi_clgen9 clgen9 (.clk_in9(wb_clk_i9), .rst9(wb_rst_i9), .go9(go9), .enable(tip9), .last_clk9(last_bit9),
                   .divider9(divider9), .clk_out9(sclk_pad_o9), .pos_edge9(pos_edge9), 
                   .neg_edge9(neg_edge9));
  
  spi_shift9 shift9 (.clk9(wb_clk_i9), .rst9(wb_rst_i9), .len(char_len9[`SPI_CHAR_LEN_BITS9-1:0]),
                   .latch9(spi_tx_sel9[3:0] & {4{wb_we_i9}}), .byte_sel9(wb_sel_i9), .lsb(lsb), 
                   .go9(go9), .pos_edge9(pos_edge9), .neg_edge9(neg_edge9), 
                   .rx_negedge9(rx_negedge9), .tx_negedge9(tx_negedge9),
                   .tip9(tip9), .last(last_bit9), 
                   .p_in9(wb_dat_i9), .p_out9(rx9), 
                   .s_clk9(sclk_pad_o9), .s_in9(miso_pad_i9), .s_out9(mosi_pad_o9));
endmodule
  
