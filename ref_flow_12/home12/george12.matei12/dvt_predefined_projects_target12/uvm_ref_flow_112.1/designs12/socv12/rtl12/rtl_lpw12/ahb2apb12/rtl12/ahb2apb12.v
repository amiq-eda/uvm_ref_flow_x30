//File12 name   : ahb2apb12.v
//Title12       : 
//Created12     : 2010
//Description12 : Simple12 AHB12 to APB12 bridge12
//Notes12       : 
//----------------------------------------------------------------------
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------

`timescale 1ns/1ps

`include "ahb2apb_defines12.v"

module ahb2apb12
(
  // AHB12 signals12
  hclk12,
  hreset_n12,
  hsel12,
  haddr12,
  htrans12,
  hwdata12,
  hwrite12,
  hrdata12,
  hready12,
  hresp12,
  
  // APB12 signals12 common to all APB12 slaves12
  pclk12,
  preset_n12,
  paddr12,
  penable12,
  pwrite12,
  pwdata12
  
  // Slave12 0 signals12
  `ifdef APB_SLAVE012
  ,psel012
  ,pready012
  ,prdata012
  `endif
  
  // Slave12 1 signals12
  `ifdef APB_SLAVE112
  ,psel112
  ,pready112
  ,prdata112
  `endif
  
  // Slave12 2 signals12
  `ifdef APB_SLAVE212
  ,psel212
  ,pready212
  ,prdata212
  `endif
  
  // Slave12 3 signals12
  `ifdef APB_SLAVE312
  ,psel312
  ,pready312
  ,prdata312
  `endif
  
  // Slave12 4 signals12
  `ifdef APB_SLAVE412
  ,psel412
  ,pready412
  ,prdata412
  `endif
  
  // Slave12 5 signals12
  `ifdef APB_SLAVE512
  ,psel512
  ,pready512
  ,prdata512
  `endif
  
  // Slave12 6 signals12
  `ifdef APB_SLAVE612
  ,psel612
  ,pready612
  ,prdata612
  `endif
  
  // Slave12 7 signals12
  `ifdef APB_SLAVE712
  ,psel712
  ,pready712
  ,prdata712
  `endif
  
  // Slave12 8 signals12
  `ifdef APB_SLAVE812
  ,psel812
  ,pready812
  ,prdata812
  `endif
  
  // Slave12 9 signals12
  `ifdef APB_SLAVE912
  ,psel912
  ,pready912
  ,prdata912
  `endif
  
  // Slave12 10 signals12
  `ifdef APB_SLAVE1012
  ,psel1012
  ,pready1012
  ,prdata1012
  `endif
  
  // Slave12 11 signals12
  `ifdef APB_SLAVE1112
  ,psel1112
  ,pready1112
  ,prdata1112
  `endif
  
  // Slave12 12 signals12
  `ifdef APB_SLAVE1212
  ,psel1212
  ,pready1212
  ,prdata1212
  `endif
  
  // Slave12 13 signals12
  `ifdef APB_SLAVE1312
  ,psel1312
  ,pready1312
  ,prdata1312
  `endif
  
  // Slave12 14 signals12
  `ifdef APB_SLAVE1412
  ,psel1412
  ,pready1412
  ,prdata1412
  `endif
  
  // Slave12 15 signals12
  `ifdef APB_SLAVE1512
  ,psel1512
  ,pready1512
  ,prdata1512
  `endif
  
);

