//File14 name   : ahb2apb14.v
//Title14       : 
//Created14     : 2010
//Description14 : Simple14 AHB14 to APB14 bridge14
//Notes14       : 
//----------------------------------------------------------------------
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------

`timescale 1ns/1ps

`include "ahb2apb_defines14.v"

module ahb2apb14
(
  // AHB14 signals14
  hclk14,
  hreset_n14,
  hsel14,
  haddr14,
  htrans14,
  hwdata14,
  hwrite14,
  hrdata14,
  hready14,
  hresp14,
  
  // APB14 signals14 common to all APB14 slaves14
  pclk14,
  preset_n14,
  paddr14,
  penable14,
  pwrite14,
  pwdata14
  
  // Slave14 0 signals14
  `ifdef APB_SLAVE014
  ,psel014
  ,pready014
  ,prdata014
  `endif
  
  // Slave14 1 signals14
  `ifdef APB_SLAVE114
  ,psel114
  ,pready114
  ,prdata114
  `endif
  
  // Slave14 2 signals14
  `ifdef APB_SLAVE214
  ,psel214
  ,pready214
  ,prdata214
  `endif
  
  // Slave14 3 signals14
  `ifdef APB_SLAVE314
  ,psel314
  ,pready314
  ,prdata314
  `endif
  
  // Slave14 4 signals14
  `ifdef APB_SLAVE414
  ,psel414
  ,pready414
  ,prdata414
  `endif
  
  // Slave14 5 signals14
  `ifdef APB_SLAVE514
  ,psel514
  ,pready514
  ,prdata514
  `endif
  
  // Slave14 6 signals14
  `ifdef APB_SLAVE614
  ,psel614
  ,pready614
  ,prdata614
  `endif
  
  // Slave14 7 signals14
  `ifdef APB_SLAVE714
  ,psel714
  ,pready714
  ,prdata714
  `endif
  
  // Slave14 8 signals14
  `ifdef APB_SLAVE814
  ,psel814
  ,pready814
  ,prdata814
  `endif
  
  // Slave14 9 signals14
  `ifdef APB_SLAVE914
  ,psel914
  ,pready914
  ,prdata914
  `endif
  
  // Slave14 10 signals14
  `ifdef APB_SLAVE1014
  ,psel1014
  ,pready1014
  ,prdata1014
  `endif
  
  // Slave14 11 signals14
  `ifdef APB_SLAVE1114
  ,psel1114
  ,pready1114
  ,prdata1114
  `endif
  
  // Slave14 12 signals14
  `ifdef APB_SLAVE1214
  ,psel1214
  ,pready1214
  ,prdata1214
  `endif
  
  // Slave14 13 signals14
  `ifdef APB_SLAVE1314
  ,psel1314
  ,pready1314
  ,prdata1314
  `endif
  
  // Slave14 14 signals14
  `ifdef APB_SLAVE1414
  ,psel1414
  ,pready1414
  ,prdata1414
  `endif
  
  // Slave14 15 signals14
  `ifdef APB_SLAVE1514
  ,psel1514
  ,pready1514
  ,prdata1514
  `endif
  
);

