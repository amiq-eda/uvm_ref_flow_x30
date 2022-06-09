//File18 name   : ahb2apb18.v
//Title18       : 
//Created18     : 2010
//Description18 : Simple18 AHB18 to APB18 bridge18
//Notes18       : 
//----------------------------------------------------------------------
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------

`timescale 1ns/1ps

`include "ahb2apb_defines18.v"

module ahb2apb18
(
  // AHB18 signals18
  hclk18,
  hreset_n18,
  hsel18,
  haddr18,
  htrans18,
  hwdata18,
  hwrite18,
  hrdata18,
  hready18,
  hresp18,
  
  // APB18 signals18 common to all APB18 slaves18
  pclk18,
  preset_n18,
  paddr18,
  penable18,
  pwrite18,
  pwdata18
  
  // Slave18 0 signals18
  `ifdef APB_SLAVE018
  ,psel018
  ,pready018
  ,prdata018
  `endif
  
  // Slave18 1 signals18
  `ifdef APB_SLAVE118
  ,psel118
  ,pready118
  ,prdata118
  `endif
  
  // Slave18 2 signals18
  `ifdef APB_SLAVE218
  ,psel218
  ,pready218
  ,prdata218
  `endif
  
  // Slave18 3 signals18
  `ifdef APB_SLAVE318
  ,psel318
  ,pready318
  ,prdata318
  `endif
  
  // Slave18 4 signals18
  `ifdef APB_SLAVE418
  ,psel418
  ,pready418
  ,prdata418
  `endif
  
  // Slave18 5 signals18
  `ifdef APB_SLAVE518
  ,psel518
  ,pready518
  ,prdata518
  `endif
  
  // Slave18 6 signals18
  `ifdef APB_SLAVE618
  ,psel618
  ,pready618
  ,prdata618
  `endif
  
  // Slave18 7 signals18
  `ifdef APB_SLAVE718
  ,psel718
  ,pready718
  ,prdata718
  `endif
  
  // Slave18 8 signals18
  `ifdef APB_SLAVE818
  ,psel818
  ,pready818
  ,prdata818
  `endif
  
  // Slave18 9 signals18
  `ifdef APB_SLAVE918
  ,psel918
  ,pready918
  ,prdata918
  `endif
  
  // Slave18 10 signals18
  `ifdef APB_SLAVE1018
  ,psel1018
  ,pready1018
  ,prdata1018
  `endif
  
  // Slave18 11 signals18
  `ifdef APB_SLAVE1118
  ,psel1118
  ,pready1118
  ,prdata1118
  `endif
  
  // Slave18 12 signals18
  `ifdef APB_SLAVE1218
  ,psel1218
  ,pready1218
  ,prdata1218
  `endif
  
  // Slave18 13 signals18
  `ifdef APB_SLAVE1318
  ,psel1318
  ,pready1318
  ,prdata1318
  `endif
  
  // Slave18 14 signals18
  `ifdef APB_SLAVE1418
  ,psel1418
  ,pready1418
  ,prdata1418
  `endif
  
  // Slave18 15 signals18
  `ifdef APB_SLAVE1518
  ,psel1518
  ,pready1518
  ,prdata1518
  `endif
  
);

