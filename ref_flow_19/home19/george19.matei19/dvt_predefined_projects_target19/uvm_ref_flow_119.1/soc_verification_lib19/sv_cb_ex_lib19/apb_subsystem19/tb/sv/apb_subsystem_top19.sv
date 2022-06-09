/*-------------------------------------------------------------------------
File19 name   : apb_subsystem_top19.v 
Title19       : Top19 level file for the testbench 
Project19     : APB19 Subsystem19
Created19     : March19 2008
Description19 : This19 is top level file which instantiate19 the dut19 apb_subsyste19,.v.
              It also has the assertion19 module which checks19 for the power19 down 
              and power19 up.To19 activate19 the assertion19 ifdef LP_ABV_ON19 is used.       
Notes19       :
-------------------------------------------------------------------------*/ 
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------

 `timescale 1ns/10ps


// Environment19 Constants19
`ifndef AHB_DATA_WIDTH19
  `define AHB_DATA_WIDTH19          32              // AHB19 bus data width [32/64]
`endif
`ifndef AHB_ADDR_WIDTH19
  `define AHB_ADDR_WIDTH19          32              // AHB19 bus address width [32/64]
`endif
`ifndef AHB_DATA_MAX_BIT19
  `define AHB_DATA_MAX_BIT19        31              // MUST19 BE19: AHB_DATA_WIDTH19 - 1
`endif
`ifndef AHB_ADDRESS_MAX_BIT19
  `define AHB_ADDRESS_MAX_BIT19     31              // MUST19 BE19: AHB_ADDR_WIDTH19 - 1
`endif
`ifndef DEFAULT_HREADY_VALUE19
  `define DEFAULT_HREADY_VALUE19    1'b1            // Ready19 Asserted19
`endif

`include "ahb_if19.sv"
`include "apb_if19.sv"
`include "apb_master_if19.sv"
`include "apb_slave_if19.sv"
`include "uart_if19.sv"
`include "spi_if19.sv"
`include "gpio_if19.sv"
`include "coverage19/uart_ctrl_internal_if19.sv"

