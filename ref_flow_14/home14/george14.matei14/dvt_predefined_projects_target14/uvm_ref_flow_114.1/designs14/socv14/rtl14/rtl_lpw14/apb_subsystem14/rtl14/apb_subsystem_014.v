//File14 name   : apb_subsystem_014.v
//Title14       : 
//Created14     : 1999
//Description14 : 
//Notes14       : 
//----------------------------------------------------------------------
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------

module apb_subsystem_014(
    // AHB14 interface
    hclk14,
    n_hreset14,
    hsel14,
    haddr14,
    htrans14,
    hsize14,
    hwrite14,
    hwdata14,
    hready_in14,
    hburst14,
    hprot14,
    hmaster14,
    hmastlock14,
    hrdata14,
    hready14,
    hresp14,
    
    // APB14 system interface
    pclk14,
    n_preset14,
    
    // SPI14 ports14
    n_ss_in14,
    mi14,
    si14,
    sclk_in14,
    so,
    mo14,
    sclk_out14,
    n_ss_out14,
    n_so_en14,
    n_mo_en14,
    n_sclk_en14,
    n_ss_en14,
    
    //UART014 ports14
    ua_rxd14,
    ua_ncts14,
    ua_txd14,
    ua_nrts14,
    
    //UART114 ports14
    ua_rxd114,
    ua_ncts114,
    ua_txd114,
    ua_nrts114,
    
    //GPIO14 ports14
    gpio_pin_in14,
    n_gpio_pin_oe14,
    gpio_pin_out14,
    

    //SMC14 ports14
    smc_hclk14,
    smc_n_hclk14,
    smc_haddr14,
    smc_htrans14,
    smc_hsel14,
    smc_hwrite14,
    smc_hsize14,
    smc_hwdata14,
    smc_hready_in14,
    smc_hburst14,
    smc_hprot14,
    smc_hmaster14,
    smc_hmastlock14,
    smc_hrdata14, 
    smc_hready14,
    smc_hresp14,
    smc_n_ext_oe14,
    smc_data14,
    smc_addr14,
    smc_n_be14,
    smc_n_cs14, 
    smc_n_we14,
    smc_n_wr14,
    smc_n_rd14,
    data_smc14,
    
    //PMC14 ports14
    clk_SRPG_macb0_en14,
    clk_SRPG_macb1_en14,
    clk_SRPG_macb2_en14,
    clk_SRPG_macb3_en14,
    core06v14,
    core08v14,
    core10v14,
    core12v14,
    macb3_wakeup14,
    macb2_wakeup14,
    macb1_wakeup14,
    macb0_wakeup14,
    mte_smc_start14,
    mte_uart_start14,
    mte_smc_uart_start14,  
    mte_pm_smc_to_default_start14, 
    mte_pm_uart_to_default_start14,
    mte_pm_smc_uart_to_default_start14,
    
    
    // Peripheral14 inerrupts14
    pcm_irq14,
    ttc_irq14,
    gpio_irq14,
    uart0_irq14,
    uart1_irq14,
    spi_irq14,
    DMA_irq14,      
    macb0_int14,
    macb1_int14,
    macb2_int14,
    macb3_int14,
   
    // Scan14 ports14
    scan_en14,      // Scan14 enable pin14
    scan_in_114,    // Scan14 input for first chain14
    scan_in_214,    // Scan14 input for second chain14
    scan_mode14,
    scan_out_114,   // Scan14 out for chain14 1
    scan_out_214    // Scan14 out for chain14 2
);

parameter GPIO_WIDTH14 = 16;        // GPIO14 width
parameter P_SIZE14 =   8;              // number14 of peripheral14 select14 lines14
parameter NO_OF_IRQS14  = 17;      //No of irqs14 read by apic14 

// AHB14 interface
input         hclk14;     // AHB14 Clock14
input         n_hreset14;  // AHB14 reset - Active14 low14
input         hsel14;     // AHB2APB14 select14
input [31:0]  haddr14;    // Address bus
input [1:0]   htrans14;   // Transfer14 type
input [2:0]   hsize14;    // AHB14 Access type - byte, half14-word14, word14
input [31:0]  hwdata14;   // Write data
input         hwrite14;   // Write signal14/
input         hready_in14;// Indicates14 that last master14 has finished14 bus access
input [2:0]   hburst14;     // Burst type
input [3:0]   hprot14;      // Protection14 control14
input [3:0]   hmaster14;    // Master14 select14
input         hmastlock14;  // Locked14 transfer14
output [31:0] hrdata14;       // Read data provided from target slave14
output        hready14;       // Ready14 for new bus cycle from target slave14
output [1:0]  hresp14;       // Response14 from the bridge14
    
// APB14 system interface
input         pclk14;     // APB14 Clock14. 
input         n_preset14;  // APB14 reset - Active14 low14
   
// SPI14 ports14
input     n_ss_in14;      // select14 input to slave14
input     mi14;           // data input to master14
input     si14;           // data input to slave14
input     sclk_in14;      // clock14 input to slave14
output    so;                    // data output from slave14
output    mo14;                    // data output from master14
output    sclk_out14;              // clock14 output from master14
output [P_SIZE14-1:0] n_ss_out14;    // peripheral14 select14 lines14 from master14
output    n_so_en14;               // out enable for slave14 data
output    n_mo_en14;               // out enable for master14 data
output    n_sclk_en14;             // out enable for master14 clock14
output    n_ss_en14;               // out enable for master14 peripheral14 lines14

//UART014 ports14
input        ua_rxd14;       // UART14 receiver14 serial14 input pin14
input        ua_ncts14;      // Clear-To14-Send14 flow14 control14
output       ua_txd14;       	// UART14 transmitter14 serial14 output
output       ua_nrts14;      	// Request14-To14-Send14 flow14 control14

// UART114 ports14   
input        ua_rxd114;      // UART14 receiver14 serial14 input pin14
input        ua_ncts114;      // Clear-To14-Send14 flow14 control14
output       ua_txd114;       // UART14 transmitter14 serial14 output
output       ua_nrts114;      // Request14-To14-Send14 flow14 control14

