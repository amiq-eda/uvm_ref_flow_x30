//File26 name   : ahb2apb26.v
//Title26       : 
//Created26     : 2010
//Description26 : Simple26 AHB26 to APB26 bridge26
//Notes26       : 
//----------------------------------------------------------------------
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------

`timescale 1ns/1ps

`include "ahb2apb_defines26.v"

module ahb2apb26
(
  // AHB26 signals26
  hclk26,
  hreset_n26,
  hsel26,
  haddr26,
  htrans26,
  hwdata26,
  hwrite26,
  hrdata26,
  hready26,
  hresp26,
  
  // APB26 signals26 common to all APB26 slaves26
  pclk26,
  preset_n26,
  paddr26,
  penable26,
  pwrite26,
  pwdata26
  
  // Slave26 0 signals26
  `ifdef APB_SLAVE026
  ,psel026
  ,pready026
  ,prdata026
  `endif
  
  // Slave26 1 signals26
  `ifdef APB_SLAVE126
  ,psel126
  ,pready126
  ,prdata126
  `endif
  
  // Slave26 2 signals26
  `ifdef APB_SLAVE226
  ,psel226
  ,pready226
  ,prdata226
  `endif
  
  // Slave26 3 signals26
  `ifdef APB_SLAVE326
  ,psel326
  ,pready326
  ,prdata326
  `endif
  
  // Slave26 4 signals26
  `ifdef APB_SLAVE426
  ,psel426
  ,pready426
  ,prdata426
  `endif
  
  // Slave26 5 signals26
  `ifdef APB_SLAVE526
  ,psel526
  ,pready526
  ,prdata526
  `endif
  
  // Slave26 6 signals26
  `ifdef APB_SLAVE626
  ,psel626
  ,pready626
  ,prdata626
  `endif
  
  // Slave26 7 signals26
  `ifdef APB_SLAVE726
  ,psel726
  ,pready726
  ,prdata726
  `endif
  
  // Slave26 8 signals26
  `ifdef APB_SLAVE826
  ,psel826
  ,pready826
  ,prdata826
  `endif
  
  // Slave26 9 signals26
  `ifdef APB_SLAVE926
  ,psel926
  ,pready926
  ,prdata926
  `endif
  
  // Slave26 10 signals26
  `ifdef APB_SLAVE1026
  ,psel1026
  ,pready1026
  ,prdata1026
  `endif
  
  // Slave26 11 signals26
  `ifdef APB_SLAVE1126
  ,psel1126
  ,pready1126
  ,prdata1126
  `endif
  
  // Slave26 12 signals26
  `ifdef APB_SLAVE1226
  ,psel1226
  ,pready1226
  ,prdata1226
  `endif
  
  // Slave26 13 signals26
  `ifdef APB_SLAVE1326
  ,psel1326
  ,pready1326
  ,prdata1326
  `endif
  
  // Slave26 14 signals26
  `ifdef APB_SLAVE1426
  ,psel1426
  ,pready1426
  ,prdata1426
  `endif
  
  // Slave26 15 signals26
  `ifdef APB_SLAVE1526
  ,psel1526
  ,pready1526
  ,prdata1526
  `endif
  
);

