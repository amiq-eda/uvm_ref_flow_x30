/*-------------------------------------------------------------------------
File2 name   : apb_subsystem_top2.v 
Title2       : Top2 level file for the testbench 
Project2     : APB2 Subsystem2
Created2     : March2 2008
Description2 : This2 is top level file which instantiate2 the dut2 apb_subsyste2,.v.
              It also has the assertion2 module which checks2 for the power2 down 
              and power2 up.To2 activate2 the assertion2 ifdef LP_ABV_ON2 is used.       
Notes2       :
-------------------------------------------------------------------------*/ 
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------

 `timescale 1ns/10ps


// Environment2 Constants2
`ifndef AHB_DATA_WIDTH2
  `define AHB_DATA_WIDTH2          32              // AHB2 bus data width [32/64]
`endif
`ifndef AHB_ADDR_WIDTH2
  `define AHB_ADDR_WIDTH2          32              // AHB2 bus address width [32/64]
`endif
`ifndef AHB_DATA_MAX_BIT2
  `define AHB_DATA_MAX_BIT2        31              // MUST2 BE2: AHB_DATA_WIDTH2 - 1
`endif
`ifndef AHB_ADDRESS_MAX_BIT2
  `define AHB_ADDRESS_MAX_BIT2     31              // MUST2 BE2: AHB_ADDR_WIDTH2 - 1
`endif
`ifndef DEFAULT_HREADY_VALUE2
  `define DEFAULT_HREADY_VALUE2    1'b1            // Ready2 Asserted2
`endif

`include "ahb_if2.sv"
`include "apb_if2.sv"
`include "apb_master_if2.sv"
`include "apb_slave_if2.sv"
`include "uart_if2.sv"
`include "spi_if2.sv"
`include "gpio_if2.sv"
`include "coverage2/uart_ctrl_internal_if2.sv"

