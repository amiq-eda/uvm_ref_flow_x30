/*-------------------------------------------------------------------------
File20 name   : apb_subsystem_top20.v 
Title20       : Top20 level file for the testbench 
Project20     : APB20 Subsystem20
Created20     : March20 2008
Description20 : This20 is top level file which instantiate20 the dut20 apb_subsyste20,.v.
              It also has the assertion20 module which checks20 for the power20 down 
              and power20 up.To20 activate20 the assertion20 ifdef LP_ABV_ON20 is used.       
Notes20       :
-------------------------------------------------------------------------*/ 
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------

 `timescale 1ns/10ps


// Environment20 Constants20
`ifndef AHB_DATA_WIDTH20
  `define AHB_DATA_WIDTH20          32              // AHB20 bus data width [32/64]
`endif
`ifndef AHB_ADDR_WIDTH20
  `define AHB_ADDR_WIDTH20          32              // AHB20 bus address width [32/64]
`endif
`ifndef AHB_DATA_MAX_BIT20
  `define AHB_DATA_MAX_BIT20        31              // MUST20 BE20: AHB_DATA_WIDTH20 - 1
`endif
`ifndef AHB_ADDRESS_MAX_BIT20
  `define AHB_ADDRESS_MAX_BIT20     31              // MUST20 BE20: AHB_ADDR_WIDTH20 - 1
`endif
`ifndef DEFAULT_HREADY_VALUE20
  `define DEFAULT_HREADY_VALUE20    1'b1            // Ready20 Asserted20
`endif

`include "ahb_if20.sv"
`include "apb_if20.sv"
`include "apb_master_if20.sv"
`include "apb_slave_if20.sv"
`include "uart_if20.sv"
`include "spi_if20.sv"
`include "gpio_if20.sv"
`include "coverage20/uart_ctrl_internal_if20.sv"

