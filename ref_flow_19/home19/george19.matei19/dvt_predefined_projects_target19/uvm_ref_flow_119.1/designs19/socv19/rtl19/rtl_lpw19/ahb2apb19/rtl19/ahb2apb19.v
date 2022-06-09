//File19 name   : ahb2apb19.v
//Title19       : 
//Created19     : 2010
//Description19 : Simple19 AHB19 to APB19 bridge19
//Notes19       : 
//----------------------------------------------------------------------
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------

`timescale 1ns/1ps

`include "ahb2apb_defines19.v"

module ahb2apb19
(
  // AHB19 signals19
  hclk19,
  hreset_n19,
  hsel19,
  haddr19,
  htrans19,
  hwdata19,
  hwrite19,
  hrdata19,
  hready19,
  hresp19,
  
  // APB19 signals19 common to all APB19 slaves19
  pclk19,
  preset_n19,
  paddr19,
  penable19,
  pwrite19,
  pwdata19
  
  // Slave19 0 signals19
  `ifdef APB_SLAVE019
  ,psel019
  ,pready019
  ,prdata019
  `endif
  
  // Slave19 1 signals19
  `ifdef APB_SLAVE119
  ,psel119
  ,pready119
  ,prdata119
  `endif
  
  // Slave19 2 signals19
  `ifdef APB_SLAVE219
  ,psel219
  ,pready219
  ,prdata219
  `endif
  
  // Slave19 3 signals19
  `ifdef APB_SLAVE319
  ,psel319
  ,pready319
  ,prdata319
  `endif
  
  // Slave19 4 signals19
  `ifdef APB_SLAVE419
  ,psel419
  ,pready419
  ,prdata419
  `endif
  
  // Slave19 5 signals19
  `ifdef APB_SLAVE519
  ,psel519
  ,pready519
  ,prdata519
  `endif
  
  // Slave19 6 signals19
  `ifdef APB_SLAVE619
  ,psel619
  ,pready619
  ,prdata619
  `endif
  
  // Slave19 7 signals19
  `ifdef APB_SLAVE719
  ,psel719
  ,pready719
  ,prdata719
  `endif
  
  // Slave19 8 signals19
  `ifdef APB_SLAVE819
  ,psel819
  ,pready819
  ,prdata819
  `endif
  
  // Slave19 9 signals19
  `ifdef APB_SLAVE919
  ,psel919
  ,pready919
  ,prdata919
  `endif
  
  // Slave19 10 signals19
  `ifdef APB_SLAVE1019
  ,psel1019
  ,pready1019
  ,prdata1019
  `endif
  
  // Slave19 11 signals19
  `ifdef APB_SLAVE1119
  ,psel1119
  ,pready1119
  ,prdata1119
  `endif
  
  // Slave19 12 signals19
  `ifdef APB_SLAVE1219
  ,psel1219
  ,pready1219
  ,prdata1219
  `endif
  
  // Slave19 13 signals19
  `ifdef APB_SLAVE1319
  ,psel1319
  ,pready1319
  ,prdata1319
  `endif
  
  // Slave19 14 signals19
  `ifdef APB_SLAVE1419
  ,psel1419
  ,pready1419
  ,prdata1419
  `endif
  
  // Slave19 15 signals19
  `ifdef APB_SLAVE1519
  ,psel1519
  ,pready1519
  ,prdata1519
  `endif
  
);

