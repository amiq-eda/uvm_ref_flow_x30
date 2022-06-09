/*-------------------------------------------------------------------------
File1 name   : apb_subsystem_top1.v 
Title1       : Top1 level file for the testbench 
Project1     : APB1 Subsystem1
Created1     : March1 2008
Description1 : This1 is top level file which instantiate1 the dut1 apb_subsyste1,.v.
              It also has the assertion1 module which checks1 for the power1 down 
              and power1 up.To1 activate1 the assertion1 ifdef LP_ABV_ON1 is used.       
Notes1       :
-------------------------------------------------------------------------*/ 
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------

 `timescale 1ns/10ps


// Environment1 Constants1
`ifndef AHB_DATA_WIDTH1
  `define AHB_DATA_WIDTH1          32              // AHB1 bus data width [32/64]
`endif
`ifndef AHB_ADDR_WIDTH1
  `define AHB_ADDR_WIDTH1          32              // AHB1 bus address width [32/64]
`endif
`ifndef AHB_DATA_MAX_BIT1
  `define AHB_DATA_MAX_BIT1        31              // MUST1 BE1: AHB_DATA_WIDTH1 - 1
`endif
`ifndef AHB_ADDRESS_MAX_BIT1
  `define AHB_ADDRESS_MAX_BIT1     31              // MUST1 BE1: AHB_ADDR_WIDTH1 - 1
`endif
`ifndef DEFAULT_HREADY_VALUE1
  `define DEFAULT_HREADY_VALUE1    1'b1            // Ready1 Asserted1
`endif

`include "ahb_if1.sv"
`include "apb_if1.sv"
`include "apb_master_if1.sv"
`include "apb_slave_if1.sv"
`include "uart_if1.sv"
`include "spi_if1.sv"
`include "gpio_if1.sv"
`include "coverage1/uart_ctrl_internal_if1.sv"

