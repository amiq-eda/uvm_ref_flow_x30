//File30 name   : ahb2apb30.v
//Title30       : 
//Created30     : 2010
//Description30 : Simple30 AHB30 to APB30 bridge30
//Notes30       : 
//----------------------------------------------------------------------
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------

`timescale 1ns/1ps

`include "ahb2apb_defines30.v"

module ahb2apb30
(
  // AHB30 signals30
  hclk30,
  hreset_n30,
  hsel30,
  haddr30,
  htrans30,
  hwdata30,
  hwrite30,
  hrdata30,
  hready30,
  hresp30,
  
  // APB30 signals30 common to all APB30 slaves30
  pclk30,
  preset_n30,
  paddr30,
  penable30,
  pwrite30,
  pwdata30
  
  // Slave30 0 signals30
  `ifdef APB_SLAVE030
  ,psel030
  ,pready030
  ,prdata030
  `endif
  
  // Slave30 1 signals30
  `ifdef APB_SLAVE130
  ,psel130
  ,pready130
  ,prdata130
  `endif
  
  // Slave30 2 signals30
  `ifdef APB_SLAVE230
  ,psel230
  ,pready230
  ,prdata230
  `endif
  
  // Slave30 3 signals30
  `ifdef APB_SLAVE330
  ,psel330
  ,pready330
  ,prdata330
  `endif
  
  // Slave30 4 signals30
  `ifdef APB_SLAVE430
  ,psel430
  ,pready430
  ,prdata430
  `endif
  
  // Slave30 5 signals30
  `ifdef APB_SLAVE530
  ,psel530
  ,pready530
  ,prdata530
  `endif
  
  // Slave30 6 signals30
  `ifdef APB_SLAVE630
  ,psel630
  ,pready630
  ,prdata630
  `endif
  
  // Slave30 7 signals30
  `ifdef APB_SLAVE730
  ,psel730
  ,pready730
  ,prdata730
  `endif
  
  // Slave30 8 signals30
  `ifdef APB_SLAVE830
  ,psel830
  ,pready830
  ,prdata830
  `endif
  
  // Slave30 9 signals30
  `ifdef APB_SLAVE930
  ,psel930
  ,pready930
  ,prdata930
  `endif
  
  // Slave30 10 signals30
  `ifdef APB_SLAVE1030
  ,psel1030
  ,pready1030
  ,prdata1030
  `endif
  
  // Slave30 11 signals30
  `ifdef APB_SLAVE1130
  ,psel1130
  ,pready1130
  ,prdata1130
  `endif
  
  // Slave30 12 signals30
  `ifdef APB_SLAVE1230
  ,psel1230
  ,pready1230
  ,prdata1230
  `endif
  
  // Slave30 13 signals30
  `ifdef APB_SLAVE1330
  ,psel1330
  ,pready1330
  ,prdata1330
  `endif
  
  // Slave30 14 signals30
  `ifdef APB_SLAVE1430
  ,psel1430
  ,pready1430
  ,prdata1430
  `endif
  
  // Slave30 15 signals30
  `ifdef APB_SLAVE1530
  ,psel1530
  ,pready1530
  ,prdata1530
  `endif
  
);

