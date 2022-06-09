//File24 name   : apb_subsystem_024.v
//Title24       : 
//Created24     : 1999
//Description24 : 
//Notes24       : 
//----------------------------------------------------------------------
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------

module apb_subsystem_024(
    // AHB24 interface
    hclk24,
    n_hreset24,
    hsel24,
    haddr24,
    htrans24,
    hsize24,
    hwrite24,
    hwdata24,
    hready_in24,
    hburst24,
    hprot24,
    hmaster24,
    hmastlock24,
    hrdata24,
    hready24,
    hresp24,
    
    // APB24 system interface
    pclk24,
    n_preset24,
    
    // SPI24 ports24
    n_ss_in24,
    mi24,
    si24,
    sclk_in24,
    so,
    mo24,
    sclk_out24,
    n_ss_out24,
    n_so_en24,
    n_mo_en24,
    n_sclk_en24,
    n_ss_en24,
    
    //UART024 ports24
    ua_rxd24,
    ua_ncts24,
    ua_txd24,
    ua_nrts24,
    
    //UART124 ports24
    ua_rxd124,
    ua_ncts124,
    ua_txd124,
    ua_nrts124,
    
    //GPIO24 ports24
    gpio_pin_in24,
    n_gpio_pin_oe24,
    gpio_pin_out24,
    

    //SMC24 ports24
    smc_hclk24,
    smc_n_hclk24,
    smc_haddr24,
    smc_htrans24,
    smc_hsel24,
    smc_hwrite24,
    smc_hsize24,
    smc_hwdata24,
    smc_hready_in24,
    smc_hburst24,
    smc_hprot24,
    smc_hmaster24,
    smc_hmastlock24,
    smc_hrdata24, 
    smc_hready24,
    smc_hresp24,
    smc_n_ext_oe24,
    smc_data24,
    smc_addr24,
    smc_n_be24,
    smc_n_cs24, 
    smc_n_we24,
    smc_n_wr24,
    smc_n_rd24,
    data_smc24,
    
    //PMC24 ports24
    clk_SRPG_macb0_en24,
    clk_SRPG_macb1_en24,
    clk_SRPG_macb2_en24,
    clk_SRPG_macb3_en24,
    core06v24,
    core08v24,
    core10v24,
    core12v24,
    macb3_wakeup24,
    macb2_wakeup24,
    macb1_wakeup24,
    macb0_wakeup24,
    mte_smc_start24,
    mte_uart_start24,
    mte_smc_uart_start24,  
    mte_pm_smc_to_default_start24, 
    mte_pm_uart_to_default_start24,
    mte_pm_smc_uart_to_default_start24,
    
    
    // Peripheral24 inerrupts24
    pcm_irq24,
    ttc_irq24,
    gpio_irq24,
    uart0_irq24,
    uart1_irq24,
    spi_irq24,
    DMA_irq24,      
    macb0_int24,
    macb1_int24,
    macb2_int24,
    macb3_int24,
   
    // Scan24 ports24
    scan_en24,      // Scan24 enable pin24
    scan_in_124,    // Scan24 input for first chain24
    scan_in_224,    // Scan24 input for second chain24
    scan_mode24,
    scan_out_124,   // Scan24 out for chain24 1
    scan_out_224    // Scan24 out for chain24 2
);

parameter GPIO_WIDTH24 = 16;        // GPIO24 width
parameter P_SIZE24 =   8;              // number24 of peripheral24 select24 lines24
parameter NO_OF_IRQS24  = 17;      //No of irqs24 read by apic24 

// AHB24 interface
input         hclk24;     // AHB24 Clock24
input         n_hreset24;  // AHB24 reset - Active24 low24
input         hsel24;     // AHB2APB24 select24
input [31:0]  haddr24;    // Address bus
input [1:0]   htrans24;   // Transfer24 type
input [2:0]   hsize24;    // AHB24 Access type - byte, half24-word24, word24
input [31:0]  hwdata24;   // Write data
input         hwrite24;   // Write signal24/
input         hready_in24;// Indicates24 that last master24 has finished24 bus access
input [2:0]   hburst24;     // Burst type
input [3:0]   hprot24;      // Protection24 control24
input [3:0]   hmaster24;    // Master24 select24
input         hmastlock24;  // Locked24 transfer24
output [31:0] hrdata24;       // Read data provided from target slave24
output        hready24;       // Ready24 for new bus cycle from target slave24
output [1:0]  hresp24;       // Response24 from the bridge24
    
// APB24 system interface
input         pclk24;     // APB24 Clock24. 
input         n_preset24;  // APB24 reset - Active24 low24
   
// SPI24 ports24
input     n_ss_in24;      // select24 input to slave24
input     mi24;           // data input to master24
input     si24;           // data input to slave24
input     sclk_in24;      // clock24 input to slave24
output    so;                    // data output from slave24
output    mo24;                    // data output from master24
output    sclk_out24;              // clock24 output from master24
output [P_SIZE24-1:0] n_ss_out24;    // peripheral24 select24 lines24 from master24
output    n_so_en24;               // out enable for slave24 data
output    n_mo_en24;               // out enable for master24 data
output    n_sclk_en24;             // out enable for master24 clock24
output    n_ss_en24;               // out enable for master24 peripheral24 lines24

//UART024 ports24
input        ua_rxd24;       // UART24 receiver24 serial24 input pin24
input        ua_ncts24;      // Clear-To24-Send24 flow24 control24
output       ua_txd24;       	// UART24 transmitter24 serial24 output
output       ua_nrts24;      	// Request24-To24-Send24 flow24 control24

// UART124 ports24   
input        ua_rxd124;      // UART24 receiver24 serial24 input pin24
input        ua_ncts124;      // Clear-To24-Send24 flow24 control24
output       ua_txd124;       // UART24 transmitter24 serial24 output
output       ua_nrts124;      // Request24-To24-Send24 flow24 control24

//GPIO24 ports24
input [GPIO_WIDTH24-1:0]      gpio_pin_in24;             // input data from pin24
output [GPIO_WIDTH24-1:0]     n_gpio_pin_oe24;           // output enable signal24 to pin24
output [GPIO_WIDTH24-1:0]     gpio_pin_out24;            // output signal24 to pin24
  
