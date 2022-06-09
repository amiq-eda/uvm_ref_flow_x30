//File30 name   : apb_subsystem_030.v
//Title30       : 
//Created30     : 1999
//Description30 : 
//Notes30       : 
//----------------------------------------------------------------------
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------

module apb_subsystem_030(
    // AHB30 interface
    hclk30,
    n_hreset30,
    hsel30,
    haddr30,
    htrans30,
    hsize30,
    hwrite30,
    hwdata30,
    hready_in30,
    hburst30,
    hprot30,
    hmaster30,
    hmastlock30,
    hrdata30,
    hready30,
    hresp30,
    
    // APB30 system interface
    pclk30,
    n_preset30,
    
    // SPI30 ports30
    n_ss_in30,
    mi30,
    si30,
    sclk_in30,
    so,
    mo30,
    sclk_out30,
    n_ss_out30,
    n_so_en30,
    n_mo_en30,
    n_sclk_en30,
    n_ss_en30,
    
    //UART030 ports30
    ua_rxd30,
    ua_ncts30,
    ua_txd30,
    ua_nrts30,
    
    //UART130 ports30
    ua_rxd130,
    ua_ncts130,
    ua_txd130,
    ua_nrts130,
    
    //GPIO30 ports30
    gpio_pin_in30,
    n_gpio_pin_oe30,
    gpio_pin_out30,
    

    //SMC30 ports30
    smc_hclk30,
    smc_n_hclk30,
    smc_haddr30,
    smc_htrans30,
    smc_hsel30,
    smc_hwrite30,
    smc_hsize30,
    smc_hwdata30,
    smc_hready_in30,
    smc_hburst30,
    smc_hprot30,
    smc_hmaster30,
    smc_hmastlock30,
    smc_hrdata30, 
    smc_hready30,
    smc_hresp30,
    smc_n_ext_oe30,
    smc_data30,
    smc_addr30,
    smc_n_be30,
    smc_n_cs30, 
    smc_n_we30,
    smc_n_wr30,
    smc_n_rd30,
    data_smc30,
    
    //PMC30 ports30
    clk_SRPG_macb0_en30,
    clk_SRPG_macb1_en30,
    clk_SRPG_macb2_en30,
    clk_SRPG_macb3_en30,
    core06v30,
    core08v30,
    core10v30,
    core12v30,
    macb3_wakeup30,
    macb2_wakeup30,
    macb1_wakeup30,
    macb0_wakeup30,
    mte_smc_start30,
    mte_uart_start30,
    mte_smc_uart_start30,  
    mte_pm_smc_to_default_start30, 
    mte_pm_uart_to_default_start30,
    mte_pm_smc_uart_to_default_start30,
    
    
    // Peripheral30 inerrupts30
    pcm_irq30,
    ttc_irq30,
    gpio_irq30,
    uart0_irq30,
    uart1_irq30,
    spi_irq30,
    DMA_irq30,      
    macb0_int30,
    macb1_int30,
    macb2_int30,
    macb3_int30,
   
    // Scan30 ports30
    scan_en30,      // Scan30 enable pin30
    scan_in_130,    // Scan30 input for first chain30
    scan_in_230,    // Scan30 input for second chain30
    scan_mode30,
    scan_out_130,   // Scan30 out for chain30 1
    scan_out_230    // Scan30 out for chain30 2
);

parameter GPIO_WIDTH30 = 16;        // GPIO30 width
parameter P_SIZE30 =   8;              // number30 of peripheral30 select30 lines30
parameter NO_OF_IRQS30  = 17;      //No of irqs30 read by apic30 

// AHB30 interface
input         hclk30;     // AHB30 Clock30
input         n_hreset30;  // AHB30 reset - Active30 low30
input         hsel30;     // AHB2APB30 select30
input [31:0]  haddr30;    // Address bus
input [1:0]   htrans30;   // Transfer30 type
input [2:0]   hsize30;    // AHB30 Access type - byte, half30-word30, word30
input [31:0]  hwdata30;   // Write data
input         hwrite30;   // Write signal30/
input         hready_in30;// Indicates30 that last master30 has finished30 bus access
input [2:0]   hburst30;     // Burst type
input [3:0]   hprot30;      // Protection30 control30
input [3:0]   hmaster30;    // Master30 select30
input         hmastlock30;  // Locked30 transfer30
output [31:0] hrdata30;       // Read data provided from target slave30
output        hready30;       // Ready30 for new bus cycle from target slave30
output [1:0]  hresp30;       // Response30 from the bridge30
    
// APB30 system interface
input         pclk30;     // APB30 Clock30. 
input         n_preset30;  // APB30 reset - Active30 low30
   
// SPI30 ports30
input     n_ss_in30;      // select30 input to slave30
input     mi30;           // data input to master30
input     si30;           // data input to slave30
input     sclk_in30;      // clock30 input to slave30
output    so;                    // data output from slave30
output    mo30;                    // data output from master30
output    sclk_out30;              // clock30 output from master30
output [P_SIZE30-1:0] n_ss_out30;    // peripheral30 select30 lines30 from master30
output    n_so_en30;               // out enable for slave30 data
output    n_mo_en30;               // out enable for master30 data
output    n_sclk_en30;             // out enable for master30 clock30
output    n_ss_en30;               // out enable for master30 peripheral30 lines30

//UART030 ports30
input        ua_rxd30;       // UART30 receiver30 serial30 input pin30
input        ua_ncts30;      // Clear-To30-Send30 flow30 control30
output       ua_txd30;       	// UART30 transmitter30 serial30 output
output       ua_nrts30;      	// Request30-To30-Send30 flow30 control30

// UART130 ports30   
input        ua_rxd130;      // UART30 receiver30 serial30 input pin30
input        ua_ncts130;      // Clear-To30-Send30 flow30 control30
output       ua_txd130;       // UART30 transmitter30 serial30 output
output       ua_nrts130;      // Request30-To30-Send30 flow30 control30

//GPIO30 ports30
input [GPIO_WIDTH30-1:0]      gpio_pin_in30;             // input data from pin30
output [GPIO_WIDTH30-1:0]     n_gpio_pin_oe30;           // output enable signal30 to pin30
output [GPIO_WIDTH30-1:0]     gpio_pin_out30;            // output signal30 to pin30
  