parameter 
  APB_SLAVE0_START_ADDR14  = 32'h00000000,
  APB_SLAVE0_END_ADDR14    = 32'h00000000,
  APB_SLAVE1_START_ADDR14  = 32'h00000000,
  APB_SLAVE1_END_ADDR14    = 32'h00000000,
  APB_SLAVE2_START_ADDR14  = 32'h00000000,
  APB_SLAVE2_END_ADDR14    = 32'h00000000,
  APB_SLAVE3_START_ADDR14  = 32'h00000000,
  APB_SLAVE3_END_ADDR14    = 32'h00000000,
  APB_SLAVE4_START_ADDR14  = 32'h00000000,
  APB_SLAVE4_END_ADDR14    = 32'h00000000,
  APB_SLAVE5_START_ADDR14  = 32'h00000000,
  APB_SLAVE5_END_ADDR14    = 32'h00000000,
  APB_SLAVE6_START_ADDR14  = 32'h00000000,
  APB_SLAVE6_END_ADDR14    = 32'h00000000,
  APB_SLAVE7_START_ADDR14  = 32'h00000000,
  APB_SLAVE7_END_ADDR14    = 32'h00000000,
  APB_SLAVE8_START_ADDR14  = 32'h00000000,
  APB_SLAVE8_END_ADDR14    = 32'h00000000,
  APB_SLAVE9_START_ADDR14  = 32'h00000000,
  APB_SLAVE9_END_ADDR14    = 32'h00000000,
  APB_SLAVE10_START_ADDR14  = 32'h00000000,
  APB_SLAVE10_END_ADDR14    = 32'h00000000,
  APB_SLAVE11_START_ADDR14  = 32'h00000000,
  APB_SLAVE11_END_ADDR14    = 32'h00000000,
  APB_SLAVE12_START_ADDR14  = 32'h00000000,
  APB_SLAVE12_END_ADDR14    = 32'h00000000,
  APB_SLAVE13_START_ADDR14  = 32'h00000000,
  APB_SLAVE13_END_ADDR14    = 32'h00000000,
  APB_SLAVE14_START_ADDR14  = 32'h00000000,
  APB_SLAVE14_END_ADDR14    = 32'h00000000,
  APB_SLAVE15_START_ADDR14  = 32'h00000000,
  APB_SLAVE15_END_ADDR14    = 32'h00000000;

  // AHB14 signals14
input        hclk14;
input        hreset_n14;
input        hsel14;
input[31:0]  haddr14;
input[1:0]   htrans14;
input[31:0]  hwdata14;
input        hwrite14;
output[31:0] hrdata14;
reg   [31:0] hrdata14;
output       hready14;
output[1:0]  hresp14;
  
  // APB14 signals14 common to all APB14 slaves14
input       pclk14;
input       preset_n14;
output[31:0] paddr14;
reg   [31:0] paddr14;
output       penable14;
reg          penable14;
output       pwrite14;
reg          pwrite14;
output[31:0] pwdata14;
  
  // Slave14 0 signals14
`ifdef APB_SLAVE014
  output      psel014;
  input       pready014;
  input[31:0] prdata014;
`endif
  
  // Slave14 1 signals14
`ifdef APB_SLAVE114
  output      psel114;
  input       pready114;
  input[31:0] prdata114;
`endif
  
  // Slave14 2 signals14
`ifdef APB_SLAVE214
  output      psel214;
  input       pready214;
  input[31:0] prdata214;
`endif
  
  // Slave14 3 signals14
`ifdef APB_SLAVE314
  output      psel314;
  input       pready314;
  input[31:0] prdata314;
`endif
  
  // Slave14 4 signals14
`ifdef APB_SLAVE414
  output      psel414;
  input       pready414;
  input[31:0] prdata414;
`endif
  
  // Slave14 5 signals14
`ifdef APB_SLAVE514
  output      psel514;
  input       pready514;
  input[31:0] prdata514;
`endif
  
  // Slave14 6 signals14
`ifdef APB_SLAVE614
  output      psel614;
  input       pready614;
  input[31:0] prdata614;
`endif
  
  // Slave14 7 signals14
`ifdef APB_SLAVE714
  output      psel714;
  input       pready714;
  input[31:0] prdata714;
`endif
  
  // Slave14 8 signals14
`ifdef APB_SLAVE814
  output      psel814;
  input       pready814;
  input[31:0] prdata814;
`endif
  
  // Slave14 9 signals14
`ifdef APB_SLAVE914
  output      psel914;
  input       pready914;
  input[31:0] prdata914;
`endif
  
  // Slave14 10 signals14
