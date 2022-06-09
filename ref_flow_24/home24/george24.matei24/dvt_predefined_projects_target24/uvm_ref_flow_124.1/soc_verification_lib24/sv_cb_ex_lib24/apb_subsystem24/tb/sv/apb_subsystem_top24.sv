/*-------------------------------------------------------------------------
File24 name   : apb_subsystem_top24.v 
Title24       : Top24 level file for the testbench 
Project24     : APB24 Subsystem24
Created24     : March24 2008
Description24 : This24 is top level file which instantiate24 the dut24 apb_subsyste24,.v.
              It also has the assertion24 module which checks24 for the power24 down 
              and power24 up.To24 activate24 the assertion24 ifdef LP_ABV_ON24 is used.       
Notes24       :
-------------------------------------------------------------------------*/ 
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------

 `timescale 1ns/10ps


// Environment24 Constants24
`ifndef AHB_DATA_WIDTH24
  `define AHB_DATA_WIDTH24          32              // AHB24 bus data width [32/64]
`endif
`ifndef AHB_ADDR_WIDTH24
  `define AHB_ADDR_WIDTH24          32              // AHB24 bus address width [32/64]
`endif
`ifndef AHB_DATA_MAX_BIT24
  `define AHB_DATA_MAX_BIT24        31              // MUST24 BE24: AHB_DATA_WIDTH24 - 1
`endif
`ifndef AHB_ADDRESS_MAX_BIT24
  `define AHB_ADDRESS_MAX_BIT24     31              // MUST24 BE24: AHB_ADDR_WIDTH24 - 1
`endif
`ifndef DEFAULT_HREADY_VALUE24
  `define DEFAULT_HREADY_VALUE24    1'b1            // Ready24 Asserted24
`endif

`include "ahb_if24.sv"
`include "apb_if24.sv"
`include "apb_master_if24.sv"
`include "apb_slave_if24.sv"
`include "uart_if24.sv"
`include "spi_if24.sv"
`include "gpio_if24.sv"
`include "coverage24/uart_ctrl_internal_if24.sv"

