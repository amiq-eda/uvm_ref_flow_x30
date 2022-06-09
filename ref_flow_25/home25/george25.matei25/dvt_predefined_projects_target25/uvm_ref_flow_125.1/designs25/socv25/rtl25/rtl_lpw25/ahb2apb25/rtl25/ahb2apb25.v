//File25 name   : ahb2apb25.v
//Title25       : 
//Created25     : 2010
//Description25 : Simple25 AHB25 to APB25 bridge25
//Notes25       : 
//----------------------------------------------------------------------
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------

`timescale 1ns/1ps

`include "ahb2apb_defines25.v"

module ahb2apb25
(
  // AHB25 signals25
  hclk25,
  hreset_n25,
  hsel25,
  haddr25,
  htrans25,
  hwdata25,
  hwrite25,
  hrdata25,
  hready25,
  hresp25,
  
  // APB25 signals25 common to all APB25 slaves25
  pclk25,
  preset_n25,
  paddr25,
  penable25,
  pwrite25,
  pwdata25
  
  // Slave25 0 signals25
  `ifdef APB_SLAVE025
  ,psel025
  ,pready025
  ,prdata025
  `endif
  
  // Slave25 1 signals25
  `ifdef APB_SLAVE125
  ,psel125
  ,pready125
  ,prdata125
  `endif
  
  // Slave25 2 signals25
  `ifdef APB_SLAVE225
  ,psel225
  ,pready225
  ,prdata225
  `endif
  
  // Slave25 3 signals25
  `ifdef APB_SLAVE325
  ,psel325
  ,pready325
  ,prdata325
  `endif
  
  // Slave25 4 signals25
  `ifdef APB_SLAVE425
  ,psel425
  ,pready425
  ,prdata425
  `endif
  
  // Slave25 5 signals25
  `ifdef APB_SLAVE525
  ,psel525
  ,pready525
  ,prdata525
  `endif
  
  // Slave25 6 signals25
  `ifdef APB_SLAVE625
  ,psel625
  ,pready625
  ,prdata625
  `endif
  
  // Slave25 7 signals25
  `ifdef APB_SLAVE725
  ,psel725
  ,pready725
  ,prdata725
  `endif
  
  // Slave25 8 signals25
  `ifdef APB_SLAVE825
  ,psel825
  ,pready825
  ,prdata825
  `endif
  
  // Slave25 9 signals25
  `ifdef APB_SLAVE925
  ,psel925
  ,pready925
  ,prdata925
  `endif
  
  // Slave25 10 signals25
  `ifdef APB_SLAVE1025
  ,psel1025
  ,pready1025
  ,prdata1025
  `endif
  
  // Slave25 11 signals25
  `ifdef APB_SLAVE1125
  ,psel1125
  ,pready1125
  ,prdata1125
  `endif
  
  // Slave25 12 signals25
  `ifdef APB_SLAVE1225
  ,psel1225
  ,pready1225
  ,prdata1225
  `endif
  
  // Slave25 13 signals25
  `ifdef APB_SLAVE1325
  ,psel1325
  ,pready1325
  ,prdata1325
  `endif
  
  // Slave25 14 signals25
  `ifdef APB_SLAVE1425
  ,psel1425
  ,pready1425
  ,prdata1425
  `endif
  
  // Slave25 15 signals25
  `ifdef APB_SLAVE1525
  ,psel1525
  ,pready1525
  ,prdata1525
  `endif
  
);

