/*-------------------------------------------------------------------------
File21 name   : apb_subsystem_top21.v 
Title21       : Top21 level file for the testbench 
Project21     : APB21 Subsystem21
Created21     : March21 2008
Description21 : This21 is top level file which instantiate21 the dut21 apb_subsyste21,.v.
              It also has the assertion21 module which checks21 for the power21 down 
              and power21 up.To21 activate21 the assertion21 ifdef LP_ABV_ON21 is used.       
Notes21       :
-------------------------------------------------------------------------*/ 
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------

 `timescale 1ns/10ps


// Environment21 Constants21
`ifndef AHB_DATA_WIDTH21
  `define AHB_DATA_WIDTH21          32              // AHB21 bus data width [32/64]
`endif
`ifndef AHB_ADDR_WIDTH21
  `define AHB_ADDR_WIDTH21          32              // AHB21 bus address width [32/64]
`endif
`ifndef AHB_DATA_MAX_BIT21
  `define AHB_DATA_MAX_BIT21        31              // MUST21 BE21: AHB_DATA_WIDTH21 - 1
`endif
`ifndef AHB_ADDRESS_MAX_BIT21
  `define AHB_ADDRESS_MAX_BIT21     31              // MUST21 BE21: AHB_ADDR_WIDTH21 - 1
`endif
`ifndef DEFAULT_HREADY_VALUE21
  `define DEFAULT_HREADY_VALUE21    1'b1            // Ready21 Asserted21
`endif

`include "ahb_if21.sv"
`include "apb_if21.sv"
`include "apb_master_if21.sv"
`include "apb_slave_if21.sv"
`include "uart_if21.sv"
`include "spi_if21.sv"
`include "gpio_if21.sv"
`include "coverage21/uart_ctrl_internal_if21.sv"