parameter 
  APB_SLAVE0_START_ADDR12  = 32'h00000000,
  APB_SLAVE0_END_ADDR12    = 32'h00000000,
  APB_SLAVE1_START_ADDR12  = 32'h00000000,
  APB_SLAVE1_END_ADDR12    = 32'h00000000,
  APB_SLAVE2_START_ADDR12  = 32'h00000000,
  APB_SLAVE2_END_ADDR12    = 32'h00000000,
  APB_SLAVE3_START_ADDR12  = 32'h00000000,
  APB_SLAVE3_END_ADDR12    = 32'h00000000,
  APB_SLAVE4_START_ADDR12  = 32'h00000000,
  APB_SLAVE4_END_ADDR12    = 32'h00000000,
  APB_SLAVE5_START_ADDR12  = 32'h00000000,
  APB_SLAVE5_END_ADDR12    = 32'h00000000,
  APB_SLAVE6_START_ADDR12  = 32'h00000000,
  APB_SLAVE6_END_ADDR12    = 32'h00000000,
  APB_SLAVE7_START_ADDR12  = 32'h00000000,
  APB_SLAVE7_END_ADDR12    = 32'h00000000,
  APB_SLAVE8_START_ADDR12  = 32'h00000000,
  APB_SLAVE8_END_ADDR12    = 32'h00000000,
  APB_SLAVE9_START_ADDR12  = 32'h00000000,
  APB_SLAVE9_END_ADDR12    = 32'h00000000,
  APB_SLAVE10_START_ADDR12  = 32'h00000000,
  APB_SLAVE10_END_ADDR12    = 32'h00000000,
  APB_SLAVE11_START_ADDR12  = 32'h00000000,
  APB_SLAVE11_END_ADDR12    = 32'h00000000,
  APB_SLAVE12_START_ADDR12  = 32'h00000000,
  APB_SLAVE12_END_ADDR12    = 32'h00000000,
  APB_SLAVE13_START_ADDR12  = 32'h00000000,
  APB_SLAVE13_END_ADDR12    = 32'h00000000,
  APB_SLAVE14_START_ADDR12  = 32'h00000000,
  APB_SLAVE14_END_ADDR12    = 32'h00000000,
  APB_SLAVE15_START_ADDR12  = 32'h00000000,
  APB_SLAVE15_END_ADDR12    = 32'h00000000;

  // AHB12 signals12
input        hclk12;
input        hreset_n12;
input        hsel12;
input[31:0]  haddr12;
input[1:0]   htrans12;
input[31:0]  hwdata12;
input        hwrite12;
output[31:0] hrdata12;
reg   [31:0] hrdata12;
output       hready12;
output[1:0]  hresp12;
  
  // APB12 signals12 common to all APB12 slaves12
input       pclk12;
input       preset_n12;
output[31:0] paddr12;
reg   [31:0] paddr12;
output       penable12;
reg          penable12;
output       pwrite12;
reg          pwrite12;
output[31:0] pwdata12;
  
  // Slave12 0 signals12
`ifdef APB_SLAVE012
  output      psel012;
  input       pready012;
  input[31:0] prdata012;
`endif
  
  // Slave12 1 signals12
`ifdef APB_SLAVE112
  output      psel112;
  input       pready112;
  input[31:0] prdata112;
`endif
  
  // Slave12 2 signals12
`ifdef APB_SLAVE212
  output      psel212;
  input       pready212;
  input[31:0] prdata212;
`endif
  
  // Slave12 3 signals12
`ifdef APB_SLAVE312
  output      psel312;
  input       pready312;
  input[31:0] prdata312;
`endif
  
  // Slave12 4 signals12
`ifdef APB_SLAVE412
  output      psel412;
  input       pready412;
  input[31:0] prdata412;
`endif
  
  // Slave12 5 signals12
`ifdef APB_SLAVE512
  output      psel512;
  input       pready512;
  input[31:0] prdata512;
`endif
  
  // Slave12 6 signals12
`ifdef APB_SLAVE612
  output      psel612;
  input       pready612;
  input[31:0] prdata612;
`endif
  
  // Slave12 7 signals12
`ifdef APB_SLAVE712
  output      psel712;
  input       pready712;
  input[31:0] prdata712;
`endif
  
  // Slave12 8 signals12
`ifdef APB_SLAVE812
  output      psel812;
  input       pready812;
  input[31:0] prdata812;
`endif
  
  // Slave12 9 signals12