parameter 
  APB_SLAVE0_START_ADDR25  = 32'h00000000,
  APB_SLAVE0_END_ADDR25    = 32'h00000000,
  APB_SLAVE1_START_ADDR25  = 32'h00000000,
  APB_SLAVE1_END_ADDR25    = 32'h00000000,
  APB_SLAVE2_START_ADDR25  = 32'h00000000,
  APB_SLAVE2_END_ADDR25    = 32'h00000000,
  APB_SLAVE3_START_ADDR25  = 32'h00000000,
  APB_SLAVE3_END_ADDR25    = 32'h00000000,
  APB_SLAVE4_START_ADDR25  = 32'h00000000,
  APB_SLAVE4_END_ADDR25    = 32'h00000000,
  APB_SLAVE5_START_ADDR25  = 32'h00000000,
  APB_SLAVE5_END_ADDR25    = 32'h00000000,
  APB_SLAVE6_START_ADDR25  = 32'h00000000,
  APB_SLAVE6_END_ADDR25    = 32'h00000000,
  APB_SLAVE7_START_ADDR25  = 32'h00000000,
  APB_SLAVE7_END_ADDR25    = 32'h00000000,
  APB_SLAVE8_START_ADDR25  = 32'h00000000,
  APB_SLAVE8_END_ADDR25    = 32'h00000000,
  APB_SLAVE9_START_ADDR25  = 32'h00000000,
  APB_SLAVE9_END_ADDR25    = 32'h00000000,
  APB_SLAVE10_START_ADDR25  = 32'h00000000,
  APB_SLAVE10_END_ADDR25    = 32'h00000000,
  APB_SLAVE11_START_ADDR25  = 32'h00000000,
  APB_SLAVE11_END_ADDR25    = 32'h00000000,
  APB_SLAVE12_START_ADDR25  = 32'h00000000,
  APB_SLAVE12_END_ADDR25    = 32'h00000000,
  APB_SLAVE13_START_ADDR25  = 32'h00000000,
  APB_SLAVE13_END_ADDR25    = 32'h00000000,
  APB_SLAVE14_START_ADDR25  = 32'h00000000,
  APB_SLAVE14_END_ADDR25    = 32'h00000000,
  APB_SLAVE15_START_ADDR25  = 32'h00000000,
  APB_SLAVE15_END_ADDR25    = 32'h00000000;

  // AHB25 signals25
input        hclk25;
input        hreset_n25;
input        hsel25;
input[31:0]  haddr25;
input[1:0]   htrans25;
input[31:0]  hwdata25;
input        hwrite25;
output[31:0] hrdata25;
reg   [31:0] hrdata25;
output       hready25;
output[1:0]  hresp25;
  
  // APB25 signals25 common to all APB25 slaves25
input       pclk25;
input       preset_n25;
output[31:0] paddr25;
reg   [31:0] paddr25;
output       penable25;
reg          penable25;
output       pwrite25;
reg          pwrite25;
output[31:0] pwdata25;
  
  // Slave25 0 signals25
`ifdef APB_SLAVE025
  output      psel025;
  input       pready025;
  input[31:0] prdata025;
`endif
  
  // Slave25 1 signals25
`ifdef APB_SLAVE125
  output      psel125;
  input       pready125;
  input[31:0] prdata125;
`endif
  
  // Slave25 2 signals25
`ifdef APB_SLAVE225
  output      psel225;
  input       pready225;
  input[31:0] prdata225;
`endif
  
  // Slave25 3 signals25
`ifdef APB_SLAVE325
  output      psel325;
  input       pready325;
  input[31:0] prdata325;
`endif
  
  // Slave25 4 signals25
`ifdef APB_SLAVE425
  output      psel425;
  input       pready425;
  input[31:0] prdata425;
`endif
  
  // Slave25 5 signals25
`ifdef APB_SLAVE525
  output      psel525;
  input       pready525;
  input[31:0] prdata525;
`endif
  
  // Slave25 6 signals25
`ifdef APB_SLAVE625
  output      psel625;
  input       pready625;
  input[31:0] prdata625;
`endif
  
  // Slave25 7 signals25
`ifdef APB_SLAVE725
  output      psel725;
  input       pready725;
  input[31:0] prdata725;
`endif
  
  // Slave25 8 signals25
`ifdef APB_SLAVE825
  output      psel825;
  input       pready825;
  input[31:0] prdata825;
`endif
  
  // Slave25 9 signals25
