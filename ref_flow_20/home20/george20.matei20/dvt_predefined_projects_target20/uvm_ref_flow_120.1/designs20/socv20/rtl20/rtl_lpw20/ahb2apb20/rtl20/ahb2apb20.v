//File20 name   : ahb2apb20.v
//Title20       : 
//Created20     : 2010
//Description20 : Simple20 AHB20 to APB20 bridge20
//Notes20       : 
//----------------------------------------------------------------------
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------

`timescale 1ns/1ps

`include "ahb2apb_defines20.v"

module ahb2apb20
(
  // AHB20 signals20
  hclk20,
  hreset_n20,
  hsel20,
  haddr20,
  htrans20,
  hwdata20,
  hwrite20,
  hrdata20,
  hready20,
  hresp20,
  
  // APB20 signals20 common to all APB20 slaves20
  pclk20,
  preset_n20,
  paddr20,
  penable20,
  pwrite20,
  pwdata20
  
  // Slave20 0 signals20
  `ifdef APB_SLAVE020
  ,psel020
  ,pready020
  ,prdata020
  `endif
  
  // Slave20 1 signals20
  `ifdef APB_SLAVE120
  ,psel120
  ,pready120
  ,prdata120
  `endif
  
  // Slave20 2 signals20
  `ifdef APB_SLAVE220
  ,psel220
  ,pready220
  ,prdata220
  `endif
  
  // Slave20 3 signals20
  `ifdef APB_SLAVE320
  ,psel320
  ,pready320
  ,prdata320
  `endif
  
  // Slave20 4 signals20
  `ifdef APB_SLAVE420
  ,psel420
  ,pready420
  ,prdata420
  `endif
  
  // Slave20 5 signals20
  `ifdef APB_SLAVE520
  ,psel520
  ,pready520
  ,prdata520
  `endif
  
  // Slave20 6 signals20
  `ifdef APB_SLAVE620
  ,psel620
  ,pready620
  ,prdata620
  `endif
  
  // Slave20 7 signals20
  `ifdef APB_SLAVE720
  ,psel720
  ,pready720
  ,prdata720
  `endif
  
  // Slave20 8 signals20
  `ifdef APB_SLAVE820
  ,psel820
  ,pready820
  ,prdata820
  `endif
  
  // Slave20 9 signals20
  `ifdef APB_SLAVE920
  ,psel920
  ,pready920
  ,prdata920
  `endif
  
  // Slave20 10 signals20
  `ifdef APB_SLAVE1020
  ,psel1020
  ,pready1020
  ,prdata1020
  `endif
  
  // Slave20 11 signals20
  `ifdef APB_SLAVE1120
  ,psel1120
  ,pready1120
  ,prdata1120
  `endif
  
  // Slave20 12 signals20
  `ifdef APB_SLAVE1220
  ,psel1220
  ,pready1220
  ,prdata1220
  `endif
  
  // Slave20 13 signals20
  `ifdef APB_SLAVE1320
  ,psel1320
  ,pready1320
  ,prdata1320
  `endif
  
  // Slave20 14 signals20
  `ifdef APB_SLAVE1420
  ,psel1420
  ,pready1420
  ,prdata1420
  `endif
  
  // Slave20 15 signals20
  `ifdef APB_SLAVE1520
  ,psel1520
  ,pready1520
  ,prdata1520
  `endif
  
);

