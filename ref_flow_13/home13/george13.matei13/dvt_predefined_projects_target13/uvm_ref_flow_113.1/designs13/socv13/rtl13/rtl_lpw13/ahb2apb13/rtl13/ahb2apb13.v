//File13 name   : ahb2apb13.v
//Title13       : 
//Created13     : 2010
//Description13 : Simple13 AHB13 to APB13 bridge13
//Notes13       : 
//----------------------------------------------------------------------
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------

`timescale 1ns/1ps

`include "ahb2apb_defines13.v"

module ahb2apb13
(
  // AHB13 signals13
  hclk13,
  hreset_n13,
  hsel13,
  haddr13,
  htrans13,
  hwdata13,
  hwrite13,
  hrdata13,
  hready13,
  hresp13,
  
  // APB13 signals13 common to all APB13 slaves13
  pclk13,
  preset_n13,
  paddr13,
  penable13,
  pwrite13,
  pwdata13
  
  // Slave13 0 signals13
  `ifdef APB_SLAVE013
  ,psel013
  ,pready013
  ,prdata013
  `endif
  
  // Slave13 1 signals13
  `ifdef APB_SLAVE113
  ,psel113
  ,pready113
  ,prdata113
  `endif
  
  // Slave13 2 signals13
  `ifdef APB_SLAVE213
  ,psel213
  ,pready213
  ,prdata213
  `endif
  
  // Slave13 3 signals13
  `ifdef APB_SLAVE313
  ,psel313
  ,pready313
  ,prdata313
  `endif
  
  // Slave13 4 signals13
  `ifdef APB_SLAVE413
  ,psel413
  ,pready413
  ,prdata413
  `endif
  
  // Slave13 5 signals13
  `ifdef APB_SLAVE513
  ,psel513
  ,pready513
  ,prdata513
  `endif
  
  // Slave13 6 signals13
  `ifdef APB_SLAVE613
  ,psel613
  ,pready613
  ,prdata613
  `endif
  
  // Slave13 7 signals13
  `ifdef APB_SLAVE713
  ,psel713
  ,pready713
  ,prdata713
  `endif
  
  // Slave13 8 signals13
  `ifdef APB_SLAVE813
  ,psel813
  ,pready813
  ,prdata813
  `endif
  
  // Slave13 9 signals13
  `ifdef APB_SLAVE913
  ,psel913
  ,pready913
  ,prdata913
  `endif
  
  // Slave13 10 signals13
  `ifdef APB_SLAVE1013
  ,psel1013
  ,pready1013
  ,prdata1013
  `endif
  
  // Slave13 11 signals13
  `ifdef APB_SLAVE1113
  ,psel1113
  ,pready1113
  ,prdata1113
  `endif
  
  // Slave13 12 signals13
  `ifdef APB_SLAVE1213
  ,psel1213
  ,pready1213
  ,prdata1213
  `endif
  
  // Slave13 13 signals13
  `ifdef APB_SLAVE1313
  ,psel1313
  ,pready1313
  ,prdata1313
  `endif
  
  // Slave13 14 signals13
  `ifdef APB_SLAVE1413
  ,psel1413
  ,pready1413
  ,prdata1413
  `endif
  
  // Slave13 15 signals13
  `ifdef APB_SLAVE1513
  ,psel1513
  ,pready1513
  ,prdata1513
  `endif
  
);

