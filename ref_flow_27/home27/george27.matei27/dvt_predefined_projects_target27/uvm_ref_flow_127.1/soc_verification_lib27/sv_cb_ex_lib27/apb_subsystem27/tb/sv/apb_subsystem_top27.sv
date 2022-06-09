/*-------------------------------------------------------------------------
File27 name   : apb_subsystem_top27.v 
Title27       : Top27 level file for the testbench 
Project27     : APB27 Subsystem27
Created27     : March27 2008
Description27 : This27 is top level file which instantiate27 the dut27 apb_subsyste27,.v.
              It also has the assertion27 module which checks27 for the power27 down 
              and power27 up.To27 activate27 the assertion27 ifdef LP_ABV_ON27 is used.       
Notes27       :
-------------------------------------------------------------------------*/ 
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------

 `timescale 1ns/10ps


// Environment27 Constants27
`ifndef AHB_DATA_WIDTH27
  `define AHB_DATA_WIDTH27          32              // AHB27 bus data width [32/64]
`endif
`ifndef AHB_ADDR_WIDTH27
  `define AHB_ADDR_WIDTH27          32              // AHB27 bus address width [32/64]
`endif
`ifndef AHB_DATA_MAX_BIT27
  `define AHB_DATA_MAX_BIT27        31              // MUST27 BE27: AHB_DATA_WIDTH27 - 1
`endif
`ifndef AHB_ADDRESS_MAX_BIT27
  `define AHB_ADDRESS_MAX_BIT27     31              // MUST27 BE27: AHB_ADDR_WIDTH27 - 1
`endif
`ifndef DEFAULT_HREADY_VALUE27
  `define DEFAULT_HREADY_VALUE27    1'b1            // Ready27 Asserted27
`endif

`include "ahb_if27.sv"
`include "apb_if27.sv"
`include "apb_master_if27.sv"
`include "apb_slave_if27.sv"
`include "uart_if27.sv"
`include "spi_if27.sv"
`include "gpio_if27.sv"
`include "coverage27/uart_ctrl_internal_if27.sv"

