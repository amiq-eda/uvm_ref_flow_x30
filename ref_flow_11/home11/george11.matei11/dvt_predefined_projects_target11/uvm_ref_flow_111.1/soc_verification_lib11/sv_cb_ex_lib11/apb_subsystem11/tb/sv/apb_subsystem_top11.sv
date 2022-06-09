/*-------------------------------------------------------------------------
File11 name   : apb_subsystem_top11.v 
Title11       : Top11 level file for the testbench 
Project11     : APB11 Subsystem11
Created11     : March11 2008
Description11 : This11 is top level file which instantiate11 the dut11 apb_subsyste11,.v.
              It also has the assertion11 module which checks11 for the power11 down 
              and power11 up.To11 activate11 the assertion11 ifdef LP_ABV_ON11 is used.       
Notes11       :
-------------------------------------------------------------------------*/ 
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------

 `timescale 1ns/10ps


// Environment11 Constants11
`ifndef AHB_DATA_WIDTH11
  `define AHB_DATA_WIDTH11          32              // AHB11 bus data width [32/64]
`endif
`ifndef AHB_ADDR_WIDTH11
  `define AHB_ADDR_WIDTH11          32              // AHB11 bus address width [32/64]
`endif
`ifndef AHB_DATA_MAX_BIT11
  `define AHB_DATA_MAX_BIT11        31              // MUST11 BE11: AHB_DATA_WIDTH11 - 1
`endif
`ifndef AHB_ADDRESS_MAX_BIT11
  `define AHB_ADDRESS_MAX_BIT11     31              // MUST11 BE11: AHB_ADDR_WIDTH11 - 1
`endif
`ifndef DEFAULT_HREADY_VALUE11
  `define DEFAULT_HREADY_VALUE11    1'b1            // Ready11 Asserted11
`endif

`include "ahb_if11.sv"
`include "apb_if11.sv"
`include "apb_master_if11.sv"
`include "apb_slave_if11.sv"
`include "uart_if11.sv"
`include "spi_if11.sv"
`include "gpio_if11.sv"
`include "coverage11/uart_ctrl_internal_if11.sv"

