/*-------------------------------------------------------------------------
File6 name   : apb_subsystem_top6.v 
Title6       : Top6 level file for the testbench 
Project6     : APB6 Subsystem6
Created6     : March6 2008
Description6 : This6 is top level file which instantiate6 the dut6 apb_subsyste6,.v.
              It also has the assertion6 module which checks6 for the power6 down 
              and power6 up.To6 activate6 the assertion6 ifdef LP_ABV_ON6 is used.       
Notes6       :
-------------------------------------------------------------------------*/ 
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------

 `timescale 1ns/10ps


// Environment6 Constants6
`ifndef AHB_DATA_WIDTH6
  `define AHB_DATA_WIDTH6          32              // AHB6 bus data width [32/64]
`endif
`ifndef AHB_ADDR_WIDTH6
  `define AHB_ADDR_WIDTH6          32              // AHB6 bus address width [32/64]
`endif
`ifndef AHB_DATA_MAX_BIT6
  `define AHB_DATA_MAX_BIT6        31              // MUST6 BE6: AHB_DATA_WIDTH6 - 1
`endif
`ifndef AHB_ADDRESS_MAX_BIT6
  `define AHB_ADDRESS_MAX_BIT6     31              // MUST6 BE6: AHB_ADDR_WIDTH6 - 1
`endif
`ifndef DEFAULT_HREADY_VALUE6
  `define DEFAULT_HREADY_VALUE6    1'b1            // Ready6 Asserted6
`endif

`include "ahb_if6.sv"
`include "apb_if6.sv"
`include "apb_master_if6.sv"
`include "apb_slave_if6.sv"
`include "uart_if6.sv"
`include "spi_if6.sv"
`include "gpio_if6.sv"
`include "coverage6/uart_ctrl_internal_if6.sv"

