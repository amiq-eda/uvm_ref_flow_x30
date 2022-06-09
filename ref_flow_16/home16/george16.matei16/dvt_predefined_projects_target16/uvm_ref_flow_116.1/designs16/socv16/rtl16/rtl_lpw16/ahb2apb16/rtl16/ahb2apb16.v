//File16 name   : ahb2apb16.v
//Title16       : 
//Created16     : 2010
//Description16 : Simple16 AHB16 to APB16 bridge16
//Notes16       : 
//----------------------------------------------------------------------
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------

`timescale 1ns/1ps

`include "ahb2apb_defines16.v"

module ahb2apb16
(
  // AHB16 signals16
  hclk16,
  hreset_n16,
  hsel16,
  haddr16,
  htrans16,
  hwdata16,
  hwrite16,
  hrdata16,
  hready16,
  hresp16,
  
  // APB16 signals16 common to all APB16 slaves16
  pclk16,
  preset_n16,
  paddr16,
  penable16,
  pwrite16,
  pwdata16
  
  // Slave16 0 signals16
  `ifdef APB_SLAVE016
  ,psel016
  ,pready016
  ,prdata016
  `endif
  
  // Slave16 1 signals16
  `ifdef APB_SLAVE116
  ,psel116
  ,pready116
  ,prdata116
  `endif
  
  // Slave16 2 signals16
  `ifdef APB_SLAVE216
  ,psel216
  ,pready216
  ,prdata216
  `endif
  
  // Slave16 3 signals16
  `ifdef APB_SLAVE316
  ,psel316
  ,pready316
  ,prdata316
  `endif
  
  // Slave16 4 signals16
  `ifdef APB_SLAVE416
  ,psel416
  ,pready416
  ,prdata416
  `endif
  
  // Slave16 5 signals16
  `ifdef APB_SLAVE516
  ,psel516
  ,pready516
  ,prdata516
  `endif
  
  // Slave16 6 signals16
  `ifdef APB_SLAVE616
  ,psel616
  ,pready616
  ,prdata616
  `endif
  
  // Slave16 7 signals16
  `ifdef APB_SLAVE716
  ,psel716
  ,pready716
  ,prdata716
  `endif
  
  // Slave16 8 signals16
  `ifdef APB_SLAVE816
  ,psel816
  ,pready816
  ,prdata816
  `endif
  
  // Slave16 9 signals16
  `ifdef APB_SLAVE916
  ,psel916
  ,pready916
  ,prdata916
  `endif
  
  // Slave16 10 signals16
  `ifdef APB_SLAVE1016
  ,psel1016
  ,pready1016
  ,prdata1016
  `endif
  
  // Slave16 11 signals16
  `ifdef APB_SLAVE1116
  ,psel1116
  ,pready1116
  ,prdata1116
  `endif
  
  // Slave16 12 signals16
  `ifdef APB_SLAVE1216
  ,psel1216
  ,pready1216
  ,prdata1216
  `endif
  
  // Slave16 13 signals16
  `ifdef APB_SLAVE1316
  ,psel1316
  ,pready1316
  ,prdata1316
  `endif
  
  // Slave16 14 signals16
  `ifdef APB_SLAVE1416
  ,psel1416
  ,pready1416
  ,prdata1416
  `endif
  
  // Slave16 15 signals16
  `ifdef APB_SLAVE1516
  ,psel1516
  ,pready1516
  ,prdata1516
  `endif
  
);

