//File10 name   : ahb2apb10.v
//Title10       : 
//Created10     : 2010
//Description10 : Simple10 AHB10 to APB10 bridge10
//Notes10       : 
//----------------------------------------------------------------------
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------

`timescale 1ns/1ps

`include "ahb2apb_defines10.v"

module ahb2apb10
(
  // AHB10 signals10
  hclk10,
  hreset_n10,
  hsel10,
  haddr10,
  htrans10,
  hwdata10,
  hwrite10,
  hrdata10,
  hready10,
  hresp10,
  
  // APB10 signals10 common to all APB10 slaves10
  pclk10,
  preset_n10,
  paddr10,
  penable10,
  pwrite10,
  pwdata10
  
  // Slave10 0 signals10
  `ifdef APB_SLAVE010
  ,psel010
  ,pready010
  ,prdata010
  `endif
  
  // Slave10 1 signals10
  `ifdef APB_SLAVE110
  ,psel110
  ,pready110
  ,prdata110
  `endif
  
  // Slave10 2 signals10
  `ifdef APB_SLAVE210
  ,psel210
  ,pready210
  ,prdata210
  `endif
  
  // Slave10 3 signals10
  `ifdef APB_SLAVE310
  ,psel310
  ,pready310
  ,prdata310
  `endif
  
  // Slave10 4 signals10
  `ifdef APB_SLAVE410
  ,psel410
  ,pready410
  ,prdata410
  `endif
  
  // Slave10 5 signals10
  `ifdef APB_SLAVE510
  ,psel510
  ,pready510
  ,prdata510
  `endif
  
  // Slave10 6 signals10
  `ifdef APB_SLAVE610
  ,psel610
  ,pready610
  ,prdata610
  `endif
  
  // Slave10 7 signals10
  `ifdef APB_SLAVE710
  ,psel710
  ,pready710
  ,prdata710
  `endif
  
  // Slave10 8 signals10
  `ifdef APB_SLAVE810
  ,psel810
  ,pready810
  ,prdata810
  `endif
  
  // Slave10 9 signals10
  `ifdef APB_SLAVE910
  ,psel910
  ,pready910
  ,prdata910
  `endif
  
  // Slave10 10 signals10
  `ifdef APB_SLAVE1010
  ,psel1010
  ,pready1010
  ,prdata1010
  `endif
  
  // Slave10 11 signals10
  `ifdef APB_SLAVE1110
  ,psel1110
  ,pready1110
  ,prdata1110
  `endif
  
  // Slave10 12 signals10
  `ifdef APB_SLAVE1210
  ,psel1210
  ,pready1210
  ,prdata1210
  `endif
  
  // Slave10 13 signals10
  `ifdef APB_SLAVE1310
  ,psel1310
  ,pready1310
  ,prdata1310
  `endif
  
  // Slave10 14 signals10
  `ifdef APB_SLAVE1410
  ,psel1410
  ,pready1410
  ,prdata1410
  `endif
  
  // Slave10 15 signals10
  `ifdef APB_SLAVE1510
  ,psel1510
  ,pready1510
  ,prdata1510
  `endif
  
);

