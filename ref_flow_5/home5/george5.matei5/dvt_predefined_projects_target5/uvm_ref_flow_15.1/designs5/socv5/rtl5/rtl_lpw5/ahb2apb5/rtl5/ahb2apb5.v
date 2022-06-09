//File5 name   : ahb2apb5.v
//Title5       : 
//Created5     : 2010
//Description5 : Simple5 AHB5 to APB5 bridge5
//Notes5       : 
//----------------------------------------------------------------------
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------

`timescale 1ns/1ps

`include "ahb2apb_defines5.v"

module ahb2apb5
(
  // AHB5 signals5
  hclk5,
  hreset_n5,
  hsel5,
  haddr5,
  htrans5,
  hwdata5,
  hwrite5,
  hrdata5,
  hready5,
  hresp5,
  
  // APB5 signals5 common to all APB5 slaves5
  pclk5,
  preset_n5,
  paddr5,
  penable5,
  pwrite5,
  pwdata5
  
  // Slave5 0 signals5
  `ifdef APB_SLAVE05
  ,psel05
  ,pready05
  ,prdata05
  `endif
  
  // Slave5 1 signals5
  `ifdef APB_SLAVE15
  ,psel15
  ,pready15
  ,prdata15
  `endif
  
  // Slave5 2 signals5
  `ifdef APB_SLAVE25
  ,psel25
  ,pready25
  ,prdata25
  `endif
  
  // Slave5 3 signals5
  `ifdef APB_SLAVE35
  ,psel35
  ,pready35
  ,prdata35
  `endif
  
  // Slave5 4 signals5
  `ifdef APB_SLAVE45
  ,psel45
  ,pready45
  ,prdata45
  `endif
  
  // Slave5 5 signals5
  `ifdef APB_SLAVE55
  ,psel55
  ,pready55
  ,prdata55
  `endif
  
  // Slave5 6 signals5
  `ifdef APB_SLAVE65
  ,psel65
  ,pready65
  ,prdata65
  `endif
  
  // Slave5 7 signals5
  `ifdef APB_SLAVE75
  ,psel75
  ,pready75
  ,prdata75
  `endif
  
  // Slave5 8 signals5
  `ifdef APB_SLAVE85
  ,psel85
  ,pready85
  ,prdata85
  `endif
  
  // Slave5 9 signals5
  `ifdef APB_SLAVE95
  ,psel95
  ,pready95
  ,prdata95
  `endif
  
  // Slave5 10 signals5
  `ifdef APB_SLAVE105
  ,psel105
  ,pready105
  ,prdata105
  `endif
  
  // Slave5 11 signals5
  `ifdef APB_SLAVE115
  ,psel115
  ,pready115
  ,prdata115
  `endif
  
  // Slave5 12 signals5
  `ifdef APB_SLAVE125
  ,psel125
  ,pready125
  ,prdata125
  `endif
  
  // Slave5 13 signals5
  `ifdef APB_SLAVE135
  ,psel135
  ,pready135
  ,prdata135
  `endif
  
  // Slave5 14 signals5
  `ifdef APB_SLAVE145
  ,psel145
  ,pready145
  ,prdata145
  `endif
  
  // Slave5 15 signals5
  `ifdef APB_SLAVE155
  ,psel155
  ,pready155
  ,prdata155
  `endif
  
);

