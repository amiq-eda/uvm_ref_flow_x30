/*-------------------------------------------------------------------------
File13 name   : apb_subsystem_top13.v 
Title13       : Top13 level file for the testbench 
Project13     : APB13 Subsystem13
Created13     : March13 2008
Description13 : This13 is top level file which instantiate13 the dut13 apb_subsyste13,.v.
              It also has the assertion13 module which checks13 for the power13 down 
              and power13 up.To13 activate13 the assertion13 ifdef LP_ABV_ON13 is used.       
Notes13       :
-------------------------------------------------------------------------*/ 
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------

 `timescale 1ns/10ps


// Environment13 Constants13
`ifndef AHB_DATA_WIDTH13
  `define AHB_DATA_WIDTH13          32              // AHB13 bus data width [32/64]
`endif
`ifndef AHB_ADDR_WIDTH13
  `define AHB_ADDR_WIDTH13          32              // AHB13 bus address width [32/64]
`endif
`ifndef AHB_DATA_MAX_BIT13
  `define AHB_DATA_MAX_BIT13        31              // MUST13 BE13: AHB_DATA_WIDTH13 - 1
`endif
`ifndef AHB_ADDRESS_MAX_BIT13
  `define AHB_ADDRESS_MAX_BIT13     31              // MUST13 BE13: AHB_ADDR_WIDTH13 - 1
`endif
`ifndef DEFAULT_HREADY_VALUE13
  `define DEFAULT_HREADY_VALUE13    1'b1            // Ready13 Asserted13
`endif

`include "ahb_if13.sv"
`include "apb_if13.sv"
`include "apb_master_if13.sv"
`include "apb_slave_if13.sv"
`include "uart_if13.sv"
`include "spi_if13.sv"
`include "gpio_if13.sv"
`include "coverage13/uart_ctrl_internal_if13.sv"

