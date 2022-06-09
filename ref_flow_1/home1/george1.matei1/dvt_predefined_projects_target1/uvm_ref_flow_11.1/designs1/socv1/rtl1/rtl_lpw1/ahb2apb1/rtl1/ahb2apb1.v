//File1 name   : ahb2apb1.v
//Title1       : 
//Created1     : 2010
//Description1 : Simple1 AHB1 to APB1 bridge1
//Notes1       : 
//----------------------------------------------------------------------
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------

`timescale 1ns/1ps

`include "ahb2apb_defines1.v"

module ahb2apb1
(
  // AHB1 signals1
  hclk1,
  hreset_n1,
  hsel1,
  haddr1,
  htrans1,
  hwdata1,
  hwrite1,
  hrdata1,
  hready1,
  hresp1,
  
  // APB1 signals1 common to all APB1 slaves1
  pclk1,
  preset_n1,
  paddr1,
  penable1,
  pwrite1,
  pwdata1
  
  // Slave1 0 signals1
  `ifdef APB_SLAVE01
  ,psel01
  ,pready01
  ,prdata01
  `endif
  
  // Slave1 1 signals1
  `ifdef APB_SLAVE11
  ,psel11
  ,pready11
  ,prdata11
  `endif
  
  // Slave1 2 signals1
  `ifdef APB_SLAVE21
  ,psel21
  ,pready21
  ,prdata21
  `endif
  
  // Slave1 3 signals1
  `ifdef APB_SLAVE31
  ,psel31
  ,pready31
  ,prdata31
  `endif
  
  // Slave1 4 signals1
  `ifdef APB_SLAVE41
  ,psel41
  ,pready41
  ,prdata41
  `endif
  
  // Slave1 5 signals1
  `ifdef APB_SLAVE51
  ,psel51
  ,pready51
  ,prdata51
  `endif
  
  // Slave1 6 signals1
  `ifdef APB_SLAVE61
  ,psel61
  ,pready61
  ,prdata61
  `endif
  
  // Slave1 7 signals1
  `ifdef APB_SLAVE71
  ,psel71
  ,pready71
  ,prdata71
  `endif
  
  // Slave1 8 signals1
  `ifdef APB_SLAVE81
  ,psel81
  ,pready81
  ,prdata81
  `endif
  
  // Slave1 9 signals1
  `ifdef APB_SLAVE91
  ,psel91
  ,pready91
  ,prdata91
  `endif
  
  // Slave1 10 signals1
  `ifdef APB_SLAVE101
  ,psel101
  ,pready101
  ,prdata101
  `endif
  
  // Slave1 11 signals1
  `ifdef APB_SLAVE111
  ,psel111
  ,pready111
  ,prdata111
  `endif
  
  // Slave1 12 signals1
  `ifdef APB_SLAVE121
  ,psel121
  ,pready121
  ,prdata121
  `endif
  
  // Slave1 13 signals1
  `ifdef APB_SLAVE131
  ,psel131
  ,pready131
  ,prdata131
  `endif
  
  // Slave1 14 signals1
  `ifdef APB_SLAVE141
  ,psel141
  ,pready141
  ,prdata141
  `endif
  
  // Slave1 15 signals1
  `ifdef APB_SLAVE151
  ,psel151
  ,pready151
  ,prdata151
  `endif
  
);