module apb_subsystem_top11;
  import uvm_pkg::*;
  // Import11 the UVM Utilities11 Package11

  import ahb_pkg11::*;
  import apb_pkg11::*;
  import uart_pkg11::*;
  import gpio_pkg11::*;
  import spi_pkg11::*;
  import uart_ctrl_pkg11::*;
  import apb_subsystem_pkg11::*;

  `include "spi_reg_model11.sv"
  `include "gpio_reg_model11.sv"
  `include "apb_subsystem_reg_rdb11.sv"
  `include "uart_ctrl_reg_seq_lib11.sv"
  `include "spi_reg_seq_lib11.sv"
  `include "gpio_reg_seq_lib11.sv"

  //Include11 module UVC11 sequences
  `include "ahb_user_monitor11.sv"
  `include "apb_subsystem_seq_lib11.sv"
  `include "apb_subsystem_vir_sequencer11.sv"
  `include "apb_subsystem_vir_seq_lib11.sv"

  `include "apb_subsystem_tb11.sv"
  `include "test_lib11.sv"
   
  
   // ====================================
   // SHARED11 signals11
   // ====================================
   
   // clock11
   reg tb_hclk11;
   
   // reset
   reg hresetn11;
   
   // post11-mux11 from master11 mux11
   wire [`AHB_DATA_MAX_BIT11:0] hwdata11;
   wire [`AHB_ADDRESS_MAX_BIT11:0] haddr11;
   wire [1:0]  htrans11;
   wire [2:0]  hburst11;
   wire [2:0]  hsize11;
   wire [3:0]  hprot11;
   wire hwrite11;

   // post11-mux11 from slave11 mux11
   wire        hready11;
   wire [1:0]  hresp11;
   wire [`AHB_DATA_MAX_BIT11:0] hrdata11;
  

  //  Specific11 signals11 of apb11 subsystem11
  reg         ua_rxd11;
  reg         ua_ncts11;


  // uart11 outputs11 
  wire        ua_txd11;
  wire        us_nrts11;

  wire   [7:0] n_ss_out11;    // peripheral11 select11 lines11 from master11
  wire   [31:0] hwdata_byte_alligned11;

  reg [2:0] div8_clk11;
 always @(posedge tb_hclk11) begin
   if (!hresetn11)
     div8_clk11 = 3'b000;
   else
     div8_clk11 = div8_clk11 + 1;
 end


  // Master11 virtual interface
  ahb_if11 ahbi_m011(.ahb_clock11(tb_hclk11), .ahb_resetn11(hresetn11));
  
  uart_if11 uart_s011(.clock11(div8_clk11[2]), .reset(hresetn11));
  uart_if11 uart_s111(.clock11(div8_clk11[2]), .reset(hresetn11));
  spi_if11 spi_s011();
  gpio_if11 gpio_s011();
  uart_ctrl_internal_if11 uart_int011(.clock11(div8_clk11[2]));
  uart_ctrl_internal_if11 uart_int111(.clock11(div8_clk11[2]));

  apb_if11 apbi_mo11(.pclock11(tb_hclk11), .preset11(hresetn11));

  //M011
  assign ahbi_m011.AHB_HCLK11 = tb_hclk11;
  assign ahbi_m011.AHB_HRESET11 = hresetn11;
  assign ahbi_m011.AHB_HRESP11 = hresp11;
  assign ahbi_m011.AHB_HRDATA11 = hrdata11;
  assign ahbi_m011.AHB_HREADY11 = hready11;

  assign apbi_mo11.paddr11 = i_apb_subsystem11.i_ahb2apb11.paddr11;
  assign apbi_mo11.prwd11 = i_apb_subsystem11.i_ahb2apb11.pwrite11;
  assign apbi_mo11.pwdata11 = i_apb_subsystem11.i_ahb2apb11.pwdata11;
  assign apbi_mo11.penable11 = i_apb_subsystem11.i_ahb2apb11.penable11;
  assign apbi_mo11.psel11 = {12'b0, i_apb_subsystem11.i_ahb2apb11.psel811, i_apb_subsystem11.i_ahb2apb11.psel211, i_apb_subsystem11.i_ahb2apb11.psel111, i_apb_subsystem11.i_ahb2apb11.psel011};
  assign apbi_mo11.prdata11 = i_apb_subsystem11.i_ahb2apb11.psel011? i_apb_subsystem11.i_ahb2apb11.prdata011 : (i_apb_subsystem11.i_ahb2apb11.psel111? i_apb_subsystem11.i_ahb2apb11.prdata111 : (i_apb_subsystem11.i_ahb2apb11.psel211? i_apb_subsystem11.i_ahb2apb11.prdata211 : i_apb_subsystem11.i_ahb2apb11.prdata811));

  assign spi_s011.sig_n_ss_in11 = n_ss_out11[0];
  assign spi_s011.sig_n_p_reset11 = hresetn11;
  assign spi_s011.sig_pclk11 = tb_hclk11;

  assign gpio_s011.n_p_reset11 = hresetn11;
  assign gpio_s011.pclk11 = tb_hclk11;

  assign hwdata_byte_alligned11 = (ahbi_m011.AHB_HADDR11[1:0] == 2'b00) ? ahbi_m011.AHB_HWDATA11 : {4{ahbi_m011.AHB_HWDATA11[7:0]}};

  apb_subsystem_011 i_apb_subsystem11 (
    // Inputs11
    // system signals11
    .hclk11              (tb_hclk11),     // AHB11 Clock11
    .n_hreset11          (hresetn11),     // AHB11 reset - Active11 low11
    .pclk11              (tb_hclk11),     // APB11 Clock11
    .n_preset11          (hresetn11),     // APB11 reset - Active11 low11
    
    // AHB11 interface for AHB2APM11 bridge11
    .hsel11     (1'b1),        // AHB2APB11 select11
    .haddr11             (ahbi_m011.AHB_HADDR11),        // Address bus
    .htrans11            (ahbi_m011.AHB_HTRANS11),       // Transfer11 type
    .hsize11             (ahbi_m011.AHB_HSIZE11),        // AHB11 Access type - byte half11-word11 word11
    .hwrite11            (ahbi_m011.AHB_HWRITE11),       // Write signal11
    .hwdata11            (hwdata_byte_alligned11),       // Write data
    .hready_in11         (hready11),       // Indicates11 that the last master11 has finished11 
                                       // its bus access
    .hburst11            (ahbi_m011.AHB_HBURST11),       // Burst type
    .hprot11             (ahbi_m011.AHB_HPROT11),        // Protection11 control11
    .hmaster11           (4'h0),      // Master11 select11
    .hmastlock11         (ahbi_m011.AHB_HLOCK11),  // Locked11 transfer11
    // AHB11 interface for SMC11
    .smc_hclk11          (1'b0),
    .smc_n_hclk11        (1'b1),
    .smc_haddr11         (32'd0),
    .smc_htrans11        (2'b00),
    .smc_hsel11          (1'b0),
    .smc_hwrite11        (1'b0),
    .smc_hsize11         (3'd0),
    .smc_hwdata11        (32'd0),
    .smc_hready_in11     (1'b1),
    .smc_hburst11        (3'b000),
    .smc_hprot11         (4'b0000),
    .smc_hmaster11       (4'b0000),
    .smc_hmastlock11     (1'b0),

    //interrupt11 from DMA11
    .DMA_irq11           (1'b0),      

    // Scan11 inputs11
    .scan_en11           (1'b0),         // Scan11 enable pin11
    .scan_in_111         (1'b0),         // Scan11 input for first chain11
    .scan_in_211         (1'b0),        // Scan11 input for second chain11
    .scan_mode11         (1'b0),
    //input for smc11
    .data_smc11          (32'd0),
    //inputs11 for uart11
    .ua_rxd11            (uart_s011.txd11),
    .ua_rxd111           (uart_s111.txd11),
    .ua_ncts11           (uart_s011.cts_n11),
    .ua_ncts111          (uart_s111.cts_n11),
    //inputs11 for spi11
    .n_ss_in11           (1'b1),
    .mi11                (spi_s011.sig_so11),
    .si11                (1'b0),
    .sclk_in11           (1'b0),
    //inputs11 for GPIO11
    .gpio_pin_in11       (gpio_s011.gpio_pin_in11[15:0]),
 
//interrupt11 from Enet11 MAC11
     .macb0_int11     (1'b0),
     .macb1_int11     (1'b0),
     .macb2_int11     (1'b0),
     .macb3_int11     (1'b0),

    // Scan11 outputs11
    .scan_out_111        (),             // Scan11 out for chain11 1
    .scan_out_211        (),             // Scan11 out for chain11 2
   
    //output from APB11 
    // AHB11 interface for AHB2APB11 bridge11
    .hrdata11            (hrdata11),       // Read data provided from target slave11
    .hready11            (hready11),       // Ready11 for new bus cycle from target slave11
    .hresp11             (hresp11),        // Response11 from the bridge11

    // AHB11 interface for SMC11
    .smc_hrdata11        (), 
    .smc_hready11        (),
    .smc_hresp11         (),
  
    //outputs11 from smc11
    .smc_n_ext_oe11      (),
    .smc_data11          (),
    .smc_addr11          (),
    .smc_n_be11          (),
    .smc_n_cs11          (), 
    .smc_n_we11          (),
    .smc_n_wr11          (),
    .smc_n_rd11          (),
    //outputs11 from uart11
    .ua_txd11             (uart_s011.rxd11),
    .ua_txd111            (uart_s111.rxd11),
    .ua_nrts11            (uart_s011.rts_n11),
    .ua_nrts111           (uart_s111.rts_n11),
    // outputs11 from ttc11
    .so                (),
    .mo11                (spi_s011.sig_si11),
    .sclk_out11          (spi_s011.sig_sclk_in11),
    .n_ss_out11          (n_ss_out11[7:0]),
    .n_so_en11           (),
    .n_mo_en11           (),
    .n_sclk_en11         (),
    .n_ss_en11           (),
    //outputs11 from gpio11
    .n_gpio_pin_oe11     (gpio_s011.n_gpio_pin_oe11[15:0]),
    .gpio_pin_out11      (gpio_s011.gpio_pin_out11[15:0]),

//unconnected11 o/p ports11
    .clk_SRPG_macb0_en11(),
    .clk_SRPG_macb1_en11(),
    .clk_SRPG_macb2_en11(),
    .clk_SRPG_macb3_en11(),
    .core06v11(),
    .core08v11(),
    .core10v11(),
    .core12v11(),
    .mte_smc_start11(),
    .mte_uart_start11(),
    .mte_smc_uart_start11(),
    .mte_pm_smc_to_default_start11(),
    .mte_pm_uart_to_default_start11(),
    .mte_pm_smc_uart_to_default_start11(),
    .pcm_irq11(),
    .ttc_irq11(),
    .gpio_irq11(),
    .uart0_irq11(),
    .uart1_irq11(),
    .spi_irq11(),

    .macb3_wakeup11(),
    .macb2_wakeup11(),
    .macb1_wakeup11(),
    .macb0_wakeup11()
);


initial
begin
  tb_hclk11 = 0;
  hresetn11 = 1;

  #1 hresetn11 = 0;
  #1200 hresetn11 = 1;
end

always #50 tb_hclk11 = ~tb_hclk11;

initial begin
  uvm_config_db#(virtual uart_if11)::set(null, "uvm_test_top.ve11.uart011*", "vif11", uart_s011);
  uvm_config_db#(virtual uart_if11)::set(null, "uvm_test_top.ve11.uart111*", "vif11", uart_s111);
  uvm_config_db#(virtual uart_ctrl_internal_if11)::set(null, "uvm_test_top.ve11.apb_ss_env11.apb_uart011.*", "vif11", uart_int011);
  uvm_config_db#(virtual uart_ctrl_internal_if11)::set(null, "uvm_test_top.ve11.apb_ss_env11.apb_uart111.*", "vif11", uart_int111);
  uvm_config_db#(virtual apb_if11)::set(null, "uvm_test_top.ve11.apb011*", "vif11", apbi_mo11);
  uvm_config_db#(virtual ahb_if11)::set(null, "uvm_test_top.ve11.ahb011*", "vif11", ahbi_m011);
  uvm_config_db#(virtual spi_if11)::set(null, "uvm_test_top.ve11.spi011*", "spi_if11", spi_s011);
  uvm_config_db#(virtual gpio_if11)::set(null, "uvm_test_top.ve11.gpio011*", "gpio_if11", gpio_s011);
  run_test();
end

endmodule