module apb_subsystem_top20;
  import uvm_pkg::*;
  // Import20 the UVM Utilities20 Package20

  import ahb_pkg20::*;
  import apb_pkg20::*;
  import uart_pkg20::*;
  import gpio_pkg20::*;
  import spi_pkg20::*;
  import uart_ctrl_pkg20::*;
  import apb_subsystem_pkg20::*;

  `include "spi_reg_model20.sv"
  `include "gpio_reg_model20.sv"
  `include "apb_subsystem_reg_rdb20.sv"
  `include "uart_ctrl_reg_seq_lib20.sv"
  `include "spi_reg_seq_lib20.sv"
  `include "gpio_reg_seq_lib20.sv"

  //Include20 module UVC20 sequences
  `include "ahb_user_monitor20.sv"
  `include "apb_subsystem_seq_lib20.sv"
  `include "apb_subsystem_vir_sequencer20.sv"
  `include "apb_subsystem_vir_seq_lib20.sv"

  `include "apb_subsystem_tb20.sv"
  `include "test_lib20.sv"
   
  
   // ====================================
   // SHARED20 signals20
   // ====================================
   
   // clock20
   reg tb_hclk20;
   
   // reset
   reg hresetn20;
   
   // post20-mux20 from master20 mux20
   wire [`AHB_DATA_MAX_BIT20:0] hwdata20;
   wire [`AHB_ADDRESS_MAX_BIT20:0] haddr20;
   wire [1:0]  htrans20;
   wire [2:0]  hburst20;
   wire [2:0]  hsize20;
   wire [3:0]  hprot20;
   wire hwrite20;

   // post20-mux20 from slave20 mux20
   wire        hready20;
   wire [1:0]  hresp20;
   wire [`AHB_DATA_MAX_BIT20:0] hrdata20;
  

  //  Specific20 signals20 of apb20 subsystem20
  reg         ua_rxd20;
  reg         ua_ncts20;


  // uart20 outputs20 
  wire        ua_txd20;
  wire        us_nrts20;

  wire   [7:0] n_ss_out20;    // peripheral20 select20 lines20 from master20
  wire   [31:0] hwdata_byte_alligned20;

  reg [2:0] div8_clk20;
 always @(posedge tb_hclk20) begin
   if (!hresetn20)
     div8_clk20 = 3'b000;
   else
     div8_clk20 = div8_clk20 + 1;
 end


  // Master20 virtual interface
  ahb_if20 ahbi_m020(.ahb_clock20(tb_hclk20), .ahb_resetn20(hresetn20));
  
  uart_if20 uart_s020(.clock20(div8_clk20[2]), .reset(hresetn20));
  uart_if20 uart_s120(.clock20(div8_clk20[2]), .reset(hresetn20));
  spi_if20 spi_s020();
  gpio_if20 gpio_s020();
  uart_ctrl_internal_if20 uart_int020(.clock20(div8_clk20[2]));
  uart_ctrl_internal_if20 uart_int120(.clock20(div8_clk20[2]));

  apb_if20 apbi_mo20(.pclock20(tb_hclk20), .preset20(hresetn20));

  //M020
  assign ahbi_m020.AHB_HCLK20 = tb_hclk20;
  assign ahbi_m020.AHB_HRESET20 = hresetn20;
  assign ahbi_m020.AHB_HRESP20 = hresp20;
  assign ahbi_m020.AHB_HRDATA20 = hrdata20;
  assign ahbi_m020.AHB_HREADY20 = hready20;

  assign apbi_mo20.paddr20 = i_apb_subsystem20.i_ahb2apb20.paddr20;
  assign apbi_mo20.prwd20 = i_apb_subsystem20.i_ahb2apb20.pwrite20;
  assign apbi_mo20.pwdata20 = i_apb_subsystem20.i_ahb2apb20.pwdata20;
  assign apbi_mo20.penable20 = i_apb_subsystem20.i_ahb2apb20.penable20;
  assign apbi_mo20.psel20 = {12'b0, i_apb_subsystem20.i_ahb2apb20.psel820, i_apb_subsystem20.i_ahb2apb20.psel220, i_apb_subsystem20.i_ahb2apb20.psel120, i_apb_subsystem20.i_ahb2apb20.psel020};
  assign apbi_mo20.prdata20 = i_apb_subsystem20.i_ahb2apb20.psel020? i_apb_subsystem20.i_ahb2apb20.prdata020 : (i_apb_subsystem20.i_ahb2apb20.psel120? i_apb_subsystem20.i_ahb2apb20.prdata120 : (i_apb_subsystem20.i_ahb2apb20.psel220? i_apb_subsystem20.i_ahb2apb20.prdata220 : i_apb_subsystem20.i_ahb2apb20.prdata820));

  assign spi_s020.sig_n_ss_in20 = n_ss_out20[0];
  assign spi_s020.sig_n_p_reset20 = hresetn20;
  assign spi_s020.sig_pclk20 = tb_hclk20;

  assign gpio_s020.n_p_reset20 = hresetn20;
  assign gpio_s020.pclk20 = tb_hclk20;

  assign hwdata_byte_alligned20 = (ahbi_m020.AHB_HADDR20[1:0] == 2'b00) ? ahbi_m020.AHB_HWDATA20 : {4{ahbi_m020.AHB_HWDATA20[7:0]}};

  apb_subsystem_020 i_apb_subsystem20 (
    // Inputs20
    // system signals20
    .hclk20              (tb_hclk20),     // AHB20 Clock20
    .n_hreset20          (hresetn20),     // AHB20 reset - Active20 low20
    .pclk20              (tb_hclk20),     // APB20 Clock20
    .n_preset20          (hresetn20),     // APB20 reset - Active20 low20
    
    // AHB20 interface for AHB2APM20 bridge20
    .hsel20     (1'b1),        // AHB2APB20 select20
    .haddr20             (ahbi_m020.AHB_HADDR20),        // Address bus
    .htrans20            (ahbi_m020.AHB_HTRANS20),       // Transfer20 type
    .hsize20             (ahbi_m020.AHB_HSIZE20),        // AHB20 Access type - byte half20-word20 word20
    .hwrite20            (ahbi_m020.AHB_HWRITE20),       // Write signal20
    .hwdata20            (hwdata_byte_alligned20),       // Write data
    .hready_in20         (hready20),       // Indicates20 that the last master20 has finished20 
                                       // its bus access
    .hburst20            (ahbi_m020.AHB_HBURST20),       // Burst type
    .hprot20             (ahbi_m020.AHB_HPROT20),        // Protection20 control20
    .hmaster20           (4'h0),      // Master20 select20
    .hmastlock20         (ahbi_m020.AHB_HLOCK20),  // Locked20 transfer20
    // AHB20 interface for SMC20
    .smc_hclk20          (1'b0),
    .smc_n_hclk20        (1'b1),
    .smc_haddr20         (32'd0),
    .smc_htrans20        (2'b00),
    .smc_hsel20          (1'b0),
    .smc_hwrite20        (1'b0),
    .smc_hsize20         (3'd0),
    .smc_hwdata20        (32'd0),
    .smc_hready_in20     (1'b1),
    .smc_hburst20        (3'b000),
    .smc_hprot20         (4'b0000),
    .smc_hmaster20       (4'b0000),
    .smc_hmastlock20     (1'b0),

    //interrupt20 from DMA20
    .DMA_irq20           (1'b0),      

    // Scan20 inputs20
    .scan_en20           (1'b0),         // Scan20 enable pin20
    .scan_in_120         (1'b0),         // Scan20 input for first chain20
    .scan_in_220         (1'b0),        // Scan20 input for second chain20
    .scan_mode20         (1'b0),
    //input for smc20
    .data_smc20          (32'd0),
    //inputs20 for uart20
    .ua_rxd20            (uart_s020.txd20),
    .ua_rxd120           (uart_s120.txd20),
    .ua_ncts20           (uart_s020.cts_n20),
    .ua_ncts120          (uart_s120.cts_n20),
    //inputs20 for spi20
    .n_ss_in20           (1'b1),
    .mi20                (spi_s020.sig_so20),
    .si20                (1'b0),
    .sclk_in20           (1'b0),
    //inputs20 for GPIO20
    .gpio_pin_in20       (gpio_s020.gpio_pin_in20[15:0]),
 
//interrupt20 from Enet20 MAC20
     .macb0_int20     (1'b0),
     .macb1_int20     (1'b0),
     .macb2_int20     (1'b0),
     .macb3_int20     (1'b0),

    // Scan20 outputs20
    .scan_out_120        (),             // Scan20 out for chain20 1
    .scan_out_220        (),             // Scan20 out for chain20 2
   
    //output from APB20 
    // AHB20 interface for AHB2APB20 bridge20
    .hrdata20            (hrdata20),       // Read data provided from target slave20
    .hready20            (hready20),       // Ready20 for new bus cycle from target slave20
    .hresp20             (hresp20),        // Response20 from the bridge20

    // AHB20 interface for SMC20
    .smc_hrdata20        (), 
    .smc_hready20        (),
    .smc_hresp20         (),
  
    //outputs20 from smc20
    .smc_n_ext_oe20      (),
    .smc_data20          (),
    .smc_addr20          (),
    .smc_n_be20          (),
    .smc_n_cs20          (), 
    .smc_n_we20          (),
    .smc_n_wr20          (),
    .smc_n_rd20          (),
    //outputs20 from uart20
    .ua_txd20             (uart_s020.rxd20),
    .ua_txd120            (uart_s120.rxd20),
    .ua_nrts20            (uart_s020.rts_n20),
    .ua_nrts120           (uart_s120.rts_n20),
    // outputs20 from ttc20
    .so                (),
    .mo20                (spi_s020.sig_si20),
    .sclk_out20          (spi_s020.sig_sclk_in20),
    .n_ss_out20          (n_ss_out20[7:0]),
    .n_so_en20           (),
    .n_mo_en20           (),
    .n_sclk_en20         (),
    .n_ss_en20           (),
    //outputs20 from gpio20
    .n_gpio_pin_oe20     (gpio_s020.n_gpio_pin_oe20[15:0]),
    .gpio_pin_out20      (gpio_s020.gpio_pin_out20[15:0]),

//unconnected20 o/p ports20
    .clk_SRPG_macb0_en20(),
    .clk_SRPG_macb1_en20(),
    .clk_SRPG_macb2_en20(),
    .clk_SRPG_macb3_en20(),
    .core06v20(),
    .core08v20(),
    .core10v20(),
    .core12v20(),
    .mte_smc_start20(),
    .mte_uart_start20(),
    .mte_smc_uart_start20(),
    .mte_pm_smc_to_default_start20(),
    .mte_pm_uart_to_default_start20(),
    .mte_pm_smc_uart_to_default_start20(),
    .pcm_irq20(),
    .ttc_irq20(),
    .gpio_irq20(),
    .uart0_irq20(),
    .uart1_irq20(),
    .spi_irq20(),

    .macb3_wakeup20(),
    .macb2_wakeup20(),
    .macb1_wakeup20(),
    .macb0_wakeup20()
);


initial
begin
  tb_hclk20 = 0;
  hresetn20 = 1;

  #1 hresetn20 = 0;
  #1200 hresetn20 = 1;
end

always #50 tb_hclk20 = ~tb_hclk20;

initial begin
  uvm_config_db#(virtual uart_if20)::set(null, "uvm_test_top.ve20.uart020*", "vif20", uart_s020);
  uvm_config_db#(virtual uart_if20)::set(null, "uvm_test_top.ve20.uart120*", "vif20", uart_s120);
  uvm_config_db#(virtual uart_ctrl_internal_if20)::set(null, "uvm_test_top.ve20.apb_ss_env20.apb_uart020.*", "vif20", uart_int020);
  uvm_config_db#(virtual uart_ctrl_internal_if20)::set(null, "uvm_test_top.ve20.apb_ss_env20.apb_uart120.*", "vif20", uart_int120);
  uvm_config_db#(virtual apb_if20)::set(null, "uvm_test_top.ve20.apb020*", "vif20", apbi_mo20);
  uvm_config_db#(virtual ahb_if20)::set(null, "uvm_test_top.ve20.ahb020*", "vif20", ahbi_m020);
  uvm_config_db#(virtual spi_if20)::set(null, "uvm_test_top.ve20.spi020*", "spi_if20", spi_s020);
  uvm_config_db#(virtual gpio_if20)::set(null, "uvm_test_top.ve20.gpio020*", "gpio_if20", gpio_s020);
  run_test();
end

endmodule
