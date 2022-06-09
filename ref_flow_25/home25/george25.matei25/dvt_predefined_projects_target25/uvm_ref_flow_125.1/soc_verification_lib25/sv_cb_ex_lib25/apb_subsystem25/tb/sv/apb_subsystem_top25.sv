/*-------------------------------------------------------------------------
File25 name   : apb_subsystem_top25.v 
Title25       : Top25 level file for the testbench 
Project25     : APB25 Subsystem25
Created25     : March25 2008
Description25 : This25 is top level file which instantiate25 the dut25 apb_subsyste25,.v.
              It also has the assertion25 module which checks25 for the power25 down 
              and power25 up.To25 activate25 the assertion25 ifdef LP_ABV_ON25 is used.       
Notes25       :
-------------------------------------------------------------------------*/ 
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------

 `timescale 1ns/10ps


// Environment25 Constants25
`ifndef AHB_DATA_WIDTH25
  `define AHB_DATA_WIDTH25          32              // AHB25 bus data width [32/64]
`endif
`ifndef AHB_ADDR_WIDTH25
  `define AHB_ADDR_WIDTH25          32              // AHB25 bus address width [32/64]
`endif
`ifndef AHB_DATA_MAX_BIT25
  `define AHB_DATA_MAX_BIT25        31              // MUST25 BE25: AHB_DATA_WIDTH25 - 1
`endif
`ifndef AHB_ADDRESS_MAX_BIT25
  `define AHB_ADDRESS_MAX_BIT25     31              // MUST25 BE25: AHB_ADDR_WIDTH25 - 1
`endif
`ifndef DEFAULT_HREADY_VALUE25
  `define DEFAULT_HREADY_VALUE25    1'b1            // Ready25 Asserted25
`endif

`include "ahb_if25.sv"
`include "apb_if25.sv"
`include "apb_master_if25.sv"
`include "apb_slave_if25.sv"
`include "uart_if25.sv"
`include "spi_if25.sv"
`include "gpio_if25.sv"
`include "coverage25/uart_ctrl_internal_if25.sv"

