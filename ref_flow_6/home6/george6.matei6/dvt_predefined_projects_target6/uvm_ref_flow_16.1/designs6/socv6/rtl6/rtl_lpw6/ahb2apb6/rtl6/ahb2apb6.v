//File6 name   : ahb2apb6.v
//Title6       : 
//Created6     : 2010
//Description6 : Simple6 AHB6 to APB6 bridge6
//Notes6       : 
//----------------------------------------------------------------------
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------

`timescale 1ns/1ps

`include "ahb2apb_defines6.v"

module ahb2apb6
(
  // AHB6 signals6
  hclk6,
  hreset_n6,
  hsel6,
  haddr6,
  htrans6,
  hwdata6,
  hwrite6,
  hrdata6,
  hready6,
  hresp6,
  
  // APB6 signals6 common to all APB6 slaves6
  pclk6,
  preset_n6,
  paddr6,
  penable6,
  pwrite6,
  pwdata6
  
  // Slave6 0 signals6
  `ifdef APB_SLAVE06
  ,psel06
  ,pready06
  ,prdata06
  `endif
  
  // Slave6 1 signals6
  `ifdef APB_SLAVE16
  ,psel16
  ,pready16
  ,prdata16
  `endif
  
  // Slave6 2 signals6
  `ifdef APB_SLAVE26
  ,psel26
  ,pready26
  ,prdata26
  `endif
  
  // Slave6 3 signals6
  `ifdef APB_SLAVE36
  ,psel36
  ,pready36
  ,prdata36
  `endif
  
  // Slave6 4 signals6
  `ifdef APB_SLAVE46
  ,psel46
  ,pready46
  ,prdata46
  `endif
  
  // Slave6 5 signals6
  `ifdef APB_SLAVE56
  ,psel56
  ,pready56
  ,prdata56
  `endif
  
  // Slave6 6 signals6
  `ifdef APB_SLAVE66
  ,psel66
  ,pready66
  ,prdata66
  `endif
  
  // Slave6 7 signals6
  `ifdef APB_SLAVE76
  ,psel76
  ,pready76
  ,prdata76
  `endif
  
  // Slave6 8 signals6
  `ifdef APB_SLAVE86
  ,psel86
  ,pready86
  ,prdata86
  `endif
  
  // Slave6 9 signals6
  `ifdef APB_SLAVE96
  ,psel96
  ,pready96
  ,prdata96
  `endif
  
  // Slave6 10 signals6
  `ifdef APB_SLAVE106
  ,psel106
  ,pready106
  ,prdata106
  `endif
  
  // Slave6 11 signals6
  `ifdef APB_SLAVE116
  ,psel116
  ,pready116
  ,prdata116
  `endif
  
  // Slave6 12 signals6
  `ifdef APB_SLAVE126
  ,psel126
  ,pready126
  ,prdata126
  `endif
  
  // Slave6 13 signals6
  `ifdef APB_SLAVE136
  ,psel136
  ,pready136
  ,prdata136
  `endif
  
  // Slave6 14 signals6
  `ifdef APB_SLAVE146
  ,psel146
  ,pready146
  ,prdata146
  `endif
  
  // Slave6 15 signals6
  `ifdef APB_SLAVE156
  ,psel156
  ,pready156
  ,prdata156
  `endif
  
);

