//File29 name   : apb_subsystem_029.v
//Title29       : 
//Created29     : 1999
//Description29 : 
//Notes29       : 
//----------------------------------------------------------------------
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------

module apb_subsystem_029(
    // AHB29 interface
    hclk29,
    n_hreset29,
    hsel29,
    haddr29,
    htrans29,
    hsize29,
    hwrite29,
    hwdata29,
    hready_in29,
    hburst29,
    hprot29,
    hmaster29,
    hmastlock29,
    hrdata29,
    hready29,
    hresp29,
    
    // APB29 system interface
    pclk29,
    n_preset29,
    
    // SPI29 ports29
    n_ss_in29,
    mi29,
    si29,
    sclk_in29,
    so,
    mo29,
    sclk_out29,
    n_ss_out29,
    n_so_en29,
    n_mo_en29,
    n_sclk_en29,
    n_ss_en29,
    
    //UART029 ports29
    ua_rxd29,
    ua_ncts29,
    ua_txd29,
    ua_nrts29,
    
    //UART129 ports29
    ua_rxd129,
    ua_ncts129,
    ua_txd129,
    ua_nrts129,
    
    //GPIO29 ports29
    gpio_pin_in29,
    n_gpio_pin_oe29,
    gpio_pin_out29,
    

    //SMC29 ports29
    smc_hclk29,
    smc_n_hclk29,
    smc_haddr29,
    smc_htrans29,
    smc_hsel29,
    smc_hwrite29,
    smc_hsize29,
    smc_hwdata29,
    smc_hready_in29,
    smc_hburst29,
    smc_hprot29,
    smc_hmaster29,
    smc_hmastlock29,
    smc_hrdata29, 
    smc_hready29,
    smc_hresp29,
    smc_n_ext_oe29,
    smc_data29,
    smc_addr29,
    smc_n_be29,
    smc_n_cs29, 
    smc_n_we29,
    smc_n_wr29,
    smc_n_rd29,
    data_smc29,
    
    //PMC29 ports29
    clk_SRPG_macb0_en29,
    clk_SRPG_macb1_en29,
    clk_SRPG_macb2_en29,
    clk_SRPG_macb3_en29,
    core06v29,
    core08v29,
    core10v29,
    core12v29,
    macb3_wakeup29,
    macb2_wakeup29,
    macb1_wakeup29,
    macb0_wakeup29,
    mte_smc_start29,
    mte_uart_start29,
    mte_smc_uart_start29,  
    mte_pm_smc_to_default_start29, 
    mte_pm_uart_to_default_start29,
    mte_pm_smc_uart_to_default_start29,
    
    
    // Peripheral29 inerrupts29
    pcm_irq29,
    ttc_irq29,
    gpio_irq29,
    uart0_irq29,
    uart1_irq29,
    spi_irq29,
    DMA_irq29,      
    macb0_int29,
    macb1_int29,
    macb2_int29,
    macb3_int29,
   
    // Scan29 ports29
    scan_en29,      // Scan29 enable pin29
    scan_in_129,    // Scan29 input for first chain29
    scan_in_229,    // Scan29 input for second chain29
    scan_mode29,
    scan_out_129,   // Scan29 out for chain29 1
    scan_out_229    // Scan29 out for chain29 2
);

parameter GPIO_WIDTH29 = 16;        // GPIO29 width
parameter P_SIZE29 =   8;              // number29 of peripheral29 select29 lines29
parameter NO_OF_IRQS29  = 17;      //No of irqs29 read by apic29 

// AHB29 interface
input         hclk29;     // AHB29 Clock29
input         n_hreset29;  // AHB29 reset - Active29 low29
input         hsel29;     // AHB2APB29 select29
input [31:0]  haddr29;    // Address bus
input [1:0]   htrans29;   // Transfer29 type
input [2:0]   hsize29;    // AHB29 Access type - byte, half29-word29, word29
input [31:0]  hwdata29;   // Write data
input         hwrite29;   // Write signal29/
input         hready_in29;// Indicates29 that last master29 has finished29 bus access
input [2:0]   hburst29;     // Burst type
input [3:0]   hprot29;      // Protection29 control29
input [3:0]   hmaster29;    // Master29 select29
input         hmastlock29;  // Locked29 transfer29
output [31:0] hrdata29;       // Read data provided from target slave29
output        hready29;       // Ready29 for new bus cycle from target slave29
output [1:0]  hresp29;       // Response29 from the bridge29
    
// APB29 system interface
input         pclk29;     // APB29 Clock29. 
input         n_preset29;  // APB29 reset - Active29 low29
   
// SPI29 ports29
input     n_ss_in29;      // select29 input to slave29
input     mi29;           // data input to master29
input     si29;           // data input to slave29
input     sclk_in29;      // clock29 input to slave29
output    so;                    // data output from slave29
output    mo29;                    // data output from master29
output    sclk_out29;              // clock29 output from master29
output [P_SIZE29-1:0] n_ss_out29;    // peripheral29 select29 lines29 from master29
output    n_so_en29;               // out enable for slave29 data
output    n_mo_en29;               // out enable for master29 data
output    n_sclk_en29;             // out enable for master29 clock29
output    n_ss_en29;               // out enable for master29 peripheral29 lines29

//UART029 ports29
input        ua_rxd29;       // UART29 receiver29 serial29 input pin29
input        ua_ncts29;      // Clear-To29-Send29 flow29 control29
output       ua_txd29;       	// UART29 transmitter29 serial29 output
output       ua_nrts29;      	// Request29-To29-Send29 flow29 control29

// UART129 ports29   
input        ua_rxd129;      // UART29 receiver29 serial29 input pin29
input        ua_ncts129;      // Clear-To29-Send29 flow29 control29
output       ua_txd129;       // UART29 transmitter29 serial29 output
output       ua_nrts129;      // Request29-To29-Send29 flow29 control29

//GPIO29 ports29
input [GPIO_WIDTH29-1:0]      gpio_pin_in29;             // input data from pin29
output [GPIO_WIDTH29-1:0]     n_gpio_pin_oe29;           // output enable signal29 to pin29
output [GPIO_WIDTH29-1:0]     gpio_pin_out29;            // output signal29 to pin29
  
