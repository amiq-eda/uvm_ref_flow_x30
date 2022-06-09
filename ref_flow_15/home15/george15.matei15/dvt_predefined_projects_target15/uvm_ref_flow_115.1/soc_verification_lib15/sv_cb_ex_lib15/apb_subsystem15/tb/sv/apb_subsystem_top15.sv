/*-------------------------------------------------------------------------
File15 name   : apb_subsystem_top15.v 
Title15       : Top15 level file for the testbench 
Project15     : APB15 Subsystem15
Created15     : March15 2008
Description15 : This15 is top level file which instantiate15 the dut15 apb_subsyste15,.v.
              It also has the assertion15 module which checks15 for the power15 down 
              and power15 up.To15 activate15 the assertion15 ifdef LP_ABV_ON15 is used.       
Notes15       :
-------------------------------------------------------------------------*/ 
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------

 `timescale 1ns/10ps


// Environment15 Constants15
`ifndef AHB_DATA_WIDTH15
  `define AHB_DATA_WIDTH15          32              // AHB15 bus data width [32/64]
`endif
`ifndef AHB_ADDR_WIDTH15
  `define AHB_ADDR_WIDTH15          32              // AHB15 bus address width [32/64]
`endif
`ifndef AHB_DATA_MAX_BIT15
  `define AHB_DATA_MAX_BIT15        31              // MUST15 BE15: AHB_DATA_WIDTH15 - 1
`endif
`ifndef AHB_ADDRESS_MAX_BIT15
  `define AHB_ADDRESS_MAX_BIT15     31              // MUST15 BE15: AHB_ADDR_WIDTH15 - 1
`endif
`ifndef DEFAULT_HREADY_VALUE15
  `define DEFAULT_HREADY_VALUE15    1'b1            // Ready15 Asserted15
`endif

`include "ahb_if15.sv"
`include "apb_if15.sv"
`include "apb_master_if15.sv"
`include "apb_slave_if15.sv"
`include "uart_if15.sv"
`include "spi_if15.sv"
`include "gpio_if15.sv"
`include "coverage15/uart_ctrl_internal_if15.sv"

