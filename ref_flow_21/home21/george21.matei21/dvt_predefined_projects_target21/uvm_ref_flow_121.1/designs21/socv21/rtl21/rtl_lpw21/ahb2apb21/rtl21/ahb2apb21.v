//File21 name   : ahb2apb21.v
//Title21       : 
//Created21     : 2010
//Description21 : Simple21 AHB21 to APB21 bridge21
//Notes21       : 
//----------------------------------------------------------------------
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------

`timescale 1ns/1ps

`include "ahb2apb_defines21.v"

module ahb2apb21
(
  // AHB21 signals21
  hclk21,
  hreset_n21,
  hsel21,
  haddr21,
  htrans21,
  hwdata21,
  hwrite21,
  hrdata21,
  hready21,
  hresp21,
  
  // APB21 signals21 common to all APB21 slaves21
  pclk21,
  preset_n21,
  paddr21,
  penable21,
  pwrite21,
  pwdata21
  
  // Slave21 0 signals21
  `ifdef APB_SLAVE021
  ,psel021
  ,pready021
  ,prdata021
  `endif
  
  // Slave21 1 signals21
  `ifdef APB_SLAVE121
  ,psel121
  ,pready121
  ,prdata121
  `endif
  
  // Slave21 2 signals21
  `ifdef APB_SLAVE221
  ,psel221
  ,pready221
  ,prdata221
  `endif
  
  // Slave21 3 signals21
  `ifdef APB_SLAVE321
  ,psel321
  ,pready321
  ,prdata321
  `endif
  
  // Slave21 4 signals21
  `ifdef APB_SLAVE421
  ,psel421
  ,pready421
  ,prdata421
  `endif
  
  // Slave21 5 signals21
  `ifdef APB_SLAVE521
  ,psel521
  ,pready521
  ,prdata521
  `endif
  
  // Slave21 6 signals21
  `ifdef APB_SLAVE621
  ,psel621
  ,pready621
  ,prdata621
  `endif
  
  // Slave21 7 signals21
  `ifdef APB_SLAVE721
  ,psel721
  ,pready721
  ,prdata721
  `endif
  
  // Slave21 8 signals21
  `ifdef APB_SLAVE821
  ,psel821
  ,pready821
  ,prdata821
  `endif
  
  // Slave21 9 signals21
  `ifdef APB_SLAVE921
  ,psel921
  ,pready921
  ,prdata921
  `endif
  
  // Slave21 10 signals21
  `ifdef APB_SLAVE1021
  ,psel1021
  ,pready1021
  ,prdata1021
  `endif
  
  // Slave21 11 signals21
  `ifdef APB_SLAVE1121
  ,psel1121
  ,pready1121
  ,prdata1121
  `endif
  
  // Slave21 12 signals21
  `ifdef APB_SLAVE1221
  ,psel1221
  ,pready1221
  ,prdata1221
  `endif
  
  // Slave21 13 signals21
  `ifdef APB_SLAVE1321
  ,psel1321
  ,pready1321
  ,prdata1321
  `endif
  
  // Slave21 14 signals21
  `ifdef APB_SLAVE1421
  ,psel1421
  ,pready1421
  ,prdata1421
  `endif
  
  // Slave21 15 signals21
  `ifdef APB_SLAVE1521
  ,psel1521
  ,pready1521
  ,prdata1521
  `endif
  
);