parameter 
  APB_SLAVE0_START_ADDR16  = 32'h00000000,
  APB_SLAVE0_END_ADDR16    = 32'h00000000,
  APB_SLAVE1_START_ADDR16  = 32'h00000000,
  APB_SLAVE1_END_ADDR16    = 32'h00000000,
  APB_SLAVE2_START_ADDR16  = 32'h00000000,
  APB_SLAVE2_END_ADDR16    = 32'h00000000,
  APB_SLAVE3_START_ADDR16  = 32'h00000000,
  APB_SLAVE3_END_ADDR16    = 32'h00000000,
  APB_SLAVE4_START_ADDR16  = 32'h00000000,
  APB_SLAVE4_END_ADDR16    = 32'h00000000,
  APB_SLAVE5_START_ADDR16  = 32'h00000000,
  APB_SLAVE5_END_ADDR16    = 32'h00000000,
  APB_SLAVE6_START_ADDR16  = 32'h00000000,
  APB_SLAVE6_END_ADDR16    = 32'h00000000,
  APB_SLAVE7_START_ADDR16  = 32'h00000000,
  APB_SLAVE7_END_ADDR16    = 32'h00000000,
  APB_SLAVE8_START_ADDR16  = 32'h00000000,
  APB_SLAVE8_END_ADDR16    = 32'h00000000,
  APB_SLAVE9_START_ADDR16  = 32'h00000000,
  APB_SLAVE9_END_ADDR16    = 32'h00000000,
  APB_SLAVE10_START_ADDR16  = 32'h00000000,
  APB_SLAVE10_END_ADDR16    = 32'h00000000,
  APB_SLAVE11_START_ADDR16  = 32'h00000000,
  APB_SLAVE11_END_ADDR16    = 32'h00000000,
  APB_SLAVE12_START_ADDR16  = 32'h00000000,
  APB_SLAVE12_END_ADDR16    = 32'h00000000,
  APB_SLAVE13_START_ADDR16  = 32'h00000000,
  APB_SLAVE13_END_ADDR16    = 32'h00000000,
  APB_SLAVE14_START_ADDR16  = 32'h00000000,
  APB_SLAVE14_END_ADDR16    = 32'h00000000,
  APB_SLAVE15_START_ADDR16  = 32'h00000000,
  APB_SLAVE15_END_ADDR16    = 32'h00000000;

  // AHB16 signals16
input        hclk16;
input        hreset_n16;
input        hsel16;
input[31:0]  haddr16;
input[1:0]   htrans16;
input[31:0]  hwdata16;
input        hwrite16;
output[31:0] hrdata16;
reg   [31:0] hrdata16;
output       hready16;
output[1:0]  hresp16;
  
  // APB16 signals16 common to all APB16 slaves16
input       pclk16;
input       preset_n16;
output[31:0] paddr16;
reg   [31:0] paddr16;
output       penable16;
reg          penable16;
output       pwrite16;
reg          pwrite16;
output[31:0] pwdata16;
  
  // Slave16 0 signals16
`ifdef APB_SLAVE016
  output      psel016;
  input       pready016;
  input[31:0] prdata016;
`endif
  
  // Slave16 1 signals16
`ifdef APB_SLAVE116
  output      psel116;
  input       pready116;
  input[31:0] prdata116;
`endif
  
  // Slave16 2 signals16
`ifdef APB_SLAVE216
  output      psel216;
  input       pready216;
  input[31:0] prdata216;
`endif
  
  // Slave16 3 signals16
`ifdef APB_SLAVE316
  output      psel316;
  input       pready316;
  input[31:0] prdata316;
`endif
  
  // Slave16 4 signals16
`ifdef APB_SLAVE416
  output      psel416;
  input       pready416;
  input[31:0] prdata416;
`endif
  
  // Slave16 5 signals16
`ifdef APB_SLAVE516
  output      psel516;
  input       pready516;
  input[31:0] prdata516;
`endif
  
  // Slave16 6 signals16
`ifdef APB_SLAVE616
  output      psel616;
  input       pready616;
  input[31:0] prdata616;
`endif
  
  // Slave16 7 signals16
`ifdef APB_SLAVE716
  output      psel716;
  input       pready716;
  input[31:0] prdata716;
`endif
  
  // Slave16 8 signals16
`ifdef APB_SLAVE816
  output      psel816;
  input       pready816;
  input[31:0] prdata816;
`endif
  
  // Slave16 9 signals16
