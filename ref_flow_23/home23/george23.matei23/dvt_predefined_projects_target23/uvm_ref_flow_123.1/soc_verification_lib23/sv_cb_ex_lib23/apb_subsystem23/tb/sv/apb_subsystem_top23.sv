/*-------------------------------------------------------------------------
File23 name   : apb_subsystem_top23.v 
Title23       : Top23 level file for the testbench 
Project23     : APB23 Subsystem23
Created23     : March23 2008
Description23 : This23 is top level file which instantiate23 the dut23 apb_subsyste23,.v.
              It also has the assertion23 module which checks23 for the power23 down 
              and power23 up.To23 activate23 the assertion23 ifdef LP_ABV_ON23 is used.       
Notes23       :
-------------------------------------------------------------------------*/ 
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------

 `timescale 1ns/10ps


// Environment23 Constants23
`ifndef AHB_DATA_WIDTH23
  `define AHB_DATA_WIDTH23          32              // AHB23 bus data width [32/64]
`endif
`ifndef AHB_ADDR_WIDTH23
  `define AHB_ADDR_WIDTH23          32              // AHB23 bus address width [32/64]
`endif
`ifndef AHB_DATA_MAX_BIT23
  `define AHB_DATA_MAX_BIT23        31              // MUST23 BE23: AHB_DATA_WIDTH23 - 1
`endif
`ifndef AHB_ADDRESS_MAX_BIT23
  `define AHB_ADDRESS_MAX_BIT23     31              // MUST23 BE23: AHB_ADDR_WIDTH23 - 1
`endif
`ifndef DEFAULT_HREADY_VALUE23
  `define DEFAULT_HREADY_VALUE23    1'b1            // Ready23 Asserted23
`endif

`include "ahb_if23.sv"
`include "apb_if23.sv"
`include "apb_master_if23.sv"
`include "apb_slave_if23.sv"
`include "uart_if23.sv"
`include "spi_if23.sv"
`include "gpio_if23.sv"
`include "coverage23/uart_ctrl_internal_if23.sv"

