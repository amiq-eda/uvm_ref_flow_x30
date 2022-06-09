/*-------------------------------------------------------------------------
File14 name   : apb_subsystem_top14.v 
Title14       : Top14 level file for the testbench 
Project14     : APB14 Subsystem14
Created14     : March14 2008
Description14 : This14 is top level file which instantiate14 the dut14 apb_subsyste14,.v.
              It also has the assertion14 module which checks14 for the power14 down 
              and power14 up.To14 activate14 the assertion14 ifdef LP_ABV_ON14 is used.       
Notes14       :
-------------------------------------------------------------------------*/ 
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------

 `timescale 1ns/10ps


// Environment14 Constants14
`ifndef AHB_DATA_WIDTH14
  `define AHB_DATA_WIDTH14          32              // AHB14 bus data width [32/64]
`endif
`ifndef AHB_ADDR_WIDTH14
  `define AHB_ADDR_WIDTH14          32              // AHB14 bus address width [32/64]
`endif
`ifndef AHB_DATA_MAX_BIT14
  `define AHB_DATA_MAX_BIT14        31              // MUST14 BE14: AHB_DATA_WIDTH14 - 1
`endif
`ifndef AHB_ADDRESS_MAX_BIT14
  `define AHB_ADDRESS_MAX_BIT14     31              // MUST14 BE14: AHB_ADDR_WIDTH14 - 1
`endif
`ifndef DEFAULT_HREADY_VALUE14
  `define DEFAULT_HREADY_VALUE14    1'b1            // Ready14 Asserted14
`endif

`include "ahb_if14.sv"
`include "apb_if14.sv"
`include "apb_master_if14.sv"
`include "apb_slave_if14.sv"
`include "uart_if14.sv"
`include "spi_if14.sv"
`include "gpio_if14.sv"
`include "coverage14/uart_ctrl_internal_if14.sv"