//GPIO14 ports14
input [GPIO_WIDTH14-1:0]      gpio_pin_in14;             // input data from pin14
output [GPIO_WIDTH14-1:0]     n_gpio_pin_oe14;           // output enable signal14 to pin14
output [GPIO_WIDTH14-1:0]     gpio_pin_out14;            // output signal14 to pin14
  
//SMC14 ports14
input        smc_hclk14;
input        smc_n_hclk14;
input [31:0] smc_haddr14;
input [1:0]  smc_htrans14;
input        smc_hsel14;
input        smc_hwrite14;
input [2:0]  smc_hsize14;
input [31:0] smc_hwdata14;
input        smc_hready_in14;
input [2:0]  smc_hburst14;     // Burst type
input [3:0]  smc_hprot14;      // Protection14 control14
input [3:0]  smc_hmaster14;    // Master14 select14
input        smc_hmastlock14;  // Locked14 transfer14
input [31:0] data_smc14;     // EMI14(External14 memory) read data
output [31:0]    smc_hrdata14;
output           smc_hready14;
output [1:0]     smc_hresp14;
output [15:0]    smc_addr14;      // External14 Memory (EMI14) address
output [3:0]     smc_n_be14;      // EMI14 byte enables14 (Active14 LOW14)
output           smc_n_cs14;      // EMI14 Chip14 Selects14 (Active14 LOW14)
output [3:0]     smc_n_we14;      // EMI14 write strobes14 (Active14 LOW14)
output           smc_n_wr14;      // EMI14 write enable (Active14 LOW14)
output           smc_n_rd14;      // EMI14 read stobe14 (Active14 LOW14)
output           smc_n_ext_oe14;  // EMI14 write data output enable
output [31:0]    smc_data14;      // EMI14 write data
       
//PMC14 ports14
output clk_SRPG_macb0_en14;
output clk_SRPG_macb1_en14;
output clk_SRPG_macb2_en14;
output clk_SRPG_macb3_en14;
output core06v14;
output core08v14;
output core10v14;
output core12v14;
output mte_smc_start14;
output mte_uart_start14;
output mte_smc_uart_start14;  
output mte_pm_smc_to_default_start14; 
output mte_pm_uart_to_default_start14;
output mte_pm_smc_uart_to_default_start14;
input macb3_wakeup14;
input macb2_wakeup14;
input macb1_wakeup14;
input macb0_wakeup14;
    

// Peripheral14 interrupts14
output pcm_irq14;
output [2:0] ttc_irq14;
output gpio_irq14;
output uart0_irq14;
output uart1_irq14;
output spi_irq14;
input        macb0_int14;
input        macb1_int14;
input        macb2_int14;
input        macb3_int14;
input        DMA_irq14;
  
//Scan14 ports14
input        scan_en14;    // Scan14 enable pin14
input        scan_in_114;  // Scan14 input for first chain14
input        scan_in_214;  // Scan14 input for second chain14
input        scan_mode14;  // test mode pin14
 output        scan_out_114;   // Scan14 out for chain14 1
 output        scan_out_214;   // Scan14 out for chain14 2  