//SMC30 ports30
input        smc_hclk30;
input        smc_n_hclk30;
input [31:0] smc_haddr30;
input [1:0]  smc_htrans30;
input        smc_hsel30;
input        smc_hwrite30;
input [2:0]  smc_hsize30;
input [31:0] smc_hwdata30;
input        smc_hready_in30;
input [2:0]  smc_hburst30;     // Burst type
input [3:0]  smc_hprot30;      // Protection30 control30
input [3:0]  smc_hmaster30;    // Master30 select30
input        smc_hmastlock30;  // Locked30 transfer30
input [31:0] data_smc30;     // EMI30(External30 memory) read data
output [31:0]    smc_hrdata30;
output           smc_hready30;
output [1:0]     smc_hresp30;
output [15:0]    smc_addr30;      // External30 Memory (EMI30) address
output [3:0]     smc_n_be30;      // EMI30 byte enables30 (Active30 LOW30)
output           smc_n_cs30;      // EMI30 Chip30 Selects30 (Active30 LOW30)
output [3:0]     smc_n_we30;      // EMI30 write strobes30 (Active30 LOW30)
output           smc_n_wr30;      // EMI30 write enable (Active30 LOW30)
output           smc_n_rd30;      // EMI30 read stobe30 (Active30 LOW30)
output           smc_n_ext_oe30;  // EMI30 write data output enable
output [31:0]    smc_data30;      // EMI30 write data
       
//PMC30 ports30
output clk_SRPG_macb0_en30;
output clk_SRPG_macb1_en30;
output clk_SRPG_macb2_en30;
output clk_SRPG_macb3_en30;
output core06v30;
output core08v30;
output core10v30;
output core12v30;
output mte_smc_start30;
output mte_uart_start30;
output mte_smc_uart_start30;  
output mte_pm_smc_to_default_start30; 
output mte_pm_uart_to_default_start30;
output mte_pm_smc_uart_to_default_start30;
input macb3_wakeup30;
input macb2_wakeup30;
input macb1_wakeup30;
input macb0_wakeup30;
    

// Peripheral30 interrupts30
output pcm_irq30;
output [2:0] ttc_irq30;
output gpio_irq30;
output uart0_irq30;
output uart1_irq30;
output spi_irq30;
input        macb0_int30;
input        macb1_int30;
input        macb2_int30;
input        macb3_int30;
input        DMA_irq30;
  
//Scan30 ports30
input        scan_en30;    // Scan30 enable pin30
input        scan_in_130;  // Scan30 input for first chain30
input        scan_in_230;  // Scan30 input for second chain30
input        scan_mode30;  // test mode pin30
 output        scan_out_130;   // Scan30 out for chain30 1
 output        scan_out_230;   // Scan30 out for chain30 2  

