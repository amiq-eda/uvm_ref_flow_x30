/*-------------------------------------------------------------------------
File4 name   : apb_subsystem_top4.v 
Title4       : Top4 level file for the testbench 
Project4     : APB4 Subsystem4
Created4     : March4 2008
Description4 : This4 is top level file which instantiate4 the dut4 apb_subsyste4,.v.
              It also has the assertion4 module which checks4 for the power4 down 
              and power4 up.To4 activate4 the assertion4 ifdef LP_ABV_ON4 is used.       
Notes4       :
-------------------------------------------------------------------------*/ 
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------

 `timescale 1ns/10ps


// Environment4 Constants4
`ifndef AHB_DATA_WIDTH4
  `define AHB_DATA_WIDTH4          32              // AHB4 bus data width [32/64]
`endif
`ifndef AHB_ADDR_WIDTH4
  `define AHB_ADDR_WIDTH4          32              // AHB4 bus address width [32/64]
`endif
`ifndef AHB_DATA_MAX_BIT4
  `define AHB_DATA_MAX_BIT4        31              // MUST4 BE4: AHB_DATA_WIDTH4 - 1
`endif
`ifndef AHB_ADDRESS_MAX_BIT4
  `define AHB_ADDRESS_MAX_BIT4     31              // MUST4 BE4: AHB_ADDR_WIDTH4 - 1
`endif
`ifndef DEFAULT_HREADY_VALUE4
  `define DEFAULT_HREADY_VALUE4    1'b1            // Ready4 Asserted4
`endif

`include "ahb_if4.sv"
`include "apb_if4.sv"
`include "apb_master_if4.sv"
`include "apb_slave_if4.sv"
`include "uart_if4.sv"
`include "spi_if4.sv"
`include "gpio_if4.sv"
`include "coverage4/uart_ctrl_internal_if4.sv"

