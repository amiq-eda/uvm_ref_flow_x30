//File29 name   : ahb2apb29.v
//Title29       : 
//Created29     : 2010
//Description29 : Simple29 AHB29 to APB29 bridge29
//Notes29       : 
//----------------------------------------------------------------------
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------

`timescale 1ns/1ps

`include "ahb2apb_defines29.v"

module ahb2apb29
(
  // AHB29 signals29
  hclk29,
  hreset_n29,
  hsel29,
  haddr29,
  htrans29,
  hwdata29,
  hwrite29,
  hrdata29,
  hready29,
  hresp29,
  
  // APB29 signals29 common to all APB29 slaves29
  pclk29,
  preset_n29,
  paddr29,
  penable29,
  pwrite29,
  pwdata29
  
  // Slave29 0 signals29
  `ifdef APB_SLAVE029
  ,psel029
  ,pready029
  ,prdata029
  `endif
  
  // Slave29 1 signals29
  `ifdef APB_SLAVE129
  ,psel129
  ,pready129
  ,prdata129
  `endif
  
  // Slave29 2 signals29
  `ifdef APB_SLAVE229
  ,psel229
  ,pready229
  ,prdata229
  `endif
  
  // Slave29 3 signals29
  `ifdef APB_SLAVE329
  ,psel329
  ,pready329
  ,prdata329
  `endif
  
  // Slave29 4 signals29
  `ifdef APB_SLAVE429
  ,psel429
  ,pready429
  ,prdata429
  `endif
  
  // Slave29 5 signals29
  `ifdef APB_SLAVE529
  ,psel529
  ,pready529
  ,prdata529
  `endif
  
  // Slave29 6 signals29
  `ifdef APB_SLAVE629
  ,psel629
  ,pready629
  ,prdata629
  `endif
  
  // Slave29 7 signals29
  `ifdef APB_SLAVE729
  ,psel729
  ,pready729
  ,prdata729
  `endif
  
  // Slave29 8 signals29
  `ifdef APB_SLAVE829
  ,psel829
  ,pready829
  ,prdata829
  `endif
  
  // Slave29 9 signals29
  `ifdef APB_SLAVE929
  ,psel929
  ,pready929
  ,prdata929
  `endif
  
  // Slave29 10 signals29
  `ifdef APB_SLAVE1029
  ,psel1029
  ,pready1029
  ,prdata1029
  `endif
  
  // Slave29 11 signals29
  `ifdef APB_SLAVE1129
  ,psel1129
  ,pready1129
  ,prdata1129
  `endif
  
  // Slave29 12 signals29
  `ifdef APB_SLAVE1229
  ,psel1229
  ,pready1229
  ,prdata1229
  `endif
  
  // Slave29 13 signals29
  `ifdef APB_SLAVE1329
  ,psel1329
  ,pready1329
  ,prdata1329
  `endif
  
  // Slave29 14 signals29
  `ifdef APB_SLAVE1429
  ,psel1429
  ,pready1429
  ,prdata1429
  `endif
  
  // Slave29 15 signals29
  `ifdef APB_SLAVE1529
  ,psel1529
  ,pready1529
  ,prdata1529
  `endif
  
);