//------------------------------------------------------------------------------
// if the ROM30 subsystem30 is NOT30 black30 boxed30 
//------------------------------------------------------------------------------
`ifndef FV_KIT_BLACK_BOX_APB_SUBSYSTEM30
   
   wire        hsel30; 
   wire        pclk30;
   wire        n_preset30;
   wire [31:0] prdata_spi30;
   wire [31:0] prdata_uart030;
   wire [31:0] prdata_gpio30;
   wire [31:0] prdata_ttc30;
   wire [31:0] prdata_smc30;
   wire [31:0] prdata_pmc30;
   wire [31:0] prdata_uart130;
   wire        pready_spi30;
   wire        pready_uart030;
   wire        pready_uart130;
   wire        tie_hi_bit30;
   wire  [31:0] hrdata30; 
   wire         hready30;
   wire         hready_in30;
   wire  [1:0]  hresp30;   
   wire  [31:0] pwdata30;  
   wire         pwrite30;
   wire  [31:0] paddr30;  
   wire   psel_spi30;
   wire   psel_uart030;
   wire   psel_gpio30;
   wire   psel_ttc30;
   wire   psel_smc30;
   wire   psel0730;
   wire   psel0830;
   wire   psel0930;
   wire   psel1030;
   wire   psel1130;
   wire   psel1230;
   wire   psel_pmc30;
   wire   psel_uart130;
   wire   penable30;
   wire   [NO_OF_IRQS30:0] int_source30;     // System30 Interrupt30 Sources30
   wire [1:0]             smc_hresp30;     // AHB30 Response30 signal30
   wire                   smc_valid30;     // Ack30 valid address

  //External30 memory interface (EMI30)
  wire [31:0]            smc_addr_int30;  // External30 Memory (EMI30) address
  wire [3:0]             smc_n_be30;      // EMI30 byte enables30 (Active30 LOW30)
  wire                   smc_n_cs30;      // EMI30 Chip30 Selects30 (Active30 LOW30)
  wire [3:0]             smc_n_we30;      // EMI30 write strobes30 (Active30 LOW30)
  wire                   smc_n_wr30;      // EMI30 write enable (Active30 LOW30)
  wire                   smc_n_rd30;      // EMI30 read stobe30 (Active30 LOW30)
 
  //AHB30 Memory Interface30 Control30
  wire                   smc_hsel_int30;
  wire                   smc_busy30;      // smc30 busy
   

//scan30 signals30

   wire                scan_in_130;        //scan30 input
   wire                scan_in_230;        //scan30 input
   wire                scan_en30;         //scan30 enable
   wire                scan_out_130;       //scan30 output
   wire                scan_out_230;       //scan30 output
   wire                byte_sel30;     // byte select30 from bridge30 1=byte, 0=2byte
   wire                UART_int30;     // UART30 module interrupt30 
   wire                ua_uclken30;    // Soft30 control30 of clock30
   wire                UART_int130;     // UART30 module interrupt30 
   wire                ua_uclken130;    // Soft30 control30 of clock30
   wire  [3:1]         TTC_int30;            //Interrupt30 from PCI30 
  // inputs30 to SPI30 
   wire    ext_clk30;                // external30 clock30
   wire    SPI_int30;             // interrupt30 request
  // outputs30 from SPI30
   wire    slave_out_clk30;         // modified slave30 clock30 output
 // gpio30 generic30 inputs30 
   wire  [GPIO_WIDTH30-1:0]   n_gpio_bypass_oe30;        // bypass30 mode enable 
   wire  [GPIO_WIDTH30-1:0]   gpio_bypass_out30;         // bypass30 mode output value 
   wire  [GPIO_WIDTH30-1:0]   tri_state_enable30;   // disables30 op enable -> z 
 // outputs30 
   //amba30 outputs30 
   // gpio30 generic30 outputs30 
   wire       GPIO_int30;                // gpio_interupt30 for input pin30 change 
   wire [GPIO_WIDTH30-1:0]     gpio_bypass_in30;          // bypass30 mode input data value  
                
   wire           cpu_debug30;        // Inhibits30 watchdog30 counter 
   wire            ex_wdz_n30;         // External30 Watchdog30 zero indication30
   wire           rstn_non_srpg_smc30; 
   wire           rstn_non_srpg_urt30;
   wire           isolate_smc30;
   wire           save_edge_smc30;
   wire           restore_edge_smc30;
   wire           save_edge_urt30;
   wire           restore_edge_urt30;
   wire           pwr1_on_smc30;
   wire           pwr2_on_smc30;
   wire           pwr1_on_urt30;
   wire           pwr2_on_urt30;
   // ETH030
   wire            rstn_non_srpg_macb030;
   wire            gate_clk_macb030;
   wire            isolate_macb030;
   wire            save_edge_macb030;
   wire            restore_edge_macb030;
   wire            pwr1_on_macb030;
   wire            pwr2_on_macb030;
   // ETH130
   wire            rstn_non_srpg_macb130;
   wire            gate_clk_macb130;
   wire            isolate_macb130;
   wire            save_edge_macb130;
   wire            restore_edge_macb130;
   wire            pwr1_on_macb130;
   wire            pwr2_on_macb130;
   // ETH230
   wire            rstn_non_srpg_macb230;
   wire            gate_clk_macb230;
   wire            isolate_macb230;
   wire            save_edge_macb230;
   wire            restore_edge_macb230;
   wire            pwr1_on_macb230;
   wire            pwr2_on_macb230;
   // ETH330
   wire            rstn_non_srpg_macb330;
   wire            gate_clk_macb330;
   wire            isolate_macb330;
   wire            save_edge_macb330;
   wire            restore_edge_macb330;
   wire            pwr1_on_macb330;
   wire            pwr2_on_macb330;


   wire           pclk_SRPG_smc30;
   wire           pclk_SRPG_urt30;
   wire           gate_clk_smc30;
   wire           gate_clk_urt30;
   wire  [31:0]   tie_lo_32bit30; 
   wire  [1:0]	  tie_lo_2bit30;
   wire  	  tie_lo_1bit30;
   wire           pcm_macb_wakeup_int30;
   wire           int_source_h30;
   wire           isolate_mem30;

assign pcm_irq30 = pcm_macb_wakeup_int30;
assign ttc_irq30[2] = TTC_int30[3];
assign ttc_irq30[1] = TTC_int30[2];
assign ttc_irq30[0] = TTC_int30[1];
assign gpio_irq30 = GPIO_int30;
assign uart0_irq30 = UART_int30;
assign uart1_irq30 = UART_int130;
assign spi_irq30 = SPI_int30;

assign n_mo_en30   = 1'b0;
assign n_so_en30   = 1'b1;
assign n_sclk_en30 = 1'b0;
assign n_ss_en30   = 1'b0;

assign smc_hsel_int30 = smc_hsel30;
  assign ext_clk30  = 1'b0;
  assign int_source30 = {macb0_int30,macb1_int30, macb2_int30, macb3_int30,1'b0, pcm_macb_wakeup_int30, 1'b0, 1'b0, 1'b0, 1'b0, TTC_int30, GPIO_int30, UART_int30, UART_int130, SPI_int30, DMA_irq30};

  // interrupt30 even30 detect30 .
  // for sleep30 wake30 up -> any interrupt30 even30 and system not in hibernation30 (isolate_mem30 = 0)
  // for hibernate30 wake30 up -> gpio30 interrupt30 even30 and system in the hibernation30 (isolate_mem30 = 1)
  assign int_source_h30 =  ((|int_source30) && (!isolate_mem30)) || (isolate_mem30 && GPIO_int30) ;

  assign byte_sel30 = 1'b1;
  assign tie_hi_bit30 = 1'b1;

  assign smc_addr30 = smc_addr_int30[15:0];



  assign  n_gpio_bypass_oe30 = {GPIO_WIDTH30{1'b0}};        // bypass30 mode enable 
  assign  gpio_bypass_out30  = {GPIO_WIDTH30{1'b0}};
  assign  tri_state_enable30 = {GPIO_WIDTH30{1'b0}};
  assign  cpu_debug30 = 1'b0;
  assign  tie_lo_32bit30 = 32'b0;
  assign  tie_lo_2bit30  = 2'b0;
  assign  tie_lo_1bit30  = 1'b0;


ahb2apb30 #(
  32'h00800000, // Slave30 0 Address Range30
  32'h0080FFFF,

  32'h00810000, // Slave30 1 Address Range30
  32'h0081FFFF,

  32'h00820000, // Slave30 2 Address Range30 
  32'h0082FFFF,

  32'h00830000, // Slave30 3 Address Range30
  32'h0083FFFF,

  32'h00840000, // Slave30 4 Address Range30
  32'h0084FFFF,

  32'h00850000, // Slave30 5 Address Range30
  32'h0085FFFF,

  32'h00860000, // Slave30 6 Address Range30
  32'h0086FFFF,

  32'h00870000, // Slave30 7 Address Range30
  32'h0087FFFF,

  32'h00880000, // Slave30 8 Address Range30
  32'h0088FFFF
) i_ahb2apb30 (
     // AHB30 interface
    .hclk30(hclk30),         
    .hreset_n30(n_hreset30), 
    .hsel30(hsel30), 
    .haddr30(haddr30),        
    .htrans30(htrans30),       
    .hwrite30(hwrite30),       
    .hwdata30(hwdata30),       
    .hrdata30(hrdata30),   
    .hready30(hready30),   
    .hresp30(hresp30),     
    
     // APB30 interface
    .pclk30(pclk30),         
    .preset_n30(n_preset30),  
    .prdata030(prdata_spi30),
    .prdata130(prdata_uart030), 
    .prdata230(prdata_gpio30),  
    .prdata330(prdata_ttc30),   
    .prdata430(32'h0),   
    .prdata530(prdata_smc30),   
    .prdata630(prdata_pmc30),    
    .prdata730(32'h0),   
    .prdata830(prdata_uart130),  
    .pready030(pready_spi30),     
    .pready130(pready_uart030),   
    .pready230(tie_hi_bit30),     
    .pready330(tie_hi_bit30),     
    .pready430(tie_hi_bit30),     
    .pready530(tie_hi_bit30),     
    .pready630(tie_hi_bit30),     
    .pready730(tie_hi_bit30),     
    .pready830(pready_uart130),  
    .pwdata30(pwdata30),       
    .pwrite30(pwrite30),       
    .paddr30(paddr30),        
    .psel030(psel_spi30),     
    .psel130(psel_uart030),   
    .psel230(psel_gpio30),    
    .psel330(psel_ttc30),     
    .psel430(),     
    .psel530(psel_smc30),     
    .psel630(psel_pmc30),    
    .psel730(psel_apic30),   
    .psel830(psel_uart130),  
    .penable30(penable30)     
);

spi_top30 i_spi30
(
  // Wishbone30 signals30
  .wb_clk_i30(pclk30), 
  .wb_rst_i30(~n_preset30), 
  .wb_adr_i30(paddr30[4:0]), 
  .wb_dat_i30(pwdata30), 
  .wb_dat_o30(prdata_spi30), 
  .wb_sel_i30(4'b1111),    // SPI30 register accesses are always 32-bit
  .wb_we_i30(pwrite30), 
  .wb_stb_i30(psel_spi30), 
  .wb_cyc_i30(psel_spi30), 
  .wb_ack_o30(pready_spi30), 
  .wb_err_o30(), 
  .wb_int_o30(SPI_int30),

  // SPI30 signals30
  .ss_pad_o30(n_ss_out30), 
  .sclk_pad_o30(sclk_out30), 
  .mosi_pad_o30(mo30), 
  .miso_pad_i30(mi30)
);

// Opencores30 UART30 instances30
wire ua_nrts_int30;
wire ua_nrts1_int30;

assign ua_nrts30 = ua_nrts_int30;
assign ua_nrts130 = ua_nrts1_int30;

reg [3:0] uart0_sel_i30;
reg [3:0] uart1_sel_i30;
// UART30 registers are all 8-bit wide30, and their30 addresses30
// are on byte boundaries30. So30 to access them30 on the
// Wishbone30 bus, the CPU30 must do byte accesses to these30
// byte addresses30. Word30 address accesses are not possible30
// because the word30 addresses30 will be unaligned30, and cause
// a fault30.
// So30, Uart30 accesses from the CPU30 will always be 8-bit size
// We30 only have to decide30 which byte of the 4-byte word30 the
// CPU30 is interested30 in.
`ifdef SYSTEM_BIG_ENDIAN30
always @(paddr30) begin
  case (paddr30[1:0])
    2'b00 : uart0_sel_i30 = 4'b1000;
    2'b01 : uart0_sel_i30 = 4'b0100;
    2'b10 : uart0_sel_i30 = 4'b0010;
    2'b11 : uart0_sel_i30 = 4'b0001;
  endcase
