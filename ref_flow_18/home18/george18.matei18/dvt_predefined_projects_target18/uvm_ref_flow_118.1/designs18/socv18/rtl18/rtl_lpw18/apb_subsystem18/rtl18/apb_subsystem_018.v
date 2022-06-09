//File18 name   : apb_subsystem_018.v
//Title18       : 
//Created18     : 1999
//Description18 : 
//Notes18       : 
//----------------------------------------------------------------------
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------

module apb_subsystem_018(
    // AHB18 interface
    hclk18,
    n_hreset18,
    hsel18,
    haddr18,
    htrans18,
    hsize18,
    hwrite18,
    hwdata18,
    hready_in18,
    hburst18,
    hprot18,
    hmaster18,
    hmastlock18,
    hrdata18,
    hready18,
    hresp18,
    
    // APB18 system interface
    pclk18,
    n_preset18,
    
    // SPI18 ports18
    n_ss_in18,
    mi18,
    si18,
    sclk_in18,
    so,
    mo18,
    sclk_out18,
    n_ss_out18,
    n_so_en18,
    n_mo_en18,
    n_sclk_en18,
    n_ss_en18,
    
    //UART018 ports18
    ua_rxd18,
    ua_ncts18,
    ua_txd18,
    ua_nrts18,
    
    //UART118 ports18
    ua_rxd118,
    ua_ncts118,
    ua_txd118,
    ua_nrts118,
    
    //GPIO18 ports18
    gpio_pin_in18,
    n_gpio_pin_oe18,
    gpio_pin_out18,
    

    //SMC18 ports18
    smc_hclk18,
    smc_n_hclk18,
    smc_haddr18,
    smc_htrans18,
    smc_hsel18,
    smc_hwrite18,
    smc_hsize18,
    smc_hwdata18,
    smc_hready_in18,
    smc_hburst18,
    smc_hprot18,
    smc_hmaster18,
    smc_hmastlock18,
    smc_hrdata18, 
    smc_hready18,
    smc_hresp18,
    smc_n_ext_oe18,
    smc_data18,
    smc_addr18,
    smc_n_be18,
    smc_n_cs18, 
    smc_n_we18,
    smc_n_wr18,
    smc_n_rd18,
    data_smc18,
    
    //PMC18 ports18
    clk_SRPG_macb0_en18,
    clk_SRPG_macb1_en18,
    clk_SRPG_macb2_en18,
    clk_SRPG_macb3_en18,
    core06v18,
    core08v18,
    core10v18,
    core12v18,
    macb3_wakeup18,
    macb2_wakeup18,
    macb1_wakeup18,
    macb0_wakeup18,
    mte_smc_start18,
    mte_uart_start18,
    mte_smc_uart_start18,  
    mte_pm_smc_to_default_start18, 
    mte_pm_uart_to_default_start18,
    mte_pm_smc_uart_to_default_start18,
    
    
    // Peripheral18 inerrupts18
    pcm_irq18,
    ttc_irq18,
    gpio_irq18,
    uart0_irq18,
    uart1_irq18,
    spi_irq18,
    DMA_irq18,      
    macb0_int18,
    macb1_int18,
    macb2_int18,
    macb3_int18,
   
    // Scan18 ports18
    scan_en18,      // Scan18 enable pin18
    scan_in_118,    // Scan18 input for first chain18
    scan_in_218,    // Scan18 input for second chain18
    scan_mode18,
    scan_out_118,   // Scan18 out for chain18 1
    scan_out_218    // Scan18 out for chain18 2
);

parameter GPIO_WIDTH18 = 16;        // GPIO18 width
parameter P_SIZE18 =   8;              // number18 of peripheral18 select18 lines18
parameter NO_OF_IRQS18  = 17;      //No of irqs18 read by apic18 

// AHB18 interface
input         hclk18;     // AHB18 Clock18
input         n_hreset18;  // AHB18 reset - Active18 low18
input         hsel18;     // AHB2APB18 select18
input [31:0]  haddr18;    // Address bus
input [1:0]   htrans18;   // Transfer18 type
input [2:0]   hsize18;    // AHB18 Access type - byte, half18-word18, word18
input [31:0]  hwdata18;   // Write data
input         hwrite18;   // Write signal18/
input         hready_in18;// Indicates18 that last master18 has finished18 bus access
input [2:0]   hburst18;     // Burst type
input [3:0]   hprot18;      // Protection18 control18
input [3:0]   hmaster18;    // Master18 select18
input         hmastlock18;  // Locked18 transfer18
output [31:0] hrdata18;       // Read data provided from target slave18
output        hready18;       // Ready18 for new bus cycle from target slave18
output [1:0]  hresp18;       // Response18 from the bridge18
    
// APB18 system interface
input         pclk18;     // APB18 Clock18. 
input         n_preset18;  // APB18 reset - Active18 low18
   
// SPI18 ports18
input     n_ss_in18;      // select18 input to slave18
input     mi18;           // data input to master18
input     si18;           // data input to slave18
input     sclk_in18;      // clock18 input to slave18
output    so;                    // data output from slave18
output    mo18;                    // data output from master18
output    sclk_out18;              // clock18 output from master18
output [P_SIZE18-1:0] n_ss_out18;    // peripheral18 select18 lines18 from master18
output    n_so_en18;               // out enable for slave18 data
output    n_mo_en18;               // out enable for master18 data
output    n_sclk_en18;             // out enable for master18 clock18
output    n_ss_en18;               // out enable for master18 peripheral18 lines18

//UART018 ports18
input        ua_rxd18;       // UART18 receiver18 serial18 input pin18
input        ua_ncts18;      // Clear-To18-Send18 flow18 control18
output       ua_txd18;       	// UART18 transmitter18 serial18 output
output       ua_nrts18;      	// Request18-To18-Send18 flow18 control18

// UART118 ports18   
input        ua_rxd118;      // UART18 receiver18 serial18 input pin18
input        ua_ncts118;      // Clear-To18-Send18 flow18 control18
output       ua_txd118;       // UART18 transmitter18 serial18 output
output       ua_nrts118;      // Request18-To18-Send18 flow18 control18

