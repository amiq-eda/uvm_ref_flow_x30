//File25 name   : apb_subsystem_025.v
//Title25       : 
//Created25     : 1999
//Description25 : 
//Notes25       : 
//----------------------------------------------------------------------
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------

module apb_subsystem_025(
    // AHB25 interface
    hclk25,
    n_hreset25,
    hsel25,
    haddr25,
    htrans25,
    hsize25,
    hwrite25,
    hwdata25,
    hready_in25,
    hburst25,
    hprot25,
    hmaster25,
    hmastlock25,
    hrdata25,
    hready25,
    hresp25,
    
    // APB25 system interface
    pclk25,
    n_preset25,
    
    // SPI25 ports25
    n_ss_in25,
    mi25,
    si25,
    sclk_in25,
    so,
    mo25,
    sclk_out25,
    n_ss_out25,
    n_so_en25,
    n_mo_en25,
    n_sclk_en25,
    n_ss_en25,
    
    //UART025 ports25
    ua_rxd25,
    ua_ncts25,
    ua_txd25,
    ua_nrts25,
    
    //UART125 ports25
    ua_rxd125,
    ua_ncts125,
    ua_txd125,
    ua_nrts125,
    
    //GPIO25 ports25
    gpio_pin_in25,
    n_gpio_pin_oe25,
    gpio_pin_out25,
    

    //SMC25 ports25
    smc_hclk25,
    smc_n_hclk25,
    smc_haddr25,
    smc_htrans25,
    smc_hsel25,
    smc_hwrite25,
    smc_hsize25,
    smc_hwdata25,
    smc_hready_in25,
    smc_hburst25,
    smc_hprot25,
    smc_hmaster25,
    smc_hmastlock25,
    smc_hrdata25, 
    smc_hready25,
    smc_hresp25,
    smc_n_ext_oe25,
    smc_data25,
    smc_addr25,
    smc_n_be25,
    smc_n_cs25, 
    smc_n_we25,
    smc_n_wr25,
    smc_n_rd25,
    data_smc25,
    
    //PMC25 ports25
    clk_SRPG_macb0_en25,
    clk_SRPG_macb1_en25,
    clk_SRPG_macb2_en25,
    clk_SRPG_macb3_en25,
    core06v25,
    core08v25,
    core10v25,
    core12v25,
    macb3_wakeup25,
    macb2_wakeup25,
    macb1_wakeup25,
    macb0_wakeup25,
    mte_smc_start25,
    mte_uart_start25,
    mte_smc_uart_start25,  
    mte_pm_smc_to_default_start25, 
    mte_pm_uart_to_default_start25,
    mte_pm_smc_uart_to_default_start25,
    
    
    // Peripheral25 inerrupts25
    pcm_irq25,
    ttc_irq25,
    gpio_irq25,
    uart0_irq25,
    uart1_irq25,
    spi_irq25,
    DMA_irq25,      
    macb0_int25,
    macb1_int25,
    macb2_int25,
    macb3_int25,
   
    // Scan25 ports25
    scan_en25,      // Scan25 enable pin25
    scan_in_125,    // Scan25 input for first chain25
    scan_in_225,    // Scan25 input for second chain25
    scan_mode25,
    scan_out_125,   // Scan25 out for chain25 1
    scan_out_225    // Scan25 out for chain25 2
);

parameter GPIO_WIDTH25 = 16;        // GPIO25 width
parameter P_SIZE25 =   8;              // number25 of peripheral25 select25 lines25
parameter NO_OF_IRQS25  = 17;      //No of irqs25 read by apic25 

// AHB25 interface
input         hclk25;     // AHB25 Clock25
input         n_hreset25;  // AHB25 reset - Active25 low25
input         hsel25;     // AHB2APB25 select25
input [31:0]  haddr25;    // Address bus
input [1:0]   htrans25;   // Transfer25 type
input [2:0]   hsize25;    // AHB25 Access type - byte, half25-word25, word25
input [31:0]  hwdata25;   // Write data
input         hwrite25;   // Write signal25/
input         hready_in25;// Indicates25 that last master25 has finished25 bus access
input [2:0]   hburst25;     // Burst type
input [3:0]   hprot25;      // Protection25 control25
input [3:0]   hmaster25;    // Master25 select25
input         hmastlock25;  // Locked25 transfer25
output [31:0] hrdata25;       // Read data provided from target slave25
output        hready25;       // Ready25 for new bus cycle from target slave25
output [1:0]  hresp25;       // Response25 from the bridge25
    
// APB25 system interface
input         pclk25;     // APB25 Clock25. 
input         n_preset25;  // APB25 reset - Active25 low25
   
// SPI25 ports25
input     n_ss_in25;      // select25 input to slave25
input     mi25;           // data input to master25
input     si25;           // data input to slave25
input     sclk_in25;      // clock25 input to slave25
output    so;                    // data output from slave25
output    mo25;                    // data output from master25
output    sclk_out25;              // clock25 output from master25
output [P_SIZE25-1:0] n_ss_out25;    // peripheral25 select25 lines25 from master25
output    n_so_en25;               // out enable for slave25 data
output    n_mo_en25;               // out enable for master25 data
output    n_sclk_en25;             // out enable for master25 clock25
output    n_ss_en25;               // out enable for master25 peripheral25 lines25

//UART025 ports25
input        ua_rxd25;       // UART25 receiver25 serial25 input pin25
input        ua_ncts25;      // Clear-To25-Send25 flow25 control25
output       ua_txd25;       	// UART25 transmitter25 serial25 output
output       ua_nrts25;      	// Request25-To25-Send25 flow25 control25

// UART125 ports25   
input        ua_rxd125;      // UART25 receiver25 serial25 input pin25
input        ua_ncts125;      // Clear-To25-Send25 flow25 control25
output       ua_txd125;       // UART25 transmitter25 serial25 output
output       ua_nrts125;      // Request25-To25-Send25 flow25 control25

//GPIO25 ports25
input [GPIO_WIDTH25-1:0]      gpio_pin_in25;             // input data from pin25
output [GPIO_WIDTH25-1:0]     n_gpio_pin_oe25;           // output enable signal25 to pin25
output [GPIO_WIDTH25-1:0]     gpio_pin_out25;            // output signal25 to pin25
  
