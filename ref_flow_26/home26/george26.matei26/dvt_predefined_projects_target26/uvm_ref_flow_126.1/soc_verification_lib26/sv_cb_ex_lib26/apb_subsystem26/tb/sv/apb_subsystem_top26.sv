/*-------------------------------------------------------------------------
File26 name   : apb_subsystem_top26.v 
Title26       : Top26 level file for the testbench 
Project26     : APB26 Subsystem26
Created26     : March26 2008
Description26 : This26 is top level file which instantiate26 the dut26 apb_subsyste26,.v.
              It also has the assertion26 module which checks26 for the power26 down 
              and power26 up.To26 activate26 the assertion26 ifdef LP_ABV_ON26 is used.       
Notes26       :
-------------------------------------------------------------------------*/ 
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------

 `timescale 1ns/10ps


// Environment26 Constants26
`ifndef AHB_DATA_WIDTH26
  `define AHB_DATA_WIDTH26          32              // AHB26 bus data width [32/64]
`endif
`ifndef AHB_ADDR_WIDTH26
  `define AHB_ADDR_WIDTH26          32              // AHB26 bus address width [32/64]
`endif
`ifndef AHB_DATA_MAX_BIT26
  `define AHB_DATA_MAX_BIT26        31              // MUST26 BE26: AHB_DATA_WIDTH26 - 1
`endif
`ifndef AHB_ADDRESS_MAX_BIT26
  `define AHB_ADDRESS_MAX_BIT26     31              // MUST26 BE26: AHB_ADDR_WIDTH26 - 1
`endif
`ifndef DEFAULT_HREADY_VALUE26
  `define DEFAULT_HREADY_VALUE26    1'b1            // Ready26 Asserted26
`endif

`include "ahb_if26.sv"
`include "apb_if26.sv"
`include "apb_master_if26.sv"
`include "apb_slave_if26.sv"
`include "uart_if26.sv"
`include "spi_if26.sv"
`include "gpio_if26.sv"
`include "coverage26/uart_ctrl_internal_if26.sv"

