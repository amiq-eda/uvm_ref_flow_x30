/*-------------------------------------------------------------------------
File28 name   : apb_subsystem_top28.v 
Title28       : Top28 level file for the testbench 
Project28     : APB28 Subsystem28
Created28     : March28 2008
Description28 : This28 is top level file which instantiate28 the dut28 apb_subsyste28,.v.
              It also has the assertion28 module which checks28 for the power28 down 
              and power28 up.To28 activate28 the assertion28 ifdef LP_ABV_ON28 is used.       
Notes28       :
-------------------------------------------------------------------------*/ 
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------

 `timescale 1ns/10ps


// Environment28 Constants28
`ifndef AHB_DATA_WIDTH28
  `define AHB_DATA_WIDTH28          32              // AHB28 bus data width [32/64]
`endif
`ifndef AHB_ADDR_WIDTH28
  `define AHB_ADDR_WIDTH28          32              // AHB28 bus address width [32/64]
`endif
`ifndef AHB_DATA_MAX_BIT28
  `define AHB_DATA_MAX_BIT28        31              // MUST28 BE28: AHB_DATA_WIDTH28 - 1
`endif
`ifndef AHB_ADDRESS_MAX_BIT28
  `define AHB_ADDRESS_MAX_BIT28     31              // MUST28 BE28: AHB_ADDR_WIDTH28 - 1
`endif
`ifndef DEFAULT_HREADY_VALUE28
  `define DEFAULT_HREADY_VALUE28    1'b1            // Ready28 Asserted28
`endif

`include "ahb_if28.sv"
`include "apb_if28.sv"
`include "apb_master_if28.sv"
`include "apb_slave_if28.sv"
`include "uart_if28.sv"
`include "spi_if28.sv"
`include "gpio_if28.sv"
`include "coverage28/uart_ctrl_internal_if28.sv"

