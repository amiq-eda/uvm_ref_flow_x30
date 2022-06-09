//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_top12.v                                                   ////
////                                                              ////
////  This12 file is part of the SPI12 IP12 core12 project12                ////
////  http12://www12.opencores12.org12/projects12/spi12/                      ////
////                                                              ////
////  Author12(s):                                                  ////
////      - Simon12 Srot12 (simons12@opencores12.org12)                     ////
////                                                              ////
////  All additional12 information is avaliable12 in the Readme12.txt12   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright12 (C) 2002 Authors12                                   ////
////                                                              ////
//// This12 source12 file may be used and distributed12 without         ////
//// restriction12 provided that this copyright12 statement12 is not    ////
//// removed from the file and that any derivative12 work12 contains12  ////
//// the original copyright12 notice12 and the associated disclaimer12. ////
////                                                              ////
//// This12 source12 file is free software12; you can redistribute12 it   ////
//// and/or modify it under the terms12 of the GNU12 Lesser12 General12   ////
//// Public12 License12 as published12 by the Free12 Software12 Foundation12; ////
//// either12 version12 2.1 of the License12, or (at your12 option) any   ////
//// later12 version12.                                               ////
////                                                              ////
//// This12 source12 is distributed12 in the hope12 that it will be       ////
//// useful12, but WITHOUT12 ANY12 WARRANTY12; without even12 the implied12   ////
//// warranty12 of MERCHANTABILITY12 or FITNESS12 FOR12 A PARTICULAR12      ////
//// PURPOSE12.  See the GNU12 Lesser12 General12 Public12 License12 for more ////
//// details12.                                                     ////
////                                                              ////
//// You should have received12 a copy of the GNU12 Lesser12 General12    ////
//// Public12 License12 along12 with this source12; if not, download12 it   ////
//// from http12://www12.opencores12.org12/lgpl12.shtml12                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////


`include "spi_defines12.v"
`include "timescale.v"