parameter 
  APB_SLAVE0_START_ADDR10  = 32'h00000000,
  APB_SLAVE0_END_ADDR10    = 32'h00000000,
  APB_SLAVE1_START_ADDR10  = 32'h00000000,
  APB_SLAVE1_END_ADDR10    = 32'h00000000,
  APB_SLAVE2_START_ADDR10  = 32'h00000000,
  APB_SLAVE2_END_ADDR10    = 32'h00000000,
  APB_SLAVE3_START_ADDR10  = 32'h00000000,
  APB_SLAVE3_END_ADDR10    = 32'h00000000,
  APB_SLAVE4_START_ADDR10  = 32'h00000000,
  APB_SLAVE4_END_ADDR10    = 32'h00000000,
  APB_SLAVE5_START_ADDR10  = 32'h00000000,
  APB_SLAVE5_END_ADDR10    = 32'h00000000,
  APB_SLAVE6_START_ADDR10  = 32'h00000000,
  APB_SLAVE6_END_ADDR10    = 32'h00000000,
  APB_SLAVE7_START_ADDR10  = 32'h00000000,
  APB_SLAVE7_END_ADDR10    = 32'h00000000,
  APB_SLAVE8_START_ADDR10  = 32'h00000000,
  APB_SLAVE8_END_ADDR10    = 32'h00000000,
  APB_SLAVE9_START_ADDR10  = 32'h00000000,
  APB_SLAVE9_END_ADDR10    = 32'h00000000,
  APB_SLAVE10_START_ADDR10  = 32'h00000000,
  APB_SLAVE10_END_ADDR10    = 32'h00000000,
  APB_SLAVE11_START_ADDR10  = 32'h00000000,
  APB_SLAVE11_END_ADDR10    = 32'h00000000,
  APB_SLAVE12_START_ADDR10  = 32'h00000000,
  APB_SLAVE12_END_ADDR10    = 32'h00000000,
  APB_SLAVE13_START_ADDR10  = 32'h00000000,
  APB_SLAVE13_END_ADDR10    = 32'h00000000,
  APB_SLAVE14_START_ADDR10  = 32'h00000000,
  APB_SLAVE14_END_ADDR10    = 32'h00000000,
  APB_SLAVE15_START_ADDR10  = 32'h00000000,
  APB_SLAVE15_END_ADDR10    = 32'h00000000;

  // AHB10 signals10
input        hclk10;
input        hreset_n10;
input        hsel10;
input[31:0]  haddr10;
input[1:0]   htrans10;
input[31:0]  hwdata10;
input        hwrite10;
output[31:0] hrdata10;
reg   [31:0] hrdata10;
output       hready10;
output[1:0]  hresp10;
  
  // APB10 signals10 common to all APB10 slaves10
input       pclk10;
input       preset_n10;
output[31:0] paddr10;
reg   [31:0] paddr10;
output       penable10;
reg          penable10;
output       pwrite10;
reg          pwrite10;
output[31:0] pwdata10;
  
  // Slave10 0 signals10
`ifdef APB_SLAVE010
  output      psel010;
  input       pready010;
  input[31:0] prdata010;
`endif
  
  // Slave10 1 signals10
`ifdef APB_SLAVE110
  output      psel110;
  input       pready110;
  input[31:0] prdata110;
`endif
  
  // Slave10 2 signals10
`ifdef APB_SLAVE210
  output      psel210;
  input       pready210;
  input[31:0] prdata210;
`endif
  
  // Slave10 3 signals10
`ifdef APB_SLAVE310
  output      psel310;
  input       pready310;
  input[31:0] prdata310;
`endif
  
  // Slave10 4 signals10
`ifdef APB_SLAVE410
  output      psel410;
  input       pready410;
  input[31:0] prdata410;
`endif
  
  // Slave10 5 signals10
`ifdef APB_SLAVE510
  output      psel510;
  input       pready510;
  input[31:0] prdata510;
`endif
  
  // Slave10 6 signals10
`ifdef APB_SLAVE610
  output      psel610;
  input       pready610;
  input[31:0] prdata610;
`endif
  
  // Slave10 7 signals10
`ifdef APB_SLAVE710
  output      psel710;
  input       pready710;
  input[31:0] prdata710;
`endif
  
  // Slave10 8 signals10
`ifdef APB_SLAVE810
  output      psel810;
  input       pready810;
  input[31:0] prdata810;
`endif
  
  // Slave10 9 signals10
`ifdef APB_SLAVE910
  output      psel910;
  input       pready910;
  input[31:0] prdata910;
`endif
  
  // Slave10 10 signals10