module apb_subsystem_top14;
  import uvm_pkg::*;
  // Import14 the UVM Utilities14 Package14

  import ahb_pkg14::*;
  import apb_pkg14::*;
  import uart_pkg14::*;
  import gpio_pkg14::*;
  import spi_pkg14::*;
  import uart_ctrl_pkg14::*;
  import apb_subsystem_pkg14::*;

  `include "spi_reg_model14.sv"
  `include "gpio_reg_model14.sv"
  `include "apb_subsystem_reg_rdb14.sv"
  `include "uart_ctrl_reg_seq_lib14.sv"
  `include "spi_reg_seq_lib14.sv"
  `include "gpio_reg_seq_lib14.sv"

  //Include14 module UVC14 sequences
  `include "ahb_user_monitor14.sv"
  `include "apb_subsystem_seq_lib14.sv"
  `include "apb_subsystem_vir_sequencer14.sv"
  `include "apb_subsystem_vir_seq_lib14.sv"

  `include "apb_subsystem_tb14.sv"
  `include "test_lib14.sv"
   
  
   // ====================================
   // SHARED14 signals14
   // ====================================
   
   // clock14
   reg tb_hclk14;
   
   // reset
   reg hresetn14;
   
   // post14-mux14 from master14 mux14
   wire [`AHB_DATA_MAX_BIT14:0] hwdata14;
   wire [`AHB_ADDRESS_MAX_BIT14:0] haddr14;
   wire [1:0]  htrans14;
   wire [2:0]  hburst14;
   wire [2:0]  hsize14;
   wire [3:0]  hprot14;
   wire hwrite14;

   // post14-mux14 from slave14 mux14
   wire        hready14;
   wire [1:0]  hresp14;
   wire [`AHB_DATA_MAX_BIT14:0] hrdata14;
  

  //  Specific14 signals14 of apb14 subsystem14
  reg         ua_rxd14;
  reg         ua_ncts14;


  // uart14 outputs14 
  wire        ua_txd14;
  wire        us_nrts14;

  wire   [7:0] n_ss_out14;    // peripheral14 select14 lines14 from master14
  wire   [31:0] hwdata_byte_alligned14;

  reg [2:0] div8_clk14;
 always @(posedge tb_hclk14) begin
   if (!hresetn14)
     div8_clk14 = 3'b000;
   else
     div8_clk14 = div8_clk14 + 1;
 end


  // Master14 virtual interface
  ahb_if14 ahbi_m014(.ahb_clock14(tb_hclk14), .ahb_resetn14(hresetn14));
  
  uart_if14 uart_s014(.clock14(div8_clk14[2]), .reset(hresetn14));
  uart_if14 uart_s114(.clock14(div8_clk14[2]), .reset(hresetn14));
  spi_if14 spi_s014();
  gpio_if14 gpio_s014();
  uart_ctrl_internal_if14 uart_int014(.clock14(div8_clk14[2]));
  uart_ctrl_internal_if14 uart_int114(.clock14(div8_clk14[2]));

  apb_if14 apbi_mo14(.pclock14(tb_hclk14), .preset14(hresetn14));

  //M014
  assign ahbi_m014.AHB_HCLK14 = tb_hclk14;
  assign ahbi_m014.AHB_HRESET14 = hresetn14;
  assign ahbi_m014.AHB_HRESP14 = hresp14;
  assign ahbi_m014.AHB_HRDATA14 = hrdata14;
  assign ahbi_m014.AHB_HREADY14 = hready14;

  assign apbi_mo14.paddr14 = i_apb_subsystem14.i_ahb2apb14.paddr14;
  assign apbi_mo14.prwd14 = i_apb_subsystem14.i_ahb2apb14.pwrite14;
  assign apbi_mo14.pwdata14 = i_apb_subsystem14.i_ahb2apb14.pwdata14;
  assign apbi_mo14.penable14 = i_apb_subsystem14.i_ahb2apb14.penable14;
  assign apbi_mo14.psel14 = {12'b0, i_apb_subsystem14.i_ahb2apb14.psel814, i_apb_subsystem14.i_ahb2apb14.psel214, i_apb_subsystem14.i_ahb2apb14.psel114, i_apb_subsystem14.i_ahb2apb14.psel014};
  assign apbi_mo14.prdata14 = i_apb_subsystem14.i_ahb2apb14.psel014? i_apb_subsystem14.i_ahb2apb14.prdata014 : (i_apb_subsystem14.i_ahb2apb14.psel114? i_apb_subsystem14.i_ahb2apb14.prdata114 : (i_apb_subsystem14.i_ahb2apb14.psel214? i_apb_subsystem14.i_ahb2apb14.prdata214 : i_apb_subsystem14.i_ahb2apb14.prdata814));

  assign spi_s014.sig_n_ss_in14 = n_ss_out14[0];
  assign spi_s014.sig_n_p_reset14 = hresetn14;
  assign spi_s014.sig_pclk14 = tb_hclk14;

  assign gpio_s014.n_p_reset14 = hresetn14;
  assign gpio_s014.pclk14 = tb_hclk14;

  assign hwdata_byte_alligned14 = (ahbi_m014.AHB_HADDR14[1:0] == 2'b00) ? ahbi_m014.AHB_HWDATA14 : {4{ahbi_m014.AHB_HWDATA14[7:0]}};

  apb_subsystem_014 i_apb_subsystem14 (
    // Inputs14
    // system signals14
    .hclk14              (tb_hclk14),     // AHB14 Clock14
    .n_hreset14          (hresetn14),     // AHB14 reset - Active14 low14
    .pclk14              (tb_hclk14),     // APB14 Clock14
    .n_preset14          (hresetn14),     // APB14 reset - Active14 low14
    
    // AHB14 interface for AHB2APM14 bridge14
    .hsel14     (1'b1),        // AHB2APB14 select14
    .haddr14             (ahbi_m014.AHB_HADDR14),        // Address bus
    .htrans14            (ahbi_m014.AHB_HTRANS14),       // Transfer14 type
    .hsize14             (ahbi_m014.AHB_HSIZE14),        // AHB14 Access type - byte half14-word14 word14
    .hwrite14            (ahbi_m014.AHB_HWRITE14),       // Write signal14
    .hwdata14            (hwdata_byte_alligned14),       // Write data
    .hready_in14         (hready14),       // Indicates14 that the last master14 has finished14 
                                       // its bus access
    .hburst14            (ahbi_m014.AHB_HBURST14),       // Burst type
    .hprot14             (ahbi_m014.AHB_HPROT14),        // Protection14 control14
    .hmaster14           (4'h0),      // Master14 select14
    .hmastlock14         (ahbi_m014.AHB_HLOCK14),  // Locked14 transfer14
    // AHB14 interface for SMC14
    .smc_hclk14          (1'b0),
    .smc_n_hclk14        (1'b1),
    .smc_haddr14         (32'd0),
    .smc_htrans14        (2'b00),
    .smc_hsel14          (1'b0),
    .smc_hwrite14        (1'b0),
    .smc_hsize14         (3'd0),
    .smc_hwdata14        (32'd0),
    .smc_hready_in14     (1'b1),
    .smc_hburst14        (3'b000),
    .smc_hprot14         (4'b0000),
    .smc_hmaster14       (4'b0000),
    .smc_hmastlock14     (1'b0),

    //interrupt14 from DMA14
    .DMA_irq14           (1'b0),      

    // Scan14 inputs14
    .scan_en14           (1'b0),         // Scan14 enable pin14
    .scan_in_114         (1'b0),         // Scan14 input for first chain14
    .scan_in_214         (1'b0),        // Scan14 input for second chain14
    .scan_mode14         (1'b0),
    //input for smc14
    .data_smc14          (32'd0),
    //inputs14 for uart14
    .ua_rxd14            (uart_s014.txd14),
    .ua_rxd114           (uart_s114.txd14),
    .ua_ncts14           (uart_s014.cts_n14),
    .ua_ncts114          (uart_s114.cts_n14),
    //inputs14 for spi14
    .n_ss_in14           (1'b1),
    .mi14                (spi_s014.sig_so14),
    .si14                (1'b0),
    .sclk_in14           (1'b0),
    //inputs14 for GPIO14
    .gpio_pin_in14       (gpio_s014.gpio_pin_in14[15:0]),
 
//interrupt14 from Enet14 MAC14
     .macb0_int14     (1'b0),
     .macb1_int14     (1'b0),
     .macb2_int14     (1'b0),
     .macb3_int14     (1'b0),

    // Scan14 outputs14
    .scan_out_114        (),             // Scan14 out for chain14 1
    .scan_out_214        (),             // Scan14 out for chain14 2
   
    //output from APB14 
    // AHB14 interface for AHB2APB14 bridge14
    .hrdata14            (hrdata14),       // Read data provided from target slave14
    .hready14            (hready14),       // Ready14 for new bus cycle from target slave14
    .hresp14             (hresp14),        // Response14 from the bridge14

    // AHB14 interface for SMC14
    .smc_hrdata14        (), 
    .smc_hready14        (),
    .smc_hresp14         (),
  
    //outputs14 from smc14
    .smc_n_ext_oe14      (),
    .smc_data14          (),
    .smc_addr14          (),
    .smc_n_be14          (),
    .smc_n_cs14          (), 
    .smc_n_we14          (),
    .smc_n_wr14          (),
    .smc_n_rd14          (),
    //outputs14 from uart14
    .ua_txd14             (uart_s014.rxd14),
    .ua_txd114            (uart_s114.rxd14),
    .ua_nrts14            (uart_s014.rts_n14),
    .ua_nrts114           (uart_s114.rts_n14),
    // outputs14 from ttc14
    .so                (),
    .mo14                (spi_s014.sig_si14),
    .sclk_out14          (spi_s014.sig_sclk_in14),
    .n_ss_out14          (n_ss_out14[7:0]),
    .n_so_en14           (),
    .n_mo_en14           (),
    .n_sclk_en14         (),
    .n_ss_en14           (),
    //outputs14 from gpio14
    .n_gpio_pin_oe14     (gpio_s014.n_gpio_pin_oe14[15:0]),
    .gpio_pin_out14      (gpio_s014.gpio_pin_out14[15:0]),

//unconnected14 o/p ports14
    .clk_SRPG_macb0_en14(),
    .clk_SRPG_macb1_en14(),
    .clk_SRPG_macb2_en14(),
    .clk_SRPG_macb3_en14(),
    .core06v14(),
    .core08v14(),
    .core10v14(),
    .core12v14(),
    .mte_smc_start14(),
    .mte_uart_start14(),
    .mte_smc_uart_start14(),
    .mte_pm_smc_to_default_start14(),
    .mte_pm_uart_to_default_start14(),
    .mte_pm_smc_uart_to_default_start14(),
    .pcm_irq14(),
    .ttc_irq14(),
    .gpio_irq14(),
    .uart0_irq14(),
    .uart1_irq14(),
    .spi_irq14(),

    .macb3_wakeup14(),
    .macb2_wakeup14(),
    .macb1_wakeup14(),
    .macb0_wakeup14()
);


initial
begin
  tb_hclk14 = 0;
  hresetn14 = 1;

  #1 hresetn14 = 0;
  #1200 hresetn14 = 1;
end

always #50 tb_hclk14 = ~tb_hclk14;

initial begin
  uvm_config_db#(virtual uart_if14)::set(null, "uvm_test_top.ve14.uart014*", "vif14", uart_s014);
  uvm_config_db#(virtual uart_if14)::set(null, "uvm_test_top.ve14.uart114*", "vif14", uart_s114);
  uvm_config_db#(virtual uart_ctrl_internal_if14)::set(null, "uvm_test_top.ve14.apb_ss_env14.apb_uart014.*", "vif14", uart_int014);
  uvm_config_db#(virtual uart_ctrl_internal_if14)::set(null, "uvm_test_top.ve14.apb_ss_env14.apb_uart114.*", "vif14", uart_int114);
  uvm_config_db#(virtual apb_if14)::set(null, "uvm_test_top.ve14.apb014*", "vif14", apbi_mo14);
  uvm_config_db#(virtual ahb_if14)::set(null, "uvm_test_top.ve14.ahb014*", "vif14", ahbi_m014);
  uvm_config_db#(virtual spi_if14)::set(null, "uvm_test_top.ve14.spi014*", "spi_if14", spi_s014);
  uvm_config_db#(virtual gpio_if14)::set(null, "uvm_test_top.ve14.gpio014*", "gpio_if14", gpio_s014);
  run_test();
end

endmodule
