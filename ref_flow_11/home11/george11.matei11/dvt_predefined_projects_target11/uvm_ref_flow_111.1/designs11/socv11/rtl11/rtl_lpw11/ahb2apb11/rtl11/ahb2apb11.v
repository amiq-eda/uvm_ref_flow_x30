//File11 name   : ahb2apb11.v
//Title11       : 
//Created11     : 2010
//Description11 : Simple11 AHB11 to APB11 bridge11
//Notes11       : 
//----------------------------------------------------------------------
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------

`timescale 1ns/1ps

`include "ahb2apb_defines11.v"

module ahb2apb11
(
  // AHB11 signals11
  hclk11,
  hreset_n11,
  hsel11,
  haddr11,
  htrans11,
  hwdata11,
  hwrite11,
  hrdata11,
  hready11,
  hresp11,
  
  // APB11 signals11 common to all APB11 slaves11
  pclk11,
  preset_n11,
  paddr11,
  penable11,
  pwrite11,
  pwdata11
  
  // Slave11 0 signals11
  `ifdef APB_SLAVE011
  ,psel011
  ,pready011
  ,prdata011
  `endif
  
  // Slave11 1 signals11
  `ifdef APB_SLAVE111
  ,psel111
  ,pready111
  ,prdata111
  `endif
  
  // Slave11 2 signals11
  `ifdef APB_SLAVE211
  ,psel211
  ,pready211
  ,prdata211
  `endif
  
  // Slave11 3 signals11
  `ifdef APB_SLAVE311
  ,psel311
  ,pready311
  ,prdata311
  `endif
  
  // Slave11 4 signals11
  `ifdef APB_SLAVE411
  ,psel411
  ,pready411
  ,prdata411
  `endif
  
  // Slave11 5 signals11
  `ifdef APB_SLAVE511
  ,psel511
  ,pready511
  ,prdata511
  `endif
  
  // Slave11 6 signals11
  `ifdef APB_SLAVE611
  ,psel611
  ,pready611
  ,prdata611
  `endif
  
  // Slave11 7 signals11
  `ifdef APB_SLAVE711
  ,psel711
  ,pready711
  ,prdata711
  `endif
  
  // Slave11 8 signals11
  `ifdef APB_SLAVE811
  ,psel811
  ,pready811
  ,prdata811
  `endif
  
  // Slave11 9 signals11
  `ifdef APB_SLAVE911
  ,psel911
  ,pready911
  ,prdata911
  `endif
  
  // Slave11 10 signals11
  `ifdef APB_SLAVE1011
  ,psel1011
  ,pready1011
  ,prdata1011
  `endif
  
  // Slave11 11 signals11
  `ifdef APB_SLAVE1111
  ,psel1111
  ,pready1111
  ,prdata1111
  `endif
  
  // Slave11 12 signals11
  `ifdef APB_SLAVE1211
  ,psel1211
  ,pready1211
  ,prdata1211
  `endif
  
  // Slave11 13 signals11
  `ifdef APB_SLAVE1311
  ,psel1311
  ,pready1311
  ,prdata1311
  `endif
  
  // Slave11 14 signals11
  `ifdef APB_SLAVE1411
  ,psel1411
  ,pready1411
  ,prdata1411
  `endif
  
  // Slave11 15 signals11
  `ifdef APB_SLAVE1511
  ,psel1511
  ,pready1511
  ,prdata1511
  `endif
  
);

