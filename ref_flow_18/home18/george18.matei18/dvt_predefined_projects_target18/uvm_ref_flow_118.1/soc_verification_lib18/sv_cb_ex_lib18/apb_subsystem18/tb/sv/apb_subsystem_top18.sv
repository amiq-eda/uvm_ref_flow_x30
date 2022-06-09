/*-------------------------------------------------------------------------
File18 name   : apb_subsystem_top18.v 
Title18       : Top18 level file for the testbench 
Project18     : APB18 Subsystem18
Created18     : March18 2008
Description18 : This18 is top level file which instantiate18 the dut18 apb_subsyste18,.v.
              It also has the assertion18 module which checks18 for the power18 down 
              and power18 up.To18 activate18 the assertion18 ifdef LP_ABV_ON18 is used.       
Notes18       :
-------------------------------------------------------------------------*/ 
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------

 `timescale 1ns/10ps


// Environment18 Constants18
`ifndef AHB_DATA_WIDTH18
  `define AHB_DATA_WIDTH18          32              // AHB18 bus data width [32/64]
`endif
`ifndef AHB_ADDR_WIDTH18
  `define AHB_ADDR_WIDTH18          32              // AHB18 bus address width [32/64]
`endif
`ifndef AHB_DATA_MAX_BIT18
  `define AHB_DATA_MAX_BIT18        31              // MUST18 BE18: AHB_DATA_WIDTH18 - 1
`endif
`ifndef AHB_ADDRESS_MAX_BIT18
  `define AHB_ADDRESS_MAX_BIT18     31              // MUST18 BE18: AHB_ADDR_WIDTH18 - 1
`endif
`ifndef DEFAULT_HREADY_VALUE18
  `define DEFAULT_HREADY_VALUE18    1'b1            // Ready18 Asserted18
`endif

`include "ahb_if18.sv"
`include "apb_if18.sv"
`include "apb_master_if18.sv"
`include "apb_slave_if18.sv"
`include "uart_if18.sv"
`include "spi_if18.sv"
`include "gpio_if18.sv"
`include "coverage18/uart_ctrl_internal_if18.sv"

