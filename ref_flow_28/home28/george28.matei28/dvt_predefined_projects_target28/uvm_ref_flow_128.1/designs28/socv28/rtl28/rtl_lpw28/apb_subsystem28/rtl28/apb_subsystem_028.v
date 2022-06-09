//File28 name   : apb_subsystem_028.v
//Title28       : 
//Created28     : 1999
//Description28 : 
//Notes28       : 
//----------------------------------------------------------------------
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------

module apb_subsystem_028(
    // AHB28 interface
    hclk28,
    n_hreset28,
    hsel28,
    haddr28,
    htrans28,
    hsize28,
    hwrite28,
    hwdata28,
    hready_in28,
    hburst28,
    hprot28,
    hmaster28,
    hmastlock28,
    hrdata28,
    hready28,
    hresp28,
    
    // APB28 system interface
    pclk28,
    n_preset28,
    
    // SPI28 ports28
    n_ss_in28,
    mi28,
    si28,
    sclk_in28,
    so,
    mo28,
    sclk_out28,
    n_ss_out28,
    n_so_en28,
    n_mo_en28,
    n_sclk_en28,
    n_ss_en28,
    
    //UART028 ports28
    ua_rxd28,
    ua_ncts28,
    ua_txd28,
    ua_nrts28,
    
    //UART128 ports28
    ua_rxd128,
    ua_ncts128,
    ua_txd128,
    ua_nrts128,
    
    //GPIO28 ports28
    gpio_pin_in28,
    n_gpio_pin_oe28,
    gpio_pin_out28,
    

    //SMC28 ports28
    smc_hclk28,
    smc_n_hclk28,
    smc_haddr28,
    smc_htrans28,
    smc_hsel28,
    smc_hwrite28,
    smc_hsize28,
    smc_hwdata28,
    smc_hready_in28,
    smc_hburst28,
    smc_hprot28,
    smc_hmaster28,
    smc_hmastlock28,
    smc_hrdata28, 
    smc_hready28,
    smc_hresp28,
    smc_n_ext_oe28,
    smc_data28,
    smc_addr28,
    smc_n_be28,
    smc_n_cs28, 
    smc_n_we28,
    smc_n_wr28,
    smc_n_rd28,
    data_smc28,
    
    //PMC28 ports28
    clk_SRPG_macb0_en28,
    clk_SRPG_macb1_en28,
    clk_SRPG_macb2_en28,
    clk_SRPG_macb3_en28,
    core06v28,
    core08v28,
    core10v28,
    core12v28,
    macb3_wakeup28,
    macb2_wakeup28,
    macb1_wakeup28,
    macb0_wakeup28,
    mte_smc_start28,
    mte_uart_start28,
    mte_smc_uart_start28,  
    mte_pm_smc_to_default_start28, 
    mte_pm_uart_to_default_start28,
    mte_pm_smc_uart_to_default_start28,
    
    
    // Peripheral28 inerrupts28
    pcm_irq28,
    ttc_irq28,
    gpio_irq28,
    uart0_irq28,
    uart1_irq28,
    spi_irq28,
    DMA_irq28,      
    macb0_int28,
    macb1_int28,
    macb2_int28,
    macb3_int28,
   
    // Scan28 ports28
    scan_en28,      // Scan28 enable pin28
    scan_in_128,    // Scan28 input for first chain28
    scan_in_228,    // Scan28 input for second chain28
    scan_mode28,
    scan_out_128,   // Scan28 out for chain28 1
    scan_out_228    // Scan28 out for chain28 2
);

parameter GPIO_WIDTH28 = 16;        // GPIO28 width
parameter P_SIZE28 =   8;              // number28 of peripheral28 select28 lines28
parameter NO_OF_IRQS28  = 17;      //No of irqs28 read by apic28 

// AHB28 interface
input         hclk28;     // AHB28 Clock28
input         n_hreset28;  // AHB28 reset - Active28 low28
input         hsel28;     // AHB2APB28 select28
input [31:0]  haddr28;    // Address bus
input [1:0]   htrans28;   // Transfer28 type
input [2:0]   hsize28;    // AHB28 Access type - byte, half28-word28, word28
input [31:0]  hwdata28;   // Write data
input         hwrite28;   // Write signal28/
input         hready_in28;// Indicates28 that last master28 has finished28 bus access
input [2:0]   hburst28;     // Burst type
input [3:0]   hprot28;      // Protection28 control28
input [3:0]   hmaster28;    // Master28 select28
input         hmastlock28;  // Locked28 transfer28
output [31:0] hrdata28;       // Read data provided from target slave28
output        hready28;       // Ready28 for new bus cycle from target slave28
output [1:0]  hresp28;       // Response28 from the bridge28
    
// APB28 system interface
input         pclk28;     // APB28 Clock28. 
input         n_preset28;  // APB28 reset - Active28 low28
   
// SPI28 ports28
input     n_ss_in28;      // select28 input to slave28
input     mi28;           // data input to master28
input     si28;           // data input to slave28
input     sclk_in28;      // clock28 input to slave28
output    so;                    // data output from slave28
output    mo28;                    // data output from master28
output    sclk_out28;              // clock28 output from master28
output [P_SIZE28-1:0] n_ss_out28;    // peripheral28 select28 lines28 from master28
output    n_so_en28;               // out enable for slave28 data
output    n_mo_en28;               // out enable for master28 data
output    n_sclk_en28;             // out enable for master28 clock28
output    n_ss_en28;               // out enable for master28 peripheral28 lines28

//UART028 ports28
input        ua_rxd28;       // UART28 receiver28 serial28 input pin28
input        ua_ncts28;      // Clear-To28-Send28 flow28 control28
output       ua_txd28;       	// UART28 transmitter28 serial28 output
output       ua_nrts28;      	// Request28-To28-Send28 flow28 control28

// UART128 ports28   
input        ua_rxd128;      // UART28 receiver28 serial28 input pin28
input        ua_ncts128;      // Clear-To28-Send28 flow28 control28
output       ua_txd128;       // UART28 transmitter28 serial28 output
output       ua_nrts128;      // Request28-To28-Send28 flow28 control28

