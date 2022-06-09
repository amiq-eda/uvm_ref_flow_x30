/*-------------------------------------------------------------------------
File17 name   : apb_subsystem_top17.v 
Title17       : Top17 level file for the testbench 
Project17     : APB17 Subsystem17
Created17     : March17 2008
Description17 : This17 is top level file which instantiate17 the dut17 apb_subsyste17,.v.
              It also has the assertion17 module which checks17 for the power17 down 
              and power17 up.To17 activate17 the assertion17 ifdef LP_ABV_ON17 is used.       
Notes17       :
-------------------------------------------------------------------------*/ 
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------

 `timescale 1ns/10ps


// Environment17 Constants17
`ifndef AHB_DATA_WIDTH17
  `define AHB_DATA_WIDTH17          32              // AHB17 bus data width [32/64]
`endif
`ifndef AHB_ADDR_WIDTH17
  `define AHB_ADDR_WIDTH17          32              // AHB17 bus address width [32/64]
`endif
`ifndef AHB_DATA_MAX_BIT17
  `define AHB_DATA_MAX_BIT17        31              // MUST17 BE17: AHB_DATA_WIDTH17 - 1
`endif
`ifndef AHB_ADDRESS_MAX_BIT17
  `define AHB_ADDRESS_MAX_BIT17     31              // MUST17 BE17: AHB_ADDR_WIDTH17 - 1
`endif
`ifndef DEFAULT_HREADY_VALUE17
  `define DEFAULT_HREADY_VALUE17    1'b1            // Ready17 Asserted17
`endif

`include "ahb_if17.sv"
`include "apb_if17.sv"
`include "apb_master_if17.sv"
`include "apb_slave_if17.sv"
`include "uart_if17.sv"
`include "spi_if17.sv"
`include "gpio_if17.sv"
`include "coverage17/uart_ctrl_internal_if17.sv"