module apb_subsystem_top4;
  import uvm_pkg::*;
  // Import4 the UVM Utilities4 Package4

  import ahb_pkg4::*;
  import apb_pkg4::*;
  import uart_pkg4::*;
  import gpio_pkg4::*;
  import spi_pkg4::*;
  import uart_ctrl_pkg4::*;
  import apb_subsystem_pkg4::*;

  `include "spi_reg_model4.sv"
  `include "gpio_reg_model4.sv"
  `include "apb_subsystem_reg_rdb4.sv"
  `include "uart_ctrl_reg_seq_lib4.sv"
  `include "spi_reg_seq_lib4.sv"
  `include "gpio_reg_seq_lib4.sv"

  //Include4 module UVC4 sequences
  `include "ahb_user_monitor4.sv"
  `include "apb_subsystem_seq_lib4.sv"
  `include "apb_subsystem_vir_sequencer4.sv"
  `include "apb_subsystem_vir_seq_lib4.sv"

  `include "apb_subsystem_tb4.sv"
  `include "test_lib4.sv"
   
  
   // ====================================
   // SHARED4 signals4
   // ====================================
   
   // clock4
   reg tb_hclk4;
   
   // reset
   reg hresetn4;
   
   // post4-mux4 from master4 mux4
   wire [`AHB_DATA_MAX_BIT4:0] hwdata4;
   wire [`AHB_ADDRESS_MAX_BIT4:0] haddr4;
   wire [1:0]  htrans4;
   wire [2:0]  hburst4;
   wire [2:0]  hsize4;
   wire [3:0]  hprot4;
   wire hwrite4;

   // post4-mux4 from slave4 mux4
   wire        hready4;
   wire [1:0]  hresp4;
   wire [`AHB_DATA_MAX_BIT4:0] hrdata4;
  

  //  Specific4 signals4 of apb4 subsystem4
  reg         ua_rxd4;
  reg         ua_ncts4;


  // uart4 outputs4 
  wire        ua_txd4;
  wire        us_nrts4;

  wire   [7:0] n_ss_out4;    // peripheral4 select4 lines4 from master4
  wire   [31:0] hwdata_byte_alligned4;

  reg [2:0] div8_clk4;
 always @(posedge tb_hclk4) begin
   if (!hresetn4)
     div8_clk4 = 3'b000;
   else
     div8_clk4 = div8_clk4 + 1;
 end


  // Master4 virtual interface
  ahb_if4 ahbi_m04(.ahb_clock4(tb_hclk4), .ahb_resetn4(hresetn4));
  
  uart_if4 uart_s04(.clock4(div8_clk4[2]), .reset(hresetn4));
  uart_if4 uart_s14(.clock4(div8_clk4[2]), .reset(hresetn4));
  spi_if4 spi_s04();
  gpio_if4 gpio_s04();
  uart_ctrl_internal_if4 uart_int04(.clock4(div8_clk4[2]));
  uart_ctrl_internal_if4 uart_int14(.clock4(div8_clk4[2]));

  apb_if4 apbi_mo4(.pclock4(tb_hclk4), .preset4(hresetn4));

  //M04
  assign ahbi_m04.AHB_HCLK4 = tb_hclk4;
  assign ahbi_m04.AHB_HRESET4 = hresetn4;
  assign ahbi_m04.AHB_HRESP4 = hresp4;
  assign ahbi_m04.AHB_HRDATA4 = hrdata4;
  assign ahbi_m04.AHB_HREADY4 = hready4;

  assign apbi_mo4.paddr4 = i_apb_subsystem4.i_ahb2apb4.paddr4;
  assign apbi_mo4.prwd4 = i_apb_subsystem4.i_ahb2apb4.pwrite4;
  assign apbi_mo4.pwdata4 = i_apb_subsystem4.i_ahb2apb4.pwdata4;
  assign apbi_mo4.penable4 = i_apb_subsystem4.i_ahb2apb4.penable4;
  assign apbi_mo4.psel4 = {12'b0, i_apb_subsystem4.i_ahb2apb4.psel84, i_apb_subsystem4.i_ahb2apb4.psel24, i_apb_subsystem4.i_ahb2apb4.psel14, i_apb_subsystem4.i_ahb2apb4.psel04};
  assign apbi_mo4.prdata4 = i_apb_subsystem4.i_ahb2apb4.psel04? i_apb_subsystem4.i_ahb2apb4.prdata04 : (i_apb_subsystem4.i_ahb2apb4.psel14? i_apb_subsystem4.i_ahb2apb4.prdata14 : (i_apb_subsystem4.i_ahb2apb4.psel24? i_apb_subsystem4.i_ahb2apb4.prdata24 : i_apb_subsystem4.i_ahb2apb4.prdata84));

  assign spi_s04.sig_n_ss_in4 = n_ss_out4[0];
  assign spi_s04.sig_n_p_reset4 = hresetn4;
  assign spi_s04.sig_pclk4 = tb_hclk4;

  assign gpio_s04.n_p_reset4 = hresetn4;
  assign gpio_s04.pclk4 = tb_hclk4;

  assign hwdata_byte_alligned4 = (ahbi_m04.AHB_HADDR4[1:0] == 2'b00) ? ahbi_m04.AHB_HWDATA4 : {4{ahbi_m04.AHB_HWDATA4[7:0]}};

  apb_subsystem_04 i_apb_subsystem4 (
    // Inputs4
    // system signals4
    .hclk4              (tb_hclk4),     // AHB4 Clock4
    .n_hreset4          (hresetn4),     // AHB4 reset - Active4 low4
    .pclk4              (tb_hclk4),     // APB4 Clock4
    .n_preset4          (hresetn4),     // APB4 reset - Active4 low4
    
    // AHB4 interface for AHB2APM4 bridge4
    .hsel4     (1'b1),        // AHB2APB4 select4
    .haddr4             (ahbi_m04.AHB_HADDR4),        // Address bus
    .htrans4            (ahbi_m04.AHB_HTRANS4),       // Transfer4 type
    .hsize4             (ahbi_m04.AHB_HSIZE4),        // AHB4 Access type - byte half4-word4 word4
    .hwrite4            (ahbi_m04.AHB_HWRITE4),       // Write signal4
    .hwdata4            (hwdata_byte_alligned4),       // Write data
    .hready_in4         (hready4),       // Indicates4 that the last master4 has finished4 
                                       // its bus access
    .hburst4            (ahbi_m04.AHB_HBURST4),       // Burst type
    .hprot4             (ahbi_m04.AHB_HPROT4),        // Protection4 control4
    .hmaster4           (4'h0),      // Master4 select4
    .hmastlock4         (ahbi_m04.AHB_HLOCK4),  // Locked4 transfer4
    // AHB4 interface for SMC4
    .smc_hclk4          (1'b0),
    .smc_n_hclk4        (1'b1),
    .smc_haddr4         (32'd0),
    .smc_htrans4        (2'b00),
    .smc_hsel4          (1'b0),
    .smc_hwrite4        (1'b0),
    .smc_hsize4         (3'd0),
    .smc_hwdata4        (32'd0),
    .smc_hready_in4     (1'b1),
    .smc_hburst4        (3'b000),
    .smc_hprot4         (4'b0000),
    .smc_hmaster4       (4'b0000),
    .smc_hmastlock4     (1'b0),

    //interrupt4 from DMA4
    .DMA_irq4           (1'b0),      

    // Scan4 inputs4
    .scan_en4           (1'b0),         // Scan4 enable pin4
    .scan_in_14         (1'b0),         // Scan4 input for first chain4
    .scan_in_24         (1'b0),        // Scan4 input for second chain4
    .scan_mode4         (1'b0),
    //input for smc4
    .data_smc4          (32'd0),
    //inputs4 for uart4
    .ua_rxd4            (uart_s04.txd4),
    .ua_rxd14           (uart_s14.txd4),
    .ua_ncts4           (uart_s04.cts_n4),
    .ua_ncts14          (uart_s14.cts_n4),
    //inputs4 for spi4
    .n_ss_in4           (1'b1),
    .mi4                (spi_s04.sig_so4),
    .si4                (1'b0),
    .sclk_in4           (1'b0),
    //inputs4 for GPIO4
    .gpio_pin_in4       (gpio_s04.gpio_pin_in4[15:0]),
 
//interrupt4 from Enet4 MAC4
     .macb0_int4     (1'b0),
     .macb1_int4     (1'b0),
     .macb2_int4     (1'b0),
     .macb3_int4     (1'b0),

    // Scan4 outputs4
    .scan_out_14        (),             // Scan4 out for chain4 1
    .scan_out_24        (),             // Scan4 out for chain4 2
   
    //output from APB4 
    // AHB4 interface for AHB2APB4 bridge4
    .hrdata4            (hrdata4),       // Read data provided from target slave4
    .hready4            (hready4),       // Ready4 for new bus cycle from target slave4
    .hresp4             (hresp4),        // Response4 from the bridge4

    // AHB4 interface for SMC4
    .smc_hrdata4        (), 
    .smc_hready4        (),
    .smc_hresp4         (),
  
    //outputs4 from smc4
    .smc_n_ext_oe4      (),
    .smc_data4          (),
    .smc_addr4          (),
    .smc_n_be4          (),
    .smc_n_cs4          (), 
    .smc_n_we4          (),
    .smc_n_wr4          (),
    .smc_n_rd4          (),
    //outputs4 from uart4
    .ua_txd4             (uart_s04.rxd4),
    .ua_txd14            (uart_s14.rxd4),
    .ua_nrts4            (uart_s04.rts_n4),
    .ua_nrts14           (uart_s14.rts_n4),
    // outputs4 from ttc4
    .so                (),
    .mo4                (spi_s04.sig_si4),
    .sclk_out4          (spi_s04.sig_sclk_in4),
    .n_ss_out4          (n_ss_out4[7:0]),
    .n_so_en4           (),
    .n_mo_en4           (),
    .n_sclk_en4         (),
    .n_ss_en4           (),
    //outputs4 from gpio4
    .n_gpio_pin_oe4     (gpio_s04.n_gpio_pin_oe4[15:0]),
    .gpio_pin_out4      (gpio_s04.gpio_pin_out4[15:0]),

//unconnected4 o/p ports4
    .clk_SRPG_macb0_en4(),
    .clk_SRPG_macb1_en4(),
    .clk_SRPG_macb2_en4(),
    .clk_SRPG_macb3_en4(),
    .core06v4(),
    .core08v4(),
    .core10v4(),
    .core12v4(),
    .mte_smc_start4(),
    .mte_uart_start4(),
    .mte_smc_uart_start4(),
    .mte_pm_smc_to_default_start4(),
    .mte_pm_uart_to_default_start4(),
    .mte_pm_smc_uart_to_default_start4(),
    .pcm_irq4(),
    .ttc_irq4(),
    .gpio_irq4(),
    .uart0_irq4(),
    .uart1_irq4(),
    .spi_irq4(),

    .macb3_wakeup4(),
    .macb2_wakeup4(),
    .macb1_wakeup4(),
    .macb0_wakeup4()
);


initial
begin
  tb_hclk4 = 0;
  hresetn4 = 1;

  #1 hresetn4 = 0;
  #1200 hresetn4 = 1;
end

always #50 tb_hclk4 = ~tb_hclk4;

initial begin
  uvm_config_db#(virtual uart_if4)::set(null, "uvm_test_top.ve4.uart04*", "vif4", uart_s04);
  uvm_config_db#(virtual uart_if4)::set(null, "uvm_test_top.ve4.uart14*", "vif4", uart_s14);
  uvm_config_db#(virtual uart_ctrl_internal_if4)::set(null, "uvm_test_top.ve4.apb_ss_env4.apb_uart04.*", "vif4", uart_int04);
  uvm_config_db#(virtual uart_ctrl_internal_if4)::set(null, "uvm_test_top.ve4.apb_ss_env4.apb_uart14.*", "vif4", uart_int14);
  uvm_config_db#(virtual apb_if4)::set(null, "uvm_test_top.ve4.apb04*", "vif4", apbi_mo4);
  uvm_config_db#(virtual ahb_if4)::set(null, "uvm_test_top.ve4.ahb04*", "vif4", ahbi_m04);
  uvm_config_db#(virtual spi_if4)::set(null, "uvm_test_top.ve4.spi04*", "spi_if4", spi_s04);
  uvm_config_db#(virtual gpio_if4)::set(null, "uvm_test_top.ve4.gpio04*", "gpio_if4", gpio_s04);
  run_test();
end

endmodule