//SMC29 ports29
input        smc_hclk29;
input        smc_n_hclk29;
input [31:0] smc_haddr29;
input [1:0]  smc_htrans29;
input        smc_hsel29;
input        smc_hwrite29;
input [2:0]  smc_hsize29;
input [31:0] smc_hwdata29;
input        smc_hready_in29;
input [2:0]  smc_hburst29;     // Burst type
input [3:0]  smc_hprot29;      // Protection29 control29
input [3:0]  smc_hmaster29;    // Master29 select29
input        smc_hmastlock29;  // Locked29 transfer29
input [31:0] data_smc29;     // EMI29(External29 memory) read data
output [31:0]    smc_hrdata29;
output           smc_hready29;
output [1:0]     smc_hresp29;
output [15:0]    smc_addr29;      // External29 Memory (EMI29) address
output [3:0]     smc_n_be29;      // EMI29 byte enables29 (Active29 LOW29)
output           smc_n_cs29;      // EMI29 Chip29 Selects29 (Active29 LOW29)
output [3:0]     smc_n_we29;      // EMI29 write strobes29 (Active29 LOW29)
output           smc_n_wr29;      // EMI29 write enable (Active29 LOW29)
output           smc_n_rd29;      // EMI29 read stobe29 (Active29 LOW29)
output           smc_n_ext_oe29;  // EMI29 write data output enable
output [31:0]    smc_data29;      // EMI29 write data
       
//PMC29 ports29
output clk_SRPG_macb0_en29;
output clk_SRPG_macb1_en29;
output clk_SRPG_macb2_en29;
output clk_SRPG_macb3_en29;
output core06v29;
output core08v29;
output core10v29;
output core12v29;
output mte_smc_start29;
output mte_uart_start29;
output mte_smc_uart_start29;  
output mte_pm_smc_to_default_start29; 
output mte_pm_uart_to_default_start29;
output mte_pm_smc_uart_to_default_start29;
input macb3_wakeup29;
input macb2_wakeup29;
input macb1_wakeup29;
input macb0_wakeup29;
    

// Peripheral29 interrupts29
output pcm_irq29;
output [2:0] ttc_irq29;
output gpio_irq29;
output uart0_irq29;
output uart1_irq29;
output spi_irq29;
input        macb0_int29;
input        macb1_int29;
input        macb2_int29;
input        macb3_int29;
input        DMA_irq29;
  
//Scan29 ports29
input        scan_en29;    // Scan29 enable pin29
input        scan_in_129;  // Scan29 input for first chain29
input        scan_in_229;  // Scan29 input for second chain29
input        scan_mode29;  // test mode pin29
 output        scan_out_129;   // Scan29 out for chain29 1
 output        scan_out_229;   // Scan29 out for chain29 2  

