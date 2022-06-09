//File23 name   : ahb2apb23.v
//Title23       : 
//Created23     : 2010
//Description23 : Simple23 AHB23 to APB23 bridge23
//Notes23       : 
//----------------------------------------------------------------------
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------

`timescale 1ns/1ps

`include "ahb2apb_defines23.v"

module ahb2apb23
(
  // AHB23 signals23
  hclk23,
  hreset_n23,
  hsel23,
  haddr23,
  htrans23,
  hwdata23,
  hwrite23,
  hrdata23,
  hready23,
  hresp23,
  
  // APB23 signals23 common to all APB23 slaves23
  pclk23,
  preset_n23,
  paddr23,
  penable23,
  pwrite23,
  pwdata23
  
  // Slave23 0 signals23
  `ifdef APB_SLAVE023
  ,psel023
  ,pready023
  ,prdata023
  `endif
  
  // Slave23 1 signals23
  `ifdef APB_SLAVE123
  ,psel123
  ,pready123
  ,prdata123
  `endif
  
  // Slave23 2 signals23
  `ifdef APB_SLAVE223
  ,psel223
  ,pready223
  ,prdata223
  `endif
  
  // Slave23 3 signals23
  `ifdef APB_SLAVE323
  ,psel323
  ,pready323
  ,prdata323
  `endif
  
  // Slave23 4 signals23
  `ifdef APB_SLAVE423
  ,psel423
  ,pready423
  ,prdata423
  `endif
  
  // Slave23 5 signals23
  `ifdef APB_SLAVE523
  ,psel523
  ,pready523
  ,prdata523
  `endif
  
  // Slave23 6 signals23
  `ifdef APB_SLAVE623
  ,psel623
  ,pready623
  ,prdata623
  `endif
  
  // Slave23 7 signals23
  `ifdef APB_SLAVE723
  ,psel723
  ,pready723
  ,prdata723
  `endif
  
  // Slave23 8 signals23
  `ifdef APB_SLAVE823
  ,psel823
  ,pready823
  ,prdata823
  `endif
  
  // Slave23 9 signals23
  `ifdef APB_SLAVE923
  ,psel923
  ,pready923
  ,prdata923
  `endif
  
  // Slave23 10 signals23
  `ifdef APB_SLAVE1023
  ,psel1023
  ,pready1023
  ,prdata1023
  `endif
  
  // Slave23 11 signals23
  `ifdef APB_SLAVE1123
  ,psel1123
  ,pready1123
  ,prdata1123
  `endif
  
  // Slave23 12 signals23
  `ifdef APB_SLAVE1223
  ,psel1223
  ,pready1223
  ,prdata1223
  `endif
  
  // Slave23 13 signals23
  `ifdef APB_SLAVE1323
  ,psel1323
  ,pready1323
  ,prdata1323
  `endif
  
  // Slave23 14 signals23
  `ifdef APB_SLAVE1423
  ,psel1423
  ,pready1423
  ,prdata1423
  `endif
  
  // Slave23 15 signals23
  `ifdef APB_SLAVE1523
  ,psel1523
  ,pready1523
  ,prdata1523
  `endif
  
);

