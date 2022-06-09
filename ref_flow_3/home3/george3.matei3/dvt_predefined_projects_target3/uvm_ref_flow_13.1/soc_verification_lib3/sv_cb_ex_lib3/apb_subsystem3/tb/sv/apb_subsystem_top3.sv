/*-------------------------------------------------------------------------
File3 name   : apb_subsystem_top3.v 
Title3       : Top3 level file for the testbench 
Project3     : APB3 Subsystem3
Created3     : March3 2008
Description3 : This3 is top level file which instantiate3 the dut3 apb_subsyste3,.v.
              It also has the assertion3 module which checks3 for the power3 down 
              and power3 up.To3 activate3 the assertion3 ifdef LP_ABV_ON3 is used.       
Notes3       :
-------------------------------------------------------------------------*/ 
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------

 `timescale 1ns/10ps


// Environment3 Constants3
`ifndef AHB_DATA_WIDTH3
  `define AHB_DATA_WIDTH3          32              // AHB3 bus data width [32/64]
`endif
`ifndef AHB_ADDR_WIDTH3
  `define AHB_ADDR_WIDTH3          32              // AHB3 bus address width [32/64]
`endif
`ifndef AHB_DATA_MAX_BIT3
  `define AHB_DATA_MAX_BIT3        31              // MUST3 BE3: AHB_DATA_WIDTH3 - 1
`endif
`ifndef AHB_ADDRESS_MAX_BIT3
  `define AHB_ADDRESS_MAX_BIT3     31              // MUST3 BE3: AHB_ADDR_WIDTH3 - 1
`endif
`ifndef DEFAULT_HREADY_VALUE3
  `define DEFAULT_HREADY_VALUE3    1'b1            // Ready3 Asserted3
`endif

`include "ahb_if3.sv"
`include "apb_if3.sv"
`include "apb_master_if3.sv"
`include "apb_slave_if3.sv"
`include "uart_if3.sv"
`include "spi_if3.sv"
`include "gpio_if3.sv"
`include "coverage3/uart_ctrl_internal_if3.sv"

