//File2 name   : ahb2apb2.v
//Title2       : 
//Created2     : 2010
//Description2 : Simple2 AHB2 to APB2 bridge2
//Notes2       : 
//----------------------------------------------------------------------
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------

`timescale 1ns/1ps

`include "ahb2apb_defines2.v"

module ahb2apb2
(
  // AHB2 signals2
  hclk2,
  hreset_n2,
  hsel2,
  haddr2,
  htrans2,
  hwdata2,
  hwrite2,
  hrdata2,
  hready2,
  hresp2,
  
  // APB2 signals2 common to all APB2 slaves2
  pclk2,
  preset_n2,
  paddr2,
  penable2,
  pwrite2,
  pwdata2
  
  // Slave2 0 signals2
  `ifdef APB_SLAVE02
  ,psel02
  ,pready02
  ,prdata02
  `endif
  
  // Slave2 1 signals2
  `ifdef APB_SLAVE12
  ,psel12
  ,pready12
  ,prdata12
  `endif
  
  // Slave2 2 signals2
  `ifdef APB_SLAVE22
  ,psel22
  ,pready22
  ,prdata22
  `endif
  
  // Slave2 3 signals2
  `ifdef APB_SLAVE32
  ,psel32
  ,pready32
  ,prdata32
  `endif
  
  // Slave2 4 signals2
  `ifdef APB_SLAVE42
  ,psel42
  ,pready42
  ,prdata42
  `endif
  
  // Slave2 5 signals2
  `ifdef APB_SLAVE52
  ,psel52
  ,pready52
  ,prdata52
  `endif
  
  // Slave2 6 signals2
  `ifdef APB_SLAVE62
  ,psel62
  ,pready62
  ,prdata62
  `endif
  
  // Slave2 7 signals2
  `ifdef APB_SLAVE72
  ,psel72
  ,pready72
  ,prdata72
  `endif
  
  // Slave2 8 signals2
  `ifdef APB_SLAVE82
  ,psel82
  ,pready82
  ,prdata82
  `endif
  
  // Slave2 9 signals2
  `ifdef APB_SLAVE92
  ,psel92
  ,pready92
  ,prdata92
  `endif
  
  // Slave2 10 signals2
  `ifdef APB_SLAVE102
  ,psel102
  ,pready102
  ,prdata102
  `endif
  
  // Slave2 11 signals2
  `ifdef APB_SLAVE112
  ,psel112
  ,pready112
  ,prdata112
  `endif
  
  // Slave2 12 signals2
  `ifdef APB_SLAVE122
  ,psel122
  ,pready122
  ,prdata122
  `endif
  
  // Slave2 13 signals2
  `ifdef APB_SLAVE132
  ,psel132
  ,pready132
  ,prdata132
  `endif
  
  // Slave2 14 signals2
  `ifdef APB_SLAVE142
  ,psel142
  ,pready142
  ,prdata142
  `endif
  
  // Slave2 15 signals2
  `ifdef APB_SLAVE152
  ,psel152
  ,pready152
  ,prdata152
  `endif
  
);

parameter 
  APB_SLAVE0_START_ADDR2  = 32'h00000000,
  APB_SLAVE0_END_ADDR2    = 32'h00000000,
  APB_SLAVE1_START_ADDR2  = 32'h00000000,
  APB_SLAVE1_END_ADDR2    = 32'h00000000,
  APB_SLAVE2_START_ADDR2  = 32'h00000000,
  APB_SLAVE2_END_ADDR2    = 32'h00000000,
  APB_SLAVE3_START_ADDR2  = 32'h00000000,
  APB_SLAVE3_END_ADDR2    = 32'h00000000,
  APB_SLAVE4_START_ADDR2  = 32'h00000000,
  APB_SLAVE4_END_ADDR2    = 32'h00000000,
  APB_SLAVE5_START_ADDR2  = 32'h00000000,
  APB_SLAVE5_END_ADDR2    = 32'h00000000,
  APB_SLAVE6_START_ADDR2  = 32'h00000000,
  APB_SLAVE6_END_ADDR2    = 32'h00000000,
  APB_SLAVE7_START_ADDR2  = 32'h00000000,
  APB_SLAVE7_END_ADDR2    = 32'h00000000,
  APB_SLAVE8_START_ADDR2  = 32'h00000000,
  APB_SLAVE8_END_ADDR2    = 32'h00000000,
  APB_SLAVE9_START_ADDR2  = 32'h00000000,
  APB_SLAVE9_END_ADDR2    = 32'h00000000,
  APB_SLAVE10_START_ADDR2  = 32'h00000000,
  APB_SLAVE10_END_ADDR2    = 32'h00000000,
  APB_SLAVE11_START_ADDR2  = 32'h00000000,
  APB_SLAVE11_END_ADDR2    = 32'h00000000,
  APB_SLAVE12_START_ADDR2  = 32'h00000000,
  APB_SLAVE12_END_ADDR2    = 32'h00000000,
  APB_SLAVE13_START_ADDR2  = 32'h00000000,
  APB_SLAVE13_END_ADDR2    = 32'h00000000,
  APB_SLAVE14_START_ADDR2  = 32'h00000000,
  APB_SLAVE14_END_ADDR2    = 32'h00000000,
  APB_SLAVE15_START_ADDR2  = 32'h00000000,
  APB_SLAVE15_END_ADDR2    = 32'h00000000;

  // AHB2 signals2