parameter 
  APB_SLAVE0_START_ADDR23  = 32'h00000000,
  APB_SLAVE0_END_ADDR23    = 32'h00000000,
  APB_SLAVE1_START_ADDR23  = 32'h00000000,
  APB_SLAVE1_END_ADDR23    = 32'h00000000,
  APB_SLAVE2_START_ADDR23  = 32'h00000000,
  APB_SLAVE2_END_ADDR23    = 32'h00000000,
  APB_SLAVE3_START_ADDR23  = 32'h00000000,
  APB_SLAVE3_END_ADDR23    = 32'h00000000,
  APB_SLAVE4_START_ADDR23  = 32'h00000000,
  APB_SLAVE4_END_ADDR23    = 32'h00000000,
  APB_SLAVE5_START_ADDR23  = 32'h00000000,
  APB_SLAVE5_END_ADDR23    = 32'h00000000,
  APB_SLAVE6_START_ADDR23  = 32'h00000000,
  APB_SLAVE6_END_ADDR23    = 32'h00000000,
  APB_SLAVE7_START_ADDR23  = 32'h00000000,
  APB_SLAVE7_END_ADDR23    = 32'h00000000,
  APB_SLAVE8_START_ADDR23  = 32'h00000000,
  APB_SLAVE8_END_ADDR23    = 32'h00000000,
  APB_SLAVE9_START_ADDR23  = 32'h00000000,
  APB_SLAVE9_END_ADDR23    = 32'h00000000,
  APB_SLAVE10_START_ADDR23  = 32'h00000000,
  APB_SLAVE10_END_ADDR23    = 32'h00000000,
  APB_SLAVE11_START_ADDR23  = 32'h00000000,
  APB_SLAVE11_END_ADDR23    = 32'h00000000,
  APB_SLAVE12_START_ADDR23  = 32'h00000000,
  APB_SLAVE12_END_ADDR23    = 32'h00000000,
  APB_SLAVE13_START_ADDR23  = 32'h00000000,
  APB_SLAVE13_END_ADDR23    = 32'h00000000,
  APB_SLAVE14_START_ADDR23  = 32'h00000000,
  APB_SLAVE14_END_ADDR23    = 32'h00000000,
  APB_SLAVE15_START_ADDR23  = 32'h00000000,
  APB_SLAVE15_END_ADDR23    = 32'h00000000;

  // AHB23 signals23
input        hclk23;
input        hreset_n23;
input        hsel23;
input[31:0]  haddr23;
input[1:0]   htrans23;
input[31:0]  hwdata23;
input        hwrite23;
output[31:0] hrdata23;
reg   [31:0] hrdata23;
output       hready23;
output[1:0]  hresp23;
  
  // APB23 signals23 common to all APB23 slaves23
input       pclk23;
input       preset_n23;
output[31:0] paddr23;
reg   [31:0] paddr23;
output       penable23;
reg          penable23;
output       pwrite23;
reg          pwrite23;
output[31:0] pwdata23;
  
  // Slave23 0 signals23
`ifdef APB_SLAVE023
  output      psel023;
  input       pready023;
  input[31:0] prdata023;
`endif
  
  // Slave23 1 signals23
`ifdef APB_SLAVE123
  output      psel123;
  input       pready123;
  input[31:0] prdata123;
`endif
  
  // Slave23 2 signals23
`ifdef APB_SLAVE223
  output      psel223;
  input       pready223;
  input[31:0] prdata223;
`endif
  
  // Slave23 3 signals23
`ifdef APB_SLAVE323
  output      psel323;
  input       pready323;
  input[31:0] prdata323;
`endif
  
  // Slave23 4 signals23
`ifdef APB_SLAVE423
  output      psel423;
  input       pready423;
  input[31:0] prdata423;
`endif
  
  // Slave23 5 signals23
`ifdef APB_SLAVE523
  output      psel523;
  input       pready523;
  input[31:0] prdata523;
`endif
  
  // Slave23 6 signals23
`ifdef APB_SLAVE623
  output      psel623;
  input       pready623;
  input[31:0] prdata623;
`endif
  
  // Slave23 7 signals23
`ifdef APB_SLAVE723
  output      psel723;
  input       pready723;
  input[31:0] prdata723;
`endif
  
  // Slave23 8 signals23
`ifdef APB_SLAVE823
  output      psel823;
  input       pready823;
  input[31:0] prdata823;
`endif
  
  // Slave23 9 signals23
`ifdef APB_SLAVE923
  output      psel923;
  input       pready923;
  input[31:0] prdata923;
`endif
  
  // Slave23 10 signals23
