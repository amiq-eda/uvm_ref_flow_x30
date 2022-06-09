//File3 name   : ahb2apb3.v
//Title3       : 
//Created3     : 2010
//Description3 : Simple3 AHB3 to APB3 bridge3
//Notes3       : 
//----------------------------------------------------------------------
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------

`timescale 1ns/1ps

`include "ahb2apb_defines3.v"

module ahb2apb3
(
  // AHB3 signals3
  hclk3,
  hreset_n3,
  hsel3,
  haddr3,
  htrans3,
  hwdata3,
  hwrite3,
  hrdata3,
  hready3,
  hresp3,
  
  // APB3 signals3 common to all APB3 slaves3
  pclk3,
  preset_n3,
  paddr3,
  penable3,
  pwrite3,
  pwdata3
  
  // Slave3 0 signals3
  `ifdef APB_SLAVE03
  ,psel03
  ,pready03
  ,prdata03
  `endif
  
  // Slave3 1 signals3
  `ifdef APB_SLAVE13
  ,psel13
  ,pready13
  ,prdata13
  `endif
  
  // Slave3 2 signals3
  `ifdef APB_SLAVE23
  ,psel23
  ,pready23
  ,prdata23
  `endif
  
  // Slave3 3 signals3
  `ifdef APB_SLAVE33
  ,psel33
  ,pready33
  ,prdata33
  `endif
  
  // Slave3 4 signals3
  `ifdef APB_SLAVE43
  ,psel43
  ,pready43
  ,prdata43
  `endif
  
  // Slave3 5 signals3
  `ifdef APB_SLAVE53
  ,psel53
  ,pready53
  ,prdata53
  `endif
  
  // Slave3 6 signals3
  `ifdef APB_SLAVE63
  ,psel63
  ,pready63
  ,prdata63
  `endif
  
  // Slave3 7 signals3
  `ifdef APB_SLAVE73
  ,psel73
  ,pready73
  ,prdata73
  `endif
  
  // Slave3 8 signals3
  `ifdef APB_SLAVE83
  ,psel83
  ,pready83
  ,prdata83
  `endif
  
  // Slave3 9 signals3
  `ifdef APB_SLAVE93
  ,psel93
  ,pready93
  ,prdata93
  `endif
  
  // Slave3 10 signals3
  `ifdef APB_SLAVE103
  ,psel103
  ,pready103
  ,prdata103
  `endif
  
  // Slave3 11 signals3
  `ifdef APB_SLAVE113
  ,psel113
  ,pready113
  ,prdata113
  `endif
  
  // Slave3 12 signals3
  `ifdef APB_SLAVE123
  ,psel123
  ,pready123
  ,prdata123
  `endif
  
  // Slave3 13 signals3
  `ifdef APB_SLAVE133
  ,psel133
  ,pready133
  ,prdata133
  `endif
  
  // Slave3 14 signals3
  `ifdef APB_SLAVE143
  ,psel143
  ,pready143
  ,prdata143
  `endif
  
  // Slave3 15 signals3
  `ifdef APB_SLAVE153
  ,psel153
  ,pready153
  ,prdata153
  `endif
  
);