module apb_subsystem_top19;
  import uvm_pkg::*;
  // Import19 the UVM Utilities19 Package19

  import ahb_pkg19::*;
  import apb_pkg19::*;
  import uart_pkg19::*;
  import gpio_pkg19::*;
  import spi_pkg19::*;
  import uart_ctrl_pkg19::*;
  import apb_subsystem_pkg19::*;

  `include "spi_reg_model19.sv"
  `include "gpio_reg_model19.sv"
  `include "apb_subsystem_reg_rdb19.sv"
  `include "uart_ctrl_reg_seq_lib19.sv"
  `include "spi_reg_seq_lib19.sv"
  `include "gpio_reg_seq_lib19.sv"

  //Include19 module UVC19 sequences
  `include "ahb_user_monitor19.sv"
  `include "apb_subsystem_seq_lib19.sv"
  `include "apb_subsystem_vir_sequencer19.sv"
  `include "apb_subsystem_vir_seq_lib19.sv"

  `include "apb_subsystem_tb19.sv"
  `include "test_lib19.sv"
   
  
   // ====================================
   // SHARED19 signals19
   // ====================================
   
   // clock19
   reg tb_hclk19;
   
   // reset
   reg hresetn19;
   
   // post19-mux19 from master19 mux19
   wire [`AHB_DATA_MAX_BIT19:0] hwdata19;
   wire [`AHB_ADDRESS_MAX_BIT19:0] haddr19;
   wire [1:0]  htrans19;
   wire [2:0]  hburst19;
   wire [2:0]  hsize19;
   wire [3:0]  hprot19;
   wire hwrite19;

   // post19-mux19 from slave19 mux19
   wire        hready19;
   wire [1:0]  hresp19;
   wire [`AHB_DATA_MAX_BIT19:0] hrdata19;
  

  //  Specific19 signals19 of apb19 subsystem19
  reg         ua_rxd19;
  reg         ua_ncts19;


  // uart19 outputs19 
  wire        ua_txd19;
  wire        us_nrts19;

  wire   [7:0] n_ss_out19;    // peripheral19 select19 lines19 from master19
  wire   [31:0] hwdata_byte_alligned19;

  reg [2:0] div8_clk19;
 always @(posedge tb_hclk19) begin
   if (!hresetn19)
     div8_clk19 = 3'b000;
   else
     div8_clk19 = div8_clk19 + 1;
 end


  // Master19 virtual interface
  ahb_if19 ahbi_m019(.ahb_clock19(tb_hclk19), .ahb_resetn19(hresetn19));
  
  uart_if19 uart_s019(.clock19(div8_clk19[2]), .reset(hresetn19));
  uart_if19 uart_s119(.clock19(div8_clk19[2]), .reset(hresetn19));
  spi_if19 spi_s019();
  gpio_if19 gpio_s019();
  uart_ctrl_internal_if19 uart_int019(.clock19(div8_clk19[2]));
  uart_ctrl_internal_if19 uart_int119(.clock19(div8_clk19[2]));

  apb_if19 apbi_mo19(.pclock19(tb_hclk19), .preset19(hresetn19));

  //M019
  assign ahbi_m019.AHB_HCLK19 = tb_hclk19;
  assign ahbi_m019.AHB_HRESET19 = hresetn19;
  assign ahbi_m019.AHB_HRESP19 = hresp19;
  assign ahbi_m019.AHB_HRDATA19 = hrdata19;
  assign ahbi_m019.AHB_HREADY19 = hready19;

  assign apbi_mo19.paddr19 = i_apb_subsystem19.i_ahb2apb19.paddr19;
  assign apbi_mo19.prwd19 = i_apb_subsystem19.i_ahb2apb19.pwrite19;
  assign apbi_mo19.pwdata19 = i_apb_subsystem19.i_ahb2apb19.pwdata19;
  assign apbi_mo19.penable19 = i_apb_subsystem19.i_ahb2apb19.penable19;
  assign apbi_mo19.psel19 = {12'b0, i_apb_subsystem19.i_ahb2apb19.psel819, i_apb_subsystem19.i_ahb2apb19.psel219, i_apb_subsystem19.i_ahb2apb19.psel119, i_apb_subsystem19.i_ahb2apb19.psel019};
  assign apbi_mo19.prdata19 = i_apb_subsystem19.i_ahb2apb19.psel019? i_apb_subsystem19.i_ahb2apb19.prdata019 : (i_apb_subsystem19.i_ahb2apb19.psel119? i_apb_subsystem19.i_ahb2apb19.prdata119 : (i_apb_subsystem19.i_ahb2apb19.psel219? i_apb_subsystem19.i_ahb2apb19.prdata219 : i_apb_subsystem19.i_ahb2apb19.prdata819));

  assign spi_s019.sig_n_ss_in19 = n_ss_out19[0];
  assign spi_s019.sig_n_p_reset19 = hresetn19;
  assign spi_s019.sig_pclk19 = tb_hclk19;

  assign gpio_s019.n_p_reset19 = hresetn19;
  assign gpio_s019.pclk19 = tb_hclk19;

  assign hwdata_byte_alligned19 = (ahbi_m019.AHB_HADDR19[1:0] == 2'b00) ? ahbi_m019.AHB_HWDATA19 : {4{ahbi_m019.AHB_HWDATA19[7:0]}};

  apb_subsystem_019 i_apb_subsystem19 (
    // Inputs19
    // system signals19
    .hclk19              (tb_hclk19),     // AHB19 Clock19
    .n_hreset19          (hresetn19),     // AHB19 reset - Active19 low19
    .pclk19              (tb_hclk19),     // APB19 Clock19
    .n_preset19          (hresetn19),     // APB19 reset - Active19 low19
    
    // AHB19 interface for AHB2APM19 bridge19
    .hsel19     (1'b1),        // AHB2APB19 select19
    .haddr19             (ahbi_m019.AHB_HADDR19),        // Address bus
    .htrans19            (ahbi_m019.AHB_HTRANS19),       // Transfer19 type
    .hsize19             (ahbi_m019.AHB_HSIZE19),        // AHB19 Access type - byte half19-word19 word19
    .hwrite19            (ahbi_m019.AHB_HWRITE19),       // Write signal19
    .hwdata19            (hwdata_byte_alligned19),       // Write data
    .hready_in19         (hready19),       // Indicates19 that the last master19 has finished19 
                                       // its bus access
    .hburst19            (ahbi_m019.AHB_HBURST19),       // Burst type
    .hprot19             (ahbi_m019.AHB_HPROT19),        // Protection19 control19
    .hmaster19           (4'h0),      // Master19 select19
    .hmastlock19         (ahbi_m019.AHB_HLOCK19),  // Locked19 transfer19
    // AHB19 interface for SMC19
    .smc_hclk19          (1'b0),
    .smc_n_hclk19        (1'b1),
    .smc_haddr19         (32'd0),
    .smc_htrans19        (2'b00),
    .smc_hsel19          (1'b0),
    .smc_hwrite19        (1'b0),
    .smc_hsize19         (3'd0),
    .smc_hwdata19        (32'd0),
    .smc_hready_in19     (1'b1),
    .smc_hburst19        (3'b000),
    .smc_hprot19         (4'b0000),
    .smc_hmaster19       (4'b0000),
    .smc_hmastlock19     (1'b0),

    //interrupt19 from DMA19
    .DMA_irq19           (1'b0),      

    // Scan19 inputs19
    .scan_en19           (1'b0),         // Scan19 enable pin19
    .scan_in_119         (1'b0),         // Scan19 input for first chain19
    .scan_in_219         (1'b0),        // Scan19 input for second chain19
    .scan_mode19         (1'b0),
    //input for smc19
    .data_smc19          (32'd0),
    //inputs19 for uart19
    .ua_rxd19            (uart_s019.txd19),
    .ua_rxd119           (uart_s119.txd19),
    .ua_ncts19           (uart_s019.cts_n19),
    .ua_ncts119          (uart_s119.cts_n19),
    //inputs19 for spi19
    .n_ss_in19           (1'b1),
    .mi19                (spi_s019.sig_so19),
    .si19                (1'b0),
    .sclk_in19           (1'b0),
    //inputs19 for GPIO19
    .gpio_pin_in19       (gpio_s019.gpio_pin_in19[15:0]),
 
//interrupt19 from Enet19 MAC19
     .macb0_int19     (1'b0),
     .macb1_int19     (1'b0),
     .macb2_int19     (1'b0),
     .macb3_int19     (1'b0),

    // Scan19 outputs19
    .scan_out_119        (),             // Scan19 out for chain19 1
    .scan_out_219        (),             // Scan19 out for chain19 2
   
    //output from APB19 
    // AHB19 interface for AHB2APB19 bridge19
    .hrdata19            (hrdata19),       // Read data provided from target slave19
    .hready19            (hready19),       // Ready19 for new bus cycle from target slave19
    .hresp19             (hresp19),        // Response19 from the bridge19

    // AHB19 interface for SMC19
    .smc_hrdata19        (), 
    .smc_hready19        (),
    .smc_hresp19         (),
  
    //outputs19 from smc19
    .smc_n_ext_oe19      (),
    .smc_data19          (),
    .smc_addr19          (),
    .smc_n_be19          (),
    .smc_n_cs19          (), 
    .smc_n_we19          (),
    .smc_n_wr19          (),
    .smc_n_rd19          (),
    //outputs19 from uart19
    .ua_txd19             (uart_s019.rxd19),
    .ua_txd119            (uart_s119.rxd19),
    .ua_nrts19            (uart_s019.rts_n19),
    .ua_nrts119           (uart_s119.rts_n19),
    // outputs19 from ttc19
    .so                (),
    .mo19                (spi_s019.sig_si19),
    .sclk_out19          (spi_s019.sig_sclk_in19),
    .n_ss_out19          (n_ss_out19[7:0]),
    .n_so_en19           (),
    .n_mo_en19           (),
    .n_sclk_en19         (),
    .n_ss_en19           (),
    //outputs19 from gpio19
    .n_gpio_pin_oe19     (gpio_s019.n_gpio_pin_oe19[15:0]),
    .gpio_pin_out19      (gpio_s019.gpio_pin_out19[15:0]),

//unconnected19 o/p ports19
    .clk_SRPG_macb0_en19(),
    .clk_SRPG_macb1_en19(),
    .clk_SRPG_macb2_en19(),
    .clk_SRPG_macb3_en19(),
    .core06v19(),
    .core08v19(),
    .core10v19(),
    .core12v19(),
    .mte_smc_start19(),
    .mte_uart_start19(),
    .mte_smc_uart_start19(),
    .mte_pm_smc_to_default_start19(),
    .mte_pm_uart_to_default_start19(),
    .mte_pm_smc_uart_to_default_start19(),
    .pcm_irq19(),
    .ttc_irq19(),
    .gpio_irq19(),
    .uart0_irq19(),
    .uart1_irq19(),
    .spi_irq19(),

    .macb3_wakeup19(),
    .macb2_wakeup19(),
    .macb1_wakeup19(),
    .macb0_wakeup19()
);


initial
begin
  tb_hclk19 = 0;
  hresetn19 = 1;

  #1 hresetn19 = 0;
  #1200 hresetn19 = 1;
end

always #50 tb_hclk19 = ~tb_hclk19;

initial begin
  uvm_config_db#(virtual uart_if19)::set(null, "uvm_test_top.ve19.uart019*", "vif19", uart_s019);
  uvm_config_db#(virtual uart_if19)::set(null, "uvm_test_top.ve19.uart119*", "vif19", uart_s119);
  uvm_config_db#(virtual uart_ctrl_internal_if19)::set(null, "uvm_test_top.ve19.apb_ss_env19.apb_uart019.*", "vif19", uart_int019);
  uvm_config_db#(virtual uart_ctrl_internal_if19)::set(null, "uvm_test_top.ve19.apb_ss_env19.apb_uart119.*", "vif19", uart_int119);
  uvm_config_db#(virtual apb_if19)::set(null, "uvm_test_top.ve19.apb019*", "vif19", apbi_mo19);
  uvm_config_db#(virtual ahb_if19)::set(null, "uvm_test_top.ve19.ahb019*", "vif19", ahbi_m019);
  uvm_config_db#(virtual spi_if19)::set(null, "uvm_test_top.ve19.spi019*", "spi_if19", spi_s019);
  uvm_config_db#(virtual gpio_if19)::set(null, "uvm_test_top.ve19.gpio019*", "gpio_if19", gpio_s019);
  run_test();
end

endmodule