`ifdef APB_SLAVE1014
  output      psel1014;
  input       pready1014;
  input[31:0] prdata1014;
`endif
  
  // Slave14 11 signals14
`ifdef APB_SLAVE1114
  output      psel1114;
  input       pready1114;
  input[31:0] prdata1114;
`endif
  
  // Slave14 12 signals14
`ifdef APB_SLAVE1214
  output      psel1214;
  input       pready1214;
  input[31:0] prdata1214;
`endif
  
  // Slave14 13 signals14
`ifdef APB_SLAVE1314
  output      psel1314;
  input       pready1314;
  input[31:0] prdata1314;
`endif
  
  // Slave14 14 signals14
`ifdef APB_SLAVE1414
  output      psel1414;
  input       pready1414;
  input[31:0] prdata1414;
`endif
  
  // Slave14 15 signals14
`ifdef APB_SLAVE1514
  output      psel1514;
  input       pready1514;
  input[31:0] prdata1514;
`endif
 
reg         ahb_addr_phase14;
reg         ahb_data_phase14;
wire        valid_ahb_trans14;
wire        pready_muxed14;
wire [31:0] prdata_muxed14;
reg  [31:0] haddr_reg14;
reg         hwrite_reg14;
reg  [2:0]  apb_state14;
wire [2:0]  apb_state_idle14;
wire [2:0]  apb_state_setup14;
wire [2:0]  apb_state_access14;
reg  [15:0] slave_select14;
wire [15:0] pready_vector14;
reg  [15:0] psel_vector14;
wire [31:0] prdata0_q14;
wire [31:0] prdata1_q14;
wire [31:0] prdata2_q14;
wire [31:0] prdata3_q14;
wire [31:0] prdata4_q14;
wire [31:0] prdata5_q14;
wire [31:0] prdata6_q14;
wire [31:0] prdata7_q14;
wire [31:0] prdata8_q14;
wire [31:0] prdata9_q14;
wire [31:0] prdata10_q14;
wire [31:0] prdata11_q14;
wire [31:0] prdata12_q14;
wire [31:0] prdata13_q14;
wire [31:0] prdata14_q14;
wire [31:0] prdata15_q14;

// assign pclk14     = hclk14;
// assign preset_n14 = hreset_n14;
assign hready14   = ahb_addr_phase14;
assign pwdata14   = hwdata14;
assign hresp14  = 2'b00;