module apb_subsystem_top15;
  import uvm_pkg::*;
  // Import15 the UVM Utilities15 Package15

  import ahb_pkg15::*;
  import apb_pkg15::*;
  import uart_pkg15::*;
  import gpio_pkg15::*;
  import spi_pkg15::*;
  import uart_ctrl_pkg15::*;
  import apb_subsystem_pkg15::*;

  `include "spi_reg_model15.sv"
  `include "gpio_reg_model15.sv"
  `include "apb_subsystem_reg_rdb15.sv"
  `include "uart_ctrl_reg_seq_lib15.sv"
  `include "spi_reg_seq_lib15.sv"
  `include "gpio_reg_seq_lib15.sv"

  //Include15 module UVC15 sequences
  `include "ahb_user_monitor15.sv"
  `include "apb_subsystem_seq_lib15.sv"
  `include "apb_subsystem_vir_sequencer15.sv"
  `include "apb_subsystem_vir_seq_lib15.sv"

  `include "apb_subsystem_tb15.sv"
  `include "test_lib15.sv"
   
  
   // ====================================
   // SHARED15 signals15
   // ====================================
   
   // clock15
   reg tb_hclk15;
   
   // reset
   reg hresetn15;
   
   // post15-mux15 from master15 mux15
   wire [`AHB_DATA_MAX_BIT15:0] hwdata15;
   wire [`AHB_ADDRESS_MAX_BIT15:0] haddr15;
   wire [1:0]  htrans15;
   wire [2:0]  hburst15;
   wire [2:0]  hsize15;
   wire [3:0]  hprot15;
   wire hwrite15;

   // post15-mux15 from slave15 mux15
   wire        hready15;
   wire [1:0]  hresp15;
   wire [`AHB_DATA_MAX_BIT15:0] hrdata15;
  

  //  Specific15 signals15 of apb15 subsystem15
  reg         ua_rxd15;
  reg         ua_ncts15;


  // uart15 outputs15 
  wire        ua_txd15;
  wire        us_nrts15;

  wire   [7:0] n_ss_out15;    // peripheral15 select15 lines15 from master15
  wire   [31:0] hwdata_byte_alligned15;

  reg [2:0] div8_clk15;
 always @(posedge tb_hclk15) begin
   if (!hresetn15)
     div8_clk15 = 3'b000;
   else
     div8_clk15 = div8_clk15 + 1;
 end


  // Master15 virtual interface
  ahb_if15 ahbi_m015(.ahb_clock15(tb_hclk15), .ahb_resetn15(hresetn15));
  
  uart_if15 uart_s015(.clock15(div8_clk15[2]), .reset(hresetn15));
  uart_if15 uart_s115(.clock15(div8_clk15[2]), .reset(hresetn15));
  spi_if15 spi_s015();
  gpio_if15 gpio_s015();
  uart_ctrl_internal_if15 uart_int015(.clock15(div8_clk15[2]));
  uart_ctrl_internal_if15 uart_int115(.clock15(div8_clk15[2]));

  apb_if15 apbi_mo15(.pclock15(tb_hclk15), .preset15(hresetn15));

  //M015
  assign ahbi_m015.AHB_HCLK15 = tb_hclk15;
  assign ahbi_m015.AHB_HRESET15 = hresetn15;
  assign ahbi_m015.AHB_HRESP15 = hresp15;
  assign ahbi_m015.AHB_HRDATA15 = hrdata15;
  assign ahbi_m015.AHB_HREADY15 = hready15;

  assign apbi_mo15.paddr15 = i_apb_subsystem15.i_ahb2apb15.paddr15;
  assign apbi_mo15.prwd15 = i_apb_subsystem15.i_ahb2apb15.pwrite15;
  assign apbi_mo15.pwdata15 = i_apb_subsystem15.i_ahb2apb15.pwdata15;
  assign apbi_mo15.penable15 = i_apb_subsystem15.i_ahb2apb15.penable15;
  assign apbi_mo15.psel15 = {12'b0, i_apb_subsystem15.i_ahb2apb15.psel815, i_apb_subsystem15.i_ahb2apb15.psel215, i_apb_subsystem15.i_ahb2apb15.psel115, i_apb_subsystem15.i_ahb2apb15.psel015};
  assign apbi_mo15.prdata15 = i_apb_subsystem15.i_ahb2apb15.psel015? i_apb_subsystem15.i_ahb2apb15.prdata015 : (i_apb_subsystem15.i_ahb2apb15.psel115? i_apb_subsystem15.i_ahb2apb15.prdata115 : (i_apb_subsystem15.i_ahb2apb15.psel215? i_apb_subsystem15.i_ahb2apb15.prdata215 : i_apb_subsystem15.i_ahb2apb15.prdata815));

  assign spi_s015.sig_n_ss_in15 = n_ss_out15[0];
  assign spi_s015.sig_n_p_reset15 = hresetn15;
  assign spi_s015.sig_pclk15 = tb_hclk15;

  assign gpio_s015.n_p_reset15 = hresetn15;
  assign gpio_s015.pclk15 = tb_hclk15;

  assign hwdata_byte_alligned15 = (ahbi_m015.AHB_HADDR15[1:0] == 2'b00) ? ahbi_m015.AHB_HWDATA15 : {4{ahbi_m015.AHB_HWDATA15[7:0]}};

  apb_subsystem_015 i_apb_subsystem15 (
    // Inputs15
    // system signals15
    .hclk15              (tb_hclk15),     // AHB15 Clock15
    .n_hreset15          (hresetn15),     // AHB15 reset - Active15 low15
    .pclk15              (tb_hclk15),     // APB15 Clock15
    .n_preset15          (hresetn15),     // APB15 reset - Active15 low15
    
    // AHB15 interface for AHB2APM15 bridge15
    .hsel15     (1'b1),        // AHB2APB15 select15
    .haddr15             (ahbi_m015.AHB_HADDR15),        // Address bus
    .htrans15            (ahbi_m015.AHB_HTRANS15),       // Transfer15 type
    .hsize15             (ahbi_m015.AHB_HSIZE15),        // AHB15 Access type - byte half15-word15 word15
    .hwrite15            (ahbi_m015.AHB_HWRITE15),       // Write signal15
    .hwdata15            (hwdata_byte_alligned15),       // Write data
    .hready_in15         (hready15),       // Indicates15 that the last master15 has finished15 
                                       // its bus access
    .hburst15            (ahbi_m015.AHB_HBURST15),       // Burst type
    .hprot15             (ahbi_m015.AHB_HPROT15),        // Protection15 control15
    .hmaster15           (4'h0),      // Master15 select15
    .hmastlock15         (ahbi_m015.AHB_HLOCK15),  // Locked15 transfer15
    // AHB15 interface for SMC15
    .smc_hclk15          (1'b0),
    .smc_n_hclk15        (1'b1),
    .smc_haddr15         (32'd0),
    .smc_htrans15        (2'b00),
    .smc_hsel15          (1'b0),
    .smc_hwrite15        (1'b0),
    .smc_hsize15         (3'd0),
    .smc_hwdata15        (32'd0),
    .smc_hready_in15     (1'b1),
    .smc_hburst15        (3'b000),
    .smc_hprot15         (4'b0000),
    .smc_hmaster15       (4'b0000),
    .smc_hmastlock15     (1'b0),

    //interrupt15 from DMA15
    .DMA_irq15           (1'b0),      

    // Scan15 inputs15
    .scan_en15           (1'b0),         // Scan15 enable pin15
    .scan_in_115         (1'b0),         // Scan15 input for first chain15
    .scan_in_215         (1'b0),        // Scan15 input for second chain15
    .scan_mode15         (1'b0),
    //input for smc15
    .data_smc15          (32'd0),
    //inputs15 for uart15
    .ua_rxd15            (uart_s015.txd15),
    .ua_rxd115           (uart_s115.txd15),
    .ua_ncts15           (uart_s015.cts_n15),
    .ua_ncts115          (uart_s115.cts_n15),
    //inputs15 for spi15
    .n_ss_in15           (1'b1),
    .mi15                (spi_s015.sig_so15),
    .si15                (1'b0),
    .sclk_in15           (1'b0),
    //inputs15 for GPIO15
    .gpio_pin_in15       (gpio_s015.gpio_pin_in15[15:0]),
 
//interrupt15 from Enet15 MAC15
     .macb0_int15     (1'b0),
     .macb1_int15     (1'b0),
     .macb2_int15     (1'b0),
     .macb3_int15     (1'b0),

    // Scan15 outputs15
    .scan_out_115        (),             // Scan15 out for chain15 1
    .scan_out_215        (),             // Scan15 out for chain15 2
   
    //output from APB15 
    // AHB15 interface for AHB2APB15 bridge15
    .hrdata15            (hrdata15),       // Read data provided from target slave15
    .hready15            (hready15),       // Ready15 for new bus cycle from target slave15
    .hresp15             (hresp15),        // Response15 from the bridge15

    // AHB15 interface for SMC15
    .smc_hrdata15        (), 
    .smc_hready15        (),
    .smc_hresp15         (),
  
    //outputs15 from smc15
    .smc_n_ext_oe15      (),
    .smc_data15          (),
    .smc_addr15          (),
    .smc_n_be15          (),
    .smc_n_cs15          (), 
    .smc_n_we15          (),
    .smc_n_wr15          (),
    .smc_n_rd15          (),
    //outputs15 from uart15
    .ua_txd15             (uart_s015.rxd15),
    .ua_txd115            (uart_s115.rxd15),
    .ua_nrts15            (uart_s015.rts_n15),
    .ua_nrts115           (uart_s115.rts_n15),
    // outputs15 from ttc15
    .so                (),
    .mo15                (spi_s015.sig_si15),
    .sclk_out15          (spi_s015.sig_sclk_in15),
    .n_ss_out15          (n_ss_out15[7:0]),
    .n_so_en15           (),
    .n_mo_en15           (),
    .n_sclk_en15         (),
    .n_ss_en15           (),
    //outputs15 from gpio15
    .n_gpio_pin_oe15     (gpio_s015.n_gpio_pin_oe15[15:0]),
    .gpio_pin_out15      (gpio_s015.gpio_pin_out15[15:0]),

//unconnected15 o/p ports15
    .clk_SRPG_macb0_en15(),
    .clk_SRPG_macb1_en15(),
    .clk_SRPG_macb2_en15(),
    .clk_SRPG_macb3_en15(),
    .core06v15(),
    .core08v15(),
    .core10v15(),
    .core12v15(),
    .mte_smc_start15(),
    .mte_uart_start15(),
    .mte_smc_uart_start15(),
    .mte_pm_smc_to_default_start15(),
    .mte_pm_uart_to_default_start15(),
    .mte_pm_smc_uart_to_default_start15(),
    .pcm_irq15(),
    .ttc_irq15(),
    .gpio_irq15(),
    .uart0_irq15(),
    .uart1_irq15(),
    .spi_irq15(),

    .macb3_wakeup15(),
    .macb2_wakeup15(),
    .macb1_wakeup15(),
    .macb0_wakeup15()
);


initial
begin
  tb_hclk15 = 0;
  hresetn15 = 1;

  #1 hresetn15 = 0;
  #1200 hresetn15 = 1;
end

always #50 tb_hclk15 = ~tb_hclk15;

initial begin
  uvm_config_db#(virtual uart_if15)::set(null, "uvm_test_top.ve15.uart015*", "vif15", uart_s015);
  uvm_config_db#(virtual uart_if15)::set(null, "uvm_test_top.ve15.uart115*", "vif15", uart_s115);
  uvm_config_db#(virtual uart_ctrl_internal_if15)::set(null, "uvm_test_top.ve15.apb_ss_env15.apb_uart015.*", "vif15", uart_int015);
  uvm_config_db#(virtual uart_ctrl_internal_if15)::set(null, "uvm_test_top.ve15.apb_ss_env15.apb_uart115.*", "vif15", uart_int115);
  uvm_config_db#(virtual apb_if15)::set(null, "uvm_test_top.ve15.apb015*", "vif15", apbi_mo15);
  uvm_config_db#(virtual ahb_if15)::set(null, "uvm_test_top.ve15.ahb015*", "vif15", ahbi_m015);
  uvm_config_db#(virtual spi_if15)::set(null, "uvm_test_top.ve15.spi015*", "spi_if15", spi_s015);
  uvm_config_db#(virtual gpio_if15)::set(null, "uvm_test_top.ve15.gpio015*", "gpio_if15", gpio_s015);
  run_test();
end

endmodule