parameter 
  APB_SLAVE0_START_ADDR26  = 32'h00000000,
  APB_SLAVE0_END_ADDR26    = 32'h00000000,
  APB_SLAVE1_START_ADDR26  = 32'h00000000,
  APB_SLAVE1_END_ADDR26    = 32'h00000000,
  APB_SLAVE2_START_ADDR26  = 32'h00000000,
  APB_SLAVE2_END_ADDR26    = 32'h00000000,
  APB_SLAVE3_START_ADDR26  = 32'h00000000,
  APB_SLAVE3_END_ADDR26    = 32'h00000000,
  APB_SLAVE4_START_ADDR26  = 32'h00000000,
  APB_SLAVE4_END_ADDR26    = 32'h00000000,
  APB_SLAVE5_START_ADDR26  = 32'h00000000,
  APB_SLAVE5_END_ADDR26    = 32'h00000000,
  APB_SLAVE6_START_ADDR26  = 32'h00000000,
  APB_SLAVE6_END_ADDR26    = 32'h00000000,
  APB_SLAVE7_START_ADDR26  = 32'h00000000,
  APB_SLAVE7_END_ADDR26    = 32'h00000000,
  APB_SLAVE8_START_ADDR26  = 32'h00000000,
  APB_SLAVE8_END_ADDR26    = 32'h00000000,
  APB_SLAVE9_START_ADDR26  = 32'h00000000,
  APB_SLAVE9_END_ADDR26    = 32'h00000000,
  APB_SLAVE10_START_ADDR26  = 32'h00000000,
  APB_SLAVE10_END_ADDR26    = 32'h00000000,
  APB_SLAVE11_START_ADDR26  = 32'h00000000,
  APB_SLAVE11_END_ADDR26    = 32'h00000000,
  APB_SLAVE12_START_ADDR26  = 32'h00000000,
  APB_SLAVE12_END_ADDR26    = 32'h00000000,
  APB_SLAVE13_START_ADDR26  = 32'h00000000,
  APB_SLAVE13_END_ADDR26    = 32'h00000000,
  APB_SLAVE14_START_ADDR26  = 32'h00000000,
  APB_SLAVE14_END_ADDR26    = 32'h00000000,
  APB_SLAVE15_START_ADDR26  = 32'h00000000,
  APB_SLAVE15_END_ADDR26    = 32'h00000000;

  // AHB26 signals26
input        hclk26;
input        hreset_n26;
input        hsel26;
input[31:0]  haddr26;
input[1:0]   htrans26;
input[31:0]  hwdata26;
input        hwrite26;
output[31:0] hrdata26;
reg   [31:0] hrdata26;
output       hready26;
output[1:0]  hresp26;
  
  // APB26 signals26 common to all APB26 slaves26
input       pclk26;
input       preset_n26;
output[31:0] paddr26;
reg   [31:0] paddr26;
output       penable26;
reg          penable26;
output       pwrite26;
reg          pwrite26;
output[31:0] pwdata26;
  
  // Slave26 0 signals26
`ifdef APB_SLAVE026
  output      psel026;
  input       pready026;
  input[31:0] prdata026;
`endif
  
  // Slave26 1 signals26
`ifdef APB_SLAVE126
  output      psel126;
  input       pready126;
  input[31:0] prdata126;
`endif
  
  // Slave26 2 signals26
`ifdef APB_SLAVE226
  output      psel226;
  input       pready226;
  input[31:0] prdata226;
`endif
  
  // Slave26 3 signals26
`ifdef APB_SLAVE326
  output      psel326;
  input       pready326;
  input[31:0] prdata326;
`endif
  
  // Slave26 4 signals26
`ifdef APB_SLAVE426
  output      psel426;
  input       pready426;
  input[31:0] prdata426;
`endif
  
  // Slave26 5 signals26
`ifdef APB_SLAVE526
  output      psel526;
  input       pready526;
  input[31:0] prdata526;
`endif
  
  // Slave26 6 signals26
`ifdef APB_SLAVE626
  output      psel626;
  input       pready626;
  input[31:0] prdata626;
`endif
  
  // Slave26 7 signals26
`ifdef APB_SLAVE726
  output      psel726;
  input       pready726;
  input[31:0] prdata726;
`endif
  
  // Slave26 8 signals26
`ifdef APB_SLAVE826
  output      psel826;
  input       pready826;
  input[31:0] prdata826;
`endif
  
  // Slave26 9 signals26
`ifdef APB_SLAVE926
  output      psel926;
  input       pready926;
  input[31:0] prdata926;
`endif
  
  // Slave26 10 signals26
