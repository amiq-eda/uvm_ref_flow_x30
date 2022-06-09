//File28 name   : ahb2apb28.v
//Title28       : 
//Created28     : 2010
//Description28 : Simple28 AHB28 to APB28 bridge28
//Notes28       : 
//----------------------------------------------------------------------
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------

`timescale 1ns/1ps

`include "ahb2apb_defines28.v"

module ahb2apb28
(
  // AHB28 signals28
  hclk28,
  hreset_n28,
  hsel28,
  haddr28,
  htrans28,
  hwdata28,
  hwrite28,
  hrdata28,
  hready28,
  hresp28,
  
  // APB28 signals28 common to all APB28 slaves28
  pclk28,
  preset_n28,
  paddr28,
  penable28,
  pwrite28,
  pwdata28
  
  // Slave28 0 signals28
  `ifdef APB_SLAVE028
  ,psel028
  ,pready028
  ,prdata028
  `endif
  
  // Slave28 1 signals28
  `ifdef APB_SLAVE128
  ,psel128
  ,pready128
  ,prdata128
  `endif
  
  // Slave28 2 signals28
  `ifdef APB_SLAVE228
  ,psel228
  ,pready228
  ,prdata228
  `endif
  
  // Slave28 3 signals28
  `ifdef APB_SLAVE328
  ,psel328
  ,pready328
  ,prdata328
  `endif
  
  // Slave28 4 signals28
  `ifdef APB_SLAVE428
  ,psel428
  ,pready428
  ,prdata428
  `endif
  
  // Slave28 5 signals28
  `ifdef APB_SLAVE528
  ,psel528
  ,pready528
  ,prdata528
  `endif
  
  // Slave28 6 signals28
  `ifdef APB_SLAVE628
  ,psel628
  ,pready628
  ,prdata628
  `endif
  
  // Slave28 7 signals28
  `ifdef APB_SLAVE728
  ,psel728
  ,pready728
  ,prdata728
  `endif
  
  // Slave28 8 signals28
  `ifdef APB_SLAVE828
  ,psel828
  ,pready828
  ,prdata828
  `endif
  
  // Slave28 9 signals28
  `ifdef APB_SLAVE928
  ,psel928
  ,pready928
  ,prdata928
  `endif
  
  // Slave28 10 signals28
  `ifdef APB_SLAVE1028
  ,psel1028
  ,pready1028
  ,prdata1028
  `endif
  
  // Slave28 11 signals28
  `ifdef APB_SLAVE1128
  ,psel1128
  ,pready1128
  ,prdata1128
  `endif
  
  // Slave28 12 signals28
  `ifdef APB_SLAVE1228
  ,psel1228
  ,pready1228
  ,prdata1228
  `endif
  
  // Slave28 13 signals28
  `ifdef APB_SLAVE1328
  ,psel1328
  ,pready1328
  ,prdata1328
  `endif
  
  // Slave28 14 signals28
  `ifdef APB_SLAVE1428
  ,psel1428
  ,pready1428
  ,prdata1428
  `endif
  
  // Slave28 15 signals28
  `ifdef APB_SLAVE1528
  ,psel1528
  ,pready1528
  ,prdata1528
  `endif
  
);