parameter 
  APB_SLAVE0_START_ADDR20  = 32'h00000000,
  APB_SLAVE0_END_ADDR20    = 32'h00000000,
  APB_SLAVE1_START_ADDR20  = 32'h00000000,
  APB_SLAVE1_END_ADDR20    = 32'h00000000,
  APB_SLAVE2_START_ADDR20  = 32'h00000000,
  APB_SLAVE2_END_ADDR20    = 32'h00000000,
  APB_SLAVE3_START_ADDR20  = 32'h00000000,
  APB_SLAVE3_END_ADDR20    = 32'h00000000,
  APB_SLAVE4_START_ADDR20  = 32'h00000000,
  APB_SLAVE4_END_ADDR20    = 32'h00000000,
  APB_SLAVE5_START_ADDR20  = 32'h00000000,
  APB_SLAVE5_END_ADDR20    = 32'h00000000,
  APB_SLAVE6_START_ADDR20  = 32'h00000000,
  APB_SLAVE6_END_ADDR20    = 32'h00000000,
  APB_SLAVE7_START_ADDR20  = 32'h00000000,
  APB_SLAVE7_END_ADDR20    = 32'h00000000,
  APB_SLAVE8_START_ADDR20  = 32'h00000000,
  APB_SLAVE8_END_ADDR20    = 32'h00000000,
  APB_SLAVE9_START_ADDR20  = 32'h00000000,
  APB_SLAVE9_END_ADDR20    = 32'h00000000,
  APB_SLAVE10_START_ADDR20  = 32'h00000000,
  APB_SLAVE10_END_ADDR20    = 32'h00000000,
  APB_SLAVE11_START_ADDR20  = 32'h00000000,
  APB_SLAVE11_END_ADDR20    = 32'h00000000,
  APB_SLAVE12_START_ADDR20  = 32'h00000000,
  APB_SLAVE12_END_ADDR20    = 32'h00000000,
  APB_SLAVE13_START_ADDR20  = 32'h00000000,
  APB_SLAVE13_END_ADDR20    = 32'h00000000,
  APB_SLAVE14_START_ADDR20  = 32'h00000000,
  APB_SLAVE14_END_ADDR20    = 32'h00000000,
  APB_SLAVE15_START_ADDR20  = 32'h00000000,
  APB_SLAVE15_END_ADDR20    = 32'h00000000;

  // AHB20 signals20
input        hclk20;
input        hreset_n20;
input        hsel20;
input[31:0]  haddr20;
input[1:0]   htrans20;
input[31:0]  hwdata20;
input        hwrite20;
output[31:0] hrdata20;
reg   [31:0] hrdata20;
output       hready20;
output[1:0]  hresp20;
  
  // APB20 signals20 common to all APB20 slaves20
input       pclk20;
input       preset_n20;
output[31:0] paddr20;
reg   [31:0] paddr20;
output       penable20;
reg          penable20;
output       pwrite20;
reg          pwrite20;
output[31:0] pwdata20;
  
  // Slave20 0 signals20
`ifdef APB_SLAVE020
  output      psel020;
  input       pready020;
  input[31:0] prdata020;
`endif
  
  // Slave20 1 signals20
`ifdef APB_SLAVE120
  output      psel120;
  input       pready120;
  input[31:0] prdata120;
`endif
  
  // Slave20 2 signals20
`ifdef APB_SLAVE220
  output      psel220;
  input       pready220;
  input[31:0] prdata220;
`endif
  
  // Slave20 3 signals20
`ifdef APB_SLAVE320
  output      psel320;
  input       pready320;
  input[31:0] prdata320;
`endif
  
  // Slave20 4 signals20
`ifdef APB_SLAVE420
  output      psel420;
  input       pready420;
  input[31:0] prdata420;
`endif
  
  // Slave20 5 signals20
`ifdef APB_SLAVE520
  output      psel520;
  input       pready520;
  input[31:0] prdata520;
`endif
  
  // Slave20 6 signals20
`ifdef APB_SLAVE620
  output      psel620;
  input       pready620;
  input[31:0] prdata620;
`endif
  
  // Slave20 7 signals20
`ifdef APB_SLAVE720
  output      psel720;
  input       pready720;
  input[31:0] prdata720;
`endif
  
  // Slave20 8 signals20
`ifdef APB_SLAVE820
  output      psel820;
  input       pready820;
  input[31:0] prdata820;
`endif
  
  // Slave20 9 signals20