`ifdef APB_SLAVE1026
  output      psel1026;
  input       pready1026;
  input[31:0] prdata1026;
`endif
  
  // Slave26 11 signals26
`ifdef APB_SLAVE1126
  output      psel1126;
  input       pready1126;
  input[31:0] prdata1126;
`endif
  
  // Slave26 12 signals26
`ifdef APB_SLAVE1226
  output      psel1226;
  input       pready1226;
  input[31:0] prdata1226;
`endif
  
  // Slave26 13 signals26
`ifdef APB_SLAVE1326
  output      psel1326;
  input       pready1326;
  input[31:0] prdata1326;
`endif
  
  // Slave26 14 signals26
`ifdef APB_SLAVE1426
  output      psel1426;
  input       pready1426;
  input[31:0] prdata1426;
`endif
  
  // Slave26 15 signals26
`ifdef APB_SLAVE1526
  output      psel1526;
  input       pready1526;
  input[31:0] prdata1526;
`endif
 
reg         ahb_addr_phase26;
reg         ahb_data_phase26;
wire        valid_ahb_trans26;
wire        pready_muxed26;
wire [31:0] prdata_muxed26;
reg  [31:0] haddr_reg26;
reg         hwrite_reg26;
reg  [2:0]  apb_state26;
wire [2:0]  apb_state_idle26;
wire [2:0]  apb_state_setup26;
wire [2:0]  apb_state_access26;
reg  [15:0] slave_select26;
wire [15:0] pready_vector26;
reg  [15:0] psel_vector26;
wire [31:0] prdata0_q26;
wire [31:0] prdata1_q26;
wire [31:0] prdata2_q26;
wire [31:0] prdata3_q26;
wire [31:0] prdata4_q26;
wire [31:0] prdata5_q26;
wire [31:0] prdata6_q26;
wire [31:0] prdata7_q26;
wire [31:0] prdata8_q26;
wire [31:0] prdata9_q26;
wire [31:0] prdata10_q26;
wire [31:0] prdata11_q26;
wire [31:0] prdata12_q26;
wire [31:0] prdata13_q26;
wire [31:0] prdata14_q26;
wire [31:0] prdata15_q26;

// assign pclk26     = hclk26;
// assign preset_n26 = hreset_n26;
assign hready26   = ahb_addr_phase26;
assign pwdata26   = hwdata26;
assign hresp26  = 2'b00;