input        hclk2;
input        hreset_n2;
input        hsel2;
input[31:0]  haddr2;
input[1:0]   htrans2;
input[31:0]  hwdata2;
input        hwrite2;
output[31:0] hrdata2;
reg   [31:0] hrdata2;
output       hready2;
output[1:0]  hresp2;
  
  // APB2 signals2 common to all APB2 slaves2
input       pclk2;
input       preset_n2;
output[31:0] paddr2;
reg   [31:0] paddr2;
output       penable2;
reg          penable2;
output       pwrite2;
reg          pwrite2;
output[31:0] pwdata2;
  
  // Slave2 0 signals2
`ifdef APB_SLAVE02
  output      psel02;
  input       pready02;
  input[31:0] prdata02;
`endif
  
  // Slave2 1 signals2
`ifdef APB_SLAVE12
  output      psel12;
  input       pready12;
  input[31:0] prdata12;
`endif
  
  // Slave2 2 signals2
`ifdef APB_SLAVE22
  output      psel22;
  input       pready22;
  input[31:0] prdata22;
`endif
  
  // Slave2 3 signals2
`ifdef APB_SLAVE32
  output      psel32;
  input       pready32;
  input[31:0] prdata32;
`endif
  
  // Slave2 4 signals2
`ifdef APB_SLAVE42
  output      psel42;
  input       pready42;
  input[31:0] prdata42;
`endif
  
  // Slave2 5 signals2
`ifdef APB_SLAVE52
  output      psel52;
  input       pready52;
  input[31:0] prdata52;
`endif
  
  // Slave2 6 signals2
`ifdef APB_SLAVE62
  output      psel62;
  input       pready62;
  input[31:0] prdata62;
`endif
  
  // Slave2 7 signals2
`ifdef APB_SLAVE72
  output      psel72;
  input       pready72;
  input[31:0] prdata72;
`endif
  
  // Slave2 8 signals2
`ifdef APB_SLAVE82
  output      psel82;
  input       pready82;
  input[31:0] prdata82;
`endif
  
  // Slave2 9 signals2
`ifdef APB_SLAVE92
  output      psel92;
  input       pready92;
  input[31:0] prdata92;
`endif
  
  // Slave2 10 signals2
`ifdef APB_SLAVE102
  output      psel102;
  input       pready102;
  input[31:0] prdata102;
`endif
  
  // Slave2 11 signals2
`ifdef APB_SLAVE112
  output      psel112;
  input       pready112;
  input[31:0] prdata112;
`endif
  
  // Slave2 12 signals2
`ifdef APB_SLAVE122
  output      psel122;
  input       pready122;
  input[31:0] prdata122;
`endif
  
  // Slave2 13 signals2
`ifdef APB_SLAVE132
  output      psel132;
  input       pready132;
  input[31:0] prdata132;
`endif
  
  // Slave2 14 signals2
`ifdef APB_SLAVE142
  output      psel142;
  input       pready142;
  input[31:0] prdata142;
`endif
  
  // Slave2 15 signals2
`ifdef APB_SLAVE152
  output      psel152;
  input       pready152;
  input[31:0] prdata152;
`endif
 
reg         ahb_addr_phase2;
reg         ahb_data_phase2;
wire        valid_ahb_trans2;
wire        pready_muxed2;
wire [31:0] prdata_muxed2;
reg  [31:0] haddr_reg2;
reg         hwrite_reg2;
reg  [2:0]  apb_state2;
wire [2:0]  apb_state_idle2;
wire [2:0]  apb_state_setup2;
wire [2:0]  apb_state_access2;
reg  [15:0] slave_select2;
wire [15:0] pready_vector2;
reg  [15:0] psel_vector2;
wire [31:0] prdata0_q2;
wire [31:0] prdata1_q2;
wire [31:0] prdata2_q2;
wire [31:0] prdata3_q2;
wire [31:0] prdata4_q2;
wire [31:0] prdata5_q2;
wire [31:0] prdata6_q2;
wire [31:0] prdata7_q2;
wire [31:0] prdata8_q2;
wire [31:0] prdata9_q2;
wire [31:0] prdata10_q2;
wire [31:0] prdata11_q2;
wire [31:0] prdata12_q2;
wire [31:0] prdata13_q2;
wire [31:0] prdata14_q2;
wire [31:0] prdata15_q2;