module apb_subsystem_top21;
  import uvm_pkg::*;
  // Import21 the UVM Utilities21 Package21

  import ahb_pkg21::*;
  import apb_pkg21::*;
  import uart_pkg21::*;
  import gpio_pkg21::*;
  import spi_pkg21::*;
  import uart_ctrl_pkg21::*;
  import apb_subsystem_pkg21::*;

  `include "spi_reg_model21.sv"
  `include "gpio_reg_model21.sv"
  `include "apb_subsystem_reg_rdb21.sv"
  `include "uart_ctrl_reg_seq_lib21.sv"
  `include "spi_reg_seq_lib21.sv"
  `include "gpio_reg_seq_lib21.sv"

  //Include21 module UVC21 sequences
  `include "ahb_user_monitor21.sv"
  `include "apb_subsystem_seq_lib21.sv"
  `include "apb_subsystem_vir_sequencer21.sv"
  `include "apb_subsystem_vir_seq_lib21.sv"

  `include "apb_subsystem_tb21.sv"
  `include "test_lib21.sv"
   
  
   // ====================================
   // SHARED21 signals21
   // ====================================
   
   // clock21
   reg tb_hclk21;
   
   // reset
   reg hresetn21;
   
   // post21-mux21 from master21 mux21
   wire [`AHB_DATA_MAX_BIT21:0] hwdata21;
   wire [`AHB_ADDRESS_MAX_BIT21:0] haddr21;
   wire [1:0]  htrans21;
   wire [2:0]  hburst21;
   wire [2:0]  hsize21;
   wire [3:0]  hprot21;
   wire hwrite21;

   // post21-mux21 from slave21 mux21
   wire        hready21;
   wire [1:0]  hresp21;
   wire [`AHB_DATA_MAX_BIT21:0] hrdata21;
  

  //  Specific21 signals21 of apb21 subsystem21
  reg         ua_rxd21;
  reg         ua_ncts21;


  // uart21 outputs21 
  wire        ua_txd21;
  wire        us_nrts21;

  wire   [7:0] n_ss_out21;    // peripheral21 select21 lines21 from master21
  wire   [31:0] hwdata_byte_alligned21;

  reg [2:0] div8_clk21;
 always @(posedge tb_hclk21) begin
   if (!hresetn21)
     div8_clk21 = 3'b000;
   else
     div8_clk21 = div8_clk21 + 1;
 end


  // Master21 virtual interface
  ahb_if21 ahbi_m021(.ahb_clock21(tb_hclk21), .ahb_resetn21(hresetn21));
  
  uart_if21 uart_s021(.clock21(div8_clk21[2]), .reset(hresetn21));
  uart_if21 uart_s121(.clock21(div8_clk21[2]), .reset(hresetn21));
  spi_if21 spi_s021();
  gpio_if21 gpio_s021();
  uart_ctrl_internal_if21 uart_int021(.clock21(div8_clk21[2]));
  uart_ctrl_internal_if21 uart_int121(.clock21(div8_clk21[2]));

  apb_if21 apbi_mo21(.pclock21(tb_hclk21), .preset21(hresetn21));

  //M021
  assign ahbi_m021.AHB_HCLK21 = tb_hclk21;
  assign ahbi_m021.AHB_HRESET21 = hresetn21;
  assign ahbi_m021.AHB_HRESP21 = hresp21;
  assign ahbi_m021.AHB_HRDATA21 = hrdata21;
  assign ahbi_m021.AHB_HREADY21 = hready21;

  assign apbi_mo21.paddr21 = i_apb_subsystem21.i_ahb2apb21.paddr21;
  assign apbi_mo21.prwd21 = i_apb_subsystem21.i_ahb2apb21.pwrite21;
  assign apbi_mo21.pwdata21 = i_apb_subsystem21.i_ahb2apb21.pwdata21;
  assign apbi_mo21.penable21 = i_apb_subsystem21.i_ahb2apb21.penable21;
  assign apbi_mo21.psel21 = {12'b0, i_apb_subsystem21.i_ahb2apb21.psel821, i_apb_subsystem21.i_ahb2apb21.psel221, i_apb_subsystem21.i_ahb2apb21.psel121, i_apb_subsystem21.i_ahb2apb21.psel021};
  assign apbi_mo21.prdata21 = i_apb_subsystem21.i_ahb2apb21.psel021? i_apb_subsystem21.i_ahb2apb21.prdata021 : (i_apb_subsystem21.i_ahb2apb21.psel121? i_apb_subsystem21.i_ahb2apb21.prdata121 : (i_apb_subsystem21.i_ahb2apb21.psel221? i_apb_subsystem21.i_ahb2apb21.prdata221 : i_apb_subsystem21.i_ahb2apb21.prdata821));

  assign spi_s021.sig_n_ss_in21 = n_ss_out21[0];
  assign spi_s021.sig_n_p_reset21 = hresetn21;
  assign spi_s021.sig_pclk21 = tb_hclk21;

  assign gpio_s021.n_p_reset21 = hresetn21;
  assign gpio_s021.pclk21 = tb_hclk21;

  assign hwdata_byte_alligned21 = (ahbi_m021.AHB_HADDR21[1:0] == 2'b00) ? ahbi_m021.AHB_HWDATA21 : {4{ahbi_m021.AHB_HWDATA21[7:0]}};

  apb_subsystem_021 i_apb_subsystem21 (
    // Inputs21
    // system signals21
    .hclk21              (tb_hclk21),     // AHB21 Clock21
    .n_hreset21          (hresetn21),     // AHB21 reset - Active21 low21
    .pclk21              (tb_hclk21),     // APB21 Clock21
    .n_preset21          (hresetn21),     // APB21 reset - Active21 low21
    
    // AHB21 interface for AHB2APM21 bridge21
    .hsel21     (1'b1),        // AHB2APB21 select21
    .haddr21             (ahbi_m021.AHB_HADDR21),        // Address bus
    .htrans21            (ahbi_m021.AHB_HTRANS21),       // Transfer21 type
    .hsize21             (ahbi_m021.AHB_HSIZE21),        // AHB21 Access type - byte half21-word21 word21
    .hwrite21            (ahbi_m021.AHB_HWRITE21),       // Write signal21
    .hwdata21            (hwdata_byte_alligned21),       // Write data
    .hready_in21         (hready21),       // Indicates21 that the last master21 has finished21 
                                       // its bus access
    .hburst21            (ahbi_m021.AHB_HBURST21),       // Burst type
    .hprot21             (ahbi_m021.AHB_HPROT21),        // Protection21 control21
    .hmaster21           (4'h0),      // Master21 select21
    .hmastlock21         (ahbi_m021.AHB_HLOCK21),  // Locked21 transfer21
    // AHB21 interface for SMC21
    .smc_hclk21          (1'b0),
    .smc_n_hclk21        (1'b1),
    .smc_haddr21         (32'd0),
    .smc_htrans21        (2'b00),
    .smc_hsel21          (1'b0),
    .smc_hwrite21        (1'b0),
    .smc_hsize21         (3'd0),
    .smc_hwdata21        (32'd0),
    .smc_hready_in21     (1'b1),
    .smc_hburst21        (3'b000),
    .smc_hprot21         (4'b0000),
    .smc_hmaster21       (4'b0000),
    .smc_hmastlock21     (1'b0),

    //interrupt21 from DMA21
    .DMA_irq21           (1'b0),      

    // Scan21 inputs21
    .scan_en21           (1'b0),         // Scan21 enable pin21
    .scan_in_121         (1'b0),         // Scan21 input for first chain21
    .scan_in_221         (1'b0),        // Scan21 input for second chain21
    .scan_mode21         (1'b0),
    //input for smc21
    .data_smc21          (32'd0),
    //inputs21 for uart21
    .ua_rxd21            (uart_s021.txd21),
    .ua_rxd121           (uart_s121.txd21),
    .ua_ncts21           (uart_s021.cts_n21),
    .ua_ncts121          (uart_s121.cts_n21),
    //inputs21 for spi21
    .n_ss_in21           (1'b1),
    .mi21                (spi_s021.sig_so21),
    .si21                (1'b0),
    .sclk_in21           (1'b0),
    //inputs21 for GPIO21
    .gpio_pin_in21       (gpio_s021.gpio_pin_in21[15:0]),
 
//interrupt21 from Enet21 MAC21
     .macb0_int21     (1'b0),
     .macb1_int21     (1'b0),
     .macb2_int21     (1'b0),
     .macb3_int21     (1'b0),

    // Scan21 outputs21
    .scan_out_121        (),             // Scan21 out for chain21 1
    .scan_out_221        (),             // Scan21 out for chain21 2
   
    //output from APB21 
    // AHB21 interface for AHB2APB21 bridge21
    .hrdata21            (hrdata21),       // Read data provided from target slave21
    .hready21            (hready21),       // Ready21 for new bus cycle from target slave21
    .hresp21             (hresp21),        // Response21 from the bridge21

    // AHB21 interface for SMC21
    .smc_hrdata21        (), 
    .smc_hready21        (),
    .smc_hresp21         (),
  
    //outputs21 from smc21
    .smc_n_ext_oe21      (),
    .smc_data21          (),
    .smc_addr21          (),
    .smc_n_be21          (),
    .smc_n_cs21          (), 
    .smc_n_we21          (),
    .smc_n_wr21          (),
    .smc_n_rd21          (),
    //outputs21 from uart21
    .ua_txd21             (uart_s021.rxd21),
    .ua_txd121            (uart_s121.rxd21),
    .ua_nrts21            (uart_s021.rts_n21),
    .ua_nrts121           (uart_s121.rts_n21),
    // outputs21 from ttc21
    .so                (),
    .mo21                (spi_s021.sig_si21),
    .sclk_out21          (spi_s021.sig_sclk_in21),
    .n_ss_out21          (n_ss_out21[7:0]),
    .n_so_en21           (),
    .n_mo_en21           (),
    .n_sclk_en21         (),
    .n_ss_en21           (),
    //outputs21 from gpio21
    .n_gpio_pin_oe21     (gpio_s021.n_gpio_pin_oe21[15:0]),
    .gpio_pin_out21      (gpio_s021.gpio_pin_out21[15:0]),

//unconnected21 o/p ports21
    .clk_SRPG_macb0_en21(),
    .clk_SRPG_macb1_en21(),
    .clk_SRPG_macb2_en21(),
    .clk_SRPG_macb3_en21(),
    .core06v21(),
    .core08v21(),
    .core10v21(),
    .core12v21(),
    .mte_smc_start21(),
    .mte_uart_start21(),
    .mte_smc_uart_start21(),
    .mte_pm_smc_to_default_start21(),
    .mte_pm_uart_to_default_start21(),
    .mte_pm_smc_uart_to_default_start21(),
    .pcm_irq21(),
    .ttc_irq21(),
    .gpio_irq21(),
    .uart0_irq21(),
    .uart1_irq21(),
    .spi_irq21(),

    .macb3_wakeup21(),
    .macb2_wakeup21(),
    .macb1_wakeup21(),
    .macb0_wakeup21()
);


initial
begin
  tb_hclk21 = 0;
  hresetn21 = 1;

  #1 hresetn21 = 0;
  #1200 hresetn21 = 1;
end

always #50 tb_hclk21 = ~tb_hclk21;

initial begin
  uvm_config_db#(virtual uart_if21)::set(null, "uvm_test_top.ve21.uart021*", "vif21", uart_s021);
  uvm_config_db#(virtual uart_if21)::set(null, "uvm_test_top.ve21.uart121*", "vif21", uart_s121);
  uvm_config_db#(virtual uart_ctrl_internal_if21)::set(null, "uvm_test_top.ve21.apb_ss_env21.apb_uart021.*", "vif21", uart_int021);
  uvm_config_db#(virtual uart_ctrl_internal_if21)::set(null, "uvm_test_top.ve21.apb_ss_env21.apb_uart121.*", "vif21", uart_int121);
  uvm_config_db#(virtual apb_if21)::set(null, "uvm_test_top.ve21.apb021*", "vif21", apbi_mo21);
  uvm_config_db#(virtual ahb_if21)::set(null, "uvm_test_top.ve21.ahb021*", "vif21", ahbi_m021);
  uvm_config_db#(virtual spi_if21)::set(null, "uvm_test_top.ve21.spi021*", "spi_if21", spi_s021);
  uvm_config_db#(virtual gpio_if21)::set(null, "uvm_test_top.ve21.gpio021*", "gpio_if21", gpio_s021);
  run_test();
end

endmodule