parameter 
  APB_SLAVE0_START_ADDR6  = 32'h00000000,
  APB_SLAVE0_END_ADDR6    = 32'h00000000,
  APB_SLAVE1_START_ADDR6  = 32'h00000000,
  APB_SLAVE1_END_ADDR6    = 32'h00000000,
  APB_SLAVE2_START_ADDR6  = 32'h00000000,
  APB_SLAVE2_END_ADDR6    = 32'h00000000,
  APB_SLAVE3_START_ADDR6  = 32'h00000000,
  APB_SLAVE3_END_ADDR6    = 32'h00000000,
  APB_SLAVE4_START_ADDR6  = 32'h00000000,
  APB_SLAVE4_END_ADDR6    = 32'h00000000,
  APB_SLAVE5_START_ADDR6  = 32'h00000000,
  APB_SLAVE5_END_ADDR6    = 32'h00000000,
  APB_SLAVE6_START_ADDR6  = 32'h00000000,
  APB_SLAVE6_END_ADDR6    = 32'h00000000,
  APB_SLAVE7_START_ADDR6  = 32'h00000000,
  APB_SLAVE7_END_ADDR6    = 32'h00000000,
  APB_SLAVE8_START_ADDR6  = 32'h00000000,
  APB_SLAVE8_END_ADDR6    = 32'h00000000,
  APB_SLAVE9_START_ADDR6  = 32'h00000000,
  APB_SLAVE9_END_ADDR6    = 32'h00000000,
  APB_SLAVE10_START_ADDR6  = 32'h00000000,
  APB_SLAVE10_END_ADDR6    = 32'h00000000,
  APB_SLAVE11_START_ADDR6  = 32'h00000000,
  APB_SLAVE11_END_ADDR6    = 32'h00000000,
  APB_SLAVE12_START_ADDR6  = 32'h00000000,
  APB_SLAVE12_END_ADDR6    = 32'h00000000,
  APB_SLAVE13_START_ADDR6  = 32'h00000000,
  APB_SLAVE13_END_ADDR6    = 32'h00000000,
  APB_SLAVE14_START_ADDR6  = 32'h00000000,
  APB_SLAVE14_END_ADDR6    = 32'h00000000,
  APB_SLAVE15_START_ADDR6  = 32'h00000000,
  APB_SLAVE15_END_ADDR6    = 32'h00000000;

  // AHB6 signals6
input        hclk6;
input        hreset_n6;
input        hsel6;
input[31:0]  haddr6;
input[1:0]   htrans6;
input[31:0]  hwdata6;
input        hwrite6;
output[31:0] hrdata6;
reg   [31:0] hrdata6;
output       hready6;
output[1:0]  hresp6;
  
  // APB6 signals6 common to all APB6 slaves6
input       pclk6;
input       preset_n6;
output[31:0] paddr6;
reg   [31:0] paddr6;
output       penable6;
reg          penable6;
output       pwrite6;
reg          pwrite6;
output[31:0] pwdata6;
  
  // Slave6 0 signals6
`ifdef APB_SLAVE06
  output      psel06;
  input       pready06;
  input[31:0] prdata06;
`endif
  
  // Slave6 1 signals6
`ifdef APB_SLAVE16
  output      psel16;
  input       pready16;
  input[31:0] prdata16;
`endif
  
  // Slave6 2 signals6
`ifdef APB_SLAVE26
  output      psel26;
  input       pready26;
  input[31:0] prdata26;
`endif
  
  // Slave6 3 signals6
`ifdef APB_SLAVE36
  output      psel36;
  input       pready36;
  input[31:0] prdata36;
`endif
  
  // Slave6 4 signals6
`ifdef APB_SLAVE46
  output      psel46;
  input       pready46;
  input[31:0] prdata46;
`endif
  
  // Slave6 5 signals6
`ifdef APB_SLAVE56
  output      psel56;
  input       pready56;
  input[31:0] prdata56;
`endif
  
  // Slave6 6 signals6
`ifdef APB_SLAVE66
  output      psel66;
  input       pready66;
  input[31:0] prdata66;
`endif
  
  // Slave6 7 signals6
`ifdef APB_SLAVE76
  output      psel76;
  input       pready76;
  input[31:0] prdata76;
`endif
  
  // Slave6 8 signals6
`ifdef APB_SLAVE86
  output      psel86;
  input       pready86;
  input[31:0] prdata86;
`endif
  
  // Slave6 9 signals6
