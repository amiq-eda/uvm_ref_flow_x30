//File22 name   : ahb2apb22.v
//Title22       : 
//Created22     : 2010
//Description22 : Simple22 AHB22 to APB22 bridge22
//Notes22       : 
//----------------------------------------------------------------------
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------

`timescale 1ns/1ps

`include "ahb2apb_defines22.v"

module ahb2apb22
(
  // AHB22 signals22
  hclk22,
  hreset_n22,
  hsel22,
  haddr22,
  htrans22,
  hwdata22,
  hwrite22,
  hrdata22,
  hready22,
  hresp22,
  
  // APB22 signals22 common to all APB22 slaves22
  pclk22,
  preset_n22,
  paddr22,
  penable22,
  pwrite22,
  pwdata22
  
  // Slave22 0 signals22
  `ifdef APB_SLAVE022
  ,psel022
  ,pready022
  ,prdata022
  `endif
  
  // Slave22 1 signals22
  `ifdef APB_SLAVE122
  ,psel122
  ,pready122
  ,prdata122
  `endif
  
  // Slave22 2 signals22
  `ifdef APB_SLAVE222
  ,psel222
  ,pready222
  ,prdata222
  `endif
  
  // Slave22 3 signals22
  `ifdef APB_SLAVE322
  ,psel322
  ,pready322
  ,prdata322
  `endif
  
  // Slave22 4 signals22
  `ifdef APB_SLAVE422
  ,psel422
  ,pready422
  ,prdata422
  `endif
  
  // Slave22 5 signals22
  `ifdef APB_SLAVE522
  ,psel522
  ,pready522
  ,prdata522
  `endif
  
  // Slave22 6 signals22
  `ifdef APB_SLAVE622
  ,psel622
  ,pready622
  ,prdata622
  `endif
  
  // Slave22 7 signals22
  `ifdef APB_SLAVE722
  ,psel722
  ,pready722
  ,prdata722
  `endif
  
  // Slave22 8 signals22
  `ifdef APB_SLAVE822
  ,psel822
  ,pready822
  ,prdata822
  `endif
  
  // Slave22 9 signals22
  `ifdef APB_SLAVE922
  ,psel922
  ,pready922
  ,prdata922
  `endif
  
  // Slave22 10 signals22
  `ifdef APB_SLAVE1022
  ,psel1022
  ,pready1022
  ,prdata1022
  `endif
  
  // Slave22 11 signals22
  `ifdef APB_SLAVE1122
  ,psel1122
  ,pready1122
  ,prdata1122
  `endif
  
  // Slave22 12 signals22
  `ifdef APB_SLAVE1222
  ,psel1222
  ,pready1222
  ,prdata1222
  `endif
  
  // Slave22 13 signals22
  `ifdef APB_SLAVE1322
  ,psel1322
  ,pready1322
  ,prdata1322
  `endif
  
  // Slave22 14 signals22
  `ifdef APB_SLAVE1422
  ,psel1422
  ,pready1422
  ,prdata1422
  `endif
  
  // Slave22 15 signals22
  `ifdef APB_SLAVE1522
  ,psel1522
  ,pready1522
  ,prdata1522
  `endif
  
);

