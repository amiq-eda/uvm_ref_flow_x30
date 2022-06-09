//File17 name   : ahb2apb17.v
//Title17       : 
//Created17     : 2010
//Description17 : Simple17 AHB17 to APB17 bridge17
//Notes17       : 
//----------------------------------------------------------------------
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------

`timescale 1ns/1ps

`include "ahb2apb_defines17.v"

module ahb2apb17
(
  // AHB17 signals17
  hclk17,
  hreset_n17,
  hsel17,
  haddr17,
  htrans17,
  hwdata17,
  hwrite17,
  hrdata17,
  hready17,
  hresp17,
  
  // APB17 signals17 common to all APB17 slaves17
  pclk17,
  preset_n17,
  paddr17,
  penable17,
  pwrite17,
  pwdata17
  
  // Slave17 0 signals17
  `ifdef APB_SLAVE017
  ,psel017
  ,pready017
  ,prdata017
  `endif
  
  // Slave17 1 signals17
  `ifdef APB_SLAVE117
  ,psel117
  ,pready117
  ,prdata117
  `endif
  
  // Slave17 2 signals17
  `ifdef APB_SLAVE217
  ,psel217
  ,pready217
  ,prdata217
  `endif
  
  // Slave17 3 signals17
  `ifdef APB_SLAVE317
  ,psel317
  ,pready317
  ,prdata317
  `endif
  
  // Slave17 4 signals17
  `ifdef APB_SLAVE417
  ,psel417
  ,pready417
  ,prdata417
  `endif
  
  // Slave17 5 signals17
  `ifdef APB_SLAVE517
  ,psel517
  ,pready517
  ,prdata517
  `endif
  
  // Slave17 6 signals17
  `ifdef APB_SLAVE617
  ,psel617
  ,pready617
  ,prdata617
  `endif
  
  // Slave17 7 signals17
  `ifdef APB_SLAVE717
  ,psel717
  ,pready717
  ,prdata717
  `endif
  
  // Slave17 8 signals17
  `ifdef APB_SLAVE817
  ,psel817
  ,pready817
  ,prdata817
  `endif
  
  // Slave17 9 signals17
  `ifdef APB_SLAVE917
  ,psel917
  ,pready917
  ,prdata917
  `endif
  
  // Slave17 10 signals17
  `ifdef APB_SLAVE1017
  ,psel1017
  ,pready1017
  ,prdata1017
  `endif
  
  // Slave17 11 signals17
  `ifdef APB_SLAVE1117
  ,psel1117
  ,pready1117
  ,prdata1117
  `endif
  
  // Slave17 12 signals17
  `ifdef APB_SLAVE1217
  ,psel1217
  ,pready1217
  ,prdata1217
  `endif
  
  // Slave17 13 signals17
  `ifdef APB_SLAVE1317
  ,psel1317
  ,pready1317
  ,prdata1317
  `endif
  
  // Slave17 14 signals17
  `ifdef APB_SLAVE1417
  ,psel1417
  ,pready1417
  ,prdata1417
  `endif
  
  // Slave17 15 signals17
  `ifdef APB_SLAVE1517
  ,psel1517
  ,pready1517
  ,prdata1517
  `endif
  
);

