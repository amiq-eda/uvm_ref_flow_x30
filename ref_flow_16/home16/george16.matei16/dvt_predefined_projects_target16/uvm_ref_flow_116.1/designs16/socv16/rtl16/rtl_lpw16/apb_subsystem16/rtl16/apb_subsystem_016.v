//File16 name   : apb_subsystem_016.v
//Title16       : 
//Created16     : 1999
//Description16 : 
//Notes16       : 
//----------------------------------------------------------------------
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

module apb_subsystem_016(
    // AHB16 interface
    hclk16,
    n_hreset16,
    hsel16,
    haddr16,
    htrans16,
    hsize16,
    hwrite16,
    hwdata16,
    hready_in16,
    hburst16,
    hprot16,
    hmaster16,
    hmastlock16,
    hrdata16,
    hready16,
    hresp16,
    
    // APB16 system interface
    pclk16,
    n_preset16,
    
    // SPI16 ports16
    n_ss_in16,
    mi16,
    si16,
    sclk_in16,
    so,
    mo16,
    sclk_out16,
    n_ss_out16,
    n_so_en16,
    n_mo_en16,
    n_sclk_en16,
    n_ss_en16,
    
    //UART016 ports16
    ua_rxd16,
    ua_ncts16,
    ua_txd16,
    ua_nrts16,
    
    //UART116 ports16
    ua_rxd116,
    ua_ncts116,
    ua_txd116,
    ua_nrts116,
    
    //GPIO16 ports16
    gpio_pin_in16,
    n_gpio_pin_oe16,
    gpio_pin_out16,
    

    //SMC16 ports16
    smc_hclk16,
    smc_n_hclk16,
    smc_haddr16,
    smc_htrans16,
    smc_hsel16,
    smc_hwrite16,
    smc_hsize16,
    smc_hwdata16,
    smc_hready_in16,
    smc_hburst16,
    smc_hprot16,
    smc_hmaster16,
    smc_hmastlock16,
    smc_hrdata16, 
    smc_hready16,
    smc_hresp16,
    smc_n_ext_oe16,
    smc_data16,
    smc_addr16,
    smc_n_be16,
    smc_n_cs16, 
    smc_n_we16,
    smc_n_wr16,
    smc_n_rd16,
    data_smc16,
    
    //PMC16 ports16
    clk_SRPG_macb0_en16,
    clk_SRPG_macb1_en16,
    clk_SRPG_macb2_en16,
    clk_SRPG_macb3_en16,
    core06v16,
    core08v16,
    core10v16,
    core12v16,
    macb3_wakeup16,
    macb2_wakeup16,
    macb1_wakeup16,
    macb0_wakeup16,
    mte_smc_start16,
    mte_uart_start16,
    mte_smc_uart_start16,  
    mte_pm_smc_to_default_start16, 
    mte_pm_uart_to_default_start16,
    mte_pm_smc_uart_to_default_start16,
    
    
    // Peripheral16 inerrupts16
    pcm_irq16,
    ttc_irq16,
    gpio_irq16,
    uart0_irq16,
    uart1_irq16,
    spi_irq16,
    DMA_irq16,      
    macb0_int16,
    macb1_int16,
    macb2_int16,
    macb3_int16,
   
    // Scan16 ports16
    scan_en16,      // Scan16 enable pin16
    scan_in_116,    // Scan16 input for first chain16
    scan_in_216,    // Scan16 input for second chain16
    scan_mode16,
    scan_out_116,   // Scan16 out for chain16 1
    scan_out_216    // Scan16 out for chain16 2
);

parameter GPIO_WIDTH16 = 16;        // GPIO16 width
parameter P_SIZE16 =   8;              // number16 of peripheral16 select16 lines16
parameter NO_OF_IRQS16  = 17;      //No of irqs16 read by apic16 

// AHB16 interface
input         hclk16;     // AHB16 Clock16
input         n_hreset16;  // AHB16 reset - Active16 low16
input         hsel16;     // AHB2APB16 select16
input [31:0]  haddr16;    // Address bus
input [1:0]   htrans16;   // Transfer16 type
input [2:0]   hsize16;    // AHB16 Access type - byte, half16-word16, word16
input [31:0]  hwdata16;   // Write data
input         hwrite16;   // Write signal16/
input         hready_in16;// Indicates16 that last master16 has finished16 bus access
input [2:0]   hburst16;     // Burst type
input [3:0]   hprot16;      // Protection16 control16
input [3:0]   hmaster16;    // Master16 select16
input         hmastlock16;  // Locked16 transfer16
output [31:0] hrdata16;       // Read data provided from target slave16
output        hready16;       // Ready16 for new bus cycle from target slave16
output [1:0]  hresp16;       // Response16 from the bridge16
    
// APB16 system interface
input         pclk16;     // APB16 Clock16. 
input         n_preset16;  // APB16 reset - Active16 low16
   
// SPI16 ports16
input     n_ss_in16;      // select16 input to slave16
input     mi16;           // data input to master16
input     si16;           // data input to slave16
input     sclk_in16;      // clock16 input to slave16
output    so;                    // data output from slave16
output    mo16;                    // data output from master16
output    sclk_out16;              // clock16 output from master16
output [P_SIZE16-1:0] n_ss_out16;    // peripheral16 select16 lines16 from master16
output    n_so_en16;               // out enable for slave16 data
output    n_mo_en16;               // out enable for master16 data
output    n_sclk_en16;             // out enable for master16 clock16
output    n_ss_en16;               // out enable for master16 peripheral16 lines16

//UART016 ports16
input        ua_rxd16;       // UART16 receiver16 serial16 input pin16
input        ua_ncts16;      // Clear-To16-Send16 flow16 control16
output       ua_txd16;       	// UART16 transmitter16 serial16 output
output       ua_nrts16;      	// Request16-To16-Send16 flow16 control16

// UART116 ports16   
input        ua_rxd116;      // UART16 receiver16 serial16 input pin16
input        ua_ncts116;      // Clear-To16-Send16 flow16 control16
output       ua_txd116;       // UART16 transmitter16 serial16 output
output       ua_nrts116;      // Request16-To16-Send16 flow16 control16

