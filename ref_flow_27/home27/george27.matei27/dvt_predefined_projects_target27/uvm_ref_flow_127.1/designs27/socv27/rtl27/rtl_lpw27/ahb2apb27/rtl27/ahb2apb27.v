//File27 name   : ahb2apb27.v
//Title27       : 
//Created27     : 2010
//Description27 : Simple27 AHB27 to APB27 bridge27
//Notes27       : 
//----------------------------------------------------------------------
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------

`timescale 1ns/1ps

`include "ahb2apb_defines27.v"

module ahb2apb27
(
  // AHB27 signals27
  hclk27,
  hreset_n27,
  hsel27,
  haddr27,
  htrans27,
  hwdata27,
  hwrite27,
  hrdata27,
  hready27,
  hresp27,
  
  // APB27 signals27 common to all APB27 slaves27
  pclk27,
  preset_n27,
  paddr27,
  penable27,
  pwrite27,
  pwdata27
  
  // Slave27 0 signals27
  `ifdef APB_SLAVE027
  ,psel027
  ,pready027
  ,prdata027
  `endif
  
  // Slave27 1 signals27
  `ifdef APB_SLAVE127
  ,psel127
  ,pready127
  ,prdata127
  `endif
  
  // Slave27 2 signals27
  `ifdef APB_SLAVE227
  ,psel227
  ,pready227
  ,prdata227
  `endif
  
  // Slave27 3 signals27
  `ifdef APB_SLAVE327
  ,psel327
  ,pready327
  ,prdata327
  `endif
  
  // Slave27 4 signals27
  `ifdef APB_SLAVE427
  ,psel427
  ,pready427
  ,prdata427
  `endif
  
  // Slave27 5 signals27
  `ifdef APB_SLAVE527
  ,psel527
  ,pready527
  ,prdata527
  `endif
  
  // Slave27 6 signals27
  `ifdef APB_SLAVE627
  ,psel627
  ,pready627
  ,prdata627
  `endif
  
  // Slave27 7 signals27
  `ifdef APB_SLAVE727
  ,psel727
  ,pready727
  ,prdata727
  `endif
  
  // Slave27 8 signals27
  `ifdef APB_SLAVE827
  ,psel827
  ,pready827
  ,prdata827
  `endif
  
  // Slave27 9 signals27
  `ifdef APB_SLAVE927
  ,psel927
  ,pready927
  ,prdata927
  `endif
  
  // Slave27 10 signals27
  `ifdef APB_SLAVE1027
  ,psel1027
  ,pready1027
  ,prdata1027
  `endif
  
  // Slave27 11 signals27
  `ifdef APB_SLAVE1127
  ,psel1127
  ,pready1127
  ,prdata1127
  `endif
  
  // Slave27 12 signals27
  `ifdef APB_SLAVE1227
  ,psel1227
  ,pready1227
  ,prdata1227
  `endif
  
  // Slave27 13 signals27
  `ifdef APB_SLAVE1327
  ,psel1327
  ,pready1327
  ,prdata1327
  `endif
  
  // Slave27 14 signals27
  `ifdef APB_SLAVE1427
  ,psel1427
  ,pready1427
  ,prdata1427
  `endif
  
  // Slave27 15 signals27
  `ifdef APB_SLAVE1527
  ,psel1527
  ,pready1527
  ,prdata1527
  `endif
  
);