parameter 
  APB_SLAVE0_START_ADDR30  = 32'h00000000,
  APB_SLAVE0_END_ADDR30    = 32'h00000000,
  APB_SLAVE1_START_ADDR30  = 32'h00000000,
  APB_SLAVE1_END_ADDR30    = 32'h00000000,
  APB_SLAVE2_START_ADDR30  = 32'h00000000,
  APB_SLAVE2_END_ADDR30    = 32'h00000000,
  APB_SLAVE3_START_ADDR30  = 32'h00000000,
  APB_SLAVE3_END_ADDR30    = 32'h00000000,
  APB_SLAVE4_START_ADDR30  = 32'h00000000,
  APB_SLAVE4_END_ADDR30    = 32'h00000000,
  APB_SLAVE5_START_ADDR30  = 32'h00000000,
  APB_SLAVE5_END_ADDR30    = 32'h00000000,
  APB_SLAVE6_START_ADDR30  = 32'h00000000,
  APB_SLAVE6_END_ADDR30    = 32'h00000000,
  APB_SLAVE7_START_ADDR30  = 32'h00000000,
  APB_SLAVE7_END_ADDR30    = 32'h00000000,
  APB_SLAVE8_START_ADDR30  = 32'h00000000,
  APB_SLAVE8_END_ADDR30    = 32'h00000000,
  APB_SLAVE9_START_ADDR30  = 32'h00000000,
  APB_SLAVE9_END_ADDR30    = 32'h00000000,
  APB_SLAVE10_START_ADDR30  = 32'h00000000,
  APB_SLAVE10_END_ADDR30    = 32'h00000000,
  APB_SLAVE11_START_ADDR30  = 32'h00000000,
  APB_SLAVE11_END_ADDR30    = 32'h00000000,
  APB_SLAVE12_START_ADDR30  = 32'h00000000,
  APB_SLAVE12_END_ADDR30    = 32'h00000000,
  APB_SLAVE13_START_ADDR30  = 32'h00000000,
  APB_SLAVE13_END_ADDR30    = 32'h00000000,
  APB_SLAVE14_START_ADDR30  = 32'h00000000,
  APB_SLAVE14_END_ADDR30    = 32'h00000000,
  APB_SLAVE15_START_ADDR30  = 32'h00000000,
  APB_SLAVE15_END_ADDR30    = 32'h00000000;

  // AHB30 signals30
input        hclk30;
input        hreset_n30;
input        hsel30;
input[31:0]  haddr30;
input[1:0]   htrans30;
input[31:0]  hwdata30;
input        hwrite30;
output[31:0] hrdata30;
reg   [31:0] hrdata30;
output       hready30;
output[1:0]  hresp30;
  
  // APB30 signals30 common to all APB30 slaves30
input       pclk30;
input       preset_n30;
output[31:0] paddr30;
reg   [31:0] paddr30;
output       penable30;
reg          penable30;
output       pwrite30;
reg          pwrite30;
output[31:0] pwdata30;
  
  // Slave30 0 signals30
`ifdef APB_SLAVE030
  output      psel030;
  input       pready030;
  input[31:0] prdata030;
`endif
  
  // Slave30 1 signals30
`ifdef APB_SLAVE130
  output      psel130;
  input       pready130;
  input[31:0] prdata130;
`endif
  
  // Slave30 2 signals30
`ifdef APB_SLAVE230
  output      psel230;
  input       pready230;
  input[31:0] prdata230;
`endif
  
  // Slave30 3 signals30
`ifdef APB_SLAVE330
  output      psel330;
  input       pready330;
  input[31:0] prdata330;
`endif
  
  // Slave30 4 signals30
`ifdef APB_SLAVE430
  output      psel430;
  input       pready430;
  input[31:0] prdata430;
`endif
  
  // Slave30 5 signals30
`ifdef APB_SLAVE530
  output      psel530;
  input       pready530;
  input[31:0] prdata530;
`endif
  
  // Slave30 6 signals30
`ifdef APB_SLAVE630
  output      psel630;
  input       pready630;
  input[31:0] prdata630;
`endif
  
  // Slave30 7 signals30
`ifdef APB_SLAVE730
  output      psel730;
  input       pready730;
  input[31:0] prdata730;
`endif
  
  // Slave30 8 signals30
`ifdef APB_SLAVE830
  output      psel830;
  input       pready830;
  input[31:0] prdata830;
`endif
  
  // Slave30 9 signals30
`ifdef APB_SLAVE930
  output      psel930;
  input       pready930;
  input[31:0] prdata930;
`endif
  
  // Slave30 10 signals30