parameter 
  APB_SLAVE0_START_ADDR3  = 32'h00000000,
  APB_SLAVE0_END_ADDR3    = 32'h00000000,
  APB_SLAVE1_START_ADDR3  = 32'h00000000,
  APB_SLAVE1_END_ADDR3    = 32'h00000000,
  APB_SLAVE2_START_ADDR3  = 32'h00000000,
  APB_SLAVE2_END_ADDR3    = 32'h00000000,
  APB_SLAVE3_START_ADDR3  = 32'h00000000,
  APB_SLAVE3_END_ADDR3    = 32'h00000000,
  APB_SLAVE4_START_ADDR3  = 32'h00000000,
  APB_SLAVE4_END_ADDR3    = 32'h00000000,
  APB_SLAVE5_START_ADDR3  = 32'h00000000,
  APB_SLAVE5_END_ADDR3    = 32'h00000000,
  APB_SLAVE6_START_ADDR3  = 32'h00000000,
  APB_SLAVE6_END_ADDR3    = 32'h00000000,
  APB_SLAVE7_START_ADDR3  = 32'h00000000,
  APB_SLAVE7_END_ADDR3    = 32'h00000000,
  APB_SLAVE8_START_ADDR3  = 32'h00000000,
  APB_SLAVE8_END_ADDR3    = 32'h00000000,
  APB_SLAVE9_START_ADDR3  = 32'h00000000,
  APB_SLAVE9_END_ADDR3    = 32'h00000000,
  APB_SLAVE10_START_ADDR3  = 32'h00000000,
  APB_SLAVE10_END_ADDR3    = 32'h00000000,
  APB_SLAVE11_START_ADDR3  = 32'h00000000,
  APB_SLAVE11_END_ADDR3    = 32'h00000000,
  APB_SLAVE12_START_ADDR3  = 32'h00000000,
  APB_SLAVE12_END_ADDR3    = 32'h00000000,
  APB_SLAVE13_START_ADDR3  = 32'h00000000,
  APB_SLAVE13_END_ADDR3    = 32'h00000000,
  APB_SLAVE14_START_ADDR3  = 32'h00000000,
  APB_SLAVE14_END_ADDR3    = 32'h00000000,
  APB_SLAVE15_START_ADDR3  = 32'h00000000,
  APB_SLAVE15_END_ADDR3    = 32'h00000000;

  // AHB3 signals3
input        hclk3;
input        hreset_n3;
input        hsel3;
input[31:0]  haddr3;
input[1:0]   htrans3;
input[31:0]  hwdata3;
input        hwrite3;
output[31:0] hrdata3;
reg   [31:0] hrdata3;
output       hready3;
output[1:0]  hresp3;
  
  // APB3 signals3 common to all APB3 slaves3
input       pclk3;
input       preset_n3;
output[31:0] paddr3;
reg   [31:0] paddr3;
output       penable3;
reg          penable3;
output       pwrite3;
reg          pwrite3;
output[31:0] pwdata3;
  
  // Slave3 0 signals3
`ifdef APB_SLAVE03
  output      psel03;
  input       pready03;
  input[31:0] prdata03;
`endif
  
  // Slave3 1 signals3
`ifdef APB_SLAVE13
  output      psel13;
  input       pready13;
  input[31:0] prdata13;
`endif
  
  // Slave3 2 signals3
`ifdef APB_SLAVE23
  output      psel23;
  input       pready23;
  input[31:0] prdata23;
`endif
  
  // Slave3 3 signals3
`ifdef APB_SLAVE33
  output      psel33;
  input       pready33;
  input[31:0] prdata33;
`endif
  
  // Slave3 4 signals3
`ifdef APB_SLAVE43
  output      psel43;
  input       pready43;
  input[31:0] prdata43;
`endif
  
  // Slave3 5 signals3
`ifdef APB_SLAVE53
  output      psel53;
  input       pready53;
  input[31:0] prdata53;
`endif
  
  // Slave3 6 signals3
`ifdef APB_SLAVE63
  output      psel63;
  input       pready63;
  input[31:0] prdata63;
`endif
  
  // Slave3 7 signals3
`ifdef APB_SLAVE73
  output      psel73;
  input       pready73;
  input[31:0] prdata73;
`endif
  
  // Slave3 8 signals3
`ifdef APB_SLAVE83
  output      psel83;
  input       pready83;
  input[31:0] prdata83;
`endif
  
  // Slave3 9 signals3
`ifdef APB_SLAVE93
  output      psel93;
  input       pready93;
  input[31:0] prdata93;
`endif
  
  // Slave3 10 signals3
