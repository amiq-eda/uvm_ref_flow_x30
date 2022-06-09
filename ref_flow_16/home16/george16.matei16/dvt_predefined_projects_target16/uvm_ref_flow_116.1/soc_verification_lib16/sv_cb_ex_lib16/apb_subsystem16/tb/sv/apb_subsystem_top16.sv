/*-------------------------------------------------------------------------
File16 name   : apb_subsystem_top16.v 
Title16       : Top16 level file for the testbench 
Project16     : APB16 Subsystem16
Created16     : March16 2008
Description16 : This16 is top level file which instantiate16 the dut16 apb_subsyste16,.v.
              It also has the assertion16 module which checks16 for the power16 down 
              and power16 up.To16 activate16 the assertion16 ifdef LP_ABV_ON16 is used.       
Notes16       :
-------------------------------------------------------------------------*/ 
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------

 `timescale 1ns/10ps


// Environment16 Constants16
`ifndef AHB_DATA_WIDTH16
  `define AHB_DATA_WIDTH16          32              // AHB16 bus data width [32/64]
`endif
`ifndef AHB_ADDR_WIDTH16
  `define AHB_ADDR_WIDTH16          32              // AHB16 bus address width [32/64]
`endif
`ifndef AHB_DATA_MAX_BIT16
  `define AHB_DATA_MAX_BIT16        31              // MUST16 BE16: AHB_DATA_WIDTH16 - 1
`endif
`ifndef AHB_ADDRESS_MAX_BIT16
  `define AHB_ADDRESS_MAX_BIT16     31              // MUST16 BE16: AHB_ADDR_WIDTH16 - 1
`endif
`ifndef DEFAULT_HREADY_VALUE16
  `define DEFAULT_HREADY_VALUE16    1'b1            // Ready16 Asserted16
`endif

`include "ahb_if16.sv"
`include "apb_if16.sv"
`include "apb_master_if16.sv"
`include "apb_slave_if16.sv"
`include "uart_if16.sv"
`include "spi_if16.sv"
`include "gpio_if16.sv"
`include "coverage16/uart_ctrl_internal_if16.sv"

