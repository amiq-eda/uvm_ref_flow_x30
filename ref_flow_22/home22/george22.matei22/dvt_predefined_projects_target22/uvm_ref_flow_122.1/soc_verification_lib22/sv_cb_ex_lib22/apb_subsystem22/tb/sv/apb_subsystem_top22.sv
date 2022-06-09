/*-------------------------------------------------------------------------
File22 name   : apb_subsystem_top22.v 
Title22       : Top22 level file for the testbench 
Project22     : APB22 Subsystem22
Created22     : March22 2008
Description22 : This22 is top level file which instantiate22 the dut22 apb_subsyste22,.v.
              It also has the assertion22 module which checks22 for the power22 down 
              and power22 up.To22 activate22 the assertion22 ifdef LP_ABV_ON22 is used.       
Notes22       :
-------------------------------------------------------------------------*/ 
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------

 `timescale 1ns/10ps


// Environment22 Constants22
`ifndef AHB_DATA_WIDTH22
  `define AHB_DATA_WIDTH22          32              // AHB22 bus data width [32/64]
`endif
`ifndef AHB_ADDR_WIDTH22
  `define AHB_ADDR_WIDTH22          32              // AHB22 bus address width [32/64]
`endif
`ifndef AHB_DATA_MAX_BIT22
  `define AHB_DATA_MAX_BIT22        31              // MUST22 BE22: AHB_DATA_WIDTH22 - 1
`endif
`ifndef AHB_ADDRESS_MAX_BIT22
  `define AHB_ADDRESS_MAX_BIT22     31              // MUST22 BE22: AHB_ADDR_WIDTH22 - 1
`endif
`ifndef DEFAULT_HREADY_VALUE22
  `define DEFAULT_HREADY_VALUE22    1'b1            // Ready22 Asserted22
`endif

`include "ahb_if22.sv"
`include "apb_if22.sv"
`include "apb_master_if22.sv"
`include "apb_slave_if22.sv"
`include "uart_if22.sv"
`include "spi_if22.sv"
`include "gpio_if22.sv"
`include "coverage22/uart_ctrl_internal_if22.sv"