//GPIO16 ports16
input [GPIO_WIDTH16-1:0]      gpio_pin_in16;             // input data from pin16
output [GPIO_WIDTH16-1:0]     n_gpio_pin_oe16;           // output enable signal16 to pin16
output [GPIO_WIDTH16-1:0]     gpio_pin_out16;            // output signal16 to pin16
  
//SMC16 ports16
input        smc_hclk16;
input        smc_n_hclk16;
input [31:0] smc_haddr16;
input [1:0]  smc_htrans16;
input        smc_hsel16;
input        smc_hwrite16;
input [2:0]  smc_hsize16;
input [31:0] smc_hwdata16;
input        smc_hready_in16;
input [2:0]  smc_hburst16;     // Burst type
input [3:0]  smc_hprot16;      // Protection16 control16
input [3:0]  smc_hmaster16;    // Master16 select16
input        smc_hmastlock16;  // Locked16 transfer16
input [31:0] data_smc16;     // EMI16(External16 memory) read data
output [31:0]    smc_hrdata16;
output           smc_hready16;
output [1:0]     smc_hresp16;
output [15:0]    smc_addr16;      // External16 Memory (EMI16) address
output [3:0]     smc_n_be16;      // EMI16 byte enables16 (Active16 LOW16)
output           smc_n_cs16;      // EMI16 Chip16 Selects16 (Active16 LOW16)
output [3:0]     smc_n_we16;      // EMI16 write strobes16 (Active16 LOW16)
output           smc_n_wr16;      // EMI16 write enable (Active16 LOW16)
output           smc_n_rd16;      // EMI16 read stobe16 (Active16 LOW16)
output           smc_n_ext_oe16;  // EMI16 write data output enable
output [31:0]    smc_data16;      // EMI16 write data
       
//PMC16 ports16
output clk_SRPG_macb0_en16;
output clk_SRPG_macb1_en16;
output clk_SRPG_macb2_en16;
output clk_SRPG_macb3_en16;
output core06v16;
output core08v16;
output core10v16;
output core12v16;
output mte_smc_start16;
output mte_uart_start16;
output mte_smc_uart_start16;  
output mte_pm_smc_to_default_start16; 
output mte_pm_uart_to_default_start16;
output mte_pm_smc_uart_to_default_start16;
input macb3_wakeup16;
input macb2_wakeup16;
input macb1_wakeup16;
input macb0_wakeup16;
    

// Peripheral16 interrupts16
output pcm_irq16;
output [2:0] ttc_irq16;
output gpio_irq16;
output uart0_irq16;
output uart1_irq16;
output spi_irq16;
input        macb0_int16;
input        macb1_int16;
input        macb2_int16;
input        macb3_int16;
input        DMA_irq16;
  
//Scan16 ports16
input        scan_en16;    // Scan16 enable pin16
input        scan_in_116;  // Scan16 input for first chain16
input        scan_in_216;  // Scan16 input for second chain16
input        scan_mode16;  // test mode pin16
 output        scan_out_116;   // Scan16 out for chain16 1
 output        scan_out_216;   // Scan16 out for chain16 2  