parameter 
  APB_SLAVE0_START_ADDR29  = 32'h00000000,
  APB_SLAVE0_END_ADDR29    = 32'h00000000,
  APB_SLAVE1_START_ADDR29  = 32'h00000000,
  APB_SLAVE1_END_ADDR29    = 32'h00000000,
  APB_SLAVE2_START_ADDR29  = 32'h00000000,
  APB_SLAVE2_END_ADDR29    = 32'h00000000,
  APB_SLAVE3_START_ADDR29  = 32'h00000000,
  APB_SLAVE3_END_ADDR29    = 32'h00000000,
  APB_SLAVE4_START_ADDR29  = 32'h00000000,
  APB_SLAVE4_END_ADDR29    = 32'h00000000,
  APB_SLAVE5_START_ADDR29  = 32'h00000000,
  APB_SLAVE5_END_ADDR29    = 32'h00000000,
  APB_SLAVE6_START_ADDR29  = 32'h00000000,
  APB_SLAVE6_END_ADDR29    = 32'h00000000,
  APB_SLAVE7_START_ADDR29  = 32'h00000000,
  APB_SLAVE7_END_ADDR29    = 32'h00000000,
  APB_SLAVE8_START_ADDR29  = 32'h00000000,
  APB_SLAVE8_END_ADDR29    = 32'h00000000,
  APB_SLAVE9_START_ADDR29  = 32'h00000000,
  APB_SLAVE9_END_ADDR29    = 32'h00000000,
  APB_SLAVE10_START_ADDR29  = 32'h00000000,
  APB_SLAVE10_END_ADDR29    = 32'h00000000,
  APB_SLAVE11_START_ADDR29  = 32'h00000000,
  APB_SLAVE11_END_ADDR29    = 32'h00000000,
  APB_SLAVE12_START_ADDR29  = 32'h00000000,
  APB_SLAVE12_END_ADDR29    = 32'h00000000,
  APB_SLAVE13_START_ADDR29  = 32'h00000000,
  APB_SLAVE13_END_ADDR29    = 32'h00000000,
  APB_SLAVE14_START_ADDR29  = 32'h00000000,
  APB_SLAVE14_END_ADDR29    = 32'h00000000,
  APB_SLAVE15_START_ADDR29  = 32'h00000000,
  APB_SLAVE15_END_ADDR29    = 32'h00000000;

  // AHB29 signals29
input        hclk29;
input        hreset_n29;
input        hsel29;
input[31:0]  haddr29;
input[1:0]   htrans29;
input[31:0]  hwdata29;
input        hwrite29;
output[31:0] hrdata29;
reg   [31:0] hrdata29;
output       hready29;
output[1:0]  hresp29;
  
  // APB29 signals29 common to all APB29 slaves29
input       pclk29;
input       preset_n29;
output[31:0] paddr29;
reg   [31:0] paddr29;
output       penable29;
reg          penable29;
output       pwrite29;
reg          pwrite29;
output[31:0] pwdata29;
  
  // Slave29 0 signals29
`ifdef APB_SLAVE029
  output      psel029;
  input       pready029;
  input[31:0] prdata029;
`endif
  
  // Slave29 1 signals29
`ifdef APB_SLAVE129
  output      psel129;
  input       pready129;
  input[31:0] prdata129;
`endif
  
  // Slave29 2 signals29
`ifdef APB_SLAVE229
  output      psel229;
  input       pready229;
  input[31:0] prdata229;
`endif
  
  // Slave29 3 signals29
`ifdef APB_SLAVE329
  output      psel329;
  input       pready329;
  input[31:0] prdata329;
`endif
  
  // Slave29 4 signals29
`ifdef APB_SLAVE429
  output      psel429;
  input       pready429;
  input[31:0] prdata429;
`endif
  
  // Slave29 5 signals29
`ifdef APB_SLAVE529
  output      psel529;
  input       pready529;
  input[31:0] prdata529;
`endif
  
  // Slave29 6 signals29
`ifdef APB_SLAVE629
  output      psel629;
  input       pready629;
  input[31:0] prdata629;
`endif
  
  // Slave29 7 signals29
`ifdef APB_SLAVE729
  output      psel729;
  input       pready729;
  input[31:0] prdata729;
`endif
  
  // Slave29 8 signals29
`ifdef APB_SLAVE829
  output      psel829;
  input       pready829;
  input[31:0] prdata829;
`endif
  
  // Slave29 9 signals29
`ifdef APB_SLAVE929
  output      psel929;
  input       pready929;
  input[31:0] prdata929;
`endif
  
  // Slave29 10 signals29