//SMC25 ports25
input        smc_hclk25;
input        smc_n_hclk25;
input [31:0] smc_haddr25;
input [1:0]  smc_htrans25;
input        smc_hsel25;
input        smc_hwrite25;
input [2:0]  smc_hsize25;
input [31:0] smc_hwdata25;
input        smc_hready_in25;
input [2:0]  smc_hburst25;     // Burst type
input [3:0]  smc_hprot25;      // Protection25 control25
input [3:0]  smc_hmaster25;    // Master25 select25
input        smc_hmastlock25;  // Locked25 transfer25
input [31:0] data_smc25;     // EMI25(External25 memory) read data
output [31:0]    smc_hrdata25;
output           smc_hready25;
output [1:0]     smc_hresp25;
output [15:0]    smc_addr25;      // External25 Memory (EMI25) address
output [3:0]     smc_n_be25;      // EMI25 byte enables25 (Active25 LOW25)
output           smc_n_cs25;      // EMI25 Chip25 Selects25 (Active25 LOW25)
output [3:0]     smc_n_we25;      // EMI25 write strobes25 (Active25 LOW25)
output           smc_n_wr25;      // EMI25 write enable (Active25 LOW25)
output           smc_n_rd25;      // EMI25 read stobe25 (Active25 LOW25)
output           smc_n_ext_oe25;  // EMI25 write data output enable
output [31:0]    smc_data25;      // EMI25 write data
       
//PMC25 ports25
output clk_SRPG_macb0_en25;
output clk_SRPG_macb1_en25;
output clk_SRPG_macb2_en25;
output clk_SRPG_macb3_en25;
output core06v25;
output core08v25;
output core10v25;
output core12v25;
output mte_smc_start25;
output mte_uart_start25;
output mte_smc_uart_start25;  
output mte_pm_smc_to_default_start25; 
output mte_pm_uart_to_default_start25;
output mte_pm_smc_uart_to_default_start25;
input macb3_wakeup25;
input macb2_wakeup25;
input macb1_wakeup25;
input macb0_wakeup25;
    

// Peripheral25 interrupts25
output pcm_irq25;
output [2:0] ttc_irq25;
output gpio_irq25;
output uart0_irq25;
output uart1_irq25;
output spi_irq25;
input        macb0_int25;
input        macb1_int25;
input        macb2_int25;
input        macb3_int25;
input        DMA_irq25;
  
//Scan25 ports25
input        scan_en25;    // Scan25 enable pin25
input        scan_in_125;  // Scan25 input for first chain25
input        scan_in_225;  // Scan25 input for second chain25
input        scan_mode25;  // test mode pin25
 output        scan_out_125;   // Scan25 out for chain25 1
 output        scan_out_225;   // Scan25 out for chain25 2  