`ifdef APB_SLAVE103
  output      psel103;
  input       pready103;
  input[31:0] prdata103;
`endif
  
  // Slave3 11 signals3
`ifdef APB_SLAVE113
  output      psel113;
  input       pready113;
  input[31:0] prdata113;
`endif
  
  // Slave3 12 signals3
`ifdef APB_SLAVE123
  output      psel123;
  input       pready123;
  input[31:0] prdata123;
`endif
  
  // Slave3 13 signals3
`ifdef APB_SLAVE133
  output      psel133;
  input       pready133;
  input[31:0] prdata133;
`endif
  
  // Slave3 14 signals3
`ifdef APB_SLAVE143
  output      psel143;
  input       pready143;
  input[31:0] prdata143;
`endif
  
  // Slave3 15 signals3
`ifdef APB_SLAVE153
  output      psel153;
  input       pready153;
  input[31:0] prdata153;
`endif
 
reg         ahb_addr_phase3;
reg         ahb_data_phase3;
wire        valid_ahb_trans3;
wire        pready_muxed3;
wire [31:0] prdata_muxed3;
reg  [31:0] haddr_reg3;
reg         hwrite_reg3;
reg  [2:0]  apb_state3;
wire [2:0]  apb_state_idle3;
wire [2:0]  apb_state_setup3;
wire [2:0]  apb_state_access3;
reg  [15:0] slave_select3;
wire [15:0] pready_vector3;
reg  [15:0] psel_vector3;
wire [31:0] prdata0_q3;
wire [31:0] prdata1_q3;
wire [31:0] prdata2_q3;
wire [31:0] prdata3_q3;
wire [31:0] prdata4_q3;
wire [31:0] prdata5_q3;
wire [31:0] prdata6_q3;
wire [31:0] prdata7_q3;
wire [31:0] prdata8_q3;
wire [31:0] prdata9_q3;
wire [31:0] prdata10_q3;
wire [31:0] prdata11_q3;
wire [31:0] prdata12_q3;
wire [31:0] prdata13_q3;
wire [31:0] prdata14_q3;
wire [31:0] prdata15_q3;

// assign pclk3     = hclk3;
// assign preset_n3 = hreset_n3;
assign hready3   = ahb_addr_phase3;
assign pwdata3   = hwdata3;
assign hresp3  = 2'b00;