//------------------------------------------------------------------------------
// if the ROM16 subsystem16 is NOT16 black16 boxed16 
//------------------------------------------------------------------------------
`ifndef FV_KIT_BLACK_BOX_APB_SUBSYSTEM16
   
   wire        hsel16; 
   wire        pclk16;
   wire        n_preset16;
   wire [31:0] prdata_spi16;
   wire [31:0] prdata_uart016;
   wire [31:0] prdata_gpio16;
   wire [31:0] prdata_ttc16;
   wire [31:0] prdata_smc16;
   wire [31:0] prdata_pmc16;
   wire [31:0] prdata_uart116;
   wire        pready_spi16;
   wire        pready_uart016;
   wire        pready_uart116;
   wire        tie_hi_bit16;
   wire  [31:0] hrdata16; 
   wire         hready16;
   wire         hready_in16;
   wire  [1:0]  hresp16;   
   wire  [31:0] pwdata16;  
   wire         pwrite16;
   wire  [31:0] paddr16;  
   wire   psel_spi16;
   wire   psel_uart016;
   wire   psel_gpio16;
   wire   psel_ttc16;
   wire   psel_smc16;
   wire   psel0716;
   wire   psel0816;
   wire   psel0916;
   wire   psel1016;
   wire   psel1116;
   wire   psel1216;
   wire   psel_pmc16;
   wire   psel_uart116;
   wire   penable16;
   wire   [NO_OF_IRQS16:0] int_source16;     // System16 Interrupt16 Sources16
   wire [1:0]             smc_hresp16;     // AHB16 Response16 signal16
   wire                   smc_valid16;     // Ack16 valid address

  //External16 memory interface (EMI16)
  wire [31:0]            smc_addr_int16;  // External16 Memory (EMI16) address
  wire [3:0]             smc_n_be16;      // EMI16 byte enables16 (Active16 LOW16)
  wire                   smc_n_cs16;      // EMI16 Chip16 Selects16 (Active16 LOW16)
  wire [3:0]             smc_n_we16;      // EMI16 write strobes16 (Active16 LOW16)
  wire                   smc_n_wr16;      // EMI16 write enable (Active16 LOW16)
  wire                   smc_n_rd16;      // EMI16 read stobe16 (Active16 LOW16)
 
  //AHB16 Memory Interface16 Control16
  wire                   smc_hsel_int16;
  wire                   smc_busy16;      // smc16 busy
   

//scan16 signals16

   wire                scan_in_116;        //scan16 input
   wire                scan_in_216;        //scan16 input
   wire                scan_en16;         //scan16 enable
   wire                scan_out_116;       //scan16 output
   wire                scan_out_216;       //scan16 output
   wire                byte_sel16;     // byte select16 from bridge16 1=byte, 0=2byte
   wire                UART_int16;     // UART16 module interrupt16 
   wire                ua_uclken16;    // Soft16 control16 of clock16
   wire                UART_int116;     // UART16 module interrupt16 
   wire                ua_uclken116;    // Soft16 control16 of clock16
   wire  [3:1]         TTC_int16;            //Interrupt16 from PCI16 
  // inputs16 to SPI16 
   wire    ext_clk16;                // external16 clock16
   wire    SPI_int16;             // interrupt16 request
  // outputs16 from SPI16
   wire    slave_out_clk16;         // modified slave16 clock16 output
 // gpio16 generic16 inputs16 
   wire  [GPIO_WIDTH16-1:0]   n_gpio_bypass_oe16;        // bypass16 mode enable 
   wire  [GPIO_WIDTH16-1:0]   gpio_bypass_out16;         // bypass16 mode output value 
   wire  [GPIO_WIDTH16-1:0]   tri_state_enable16;   // disables16 op enable -> z 
 // outputs16 
   //amba16 outputs16 
   // gpio16 generic16 outputs16 
   wire       GPIO_int16;                // gpio_interupt16 for input pin16 change 
   wire [GPIO_WIDTH16-1:0]     gpio_bypass_in16;          // bypass16 mode input data value  
                
   wire           cpu_debug16;        // Inhibits16 watchdog16 counter 
   wire            ex_wdz_n16;         // External16 Watchdog16 zero indication16
   wire           rstn_non_srpg_smc16; 
   wire           rstn_non_srpg_urt16;
   wire           isolate_smc16;
   wire           save_edge_smc16;
   wire           restore_edge_smc16;
   wire           save_edge_urt16;
   wire           restore_edge_urt16;
   wire           pwr1_on_smc16;
   wire           pwr2_on_smc16;
   wire           pwr1_on_urt16;
   wire           pwr2_on_urt16;
   // ETH016
   wire            rstn_non_srpg_macb016;
   wire            gate_clk_macb016;
   wire            isolate_macb016;
   wire            save_edge_macb016;
   wire            restore_edge_macb016;
   wire            pwr1_on_macb016;
   wire            pwr2_on_macb016;
   // ETH116
   wire            rstn_non_srpg_macb116;
   wire            gate_clk_macb116;
   wire            isolate_macb116;
   wire            save_edge_macb116;
   wire            restore_edge_macb116;
   wire            pwr1_on_macb116;
   wire            pwr2_on_macb116;
   // ETH216
   wire            rstn_non_srpg_macb216;
   wire            gate_clk_macb216;
   wire            isolate_macb216;
   wire            save_edge_macb216;
   wire            restore_edge_macb216;
   wire            pwr1_on_macb216;
   wire            pwr2_on_macb216;
   // ETH316
   wire            rstn_non_srpg_macb316;
   wire            gate_clk_macb316;
   wire            isolate_macb316;
   wire            save_edge_macb316;
   wire            restore_edge_macb316;
   wire            pwr1_on_macb316;
   wire            pwr2_on_macb316;


   wire           pclk_SRPG_smc16;
   wire           pclk_SRPG_urt16;
   wire           gate_clk_smc16;
   wire           gate_clk_urt16;
   wire  [31:0]   tie_lo_32bit16; 
   wire  [1:0]	  tie_lo_2bit16;
   wire  	  tie_lo_1bit16;
   wire           pcm_macb_wakeup_int16;
   wire           int_source_h16;
   wire           isolate_mem16;

assign pcm_irq16 = pcm_macb_wakeup_int16;
assign ttc_irq16[2] = TTC_int16[3];
assign ttc_irq16[1] = TTC_int16[2];
assign ttc_irq16[0] = TTC_int16[1];
assign gpio_irq16 = GPIO_int16;
assign uart0_irq16 = UART_int16;
assign uart1_irq16 = UART_int116;
assign spi_irq16 = SPI_int16;

assign n_mo_en16   = 1'b0;
assign n_so_en16   = 1'b1;
assign n_sclk_en16 = 1'b0;
assign n_ss_en16   = 1'b0;

assign smc_hsel_int16 = smc_hsel16;
  assign ext_clk16  = 1'b0;
  assign int_source16 = {macb0_int16,macb1_int16, macb2_int16, macb3_int16,1'b0, pcm_macb_wakeup_int16, 1'b0, 1'b0, 1'b0, 1'b0, TTC_int16, GPIO_int16, UART_int16, UART_int116, SPI_int16, DMA_irq16};

  // interrupt16 even16 detect16 .
  // for sleep16 wake16 up -> any interrupt16 even16 and system not in hibernation16 (isolate_mem16 = 0)
  // for hibernate16 wake16 up -> gpio16 interrupt16 even16 and system in the hibernation16 (isolate_mem16 = 1)
  assign int_source_h16 =  ((|int_source16) && (!isolate_mem16)) || (isolate_mem16 && GPIO_int16) ;

  assign byte_sel16 = 1'b1;
  assign tie_hi_bit16 = 1'b1;

  assign smc_addr16 = smc_addr_int16[15:0];



  assign  n_gpio_bypass_oe16 = {GPIO_WIDTH16{1'b0}};        // bypass16 mode enable 
  assign  gpio_bypass_out16  = {GPIO_WIDTH16{1'b0}};
  assign  tri_state_enable16 = {GPIO_WIDTH16{1'b0}};
  assign  cpu_debug16 = 1'b0;
  assign  tie_lo_32bit16 = 32'b0;
  assign  tie_lo_2bit16  = 2'b0;
  assign  tie_lo_1bit16  = 1'b0;


ahb2apb16 #(
  32'h00800000, // Slave16 0 Address Range16
  32'h0080FFFF,

  32'h00810000, // Slave16 1 Address Range16
  32'h0081FFFF,

  32'h00820000, // Slave16 2 Address Range16 
  32'h0082FFFF,

  32'h00830000, // Slave16 3 Address Range16
  32'h0083FFFF,

  32'h00840000, // Slave16 4 Address Range16
  32'h0084FFFF,

  32'h00850000, // Slave16 5 Address Range16
  32'h0085FFFF,

  32'h00860000, // Slave16 6 Address Range16
  32'h0086FFFF,

  32'h00870000, // Slave16 7 Address Range16
  32'h0087FFFF,

  32'h00880000, // Slave16 8 Address Range16
  32'h0088FFFF
) i_ahb2apb16 (
     // AHB16 interface
    .hclk16(hclk16),         
    .hreset_n16(n_hreset16), 
    .hsel16(hsel16), 
    .haddr16(haddr16),        
    .htrans16(htrans16),       
    .hwrite16(hwrite16),       
    .hwdata16(hwdata16),       
    .hrdata16(hrdata16),   
    .hready16(hready16),   
    .hresp16(hresp16),     
    
     // APB16 interface
    .pclk16(pclk16),         
    .preset_n16(n_preset16),  
    .prdata016(prdata_spi16),
    .prdata116(prdata_uart016), 
    .prdata216(prdata_gpio16),  
    .prdata316(prdata_ttc16),   
    .prdata416(32'h0),   
    .prdata516(prdata_smc16),   
    .prdata616(prdata_pmc16),    
    .prdata716(32'h0),   
    .prdata816(prdata_uart116),  
    .pready016(pready_spi16),     
    .pready116(pready_uart016),   
    .pready216(tie_hi_bit16),     
    .pready316(tie_hi_bit16),     
    .pready416(tie_hi_bit16),     
    .pready516(tie_hi_bit16),     
    .pready616(tie_hi_bit16),     
    .pready716(tie_hi_bit16),     
    .pready816(pready_uart116),  
    .pwdata16(pwdata16),       
    .pwrite16(pwrite16),       
    .paddr16(paddr16),        
    .psel016(psel_spi16),     
    .psel116(psel_uart016),   
    .psel216(psel_gpio16),    
    .psel316(psel_ttc16),     
    .psel416(),     
    .psel516(psel_smc16),     
    .psel616(psel_pmc16),    
    .psel716(psel_apic16),   
    .psel816(psel_uart116),  
    .penable16(penable16)     
);

spi_top16 i_spi16
(
  // Wishbone16 signals16
  .wb_clk_i16(pclk16), 
  .wb_rst_i16(~n_preset16), 
  .wb_adr_i16(paddr16[4:0]), 
  .wb_dat_i16(pwdata16), 
  .wb_dat_o16(prdata_spi16), 
  .wb_sel_i16(4'b1111),    // SPI16 register accesses are always 32-bit
  .wb_we_i16(pwrite16), 
  .wb_stb_i16(psel_spi16), 
  .wb_cyc_i16(psel_spi16), 
  .wb_ack_o16(pready_spi16), 
  .wb_err_o16(), 
  .wb_int_o16(SPI_int16),

  // SPI16 signals16
  .ss_pad_o16(n_ss_out16), 
  .sclk_pad_o16(sclk_out16), 
  .mosi_pad_o16(mo16), 
  .miso_pad_i16(mi16)
);

// Opencores16 UART16 instances16
wire ua_nrts_int16;
wire ua_nrts1_int16;

assign ua_nrts16 = ua_nrts_int16;
assign ua_nrts116 = ua_nrts1_int16;

reg [3:0] uart0_sel_i16;
reg [3:0] uart1_sel_i16;
// UART16 registers are all 8-bit wide16, and their16 addresses16
// are on byte boundaries16. So16 to access them16 on the
// Wishbone16 bus, the CPU16 must do byte accesses to these16
// byte addresses16. Word16 address accesses are not possible16
// because the word16 addresses16 will be unaligned16, and cause
// a fault16.
// So16, Uart16 accesses from the CPU16 will always be 8-bit size
// We16 only have to decide16 which byte of the 4-byte word16 the
// CPU16 is interested16 in.
`ifdef SYSTEM_BIG_ENDIAN16
always @(paddr16) begin
  case (paddr16[1:0])
    2'b00 : uart0_sel_i16 = 4'b1000;
    2'b01 : uart0_sel_i16 = 4'b0100;
    2'b10 : uart0_sel_i16 = 4'b0010;
    2'b11 : uart0_sel_i16 = 4'b0001;
  endcase
