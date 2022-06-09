//File8 name   : ahb2apb8.v
//Title8       : 
//Created8     : 2010
//Description8 : Simple8 AHB8 to APB8 bridge8
//Notes8       : 
//----------------------------------------------------------------------
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------

`timescale 1ns/1ps

`include "ahb2apb_defines8.v"

module ahb2apb8
(
  // AHB8 signals8
  hclk8,
  hreset_n8,
  hsel8,
  haddr8,
  htrans8,
  hwdata8,
  hwrite8,
  hrdata8,
  hready8,
  hresp8,
  
  // APB8 signals8 common to all APB8 slaves8
  pclk8,
  preset_n8,
  paddr8,
  penable8,
  pwrite8,
  pwdata8
  
  // Slave8 0 signals8
  `ifdef APB_SLAVE08
  ,psel08
  ,pready08
  ,prdata08
  `endif
  
  // Slave8 1 signals8
  `ifdef APB_SLAVE18
  ,psel18
  ,pready18
  ,prdata18
  `endif
  
  // Slave8 2 signals8
  `ifdef APB_SLAVE28
  ,psel28
  ,pready28
  ,prdata28
  `endif
  
  // Slave8 3 signals8
  `ifdef APB_SLAVE38
  ,psel38
  ,pready38
  ,prdata38
  `endif
  
  // Slave8 4 signals8
  `ifdef APB_SLAVE48
  ,psel48
  ,pready48
  ,prdata48
  `endif
  
  // Slave8 5 signals8
  `ifdef APB_SLAVE58
  ,psel58
  ,pready58
  ,prdata58
  `endif
  
  // Slave8 6 signals8
  `ifdef APB_SLAVE68
  ,psel68
  ,pready68
  ,prdata68
  `endif
  
  // Slave8 7 signals8
  `ifdef APB_SLAVE78
  ,psel78
  ,pready78
  ,prdata78
  `endif
  
  // Slave8 8 signals8
  `ifdef APB_SLAVE88
  ,psel88
  ,pready88
  ,prdata88
  `endif
  
  // Slave8 9 signals8
  `ifdef APB_SLAVE98
  ,psel98
  ,pready98
  ,prdata98
  `endif
  
  // Slave8 10 signals8
  `ifdef APB_SLAVE108
  ,psel108
  ,pready108
  ,prdata108
  `endif
  
  // Slave8 11 signals8
  `ifdef APB_SLAVE118
  ,psel118
  ,pready118
  ,prdata118
  `endif
  
  // Slave8 12 signals8
  `ifdef APB_SLAVE128
  ,psel128
  ,pready128
  ,prdata128
  `endif
  
  // Slave8 13 signals8
  `ifdef APB_SLAVE138
  ,psel138
  ,pready138
  ,prdata138
  `endif
  
  // Slave8 14 signals8
  `ifdef APB_SLAVE148
  ,psel148
  ,pready148
  ,prdata148
  `endif
  
  // Slave8 15 signals8
  `ifdef APB_SLAVE158
  ,psel158
  ,pready158
  ,prdata158
  `endif
  
);

parameter 
  APB_SLAVE0_START_ADDR8  = 32'h00000000,
  APB_SLAVE0_END_ADDR8    = 32'h00000000,
  APB_SLAVE1_START_ADDR8  = 32'h00000000,
  APB_SLAVE1_END_ADDR8    = 32'h00000000,
  APB_SLAVE2_START_ADDR8  = 32'h00000000,
  APB_SLAVE2_END_ADDR8    = 32'h00000000,
  APB_SLAVE3_START_ADDR8  = 32'h00000000,
  APB_SLAVE3_END_ADDR8    = 32'h00000000,
  APB_SLAVE4_START_ADDR8  = 32'h00000000,
  APB_SLAVE4_END_ADDR8    = 32'h00000000,
  APB_SLAVE5_START_ADDR8  = 32'h00000000,
  APB_SLAVE5_END_ADDR8    = 32'h00000000,
  APB_SLAVE6_START_ADDR8  = 32'h00000000,
  APB_SLAVE6_END_ADDR8    = 32'h00000000,
  APB_SLAVE7_START_ADDR8  = 32'h00000000,
  APB_SLAVE7_END_ADDR8    = 32'h00000000,
  APB_SLAVE8_START_ADDR8  = 32'h00000000,
  APB_SLAVE8_END_ADDR8    = 32'h00000000,
  APB_SLAVE9_START_ADDR8  = 32'h00000000,
  APB_SLAVE9_END_ADDR8    = 32'h00000000,
  APB_SLAVE10_START_ADDR8  = 32'h00000000,
  APB_SLAVE10_END_ADDR8    = 32'h00000000,
  APB_SLAVE11_START_ADDR8  = 32'h00000000,
  APB_SLAVE11_END_ADDR8    = 32'h00000000,
  APB_SLAVE12_START_ADDR8  = 32'h00000000,
  APB_SLAVE12_END_ADDR8    = 32'h00000000,
  APB_SLAVE13_START_ADDR8  = 32'h00000000,
  APB_SLAVE13_END_ADDR8    = 32'h00000000,
  APB_SLAVE14_START_ADDR8  = 32'h00000000,
  APB_SLAVE14_END_ADDR8    = 32'h00000000,
  APB_SLAVE15_START_ADDR8  = 32'h00000000,
  APB_SLAVE15_END_ADDR8    = 32'h00000000;

  // AHB8 signals8