module apb_subsystem_top13;
  import uvm_pkg::*;
  // Import13 the UVM Utilities13 Package13

  import ahb_pkg13::*;
  import apb_pkg13::*;
  import uart_pkg13::*;
  import gpio_pkg13::*;
  import spi_pkg13::*;
  import uart_ctrl_pkg13::*;
  import apb_subsystem_pkg13::*;

  `include "spi_reg_model13.sv"
  `include "gpio_reg_model13.sv"
  `include "apb_subsystem_reg_rdb13.sv"
  `include "uart_ctrl_reg_seq_lib13.sv"
  `include "spi_reg_seq_lib13.sv"
  `include "gpio_reg_seq_lib13.sv"

  //Include13 module UVC13 sequences
  `include "ahb_user_monitor13.sv"
  `include "apb_subsystem_seq_lib13.sv"
  `include "apb_subsystem_vir_sequencer13.sv"
  `include "apb_subsystem_vir_seq_lib13.sv"

  `include "apb_subsystem_tb13.sv"
  `include "test_lib13.sv"
   
  
   // ====================================
   // SHARED13 signals13
   // ====================================
   
   // clock13
   reg tb_hclk13;
   
   // reset
   reg hresetn13;
   
   // post13-mux13 from master13 mux13
   wire [`AHB_DATA_MAX_BIT13:0] hwdata13;
   wire [`AHB_ADDRESS_MAX_BIT13:0] haddr13;
   wire [1:0]  htrans13;
   wire [2:0]  hburst13;
   wire [2:0]  hsize13;
   wire [3:0]  hprot13;
   wire hwrite13;

   // post13-mux13 from slave13 mux13
   wire        hready13;
   wire [1:0]  hresp13;
   wire [`AHB_DATA_MAX_BIT13:0] hrdata13;
  

  //  Specific13 signals13 of apb13 subsystem13
  reg         ua_rxd13;
  reg         ua_ncts13;


  // uart13 outputs13 
  wire        ua_txd13;
  wire        us_nrts13;

  wire   [7:0] n_ss_out13;    // peripheral13 select13 lines13 from master13
  wire   [31:0] hwdata_byte_alligned13;

  reg [2:0] div8_clk13;
 always @(posedge tb_hclk13) begin
   if (!hresetn13)
     div8_clk13 = 3'b000;
   else
     div8_clk13 = div8_clk13 + 1;
 end


  // Master13 virtual interface
  ahb_if13 ahbi_m013(.ahb_clock13(tb_hclk13), .ahb_resetn13(hresetn13));
  
  uart_if13 uart_s013(.clock13(div8_clk13[2]), .reset(hresetn13));
  uart_if13 uart_s113(.clock13(div8_clk13[2]), .reset(hresetn13));
  spi_if13 spi_s013();
  gpio_if13 gpio_s013();
  uart_ctrl_internal_if13 uart_int013(.clock13(div8_clk13[2]));
  uart_ctrl_internal_if13 uart_int113(.clock13(div8_clk13[2]));

  apb_if13 apbi_mo13(.pclock13(tb_hclk13), .preset13(hresetn13));

  //M013
  assign ahbi_m013.AHB_HCLK13 = tb_hclk13;
  assign ahbi_m013.AHB_HRESET13 = hresetn13;
  assign ahbi_m013.AHB_HRESP13 = hresp13;
  assign ahbi_m013.AHB_HRDATA13 = hrdata13;
  assign ahbi_m013.AHB_HREADY13 = hready13;

  assign apbi_mo13.paddr13 = i_apb_subsystem13.i_ahb2apb13.paddr13;
  assign apbi_mo13.prwd13 = i_apb_subsystem13.i_ahb2apb13.pwrite13;
  assign apbi_mo13.pwdata13 = i_apb_subsystem13.i_ahb2apb13.pwdata13;
  assign apbi_mo13.penable13 = i_apb_subsystem13.i_ahb2apb13.penable13;
  assign apbi_mo13.psel13 = {12'b0, i_apb_subsystem13.i_ahb2apb13.psel813, i_apb_subsystem13.i_ahb2apb13.psel213, i_apb_subsystem13.i_ahb2apb13.psel113, i_apb_subsystem13.i_ahb2apb13.psel013};
  assign apbi_mo13.prdata13 = i_apb_subsystem13.i_ahb2apb13.psel013? i_apb_subsystem13.i_ahb2apb13.prdata013 : (i_apb_subsystem13.i_ahb2apb13.psel113? i_apb_subsystem13.i_ahb2apb13.prdata113 : (i_apb_subsystem13.i_ahb2apb13.psel213? i_apb_subsystem13.i_ahb2apb13.prdata213 : i_apb_subsystem13.i_ahb2apb13.prdata813));

  assign spi_s013.sig_n_ss_in13 = n_ss_out13[0];
  assign spi_s013.sig_n_p_reset13 = hresetn13;
  assign spi_s013.sig_pclk13 = tb_hclk13;

  assign gpio_s013.n_p_reset13 = hresetn13;
  assign gpio_s013.pclk13 = tb_hclk13;

  assign hwdata_byte_alligned13 = (ahbi_m013.AHB_HADDR13[1:0] == 2'b00) ? ahbi_m013.AHB_HWDATA13 : {4{ahbi_m013.AHB_HWDATA13[7:0]}};

  apb_subsystem_013 i_apb_subsystem13 (
    // Inputs13
    // system signals13
    .hclk13              (tb_hclk13),     // AHB13 Clock13
    .n_hreset13          (hresetn13),     // AHB13 reset - Active13 low13
    .pclk13              (tb_hclk13),     // APB13 Clock13
    .n_preset13          (hresetn13),     // APB13 reset - Active13 low13
    
    // AHB13 interface for AHB2APM13 bridge13
    .hsel13     (1'b1),        // AHB2APB13 select13
    .haddr13             (ahbi_m013.AHB_HADDR13),        // Address bus
    .htrans13            (ahbi_m013.AHB_HTRANS13),       // Transfer13 type
    .hsize13             (ahbi_m013.AHB_HSIZE13),        // AHB13 Access type - byte half13-word13 word13
    .hwrite13            (ahbi_m013.AHB_HWRITE13),       // Write signal13
    .hwdata13            (hwdata_byte_alligned13),       // Write data
    .hready_in13         (hready13),       // Indicates13 that the last master13 has finished13 
                                       // its bus access
    .hburst13            (ahbi_m013.AHB_HBURST13),       // Burst type
    .hprot13             (ahbi_m013.AHB_HPROT13),        // Protection13 control13
    .hmaster13           (4'h0),      // Master13 select13
    .hmastlock13         (ahbi_m013.AHB_HLOCK13),  // Locked13 transfer13
    // AHB13 interface for SMC13
    .smc_hclk13          (1'b0),
    .smc_n_hclk13        (1'b1),
    .smc_haddr13         (32'd0),
    .smc_htrans13        (2'b00),
    .smc_hsel13          (1'b0),
    .smc_hwrite13        (1'b0),
    .smc_hsize13         (3'd0),
    .smc_hwdata13        (32'd0),
    .smc_hready_in13     (1'b1),
    .smc_hburst13        (3'b000),
    .smc_hprot13         (4'b0000),
    .smc_hmaster13       (4'b0000),
    .smc_hmastlock13     (1'b0),

    //interrupt13 from DMA13
    .DMA_irq13           (1'b0),      

    // Scan13 inputs13
    .scan_en13           (1'b0),         // Scan13 enable pin13
    .scan_in_113         (1'b0),         // Scan13 input for first chain13
    .scan_in_213         (1'b0),        // Scan13 input for second chain13
    .scan_mode13         (1'b0),
    //input for smc13
    .data_smc13          (32'd0),
    //inputs13 for uart13
    .ua_rxd13            (uart_s013.txd13),
    .ua_rxd113           (uart_s113.txd13),
    .ua_ncts13           (uart_s013.cts_n13),
    .ua_ncts113          (uart_s113.cts_n13),
    //inputs13 for spi13
    .n_ss_in13           (1'b1),
    .mi13                (spi_s013.sig_so13),
    .si13                (1'b0),
    .sclk_in13           (1'b0),
    //inputs13 for GPIO13
    .gpio_pin_in13       (gpio_s013.gpio_pin_in13[15:0]),
 
//interrupt13 from Enet13 MAC13
     .macb0_int13     (1'b0),
     .macb1_int13     (1'b0),
     .macb2_int13     (1'b0),
     .macb3_int13     (1'b0),

    // Scan13 outputs13
    .scan_out_113        (),             // Scan13 out for chain13 1
    .scan_out_213        (),             // Scan13 out for chain13 2
   
    //output from APB13 
    // AHB13 interface for AHB2APB13 bridge13
    .hrdata13            (hrdata13),       // Read data provided from target slave13
    .hready13            (hready13),       // Ready13 for new bus cycle from target slave13
    .hresp13             (hresp13),        // Response13 from the bridge13

    // AHB13 interface for SMC13
    .smc_hrdata13        (), 
    .smc_hready13        (),
    .smc_hresp13         (),
  
    //outputs13 from smc13
    .smc_n_ext_oe13      (),
    .smc_data13          (),
    .smc_addr13          (),
    .smc_n_be13          (),
    .smc_n_cs13          (), 
    .smc_n_we13          (),
    .smc_n_wr13          (),
    .smc_n_rd13          (),
    //outputs13 from uart13
    .ua_txd13             (uart_s013.rxd13),
    .ua_txd113            (uart_s113.rxd13),
    .ua_nrts13            (uart_s013.rts_n13),
    .ua_nrts113           (uart_s113.rts_n13),
    // outputs13 from ttc13
    .so                (),
    .mo13                (spi_s013.sig_si13),
    .sclk_out13          (spi_s013.sig_sclk_in13),
    .n_ss_out13          (n_ss_out13[7:0]),
    .n_so_en13           (),
    .n_mo_en13           (),
    .n_sclk_en13         (),
    .n_ss_en13           (),
    //outputs13 from gpio13
    .n_gpio_pin_oe13     (gpio_s013.n_gpio_pin_oe13[15:0]),
    .gpio_pin_out13      (gpio_s013.gpio_pin_out13[15:0]),

//unconnected13 o/p ports13
    .clk_SRPG_macb0_en13(),
    .clk_SRPG_macb1_en13(),
    .clk_SRPG_macb2_en13(),
    .clk_SRPG_macb3_en13(),
    .core06v13(),
    .core08v13(),
    .core10v13(),
    .core12v13(),
    .mte_smc_start13(),
    .mte_uart_start13(),
    .mte_smc_uart_start13(),
    .mte_pm_smc_to_default_start13(),
    .mte_pm_uart_to_default_start13(),
    .mte_pm_smc_uart_to_default_start13(),
    .pcm_irq13(),
    .ttc_irq13(),
    .gpio_irq13(),
    .uart0_irq13(),
    .uart1_irq13(),
    .spi_irq13(),

    .macb3_wakeup13(),
    .macb2_wakeup13(),
    .macb1_wakeup13(),
    .macb0_wakeup13()
);


initial
begin
  tb_hclk13 = 0;
  hresetn13 = 1;

  #1 hresetn13 = 0;
  #1200 hresetn13 = 1;
end

always #50 tb_hclk13 = ~tb_hclk13;

initial begin
  uvm_config_db#(virtual uart_if13)::set(null, "uvm_test_top.ve13.uart013*", "vif13", uart_s013);
  uvm_config_db#(virtual uart_if13)::set(null, "uvm_test_top.ve13.uart113*", "vif13", uart_s113);
  uvm_config_db#(virtual uart_ctrl_internal_if13)::set(null, "uvm_test_top.ve13.apb_ss_env13.apb_uart013.*", "vif13", uart_int013);
  uvm_config_db#(virtual uart_ctrl_internal_if13)::set(null, "uvm_test_top.ve13.apb_ss_env13.apb_uart113.*", "vif13", uart_int113);
  uvm_config_db#(virtual apb_if13)::set(null, "uvm_test_top.ve13.apb013*", "vif13", apbi_mo13);
  uvm_config_db#(virtual ahb_if13)::set(null, "uvm_test_top.ve13.ahb013*", "vif13", ahbi_m013);
  uvm_config_db#(virtual spi_if13)::set(null, "uvm_test_top.ve13.spi013*", "spi_if13", spi_s013);
  uvm_config_db#(virtual gpio_if13)::set(null, "uvm_test_top.ve13.gpio013*", "gpio_if13", gpio_s013);
  run_test();
end

endmodule