`ifdef APB_SLAVE1023
  output      psel1023;
  input       pready1023;
  input[31:0] prdata1023;
`endif
  
  // Slave23 11 signals23
`ifdef APB_SLAVE1123
  output      psel1123;
  input       pready1123;
  input[31:0] prdata1123;
`endif
  
  // Slave23 12 signals23
`ifdef APB_SLAVE1223
  output      psel1223;
  input       pready1223;
  input[31:0] prdata1223;
`endif
  
  // Slave23 13 signals23
`ifdef APB_SLAVE1323
  output      psel1323;
  input       pready1323;
  input[31:0] prdata1323;
`endif
  
  // Slave23 14 signals23
`ifdef APB_SLAVE1423
  output      psel1423;
  input       pready1423;
  input[31:0] prdata1423;
`endif
  
  // Slave23 15 signals23
`ifdef APB_SLAVE1523
  output      psel1523;
  input       pready1523;
  input[31:0] prdata1523;
`endif
 
reg         ahb_addr_phase23;
reg         ahb_data_phase23;
wire        valid_ahb_trans23;
wire        pready_muxed23;
wire [31:0] prdata_muxed23;
reg  [31:0] haddr_reg23;
reg         hwrite_reg23;
reg  [2:0]  apb_state23;
wire [2:0]  apb_state_idle23;
wire [2:0]  apb_state_setup23;
wire [2:0]  apb_state_access23;
reg  [15:0] slave_select23;
wire [15:0] pready_vector23;
reg  [15:0] psel_vector23;
wire [31:0] prdata0_q23;
wire [31:0] prdata1_q23;
wire [31:0] prdata2_q23;
wire [31:0] prdata3_q23;
wire [31:0] prdata4_q23;
wire [31:0] prdata5_q23;
wire [31:0] prdata6_q23;
wire [31:0] prdata7_q23;
wire [31:0] prdata8_q23;
wire [31:0] prdata9_q23;
wire [31:0] prdata10_q23;
wire [31:0] prdata11_q23;
wire [31:0] prdata12_q23;
wire [31:0] prdata13_q23;
wire [31:0] prdata14_q23;
wire [31:0] prdata15_q23;

// assign pclk23     = hclk23;
// assign preset_n23 = hreset_n23;
assign hready23   = ahb_addr_phase23;
assign pwdata23   = hwdata23;
assign hresp23  = 2'b00;