module apb_subsystem_top23;
  import uvm_pkg::*;
  // Import23 the UVM Utilities23 Package23

  import ahb_pkg23::*;
  import apb_pkg23::*;
  import uart_pkg23::*;
  import gpio_pkg23::*;
  import spi_pkg23::*;
  import uart_ctrl_pkg23::*;
  import apb_subsystem_pkg23::*;

  `include "spi_reg_model23.sv"
  `include "gpio_reg_model23.sv"
  `include "apb_subsystem_reg_rdb23.sv"
  `include "uart_ctrl_reg_seq_lib23.sv"
  `include "spi_reg_seq_lib23.sv"
  `include "gpio_reg_seq_lib23.sv"

  //Include23 module UVC23 sequences
  `include "ahb_user_monitor23.sv"
  `include "apb_subsystem_seq_lib23.sv"
  `include "apb_subsystem_vir_sequencer23.sv"
  `include "apb_subsystem_vir_seq_lib23.sv"

  `include "apb_subsystem_tb23.sv"
  `include "test_lib23.sv"
   
  
   // ====================================
   // SHARED23 signals23
   // ====================================
   
   // clock23
   reg tb_hclk23;
   
   // reset
   reg hresetn23;
   
   // post23-mux23 from master23 mux23
   wire [`AHB_DATA_MAX_BIT23:0] hwdata23;
   wire [`AHB_ADDRESS_MAX_BIT23:0] haddr23;
   wire [1:0]  htrans23;
   wire [2:0]  hburst23;
   wire [2:0]  hsize23;
   wire [3:0]  hprot23;
   wire hwrite23;

   // post23-mux23 from slave23 mux23
   wire        hready23;
   wire [1:0]  hresp23;
   wire [`AHB_DATA_MAX_BIT23:0] hrdata23;
  

  //  Specific23 signals23 of apb23 subsystem23
  reg         ua_rxd23;
  reg         ua_ncts23;


  // uart23 outputs23 
  wire        ua_txd23;
  wire        us_nrts23;

  wire   [7:0] n_ss_out23;    // peripheral23 select23 lines23 from master23
  wire   [31:0] hwdata_byte_alligned23;

  reg [2:0] div8_clk23;
 always @(posedge tb_hclk23) begin
   if (!hresetn23)
     div8_clk23 = 3'b000;
   else
     div8_clk23 = div8_clk23 + 1;
 end


  // Master23 virtual interface
  ahb_if23 ahbi_m023(.ahb_clock23(tb_hclk23), .ahb_resetn23(hresetn23));
  
  uart_if23 uart_s023(.clock23(div8_clk23[2]), .reset(hresetn23));
  uart_if23 uart_s123(.clock23(div8_clk23[2]), .reset(hresetn23));
  spi_if23 spi_s023();
  gpio_if23 gpio_s023();
  uart_ctrl_internal_if23 uart_int023(.clock23(div8_clk23[2]));
  uart_ctrl_internal_if23 uart_int123(.clock23(div8_clk23[2]));

  apb_if23 apbi_mo23(.pclock23(tb_hclk23), .preset23(hresetn23));

  //M023
  assign ahbi_m023.AHB_HCLK23 = tb_hclk23;
  assign ahbi_m023.AHB_HRESET23 = hresetn23;
  assign ahbi_m023.AHB_HRESP23 = hresp23;
  assign ahbi_m023.AHB_HRDATA23 = hrdata23;
  assign ahbi_m023.AHB_HREADY23 = hready23;

  assign apbi_mo23.paddr23 = i_apb_subsystem23.i_ahb2apb23.paddr23;
  assign apbi_mo23.prwd23 = i_apb_subsystem23.i_ahb2apb23.pwrite23;
  assign apbi_mo23.pwdata23 = i_apb_subsystem23.i_ahb2apb23.pwdata23;
  assign apbi_mo23.penable23 = i_apb_subsystem23.i_ahb2apb23.penable23;
  assign apbi_mo23.psel23 = {12'b0, i_apb_subsystem23.i_ahb2apb23.psel823, i_apb_subsystem23.i_ahb2apb23.psel223, i_apb_subsystem23.i_ahb2apb23.psel123, i_apb_subsystem23.i_ahb2apb23.psel023};
  assign apbi_mo23.prdata23 = i_apb_subsystem23.i_ahb2apb23.psel023? i_apb_subsystem23.i_ahb2apb23.prdata023 : (i_apb_subsystem23.i_ahb2apb23.psel123? i_apb_subsystem23.i_ahb2apb23.prdata123 : (i_apb_subsystem23.i_ahb2apb23.psel223? i_apb_subsystem23.i_ahb2apb23.prdata223 : i_apb_subsystem23.i_ahb2apb23.prdata823));

  assign spi_s023.sig_n_ss_in23 = n_ss_out23[0];
  assign spi_s023.sig_n_p_reset23 = hresetn23;
  assign spi_s023.sig_pclk23 = tb_hclk23;

  assign gpio_s023.n_p_reset23 = hresetn23;
  assign gpio_s023.pclk23 = tb_hclk23;

  assign hwdata_byte_alligned23 = (ahbi_m023.AHB_HADDR23[1:0] == 2'b00) ? ahbi_m023.AHB_HWDATA23 : {4{ahbi_m023.AHB_HWDATA23[7:0]}};

  apb_subsystem_023 i_apb_subsystem23 (
    // Inputs23
    // system signals23
    .hclk23              (tb_hclk23),     // AHB23 Clock23
    .n_hreset23          (hresetn23),     // AHB23 reset - Active23 low23
    .pclk23              (tb_hclk23),     // APB23 Clock23
    .n_preset23          (hresetn23),     // APB23 reset - Active23 low23
    
    // AHB23 interface for AHB2APM23 bridge23
    .hsel23     (1'b1),        // AHB2APB23 select23
    .haddr23             (ahbi_m023.AHB_HADDR23),        // Address bus
    .htrans23            (ahbi_m023.AHB_HTRANS23),       // Transfer23 type
    .hsize23             (ahbi_m023.AHB_HSIZE23),        // AHB23 Access type - byte half23-word23 word23
    .hwrite23            (ahbi_m023.AHB_HWRITE23),       // Write signal23
    .hwdata23            (hwdata_byte_alligned23),       // Write data
    .hready_in23         (hready23),       // Indicates23 that the last master23 has finished23 
                                       // its bus access
    .hburst23            (ahbi_m023.AHB_HBURST23),       // Burst type
    .hprot23             (ahbi_m023.AHB_HPROT23),        // Protection23 control23
    .hmaster23           (4'h0),      // Master23 select23
    .hmastlock23         (ahbi_m023.AHB_HLOCK23),  // Locked23 transfer23
    // AHB23 interface for SMC23
    .smc_hclk23          (1'b0),
    .smc_n_hclk23        (1'b1),
    .smc_haddr23         (32'd0),
    .smc_htrans23        (2'b00),
    .smc_hsel23          (1'b0),
    .smc_hwrite23        (1'b0),
    .smc_hsize23         (3'd0),
    .smc_hwdata23        (32'd0),
    .smc_hready_in23     (1'b1),
    .smc_hburst23        (3'b000),
    .smc_hprot23         (4'b0000),
    .smc_hmaster23       (4'b0000),
    .smc_hmastlock23     (1'b0),

    //interrupt23 from DMA23
    .DMA_irq23           (1'b0),      

    // Scan23 inputs23
    .scan_en23           (1'b0),         // Scan23 enable pin23
    .scan_in_123         (1'b0),         // Scan23 input for first chain23
    .scan_in_223         (1'b0),        // Scan23 input for second chain23
    .scan_mode23         (1'b0),
    //input for smc23
    .data_smc23          (32'd0),
    //inputs23 for uart23
    .ua_rxd23            (uart_s023.txd23),
    .ua_rxd123           (uart_s123.txd23),
    .ua_ncts23           (uart_s023.cts_n23),
    .ua_ncts123          (uart_s123.cts_n23),
    //inputs23 for spi23
    .n_ss_in23           (1'b1),
    .mi23                (spi_s023.sig_so23),
    .si23                (1'b0),
    .sclk_in23           (1'b0),
    //inputs23 for GPIO23
    .gpio_pin_in23       (gpio_s023.gpio_pin_in23[15:0]),
 
//interrupt23 from Enet23 MAC23
     .macb0_int23     (1'b0),
     .macb1_int23     (1'b0),
     .macb2_int23     (1'b0),
     .macb3_int23     (1'b0),

    // Scan23 outputs23
    .scan_out_123        (),             // Scan23 out for chain23 1
    .scan_out_223        (),             // Scan23 out for chain23 2
   
    //output from APB23 
    // AHB23 interface for AHB2APB23 bridge23
    .hrdata23            (hrdata23),       // Read data provided from target slave23
    .hready23            (hready23),       // Ready23 for new bus cycle from target slave23
    .hresp23             (hresp23),        // Response23 from the bridge23

    // AHB23 interface for SMC23
    .smc_hrdata23        (), 
    .smc_hready23        (),
    .smc_hresp23         (),
  
    //outputs23 from smc23
    .smc_n_ext_oe23      (),
    .smc_data23          (),
    .smc_addr23          (),
    .smc_n_be23          (),
    .smc_n_cs23          (), 
    .smc_n_we23          (),
    .smc_n_wr23          (),
    .smc_n_rd23          (),
    //outputs23 from uart23
    .ua_txd23             (uart_s023.rxd23),
    .ua_txd123            (uart_s123.rxd23),
    .ua_nrts23            (uart_s023.rts_n23),
    .ua_nrts123           (uart_s123.rts_n23),
    // outputs23 from ttc23
    .so                (),
    .mo23                (spi_s023.sig_si23),
    .sclk_out23          (spi_s023.sig_sclk_in23),
    .n_ss_out23          (n_ss_out23[7:0]),
    .n_so_en23           (),
    .n_mo_en23           (),
    .n_sclk_en23         (),
    .n_ss_en23           (),
    //outputs23 from gpio23
    .n_gpio_pin_oe23     (gpio_s023.n_gpio_pin_oe23[15:0]),
    .gpio_pin_out23      (gpio_s023.gpio_pin_out23[15:0]),

//unconnected23 o/p ports23
    .clk_SRPG_macb0_en23(),
    .clk_SRPG_macb1_en23(),
    .clk_SRPG_macb2_en23(),
    .clk_SRPG_macb3_en23(),
    .core06v23(),
    .core08v23(),
    .core10v23(),
    .core12v23(),
    .mte_smc_start23(),
    .mte_uart_start23(),
    .mte_smc_uart_start23(),
    .mte_pm_smc_to_default_start23(),
    .mte_pm_uart_to_default_start23(),
    .mte_pm_smc_uart_to_default_start23(),
    .pcm_irq23(),
    .ttc_irq23(),
    .gpio_irq23(),
    .uart0_irq23(),
    .uart1_irq23(),
    .spi_irq23(),

    .macb3_wakeup23(),
    .macb2_wakeup23(),
    .macb1_wakeup23(),
    .macb0_wakeup23()
);


initial
begin
  tb_hclk23 = 0;
  hresetn23 = 1;

  #1 hresetn23 = 0;
  #1200 hresetn23 = 1;
end

always #50 tb_hclk23 = ~tb_hclk23;

initial begin
  uvm_config_db#(virtual uart_if23)::set(null, "uvm_test_top.ve23.uart023*", "vif23", uart_s023);
  uvm_config_db#(virtual uart_if23)::set(null, "uvm_test_top.ve23.uart123*", "vif23", uart_s123);
  uvm_config_db#(virtual uart_ctrl_internal_if23)::set(null, "uvm_test_top.ve23.apb_ss_env23.apb_uart023.*", "vif23", uart_int023);
  uvm_config_db#(virtual uart_ctrl_internal_if23)::set(null, "uvm_test_top.ve23.apb_ss_env23.apb_uart123.*", "vif23", uart_int123);
  uvm_config_db#(virtual apb_if23)::set(null, "uvm_test_top.ve23.apb023*", "vif23", apbi_mo23);
  uvm_config_db#(virtual ahb_if23)::set(null, "uvm_test_top.ve23.ahb023*", "vif23", ahbi_m023);
  uvm_config_db#(virtual spi_if23)::set(null, "uvm_test_top.ve23.spi023*", "spi_if23", spi_s023);
  uvm_config_db#(virtual gpio_if23)::set(null, "uvm_test_top.ve23.gpio023*", "gpio_if23", gpio_s023);
  run_test();
end

endmodule
