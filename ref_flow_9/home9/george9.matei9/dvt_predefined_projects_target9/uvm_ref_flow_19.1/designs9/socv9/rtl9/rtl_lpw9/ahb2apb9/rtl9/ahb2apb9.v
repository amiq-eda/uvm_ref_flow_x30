//File9 name   : ahb2apb9.v
//Title9       : 
//Created9     : 2010
//Description9 : Simple9 AHB9 to APB9 bridge9
//Notes9       : 
//----------------------------------------------------------------------
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------

`timescale 1ns/1ps

`include "ahb2apb_defines9.v"

module ahb2apb9
(
  // AHB9 signals9
  hclk9,
  hreset_n9,
  hsel9,
  haddr9,
  htrans9,
  hwdata9,
  hwrite9,
  hrdata9,
  hready9,
  hresp9,
  
  // APB9 signals9 common to all APB9 slaves9
  pclk9,
  preset_n9,
  paddr9,
  penable9,
  pwrite9,
  pwdata9
  
  // Slave9 0 signals9
  `ifdef APB_SLAVE09
  ,psel09
  ,pready09
  ,prdata09
  `endif
  
  // Slave9 1 signals9
  `ifdef APB_SLAVE19
  ,psel19
  ,pready19
  ,prdata19
  `endif
  
  // Slave9 2 signals9
  `ifdef APB_SLAVE29
  ,psel29
  ,pready29
  ,prdata29
  `endif
  
  // Slave9 3 signals9
  `ifdef APB_SLAVE39
  ,psel39
  ,pready39
  ,prdata39
  `endif
  
  // Slave9 4 signals9
  `ifdef APB_SLAVE49
  ,psel49
  ,pready49
  ,prdata49
  `endif
  
  // Slave9 5 signals9
  `ifdef APB_SLAVE59
  ,psel59
  ,pready59
  ,prdata59
  `endif
  
  // Slave9 6 signals9
  `ifdef APB_SLAVE69
  ,psel69
  ,pready69
  ,prdata69
  `endif
  
  // Slave9 7 signals9
  `ifdef APB_SLAVE79
  ,psel79
  ,pready79
  ,prdata79
  `endif
  
  // Slave9 8 signals9
  `ifdef APB_SLAVE89
  ,psel89
  ,pready89
  ,prdata89
  `endif
  
  // Slave9 9 signals9
  `ifdef APB_SLAVE99
  ,psel99
  ,pready99
  ,prdata99
  `endif
  
  // Slave9 10 signals9
  `ifdef APB_SLAVE109
  ,psel109
  ,pready109
  ,prdata109
  `endif
  
  // Slave9 11 signals9
  `ifdef APB_SLAVE119
  ,psel119
  ,pready119
  ,prdata119
  `endif
  
  // Slave9 12 signals9
  `ifdef APB_SLAVE129
  ,psel129
  ,pready129
  ,prdata129
  `endif
  
  // Slave9 13 signals9
  `ifdef APB_SLAVE139
  ,psel139
  ,pready139
  ,prdata139
  `endif
  
  // Slave9 14 signals9
  `ifdef APB_SLAVE149
  ,psel149
  ,pready149
  ,prdata149
  `endif
  
  // Slave9 15 signals9
  `ifdef APB_SLAVE159
  ,psel159
  ,pready159
  ,prdata159
  `endif
  
);