parameter 
  APB_SLAVE0_START_ADDR28  = 32'h00000000,
  APB_SLAVE0_END_ADDR28    = 32'h00000000,
  APB_SLAVE1_START_ADDR28  = 32'h00000000,
  APB_SLAVE1_END_ADDR28    = 32'h00000000,
  APB_SLAVE2_START_ADDR28  = 32'h00000000,
  APB_SLAVE2_END_ADDR28    = 32'h00000000,
  APB_SLAVE3_START_ADDR28  = 32'h00000000,
  APB_SLAVE3_END_ADDR28    = 32'h00000000,
  APB_SLAVE4_START_ADDR28  = 32'h00000000,
  APB_SLAVE4_END_ADDR28    = 32'h00000000,
  APB_SLAVE5_START_ADDR28  = 32'h00000000,
  APB_SLAVE5_END_ADDR28    = 32'h00000000,
  APB_SLAVE6_START_ADDR28  = 32'h00000000,
  APB_SLAVE6_END_ADDR28    = 32'h00000000,
  APB_SLAVE7_START_ADDR28  = 32'h00000000,
  APB_SLAVE7_END_ADDR28    = 32'h00000000,
  APB_SLAVE8_START_ADDR28  = 32'h00000000,
  APB_SLAVE8_END_ADDR28    = 32'h00000000,
  APB_SLAVE9_START_ADDR28  = 32'h00000000,
  APB_SLAVE9_END_ADDR28    = 32'h00000000,
  APB_SLAVE10_START_ADDR28  = 32'h00000000,
  APB_SLAVE10_END_ADDR28    = 32'h00000000,
  APB_SLAVE11_START_ADDR28  = 32'h00000000,
  APB_SLAVE11_END_ADDR28    = 32'h00000000,
  APB_SLAVE12_START_ADDR28  = 32'h00000000,
  APB_SLAVE12_END_ADDR28    = 32'h00000000,
  APB_SLAVE13_START_ADDR28  = 32'h00000000,
  APB_SLAVE13_END_ADDR28    = 32'h00000000,
  APB_SLAVE14_START_ADDR28  = 32'h00000000,
  APB_SLAVE14_END_ADDR28    = 32'h00000000,
  APB_SLAVE15_START_ADDR28  = 32'h00000000,
  APB_SLAVE15_END_ADDR28    = 32'h00000000;

  // AHB28 signals28
input        hclk28;
input        hreset_n28;
input        hsel28;
input[31:0]  haddr28;
input[1:0]   htrans28;
input[31:0]  hwdata28;
input        hwrite28;
output[31:0] hrdata28;
reg   [31:0] hrdata28;
output       hready28;
output[1:0]  hresp28;
  
  // APB28 signals28 common to all APB28 slaves28
input       pclk28;
input       preset_n28;
output[31:0] paddr28;
reg   [31:0] paddr28;
output       penable28;
reg          penable28;
output       pwrite28;
reg          pwrite28;
output[31:0] pwdata28;
  
  // Slave28 0 signals28
`ifdef APB_SLAVE028
  output      psel028;
  input       pready028;
  input[31:0] prdata028;
`endif
  
  // Slave28 1 signals28
`ifdef APB_SLAVE128
  output      psel128;
  input       pready128;
  input[31:0] prdata128;
`endif
  
  // Slave28 2 signals28
`ifdef APB_SLAVE228
  output      psel228;
  input       pready228;
  input[31:0] prdata228;
`endif
  
  // Slave28 3 signals28
`ifdef APB_SLAVE328
  output      psel328;
  input       pready328;
  input[31:0] prdata328;
`endif
  
  // Slave28 4 signals28
`ifdef APB_SLAVE428
  output      psel428;
  input       pready428;
  input[31:0] prdata428;
`endif
  
  // Slave28 5 signals28
`ifdef APB_SLAVE528
  output      psel528;
  input       pready528;
  input[31:0] prdata528;
`endif
  
  // Slave28 6 signals28
`ifdef APB_SLAVE628
  output      psel628;
  input       pready628;
  input[31:0] prdata628;
`endif
  
  // Slave28 7 signals28
`ifdef APB_SLAVE728
  output      psel728;
  input       pready728;
  input[31:0] prdata728;
`endif
  
  // Slave28 8 signals28
`ifdef APB_SLAVE828
  output      psel828;
  input       pready828;
  input[31:0] prdata828;
`endif
  
  // Slave28 9 signals28
`ifdef APB_SLAVE928
  output      psel928;
  input       pready928;
  input[31:0] prdata928;
`endif
  
  // Slave28 10 signals28