parameter 
  APB_SLAVE0_START_ADDR17  = 32'h00000000,
  APB_SLAVE0_END_ADDR17    = 32'h00000000,
  APB_SLAVE1_START_ADDR17  = 32'h00000000,
  APB_SLAVE1_END_ADDR17    = 32'h00000000,
  APB_SLAVE2_START_ADDR17  = 32'h00000000,
  APB_SLAVE2_END_ADDR17    = 32'h00000000,
  APB_SLAVE3_START_ADDR17  = 32'h00000000,
  APB_SLAVE3_END_ADDR17    = 32'h00000000,
  APB_SLAVE4_START_ADDR17  = 32'h00000000,
  APB_SLAVE4_END_ADDR17    = 32'h00000000,
  APB_SLAVE5_START_ADDR17  = 32'h00000000,
  APB_SLAVE5_END_ADDR17    = 32'h00000000,
  APB_SLAVE6_START_ADDR17  = 32'h00000000,
  APB_SLAVE6_END_ADDR17    = 32'h00000000,
  APB_SLAVE7_START_ADDR17  = 32'h00000000,
  APB_SLAVE7_END_ADDR17    = 32'h00000000,
  APB_SLAVE8_START_ADDR17  = 32'h00000000,
  APB_SLAVE8_END_ADDR17    = 32'h00000000,
  APB_SLAVE9_START_ADDR17  = 32'h00000000,
  APB_SLAVE9_END_ADDR17    = 32'h00000000,
  APB_SLAVE10_START_ADDR17  = 32'h00000000,
  APB_SLAVE10_END_ADDR17    = 32'h00000000,
  APB_SLAVE11_START_ADDR17  = 32'h00000000,
  APB_SLAVE11_END_ADDR17    = 32'h00000000,
  APB_SLAVE12_START_ADDR17  = 32'h00000000,
  APB_SLAVE12_END_ADDR17    = 32'h00000000,
  APB_SLAVE13_START_ADDR17  = 32'h00000000,
  APB_SLAVE13_END_ADDR17    = 32'h00000000,
  APB_SLAVE14_START_ADDR17  = 32'h00000000,
  APB_SLAVE14_END_ADDR17    = 32'h00000000,
  APB_SLAVE15_START_ADDR17  = 32'h00000000,
  APB_SLAVE15_END_ADDR17    = 32'h00000000;

  // AHB17 signals17
input        hclk17;
input        hreset_n17;
input        hsel17;
input[31:0]  haddr17;
input[1:0]   htrans17;
input[31:0]  hwdata17;
input        hwrite17;
output[31:0] hrdata17;
reg   [31:0] hrdata17;
output       hready17;
output[1:0]  hresp17;
  
  // APB17 signals17 common to all APB17 slaves17
input       pclk17;
input       preset_n17;
output[31:0] paddr17;
reg   [31:0] paddr17;
output       penable17;
reg          penable17;
output       pwrite17;
reg          pwrite17;
output[31:0] pwdata17;
  
  // Slave17 0 signals17
`ifdef APB_SLAVE017
  output      psel017;
  input       pready017;
  input[31:0] prdata017;
`endif
  
  // Slave17 1 signals17
`ifdef APB_SLAVE117
  output      psel117;
  input       pready117;
  input[31:0] prdata117;
`endif
  
  // Slave17 2 signals17
`ifdef APB_SLAVE217
  output      psel217;
  input       pready217;
  input[31:0] prdata217;
`endif
  
  // Slave17 3 signals17
`ifdef APB_SLAVE317
  output      psel317;
  input       pready317;
  input[31:0] prdata317;
`endif
  
  // Slave17 4 signals17
`ifdef APB_SLAVE417
  output      psel417;
  input       pready417;
  input[31:0] prdata417;
`endif
  
  // Slave17 5 signals17
`ifdef APB_SLAVE517
  output      psel517;
  input       pready517;
  input[31:0] prdata517;
`endif
  
  // Slave17 6 signals17
`ifdef APB_SLAVE617
  output      psel617;
  input       pready617;
  input[31:0] prdata617;
`endif
  
  // Slave17 7 signals17
`ifdef APB_SLAVE717
  output      psel717;
  input       pready717;
  input[31:0] prdata717;
`endif
  
  // Slave17 8 signals17
`ifdef APB_SLAVE817
  output      psel817;
  input       pready817;
  input[31:0] prdata817;
`endif
  
  // Slave17 9 signals17
`ifdef APB_SLAVE917
  output      psel917;
  input       pready917;
  input[31:0] prdata917;
`endif
  
  // Slave17 10 signals17