parameter 
  APB_SLAVE0_START_ADDR18  = 32'h00000000,
  APB_SLAVE0_END_ADDR18    = 32'h00000000,
  APB_SLAVE1_START_ADDR18  = 32'h00000000,
  APB_SLAVE1_END_ADDR18    = 32'h00000000,
  APB_SLAVE2_START_ADDR18  = 32'h00000000,
  APB_SLAVE2_END_ADDR18    = 32'h00000000,
  APB_SLAVE3_START_ADDR18  = 32'h00000000,
  APB_SLAVE3_END_ADDR18    = 32'h00000000,
  APB_SLAVE4_START_ADDR18  = 32'h00000000,
  APB_SLAVE4_END_ADDR18    = 32'h00000000,
  APB_SLAVE5_START_ADDR18  = 32'h00000000,
  APB_SLAVE5_END_ADDR18    = 32'h00000000,
  APB_SLAVE6_START_ADDR18  = 32'h00000000,
  APB_SLAVE6_END_ADDR18    = 32'h00000000,
  APB_SLAVE7_START_ADDR18  = 32'h00000000,
  APB_SLAVE7_END_ADDR18    = 32'h00000000,
  APB_SLAVE8_START_ADDR18  = 32'h00000000,
  APB_SLAVE8_END_ADDR18    = 32'h00000000,
  APB_SLAVE9_START_ADDR18  = 32'h00000000,
  APB_SLAVE9_END_ADDR18    = 32'h00000000,
  APB_SLAVE10_START_ADDR18  = 32'h00000000,
  APB_SLAVE10_END_ADDR18    = 32'h00000000,
  APB_SLAVE11_START_ADDR18  = 32'h00000000,
  APB_SLAVE11_END_ADDR18    = 32'h00000000,
  APB_SLAVE12_START_ADDR18  = 32'h00000000,
  APB_SLAVE12_END_ADDR18    = 32'h00000000,
  APB_SLAVE13_START_ADDR18  = 32'h00000000,
  APB_SLAVE13_END_ADDR18    = 32'h00000000,
  APB_SLAVE14_START_ADDR18  = 32'h00000000,
  APB_SLAVE14_END_ADDR18    = 32'h00000000,
  APB_SLAVE15_START_ADDR18  = 32'h00000000,
  APB_SLAVE15_END_ADDR18    = 32'h00000000;

  // AHB18 signals18
input        hclk18;
input        hreset_n18;
input        hsel18;
input[31:0]  haddr18;
input[1:0]   htrans18;
input[31:0]  hwdata18;
input        hwrite18;
output[31:0] hrdata18;
reg   [31:0] hrdata18;
output       hready18;
output[1:0]  hresp18;
  
  // APB18 signals18 common to all APB18 slaves18
input       pclk18;
input       preset_n18;
output[31:0] paddr18;
reg   [31:0] paddr18;
output       penable18;
reg          penable18;
output       pwrite18;
reg          pwrite18;
output[31:0] pwdata18;
  
  // Slave18 0 signals18
`ifdef APB_SLAVE018
  output      psel018;
  input       pready018;
  input[31:0] prdata018;
`endif
  
  // Slave18 1 signals18
`ifdef APB_SLAVE118
  output      psel118;
  input       pready118;
  input[31:0] prdata118;
`endif
  
  // Slave18 2 signals18
`ifdef APB_SLAVE218
  output      psel218;
  input       pready218;
  input[31:0] prdata218;
`endif
  
  // Slave18 3 signals18
`ifdef APB_SLAVE318
  output      psel318;
  input       pready318;
  input[31:0] prdata318;
`endif
  
  // Slave18 4 signals18
`ifdef APB_SLAVE418
  output      psel418;
  input       pready418;
  input[31:0] prdata418;
`endif
  
  // Slave18 5 signals18
`ifdef APB_SLAVE518
  output      psel518;
  input       pready518;
  input[31:0] prdata518;
`endif
  
  // Slave18 6 signals18
`ifdef APB_SLAVE618
  output      psel618;
  input       pready618;
  input[31:0] prdata618;
`endif
  
  // Slave18 7 signals18
`ifdef APB_SLAVE718
  output      psel718;
  input       pready718;
  input[31:0] prdata718;
`endif
  
  // Slave18 8 signals18
`ifdef APB_SLAVE818
  output      psel818;
  input       pready818;
  input[31:0] prdata818;
`endif
  
  // Slave18 9 signals18
`ifdef APB_SLAVE918
  output      psel918;
  input       pready918;
  input[31:0] prdata918;
`endif
  
  // Slave18 10 signals18
