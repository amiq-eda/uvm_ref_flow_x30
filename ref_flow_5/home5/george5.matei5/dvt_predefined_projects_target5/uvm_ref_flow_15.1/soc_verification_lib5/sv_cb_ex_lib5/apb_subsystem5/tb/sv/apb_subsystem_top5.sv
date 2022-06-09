/*-------------------------------------------------------------------------
File5 name   : apb_subsystem_top5.v 
Title5       : Top5 level file for the testbench 
Project5     : APB5 Subsystem5
Created5     : March5 2008
Description5 : This5 is top level file which instantiate5 the dut5 apb_subsyste5,.v.
              It also has the assertion5 module which checks5 for the power5 down 
              and power5 up.To5 activate5 the assertion5 ifdef LP_ABV_ON5 is used.       
Notes5       :
-------------------------------------------------------------------------*/ 
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------

 `timescale 1ns/10ps


// Environment5 Constants5
`ifndef AHB_DATA_WIDTH5
  `define AHB_DATA_WIDTH5          32              // AHB5 bus data width [32/64]
`endif
`ifndef AHB_ADDR_WIDTH5
  `define AHB_ADDR_WIDTH5          32              // AHB5 bus address width [32/64]
`endif
`ifndef AHB_DATA_MAX_BIT5
  `define AHB_DATA_MAX_BIT5        31              // MUST5 BE5: AHB_DATA_WIDTH5 - 1
`endif
`ifndef AHB_ADDRESS_MAX_BIT5
  `define AHB_ADDRESS_MAX_BIT5     31              // MUST5 BE5: AHB_ADDR_WIDTH5 - 1
`endif
`ifndef DEFAULT_HREADY_VALUE5
  `define DEFAULT_HREADY_VALUE5    1'b1            // Ready5 Asserted5
`endif

`include "ahb_if5.sv"
`include "apb_if5.sv"
`include "apb_master_if5.sv"
`include "apb_slave_if5.sv"
`include "uart_if5.sv"
`include "spi_if5.sv"
`include "gpio_if5.sv"
`include "coverage5/uart_ctrl_internal_if5.sv"