module apb_subsystem_top2;
  import uvm_pkg::*;
  // Import2 the UVM Utilities2 Package2

  import ahb_pkg2::*;
  import apb_pkg2::*;
  import uart_pkg2::*;
  import gpio_pkg2::*;
  import spi_pkg2::*;
  import uart_ctrl_pkg2::*;
  import apb_subsystem_pkg2::*;

  `include "spi_reg_model2.sv"
  `include "gpio_reg_model2.sv"
  `include "apb_subsystem_reg_rdb2.sv"
  `include "uart_ctrl_reg_seq_lib2.sv"
  `include "spi_reg_seq_lib2.sv"
  `include "gpio_reg_seq_lib2.sv"

  //Include2 module UVC2 sequences
  `include "ahb_user_monitor2.sv"
  `include "apb_subsystem_seq_lib2.sv"
  `include "apb_subsystem_vir_sequencer2.sv"
  `include "apb_subsystem_vir_seq_lib2.sv"

  `include "apb_subsystem_tb2.sv"
  `include "test_lib2.sv"
   
  
   // ====================================
   // SHARED2 signals2
   // ====================================
   
   // clock2
   reg tb_hclk2;
   
   // reset
   reg hresetn2;
   
   // post2-mux2 from master2 mux2
   wire [`AHB_DATA_MAX_BIT2:0] hwdata2;
   wire [`AHB_ADDRESS_MAX_BIT2:0] haddr2;
   wire [1:0]  htrans2;
   wire [2:0]  hburst2;
   wire [2:0]  hsize2;
   wire [3:0]  hprot2;
   wire hwrite2;

   // post2-mux2 from slave2 mux2
   wire        hready2;
   wire [1:0]  hresp2;
   wire [`AHB_DATA_MAX_BIT2:0] hrdata2;
  

  //  Specific2 signals2 of apb2 subsystem2
  reg         ua_rxd2;
  reg         ua_ncts2;


  // uart2 outputs2 
  wire        ua_txd2;
  wire        us_nrts2;

  wire   [7:0] n_ss_out2;    // peripheral2 select2 lines2 from master2
  wire   [31:0] hwdata_byte_alligned2;

  reg [2:0] div8_clk2;
 always @(posedge tb_hclk2) begin
   if (!hresetn2)
     div8_clk2 = 3'b000;
   else
     div8_clk2 = div8_clk2 + 1;
 end


  // Master2 virtual interface
  ahb_if2 ahbi_m02(.ahb_clock2(tb_hclk2), .ahb_resetn2(hresetn2));
  
  uart_if2 uart_s02(.clock2(div8_clk2[2]), .reset(hresetn2));
  uart_if2 uart_s12(.clock2(div8_clk2[2]), .reset(hresetn2));
  spi_if2 spi_s02();
  gpio_if2 gpio_s02();
  uart_ctrl_internal_if2 uart_int02(.clock2(div8_clk2[2]));
  uart_ctrl_internal_if2 uart_int12(.clock2(div8_clk2[2]));

  apb_if2 apbi_mo2(.pclock2(tb_hclk2), .preset2(hresetn2));

  //M02
  assign ahbi_m02.AHB_HCLK2 = tb_hclk2;
  assign ahbi_m02.AHB_HRESET2 = hresetn2;
  assign ahbi_m02.AHB_HRESP2 = hresp2;
  assign ahbi_m02.AHB_HRDATA2 = hrdata2;
  assign ahbi_m02.AHB_HREADY2 = hready2;

  assign apbi_mo2.paddr2 = i_apb_subsystem2.i_ahb2apb2.paddr2;
  assign apbi_mo2.prwd2 = i_apb_subsystem2.i_ahb2apb2.pwrite2;
  assign apbi_mo2.pwdata2 = i_apb_subsystem2.i_ahb2apb2.pwdata2;
  assign apbi_mo2.penable2 = i_apb_subsystem2.i_ahb2apb2.penable2;
  assign apbi_mo2.psel2 = {12'b0, i_apb_subsystem2.i_ahb2apb2.psel82, i_apb_subsystem2.i_ahb2apb2.psel22, i_apb_subsystem2.i_ahb2apb2.psel12, i_apb_subsystem2.i_ahb2apb2.psel02};
  assign apbi_mo2.prdata2 = i_apb_subsystem2.i_ahb2apb2.psel02? i_apb_subsystem2.i_ahb2apb2.prdata02 : (i_apb_subsystem2.i_ahb2apb2.psel12? i_apb_subsystem2.i_ahb2apb2.prdata12 : (i_apb_subsystem2.i_ahb2apb2.psel22? i_apb_subsystem2.i_ahb2apb2.prdata22 : i_apb_subsystem2.i_ahb2apb2.prdata82));

  assign spi_s02.sig_n_ss_in2 = n_ss_out2[0];
  assign spi_s02.sig_n_p_reset2 = hresetn2;
  assign spi_s02.sig_pclk2 = tb_hclk2;

  assign gpio_s02.n_p_reset2 = hresetn2;
  assign gpio_s02.pclk2 = tb_hclk2;

  assign hwdata_byte_alligned2 = (ahbi_m02.AHB_HADDR2[1:0] == 2'b00) ? ahbi_m02.AHB_HWDATA2 : {4{ahbi_m02.AHB_HWDATA2[7:0]}};

  apb_subsystem_02 i_apb_subsystem2 (
    // Inputs2
    // system signals2
    .hclk2              (tb_hclk2),     // AHB2 Clock2
    .n_hreset2          (hresetn2),     // AHB2 reset - Active2 low2
    .pclk2              (tb_hclk2),     // APB2 Clock2
    .n_preset2          (hresetn2),     // APB2 reset - Active2 low2
    
    // AHB2 interface for AHB2APM2 bridge2
    .hsel2     (1'b1),        // AHB2APB2 select2
    .haddr2             (ahbi_m02.AHB_HADDR2),        // Address bus
    .htrans2            (ahbi_m02.AHB_HTRANS2),       // Transfer2 type
    .hsize2             (ahbi_m02.AHB_HSIZE2),        // AHB2 Access type - byte half2-word2 word2
    .hwrite2            (ahbi_m02.AHB_HWRITE2),       // Write signal2
    .hwdata2            (hwdata_byte_alligned2),       // Write data
    .hready_in2         (hready2),       // Indicates2 that the last master2 has finished2 
                                       // its bus access
    .hburst2            (ahbi_m02.AHB_HBURST2),       // Burst type
    .hprot2             (ahbi_m02.AHB_HPROT2),        // Protection2 control2
    .hmaster2           (4'h0),      // Master2 select2
    .hmastlock2         (ahbi_m02.AHB_HLOCK2),  // Locked2 transfer2
    // AHB2 interface for SMC2
    .smc_hclk2          (1'b0),
    .smc_n_hclk2        (1'b1),
    .smc_haddr2         (32'd0),
    .smc_htrans2        (2'b00),
    .smc_hsel2          (1'b0),
    .smc_hwrite2        (1'b0),
    .smc_hsize2         (3'd0),
    .smc_hwdata2        (32'd0),
    .smc_hready_in2     (1'b1),
    .smc_hburst2        (3'b000),
    .smc_hprot2         (4'b0000),
    .smc_hmaster2       (4'b0000),
    .smc_hmastlock2     (1'b0),

    //interrupt2 from DMA2
    .DMA_irq2           (1'b0),      

    // Scan2 inputs2
    .scan_en2           (1'b0),         // Scan2 enable pin2
    .scan_in_12         (1'b0),         // Scan2 input for first chain2
    .scan_in_22         (1'b0),        // Scan2 input for second chain2
    .scan_mode2         (1'b0),
    //input for smc2
    .data_smc2          (32'd0),
    //inputs2 for uart2
    .ua_rxd2            (uart_s02.txd2),
    .ua_rxd12           (uart_s12.txd2),
    .ua_ncts2           (uart_s02.cts_n2),
    .ua_ncts12          (uart_s12.cts_n2),
    //inputs2 for spi2
    .n_ss_in2           (1'b1),
    .mi2                (spi_s02.sig_so2),
    .si2                (1'b0),
    .sclk_in2           (1'b0),
    //inputs2 for GPIO2
    .gpio_pin_in2       (gpio_s02.gpio_pin_in2[15:0]),
 
//interrupt2 from Enet2 MAC2
     .macb0_int2     (1'b0),
     .macb1_int2     (1'b0),
     .macb2_int2     (1'b0),
     .macb3_int2     (1'b0),

    // Scan2 outputs2
    .scan_out_12        (),             // Scan2 out for chain2 1
    .scan_out_22        (),             // Scan2 out for chain2 2
   
    //output from APB2 
    // AHB2 interface for AHB2APB2 bridge2
    .hrdata2            (hrdata2),       // Read data provided from target slave2
    .hready2            (hready2),       // Ready2 for new bus cycle from target slave2
    .hresp2             (hresp2),        // Response2 from the bridge2

    // AHB2 interface for SMC2
    .smc_hrdata2        (), 
    .smc_hready2        (),
    .smc_hresp2         (),
  
    //outputs2 from smc2
    .smc_n_ext_oe2      (),
    .smc_data2          (),
    .smc_addr2          (),
    .smc_n_be2          (),
    .smc_n_cs2          (), 
    .smc_n_we2          (),
    .smc_n_wr2          (),
    .smc_n_rd2          (),
    //outputs2 from uart2
    .ua_txd2             (uart_s02.rxd2),
    .ua_txd12            (uart_s12.rxd2),
    .ua_nrts2            (uart_s02.rts_n2),
    .ua_nrts12           (uart_s12.rts_n2),
    // outputs2 from ttc2
    .so                (),
    .mo2                (spi_s02.sig_si2),
    .sclk_out2          (spi_s02.sig_sclk_in2),
    .n_ss_out2          (n_ss_out2[7:0]),
    .n_so_en2           (),
    .n_mo_en2           (),
    .n_sclk_en2         (),
    .n_ss_en2           (),
    //outputs2 from gpio2
    .n_gpio_pin_oe2     (gpio_s02.n_gpio_pin_oe2[15:0]),
    .gpio_pin_out2      (gpio_s02.gpio_pin_out2[15:0]),

//unconnected2 o/p ports2
    .clk_SRPG_macb0_en2(),
    .clk_SRPG_macb1_en2(),
    .clk_SRPG_macb2_en2(),
    .clk_SRPG_macb3_en2(),
    .core06v2(),
    .core08v2(),
    .core10v2(),
    .core12v2(),
    .mte_smc_start2(),
    .mte_uart_start2(),
    .mte_smc_uart_start2(),
    .mte_pm_smc_to_default_start2(),
    .mte_pm_uart_to_default_start2(),
    .mte_pm_smc_uart_to_default_start2(),
    .pcm_irq2(),
    .ttc_irq2(),
    .gpio_irq2(),
    .uart0_irq2(),
    .uart1_irq2(),
    .spi_irq2(),

    .macb3_wakeup2(),
    .macb2_wakeup2(),
    .macb1_wakeup2(),
    .macb0_wakeup2()
);


initial
begin
  tb_hclk2 = 0;
  hresetn2 = 1;

  #1 hresetn2 = 0;
  #1200 hresetn2 = 1;
end

always #50 tb_hclk2 = ~tb_hclk2;

initial begin
  uvm_config_db#(virtual uart_if2)::set(null, "uvm_test_top.ve2.uart02*", "vif2", uart_s02);
  uvm_config_db#(virtual uart_if2)::set(null, "uvm_test_top.ve2.uart12*", "vif2", uart_s12);
  uvm_config_db#(virtual uart_ctrl_internal_if2)::set(null, "uvm_test_top.ve2.apb_ss_env2.apb_uart02.*", "vif2", uart_int02);
  uvm_config_db#(virtual uart_ctrl_internal_if2)::set(null, "uvm_test_top.ve2.apb_ss_env2.apb_uart12.*", "vif2", uart_int12);
  uvm_config_db#(virtual apb_if2)::set(null, "uvm_test_top.ve2.apb02*", "vif2", apbi_mo2);
  uvm_config_db#(virtual ahb_if2)::set(null, "uvm_test_top.ve2.ahb02*", "vif2", ahbi_m02);
  uvm_config_db#(virtual spi_if2)::set(null, "uvm_test_top.ve2.spi02*", "spi_if2", spi_s02);
  uvm_config_db#(virtual gpio_if2)::set(null, "uvm_test_top.ve2.gpio02*", "gpio_if2", gpio_s02);
  run_test();
end

endmodule