parameter 
  APB_SLAVE0_START_ADDR19  = 32'h00000000,
  APB_SLAVE0_END_ADDR19    = 32'h00000000,
  APB_SLAVE1_START_ADDR19  = 32'h00000000,
  APB_SLAVE1_END_ADDR19    = 32'h00000000,
  APB_SLAVE2_START_ADDR19  = 32'h00000000,
  APB_SLAVE2_END_ADDR19    = 32'h00000000,
  APB_SLAVE3_START_ADDR19  = 32'h00000000,
  APB_SLAVE3_END_ADDR19    = 32'h00000000,
  APB_SLAVE4_START_ADDR19  = 32'h00000000,
  APB_SLAVE4_END_ADDR19    = 32'h00000000,
  APB_SLAVE5_START_ADDR19  = 32'h00000000,
  APB_SLAVE5_END_ADDR19    = 32'h00000000,
  APB_SLAVE6_START_ADDR19  = 32'h00000000,
  APB_SLAVE6_END_ADDR19    = 32'h00000000,
  APB_SLAVE7_START_ADDR19  = 32'h00000000,
  APB_SLAVE7_END_ADDR19    = 32'h00000000,
  APB_SLAVE8_START_ADDR19  = 32'h00000000,
  APB_SLAVE8_END_ADDR19    = 32'h00000000,
  APB_SLAVE9_START_ADDR19  = 32'h00000000,
  APB_SLAVE9_END_ADDR19    = 32'h00000000,
  APB_SLAVE10_START_ADDR19  = 32'h00000000,
  APB_SLAVE10_END_ADDR19    = 32'h00000000,
  APB_SLAVE11_START_ADDR19  = 32'h00000000,
  APB_SLAVE11_END_ADDR19    = 32'h00000000,
  APB_SLAVE12_START_ADDR19  = 32'h00000000,
  APB_SLAVE12_END_ADDR19    = 32'h00000000,
  APB_SLAVE13_START_ADDR19  = 32'h00000000,
  APB_SLAVE13_END_ADDR19    = 32'h00000000,
  APB_SLAVE14_START_ADDR19  = 32'h00000000,
  APB_SLAVE14_END_ADDR19    = 32'h00000000,
  APB_SLAVE15_START_ADDR19  = 32'h00000000,
  APB_SLAVE15_END_ADDR19    = 32'h00000000;

  // AHB19 signals19
input        hclk19;
input        hreset_n19;
input        hsel19;
input[31:0]  haddr19;
input[1:0]   htrans19;
input[31:0]  hwdata19;
input        hwrite19;
output[31:0] hrdata19;
reg   [31:0] hrdata19;
output       hready19;
output[1:0]  hresp19;
  
  // APB19 signals19 common to all APB19 slaves19
input       pclk19;
input       preset_n19;
output[31:0] paddr19;
reg   [31:0] paddr19;
output       penable19;
reg          penable19;
output       pwrite19;
reg          pwrite19;
output[31:0] pwdata19;
  
  // Slave19 0 signals19
`ifdef APB_SLAVE019
  output      psel019;
  input       pready019;
  input[31:0] prdata019;
`endif
  
  // Slave19 1 signals19
`ifdef APB_SLAVE119
  output      psel119;
  input       pready119;
  input[31:0] prdata119;
`endif
  
  // Slave19 2 signals19
`ifdef APB_SLAVE219
  output      psel219;
  input       pready219;
  input[31:0] prdata219;
`endif
  
  // Slave19 3 signals19
`ifdef APB_SLAVE319
  output      psel319;
  input       pready319;
  input[31:0] prdata319;
`endif
  
  // Slave19 4 signals19
`ifdef APB_SLAVE419
  output      psel419;
  input       pready419;
  input[31:0] prdata419;
`endif
  
  // Slave19 5 signals19
`ifdef APB_SLAVE519
  output      psel519;
  input       pready519;
  input[31:0] prdata519;
`endif
  
  // Slave19 6 signals19
`ifdef APB_SLAVE619
  output      psel619;
  input       pready619;
  input[31:0] prdata619;
`endif
  
  // Slave19 7 signals19
`ifdef APB_SLAVE719
  output      psel719;
  input       pready719;
  input[31:0] prdata719;
`endif
  
  // Slave19 8 signals19
`ifdef APB_SLAVE819
  output      psel819;
  input       pready819;
  input[31:0] prdata819;
`endif
  
  // Slave19 9 signals19
