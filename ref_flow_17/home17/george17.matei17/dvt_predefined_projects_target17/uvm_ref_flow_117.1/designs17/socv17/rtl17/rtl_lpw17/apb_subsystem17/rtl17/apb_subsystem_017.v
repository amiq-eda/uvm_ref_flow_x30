//File17 name   : apb_subsystem_017.v
//Title17       : 
//Created17     : 1999
//Description17 : 
//Notes17       : 
//----------------------------------------------------------------------
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------

module apb_subsystem_017(
    // AHB17 interface
    hclk17,
    n_hreset17,
    hsel17,
    haddr17,
    htrans17,
    hsize17,
    hwrite17,
    hwdata17,
    hready_in17,
    hburst17,
    hprot17,
    hmaster17,
    hmastlock17,
    hrdata17,
    hready17,
    hresp17,
    
    // APB17 system interface
    pclk17,
    n_preset17,
    
    // SPI17 ports17
    n_ss_in17,
    mi17,
    si17,
    sclk_in17,
    so,
    mo17,
    sclk_out17,
    n_ss_out17,
    n_so_en17,
    n_mo_en17,
    n_sclk_en17,
    n_ss_en17,
    
    //UART017 ports17
    ua_rxd17,
    ua_ncts17,
    ua_txd17,
    ua_nrts17,
    
    //UART117 ports17
    ua_rxd117,
    ua_ncts117,
    ua_txd117,
    ua_nrts117,
    
    //GPIO17 ports17
    gpio_pin_in17,
    n_gpio_pin_oe17,
    gpio_pin_out17,
    

    //SMC17 ports17
    smc_hclk17,
    smc_n_hclk17,
    smc_haddr17,
    smc_htrans17,
    smc_hsel17,
    smc_hwrite17,
    smc_hsize17,
    smc_hwdata17,
    smc_hready_in17,
    smc_hburst17,
    smc_hprot17,
    smc_hmaster17,
    smc_hmastlock17,
    smc_hrdata17, 
    smc_hready17,
    smc_hresp17,
    smc_n_ext_oe17,
    smc_data17,
    smc_addr17,
    smc_n_be17,
    smc_n_cs17, 
    smc_n_we17,
    smc_n_wr17,
    smc_n_rd17,
    data_smc17,
    
    //PMC17 ports17
    clk_SRPG_macb0_en17,
    clk_SRPG_macb1_en17,
    clk_SRPG_macb2_en17,
    clk_SRPG_macb3_en17,
    core06v17,
    core08v17,
    core10v17,
    core12v17,
    macb3_wakeup17,
    macb2_wakeup17,
    macb1_wakeup17,
    macb0_wakeup17,
    mte_smc_start17,
    mte_uart_start17,
    mte_smc_uart_start17,  
    mte_pm_smc_to_default_start17, 
    mte_pm_uart_to_default_start17,
    mte_pm_smc_uart_to_default_start17,
    
    
    // Peripheral17 inerrupts17
    pcm_irq17,
    ttc_irq17,
    gpio_irq17,
    uart0_irq17,
    uart1_irq17,
    spi_irq17,
    DMA_irq17,      
    macb0_int17,
    macb1_int17,
    macb2_int17,
    macb3_int17,
   
    // Scan17 ports17
    scan_en17,      // Scan17 enable pin17
    scan_in_117,    // Scan17 input for first chain17
    scan_in_217,    // Scan17 input for second chain17
    scan_mode17,
    scan_out_117,   // Scan17 out for chain17 1
    scan_out_217    // Scan17 out for chain17 2
);

parameter GPIO_WIDTH17 = 16;        // GPIO17 width
parameter P_SIZE17 =   8;              // number17 of peripheral17 select17 lines17
parameter NO_OF_IRQS17  = 17;      //No of irqs17 read by apic17 

// AHB17 interface
input         hclk17;     // AHB17 Clock17
input         n_hreset17;  // AHB17 reset - Active17 low17
input         hsel17;     // AHB2APB17 select17
input [31:0]  haddr17;    // Address bus
input [1:0]   htrans17;   // Transfer17 type
input [2:0]   hsize17;    // AHB17 Access type - byte, half17-word17, word17
input [31:0]  hwdata17;   // Write data
input         hwrite17;   // Write signal17/
input         hready_in17;// Indicates17 that last master17 has finished17 bus access
input [2:0]   hburst17;     // Burst type
input [3:0]   hprot17;      // Protection17 control17
input [3:0]   hmaster17;    // Master17 select17
input         hmastlock17;  // Locked17 transfer17
output [31:0] hrdata17;       // Read data provided from target slave17
output        hready17;       // Ready17 for new bus cycle from target slave17
output [1:0]  hresp17;       // Response17 from the bridge17
    
// APB17 system interface
input         pclk17;     // APB17 Clock17. 
input         n_preset17;  // APB17 reset - Active17 low17
   
// SPI17 ports17
input     n_ss_in17;      // select17 input to slave17
input     mi17;           // data input to master17
input     si17;           // data input to slave17
input     sclk_in17;      // clock17 input to slave17
output    so;                    // data output from slave17
output    mo17;                    // data output from master17
output    sclk_out17;              // clock17 output from master17
output [P_SIZE17-1:0] n_ss_out17;    // peripheral17 select17 lines17 from master17
output    n_so_en17;               // out enable for slave17 data
output    n_mo_en17;               // out enable for master17 data
output    n_sclk_en17;             // out enable for master17 clock17
output    n_ss_en17;               // out enable for master17 peripheral17 lines17

//UART017 ports17
input        ua_rxd17;       // UART17 receiver17 serial17 input pin17
input        ua_ncts17;      // Clear-To17-Send17 flow17 control17
output       ua_txd17;       	// UART17 transmitter17 serial17 output
output       ua_nrts17;      	// Request17-To17-Send17 flow17 control17

// UART117 ports17   
input        ua_rxd117;      // UART17 receiver17 serial17 input pin17
input        ua_ncts117;      // Clear-To17-Send17 flow17 control17
output       ua_txd117;       // UART17 transmitter17 serial17 output
output       ua_nrts117;      // Request17-To17-Send17 flow17 control17