parameter 
  APB_SLAVE0_START_ADDR9  = 32'h00000000,
  APB_SLAVE0_END_ADDR9    = 32'h00000000,
  APB_SLAVE1_START_ADDR9  = 32'h00000000,
  APB_SLAVE1_END_ADDR9    = 32'h00000000,
  APB_SLAVE2_START_ADDR9  = 32'h00000000,
  APB_SLAVE2_END_ADDR9    = 32'h00000000,
  APB_SLAVE3_START_ADDR9  = 32'h00000000,
  APB_SLAVE3_END_ADDR9    = 32'h00000000,
  APB_SLAVE4_START_ADDR9  = 32'h00000000,
  APB_SLAVE4_END_ADDR9    = 32'h00000000,
  APB_SLAVE5_START_ADDR9  = 32'h00000000,
  APB_SLAVE5_END_ADDR9    = 32'h00000000,
  APB_SLAVE6_START_ADDR9  = 32'h00000000,
  APB_SLAVE6_END_ADDR9    = 32'h00000000,
  APB_SLAVE7_START_ADDR9  = 32'h00000000,
  APB_SLAVE7_END_ADDR9    = 32'h00000000,
  APB_SLAVE8_START_ADDR9  = 32'h00000000,
  APB_SLAVE8_END_ADDR9    = 32'h00000000,
  APB_SLAVE9_START_ADDR9  = 32'h00000000,
  APB_SLAVE9_END_ADDR9    = 32'h00000000,
  APB_SLAVE10_START_ADDR9  = 32'h00000000,
  APB_SLAVE10_END_ADDR9    = 32'h00000000,
  APB_SLAVE11_START_ADDR9  = 32'h00000000,
  APB_SLAVE11_END_ADDR9    = 32'h00000000,
  APB_SLAVE12_START_ADDR9  = 32'h00000000,
  APB_SLAVE12_END_ADDR9    = 32'h00000000,
  APB_SLAVE13_START_ADDR9  = 32'h00000000,
  APB_SLAVE13_END_ADDR9    = 32'h00000000,
  APB_SLAVE14_START_ADDR9  = 32'h00000000,
  APB_SLAVE14_END_ADDR9    = 32'h00000000,
  APB_SLAVE15_START_ADDR9  = 32'h00000000,
  APB_SLAVE15_END_ADDR9    = 32'h00000000;

  // AHB9 signals9
input        hclk9;
input        hreset_n9;
input        hsel9;
input[31:0]  haddr9;
input[1:0]   htrans9;
input[31:0]  hwdata9;
input        hwrite9;
output[31:0] hrdata9;
reg   [31:0] hrdata9;
output       hready9;
output[1:0]  hresp9;
  
  // APB9 signals9 common to all APB9 slaves9
input       pclk9;
input       preset_n9;
output[31:0] paddr9;
reg   [31:0] paddr9;
output       penable9;
reg          penable9;
output       pwrite9;
reg          pwrite9;
output[31:0] pwdata9;
  
  // Slave9 0 signals9
`ifdef APB_SLAVE09
  output      psel09;
  input       pready09;
  input[31:0] prdata09;
`endif
  
  // Slave9 1 signals9
`ifdef APB_SLAVE19
  output      psel19;
  input       pready19;
  input[31:0] prdata19;
`endif
  
  // Slave9 2 signals9
`ifdef APB_SLAVE29
  output      psel29;
  input       pready29;
  input[31:0] prdata29;
`endif
  
  // Slave9 3 signals9
`ifdef APB_SLAVE39
  output      psel39;
  input       pready39;
  input[31:0] prdata39;
`endif
  
  // Slave9 4 signals9
`ifdef APB_SLAVE49
  output      psel49;
  input       pready49;
  input[31:0] prdata49;
`endif
  
  // Slave9 5 signals9
`ifdef APB_SLAVE59
  output      psel59;
  input       pready59;
  input[31:0] prdata59;
`endif
  
  // Slave9 6 signals9
`ifdef APB_SLAVE69
  output      psel69;
  input       pready69;
  input[31:0] prdata69;
`endif
  
  // Slave9 7 signals9
`ifdef APB_SLAVE79
  output      psel79;
  input       pready79;
  input[31:0] prdata79;
`endif
  
  // Slave9 8 signals9
`ifdef APB_SLAVE89
  output      psel89;
  input       pready89;
  input[31:0] prdata89;
`endif
  
  // Slave9 9 signals9
