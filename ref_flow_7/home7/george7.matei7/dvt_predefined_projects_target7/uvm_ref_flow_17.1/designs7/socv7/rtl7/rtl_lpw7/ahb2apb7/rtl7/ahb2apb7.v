//File7 name   : ahb2apb7.v
//Title7       : 
//Created7     : 2010
//Description7 : Simple7 AHB7 to APB7 bridge7
//Notes7       : 
//----------------------------------------------------------------------
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------

`timescale 1ns/1ps

`include "ahb2apb_defines7.v"

module ahb2apb7
(
  // AHB7 signals7
  hclk7,
  hreset_n7,
  hsel7,
  haddr7,
  htrans7,
  hwdata7,
  hwrite7,
  hrdata7,
  hready7,
  hresp7,
  
  // APB7 signals7 common to all APB7 slaves7
  pclk7,
  preset_n7,
  paddr7,
  penable7,
  pwrite7,
  pwdata7
  
  // Slave7 0 signals7
  `ifdef APB_SLAVE07
  ,psel07
  ,pready07
  ,prdata07
  `endif
  
  // Slave7 1 signals7
  `ifdef APB_SLAVE17
  ,psel17
  ,pready17
  ,prdata17
  `endif
  
  // Slave7 2 signals7
  `ifdef APB_SLAVE27
  ,psel27
  ,pready27
  ,prdata27
  `endif
  
  // Slave7 3 signals7
  `ifdef APB_SLAVE37
  ,psel37
  ,pready37
  ,prdata37
  `endif
  
  // Slave7 4 signals7
  `ifdef APB_SLAVE47
  ,psel47
  ,pready47
  ,prdata47
  `endif
  
  // Slave7 5 signals7
  `ifdef APB_SLAVE57
  ,psel57
  ,pready57
  ,prdata57
  `endif
  
  // Slave7 6 signals7
  `ifdef APB_SLAVE67
  ,psel67
  ,pready67
  ,prdata67
  `endif
  
  // Slave7 7 signals7
  `ifdef APB_SLAVE77
  ,psel77
  ,pready77
  ,prdata77
  `endif
  
  // Slave7 8 signals7
  `ifdef APB_SLAVE87
  ,psel87
  ,pready87
  ,prdata87
  `endif
  
  // Slave7 9 signals7
  `ifdef APB_SLAVE97
  ,psel97
  ,pready97
  ,prdata97
  `endif
  
  // Slave7 10 signals7
  `ifdef APB_SLAVE107
  ,psel107
  ,pready107
  ,prdata107
  `endif
  
  // Slave7 11 signals7
  `ifdef APB_SLAVE117
  ,psel117
  ,pready117
  ,prdata117
  `endif
  
  // Slave7 12 signals7
  `ifdef APB_SLAVE127
  ,psel127
  ,pready127
  ,prdata127
  `endif
  
  // Slave7 13 signals7
  `ifdef APB_SLAVE137
  ,psel137
  ,pready137
  ,prdata137
  `endif
  
  // Slave7 14 signals7
  `ifdef APB_SLAVE147
  ,psel147
  ,pready147
  ,prdata147
  `endif
  
  // Slave7 15 signals7
  `ifdef APB_SLAVE157
  ,psel157
  ,pready157
  ,prdata157
  `endif
  
);