module apb_subsystem_top1;
  import uvm_pkg::*;
  // Import1 the UVM Utilities1 Package1

  import ahb_pkg1::*;
  import apb_pkg1::*;
  import uart_pkg1::*;
  import gpio_pkg1::*;
  import spi_pkg1::*;
  import uart_ctrl_pkg1::*;
  import apb_subsystem_pkg1::*;

  `include "spi_reg_model1.sv"
  `include "gpio_reg_model1.sv"
  `include "apb_subsystem_reg_rdb1.sv"
  `include "uart_ctrl_reg_seq_lib1.sv"
  `include "spi_reg_seq_lib1.sv"
  `include "gpio_reg_seq_lib1.sv"

  //Include1 module UVC1 sequences
  `include "ahb_user_monitor1.sv"
  `include "apb_subsystem_seq_lib1.sv"
  `include "apb_subsystem_vir_sequencer1.sv"
  `include "apb_subsystem_vir_seq_lib1.sv"

  `include "apb_subsystem_tb1.sv"
  `include "test_lib1.sv"
   
  
   // ====================================
   // SHARED1 signals1
   // ====================================
   
   // clock1
   reg tb_hclk1;
   
   // reset
   reg hresetn1;
   
   // post1-mux1 from master1 mux1
   wire [`AHB_DATA_MAX_BIT1:0] hwdata1;
   wire [`AHB_ADDRESS_MAX_BIT1:0] haddr1;
   wire [1:0]  htrans1;
   wire [2:0]  hburst1;
   wire [2:0]  hsize1;
   wire [3:0]  hprot1;
   wire hwrite1;

   // post1-mux1 from slave1 mux1
   wire        hready1;
   wire [1:0]  hresp1;
   wire [`AHB_DATA_MAX_BIT1:0] hrdata1;
  

  //  Specific1 signals1 of apb1 subsystem1
  reg         ua_rxd1;
  reg         ua_ncts1;


  // uart1 outputs1 
  wire        ua_txd1;
  wire        us_nrts1;

  wire   [7:0] n_ss_out1;    // peripheral1 select1 lines1 from master1
  wire   [31:0] hwdata_byte_alligned1;

  reg [2:0] div8_clk1;
 always @(posedge tb_hclk1) begin
   if (!hresetn1)
     div8_clk1 = 3'b000;
   else
     div8_clk1 = div8_clk1 + 1;
 end


  // Master1 virtual interface
  ahb_if1 ahbi_m01(.ahb_clock1(tb_hclk1), .ahb_resetn1(hresetn1));
  
  uart_if1 uart_s01(.clock1(div8_clk1[2]), .reset(hresetn1));
  uart_if1 uart_s11(.clock1(div8_clk1[2]), .reset(hresetn1));
  spi_if1 spi_s01();
  gpio_if1 gpio_s01();
  uart_ctrl_internal_if1 uart_int01(.clock1(div8_clk1[2]));
  uart_ctrl_internal_if1 uart_int11(.clock1(div8_clk1[2]));

  apb_if1 apbi_mo1(.pclock1(tb_hclk1), .preset1(hresetn1));

  //M01
  assign ahbi_m01.AHB_HCLK1 = tb_hclk1;
  assign ahbi_m01.AHB_HRESET1 = hresetn1;
  assign ahbi_m01.AHB_HRESP1 = hresp1;
  assign ahbi_m01.AHB_HRDATA1 = hrdata1;
  assign ahbi_m01.AHB_HREADY1 = hready1;

  assign apbi_mo1.paddr1 = i_apb_subsystem1.i_ahb2apb1.paddr1;
  assign apbi_mo1.prwd1 = i_apb_subsystem1.i_ahb2apb1.pwrite1;
  assign apbi_mo1.pwdata1 = i_apb_subsystem1.i_ahb2apb1.pwdata1;
  assign apbi_mo1.penable1 = i_apb_subsystem1.i_ahb2apb1.penable1;
  assign apbi_mo1.psel1 = {12'b0, i_apb_subsystem1.i_ahb2apb1.psel81, i_apb_subsystem1.i_ahb2apb1.psel21, i_apb_subsystem1.i_ahb2apb1.psel11, i_apb_subsystem1.i_ahb2apb1.psel01};
  assign apbi_mo1.prdata1 = i_apb_subsystem1.i_ahb2apb1.psel01? i_apb_subsystem1.i_ahb2apb1.prdata01 : (i_apb_subsystem1.i_ahb2apb1.psel11? i_apb_subsystem1.i_ahb2apb1.prdata11 : (i_apb_subsystem1.i_ahb2apb1.psel21? i_apb_subsystem1.i_ahb2apb1.prdata21 : i_apb_subsystem1.i_ahb2apb1.prdata81));

  assign spi_s01.sig_n_ss_in1 = n_ss_out1[0];
  assign spi_s01.sig_n_p_reset1 = hresetn1;
  assign spi_s01.sig_pclk1 = tb_hclk1;

  assign gpio_s01.n_p_reset1 = hresetn1;
  assign gpio_s01.pclk1 = tb_hclk1;

  assign hwdata_byte_alligned1 = (ahbi_m01.AHB_HADDR1[1:0] == 2'b00) ? ahbi_m01.AHB_HWDATA1 : {4{ahbi_m01.AHB_HWDATA1[7:0]}};

  apb_subsystem_01 i_apb_subsystem1 (
    // Inputs1
    // system signals1
    .hclk1              (tb_hclk1),     // AHB1 Clock1
    .n_hreset1          (hresetn1),     // AHB1 reset - Active1 low1
    .pclk1              (tb_hclk1),     // APB1 Clock1
    .n_preset1          (hresetn1),     // APB1 reset - Active1 low1
    
    // AHB1 interface for AHB2APM1 bridge1
    .hsel1     (1'b1),        // AHB2APB1 select1
    .haddr1             (ahbi_m01.AHB_HADDR1),        // Address bus
    .htrans1            (ahbi_m01.AHB_HTRANS1),       // Transfer1 type
    .hsize1             (ahbi_m01.AHB_HSIZE1),        // AHB1 Access type - byte half1-word1 word1
    .hwrite1            (ahbi_m01.AHB_HWRITE1),       // Write signal1
    .hwdata1            (hwdata_byte_alligned1),       // Write data
    .hready_in1         (hready1),       // Indicates1 that the last master1 has finished1 
                                       // its bus access
    .hburst1            (ahbi_m01.AHB_HBURST1),       // Burst type
    .hprot1             (ahbi_m01.AHB_HPROT1),        // Protection1 control1
    .hmaster1           (4'h0),      // Master1 select1
    .hmastlock1         (ahbi_m01.AHB_HLOCK1),  // Locked1 transfer1
    // AHB1 interface for SMC1
    .smc_hclk1          (1'b0),
    .smc_n_hclk1        (1'b1),
    .smc_haddr1         (32'd0),
    .smc_htrans1        (2'b00),
    .smc_hsel1          (1'b0),
    .smc_hwrite1        (1'b0),
    .smc_hsize1         (3'd0),
    .smc_hwdata1        (32'd0),
    .smc_hready_in1     (1'b1),
    .smc_hburst1        (3'b000),
    .smc_hprot1         (4'b0000),
    .smc_hmaster1       (4'b0000),
    .smc_hmastlock1     (1'b0),

    //interrupt1 from DMA1
    .DMA_irq1           (1'b0),      

    // Scan1 inputs1
    .scan_en1           (1'b0),         // Scan1 enable pin1
    .scan_in_11         (1'b0),         // Scan1 input for first chain1
    .scan_in_21         (1'b0),        // Scan1 input for second chain1
    .scan_mode1         (1'b0),
    //input for smc1
    .data_smc1          (32'd0),
    //inputs1 for uart1
    .ua_rxd1            (uart_s01.txd1),
    .ua_rxd11           (uart_s11.txd1),
    .ua_ncts1           (uart_s01.cts_n1),
    .ua_ncts11          (uart_s11.cts_n1),
    //inputs1 for spi1
    .n_ss_in1           (1'b1),
    .mi1                (spi_s01.sig_so1),
    .si1                (1'b0),
    .sclk_in1           (1'b0),
    //inputs1 for GPIO1
    .gpio_pin_in1       (gpio_s01.gpio_pin_in1[15:0]),
 
//interrupt1 from Enet1 MAC1
     .macb0_int1     (1'b0),
     .macb1_int1     (1'b0),
     .macb2_int1     (1'b0),
     .macb3_int1     (1'b0),

    // Scan1 outputs1
    .scan_out_11        (),             // Scan1 out for chain1 1
    .scan_out_21        (),             // Scan1 out for chain1 2
   
    //output from APB1 
    // AHB1 interface for AHB2APB1 bridge1
    .hrdata1            (hrdata1),       // Read data provided from target slave1
    .hready1            (hready1),       // Ready1 for new bus cycle from target slave1
    .hresp1             (hresp1),        // Response1 from the bridge1

    // AHB1 interface for SMC1
    .smc_hrdata1        (), 
    .smc_hready1        (),
    .smc_hresp1         (),
  
    //outputs1 from smc1
    .smc_n_ext_oe1      (),
    .smc_data1          (),
    .smc_addr1          (),
    .smc_n_be1          (),
    .smc_n_cs1          (), 
    .smc_n_we1          (),
    .smc_n_wr1          (),
    .smc_n_rd1          (),
    //outputs1 from uart1
    .ua_txd1             (uart_s01.rxd1),
    .ua_txd11            (uart_s11.rxd1),
    .ua_nrts1            (uart_s01.rts_n1),
    .ua_nrts11           (uart_s11.rts_n1),
    // outputs1 from ttc1
    .so                (),
    .mo1                (spi_s01.sig_si1),
    .sclk_out1          (spi_s01.sig_sclk_in1),
    .n_ss_out1          (n_ss_out1[7:0]),
    .n_so_en1           (),
    .n_mo_en1           (),
    .n_sclk_en1         (),
    .n_ss_en1           (),
    //outputs1 from gpio1
    .n_gpio_pin_oe1     (gpio_s01.n_gpio_pin_oe1[15:0]),
    .gpio_pin_out1      (gpio_s01.gpio_pin_out1[15:0]),

//unconnected1 o/p ports1
    .clk_SRPG_macb0_en1(),
    .clk_SRPG_macb1_en1(),
    .clk_SRPG_macb2_en1(),
    .clk_SRPG_macb3_en1(),
    .core06v1(),
    .core08v1(),
    .core10v1(),
    .core12v1(),
    .mte_smc_start1(),
    .mte_uart_start1(),
    .mte_smc_uart_start1(),
    .mte_pm_smc_to_default_start1(),
    .mte_pm_uart_to_default_start1(),
    .mte_pm_smc_uart_to_default_start1(),
    .pcm_irq1(),
    .ttc_irq1(),
    .gpio_irq1(),
    .uart0_irq1(),
    .uart1_irq1(),
    .spi_irq1(),

    .macb3_wakeup1(),
    .macb2_wakeup1(),
    .macb1_wakeup1(),
    .macb0_wakeup1()
);


initial
begin
  tb_hclk1 = 0;
  hresetn1 = 1;

  #1 hresetn1 = 0;
  #1200 hresetn1 = 1;
end

always #50 tb_hclk1 = ~tb_hclk1;

initial begin
  uvm_config_db#(virtual uart_if1)::set(null, "uvm_test_top.ve1.uart01*", "vif1", uart_s01);
  uvm_config_db#(virtual uart_if1)::set(null, "uvm_test_top.ve1.uart11*", "vif1", uart_s11);
  uvm_config_db#(virtual uart_ctrl_internal_if1)::set(null, "uvm_test_top.ve1.apb_ss_env1.apb_uart01.*", "vif1", uart_int01);
  uvm_config_db#(virtual uart_ctrl_internal_if1)::set(null, "uvm_test_top.ve1.apb_ss_env1.apb_uart11.*", "vif1", uart_int11);
  uvm_config_db#(virtual apb_if1)::set(null, "uvm_test_top.ve1.apb01*", "vif1", apbi_mo1);
  uvm_config_db#(virtual ahb_if1)::set(null, "uvm_test_top.ve1.ahb01*", "vif1", ahbi_m01);
  uvm_config_db#(virtual spi_if1)::set(null, "uvm_test_top.ve1.spi01*", "spi_if1", spi_s01);
  uvm_config_db#(virtual gpio_if1)::set(null, "uvm_test_top.ve1.gpio01*", "gpio_if1", gpio_s01);
  run_test();
end

endmodule