// Respond23 to NONSEQ23 or SEQ transfers23
assign valid_ahb_trans23 = ((htrans23 == 2'b10) || (htrans23 == 2'b11)) && (hsel23 == 1'b1);

always @(posedge hclk23) begin
  if (hreset_n23 == 1'b0) begin
    ahb_addr_phase23 <= 1'b1;
    ahb_data_phase23 <= 1'b0;
    haddr_reg23      <= 'b0;
    hwrite_reg23     <= 1'b0;
    hrdata23         <= 'b0;
  end
  else begin
    if (ahb_addr_phase23 == 1'b1 && valid_ahb_trans23 == 1'b1) begin
      ahb_addr_phase23 <= 1'b0;
      ahb_data_phase23 <= 1'b1;
      haddr_reg23      <= haddr23;
      hwrite_reg23     <= hwrite23;
    end
    if (ahb_data_phase23 == 1'b1 && pready_muxed23 == 1'b1 && apb_state23 == apb_state_access23) begin
      ahb_addr_phase23 <= 1'b1;
      ahb_data_phase23 <= 1'b0;
      hrdata23         <= prdata_muxed23;
    end
  end
end

// APB23 state machine23 state definitions23
assign apb_state_idle23   = 3'b001;
assign apb_state_setup23  = 3'b010;
assign apb_state_access23 = 3'b100;

// APB23 state machine23
always @(posedge hclk23 or negedge hreset_n23) begin
  if (hreset_n23 == 1'b0) begin
    apb_state23   <= apb_state_idle23;
    psel_vector23 <= 1'b0;
    penable23     <= 1'b0;
    paddr23       <= 1'b0;
    pwrite23      <= 1'b0;
  end  
  else begin
    
    // IDLE23 -> SETUP23
    if (apb_state23 == apb_state_idle23) begin
      if (ahb_data_phase23 == 1'b1) begin
        apb_state23   <= apb_state_setup23;
        psel_vector23 <= slave_select23;
        paddr23       <= haddr_reg23;
        pwrite23      <= hwrite_reg23;
      end  
    end
    
    // SETUP23 -> TRANSFER23
    if (apb_state23 == apb_state_setup23) begin
      apb_state23 <= apb_state_access23;
      penable23   <= 1'b1;
    end
    
    // TRANSFER23 -> SETUP23 or
    // TRANSFER23 -> IDLE23
    if (apb_state23 == apb_state_access23) begin
      if (pready_muxed23 == 1'b1) begin
      
        // TRANSFER23 -> SETUP23
        if (valid_ahb_trans23 == 1'b1) begin
          apb_state23   <= apb_state_setup23;
          penable23     <= 1'b0;
          psel_vector23 <= slave_select23;
          paddr23       <= haddr_reg23;
          pwrite23      <= hwrite_reg23;
        end  
        
        // TRANSFER23 -> IDLE23
        else begin
          apb_state23   <= apb_state_idle23;      
          penable23     <= 1'b0;
          psel_vector23 <= 'b0;
        end  
      end
    end
    
  end
end

always @(posedge hclk23 or negedge hreset_n23) begin
  if (hreset_n23 == 1'b0)
    slave_select23 <= 'b0;
  else begin  
  `ifdef APB_SLAVE023
     slave_select23[0]   <= valid_ahb_trans23 && (haddr23 >= APB_SLAVE0_START_ADDR23)  && (haddr23 <= APB_SLAVE0_END_ADDR23);
   `else
     slave_select23[0]   <= 1'b0;
   `endif
   
   `ifdef APB_SLAVE123
     slave_select23[1]   <= valid_ahb_trans23 && (haddr23 >= APB_SLAVE1_START_ADDR23)  && (haddr23 <= APB_SLAVE1_END_ADDR23);
   `else
     slave_select23[1]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE223  
     slave_select23[2]   <= valid_ahb_trans23 && (haddr23 >= APB_SLAVE2_START_ADDR23)  && (haddr23 <= APB_SLAVE2_END_ADDR23);
   `else
     slave_select23[2]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE323  
     slave_select23[3]   <= valid_ahb_trans23 && (haddr23 >= APB_SLAVE3_START_ADDR23)  && (haddr23 <= APB_SLAVE3_END_ADDR23);
   `else
     slave_select23[3]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE423  
     slave_select23[4]   <= valid_ahb_trans23 && (haddr23 >= APB_SLAVE4_START_ADDR23)  && (haddr23 <= APB_SLAVE4_END_ADDR23);
   `else
     slave_select23[4]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE523  
     slave_select23[5]   <= valid_ahb_trans23 && (haddr23 >= APB_SLAVE5_START_ADDR23)  && (haddr23 <= APB_SLAVE5_END_ADDR23);
   `else
     slave_select23[5]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE623  
     slave_select23[6]   <= valid_ahb_trans23 && (haddr23 >= APB_SLAVE6_START_ADDR23)  && (haddr23 <= APB_SLAVE6_END_ADDR23);
   `else
     slave_select23[6]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE723  
     slave_select23[7]   <= valid_ahb_trans23 && (haddr23 >= APB_SLAVE7_START_ADDR23)  && (haddr23 <= APB_SLAVE7_END_ADDR23);
   `else
     slave_select23[7]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE823  
     slave_select23[8]   <= valid_ahb_trans23 && (haddr23 >= APB_SLAVE8_START_ADDR23)  && (haddr23 <= APB_SLAVE8_END_ADDR23);
   `else
     slave_select23[8]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE923  
     slave_select23[9]   <= valid_ahb_trans23 && (haddr23 >= APB_SLAVE9_START_ADDR23)  && (haddr23 <= APB_SLAVE9_END_ADDR23);
   `else
     slave_select23[9]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1023  
     slave_select23[10]  <= valid_ahb_trans23 && (haddr23 >= APB_SLAVE10_START_ADDR23) && (haddr23 <= APB_SLAVE10_END_ADDR23);
   `else
     slave_select23[10]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1123  
     slave_select23[11]  <= valid_ahb_trans23 && (haddr23 >= APB_SLAVE11_START_ADDR23) && (haddr23 <= APB_SLAVE11_END_ADDR23);
   `else
     slave_select23[11]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1223  
     slave_select23[12]  <= valid_ahb_trans23 && (haddr23 >= APB_SLAVE12_START_ADDR23) && (haddr23 <= APB_SLAVE12_END_ADDR23);
   `else
     slave_select23[12]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1323  
     slave_select23[13]  <= valid_ahb_trans23 && (haddr23 >= APB_SLAVE13_START_ADDR23) && (haddr23 <= APB_SLAVE13_END_ADDR23);
   `else
     slave_select23[13]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1423  
     slave_select23[14]  <= valid_ahb_trans23 && (haddr23 >= APB_SLAVE14_START_ADDR23) && (haddr23 <= APB_SLAVE14_END_ADDR23);
   `else
     slave_select23[14]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1523  
     slave_select23[15]  <= valid_ahb_trans23 && (haddr23 >= APB_SLAVE15_START_ADDR23) && (haddr23 <= APB_SLAVE15_END_ADDR23);
   `else
     slave_select23[15]   <= 1'b0;
   `endif  
  end
end

assign pready_muxed23 = |(psel_vector23 & pready_vector23);
assign prdata_muxed23 = prdata0_q23  | prdata1_q23  | prdata2_q23  | prdata3_q23  |
                      prdata4_q23  | prdata5_q23  | prdata6_q23  | prdata7_q23  |
                      prdata8_q23  | prdata9_q23  | prdata10_q23 | prdata11_q23 |
                      prdata12_q23 | prdata13_q23 | prdata14_q23 | prdata15_q23 ;

`ifdef APB_SLAVE023
  assign psel023            = psel_vector23[0];
  assign pready_vector23[0] = pready023;
  assign prdata0_q23        = (psel023 == 1'b1) ? prdata023 : 'b0;
`else
  assign pready_vector23[0] = 1'b0;
  assign prdata0_q23        = 'b0;
`endif

`ifdef APB_SLAVE123
  assign psel123            = psel_vector23[1];
  assign pready_vector23[1] = pready123;
  assign prdata1_q23        = (psel123 == 1'b1) ? prdata123 : 'b0;
`else
  assign pready_vector23[1] = 1'b0;
  assign prdata1_q23        = 'b0;
`endif

`ifdef APB_SLAVE223
  assign psel223            = psel_vector23[2];
  assign pready_vector23[2] = pready223;
  assign prdata2_q23        = (psel223 == 1'b1) ? prdata223 : 'b0;
`else
  assign pready_vector23[2] = 1'b0;
  assign prdata2_q23        = 'b0;
`endif

`ifdef APB_SLAVE323
  assign psel323            = psel_vector23[3];
  assign pready_vector23[3] = pready323;
  assign prdata3_q23        = (psel323 == 1'b1) ? prdata323 : 'b0;
`else
  assign pready_vector23[3] = 1'b0;
  assign prdata3_q23        = 'b0;
`endif

`ifdef APB_SLAVE423
  assign psel423            = psel_vector23[4];
  assign pready_vector23[4] = pready423;
  assign prdata4_q23        = (psel423 == 1'b1) ? prdata423 : 'b0;
`else
  assign pready_vector23[4] = 1'b0;
  assign prdata4_q23        = 'b0;
`endif

`ifdef APB_SLAVE523
  assign psel523            = psel_vector23[5];
  assign pready_vector23[5] = pready523;
  assign prdata5_q23        = (psel523 == 1'b1) ? prdata523 : 'b0;
`else
  assign pready_vector23[5] = 1'b0;
  assign prdata5_q23        = 'b0;
`endif

`ifdef APB_SLAVE623
  assign psel623            = psel_vector23[6];
  assign pready_vector23[6] = pready623;
  assign prdata6_q23        = (psel623 == 1'b1) ? prdata623 : 'b0;
`else
  assign pready_vector23[6] = 1'b0;
  assign prdata6_q23        = 'b0;
`endif

`ifdef APB_SLAVE723
  assign psel723            = psel_vector23[7];
  assign pready_vector23[7] = pready723;
  assign prdata7_q23        = (psel723 == 1'b1) ? prdata723 : 'b0;
`else
  assign pready_vector23[7] = 1'b0;
  assign prdata7_q23        = 'b0;
`endif

`ifdef APB_SLAVE823
  assign psel823            = psel_vector23[8];
  assign pready_vector23[8] = pready823;
  assign prdata8_q23        = (psel823 == 1'b1) ? prdata823 : 'b0;
`else
  assign pready_vector23[8] = 1'b0;
  assign prdata8_q23        = 'b0;
`endif

`ifdef APB_SLAVE923
  assign psel923            = psel_vector23[9];
  assign pready_vector23[9] = pready923;
  assign prdata9_q23        = (psel923 == 1'b1) ? prdata923 : 'b0;
`else
  assign pready_vector23[9] = 1'b0;
  assign prdata9_q23        = 'b0;
`endif

`ifdef APB_SLAVE1023
  assign psel1023            = psel_vector23[10];
  assign pready_vector23[10] = pready1023;
  assign prdata10_q23        = (psel1023 == 1'b1) ? prdata1023 : 'b0;
`else
  assign pready_vector23[10] = 1'b0;
  assign prdata10_q23        = 'b0;
`endif

`ifdef APB_SLAVE1123
  assign psel1123            = psel_vector23[11];
  assign pready_vector23[11] = pready1123;
  assign prdata11_q23        = (psel1123 == 1'b1) ? prdata1123 : 'b0;
`else
  assign pready_vector23[11] = 1'b0;
  assign prdata11_q23        = 'b0;
`endif

`ifdef APB_SLAVE1223
  assign psel1223            = psel_vector23[12];
  assign pready_vector23[12] = pready1223;
  assign prdata12_q23        = (psel1223 == 1'b1) ? prdata1223 : 'b0;
`else
  assign pready_vector23[12] = 1'b0;
  assign prdata12_q23        = 'b0;
`endif

`ifdef APB_SLAVE1323
  assign psel1323            = psel_vector23[13];
  assign pready_vector23[13] = pready1323;
  assign prdata13_q23        = (psel1323 == 1'b1) ? prdata1323 : 'b0;
`else
  assign pready_vector23[13] = 1'b0;
  assign prdata13_q23        = 'b0;
`endif

`ifdef APB_SLAVE1423
  assign psel1423            = psel_vector23[14];
  assign pready_vector23[14] = pready1423;
  assign prdata14_q23        = (psel1423 == 1'b1) ? prdata1423 : 'b0;
`else
  assign pready_vector23[14] = 1'b0;
  assign prdata14_q23        = 'b0;
`endif

`ifdef APB_SLAVE1523
  assign psel1523            = psel_vector23[15];
  assign pready_vector23[15] = pready1523;
  assign prdata15_q23        = (psel1523 == 1'b1) ? prdata1523 : 'b0;
`else
  assign pready_vector23[15] = 1'b0;
  assign prdata15_q23        = 'b0;
`endif

endmodule