parameter 
  APB_SLAVE0_START_ADDR22  = 32'h00000000,
  APB_SLAVE0_END_ADDR22    = 32'h00000000,
  APB_SLAVE1_START_ADDR22  = 32'h00000000,
  APB_SLAVE1_END_ADDR22    = 32'h00000000,
  APB_SLAVE2_START_ADDR22  = 32'h00000000,
  APB_SLAVE2_END_ADDR22    = 32'h00000000,
  APB_SLAVE3_START_ADDR22  = 32'h00000000,
  APB_SLAVE3_END_ADDR22    = 32'h00000000,
  APB_SLAVE4_START_ADDR22  = 32'h00000000,
  APB_SLAVE4_END_ADDR22    = 32'h00000000,
  APB_SLAVE5_START_ADDR22  = 32'h00000000,
  APB_SLAVE5_END_ADDR22    = 32'h00000000,
  APB_SLAVE6_START_ADDR22  = 32'h00000000,
  APB_SLAVE6_END_ADDR22    = 32'h00000000,
  APB_SLAVE7_START_ADDR22  = 32'h00000000,
  APB_SLAVE7_END_ADDR22    = 32'h00000000,
  APB_SLAVE8_START_ADDR22  = 32'h00000000,
  APB_SLAVE8_END_ADDR22    = 32'h00000000,
  APB_SLAVE9_START_ADDR22  = 32'h00000000,
  APB_SLAVE9_END_ADDR22    = 32'h00000000,
  APB_SLAVE10_START_ADDR22  = 32'h00000000,
  APB_SLAVE10_END_ADDR22    = 32'h00000000,
  APB_SLAVE11_START_ADDR22  = 32'h00000000,
  APB_SLAVE11_END_ADDR22    = 32'h00000000,
  APB_SLAVE12_START_ADDR22  = 32'h00000000,
  APB_SLAVE12_END_ADDR22    = 32'h00000000,
  APB_SLAVE13_START_ADDR22  = 32'h00000000,
  APB_SLAVE13_END_ADDR22    = 32'h00000000,
  APB_SLAVE14_START_ADDR22  = 32'h00000000,
  APB_SLAVE14_END_ADDR22    = 32'h00000000,
  APB_SLAVE15_START_ADDR22  = 32'h00000000,
  APB_SLAVE15_END_ADDR22    = 32'h00000000;

  // AHB22 signals22
input        hclk22;
input        hreset_n22;
input        hsel22;
input[31:0]  haddr22;
input[1:0]   htrans22;
input[31:0]  hwdata22;
input        hwrite22;
output[31:0] hrdata22;
reg   [31:0] hrdata22;
output       hready22;
output[1:0]  hresp22;
  
  // APB22 signals22 common to all APB22 slaves22
input       pclk22;
input       preset_n22;
output[31:0] paddr22;
reg   [31:0] paddr22;
output       penable22;
reg          penable22;
output       pwrite22;
reg          pwrite22;
output[31:0] pwdata22;
  
  // Slave22 0 signals22
`ifdef APB_SLAVE022
  output      psel022;
  input       pready022;
  input[31:0] prdata022;
`endif
  
  // Slave22 1 signals22
`ifdef APB_SLAVE122
  output      psel122;
  input       pready122;
  input[31:0] prdata122;
`endif
  
  // Slave22 2 signals22
`ifdef APB_SLAVE222
  output      psel222;
  input       pready222;
  input[31:0] prdata222;
`endif
  
  // Slave22 3 signals22
`ifdef APB_SLAVE322
  output      psel322;
  input       pready322;
  input[31:0] prdata322;
`endif
  
  // Slave22 4 signals22
`ifdef APB_SLAVE422
  output      psel422;
  input       pready422;
  input[31:0] prdata422;
`endif
  
  // Slave22 5 signals22
`ifdef APB_SLAVE522
  output      psel522;
  input       pready522;
  input[31:0] prdata522;
`endif
  
  // Slave22 6 signals22
`ifdef APB_SLAVE622
  output      psel622;
  input       pready622;
  input[31:0] prdata622;
`endif
  
  // Slave22 7 signals22
`ifdef APB_SLAVE722
  output      psel722;
  input       pready722;
  input[31:0] prdata722;
`endif
  
  // Slave22 8 signals22
`ifdef APB_SLAVE822
  output      psel822;
  input       pready822;
  input[31:0] prdata822;
`endif
  
  // Slave22 9 signals22
`ifdef APB_SLAVE922
  output      psel922;
  input       pready922;
  input[31:0] prdata922;
`endif
  
  // Slave22 10 signals22