//GPIO17 ports17
input [GPIO_WIDTH17-1:0]      gpio_pin_in17;             // input data from pin17
output [GPIO_WIDTH17-1:0]     n_gpio_pin_oe17;           // output enable signal17 to pin17
output [GPIO_WIDTH17-1:0]     gpio_pin_out17;            // output signal17 to pin17
  
//SMC17 ports17
input        smc_hclk17;
input        smc_n_hclk17;
input [31:0] smc_haddr17;
input [1:0]  smc_htrans17;
input        smc_hsel17;
input        smc_hwrite17;
input [2:0]  smc_hsize17;
input [31:0] smc_hwdata17;
input        smc_hready_in17;
input [2:0]  smc_hburst17;     // Burst type
input [3:0]  smc_hprot17;      // Protection17 control17
input [3:0]  smc_hmaster17;    // Master17 select17
input        smc_hmastlock17;  // Locked17 transfer17
input [31:0] data_smc17;     // EMI17(External17 memory) read data
output [31:0]    smc_hrdata17;
output           smc_hready17;
output [1:0]     smc_hresp17;
output [15:0]    smc_addr17;      // External17 Memory (EMI17) address
output [3:0]     smc_n_be17;      // EMI17 byte enables17 (Active17 LOW17)
output           smc_n_cs17;      // EMI17 Chip17 Selects17 (Active17 LOW17)
output [3:0]     smc_n_we17;      // EMI17 write strobes17 (Active17 LOW17)
output           smc_n_wr17;      // EMI17 write enable (Active17 LOW17)
output           smc_n_rd17;      // EMI17 read stobe17 (Active17 LOW17)
output           smc_n_ext_oe17;  // EMI17 write data output enable
output [31:0]    smc_data17;      // EMI17 write data
       
//PMC17 ports17
output clk_SRPG_macb0_en17;
output clk_SRPG_macb1_en17;
output clk_SRPG_macb2_en17;
output clk_SRPG_macb3_en17;
output core06v17;
output core08v17;
output core10v17;
output core12v17;
output mte_smc_start17;
output mte_uart_start17;
output mte_smc_uart_start17;  
output mte_pm_smc_to_default_start17; 
output mte_pm_uart_to_default_start17;
output mte_pm_smc_uart_to_default_start17;
input macb3_wakeup17;
input macb2_wakeup17;
input macb1_wakeup17;
input macb0_wakeup17;
    

// Peripheral17 interrupts17
output pcm_irq17;
output [2:0] ttc_irq17;
output gpio_irq17;
output uart0_irq17;
output uart1_irq17;
output spi_irq17;
input        macb0_int17;
input        macb1_int17;
input        macb2_int17;
input        macb3_int17;
input        DMA_irq17;
  
//Scan17 ports17
input        scan_en17;    // Scan17 enable pin17
input        scan_in_117;  // Scan17 input for first chain17
input        scan_in_217;  // Scan17 input for second chain17
input        scan_mode17;  // test mode pin17
 output        scan_out_117;   // Scan17 out for chain17 1
 output        scan_out_217;   // Scan17 out for chain17 2  