module apb_subsystem_top6;
  import uvm_pkg::*;
  // Import6 the UVM Utilities6 Package6

  import ahb_pkg6::*;
  import apb_pkg6::*;
  import uart_pkg6::*;
  import gpio_pkg6::*;
  import spi_pkg6::*;
  import uart_ctrl_pkg6::*;
  import apb_subsystem_pkg6::*;

  `include "spi_reg_model6.sv"
  `include "gpio_reg_model6.sv"
  `include "apb_subsystem_reg_rdb6.sv"
  `include "uart_ctrl_reg_seq_lib6.sv"
  `include "spi_reg_seq_lib6.sv"
  `include "gpio_reg_seq_lib6.sv"

  //Include6 module UVC6 sequences
  `include "ahb_user_monitor6.sv"
  `include "apb_subsystem_seq_lib6.sv"
  `include "apb_subsystem_vir_sequencer6.sv"
  `include "apb_subsystem_vir_seq_lib6.sv"

  `include "apb_subsystem_tb6.sv"
  `include "test_lib6.sv"
   
  
   // ====================================
   // SHARED6 signals6
   // ====================================
   
   // clock6
   reg tb_hclk6;
   
   // reset
   reg hresetn6;
   
   // post6-mux6 from master6 mux6
   wire [`AHB_DATA_MAX_BIT6:0] hwdata6;
   wire [`AHB_ADDRESS_MAX_BIT6:0] haddr6;
   wire [1:0]  htrans6;
   wire [2:0]  hburst6;
   wire [2:0]  hsize6;
   wire [3:0]  hprot6;
   wire hwrite6;

   // post6-mux6 from slave6 mux6
   wire        hready6;
   wire [1:0]  hresp6;
   wire [`AHB_DATA_MAX_BIT6:0] hrdata6;
  

  //  Specific6 signals6 of apb6 subsystem6
  reg         ua_rxd6;
  reg         ua_ncts6;


  // uart6 outputs6 
  wire        ua_txd6;
  wire        us_nrts6;

  wire   [7:0] n_ss_out6;    // peripheral6 select6 lines6 from master6
  wire   [31:0] hwdata_byte_alligned6;

  reg [2:0] div8_clk6;
 always @(posedge tb_hclk6) begin
   if (!hresetn6)
     div8_clk6 = 3'b000;
   else
     div8_clk6 = div8_clk6 + 1;
 end


  // Master6 virtual interface
  ahb_if6 ahbi_m06(.ahb_clock6(tb_hclk6), .ahb_resetn6(hresetn6));
  
  uart_if6 uart_s06(.clock6(div8_clk6[2]), .reset(hresetn6));
  uart_if6 uart_s16(.clock6(div8_clk6[2]), .reset(hresetn6));
  spi_if6 spi_s06();
  gpio_if6 gpio_s06();
  uart_ctrl_internal_if6 uart_int06(.clock6(div8_clk6[2]));
  uart_ctrl_internal_if6 uart_int16(.clock6(div8_clk6[2]));

  apb_if6 apbi_mo6(.pclock6(tb_hclk6), .preset6(hresetn6));

  //M06
  assign ahbi_m06.AHB_HCLK6 = tb_hclk6;
  assign ahbi_m06.AHB_HRESET6 = hresetn6;
  assign ahbi_m06.AHB_HRESP6 = hresp6;
  assign ahbi_m06.AHB_HRDATA6 = hrdata6;
  assign ahbi_m06.AHB_HREADY6 = hready6;

  assign apbi_mo6.paddr6 = i_apb_subsystem6.i_ahb2apb6.paddr6;
  assign apbi_mo6.prwd6 = i_apb_subsystem6.i_ahb2apb6.pwrite6;
  assign apbi_mo6.pwdata6 = i_apb_subsystem6.i_ahb2apb6.pwdata6;
  assign apbi_mo6.penable6 = i_apb_subsystem6.i_ahb2apb6.penable6;
  assign apbi_mo6.psel6 = {12'b0, i_apb_subsystem6.i_ahb2apb6.psel86, i_apb_subsystem6.i_ahb2apb6.psel26, i_apb_subsystem6.i_ahb2apb6.psel16, i_apb_subsystem6.i_ahb2apb6.psel06};
  assign apbi_mo6.prdata6 = i_apb_subsystem6.i_ahb2apb6.psel06? i_apb_subsystem6.i_ahb2apb6.prdata06 : (i_apb_subsystem6.i_ahb2apb6.psel16? i_apb_subsystem6.i_ahb2apb6.prdata16 : (i_apb_subsystem6.i_ahb2apb6.psel26? i_apb_subsystem6.i_ahb2apb6.prdata26 : i_apb_subsystem6.i_ahb2apb6.prdata86));

  assign spi_s06.sig_n_ss_in6 = n_ss_out6[0];
  assign spi_s06.sig_n_p_reset6 = hresetn6;
  assign spi_s06.sig_pclk6 = tb_hclk6;

  assign gpio_s06.n_p_reset6 = hresetn6;
  assign gpio_s06.pclk6 = tb_hclk6;

  assign hwdata_byte_alligned6 = (ahbi_m06.AHB_HADDR6[1:0] == 2'b00) ? ahbi_m06.AHB_HWDATA6 : {4{ahbi_m06.AHB_HWDATA6[7:0]}};

  apb_subsystem_06 i_apb_subsystem6 (
    // Inputs6
    // system signals6
    .hclk6              (tb_hclk6),     // AHB6 Clock6
    .n_hreset6          (hresetn6),     // AHB6 reset - Active6 low6
    .pclk6              (tb_hclk6),     // APB6 Clock6
    .n_preset6          (hresetn6),     // APB6 reset - Active6 low6
    
    // AHB6 interface for AHB2APM6 bridge6
    .hsel6     (1'b1),        // AHB2APB6 select6
    .haddr6             (ahbi_m06.AHB_HADDR6),        // Address bus
    .htrans6            (ahbi_m06.AHB_HTRANS6),       // Transfer6 type
    .hsize6             (ahbi_m06.AHB_HSIZE6),        // AHB6 Access type - byte half6-word6 word6
    .hwrite6            (ahbi_m06.AHB_HWRITE6),       // Write signal6
    .hwdata6            (hwdata_byte_alligned6),       // Write data
    .hready_in6         (hready6),       // Indicates6 that the last master6 has finished6 
                                       // its bus access
    .hburst6            (ahbi_m06.AHB_HBURST6),       // Burst type
    .hprot6             (ahbi_m06.AHB_HPROT6),        // Protection6 control6
    .hmaster6           (4'h0),      // Master6 select6
    .hmastlock6         (ahbi_m06.AHB_HLOCK6),  // Locked6 transfer6
    // AHB6 interface for SMC6
    .smc_hclk6          (1'b0),
    .smc_n_hclk6        (1'b1),
    .smc_haddr6         (32'd0),
    .smc_htrans6        (2'b00),
    .smc_hsel6          (1'b0),
    .smc_hwrite6        (1'b0),
    .smc_hsize6         (3'd0),
    .smc_hwdata6        (32'd0),
    .smc_hready_in6     (1'b1),
    .smc_hburst6        (3'b000),
    .smc_hprot6         (4'b0000),
    .smc_hmaster6       (4'b0000),
    .smc_hmastlock6     (1'b0),

    //interrupt6 from DMA6
    .DMA_irq6           (1'b0),      

    // Scan6 inputs6
    .scan_en6           (1'b0),         // Scan6 enable pin6
    .scan_in_16         (1'b0),         // Scan6 input for first chain6
    .scan_in_26         (1'b0),        // Scan6 input for second chain6
    .scan_mode6         (1'b0),
    //input for smc6
    .data_smc6          (32'd0),
    //inputs6 for uart6
    .ua_rxd6            (uart_s06.txd6),
    .ua_rxd16           (uart_s16.txd6),
    .ua_ncts6           (uart_s06.cts_n6),
    .ua_ncts16          (uart_s16.cts_n6),
    //inputs6 for spi6
    .n_ss_in6           (1'b1),
    .mi6                (spi_s06.sig_so6),
    .si6                (1'b0),
    .sclk_in6           (1'b0),
    //inputs6 for GPIO6
    .gpio_pin_in6       (gpio_s06.gpio_pin_in6[15:0]),
 
//interrupt6 from Enet6 MAC6
     .macb0_int6     (1'b0),
     .macb1_int6     (1'b0),
     .macb2_int6     (1'b0),
     .macb3_int6     (1'b0),

    // Scan6 outputs6
    .scan_out_16        (),             // Scan6 out for chain6 1
    .scan_out_26        (),             // Scan6 out for chain6 2
   
    //output from APB6 
    // AHB6 interface for AHB2APB6 bridge6
    .hrdata6            (hrdata6),       // Read data provided from target slave6
    .hready6            (hready6),       // Ready6 for new bus cycle from target slave6
    .hresp6             (hresp6),        // Response6 from the bridge6

    // AHB6 interface for SMC6
    .smc_hrdata6        (), 
    .smc_hready6        (),
    .smc_hresp6         (),
  
    //outputs6 from smc6
    .smc_n_ext_oe6      (),
    .smc_data6          (),
    .smc_addr6          (),
    .smc_n_be6          (),
    .smc_n_cs6          (), 
    .smc_n_we6          (),
    .smc_n_wr6          (),
    .smc_n_rd6          (),
    //outputs6 from uart6
    .ua_txd6             (uart_s06.rxd6),
    .ua_txd16            (uart_s16.rxd6),
    .ua_nrts6            (uart_s06.rts_n6),
    .ua_nrts16           (uart_s16.rts_n6),
    // outputs6 from ttc6
    .so                (),
    .mo6                (spi_s06.sig_si6),
    .sclk_out6          (spi_s06.sig_sclk_in6),
    .n_ss_out6          (n_ss_out6[7:0]),
    .n_so_en6           (),
    .n_mo_en6           (),
    .n_sclk_en6         (),
    .n_ss_en6           (),
    //outputs6 from gpio6
    .n_gpio_pin_oe6     (gpio_s06.n_gpio_pin_oe6[15:0]),
    .gpio_pin_out6      (gpio_s06.gpio_pin_out6[15:0]),

//unconnected6 o/p ports6
    .clk_SRPG_macb0_en6(),
    .clk_SRPG_macb1_en6(),
    .clk_SRPG_macb2_en6(),
    .clk_SRPG_macb3_en6(),
    .core06v6(),
    .core08v6(),
    .core10v6(),
    .core12v6(),
    .mte_smc_start6(),
    .mte_uart_start6(),
    .mte_smc_uart_start6(),
    .mte_pm_smc_to_default_start6(),
    .mte_pm_uart_to_default_start6(),
    .mte_pm_smc_uart_to_default_start6(),
    .pcm_irq6(),
    .ttc_irq6(),
    .gpio_irq6(),
    .uart0_irq6(),
    .uart1_irq6(),
    .spi_irq6(),

    .macb3_wakeup6(),
    .macb2_wakeup6(),
    .macb1_wakeup6(),
    .macb0_wakeup6()
);


initial
begin
  tb_hclk6 = 0;
  hresetn6 = 1;

  #1 hresetn6 = 0;
  #1200 hresetn6 = 1;
end

always #50 tb_hclk6 = ~tb_hclk6;

initial begin
  uvm_config_db#(virtual uart_if6)::set(null, "uvm_test_top.ve6.uart06*", "vif6", uart_s06);
  uvm_config_db#(virtual uart_if6)::set(null, "uvm_test_top.ve6.uart16*", "vif6", uart_s16);
  uvm_config_db#(virtual uart_ctrl_internal_if6)::set(null, "uvm_test_top.ve6.apb_ss_env6.apb_uart06.*", "vif6", uart_int06);
  uvm_config_db#(virtual uart_ctrl_internal_if6)::set(null, "uvm_test_top.ve6.apb_ss_env6.apb_uart16.*", "vif6", uart_int16);
  uvm_config_db#(virtual apb_if6)::set(null, "uvm_test_top.ve6.apb06*", "vif6", apbi_mo6);
  uvm_config_db#(virtual ahb_if6)::set(null, "uvm_test_top.ve6.ahb06*", "vif6", ahbi_m06);
  uvm_config_db#(virtual spi_if6)::set(null, "uvm_test_top.ve6.spi06*", "spi_if6", spi_s06);
  uvm_config_db#(virtual gpio_if6)::set(null, "uvm_test_top.ve6.gpio06*", "gpio_if6", gpio_s06);
  run_test();
end

endmodule