input        hclk8;
input        hreset_n8;
input        hsel8;
input[31:0]  haddr8;
input[1:0]   htrans8;
input[31:0]  hwdata8;
input        hwrite8;
output[31:0] hrdata8;
reg   [31:0] hrdata8;
output       hready8;
output[1:0]  hresp8;
  
  // APB8 signals8 common to all APB8 slaves8
input       pclk8;
input       preset_n8;
output[31:0] paddr8;
reg   [31:0] paddr8;
output       penable8;
reg          penable8;
output       pwrite8;
reg          pwrite8;
output[31:0] pwdata8;
  
  // Slave8 0 signals8
`ifdef APB_SLAVE08
  output      psel08;
  input       pready08;
  input[31:0] prdata08;
`endif
  
  // Slave8 1 signals8
`ifdef APB_SLAVE18
  output      psel18;
  input       pready18;
  input[31:0] prdata18;
`endif
  
  // Slave8 2 signals8
`ifdef APB_SLAVE28
  output      psel28;
  input       pready28;
  input[31:0] prdata28;
`endif
  
  // Slave8 3 signals8
`ifdef APB_SLAVE38
  output      psel38;
  input       pready38;
  input[31:0] prdata38;
`endif
  
  // Slave8 4 signals8
`ifdef APB_SLAVE48
  output      psel48;
  input       pready48;
  input[31:0] prdata48;
`endif
  
  // Slave8 5 signals8
`ifdef APB_SLAVE58
  output      psel58;
  input       pready58;
  input[31:0] prdata58;
`endif
  
  // Slave8 6 signals8
`ifdef APB_SLAVE68
  output      psel68;
  input       pready68;
  input[31:0] prdata68;
`endif
  
  // Slave8 7 signals8
`ifdef APB_SLAVE78
  output      psel78;
  input       pready78;
  input[31:0] prdata78;
`endif
  
  // Slave8 8 signals8
`ifdef APB_SLAVE88
  output      psel88;
  input       pready88;
  input[31:0] prdata88;
`endif
  
  // Slave8 9 signals8
`ifdef APB_SLAVE98
  output      psel98;
  input       pready98;
  input[31:0] prdata98;
`endif
  
  // Slave8 10 signals8
`ifdef APB_SLAVE108
  output      psel108;
  input       pready108;
  input[31:0] prdata108;
`endif
  
  // Slave8 11 signals8
`ifdef APB_SLAVE118
  output      psel118;
  input       pready118;
  input[31:0] prdata118;
`endif
  
  // Slave8 12 signals8
`ifdef APB_SLAVE128
  output      psel128;
  input       pready128;
  input[31:0] prdata128;
`endif
  
  // Slave8 13 signals8
`ifdef APB_SLAVE138
  output      psel138;
  input       pready138;
  input[31:0] prdata138;
`endif
  
  // Slave8 14 signals8
`ifdef APB_SLAVE148
  output      psel148;
  input       pready148;
  input[31:0] prdata148;
`endif
  
  // Slave8 15 signals8
`ifdef APB_SLAVE158
  output      psel158;
  input       pready158;
  input[31:0] prdata158;
`endif
 
reg         ahb_addr_phase8;
reg         ahb_data_phase8;
wire        valid_ahb_trans8;
wire        pready_muxed8;
wire [31:0] prdata_muxed8;
reg  [31:0] haddr_reg8;
reg         hwrite_reg8;
reg  [2:0]  apb_state8;
wire [2:0]  apb_state_idle8;
wire [2:0]  apb_state_setup8;
wire [2:0]  apb_state_access8;
reg  [15:0] slave_select8;
wire [15:0] pready_vector8;
reg  [15:0] psel_vector8;
wire [31:0] prdata0_q8;
wire [31:0] prdata1_q8;
wire [31:0] prdata2_q8;
wire [31:0] prdata3_q8;
wire [31:0] prdata4_q8;
wire [31:0] prdata5_q8;
wire [31:0] prdata6_q8;
wire [31:0] prdata7_q8;
wire [31:0] prdata8_q8;
wire [31:0] prdata9_q8;
wire [31:0] prdata10_q8;
wire [31:0] prdata11_q8;
wire [31:0] prdata12_q8;
wire [31:0] prdata13_q8;
wire [31:0] prdata14_q8;
wire [31:0] prdata15_q8;