parameter 
  APB_SLAVE0_START_ADDR5  = 32'h00000000,
  APB_SLAVE0_END_ADDR5    = 32'h00000000,
  APB_SLAVE1_START_ADDR5  = 32'h00000000,
  APB_SLAVE1_END_ADDR5    = 32'h00000000,
  APB_SLAVE2_START_ADDR5  = 32'h00000000,
  APB_SLAVE2_END_ADDR5    = 32'h00000000,
  APB_SLAVE3_START_ADDR5  = 32'h00000000,
  APB_SLAVE3_END_ADDR5    = 32'h00000000,
  APB_SLAVE4_START_ADDR5  = 32'h00000000,
  APB_SLAVE4_END_ADDR5    = 32'h00000000,
  APB_SLAVE5_START_ADDR5  = 32'h00000000,
  APB_SLAVE5_END_ADDR5    = 32'h00000000,
  APB_SLAVE6_START_ADDR5  = 32'h00000000,
  APB_SLAVE6_END_ADDR5    = 32'h00000000,
  APB_SLAVE7_START_ADDR5  = 32'h00000000,
  APB_SLAVE7_END_ADDR5    = 32'h00000000,
  APB_SLAVE8_START_ADDR5  = 32'h00000000,
  APB_SLAVE8_END_ADDR5    = 32'h00000000,
  APB_SLAVE9_START_ADDR5  = 32'h00000000,
  APB_SLAVE9_END_ADDR5    = 32'h00000000,
  APB_SLAVE10_START_ADDR5  = 32'h00000000,
  APB_SLAVE10_END_ADDR5    = 32'h00000000,
  APB_SLAVE11_START_ADDR5  = 32'h00000000,
  APB_SLAVE11_END_ADDR5    = 32'h00000000,
  APB_SLAVE12_START_ADDR5  = 32'h00000000,
  APB_SLAVE12_END_ADDR5    = 32'h00000000,
  APB_SLAVE13_START_ADDR5  = 32'h00000000,
  APB_SLAVE13_END_ADDR5    = 32'h00000000,
  APB_SLAVE14_START_ADDR5  = 32'h00000000,
  APB_SLAVE14_END_ADDR5    = 32'h00000000,
  APB_SLAVE15_START_ADDR5  = 32'h00000000,
  APB_SLAVE15_END_ADDR5    = 32'h00000000;

  // AHB5 signals5
input        hclk5;
input        hreset_n5;
input        hsel5;
input[31:0]  haddr5;
input[1:0]   htrans5;
input[31:0]  hwdata5;
input        hwrite5;
output[31:0] hrdata5;
reg   [31:0] hrdata5;
output       hready5;
output[1:0]  hresp5;
  
  // APB5 signals5 common to all APB5 slaves5
input       pclk5;
input       preset_n5;
output[31:0] paddr5;
reg   [31:0] paddr5;
output       penable5;
reg          penable5;
output       pwrite5;
reg          pwrite5;
output[31:0] pwdata5;
  
  // Slave5 0 signals5
`ifdef APB_SLAVE05
  output      psel05;
  input       pready05;
  input[31:0] prdata05;
`endif
  
  // Slave5 1 signals5
`ifdef APB_SLAVE15
  output      psel15;
  input       pready15;
  input[31:0] prdata15;
`endif
  
  // Slave5 2 signals5
`ifdef APB_SLAVE25
  output      psel25;
  input       pready25;
  input[31:0] prdata25;
`endif
  
  // Slave5 3 signals5
`ifdef APB_SLAVE35
  output      psel35;
  input       pready35;
  input[31:0] prdata35;
`endif
  
  // Slave5 4 signals5
`ifdef APB_SLAVE45
  output      psel45;
  input       pready45;
  input[31:0] prdata45;
`endif
  
  // Slave5 5 signals5
`ifdef APB_SLAVE55
  output      psel55;
  input       pready55;
  input[31:0] prdata55;
`endif
  
  // Slave5 6 signals5
`ifdef APB_SLAVE65
  output      psel65;
  input       pready65;
  input[31:0] prdata65;
`endif
  
  // Slave5 7 signals5
`ifdef APB_SLAVE75
  output      psel75;
  input       pready75;
  input[31:0] prdata75;
`endif
  
  // Slave5 8 signals5
`ifdef APB_SLAVE85
  output      psel85;
  input       pready85;
  input[31:0] prdata85;
`endif
  
  // Slave5 9 signals5