parameter 
  APB_SLAVE0_START_ADDR27  = 32'h00000000,
  APB_SLAVE0_END_ADDR27    = 32'h00000000,
  APB_SLAVE1_START_ADDR27  = 32'h00000000,
  APB_SLAVE1_END_ADDR27    = 32'h00000000,
  APB_SLAVE2_START_ADDR27  = 32'h00000000,
  APB_SLAVE2_END_ADDR27    = 32'h00000000,
  APB_SLAVE3_START_ADDR27  = 32'h00000000,
  APB_SLAVE3_END_ADDR27    = 32'h00000000,
  APB_SLAVE4_START_ADDR27  = 32'h00000000,
  APB_SLAVE4_END_ADDR27    = 32'h00000000,
  APB_SLAVE5_START_ADDR27  = 32'h00000000,
  APB_SLAVE5_END_ADDR27    = 32'h00000000,
  APB_SLAVE6_START_ADDR27  = 32'h00000000,
  APB_SLAVE6_END_ADDR27    = 32'h00000000,
  APB_SLAVE7_START_ADDR27  = 32'h00000000,
  APB_SLAVE7_END_ADDR27    = 32'h00000000,
  APB_SLAVE8_START_ADDR27  = 32'h00000000,
  APB_SLAVE8_END_ADDR27    = 32'h00000000,
  APB_SLAVE9_START_ADDR27  = 32'h00000000,
  APB_SLAVE9_END_ADDR27    = 32'h00000000,
  APB_SLAVE10_START_ADDR27  = 32'h00000000,
  APB_SLAVE10_END_ADDR27    = 32'h00000000,
  APB_SLAVE11_START_ADDR27  = 32'h00000000,
  APB_SLAVE11_END_ADDR27    = 32'h00000000,
  APB_SLAVE12_START_ADDR27  = 32'h00000000,
  APB_SLAVE12_END_ADDR27    = 32'h00000000,
  APB_SLAVE13_START_ADDR27  = 32'h00000000,
  APB_SLAVE13_END_ADDR27    = 32'h00000000,
  APB_SLAVE14_START_ADDR27  = 32'h00000000,
  APB_SLAVE14_END_ADDR27    = 32'h00000000,
  APB_SLAVE15_START_ADDR27  = 32'h00000000,
  APB_SLAVE15_END_ADDR27    = 32'h00000000;

  // AHB27 signals27
input        hclk27;
input        hreset_n27;
input        hsel27;
input[31:0]  haddr27;
input[1:0]   htrans27;
input[31:0]  hwdata27;
input        hwrite27;
output[31:0] hrdata27;
reg   [31:0] hrdata27;
output       hready27;
output[1:0]  hresp27;
  
  // APB27 signals27 common to all APB27 slaves27
input       pclk27;
input       preset_n27;
output[31:0] paddr27;
reg   [31:0] paddr27;
output       penable27;
reg          penable27;
output       pwrite27;
reg          pwrite27;
output[31:0] pwdata27;
  
  // Slave27 0 signals27
`ifdef APB_SLAVE027
  output      psel027;
  input       pready027;
  input[31:0] prdata027;
`endif
  
  // Slave27 1 signals27
`ifdef APB_SLAVE127
  output      psel127;
  input       pready127;
  input[31:0] prdata127;
`endif
  
  // Slave27 2 signals27
`ifdef APB_SLAVE227
  output      psel227;
  input       pready227;
  input[31:0] prdata227;
`endif
  
  // Slave27 3 signals27
`ifdef APB_SLAVE327
  output      psel327;
  input       pready327;
  input[31:0] prdata327;
`endif
  
  // Slave27 4 signals27
`ifdef APB_SLAVE427
  output      psel427;
  input       pready427;
  input[31:0] prdata427;
`endif
  
  // Slave27 5 signals27
`ifdef APB_SLAVE527
  output      psel527;
  input       pready527;
  input[31:0] prdata527;
`endif
  
  // Slave27 6 signals27
`ifdef APB_SLAVE627
  output      psel627;
  input       pready627;
  input[31:0] prdata627;
`endif
  
  // Slave27 7 signals27
`ifdef APB_SLAVE727
  output      psel727;
  input       pready727;
  input[31:0] prdata727;
`endif
  
  // Slave27 8 signals27
`ifdef APB_SLAVE827
  output      psel827;
  input       pready827;
  input[31:0] prdata827;
`endif
  
  // Slave27 9 signals27