`ifdef APB_SLAVE920
  output      psel920;
  input       pready920;
  input[31:0] prdata920;
`endif
  
  // Slave20 10 signals20
`ifdef APB_SLAVE1020
  output      psel1020;
  input       pready1020;
  input[31:0] prdata1020;
`endif
  
  // Slave20 11 signals20
`ifdef APB_SLAVE1120
  output      psel1120;
  input       pready1120;
  input[31:0] prdata1120;
`endif
  
  // Slave20 12 signals20
`ifdef APB_SLAVE1220
  output      psel1220;
  input       pready1220;
  input[31:0] prdata1220;
`endif
  
  // Slave20 13 signals20
`ifdef APB_SLAVE1320
  output      psel1320;
  input       pready1320;
  input[31:0] prdata1320;
`endif
  
  // Slave20 14 signals20
`ifdef APB_SLAVE1420
  output      psel1420;
  input       pready1420;
  input[31:0] prdata1420;
`endif
  
  // Slave20 15 signals20
`ifdef APB_SLAVE1520
  output      psel1520;
  input       pready1520;
  input[31:0] prdata1520;
`endif
 
reg         ahb_addr_phase20;
reg         ahb_data_phase20;
wire        valid_ahb_trans20;
wire        pready_muxed20;
wire [31:0] prdata_muxed20;
reg  [31:0] haddr_reg20;
reg         hwrite_reg20;
reg  [2:0]  apb_state20;
wire [2:0]  apb_state_idle20;
wire [2:0]  apb_state_setup20;
wire [2:0]  apb_state_access20;
reg  [15:0] slave_select20;
wire [15:0] pready_vector20;
reg  [15:0] psel_vector20;
wire [31:0] prdata0_q20;
wire [31:0] prdata1_q20;
wire [31:0] prdata2_q20;
wire [31:0] prdata3_q20;
wire [31:0] prdata4_q20;
wire [31:0] prdata5_q20;
wire [31:0] prdata6_q20;
wire [31:0] prdata7_q20;
wire [31:0] prdata8_q20;
wire [31:0] prdata9_q20;
wire [31:0] prdata10_q20;
wire [31:0] prdata11_q20;
wire [31:0] prdata12_q20;
wire [31:0] prdata13_q20;
wire [31:0] prdata14_q20;
wire [31:0] prdata15_q20;

// assign pclk20     = hclk20;
// assign preset_n20 = hreset_n20;
assign hready20   = ahb_addr_phase20;
assign pwdata20   = hwdata20;
assign hresp20  = 2'b00;