parameter 
  APB_SLAVE0_START_ADDR11  = 32'h00000000,
  APB_SLAVE0_END_ADDR11    = 32'h00000000,
  APB_SLAVE1_START_ADDR11  = 32'h00000000,
  APB_SLAVE1_END_ADDR11    = 32'h00000000,
  APB_SLAVE2_START_ADDR11  = 32'h00000000,
  APB_SLAVE2_END_ADDR11    = 32'h00000000,
  APB_SLAVE3_START_ADDR11  = 32'h00000000,
  APB_SLAVE3_END_ADDR11    = 32'h00000000,
  APB_SLAVE4_START_ADDR11  = 32'h00000000,
  APB_SLAVE4_END_ADDR11    = 32'h00000000,
  APB_SLAVE5_START_ADDR11  = 32'h00000000,
  APB_SLAVE5_END_ADDR11    = 32'h00000000,
  APB_SLAVE6_START_ADDR11  = 32'h00000000,
  APB_SLAVE6_END_ADDR11    = 32'h00000000,
  APB_SLAVE7_START_ADDR11  = 32'h00000000,
  APB_SLAVE7_END_ADDR11    = 32'h00000000,
  APB_SLAVE8_START_ADDR11  = 32'h00000000,
  APB_SLAVE8_END_ADDR11    = 32'h00000000,
  APB_SLAVE9_START_ADDR11  = 32'h00000000,
  APB_SLAVE9_END_ADDR11    = 32'h00000000,
  APB_SLAVE10_START_ADDR11  = 32'h00000000,
  APB_SLAVE10_END_ADDR11    = 32'h00000000,
  APB_SLAVE11_START_ADDR11  = 32'h00000000,
  APB_SLAVE11_END_ADDR11    = 32'h00000000,
  APB_SLAVE12_START_ADDR11  = 32'h00000000,
  APB_SLAVE12_END_ADDR11    = 32'h00000000,
  APB_SLAVE13_START_ADDR11  = 32'h00000000,
  APB_SLAVE13_END_ADDR11    = 32'h00000000,
  APB_SLAVE14_START_ADDR11  = 32'h00000000,
  APB_SLAVE14_END_ADDR11    = 32'h00000000,
  APB_SLAVE15_START_ADDR11  = 32'h00000000,
  APB_SLAVE15_END_ADDR11    = 32'h00000000;

  // AHB11 signals11
input        hclk11;
input        hreset_n11;
input        hsel11;
input[31:0]  haddr11;
input[1:0]   htrans11;
input[31:0]  hwdata11;
input        hwrite11;
output[31:0] hrdata11;
reg   [31:0] hrdata11;
output       hready11;
output[1:0]  hresp11;
  
  // APB11 signals11 common to all APB11 slaves11
input       pclk11;
input       preset_n11;
output[31:0] paddr11;
reg   [31:0] paddr11;
output       penable11;
reg          penable11;
output       pwrite11;
reg          pwrite11;
output[31:0] pwdata11;
  
  // Slave11 0 signals11
`ifdef APB_SLAVE011
  output      psel011;
  input       pready011;
  input[31:0] prdata011;
`endif
  
  // Slave11 1 signals11
`ifdef APB_SLAVE111
  output      psel111;
  input       pready111;
  input[31:0] prdata111;
`endif
  
  // Slave11 2 signals11
`ifdef APB_SLAVE211
  output      psel211;
  input       pready211;
  input[31:0] prdata211;
`endif
  
  // Slave11 3 signals11
`ifdef APB_SLAVE311
  output      psel311;
  input       pready311;
  input[31:0] prdata311;
`endif
  
  // Slave11 4 signals11
`ifdef APB_SLAVE411
  output      psel411;
  input       pready411;
  input[31:0] prdata411;
`endif
  
  // Slave11 5 signals11
`ifdef APB_SLAVE511
  output      psel511;
  input       pready511;
  input[31:0] prdata511;
`endif
  
  // Slave11 6 signals11
`ifdef APB_SLAVE611
  output      psel611;
  input       pready611;
  input[31:0] prdata611;
`endif
  
  // Slave11 7 signals11
`ifdef APB_SLAVE711
  output      psel711;
  input       pready711;
  input[31:0] prdata711;
`endif
  
  // Slave11 8 signals11
`ifdef APB_SLAVE811
  output      psel811;
  input       pready811;
  input[31:0] prdata811;
`endif
  
  // Slave11 9 signals11