parameter 
  APB_SLAVE0_START_ADDR7  = 32'h00000000,
  APB_SLAVE0_END_ADDR7    = 32'h00000000,
  APB_SLAVE1_START_ADDR7  = 32'h00000000,
  APB_SLAVE1_END_ADDR7    = 32'h00000000,
  APB_SLAVE2_START_ADDR7  = 32'h00000000,
  APB_SLAVE2_END_ADDR7    = 32'h00000000,
  APB_SLAVE3_START_ADDR7  = 32'h00000000,
  APB_SLAVE3_END_ADDR7    = 32'h00000000,
  APB_SLAVE4_START_ADDR7  = 32'h00000000,
  APB_SLAVE4_END_ADDR7    = 32'h00000000,
  APB_SLAVE5_START_ADDR7  = 32'h00000000,
  APB_SLAVE5_END_ADDR7    = 32'h00000000,
  APB_SLAVE6_START_ADDR7  = 32'h00000000,
  APB_SLAVE6_END_ADDR7    = 32'h00000000,
  APB_SLAVE7_START_ADDR7  = 32'h00000000,
  APB_SLAVE7_END_ADDR7    = 32'h00000000,
  APB_SLAVE8_START_ADDR7  = 32'h00000000,
  APB_SLAVE8_END_ADDR7    = 32'h00000000,
  APB_SLAVE9_START_ADDR7  = 32'h00000000,
  APB_SLAVE9_END_ADDR7    = 32'h00000000,
  APB_SLAVE10_START_ADDR7  = 32'h00000000,
  APB_SLAVE10_END_ADDR7    = 32'h00000000,
  APB_SLAVE11_START_ADDR7  = 32'h00000000,
  APB_SLAVE11_END_ADDR7    = 32'h00000000,
  APB_SLAVE12_START_ADDR7  = 32'h00000000,
  APB_SLAVE12_END_ADDR7    = 32'h00000000,
  APB_SLAVE13_START_ADDR7  = 32'h00000000,
  APB_SLAVE13_END_ADDR7    = 32'h00000000,
  APB_SLAVE14_START_ADDR7  = 32'h00000000,
  APB_SLAVE14_END_ADDR7    = 32'h00000000,
  APB_SLAVE15_START_ADDR7  = 32'h00000000,
  APB_SLAVE15_END_ADDR7    = 32'h00000000;

  // AHB7 signals7
input        hclk7;
input        hreset_n7;
input        hsel7;
input[31:0]  haddr7;
input[1:0]   htrans7;
input[31:0]  hwdata7;
input        hwrite7;
output[31:0] hrdata7;
reg   [31:0] hrdata7;
output       hready7;
output[1:0]  hresp7;
  
  // APB7 signals7 common to all APB7 slaves7
input       pclk7;
input       preset_n7;
output[31:0] paddr7;
reg   [31:0] paddr7;
output       penable7;
reg          penable7;
output       pwrite7;
reg          pwrite7;
output[31:0] pwdata7;
  
  // Slave7 0 signals7
`ifdef APB_SLAVE07
  output      psel07;
  input       pready07;
  input[31:0] prdata07;
`endif
  
  // Slave7 1 signals7
`ifdef APB_SLAVE17
  output      psel17;
  input       pready17;
  input[31:0] prdata17;
`endif
  
  // Slave7 2 signals7
`ifdef APB_SLAVE27
  output      psel27;
  input       pready27;
  input[31:0] prdata27;
`endif
  
  // Slave7 3 signals7
`ifdef APB_SLAVE37
  output      psel37;
  input       pready37;
  input[31:0] prdata37;
`endif
  
  // Slave7 4 signals7
`ifdef APB_SLAVE47
  output      psel47;
  input       pready47;
  input[31:0] prdata47;
`endif
  
  // Slave7 5 signals7
`ifdef APB_SLAVE57
  output      psel57;
  input       pready57;
  input[31:0] prdata57;
`endif
  
  // Slave7 6 signals7
`ifdef APB_SLAVE67
  output      psel67;
  input       pready67;
  input[31:0] prdata67;
`endif
  
  // Slave7 7 signals7
`ifdef APB_SLAVE77
  output      psel77;
  input       pready77;
  input[31:0] prdata77;
`endif
  
  // Slave7 8 signals7
`ifdef APB_SLAVE87
  output      psel87;
  input       pready87;
  input[31:0] prdata87;
`endif
  
  // Slave7 9 signals7