// Respond14 to NONSEQ14 or SEQ transfers14
assign valid_ahb_trans14 = ((htrans14 == 2'b10) || (htrans14 == 2'b11)) && (hsel14 == 1'b1);

always @(posedge hclk14) begin
  if (hreset_n14 == 1'b0) begin
    ahb_addr_phase14 <= 1'b1;
    ahb_data_phase14 <= 1'b0;
    haddr_reg14      <= 'b0;
    hwrite_reg14     <= 1'b0;
    hrdata14         <= 'b0;
  end
  else begin
    if (ahb_addr_phase14 == 1'b1 && valid_ahb_trans14 == 1'b1) begin
      ahb_addr_phase14 <= 1'b0;
      ahb_data_phase14 <= 1'b1;
      haddr_reg14      <= haddr14;
      hwrite_reg14     <= hwrite14;
    end
    if (ahb_data_phase14 == 1'b1 && pready_muxed14 == 1'b1 && apb_state14 == apb_state_access14) begin
      ahb_addr_phase14 <= 1'b1;
      ahb_data_phase14 <= 1'b0;
      hrdata14         <= prdata_muxed14;
    end
  end
end

// APB14 state machine14 state definitions14
assign apb_state_idle14   = 3'b001;
assign apb_state_setup14  = 3'b010;
assign apb_state_access14 = 3'b100;

// APB14 state machine14
always @(posedge hclk14 or negedge hreset_n14) begin
  if (hreset_n14 == 1'b0) begin
    apb_state14   <= apb_state_idle14;
    psel_vector14 <= 1'b0;
    penable14     <= 1'b0;
    paddr14       <= 1'b0;
    pwrite14      <= 1'b0;
  end  
  else begin
    
    // IDLE14 -> SETUP14
    if (apb_state14 == apb_state_idle14) begin
      if (ahb_data_phase14 == 1'b1) begin
        apb_state14   <= apb_state_setup14;
        psel_vector14 <= slave_select14;
        paddr14       <= haddr_reg14;
        pwrite14      <= hwrite_reg14;
      end  
    end
    
    // SETUP14 -> TRANSFER14
    if (apb_state14 == apb_state_setup14) begin
      apb_state14 <= apb_state_access14;
      penable14   <= 1'b1;
    end
    
    // TRANSFER14 -> SETUP14 or
    // TRANSFER14 -> IDLE14
    if (apb_state14 == apb_state_access14) begin
      if (pready_muxed14 == 1'b1) begin
      
        // TRANSFER14 -> SETUP14
        if (valid_ahb_trans14 == 1'b1) begin
          apb_state14   <= apb_state_setup14;
          penable14     <= 1'b0;
          psel_vector14 <= slave_select14;
          paddr14       <= haddr_reg14;
          pwrite14      <= hwrite_reg14;
        end  
        
        // TRANSFER14 -> IDLE14
        else begin
          apb_state14   <= apb_state_idle14;      
          penable14     <= 1'b0;
          psel_vector14 <= 'b0;
        end  
      end
    end
    
  end
end

always @(posedge hclk14 or negedge hreset_n14) begin
  if (hreset_n14 == 1'b0)
    slave_select14 <= 'b0;
  else begin  
  `ifdef APB_SLAVE014
     slave_select14[0]   <= valid_ahb_trans14 && (haddr14 >= APB_SLAVE0_START_ADDR14)  && (haddr14 <= APB_SLAVE0_END_ADDR14);
   `else
     slave_select14[0]   <= 1'b0;
   `endif
   
   `ifdef APB_SLAVE114
     slave_select14[1]   <= valid_ahb_trans14 && (haddr14 >= APB_SLAVE1_START_ADDR14)  && (haddr14 <= APB_SLAVE1_END_ADDR14);
   `else
     slave_select14[1]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE214  
     slave_select14[2]   <= valid_ahb_trans14 && (haddr14 >= APB_SLAVE2_START_ADDR14)  && (haddr14 <= APB_SLAVE2_END_ADDR14);
   `else
     slave_select14[2]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE314  
     slave_select14[3]   <= valid_ahb_trans14 && (haddr14 >= APB_SLAVE3_START_ADDR14)  && (haddr14 <= APB_SLAVE3_END_ADDR14);
   `else
     slave_select14[3]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE414  
     slave_select14[4]   <= valid_ahb_trans14 && (haddr14 >= APB_SLAVE4_START_ADDR14)  && (haddr14 <= APB_SLAVE4_END_ADDR14);
   `else
     slave_select14[4]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE514  
     slave_select14[5]   <= valid_ahb_trans14 && (haddr14 >= APB_SLAVE5_START_ADDR14)  && (haddr14 <= APB_SLAVE5_END_ADDR14);
   `else
     slave_select14[5]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE614  
     slave_select14[6]   <= valid_ahb_trans14 && (haddr14 >= APB_SLAVE6_START_ADDR14)  && (haddr14 <= APB_SLAVE6_END_ADDR14);
   `else
     slave_select14[6]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE714  
     slave_select14[7]   <= valid_ahb_trans14 && (haddr14 >= APB_SLAVE7_START_ADDR14)  && (haddr14 <= APB_SLAVE7_END_ADDR14);
   `else
     slave_select14[7]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE814  
     slave_select14[8]   <= valid_ahb_trans14 && (haddr14 >= APB_SLAVE8_START_ADDR14)  && (haddr14 <= APB_SLAVE8_END_ADDR14);
   `else
     slave_select14[8]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE914  
     slave_select14[9]   <= valid_ahb_trans14 && (haddr14 >= APB_SLAVE9_START_ADDR14)  && (haddr14 <= APB_SLAVE9_END_ADDR14);
   `else
     slave_select14[9]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1014  
     slave_select14[10]  <= valid_ahb_trans14 && (haddr14 >= APB_SLAVE10_START_ADDR14) && (haddr14 <= APB_SLAVE10_END_ADDR14);
   `else
     slave_select14[10]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1114  
     slave_select14[11]  <= valid_ahb_trans14 && (haddr14 >= APB_SLAVE11_START_ADDR14) && (haddr14 <= APB_SLAVE11_END_ADDR14);
   `else
     slave_select14[11]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1214  
     slave_select14[12]  <= valid_ahb_trans14 && (haddr14 >= APB_SLAVE12_START_ADDR14) && (haddr14 <= APB_SLAVE12_END_ADDR14);
   `else
     slave_select14[12]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1314  
     slave_select14[13]  <= valid_ahb_trans14 && (haddr14 >= APB_SLAVE13_START_ADDR14) && (haddr14 <= APB_SLAVE13_END_ADDR14);
   `else
     slave_select14[13]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1414  
     slave_select14[14]  <= valid_ahb_trans14 && (haddr14 >= APB_SLAVE14_START_ADDR14) && (haddr14 <= APB_SLAVE14_END_ADDR14);
   `else
     slave_select14[14]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1514  
     slave_select14[15]  <= valid_ahb_trans14 && (haddr14 >= APB_SLAVE15_START_ADDR14) && (haddr14 <= APB_SLAVE15_END_ADDR14);
   `else
     slave_select14[15]   <= 1'b0;
   `endif  
  end
end

assign pready_muxed14 = |(psel_vector14 & pready_vector14);
assign prdata_muxed14 = prdata0_q14  | prdata1_q14  | prdata2_q14  | prdata3_q14  |
                      prdata4_q14  | prdata5_q14  | prdata6_q14  | prdata7_q14  |
                      prdata8_q14  | prdata9_q14  | prdata10_q14 | prdata11_q14 |
                      prdata12_q14 | prdata13_q14 | prdata14_q14 | prdata15_q14 ;

`ifdef APB_SLAVE014
  assign psel014            = psel_vector14[0];
  assign pready_vector14[0] = pready014;
  assign prdata0_q14        = (psel014 == 1'b1) ? prdata014 : 'b0;
`else
  assign pready_vector14[0] = 1'b0;
  assign prdata0_q14        = 'b0;
`endif

`ifdef APB_SLAVE114
  assign psel114            = psel_vector14[1];
  assign pready_vector14[1] = pready114;
  assign prdata1_q14        = (psel114 == 1'b1) ? prdata114 : 'b0;
`else
  assign pready_vector14[1] = 1'b0;
  assign prdata1_q14        = 'b0;
`endif

`ifdef APB_SLAVE214
  assign psel214            = psel_vector14[2];
  assign pready_vector14[2] = pready214;
  assign prdata2_q14        = (psel214 == 1'b1) ? prdata214 : 'b0;
`else
  assign pready_vector14[2] = 1'b0;
  assign prdata2_q14        = 'b0;
`endif

`ifdef APB_SLAVE314
  assign psel314            = psel_vector14[3];
  assign pready_vector14[3] = pready314;
  assign prdata3_q14        = (psel314 == 1'b1) ? prdata314 : 'b0;
`else
  assign pready_vector14[3] = 1'b0;
  assign prdata3_q14        = 'b0;
`endif

`ifdef APB_SLAVE414
  assign psel414            = psel_vector14[4];
  assign pready_vector14[4] = pready414;
  assign prdata4_q14        = (psel414 == 1'b1) ? prdata414 : 'b0;
`else
  assign pready_vector14[4] = 1'b0;
  assign prdata4_q14        = 'b0;
`endif

`ifdef APB_SLAVE514
  assign psel514            = psel_vector14[5];
  assign pready_vector14[5] = pready514;
  assign prdata5_q14        = (psel514 == 1'b1) ? prdata514 : 'b0;
`else
  assign pready_vector14[5] = 1'b0;
  assign prdata5_q14        = 'b0;
`endif

`ifdef APB_SLAVE614
  assign psel614            = psel_vector14[6];
  assign pready_vector14[6] = pready614;
  assign prdata6_q14        = (psel614 == 1'b1) ? prdata614 : 'b0;
`else
  assign pready_vector14[6] = 1'b0;
  assign prdata6_q14        = 'b0;
`endif

`ifdef APB_SLAVE714
  assign psel714            = psel_vector14[7];
  assign pready_vector14[7] = pready714;
  assign prdata7_q14        = (psel714 == 1'b1) ? prdata714 : 'b0;
`else
  assign pready_vector14[7] = 1'b0;
  assign prdata7_q14        = 'b0;
`endif

`ifdef APB_SLAVE814
  assign psel814            = psel_vector14[8];
  assign pready_vector14[8] = pready814;
  assign prdata8_q14        = (psel814 == 1'b1) ? prdata814 : 'b0;
`else
  assign pready_vector14[8] = 1'b0;
  assign prdata8_q14        = 'b0;
`endif

`ifdef APB_SLAVE914
  assign psel914            = psel_vector14[9];
  assign pready_vector14[9] = pready914;
  assign prdata9_q14        = (psel914 == 1'b1) ? prdata914 : 'b0;
`else
  assign pready_vector14[9] = 1'b0;
  assign prdata9_q14        = 'b0;
`endif

`ifdef APB_SLAVE1014
  assign psel1014            = psel_vector14[10];
  assign pready_vector14[10] = pready1014;
  assign prdata10_q14        = (psel1014 == 1'b1) ? prdata1014 : 'b0;
`else
  assign pready_vector14[10] = 1'b0;
  assign prdata10_q14        = 'b0;
`endif

`ifdef APB_SLAVE1114
  assign psel1114            = psel_vector14[11];
  assign pready_vector14[11] = pready1114;
  assign prdata11_q14        = (psel1114 == 1'b1) ? prdata1114 : 'b0;
`else
  assign pready_vector14[11] = 1'b0;
  assign prdata11_q14        = 'b0;
`endif

`ifdef APB_SLAVE1214
  assign psel1214            = psel_vector14[12];
  assign pready_vector14[12] = pready1214;
  assign prdata12_q14        = (psel1214 == 1'b1) ? prdata1214 : 'b0;
`else
  assign pready_vector14[12] = 1'b0;
  assign prdata12_q14        = 'b0;
`endif

`ifdef APB_SLAVE1314
  assign psel1314            = psel_vector14[13];
  assign pready_vector14[13] = pready1314;
  assign prdata13_q14        = (psel1314 == 1'b1) ? prdata1314 : 'b0;
`else
  assign pready_vector14[13] = 1'b0;
  assign prdata13_q14        = 'b0;
`endif

`ifdef APB_SLAVE1414
  assign psel1414            = psel_vector14[14];
  assign pready_vector14[14] = pready1414;
  assign prdata14_q14        = (psel1414 == 1'b1) ? prdata1414 : 'b0;
`else
  assign pready_vector14[14] = 1'b0;
  assign prdata14_q14        = 'b0;
`endif

`ifdef APB_SLAVE1514
  assign psel1514            = psel_vector14[15];
  assign pready_vector14[15] = pready1514;
  assign prdata15_q14        = (psel1514 == 1'b1) ? prdata1514 : 'b0;
`else
  assign pready_vector14[15] = 1'b0;
  assign prdata15_q14        = 'b0;
`endif

endmodule