parameter 
  APB_SLAVE0_START_ADDR21  = 32'h00000000,
  APB_SLAVE0_END_ADDR21    = 32'h00000000,
  APB_SLAVE1_START_ADDR21  = 32'h00000000,
  APB_SLAVE1_END_ADDR21    = 32'h00000000,
  APB_SLAVE2_START_ADDR21  = 32'h00000000,
  APB_SLAVE2_END_ADDR21    = 32'h00000000,
  APB_SLAVE3_START_ADDR21  = 32'h00000000,
  APB_SLAVE3_END_ADDR21    = 32'h00000000,
  APB_SLAVE4_START_ADDR21  = 32'h00000000,
  APB_SLAVE4_END_ADDR21    = 32'h00000000,
  APB_SLAVE5_START_ADDR21  = 32'h00000000,
  APB_SLAVE5_END_ADDR21    = 32'h00000000,
  APB_SLAVE6_START_ADDR21  = 32'h00000000,
  APB_SLAVE6_END_ADDR21    = 32'h00000000,
  APB_SLAVE7_START_ADDR21  = 32'h00000000,
  APB_SLAVE7_END_ADDR21    = 32'h00000000,
  APB_SLAVE8_START_ADDR21  = 32'h00000000,
  APB_SLAVE8_END_ADDR21    = 32'h00000000,
  APB_SLAVE9_START_ADDR21  = 32'h00000000,
  APB_SLAVE9_END_ADDR21    = 32'h00000000,
  APB_SLAVE10_START_ADDR21  = 32'h00000000,
  APB_SLAVE10_END_ADDR21    = 32'h00000000,
  APB_SLAVE11_START_ADDR21  = 32'h00000000,
  APB_SLAVE11_END_ADDR21    = 32'h00000000,
  APB_SLAVE12_START_ADDR21  = 32'h00000000,
  APB_SLAVE12_END_ADDR21    = 32'h00000000,
  APB_SLAVE13_START_ADDR21  = 32'h00000000,
  APB_SLAVE13_END_ADDR21    = 32'h00000000,
  APB_SLAVE14_START_ADDR21  = 32'h00000000,
  APB_SLAVE14_END_ADDR21    = 32'h00000000,
  APB_SLAVE15_START_ADDR21  = 32'h00000000,
  APB_SLAVE15_END_ADDR21    = 32'h00000000;

  // AHB21 signals21
input        hclk21;
input        hreset_n21;
input        hsel21;
input[31:0]  haddr21;
input[1:0]   htrans21;
input[31:0]  hwdata21;
input        hwrite21;
output[31:0] hrdata21;
reg   [31:0] hrdata21;
output       hready21;
output[1:0]  hresp21;
  
  // APB21 signals21 common to all APB21 slaves21
input       pclk21;
input       preset_n21;
output[31:0] paddr21;
reg   [31:0] paddr21;
output       penable21;
reg          penable21;
output       pwrite21;
reg          pwrite21;
output[31:0] pwdata21;
  
  // Slave21 0 signals21
`ifdef APB_SLAVE021
  output      psel021;
  input       pready021;
  input[31:0] prdata021;
`endif
  
  // Slave21 1 signals21
`ifdef APB_SLAVE121
  output      psel121;
  input       pready121;
  input[31:0] prdata121;
`endif
  
  // Slave21 2 signals21
`ifdef APB_SLAVE221
  output      psel221;
  input       pready221;
  input[31:0] prdata221;
`endif
  
  // Slave21 3 signals21
`ifdef APB_SLAVE321
  output      psel321;
  input       pready321;
  input[31:0] prdata321;
`endif
  
  // Slave21 4 signals21
`ifdef APB_SLAVE421
  output      psel421;
  input       pready421;
  input[31:0] prdata421;
`endif
  
  // Slave21 5 signals21
`ifdef APB_SLAVE521
  output      psel521;
  input       pready521;
  input[31:0] prdata521;
`endif
  
  // Slave21 6 signals21
`ifdef APB_SLAVE621
  output      psel621;
  input       pready621;
  input[31:0] prdata621;
`endif
  
  // Slave21 7 signals21
`ifdef APB_SLAVE721
  output      psel721;
  input       pready721;
  input[31:0] prdata721;
`endif
  
  // Slave21 8 signals21
`ifdef APB_SLAVE821
  output      psel821;
  input       pready821;
  input[31:0] prdata821;
`endif
  
  // Slave21 9 signals21