`ifdef APB_SLAVE927
  output      psel927;
  input       pready927;
  input[31:0] prdata927;
`endif
  
  // Slave27 10 signals27
`ifdef APB_SLAVE1027
  output      psel1027;
  input       pready1027;
  input[31:0] prdata1027;
`endif
  
  // Slave27 11 signals27
`ifdef APB_SLAVE1127
  output      psel1127;
  input       pready1127;
  input[31:0] prdata1127;
`endif
  
  // Slave27 12 signals27
`ifdef APB_SLAVE1227
  output      psel1227;
  input       pready1227;
  input[31:0] prdata1227;
`endif
  
  // Slave27 13 signals27
`ifdef APB_SLAVE1327
  output      psel1327;
  input       pready1327;
  input[31:0] prdata1327;
`endif
  
  // Slave27 14 signals27
`ifdef APB_SLAVE1427
  output      psel1427;
  input       pready1427;
  input[31:0] prdata1427;
`endif
  
  // Slave27 15 signals27
`ifdef APB_SLAVE1527
  output      psel1527;
  input       pready1527;
  input[31:0] prdata1527;
`endif
 
reg         ahb_addr_phase27;
reg         ahb_data_phase27;
wire        valid_ahb_trans27;
wire        pready_muxed27;
wire [31:0] prdata_muxed27;
reg  [31:0] haddr_reg27;
reg         hwrite_reg27;
reg  [2:0]  apb_state27;
wire [2:0]  apb_state_idle27;
wire [2:0]  apb_state_setup27;
wire [2:0]  apb_state_access27;
reg  [15:0] slave_select27;
wire [15:0] pready_vector27;
reg  [15:0] psel_vector27;
wire [31:0] prdata0_q27;
wire [31:0] prdata1_q27;
wire [31:0] prdata2_q27;
wire [31:0] prdata3_q27;
wire [31:0] prdata4_q27;
wire [31:0] prdata5_q27;
wire [31:0] prdata6_q27;
wire [31:0] prdata7_q27;
wire [31:0] prdata8_q27;
wire [31:0] prdata9_q27;
wire [31:0] prdata10_q27;
wire [31:0] prdata11_q27;
wire [31:0] prdata12_q27;
wire [31:0] prdata13_q27;
wire [31:0] prdata14_q27;
wire [31:0] prdata15_q27;

// assign pclk27     = hclk27;
// assign preset_n27 = hreset_n27;
assign hready27   = ahb_addr_phase27;
assign pwdata27   = hwdata27;
assign hresp27  = 2'b00;