//GPIO28 ports28
input [GPIO_WIDTH28-1:0]      gpio_pin_in28;             // input data from pin28
output [GPIO_WIDTH28-1:0]     n_gpio_pin_oe28;           // output enable signal28 to pin28
output [GPIO_WIDTH28-1:0]     gpio_pin_out28;            // output signal28 to pin28
  
//SMC28 ports28
input        smc_hclk28;
input        smc_n_hclk28;
input [31:0] smc_haddr28;
input [1:0]  smc_htrans28;
input        smc_hsel28;
input        smc_hwrite28;
input [2:0]  smc_hsize28;
input [31:0] smc_hwdata28;
input        smc_hready_in28;
input [2:0]  smc_hburst28;     // Burst type
input [3:0]  smc_hprot28;      // Protection28 control28
input [3:0]  smc_hmaster28;    // Master28 select28
input        smc_hmastlock28;  // Locked28 transfer28
input [31:0] data_smc28;     // EMI28(External28 memory) read data
output [31:0]    smc_hrdata28;
output           smc_hready28;
output [1:0]     smc_hresp28;
output [15:0]    smc_addr28;      // External28 Memory (EMI28) address
output [3:0]     smc_n_be28;      // EMI28 byte enables28 (Active28 LOW28)
output           smc_n_cs28;      // EMI28 Chip28 Selects28 (Active28 LOW28)
output [3:0]     smc_n_we28;      // EMI28 write strobes28 (Active28 LOW28)
output           smc_n_wr28;      // EMI28 write enable (Active28 LOW28)
output           smc_n_rd28;      // EMI28 read stobe28 (Active28 LOW28)
output           smc_n_ext_oe28;  // EMI28 write data output enable
output [31:0]    smc_data28;      // EMI28 write data
       
//PMC28 ports28
output clk_SRPG_macb0_en28;
output clk_SRPG_macb1_en28;
output clk_SRPG_macb2_en28;
output clk_SRPG_macb3_en28;
output core06v28;
output core08v28;
output core10v28;
output core12v28;
output mte_smc_start28;
output mte_uart_start28;
output mte_smc_uart_start28;  
output mte_pm_smc_to_default_start28; 
output mte_pm_uart_to_default_start28;
output mte_pm_smc_uart_to_default_start28;
input macb3_wakeup28;
input macb2_wakeup28;
input macb1_wakeup28;
input macb0_wakeup28;
    

// Peripheral28 interrupts28
output pcm_irq28;
output [2:0] ttc_irq28;
output gpio_irq28;
output uart0_irq28;
output uart1_irq28;
output spi_irq28;
input        macb0_int28;
input        macb1_int28;
input        macb2_int28;
input        macb3_int28;
input        DMA_irq28;
  
//Scan28 ports28
input        scan_en28;    // Scan28 enable pin28
input        scan_in_128;  // Scan28 input for first chain28
input        scan_in_228;  // Scan28 input for second chain28
input        scan_mode28;  // test mode pin28
 output        scan_out_128;   // Scan28 out for chain28 1
 output        scan_out_228;   // Scan28 out for chain28 2  