module apb_subsystem_top27;
  import uvm_pkg::*;
  // Import27 the UVM Utilities27 Package27

  import ahb_pkg27::*;
  import apb_pkg27::*;
  import uart_pkg27::*;
  import gpio_pkg27::*;
  import spi_pkg27::*;
  import uart_ctrl_pkg27::*;
  import apb_subsystem_pkg27::*;

  `include "spi_reg_model27.sv"
  `include "gpio_reg_model27.sv"
  `include "apb_subsystem_reg_rdb27.sv"
  `include "uart_ctrl_reg_seq_lib27.sv"
  `include "spi_reg_seq_lib27.sv"
  `include "gpio_reg_seq_lib27.sv"

  //Include27 module UVC27 sequences
  `include "ahb_user_monitor27.sv"
  `include "apb_subsystem_seq_lib27.sv"
  `include "apb_subsystem_vir_sequencer27.sv"
  `include "apb_subsystem_vir_seq_lib27.sv"

  `include "apb_subsystem_tb27.sv"
  `include "test_lib27.sv"
   
  
   // ====================================
   // SHARED27 signals27
   // ====================================
   
   // clock27
   reg tb_hclk27;
   
   // reset
   reg hresetn27;
   
   // post27-mux27 from master27 mux27
   wire [`AHB_DATA_MAX_BIT27:0] hwdata27;
   wire [`AHB_ADDRESS_MAX_BIT27:0] haddr27;
   wire [1:0]  htrans27;
   wire [2:0]  hburst27;
   wire [2:0]  hsize27;
   wire [3:0]  hprot27;
   wire hwrite27;

   // post27-mux27 from slave27 mux27
   wire        hready27;
   wire [1:0]  hresp27;
   wire [`AHB_DATA_MAX_BIT27:0] hrdata27;
  

  //  Specific27 signals27 of apb27 subsystem27
  reg         ua_rxd27;
  reg         ua_ncts27;


  // uart27 outputs27 
  wire        ua_txd27;
  wire        us_nrts27;

  wire   [7:0] n_ss_out27;    // peripheral27 select27 lines27 from master27
  wire   [31:0] hwdata_byte_alligned27;

  reg [2:0] div8_clk27;
 always @(posedge tb_hclk27) begin
   if (!hresetn27)
     div8_clk27 = 3'b000;
   else
     div8_clk27 = div8_clk27 + 1;
 end


  // Master27 virtual interface
  ahb_if27 ahbi_m027(.ahb_clock27(tb_hclk27), .ahb_resetn27(hresetn27));
  
  uart_if27 uart_s027(.clock27(div8_clk27[2]), .reset(hresetn27));
  uart_if27 uart_s127(.clock27(div8_clk27[2]), .reset(hresetn27));
  spi_if27 spi_s027();
  gpio_if27 gpio_s027();
  uart_ctrl_internal_if27 uart_int027(.clock27(div8_clk27[2]));
  uart_ctrl_internal_if27 uart_int127(.clock27(div8_clk27[2]));

  apb_if27 apbi_mo27(.pclock27(tb_hclk27), .preset27(hresetn27));

  //M027
  assign ahbi_m027.AHB_HCLK27 = tb_hclk27;
  assign ahbi_m027.AHB_HRESET27 = hresetn27;
  assign ahbi_m027.AHB_HRESP27 = hresp27;
  assign ahbi_m027.AHB_HRDATA27 = hrdata27;
  assign ahbi_m027.AHB_HREADY27 = hready27;

  assign apbi_mo27.paddr27 = i_apb_subsystem27.i_ahb2apb27.paddr27;
  assign apbi_mo27.prwd27 = i_apb_subsystem27.i_ahb2apb27.pwrite27;
  assign apbi_mo27.pwdata27 = i_apb_subsystem27.i_ahb2apb27.pwdata27;
  assign apbi_mo27.penable27 = i_apb_subsystem27.i_ahb2apb27.penable27;
  assign apbi_mo27.psel27 = {12'b0, i_apb_subsystem27.i_ahb2apb27.psel827, i_apb_subsystem27.i_ahb2apb27.psel227, i_apb_subsystem27.i_ahb2apb27.psel127, i_apb_subsystem27.i_ahb2apb27.psel027};
  assign apbi_mo27.prdata27 = i_apb_subsystem27.i_ahb2apb27.psel027? i_apb_subsystem27.i_ahb2apb27.prdata027 : (i_apb_subsystem27.i_ahb2apb27.psel127? i_apb_subsystem27.i_ahb2apb27.prdata127 : (i_apb_subsystem27.i_ahb2apb27.psel227? i_apb_subsystem27.i_ahb2apb27.prdata227 : i_apb_subsystem27.i_ahb2apb27.prdata827));

  assign spi_s027.sig_n_ss_in27 = n_ss_out27[0];
  assign spi_s027.sig_n_p_reset27 = hresetn27;
  assign spi_s027.sig_pclk27 = tb_hclk27;

  assign gpio_s027.n_p_reset27 = hresetn27;
  assign gpio_s027.pclk27 = tb_hclk27;

  assign hwdata_byte_alligned27 = (ahbi_m027.AHB_HADDR27[1:0] == 2'b00) ? ahbi_m027.AHB_HWDATA27 : {4{ahbi_m027.AHB_HWDATA27[7:0]}};

  apb_subsystem_027 i_apb_subsystem27 (
    // Inputs27
    // system signals27
    .hclk27              (tb_hclk27),     // AHB27 Clock27
    .n_hreset27          (hresetn27),     // AHB27 reset - Active27 low27
    .pclk27              (tb_hclk27),     // APB27 Clock27
    .n_preset27          (hresetn27),     // APB27 reset - Active27 low27
    
    // AHB27 interface for AHB2APM27 bridge27
    .hsel27     (1'b1),        // AHB2APB27 select27
    .haddr27             (ahbi_m027.AHB_HADDR27),        // Address bus
    .htrans27            (ahbi_m027.AHB_HTRANS27),       // Transfer27 type
    .hsize27             (ahbi_m027.AHB_HSIZE27),        // AHB27 Access type - byte half27-word27 word27
    .hwrite27            (ahbi_m027.AHB_HWRITE27),       // Write signal27
    .hwdata27            (hwdata_byte_alligned27),       // Write data
    .hready_in27         (hready27),       // Indicates27 that the last master27 has finished27 
                                       // its bus access
    .hburst27            (ahbi_m027.AHB_HBURST27),       // Burst type
    .hprot27             (ahbi_m027.AHB_HPROT27),        // Protection27 control27
    .hmaster27           (4'h0),      // Master27 select27
    .hmastlock27         (ahbi_m027.AHB_HLOCK27),  // Locked27 transfer27
    // AHB27 interface for SMC27
    .smc_hclk27          (1'b0),
    .smc_n_hclk27        (1'b1),
    .smc_haddr27         (32'd0),
    .smc_htrans27        (2'b00),
    .smc_hsel27          (1'b0),
    .smc_hwrite27        (1'b0),
    .smc_hsize27         (3'd0),
    .smc_hwdata27        (32'd0),
    .smc_hready_in27     (1'b1),
    .smc_hburst27        (3'b000),
    .smc_hprot27         (4'b0000),
    .smc_hmaster27       (4'b0000),
    .smc_hmastlock27     (1'b0),

    //interrupt27 from DMA27
    .DMA_irq27           (1'b0),      

    // Scan27 inputs27
    .scan_en27           (1'b0),         // Scan27 enable pin27
    .scan_in_127         (1'b0),         // Scan27 input for first chain27
    .scan_in_227         (1'b0),        // Scan27 input for second chain27
    .scan_mode27         (1'b0),
    //input for smc27
    .data_smc27          (32'd0),
    //inputs27 for uart27
    .ua_rxd27            (uart_s027.txd27),
    .ua_rxd127           (uart_s127.txd27),
    .ua_ncts27           (uart_s027.cts_n27),
    .ua_ncts127          (uart_s127.cts_n27),
    //inputs27 for spi27
    .n_ss_in27           (1'b1),
    .mi27                (spi_s027.sig_so27),
    .si27                (1'b0),
    .sclk_in27           (1'b0),
    //inputs27 for GPIO27
    .gpio_pin_in27       (gpio_s027.gpio_pin_in27[15:0]),
 
//interrupt27 from Enet27 MAC27
     .macb0_int27     (1'b0),
     .macb1_int27     (1'b0),
     .macb2_int27     (1'b0),
     .macb3_int27     (1'b0),

    // Scan27 outputs27
    .scan_out_127        (),             // Scan27 out for chain27 1
    .scan_out_227        (),             // Scan27 out for chain27 2
   
    //output from APB27 
    // AHB27 interface for AHB2APB27 bridge27
    .hrdata27            (hrdata27),       // Read data provided from target slave27
    .hready27            (hready27),       // Ready27 for new bus cycle from target slave27
    .hresp27             (hresp27),        // Response27 from the bridge27

    // AHB27 interface for SMC27
    .smc_hrdata27        (), 
    .smc_hready27        (),
    .smc_hresp27         (),
  
    //outputs27 from smc27
    .smc_n_ext_oe27      (),
    .smc_data27          (),
    .smc_addr27          (),
    .smc_n_be27          (),
    .smc_n_cs27          (), 
    .smc_n_we27          (),
    .smc_n_wr27          (),
    .smc_n_rd27          (),
    //outputs27 from uart27
    .ua_txd27             (uart_s027.rxd27),
    .ua_txd127            (uart_s127.rxd27),
    .ua_nrts27            (uart_s027.rts_n27),
    .ua_nrts127           (uart_s127.rts_n27),
    // outputs27 from ttc27
    .so                (),
    .mo27                (spi_s027.sig_si27),
    .sclk_out27          (spi_s027.sig_sclk_in27),
    .n_ss_out27          (n_ss_out27[7:0]),
    .n_so_en27           (),
    .n_mo_en27           (),
    .n_sclk_en27         (),
    .n_ss_en27           (),
    //outputs27 from gpio27
    .n_gpio_pin_oe27     (gpio_s027.n_gpio_pin_oe27[15:0]),
    .gpio_pin_out27      (gpio_s027.gpio_pin_out27[15:0]),

//unconnected27 o/p ports27
    .clk_SRPG_macb0_en27(),
    .clk_SRPG_macb1_en27(),
    .clk_SRPG_macb2_en27(),
    .clk_SRPG_macb3_en27(),
    .core06v27(),
    .core08v27(),
    .core10v27(),
    .core12v27(),
    .mte_smc_start27(),
    .mte_uart_start27(),
    .mte_smc_uart_start27(),
    .mte_pm_smc_to_default_start27(),
    .mte_pm_uart_to_default_start27(),
    .mte_pm_smc_uart_to_default_start27(),
    .pcm_irq27(),
    .ttc_irq27(),
    .gpio_irq27(),
    .uart0_irq27(),
    .uart1_irq27(),
    .spi_irq27(),

    .macb3_wakeup27(),
    .macb2_wakeup27(),
    .macb1_wakeup27(),
    .macb0_wakeup27()
);


initial
begin
  tb_hclk27 = 0;
  hresetn27 = 1;

  #1 hresetn27 = 0;
  #1200 hresetn27 = 1;
end

always #50 tb_hclk27 = ~tb_hclk27;

initial begin
  uvm_config_db#(virtual uart_if27)::set(null, "uvm_test_top.ve27.uart027*", "vif27", uart_s027);
  uvm_config_db#(virtual uart_if27)::set(null, "uvm_test_top.ve27.uart127*", "vif27", uart_s127);
  uvm_config_db#(virtual uart_ctrl_internal_if27)::set(null, "uvm_test_top.ve27.apb_ss_env27.apb_uart027.*", "vif27", uart_int027);
  uvm_config_db#(virtual uart_ctrl_internal_if27)::set(null, "uvm_test_top.ve27.apb_ss_env27.apb_uart127.*", "vif27", uart_int127);
  uvm_config_db#(virtual apb_if27)::set(null, "uvm_test_top.ve27.apb027*", "vif27", apbi_mo27);
  uvm_config_db#(virtual ahb_if27)::set(null, "uvm_test_top.ve27.ahb027*", "vif27", ahbi_m027);
  uvm_config_db#(virtual spi_if27)::set(null, "uvm_test_top.ve27.spi027*", "spi_if27", spi_s027);
  uvm_config_db#(virtual gpio_if27)::set(null, "uvm_test_top.ve27.gpio027*", "gpio_if27", gpio_s027);
  run_test();
end

endmodule