`ifdef APB_SLAVE95
  output      psel95;
  input       pready95;
  input[31:0] prdata95;
`endif
  
  // Slave5 10 signals5
`ifdef APB_SLAVE105
  output      psel105;
  input       pready105;
  input[31:0] prdata105;
`endif
  
  // Slave5 11 signals5
`ifdef APB_SLAVE115
  output      psel115;
  input       pready115;
  input[31:0] prdata115;
`endif
  
  // Slave5 12 signals5
`ifdef APB_SLAVE125
  output      psel125;
  input       pready125;
  input[31:0] prdata125;
`endif
  
  // Slave5 13 signals5
`ifdef APB_SLAVE135
  output      psel135;
  input       pready135;
  input[31:0] prdata135;
`endif
  
  // Slave5 14 signals5
`ifdef APB_SLAVE145
  output      psel145;
  input       pready145;
  input[31:0] prdata145;
`endif
  
  // Slave5 15 signals5
`ifdef APB_SLAVE155
  output      psel155;
  input       pready155;
  input[31:0] prdata155;
`endif
 
reg         ahb_addr_phase5;
reg         ahb_data_phase5;
wire        valid_ahb_trans5;
wire        pready_muxed5;
wire [31:0] prdata_muxed5;
reg  [31:0] haddr_reg5;
reg         hwrite_reg5;
reg  [2:0]  apb_state5;
wire [2:0]  apb_state_idle5;
wire [2:0]  apb_state_setup5;
wire [2:0]  apb_state_access5;
reg  [15:0] slave_select5;
wire [15:0] pready_vector5;
reg  [15:0] psel_vector5;
wire [31:0] prdata0_q5;
wire [31:0] prdata1_q5;
wire [31:0] prdata2_q5;
wire [31:0] prdata3_q5;
wire [31:0] prdata4_q5;
wire [31:0] prdata5_q5;
wire [31:0] prdata6_q5;
wire [31:0] prdata7_q5;
wire [31:0] prdata8_q5;
wire [31:0] prdata9_q5;
wire [31:0] prdata10_q5;
wire [31:0] prdata11_q5;
wire [31:0] prdata12_q5;
wire [31:0] prdata13_q5;
wire [31:0] prdata14_q5;
wire [31:0] prdata15_q5;

// assign pclk5     = hclk5;
// assign preset_n5 = hreset_n5;
assign hready5   = ahb_addr_phase5;
assign pwdata5   = hwdata5;
assign hresp5  = 2'b00;