module apb_subsystem_top5;
  import uvm_pkg::*;
  // Import5 the UVM Utilities5 Package5

  import ahb_pkg5::*;
  import apb_pkg5::*;
  import uart_pkg5::*;
  import gpio_pkg5::*;
  import spi_pkg5::*;
  import uart_ctrl_pkg5::*;
  import apb_subsystem_pkg5::*;

  `include "spi_reg_model5.sv"
  `include "gpio_reg_model5.sv"
  `include "apb_subsystem_reg_rdb5.sv"
  `include "uart_ctrl_reg_seq_lib5.sv"
  `include "spi_reg_seq_lib5.sv"
  `include "gpio_reg_seq_lib5.sv"

  //Include5 module UVC5 sequences
  `include "ahb_user_monitor5.sv"
  `include "apb_subsystem_seq_lib5.sv"
  `include "apb_subsystem_vir_sequencer5.sv"
  `include "apb_subsystem_vir_seq_lib5.sv"

  `include "apb_subsystem_tb5.sv"
  `include "test_lib5.sv"
   
  
   // ====================================
   // SHARED5 signals5
   // ====================================
   
   // clock5
   reg tb_hclk5;
   
   // reset
   reg hresetn5;
   
   // post5-mux5 from master5 mux5
   wire [`AHB_DATA_MAX_BIT5:0] hwdata5;
   wire [`AHB_ADDRESS_MAX_BIT5:0] haddr5;
   wire [1:0]  htrans5;
   wire [2:0]  hburst5;
   wire [2:0]  hsize5;
   wire [3:0]  hprot5;
   wire hwrite5;

   // post5-mux5 from slave5 mux5
   wire        hready5;
   wire [1:0]  hresp5;
   wire [`AHB_DATA_MAX_BIT5:0] hrdata5;
  

  //  Specific5 signals5 of apb5 subsystem5
  reg         ua_rxd5;
  reg         ua_ncts5;


  // uart5 outputs5 
  wire        ua_txd5;
  wire        us_nrts5;

  wire   [7:0] n_ss_out5;    // peripheral5 select5 lines5 from master5
  wire   [31:0] hwdata_byte_alligned5;

  reg [2:0] div8_clk5;
 always @(posedge tb_hclk5) begin
   if (!hresetn5)
     div8_clk5 = 3'b000;
   else
     div8_clk5 = div8_clk5 + 1;
 end


  // Master5 virtual interface
  ahb_if5 ahbi_m05(.ahb_clock5(tb_hclk5), .ahb_resetn5(hresetn5));
  
  uart_if5 uart_s05(.clock5(div8_clk5[2]), .reset(hresetn5));
  uart_if5 uart_s15(.clock5(div8_clk5[2]), .reset(hresetn5));
  spi_if5 spi_s05();
  gpio_if5 gpio_s05();
  uart_ctrl_internal_if5 uart_int05(.clock5(div8_clk5[2]));
  uart_ctrl_internal_if5 uart_int15(.clock5(div8_clk5[2]));

  apb_if5 apbi_mo5(.pclock5(tb_hclk5), .preset5(hresetn5));

  //M05
  assign ahbi_m05.AHB_HCLK5 = tb_hclk5;
  assign ahbi_m05.AHB_HRESET5 = hresetn5;
  assign ahbi_m05.AHB_HRESP5 = hresp5;
  assign ahbi_m05.AHB_HRDATA5 = hrdata5;
  assign ahbi_m05.AHB_HREADY5 = hready5;

  assign apbi_mo5.paddr5 = i_apb_subsystem5.i_ahb2apb5.paddr5;
  assign apbi_mo5.prwd5 = i_apb_subsystem5.i_ahb2apb5.pwrite5;
  assign apbi_mo5.pwdata5 = i_apb_subsystem5.i_ahb2apb5.pwdata5;
  assign apbi_mo5.penable5 = i_apb_subsystem5.i_ahb2apb5.penable5;
  assign apbi_mo5.psel5 = {12'b0, i_apb_subsystem5.i_ahb2apb5.psel85, i_apb_subsystem5.i_ahb2apb5.psel25, i_apb_subsystem5.i_ahb2apb5.psel15, i_apb_subsystem5.i_ahb2apb5.psel05};
  assign apbi_mo5.prdata5 = i_apb_subsystem5.i_ahb2apb5.psel05? i_apb_subsystem5.i_ahb2apb5.prdata05 : (i_apb_subsystem5.i_ahb2apb5.psel15? i_apb_subsystem5.i_ahb2apb5.prdata15 : (i_apb_subsystem5.i_ahb2apb5.psel25? i_apb_subsystem5.i_ahb2apb5.prdata25 : i_apb_subsystem5.i_ahb2apb5.prdata85));

  assign spi_s05.sig_n_ss_in5 = n_ss_out5[0];
  assign spi_s05.sig_n_p_reset5 = hresetn5;
  assign spi_s05.sig_pclk5 = tb_hclk5;

  assign gpio_s05.n_p_reset5 = hresetn5;
  assign gpio_s05.pclk5 = tb_hclk5;

  assign hwdata_byte_alligned5 = (ahbi_m05.AHB_HADDR5[1:0] == 2'b00) ? ahbi_m05.AHB_HWDATA5 : {4{ahbi_m05.AHB_HWDATA5[7:0]}};

  apb_subsystem_05 i_apb_subsystem5 (
    // Inputs5
    // system signals5
    .hclk5              (tb_hclk5),     // AHB5 Clock5
    .n_hreset5          (hresetn5),     // AHB5 reset - Active5 low5
    .pclk5              (tb_hclk5),     // APB5 Clock5
    .n_preset5          (hresetn5),     // APB5 reset - Active5 low5
    
    // AHB5 interface for AHB2APM5 bridge5
    .hsel5     (1'b1),        // AHB2APB5 select5
    .haddr5             (ahbi_m05.AHB_HADDR5),        // Address bus
    .htrans5            (ahbi_m05.AHB_HTRANS5),       // Transfer5 type
    .hsize5             (ahbi_m05.AHB_HSIZE5),        // AHB5 Access type - byte half5-word5 word5
    .hwrite5            (ahbi_m05.AHB_HWRITE5),       // Write signal5
    .hwdata5            (hwdata_byte_alligned5),       // Write data
    .hready_in5         (hready5),       // Indicates5 that the last master5 has finished5 
                                       // its bus access
    .hburst5            (ahbi_m05.AHB_HBURST5),       // Burst type
    .hprot5             (ahbi_m05.AHB_HPROT5),        // Protection5 control5
    .hmaster5           (4'h0),      // Master5 select5
    .hmastlock5         (ahbi_m05.AHB_HLOCK5),  // Locked5 transfer5
    // AHB5 interface for SMC5
    .smc_hclk5          (1'b0),
    .smc_n_hclk5        (1'b1),
    .smc_haddr5         (32'd0),
    .smc_htrans5        (2'b00),
    .smc_hsel5          (1'b0),
    .smc_hwrite5        (1'b0),
    .smc_hsize5         (3'd0),
    .smc_hwdata5        (32'd0),
    .smc_hready_in5     (1'b1),
    .smc_hburst5        (3'b000),
    .smc_hprot5         (4'b0000),
    .smc_hmaster5       (4'b0000),
    .smc_hmastlock5     (1'b0),

    //interrupt5 from DMA5
    .DMA_irq5           (1'b0),      

    // Scan5 inputs5
    .scan_en5           (1'b0),         // Scan5 enable pin5
    .scan_in_15         (1'b0),         // Scan5 input for first chain5
    .scan_in_25         (1'b0),        // Scan5 input for second chain5
    .scan_mode5         (1'b0),
    //input for smc5
    .data_smc5          (32'd0),
    //inputs5 for uart5
    .ua_rxd5            (uart_s05.txd5),
    .ua_rxd15           (uart_s15.txd5),
    .ua_ncts5           (uart_s05.cts_n5),
    .ua_ncts15          (uart_s15.cts_n5),
    //inputs5 for spi5
    .n_ss_in5           (1'b1),
    .mi5                (spi_s05.sig_so5),
    .si5                (1'b0),
    .sclk_in5           (1'b0),
    //inputs5 for GPIO5
    .gpio_pin_in5       (gpio_s05.gpio_pin_in5[15:0]),
 
//interrupt5 from Enet5 MAC5
     .macb0_int5     (1'b0),
     .macb1_int5     (1'b0),
     .macb2_int5     (1'b0),
     .macb3_int5     (1'b0),

    // Scan5 outputs5
    .scan_out_15        (),             // Scan5 out for chain5 1
    .scan_out_25        (),             // Scan5 out for chain5 2
   
    //output from APB5 
    // AHB5 interface for AHB2APB5 bridge5
    .hrdata5            (hrdata5),       // Read data provided from target slave5
    .hready5            (hready5),       // Ready5 for new bus cycle from target slave5
    .hresp5             (hresp5),        // Response5 from the bridge5

    // AHB5 interface for SMC5
    .smc_hrdata5        (), 
    .smc_hready5        (),
    .smc_hresp5         (),
  
    //outputs5 from smc5
    .smc_n_ext_oe5      (),
    .smc_data5          (),
    .smc_addr5          (),
    .smc_n_be5          (),
    .smc_n_cs5          (), 
    .smc_n_we5          (),
    .smc_n_wr5          (),
    .smc_n_rd5          (),
    //outputs5 from uart5
    .ua_txd5             (uart_s05.rxd5),
    .ua_txd15            (uart_s15.rxd5),
    .ua_nrts5            (uart_s05.rts_n5),
    .ua_nrts15           (uart_s15.rts_n5),
    // outputs5 from ttc5
    .so                (),
    .mo5                (spi_s05.sig_si5),
    .sclk_out5          (spi_s05.sig_sclk_in5),
    .n_ss_out5          (n_ss_out5[7:0]),
    .n_so_en5           (),
    .n_mo_en5           (),
    .n_sclk_en5         (),
    .n_ss_en5           (),
    //outputs5 from gpio5
    .n_gpio_pin_oe5     (gpio_s05.n_gpio_pin_oe5[15:0]),
    .gpio_pin_out5      (gpio_s05.gpio_pin_out5[15:0]),

//unconnected5 o/p ports5
    .clk_SRPG_macb0_en5(),
    .clk_SRPG_macb1_en5(),
    .clk_SRPG_macb2_en5(),
    .clk_SRPG_macb3_en5(),
    .core06v5(),
    .core08v5(),
    .core10v5(),
    .core12v5(),
    .mte_smc_start5(),
    .mte_uart_start5(),
    .mte_smc_uart_start5(),
    .mte_pm_smc_to_default_start5(),
    .mte_pm_uart_to_default_start5(),
    .mte_pm_smc_uart_to_default_start5(),
    .pcm_irq5(),
    .ttc_irq5(),
    .gpio_irq5(),
    .uart0_irq5(),
    .uart1_irq5(),
    .spi_irq5(),

    .macb3_wakeup5(),
    .macb2_wakeup5(),
    .macb1_wakeup5(),
    .macb0_wakeup5()
);


initial
begin
  tb_hclk5 = 0;
  hresetn5 = 1;

  #1 hresetn5 = 0;
  #1200 hresetn5 = 1;
end

always #50 tb_hclk5 = ~tb_hclk5;

initial begin
  uvm_config_db#(virtual uart_if5)::set(null, "uvm_test_top.ve5.uart05*", "vif5", uart_s05);
  uvm_config_db#(virtual uart_if5)::set(null, "uvm_test_top.ve5.uart15*", "vif5", uart_s15);
  uvm_config_db#(virtual uart_ctrl_internal_if5)::set(null, "uvm_test_top.ve5.apb_ss_env5.apb_uart05.*", "vif5", uart_int05);
  uvm_config_db#(virtual uart_ctrl_internal_if5)::set(null, "uvm_test_top.ve5.apb_ss_env5.apb_uart15.*", "vif5", uart_int15);
  uvm_config_db#(virtual apb_if5)::set(null, "uvm_test_top.ve5.apb05*", "vif5", apbi_mo5);
  uvm_config_db#(virtual ahb_if5)::set(null, "uvm_test_top.ve5.ahb05*", "vif5", ahbi_m05);
  uvm_config_db#(virtual spi_if5)::set(null, "uvm_test_top.ve5.spi05*", "spi_if5", spi_s05);
  uvm_config_db#(virtual gpio_if5)::set(null, "uvm_test_top.ve5.gpio05*", "gpio_if5", gpio_s05);
  run_test();
end

endmodule