parameter 
  APB_SLAVE0_START_ADDR13  = 32'h00000000,
  APB_SLAVE0_END_ADDR13    = 32'h00000000,
  APB_SLAVE1_START_ADDR13  = 32'h00000000,
  APB_SLAVE1_END_ADDR13    = 32'h00000000,
  APB_SLAVE2_START_ADDR13  = 32'h00000000,
  APB_SLAVE2_END_ADDR13    = 32'h00000000,
  APB_SLAVE3_START_ADDR13  = 32'h00000000,
  APB_SLAVE3_END_ADDR13    = 32'h00000000,
  APB_SLAVE4_START_ADDR13  = 32'h00000000,
  APB_SLAVE4_END_ADDR13    = 32'h00000000,
  APB_SLAVE5_START_ADDR13  = 32'h00000000,
  APB_SLAVE5_END_ADDR13    = 32'h00000000,
  APB_SLAVE6_START_ADDR13  = 32'h00000000,
  APB_SLAVE6_END_ADDR13    = 32'h00000000,
  APB_SLAVE7_START_ADDR13  = 32'h00000000,
  APB_SLAVE7_END_ADDR13    = 32'h00000000,
  APB_SLAVE8_START_ADDR13  = 32'h00000000,
  APB_SLAVE8_END_ADDR13    = 32'h00000000,
  APB_SLAVE9_START_ADDR13  = 32'h00000000,
  APB_SLAVE9_END_ADDR13    = 32'h00000000,
  APB_SLAVE10_START_ADDR13  = 32'h00000000,
  APB_SLAVE10_END_ADDR13    = 32'h00000000,
  APB_SLAVE11_START_ADDR13  = 32'h00000000,
  APB_SLAVE11_END_ADDR13    = 32'h00000000,
  APB_SLAVE12_START_ADDR13  = 32'h00000000,
  APB_SLAVE12_END_ADDR13    = 32'h00000000,
  APB_SLAVE13_START_ADDR13  = 32'h00000000,
  APB_SLAVE13_END_ADDR13    = 32'h00000000,
  APB_SLAVE14_START_ADDR13  = 32'h00000000,
  APB_SLAVE14_END_ADDR13    = 32'h00000000,
  APB_SLAVE15_START_ADDR13  = 32'h00000000,
  APB_SLAVE15_END_ADDR13    = 32'h00000000;

  // AHB13 signals13
input        hclk13;
input        hreset_n13;
input        hsel13;
input[31:0]  haddr13;
input[1:0]   htrans13;
input[31:0]  hwdata13;
input        hwrite13;
output[31:0] hrdata13;
reg   [31:0] hrdata13;
output       hready13;
output[1:0]  hresp13;
  
  // APB13 signals13 common to all APB13 slaves13
input       pclk13;
input       preset_n13;
output[31:0] paddr13;
reg   [31:0] paddr13;
output       penable13;
reg          penable13;
output       pwrite13;
reg          pwrite13;
output[31:0] pwdata13;
  
  // Slave13 0 signals13
`ifdef APB_SLAVE013
  output      psel013;
  input       pready013;
  input[31:0] prdata013;
`endif
  
  // Slave13 1 signals13
`ifdef APB_SLAVE113
  output      psel113;
  input       pready113;
  input[31:0] prdata113;
`endif
  
  // Slave13 2 signals13
`ifdef APB_SLAVE213
  output      psel213;
  input       pready213;
  input[31:0] prdata213;
`endif
  
  // Slave13 3 signals13
`ifdef APB_SLAVE313
  output      psel313;
  input       pready313;
  input[31:0] prdata313;
`endif
  
  // Slave13 4 signals13
`ifdef APB_SLAVE413
  output      psel413;
  input       pready413;
  input[31:0] prdata413;
`endif
  
  // Slave13 5 signals13
`ifdef APB_SLAVE513
  output      psel513;
  input       pready513;
  input[31:0] prdata513;
`endif
  
  // Slave13 6 signals13
`ifdef APB_SLAVE613
  output      psel613;
  input       pready613;
  input[31:0] prdata613;
`endif
  
  // Slave13 7 signals13
`ifdef APB_SLAVE713
  output      psel713;
  input       pready713;
  input[31:0] prdata713;
`endif
  
  // Slave13 8 signals13
`ifdef APB_SLAVE813
  output      psel813;
  input       pready813;
  input[31:0] prdata813;
`endif
  
  // Slave13 9 signals13
