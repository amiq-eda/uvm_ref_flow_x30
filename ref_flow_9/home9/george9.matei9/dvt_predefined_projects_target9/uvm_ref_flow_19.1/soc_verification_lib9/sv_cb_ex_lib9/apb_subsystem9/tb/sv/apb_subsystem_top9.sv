/*-------------------------------------------------------------------------
File9 name   : apb_subsystem_top9.v 
Title9       : Top9 level file for the testbench 
Project9     : APB9 Subsystem9
Created9     : March9 2008
Description9 : This9 is top level file which instantiate9 the dut9 apb_subsyste9,.v.
              It also has the assertion9 module which checks9 for the power9 down 
              and power9 up.To9 activate9 the assertion9 ifdef LP_ABV_ON9 is used.       
Notes9       :
-------------------------------------------------------------------------*/ 
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------

 `timescale 1ns/10ps


// Environment9 Constants9
`ifndef AHB_DATA_WIDTH9
  `define AHB_DATA_WIDTH9          32              // AHB9 bus data width [32/64]
`endif
`ifndef AHB_ADDR_WIDTH9
  `define AHB_ADDR_WIDTH9          32              // AHB9 bus address width [32/64]
`endif
`ifndef AHB_DATA_MAX_BIT9
  `define AHB_DATA_MAX_BIT9        31              // MUST9 BE9: AHB_DATA_WIDTH9 - 1
`endif
`ifndef AHB_ADDRESS_MAX_BIT9
  `define AHB_ADDRESS_MAX_BIT9     31              // MUST9 BE9: AHB_ADDR_WIDTH9 - 1
`endif
`ifndef DEFAULT_HREADY_VALUE9
  `define DEFAULT_HREADY_VALUE9    1'b1            // Ready9 Asserted9
`endif

`include "ahb_if9.sv"
`include "apb_if9.sv"
`include "apb_master_if9.sv"
`include "apb_slave_if9.sv"
`include "uart_if9.sv"
`include "spi_if9.sv"
`include "gpio_if9.sv"
`include "coverage9/uart_ctrl_internal_if9.sv"

