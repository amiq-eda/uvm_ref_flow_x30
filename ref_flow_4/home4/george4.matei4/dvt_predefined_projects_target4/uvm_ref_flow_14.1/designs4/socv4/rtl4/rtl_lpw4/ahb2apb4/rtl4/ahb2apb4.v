//File4 name   : ahb2apb4.v
//Title4       : 
//Created4     : 2010
//Description4 : Simple4 AHB4 to APB4 bridge4
//Notes4       : 
//----------------------------------------------------------------------
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------

`timescale 1ns/1ps

`include "ahb2apb_defines4.v"

module ahb2apb4
(
  // AHB4 signals4
  hclk4,
  hreset_n4,
  hsel4,
  haddr4,
  htrans4,
  hwdata4,
  hwrite4,
  hrdata4,
  hready4,
  hresp4,
  
  // APB4 signals4 common to all APB4 slaves4
  pclk4,
  preset_n4,
  paddr4,
  penable4,
  pwrite4,
  pwdata4
  
  // Slave4 0 signals4
  `ifdef APB_SLAVE04
  ,psel04
  ,pready04
  ,prdata04
  `endif
  
  // Slave4 1 signals4
  `ifdef APB_SLAVE14
  ,psel14
  ,pready14
  ,prdata14
  `endif
  
  // Slave4 2 signals4
  `ifdef APB_SLAVE24
  ,psel24
  ,pready24
  ,prdata24
  `endif
  
  // Slave4 3 signals4
  `ifdef APB_SLAVE34
  ,psel34
  ,pready34
  ,prdata34
  `endif
  
  // Slave4 4 signals4
  `ifdef APB_SLAVE44
  ,psel44
  ,pready44
  ,prdata44
  `endif
  
  // Slave4 5 signals4
  `ifdef APB_SLAVE54
  ,psel54
  ,pready54
  ,prdata54
  `endif
  
  // Slave4 6 signals4
  `ifdef APB_SLAVE64
  ,psel64
  ,pready64
  ,prdata64
  `endif
  
  // Slave4 7 signals4
  `ifdef APB_SLAVE74
  ,psel74
  ,pready74
  ,prdata74
  `endif
  
  // Slave4 8 signals4
  `ifdef APB_SLAVE84
  ,psel84
  ,pready84
  ,prdata84
  `endif
  
  // Slave4 9 signals4
  `ifdef APB_SLAVE94
  ,psel94
  ,pready94
  ,prdata94
  `endif
  
  // Slave4 10 signals4
  `ifdef APB_SLAVE104
  ,psel104
  ,pready104
  ,prdata104
  `endif
  
  // Slave4 11 signals4
  `ifdef APB_SLAVE114
  ,psel114
  ,pready114
  ,prdata114
  `endif
  
  // Slave4 12 signals4
  `ifdef APB_SLAVE124
  ,psel124
  ,pready124
  ,prdata124
  `endif
  
  // Slave4 13 signals4
  `ifdef APB_SLAVE134
  ,psel134
  ,pready134
  ,prdata134
  `endif
  
  // Slave4 14 signals4
  `ifdef APB_SLAVE144
  ,psel144
  ,pready144
  ,prdata144
  `endif
  
  // Slave4 15 signals4
  `ifdef APB_SLAVE154
  ,psel154
  ,pready154
  ,prdata154
  `endif
  
);