`ifdef APB_SLAVE1010
  output      psel1010;
  input       pready1010;
  input[31:0] prdata1010;
`endif
  
  // Slave10 11 signals10
`ifdef APB_SLAVE1110
  output      psel1110;
  input       pready1110;
  input[31:0] prdata1110;
`endif
  
  // Slave10 12 signals10
`ifdef APB_SLAVE1210
  output      psel1210;
  input       pready1210;
  input[31:0] prdata1210;
`endif
  
  // Slave10 13 signals10
`ifdef APB_SLAVE1310
  output      psel1310;
  input       pready1310;
  input[31:0] prdata1310;
`endif
  
  // Slave10 14 signals10
`ifdef APB_SLAVE1410
  output      psel1410;
  input       pready1410;
  input[31:0] prdata1410;
`endif
  
  // Slave10 15 signals10
`ifdef APB_SLAVE1510
  output      psel1510;
  input       pready1510;
  input[31:0] prdata1510;
`endif
 
reg         ahb_addr_phase10;
reg         ahb_data_phase10;
wire        valid_ahb_trans10;
wire        pready_muxed10;
wire [31:0] prdata_muxed10;
reg  [31:0] haddr_reg10;
reg         hwrite_reg10;
reg  [2:0]  apb_state10;
wire [2:0]  apb_state_idle10;
wire [2:0]  apb_state_setup10;
wire [2:0]  apb_state_access10;
reg  [15:0] slave_select10;
wire [15:0] pready_vector10;
reg  [15:0] psel_vector10;
wire [31:0] prdata0_q10;
wire [31:0] prdata1_q10;
wire [31:0] prdata2_q10;
wire [31:0] prdata3_q10;
wire [31:0] prdata4_q10;
wire [31:0] prdata5_q10;
wire [31:0] prdata6_q10;
wire [31:0] prdata7_q10;
wire [31:0] prdata8_q10;
wire [31:0] prdata9_q10;
wire [31:0] prdata10_q10;
wire [31:0] prdata11_q10;
wire [31:0] prdata12_q10;
wire [31:0] prdata13_q10;
wire [31:0] prdata14_q10;
wire [31:0] prdata15_q10;

// assign pclk10     = hclk10;
// assign preset_n10 = hreset_n10;
assign hready10   = ahb_addr_phase10;
assign pwdata10   = hwdata10;
assign hresp10  = 2'b00;