`ifdef APB_SLAVE1030
  output      psel1030;
  input       pready1030;
  input[31:0] prdata1030;
`endif
  
  // Slave30 11 signals30
`ifdef APB_SLAVE1130
  output      psel1130;
  input       pready1130;
  input[31:0] prdata1130;
`endif
  
  // Slave30 12 signals30
`ifdef APB_SLAVE1230
  output      psel1230;
  input       pready1230;
  input[31:0] prdata1230;
`endif
  
  // Slave30 13 signals30
`ifdef APB_SLAVE1330
  output      psel1330;
  input       pready1330;
  input[31:0] prdata1330;
`endif
  
  // Slave30 14 signals30
`ifdef APB_SLAVE1430
  output      psel1430;
  input       pready1430;
  input[31:0] prdata1430;
`endif
  
  // Slave30 15 signals30
`ifdef APB_SLAVE1530
  output      psel1530;
  input       pready1530;
  input[31:0] prdata1530;
`endif
 
reg         ahb_addr_phase30;
reg         ahb_data_phase30;
wire        valid_ahb_trans30;
wire        pready_muxed30;
wire [31:0] prdata_muxed30;
reg  [31:0] haddr_reg30;
reg         hwrite_reg30;
reg  [2:0]  apb_state30;
wire [2:0]  apb_state_idle30;
wire [2:0]  apb_state_setup30;
wire [2:0]  apb_state_access30;
reg  [15:0] slave_select30;
wire [15:0] pready_vector30;
reg  [15:0] psel_vector30;
wire [31:0] prdata0_q30;
wire [31:0] prdata1_q30;
wire [31:0] prdata2_q30;
wire [31:0] prdata3_q30;
wire [31:0] prdata4_q30;
wire [31:0] prdata5_q30;
wire [31:0] prdata6_q30;
wire [31:0] prdata7_q30;
wire [31:0] prdata8_q30;
wire [31:0] prdata9_q30;
wire [31:0] prdata10_q30;
wire [31:0] prdata11_q30;
wire [31:0] prdata12_q30;
wire [31:0] prdata13_q30;
wire [31:0] prdata14_q30;
wire [31:0] prdata15_q30;

// assign pclk30     = hclk30;
// assign preset_n30 = hreset_n30;
assign hready30   = ahb_addr_phase30;
assign pwdata30   = hwdata30;
assign hresp30  = 2'b00;