module apb_subsystem_top26;
  import uvm_pkg::*;
  // Import26 the UVM Utilities26 Package26

  import ahb_pkg26::*;
  import apb_pkg26::*;
  import uart_pkg26::*;
  import gpio_pkg26::*;
  import spi_pkg26::*;
  import uart_ctrl_pkg26::*;
  import apb_subsystem_pkg26::*;

  `include "spi_reg_model26.sv"
  `include "gpio_reg_model26.sv"
  `include "apb_subsystem_reg_rdb26.sv"
  `include "uart_ctrl_reg_seq_lib26.sv"
  `include "spi_reg_seq_lib26.sv"
  `include "gpio_reg_seq_lib26.sv"

  //Include26 module UVC26 sequences
  `include "ahb_user_monitor26.sv"
  `include "apb_subsystem_seq_lib26.sv"
  `include "apb_subsystem_vir_sequencer26.sv"
  `include "apb_subsystem_vir_seq_lib26.sv"

  `include "apb_subsystem_tb26.sv"
  `include "test_lib26.sv"
   
  
   // ====================================
   // SHARED26 signals26
   // ====================================
   
   // clock26
   reg tb_hclk26;
   
   // reset
   reg hresetn26;
   
   // post26-mux26 from master26 mux26
   wire [`AHB_DATA_MAX_BIT26:0] hwdata26;
   wire [`AHB_ADDRESS_MAX_BIT26:0] haddr26;
   wire [1:0]  htrans26;
   wire [2:0]  hburst26;
   wire [2:0]  hsize26;
   wire [3:0]  hprot26;
   wire hwrite26;

   // post26-mux26 from slave26 mux26
   wire        hready26;
   wire [1:0]  hresp26;
   wire [`AHB_DATA_MAX_BIT26:0] hrdata26;
  

  //  Specific26 signals26 of apb26 subsystem26
  reg         ua_rxd26;
  reg         ua_ncts26;


  // uart26 outputs26 
  wire        ua_txd26;
  wire        us_nrts26;

  wire   [7:0] n_ss_out26;    // peripheral26 select26 lines26 from master26
  wire   [31:0] hwdata_byte_alligned26;

  reg [2:0] div8_clk26;
 always @(posedge tb_hclk26) begin
   if (!hresetn26)
     div8_clk26 = 3'b000;
   else
     div8_clk26 = div8_clk26 + 1;
 end


  // Master26 virtual interface
  ahb_if26 ahbi_m026(.ahb_clock26(tb_hclk26), .ahb_resetn26(hresetn26));
  
  uart_if26 uart_s026(.clock26(div8_clk26[2]), .reset(hresetn26));
  uart_if26 uart_s126(.clock26(div8_clk26[2]), .reset(hresetn26));
  spi_if26 spi_s026();
  gpio_if26 gpio_s026();
  uart_ctrl_internal_if26 uart_int026(.clock26(div8_clk26[2]));
  uart_ctrl_internal_if26 uart_int126(.clock26(div8_clk26[2]));

  apb_if26 apbi_mo26(.pclock26(tb_hclk26), .preset26(hresetn26));

  //M026
  assign ahbi_m026.AHB_HCLK26 = tb_hclk26;
  assign ahbi_m026.AHB_HRESET26 = hresetn26;
  assign ahbi_m026.AHB_HRESP26 = hresp26;
  assign ahbi_m026.AHB_HRDATA26 = hrdata26;
  assign ahbi_m026.AHB_HREADY26 = hready26;

  assign apbi_mo26.paddr26 = i_apb_subsystem26.i_ahb2apb26.paddr26;
  assign apbi_mo26.prwd26 = i_apb_subsystem26.i_ahb2apb26.pwrite26;
  assign apbi_mo26.pwdata26 = i_apb_subsystem26.i_ahb2apb26.pwdata26;
  assign apbi_mo26.penable26 = i_apb_subsystem26.i_ahb2apb26.penable26;
  assign apbi_mo26.psel26 = {12'b0, i_apb_subsystem26.i_ahb2apb26.psel826, i_apb_subsystem26.i_ahb2apb26.psel226, i_apb_subsystem26.i_ahb2apb26.psel126, i_apb_subsystem26.i_ahb2apb26.psel026};
  assign apbi_mo26.prdata26 = i_apb_subsystem26.i_ahb2apb26.psel026? i_apb_subsystem26.i_ahb2apb26.prdata026 : (i_apb_subsystem26.i_ahb2apb26.psel126? i_apb_subsystem26.i_ahb2apb26.prdata126 : (i_apb_subsystem26.i_ahb2apb26.psel226? i_apb_subsystem26.i_ahb2apb26.prdata226 : i_apb_subsystem26.i_ahb2apb26.prdata826));

  assign spi_s026.sig_n_ss_in26 = n_ss_out26[0];
  assign spi_s026.sig_n_p_reset26 = hresetn26;
  assign spi_s026.sig_pclk26 = tb_hclk26;

  assign gpio_s026.n_p_reset26 = hresetn26;
  assign gpio_s026.pclk26 = tb_hclk26;

  assign hwdata_byte_alligned26 = (ahbi_m026.AHB_HADDR26[1:0] == 2'b00) ? ahbi_m026.AHB_HWDATA26 : {4{ahbi_m026.AHB_HWDATA26[7:0]}};

  apb_subsystem_026 i_apb_subsystem26 (
    // Inputs26
    // system signals26
    .hclk26              (tb_hclk26),     // AHB26 Clock26
    .n_hreset26          (hresetn26),     // AHB26 reset - Active26 low26
    .pclk26              (tb_hclk26),     // APB26 Clock26
    .n_preset26          (hresetn26),     // APB26 reset - Active26 low26
    
    // AHB26 interface for AHB2APM26 bridge26
    .hsel26     (1'b1),        // AHB2APB26 select26
    .haddr26             (ahbi_m026.AHB_HADDR26),        // Address bus
    .htrans26            (ahbi_m026.AHB_HTRANS26),       // Transfer26 type
    .hsize26             (ahbi_m026.AHB_HSIZE26),        // AHB26 Access type - byte half26-word26 word26
    .hwrite26            (ahbi_m026.AHB_HWRITE26),       // Write signal26
    .hwdata26            (hwdata_byte_alligned26),       // Write data
    .hready_in26         (hready26),       // Indicates26 that the last master26 has finished26 
                                       // its bus access
    .hburst26            (ahbi_m026.AHB_HBURST26),       // Burst type
    .hprot26             (ahbi_m026.AHB_HPROT26),        // Protection26 control26
    .hmaster26           (4'h0),      // Master26 select26
    .hmastlock26         (ahbi_m026.AHB_HLOCK26),  // Locked26 transfer26
    // AHB26 interface for SMC26
    .smc_hclk26          (1'b0),
    .smc_n_hclk26        (1'b1),
    .smc_haddr26         (32'd0),
    .smc_htrans26        (2'b00),
    .smc_hsel26          (1'b0),
    .smc_hwrite26        (1'b0),
    .smc_hsize26         (3'd0),
    .smc_hwdata26        (32'd0),
    .smc_hready_in26     (1'b1),
    .smc_hburst26        (3'b000),
    .smc_hprot26         (4'b0000),
    .smc_hmaster26       (4'b0000),
    .smc_hmastlock26     (1'b0),

    //interrupt26 from DMA26
    .DMA_irq26           (1'b0),      

    // Scan26 inputs26
    .scan_en26           (1'b0),         // Scan26 enable pin26
    .scan_in_126         (1'b0),         // Scan26 input for first chain26
    .scan_in_226         (1'b0),        // Scan26 input for second chain26
    .scan_mode26         (1'b0),
    //input for smc26
    .data_smc26          (32'd0),
    //inputs26 for uart26
    .ua_rxd26            (uart_s026.txd26),
    .ua_rxd126           (uart_s126.txd26),
    .ua_ncts26           (uart_s026.cts_n26),
    .ua_ncts126          (uart_s126.cts_n26),
    //inputs26 for spi26
    .n_ss_in26           (1'b1),
    .mi26                (spi_s026.sig_so26),
    .si26                (1'b0),
    .sclk_in26           (1'b0),
    //inputs26 for GPIO26
    .gpio_pin_in26       (gpio_s026.gpio_pin_in26[15:0]),
 
//interrupt26 from Enet26 MAC26
     .macb0_int26     (1'b0),
     .macb1_int26     (1'b0),
     .macb2_int26     (1'b0),
     .macb3_int26     (1'b0),

    // Scan26 outputs26
    .scan_out_126        (),             // Scan26 out for chain26 1
    .scan_out_226        (),             // Scan26 out for chain26 2
   
    //output from APB26 
    // AHB26 interface for AHB2APB26 bridge26
    .hrdata26            (hrdata26),       // Read data provided from target slave26
    .hready26            (hready26),       // Ready26 for new bus cycle from target slave26
    .hresp26             (hresp26),        // Response26 from the bridge26

    // AHB26 interface for SMC26
    .smc_hrdata26        (), 
    .smc_hready26        (),
    .smc_hresp26         (),
  
    //outputs26 from smc26
    .smc_n_ext_oe26      (),
    .smc_data26          (),
    .smc_addr26          (),
    .smc_n_be26          (),
    .smc_n_cs26          (), 
    .smc_n_we26          (),
    .smc_n_wr26          (),
    .smc_n_rd26          (),
    //outputs26 from uart26
    .ua_txd26             (uart_s026.rxd26),
    .ua_txd126            (uart_s126.rxd26),
    .ua_nrts26            (uart_s026.rts_n26),
    .ua_nrts126           (uart_s126.rts_n26),
    // outputs26 from ttc26
    .so                (),
    .mo26                (spi_s026.sig_si26),
    .sclk_out26          (spi_s026.sig_sclk_in26),
    .n_ss_out26          (n_ss_out26[7:0]),
    .n_so_en26           (),
    .n_mo_en26           (),
    .n_sclk_en26         (),
    .n_ss_en26           (),
    //outputs26 from gpio26
    .n_gpio_pin_oe26     (gpio_s026.n_gpio_pin_oe26[15:0]),
    .gpio_pin_out26      (gpio_s026.gpio_pin_out26[15:0]),

//unconnected26 o/p ports26
    .clk_SRPG_macb0_en26(),
    .clk_SRPG_macb1_en26(),
    .clk_SRPG_macb2_en26(),
    .clk_SRPG_macb3_en26(),
    .core06v26(),
    .core08v26(),
    .core10v26(),
    .core12v26(),
    .mte_smc_start26(),
    .mte_uart_start26(),
    .mte_smc_uart_start26(),
    .mte_pm_smc_to_default_start26(),
    .mte_pm_uart_to_default_start26(),
    .mte_pm_smc_uart_to_default_start26(),
    .pcm_irq26(),
    .ttc_irq26(),
    .gpio_irq26(),
    .uart0_irq26(),
    .uart1_irq26(),
    .spi_irq26(),

    .macb3_wakeup26(),
    .macb2_wakeup26(),
    .macb1_wakeup26(),
    .macb0_wakeup26()
);


initial
begin
  tb_hclk26 = 0;
  hresetn26 = 1;

  #1 hresetn26 = 0;
  #1200 hresetn26 = 1;
end

always #50 tb_hclk26 = ~tb_hclk26;

initial begin
  uvm_config_db#(virtual uart_if26)::set(null, "uvm_test_top.ve26.uart026*", "vif26", uart_s026);
  uvm_config_db#(virtual uart_if26)::set(null, "uvm_test_top.ve26.uart126*", "vif26", uart_s126);
  uvm_config_db#(virtual uart_ctrl_internal_if26)::set(null, "uvm_test_top.ve26.apb_ss_env26.apb_uart026.*", "vif26", uart_int026);
  uvm_config_db#(virtual uart_ctrl_internal_if26)::set(null, "uvm_test_top.ve26.apb_ss_env26.apb_uart126.*", "vif26", uart_int126);
  uvm_config_db#(virtual apb_if26)::set(null, "uvm_test_top.ve26.apb026*", "vif26", apbi_mo26);
  uvm_config_db#(virtual ahb_if26)::set(null, "uvm_test_top.ve26.ahb026*", "vif26", ahbi_m026);
  uvm_config_db#(virtual spi_if26)::set(null, "uvm_test_top.ve26.spi026*", "spi_if26", spi_s026);
  uvm_config_db#(virtual gpio_if26)::set(null, "uvm_test_top.ve26.gpio026*", "gpio_if26", gpio_s026);
  run_test();
end

endmodule