parameter 
  APB_SLAVE0_START_ADDR1  = 32'h00000000,
  APB_SLAVE0_END_ADDR1    = 32'h00000000,
  APB_SLAVE1_START_ADDR1  = 32'h00000000,
  APB_SLAVE1_END_ADDR1    = 32'h00000000,
  APB_SLAVE2_START_ADDR1  = 32'h00000000,
  APB_SLAVE2_END_ADDR1    = 32'h00000000,
  APB_SLAVE3_START_ADDR1  = 32'h00000000,
  APB_SLAVE3_END_ADDR1    = 32'h00000000,
  APB_SLAVE4_START_ADDR1  = 32'h00000000,
  APB_SLAVE4_END_ADDR1    = 32'h00000000,
  APB_SLAVE5_START_ADDR1  = 32'h00000000,
  APB_SLAVE5_END_ADDR1    = 32'h00000000,
  APB_SLAVE6_START_ADDR1  = 32'h00000000,
  APB_SLAVE6_END_ADDR1    = 32'h00000000,
  APB_SLAVE7_START_ADDR1  = 32'h00000000,
  APB_SLAVE7_END_ADDR1    = 32'h00000000,
  APB_SLAVE8_START_ADDR1  = 32'h00000000,
  APB_SLAVE8_END_ADDR1    = 32'h00000000,
  APB_SLAVE9_START_ADDR1  = 32'h00000000,
  APB_SLAVE9_END_ADDR1    = 32'h00000000,
  APB_SLAVE10_START_ADDR1  = 32'h00000000,
  APB_SLAVE10_END_ADDR1    = 32'h00000000,
  APB_SLAVE11_START_ADDR1  = 32'h00000000,
  APB_SLAVE11_END_ADDR1    = 32'h00000000,
  APB_SLAVE12_START_ADDR1  = 32'h00000000,
  APB_SLAVE12_END_ADDR1    = 32'h00000000,
  APB_SLAVE13_START_ADDR1  = 32'h00000000,
  APB_SLAVE13_END_ADDR1    = 32'h00000000,
  APB_SLAVE14_START_ADDR1  = 32'h00000000,
  APB_SLAVE14_END_ADDR1    = 32'h00000000,
  APB_SLAVE15_START_ADDR1  = 32'h00000000,
  APB_SLAVE15_END_ADDR1    = 32'h00000000;

  // AHB1 signals1
input        hclk1;
input        hreset_n1;
input        hsel1;
input[31:0]  haddr1;
input[1:0]   htrans1;
input[31:0]  hwdata1;
input        hwrite1;
output[31:0] hrdata1;
reg   [31:0] hrdata1;
output       hready1;
output[1:0]  hresp1;
  
  // APB1 signals1 common to all APB1 slaves1
input       pclk1;
input       preset_n1;
output[31:0] paddr1;
reg   [31:0] paddr1;
output       penable1;
reg          penable1;
output       pwrite1;
reg          pwrite1;
output[31:0] pwdata1;
  
  // Slave1 0 signals1
`ifdef APB_SLAVE01
  output      psel01;
  input       pready01;
  input[31:0] prdata01;
`endif
  
  // Slave1 1 signals1
`ifdef APB_SLAVE11
  output      psel11;
  input       pready11;
  input[31:0] prdata11;
`endif
  
  // Slave1 2 signals1
`ifdef APB_SLAVE21
  output      psel21;
  input       pready21;
  input[31:0] prdata21;
`endif
  
  // Slave1 3 signals1
`ifdef APB_SLAVE31
  output      psel31;
  input       pready31;
  input[31:0] prdata31;
`endif
  
  // Slave1 4 signals1
`ifdef APB_SLAVE41
  output      psel41;
  input       pready41;
  input[31:0] prdata41;
`endif
  
  // Slave1 5 signals1
`ifdef APB_SLAVE51
  output      psel51;
  input       pready51;
  input[31:0] prdata51;
`endif
  
  // Slave1 6 signals1
`ifdef APB_SLAVE61
  output      psel61;
  input       pready61;
  input[31:0] prdata61;
`endif
  
  // Slave1 7 signals1
`ifdef APB_SLAVE71
  output      psel71;
  input       pready71;
  input[31:0] prdata71;
`endif
  
  // Slave1 8 signals1
`ifdef APB_SLAVE81
  output      psel81;
  input       pready81;
  input[31:0] prdata81;
`endif
  
  // Slave1 9 signals1