`ifdef APB_SLAVE1028
  output      psel1028;
  input       pready1028;
  input[31:0] prdata1028;
`endif
  
  // Slave28 11 signals28
`ifdef APB_SLAVE1128
  output      psel1128;
  input       pready1128;
  input[31:0] prdata1128;
`endif
  
  // Slave28 12 signals28
`ifdef APB_SLAVE1228
  output      psel1228;
  input       pready1228;
  input[31:0] prdata1228;
`endif
  
  // Slave28 13 signals28
`ifdef APB_SLAVE1328
  output      psel1328;
  input       pready1328;
  input[31:0] prdata1328;
`endif
  
  // Slave28 14 signals28
`ifdef APB_SLAVE1428
  output      psel1428;
  input       pready1428;
  input[31:0] prdata1428;
`endif
  
  // Slave28 15 signals28
`ifdef APB_SLAVE1528
  output      psel1528;
  input       pready1528;
  input[31:0] prdata1528;
`endif
 
reg         ahb_addr_phase28;
reg         ahb_data_phase28;
wire        valid_ahb_trans28;
wire        pready_muxed28;
wire [31:0] prdata_muxed28;
reg  [31:0] haddr_reg28;
reg         hwrite_reg28;
reg  [2:0]  apb_state28;
wire [2:0]  apb_state_idle28;
wire [2:0]  apb_state_setup28;
wire [2:0]  apb_state_access28;
reg  [15:0] slave_select28;
wire [15:0] pready_vector28;
reg  [15:0] psel_vector28;
wire [31:0] prdata0_q28;
wire [31:0] prdata1_q28;
wire [31:0] prdata2_q28;
wire [31:0] prdata3_q28;
wire [31:0] prdata4_q28;
wire [31:0] prdata5_q28;
wire [31:0] prdata6_q28;
wire [31:0] prdata7_q28;
wire [31:0] prdata8_q28;
wire [31:0] prdata9_q28;
wire [31:0] prdata10_q28;
wire [31:0] prdata11_q28;
wire [31:0] prdata12_q28;
wire [31:0] prdata13_q28;
wire [31:0] prdata14_q28;
wire [31:0] prdata15_q28;

// assign pclk28     = hclk28;
// assign preset_n28 = hreset_n28;
assign hready28   = ahb_addr_phase28;
assign pwdata28   = hwdata28;
assign hresp28  = 2'b00;

