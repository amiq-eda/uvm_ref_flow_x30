//File24 name   : ahb2apb24.v
//Title24       : 
//Created24     : 2010
//Description24 : Simple24 AHB24 to APB24 bridge24
//Notes24       : 
//----------------------------------------------------------------------
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------

`timescale 1ns/1ps

`include "ahb2apb_defines24.v"

module ahb2apb24
(
  // AHB24 signals24
  hclk24,
  hreset_n24,
  hsel24,
  haddr24,
  htrans24,
  hwdata24,
  hwrite24,
  hrdata24,
  hready24,
  hresp24,
  
  // APB24 signals24 common to all APB24 slaves24
  pclk24,
  preset_n24,
  paddr24,
  penable24,
  pwrite24,
  pwdata24
  
  // Slave24 0 signals24
  `ifdef APB_SLAVE024
  ,psel024
  ,pready024
  ,prdata024
  `endif
  
  // Slave24 1 signals24
  `ifdef APB_SLAVE124
  ,psel124
  ,pready124
  ,prdata124
  `endif
  
  // Slave24 2 signals24
  `ifdef APB_SLAVE224
  ,psel224
  ,pready224
  ,prdata224
  `endif
  
  // Slave24 3 signals24
  `ifdef APB_SLAVE324
  ,psel324
  ,pready324
  ,prdata324
  `endif
  
  // Slave24 4 signals24
  `ifdef APB_SLAVE424
  ,psel424
  ,pready424
  ,prdata424
  `endif
  
  // Slave24 5 signals24
  `ifdef APB_SLAVE524
  ,psel524
  ,pready524
  ,prdata524
  `endif
  
  // Slave24 6 signals24
  `ifdef APB_SLAVE624
  ,psel624
  ,pready624
  ,prdata624
  `endif
  
  // Slave24 7 signals24
  `ifdef APB_SLAVE724
  ,psel724
  ,pready724
  ,prdata724
  `endif
  
  // Slave24 8 signals24
  `ifdef APB_SLAVE824
  ,psel824
  ,pready824
  ,prdata824
  `endif
  
  // Slave24 9 signals24
  `ifdef APB_SLAVE924
  ,psel924
  ,pready924
  ,prdata924
  `endif
  
  // Slave24 10 signals24
  `ifdef APB_SLAVE1024
  ,psel1024
  ,pready1024
  ,prdata1024
  `endif
  
  // Slave24 11 signals24
  `ifdef APB_SLAVE1124
  ,psel1124
  ,pready1124
  ,prdata1124
  `endif
  
  // Slave24 12 signals24
  `ifdef APB_SLAVE1224
  ,psel1224
  ,pready1224
  ,prdata1224
  `endif
  
  // Slave24 13 signals24
  `ifdef APB_SLAVE1324
  ,psel1324
  ,pready1324
  ,prdata1324
  `endif
  
  // Slave24 14 signals24
  `ifdef APB_SLAVE1424
  ,psel1424
  ,pready1424
  ,prdata1424
  `endif
  
  // Slave24 15 signals24
  `ifdef APB_SLAVE1524
  ,psel1524
  ,pready1524
  ,prdata1524
  `endif
  
);

