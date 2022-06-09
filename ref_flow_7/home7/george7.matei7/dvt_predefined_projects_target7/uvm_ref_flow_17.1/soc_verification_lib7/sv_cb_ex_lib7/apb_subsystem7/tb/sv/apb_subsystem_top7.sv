/*-------------------------------------------------------------------------
File7 name   : apb_subsystem_top7.v 
Title7       : Top7 level file for the testbench 
Project7     : APB7 Subsystem7
Created7     : March7 2008
Description7 : This7 is top level file which instantiate7 the dut7 apb_subsyste7,.v.
              It also has the assertion7 module which checks7 for the power7 down 
              and power7 up.To7 activate7 the assertion7 ifdef LP_ABV_ON7 is used.       
Notes7       :
-------------------------------------------------------------------------*/ 
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------

 `timescale 1ns/10ps


// Environment7 Constants7
`ifndef AHB_DATA_WIDTH7
  `define AHB_DATA_WIDTH7          32              // AHB7 bus data width [32/64]
`endif
`ifndef AHB_ADDR_WIDTH7
  `define AHB_ADDR_WIDTH7          32              // AHB7 bus address width [32/64]
`endif
`ifndef AHB_DATA_MAX_BIT7
  `define AHB_DATA_MAX_BIT7        31              // MUST7 BE7: AHB_DATA_WIDTH7 - 1
`endif
`ifndef AHB_ADDRESS_MAX_BIT7
  `define AHB_ADDRESS_MAX_BIT7     31              // MUST7 BE7: AHB_ADDR_WIDTH7 - 1
`endif
`ifndef DEFAULT_HREADY_VALUE7
  `define DEFAULT_HREADY_VALUE7    1'b1            // Ready7 Asserted7
`endif

`include "ahb_if7.sv"
`include "apb_if7.sv"
`include "apb_master_if7.sv"
`include "apb_slave_if7.sv"
`include "uart_if7.sv"
`include "spi_if7.sv"
`include "gpio_if7.sv"
`include "coverage7/uart_ctrl_internal_if7.sv"