parameter 
  APB_SLAVE0_START_ADDR4  = 32'h00000000,
  APB_SLAVE0_END_ADDR4    = 32'h00000000,
  APB_SLAVE1_START_ADDR4  = 32'h00000000,
  APB_SLAVE1_END_ADDR4    = 32'h00000000,
  APB_SLAVE2_START_ADDR4  = 32'h00000000,
  APB_SLAVE2_END_ADDR4    = 32'h00000000,
  APB_SLAVE3_START_ADDR4  = 32'h00000000,
  APB_SLAVE3_END_ADDR4    = 32'h00000000,
  APB_SLAVE4_START_ADDR4  = 32'h00000000,
  APB_SLAVE4_END_ADDR4    = 32'h00000000,
  APB_SLAVE5_START_ADDR4  = 32'h00000000,
  APB_SLAVE5_END_ADDR4    = 32'h00000000,
  APB_SLAVE6_START_ADDR4  = 32'h00000000,
  APB_SLAVE6_END_ADDR4    = 32'h00000000,
  APB_SLAVE7_START_ADDR4  = 32'h00000000,
  APB_SLAVE7_END_ADDR4    = 32'h00000000,
  APB_SLAVE8_START_ADDR4  = 32'h00000000,
  APB_SLAVE8_END_ADDR4    = 32'h00000000,
  APB_SLAVE9_START_ADDR4  = 32'h00000000,
  APB_SLAVE9_END_ADDR4    = 32'h00000000,
  APB_SLAVE10_START_ADDR4  = 32'h00000000,
  APB_SLAVE10_END_ADDR4    = 32'h00000000,
  APB_SLAVE11_START_ADDR4  = 32'h00000000,
  APB_SLAVE11_END_ADDR4    = 32'h00000000,
  APB_SLAVE12_START_ADDR4  = 32'h00000000,
  APB_SLAVE12_END_ADDR4    = 32'h00000000,
  APB_SLAVE13_START_ADDR4  = 32'h00000000,
  APB_SLAVE13_END_ADDR4    = 32'h00000000,
  APB_SLAVE14_START_ADDR4  = 32'h00000000,
  APB_SLAVE14_END_ADDR4    = 32'h00000000,
  APB_SLAVE15_START_ADDR4  = 32'h00000000,
  APB_SLAVE15_END_ADDR4    = 32'h00000000;

  // AHB4 signals4
input        hclk4;
input        hreset_n4;
input        hsel4;
input[31:0]  haddr4;
input[1:0]   htrans4;
input[31:0]  hwdata4;
input        hwrite4;
output[31:0] hrdata4;
reg   [31:0] hrdata4;
output       hready4;
output[1:0]  hresp4;
  
  // APB4 signals4 common to all APB4 slaves4
input       pclk4;
input       preset_n4;
output[31:0] paddr4;
reg   [31:0] paddr4;
output       penable4;
reg          penable4;
output       pwrite4;
reg          pwrite4;
output[31:0] pwdata4;
  
  // Slave4 0 signals4
`ifdef APB_SLAVE04
  output      psel04;
  input       pready04;
  input[31:0] prdata04;
`endif
  
  // Slave4 1 signals4
`ifdef APB_SLAVE14
  output      psel14;
  input       pready14;
  input[31:0] prdata14;
`endif
  
  // Slave4 2 signals4
`ifdef APB_SLAVE24
  output      psel24;
  input       pready24;
  input[31:0] prdata24;
`endif
  
  // Slave4 3 signals4
`ifdef APB_SLAVE34
  output      psel34;
  input       pready34;
  input[31:0] prdata34;
`endif
  
  // Slave4 4 signals4
`ifdef APB_SLAVE44
  output      psel44;
  input       pready44;
  input[31:0] prdata44;
`endif
  
  // Slave4 5 signals4
`ifdef APB_SLAVE54
  output      psel54;
  input       pready54;
  input[31:0] prdata54;
`endif
  
  // Slave4 6 signals4
`ifdef APB_SLAVE64
  output      psel64;
  input       pready64;
  input[31:0] prdata64;
`endif
  
  // Slave4 7 signals4
`ifdef APB_SLAVE74
  output      psel74;
  input       pready74;
  input[31:0] prdata74;
`endif
  
  // Slave4 8 signals4
`ifdef APB_SLAVE84
  output      psel84;
  input       pready84;
  input[31:0] prdata84;
`endif
  
  // Slave4 9 signals4