`ifdef APB_SLAVE97
  output      psel97;
  input       pready97;
  input[31:0] prdata97;
`endif
  
  // Slave7 10 signals7
`ifdef APB_SLAVE107
  output      psel107;
  input       pready107;
  input[31:0] prdata107;
`endif
  
  // Slave7 11 signals7
`ifdef APB_SLAVE117
  output      psel117;
  input       pready117;
  input[31:0] prdata117;
`endif
  
  // Slave7 12 signals7
`ifdef APB_SLAVE127
  output      psel127;
  input       pready127;
  input[31:0] prdata127;
`endif
  
  // Slave7 13 signals7
`ifdef APB_SLAVE137
  output      psel137;
  input       pready137;
  input[31:0] prdata137;
`endif
  
  // Slave7 14 signals7
`ifdef APB_SLAVE147
  output      psel147;
  input       pready147;
  input[31:0] prdata147;
`endif
  
  // Slave7 15 signals7
`ifdef APB_SLAVE157
  output      psel157;
  input       pready157;
  input[31:0] prdata157;
`endif
 
reg         ahb_addr_phase7;
reg         ahb_data_phase7;
wire        valid_ahb_trans7;
wire        pready_muxed7;
wire [31:0] prdata_muxed7;
reg  [31:0] haddr_reg7;
reg         hwrite_reg7;
reg  [2:0]  apb_state7;
wire [2:0]  apb_state_idle7;
wire [2:0]  apb_state_setup7;
wire [2:0]  apb_state_access7;
reg  [15:0] slave_select7;
wire [15:0] pready_vector7;
reg  [15:0] psel_vector7;
wire [31:0] prdata0_q7;
wire [31:0] prdata1_q7;
wire [31:0] prdata2_q7;
wire [31:0] prdata3_q7;
wire [31:0] prdata4_q7;
wire [31:0] prdata5_q7;
wire [31:0] prdata6_q7;
wire [31:0] prdata7_q7;
wire [31:0] prdata8_q7;
wire [31:0] prdata9_q7;
wire [31:0] prdata10_q7;
wire [31:0] prdata11_q7;
wire [31:0] prdata12_q7;
wire [31:0] prdata13_q7;
wire [31:0] prdata14_q7;
wire [31:0] prdata15_q7;

// assign pclk7     = hclk7;
// assign preset_n7 = hreset_n7;
assign hready7   = ahb_addr_phase7;
assign pwdata7   = hwdata7;
assign hresp7  = 2'b00;