module apb_subsystem_top17;
  import uvm_pkg::*;
  // Import17 the UVM Utilities17 Package17

  import ahb_pkg17::*;
  import apb_pkg17::*;
  import uart_pkg17::*;
  import gpio_pkg17::*;
  import spi_pkg17::*;
  import uart_ctrl_pkg17::*;
  import apb_subsystem_pkg17::*;

  `include "spi_reg_model17.sv"
  `include "gpio_reg_model17.sv"
  `include "apb_subsystem_reg_rdb17.sv"
  `include "uart_ctrl_reg_seq_lib17.sv"
  `include "spi_reg_seq_lib17.sv"
  `include "gpio_reg_seq_lib17.sv"

  //Include17 module UVC17 sequences
  `include "ahb_user_monitor17.sv"
  `include "apb_subsystem_seq_lib17.sv"
  `include "apb_subsystem_vir_sequencer17.sv"
  `include "apb_subsystem_vir_seq_lib17.sv"

  `include "apb_subsystem_tb17.sv"
  `include "test_lib17.sv"
   
  
   // ====================================
   // SHARED17 signals17
   // ====================================
   
   // clock17
   reg tb_hclk17;
   
   // reset
   reg hresetn17;
   
   // post17-mux17 from master17 mux17
   wire [`AHB_DATA_MAX_BIT17:0] hwdata17;
   wire [`AHB_ADDRESS_MAX_BIT17:0] haddr17;
   wire [1:0]  htrans17;
   wire [2:0]  hburst17;
   wire [2:0]  hsize17;
   wire [3:0]  hprot17;
   wire hwrite17;

   // post17-mux17 from slave17 mux17
   wire        hready17;
   wire [1:0]  hresp17;
   wire [`AHB_DATA_MAX_BIT17:0] hrdata17;
  

  //  Specific17 signals17 of apb17 subsystem17
  reg         ua_rxd17;
  reg         ua_ncts17;


  // uart17 outputs17 
  wire        ua_txd17;
  wire        us_nrts17;

  wire   [7:0] n_ss_out17;    // peripheral17 select17 lines17 from master17
  wire   [31:0] hwdata_byte_alligned17;

  reg [2:0] div8_clk17;
 always @(posedge tb_hclk17) begin
   if (!hresetn17)
     div8_clk17 = 3'b000;
   else
     div8_clk17 = div8_clk17 + 1;
 end


  // Master17 virtual interface
  ahb_if17 ahbi_m017(.ahb_clock17(tb_hclk17), .ahb_resetn17(hresetn17));
  
  uart_if17 uart_s017(.clock17(div8_clk17[2]), .reset(hresetn17));
  uart_if17 uart_s117(.clock17(div8_clk17[2]), .reset(hresetn17));
  spi_if17 spi_s017();
  gpio_if17 gpio_s017();
  uart_ctrl_internal_if17 uart_int017(.clock17(div8_clk17[2]));
  uart_ctrl_internal_if17 uart_int117(.clock17(div8_clk17[2]));

  apb_if17 apbi_mo17(.pclock17(tb_hclk17), .preset17(hresetn17));

  //M017
  assign ahbi_m017.AHB_HCLK17 = tb_hclk17;
  assign ahbi_m017.AHB_HRESET17 = hresetn17;
  assign ahbi_m017.AHB_HRESP17 = hresp17;
  assign ahbi_m017.AHB_HRDATA17 = hrdata17;
  assign ahbi_m017.AHB_HREADY17 = hready17;

  assign apbi_mo17.paddr17 = i_apb_subsystem17.i_ahb2apb17.paddr17;
  assign apbi_mo17.prwd17 = i_apb_subsystem17.i_ahb2apb17.pwrite17;
  assign apbi_mo17.pwdata17 = i_apb_subsystem17.i_ahb2apb17.pwdata17;
  assign apbi_mo17.penable17 = i_apb_subsystem17.i_ahb2apb17.penable17;
  assign apbi_mo17.psel17 = {12'b0, i_apb_subsystem17.i_ahb2apb17.psel817, i_apb_subsystem17.i_ahb2apb17.psel217, i_apb_subsystem17.i_ahb2apb17.psel117, i_apb_subsystem17.i_ahb2apb17.psel017};
  assign apbi_mo17.prdata17 = i_apb_subsystem17.i_ahb2apb17.psel017? i_apb_subsystem17.i_ahb2apb17.prdata017 : (i_apb_subsystem17.i_ahb2apb17.psel117? i_apb_subsystem17.i_ahb2apb17.prdata117 : (i_apb_subsystem17.i_ahb2apb17.psel217? i_apb_subsystem17.i_ahb2apb17.prdata217 : i_apb_subsystem17.i_ahb2apb17.prdata817));

  assign spi_s017.sig_n_ss_in17 = n_ss_out17[0];
  assign spi_s017.sig_n_p_reset17 = hresetn17;
  assign spi_s017.sig_pclk17 = tb_hclk17;

  assign gpio_s017.n_p_reset17 = hresetn17;
  assign gpio_s017.pclk17 = tb_hclk17;

  assign hwdata_byte_alligned17 = (ahbi_m017.AHB_HADDR17[1:0] == 2'b00) ? ahbi_m017.AHB_HWDATA17 : {4{ahbi_m017.AHB_HWDATA17[7:0]}};

  apb_subsystem_017 i_apb_subsystem17 (
    // Inputs17
    // system signals17
    .hclk17              (tb_hclk17),     // AHB17 Clock17
    .n_hreset17          (hresetn17),     // AHB17 reset - Active17 low17
    .pclk17              (tb_hclk17),     // APB17 Clock17
    .n_preset17          (hresetn17),     // APB17 reset - Active17 low17
    
    // AHB17 interface for AHB2APM17 bridge17
    .hsel17     (1'b1),        // AHB2APB17 select17
    .haddr17             (ahbi_m017.AHB_HADDR17),        // Address bus
    .htrans17            (ahbi_m017.AHB_HTRANS17),       // Transfer17 type
    .hsize17             (ahbi_m017.AHB_HSIZE17),        // AHB17 Access type - byte half17-word17 word17
    .hwrite17            (ahbi_m017.AHB_HWRITE17),       // Write signal17
    .hwdata17            (hwdata_byte_alligned17),       // Write data
    .hready_in17         (hready17),       // Indicates17 that the last master17 has finished17 
                                       // its bus access
    .hburst17            (ahbi_m017.AHB_HBURST17),       // Burst type
    .hprot17             (ahbi_m017.AHB_HPROT17),        // Protection17 control17
    .hmaster17           (4'h0),      // Master17 select17
    .hmastlock17         (ahbi_m017.AHB_HLOCK17),  // Locked17 transfer17
    // AHB17 interface for SMC17
    .smc_hclk17          (1'b0),
    .smc_n_hclk17        (1'b1),
    .smc_haddr17         (32'd0),
    .smc_htrans17        (2'b00),
    .smc_hsel17          (1'b0),
    .smc_hwrite17        (1'b0),
    .smc_hsize17         (3'd0),
    .smc_hwdata17        (32'd0),
    .smc_hready_in17     (1'b1),
    .smc_hburst17        (3'b000),
    .smc_hprot17         (4'b0000),
    .smc_hmaster17       (4'b0000),
    .smc_hmastlock17     (1'b0),

    //interrupt17 from DMA17
    .DMA_irq17           (1'b0),      

    // Scan17 inputs17
    .scan_en17           (1'b0),         // Scan17 enable pin17
    .scan_in_117         (1'b0),         // Scan17 input for first chain17
    .scan_in_217         (1'b0),        // Scan17 input for second chain17
    .scan_mode17         (1'b0),
    //input for smc17
    .data_smc17          (32'd0),
    //inputs17 for uart17
    .ua_rxd17            (uart_s017.txd17),
    .ua_rxd117           (uart_s117.txd17),
    .ua_ncts17           (uart_s017.cts_n17),
    .ua_ncts117          (uart_s117.cts_n17),
    //inputs17 for spi17
    .n_ss_in17           (1'b1),
    .mi17                (spi_s017.sig_so17),
    .si17                (1'b0),
    .sclk_in17           (1'b0),
    //inputs17 for GPIO17
    .gpio_pin_in17       (gpio_s017.gpio_pin_in17[15:0]),
 
//interrupt17 from Enet17 MAC17
     .macb0_int17     (1'b0),
     .macb1_int17     (1'b0),
     .macb2_int17     (1'b0),
     .macb3_int17     (1'b0),

    // Scan17 outputs17
    .scan_out_117        (),             // Scan17 out for chain17 1
    .scan_out_217        (),             // Scan17 out for chain17 2
   
    //output from APB17 
    // AHB17 interface for AHB2APB17 bridge17
    .hrdata17            (hrdata17),       // Read data provided from target slave17
    .hready17            (hready17),       // Ready17 for new bus cycle from target slave17
    .hresp17             (hresp17),        // Response17 from the bridge17

    // AHB17 interface for SMC17
    .smc_hrdata17        (), 
    .smc_hready17        (),
    .smc_hresp17         (),
  
    //outputs17 from smc17
    .smc_n_ext_oe17      (),
    .smc_data17          (),
    .smc_addr17          (),
    .smc_n_be17          (),
    .smc_n_cs17          (), 
    .smc_n_we17          (),
    .smc_n_wr17          (),
    .smc_n_rd17          (),
    //outputs17 from uart17
    .ua_txd17             (uart_s017.rxd17),
    .ua_txd117            (uart_s117.rxd17),
    .ua_nrts17            (uart_s017.rts_n17),
    .ua_nrts117           (uart_s117.rts_n17),
    // outputs17 from ttc17
    .so                (),
    .mo17                (spi_s017.sig_si17),
    .sclk_out17          (spi_s017.sig_sclk_in17),
    .n_ss_out17          (n_ss_out17[7:0]),
    .n_so_en17           (),
    .n_mo_en17           (),
    .n_sclk_en17         (),
    .n_ss_en17           (),
    //outputs17 from gpio17
    .n_gpio_pin_oe17     (gpio_s017.n_gpio_pin_oe17[15:0]),
    .gpio_pin_out17      (gpio_s017.gpio_pin_out17[15:0]),

//unconnected17 o/p ports17
    .clk_SRPG_macb0_en17(),
    .clk_SRPG_macb1_en17(),
    .clk_SRPG_macb2_en17(),
    .clk_SRPG_macb3_en17(),
    .core06v17(),
    .core08v17(),
    .core10v17(),
    .core12v17(),
    .mte_smc_start17(),
    .mte_uart_start17(),
    .mte_smc_uart_start17(),
    .mte_pm_smc_to_default_start17(),
    .mte_pm_uart_to_default_start17(),
    .mte_pm_smc_uart_to_default_start17(),
    .pcm_irq17(),
    .ttc_irq17(),
    .gpio_irq17(),
    .uart0_irq17(),
    .uart1_irq17(),
    .spi_irq17(),

    .macb3_wakeup17(),
    .macb2_wakeup17(),
    .macb1_wakeup17(),
    .macb0_wakeup17()
);


initial
begin
  tb_hclk17 = 0;
  hresetn17 = 1;

  #1 hresetn17 = 0;
  #1200 hresetn17 = 1;
end

always #50 tb_hclk17 = ~tb_hclk17;

initial begin
  uvm_config_db#(virtual uart_if17)::set(null, "uvm_test_top.ve17.uart017*", "vif17", uart_s017);
  uvm_config_db#(virtual uart_if17)::set(null, "uvm_test_top.ve17.uart117*", "vif17", uart_s117);
  uvm_config_db#(virtual uart_ctrl_internal_if17)::set(null, "uvm_test_top.ve17.apb_ss_env17.apb_uart017.*", "vif17", uart_int017);
  uvm_config_db#(virtual uart_ctrl_internal_if17)::set(null, "uvm_test_top.ve17.apb_ss_env17.apb_uart117.*", "vif17", uart_int117);
  uvm_config_db#(virtual apb_if17)::set(null, "uvm_test_top.ve17.apb017*", "vif17", apbi_mo17);
  uvm_config_db#(virtual ahb_if17)::set(null, "uvm_test_top.ve17.ahb017*", "vif17", ahbi_m017);
  uvm_config_db#(virtual spi_if17)::set(null, "uvm_test_top.ve17.spi017*", "spi_if17", spi_s017);
  uvm_config_db#(virtual gpio_if17)::set(null, "uvm_test_top.ve17.gpio017*", "gpio_if17", gpio_s017);
  run_test();
end

endmodule