end
always @(paddr16) begin
  case (paddr16[1:0])
    2'b00 : uart1_sel_i16 = 4'b1000;
    2'b01 : uart1_sel_i16 = 4'b0100;
    2'b10 : uart1_sel_i16 = 4'b0010;
    2'b11 : uart1_sel_i16 = 4'b0001;
  endcase
end
`else
always @(paddr16) begin
  case (paddr16[1:0])
    2'b00 : uart0_sel_i16 = 4'b0001;
    2'b01 : uart0_sel_i16 = 4'b0010;
    2'b10 : uart0_sel_i16 = 4'b0100;
    2'b11 : uart0_sel_i16 = 4'b1000;
  endcase
end
always @(paddr16) begin
  case (paddr16[1:0])
    2'b00 : uart1_sel_i16 = 4'b0001;
    2'b01 : uart1_sel_i16 = 4'b0010;
    2'b10 : uart1_sel_i16 = 4'b0100;
    2'b11 : uart1_sel_i16 = 4'b1000;
  endcase
end
`endif

uart_top16 i_oc_uart016 (
  .wb_clk_i16(pclk16),
  .wb_rst_i16(~n_preset16),
  .wb_adr_i16(paddr16[4:0]),
  .wb_dat_i16(pwdata16),
  .wb_dat_o16(prdata_uart016),
  .wb_we_i16(pwrite16),
  .wb_stb_i16(psel_uart016),
  .wb_cyc_i16(psel_uart016),
  .wb_ack_o16(pready_uart016),
  .wb_sel_i16(uart0_sel_i16),
  .int_o16(UART_int16),
  .stx_pad_o16(ua_txd16),
  .srx_pad_i16(ua_rxd16),
  .rts_pad_o16(ua_nrts_int16),
  .cts_pad_i16(ua_ncts16),
  .dtr_pad_o16(),
  .dsr_pad_i16(1'b0),
  .ri_pad_i16(1'b0),
  .dcd_pad_i16(1'b0)
);

uart_top16 i_oc_uart116 (
  .wb_clk_i16(pclk16),
  .wb_rst_i16(~n_preset16),
  .wb_adr_i16(paddr16[4:0]),
  .wb_dat_i16(pwdata16),
  .wb_dat_o16(prdata_uart116),
  .wb_we_i16(pwrite16),
  .wb_stb_i16(psel_uart116),
  .wb_cyc_i16(psel_uart116),
  .wb_ack_o16(pready_uart116),
  .wb_sel_i16(uart1_sel_i16),
  .int_o16(UART_int116),
  .stx_pad_o16(ua_txd116),
  .srx_pad_i16(ua_rxd116),
  .rts_pad_o16(ua_nrts1_int16),
  .cts_pad_i16(ua_ncts116),
  .dtr_pad_o16(),
  .dsr_pad_i16(1'b0),
  .ri_pad_i16(1'b0),
  .dcd_pad_i16(1'b0)
);

gpio_veneer16 i_gpio_veneer16 (
        //inputs16

        . n_p_reset16(n_preset16),
        . pclk16(pclk16),
        . psel16(psel_gpio16),
        . penable16(penable16),
        . pwrite16(pwrite16),
        . paddr16(paddr16[5:0]),
        . pwdata16(pwdata16),
        . gpio_pin_in16(gpio_pin_in16),
        . scan_en16(scan_en16),
        . tri_state_enable16(tri_state_enable16),
        . scan_in16(), //added by smarkov16 for dft16

        //outputs16
        . scan_out16(), //added by smarkov16 for dft16
        . prdata16(prdata_gpio16),
        . gpio_int16(GPIO_int16),
        . n_gpio_pin_oe16(n_gpio_pin_oe16),
        . gpio_pin_out16(gpio_pin_out16)
);


ttc_veneer16 i_ttc_veneer16 (

         //inputs16
        . n_p_reset16(n_preset16),
        . pclk16(pclk16),
        . psel16(psel_ttc16),
        . penable16(penable16),
        . pwrite16(pwrite16),
        . pwdata16(pwdata16),
        . paddr16(paddr16[7:0]),
        . scan_in16(),
        . scan_en16(scan_en16),

        //outputs16
        . prdata16(prdata_ttc16),
        . interrupt16(TTC_int16[3:1]),
        . scan_out16()
);


smc_veneer16 i_smc_veneer16 (
        //inputs16
	//apb16 inputs16
        . n_preset16(n_preset16),
        . pclk16(pclk_SRPG_smc16),
        . psel16(psel_smc16),
        . penable16(penable16),
        . pwrite16(pwrite16),
        . paddr16(paddr16[4:0]),
        . pwdata16(pwdata16),
        //ahb16 inputs16
	. hclk16(smc_hclk16),
        . n_sys_reset16(rstn_non_srpg_smc16),
        . haddr16(smc_haddr16),
        . htrans16(smc_htrans16),
        . hsel16(smc_hsel_int16),
        . hwrite16(smc_hwrite16),
	. hsize16(smc_hsize16),
        . hwdata16(smc_hwdata16),
        . hready16(smc_hready_in16),
        . data_smc16(data_smc16),

         //test signal16 inputs16

        . scan_in_116(),
        . scan_in_216(),
        . scan_in_316(),
        . scan_en16(scan_en16),

        //apb16 outputs16
        . prdata16(prdata_smc16),

       //design output

        . smc_hrdata16(smc_hrdata16),
        . smc_hready16(smc_hready16),
        . smc_hresp16(smc_hresp16),
        . smc_valid16(smc_valid16),
        . smc_addr16(smc_addr_int16),
        . smc_data16(smc_data16),
        . smc_n_be16(smc_n_be16),
        . smc_n_cs16(smc_n_cs16),
        . smc_n_wr16(smc_n_wr16),
        . smc_n_we16(smc_n_we16),
        . smc_n_rd16(smc_n_rd16),
        . smc_n_ext_oe16(smc_n_ext_oe16),
        . smc_busy16(smc_busy16),

         //test signal16 output
        . scan_out_116(),
        . scan_out_216(),
        . scan_out_316()
);

power_ctrl_veneer16 i_power_ctrl_veneer16 (
    // -- Clocks16 & Reset16
    	.pclk16(pclk16), 			//  : in  std_logic16;
    	.nprst16(n_preset16), 		//  : in  std_logic16;
    // -- APB16 programming16 interface
    	.paddr16(paddr16), 			//  : in  std_logic_vector16(31 downto16 0);
    	.psel16(psel_pmc16), 			//  : in  std_logic16;
    	.penable16(penable16), 		//  : in  std_logic16;
    	.pwrite16(pwrite16), 		//  : in  std_logic16;
    	.pwdata16(pwdata16), 		//  : in  std_logic_vector16(31 downto16 0);
    	.prdata16(prdata_pmc16), 		//  : out std_logic_vector16(31 downto16 0);
        .macb3_wakeup16(macb3_wakeup16),
        .macb2_wakeup16(macb2_wakeup16),
        .macb1_wakeup16(macb1_wakeup16),
        .macb0_wakeup16(macb0_wakeup16),
    // -- Module16 control16 outputs16
    	.scan_in16(),			//  : in  std_logic16;
    	.scan_en16(scan_en16),             	//  : in  std_logic16;
    	.scan_mode16(scan_mode16),          //  : in  std_logic16;
    	.scan_out16(),            	//  : out std_logic16;
        .int_source_h16(int_source_h16),
     	.rstn_non_srpg_smc16(rstn_non_srpg_smc16), 		//   : out std_logic16;
    	.gate_clk_smc16(gate_clk_smc16), 	//  : out std_logic16;
    	.isolate_smc16(isolate_smc16), 	//  : out std_logic16;
    	.save_edge_smc16(save_edge_smc16), 	//  : out std_logic16;
    	.restore_edge_smc16(restore_edge_smc16), 	//  : out std_logic16;
    	.pwr1_on_smc16(pwr1_on_smc16), 	//  : out std_logic16;
    	.pwr2_on_smc16(pwr2_on_smc16), 	//  : out std_logic16
     	.rstn_non_srpg_urt16(rstn_non_srpg_urt16), 		//   : out std_logic16;
    	.gate_clk_urt16(gate_clk_urt16), 	//  : out std_logic16;
    	.isolate_urt16(isolate_urt16), 	//  : out std_logic16;
    	.save_edge_urt16(save_edge_urt16), 	//  : out std_logic16;
    	.restore_edge_urt16(restore_edge_urt16), 	//  : out std_logic16;
    	.pwr1_on_urt16(pwr1_on_urt16), 	//  : out std_logic16;
    	.pwr2_on_urt16(pwr2_on_urt16),  	//  : out std_logic16
        // ETH016
        .rstn_non_srpg_macb016(rstn_non_srpg_macb016),
        .gate_clk_macb016(gate_clk_macb016),
        .isolate_macb016(isolate_macb016),
        .save_edge_macb016(save_edge_macb016),
        .restore_edge_macb016(restore_edge_macb016),
        .pwr1_on_macb016(pwr1_on_macb016),
        .pwr2_on_macb016(pwr2_on_macb016),
        // ETH116
        .rstn_non_srpg_macb116(rstn_non_srpg_macb116),
        .gate_clk_macb116(gate_clk_macb116),
        .isolate_macb116(isolate_macb116),
        .save_edge_macb116(save_edge_macb116),
        .restore_edge_macb116(restore_edge_macb116),
        .pwr1_on_macb116(pwr1_on_macb116),
        .pwr2_on_macb116(pwr2_on_macb116),
        // ETH216
        .rstn_non_srpg_macb216(rstn_non_srpg_macb216),
        .gate_clk_macb216(gate_clk_macb216),
        .isolate_macb216(isolate_macb216),
        .save_edge_macb216(save_edge_macb216),
        .restore_edge_macb216(restore_edge_macb216),
        .pwr1_on_macb216(pwr1_on_macb216),
        .pwr2_on_macb216(pwr2_on_macb216),
        // ETH316
        .rstn_non_srpg_macb316(rstn_non_srpg_macb316),
        .gate_clk_macb316(gate_clk_macb316),
        .isolate_macb316(isolate_macb316),
        .save_edge_macb316(save_edge_macb316),
        .restore_edge_macb316(restore_edge_macb316),
        .pwr1_on_macb316(pwr1_on_macb316),
        .pwr2_on_macb316(pwr2_on_macb316),
        .core06v16(core06v16),
        .core08v16(core08v16),
        .core10v16(core10v16),
        .core12v16(core12v16),
        .pcm_macb_wakeup_int16(pcm_macb_wakeup_int16),
        .isolate_mem16(isolate_mem16),
        .mte_smc_start16(mte_smc_start16),
        .mte_uart_start16(mte_uart_start16),
        .mte_smc_uart_start16(mte_smc_uart_start16),  
        .mte_pm_smc_to_default_start16(mte_pm_smc_to_default_start16), 
        .mte_pm_uart_to_default_start16(mte_pm_uart_to_default_start16),
        .mte_pm_smc_uart_to_default_start16(mte_pm_smc_uart_to_default_start16)
);

// Clock16 gating16 macro16 to shut16 off16 clocks16 to the SRPG16 flops16 in the SMC16
//CKLNQD116 i_SMC_SRPG_clk_gate16  (
//	.TE16(scan_mode16), 
//	.E16(~gate_clk_smc16), 
//	.CP16(pclk16), 
//	.Q16(pclk_SRPG_smc16)
//	);
// Replace16 gate16 with behavioural16 code16 //
wire 	smc_scan_gate16;
reg 	smc_latched_enable16;
assign smc_scan_gate16 = scan_mode16 ? 1'b1 : ~gate_clk_smc16;

always @ (pclk16 or smc_scan_gate16)
  	if (pclk16 == 1'b0) begin
  		smc_latched_enable16 <= smc_scan_gate16;
  	end  	
	
assign pclk_SRPG_smc16 = smc_latched_enable16 ? pclk16 : 1'b0;


// Clock16 gating16 macro16 to shut16 off16 clocks16 to the SRPG16 flops16 in the URT16
//CKLNQD116 i_URT_SRPG_clk_gate16  (
//	.TE16(scan_mode16), 
//	.E16(~gate_clk_urt16), 
//	.CP16(pclk16), 
//	.Q16(pclk_SRPG_urt16)
//	);
// Replace16 gate16 with behavioural16 code16 //
wire 	urt_scan_gate16;
reg 	urt_latched_enable16;
assign urt_scan_gate16 = scan_mode16 ? 1'b1 : ~gate_clk_urt16;

always @ (pclk16 or urt_scan_gate16)
  	if (pclk16 == 1'b0) begin
  		urt_latched_enable16 <= urt_scan_gate16;
  	end  	
	
assign pclk_SRPG_urt16 = urt_latched_enable16 ? pclk16 : 1'b0;

// ETH016
wire 	macb0_scan_gate16;
reg 	macb0_latched_enable16;
assign macb0_scan_gate16 = scan_mode16 ? 1'b1 : ~gate_clk_macb016;

always @ (pclk16 or macb0_scan_gate16)
  	if (pclk16 == 1'b0) begin
  		macb0_latched_enable16 <= macb0_scan_gate16;
  	end  	
	
assign clk_SRPG_macb0_en16 = macb0_latched_enable16 ? 1'b1 : 1'b0;

// ETH116
wire 	macb1_scan_gate16;
reg 	macb1_latched_enable16;
assign macb1_scan_gate16 = scan_mode16 ? 1'b1 : ~gate_clk_macb116;

always @ (pclk16 or macb1_scan_gate16)
  	if (pclk16 == 1'b0) begin
  		macb1_latched_enable16 <= macb1_scan_gate16;
  	end  	
	
assign clk_SRPG_macb1_en16 = macb1_latched_enable16 ? 1'b1 : 1'b0;

// ETH216
wire 	macb2_scan_gate16;
reg 	macb2_latched_enable16;
assign macb2_scan_gate16 = scan_mode16 ? 1'b1 : ~gate_clk_macb216;

always @ (pclk16 or macb2_scan_gate16)
  	if (pclk16 == 1'b0) begin
  		macb2_latched_enable16 <= macb2_scan_gate16;
  	end  	
	
assign clk_SRPG_macb2_en16 = macb2_latched_enable16 ? 1'b1 : 1'b0;

// ETH316
wire 	macb3_scan_gate16;
reg 	macb3_latched_enable16;
assign macb3_scan_gate16 = scan_mode16 ? 1'b1 : ~gate_clk_macb316;

always @ (pclk16 or macb3_scan_gate16)
  	if (pclk16 == 1'b0) begin
  		macb3_latched_enable16 <= macb3_scan_gate16;
  	end  	
	
assign clk_SRPG_macb3_en16 = macb3_latched_enable16 ? 1'b1 : 1'b0;



`else
//------------------------------------------------------------------------------
// if the APB16 subsystem16 is black16 boxed16 
//------------------------------------------------------------------------------
// wire s ports16
    // system signals16
    wire         hclk16;     // AHB16 Clock16
    wire         n_hreset16;  // AHB16 reset - Active16 low16
    wire         pclk16;     // APB16 Clock16. 
    wire         n_preset16;  // APB16 reset - Active16 low16

    // AHB16 interface
    wire         ahb2apb0_hsel16;     // AHB2APB16 select16
    wire  [31:0] haddr16;    // Address bus
    wire  [1:0]  htrans16;   // Transfer16 type
    wire  [2:0]  hsize16;    // AHB16 Access type - byte, half16-word16, word16
    wire  [31:0] hwdata16;   // Write data
    wire         hwrite16;   // Write signal16/
    wire         hready_in16;// Indicates16 that last master16 has finished16 bus access
    wire [2:0]   hburst16;     // Burst type
    wire [3:0]   hprot16;      // Protection16 control16
    wire [3:0]   hmaster16;    // Master16 select16
    wire         hmastlock16;  // Locked16 transfer16
  // Interrupts16 from the Enet16 MACs16
    wire         macb0_int16;
    wire         macb1_int16;
    wire         macb2_int16;
    wire         macb3_int16;
  // Interrupt16 from the DMA16
    wire         DMA_irq16;
  // Scan16 wire s
    wire         scan_en16;    // Scan16 enable pin16
    wire         scan_in_116;  // Scan16 wire  for first chain16
    wire         scan_in_216;  // Scan16 wire  for second chain16
    wire         scan_mode16;  // test mode pin16
 
  //wire  for smc16 AHB16 interface
    wire         smc_hclk16;
    wire         smc_n_hclk16;
    wire  [31:0] smc_haddr16;
    wire  [1:0]  smc_htrans16;
    wire         smc_hsel16;
    wire         smc_hwrite16;
    wire  [2:0]  smc_hsize16;
    wire  [31:0] smc_hwdata16;
    wire         smc_hready_in16;
    wire  [2:0]  smc_hburst16;     // Burst type
    wire  [3:0]  smc_hprot16;      // Protection16 control16
    wire  [3:0]  smc_hmaster16;    // Master16 select16
    wire         smc_hmastlock16;  // Locked16 transfer16


    wire  [31:0] data_smc16;     // EMI16(External16 memory) read data
    
  //wire s for uart16
    wire         ua_rxd16;       // UART16 receiver16 serial16 wire  pin16
    wire         ua_rxd116;      // UART16 receiver16 serial16 wire  pin16
    wire         ua_ncts16;      // Clear-To16-Send16 flow16 control16
    wire         ua_ncts116;      // Clear-To16-Send16 flow16 control16
   //wire s for spi16
    wire         n_ss_in16;      // select16 wire  to slave16
    wire         mi16;           // data wire  to master16
    wire         si16;           // data wire  to slave16
    wire         sclk_in16;      // clock16 wire  to slave16
  //wire s for GPIO16
   wire  [GPIO_WIDTH16-1:0]  gpio_pin_in16;             // wire  data from pin16

  //reg    ports16
  // Scan16 reg   s
   reg           scan_out_116;   // Scan16 out for chain16 1
   reg           scan_out_216;   // Scan16 out for chain16 2
  //AHB16 interface 
   reg    [31:0] hrdata16;       // Read data provided from target slave16
   reg           hready16;       // Ready16 for new bus cycle from target slave16
   reg    [1:0]  hresp16;       // Response16 from the bridge16

   // SMC16 reg    for AHB16 interface
   reg    [31:0]    smc_hrdata16;
   reg              smc_hready16;
   reg    [1:0]     smc_hresp16;

  //reg   s from smc16
   reg    [15:0]    smc_addr16;      // External16 Memory (EMI16) address
   reg    [3:0]     smc_n_be16;      // EMI16 byte enables16 (Active16 LOW16)
   reg    [7:0]     smc_n_cs16;      // EMI16 Chip16 Selects16 (Active16 LOW16)
   reg    [3:0]     smc_n_we16;      // EMI16 write strobes16 (Active16 LOW16)
   reg              smc_n_wr16;      // EMI16 write enable (Active16 LOW16)
   reg              smc_n_rd16;      // EMI16 read stobe16 (Active16 LOW16)
   reg              smc_n_ext_oe16;  // EMI16 write data reg    enable
   reg    [31:0]    smc_data16;      // EMI16 write data
  //reg   s from uart16
   reg           ua_txd16;       	// UART16 transmitter16 serial16 reg   
   reg           ua_txd116;       // UART16 transmitter16 serial16 reg   
   reg           ua_nrts16;      	// Request16-To16-Send16 flow16 control16
   reg           ua_nrts116;      // Request16-To16-Send16 flow16 control16
   // reg   s from ttc16
  // reg   s from SPI16
   reg       so;                    // data reg    from slave16
   reg       mo16;                    // data reg    from master16
   reg       sclk_out16;              // clock16 reg    from master16
   reg    [P_SIZE16-1:0] n_ss_out16;    // peripheral16 select16 lines16 from master16
   reg       n_so_en16;               // out enable for slave16 data
   reg       n_mo_en16;               // out enable for master16 data
   reg       n_sclk_en16;             // out enable for master16 clock16
   reg       n_ss_en16;               // out enable for master16 peripheral16 lines16
  //reg   s from gpio16
   reg    [GPIO_WIDTH16-1:0]     n_gpio_pin_oe16;           // reg    enable signal16 to pin16
   reg    [GPIO_WIDTH16-1:0]     gpio_pin_out16;            // reg    signal16 to pin16


`endif
//------------------------------------------------------------------------------
// black16 boxed16 defines16 
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// APB16 and AHB16 interface formal16 verification16 monitors16
//------------------------------------------------------------------------------
`ifdef ABV_ON16
apb_assert16 i_apb_assert16 (

        // APB16 signals16
  	.n_preset16(n_preset16),
   	.pclk16(pclk16),
	.penable16(penable16),
	.paddr16(paddr16),
	.pwrite16(pwrite16),
	.pwdata16(pwdata16),

	.psel0016(psel_spi16),
	.psel0116(psel_uart016),
	.psel0216(psel_gpio16),
	.psel0316(psel_ttc16),
	.psel0416(1'b0),
	.psel0516(psel_smc16),
	.psel0616(1'b0),
	.psel0716(1'b0),
	.psel0816(1'b0),
	.psel0916(1'b0),
	.psel1016(1'b0),
	.psel1116(1'b0),
	.psel1216(1'b0),
	.psel1316(psel_pmc16),
	.psel1416(psel_apic16),
	.psel1516(psel_uart116),

        .prdata0016(prdata_spi16),
        .prdata0116(prdata_uart016), // Read Data from peripheral16 UART16 
        .prdata0216(prdata_gpio16), // Read Data from peripheral16 GPIO16
        .prdata0316(prdata_ttc16), // Read Data from peripheral16 TTC16
        .prdata0416(32'b0), // 
        .prdata0516(prdata_smc16), // Read Data from peripheral16 SMC16
        .prdata1316(prdata_pmc16), // Read Data from peripheral16 Power16 Control16 Block
   	.prdata1416(32'b0), // 
        .prdata1516(prdata_uart116),


        // AHB16 signals16
        .hclk16(hclk16),         // ahb16 system clock16
        .n_hreset16(n_hreset16), // ahb16 system reset

        // ahb2apb16 signals16
        .hresp16(hresp16),
        .hready16(hready16),
        .hrdata16(hrdata16),
        .hwdata16(hwdata16),
        .hprot16(hprot16),
        .hburst16(hburst16),
        .hsize16(hsize16),
        .hwrite16(hwrite16),
        .htrans16(htrans16),
        .haddr16(haddr16),
        .ahb2apb_hsel16(ahb2apb0_hsel16));



//------------------------------------------------------------------------------
// AHB16 interface formal16 verification16 monitor16
//------------------------------------------------------------------------------
defparam i_ahbSlaveMonitor16.DBUS_WIDTH16 = 32;
defparam i_ahbMasterMonitor16.DBUS_WIDTH16 = 32;


// AHB2APB16 Bridge16

    ahb_liteslave_monitor16 i_ahbSlaveMonitor16 (
        .hclk_i16(hclk16),
        .hresetn_i16(n_hreset16),
        .hresp16(hresp16),
        .hready16(hready16),
        .hready_global_i16(hready16),
        .hrdata16(hrdata16),
        .hwdata_i16(hwdata16),
        .hburst_i16(hburst16),
        .hsize_i16(hsize16),
        .hwrite_i16(hwrite16),
        .htrans_i16(htrans16),
        .haddr_i16(haddr16),
        .hsel_i16(ahb2apb0_hsel16)
    );


  ahb_litemaster_monitor16 i_ahbMasterMonitor16 (
          .hclk_i16(hclk16),
          .hresetn_i16(n_hreset16),
          .hresp_i16(hresp16),
          .hready_i16(hready16),
          .hrdata_i16(hrdata16),
          .hlock16(1'b0),
          .hwdata16(hwdata16),
          .hprot16(hprot16),
          .hburst16(hburst16),
          .hsize16(hsize16),
          .hwrite16(hwrite16),
          .htrans16(htrans16),
          .haddr16(haddr16)
          );







`endif




`ifdef IFV_LP_ABV_ON16
// power16 control16
wire isolate16;

// testbench mirror signals16
wire L1_ctrl_access16;
wire L1_status_access16;

wire [31:0] L1_status_reg16;
wire [31:0] L1_ctrl_reg16;

//wire rstn_non_srpg_urt16;
//wire isolate_urt16;
//wire retain_urt16;
//wire gate_clk_urt16;
//wire pwr1_on_urt16;


// smc16 signals16
wire [31:0] smc_prdata16;
wire lp_clk_smc16;
                    

// uart16 isolation16 register
  wire [15:0] ua_prdata16;
  wire ua_int16;
  assign ua_prdata16          =  i_uart1_veneer16.prdata16;
  assign ua_int16             =  i_uart1_veneer16.ua_int16;


assign lp_clk_smc16          = i_smc_veneer16.pclk16;
assign smc_prdata16          = i_smc_veneer16.prdata16;
lp_chk_smc16 u_lp_chk_smc16 (
    .clk16 (hclk16),
    .rst16 (n_hreset16),
    .iso_smc16 (isolate_smc16),
    .gate_clk16 (gate_clk_smc16),
    .lp_clk16 (pclk_SRPG_smc16),

    // srpg16 outputs16
    .smc_hrdata16 (smc_hrdata16),
    .smc_hready16 (smc_hready16),
    .smc_hresp16  (smc_hresp16),
    .smc_valid16 (smc_valid16),
    .smc_addr_int16 (smc_addr_int16),
    .smc_data16 (smc_data16),
    .smc_n_be16 (smc_n_be16),
    .smc_n_cs16  (smc_n_cs16),
    .smc_n_wr16 (smc_n_wr16),
    .smc_n_we16 (smc_n_we16),
    .smc_n_rd16 (smc_n_rd16),
    .smc_n_ext_oe16 (smc_n_ext_oe16)
   );

// lp16 retention16/isolation16 assertions16
lp_chk_uart16 u_lp_chk_urt16 (

  .clk16         (hclk16),
  .rst16         (n_hreset16),
  .iso_urt16     (isolate_urt16),
  .gate_clk16    (gate_clk_urt16),
  .lp_clk16      (pclk_SRPG_urt16),
  //ports16
  .prdata16 (ua_prdata16),
  .ua_int16 (ua_int16),
  .ua_txd16 (ua_txd116),
  .ua_nrts16 (ua_nrts116)
 );

`endif  //IFV_LP_ABV_ON16




endmodule
