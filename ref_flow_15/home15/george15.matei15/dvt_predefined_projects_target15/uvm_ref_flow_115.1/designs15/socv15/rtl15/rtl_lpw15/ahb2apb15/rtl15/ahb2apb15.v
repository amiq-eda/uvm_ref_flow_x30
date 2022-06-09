//File15 name   : ahb2apb15.v
//Title15       : 
//Created15     : 2010
//Description15 : Simple15 AHB15 to APB15 bridge15
//Notes15       : 
//----------------------------------------------------------------------
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------

`timescale 1ns/1ps

`include "ahb2apb_defines15.v"

module ahb2apb15
(
  // AHB15 signals15
  hclk15,
  hreset_n15,
  hsel15,
  haddr15,
  htrans15,
  hwdata15,
  hwrite15,
  hrdata15,
  hready15,
  hresp15,
  
  // APB15 signals15 common to all APB15 slaves15
  pclk15,
  preset_n15,
  paddr15,
  penable15,
  pwrite15,
  pwdata15
  
  // Slave15 0 signals15
  `ifdef APB_SLAVE015
  ,psel015
  ,pready015
  ,prdata015
  `endif
  
  // Slave15 1 signals15
  `ifdef APB_SLAVE115
  ,psel115
  ,pready115
  ,prdata115
  `endif
  
  // Slave15 2 signals15
  `ifdef APB_SLAVE215
  ,psel215
  ,pready215
  ,prdata215
  `endif
  
  // Slave15 3 signals15
  `ifdef APB_SLAVE315
  ,psel315
  ,pready315
  ,prdata315
  `endif
  
  // Slave15 4 signals15
  `ifdef APB_SLAVE415
  ,psel415
  ,pready415
  ,prdata415
  `endif
  
  // Slave15 5 signals15
  `ifdef APB_SLAVE515
  ,psel515
  ,pready515
  ,prdata515
  `endif
  
  // Slave15 6 signals15
  `ifdef APB_SLAVE615
  ,psel615
  ,pready615
  ,prdata615
  `endif
  
  // Slave15 7 signals15
  `ifdef APB_SLAVE715
  ,psel715
  ,pready715
  ,prdata715
  `endif
  
  // Slave15 8 signals15
  `ifdef APB_SLAVE815
  ,psel815
  ,pready815
  ,prdata815
  `endif
  
  // Slave15 9 signals15
  `ifdef APB_SLAVE915
  ,psel915
  ,pready915
  ,prdata915
  `endif
  
  // Slave15 10 signals15
  `ifdef APB_SLAVE1015
  ,psel1015
  ,pready1015
  ,prdata1015
  `endif
  
  // Slave15 11 signals15
  `ifdef APB_SLAVE1115
  ,psel1115
  ,pready1115
  ,prdata1115
  `endif
  
  // Slave15 12 signals15
  `ifdef APB_SLAVE1215
  ,psel1215
  ,pready1215
  ,prdata1215
  `endif
  
  // Slave15 13 signals15
  `ifdef APB_SLAVE1315
  ,psel1315
  ,pready1315
  ,prdata1315
  `endif
  
  // Slave15 14 signals15
  `ifdef APB_SLAVE1415
  ,psel1415
  ,pready1415
  ,prdata1415
  `endif
  
  // Slave15 15 signals15
  `ifdef APB_SLAVE1515
  ,psel1515
  ,pready1515
  ,prdata1515
  `endif
  
);