module apb_subsystem_top22;
  import uvm_pkg::*;
  // Import22 the UVM Utilities22 Package22

  import ahb_pkg22::*;
  import apb_pkg22::*;
  import uart_pkg22::*;
  import gpio_pkg22::*;
  import spi_pkg22::*;
  import uart_ctrl_pkg22::*;
  import apb_subsystem_pkg22::*;

  `include "spi_reg_model22.sv"
  `include "gpio_reg_model22.sv"
  `include "apb_subsystem_reg_rdb22.sv"
  `include "uart_ctrl_reg_seq_lib22.sv"
  `include "spi_reg_seq_lib22.sv"
  `include "gpio_reg_seq_lib22.sv"

  //Include22 module UVC22 sequences
  `include "ahb_user_monitor22.sv"
  `include "apb_subsystem_seq_lib22.sv"
  `include "apb_subsystem_vir_sequencer22.sv"
  `include "apb_subsystem_vir_seq_lib22.sv"

  `include "apb_subsystem_tb22.sv"
  `include "test_lib22.sv"
   
  
   // ====================================
   // SHARED22 signals22
   // ====================================
   
   // clock22
   reg tb_hclk22;
   
   // reset
   reg hresetn22;
   
   // post22-mux22 from master22 mux22
   wire [`AHB_DATA_MAX_BIT22:0] hwdata22;
   wire [`AHB_ADDRESS_MAX_BIT22:0] haddr22;
   wire [1:0]  htrans22;
   wire [2:0]  hburst22;
   wire [2:0]  hsize22;
   wire [3:0]  hprot22;
   wire hwrite22;

   // post22-mux22 from slave22 mux22
   wire        hready22;
   wire [1:0]  hresp22;
   wire [`AHB_DATA_MAX_BIT22:0] hrdata22;
  

  //  Specific22 signals22 of apb22 subsystem22
  reg         ua_rxd22;
  reg         ua_ncts22;


  // uart22 outputs22 
  wire        ua_txd22;
  wire        us_nrts22;

  wire   [7:0] n_ss_out22;    // peripheral22 select22 lines22 from master22
  wire   [31:0] hwdata_byte_alligned22;

  reg [2:0] div8_clk22;
 always @(posedge tb_hclk22) begin
   if (!hresetn22)
     div8_clk22 = 3'b000;
   else
     div8_clk22 = div8_clk22 + 1;
 end


  // Master22 virtual interface
  ahb_if22 ahbi_m022(.ahb_clock22(tb_hclk22), .ahb_resetn22(hresetn22));
  
  uart_if22 uart_s022(.clock22(div8_clk22[2]), .reset(hresetn22));
  uart_if22 uart_s122(.clock22(div8_clk22[2]), .reset(hresetn22));
  spi_if22 spi_s022();
  gpio_if22 gpio_s022();
  uart_ctrl_internal_if22 uart_int022(.clock22(div8_clk22[2]));
  uart_ctrl_internal_if22 uart_int122(.clock22(div8_clk22[2]));

  apb_if22 apbi_mo22(.pclock22(tb_hclk22), .preset22(hresetn22));

  //M022
  assign ahbi_m022.AHB_HCLK22 = tb_hclk22;
  assign ahbi_m022.AHB_HRESET22 = hresetn22;
  assign ahbi_m022.AHB_HRESP22 = hresp22;
  assign ahbi_m022.AHB_HRDATA22 = hrdata22;
  assign ahbi_m022.AHB_HREADY22 = hready22;

  assign apbi_mo22.paddr22 = i_apb_subsystem22.i_ahb2apb22.paddr22;
  assign apbi_mo22.prwd22 = i_apb_subsystem22.i_ahb2apb22.pwrite22;
  assign apbi_mo22.pwdata22 = i_apb_subsystem22.i_ahb2apb22.pwdata22;
  assign apbi_mo22.penable22 = i_apb_subsystem22.i_ahb2apb22.penable22;
  assign apbi_mo22.psel22 = {12'b0, i_apb_subsystem22.i_ahb2apb22.psel822, i_apb_subsystem22.i_ahb2apb22.psel222, i_apb_subsystem22.i_ahb2apb22.psel122, i_apb_subsystem22.i_ahb2apb22.psel022};
  assign apbi_mo22.prdata22 = i_apb_subsystem22.i_ahb2apb22.psel022? i_apb_subsystem22.i_ahb2apb22.prdata022 : (i_apb_subsystem22.i_ahb2apb22.psel122? i_apb_subsystem22.i_ahb2apb22.prdata122 : (i_apb_subsystem22.i_ahb2apb22.psel222? i_apb_subsystem22.i_ahb2apb22.prdata222 : i_apb_subsystem22.i_ahb2apb22.prdata822));

  assign spi_s022.sig_n_ss_in22 = n_ss_out22[0];
  assign spi_s022.sig_n_p_reset22 = hresetn22;
  assign spi_s022.sig_pclk22 = tb_hclk22;

  assign gpio_s022.n_p_reset22 = hresetn22;
  assign gpio_s022.pclk22 = tb_hclk22;

  assign hwdata_byte_alligned22 = (ahbi_m022.AHB_HADDR22[1:0] == 2'b00) ? ahbi_m022.AHB_HWDATA22 : {4{ahbi_m022.AHB_HWDATA22[7:0]}};

  apb_subsystem_022 i_apb_subsystem22 (
    // Inputs22
    // system signals22
    .hclk22              (tb_hclk22),     // AHB22 Clock22
    .n_hreset22          (hresetn22),     // AHB22 reset - Active22 low22
    .pclk22              (tb_hclk22),     // APB22 Clock22
    .n_preset22          (hresetn22),     // APB22 reset - Active22 low22
    
    // AHB22 interface for AHB2APM22 bridge22
    .hsel22     (1'b1),        // AHB2APB22 select22
    .haddr22             (ahbi_m022.AHB_HADDR22),        // Address bus
    .htrans22            (ahbi_m022.AHB_HTRANS22),       // Transfer22 type
    .hsize22             (ahbi_m022.AHB_HSIZE22),        // AHB22 Access type - byte half22-word22 word22
    .hwrite22            (ahbi_m022.AHB_HWRITE22),       // Write signal22
    .hwdata22            (hwdata_byte_alligned22),       // Write data
    .hready_in22         (hready22),       // Indicates22 that the last master22 has finished22 
                                       // its bus access
    .hburst22            (ahbi_m022.AHB_HBURST22),       // Burst type
    .hprot22             (ahbi_m022.AHB_HPROT22),        // Protection22 control22
    .hmaster22           (4'h0),      // Master22 select22
    .hmastlock22         (ahbi_m022.AHB_HLOCK22),  // Locked22 transfer22
    // AHB22 interface for SMC22
    .smc_hclk22          (1'b0),
    .smc_n_hclk22        (1'b1),
    .smc_haddr22         (32'd0),
    .smc_htrans22        (2'b00),
    .smc_hsel22          (1'b0),
    .smc_hwrite22        (1'b0),
    .smc_hsize22         (3'd0),
    .smc_hwdata22        (32'd0),
    .smc_hready_in22     (1'b1),
    .smc_hburst22        (3'b000),
    .smc_hprot22         (4'b0000),
    .smc_hmaster22       (4'b0000),
    .smc_hmastlock22     (1'b0),

    //interrupt22 from DMA22
    .DMA_irq22           (1'b0),      

    // Scan22 inputs22
    .scan_en22           (1'b0),         // Scan22 enable pin22
    .scan_in_122         (1'b0),         // Scan22 input for first chain22
    .scan_in_222         (1'b0),        // Scan22 input for second chain22
    .scan_mode22         (1'b0),
    //input for smc22
    .data_smc22          (32'd0),
    //inputs22 for uart22
    .ua_rxd22            (uart_s022.txd22),
    .ua_rxd122           (uart_s122.txd22),
    .ua_ncts22           (uart_s022.cts_n22),
    .ua_ncts122          (uart_s122.cts_n22),
    //inputs22 for spi22
    .n_ss_in22           (1'b1),
    .mi22                (spi_s022.sig_so22),
    .si22                (1'b0),
    .sclk_in22           (1'b0),
    //inputs22 for GPIO22
    .gpio_pin_in22       (gpio_s022.gpio_pin_in22[15:0]),
 
//interrupt22 from Enet22 MAC22
     .macb0_int22     (1'b0),
     .macb1_int22     (1'b0),
     .macb2_int22     (1'b0),
     .macb3_int22     (1'b0),

    // Scan22 outputs22
    .scan_out_122        (),             // Scan22 out for chain22 1
    .scan_out_222        (),             // Scan22 out for chain22 2
   
    //output from APB22 
    // AHB22 interface for AHB2APB22 bridge22
    .hrdata22            (hrdata22),       // Read data provided from target slave22
    .hready22            (hready22),       // Ready22 for new bus cycle from target slave22
    .hresp22             (hresp22),        // Response22 from the bridge22

    // AHB22 interface for SMC22
    .smc_hrdata22        (), 
    .smc_hready22        (),
    .smc_hresp22         (),
  
    //outputs22 from smc22
    .smc_n_ext_oe22      (),
    .smc_data22          (),
    .smc_addr22          (),
    .smc_n_be22          (),
    .smc_n_cs22          (), 
    .smc_n_we22          (),
    .smc_n_wr22          (),
    .smc_n_rd22          (),
    //outputs22 from uart22
    .ua_txd22             (uart_s022.rxd22),
    .ua_txd122            (uart_s122.rxd22),
    .ua_nrts22            (uart_s022.rts_n22),
    .ua_nrts122           (uart_s122.rts_n22),
    // outputs22 from ttc22
    .so                (),
    .mo22                (spi_s022.sig_si22),
    .sclk_out22          (spi_s022.sig_sclk_in22),
    .n_ss_out22          (n_ss_out22[7:0]),
    .n_so_en22           (),
    .n_mo_en22           (),
    .n_sclk_en22         (),
    .n_ss_en22           (),
    //outputs22 from gpio22
    .n_gpio_pin_oe22     (gpio_s022.n_gpio_pin_oe22[15:0]),
    .gpio_pin_out22      (gpio_s022.gpio_pin_out22[15:0]),

//unconnected22 o/p ports22
    .clk_SRPG_macb0_en22(),
    .clk_SRPG_macb1_en22(),
    .clk_SRPG_macb2_en22(),
    .clk_SRPG_macb3_en22(),
    .core06v22(),
    .core08v22(),
    .core10v22(),
    .core12v22(),
    .mte_smc_start22(),
    .mte_uart_start22(),
    .mte_smc_uart_start22(),
    .mte_pm_smc_to_default_start22(),
    .mte_pm_uart_to_default_start22(),
    .mte_pm_smc_uart_to_default_start22(),
    .pcm_irq22(),
    .ttc_irq22(),
    .gpio_irq22(),
    .uart0_irq22(),
    .uart1_irq22(),
    .spi_irq22(),

    .macb3_wakeup22(),
    .macb2_wakeup22(),
    .macb1_wakeup22(),
    .macb0_wakeup22()
);


initial
begin
  tb_hclk22 = 0;
  hresetn22 = 1;

  #1 hresetn22 = 0;
  #1200 hresetn22 = 1;
end

always #50 tb_hclk22 = ~tb_hclk22;

initial begin
  uvm_config_db#(virtual uart_if22)::set(null, "uvm_test_top.ve22.uart022*", "vif22", uart_s022);
  uvm_config_db#(virtual uart_if22)::set(null, "uvm_test_top.ve22.uart122*", "vif22", uart_s122);
  uvm_config_db#(virtual uart_ctrl_internal_if22)::set(null, "uvm_test_top.ve22.apb_ss_env22.apb_uart022.*", "vif22", uart_int022);
  uvm_config_db#(virtual uart_ctrl_internal_if22)::set(null, "uvm_test_top.ve22.apb_ss_env22.apb_uart122.*", "vif22", uart_int122);
  uvm_config_db#(virtual apb_if22)::set(null, "uvm_test_top.ve22.apb022*", "vif22", apbi_mo22);
  uvm_config_db#(virtual ahb_if22)::set(null, "uvm_test_top.ve22.ahb022*", "vif22", ahbi_m022);
  uvm_config_db#(virtual spi_if22)::set(null, "uvm_test_top.ve22.spi022*", "spi_if22", spi_s022);
  uvm_config_db#(virtual gpio_if22)::set(null, "uvm_test_top.ve22.gpio022*", "gpio_if22", gpio_s022);
  run_test();
end

endmodule