`ifdef APB_SLAVE91
  output      psel91;
  input       pready91;
  input[31:0] prdata91;
`endif
  
  // Slave1 10 signals1
`ifdef APB_SLAVE101
  output      psel101;
  input       pready101;
  input[31:0] prdata101;
`endif
  
  // Slave1 11 signals1
`ifdef APB_SLAVE111
  output      psel111;
  input       pready111;
  input[31:0] prdata111;
`endif
  
  // Slave1 12 signals1
`ifdef APB_SLAVE121
  output      psel121;
  input       pready121;
  input[31:0] prdata121;
`endif
  
  // Slave1 13 signals1
`ifdef APB_SLAVE131
  output      psel131;
  input       pready131;
  input[31:0] prdata131;
`endif
  
  // Slave1 14 signals1
`ifdef APB_SLAVE141
  output      psel141;
  input       pready141;
  input[31:0] prdata141;
`endif
  
  // Slave1 15 signals1
`ifdef APB_SLAVE151
  output      psel151;
  input       pready151;
  input[31:0] prdata151;
`endif
 
reg         ahb_addr_phase1;
reg         ahb_data_phase1;
wire        valid_ahb_trans1;
wire        pready_muxed1;
wire [31:0] prdata_muxed1;
reg  [31:0] haddr_reg1;
reg         hwrite_reg1;
reg  [2:0]  apb_state1;
wire [2:0]  apb_state_idle1;
wire [2:0]  apb_state_setup1;
wire [2:0]  apb_state_access1;
reg  [15:0] slave_select1;
wire [15:0] pready_vector1;
reg  [15:0] psel_vector1;
wire [31:0] prdata0_q1;
wire [31:0] prdata1_q1;
wire [31:0] prdata2_q1;
wire [31:0] prdata3_q1;
wire [31:0] prdata4_q1;
wire [31:0] prdata5_q1;
wire [31:0] prdata6_q1;
wire [31:0] prdata7_q1;
wire [31:0] prdata8_q1;
wire [31:0] prdata9_q1;
wire [31:0] prdata10_q1;
wire [31:0] prdata11_q1;
wire [31:0] prdata12_q1;
wire [31:0] prdata13_q1;
wire [31:0] prdata14_q1;
wire [31:0] prdata15_q1;

// assign pclk1     = hclk1;
// assign preset_n1 = hreset_n1;
assign hready1   = ahb_addr_phase1;
assign pwdata1   = hwdata1;
assign hresp1  = 2'b00;