module apb_subsystem_top7;
  import uvm_pkg::*;
  // Import7 the UVM Utilities7 Package7

  import ahb_pkg7::*;
  import apb_pkg7::*;
  import uart_pkg7::*;
  import gpio_pkg7::*;
  import spi_pkg7::*;
  import uart_ctrl_pkg7::*;
  import apb_subsystem_pkg7::*;

  `include "spi_reg_model7.sv"
  `include "gpio_reg_model7.sv"
  `include "apb_subsystem_reg_rdb7.sv"
  `include "uart_ctrl_reg_seq_lib7.sv"
  `include "spi_reg_seq_lib7.sv"
  `include "gpio_reg_seq_lib7.sv"

  //Include7 module UVC7 sequences
  `include "ahb_user_monitor7.sv"
  `include "apb_subsystem_seq_lib7.sv"
  `include "apb_subsystem_vir_sequencer7.sv"
  `include "apb_subsystem_vir_seq_lib7.sv"

  `include "apb_subsystem_tb7.sv"
  `include "test_lib7.sv"
   
  
   // ====================================
   // SHARED7 signals7
   // ====================================
   
   // clock7
   reg tb_hclk7;
   
   // reset
   reg hresetn7;
   
   // post7-mux7 from master7 mux7
   wire [`AHB_DATA_MAX_BIT7:0] hwdata7;
   wire [`AHB_ADDRESS_MAX_BIT7:0] haddr7;
   wire [1:0]  htrans7;
   wire [2:0]  hburst7;
   wire [2:0]  hsize7;
   wire [3:0]  hprot7;
   wire hwrite7;

   // post7-mux7 from slave7 mux7
   wire        hready7;
   wire [1:0]  hresp7;
   wire [`AHB_DATA_MAX_BIT7:0] hrdata7;
  

  //  Specific7 signals7 of apb7 subsystem7
  reg         ua_rxd7;
  reg         ua_ncts7;


  // uart7 outputs7 
  wire        ua_txd7;
  wire        us_nrts7;

  wire   [7:0] n_ss_out7;    // peripheral7 select7 lines7 from master7
  wire   [31:0] hwdata_byte_alligned7;

  reg [2:0] div8_clk7;
 always @(posedge tb_hclk7) begin
   if (!hresetn7)
     div8_clk7 = 3'b000;
   else
     div8_clk7 = div8_clk7 + 1;
 end


  // Master7 virtual interface
  ahb_if7 ahbi_m07(.ahb_clock7(tb_hclk7), .ahb_resetn7(hresetn7));
  
  uart_if7 uart_s07(.clock7(div8_clk7[2]), .reset(hresetn7));
  uart_if7 uart_s17(.clock7(div8_clk7[2]), .reset(hresetn7));
  spi_if7 spi_s07();
  gpio_if7 gpio_s07();
  uart_ctrl_internal_if7 uart_int07(.clock7(div8_clk7[2]));
  uart_ctrl_internal_if7 uart_int17(.clock7(div8_clk7[2]));

  apb_if7 apbi_mo7(.pclock7(tb_hclk7), .preset7(hresetn7));

  //M07
  assign ahbi_m07.AHB_HCLK7 = tb_hclk7;
  assign ahbi_m07.AHB_HRESET7 = hresetn7;
  assign ahbi_m07.AHB_HRESP7 = hresp7;
  assign ahbi_m07.AHB_HRDATA7 = hrdata7;
  assign ahbi_m07.AHB_HREADY7 = hready7;

  assign apbi_mo7.paddr7 = i_apb_subsystem7.i_ahb2apb7.paddr7;
  assign apbi_mo7.prwd7 = i_apb_subsystem7.i_ahb2apb7.pwrite7;
  assign apbi_mo7.pwdata7 = i_apb_subsystem7.i_ahb2apb7.pwdata7;
  assign apbi_mo7.penable7 = i_apb_subsystem7.i_ahb2apb7.penable7;
  assign apbi_mo7.psel7 = {12'b0, i_apb_subsystem7.i_ahb2apb7.psel87, i_apb_subsystem7.i_ahb2apb7.psel27, i_apb_subsystem7.i_ahb2apb7.psel17, i_apb_subsystem7.i_ahb2apb7.psel07};
  assign apbi_mo7.prdata7 = i_apb_subsystem7.i_ahb2apb7.psel07? i_apb_subsystem7.i_ahb2apb7.prdata07 : (i_apb_subsystem7.i_ahb2apb7.psel17? i_apb_subsystem7.i_ahb2apb7.prdata17 : (i_apb_subsystem7.i_ahb2apb7.psel27? i_apb_subsystem7.i_ahb2apb7.prdata27 : i_apb_subsystem7.i_ahb2apb7.prdata87));

  assign spi_s07.sig_n_ss_in7 = n_ss_out7[0];
  assign spi_s07.sig_n_p_reset7 = hresetn7;
  assign spi_s07.sig_pclk7 = tb_hclk7;

  assign gpio_s07.n_p_reset7 = hresetn7;
  assign gpio_s07.pclk7 = tb_hclk7;

  assign hwdata_byte_alligned7 = (ahbi_m07.AHB_HADDR7[1:0] == 2'b00) ? ahbi_m07.AHB_HWDATA7 : {4{ahbi_m07.AHB_HWDATA7[7:0]}};

  apb_subsystem_07 i_apb_subsystem7 (
    // Inputs7
    // system signals7
    .hclk7              (tb_hclk7),     // AHB7 Clock7
    .n_hreset7          (hresetn7),     // AHB7 reset - Active7 low7
    .pclk7              (tb_hclk7),     // APB7 Clock7
    .n_preset7          (hresetn7),     // APB7 reset - Active7 low7
    
    // AHB7 interface for AHB2APM7 bridge7
    .hsel7     (1'b1),        // AHB2APB7 select7
    .haddr7             (ahbi_m07.AHB_HADDR7),        // Address bus
    .htrans7            (ahbi_m07.AHB_HTRANS7),       // Transfer7 type
    .hsize7             (ahbi_m07.AHB_HSIZE7),        // AHB7 Access type - byte half7-word7 word7
    .hwrite7            (ahbi_m07.AHB_HWRITE7),       // Write signal7
    .hwdata7            (hwdata_byte_alligned7),       // Write data
    .hready_in7         (hready7),       // Indicates7 that the last master7 has finished7 
                                       // its bus access
    .hburst7            (ahbi_m07.AHB_HBURST7),       // Burst type
    .hprot7             (ahbi_m07.AHB_HPROT7),        // Protection7 control7
    .hmaster7           (4'h0),      // Master7 select7
    .hmastlock7         (ahbi_m07.AHB_HLOCK7),  // Locked7 transfer7
    // AHB7 interface for SMC7
    .smc_hclk7          (1'b0),
    .smc_n_hclk7        (1'b1),
    .smc_haddr7         (32'd0),
    .smc_htrans7        (2'b00),
    .smc_hsel7          (1'b0),
    .smc_hwrite7        (1'b0),
    .smc_hsize7         (3'd0),
    .smc_hwdata7        (32'd0),
    .smc_hready_in7     (1'b1),
    .smc_hburst7        (3'b000),
    .smc_hprot7         (4'b0000),
    .smc_hmaster7       (4'b0000),
    .smc_hmastlock7     (1'b0),

    //interrupt7 from DMA7
    .DMA_irq7           (1'b0),      

    // Scan7 inputs7
    .scan_en7           (1'b0),         // Scan7 enable pin7
    .scan_in_17         (1'b0),         // Scan7 input for first chain7
    .scan_in_27         (1'b0),        // Scan7 input for second chain7
    .scan_mode7         (1'b0),
    //input for smc7
    .data_smc7          (32'd0),
    //inputs7 for uart7
    .ua_rxd7            (uart_s07.txd7),
    .ua_rxd17           (uart_s17.txd7),
    .ua_ncts7           (uart_s07.cts_n7),
    .ua_ncts17          (uart_s17.cts_n7),
    //inputs7 for spi7
    .n_ss_in7           (1'b1),
    .mi7                (spi_s07.sig_so7),
    .si7                (1'b0),
    .sclk_in7           (1'b0),
    //inputs7 for GPIO7
    .gpio_pin_in7       (gpio_s07.gpio_pin_in7[15:0]),
 
//interrupt7 from Enet7 MAC7
     .macb0_int7     (1'b0),
     .macb1_int7     (1'b0),
     .macb2_int7     (1'b0),
     .macb3_int7     (1'b0),

    // Scan7 outputs7
    .scan_out_17        (),             // Scan7 out for chain7 1
    .scan_out_27        (),             // Scan7 out for chain7 2
   
    //output from APB7 
    // AHB7 interface for AHB2APB7 bridge7
    .hrdata7            (hrdata7),       // Read data provided from target slave7
    .hready7            (hready7),       // Ready7 for new bus cycle from target slave7
    .hresp7             (hresp7),        // Response7 from the bridge7

    // AHB7 interface for SMC7
    .smc_hrdata7        (), 
    .smc_hready7        (),
    .smc_hresp7         (),
  
    //outputs7 from smc7
    .smc_n_ext_oe7      (),
    .smc_data7          (),
    .smc_addr7          (),
    .smc_n_be7          (),
    .smc_n_cs7          (), 
    .smc_n_we7          (),
    .smc_n_wr7          (),
    .smc_n_rd7          (),
    //outputs7 from uart7
    .ua_txd7             (uart_s07.rxd7),
    .ua_txd17            (uart_s17.rxd7),
    .ua_nrts7            (uart_s07.rts_n7),
    .ua_nrts17           (uart_s17.rts_n7),
    // outputs7 from ttc7
    .so                (),
    .mo7                (spi_s07.sig_si7),
    .sclk_out7          (spi_s07.sig_sclk_in7),
    .n_ss_out7          (n_ss_out7[7:0]),
    .n_so_en7           (),
    .n_mo_en7           (),
    .n_sclk_en7         (),
    .n_ss_en7           (),
    //outputs7 from gpio7
    .n_gpio_pin_oe7     (gpio_s07.n_gpio_pin_oe7[15:0]),
    .gpio_pin_out7      (gpio_s07.gpio_pin_out7[15:0]),

//unconnected7 o/p ports7
    .clk_SRPG_macb0_en7(),
    .clk_SRPG_macb1_en7(),
    .clk_SRPG_macb2_en7(),
    .clk_SRPG_macb3_en7(),
    .core06v7(),
    .core08v7(),
    .core10v7(),
    .core12v7(),
    .mte_smc_start7(),
    .mte_uart_start7(),
    .mte_smc_uart_start7(),
    .mte_pm_smc_to_default_start7(),
    .mte_pm_uart_to_default_start7(),
    .mte_pm_smc_uart_to_default_start7(),
    .pcm_irq7(),
    .ttc_irq7(),
    .gpio_irq7(),
    .uart0_irq7(),
    .uart1_irq7(),
    .spi_irq7(),

    .macb3_wakeup7(),
    .macb2_wakeup7(),
    .macb1_wakeup7(),
    .macb0_wakeup7()
);


initial
begin
  tb_hclk7 = 0;
  hresetn7 = 1;

  #1 hresetn7 = 0;
  #1200 hresetn7 = 1;
end

always #50 tb_hclk7 = ~tb_hclk7;

initial begin
  uvm_config_db#(virtual uart_if7)::set(null, "uvm_test_top.ve7.uart07*", "vif7", uart_s07);
  uvm_config_db#(virtual uart_if7)::set(null, "uvm_test_top.ve7.uart17*", "vif7", uart_s17);
  uvm_config_db#(virtual uart_ctrl_internal_if7)::set(null, "uvm_test_top.ve7.apb_ss_env7.apb_uart07.*", "vif7", uart_int07);
  uvm_config_db#(virtual uart_ctrl_internal_if7)::set(null, "uvm_test_top.ve7.apb_ss_env7.apb_uart17.*", "vif7", uart_int17);
  uvm_config_db#(virtual apb_if7)::set(null, "uvm_test_top.ve7.apb07*", "vif7", apbi_mo7);
  uvm_config_db#(virtual ahb_if7)::set(null, "uvm_test_top.ve7.ahb07*", "vif7", ahbi_m07);
  uvm_config_db#(virtual spi_if7)::set(null, "uvm_test_top.ve7.spi07*", "spi_if7", spi_s07);
  uvm_config_db#(virtual gpio_if7)::set(null, "uvm_test_top.ve7.gpio07*", "gpio_if7", gpio_s07);
  run_test();
end

endmodule