`ifdef APB_SLAVE912
  output      psel912;
  input       pready912;
  input[31:0] prdata912;
`endif
  
  // Slave12 10 signals12
`ifdef APB_SLAVE1012
  output      psel1012;
  input       pready1012;
  input[31:0] prdata1012;
`endif
  
  // Slave12 11 signals12
`ifdef APB_SLAVE1112
  output      psel1112;
  input       pready1112;
  input[31:0] prdata1112;
`endif
  
  // Slave12 12 signals12
`ifdef APB_SLAVE1212
  output      psel1212;
  input       pready1212;
  input[31:0] prdata1212;
`endif
  
  // Slave12 13 signals12
`ifdef APB_SLAVE1312
  output      psel1312;
  input       pready1312;
  input[31:0] prdata1312;
`endif
  
  // Slave12 14 signals12
`ifdef APB_SLAVE1412
  output      psel1412;
  input       pready1412;
  input[31:0] prdata1412;
`endif
  
  // Slave12 15 signals12
`ifdef APB_SLAVE1512
  output      psel1512;
  input       pready1512;
  input[31:0] prdata1512;
`endif
 
reg         ahb_addr_phase12;
reg         ahb_data_phase12;
wire        valid_ahb_trans12;
wire        pready_muxed12;
wire [31:0] prdata_muxed12;
reg  [31:0] haddr_reg12;
reg         hwrite_reg12;
reg  [2:0]  apb_state12;
wire [2:0]  apb_state_idle12;
wire [2:0]  apb_state_setup12;
wire [2:0]  apb_state_access12;
reg  [15:0] slave_select12;
wire [15:0] pready_vector12;
reg  [15:0] psel_vector12;
wire [31:0] prdata0_q12;
wire [31:0] prdata1_q12;
wire [31:0] prdata2_q12;
wire [31:0] prdata3_q12;
wire [31:0] prdata4_q12;
wire [31:0] prdata5_q12;
wire [31:0] prdata6_q12;
wire [31:0] prdata7_q12;
wire [31:0] prdata8_q12;
wire [31:0] prdata9_q12;
wire [31:0] prdata10_q12;
wire [31:0] prdata11_q12;
wire [31:0] prdata12_q12;
wire [31:0] prdata13_q12;
wire [31:0] prdata14_q12;
wire [31:0] prdata15_q12;

// assign pclk12     = hclk12;
// assign preset_n12 = hreset_n12;
assign hready12   = ahb_addr_phase12;
assign pwdata12   = hwdata12;
assign hresp12  = 2'b00;