end
always @(paddr30) begin
  case (paddr30[1:0])
    2'b00 : uart1_sel_i30 = 4'b1000;
    2'b01 : uart1_sel_i30 = 4'b0100;
    2'b10 : uart1_sel_i30 = 4'b0010;
    2'b11 : uart1_sel_i30 = 4'b0001;
  endcase
end
`else
always @(paddr30) begin
  case (paddr30[1:0])
    2'b00 : uart0_sel_i30 = 4'b0001;
    2'b01 : uart0_sel_i30 = 4'b0010;
    2'b10 : uart0_sel_i30 = 4'b0100;
    2'b11 : uart0_sel_i30 = 4'b1000;
  endcase
end
always @(paddr30) begin
  case (paddr30[1:0])
    2'b00 : uart1_sel_i30 = 4'b0001;
    2'b01 : uart1_sel_i30 = 4'b0010;
    2'b10 : uart1_sel_i30 = 4'b0100;
    2'b11 : uart1_sel_i30 = 4'b1000;
  endcase
end
`endif

uart_top30 i_oc_uart030 (
  .wb_clk_i30(pclk30),
  .wb_rst_i30(~n_preset30),
  .wb_adr_i30(paddr30[4:0]),
  .wb_dat_i30(pwdata30),
  .wb_dat_o30(prdata_uart030),
  .wb_we_i30(pwrite30),
  .wb_stb_i30(psel_uart030),
  .wb_cyc_i30(psel_uart030),
  .wb_ack_o30(pready_uart030),
  .wb_sel_i30(uart0_sel_i30),
  .int_o30(UART_int30),
  .stx_pad_o30(ua_txd30),
  .srx_pad_i30(ua_rxd30),
  .rts_pad_o30(ua_nrts_int30),
  .cts_pad_i30(ua_ncts30),
  .dtr_pad_o30(),
  .dsr_pad_i30(1'b0),
  .ri_pad_i30(1'b0),
  .dcd_pad_i30(1'b0)
);

uart_top30 i_oc_uart130 (
  .wb_clk_i30(pclk30),
  .wb_rst_i30(~n_preset30),
  .wb_adr_i30(paddr30[4:0]),
  .wb_dat_i30(pwdata30),
  .wb_dat_o30(prdata_uart130),
  .wb_we_i30(pwrite30),
  .wb_stb_i30(psel_uart130),
  .wb_cyc_i30(psel_uart130),
  .wb_ack_o30(pready_uart130),
  .wb_sel_i30(uart1_sel_i30),
  .int_o30(UART_int130),
  .stx_pad_o30(ua_txd130),
  .srx_pad_i30(ua_rxd130),
  .rts_pad_o30(ua_nrts1_int30),
  .cts_pad_i30(ua_ncts130),
  .dtr_pad_o30(),
  .dsr_pad_i30(1'b0),
  .ri_pad_i30(1'b0),
  .dcd_pad_i30(1'b0)
);

gpio_veneer30 i_gpio_veneer30 (
        //inputs30

        . n_p_reset30(n_preset30),
        . pclk30(pclk30),
        . psel30(psel_gpio30),
        . penable30(penable30),
        . pwrite30(pwrite30),
        . paddr30(paddr30[5:0]),
        . pwdata30(pwdata30),
        . gpio_pin_in30(gpio_pin_in30),
        . scan_en30(scan_en30),
        . tri_state_enable30(tri_state_enable30),
        . scan_in30(), //added by smarkov30 for dft30

        //outputs30
        . scan_out30(), //added by smarkov30 for dft30
        . prdata30(prdata_gpio30),
        . gpio_int30(GPIO_int30),
        . n_gpio_pin_oe30(n_gpio_pin_oe30),
        . gpio_pin_out30(gpio_pin_out30)
);


ttc_veneer30 i_ttc_veneer30 (

         //inputs30
        . n_p_reset30(n_preset30),
        . pclk30(pclk30),
        . psel30(psel_ttc30),
        . penable30(penable30),
        . pwrite30(pwrite30),
        . pwdata30(pwdata30),
        . paddr30(paddr30[7:0]),
        . scan_in30(),
        . scan_en30(scan_en30),

        //outputs30
        . prdata30(prdata_ttc30),
        . interrupt30(TTC_int30[3:1]),
        . scan_out30()
);


smc_veneer30 i_smc_veneer30 (
        //inputs30
	//apb30 inputs30
        . n_preset30(n_preset30),
        . pclk30(pclk_SRPG_smc30),
        . psel30(psel_smc30),
        . penable30(penable30),
        . pwrite30(pwrite30),
        . paddr30(paddr30[4:0]),
        . pwdata30(pwdata30),
        //ahb30 inputs30
	. hclk30(smc_hclk30),
        . n_sys_reset30(rstn_non_srpg_smc30),
        . haddr30(smc_haddr30),
        . htrans30(smc_htrans30),
        . hsel30(smc_hsel_int30),
        . hwrite30(smc_hwrite30),
	. hsize30(smc_hsize30),
        . hwdata30(smc_hwdata30),
        . hready30(smc_hready_in30),
        . data_smc30(data_smc30),

         //test signal30 inputs30

        . scan_in_130(),
        . scan_in_230(),
        . scan_in_330(),
        . scan_en30(scan_en30),

        //apb30 outputs30
        . prdata30(prdata_smc30),

       //design output

        . smc_hrdata30(smc_hrdata30),
        . smc_hready30(smc_hready30),
        . smc_hresp30(smc_hresp30),
        . smc_valid30(smc_valid30),
        . smc_addr30(smc_addr_int30),
        . smc_data30(smc_data30),
        . smc_n_be30(smc_n_be30),
        . smc_n_cs30(smc_n_cs30),
        . smc_n_wr30(smc_n_wr30),
        . smc_n_we30(smc_n_we30),
        . smc_n_rd30(smc_n_rd30),
        . smc_n_ext_oe30(smc_n_ext_oe30),
        . smc_busy30(smc_busy30),

         //test signal30 output
        . scan_out_130(),
        . scan_out_230(),
        . scan_out_330()
);

power_ctrl_veneer30 i_power_ctrl_veneer30 (
    // -- Clocks30 & Reset30
    	.pclk30(pclk30), 			//  : in  std_logic30;
    	.nprst30(n_preset30), 		//  : in  std_logic30;
    // -- APB30 programming30 interface
    	.paddr30(paddr30), 			//  : in  std_logic_vector30(31 downto30 0);
    	.psel30(psel_pmc30), 			//  : in  std_logic30;
    	.penable30(penable30), 		//  : in  std_logic30;
    	.pwrite30(pwrite30), 		//  : in  std_logic30;
    	.pwdata30(pwdata30), 		//  : in  std_logic_vector30(31 downto30 0);
    	.prdata30(prdata_pmc30), 		//  : out std_logic_vector30(31 downto30 0);
        .macb3_wakeup30(macb3_wakeup30),
        .macb2_wakeup30(macb2_wakeup30),
        .macb1_wakeup30(macb1_wakeup30),
        .macb0_wakeup30(macb0_wakeup30),
    // -- Module30 control30 outputs30
    	.scan_in30(),			//  : in  std_logic30;
    	.scan_en30(scan_en30),             	//  : in  std_logic30;
    	.scan_mode30(scan_mode30),          //  : in  std_logic30;
    	.scan_out30(),            	//  : out std_logic30;
        .int_source_h30(int_source_h30),
     	.rstn_non_srpg_smc30(rstn_non_srpg_smc30), 		//   : out std_logic30;
    	.gate_clk_smc30(gate_clk_smc30), 	//  : out std_logic30;
    	.isolate_smc30(isolate_smc30), 	//  : out std_logic30;
    	.save_edge_smc30(save_edge_smc30), 	//  : out std_logic30;
    	.restore_edge_smc30(restore_edge_smc30), 	//  : out std_logic30;
    	.pwr1_on_smc30(pwr1_on_smc30), 	//  : out std_logic30;
    	.pwr2_on_smc30(pwr2_on_smc30), 	//  : out std_logic30
     	.rstn_non_srpg_urt30(rstn_non_srpg_urt30), 		//   : out std_logic30;
    	.gate_clk_urt30(gate_clk_urt30), 	//  : out std_logic30;
    	.isolate_urt30(isolate_urt30), 	//  : out std_logic30;
    	.save_edge_urt30(save_edge_urt30), 	//  : out std_logic30;
    	.restore_edge_urt30(restore_edge_urt30), 	//  : out std_logic30;
    	.pwr1_on_urt30(pwr1_on_urt30), 	//  : out std_logic30;
    	.pwr2_on_urt30(pwr2_on_urt30),  	//  : out std_logic30
        // ETH030
        .rstn_non_srpg_macb030(rstn_non_srpg_macb030),
        .gate_clk_macb030(gate_clk_macb030),
        .isolate_macb030(isolate_macb030),
        .save_edge_macb030(save_edge_macb030),
        .restore_edge_macb030(restore_edge_macb030),
        .pwr1_on_macb030(pwr1_on_macb030),
        .pwr2_on_macb030(pwr2_on_macb030),
        // ETH130
        .rstn_non_srpg_macb130(rstn_non_srpg_macb130),
        .gate_clk_macb130(gate_clk_macb130),
        .isolate_macb130(isolate_macb130),
        .save_edge_macb130(save_edge_macb130),
        .restore_edge_macb130(restore_edge_macb130),
        .pwr1_on_macb130(pwr1_on_macb130),
        .pwr2_on_macb130(pwr2_on_macb130),
        // ETH230
        .rstn_non_srpg_macb230(rstn_non_srpg_macb230),
        .gate_clk_macb230(gate_clk_macb230),
        .isolate_macb230(isolate_macb230),
        .save_edge_macb230(save_edge_macb230),
        .restore_edge_macb230(restore_edge_macb230),
        .pwr1_on_macb230(pwr1_on_macb230),
        .pwr2_on_macb230(pwr2_on_macb230),
        // ETH330
        .rstn_non_srpg_macb330(rstn_non_srpg_macb330),
        .gate_clk_macb330(gate_clk_macb330),
        .isolate_macb330(isolate_macb330),
        .save_edge_macb330(save_edge_macb330),
        .restore_edge_macb330(restore_edge_macb330),
        .pwr1_on_macb330(pwr1_on_macb330),
        .pwr2_on_macb330(pwr2_on_macb330),
        .core06v30(core06v30),
        .core08v30(core08v30),
        .core10v30(core10v30),
        .core12v30(core12v30),
        .pcm_macb_wakeup_int30(pcm_macb_wakeup_int30),
        .isolate_mem30(isolate_mem30),
        .mte_smc_start30(mte_smc_start30),
        .mte_uart_start30(mte_uart_start30),
        .mte_smc_uart_start30(mte_smc_uart_start30),  
        .mte_pm_smc_to_default_start30(mte_pm_smc_to_default_start30), 
        .mte_pm_uart_to_default_start30(mte_pm_uart_to_default_start30),
        .mte_pm_smc_uart_to_default_start30(mte_pm_smc_uart_to_default_start30)
);

// Clock30 gating30 macro30 to shut30 off30 clocks30 to the SRPG30 flops30 in the SMC30
//CKLNQD130 i_SMC_SRPG_clk_gate30  (
//	.TE30(scan_mode30), 
//	.E30(~gate_clk_smc30), 
//	.CP30(pclk30), 
//	.Q30(pclk_SRPG_smc30)
//	);
// Replace30 gate30 with behavioural30 code30 //
wire 	smc_scan_gate30;
reg 	smc_latched_enable30;
assign smc_scan_gate30 = scan_mode30 ? 1'b1 : ~gate_clk_smc30;

always @ (pclk30 or smc_scan_gate30)
  	if (pclk30 == 1'b0) begin
  		smc_latched_enable30 <= smc_scan_gate30;
  	end  	
	
assign pclk_SRPG_smc30 = smc_latched_enable30 ? pclk30 : 1'b0;


// Clock30 gating30 macro30 to shut30 off30 clocks30 to the SRPG30 flops30 in the URT30
//CKLNQD130 i_URT_SRPG_clk_gate30  (
//	.TE30(scan_mode30), 
//	.E30(~gate_clk_urt30), 
//	.CP30(pclk30), 
//	.Q30(pclk_SRPG_urt30)
//	);
// Replace30 gate30 with behavioural30 code30 //
wire 	urt_scan_gate30;
reg 	urt_latched_enable30;
assign urt_scan_gate30 = scan_mode30 ? 1'b1 : ~gate_clk_urt30;

always @ (pclk30 or urt_scan_gate30)
  	if (pclk30 == 1'b0) begin
  		urt_latched_enable30 <= urt_scan_gate30;
  	end  	
	
assign pclk_SRPG_urt30 = urt_latched_enable30 ? pclk30 : 1'b0;

// ETH030
wire 	macb0_scan_gate30;
reg 	macb0_latched_enable30;
assign macb0_scan_gate30 = scan_mode30 ? 1'b1 : ~gate_clk_macb030;

always @ (pclk30 or macb0_scan_gate30)
  	if (pclk30 == 1'b0) begin
  		macb0_latched_enable30 <= macb0_scan_gate30;
  	end  	
	
assign clk_SRPG_macb0_en30 = macb0_latched_enable30 ? 1'b1 : 1'b0;

// ETH130
wire 	macb1_scan_gate30;
reg 	macb1_latched_enable30;
assign macb1_scan_gate30 = scan_mode30 ? 1'b1 : ~gate_clk_macb130;

always @ (pclk30 or macb1_scan_gate30)
  	if (pclk30 == 1'b0) begin
  		macb1_latched_enable30 <= macb1_scan_gate30;
  	end  	
	
assign clk_SRPG_macb1_en30 = macb1_latched_enable30 ? 1'b1 : 1'b0;

// ETH230
wire 	macb2_scan_gate30;
reg 	macb2_latched_enable30;
assign macb2_scan_gate30 = scan_mode30 ? 1'b1 : ~gate_clk_macb230;

always @ (pclk30 or macb2_scan_gate30)
  	if (pclk30 == 1'b0) begin
  		macb2_latched_enable30 <= macb2_scan_gate30;
  	end  	
	
assign clk_SRPG_macb2_en30 = macb2_latched_enable30 ? 1'b1 : 1'b0;

// ETH330
wire 	macb3_scan_gate30;
reg 	macb3_latched_enable30;
assign macb3_scan_gate30 = scan_mode30 ? 1'b1 : ~gate_clk_macb330;

always @ (pclk30 or macb3_scan_gate30)
  	if (pclk30 == 1'b0) begin
  		macb3_latched_enable30 <= macb3_scan_gate30;
  	end  	
	
assign clk_SRPG_macb3_en30 = macb3_latched_enable30 ? 1'b1 : 1'b0;



`else
//------------------------------------------------------------------------------
// if the APB30 subsystem30 is black30 boxed30 
//------------------------------------------------------------------------------
// wire s ports30
    // system signals30
    wire         hclk30;     // AHB30 Clock30
    wire         n_hreset30;  // AHB30 reset - Active30 low30
    wire         pclk30;     // APB30 Clock30. 
    wire         n_preset30;  // APB30 reset - Active30 low30

    // AHB30 interface
    wire         ahb2apb0_hsel30;     // AHB2APB30 select30
    wire  [31:0] haddr30;    // Address bus
    wire  [1:0]  htrans30;   // Transfer30 type
    wire  [2:0]  hsize30;    // AHB30 Access type - byte, half30-word30, word30
    wire  [31:0] hwdata30;   // Write data
    wire         hwrite30;   // Write signal30/
    wire         hready_in30;// Indicates30 that last master30 has finished30 bus access
    wire [2:0]   hburst30;     // Burst type
    wire [3:0]   hprot30;      // Protection30 control30
    wire [3:0]   hmaster30;    // Master30 select30
    wire         hmastlock30;  // Locked30 transfer30
  // Interrupts30 from the Enet30 MACs30
    wire         macb0_int30;
    wire         macb1_int30;
    wire         macb2_int30;
    wire         macb3_int30;
  // Interrupt30 from the DMA30
    wire         DMA_irq30;
  // Scan30 wire s
    wire         scan_en30;    // Scan30 enable pin30
    wire         scan_in_130;  // Scan30 wire  for first chain30
    wire         scan_in_230;  // Scan30 wire  for second chain30
    wire         scan_mode30;  // test mode pin30
 
  //wire  for smc30 AHB30 interface
    wire         smc_hclk30;
    wire         smc_n_hclk30;
    wire  [31:0] smc_haddr30;
    wire  [1:0]  smc_htrans30;
    wire         smc_hsel30;
    wire         smc_hwrite30;
    wire  [2:0]  smc_hsize30;
    wire  [31:0] smc_hwdata30;
    wire         smc_hready_in30;
    wire  [2:0]  smc_hburst30;     // Burst type
    wire  [3:0]  smc_hprot30;      // Protection30 control30
    wire  [3:0]  smc_hmaster30;    // Master30 select30
    wire         smc_hmastlock30;  // Locked30 transfer30


    wire  [31:0] data_smc30;     // EMI30(External30 memory) read data
    
  //wire s for uart30
    wire         ua_rxd30;       // UART30 receiver30 serial30 wire  pin30
    wire         ua_rxd130;      // UART30 receiver30 serial30 wire  pin30
    wire         ua_ncts30;      // Clear-To30-Send30 flow30 control30
    wire         ua_ncts130;      // Clear-To30-Send30 flow30 control30
   //wire s for spi30
    wire         n_ss_in30;      // select30 wire  to slave30
    wire         mi30;           // data wire  to master30
    wire         si30;           // data wire  to slave30
    wire         sclk_in30;      // clock30 wire  to slave30
  //wire s for GPIO30
   wire  [GPIO_WIDTH30-1:0]  gpio_pin_in30;             // wire  data from pin30

  //reg    ports30
  // Scan30 reg   s
   reg           scan_out_130;   // Scan30 out for chain30 1
   reg           scan_out_230;   // Scan30 out for chain30 2
  //AHB30 interface 
   reg    [31:0] hrdata30;       // Read data provided from target slave30
   reg           hready30;       // Ready30 for new bus cycle from target slave30
   reg    [1:0]  hresp30;       // Response30 from the bridge30

   // SMC30 reg    for AHB30 interface
   reg    [31:0]    smc_hrdata30;
   reg              smc_hready30;
   reg    [1:0]     smc_hresp30;

  //reg   s from smc30
   reg    [15:0]    smc_addr30;      // External30 Memory (EMI30) address
   reg    [3:0]     smc_n_be30;      // EMI30 byte enables30 (Active30 LOW30)
   reg    [7:0]     smc_n_cs30;      // EMI30 Chip30 Selects30 (Active30 LOW30)
   reg    [3:0]     smc_n_we30;      // EMI30 write strobes30 (Active30 LOW30)
   reg              smc_n_wr30;      // EMI30 write enable (Active30 LOW30)
   reg              smc_n_rd30;      // EMI30 read stobe30 (Active30 LOW30)
   reg              smc_n_ext_oe30;  // EMI30 write data reg    enable
   reg    [31:0]    smc_data30;      // EMI30 write data
  //reg   s from uart30
   reg           ua_txd30;       	// UART30 transmitter30 serial30 reg   
   reg           ua_txd130;       // UART30 transmitter30 serial30 reg   
   reg           ua_nrts30;      	// Request30-To30-Send30 flow30 control30
   reg           ua_nrts130;      // Request30-To30-Send30 flow30 control30
   // reg   s from ttc30
  // reg   s from SPI30
   reg       so;                    // data reg    from slave30
   reg       mo30;                    // data reg    from master30
   reg       sclk_out30;              // clock30 reg    from master30
   reg    [P_SIZE30-1:0] n_ss_out30;    // peripheral30 select30 lines30 from master30
   reg       n_so_en30;               // out enable for slave30 data
   reg       n_mo_en30;               // out enable for master30 data
   reg       n_sclk_en30;             // out enable for master30 clock30
   reg       n_ss_en30;               // out enable for master30 peripheral30 lines30
  //reg   s from gpio30
   reg    [GPIO_WIDTH30-1:0]     n_gpio_pin_oe30;           // reg    enable signal30 to pin30
   reg    [GPIO_WIDTH30-1:0]     gpio_pin_out30;            // reg    signal30 to pin30


`endif
//------------------------------------------------------------------------------
// black30 boxed30 defines30 
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// APB30 and AHB30 interface formal30 verification30 monitors30
//------------------------------------------------------------------------------
`ifdef ABV_ON30
apb_assert30 i_apb_assert30 (

        // APB30 signals30
  	.n_preset30(n_preset30),
   	.pclk30(pclk30),
	.penable30(penable30),
	.paddr30(paddr30),
	.pwrite30(pwrite30),
	.pwdata30(pwdata30),

	.psel0030(psel_spi30),
	.psel0130(psel_uart030),
	.psel0230(psel_gpio30),
	.psel0330(psel_ttc30),
	.psel0430(1'b0),
	.psel0530(psel_smc30),
	.psel0630(1'b0),
	.psel0730(1'b0),
	.psel0830(1'b0),
	.psel0930(1'b0),
	.psel1030(1'b0),
	.psel1130(1'b0),
	.psel1230(1'b0),
	.psel1330(psel_pmc30),
	.psel1430(psel_apic30),
	.psel1530(psel_uart130),

        .prdata0030(prdata_spi30),
        .prdata0130(prdata_uart030), // Read Data from peripheral30 UART30 
        .prdata0230(prdata_gpio30), // Read Data from peripheral30 GPIO30
        .prdata0330(prdata_ttc30), // Read Data from peripheral30 TTC30
        .prdata0430(32'b0), // 
        .prdata0530(prdata_smc30), // Read Data from peripheral30 SMC30
        .prdata1330(prdata_pmc30), // Read Data from peripheral30 Power30 Control30 Block
   	.prdata1430(32'b0), // 
        .prdata1530(prdata_uart130),


        // AHB30 signals30
        .hclk30(hclk30),         // ahb30 system clock30
        .n_hreset30(n_hreset30), // ahb30 system reset

        // ahb2apb30 signals30
        .hresp30(hresp30),
        .hready30(hready30),
        .hrdata30(hrdata30),
        .hwdata30(hwdata30),
        .hprot30(hprot30),
        .hburst30(hburst30),
        .hsize30(hsize30),
        .hwrite30(hwrite30),
        .htrans30(htrans30),
        .haddr30(haddr30),
        .ahb2apb_hsel30(ahb2apb0_hsel30));



//------------------------------------------------------------------------------
// AHB30 interface formal30 verification30 monitor30
//------------------------------------------------------------------------------
defparam i_ahbSlaveMonitor30.DBUS_WIDTH30 = 32;
defparam i_ahbMasterMonitor30.DBUS_WIDTH30 = 32;


// AHB2APB30 Bridge30

    ahb_liteslave_monitor30 i_ahbSlaveMonitor30 (
        .hclk_i30(hclk30),
        .hresetn_i30(n_hreset30),
        .hresp30(hresp30),
        .hready30(hready30),
        .hready_global_i30(hready30),
        .hrdata30(hrdata30),
        .hwdata_i30(hwdata30),
        .hburst_i30(hburst30),
        .hsize_i30(hsize30),
        .hwrite_i30(hwrite30),
        .htrans_i30(htrans30),
        .haddr_i30(haddr30),
        .hsel_i30(ahb2apb0_hsel30)
    );


  ahb_litemaster_monitor30 i_ahbMasterMonitor30 (
          .hclk_i30(hclk30),
          .hresetn_i30(n_hreset30),
          .hresp_i30(hresp30),
          .hready_i30(hready30),
          .hrdata_i30(hrdata30),
          .hlock30(1'b0),
          .hwdata30(hwdata30),
          .hprot30(hprot30),
          .hburst30(hburst30),
          .hsize30(hsize30),
          .hwrite30(hwrite30),
          .htrans30(htrans30),
          .haddr30(haddr30)
          );







`endif




`ifdef IFV_LP_ABV_ON30
// power30 control30
wire isolate30;

// testbench mirror signals30
wire L1_ctrl_access30;
wire L1_status_access30;

wire [31:0] L1_status_reg30;
wire [31:0] L1_ctrl_reg30;

//wire rstn_non_srpg_urt30;
//wire isolate_urt30;
//wire retain_urt30;
//wire gate_clk_urt30;
//wire pwr1_on_urt30;


// smc30 signals30
wire [31:0] smc_prdata30;
wire lp_clk_smc30;
                    

// uart30 isolation30 register
  wire [15:0] ua_prdata30;
  wire ua_int30;
  assign ua_prdata30          =  i_uart1_veneer30.prdata30;
  assign ua_int30             =  i_uart1_veneer30.ua_int30;


assign lp_clk_smc30          = i_smc_veneer30.pclk30;
assign smc_prdata30          = i_smc_veneer30.prdata30;
lp_chk_smc30 u_lp_chk_smc30 (
    .clk30 (hclk30),
    .rst30 (n_hreset30),
    .iso_smc30 (isolate_smc30),
    .gate_clk30 (gate_clk_smc30),
    .lp_clk30 (pclk_SRPG_smc30),

    // srpg30 outputs30
    .smc_hrdata30 (smc_hrdata30),
    .smc_hready30 (smc_hready30),
    .smc_hresp30  (smc_hresp30),
    .smc_valid30 (smc_valid30),
    .smc_addr_int30 (smc_addr_int30),
    .smc_data30 (smc_data30),
    .smc_n_be30 (smc_n_be30),
    .smc_n_cs30  (smc_n_cs30),
    .smc_n_wr30 (smc_n_wr30),
    .smc_n_we30 (smc_n_we30),
    .smc_n_rd30 (smc_n_rd30),
    .smc_n_ext_oe30 (smc_n_ext_oe30)
   );

// lp30 retention30/isolation30 assertions30
lp_chk_uart30 u_lp_chk_urt30 (

  .clk30         (hclk30),
  .rst30         (n_hreset30),
  .iso_urt30     (isolate_urt30),
  .gate_clk30    (gate_clk_urt30),
  .lp_clk30      (pclk_SRPG_urt30),
  //ports30
  .prdata30 (ua_prdata30),
  .ua_int30 (ua_int30),
  .ua_txd30 (ua_txd130),
  .ua_nrts30 (ua_nrts130)
 );

`endif  //IFV_LP_ABV_ON30




endmodule