`ifdef APB_SLAVE99
  output      psel99;
  input       pready99;
  input[31:0] prdata99;
`endif
  
  // Slave9 10 signals9
`ifdef APB_SLAVE109
  output      psel109;
  input       pready109;
  input[31:0] prdata109;
`endif
  
  // Slave9 11 signals9
`ifdef APB_SLAVE119
  output      psel119;
  input       pready119;
  input[31:0] prdata119;
`endif
  
  // Slave9 12 signals9
`ifdef APB_SLAVE129
  output      psel129;
  input       pready129;
  input[31:0] prdata129;
`endif
  
  // Slave9 13 signals9
`ifdef APB_SLAVE139
  output      psel139;
  input       pready139;
  input[31:0] prdata139;
`endif
  
  // Slave9 14 signals9
`ifdef APB_SLAVE149
  output      psel149;
  input       pready149;
  input[31:0] prdata149;
`endif
  
  // Slave9 15 signals9
`ifdef APB_SLAVE159
  output      psel159;
  input       pready159;
  input[31:0] prdata159;
`endif
 
reg         ahb_addr_phase9;
reg         ahb_data_phase9;
wire        valid_ahb_trans9;
wire        pready_muxed9;
wire [31:0] prdata_muxed9;
reg  [31:0] haddr_reg9;
reg         hwrite_reg9;
reg  [2:0]  apb_state9;
wire [2:0]  apb_state_idle9;
wire [2:0]  apb_state_setup9;
wire [2:0]  apb_state_access9;
reg  [15:0] slave_select9;
wire [15:0] pready_vector9;
reg  [15:0] psel_vector9;
wire [31:0] prdata0_q9;
wire [31:0] prdata1_q9;
wire [31:0] prdata2_q9;
wire [31:0] prdata3_q9;
wire [31:0] prdata4_q9;
wire [31:0] prdata5_q9;
wire [31:0] prdata6_q9;
wire [31:0] prdata7_q9;
wire [31:0] prdata8_q9;
wire [31:0] prdata9_q9;
wire [31:0] prdata10_q9;
wire [31:0] prdata11_q9;
wire [31:0] prdata12_q9;
wire [31:0] prdata13_q9;
wire [31:0] prdata14_q9;
wire [31:0] prdata15_q9;

// assign pclk9     = hclk9;
// assign preset_n9 = hreset_n9;
assign hready9   = ahb_addr_phase9;
assign pwdata9   = hwdata9;
assign hresp9  = 2'b00;

