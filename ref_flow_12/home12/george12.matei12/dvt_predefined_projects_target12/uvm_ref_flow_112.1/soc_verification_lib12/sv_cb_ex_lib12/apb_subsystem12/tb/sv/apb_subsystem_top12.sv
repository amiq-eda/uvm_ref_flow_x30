/*-------------------------------------------------------------------------
File12 name   : apb_subsystem_top12.v 
Title12       : Top12 level file for the testbench 
Project12     : APB12 Subsystem12
Created12     : March12 2008
Description12 : This12 is top level file which instantiate12 the dut12 apb_subsyste12,.v.
              It also has the assertion12 module which checks12 for the power12 down 
              and power12 up.To12 activate12 the assertion12 ifdef LP_ABV_ON12 is used.       
Notes12       :
-------------------------------------------------------------------------*/ 
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------

 `timescale 1ns/10ps


// Environment12 Constants12
`ifndef AHB_DATA_WIDTH12
  `define AHB_DATA_WIDTH12          32              // AHB12 bus data width [32/64]
`endif
`ifndef AHB_ADDR_WIDTH12
  `define AHB_ADDR_WIDTH12          32              // AHB12 bus address width [32/64]
`endif
`ifndef AHB_DATA_MAX_BIT12
  `define AHB_DATA_MAX_BIT12        31              // MUST12 BE12: AHB_DATA_WIDTH12 - 1
`endif
`ifndef AHB_ADDRESS_MAX_BIT12
  `define AHB_ADDRESS_MAX_BIT12     31              // MUST12 BE12: AHB_ADDR_WIDTH12 - 1
`endif
`ifndef DEFAULT_HREADY_VALUE12
  `define DEFAULT_HREADY_VALUE12    1'b1            // Ready12 Asserted12
`endif

`include "ahb_if12.sv"
`include "apb_if12.sv"
`include "apb_master_if12.sv"
`include "apb_slave_if12.sv"
`include "uart_if12.sv"
`include "spi_if12.sv"
`include "gpio_if12.sv"
`include "coverage12/uart_ctrl_internal_if12.sv"