`ifdef APB_SLAVE96
  output      psel96;
  input       pready96;
  input[31:0] prdata96;
`endif
  
  // Slave6 10 signals6
`ifdef APB_SLAVE106
  output      psel106;
  input       pready106;
  input[31:0] prdata106;
`endif
  
  // Slave6 11 signals6
`ifdef APB_SLAVE116
  output      psel116;
  input       pready116;
  input[31:0] prdata116;
`endif
  
  // Slave6 12 signals6
`ifdef APB_SLAVE126
  output      psel126;
  input       pready126;
  input[31:0] prdata126;
`endif
  
  // Slave6 13 signals6
`ifdef APB_SLAVE136
  output      psel136;
  input       pready136;
  input[31:0] prdata136;
`endif
  
  // Slave6 14 signals6
`ifdef APB_SLAVE146
  output      psel146;
  input       pready146;
  input[31:0] prdata146;
`endif
  
  // Slave6 15 signals6
`ifdef APB_SLAVE156
  output      psel156;
  input       pready156;
  input[31:0] prdata156;
`endif
 
reg         ahb_addr_phase6;
reg         ahb_data_phase6;
wire        valid_ahb_trans6;
wire        pready_muxed6;
wire [31:0] prdata_muxed6;
reg  [31:0] haddr_reg6;
reg         hwrite_reg6;
reg  [2:0]  apb_state6;
wire [2:0]  apb_state_idle6;
wire [2:0]  apb_state_setup6;
wire [2:0]  apb_state_access6;
reg  [15:0] slave_select6;
wire [15:0] pready_vector6;
reg  [15:0] psel_vector6;
wire [31:0] prdata0_q6;
wire [31:0] prdata1_q6;
wire [31:0] prdata2_q6;
wire [31:0] prdata3_q6;
wire [31:0] prdata4_q6;
wire [31:0] prdata5_q6;
wire [31:0] prdata6_q6;
wire [31:0] prdata7_q6;
wire [31:0] prdata8_q6;
wire [31:0] prdata9_q6;
wire [31:0] prdata10_q6;
wire [31:0] prdata11_q6;
wire [31:0] prdata12_q6;
wire [31:0] prdata13_q6;
wire [31:0] prdata14_q6;
wire [31:0] prdata15_q6;

// assign pclk6     = hclk6;
// assign preset_n6 = hreset_n6;
assign hready6   = ahb_addr_phase6;
assign pwdata6   = hwdata6;
assign hresp6  = 2'b00;