//GPIO18 ports18
input [GPIO_WIDTH18-1:0]      gpio_pin_in18;             // input data from pin18
output [GPIO_WIDTH18-1:0]     n_gpio_pin_oe18;           // output enable signal18 to pin18
output [GPIO_WIDTH18-1:0]     gpio_pin_out18;            // output signal18 to pin18
  
//SMC18 ports18
input        smc_hclk18;
input        smc_n_hclk18;
input [31:0] smc_haddr18;
input [1:0]  smc_htrans18;
input        smc_hsel18;
input        smc_hwrite18;
input [2:0]  smc_hsize18;
input [31:0] smc_hwdata18;
input        smc_hready_in18;
input [2:0]  smc_hburst18;     // Burst type
input [3:0]  smc_hprot18;      // Protection18 control18
input [3:0]  smc_hmaster18;    // Master18 select18
input        smc_hmastlock18;  // Locked18 transfer18
input [31:0] data_smc18;     // EMI18(External18 memory) read data
output [31:0]    smc_hrdata18;
output           smc_hready18;
output [1:0]     smc_hresp18;
output [15:0]    smc_addr18;      // External18 Memory (EMI18) address
output [3:0]     smc_n_be18;      // EMI18 byte enables18 (Active18 LOW18)
output           smc_n_cs18;      // EMI18 Chip18 Selects18 (Active18 LOW18)
output [3:0]     smc_n_we18;      // EMI18 write strobes18 (Active18 LOW18)
output           smc_n_wr18;      // EMI18 write enable (Active18 LOW18)
output           smc_n_rd18;      // EMI18 read stobe18 (Active18 LOW18)
output           smc_n_ext_oe18;  // EMI18 write data output enable
output [31:0]    smc_data18;      // EMI18 write data
       
//PMC18 ports18
output clk_SRPG_macb0_en18;
output clk_SRPG_macb1_en18;
output clk_SRPG_macb2_en18;
output clk_SRPG_macb3_en18;
output core06v18;
output core08v18;
output core10v18;
output core12v18;
output mte_smc_start18;
output mte_uart_start18;
output mte_smc_uart_start18;  
output mte_pm_smc_to_default_start18; 
output mte_pm_uart_to_default_start18;
output mte_pm_smc_uart_to_default_start18;
input macb3_wakeup18;
input macb2_wakeup18;
input macb1_wakeup18;
input macb0_wakeup18;
    

// Peripheral18 interrupts18
output pcm_irq18;
output [2:0] ttc_irq18;
output gpio_irq18;
output uart0_irq18;
output uart1_irq18;
output spi_irq18;
input        macb0_int18;
input        macb1_int18;
input        macb2_int18;
input        macb3_int18;
input        DMA_irq18;
  
//Scan18 ports18
input        scan_en18;    // Scan18 enable pin18
input        scan_in_118;  // Scan18 input for first chain18
input        scan_in_218;  // Scan18 input for second chain18
input        scan_mode18;  // test mode pin18
 output        scan_out_118;   // Scan18 out for chain18 1
 output        scan_out_218;   // Scan18 out for chain18 2  