module apb_subsystem_top25;
  import uvm_pkg::*;
  // Import25 the UVM Utilities25 Package25

  import ahb_pkg25::*;
  import apb_pkg25::*;
  import uart_pkg25::*;
  import gpio_pkg25::*;
  import spi_pkg25::*;
  import uart_ctrl_pkg25::*;
  import apb_subsystem_pkg25::*;

  `include "spi_reg_model25.sv"
  `include "gpio_reg_model25.sv"
  `include "apb_subsystem_reg_rdb25.sv"
  `include "uart_ctrl_reg_seq_lib25.sv"
  `include "spi_reg_seq_lib25.sv"
  `include "gpio_reg_seq_lib25.sv"

  //Include25 module UVC25 sequences
  `include "ahb_user_monitor25.sv"
  `include "apb_subsystem_seq_lib25.sv"
  `include "apb_subsystem_vir_sequencer25.sv"
  `include "apb_subsystem_vir_seq_lib25.sv"

  `include "apb_subsystem_tb25.sv"
  `include "test_lib25.sv"
   
  
   // ====================================
   // SHARED25 signals25
   // ====================================
   
   // clock25
   reg tb_hclk25;
   
   // reset
   reg hresetn25;
   
   // post25-mux25 from master25 mux25
   wire [`AHB_DATA_MAX_BIT25:0] hwdata25;
   wire [`AHB_ADDRESS_MAX_BIT25:0] haddr25;
   wire [1:0]  htrans25;
   wire [2:0]  hburst25;
   wire [2:0]  hsize25;
   wire [3:0]  hprot25;
   wire hwrite25;

   // post25-mux25 from slave25 mux25
   wire        hready25;
   wire [1:0]  hresp25;
   wire [`AHB_DATA_MAX_BIT25:0] hrdata25;
  

  //  Specific25 signals25 of apb25 subsystem25
  reg         ua_rxd25;
  reg         ua_ncts25;


  // uart25 outputs25 
  wire        ua_txd25;
  wire        us_nrts25;

  wire   [7:0] n_ss_out25;    // peripheral25 select25 lines25 from master25
  wire   [31:0] hwdata_byte_alligned25;

  reg [2:0] div8_clk25;
 always @(posedge tb_hclk25) begin
   if (!hresetn25)
     div8_clk25 = 3'b000;
   else
     div8_clk25 = div8_clk25 + 1;
 end


  // Master25 virtual interface
  ahb_if25 ahbi_m025(.ahb_clock25(tb_hclk25), .ahb_resetn25(hresetn25));
  
  uart_if25 uart_s025(.clock25(div8_clk25[2]), .reset(hresetn25));
  uart_if25 uart_s125(.clock25(div8_clk25[2]), .reset(hresetn25));
  spi_if25 spi_s025();
  gpio_if25 gpio_s025();
  uart_ctrl_internal_if25 uart_int025(.clock25(div8_clk25[2]));
  uart_ctrl_internal_if25 uart_int125(.clock25(div8_clk25[2]));

  apb_if25 apbi_mo25(.pclock25(tb_hclk25), .preset25(hresetn25));

  //M025
  assign ahbi_m025.AHB_HCLK25 = tb_hclk25;
  assign ahbi_m025.AHB_HRESET25 = hresetn25;
  assign ahbi_m025.AHB_HRESP25 = hresp25;
  assign ahbi_m025.AHB_HRDATA25 = hrdata25;
  assign ahbi_m025.AHB_HREADY25 = hready25;

  assign apbi_mo25.paddr25 = i_apb_subsystem25.i_ahb2apb25.paddr25;
  assign apbi_mo25.prwd25 = i_apb_subsystem25.i_ahb2apb25.pwrite25;
  assign apbi_mo25.pwdata25 = i_apb_subsystem25.i_ahb2apb25.pwdata25;
  assign apbi_mo25.penable25 = i_apb_subsystem25.i_ahb2apb25.penable25;
  assign apbi_mo25.psel25 = {12'b0, i_apb_subsystem25.i_ahb2apb25.psel825, i_apb_subsystem25.i_ahb2apb25.psel225, i_apb_subsystem25.i_ahb2apb25.psel125, i_apb_subsystem25.i_ahb2apb25.psel025};
  assign apbi_mo25.prdata25 = i_apb_subsystem25.i_ahb2apb25.psel025? i_apb_subsystem25.i_ahb2apb25.prdata025 : (i_apb_subsystem25.i_ahb2apb25.psel125? i_apb_subsystem25.i_ahb2apb25.prdata125 : (i_apb_subsystem25.i_ahb2apb25.psel225? i_apb_subsystem25.i_ahb2apb25.prdata225 : i_apb_subsystem25.i_ahb2apb25.prdata825));

  assign spi_s025.sig_n_ss_in25 = n_ss_out25[0];
  assign spi_s025.sig_n_p_reset25 = hresetn25;
  assign spi_s025.sig_pclk25 = tb_hclk25;

  assign gpio_s025.n_p_reset25 = hresetn25;
  assign gpio_s025.pclk25 = tb_hclk25;

  assign hwdata_byte_alligned25 = (ahbi_m025.AHB_HADDR25[1:0] == 2'b00) ? ahbi_m025.AHB_HWDATA25 : {4{ahbi_m025.AHB_HWDATA25[7:0]}};

  apb_subsystem_025 i_apb_subsystem25 (
    // Inputs25
    // system signals25
    .hclk25              (tb_hclk25),     // AHB25 Clock25
    .n_hreset25          (hresetn25),     // AHB25 reset - Active25 low25
    .pclk25              (tb_hclk25),     // APB25 Clock25
    .n_preset25          (hresetn25),     // APB25 reset - Active25 low25
    
    // AHB25 interface for AHB2APM25 bridge25
    .hsel25     (1'b1),        // AHB2APB25 select25
    .haddr25             (ahbi_m025.AHB_HADDR25),        // Address bus
    .htrans25            (ahbi_m025.AHB_HTRANS25),       // Transfer25 type
    .hsize25             (ahbi_m025.AHB_HSIZE25),        // AHB25 Access type - byte half25-word25 word25
    .hwrite25            (ahbi_m025.AHB_HWRITE25),       // Write signal25
    .hwdata25            (hwdata_byte_alligned25),       // Write data
    .hready_in25         (hready25),       // Indicates25 that the last master25 has finished25 
                                       // its bus access
    .hburst25            (ahbi_m025.AHB_HBURST25),       // Burst type
    .hprot25             (ahbi_m025.AHB_HPROT25),        // Protection25 control25
    .hmaster25           (4'h0),      // Master25 select25
    .hmastlock25         (ahbi_m025.AHB_HLOCK25),  // Locked25 transfer25
    // AHB25 interface for SMC25
    .smc_hclk25          (1'b0),
    .smc_n_hclk25        (1'b1),
    .smc_haddr25         (32'd0),
    .smc_htrans25        (2'b00),
    .smc_hsel25          (1'b0),
    .smc_hwrite25        (1'b0),
    .smc_hsize25         (3'd0),
    .smc_hwdata25        (32'd0),
    .smc_hready_in25     (1'b1),
    .smc_hburst25        (3'b000),
    .smc_hprot25         (4'b0000),
    .smc_hmaster25       (4'b0000),
    .smc_hmastlock25     (1'b0),

    //interrupt25 from DMA25
    .DMA_irq25           (1'b0),      

    // Scan25 inputs25
    .scan_en25           (1'b0),         // Scan25 enable pin25
    .scan_in_125         (1'b0),         // Scan25 input for first chain25
    .scan_in_225         (1'b0),        // Scan25 input for second chain25
    .scan_mode25         (1'b0),
    //input for smc25
    .data_smc25          (32'd0),
    //inputs25 for uart25
    .ua_rxd25            (uart_s025.txd25),
    .ua_rxd125           (uart_s125.txd25),
    .ua_ncts25           (uart_s025.cts_n25),
    .ua_ncts125          (uart_s125.cts_n25),
    //inputs25 for spi25
    .n_ss_in25           (1'b1),
    .mi25                (spi_s025.sig_so25),
    .si25                (1'b0),
    .sclk_in25           (1'b0),
    //inputs25 for GPIO25
    .gpio_pin_in25       (gpio_s025.gpio_pin_in25[15:0]),
 
//interrupt25 from Enet25 MAC25
     .macb0_int25     (1'b0),
     .macb1_int25     (1'b0),
     .macb2_int25     (1'b0),
     .macb3_int25     (1'b0),

    // Scan25 outputs25
    .scan_out_125        (),             // Scan25 out for chain25 1
    .scan_out_225        (),             // Scan25 out for chain25 2
   
    //output from APB25 
    // AHB25 interface for AHB2APB25 bridge25
    .hrdata25            (hrdata25),       // Read data provided from target slave25
    .hready25            (hready25),       // Ready25 for new bus cycle from target slave25
    .hresp25             (hresp25),        // Response25 from the bridge25

    // AHB25 interface for SMC25
    .smc_hrdata25        (), 
    .smc_hready25        (),
    .smc_hresp25         (),
  
    //outputs25 from smc25
    .smc_n_ext_oe25      (),
    .smc_data25          (),
    .smc_addr25          (),
    .smc_n_be25          (),
    .smc_n_cs25          (), 
    .smc_n_we25          (),
    .smc_n_wr25          (),
    .smc_n_rd25          (),
    //outputs25 from uart25
    .ua_txd25             (uart_s025.rxd25),
    .ua_txd125            (uart_s125.rxd25),
    .ua_nrts25            (uart_s025.rts_n25),
    .ua_nrts125           (uart_s125.rts_n25),
    // outputs25 from ttc25
    .so                (),
    .mo25                (spi_s025.sig_si25),
    .sclk_out25          (spi_s025.sig_sclk_in25),
    .n_ss_out25          (n_ss_out25[7:0]),
    .n_so_en25           (),
    .n_mo_en25           (),
    .n_sclk_en25         (),
    .n_ss_en25           (),
    //outputs25 from gpio25
    .n_gpio_pin_oe25     (gpio_s025.n_gpio_pin_oe25[15:0]),
    .gpio_pin_out25      (gpio_s025.gpio_pin_out25[15:0]),

//unconnected25 o/p ports25
    .clk_SRPG_macb0_en25(),
    .clk_SRPG_macb1_en25(),
    .clk_SRPG_macb2_en25(),
    .clk_SRPG_macb3_en25(),
    .core06v25(),
    .core08v25(),
    .core10v25(),
    .core12v25(),
    .mte_smc_start25(),
    .mte_uart_start25(),
    .mte_smc_uart_start25(),
    .mte_pm_smc_to_default_start25(),
    .mte_pm_uart_to_default_start25(),
    .mte_pm_smc_uart_to_default_start25(),
    .pcm_irq25(),
    .ttc_irq25(),
    .gpio_irq25(),
    .uart0_irq25(),
    .uart1_irq25(),
    .spi_irq25(),

    .macb3_wakeup25(),
    .macb2_wakeup25(),
    .macb1_wakeup25(),
    .macb0_wakeup25()
);


initial
begin
  tb_hclk25 = 0;
  hresetn25 = 1;

  #1 hresetn25 = 0;
  #1200 hresetn25 = 1;
end

always #50 tb_hclk25 = ~tb_hclk25;

initial begin
  uvm_config_db#(virtual uart_if25)::set(null, "uvm_test_top.ve25.uart025*", "vif25", uart_s025);
  uvm_config_db#(virtual uart_if25)::set(null, "uvm_test_top.ve25.uart125*", "vif25", uart_s125);
  uvm_config_db#(virtual uart_ctrl_internal_if25)::set(null, "uvm_test_top.ve25.apb_ss_env25.apb_uart025.*", "vif25", uart_int025);
  uvm_config_db#(virtual uart_ctrl_internal_if25)::set(null, "uvm_test_top.ve25.apb_ss_env25.apb_uart125.*", "vif25", uart_int125);
  uvm_config_db#(virtual apb_if25)::set(null, "uvm_test_top.ve25.apb025*", "vif25", apbi_mo25);
  uvm_config_db#(virtual ahb_if25)::set(null, "uvm_test_top.ve25.ahb025*", "vif25", ahbi_m025);
  uvm_config_db#(virtual spi_if25)::set(null, "uvm_test_top.ve25.spi025*", "spi_if25", spi_s025);
  uvm_config_db#(virtual gpio_if25)::set(null, "uvm_test_top.ve25.gpio025*", "gpio_if25", gpio_s025);
  run_test();
end

endmodule