`ifdef APB_SLAVE911
  output      psel911;
  input       pready911;
  input[31:0] prdata911;
`endif
  
  // Slave11 10 signals11
`ifdef APB_SLAVE1011
  output      psel1011;
  input       pready1011;
  input[31:0] prdata1011;
`endif
  
  // Slave11 11 signals11
`ifdef APB_SLAVE1111
  output      psel1111;
  input       pready1111;
  input[31:0] prdata1111;
`endif
  
  // Slave11 12 signals11
`ifdef APB_SLAVE1211
  output      psel1211;
  input       pready1211;
  input[31:0] prdata1211;
`endif
  
  // Slave11 13 signals11
`ifdef APB_SLAVE1311
  output      psel1311;
  input       pready1311;
  input[31:0] prdata1311;
`endif
  
  // Slave11 14 signals11
`ifdef APB_SLAVE1411
  output      psel1411;
  input       pready1411;
  input[31:0] prdata1411;
`endif
  
  // Slave11 15 signals11
`ifdef APB_SLAVE1511
  output      psel1511;
  input       pready1511;
  input[31:0] prdata1511;
`endif
 
reg         ahb_addr_phase11;
reg         ahb_data_phase11;
wire        valid_ahb_trans11;
wire        pready_muxed11;
wire [31:0] prdata_muxed11;
reg  [31:0] haddr_reg11;
reg         hwrite_reg11;
reg  [2:0]  apb_state11;
wire [2:0]  apb_state_idle11;
wire [2:0]  apb_state_setup11;
wire [2:0]  apb_state_access11;
reg  [15:0] slave_select11;
wire [15:0] pready_vector11;
reg  [15:0] psel_vector11;
wire [31:0] prdata0_q11;
wire [31:0] prdata1_q11;
wire [31:0] prdata2_q11;
wire [31:0] prdata3_q11;
wire [31:0] prdata4_q11;
wire [31:0] prdata5_q11;
wire [31:0] prdata6_q11;
wire [31:0] prdata7_q11;
wire [31:0] prdata8_q11;
wire [31:0] prdata9_q11;
wire [31:0] prdata10_q11;
wire [31:0] prdata11_q11;
wire [31:0] prdata12_q11;
wire [31:0] prdata13_q11;
wire [31:0] prdata14_q11;
wire [31:0] prdata15_q11;

// assign pclk11     = hclk11;
// assign preset_n11 = hreset_n11;
assign hready11   = ahb_addr_phase11;
assign pwdata11   = hwdata11;
assign hresp11  = 2'b00;