// Respond12 to NONSEQ12 or SEQ transfers12
assign valid_ahb_trans12 = ((htrans12 == 2'b10) || (htrans12 == 2'b11)) && (hsel12 == 1'b1);

always @(posedge hclk12) begin
  if (hreset_n12 == 1'b0) begin
    ahb_addr_phase12 <= 1'b1;
    ahb_data_phase12 <= 1'b0;
    haddr_reg12      <= 'b0;
    hwrite_reg12     <= 1'b0;
    hrdata12         <= 'b0;
  end
  else begin
    if (ahb_addr_phase12 == 1'b1 && valid_ahb_trans12 == 1'b1) begin
      ahb_addr_phase12 <= 1'b0;
      ahb_data_phase12 <= 1'b1;
      haddr_reg12      <= haddr12;
      hwrite_reg12     <= hwrite12;
    end
    if (ahb_data_phase12 == 1'b1 && pready_muxed12 == 1'b1 && apb_state12 == apb_state_access12) begin
      ahb_addr_phase12 <= 1'b1;
      ahb_data_phase12 <= 1'b0;
      hrdata12         <= prdata_muxed12;
    end
  end
end

// APB12 state machine12 state definitions12
assign apb_state_idle12   = 3'b001;
assign apb_state_setup12  = 3'b010;
assign apb_state_access12 = 3'b100;

// APB12 state machine12
always @(posedge hclk12 or negedge hreset_n12) begin
  if (hreset_n12 == 1'b0) begin
    apb_state12   <= apb_state_idle12;
    psel_vector12 <= 1'b0;
    penable12     <= 1'b0;
    paddr12       <= 1'b0;
    pwrite12      <= 1'b0;
  end  
  else begin
    
    // IDLE12 -> SETUP12
    if (apb_state12 == apb_state_idle12) begin
      if (ahb_data_phase12 == 1'b1) begin
        apb_state12   <= apb_state_setup12;
        psel_vector12 <= slave_select12;
        paddr12       <= haddr_reg12;
        pwrite12      <= hwrite_reg12;
      end  
    end
    
    // SETUP12 -> TRANSFER12
    if (apb_state12 == apb_state_setup12) begin
      apb_state12 <= apb_state_access12;
      penable12   <= 1'b1;
    end
    
    // TRANSFER12 -> SETUP12 or
    // TRANSFER12 -> IDLE12
    if (apb_state12 == apb_state_access12) begin
      if (pready_muxed12 == 1'b1) begin
      
        // TRANSFER12 -> SETUP12
        if (valid_ahb_trans12 == 1'b1) begin
          apb_state12   <= apb_state_setup12;
          penable12     <= 1'b0;
          psel_vector12 <= slave_select12;
          paddr12       <= haddr_reg12;
          pwrite12      <= hwrite_reg12;
        end  
        
        // TRANSFER12 -> IDLE12
        else begin
          apb_state12   <= apb_state_idle12;      
          penable12     <= 1'b0;
          psel_vector12 <= 'b0;
        end  
      end
    end
    
  end
end

always @(posedge hclk12 or negedge hreset_n12) begin
  if (hreset_n12 == 1'b0)
    slave_select12 <= 'b0;
  else begin  
  `ifdef APB_SLAVE012
     slave_select12[0]   <= valid_ahb_trans12 && (haddr12 >= APB_SLAVE0_START_ADDR12)  && (haddr12 <= APB_SLAVE0_END_ADDR12);
   `else
     slave_select12[0]   <= 1'b0;
   `endif
   
   `ifdef APB_SLAVE112
     slave_select12[1]   <= valid_ahb_trans12 && (haddr12 >= APB_SLAVE1_START_ADDR12)  && (haddr12 <= APB_SLAVE1_END_ADDR12);
   `else
     slave_select12[1]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE212  
     slave_select12[2]   <= valid_ahb_trans12 && (haddr12 >= APB_SLAVE2_START_ADDR12)  && (haddr12 <= APB_SLAVE2_END_ADDR12);
   `else
     slave_select12[2]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE312  
     slave_select12[3]   <= valid_ahb_trans12 && (haddr12 >= APB_SLAVE3_START_ADDR12)  && (haddr12 <= APB_SLAVE3_END_ADDR12);
   `else
     slave_select12[3]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE412  
     slave_select12[4]   <= valid_ahb_trans12 && (haddr12 >= APB_SLAVE4_START_ADDR12)  && (haddr12 <= APB_SLAVE4_END_ADDR12);
   `else
     slave_select12[4]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE512  
     slave_select12[5]   <= valid_ahb_trans12 && (haddr12 >= APB_SLAVE5_START_ADDR12)  && (haddr12 <= APB_SLAVE5_END_ADDR12);
   `else
     slave_select12[5]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE612  
     slave_select12[6]   <= valid_ahb_trans12 && (haddr12 >= APB_SLAVE6_START_ADDR12)  && (haddr12 <= APB_SLAVE6_END_ADDR12);
   `else
     slave_select12[6]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE712  
     slave_select12[7]   <= valid_ahb_trans12 && (haddr12 >= APB_SLAVE7_START_ADDR12)  && (haddr12 <= APB_SLAVE7_END_ADDR12);
   `else
     slave_select12[7]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE812  
     slave_select12[8]   <= valid_ahb_trans12 && (haddr12 >= APB_SLAVE8_START_ADDR12)  && (haddr12 <= APB_SLAVE8_END_ADDR12);
   `else
     slave_select12[8]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE912  
     slave_select12[9]   <= valid_ahb_trans12 && (haddr12 >= APB_SLAVE9_START_ADDR12)  && (haddr12 <= APB_SLAVE9_END_ADDR12);
   `else
     slave_select12[9]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1012  
     slave_select12[10]  <= valid_ahb_trans12 && (haddr12 >= APB_SLAVE10_START_ADDR12) && (haddr12 <= APB_SLAVE10_END_ADDR12);
   `else
     slave_select12[10]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1112  
     slave_select12[11]  <= valid_ahb_trans12 && (haddr12 >= APB_SLAVE11_START_ADDR12) && (haddr12 <= APB_SLAVE11_END_ADDR12);
   `else
     slave_select12[11]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1212  
     slave_select12[12]  <= valid_ahb_trans12 && (haddr12 >= APB_SLAVE12_START_ADDR12) && (haddr12 <= APB_SLAVE12_END_ADDR12);
   `else
     slave_select12[12]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1312  
     slave_select12[13]  <= valid_ahb_trans12 && (haddr12 >= APB_SLAVE13_START_ADDR12) && (haddr12 <= APB_SLAVE13_END_ADDR12);
   `else
     slave_select12[13]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1412  
     slave_select12[14]  <= valid_ahb_trans12 && (haddr12 >= APB_SLAVE14_START_ADDR12) && (haddr12 <= APB_SLAVE14_END_ADDR12);
   `else
     slave_select12[14]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1512  
     slave_select12[15]  <= valid_ahb_trans12 && (haddr12 >= APB_SLAVE15_START_ADDR12) && (haddr12 <= APB_SLAVE15_END_ADDR12);
   `else
     slave_select12[15]   <= 1'b0;
   `endif  
  end
end

assign pready_muxed12 = |(psel_vector12 & pready_vector12);
assign prdata_muxed12 = prdata0_q12  | prdata1_q12  | prdata2_q12  | prdata3_q12  |
                      prdata4_q12  | prdata5_q12  | prdata6_q12  | prdata7_q12  |
                      prdata8_q12  | prdata9_q12  | prdata10_q12 | prdata11_q12 |
                      prdata12_q12 | prdata13_q12 | prdata14_q12 | prdata15_q12 ;

`ifdef APB_SLAVE012
  assign psel012            = psel_vector12[0];
  assign pready_vector12[0] = pready012;
  assign prdata0_q12        = (psel012 == 1'b1) ? prdata012 : 'b0;
`else
  assign pready_vector12[0] = 1'b0;
  assign prdata0_q12        = 'b0;
`endif

`ifdef APB_SLAVE112
  assign psel112            = psel_vector12[1];
  assign pready_vector12[1] = pready112;
  assign prdata1_q12        = (psel112 == 1'b1) ? prdata112 : 'b0;
`else
  assign pready_vector12[1] = 1'b0;
  assign prdata1_q12        = 'b0;
`endif

`ifdef APB_SLAVE212
  assign psel212            = psel_vector12[2];
  assign pready_vector12[2] = pready212;
  assign prdata2_q12        = (psel212 == 1'b1) ? prdata212 : 'b0;
`else
  assign pready_vector12[2] = 1'b0;
  assign prdata2_q12        = 'b0;
`endif

`ifdef APB_SLAVE312
  assign psel312            = psel_vector12[3];
  assign pready_vector12[3] = pready312;
  assign prdata3_q12        = (psel312 == 1'b1) ? prdata312 : 'b0;
`else
  assign pready_vector12[3] = 1'b0;
  assign prdata3_q12        = 'b0;
`endif

`ifdef APB_SLAVE412
  assign psel412            = psel_vector12[4];
  assign pready_vector12[4] = pready412;
  assign prdata4_q12        = (psel412 == 1'b1) ? prdata412 : 'b0;
`else
  assign pready_vector12[4] = 1'b0;
  assign prdata4_q12        = 'b0;
`endif

`ifdef APB_SLAVE512
  assign psel512            = psel_vector12[5];
  assign pready_vector12[5] = pready512;
  assign prdata5_q12        = (psel512 == 1'b1) ? prdata512 : 'b0;
`else
  assign pready_vector12[5] = 1'b0;
  assign prdata5_q12        = 'b0;
`endif

`ifdef APB_SLAVE612
  assign psel612            = psel_vector12[6];
  assign pready_vector12[6] = pready612;
  assign prdata6_q12        = (psel612 == 1'b1) ? prdata612 : 'b0;
`else
  assign pready_vector12[6] = 1'b0;
  assign prdata6_q12        = 'b0;
`endif

`ifdef APB_SLAVE712
  assign psel712            = psel_vector12[7];
  assign pready_vector12[7] = pready712;
  assign prdata7_q12        = (psel712 == 1'b1) ? prdata712 : 'b0;
`else
  assign pready_vector12[7] = 1'b0;
  assign prdata7_q12        = 'b0;
`endif

`ifdef APB_SLAVE812
  assign psel812            = psel_vector12[8];
  assign pready_vector12[8] = pready812;
  assign prdata8_q12        = (psel812 == 1'b1) ? prdata812 : 'b0;
`else
  assign pready_vector12[8] = 1'b0;
  assign prdata8_q12        = 'b0;
`endif

`ifdef APB_SLAVE912
  assign psel912            = psel_vector12[9];
  assign pready_vector12[9] = pready912;
  assign prdata9_q12        = (psel912 == 1'b1) ? prdata912 : 'b0;
`else
  assign pready_vector12[9] = 1'b0;
  assign prdata9_q12        = 'b0;
`endif

`ifdef APB_SLAVE1012
  assign psel1012            = psel_vector12[10];
  assign pready_vector12[10] = pready1012;
  assign prdata10_q12        = (psel1012 == 1'b1) ? prdata1012 : 'b0;
`else
  assign pready_vector12[10] = 1'b0;
  assign prdata10_q12        = 'b0;
`endif

`ifdef APB_SLAVE1112
  assign psel1112            = psel_vector12[11];
  assign pready_vector12[11] = pready1112;
  assign prdata11_q12        = (psel1112 == 1'b1) ? prdata1112 : 'b0;
`else
  assign pready_vector12[11] = 1'b0;
  assign prdata11_q12        = 'b0;
`endif

`ifdef APB_SLAVE1212
  assign psel1212            = psel_vector12[12];
  assign pready_vector12[12] = pready1212;
  assign prdata12_q12        = (psel1212 == 1'b1) ? prdata1212 : 'b0;
`else
  assign pready_vector12[12] = 1'b0;
  assign prdata12_q12        = 'b0;
`endif

`ifdef APB_SLAVE1312
  assign psel1312            = psel_vector12[13];
  assign pready_vector12[13] = pready1312;
  assign prdata13_q12        = (psel1312 == 1'b1) ? prdata1312 : 'b0;
`else
  assign pready_vector12[13] = 1'b0;
  assign prdata13_q12        = 'b0;
`endif

`ifdef APB_SLAVE1412
  assign psel1412            = psel_vector12[14];
  assign pready_vector12[14] = pready1412;
  assign prdata14_q12        = (psel1412 == 1'b1) ? prdata1412 : 'b0;
`else
  assign pready_vector12[14] = 1'b0;
  assign prdata14_q12        = 'b0;
`endif

`ifdef APB_SLAVE1512
  assign psel1512            = psel_vector12[15];
  assign pready_vector12[15] = pready1512;
  assign prdata15_q12        = (psel1512 == 1'b1) ? prdata1512 : 'b0;
`else
  assign pready_vector12[15] = 1'b0;
  assign prdata15_q12        = 'b0;
`endif

endmodule