module apb_subsystem_top18;
  import uvm_pkg::*;
  // Import18 the UVM Utilities18 Package18

  import ahb_pkg18::*;
  import apb_pkg18::*;
  import uart_pkg18::*;
  import gpio_pkg18::*;
  import spi_pkg18::*;
  import uart_ctrl_pkg18::*;
  import apb_subsystem_pkg18::*;

  `include "spi_reg_model18.sv"
  `include "gpio_reg_model18.sv"
  `include "apb_subsystem_reg_rdb18.sv"
  `include "uart_ctrl_reg_seq_lib18.sv"
  `include "spi_reg_seq_lib18.sv"
  `include "gpio_reg_seq_lib18.sv"

  //Include18 module UVC18 sequences
  `include "ahb_user_monitor18.sv"
  `include "apb_subsystem_seq_lib18.sv"
  `include "apb_subsystem_vir_sequencer18.sv"
  `include "apb_subsystem_vir_seq_lib18.sv"

  `include "apb_subsystem_tb18.sv"
  `include "test_lib18.sv"
   
  
   // ====================================
   // SHARED18 signals18
   // ====================================
   
   // clock18
   reg tb_hclk18;
   
   // reset
   reg hresetn18;
   
   // post18-mux18 from master18 mux18
   wire [`AHB_DATA_MAX_BIT18:0] hwdata18;
   wire [`AHB_ADDRESS_MAX_BIT18:0] haddr18;
   wire [1:0]  htrans18;
   wire [2:0]  hburst18;
   wire [2:0]  hsize18;
   wire [3:0]  hprot18;
   wire hwrite18;

   // post18-mux18 from slave18 mux18
   wire        hready18;
   wire [1:0]  hresp18;
   wire [`AHB_DATA_MAX_BIT18:0] hrdata18;
  

  //  Specific18 signals18 of apb18 subsystem18
  reg         ua_rxd18;
  reg         ua_ncts18;


  // uart18 outputs18 
  wire        ua_txd18;
  wire        us_nrts18;

  wire   [7:0] n_ss_out18;    // peripheral18 select18 lines18 from master18
  wire   [31:0] hwdata_byte_alligned18;

  reg [2:0] div8_clk18;
 always @(posedge tb_hclk18) begin
   if (!hresetn18)
     div8_clk18 = 3'b000;
   else
     div8_clk18 = div8_clk18 + 1;
 end


  // Master18 virtual interface
  ahb_if18 ahbi_m018(.ahb_clock18(tb_hclk18), .ahb_resetn18(hresetn18));
  
  uart_if18 uart_s018(.clock18(div8_clk18[2]), .reset(hresetn18));
  uart_if18 uart_s118(.clock18(div8_clk18[2]), .reset(hresetn18));
  spi_if18 spi_s018();
  gpio_if18 gpio_s018();
  uart_ctrl_internal_if18 uart_int018(.clock18(div8_clk18[2]));
  uart_ctrl_internal_if18 uart_int118(.clock18(div8_clk18[2]));

  apb_if18 apbi_mo18(.pclock18(tb_hclk18), .preset18(hresetn18));

  //M018
  assign ahbi_m018.AHB_HCLK18 = tb_hclk18;
  assign ahbi_m018.AHB_HRESET18 = hresetn18;
  assign ahbi_m018.AHB_HRESP18 = hresp18;
  assign ahbi_m018.AHB_HRDATA18 = hrdata18;
  assign ahbi_m018.AHB_HREADY18 = hready18;

  assign apbi_mo18.paddr18 = i_apb_subsystem18.i_ahb2apb18.paddr18;
  assign apbi_mo18.prwd18 = i_apb_subsystem18.i_ahb2apb18.pwrite18;
  assign apbi_mo18.pwdata18 = i_apb_subsystem18.i_ahb2apb18.pwdata18;
  assign apbi_mo18.penable18 = i_apb_subsystem18.i_ahb2apb18.penable18;
  assign apbi_mo18.psel18 = {12'b0, i_apb_subsystem18.i_ahb2apb18.psel818, i_apb_subsystem18.i_ahb2apb18.psel218, i_apb_subsystem18.i_ahb2apb18.psel118, i_apb_subsystem18.i_ahb2apb18.psel018};
  assign apbi_mo18.prdata18 = i_apb_subsystem18.i_ahb2apb18.psel018? i_apb_subsystem18.i_ahb2apb18.prdata018 : (i_apb_subsystem18.i_ahb2apb18.psel118? i_apb_subsystem18.i_ahb2apb18.prdata118 : (i_apb_subsystem18.i_ahb2apb18.psel218? i_apb_subsystem18.i_ahb2apb18.prdata218 : i_apb_subsystem18.i_ahb2apb18.prdata818));

  assign spi_s018.sig_n_ss_in18 = n_ss_out18[0];
  assign spi_s018.sig_n_p_reset18 = hresetn18;
  assign spi_s018.sig_pclk18 = tb_hclk18;

  assign gpio_s018.n_p_reset18 = hresetn18;
  assign gpio_s018.pclk18 = tb_hclk18;

  assign hwdata_byte_alligned18 = (ahbi_m018.AHB_HADDR18[1:0] == 2'b00) ? ahbi_m018.AHB_HWDATA18 : {4{ahbi_m018.AHB_HWDATA18[7:0]}};

  apb_subsystem_018 i_apb_subsystem18 (
    // Inputs18
    // system signals18
    .hclk18              (tb_hclk18),     // AHB18 Clock18
    .n_hreset18          (hresetn18),     // AHB18 reset - Active18 low18
    .pclk18              (tb_hclk18),     // APB18 Clock18
    .n_preset18          (hresetn18),     // APB18 reset - Active18 low18
    
    // AHB18 interface for AHB2APM18 bridge18
    .hsel18     (1'b1),        // AHB2APB18 select18
    .haddr18             (ahbi_m018.AHB_HADDR18),        // Address bus
    .htrans18            (ahbi_m018.AHB_HTRANS18),       // Transfer18 type
    .hsize18             (ahbi_m018.AHB_HSIZE18),        // AHB18 Access type - byte half18-word18 word18
    .hwrite18            (ahbi_m018.AHB_HWRITE18),       // Write signal18
    .hwdata18            (hwdata_byte_alligned18),       // Write data
    .hready_in18         (hready18),       // Indicates18 that the last master18 has finished18 
                                       // its bus access
    .hburst18            (ahbi_m018.AHB_HBURST18),       // Burst type
    .hprot18             (ahbi_m018.AHB_HPROT18),        // Protection18 control18
    .hmaster18           (4'h0),      // Master18 select18
    .hmastlock18         (ahbi_m018.AHB_HLOCK18),  // Locked18 transfer18
    // AHB18 interface for SMC18
    .smc_hclk18          (1'b0),
    .smc_n_hclk18        (1'b1),
    .smc_haddr18         (32'd0),
    .smc_htrans18        (2'b00),
    .smc_hsel18          (1'b0),
    .smc_hwrite18        (1'b0),
    .smc_hsize18         (3'd0),
    .smc_hwdata18        (32'd0),
    .smc_hready_in18     (1'b1),
    .smc_hburst18        (3'b000),
    .smc_hprot18         (4'b0000),
    .smc_hmaster18       (4'b0000),
    .smc_hmastlock18     (1'b0),

    //interrupt18 from DMA18
    .DMA_irq18           (1'b0),      

    // Scan18 inputs18
    .scan_en18           (1'b0),         // Scan18 enable pin18
    .scan_in_118         (1'b0),         // Scan18 input for first chain18
    .scan_in_218         (1'b0),        // Scan18 input for second chain18
    .scan_mode18         (1'b0),
    //input for smc18
    .data_smc18          (32'd0),
    //inputs18 for uart18
    .ua_rxd18            (uart_s018.txd18),
    .ua_rxd118           (uart_s118.txd18),
    .ua_ncts18           (uart_s018.cts_n18),
    .ua_ncts118          (uart_s118.cts_n18),
    //inputs18 for spi18
    .n_ss_in18           (1'b1),
    .mi18                (spi_s018.sig_so18),
    .si18                (1'b0),
    .sclk_in18           (1'b0),
    //inputs18 for GPIO18
    .gpio_pin_in18       (gpio_s018.gpio_pin_in18[15:0]),
 
//interrupt18 from Enet18 MAC18
     .macb0_int18     (1'b0),
     .macb1_int18     (1'b0),
     .macb2_int18     (1'b0),
     .macb3_int18     (1'b0),

    // Scan18 outputs18
    .scan_out_118        (),             // Scan18 out for chain18 1
    .scan_out_218        (),             // Scan18 out for chain18 2
   
    //output from APB18 
    // AHB18 interface for AHB2APB18 bridge18
    .hrdata18            (hrdata18),       // Read data provided from target slave18
    .hready18            (hready18),       // Ready18 for new bus cycle from target slave18
    .hresp18             (hresp18),        // Response18 from the bridge18

    // AHB18 interface for SMC18
    .smc_hrdata18        (), 
    .smc_hready18        (),
    .smc_hresp18         (),
  
    //outputs18 from smc18
    .smc_n_ext_oe18      (),
    .smc_data18          (),
    .smc_addr18          (),
    .smc_n_be18          (),
    .smc_n_cs18          (), 
    .smc_n_we18          (),
    .smc_n_wr18          (),
    .smc_n_rd18          (),
    //outputs18 from uart18
    .ua_txd18             (uart_s018.rxd18),
    .ua_txd118            (uart_s118.rxd18),
    .ua_nrts18            (uart_s018.rts_n18),
    .ua_nrts118           (uart_s118.rts_n18),
    // outputs18 from ttc18
    .so                (),
    .mo18                (spi_s018.sig_si18),
    .sclk_out18          (spi_s018.sig_sclk_in18),
    .n_ss_out18          (n_ss_out18[7:0]),
    .n_so_en18           (),
    .n_mo_en18           (),
    .n_sclk_en18         (),
    .n_ss_en18           (),
    //outputs18 from gpio18
    .n_gpio_pin_oe18     (gpio_s018.n_gpio_pin_oe18[15:0]),
    .gpio_pin_out18      (gpio_s018.gpio_pin_out18[15:0]),

//unconnected18 o/p ports18
    .clk_SRPG_macb0_en18(),
    .clk_SRPG_macb1_en18(),
    .clk_SRPG_macb2_en18(),
    .clk_SRPG_macb3_en18(),
    .core06v18(),
    .core08v18(),
    .core10v18(),
    .core12v18(),
    .mte_smc_start18(),
    .mte_uart_start18(),
    .mte_smc_uart_start18(),
    .mte_pm_smc_to_default_start18(),
    .mte_pm_uart_to_default_start18(),
    .mte_pm_smc_uart_to_default_start18(),
    .pcm_irq18(),
    .ttc_irq18(),
    .gpio_irq18(),
    .uart0_irq18(),
    .uart1_irq18(),
    .spi_irq18(),

    .macb3_wakeup18(),
    .macb2_wakeup18(),
    .macb1_wakeup18(),
    .macb0_wakeup18()
);


initial
begin
  tb_hclk18 = 0;
  hresetn18 = 1;

  #1 hresetn18 = 0;
  #1200 hresetn18 = 1;
end

always #50 tb_hclk18 = ~tb_hclk18;

initial begin
  uvm_config_db#(virtual uart_if18)::set(null, "uvm_test_top.ve18.uart018*", "vif18", uart_s018);
  uvm_config_db#(virtual uart_if18)::set(null, "uvm_test_top.ve18.uart118*", "vif18", uart_s118);
  uvm_config_db#(virtual uart_ctrl_internal_if18)::set(null, "uvm_test_top.ve18.apb_ss_env18.apb_uart018.*", "vif18", uart_int018);
  uvm_config_db#(virtual uart_ctrl_internal_if18)::set(null, "uvm_test_top.ve18.apb_ss_env18.apb_uart118.*", "vif18", uart_int118);
  uvm_config_db#(virtual apb_if18)::set(null, "uvm_test_top.ve18.apb018*", "vif18", apbi_mo18);
  uvm_config_db#(virtual ahb_if18)::set(null, "uvm_test_top.ve18.ahb018*", "vif18", ahbi_m018);
  uvm_config_db#(virtual spi_if18)::set(null, "uvm_test_top.ve18.spi018*", "spi_if18", spi_s018);
  uvm_config_db#(virtual gpio_if18)::set(null, "uvm_test_top.ve18.gpio018*", "gpio_if18", gpio_s018);
  run_test();
end

endmodule