// Respond6 to NONSEQ6 or SEQ transfers6
assign valid_ahb_trans6 = ((htrans6 == 2'b10) || (htrans6 == 2'b11)) && (hsel6 == 1'b1);

always @(posedge hclk6) begin
  if (hreset_n6 == 1'b0) begin
    ahb_addr_phase6 <= 1'b1;
    ahb_data_phase6 <= 1'b0;
    haddr_reg6      <= 'b0;
    hwrite_reg6     <= 1'b0;
    hrdata6         <= 'b0;
  end
  else begin
    if (ahb_addr_phase6 == 1'b1 && valid_ahb_trans6 == 1'b1) begin
      ahb_addr_phase6 <= 1'b0;
      ahb_data_phase6 <= 1'b1;
      haddr_reg6      <= haddr6;
      hwrite_reg6     <= hwrite6;
    end
    if (ahb_data_phase6 == 1'b1 && pready_muxed6 == 1'b1 && apb_state6 == apb_state_access6) begin
      ahb_addr_phase6 <= 1'b1;
      ahb_data_phase6 <= 1'b0;
      hrdata6         <= prdata_muxed6;
    end
  end
end

// APB6 state machine6 state definitions6
assign apb_state_idle6   = 3'b001;
assign apb_state_setup6  = 3'b010;
assign apb_state_access6 = 3'b100;

// APB6 state machine6
always @(posedge hclk6 or negedge hreset_n6) begin
  if (hreset_n6 == 1'b0) begin
    apb_state6   <= apb_state_idle6;
    psel_vector6 <= 1'b0;
    penable6     <= 1'b0;
    paddr6       <= 1'b0;
    pwrite6      <= 1'b0;
  end  
  else begin
    
    // IDLE6 -> SETUP6
    if (apb_state6 == apb_state_idle6) begin
      if (ahb_data_phase6 == 1'b1) begin
        apb_state6   <= apb_state_setup6;
        psel_vector6 <= slave_select6;
        paddr6       <= haddr_reg6;
        pwrite6      <= hwrite_reg6;
      end  
    end
    
    // SETUP6 -> TRANSFER6
    if (apb_state6 == apb_state_setup6) begin
      apb_state6 <= apb_state_access6;
      penable6   <= 1'b1;
    end
    
    // TRANSFER6 -> SETUP6 or
    // TRANSFER6 -> IDLE6
    if (apb_state6 == apb_state_access6) begin
      if (pready_muxed6 == 1'b1) begin
      
        // TRANSFER6 -> SETUP6
        if (valid_ahb_trans6 == 1'b1) begin
          apb_state6   <= apb_state_setup6;
          penable6     <= 1'b0;
          psel_vector6 <= slave_select6;
          paddr6       <= haddr_reg6;
          pwrite6      <= hwrite_reg6;
        end  
        
        // TRANSFER6 -> IDLE6
        else begin
          apb_state6   <= apb_state_idle6;      
          penable6     <= 1'b0;
          psel_vector6 <= 'b0;
        end  
      end
    end
    
  end
end

always @(posedge hclk6 or negedge hreset_n6) begin
  if (hreset_n6 == 1'b0)
    slave_select6 <= 'b0;
  else begin  
  `ifdef APB_SLAVE06
     slave_select6[0]   <= valid_ahb_trans6 && (haddr6 >= APB_SLAVE0_START_ADDR6)  && (haddr6 <= APB_SLAVE0_END_ADDR6);
   `else
     slave_select6[0]   <= 1'b0;
   `endif
   
   `ifdef APB_SLAVE16
     slave_select6[1]   <= valid_ahb_trans6 && (haddr6 >= APB_SLAVE1_START_ADDR6)  && (haddr6 <= APB_SLAVE1_END_ADDR6);
   `else
     slave_select6[1]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE26  
     slave_select6[2]   <= valid_ahb_trans6 && (haddr6 >= APB_SLAVE2_START_ADDR6)  && (haddr6 <= APB_SLAVE2_END_ADDR6);
   `else
     slave_select6[2]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE36  
     slave_select6[3]   <= valid_ahb_trans6 && (haddr6 >= APB_SLAVE3_START_ADDR6)  && (haddr6 <= APB_SLAVE3_END_ADDR6);
   `else
     slave_select6[3]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE46  
     slave_select6[4]   <= valid_ahb_trans6 && (haddr6 >= APB_SLAVE4_START_ADDR6)  && (haddr6 <= APB_SLAVE4_END_ADDR6);
   `else
     slave_select6[4]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE56  
     slave_select6[5]   <= valid_ahb_trans6 && (haddr6 >= APB_SLAVE5_START_ADDR6)  && (haddr6 <= APB_SLAVE5_END_ADDR6);
   `else
     slave_select6[5]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE66  
     slave_select6[6]   <= valid_ahb_trans6 && (haddr6 >= APB_SLAVE6_START_ADDR6)  && (haddr6 <= APB_SLAVE6_END_ADDR6);
   `else
     slave_select6[6]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE76  
     slave_select6[7]   <= valid_ahb_trans6 && (haddr6 >= APB_SLAVE7_START_ADDR6)  && (haddr6 <= APB_SLAVE7_END_ADDR6);
   `else
     slave_select6[7]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE86  
     slave_select6[8]   <= valid_ahb_trans6 && (haddr6 >= APB_SLAVE8_START_ADDR6)  && (haddr6 <= APB_SLAVE8_END_ADDR6);
   `else
     slave_select6[8]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE96  
     slave_select6[9]   <= valid_ahb_trans6 && (haddr6 >= APB_SLAVE9_START_ADDR6)  && (haddr6 <= APB_SLAVE9_END_ADDR6);
   `else
     slave_select6[9]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE106  
     slave_select6[10]  <= valid_ahb_trans6 && (haddr6 >= APB_SLAVE10_START_ADDR6) && (haddr6 <= APB_SLAVE10_END_ADDR6);
   `else
     slave_select6[10]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE116  
     slave_select6[11]  <= valid_ahb_trans6 && (haddr6 >= APB_SLAVE11_START_ADDR6) && (haddr6 <= APB_SLAVE11_END_ADDR6);
   `else
     slave_select6[11]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE126  
     slave_select6[12]  <= valid_ahb_trans6 && (haddr6 >= APB_SLAVE12_START_ADDR6) && (haddr6 <= APB_SLAVE12_END_ADDR6);
   `else
     slave_select6[12]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE136  
     slave_select6[13]  <= valid_ahb_trans6 && (haddr6 >= APB_SLAVE13_START_ADDR6) && (haddr6 <= APB_SLAVE13_END_ADDR6);
   `else
     slave_select6[13]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE146  
     slave_select6[14]  <= valid_ahb_trans6 && (haddr6 >= APB_SLAVE14_START_ADDR6) && (haddr6 <= APB_SLAVE14_END_ADDR6);
   `else
     slave_select6[14]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE156  
     slave_select6[15]  <= valid_ahb_trans6 && (haddr6 >= APB_SLAVE15_START_ADDR6) && (haddr6 <= APB_SLAVE15_END_ADDR6);
   `else
     slave_select6[15]   <= 1'b0;
   `endif  
  end
end

assign pready_muxed6 = |(psel_vector6 & pready_vector6);
assign prdata_muxed6 = prdata0_q6  | prdata1_q6  | prdata2_q6  | prdata3_q6  |
                      prdata4_q6  | prdata5_q6  | prdata6_q6  | prdata7_q6  |
                      prdata8_q6  | prdata9_q6  | prdata10_q6 | prdata11_q6 |
                      prdata12_q6 | prdata13_q6 | prdata14_q6 | prdata15_q6 ;

`ifdef APB_SLAVE06
  assign psel06            = psel_vector6[0];
  assign pready_vector6[0] = pready06;
  assign prdata0_q6        = (psel06 == 1'b1) ? prdata06 : 'b0;
`else
  assign pready_vector6[0] = 1'b0;
  assign prdata0_q6        = 'b0;
`endif

`ifdef APB_SLAVE16
  assign psel16            = psel_vector6[1];
  assign pready_vector6[1] = pready16;
  assign prdata1_q6        = (psel16 == 1'b1) ? prdata16 : 'b0;
`else
  assign pready_vector6[1] = 1'b0;
  assign prdata1_q6        = 'b0;
`endif

`ifdef APB_SLAVE26
  assign psel26            = psel_vector6[2];
  assign pready_vector6[2] = pready26;
  assign prdata2_q6        = (psel26 == 1'b1) ? prdata26 : 'b0;
`else
  assign pready_vector6[2] = 1'b0;
  assign prdata2_q6        = 'b0;
`endif

`ifdef APB_SLAVE36
  assign psel36            = psel_vector6[3];
  assign pready_vector6[3] = pready36;
  assign prdata3_q6        = (psel36 == 1'b1) ? prdata36 : 'b0;
`else
  assign pready_vector6[3] = 1'b0;
  assign prdata3_q6        = 'b0;
`endif

`ifdef APB_SLAVE46
  assign psel46            = psel_vector6[4];
  assign pready_vector6[4] = pready46;
  assign prdata4_q6        = (psel46 == 1'b1) ? prdata46 : 'b0;
`else
  assign pready_vector6[4] = 1'b0;
  assign prdata4_q6        = 'b0;
`endif

`ifdef APB_SLAVE56
  assign psel56            = psel_vector6[5];
  assign pready_vector6[5] = pready56;
  assign prdata5_q6        = (psel56 == 1'b1) ? prdata56 : 'b0;
`else
  assign pready_vector6[5] = 1'b0;
  assign prdata5_q6        = 'b0;
`endif

`ifdef APB_SLAVE66
  assign psel66            = psel_vector6[6];
  assign pready_vector6[6] = pready66;
  assign prdata6_q6        = (psel66 == 1'b1) ? prdata66 : 'b0;
`else
  assign pready_vector6[6] = 1'b0;
  assign prdata6_q6        = 'b0;
`endif

`ifdef APB_SLAVE76
  assign psel76            = psel_vector6[7];
  assign pready_vector6[7] = pready76;
  assign prdata7_q6        = (psel76 == 1'b1) ? prdata76 : 'b0;
`else
  assign pready_vector6[7] = 1'b0;
  assign prdata7_q6        = 'b0;
`endif

`ifdef APB_SLAVE86
  assign psel86            = psel_vector6[8];
  assign pready_vector6[8] = pready86;
  assign prdata8_q6        = (psel86 == 1'b1) ? prdata86 : 'b0;
`else
  assign pready_vector6[8] = 1'b0;
  assign prdata8_q6        = 'b0;
`endif

`ifdef APB_SLAVE96
  assign psel96            = psel_vector6[9];
  assign pready_vector6[9] = pready96;
  assign prdata9_q6        = (psel96 == 1'b1) ? prdata96 : 'b0;
`else
  assign pready_vector6[9] = 1'b0;
  assign prdata9_q6        = 'b0;
`endif

`ifdef APB_SLAVE106
  assign psel106            = psel_vector6[10];
  assign pready_vector6[10] = pready106;
  assign prdata10_q6        = (psel106 == 1'b1) ? prdata106 : 'b0;
`else
  assign pready_vector6[10] = 1'b0;
  assign prdata10_q6        = 'b0;
`endif

`ifdef APB_SLAVE116
  assign psel116            = psel_vector6[11];
  assign pready_vector6[11] = pready116;
  assign prdata11_q6        = (psel116 == 1'b1) ? prdata116 : 'b0;
`else
  assign pready_vector6[11] = 1'b0;
  assign prdata11_q6        = 'b0;
`endif

`ifdef APB_SLAVE126
  assign psel126            = psel_vector6[12];
  assign pready_vector6[12] = pready126;
  assign prdata12_q6        = (psel126 == 1'b1) ? prdata126 : 'b0;
`else
  assign pready_vector6[12] = 1'b0;
  assign prdata12_q6        = 'b0;
`endif

`ifdef APB_SLAVE136
  assign psel136            = psel_vector6[13];
  assign pready_vector6[13] = pready136;
  assign prdata13_q6        = (psel136 == 1'b1) ? prdata136 : 'b0;
`else
  assign pready_vector6[13] = 1'b0;
  assign prdata13_q6        = 'b0;
`endif

`ifdef APB_SLAVE146
  assign psel146            = psel_vector6[14];
  assign pready_vector6[14] = pready146;
  assign prdata14_q6        = (psel146 == 1'b1) ? prdata146 : 'b0;
`else
  assign pready_vector6[14] = 1'b0;
  assign prdata14_q6        = 'b0;
`endif

`ifdef APB_SLAVE156
  assign psel156            = psel_vector6[15];
  assign pready_vector6[15] = pready156;
  assign prdata15_q6        = (psel156 == 1'b1) ? prdata156 : 'b0;
`else
  assign pready_vector6[15] = 1'b0;
  assign prdata15_q6        = 'b0;
`endif

endmodule