parameter 
  APB_SLAVE0_START_ADDR24  = 32'h00000000,
  APB_SLAVE0_END_ADDR24    = 32'h00000000,
  APB_SLAVE1_START_ADDR24  = 32'h00000000,
  APB_SLAVE1_END_ADDR24    = 32'h00000000,
  APB_SLAVE2_START_ADDR24  = 32'h00000000,
  APB_SLAVE2_END_ADDR24    = 32'h00000000,
  APB_SLAVE3_START_ADDR24  = 32'h00000000,
  APB_SLAVE3_END_ADDR24    = 32'h00000000,
  APB_SLAVE4_START_ADDR24  = 32'h00000000,
  APB_SLAVE4_END_ADDR24    = 32'h00000000,
  APB_SLAVE5_START_ADDR24  = 32'h00000000,
  APB_SLAVE5_END_ADDR24    = 32'h00000000,
  APB_SLAVE6_START_ADDR24  = 32'h00000000,
  APB_SLAVE6_END_ADDR24    = 32'h00000000,
  APB_SLAVE7_START_ADDR24  = 32'h00000000,
  APB_SLAVE7_END_ADDR24    = 32'h00000000,
  APB_SLAVE8_START_ADDR24  = 32'h00000000,
  APB_SLAVE8_END_ADDR24    = 32'h00000000,
  APB_SLAVE9_START_ADDR24  = 32'h00000000,
  APB_SLAVE9_END_ADDR24    = 32'h00000000,
  APB_SLAVE10_START_ADDR24  = 32'h00000000,
  APB_SLAVE10_END_ADDR24    = 32'h00000000,
  APB_SLAVE11_START_ADDR24  = 32'h00000000,
  APB_SLAVE11_END_ADDR24    = 32'h00000000,
  APB_SLAVE12_START_ADDR24  = 32'h00000000,
  APB_SLAVE12_END_ADDR24    = 32'h00000000,
  APB_SLAVE13_START_ADDR24  = 32'h00000000,
  APB_SLAVE13_END_ADDR24    = 32'h00000000,
  APB_SLAVE14_START_ADDR24  = 32'h00000000,
  APB_SLAVE14_END_ADDR24    = 32'h00000000,
  APB_SLAVE15_START_ADDR24  = 32'h00000000,
  APB_SLAVE15_END_ADDR24    = 32'h00000000;

  // AHB24 signals24
input        hclk24;
input        hreset_n24;
input        hsel24;
input[31:0]  haddr24;
input[1:0]   htrans24;
input[31:0]  hwdata24;
input        hwrite24;
output[31:0] hrdata24;
reg   [31:0] hrdata24;
output       hready24;
output[1:0]  hresp24;
  
  // APB24 signals24 common to all APB24 slaves24
input       pclk24;
input       preset_n24;
output[31:0] paddr24;
reg   [31:0] paddr24;
output       penable24;
reg          penable24;
output       pwrite24;
reg          pwrite24;
output[31:0] pwdata24;
  
  // Slave24 0 signals24
`ifdef APB_SLAVE024
  output      psel024;
  input       pready024;
  input[31:0] prdata024;
`endif
  
  // Slave24 1 signals24
`ifdef APB_SLAVE124
  output      psel124;
  input       pready124;
  input[31:0] prdata124;
`endif
  
  // Slave24 2 signals24
`ifdef APB_SLAVE224
  output      psel224;
  input       pready224;
  input[31:0] prdata224;
`endif
  
  // Slave24 3 signals24
`ifdef APB_SLAVE324
  output      psel324;
  input       pready324;
  input[31:0] prdata324;
`endif
  
  // Slave24 4 signals24
`ifdef APB_SLAVE424
  output      psel424;
  input       pready424;
  input[31:0] prdata424;
`endif
  
  // Slave24 5 signals24
`ifdef APB_SLAVE524
  output      psel524;
  input       pready524;
  input[31:0] prdata524;
`endif
  
  // Slave24 6 signals24
`ifdef APB_SLAVE624
  output      psel624;
  input       pready624;
  input[31:0] prdata624;
`endif
  
  // Slave24 7 signals24
`ifdef APB_SLAVE724
  output      psel724;
  input       pready724;
  input[31:0] prdata724;
`endif
  
  // Slave24 8 signals24
`ifdef APB_SLAVE824
  output      psel824;
  input       pready824;
  input[31:0] prdata824;
`endif
  
  // Slave24 9 signals24
`ifdef APB_SLAVE924
  output      psel924;
  input       pready924;
  input[31:0] prdata924;
`endif
  
  // Slave24 10 signals24