`ifdef APB_SLAVE1022
  output      psel1022;
  input       pready1022;
  input[31:0] prdata1022;
`endif
  
  // Slave22 11 signals22
`ifdef APB_SLAVE1122
  output      psel1122;
  input       pready1122;
  input[31:0] prdata1122;
`endif
  
  // Slave22 12 signals22
`ifdef APB_SLAVE1222
  output      psel1222;
  input       pready1222;
  input[31:0] prdata1222;
`endif
  
  // Slave22 13 signals22
`ifdef APB_SLAVE1322
  output      psel1322;
  input       pready1322;
  input[31:0] prdata1322;
`endif
  
  // Slave22 14 signals22
`ifdef APB_SLAVE1422
  output      psel1422;
  input       pready1422;
  input[31:0] prdata1422;
`endif
  
  // Slave22 15 signals22
`ifdef APB_SLAVE1522
  output      psel1522;
  input       pready1522;
  input[31:0] prdata1522;
`endif
 
reg         ahb_addr_phase22;
reg         ahb_data_phase22;
wire        valid_ahb_trans22;
wire        pready_muxed22;
wire [31:0] prdata_muxed22;
reg  [31:0] haddr_reg22;
reg         hwrite_reg22;
reg  [2:0]  apb_state22;
wire [2:0]  apb_state_idle22;
wire [2:0]  apb_state_setup22;
wire [2:0]  apb_state_access22;
reg  [15:0] slave_select22;
wire [15:0] pready_vector22;
reg  [15:0] psel_vector22;
wire [31:0] prdata0_q22;
wire [31:0] prdata1_q22;
wire [31:0] prdata2_q22;
wire [31:0] prdata3_q22;
wire [31:0] prdata4_q22;
wire [31:0] prdata5_q22;
wire [31:0] prdata6_q22;
wire [31:0] prdata7_q22;
wire [31:0] prdata8_q22;
wire [31:0] prdata9_q22;
wire [31:0] prdata10_q22;
wire [31:0] prdata11_q22;
wire [31:0] prdata12_q22;
wire [31:0] prdata13_q22;
wire [31:0] prdata14_q22;
wire [31:0] prdata15_q22;

// assign pclk22     = hclk22;
// assign preset_n22 = hreset_n22;
assign hready22   = ahb_addr_phase22;
assign pwdata22   = hwdata22;
assign hresp22  = 2'b00;