`ifdef APB_SLAVE925
  output      psel925;
  input       pready925;
  input[31:0] prdata925;
`endif
  
  // Slave25 10 signals25
`ifdef APB_SLAVE1025
  output      psel1025;
  input       pready1025;
  input[31:0] prdata1025;
`endif
  
  // Slave25 11 signals25
`ifdef APB_SLAVE1125
  output      psel1125;
  input       pready1125;
  input[31:0] prdata1125;
`endif
  
  // Slave25 12 signals25
`ifdef APB_SLAVE1225
  output      psel1225;
  input       pready1225;
  input[31:0] prdata1225;
`endif
  
  // Slave25 13 signals25
`ifdef APB_SLAVE1325
  output      psel1325;
  input       pready1325;
  input[31:0] prdata1325;
`endif
  
  // Slave25 14 signals25
`ifdef APB_SLAVE1425
  output      psel1425;
  input       pready1425;
  input[31:0] prdata1425;
`endif
  
  // Slave25 15 signals25
`ifdef APB_SLAVE1525
  output      psel1525;
  input       pready1525;
  input[31:0] prdata1525;
`endif
 
reg         ahb_addr_phase25;
reg         ahb_data_phase25;
wire        valid_ahb_trans25;
wire        pready_muxed25;
wire [31:0] prdata_muxed25;
reg  [31:0] haddr_reg25;
reg         hwrite_reg25;
reg  [2:0]  apb_state25;
wire [2:0]  apb_state_idle25;
wire [2:0]  apb_state_setup25;
wire [2:0]  apb_state_access25;
reg  [15:0] slave_select25;
wire [15:0] pready_vector25;
reg  [15:0] psel_vector25;
wire [31:0] prdata0_q25;
wire [31:0] prdata1_q25;
wire [31:0] prdata2_q25;
wire [31:0] prdata3_q25;
wire [31:0] prdata4_q25;
wire [31:0] prdata5_q25;
wire [31:0] prdata6_q25;
wire [31:0] prdata7_q25;
wire [31:0] prdata8_q25;
wire [31:0] prdata9_q25;
wire [31:0] prdata10_q25;
wire [31:0] prdata11_q25;
wire [31:0] prdata12_q25;
wire [31:0] prdata13_q25;
wire [31:0] prdata14_q25;
wire [31:0] prdata15_q25;

// assign pclk25     = hclk25;
// assign preset_n25 = hreset_n25;
assign hready25   = ahb_addr_phase25;
assign pwdata25   = hwdata25;
assign hresp25  = 2'b00;