`ifdef APB_SLAVE1024
  output      psel1024;
  input       pready1024;
  input[31:0] prdata1024;
`endif
  
  // Slave24 11 signals24
`ifdef APB_SLAVE1124
  output      psel1124;
  input       pready1124;
  input[31:0] prdata1124;
`endif
  
  // Slave24 12 signals24
`ifdef APB_SLAVE1224
  output      psel1224;
  input       pready1224;
  input[31:0] prdata1224;
`endif
  
  // Slave24 13 signals24
`ifdef APB_SLAVE1324
  output      psel1324;
  input       pready1324;
  input[31:0] prdata1324;
`endif
  
  // Slave24 14 signals24
`ifdef APB_SLAVE1424
  output      psel1424;
  input       pready1424;
  input[31:0] prdata1424;
`endif
  
  // Slave24 15 signals24
`ifdef APB_SLAVE1524
  output      psel1524;
  input       pready1524;
  input[31:0] prdata1524;
`endif
 
reg         ahb_addr_phase24;
reg         ahb_data_phase24;
wire        valid_ahb_trans24;
wire        pready_muxed24;
wire [31:0] prdata_muxed24;
reg  [31:0] haddr_reg24;
reg         hwrite_reg24;
reg  [2:0]  apb_state24;
wire [2:0]  apb_state_idle24;
wire [2:0]  apb_state_setup24;
wire [2:0]  apb_state_access24;
reg  [15:0] slave_select24;
wire [15:0] pready_vector24;
reg  [15:0] psel_vector24;
wire [31:0] prdata0_q24;
wire [31:0] prdata1_q24;
wire [31:0] prdata2_q24;
wire [31:0] prdata3_q24;
wire [31:0] prdata4_q24;
wire [31:0] prdata5_q24;
wire [31:0] prdata6_q24;
wire [31:0] prdata7_q24;
wire [31:0] prdata8_q24;
wire [31:0] prdata9_q24;
wire [31:0] prdata10_q24;
wire [31:0] prdata11_q24;
wire [31:0] prdata12_q24;
wire [31:0] prdata13_q24;
wire [31:0] prdata14_q24;
wire [31:0] prdata15_q24;

// assign pclk24     = hclk24;
// assign preset_n24 = hreset_n24;
assign hready24   = ahb_addr_phase24;
assign pwdata24   = hwdata24;
assign hresp24  = 2'b00;

