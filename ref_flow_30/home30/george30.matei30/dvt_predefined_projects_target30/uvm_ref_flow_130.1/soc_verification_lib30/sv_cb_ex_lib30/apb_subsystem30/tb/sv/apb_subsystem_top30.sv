/*-------------------------------------------------------------------------
File30 name   : apb_subsystem_top30.v 
Title30       : Top30 level file for the testbench 
Project30     : APB30 Subsystem30
Created30     : March30 2008
Description30 : This30 is top level file which instantiate30 the dut30 apb_subsyste30,.v.
              It also has the assertion30 module which checks30 for the power30 down 
              and power30 up.To30 activate30 the assertion30 ifdef LP_ABV_ON30 is used.       
Notes30       :
-------------------------------------------------------------------------*/ 
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------

 `timescale 1ns/10ps


// Environment30 Constants30
`ifndef AHB_DATA_WIDTH30
  `define AHB_DATA_WIDTH30          32              // AHB30 bus data width [32/64]
`endif
`ifndef AHB_ADDR_WIDTH30
  `define AHB_ADDR_WIDTH30          32              // AHB30 bus address width [32/64]
`endif
`ifndef AHB_DATA_MAX_BIT30
  `define AHB_DATA_MAX_BIT30        31              // MUST30 BE30: AHB_DATA_WIDTH30 - 1
`endif
`ifndef AHB_ADDRESS_MAX_BIT30
  `define AHB_ADDRESS_MAX_BIT30     31              // MUST30 BE30: AHB_ADDR_WIDTH30 - 1
`endif
`ifndef DEFAULT_HREADY_VALUE30
  `define DEFAULT_HREADY_VALUE30    1'b1            // Ready30 Asserted30
`endif

`include "ahb_if30.sv"
`include "apb_if30.sv"
`include "apb_master_if30.sv"
`include "apb_slave_if30.sv"
`include "uart_if30.sv"
`include "spi_if30.sv"
`include "gpio_if30.sv"
`include "coverage30/uart_ctrl_internal_if30.sv"

