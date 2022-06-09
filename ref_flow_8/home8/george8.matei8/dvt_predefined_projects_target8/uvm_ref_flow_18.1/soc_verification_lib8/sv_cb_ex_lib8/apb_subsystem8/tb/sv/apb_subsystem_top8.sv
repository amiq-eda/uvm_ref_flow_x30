/*-------------------------------------------------------------------------
File8 name   : apb_subsystem_top8.v 
Title8       : Top8 level file for the testbench 
Project8     : APB8 Subsystem8
Created8     : March8 2008
Description8 : This8 is top level file which instantiate8 the dut8 apb_subsyste8,.v.
              It also has the assertion8 module which checks8 for the power8 down 
              and power8 up.To8 activate8 the assertion8 ifdef LP_ABV_ON8 is used.       
Notes8       :
-------------------------------------------------------------------------*/ 
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------

 `timescale 1ns/10ps


// Environment8 Constants8
`ifndef AHB_DATA_WIDTH8
  `define AHB_DATA_WIDTH8          32              // AHB8 bus data width [32/64]
`endif
`ifndef AHB_ADDR_WIDTH8
  `define AHB_ADDR_WIDTH8          32              // AHB8 bus address width [32/64]
`endif
`ifndef AHB_DATA_MAX_BIT8
  `define AHB_DATA_MAX_BIT8        31              // MUST8 BE8: AHB_DATA_WIDTH8 - 1
`endif
`ifndef AHB_ADDRESS_MAX_BIT8
  `define AHB_ADDRESS_MAX_BIT8     31              // MUST8 BE8: AHB_ADDR_WIDTH8 - 1
`endif
`ifndef DEFAULT_HREADY_VALUE8
  `define DEFAULT_HREADY_VALUE8    1'b1            // Ready8 Asserted8
`endif

`include "ahb_if8.sv"
`include "apb_if8.sv"
`include "apb_master_if8.sv"
`include "apb_slave_if8.sv"
`include "uart_if8.sv"
`include "spi_if8.sv"
`include "gpio_if8.sv"
`include "coverage8/uart_ctrl_internal_if8.sv"