// Respond30 to NONSEQ30 or SEQ transfers30
assign valid_ahb_trans30 = ((htrans30 == 2'b10) || (htrans30 == 2'b11)) && (hsel30 == 1'b1);

always @(posedge hclk30) begin
  if (hreset_n30 == 1'b0) begin
    ahb_addr_phase30 <= 1'b1;
    ahb_data_phase30 <= 1'b0;
    haddr_reg30      <= 'b0;
    hwrite_reg30     <= 1'b0;
    hrdata30         <= 'b0;
  end
  else begin
    if (ahb_addr_phase30 == 1'b1 && valid_ahb_trans30 == 1'b1) begin
      ahb_addr_phase30 <= 1'b0;
      ahb_data_phase30 <= 1'b1;
      haddr_reg30      <= haddr30;
      hwrite_reg30     <= hwrite30;
    end
    if (ahb_data_phase30 == 1'b1 && pready_muxed30 == 1'b1 && apb_state30 == apb_state_access30) begin
      ahb_addr_phase30 <= 1'b1;
      ahb_data_phase30 <= 1'b0;
      hrdata30         <= prdata_muxed30;
    end
  end
end

// APB30 state machine30 state definitions30
assign apb_state_idle30   = 3'b001;
assign apb_state_setup30  = 3'b010;
assign apb_state_access30 = 3'b100;

// APB30 state machine30
always @(posedge hclk30 or negedge hreset_n30) begin
  if (hreset_n30 == 1'b0) begin
    apb_state30   <= apb_state_idle30;
    psel_vector30 <= 1'b0;
    penable30     <= 1'b0;
    paddr30       <= 1'b0;
    pwrite30      <= 1'b0;
  end  
  else begin
    
    // IDLE30 -> SETUP30
    if (apb_state30 == apb_state_idle30) begin
      if (ahb_data_phase30 == 1'b1) begin
        apb_state30   <= apb_state_setup30;
        psel_vector30 <= slave_select30;
        paddr30       <= haddr_reg30;
        pwrite30      <= hwrite_reg30;
      end  
    end
    
    // SETUP30 -> TRANSFER30
    if (apb_state30 == apb_state_setup30) begin
      apb_state30 <= apb_state_access30;
      penable30   <= 1'b1;
    end
    
    // TRANSFER30 -> SETUP30 or
    // TRANSFER30 -> IDLE30
    if (apb_state30 == apb_state_access30) begin
      if (pready_muxed30 == 1'b1) begin
      
        // TRANSFER30 -> SETUP30
        if (valid_ahb_trans30 == 1'b1) begin
          apb_state30   <= apb_state_setup30;
          penable30     <= 1'b0;
          psel_vector30 <= slave_select30;
          paddr30       <= haddr_reg30;
          pwrite30      <= hwrite_reg30;
        end  
        
        // TRANSFER30 -> IDLE30
        else begin
          apb_state30   <= apb_state_idle30;      
          penable30     <= 1'b0;
          psel_vector30 <= 'b0;
        end  
      end
    end
    
  end
end

always @(posedge hclk30 or negedge hreset_n30) begin
  if (hreset_n30 == 1'b0)
    slave_select30 <= 'b0;
  else begin  
  `ifdef APB_SLAVE030
     slave_select30[0]   <= valid_ahb_trans30 && (haddr30 >= APB_SLAVE0_START_ADDR30)  && (haddr30 <= APB_SLAVE0_END_ADDR30);
   `else
     slave_select30[0]   <= 1'b0;
   `endif
   
   `ifdef APB_SLAVE130
     slave_select30[1]   <= valid_ahb_trans30 && (haddr30 >= APB_SLAVE1_START_ADDR30)  && (haddr30 <= APB_SLAVE1_END_ADDR30);
   `else
     slave_select30[1]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE230  
     slave_select30[2]   <= valid_ahb_trans30 && (haddr30 >= APB_SLAVE2_START_ADDR30)  && (haddr30 <= APB_SLAVE2_END_ADDR30);
   `else
     slave_select30[2]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE330  
     slave_select30[3]   <= valid_ahb_trans30 && (haddr30 >= APB_SLAVE3_START_ADDR30)  && (haddr30 <= APB_SLAVE3_END_ADDR30);
   `else
     slave_select30[3]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE430  
     slave_select30[4]   <= valid_ahb_trans30 && (haddr30 >= APB_SLAVE4_START_ADDR30)  && (haddr30 <= APB_SLAVE4_END_ADDR30);
   `else
     slave_select30[4]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE530  
     slave_select30[5]   <= valid_ahb_trans30 && (haddr30 >= APB_SLAVE5_START_ADDR30)  && (haddr30 <= APB_SLAVE5_END_ADDR30);
   `else
     slave_select30[5]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE630  
     slave_select30[6]   <= valid_ahb_trans30 && (haddr30 >= APB_SLAVE6_START_ADDR30)  && (haddr30 <= APB_SLAVE6_END_ADDR30);
   `else
     slave_select30[6]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE730  
     slave_select30[7]   <= valid_ahb_trans30 && (haddr30 >= APB_SLAVE7_START_ADDR30)  && (haddr30 <= APB_SLAVE7_END_ADDR30);
   `else
     slave_select30[7]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE830  
     slave_select30[8]   <= valid_ahb_trans30 && (haddr30 >= APB_SLAVE8_START_ADDR30)  && (haddr30 <= APB_SLAVE8_END_ADDR30);
   `else
     slave_select30[8]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE930  
     slave_select30[9]   <= valid_ahb_trans30 && (haddr30 >= APB_SLAVE9_START_ADDR30)  && (haddr30 <= APB_SLAVE9_END_ADDR30);
   `else
     slave_select30[9]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1030  
     slave_select30[10]  <= valid_ahb_trans30 && (haddr30 >= APB_SLAVE10_START_ADDR30) && (haddr30 <= APB_SLAVE10_END_ADDR30);
   `else
     slave_select30[10]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1130  
     slave_select30[11]  <= valid_ahb_trans30 && (haddr30 >= APB_SLAVE11_START_ADDR30) && (haddr30 <= APB_SLAVE11_END_ADDR30);
   `else
     slave_select30[11]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1230  
     slave_select30[12]  <= valid_ahb_trans30 && (haddr30 >= APB_SLAVE12_START_ADDR30) && (haddr30 <= APB_SLAVE12_END_ADDR30);
   `else
     slave_select30[12]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1330  
     slave_select30[13]  <= valid_ahb_trans30 && (haddr30 >= APB_SLAVE13_START_ADDR30) && (haddr30 <= APB_SLAVE13_END_ADDR30);
   `else
     slave_select30[13]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1430  
     slave_select30[14]  <= valid_ahb_trans30 && (haddr30 >= APB_SLAVE14_START_ADDR30) && (haddr30 <= APB_SLAVE14_END_ADDR30);
   `else
     slave_select30[14]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1530  
     slave_select30[15]  <= valid_ahb_trans30 && (haddr30 >= APB_SLAVE15_START_ADDR30) && (haddr30 <= APB_SLAVE15_END_ADDR30);
   `else
     slave_select30[15]   <= 1'b0;
   `endif  
  end
end

assign pready_muxed30 = |(psel_vector30 & pready_vector30);
assign prdata_muxed30 = prdata0_q30  | prdata1_q30  | prdata2_q30  | prdata3_q30  |
                      prdata4_q30  | prdata5_q30  | prdata6_q30  | prdata7_q30  |
                      prdata8_q30  | prdata9_q30  | prdata10_q30 | prdata11_q30 |
                      prdata12_q30 | prdata13_q30 | prdata14_q30 | prdata15_q30 ;

`ifdef APB_SLAVE030
  assign psel030            = psel_vector30[0];
  assign pready_vector30[0] = pready030;
  assign prdata0_q30        = (psel030 == 1'b1) ? prdata030 : 'b0;
`else
  assign pready_vector30[0] = 1'b0;
  assign prdata0_q30        = 'b0;
`endif

`ifdef APB_SLAVE130
  assign psel130            = psel_vector30[1];
  assign pready_vector30[1] = pready130;
  assign prdata1_q30        = (psel130 == 1'b1) ? prdata130 : 'b0;
`else
  assign pready_vector30[1] = 1'b0;
  assign prdata1_q30        = 'b0;
`endif

`ifdef APB_SLAVE230
  assign psel230            = psel_vector30[2];
  assign pready_vector30[2] = pready230;
  assign prdata2_q30        = (psel230 == 1'b1) ? prdata230 : 'b0;
`else
  assign pready_vector30[2] = 1'b0;
  assign prdata2_q30        = 'b0;
`endif

`ifdef APB_SLAVE330
  assign psel330            = psel_vector30[3];
  assign pready_vector30[3] = pready330;
  assign prdata3_q30        = (psel330 == 1'b1) ? prdata330 : 'b0;
`else
  assign pready_vector30[3] = 1'b0;
  assign prdata3_q30        = 'b0;
`endif

`ifdef APB_SLAVE430
  assign psel430            = psel_vector30[4];
  assign pready_vector30[4] = pready430;
  assign prdata4_q30        = (psel430 == 1'b1) ? prdata430 : 'b0;
`else
  assign pready_vector30[4] = 1'b0;
  assign prdata4_q30        = 'b0;
`endif

`ifdef APB_SLAVE530
  assign psel530            = psel_vector30[5];
  assign pready_vector30[5] = pready530;
  assign prdata5_q30        = (psel530 == 1'b1) ? prdata530 : 'b0;
`else
  assign pready_vector30[5] = 1'b0;
  assign prdata5_q30        = 'b0;
`endif

`ifdef APB_SLAVE630
  assign psel630            = psel_vector30[6];
  assign pready_vector30[6] = pready630;
  assign prdata6_q30        = (psel630 == 1'b1) ? prdata630 : 'b0;
`else
  assign pready_vector30[6] = 1'b0;
  assign prdata6_q30        = 'b0;
`endif

`ifdef APB_SLAVE730
  assign psel730            = psel_vector30[7];
  assign pready_vector30[7] = pready730;
  assign prdata7_q30        = (psel730 == 1'b1) ? prdata730 : 'b0;
`else
  assign pready_vector30[7] = 1'b0;
  assign prdata7_q30        = 'b0;
`endif

`ifdef APB_SLAVE830
  assign psel830            = psel_vector30[8];
  assign pready_vector30[8] = pready830;
  assign prdata8_q30        = (psel830 == 1'b1) ? prdata830 : 'b0;
`else
  assign pready_vector30[8] = 1'b0;
  assign prdata8_q30        = 'b0;
`endif

`ifdef APB_SLAVE930
  assign psel930            = psel_vector30[9];
  assign pready_vector30[9] = pready930;
  assign prdata9_q30        = (psel930 == 1'b1) ? prdata930 : 'b0;
`else
  assign pready_vector30[9] = 1'b0;
  assign prdata9_q30        = 'b0;
`endif

`ifdef APB_SLAVE1030
  assign psel1030            = psel_vector30[10];
  assign pready_vector30[10] = pready1030;
  assign prdata10_q30        = (psel1030 == 1'b1) ? prdata1030 : 'b0;
`else
  assign pready_vector30[10] = 1'b0;
  assign prdata10_q30        = 'b0;
`endif

`ifdef APB_SLAVE1130
  assign psel1130            = psel_vector30[11];
  assign pready_vector30[11] = pready1130;
  assign prdata11_q30        = (psel1130 == 1'b1) ? prdata1130 : 'b0;
`else
  assign pready_vector30[11] = 1'b0;
  assign prdata11_q30        = 'b0;
`endif

`ifdef APB_SLAVE1230
  assign psel1230            = psel_vector30[12];
  assign pready_vector30[12] = pready1230;
  assign prdata12_q30        = (psel1230 == 1'b1) ? prdata1230 : 'b0;
`else
  assign pready_vector30[12] = 1'b0;
  assign prdata12_q30        = 'b0;
`endif

`ifdef APB_SLAVE1330
  assign psel1330            = psel_vector30[13];
  assign pready_vector30[13] = pready1330;
  assign prdata13_q30        = (psel1330 == 1'b1) ? prdata1330 : 'b0;
`else
  assign pready_vector30[13] = 1'b0;
  assign prdata13_q30        = 'b0;
`endif

`ifdef APB_SLAVE1430
  assign psel1430            = psel_vector30[14];
  assign pready_vector30[14] = pready1430;
  assign prdata14_q30        = (psel1430 == 1'b1) ? prdata1430 : 'b0;
`else
  assign pready_vector30[14] = 1'b0;
  assign prdata14_q30        = 'b0;
`endif

`ifdef APB_SLAVE1530
  assign psel1530            = psel_vector30[15];
  assign pready_vector30[15] = pready1530;
  assign prdata15_q30        = (psel1530 == 1'b1) ? prdata1530 : 'b0;
`else
  assign pready_vector30[15] = 1'b0;
  assign prdata15_q30        = 'b0;
`endif

endmodule