//SMC24 ports24
input        smc_hclk24;
input        smc_n_hclk24;
input [31:0] smc_haddr24;
input [1:0]  smc_htrans24;
input        smc_hsel24;
input        smc_hwrite24;
input [2:0]  smc_hsize24;
input [31:0] smc_hwdata24;
input        smc_hready_in24;
input [2:0]  smc_hburst24;     // Burst type
input [3:0]  smc_hprot24;      // Protection24 control24
input [3:0]  smc_hmaster24;    // Master24 select24
input        smc_hmastlock24;  // Locked24 transfer24
input [31:0] data_smc24;     // EMI24(External24 memory) read data
output [31:0]    smc_hrdata24;
output           smc_hready24;
output [1:0]     smc_hresp24;
output [15:0]    smc_addr24;      // External24 Memory (EMI24) address
output [3:0]     smc_n_be24;      // EMI24 byte enables24 (Active24 LOW24)
output           smc_n_cs24;      // EMI24 Chip24 Selects24 (Active24 LOW24)
output [3:0]     smc_n_we24;      // EMI24 write strobes24 (Active24 LOW24)
output           smc_n_wr24;      // EMI24 write enable (Active24 LOW24)
output           smc_n_rd24;      // EMI24 read stobe24 (Active24 LOW24)
output           smc_n_ext_oe24;  // EMI24 write data output enable
output [31:0]    smc_data24;      // EMI24 write data
       
//PMC24 ports24
output clk_SRPG_macb0_en24;
output clk_SRPG_macb1_en24;
output clk_SRPG_macb2_en24;
output clk_SRPG_macb3_en24;
output core06v24;
output core08v24;
output core10v24;
output core12v24;
output mte_smc_start24;
output mte_uart_start24;
output mte_smc_uart_start24;  
output mte_pm_smc_to_default_start24; 
output mte_pm_uart_to_default_start24;
output mte_pm_smc_uart_to_default_start24;
input macb3_wakeup24;
input macb2_wakeup24;
input macb1_wakeup24;
input macb0_wakeup24;
    

// Peripheral24 interrupts24
output pcm_irq24;
output [2:0] ttc_irq24;
output gpio_irq24;
output uart0_irq24;
output uart1_irq24;
output spi_irq24;
input        macb0_int24;
input        macb1_int24;
input        macb2_int24;
input        macb3_int24;
input        DMA_irq24;
  
//Scan24 ports24
input        scan_en24;    // Scan24 enable pin24
input        scan_in_124;  // Scan24 input for first chain24
input        scan_in_224;  // Scan24 input for second chain24
input        scan_mode24;  // test mode pin24
 output        scan_out_124;   // Scan24 out for chain24 1
 output        scan_out_224;   // Scan24 out for chain24 2  