`ifdef APB_SLAVE1029
  output      psel1029;
  input       pready1029;
  input[31:0] prdata1029;
`endif
  
  // Slave29 11 signals29
`ifdef APB_SLAVE1129
  output      psel1129;
  input       pready1129;
  input[31:0] prdata1129;
`endif
  
  // Slave29 12 signals29
`ifdef APB_SLAVE1229
  output      psel1229;
  input       pready1229;
  input[31:0] prdata1229;
`endif
  
  // Slave29 13 signals29
`ifdef APB_SLAVE1329
  output      psel1329;
  input       pready1329;
  input[31:0] prdata1329;
`endif
  
  // Slave29 14 signals29
`ifdef APB_SLAVE1429
  output      psel1429;
  input       pready1429;
  input[31:0] prdata1429;
`endif
  
  // Slave29 15 signals29
`ifdef APB_SLAVE1529
  output      psel1529;
  input       pready1529;
  input[31:0] prdata1529;
`endif
 
reg         ahb_addr_phase29;
reg         ahb_data_phase29;
wire        valid_ahb_trans29;
wire        pready_muxed29;
wire [31:0] prdata_muxed29;
reg  [31:0] haddr_reg29;
reg         hwrite_reg29;
reg  [2:0]  apb_state29;
wire [2:0]  apb_state_idle29;
wire [2:0]  apb_state_setup29;
wire [2:0]  apb_state_access29;
reg  [15:0] slave_select29;
wire [15:0] pready_vector29;
reg  [15:0] psel_vector29;
wire [31:0] prdata0_q29;
wire [31:0] prdata1_q29;
wire [31:0] prdata2_q29;
wire [31:0] prdata3_q29;
wire [31:0] prdata4_q29;
wire [31:0] prdata5_q29;
wire [31:0] prdata6_q29;
wire [31:0] prdata7_q29;
wire [31:0] prdata8_q29;
wire [31:0] prdata9_q29;
wire [31:0] prdata10_q29;
wire [31:0] prdata11_q29;
wire [31:0] prdata12_q29;
wire [31:0] prdata13_q29;
wire [31:0] prdata14_q29;
wire [31:0] prdata15_q29;

// assign pclk29     = hclk29;
// assign preset_n29 = hreset_n29;
assign hready29   = ahb_addr_phase29;
assign pwdata29   = hwdata29;
assign hresp29  = 2'b00;