module apb_subsystem_top16;
  import uvm_pkg::*;
  // Import16 the UVM Utilities16 Package16

  import ahb_pkg16::*;
  import apb_pkg16::*;
  import uart_pkg16::*;
  import gpio_pkg16::*;
  import spi_pkg16::*;
  import uart_ctrl_pkg16::*;
  import apb_subsystem_pkg16::*;

  `include "spi_reg_model16.sv"
  `include "gpio_reg_model16.sv"
  `include "apb_subsystem_reg_rdb16.sv"
  `include "uart_ctrl_reg_seq_lib16.sv"
  `include "spi_reg_seq_lib16.sv"
  `include "gpio_reg_seq_lib16.sv"

  //Include16 module UVC16 sequences
  `include "ahb_user_monitor16.sv"
  `include "apb_subsystem_seq_lib16.sv"
  `include "apb_subsystem_vir_sequencer16.sv"
  `include "apb_subsystem_vir_seq_lib16.sv"

  `include "apb_subsystem_tb16.sv"
  `include "test_lib16.sv"
   
  
   // ====================================
   // SHARED16 signals16
   // ====================================
   
   // clock16
   reg tb_hclk16;
   
   // reset
   reg hresetn16;
   
   // post16-mux16 from master16 mux16
   wire [`AHB_DATA_MAX_BIT16:0] hwdata16;
   wire [`AHB_ADDRESS_MAX_BIT16:0] haddr16;
   wire [1:0]  htrans16;
   wire [2:0]  hburst16;
   wire [2:0]  hsize16;
   wire [3:0]  hprot16;
   wire hwrite16;

   // post16-mux16 from slave16 mux16
   wire        hready16;
   wire [1:0]  hresp16;
   wire [`AHB_DATA_MAX_BIT16:0] hrdata16;
  

  //  Specific16 signals16 of apb16 subsystem16
  reg         ua_rxd16;
  reg         ua_ncts16;


  // uart16 outputs16 
  wire        ua_txd16;
  wire        us_nrts16;

  wire   [7:0] n_ss_out16;    // peripheral16 select16 lines16 from master16
  wire   [31:0] hwdata_byte_alligned16;

  reg [2:0] div8_clk16;
 always @(posedge tb_hclk16) begin
   if (!hresetn16)
     div8_clk16 = 3'b000;
   else
     div8_clk16 = div8_clk16 + 1;
 end


  // Master16 virtual interface
  ahb_if16 ahbi_m016(.ahb_clock16(tb_hclk16), .ahb_resetn16(hresetn16));
  
  uart_if16 uart_s016(.clock16(div8_clk16[2]), .reset(hresetn16));
  uart_if16 uart_s116(.clock16(div8_clk16[2]), .reset(hresetn16));
  spi_if16 spi_s016();
  gpio_if16 gpio_s016();
  uart_ctrl_internal_if16 uart_int016(.clock16(div8_clk16[2]));
  uart_ctrl_internal_if16 uart_int116(.clock16(div8_clk16[2]));

  apb_if16 apbi_mo16(.pclock16(tb_hclk16), .preset16(hresetn16));

  //M016
  assign ahbi_m016.AHB_HCLK16 = tb_hclk16;
  assign ahbi_m016.AHB_HRESET16 = hresetn16;
  assign ahbi_m016.AHB_HRESP16 = hresp16;
  assign ahbi_m016.AHB_HRDATA16 = hrdata16;
  assign ahbi_m016.AHB_HREADY16 = hready16;

  assign apbi_mo16.paddr16 = i_apb_subsystem16.i_ahb2apb16.paddr16;
  assign apbi_mo16.prwd16 = i_apb_subsystem16.i_ahb2apb16.pwrite16;
  assign apbi_mo16.pwdata16 = i_apb_subsystem16.i_ahb2apb16.pwdata16;
  assign apbi_mo16.penable16 = i_apb_subsystem16.i_ahb2apb16.penable16;
  assign apbi_mo16.psel16 = {12'b0, i_apb_subsystem16.i_ahb2apb16.psel816, i_apb_subsystem16.i_ahb2apb16.psel216, i_apb_subsystem16.i_ahb2apb16.psel116, i_apb_subsystem16.i_ahb2apb16.psel016};
  assign apbi_mo16.prdata16 = i_apb_subsystem16.i_ahb2apb16.psel016? i_apb_subsystem16.i_ahb2apb16.prdata016 : (i_apb_subsystem16.i_ahb2apb16.psel116? i_apb_subsystem16.i_ahb2apb16.prdata116 : (i_apb_subsystem16.i_ahb2apb16.psel216? i_apb_subsystem16.i_ahb2apb16.prdata216 : i_apb_subsystem16.i_ahb2apb16.prdata816));

  assign spi_s016.sig_n_ss_in16 = n_ss_out16[0];
  assign spi_s016.sig_n_p_reset16 = hresetn16;
  assign spi_s016.sig_pclk16 = tb_hclk16;

  assign gpio_s016.n_p_reset16 = hresetn16;
  assign gpio_s016.pclk16 = tb_hclk16;

  assign hwdata_byte_alligned16 = (ahbi_m016.AHB_HADDR16[1:0] == 2'b00) ? ahbi_m016.AHB_HWDATA16 : {4{ahbi_m016.AHB_HWDATA16[7:0]}};

  apb_subsystem_016 i_apb_subsystem16 (
    // Inputs16
    // system signals16
    .hclk16              (tb_hclk16),     // AHB16 Clock16
    .n_hreset16          (hresetn16),     // AHB16 reset - Active16 low16
    .pclk16              (tb_hclk16),     // APB16 Clock16
    .n_preset16          (hresetn16),     // APB16 reset - Active16 low16
    
    // AHB16 interface for AHB2APM16 bridge16
    .hsel16     (1'b1),        // AHB2APB16 select16
    .haddr16             (ahbi_m016.AHB_HADDR16),        // Address bus
    .htrans16            (ahbi_m016.AHB_HTRANS16),       // Transfer16 type
    .hsize16             (ahbi_m016.AHB_HSIZE16),        // AHB16 Access type - byte half16-word16 word16
    .hwrite16            (ahbi_m016.AHB_HWRITE16),       // Write signal16
    .hwdata16            (hwdata_byte_alligned16),       // Write data
    .hready_in16         (hready16),       // Indicates16 that the last master16 has finished16 
                                       // its bus access
    .hburst16            (ahbi_m016.AHB_HBURST16),       // Burst type
    .hprot16             (ahbi_m016.AHB_HPROT16),        // Protection16 control16
    .hmaster16           (4'h0),      // Master16 select16
    .hmastlock16         (ahbi_m016.AHB_HLOCK16),  // Locked16 transfer16
    // AHB16 interface for SMC16
    .smc_hclk16          (1'b0),
    .smc_n_hclk16        (1'b1),
    .smc_haddr16         (32'd0),
    .smc_htrans16        (2'b00),
    .smc_hsel16          (1'b0),
    .smc_hwrite16        (1'b0),
    .smc_hsize16         (3'd0),
    .smc_hwdata16        (32'd0),
    .smc_hready_in16     (1'b1),
    .smc_hburst16        (3'b000),
    .smc_hprot16         (4'b0000),
    .smc_hmaster16       (4'b0000),
    .smc_hmastlock16     (1'b0),

    //interrupt16 from DMA16
    .DMA_irq16           (1'b0),      

    // Scan16 inputs16
    .scan_en16           (1'b0),         // Scan16 enable pin16
    .scan_in_116         (1'b0),         // Scan16 input for first chain16
    .scan_in_216         (1'b0),        // Scan16 input for second chain16
    .scan_mode16         (1'b0),
    //input for smc16
    .data_smc16          (32'd0),
    //inputs16 for uart16
    .ua_rxd16            (uart_s016.txd16),
    .ua_rxd116           (uart_s116.txd16),
    .ua_ncts16           (uart_s016.cts_n16),
    .ua_ncts116          (uart_s116.cts_n16),
    //inputs16 for spi16
    .n_ss_in16           (1'b1),
    .mi16                (spi_s016.sig_so16),
    .si16                (1'b0),
    .sclk_in16           (1'b0),
    //inputs16 for GPIO16
    .gpio_pin_in16       (gpio_s016.gpio_pin_in16[15:0]),
 
//interrupt16 from Enet16 MAC16
     .macb0_int16     (1'b0),
     .macb1_int16     (1'b0),
     .macb2_int16     (1'b0),
     .macb3_int16     (1'b0),

    // Scan16 outputs16
    .scan_out_116        (),             // Scan16 out for chain16 1
    .scan_out_216        (),             // Scan16 out for chain16 2
   
    //output from APB16 
    // AHB16 interface for AHB2APB16 bridge16
    .hrdata16            (hrdata16),       // Read data provided from target slave16
    .hready16            (hready16),       // Ready16 for new bus cycle from target slave16
    .hresp16             (hresp16),        // Response16 from the bridge16

    // AHB16 interface for SMC16
    .smc_hrdata16        (), 
    .smc_hready16        (),
    .smc_hresp16         (),
  
    //outputs16 from smc16
    .smc_n_ext_oe16      (),
    .smc_data16          (),
    .smc_addr16          (),
    .smc_n_be16          (),
    .smc_n_cs16          (), 
    .smc_n_we16          (),
    .smc_n_wr16          (),
    .smc_n_rd16          (),
    //outputs16 from uart16
    .ua_txd16             (uart_s016.rxd16),
    .ua_txd116            (uart_s116.rxd16),
    .ua_nrts16            (uart_s016.rts_n16),
    .ua_nrts116           (uart_s116.rts_n16),
    // outputs16 from ttc16
    .so                (),
    .mo16                (spi_s016.sig_si16),
    .sclk_out16          (spi_s016.sig_sclk_in16),
    .n_ss_out16          (n_ss_out16[7:0]),
    .n_so_en16           (),
    .n_mo_en16           (),
    .n_sclk_en16         (),
    .n_ss_en16           (),
    //outputs16 from gpio16
    .n_gpio_pin_oe16     (gpio_s016.n_gpio_pin_oe16[15:0]),
    .gpio_pin_out16      (gpio_s016.gpio_pin_out16[15:0]),

//unconnected16 o/p ports16
    .clk_SRPG_macb0_en16(),
    .clk_SRPG_macb1_en16(),
    .clk_SRPG_macb2_en16(),
    .clk_SRPG_macb3_en16(),
    .core06v16(),
    .core08v16(),
    .core10v16(),
    .core12v16(),
    .mte_smc_start16(),
    .mte_uart_start16(),
    .mte_smc_uart_start16(),
    .mte_pm_smc_to_default_start16(),
    .mte_pm_uart_to_default_start16(),
    .mte_pm_smc_uart_to_default_start16(),
    .pcm_irq16(),
    .ttc_irq16(),
    .gpio_irq16(),
    .uart0_irq16(),
    .uart1_irq16(),
    .spi_irq16(),

    .macb3_wakeup16(),
    .macb2_wakeup16(),
    .macb1_wakeup16(),
    .macb0_wakeup16()
);


initial
begin
  tb_hclk16 = 0;
  hresetn16 = 1;

  #1 hresetn16 = 0;
  #1200 hresetn16 = 1;
end

always #50 tb_hclk16 = ~tb_hclk16;

initial begin
  uvm_config_db#(virtual uart_if16)::set(null, "uvm_test_top.ve16.uart016*", "vif16", uart_s016);
  uvm_config_db#(virtual uart_if16)::set(null, "uvm_test_top.ve16.uart116*", "vif16", uart_s116);
  uvm_config_db#(virtual uart_ctrl_internal_if16)::set(null, "uvm_test_top.ve16.apb_ss_env16.apb_uart016.*", "vif16", uart_int016);
  uvm_config_db#(virtual uart_ctrl_internal_if16)::set(null, "uvm_test_top.ve16.apb_ss_env16.apb_uart116.*", "vif16", uart_int116);
  uvm_config_db#(virtual apb_if16)::set(null, "uvm_test_top.ve16.apb016*", "vif16", apbi_mo16);
  uvm_config_db#(virtual ahb_if16)::set(null, "uvm_test_top.ve16.ahb016*", "vif16", ahbi_m016);
  uvm_config_db#(virtual spi_if16)::set(null, "uvm_test_top.ve16.spi016*", "spi_if16", spi_s016);
  uvm_config_db#(virtual gpio_if16)::set(null, "uvm_test_top.ve16.gpio016*", "gpio_if16", gpio_s016);
  run_test();
end

endmodule