//------------------------------------------------------------------------------
// if the ROM24 subsystem24 is NOT24 black24 boxed24 
//------------------------------------------------------------------------------
`ifndef FV_KIT_BLACK_BOX_APB_SUBSYSTEM24
   
   wire        hsel24; 
   wire        pclk24;
   wire        n_preset24;
   wire [31:0] prdata_spi24;
   wire [31:0] prdata_uart024;
   wire [31:0] prdata_gpio24;
   wire [31:0] prdata_ttc24;
   wire [31:0] prdata_smc24;
   wire [31:0] prdata_pmc24;
   wire [31:0] prdata_uart124;
   wire        pready_spi24;
   wire        pready_uart024;
   wire        pready_uart124;
   wire        tie_hi_bit24;
   wire  [31:0] hrdata24; 
   wire         hready24;
   wire         hready_in24;
   wire  [1:0]  hresp24;   
   wire  [31:0] pwdata24;  
   wire         pwrite24;
   wire  [31:0] paddr24;  
   wire   psel_spi24;
   wire   psel_uart024;
   wire   psel_gpio24;
   wire   psel_ttc24;
   wire   psel_smc24;
   wire   psel0724;
   wire   psel0824;
   wire   psel0924;
   wire   psel1024;
   wire   psel1124;
   wire   psel1224;
   wire   psel_pmc24;
   wire   psel_uart124;
   wire   penable24;
   wire   [NO_OF_IRQS24:0] int_source24;     // System24 Interrupt24 Sources24
   wire [1:0]             smc_hresp24;     // AHB24 Response24 signal24
   wire                   smc_valid24;     // Ack24 valid address

  //External24 memory interface (EMI24)
  wire [31:0]            smc_addr_int24;  // External24 Memory (EMI24) address
  wire [3:0]             smc_n_be24;      // EMI24 byte enables24 (Active24 LOW24)
  wire                   smc_n_cs24;      // EMI24 Chip24 Selects24 (Active24 LOW24)
  wire [3:0]             smc_n_we24;      // EMI24 write strobes24 (Active24 LOW24)
  wire                   smc_n_wr24;      // EMI24 write enable (Active24 LOW24)
  wire                   smc_n_rd24;      // EMI24 read stobe24 (Active24 LOW24)
 
  //AHB24 Memory Interface24 Control24
  wire                   smc_hsel_int24;
  wire                   smc_busy24;      // smc24 busy
   

//scan24 signals24

   wire                scan_in_124;        //scan24 input
   wire                scan_in_224;        //scan24 input
   wire                scan_en24;         //scan24 enable
   wire                scan_out_124;       //scan24 output
   wire                scan_out_224;       //scan24 output
   wire                byte_sel24;     // byte select24 from bridge24 1=byte, 0=2byte
   wire                UART_int24;     // UART24 module interrupt24 
   wire                ua_uclken24;    // Soft24 control24 of clock24
   wire                UART_int124;     // UART24 module interrupt24 
   wire                ua_uclken124;    // Soft24 control24 of clock24
   wire  [3:1]         TTC_int24;            //Interrupt24 from PCI24 
  // inputs24 to SPI24 
   wire    ext_clk24;                // external24 clock24
   wire    SPI_int24;             // interrupt24 request
  // outputs24 from SPI24
   wire    slave_out_clk24;         // modified slave24 clock24 output
 // gpio24 generic24 inputs24 
   wire  [GPIO_WIDTH24-1:0]   n_gpio_bypass_oe24;        // bypass24 mode enable 
   wire  [GPIO_WIDTH24-1:0]   gpio_bypass_out24;         // bypass24 mode output value 
   wire  [GPIO_WIDTH24-1:0]   tri_state_enable24;   // disables24 op enable -> z 
 // outputs24 
   //amba24 outputs24 
   // gpio24 generic24 outputs24 
   wire       GPIO_int24;                // gpio_interupt24 for input pin24 change 
   wire [GPIO_WIDTH24-1:0]     gpio_bypass_in24;          // bypass24 mode input data value  
                
   wire           cpu_debug24;        // Inhibits24 watchdog24 counter 
   wire            ex_wdz_n24;         // External24 Watchdog24 zero indication24
   wire           rstn_non_srpg_smc24; 
   wire           rstn_non_srpg_urt24;
   wire           isolate_smc24;
   wire           save_edge_smc24;
   wire           restore_edge_smc24;
   wire           save_edge_urt24;
   wire           restore_edge_urt24;
   wire           pwr1_on_smc24;
   wire           pwr2_on_smc24;
   wire           pwr1_on_urt24;
   wire           pwr2_on_urt24;
   // ETH024
   wire            rstn_non_srpg_macb024;
   wire            gate_clk_macb024;
   wire            isolate_macb024;
   wire            save_edge_macb024;
   wire            restore_edge_macb024;
   wire            pwr1_on_macb024;
   wire            pwr2_on_macb024;
   // ETH124
   wire            rstn_non_srpg_macb124;
   wire            gate_clk_macb124;
   wire            isolate_macb124;
   wire            save_edge_macb124;
   wire            restore_edge_macb124;
   wire            pwr1_on_macb124;
   wire            pwr2_on_macb124;
   // ETH224
   wire            rstn_non_srpg_macb224;
   wire            gate_clk_macb224;
   wire            isolate_macb224;
   wire            save_edge_macb224;
   wire            restore_edge_macb224;
   wire            pwr1_on_macb224;
   wire            pwr2_on_macb224;
   // ETH324
   wire            rstn_non_srpg_macb324;
   wire            gate_clk_macb324;
   wire            isolate_macb324;
   wire            save_edge_macb324;
   wire            restore_edge_macb324;
   wire            pwr1_on_macb324;
   wire            pwr2_on_macb324;


   wire           pclk_SRPG_smc24;
   wire           pclk_SRPG_urt24;
   wire           gate_clk_smc24;
   wire           gate_clk_urt24;
   wire  [31:0]   tie_lo_32bit24; 
   wire  [1:0]	  tie_lo_2bit24;
   wire  	  tie_lo_1bit24;
   wire           pcm_macb_wakeup_int24;
   wire           int_source_h24;
   wire           isolate_mem24;

assign pcm_irq24 = pcm_macb_wakeup_int24;
assign ttc_irq24[2] = TTC_int24[3];
assign ttc_irq24[1] = TTC_int24[2];
assign ttc_irq24[0] = TTC_int24[1];
assign gpio_irq24 = GPIO_int24;
assign uart0_irq24 = UART_int24;
assign uart1_irq24 = UART_int124;
assign spi_irq24 = SPI_int24;

assign n_mo_en24   = 1'b0;
assign n_so_en24   = 1'b1;
assign n_sclk_en24 = 1'b0;
assign n_ss_en24   = 1'b0;

assign smc_hsel_int24 = smc_hsel24;
  assign ext_clk24  = 1'b0;
  assign int_source24 = {macb0_int24,macb1_int24, macb2_int24, macb3_int24,1'b0, pcm_macb_wakeup_int24, 1'b0, 1'b0, 1'b0, 1'b0, TTC_int24, GPIO_int24, UART_int24, UART_int124, SPI_int24, DMA_irq24};

  // interrupt24 even24 detect24 .
  // for sleep24 wake24 up -> any interrupt24 even24 and system not in hibernation24 (isolate_mem24 = 0)
  // for hibernate24 wake24 up -> gpio24 interrupt24 even24 and system in the hibernation24 (isolate_mem24 = 1)
  assign int_source_h24 =  ((|int_source24) && (!isolate_mem24)) || (isolate_mem24 && GPIO_int24) ;

  assign byte_sel24 = 1'b1;
  assign tie_hi_bit24 = 1'b1;

  assign smc_addr24 = smc_addr_int24[15:0];



  assign  n_gpio_bypass_oe24 = {GPIO_WIDTH24{1'b0}};        // bypass24 mode enable 
  assign  gpio_bypass_out24  = {GPIO_WIDTH24{1'b0}};
  assign  tri_state_enable24 = {GPIO_WIDTH24{1'b0}};
  assign  cpu_debug24 = 1'b0;
  assign  tie_lo_32bit24 = 32'b0;
  assign  tie_lo_2bit24  = 2'b0;
  assign  tie_lo_1bit24  = 1'b0;


ahb2apb24 #(
  32'h00800000, // Slave24 0 Address Range24
  32'h0080FFFF,

  32'h00810000, // Slave24 1 Address Range24
  32'h0081FFFF,

  32'h00820000, // Slave24 2 Address Range24 
  32'h0082FFFF,

  32'h00830000, // Slave24 3 Address Range24
  32'h0083FFFF,

  32'h00840000, // Slave24 4 Address Range24
  32'h0084FFFF,

  32'h00850000, // Slave24 5 Address Range24
  32'h0085FFFF,

  32'h00860000, // Slave24 6 Address Range24
  32'h0086FFFF,

  32'h00870000, // Slave24 7 Address Range24
  32'h0087FFFF,

  32'h00880000, // Slave24 8 Address Range24
  32'h0088FFFF
) i_ahb2apb24 (
     // AHB24 interface
    .hclk24(hclk24),         
    .hreset_n24(n_hreset24), 
    .hsel24(hsel24), 
    .haddr24(haddr24),        
    .htrans24(htrans24),       
    .hwrite24(hwrite24),       
    .hwdata24(hwdata24),       
    .hrdata24(hrdata24),   
    .hready24(hready24),   
    .hresp24(hresp24),     
    
     // APB24 interface
    .pclk24(pclk24),         
    .preset_n24(n_preset24),  
    .prdata024(prdata_spi24),
    .prdata124(prdata_uart024), 
    .prdata224(prdata_gpio24),  
    .prdata324(prdata_ttc24),   
    .prdata424(32'h0),   
    .prdata524(prdata_smc24),   
    .prdata624(prdata_pmc24),    
    .prdata724(32'h0),   
    .prdata824(prdata_uart124),  
    .pready024(pready_spi24),     
    .pready124(pready_uart024),   
    .pready224(tie_hi_bit24),     
    .pready324(tie_hi_bit24),     
    .pready424(tie_hi_bit24),     
    .pready524(tie_hi_bit24),     
    .pready624(tie_hi_bit24),     
    .pready724(tie_hi_bit24),     
    .pready824(pready_uart124),  
    .pwdata24(pwdata24),       
    .pwrite24(pwrite24),       
    .paddr24(paddr24),        
    .psel024(psel_spi24),     
    .psel124(psel_uart024),   
    .psel224(psel_gpio24),    
    .psel324(psel_ttc24),     
    .psel424(),     
    .psel524(psel_smc24),     
    .psel624(psel_pmc24),    
    .psel724(psel_apic24),   
    .psel824(psel_uart124),  
    .penable24(penable24)     
);

spi_top24 i_spi24
(
  // Wishbone24 signals24
  .wb_clk_i24(pclk24), 
  .wb_rst_i24(~n_preset24), 
  .wb_adr_i24(paddr24[4:0]), 
  .wb_dat_i24(pwdata24), 
  .wb_dat_o24(prdata_spi24), 
  .wb_sel_i24(4'b1111),    // SPI24 register accesses are always 32-bit
  .wb_we_i24(pwrite24), 
  .wb_stb_i24(psel_spi24), 
  .wb_cyc_i24(psel_spi24), 
  .wb_ack_o24(pready_spi24), 
  .wb_err_o24(), 
  .wb_int_o24(SPI_int24),

  // SPI24 signals24
  .ss_pad_o24(n_ss_out24), 
  .sclk_pad_o24(sclk_out24), 
  .mosi_pad_o24(mo24), 
  .miso_pad_i24(mi24)
);

// Opencores24 UART24 instances24
wire ua_nrts_int24;
wire ua_nrts1_int24;

assign ua_nrts24 = ua_nrts_int24;
assign ua_nrts124 = ua_nrts1_int24;

reg [3:0] uart0_sel_i24;
reg [3:0] uart1_sel_i24;
// UART24 registers are all 8-bit wide24, and their24 addresses24
// are on byte boundaries24. So24 to access them24 on the
// Wishbone24 bus, the CPU24 must do byte accesses to these24
// byte addresses24. Word24 address accesses are not possible24
// because the word24 addresses24 will be unaligned24, and cause
// a fault24.
// So24, Uart24 accesses from the CPU24 will always be 8-bit size
// We24 only have to decide24 which byte of the 4-byte word24 the
// CPU24 is interested24 in.
`ifdef SYSTEM_BIG_ENDIAN24
always @(paddr24) begin
  case (paddr24[1:0])
    2'b00 : uart0_sel_i24 = 4'b1000;
    2'b01 : uart0_sel_i24 = 4'b0100;
    2'b10 : uart0_sel_i24 = 4'b0010;
    2'b11 : uart0_sel_i24 = 4'b0001;
  endcase