// Respond24 to NONSEQ24 or SEQ transfers24
assign valid_ahb_trans24 = ((htrans24 == 2'b10) || (htrans24 == 2'b11)) && (hsel24 == 1'b1);

always @(posedge hclk24) begin
  if (hreset_n24 == 1'b0) begin
    ahb_addr_phase24 <= 1'b1;
    ahb_data_phase24 <= 1'b0;
    haddr_reg24      <= 'b0;
    hwrite_reg24     <= 1'b0;
    hrdata24         <= 'b0;
  end
  else begin
    if (ahb_addr_phase24 == 1'b1 && valid_ahb_trans24 == 1'b1) begin
      ahb_addr_phase24 <= 1'b0;
      ahb_data_phase24 <= 1'b1;
      haddr_reg24      <= haddr24;
      hwrite_reg24     <= hwrite24;
    end
    if (ahb_data_phase24 == 1'b1 && pready_muxed24 == 1'b1 && apb_state24 == apb_state_access24) begin
      ahb_addr_phase24 <= 1'b1;
      ahb_data_phase24 <= 1'b0;
      hrdata24         <= prdata_muxed24;
    end
  end
end

// APB24 state machine24 state definitions24
assign apb_state_idle24   = 3'b001;
assign apb_state_setup24  = 3'b010;
assign apb_state_access24 = 3'b100;

// APB24 state machine24
always @(posedge hclk24 or negedge hreset_n24) begin
  if (hreset_n24 == 1'b0) begin
    apb_state24   <= apb_state_idle24;
    psel_vector24 <= 1'b0;
    penable24     <= 1'b0;
    paddr24       <= 1'b0;
    pwrite24      <= 1'b0;
  end  
  else begin
    
    // IDLE24 -> SETUP24
    if (apb_state24 == apb_state_idle24) begin
      if (ahb_data_phase24 == 1'b1) begin
        apb_state24   <= apb_state_setup24;
        psel_vector24 <= slave_select24;
        paddr24       <= haddr_reg24;
        pwrite24      <= hwrite_reg24;
      end  
    end
    
    // SETUP24 -> TRANSFER24
    if (apb_state24 == apb_state_setup24) begin
      apb_state24 <= apb_state_access24;
      penable24   <= 1'b1;
    end
    
    // TRANSFER24 -> SETUP24 or
    // TRANSFER24 -> IDLE24
    if (apb_state24 == apb_state_access24) begin
      if (pready_muxed24 == 1'b1) begin
      
        // TRANSFER24 -> SETUP24
        if (valid_ahb_trans24 == 1'b1) begin
          apb_state24   <= apb_state_setup24;
          penable24     <= 1'b0;
          psel_vector24 <= slave_select24;
          paddr24       <= haddr_reg24;
          pwrite24      <= hwrite_reg24;
        end  
        
        // TRANSFER24 -> IDLE24
        else begin
          apb_state24   <= apb_state_idle24;      
          penable24     <= 1'b0;
          psel_vector24 <= 'b0;
        end  
      end
    end
    
  end
end

always @(posedge hclk24 or negedge hreset_n24) begin
  if (hreset_n24 == 1'b0)
    slave_select24 <= 'b0;
  else begin  
  `ifdef APB_SLAVE024
     slave_select24[0]   <= valid_ahb_trans24 && (haddr24 >= APB_SLAVE0_START_ADDR24)  && (haddr24 <= APB_SLAVE0_END_ADDR24);
   `else
     slave_select24[0]   <= 1'b0;
   `endif
   
   `ifdef APB_SLAVE124
     slave_select24[1]   <= valid_ahb_trans24 && (haddr24 >= APB_SLAVE1_START_ADDR24)  && (haddr24 <= APB_SLAVE1_END_ADDR24);
   `else
     slave_select24[1]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE224  
     slave_select24[2]   <= valid_ahb_trans24 && (haddr24 >= APB_SLAVE2_START_ADDR24)  && (haddr24 <= APB_SLAVE2_END_ADDR24);
   `else
     slave_select24[2]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE324  
     slave_select24[3]   <= valid_ahb_trans24 && (haddr24 >= APB_SLAVE3_START_ADDR24)  && (haddr24 <= APB_SLAVE3_END_ADDR24);
   `else
     slave_select24[3]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE424  
     slave_select24[4]   <= valid_ahb_trans24 && (haddr24 >= APB_SLAVE4_START_ADDR24)  && (haddr24 <= APB_SLAVE4_END_ADDR24);
   `else
     slave_select24[4]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE524  
     slave_select24[5]   <= valid_ahb_trans24 && (haddr24 >= APB_SLAVE5_START_ADDR24)  && (haddr24 <= APB_SLAVE5_END_ADDR24);
   `else
     slave_select24[5]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE624  
     slave_select24[6]   <= valid_ahb_trans24 && (haddr24 >= APB_SLAVE6_START_ADDR24)  && (haddr24 <= APB_SLAVE6_END_ADDR24);
   `else
     slave_select24[6]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE724  
     slave_select24[7]   <= valid_ahb_trans24 && (haddr24 >= APB_SLAVE7_START_ADDR24)  && (haddr24 <= APB_SLAVE7_END_ADDR24);
   `else
     slave_select24[7]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE824  
     slave_select24[8]   <= valid_ahb_trans24 && (haddr24 >= APB_SLAVE8_START_ADDR24)  && (haddr24 <= APB_SLAVE8_END_ADDR24);
   `else
     slave_select24[8]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE924  
     slave_select24[9]   <= valid_ahb_trans24 && (haddr24 >= APB_SLAVE9_START_ADDR24)  && (haddr24 <= APB_SLAVE9_END_ADDR24);
   `else
     slave_select24[9]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1024  
     slave_select24[10]  <= valid_ahb_trans24 && (haddr24 >= APB_SLAVE10_START_ADDR24) && (haddr24 <= APB_SLAVE10_END_ADDR24);
   `else
     slave_select24[10]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1124  
     slave_select24[11]  <= valid_ahb_trans24 && (haddr24 >= APB_SLAVE11_START_ADDR24) && (haddr24 <= APB_SLAVE11_END_ADDR24);
   `else
     slave_select24[11]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1224  
     slave_select24[12]  <= valid_ahb_trans24 && (haddr24 >= APB_SLAVE12_START_ADDR24) && (haddr24 <= APB_SLAVE12_END_ADDR24);
   `else
     slave_select24[12]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1324  
     slave_select24[13]  <= valid_ahb_trans24 && (haddr24 >= APB_SLAVE13_START_ADDR24) && (haddr24 <= APB_SLAVE13_END_ADDR24);
   `else
     slave_select24[13]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1424  
     slave_select24[14]  <= valid_ahb_trans24 && (haddr24 >= APB_SLAVE14_START_ADDR24) && (haddr24 <= APB_SLAVE14_END_ADDR24);
   `else
     slave_select24[14]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1524  
     slave_select24[15]  <= valid_ahb_trans24 && (haddr24 >= APB_SLAVE15_START_ADDR24) && (haddr24 <= APB_SLAVE15_END_ADDR24);
   `else
     slave_select24[15]   <= 1'b0;
   `endif  
  end
end

assign pready_muxed24 = |(psel_vector24 & pready_vector24);
assign prdata_muxed24 = prdata0_q24  | prdata1_q24  | prdata2_q24  | prdata3_q24  |
                      prdata4_q24  | prdata5_q24  | prdata6_q24  | prdata7_q24  |
                      prdata8_q24  | prdata9_q24  | prdata10_q24 | prdata11_q24 |
                      prdata12_q24 | prdata13_q24 | prdata14_q24 | prdata15_q24 ;

`ifdef APB_SLAVE024
  assign psel024            = psel_vector24[0];
  assign pready_vector24[0] = pready024;
  assign prdata0_q24        = (psel024 == 1'b1) ? prdata024 : 'b0;
`else
  assign pready_vector24[0] = 1'b0;
  assign prdata0_q24        = 'b0;
`endif

`ifdef APB_SLAVE124
  assign psel124            = psel_vector24[1];
  assign pready_vector24[1] = pready124;
  assign prdata1_q24        = (psel124 == 1'b1) ? prdata124 : 'b0;
`else
  assign pready_vector24[1] = 1'b0;
  assign prdata1_q24        = 'b0;
`endif

`ifdef APB_SLAVE224
  assign psel224            = psel_vector24[2];
  assign pready_vector24[2] = pready224;
  assign prdata2_q24        = (psel224 == 1'b1) ? prdata224 : 'b0;
`else
  assign pready_vector24[2] = 1'b0;
  assign prdata2_q24        = 'b0;
`endif

`ifdef APB_SLAVE324
  assign psel324            = psel_vector24[3];
  assign pready_vector24[3] = pready324;
  assign prdata3_q24        = (psel324 == 1'b1) ? prdata324 : 'b0;
`else
  assign pready_vector24[3] = 1'b0;
  assign prdata3_q24        = 'b0;
`endif

`ifdef APB_SLAVE424
  assign psel424            = psel_vector24[4];
  assign pready_vector24[4] = pready424;
  assign prdata4_q24        = (psel424 == 1'b1) ? prdata424 : 'b0;
`else
  assign pready_vector24[4] = 1'b0;
  assign prdata4_q24        = 'b0;
`endif

`ifdef APB_SLAVE524
  assign psel524            = psel_vector24[5];
  assign pready_vector24[5] = pready524;
  assign prdata5_q24        = (psel524 == 1'b1) ? prdata524 : 'b0;
`else
  assign pready_vector24[5] = 1'b0;
  assign prdata5_q24        = 'b0;
`endif

`ifdef APB_SLAVE624
  assign psel624            = psel_vector24[6];
  assign pready_vector24[6] = pready624;
  assign prdata6_q24        = (psel624 == 1'b1) ? prdata624 : 'b0;
`else
  assign pready_vector24[6] = 1'b0;
  assign prdata6_q24        = 'b0;
`endif

`ifdef APB_SLAVE724
  assign psel724            = psel_vector24[7];
  assign pready_vector24[7] = pready724;
  assign prdata7_q24        = (psel724 == 1'b1) ? prdata724 : 'b0;
`else
  assign pready_vector24[7] = 1'b0;
  assign prdata7_q24        = 'b0;
`endif

`ifdef APB_SLAVE824
  assign psel824            = psel_vector24[8];
  assign pready_vector24[8] = pready824;
  assign prdata8_q24        = (psel824 == 1'b1) ? prdata824 : 'b0;
`else
  assign pready_vector24[8] = 1'b0;
  assign prdata8_q24        = 'b0;
`endif

`ifdef APB_SLAVE924
  assign psel924            = psel_vector24[9];
  assign pready_vector24[9] = pready924;
  assign prdata9_q24        = (psel924 == 1'b1) ? prdata924 : 'b0;
`else
  assign pready_vector24[9] = 1'b0;
  assign prdata9_q24        = 'b0;
`endif

`ifdef APB_SLAVE1024
  assign psel1024            = psel_vector24[10];
  assign pready_vector24[10] = pready1024;
  assign prdata10_q24        = (psel1024 == 1'b1) ? prdata1024 : 'b0;
`else
  assign pready_vector24[10] = 1'b0;
  assign prdata10_q24        = 'b0;
`endif

`ifdef APB_SLAVE1124
  assign psel1124            = psel_vector24[11];
  assign pready_vector24[11] = pready1124;
  assign prdata11_q24        = (psel1124 == 1'b1) ? prdata1124 : 'b0;
`else
  assign pready_vector24[11] = 1'b0;
  assign prdata11_q24        = 'b0;
`endif

`ifdef APB_SLAVE1224
  assign psel1224            = psel_vector24[12];
  assign pready_vector24[12] = pready1224;
  assign prdata12_q24        = (psel1224 == 1'b1) ? prdata1224 : 'b0;
`else
  assign pready_vector24[12] = 1'b0;
  assign prdata12_q24        = 'b0;
`endif

`ifdef APB_SLAVE1324
  assign psel1324            = psel_vector24[13];
  assign pready_vector24[13] = pready1324;
  assign prdata13_q24        = (psel1324 == 1'b1) ? prdata1324 : 'b0;
`else
  assign pready_vector24[13] = 1'b0;
  assign prdata13_q24        = 'b0;
`endif

`ifdef APB_SLAVE1424
  assign psel1424            = psel_vector24[14];
  assign pready_vector24[14] = pready1424;
  assign prdata14_q24        = (psel1424 == 1'b1) ? prdata1424 : 'b0;
`else
  assign pready_vector24[14] = 1'b0;
  assign prdata14_q24        = 'b0;
`endif

`ifdef APB_SLAVE1524
  assign psel1524            = psel_vector24[15];
  assign pready_vector24[15] = pready1524;
  assign prdata15_q24        = (psel1524 == 1'b1) ? prdata1524 : 'b0;
`else
  assign pready_vector24[15] = 1'b0;
  assign prdata15_q24        = 'b0;
`endif

endmodule