`ifdef APB_SLAVE921
  output      psel921;
  input       pready921;
  input[31:0] prdata921;
`endif
  
  // Slave21 10 signals21
`ifdef APB_SLAVE1021
  output      psel1021;
  input       pready1021;
  input[31:0] prdata1021;
`endif
  
  // Slave21 11 signals21
`ifdef APB_SLAVE1121
  output      psel1121;
  input       pready1121;
  input[31:0] prdata1121;
`endif
  
  // Slave21 12 signals21
`ifdef APB_SLAVE1221
  output      psel1221;
  input       pready1221;
  input[31:0] prdata1221;
`endif
  
  // Slave21 13 signals21
`ifdef APB_SLAVE1321
  output      psel1321;
  input       pready1321;
  input[31:0] prdata1321;
`endif
  
  // Slave21 14 signals21
`ifdef APB_SLAVE1421
  output      psel1421;
  input       pready1421;
  input[31:0] prdata1421;
`endif
  
  // Slave21 15 signals21
`ifdef APB_SLAVE1521
  output      psel1521;
  input       pready1521;
  input[31:0] prdata1521;
`endif
 
reg         ahb_addr_phase21;
reg         ahb_data_phase21;
wire        valid_ahb_trans21;
wire        pready_muxed21;
wire [31:0] prdata_muxed21;
reg  [31:0] haddr_reg21;
reg         hwrite_reg21;
reg  [2:0]  apb_state21;
wire [2:0]  apb_state_idle21;
wire [2:0]  apb_state_setup21;
wire [2:0]  apb_state_access21;
reg  [15:0] slave_select21;
wire [15:0] pready_vector21;
reg  [15:0] psel_vector21;
wire [31:0] prdata0_q21;
wire [31:0] prdata1_q21;
wire [31:0] prdata2_q21;
wire [31:0] prdata3_q21;
wire [31:0] prdata4_q21;
wire [31:0] prdata5_q21;
wire [31:0] prdata6_q21;
wire [31:0] prdata7_q21;
wire [31:0] prdata8_q21;
wire [31:0] prdata9_q21;
wire [31:0] prdata10_q21;
wire [31:0] prdata11_q21;
wire [31:0] prdata12_q21;
wire [31:0] prdata13_q21;
wire [31:0] prdata14_q21;
wire [31:0] prdata15_q21;

// assign pclk21     = hclk21;
// assign preset_n21 = hreset_n21;
assign hready21   = ahb_addr_phase21;
assign pwdata21   = hwdata21;
assign hresp21  = 2'b00;