`ifdef APB_SLAVE913
  output      psel913;
  input       pready913;
  input[31:0] prdata913;
`endif
  
  // Slave13 10 signals13
`ifdef APB_SLAVE1013
  output      psel1013;
  input       pready1013;
  input[31:0] prdata1013;
`endif
  
  // Slave13 11 signals13
`ifdef APB_SLAVE1113
  output      psel1113;
  input       pready1113;
  input[31:0] prdata1113;
`endif
  
  // Slave13 12 signals13
`ifdef APB_SLAVE1213
  output      psel1213;
  input       pready1213;
  input[31:0] prdata1213;
`endif
  
  // Slave13 13 signals13
`ifdef APB_SLAVE1313
  output      psel1313;
  input       pready1313;
  input[31:0] prdata1313;
`endif
  
  // Slave13 14 signals13
`ifdef APB_SLAVE1413
  output      psel1413;
  input       pready1413;
  input[31:0] prdata1413;
`endif
  
  // Slave13 15 signals13
`ifdef APB_SLAVE1513
  output      psel1513;
  input       pready1513;
  input[31:0] prdata1513;
`endif
 
reg         ahb_addr_phase13;
reg         ahb_data_phase13;
wire        valid_ahb_trans13;
wire        pready_muxed13;
wire [31:0] prdata_muxed13;
reg  [31:0] haddr_reg13;
reg         hwrite_reg13;
reg  [2:0]  apb_state13;
wire [2:0]  apb_state_idle13;
wire [2:0]  apb_state_setup13;
wire [2:0]  apb_state_access13;
reg  [15:0] slave_select13;
wire [15:0] pready_vector13;
reg  [15:0] psel_vector13;
wire [31:0] prdata0_q13;
wire [31:0] prdata1_q13;
wire [31:0] prdata2_q13;
wire [31:0] prdata3_q13;
wire [31:0] prdata4_q13;
wire [31:0] prdata5_q13;
wire [31:0] prdata6_q13;
wire [31:0] prdata7_q13;
wire [31:0] prdata8_q13;
wire [31:0] prdata9_q13;
wire [31:0] prdata10_q13;
wire [31:0] prdata11_q13;
wire [31:0] prdata12_q13;
wire [31:0] prdata13_q13;
wire [31:0] prdata14_q13;
wire [31:0] prdata15_q13;

// assign pclk13     = hclk13;
// assign preset_n13 = hreset_n13;
assign hready13   = ahb_addr_phase13;
assign pwdata13   = hwdata13;
assign hresp13  = 2'b00;