`ifdef APB_SLAVE916
  output      psel916;
  input       pready916;
  input[31:0] prdata916;
`endif
  
  // Slave16 10 signals16
`ifdef APB_SLAVE1016
  output      psel1016;
  input       pready1016;
  input[31:0] prdata1016;
`endif
  
  // Slave16 11 signals16
`ifdef APB_SLAVE1116
  output      psel1116;
  input       pready1116;
  input[31:0] prdata1116;
`endif
  
  // Slave16 12 signals16
`ifdef APB_SLAVE1216
  output      psel1216;
  input       pready1216;
  input[31:0] prdata1216;
`endif
  
  // Slave16 13 signals16
`ifdef APB_SLAVE1316
  output      psel1316;
  input       pready1316;
  input[31:0] prdata1316;
`endif
  
  // Slave16 14 signals16
`ifdef APB_SLAVE1416
  output      psel1416;
  input       pready1416;
  input[31:0] prdata1416;
`endif
  
  // Slave16 15 signals16
`ifdef APB_SLAVE1516
  output      psel1516;
  input       pready1516;
  input[31:0] prdata1516;
`endif
 
reg         ahb_addr_phase16;
reg         ahb_data_phase16;
wire        valid_ahb_trans16;
wire        pready_muxed16;
wire [31:0] prdata_muxed16;
reg  [31:0] haddr_reg16;
reg         hwrite_reg16;
reg  [2:0]  apb_state16;
wire [2:0]  apb_state_idle16;
wire [2:0]  apb_state_setup16;
wire [2:0]  apb_state_access16;
reg  [15:0] slave_select16;
wire [15:0] pready_vector16;
reg  [15:0] psel_vector16;
wire [31:0] prdata0_q16;
wire [31:0] prdata1_q16;
wire [31:0] prdata2_q16;
wire [31:0] prdata3_q16;
wire [31:0] prdata4_q16;
wire [31:0] prdata5_q16;
wire [31:0] prdata6_q16;
wire [31:0] prdata7_q16;
wire [31:0] prdata8_q16;
wire [31:0] prdata9_q16;
wire [31:0] prdata10_q16;
wire [31:0] prdata11_q16;
wire [31:0] prdata12_q16;
wire [31:0] prdata13_q16;
wire [31:0] prdata14_q16;
wire [31:0] prdata15_q16;

// assign pclk16     = hclk16;
// assign preset_n16 = hreset_n16;
assign hready16   = ahb_addr_phase16;
assign pwdata16   = hwdata16;
assign hresp16  = 2'b00;