module apb_subsystem_top8;
  import uvm_pkg::*;
  // Import8 the UVM Utilities8 Package8

  import ahb_pkg8::*;
  import apb_pkg8::*;
  import uart_pkg8::*;
  import gpio_pkg8::*;
  import spi_pkg8::*;
  import uart_ctrl_pkg8::*;
  import apb_subsystem_pkg8::*;

  `include "spi_reg_model8.sv"
  `include "gpio_reg_model8.sv"
  `include "apb_subsystem_reg_rdb8.sv"
  `include "uart_ctrl_reg_seq_lib8.sv"
  `include "spi_reg_seq_lib8.sv"
  `include "gpio_reg_seq_lib8.sv"

  //Include8 module UVC8 sequences
  `include "ahb_user_monitor8.sv"
  `include "apb_subsystem_seq_lib8.sv"
  `include "apb_subsystem_vir_sequencer8.sv"
  `include "apb_subsystem_vir_seq_lib8.sv"

  `include "apb_subsystem_tb8.sv"
  `include "test_lib8.sv"
   
  
   // ====================================
   // SHARED8 signals8
   // ====================================
   
   // clock8
   reg tb_hclk8;
   
   // reset
   reg hresetn8;
   
   // post8-mux8 from master8 mux8
   wire [`AHB_DATA_MAX_BIT8:0] hwdata8;
   wire [`AHB_ADDRESS_MAX_BIT8:0] haddr8;
   wire [1:0]  htrans8;
   wire [2:0]  hburst8;
   wire [2:0]  hsize8;
   wire [3:0]  hprot8;
   wire hwrite8;

   // post8-mux8 from slave8 mux8
   wire        hready8;
   wire [1:0]  hresp8;
   wire [`AHB_DATA_MAX_BIT8:0] hrdata8;
  

  //  Specific8 signals8 of apb8 subsystem8
  reg         ua_rxd8;
  reg         ua_ncts8;


  // uart8 outputs8 
  wire        ua_txd8;
  wire        us_nrts8;

  wire   [7:0] n_ss_out8;    // peripheral8 select8 lines8 from master8
  wire   [31:0] hwdata_byte_alligned8;

  reg [2:0] div8_clk8;
 always @(posedge tb_hclk8) begin
   if (!hresetn8)
     div8_clk8 = 3'b000;
   else
     div8_clk8 = div8_clk8 + 1;
 end


  // Master8 virtual interface
  ahb_if8 ahbi_m08(.ahb_clock8(tb_hclk8), .ahb_resetn8(hresetn8));
  
  uart_if8 uart_s08(.clock8(div8_clk8[2]), .reset(hresetn8));
  uart_if8 uart_s18(.clock8(div8_clk8[2]), .reset(hresetn8));
  spi_if8 spi_s08();
  gpio_if8 gpio_s08();
  uart_ctrl_internal_if8 uart_int08(.clock8(div8_clk8[2]));
  uart_ctrl_internal_if8 uart_int18(.clock8(div8_clk8[2]));

  apb_if8 apbi_mo8(.pclock8(tb_hclk8), .preset8(hresetn8));

  //M08
  assign ahbi_m08.AHB_HCLK8 = tb_hclk8;
  assign ahbi_m08.AHB_HRESET8 = hresetn8;
  assign ahbi_m08.AHB_HRESP8 = hresp8;
  assign ahbi_m08.AHB_HRDATA8 = hrdata8;
  assign ahbi_m08.AHB_HREADY8 = hready8;

  assign apbi_mo8.paddr8 = i_apb_subsystem8.i_ahb2apb8.paddr8;
  assign apbi_mo8.prwd8 = i_apb_subsystem8.i_ahb2apb8.pwrite8;
  assign apbi_mo8.pwdata8 = i_apb_subsystem8.i_ahb2apb8.pwdata8;
  assign apbi_mo8.penable8 = i_apb_subsystem8.i_ahb2apb8.penable8;
  assign apbi_mo8.psel8 = {12'b0, i_apb_subsystem8.i_ahb2apb8.psel88, i_apb_subsystem8.i_ahb2apb8.psel28, i_apb_subsystem8.i_ahb2apb8.psel18, i_apb_subsystem8.i_ahb2apb8.psel08};
  assign apbi_mo8.prdata8 = i_apb_subsystem8.i_ahb2apb8.psel08? i_apb_subsystem8.i_ahb2apb8.prdata08 : (i_apb_subsystem8.i_ahb2apb8.psel18? i_apb_subsystem8.i_ahb2apb8.prdata18 : (i_apb_subsystem8.i_ahb2apb8.psel28? i_apb_subsystem8.i_ahb2apb8.prdata28 : i_apb_subsystem8.i_ahb2apb8.prdata88));

  assign spi_s08.sig_n_ss_in8 = n_ss_out8[0];
  assign spi_s08.sig_n_p_reset8 = hresetn8;
  assign spi_s08.sig_pclk8 = tb_hclk8;

  assign gpio_s08.n_p_reset8 = hresetn8;
  assign gpio_s08.pclk8 = tb_hclk8;

  assign hwdata_byte_alligned8 = (ahbi_m08.AHB_HADDR8[1:0] == 2'b00) ? ahbi_m08.AHB_HWDATA8 : {4{ahbi_m08.AHB_HWDATA8[7:0]}};

  apb_subsystem_08 i_apb_subsystem8 (
    // Inputs8
    // system signals8
    .hclk8              (tb_hclk8),     // AHB8 Clock8
    .n_hreset8          (hresetn8),     // AHB8 reset - Active8 low8
    .pclk8              (tb_hclk8),     // APB8 Clock8
    .n_preset8          (hresetn8),     // APB8 reset - Active8 low8
    
    // AHB8 interface for AHB2APM8 bridge8
    .hsel8     (1'b1),        // AHB2APB8 select8
    .haddr8             (ahbi_m08.AHB_HADDR8),        // Address bus
    .htrans8            (ahbi_m08.AHB_HTRANS8),       // Transfer8 type
    .hsize8             (ahbi_m08.AHB_HSIZE8),        // AHB8 Access type - byte half8-word8 word8
    .hwrite8            (ahbi_m08.AHB_HWRITE8),       // Write signal8
    .hwdata8            (hwdata_byte_alligned8),       // Write data
    .hready_in8         (hready8),       // Indicates8 that the last master8 has finished8 
                                       // its bus access
    .hburst8            (ahbi_m08.AHB_HBURST8),       // Burst type
    .hprot8             (ahbi_m08.AHB_HPROT8),        // Protection8 control8
    .hmaster8           (4'h0),      // Master8 select8
    .hmastlock8         (ahbi_m08.AHB_HLOCK8),  // Locked8 transfer8
    // AHB8 interface for SMC8
    .smc_hclk8          (1'b0),
    .smc_n_hclk8        (1'b1),
    .smc_haddr8         (32'd0),
    .smc_htrans8        (2'b00),
    .smc_hsel8          (1'b0),
    .smc_hwrite8        (1'b0),
    .smc_hsize8         (3'd0),
    .smc_hwdata8        (32'd0),
    .smc_hready_in8     (1'b1),
    .smc_hburst8        (3'b000),
    .smc_hprot8         (4'b0000),
    .smc_hmaster8       (4'b0000),
    .smc_hmastlock8     (1'b0),

    //interrupt8 from DMA8
    .DMA_irq8           (1'b0),      

    // Scan8 inputs8
    .scan_en8           (1'b0),         // Scan8 enable pin8
    .scan_in_18         (1'b0),         // Scan8 input for first chain8
    .scan_in_28         (1'b0),        // Scan8 input for second chain8
    .scan_mode8         (1'b0),
    //input for smc8
    .data_smc8          (32'd0),
    //inputs8 for uart8
    .ua_rxd8            (uart_s08.txd8),
    .ua_rxd18           (uart_s18.txd8),
    .ua_ncts8           (uart_s08.cts_n8),
    .ua_ncts18          (uart_s18.cts_n8),
    //inputs8 for spi8
    .n_ss_in8           (1'b1),
    .mi8                (spi_s08.sig_so8),
    .si8                (1'b0),
    .sclk_in8           (1'b0),
    //inputs8 for GPIO8
    .gpio_pin_in8       (gpio_s08.gpio_pin_in8[15:0]),
 
//interrupt8 from Enet8 MAC8
     .macb0_int8     (1'b0),
     .macb1_int8     (1'b0),
     .macb2_int8     (1'b0),
     .macb3_int8     (1'b0),

    // Scan8 outputs8
    .scan_out_18        (),             // Scan8 out for chain8 1
    .scan_out_28        (),             // Scan8 out for chain8 2
   
    //output from APB8 
    // AHB8 interface for AHB2APB8 bridge8
    .hrdata8            (hrdata8),       // Read data provided from target slave8
    .hready8            (hready8),       // Ready8 for new bus cycle from target slave8
    .hresp8             (hresp8),        // Response8 from the bridge8

    // AHB8 interface for SMC8
    .smc_hrdata8        (), 
    .smc_hready8        (),
    .smc_hresp8         (),
  
    //outputs8 from smc8
    .smc_n_ext_oe8      (),
    .smc_data8          (),
    .smc_addr8          (),
    .smc_n_be8          (),
    .smc_n_cs8          (), 
    .smc_n_we8          (),
    .smc_n_wr8          (),
    .smc_n_rd8          (),
    //outputs8 from uart8
    .ua_txd8             (uart_s08.rxd8),
    .ua_txd18            (uart_s18.rxd8),
    .ua_nrts8            (uart_s08.rts_n8),
    .ua_nrts18           (uart_s18.rts_n8),
    // outputs8 from ttc8
    .so                (),
    .mo8                (spi_s08.sig_si8),
    .sclk_out8          (spi_s08.sig_sclk_in8),
    .n_ss_out8          (n_ss_out8[7:0]),
    .n_so_en8           (),
    .n_mo_en8           (),
    .n_sclk_en8         (),
    .n_ss_en8           (),
    //outputs8 from gpio8
    .n_gpio_pin_oe8     (gpio_s08.n_gpio_pin_oe8[15:0]),
    .gpio_pin_out8      (gpio_s08.gpio_pin_out8[15:0]),

//unconnected8 o/p ports8
    .clk_SRPG_macb0_en8(),
    .clk_SRPG_macb1_en8(),
    .clk_SRPG_macb2_en8(),
    .clk_SRPG_macb3_en8(),
    .core06v8(),
    .core08v8(),
    .core10v8(),
    .core12v8(),
    .mte_smc_start8(),
    .mte_uart_start8(),
    .mte_smc_uart_start8(),
    .mte_pm_smc_to_default_start8(),
    .mte_pm_uart_to_default_start8(),
    .mte_pm_smc_uart_to_default_start8(),
    .pcm_irq8(),
    .ttc_irq8(),
    .gpio_irq8(),
    .uart0_irq8(),
    .uart1_irq8(),
    .spi_irq8(),

    .macb3_wakeup8(),
    .macb2_wakeup8(),
    .macb1_wakeup8(),
    .macb0_wakeup8()
);


initial
begin
  tb_hclk8 = 0;
  hresetn8 = 1;

  #1 hresetn8 = 0;
  #1200 hresetn8 = 1;
end

always #50 tb_hclk8 = ~tb_hclk8;

initial begin
  uvm_config_db#(virtual uart_if8)::set(null, "uvm_test_top.ve8.uart08*", "vif8", uart_s08);
  uvm_config_db#(virtual uart_if8)::set(null, "uvm_test_top.ve8.uart18*", "vif8", uart_s18);
  uvm_config_db#(virtual uart_ctrl_internal_if8)::set(null, "uvm_test_top.ve8.apb_ss_env8.apb_uart08.*", "vif8", uart_int08);
  uvm_config_db#(virtual uart_ctrl_internal_if8)::set(null, "uvm_test_top.ve8.apb_ss_env8.apb_uart18.*", "vif8", uart_int18);
  uvm_config_db#(virtual apb_if8)::set(null, "uvm_test_top.ve8.apb08*", "vif8", apbi_mo8);
  uvm_config_db#(virtual ahb_if8)::set(null, "uvm_test_top.ve8.ahb08*", "vif8", ahbi_m08);
  uvm_config_db#(virtual spi_if8)::set(null, "uvm_test_top.ve8.spi08*", "spi_if8", spi_s08);
  uvm_config_db#(virtual gpio_if8)::set(null, "uvm_test_top.ve8.gpio08*", "gpio_if8", gpio_s08);
  run_test();
end

endmodule
