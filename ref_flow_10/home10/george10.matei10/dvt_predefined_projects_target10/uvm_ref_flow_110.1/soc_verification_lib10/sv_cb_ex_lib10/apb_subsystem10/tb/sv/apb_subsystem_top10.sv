/*-------------------------------------------------------------------------
File10 name   : apb_subsystem_top10.v 
Title10       : Top10 level file for the testbench 
Project10     : APB10 Subsystem10
Created10     : March10 2008
Description10 : This10 is top level file which instantiate10 the dut10 apb_subsyste10,.v.
              It also has the assertion10 module which checks10 for the power10 down 
              and power10 up.To10 activate10 the assertion10 ifdef LP_ABV_ON10 is used.       
Notes10       :
-------------------------------------------------------------------------*/ 
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------

 `timescale 1ns/10ps


// Environment10 Constants10
`ifndef AHB_DATA_WIDTH10
  `define AHB_DATA_WIDTH10          32              // AHB10 bus data width [32/64]
`endif
`ifndef AHB_ADDR_WIDTH10
  `define AHB_ADDR_WIDTH10          32              // AHB10 bus address width [32/64]
`endif
`ifndef AHB_DATA_MAX_BIT10
  `define AHB_DATA_MAX_BIT10        31              // MUST10 BE10: AHB_DATA_WIDTH10 - 1
`endif
`ifndef AHB_ADDRESS_MAX_BIT10
  `define AHB_ADDRESS_MAX_BIT10     31              // MUST10 BE10: AHB_ADDR_WIDTH10 - 1
`endif
`ifndef DEFAULT_HREADY_VALUE10
  `define DEFAULT_HREADY_VALUE10    1'b1            // Ready10 Asserted10
`endif

`include "ahb_if10.sv"
`include "apb_if10.sv"
`include "apb_master_if10.sv"
`include "apb_slave_if10.sv"
`include "uart_if10.sv"
`include "spi_if10.sv"
`include "gpio_if10.sv"
`include "coverage10/uart_ctrl_internal_if10.sv"