// Respond28 to NONSEQ28 or SEQ transfers28
assign valid_ahb_trans28 = ((htrans28 == 2'b10) || (htrans28 == 2'b11)) && (hsel28 == 1'b1);

always @(posedge hclk28) begin
  if (hreset_n28 == 1'b0) begin
    ahb_addr_phase28 <= 1'b1;
    ahb_data_phase28 <= 1'b0;
    haddr_reg28      <= 'b0;
    hwrite_reg28     <= 1'b0;
    hrdata28         <= 'b0;
  end
  else begin
    if (ahb_addr_phase28 == 1'b1 && valid_ahb_trans28 == 1'b1) begin
      ahb_addr_phase28 <= 1'b0;
      ahb_data_phase28 <= 1'b1;
      haddr_reg28      <= haddr28;
      hwrite_reg28     <= hwrite28;
    end
    if (ahb_data_phase28 == 1'b1 && pready_muxed28 == 1'b1 && apb_state28 == apb_state_access28) begin
      ahb_addr_phase28 <= 1'b1;
      ahb_data_phase28 <= 1'b0;
      hrdata28         <= prdata_muxed28;
    end
  end
end

// APB28 state machine28 state definitions28
assign apb_state_idle28   = 3'b001;
assign apb_state_setup28  = 3'b010;
assign apb_state_access28 = 3'b100;

// APB28 state machine28
always @(posedge hclk28 or negedge hreset_n28) begin
  if (hreset_n28 == 1'b0) begin
    apb_state28   <= apb_state_idle28;
    psel_vector28 <= 1'b0;
    penable28     <= 1'b0;
    paddr28       <= 1'b0;
    pwrite28      <= 1'b0;
  end  
  else begin
    
    // IDLE28 -> SETUP28
    if (apb_state28 == apb_state_idle28) begin
      if (ahb_data_phase28 == 1'b1) begin
        apb_state28   <= apb_state_setup28;
        psel_vector28 <= slave_select28;
        paddr28       <= haddr_reg28;
        pwrite28      <= hwrite_reg28;
      end  
    end
    
    // SETUP28 -> TRANSFER28
    if (apb_state28 == apb_state_setup28) begin
      apb_state28 <= apb_state_access28;
      penable28   <= 1'b1;
    end
    
    // TRANSFER28 -> SETUP28 or
    // TRANSFER28 -> IDLE28
    if (apb_state28 == apb_state_access28) begin
      if (pready_muxed28 == 1'b1) begin
      
        // TRANSFER28 -> SETUP28
        if (valid_ahb_trans28 == 1'b1) begin
          apb_state28   <= apb_state_setup28;
          penable28     <= 1'b0;
          psel_vector28 <= slave_select28;
          paddr28       <= haddr_reg28;
          pwrite28      <= hwrite_reg28;
        end  
        
        // TRANSFER28 -> IDLE28
        else begin
          apb_state28   <= apb_state_idle28;      
          penable28     <= 1'b0;
          psel_vector28 <= 'b0;
        end  
      end
    end
    
  end
end

always @(posedge hclk28 or negedge hreset_n28) begin
  if (hreset_n28 == 1'b0)
    slave_select28 <= 'b0;
  else begin  
  `ifdef APB_SLAVE028
     slave_select28[0]   <= valid_ahb_trans28 && (haddr28 >= APB_SLAVE0_START_ADDR28)  && (haddr28 <= APB_SLAVE0_END_ADDR28);
   `else
     slave_select28[0]   <= 1'b0;
   `endif
   
   `ifdef APB_SLAVE128
     slave_select28[1]   <= valid_ahb_trans28 && (haddr28 >= APB_SLAVE1_START_ADDR28)  && (haddr28 <= APB_SLAVE1_END_ADDR28);
   `else
     slave_select28[1]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE228  
     slave_select28[2]   <= valid_ahb_trans28 && (haddr28 >= APB_SLAVE2_START_ADDR28)  && (haddr28 <= APB_SLAVE2_END_ADDR28);
   `else
     slave_select28[2]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE328  
     slave_select28[3]   <= valid_ahb_trans28 && (haddr28 >= APB_SLAVE3_START_ADDR28)  && (haddr28 <= APB_SLAVE3_END_ADDR28);
   `else
     slave_select28[3]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE428  
     slave_select28[4]   <= valid_ahb_trans28 && (haddr28 >= APB_SLAVE4_START_ADDR28)  && (haddr28 <= APB_SLAVE4_END_ADDR28);
   `else
     slave_select28[4]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE528  
     slave_select28[5]   <= valid_ahb_trans28 && (haddr28 >= APB_SLAVE5_START_ADDR28)  && (haddr28 <= APB_SLAVE5_END_ADDR28);
   `else
     slave_select28[5]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE628  
     slave_select28[6]   <= valid_ahb_trans28 && (haddr28 >= APB_SLAVE6_START_ADDR28)  && (haddr28 <= APB_SLAVE6_END_ADDR28);
   `else
     slave_select28[6]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE728  
     slave_select28[7]   <= valid_ahb_trans28 && (haddr28 >= APB_SLAVE7_START_ADDR28)  && (haddr28 <= APB_SLAVE7_END_ADDR28);
   `else
     slave_select28[7]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE828  
     slave_select28[8]   <= valid_ahb_trans28 && (haddr28 >= APB_SLAVE8_START_ADDR28)  && (haddr28 <= APB_SLAVE8_END_ADDR28);
   `else
     slave_select28[8]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE928  
     slave_select28[9]   <= valid_ahb_trans28 && (haddr28 >= APB_SLAVE9_START_ADDR28)  && (haddr28 <= APB_SLAVE9_END_ADDR28);
   `else
     slave_select28[9]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1028  
     slave_select28[10]  <= valid_ahb_trans28 && (haddr28 >= APB_SLAVE10_START_ADDR28) && (haddr28 <= APB_SLAVE10_END_ADDR28);
   `else
     slave_select28[10]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1128  
     slave_select28[11]  <= valid_ahb_trans28 && (haddr28 >= APB_SLAVE11_START_ADDR28) && (haddr28 <= APB_SLAVE11_END_ADDR28);
   `else
     slave_select28[11]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1228  
     slave_select28[12]  <= valid_ahb_trans28 && (haddr28 >= APB_SLAVE12_START_ADDR28) && (haddr28 <= APB_SLAVE12_END_ADDR28);
   `else
     slave_select28[12]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1328  
     slave_select28[13]  <= valid_ahb_trans28 && (haddr28 >= APB_SLAVE13_START_ADDR28) && (haddr28 <= APB_SLAVE13_END_ADDR28);
   `else
     slave_select28[13]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1428  
     slave_select28[14]  <= valid_ahb_trans28 && (haddr28 >= APB_SLAVE14_START_ADDR28) && (haddr28 <= APB_SLAVE14_END_ADDR28);
   `else
     slave_select28[14]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1528  
     slave_select28[15]  <= valid_ahb_trans28 && (haddr28 >= APB_SLAVE15_START_ADDR28) && (haddr28 <= APB_SLAVE15_END_ADDR28);
   `else
     slave_select28[15]   <= 1'b0;
   `endif  
  end
end

assign pready_muxed28 = |(psel_vector28 & pready_vector28);
assign prdata_muxed28 = prdata0_q28  | prdata1_q28  | prdata2_q28  | prdata3_q28  |
                      prdata4_q28  | prdata5_q28  | prdata6_q28  | prdata7_q28  |
                      prdata8_q28  | prdata9_q28  | prdata10_q28 | prdata11_q28 |
                      prdata12_q28 | prdata13_q28 | prdata14_q28 | prdata15_q28 ;

`ifdef APB_SLAVE028
  assign psel028            = psel_vector28[0];
  assign pready_vector28[0] = pready028;
  assign prdata0_q28        = (psel028 == 1'b1) ? prdata028 : 'b0;
`else
  assign pready_vector28[0] = 1'b0;
  assign prdata0_q28        = 'b0;
`endif

`ifdef APB_SLAVE128
  assign psel128            = psel_vector28[1];
  assign pready_vector28[1] = pready128;
  assign prdata1_q28        = (psel128 == 1'b1) ? prdata128 : 'b0;
`else
  assign pready_vector28[1] = 1'b0;
  assign prdata1_q28        = 'b0;
`endif

`ifdef APB_SLAVE228
  assign psel228            = psel_vector28[2];
  assign pready_vector28[2] = pready228;
  assign prdata2_q28        = (psel228 == 1'b1) ? prdata228 : 'b0;
`else
  assign pready_vector28[2] = 1'b0;
  assign prdata2_q28        = 'b0;
`endif

`ifdef APB_SLAVE328
  assign psel328            = psel_vector28[3];
  assign pready_vector28[3] = pready328;
  assign prdata3_q28        = (psel328 == 1'b1) ? prdata328 : 'b0;
`else
  assign pready_vector28[3] = 1'b0;
  assign prdata3_q28        = 'b0;
`endif

`ifdef APB_SLAVE428
  assign psel428            = psel_vector28[4];
  assign pready_vector28[4] = pready428;
  assign prdata4_q28        = (psel428 == 1'b1) ? prdata428 : 'b0;
`else
  assign pready_vector28[4] = 1'b0;
  assign prdata4_q28        = 'b0;
`endif

`ifdef APB_SLAVE528
  assign psel528            = psel_vector28[5];
  assign pready_vector28[5] = pready528;
  assign prdata5_q28        = (psel528 == 1'b1) ? prdata528 : 'b0;
`else
  assign pready_vector28[5] = 1'b0;
  assign prdata5_q28        = 'b0;
`endif

`ifdef APB_SLAVE628
  assign psel628            = psel_vector28[6];
  assign pready_vector28[6] = pready628;
  assign prdata6_q28        = (psel628 == 1'b1) ? prdata628 : 'b0;
`else
  assign pready_vector28[6] = 1'b0;
  assign prdata6_q28        = 'b0;
`endif

`ifdef APB_SLAVE728
  assign psel728            = psel_vector28[7];
  assign pready_vector28[7] = pready728;
  assign prdata7_q28        = (psel728 == 1'b1) ? prdata728 : 'b0;
`else
  assign pready_vector28[7] = 1'b0;
  assign prdata7_q28        = 'b0;
`endif

`ifdef APB_SLAVE828
  assign psel828            = psel_vector28[8];
  assign pready_vector28[8] = pready828;
  assign prdata8_q28        = (psel828 == 1'b1) ? prdata828 : 'b0;
`else
  assign pready_vector28[8] = 1'b0;
  assign prdata8_q28        = 'b0;
`endif

`ifdef APB_SLAVE928
  assign psel928            = psel_vector28[9];
  assign pready_vector28[9] = pready928;
  assign prdata9_q28        = (psel928 == 1'b1) ? prdata928 : 'b0;
`else
  assign pready_vector28[9] = 1'b0;
  assign prdata9_q28        = 'b0;
`endif

`ifdef APB_SLAVE1028
  assign psel1028            = psel_vector28[10];
  assign pready_vector28[10] = pready1028;
  assign prdata10_q28        = (psel1028 == 1'b1) ? prdata1028 : 'b0;
`else
  assign pready_vector28[10] = 1'b0;
  assign prdata10_q28        = 'b0;
`endif

`ifdef APB_SLAVE1128
  assign psel1128            = psel_vector28[11];
  assign pready_vector28[11] = pready1128;
  assign prdata11_q28        = (psel1128 == 1'b1) ? prdata1128 : 'b0;
`else
  assign pready_vector28[11] = 1'b0;
  assign prdata11_q28        = 'b0;
`endif

`ifdef APB_SLAVE1228
  assign psel1228            = psel_vector28[12];
  assign pready_vector28[12] = pready1228;
  assign prdata12_q28        = (psel1228 == 1'b1) ? prdata1228 : 'b0;
`else
  assign pready_vector28[12] = 1'b0;
  assign prdata12_q28        = 'b0;
`endif

`ifdef APB_SLAVE1328
  assign psel1328            = psel_vector28[13];
  assign pready_vector28[13] = pready1328;
  assign prdata13_q28        = (psel1328 == 1'b1) ? prdata1328 : 'b0;
`else
  assign pready_vector28[13] = 1'b0;
  assign prdata13_q28        = 'b0;
`endif

`ifdef APB_SLAVE1428
  assign psel1428            = psel_vector28[14];
  assign pready_vector28[14] = pready1428;
  assign prdata14_q28        = (psel1428 == 1'b1) ? prdata1428 : 'b0;
`else
  assign pready_vector28[14] = 1'b0;
  assign prdata14_q28        = 'b0;
`endif

`ifdef APB_SLAVE1528
  assign psel1528            = psel_vector28[15];
  assign pready_vector28[15] = pready1528;
  assign prdata15_q28        = (psel1528 == 1'b1) ? prdata1528 : 'b0;
`else
  assign pready_vector28[15] = 1'b0;
  assign prdata15_q28        = 'b0;
`endif

endmodule