//------------------------------------------------------------------------------
// if the ROM29 subsystem29 is NOT29 black29 boxed29 
//------------------------------------------------------------------------------
`ifndef FV_KIT_BLACK_BOX_APB_SUBSYSTEM29
   
   wire        hsel29; 
   wire        pclk29;
   wire        n_preset29;
   wire [31:0] prdata_spi29;
   wire [31:0] prdata_uart029;
   wire [31:0] prdata_gpio29;
   wire [31:0] prdata_ttc29;
   wire [31:0] prdata_smc29;
   wire [31:0] prdata_pmc29;
   wire [31:0] prdata_uart129;
   wire        pready_spi29;
   wire        pready_uart029;
   wire        pready_uart129;
   wire        tie_hi_bit29;
   wire  [31:0] hrdata29; 
   wire         hready29;
   wire         hready_in29;
   wire  [1:0]  hresp29;   
   wire  [31:0] pwdata29;  
   wire         pwrite29;
   wire  [31:0] paddr29;  
   wire   psel_spi29;
   wire   psel_uart029;
   wire   psel_gpio29;
   wire   psel_ttc29;
   wire   psel_smc29;
   wire   psel0729;
   wire   psel0829;
   wire   psel0929;
   wire   psel1029;
   wire   psel1129;
   wire   psel1229;
   wire   psel_pmc29;
   wire   psel_uart129;
   wire   penable29;
   wire   [NO_OF_IRQS29:0] int_source29;     // System29 Interrupt29 Sources29
   wire [1:0]             smc_hresp29;     // AHB29 Response29 signal29
   wire                   smc_valid29;     // Ack29 valid address

  //External29 memory interface (EMI29)
  wire [31:0]            smc_addr_int29;  // External29 Memory (EMI29) address
  wire [3:0]             smc_n_be29;      // EMI29 byte enables29 (Active29 LOW29)
  wire                   smc_n_cs29;      // EMI29 Chip29 Selects29 (Active29 LOW29)
  wire [3:0]             smc_n_we29;      // EMI29 write strobes29 (Active29 LOW29)
  wire                   smc_n_wr29;      // EMI29 write enable (Active29 LOW29)
  wire                   smc_n_rd29;      // EMI29 read stobe29 (Active29 LOW29)
 
  //AHB29 Memory Interface29 Control29
  wire                   smc_hsel_int29;
  wire                   smc_busy29;      // smc29 busy
   

//scan29 signals29

   wire                scan_in_129;        //scan29 input
   wire                scan_in_229;        //scan29 input
   wire                scan_en29;         //scan29 enable
   wire                scan_out_129;       //scan29 output
   wire                scan_out_229;       //scan29 output
   wire                byte_sel29;     // byte select29 from bridge29 1=byte, 0=2byte
   wire                UART_int29;     // UART29 module interrupt29 
   wire                ua_uclken29;    // Soft29 control29 of clock29
   wire                UART_int129;     // UART29 module interrupt29 
   wire                ua_uclken129;    // Soft29 control29 of clock29
   wire  [3:1]         TTC_int29;            //Interrupt29 from PCI29 
  // inputs29 to SPI29 
   wire    ext_clk29;                // external29 clock29
   wire    SPI_int29;             // interrupt29 request
  // outputs29 from SPI29
   wire    slave_out_clk29;         // modified slave29 clock29 output
 // gpio29 generic29 inputs29 
   wire  [GPIO_WIDTH29-1:0]   n_gpio_bypass_oe29;        // bypass29 mode enable 
   wire  [GPIO_WIDTH29-1:0]   gpio_bypass_out29;         // bypass29 mode output value 
   wire  [GPIO_WIDTH29-1:0]   tri_state_enable29;   // disables29 op enable -> z 
 // outputs29 
   //amba29 outputs29 
   // gpio29 generic29 outputs29 
   wire       GPIO_int29;                // gpio_interupt29 for input pin29 change 
   wire [GPIO_WIDTH29-1:0]     gpio_bypass_in29;          // bypass29 mode input data value  
                
   wire           cpu_debug29;        // Inhibits29 watchdog29 counter 
   wire            ex_wdz_n29;         // External29 Watchdog29 zero indication29
   wire           rstn_non_srpg_smc29; 
   wire           rstn_non_srpg_urt29;
   wire           isolate_smc29;
   wire           save_edge_smc29;
   wire           restore_edge_smc29;
   wire           save_edge_urt29;
   wire           restore_edge_urt29;
   wire           pwr1_on_smc29;
   wire           pwr2_on_smc29;
   wire           pwr1_on_urt29;
   wire           pwr2_on_urt29;
   // ETH029
   wire            rstn_non_srpg_macb029;
   wire            gate_clk_macb029;
   wire            isolate_macb029;
   wire            save_edge_macb029;
   wire            restore_edge_macb029;
   wire            pwr1_on_macb029;
   wire            pwr2_on_macb029;
   // ETH129
   wire            rstn_non_srpg_macb129;
   wire            gate_clk_macb129;
   wire            isolate_macb129;
   wire            save_edge_macb129;
   wire            restore_edge_macb129;
   wire            pwr1_on_macb129;
   wire            pwr2_on_macb129;
   // ETH229
   wire            rstn_non_srpg_macb229;
   wire            gate_clk_macb229;
   wire            isolate_macb229;
   wire            save_edge_macb229;
   wire            restore_edge_macb229;
   wire            pwr1_on_macb229;
   wire            pwr2_on_macb229;
   // ETH329
   wire            rstn_non_srpg_macb329;
   wire            gate_clk_macb329;
   wire            isolate_macb329;
   wire            save_edge_macb329;
   wire            restore_edge_macb329;
   wire            pwr1_on_macb329;
   wire            pwr2_on_macb329;


   wire           pclk_SRPG_smc29;
   wire           pclk_SRPG_urt29;
   wire           gate_clk_smc29;
   wire           gate_clk_urt29;
   wire  [31:0]   tie_lo_32bit29; 
   wire  [1:0]	  tie_lo_2bit29;
   wire  	  tie_lo_1bit29;
   wire           pcm_macb_wakeup_int29;
   wire           int_source_h29;
   wire           isolate_mem29;

assign pcm_irq29 = pcm_macb_wakeup_int29;
assign ttc_irq29[2] = TTC_int29[3];
assign ttc_irq29[1] = TTC_int29[2];
assign ttc_irq29[0] = TTC_int29[1];
assign gpio_irq29 = GPIO_int29;
assign uart0_irq29 = UART_int29;
assign uart1_irq29 = UART_int129;
assign spi_irq29 = SPI_int29;

assign n_mo_en29   = 1'b0;
assign n_so_en29   = 1'b1;
assign n_sclk_en29 = 1'b0;
assign n_ss_en29   = 1'b0;

assign smc_hsel_int29 = smc_hsel29;
  assign ext_clk29  = 1'b0;
  assign int_source29 = {macb0_int29,macb1_int29, macb2_int29, macb3_int29,1'b0, pcm_macb_wakeup_int29, 1'b0, 1'b0, 1'b0, 1'b0, TTC_int29, GPIO_int29, UART_int29, UART_int129, SPI_int29, DMA_irq29};

  // interrupt29 even29 detect29 .
  // for sleep29 wake29 up -> any interrupt29 even29 and system not in hibernation29 (isolate_mem29 = 0)
  // for hibernate29 wake29 up -> gpio29 interrupt29 even29 and system in the hibernation29 (isolate_mem29 = 1)
  assign int_source_h29 =  ((|int_source29) && (!isolate_mem29)) || (isolate_mem29 && GPIO_int29) ;

  assign byte_sel29 = 1'b1;
  assign tie_hi_bit29 = 1'b1;

  assign smc_addr29 = smc_addr_int29[15:0];



  assign  n_gpio_bypass_oe29 = {GPIO_WIDTH29{1'b0}};        // bypass29 mode enable 
  assign  gpio_bypass_out29  = {GPIO_WIDTH29{1'b0}};
  assign  tri_state_enable29 = {GPIO_WIDTH29{1'b0}};
  assign  cpu_debug29 = 1'b0;
  assign  tie_lo_32bit29 = 32'b0;
  assign  tie_lo_2bit29  = 2'b0;
  assign  tie_lo_1bit29  = 1'b0;


ahb2apb29 #(
  32'h00800000, // Slave29 0 Address Range29
  32'h0080FFFF,

  32'h00810000, // Slave29 1 Address Range29
  32'h0081FFFF,

  32'h00820000, // Slave29 2 Address Range29 
  32'h0082FFFF,

  32'h00830000, // Slave29 3 Address Range29
  32'h0083FFFF,

  32'h00840000, // Slave29 4 Address Range29
  32'h0084FFFF,

  32'h00850000, // Slave29 5 Address Range29
  32'h0085FFFF,

  32'h00860000, // Slave29 6 Address Range29
  32'h0086FFFF,

  32'h00870000, // Slave29 7 Address Range29
  32'h0087FFFF,

  32'h00880000, // Slave29 8 Address Range29
  32'h0088FFFF
) i_ahb2apb29 (
     // AHB29 interface
    .hclk29(hclk29),         
    .hreset_n29(n_hreset29), 
    .hsel29(hsel29), 
    .haddr29(haddr29),        
    .htrans29(htrans29),       
    .hwrite29(hwrite29),       
    .hwdata29(hwdata29),       
    .hrdata29(hrdata29),   
    .hready29(hready29),   
    .hresp29(hresp29),     
    
     // APB29 interface
    .pclk29(pclk29),         
    .preset_n29(n_preset29),  
    .prdata029(prdata_spi29),
    .prdata129(prdata_uart029), 
    .prdata229(prdata_gpio29),  
    .prdata329(prdata_ttc29),   
    .prdata429(32'h0),   
    .prdata529(prdata_smc29),   
    .prdata629(prdata_pmc29),    
    .prdata729(32'h0),   
    .prdata829(prdata_uart129),  
    .pready029(pready_spi29),     
    .pready129(pready_uart029),   
    .pready229(tie_hi_bit29),     
    .pready329(tie_hi_bit29),     
    .pready429(tie_hi_bit29),     
    .pready529(tie_hi_bit29),     
    .pready629(tie_hi_bit29),     
    .pready729(tie_hi_bit29),     
    .pready829(pready_uart129),  
    .pwdata29(pwdata29),       
    .pwrite29(pwrite29),       
    .paddr29(paddr29),        
    .psel029(psel_spi29),     
    .psel129(psel_uart029),   
    .psel229(psel_gpio29),    
    .psel329(psel_ttc29),     
    .psel429(),     
    .psel529(psel_smc29),     
    .psel629(psel_pmc29),    
    .psel729(psel_apic29),   
    .psel829(psel_uart129),  
    .penable29(penable29)     
);

spi_top29 i_spi29
(
  // Wishbone29 signals29
  .wb_clk_i29(pclk29), 
  .wb_rst_i29(~n_preset29), 
  .wb_adr_i29(paddr29[4:0]), 
  .wb_dat_i29(pwdata29), 
  .wb_dat_o29(prdata_spi29), 
  .wb_sel_i29(4'b1111),    // SPI29 register accesses are always 32-bit
  .wb_we_i29(pwrite29), 
  .wb_stb_i29(psel_spi29), 
  .wb_cyc_i29(psel_spi29), 
  .wb_ack_o29(pready_spi29), 
  .wb_err_o29(), 
  .wb_int_o29(SPI_int29),

  // SPI29 signals29
  .ss_pad_o29(n_ss_out29), 
  .sclk_pad_o29(sclk_out29), 
  .mosi_pad_o29(mo29), 
  .miso_pad_i29(mi29)
);

// Opencores29 UART29 instances29
wire ua_nrts_int29;
wire ua_nrts1_int29;

assign ua_nrts29 = ua_nrts_int29;
assign ua_nrts129 = ua_nrts1_int29;

reg [3:0] uart0_sel_i29;
reg [3:0] uart1_sel_i29;
// UART29 registers are all 8-bit wide29, and their29 addresses29
// are on byte boundaries29. So29 to access them29 on the
// Wishbone29 bus, the CPU29 must do byte accesses to these29
// byte addresses29. Word29 address accesses are not possible29
// because the word29 addresses29 will be unaligned29, and cause
// a fault29.
// So29, Uart29 accesses from the CPU29 will always be 8-bit size
// We29 only have to decide29 which byte of the 4-byte word29 the
// CPU29 is interested29 in.
`ifdef SYSTEM_BIG_ENDIAN29
always @(paddr29) begin
  case (paddr29[1:0])
    2'b00 : uart0_sel_i29 = 4'b1000;
    2'b01 : uart0_sel_i29 = 4'b0100;
    2'b10 : uart0_sel_i29 = 4'b0010;
    2'b11 : uart0_sel_i29 = 4'b0001;
  endcase