// Respond21 to NONSEQ21 or SEQ transfers21
assign valid_ahb_trans21 = ((htrans21 == 2'b10) || (htrans21 == 2'b11)) && (hsel21 == 1'b1);

always @(posedge hclk21) begin
  if (hreset_n21 == 1'b0) begin
    ahb_addr_phase21 <= 1'b1;
    ahb_data_phase21 <= 1'b0;
    haddr_reg21      <= 'b0;
    hwrite_reg21     <= 1'b0;
    hrdata21         <= 'b0;
  end
  else begin
    if (ahb_addr_phase21 == 1'b1 && valid_ahb_trans21 == 1'b1) begin
      ahb_addr_phase21 <= 1'b0;
      ahb_data_phase21 <= 1'b1;
      haddr_reg21      <= haddr21;
      hwrite_reg21     <= hwrite21;
    end
    if (ahb_data_phase21 == 1'b1 && pready_muxed21 == 1'b1 && apb_state21 == apb_state_access21) begin
      ahb_addr_phase21 <= 1'b1;
      ahb_data_phase21 <= 1'b0;
      hrdata21         <= prdata_muxed21;
    end
  end
end

// APB21 state machine21 state definitions21
assign apb_state_idle21   = 3'b001;
assign apb_state_setup21  = 3'b010;
assign apb_state_access21 = 3'b100;

// APB21 state machine21
always @(posedge hclk21 or negedge hreset_n21) begin
  if (hreset_n21 == 1'b0) begin
    apb_state21   <= apb_state_idle21;
    psel_vector21 <= 1'b0;
    penable21     <= 1'b0;
    paddr21       <= 1'b0;
    pwrite21      <= 1'b0;
  end  
  else begin
    
    // IDLE21 -> SETUP21
    if (apb_state21 == apb_state_idle21) begin
      if (ahb_data_phase21 == 1'b1) begin
        apb_state21   <= apb_state_setup21;
        psel_vector21 <= slave_select21;
        paddr21       <= haddr_reg21;
        pwrite21      <= hwrite_reg21;
      end  
    end
    
    // SETUP21 -> TRANSFER21
    if (apb_state21 == apb_state_setup21) begin
      apb_state21 <= apb_state_access21;
      penable21   <= 1'b1;
    end
    
    // TRANSFER21 -> SETUP21 or
    // TRANSFER21 -> IDLE21
    if (apb_state21 == apb_state_access21) begin
      if (pready_muxed21 == 1'b1) begin
      
        // TRANSFER21 -> SETUP21
        if (valid_ahb_trans21 == 1'b1) begin
          apb_state21   <= apb_state_setup21;
          penable21     <= 1'b0;
          psel_vector21 <= slave_select21;
          paddr21       <= haddr_reg21;
          pwrite21      <= hwrite_reg21;
        end  
        
        // TRANSFER21 -> IDLE21
        else begin
          apb_state21   <= apb_state_idle21;      
          penable21     <= 1'b0;
          psel_vector21 <= 'b0;
        end  
      end
    end
    
  end
end

always @(posedge hclk21 or negedge hreset_n21) begin
  if (hreset_n21 == 1'b0)
    slave_select21 <= 'b0;
  else begin  
  `ifdef APB_SLAVE021
     slave_select21[0]   <= valid_ahb_trans21 && (haddr21 >= APB_SLAVE0_START_ADDR21)  && (haddr21 <= APB_SLAVE0_END_ADDR21);
   `else
     slave_select21[0]   <= 1'b0;
   `endif
   
   `ifdef APB_SLAVE121
     slave_select21[1]   <= valid_ahb_trans21 && (haddr21 >= APB_SLAVE1_START_ADDR21)  && (haddr21 <= APB_SLAVE1_END_ADDR21);
   `else
     slave_select21[1]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE221  
     slave_select21[2]   <= valid_ahb_trans21 && (haddr21 >= APB_SLAVE2_START_ADDR21)  && (haddr21 <= APB_SLAVE2_END_ADDR21);
   `else
     slave_select21[2]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE321  
     slave_select21[3]   <= valid_ahb_trans21 && (haddr21 >= APB_SLAVE3_START_ADDR21)  && (haddr21 <= APB_SLAVE3_END_ADDR21);
   `else
     slave_select21[3]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE421  
     slave_select21[4]   <= valid_ahb_trans21 && (haddr21 >= APB_SLAVE4_START_ADDR21)  && (haddr21 <= APB_SLAVE4_END_ADDR21);
   `else
     slave_select21[4]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE521  
     slave_select21[5]   <= valid_ahb_trans21 && (haddr21 >= APB_SLAVE5_START_ADDR21)  && (haddr21 <= APB_SLAVE5_END_ADDR21);
   `else
     slave_select21[5]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE621  
     slave_select21[6]   <= valid_ahb_trans21 && (haddr21 >= APB_SLAVE6_START_ADDR21)  && (haddr21 <= APB_SLAVE6_END_ADDR21);
   `else
     slave_select21[6]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE721  
     slave_select21[7]   <= valid_ahb_trans21 && (haddr21 >= APB_SLAVE7_START_ADDR21)  && (haddr21 <= APB_SLAVE7_END_ADDR21);
   `else
     slave_select21[7]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE821  
     slave_select21[8]   <= valid_ahb_trans21 && (haddr21 >= APB_SLAVE8_START_ADDR21)  && (haddr21 <= APB_SLAVE8_END_ADDR21);
   `else
     slave_select21[8]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE921  
     slave_select21[9]   <= valid_ahb_trans21 && (haddr21 >= APB_SLAVE9_START_ADDR21)  && (haddr21 <= APB_SLAVE9_END_ADDR21);
   `else
     slave_select21[9]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1021  
     slave_select21[10]  <= valid_ahb_trans21 && (haddr21 >= APB_SLAVE10_START_ADDR21) && (haddr21 <= APB_SLAVE10_END_ADDR21);
   `else
     slave_select21[10]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1121  
     slave_select21[11]  <= valid_ahb_trans21 && (haddr21 >= APB_SLAVE11_START_ADDR21) && (haddr21 <= APB_SLAVE11_END_ADDR21);
   `else
     slave_select21[11]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1221  
     slave_select21[12]  <= valid_ahb_trans21 && (haddr21 >= APB_SLAVE12_START_ADDR21) && (haddr21 <= APB_SLAVE12_END_ADDR21);
   `else
     slave_select21[12]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1321  
     slave_select21[13]  <= valid_ahb_trans21 && (haddr21 >= APB_SLAVE13_START_ADDR21) && (haddr21 <= APB_SLAVE13_END_ADDR21);
   `else
     slave_select21[13]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1421  
     slave_select21[14]  <= valid_ahb_trans21 && (haddr21 >= APB_SLAVE14_START_ADDR21) && (haddr21 <= APB_SLAVE14_END_ADDR21);
   `else
     slave_select21[14]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE1521  
     slave_select21[15]  <= valid_ahb_trans21 && (haddr21 >= APB_SLAVE15_START_ADDR21) && (haddr21 <= APB_SLAVE15_END_ADDR21);
   `else
     slave_select21[15]   <= 1'b0;
   `endif  
  end
end

assign pready_muxed21 = |(psel_vector21 & pready_vector21);
assign prdata_muxed21 = prdata0_q21  | prdata1_q21  | prdata2_q21  | prdata3_q21  |
                      prdata4_q21  | prdata5_q21  | prdata6_q21  | prdata7_q21  |
                      prdata8_q21  | prdata9_q21  | prdata10_q21 | prdata11_q21 |
                      prdata12_q21 | prdata13_q21 | prdata14_q21 | prdata15_q21 ;

`ifdef APB_SLAVE021
  assign psel021            = psel_vector21[0];
  assign pready_vector21[0] = pready021;
  assign prdata0_q21        = (psel021 == 1'b1) ? prdata021 : 'b0;
`else
  assign pready_vector21[0] = 1'b0;
  assign prdata0_q21        = 'b0;
`endif

`ifdef APB_SLAVE121
  assign psel121            = psel_vector21[1];
  assign pready_vector21[1] = pready121;
  assign prdata1_q21        = (psel121 == 1'b1) ? prdata121 : 'b0;
`else
  assign pready_vector21[1] = 1'b0;
  assign prdata1_q21        = 'b0;
`endif

`ifdef APB_SLAVE221
  assign psel221            = psel_vector21[2];
  assign pready_vector21[2] = pready221;
  assign prdata2_q21        = (psel221 == 1'b1) ? prdata221 : 'b0;
`else
  assign pready_vector21[2] = 1'b0;
  assign prdata2_q21        = 'b0;
`endif

`ifdef APB_SLAVE321
  assign psel321            = psel_vector21[3];
  assign pready_vector21[3] = pready321;
  assign prdata3_q21        = (psel321 == 1'b1) ? prdata321 : 'b0;
`else
  assign pready_vector21[3] = 1'b0;
  assign prdata3_q21        = 'b0;
`endif

`ifdef APB_SLAVE421
  assign psel421            = psel_vector21[4];
  assign pready_vector21[4] = pready421;
  assign prdata4_q21        = (psel421 == 1'b1) ? prdata421 : 'b0;
`else
  assign pready_vector21[4] = 1'b0;
  assign prdata4_q21        = 'b0;
`endif

`ifdef APB_SLAVE521
  assign psel521            = psel_vector21[5];
  assign pready_vector21[5] = pready521;
  assign prdata5_q21        = (psel521 == 1'b1) ? prdata521 : 'b0;
`else
  assign pready_vector21[5] = 1'b0;
  assign prdata5_q21        = 'b0;
`endif

`ifdef APB_SLAVE621
  assign psel621            = psel_vector21[6];
  assign pready_vector21[6] = pready621;
  assign prdata6_q21        = (psel621 == 1'b1) ? prdata621 : 'b0;
`else
  assign pready_vector21[6] = 1'b0;
  assign prdata6_q21        = 'b0;
`endif

`ifdef APB_SLAVE721
  assign psel721            = psel_vector21[7];
  assign pready_vector21[7] = pready721;
  assign prdata7_q21        = (psel721 == 1'b1) ? prdata721 : 'b0;
`else
  assign pready_vector21[7] = 1'b0;
  assign prdata7_q21        = 'b0;
`endif

`ifdef APB_SLAVE821
  assign psel821            = psel_vector21[8];
  assign pready_vector21[8] = pready821;
  assign prdata8_q21        = (psel821 == 1'b1) ? prdata821 : 'b0;
`else
  assign pready_vector21[8] = 1'b0;
  assign prdata8_q21        = 'b0;
`endif

`ifdef APB_SLAVE921
  assign psel921            = psel_vector21[9];
  assign pready_vector21[9] = pready921;
  assign prdata9_q21        = (psel921 == 1'b1) ? prdata921 : 'b0;
`else
  assign pready_vector21[9] = 1'b0;
  assign prdata9_q21        = 'b0;
`endif

`ifdef APB_SLAVE1021
  assign psel1021            = psel_vector21[10];
  assign pready_vector21[10] = pready1021;
  assign prdata10_q21        = (psel1021 == 1'b1) ? prdata1021 : 'b0;
`else
  assign pready_vector21[10] = 1'b0;
  assign prdata10_q21        = 'b0;
`endif

`ifdef APB_SLAVE1121
  assign psel1121            = psel_vector21[11];
  assign pready_vector21[11] = pready1121;
  assign prdata11_q21        = (psel1121 == 1'b1) ? prdata1121 : 'b0;
`else
  assign pready_vector21[11] = 1'b0;
  assign prdata11_q21        = 'b0;
`endif

`ifdef APB_SLAVE1221
  assign psel1221            = psel_vector21[12];
  assign pready_vector21[12] = pready1221;
  assign prdata12_q21        = (psel1221 == 1'b1) ? prdata1221 : 'b0;
`else
  assign pready_vector21[12] = 1'b0;
  assign prdata12_q21        = 'b0;
`endif

`ifdef APB_SLAVE1321
  assign psel1321            = psel_vector21[13];
  assign pready_vector21[13] = pready1321;
  assign prdata13_q21        = (psel1321 == 1'b1) ? prdata1321 : 'b0;
`else
  assign pready_vector21[13] = 1'b0;
  assign prdata13_q21        = 'b0;
`endif

`ifdef APB_SLAVE1421
  assign psel1421            = psel_vector21[14];
  assign pready_vector21[14] = pready1421;
  assign prdata14_q21        = (psel1421 == 1'b1) ? prdata1421 : 'b0;
`else
  assign pready_vector21[14] = 1'b0;
  assign prdata14_q21        = 'b0;
`endif

`ifdef APB_SLAVE1521
  assign psel1521            = psel_vector21[15];
  assign pready_vector21[15] = pready1521;
  assign prdata15_q21        = (psel1521 == 1'b1) ? prdata1521 : 'b0;
`else
  assign pready_vector21[15] = 1'b0;
  assign prdata15_q21        = 'b0;
`endif

endmodule