//------------------------------------------------------------------------------
// if the ROM14 subsystem14 is NOT14 black14 boxed14 
//------------------------------------------------------------------------------
`ifndef FV_KIT_BLACK_BOX_APB_SUBSYSTEM14
   
   wire        hsel14; 
   wire        pclk14;
   wire        n_preset14;
   wire [31:0] prdata_spi14;
   wire [31:0] prdata_uart014;
   wire [31:0] prdata_gpio14;
   wire [31:0] prdata_ttc14;
   wire [31:0] prdata_smc14;
   wire [31:0] prdata_pmc14;
   wire [31:0] prdata_uart114;
   wire        pready_spi14;
   wire        pready_uart014;
   wire        pready_uart114;
   wire        tie_hi_bit14;
   wire  [31:0] hrdata14; 
   wire         hready14;
   wire         hready_in14;
   wire  [1:0]  hresp14;   
   wire  [31:0] pwdata14;  
   wire         pwrite14;
   wire  [31:0] paddr14;  
   wire   psel_spi14;
   wire   psel_uart014;
   wire   psel_gpio14;
   wire   psel_ttc14;
   wire   psel_smc14;
   wire   psel0714;
   wire   psel0814;
   wire   psel0914;
   wire   psel1014;
   wire   psel1114;
   wire   psel1214;
   wire   psel_pmc14;
   wire   psel_uart114;
   wire   penable14;
   wire   [NO_OF_IRQS14:0] int_source14;     // System14 Interrupt14 Sources14
   wire [1:0]             smc_hresp14;     // AHB14 Response14 signal14
   wire                   smc_valid14;     // Ack14 valid address

  //External14 memory interface (EMI14)
  wire [31:0]            smc_addr_int14;  // External14 Memory (EMI14) address
  wire [3:0]             smc_n_be14;      // EMI14 byte enables14 (Active14 LOW14)
  wire                   smc_n_cs14;      // EMI14 Chip14 Selects14 (Active14 LOW14)
  wire [3:0]             smc_n_we14;      // EMI14 write strobes14 (Active14 LOW14)
  wire                   smc_n_wr14;      // EMI14 write enable (Active14 LOW14)
  wire                   smc_n_rd14;      // EMI14 read stobe14 (Active14 LOW14)
 
  //AHB14 Memory Interface14 Control14
  wire                   smc_hsel_int14;
  wire                   smc_busy14;      // smc14 busy
   

//scan14 signals14

   wire                scan_in_114;        //scan14 input
   wire                scan_in_214;        //scan14 input
   wire                scan_en14;         //scan14 enable
   wire                scan_out_114;       //scan14 output
   wire                scan_out_214;       //scan14 output
   wire                byte_sel14;     // byte select14 from bridge14 1=byte, 0=2byte
   wire                UART_int14;     // UART14 module interrupt14 
   wire                ua_uclken14;    // Soft14 control14 of clock14
   wire                UART_int114;     // UART14 module interrupt14 
   wire                ua_uclken114;    // Soft14 control14 of clock14
   wire  [3:1]         TTC_int14;            //Interrupt14 from PCI14 
  // inputs14 to SPI14 
   wire    ext_clk14;                // external14 clock14
   wire    SPI_int14;             // interrupt14 request
  // outputs14 from SPI14
   wire    slave_out_clk14;         // modified slave14 clock14 output
 // gpio14 generic14 inputs14 
   wire  [GPIO_WIDTH14-1:0]   n_gpio_bypass_oe14;        // bypass14 mode enable 
   wire  [GPIO_WIDTH14-1:0]   gpio_bypass_out14;         // bypass14 mode output value 
   wire  [GPIO_WIDTH14-1:0]   tri_state_enable14;   // disables14 op enable -> z 
 // outputs14 
   //amba14 outputs14 
   // gpio14 generic14 outputs14 
   wire       GPIO_int14;                // gpio_interupt14 for input pin14 change 
   wire [GPIO_WIDTH14-1:0]     gpio_bypass_in14;          // bypass14 mode input data value  
                
   wire           cpu_debug14;        // Inhibits14 watchdog14 counter 
   wire            ex_wdz_n14;         // External14 Watchdog14 zero indication14
   wire           rstn_non_srpg_smc14; 
   wire           rstn_non_srpg_urt14;
   wire           isolate_smc14;
   wire           save_edge_smc14;
   wire           restore_edge_smc14;
   wire           save_edge_urt14;
   wire           restore_edge_urt14;
   wire           pwr1_on_smc14;
   wire           pwr2_on_smc14;
   wire           pwr1_on_urt14;
   wire           pwr2_on_urt14;
   // ETH014
   wire            rstn_non_srpg_macb014;
   wire            gate_clk_macb014;
   wire            isolate_macb014;
   wire            save_edge_macb014;
   wire            restore_edge_macb014;
   wire            pwr1_on_macb014;
   wire            pwr2_on_macb014;
   // ETH114
   wire            rstn_non_srpg_macb114;
   wire            gate_clk_macb114;
   wire            isolate_macb114;
   wire            save_edge_macb114;
   wire            restore_edge_macb114;
   wire            pwr1_on_macb114;
   wire            pwr2_on_macb114;
   // ETH214
   wire            rstn_non_srpg_macb214;
   wire            gate_clk_macb214;
   wire            isolate_macb214;
   wire            save_edge_macb214;
   wire            restore_edge_macb214;
   wire            pwr1_on_macb214;
   wire            pwr2_on_macb214;
   // ETH314
   wire            rstn_non_srpg_macb314;
   wire            gate_clk_macb314;
   wire            isolate_macb314;
   wire            save_edge_macb314;
   wire            restore_edge_macb314;
   wire            pwr1_on_macb314;
   wire            pwr2_on_macb314;


   wire           pclk_SRPG_smc14;
   wire           pclk_SRPG_urt14;
   wire           gate_clk_smc14;
   wire           gate_clk_urt14;
   wire  [31:0]   tie_lo_32bit14; 
   wire  [1:0]	  tie_lo_2bit14;
   wire  	  tie_lo_1bit14;
   wire           pcm_macb_wakeup_int14;
   wire           int_source_h14;
   wire           isolate_mem14;

assign pcm_irq14 = pcm_macb_wakeup_int14;
assign ttc_irq14[2] = TTC_int14[3];
assign ttc_irq14[1] = TTC_int14[2];
assign ttc_irq14[0] = TTC_int14[1];
assign gpio_irq14 = GPIO_int14;
assign uart0_irq14 = UART_int14;
assign uart1_irq14 = UART_int114;
assign spi_irq14 = SPI_int14;

assign n_mo_en14   = 1'b0;
assign n_so_en14   = 1'b1;
assign n_sclk_en14 = 1'b0;
assign n_ss_en14   = 1'b0;

assign smc_hsel_int14 = smc_hsel14;
  assign ext_clk14  = 1'b0;
  assign int_source14 = {macb0_int14,macb1_int14, macb2_int14, macb3_int14,1'b0, pcm_macb_wakeup_int14, 1'b0, 1'b0, 1'b0, 1'b0, TTC_int14, GPIO_int14, UART_int14, UART_int114, SPI_int14, DMA_irq14};

  // interrupt14 even14 detect14 .
  // for sleep14 wake14 up -> any interrupt14 even14 and system not in hibernation14 (isolate_mem14 = 0)
  // for hibernate14 wake14 up -> gpio14 interrupt14 even14 and system in the hibernation14 (isolate_mem14 = 1)
  assign int_source_h14 =  ((|int_source14) && (!isolate_mem14)) || (isolate_mem14 && GPIO_int14) ;

  assign byte_sel14 = 1'b1;
  assign tie_hi_bit14 = 1'b1;

  assign smc_addr14 = smc_addr_int14[15:0];



  assign  n_gpio_bypass_oe14 = {GPIO_WIDTH14{1'b0}};        // bypass14 mode enable 
  assign  gpio_bypass_out14  = {GPIO_WIDTH14{1'b0}};
  assign  tri_state_enable14 = {GPIO_WIDTH14{1'b0}};
  assign  cpu_debug14 = 1'b0;
  assign  tie_lo_32bit14 = 32'b0;
  assign  tie_lo_2bit14  = 2'b0;
  assign  tie_lo_1bit14  = 1'b0;


ahb2apb14 #(
  32'h00800000, // Slave14 0 Address Range14
  32'h0080FFFF,

  32'h00810000, // Slave14 1 Address Range14
  32'h0081FFFF,

  32'h00820000, // Slave14 2 Address Range14 
  32'h0082FFFF,

  32'h00830000, // Slave14 3 Address Range14
  32'h0083FFFF,

  32'h00840000, // Slave14 4 Address Range14
  32'h0084FFFF,

  32'h00850000, // Slave14 5 Address Range14
  32'h0085FFFF,

  32'h00860000, // Slave14 6 Address Range14
  32'h0086FFFF,

  32'h00870000, // Slave14 7 Address Range14
  32'h0087FFFF,

  32'h00880000, // Slave14 8 Address Range14
  32'h0088FFFF
) i_ahb2apb14 (
     // AHB14 interface
    .hclk14(hclk14),         
    .hreset_n14(n_hreset14), 
    .hsel14(hsel14), 
    .haddr14(haddr14),        
    .htrans14(htrans14),       
    .hwrite14(hwrite14),       
    .hwdata14(hwdata14),       
    .hrdata14(hrdata14),   
    .hready14(hready14),   
    .hresp14(hresp14),     
    
     // APB14 interface
    .pclk14(pclk14),         
    .preset_n14(n_preset14),  
    .prdata014(prdata_spi14),
    .prdata114(prdata_uart014), 
    .prdata214(prdata_gpio14),  
    .prdata314(prdata_ttc14),   
    .prdata414(32'h0),   
    .prdata514(prdata_smc14),   
    .prdata614(prdata_pmc14),    
    .prdata714(32'h0),   
    .prdata814(prdata_uart114),  
    .pready014(pready_spi14),     
    .pready114(pready_uart014),   
    .pready214(tie_hi_bit14),     
    .pready314(tie_hi_bit14),     
    .pready414(tie_hi_bit14),     
    .pready514(tie_hi_bit14),     
    .pready614(tie_hi_bit14),     
    .pready714(tie_hi_bit14),     
    .pready814(pready_uart114),  
    .pwdata14(pwdata14),       
    .pwrite14(pwrite14),       
    .paddr14(paddr14),        
    .psel014(psel_spi14),     
    .psel114(psel_uart014),   
    .psel214(psel_gpio14),    
    .psel314(psel_ttc14),     
    .psel414(),     
    .psel514(psel_smc14),     
    .psel614(psel_pmc14),    
    .psel714(psel_apic14),   
    .psel814(psel_uart114),  
    .penable14(penable14)     
);

spi_top14 i_spi14
(
  // Wishbone14 signals14
  .wb_clk_i14(pclk14), 
  .wb_rst_i14(~n_preset14), 
  .wb_adr_i14(paddr14[4:0]), 
  .wb_dat_i14(pwdata14), 
  .wb_dat_o14(prdata_spi14), 
  .wb_sel_i14(4'b1111),    // SPI14 register accesses are always 32-bit
  .wb_we_i14(pwrite14), 
  .wb_stb_i14(psel_spi14), 
  .wb_cyc_i14(psel_spi14), 
  .wb_ack_o14(pready_spi14), 
  .wb_err_o14(), 
  .wb_int_o14(SPI_int14),

  // SPI14 signals14
  .ss_pad_o14(n_ss_out14), 
  .sclk_pad_o14(sclk_out14), 
  .mosi_pad_o14(mo14), 
  .miso_pad_i14(mi14)
);

// Opencores14 UART14 instances14
wire ua_nrts_int14;
wire ua_nrts1_int14;

assign ua_nrts14 = ua_nrts_int14;
assign ua_nrts114 = ua_nrts1_int14;

reg [3:0] uart0_sel_i14;
reg [3:0] uart1_sel_i14;
// UART14 registers are all 8-bit wide14, and their14 addresses14
// are on byte boundaries14. So14 to access them14 on the
// Wishbone14 bus, the CPU14 must do byte accesses to these14
// byte addresses14. Word14 address accesses are not possible14
// because the word14 addresses14 will be unaligned14, and cause
// a fault14.
// So14, Uart14 accesses from the CPU14 will always be 8-bit size
// We14 only have to decide14 which byte of the 4-byte word14 the
// CPU14 is interested14 in.
`ifdef SYSTEM_BIG_ENDIAN14
always @(paddr14) begin
  case (paddr14[1:0])
    2'b00 : uart0_sel_i14 = 4'b1000;
    2'b01 : uart0_sel_i14 = 4'b0100;
    2'b10 : uart0_sel_i14 = 4'b0010;
    2'b11 : uart0_sel_i14 = 4'b0001;
  endcase