//------------------------------------------------------------------------------
// if the ROM17 subsystem17 is NOT17 black17 boxed17 
//------------------------------------------------------------------------------
`ifndef FV_KIT_BLACK_BOX_APB_SUBSYSTEM17
   
   wire        hsel17; 
   wire        pclk17;
   wire        n_preset17;
   wire [31:0] prdata_spi17;
   wire [31:0] prdata_uart017;
   wire [31:0] prdata_gpio17;
   wire [31:0] prdata_ttc17;
   wire [31:0] prdata_smc17;
   wire [31:0] prdata_pmc17;
   wire [31:0] prdata_uart117;
   wire        pready_spi17;
   wire        pready_uart017;
   wire        pready_uart117;
   wire        tie_hi_bit17;
   wire  [31:0] hrdata17; 
   wire         hready17;
   wire         hready_in17;
   wire  [1:0]  hresp17;   
   wire  [31:0] pwdata17;  
   wire         pwrite17;
   wire  [31:0] paddr17;  
   wire   psel_spi17;
   wire   psel_uart017;
   wire   psel_gpio17;
   wire   psel_ttc17;
   wire   psel_smc17;
   wire   psel0717;
   wire   psel0817;
   wire   psel0917;
   wire   psel1017;
   wire   psel1117;
   wire   psel1217;
   wire   psel_pmc17;
   wire   psel_uart117;
   wire   penable17;
   wire   [NO_OF_IRQS17:0] int_source17;     // System17 Interrupt17 Sources17
   wire [1:0]             smc_hresp17;     // AHB17 Response17 signal17
   wire                   smc_valid17;     // Ack17 valid address

  //External17 memory interface (EMI17)
  wire [31:0]            smc_addr_int17;  // External17 Memory (EMI17) address
  wire [3:0]             smc_n_be17;      // EMI17 byte enables17 (Active17 LOW17)
  wire                   smc_n_cs17;      // EMI17 Chip17 Selects17 (Active17 LOW17)
  wire [3:0]             smc_n_we17;      // EMI17 write strobes17 (Active17 LOW17)
  wire                   smc_n_wr17;      // EMI17 write enable (Active17 LOW17)
  wire                   smc_n_rd17;      // EMI17 read stobe17 (Active17 LOW17)
 
  //AHB17 Memory Interface17 Control17
  wire                   smc_hsel_int17;
  wire                   smc_busy17;      // smc17 busy
   

//scan17 signals17

   wire                scan_in_117;        //scan17 input
   wire                scan_in_217;        //scan17 input
   wire                scan_en17;         //scan17 enable
   wire                scan_out_117;       //scan17 output
   wire                scan_out_217;       //scan17 output
   wire                byte_sel17;     // byte select17 from bridge17 1=byte, 0=2byte
   wire                UART_int17;     // UART17 module interrupt17 
   wire                ua_uclken17;    // Soft17 control17 of clock17
   wire                UART_int117;     // UART17 module interrupt17 
   wire                ua_uclken117;    // Soft17 control17 of clock17
   wire  [3:1]         TTC_int17;            //Interrupt17 from PCI17 
  // inputs17 to SPI17 
   wire    ext_clk17;                // external17 clock17
   wire    SPI_int17;             // interrupt17 request
  // outputs17 from SPI17
   wire    slave_out_clk17;         // modified slave17 clock17 output
 // gpio17 generic17 inputs17 
   wire  [GPIO_WIDTH17-1:0]   n_gpio_bypass_oe17;        // bypass17 mode enable 
   wire  [GPIO_WIDTH17-1:0]   gpio_bypass_out17;         // bypass17 mode output value 
   wire  [GPIO_WIDTH17-1:0]   tri_state_enable17;   // disables17 op enable -> z 
 // outputs17 
   //amba17 outputs17 
   // gpio17 generic17 outputs17 
   wire       GPIO_int17;                // gpio_interupt17 for input pin17 change 
   wire [GPIO_WIDTH17-1:0]     gpio_bypass_in17;          // bypass17 mode input data value  
                
   wire           cpu_debug17;        // Inhibits17 watchdog17 counter 
   wire            ex_wdz_n17;         // External17 Watchdog17 zero indication17
   wire           rstn_non_srpg_smc17; 
   wire           rstn_non_srpg_urt17;
   wire           isolate_smc17;
   wire           save_edge_smc17;
   wire           restore_edge_smc17;
   wire           save_edge_urt17;
   wire           restore_edge_urt17;
   wire           pwr1_on_smc17;
   wire           pwr2_on_smc17;
   wire           pwr1_on_urt17;
   wire           pwr2_on_urt17;
   // ETH017
   wire            rstn_non_srpg_macb017;
   wire            gate_clk_macb017;
   wire            isolate_macb017;
   wire            save_edge_macb017;
   wire            restore_edge_macb017;
   wire            pwr1_on_macb017;
   wire            pwr2_on_macb017;
   // ETH117
   wire            rstn_non_srpg_macb117;
   wire            gate_clk_macb117;
   wire            isolate_macb117;
   wire            save_edge_macb117;
   wire            restore_edge_macb117;
   wire            pwr1_on_macb117;
   wire            pwr2_on_macb117;
   // ETH217
   wire            rstn_non_srpg_macb217;
   wire            gate_clk_macb217;
   wire            isolate_macb217;
   wire            save_edge_macb217;
   wire            restore_edge_macb217;
   wire            pwr1_on_macb217;
   wire            pwr2_on_macb217;
   // ETH317
   wire            rstn_non_srpg_macb317;
   wire            gate_clk_macb317;
   wire            isolate_macb317;
   wire            save_edge_macb317;
   wire            restore_edge_macb317;
   wire            pwr1_on_macb317;
   wire            pwr2_on_macb317;


   wire           pclk_SRPG_smc17;
   wire           pclk_SRPG_urt17;
   wire           gate_clk_smc17;
   wire           gate_clk_urt17;
   wire  [31:0]   tie_lo_32bit17; 
   wire  [1:0]	  tie_lo_2bit17;
   wire  	  tie_lo_1bit17;
   wire           pcm_macb_wakeup_int17;
   wire           int_source_h17;
   wire           isolate_mem17;

assign pcm_irq17 = pcm_macb_wakeup_int17;
assign ttc_irq17[2] = TTC_int17[3];
assign ttc_irq17[1] = TTC_int17[2];
assign ttc_irq17[0] = TTC_int17[1];
assign gpio_irq17 = GPIO_int17;
assign uart0_irq17 = UART_int17;
assign uart1_irq17 = UART_int117;
assign spi_irq17 = SPI_int17;

assign n_mo_en17   = 1'b0;
assign n_so_en17   = 1'b1;
assign n_sclk_en17 = 1'b0;
assign n_ss_en17   = 1'b0;

assign smc_hsel_int17 = smc_hsel17;
  assign ext_clk17  = 1'b0;
  assign int_source17 = {macb0_int17,macb1_int17, macb2_int17, macb3_int17,1'b0, pcm_macb_wakeup_int17, 1'b0, 1'b0, 1'b0, 1'b0, TTC_int17, GPIO_int17, UART_int17, UART_int117, SPI_int17, DMA_irq17};

  // interrupt17 even17 detect17 .
  // for sleep17 wake17 up -> any interrupt17 even17 and system not in hibernation17 (isolate_mem17 = 0)
  // for hibernate17 wake17 up -> gpio17 interrupt17 even17 and system in the hibernation17 (isolate_mem17 = 1)
  assign int_source_h17 =  ((|int_source17) && (!isolate_mem17)) || (isolate_mem17 && GPIO_int17) ;

  assign byte_sel17 = 1'b1;
  assign tie_hi_bit17 = 1'b1;

  assign smc_addr17 = smc_addr_int17[15:0];



  assign  n_gpio_bypass_oe17 = {GPIO_WIDTH17{1'b0}};        // bypass17 mode enable 
  assign  gpio_bypass_out17  = {GPIO_WIDTH17{1'b0}};
  assign  tri_state_enable17 = {GPIO_WIDTH17{1'b0}};
  assign  cpu_debug17 = 1'b0;
  assign  tie_lo_32bit17 = 32'b0;
  assign  tie_lo_2bit17  = 2'b0;
  assign  tie_lo_1bit17  = 1'b0;


ahb2apb17 #(
  32'h00800000, // Slave17 0 Address Range17
  32'h0080FFFF,

  32'h00810000, // Slave17 1 Address Range17
  32'h0081FFFF,

  32'h00820000, // Slave17 2 Address Range17 
  32'h0082FFFF,

  32'h00830000, // Slave17 3 Address Range17
  32'h0083FFFF,

  32'h00840000, // Slave17 4 Address Range17
  32'h0084FFFF,

  32'h00850000, // Slave17 5 Address Range17
  32'h0085FFFF,

  32'h00860000, // Slave17 6 Address Range17
  32'h0086FFFF,

  32'h00870000, // Slave17 7 Address Range17
  32'h0087FFFF,

  32'h00880000, // Slave17 8 Address Range17
  32'h0088FFFF
) i_ahb2apb17 (
     // AHB17 interface
    .hclk17(hclk17),         
    .hreset_n17(n_hreset17), 
    .hsel17(hsel17), 
    .haddr17(haddr17),        
    .htrans17(htrans17),       
    .hwrite17(hwrite17),       
    .hwdata17(hwdata17),       
    .hrdata17(hrdata17),   
    .hready17(hready17),   
    .hresp17(hresp17),     
    
     // APB17 interface
    .pclk17(pclk17),         
    .preset_n17(n_preset17),  
    .prdata017(prdata_spi17),
    .prdata117(prdata_uart017), 
    .prdata217(prdata_gpio17),  
    .prdata317(prdata_ttc17),   
    .prdata417(32'h0),   
    .prdata517(prdata_smc17),   
    .prdata617(prdata_pmc17),    
    .prdata717(32'h0),   
    .prdata817(prdata_uart117),  
    .pready017(pready_spi17),     
    .pready117(pready_uart017),   
    .pready217(tie_hi_bit17),     
    .pready317(tie_hi_bit17),     
    .pready417(tie_hi_bit17),     
    .pready517(tie_hi_bit17),     
    .pready617(tie_hi_bit17),     
    .pready717(tie_hi_bit17),     
    .pready817(pready_uart117),  
    .pwdata17(pwdata17),       
    .pwrite17(pwrite17),       
    .paddr17(paddr17),        
    .psel017(psel_spi17),     
    .psel117(psel_uart017),   
    .psel217(psel_gpio17),    
    .psel317(psel_ttc17),     
    .psel417(),     
    .psel517(psel_smc17),     
    .psel617(psel_pmc17),    
    .psel717(psel_apic17),   
    .psel817(psel_uart117),  
    .penable17(penable17)     
);

spi_top17 i_spi17
(
  // Wishbone17 signals17
  .wb_clk_i17(pclk17), 
  .wb_rst_i17(~n_preset17), 
  .wb_adr_i17(paddr17[4:0]), 
  .wb_dat_i17(pwdata17), 
  .wb_dat_o17(prdata_spi17), 
  .wb_sel_i17(4'b1111),    // SPI17 register accesses are always 32-bit
  .wb_we_i17(pwrite17), 
  .wb_stb_i17(psel_spi17), 
  .wb_cyc_i17(psel_spi17), 
  .wb_ack_o17(pready_spi17), 
  .wb_err_o17(), 
  .wb_int_o17(SPI_int17),

  // SPI17 signals17
  .ss_pad_o17(n_ss_out17), 
  .sclk_pad_o17(sclk_out17), 
  .mosi_pad_o17(mo17), 
  .miso_pad_i17(mi17)
);

// Opencores17 UART17 instances17
wire ua_nrts_int17;
wire ua_nrts1_int17;

assign ua_nrts17 = ua_nrts_int17;
assign ua_nrts117 = ua_nrts1_int17;

reg [3:0] uart0_sel_i17;
reg [3:0] uart1_sel_i17;
// UART17 registers are all 8-bit wide17, and their17 addresses17
// are on byte boundaries17. So17 to access them17 on the
// Wishbone17 bus, the CPU17 must do byte accesses to these17
// byte addresses17. Word17 address accesses are not possible17
// because the word17 addresses17 will be unaligned17, and cause
// a fault17.
// So17, Uart17 accesses from the CPU17 will always be 8-bit size
// We17 only have to decide17 which byte of the 4-byte word17 the
// CPU17 is interested17 in.
`ifdef SYSTEM_BIG_ENDIAN17
always @(paddr17) begin
  case (paddr17[1:0])
    2'b00 : uart0_sel_i17 = 4'b1000;
    2'b01 : uart0_sel_i17 = 4'b0100;
    2'b10 : uart0_sel_i17 = 4'b0010;
    2'b11 : uart0_sel_i17 = 4'b0001;
  endcase
