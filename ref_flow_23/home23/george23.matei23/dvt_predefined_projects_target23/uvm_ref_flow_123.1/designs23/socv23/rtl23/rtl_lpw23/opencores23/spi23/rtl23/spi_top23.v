//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_top23.v                                                   ////
////                                                              ////
////  This23 file is part of the SPI23 IP23 core23 project23                ////
////  http23://www23.opencores23.org23/projects23/spi23/                      ////
////                                                              ////
////  Author23(s):                                                  ////
////      - Simon23 Srot23 (simons23@opencores23.org23)                     ////
////                                                              ////
////  All additional23 information is avaliable23 in the Readme23.txt23   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright23 (C) 2002 Authors23                                   ////
////                                                              ////
//// This23 source23 file may be used and distributed23 without         ////
//// restriction23 provided that this copyright23 statement23 is not    ////
//// removed from the file and that any derivative23 work23 contains23  ////
//// the original copyright23 notice23 and the associated disclaimer23. ////
////                                                              ////
//// This23 source23 file is free software23; you can redistribute23 it   ////
//// and/or modify it under the terms23 of the GNU23 Lesser23 General23   ////
//// Public23 License23 as published23 by the Free23 Software23 Foundation23; ////
//// either23 version23 2.1 of the License23, or (at your23 option) any   ////
//// later23 version23.                                               ////
////                                                              ////
//// This23 source23 is distributed23 in the hope23 that it will be       ////
//// useful23, but WITHOUT23 ANY23 WARRANTY23; without even23 the implied23   ////
//// warranty23 of MERCHANTABILITY23 or FITNESS23 FOR23 A PARTICULAR23      ////
//// PURPOSE23.  See the GNU23 Lesser23 General23 Public23 License23 for more ////
//// details23.                                                     ////
////                                                              ////
//// You should have received23 a copy of the GNU23 Lesser23 General23    ////
//// Public23 License23 along23 with this source23; if not, download23 it   ////
//// from http23://www23.opencores23.org23/lgpl23.shtml23                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////


`include "spi_defines23.v"
`include "timescale.v"