module apb_subsystem_top24;
  import uvm_pkg::*;
  // Import24 the UVM Utilities24 Package24

  import ahb_pkg24::*;
  import apb_pkg24::*;
  import uart_pkg24::*;
  import gpio_pkg24::*;
  import spi_pkg24::*;
  import uart_ctrl_pkg24::*;
  import apb_subsystem_pkg24::*;

  `include "spi_reg_model24.sv"
  `include "gpio_reg_model24.sv"
  `include "apb_subsystem_reg_rdb24.sv"
  `include "uart_ctrl_reg_seq_lib24.sv"
  `include "spi_reg_seq_lib24.sv"
  `include "gpio_reg_seq_lib24.sv"

  //Include24 module UVC24 sequences
  `include "ahb_user_monitor24.sv"
  `include "apb_subsystem_seq_lib24.sv"
  `include "apb_subsystem_vir_sequencer24.sv"
  `include "apb_subsystem_vir_seq_lib24.sv"

  `include "apb_subsystem_tb24.sv"
  `include "test_lib24.sv"
   
  
   // ====================================
   // SHARED24 signals24
   // ====================================
   
   // clock24
   reg tb_hclk24;
   
   // reset
   reg hresetn24;
   
   // post24-mux24 from master24 mux24
   wire [`AHB_DATA_MAX_BIT24:0] hwdata24;
   wire [`AHB_ADDRESS_MAX_BIT24:0] haddr24;
   wire [1:0]  htrans24;
   wire [2:0]  hburst24;
   wire [2:0]  hsize24;
   wire [3:0]  hprot24;
   wire hwrite24;

   // post24-mux24 from slave24 mux24
   wire        hready24;
   wire [1:0]  hresp24;
   wire [`AHB_DATA_MAX_BIT24:0] hrdata24;
  

  //  Specific24 signals24 of apb24 subsystem24
  reg         ua_rxd24;
  reg         ua_ncts24;


  // uart24 outputs24 
  wire        ua_txd24;
  wire        us_nrts24;

  wire   [7:0] n_ss_out24;    // peripheral24 select24 lines24 from master24
  wire   [31:0] hwdata_byte_alligned24;

  reg [2:0] div8_clk24;
 always @(posedge tb_hclk24) begin
   if (!hresetn24)
     div8_clk24 = 3'b000;
   else
     div8_clk24 = div8_clk24 + 1;
 end


  // Master24 virtual interface
  ahb_if24 ahbi_m024(.ahb_clock24(tb_hclk24), .ahb_resetn24(hresetn24));
  
  uart_if24 uart_s024(.clock24(div8_clk24[2]), .reset(hresetn24));
  uart_if24 uart_s124(.clock24(div8_clk24[2]), .reset(hresetn24));
  spi_if24 spi_s024();
  gpio_if24 gpio_s024();
  uart_ctrl_internal_if24 uart_int024(.clock24(div8_clk24[2]));
  uart_ctrl_internal_if24 uart_int124(.clock24(div8_clk24[2]));

  apb_if24 apbi_mo24(.pclock24(tb_hclk24), .preset24(hresetn24));

  //M024
  assign ahbi_m024.AHB_HCLK24 = tb_hclk24;
  assign ahbi_m024.AHB_HRESET24 = hresetn24;
  assign ahbi_m024.AHB_HRESP24 = hresp24;
  assign ahbi_m024.AHB_HRDATA24 = hrdata24;
  assign ahbi_m024.AHB_HREADY24 = hready24;

  assign apbi_mo24.paddr24 = i_apb_subsystem24.i_ahb2apb24.paddr24;
  assign apbi_mo24.prwd24 = i_apb_subsystem24.i_ahb2apb24.pwrite24;
  assign apbi_mo24.pwdata24 = i_apb_subsystem24.i_ahb2apb24.pwdata24;
  assign apbi_mo24.penable24 = i_apb_subsystem24.i_ahb2apb24.penable24;
  assign apbi_mo24.psel24 = {12'b0, i_apb_subsystem24.i_ahb2apb24.psel824, i_apb_subsystem24.i_ahb2apb24.psel224, i_apb_subsystem24.i_ahb2apb24.psel124, i_apb_subsystem24.i_ahb2apb24.psel024};
  assign apbi_mo24.prdata24 = i_apb_subsystem24.i_ahb2apb24.psel024? i_apb_subsystem24.i_ahb2apb24.prdata024 : (i_apb_subsystem24.i_ahb2apb24.psel124? i_apb_subsystem24.i_ahb2apb24.prdata124 : (i_apb_subsystem24.i_ahb2apb24.psel224? i_apb_subsystem24.i_ahb2apb24.prdata224 : i_apb_subsystem24.i_ahb2apb24.prdata824));

  assign spi_s024.sig_n_ss_in24 = n_ss_out24[0];
  assign spi_s024.sig_n_p_reset24 = hresetn24;
  assign spi_s024.sig_pclk24 = tb_hclk24;

  assign gpio_s024.n_p_reset24 = hresetn24;
  assign gpio_s024.pclk24 = tb_hclk24;

  assign hwdata_byte_alligned24 = (ahbi_m024.AHB_HADDR24[1:0] == 2'b00) ? ahbi_m024.AHB_HWDATA24 : {4{ahbi_m024.AHB_HWDATA24[7:0]}};

  apb_subsystem_024 i_apb_subsystem24 (
    // Inputs24
    // system signals24
    .hclk24              (tb_hclk24),     // AHB24 Clock24
    .n_hreset24          (hresetn24),     // AHB24 reset - Active24 low24
    .pclk24              (tb_hclk24),     // APB24 Clock24
    .n_preset24          (hresetn24),     // APB24 reset - Active24 low24
    
    // AHB24 interface for AHB2APM24 bridge24
    .hsel24     (1'b1),        // AHB2APB24 select24
    .haddr24             (ahbi_m024.AHB_HADDR24),        // Address bus
    .htrans24            (ahbi_m024.AHB_HTRANS24),       // Transfer24 type
    .hsize24             (ahbi_m024.AHB_HSIZE24),        // AHB24 Access type - byte half24-word24 word24
    .hwrite24            (ahbi_m024.AHB_HWRITE24),       // Write signal24
    .hwdata24            (hwdata_byte_alligned24),       // Write data
    .hready_in24         (hready24),       // Indicates24 that the last master24 has finished24 
                                       // its bus access
    .hburst24            (ahbi_m024.AHB_HBURST24),       // Burst type
    .hprot24             (ahbi_m024.AHB_HPROT24),        // Protection24 control24
    .hmaster24           (4'h0),      // Master24 select24
    .hmastlock24         (ahbi_m024.AHB_HLOCK24),  // Locked24 transfer24
    // AHB24 interface for SMC24
    .smc_hclk24          (1'b0),
    .smc_n_hclk24        (1'b1),
    .smc_haddr24         (32'd0),
    .smc_htrans24        (2'b00),
    .smc_hsel24          (1'b0),
    .smc_hwrite24        (1'b0),
    .smc_hsize24         (3'd0),
    .smc_hwdata24        (32'd0),
    .smc_hready_in24     (1'b1),
    .smc_hburst24        (3'b000),
    .smc_hprot24         (4'b0000),
    .smc_hmaster24       (4'b0000),
    .smc_hmastlock24     (1'b0),

    //interrupt24 from DMA24
    .DMA_irq24           (1'b0),      

    // Scan24 inputs24
    .scan_en24           (1'b0),         // Scan24 enable pin24
    .scan_in_124         (1'b0),         // Scan24 input for first chain24
    .scan_in_224         (1'b0),        // Scan24 input for second chain24
    .scan_mode24         (1'b0),
    //input for smc24
    .data_smc24          (32'd0),
    //inputs24 for uart24
    .ua_rxd24            (uart_s024.txd24),
    .ua_rxd124           (uart_s124.txd24),
    .ua_ncts24           (uart_s024.cts_n24),
    .ua_ncts124          (uart_s124.cts_n24),
    //inputs24 for spi24
    .n_ss_in24           (1'b1),
    .mi24                (spi_s024.sig_so24),
    .si24                (1'b0),
    .sclk_in24           (1'b0),
    //inputs24 for GPIO24
    .gpio_pin_in24       (gpio_s024.gpio_pin_in24[15:0]),
 
//interrupt24 from Enet24 MAC24
     .macb0_int24     (1'b0),
     .macb1_int24     (1'b0),
     .macb2_int24     (1'b0),
     .macb3_int24     (1'b0),

    // Scan24 outputs24
    .scan_out_124        (),             // Scan24 out for chain24 1
    .scan_out_224        (),             // Scan24 out for chain24 2
   
    //output from APB24 
    // AHB24 interface for AHB2APB24 bridge24
    .hrdata24            (hrdata24),       // Read data provided from target slave24
    .hready24            (hready24),       // Ready24 for new bus cycle from target slave24
    .hresp24             (hresp24),        // Response24 from the bridge24

    // AHB24 interface for SMC24
    .smc_hrdata24        (), 
    .smc_hready24        (),
    .smc_hresp24         (),
  
    //outputs24 from smc24
    .smc_n_ext_oe24      (),
    .smc_data24          (),
    .smc_addr24          (),
    .smc_n_be24          (),
    .smc_n_cs24          (), 
    .smc_n_we24          (),
    .smc_n_wr24          (),
    .smc_n_rd24          (),
    //outputs24 from uart24
    .ua_txd24             (uart_s024.rxd24),
    .ua_txd124            (uart_s124.rxd24),
    .ua_nrts24            (uart_s024.rts_n24),
    .ua_nrts124           (uart_s124.rts_n24),
    // outputs24 from ttc24
    .so                (),
    .mo24                (spi_s024.sig_si24),
    .sclk_out24          (spi_s024.sig_sclk_in24),
    .n_ss_out24          (n_ss_out24[7:0]),
    .n_so_en24           (),
    .n_mo_en24           (),
    .n_sclk_en24         (),
    .n_ss_en24           (),
    //outputs24 from gpio24
    .n_gpio_pin_oe24     (gpio_s024.n_gpio_pin_oe24[15:0]),
    .gpio_pin_out24      (gpio_s024.gpio_pin_out24[15:0]),

//unconnected24 o/p ports24
    .clk_SRPG_macb0_en24(),
    .clk_SRPG_macb1_en24(),
    .clk_SRPG_macb2_en24(),
    .clk_SRPG_macb3_en24(),
    .core06v24(),
    .core08v24(),
    .core10v24(),
    .core12v24(),
    .mte_smc_start24(),
    .mte_uart_start24(),
    .mte_smc_uart_start24(),
    .mte_pm_smc_to_default_start24(),
    .mte_pm_uart_to_default_start24(),
    .mte_pm_smc_uart_to_default_start24(),
    .pcm_irq24(),
    .ttc_irq24(),
    .gpio_irq24(),
    .uart0_irq24(),
    .uart1_irq24(),
    .spi_irq24(),

    .macb3_wakeup24(),
    .macb2_wakeup24(),
    .macb1_wakeup24(),
    .macb0_wakeup24()
);


initial
begin
  tb_hclk24 = 0;
  hresetn24 = 1;

  #1 hresetn24 = 0;
  #1200 hresetn24 = 1;
end

always #50 tb_hclk24 = ~tb_hclk24;

initial begin
  uvm_config_db#(virtual uart_if24)::set(null, "uvm_test_top.ve24.uart024*", "vif24", uart_s024);
  uvm_config_db#(virtual uart_if24)::set(null, "uvm_test_top.ve24.uart124*", "vif24", uart_s124);
  uvm_config_db#(virtual uart_ctrl_internal_if24)::set(null, "uvm_test_top.ve24.apb_ss_env24.apb_uart024.*", "vif24", uart_int024);
  uvm_config_db#(virtual uart_ctrl_internal_if24)::set(null, "uvm_test_top.ve24.apb_ss_env24.apb_uart124.*", "vif24", uart_int124);
  uvm_config_db#(virtual apb_if24)::set(null, "uvm_test_top.ve24.apb024*", "vif24", apbi_mo24);
  uvm_config_db#(virtual ahb_if24)::set(null, "uvm_test_top.ve24.ahb024*", "vif24", ahbi_m024);
  uvm_config_db#(virtual spi_if24)::set(null, "uvm_test_top.ve24.spi024*", "spi_if24", spi_s024);
  uvm_config_db#(virtual gpio_if24)::set(null, "uvm_test_top.ve24.gpio024*", "gpio_if24", gpio_s024);
  run_test();
end

endmodule