// Respond1 to NONSEQ1 or SEQ transfers1
assign valid_ahb_trans1 = ((htrans1 == 2'b10) || (htrans1 == 2'b11)) && (hsel1 == 1'b1);

always @(posedge hclk1) begin
  if (hreset_n1 == 1'b0) begin
    ahb_addr_phase1 <= 1'b1;
    ahb_data_phase1 <= 1'b0;
    haddr_reg1      <= 'b0;
    hwrite_reg1     <= 1'b0;
    hrdata1         <= 'b0;
  end
  else begin
    if (ahb_addr_phase1 == 1'b1 && valid_ahb_trans1 == 1'b1) begin
      ahb_addr_phase1 <= 1'b0;
      ahb_data_phase1 <= 1'b1;
      haddr_reg1      <= haddr1;
      hwrite_reg1     <= hwrite1;
    end
    if (ahb_data_phase1 == 1'b1 && pready_muxed1 == 1'b1 && apb_state1 == apb_state_access1) begin
      ahb_addr_phase1 <= 1'b1;
      ahb_data_phase1 <= 1'b0;
      hrdata1         <= prdata_muxed1;
    end
  end
end

// APB1 state machine1 state definitions1
assign apb_state_idle1   = 3'b001;
assign apb_state_setup1  = 3'b010;
assign apb_state_access1 = 3'b100;

// APB1 state machine1
always @(posedge hclk1 or negedge hreset_n1) begin
  if (hreset_n1 == 1'b0) begin
    apb_state1   <= apb_state_idle1;
    psel_vector1 <= 1'b0;
    penable1     <= 1'b0;
    paddr1       <= 1'b0;
    pwrite1      <= 1'b0;
  end  
  else begin
    
    // IDLE1 -> SETUP1
    if (apb_state1 == apb_state_idle1) begin
      if (ahb_data_phase1 == 1'b1) begin
        apb_state1   <= apb_state_setup1;
        psel_vector1 <= slave_select1;
        paddr1       <= haddr_reg1;
        pwrite1      <= hwrite_reg1;
      end  
    end
    
    // SETUP1 -> TRANSFER1
    if (apb_state1 == apb_state_setup1) begin
      apb_state1 <= apb_state_access1;
      penable1   <= 1'b1;
    end
    
    // TRANSFER1 -> SETUP1 or
    // TRANSFER1 -> IDLE1
    if (apb_state1 == apb_state_access1) begin
      if (pready_muxed1 == 1'b1) begin
      
        // TRANSFER1 -> SETUP1
        if (valid_ahb_trans1 == 1'b1) begin
          apb_state1   <= apb_state_setup1;
          penable1     <= 1'b0;
          psel_vector1 <= slave_select1;
          paddr1       <= haddr_reg1;
          pwrite1      <= hwrite_reg1;
        end  
        
        // TRANSFER1 -> IDLE1
        else begin
          apb_state1   <= apb_state_idle1;      
          penable1     <= 1'b0;
          psel_vector1 <= 'b0;
        end  
      end
    end
    
  end
end

always @(posedge hclk1 or negedge hreset_n1) begin
  if (hreset_n1 == 1'b0)
    slave_select1 <= 'b0;
  else begin  
  `ifdef APB_SLAVE01
     slave_select1[0]   <= valid_ahb_trans1 && (haddr1 >= APB_SLAVE0_START_ADDR1)  && (haddr1 <= APB_SLAVE0_END_ADDR1);
   `else
     slave_select1[0]   <= 1'b0;
   `endif
   
   `ifdef APB_SLAVE11
     slave_select1[1]   <= valid_ahb_trans1 && (haddr1 >= APB_SLAVE1_START_ADDR1)  && (haddr1 <= APB_SLAVE1_END_ADDR1);
   `else
     slave_select1[1]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE21  
     slave_select1[2]   <= valid_ahb_trans1 && (haddr1 >= APB_SLAVE2_START_ADDR1)  && (haddr1 <= APB_SLAVE2_END_ADDR1);
   `else
     slave_select1[2]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE31  
     slave_select1[3]   <= valid_ahb_trans1 && (haddr1 >= APB_SLAVE3_START_ADDR1)  && (haddr1 <= APB_SLAVE3_END_ADDR1);
   `else
     slave_select1[3]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE41  
     slave_select1[4]   <= valid_ahb_trans1 && (haddr1 >= APB_SLAVE4_START_ADDR1)  && (haddr1 <= APB_SLAVE4_END_ADDR1);
   `else
     slave_select1[4]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE51  
     slave_select1[5]   <= valid_ahb_trans1 && (haddr1 >= APB_SLAVE5_START_ADDR1)  && (haddr1 <= APB_SLAVE5_END_ADDR1);
   `else
     slave_select1[5]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE61  
     slave_select1[6]   <= valid_ahb_trans1 && (haddr1 >= APB_SLAVE6_START_ADDR1)  && (haddr1 <= APB_SLAVE6_END_ADDR1);
   `else
     slave_select1[6]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE71  
     slave_select1[7]   <= valid_ahb_trans1 && (haddr1 >= APB_SLAVE7_START_ADDR1)  && (haddr1 <= APB_SLAVE7_END_ADDR1);
   `else
     slave_select1[7]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE81  
     slave_select1[8]   <= valid_ahb_trans1 && (haddr1 >= APB_SLAVE8_START_ADDR1)  && (haddr1 <= APB_SLAVE8_END_ADDR1);
   `else
     slave_select1[8]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE91  
     slave_select1[9]   <= valid_ahb_trans1 && (haddr1 >= APB_SLAVE9_START_ADDR1)  && (haddr1 <= APB_SLAVE9_END_ADDR1);
   `else
     slave_select1[9]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE101  
     slave_select1[10]  <= valid_ahb_trans1 && (haddr1 >= APB_SLAVE10_START_ADDR1) && (haddr1 <= APB_SLAVE10_END_ADDR1);
   `else
     slave_select1[10]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE111  
     slave_select1[11]  <= valid_ahb_trans1 && (haddr1 >= APB_SLAVE11_START_ADDR1) && (haddr1 <= APB_SLAVE11_END_ADDR1);
   `else
     slave_select1[11]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE121  
     slave_select1[12]  <= valid_ahb_trans1 && (haddr1 >= APB_SLAVE12_START_ADDR1) && (haddr1 <= APB_SLAVE12_END_ADDR1);
   `else
     slave_select1[12]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE131  
     slave_select1[13]  <= valid_ahb_trans1 && (haddr1 >= APB_SLAVE13_START_ADDR1) && (haddr1 <= APB_SLAVE13_END_ADDR1);
   `else
     slave_select1[13]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE141  
     slave_select1[14]  <= valid_ahb_trans1 && (haddr1 >= APB_SLAVE14_START_ADDR1) && (haddr1 <= APB_SLAVE14_END_ADDR1);
   `else
     slave_select1[14]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE151  
     slave_select1[15]  <= valid_ahb_trans1 && (haddr1 >= APB_SLAVE15_START_ADDR1) && (haddr1 <= APB_SLAVE15_END_ADDR1);
   `else
     slave_select1[15]   <= 1'b0;
   `endif  
  end
end

assign pready_muxed1 = |(psel_vector1 & pready_vector1);
assign prdata_muxed1 = prdata0_q1  | prdata1_q1  | prdata2_q1  | prdata3_q1  |
                      prdata4_q1  | prdata5_q1  | prdata6_q1  | prdata7_q1  |
                      prdata8_q1  | prdata9_q1  | prdata10_q1 | prdata11_q1 |
                      prdata12_q1 | prdata13_q1 | prdata14_q1 | prdata15_q1 ;

`ifdef APB_SLAVE01
  assign psel01            = psel_vector1[0];
  assign pready_vector1[0] = pready01;
  assign prdata0_q1        = (psel01 == 1'b1) ? prdata01 : 'b0;
`else
  assign pready_vector1[0] = 1'b0;
  assign prdata0_q1        = 'b0;
`endif

`ifdef APB_SLAVE11
  assign psel11            = psel_vector1[1];
  assign pready_vector1[1] = pready11;
  assign prdata1_q1        = (psel11 == 1'b1) ? prdata11 : 'b0;
`else
  assign pready_vector1[1] = 1'b0;
  assign prdata1_q1        = 'b0;
`endif

`ifdef APB_SLAVE21
  assign psel21            = psel_vector1[2];
  assign pready_vector1[2] = pready21;
  assign prdata2_q1        = (psel21 == 1'b1) ? prdata21 : 'b0;
`else
  assign pready_vector1[2] = 1'b0;
  assign prdata2_q1        = 'b0;
`endif

`ifdef APB_SLAVE31
  assign psel31            = psel_vector1[3];
  assign pready_vector1[3] = pready31;
  assign prdata3_q1        = (psel31 == 1'b1) ? prdata31 : 'b0;
`else
  assign pready_vector1[3] = 1'b0;
  assign prdata3_q1        = 'b0;
`endif

`ifdef APB_SLAVE41
  assign psel41            = psel_vector1[4];
  assign pready_vector1[4] = pready41;
  assign prdata4_q1        = (psel41 == 1'b1) ? prdata41 : 'b0;
`else
  assign pready_vector1[4] = 1'b0;
  assign prdata4_q1        = 'b0;
`endif

`ifdef APB_SLAVE51
  assign psel51            = psel_vector1[5];
  assign pready_vector1[5] = pready51;
  assign prdata5_q1        = (psel51 == 1'b1) ? prdata51 : 'b0;
`else
  assign pready_vector1[5] = 1'b0;
  assign prdata5_q1        = 'b0;
`endif

`ifdef APB_SLAVE61
  assign psel61            = psel_vector1[6];
  assign pready_vector1[6] = pready61;
  assign prdata6_q1        = (psel61 == 1'b1) ? prdata61 : 'b0;
`else
  assign pready_vector1[6] = 1'b0;
  assign prdata6_q1        = 'b0;
`endif

`ifdef APB_SLAVE71
  assign psel71            = psel_vector1[7];
  assign pready_vector1[7] = pready71;
  assign prdata7_q1        = (psel71 == 1'b1) ? prdata71 : 'b0;
`else
  assign pready_vector1[7] = 1'b0;
  assign prdata7_q1        = 'b0;
`endif

`ifdef APB_SLAVE81
  assign psel81            = psel_vector1[8];
  assign pready_vector1[8] = pready81;
  assign prdata8_q1        = (psel81 == 1'b1) ? prdata81 : 'b0;
`else
  assign pready_vector1[8] = 1'b0;
  assign prdata8_q1        = 'b0;
`endif

`ifdef APB_SLAVE91
  assign psel91            = psel_vector1[9];
  assign pready_vector1[9] = pready91;
  assign prdata9_q1        = (psel91 == 1'b1) ? prdata91 : 'b0;
`else
  assign pready_vector1[9] = 1'b0;
  assign prdata9_q1        = 'b0;
`endif

`ifdef APB_SLAVE101
  assign psel101            = psel_vector1[10];
  assign pready_vector1[10] = pready101;
  assign prdata10_q1        = (psel101 == 1'b1) ? prdata101 : 'b0;
`else
  assign pready_vector1[10] = 1'b0;
  assign prdata10_q1        = 'b0;
`endif

`ifdef APB_SLAVE111
  assign psel111            = psel_vector1[11];
  assign pready_vector1[11] = pready111;
  assign prdata11_q1        = (psel111 == 1'b1) ? prdata111 : 'b0;
`else
  assign pready_vector1[11] = 1'b0;
  assign prdata11_q1        = 'b0;
`endif

`ifdef APB_SLAVE121
  assign psel121            = psel_vector1[12];
  assign pready_vector1[12] = pready121;
  assign prdata12_q1        = (psel121 == 1'b1) ? prdata121 : 'b0;
`else
  assign pready_vector1[12] = 1'b0;
  assign prdata12_q1        = 'b0;
`endif

`ifdef APB_SLAVE131
  assign psel131            = psel_vector1[13];
  assign pready_vector1[13] = pready131;
  assign prdata13_q1        = (psel131 == 1'b1) ? prdata131 : 'b0;
`else
  assign pready_vector1[13] = 1'b0;
  assign prdata13_q1        = 'b0;
`endif

`ifdef APB_SLAVE141
  assign psel141            = psel_vector1[14];
  assign pready_vector1[14] = pready141;
  assign prdata14_q1        = (psel141 == 1'b1) ? prdata141 : 'b0;
`else
  assign pready_vector1[14] = 1'b0;
  assign prdata14_q1        = 'b0;
`endif

`ifdef APB_SLAVE151
  assign psel151            = psel_vector1[15];
  assign pready_vector1[15] = pready151;
  assign prdata15_q1        = (psel151 == 1'b1) ? prdata151 : 'b0;
`else
  assign pready_vector1[15] = 1'b0;
  assign prdata15_q1        = 'b0;
`endif

endmodule
