/*-------------------------------------------------------------------------
File29 name   : apb_subsystem_top29.v 
Title29       : Top29 level file for the testbench 
Project29     : APB29 Subsystem29
Created29     : March29 2008
Description29 : This29 is top level file which instantiate29 the dut29 apb_subsyste29,.v.
              It also has the assertion29 module which checks29 for the power29 down 
              and power29 up.To29 activate29 the assertion29 ifdef LP_ABV_ON29 is used.       
Notes29       :
-------------------------------------------------------------------------*/ 
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------

 `timescale 1ns/10ps


// Environment29 Constants29
`ifndef AHB_DATA_WIDTH29
  `define AHB_DATA_WIDTH29          32              // AHB29 bus data width [32/64]
`endif
`ifndef AHB_ADDR_WIDTH29
  `define AHB_ADDR_WIDTH29          32              // AHB29 bus address width [32/64]
`endif
`ifndef AHB_DATA_MAX_BIT29
  `define AHB_DATA_MAX_BIT29        31              // MUST29 BE29: AHB_DATA_WIDTH29 - 1
`endif
`ifndef AHB_ADDRESS_MAX_BIT29
  `define AHB_ADDRESS_MAX_BIT29     31              // MUST29 BE29: AHB_ADDR_WIDTH29 - 1
`endif
`ifndef DEFAULT_HREADY_VALUE29
  `define DEFAULT_HREADY_VALUE29    1'b1            // Ready29 Asserted29
`endif

`include "ahb_if29.sv"
`include "apb_if29.sv"
`include "apb_master_if29.sv"
`include "apb_slave_if29.sv"
`include "uart_if29.sv"
`include "spi_if29.sv"
`include "gpio_if29.sv"
`include "coverage29/uart_ctrl_internal_if29.sv"