`ifdef APB_SLAVE919
  output      psel919;
  input       pready919;
  input[31:0] prdata919;
`endif
  
  // Slave19 10 signals19
`ifdef APB_SLAVE1019
  output      psel1019;
  input       pready1019;
  input[31:0] prdata1019;
`endif
  
  // Slave19 11 signals19
`ifdef APB_SLAVE1119
  output      psel1119;
  input       pready1119;
  input[31:0] prdata1119;
`endif
  
  // Slave19 12 signals19
`ifdef APB_SLAVE1219
  output      psel1219;
  input       pready1219;
  input[31:0] prdata1219;
`endif
  
  // Slave19 13 signals19
`ifdef APB_SLAVE1319
  output      psel1319;
  input       pready1319;
  input[31:0] prdata1319;
`endif
  
  // Slave19 14 signals19
`ifdef APB_SLAVE1419
  output      psel1419;
  input       pready1419;
  input[31:0] prdata1419;
`endif
  
  // Slave19 15 signals19
`ifdef APB_SLAVE1519
  output      psel1519;
  input       pready1519;
  input[31:0] prdata1519;
`endif
 
reg         ahb_addr_phase19;
reg         ahb_data_phase19;
wire        valid_ahb_trans19;
wire        pready_muxed19;
wire [31:0] prdata_muxed19;
reg  [31:0] haddr_reg19;
reg         hwrite_reg19;
reg  [2:0]  apb_state19;
wire [2:0]  apb_state_idle19;
wire [2:0]  apb_state_setup19;
wire [2:0]  apb_state_access19;
reg  [15:0] slave_select19;
wire [15:0] pready_vector19;
reg  [15:0] psel_vector19;
wire [31:0] prdata0_q19;
wire [31:0] prdata1_q19;
wire [31:0] prdata2_q19;
wire [31:0] prdata3_q19;
wire [31:0] prdata4_q19;
wire [31:0] prdata5_q19;
wire [31:0] prdata6_q19;
wire [31:0] prdata7_q19;
wire [31:0] prdata8_q19;
wire [31:0] prdata9_q19;
wire [31:0] prdata10_q19;
wire [31:0] prdata11_q19;
wire [31:0] prdata12_q19;
wire [31:0] prdata13_q19;
wire [31:0] prdata14_q19;
wire [31:0] prdata15_q19;

// assign pclk19     = hclk19;
// assign preset_n19 = hreset_n19;
assign hready19   = ahb_addr_phase19;
assign pwdata19   = hwdata19;
assign hresp19  = 2'b00;