// Respond16 to NONSEQ16 or SEQ transfers16
assign valid_ahb_trans16 = ((htrans16 == 2'b10) || (htrans16 == 2'b11)) && (hsel16 == 1'b1);

always @(posedge hclk16) begin
  if (hreset_n16 == 1'b0) begin
    ahb_addr_phase16 <= 1'b1;
    ahb_data_phase16 <= 1'b0;
    haddr_reg16      <= 'b0;
    hwrite_reg16     <= 1'b0;
    hrdata16         <= 'b0;
  end
  else begin
    if (ahb_addr_phase16 == 1'b1 && valid_ahb_trans16 == 1'b1) begin
      ahb_addr_phase16 <= 1'b0;
      ahb_data_phase16 <= 1'b1;
      haddr_reg16      <= haddr16;
      hwrite_reg16     <= hwrite16;
    end
    if (ahb_data_phase16 == 1'b1 && pready_muxed16 == 1'b1 && apb_state16 == apb_state_access16) begin
      ahb_addr_phase16 <= 1'b1;
      ahb_data_phase16 <= 1'b0;
      hrdata16         <= prdata_muxed16;
    end
  end
end

// APB16 state machine16 state definitions16
assign apb_state_idle16   = 3'b001;
assign apb_state_setup16  = 3'b010;
assign apb_state_access16 = 3'b100;

// APB16 state machine16
always @(posedge hclk16 or negedge hreset_n16) begin
  if (hreset_n16 == 1'b0) begin
    apb_state16   <= apb_state_idle16;
    psel_vector16 <= 1'b0;
    penable16     <= 1'b0;
    paddr16       <= 1'b0;
    pwrite16      <= 1'b0;
  end  
  else begin
    
    // IDLE16 -> SETUP16
    if (apb_state16 == apb_state_idle16) begin
      if (ahb_data_phase16 == 1'b1) begin
        apb_state16   <= apb_state_setup16;
        psel_vector16 <= slave_select16;
        paddr16       <= haddr_reg16;
        pwrite16      <= hwrite_reg16;
      end  
    end
    
    // SETUP16 -> TRANSFER16
    if (apb_state16 == apb_state_setup16) begin
      apb_state16 <= apb_state_access16;
      penable16   <= 1'b1;
    end
    
    // TRANSFER16 -> SETUP16 or
    // TRANSFER16 -> IDLE16
    if (apb_state16 == apb_state_access16) begin
      if (pready_muxed16 == 1'b1) begin
      
        // TRANSFER16 -> SETUP16
        if (valid_ahb_trans16 == 1'b1) begin
          apb_state16   <= apb_state_setup16;
          penable16     <= 1'b0;
          psel_vector16 <= slave_select16;
          paddr16       <= haddr_reg16;
          pwrite16      <= hwrite_reg16;
        end  
        
        // TRANSFER16 -> IDLE16
        else begin
          apb_state16   <= apb_state_idle16;      
          penable16     <= 1'b0;
          psel_vector16 <= 'b0;
        end  
      end
    end
    
  end
end

always @(posedge hclk16 or negedge hreset_n16) begin
  if (hreset_n16 == 1'b0)
    slave_select16 <= 'b0;
  else begin  
  `ifdef APB_SLAVE016
     slave_select16[0]   <= valid_ahb_trans16 && (haddr16 >= APB_SLAVE0_START_ADDR16)  && (haddr16 <= APB_SLAVE0_END_ADDR16);
   `else
     slave_select16[0]   <= 1'b0;
   `endif
   
   `ifdef APB_SLAVE116
     slave_select16[1]   <= valid_ahb_trans16 && (haddr16 >= APB_SLAVE1_START_ADDR16)  && (haddr16 <= APB_SLAVE1_END_ADDR16);
   `else
     slave_select16[1]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE216  
     slave_select16[2]   <= valid_ahb_trans16 && (haddr16 >= APB_SLAVE2_START_ADDR16)  && (haddr16 <= APB_SLAVE2_END_ADDR16);
   `else
     slave_select16[2]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE316  
     slave_select16[3]   <= valid_ahb_trans16 && (haddr16 >= APB_SLAVE3_START_ADDR16)  && (haddr16 <= APB_SLAVE3_END_ADDR16);
   `else
     slave_select16[3]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE416  
     slave_select16[4]   <= valid_ahb_trans16 && (haddr16 >= APB_SLAVE4_START_ADDR16)  && (haddr16 <= APB_SLAVE4_END_ADDR16);
   `else
     slave_select16[4]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE516  
     slave_select16[5]   <= valid_ahb_trans16 && (haddr16 >= APB_SLAVE5_START_ADDR16)  && (haddr16 <= APB_SLAVE5_END_ADDR16);
   `else
     slave_select16[5]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE616  
     slave_select16[6]   <= valid_ahb_trans16 && (haddr16 >= APB_SLAVE6_START_ADDR16)  && (haddr16 <= APB_SLAVE6_END_ADDR16);
   `else
     slave_select16[6]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE716  
     slave_select16[7]   <= valid_ahb_trans16 && (haddr16 >= APB_SLAVE7_START_ADDR16)  && (haddr16 <= APB_SLAVE7_END_ADDR16);
   `else
     slave_select16[7]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE816  
     slave_select16[8]   <= valid_ahb_trans16 && (haddr16 >= APB_SLAVE8_START_ADDR16)  && (haddr16 <= APB_SLAVE8_END_ADDR16);
   `else
     slave_select16[8]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE916  
     slave_select16[9]   <= valid_ahb_trans16 && (haddr16 >= APB_SLAVE9_START_ADDR16)  && (haddr16 <= APB_SLAVE9_END_ADDR16);
   `else
     slave_select16[9]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1016  
     slave_select16[10]  <= valid_ahb_trans16 && (haddr16 >= APB_SLAVE10_START_ADDR16) && (haddr16 <= APB_SLAVE10_END_ADDR16);
   `else
     slave_select16[10]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1116  
     slave_select16[11]  <= valid_ahb_trans16 && (haddr16 >= APB_SLAVE11_START_ADDR16) && (haddr16 <= APB_SLAVE11_END_ADDR16);
   `else
     slave_select16[11]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1216  
     slave_select16[12]  <= valid_ahb_trans16 && (haddr16 >= APB_SLAVE12_START_ADDR16) && (haddr16 <= APB_SLAVE12_END_ADDR16);
   `else
     slave_select16[12]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1316  
     slave_select16[13]  <= valid_ahb_trans16 && (haddr16 >= APB_SLAVE13_START_ADDR16) && (haddr16 <= APB_SLAVE13_END_ADDR16);
   `else
     slave_select16[13]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1416  
     slave_select16[14]  <= valid_ahb_trans16 && (haddr16 >= APB_SLAVE14_START_ADDR16) && (haddr16 <= APB_SLAVE14_END_ADDR16);
   `else
     slave_select16[14]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1516  
     slave_select16[15]  <= valid_ahb_trans16 && (haddr16 >= APB_SLAVE15_START_ADDR16) && (haddr16 <= APB_SLAVE15_END_ADDR16);
   `else
     slave_select16[15]   <= 1'b0;
   `endif  
  end
end

assign pready_muxed16 = |(psel_vector16 & pready_vector16);
assign prdata_muxed16 = prdata0_q16  | prdata1_q16  | prdata2_q16  | prdata3_q16  |
                      prdata4_q16  | prdata5_q16  | prdata6_q16  | prdata7_q16  |
                      prdata8_q16  | prdata9_q16  | prdata10_q16 | prdata11_q16 |
                      prdata12_q16 | prdata13_q16 | prdata14_q16 | prdata15_q16 ;

`ifdef APB_SLAVE016
  assign psel016            = psel_vector16[0];
  assign pready_vector16[0] = pready016;
  assign prdata0_q16        = (psel016 == 1'b1) ? prdata016 : 'b0;
`else
  assign pready_vector16[0] = 1'b0;
  assign prdata0_q16        = 'b0;
`endif

`ifdef APB_SLAVE116
  assign psel116            = psel_vector16[1];
  assign pready_vector16[1] = pready116;
  assign prdata1_q16        = (psel116 == 1'b1) ? prdata116 : 'b0;
`else
  assign pready_vector16[1] = 1'b0;
  assign prdata1_q16        = 'b0;
`endif

`ifdef APB_SLAVE216
  assign psel216            = psel_vector16[2];
  assign pready_vector16[2] = pready216;
  assign prdata2_q16        = (psel216 == 1'b1) ? prdata216 : 'b0;
`else
  assign pready_vector16[2] = 1'b0;
  assign prdata2_q16        = 'b0;
`endif

`ifdef APB_SLAVE316
  assign psel316            = psel_vector16[3];
  assign pready_vector16[3] = pready316;
  assign prdata3_q16        = (psel316 == 1'b1) ? prdata316 : 'b0;
`else
  assign pready_vector16[3] = 1'b0;
  assign prdata3_q16        = 'b0;
`endif

`ifdef APB_SLAVE416
  assign psel416            = psel_vector16[4];
  assign pready_vector16[4] = pready416;
  assign prdata4_q16        = (psel416 == 1'b1) ? prdata416 : 'b0;
`else
  assign pready_vector16[4] = 1'b0;
  assign prdata4_q16        = 'b0;
`endif

`ifdef APB_SLAVE516
  assign psel516            = psel_vector16[5];
  assign pready_vector16[5] = pready516;
  assign prdata5_q16        = (psel516 == 1'b1) ? prdata516 : 'b0;
`else
  assign pready_vector16[5] = 1'b0;
  assign prdata5_q16        = 'b0;
`endif

`ifdef APB_SLAVE616
  assign psel616            = psel_vector16[6];
  assign pready_vector16[6] = pready616;
  assign prdata6_q16        = (psel616 == 1'b1) ? prdata616 : 'b0;
`else
  assign pready_vector16[6] = 1'b0;
  assign prdata6_q16        = 'b0;
`endif

`ifdef APB_SLAVE716
  assign psel716            = psel_vector16[7];
  assign pready_vector16[7] = pready716;
  assign prdata7_q16        = (psel716 == 1'b1) ? prdata716 : 'b0;
`else
  assign pready_vector16[7] = 1'b0;
  assign prdata7_q16        = 'b0;
`endif

`ifdef APB_SLAVE816
  assign psel816            = psel_vector16[8];
  assign pready_vector16[8] = pready816;
  assign prdata8_q16        = (psel816 == 1'b1) ? prdata816 : 'b0;
`else
  assign pready_vector16[8] = 1'b0;
  assign prdata8_q16        = 'b0;
`endif

`ifdef APB_SLAVE916
  assign psel916            = psel_vector16[9];
  assign pready_vector16[9] = pready916;
  assign prdata9_q16        = (psel916 == 1'b1) ? prdata916 : 'b0;
`else
  assign pready_vector16[9] = 1'b0;
  assign prdata9_q16        = 'b0;
`endif

`ifdef APB_SLAVE1016
  assign psel1016            = psel_vector16[10];
  assign pready_vector16[10] = pready1016;
  assign prdata10_q16        = (psel1016 == 1'b1) ? prdata1016 : 'b0;
`else
  assign pready_vector16[10] = 1'b0;
  assign prdata10_q16        = 'b0;
`endif

`ifdef APB_SLAVE1116
  assign psel1116            = psel_vector16[11];
  assign pready_vector16[11] = pready1116;
  assign prdata11_q16        = (psel1116 == 1'b1) ? prdata1116 : 'b0;
`else
  assign pready_vector16[11] = 1'b0;
  assign prdata11_q16        = 'b0;
`endif

`ifdef APB_SLAVE1216
  assign psel1216            = psel_vector16[12];
  assign pready_vector16[12] = pready1216;
  assign prdata12_q16        = (psel1216 == 1'b1) ? prdata1216 : 'b0;
`else
  assign pready_vector16[12] = 1'b0;
  assign prdata12_q16        = 'b0;
`endif

`ifdef APB_SLAVE1316
  assign psel1316            = psel_vector16[13];
  assign pready_vector16[13] = pready1316;
  assign prdata13_q16        = (psel1316 == 1'b1) ? prdata1316 : 'b0;
`else
  assign pready_vector16[13] = 1'b0;
  assign prdata13_q16        = 'b0;
`endif

`ifdef APB_SLAVE1416
  assign psel1416            = psel_vector16[14];
  assign pready_vector16[14] = pready1416;
  assign prdata14_q16        = (psel1416 == 1'b1) ? prdata1416 : 'b0;
`else
  assign pready_vector16[14] = 1'b0;
  assign prdata14_q16        = 'b0;
`endif

`ifdef APB_SLAVE1516
  assign psel1516            = psel_vector16[15];
  assign pready_vector16[15] = pready1516;
  assign prdata15_q16        = (psel1516 == 1'b1) ? prdata1516 : 'b0;
`else
  assign pready_vector16[15] = 1'b0;
  assign prdata15_q16        = 'b0;
`endif

endmodule