// assign pclk8     = hclk8;
// assign preset_n8 = hreset_n8;
assign hready8   = ahb_addr_phase8;
assign pwdata8   = hwdata8;
assign hresp8  = 2'b00;

// Respond8 to NONSEQ8 or SEQ transfers8
assign valid_ahb_trans8 = ((htrans8 == 2'b10) || (htrans8 == 2'b11)) && (hsel8 == 1'b1);

always @(posedge hclk8) begin
  if (hreset_n8 == 1'b0) begin
    ahb_addr_phase8 <= 1'b1;
    ahb_data_phase8 <= 1'b0;
    haddr_reg8      <= 'b0;
    hwrite_reg8     <= 1'b0;
    hrdata8         <= 'b0;
  end
  else begin
    if (ahb_addr_phase8 == 1'b1 && valid_ahb_trans8 == 1'b1) begin
      ahb_addr_phase8 <= 1'b0;
      ahb_data_phase8 <= 1'b1;
      haddr_reg8      <= haddr8;
      hwrite_reg8     <= hwrite8;
    end
    if (ahb_data_phase8 == 1'b1 && pready_muxed8 == 1'b1 && apb_state8 == apb_state_access8) begin
      ahb_addr_phase8 <= 1'b1;
      ahb_data_phase8 <= 1'b0;
      hrdata8         <= prdata_muxed8;
    end
  end
end

// APB8 state machine8 state definitions8
assign apb_state_idle8   = 3'b001;
assign apb_state_setup8  = 3'b010;
assign apb_state_access8 = 3'b100;

// APB8 state machine8
always @(posedge hclk8 or negedge hreset_n8) begin
  if (hreset_n8 == 1'b0) begin
    apb_state8   <= apb_state_idle8;
    psel_vector8 <= 1'b0;
    penable8     <= 1'b0;
    paddr8       <= 1'b0;
    pwrite8      <= 1'b0;
  end  
  else begin
    
    // IDLE8 -> SETUP8
    if (apb_state8 == apb_state_idle8) begin
      if (ahb_data_phase8 == 1'b1) begin
        apb_state8   <= apb_state_setup8;
        psel_vector8 <= slave_select8;
        paddr8       <= haddr_reg8;
        pwrite8      <= hwrite_reg8;
      end  
    end
    
    // SETUP8 -> TRANSFER8
    if (apb_state8 == apb_state_setup8) begin
      apb_state8 <= apb_state_access8;
      penable8   <= 1'b1;
    end
    
    // TRANSFER8 -> SETUP8 or
    // TRANSFER8 -> IDLE8
    if (apb_state8 == apb_state_access8) begin
      if (pready_muxed8 == 1'b1) begin
      
        // TRANSFER8 -> SETUP8
        if (valid_ahb_trans8 == 1'b1) begin
          apb_state8   <= apb_state_setup8;
          penable8     <= 1'b0;
          psel_vector8 <= slave_select8;
          paddr8       <= haddr_reg8;
          pwrite8      <= hwrite_reg8;
        end  
        
        // TRANSFER8 -> IDLE8
        else begin
          apb_state8   <= apb_state_idle8;      
          penable8     <= 1'b0;
          psel_vector8 <= 'b0;
        end  
      end
    end
    
  end
end

always @(posedge hclk8 or negedge hreset_n8) begin
  if (hreset_n8 == 1'b0)
    slave_select8 <= 'b0;
  else begin  
  `ifdef APB_SLAVE08
     slave_select8[0]   <= valid_ahb_trans8 && (haddr8 >= APB_SLAVE0_START_ADDR8)  && (haddr8 <= APB_SLAVE0_END_ADDR8);
   `else
     slave_select8[0]   <= 1'b0;
   `endif
   
   `ifdef APB_SLAVE18
     slave_select8[1]   <= valid_ahb_trans8 && (haddr8 >= APB_SLAVE1_START_ADDR8)  && (haddr8 <= APB_SLAVE1_END_ADDR8);
   `else
     slave_select8[1]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE28  
     slave_select8[2]   <= valid_ahb_trans8 && (haddr8 >= APB_SLAVE2_START_ADDR8)  && (haddr8 <= APB_SLAVE2_END_ADDR8);
   `else
     slave_select8[2]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE38  
     slave_select8[3]   <= valid_ahb_trans8 && (haddr8 >= APB_SLAVE3_START_ADDR8)  && (haddr8 <= APB_SLAVE3_END_ADDR8);
   `else
     slave_select8[3]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE48  
     slave_select8[4]   <= valid_ahb_trans8 && (haddr8 >= APB_SLAVE4_START_ADDR8)  && (haddr8 <= APB_SLAVE4_END_ADDR8);
   `else
     slave_select8[4]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE58  
     slave_select8[5]   <= valid_ahb_trans8 && (haddr8 >= APB_SLAVE5_START_ADDR8)  && (haddr8 <= APB_SLAVE5_END_ADDR8);
   `else
     slave_select8[5]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE68  
     slave_select8[6]   <= valid_ahb_trans8 && (haddr8 >= APB_SLAVE6_START_ADDR8)  && (haddr8 <= APB_SLAVE6_END_ADDR8);
   `else
     slave_select8[6]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE78  
     slave_select8[7]   <= valid_ahb_trans8 && (haddr8 >= APB_SLAVE7_START_ADDR8)  && (haddr8 <= APB_SLAVE7_END_ADDR8);
   `else
     slave_select8[7]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE88  
     slave_select8[8]   <= valid_ahb_trans8 && (haddr8 >= APB_SLAVE8_START_ADDR8)  && (haddr8 <= APB_SLAVE8_END_ADDR8);
   `else
     slave_select8[8]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE98  
     slave_select8[9]   <= valid_ahb_trans8 && (haddr8 >= APB_SLAVE9_START_ADDR8)  && (haddr8 <= APB_SLAVE9_END_ADDR8);
   `else
     slave_select8[9]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE108  
     slave_select8[10]  <= valid_ahb_trans8 && (haddr8 >= APB_SLAVE10_START_ADDR8) && (haddr8 <= APB_SLAVE10_END_ADDR8);
   `else
     slave_select8[10]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE118  
     slave_select8[11]  <= valid_ahb_trans8 && (haddr8 >= APB_SLAVE11_START_ADDR8) && (haddr8 <= APB_SLAVE11_END_ADDR8);
   `else
     slave_select8[11]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE128  
     slave_select8[12]  <= valid_ahb_trans8 && (haddr8 >= APB_SLAVE12_START_ADDR8) && (haddr8 <= APB_SLAVE12_END_ADDR8);
   `else
     slave_select8[12]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE138  
     slave_select8[13]  <= valid_ahb_trans8 && (haddr8 >= APB_SLAVE13_START_ADDR8) && (haddr8 <= APB_SLAVE13_END_ADDR8);
   `else
     slave_select8[13]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE148  
     slave_select8[14]  <= valid_ahb_trans8 && (haddr8 >= APB_SLAVE14_START_ADDR8) && (haddr8 <= APB_SLAVE14_END_ADDR8);
   `else
     slave_select8[14]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE158  
     slave_select8[15]  <= valid_ahb_trans8 && (haddr8 >= APB_SLAVE15_START_ADDR8) && (haddr8 <= APB_SLAVE15_END_ADDR8);
   `else
     slave_select8[15]   <= 1'b0;
   `endif  
  end
end

assign pready_muxed8 = |(psel_vector8 & pready_vector8);
assign prdata_muxed8 = prdata0_q8  | prdata1_q8  | prdata2_q8  | prdata3_q8  |
                      prdata4_q8  | prdata5_q8  | prdata6_q8  | prdata7_q8  |
                      prdata8_q8  | prdata9_q8  | prdata10_q8 | prdata11_q8 |
                      prdata12_q8 | prdata13_q8 | prdata14_q8 | prdata15_q8 ;

`ifdef APB_SLAVE08
  assign psel08            = psel_vector8[0];
  assign pready_vector8[0] = pready08;
  assign prdata0_q8        = (psel08 == 1'b1) ? prdata08 : 'b0;
`else
  assign pready_vector8[0] = 1'b0;
  assign prdata0_q8        = 'b0;
`endif

`ifdef APB_SLAVE18
  assign psel18            = psel_vector8[1];
  assign pready_vector8[1] = pready18;
  assign prdata1_q8        = (psel18 == 1'b1) ? prdata18 : 'b0;
`else
  assign pready_vector8[1] = 1'b0;
  assign prdata1_q8        = 'b0;
`endif

`ifdef APB_SLAVE28
  assign psel28            = psel_vector8[2];
  assign pready_vector8[2] = pready28;
  assign prdata2_q8        = (psel28 == 1'b1) ? prdata28 : 'b0;
`else
  assign pready_vector8[2] = 1'b0;
  assign prdata2_q8        = 'b0;
`endif

`ifdef APB_SLAVE38
  assign psel38            = psel_vector8[3];
  assign pready_vector8[3] = pready38;
  assign prdata3_q8        = (psel38 == 1'b1) ? prdata38 : 'b0;
`else
  assign pready_vector8[3] = 1'b0;
  assign prdata3_q8        = 'b0;
`endif

`ifdef APB_SLAVE48
  assign psel48            = psel_vector8[4];
  assign pready_vector8[4] = pready48;
  assign prdata4_q8        = (psel48 == 1'b1) ? prdata48 : 'b0;
`else
  assign pready_vector8[4] = 1'b0;
  assign prdata4_q8        = 'b0;
`endif

`ifdef APB_SLAVE58
  assign psel58            = psel_vector8[5];
  assign pready_vector8[5] = pready58;
  assign prdata5_q8        = (psel58 == 1'b1) ? prdata58 : 'b0;
`else
  assign pready_vector8[5] = 1'b0;
  assign prdata5_q8        = 'b0;
`endif

`ifdef APB_SLAVE68
  assign psel68            = psel_vector8[6];
  assign pready_vector8[6] = pready68;
  assign prdata6_q8        = (psel68 == 1'b1) ? prdata68 : 'b0;
`else
  assign pready_vector8[6] = 1'b0;
  assign prdata6_q8        = 'b0;
`endif

`ifdef APB_SLAVE78
  assign psel78            = psel_vector8[7];
  assign pready_vector8[7] = pready78;
  assign prdata7_q8        = (psel78 == 1'b1) ? prdata78 : 'b0;
`else
  assign pready_vector8[7] = 1'b0;
  assign prdata7_q8        = 'b0;
`endif

`ifdef APB_SLAVE88
  assign psel88            = psel_vector8[8];
  assign pready_vector8[8] = pready88;
  assign prdata8_q8        = (psel88 == 1'b1) ? prdata88 : 'b0;
`else
  assign pready_vector8[8] = 1'b0;
  assign prdata8_q8        = 'b0;
`endif

`ifdef APB_SLAVE98
  assign psel98            = psel_vector8[9];
  assign pready_vector8[9] = pready98;
  assign prdata9_q8        = (psel98 == 1'b1) ? prdata98 : 'b0;
`else
  assign pready_vector8[9] = 1'b0;
  assign prdata9_q8        = 'b0;
`endif

`ifdef APB_SLAVE108
  assign psel108            = psel_vector8[10];
  assign pready_vector8[10] = pready108;
  assign prdata10_q8        = (psel108 == 1'b1) ? prdata108 : 'b0;
`else
  assign pready_vector8[10] = 1'b0;
  assign prdata10_q8        = 'b0;
`endif

`ifdef APB_SLAVE118
  assign psel118            = psel_vector8[11];
  assign pready_vector8[11] = pready118;
  assign prdata11_q8        = (psel118 == 1'b1) ? prdata118 : 'b0;
`else
  assign pready_vector8[11] = 1'b0;
  assign prdata11_q8        = 'b0;
`endif

`ifdef APB_SLAVE128
  assign psel128            = psel_vector8[12];
  assign pready_vector8[12] = pready128;
  assign prdata12_q8        = (psel128 == 1'b1) ? prdata128 : 'b0;
`else
  assign pready_vector8[12] = 1'b0;
  assign prdata12_q8        = 'b0;
`endif

`ifdef APB_SLAVE138
  assign psel138            = psel_vector8[13];
  assign pready_vector8[13] = pready138;
  assign prdata13_q8        = (psel138 == 1'b1) ? prdata138 : 'b0;
`else
  assign pready_vector8[13] = 1'b0;
  assign prdata13_q8        = 'b0;
`endif

`ifdef APB_SLAVE148
  assign psel148            = psel_vector8[14];
  assign pready_vector8[14] = pready148;
  assign prdata14_q8        = (psel148 == 1'b1) ? prdata148 : 'b0;
`else
  assign pready_vector8[14] = 1'b0;
  assign prdata14_q8        = 'b0;
`endif

`ifdef APB_SLAVE158
  assign psel158            = psel_vector8[15];
  assign pready_vector8[15] = pready158;
  assign prdata15_q8        = (psel158 == 1'b1) ? prdata158 : 'b0;
`else
  assign pready_vector8[15] = 1'b0;
  assign prdata15_q8        = 'b0;
`endif

endmodule