end
always @(paddr17) begin
  case (paddr17[1:0])
    2'b00 : uart1_sel_i17 = 4'b1000;
    2'b01 : uart1_sel_i17 = 4'b0100;
    2'b10 : uart1_sel_i17 = 4'b0010;
    2'b11 : uart1_sel_i17 = 4'b0001;
  endcase
end
`else
always @(paddr17) begin
  case (paddr17[1:0])
    2'b00 : uart0_sel_i17 = 4'b0001;
    2'b01 : uart0_sel_i17 = 4'b0010;
    2'b10 : uart0_sel_i17 = 4'b0100;
    2'b11 : uart0_sel_i17 = 4'b1000;
  endcase
end
always @(paddr17) begin
  case (paddr17[1:0])
    2'b00 : uart1_sel_i17 = 4'b0001;
    2'b01 : uart1_sel_i17 = 4'b0010;
    2'b10 : uart1_sel_i17 = 4'b0100;
    2'b11 : uart1_sel_i17 = 4'b1000;
  endcase
end
`endif

uart_top17 i_oc_uart017 (
  .wb_clk_i17(pclk17),
  .wb_rst_i17(~n_preset17),
  .wb_adr_i17(paddr17[4:0]),
  .wb_dat_i17(pwdata17),
  .wb_dat_o17(prdata_uart017),
  .wb_we_i17(pwrite17),
  .wb_stb_i17(psel_uart017),
  .wb_cyc_i17(psel_uart017),
  .wb_ack_o17(pready_uart017),
  .wb_sel_i17(uart0_sel_i17),
  .int_o17(UART_int17),
  .stx_pad_o17(ua_txd17),
  .srx_pad_i17(ua_rxd17),
  .rts_pad_o17(ua_nrts_int17),
  .cts_pad_i17(ua_ncts17),
  .dtr_pad_o17(),
  .dsr_pad_i17(1'b0),
  .ri_pad_i17(1'b0),
  .dcd_pad_i17(1'b0)
);

uart_top17 i_oc_uart117 (
  .wb_clk_i17(pclk17),
  .wb_rst_i17(~n_preset17),
  .wb_adr_i17(paddr17[4:0]),
  .wb_dat_i17(pwdata17),
  .wb_dat_o17(prdata_uart117),
  .wb_we_i17(pwrite17),
  .wb_stb_i17(psel_uart117),
  .wb_cyc_i17(psel_uart117),
  .wb_ack_o17(pready_uart117),
  .wb_sel_i17(uart1_sel_i17),
  .int_o17(UART_int117),
  .stx_pad_o17(ua_txd117),
  .srx_pad_i17(ua_rxd117),
  .rts_pad_o17(ua_nrts1_int17),
  .cts_pad_i17(ua_ncts117),
  .dtr_pad_o17(),
  .dsr_pad_i17(1'b0),
  .ri_pad_i17(1'b0),
  .dcd_pad_i17(1'b0)
);

gpio_veneer17 i_gpio_veneer17 (
        //inputs17

        . n_p_reset17(n_preset17),
        . pclk17(pclk17),
        . psel17(psel_gpio17),
        . penable17(penable17),
        . pwrite17(pwrite17),
        . paddr17(paddr17[5:0]),
        . pwdata17(pwdata17),
        . gpio_pin_in17(gpio_pin_in17),
        . scan_en17(scan_en17),
        . tri_state_enable17(tri_state_enable17),
        . scan_in17(), //added by smarkov17 for dft17

        //outputs17
        . scan_out17(), //added by smarkov17 for dft17
        . prdata17(prdata_gpio17),
        . gpio_int17(GPIO_int17),
        . n_gpio_pin_oe17(n_gpio_pin_oe17),
        . gpio_pin_out17(gpio_pin_out17)
);


ttc_veneer17 i_ttc_veneer17 (

         //inputs17
        . n_p_reset17(n_preset17),
        . pclk17(pclk17),
        . psel17(psel_ttc17),
        . penable17(penable17),
        . pwrite17(pwrite17),
        . pwdata17(pwdata17),
        . paddr17(paddr17[7:0]),
        . scan_in17(),
        . scan_en17(scan_en17),

        //outputs17
        . prdata17(prdata_ttc17),
        . interrupt17(TTC_int17[3:1]),
        . scan_out17()
);


smc_veneer17 i_smc_veneer17 (
        //inputs17
	//apb17 inputs17
        . n_preset17(n_preset17),
        . pclk17(pclk_SRPG_smc17),
        . psel17(psel_smc17),
        . penable17(penable17),
        . pwrite17(pwrite17),
        . paddr17(paddr17[4:0]),
        . pwdata17(pwdata17),
        //ahb17 inputs17
	. hclk17(smc_hclk17),
        . n_sys_reset17(rstn_non_srpg_smc17),
        . haddr17(smc_haddr17),
        . htrans17(smc_htrans17),
        . hsel17(smc_hsel_int17),
        . hwrite17(smc_hwrite17),
	. hsize17(smc_hsize17),
        . hwdata17(smc_hwdata17),
        . hready17(smc_hready_in17),
        . data_smc17(data_smc17),

         //test signal17 inputs17

        . scan_in_117(),
        . scan_in_217(),
        . scan_in_317(),
        . scan_en17(scan_en17),

        //apb17 outputs17
        . prdata17(prdata_smc17),

       //design output

        . smc_hrdata17(smc_hrdata17),
        . smc_hready17(smc_hready17),
        . smc_hresp17(smc_hresp17),
        . smc_valid17(smc_valid17),
        . smc_addr17(smc_addr_int17),
        . smc_data17(smc_data17),
        . smc_n_be17(smc_n_be17),
        . smc_n_cs17(smc_n_cs17),
        . smc_n_wr17(smc_n_wr17),
        . smc_n_we17(smc_n_we17),
        . smc_n_rd17(smc_n_rd17),
        . smc_n_ext_oe17(smc_n_ext_oe17),
        . smc_busy17(smc_busy17),

         //test signal17 output
        . scan_out_117(),
        . scan_out_217(),
        . scan_out_317()
);

power_ctrl_veneer17 i_power_ctrl_veneer17 (
    // -- Clocks17 & Reset17
    	.pclk17(pclk17), 			//  : in  std_logic17;
    	.nprst17(n_preset17), 		//  : in  std_logic17;
    // -- APB17 programming17 interface
    	.paddr17(paddr17), 			//  : in  std_logic_vector17(31 downto17 0);
    	.psel17(psel_pmc17), 			//  : in  std_logic17;
    	.penable17(penable17), 		//  : in  std_logic17;
    	.pwrite17(pwrite17), 		//  : in  std_logic17;
    	.pwdata17(pwdata17), 		//  : in  std_logic_vector17(31 downto17 0);
    	.prdata17(prdata_pmc17), 		//  : out std_logic_vector17(31 downto17 0);
        .macb3_wakeup17(macb3_wakeup17),
        .macb2_wakeup17(macb2_wakeup17),
        .macb1_wakeup17(macb1_wakeup17),
        .macb0_wakeup17(macb0_wakeup17),
    // -- Module17 control17 outputs17
    	.scan_in17(),			//  : in  std_logic17;
    	.scan_en17(scan_en17),             	//  : in  std_logic17;
    	.scan_mode17(scan_mode17),          //  : in  std_logic17;
    	.scan_out17(),            	//  : out std_logic17;
        .int_source_h17(int_source_h17),
     	.rstn_non_srpg_smc17(rstn_non_srpg_smc17), 		//   : out std_logic17;
    	.gate_clk_smc17(gate_clk_smc17), 	//  : out std_logic17;
    	.isolate_smc17(isolate_smc17), 	//  : out std_logic17;
    	.save_edge_smc17(save_edge_smc17), 	//  : out std_logic17;
    	.restore_edge_smc17(restore_edge_smc17), 	//  : out std_logic17;
    	.pwr1_on_smc17(pwr1_on_smc17), 	//  : out std_logic17;
    	.pwr2_on_smc17(pwr2_on_smc17), 	//  : out std_logic17
     	.rstn_non_srpg_urt17(rstn_non_srpg_urt17), 		//   : out std_logic17;
    	.gate_clk_urt17(gate_clk_urt17), 	//  : out std_logic17;
    	.isolate_urt17(isolate_urt17), 	//  : out std_logic17;
    	.save_edge_urt17(save_edge_urt17), 	//  : out std_logic17;
    	.restore_edge_urt17(restore_edge_urt17), 	//  : out std_logic17;
    	.pwr1_on_urt17(pwr1_on_urt17), 	//  : out std_logic17;
    	.pwr2_on_urt17(pwr2_on_urt17),  	//  : out std_logic17
        // ETH017
        .rstn_non_srpg_macb017(rstn_non_srpg_macb017),
        .gate_clk_macb017(gate_clk_macb017),
        .isolate_macb017(isolate_macb017),
        .save_edge_macb017(save_edge_macb017),
        .restore_edge_macb017(restore_edge_macb017),
        .pwr1_on_macb017(pwr1_on_macb017),
        .pwr2_on_macb017(pwr2_on_macb017),
        // ETH117
        .rstn_non_srpg_macb117(rstn_non_srpg_macb117),
        .gate_clk_macb117(gate_clk_macb117),
        .isolate_macb117(isolate_macb117),
        .save_edge_macb117(save_edge_macb117),
        .restore_edge_macb117(restore_edge_macb117),
        .pwr1_on_macb117(pwr1_on_macb117),
        .pwr2_on_macb117(pwr2_on_macb117),
        // ETH217
        .rstn_non_srpg_macb217(rstn_non_srpg_macb217),
        .gate_clk_macb217(gate_clk_macb217),
        .isolate_macb217(isolate_macb217),
        .save_edge_macb217(save_edge_macb217),
        .restore_edge_macb217(restore_edge_macb217),
        .pwr1_on_macb217(pwr1_on_macb217),
        .pwr2_on_macb217(pwr2_on_macb217),
        // ETH317
        .rstn_non_srpg_macb317(rstn_non_srpg_macb317),
        .gate_clk_macb317(gate_clk_macb317),
        .isolate_macb317(isolate_macb317),
        .save_edge_macb317(save_edge_macb317),
        .restore_edge_macb317(restore_edge_macb317),
        .pwr1_on_macb317(pwr1_on_macb317),
        .pwr2_on_macb317(pwr2_on_macb317),
        .core06v17(core06v17),
        .core08v17(core08v17),
        .core10v17(core10v17),
        .core12v17(core12v17),
        .pcm_macb_wakeup_int17(pcm_macb_wakeup_int17),
        .isolate_mem17(isolate_mem17),
        .mte_smc_start17(mte_smc_start17),
        .mte_uart_start17(mte_uart_start17),
        .mte_smc_uart_start17(mte_smc_uart_start17),  
        .mte_pm_smc_to_default_start17(mte_pm_smc_to_default_start17), 
        .mte_pm_uart_to_default_start17(mte_pm_uart_to_default_start17),
        .mte_pm_smc_uart_to_default_start17(mte_pm_smc_uart_to_default_start17)
);

// Clock17 gating17 macro17 to shut17 off17 clocks17 to the SRPG17 flops17 in the SMC17
//CKLNQD117 i_SMC_SRPG_clk_gate17  (
//	.TE17(scan_mode17), 
//	.E17(~gate_clk_smc17), 
//	.CP17(pclk17), 
//	.Q17(pclk_SRPG_smc17)
//	);
// Replace17 gate17 with behavioural17 code17 //
wire 	smc_scan_gate17;
reg 	smc_latched_enable17;
assign smc_scan_gate17 = scan_mode17 ? 1'b1 : ~gate_clk_smc17;

always @ (pclk17 or smc_scan_gate17)
  	if (pclk17 == 1'b0) begin
  		smc_latched_enable17 <= smc_scan_gate17;
  	end  	
	
assign pclk_SRPG_smc17 = smc_latched_enable17 ? pclk17 : 1'b0;


// Clock17 gating17 macro17 to shut17 off17 clocks17 to the SRPG17 flops17 in the URT17
//CKLNQD117 i_URT_SRPG_clk_gate17  (
//	.TE17(scan_mode17), 
//	.E17(~gate_clk_urt17), 
//	.CP17(pclk17), 
//	.Q17(pclk_SRPG_urt17)
//	);
// Replace17 gate17 with behavioural17 code17 //
wire 	urt_scan_gate17;
reg 	urt_latched_enable17;
assign urt_scan_gate17 = scan_mode17 ? 1'b1 : ~gate_clk_urt17;

always @ (pclk17 or urt_scan_gate17)
  	if (pclk17 == 1'b0) begin
  		urt_latched_enable17 <= urt_scan_gate17;
  	end  	
	
assign pclk_SRPG_urt17 = urt_latched_enable17 ? pclk17 : 1'b0;

// ETH017
wire 	macb0_scan_gate17;
reg 	macb0_latched_enable17;
assign macb0_scan_gate17 = scan_mode17 ? 1'b1 : ~gate_clk_macb017;

always @ (pclk17 or macb0_scan_gate17)
  	if (pclk17 == 1'b0) begin
  		macb0_latched_enable17 <= macb0_scan_gate17;
  	end  	
	
assign clk_SRPG_macb0_en17 = macb0_latched_enable17 ? 1'b1 : 1'b0;

// ETH117
wire 	macb1_scan_gate17;
reg 	macb1_latched_enable17;
assign macb1_scan_gate17 = scan_mode17 ? 1'b1 : ~gate_clk_macb117;

always @ (pclk17 or macb1_scan_gate17)
  	if (pclk17 == 1'b0) begin
  		macb1_latched_enable17 <= macb1_scan_gate17;
  	end  	
	
assign clk_SRPG_macb1_en17 = macb1_latched_enable17 ? 1'b1 : 1'b0;

// ETH217
wire 	macb2_scan_gate17;
reg 	macb2_latched_enable17;
assign macb2_scan_gate17 = scan_mode17 ? 1'b1 : ~gate_clk_macb217;

always @ (pclk17 or macb2_scan_gate17)
  	if (pclk17 == 1'b0) begin
  		macb2_latched_enable17 <= macb2_scan_gate17;
  	end  	
	
assign clk_SRPG_macb2_en17 = macb2_latched_enable17 ? 1'b1 : 1'b0;

// ETH317
wire 	macb3_scan_gate17;
reg 	macb3_latched_enable17;
assign macb3_scan_gate17 = scan_mode17 ? 1'b1 : ~gate_clk_macb317;

always @ (pclk17 or macb3_scan_gate17)
  	if (pclk17 == 1'b0) begin
  		macb3_latched_enable17 <= macb3_scan_gate17;
  	end  	
	
assign clk_SRPG_macb3_en17 = macb3_latched_enable17 ? 1'b1 : 1'b0;



`else
//------------------------------------------------------------------------------
// if the APB17 subsystem17 is black17 boxed17 
//------------------------------------------------------------------------------
// wire s ports17
    // system signals17
    wire         hclk17;     // AHB17 Clock17
    wire         n_hreset17;  // AHB17 reset - Active17 low17
    wire         pclk17;     // APB17 Clock17. 
    wire         n_preset17;  // APB17 reset - Active17 low17

    // AHB17 interface
    wire         ahb2apb0_hsel17;     // AHB2APB17 select17
    wire  [31:0] haddr17;    // Address bus
    wire  [1:0]  htrans17;   // Transfer17 type
    wire  [2:0]  hsize17;    // AHB17 Access type - byte, half17-word17, word17
    wire  [31:0] hwdata17;   // Write data
    wire         hwrite17;   // Write signal17/
    wire         hready_in17;// Indicates17 that last master17 has finished17 bus access
    wire [2:0]   hburst17;     // Burst type
    wire [3:0]   hprot17;      // Protection17 control17
    wire [3:0]   hmaster17;    // Master17 select17
    wire         hmastlock17;  // Locked17 transfer17
  // Interrupts17 from the Enet17 MACs17
    wire         macb0_int17;
    wire         macb1_int17;
    wire         macb2_int17;
    wire         macb3_int17;
  // Interrupt17 from the DMA17
    wire         DMA_irq17;
  // Scan17 wire s
    wire         scan_en17;    // Scan17 enable pin17
    wire         scan_in_117;  // Scan17 wire  for first chain17
    wire         scan_in_217;  // Scan17 wire  for second chain17
    wire         scan_mode17;  // test mode pin17
 
  //wire  for smc17 AHB17 interface
    wire         smc_hclk17;
    wire         smc_n_hclk17;
    wire  [31:0] smc_haddr17;
    wire  [1:0]  smc_htrans17;
    wire         smc_hsel17;
    wire         smc_hwrite17;
    wire  [2:0]  smc_hsize17;
    wire  [31:0] smc_hwdata17;
    wire         smc_hready_in17;
    wire  [2:0]  smc_hburst17;     // Burst type
    wire  [3:0]  smc_hprot17;      // Protection17 control17
    wire  [3:0]  smc_hmaster17;    // Master17 select17
    wire         smc_hmastlock17;  // Locked17 transfer17


    wire  [31:0] data_smc17;     // EMI17(External17 memory) read data
    
  //wire s for uart17
    wire         ua_rxd17;       // UART17 receiver17 serial17 wire  pin17
    wire         ua_rxd117;      // UART17 receiver17 serial17 wire  pin17
    wire         ua_ncts17;      // Clear-To17-Send17 flow17 control17
    wire         ua_ncts117;      // Clear-To17-Send17 flow17 control17
   //wire s for spi17
    wire         n_ss_in17;      // select17 wire  to slave17
    wire         mi17;           // data wire  to master17
    wire         si17;           // data wire  to slave17
    wire         sclk_in17;      // clock17 wire  to slave17
  //wire s for GPIO17
   wire  [GPIO_WIDTH17-1:0]  gpio_pin_in17;             // wire  data from pin17

  //reg    ports17
  // Scan17 reg   s
   reg           scan_out_117;   // Scan17 out for chain17 1
   reg           scan_out_217;   // Scan17 out for chain17 2
  //AHB17 interface 
   reg    [31:0] hrdata17;       // Read data provided from target slave17
   reg           hready17;       // Ready17 for new bus cycle from target slave17
   reg    [1:0]  hresp17;       // Response17 from the bridge17

   // SMC17 reg    for AHB17 interface
   reg    [31:0]    smc_hrdata17;
   reg              smc_hready17;
   reg    [1:0]     smc_hresp17;

  //reg   s from smc17
   reg    [15:0]    smc_addr17;      // External17 Memory (EMI17) address
   reg    [3:0]     smc_n_be17;      // EMI17 byte enables17 (Active17 LOW17)
   reg    [7:0]     smc_n_cs17;      // EMI17 Chip17 Selects17 (Active17 LOW17)
   reg    [3:0]     smc_n_we17;      // EMI17 write strobes17 (Active17 LOW17)
   reg              smc_n_wr17;      // EMI17 write enable (Active17 LOW17)
   reg              smc_n_rd17;      // EMI17 read stobe17 (Active17 LOW17)
   reg              smc_n_ext_oe17;  // EMI17 write data reg    enable
   reg    [31:0]    smc_data17;      // EMI17 write data
  //reg   s from uart17
   reg           ua_txd17;       	// UART17 transmitter17 serial17 reg   
   reg           ua_txd117;       // UART17 transmitter17 serial17 reg   
   reg           ua_nrts17;      	// Request17-To17-Send17 flow17 control17
   reg           ua_nrts117;      // Request17-To17-Send17 flow17 control17
   // reg   s from ttc17
  // reg   s from SPI17
   reg       so;                    // data reg    from slave17
   reg       mo17;                    // data reg    from master17
   reg       sclk_out17;              // clock17 reg    from master17
   reg    [P_SIZE17-1:0] n_ss_out17;    // peripheral17 select17 lines17 from master17
   reg       n_so_en17;               // out enable for slave17 data
   reg       n_mo_en17;               // out enable for master17 data
   reg       n_sclk_en17;             // out enable for master17 clock17
   reg       n_ss_en17;               // out enable for master17 peripheral17 lines17
  //reg   s from gpio17
   reg    [GPIO_WIDTH17-1:0]     n_gpio_pin_oe17;           // reg    enable signal17 to pin17
   reg    [GPIO_WIDTH17-1:0]     gpio_pin_out17;            // reg    signal17 to pin17


`endif
//------------------------------------------------------------------------------
// black17 boxed17 defines17 
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// APB17 and AHB17 interface formal17 verification17 monitors17
//------------------------------------------------------------------------------
`ifdef ABV_ON17
apb_assert17 i_apb_assert17 (

        // APB17 signals17
  	.n_preset17(n_preset17),
   	.pclk17(pclk17),
	.penable17(penable17),
	.paddr17(paddr17),
	.pwrite17(pwrite17),
	.pwdata17(pwdata17),

	.psel0017(psel_spi17),
	.psel0117(psel_uart017),
	.psel0217(psel_gpio17),
	.psel0317(psel_ttc17),
	.psel0417(1'b0),
	.psel0517(psel_smc17),
	.psel0617(1'b0),
	.psel0717(1'b0),
	.psel0817(1'b0),
	.psel0917(1'b0),
	.psel1017(1'b0),
	.psel1117(1'b0),
	.psel1217(1'b0),
	.psel1317(psel_pmc17),
	.psel1417(psel_apic17),
	.psel1517(psel_uart117),

        .prdata0017(prdata_spi17),
        .prdata0117(prdata_uart017), // Read Data from peripheral17 UART17 
        .prdata0217(prdata_gpio17), // Read Data from peripheral17 GPIO17
        .prdata0317(prdata_ttc17), // Read Data from peripheral17 TTC17
        .prdata0417(32'b0), // 
        .prdata0517(prdata_smc17), // Read Data from peripheral17 SMC17
        .prdata1317(prdata_pmc17), // Read Data from peripheral17 Power17 Control17 Block
   	.prdata1417(32'b0), // 
        .prdata1517(prdata_uart117),


        // AHB17 signals17
        .hclk17(hclk17),         // ahb17 system clock17
        .n_hreset17(n_hreset17), // ahb17 system reset

        // ahb2apb17 signals17
        .hresp17(hresp17),
        .hready17(hready17),
        .hrdata17(hrdata17),
        .hwdata17(hwdata17),
        .hprot17(hprot17),
        .hburst17(hburst17),
        .hsize17(hsize17),
        .hwrite17(hwrite17),
        .htrans17(htrans17),
        .haddr17(haddr17),
        .ahb2apb_hsel17(ahb2apb0_hsel17));



//------------------------------------------------------------------------------
// AHB17 interface formal17 verification17 monitor17
//------------------------------------------------------------------------------
defparam i_ahbSlaveMonitor17.DBUS_WIDTH17 = 32;
defparam i_ahbMasterMonitor17.DBUS_WIDTH17 = 32;


// AHB2APB17 Bridge17

    ahb_liteslave_monitor17 i_ahbSlaveMonitor17 (
        .hclk_i17(hclk17),
        .hresetn_i17(n_hreset17),
        .hresp17(hresp17),
        .hready17(hready17),
        .hready_global_i17(hready17),
        .hrdata17(hrdata17),
        .hwdata_i17(hwdata17),
        .hburst_i17(hburst17),
        .hsize_i17(hsize17),
        .hwrite_i17(hwrite17),
        .htrans_i17(htrans17),
        .haddr_i17(haddr17),
        .hsel_i17(ahb2apb0_hsel17)
    );


  ahb_litemaster_monitor17 i_ahbMasterMonitor17 (
          .hclk_i17(hclk17),
          .hresetn_i17(n_hreset17),
          .hresp_i17(hresp17),
          .hready_i17(hready17),
          .hrdata_i17(hrdata17),
          .hlock17(1'b0),
          .hwdata17(hwdata17),
          .hprot17(hprot17),
          .hburst17(hburst17),
          .hsize17(hsize17),
          .hwrite17(hwrite17),
          .htrans17(htrans17),
          .haddr17(haddr17)
          );







`endif




`ifdef IFV_LP_ABV_ON17
// power17 control17
wire isolate17;

// testbench mirror signals17
wire L1_ctrl_access17;
wire L1_status_access17;

wire [31:0] L1_status_reg17;
wire [31:0] L1_ctrl_reg17;

//wire rstn_non_srpg_urt17;
//wire isolate_urt17;
//wire retain_urt17;
//wire gate_clk_urt17;
//wire pwr1_on_urt17;


// smc17 signals17
wire [31:0] smc_prdata17;
wire lp_clk_smc17;
                    

// uart17 isolation17 register
  wire [15:0] ua_prdata17;
  wire ua_int17;
  assign ua_prdata17          =  i_uart1_veneer17.prdata17;
  assign ua_int17             =  i_uart1_veneer17.ua_int17;


assign lp_clk_smc17          = i_smc_veneer17.pclk17;
assign smc_prdata17          = i_smc_veneer17.prdata17;
lp_chk_smc17 u_lp_chk_smc17 (
    .clk17 (hclk17),
    .rst17 (n_hreset17),
    .iso_smc17 (isolate_smc17),
    .gate_clk17 (gate_clk_smc17),
    .lp_clk17 (pclk_SRPG_smc17),

    // srpg17 outputs17
    .smc_hrdata17 (smc_hrdata17),
    .smc_hready17 (smc_hready17),
    .smc_hresp17  (smc_hresp17),
    .smc_valid17 (smc_valid17),
    .smc_addr_int17 (smc_addr_int17),
    .smc_data17 (smc_data17),
    .smc_n_be17 (smc_n_be17),
    .smc_n_cs17  (smc_n_cs17),
    .smc_n_wr17 (smc_n_wr17),
    .smc_n_we17 (smc_n_we17),
    .smc_n_rd17 (smc_n_rd17),
    .smc_n_ext_oe17 (smc_n_ext_oe17)
   );

// lp17 retention17/isolation17 assertions17
lp_chk_uart17 u_lp_chk_urt17 (

  .clk17         (hclk17),
  .rst17         (n_hreset17),
  .iso_urt17     (isolate_urt17),
  .gate_clk17    (gate_clk_urt17),
  .lp_clk17      (pclk_SRPG_urt17),
  //ports17
  .prdata17 (ua_prdata17),
  .ua_int17 (ua_int17),
  .ua_txd17 (ua_txd117),
  .ua_nrts17 (ua_nrts117)
 );

`endif  //IFV_LP_ABV_ON17




endmodule