parameter 
  APB_SLAVE0_START_ADDR15  = 32'h00000000,
  APB_SLAVE0_END_ADDR15    = 32'h00000000,
  APB_SLAVE1_START_ADDR15  = 32'h00000000,
  APB_SLAVE1_END_ADDR15    = 32'h00000000,
  APB_SLAVE2_START_ADDR15  = 32'h00000000,
  APB_SLAVE2_END_ADDR15    = 32'h00000000,
  APB_SLAVE3_START_ADDR15  = 32'h00000000,
  APB_SLAVE3_END_ADDR15    = 32'h00000000,
  APB_SLAVE4_START_ADDR15  = 32'h00000000,
  APB_SLAVE4_END_ADDR15    = 32'h00000000,
  APB_SLAVE5_START_ADDR15  = 32'h00000000,
  APB_SLAVE5_END_ADDR15    = 32'h00000000,
  APB_SLAVE6_START_ADDR15  = 32'h00000000,
  APB_SLAVE6_END_ADDR15    = 32'h00000000,
  APB_SLAVE7_START_ADDR15  = 32'h00000000,
  APB_SLAVE7_END_ADDR15    = 32'h00000000,
  APB_SLAVE8_START_ADDR15  = 32'h00000000,
  APB_SLAVE8_END_ADDR15    = 32'h00000000,
  APB_SLAVE9_START_ADDR15  = 32'h00000000,
  APB_SLAVE9_END_ADDR15    = 32'h00000000,
  APB_SLAVE10_START_ADDR15  = 32'h00000000,
  APB_SLAVE10_END_ADDR15    = 32'h00000000,
  APB_SLAVE11_START_ADDR15  = 32'h00000000,
  APB_SLAVE11_END_ADDR15    = 32'h00000000,
  APB_SLAVE12_START_ADDR15  = 32'h00000000,
  APB_SLAVE12_END_ADDR15    = 32'h00000000,
  APB_SLAVE13_START_ADDR15  = 32'h00000000,
  APB_SLAVE13_END_ADDR15    = 32'h00000000,
  APB_SLAVE14_START_ADDR15  = 32'h00000000,
  APB_SLAVE14_END_ADDR15    = 32'h00000000,
  APB_SLAVE15_START_ADDR15  = 32'h00000000,
  APB_SLAVE15_END_ADDR15    = 32'h00000000;

  // AHB15 signals15
input        hclk15;
input        hreset_n15;
input        hsel15;
input[31:0]  haddr15;
input[1:0]   htrans15;
input[31:0]  hwdata15;
input        hwrite15;
output[31:0] hrdata15;
reg   [31:0] hrdata15;
output       hready15;
output[1:0]  hresp15;
  
  // APB15 signals15 common to all APB15 slaves15
input       pclk15;
input       preset_n15;
output[31:0] paddr15;
reg   [31:0] paddr15;
output       penable15;
reg          penable15;
output       pwrite15;
reg          pwrite15;
output[31:0] pwdata15;
  
  // Slave15 0 signals15
`ifdef APB_SLAVE015
  output      psel015;
  input       pready015;
  input[31:0] prdata015;
`endif
  
  // Slave15 1 signals15
`ifdef APB_SLAVE115
  output      psel115;
  input       pready115;
  input[31:0] prdata115;
`endif
  
  // Slave15 2 signals15
`ifdef APB_SLAVE215
  output      psel215;
  input       pready215;
  input[31:0] prdata215;
`endif
  
  // Slave15 3 signals15
`ifdef APB_SLAVE315
  output      psel315;
  input       pready315;
  input[31:0] prdata315;
`endif
  
  // Slave15 4 signals15
`ifdef APB_SLAVE415
  output      psel415;
  input       pready415;
  input[31:0] prdata415;
`endif
  
  // Slave15 5 signals15
`ifdef APB_SLAVE515
  output      psel515;
  input       pready515;
  input[31:0] prdata515;
`endif
  
  // Slave15 6 signals15
`ifdef APB_SLAVE615
  output      psel615;
  input       pready615;
  input[31:0] prdata615;
`endif
  
  // Slave15 7 signals15
`ifdef APB_SLAVE715
  output      psel715;
  input       pready715;
  input[31:0] prdata715;
`endif
  
  // Slave15 8 signals15
`ifdef APB_SLAVE815
  output      psel815;
  input       pready815;
  input[31:0] prdata815;
`endif
  
  // Slave15 9 signals15