// Respond13 to NONSEQ13 or SEQ transfers13
assign valid_ahb_trans13 = ((htrans13 == 2'b10) || (htrans13 == 2'b11)) && (hsel13 == 1'b1);

always @(posedge hclk13) begin
  if (hreset_n13 == 1'b0) begin
    ahb_addr_phase13 <= 1'b1;
    ahb_data_phase13 <= 1'b0;
    haddr_reg13      <= 'b0;
    hwrite_reg13     <= 1'b0;
    hrdata13         <= 'b0;
  end
  else begin
    if (ahb_addr_phase13 == 1'b1 && valid_ahb_trans13 == 1'b1) begin
      ahb_addr_phase13 <= 1'b0;
      ahb_data_phase13 <= 1'b1;
      haddr_reg13      <= haddr13;
      hwrite_reg13     <= hwrite13;
    end
    if (ahb_data_phase13 == 1'b1 && pready_muxed13 == 1'b1 && apb_state13 == apb_state_access13) begin
      ahb_addr_phase13 <= 1'b1;
      ahb_data_phase13 <= 1'b0;
      hrdata13         <= prdata_muxed13;
    end
  end
end

// APB13 state machine13 state definitions13
assign apb_state_idle13   = 3'b001;
assign apb_state_setup13  = 3'b010;
assign apb_state_access13 = 3'b100;

// APB13 state machine13
always @(posedge hclk13 or negedge hreset_n13) begin
  if (hreset_n13 == 1'b0) begin
    apb_state13   <= apb_state_idle13;
    psel_vector13 <= 1'b0;
    penable13     <= 1'b0;
    paddr13       <= 1'b0;
    pwrite13      <= 1'b0;
  end  
  else begin
    
    // IDLE13 -> SETUP13
    if (apb_state13 == apb_state_idle13) begin
      if (ahb_data_phase13 == 1'b1) begin
        apb_state13   <= apb_state_setup13;
        psel_vector13 <= slave_select13;
        paddr13       <= haddr_reg13;
        pwrite13      <= hwrite_reg13;
      end  
    end
    
    // SETUP13 -> TRANSFER13
    if (apb_state13 == apb_state_setup13) begin
      apb_state13 <= apb_state_access13;
      penable13   <= 1'b1;
    end
    
    // TRANSFER13 -> SETUP13 or
    // TRANSFER13 -> IDLE13
    if (apb_state13 == apb_state_access13) begin
      if (pready_muxed13 == 1'b1) begin
      
        // TRANSFER13 -> SETUP13
        if (valid_ahb_trans13 == 1'b1) begin
          apb_state13   <= apb_state_setup13;
          penable13     <= 1'b0;
          psel_vector13 <= slave_select13;
          paddr13       <= haddr_reg13;
          pwrite13      <= hwrite_reg13;
        end  
        
        // TRANSFER13 -> IDLE13
        else begin
          apb_state13   <= apb_state_idle13;      
          penable13     <= 1'b0;
          psel_vector13 <= 'b0;
        end  
      end
    end
    
  end
end

always @(posedge hclk13 or negedge hreset_n13) begin
  if (hreset_n13 == 1'b0)
    slave_select13 <= 'b0;
  else begin  
  `ifdef APB_SLAVE013
     slave_select13[0]   <= valid_ahb_trans13 && (haddr13 >= APB_SLAVE0_START_ADDR13)  && (haddr13 <= APB_SLAVE0_END_ADDR13);
   `else
     slave_select13[0]   <= 1'b0;
   `endif
   
   `ifdef APB_SLAVE113
     slave_select13[1]   <= valid_ahb_trans13 && (haddr13 >= APB_SLAVE1_START_ADDR13)  && (haddr13 <= APB_SLAVE1_END_ADDR13);
   `else
     slave_select13[1]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE213  
     slave_select13[2]   <= valid_ahb_trans13 && (haddr13 >= APB_SLAVE2_START_ADDR13)  && (haddr13 <= APB_SLAVE2_END_ADDR13);
   `else
     slave_select13[2]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE313  
     slave_select13[3]   <= valid_ahb_trans13 && (haddr13 >= APB_SLAVE3_START_ADDR13)  && (haddr13 <= APB_SLAVE3_END_ADDR13);
   `else
     slave_select13[3]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE413  
     slave_select13[4]   <= valid_ahb_trans13 && (haddr13 >= APB_SLAVE4_START_ADDR13)  && (haddr13 <= APB_SLAVE4_END_ADDR13);
   `else
     slave_select13[4]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE513  
     slave_select13[5]   <= valid_ahb_trans13 && (haddr13 >= APB_SLAVE5_START_ADDR13)  && (haddr13 <= APB_SLAVE5_END_ADDR13);
   `else
     slave_select13[5]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE613  
     slave_select13[6]   <= valid_ahb_trans13 && (haddr13 >= APB_SLAVE6_START_ADDR13)  && (haddr13 <= APB_SLAVE6_END_ADDR13);
   `else
     slave_select13[6]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE713  
     slave_select13[7]   <= valid_ahb_trans13 && (haddr13 >= APB_SLAVE7_START_ADDR13)  && (haddr13 <= APB_SLAVE7_END_ADDR13);
   `else
     slave_select13[7]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE813  
     slave_select13[8]   <= valid_ahb_trans13 && (haddr13 >= APB_SLAVE8_START_ADDR13)  && (haddr13 <= APB_SLAVE8_END_ADDR13);
   `else
     slave_select13[8]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE913  
     slave_select13[9]   <= valid_ahb_trans13 && (haddr13 >= APB_SLAVE9_START_ADDR13)  && (haddr13 <= APB_SLAVE9_END_ADDR13);
   `else
     slave_select13[9]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1013  
     slave_select13[10]  <= valid_ahb_trans13 && (haddr13 >= APB_SLAVE10_START_ADDR13) && (haddr13 <= APB_SLAVE10_END_ADDR13);
   `else
     slave_select13[10]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1113  
     slave_select13[11]  <= valid_ahb_trans13 && (haddr13 >= APB_SLAVE11_START_ADDR13) && (haddr13 <= APB_SLAVE11_END_ADDR13);
   `else
     slave_select13[11]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1213  
     slave_select13[12]  <= valid_ahb_trans13 && (haddr13 >= APB_SLAVE12_START_ADDR13) && (haddr13 <= APB_SLAVE12_END_ADDR13);
   `else
     slave_select13[12]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1313  
     slave_select13[13]  <= valid_ahb_trans13 && (haddr13 >= APB_SLAVE13_START_ADDR13) && (haddr13 <= APB_SLAVE13_END_ADDR13);
   `else
     slave_select13[13]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1413  
     slave_select13[14]  <= valid_ahb_trans13 && (haddr13 >= APB_SLAVE14_START_ADDR13) && (haddr13 <= APB_SLAVE14_END_ADDR13);
   `else
     slave_select13[14]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1513  
     slave_select13[15]  <= valid_ahb_trans13 && (haddr13 >= APB_SLAVE15_START_ADDR13) && (haddr13 <= APB_SLAVE15_END_ADDR13);
   `else
     slave_select13[15]   <= 1'b0;
   `endif  
  end
end

assign pready_muxed13 = |(psel_vector13 & pready_vector13);
assign prdata_muxed13 = prdata0_q13  | prdata1_q13  | prdata2_q13  | prdata3_q13  |
                      prdata4_q13  | prdata5_q13  | prdata6_q13  | prdata7_q13  |
                      prdata8_q13  | prdata9_q13  | prdata10_q13 | prdata11_q13 |
                      prdata12_q13 | prdata13_q13 | prdata14_q13 | prdata15_q13 ;

`ifdef APB_SLAVE013
  assign psel013            = psel_vector13[0];
  assign pready_vector13[0] = pready013;
  assign prdata0_q13        = (psel013 == 1'b1) ? prdata013 : 'b0;
`else
  assign pready_vector13[0] = 1'b0;
  assign prdata0_q13        = 'b0;
`endif

`ifdef APB_SLAVE113
  assign psel113            = psel_vector13[1];
  assign pready_vector13[1] = pready113;
  assign prdata1_q13        = (psel113 == 1'b1) ? prdata113 : 'b0;
`else
  assign pready_vector13[1] = 1'b0;
  assign prdata1_q13        = 'b0;
`endif

`ifdef APB_SLAVE213
  assign psel213            = psel_vector13[2];
  assign pready_vector13[2] = pready213;
  assign prdata2_q13        = (psel213 == 1'b1) ? prdata213 : 'b0;
`else
  assign pready_vector13[2] = 1'b0;
  assign prdata2_q13        = 'b0;
`endif

`ifdef APB_SLAVE313
  assign psel313            = psel_vector13[3];
  assign pready_vector13[3] = pready313;
  assign prdata3_q13        = (psel313 == 1'b1) ? prdata313 : 'b0;
`else
  assign pready_vector13[3] = 1'b0;
  assign prdata3_q13        = 'b0;
`endif

`ifdef APB_SLAVE413
  assign psel413            = psel_vector13[4];
  assign pready_vector13[4] = pready413;
  assign prdata4_q13        = (psel413 == 1'b1) ? prdata413 : 'b0;
`else
  assign pready_vector13[4] = 1'b0;
  assign prdata4_q13        = 'b0;
`endif

`ifdef APB_SLAVE513
  assign psel513            = psel_vector13[5];
  assign pready_vector13[5] = pready513;
  assign prdata5_q13        = (psel513 == 1'b1) ? prdata513 : 'b0;
`else
  assign pready_vector13[5] = 1'b0;
  assign prdata5_q13        = 'b0;
`endif

`ifdef APB_SLAVE613
  assign psel613            = psel_vector13[6];
  assign pready_vector13[6] = pready613;
  assign prdata6_q13        = (psel613 == 1'b1) ? prdata613 : 'b0;
`else
  assign pready_vector13[6] = 1'b0;
  assign prdata6_q13        = 'b0;
`endif

`ifdef APB_SLAVE713
  assign psel713            = psel_vector13[7];
  assign pready_vector13[7] = pready713;
  assign prdata7_q13        = (psel713 == 1'b1) ? prdata713 : 'b0;
`else
  assign pready_vector13[7] = 1'b0;
  assign prdata7_q13        = 'b0;
`endif

`ifdef APB_SLAVE813
  assign psel813            = psel_vector13[8];
  assign pready_vector13[8] = pready813;
  assign prdata8_q13        = (psel813 == 1'b1) ? prdata813 : 'b0;
`else
  assign pready_vector13[8] = 1'b0;
  assign prdata8_q13        = 'b0;
`endif

`ifdef APB_SLAVE913
  assign psel913            = psel_vector13[9];
  assign pready_vector13[9] = pready913;
  assign prdata9_q13        = (psel913 == 1'b1) ? prdata913 : 'b0;
`else
  assign pready_vector13[9] = 1'b0;
  assign prdata9_q13        = 'b0;
`endif

`ifdef APB_SLAVE1013
  assign psel1013            = psel_vector13[10];
  assign pready_vector13[10] = pready1013;
  assign prdata10_q13        = (psel1013 == 1'b1) ? prdata1013 : 'b0;
`else
  assign pready_vector13[10] = 1'b0;
  assign prdata10_q13        = 'b0;
`endif

`ifdef APB_SLAVE1113
  assign psel1113            = psel_vector13[11];
  assign pready_vector13[11] = pready1113;
  assign prdata11_q13        = (psel1113 == 1'b1) ? prdata1113 : 'b0;
`else
  assign pready_vector13[11] = 1'b0;
  assign prdata11_q13        = 'b0;
`endif

`ifdef APB_SLAVE1213
  assign psel1213            = psel_vector13[12];
  assign pready_vector13[12] = pready1213;
  assign prdata12_q13        = (psel1213 == 1'b1) ? prdata1213 : 'b0;
`else
  assign pready_vector13[12] = 1'b0;
  assign prdata12_q13        = 'b0;
`endif

`ifdef APB_SLAVE1313
  assign psel1313            = psel_vector13[13];
  assign pready_vector13[13] = pready1313;
  assign prdata13_q13        = (psel1313 == 1'b1) ? prdata1313 : 'b0;
`else
  assign pready_vector13[13] = 1'b0;
  assign prdata13_q13        = 'b0;
`endif

`ifdef APB_SLAVE1413
  assign psel1413            = psel_vector13[14];
  assign pready_vector13[14] = pready1413;
  assign prdata14_q13        = (psel1413 == 1'b1) ? prdata1413 : 'b0;
`else
  assign pready_vector13[14] = 1'b0;
  assign prdata14_q13        = 'b0;
`endif

`ifdef APB_SLAVE1513
  assign psel1513            = psel_vector13[15];
  assign pready_vector13[15] = pready1513;
  assign prdata15_q13        = (psel1513 == 1'b1) ? prdata1513 : 'b0;
`else
  assign pready_vector13[15] = 1'b0;
  assign prdata15_q13        = 'b0;
`endif

endmodule