// Respond19 to NONSEQ19 or SEQ transfers19
assign valid_ahb_trans19 = ((htrans19 == 2'b10) || (htrans19 == 2'b11)) && (hsel19 == 1'b1);

always @(posedge hclk19) begin
  if (hreset_n19 == 1'b0) begin
    ahb_addr_phase19 <= 1'b1;
    ahb_data_phase19 <= 1'b0;
    haddr_reg19      <= 'b0;
    hwrite_reg19     <= 1'b0;
    hrdata19         <= 'b0;
  end
  else begin
    if (ahb_addr_phase19 == 1'b1 && valid_ahb_trans19 == 1'b1) begin
      ahb_addr_phase19 <= 1'b0;
      ahb_data_phase19 <= 1'b1;
      haddr_reg19      <= haddr19;
      hwrite_reg19     <= hwrite19;
    end
    if (ahb_data_phase19 == 1'b1 && pready_muxed19 == 1'b1 && apb_state19 == apb_state_access19) begin
      ahb_addr_phase19 <= 1'b1;
      ahb_data_phase19 <= 1'b0;
      hrdata19         <= prdata_muxed19;
    end
  end
end

// APB19 state machine19 state definitions19
assign apb_state_idle19   = 3'b001;
assign apb_state_setup19  = 3'b010;
assign apb_state_access19 = 3'b100;

// APB19 state machine19
always @(posedge hclk19 or negedge hreset_n19) begin
  if (hreset_n19 == 1'b0) begin
    apb_state19   <= apb_state_idle19;
    psel_vector19 <= 1'b0;
    penable19     <= 1'b0;
    paddr19       <= 1'b0;
    pwrite19      <= 1'b0;
  end  
  else begin
    
    // IDLE19 -> SETUP19
    if (apb_state19 == apb_state_idle19) begin
      if (ahb_data_phase19 == 1'b1) begin
        apb_state19   <= apb_state_setup19;
        psel_vector19 <= slave_select19;
        paddr19       <= haddr_reg19;
        pwrite19      <= hwrite_reg19;
      end  
    end
    
    // SETUP19 -> TRANSFER19
    if (apb_state19 == apb_state_setup19) begin
      apb_state19 <= apb_state_access19;
      penable19   <= 1'b1;
    end
    
    // TRANSFER19 -> SETUP19 or
    // TRANSFER19 -> IDLE19
    if (apb_state19 == apb_state_access19) begin
      if (pready_muxed19 == 1'b1) begin
      
        // TRANSFER19 -> SETUP19
        if (valid_ahb_trans19 == 1'b1) begin
          apb_state19   <= apb_state_setup19;
          penable19     <= 1'b0;
          psel_vector19 <= slave_select19;
          paddr19       <= haddr_reg19;
          pwrite19      <= hwrite_reg19;
        end  
        
        // TRANSFER19 -> IDLE19
        else begin
          apb_state19   <= apb_state_idle19;      
          penable19     <= 1'b0;
          psel_vector19 <= 'b0;
        end  
      end
    end
    
  end
end

always @(posedge hclk19 or negedge hreset_n19) begin
  if (hreset_n19 == 1'b0)
    slave_select19 <= 'b0;
  else begin  
  `ifdef APB_SLAVE019
     slave_select19[0]   <= valid_ahb_trans19 && (haddr19 >= APB_SLAVE0_START_ADDR19)  && (haddr19 <= APB_SLAVE0_END_ADDR19);
   `else
     slave_select19[0]   <= 1'b0;
   `endif
   
   `ifdef APB_SLAVE119
     slave_select19[1]   <= valid_ahb_trans19 && (haddr19 >= APB_SLAVE1_START_ADDR19)  && (haddr19 <= APB_SLAVE1_END_ADDR19);
   `else
     slave_select19[1]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE219  
     slave_select19[2]   <= valid_ahb_trans19 && (haddr19 >= APB_SLAVE2_START_ADDR19)  && (haddr19 <= APB_SLAVE2_END_ADDR19);
   `else
     slave_select19[2]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE319  
     slave_select19[3]   <= valid_ahb_trans19 && (haddr19 >= APB_SLAVE3_START_ADDR19)  && (haddr19 <= APB_SLAVE3_END_ADDR19);
   `else
     slave_select19[3]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE419  
     slave_select19[4]   <= valid_ahb_trans19 && (haddr19 >= APB_SLAVE4_START_ADDR19)  && (haddr19 <= APB_SLAVE4_END_ADDR19);
   `else
     slave_select19[4]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE519  
     slave_select19[5]   <= valid_ahb_trans19 && (haddr19 >= APB_SLAVE5_START_ADDR19)  && (haddr19 <= APB_SLAVE5_END_ADDR19);
   `else
     slave_select19[5]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE619  
     slave_select19[6]   <= valid_ahb_trans19 && (haddr19 >= APB_SLAVE6_START_ADDR19)  && (haddr19 <= APB_SLAVE6_END_ADDR19);
   `else
     slave_select19[6]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE719  
     slave_select19[7]   <= valid_ahb_trans19 && (haddr19 >= APB_SLAVE7_START_ADDR19)  && (haddr19 <= APB_SLAVE7_END_ADDR19);
   `else
     slave_select19[7]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE819  
     slave_select19[8]   <= valid_ahb_trans19 && (haddr19 >= APB_SLAVE8_START_ADDR19)  && (haddr19 <= APB_SLAVE8_END_ADDR19);
   `else
     slave_select19[8]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE919  
     slave_select19[9]   <= valid_ahb_trans19 && (haddr19 >= APB_SLAVE9_START_ADDR19)  && (haddr19 <= APB_SLAVE9_END_ADDR19);
   `else
     slave_select19[9]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1019  
     slave_select19[10]  <= valid_ahb_trans19 && (haddr19 >= APB_SLAVE10_START_ADDR19) && (haddr19 <= APB_SLAVE10_END_ADDR19);
   `else
     slave_select19[10]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1119  
     slave_select19[11]  <= valid_ahb_trans19 && (haddr19 >= APB_SLAVE11_START_ADDR19) && (haddr19 <= APB_SLAVE11_END_ADDR19);
   `else
     slave_select19[11]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1219  
     slave_select19[12]  <= valid_ahb_trans19 && (haddr19 >= APB_SLAVE12_START_ADDR19) && (haddr19 <= APB_SLAVE12_END_ADDR19);
   `else
     slave_select19[12]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1319  
     slave_select19[13]  <= valid_ahb_trans19 && (haddr19 >= APB_SLAVE13_START_ADDR19) && (haddr19 <= APB_SLAVE13_END_ADDR19);
   `else
     slave_select19[13]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1419  
     slave_select19[14]  <= valid_ahb_trans19 && (haddr19 >= APB_SLAVE14_START_ADDR19) && (haddr19 <= APB_SLAVE14_END_ADDR19);
   `else
     slave_select19[14]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1519  
     slave_select19[15]  <= valid_ahb_trans19 && (haddr19 >= APB_SLAVE15_START_ADDR19) && (haddr19 <= APB_SLAVE15_END_ADDR19);
   `else
     slave_select19[15]   <= 1'b0;
   `endif  
  end
end

assign pready_muxed19 = |(psel_vector19 & pready_vector19);
assign prdata_muxed19 = prdata0_q19  | prdata1_q19  | prdata2_q19  | prdata3_q19  |
                      prdata4_q19  | prdata5_q19  | prdata6_q19  | prdata7_q19  |
                      prdata8_q19  | prdata9_q19  | prdata10_q19 | prdata11_q19 |
                      prdata12_q19 | prdata13_q19 | prdata14_q19 | prdata15_q19 ;

`ifdef APB_SLAVE019
  assign psel019            = psel_vector19[0];
  assign pready_vector19[0] = pready019;
  assign prdata0_q19        = (psel019 == 1'b1) ? prdata019 : 'b0;
`else
  assign pready_vector19[0] = 1'b0;
  assign prdata0_q19        = 'b0;
`endif

`ifdef APB_SLAVE119
  assign psel119            = psel_vector19[1];
  assign pready_vector19[1] = pready119;
  assign prdata1_q19        = (psel119 == 1'b1) ? prdata119 : 'b0;
`else
  assign pready_vector19[1] = 1'b0;
  assign prdata1_q19        = 'b0;
`endif

`ifdef APB_SLAVE219
  assign psel219            = psel_vector19[2];
  assign pready_vector19[2] = pready219;
  assign prdata2_q19        = (psel219 == 1'b1) ? prdata219 : 'b0;
`else
  assign pready_vector19[2] = 1'b0;
  assign prdata2_q19        = 'b0;
`endif

`ifdef APB_SLAVE319
  assign psel319            = psel_vector19[3];
  assign pready_vector19[3] = pready319;
  assign prdata3_q19        = (psel319 == 1'b1) ? prdata319 : 'b0;
`else
  assign pready_vector19[3] = 1'b0;
  assign prdata3_q19        = 'b0;
`endif

`ifdef APB_SLAVE419
  assign psel419            = psel_vector19[4];
  assign pready_vector19[4] = pready419;
  assign prdata4_q19        = (psel419 == 1'b1) ? prdata419 : 'b0;
`else
  assign pready_vector19[4] = 1'b0;
  assign prdata4_q19        = 'b0;
`endif

`ifdef APB_SLAVE519
  assign psel519            = psel_vector19[5];
  assign pready_vector19[5] = pready519;
  assign prdata5_q19        = (psel519 == 1'b1) ? prdata519 : 'b0;
`else
  assign pready_vector19[5] = 1'b0;
  assign prdata5_q19        = 'b0;
`endif

`ifdef APB_SLAVE619
  assign psel619            = psel_vector19[6];
  assign pready_vector19[6] = pready619;
  assign prdata6_q19        = (psel619 == 1'b1) ? prdata619 : 'b0;
`else
  assign pready_vector19[6] = 1'b0;
  assign prdata6_q19        = 'b0;
`endif

`ifdef APB_SLAVE719
  assign psel719            = psel_vector19[7];
  assign pready_vector19[7] = pready719;
  assign prdata7_q19        = (psel719 == 1'b1) ? prdata719 : 'b0;
`else
  assign pready_vector19[7] = 1'b0;
  assign prdata7_q19        = 'b0;
`endif

`ifdef APB_SLAVE819
  assign psel819            = psel_vector19[8];
  assign pready_vector19[8] = pready819;
  assign prdata8_q19        = (psel819 == 1'b1) ? prdata819 : 'b0;
`else
  assign pready_vector19[8] = 1'b0;
  assign prdata8_q19        = 'b0;
`endif

`ifdef APB_SLAVE919
  assign psel919            = psel_vector19[9];
  assign pready_vector19[9] = pready919;
  assign prdata9_q19        = (psel919 == 1'b1) ? prdata919 : 'b0;
`else
  assign pready_vector19[9] = 1'b0;
  assign prdata9_q19        = 'b0;
`endif

`ifdef APB_SLAVE1019
  assign psel1019            = psel_vector19[10];
  assign pready_vector19[10] = pready1019;
  assign prdata10_q19        = (psel1019 == 1'b1) ? prdata1019 : 'b0;
`else
  assign pready_vector19[10] = 1'b0;
  assign prdata10_q19        = 'b0;
`endif

`ifdef APB_SLAVE1119
  assign psel1119            = psel_vector19[11];
  assign pready_vector19[11] = pready1119;
  assign prdata11_q19        = (psel1119 == 1'b1) ? prdata1119 : 'b0;
`else
  assign pready_vector19[11] = 1'b0;
  assign prdata11_q19        = 'b0;
`endif

`ifdef APB_SLAVE1219
  assign psel1219            = psel_vector19[12];
  assign pready_vector19[12] = pready1219;
  assign prdata12_q19        = (psel1219 == 1'b1) ? prdata1219 : 'b0;
`else
  assign pready_vector19[12] = 1'b0;
  assign prdata12_q19        = 'b0;
`endif

`ifdef APB_SLAVE1319
  assign psel1319            = psel_vector19[13];
  assign pready_vector19[13] = pready1319;
  assign prdata13_q19        = (psel1319 == 1'b1) ? prdata1319 : 'b0;
`else
  assign pready_vector19[13] = 1'b0;
  assign prdata13_q19        = 'b0;
`endif

`ifdef APB_SLAVE1419
  assign psel1419            = psel_vector19[14];
  assign pready_vector19[14] = pready1419;
  assign prdata14_q19        = (psel1419 == 1'b1) ? prdata1419 : 'b0;
`else
  assign pready_vector19[14] = 1'b0;
  assign prdata14_q19        = 'b0;
`endif

`ifdef APB_SLAVE1519
  assign psel1519            = psel_vector19[15];
  assign pready_vector19[15] = pready1519;
  assign prdata15_q19        = (psel1519 == 1'b1) ? prdata1519 : 'b0;
`else
  assign pready_vector19[15] = 1'b0;
  assign prdata15_q19        = 'b0;
`endif

endmodule