//------------------------------------------------------------------------------
// if the ROM18 subsystem18 is NOT18 black18 boxed18 
//------------------------------------------------------------------------------
`ifndef FV_KIT_BLACK_BOX_APB_SUBSYSTEM18
   
   wire        hsel18; 
   wire        pclk18;
   wire        n_preset18;
   wire [31:0] prdata_spi18;
   wire [31:0] prdata_uart018;
   wire [31:0] prdata_gpio18;
   wire [31:0] prdata_ttc18;
   wire [31:0] prdata_smc18;
   wire [31:0] prdata_pmc18;
   wire [31:0] prdata_uart118;
   wire        pready_spi18;
   wire        pready_uart018;
   wire        pready_uart118;
   wire        tie_hi_bit18;
   wire  [31:0] hrdata18; 
   wire         hready18;
   wire         hready_in18;
   wire  [1:0]  hresp18;   
   wire  [31:0] pwdata18;  
   wire         pwrite18;
   wire  [31:0] paddr18;  
   wire   psel_spi18;
   wire   psel_uart018;
   wire   psel_gpio18;
   wire   psel_ttc18;
   wire   psel_smc18;
   wire   psel0718;
   wire   psel0818;
   wire   psel0918;
   wire   psel1018;
   wire   psel1118;
   wire   psel1218;
   wire   psel_pmc18;
   wire   psel_uart118;
   wire   penable18;
   wire   [NO_OF_IRQS18:0] int_source18;     // System18 Interrupt18 Sources18
   wire [1:0]             smc_hresp18;     // AHB18 Response18 signal18
   wire                   smc_valid18;     // Ack18 valid address

  //External18 memory interface (EMI18)
  wire [31:0]            smc_addr_int18;  // External18 Memory (EMI18) address
  wire [3:0]             smc_n_be18;      // EMI18 byte enables18 (Active18 LOW18)
  wire                   smc_n_cs18;      // EMI18 Chip18 Selects18 (Active18 LOW18)
  wire [3:0]             smc_n_we18;      // EMI18 write strobes18 (Active18 LOW18)
  wire                   smc_n_wr18;      // EMI18 write enable (Active18 LOW18)
  wire                   smc_n_rd18;      // EMI18 read stobe18 (Active18 LOW18)
 
  //AHB18 Memory Interface18 Control18
  wire                   smc_hsel_int18;
  wire                   smc_busy18;      // smc18 busy
   

//scan18 signals18

   wire                scan_in_118;        //scan18 input
   wire                scan_in_218;        //scan18 input
   wire                scan_en18;         //scan18 enable
   wire                scan_out_118;       //scan18 output
   wire                scan_out_218;       //scan18 output
   wire                byte_sel18;     // byte select18 from bridge18 1=byte, 0=2byte
   wire                UART_int18;     // UART18 module interrupt18 
   wire                ua_uclken18;    // Soft18 control18 of clock18
   wire                UART_int118;     // UART18 module interrupt18 
   wire                ua_uclken118;    // Soft18 control18 of clock18
   wire  [3:1]         TTC_int18;            //Interrupt18 from PCI18 
  // inputs18 to SPI18 
   wire    ext_clk18;                // external18 clock18
   wire    SPI_int18;             // interrupt18 request
  // outputs18 from SPI18
   wire    slave_out_clk18;         // modified slave18 clock18 output
 // gpio18 generic18 inputs18 
   wire  [GPIO_WIDTH18-1:0]   n_gpio_bypass_oe18;        // bypass18 mode enable 
   wire  [GPIO_WIDTH18-1:0]   gpio_bypass_out18;         // bypass18 mode output value 
   wire  [GPIO_WIDTH18-1:0]   tri_state_enable18;   // disables18 op enable -> z 
 // outputs18 
   //amba18 outputs18 
   // gpio18 generic18 outputs18 
   wire       GPIO_int18;                // gpio_interupt18 for input pin18 change 
   wire [GPIO_WIDTH18-1:0]     gpio_bypass_in18;          // bypass18 mode input data value  
                
   wire           cpu_debug18;        // Inhibits18 watchdog18 counter 
   wire            ex_wdz_n18;         // External18 Watchdog18 zero indication18
   wire           rstn_non_srpg_smc18; 
   wire           rstn_non_srpg_urt18;
   wire           isolate_smc18;
   wire           save_edge_smc18;
   wire           restore_edge_smc18;
   wire           save_edge_urt18;
   wire           restore_edge_urt18;
   wire           pwr1_on_smc18;
   wire           pwr2_on_smc18;
   wire           pwr1_on_urt18;
   wire           pwr2_on_urt18;
   // ETH018
   wire            rstn_non_srpg_macb018;
   wire            gate_clk_macb018;
   wire            isolate_macb018;
   wire            save_edge_macb018;
   wire            restore_edge_macb018;
   wire            pwr1_on_macb018;
   wire            pwr2_on_macb018;
   // ETH118
   wire            rstn_non_srpg_macb118;
   wire            gate_clk_macb118;
   wire            isolate_macb118;
   wire            save_edge_macb118;
   wire            restore_edge_macb118;
   wire            pwr1_on_macb118;
   wire            pwr2_on_macb118;
   // ETH218
   wire            rstn_non_srpg_macb218;
   wire            gate_clk_macb218;
   wire            isolate_macb218;
   wire            save_edge_macb218;
   wire            restore_edge_macb218;
   wire            pwr1_on_macb218;
   wire            pwr2_on_macb218;
   // ETH318
   wire            rstn_non_srpg_macb318;
   wire            gate_clk_macb318;
   wire            isolate_macb318;
   wire            save_edge_macb318;
   wire            restore_edge_macb318;
   wire            pwr1_on_macb318;
   wire            pwr2_on_macb318;


   wire           pclk_SRPG_smc18;
   wire           pclk_SRPG_urt18;
   wire           gate_clk_smc18;
   wire           gate_clk_urt18;
   wire  [31:0]   tie_lo_32bit18; 
   wire  [1:0]	  tie_lo_2bit18;
   wire  	  tie_lo_1bit18;
   wire           pcm_macb_wakeup_int18;
   wire           int_source_h18;
   wire           isolate_mem18;

assign pcm_irq18 = pcm_macb_wakeup_int18;
assign ttc_irq18[2] = TTC_int18[3];
assign ttc_irq18[1] = TTC_int18[2];
assign ttc_irq18[0] = TTC_int18[1];
assign gpio_irq18 = GPIO_int18;
assign uart0_irq18 = UART_int18;
assign uart1_irq18 = UART_int118;
assign spi_irq18 = SPI_int18;

assign n_mo_en18   = 1'b0;
assign n_so_en18   = 1'b1;
assign n_sclk_en18 = 1'b0;
assign n_ss_en18   = 1'b0;

assign smc_hsel_int18 = smc_hsel18;
  assign ext_clk18  = 1'b0;
  assign int_source18 = {macb0_int18,macb1_int18, macb2_int18, macb3_int18,1'b0, pcm_macb_wakeup_int18, 1'b0, 1'b0, 1'b0, 1'b0, TTC_int18, GPIO_int18, UART_int18, UART_int118, SPI_int18, DMA_irq18};

  // interrupt18 even18 detect18 .
  // for sleep18 wake18 up -> any interrupt18 even18 and system not in hibernation18 (isolate_mem18 = 0)
  // for hibernate18 wake18 up -> gpio18 interrupt18 even18 and system in the hibernation18 (isolate_mem18 = 1)
  assign int_source_h18 =  ((|int_source18) && (!isolate_mem18)) || (isolate_mem18 && GPIO_int18) ;

  assign byte_sel18 = 1'b1;
  assign tie_hi_bit18 = 1'b1;

  assign smc_addr18 = smc_addr_int18[15:0];



  assign  n_gpio_bypass_oe18 = {GPIO_WIDTH18{1'b0}};        // bypass18 mode enable 
  assign  gpio_bypass_out18  = {GPIO_WIDTH18{1'b0}};
  assign  tri_state_enable18 = {GPIO_WIDTH18{1'b0}};
  assign  cpu_debug18 = 1'b0;
  assign  tie_lo_32bit18 = 32'b0;
  assign  tie_lo_2bit18  = 2'b0;
  assign  tie_lo_1bit18  = 1'b0;


ahb2apb18 #(
  32'h00800000, // Slave18 0 Address Range18
  32'h0080FFFF,

  32'h00810000, // Slave18 1 Address Range18
  32'h0081FFFF,

  32'h00820000, // Slave18 2 Address Range18 
  32'h0082FFFF,

  32'h00830000, // Slave18 3 Address Range18
  32'h0083FFFF,

  32'h00840000, // Slave18 4 Address Range18
  32'h0084FFFF,

  32'h00850000, // Slave18 5 Address Range18
  32'h0085FFFF,

  32'h00860000, // Slave18 6 Address Range18
  32'h0086FFFF,

  32'h00870000, // Slave18 7 Address Range18
  32'h0087FFFF,

  32'h00880000, // Slave18 8 Address Range18
  32'h0088FFFF
) i_ahb2apb18 (
     // AHB18 interface
    .hclk18(hclk18),         
    .hreset_n18(n_hreset18), 
    .hsel18(hsel18), 
    .haddr18(haddr18),        
    .htrans18(htrans18),       
    .hwrite18(hwrite18),       
    .hwdata18(hwdata18),       
    .hrdata18(hrdata18),   
    .hready18(hready18),   
    .hresp18(hresp18),     
    
     // APB18 interface
    .pclk18(pclk18),         
    .preset_n18(n_preset18),  
    .prdata018(prdata_spi18),
    .prdata118(prdata_uart018), 
    .prdata218(prdata_gpio18),  
    .prdata318(prdata_ttc18),   
    .prdata418(32'h0),   
    .prdata518(prdata_smc18),   
    .prdata618(prdata_pmc18),    
    .prdata718(32'h0),   
    .prdata818(prdata_uart118),  
    .pready018(pready_spi18),     
    .pready118(pready_uart018),   
    .pready218(tie_hi_bit18),     
    .pready318(tie_hi_bit18),     
    .pready418(tie_hi_bit18),     
    .pready518(tie_hi_bit18),     
    .pready618(tie_hi_bit18),     
    .pready718(tie_hi_bit18),     
    .pready818(pready_uart118),  
    .pwdata18(pwdata18),       
    .pwrite18(pwrite18),       
    .paddr18(paddr18),        
    .psel018(psel_spi18),     
    .psel118(psel_uart018),   
    .psel218(psel_gpio18),    
    .psel318(psel_ttc18),     
    .psel418(),     
    .psel518(psel_smc18),     
    .psel618(psel_pmc18),    
    .psel718(psel_apic18),   
    .psel818(psel_uart118),  
    .penable18(penable18)     
);

spi_top18 i_spi18
(
  // Wishbone18 signals18
  .wb_clk_i18(pclk18), 
  .wb_rst_i18(~n_preset18), 
  .wb_adr_i18(paddr18[4:0]), 
  .wb_dat_i18(pwdata18), 
  .wb_dat_o18(prdata_spi18), 
  .wb_sel_i18(4'b1111),    // SPI18 register accesses are always 32-bit
  .wb_we_i18(pwrite18), 
  .wb_stb_i18(psel_spi18), 
  .wb_cyc_i18(psel_spi18), 
  .wb_ack_o18(pready_spi18), 
  .wb_err_o18(), 
  .wb_int_o18(SPI_int18),

  // SPI18 signals18
  .ss_pad_o18(n_ss_out18), 
  .sclk_pad_o18(sclk_out18), 
  .mosi_pad_o18(mo18), 
  .miso_pad_i18(mi18)
);

// Opencores18 UART18 instances18
wire ua_nrts_int18;
wire ua_nrts1_int18;

assign ua_nrts18 = ua_nrts_int18;
assign ua_nrts118 = ua_nrts1_int18;

reg [3:0] uart0_sel_i18;
reg [3:0] uart1_sel_i18;
// UART18 registers are all 8-bit wide18, and their18 addresses18
// are on byte boundaries18. So18 to access them18 on the
// Wishbone18 bus, the CPU18 must do byte accesses to these18
// byte addresses18. Word18 address accesses are not possible18
// because the word18 addresses18 will be unaligned18, and cause
// a fault18.
// So18, Uart18 accesses from the CPU18 will always be 8-bit size
// We18 only have to decide18 which byte of the 4-byte word18 the
// CPU18 is interested18 in.
`ifdef SYSTEM_BIG_ENDIAN18
always @(paddr18) begin
  case (paddr18[1:0])
    2'b00 : uart0_sel_i18 = 4'b1000;
    2'b01 : uart0_sel_i18 = 4'b0100;
    2'b10 : uart0_sel_i18 = 4'b0010;
    2'b11 : uart0_sel_i18 = 4'b0001;
  endcase