//------------------------------------------------------------------------------
// if the ROM25 subsystem25 is NOT25 black25 boxed25 
//------------------------------------------------------------------------------
`ifndef FV_KIT_BLACK_BOX_APB_SUBSYSTEM25
   
   wire        hsel25; 
   wire        pclk25;
   wire        n_preset25;
   wire [31:0] prdata_spi25;
   wire [31:0] prdata_uart025;
   wire [31:0] prdata_gpio25;
   wire [31:0] prdata_ttc25;
   wire [31:0] prdata_smc25;
   wire [31:0] prdata_pmc25;
   wire [31:0] prdata_uart125;
   wire        pready_spi25;
   wire        pready_uart025;
   wire        pready_uart125;
   wire        tie_hi_bit25;
   wire  [31:0] hrdata25; 
   wire         hready25;
   wire         hready_in25;
   wire  [1:0]  hresp25;   
   wire  [31:0] pwdata25;  
   wire         pwrite25;
   wire  [31:0] paddr25;  
   wire   psel_spi25;
   wire   psel_uart025;
   wire   psel_gpio25;
   wire   psel_ttc25;
   wire   psel_smc25;
   wire   psel0725;
   wire   psel0825;
   wire   psel0925;
   wire   psel1025;
   wire   psel1125;
   wire   psel1225;
   wire   psel_pmc25;
   wire   psel_uart125;
   wire   penable25;
   wire   [NO_OF_IRQS25:0] int_source25;     // System25 Interrupt25 Sources25
   wire [1:0]             smc_hresp25;     // AHB25 Response25 signal25
   wire                   smc_valid25;     // Ack25 valid address

  //External25 memory interface (EMI25)
  wire [31:0]            smc_addr_int25;  // External25 Memory (EMI25) address
  wire [3:0]             smc_n_be25;      // EMI25 byte enables25 (Active25 LOW25)
  wire                   smc_n_cs25;      // EMI25 Chip25 Selects25 (Active25 LOW25)
  wire [3:0]             smc_n_we25;      // EMI25 write strobes25 (Active25 LOW25)
  wire                   smc_n_wr25;      // EMI25 write enable (Active25 LOW25)
  wire                   smc_n_rd25;      // EMI25 read stobe25 (Active25 LOW25)
 
  //AHB25 Memory Interface25 Control25
  wire                   smc_hsel_int25;
  wire                   smc_busy25;      // smc25 busy
   

//scan25 signals25

   wire                scan_in_125;        //scan25 input
   wire                scan_in_225;        //scan25 input
   wire                scan_en25;         //scan25 enable
   wire                scan_out_125;       //scan25 output
   wire                scan_out_225;       //scan25 output
   wire                byte_sel25;     // byte select25 from bridge25 1=byte, 0=2byte
   wire                UART_int25;     // UART25 module interrupt25 
   wire                ua_uclken25;    // Soft25 control25 of clock25
   wire                UART_int125;     // UART25 module interrupt25 
   wire                ua_uclken125;    // Soft25 control25 of clock25
   wire  [3:1]         TTC_int25;            //Interrupt25 from PCI25 
  // inputs25 to SPI25 
   wire    ext_clk25;                // external25 clock25
   wire    SPI_int25;             // interrupt25 request
  // outputs25 from SPI25
   wire    slave_out_clk25;         // modified slave25 clock25 output
 // gpio25 generic25 inputs25 
   wire  [GPIO_WIDTH25-1:0]   n_gpio_bypass_oe25;        // bypass25 mode enable 
   wire  [GPIO_WIDTH25-1:0]   gpio_bypass_out25;         // bypass25 mode output value 
   wire  [GPIO_WIDTH25-1:0]   tri_state_enable25;   // disables25 op enable -> z 
 // outputs25 
   //amba25 outputs25 
   // gpio25 generic25 outputs25 
   wire       GPIO_int25;                // gpio_interupt25 for input pin25 change 
   wire [GPIO_WIDTH25-1:0]     gpio_bypass_in25;          // bypass25 mode input data value  
                
   wire           cpu_debug25;        // Inhibits25 watchdog25 counter 
   wire            ex_wdz_n25;         // External25 Watchdog25 zero indication25
   wire           rstn_non_srpg_smc25; 
   wire           rstn_non_srpg_urt25;
   wire           isolate_smc25;
   wire           save_edge_smc25;
   wire           restore_edge_smc25;
   wire           save_edge_urt25;
   wire           restore_edge_urt25;
   wire           pwr1_on_smc25;
   wire           pwr2_on_smc25;
   wire           pwr1_on_urt25;
   wire           pwr2_on_urt25;
   // ETH025
   wire            rstn_non_srpg_macb025;
   wire            gate_clk_macb025;
   wire            isolate_macb025;
   wire            save_edge_macb025;
   wire            restore_edge_macb025;
   wire            pwr1_on_macb025;
   wire            pwr2_on_macb025;
   // ETH125
   wire            rstn_non_srpg_macb125;
   wire            gate_clk_macb125;
   wire            isolate_macb125;
   wire            save_edge_macb125;
   wire            restore_edge_macb125;
   wire            pwr1_on_macb125;
   wire            pwr2_on_macb125;
   // ETH225
   wire            rstn_non_srpg_macb225;
   wire            gate_clk_macb225;
   wire            isolate_macb225;
   wire            save_edge_macb225;
   wire            restore_edge_macb225;
   wire            pwr1_on_macb225;
   wire            pwr2_on_macb225;
   // ETH325
   wire            rstn_non_srpg_macb325;
   wire            gate_clk_macb325;
   wire            isolate_macb325;
   wire            save_edge_macb325;
   wire            restore_edge_macb325;
   wire            pwr1_on_macb325;
   wire            pwr2_on_macb325;


   wire           pclk_SRPG_smc25;
   wire           pclk_SRPG_urt25;
   wire           gate_clk_smc25;
   wire           gate_clk_urt25;
   wire  [31:0]   tie_lo_32bit25; 
   wire  [1:0]	  tie_lo_2bit25;
   wire  	  tie_lo_1bit25;
   wire           pcm_macb_wakeup_int25;
   wire           int_source_h25;
   wire           isolate_mem25;

assign pcm_irq25 = pcm_macb_wakeup_int25;
assign ttc_irq25[2] = TTC_int25[3];
assign ttc_irq25[1] = TTC_int25[2];
assign ttc_irq25[0] = TTC_int25[1];
assign gpio_irq25 = GPIO_int25;
assign uart0_irq25 = UART_int25;
assign uart1_irq25 = UART_int125;
assign spi_irq25 = SPI_int25;

assign n_mo_en25   = 1'b0;
assign n_so_en25   = 1'b1;
assign n_sclk_en25 = 1'b0;
assign n_ss_en25   = 1'b0;

assign smc_hsel_int25 = smc_hsel25;
  assign ext_clk25  = 1'b0;
  assign int_source25 = {macb0_int25,macb1_int25, macb2_int25, macb3_int25,1'b0, pcm_macb_wakeup_int25, 1'b0, 1'b0, 1'b0, 1'b0, TTC_int25, GPIO_int25, UART_int25, UART_int125, SPI_int25, DMA_irq25};

  // interrupt25 even25 detect25 .
  // for sleep25 wake25 up -> any interrupt25 even25 and system not in hibernation25 (isolate_mem25 = 0)
  // for hibernate25 wake25 up -> gpio25 interrupt25 even25 and system in the hibernation25 (isolate_mem25 = 1)
  assign int_source_h25 =  ((|int_source25) && (!isolate_mem25)) || (isolate_mem25 && GPIO_int25) ;

  assign byte_sel25 = 1'b1;
  assign tie_hi_bit25 = 1'b1;

  assign smc_addr25 = smc_addr_int25[15:0];



  assign  n_gpio_bypass_oe25 = {GPIO_WIDTH25{1'b0}};        // bypass25 mode enable 
  assign  gpio_bypass_out25  = {GPIO_WIDTH25{1'b0}};
  assign  tri_state_enable25 = {GPIO_WIDTH25{1'b0}};
  assign  cpu_debug25 = 1'b0;
  assign  tie_lo_32bit25 = 32'b0;
  assign  tie_lo_2bit25  = 2'b0;
  assign  tie_lo_1bit25  = 1'b0;


ahb2apb25 #(
  32'h00800000, // Slave25 0 Address Range25
  32'h0080FFFF,

  32'h00810000, // Slave25 1 Address Range25
  32'h0081FFFF,

  32'h00820000, // Slave25 2 Address Range25 
  32'h0082FFFF,

  32'h00830000, // Slave25 3 Address Range25
  32'h0083FFFF,

  32'h00840000, // Slave25 4 Address Range25
  32'h0084FFFF,

  32'h00850000, // Slave25 5 Address Range25
  32'h0085FFFF,

  32'h00860000, // Slave25 6 Address Range25
  32'h0086FFFF,

  32'h00870000, // Slave25 7 Address Range25
  32'h0087FFFF,

  32'h00880000, // Slave25 8 Address Range25
  32'h0088FFFF
) i_ahb2apb25 (
     // AHB25 interface
    .hclk25(hclk25),         
    .hreset_n25(n_hreset25), 
    .hsel25(hsel25), 
    .haddr25(haddr25),        
    .htrans25(htrans25),       
    .hwrite25(hwrite25),       
    .hwdata25(hwdata25),       
    .hrdata25(hrdata25),   
    .hready25(hready25),   
    .hresp25(hresp25),     
    
     // APB25 interface
    .pclk25(pclk25),         
    .preset_n25(n_preset25),  
    .prdata025(prdata_spi25),
    .prdata125(prdata_uart025), 
    .prdata225(prdata_gpio25),  
    .prdata325(prdata_ttc25),   
    .prdata425(32'h0),   
    .prdata525(prdata_smc25),   
    .prdata625(prdata_pmc25),    
    .prdata725(32'h0),   
    .prdata825(prdata_uart125),  
    .pready025(pready_spi25),     
    .pready125(pready_uart025),   
    .pready225(tie_hi_bit25),     
    .pready325(tie_hi_bit25),     
    .pready425(tie_hi_bit25),     
    .pready525(tie_hi_bit25),     
    .pready625(tie_hi_bit25),     
    .pready725(tie_hi_bit25),     
    .pready825(pready_uart125),  
    .pwdata25(pwdata25),       
    .pwrite25(pwrite25),       
    .paddr25(paddr25),        
    .psel025(psel_spi25),     
    .psel125(psel_uart025),   
    .psel225(psel_gpio25),    
    .psel325(psel_ttc25),     
    .psel425(),     
    .psel525(psel_smc25),     
    .psel625(psel_pmc25),    
    .psel725(psel_apic25),   
    .psel825(psel_uart125),  
    .penable25(penable25)     
);

spi_top25 i_spi25
(
  // Wishbone25 signals25
  .wb_clk_i25(pclk25), 
  .wb_rst_i25(~n_preset25), 
  .wb_adr_i25(paddr25[4:0]), 
  .wb_dat_i25(pwdata25), 
  .wb_dat_o25(prdata_spi25), 
  .wb_sel_i25(4'b1111),    // SPI25 register accesses are always 32-bit
  .wb_we_i25(pwrite25), 
  .wb_stb_i25(psel_spi25), 
  .wb_cyc_i25(psel_spi25), 
  .wb_ack_o25(pready_spi25), 
  .wb_err_o25(), 
  .wb_int_o25(SPI_int25),

  // SPI25 signals25
  .ss_pad_o25(n_ss_out25), 
  .sclk_pad_o25(sclk_out25), 
  .mosi_pad_o25(mo25), 
  .miso_pad_i25(mi25)
);

// Opencores25 UART25 instances25
wire ua_nrts_int25;
wire ua_nrts1_int25;

assign ua_nrts25 = ua_nrts_int25;
assign ua_nrts125 = ua_nrts1_int25;

reg [3:0] uart0_sel_i25;
reg [3:0] uart1_sel_i25;
// UART25 registers are all 8-bit wide25, and their25 addresses25
// are on byte boundaries25. So25 to access them25 on the
// Wishbone25 bus, the CPU25 must do byte accesses to these25
// byte addresses25. Word25 address accesses are not possible25
// because the word25 addresses25 will be unaligned25, and cause
// a fault25.
// So25, Uart25 accesses from the CPU25 will always be 8-bit size
// We25 only have to decide25 which byte of the 4-byte word25 the
// CPU25 is interested25 in.
`ifdef SYSTEM_BIG_ENDIAN25
always @(paddr25) begin
  case (paddr25[1:0])
    2'b00 : uart0_sel_i25 = 4'b1000;
    2'b01 : uart0_sel_i25 = 4'b0100;
    2'b10 : uart0_sel_i25 = 4'b0010;
    2'b11 : uart0_sel_i25 = 4'b0001;
  endcase