//------------------------------------------------------------------------------
// if the ROM28 subsystem28 is NOT28 black28 boxed28 
//------------------------------------------------------------------------------
`ifndef FV_KIT_BLACK_BOX_APB_SUBSYSTEM28
   
   wire        hsel28; 
   wire        pclk28;
   wire        n_preset28;
   wire [31:0] prdata_spi28;
   wire [31:0] prdata_uart028;
   wire [31:0] prdata_gpio28;
   wire [31:0] prdata_ttc28;
   wire [31:0] prdata_smc28;
   wire [31:0] prdata_pmc28;
   wire [31:0] prdata_uart128;
   wire        pready_spi28;
   wire        pready_uart028;
   wire        pready_uart128;
   wire        tie_hi_bit28;
   wire  [31:0] hrdata28; 
   wire         hready28;
   wire         hready_in28;
   wire  [1:0]  hresp28;   
   wire  [31:0] pwdata28;  
   wire         pwrite28;
   wire  [31:0] paddr28;  
   wire   psel_spi28;
   wire   psel_uart028;
   wire   psel_gpio28;
   wire   psel_ttc28;
   wire   psel_smc28;
   wire   psel0728;
   wire   psel0828;
   wire   psel0928;
   wire   psel1028;
   wire   psel1128;
   wire   psel1228;
   wire   psel_pmc28;
   wire   psel_uart128;
   wire   penable28;
   wire   [NO_OF_IRQS28:0] int_source28;     // System28 Interrupt28 Sources28
   wire [1:0]             smc_hresp28;     // AHB28 Response28 signal28
   wire                   smc_valid28;     // Ack28 valid address

  //External28 memory interface (EMI28)
  wire [31:0]            smc_addr_int28;  // External28 Memory (EMI28) address
  wire [3:0]             smc_n_be28;      // EMI28 byte enables28 (Active28 LOW28)
  wire                   smc_n_cs28;      // EMI28 Chip28 Selects28 (Active28 LOW28)
  wire [3:0]             smc_n_we28;      // EMI28 write strobes28 (Active28 LOW28)
  wire                   smc_n_wr28;      // EMI28 write enable (Active28 LOW28)
  wire                   smc_n_rd28;      // EMI28 read stobe28 (Active28 LOW28)
 
  //AHB28 Memory Interface28 Control28
  wire                   smc_hsel_int28;
  wire                   smc_busy28;      // smc28 busy
   

//scan28 signals28

   wire                scan_in_128;        //scan28 input
   wire                scan_in_228;        //scan28 input
   wire                scan_en28;         //scan28 enable
   wire                scan_out_128;       //scan28 output
   wire                scan_out_228;       //scan28 output
   wire                byte_sel28;     // byte select28 from bridge28 1=byte, 0=2byte
   wire                UART_int28;     // UART28 module interrupt28 
   wire                ua_uclken28;    // Soft28 control28 of clock28
   wire                UART_int128;     // UART28 module interrupt28 
   wire                ua_uclken128;    // Soft28 control28 of clock28
   wire  [3:1]         TTC_int28;            //Interrupt28 from PCI28 
  // inputs28 to SPI28 
   wire    ext_clk28;                // external28 clock28
   wire    SPI_int28;             // interrupt28 request
  // outputs28 from SPI28
   wire    slave_out_clk28;         // modified slave28 clock28 output
 // gpio28 generic28 inputs28 
   wire  [GPIO_WIDTH28-1:0]   n_gpio_bypass_oe28;        // bypass28 mode enable 
   wire  [GPIO_WIDTH28-1:0]   gpio_bypass_out28;         // bypass28 mode output value 
   wire  [GPIO_WIDTH28-1:0]   tri_state_enable28;   // disables28 op enable -> z 
 // outputs28 
   //amba28 outputs28 
   // gpio28 generic28 outputs28 
   wire       GPIO_int28;                // gpio_interupt28 for input pin28 change 
   wire [GPIO_WIDTH28-1:0]     gpio_bypass_in28;          // bypass28 mode input data value  
                
   wire           cpu_debug28;        // Inhibits28 watchdog28 counter 
   wire            ex_wdz_n28;         // External28 Watchdog28 zero indication28
   wire           rstn_non_srpg_smc28; 
   wire           rstn_non_srpg_urt28;
   wire           isolate_smc28;
   wire           save_edge_smc28;
   wire           restore_edge_smc28;
   wire           save_edge_urt28;
   wire           restore_edge_urt28;
   wire           pwr1_on_smc28;
   wire           pwr2_on_smc28;
   wire           pwr1_on_urt28;
   wire           pwr2_on_urt28;
   // ETH028
   wire            rstn_non_srpg_macb028;
   wire            gate_clk_macb028;
   wire            isolate_macb028;
   wire            save_edge_macb028;
   wire            restore_edge_macb028;
   wire            pwr1_on_macb028;
   wire            pwr2_on_macb028;
   // ETH128
   wire            rstn_non_srpg_macb128;
   wire            gate_clk_macb128;
   wire            isolate_macb128;
   wire            save_edge_macb128;
   wire            restore_edge_macb128;
   wire            pwr1_on_macb128;
   wire            pwr2_on_macb128;
   // ETH228
   wire            rstn_non_srpg_macb228;
   wire            gate_clk_macb228;
   wire            isolate_macb228;
   wire            save_edge_macb228;
   wire            restore_edge_macb228;
   wire            pwr1_on_macb228;
   wire            pwr2_on_macb228;
   // ETH328
   wire            rstn_non_srpg_macb328;
   wire            gate_clk_macb328;
   wire            isolate_macb328;
   wire            save_edge_macb328;
   wire            restore_edge_macb328;
   wire            pwr1_on_macb328;
   wire            pwr2_on_macb328;


   wire           pclk_SRPG_smc28;
   wire           pclk_SRPG_urt28;
   wire           gate_clk_smc28;
   wire           gate_clk_urt28;
   wire  [31:0]   tie_lo_32bit28; 
   wire  [1:0]	  tie_lo_2bit28;
   wire  	  tie_lo_1bit28;
   wire           pcm_macb_wakeup_int28;
   wire           int_source_h28;
   wire           isolate_mem28;

assign pcm_irq28 = pcm_macb_wakeup_int28;
assign ttc_irq28[2] = TTC_int28[3];
assign ttc_irq28[1] = TTC_int28[2];
assign ttc_irq28[0] = TTC_int28[1];
assign gpio_irq28 = GPIO_int28;
assign uart0_irq28 = UART_int28;
assign uart1_irq28 = UART_int128;
assign spi_irq28 = SPI_int28;

assign n_mo_en28   = 1'b0;
assign n_so_en28   = 1'b1;
assign n_sclk_en28 = 1'b0;
assign n_ss_en28   = 1'b0;

assign smc_hsel_int28 = smc_hsel28;
  assign ext_clk28  = 1'b0;
  assign int_source28 = {macb0_int28,macb1_int28, macb2_int28, macb3_int28,1'b0, pcm_macb_wakeup_int28, 1'b0, 1'b0, 1'b0, 1'b0, TTC_int28, GPIO_int28, UART_int28, UART_int128, SPI_int28, DMA_irq28};

  // interrupt28 even28 detect28 .
  // for sleep28 wake28 up -> any interrupt28 even28 and system not in hibernation28 (isolate_mem28 = 0)
  // for hibernate28 wake28 up -> gpio28 interrupt28 even28 and system in the hibernation28 (isolate_mem28 = 1)
  assign int_source_h28 =  ((|int_source28) && (!isolate_mem28)) || (isolate_mem28 && GPIO_int28) ;

  assign byte_sel28 = 1'b1;
  assign tie_hi_bit28 = 1'b1;

  assign smc_addr28 = smc_addr_int28[15:0];



  assign  n_gpio_bypass_oe28 = {GPIO_WIDTH28{1'b0}};        // bypass28 mode enable 
  assign  gpio_bypass_out28  = {GPIO_WIDTH28{1'b0}};
  assign  tri_state_enable28 = {GPIO_WIDTH28{1'b0}};
  assign  cpu_debug28 = 1'b0;
  assign  tie_lo_32bit28 = 32'b0;
  assign  tie_lo_2bit28  = 2'b0;
  assign  tie_lo_1bit28  = 1'b0;


ahb2apb28 #(
  32'h00800000, // Slave28 0 Address Range28
  32'h0080FFFF,

  32'h00810000, // Slave28 1 Address Range28
  32'h0081FFFF,

  32'h00820000, // Slave28 2 Address Range28 
  32'h0082FFFF,

  32'h00830000, // Slave28 3 Address Range28
  32'h0083FFFF,

  32'h00840000, // Slave28 4 Address Range28
  32'h0084FFFF,

  32'h00850000, // Slave28 5 Address Range28
  32'h0085FFFF,

  32'h00860000, // Slave28 6 Address Range28
  32'h0086FFFF,

  32'h00870000, // Slave28 7 Address Range28
  32'h0087FFFF,

  32'h00880000, // Slave28 8 Address Range28
  32'h0088FFFF
) i_ahb2apb28 (
     // AHB28 interface
    .hclk28(hclk28),         
    .hreset_n28(n_hreset28), 
    .hsel28(hsel28), 
    .haddr28(haddr28),        
    .htrans28(htrans28),       
    .hwrite28(hwrite28),       
    .hwdata28(hwdata28),       
    .hrdata28(hrdata28),   
    .hready28(hready28),   
    .hresp28(hresp28),     
    
     // APB28 interface
    .pclk28(pclk28),         
    .preset_n28(n_preset28),  
    .prdata028(prdata_spi28),
    .prdata128(prdata_uart028), 
    .prdata228(prdata_gpio28),  
    .prdata328(prdata_ttc28),   
    .prdata428(32'h0),   
    .prdata528(prdata_smc28),   
    .prdata628(prdata_pmc28),    
    .prdata728(32'h0),   
    .prdata828(prdata_uart128),  
    .pready028(pready_spi28),     
    .pready128(pready_uart028),   
    .pready228(tie_hi_bit28),     
    .pready328(tie_hi_bit28),     
    .pready428(tie_hi_bit28),     
    .pready528(tie_hi_bit28),     
    .pready628(tie_hi_bit28),     
    .pready728(tie_hi_bit28),     
    .pready828(pready_uart128),  
    .pwdata28(pwdata28),       
    .pwrite28(pwrite28),       
    .paddr28(paddr28),        
    .psel028(psel_spi28),     
    .psel128(psel_uart028),   
    .psel228(psel_gpio28),    
    .psel328(psel_ttc28),     
    .psel428(),     
    .psel528(psel_smc28),     
    .psel628(psel_pmc28),    
    .psel728(psel_apic28),   
    .psel828(psel_uart128),  
    .penable28(penable28)     
);

spi_top28 i_spi28
(
  // Wishbone28 signals28
  .wb_clk_i28(pclk28), 
  .wb_rst_i28(~n_preset28), 
  .wb_adr_i28(paddr28[4:0]), 
  .wb_dat_i28(pwdata28), 
  .wb_dat_o28(prdata_spi28), 
  .wb_sel_i28(4'b1111),    // SPI28 register accesses are always 32-bit
  .wb_we_i28(pwrite28), 
  .wb_stb_i28(psel_spi28), 
  .wb_cyc_i28(psel_spi28), 
  .wb_ack_o28(pready_spi28), 
  .wb_err_o28(), 
  .wb_int_o28(SPI_int28),

  // SPI28 signals28
  .ss_pad_o28(n_ss_out28), 
  .sclk_pad_o28(sclk_out28), 
  .mosi_pad_o28(mo28), 
  .miso_pad_i28(mi28)
);

// Opencores28 UART28 instances28
wire ua_nrts_int28;
wire ua_nrts1_int28;

assign ua_nrts28 = ua_nrts_int28;
assign ua_nrts128 = ua_nrts1_int28;

reg [3:0] uart0_sel_i28;
reg [3:0] uart1_sel_i28;
// UART28 registers are all 8-bit wide28, and their28 addresses28
// are on byte boundaries28. So28 to access them28 on the
// Wishbone28 bus, the CPU28 must do byte accesses to these28
// byte addresses28. Word28 address accesses are not possible28
// because the word28 addresses28 will be unaligned28, and cause
// a fault28.
// So28, Uart28 accesses from the CPU28 will always be 8-bit size
// We28 only have to decide28 which byte of the 4-byte word28 the
// CPU28 is interested28 in.
`ifdef SYSTEM_BIG_ENDIAN28
always @(paddr28) begin
  case (paddr28[1:0])
    2'b00 : uart0_sel_i28 = 4'b1000;
    2'b01 : uart0_sel_i28 = 4'b0100;
    2'b10 : uart0_sel_i28 = 4'b0010;
    2'b11 : uart0_sel_i28 = 4'b0001;
  endcase