`ifdef APB_SLAVE1017
  output      psel1017;
  input       pready1017;
  input[31:0] prdata1017;
`endif
  
  // Slave17 11 signals17
`ifdef APB_SLAVE1117
  output      psel1117;
  input       pready1117;
  input[31:0] prdata1117;
`endif
  
  // Slave17 12 signals17
`ifdef APB_SLAVE1217
  output      psel1217;
  input       pready1217;
  input[31:0] prdata1217;
`endif
  
  // Slave17 13 signals17
`ifdef APB_SLAVE1317
  output      psel1317;
  input       pready1317;
  input[31:0] prdata1317;
`endif
  
  // Slave17 14 signals17
`ifdef APB_SLAVE1417
  output      psel1417;
  input       pready1417;
  input[31:0] prdata1417;
`endif
  
  // Slave17 15 signals17
`ifdef APB_SLAVE1517
  output      psel1517;
  input       pready1517;
  input[31:0] prdata1517;
`endif
 
reg         ahb_addr_phase17;
reg         ahb_data_phase17;
wire        valid_ahb_trans17;
wire        pready_muxed17;
wire [31:0] prdata_muxed17;
reg  [31:0] haddr_reg17;
reg         hwrite_reg17;
reg  [2:0]  apb_state17;
wire [2:0]  apb_state_idle17;
wire [2:0]  apb_state_setup17;
wire [2:0]  apb_state_access17;
reg  [15:0] slave_select17;
wire [15:0] pready_vector17;
reg  [15:0] psel_vector17;
wire [31:0] prdata0_q17;
wire [31:0] prdata1_q17;
wire [31:0] prdata2_q17;
wire [31:0] prdata3_q17;
wire [31:0] prdata4_q17;
wire [31:0] prdata5_q17;
wire [31:0] prdata6_q17;
wire [31:0] prdata7_q17;
wire [31:0] prdata8_q17;
wire [31:0] prdata9_q17;
wire [31:0] prdata10_q17;
wire [31:0] prdata11_q17;
wire [31:0] prdata12_q17;
wire [31:0] prdata13_q17;
wire [31:0] prdata14_q17;
wire [31:0] prdata15_q17;

// assign pclk17     = hclk17;
// assign preset_n17 = hreset_n17;
assign hready17   = ahb_addr_phase17;
assign pwdata17   = hwdata17;
assign hresp17  = 2'b00;