module apb_subsystem_top10;
  import uvm_pkg::*;
  // Import10 the UVM Utilities10 Package10

  import ahb_pkg10::*;
  import apb_pkg10::*;
  import uart_pkg10::*;
  import gpio_pkg10::*;
  import spi_pkg10::*;
  import uart_ctrl_pkg10::*;
  import apb_subsystem_pkg10::*;

  `include "spi_reg_model10.sv"
  `include "gpio_reg_model10.sv"
  `include "apb_subsystem_reg_rdb10.sv"
  `include "uart_ctrl_reg_seq_lib10.sv"
  `include "spi_reg_seq_lib10.sv"
  `include "gpio_reg_seq_lib10.sv"

  //Include10 module UVC10 sequences
  `include "ahb_user_monitor10.sv"
  `include "apb_subsystem_seq_lib10.sv"
  `include "apb_subsystem_vir_sequencer10.sv"
  `include "apb_subsystem_vir_seq_lib10.sv"

  `include "apb_subsystem_tb10.sv"
  `include "test_lib10.sv"
   
  
   // ====================================
   // SHARED10 signals10
   // ====================================
   
   // clock10
   reg tb_hclk10;
   
   // reset
   reg hresetn10;
   
   // post10-mux10 from master10 mux10
   wire [`AHB_DATA_MAX_BIT10:0] hwdata10;
   wire [`AHB_ADDRESS_MAX_BIT10:0] haddr10;
   wire [1:0]  htrans10;
   wire [2:0]  hburst10;
   wire [2:0]  hsize10;
   wire [3:0]  hprot10;
   wire hwrite10;

   // post10-mux10 from slave10 mux10
   wire        hready10;
   wire [1:0]  hresp10;
   wire [`AHB_DATA_MAX_BIT10:0] hrdata10;
  

  //  Specific10 signals10 of apb10 subsystem10
  reg         ua_rxd10;
  reg         ua_ncts10;


  // uart10 outputs10 
  wire        ua_txd10;
  wire        us_nrts10;

  wire   [7:0] n_ss_out10;    // peripheral10 select10 lines10 from master10
  wire   [31:0] hwdata_byte_alligned10;

  reg [2:0] div8_clk10;
 always @(posedge tb_hclk10) begin
   if (!hresetn10)
     div8_clk10 = 3'b000;
   else
     div8_clk10 = div8_clk10 + 1;
 end


  // Master10 virtual interface
  ahb_if10 ahbi_m010(.ahb_clock10(tb_hclk10), .ahb_resetn10(hresetn10));
  
  uart_if10 uart_s010(.clock10(div8_clk10[2]), .reset(hresetn10));
  uart_if10 uart_s110(.clock10(div8_clk10[2]), .reset(hresetn10));
  spi_if10 spi_s010();
  gpio_if10 gpio_s010();
  uart_ctrl_internal_if10 uart_int010(.clock10(div8_clk10[2]));
  uart_ctrl_internal_if10 uart_int110(.clock10(div8_clk10[2]));

  apb_if10 apbi_mo10(.pclock10(tb_hclk10), .preset10(hresetn10));

  //M010
  assign ahbi_m010.AHB_HCLK10 = tb_hclk10;
  assign ahbi_m010.AHB_HRESET10 = hresetn10;
  assign ahbi_m010.AHB_HRESP10 = hresp10;
  assign ahbi_m010.AHB_HRDATA10 = hrdata10;
  assign ahbi_m010.AHB_HREADY10 = hready10;

  assign apbi_mo10.paddr10 = i_apb_subsystem10.i_ahb2apb10.paddr10;
  assign apbi_mo10.prwd10 = i_apb_subsystem10.i_ahb2apb10.pwrite10;
  assign apbi_mo10.pwdata10 = i_apb_subsystem10.i_ahb2apb10.pwdata10;
  assign apbi_mo10.penable10 = i_apb_subsystem10.i_ahb2apb10.penable10;
  assign apbi_mo10.psel10 = {12'b0, i_apb_subsystem10.i_ahb2apb10.psel810, i_apb_subsystem10.i_ahb2apb10.psel210, i_apb_subsystem10.i_ahb2apb10.psel110, i_apb_subsystem10.i_ahb2apb10.psel010};
  assign apbi_mo10.prdata10 = i_apb_subsystem10.i_ahb2apb10.psel010? i_apb_subsystem10.i_ahb2apb10.prdata010 : (i_apb_subsystem10.i_ahb2apb10.psel110? i_apb_subsystem10.i_ahb2apb10.prdata110 : (i_apb_subsystem10.i_ahb2apb10.psel210? i_apb_subsystem10.i_ahb2apb10.prdata210 : i_apb_subsystem10.i_ahb2apb10.prdata810));

  assign spi_s010.sig_n_ss_in10 = n_ss_out10[0];
  assign spi_s010.sig_n_p_reset10 = hresetn10;
  assign spi_s010.sig_pclk10 = tb_hclk10;

  assign gpio_s010.n_p_reset10 = hresetn10;
  assign gpio_s010.pclk10 = tb_hclk10;

  assign hwdata_byte_alligned10 = (ahbi_m010.AHB_HADDR10[1:0] == 2'b00) ? ahbi_m010.AHB_HWDATA10 : {4{ahbi_m010.AHB_HWDATA10[7:0]}};

  apb_subsystem_010 i_apb_subsystem10 (
    // Inputs10
    // system signals10
    .hclk10              (tb_hclk10),     // AHB10 Clock10
    .n_hreset10          (hresetn10),     // AHB10 reset - Active10 low10
    .pclk10              (tb_hclk10),     // APB10 Clock10
    .n_preset10          (hresetn10),     // APB10 reset - Active10 low10
    
    // AHB10 interface for AHB2APM10 bridge10
    .hsel10     (1'b1),        // AHB2APB10 select10
    .haddr10             (ahbi_m010.AHB_HADDR10),        // Address bus
    .htrans10            (ahbi_m010.AHB_HTRANS10),       // Transfer10 type
    .hsize10             (ahbi_m010.AHB_HSIZE10),        // AHB10 Access type - byte half10-word10 word10
    .hwrite10            (ahbi_m010.AHB_HWRITE10),       // Write signal10
    .hwdata10            (hwdata_byte_alligned10),       // Write data
    .hready_in10         (hready10),       // Indicates10 that the last master10 has finished10 
                                       // its bus access
    .hburst10            (ahbi_m010.AHB_HBURST10),       // Burst type
    .hprot10             (ahbi_m010.AHB_HPROT10),        // Protection10 control10
    .hmaster10           (4'h0),      // Master10 select10
    .hmastlock10         (ahbi_m010.AHB_HLOCK10),  // Locked10 transfer10
    // AHB10 interface for SMC10
    .smc_hclk10          (1'b0),
    .smc_n_hclk10        (1'b1),
    .smc_haddr10         (32'd0),
    .smc_htrans10        (2'b00),
    .smc_hsel10          (1'b0),
    .smc_hwrite10        (1'b0),
    .smc_hsize10         (3'd0),
    .smc_hwdata10        (32'd0),
    .smc_hready_in10     (1'b1),
    .smc_hburst10        (3'b000),
    .smc_hprot10         (4'b0000),
    .smc_hmaster10       (4'b0000),
    .smc_hmastlock10     (1'b0),

    //interrupt10 from DMA10
    .DMA_irq10           (1'b0),      

    // Scan10 inputs10
    .scan_en10           (1'b0),         // Scan10 enable pin10
    .scan_in_110         (1'b0),         // Scan10 input for first chain10
    .scan_in_210         (1'b0),        // Scan10 input for second chain10
    .scan_mode10         (1'b0),
    //input for smc10
    .data_smc10          (32'd0),
    //inputs10 for uart10
    .ua_rxd10            (uart_s010.txd10),
    .ua_rxd110           (uart_s110.txd10),
    .ua_ncts10           (uart_s010.cts_n10),
    .ua_ncts110          (uart_s110.cts_n10),
    //inputs10 for spi10
    .n_ss_in10           (1'b1),
    .mi10                (spi_s010.sig_so10),
    .si10                (1'b0),
    .sclk_in10           (1'b0),
    //inputs10 for GPIO10
    .gpio_pin_in10       (gpio_s010.gpio_pin_in10[15:0]),
 
//interrupt10 from Enet10 MAC10
     .macb0_int10     (1'b0),
     .macb1_int10     (1'b0),
     .macb2_int10     (1'b0),
     .macb3_int10     (1'b0),

    // Scan10 outputs10
    .scan_out_110        (),             // Scan10 out for chain10 1
    .scan_out_210        (),             // Scan10 out for chain10 2
   
    //output from APB10 
    // AHB10 interface for AHB2APB10 bridge10
    .hrdata10            (hrdata10),       // Read data provided from target slave10
    .hready10            (hready10),       // Ready10 for new bus cycle from target slave10
    .hresp10             (hresp10),        // Response10 from the bridge10

    // AHB10 interface for SMC10
    .smc_hrdata10        (), 
    .smc_hready10        (),
    .smc_hresp10         (),
  
    //outputs10 from smc10
    .smc_n_ext_oe10      (),
    .smc_data10          (),
    .smc_addr10          (),
    .smc_n_be10          (),
    .smc_n_cs10          (), 
    .smc_n_we10          (),
    .smc_n_wr10          (),
    .smc_n_rd10          (),
    //outputs10 from uart10
    .ua_txd10             (uart_s010.rxd10),
    .ua_txd110            (uart_s110.rxd10),
    .ua_nrts10            (uart_s010.rts_n10),
    .ua_nrts110           (uart_s110.rts_n10),
    // outputs10 from ttc10
    .so                (),
    .mo10                (spi_s010.sig_si10),
    .sclk_out10          (spi_s010.sig_sclk_in10),
    .n_ss_out10          (n_ss_out10[7:0]),
    .n_so_en10           (),
    .n_mo_en10           (),
    .n_sclk_en10         (),
    .n_ss_en10           (),
    //outputs10 from gpio10
    .n_gpio_pin_oe10     (gpio_s010.n_gpio_pin_oe10[15:0]),
    .gpio_pin_out10      (gpio_s010.gpio_pin_out10[15:0]),

//unconnected10 o/p ports10
    .clk_SRPG_macb0_en10(),
    .clk_SRPG_macb1_en10(),
    .clk_SRPG_macb2_en10(),
    .clk_SRPG_macb3_en10(),
    .core06v10(),
    .core08v10(),
    .core10v10(),
    .core12v10(),
    .mte_smc_start10(),
    .mte_uart_start10(),
    .mte_smc_uart_start10(),
    .mte_pm_smc_to_default_start10(),
    .mte_pm_uart_to_default_start10(),
    .mte_pm_smc_uart_to_default_start10(),
    .pcm_irq10(),
    .ttc_irq10(),
    .gpio_irq10(),
    .uart0_irq10(),
    .uart1_irq10(),
    .spi_irq10(),

    .macb3_wakeup10(),
    .macb2_wakeup10(),
    .macb1_wakeup10(),
    .macb0_wakeup10()
);


initial
begin
  tb_hclk10 = 0;
  hresetn10 = 1;

  #1 hresetn10 = 0;
  #1200 hresetn10 = 1;
end

always #50 tb_hclk10 = ~tb_hclk10;

initial begin
  uvm_config_db#(virtual uart_if10)::set(null, "uvm_test_top.ve10.uart010*", "vif10", uart_s010);
  uvm_config_db#(virtual uart_if10)::set(null, "uvm_test_top.ve10.uart110*", "vif10", uart_s110);
  uvm_config_db#(virtual uart_ctrl_internal_if10)::set(null, "uvm_test_top.ve10.apb_ss_env10.apb_uart010.*", "vif10", uart_int010);
  uvm_config_db#(virtual uart_ctrl_internal_if10)::set(null, "uvm_test_top.ve10.apb_ss_env10.apb_uart110.*", "vif10", uart_int110);
  uvm_config_db#(virtual apb_if10)::set(null, "uvm_test_top.ve10.apb010*", "vif10", apbi_mo10);
  uvm_config_db#(virtual ahb_if10)::set(null, "uvm_test_top.ve10.ahb010*", "vif10", ahbi_m010);
  uvm_config_db#(virtual spi_if10)::set(null, "uvm_test_top.ve10.spi010*", "spi_if10", spi_s010);
  uvm_config_db#(virtual gpio_if10)::set(null, "uvm_test_top.ve10.gpio010*", "gpio_if10", gpio_s010);
  run_test();
end

endmodule