`ifdef APB_SLAVE1018
  output      psel1018;
  input       pready1018;
  input[31:0] prdata1018;
`endif
  
  // Slave18 11 signals18
`ifdef APB_SLAVE1118
  output      psel1118;
  input       pready1118;
  input[31:0] prdata1118;
`endif
  
  // Slave18 12 signals18
`ifdef APB_SLAVE1218
  output      psel1218;
  input       pready1218;
  input[31:0] prdata1218;
`endif
  
  // Slave18 13 signals18
`ifdef APB_SLAVE1318
  output      psel1318;
  input       pready1318;
  input[31:0] prdata1318;
`endif
  
  // Slave18 14 signals18
`ifdef APB_SLAVE1418
  output      psel1418;
  input       pready1418;
  input[31:0] prdata1418;
`endif
  
  // Slave18 15 signals18
`ifdef APB_SLAVE1518
  output      psel1518;
  input       pready1518;
  input[31:0] prdata1518;
`endif
 
reg         ahb_addr_phase18;
reg         ahb_data_phase18;
wire        valid_ahb_trans18;
wire        pready_muxed18;
wire [31:0] prdata_muxed18;
reg  [31:0] haddr_reg18;
reg         hwrite_reg18;
reg  [2:0]  apb_state18;
wire [2:0]  apb_state_idle18;
wire [2:0]  apb_state_setup18;
wire [2:0]  apb_state_access18;
reg  [15:0] slave_select18;
wire [15:0] pready_vector18;
reg  [15:0] psel_vector18;
wire [31:0] prdata0_q18;
wire [31:0] prdata1_q18;
wire [31:0] prdata2_q18;
wire [31:0] prdata3_q18;
wire [31:0] prdata4_q18;
wire [31:0] prdata5_q18;
wire [31:0] prdata6_q18;
wire [31:0] prdata7_q18;
wire [31:0] prdata8_q18;
wire [31:0] prdata9_q18;
wire [31:0] prdata10_q18;
wire [31:0] prdata11_q18;
wire [31:0] prdata12_q18;
wire [31:0] prdata13_q18;
wire [31:0] prdata14_q18;
wire [31:0] prdata15_q18;

// assign pclk18     = hclk18;
// assign preset_n18 = hreset_n18;
assign hready18   = ahb_addr_phase18;
assign pwdata18   = hwdata18;
assign hresp18  = 2'b00;