module apb_subsystem_top30;
  import uvm_pkg::*;
  // Import30 the UVM Utilities30 Package30

  import ahb_pkg30::*;
  import apb_pkg30::*;
  import uart_pkg30::*;
  import gpio_pkg30::*;
  import spi_pkg30::*;
  import uart_ctrl_pkg30::*;
  import apb_subsystem_pkg30::*;

  `include "spi_reg_model30.sv"
  `include "gpio_reg_model30.sv"
  `include "apb_subsystem_reg_rdb30.sv"
  `include "uart_ctrl_reg_seq_lib30.sv"
  `include "spi_reg_seq_lib30.sv"
  `include "gpio_reg_seq_lib30.sv"

  //Include30 module UVC30 sequences
  `include "ahb_user_monitor30.sv"
  `include "apb_subsystem_seq_lib30.sv"
  `include "apb_subsystem_vir_sequencer30.sv"
  `include "apb_subsystem_vir_seq_lib30.sv"

  `include "apb_subsystem_tb30.sv"
  `include "test_lib30.sv"
   
  
   // ====================================
   // SHARED30 signals30
   // ====================================
   
   // clock30
   reg tb_hclk30;
   
   // reset
   reg hresetn30;
   
   // post30-mux30 from master30 mux30
   wire [`AHB_DATA_MAX_BIT30:0] hwdata30;
   wire [`AHB_ADDRESS_MAX_BIT30:0] haddr30;
   wire [1:0]  htrans30;
   wire [2:0]  hburst30;
   wire [2:0]  hsize30;
   wire [3:0]  hprot30;
   wire hwrite30;

   // post30-mux30 from slave30 mux30
   wire        hready30;
   wire [1:0]  hresp30;
   wire [`AHB_DATA_MAX_BIT30:0] hrdata30;
  

  //  Specific30 signals30 of apb30 subsystem30
  reg         ua_rxd30;
  reg         ua_ncts30;


  // uart30 outputs30 
  wire        ua_txd30;
  wire        us_nrts30;

  wire   [7:0] n_ss_out30;    // peripheral30 select30 lines30 from master30
  wire   [31:0] hwdata_byte_alligned30;

  reg [2:0] div8_clk30;
 always @(posedge tb_hclk30) begin
   if (!hresetn30)
     div8_clk30 = 3'b000;
   else
     div8_clk30 = div8_clk30 + 1;
 end


  // Master30 virtual interface
  ahb_if30 ahbi_m030(.ahb_clock30(tb_hclk30), .ahb_resetn30(hresetn30));
  
  uart_if30 uart_s030(.clock30(div8_clk30[2]), .reset(hresetn30));
  uart_if30 uart_s130(.clock30(div8_clk30[2]), .reset(hresetn30));
  spi_if30 spi_s030();
  gpio_if30 gpio_s030();
  uart_ctrl_internal_if30 uart_int030(.clock30(div8_clk30[2]));
  uart_ctrl_internal_if30 uart_int130(.clock30(div8_clk30[2]));

  apb_if30 apbi_mo30(.pclock30(tb_hclk30), .preset30(hresetn30));

  //M030
  assign ahbi_m030.AHB_HCLK30 = tb_hclk30;
  assign ahbi_m030.AHB_HRESET30 = hresetn30;
  assign ahbi_m030.AHB_HRESP30 = hresp30;
  assign ahbi_m030.AHB_HRDATA30 = hrdata30;
  assign ahbi_m030.AHB_HREADY30 = hready30;

  assign apbi_mo30.paddr30 = i_apb_subsystem30.i_ahb2apb30.paddr30;
  assign apbi_mo30.prwd30 = i_apb_subsystem30.i_ahb2apb30.pwrite30;
  assign apbi_mo30.pwdata30 = i_apb_subsystem30.i_ahb2apb30.pwdata30;
  assign apbi_mo30.penable30 = i_apb_subsystem30.i_ahb2apb30.penable30;
  assign apbi_mo30.psel30 = {12'b0, i_apb_subsystem30.i_ahb2apb30.psel830, i_apb_subsystem30.i_ahb2apb30.psel230, i_apb_subsystem30.i_ahb2apb30.psel130, i_apb_subsystem30.i_ahb2apb30.psel030};
  assign apbi_mo30.prdata30 = i_apb_subsystem30.i_ahb2apb30.psel030? i_apb_subsystem30.i_ahb2apb30.prdata030 : (i_apb_subsystem30.i_ahb2apb30.psel130? i_apb_subsystem30.i_ahb2apb30.prdata130 : (i_apb_subsystem30.i_ahb2apb30.psel230? i_apb_subsystem30.i_ahb2apb30.prdata230 : i_apb_subsystem30.i_ahb2apb30.prdata830));

  assign spi_s030.sig_n_ss_in30 = n_ss_out30[0];
  assign spi_s030.sig_n_p_reset30 = hresetn30;
  assign spi_s030.sig_pclk30 = tb_hclk30;

  assign gpio_s030.n_p_reset30 = hresetn30;
  assign gpio_s030.pclk30 = tb_hclk30;

  assign hwdata_byte_alligned30 = (ahbi_m030.AHB_HADDR30[1:0] == 2'b00) ? ahbi_m030.AHB_HWDATA30 : {4{ahbi_m030.AHB_HWDATA30[7:0]}};

  apb_subsystem_030 i_apb_subsystem30 (
    // Inputs30
    // system signals30
    .hclk30              (tb_hclk30),     // AHB30 Clock30
    .n_hreset30          (hresetn30),     // AHB30 reset - Active30 low30
    .pclk30              (tb_hclk30),     // APB30 Clock30
    .n_preset30          (hresetn30),     // APB30 reset - Active30 low30
    
    // AHB30 interface for AHB2APM30 bridge30
    .hsel30     (1'b1),        // AHB2APB30 select30
    .haddr30             (ahbi_m030.AHB_HADDR30),        // Address bus
    .htrans30            (ahbi_m030.AHB_HTRANS30),       // Transfer30 type
    .hsize30             (ahbi_m030.AHB_HSIZE30),        // AHB30 Access type - byte half30-word30 word30
    .hwrite30            (ahbi_m030.AHB_HWRITE30),       // Write signal30
    .hwdata30            (hwdata_byte_alligned30),       // Write data
    .hready_in30         (hready30),       // Indicates30 that the last master30 has finished30 
                                       // its bus access
    .hburst30            (ahbi_m030.AHB_HBURST30),       // Burst type
    .hprot30             (ahbi_m030.AHB_HPROT30),        // Protection30 control30
    .hmaster30           (4'h0),      // Master30 select30
    .hmastlock30         (ahbi_m030.AHB_HLOCK30),  // Locked30 transfer30
    // AHB30 interface for SMC30
    .smc_hclk30          (1'b0),
    .smc_n_hclk30        (1'b1),
    .smc_haddr30         (32'd0),
    .smc_htrans30        (2'b00),
    .smc_hsel30          (1'b0),
    .smc_hwrite30        (1'b0),
    .smc_hsize30         (3'd0),
    .smc_hwdata30        (32'd0),
    .smc_hready_in30     (1'b1),
    .smc_hburst30        (3'b000),
    .smc_hprot30         (4'b0000),
    .smc_hmaster30       (4'b0000),
    .smc_hmastlock30     (1'b0),

    //interrupt30 from DMA30
    .DMA_irq30           (1'b0),      

    // Scan30 inputs30
    .scan_en30           (1'b0),         // Scan30 enable pin30
    .scan_in_130         (1'b0),         // Scan30 input for first chain30
    .scan_in_230         (1'b0),        // Scan30 input for second chain30
    .scan_mode30         (1'b0),
    //input for smc30
    .data_smc30          (32'd0),
    //inputs30 for uart30
    .ua_rxd30            (uart_s030.txd30),
    .ua_rxd130           (uart_s130.txd30),
    .ua_ncts30           (uart_s030.cts_n30),
    .ua_ncts130          (uart_s130.cts_n30),
    //inputs30 for spi30
    .n_ss_in30           (1'b1),
    .mi30                (spi_s030.sig_so30),
    .si30                (1'b0),
    .sclk_in30           (1'b0),
    //inputs30 for GPIO30
    .gpio_pin_in30       (gpio_s030.gpio_pin_in30[15:0]),
 
//interrupt30 from Enet30 MAC30
     .macb0_int30     (1'b0),
     .macb1_int30     (1'b0),
     .macb2_int30     (1'b0),
     .macb3_int30     (1'b0),

    // Scan30 outputs30
    .scan_out_130        (),             // Scan30 out for chain30 1
    .scan_out_230        (),             // Scan30 out for chain30 2
   
    //output from APB30 
    // AHB30 interface for AHB2APB30 bridge30
    .hrdata30            (hrdata30),       // Read data provided from target slave30
    .hready30            (hready30),       // Ready30 for new bus cycle from target slave30
    .hresp30             (hresp30),        // Response30 from the bridge30

    // AHB30 interface for SMC30
    .smc_hrdata30        (), 
    .smc_hready30        (),
    .smc_hresp30         (),
  
    //outputs30 from smc30
    .smc_n_ext_oe30      (),
    .smc_data30          (),
    .smc_addr30          (),
    .smc_n_be30          (),
    .smc_n_cs30          (), 
    .smc_n_we30          (),
    .smc_n_wr30          (),
    .smc_n_rd30          (),
    //outputs30 from uart30
    .ua_txd30             (uart_s030.rxd30),
    .ua_txd130            (uart_s130.rxd30),
    .ua_nrts30            (uart_s030.rts_n30),
    .ua_nrts130           (uart_s130.rts_n30),
    // outputs30 from ttc30
    .so                (),
    .mo30                (spi_s030.sig_si30),
    .sclk_out30          (spi_s030.sig_sclk_in30),
    .n_ss_out30          (n_ss_out30[7:0]),
    .n_so_en30           (),
    .n_mo_en30           (),
    .n_sclk_en30         (),
    .n_ss_en30           (),
    //outputs30 from gpio30
    .n_gpio_pin_oe30     (gpio_s030.n_gpio_pin_oe30[15:0]),
    .gpio_pin_out30      (gpio_s030.gpio_pin_out30[15:0]),

//unconnected30 o/p ports30
    .clk_SRPG_macb0_en30(),
    .clk_SRPG_macb1_en30(),
    .clk_SRPG_macb2_en30(),
    .clk_SRPG_macb3_en30(),
    .core06v30(),
    .core08v30(),
    .core10v30(),
    .core12v30(),
    .mte_smc_start30(),
    .mte_uart_start30(),
    .mte_smc_uart_start30(),
    .mte_pm_smc_to_default_start30(),
    .mte_pm_uart_to_default_start30(),
    .mte_pm_smc_uart_to_default_start30(),
    .pcm_irq30(),
    .ttc_irq30(),
    .gpio_irq30(),
    .uart0_irq30(),
    .uart1_irq30(),
    .spi_irq30(),

    .macb3_wakeup30(),
    .macb2_wakeup30(),
    .macb1_wakeup30(),
    .macb0_wakeup30()
);


initial
begin
  tb_hclk30 = 0;
  hresetn30 = 1;

  #1 hresetn30 = 0;
  #1200 hresetn30 = 1;
end

always #50 tb_hclk30 = ~tb_hclk30;

initial begin
  uvm_config_db#(virtual uart_if30)::set(null, "uvm_test_top.ve30.uart030*", "vif30", uart_s030);
  uvm_config_db#(virtual uart_if30)::set(null, "uvm_test_top.ve30.uart130*", "vif30", uart_s130);
  uvm_config_db#(virtual uart_ctrl_internal_if30)::set(null, "uvm_test_top.ve30.apb_ss_env30.apb_uart030.*", "vif30", uart_int030);
  uvm_config_db#(virtual uart_ctrl_internal_if30)::set(null, "uvm_test_top.ve30.apb_ss_env30.apb_uart130.*", "vif30", uart_int130);
  uvm_config_db#(virtual apb_if30)::set(null, "uvm_test_top.ve30.apb030*", "vif30", apbi_mo30);
  uvm_config_db#(virtual ahb_if30)::set(null, "uvm_test_top.ve30.ahb030*", "vif30", ahbi_m030);
  uvm_config_db#(virtual spi_if30)::set(null, "uvm_test_top.ve30.spi030*", "spi_if30", spi_s030);
  uvm_config_db#(virtual gpio_if30)::set(null, "uvm_test_top.ve30.gpio030*", "gpio_if30", gpio_s030);
  run_test();
end

endmodule