`ifdef APB_SLAVE94
  output      psel94;
  input       pready94;
  input[31:0] prdata94;
`endif
  
  // Slave4 10 signals4
`ifdef APB_SLAVE104
  output      psel104;
  input       pready104;
  input[31:0] prdata104;
`endif
  
  // Slave4 11 signals4
`ifdef APB_SLAVE114
  output      psel114;
  input       pready114;
  input[31:0] prdata114;
`endif
  
  // Slave4 12 signals4
`ifdef APB_SLAVE124
  output      psel124;
  input       pready124;
  input[31:0] prdata124;
`endif
  
  // Slave4 13 signals4
`ifdef APB_SLAVE134
  output      psel134;
  input       pready134;
  input[31:0] prdata134;
`endif
  
  // Slave4 14 signals4
`ifdef APB_SLAVE144
  output      psel144;
  input       pready144;
  input[31:0] prdata144;
`endif
  
  // Slave4 15 signals4
`ifdef APB_SLAVE154
  output      psel154;
  input       pready154;
  input[31:0] prdata154;
`endif
 
reg         ahb_addr_phase4;
reg         ahb_data_phase4;
wire        valid_ahb_trans4;
wire        pready_muxed4;
wire [31:0] prdata_muxed4;
reg  [31:0] haddr_reg4;
reg         hwrite_reg4;
reg  [2:0]  apb_state4;
wire [2:0]  apb_state_idle4;
wire [2:0]  apb_state_setup4;
wire [2:0]  apb_state_access4;
reg  [15:0] slave_select4;
wire [15:0] pready_vector4;
reg  [15:0] psel_vector4;
wire [31:0] prdata0_q4;
wire [31:0] prdata1_q4;
wire [31:0] prdata2_q4;
wire [31:0] prdata3_q4;
wire [31:0] prdata4_q4;
wire [31:0] prdata5_q4;
wire [31:0] prdata6_q4;
wire [31:0] prdata7_q4;
wire [31:0] prdata8_q4;
wire [31:0] prdata9_q4;
wire [31:0] prdata10_q4;
wire [31:0] prdata11_q4;
wire [31:0] prdata12_q4;
wire [31:0] prdata13_q4;
wire [31:0] prdata14_q4;
wire [31:0] prdata15_q4;

// assign pclk4     = hclk4;
// assign preset_n4 = hreset_n4;
assign hready4   = ahb_addr_phase4;
assign pwdata4   = hwdata4;
assign hresp4  = 2'b00;