end
always @(paddr28) begin
  case (paddr28[1:0])
    2'b00 : uart1_sel_i28 = 4'b1000;
    2'b01 : uart1_sel_i28 = 4'b0100;
    2'b10 : uart1_sel_i28 = 4'b0010;
    2'b11 : uart1_sel_i28 = 4'b0001;
  endcase
end
`else
always @(paddr28) begin
  case (paddr28[1:0])
    2'b00 : uart0_sel_i28 = 4'b0001;
    2'b01 : uart0_sel_i28 = 4'b0010;
    2'b10 : uart0_sel_i28 = 4'b0100;
    2'b11 : uart0_sel_i28 = 4'b1000;
  endcase
end
always @(paddr28) begin
  case (paddr28[1:0])
    2'b00 : uart1_sel_i28 = 4'b0001;
    2'b01 : uart1_sel_i28 = 4'b0010;
    2'b10 : uart1_sel_i28 = 4'b0100;
    2'b11 : uart1_sel_i28 = 4'b1000;
  endcase
end
`endif

uart_top28 i_oc_uart028 (
  .wb_clk_i28(pclk28),
  .wb_rst_i28(~n_preset28),
  .wb_adr_i28(paddr28[4:0]),
  .wb_dat_i28(pwdata28),
  .wb_dat_o28(prdata_uart028),
  .wb_we_i28(pwrite28),
  .wb_stb_i28(psel_uart028),
  .wb_cyc_i28(psel_uart028),
  .wb_ack_o28(pready_uart028),
  .wb_sel_i28(uart0_sel_i28),
  .int_o28(UART_int28),
  .stx_pad_o28(ua_txd28),
  .srx_pad_i28(ua_rxd28),
  .rts_pad_o28(ua_nrts_int28),
  .cts_pad_i28(ua_ncts28),
  .dtr_pad_o28(),
  .dsr_pad_i28(1'b0),
  .ri_pad_i28(1'b0),
  .dcd_pad_i28(1'b0)
);

uart_top28 i_oc_uart128 (
  .wb_clk_i28(pclk28),
  .wb_rst_i28(~n_preset28),
  .wb_adr_i28(paddr28[4:0]),
  .wb_dat_i28(pwdata28),
  .wb_dat_o28(prdata_uart128),
  .wb_we_i28(pwrite28),
  .wb_stb_i28(psel_uart128),
  .wb_cyc_i28(psel_uart128),
  .wb_ack_o28(pready_uart128),
  .wb_sel_i28(uart1_sel_i28),
  .int_o28(UART_int128),
  .stx_pad_o28(ua_txd128),
  .srx_pad_i28(ua_rxd128),
  .rts_pad_o28(ua_nrts1_int28),
  .cts_pad_i28(ua_ncts128),
  .dtr_pad_o28(),
  .dsr_pad_i28(1'b0),
  .ri_pad_i28(1'b0),
  .dcd_pad_i28(1'b0)
);

gpio_veneer28 i_gpio_veneer28 (
        //inputs28

        . n_p_reset28(n_preset28),
        . pclk28(pclk28),
        . psel28(psel_gpio28),
        . penable28(penable28),
        . pwrite28(pwrite28),
        . paddr28(paddr28[5:0]),
        . pwdata28(pwdata28),
        . gpio_pin_in28(gpio_pin_in28),
        . scan_en28(scan_en28),
        . tri_state_enable28(tri_state_enable28),
        . scan_in28(), //added by smarkov28 for dft28

        //outputs28
        . scan_out28(), //added by smarkov28 for dft28
        . prdata28(prdata_gpio28),
        . gpio_int28(GPIO_int28),
        . n_gpio_pin_oe28(n_gpio_pin_oe28),
        . gpio_pin_out28(gpio_pin_out28)
);


ttc_veneer28 i_ttc_veneer28 (

         //inputs28
        . n_p_reset28(n_preset28),
        . pclk28(pclk28),
        . psel28(psel_ttc28),
        . penable28(penable28),
        . pwrite28(pwrite28),
        . pwdata28(pwdata28),
        . paddr28(paddr28[7:0]),
        . scan_in28(),
        . scan_en28(scan_en28),

        //outputs28
        . prdata28(prdata_ttc28),
        . interrupt28(TTC_int28[3:1]),
        . scan_out28()
);


smc_veneer28 i_smc_veneer28 (
        //inputs28
	//apb28 inputs28
        . n_preset28(n_preset28),
        . pclk28(pclk_SRPG_smc28),
        . psel28(psel_smc28),
        . penable28(penable28),
        . pwrite28(pwrite28),
        . paddr28(paddr28[4:0]),
        . pwdata28(pwdata28),
        //ahb28 inputs28
	. hclk28(smc_hclk28),
        . n_sys_reset28(rstn_non_srpg_smc28),
        . haddr28(smc_haddr28),
        . htrans28(smc_htrans28),
        . hsel28(smc_hsel_int28),
        . hwrite28(smc_hwrite28),
	. hsize28(smc_hsize28),
        . hwdata28(smc_hwdata28),
        . hready28(smc_hready_in28),
        . data_smc28(data_smc28),

         //test signal28 inputs28

        . scan_in_128(),
        . scan_in_228(),
        . scan_in_328(),
        . scan_en28(scan_en28),

        //apb28 outputs28
        . prdata28(prdata_smc28),

       //design output

        . smc_hrdata28(smc_hrdata28),
        . smc_hready28(smc_hready28),
        . smc_hresp28(smc_hresp28),
        . smc_valid28(smc_valid28),
        . smc_addr28(smc_addr_int28),
        . smc_data28(smc_data28),
        . smc_n_be28(smc_n_be28),
        . smc_n_cs28(smc_n_cs28),
        . smc_n_wr28(smc_n_wr28),
        . smc_n_we28(smc_n_we28),
        . smc_n_rd28(smc_n_rd28),
        . smc_n_ext_oe28(smc_n_ext_oe28),
        . smc_busy28(smc_busy28),

         //test signal28 output
        . scan_out_128(),
        . scan_out_228(),
        . scan_out_328()
);

power_ctrl_veneer28 i_power_ctrl_veneer28 (
    // -- Clocks28 & Reset28
    	.pclk28(pclk28), 			//  : in  std_logic28;
    	.nprst28(n_preset28), 		//  : in  std_logic28;
    // -- APB28 programming28 interface
    	.paddr28(paddr28), 			//  : in  std_logic_vector28(31 downto28 0);
    	.psel28(psel_pmc28), 			//  : in  std_logic28;
    	.penable28(penable28), 		//  : in  std_logic28;
    	.pwrite28(pwrite28), 		//  : in  std_logic28;
    	.pwdata28(pwdata28), 		//  : in  std_logic_vector28(31 downto28 0);
    	.prdata28(prdata_pmc28), 		//  : out std_logic_vector28(31 downto28 0);
        .macb3_wakeup28(macb3_wakeup28),
        .macb2_wakeup28(macb2_wakeup28),
        .macb1_wakeup28(macb1_wakeup28),
        .macb0_wakeup28(macb0_wakeup28),
    // -- Module28 control28 outputs28
    	.scan_in28(),			//  : in  std_logic28;
    	.scan_en28(scan_en28),             	//  : in  std_logic28;
    	.scan_mode28(scan_mode28),          //  : in  std_logic28;
    	.scan_out28(),            	//  : out std_logic28;
        .int_source_h28(int_source_h28),
     	.rstn_non_srpg_smc28(rstn_non_srpg_smc28), 		//   : out std_logic28;
    	.gate_clk_smc28(gate_clk_smc28), 	//  : out std_logic28;
    	.isolate_smc28(isolate_smc28), 	//  : out std_logic28;
    	.save_edge_smc28(save_edge_smc28), 	//  : out std_logic28;
    	.restore_edge_smc28(restore_edge_smc28), 	//  : out std_logic28;
    	.pwr1_on_smc28(pwr1_on_smc28), 	//  : out std_logic28;
    	.pwr2_on_smc28(pwr2_on_smc28), 	//  : out std_logic28
     	.rstn_non_srpg_urt28(rstn_non_srpg_urt28), 		//   : out std_logic28;
    	.gate_clk_urt28(gate_clk_urt28), 	//  : out std_logic28;
    	.isolate_urt28(isolate_urt28), 	//  : out std_logic28;
    	.save_edge_urt28(save_edge_urt28), 	//  : out std_logic28;
    	.restore_edge_urt28(restore_edge_urt28), 	//  : out std_logic28;
    	.pwr1_on_urt28(pwr1_on_urt28), 	//  : out std_logic28;
    	.pwr2_on_urt28(pwr2_on_urt28),  	//  : out std_logic28
        // ETH028
        .rstn_non_srpg_macb028(rstn_non_srpg_macb028),
        .gate_clk_macb028(gate_clk_macb028),
        .isolate_macb028(isolate_macb028),
        .save_edge_macb028(save_edge_macb028),
        .restore_edge_macb028(restore_edge_macb028),
        .pwr1_on_macb028(pwr1_on_macb028),
        .pwr2_on_macb028(pwr2_on_macb028),
        // ETH128
        .rstn_non_srpg_macb128(rstn_non_srpg_macb128),
        .gate_clk_macb128(gate_clk_macb128),
        .isolate_macb128(isolate_macb128),
        .save_edge_macb128(save_edge_macb128),
        .restore_edge_macb128(restore_edge_macb128),
        .pwr1_on_macb128(pwr1_on_macb128),
        .pwr2_on_macb128(pwr2_on_macb128),
        // ETH228
        .rstn_non_srpg_macb228(rstn_non_srpg_macb228),
        .gate_clk_macb228(gate_clk_macb228),
        .isolate_macb228(isolate_macb228),
        .save_edge_macb228(save_edge_macb228),
        .restore_edge_macb228(restore_edge_macb228),
        .pwr1_on_macb228(pwr1_on_macb228),
        .pwr2_on_macb228(pwr2_on_macb228),
        // ETH328
        .rstn_non_srpg_macb328(rstn_non_srpg_macb328),
        .gate_clk_macb328(gate_clk_macb328),
        .isolate_macb328(isolate_macb328),
        .save_edge_macb328(save_edge_macb328),
        .restore_edge_macb328(restore_edge_macb328),
        .pwr1_on_macb328(pwr1_on_macb328),
        .pwr2_on_macb328(pwr2_on_macb328),
        .core06v28(core06v28),
        .core08v28(core08v28),
        .core10v28(core10v28),
        .core12v28(core12v28),
        .pcm_macb_wakeup_int28(pcm_macb_wakeup_int28),
        .isolate_mem28(isolate_mem28),
        .mte_smc_start28(mte_smc_start28),
        .mte_uart_start28(mte_uart_start28),
        .mte_smc_uart_start28(mte_smc_uart_start28),  
        .mte_pm_smc_to_default_start28(mte_pm_smc_to_default_start28), 
        .mte_pm_uart_to_default_start28(mte_pm_uart_to_default_start28),
        .mte_pm_smc_uart_to_default_start28(mte_pm_smc_uart_to_default_start28)
);

// Clock28 gating28 macro28 to shut28 off28 clocks28 to the SRPG28 flops28 in the SMC28
//CKLNQD128 i_SMC_SRPG_clk_gate28  (
//	.TE28(scan_mode28), 
//	.E28(~gate_clk_smc28), 
//	.CP28(pclk28), 
//	.Q28(pclk_SRPG_smc28)
//	);
// Replace28 gate28 with behavioural28 code28 //
wire 	smc_scan_gate28;
reg 	smc_latched_enable28;
assign smc_scan_gate28 = scan_mode28 ? 1'b1 : ~gate_clk_smc28;

always @ (pclk28 or smc_scan_gate28)
  	if (pclk28 == 1'b0) begin
  		smc_latched_enable28 <= smc_scan_gate28;
  	end  	
	
assign pclk_SRPG_smc28 = smc_latched_enable28 ? pclk28 : 1'b0;


// Clock28 gating28 macro28 to shut28 off28 clocks28 to the SRPG28 flops28 in the URT28
//CKLNQD128 i_URT_SRPG_clk_gate28  (
//	.TE28(scan_mode28), 
//	.E28(~gate_clk_urt28), 
//	.CP28(pclk28), 
//	.Q28(pclk_SRPG_urt28)
//	);
// Replace28 gate28 with behavioural28 code28 //
wire 	urt_scan_gate28;
reg 	urt_latched_enable28;
assign urt_scan_gate28 = scan_mode28 ? 1'b1 : ~gate_clk_urt28;

always @ (pclk28 or urt_scan_gate28)
  	if (pclk28 == 1'b0) begin
  		urt_latched_enable28 <= urt_scan_gate28;
  	end  	
	
assign pclk_SRPG_urt28 = urt_latched_enable28 ? pclk28 : 1'b0;

// ETH028
wire 	macb0_scan_gate28;
reg 	macb0_latched_enable28;
assign macb0_scan_gate28 = scan_mode28 ? 1'b1 : ~gate_clk_macb028;

always @ (pclk28 or macb0_scan_gate28)
  	if (pclk28 == 1'b0) begin
  		macb0_latched_enable28 <= macb0_scan_gate28;
  	end  	
	
assign clk_SRPG_macb0_en28 = macb0_latched_enable28 ? 1'b1 : 1'b0;

// ETH128
wire 	macb1_scan_gate28;
reg 	macb1_latched_enable28;
assign macb1_scan_gate28 = scan_mode28 ? 1'b1 : ~gate_clk_macb128;

always @ (pclk28 or macb1_scan_gate28)
  	if (pclk28 == 1'b0) begin
  		macb1_latched_enable28 <= macb1_scan_gate28;
  	end  	
	
assign clk_SRPG_macb1_en28 = macb1_latched_enable28 ? 1'b1 : 1'b0;

// ETH228
wire 	macb2_scan_gate28;
reg 	macb2_latched_enable28;
assign macb2_scan_gate28 = scan_mode28 ? 1'b1 : ~gate_clk_macb228;

always @ (pclk28 or macb2_scan_gate28)
  	if (pclk28 == 1'b0) begin
  		macb2_latched_enable28 <= macb2_scan_gate28;
  	end  	
	
assign clk_SRPG_macb2_en28 = macb2_latched_enable28 ? 1'b1 : 1'b0;

// ETH328
wire 	macb3_scan_gate28;
reg 	macb3_latched_enable28;
assign macb3_scan_gate28 = scan_mode28 ? 1'b1 : ~gate_clk_macb328;

always @ (pclk28 or macb3_scan_gate28)
  	if (pclk28 == 1'b0) begin
  		macb3_latched_enable28 <= macb3_scan_gate28;
  	end  	
	
assign clk_SRPG_macb3_en28 = macb3_latched_enable28 ? 1'b1 : 1'b0;



`else
//------------------------------------------------------------------------------
// if the APB28 subsystem28 is black28 boxed28 
//------------------------------------------------------------------------------
// wire s ports28
    // system signals28
    wire         hclk28;     // AHB28 Clock28
    wire         n_hreset28;  // AHB28 reset - Active28 low28
    wire         pclk28;     // APB28 Clock28. 
    wire         n_preset28;  // APB28 reset - Active28 low28

    // AHB28 interface
    wire         ahb2apb0_hsel28;     // AHB2APB28 select28
    wire  [31:0] haddr28;    // Address bus
    wire  [1:0]  htrans28;   // Transfer28 type
    wire  [2:0]  hsize28;    // AHB28 Access type - byte, half28-word28, word28
    wire  [31:0] hwdata28;   // Write data
    wire         hwrite28;   // Write signal28/
    wire         hready_in28;// Indicates28 that last master28 has finished28 bus access
    wire [2:0]   hburst28;     // Burst type
    wire [3:0]   hprot28;      // Protection28 control28
    wire [3:0]   hmaster28;    // Master28 select28
    wire         hmastlock28;  // Locked28 transfer28
  // Interrupts28 from the Enet28 MACs28
    wire         macb0_int28;
    wire         macb1_int28;
    wire         macb2_int28;
    wire         macb3_int28;
  // Interrupt28 from the DMA28
    wire         DMA_irq28;
  // Scan28 wire s
    wire         scan_en28;    // Scan28 enable pin28
    wire         scan_in_128;  // Scan28 wire  for first chain28
    wire         scan_in_228;  // Scan28 wire  for second chain28
    wire         scan_mode28;  // test mode pin28
 
  //wire  for smc28 AHB28 interface
    wire         smc_hclk28;
    wire         smc_n_hclk28;
    wire  [31:0] smc_haddr28;
    wire  [1:0]  smc_htrans28;
    wire         smc_hsel28;
    wire         smc_hwrite28;
    wire  [2:0]  smc_hsize28;
    wire  [31:0] smc_hwdata28;
    wire         smc_hready_in28;
    wire  [2:0]  smc_hburst28;     // Burst type
    wire  [3:0]  smc_hprot28;      // Protection28 control28
    wire  [3:0]  smc_hmaster28;    // Master28 select28
    wire         smc_hmastlock28;  // Locked28 transfer28


    wire  [31:0] data_smc28;     // EMI28(External28 memory) read data
    
  //wire s for uart28
    wire         ua_rxd28;       // UART28 receiver28 serial28 wire  pin28
    wire         ua_rxd128;      // UART28 receiver28 serial28 wire  pin28
    wire         ua_ncts28;      // Clear-To28-Send28 flow28 control28
    wire         ua_ncts128;      // Clear-To28-Send28 flow28 control28
   //wire s for spi28
    wire         n_ss_in28;      // select28 wire  to slave28
    wire         mi28;           // data wire  to master28
    wire         si28;           // data wire  to slave28
    wire         sclk_in28;      // clock28 wire  to slave28
  //wire s for GPIO28
   wire  [GPIO_WIDTH28-1:0]  gpio_pin_in28;             // wire  data from pin28

  //reg    ports28
  // Scan28 reg   s
   reg           scan_out_128;   // Scan28 out for chain28 1
   reg           scan_out_228;   // Scan28 out for chain28 2
  //AHB28 interface 
   reg    [31:0] hrdata28;       // Read data provided from target slave28
   reg           hready28;       // Ready28 for new bus cycle from target slave28
   reg    [1:0]  hresp28;       // Response28 from the bridge28

   // SMC28 reg    for AHB28 interface
   reg    [31:0]    smc_hrdata28;
   reg              smc_hready28;
   reg    [1:0]     smc_hresp28;

  //reg   s from smc28
   reg    [15:0]    smc_addr28;      // External28 Memory (EMI28) address
   reg    [3:0]     smc_n_be28;      // EMI28 byte enables28 (Active28 LOW28)
   reg    [7:0]     smc_n_cs28;      // EMI28 Chip28 Selects28 (Active28 LOW28)
   reg    [3:0]     smc_n_we28;      // EMI28 write strobes28 (Active28 LOW28)
   reg              smc_n_wr28;      // EMI28 write enable (Active28 LOW28)
   reg              smc_n_rd28;      // EMI28 read stobe28 (Active28 LOW28)
   reg              smc_n_ext_oe28;  // EMI28 write data reg    enable
   reg    [31:0]    smc_data28;      // EMI28 write data
  //reg   s from uart28
   reg           ua_txd28;       	// UART28 transmitter28 serial28 reg   
   reg           ua_txd128;       // UART28 transmitter28 serial28 reg   
   reg           ua_nrts28;      	// Request28-To28-Send28 flow28 control28
   reg           ua_nrts128;      // Request28-To28-Send28 flow28 control28
   // reg   s from ttc28
  // reg   s from SPI28
   reg       so;                    // data reg    from slave28
   reg       mo28;                    // data reg    from master28
   reg       sclk_out28;              // clock28 reg    from master28
   reg    [P_SIZE28-1:0] n_ss_out28;    // peripheral28 select28 lines28 from master28
   reg       n_so_en28;               // out enable for slave28 data
   reg       n_mo_en28;               // out enable for master28 data
   reg       n_sclk_en28;             // out enable for master28 clock28
   reg       n_ss_en28;               // out enable for master28 peripheral28 lines28
  //reg   s from gpio28
   reg    [GPIO_WIDTH28-1:0]     n_gpio_pin_oe28;           // reg    enable signal28 to pin28
   reg    [GPIO_WIDTH28-1:0]     gpio_pin_out28;            // reg    signal28 to pin28


`endif
//------------------------------------------------------------------------------
// black28 boxed28 defines28 
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// APB28 and AHB28 interface formal28 verification28 monitors28
//------------------------------------------------------------------------------
`ifdef ABV_ON28
apb_assert28 i_apb_assert28 (

        // APB28 signals28
  	.n_preset28(n_preset28),
   	.pclk28(pclk28),
	.penable28(penable28),
	.paddr28(paddr28),
	.pwrite28(pwrite28),
	.pwdata28(pwdata28),

	.psel0028(psel_spi28),
	.psel0128(psel_uart028),
	.psel0228(psel_gpio28),
	.psel0328(psel_ttc28),
	.psel0428(1'b0),
	.psel0528(psel_smc28),
	.psel0628(1'b0),
	.psel0728(1'b0),
	.psel0828(1'b0),
	.psel0928(1'b0),
	.psel1028(1'b0),
	.psel1128(1'b0),
	.psel1228(1'b0),
	.psel1328(psel_pmc28),
	.psel1428(psel_apic28),
	.psel1528(psel_uart128),

        .prdata0028(prdata_spi28),
        .prdata0128(prdata_uart028), // Read Data from peripheral28 UART28 
        .prdata0228(prdata_gpio28), // Read Data from peripheral28 GPIO28
        .prdata0328(prdata_ttc28), // Read Data from peripheral28 TTC28
        .prdata0428(32'b0), // 
        .prdata0528(prdata_smc28), // Read Data from peripheral28 SMC28
        .prdata1328(prdata_pmc28), // Read Data from peripheral28 Power28 Control28 Block
   	.prdata1428(32'b0), // 
        .prdata1528(prdata_uart128),


        // AHB28 signals28
        .hclk28(hclk28),         // ahb28 system clock28
        .n_hreset28(n_hreset28), // ahb28 system reset

        // ahb2apb28 signals28
        .hresp28(hresp28),
        .hready28(hready28),
        .hrdata28(hrdata28),
        .hwdata28(hwdata28),
        .hprot28(hprot28),
        .hburst28(hburst28),
        .hsize28(hsize28),
        .hwrite28(hwrite28),
        .htrans28(htrans28),
        .haddr28(haddr28),
        .ahb2apb_hsel28(ahb2apb0_hsel28));



//------------------------------------------------------------------------------
// AHB28 interface formal28 verification28 monitor28
//------------------------------------------------------------------------------
defparam i_ahbSlaveMonitor28.DBUS_WIDTH28 = 32;
defparam i_ahbMasterMonitor28.DBUS_WIDTH28 = 32;


// AHB2APB28 Bridge28

    ahb_liteslave_monitor28 i_ahbSlaveMonitor28 (
        .hclk_i28(hclk28),
        .hresetn_i28(n_hreset28),
        .hresp28(hresp28),
        .hready28(hready28),
        .hready_global_i28(hready28),
        .hrdata28(hrdata28),
        .hwdata_i28(hwdata28),
        .hburst_i28(hburst28),
        .hsize_i28(hsize28),
        .hwrite_i28(hwrite28),
        .htrans_i28(htrans28),
        .haddr_i28(haddr28),
        .hsel_i28(ahb2apb0_hsel28)
    );


  ahb_litemaster_monitor28 i_ahbMasterMonitor28 (
          .hclk_i28(hclk28),
          .hresetn_i28(n_hreset28),
          .hresp_i28(hresp28),
          .hready_i28(hready28),
          .hrdata_i28(hrdata28),
          .hlock28(1'b0),
          .hwdata28(hwdata28),
          .hprot28(hprot28),
          .hburst28(hburst28),
          .hsize28(hsize28),
          .hwrite28(hwrite28),
          .htrans28(htrans28),
          .haddr28(haddr28)
          );







`endif




`ifdef IFV_LP_ABV_ON28
// power28 control28
wire isolate28;

// testbench mirror signals28
wire L1_ctrl_access28;
wire L1_status_access28;

wire [31:0] L1_status_reg28;
wire [31:0] L1_ctrl_reg28;

//wire rstn_non_srpg_urt28;
//wire isolate_urt28;
//wire retain_urt28;
//wire gate_clk_urt28;
//wire pwr1_on_urt28;


// smc28 signals28
wire [31:0] smc_prdata28;
wire lp_clk_smc28;
                    

// uart28 isolation28 register
  wire [15:0] ua_prdata28;
  wire ua_int28;
  assign ua_prdata28          =  i_uart1_veneer28.prdata28;
  assign ua_int28             =  i_uart1_veneer28.ua_int28;


assign lp_clk_smc28          = i_smc_veneer28.pclk28;
assign smc_prdata28          = i_smc_veneer28.prdata28;
lp_chk_smc28 u_lp_chk_smc28 (
    .clk28 (hclk28),
    .rst28 (n_hreset28),
    .iso_smc28 (isolate_smc28),
    .gate_clk28 (gate_clk_smc28),
    .lp_clk28 (pclk_SRPG_smc28),

    // srpg28 outputs28
    .smc_hrdata28 (smc_hrdata28),
    .smc_hready28 (smc_hready28),
    .smc_hresp28  (smc_hresp28),
    .smc_valid28 (smc_valid28),
    .smc_addr_int28 (smc_addr_int28),
    .smc_data28 (smc_data28),
    .smc_n_be28 (smc_n_be28),
    .smc_n_cs28  (smc_n_cs28),
    .smc_n_wr28 (smc_n_wr28),
    .smc_n_we28 (smc_n_we28),
    .smc_n_rd28 (smc_n_rd28),
    .smc_n_ext_oe28 (smc_n_ext_oe28)
   );

// lp28 retention28/isolation28 assertions28
lp_chk_uart28 u_lp_chk_urt28 (

  .clk28         (hclk28),
  .rst28         (n_hreset28),
  .iso_urt28     (isolate_urt28),
  .gate_clk28    (gate_clk_urt28),
  .lp_clk28      (pclk_SRPG_urt28),
  //ports28
  .prdata28 (ua_prdata28),
  .ua_int28 (ua_int28),
  .ua_txd28 (ua_txd128),
  .ua_nrts28 (ua_nrts128)
 );

`endif  //IFV_LP_ABV_ON28




endmodule