end
always @(paddr29) begin
  case (paddr29[1:0])
    2'b00 : uart1_sel_i29 = 4'b1000;
    2'b01 : uart1_sel_i29 = 4'b0100;
    2'b10 : uart1_sel_i29 = 4'b0010;
    2'b11 : uart1_sel_i29 = 4'b0001;
  endcase
end
`else
always @(paddr29) begin
  case (paddr29[1:0])
    2'b00 : uart0_sel_i29 = 4'b0001;
    2'b01 : uart0_sel_i29 = 4'b0010;
    2'b10 : uart0_sel_i29 = 4'b0100;
    2'b11 : uart0_sel_i29 = 4'b1000;
  endcase
end
always @(paddr29) begin
  case (paddr29[1:0])
    2'b00 : uart1_sel_i29 = 4'b0001;
    2'b01 : uart1_sel_i29 = 4'b0010;
    2'b10 : uart1_sel_i29 = 4'b0100;
    2'b11 : uart1_sel_i29 = 4'b1000;
  endcase
end
`endif

uart_top29 i_oc_uart029 (
  .wb_clk_i29(pclk29),
  .wb_rst_i29(~n_preset29),
  .wb_adr_i29(paddr29[4:0]),
  .wb_dat_i29(pwdata29),
  .wb_dat_o29(prdata_uart029),
  .wb_we_i29(pwrite29),
  .wb_stb_i29(psel_uart029),
  .wb_cyc_i29(psel_uart029),
  .wb_ack_o29(pready_uart029),
  .wb_sel_i29(uart0_sel_i29),
  .int_o29(UART_int29),
  .stx_pad_o29(ua_txd29),
  .srx_pad_i29(ua_rxd29),
  .rts_pad_o29(ua_nrts_int29),
  .cts_pad_i29(ua_ncts29),
  .dtr_pad_o29(),
  .dsr_pad_i29(1'b0),
  .ri_pad_i29(1'b0),
  .dcd_pad_i29(1'b0)
);

uart_top29 i_oc_uart129 (
  .wb_clk_i29(pclk29),
  .wb_rst_i29(~n_preset29),
  .wb_adr_i29(paddr29[4:0]),
  .wb_dat_i29(pwdata29),
  .wb_dat_o29(prdata_uart129),
  .wb_we_i29(pwrite29),
  .wb_stb_i29(psel_uart129),
  .wb_cyc_i29(psel_uart129),
  .wb_ack_o29(pready_uart129),
  .wb_sel_i29(uart1_sel_i29),
  .int_o29(UART_int129),
  .stx_pad_o29(ua_txd129),
  .srx_pad_i29(ua_rxd129),
  .rts_pad_o29(ua_nrts1_int29),
  .cts_pad_i29(ua_ncts129),
  .dtr_pad_o29(),
  .dsr_pad_i29(1'b0),
  .ri_pad_i29(1'b0),
  .dcd_pad_i29(1'b0)
);

gpio_veneer29 i_gpio_veneer29 (
        //inputs29

        . n_p_reset29(n_preset29),
        . pclk29(pclk29),
        . psel29(psel_gpio29),
        . penable29(penable29),
        . pwrite29(pwrite29),
        . paddr29(paddr29[5:0]),
        . pwdata29(pwdata29),
        . gpio_pin_in29(gpio_pin_in29),
        . scan_en29(scan_en29),
        . tri_state_enable29(tri_state_enable29),
        . scan_in29(), //added by smarkov29 for dft29

        //outputs29
        . scan_out29(), //added by smarkov29 for dft29
        . prdata29(prdata_gpio29),
        . gpio_int29(GPIO_int29),
        . n_gpio_pin_oe29(n_gpio_pin_oe29),
        . gpio_pin_out29(gpio_pin_out29)
);


ttc_veneer29 i_ttc_veneer29 (

         //inputs29
        . n_p_reset29(n_preset29),
        . pclk29(pclk29),
        . psel29(psel_ttc29),
        . penable29(penable29),
        . pwrite29(pwrite29),
        . pwdata29(pwdata29),
        . paddr29(paddr29[7:0]),
        . scan_in29(),
        . scan_en29(scan_en29),

        //outputs29
        . prdata29(prdata_ttc29),
        . interrupt29(TTC_int29[3:1]),
        . scan_out29()
);


smc_veneer29 i_smc_veneer29 (
        //inputs29
	//apb29 inputs29
        . n_preset29(n_preset29),
        . pclk29(pclk_SRPG_smc29),
        . psel29(psel_smc29),
        . penable29(penable29),
        . pwrite29(pwrite29),
        . paddr29(paddr29[4:0]),
        . pwdata29(pwdata29),
        //ahb29 inputs29
	. hclk29(smc_hclk29),
        . n_sys_reset29(rstn_non_srpg_smc29),
        . haddr29(smc_haddr29),
        . htrans29(smc_htrans29),
        . hsel29(smc_hsel_int29),
        . hwrite29(smc_hwrite29),
	. hsize29(smc_hsize29),
        . hwdata29(smc_hwdata29),
        . hready29(smc_hready_in29),
        . data_smc29(data_smc29),

         //test signal29 inputs29

        . scan_in_129(),
        . scan_in_229(),
        . scan_in_329(),
        . scan_en29(scan_en29),

        //apb29 outputs29
        . prdata29(prdata_smc29),

       //design output

        . smc_hrdata29(smc_hrdata29),
        . smc_hready29(smc_hready29),
        . smc_hresp29(smc_hresp29),
        . smc_valid29(smc_valid29),
        . smc_addr29(smc_addr_int29),
        . smc_data29(smc_data29),
        . smc_n_be29(smc_n_be29),
        . smc_n_cs29(smc_n_cs29),
        . smc_n_wr29(smc_n_wr29),
        . smc_n_we29(smc_n_we29),
        . smc_n_rd29(smc_n_rd29),
        . smc_n_ext_oe29(smc_n_ext_oe29),
        . smc_busy29(smc_busy29),

         //test signal29 output
        . scan_out_129(),
        . scan_out_229(),
        . scan_out_329()
);

power_ctrl_veneer29 i_power_ctrl_veneer29 (
    // -- Clocks29 & Reset29
    	.pclk29(pclk29), 			//  : in  std_logic29;
    	.nprst29(n_preset29), 		//  : in  std_logic29;
    // -- APB29 programming29 interface
    	.paddr29(paddr29), 			//  : in  std_logic_vector29(31 downto29 0);
    	.psel29(psel_pmc29), 			//  : in  std_logic29;
    	.penable29(penable29), 		//  : in  std_logic29;
    	.pwrite29(pwrite29), 		//  : in  std_logic29;
    	.pwdata29(pwdata29), 		//  : in  std_logic_vector29(31 downto29 0);
    	.prdata29(prdata_pmc29), 		//  : out std_logic_vector29(31 downto29 0);
        .macb3_wakeup29(macb3_wakeup29),
        .macb2_wakeup29(macb2_wakeup29),
        .macb1_wakeup29(macb1_wakeup29),
        .macb0_wakeup29(macb0_wakeup29),
    // -- Module29 control29 outputs29
    	.scan_in29(),			//  : in  std_logic29;
    	.scan_en29(scan_en29),             	//  : in  std_logic29;
    	.scan_mode29(scan_mode29),          //  : in  std_logic29;
    	.scan_out29(),            	//  : out std_logic29;
        .int_source_h29(int_source_h29),
     	.rstn_non_srpg_smc29(rstn_non_srpg_smc29), 		//   : out std_logic29;
    	.gate_clk_smc29(gate_clk_smc29), 	//  : out std_logic29;
    	.isolate_smc29(isolate_smc29), 	//  : out std_logic29;
    	.save_edge_smc29(save_edge_smc29), 	//  : out std_logic29;
    	.restore_edge_smc29(restore_edge_smc29), 	//  : out std_logic29;
    	.pwr1_on_smc29(pwr1_on_smc29), 	//  : out std_logic29;
    	.pwr2_on_smc29(pwr2_on_smc29), 	//  : out std_logic29
     	.rstn_non_srpg_urt29(rstn_non_srpg_urt29), 		//   : out std_logic29;
    	.gate_clk_urt29(gate_clk_urt29), 	//  : out std_logic29;
    	.isolate_urt29(isolate_urt29), 	//  : out std_logic29;
    	.save_edge_urt29(save_edge_urt29), 	//  : out std_logic29;
    	.restore_edge_urt29(restore_edge_urt29), 	//  : out std_logic29;
    	.pwr1_on_urt29(pwr1_on_urt29), 	//  : out std_logic29;
    	.pwr2_on_urt29(pwr2_on_urt29),  	//  : out std_logic29
        // ETH029
        .rstn_non_srpg_macb029(rstn_non_srpg_macb029),
        .gate_clk_macb029(gate_clk_macb029),
        .isolate_macb029(isolate_macb029),
        .save_edge_macb029(save_edge_macb029),
        .restore_edge_macb029(restore_edge_macb029),
        .pwr1_on_macb029(pwr1_on_macb029),
        .pwr2_on_macb029(pwr2_on_macb029),
        // ETH129
        .rstn_non_srpg_macb129(rstn_non_srpg_macb129),
        .gate_clk_macb129(gate_clk_macb129),
        .isolate_macb129(isolate_macb129),
        .save_edge_macb129(save_edge_macb129),
        .restore_edge_macb129(restore_edge_macb129),
        .pwr1_on_macb129(pwr1_on_macb129),
        .pwr2_on_macb129(pwr2_on_macb129),
        // ETH229
        .rstn_non_srpg_macb229(rstn_non_srpg_macb229),
        .gate_clk_macb229(gate_clk_macb229),
        .isolate_macb229(isolate_macb229),
        .save_edge_macb229(save_edge_macb229),
        .restore_edge_macb229(restore_edge_macb229),
        .pwr1_on_macb229(pwr1_on_macb229),
        .pwr2_on_macb229(pwr2_on_macb229),
        // ETH329
        .rstn_non_srpg_macb329(rstn_non_srpg_macb329),
        .gate_clk_macb329(gate_clk_macb329),
        .isolate_macb329(isolate_macb329),
        .save_edge_macb329(save_edge_macb329),
        .restore_edge_macb329(restore_edge_macb329),
        .pwr1_on_macb329(pwr1_on_macb329),
        .pwr2_on_macb329(pwr2_on_macb329),
        .core06v29(core06v29),
        .core08v29(core08v29),
        .core10v29(core10v29),
        .core12v29(core12v29),
        .pcm_macb_wakeup_int29(pcm_macb_wakeup_int29),
        .isolate_mem29(isolate_mem29),
        .mte_smc_start29(mte_smc_start29),
        .mte_uart_start29(mte_uart_start29),
        .mte_smc_uart_start29(mte_smc_uart_start29),  
        .mte_pm_smc_to_default_start29(mte_pm_smc_to_default_start29), 
        .mte_pm_uart_to_default_start29(mte_pm_uart_to_default_start29),
        .mte_pm_smc_uart_to_default_start29(mte_pm_smc_uart_to_default_start29)
);

// Clock29 gating29 macro29 to shut29 off29 clocks29 to the SRPG29 flops29 in the SMC29
//CKLNQD129 i_SMC_SRPG_clk_gate29  (
//	.TE29(scan_mode29), 
//	.E29(~gate_clk_smc29), 
//	.CP29(pclk29), 
//	.Q29(pclk_SRPG_smc29)
//	);
// Replace29 gate29 with behavioural29 code29 //
wire 	smc_scan_gate29;
reg 	smc_latched_enable29;
assign smc_scan_gate29 = scan_mode29 ? 1'b1 : ~gate_clk_smc29;

always @ (pclk29 or smc_scan_gate29)
  	if (pclk29 == 1'b0) begin
  		smc_latched_enable29 <= smc_scan_gate29;
  	end  	
	
assign pclk_SRPG_smc29 = smc_latched_enable29 ? pclk29 : 1'b0;


// Clock29 gating29 macro29 to shut29 off29 clocks29 to the SRPG29 flops29 in the URT29
//CKLNQD129 i_URT_SRPG_clk_gate29  (
//	.TE29(scan_mode29), 
//	.E29(~gate_clk_urt29), 
//	.CP29(pclk29), 
//	.Q29(pclk_SRPG_urt29)
//	);
// Replace29 gate29 with behavioural29 code29 //
wire 	urt_scan_gate29;
reg 	urt_latched_enable29;
assign urt_scan_gate29 = scan_mode29 ? 1'b1 : ~gate_clk_urt29;

always @ (pclk29 or urt_scan_gate29)
  	if (pclk29 == 1'b0) begin
  		urt_latched_enable29 <= urt_scan_gate29;
  	end  	
	
assign pclk_SRPG_urt29 = urt_latched_enable29 ? pclk29 : 1'b0;

// ETH029
wire 	macb0_scan_gate29;
reg 	macb0_latched_enable29;
assign macb0_scan_gate29 = scan_mode29 ? 1'b1 : ~gate_clk_macb029;

always @ (pclk29 or macb0_scan_gate29)
  	if (pclk29 == 1'b0) begin
  		macb0_latched_enable29 <= macb0_scan_gate29;
  	end  	
	
assign clk_SRPG_macb0_en29 = macb0_latched_enable29 ? 1'b1 : 1'b0;

// ETH129
wire 	macb1_scan_gate29;
reg 	macb1_latched_enable29;
assign macb1_scan_gate29 = scan_mode29 ? 1'b1 : ~gate_clk_macb129;

always @ (pclk29 or macb1_scan_gate29)
  	if (pclk29 == 1'b0) begin
  		macb1_latched_enable29 <= macb1_scan_gate29;
  	end  	
	
assign clk_SRPG_macb1_en29 = macb1_latched_enable29 ? 1'b1 : 1'b0;

// ETH229
wire 	macb2_scan_gate29;
reg 	macb2_latched_enable29;
assign macb2_scan_gate29 = scan_mode29 ? 1'b1 : ~gate_clk_macb229;

always @ (pclk29 or macb2_scan_gate29)
  	if (pclk29 == 1'b0) begin
  		macb2_latched_enable29 <= macb2_scan_gate29;
  	end  	
	
assign clk_SRPG_macb2_en29 = macb2_latched_enable29 ? 1'b1 : 1'b0;

// ETH329
wire 	macb3_scan_gate29;
reg 	macb3_latched_enable29;
assign macb3_scan_gate29 = scan_mode29 ? 1'b1 : ~gate_clk_macb329;

always @ (pclk29 or macb3_scan_gate29)
  	if (pclk29 == 1'b0) begin
  		macb3_latched_enable29 <= macb3_scan_gate29;
  	end  	
	
assign clk_SRPG_macb3_en29 = macb3_latched_enable29 ? 1'b1 : 1'b0;



`else
//------------------------------------------------------------------------------
// if the APB29 subsystem29 is black29 boxed29 
//------------------------------------------------------------------------------
// wire s ports29
    // system signals29
    wire         hclk29;     // AHB29 Clock29
    wire         n_hreset29;  // AHB29 reset - Active29 low29
    wire         pclk29;     // APB29 Clock29. 
    wire         n_preset29;  // APB29 reset - Active29 low29

    // AHB29 interface
    wire         ahb2apb0_hsel29;     // AHB2APB29 select29
    wire  [31:0] haddr29;    // Address bus
    wire  [1:0]  htrans29;   // Transfer29 type
    wire  [2:0]  hsize29;    // AHB29 Access type - byte, half29-word29, word29
    wire  [31:0] hwdata29;   // Write data
    wire         hwrite29;   // Write signal29/
    wire         hready_in29;// Indicates29 that last master29 has finished29 bus access
    wire [2:0]   hburst29;     // Burst type
    wire [3:0]   hprot29;      // Protection29 control29
    wire [3:0]   hmaster29;    // Master29 select29
    wire         hmastlock29;  // Locked29 transfer29
  // Interrupts29 from the Enet29 MACs29
    wire         macb0_int29;
    wire         macb1_int29;
    wire         macb2_int29;
    wire         macb3_int29;
  // Interrupt29 from the DMA29
    wire         DMA_irq29;
  // Scan29 wire s
    wire         scan_en29;    // Scan29 enable pin29
    wire         scan_in_129;  // Scan29 wire  for first chain29
    wire         scan_in_229;  // Scan29 wire  for second chain29
    wire         scan_mode29;  // test mode pin29
 
  //wire  for smc29 AHB29 interface
    wire         smc_hclk29;
    wire         smc_n_hclk29;
    wire  [31:0] smc_haddr29;
    wire  [1:0]  smc_htrans29;
    wire         smc_hsel29;
    wire         smc_hwrite29;
    wire  [2:0]  smc_hsize29;
    wire  [31:0] smc_hwdata29;
    wire         smc_hready_in29;
    wire  [2:0]  smc_hburst29;     // Burst type
    wire  [3:0]  smc_hprot29;      // Protection29 control29
    wire  [3:0]  smc_hmaster29;    // Master29 select29
    wire         smc_hmastlock29;  // Locked29 transfer29


    wire  [31:0] data_smc29;     // EMI29(External29 memory) read data
    
  //wire s for uart29
    wire         ua_rxd29;       // UART29 receiver29 serial29 wire  pin29
    wire         ua_rxd129;      // UART29 receiver29 serial29 wire  pin29
    wire         ua_ncts29;      // Clear-To29-Send29 flow29 control29
    wire         ua_ncts129;      // Clear-To29-Send29 flow29 control29
   //wire s for spi29
    wire         n_ss_in29;      // select29 wire  to slave29
    wire         mi29;           // data wire  to master29
    wire         si29;           // data wire  to slave29
    wire         sclk_in29;      // clock29 wire  to slave29
  //wire s for GPIO29
   wire  [GPIO_WIDTH29-1:0]  gpio_pin_in29;             // wire  data from pin29

  //reg    ports29
  // Scan29 reg   s
   reg           scan_out_129;   // Scan29 out for chain29 1
   reg           scan_out_229;   // Scan29 out for chain29 2
  //AHB29 interface 
   reg    [31:0] hrdata29;       // Read data provided from target slave29
   reg           hready29;       // Ready29 for new bus cycle from target slave29
   reg    [1:0]  hresp29;       // Response29 from the bridge29

   // SMC29 reg    for AHB29 interface
   reg    [31:0]    smc_hrdata29;
   reg              smc_hready29;
   reg    [1:0]     smc_hresp29;

  //reg   s from smc29
   reg    [15:0]    smc_addr29;      // External29 Memory (EMI29) address
   reg    [3:0]     smc_n_be29;      // EMI29 byte enables29 (Active29 LOW29)
   reg    [7:0]     smc_n_cs29;      // EMI29 Chip29 Selects29 (Active29 LOW29)
   reg    [3:0]     smc_n_we29;      // EMI29 write strobes29 (Active29 LOW29)
   reg              smc_n_wr29;      // EMI29 write enable (Active29 LOW29)
   reg              smc_n_rd29;      // EMI29 read stobe29 (Active29 LOW29)
   reg              smc_n_ext_oe29;  // EMI29 write data reg    enable
   reg    [31:0]    smc_data29;      // EMI29 write data
  //reg   s from uart29
   reg           ua_txd29;       	// UART29 transmitter29 serial29 reg   
   reg           ua_txd129;       // UART29 transmitter29 serial29 reg   
   reg           ua_nrts29;      	// Request29-To29-Send29 flow29 control29
   reg           ua_nrts129;      // Request29-To29-Send29 flow29 control29
   // reg   s from ttc29
  // reg   s from SPI29
   reg       so;                    // data reg    from slave29
   reg       mo29;                    // data reg    from master29
   reg       sclk_out29;              // clock29 reg    from master29
   reg    [P_SIZE29-1:0] n_ss_out29;    // peripheral29 select29 lines29 from master29
   reg       n_so_en29;               // out enable for slave29 data
   reg       n_mo_en29;               // out enable for master29 data
   reg       n_sclk_en29;             // out enable for master29 clock29
   reg       n_ss_en29;               // out enable for master29 peripheral29 lines29
  //reg   s from gpio29
   reg    [GPIO_WIDTH29-1:0]     n_gpio_pin_oe29;           // reg    enable signal29 to pin29
   reg    [GPIO_WIDTH29-1:0]     gpio_pin_out29;            // reg    signal29 to pin29


`endif
//------------------------------------------------------------------------------
// black29 boxed29 defines29 
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// APB29 and AHB29 interface formal29 verification29 monitors29
//------------------------------------------------------------------------------
`ifdef ABV_ON29
apb_assert29 i_apb_assert29 (

        // APB29 signals29
  	.n_preset29(n_preset29),
   	.pclk29(pclk29),
	.penable29(penable29),
	.paddr29(paddr29),
	.pwrite29(pwrite29),
	.pwdata29(pwdata29),

	.psel0029(psel_spi29),
	.psel0129(psel_uart029),
	.psel0229(psel_gpio29),
	.psel0329(psel_ttc29),
	.psel0429(1'b0),
	.psel0529(psel_smc29),
	.psel0629(1'b0),
	.psel0729(1'b0),
	.psel0829(1'b0),
	.psel0929(1'b0),
	.psel1029(1'b0),
	.psel1129(1'b0),
	.psel1229(1'b0),
	.psel1329(psel_pmc29),
	.psel1429(psel_apic29),
	.psel1529(psel_uart129),

        .prdata0029(prdata_spi29),
        .prdata0129(prdata_uart029), // Read Data from peripheral29 UART29 
        .prdata0229(prdata_gpio29), // Read Data from peripheral29 GPIO29
        .prdata0329(prdata_ttc29), // Read Data from peripheral29 TTC29
        .prdata0429(32'b0), // 
        .prdata0529(prdata_smc29), // Read Data from peripheral29 SMC29
        .prdata1329(prdata_pmc29), // Read Data from peripheral29 Power29 Control29 Block
   	.prdata1429(32'b0), // 
        .prdata1529(prdata_uart129),


        // AHB29 signals29
        .hclk29(hclk29),         // ahb29 system clock29
        .n_hreset29(n_hreset29), // ahb29 system reset

        // ahb2apb29 signals29
        .hresp29(hresp29),
        .hready29(hready29),
        .hrdata29(hrdata29),
        .hwdata29(hwdata29),
        .hprot29(hprot29),
        .hburst29(hburst29),
        .hsize29(hsize29),
        .hwrite29(hwrite29),
        .htrans29(htrans29),
        .haddr29(haddr29),
        .ahb2apb_hsel29(ahb2apb0_hsel29));



//------------------------------------------------------------------------------
// AHB29 interface formal29 verification29 monitor29
//------------------------------------------------------------------------------
defparam i_ahbSlaveMonitor29.DBUS_WIDTH29 = 32;
defparam i_ahbMasterMonitor29.DBUS_WIDTH29 = 32;


// AHB2APB29 Bridge29

    ahb_liteslave_monitor29 i_ahbSlaveMonitor29 (
        .hclk_i29(hclk29),
        .hresetn_i29(n_hreset29),
        .hresp29(hresp29),
        .hready29(hready29),
        .hready_global_i29(hready29),
        .hrdata29(hrdata29),
        .hwdata_i29(hwdata29),
        .hburst_i29(hburst29),
        .hsize_i29(hsize29),
        .hwrite_i29(hwrite29),
        .htrans_i29(htrans29),
        .haddr_i29(haddr29),
        .hsel_i29(ahb2apb0_hsel29)
    );


  ahb_litemaster_monitor29 i_ahbMasterMonitor29 (
          .hclk_i29(hclk29),
          .hresetn_i29(n_hreset29),
          .hresp_i29(hresp29),
          .hready_i29(hready29),
          .hrdata_i29(hrdata29),
          .hlock29(1'b0),
          .hwdata29(hwdata29),
          .hprot29(hprot29),
          .hburst29(hburst29),
          .hsize29(hsize29),
          .hwrite29(hwrite29),
          .htrans29(htrans29),
          .haddr29(haddr29)
          );







`endif




`ifdef IFV_LP_ABV_ON29
// power29 control29
wire isolate29;

// testbench mirror signals29
wire L1_ctrl_access29;
wire L1_status_access29;

wire [31:0] L1_status_reg29;
wire [31:0] L1_ctrl_reg29;

//wire rstn_non_srpg_urt29;
//wire isolate_urt29;
//wire retain_urt29;
//wire gate_clk_urt29;
//wire pwr1_on_urt29;


// smc29 signals29
wire [31:0] smc_prdata29;
wire lp_clk_smc29;
                    

// uart29 isolation29 register
  wire [15:0] ua_prdata29;
  wire ua_int29;
  assign ua_prdata29          =  i_uart1_veneer29.prdata29;
  assign ua_int29             =  i_uart1_veneer29.ua_int29;


assign lp_clk_smc29          = i_smc_veneer29.pclk29;
assign smc_prdata29          = i_smc_veneer29.prdata29;
lp_chk_smc29 u_lp_chk_smc29 (
    .clk29 (hclk29),
    .rst29 (n_hreset29),
    .iso_smc29 (isolate_smc29),
    .gate_clk29 (gate_clk_smc29),
    .lp_clk29 (pclk_SRPG_smc29),

    // srpg29 outputs29
    .smc_hrdata29 (smc_hrdata29),
    .smc_hready29 (smc_hready29),
    .smc_hresp29  (smc_hresp29),
    .smc_valid29 (smc_valid29),
    .smc_addr_int29 (smc_addr_int29),
    .smc_data29 (smc_data29),
    .smc_n_be29 (smc_n_be29),
    .smc_n_cs29  (smc_n_cs29),
    .smc_n_wr29 (smc_n_wr29),
    .smc_n_we29 (smc_n_we29),
    .smc_n_rd29 (smc_n_rd29),
    .smc_n_ext_oe29 (smc_n_ext_oe29)
   );

// lp29 retention29/isolation29 assertions29
lp_chk_uart29 u_lp_chk_urt29 (

  .clk29         (hclk29),
  .rst29         (n_hreset29),
  .iso_urt29     (isolate_urt29),
  .gate_clk29    (gate_clk_urt29),
  .lp_clk29      (pclk_SRPG_urt29),
  //ports29
  .prdata29 (ua_prdata29),
  .ua_int29 (ua_int29),
  .ua_txd29 (ua_txd129),
  .ua_nrts29 (ua_nrts129)
 );

`endif  //IFV_LP_ABV_ON29




endmodule