// Respond3 to NONSEQ3 or SEQ transfers3
assign valid_ahb_trans3 = ((htrans3 == 2'b10) || (htrans3 == 2'b11)) && (hsel3 == 1'b1);

always @(posedge hclk3) begin
  if (hreset_n3 == 1'b0) begin
    ahb_addr_phase3 <= 1'b1;
    ahb_data_phase3 <= 1'b0;
    haddr_reg3      <= 'b0;
    hwrite_reg3     <= 1'b0;
    hrdata3         <= 'b0;
  end
  else begin
    if (ahb_addr_phase3 == 1'b1 && valid_ahb_trans3 == 1'b1) begin
      ahb_addr_phase3 <= 1'b0;
      ahb_data_phase3 <= 1'b1;
      haddr_reg3      <= haddr3;
      hwrite_reg3     <= hwrite3;
    end
    if (ahb_data_phase3 == 1'b1 && pready_muxed3 == 1'b1 && apb_state3 == apb_state_access3) begin
      ahb_addr_phase3 <= 1'b1;
      ahb_data_phase3 <= 1'b0;
      hrdata3         <= prdata_muxed3;
    end
  end
end

// APB3 state machine3 state definitions3
assign apb_state_idle3   = 3'b001;
assign apb_state_setup3  = 3'b010;
assign apb_state_access3 = 3'b100;

// APB3 state machine3
always @(posedge hclk3 or negedge hreset_n3) begin
  if (hreset_n3 == 1'b0) begin
    apb_state3   <= apb_state_idle3;
    psel_vector3 <= 1'b0;
    penable3     <= 1'b0;
    paddr3       <= 1'b0;
    pwrite3      <= 1'b0;
  end  
  else begin
    
    // IDLE3 -> SETUP3
    if (apb_state3 == apb_state_idle3) begin
      if (ahb_data_phase3 == 1'b1) begin
        apb_state3   <= apb_state_setup3;
        psel_vector3 <= slave_select3;
        paddr3       <= haddr_reg3;
        pwrite3      <= hwrite_reg3;
      end  
    end
    
    // SETUP3 -> TRANSFER3
    if (apb_state3 == apb_state_setup3) begin
      apb_state3 <= apb_state_access3;
      penable3   <= 1'b1;
    end
    
    // TRANSFER3 -> SETUP3 or
    // TRANSFER3 -> IDLE3
    if (apb_state3 == apb_state_access3) begin
      if (pready_muxed3 == 1'b1) begin
      
        // TRANSFER3 -> SETUP3
        if (valid_ahb_trans3 == 1'b1) begin
          apb_state3   <= apb_state_setup3;
          penable3     <= 1'b0;
          psel_vector3 <= slave_select3;
          paddr3       <= haddr_reg3;
          pwrite3      <= hwrite_reg3;
        end  
        
        // TRANSFER3 -> IDLE3
        else begin
          apb_state3   <= apb_state_idle3;      
          penable3     <= 1'b0;
          psel_vector3 <= 'b0;
        end  
      end
    end
    
  end
end

always @(posedge hclk3 or negedge hreset_n3) begin
  if (hreset_n3 == 1'b0)
    slave_select3 <= 'b0;
  else begin  
  `ifdef APB_SLAVE03
     slave_select3[0]   <= valid_ahb_trans3 && (haddr3 >= APB_SLAVE0_START_ADDR3)  && (haddr3 <= APB_SLAVE0_END_ADDR3);
   `else
     slave_select3[0]   <= 1'b0;
   `endif
   
   `ifdef APB_SLAVE13
     slave_select3[1]   <= valid_ahb_trans3 && (haddr3 >= APB_SLAVE1_START_ADDR3)  && (haddr3 <= APB_SLAVE1_END_ADDR3);
   `else
     slave_select3[1]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE23  
     slave_select3[2]   <= valid_ahb_trans3 && (haddr3 >= APB_SLAVE2_START_ADDR3)  && (haddr3 <= APB_SLAVE2_END_ADDR3);
   `else
     slave_select3[2]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE33  
     slave_select3[3]   <= valid_ahb_trans3 && (haddr3 >= APB_SLAVE3_START_ADDR3)  && (haddr3 <= APB_SLAVE3_END_ADDR3);
   `else
     slave_select3[3]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE43  
     slave_select3[4]   <= valid_ahb_trans3 && (haddr3 >= APB_SLAVE4_START_ADDR3)  && (haddr3 <= APB_SLAVE4_END_ADDR3);
   `else
     slave_select3[4]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE53  
     slave_select3[5]   <= valid_ahb_trans3 && (haddr3 >= APB_SLAVE5_START_ADDR3)  && (haddr3 <= APB_SLAVE5_END_ADDR3);
   `else
     slave_select3[5]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE63  
     slave_select3[6]   <= valid_ahb_trans3 && (haddr3 >= APB_SLAVE6_START_ADDR3)  && (haddr3 <= APB_SLAVE6_END_ADDR3);
   `else
     slave_select3[6]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE73  
     slave_select3[7]   <= valid_ahb_trans3 && (haddr3 >= APB_SLAVE7_START_ADDR3)  && (haddr3 <= APB_SLAVE7_END_ADDR3);
   `else
     slave_select3[7]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE83  
     slave_select3[8]   <= valid_ahb_trans3 && (haddr3 >= APB_SLAVE8_START_ADDR3)  && (haddr3 <= APB_SLAVE8_END_ADDR3);
   `else
     slave_select3[8]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE93  
     slave_select3[9]   <= valid_ahb_trans3 && (haddr3 >= APB_SLAVE9_START_ADDR3)  && (haddr3 <= APB_SLAVE9_END_ADDR3);
   `else
     slave_select3[9]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE103  
     slave_select3[10]  <= valid_ahb_trans3 && (haddr3 >= APB_SLAVE10_START_ADDR3) && (haddr3 <= APB_SLAVE10_END_ADDR3);
   `else
     slave_select3[10]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE113  
     slave_select3[11]  <= valid_ahb_trans3 && (haddr3 >= APB_SLAVE11_START_ADDR3) && (haddr3 <= APB_SLAVE11_END_ADDR3);
   `else
     slave_select3[11]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE123  
     slave_select3[12]  <= valid_ahb_trans3 && (haddr3 >= APB_SLAVE12_START_ADDR3) && (haddr3 <= APB_SLAVE12_END_ADDR3);
   `else
     slave_select3[12]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE133  
     slave_select3[13]  <= valid_ahb_trans3 && (haddr3 >= APB_SLAVE13_START_ADDR3) && (haddr3 <= APB_SLAVE13_END_ADDR3);
   `else
     slave_select3[13]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE143  
     slave_select3[14]  <= valid_ahb_trans3 && (haddr3 >= APB_SLAVE14_START_ADDR3) && (haddr3 <= APB_SLAVE14_END_ADDR3);
   `else
     slave_select3[14]   <= 1'b0;
   `endif  
     
   `ifdef APB_SLAVE153  
     slave_select3[15]  <= valid_ahb_trans3 && (haddr3 >= APB_SLAVE15_START_ADDR3) && (haddr3 <= APB_SLAVE15_END_ADDR3);
   `else
     slave_select3[15]   <= 1'b0;
   `endif  
  end
end

assign pready_muxed3 = |(psel_vector3 & pready_vector3);
assign prdata_muxed3 = prdata0_q3  | prdata1_q3  | prdata2_q3  | prdata3_q3  |
                      prdata4_q3  | prdata5_q3  | prdata6_q3  | prdata7_q3  |
                      prdata8_q3  | prdata9_q3  | prdata10_q3 | prdata11_q3 |
                      prdata12_q3 | prdata13_q3 | prdata14_q3 | prdata15_q3 ;

`ifdef APB_SLAVE03
  assign psel03            = psel_vector3[0];
  assign pready_vector3[0] = pready03;
  assign prdata0_q3        = (psel03 == 1'b1) ? prdata03 : 'b0;
`else
  assign pready_vector3[0] = 1'b0;
  assign prdata0_q3        = 'b0;
`endif

`ifdef APB_SLAVE13
  assign psel13            = psel_vector3[1];
  assign pready_vector3[1] = pready13;
  assign prdata1_q3        = (psel13 == 1'b1) ? prdata13 : 'b0;
`else
  assign pready_vector3[1] = 1'b0;
  assign prdata1_q3        = 'b0;
`endif

`ifdef APB_SLAVE23
  assign psel23            = psel_vector3[2];
  assign pready_vector3[2] = pready23;
  assign prdata2_q3        = (psel23 == 1'b1) ? prdata23 : 'b0;
`else
  assign pready_vector3[2] = 1'b0;
  assign prdata2_q3        = 'b0;
`endif

`ifdef APB_SLAVE33
  assign psel33            = psel_vector3[3];
  assign pready_vector3[3] = pready33;
  assign prdata3_q3        = (psel33 == 1'b1) ? prdata33 : 'b0;
`else
  assign pready_vector3[3] = 1'b0;
  assign prdata3_q3        = 'b0;
`endif

`ifdef APB_SLAVE43
  assign psel43            = psel_vector3[4];
  assign pready_vector3[4] = pready43;
  assign prdata4_q3        = (psel43 == 1'b1) ? prdata43 : 'b0;
`else
  assign pready_vector3[4] = 1'b0;
  assign prdata4_q3        = 'b0;
`endif

`ifdef APB_SLAVE53
  assign psel53            = psel_vector3[5];
  assign pready_vector3[5] = pready53;
  assign prdata5_q3        = (psel53 == 1'b1) ? prdata53 : 'b0;
`else
  assign pready_vector3[5] = 1'b0;
  assign prdata5_q3        = 'b0;
`endif

`ifdef APB_SLAVE63
  assign psel63            = psel_vector3[6];
  assign pready_vector3[6] = pready63;
  assign prdata6_q3        = (psel63 == 1'b1) ? prdata63 : 'b0;
`else
  assign pready_vector3[6] = 1'b0;
  assign prdata6_q3        = 'b0;
`endif

`ifdef APB_SLAVE73
  assign psel73            = psel_vector3[7];
  assign pready_vector3[7] = pready73;
  assign prdata7_q3        = (psel73 == 1'b1) ? prdata73 : 'b0;
`else
  assign pready_vector3[7] = 1'b0;
  assign prdata7_q3        = 'b0;
`endif

`ifdef APB_SLAVE83
  assign psel83            = psel_vector3[8];
  assign pready_vector3[8] = pready83;
  assign prdata8_q3        = (psel83 == 1'b1) ? prdata83 : 'b0;
`else
  assign pready_vector3[8] = 1'b0;
  assign prdata8_q3        = 'b0;
`endif

`ifdef APB_SLAVE93
  assign psel93            = psel_vector3[9];
  assign pready_vector3[9] = pready93;
  assign prdata9_q3        = (psel93 == 1'b1) ? prdata93 : 'b0;
`else
  assign pready_vector3[9] = 1'b0;
  assign prdata9_q3        = 'b0;
`endif

`ifdef APB_SLAVE103
  assign psel103            = psel_vector3[10];
  assign pready_vector3[10] = pready103;
  assign prdata10_q3        = (psel103 == 1'b1) ? prdata103 : 'b0;
`else
  assign pready_vector3[10] = 1'b0;
  assign prdata10_q3        = 'b0;
`endif

`ifdef APB_SLAVE113
  assign psel113            = psel_vector3[11];
  assign pready_vector3[11] = pready113;
  assign prdata11_q3        = (psel113 == 1'b1) ? prdata113 : 'b0;
`else
  assign pready_vector3[11] = 1'b0;
  assign prdata11_q3        = 'b0;
`endif

`ifdef APB_SLAVE123
  assign psel123            = psel_vector3[12];
  assign pready_vector3[12] = pready123;
  assign prdata12_q3        = (psel123 == 1'b1) ? prdata123 : 'b0;
`else
  assign pready_vector3[12] = 1'b0;
  assign prdata12_q3        = 'b0;
`endif

`ifdef APB_SLAVE133
  assign psel133            = psel_vector3[13];
  assign pready_vector3[13] = pready133;
  assign prdata13_q3        = (psel133 == 1'b1) ? prdata133 : 'b0;
`else
  assign pready_vector3[13] = 1'b0;
  assign prdata13_q3        = 'b0;
`endif

`ifdef APB_SLAVE143
  assign psel143            = psel_vector3[14];
  assign pready_vector3[14] = pready143;
  assign prdata14_q3        = (psel143 == 1'b1) ? prdata143 : 'b0;
`else
  assign pready_vector3[14] = 1'b0;
  assign prdata14_q3        = 'b0;
`endif

`ifdef APB_SLAVE153
  assign psel153            = psel_vector3[15];
  assign pready_vector3[15] = pready153;
  assign prdata15_q3        = (psel153 == 1'b1) ? prdata153 : 'b0;
`else
  assign pready_vector3[15] = 1'b0;
  assign prdata15_q3        = 'b0;
`endif

endmodule