// Respond5 to NONSEQ5 or SEQ transfers5
assign valid_ahb_trans5 = ((htrans5 == 2'b10) || (htrans5 == 2'b11)) && (hsel5 == 1'b1);

always @(posedge hclk5) begin
  if (hreset_n5 == 1'b0) begin
    ahb_addr_phase5 <= 1'b1;
    ahb_data_phase5 <= 1'b0;
    haddr_reg5      <= 'b0;
    hwrite_reg5     <= 1'b0;
    hrdata5         <= 'b0;
  end
  else begin
    if (ahb_addr_phase5 == 1'b1 && valid_ahb_trans5 == 1'b1) begin
      ahb_addr_phase5 <= 1'b0;
      ahb_data_phase5 <= 1'b1;
      haddr_reg5      <= haddr5;
      hwrite_reg5     <= hwrite5;
    end
    if (ahb_data_phase5 == 1'b1 && pready_muxed5 == 1'b1 && apb_state5 == apb_state_access5) begin
      ahb_addr_phase5 <= 1'b1;
      ahb_data_phase5 <= 1'b0;
      hrdata5         <= prdata_muxed5;
    end
  end
end

// APB5 state machine5 state definitions5
assign apb_state_idle5   = 3'b001;
assign apb_state_setup5  = 3'b010;
assign apb_state_access5 = 3'b100;

// APB5 state machine5
always @(posedge hclk5 or negedge hreset_n5) begin
  if (hreset_n5 == 1'b0) begin
    apb_state5   <= apb_state_idle5;
    psel_vector5 <= 1'b0;
    penable5     <= 1'b0;
    paddr5       <= 1'b0;
    pwrite5      <= 1'b0;
  end  
  else begin
    
    // IDLE5 -> SETUP5
    if (apb_state5 == apb_state_idle5) begin
      if (ahb_data_phase5 == 1'b1) begin
        apb_state5   <= apb_state_setup5;
        psel_vector5 <= slave_select5;
        paddr5       <= haddr_reg5;
        pwrite5      <= hwrite_reg5;
      end  
    end
    
    // SETUP5 -> TRANSFER5
    if (apb_state5 == apb_state_setup5) begin
      apb_state5 <= apb_state_access5;
      penable5   <= 1'b1;
    end
    
    // TRANSFER5 -> SETUP5 or
    // TRANSFER5 -> IDLE5
    if (apb_state5 == apb_state_access5) begin
      if (pready_muxed5 == 1'b1) begin
      
        // TRANSFER5 -> SETUP5
        if (valid_ahb_trans5 == 1'b1) begin
          apb_state5   <= apb_state_setup5;
          penable5     <= 1'b0;
          psel_vector5 <= slave_select5;
          paddr5       <= haddr_reg5;
          pwrite5      <= hwrite_reg5;
        end  
        
        // TRANSFER5 -> IDLE5
        else begin
          apb_state5   <= apb_state_idle5;      
          penable5     <= 1'b0;
          psel_vector5 <= 'b0;
        end  
      end
    end
    
  end
end

always @(posedge hclk5 or negedge hreset_n5) begin
  if (hreset_n5 == 1'b0)
    slave_select5 <= 'b0;
  else begin  
  `ifdef APB_SLAVE05
     slave_select5[0]   <= valid_ahb_trans5 && (haddr5 >= APB_SLAVE0_START_ADDR5)  && (haddr5 <= APB_SLAVE0_END_ADDR5);
   `else
     slave_select5[0]   <= 1'b0;
   `endif
   
   `ifdef APB_SLAVE15
     slave_select5[1]   <= valid_ahb_trans5 && (haddr5 >= APB_SLAVE1_START_ADDR5)  && (haddr5 <= APB_SLAVE1_END_ADDR5);
   `else
     slave_select5[1]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE25  
     slave_select5[2]   <= valid_ahb_trans5 && (haddr5 >= APB_SLAVE2_START_ADDR5)  && (haddr5 <= APB_SLAVE2_END_ADDR5);
   `else
     slave_select5[2]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE35  
     slave_select5[3]   <= valid_ahb_trans5 && (haddr5 >= APB_SLAVE3_START_ADDR5)  && (haddr5 <= APB_SLAVE3_END_ADDR5);
   `else
     slave_select5[3]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE45  
     slave_select5[4]   <= valid_ahb_trans5 && (haddr5 >= APB_SLAVE4_START_ADDR5)  && (haddr5 <= APB_SLAVE4_END_ADDR5);
   `else
     slave_select5[4]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE55  
     slave_select5[5]   <= valid_ahb_trans5 && (haddr5 >= APB_SLAVE5_START_ADDR5)  && (haddr5 <= APB_SLAVE5_END_ADDR5);
   `else
     slave_select5[5]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE65  
     slave_select5[6]   <= valid_ahb_trans5 && (haddr5 >= APB_SLAVE6_START_ADDR5)  && (haddr5 <= APB_SLAVE6_END_ADDR5);
   `else
     slave_select5[6]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE75  
     slave_select5[7]   <= valid_ahb_trans5 && (haddr5 >= APB_SLAVE7_START_ADDR5)  && (haddr5 <= APB_SLAVE7_END_ADDR5);
   `else
     slave_select5[7]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE85  
     slave_select5[8]   <= valid_ahb_trans5 && (haddr5 >= APB_SLAVE8_START_ADDR5)  && (haddr5 <= APB_SLAVE8_END_ADDR5);
   `else
     slave_select5[8]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE95  
     slave_select5[9]   <= valid_ahb_trans5 && (haddr5 >= APB_SLAVE9_START_ADDR5)  && (haddr5 <= APB_SLAVE9_END_ADDR5);
   `else
     slave_select5[9]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE105  
     slave_select5[10]  <= valid_ahb_trans5 && (haddr5 >= APB_SLAVE10_START_ADDR5) && (haddr5 <= APB_SLAVE10_END_ADDR5);
   `else
     slave_select5[10]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE115  
     slave_select5[11]  <= valid_ahb_trans5 && (haddr5 >= APB_SLAVE11_START_ADDR5) && (haddr5 <= APB_SLAVE11_END_ADDR5);
   `else
     slave_select5[11]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE125  
     slave_select5[12]  <= valid_ahb_trans5 && (haddr5 >= APB_SLAVE12_START_ADDR5) && (haddr5 <= APB_SLAVE12_END_ADDR5);
   `else
     slave_select5[12]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE135  
     slave_select5[13]  <= valid_ahb_trans5 && (haddr5 >= APB_SLAVE13_START_ADDR5) && (haddr5 <= APB_SLAVE13_END_ADDR5);
   `else
     slave_select5[13]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE145  
     slave_select5[14]  <= valid_ahb_trans5 && (haddr5 >= APB_SLAVE14_START_ADDR5) && (haddr5 <= APB_SLAVE14_END_ADDR5);
   `else
     slave_select5[14]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE155  
     slave_select5[15]  <= valid_ahb_trans5 && (haddr5 >= APB_SLAVE15_START_ADDR5) && (haddr5 <= APB_SLAVE15_END_ADDR5);
   `else
     slave_select5[15]   <= 1'b0;
   `endif  
  end
end

assign pready_muxed5 = |(psel_vector5 & pready_vector5);
assign prdata_muxed5 = prdata0_q5  | prdata1_q5  | prdata2_q5  | prdata3_q5  |
                      prdata4_q5  | prdata5_q5  | prdata6_q5  | prdata7_q5  |
                      prdata8_q5  | prdata9_q5  | prdata10_q5 | prdata11_q5 |
                      prdata12_q5 | prdata13_q5 | prdata14_q5 | prdata15_q5 ;

`ifdef APB_SLAVE05
  assign psel05            = psel_vector5[0];
  assign pready_vector5[0] = pready05;
  assign prdata0_q5        = (psel05 == 1'b1) ? prdata05 : 'b0;
`else
  assign pready_vector5[0] = 1'b0;
  assign prdata0_q5        = 'b0;
`endif

`ifdef APB_SLAVE15
  assign psel15            = psel_vector5[1];
  assign pready_vector5[1] = pready15;
  assign prdata1_q5        = (psel15 == 1'b1) ? prdata15 : 'b0;
`else
  assign pready_vector5[1] = 1'b0;
  assign prdata1_q5        = 'b0;
`endif

`ifdef APB_SLAVE25
  assign psel25            = psel_vector5[2];
  assign pready_vector5[2] = pready25;
  assign prdata2_q5        = (psel25 == 1'b1) ? prdata25 : 'b0;
`else
  assign pready_vector5[2] = 1'b0;
  assign prdata2_q5        = 'b0;
`endif

`ifdef APB_SLAVE35
  assign psel35            = psel_vector5[3];
  assign pready_vector5[3] = pready35;
  assign prdata3_q5        = (psel35 == 1'b1) ? prdata35 : 'b0;
`else
  assign pready_vector5[3] = 1'b0;
  assign prdata3_q5        = 'b0;
`endif

`ifdef APB_SLAVE45
  assign psel45            = psel_vector5[4];
  assign pready_vector5[4] = pready45;
  assign prdata4_q5        = (psel45 == 1'b1) ? prdata45 : 'b0;
`else
  assign pready_vector5[4] = 1'b0;
  assign prdata4_q5        = 'b0;
`endif

`ifdef APB_SLAVE55
  assign psel55            = psel_vector5[5];
  assign pready_vector5[5] = pready55;
  assign prdata5_q5        = (psel55 == 1'b1) ? prdata55 : 'b0;
`else
  assign pready_vector5[5] = 1'b0;
  assign prdata5_q5        = 'b0;
`endif

`ifdef APB_SLAVE65
  assign psel65            = psel_vector5[6];
  assign pready_vector5[6] = pready65;
  assign prdata6_q5        = (psel65 == 1'b1) ? prdata65 : 'b0;
`else
  assign pready_vector5[6] = 1'b0;
  assign prdata6_q5        = 'b0;
`endif

`ifdef APB_SLAVE75
  assign psel75            = psel_vector5[7];
  assign pready_vector5[7] = pready75;
  assign prdata7_q5        = (psel75 == 1'b1) ? prdata75 : 'b0;
`else
  assign pready_vector5[7] = 1'b0;
  assign prdata7_q5        = 'b0;
`endif

`ifdef APB_SLAVE85
  assign psel85            = psel_vector5[8];
  assign pready_vector5[8] = pready85;
  assign prdata8_q5        = (psel85 == 1'b1) ? prdata85 : 'b0;
`else
  assign pready_vector5[8] = 1'b0;
  assign prdata8_q5        = 'b0;
`endif

`ifdef APB_SLAVE95
  assign psel95            = psel_vector5[9];
  assign pready_vector5[9] = pready95;
  assign prdata9_q5        = (psel95 == 1'b1) ? prdata95 : 'b0;
`else
  assign pready_vector5[9] = 1'b0;
  assign prdata9_q5        = 'b0;
`endif

`ifdef APB_SLAVE105
  assign psel105            = psel_vector5[10];
  assign pready_vector5[10] = pready105;
  assign prdata10_q5        = (psel105 == 1'b1) ? prdata105 : 'b0;
`else
  assign pready_vector5[10] = 1'b0;
  assign prdata10_q5        = 'b0;
`endif

`ifdef APB_SLAVE115
  assign psel115            = psel_vector5[11];
  assign pready_vector5[11] = pready115;
  assign prdata11_q5        = (psel115 == 1'b1) ? prdata115 : 'b0;
`else
  assign pready_vector5[11] = 1'b0;
  assign prdata11_q5        = 'b0;
`endif

`ifdef APB_SLAVE125
  assign psel125            = psel_vector5[12];
  assign pready_vector5[12] = pready125;
  assign prdata12_q5        = (psel125 == 1'b1) ? prdata125 : 'b0;
`else
  assign pready_vector5[12] = 1'b0;
  assign prdata12_q5        = 'b0;
`endif

`ifdef APB_SLAVE135
  assign psel135            = psel_vector5[13];
  assign pready_vector5[13] = pready135;
  assign prdata13_q5        = (psel135 == 1'b1) ? prdata135 : 'b0;
`else
  assign pready_vector5[13] = 1'b0;
  assign prdata13_q5        = 'b0;
`endif

`ifdef APB_SLAVE145
  assign psel145            = psel_vector5[14];
  assign pready_vector5[14] = pready145;
  assign prdata14_q5        = (psel145 == 1'b1) ? prdata145 : 'b0;
`else
  assign pready_vector5[14] = 1'b0;
  assign prdata14_q5        = 'b0;
`endif

`ifdef APB_SLAVE155
  assign psel155            = psel_vector5[15];
  assign pready_vector5[15] = pready155;
  assign prdata15_q5        = (psel155 == 1'b1) ? prdata155 : 'b0;
`else
  assign pready_vector5[15] = 1'b0;
  assign prdata15_q5        = 'b0;
`endif

endmodule