// Respond4 to NONSEQ4 or SEQ transfers4
assign valid_ahb_trans4 = ((htrans4 == 2'b10) || (htrans4 == 2'b11)) && (hsel4 == 1'b1);

always @(posedge hclk4) begin
  if (hreset_n4 == 1'b0) begin
    ahb_addr_phase4 <= 1'b1;
    ahb_data_phase4 <= 1'b0;
    haddr_reg4      <= 'b0;
    hwrite_reg4     <= 1'b0;
    hrdata4         <= 'b0;
  end
  else begin
    if (ahb_addr_phase4 == 1'b1 && valid_ahb_trans4 == 1'b1) begin
      ahb_addr_phase4 <= 1'b0;
      ahb_data_phase4 <= 1'b1;
      haddr_reg4      <= haddr4;
      hwrite_reg4     <= hwrite4;
    end
    if (ahb_data_phase4 == 1'b1 && pready_muxed4 == 1'b1 && apb_state4 == apb_state_access4) begin
      ahb_addr_phase4 <= 1'b1;
      ahb_data_phase4 <= 1'b0;
      hrdata4         <= prdata_muxed4;
    end
  end
end

// APB4 state machine4 state definitions4
assign apb_state_idle4   = 3'b001;
assign apb_state_setup4  = 3'b010;
assign apb_state_access4 = 3'b100;

// APB4 state machine4
always @(posedge hclk4 or negedge hreset_n4) begin
  if (hreset_n4 == 1'b0) begin
    apb_state4   <= apb_state_idle4;
    psel_vector4 <= 1'b0;
    penable4     <= 1'b0;
    paddr4       <= 1'b0;
    pwrite4      <= 1'b0;
  end  
  else begin
    
    // IDLE4 -> SETUP4
    if (apb_state4 == apb_state_idle4) begin
      if (ahb_data_phase4 == 1'b1) begin
        apb_state4   <= apb_state_setup4;
        psel_vector4 <= slave_select4;
        paddr4       <= haddr_reg4;
        pwrite4      <= hwrite_reg4;
      end  
    end
    
    // SETUP4 -> TRANSFER4
    if (apb_state4 == apb_state_setup4) begin
      apb_state4 <= apb_state_access4;
      penable4   <= 1'b1;
    end
    
    // TRANSFER4 -> SETUP4 or
    // TRANSFER4 -> IDLE4
    if (apb_state4 == apb_state_access4) begin
      if (pready_muxed4 == 1'b1) begin
      
        // TRANSFER4 -> SETUP4
        if (valid_ahb_trans4 == 1'b1) begin
          apb_state4   <= apb_state_setup4;
          penable4     <= 1'b0;
          psel_vector4 <= slave_select4;
          paddr4       <= haddr_reg4;
          pwrite4      <= hwrite_reg4;
        end  
        
        // TRANSFER4 -> IDLE4
        else begin
          apb_state4   <= apb_state_idle4;      
          penable4     <= 1'b0;
          psel_vector4 <= 'b0;
        end  
      end
    end
    
  end
end

always @(posedge hclk4 or negedge hreset_n4) begin
  if (hreset_n4 == 1'b0)
    slave_select4 <= 'b0;
  else begin  
  `ifdef APB_SLAVE04
     slave_select4[0]   <= valid_ahb_trans4 && (haddr4 >= APB_SLAVE0_START_ADDR4)  && (haddr4 <= APB_SLAVE0_END_ADDR4);
   `else
     slave_select4[0]   <= 1'b0;
   `endif
   
   `ifdef APB_SLAVE14
     slave_select4[1]   <= valid_ahb_trans4 && (haddr4 >= APB_SLAVE1_START_ADDR4)  && (haddr4 <= APB_SLAVE1_END_ADDR4);
   `else
     slave_select4[1]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE24  
     slave_select4[2]   <= valid_ahb_trans4 && (haddr4 >= APB_SLAVE2_START_ADDR4)  && (haddr4 <= APB_SLAVE2_END_ADDR4);
   `else
     slave_select4[2]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE34  
     slave_select4[3]   <= valid_ahb_trans4 && (haddr4 >= APB_SLAVE3_START_ADDR4)  && (haddr4 <= APB_SLAVE3_END_ADDR4);
   `else
     slave_select4[3]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE44  
     slave_select4[4]   <= valid_ahb_trans4 && (haddr4 >= APB_SLAVE4_START_ADDR4)  && (haddr4 <= APB_SLAVE4_END_ADDR4);
   `else
     slave_select4[4]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE54  
     slave_select4[5]   <= valid_ahb_trans4 && (haddr4 >= APB_SLAVE5_START_ADDR4)  && (haddr4 <= APB_SLAVE5_END_ADDR4);
   `else
     slave_select4[5]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE64  
     slave_select4[6]   <= valid_ahb_trans4 && (haddr4 >= APB_SLAVE6_START_ADDR4)  && (haddr4 <= APB_SLAVE6_END_ADDR4);
   `else
     slave_select4[6]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE74  
     slave_select4[7]   <= valid_ahb_trans4 && (haddr4 >= APB_SLAVE7_START_ADDR4)  && (haddr4 <= APB_SLAVE7_END_ADDR4);
   `else
     slave_select4[7]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE84  
     slave_select4[8]   <= valid_ahb_trans4 && (haddr4 >= APB_SLAVE8_START_ADDR4)  && (haddr4 <= APB_SLAVE8_END_ADDR4);
   `else
     slave_select4[8]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE94  
     slave_select4[9]   <= valid_ahb_trans4 && (haddr4 >= APB_SLAVE9_START_ADDR4)  && (haddr4 <= APB_SLAVE9_END_ADDR4);
   `else
     slave_select4[9]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE104  
     slave_select4[10]  <= valid_ahb_trans4 && (haddr4 >= APB_SLAVE10_START_ADDR4) && (haddr4 <= APB_SLAVE10_END_ADDR4);
   `else
     slave_select4[10]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE114  
     slave_select4[11]  <= valid_ahb_trans4 && (haddr4 >= APB_SLAVE11_START_ADDR4) && (haddr4 <= APB_SLAVE11_END_ADDR4);
   `else
     slave_select4[11]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE124  
     slave_select4[12]  <= valid_ahb_trans4 && (haddr4 >= APB_SLAVE12_START_ADDR4) && (haddr4 <= APB_SLAVE12_END_ADDR4);
   `else
     slave_select4[12]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE134  
     slave_select4[13]  <= valid_ahb_trans4 && (haddr4 >= APB_SLAVE13_START_ADDR4) && (haddr4 <= APB_SLAVE13_END_ADDR4);
   `else
     slave_select4[13]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE144  
     slave_select4[14]  <= valid_ahb_trans4 && (haddr4 >= APB_SLAVE14_START_ADDR4) && (haddr4 <= APB_SLAVE14_END_ADDR4);
   `else
     slave_select4[14]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE154  
     slave_select4[15]  <= valid_ahb_trans4 && (haddr4 >= APB_SLAVE15_START_ADDR4) && (haddr4 <= APB_SLAVE15_END_ADDR4);
   `else
     slave_select4[15]   <= 1'b0;
   `endif  
  end
end

assign pready_muxed4 = |(psel_vector4 & pready_vector4);
assign prdata_muxed4 = prdata0_q4  | prdata1_q4  | prdata2_q4  | prdata3_q4  |
                      prdata4_q4  | prdata5_q4  | prdata6_q4  | prdata7_q4  |
                      prdata8_q4  | prdata9_q4  | prdata10_q4 | prdata11_q4 |
                      prdata12_q4 | prdata13_q4 | prdata14_q4 | prdata15_q4 ;

`ifdef APB_SLAVE04
  assign psel04            = psel_vector4[0];
  assign pready_vector4[0] = pready04;
  assign prdata0_q4        = (psel04 == 1'b1) ? prdata04 : 'b0;
`else
  assign pready_vector4[0] = 1'b0;
  assign prdata0_q4        = 'b0;
`endif

`ifdef APB_SLAVE14
  assign psel14            = psel_vector4[1];
  assign pready_vector4[1] = pready14;
  assign prdata1_q4        = (psel14 == 1'b1) ? prdata14 : 'b0;
`else
  assign pready_vector4[1] = 1'b0;
  assign prdata1_q4        = 'b0;
`endif

`ifdef APB_SLAVE24
  assign psel24            = psel_vector4[2];
  assign pready_vector4[2] = pready24;
  assign prdata2_q4        = (psel24 == 1'b1) ? prdata24 : 'b0;
`else
  assign pready_vector4[2] = 1'b0;
  assign prdata2_q4        = 'b0;
`endif

`ifdef APB_SLAVE34
  assign psel34            = psel_vector4[3];
  assign pready_vector4[3] = pready34;
  assign prdata3_q4        = (psel34 == 1'b1) ? prdata34 : 'b0;
`else
  assign pready_vector4[3] = 1'b0;
  assign prdata3_q4        = 'b0;
`endif

`ifdef APB_SLAVE44
  assign psel44            = psel_vector4[4];
  assign pready_vector4[4] = pready44;
  assign prdata4_q4        = (psel44 == 1'b1) ? prdata44 : 'b0;
`else
  assign pready_vector4[4] = 1'b0;
  assign prdata4_q4        = 'b0;
`endif

`ifdef APB_SLAVE54
  assign psel54            = psel_vector4[5];
  assign pready_vector4[5] = pready54;
  assign prdata5_q4        = (psel54 == 1'b1) ? prdata54 : 'b0;
`else
  assign pready_vector4[5] = 1'b0;
  assign prdata5_q4        = 'b0;
`endif

`ifdef APB_SLAVE64
  assign psel64            = psel_vector4[6];
  assign pready_vector4[6] = pready64;
  assign prdata6_q4        = (psel64 == 1'b1) ? prdata64 : 'b0;
`else
  assign pready_vector4[6] = 1'b0;
  assign prdata6_q4        = 'b0;
`endif

`ifdef APB_SLAVE74
  assign psel74            = psel_vector4[7];
  assign pready_vector4[7] = pready74;
  assign prdata7_q4        = (psel74 == 1'b1) ? prdata74 : 'b0;
`else
  assign pready_vector4[7] = 1'b0;
  assign prdata7_q4        = 'b0;
`endif

`ifdef APB_SLAVE84
  assign psel84            = psel_vector4[8];
  assign pready_vector4[8] = pready84;
  assign prdata8_q4        = (psel84 == 1'b1) ? prdata84 : 'b0;
`else
  assign pready_vector4[8] = 1'b0;
  assign prdata8_q4        = 'b0;
`endif

`ifdef APB_SLAVE94
  assign psel94            = psel_vector4[9];
  assign pready_vector4[9] = pready94;
  assign prdata9_q4        = (psel94 == 1'b1) ? prdata94 : 'b0;
`else
  assign pready_vector4[9] = 1'b0;
  assign prdata9_q4        = 'b0;
`endif

`ifdef APB_SLAVE104
  assign psel104            = psel_vector4[10];
  assign pready_vector4[10] = pready104;
  assign prdata10_q4        = (psel104 == 1'b1) ? prdata104 : 'b0;
`else
  assign pready_vector4[10] = 1'b0;
  assign prdata10_q4        = 'b0;
`endif

`ifdef APB_SLAVE114
  assign psel114            = psel_vector4[11];
  assign pready_vector4[11] = pready114;
  assign prdata11_q4        = (psel114 == 1'b1) ? prdata114 : 'b0;
`else
  assign pready_vector4[11] = 1'b0;
  assign prdata11_q4        = 'b0;
`endif

`ifdef APB_SLAVE124
  assign psel124            = psel_vector4[12];
  assign pready_vector4[12] = pready124;
  assign prdata12_q4        = (psel124 == 1'b1) ? prdata124 : 'b0;
`else
  assign pready_vector4[12] = 1'b0;
  assign prdata12_q4        = 'b0;
`endif

`ifdef APB_SLAVE134
  assign psel134            = psel_vector4[13];
  assign pready_vector4[13] = pready134;
  assign prdata13_q4        = (psel134 == 1'b1) ? prdata134 : 'b0;
`else
  assign pready_vector4[13] = 1'b0;
  assign prdata13_q4        = 'b0;
`endif

`ifdef APB_SLAVE144
  assign psel144            = psel_vector4[14];
  assign pready_vector4[14] = pready144;
  assign prdata14_q4        = (psel144 == 1'b1) ? prdata144 : 'b0;
`else
  assign pready_vector4[14] = 1'b0;
  assign prdata14_q4        = 'b0;
`endif

`ifdef APB_SLAVE154
  assign psel154            = psel_vector4[15];
  assign pready_vector4[15] = pready154;
  assign prdata15_q4        = (psel154 == 1'b1) ? prdata154 : 'b0;
`else
  assign pready_vector4[15] = 1'b0;
  assign prdata15_q4        = 'b0;
`endif

endmodule