module apb_subsystem_top3;
  import uvm_pkg::*;
  // Import3 the UVM Utilities3 Package3

  import ahb_pkg3::*;
  import apb_pkg3::*;
  import uart_pkg3::*;
  import gpio_pkg3::*;
  import spi_pkg3::*;
  import uart_ctrl_pkg3::*;
  import apb_subsystem_pkg3::*;

  `include "spi_reg_model3.sv"
  `include "gpio_reg_model3.sv"
  `include "apb_subsystem_reg_rdb3.sv"
  `include "uart_ctrl_reg_seq_lib3.sv"
  `include "spi_reg_seq_lib3.sv"
  `include "gpio_reg_seq_lib3.sv"

  //Include3 module UVC3 sequences
  `include "ahb_user_monitor3.sv"
  `include "apb_subsystem_seq_lib3.sv"
  `include "apb_subsystem_vir_sequencer3.sv"
  `include "apb_subsystem_vir_seq_lib3.sv"

  `include "apb_subsystem_tb3.sv"
  `include "test_lib3.sv"
   
  
   // ====================================
   // SHARED3 signals3
   // ====================================
   
   // clock3
   reg tb_hclk3;
   
   // reset
   reg hresetn3;
   
   // post3-mux3 from master3 mux3
   wire [`AHB_DATA_MAX_BIT3:0] hwdata3;
   wire [`AHB_ADDRESS_MAX_BIT3:0] haddr3;
   wire [1:0]  htrans3;
   wire [2:0]  hburst3;
   wire [2:0]  hsize3;
   wire [3:0]  hprot3;
   wire hwrite3;

   // post3-mux3 from slave3 mux3
   wire        hready3;
   wire [1:0]  hresp3;
   wire [`AHB_DATA_MAX_BIT3:0] hrdata3;
  

  //  Specific3 signals3 of apb3 subsystem3
  reg         ua_rxd3;
  reg         ua_ncts3;


  // uart3 outputs3 
  wire        ua_txd3;
  wire        us_nrts3;

  wire   [7:0] n_ss_out3;    // peripheral3 select3 lines3 from master3
  wire   [31:0] hwdata_byte_alligned3;

  reg [2:0] div8_clk3;
 always @(posedge tb_hclk3) begin
   if (!hresetn3)
     div8_clk3 = 3'b000;
   else
     div8_clk3 = div8_clk3 + 1;
 end


  // Master3 virtual interface
  ahb_if3 ahbi_m03(.ahb_clock3(tb_hclk3), .ahb_resetn3(hresetn3));
  
  uart_if3 uart_s03(.clock3(div8_clk3[2]), .reset(hresetn3));
  uart_if3 uart_s13(.clock3(div8_clk3[2]), .reset(hresetn3));
  spi_if3 spi_s03();
  gpio_if3 gpio_s03();
  uart_ctrl_internal_if3 uart_int03(.clock3(div8_clk3[2]));
  uart_ctrl_internal_if3 uart_int13(.clock3(div8_clk3[2]));

  apb_if3 apbi_mo3(.pclock3(tb_hclk3), .preset3(hresetn3));

  //M03
  assign ahbi_m03.AHB_HCLK3 = tb_hclk3;
  assign ahbi_m03.AHB_HRESET3 = hresetn3;
  assign ahbi_m03.AHB_HRESP3 = hresp3;
  assign ahbi_m03.AHB_HRDATA3 = hrdata3;
  assign ahbi_m03.AHB_HREADY3 = hready3;

  assign apbi_mo3.paddr3 = i_apb_subsystem3.i_ahb2apb3.paddr3;
  assign apbi_mo3.prwd3 = i_apb_subsystem3.i_ahb2apb3.pwrite3;
  assign apbi_mo3.pwdata3 = i_apb_subsystem3.i_ahb2apb3.pwdata3;
  assign apbi_mo3.penable3 = i_apb_subsystem3.i_ahb2apb3.penable3;
  assign apbi_mo3.psel3 = {12'b0, i_apb_subsystem3.i_ahb2apb3.psel83, i_apb_subsystem3.i_ahb2apb3.psel23, i_apb_subsystem3.i_ahb2apb3.psel13, i_apb_subsystem3.i_ahb2apb3.psel03};
  assign apbi_mo3.prdata3 = i_apb_subsystem3.i_ahb2apb3.psel03? i_apb_subsystem3.i_ahb2apb3.prdata03 : (i_apb_subsystem3.i_ahb2apb3.psel13? i_apb_subsystem3.i_ahb2apb3.prdata13 : (i_apb_subsystem3.i_ahb2apb3.psel23? i_apb_subsystem3.i_ahb2apb3.prdata23 : i_apb_subsystem3.i_ahb2apb3.prdata83));

  assign spi_s03.sig_n_ss_in3 = n_ss_out3[0];
  assign spi_s03.sig_n_p_reset3 = hresetn3;
  assign spi_s03.sig_pclk3 = tb_hclk3;

  assign gpio_s03.n_p_reset3 = hresetn3;
  assign gpio_s03.pclk3 = tb_hclk3;

  assign hwdata_byte_alligned3 = (ahbi_m03.AHB_HADDR3[1:0] == 2'b00) ? ahbi_m03.AHB_HWDATA3 : {4{ahbi_m03.AHB_HWDATA3[7:0]}};

  apb_subsystem_03 i_apb_subsystem3 (
    // Inputs3
    // system signals3
    .hclk3              (tb_hclk3),     // AHB3 Clock3
    .n_hreset3          (hresetn3),     // AHB3 reset - Active3 low3
    .pclk3              (tb_hclk3),     // APB3 Clock3
    .n_preset3          (hresetn3),     // APB3 reset - Active3 low3
    
    // AHB3 interface for AHB2APM3 bridge3
    .hsel3     (1'b1),        // AHB2APB3 select3
    .haddr3             (ahbi_m03.AHB_HADDR3),        // Address bus
    .htrans3            (ahbi_m03.AHB_HTRANS3),       // Transfer3 type
    .hsize3             (ahbi_m03.AHB_HSIZE3),        // AHB3 Access type - byte half3-word3 word3
    .hwrite3            (ahbi_m03.AHB_HWRITE3),       // Write signal3
    .hwdata3            (hwdata_byte_alligned3),       // Write data
    .hready_in3         (hready3),       // Indicates3 that the last master3 has finished3 
                                       // its bus access
    .hburst3            (ahbi_m03.AHB_HBURST3),       // Burst type
    .hprot3             (ahbi_m03.AHB_HPROT3),        // Protection3 control3
    .hmaster3           (4'h0),      // Master3 select3
    .hmastlock3         (ahbi_m03.AHB_HLOCK3),  // Locked3 transfer3
    // AHB3 interface for SMC3
    .smc_hclk3          (1'b0),
    .smc_n_hclk3        (1'b1),
    .smc_haddr3         (32'd0),
    .smc_htrans3        (2'b00),
    .smc_hsel3          (1'b0),
    .smc_hwrite3        (1'b0),
    .smc_hsize3         (3'd0),
    .smc_hwdata3        (32'd0),
    .smc_hready_in3     (1'b1),
    .smc_hburst3        (3'b000),
    .smc_hprot3         (4'b0000),
    .smc_hmaster3       (4'b0000),
    .smc_hmastlock3     (1'b0),

    //interrupt3 from DMA3
    .DMA_irq3           (1'b0),      

    // Scan3 inputs3
    .scan_en3           (1'b0),         // Scan3 enable pin3
    .scan_in_13         (1'b0),         // Scan3 input for first chain3
    .scan_in_23         (1'b0),        // Scan3 input for second chain3
    .scan_mode3         (1'b0),
    //input for smc3
    .data_smc3          (32'd0),
    //inputs3 for uart3
    .ua_rxd3            (uart_s03.txd3),
    .ua_rxd13           (uart_s13.txd3),
    .ua_ncts3           (uart_s03.cts_n3),
    .ua_ncts13          (uart_s13.cts_n3),
    //inputs3 for spi3
    .n_ss_in3           (1'b1),
    .mi3                (spi_s03.sig_so3),
    .si3                (1'b0),
    .sclk_in3           (1'b0),
    //inputs3 for GPIO3
    .gpio_pin_in3       (gpio_s03.gpio_pin_in3[15:0]),
 
//interrupt3 from Enet3 MAC3
     .macb0_int3     (1'b0),
     .macb1_int3     (1'b0),
     .macb2_int3     (1'b0),
     .macb3_int3     (1'b0),

    // Scan3 outputs3
    .scan_out_13        (),             // Scan3 out for chain3 1
    .scan_out_23        (),             // Scan3 out for chain3 2
   
    //output from APB3 
    // AHB3 interface for AHB2APB3 bridge3
    .hrdata3            (hrdata3),       // Read data provided from target slave3
    .hready3            (hready3),       // Ready3 for new bus cycle from target slave3
    .hresp3             (hresp3),        // Response3 from the bridge3

    // AHB3 interface for SMC3
    .smc_hrdata3        (), 
    .smc_hready3        (),
    .smc_hresp3         (),
  
    //outputs3 from smc3
    .smc_n_ext_oe3      (),
    .smc_data3          (),
    .smc_addr3          (),
    .smc_n_be3          (),
    .smc_n_cs3          (), 
    .smc_n_we3          (),
    .smc_n_wr3          (),
    .smc_n_rd3          (),
    //outputs3 from uart3
    .ua_txd3             (uart_s03.rxd3),
    .ua_txd13            (uart_s13.rxd3),
    .ua_nrts3            (uart_s03.rts_n3),
    .ua_nrts13           (uart_s13.rts_n3),
    // outputs3 from ttc3
    .so                (),
    .mo3                (spi_s03.sig_si3),
    .sclk_out3          (spi_s03.sig_sclk_in3),
    .n_ss_out3          (n_ss_out3[7:0]),
    .n_so_en3           (),
    .n_mo_en3           (),
    .n_sclk_en3         (),
    .n_ss_en3           (),
    //outputs3 from gpio3
    .n_gpio_pin_oe3     (gpio_s03.n_gpio_pin_oe3[15:0]),
    .gpio_pin_out3      (gpio_s03.gpio_pin_out3[15:0]),

//unconnected3 o/p ports3
    .clk_SRPG_macb0_en3(),
    .clk_SRPG_macb1_en3(),
    .clk_SRPG_macb2_en3(),
    .clk_SRPG_macb3_en3(),
    .core06v3(),
    .core08v3(),
    .core10v3(),
    .core12v3(),
    .mte_smc_start3(),
    .mte_uart_start3(),
    .mte_smc_uart_start3(),
    .mte_pm_smc_to_default_start3(),
    .mte_pm_uart_to_default_start3(),
    .mte_pm_smc_uart_to_default_start3(),
    .pcm_irq3(),
    .ttc_irq3(),
    .gpio_irq3(),
    .uart0_irq3(),
    .uart1_irq3(),
    .spi_irq3(),

    .macb3_wakeup3(),
    .macb2_wakeup3(),
    .macb1_wakeup3(),
    .macb0_wakeup3()
);


initial
begin
  tb_hclk3 = 0;
  hresetn3 = 1;

  #1 hresetn3 = 0;
  #1200 hresetn3 = 1;
end

always #50 tb_hclk3 = ~tb_hclk3;

initial begin
  uvm_config_db#(virtual uart_if3)::set(null, "uvm_test_top.ve3.uart03*", "vif3", uart_s03);
  uvm_config_db#(virtual uart_if3)::set(null, "uvm_test_top.ve3.uart13*", "vif3", uart_s13);
  uvm_config_db#(virtual uart_ctrl_internal_if3)::set(null, "uvm_test_top.ve3.apb_ss_env3.apb_uart03.*", "vif3", uart_int03);
  uvm_config_db#(virtual uart_ctrl_internal_if3)::set(null, "uvm_test_top.ve3.apb_ss_env3.apb_uart13.*", "vif3", uart_int13);
  uvm_config_db#(virtual apb_if3)::set(null, "uvm_test_top.ve3.apb03*", "vif3", apbi_mo3);
  uvm_config_db#(virtual ahb_if3)::set(null, "uvm_test_top.ve3.ahb03*", "vif3", ahbi_m03);
  uvm_config_db#(virtual spi_if3)::set(null, "uvm_test_top.ve3.spi03*", "spi_if3", spi_s03);
  uvm_config_db#(virtual gpio_if3)::set(null, "uvm_test_top.ve3.gpio03*", "gpio_if3", gpio_s03);
  run_test();
end

endmodule