`ifdef APB_SLAVE915
  output      psel915;
  input       pready915;
  input[31:0] prdata915;
`endif
  
  // Slave15 10 signals15
`ifdef APB_SLAVE1015
  output      psel1015;
  input       pready1015;
  input[31:0] prdata1015;
`endif
  
  // Slave15 11 signals15
`ifdef APB_SLAVE1115
  output      psel1115;
  input       pready1115;
  input[31:0] prdata1115;
`endif
  
  // Slave15 12 signals15
`ifdef APB_SLAVE1215
  output      psel1215;
  input       pready1215;
  input[31:0] prdata1215;
`endif
  
  // Slave15 13 signals15
`ifdef APB_SLAVE1315
  output      psel1315;
  input       pready1315;
  input[31:0] prdata1315;
`endif
  
  // Slave15 14 signals15
`ifdef APB_SLAVE1415
  output      psel1415;
  input       pready1415;
  input[31:0] prdata1415;
`endif
  
  // Slave15 15 signals15
`ifdef APB_SLAVE1515
  output      psel1515;
  input       pready1515;
  input[31:0] prdata1515;
`endif
 
reg         ahb_addr_phase15;
reg         ahb_data_phase15;
wire        valid_ahb_trans15;
wire        pready_muxed15;
wire [31:0] prdata_muxed15;
reg  [31:0] haddr_reg15;
reg         hwrite_reg15;
reg  [2:0]  apb_state15;
wire [2:0]  apb_state_idle15;
wire [2:0]  apb_state_setup15;
wire [2:0]  apb_state_access15;
reg  [15:0] slave_select15;
wire [15:0] pready_vector15;
reg  [15:0] psel_vector15;
wire [31:0] prdata0_q15;
wire [31:0] prdata1_q15;
wire [31:0] prdata2_q15;
wire [31:0] prdata3_q15;
wire [31:0] prdata4_q15;
wire [31:0] prdata5_q15;
wire [31:0] prdata6_q15;
wire [31:0] prdata7_q15;
wire [31:0] prdata8_q15;
wire [31:0] prdata9_q15;
wire [31:0] prdata10_q15;
wire [31:0] prdata11_q15;
wire [31:0] prdata12_q15;
wire [31:0] prdata13_q15;
wire [31:0] prdata14_q15;
wire [31:0] prdata15_q15;

// assign pclk15     = hclk15;
// assign preset_n15 = hreset_n15;
assign hready15   = ahb_addr_phase15;
assign pwdata15   = hwdata15;
assign hresp15  = 2'b00;