end
always @(paddr18) begin
  case (paddr18[1:0])
    2'b00 : uart1_sel_i18 = 4'b1000;
    2'b01 : uart1_sel_i18 = 4'b0100;
    2'b10 : uart1_sel_i18 = 4'b0010;
    2'b11 : uart1_sel_i18 = 4'b0001;
  endcase
end
`else
always @(paddr18) begin
  case (paddr18[1:0])
    2'b00 : uart0_sel_i18 = 4'b0001;
    2'b01 : uart0_sel_i18 = 4'b0010;
    2'b10 : uart0_sel_i18 = 4'b0100;
    2'b11 : uart0_sel_i18 = 4'b1000;
  endcase
end
always @(paddr18) begin
  case (paddr18[1:0])
    2'b00 : uart1_sel_i18 = 4'b0001;
    2'b01 : uart1_sel_i18 = 4'b0010;
    2'b10 : uart1_sel_i18 = 4'b0100;
    2'b11 : uart1_sel_i18 = 4'b1000;
  endcase
end
`endif

uart_top18 i_oc_uart018 (
  .wb_clk_i18(pclk18),
  .wb_rst_i18(~n_preset18),
  .wb_adr_i18(paddr18[4:0]),
  .wb_dat_i18(pwdata18),
  .wb_dat_o18(prdata_uart018),
  .wb_we_i18(pwrite18),
  .wb_stb_i18(psel_uart018),
  .wb_cyc_i18(psel_uart018),
  .wb_ack_o18(pready_uart018),
  .wb_sel_i18(uart0_sel_i18),
  .int_o18(UART_int18),
  .stx_pad_o18(ua_txd18),
  .srx_pad_i18(ua_rxd18),
  .rts_pad_o18(ua_nrts_int18),
  .cts_pad_i18(ua_ncts18),
  .dtr_pad_o18(),
  .dsr_pad_i18(1'b0),
  .ri_pad_i18(1'b0),
  .dcd_pad_i18(1'b0)
);

uart_top18 i_oc_uart118 (
  .wb_clk_i18(pclk18),
  .wb_rst_i18(~n_preset18),
  .wb_adr_i18(paddr18[4:0]),
  .wb_dat_i18(pwdata18),
  .wb_dat_o18(prdata_uart118),
  .wb_we_i18(pwrite18),
  .wb_stb_i18(psel_uart118),
  .wb_cyc_i18(psel_uart118),
  .wb_ack_o18(pready_uart118),
  .wb_sel_i18(uart1_sel_i18),
  .int_o18(UART_int118),
  .stx_pad_o18(ua_txd118),
  .srx_pad_i18(ua_rxd118),
  .rts_pad_o18(ua_nrts1_int18),
  .cts_pad_i18(ua_ncts118),
  .dtr_pad_o18(),
  .dsr_pad_i18(1'b0),
  .ri_pad_i18(1'b0),
  .dcd_pad_i18(1'b0)
);

gpio_veneer18 i_gpio_veneer18 (
        //inputs18

        . n_p_reset18(n_preset18),
        . pclk18(pclk18),
        . psel18(psel_gpio18),
        . penable18(penable18),
        . pwrite18(pwrite18),
        . paddr18(paddr18[5:0]),
        . pwdata18(pwdata18),
        . gpio_pin_in18(gpio_pin_in18),
        . scan_en18(scan_en18),
        . tri_state_enable18(tri_state_enable18),
        . scan_in18(), //added by smarkov18 for dft18

        //outputs18
        . scan_out18(), //added by smarkov18 for dft18
        . prdata18(prdata_gpio18),
        . gpio_int18(GPIO_int18),
        . n_gpio_pin_oe18(n_gpio_pin_oe18),
        . gpio_pin_out18(gpio_pin_out18)
);


ttc_veneer18 i_ttc_veneer18 (

         //inputs18
        . n_p_reset18(n_preset18),
        . pclk18(pclk18),
        . psel18(psel_ttc18),
        . penable18(penable18),
        . pwrite18(pwrite18),
        . pwdata18(pwdata18),
        . paddr18(paddr18[7:0]),
        . scan_in18(),
        . scan_en18(scan_en18),

        //outputs18
        . prdata18(prdata_ttc18),
        . interrupt18(TTC_int18[3:1]),
        . scan_out18()
);


smc_veneer18 i_smc_veneer18 (
        //inputs18
	//apb18 inputs18
        . n_preset18(n_preset18),
        . pclk18(pclk_SRPG_smc18),
        . psel18(psel_smc18),
        . penable18(penable18),
        . pwrite18(pwrite18),
        . paddr18(paddr18[4:0]),
        . pwdata18(pwdata18),
        //ahb18 inputs18
	. hclk18(smc_hclk18),
        . n_sys_reset18(rstn_non_srpg_smc18),
        . haddr18(smc_haddr18),
        . htrans18(smc_htrans18),
        . hsel18(smc_hsel_int18),
        . hwrite18(smc_hwrite18),
	. hsize18(smc_hsize18),
        . hwdata18(smc_hwdata18),
        . hready18(smc_hready_in18),
        . data_smc18(data_smc18),

         //test signal18 inputs18

        . scan_in_118(),
        . scan_in_218(),
        . scan_in_318(),
        . scan_en18(scan_en18),

        //apb18 outputs18
        . prdata18(prdata_smc18),

       //design output

        . smc_hrdata18(smc_hrdata18),
        . smc_hready18(smc_hready18),
        . smc_hresp18(smc_hresp18),
        . smc_valid18(smc_valid18),
        . smc_addr18(smc_addr_int18),
        . smc_data18(smc_data18),
        . smc_n_be18(smc_n_be18),
        . smc_n_cs18(smc_n_cs18),
        . smc_n_wr18(smc_n_wr18),
        . smc_n_we18(smc_n_we18),
        . smc_n_rd18(smc_n_rd18),
        . smc_n_ext_oe18(smc_n_ext_oe18),
        . smc_busy18(smc_busy18),

         //test signal18 output
        . scan_out_118(),
        . scan_out_218(),
        . scan_out_318()
);

power_ctrl_veneer18 i_power_ctrl_veneer18 (
    // -- Clocks18 & Reset18
    	.pclk18(pclk18), 			//  : in  std_logic18;
    	.nprst18(n_preset18), 		//  : in  std_logic18;
    // -- APB18 programming18 interface
    	.paddr18(paddr18), 			//  : in  std_logic_vector18(31 downto18 0);
    	.psel18(psel_pmc18), 			//  : in  std_logic18;
    	.penable18(penable18), 		//  : in  std_logic18;
    	.pwrite18(pwrite18), 		//  : in  std_logic18;
    	.pwdata18(pwdata18), 		//  : in  std_logic_vector18(31 downto18 0);
    	.prdata18(prdata_pmc18), 		//  : out std_logic_vector18(31 downto18 0);
        .macb3_wakeup18(macb3_wakeup18),
        .macb2_wakeup18(macb2_wakeup18),
        .macb1_wakeup18(macb1_wakeup18),
        .macb0_wakeup18(macb0_wakeup18),
    // -- Module18 control18 outputs18
    	.scan_in18(),			//  : in  std_logic18;
    	.scan_en18(scan_en18),             	//  : in  std_logic18;
    	.scan_mode18(scan_mode18),          //  : in  std_logic18;
    	.scan_out18(),            	//  : out std_logic18;
        .int_source_h18(int_source_h18),
     	.rstn_non_srpg_smc18(rstn_non_srpg_smc18), 		//   : out std_logic18;
    	.gate_clk_smc18(gate_clk_smc18), 	//  : out std_logic18;
    	.isolate_smc18(isolate_smc18), 	//  : out std_logic18;
    	.save_edge_smc18(save_edge_smc18), 	//  : out std_logic18;
    	.restore_edge_smc18(restore_edge_smc18), 	//  : out std_logic18;
    	.pwr1_on_smc18(pwr1_on_smc18), 	//  : out std_logic18;
    	.pwr2_on_smc18(pwr2_on_smc18), 	//  : out std_logic18
     	.rstn_non_srpg_urt18(rstn_non_srpg_urt18), 		//   : out std_logic18;
    	.gate_clk_urt18(gate_clk_urt18), 	//  : out std_logic18;
    	.isolate_urt18(isolate_urt18), 	//  : out std_logic18;
    	.save_edge_urt18(save_edge_urt18), 	//  : out std_logic18;
    	.restore_edge_urt18(restore_edge_urt18), 	//  : out std_logic18;
    	.pwr1_on_urt18(pwr1_on_urt18), 	//  : out std_logic18;
    	.pwr2_on_urt18(pwr2_on_urt18),  	//  : out std_logic18
        // ETH018
        .rstn_non_srpg_macb018(rstn_non_srpg_macb018),
        .gate_clk_macb018(gate_clk_macb018),
        .isolate_macb018(isolate_macb018),
        .save_edge_macb018(save_edge_macb018),
        .restore_edge_macb018(restore_edge_macb018),
        .pwr1_on_macb018(pwr1_on_macb018),
        .pwr2_on_macb018(pwr2_on_macb018),
        // ETH118
        .rstn_non_srpg_macb118(rstn_non_srpg_macb118),
        .gate_clk_macb118(gate_clk_macb118),
        .isolate_macb118(isolate_macb118),
        .save_edge_macb118(save_edge_macb118),
        .restore_edge_macb118(restore_edge_macb118),
        .pwr1_on_macb118(pwr1_on_macb118),
        .pwr2_on_macb118(pwr2_on_macb118),
        // ETH218
        .rstn_non_srpg_macb218(rstn_non_srpg_macb218),
        .gate_clk_macb218(gate_clk_macb218),
        .isolate_macb218(isolate_macb218),
        .save_edge_macb218(save_edge_macb218),
        .restore_edge_macb218(restore_edge_macb218),
        .pwr1_on_macb218(pwr1_on_macb218),
        .pwr2_on_macb218(pwr2_on_macb218),
        // ETH318
        .rstn_non_srpg_macb318(rstn_non_srpg_macb318),
        .gate_clk_macb318(gate_clk_macb318),
        .isolate_macb318(isolate_macb318),
        .save_edge_macb318(save_edge_macb318),
        .restore_edge_macb318(restore_edge_macb318),
        .pwr1_on_macb318(pwr1_on_macb318),
        .pwr2_on_macb318(pwr2_on_macb318),
        .core06v18(core06v18),
        .core08v18(core08v18),
        .core10v18(core10v18),
        .core12v18(core12v18),
        .pcm_macb_wakeup_int18(pcm_macb_wakeup_int18),
        .isolate_mem18(isolate_mem18),
        .mte_smc_start18(mte_smc_start18),
        .mte_uart_start18(mte_uart_start18),
        .mte_smc_uart_start18(mte_smc_uart_start18),  
        .mte_pm_smc_to_default_start18(mte_pm_smc_to_default_start18), 
        .mte_pm_uart_to_default_start18(mte_pm_uart_to_default_start18),
        .mte_pm_smc_uart_to_default_start18(mte_pm_smc_uart_to_default_start18)
);

// Clock18 gating18 macro18 to shut18 off18 clocks18 to the SRPG18 flops18 in the SMC18
//CKLNQD118 i_SMC_SRPG_clk_gate18  (
//	.TE18(scan_mode18), 
//	.E18(~gate_clk_smc18), 
//	.CP18(pclk18), 
//	.Q18(pclk_SRPG_smc18)
//	);
// Replace18 gate18 with behavioural18 code18 //
wire 	smc_scan_gate18;
reg 	smc_latched_enable18;
assign smc_scan_gate18 = scan_mode18 ? 1'b1 : ~gate_clk_smc18;

always @ (pclk18 or smc_scan_gate18)
  	if (pclk18 == 1'b0) begin
  		smc_latched_enable18 <= smc_scan_gate18;
  	end  	
	
assign pclk_SRPG_smc18 = smc_latched_enable18 ? pclk18 : 1'b0;


// Clock18 gating18 macro18 to shut18 off18 clocks18 to the SRPG18 flops18 in the URT18
//CKLNQD118 i_URT_SRPG_clk_gate18  (
//	.TE18(scan_mode18), 
//	.E18(~gate_clk_urt18), 
//	.CP18(pclk18), 
//	.Q18(pclk_SRPG_urt18)
//	);
// Replace18 gate18 with behavioural18 code18 //
wire 	urt_scan_gate18;
reg 	urt_latched_enable18;
assign urt_scan_gate18 = scan_mode18 ? 1'b1 : ~gate_clk_urt18;

always @ (pclk18 or urt_scan_gate18)
  	if (pclk18 == 1'b0) begin
  		urt_latched_enable18 <= urt_scan_gate18;
  	end  	
	
assign pclk_SRPG_urt18 = urt_latched_enable18 ? pclk18 : 1'b0;

// ETH018
wire 	macb0_scan_gate18;
reg 	macb0_latched_enable18;
assign macb0_scan_gate18 = scan_mode18 ? 1'b1 : ~gate_clk_macb018;

always @ (pclk18 or macb0_scan_gate18)
  	if (pclk18 == 1'b0) begin
  		macb0_latched_enable18 <= macb0_scan_gate18;
  	end  	
	
assign clk_SRPG_macb0_en18 = macb0_latched_enable18 ? 1'b1 : 1'b0;

// ETH118
wire 	macb1_scan_gate18;
reg 	macb1_latched_enable18;
assign macb1_scan_gate18 = scan_mode18 ? 1'b1 : ~gate_clk_macb118;

always @ (pclk18 or macb1_scan_gate18)
  	if (pclk18 == 1'b0) begin
  		macb1_latched_enable18 <= macb1_scan_gate18;
  	end  	
	
assign clk_SRPG_macb1_en18 = macb1_latched_enable18 ? 1'b1 : 1'b0;

// ETH218
wire 	macb2_scan_gate18;
reg 	macb2_latched_enable18;
assign macb2_scan_gate18 = scan_mode18 ? 1'b1 : ~gate_clk_macb218;

always @ (pclk18 or macb2_scan_gate18)
  	if (pclk18 == 1'b0) begin
  		macb2_latched_enable18 <= macb2_scan_gate18;
  	end  	
	
assign clk_SRPG_macb2_en18 = macb2_latched_enable18 ? 1'b1 : 1'b0;

// ETH318
wire 	macb3_scan_gate18;
reg 	macb3_latched_enable18;
assign macb3_scan_gate18 = scan_mode18 ? 1'b1 : ~gate_clk_macb318;

always @ (pclk18 or macb3_scan_gate18)
  	if (pclk18 == 1'b0) begin
  		macb3_latched_enable18 <= macb3_scan_gate18;
  	end  	
	
assign clk_SRPG_macb3_en18 = macb3_latched_enable18 ? 1'b1 : 1'b0;



`else
//------------------------------------------------------------------------------
// if the APB18 subsystem18 is black18 boxed18 
//------------------------------------------------------------------------------
// wire s ports18
    // system signals18
    wire         hclk18;     // AHB18 Clock18
    wire         n_hreset18;  // AHB18 reset - Active18 low18
    wire         pclk18;     // APB18 Clock18. 
    wire         n_preset18;  // APB18 reset - Active18 low18

    // AHB18 interface
    wire         ahb2apb0_hsel18;     // AHB2APB18 select18
    wire  [31:0] haddr18;    // Address bus
    wire  [1:0]  htrans18;   // Transfer18 type
    wire  [2:0]  hsize18;    // AHB18 Access type - byte, half18-word18, word18
    wire  [31:0] hwdata18;   // Write data
    wire         hwrite18;   // Write signal18/
    wire         hready_in18;// Indicates18 that last master18 has finished18 bus access
    wire [2:0]   hburst18;     // Burst type
    wire [3:0]   hprot18;      // Protection18 control18
    wire [3:0]   hmaster18;    // Master18 select18
    wire         hmastlock18;  // Locked18 transfer18
  // Interrupts18 from the Enet18 MACs18
    wire         macb0_int18;
    wire         macb1_int18;
    wire         macb2_int18;
    wire         macb3_int18;
  // Interrupt18 from the DMA18
    wire         DMA_irq18;
  // Scan18 wire s
    wire         scan_en18;    // Scan18 enable pin18
    wire         scan_in_118;  // Scan18 wire  for first chain18
    wire         scan_in_218;  // Scan18 wire  for second chain18
    wire         scan_mode18;  // test mode pin18
 
  //wire  for smc18 AHB18 interface
    wire         smc_hclk18;
    wire         smc_n_hclk18;
    wire  [31:0] smc_haddr18;
    wire  [1:0]  smc_htrans18;
    wire         smc_hsel18;
    wire         smc_hwrite18;
    wire  [2:0]  smc_hsize18;
    wire  [31:0] smc_hwdata18;
    wire         smc_hready_in18;
    wire  [2:0]  smc_hburst18;     // Burst type
    wire  [3:0]  smc_hprot18;      // Protection18 control18
    wire  [3:0]  smc_hmaster18;    // Master18 select18
    wire         smc_hmastlock18;  // Locked18 transfer18


    wire  [31:0] data_smc18;     // EMI18(External18 memory) read data
    
  //wire s for uart18
    wire         ua_rxd18;       // UART18 receiver18 serial18 wire  pin18
    wire         ua_rxd118;      // UART18 receiver18 serial18 wire  pin18
    wire         ua_ncts18;      // Clear-To18-Send18 flow18 control18
    wire         ua_ncts118;      // Clear-To18-Send18 flow18 control18
   //wire s for spi18
    wire         n_ss_in18;      // select18 wire  to slave18
    wire         mi18;           // data wire  to master18
    wire         si18;           // data wire  to slave18
    wire         sclk_in18;      // clock18 wire  to slave18
  //wire s for GPIO18
   wire  [GPIO_WIDTH18-1:0]  gpio_pin_in18;             // wire  data from pin18

  //reg    ports18
  // Scan18 reg   s
   reg           scan_out_118;   // Scan18 out for chain18 1
   reg           scan_out_218;   // Scan18 out for chain18 2
  //AHB18 interface 
   reg    [31:0] hrdata18;       // Read data provided from target slave18
   reg           hready18;       // Ready18 for new bus cycle from target slave18
   reg    [1:0]  hresp18;       // Response18 from the bridge18

   // SMC18 reg    for AHB18 interface
   reg    [31:0]    smc_hrdata18;
   reg              smc_hready18;
   reg    [1:0]     smc_hresp18;

  //reg   s from smc18
   reg    [15:0]    smc_addr18;      // External18 Memory (EMI18) address
   reg    [3:0]     smc_n_be18;      // EMI18 byte enables18 (Active18 LOW18)
   reg    [7:0]     smc_n_cs18;      // EMI18 Chip18 Selects18 (Active18 LOW18)
   reg    [3:0]     smc_n_we18;      // EMI18 write strobes18 (Active18 LOW18)
   reg              smc_n_wr18;      // EMI18 write enable (Active18 LOW18)
   reg              smc_n_rd18;      // EMI18 read stobe18 (Active18 LOW18)
   reg              smc_n_ext_oe18;  // EMI18 write data reg    enable
   reg    [31:0]    smc_data18;      // EMI18 write data
  //reg   s from uart18
   reg           ua_txd18;       	// UART18 transmitter18 serial18 reg   
   reg           ua_txd118;       // UART18 transmitter18 serial18 reg   
   reg           ua_nrts18;      	// Request18-To18-Send18 flow18 control18
   reg           ua_nrts118;      // Request18-To18-Send18 flow18 control18
   // reg   s from ttc18
  // reg   s from SPI18
   reg       so;                    // data reg    from slave18
   reg       mo18;                    // data reg    from master18
   reg       sclk_out18;              // clock18 reg    from master18
   reg    [P_SIZE18-1:0] n_ss_out18;    // peripheral18 select18 lines18 from master18
   reg       n_so_en18;               // out enable for slave18 data
   reg       n_mo_en18;               // out enable for master18 data
   reg       n_sclk_en18;             // out enable for master18 clock18
   reg       n_ss_en18;               // out enable for master18 peripheral18 lines18
  //reg   s from gpio18
   reg    [GPIO_WIDTH18-1:0]     n_gpio_pin_oe18;           // reg    enable signal18 to pin18
   reg    [GPIO_WIDTH18-1:0]     gpio_pin_out18;            // reg    signal18 to pin18


`endif
//------------------------------------------------------------------------------
// black18 boxed18 defines18 
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// APB18 and AHB18 interface formal18 verification18 monitors18
//------------------------------------------------------------------------------
`ifdef ABV_ON18
apb_assert18 i_apb_assert18 (

        // APB18 signals18
  	.n_preset18(n_preset18),
   	.pclk18(pclk18),
	.penable18(penable18),
	.paddr18(paddr18),
	.pwrite18(pwrite18),
	.pwdata18(pwdata18),

	.psel0018(psel_spi18),
	.psel0118(psel_uart018),
	.psel0218(psel_gpio18),
	.psel0318(psel_ttc18),
	.psel0418(1'b0),
	.psel0518(psel_smc18),
	.psel0618(1'b0),
	.psel0718(1'b0),
	.psel0818(1'b0),
	.psel0918(1'b0),
	.psel1018(1'b0),
	.psel1118(1'b0),
	.psel1218(1'b0),
	.psel1318(psel_pmc18),
	.psel1418(psel_apic18),
	.psel1518(psel_uart118),

        .prdata0018(prdata_spi18),
        .prdata0118(prdata_uart018), // Read Data from peripheral18 UART18 
        .prdata0218(prdata_gpio18), // Read Data from peripheral18 GPIO18
        .prdata0318(prdata_ttc18), // Read Data from peripheral18 TTC18
        .prdata0418(32'b0), // 
        .prdata0518(prdata_smc18), // Read Data from peripheral18 SMC18
        .prdata1318(prdata_pmc18), // Read Data from peripheral18 Power18 Control18 Block
   	.prdata1418(32'b0), // 
        .prdata1518(prdata_uart118),


        // AHB18 signals18
        .hclk18(hclk18),         // ahb18 system clock18
        .n_hreset18(n_hreset18), // ahb18 system reset

        // ahb2apb18 signals18
        .hresp18(hresp18),
        .hready18(hready18),
        .hrdata18(hrdata18),
        .hwdata18(hwdata18),
        .hprot18(hprot18),
        .hburst18(hburst18),
        .hsize18(hsize18),
        .hwrite18(hwrite18),
        .htrans18(htrans18),
        .haddr18(haddr18),
        .ahb2apb_hsel18(ahb2apb0_hsel18));



//------------------------------------------------------------------------------
// AHB18 interface formal18 verification18 monitor18
//------------------------------------------------------------------------------
defparam i_ahbSlaveMonitor18.DBUS_WIDTH18 = 32;
defparam i_ahbMasterMonitor18.DBUS_WIDTH18 = 32;


// AHB2APB18 Bridge18

    ahb_liteslave_monitor18 i_ahbSlaveMonitor18 (
        .hclk_i18(hclk18),
        .hresetn_i18(n_hreset18),
        .hresp18(hresp18),
        .hready18(hready18),
        .hready_global_i18(hready18),
        .hrdata18(hrdata18),
        .hwdata_i18(hwdata18),
        .hburst_i18(hburst18),
        .hsize_i18(hsize18),
        .hwrite_i18(hwrite18),
        .htrans_i18(htrans18),
        .haddr_i18(haddr18),
        .hsel_i18(ahb2apb0_hsel18)
    );


  ahb_litemaster_monitor18 i_ahbMasterMonitor18 (
          .hclk_i18(hclk18),
          .hresetn_i18(n_hreset18),
          .hresp_i18(hresp18),
          .hready_i18(hready18),
          .hrdata_i18(hrdata18),
          .hlock18(1'b0),
          .hwdata18(hwdata18),
          .hprot18(hprot18),
          .hburst18(hburst18),
          .hsize18(hsize18),
          .hwrite18(hwrite18),
          .htrans18(htrans18),
          .haddr18(haddr18)
          );







`endif




`ifdef IFV_LP_ABV_ON18
// power18 control18
wire isolate18;

// testbench mirror signals18
wire L1_ctrl_access18;
wire L1_status_access18;

wire [31:0] L1_status_reg18;
wire [31:0] L1_ctrl_reg18;

//wire rstn_non_srpg_urt18;
//wire isolate_urt18;
//wire retain_urt18;
//wire gate_clk_urt18;
//wire pwr1_on_urt18;


// smc18 signals18
wire [31:0] smc_prdata18;
wire lp_clk_smc18;
                    

// uart18 isolation18 register
  wire [15:0] ua_prdata18;
  wire ua_int18;
  assign ua_prdata18          =  i_uart1_veneer18.prdata18;
  assign ua_int18             =  i_uart1_veneer18.ua_int18;


assign lp_clk_smc18          = i_smc_veneer18.pclk18;
assign smc_prdata18          = i_smc_veneer18.prdata18;
lp_chk_smc18 u_lp_chk_smc18 (
    .clk18 (hclk18),
    .rst18 (n_hreset18),
    .iso_smc18 (isolate_smc18),
    .gate_clk18 (gate_clk_smc18),
    .lp_clk18 (pclk_SRPG_smc18),

    // srpg18 outputs18
    .smc_hrdata18 (smc_hrdata18),
    .smc_hready18 (smc_hready18),
    .smc_hresp18  (smc_hresp18),
    .smc_valid18 (smc_valid18),
    .smc_addr_int18 (smc_addr_int18),
    .smc_data18 (smc_data18),
    .smc_n_be18 (smc_n_be18),
    .smc_n_cs18  (smc_n_cs18),
    .smc_n_wr18 (smc_n_wr18),
    .smc_n_we18 (smc_n_we18),
    .smc_n_rd18 (smc_n_rd18),
    .smc_n_ext_oe18 (smc_n_ext_oe18)
   );

// lp18 retention18/isolation18 assertions18
lp_chk_uart18 u_lp_chk_urt18 (

  .clk18         (hclk18),
  .rst18         (n_hreset18),
  .iso_urt18     (isolate_urt18),
  .gate_clk18    (gate_clk_urt18),
  .lp_clk18      (pclk_SRPG_urt18),
  //ports18
  .prdata18 (ua_prdata18),
  .ua_int18 (ua_int18),
  .ua_txd18 (ua_txd118),
  .ua_nrts18 (ua_nrts118)
 );

`endif  //IFV_LP_ABV_ON18




endmodule