// Respond26 to NONSEQ26 or SEQ transfers26
assign valid_ahb_trans26 = ((htrans26 == 2'b10) || (htrans26 == 2'b11)) && (hsel26 == 1'b1);

always @(posedge hclk26) begin
  if (hreset_n26 == 1'b0) begin
    ahb_addr_phase26 <= 1'b1;
    ahb_data_phase26 <= 1'b0;
    haddr_reg26      <= 'b0;
    hwrite_reg26     <= 1'b0;
    hrdata26         <= 'b0;
  end
  else begin
    if (ahb_addr_phase26 == 1'b1 && valid_ahb_trans26 == 1'b1) begin
      ahb_addr_phase26 <= 1'b0;
      ahb_data_phase26 <= 1'b1;
      haddr_reg26      <= haddr26;
      hwrite_reg26     <= hwrite26;
    end
    if (ahb_data_phase26 == 1'b1 && pready_muxed26 == 1'b1 && apb_state26 == apb_state_access26) begin
      ahb_addr_phase26 <= 1'b1;
      ahb_data_phase26 <= 1'b0;
      hrdata26         <= prdata_muxed26;
    end
  end
end

// APB26 state machine26 state definitions26
assign apb_state_idle26   = 3'b001;
assign apb_state_setup26  = 3'b010;
assign apb_state_access26 = 3'b100;

// APB26 state machine26
always @(posedge hclk26 or negedge hreset_n26) begin
  if (hreset_n26 == 1'b0) begin
    apb_state26   <= apb_state_idle26;
    psel_vector26 <= 1'b0;
    penable26     <= 1'b0;
    paddr26       <= 1'b0;
    pwrite26      <= 1'b0;
  end  
  else begin
    
    // IDLE26 -> SETUP26
    if (apb_state26 == apb_state_idle26) begin
      if (ahb_data_phase26 == 1'b1) begin
        apb_state26   <= apb_state_setup26;
        psel_vector26 <= slave_select26;
        paddr26       <= haddr_reg26;
        pwrite26      <= hwrite_reg26;
      end  
    end
    
    // SETUP26 -> TRANSFER26
    if (apb_state26 == apb_state_setup26) begin
      apb_state26 <= apb_state_access26;
      penable26   <= 1'b1;
    end
    
    // TRANSFER26 -> SETUP26 or
    // TRANSFER26 -> IDLE26
    if (apb_state26 == apb_state_access26) begin
      if (pready_muxed26 == 1'b1) begin
      
        // TRANSFER26 -> SETUP26
        if (valid_ahb_trans26 == 1'b1) begin
          apb_state26   <= apb_state_setup26;
          penable26     <= 1'b0;
          psel_vector26 <= slave_select26;
          paddr26       <= haddr_reg26;
          pwrite26      <= hwrite_reg26;
        end  
        
        // TRANSFER26 -> IDLE26
        else begin
          apb_state26   <= apb_state_idle26;      
          penable26     <= 1'b0;
          psel_vector26 <= 'b0;
        end  
      end
    end
    
  end
end

always @(posedge hclk26 or negedge hreset_n26) begin
  if (hreset_n26 == 1'b0)
    slave_select26 <= 'b0;
  else begin  
  `ifdef APB_SLAVE026
     slave_select26[0]   <= valid_ahb_trans26 && (haddr26 >= APB_SLAVE0_START_ADDR26)  && (haddr26 <= APB_SLAVE0_END_ADDR26);
   `else
     slave_select26[0]   <= 1'b0;
   `endif
   
   `ifdef APB_SLAVE126
     slave_select26[1]   <= valid_ahb_trans26 && (haddr26 >= APB_SLAVE1_START_ADDR26)  && (haddr26 <= APB_SLAVE1_END_ADDR26);
   `else
     slave_select26[1]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE226  
     slave_select26[2]   <= valid_ahb_trans26 && (haddr26 >= APB_SLAVE2_START_ADDR26)  && (haddr26 <= APB_SLAVE2_END_ADDR26);
   `else
     slave_select26[2]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE326  
     slave_select26[3]   <= valid_ahb_trans26 && (haddr26 >= APB_SLAVE3_START_ADDR26)  && (haddr26 <= APB_SLAVE3_END_ADDR26);
   `else
     slave_select26[3]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE426  
     slave_select26[4]   <= valid_ahb_trans26 && (haddr26 >= APB_SLAVE4_START_ADDR26)  && (haddr26 <= APB_SLAVE4_END_ADDR26);
   `else
     slave_select26[4]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE526  
     slave_select26[5]   <= valid_ahb_trans26 && (haddr26 >= APB_SLAVE5_START_ADDR26)  && (haddr26 <= APB_SLAVE5_END_ADDR26);
   `else
     slave_select26[5]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE626  
     slave_select26[6]   <= valid_ahb_trans26 && (haddr26 >= APB_SLAVE6_START_ADDR26)  && (haddr26 <= APB_SLAVE6_END_ADDR26);
   `else
     slave_select26[6]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE726  
     slave_select26[7]   <= valid_ahb_trans26 && (haddr26 >= APB_SLAVE7_START_ADDR26)  && (haddr26 <= APB_SLAVE7_END_ADDR26);
   `else
     slave_select26[7]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE826  
     slave_select26[8]   <= valid_ahb_trans26 && (haddr26 >= APB_SLAVE8_START_ADDR26)  && (haddr26 <= APB_SLAVE8_END_ADDR26);
   `else
     slave_select26[8]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE926  
     slave_select26[9]   <= valid_ahb_trans26 && (haddr26 >= APB_SLAVE9_START_ADDR26)  && (haddr26 <= APB_SLAVE9_END_ADDR26);
   `else
     slave_select26[9]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1026  
     slave_select26[10]  <= valid_ahb_trans26 && (haddr26 >= APB_SLAVE10_START_ADDR26) && (haddr26 <= APB_SLAVE10_END_ADDR26);
   `else
     slave_select26[10]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1126  
     slave_select26[11]  <= valid_ahb_trans26 && (haddr26 >= APB_SLAVE11_START_ADDR26) && (haddr26 <= APB_SLAVE11_END_ADDR26);
   `else
     slave_select26[11]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1226  
     slave_select26[12]  <= valid_ahb_trans26 && (haddr26 >= APB_SLAVE12_START_ADDR26) && (haddr26 <= APB_SLAVE12_END_ADDR26);
   `else
     slave_select26[12]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1326  
     slave_select26[13]  <= valid_ahb_trans26 && (haddr26 >= APB_SLAVE13_START_ADDR26) && (haddr26 <= APB_SLAVE13_END_ADDR26);
   `else
     slave_select26[13]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1426  
     slave_select26[14]  <= valid_ahb_trans26 && (haddr26 >= APB_SLAVE14_START_ADDR26) && (haddr26 <= APB_SLAVE14_END_ADDR26);
   `else
     slave_select26[14]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1526  
     slave_select26[15]  <= valid_ahb_trans26 && (haddr26 >= APB_SLAVE15_START_ADDR26) && (haddr26 <= APB_SLAVE15_END_ADDR26);
   `else
     slave_select26[15]   <= 1'b0;
   `endif  
  end
end

assign pready_muxed26 = |(psel_vector26 & pready_vector26);
assign prdata_muxed26 = prdata0_q26  | prdata1_q26  | prdata2_q26  | prdata3_q26  |
                      prdata4_q26  | prdata5_q26  | prdata6_q26  | prdata7_q26  |
                      prdata8_q26  | prdata9_q26  | prdata10_q26 | prdata11_q26 |
                      prdata12_q26 | prdata13_q26 | prdata14_q26 | prdata15_q26 ;

`ifdef APB_SLAVE026
  assign psel026            = psel_vector26[0];
  assign pready_vector26[0] = pready026;
  assign prdata0_q26        = (psel026 == 1'b1) ? prdata026 : 'b0;
`else
  assign pready_vector26[0] = 1'b0;
  assign prdata0_q26        = 'b0;
`endif

`ifdef APB_SLAVE126
  assign psel126            = psel_vector26[1];
  assign pready_vector26[1] = pready126;
  assign prdata1_q26        = (psel126 == 1'b1) ? prdata126 : 'b0;
`else
  assign pready_vector26[1] = 1'b0;
  assign prdata1_q26        = 'b0;
`endif

`ifdef APB_SLAVE226
  assign psel226            = psel_vector26[2];
  assign pready_vector26[2] = pready226;
  assign prdata2_q26        = (psel226 == 1'b1) ? prdata226 : 'b0;
`else
  assign pready_vector26[2] = 1'b0;
  assign prdata2_q26        = 'b0;
`endif

`ifdef APB_SLAVE326
  assign psel326            = psel_vector26[3];
  assign pready_vector26[3] = pready326;
  assign prdata3_q26        = (psel326 == 1'b1) ? prdata326 : 'b0;
`else
  assign pready_vector26[3] = 1'b0;
  assign prdata3_q26        = 'b0;
`endif

`ifdef APB_SLAVE426
  assign psel426            = psel_vector26[4];
  assign pready_vector26[4] = pready426;
  assign prdata4_q26        = (psel426 == 1'b1) ? prdata426 : 'b0;
`else
  assign pready_vector26[4] = 1'b0;
  assign prdata4_q26        = 'b0;
`endif

`ifdef APB_SLAVE526
  assign psel526            = psel_vector26[5];
  assign pready_vector26[5] = pready526;
  assign prdata5_q26        = (psel526 == 1'b1) ? prdata526 : 'b0;
`else
  assign pready_vector26[5] = 1'b0;
  assign prdata5_q26        = 'b0;
`endif

`ifdef APB_SLAVE626
  assign psel626            = psel_vector26[6];
  assign pready_vector26[6] = pready626;
  assign prdata6_q26        = (psel626 == 1'b1) ? prdata626 : 'b0;
`else
  assign pready_vector26[6] = 1'b0;
  assign prdata6_q26        = 'b0;
`endif

`ifdef APB_SLAVE726
  assign psel726            = psel_vector26[7];
  assign pready_vector26[7] = pready726;
  assign prdata7_q26        = (psel726 == 1'b1) ? prdata726 : 'b0;
`else
  assign pready_vector26[7] = 1'b0;
  assign prdata7_q26        = 'b0;
`endif

`ifdef APB_SLAVE826
  assign psel826            = psel_vector26[8];
  assign pready_vector26[8] = pready826;
  assign prdata8_q26        = (psel826 == 1'b1) ? prdata826 : 'b0;
`else
  assign pready_vector26[8] = 1'b0;
  assign prdata8_q26        = 'b0;
`endif

`ifdef APB_SLAVE926
  assign psel926            = psel_vector26[9];
  assign pready_vector26[9] = pready926;
  assign prdata9_q26        = (psel926 == 1'b1) ? prdata926 : 'b0;
`else
  assign pready_vector26[9] = 1'b0;
  assign prdata9_q26        = 'b0;
`endif

`ifdef APB_SLAVE1026
  assign psel1026            = psel_vector26[10];
  assign pready_vector26[10] = pready1026;
  assign prdata10_q26        = (psel1026 == 1'b1) ? prdata1026 : 'b0;
`else
  assign pready_vector26[10] = 1'b0;
  assign prdata10_q26        = 'b0;
`endif

`ifdef APB_SLAVE1126
  assign psel1126            = psel_vector26[11];
  assign pready_vector26[11] = pready1126;
  assign prdata11_q26        = (psel1126 == 1'b1) ? prdata1126 : 'b0;
`else
  assign pready_vector26[11] = 1'b0;
  assign prdata11_q26        = 'b0;
`endif

`ifdef APB_SLAVE1226
  assign psel1226            = psel_vector26[12];
  assign pready_vector26[12] = pready1226;
  assign prdata12_q26        = (psel1226 == 1'b1) ? prdata1226 : 'b0;
`else
  assign pready_vector26[12] = 1'b0;
  assign prdata12_q26        = 'b0;
`endif

`ifdef APB_SLAVE1326
  assign psel1326            = psel_vector26[13];
  assign pready_vector26[13] = pready1326;
  assign prdata13_q26        = (psel1326 == 1'b1) ? prdata1326 : 'b0;
`else
  assign pready_vector26[13] = 1'b0;
  assign prdata13_q26        = 'b0;
`endif

`ifdef APB_SLAVE1426
  assign psel1426            = psel_vector26[14];
  assign pready_vector26[14] = pready1426;
  assign prdata14_q26        = (psel1426 == 1'b1) ? prdata1426 : 'b0;
`else
  assign pready_vector26[14] = 1'b0;
  assign prdata14_q26        = 'b0;
`endif

`ifdef APB_SLAVE1526
  assign psel1526            = psel_vector26[15];
  assign pready_vector26[15] = pready1526;
  assign prdata15_q26        = (psel1526 == 1'b1) ? prdata1526 : 'b0;
`else
  assign pready_vector26[15] = 1'b0;
  assign prdata15_q26        = 'b0;
`endif

endmodule