// Respond15 to NONSEQ15 or SEQ transfers15
assign valid_ahb_trans15 = ((htrans15 == 2'b10) || (htrans15 == 2'b11)) && (hsel15 == 1'b1);

always @(posedge hclk15) begin
  if (hreset_n15 == 1'b0) begin
    ahb_addr_phase15 <= 1'b1;
    ahb_data_phase15 <= 1'b0;
    haddr_reg15      <= 'b0;
    hwrite_reg15     <= 1'b0;
    hrdata15         <= 'b0;
  end
  else begin
    if (ahb_addr_phase15 == 1'b1 && valid_ahb_trans15 == 1'b1) begin
      ahb_addr_phase15 <= 1'b0;
      ahb_data_phase15 <= 1'b1;
      haddr_reg15      <= haddr15;
      hwrite_reg15     <= hwrite15;
    end
    if (ahb_data_phase15 == 1'b1 && pready_muxed15 == 1'b1 && apb_state15 == apb_state_access15) begin
      ahb_addr_phase15 <= 1'b1;
      ahb_data_phase15 <= 1'b0;
      hrdata15         <= prdata_muxed15;
    end
  end
end

// APB15 state machine15 state definitions15
assign apb_state_idle15   = 3'b001;
assign apb_state_setup15  = 3'b010;
assign apb_state_access15 = 3'b100;

// APB15 state machine15
always @(posedge hclk15 or negedge hreset_n15) begin
  if (hreset_n15 == 1'b0) begin
    apb_state15   <= apb_state_idle15;
    psel_vector15 <= 1'b0;
    penable15     <= 1'b0;
    paddr15       <= 1'b0;
    pwrite15      <= 1'b0;
  end  
  else begin
    
    // IDLE15 -> SETUP15
    if (apb_state15 == apb_state_idle15) begin
      if (ahb_data_phase15 == 1'b1) begin
        apb_state15   <= apb_state_setup15;
        psel_vector15 <= slave_select15;
        paddr15       <= haddr_reg15;
        pwrite15      <= hwrite_reg15;
      end  
    end
    
    // SETUP15 -> TRANSFER15
    if (apb_state15 == apb_state_setup15) begin
      apb_state15 <= apb_state_access15;
      penable15   <= 1'b1;
    end
    
    // TRANSFER15 -> SETUP15 or
    // TRANSFER15 -> IDLE15
    if (apb_state15 == apb_state_access15) begin
      if (pready_muxed15 == 1'b1) begin
      
        // TRANSFER15 -> SETUP15
        if (valid_ahb_trans15 == 1'b1) begin
          apb_state15   <= apb_state_setup15;
          penable15     <= 1'b0;
          psel_vector15 <= slave_select15;
          paddr15       <= haddr_reg15;
          pwrite15      <= hwrite_reg15;
        end  
        
        // TRANSFER15 -> IDLE15
        else begin
          apb_state15   <= apb_state_idle15;      
          penable15     <= 1'b0;
          psel_vector15 <= 'b0;
        end  
      end
    end
    
  end
end

always @(posedge hclk15 or negedge hreset_n15) begin
  if (hreset_n15 == 1'b0)
    slave_select15 <= 'b0;
  else begin  
  `ifdef APB_SLAVE015
     slave_select15[0]   <= valid_ahb_trans15 && (haddr15 >= APB_SLAVE0_START_ADDR15)  && (haddr15 <= APB_SLAVE0_END_ADDR15);
   `else
     slave_select15[0]   <= 1'b0;
   `endif
   
   `ifdef APB_SLAVE115
     slave_select15[1]   <= valid_ahb_trans15 && (haddr15 >= APB_SLAVE1_START_ADDR15)  && (haddr15 <= APB_SLAVE1_END_ADDR15);
   `else
     slave_select15[1]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE215  
     slave_select15[2]   <= valid_ahb_trans15 && (haddr15 >= APB_SLAVE2_START_ADDR15)  && (haddr15 <= APB_SLAVE2_END_ADDR15);
   `else
     slave_select15[2]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE315  
     slave_select15[3]   <= valid_ahb_trans15 && (haddr15 >= APB_SLAVE3_START_ADDR15)  && (haddr15 <= APB_SLAVE3_END_ADDR15);
   `else
     slave_select15[3]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE415  
     slave_select15[4]   <= valid_ahb_trans15 && (haddr15 >= APB_SLAVE4_START_ADDR15)  && (haddr15 <= APB_SLAVE4_END_ADDR15);
   `else
     slave_select15[4]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE515  
     slave_select15[5]   <= valid_ahb_trans15 && (haddr15 >= APB_SLAVE5_START_ADDR15)  && (haddr15 <= APB_SLAVE5_END_ADDR15);
   `else
     slave_select15[5]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE615  
     slave_select15[6]   <= valid_ahb_trans15 && (haddr15 >= APB_SLAVE6_START_ADDR15)  && (haddr15 <= APB_SLAVE6_END_ADDR15);
   `else
     slave_select15[6]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE715  
     slave_select15[7]   <= valid_ahb_trans15 && (haddr15 >= APB_SLAVE7_START_ADDR15)  && (haddr15 <= APB_SLAVE7_END_ADDR15);
   `else
     slave_select15[7]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE815  
     slave_select15[8]   <= valid_ahb_trans15 && (haddr15 >= APB_SLAVE8_START_ADDR15)  && (haddr15 <= APB_SLAVE8_END_ADDR15);
   `else
     slave_select15[8]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE915  
     slave_select15[9]   <= valid_ahb_trans15 && (haddr15 >= APB_SLAVE9_START_ADDR15)  && (haddr15 <= APB_SLAVE9_END_ADDR15);
   `else
     slave_select15[9]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1015  
     slave_select15[10]  <= valid_ahb_trans15 && (haddr15 >= APB_SLAVE10_START_ADDR15) && (haddr15 <= APB_SLAVE10_END_ADDR15);
   `else
     slave_select15[10]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1115  
     slave_select15[11]  <= valid_ahb_trans15 && (haddr15 >= APB_SLAVE11_START_ADDR15) && (haddr15 <= APB_SLAVE11_END_ADDR15);
   `else
     slave_select15[11]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1215  
     slave_select15[12]  <= valid_ahb_trans15 && (haddr15 >= APB_SLAVE12_START_ADDR15) && (haddr15 <= APB_SLAVE12_END_ADDR15);
   `else
     slave_select15[12]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1315  
     slave_select15[13]  <= valid_ahb_trans15 && (haddr15 >= APB_SLAVE13_START_ADDR15) && (haddr15 <= APB_SLAVE13_END_ADDR15);
   `else
     slave_select15[13]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1415  
     slave_select15[14]  <= valid_ahb_trans15 && (haddr15 >= APB_SLAVE14_START_ADDR15) && (haddr15 <= APB_SLAVE14_END_ADDR15);
   `else
     slave_select15[14]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1515  
     slave_select15[15]  <= valid_ahb_trans15 && (haddr15 >= APB_SLAVE15_START_ADDR15) && (haddr15 <= APB_SLAVE15_END_ADDR15);
   `else
     slave_select15[15]   <= 1'b0;
   `endif  
  end
end

assign pready_muxed15 = |(psel_vector15 & pready_vector15);
assign prdata_muxed15 = prdata0_q15  | prdata1_q15  | prdata2_q15  | prdata3_q15  |
                      prdata4_q15  | prdata5_q15  | prdata6_q15  | prdata7_q15  |
                      prdata8_q15  | prdata9_q15  | prdata10_q15 | prdata11_q15 |
                      prdata12_q15 | prdata13_q15 | prdata14_q15 | prdata15_q15 ;

`ifdef APB_SLAVE015
  assign psel015            = psel_vector15[0];
  assign pready_vector15[0] = pready015;
  assign prdata0_q15        = (psel015 == 1'b1) ? prdata015 : 'b0;
`else
  assign pready_vector15[0] = 1'b0;
  assign prdata0_q15        = 'b0;
`endif

`ifdef APB_SLAVE115
  assign psel115            = psel_vector15[1];
  assign pready_vector15[1] = pready115;
  assign prdata1_q15        = (psel115 == 1'b1) ? prdata115 : 'b0;
`else
  assign pready_vector15[1] = 1'b0;
  assign prdata1_q15        = 'b0;
`endif

`ifdef APB_SLAVE215
  assign psel215            = psel_vector15[2];
  assign pready_vector15[2] = pready215;
  assign prdata2_q15        = (psel215 == 1'b1) ? prdata215 : 'b0;
`else
  assign pready_vector15[2] = 1'b0;
  assign prdata2_q15        = 'b0;
`endif

`ifdef APB_SLAVE315
  assign psel315            = psel_vector15[3];
  assign pready_vector15[3] = pready315;
  assign prdata3_q15        = (psel315 == 1'b1) ? prdata315 : 'b0;
`else
  assign pready_vector15[3] = 1'b0;
  assign prdata3_q15        = 'b0;
`endif

`ifdef APB_SLAVE415
  assign psel415            = psel_vector15[4];
  assign pready_vector15[4] = pready415;
  assign prdata4_q15        = (psel415 == 1'b1) ? prdata415 : 'b0;
`else
  assign pready_vector15[4] = 1'b0;
  assign prdata4_q15        = 'b0;
`endif

`ifdef APB_SLAVE515
  assign psel515            = psel_vector15[5];
  assign pready_vector15[5] = pready515;
  assign prdata5_q15        = (psel515 == 1'b1) ? prdata515 : 'b0;
`else
  assign pready_vector15[5] = 1'b0;
  assign prdata5_q15        = 'b0;
`endif

`ifdef APB_SLAVE615
  assign psel615            = psel_vector15[6];
  assign pready_vector15[6] = pready615;
  assign prdata6_q15        = (psel615 == 1'b1) ? prdata615 : 'b0;
`else
  assign pready_vector15[6] = 1'b0;
  assign prdata6_q15        = 'b0;
`endif

`ifdef APB_SLAVE715
  assign psel715            = psel_vector15[7];
  assign pready_vector15[7] = pready715;
  assign prdata7_q15        = (psel715 == 1'b1) ? prdata715 : 'b0;
`else
  assign pready_vector15[7] = 1'b0;
  assign prdata7_q15        = 'b0;
`endif

`ifdef APB_SLAVE815
  assign psel815            = psel_vector15[8];
  assign pready_vector15[8] = pready815;
  assign prdata8_q15        = (psel815 == 1'b1) ? prdata815 : 'b0;
`else
  assign pready_vector15[8] = 1'b0;
  assign prdata8_q15        = 'b0;
`endif

`ifdef APB_SLAVE915
  assign psel915            = psel_vector15[9];
  assign pready_vector15[9] = pready915;
  assign prdata9_q15        = (psel915 == 1'b1) ? prdata915 : 'b0;
`else
  assign pready_vector15[9] = 1'b0;
  assign prdata9_q15        = 'b0;
`endif

`ifdef APB_SLAVE1015
  assign psel1015            = psel_vector15[10];
  assign pready_vector15[10] = pready1015;
  assign prdata10_q15        = (psel1015 == 1'b1) ? prdata1015 : 'b0;
`else
  assign pready_vector15[10] = 1'b0;
  assign prdata10_q15        = 'b0;
`endif

`ifdef APB_SLAVE1115
  assign psel1115            = psel_vector15[11];
  assign pready_vector15[11] = pready1115;
  assign prdata11_q15        = (psel1115 == 1'b1) ? prdata1115 : 'b0;
`else
  assign pready_vector15[11] = 1'b0;
  assign prdata11_q15        = 'b0;
`endif

`ifdef APB_SLAVE1215
  assign psel1215            = psel_vector15[12];
  assign pready_vector15[12] = pready1215;
  assign prdata12_q15        = (psel1215 == 1'b1) ? prdata1215 : 'b0;
`else
  assign pready_vector15[12] = 1'b0;
  assign prdata12_q15        = 'b0;
`endif

`ifdef APB_SLAVE1315
  assign psel1315            = psel_vector15[13];
  assign pready_vector15[13] = pready1315;
  assign prdata13_q15        = (psel1315 == 1'b1) ? prdata1315 : 'b0;
`else
  assign pready_vector15[13] = 1'b0;
  assign prdata13_q15        = 'b0;
`endif

`ifdef APB_SLAVE1415
  assign psel1415            = psel_vector15[14];
  assign pready_vector15[14] = pready1415;
  assign prdata14_q15        = (psel1415 == 1'b1) ? prdata1415 : 'b0;
`else
  assign pready_vector15[14] = 1'b0;
  assign prdata14_q15        = 'b0;
`endif

`ifdef APB_SLAVE1515
  assign psel1515            = psel_vector15[15];
  assign pready_vector15[15] = pready1515;
  assign prdata15_q15        = (psel1515 == 1'b1) ? prdata1515 : 'b0;
`else
  assign pready_vector15[15] = 1'b0;
  assign prdata15_q15        = 'b0;
`endif

endmodule