// assign pclk2     = hclk2;
// assign preset_n2 = hreset_n2;
assign hready2   = ahb_addr_phase2;
assign pwdata2   = hwdata2;
assign hresp2  = 2'b00;

// Respond2 to NONSEQ2 or SEQ transfers2
assign valid_ahb_trans2 = ((htrans2 == 2'b10) || (htrans2 == 2'b11)) && (hsel2 == 1'b1);

always @(posedge hclk2) begin
  if (hreset_n2 == 1'b0) begin
    ahb_addr_phase2 <= 1'b1;
    ahb_data_phase2 <= 1'b0;
    haddr_reg2      <= 'b0;
    hwrite_reg2     <= 1'b0;
    hrdata2         <= 'b0;
  end
  else begin
    if (ahb_addr_phase2 == 1'b1 && valid_ahb_trans2 == 1'b1) begin
      ahb_addr_phase2 <= 1'b0;
      ahb_data_phase2 <= 1'b1;
      haddr_reg2      <= haddr2;
      hwrite_reg2     <= hwrite2;
    end
    if (ahb_data_phase2 == 1'b1 && pready_muxed2 == 1'b1 && apb_state2 == apb_state_access2) begin
      ahb_addr_phase2 <= 1'b1;
      ahb_data_phase2 <= 1'b0;
      hrdata2         <= prdata_muxed2;
    end
  end
end

// APB2 state machine2 state definitions2
assign apb_state_idle2   = 3'b001;
assign apb_state_setup2  = 3'b010;
assign apb_state_access2 = 3'b100;

// APB2 state machine2
always @(posedge hclk2 or negedge hreset_n2) begin
  if (hreset_n2 == 1'b0) begin
    apb_state2   <= apb_state_idle2;
    psel_vector2 <= 1'b0;
    penable2     <= 1'b0;
    paddr2       <= 1'b0;
    pwrite2      <= 1'b0;
  end  
  else begin
    
    // IDLE2 -> SETUP2
    if (apb_state2 == apb_state_idle2) begin
      if (ahb_data_phase2 == 1'b1) begin
        apb_state2   <= apb_state_setup2;
        psel_vector2 <= slave_select2;
        paddr2       <= haddr_reg2;
        pwrite2      <= hwrite_reg2;
      end  
    end
    
    // SETUP2 -> TRANSFER2
    if (apb_state2 == apb_state_setup2) begin
      apb_state2 <= apb_state_access2;
      penable2   <= 1'b1;
    end
    
    // TRANSFER2 -> SETUP2 or
    // TRANSFER2 -> IDLE2
    if (apb_state2 == apb_state_access2) begin
      if (pready_muxed2 == 1'b1) begin
      
        // TRANSFER2 -> SETUP2
        if (valid_ahb_trans2 == 1'b1) begin
          apb_state2   <= apb_state_setup2;
          penable2     <= 1'b0;
          psel_vector2 <= slave_select2;
          paddr2       <= haddr_reg2;
          pwrite2      <= hwrite_reg2;
        end  
        
        // TRANSFER2 -> IDLE2
        else begin
          apb_state2   <= apb_state_idle2;      
          penable2     <= 1'b0;
          psel_vector2 <= 'b0;
        end  
      end
    end
    
  end
end

always @(posedge hclk2 or negedge hreset_n2) begin
  if (hreset_n2 == 1'b0)
    slave_select2 <= 'b0;
  else begin  
  `ifdef APB_SLAVE02
     slave_select2[0]   <= valid_ahb_trans2 && (haddr2 >= APB_SLAVE0_START_ADDR2)  && (haddr2 <= APB_SLAVE0_END_ADDR2);
   `else
     slave_select2[0]   <= 1'b0;
   `endif
   
   `ifdef APB_SLAVE12
     slave_select2[1]   <= valid_ahb_trans2 && (haddr2 >= APB_SLAVE1_START_ADDR2)  && (haddr2 <= APB_SLAVE1_END_ADDR2);
   `else
     slave_select2[1]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE22  
     slave_select2[2]   <= valid_ahb_trans2 && (haddr2 >= APB_SLAVE2_START_ADDR2)  && (haddr2 <= APB_SLAVE2_END_ADDR2);
   `else
     slave_select2[2]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE32  
     slave_select2[3]   <= valid_ahb_trans2 && (haddr2 >= APB_SLAVE3_START_ADDR2)  && (haddr2 <= APB_SLAVE3_END_ADDR2);
   `else
     slave_select2[3]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE42  
     slave_select2[4]   <= valid_ahb_trans2 && (haddr2 >= APB_SLAVE4_START_ADDR2)  && (haddr2 <= APB_SLAVE4_END_ADDR2);
   `else
     slave_select2[4]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE52  
     slave_select2[5]   <= valid_ahb_trans2 && (haddr2 >= APB_SLAVE5_START_ADDR2)  && (haddr2 <= APB_SLAVE5_END_ADDR2);
   `else
     slave_select2[5]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE62  
     slave_select2[6]   <= valid_ahb_trans2 && (haddr2 >= APB_SLAVE6_START_ADDR2)  && (haddr2 <= APB_SLAVE6_END_ADDR2);
   `else
     slave_select2[6]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE72  
     slave_select2[7]   <= valid_ahb_trans2 && (haddr2 >= APB_SLAVE7_START_ADDR2)  && (haddr2 <= APB_SLAVE7_END_ADDR2);
   `else
     slave_select2[7]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE82  
     slave_select2[8]   <= valid_ahb_trans2 && (haddr2 >= APB_SLAVE8_START_ADDR2)  && (haddr2 <= APB_SLAVE8_END_ADDR2);
   `else
     slave_select2[8]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE92  
     slave_select2[9]   <= valid_ahb_trans2 && (haddr2 >= APB_SLAVE9_START_ADDR2)  && (haddr2 <= APB_SLAVE9_END_ADDR2);
   `else
     slave_select2[9]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE102  
     slave_select2[10]  <= valid_ahb_trans2 && (haddr2 >= APB_SLAVE10_START_ADDR2) && (haddr2 <= APB_SLAVE10_END_ADDR2);
   `else
     slave_select2[10]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE112  
     slave_select2[11]  <= valid_ahb_trans2 && (haddr2 >= APB_SLAVE11_START_ADDR2) && (haddr2 <= APB_SLAVE11_END_ADDR2);
   `else
     slave_select2[11]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE122  
     slave_select2[12]  <= valid_ahb_trans2 && (haddr2 >= APB_SLAVE12_START_ADDR2) && (haddr2 <= APB_SLAVE12_END_ADDR2);
   `else
     slave_select2[12]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE132  
     slave_select2[13]  <= valid_ahb_trans2 && (haddr2 >= APB_SLAVE13_START_ADDR2) && (haddr2 <= APB_SLAVE13_END_ADDR2);
   `else
     slave_select2[13]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE142  
     slave_select2[14]  <= valid_ahb_trans2 && (haddr2 >= APB_SLAVE14_START_ADDR2) && (haddr2 <= APB_SLAVE14_END_ADDR2);
   `else
     slave_select2[14]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE152  
     slave_select2[15]  <= valid_ahb_trans2 && (haddr2 >= APB_SLAVE15_START_ADDR2) && (haddr2 <= APB_SLAVE15_END_ADDR2);
   `else
     slave_select2[15]   <= 1'b0;
   `endif  
  end
end

assign pready_muxed2 = |(psel_vector2 & pready_vector2);
assign prdata_muxed2 = prdata0_q2  | prdata1_q2  | prdata2_q2  | prdata3_q2  |
                      prdata4_q2  | prdata5_q2  | prdata6_q2  | prdata7_q2  |
                      prdata8_q2  | prdata9_q2  | prdata10_q2 | prdata11_q2 |
                      prdata12_q2 | prdata13_q2 | prdata14_q2 | prdata15_q2 ;

`ifdef APB_SLAVE02
  assign psel02            = psel_vector2[0];
  assign pready_vector2[0] = pready02;
  assign prdata0_q2        = (psel02 == 1'b1) ? prdata02 : 'b0;
`else
  assign pready_vector2[0] = 1'b0;
  assign prdata0_q2        = 'b0;
`endif

`ifdef APB_SLAVE12
  assign psel12            = psel_vector2[1];
  assign pready_vector2[1] = pready12;
  assign prdata1_q2        = (psel12 == 1'b1) ? prdata12 : 'b0;
`else
  assign pready_vector2[1] = 1'b0;
  assign prdata1_q2        = 'b0;
`endif

`ifdef APB_SLAVE22
  assign psel22            = psel_vector2[2];
  assign pready_vector2[2] = pready22;
  assign prdata2_q2        = (psel22 == 1'b1) ? prdata22 : 'b0;
`else
  assign pready_vector2[2] = 1'b0;
  assign prdata2_q2        = 'b0;
`endif

`ifdef APB_SLAVE32
  assign psel32            = psel_vector2[3];
  assign pready_vector2[3] = pready32;
  assign prdata3_q2        = (psel32 == 1'b1) ? prdata32 : 'b0;
`else
  assign pready_vector2[3] = 1'b0;
  assign prdata3_q2        = 'b0;
`endif

`ifdef APB_SLAVE42
  assign psel42            = psel_vector2[4];
  assign pready_vector2[4] = pready42;
  assign prdata4_q2        = (psel42 == 1'b1) ? prdata42 : 'b0;
`else
  assign pready_vector2[4] = 1'b0;
  assign prdata4_q2        = 'b0;
`endif

`ifdef APB_SLAVE52
  assign psel52            = psel_vector2[5];
  assign pready_vector2[5] = pready52;
  assign prdata5_q2        = (psel52 == 1'b1) ? prdata52 : 'b0;
`else
  assign pready_vector2[5] = 1'b0;
  assign prdata5_q2        = 'b0;
`endif

`ifdef APB_SLAVE62
  assign psel62            = psel_vector2[6];
  assign pready_vector2[6] = pready62;
  assign prdata6_q2        = (psel62 == 1'b1) ? prdata62 : 'b0;
`else
  assign pready_vector2[6] = 1'b0;
  assign prdata6_q2        = 'b0;
`endif

`ifdef APB_SLAVE72
  assign psel72            = psel_vector2[7];
  assign pready_vector2[7] = pready72;
  assign prdata7_q2        = (psel72 == 1'b1) ? prdata72 : 'b0;
`else
  assign pready_vector2[7] = 1'b0;
  assign prdata7_q2        = 'b0;
`endif

`ifdef APB_SLAVE82
  assign psel82            = psel_vector2[8];
  assign pready_vector2[8] = pready82;
  assign prdata8_q2        = (psel82 == 1'b1) ? prdata82 : 'b0;
`else
  assign pready_vector2[8] = 1'b0;
  assign prdata8_q2        = 'b0;
`endif

`ifdef APB_SLAVE92
  assign psel92            = psel_vector2[9];
  assign pready_vector2[9] = pready92;
  assign prdata9_q2        = (psel92 == 1'b1) ? prdata92 : 'b0;
`else
  assign pready_vector2[9] = 1'b0;
  assign prdata9_q2        = 'b0;
`endif

`ifdef APB_SLAVE102
  assign psel102            = psel_vector2[10];
  assign pready_vector2[10] = pready102;
  assign prdata10_q2        = (psel102 == 1'b1) ? prdata102 : 'b0;
`else
  assign pready_vector2[10] = 1'b0;
  assign prdata10_q2        = 'b0;
`endif

`ifdef APB_SLAVE112
  assign psel112            = psel_vector2[11];
  assign pready_vector2[11] = pready112;
  assign prdata11_q2        = (psel112 == 1'b1) ? prdata112 : 'b0;
`else
  assign pready_vector2[11] = 1'b0;
  assign prdata11_q2        = 'b0;
`endif

`ifdef APB_SLAVE122
  assign psel122            = psel_vector2[12];
  assign pready_vector2[12] = pready122;
  assign prdata12_q2        = (psel122 == 1'b1) ? prdata122 : 'b0;
`else
  assign pready_vector2[12] = 1'b0;
  assign prdata12_q2        = 'b0;
`endif

`ifdef APB_SLAVE132
  assign psel132            = psel_vector2[13];
  assign pready_vector2[13] = pready132;
  assign prdata13_q2        = (psel132 == 1'b1) ? prdata132 : 'b0;
`else
  assign pready_vector2[13] = 1'b0;
  assign prdata13_q2        = 'b0;
`endif

`ifdef APB_SLAVE142
  assign psel142            = psel_vector2[14];
  assign pready_vector2[14] = pready142;
  assign prdata14_q2        = (psel142 == 1'b1) ? prdata142 : 'b0;
`else
  assign pready_vector2[14] = 1'b0;
  assign prdata14_q2        = 'b0;
`endif

`ifdef APB_SLAVE152
  assign psel152            = psel_vector2[15];
  assign pready_vector2[15] = pready152;
  assign prdata15_q2        = (psel152 == 1'b1) ? prdata152 : 'b0;
`else
  assign pready_vector2[15] = 1'b0;
  assign prdata15_q2        = 'b0;
`endif

endmodule