// Respond7 to NONSEQ7 or SEQ transfers7
assign valid_ahb_trans7 = ((htrans7 == 2'b10) || (htrans7 == 2'b11)) && (hsel7 == 1'b1);

always @(posedge hclk7) begin
  if (hreset_n7 == 1'b0) begin
    ahb_addr_phase7 <= 1'b1;
    ahb_data_phase7 <= 1'b0;
    haddr_reg7      <= 'b0;
    hwrite_reg7     <= 1'b0;
    hrdata7         <= 'b0;
  end
  else begin
    if (ahb_addr_phase7 == 1'b1 && valid_ahb_trans7 == 1'b1) begin
      ahb_addr_phase7 <= 1'b0;
      ahb_data_phase7 <= 1'b1;
      haddr_reg7      <= haddr7;
      hwrite_reg7     <= hwrite7;
    end
    if (ahb_data_phase7 == 1'b1 && pready_muxed7 == 1'b1 && apb_state7 == apb_state_access7) begin
      ahb_addr_phase7 <= 1'b1;
      ahb_data_phase7 <= 1'b0;
      hrdata7         <= prdata_muxed7;
    end
  end
end

// APB7 state machine7 state definitions7
assign apb_state_idle7   = 3'b001;
assign apb_state_setup7  = 3'b010;
assign apb_state_access7 = 3'b100;

// APB7 state machine7
always @(posedge hclk7 or negedge hreset_n7) begin
  if (hreset_n7 == 1'b0) begin
    apb_state7   <= apb_state_idle7;
    psel_vector7 <= 1'b0;
    penable7     <= 1'b0;
    paddr7       <= 1'b0;
    pwrite7      <= 1'b0;
  end  
  else begin
    
    // IDLE7 -> SETUP7
    if (apb_state7 == apb_state_idle7) begin
      if (ahb_data_phase7 == 1'b1) begin
        apb_state7   <= apb_state_setup7;
        psel_vector7 <= slave_select7;
        paddr7       <= haddr_reg7;
        pwrite7      <= hwrite_reg7;
      end  
    end
    
    // SETUP7 -> TRANSFER7
    if (apb_state7 == apb_state_setup7) begin
      apb_state7 <= apb_state_access7;
      penable7   <= 1'b1;
    end
    
    // TRANSFER7 -> SETUP7 or
    // TRANSFER7 -> IDLE7
    if (apb_state7 == apb_state_access7) begin
      if (pready_muxed7 == 1'b1) begin
      
        // TRANSFER7 -> SETUP7
        if (valid_ahb_trans7 == 1'b1) begin
          apb_state7   <= apb_state_setup7;
          penable7     <= 1'b0;
          psel_vector7 <= slave_select7;
          paddr7       <= haddr_reg7;
          pwrite7      <= hwrite_reg7;
        end  
        
        // TRANSFER7 -> IDLE7
        else begin
          apb_state7   <= apb_state_idle7;      
          penable7     <= 1'b0;
          psel_vector7 <= 'b0;
        end  
      end
    end
    
  end
end

always @(posedge hclk7 or negedge hreset_n7) begin
  if (hreset_n7 == 1'b0)
    slave_select7 <= 'b0;
  else begin  
  `ifdef APB_SLAVE07
     slave_select7[0]   <= valid_ahb_trans7 && (haddr7 >= APB_SLAVE0_START_ADDR7)  && (haddr7 <= APB_SLAVE0_END_ADDR7);
   `else
     slave_select7[0]   <= 1'b0;
   `endif
   
   `ifdef APB_SLAVE17
     slave_select7[1]   <= valid_ahb_trans7 && (haddr7 >= APB_SLAVE1_START_ADDR7)  && (haddr7 <= APB_SLAVE1_END_ADDR7);
   `else
     slave_select7[1]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE27  
     slave_select7[2]   <= valid_ahb_trans7 && (haddr7 >= APB_SLAVE2_START_ADDR7)  && (haddr7 <= APB_SLAVE2_END_ADDR7);
   `else
     slave_select7[2]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE37  
     slave_select7[3]   <= valid_ahb_trans7 && (haddr7 >= APB_SLAVE3_START_ADDR7)  && (haddr7 <= APB_SLAVE3_END_ADDR7);
   `else
     slave_select7[3]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE47  
     slave_select7[4]   <= valid_ahb_trans7 && (haddr7 >= APB_SLAVE4_START_ADDR7)  && (haddr7 <= APB_SLAVE4_END_ADDR7);
   `else
     slave_select7[4]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE57  
     slave_select7[5]   <= valid_ahb_trans7 && (haddr7 >= APB_SLAVE5_START_ADDR7)  && (haddr7 <= APB_SLAVE5_END_ADDR7);
   `else
     slave_select7[5]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE67  
     slave_select7[6]   <= valid_ahb_trans7 && (haddr7 >= APB_SLAVE6_START_ADDR7)  && (haddr7 <= APB_SLAVE6_END_ADDR7);
   `else
     slave_select7[6]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE77  
     slave_select7[7]   <= valid_ahb_trans7 && (haddr7 >= APB_SLAVE7_START_ADDR7)  && (haddr7 <= APB_SLAVE7_END_ADDR7);
   `else
     slave_select7[7]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE87  
     slave_select7[8]   <= valid_ahb_trans7 && (haddr7 >= APB_SLAVE8_START_ADDR7)  && (haddr7 <= APB_SLAVE8_END_ADDR7);
   `else
     slave_select7[8]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE97  
     slave_select7[9]   <= valid_ahb_trans7 && (haddr7 >= APB_SLAVE9_START_ADDR7)  && (haddr7 <= APB_SLAVE9_END_ADDR7);
   `else
     slave_select7[9]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE107  
     slave_select7[10]  <= valid_ahb_trans7 && (haddr7 >= APB_SLAVE10_START_ADDR7) && (haddr7 <= APB_SLAVE10_END_ADDR7);
   `else
     slave_select7[10]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE117  
     slave_select7[11]  <= valid_ahb_trans7 && (haddr7 >= APB_SLAVE11_START_ADDR7) && (haddr7 <= APB_SLAVE11_END_ADDR7);
   `else
     slave_select7[11]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE127  
     slave_select7[12]  <= valid_ahb_trans7 && (haddr7 >= APB_SLAVE12_START_ADDR7) && (haddr7 <= APB_SLAVE12_END_ADDR7);
   `else
     slave_select7[12]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE137  
     slave_select7[13]  <= valid_ahb_trans7 && (haddr7 >= APB_SLAVE13_START_ADDR7) && (haddr7 <= APB_SLAVE13_END_ADDR7);
   `else
     slave_select7[13]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE147  
     slave_select7[14]  <= valid_ahb_trans7 && (haddr7 >= APB_SLAVE14_START_ADDR7) && (haddr7 <= APB_SLAVE14_END_ADDR7);
   `else
     slave_select7[14]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE157  
     slave_select7[15]  <= valid_ahb_trans7 && (haddr7 >= APB_SLAVE15_START_ADDR7) && (haddr7 <= APB_SLAVE15_END_ADDR7);
   `else
     slave_select7[15]   <= 1'b0;
   `endif  
  end
end

assign pready_muxed7 = |(psel_vector7 & pready_vector7);
assign prdata_muxed7 = prdata0_q7  | prdata1_q7  | prdata2_q7  | prdata3_q7  |
                      prdata4_q7  | prdata5_q7  | prdata6_q7  | prdata7_q7  |
                      prdata8_q7  | prdata9_q7  | prdata10_q7 | prdata11_q7 |
                      prdata12_q7 | prdata13_q7 | prdata14_q7 | prdata15_q7 ;

`ifdef APB_SLAVE07
  assign psel07            = psel_vector7[0];
  assign pready_vector7[0] = pready07;
  assign prdata0_q7        = (psel07 == 1'b1) ? prdata07 : 'b0;
`else
  assign pready_vector7[0] = 1'b0;
  assign prdata0_q7        = 'b0;
`endif

`ifdef APB_SLAVE17
  assign psel17            = psel_vector7[1];
  assign pready_vector7[1] = pready17;
  assign prdata1_q7        = (psel17 == 1'b1) ? prdata17 : 'b0;
`else
  assign pready_vector7[1] = 1'b0;
  assign prdata1_q7        = 'b0;
`endif

`ifdef APB_SLAVE27
  assign psel27            = psel_vector7[2];
  assign pready_vector7[2] = pready27;
  assign prdata2_q7        = (psel27 == 1'b1) ? prdata27 : 'b0;
`else
  assign pready_vector7[2] = 1'b0;
  assign prdata2_q7        = 'b0;
`endif

`ifdef APB_SLAVE37
  assign psel37            = psel_vector7[3];
  assign pready_vector7[3] = pready37;
  assign prdata3_q7        = (psel37 == 1'b1) ? prdata37 : 'b0;
`else
  assign pready_vector7[3] = 1'b0;
  assign prdata3_q7        = 'b0;
`endif

`ifdef APB_SLAVE47
  assign psel47            = psel_vector7[4];
  assign pready_vector7[4] = pready47;
  assign prdata4_q7        = (psel47 == 1'b1) ? prdata47 : 'b0;
`else
  assign pready_vector7[4] = 1'b0;
  assign prdata4_q7        = 'b0;
`endif

`ifdef APB_SLAVE57
  assign psel57            = psel_vector7[5];
  assign pready_vector7[5] = pready57;
  assign prdata5_q7        = (psel57 == 1'b1) ? prdata57 : 'b0;
`else
  assign pready_vector7[5] = 1'b0;
  assign prdata5_q7        = 'b0;
`endif

`ifdef APB_SLAVE67
  assign psel67            = psel_vector7[6];
  assign pready_vector7[6] = pready67;
  assign prdata6_q7        = (psel67 == 1'b1) ? prdata67 : 'b0;
`else
  assign pready_vector7[6] = 1'b0;
  assign prdata6_q7        = 'b0;
`endif

`ifdef APB_SLAVE77
  assign psel77            = psel_vector7[7];
  assign pready_vector7[7] = pready77;
  assign prdata7_q7        = (psel77 == 1'b1) ? prdata77 : 'b0;
`else
  assign pready_vector7[7] = 1'b0;
  assign prdata7_q7        = 'b0;
`endif

`ifdef APB_SLAVE87
  assign psel87            = psel_vector7[8];
  assign pready_vector7[8] = pready87;
  assign prdata8_q7        = (psel87 == 1'b1) ? prdata87 : 'b0;
`else
  assign pready_vector7[8] = 1'b0;
  assign prdata8_q7        = 'b0;
`endif

`ifdef APB_SLAVE97
  assign psel97            = psel_vector7[9];
  assign pready_vector7[9] = pready97;
  assign prdata9_q7        = (psel97 == 1'b1) ? prdata97 : 'b0;
`else
  assign pready_vector7[9] = 1'b0;
  assign prdata9_q7        = 'b0;
`endif

`ifdef APB_SLAVE107
  assign psel107            = psel_vector7[10];
  assign pready_vector7[10] = pready107;
  assign prdata10_q7        = (psel107 == 1'b1) ? prdata107 : 'b0;
`else
  assign pready_vector7[10] = 1'b0;
  assign prdata10_q7        = 'b0;
`endif

`ifdef APB_SLAVE117
  assign psel117            = psel_vector7[11];
  assign pready_vector7[11] = pready117;
  assign prdata11_q7        = (psel117 == 1'b1) ? prdata117 : 'b0;
`else
  assign pready_vector7[11] = 1'b0;
  assign prdata11_q7        = 'b0;
`endif

`ifdef APB_SLAVE127
  assign psel127            = psel_vector7[12];
  assign pready_vector7[12] = pready127;
  assign prdata12_q7        = (psel127 == 1'b1) ? prdata127 : 'b0;
`else
  assign pready_vector7[12] = 1'b0;
  assign prdata12_q7        = 'b0;
`endif

`ifdef APB_SLAVE137
  assign psel137            = psel_vector7[13];
  assign pready_vector7[13] = pready137;
  assign prdata13_q7        = (psel137 == 1'b1) ? prdata137 : 'b0;
`else
  assign pready_vector7[13] = 1'b0;
  assign prdata13_q7        = 'b0;
`endif

`ifdef APB_SLAVE147
  assign psel147            = psel_vector7[14];
  assign pready_vector7[14] = pready147;
  assign prdata14_q7        = (psel147 == 1'b1) ? prdata147 : 'b0;
`else
  assign pready_vector7[14] = 1'b0;
  assign prdata14_q7        = 'b0;
`endif

`ifdef APB_SLAVE157
  assign psel157            = psel_vector7[15];
  assign pready_vector7[15] = pready157;
  assign prdata15_q7        = (psel157 == 1'b1) ? prdata157 : 'b0;
`else
  assign pready_vector7[15] = 1'b0;
  assign prdata15_q7        = 'b0;
`endif

endmodule