// Respond17 to NONSEQ17 or SEQ transfers17
assign valid_ahb_trans17 = ((htrans17 == 2'b10) || (htrans17 == 2'b11)) && (hsel17 == 1'b1);

always @(posedge hclk17) begin
  if (hreset_n17 == 1'b0) begin
    ahb_addr_phase17 <= 1'b1;
    ahb_data_phase17 <= 1'b0;
    haddr_reg17      <= 'b0;
    hwrite_reg17     <= 1'b0;
    hrdata17         <= 'b0;
  end
  else begin
    if (ahb_addr_phase17 == 1'b1 && valid_ahb_trans17 == 1'b1) begin
      ahb_addr_phase17 <= 1'b0;
      ahb_data_phase17 <= 1'b1;
      haddr_reg17      <= haddr17;
      hwrite_reg17     <= hwrite17;
    end
    if (ahb_data_phase17 == 1'b1 && pready_muxed17 == 1'b1 && apb_state17 == apb_state_access17) begin
      ahb_addr_phase17 <= 1'b1;
      ahb_data_phase17 <= 1'b0;
      hrdata17         <= prdata_muxed17;
    end
  end
end

// APB17 state machine17 state definitions17
assign apb_state_idle17   = 3'b001;
assign apb_state_setup17  = 3'b010;
assign apb_state_access17 = 3'b100;

// APB17 state machine17
always @(posedge hclk17 or negedge hreset_n17) begin
  if (hreset_n17 == 1'b0) begin
    apb_state17   <= apb_state_idle17;
    psel_vector17 <= 1'b0;
    penable17     <= 1'b0;
    paddr17       <= 1'b0;
    pwrite17      <= 1'b0;
  end  
  else begin
    
    // IDLE17 -> SETUP17
    if (apb_state17 == apb_state_idle17) begin
      if (ahb_data_phase17 == 1'b1) begin
        apb_state17   <= apb_state_setup17;
        psel_vector17 <= slave_select17;
        paddr17       <= haddr_reg17;
        pwrite17      <= hwrite_reg17;
      end  
    end
    
    // SETUP17 -> TRANSFER17
    if (apb_state17 == apb_state_setup17) begin
      apb_state17 <= apb_state_access17;
      penable17   <= 1'b1;
    end
    
    // TRANSFER17 -> SETUP17 or
    // TRANSFER17 -> IDLE17
    if (apb_state17 == apb_state_access17) begin
      if (pready_muxed17 == 1'b1) begin
      
        // TRANSFER17 -> SETUP17
        if (valid_ahb_trans17 == 1'b1) begin
          apb_state17   <= apb_state_setup17;
          penable17     <= 1'b0;
          psel_vector17 <= slave_select17;
          paddr17       <= haddr_reg17;
          pwrite17      <= hwrite_reg17;
        end  
        
        // TRANSFER17 -> IDLE17
        else begin
          apb_state17   <= apb_state_idle17;      
          penable17     <= 1'b0;
          psel_vector17 <= 'b0;
        end  
      end
    end
    
  end
end

always @(posedge hclk17 or negedge hreset_n17) begin
  if (hreset_n17 == 1'b0)
    slave_select17 <= 'b0;
  else begin  
  `ifdef APB_SLAVE017
     slave_select17[0]   <= valid_ahb_trans17 && (haddr17 >= APB_SLAVE0_START_ADDR17)  && (haddr17 <= APB_SLAVE0_END_ADDR17);
   `else
     slave_select17[0]   <= 1'b0;
   `endif
   
   `ifdef APB_SLAVE117
     slave_select17[1]   <= valid_ahb_trans17 && (haddr17 >= APB_SLAVE1_START_ADDR17)  && (haddr17 <= APB_SLAVE1_END_ADDR17);
   `else
     slave_select17[1]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE217  
     slave_select17[2]   <= valid_ahb_trans17 && (haddr17 >= APB_SLAVE2_START_ADDR17)  && (haddr17 <= APB_SLAVE2_END_ADDR17);
   `else
     slave_select17[2]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE317  
     slave_select17[3]   <= valid_ahb_trans17 && (haddr17 >= APB_SLAVE3_START_ADDR17)  && (haddr17 <= APB_SLAVE3_END_ADDR17);
   `else
     slave_select17[3]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE417  
     slave_select17[4]   <= valid_ahb_trans17 && (haddr17 >= APB_SLAVE4_START_ADDR17)  && (haddr17 <= APB_SLAVE4_END_ADDR17);
   `else
     slave_select17[4]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE517  
     slave_select17[5]   <= valid_ahb_trans17 && (haddr17 >= APB_SLAVE5_START_ADDR17)  && (haddr17 <= APB_SLAVE5_END_ADDR17);
   `else
     slave_select17[5]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE617  
     slave_select17[6]   <= valid_ahb_trans17 && (haddr17 >= APB_SLAVE6_START_ADDR17)  && (haddr17 <= APB_SLAVE6_END_ADDR17);
   `else
     slave_select17[6]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE717  
     slave_select17[7]   <= valid_ahb_trans17 && (haddr17 >= APB_SLAVE7_START_ADDR17)  && (haddr17 <= APB_SLAVE7_END_ADDR17);
   `else
     slave_select17[7]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE817  
     slave_select17[8]   <= valid_ahb_trans17 && (haddr17 >= APB_SLAVE8_START_ADDR17)  && (haddr17 <= APB_SLAVE8_END_ADDR17);
   `else
     slave_select17[8]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE917  
     slave_select17[9]   <= valid_ahb_trans17 && (haddr17 >= APB_SLAVE9_START_ADDR17)  && (haddr17 <= APB_SLAVE9_END_ADDR17);
   `else
     slave_select17[9]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1017  
     slave_select17[10]  <= valid_ahb_trans17 && (haddr17 >= APB_SLAVE10_START_ADDR17) && (haddr17 <= APB_SLAVE10_END_ADDR17);
   `else
     slave_select17[10]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1117  
     slave_select17[11]  <= valid_ahb_trans17 && (haddr17 >= APB_SLAVE11_START_ADDR17) && (haddr17 <= APB_SLAVE11_END_ADDR17);
   `else
     slave_select17[11]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1217  
     slave_select17[12]  <= valid_ahb_trans17 && (haddr17 >= APB_SLAVE12_START_ADDR17) && (haddr17 <= APB_SLAVE12_END_ADDR17);
   `else
     slave_select17[12]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1317  
     slave_select17[13]  <= valid_ahb_trans17 && (haddr17 >= APB_SLAVE13_START_ADDR17) && (haddr17 <= APB_SLAVE13_END_ADDR17);
   `else
     slave_select17[13]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1417  
     slave_select17[14]  <= valid_ahb_trans17 && (haddr17 >= APB_SLAVE14_START_ADDR17) && (haddr17 <= APB_SLAVE14_END_ADDR17);
   `else
     slave_select17[14]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1517  
     slave_select17[15]  <= valid_ahb_trans17 && (haddr17 >= APB_SLAVE15_START_ADDR17) && (haddr17 <= APB_SLAVE15_END_ADDR17);
   `else
     slave_select17[15]   <= 1'b0;
   `endif  
  end
end

assign pready_muxed17 = |(psel_vector17 & pready_vector17);
assign prdata_muxed17 = prdata0_q17  | prdata1_q17  | prdata2_q17  | prdata3_q17  |
                      prdata4_q17  | prdata5_q17  | prdata6_q17  | prdata7_q17  |
                      prdata8_q17  | prdata9_q17  | prdata10_q17 | prdata11_q17 |
                      prdata12_q17 | prdata13_q17 | prdata14_q17 | prdata15_q17 ;

`ifdef APB_SLAVE017
  assign psel017            = psel_vector17[0];
  assign pready_vector17[0] = pready017;
  assign prdata0_q17        = (psel017 == 1'b1) ? prdata017 : 'b0;
`else
  assign pready_vector17[0] = 1'b0;
  assign prdata0_q17        = 'b0;
`endif

`ifdef APB_SLAVE117
  assign psel117            = psel_vector17[1];
  assign pready_vector17[1] = pready117;
  assign prdata1_q17        = (psel117 == 1'b1) ? prdata117 : 'b0;
`else
  assign pready_vector17[1] = 1'b0;
  assign prdata1_q17        = 'b0;
`endif

`ifdef APB_SLAVE217
  assign psel217            = psel_vector17[2];
  assign pready_vector17[2] = pready217;
  assign prdata2_q17        = (psel217 == 1'b1) ? prdata217 : 'b0;
`else
  assign pready_vector17[2] = 1'b0;
  assign prdata2_q17        = 'b0;
`endif

`ifdef APB_SLAVE317
  assign psel317            = psel_vector17[3];
  assign pready_vector17[3] = pready317;
  assign prdata3_q17        = (psel317 == 1'b1) ? prdata317 : 'b0;
`else
  assign pready_vector17[3] = 1'b0;
  assign prdata3_q17        = 'b0;
`endif

`ifdef APB_SLAVE417
  assign psel417            = psel_vector17[4];
  assign pready_vector17[4] = pready417;
  assign prdata4_q17        = (psel417 == 1'b1) ? prdata417 : 'b0;
`else
  assign pready_vector17[4] = 1'b0;
  assign prdata4_q17        = 'b0;
`endif

`ifdef APB_SLAVE517
  assign psel517            = psel_vector17[5];
  assign pready_vector17[5] = pready517;
  assign prdata5_q17        = (psel517 == 1'b1) ? prdata517 : 'b0;
`else
  assign pready_vector17[5] = 1'b0;
  assign prdata5_q17        = 'b0;
`endif

`ifdef APB_SLAVE617
  assign psel617            = psel_vector17[6];
  assign pready_vector17[6] = pready617;
  assign prdata6_q17        = (psel617 == 1'b1) ? prdata617 : 'b0;
`else
  assign pready_vector17[6] = 1'b0;
  assign prdata6_q17        = 'b0;
`endif

`ifdef APB_SLAVE717
  assign psel717            = psel_vector17[7];
  assign pready_vector17[7] = pready717;
  assign prdata7_q17        = (psel717 == 1'b1) ? prdata717 : 'b0;
`else
  assign pready_vector17[7] = 1'b0;
  assign prdata7_q17        = 'b0;
`endif

`ifdef APB_SLAVE817
  assign psel817            = psel_vector17[8];
  assign pready_vector17[8] = pready817;
  assign prdata8_q17        = (psel817 == 1'b1) ? prdata817 : 'b0;
`else
  assign pready_vector17[8] = 1'b0;
  assign prdata8_q17        = 'b0;
`endif

`ifdef APB_SLAVE917
  assign psel917            = psel_vector17[9];
  assign pready_vector17[9] = pready917;
  assign prdata9_q17        = (psel917 == 1'b1) ? prdata917 : 'b0;
`else
  assign pready_vector17[9] = 1'b0;
  assign prdata9_q17        = 'b0;
`endif

`ifdef APB_SLAVE1017
  assign psel1017            = psel_vector17[10];
  assign pready_vector17[10] = pready1017;
  assign prdata10_q17        = (psel1017 == 1'b1) ? prdata1017 : 'b0;
`else
  assign pready_vector17[10] = 1'b0;
  assign prdata10_q17        = 'b0;
`endif

`ifdef APB_SLAVE1117
  assign psel1117            = psel_vector17[11];
  assign pready_vector17[11] = pready1117;
  assign prdata11_q17        = (psel1117 == 1'b1) ? prdata1117 : 'b0;
`else
  assign pready_vector17[11] = 1'b0;
  assign prdata11_q17        = 'b0;
`endif

`ifdef APB_SLAVE1217
  assign psel1217            = psel_vector17[12];
  assign pready_vector17[12] = pready1217;
  assign prdata12_q17        = (psel1217 == 1'b1) ? prdata1217 : 'b0;
`else
  assign pready_vector17[12] = 1'b0;
  assign prdata12_q17        = 'b0;
`endif

`ifdef APB_SLAVE1317
  assign psel1317            = psel_vector17[13];
  assign pready_vector17[13] = pready1317;
  assign prdata13_q17        = (psel1317 == 1'b1) ? prdata1317 : 'b0;
`else
  assign pready_vector17[13] = 1'b0;
  assign prdata13_q17        = 'b0;
`endif

`ifdef APB_SLAVE1417
  assign psel1417            = psel_vector17[14];
  assign pready_vector17[14] = pready1417;
  assign prdata14_q17        = (psel1417 == 1'b1) ? prdata1417 : 'b0;
`else
  assign pready_vector17[14] = 1'b0;
  assign prdata14_q17        = 'b0;
`endif

`ifdef APB_SLAVE1517
  assign psel1517            = psel_vector17[15];
  assign pready_vector17[15] = pready1517;
  assign prdata15_q17        = (psel1517 == 1'b1) ? prdata1517 : 'b0;
`else
  assign pready_vector17[15] = 1'b0;
  assign prdata15_q17        = 'b0;
`endif

endmodule