module apb_subsystem_top29;
  import uvm_pkg::*;
  // Import29 the UVM Utilities29 Package29

  import ahb_pkg29::*;
  import apb_pkg29::*;
  import uart_pkg29::*;
  import gpio_pkg29::*;
  import spi_pkg29::*;
  import uart_ctrl_pkg29::*;
  import apb_subsystem_pkg29::*;

  `include "spi_reg_model29.sv"
  `include "gpio_reg_model29.sv"
  `include "apb_subsystem_reg_rdb29.sv"
  `include "uart_ctrl_reg_seq_lib29.sv"
  `include "spi_reg_seq_lib29.sv"
  `include "gpio_reg_seq_lib29.sv"

  //Include29 module UVC29 sequences
  `include "ahb_user_monitor29.sv"
  `include "apb_subsystem_seq_lib29.sv"
  `include "apb_subsystem_vir_sequencer29.sv"
  `include "apb_subsystem_vir_seq_lib29.sv"

  `include "apb_subsystem_tb29.sv"
  `include "test_lib29.sv"
   
  
   // ====================================
   // SHARED29 signals29
   // ====================================
   
   // clock29
   reg tb_hclk29;
   
   // reset
   reg hresetn29;
   
   // post29-mux29 from master29 mux29
   wire [`AHB_DATA_MAX_BIT29:0] hwdata29;
   wire [`AHB_ADDRESS_MAX_BIT29:0] haddr29;
   wire [1:0]  htrans29;
   wire [2:0]  hburst29;
   wire [2:0]  hsize29;
   wire [3:0]  hprot29;
   wire hwrite29;

   // post29-mux29 from slave29 mux29
   wire        hready29;
   wire [1:0]  hresp29;
   wire [`AHB_DATA_MAX_BIT29:0] hrdata29;
  

  //  Specific29 signals29 of apb29 subsystem29
  reg         ua_rxd29;
  reg         ua_ncts29;


  // uart29 outputs29 
  wire        ua_txd29;
  wire        us_nrts29;

  wire   [7:0] n_ss_out29;    // peripheral29 select29 lines29 from master29
  wire   [31:0] hwdata_byte_alligned29;

  reg [2:0] div8_clk29;
 always @(posedge tb_hclk29) begin
   if (!hresetn29)
     div8_clk29 = 3'b000;
   else
     div8_clk29 = div8_clk29 + 1;
 end


  // Master29 virtual interface
  ahb_if29 ahbi_m029(.ahb_clock29(tb_hclk29), .ahb_resetn29(hresetn29));
  
  uart_if29 uart_s029(.clock29(div8_clk29[2]), .reset(hresetn29));
  uart_if29 uart_s129(.clock29(div8_clk29[2]), .reset(hresetn29));
  spi_if29 spi_s029();
  gpio_if29 gpio_s029();
  uart_ctrl_internal_if29 uart_int029(.clock29(div8_clk29[2]));
  uart_ctrl_internal_if29 uart_int129(.clock29(div8_clk29[2]));

  apb_if29 apbi_mo29(.pclock29(tb_hclk29), .preset29(hresetn29));

  //M029
  assign ahbi_m029.AHB_HCLK29 = tb_hclk29;
  assign ahbi_m029.AHB_HRESET29 = hresetn29;
  assign ahbi_m029.AHB_HRESP29 = hresp29;
  assign ahbi_m029.AHB_HRDATA29 = hrdata29;
  assign ahbi_m029.AHB_HREADY29 = hready29;

  assign apbi_mo29.paddr29 = i_apb_subsystem29.i_ahb2apb29.paddr29;
  assign apbi_mo29.prwd29 = i_apb_subsystem29.i_ahb2apb29.pwrite29;
  assign apbi_mo29.pwdata29 = i_apb_subsystem29.i_ahb2apb29.pwdata29;
  assign apbi_mo29.penable29 = i_apb_subsystem29.i_ahb2apb29.penable29;
  assign apbi_mo29.psel29 = {12'b0, i_apb_subsystem29.i_ahb2apb29.psel829, i_apb_subsystem29.i_ahb2apb29.psel229, i_apb_subsystem29.i_ahb2apb29.psel129, i_apb_subsystem29.i_ahb2apb29.psel029};
  assign apbi_mo29.prdata29 = i_apb_subsystem29.i_ahb2apb29.psel029? i_apb_subsystem29.i_ahb2apb29.prdata029 : (i_apb_subsystem29.i_ahb2apb29.psel129? i_apb_subsystem29.i_ahb2apb29.prdata129 : (i_apb_subsystem29.i_ahb2apb29.psel229? i_apb_subsystem29.i_ahb2apb29.prdata229 : i_apb_subsystem29.i_ahb2apb29.prdata829));

  assign spi_s029.sig_n_ss_in29 = n_ss_out29[0];
  assign spi_s029.sig_n_p_reset29 = hresetn29;
  assign spi_s029.sig_pclk29 = tb_hclk29;

  assign gpio_s029.n_p_reset29 = hresetn29;
  assign gpio_s029.pclk29 = tb_hclk29;

  assign hwdata_byte_alligned29 = (ahbi_m029.AHB_HADDR29[1:0] == 2'b00) ? ahbi_m029.AHB_HWDATA29 : {4{ahbi_m029.AHB_HWDATA29[7:0]}};

  apb_subsystem_029 i_apb_subsystem29 (
    // Inputs29
    // system signals29
    .hclk29              (tb_hclk29),     // AHB29 Clock29
    .n_hreset29          (hresetn29),     // AHB29 reset - Active29 low29
    .pclk29              (tb_hclk29),     // APB29 Clock29
    .n_preset29          (hresetn29),     // APB29 reset - Active29 low29
    
    // AHB29 interface for AHB2APM29 bridge29
    .hsel29     (1'b1),        // AHB2APB29 select29
    .haddr29             (ahbi_m029.AHB_HADDR29),        // Address bus
    .htrans29            (ahbi_m029.AHB_HTRANS29),       // Transfer29 type
    .hsize29             (ahbi_m029.AHB_HSIZE29),        // AHB29 Access type - byte half29-word29 word29
    .hwrite29            (ahbi_m029.AHB_HWRITE29),       // Write signal29
    .hwdata29            (hwdata_byte_alligned29),       // Write data
    .hready_in29         (hready29),       // Indicates29 that the last master29 has finished29 
                                       // its bus access
    .hburst29            (ahbi_m029.AHB_HBURST29),       // Burst type
    .hprot29             (ahbi_m029.AHB_HPROT29),        // Protection29 control29
    .hmaster29           (4'h0),      // Master29 select29
    .hmastlock29         (ahbi_m029.AHB_HLOCK29),  // Locked29 transfer29
    // AHB29 interface for SMC29
    .smc_hclk29          (1'b0),
    .smc_n_hclk29        (1'b1),
    .smc_haddr29         (32'd0),
    .smc_htrans29        (2'b00),
    .smc_hsel29          (1'b0),
    .smc_hwrite29        (1'b0),
    .smc_hsize29         (3'd0),
    .smc_hwdata29        (32'd0),
    .smc_hready_in29     (1'b1),
    .smc_hburst29        (3'b000),
    .smc_hprot29         (4'b0000),
    .smc_hmaster29       (4'b0000),
    .smc_hmastlock29     (1'b0),

    //interrupt29 from DMA29
    .DMA_irq29           (1'b0),      

    // Scan29 inputs29
    .scan_en29           (1'b0),         // Scan29 enable pin29
    .scan_in_129         (1'b0),         // Scan29 input for first chain29
    .scan_in_229         (1'b0),        // Scan29 input for second chain29
    .scan_mode29         (1'b0),
    //input for smc29
    .data_smc29          (32'd0),
    //inputs29 for uart29
    .ua_rxd29            (uart_s029.txd29),
    .ua_rxd129           (uart_s129.txd29),
    .ua_ncts29           (uart_s029.cts_n29),
    .ua_ncts129          (uart_s129.cts_n29),
    //inputs29 for spi29
    .n_ss_in29           (1'b1),
    .mi29                (spi_s029.sig_so29),
    .si29                (1'b0),
    .sclk_in29           (1'b0),
    //inputs29 for GPIO29
    .gpio_pin_in29       (gpio_s029.gpio_pin_in29[15:0]),
 
//interrupt29 from Enet29 MAC29
     .macb0_int29     (1'b0),
     .macb1_int29     (1'b0),
     .macb2_int29     (1'b0),
     .macb3_int29     (1'b0),

    // Scan29 outputs29
    .scan_out_129        (),             // Scan29 out for chain29 1
    .scan_out_229        (),             // Scan29 out for chain29 2
   
    //output from APB29 
    // AHB29 interface for AHB2APB29 bridge29
    .hrdata29            (hrdata29),       // Read data provided from target slave29
    .hready29            (hready29),       // Ready29 for new bus cycle from target slave29
    .hresp29             (hresp29),        // Response29 from the bridge29

    // AHB29 interface for SMC29
    .smc_hrdata29        (), 
    .smc_hready29        (),
    .smc_hresp29         (),
  
    //outputs29 from smc29
    .smc_n_ext_oe29      (),
    .smc_data29          (),
    .smc_addr29          (),
    .smc_n_be29          (),
    .smc_n_cs29          (), 
    .smc_n_we29          (),
    .smc_n_wr29          (),
    .smc_n_rd29          (),
    //outputs29 from uart29
    .ua_txd29             (uart_s029.rxd29),
    .ua_txd129            (uart_s129.rxd29),
    .ua_nrts29            (uart_s029.rts_n29),
    .ua_nrts129           (uart_s129.rts_n29),
    // outputs29 from ttc29
    .so                (),
    .mo29                (spi_s029.sig_si29),
    .sclk_out29          (spi_s029.sig_sclk_in29),
    .n_ss_out29          (n_ss_out29[7:0]),
    .n_so_en29           (),
    .n_mo_en29           (),
    .n_sclk_en29         (),
    .n_ss_en29           (),
    //outputs29 from gpio29
    .n_gpio_pin_oe29     (gpio_s029.n_gpio_pin_oe29[15:0]),
    .gpio_pin_out29      (gpio_s029.gpio_pin_out29[15:0]),

//unconnected29 o/p ports29
    .clk_SRPG_macb0_en29(),
    .clk_SRPG_macb1_en29(),
    .clk_SRPG_macb2_en29(),
    .clk_SRPG_macb3_en29(),
    .core06v29(),
    .core08v29(),
    .core10v29(),
    .core12v29(),
    .mte_smc_start29(),
    .mte_uart_start29(),
    .mte_smc_uart_start29(),
    .mte_pm_smc_to_default_start29(),
    .mte_pm_uart_to_default_start29(),
    .mte_pm_smc_uart_to_default_start29(),
    .pcm_irq29(),
    .ttc_irq29(),
    .gpio_irq29(),
    .uart0_irq29(),
    .uart1_irq29(),
    .spi_irq29(),

    .macb3_wakeup29(),
    .macb2_wakeup29(),
    .macb1_wakeup29(),
    .macb0_wakeup29()
);


initial
begin
  tb_hclk29 = 0;
  hresetn29 = 1;

  #1 hresetn29 = 0;
  #1200 hresetn29 = 1;
end

always #50 tb_hclk29 = ~tb_hclk29;

initial begin
  uvm_config_db#(virtual uart_if29)::set(null, "uvm_test_top.ve29.uart029*", "vif29", uart_s029);
  uvm_config_db#(virtual uart_if29)::set(null, "uvm_test_top.ve29.uart129*", "vif29", uart_s129);
  uvm_config_db#(virtual uart_ctrl_internal_if29)::set(null, "uvm_test_top.ve29.apb_ss_env29.apb_uart029.*", "vif29", uart_int029);
  uvm_config_db#(virtual uart_ctrl_internal_if29)::set(null, "uvm_test_top.ve29.apb_ss_env29.apb_uart129.*", "vif29", uart_int129);
  uvm_config_db#(virtual apb_if29)::set(null, "uvm_test_top.ve29.apb029*", "vif29", apbi_mo29);
  uvm_config_db#(virtual ahb_if29)::set(null, "uvm_test_top.ve29.ahb029*", "vif29", ahbi_m029);
  uvm_config_db#(virtual spi_if29)::set(null, "uvm_test_top.ve29.spi029*", "spi_if29", spi_s029);
  uvm_config_db#(virtual gpio_if29)::set(null, "uvm_test_top.ve29.gpio029*", "gpio_if29", gpio_s029);
  run_test();
end

endmodule