// Respond11 to NONSEQ11 or SEQ transfers11
assign valid_ahb_trans11 = ((htrans11 == 2'b10) || (htrans11 == 2'b11)) && (hsel11 == 1'b1);

always @(posedge hclk11) begin
  if (hreset_n11 == 1'b0) begin
    ahb_addr_phase11 <= 1'b1;
    ahb_data_phase11 <= 1'b0;
    haddr_reg11      <= 'b0;
    hwrite_reg11     <= 1'b0;
    hrdata11         <= 'b0;
  end
  else begin
    if (ahb_addr_phase11 == 1'b1 && valid_ahb_trans11 == 1'b1) begin
      ahb_addr_phase11 <= 1'b0;
      ahb_data_phase11 <= 1'b1;
      haddr_reg11      <= haddr11;
      hwrite_reg11     <= hwrite11;
    end
    if (ahb_data_phase11 == 1'b1 && pready_muxed11 == 1'b1 && apb_state11 == apb_state_access11) begin
      ahb_addr_phase11 <= 1'b1;
      ahb_data_phase11 <= 1'b0;
      hrdata11         <= prdata_muxed11;
    end
  end
end

// APB11 state machine11 state definitions11
assign apb_state_idle11   = 3'b001;
assign apb_state_setup11  = 3'b010;
assign apb_state_access11 = 3'b100;

// APB11 state machine11
always @(posedge hclk11 or negedge hreset_n11) begin
  if (hreset_n11 == 1'b0) begin
    apb_state11   <= apb_state_idle11;
    psel_vector11 <= 1'b0;
    penable11     <= 1'b0;
    paddr11       <= 1'b0;
    pwrite11      <= 1'b0;
  end  
  else begin
    
    // IDLE11 -> SETUP11
    if (apb_state11 == apb_state_idle11) begin
      if (ahb_data_phase11 == 1'b1) begin
        apb_state11   <= apb_state_setup11;
        psel_vector11 <= slave_select11;
        paddr11       <= haddr_reg11;
        pwrite11      <= hwrite_reg11;
      end  
    end
    
    // SETUP11 -> TRANSFER11
    if (apb_state11 == apb_state_setup11) begin
      apb_state11 <= apb_state_access11;
      penable11   <= 1'b1;
    end
    
    // TRANSFER11 -> SETUP11 or
    // TRANSFER11 -> IDLE11
    if (apb_state11 == apb_state_access11) begin
      if (pready_muxed11 == 1'b1) begin
      
        // TRANSFER11 -> SETUP11
        if (valid_ahb_trans11 == 1'b1) begin
          apb_state11   <= apb_state_setup11;
          penable11     <= 1'b0;
          psel_vector11 <= slave_select11;
          paddr11       <= haddr_reg11;
          pwrite11      <= hwrite_reg11;
        end  
        
        // TRANSFER11 -> IDLE11
        else begin
          apb_state11   <= apb_state_idle11;      
          penable11     <= 1'b0;
          psel_vector11 <= 'b0;
        end  
      end
    end
    
  end
end

always @(posedge hclk11 or negedge hreset_n11) begin
  if (hreset_n11 == 1'b0)
    slave_select11 <= 'b0;
  else begin  
  `ifdef APB_SLAVE011
     slave_select11[0]   <= valid_ahb_trans11 && (haddr11 >= APB_SLAVE0_START_ADDR11)  && (haddr11 <= APB_SLAVE0_END_ADDR11);
   `else
     slave_select11[0]   <= 1'b0;
   `endif
   
   `ifdef APB_SLAVE111
     slave_select11[1]   <= valid_ahb_trans11 && (haddr11 >= APB_SLAVE1_START_ADDR11)  && (haddr11 <= APB_SLAVE1_END_ADDR11);
   `else
     slave_select11[1]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE211  
     slave_select11[2]   <= valid_ahb_trans11 && (haddr11 >= APB_SLAVE2_START_ADDR11)  && (haddr11 <= APB_SLAVE2_END_ADDR11);
   `else
     slave_select11[2]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE311  
     slave_select11[3]   <= valid_ahb_trans11 && (haddr11 >= APB_SLAVE3_START_ADDR11)  && (haddr11 <= APB_SLAVE3_END_ADDR11);
   `else
     slave_select11[3]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE411  
     slave_select11[4]   <= valid_ahb_trans11 && (haddr11 >= APB_SLAVE4_START_ADDR11)  && (haddr11 <= APB_SLAVE4_END_ADDR11);
   `else
     slave_select11[4]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE511  
     slave_select11[5]   <= valid_ahb_trans11 && (haddr11 >= APB_SLAVE5_START_ADDR11)  && (haddr11 <= APB_SLAVE5_END_ADDR11);
   `else
     slave_select11[5]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE611  
     slave_select11[6]   <= valid_ahb_trans11 && (haddr11 >= APB_SLAVE6_START_ADDR11)  && (haddr11 <= APB_SLAVE6_END_ADDR11);
   `else
     slave_select11[6]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE711  
     slave_select11[7]   <= valid_ahb_trans11 && (haddr11 >= APB_SLAVE7_START_ADDR11)  && (haddr11 <= APB_SLAVE7_END_ADDR11);
   `else
     slave_select11[7]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE811  
     slave_select11[8]   <= valid_ahb_trans11 && (haddr11 >= APB_SLAVE8_START_ADDR11)  && (haddr11 <= APB_SLAVE8_END_ADDR11);
   `else
     slave_select11[8]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE911  
     slave_select11[9]   <= valid_ahb_trans11 && (haddr11 >= APB_SLAVE9_START_ADDR11)  && (haddr11 <= APB_SLAVE9_END_ADDR11);
   `else
     slave_select11[9]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1011  
     slave_select11[10]  <= valid_ahb_trans11 && (haddr11 >= APB_SLAVE10_START_ADDR11) && (haddr11 <= APB_SLAVE10_END_ADDR11);
   `else
     slave_select11[10]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1111  
     slave_select11[11]  <= valid_ahb_trans11 && (haddr11 >= APB_SLAVE11_START_ADDR11) && (haddr11 <= APB_SLAVE11_END_ADDR11);
   `else
     slave_select11[11]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1211  
     slave_select11[12]  <= valid_ahb_trans11 && (haddr11 >= APB_SLAVE12_START_ADDR11) && (haddr11 <= APB_SLAVE12_END_ADDR11);
   `else
     slave_select11[12]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1311  
     slave_select11[13]  <= valid_ahb_trans11 && (haddr11 >= APB_SLAVE13_START_ADDR11) && (haddr11 <= APB_SLAVE13_END_ADDR11);
   `else
     slave_select11[13]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1411  
     slave_select11[14]  <= valid_ahb_trans11 && (haddr11 >= APB_SLAVE14_START_ADDR11) && (haddr11 <= APB_SLAVE14_END_ADDR11);
   `else
     slave_select11[14]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1511  
     slave_select11[15]  <= valid_ahb_trans11 && (haddr11 >= APB_SLAVE15_START_ADDR11) && (haddr11 <= APB_SLAVE15_END_ADDR11);
   `else
     slave_select11[15]   <= 1'b0;
   `endif  
  end
end

assign pready_muxed11 = |(psel_vector11 & pready_vector11);
assign prdata_muxed11 = prdata0_q11  | prdata1_q11  | prdata2_q11  | prdata3_q11  |
                      prdata4_q11  | prdata5_q11  | prdata6_q11  | prdata7_q11  |
                      prdata8_q11  | prdata9_q11  | prdata10_q11 | prdata11_q11 |
                      prdata12_q11 | prdata13_q11 | prdata14_q11 | prdata15_q11 ;

`ifdef APB_SLAVE011
  assign psel011            = psel_vector11[0];
  assign pready_vector11[0] = pready011;
  assign prdata0_q11        = (psel011 == 1'b1) ? prdata011 : 'b0;
`else
  assign pready_vector11[0] = 1'b0;
  assign prdata0_q11        = 'b0;
`endif

`ifdef APB_SLAVE111
  assign psel111            = psel_vector11[1];
  assign pready_vector11[1] = pready111;
  assign prdata1_q11        = (psel111 == 1'b1) ? prdata111 : 'b0;
`else
  assign pready_vector11[1] = 1'b0;
  assign prdata1_q11        = 'b0;
`endif

`ifdef APB_SLAVE211
  assign psel211            = psel_vector11[2];
  assign pready_vector11[2] = pready211;
  assign prdata2_q11        = (psel211 == 1'b1) ? prdata211 : 'b0;
`else
  assign pready_vector11[2] = 1'b0;
  assign prdata2_q11        = 'b0;
`endif

`ifdef APB_SLAVE311
  assign psel311            = psel_vector11[3];
  assign pready_vector11[3] = pready311;
  assign prdata3_q11        = (psel311 == 1'b1) ? prdata311 : 'b0;
`else
  assign pready_vector11[3] = 1'b0;
  assign prdata3_q11        = 'b0;
`endif

`ifdef APB_SLAVE411
  assign psel411            = psel_vector11[4];
  assign pready_vector11[4] = pready411;
  assign prdata4_q11        = (psel411 == 1'b1) ? prdata411 : 'b0;
`else
  assign pready_vector11[4] = 1'b0;
  assign prdata4_q11        = 'b0;
`endif

`ifdef APB_SLAVE511
  assign psel511            = psel_vector11[5];
  assign pready_vector11[5] = pready511;
  assign prdata5_q11        = (psel511 == 1'b1) ? prdata511 : 'b0;
`else
  assign pready_vector11[5] = 1'b0;
  assign prdata5_q11        = 'b0;
`endif

`ifdef APB_SLAVE611
  assign psel611            = psel_vector11[6];
  assign pready_vector11[6] = pready611;
  assign prdata6_q11        = (psel611 == 1'b1) ? prdata611 : 'b0;
`else
  assign pready_vector11[6] = 1'b0;
  assign prdata6_q11        = 'b0;
`endif

`ifdef APB_SLAVE711
  assign psel711            = psel_vector11[7];
  assign pready_vector11[7] = pready711;
  assign prdata7_q11        = (psel711 == 1'b1) ? prdata711 : 'b0;
`else
  assign pready_vector11[7] = 1'b0;
  assign prdata7_q11        = 'b0;
`endif

`ifdef APB_SLAVE811
  assign psel811            = psel_vector11[8];
  assign pready_vector11[8] = pready811;
  assign prdata8_q11        = (psel811 == 1'b1) ? prdata811 : 'b0;
`else
  assign pready_vector11[8] = 1'b0;
  assign prdata8_q11        = 'b0;
`endif

`ifdef APB_SLAVE911
  assign psel911            = psel_vector11[9];
  assign pready_vector11[9] = pready911;
  assign prdata9_q11        = (psel911 == 1'b1) ? prdata911 : 'b0;
`else
  assign pready_vector11[9] = 1'b0;
  assign prdata9_q11        = 'b0;
`endif

`ifdef APB_SLAVE1011
  assign psel1011            = psel_vector11[10];
  assign pready_vector11[10] = pready1011;
  assign prdata10_q11        = (psel1011 == 1'b1) ? prdata1011 : 'b0;
`else
  assign pready_vector11[10] = 1'b0;
  assign prdata10_q11        = 'b0;
`endif

`ifdef APB_SLAVE1111
  assign psel1111            = psel_vector11[11];
  assign pready_vector11[11] = pready1111;
  assign prdata11_q11        = (psel1111 == 1'b1) ? prdata1111 : 'b0;
`else
  assign pready_vector11[11] = 1'b0;
  assign prdata11_q11        = 'b0;
`endif

`ifdef APB_SLAVE1211
  assign psel1211            = psel_vector11[12];
  assign pready_vector11[12] = pready1211;
  assign prdata12_q11        = (psel1211 == 1'b1) ? prdata1211 : 'b0;
`else
  assign pready_vector11[12] = 1'b0;
  assign prdata12_q11        = 'b0;
`endif

`ifdef APB_SLAVE1311
  assign psel1311            = psel_vector11[13];
  assign pready_vector11[13] = pready1311;
  assign prdata13_q11        = (psel1311 == 1'b1) ? prdata1311 : 'b0;
`else
  assign pready_vector11[13] = 1'b0;
  assign prdata13_q11        = 'b0;
`endif

`ifdef APB_SLAVE1411
  assign psel1411            = psel_vector11[14];
  assign pready_vector11[14] = pready1411;
  assign prdata14_q11        = (psel1411 == 1'b1) ? prdata1411 : 'b0;
`else
  assign pready_vector11[14] = 1'b0;
  assign prdata14_q11        = 'b0;
`endif

`ifdef APB_SLAVE1511
  assign psel1511            = psel_vector11[15];
  assign pready_vector11[15] = pready1511;
  assign prdata15_q11        = (psel1511 == 1'b1) ? prdata1511 : 'b0;
`else
  assign pready_vector11[15] = 1'b0;
  assign prdata15_q11        = 'b0;
`endif

endmodule