// Respond18 to NONSEQ18 or SEQ transfers18
assign valid_ahb_trans18 = ((htrans18 == 2'b10) || (htrans18 == 2'b11)) && (hsel18 == 1'b1);

always @(posedge hclk18) begin
  if (hreset_n18 == 1'b0) begin
    ahb_addr_phase18 <= 1'b1;
    ahb_data_phase18 <= 1'b0;
    haddr_reg18      <= 'b0;
    hwrite_reg18     <= 1'b0;
    hrdata18         <= 'b0;
  end
  else begin
    if (ahb_addr_phase18 == 1'b1 && valid_ahb_trans18 == 1'b1) begin
      ahb_addr_phase18 <= 1'b0;
      ahb_data_phase18 <= 1'b1;
      haddr_reg18      <= haddr18;
      hwrite_reg18     <= hwrite18;
    end
    if (ahb_data_phase18 == 1'b1 && pready_muxed18 == 1'b1 && apb_state18 == apb_state_access18) begin
      ahb_addr_phase18 <= 1'b1;
      ahb_data_phase18 <= 1'b0;
      hrdata18         <= prdata_muxed18;
    end
  end
end

// APB18 state machine18 state definitions18
assign apb_state_idle18   = 3'b001;
assign apb_state_setup18  = 3'b010;
assign apb_state_access18 = 3'b100;

// APB18 state machine18
always @(posedge hclk18 or negedge hreset_n18) begin
  if (hreset_n18 == 1'b0) begin
    apb_state18   <= apb_state_idle18;
    psel_vector18 <= 1'b0;
    penable18     <= 1'b0;
    paddr18       <= 1'b0;
    pwrite18      <= 1'b0;
  end  
  else begin
    
    // IDLE18 -> SETUP18
    if (apb_state18 == apb_state_idle18) begin
      if (ahb_data_phase18 == 1'b1) begin
        apb_state18   <= apb_state_setup18;
        psel_vector18 <= slave_select18;
        paddr18       <= haddr_reg18;
        pwrite18      <= hwrite_reg18;
      end  
    end
    
    // SETUP18 -> TRANSFER18
    if (apb_state18 == apb_state_setup18) begin
      apb_state18 <= apb_state_access18;
      penable18   <= 1'b1;
    end
    
    // TRANSFER18 -> SETUP18 or
    // TRANSFER18 -> IDLE18
    if (apb_state18 == apb_state_access18) begin
      if (pready_muxed18 == 1'b1) begin
      
        // TRANSFER18 -> SETUP18
        if (valid_ahb_trans18 == 1'b1) begin
          apb_state18   <= apb_state_setup18;
          penable18     <= 1'b0;
          psel_vector18 <= slave_select18;
          paddr18       <= haddr_reg18;
          pwrite18      <= hwrite_reg18;
        end  
        
        // TRANSFER18 -> IDLE18
        else begin
          apb_state18   <= apb_state_idle18;      
          penable18     <= 1'b0;
          psel_vector18 <= 'b0;
        end  
      end
    end
    
  end
end

always @(posedge hclk18 or negedge hreset_n18) begin
  if (hreset_n18 == 1'b0)
    slave_select18 <= 'b0;
  else begin  
  `ifdef APB_SLAVE018
     slave_select18[0]   <= valid_ahb_trans18 && (haddr18 >= APB_SLAVE0_START_ADDR18)  && (haddr18 <= APB_SLAVE0_END_ADDR18);
   `else
     slave_select18[0]   <= 1'b0;
   `endif
   
   `ifdef APB_SLAVE118
     slave_select18[1]   <= valid_ahb_trans18 && (haddr18 >= APB_SLAVE1_START_ADDR18)  && (haddr18 <= APB_SLAVE1_END_ADDR18);
   `else
     slave_select18[1]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE218  
     slave_select18[2]   <= valid_ahb_trans18 && (haddr18 >= APB_SLAVE2_START_ADDR18)  && (haddr18 <= APB_SLAVE2_END_ADDR18);
   `else
     slave_select18[2]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE318  
     slave_select18[3]   <= valid_ahb_trans18 && (haddr18 >= APB_SLAVE3_START_ADDR18)  && (haddr18 <= APB_SLAVE3_END_ADDR18);
   `else
     slave_select18[3]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE418  
     slave_select18[4]   <= valid_ahb_trans18 && (haddr18 >= APB_SLAVE4_START_ADDR18)  && (haddr18 <= APB_SLAVE4_END_ADDR18);
   `else
     slave_select18[4]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE518  
     slave_select18[5]   <= valid_ahb_trans18 && (haddr18 >= APB_SLAVE5_START_ADDR18)  && (haddr18 <= APB_SLAVE5_END_ADDR18);
   `else
     slave_select18[5]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE618  
     slave_select18[6]   <= valid_ahb_trans18 && (haddr18 >= APB_SLAVE6_START_ADDR18)  && (haddr18 <= APB_SLAVE6_END_ADDR18);
   `else
     slave_select18[6]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE718  
     slave_select18[7]   <= valid_ahb_trans18 && (haddr18 >= APB_SLAVE7_START_ADDR18)  && (haddr18 <= APB_SLAVE7_END_ADDR18);
   `else
     slave_select18[7]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE818  
     slave_select18[8]   <= valid_ahb_trans18 && (haddr18 >= APB_SLAVE8_START_ADDR18)  && (haddr18 <= APB_SLAVE8_END_ADDR18);
   `else
     slave_select18[8]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE918  
     slave_select18[9]   <= valid_ahb_trans18 && (haddr18 >= APB_SLAVE9_START_ADDR18)  && (haddr18 <= APB_SLAVE9_END_ADDR18);
   `else
     slave_select18[9]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1018  
     slave_select18[10]  <= valid_ahb_trans18 && (haddr18 >= APB_SLAVE10_START_ADDR18) && (haddr18 <= APB_SLAVE10_END_ADDR18);
   `else
     slave_select18[10]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1118  
     slave_select18[11]  <= valid_ahb_trans18 && (haddr18 >= APB_SLAVE11_START_ADDR18) && (haddr18 <= APB_SLAVE11_END_ADDR18);
   `else
     slave_select18[11]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1218  
     slave_select18[12]  <= valid_ahb_trans18 && (haddr18 >= APB_SLAVE12_START_ADDR18) && (haddr18 <= APB_SLAVE12_END_ADDR18);
   `else
     slave_select18[12]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1318  
     slave_select18[13]  <= valid_ahb_trans18 && (haddr18 >= APB_SLAVE13_START_ADDR18) && (haddr18 <= APB_SLAVE13_END_ADDR18);
   `else
     slave_select18[13]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1418  
     slave_select18[14]  <= valid_ahb_trans18 && (haddr18 >= APB_SLAVE14_START_ADDR18) && (haddr18 <= APB_SLAVE14_END_ADDR18);
   `else
     slave_select18[14]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1518  
     slave_select18[15]  <= valid_ahb_trans18 && (haddr18 >= APB_SLAVE15_START_ADDR18) && (haddr18 <= APB_SLAVE15_END_ADDR18);
   `else
     slave_select18[15]   <= 1'b0;
   `endif  
  end
end

assign pready_muxed18 = |(psel_vector18 & pready_vector18);
assign prdata_muxed18 = prdata0_q18  | prdata1_q18  | prdata2_q18  | prdata3_q18  |
                      prdata4_q18  | prdata5_q18  | prdata6_q18  | prdata7_q18  |
                      prdata8_q18  | prdata9_q18  | prdata10_q18 | prdata11_q18 |
                      prdata12_q18 | prdata13_q18 | prdata14_q18 | prdata15_q18 ;

`ifdef APB_SLAVE018
  assign psel018            = psel_vector18[0];
  assign pready_vector18[0] = pready018;
  assign prdata0_q18        = (psel018 == 1'b1) ? prdata018 : 'b0;
`else
  assign pready_vector18[0] = 1'b0;
  assign prdata0_q18        = 'b0;
`endif

`ifdef APB_SLAVE118
  assign psel118            = psel_vector18[1];
  assign pready_vector18[1] = pready118;
  assign prdata1_q18        = (psel118 == 1'b1) ? prdata118 : 'b0;
`else
  assign pready_vector18[1] = 1'b0;
  assign prdata1_q18        = 'b0;
`endif

`ifdef APB_SLAVE218
  assign psel218            = psel_vector18[2];
  assign pready_vector18[2] = pready218;
  assign prdata2_q18        = (psel218 == 1'b1) ? prdata218 : 'b0;
`else
  assign pready_vector18[2] = 1'b0;
  assign prdata2_q18        = 'b0;
`endif

`ifdef APB_SLAVE318
  assign psel318            = psel_vector18[3];
  assign pready_vector18[3] = pready318;
  assign prdata3_q18        = (psel318 == 1'b1) ? prdata318 : 'b0;
`else
  assign pready_vector18[3] = 1'b0;
  assign prdata3_q18        = 'b0;
`endif

`ifdef APB_SLAVE418
  assign psel418            = psel_vector18[4];
  assign pready_vector18[4] = pready418;
  assign prdata4_q18        = (psel418 == 1'b1) ? prdata418 : 'b0;
`else
  assign pready_vector18[4] = 1'b0;
  assign prdata4_q18        = 'b0;
`endif

`ifdef APB_SLAVE518
  assign psel518            = psel_vector18[5];
  assign pready_vector18[5] = pready518;
  assign prdata5_q18        = (psel518 == 1'b1) ? prdata518 : 'b0;
`else
  assign pready_vector18[5] = 1'b0;
  assign prdata5_q18        = 'b0;
`endif

`ifdef APB_SLAVE618
  assign psel618            = psel_vector18[6];
  assign pready_vector18[6] = pready618;
  assign prdata6_q18        = (psel618 == 1'b1) ? prdata618 : 'b0;
`else
  assign pready_vector18[6] = 1'b0;
  assign prdata6_q18        = 'b0;
`endif

`ifdef APB_SLAVE718
  assign psel718            = psel_vector18[7];
  assign pready_vector18[7] = pready718;
  assign prdata7_q18        = (psel718 == 1'b1) ? prdata718 : 'b0;
`else
  assign pready_vector18[7] = 1'b0;
  assign prdata7_q18        = 'b0;
`endif

`ifdef APB_SLAVE818
  assign psel818            = psel_vector18[8];
  assign pready_vector18[8] = pready818;
  assign prdata8_q18        = (psel818 == 1'b1) ? prdata818 : 'b0;
`else
  assign pready_vector18[8] = 1'b0;
  assign prdata8_q18        = 'b0;
`endif

`ifdef APB_SLAVE918
  assign psel918            = psel_vector18[9];
  assign pready_vector18[9] = pready918;
  assign prdata9_q18        = (psel918 == 1'b1) ? prdata918 : 'b0;
`else
  assign pready_vector18[9] = 1'b0;
  assign prdata9_q18        = 'b0;
`endif

`ifdef APB_SLAVE1018
  assign psel1018            = psel_vector18[10];
  assign pready_vector18[10] = pready1018;
  assign prdata10_q18        = (psel1018 == 1'b1) ? prdata1018 : 'b0;
`else
  assign pready_vector18[10] = 1'b0;
  assign prdata10_q18        = 'b0;
`endif

`ifdef APB_SLAVE1118
  assign psel1118            = psel_vector18[11];
  assign pready_vector18[11] = pready1118;
  assign prdata11_q18        = (psel1118 == 1'b1) ? prdata1118 : 'b0;
`else
  assign pready_vector18[11] = 1'b0;
  assign prdata11_q18        = 'b0;
`endif

`ifdef APB_SLAVE1218
  assign psel1218            = psel_vector18[12];
  assign pready_vector18[12] = pready1218;
  assign prdata12_q18        = (psel1218 == 1'b1) ? prdata1218 : 'b0;
`else
  assign pready_vector18[12] = 1'b0;
  assign prdata12_q18        = 'b0;
`endif

`ifdef APB_SLAVE1318
  assign psel1318            = psel_vector18[13];
  assign pready_vector18[13] = pready1318;
  assign prdata13_q18        = (psel1318 == 1'b1) ? prdata1318 : 'b0;
`else
  assign pready_vector18[13] = 1'b0;
  assign prdata13_q18        = 'b0;
`endif

`ifdef APB_SLAVE1418
  assign psel1418            = psel_vector18[14];
  assign pready_vector18[14] = pready1418;
  assign prdata14_q18        = (psel1418 == 1'b1) ? prdata1418 : 'b0;
`else
  assign pready_vector18[14] = 1'b0;
  assign prdata14_q18        = 'b0;
`endif

`ifdef APB_SLAVE1518
  assign psel1518            = psel_vector18[15];
  assign pready_vector18[15] = pready1518;
  assign prdata15_q18        = (psel1518 == 1'b1) ? prdata1518 : 'b0;
`else
  assign pready_vector18[15] = 1'b0;
  assign prdata15_q18        = 'b0;
`endif

endmodule