// Respond29 to NONSEQ29 or SEQ transfers29
assign valid_ahb_trans29 = ((htrans29 == 2'b10) || (htrans29 == 2'b11)) && (hsel29 == 1'b1);

always @(posedge hclk29) begin
  if (hreset_n29 == 1'b0) begin
    ahb_addr_phase29 <= 1'b1;
    ahb_data_phase29 <= 1'b0;
    haddr_reg29      <= 'b0;
    hwrite_reg29     <= 1'b0;
    hrdata29         <= 'b0;
  end
  else begin
    if (ahb_addr_phase29 == 1'b1 && valid_ahb_trans29 == 1'b1) begin
      ahb_addr_phase29 <= 1'b0;
      ahb_data_phase29 <= 1'b1;
      haddr_reg29      <= haddr29;
      hwrite_reg29     <= hwrite29;
    end
    if (ahb_data_phase29 == 1'b1 && pready_muxed29 == 1'b1 && apb_state29 == apb_state_access29) begin
      ahb_addr_phase29 <= 1'b1;
      ahb_data_phase29 <= 1'b0;
      hrdata29         <= prdata_muxed29;
    end
  end
end

// APB29 state machine29 state definitions29
assign apb_state_idle29   = 3'b001;
assign apb_state_setup29  = 3'b010;
assign apb_state_access29 = 3'b100;

// APB29 state machine29
always @(posedge hclk29 or negedge hreset_n29) begin
  if (hreset_n29 == 1'b0) begin
    apb_state29   <= apb_state_idle29;
    psel_vector29 <= 1'b0;
    penable29     <= 1'b0;
    paddr29       <= 1'b0;
    pwrite29      <= 1'b0;
  end  
  else begin
    
    // IDLE29 -> SETUP29
    if (apb_state29 == apb_state_idle29) begin
      if (ahb_data_phase29 == 1'b1) begin
        apb_state29   <= apb_state_setup29;
        psel_vector29 <= slave_select29;
        paddr29       <= haddr_reg29;
        pwrite29      <= hwrite_reg29;
      end  
    end
    
    // SETUP29 -> TRANSFER29
    if (apb_state29 == apb_state_setup29) begin
      apb_state29 <= apb_state_access29;
      penable29   <= 1'b1;
    end
    
    // TRANSFER29 -> SETUP29 or
    // TRANSFER29 -> IDLE29
    if (apb_state29 == apb_state_access29) begin
      if (pready_muxed29 == 1'b1) begin
      
        // TRANSFER29 -> SETUP29
        if (valid_ahb_trans29 == 1'b1) begin
          apb_state29   <= apb_state_setup29;
          penable29     <= 1'b0;
          psel_vector29 <= slave_select29;
          paddr29       <= haddr_reg29;
          pwrite29      <= hwrite_reg29;
        end  
        
        // TRANSFER29 -> IDLE29
        else begin
          apb_state29   <= apb_state_idle29;      
          penable29     <= 1'b0;
          psel_vector29 <= 'b0;
        end  
      end
    end
    
  end
end

always @(posedge hclk29 or negedge hreset_n29) begin
  if (hreset_n29 == 1'b0)
    slave_select29 <= 'b0;
  else begin  
  `ifdef APB_SLAVE029
     slave_select29[0]   <= valid_ahb_trans29 && (haddr29 >= APB_SLAVE0_START_ADDR29)  && (haddr29 <= APB_SLAVE0_END_ADDR29);
   `else
     slave_select29[0]   <= 1'b0;
   `endif
   
   `ifdef APB_SLAVE129
     slave_select29[1]   <= valid_ahb_trans29 && (haddr29 >= APB_SLAVE1_START_ADDR29)  && (haddr29 <= APB_SLAVE1_END_ADDR29);
   `else
     slave_select29[1]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE229  
     slave_select29[2]   <= valid_ahb_trans29 && (haddr29 >= APB_SLAVE2_START_ADDR29)  && (haddr29 <= APB_SLAVE2_END_ADDR29);
   `else
     slave_select29[2]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE329  
     slave_select29[3]   <= valid_ahb_trans29 && (haddr29 >= APB_SLAVE3_START_ADDR29)  && (haddr29 <= APB_SLAVE3_END_ADDR29);
   `else
     slave_select29[3]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE429  
     slave_select29[4]   <= valid_ahb_trans29 && (haddr29 >= APB_SLAVE4_START_ADDR29)  && (haddr29 <= APB_SLAVE4_END_ADDR29);
   `else
     slave_select29[4]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE529  
     slave_select29[5]   <= valid_ahb_trans29 && (haddr29 >= APB_SLAVE5_START_ADDR29)  && (haddr29 <= APB_SLAVE5_END_ADDR29);
   `else
     slave_select29[5]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE629  
     slave_select29[6]   <= valid_ahb_trans29 && (haddr29 >= APB_SLAVE6_START_ADDR29)  && (haddr29 <= APB_SLAVE6_END_ADDR29);
   `else
     slave_select29[6]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE729  
     slave_select29[7]   <= valid_ahb_trans29 && (haddr29 >= APB_SLAVE7_START_ADDR29)  && (haddr29 <= APB_SLAVE7_END_ADDR29);
   `else
     slave_select29[7]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE829  
     slave_select29[8]   <= valid_ahb_trans29 && (haddr29 >= APB_SLAVE8_START_ADDR29)  && (haddr29 <= APB_SLAVE8_END_ADDR29);
   `else
     slave_select29[8]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE929  
     slave_select29[9]   <= valid_ahb_trans29 && (haddr29 >= APB_SLAVE9_START_ADDR29)  && (haddr29 <= APB_SLAVE9_END_ADDR29);
   `else
     slave_select29[9]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1029  
     slave_select29[10]  <= valid_ahb_trans29 && (haddr29 >= APB_SLAVE10_START_ADDR29) && (haddr29 <= APB_SLAVE10_END_ADDR29);
   `else
     slave_select29[10]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1129  
     slave_select29[11]  <= valid_ahb_trans29 && (haddr29 >= APB_SLAVE11_START_ADDR29) && (haddr29 <= APB_SLAVE11_END_ADDR29);
   `else
     slave_select29[11]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1229  
     slave_select29[12]  <= valid_ahb_trans29 && (haddr29 >= APB_SLAVE12_START_ADDR29) && (haddr29 <= APB_SLAVE12_END_ADDR29);
   `else
     slave_select29[12]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1329  
     slave_select29[13]  <= valid_ahb_trans29 && (haddr29 >= APB_SLAVE13_START_ADDR29) && (haddr29 <= APB_SLAVE13_END_ADDR29);
   `else
     slave_select29[13]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1429  
     slave_select29[14]  <= valid_ahb_trans29 && (haddr29 >= APB_SLAVE14_START_ADDR29) && (haddr29 <= APB_SLAVE14_END_ADDR29);
   `else
     slave_select29[14]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1529  
     slave_select29[15]  <= valid_ahb_trans29 && (haddr29 >= APB_SLAVE15_START_ADDR29) && (haddr29 <= APB_SLAVE15_END_ADDR29);
   `else
     slave_select29[15]   <= 1'b0;
   `endif  
  end
end

assign pready_muxed29 = |(psel_vector29 & pready_vector29);
assign prdata_muxed29 = prdata0_q29  | prdata1_q29  | prdata2_q29  | prdata3_q29  |
                      prdata4_q29  | prdata5_q29  | prdata6_q29  | prdata7_q29  |
                      prdata8_q29  | prdata9_q29  | prdata10_q29 | prdata11_q29 |
                      prdata12_q29 | prdata13_q29 | prdata14_q29 | prdata15_q29 ;

`ifdef APB_SLAVE029
  assign psel029            = psel_vector29[0];
  assign pready_vector29[0] = pready029;
  assign prdata0_q29        = (psel029 == 1'b1) ? prdata029 : 'b0;
`else
  assign pready_vector29[0] = 1'b0;
  assign prdata0_q29        = 'b0;
`endif

`ifdef APB_SLAVE129
  assign psel129            = psel_vector29[1];
  assign pready_vector29[1] = pready129;
  assign prdata1_q29        = (psel129 == 1'b1) ? prdata129 : 'b0;
`else
  assign pready_vector29[1] = 1'b0;
  assign prdata1_q29        = 'b0;
`endif

`ifdef APB_SLAVE229
  assign psel229            = psel_vector29[2];
  assign pready_vector29[2] = pready229;
  assign prdata2_q29        = (psel229 == 1'b1) ? prdata229 : 'b0;
`else
  assign pready_vector29[2] = 1'b0;
  assign prdata2_q29        = 'b0;
`endif

`ifdef APB_SLAVE329
  assign psel329            = psel_vector29[3];
  assign pready_vector29[3] = pready329;
  assign prdata3_q29        = (psel329 == 1'b1) ? prdata329 : 'b0;
`else
  assign pready_vector29[3] = 1'b0;
  assign prdata3_q29        = 'b0;
`endif

`ifdef APB_SLAVE429
  assign psel429            = psel_vector29[4];
  assign pready_vector29[4] = pready429;
  assign prdata4_q29        = (psel429 == 1'b1) ? prdata429 : 'b0;
`else
  assign pready_vector29[4] = 1'b0;
  assign prdata4_q29        = 'b0;
`endif

`ifdef APB_SLAVE529
  assign psel529            = psel_vector29[5];
  assign pready_vector29[5] = pready529;
  assign prdata5_q29        = (psel529 == 1'b1) ? prdata529 : 'b0;
`else
  assign pready_vector29[5] = 1'b0;
  assign prdata5_q29        = 'b0;
`endif

`ifdef APB_SLAVE629
  assign psel629            = psel_vector29[6];
  assign pready_vector29[6] = pready629;
  assign prdata6_q29        = (psel629 == 1'b1) ? prdata629 : 'b0;
`else
  assign pready_vector29[6] = 1'b0;
  assign prdata6_q29        = 'b0;
`endif

`ifdef APB_SLAVE729
  assign psel729            = psel_vector29[7];
  assign pready_vector29[7] = pready729;
  assign prdata7_q29        = (psel729 == 1'b1) ? prdata729 : 'b0;
`else
  assign pready_vector29[7] = 1'b0;
  assign prdata7_q29        = 'b0;
`endif

`ifdef APB_SLAVE829
  assign psel829            = psel_vector29[8];
  assign pready_vector29[8] = pready829;
  assign prdata8_q29        = (psel829 == 1'b1) ? prdata829 : 'b0;
`else
  assign pready_vector29[8] = 1'b0;
  assign prdata8_q29        = 'b0;
`endif

`ifdef APB_SLAVE929
  assign psel929            = psel_vector29[9];
  assign pready_vector29[9] = pready929;
  assign prdata9_q29        = (psel929 == 1'b1) ? prdata929 : 'b0;
`else
  assign pready_vector29[9] = 1'b0;
  assign prdata9_q29        = 'b0;
`endif

`ifdef APB_SLAVE1029
  assign psel1029            = psel_vector29[10];
  assign pready_vector29[10] = pready1029;
  assign prdata10_q29        = (psel1029 == 1'b1) ? prdata1029 : 'b0;
`else
  assign pready_vector29[10] = 1'b0;
  assign prdata10_q29        = 'b0;
`endif

`ifdef APB_SLAVE1129
  assign psel1129            = psel_vector29[11];
  assign pready_vector29[11] = pready1129;
  assign prdata11_q29        = (psel1129 == 1'b1) ? prdata1129 : 'b0;
`else
  assign pready_vector29[11] = 1'b0;
  assign prdata11_q29        = 'b0;
`endif

`ifdef APB_SLAVE1229
  assign psel1229            = psel_vector29[12];
  assign pready_vector29[12] = pready1229;
  assign prdata12_q29        = (psel1229 == 1'b1) ? prdata1229 : 'b0;
`else
  assign pready_vector29[12] = 1'b0;
  assign prdata12_q29        = 'b0;
`endif

`ifdef APB_SLAVE1329
  assign psel1329            = psel_vector29[13];
  assign pready_vector29[13] = pready1329;
  assign prdata13_q29        = (psel1329 == 1'b1) ? prdata1329 : 'b0;
`else
  assign pready_vector29[13] = 1'b0;
  assign prdata13_q29        = 'b0;
`endif

`ifdef APB_SLAVE1429
  assign psel1429            = psel_vector29[14];
  assign pready_vector29[14] = pready1429;
  assign prdata14_q29        = (psel1429 == 1'b1) ? prdata1429 : 'b0;
`else
  assign pready_vector29[14] = 1'b0;
  assign prdata14_q29        = 'b0;
`endif

`ifdef APB_SLAVE1529
  assign psel1529            = psel_vector29[15];
  assign pready_vector29[15] = pready1529;
  assign prdata15_q29        = (psel1529 == 1'b1) ? prdata1529 : 'b0;
`else
  assign pready_vector29[15] = 1'b0;
  assign prdata15_q29        = 'b0;
`endif

endmodule