module apb_subsystem_top28;
  import uvm_pkg::*;
  // Import28 the UVM Utilities28 Package28

  import ahb_pkg28::*;
  import apb_pkg28::*;
  import uart_pkg28::*;
  import gpio_pkg28::*;
  import spi_pkg28::*;
  import uart_ctrl_pkg28::*;
  import apb_subsystem_pkg28::*;

  `include "spi_reg_model28.sv"
  `include "gpio_reg_model28.sv"
  `include "apb_subsystem_reg_rdb28.sv"
  `include "uart_ctrl_reg_seq_lib28.sv"
  `include "spi_reg_seq_lib28.sv"
  `include "gpio_reg_seq_lib28.sv"

  //Include28 module UVC28 sequences
  `include "ahb_user_monitor28.sv"
  `include "apb_subsystem_seq_lib28.sv"
  `include "apb_subsystem_vir_sequencer28.sv"
  `include "apb_subsystem_vir_seq_lib28.sv"

  `include "apb_subsystem_tb28.sv"
  `include "test_lib28.sv"
   
  
   // ====================================
   // SHARED28 signals28
   // ====================================
   
   // clock28
   reg tb_hclk28;
   
   // reset
   reg hresetn28;
   
   // post28-mux28 from master28 mux28
   wire [`AHB_DATA_MAX_BIT28:0] hwdata28;
   wire [`AHB_ADDRESS_MAX_BIT28:0] haddr28;
   wire [1:0]  htrans28;
   wire [2:0]  hburst28;
   wire [2:0]  hsize28;
   wire [3:0]  hprot28;
   wire hwrite28;

   // post28-mux28 from slave28 mux28
   wire        hready28;
   wire [1:0]  hresp28;
   wire [`AHB_DATA_MAX_BIT28:0] hrdata28;
  

  //  Specific28 signals28 of apb28 subsystem28
  reg         ua_rxd28;
  reg         ua_ncts28;


  // uart28 outputs28 
  wire        ua_txd28;
  wire        us_nrts28;

  wire   [7:0] n_ss_out28;    // peripheral28 select28 lines28 from master28
  wire   [31:0] hwdata_byte_alligned28;

  reg [2:0] div8_clk28;
 always @(posedge tb_hclk28) begin
   if (!hresetn28)
     div8_clk28 = 3'b000;
   else
     div8_clk28 = div8_clk28 + 1;
 end


  // Master28 virtual interface
  ahb_if28 ahbi_m028(.ahb_clock28(tb_hclk28), .ahb_resetn28(hresetn28));
  
  uart_if28 uart_s028(.clock28(div8_clk28[2]), .reset(hresetn28));
  uart_if28 uart_s128(.clock28(div8_clk28[2]), .reset(hresetn28));
  spi_if28 spi_s028();
  gpio_if28 gpio_s028();
  uart_ctrl_internal_if28 uart_int028(.clock28(div8_clk28[2]));
  uart_ctrl_internal_if28 uart_int128(.clock28(div8_clk28[2]));

  apb_if28 apbi_mo28(.pclock28(tb_hclk28), .preset28(hresetn28));

  //M028
  assign ahbi_m028.AHB_HCLK28 = tb_hclk28;
  assign ahbi_m028.AHB_HRESET28 = hresetn28;
  assign ahbi_m028.AHB_HRESP28 = hresp28;
  assign ahbi_m028.AHB_HRDATA28 = hrdata28;
  assign ahbi_m028.AHB_HREADY28 = hready28;

  assign apbi_mo28.paddr28 = i_apb_subsystem28.i_ahb2apb28.paddr28;
  assign apbi_mo28.prwd28 = i_apb_subsystem28.i_ahb2apb28.pwrite28;
  assign apbi_mo28.pwdata28 = i_apb_subsystem28.i_ahb2apb28.pwdata28;
  assign apbi_mo28.penable28 = i_apb_subsystem28.i_ahb2apb28.penable28;
  assign apbi_mo28.psel28 = {12'b0, i_apb_subsystem28.i_ahb2apb28.psel828, i_apb_subsystem28.i_ahb2apb28.psel228, i_apb_subsystem28.i_ahb2apb28.psel128, i_apb_subsystem28.i_ahb2apb28.psel028};
  assign apbi_mo28.prdata28 = i_apb_subsystem28.i_ahb2apb28.psel028? i_apb_subsystem28.i_ahb2apb28.prdata028 : (i_apb_subsystem28.i_ahb2apb28.psel128? i_apb_subsystem28.i_ahb2apb28.prdata128 : (i_apb_subsystem28.i_ahb2apb28.psel228? i_apb_subsystem28.i_ahb2apb28.prdata228 : i_apb_subsystem28.i_ahb2apb28.prdata828));

  assign spi_s028.sig_n_ss_in28 = n_ss_out28[0];
  assign spi_s028.sig_n_p_reset28 = hresetn28;
  assign spi_s028.sig_pclk28 = tb_hclk28;

  assign gpio_s028.n_p_reset28 = hresetn28;
  assign gpio_s028.pclk28 = tb_hclk28;

  assign hwdata_byte_alligned28 = (ahbi_m028.AHB_HADDR28[1:0] == 2'b00) ? ahbi_m028.AHB_HWDATA28 : {4{ahbi_m028.AHB_HWDATA28[7:0]}};

  apb_subsystem_028 i_apb_subsystem28 (
    // Inputs28
    // system signals28
    .hclk28              (tb_hclk28),     // AHB28 Clock28
    .n_hreset28          (hresetn28),     // AHB28 reset - Active28 low28
    .pclk28              (tb_hclk28),     // APB28 Clock28
    .n_preset28          (hresetn28),     // APB28 reset - Active28 low28
    
    // AHB28 interface for AHB2APM28 bridge28
    .hsel28     (1'b1),        // AHB2APB28 select28
    .haddr28             (ahbi_m028.AHB_HADDR28),        // Address bus
    .htrans28            (ahbi_m028.AHB_HTRANS28),       // Transfer28 type
    .hsize28             (ahbi_m028.AHB_HSIZE28),        // AHB28 Access type - byte half28-word28 word28
    .hwrite28            (ahbi_m028.AHB_HWRITE28),       // Write signal28
    .hwdata28            (hwdata_byte_alligned28),       // Write data
    .hready_in28         (hready28),       // Indicates28 that the last master28 has finished28 
                                       // its bus access
    .hburst28            (ahbi_m028.AHB_HBURST28),       // Burst type
    .hprot28             (ahbi_m028.AHB_HPROT28),        // Protection28 control28
    .hmaster28           (4'h0),      // Master28 select28
    .hmastlock28         (ahbi_m028.AHB_HLOCK28),  // Locked28 transfer28
    // AHB28 interface for SMC28
    .smc_hclk28          (1'b0),
    .smc_n_hclk28        (1'b1),
    .smc_haddr28         (32'd0),
    .smc_htrans28        (2'b00),
    .smc_hsel28          (1'b0),
    .smc_hwrite28        (1'b0),
    .smc_hsize28         (3'd0),
    .smc_hwdata28        (32'd0),
    .smc_hready_in28     (1'b1),
    .smc_hburst28        (3'b000),
    .smc_hprot28         (4'b0000),
    .smc_hmaster28       (4'b0000),
    .smc_hmastlock28     (1'b0),

    //interrupt28 from DMA28
    .DMA_irq28           (1'b0),      

    // Scan28 inputs28
    .scan_en28           (1'b0),         // Scan28 enable pin28
    .scan_in_128         (1'b0),         // Scan28 input for first chain28
    .scan_in_228         (1'b0),        // Scan28 input for second chain28
    .scan_mode28         (1'b0),
    //input for smc28
    .data_smc28          (32'd0),
    //inputs28 for uart28
    .ua_rxd28            (uart_s028.txd28),
    .ua_rxd128           (uart_s128.txd28),
    .ua_ncts28           (uart_s028.cts_n28),
    .ua_ncts128          (uart_s128.cts_n28),
    //inputs28 for spi28
    .n_ss_in28           (1'b1),
    .mi28                (spi_s028.sig_so28),
    .si28                (1'b0),
    .sclk_in28           (1'b0),
    //inputs28 for GPIO28
    .gpio_pin_in28       (gpio_s028.gpio_pin_in28[15:0]),
 
//interrupt28 from Enet28 MAC28
     .macb0_int28     (1'b0),
     .macb1_int28     (1'b0),
     .macb2_int28     (1'b0),
     .macb3_int28     (1'b0),

    // Scan28 outputs28
    .scan_out_128        (),             // Scan28 out for chain28 1
    .scan_out_228        (),             // Scan28 out for chain28 2
   
    //output from APB28 
    // AHB28 interface for AHB2APB28 bridge28
    .hrdata28            (hrdata28),       // Read data provided from target slave28
    .hready28            (hready28),       // Ready28 for new bus cycle from target slave28
    .hresp28             (hresp28),        // Response28 from the bridge28

    // AHB28 interface for SMC28
    .smc_hrdata28        (), 
    .smc_hready28        (),
    .smc_hresp28         (),
  
    //outputs28 from smc28
    .smc_n_ext_oe28      (),
    .smc_data28          (),
    .smc_addr28          (),
    .smc_n_be28          (),
    .smc_n_cs28          (), 
    .smc_n_we28          (),
    .smc_n_wr28          (),
    .smc_n_rd28          (),
    //outputs28 from uart28
    .ua_txd28             (uart_s028.rxd28),
    .ua_txd128            (uart_s128.rxd28),
    .ua_nrts28            (uart_s028.rts_n28),
    .ua_nrts128           (uart_s128.rts_n28),
    // outputs28 from ttc28
    .so                (),
    .mo28                (spi_s028.sig_si28),
    .sclk_out28          (spi_s028.sig_sclk_in28),
    .n_ss_out28          (n_ss_out28[7:0]),
    .n_so_en28           (),
    .n_mo_en28           (),
    .n_sclk_en28         (),
    .n_ss_en28           (),
    //outputs28 from gpio28
    .n_gpio_pin_oe28     (gpio_s028.n_gpio_pin_oe28[15:0]),
    .gpio_pin_out28      (gpio_s028.gpio_pin_out28[15:0]),

//unconnected28 o/p ports28
    .clk_SRPG_macb0_en28(),
    .clk_SRPG_macb1_en28(),
    .clk_SRPG_macb2_en28(),
    .clk_SRPG_macb3_en28(),
    .core06v28(),
    .core08v28(),
    .core10v28(),
    .core12v28(),
    .mte_smc_start28(),
    .mte_uart_start28(),
    .mte_smc_uart_start28(),
    .mte_pm_smc_to_default_start28(),
    .mte_pm_uart_to_default_start28(),
    .mte_pm_smc_uart_to_default_start28(),
    .pcm_irq28(),
    .ttc_irq28(),
    .gpio_irq28(),
    .uart0_irq28(),
    .uart1_irq28(),
    .spi_irq28(),

    .macb3_wakeup28(),
    .macb2_wakeup28(),
    .macb1_wakeup28(),
    .macb0_wakeup28()
);


initial
begin
  tb_hclk28 = 0;
  hresetn28 = 1;

  #1 hresetn28 = 0;
  #1200 hresetn28 = 1;
end

always #50 tb_hclk28 = ~tb_hclk28;

initial begin
  uvm_config_db#(virtual uart_if28)::set(null, "uvm_test_top.ve28.uart028*", "vif28", uart_s028);
  uvm_config_db#(virtual uart_if28)::set(null, "uvm_test_top.ve28.uart128*", "vif28", uart_s128);
  uvm_config_db#(virtual uart_ctrl_internal_if28)::set(null, "uvm_test_top.ve28.apb_ss_env28.apb_uart028.*", "vif28", uart_int028);
  uvm_config_db#(virtual uart_ctrl_internal_if28)::set(null, "uvm_test_top.ve28.apb_ss_env28.apb_uart128.*", "vif28", uart_int128);
  uvm_config_db#(virtual apb_if28)::set(null, "uvm_test_top.ve28.apb028*", "vif28", apbi_mo28);
  uvm_config_db#(virtual ahb_if28)::set(null, "uvm_test_top.ve28.ahb028*", "vif28", ahbi_m028);
  uvm_config_db#(virtual spi_if28)::set(null, "uvm_test_top.ve28.spi028*", "spi_if28", spi_s028);
  uvm_config_db#(virtual gpio_if28)::set(null, "uvm_test_top.ve28.gpio028*", "gpio_if28", gpio_s028);
  run_test();
end

endmodule