end
always @(paddr14) begin
  case (paddr14[1:0])
    2'b00 : uart1_sel_i14 = 4'b1000;
    2'b01 : uart1_sel_i14 = 4'b0100;
    2'b10 : uart1_sel_i14 = 4'b0010;
    2'b11 : uart1_sel_i14 = 4'b0001;
  endcase
end
`else
always @(paddr14) begin
  case (paddr14[1:0])
    2'b00 : uart0_sel_i14 = 4'b0001;
    2'b01 : uart0_sel_i14 = 4'b0010;
    2'b10 : uart0_sel_i14 = 4'b0100;
    2'b11 : uart0_sel_i14 = 4'b1000;
  endcase
end
always @(paddr14) begin
  case (paddr14[1:0])
    2'b00 : uart1_sel_i14 = 4'b0001;
    2'b01 : uart1_sel_i14 = 4'b0010;
    2'b10 : uart1_sel_i14 = 4'b0100;
    2'b11 : uart1_sel_i14 = 4'b1000;
  endcase
end
`endif

uart_top14 i_oc_uart014 (
  .wb_clk_i14(pclk14),
  .wb_rst_i14(~n_preset14),
  .wb_adr_i14(paddr14[4:0]),
  .wb_dat_i14(pwdata14),
  .wb_dat_o14(prdata_uart014),
  .wb_we_i14(pwrite14),
  .wb_stb_i14(psel_uart014),
  .wb_cyc_i14(psel_uart014),
  .wb_ack_o14(pready_uart014),
  .wb_sel_i14(uart0_sel_i14),
  .int_o14(UART_int14),
  .stx_pad_o14(ua_txd14),
  .srx_pad_i14(ua_rxd14),
  .rts_pad_o14(ua_nrts_int14),
  .cts_pad_i14(ua_ncts14),
  .dtr_pad_o14(),
  .dsr_pad_i14(1'b0),
  .ri_pad_i14(1'b0),
  .dcd_pad_i14(1'b0)
);

uart_top14 i_oc_uart114 (
  .wb_clk_i14(pclk14),
  .wb_rst_i14(~n_preset14),
  .wb_adr_i14(paddr14[4:0]),
  .wb_dat_i14(pwdata14),
  .wb_dat_o14(prdata_uart114),
  .wb_we_i14(pwrite14),
  .wb_stb_i14(psel_uart114),
  .wb_cyc_i14(psel_uart114),
  .wb_ack_o14(pready_uart114),
  .wb_sel_i14(uart1_sel_i14),
  .int_o14(UART_int114),
  .stx_pad_o14(ua_txd114),
  .srx_pad_i14(ua_rxd114),
  .rts_pad_o14(ua_nrts1_int14),
  .cts_pad_i14(ua_ncts114),
  .dtr_pad_o14(),
  .dsr_pad_i14(1'b0),
  .ri_pad_i14(1'b0),
  .dcd_pad_i14(1'b0)
);

gpio_veneer14 i_gpio_veneer14 (
        //inputs14

        . n_p_reset14(n_preset14),
        . pclk14(pclk14),
        . psel14(psel_gpio14),
        . penable14(penable14),
        . pwrite14(pwrite14),
        . paddr14(paddr14[5:0]),
        . pwdata14(pwdata14),
        . gpio_pin_in14(gpio_pin_in14),
        . scan_en14(scan_en14),
        . tri_state_enable14(tri_state_enable14),
        . scan_in14(), //added by smarkov14 for dft14

        //outputs14
        . scan_out14(), //added by smarkov14 for dft14
        . prdata14(prdata_gpio14),
        . gpio_int14(GPIO_int14),
        . n_gpio_pin_oe14(n_gpio_pin_oe14),
        . gpio_pin_out14(gpio_pin_out14)
);


ttc_veneer14 i_ttc_veneer14 (

         //inputs14
        . n_p_reset14(n_preset14),
        . pclk14(pclk14),
        . psel14(psel_ttc14),
        . penable14(penable14),
        . pwrite14(pwrite14),
        . pwdata14(pwdata14),
        . paddr14(paddr14[7:0]),
        . scan_in14(),
        . scan_en14(scan_en14),

        //outputs14
        . prdata14(prdata_ttc14),
        . interrupt14(TTC_int14[3:1]),
        . scan_out14()
);


smc_veneer14 i_smc_veneer14 (
        //inputs14
	//apb14 inputs14
        . n_preset14(n_preset14),
        . pclk14(pclk_SRPG_smc14),
        . psel14(psel_smc14),
        . penable14(penable14),
        . pwrite14(pwrite14),
        . paddr14(paddr14[4:0]),
        . pwdata14(pwdata14),
        //ahb14 inputs14
	. hclk14(smc_hclk14),
        . n_sys_reset14(rstn_non_srpg_smc14),
        . haddr14(smc_haddr14),
        . htrans14(smc_htrans14),
        . hsel14(smc_hsel_int14),
        . hwrite14(smc_hwrite14),
	. hsize14(smc_hsize14),
        . hwdata14(smc_hwdata14),
        . hready14(smc_hready_in14),
        . data_smc14(data_smc14),

         //test signal14 inputs14

        . scan_in_114(),
        . scan_in_214(),
        . scan_in_314(),
        . scan_en14(scan_en14),

        //apb14 outputs14
        . prdata14(prdata_smc14),

       //design output

        . smc_hrdata14(smc_hrdata14),
        . smc_hready14(smc_hready14),
        . smc_hresp14(smc_hresp14),
        . smc_valid14(smc_valid14),
        . smc_addr14(smc_addr_int14),
        . smc_data14(smc_data14),
        . smc_n_be14(smc_n_be14),
        . smc_n_cs14(smc_n_cs14),
        . smc_n_wr14(smc_n_wr14),
        . smc_n_we14(smc_n_we14),
        . smc_n_rd14(smc_n_rd14),
        . smc_n_ext_oe14(smc_n_ext_oe14),
        . smc_busy14(smc_busy14),

         //test signal14 output
        . scan_out_114(),
        . scan_out_214(),
        . scan_out_314()
);

power_ctrl_veneer14 i_power_ctrl_veneer14 (
    // -- Clocks14 & Reset14
    	.pclk14(pclk14), 			//  : in  std_logic14;
    	.nprst14(n_preset14), 		//  : in  std_logic14;
    // -- APB14 programming14 interface
    	.paddr14(paddr14), 			//  : in  std_logic_vector14(31 downto14 0);
    	.psel14(psel_pmc14), 			//  : in  std_logic14;
    	.penable14(penable14), 		//  : in  std_logic14;
    	.pwrite14(pwrite14), 		//  : in  std_logic14;
    	.pwdata14(pwdata14), 		//  : in  std_logic_vector14(31 downto14 0);
    	.prdata14(prdata_pmc14), 		//  : out std_logic_vector14(31 downto14 0);
        .macb3_wakeup14(macb3_wakeup14),
        .macb2_wakeup14(macb2_wakeup14),
        .macb1_wakeup14(macb1_wakeup14),
        .macb0_wakeup14(macb0_wakeup14),
    // -- Module14 control14 outputs14
    	.scan_in14(),			//  : in  std_logic14;
    	.scan_en14(scan_en14),             	//  : in  std_logic14;
    	.scan_mode14(scan_mode14),          //  : in  std_logic14;
    	.scan_out14(),            	//  : out std_logic14;
        .int_source_h14(int_source_h14),
     	.rstn_non_srpg_smc14(rstn_non_srpg_smc14), 		//   : out std_logic14;
    	.gate_clk_smc14(gate_clk_smc14), 	//  : out std_logic14;
    	.isolate_smc14(isolate_smc14), 	//  : out std_logic14;
    	.save_edge_smc14(save_edge_smc14), 	//  : out std_logic14;
    	.restore_edge_smc14(restore_edge_smc14), 	//  : out std_logic14;
    	.pwr1_on_smc14(pwr1_on_smc14), 	//  : out std_logic14;
    	.pwr2_on_smc14(pwr2_on_smc14), 	//  : out std_logic14
     	.rstn_non_srpg_urt14(rstn_non_srpg_urt14), 		//   : out std_logic14;
    	.gate_clk_urt14(gate_clk_urt14), 	//  : out std_logic14;
    	.isolate_urt14(isolate_urt14), 	//  : out std_logic14;
    	.save_edge_urt14(save_edge_urt14), 	//  : out std_logic14;
    	.restore_edge_urt14(restore_edge_urt14), 	//  : out std_logic14;
    	.pwr1_on_urt14(pwr1_on_urt14), 	//  : out std_logic14;
    	.pwr2_on_urt14(pwr2_on_urt14),  	//  : out std_logic14
        // ETH014
        .rstn_non_srpg_macb014(rstn_non_srpg_macb014),
        .gate_clk_macb014(gate_clk_macb014),
        .isolate_macb014(isolate_macb014),
        .save_edge_macb014(save_edge_macb014),
        .restore_edge_macb014(restore_edge_macb014),
        .pwr1_on_macb014(pwr1_on_macb014),
        .pwr2_on_macb014(pwr2_on_macb014),
        // ETH114
        .rstn_non_srpg_macb114(rstn_non_srpg_macb114),
        .gate_clk_macb114(gate_clk_macb114),
        .isolate_macb114(isolate_macb114),
        .save_edge_macb114(save_edge_macb114),
        .restore_edge_macb114(restore_edge_macb114),
        .pwr1_on_macb114(pwr1_on_macb114),
        .pwr2_on_macb114(pwr2_on_macb114),
        // ETH214
        .rstn_non_srpg_macb214(rstn_non_srpg_macb214),
        .gate_clk_macb214(gate_clk_macb214),
        .isolate_macb214(isolate_macb214),
        .save_edge_macb214(save_edge_macb214),
        .restore_edge_macb214(restore_edge_macb214),
        .pwr1_on_macb214(pwr1_on_macb214),
        .pwr2_on_macb214(pwr2_on_macb214),
        // ETH314
        .rstn_non_srpg_macb314(rstn_non_srpg_macb314),
        .gate_clk_macb314(gate_clk_macb314),
        .isolate_macb314(isolate_macb314),
        .save_edge_macb314(save_edge_macb314),
        .restore_edge_macb314(restore_edge_macb314),
        .pwr1_on_macb314(pwr1_on_macb314),
        .pwr2_on_macb314(pwr2_on_macb314),
        .core06v14(core06v14),
        .core08v14(core08v14),
        .core10v14(core10v14),
        .core12v14(core12v14),
        .pcm_macb_wakeup_int14(pcm_macb_wakeup_int14),
        .isolate_mem14(isolate_mem14),
        .mte_smc_start14(mte_smc_start14),
        .mte_uart_start14(mte_uart_start14),
        .mte_smc_uart_start14(mte_smc_uart_start14),  
        .mte_pm_smc_to_default_start14(mte_pm_smc_to_default_start14), 
        .mte_pm_uart_to_default_start14(mte_pm_uart_to_default_start14),
        .mte_pm_smc_uart_to_default_start14(mte_pm_smc_uart_to_default_start14)
);

// Clock14 gating14 macro14 to shut14 off14 clocks14 to the SRPG14 flops14 in the SMC14
//CKLNQD114 i_SMC_SRPG_clk_gate14  (
//	.TE14(scan_mode14), 
//	.E14(~gate_clk_smc14), 
//	.CP14(pclk14), 
//	.Q14(pclk_SRPG_smc14)
//	);
// Replace14 gate14 with behavioural14 code14 //
wire 	smc_scan_gate14;
reg 	smc_latched_enable14;
assign smc_scan_gate14 = scan_mode14 ? 1'b1 : ~gate_clk_smc14;

always @ (pclk14 or smc_scan_gate14)
  	if (pclk14 == 1'b0) begin
  		smc_latched_enable14 <= smc_scan_gate14;
  	end  	
	
assign pclk_SRPG_smc14 = smc_latched_enable14 ? pclk14 : 1'b0;


// Clock14 gating14 macro14 to shut14 off14 clocks14 to the SRPG14 flops14 in the URT14
//CKLNQD114 i_URT_SRPG_clk_gate14  (
//	.TE14(scan_mode14), 
//	.E14(~gate_clk_urt14), 
//	.CP14(pclk14), 
//	.Q14(pclk_SRPG_urt14)
//	);
// Replace14 gate14 with behavioural14 code14 //
wire 	urt_scan_gate14;
reg 	urt_latched_enable14;
assign urt_scan_gate14 = scan_mode14 ? 1'b1 : ~gate_clk_urt14;

always @ (pclk14 or urt_scan_gate14)
  	if (pclk14 == 1'b0) begin
  		urt_latched_enable14 <= urt_scan_gate14;
  	end  	
	
assign pclk_SRPG_urt14 = urt_latched_enable14 ? pclk14 : 1'b0;

// ETH014
wire 	macb0_scan_gate14;
reg 	macb0_latched_enable14;
assign macb0_scan_gate14 = scan_mode14 ? 1'b1 : ~gate_clk_macb014;

always @ (pclk14 or macb0_scan_gate14)
  	if (pclk14 == 1'b0) begin
  		macb0_latched_enable14 <= macb0_scan_gate14;
  	end  	
	
assign clk_SRPG_macb0_en14 = macb0_latched_enable14 ? 1'b1 : 1'b0;

// ETH114
wire 	macb1_scan_gate14;
reg 	macb1_latched_enable14;
assign macb1_scan_gate14 = scan_mode14 ? 1'b1 : ~gate_clk_macb114;

always @ (pclk14 or macb1_scan_gate14)
  	if (pclk14 == 1'b0) begin
  		macb1_latched_enable14 <= macb1_scan_gate14;
  	end  	
	
assign clk_SRPG_macb1_en14 = macb1_latched_enable14 ? 1'b1 : 1'b0;

// ETH214
wire 	macb2_scan_gate14;
reg 	macb2_latched_enable14;
assign macb2_scan_gate14 = scan_mode14 ? 1'b1 : ~gate_clk_macb214;

always @ (pclk14 or macb2_scan_gate14)
  	if (pclk14 == 1'b0) begin
  		macb2_latched_enable14 <= macb2_scan_gate14;
  	end  	
	
assign clk_SRPG_macb2_en14 = macb2_latched_enable14 ? 1'b1 : 1'b0;

// ETH314
wire 	macb3_scan_gate14;
reg 	macb3_latched_enable14;
assign macb3_scan_gate14 = scan_mode14 ? 1'b1 : ~gate_clk_macb314;

always @ (pclk14 or macb3_scan_gate14)
  	if (pclk14 == 1'b0) begin
  		macb3_latched_enable14 <= macb3_scan_gate14;
  	end  	
	
assign clk_SRPG_macb3_en14 = macb3_latched_enable14 ? 1'b1 : 1'b0;



`else
//------------------------------------------------------------------------------
// if the APB14 subsystem14 is black14 boxed14 
//------------------------------------------------------------------------------
// wire s ports14
    // system signals14
    wire         hclk14;     // AHB14 Clock14
    wire         n_hreset14;  // AHB14 reset - Active14 low14
    wire         pclk14;     // APB14 Clock14. 
    wire         n_preset14;  // APB14 reset - Active14 low14

    // AHB14 interface
    wire         ahb2apb0_hsel14;     // AHB2APB14 select14
    wire  [31:0] haddr14;    // Address bus
    wire  [1:0]  htrans14;   // Transfer14 type
    wire  [2:0]  hsize14;    // AHB14 Access type - byte, half14-word14, word14
    wire  [31:0] hwdata14;   // Write data
    wire         hwrite14;   // Write signal14/
    wire         hready_in14;// Indicates14 that last master14 has finished14 bus access
    wire [2:0]   hburst14;     // Burst type
    wire [3:0]   hprot14;      // Protection14 control14
    wire [3:0]   hmaster14;    // Master14 select14
    wire         hmastlock14;  // Locked14 transfer14
  // Interrupts14 from the Enet14 MACs14
    wire         macb0_int14;
    wire         macb1_int14;
    wire         macb2_int14;
    wire         macb3_int14;
  // Interrupt14 from the DMA14
    wire         DMA_irq14;
  // Scan14 wire s
    wire         scan_en14;    // Scan14 enable pin14
    wire         scan_in_114;  // Scan14 wire  for first chain14
    wire         scan_in_214;  // Scan14 wire  for second chain14
    wire         scan_mode14;  // test mode pin14
 
  //wire  for smc14 AHB14 interface
    wire         smc_hclk14;
    wire         smc_n_hclk14;
    wire  [31:0] smc_haddr14;
    wire  [1:0]  smc_htrans14;
    wire         smc_hsel14;
    wire         smc_hwrite14;
    wire  [2:0]  smc_hsize14;
    wire  [31:0] smc_hwdata14;
    wire         smc_hready_in14;
    wire  [2:0]  smc_hburst14;     // Burst type
    wire  [3:0]  smc_hprot14;      // Protection14 control14
    wire  [3:0]  smc_hmaster14;    // Master14 select14
    wire         smc_hmastlock14;  // Locked14 transfer14


    wire  [31:0] data_smc14;     // EMI14(External14 memory) read data
    
  //wire s for uart14
    wire         ua_rxd14;       // UART14 receiver14 serial14 wire  pin14
    wire         ua_rxd114;      // UART14 receiver14 serial14 wire  pin14
    wire         ua_ncts14;      // Clear-To14-Send14 flow14 control14
    wire         ua_ncts114;      // Clear-To14-Send14 flow14 control14
   //wire s for spi14
    wire         n_ss_in14;      // select14 wire  to slave14
    wire         mi14;           // data wire  to master14
    wire         si14;           // data wire  to slave14
    wire         sclk_in14;      // clock14 wire  to slave14
  //wire s for GPIO14
   wire  [GPIO_WIDTH14-1:0]  gpio_pin_in14;             // wire  data from pin14

  //reg    ports14
  // Scan14 reg   s
   reg           scan_out_114;   // Scan14 out for chain14 1
   reg           scan_out_214;   // Scan14 out for chain14 2
  //AHB14 interface 
   reg    [31:0] hrdata14;       // Read data provided from target slave14
   reg           hready14;       // Ready14 for new bus cycle from target slave14
   reg    [1:0]  hresp14;       // Response14 from the bridge14

   // SMC14 reg    for AHB14 interface
   reg    [31:0]    smc_hrdata14;
   reg              smc_hready14;
   reg    [1:0]     smc_hresp14;

  //reg   s from smc14
   reg    [15:0]    smc_addr14;      // External14 Memory (EMI14) address
   reg    [3:0]     smc_n_be14;      // EMI14 byte enables14 (Active14 LOW14)
   reg    [7:0]     smc_n_cs14;      // EMI14 Chip14 Selects14 (Active14 LOW14)
   reg    [3:0]     smc_n_we14;      // EMI14 write strobes14 (Active14 LOW14)
   reg              smc_n_wr14;      // EMI14 write enable (Active14 LOW14)
   reg              smc_n_rd14;      // EMI14 read stobe14 (Active14 LOW14)
   reg              smc_n_ext_oe14;  // EMI14 write data reg    enable
   reg    [31:0]    smc_data14;      // EMI14 write data
  //reg   s from uart14
   reg           ua_txd14;       	// UART14 transmitter14 serial14 reg   
   reg           ua_txd114;       // UART14 transmitter14 serial14 reg   
   reg           ua_nrts14;      	// Request14-To14-Send14 flow14 control14
   reg           ua_nrts114;      // Request14-To14-Send14 flow14 control14
   // reg   s from ttc14
  // reg   s from SPI14
   reg       so;                    // data reg    from slave14
   reg       mo14;                    // data reg    from master14
   reg       sclk_out14;              // clock14 reg    from master14
   reg    [P_SIZE14-1:0] n_ss_out14;    // peripheral14 select14 lines14 from master14
   reg       n_so_en14;               // out enable for slave14 data
   reg       n_mo_en14;               // out enable for master14 data
   reg       n_sclk_en14;             // out enable for master14 clock14
   reg       n_ss_en14;               // out enable for master14 peripheral14 lines14
  //reg   s from gpio14
   reg    [GPIO_WIDTH14-1:0]     n_gpio_pin_oe14;           // reg    enable signal14 to pin14
   reg    [GPIO_WIDTH14-1:0]     gpio_pin_out14;            // reg    signal14 to pin14


`endif
//------------------------------------------------------------------------------
// black14 boxed14 defines14 
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// APB14 and AHB14 interface formal14 verification14 monitors14
//------------------------------------------------------------------------------
`ifdef ABV_ON14
apb_assert14 i_apb_assert14 (

        // APB14 signals14
  	.n_preset14(n_preset14),
   	.pclk14(pclk14),
	.penable14(penable14),
	.paddr14(paddr14),
	.pwrite14(pwrite14),
	.pwdata14(pwdata14),

	.psel0014(psel_spi14),
	.psel0114(psel_uart014),
	.psel0214(psel_gpio14),
	.psel0314(psel_ttc14),
	.psel0414(1'b0),
	.psel0514(psel_smc14),
	.psel0614(1'b0),
	.psel0714(1'b0),
	.psel0814(1'b0),
	.psel0914(1'b0),
	.psel1014(1'b0),
	.psel1114(1'b0),
	.psel1214(1'b0),
	.psel1314(psel_pmc14),
	.psel1414(psel_apic14),
	.psel1514(psel_uart114),

        .prdata0014(prdata_spi14),
        .prdata0114(prdata_uart014), // Read Data from peripheral14 UART14 
        .prdata0214(prdata_gpio14), // Read Data from peripheral14 GPIO14
        .prdata0314(prdata_ttc14), // Read Data from peripheral14 TTC14
        .prdata0414(32'b0), // 
        .prdata0514(prdata_smc14), // Read Data from peripheral14 SMC14
        .prdata1314(prdata_pmc14), // Read Data from peripheral14 Power14 Control14 Block
   	.prdata1414(32'b0), // 
        .prdata1514(prdata_uart114),


        // AHB14 signals14
        .hclk14(hclk14),         // ahb14 system clock14
        .n_hreset14(n_hreset14), // ahb14 system reset

        // ahb2apb14 signals14
        .hresp14(hresp14),
        .hready14(hready14),
        .hrdata14(hrdata14),
        .hwdata14(hwdata14),
        .hprot14(hprot14),
        .hburst14(hburst14),
        .hsize14(hsize14),
        .hwrite14(hwrite14),
        .htrans14(htrans14),
        .haddr14(haddr14),
        .ahb2apb_hsel14(ahb2apb0_hsel14));



//------------------------------------------------------------------------------
// AHB14 interface formal14 verification14 monitor14
//------------------------------------------------------------------------------
defparam i_ahbSlaveMonitor14.DBUS_WIDTH14 = 32;
defparam i_ahbMasterMonitor14.DBUS_WIDTH14 = 32;


// AHB2APB14 Bridge14

    ahb_liteslave_monitor14 i_ahbSlaveMonitor14 (
        .hclk_i14(hclk14),
        .hresetn_i14(n_hreset14),
        .hresp14(hresp14),
        .hready14(hready14),
        .hready_global_i14(hready14),
        .hrdata14(hrdata14),
        .hwdata_i14(hwdata14),
        .hburst_i14(hburst14),
        .hsize_i14(hsize14),
        .hwrite_i14(hwrite14),
        .htrans_i14(htrans14),
        .haddr_i14(haddr14),
        .hsel_i14(ahb2apb0_hsel14)
    );


  ahb_litemaster_monitor14 i_ahbMasterMonitor14 (
          .hclk_i14(hclk14),
          .hresetn_i14(n_hreset14),
          .hresp_i14(hresp14),
          .hready_i14(hready14),
          .hrdata_i14(hrdata14),
          .hlock14(1'b0),
          .hwdata14(hwdata14),
          .hprot14(hprot14),
          .hburst14(hburst14),
          .hsize14(hsize14),
          .hwrite14(hwrite14),
          .htrans14(htrans14),
          .haddr14(haddr14)
          );







`endif




`ifdef IFV_LP_ABV_ON14
// power14 control14
wire isolate14;

// testbench mirror signals14
wire L1_ctrl_access14;
wire L1_status_access14;

wire [31:0] L1_status_reg14;
wire [31:0] L1_ctrl_reg14;

//wire rstn_non_srpg_urt14;
//wire isolate_urt14;
//wire retain_urt14;
//wire gate_clk_urt14;
//wire pwr1_on_urt14;


// smc14 signals14
wire [31:0] smc_prdata14;
wire lp_clk_smc14;
                    

// uart14 isolation14 register
  wire [15:0] ua_prdata14;
  wire ua_int14;
  assign ua_prdata14          =  i_uart1_veneer14.prdata14;
  assign ua_int14             =  i_uart1_veneer14.ua_int14;


assign lp_clk_smc14          = i_smc_veneer14.pclk14;
assign smc_prdata14          = i_smc_veneer14.prdata14;
lp_chk_smc14 u_lp_chk_smc14 (
    .clk14 (hclk14),
    .rst14 (n_hreset14),
    .iso_smc14 (isolate_smc14),
    .gate_clk14 (gate_clk_smc14),
    .lp_clk14 (pclk_SRPG_smc14),

    // srpg14 outputs14
    .smc_hrdata14 (smc_hrdata14),
    .smc_hready14 (smc_hready14),
    .smc_hresp14  (smc_hresp14),
    .smc_valid14 (smc_valid14),
    .smc_addr_int14 (smc_addr_int14),
    .smc_data14 (smc_data14),
    .smc_n_be14 (smc_n_be14),
    .smc_n_cs14  (smc_n_cs14),
    .smc_n_wr14 (smc_n_wr14),
    .smc_n_we14 (smc_n_we14),
    .smc_n_rd14 (smc_n_rd14),
    .smc_n_ext_oe14 (smc_n_ext_oe14)
   );

// lp14 retention14/isolation14 assertions14
lp_chk_uart14 u_lp_chk_urt14 (

  .clk14         (hclk14),
  .rst14         (n_hreset14),
  .iso_urt14     (isolate_urt14),
  .gate_clk14    (gate_clk_urt14),
  .lp_clk14      (pclk_SRPG_urt14),
  //ports14
  .prdata14 (ua_prdata14),
  .ua_int14 (ua_int14),
  .ua_txd14 (ua_txd114),
  .ua_nrts14 (ua_nrts114)
 );

`endif  //IFV_LP_ABV_ON14




endmodule