module apb_subsystem_top12;
  import uvm_pkg::*;
  // Import12 the UVM Utilities12 Package12

  import ahb_pkg12::*;
  import apb_pkg12::*;
  import uart_pkg12::*;
  import gpio_pkg12::*;
  import spi_pkg12::*;
  import uart_ctrl_pkg12::*;
  import apb_subsystem_pkg12::*;

  `include "spi_reg_model12.sv"
  `include "gpio_reg_model12.sv"
  `include "apb_subsystem_reg_rdb12.sv"
  `include "uart_ctrl_reg_seq_lib12.sv"
  `include "spi_reg_seq_lib12.sv"
  `include "gpio_reg_seq_lib12.sv"

  //Include12 module UVC12 sequences
  `include "ahb_user_monitor12.sv"
  `include "apb_subsystem_seq_lib12.sv"
  `include "apb_subsystem_vir_sequencer12.sv"
  `include "apb_subsystem_vir_seq_lib12.sv"

  `include "apb_subsystem_tb12.sv"
  `include "test_lib12.sv"
   
  
   // ====================================
   // SHARED12 signals12
   // ====================================
   
   // clock12
   reg tb_hclk12;
   
   // reset
   reg hresetn12;
   
   // post12-mux12 from master12 mux12
   wire [`AHB_DATA_MAX_BIT12:0] hwdata12;
   wire [`AHB_ADDRESS_MAX_BIT12:0] haddr12;
   wire [1:0]  htrans12;
   wire [2:0]  hburst12;
   wire [2:0]  hsize12;
   wire [3:0]  hprot12;
   wire hwrite12;

   // post12-mux12 from slave12 mux12
   wire        hready12;
   wire [1:0]  hresp12;
   wire [`AHB_DATA_MAX_BIT12:0] hrdata12;
  

  //  Specific12 signals12 of apb12 subsystem12
  reg         ua_rxd12;
  reg         ua_ncts12;


  // uart12 outputs12 
  wire        ua_txd12;
  wire        us_nrts12;

  wire   [7:0] n_ss_out12;    // peripheral12 select12 lines12 from master12
  wire   [31:0] hwdata_byte_alligned12;

  reg [2:0] div8_clk12;
 always @(posedge tb_hclk12) begin
   if (!hresetn12)
     div8_clk12 = 3'b000;
   else
     div8_clk12 = div8_clk12 + 1;
 end


  // Master12 virtual interface
  ahb_if12 ahbi_m012(.ahb_clock12(tb_hclk12), .ahb_resetn12(hresetn12));
  
  uart_if12 uart_s012(.clock12(div8_clk12[2]), .reset(hresetn12));
  uart_if12 uart_s112(.clock12(div8_clk12[2]), .reset(hresetn12));
  spi_if12 spi_s012();
  gpio_if12 gpio_s012();
  uart_ctrl_internal_if12 uart_int012(.clock12(div8_clk12[2]));
  uart_ctrl_internal_if12 uart_int112(.clock12(div8_clk12[2]));

  apb_if12 apbi_mo12(.pclock12(tb_hclk12), .preset12(hresetn12));

  //M012
  assign ahbi_m012.AHB_HCLK12 = tb_hclk12;
  assign ahbi_m012.AHB_HRESET12 = hresetn12;
  assign ahbi_m012.AHB_HRESP12 = hresp12;
  assign ahbi_m012.AHB_HRDATA12 = hrdata12;
  assign ahbi_m012.AHB_HREADY12 = hready12;

  assign apbi_mo12.paddr12 = i_apb_subsystem12.i_ahb2apb12.paddr12;
  assign apbi_mo12.prwd12 = i_apb_subsystem12.i_ahb2apb12.pwrite12;
  assign apbi_mo12.pwdata12 = i_apb_subsystem12.i_ahb2apb12.pwdata12;
  assign apbi_mo12.penable12 = i_apb_subsystem12.i_ahb2apb12.penable12;
  assign apbi_mo12.psel12 = {12'b0, i_apb_subsystem12.i_ahb2apb12.psel812, i_apb_subsystem12.i_ahb2apb12.psel212, i_apb_subsystem12.i_ahb2apb12.psel112, i_apb_subsystem12.i_ahb2apb12.psel012};
  assign apbi_mo12.prdata12 = i_apb_subsystem12.i_ahb2apb12.psel012? i_apb_subsystem12.i_ahb2apb12.prdata012 : (i_apb_subsystem12.i_ahb2apb12.psel112? i_apb_subsystem12.i_ahb2apb12.prdata112 : (i_apb_subsystem12.i_ahb2apb12.psel212? i_apb_subsystem12.i_ahb2apb12.prdata212 : i_apb_subsystem12.i_ahb2apb12.prdata812));

  assign spi_s012.sig_n_ss_in12 = n_ss_out12[0];
  assign spi_s012.sig_n_p_reset12 = hresetn12;
  assign spi_s012.sig_pclk12 = tb_hclk12;

  assign gpio_s012.n_p_reset12 = hresetn12;
  assign gpio_s012.pclk12 = tb_hclk12;

  assign hwdata_byte_alligned12 = (ahbi_m012.AHB_HADDR12[1:0] == 2'b00) ? ahbi_m012.AHB_HWDATA12 : {4{ahbi_m012.AHB_HWDATA12[7:0]}};

  apb_subsystem_012 i_apb_subsystem12 (
    // Inputs12
    // system signals12
    .hclk12              (tb_hclk12),     // AHB12 Clock12
    .n_hreset12          (hresetn12),     // AHB12 reset - Active12 low12
    .pclk12              (tb_hclk12),     // APB12 Clock12
    .n_preset12          (hresetn12),     // APB12 reset - Active12 low12
    
    // AHB12 interface for AHB2APM12 bridge12
    .hsel12     (1'b1),        // AHB2APB12 select12
    .haddr12             (ahbi_m012.AHB_HADDR12),        // Address bus
    .htrans12            (ahbi_m012.AHB_HTRANS12),       // Transfer12 type
    .hsize12             (ahbi_m012.AHB_HSIZE12),        // AHB12 Access type - byte half12-word12 word12
    .hwrite12            (ahbi_m012.AHB_HWRITE12),       // Write signal12
    .hwdata12            (hwdata_byte_alligned12),       // Write data
    .hready_in12         (hready12),       // Indicates12 that the last master12 has finished12 
                                       // its bus access
    .hburst12            (ahbi_m012.AHB_HBURST12),       // Burst type
    .hprot12             (ahbi_m012.AHB_HPROT12),        // Protection12 control12
    .hmaster12           (4'h0),      // Master12 select12
    .hmastlock12         (ahbi_m012.AHB_HLOCK12),  // Locked12 transfer12
    // AHB12 interface for SMC12
    .smc_hclk12          (1'b0),
    .smc_n_hclk12        (1'b1),
    .smc_haddr12         (32'd0),
    .smc_htrans12        (2'b00),
    .smc_hsel12          (1'b0),
    .smc_hwrite12        (1'b0),
    .smc_hsize12         (3'd0),
    .smc_hwdata12        (32'd0),
    .smc_hready_in12     (1'b1),
    .smc_hburst12        (3'b000),
    .smc_hprot12         (4'b0000),
    .smc_hmaster12       (4'b0000),
    .smc_hmastlock12     (1'b0),

    //interrupt12 from DMA12
    .DMA_irq12           (1'b0),      

    // Scan12 inputs12
    .scan_en12           (1'b0),         // Scan12 enable pin12
    .scan_in_112         (1'b0),         // Scan12 input for first chain12
    .scan_in_212         (1'b0),        // Scan12 input for second chain12
    .scan_mode12         (1'b0),
    //input for smc12
    .data_smc12          (32'd0),
    //inputs12 for uart12
    .ua_rxd12            (uart_s012.txd12),
    .ua_rxd112           (uart_s112.txd12),
    .ua_ncts12           (uart_s012.cts_n12),
    .ua_ncts112          (uart_s112.cts_n12),
    //inputs12 for spi12
    .n_ss_in12           (1'b1),
    .mi12                (spi_s012.sig_so12),
    .si12                (1'b0),
    .sclk_in12           (1'b0),
    //inputs12 for GPIO12
    .gpio_pin_in12       (gpio_s012.gpio_pin_in12[15:0]),
 
//interrupt12 from Enet12 MAC12
     .macb0_int12     (1'b0),
     .macb1_int12     (1'b0),
     .macb2_int12     (1'b0),
     .macb3_int12     (1'b0),

    // Scan12 outputs12
    .scan_out_112        (),             // Scan12 out for chain12 1
    .scan_out_212        (),             // Scan12 out for chain12 2
   
    //output from APB12 
    // AHB12 interface for AHB2APB12 bridge12
    .hrdata12            (hrdata12),       // Read data provided from target slave12
    .hready12            (hready12),       // Ready12 for new bus cycle from target slave12
    .hresp12             (hresp12),        // Response12 from the bridge12

    // AHB12 interface for SMC12
    .smc_hrdata12        (), 
    .smc_hready12        (),
    .smc_hresp12         (),
  
    //outputs12 from smc12
    .smc_n_ext_oe12      (),
    .smc_data12          (),
    .smc_addr12          (),
    .smc_n_be12          (),
    .smc_n_cs12          (), 
    .smc_n_we12          (),
    .smc_n_wr12          (),
    .smc_n_rd12          (),
    //outputs12 from uart12
    .ua_txd12             (uart_s012.rxd12),
    .ua_txd112            (uart_s112.rxd12),
    .ua_nrts12            (uart_s012.rts_n12),
    .ua_nrts112           (uart_s112.rts_n12),
    // outputs12 from ttc12
    .so                (),
    .mo12                (spi_s012.sig_si12),
    .sclk_out12          (spi_s012.sig_sclk_in12),
    .n_ss_out12          (n_ss_out12[7:0]),
    .n_so_en12           (),
    .n_mo_en12           (),
    .n_sclk_en12         (),
    .n_ss_en12           (),
    //outputs12 from gpio12
    .n_gpio_pin_oe12     (gpio_s012.n_gpio_pin_oe12[15:0]),
    .gpio_pin_out12      (gpio_s012.gpio_pin_out12[15:0]),

//unconnected12 o/p ports12
    .clk_SRPG_macb0_en12(),
    .clk_SRPG_macb1_en12(),
    .clk_SRPG_macb2_en12(),
    .clk_SRPG_macb3_en12(),
    .core06v12(),
    .core08v12(),
    .core10v12(),
    .core12v12(),
    .mte_smc_start12(),
    .mte_uart_start12(),
    .mte_smc_uart_start12(),
    .mte_pm_smc_to_default_start12(),
    .mte_pm_uart_to_default_start12(),
    .mte_pm_smc_uart_to_default_start12(),
    .pcm_irq12(),
    .ttc_irq12(),
    .gpio_irq12(),
    .uart0_irq12(),
    .uart1_irq12(),
    .spi_irq12(),

    .macb3_wakeup12(),
    .macb2_wakeup12(),
    .macb1_wakeup12(),
    .macb0_wakeup12()
);


initial
begin
  tb_hclk12 = 0;
  hresetn12 = 1;

  #1 hresetn12 = 0;
  #1200 hresetn12 = 1;
end

always #50 tb_hclk12 = ~tb_hclk12;

initial begin
  uvm_config_db#(virtual uart_if12)::set(null, "uvm_test_top.ve12.uart012*", "vif12", uart_s012);
  uvm_config_db#(virtual uart_if12)::set(null, "uvm_test_top.ve12.uart112*", "vif12", uart_s112);
  uvm_config_db#(virtual uart_ctrl_internal_if12)::set(null, "uvm_test_top.ve12.apb_ss_env12.apb_uart012.*", "vif12", uart_int012);
  uvm_config_db#(virtual uart_ctrl_internal_if12)::set(null, "uvm_test_top.ve12.apb_ss_env12.apb_uart112.*", "vif12", uart_int112);
  uvm_config_db#(virtual apb_if12)::set(null, "uvm_test_top.ve12.apb012*", "vif12", apbi_mo12);
  uvm_config_db#(virtual ahb_if12)::set(null, "uvm_test_top.ve12.ahb012*", "vif12", ahbi_m012);
  uvm_config_db#(virtual spi_if12)::set(null, "uvm_test_top.ve12.spi012*", "spi_if12", spi_s012);
  uvm_config_db#(virtual gpio_if12)::set(null, "uvm_test_top.ve12.gpio012*", "gpio_if12", gpio_s012);
  run_test();
end

endmodule