// Respond10 to NONSEQ10 or SEQ transfers10
assign valid_ahb_trans10 = ((htrans10 == 2'b10) || (htrans10 == 2'b11)) && (hsel10 == 1'b1);

always @(posedge hclk10) begin
  if (hreset_n10 == 1'b0) begin
    ahb_addr_phase10 <= 1'b1;
    ahb_data_phase10 <= 1'b0;
    haddr_reg10      <= 'b0;
    hwrite_reg10     <= 1'b0;
    hrdata10         <= 'b0;
  end
  else begin
    if (ahb_addr_phase10 == 1'b1 && valid_ahb_trans10 == 1'b1) begin
      ahb_addr_phase10 <= 1'b0;
      ahb_data_phase10 <= 1'b1;
      haddr_reg10      <= haddr10;
      hwrite_reg10     <= hwrite10;
    end
    if (ahb_data_phase10 == 1'b1 && pready_muxed10 == 1'b1 && apb_state10 == apb_state_access10) begin
      ahb_addr_phase10 <= 1'b1;
      ahb_data_phase10 <= 1'b0;
      hrdata10         <= prdata_muxed10;
    end
  end
end

// APB10 state machine10 state definitions10
assign apb_state_idle10   = 3'b001;
assign apb_state_setup10  = 3'b010;
assign apb_state_access10 = 3'b100;

// APB10 state machine10
always @(posedge hclk10 or negedge hreset_n10) begin
  if (hreset_n10 == 1'b0) begin
    apb_state10   <= apb_state_idle10;
    psel_vector10 <= 1'b0;
    penable10     <= 1'b0;
    paddr10       <= 1'b0;
    pwrite10      <= 1'b0;
  end  
  else begin
    
    // IDLE10 -> SETUP10
    if (apb_state10 == apb_state_idle10) begin
      if (ahb_data_phase10 == 1'b1) begin
        apb_state10   <= apb_state_setup10;
        psel_vector10 <= slave_select10;
        paddr10       <= haddr_reg10;
        pwrite10      <= hwrite_reg10;
      end  
    end
    
    // SETUP10 -> TRANSFER10
    if (apb_state10 == apb_state_setup10) begin
      apb_state10 <= apb_state_access10;
      penable10   <= 1'b1;
    end
    
    // TRANSFER10 -> SETUP10 or
    // TRANSFER10 -> IDLE10
    if (apb_state10 == apb_state_access10) begin
      if (pready_muxed10 == 1'b1) begin
      
        // TRANSFER10 -> SETUP10
        if (valid_ahb_trans10 == 1'b1) begin
          apb_state10   <= apb_state_setup10;
          penable10     <= 1'b0;
          psel_vector10 <= slave_select10;
          paddr10       <= haddr_reg10;
          pwrite10      <= hwrite_reg10;
        end  
        
        // TRANSFER10 -> IDLE10
        else begin
          apb_state10   <= apb_state_idle10;      
          penable10     <= 1'b0;
          psel_vector10 <= 'b0;
        end  
      end
    end
    
  end
end

always @(posedge hclk10 or negedge hreset_n10) begin
  if (hreset_n10 == 1'b0)
    slave_select10 <= 'b0;
  else begin  
  `ifdef APB_SLAVE010
     slave_select10[0]   <= valid_ahb_trans10 && (haddr10 >= APB_SLAVE0_START_ADDR10)  && (haddr10 <= APB_SLAVE0_END_ADDR10);
   `else
     slave_select10[0]   <= 1'b0;
   `endif
   
   `ifdef APB_SLAVE110
     slave_select10[1]   <= valid_ahb_trans10 && (haddr10 >= APB_SLAVE1_START_ADDR10)  && (haddr10 <= APB_SLAVE1_END_ADDR10);
   `else
     slave_select10[1]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE210  
     slave_select10[2]   <= valid_ahb_trans10 && (haddr10 >= APB_SLAVE2_START_ADDR10)  && (haddr10 <= APB_SLAVE2_END_ADDR10);
   `else
     slave_select10[2]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE310  
     slave_select10[3]   <= valid_ahb_trans10 && (haddr10 >= APB_SLAVE3_START_ADDR10)  && (haddr10 <= APB_SLAVE3_END_ADDR10);
   `else
     slave_select10[3]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE410  
     slave_select10[4]   <= valid_ahb_trans10 && (haddr10 >= APB_SLAVE4_START_ADDR10)  && (haddr10 <= APB_SLAVE4_END_ADDR10);
   `else
     slave_select10[4]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE510  
     slave_select10[5]   <= valid_ahb_trans10 && (haddr10 >= APB_SLAVE5_START_ADDR10)  && (haddr10 <= APB_SLAVE5_END_ADDR10);
   `else
     slave_select10[5]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE610  
     slave_select10[6]   <= valid_ahb_trans10 && (haddr10 >= APB_SLAVE6_START_ADDR10)  && (haddr10 <= APB_SLAVE6_END_ADDR10);
   `else
     slave_select10[6]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE710  
     slave_select10[7]   <= valid_ahb_trans10 && (haddr10 >= APB_SLAVE7_START_ADDR10)  && (haddr10 <= APB_SLAVE7_END_ADDR10);
   `else
     slave_select10[7]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE810  
     slave_select10[8]   <= valid_ahb_trans10 && (haddr10 >= APB_SLAVE8_START_ADDR10)  && (haddr10 <= APB_SLAVE8_END_ADDR10);
   `else
     slave_select10[8]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE910  
     slave_select10[9]   <= valid_ahb_trans10 && (haddr10 >= APB_SLAVE9_START_ADDR10)  && (haddr10 <= APB_SLAVE9_END_ADDR10);
   `else
     slave_select10[9]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1010  
     slave_select10[10]  <= valid_ahb_trans10 && (haddr10 >= APB_SLAVE10_START_ADDR10) && (haddr10 <= APB_SLAVE10_END_ADDR10);
   `else
     slave_select10[10]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1110  
     slave_select10[11]  <= valid_ahb_trans10 && (haddr10 >= APB_SLAVE11_START_ADDR10) && (haddr10 <= APB_SLAVE11_END_ADDR10);
   `else
     slave_select10[11]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1210  
     slave_select10[12]  <= valid_ahb_trans10 && (haddr10 >= APB_SLAVE12_START_ADDR10) && (haddr10 <= APB_SLAVE12_END_ADDR10);
   `else
     slave_select10[12]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1310  
     slave_select10[13]  <= valid_ahb_trans10 && (haddr10 >= APB_SLAVE13_START_ADDR10) && (haddr10 <= APB_SLAVE13_END_ADDR10);
   `else
     slave_select10[13]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1410  
     slave_select10[14]  <= valid_ahb_trans10 && (haddr10 >= APB_SLAVE14_START_ADDR10) && (haddr10 <= APB_SLAVE14_END_ADDR10);
   `else
     slave_select10[14]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1510  
     slave_select10[15]  <= valid_ahb_trans10 && (haddr10 >= APB_SLAVE15_START_ADDR10) && (haddr10 <= APB_SLAVE15_END_ADDR10);
   `else
     slave_select10[15]   <= 1'b0;
   `endif  
  end
end

assign pready_muxed10 = |(psel_vector10 & pready_vector10);
assign prdata_muxed10 = prdata0_q10  | prdata1_q10  | prdata2_q10  | prdata3_q10  |
                      prdata4_q10  | prdata5_q10  | prdata6_q10  | prdata7_q10  |
                      prdata8_q10  | prdata9_q10  | prdata10_q10 | prdata11_q10 |
                      prdata12_q10 | prdata13_q10 | prdata14_q10 | prdata15_q10 ;

`ifdef APB_SLAVE010
  assign psel010            = psel_vector10[0];
  assign pready_vector10[0] = pready010;
  assign prdata0_q10        = (psel010 == 1'b1) ? prdata010 : 'b0;
`else
  assign pready_vector10[0] = 1'b0;
  assign prdata0_q10        = 'b0;
`endif

`ifdef APB_SLAVE110
  assign psel110            = psel_vector10[1];
  assign pready_vector10[1] = pready110;
  assign prdata1_q10        = (psel110 == 1'b1) ? prdata110 : 'b0;
`else
  assign pready_vector10[1] = 1'b0;
  assign prdata1_q10        = 'b0;
`endif

`ifdef APB_SLAVE210
  assign psel210            = psel_vector10[2];
  assign pready_vector10[2] = pready210;
  assign prdata2_q10        = (psel210 == 1'b1) ? prdata210 : 'b0;
`else
  assign pready_vector10[2] = 1'b0;
  assign prdata2_q10        = 'b0;
`endif

`ifdef APB_SLAVE310
  assign psel310            = psel_vector10[3];
  assign pready_vector10[3] = pready310;
  assign prdata3_q10        = (psel310 == 1'b1) ? prdata310 : 'b0;
`else
  assign pready_vector10[3] = 1'b0;
  assign prdata3_q10        = 'b0;
`endif

`ifdef APB_SLAVE410
  assign psel410            = psel_vector10[4];
  assign pready_vector10[4] = pready410;
  assign prdata4_q10        = (psel410 == 1'b1) ? prdata410 : 'b0;
`else
  assign pready_vector10[4] = 1'b0;
  assign prdata4_q10        = 'b0;
`endif

`ifdef APB_SLAVE510
  assign psel510            = psel_vector10[5];
  assign pready_vector10[5] = pready510;
  assign prdata5_q10        = (psel510 == 1'b1) ? prdata510 : 'b0;
`else
  assign pready_vector10[5] = 1'b0;
  assign prdata5_q10        = 'b0;
`endif

`ifdef APB_SLAVE610
  assign psel610            = psel_vector10[6];
  assign pready_vector10[6] = pready610;
  assign prdata6_q10        = (psel610 == 1'b1) ? prdata610 : 'b0;
`else
  assign pready_vector10[6] = 1'b0;
  assign prdata6_q10        = 'b0;
`endif

`ifdef APB_SLAVE710
  assign psel710            = psel_vector10[7];
  assign pready_vector10[7] = pready710;
  assign prdata7_q10        = (psel710 == 1'b1) ? prdata710 : 'b0;
`else
  assign pready_vector10[7] = 1'b0;
  assign prdata7_q10        = 'b0;
`endif

`ifdef APB_SLAVE810
  assign psel810            = psel_vector10[8];
  assign pready_vector10[8] = pready810;
  assign prdata8_q10        = (psel810 == 1'b1) ? prdata810 : 'b0;
`else
  assign pready_vector10[8] = 1'b0;
  assign prdata8_q10        = 'b0;
`endif

`ifdef APB_SLAVE910
  assign psel910            = psel_vector10[9];
  assign pready_vector10[9] = pready910;
  assign prdata9_q10        = (psel910 == 1'b1) ? prdata910 : 'b0;
`else
  assign pready_vector10[9] = 1'b0;
  assign prdata9_q10        = 'b0;
`endif

`ifdef APB_SLAVE1010
  assign psel1010            = psel_vector10[10];
  assign pready_vector10[10] = pready1010;
  assign prdata10_q10        = (psel1010 == 1'b1) ? prdata1010 : 'b0;
`else
  assign pready_vector10[10] = 1'b0;
  assign prdata10_q10        = 'b0;
`endif

`ifdef APB_SLAVE1110
  assign psel1110            = psel_vector10[11];
  assign pready_vector10[11] = pready1110;
  assign prdata11_q10        = (psel1110 == 1'b1) ? prdata1110 : 'b0;
`else
  assign pready_vector10[11] = 1'b0;
  assign prdata11_q10        = 'b0;
`endif

`ifdef APB_SLAVE1210
  assign psel1210            = psel_vector10[12];
  assign pready_vector10[12] = pready1210;
  assign prdata12_q10        = (psel1210 == 1'b1) ? prdata1210 : 'b0;
`else
  assign pready_vector10[12] = 1'b0;
  assign prdata12_q10        = 'b0;
`endif

`ifdef APB_SLAVE1310
  assign psel1310            = psel_vector10[13];
  assign pready_vector10[13] = pready1310;
  assign prdata13_q10        = (psel1310 == 1'b1) ? prdata1310 : 'b0;
`else
  assign pready_vector10[13] = 1'b0;
  assign prdata13_q10        = 'b0;
`endif

`ifdef APB_SLAVE1410
  assign psel1410            = psel_vector10[14];
  assign pready_vector10[14] = pready1410;
  assign prdata14_q10        = (psel1410 == 1'b1) ? prdata1410 : 'b0;
`else
  assign pready_vector10[14] = 1'b0;
  assign prdata14_q10        = 'b0;
`endif

`ifdef APB_SLAVE1510
  assign psel1510            = psel_vector10[15];
  assign pready_vector10[15] = pready1510;
  assign prdata15_q10        = (psel1510 == 1'b1) ? prdata1510 : 'b0;
`else
  assign pready_vector10[15] = 1'b0;
  assign prdata15_q10        = 'b0;
`endif

endmodule