end
always @(paddr25) begin
  case (paddr25[1:0])
    2'b00 : uart1_sel_i25 = 4'b1000;
    2'b01 : uart1_sel_i25 = 4'b0100;
    2'b10 : uart1_sel_i25 = 4'b0010;
    2'b11 : uart1_sel_i25 = 4'b0001;
  endcase
end
`else
always @(paddr25) begin
  case (paddr25[1:0])
    2'b00 : uart0_sel_i25 = 4'b0001;
    2'b01 : uart0_sel_i25 = 4'b0010;
    2'b10 : uart0_sel_i25 = 4'b0100;
    2'b11 : uart0_sel_i25 = 4'b1000;
  endcase
end
always @(paddr25) begin
  case (paddr25[1:0])
    2'b00 : uart1_sel_i25 = 4'b0001;
    2'b01 : uart1_sel_i25 = 4'b0010;
    2'b10 : uart1_sel_i25 = 4'b0100;
    2'b11 : uart1_sel_i25 = 4'b1000;
  endcase
end
`endif

uart_top25 i_oc_uart025 (
  .wb_clk_i25(pclk25),
  .wb_rst_i25(~n_preset25),
  .wb_adr_i25(paddr25[4:0]),
  .wb_dat_i25(pwdata25),
  .wb_dat_o25(prdata_uart025),
  .wb_we_i25(pwrite25),
  .wb_stb_i25(psel_uart025),
  .wb_cyc_i25(psel_uart025),
  .wb_ack_o25(pready_uart025),
  .wb_sel_i25(uart0_sel_i25),
  .int_o25(UART_int25),
  .stx_pad_o25(ua_txd25),
  .srx_pad_i25(ua_rxd25),
  .rts_pad_o25(ua_nrts_int25),
  .cts_pad_i25(ua_ncts25),
  .dtr_pad_o25(),
  .dsr_pad_i25(1'b0),
  .ri_pad_i25(1'b0),
  .dcd_pad_i25(1'b0)
);

uart_top25 i_oc_uart125 (
  .wb_clk_i25(pclk25),
  .wb_rst_i25(~n_preset25),
  .wb_adr_i25(paddr25[4:0]),
  .wb_dat_i25(pwdata25),
  .wb_dat_o25(prdata_uart125),
  .wb_we_i25(pwrite25),
  .wb_stb_i25(psel_uart125),
  .wb_cyc_i25(psel_uart125),
  .wb_ack_o25(pready_uart125),
  .wb_sel_i25(uart1_sel_i25),
  .int_o25(UART_int125),
  .stx_pad_o25(ua_txd125),
  .srx_pad_i25(ua_rxd125),
  .rts_pad_o25(ua_nrts1_int25),
  .cts_pad_i25(ua_ncts125),
  .dtr_pad_o25(),
  .dsr_pad_i25(1'b0),
  .ri_pad_i25(1'b0),
  .dcd_pad_i25(1'b0)
);

gpio_veneer25 i_gpio_veneer25 (
        //inputs25

        . n_p_reset25(n_preset25),
        . pclk25(pclk25),
        . psel25(psel_gpio25),
        . penable25(penable25),
        . pwrite25(pwrite25),
        . paddr25(paddr25[5:0]),
        . pwdata25(pwdata25),
        . gpio_pin_in25(gpio_pin_in25),
        . scan_en25(scan_en25),
        . tri_state_enable25(tri_state_enable25),
        . scan_in25(), //added by smarkov25 for dft25

        //outputs25
        . scan_out25(), //added by smarkov25 for dft25
        . prdata25(prdata_gpio25),
        . gpio_int25(GPIO_int25),
        . n_gpio_pin_oe25(n_gpio_pin_oe25),
        . gpio_pin_out25(gpio_pin_out25)
);


ttc_veneer25 i_ttc_veneer25 (

         //inputs25
        . n_p_reset25(n_preset25),
        . pclk25(pclk25),
        . psel25(psel_ttc25),
        . penable25(penable25),
        . pwrite25(pwrite25),
        . pwdata25(pwdata25),
        . paddr25(paddr25[7:0]),
        . scan_in25(),
        . scan_en25(scan_en25),

        //outputs25
        . prdata25(prdata_ttc25),
        . interrupt25(TTC_int25[3:1]),
        . scan_out25()
);


smc_veneer25 i_smc_veneer25 (
        //inputs25
	//apb25 inputs25
        . n_preset25(n_preset25),
        . pclk25(pclk_SRPG_smc25),
        . psel25(psel_smc25),
        . penable25(penable25),
        . pwrite25(pwrite25),
        . paddr25(paddr25[4:0]),
        . pwdata25(pwdata25),
        //ahb25 inputs25
	. hclk25(smc_hclk25),
        . n_sys_reset25(rstn_non_srpg_smc25),
        . haddr25(smc_haddr25),
        . htrans25(smc_htrans25),
        . hsel25(smc_hsel_int25),
        . hwrite25(smc_hwrite25),
	. hsize25(smc_hsize25),
        . hwdata25(smc_hwdata25),
        . hready25(smc_hready_in25),
        . data_smc25(data_smc25),

         //test signal25 inputs25

        . scan_in_125(),
        . scan_in_225(),
        . scan_in_325(),
        . scan_en25(scan_en25),

        //apb25 outputs25
        . prdata25(prdata_smc25),

       //design output

        . smc_hrdata25(smc_hrdata25),
        . smc_hready25(smc_hready25),
        . smc_hresp25(smc_hresp25),
        . smc_valid25(smc_valid25),
        . smc_addr25(smc_addr_int25),
        . smc_data25(smc_data25),
        . smc_n_be25(smc_n_be25),
        . smc_n_cs25(smc_n_cs25),
        . smc_n_wr25(smc_n_wr25),
        . smc_n_we25(smc_n_we25),
        . smc_n_rd25(smc_n_rd25),
        . smc_n_ext_oe25(smc_n_ext_oe25),
        . smc_busy25(smc_busy25),

         //test signal25 output
        . scan_out_125(),
        . scan_out_225(),
        . scan_out_325()
);

power_ctrl_veneer25 i_power_ctrl_veneer25 (
    // -- Clocks25 & Reset25
    	.pclk25(pclk25), 			//  : in  std_logic25;
    	.nprst25(n_preset25), 		//  : in  std_logic25;
    // -- APB25 programming25 interface
    	.paddr25(paddr25), 			//  : in  std_logic_vector25(31 downto25 0);
    	.psel25(psel_pmc25), 			//  : in  std_logic25;
    	.penable25(penable25), 		//  : in  std_logic25;
    	.pwrite25(pwrite25), 		//  : in  std_logic25;
    	.pwdata25(pwdata25), 		//  : in  std_logic_vector25(31 downto25 0);
    	.prdata25(prdata_pmc25), 		//  : out std_logic_vector25(31 downto25 0);
        .macb3_wakeup25(macb3_wakeup25),
        .macb2_wakeup25(macb2_wakeup25),
        .macb1_wakeup25(macb1_wakeup25),
        .macb0_wakeup25(macb0_wakeup25),
    // -- Module25 control25 outputs25
    	.scan_in25(),			//  : in  std_logic25;
    	.scan_en25(scan_en25),             	//  : in  std_logic25;
    	.scan_mode25(scan_mode25),          //  : in  std_logic25;
    	.scan_out25(),            	//  : out std_logic25;
        .int_source_h25(int_source_h25),
     	.rstn_non_srpg_smc25(rstn_non_srpg_smc25), 		//   : out std_logic25;
    	.gate_clk_smc25(gate_clk_smc25), 	//  : out std_logic25;
    	.isolate_smc25(isolate_smc25), 	//  : out std_logic25;
    	.save_edge_smc25(save_edge_smc25), 	//  : out std_logic25;
    	.restore_edge_smc25(restore_edge_smc25), 	//  : out std_logic25;
    	.pwr1_on_smc25(pwr1_on_smc25), 	//  : out std_logic25;
    	.pwr2_on_smc25(pwr2_on_smc25), 	//  : out std_logic25
     	.rstn_non_srpg_urt25(rstn_non_srpg_urt25), 		//   : out std_logic25;
    	.gate_clk_urt25(gate_clk_urt25), 	//  : out std_logic25;
    	.isolate_urt25(isolate_urt25), 	//  : out std_logic25;
    	.save_edge_urt25(save_edge_urt25), 	//  : out std_logic25;
    	.restore_edge_urt25(restore_edge_urt25), 	//  : out std_logic25;
    	.pwr1_on_urt25(pwr1_on_urt25), 	//  : out std_logic25;
    	.pwr2_on_urt25(pwr2_on_urt25),  	//  : out std_logic25
        // ETH025
        .rstn_non_srpg_macb025(rstn_non_srpg_macb025),
        .gate_clk_macb025(gate_clk_macb025),
        .isolate_macb025(isolate_macb025),
        .save_edge_macb025(save_edge_macb025),
        .restore_edge_macb025(restore_edge_macb025),
        .pwr1_on_macb025(pwr1_on_macb025),
        .pwr2_on_macb025(pwr2_on_macb025),
        // ETH125
        .rstn_non_srpg_macb125(rstn_non_srpg_macb125),
        .gate_clk_macb125(gate_clk_macb125),
        .isolate_macb125(isolate_macb125),
        .save_edge_macb125(save_edge_macb125),
        .restore_edge_macb125(restore_edge_macb125),
        .pwr1_on_macb125(pwr1_on_macb125),
        .pwr2_on_macb125(pwr2_on_macb125),
        // ETH225
        .rstn_non_srpg_macb225(rstn_non_srpg_macb225),
        .gate_clk_macb225(gate_clk_macb225),
        .isolate_macb225(isolate_macb225),
        .save_edge_macb225(save_edge_macb225),
        .restore_edge_macb225(restore_edge_macb225),
        .pwr1_on_macb225(pwr1_on_macb225),
        .pwr2_on_macb225(pwr2_on_macb225),
        // ETH325
        .rstn_non_srpg_macb325(rstn_non_srpg_macb325),
        .gate_clk_macb325(gate_clk_macb325),
        .isolate_macb325(isolate_macb325),
        .save_edge_macb325(save_edge_macb325),
        .restore_edge_macb325(restore_edge_macb325),
        .pwr1_on_macb325(pwr1_on_macb325),
        .pwr2_on_macb325(pwr2_on_macb325),
        .core06v25(core06v25),
        .core08v25(core08v25),
        .core10v25(core10v25),
        .core12v25(core12v25),
        .pcm_macb_wakeup_int25(pcm_macb_wakeup_int25),
        .isolate_mem25(isolate_mem25),
        .mte_smc_start25(mte_smc_start25),
        .mte_uart_start25(mte_uart_start25),
        .mte_smc_uart_start25(mte_smc_uart_start25),  
        .mte_pm_smc_to_default_start25(mte_pm_smc_to_default_start25), 
        .mte_pm_uart_to_default_start25(mte_pm_uart_to_default_start25),
        .mte_pm_smc_uart_to_default_start25(mte_pm_smc_uart_to_default_start25)
);

// Clock25 gating25 macro25 to shut25 off25 clocks25 to the SRPG25 flops25 in the SMC25
//CKLNQD125 i_SMC_SRPG_clk_gate25  (
//	.TE25(scan_mode25), 
//	.E25(~gate_clk_smc25), 
//	.CP25(pclk25), 
//	.Q25(pclk_SRPG_smc25)
//	);
// Replace25 gate25 with behavioural25 code25 //
wire 	smc_scan_gate25;
reg 	smc_latched_enable25;
assign smc_scan_gate25 = scan_mode25 ? 1'b1 : ~gate_clk_smc25;

always @ (pclk25 or smc_scan_gate25)
  	if (pclk25 == 1'b0) begin
  		smc_latched_enable25 <= smc_scan_gate25;
  	end  	
	
assign pclk_SRPG_smc25 = smc_latched_enable25 ? pclk25 : 1'b0;


// Clock25 gating25 macro25 to shut25 off25 clocks25 to the SRPG25 flops25 in the URT25
//CKLNQD125 i_URT_SRPG_clk_gate25  (
//	.TE25(scan_mode25), 
//	.E25(~gate_clk_urt25), 
//	.CP25(pclk25), 
//	.Q25(pclk_SRPG_urt25)
//	);
// Replace25 gate25 with behavioural25 code25 //
wire 	urt_scan_gate25;
reg 	urt_latched_enable25;
assign urt_scan_gate25 = scan_mode25 ? 1'b1 : ~gate_clk_urt25;

always @ (pclk25 or urt_scan_gate25)
  	if (pclk25 == 1'b0) begin
  		urt_latched_enable25 <= urt_scan_gate25;
  	end  	
	
assign pclk_SRPG_urt25 = urt_latched_enable25 ? pclk25 : 1'b0;

// ETH025
wire 	macb0_scan_gate25;
reg 	macb0_latched_enable25;
assign macb0_scan_gate25 = scan_mode25 ? 1'b1 : ~gate_clk_macb025;

always @ (pclk25 or macb0_scan_gate25)
  	if (pclk25 == 1'b0) begin
  		macb0_latched_enable25 <= macb0_scan_gate25;
  	end  	
	
assign clk_SRPG_macb0_en25 = macb0_latched_enable25 ? 1'b1 : 1'b0;

// ETH125
wire 	macb1_scan_gate25;
reg 	macb1_latched_enable25;
assign macb1_scan_gate25 = scan_mode25 ? 1'b1 : ~gate_clk_macb125;

always @ (pclk25 or macb1_scan_gate25)
  	if (pclk25 == 1'b0) begin
  		macb1_latched_enable25 <= macb1_scan_gate25;
  	end  	
	
assign clk_SRPG_macb1_en25 = macb1_latched_enable25 ? 1'b1 : 1'b0;

// ETH225
wire 	macb2_scan_gate25;
reg 	macb2_latched_enable25;
assign macb2_scan_gate25 = scan_mode25 ? 1'b1 : ~gate_clk_macb225;

always @ (pclk25 or macb2_scan_gate25)
  	if (pclk25 == 1'b0) begin
  		macb2_latched_enable25 <= macb2_scan_gate25;
  	end  	
	
assign clk_SRPG_macb2_en25 = macb2_latched_enable25 ? 1'b1 : 1'b0;

// ETH325
wire 	macb3_scan_gate25;
reg 	macb3_latched_enable25;
assign macb3_scan_gate25 = scan_mode25 ? 1'b1 : ~gate_clk_macb325;

always @ (pclk25 or macb3_scan_gate25)
  	if (pclk25 == 1'b0) begin
  		macb3_latched_enable25 <= macb3_scan_gate25;
  	end  	
	
assign clk_SRPG_macb3_en25 = macb3_latched_enable25 ? 1'b1 : 1'b0;



`else
//------------------------------------------------------------------------------
// if the APB25 subsystem25 is black25 boxed25 
//------------------------------------------------------------------------------
// wire s ports25
    // system signals25
    wire         hclk25;     // AHB25 Clock25
    wire         n_hreset25;  // AHB25 reset - Active25 low25
    wire         pclk25;     // APB25 Clock25. 
    wire         n_preset25;  // APB25 reset - Active25 low25

    // AHB25 interface
    wire         ahb2apb0_hsel25;     // AHB2APB25 select25
    wire  [31:0] haddr25;    // Address bus
    wire  [1:0]  htrans25;   // Transfer25 type
    wire  [2:0]  hsize25;    // AHB25 Access type - byte, half25-word25, word25
    wire  [31:0] hwdata25;   // Write data
    wire         hwrite25;   // Write signal25/
    wire         hready_in25;// Indicates25 that last master25 has finished25 bus access
    wire [2:0]   hburst25;     // Burst type
    wire [3:0]   hprot25;      // Protection25 control25
    wire [3:0]   hmaster25;    // Master25 select25
    wire         hmastlock25;  // Locked25 transfer25
  // Interrupts25 from the Enet25 MACs25
    wire         macb0_int25;
    wire         macb1_int25;
    wire         macb2_int25;
    wire         macb3_int25;
  // Interrupt25 from the DMA25
    wire         DMA_irq25;
  // Scan25 wire s
    wire         scan_en25;    // Scan25 enable pin25
    wire         scan_in_125;  // Scan25 wire  for first chain25
    wire         scan_in_225;  // Scan25 wire  for second chain25
    wire         scan_mode25;  // test mode pin25
 
  //wire  for smc25 AHB25 interface
    wire         smc_hclk25;
    wire         smc_n_hclk25;
    wire  [31:0] smc_haddr25;
    wire  [1:0]  smc_htrans25;
    wire         smc_hsel25;
    wire         smc_hwrite25;
    wire  [2:0]  smc_hsize25;
    wire  [31:0] smc_hwdata25;
    wire         smc_hready_in25;
    wire  [2:0]  smc_hburst25;     // Burst type
    wire  [3:0]  smc_hprot25;      // Protection25 control25
    wire  [3:0]  smc_hmaster25;    // Master25 select25
    wire         smc_hmastlock25;  // Locked25 transfer25


    wire  [31:0] data_smc25;     // EMI25(External25 memory) read data
    
  //wire s for uart25
    wire         ua_rxd25;       // UART25 receiver25 serial25 wire  pin25
    wire         ua_rxd125;      // UART25 receiver25 serial25 wire  pin25
    wire         ua_ncts25;      // Clear-To25-Send25 flow25 control25
    wire         ua_ncts125;      // Clear-To25-Send25 flow25 control25
   //wire s for spi25
    wire         n_ss_in25;      // select25 wire  to slave25
    wire         mi25;           // data wire  to master25
    wire         si25;           // data wire  to slave25
    wire         sclk_in25;      // clock25 wire  to slave25
  //wire s for GPIO25
   wire  [GPIO_WIDTH25-1:0]  gpio_pin_in25;             // wire  data from pin25

  //reg    ports25
  // Scan25 reg   s
   reg           scan_out_125;   // Scan25 out for chain25 1
   reg           scan_out_225;   // Scan25 out for chain25 2
  //AHB25 interface 
   reg    [31:0] hrdata25;       // Read data provided from target slave25
   reg           hready25;       // Ready25 for new bus cycle from target slave25
   reg    [1:0]  hresp25;       // Response25 from the bridge25

   // SMC25 reg    for AHB25 interface
   reg    [31:0]    smc_hrdata25;
   reg              smc_hready25;
   reg    [1:0]     smc_hresp25;

  //reg   s from smc25
   reg    [15:0]    smc_addr25;      // External25 Memory (EMI25) address
   reg    [3:0]     smc_n_be25;      // EMI25 byte enables25 (Active25 LOW25)
   reg    [7:0]     smc_n_cs25;      // EMI25 Chip25 Selects25 (Active25 LOW25)
   reg    [3:0]     smc_n_we25;      // EMI25 write strobes25 (Active25 LOW25)
   reg              smc_n_wr25;      // EMI25 write enable (Active25 LOW25)
   reg              smc_n_rd25;      // EMI25 read stobe25 (Active25 LOW25)
   reg              smc_n_ext_oe25;  // EMI25 write data reg    enable
   reg    [31:0]    smc_data25;      // EMI25 write data
  //reg   s from uart25
   reg           ua_txd25;       	// UART25 transmitter25 serial25 reg   
   reg           ua_txd125;       // UART25 transmitter25 serial25 reg   
   reg           ua_nrts25;      	// Request25-To25-Send25 flow25 control25
   reg           ua_nrts125;      // Request25-To25-Send25 flow25 control25
   // reg   s from ttc25
  // reg   s from SPI25
   reg       so;                    // data reg    from slave25
   reg       mo25;                    // data reg    from master25
   reg       sclk_out25;              // clock25 reg    from master25
   reg    [P_SIZE25-1:0] n_ss_out25;    // peripheral25 select25 lines25 from master25
   reg       n_so_en25;               // out enable for slave25 data
   reg       n_mo_en25;               // out enable for master25 data
   reg       n_sclk_en25;             // out enable for master25 clock25
   reg       n_ss_en25;               // out enable for master25 peripheral25 lines25
  //reg   s from gpio25
   reg    [GPIO_WIDTH25-1:0]     n_gpio_pin_oe25;           // reg    enable signal25 to pin25
   reg    [GPIO_WIDTH25-1:0]     gpio_pin_out25;            // reg    signal25 to pin25


`endif
//------------------------------------------------------------------------------
// black25 boxed25 defines25 
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// APB25 and AHB25 interface formal25 verification25 monitors25
//------------------------------------------------------------------------------
`ifdef ABV_ON25
apb_assert25 i_apb_assert25 (

        // APB25 signals25
  	.n_preset25(n_preset25),
   	.pclk25(pclk25),
	.penable25(penable25),
	.paddr25(paddr25),
	.pwrite25(pwrite25),
	.pwdata25(pwdata25),

	.psel0025(psel_spi25),
	.psel0125(psel_uart025),
	.psel0225(psel_gpio25),
	.psel0325(psel_ttc25),
	.psel0425(1'b0),
	.psel0525(psel_smc25),
	.psel0625(1'b0),
	.psel0725(1'b0),
	.psel0825(1'b0),
	.psel0925(1'b0),
	.psel1025(1'b0),
	.psel1125(1'b0),
	.psel1225(1'b0),
	.psel1325(psel_pmc25),
	.psel1425(psel_apic25),
	.psel1525(psel_uart125),

        .prdata0025(prdata_spi25),
        .prdata0125(prdata_uart025), // Read Data from peripheral25 UART25 
        .prdata0225(prdata_gpio25), // Read Data from peripheral25 GPIO25
        .prdata0325(prdata_ttc25), // Read Data from peripheral25 TTC25
        .prdata0425(32'b0), // 
        .prdata0525(prdata_smc25), // Read Data from peripheral25 SMC25
        .prdata1325(prdata_pmc25), // Read Data from peripheral25 Power25 Control25 Block
   	.prdata1425(32'b0), // 
        .prdata1525(prdata_uart125),


        // AHB25 signals25
        .hclk25(hclk25),         // ahb25 system clock25
        .n_hreset25(n_hreset25), // ahb25 system reset

        // ahb2apb25 signals25
        .hresp25(hresp25),
        .hready25(hready25),
        .hrdata25(hrdata25),
        .hwdata25(hwdata25),
        .hprot25(hprot25),
        .hburst25(hburst25),
        .hsize25(hsize25),
        .hwrite25(hwrite25),
        .htrans25(htrans25),
        .haddr25(haddr25),
        .ahb2apb_hsel25(ahb2apb0_hsel25));



//------------------------------------------------------------------------------
// AHB25 interface formal25 verification25 monitor25
//------------------------------------------------------------------------------
defparam i_ahbSlaveMonitor25.DBUS_WIDTH25 = 32;
defparam i_ahbMasterMonitor25.DBUS_WIDTH25 = 32;


// AHB2APB25 Bridge25

    ahb_liteslave_monitor25 i_ahbSlaveMonitor25 (
        .hclk_i25(hclk25),
        .hresetn_i25(n_hreset25),
        .hresp25(hresp25),
        .hready25(hready25),
        .hready_global_i25(hready25),
        .hrdata25(hrdata25),
        .hwdata_i25(hwdata25),
        .hburst_i25(hburst25),
        .hsize_i25(hsize25),
        .hwrite_i25(hwrite25),
        .htrans_i25(htrans25),
        .haddr_i25(haddr25),
        .hsel_i25(ahb2apb0_hsel25)
    );


  ahb_litemaster_monitor25 i_ahbMasterMonitor25 (
          .hclk_i25(hclk25),
          .hresetn_i25(n_hreset25),
          .hresp_i25(hresp25),
          .hready_i25(hready25),
          .hrdata_i25(hrdata25),
          .hlock25(1'b0),
          .hwdata25(hwdata25),
          .hprot25(hprot25),
          .hburst25(hburst25),
          .hsize25(hsize25),
          .hwrite25(hwrite25),
          .htrans25(htrans25),
          .haddr25(haddr25)
          );







`endif




`ifdef IFV_LP_ABV_ON25
// power25 control25
wire isolate25;

// testbench mirror signals25
wire L1_ctrl_access25;
wire L1_status_access25;

wire [31:0] L1_status_reg25;
wire [31:0] L1_ctrl_reg25;

//wire rstn_non_srpg_urt25;
//wire isolate_urt25;
//wire retain_urt25;
//wire gate_clk_urt25;
//wire pwr1_on_urt25;


// smc25 signals25
wire [31:0] smc_prdata25;
wire lp_clk_smc25;
                    

// uart25 isolation25 register
  wire [15:0] ua_prdata25;
  wire ua_int25;
  assign ua_prdata25          =  i_uart1_veneer25.prdata25;
  assign ua_int25             =  i_uart1_veneer25.ua_int25;


assign lp_clk_smc25          = i_smc_veneer25.pclk25;
assign smc_prdata25          = i_smc_veneer25.prdata25;
lp_chk_smc25 u_lp_chk_smc25 (
    .clk25 (hclk25),
    .rst25 (n_hreset25),
    .iso_smc25 (isolate_smc25),
    .gate_clk25 (gate_clk_smc25),
    .lp_clk25 (pclk_SRPG_smc25),

    // srpg25 outputs25
    .smc_hrdata25 (smc_hrdata25),
    .smc_hready25 (smc_hready25),
    .smc_hresp25  (smc_hresp25),
    .smc_valid25 (smc_valid25),
    .smc_addr_int25 (smc_addr_int25),
    .smc_data25 (smc_data25),
    .smc_n_be25 (smc_n_be25),
    .smc_n_cs25  (smc_n_cs25),
    .smc_n_wr25 (smc_n_wr25),
    .smc_n_we25 (smc_n_we25),
    .smc_n_rd25 (smc_n_rd25),
    .smc_n_ext_oe25 (smc_n_ext_oe25)
   );

// lp25 retention25/isolation25 assertions25
lp_chk_uart25 u_lp_chk_urt25 (

  .clk25         (hclk25),
  .rst25         (n_hreset25),
  .iso_urt25     (isolate_urt25),
  .gate_clk25    (gate_clk_urt25),
  .lp_clk25      (pclk_SRPG_urt25),
  //ports25
  .prdata25 (ua_prdata25),
  .ua_int25 (ua_int25),
  .ua_txd25 (ua_txd125),
  .ua_nrts25 (ua_nrts125)
 );

`endif  //IFV_LP_ABV_ON25




endmodule