// Respond25 to NONSEQ25 or SEQ transfers25
assign valid_ahb_trans25 = ((htrans25 == 2'b10) || (htrans25 == 2'b11)) && (hsel25 == 1'b1);

always @(posedge hclk25) begin
  if (hreset_n25 == 1'b0) begin
    ahb_addr_phase25 <= 1'b1;
    ahb_data_phase25 <= 1'b0;
    haddr_reg25      <= 'b0;
    hwrite_reg25     <= 1'b0;
    hrdata25         <= 'b0;
  end
  else begin
    if (ahb_addr_phase25 == 1'b1 && valid_ahb_trans25 == 1'b1) begin
      ahb_addr_phase25 <= 1'b0;
      ahb_data_phase25 <= 1'b1;
      haddr_reg25      <= haddr25;
      hwrite_reg25     <= hwrite25;
    end
    if (ahb_data_phase25 == 1'b1 && pready_muxed25 == 1'b1 && apb_state25 == apb_state_access25) begin
      ahb_addr_phase25 <= 1'b1;
      ahb_data_phase25 <= 1'b0;
      hrdata25         <= prdata_muxed25;
    end
  end
end

// APB25 state machine25 state definitions25
assign apb_state_idle25   = 3'b001;
assign apb_state_setup25  = 3'b010;
assign apb_state_access25 = 3'b100;

// APB25 state machine25
always @(posedge hclk25 or negedge hreset_n25) begin
  if (hreset_n25 == 1'b0) begin
    apb_state25   <= apb_state_idle25;
    psel_vector25 <= 1'b0;
    penable25     <= 1'b0;
    paddr25       <= 1'b0;
    pwrite25      <= 1'b0;
  end  
  else begin
    
    // IDLE25 -> SETUP25
    if (apb_state25 == apb_state_idle25) begin
      if (ahb_data_phase25 == 1'b1) begin
        apb_state25   <= apb_state_setup25;
        psel_vector25 <= slave_select25;
        paddr25       <= haddr_reg25;
        pwrite25      <= hwrite_reg25;
      end  
    end
    
    // SETUP25 -> TRANSFER25
    if (apb_state25 == apb_state_setup25) begin
      apb_state25 <= apb_state_access25;
      penable25   <= 1'b1;
    end
    
    // TRANSFER25 -> SETUP25 or
    // TRANSFER25 -> IDLE25
    if (apb_state25 == apb_state_access25) begin
      if (pready_muxed25 == 1'b1) begin
      
        // TRANSFER25 -> SETUP25
        if (valid_ahb_trans25 == 1'b1) begin
          apb_state25   <= apb_state_setup25;
          penable25     <= 1'b0;
          psel_vector25 <= slave_select25;
          paddr25       <= haddr_reg25;
          pwrite25      <= hwrite_reg25;
        end  
        
        // TRANSFER25 -> IDLE25
        else begin
          apb_state25   <= apb_state_idle25;      
          penable25     <= 1'b0;
          psel_vector25 <= 'b0;
        end  
      end
    end
    
  end
end

always @(posedge hclk25 or negedge hreset_n25) begin
  if (hreset_n25 == 1'b0)
    slave_select25 <= 'b0;
  else begin  
  `ifdef APB_SLAVE025
     slave_select25[0]   <= valid_ahb_trans25 && (haddr25 >= APB_SLAVE0_START_ADDR25)  && (haddr25 <= APB_SLAVE0_END_ADDR25);
   `else
     slave_select25[0]   <= 1'b0;
   `endif
   
   `ifdef APB_SLAVE125
     slave_select25[1]   <= valid_ahb_trans25 && (haddr25 >= APB_SLAVE1_START_ADDR25)  && (haddr25 <= APB_SLAVE1_END_ADDR25);
   `else
     slave_select25[1]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE225  
     slave_select25[2]   <= valid_ahb_trans25 && (haddr25 >= APB_SLAVE2_START_ADDR25)  && (haddr25 <= APB_SLAVE2_END_ADDR25);
   `else
     slave_select25[2]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE325  
     slave_select25[3]   <= valid_ahb_trans25 && (haddr25 >= APB_SLAVE3_START_ADDR25)  && (haddr25 <= APB_SLAVE3_END_ADDR25);
   `else
     slave_select25[3]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE425  
     slave_select25[4]   <= valid_ahb_trans25 && (haddr25 >= APB_SLAVE4_START_ADDR25)  && (haddr25 <= APB_SLAVE4_END_ADDR25);
   `else
     slave_select25[4]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE525  
     slave_select25[5]   <= valid_ahb_trans25 && (haddr25 >= APB_SLAVE5_START_ADDR25)  && (haddr25 <= APB_SLAVE5_END_ADDR25);
   `else
     slave_select25[5]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE625  
     slave_select25[6]   <= valid_ahb_trans25 && (haddr25 >= APB_SLAVE6_START_ADDR25)  && (haddr25 <= APB_SLAVE6_END_ADDR25);
   `else
     slave_select25[6]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE725  
     slave_select25[7]   <= valid_ahb_trans25 && (haddr25 >= APB_SLAVE7_START_ADDR25)  && (haddr25 <= APB_SLAVE7_END_ADDR25);
   `else
     slave_select25[7]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE825  
     slave_select25[8]   <= valid_ahb_trans25 && (haddr25 >= APB_SLAVE8_START_ADDR25)  && (haddr25 <= APB_SLAVE8_END_ADDR25);
   `else
     slave_select25[8]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE925  
     slave_select25[9]   <= valid_ahb_trans25 && (haddr25 >= APB_SLAVE9_START_ADDR25)  && (haddr25 <= APB_SLAVE9_END_ADDR25);
   `else
     slave_select25[9]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1025  
     slave_select25[10]  <= valid_ahb_trans25 && (haddr25 >= APB_SLAVE10_START_ADDR25) && (haddr25 <= APB_SLAVE10_END_ADDR25);
   `else
     slave_select25[10]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1125  
     slave_select25[11]  <= valid_ahb_trans25 && (haddr25 >= APB_SLAVE11_START_ADDR25) && (haddr25 <= APB_SLAVE11_END_ADDR25);
   `else
     slave_select25[11]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1225  
     slave_select25[12]  <= valid_ahb_trans25 && (haddr25 >= APB_SLAVE12_START_ADDR25) && (haddr25 <= APB_SLAVE12_END_ADDR25);
   `else
     slave_select25[12]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1325  
     slave_select25[13]  <= valid_ahb_trans25 && (haddr25 >= APB_SLAVE13_START_ADDR25) && (haddr25 <= APB_SLAVE13_END_ADDR25);
   `else
     slave_select25[13]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1425  
     slave_select25[14]  <= valid_ahb_trans25 && (haddr25 >= APB_SLAVE14_START_ADDR25) && (haddr25 <= APB_SLAVE14_END_ADDR25);
   `else
     slave_select25[14]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1525  
     slave_select25[15]  <= valid_ahb_trans25 && (haddr25 >= APB_SLAVE15_START_ADDR25) && (haddr25 <= APB_SLAVE15_END_ADDR25);
   `else
     slave_select25[15]   <= 1'b0;
   `endif  
  end
end

assign pready_muxed25 = |(psel_vector25 & pready_vector25);
assign prdata_muxed25 = prdata0_q25  | prdata1_q25  | prdata2_q25  | prdata3_q25  |
                      prdata4_q25  | prdata5_q25  | prdata6_q25  | prdata7_q25  |
                      prdata8_q25  | prdata9_q25  | prdata10_q25 | prdata11_q25 |
                      prdata12_q25 | prdata13_q25 | prdata14_q25 | prdata15_q25 ;

`ifdef APB_SLAVE025
  assign psel025            = psel_vector25[0];
  assign pready_vector25[0] = pready025;
  assign prdata0_q25        = (psel025 == 1'b1) ? prdata025 : 'b0;
`else
  assign pready_vector25[0] = 1'b0;
  assign prdata0_q25        = 'b0;
`endif

`ifdef APB_SLAVE125
  assign psel125            = psel_vector25[1];
  assign pready_vector25[1] = pready125;
  assign prdata1_q25        = (psel125 == 1'b1) ? prdata125 : 'b0;
`else
  assign pready_vector25[1] = 1'b0;
  assign prdata1_q25        = 'b0;
`endif

`ifdef APB_SLAVE225
  assign psel225            = psel_vector25[2];
  assign pready_vector25[2] = pready225;
  assign prdata2_q25        = (psel225 == 1'b1) ? prdata225 : 'b0;
`else
  assign pready_vector25[2] = 1'b0;
  assign prdata2_q25        = 'b0;
`endif

`ifdef APB_SLAVE325
  assign psel325            = psel_vector25[3];
  assign pready_vector25[3] = pready325;
  assign prdata3_q25        = (psel325 == 1'b1) ? prdata325 : 'b0;
`else
  assign pready_vector25[3] = 1'b0;
  assign prdata3_q25        = 'b0;
`endif

`ifdef APB_SLAVE425
  assign psel425            = psel_vector25[4];
  assign pready_vector25[4] = pready425;
  assign prdata4_q25        = (psel425 == 1'b1) ? prdata425 : 'b0;
`else
  assign pready_vector25[4] = 1'b0;
  assign prdata4_q25        = 'b0;
`endif

`ifdef APB_SLAVE525
  assign psel525            = psel_vector25[5];
  assign pready_vector25[5] = pready525;
  assign prdata5_q25        = (psel525 == 1'b1) ? prdata525 : 'b0;
`else
  assign pready_vector25[5] = 1'b0;
  assign prdata5_q25        = 'b0;
`endif

`ifdef APB_SLAVE625
  assign psel625            = psel_vector25[6];
  assign pready_vector25[6] = pready625;
  assign prdata6_q25        = (psel625 == 1'b1) ? prdata625 : 'b0;
`else
  assign pready_vector25[6] = 1'b0;
  assign prdata6_q25        = 'b0;
`endif

`ifdef APB_SLAVE725
  assign psel725            = psel_vector25[7];
  assign pready_vector25[7] = pready725;
  assign prdata7_q25        = (psel725 == 1'b1) ? prdata725 : 'b0;
`else
  assign pready_vector25[7] = 1'b0;
  assign prdata7_q25        = 'b0;
`endif

`ifdef APB_SLAVE825
  assign psel825            = psel_vector25[8];
  assign pready_vector25[8] = pready825;
  assign prdata8_q25        = (psel825 == 1'b1) ? prdata825 : 'b0;
`else
  assign pready_vector25[8] = 1'b0;
  assign prdata8_q25        = 'b0;
`endif

`ifdef APB_SLAVE925
  assign psel925            = psel_vector25[9];
  assign pready_vector25[9] = pready925;
  assign prdata9_q25        = (psel925 == 1'b1) ? prdata925 : 'b0;
`else
  assign pready_vector25[9] = 1'b0;
  assign prdata9_q25        = 'b0;
`endif

`ifdef APB_SLAVE1025
  assign psel1025            = psel_vector25[10];
  assign pready_vector25[10] = pready1025;
  assign prdata10_q25        = (psel1025 == 1'b1) ? prdata1025 : 'b0;
`else
  assign pready_vector25[10] = 1'b0;
  assign prdata10_q25        = 'b0;
`endif

`ifdef APB_SLAVE1125
  assign psel1125            = psel_vector25[11];
  assign pready_vector25[11] = pready1125;
  assign prdata11_q25        = (psel1125 == 1'b1) ? prdata1125 : 'b0;
`else
  assign pready_vector25[11] = 1'b0;
  assign prdata11_q25        = 'b0;
`endif

`ifdef APB_SLAVE1225
  assign psel1225            = psel_vector25[12];
  assign pready_vector25[12] = pready1225;
  assign prdata12_q25        = (psel1225 == 1'b1) ? prdata1225 : 'b0;
`else
  assign pready_vector25[12] = 1'b0;
  assign prdata12_q25        = 'b0;
`endif

`ifdef APB_SLAVE1325
  assign psel1325            = psel_vector25[13];
  assign pready_vector25[13] = pready1325;
  assign prdata13_q25        = (psel1325 == 1'b1) ? prdata1325 : 'b0;
`else
  assign pready_vector25[13] = 1'b0;
  assign prdata13_q25        = 'b0;
`endif

`ifdef APB_SLAVE1425
  assign psel1425            = psel_vector25[14];
  assign pready_vector25[14] = pready1425;
  assign prdata14_q25        = (psel1425 == 1'b1) ? prdata1425 : 'b0;
`else
  assign pready_vector25[14] = 1'b0;
  assign prdata14_q25        = 'b0;
`endif

`ifdef APB_SLAVE1525
  assign psel1525            = psel_vector25[15];
  assign pready_vector25[15] = pready1525;
  assign prdata15_q25        = (psel1525 == 1'b1) ? prdata1525 : 'b0;
`else
  assign pready_vector25[15] = 1'b0;
  assign prdata15_q25        = 'b0;
`endif

endmodule