module spi_top12
(
  // Wishbone12 signals12
  wb_clk_i12, wb_rst_i12, wb_adr_i12, wb_dat_i12, wb_dat_o12, wb_sel_i12,
  wb_we_i12, wb_stb_i12, wb_cyc_i12, wb_ack_o12, wb_err_o12, wb_int_o12,

  // SPI12 signals12
  ss_pad_o12, sclk_pad_o12, mosi_pad_o12, miso_pad_i12
);

  parameter Tp12 = 1;

  // Wishbone12 signals12
  input                            wb_clk_i12;         // master12 clock12 input
  input                            wb_rst_i12;         // synchronous12 active high12 reset
  input                      [4:0] wb_adr_i12;         // lower12 address bits
  input                   [32-1:0] wb_dat_i12;         // databus12 input
  output                  [32-1:0] wb_dat_o12;         // databus12 output
  input                      [3:0] wb_sel_i12;         // byte select12 inputs12
  input                            wb_we_i12;          // write enable input
  input                            wb_stb_i12;         // stobe12/core12 select12 signal12
  input                            wb_cyc_i12;         // valid bus cycle input
  output                           wb_ack_o12;         // bus cycle acknowledge12 output
  output                           wb_err_o12;         // termination w/ error
  output                           wb_int_o12;         // interrupt12 request signal12 output
                                                     
  // SPI12 signals12                                     
  output          [`SPI_SS_NB12-1:0] ss_pad_o12;         // slave12 select12
  output                           sclk_pad_o12;       // serial12 clock12
  output                           mosi_pad_o12;       // master12 out slave12 in
  input                            miso_pad_i12;       // master12 in slave12 out
                                                     
  reg                     [32-1:0] wb_dat_o12;
  reg                              wb_ack_o12;
  reg                              wb_int_o12;
                                               
  // Internal signals12
  reg       [`SPI_DIVIDER_LEN12-1:0] divider12;          // Divider12 register
  reg       [`SPI_CTRL_BIT_NB12-1:0] ctrl12;             // Control12 and status register
  reg             [`SPI_SS_NB12-1:0] ss;               // Slave12 select12 register
  reg                     [32-1:0] wb_dat12;           // wb12 data out
  wire         [`SPI_MAX_CHAR12-1:0] rx12;               // Rx12 register
  wire                             rx_negedge12;       // miso12 is sampled12 on negative edge
  wire                             tx_negedge12;       // mosi12 is driven12 on negative edge
  wire    [`SPI_CHAR_LEN_BITS12-1:0] char_len12;         // char12 len
  wire                             go12;               // go12
  wire                             lsb;              // lsb first on line
  wire                             ie12;               // interrupt12 enable
  wire                             ass12;              // automatic slave12 select12
  wire                             spi_divider_sel12;  // divider12 register select12
  wire                             spi_ctrl_sel12;     // ctrl12 register select12
  wire                       [3:0] spi_tx_sel12;       // tx_l12 register select12
  wire                             spi_ss_sel12;       // ss register select12
  wire                             tip12;              // transfer12 in progress12
  wire                             pos_edge12;         // recognize12 posedge of sclk12
  wire                             neg_edge12;         // recognize12 negedge of sclk12
  wire                             last_bit12;         // marks12 last character12 bit
  
  // Address decoder12
  assign spi_divider_sel12 = wb_cyc_i12 & wb_stb_i12 & (wb_adr_i12[`SPI_OFS_BITS12] == `SPI_DEVIDE12);
  assign spi_ctrl_sel12    = wb_cyc_i12 & wb_stb_i12 & (wb_adr_i12[`SPI_OFS_BITS12] == `SPI_CTRL12);
  assign spi_tx_sel12[0]   = wb_cyc_i12 & wb_stb_i12 & (wb_adr_i12[`SPI_OFS_BITS12] == `SPI_TX_012);
  assign spi_tx_sel12[1]   = wb_cyc_i12 & wb_stb_i12 & (wb_adr_i12[`SPI_OFS_BITS12] == `SPI_TX_112);
  assign spi_tx_sel12[2]   = wb_cyc_i12 & wb_stb_i12 & (wb_adr_i12[`SPI_OFS_BITS12] == `SPI_TX_212);
  assign spi_tx_sel12[3]   = wb_cyc_i12 & wb_stb_i12 & (wb_adr_i12[`SPI_OFS_BITS12] == `SPI_TX_312);
  assign spi_ss_sel12      = wb_cyc_i12 & wb_stb_i12 & (wb_adr_i12[`SPI_OFS_BITS12] == `SPI_SS12);
  
  // Read from registers
  always @(wb_adr_i12 or rx12 or ctrl12 or divider12 or ss)
  begin
    case (wb_adr_i12[`SPI_OFS_BITS12])
`ifdef SPI_MAX_CHAR_12812
      `SPI_RX_012:    wb_dat12 = rx12[31:0];
      `SPI_RX_112:    wb_dat12 = rx12[63:32];
      `SPI_RX_212:    wb_dat12 = rx12[95:64];
      `SPI_RX_312:    wb_dat12 = {{128-`SPI_MAX_CHAR12{1'b0}}, rx12[`SPI_MAX_CHAR12-1:96]};
`else
`ifdef SPI_MAX_CHAR_6412
      `SPI_RX_012:    wb_dat12 = rx12[31:0];
      `SPI_RX_112:    wb_dat12 = {{64-`SPI_MAX_CHAR12{1'b0}}, rx12[`SPI_MAX_CHAR12-1:32]};
      `SPI_RX_212:    wb_dat12 = 32'b0;
      `SPI_RX_312:    wb_dat12 = 32'b0;
`else
      `SPI_RX_012:    wb_dat12 = {{32-`SPI_MAX_CHAR12{1'b0}}, rx12[`SPI_MAX_CHAR12-1:0]};
      `SPI_RX_112:    wb_dat12 = 32'b0;
      `SPI_RX_212:    wb_dat12 = 32'b0;
      `SPI_RX_312:    wb_dat12 = 32'b0;
`endif
`endif
      `SPI_CTRL12:    wb_dat12 = {{32-`SPI_CTRL_BIT_NB12{1'b0}}, ctrl12};
      `SPI_DEVIDE12:  wb_dat12 = {{32-`SPI_DIVIDER_LEN12{1'b0}}, divider12};
      `SPI_SS12:      wb_dat12 = {{32-`SPI_SS_NB12{1'b0}}, ss};
      default:      wb_dat12 = 32'bx;
    endcase
  end
  
  // Wb12 data out
  always @(posedge wb_clk_i12 or posedge wb_rst_i12)
  begin
    if (wb_rst_i12)
      wb_dat_o12 <= #Tp12 32'b0;
    else
      wb_dat_o12 <= #Tp12 wb_dat12;
  end
  
  // Wb12 acknowledge12
  always @(posedge wb_clk_i12 or posedge wb_rst_i12)
  begin
    if (wb_rst_i12)
      wb_ack_o12 <= #Tp12 1'b0;
    else
      wb_ack_o12 <= #Tp12 wb_cyc_i12 & wb_stb_i12 & ~wb_ack_o12;
  end
  
  // Wb12 error
  assign wb_err_o12 = 1'b0;
  
  // Interrupt12
  always @(posedge wb_clk_i12 or posedge wb_rst_i12)
  begin
    if (wb_rst_i12)
      wb_int_o12 <= #Tp12 1'b0;
    else if (ie12 && tip12 && last_bit12 && pos_edge12)
      wb_int_o12 <= #Tp12 1'b1;
    else if (wb_ack_o12)
      wb_int_o12 <= #Tp12 1'b0;
  end
  
  // Divider12 register
  always @(posedge wb_clk_i12 or posedge wb_rst_i12)
  begin
    if (wb_rst_i12)
        divider12 <= #Tp12 {`SPI_DIVIDER_LEN12{1'b0}};
    else if (spi_divider_sel12 && wb_we_i12 && !tip12)
      begin
      `ifdef SPI_DIVIDER_LEN_812
        if (wb_sel_i12[0])
          divider12 <= #Tp12 wb_dat_i12[`SPI_DIVIDER_LEN12-1:0];
      `endif
      `ifdef SPI_DIVIDER_LEN_1612
        if (wb_sel_i12[0])
          divider12[7:0] <= #Tp12 wb_dat_i12[7:0];
        if (wb_sel_i12[1])
          divider12[`SPI_DIVIDER_LEN12-1:8] <= #Tp12 wb_dat_i12[`SPI_DIVIDER_LEN12-1:8];
      `endif
      `ifdef SPI_DIVIDER_LEN_2412
        if (wb_sel_i12[0])
          divider12[7:0] <= #Tp12 wb_dat_i12[7:0];
        if (wb_sel_i12[1])
          divider12[15:8] <= #Tp12 wb_dat_i12[15:8];
        if (wb_sel_i12[2])
          divider12[`SPI_DIVIDER_LEN12-1:16] <= #Tp12 wb_dat_i12[`SPI_DIVIDER_LEN12-1:16];
      `endif
      `ifdef SPI_DIVIDER_LEN_3212
        if (wb_sel_i12[0])
          divider12[7:0] <= #Tp12 wb_dat_i12[7:0];
        if (wb_sel_i12[1])
          divider12[15:8] <= #Tp12 wb_dat_i12[15:8];
        if (wb_sel_i12[2])
          divider12[23:16] <= #Tp12 wb_dat_i12[23:16];
        if (wb_sel_i12[3])
          divider12[`SPI_DIVIDER_LEN12-1:24] <= #Tp12 wb_dat_i12[`SPI_DIVIDER_LEN12-1:24];
      `endif
      end
  end
  
  // Ctrl12 register
  always @(posedge wb_clk_i12 or posedge wb_rst_i12)
  begin
    if (wb_rst_i12)
      ctrl12 <= #Tp12 {`SPI_CTRL_BIT_NB12{1'b0}};
    else if(spi_ctrl_sel12 && wb_we_i12 && !tip12)
      begin
        if (wb_sel_i12[0])
          ctrl12[7:0] <= #Tp12 wb_dat_i12[7:0] | {7'b0, ctrl12[0]};
        if (wb_sel_i12[1])
          ctrl12[`SPI_CTRL_BIT_NB12-1:8] <= #Tp12 wb_dat_i12[`SPI_CTRL_BIT_NB12-1:8];
      end
    else if(tip12 && last_bit12 && pos_edge12)
      ctrl12[`SPI_CTRL_GO12] <= #Tp12 1'b0;
  end
  
  assign rx_negedge12 = ctrl12[`SPI_CTRL_RX_NEGEDGE12];
  assign tx_negedge12 = ctrl12[`SPI_CTRL_TX_NEGEDGE12];
  assign go12         = ctrl12[`SPI_CTRL_GO12];
  assign char_len12   = ctrl12[`SPI_CTRL_CHAR_LEN12];
  assign lsb        = ctrl12[`SPI_CTRL_LSB12];
  assign ie12         = ctrl12[`SPI_CTRL_IE12];
  assign ass12        = ctrl12[`SPI_CTRL_ASS12];
  
  // Slave12 select12 register
  always @(posedge wb_clk_i12 or posedge wb_rst_i12)
  begin
    if (wb_rst_i12)
      ss <= #Tp12 {`SPI_SS_NB12{1'b0}};
    else if(spi_ss_sel12 && wb_we_i12 && !tip12)
      begin
      `ifdef SPI_SS_NB_812
        if (wb_sel_i12[0])
          ss <= #Tp12 wb_dat_i12[`SPI_SS_NB12-1:0];
      `endif
      `ifdef SPI_SS_NB_1612
        if (wb_sel_i12[0])
          ss[7:0] <= #Tp12 wb_dat_i12[7:0];
        if (wb_sel_i12[1])
          ss[`SPI_SS_NB12-1:8] <= #Tp12 wb_dat_i12[`SPI_SS_NB12-1:8];
      `endif
      `ifdef SPI_SS_NB_2412
        if (wb_sel_i12[0])
          ss[7:0] <= #Tp12 wb_dat_i12[7:0];
        if (wb_sel_i12[1])
          ss[15:8] <= #Tp12 wb_dat_i12[15:8];
        if (wb_sel_i12[2])
          ss[`SPI_SS_NB12-1:16] <= #Tp12 wb_dat_i12[`SPI_SS_NB12-1:16];
      `endif
      `ifdef SPI_SS_NB_3212
        if (wb_sel_i12[0])
          ss[7:0] <= #Tp12 wb_dat_i12[7:0];
        if (wb_sel_i12[1])
          ss[15:8] <= #Tp12 wb_dat_i12[15:8];
        if (wb_sel_i12[2])
          ss[23:16] <= #Tp12 wb_dat_i12[23:16];
        if (wb_sel_i12[3])
          ss[`SPI_SS_NB12-1:24] <= #Tp12 wb_dat_i12[`SPI_SS_NB12-1:24];
      `endif
      end
  end
  
  assign ss_pad_o12 = ~((ss & {`SPI_SS_NB12{tip12 & ass12}}) | (ss & {`SPI_SS_NB12{!ass12}}));
  
  spi_clgen12 clgen12 (.clk_in12(wb_clk_i12), .rst12(wb_rst_i12), .go12(go12), .enable(tip12), .last_clk12(last_bit12),
                   .divider12(divider12), .clk_out12(sclk_pad_o12), .pos_edge12(pos_edge12), 
                   .neg_edge12(neg_edge12));
  
  spi_shift12 shift12 (.clk12(wb_clk_i12), .rst12(wb_rst_i12), .len(char_len12[`SPI_CHAR_LEN_BITS12-1:0]),
                   .latch12(spi_tx_sel12[3:0] & {4{wb_we_i12}}), .byte_sel12(wb_sel_i12), .lsb(lsb), 
                   .go12(go12), .pos_edge12(pos_edge12), .neg_edge12(neg_edge12), 
                   .rx_negedge12(rx_negedge12), .tx_negedge12(tx_negedge12),
                   .tip12(tip12), .last(last_bit12), 
                   .p_in12(wb_dat_i12), .p_out12(rx12), 
                   .s_clk12(sclk_pad_o12), .s_in12(miso_pad_i12), .s_out12(mosi_pad_o12));
endmodule
  