module apb_subsystem_top9;
  import uvm_pkg::*;
  // Import9 the UVM Utilities9 Package9

  import ahb_pkg9::*;
  import apb_pkg9::*;
  import uart_pkg9::*;
  import gpio_pkg9::*;
  import spi_pkg9::*;
  import uart_ctrl_pkg9::*;
  import apb_subsystem_pkg9::*;

  `include "spi_reg_model9.sv"
  `include "gpio_reg_model9.sv"
  `include "apb_subsystem_reg_rdb9.sv"
  `include "uart_ctrl_reg_seq_lib9.sv"
  `include "spi_reg_seq_lib9.sv"
  `include "gpio_reg_seq_lib9.sv"

  //Include9 module UVC9 sequences
  `include "ahb_user_monitor9.sv"
  `include "apb_subsystem_seq_lib9.sv"
  `include "apb_subsystem_vir_sequencer9.sv"
  `include "apb_subsystem_vir_seq_lib9.sv"

  `include "apb_subsystem_tb9.sv"
  `include "test_lib9.sv"
   
  
   // ====================================
   // SHARED9 signals9
   // ====================================
   
   // clock9
   reg tb_hclk9;
   
   // reset
   reg hresetn9;
   
   // post9-mux9 from master9 mux9
   wire [`AHB_DATA_MAX_BIT9:0] hwdata9;
   wire [`AHB_ADDRESS_MAX_BIT9:0] haddr9;
   wire [1:0]  htrans9;
   wire [2:0]  hburst9;
   wire [2:0]  hsize9;
   wire [3:0]  hprot9;
   wire hwrite9;

   // post9-mux9 from slave9 mux9
   wire        hready9;
   wire [1:0]  hresp9;
   wire [`AHB_DATA_MAX_BIT9:0] hrdata9;
  

  //  Specific9 signals9 of apb9 subsystem9
  reg         ua_rxd9;
  reg         ua_ncts9;


  // uart9 outputs9 
  wire        ua_txd9;
  wire        us_nrts9;

  wire   [7:0] n_ss_out9;    // peripheral9 select9 lines9 from master9
  wire   [31:0] hwdata_byte_alligned9;

  reg [2:0] div8_clk9;
 always @(posedge tb_hclk9) begin
   if (!hresetn9)
     div8_clk9 = 3'b000;
   else
     div8_clk9 = div8_clk9 + 1;
 end


  // Master9 virtual interface
  ahb_if9 ahbi_m09(.ahb_clock9(tb_hclk9), .ahb_resetn9(hresetn9));
  
  uart_if9 uart_s09(.clock9(div8_clk9[2]), .reset(hresetn9));
  uart_if9 uart_s19(.clock9(div8_clk9[2]), .reset(hresetn9));
  spi_if9 spi_s09();
  gpio_if9 gpio_s09();
  uart_ctrl_internal_if9 uart_int09(.clock9(div8_clk9[2]));
  uart_ctrl_internal_if9 uart_int19(.clock9(div8_clk9[2]));

  apb_if9 apbi_mo9(.pclock9(tb_hclk9), .preset9(hresetn9));

  //M09
  assign ahbi_m09.AHB_HCLK9 = tb_hclk9;
  assign ahbi_m09.AHB_HRESET9 = hresetn9;
  assign ahbi_m09.AHB_HRESP9 = hresp9;
  assign ahbi_m09.AHB_HRDATA9 = hrdata9;
  assign ahbi_m09.AHB_HREADY9 = hready9;

  assign apbi_mo9.paddr9 = i_apb_subsystem9.i_ahb2apb9.paddr9;
  assign apbi_mo9.prwd9 = i_apb_subsystem9.i_ahb2apb9.pwrite9;
  assign apbi_mo9.pwdata9 = i_apb_subsystem9.i_ahb2apb9.pwdata9;
  assign apbi_mo9.penable9 = i_apb_subsystem9.i_ahb2apb9.penable9;
  assign apbi_mo9.psel9 = {12'b0, i_apb_subsystem9.i_ahb2apb9.psel89, i_apb_subsystem9.i_ahb2apb9.psel29, i_apb_subsystem9.i_ahb2apb9.psel19, i_apb_subsystem9.i_ahb2apb9.psel09};
  assign apbi_mo9.prdata9 = i_apb_subsystem9.i_ahb2apb9.psel09? i_apb_subsystem9.i_ahb2apb9.prdata09 : (i_apb_subsystem9.i_ahb2apb9.psel19? i_apb_subsystem9.i_ahb2apb9.prdata19 : (i_apb_subsystem9.i_ahb2apb9.psel29? i_apb_subsystem9.i_ahb2apb9.prdata29 : i_apb_subsystem9.i_ahb2apb9.prdata89));

  assign spi_s09.sig_n_ss_in9 = n_ss_out9[0];
  assign spi_s09.sig_n_p_reset9 = hresetn9;
  assign spi_s09.sig_pclk9 = tb_hclk9;

  assign gpio_s09.n_p_reset9 = hresetn9;
  assign gpio_s09.pclk9 = tb_hclk9;

  assign hwdata_byte_alligned9 = (ahbi_m09.AHB_HADDR9[1:0] == 2'b00) ? ahbi_m09.AHB_HWDATA9 : {4{ahbi_m09.AHB_HWDATA9[7:0]}};

  apb_subsystem_09 i_apb_subsystem9 (
    // Inputs9
    // system signals9
    .hclk9              (tb_hclk9),     // AHB9 Clock9
    .n_hreset9          (hresetn9),     // AHB9 reset - Active9 low9
    .pclk9              (tb_hclk9),     // APB9 Clock9
    .n_preset9          (hresetn9),     // APB9 reset - Active9 low9
    
    // AHB9 interface for AHB2APM9 bridge9
    .hsel9     (1'b1),        // AHB2APB9 select9
    .haddr9             (ahbi_m09.AHB_HADDR9),        // Address bus
    .htrans9            (ahbi_m09.AHB_HTRANS9),       // Transfer9 type
    .hsize9             (ahbi_m09.AHB_HSIZE9),        // AHB9 Access type - byte half9-word9 word9
    .hwrite9            (ahbi_m09.AHB_HWRITE9),       // Write signal9
    .hwdata9            (hwdata_byte_alligned9),       // Write data
    .hready_in9         (hready9),       // Indicates9 that the last master9 has finished9 
                                       // its bus access
    .hburst9            (ahbi_m09.AHB_HBURST9),       // Burst type
    .hprot9             (ahbi_m09.AHB_HPROT9),        // Protection9 control9
    .hmaster9           (4'h0),      // Master9 select9
    .hmastlock9         (ahbi_m09.AHB_HLOCK9),  // Locked9 transfer9
    // AHB9 interface for SMC9
    .smc_hclk9          (1'b0),
    .smc_n_hclk9        (1'b1),
    .smc_haddr9         (32'd0),
    .smc_htrans9        (2'b00),
    .smc_hsel9          (1'b0),
    .smc_hwrite9        (1'b0),
    .smc_hsize9         (3'd0),
    .smc_hwdata9        (32'd0),
    .smc_hready_in9     (1'b1),
    .smc_hburst9        (3'b000),
    .smc_hprot9         (4'b0000),
    .smc_hmaster9       (4'b0000),
    .smc_hmastlock9     (1'b0),

    //interrupt9 from DMA9
    .DMA_irq9           (1'b0),      

    // Scan9 inputs9
    .scan_en9           (1'b0),         // Scan9 enable pin9
    .scan_in_19         (1'b0),         // Scan9 input for first chain9
    .scan_in_29         (1'b0),        // Scan9 input for second chain9
    .scan_mode9         (1'b0),
    //input for smc9
    .data_smc9          (32'd0),
    //inputs9 for uart9
    .ua_rxd9            (uart_s09.txd9),
    .ua_rxd19           (uart_s19.txd9),
    .ua_ncts9           (uart_s09.cts_n9),
    .ua_ncts19          (uart_s19.cts_n9),
    //inputs9 for spi9
    .n_ss_in9           (1'b1),
    .mi9                (spi_s09.sig_so9),
    .si9                (1'b0),
    .sclk_in9           (1'b0),
    //inputs9 for GPIO9
    .gpio_pin_in9       (gpio_s09.gpio_pin_in9[15:0]),
 
//interrupt9 from Enet9 MAC9
     .macb0_int9     (1'b0),
     .macb1_int9     (1'b0),
     .macb2_int9     (1'b0),
     .macb3_int9     (1'b0),

    // Scan9 outputs9
    .scan_out_19        (),             // Scan9 out for chain9 1
    .scan_out_29        (),             // Scan9 out for chain9 2
   
    //output from APB9 
    // AHB9 interface for AHB2APB9 bridge9
    .hrdata9            (hrdata9),       // Read data provided from target slave9
    .hready9            (hready9),       // Ready9 for new bus cycle from target slave9
    .hresp9             (hresp9),        // Response9 from the bridge9

    // AHB9 interface for SMC9
    .smc_hrdata9        (), 
    .smc_hready9        (),
    .smc_hresp9         (),
  
    //outputs9 from smc9
    .smc_n_ext_oe9      (),
    .smc_data9          (),
    .smc_addr9          (),
    .smc_n_be9          (),
    .smc_n_cs9          (), 
    .smc_n_we9          (),
    .smc_n_wr9          (),
    .smc_n_rd9          (),
    //outputs9 from uart9
    .ua_txd9             (uart_s09.rxd9),
    .ua_txd19            (uart_s19.rxd9),
    .ua_nrts9            (uart_s09.rts_n9),
    .ua_nrts19           (uart_s19.rts_n9),
    // outputs9 from ttc9
    .so                (),
    .mo9                (spi_s09.sig_si9),
    .sclk_out9          (spi_s09.sig_sclk_in9),
    .n_ss_out9          (n_ss_out9[7:0]),
    .n_so_en9           (),
    .n_mo_en9           (),
    .n_sclk_en9         (),
    .n_ss_en9           (),
    //outputs9 from gpio9
    .n_gpio_pin_oe9     (gpio_s09.n_gpio_pin_oe9[15:0]),
    .gpio_pin_out9      (gpio_s09.gpio_pin_out9[15:0]),

//unconnected9 o/p ports9
    .clk_SRPG_macb0_en9(),
    .clk_SRPG_macb1_en9(),
    .clk_SRPG_macb2_en9(),
    .clk_SRPG_macb3_en9(),
    .core06v9(),
    .core08v9(),
    .core10v9(),
    .core12v9(),
    .mte_smc_start9(),
    .mte_uart_start9(),
    .mte_smc_uart_start9(),
    .mte_pm_smc_to_default_start9(),
    .mte_pm_uart_to_default_start9(),
    .mte_pm_smc_uart_to_default_start9(),
    .pcm_irq9(),
    .ttc_irq9(),
    .gpio_irq9(),
    .uart0_irq9(),
    .uart1_irq9(),
    .spi_irq9(),

    .macb3_wakeup9(),
    .macb2_wakeup9(),
    .macb1_wakeup9(),
    .macb0_wakeup9()
);


initial
begin
  tb_hclk9 = 0;
  hresetn9 = 1;

  #1 hresetn9 = 0;
  #1200 hresetn9 = 1;
end

always #50 tb_hclk9 = ~tb_hclk9;

initial begin
  uvm_config_db#(virtual uart_if9)::set(null, "uvm_test_top.ve9.uart09*", "vif9", uart_s09);
  uvm_config_db#(virtual uart_if9)::set(null, "uvm_test_top.ve9.uart19*", "vif9", uart_s19);
  uvm_config_db#(virtual uart_ctrl_internal_if9)::set(null, "uvm_test_top.ve9.apb_ss_env9.apb_uart09.*", "vif9", uart_int09);
  uvm_config_db#(virtual uart_ctrl_internal_if9)::set(null, "uvm_test_top.ve9.apb_ss_env9.apb_uart19.*", "vif9", uart_int19);
  uvm_config_db#(virtual apb_if9)::set(null, "uvm_test_top.ve9.apb09*", "vif9", apbi_mo9);
  uvm_config_db#(virtual ahb_if9)::set(null, "uvm_test_top.ve9.ahb09*", "vif9", ahbi_m09);
  uvm_config_db#(virtual spi_if9)::set(null, "uvm_test_top.ve9.spi09*", "spi_if9", spi_s09);
  uvm_config_db#(virtual gpio_if9)::set(null, "uvm_test_top.ve9.gpio09*", "gpio_if9", gpio_s09);
  run_test();
end

endmodule