module spi_top23
(
  // Wishbone23 signals23
  wb_clk_i23, wb_rst_i23, wb_adr_i23, wb_dat_i23, wb_dat_o23, wb_sel_i23,
  wb_we_i23, wb_stb_i23, wb_cyc_i23, wb_ack_o23, wb_err_o23, wb_int_o23,

  // SPI23 signals23
  ss_pad_o23, sclk_pad_o23, mosi_pad_o23, miso_pad_i23
);

  parameter Tp23 = 1;

  // Wishbone23 signals23
  input                            wb_clk_i23;         // master23 clock23 input
  input                            wb_rst_i23;         // synchronous23 active high23 reset
  input                      [4:0] wb_adr_i23;         // lower23 address bits
  input                   [32-1:0] wb_dat_i23;         // databus23 input
  output                  [32-1:0] wb_dat_o23;         // databus23 output
  input                      [3:0] wb_sel_i23;         // byte select23 inputs23
  input                            wb_we_i23;          // write enable input
  input                            wb_stb_i23;         // stobe23/core23 select23 signal23
  input                            wb_cyc_i23;         // valid bus cycle input
  output                           wb_ack_o23;         // bus cycle acknowledge23 output
  output                           wb_err_o23;         // termination w/ error
  output                           wb_int_o23;         // interrupt23 request signal23 output
                                                     
  // SPI23 signals23                                     
  output          [`SPI_SS_NB23-1:0] ss_pad_o23;         // slave23 select23
  output                           sclk_pad_o23;       // serial23 clock23
  output                           mosi_pad_o23;       // master23 out slave23 in
  input                            miso_pad_i23;       // master23 in slave23 out
                                                     
  reg                     [32-1:0] wb_dat_o23;
  reg                              wb_ack_o23;
  reg                              wb_int_o23;
                                               
  // Internal signals23
  reg       [`SPI_DIVIDER_LEN23-1:0] divider23;          // Divider23 register
  reg       [`SPI_CTRL_BIT_NB23-1:0] ctrl23;             // Control23 and status register
  reg             [`SPI_SS_NB23-1:0] ss;               // Slave23 select23 register
  reg                     [32-1:0] wb_dat23;           // wb23 data out
  wire         [`SPI_MAX_CHAR23-1:0] rx23;               // Rx23 register
  wire                             rx_negedge23;       // miso23 is sampled23 on negative edge
  wire                             tx_negedge23;       // mosi23 is driven23 on negative edge
  wire    [`SPI_CHAR_LEN_BITS23-1:0] char_len23;         // char23 len
  wire                             go23;               // go23
  wire                             lsb;              // lsb first on line
  wire                             ie23;               // interrupt23 enable
  wire                             ass23;              // automatic slave23 select23
  wire                             spi_divider_sel23;  // divider23 register select23
  wire                             spi_ctrl_sel23;     // ctrl23 register select23
  wire                       [3:0] spi_tx_sel23;       // tx_l23 register select23
  wire                             spi_ss_sel23;       // ss register select23
  wire                             tip23;              // transfer23 in progress23
  wire                             pos_edge23;         // recognize23 posedge of sclk23
  wire                             neg_edge23;         // recognize23 negedge of sclk23
  wire                             last_bit23;         // marks23 last character23 bit
  
  // Address decoder23
  assign spi_divider_sel23 = wb_cyc_i23 & wb_stb_i23 & (wb_adr_i23[`SPI_OFS_BITS23] == `SPI_DEVIDE23);
  assign spi_ctrl_sel23    = wb_cyc_i23 & wb_stb_i23 & (wb_adr_i23[`SPI_OFS_BITS23] == `SPI_CTRL23);
  assign spi_tx_sel23[0]   = wb_cyc_i23 & wb_stb_i23 & (wb_adr_i23[`SPI_OFS_BITS23] == `SPI_TX_023);
  assign spi_tx_sel23[1]   = wb_cyc_i23 & wb_stb_i23 & (wb_adr_i23[`SPI_OFS_BITS23] == `SPI_TX_123);
  assign spi_tx_sel23[2]   = wb_cyc_i23 & wb_stb_i23 & (wb_adr_i23[`SPI_OFS_BITS23] == `SPI_TX_223);
  assign spi_tx_sel23[3]   = wb_cyc_i23 & wb_stb_i23 & (wb_adr_i23[`SPI_OFS_BITS23] == `SPI_TX_323);
  assign spi_ss_sel23      = wb_cyc_i23 & wb_stb_i23 & (wb_adr_i23[`SPI_OFS_BITS23] == `SPI_SS23);
  
  // Read from registers
  always @(wb_adr_i23 or rx23 or ctrl23 or divider23 or ss)
  begin
    case (wb_adr_i23[`SPI_OFS_BITS23])
`ifdef SPI_MAX_CHAR_12823
      `SPI_RX_023:    wb_dat23 = rx23[31:0];
      `SPI_RX_123:    wb_dat23 = rx23[63:32];
      `SPI_RX_223:    wb_dat23 = rx23[95:64];
      `SPI_RX_323:    wb_dat23 = {{128-`SPI_MAX_CHAR23{1'b0}}, rx23[`SPI_MAX_CHAR23-1:96]};
`else
`ifdef SPI_MAX_CHAR_6423
      `SPI_RX_023:    wb_dat23 = rx23[31:0];
      `SPI_RX_123:    wb_dat23 = {{64-`SPI_MAX_CHAR23{1'b0}}, rx23[`SPI_MAX_CHAR23-1:32]};
      `SPI_RX_223:    wb_dat23 = 32'b0;
      `SPI_RX_323:    wb_dat23 = 32'b0;
`else
      `SPI_RX_023:    wb_dat23 = {{32-`SPI_MAX_CHAR23{1'b0}}, rx23[`SPI_MAX_CHAR23-1:0]};
      `SPI_RX_123:    wb_dat23 = 32'b0;
      `SPI_RX_223:    wb_dat23 = 32'b0;
      `SPI_RX_323:    wb_dat23 = 32'b0;
`endif
`endif
      `SPI_CTRL23:    wb_dat23 = {{32-`SPI_CTRL_BIT_NB23{1'b0}}, ctrl23};
      `SPI_DEVIDE23:  wb_dat23 = {{32-`SPI_DIVIDER_LEN23{1'b0}}, divider23};
      `SPI_SS23:      wb_dat23 = {{32-`SPI_SS_NB23{1'b0}}, ss};
      default:      wb_dat23 = 32'bx;
    endcase
  end
  
  // Wb23 data out
  always @(posedge wb_clk_i23 or posedge wb_rst_i23)
  begin
    if (wb_rst_i23)
      wb_dat_o23 <= #Tp23 32'b0;
    else
      wb_dat_o23 <= #Tp23 wb_dat23;
  end
  
  // Wb23 acknowledge23
  always @(posedge wb_clk_i23 or posedge wb_rst_i23)
  begin
    if (wb_rst_i23)
      wb_ack_o23 <= #Tp23 1'b0;
    else
      wb_ack_o23 <= #Tp23 wb_cyc_i23 & wb_stb_i23 & ~wb_ack_o23;
  end
  
  // Wb23 error
  assign wb_err_o23 = 1'b0;
  
  // Interrupt23
  always @(posedge wb_clk_i23 or posedge wb_rst_i23)
  begin
    if (wb_rst_i23)
      wb_int_o23 <= #Tp23 1'b0;
    else if (ie23 && tip23 && last_bit23 && pos_edge23)
      wb_int_o23 <= #Tp23 1'b1;
    else if (wb_ack_o23)
      wb_int_o23 <= #Tp23 1'b0;
  end
  
  // Divider23 register
  always @(posedge wb_clk_i23 or posedge wb_rst_i23)
  begin
    if (wb_rst_i23)
        divider23 <= #Tp23 {`SPI_DIVIDER_LEN23{1'b0}};
    else if (spi_divider_sel23 && wb_we_i23 && !tip23)
      begin
      `ifdef SPI_DIVIDER_LEN_823
        if (wb_sel_i23[0])
          divider23 <= #Tp23 wb_dat_i23[`SPI_DIVIDER_LEN23-1:0];
      `endif
      `ifdef SPI_DIVIDER_LEN_1623
        if (wb_sel_i23[0])
          divider23[7:0] <= #Tp23 wb_dat_i23[7:0];
        if (wb_sel_i23[1])
          divider23[`SPI_DIVIDER_LEN23-1:8] <= #Tp23 wb_dat_i23[`SPI_DIVIDER_LEN23-1:8];
      `endif
      `ifdef SPI_DIVIDER_LEN_2423
        if (wb_sel_i23[0])
          divider23[7:0] <= #Tp23 wb_dat_i23[7:0];
        if (wb_sel_i23[1])
          divider23[15:8] <= #Tp23 wb_dat_i23[15:8];
        if (wb_sel_i23[2])
          divider23[`SPI_DIVIDER_LEN23-1:16] <= #Tp23 wb_dat_i23[`SPI_DIVIDER_LEN23-1:16];
      `endif
      `ifdef SPI_DIVIDER_LEN_3223
        if (wb_sel_i23[0])
          divider23[7:0] <= #Tp23 wb_dat_i23[7:0];
        if (wb_sel_i23[1])
          divider23[15:8] <= #Tp23 wb_dat_i23[15:8];
        if (wb_sel_i23[2])
          divider23[23:16] <= #Tp23 wb_dat_i23[23:16];
        if (wb_sel_i23[3])
          divider23[`SPI_DIVIDER_LEN23-1:24] <= #Tp23 wb_dat_i23[`SPI_DIVIDER_LEN23-1:24];
      `endif
      end
  end
  
  // Ctrl23 register
  always @(posedge wb_clk_i23 or posedge wb_rst_i23)
  begin
    if (wb_rst_i23)
      ctrl23 <= #Tp23 {`SPI_CTRL_BIT_NB23{1'b0}};
    else if(spi_ctrl_sel23 && wb_we_i23 && !tip23)
      begin
        if (wb_sel_i23[0])
          ctrl23[7:0] <= #Tp23 wb_dat_i23[7:0] | {7'b0, ctrl23[0]};
        if (wb_sel_i23[1])
          ctrl23[`SPI_CTRL_BIT_NB23-1:8] <= #Tp23 wb_dat_i23[`SPI_CTRL_BIT_NB23-1:8];
      end
    else if(tip23 && last_bit23 && pos_edge23)
      ctrl23[`SPI_CTRL_GO23] <= #Tp23 1'b0;
  end
  
  assign rx_negedge23 = ctrl23[`SPI_CTRL_RX_NEGEDGE23];
  assign tx_negedge23 = ctrl23[`SPI_CTRL_TX_NEGEDGE23];
  assign go23         = ctrl23[`SPI_CTRL_GO23];
  assign char_len23   = ctrl23[`SPI_CTRL_CHAR_LEN23];
  assign lsb        = ctrl23[`SPI_CTRL_LSB23];
  assign ie23         = ctrl23[`SPI_CTRL_IE23];
  assign ass23        = ctrl23[`SPI_CTRL_ASS23];
  
  // Slave23 select23 register
  always @(posedge wb_clk_i23 or posedge wb_rst_i23)
  begin
    if (wb_rst_i23)
      ss <= #Tp23 {`SPI_SS_NB23{1'b0}};
    else if(spi_ss_sel23 && wb_we_i23 && !tip23)
      begin
      `ifdef SPI_SS_NB_823
        if (wb_sel_i23[0])
          ss <= #Tp23 wb_dat_i23[`SPI_SS_NB23-1:0];
      `endif
      `ifdef SPI_SS_NB_1623
        if (wb_sel_i23[0])
          ss[7:0] <= #Tp23 wb_dat_i23[7:0];
        if (wb_sel_i23[1])
          ss[`SPI_SS_NB23-1:8] <= #Tp23 wb_dat_i23[`SPI_SS_NB23-1:8];
      `endif
      `ifdef SPI_SS_NB_2423
        if (wb_sel_i23[0])
          ss[7:0] <= #Tp23 wb_dat_i23[7:0];
        if (wb_sel_i23[1])
          ss[15:8] <= #Tp23 wb_dat_i23[15:8];
        if (wb_sel_i23[2])
          ss[`SPI_SS_NB23-1:16] <= #Tp23 wb_dat_i23[`SPI_SS_NB23-1:16];
      `endif
      `ifdef SPI_SS_NB_3223
        if (wb_sel_i23[0])
          ss[7:0] <= #Tp23 wb_dat_i23[7:0];
        if (wb_sel_i23[1])
          ss[15:8] <= #Tp23 wb_dat_i23[15:8];
        if (wb_sel_i23[2])
          ss[23:16] <= #Tp23 wb_dat_i23[23:16];
        if (wb_sel_i23[3])
          ss[`SPI_SS_NB23-1:24] <= #Tp23 wb_dat_i23[`SPI_SS_NB23-1:24];
      `endif
      end
  end
  
  assign ss_pad_o23 = ~((ss & {`SPI_SS_NB23{tip23 & ass23}}) | (ss & {`SPI_SS_NB23{!ass23}}));
  
  spi_clgen23 clgen23 (.clk_in23(wb_clk_i23), .rst23(wb_rst_i23), .go23(go23), .enable(tip23), .last_clk23(last_bit23),
                   .divider23(divider23), .clk_out23(sclk_pad_o23), .pos_edge23(pos_edge23), 
                   .neg_edge23(neg_edge23));
  
  spi_shift23 shift23 (.clk23(wb_clk_i23), .rst23(wb_rst_i23), .len(char_len23[`SPI_CHAR_LEN_BITS23-1:0]),
                   .latch23(spi_tx_sel23[3:0] & {4{wb_we_i23}}), .byte_sel23(wb_sel_i23), .lsb(lsb), 
                   .go23(go23), .pos_edge23(pos_edge23), .neg_edge23(neg_edge23), 
                   .rx_negedge23(rx_negedge23), .tx_negedge23(tx_negedge23),
                   .tip23(tip23), .last(last_bit23), 
                   .p_in23(wb_dat_i23), .p_out23(rx23), 
                   .s_clk23(sclk_pad_o23), .s_in23(miso_pad_i23), .s_out23(mosi_pad_o23));
endmodule
  