// Respond9 to NONSEQ9 or SEQ transfers9
assign valid_ahb_trans9 = ((htrans9 == 2'b10) || (htrans9 == 2'b11)) && (hsel9 == 1'b1);

always @(posedge hclk9) begin
  if (hreset_n9 == 1'b0) begin
    ahb_addr_phase9 <= 1'b1;
    ahb_data_phase9 <= 1'b0;
    haddr_reg9      <= 'b0;
    hwrite_reg9     <= 1'b0;
    hrdata9         <= 'b0;
  end
  else begin
    if (ahb_addr_phase9 == 1'b1 && valid_ahb_trans9 == 1'b1) begin
      ahb_addr_phase9 <= 1'b0;
      ahb_data_phase9 <= 1'b1;
      haddr_reg9      <= haddr9;
      hwrite_reg9     <= hwrite9;
    end
    if (ahb_data_phase9 == 1'b1 && pready_muxed9 == 1'b1 && apb_state9 == apb_state_access9) begin
      ahb_addr_phase9 <= 1'b1;
      ahb_data_phase9 <= 1'b0;
      hrdata9         <= prdata_muxed9;
    end
  end
end

// APB9 state machine9 state definitions9
assign apb_state_idle9   = 3'b001;
assign apb_state_setup9  = 3'b010;
assign apb_state_access9 = 3'b100;

// APB9 state machine9
always @(posedge hclk9 or negedge hreset_n9) begin
  if (hreset_n9 == 1'b0) begin
    apb_state9   <= apb_state_idle9;
    psel_vector9 <= 1'b0;
    penable9     <= 1'b0;
    paddr9       <= 1'b0;
    pwrite9      <= 1'b0;
  end  
  else begin
    
    // IDLE9 -> SETUP9
    if (apb_state9 == apb_state_idle9) begin
      if (ahb_data_phase9 == 1'b1) begin
        apb_state9   <= apb_state_setup9;
        psel_vector9 <= slave_select9;
        paddr9       <= haddr_reg9;
        pwrite9      <= hwrite_reg9;
      end  
    end
    
    // SETUP9 -> TRANSFER9
    if (apb_state9 == apb_state_setup9) begin
      apb_state9 <= apb_state_access9;
      penable9   <= 1'b1;
    end
    
    // TRANSFER9 -> SETUP9 or
    // TRANSFER9 -> IDLE9
    if (apb_state9 == apb_state_access9) begin
      if (pready_muxed9 == 1'b1) begin
      
        // TRANSFER9 -> SETUP9
        if (valid_ahb_trans9 == 1'b1) begin
          apb_state9   <= apb_state_setup9;
          penable9     <= 1'b0;
          psel_vector9 <= slave_select9;
          paddr9       <= haddr_reg9;
          pwrite9      <= hwrite_reg9;
        end  
        
        // TRANSFER9 -> IDLE9
        else begin
          apb_state9   <= apb_state_idle9;      
          penable9     <= 1'b0;
          psel_vector9 <= 'b0;
        end  
      end
    end
    
  end
end

always @(posedge hclk9 or negedge hreset_n9) begin
  if (hreset_n9 == 1'b0)
    slave_select9 <= 'b0;
  else begin  
  `ifdef APB_SLAVE09
     slave_select9[0]   <= valid_ahb_trans9 && (haddr9 >= APB_SLAVE0_START_ADDR9)  && (haddr9 <= APB_SLAVE0_END_ADDR9);
   `else
     slave_select9[0]   <= 1'b0;
   `endif
   
   `ifdef APB_SLAVE19
     slave_select9[1]   <= valid_ahb_trans9 && (haddr9 >= APB_SLAVE1_START_ADDR9)  && (haddr9 <= APB_SLAVE1_END_ADDR9);
   `else
     slave_select9[1]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE29  
     slave_select9[2]   <= valid_ahb_trans9 && (haddr9 >= APB_SLAVE2_START_ADDR9)  && (haddr9 <= APB_SLAVE2_END_ADDR9);
   `else
     slave_select9[2]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE39  
     slave_select9[3]   <= valid_ahb_trans9 && (haddr9 >= APB_SLAVE3_START_ADDR9)  && (haddr9 <= APB_SLAVE3_END_ADDR9);
   `else
     slave_select9[3]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE49  
     slave_select9[4]   <= valid_ahb_trans9 && (haddr9 >= APB_SLAVE4_START_ADDR9)  && (haddr9 <= APB_SLAVE4_END_ADDR9);
   `else
     slave_select9[4]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE59  
     slave_select9[5]   <= valid_ahb_trans9 && (haddr9 >= APB_SLAVE5_START_ADDR9)  && (haddr9 <= APB_SLAVE5_END_ADDR9);
   `else
     slave_select9[5]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE69  
     slave_select9[6]   <= valid_ahb_trans9 && (haddr9 >= APB_SLAVE6_START_ADDR9)  && (haddr9 <= APB_SLAVE6_END_ADDR9);
   `else
     slave_select9[6]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE79  
     slave_select9[7]   <= valid_ahb_trans9 && (haddr9 >= APB_SLAVE7_START_ADDR9)  && (haddr9 <= APB_SLAVE7_END_ADDR9);
   `else
     slave_select9[7]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE89  
     slave_select9[8]   <= valid_ahb_trans9 && (haddr9 >= APB_SLAVE8_START_ADDR9)  && (haddr9 <= APB_SLAVE8_END_ADDR9);
   `else
     slave_select9[8]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE99  
     slave_select9[9]   <= valid_ahb_trans9 && (haddr9 >= APB_SLAVE9_START_ADDR9)  && (haddr9 <= APB_SLAVE9_END_ADDR9);
   `else
     slave_select9[9]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE109  
     slave_select9[10]  <= valid_ahb_trans9 && (haddr9 >= APB_SLAVE10_START_ADDR9) && (haddr9 <= APB_SLAVE10_END_ADDR9);
   `else
     slave_select9[10]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE119  
     slave_select9[11]  <= valid_ahb_trans9 && (haddr9 >= APB_SLAVE11_START_ADDR9) && (haddr9 <= APB_SLAVE11_END_ADDR9);
   `else
     slave_select9[11]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE129  
     slave_select9[12]  <= valid_ahb_trans9 && (haddr9 >= APB_SLAVE12_START_ADDR9) && (haddr9 <= APB_SLAVE12_END_ADDR9);
   `else
     slave_select9[12]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE139  
     slave_select9[13]  <= valid_ahb_trans9 && (haddr9 >= APB_SLAVE13_START_ADDR9) && (haddr9 <= APB_SLAVE13_END_ADDR9);
   `else
     slave_select9[13]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE149  
     slave_select9[14]  <= valid_ahb_trans9 && (haddr9 >= APB_SLAVE14_START_ADDR9) && (haddr9 <= APB_SLAVE14_END_ADDR9);
   `else
     slave_select9[14]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE159  
     slave_select9[15]  <= valid_ahb_trans9 && (haddr9 >= APB_SLAVE15_START_ADDR9) && (haddr9 <= APB_SLAVE15_END_ADDR9);
   `else
     slave_select9[15]   <= 1'b0;
   `endif  
  end
end

assign pready_muxed9 = |(psel_vector9 & pready_vector9);
assign prdata_muxed9 = prdata0_q9  | prdata1_q9  | prdata2_q9  | prdata3_q9  |
                      prdata4_q9  | prdata5_q9  | prdata6_q9  | prdata7_q9  |
                      prdata8_q9  | prdata9_q9  | prdata10_q9 | prdata11_q9 |
                      prdata12_q9 | prdata13_q9 | prdata14_q9 | prdata15_q9 ;

`ifdef APB_SLAVE09
  assign psel09            = psel_vector9[0];
  assign pready_vector9[0] = pready09;
  assign prdata0_q9        = (psel09 == 1'b1) ? prdata09 : 'b0;
`else
  assign pready_vector9[0] = 1'b0;
  assign prdata0_q9        = 'b0;
`endif

`ifdef APB_SLAVE19
  assign psel19            = psel_vector9[1];
  assign pready_vector9[1] = pready19;
  assign prdata1_q9        = (psel19 == 1'b1) ? prdata19 : 'b0;
`else
  assign pready_vector9[1] = 1'b0;
  assign prdata1_q9        = 'b0;
`endif

`ifdef APB_SLAVE29
  assign psel29            = psel_vector9[2];
  assign pready_vector9[2] = pready29;
  assign prdata2_q9        = (psel29 == 1'b1) ? prdata29 : 'b0;
`else
  assign pready_vector9[2] = 1'b0;
  assign prdata2_q9        = 'b0;
`endif

`ifdef APB_SLAVE39
  assign psel39            = psel_vector9[3];
  assign pready_vector9[3] = pready39;
  assign prdata3_q9        = (psel39 == 1'b1) ? prdata39 : 'b0;
`else
  assign pready_vector9[3] = 1'b0;
  assign prdata3_q9        = 'b0;
`endif

`ifdef APB_SLAVE49
  assign psel49            = psel_vector9[4];
  assign pready_vector9[4] = pready49;
  assign prdata4_q9        = (psel49 == 1'b1) ? prdata49 : 'b0;
`else
  assign pready_vector9[4] = 1'b0;
  assign prdata4_q9        = 'b0;
`endif

`ifdef APB_SLAVE59
  assign psel59            = psel_vector9[5];
  assign pready_vector9[5] = pready59;
  assign prdata5_q9        = (psel59 == 1'b1) ? prdata59 : 'b0;
`else
  assign pready_vector9[5] = 1'b0;
  assign prdata5_q9        = 'b0;
`endif

`ifdef APB_SLAVE69
  assign psel69            = psel_vector9[6];
  assign pready_vector9[6] = pready69;
  assign prdata6_q9        = (psel69 == 1'b1) ? prdata69 : 'b0;
`else
  assign pready_vector9[6] = 1'b0;
  assign prdata6_q9        = 'b0;
`endif

`ifdef APB_SLAVE79
  assign psel79            = psel_vector9[7];
  assign pready_vector9[7] = pready79;
  assign prdata7_q9        = (psel79 == 1'b1) ? prdata79 : 'b0;
`else
  assign pready_vector9[7] = 1'b0;
  assign prdata7_q9        = 'b0;
`endif

`ifdef APB_SLAVE89
  assign psel89            = psel_vector9[8];
  assign pready_vector9[8] = pready89;
  assign prdata8_q9        = (psel89 == 1'b1) ? prdata89 : 'b0;
`else
  assign pready_vector9[8] = 1'b0;
  assign prdata8_q9        = 'b0;
`endif

`ifdef APB_SLAVE99
  assign psel99            = psel_vector9[9];
  assign pready_vector9[9] = pready99;
  assign prdata9_q9        = (psel99 == 1'b1) ? prdata99 : 'b0;
`else
  assign pready_vector9[9] = 1'b0;
  assign prdata9_q9        = 'b0;
`endif

`ifdef APB_SLAVE109
  assign psel109            = psel_vector9[10];
  assign pready_vector9[10] = pready109;
  assign prdata10_q9        = (psel109 == 1'b1) ? prdata109 : 'b0;
`else
  assign pready_vector9[10] = 1'b0;
  assign prdata10_q9        = 'b0;
`endif

`ifdef APB_SLAVE119
  assign psel119            = psel_vector9[11];
  assign pready_vector9[11] = pready119;
  assign prdata11_q9        = (psel119 == 1'b1) ? prdata119 : 'b0;
`else
  assign pready_vector9[11] = 1'b0;
  assign prdata11_q9        = 'b0;
`endif

`ifdef APB_SLAVE129
  assign psel129            = psel_vector9[12];
  assign pready_vector9[12] = pready129;
  assign prdata12_q9        = (psel129 == 1'b1) ? prdata129 : 'b0;
`else
  assign pready_vector9[12] = 1'b0;
  assign prdata12_q9        = 'b0;
`endif

`ifdef APB_SLAVE139
  assign psel139            = psel_vector9[13];
  assign pready_vector9[13] = pready139;
  assign prdata13_q9        = (psel139 == 1'b1) ? prdata139 : 'b0;
`else
  assign pready_vector9[13] = 1'b0;
  assign prdata13_q9        = 'b0;
`endif

`ifdef APB_SLAVE149
  assign psel149            = psel_vector9[14];
  assign pready_vector9[14] = pready149;
  assign prdata14_q9        = (psel149 == 1'b1) ? prdata149 : 'b0;
`else
  assign pready_vector9[14] = 1'b0;
  assign prdata14_q9        = 'b0;
`endif

`ifdef APB_SLAVE159
  assign psel159            = psel_vector9[15];
  assign pready_vector9[15] = pready159;
  assign prdata15_q9        = (psel159 == 1'b1) ? prdata159 : 'b0;
`else
  assign pready_vector9[15] = 1'b0;
  assign prdata15_q9        = 'b0;
`endif

endmodule