// Respond22 to NONSEQ22 or SEQ transfers22
assign valid_ahb_trans22 = ((htrans22 == 2'b10) || (htrans22 == 2'b11)) && (hsel22 == 1'b1);

always @(posedge hclk22) begin
  if (hreset_n22 == 1'b0) begin
    ahb_addr_phase22 <= 1'b1;
    ahb_data_phase22 <= 1'b0;
    haddr_reg22      <= 'b0;
    hwrite_reg22     <= 1'b0;
    hrdata22         <= 'b0;
  end
  else begin
    if (ahb_addr_phase22 == 1'b1 && valid_ahb_trans22 == 1'b1) begin
      ahb_addr_phase22 <= 1'b0;
      ahb_data_phase22 <= 1'b1;
      haddr_reg22      <= haddr22;
      hwrite_reg22     <= hwrite22;
    end
    if (ahb_data_phase22 == 1'b1 && pready_muxed22 == 1'b1 && apb_state22 == apb_state_access22) begin
      ahb_addr_phase22 <= 1'b1;
      ahb_data_phase22 <= 1'b0;
      hrdata22         <= prdata_muxed22;
    end
  end
end

// APB22 state machine22 state definitions22
assign apb_state_idle22   = 3'b001;
assign apb_state_setup22  = 3'b010;
assign apb_state_access22 = 3'b100;

// APB22 state machine22
always @(posedge hclk22 or negedge hreset_n22) begin
  if (hreset_n22 == 1'b0) begin
    apb_state22   <= apb_state_idle22;
    psel_vector22 <= 1'b0;
    penable22     <= 1'b0;
    paddr22       <= 1'b0;
    pwrite22      <= 1'b0;
  end  
  else begin
    
    // IDLE22 -> SETUP22
    if (apb_state22 == apb_state_idle22) begin
      if (ahb_data_phase22 == 1'b1) begin
        apb_state22   <= apb_state_setup22;
        psel_vector22 <= slave_select22;
        paddr22       <= haddr_reg22;
        pwrite22      <= hwrite_reg22;
      end  
    end
    
    // SETUP22 -> TRANSFER22
    if (apb_state22 == apb_state_setup22) begin
      apb_state22 <= apb_state_access22;
      penable22   <= 1'b1;
    end
    
    // TRANSFER22 -> SETUP22 or
    // TRANSFER22 -> IDLE22
    if (apb_state22 == apb_state_access22) begin
      if (pready_muxed22 == 1'b1) begin
      
        // TRANSFER22 -> SETUP22
        if (valid_ahb_trans22 == 1'b1) begin
          apb_state22   <= apb_state_setup22;
          penable22     <= 1'b0;
          psel_vector22 <= slave_select22;
          paddr22       <= haddr_reg22;
          pwrite22      <= hwrite_reg22;
        end  
        
        // TRANSFER22 -> IDLE22
        else begin
          apb_state22   <= apb_state_idle22;      
          penable22     <= 1'b0;
          psel_vector22 <= 'b0;
        end  
      end
    end
    
  end
end

always @(posedge hclk22 or negedge hreset_n22) begin
  if (hreset_n22 == 1'b0)
    slave_select22 <= 'b0;
  else begin  
  `ifdef APB_SLAVE022
     slave_select22[0]   <= valid_ahb_trans22 && (haddr22 >= APB_SLAVE0_START_ADDR22)  && (haddr22 <= APB_SLAVE0_END_ADDR22);
   `else
     slave_select22[0]   <= 1'b0;
   `endif
   
   `ifdef APB_SLAVE122
     slave_select22[1]   <= valid_ahb_trans22 && (haddr22 >= APB_SLAVE1_START_ADDR22)  && (haddr22 <= APB_SLAVE1_END_ADDR22);
   `else
     slave_select22[1]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE222  
     slave_select22[2]   <= valid_ahb_trans22 && (haddr22 >= APB_SLAVE2_START_ADDR22)  && (haddr22 <= APB_SLAVE2_END_ADDR22);
   `else
     slave_select22[2]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE322  
     slave_select22[3]   <= valid_ahb_trans22 && (haddr22 >= APB_SLAVE3_START_ADDR22)  && (haddr22 <= APB_SLAVE3_END_ADDR22);
   `else
     slave_select22[3]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE422  
     slave_select22[4]   <= valid_ahb_trans22 && (haddr22 >= APB_SLAVE4_START_ADDR22)  && (haddr22 <= APB_SLAVE4_END_ADDR22);
   `else
     slave_select22[4]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE522  
     slave_select22[5]   <= valid_ahb_trans22 && (haddr22 >= APB_SLAVE5_START_ADDR22)  && (haddr22 <= APB_SLAVE5_END_ADDR22);
   `else
     slave_select22[5]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE622  
     slave_select22[6]   <= valid_ahb_trans22 && (haddr22 >= APB_SLAVE6_START_ADDR22)  && (haddr22 <= APB_SLAVE6_END_ADDR22);
   `else
     slave_select22[6]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE722  
     slave_select22[7]   <= valid_ahb_trans22 && (haddr22 >= APB_SLAVE7_START_ADDR22)  && (haddr22 <= APB_SLAVE7_END_ADDR22);
   `else
     slave_select22[7]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE822  
     slave_select22[8]   <= valid_ahb_trans22 && (haddr22 >= APB_SLAVE8_START_ADDR22)  && (haddr22 <= APB_SLAVE8_END_ADDR22);
   `else
     slave_select22[8]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE922  
     slave_select22[9]   <= valid_ahb_trans22 && (haddr22 >= APB_SLAVE9_START_ADDR22)  && (haddr22 <= APB_SLAVE9_END_ADDR22);
   `else
     slave_select22[9]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1022  
     slave_select22[10]  <= valid_ahb_trans22 && (haddr22 >= APB_SLAVE10_START_ADDR22) && (haddr22 <= APB_SLAVE10_END_ADDR22);
   `else
     slave_select22[10]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1122  
     slave_select22[11]  <= valid_ahb_trans22 && (haddr22 >= APB_SLAVE11_START_ADDR22) && (haddr22 <= APB_SLAVE11_END_ADDR22);
   `else
     slave_select22[11]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1222  
     slave_select22[12]  <= valid_ahb_trans22 && (haddr22 >= APB_SLAVE12_START_ADDR22) && (haddr22 <= APB_SLAVE12_END_ADDR22);
   `else
     slave_select22[12]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1322  
     slave_select22[13]  <= valid_ahb_trans22 && (haddr22 >= APB_SLAVE13_START_ADDR22) && (haddr22 <= APB_SLAVE13_END_ADDR22);
   `else
     slave_select22[13]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1422  
     slave_select22[14]  <= valid_ahb_trans22 && (haddr22 >= APB_SLAVE14_START_ADDR22) && (haddr22 <= APB_SLAVE14_END_ADDR22);
   `else
     slave_select22[14]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1522  
     slave_select22[15]  <= valid_ahb_trans22 && (haddr22 >= APB_SLAVE15_START_ADDR22) && (haddr22 <= APB_SLAVE15_END_ADDR22);
   `else
     slave_select22[15]   <= 1'b0;
   `endif  
  end
end

assign pready_muxed22 = |(psel_vector22 & pready_vector22);
assign prdata_muxed22 = prdata0_q22  | prdata1_q22  | prdata2_q22  | prdata3_q22  |
                      prdata4_q22  | prdata5_q22  | prdata6_q22  | prdata7_q22  |
                      prdata8_q22  | prdata9_q22  | prdata10_q22 | prdata11_q22 |
                      prdata12_q22 | prdata13_q22 | prdata14_q22 | prdata15_q22 ;

`ifdef APB_SLAVE022
  assign psel022            = psel_vector22[0];
  assign pready_vector22[0] = pready022;
  assign prdata0_q22        = (psel022 == 1'b1) ? prdata022 : 'b0;
`else
  assign pready_vector22[0] = 1'b0;
  assign prdata0_q22        = 'b0;
`endif

`ifdef APB_SLAVE122
  assign psel122            = psel_vector22[1];
  assign pready_vector22[1] = pready122;
  assign prdata1_q22        = (psel122 == 1'b1) ? prdata122 : 'b0;
`else
  assign pready_vector22[1] = 1'b0;
  assign prdata1_q22        = 'b0;
`endif

`ifdef APB_SLAVE222
  assign psel222            = psel_vector22[2];
  assign pready_vector22[2] = pready222;
  assign prdata2_q22        = (psel222 == 1'b1) ? prdata222 : 'b0;
`else
  assign pready_vector22[2] = 1'b0;
  assign prdata2_q22        = 'b0;
`endif

`ifdef APB_SLAVE322
  assign psel322            = psel_vector22[3];
  assign pready_vector22[3] = pready322;
  assign prdata3_q22        = (psel322 == 1'b1) ? prdata322 : 'b0;
`else
  assign pready_vector22[3] = 1'b0;
  assign prdata3_q22        = 'b0;
`endif

`ifdef APB_SLAVE422
  assign psel422            = psel_vector22[4];
  assign pready_vector22[4] = pready422;
  assign prdata4_q22        = (psel422 == 1'b1) ? prdata422 : 'b0;
`else
  assign pready_vector22[4] = 1'b0;
  assign prdata4_q22        = 'b0;
`endif

`ifdef APB_SLAVE522
  assign psel522            = psel_vector22[5];
  assign pready_vector22[5] = pready522;
  assign prdata5_q22        = (psel522 == 1'b1) ? prdata522 : 'b0;
`else
  assign pready_vector22[5] = 1'b0;
  assign prdata5_q22        = 'b0;
`endif

`ifdef APB_SLAVE622
  assign psel622            = psel_vector22[6];
  assign pready_vector22[6] = pready622;
  assign prdata6_q22        = (psel622 == 1'b1) ? prdata622 : 'b0;
`else
  assign pready_vector22[6] = 1'b0;
  assign prdata6_q22        = 'b0;
`endif

`ifdef APB_SLAVE722
  assign psel722            = psel_vector22[7];
  assign pready_vector22[7] = pready722;
  assign prdata7_q22        = (psel722 == 1'b1) ? prdata722 : 'b0;
`else
  assign pready_vector22[7] = 1'b0;
  assign prdata7_q22        = 'b0;
`endif

`ifdef APB_SLAVE822
  assign psel822            = psel_vector22[8];
  assign pready_vector22[8] = pready822;
  assign prdata8_q22        = (psel822 == 1'b1) ? prdata822 : 'b0;
`else
  assign pready_vector22[8] = 1'b0;
  assign prdata8_q22        = 'b0;
`endif

`ifdef APB_SLAVE922
  assign psel922            = psel_vector22[9];
  assign pready_vector22[9] = pready922;
  assign prdata9_q22        = (psel922 == 1'b1) ? prdata922 : 'b0;
`else
  assign pready_vector22[9] = 1'b0;
  assign prdata9_q22        = 'b0;
`endif

`ifdef APB_SLAVE1022
  assign psel1022            = psel_vector22[10];
  assign pready_vector22[10] = pready1022;
  assign prdata10_q22        = (psel1022 == 1'b1) ? prdata1022 : 'b0;
`else
  assign pready_vector22[10] = 1'b0;
  assign prdata10_q22        = 'b0;
`endif

`ifdef APB_SLAVE1122
  assign psel1122            = psel_vector22[11];
  assign pready_vector22[11] = pready1122;
  assign prdata11_q22        = (psel1122 == 1'b1) ? prdata1122 : 'b0;
`else
  assign pready_vector22[11] = 1'b0;
  assign prdata11_q22        = 'b0;
`endif

`ifdef APB_SLAVE1222
  assign psel1222            = psel_vector22[12];
  assign pready_vector22[12] = pready1222;
  assign prdata12_q22        = (psel1222 == 1'b1) ? prdata1222 : 'b0;
`else
  assign pready_vector22[12] = 1'b0;
  assign prdata12_q22        = 'b0;
`endif

`ifdef APB_SLAVE1322
  assign psel1322            = psel_vector22[13];
  assign pready_vector22[13] = pready1322;
  assign prdata13_q22        = (psel1322 == 1'b1) ? prdata1322 : 'b0;
`else
  assign pready_vector22[13] = 1'b0;
  assign prdata13_q22        = 'b0;
`endif

`ifdef APB_SLAVE1422
  assign psel1422            = psel_vector22[14];
  assign pready_vector22[14] = pready1422;
  assign prdata14_q22        = (psel1422 == 1'b1) ? prdata1422 : 'b0;
`else
  assign pready_vector22[14] = 1'b0;
  assign prdata14_q22        = 'b0;
`endif

`ifdef APB_SLAVE1522
  assign psel1522            = psel_vector22[15];
  assign pready_vector22[15] = pready1522;
  assign prdata15_q22        = (psel1522 == 1'b1) ? prdata1522 : 'b0;
`else
  assign pready_vector22[15] = 1'b0;
  assign prdata15_q22        = 'b0;
`endif

endmodule