// Respond27 to NONSEQ27 or SEQ transfers27
assign valid_ahb_trans27 = ((htrans27 == 2'b10) || (htrans27 == 2'b11)) && (hsel27 == 1'b1);

always @(posedge hclk27) begin
  if (hreset_n27 == 1'b0) begin
    ahb_addr_phase27 <= 1'b1;
    ahb_data_phase27 <= 1'b0;
    haddr_reg27      <= 'b0;
    hwrite_reg27     <= 1'b0;
    hrdata27         <= 'b0;
  end
  else begin
    if (ahb_addr_phase27 == 1'b1 && valid_ahb_trans27 == 1'b1) begin
      ahb_addr_phase27 <= 1'b0;
      ahb_data_phase27 <= 1'b1;
      haddr_reg27      <= haddr27;
      hwrite_reg27     <= hwrite27;
    end
    if (ahb_data_phase27 == 1'b1 && pready_muxed27 == 1'b1 && apb_state27 == apb_state_access27) begin
      ahb_addr_phase27 <= 1'b1;
      ahb_data_phase27 <= 1'b0;
      hrdata27         <= prdata_muxed27;
    end
  end
end

// APB27 state machine27 state definitions27
assign apb_state_idle27   = 3'b001;
assign apb_state_setup27  = 3'b010;
assign apb_state_access27 = 3'b100;

// APB27 state machine27
always @(posedge hclk27 or negedge hreset_n27) begin
  if (hreset_n27 == 1'b0) begin
    apb_state27   <= apb_state_idle27;
    psel_vector27 <= 1'b0;
    penable27     <= 1'b0;
    paddr27       <= 1'b0;
    pwrite27      <= 1'b0;
  end  
  else begin
    
    // IDLE27 -> SETUP27
    if (apb_state27 == apb_state_idle27) begin
      if (ahb_data_phase27 == 1'b1) begin
        apb_state27   <= apb_state_setup27;
        psel_vector27 <= slave_select27;
        paddr27       <= haddr_reg27;
        pwrite27      <= hwrite_reg27;
      end  
    end
    
    // SETUP27 -> TRANSFER27
    if (apb_state27 == apb_state_setup27) begin
      apb_state27 <= apb_state_access27;
      penable27   <= 1'b1;
    end
    
    // TRANSFER27 -> SETUP27 or
    // TRANSFER27 -> IDLE27
    if (apb_state27 == apb_state_access27) begin
      if (pready_muxed27 == 1'b1) begin
      
        // TRANSFER27 -> SETUP27
        if (valid_ahb_trans27 == 1'b1) begin
          apb_state27   <= apb_state_setup27;
          penable27     <= 1'b0;
          psel_vector27 <= slave_select27;
          paddr27       <= haddr_reg27;
          pwrite27      <= hwrite_reg27;
        end  
        
        // TRANSFER27 -> IDLE27
        else begin
          apb_state27   <= apb_state_idle27;      
          penable27     <= 1'b0;
          psel_vector27 <= 'b0;
        end  
      end
    end
    
  end
end

always @(posedge hclk27 or negedge hreset_n27) begin
  if (hreset_n27 == 1'b0)
    slave_select27 <= 'b0;
  else begin  
  `ifdef APB_SLAVE027
     slave_select27[0]   <= valid_ahb_trans27 && (haddr27 >= APB_SLAVE0_START_ADDR27)  && (haddr27 <= APB_SLAVE0_END_ADDR27);
   `else
     slave_select27[0]   <= 1'b0;
   `endif
   
   `ifdef APB_SLAVE127
     slave_select27[1]   <= valid_ahb_trans27 && (haddr27 >= APB_SLAVE1_START_ADDR27)  && (haddr27 <= APB_SLAVE1_END_ADDR27);
   `else
     slave_select27[1]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE227  
     slave_select27[2]   <= valid_ahb_trans27 && (haddr27 >= APB_SLAVE2_START_ADDR27)  && (haddr27 <= APB_SLAVE2_END_ADDR27);
   `else
     slave_select27[2]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE327  
     slave_select27[3]   <= valid_ahb_trans27 && (haddr27 >= APB_SLAVE3_START_ADDR27)  && (haddr27 <= APB_SLAVE3_END_ADDR27);
   `else
     slave_select27[3]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE427  
     slave_select27[4]   <= valid_ahb_trans27 && (haddr27 >= APB_SLAVE4_START_ADDR27)  && (haddr27 <= APB_SLAVE4_END_ADDR27);
   `else
     slave_select27[4]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE527  
     slave_select27[5]   <= valid_ahb_trans27 && (haddr27 >= APB_SLAVE5_START_ADDR27)  && (haddr27 <= APB_SLAVE5_END_ADDR27);
   `else
     slave_select27[5]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE627  
     slave_select27[6]   <= valid_ahb_trans27 && (haddr27 >= APB_SLAVE6_START_ADDR27)  && (haddr27 <= APB_SLAVE6_END_ADDR27);
   `else
     slave_select27[6]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE727  
     slave_select27[7]   <= valid_ahb_trans27 && (haddr27 >= APB_SLAVE7_START_ADDR27)  && (haddr27 <= APB_SLAVE7_END_ADDR27);
   `else
     slave_select27[7]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE827  
     slave_select27[8]   <= valid_ahb_trans27 && (haddr27 >= APB_SLAVE8_START_ADDR27)  && (haddr27 <= APB_SLAVE8_END_ADDR27);
   `else
     slave_select27[8]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE927  
     slave_select27[9]   <= valid_ahb_trans27 && (haddr27 >= APB_SLAVE9_START_ADDR27)  && (haddr27 <= APB_SLAVE9_END_ADDR27);
   `else
     slave_select27[9]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1027  
     slave_select27[10]  <= valid_ahb_trans27 && (haddr27 >= APB_SLAVE10_START_ADDR27) && (haddr27 <= APB_SLAVE10_END_ADDR27);
   `else
     slave_select27[10]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1127  
     slave_select27[11]  <= valid_ahb_trans27 && (haddr27 >= APB_SLAVE11_START_ADDR27) && (haddr27 <= APB_SLAVE11_END_ADDR27);
   `else
     slave_select27[11]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1227  
     slave_select27[12]  <= valid_ahb_trans27 && (haddr27 >= APB_SLAVE12_START_ADDR27) && (haddr27 <= APB_SLAVE12_END_ADDR27);
   `else
     slave_select27[12]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1327  
     slave_select27[13]  <= valid_ahb_trans27 && (haddr27 >= APB_SLAVE13_START_ADDR27) && (haddr27 <= APB_SLAVE13_END_ADDR27);
   `else
     slave_select27[13]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1427  
     slave_select27[14]  <= valid_ahb_trans27 && (haddr27 >= APB_SLAVE14_START_ADDR27) && (haddr27 <= APB_SLAVE14_END_ADDR27);
   `else
     slave_select27[14]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1527  
     slave_select27[15]  <= valid_ahb_trans27 && (haddr27 >= APB_SLAVE15_START_ADDR27) && (haddr27 <= APB_SLAVE15_END_ADDR27);
   `else
     slave_select27[15]   <= 1'b0;
   `endif  
  end
end

assign pready_muxed27 = |(psel_vector27 & pready_vector27);
assign prdata_muxed27 = prdata0_q27  | prdata1_q27  | prdata2_q27  | prdata3_q27  |
                      prdata4_q27  | prdata5_q27  | prdata6_q27  | prdata7_q27  |
                      prdata8_q27  | prdata9_q27  | prdata10_q27 | prdata11_q27 |
                      prdata12_q27 | prdata13_q27 | prdata14_q27 | prdata15_q27 ;

`ifdef APB_SLAVE027
  assign psel027            = psel_vector27[0];
  assign pready_vector27[0] = pready027;
  assign prdata0_q27        = (psel027 == 1'b1) ? prdata027 : 'b0;
`else
  assign pready_vector27[0] = 1'b0;
  assign prdata0_q27        = 'b0;
`endif

`ifdef APB_SLAVE127
  assign psel127            = psel_vector27[1];
  assign pready_vector27[1] = pready127;
  assign prdata1_q27        = (psel127 == 1'b1) ? prdata127 : 'b0;
`else
  assign pready_vector27[1] = 1'b0;
  assign prdata1_q27        = 'b0;
`endif

`ifdef APB_SLAVE227
  assign psel227            = psel_vector27[2];
  assign pready_vector27[2] = pready227;
  assign prdata2_q27        = (psel227 == 1'b1) ? prdata227 : 'b0;
`else
  assign pready_vector27[2] = 1'b0;
  assign prdata2_q27        = 'b0;
`endif

`ifdef APB_SLAVE327
  assign psel327            = psel_vector27[3];
  assign pready_vector27[3] = pready327;
  assign prdata3_q27        = (psel327 == 1'b1) ? prdata327 : 'b0;
`else
  assign pready_vector27[3] = 1'b0;
  assign prdata3_q27        = 'b0;
`endif

`ifdef APB_SLAVE427
  assign psel427            = psel_vector27[4];
  assign pready_vector27[4] = pready427;
  assign prdata4_q27        = (psel427 == 1'b1) ? prdata427 : 'b0;
`else
  assign pready_vector27[4] = 1'b0;
  assign prdata4_q27        = 'b0;
`endif

`ifdef APB_SLAVE527
  assign psel527            = psel_vector27[5];
  assign pready_vector27[5] = pready527;
  assign prdata5_q27        = (psel527 == 1'b1) ? prdata527 : 'b0;
`else
  assign pready_vector27[5] = 1'b0;
  assign prdata5_q27        = 'b0;
`endif

`ifdef APB_SLAVE627
  assign psel627            = psel_vector27[6];
  assign pready_vector27[6] = pready627;
  assign prdata6_q27        = (psel627 == 1'b1) ? prdata627 : 'b0;
`else
  assign pready_vector27[6] = 1'b0;
  assign prdata6_q27        = 'b0;
`endif

`ifdef APB_SLAVE727
  assign psel727            = psel_vector27[7];
  assign pready_vector27[7] = pready727;
  assign prdata7_q27        = (psel727 == 1'b1) ? prdata727 : 'b0;
`else
  assign pready_vector27[7] = 1'b0;
  assign prdata7_q27        = 'b0;
`endif

`ifdef APB_SLAVE827
  assign psel827            = psel_vector27[8];
  assign pready_vector27[8] = pready827;
  assign prdata8_q27        = (psel827 == 1'b1) ? prdata827 : 'b0;
`else
  assign pready_vector27[8] = 1'b0;
  assign prdata8_q27        = 'b0;
`endif

`ifdef APB_SLAVE927
  assign psel927            = psel_vector27[9];
  assign pready_vector27[9] = pready927;
  assign prdata9_q27        = (psel927 == 1'b1) ? prdata927 : 'b0;
`else
  assign pready_vector27[9] = 1'b0;
  assign prdata9_q27        = 'b0;
`endif

`ifdef APB_SLAVE1027
  assign psel1027            = psel_vector27[10];
  assign pready_vector27[10] = pready1027;
  assign prdata10_q27        = (psel1027 == 1'b1) ? prdata1027 : 'b0;
`else
  assign pready_vector27[10] = 1'b0;
  assign prdata10_q27        = 'b0;
`endif

`ifdef APB_SLAVE1127
  assign psel1127            = psel_vector27[11];
  assign pready_vector27[11] = pready1127;
  assign prdata11_q27        = (psel1127 == 1'b1) ? prdata1127 : 'b0;
`else
  assign pready_vector27[11] = 1'b0;
  assign prdata11_q27        = 'b0;
`endif

`ifdef APB_SLAVE1227
  assign psel1227            = psel_vector27[12];
  assign pready_vector27[12] = pready1227;
  assign prdata12_q27        = (psel1227 == 1'b1) ? prdata1227 : 'b0;
`else
  assign pready_vector27[12] = 1'b0;
  assign prdata12_q27        = 'b0;
`endif

`ifdef APB_SLAVE1327
  assign psel1327            = psel_vector27[13];
  assign pready_vector27[13] = pready1327;
  assign prdata13_q27        = (psel1327 == 1'b1) ? prdata1327 : 'b0;
`else
  assign pready_vector27[13] = 1'b0;
  assign prdata13_q27        = 'b0;
`endif

`ifdef APB_SLAVE1427
  assign psel1427            = psel_vector27[14];
  assign pready_vector27[14] = pready1427;
  assign prdata14_q27        = (psel1427 == 1'b1) ? prdata1427 : 'b0;
`else
  assign pready_vector27[14] = 1'b0;
  assign prdata14_q27        = 'b0;
`endif

`ifdef APB_SLAVE1527
  assign psel1527            = psel_vector27[15];
  assign pready_vector27[15] = pready1527;
  assign prdata15_q27        = (psel1527 == 1'b1) ? prdata1527 : 'b0;
`else
  assign pready_vector27[15] = 1'b0;
  assign prdata15_q27        = 'b0;
`endif

endmodule