end
always @(paddr24) begin
  case (paddr24[1:0])
    2'b00 : uart1_sel_i24 = 4'b1000;
    2'b01 : uart1_sel_i24 = 4'b0100;
    2'b10 : uart1_sel_i24 = 4'b0010;
    2'b11 : uart1_sel_i24 = 4'b0001;
  endcase
end
`else
always @(paddr24) begin
  case (paddr24[1:0])
    2'b00 : uart0_sel_i24 = 4'b0001;
    2'b01 : uart0_sel_i24 = 4'b0010;
    2'b10 : uart0_sel_i24 = 4'b0100;
    2'b11 : uart0_sel_i24 = 4'b1000;
  endcase
end
always @(paddr24) begin
  case (paddr24[1:0])
    2'b00 : uart1_sel_i24 = 4'b0001;
    2'b01 : uart1_sel_i24 = 4'b0010;
    2'b10 : uart1_sel_i24 = 4'b0100;
    2'b11 : uart1_sel_i24 = 4'b1000;
  endcase
end
`endif

uart_top24 i_oc_uart024 (
  .wb_clk_i24(pclk24),
  .wb_rst_i24(~n_preset24),
  .wb_adr_i24(paddr24[4:0]),
  .wb_dat_i24(pwdata24),
  .wb_dat_o24(prdata_uart024),
  .wb_we_i24(pwrite24),
  .wb_stb_i24(psel_uart024),
  .wb_cyc_i24(psel_uart024),
  .wb_ack_o24(pready_uart024),
  .wb_sel_i24(uart0_sel_i24),
  .int_o24(UART_int24),
  .stx_pad_o24(ua_txd24),
  .srx_pad_i24(ua_rxd24),
  .rts_pad_o24(ua_nrts_int24),
  .cts_pad_i24(ua_ncts24),
  .dtr_pad_o24(),
  .dsr_pad_i24(1'b0),
  .ri_pad_i24(1'b0),
  .dcd_pad_i24(1'b0)
);

uart_top24 i_oc_uart124 (
  .wb_clk_i24(pclk24),
  .wb_rst_i24(~n_preset24),
  .wb_adr_i24(paddr24[4:0]),
  .wb_dat_i24(pwdata24),
  .wb_dat_o24(prdata_uart124),
  .wb_we_i24(pwrite24),
  .wb_stb_i24(psel_uart124),
  .wb_cyc_i24(psel_uart124),
  .wb_ack_o24(pready_uart124),
  .wb_sel_i24(uart1_sel_i24),
  .int_o24(UART_int124),
  .stx_pad_o24(ua_txd124),
  .srx_pad_i24(ua_rxd124),
  .rts_pad_o24(ua_nrts1_int24),
  .cts_pad_i24(ua_ncts124),
  .dtr_pad_o24(),
  .dsr_pad_i24(1'b0),
  .ri_pad_i24(1'b0),
  .dcd_pad_i24(1'b0)
);

gpio_veneer24 i_gpio_veneer24 (
        //inputs24

        . n_p_reset24(n_preset24),
        . pclk24(pclk24),
        . psel24(psel_gpio24),
        . penable24(penable24),
        . pwrite24(pwrite24),
        . paddr24(paddr24[5:0]),
        . pwdata24(pwdata24),
        . gpio_pin_in24(gpio_pin_in24),
        . scan_en24(scan_en24),
        . tri_state_enable24(tri_state_enable24),
        . scan_in24(), //added by smarkov24 for dft24

        //outputs24
        . scan_out24(), //added by smarkov24 for dft24
        . prdata24(prdata_gpio24),
        . gpio_int24(GPIO_int24),
        . n_gpio_pin_oe24(n_gpio_pin_oe24),
        . gpio_pin_out24(gpio_pin_out24)
);


ttc_veneer24 i_ttc_veneer24 (

         //inputs24
        . n_p_reset24(n_preset24),
        . pclk24(pclk24),
        . psel24(psel_ttc24),
        . penable24(penable24),
        . pwrite24(pwrite24),
        . pwdata24(pwdata24),
        . paddr24(paddr24[7:0]),
        . scan_in24(),
        . scan_en24(scan_en24),

        //outputs24
        . prdata24(prdata_ttc24),
        . interrupt24(TTC_int24[3:1]),
        . scan_out24()
);


smc_veneer24 i_smc_veneer24 (
        //inputs24
	//apb24 inputs24
        . n_preset24(n_preset24),
        . pclk24(pclk_SRPG_smc24),
        . psel24(psel_smc24),
        . penable24(penable24),
        . pwrite24(pwrite24),
        . paddr24(paddr24[4:0]),
        . pwdata24(pwdata24),
        //ahb24 inputs24
	. hclk24(smc_hclk24),
        . n_sys_reset24(rstn_non_srpg_smc24),
        . haddr24(smc_haddr24),
        . htrans24(smc_htrans24),
        . hsel24(smc_hsel_int24),
        . hwrite24(smc_hwrite24),
	. hsize24(smc_hsize24),
        . hwdata24(smc_hwdata24),
        . hready24(smc_hready_in24),
        . data_smc24(data_smc24),

         //test signal24 inputs24

        . scan_in_124(),
        . scan_in_224(),
        . scan_in_324(),
        . scan_en24(scan_en24),

        //apb24 outputs24
        . prdata24(prdata_smc24),

       //design output

        . smc_hrdata24(smc_hrdata24),
        . smc_hready24(smc_hready24),
        . smc_hresp24(smc_hresp24),
        . smc_valid24(smc_valid24),
        . smc_addr24(smc_addr_int24),
        . smc_data24(smc_data24),
        . smc_n_be24(smc_n_be24),
        . smc_n_cs24(smc_n_cs24),
        . smc_n_wr24(smc_n_wr24),
        . smc_n_we24(smc_n_we24),
        . smc_n_rd24(smc_n_rd24),
        . smc_n_ext_oe24(smc_n_ext_oe24),
        . smc_busy24(smc_busy24),

         //test signal24 output
        . scan_out_124(),
        . scan_out_224(),
        . scan_out_324()
);

power_ctrl_veneer24 i_power_ctrl_veneer24 (
    // -- Clocks24 & Reset24
    	.pclk24(pclk24), 			//  : in  std_logic24;
    	.nprst24(n_preset24), 		//  : in  std_logic24;
    // -- APB24 programming24 interface
    	.paddr24(paddr24), 			//  : in  std_logic_vector24(31 downto24 0);
    	.psel24(psel_pmc24), 			//  : in  std_logic24;
    	.penable24(penable24), 		//  : in  std_logic24;
    	.pwrite24(pwrite24), 		//  : in  std_logic24;
    	.pwdata24(pwdata24), 		//  : in  std_logic_vector24(31 downto24 0);
    	.prdata24(prdata_pmc24), 		//  : out std_logic_vector24(31 downto24 0);
        .macb3_wakeup24(macb3_wakeup24),
        .macb2_wakeup24(macb2_wakeup24),
        .macb1_wakeup24(macb1_wakeup24),
        .macb0_wakeup24(macb0_wakeup24),
    // -- Module24 control24 outputs24
    	.scan_in24(),			//  : in  std_logic24;
    	.scan_en24(scan_en24),             	//  : in  std_logic24;
    	.scan_mode24(scan_mode24),          //  : in  std_logic24;
    	.scan_out24(),            	//  : out std_logic24;
        .int_source_h24(int_source_h24),
     	.rstn_non_srpg_smc24(rstn_non_srpg_smc24), 		//   : out std_logic24;
    	.gate_clk_smc24(gate_clk_smc24), 	//  : out std_logic24;
    	.isolate_smc24(isolate_smc24), 	//  : out std_logic24;
    	.save_edge_smc24(save_edge_smc24), 	//  : out std_logic24;
    	.restore_edge_smc24(restore_edge_smc24), 	//  : out std_logic24;
    	.pwr1_on_smc24(pwr1_on_smc24), 	//  : out std_logic24;
    	.pwr2_on_smc24(pwr2_on_smc24), 	//  : out std_logic24
     	.rstn_non_srpg_urt24(rstn_non_srpg_urt24), 		//   : out std_logic24;
    	.gate_clk_urt24(gate_clk_urt24), 	//  : out std_logic24;
    	.isolate_urt24(isolate_urt24), 	//  : out std_logic24;
    	.save_edge_urt24(save_edge_urt24), 	//  : out std_logic24;
    	.restore_edge_urt24(restore_edge_urt24), 	//  : out std_logic24;
    	.pwr1_on_urt24(pwr1_on_urt24), 	//  : out std_logic24;
    	.pwr2_on_urt24(pwr2_on_urt24),  	//  : out std_logic24
        // ETH024
        .rstn_non_srpg_macb024(rstn_non_srpg_macb024),
        .gate_clk_macb024(gate_clk_macb024),
        .isolate_macb024(isolate_macb024),
        .save_edge_macb024(save_edge_macb024),
        .restore_edge_macb024(restore_edge_macb024),
        .pwr1_on_macb024(pwr1_on_macb024),
        .pwr2_on_macb024(pwr2_on_macb024),
        // ETH124
        .rstn_non_srpg_macb124(rstn_non_srpg_macb124),
        .gate_clk_macb124(gate_clk_macb124),
        .isolate_macb124(isolate_macb124),
        .save_edge_macb124(save_edge_macb124),
        .restore_edge_macb124(restore_edge_macb124),
        .pwr1_on_macb124(pwr1_on_macb124),
        .pwr2_on_macb124(pwr2_on_macb124),
        // ETH224
        .rstn_non_srpg_macb224(rstn_non_srpg_macb224),
        .gate_clk_macb224(gate_clk_macb224),
        .isolate_macb224(isolate_macb224),
        .save_edge_macb224(save_edge_macb224),
        .restore_edge_macb224(restore_edge_macb224),
        .pwr1_on_macb224(pwr1_on_macb224),
        .pwr2_on_macb224(pwr2_on_macb224),
        // ETH324
        .rstn_non_srpg_macb324(rstn_non_srpg_macb324),
        .gate_clk_macb324(gate_clk_macb324),
        .isolate_macb324(isolate_macb324),
        .save_edge_macb324(save_edge_macb324),
        .restore_edge_macb324(restore_edge_macb324),
        .pwr1_on_macb324(pwr1_on_macb324),
        .pwr2_on_macb324(pwr2_on_macb324),
        .core06v24(core06v24),
        .core08v24(core08v24),
        .core10v24(core10v24),
        .core12v24(core12v24),
        .pcm_macb_wakeup_int24(pcm_macb_wakeup_int24),
        .isolate_mem24(isolate_mem24),
        .mte_smc_start24(mte_smc_start24),
        .mte_uart_start24(mte_uart_start24),
        .mte_smc_uart_start24(mte_smc_uart_start24),  
        .mte_pm_smc_to_default_start24(mte_pm_smc_to_default_start24), 
        .mte_pm_uart_to_default_start24(mte_pm_uart_to_default_start24),
        .mte_pm_smc_uart_to_default_start24(mte_pm_smc_uart_to_default_start24)
);

// Clock24 gating24 macro24 to shut24 off24 clocks24 to the SRPG24 flops24 in the SMC24
//CKLNQD124 i_SMC_SRPG_clk_gate24  (
//	.TE24(scan_mode24), 
//	.E24(~gate_clk_smc24), 
//	.CP24(pclk24), 
//	.Q24(pclk_SRPG_smc24)
//	);
// Replace24 gate24 with behavioural24 code24 //
wire 	smc_scan_gate24;
reg 	smc_latched_enable24;
assign smc_scan_gate24 = scan_mode24 ? 1'b1 : ~gate_clk_smc24;

always @ (pclk24 or smc_scan_gate24)
  	if (pclk24 == 1'b0) begin
  		smc_latched_enable24 <= smc_scan_gate24;
  	end  	
	
assign pclk_SRPG_smc24 = smc_latched_enable24 ? pclk24 : 1'b0;


// Clock24 gating24 macro24 to shut24 off24 clocks24 to the SRPG24 flops24 in the URT24
//CKLNQD124 i_URT_SRPG_clk_gate24  (
//	.TE24(scan_mode24), 
//	.E24(~gate_clk_urt24), 
//	.CP24(pclk24), 
//	.Q24(pclk_SRPG_urt24)
//	);
// Replace24 gate24 with behavioural24 code24 //
wire 	urt_scan_gate24;
reg 	urt_latched_enable24;
assign urt_scan_gate24 = scan_mode24 ? 1'b1 : ~gate_clk_urt24;

always @ (pclk24 or urt_scan_gate24)
  	if (pclk24 == 1'b0) begin
  		urt_latched_enable24 <= urt_scan_gate24;
  	end  	
	
assign pclk_SRPG_urt24 = urt_latched_enable24 ? pclk24 : 1'b0;

// ETH024
wire 	macb0_scan_gate24;
reg 	macb0_latched_enable24;
assign macb0_scan_gate24 = scan_mode24 ? 1'b1 : ~gate_clk_macb024;

always @ (pclk24 or macb0_scan_gate24)
  	if (pclk24 == 1'b0) begin
  		macb0_latched_enable24 <= macb0_scan_gate24;
  	end  	
	
assign clk_SRPG_macb0_en24 = macb0_latched_enable24 ? 1'b1 : 1'b0;

// ETH124
wire 	macb1_scan_gate24;
reg 	macb1_latched_enable24;
assign macb1_scan_gate24 = scan_mode24 ? 1'b1 : ~gate_clk_macb124;

always @ (pclk24 or macb1_scan_gate24)
  	if (pclk24 == 1'b0) begin
  		macb1_latched_enable24 <= macb1_scan_gate24;
  	end  	
	
assign clk_SRPG_macb1_en24 = macb1_latched_enable24 ? 1'b1 : 1'b0;

// ETH224
wire 	macb2_scan_gate24;
reg 	macb2_latched_enable24;
assign macb2_scan_gate24 = scan_mode24 ? 1'b1 : ~gate_clk_macb224;

always @ (pclk24 or macb2_scan_gate24)
  	if (pclk24 == 1'b0) begin
  		macb2_latched_enable24 <= macb2_scan_gate24;
  	end  	
	
assign clk_SRPG_macb2_en24 = macb2_latched_enable24 ? 1'b1 : 1'b0;

// ETH324
wire 	macb3_scan_gate24;
reg 	macb3_latched_enable24;
assign macb3_scan_gate24 = scan_mode24 ? 1'b1 : ~gate_clk_macb324;

always @ (pclk24 or macb3_scan_gate24)
  	if (pclk24 == 1'b0) begin
  		macb3_latched_enable24 <= macb3_scan_gate24;
  	end  	
	
assign clk_SRPG_macb3_en24 = macb3_latched_enable24 ? 1'b1 : 1'b0;



`else
//------------------------------------------------------------------------------
// if the APB24 subsystem24 is black24 boxed24 
//------------------------------------------------------------------------------
// wire s ports24
    // system signals24
    wire         hclk24;     // AHB24 Clock24
    wire         n_hreset24;  // AHB24 reset - Active24 low24
    wire         pclk24;     // APB24 Clock24. 
    wire         n_preset24;  // APB24 reset - Active24 low24

    // AHB24 interface
    wire         ahb2apb0_hsel24;     // AHB2APB24 select24
    wire  [31:0] haddr24;    // Address bus
    wire  [1:0]  htrans24;   // Transfer24 type
    wire  [2:0]  hsize24;    // AHB24 Access type - byte, half24-word24, word24
    wire  [31:0] hwdata24;   // Write data
    wire         hwrite24;   // Write signal24/
    wire         hready_in24;// Indicates24 that last master24 has finished24 bus access
    wire [2:0]   hburst24;     // Burst type
    wire [3:0]   hprot24;      // Protection24 control24
    wire [3:0]   hmaster24;    // Master24 select24
    wire         hmastlock24;  // Locked24 transfer24
  // Interrupts24 from the Enet24 MACs24
    wire         macb0_int24;
    wire         macb1_int24;
    wire         macb2_int24;
    wire         macb3_int24;
  // Interrupt24 from the DMA24
    wire         DMA_irq24;
  // Scan24 wire s
    wire         scan_en24;    // Scan24 enable pin24
    wire         scan_in_124;  // Scan24 wire  for first chain24
    wire         scan_in_224;  // Scan24 wire  for second chain24
    wire         scan_mode24;  // test mode pin24
 
  //wire  for smc24 AHB24 interface
    wire         smc_hclk24;
    wire         smc_n_hclk24;
    wire  [31:0] smc_haddr24;
    wire  [1:0]  smc_htrans24;
    wire         smc_hsel24;
    wire         smc_hwrite24;
    wire  [2:0]  smc_hsize24;
    wire  [31:0] smc_hwdata24;
    wire         smc_hready_in24;
    wire  [2:0]  smc_hburst24;     // Burst type
    wire  [3:0]  smc_hprot24;      // Protection24 control24
    wire  [3:0]  smc_hmaster24;    // Master24 select24
    wire         smc_hmastlock24;  // Locked24 transfer24


    wire  [31:0] data_smc24;     // EMI24(External24 memory) read data
    
  //wire s for uart24
    wire         ua_rxd24;       // UART24 receiver24 serial24 wire  pin24
    wire         ua_rxd124;      // UART24 receiver24 serial24 wire  pin24
    wire         ua_ncts24;      // Clear-To24-Send24 flow24 control24
    wire         ua_ncts124;      // Clear-To24-Send24 flow24 control24
   //wire s for spi24
    wire         n_ss_in24;      // select24 wire  to slave24
    wire         mi24;           // data wire  to master24
    wire         si24;           // data wire  to slave24
    wire         sclk_in24;      // clock24 wire  to slave24
  //wire s for GPIO24
   wire  [GPIO_WIDTH24-1:0]  gpio_pin_in24;             // wire  data from pin24

  //reg    ports24
  // Scan24 reg   s
   reg           scan_out_124;   // Scan24 out for chain24 1
   reg           scan_out_224;   // Scan24 out for chain24 2
  //AHB24 interface 
   reg    [31:0] hrdata24;       // Read data provided from target slave24
   reg           hready24;       // Ready24 for new bus cycle from target slave24
   reg    [1:0]  hresp24;       // Response24 from the bridge24

   // SMC24 reg    for AHB24 interface
   reg    [31:0]    smc_hrdata24;
   reg              smc_hready24;
   reg    [1:0]     smc_hresp24;

  //reg   s from smc24
   reg    [15:0]    smc_addr24;      // External24 Memory (EMI24) address
   reg    [3:0]     smc_n_be24;      // EMI24 byte enables24 (Active24 LOW24)
   reg    [7:0]     smc_n_cs24;      // EMI24 Chip24 Selects24 (Active24 LOW24)
   reg    [3:0]     smc_n_we24;      // EMI24 write strobes24 (Active24 LOW24)
   reg              smc_n_wr24;      // EMI24 write enable (Active24 LOW24)
   reg              smc_n_rd24;      // EMI24 read stobe24 (Active24 LOW24)
   reg              smc_n_ext_oe24;  // EMI24 write data reg    enable
   reg    [31:0]    smc_data24;      // EMI24 write data
  //reg   s from uart24
   reg           ua_txd24;       	// UART24 transmitter24 serial24 reg   
   reg           ua_txd124;       // UART24 transmitter24 serial24 reg   
   reg           ua_nrts24;      	// Request24-To24-Send24 flow24 control24
   reg           ua_nrts124;      // Request24-To24-Send24 flow24 control24
   // reg   s from ttc24
  // reg   s from SPI24
   reg       so;                    // data reg    from slave24
   reg       mo24;                    // data reg    from master24
   reg       sclk_out24;              // clock24 reg    from master24
   reg    [P_SIZE24-1:0] n_ss_out24;    // peripheral24 select24 lines24 from master24
   reg       n_so_en24;               // out enable for slave24 data
   reg       n_mo_en24;               // out enable for master24 data
   reg       n_sclk_en24;             // out enable for master24 clock24
   reg       n_ss_en24;               // out enable for master24 peripheral24 lines24
  //reg   s from gpio24
   reg    [GPIO_WIDTH24-1:0]     n_gpio_pin_oe24;           // reg    enable signal24 to pin24
   reg    [GPIO_WIDTH24-1:0]     gpio_pin_out24;            // reg    signal24 to pin24


`endif
//------------------------------------------------------------------------------
// black24 boxed24 defines24 
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// APB24 and AHB24 interface formal24 verification24 monitors24
//------------------------------------------------------------------------------
`ifdef ABV_ON24
apb_assert24 i_apb_assert24 (

        // APB24 signals24
  	.n_preset24(n_preset24),
   	.pclk24(pclk24),
	.penable24(penable24),
	.paddr24(paddr24),
	.pwrite24(pwrite24),
	.pwdata24(pwdata24),

	.psel0024(psel_spi24),
	.psel0124(psel_uart024),
	.psel0224(psel_gpio24),
	.psel0324(psel_ttc24),
	.psel0424(1'b0),
	.psel0524(psel_smc24),
	.psel0624(1'b0),
	.psel0724(1'b0),
	.psel0824(1'b0),
	.psel0924(1'b0),
	.psel1024(1'b0),
	.psel1124(1'b0),
	.psel1224(1'b0),
	.psel1324(psel_pmc24),
	.psel1424(psel_apic24),
	.psel1524(psel_uart124),

        .prdata0024(prdata_spi24),
        .prdata0124(prdata_uart024), // Read Data from peripheral24 UART24 
        .prdata0224(prdata_gpio24), // Read Data from peripheral24 GPIO24
        .prdata0324(prdata_ttc24), // Read Data from peripheral24 TTC24
        .prdata0424(32'b0), // 
        .prdata0524(prdata_smc24), // Read Data from peripheral24 SMC24
        .prdata1324(prdata_pmc24), // Read Data from peripheral24 Power24 Control24 Block
   	.prdata1424(32'b0), // 
        .prdata1524(prdata_uart124),


        // AHB24 signals24
        .hclk24(hclk24),         // ahb24 system clock24
        .n_hreset24(n_hreset24), // ahb24 system reset

        // ahb2apb24 signals24
        .hresp24(hresp24),
        .hready24(hready24),
        .hrdata24(hrdata24),
        .hwdata24(hwdata24),
        .hprot24(hprot24),
        .hburst24(hburst24),
        .hsize24(hsize24),
        .hwrite24(hwrite24),
        .htrans24(htrans24),
        .haddr24(haddr24),
        .ahb2apb_hsel24(ahb2apb0_hsel24));



//------------------------------------------------------------------------------
// AHB24 interface formal24 verification24 monitor24
//------------------------------------------------------------------------------
defparam i_ahbSlaveMonitor24.DBUS_WIDTH24 = 32;
defparam i_ahbMasterMonitor24.DBUS_WIDTH24 = 32;


// AHB2APB24 Bridge24

    ahb_liteslave_monitor24 i_ahbSlaveMonitor24 (
        .hclk_i24(hclk24),
        .hresetn_i24(n_hreset24),
        .hresp24(hresp24),
        .hready24(hready24),
        .hready_global_i24(hready24),
        .hrdata24(hrdata24),
        .hwdata_i24(hwdata24),
        .hburst_i24(hburst24),
        .hsize_i24(hsize24),
        .hwrite_i24(hwrite24),
        .htrans_i24(htrans24),
        .haddr_i24(haddr24),
        .hsel_i24(ahb2apb0_hsel24)
    );


  ahb_litemaster_monitor24 i_ahbMasterMonitor24 (
          .hclk_i24(hclk24),
          .hresetn_i24(n_hreset24),
          .hresp_i24(hresp24),
          .hready_i24(hready24),
          .hrdata_i24(hrdata24),
          .hlock24(1'b0),
          .hwdata24(hwdata24),
          .hprot24(hprot24),
          .hburst24(hburst24),
          .hsize24(hsize24),
          .hwrite24(hwrite24),
          .htrans24(htrans24),
          .haddr24(haddr24)
          );







`endif




`ifdef IFV_LP_ABV_ON24
// power24 control24
wire isolate24;

// testbench mirror signals24
wire L1_ctrl_access24;
wire L1_status_access24;

wire [31:0] L1_status_reg24;
wire [31:0] L1_ctrl_reg24;

//wire rstn_non_srpg_urt24;
//wire isolate_urt24;
//wire retain_urt24;
//wire gate_clk_urt24;
//wire pwr1_on_urt24;


// smc24 signals24
wire [31:0] smc_prdata24;
wire lp_clk_smc24;
                    

// uart24 isolation24 register
  wire [15:0] ua_prdata24;
  wire ua_int24;
  assign ua_prdata24          =  i_uart1_veneer24.prdata24;
  assign ua_int24             =  i_uart1_veneer24.ua_int24;


assign lp_clk_smc24          = i_smc_veneer24.pclk24;
assign smc_prdata24          = i_smc_veneer24.prdata24;
lp_chk_smc24 u_lp_chk_smc24 (
    .clk24 (hclk24),
    .rst24 (n_hreset24),
    .iso_smc24 (isolate_smc24),
    .gate_clk24 (gate_clk_smc24),
    .lp_clk24 (pclk_SRPG_smc24),

    // srpg24 outputs24
    .smc_hrdata24 (smc_hrdata24),
    .smc_hready24 (smc_hready24),
    .smc_hresp24  (smc_hresp24),
    .smc_valid24 (smc_valid24),
    .smc_addr_int24 (smc_addr_int24),
    .smc_data24 (smc_data24),
    .smc_n_be24 (smc_n_be24),
    .smc_n_cs24  (smc_n_cs24),
    .smc_n_wr24 (smc_n_wr24),
    .smc_n_we24 (smc_n_we24),
    .smc_n_rd24 (smc_n_rd24),
    .smc_n_ext_oe24 (smc_n_ext_oe24)
   );

// lp24 retention24/isolation24 assertions24
lp_chk_uart24 u_lp_chk_urt24 (

  .clk24         (hclk24),
  .rst24         (n_hreset24),
  .iso_urt24     (isolate_urt24),
  .gate_clk24    (gate_clk_urt24),
  .lp_clk24      (pclk_SRPG_urt24),
  //ports24
  .prdata24 (ua_prdata24),
  .ua_int24 (ua_int24),
  .ua_txd24 (ua_txd124),
  .ua_nrts24 (ua_nrts124)
 );

`endif  //IFV_LP_ABV_ON24




endmodule