// Respond20 to NONSEQ20 or SEQ transfers20
assign valid_ahb_trans20 = ((htrans20 == 2'b10) || (htrans20 == 2'b11)) && (hsel20 == 1'b1);

always @(posedge hclk20) begin
  if (hreset_n20 == 1'b0) begin
    ahb_addr_phase20 <= 1'b1;
    ahb_data_phase20 <= 1'b0;
    haddr_reg20      <= 'b0;
    hwrite_reg20     <= 1'b0;
    hrdata20         <= 'b0;
  end
  else begin
    if (ahb_addr_phase20 == 1'b1 && valid_ahb_trans20 == 1'b1) begin
      ahb_addr_phase20 <= 1'b0;
      ahb_data_phase20 <= 1'b1;
      haddr_reg20      <= haddr20;
      hwrite_reg20     <= hwrite20;
    end
    if (ahb_data_phase20 == 1'b1 && pready_muxed20 == 1'b1 && apb_state20 == apb_state_access20) begin
      ahb_addr_phase20 <= 1'b1;
      ahb_data_phase20 <= 1'b0;
      hrdata20         <= prdata_muxed20;
    end
  end
end

// APB20 state machine20 state definitions20
assign apb_state_idle20   = 3'b001;
assign apb_state_setup20  = 3'b010;
assign apb_state_access20 = 3'b100;

// APB20 state machine20
always @(posedge hclk20 or negedge hreset_n20) begin
  if (hreset_n20 == 1'b0) begin
    apb_state20   <= apb_state_idle20;
    psel_vector20 <= 1'b0;
    penable20     <= 1'b0;
    paddr20       <= 1'b0;
    pwrite20      <= 1'b0;
  end  
  else begin
    
    // IDLE20 -> SETUP20
    if (apb_state20 == apb_state_idle20) begin
      if (ahb_data_phase20 == 1'b1) begin
        apb_state20   <= apb_state_setup20;
        psel_vector20 <= slave_select20;
        paddr20       <= haddr_reg20;
        pwrite20      <= hwrite_reg20;
      end  
    end
    
    // SETUP20 -> TRANSFER20
    if (apb_state20 == apb_state_setup20) begin
      apb_state20 <= apb_state_access20;
      penable20   <= 1'b1;
    end
    
    // TRANSFER20 -> SETUP20 or
    // TRANSFER20 -> IDLE20
    if (apb_state20 == apb_state_access20) begin
      if (pready_muxed20 == 1'b1) begin
      
        // TRANSFER20 -> SETUP20
        if (valid_ahb_trans20 == 1'b1) begin
          apb_state20   <= apb_state_setup20;
          penable20     <= 1'b0;
          psel_vector20 <= slave_select20;
          paddr20       <= haddr_reg20;
          pwrite20      <= hwrite_reg20;
        end  
        
        // TRANSFER20 -> IDLE20
        else begin
          apb_state20   <= apb_state_idle20;      
          penable20     <= 1'b0;
          psel_vector20 <= 'b0;
        end  
      end
    end
    
  end
end

always @(posedge hclk20 or negedge hreset_n20) begin
  if (hreset_n20 == 1'b0)
    slave_select20 <= 'b0;
  else begin  
  `ifdef APB_SLAVE020
     slave_select20[0]   <= valid_ahb_trans20 && (haddr20 >= APB_SLAVE0_START_ADDR20)  && (haddr20 <= APB_SLAVE0_END_ADDR20);
   `else
     slave_select20[0]   <= 1'b0;
   `endif
   
   `ifdef APB_SLAVE120
     slave_select20[1]   <= valid_ahb_trans20 && (haddr20 >= APB_SLAVE1_START_ADDR20)  && (haddr20 <= APB_SLAVE1_END_ADDR20);
   `else
     slave_select20[1]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE220  
     slave_select20[2]   <= valid_ahb_trans20 && (haddr20 >= APB_SLAVE2_START_ADDR20)  && (haddr20 <= APB_SLAVE2_END_ADDR20);
   `else
     slave_select20[2]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE320  
     slave_select20[3]   <= valid_ahb_trans20 && (haddr20 >= APB_SLAVE3_START_ADDR20)  && (haddr20 <= APB_SLAVE3_END_ADDR20);
   `else
     slave_select20[3]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE420  
     slave_select20[4]   <= valid_ahb_trans20 && (haddr20 >= APB_SLAVE4_START_ADDR20)  && (haddr20 <= APB_SLAVE4_END_ADDR20);
   `else
     slave_select20[4]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE520  
     slave_select20[5]   <= valid_ahb_trans20 && (haddr20 >= APB_SLAVE5_START_ADDR20)  && (haddr20 <= APB_SLAVE5_END_ADDR20);
   `else
     slave_select20[5]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE620  
     slave_select20[6]   <= valid_ahb_trans20 && (haddr20 >= APB_SLAVE6_START_ADDR20)  && (haddr20 <= APB_SLAVE6_END_ADDR20);
   `else
     slave_select20[6]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE720  
     slave_select20[7]   <= valid_ahb_trans20 && (haddr20 >= APB_SLAVE7_START_ADDR20)  && (haddr20 <= APB_SLAVE7_END_ADDR20);
   `else
     slave_select20[7]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE820  
     slave_select20[8]   <= valid_ahb_trans20 && (haddr20 >= APB_SLAVE8_START_ADDR20)  && (haddr20 <= APB_SLAVE8_END_ADDR20);
   `else
     slave_select20[8]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE920  
     slave_select20[9]   <= valid_ahb_trans20 && (haddr20 >= APB_SLAVE9_START_ADDR20)  && (haddr20 <= APB_SLAVE9_END_ADDR20);
   `else
     slave_select20[9]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1020  
     slave_select20[10]  <= valid_ahb_trans20 && (haddr20 >= APB_SLAVE10_START_ADDR20) && (haddr20 <= APB_SLAVE10_END_ADDR20);
   `else
     slave_select20[10]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1120  
     slave_select20[11]  <= valid_ahb_trans20 && (haddr20 >= APB_SLAVE11_START_ADDR20) && (haddr20 <= APB_SLAVE11_END_ADDR20);
   `else
     slave_select20[11]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1220  
     slave_select20[12]  <= valid_ahb_trans20 && (haddr20 >= APB_SLAVE12_START_ADDR20) && (haddr20 <= APB_SLAVE12_END_ADDR20);
   `else
     slave_select20[12]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1320  
     slave_select20[13]  <= valid_ahb_trans20 && (haddr20 >= APB_SLAVE13_START_ADDR20) && (haddr20 <= APB_SLAVE13_END_ADDR20);
   `else
     slave_select20[13]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1420  
     slave_select20[14]  <= valid_ahb_trans20 && (haddr20 >= APB_SLAVE14_START_ADDR20) && (haddr20 <= APB_SLAVE14_END_ADDR20);
   `else
     slave_select20[14]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1520  
     slave_select20[15]  <= valid_ahb_trans20 && (haddr20 >= APB_SLAVE15_START_ADDR20) && (haddr20 <= APB_SLAVE15_END_ADDR20);
   `else
     slave_select20[15]   <= 1'b0;
   `endif  
  end
end

assign pready_muxed20 = |(psel_vector20 & pready_vector20);
assign prdata_muxed20 = prdata0_q20  | prdata1_q20  | prdata2_q20  | prdata3_q20  |
                      prdata4_q20  | prdata5_q20  | prdata6_q20  | prdata7_q20  |
                      prdata8_q20  | prdata9_q20  | prdata10_q20 | prdata11_q20 |
                      prdata12_q20 | prdata13_q20 | prdata14_q20 | prdata15_q20 ;

`ifdef APB_SLAVE020
  assign psel020            = psel_vector20[0];
  assign pready_vector20[0] = pready020;
  assign prdata0_q20        = (psel020 == 1'b1) ? prdata020 : 'b0;
`else
  assign pready_vector20[0] = 1'b0;
  assign prdata0_q20        = 'b0;
`endif

`ifdef APB_SLAVE120
  assign psel120            = psel_vector20[1];
  assign pready_vector20[1] = pready120;
  assign prdata1_q20        = (psel120 == 1'b1) ? prdata120 : 'b0;
`else
  assign pready_vector20[1] = 1'b0;
  assign prdata1_q20        = 'b0;
`endif

`ifdef APB_SLAVE220
  assign psel220            = psel_vector20[2];
  assign pready_vector20[2] = pready220;
  assign prdata2_q20        = (psel220 == 1'b1) ? prdata220 : 'b0;
`else
  assign pready_vector20[2] = 1'b0;
  assign prdata2_q20        = 'b0;
`endif

`ifdef APB_SLAVE320
  assign psel320            = psel_vector20[3];
  assign pready_vector20[3] = pready320;
  assign prdata3_q20        = (psel320 == 1'b1) ? prdata320 : 'b0;
`else
  assign pready_vector20[3] = 1'b0;
  assign prdata3_q20        = 'b0;
`endif

`ifdef APB_SLAVE420
  assign psel420            = psel_vector20[4];
  assign pready_vector20[4] = pready420;
  assign prdata4_q20        = (psel420 == 1'b1) ? prdata420 : 'b0;
`else
  assign pready_vector20[4] = 1'b0;
  assign prdata4_q20        = 'b0;
`endif

`ifdef APB_SLAVE520
  assign psel520            = psel_vector20[5];
  assign pready_vector20[5] = pready520;
  assign prdata5_q20        = (psel520 == 1'b1) ? prdata520 : 'b0;
`else
  assign pready_vector20[5] = 1'b0;
  assign prdata5_q20        = 'b0;
`endif

`ifdef APB_SLAVE620
  assign psel620            = psel_vector20[6];
  assign pready_vector20[6] = pready620;
  assign prdata6_q20        = (psel620 == 1'b1) ? prdata620 : 'b0;
`else
  assign pready_vector20[6] = 1'b0;
  assign prdata6_q20        = 'b0;
`endif

`ifdef APB_SLAVE720
  assign psel720            = psel_vector20[7];
  assign pready_vector20[7] = pready720;
  assign prdata7_q20        = (psel720 == 1'b1) ? prdata720 : 'b0;
`else
  assign pready_vector20[7] = 1'b0;
  assign prdata7_q20        = 'b0;
`endif

`ifdef APB_SLAVE820
  assign psel820            = psel_vector20[8];
  assign pready_vector20[8] = pready820;
  assign prdata8_q20        = (psel820 == 1'b1) ? prdata820 : 'b0;
`else
  assign pready_vector20[8] = 1'b0;
  assign prdata8_q20        = 'b0;
`endif

`ifdef APB_SLAVE920
  assign psel920            = psel_vector20[9];
  assign pready_vector20[9] = pready920;
  assign prdata9_q20        = (psel920 == 1'b1) ? prdata920 : 'b0;
`else
  assign pready_vector20[9] = 1'b0;
  assign prdata9_q20        = 'b0;
`endif

`ifdef APB_SLAVE1020
  assign psel1020            = psel_vector20[10];
  assign pready_vector20[10] = pready1020;
  assign prdata10_q20        = (psel1020 == 1'b1) ? prdata1020 : 'b0;
`else
  assign pready_vector20[10] = 1'b0;
  assign prdata10_q20        = 'b0;
`endif

`ifdef APB_SLAVE1120
  assign psel1120            = psel_vector20[11];
  assign pready_vector20[11] = pready1120;
  assign prdata11_q20        = (psel1120 == 1'b1) ? prdata1120 : 'b0;
`else
  assign pready_vector20[11] = 1'b0;
  assign prdata11_q20        = 'b0;
`endif

`ifdef APB_SLAVE1220
  assign psel1220            = psel_vector20[12];
  assign pready_vector20[12] = pready1220;
  assign prdata12_q20        = (psel1220 == 1'b1) ? prdata1220 : 'b0;
`else
  assign pready_vector20[12] = 1'b0;
  assign prdata12_q20        = 'b0;
`endif

`ifdef APB_SLAVE1320
  assign psel1320            = psel_vector20[13];
  assign pready_vector20[13] = pready1320;
  assign prdata13_q20        = (psel1320 == 1'b1) ? prdata1320 : 'b0;
`else
  assign pready_vector20[13] = 1'b0;
  assign prdata13_q20        = 'b0;
`endif

`ifdef APB_SLAVE1420
  assign psel1420            = psel_vector20[14];
  assign pready_vector20[14] = pready1420;
  assign prdata14_q20        = (psel1420 == 1'b1) ? prdata1420 : 'b0;
`else
  assign pready_vector20[14] = 1'b0;
  assign prdata14_q20        = 'b0;
`endif

`ifdef APB_SLAVE1520
  assign psel1520            = psel_vector20[15];
  assign pready_vector20[15] = pready1520;
  assign prdata15_q20        = (psel1520 == 1'b1) ? prdata1520 : 'b0;
`else
  assign pready_vector20[15] = 1'b0;
  assign prdata15_q20        = 'b0;
`endif

endmodule
