//File8 name   : apb_subsystem_08.v
//Title8       : 
//Created8     : 1999
//Description8 : 
//Notes8       : 
//----------------------------------------------------------------------
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------

module apb_subsystem_08(
    // AHB8 interface
    hclk8,
    n_hreset8,
    hsel8,
    haddr8,
    htrans8,
    hsize8,
    hwrite8,
    hwdata8,
    hready_in8,
    hburst8,
    hprot8,
    hmaster8,
    hmastlock8,
    hrdata8,
    hready8,
    hresp8,
    
    // APB8 system interface
    pclk8,
    n_preset8,
    
    // SPI8 ports8
    n_ss_in8,
    mi8,
    si8,
    sclk_in8,
    so,
    mo8,
    sclk_out8,
    n_ss_out8,
    n_so_en8,
    n_mo_en8,
    n_sclk_en8,
    n_ss_en8,
    
    //UART08 ports8
    ua_rxd8,
    ua_ncts8,
    ua_txd8,
    ua_nrts8,
    
    //UART18 ports8
    ua_rxd18,
    ua_ncts18,
    ua_txd18,
    ua_nrts18,
    
    //GPIO8 ports8
    gpio_pin_in8,
    n_gpio_pin_oe8,
    gpio_pin_out8,
    

    //SMC8 ports8
    smc_hclk8,
    smc_n_hclk8,
    smc_haddr8,
    smc_htrans8,
    smc_hsel8,
    smc_hwrite8,
    smc_hsize8,
    smc_hwdata8,
    smc_hready_in8,
    smc_hburst8,
    smc_hprot8,
    smc_hmaster8,
    smc_hmastlock8,
    smc_hrdata8, 
    smc_hready8,
    smc_hresp8,
    smc_n_ext_oe8,
    smc_data8,
    smc_addr8,
    smc_n_be8,
    smc_n_cs8, 
    smc_n_we8,
    smc_n_wr8,
    smc_n_rd8,
    data_smc8,
    
    //PMC8 ports8
    clk_SRPG_macb0_en8,
    clk_SRPG_macb1_en8,
    clk_SRPG_macb2_en8,
    clk_SRPG_macb3_en8,
    core06v8,
    core08v8,
    core10v8,
    core12v8,
    macb3_wakeup8,
    macb2_wakeup8,
    macb1_wakeup8,
    macb0_wakeup8,
    mte_smc_start8,
    mte_uart_start8,
    mte_smc_uart_start8,  
    mte_pm_smc_to_default_start8, 
    mte_pm_uart_to_default_start8,
    mte_pm_smc_uart_to_default_start8,
    
    
    // Peripheral8 inerrupts8
    pcm_irq8,
    ttc_irq8,
    gpio_irq8,
    uart0_irq8,
    uart1_irq8,
    spi_irq8,
    DMA_irq8,      
    macb0_int8,
    macb1_int8,
    macb2_int8,
    macb3_int8,
   
    // Scan8 ports8
    scan_en8,      // Scan8 enable pin8
    scan_in_18,    // Scan8 input for first chain8
    scan_in_28,    // Scan8 input for second chain8
    scan_mode8,
    scan_out_18,   // Scan8 out for chain8 1
    scan_out_28    // Scan8 out for chain8 2
);

parameter GPIO_WIDTH8 = 16;        // GPIO8 width
parameter P_SIZE8 =   8;              // number8 of peripheral8 select8 lines8
parameter NO_OF_IRQS8  = 17;      //No of irqs8 read by apic8 

// AHB8 interface
input         hclk8;     // AHB8 Clock8
input         n_hreset8;  // AHB8 reset - Active8 low8
input         hsel8;     // AHB2APB8 select8
input [31:0]  haddr8;    // Address bus
input [1:0]   htrans8;   // Transfer8 type
input [2:0]   hsize8;    // AHB8 Access type - byte, half8-word8, word8
input [31:0]  hwdata8;   // Write data
input         hwrite8;   // Write signal8/
input         hready_in8;// Indicates8 that last master8 has finished8 bus access
input [2:0]   hburst8;     // Burst type
input [3:0]   hprot8;      // Protection8 control8
input [3:0]   hmaster8;    // Master8 select8
input         hmastlock8;  // Locked8 transfer8
output [31:0] hrdata8;       // Read data provided from target slave8
output        hready8;       // Ready8 for new bus cycle from target slave8
output [1:0]  hresp8;       // Response8 from the bridge8
    
// APB8 system interface
input         pclk8;     // APB8 Clock8. 
input         n_preset8;  // APB8 reset - Active8 low8
   
// SPI8 ports8
input     n_ss_in8;      // select8 input to slave8
input     mi8;           // data input to master8
input     si8;           // data input to slave8
input     sclk_in8;      // clock8 input to slave8
output    so;                    // data output from slave8
output    mo8;                    // data output from master8
output    sclk_out8;              // clock8 output from master8
output [P_SIZE8-1:0] n_ss_out8;    // peripheral8 select8 lines8 from master8
output    n_so_en8;               // out enable for slave8 data
output    n_mo_en8;               // out enable for master8 data
output    n_sclk_en8;             // out enable for master8 clock8
output    n_ss_en8;               // out enable for master8 peripheral8 lines8

//UART08 ports8
input        ua_rxd8;       // UART8 receiver8 serial8 input pin8
input        ua_ncts8;      // Clear-To8-Send8 flow8 control8
output       ua_txd8;       	// UART8 transmitter8 serial8 output
output       ua_nrts8;      	// Request8-To8-Send8 flow8 control8

// UART18 ports8   
input        ua_rxd18;      // UART8 receiver8 serial8 input pin8
input        ua_ncts18;      // Clear-To8-Send8 flow8 control8
output       ua_txd18;       // UART8 transmitter8 serial8 output
output       ua_nrts18;      // Request8-To8-Send8 flow8 control8

//GPIO8 ports8
input [GPIO_WIDTH8-1:0]      gpio_pin_in8;             // input data from pin8
output [GPIO_WIDTH8-1:0]     n_gpio_pin_oe8;           // output enable signal8 to pin8
output [GPIO_WIDTH8-1:0]     gpio_pin_out8;            // output signal8 to pin8
  
//SMC8 ports8
input        smc_hclk8;
input        smc_n_hclk8;
input [31:0] smc_haddr8;
input [1:0]  smc_htrans8;
input        smc_hsel8;
input        smc_hwrite8;
input [2:0]  smc_hsize8;
input [31:0] smc_hwdata8;
input        smc_hready_in8;
input [2:0]  smc_hburst8;     // Burst type
input [3:0]  smc_hprot8;      // Protection8 control8
input [3:0]  smc_hmaster8;    // Master8 select8
input        smc_hmastlock8;  // Locked8 transfer8
input [31:0] data_smc8;     // EMI8(External8 memory) read data
output [31:0]    smc_hrdata8;
output           smc_hready8;
output [1:0]     smc_hresp8;
output [15:0]    smc_addr8;      // External8 Memory (EMI8) address
output [3:0]     smc_n_be8;      // EMI8 byte enables8 (Active8 LOW8)
output           smc_n_cs8;      // EMI8 Chip8 Selects8 (Active8 LOW8)
output [3:0]     smc_n_we8;      // EMI8 write strobes8 (Active8 LOW8)
output           smc_n_wr8;      // EMI8 write enable (Active8 LOW8)
output           smc_n_rd8;      // EMI8 read stobe8 (Active8 LOW8)
output           smc_n_ext_oe8;  // EMI8 write data output enable
output [31:0]    smc_data8;      // EMI8 write data
       
//PMC8 ports8
output clk_SRPG_macb0_en8;
output clk_SRPG_macb1_en8;
output clk_SRPG_macb2_en8;
output clk_SRPG_macb3_en8;
output core06v8;
output core08v8;
output core10v8;
output core12v8;
output mte_smc_start8;
output mte_uart_start8;
output mte_smc_uart_start8;  
output mte_pm_smc_to_default_start8; 
output mte_pm_uart_to_default_start8;
output mte_pm_smc_uart_to_default_start8;
input macb3_wakeup8;
input macb2_wakeup8;
input macb1_wakeup8;
input macb0_wakeup8;
    

// Peripheral8 interrupts8
output pcm_irq8;
output [2:0] ttc_irq8;
output gpio_irq8;
output uart0_irq8;
output uart1_irq8;
output spi_irq8;
input        macb0_int8;
input        macb1_int8;
input        macb2_int8;
input        macb3_int8;
input        DMA_irq8;
  
//Scan8 ports8
input        scan_en8;    // Scan8 enable pin8
input        scan_in_18;  // Scan8 input for first chain8
input        scan_in_28;  // Scan8 input for second chain8
input        scan_mode8;  // test mode pin8
 output        scan_out_18;   // Scan8 out for chain8 1
 output        scan_out_28;   // Scan8 out for chain8 2  

//------------------------------------------------------------------------------
// if the ROM8 subsystem8 is NOT8 black8 boxed8 
//------------------------------------------------------------------------------
`ifndef FV_KIT_BLACK_BOX_APB_SUBSYSTEM8
   
   wire        hsel8; 
   wire        pclk8;
   wire        n_preset8;
   wire [31:0] prdata_spi8;
   wire [31:0] prdata_uart08;
   wire [31:0] prdata_gpio8;
   wire [31:0] prdata_ttc8;
   wire [31:0] prdata_smc8;
   wire [31:0] prdata_pmc8;
   wire [31:0] prdata_uart18;
   wire        pready_spi8;
   wire        pready_uart08;
   wire        pready_uart18;
   wire        tie_hi_bit8;
   wire  [31:0] hrdata8; 
   wire         hready8;
   wire         hready_in8;
   wire  [1:0]  hresp8;   
   wire  [31:0] pwdata8;  
   wire         pwrite8;
   wire  [31:0] paddr8;  
   wire   psel_spi8;
   wire   psel_uart08;
   wire   psel_gpio8;
   wire   psel_ttc8;
   wire   psel_smc8;
   wire   psel078;
   wire   psel088;
   wire   psel098;
   wire   psel108;
   wire   psel118;
   wire   psel128;
   wire   psel_pmc8;
   wire   psel_uart18;
   wire   penable8;
   wire   [NO_OF_IRQS8:0] int_source8;     // System8 Interrupt8 Sources8
   wire [1:0]             smc_hresp8;     // AHB8 Response8 signal8
   wire                   smc_valid8;     // Ack8 valid address

  //External8 memory interface (EMI8)
  wire [31:0]            smc_addr_int8;  // External8 Memory (EMI8) address
  wire [3:0]             smc_n_be8;      // EMI8 byte enables8 (Active8 LOW8)
  wire                   smc_n_cs8;      // EMI8 Chip8 Selects8 (Active8 LOW8)
  wire [3:0]             smc_n_we8;      // EMI8 write strobes8 (Active8 LOW8)
  wire                   smc_n_wr8;      // EMI8 write enable (Active8 LOW8)
  wire                   smc_n_rd8;      // EMI8 read stobe8 (Active8 LOW8)
 
  //AHB8 Memory Interface8 Control8
  wire                   smc_hsel_int8;
  wire                   smc_busy8;      // smc8 busy
   

//scan8 signals8

   wire                scan_in_18;        //scan8 input
   wire                scan_in_28;        //scan8 input
   wire                scan_en8;         //scan8 enable
   wire                scan_out_18;       //scan8 output
   wire                scan_out_28;       //scan8 output
   wire                byte_sel8;     // byte select8 from bridge8 1=byte, 0=2byte
   wire                UART_int8;     // UART8 module interrupt8 
   wire                ua_uclken8;    // Soft8 control8 of clock8
   wire                UART_int18;     // UART8 module interrupt8 
   wire                ua_uclken18;    // Soft8 control8 of clock8
   wire  [3:1]         TTC_int8;            //Interrupt8 from PCI8 
  // inputs8 to SPI8 
   wire    ext_clk8;                // external8 clock8
   wire    SPI_int8;             // interrupt8 request
  // outputs8 from SPI8
   wire    slave_out_clk8;         // modified slave8 clock8 output
 // gpio8 generic8 inputs8 
   wire  [GPIO_WIDTH8-1:0]   n_gpio_bypass_oe8;        // bypass8 mode enable 
   wire  [GPIO_WIDTH8-1:0]   gpio_bypass_out8;         // bypass8 mode output value 
   wire  [GPIO_WIDTH8-1:0]   tri_state_enable8;   // disables8 op enable -> z 
 // outputs8 
   //amba8 outputs8 
   // gpio8 generic8 outputs8 
   wire       GPIO_int8;                // gpio_interupt8 for input pin8 change 
   wire [GPIO_WIDTH8-1:0]     gpio_bypass_in8;          // bypass8 mode input data value  
                
   wire           cpu_debug8;        // Inhibits8 watchdog8 counter 
   wire            ex_wdz_n8;         // External8 Watchdog8 zero indication8
   wire           rstn_non_srpg_smc8; 
   wire           rstn_non_srpg_urt8;
   wire           isolate_smc8;
   wire           save_edge_smc8;
   wire           restore_edge_smc8;
   wire           save_edge_urt8;
   wire           restore_edge_urt8;
   wire           pwr1_on_smc8;
   wire           pwr2_on_smc8;
   wire           pwr1_on_urt8;
   wire           pwr2_on_urt8;
   // ETH08
   wire            rstn_non_srpg_macb08;
   wire            gate_clk_macb08;
   wire            isolate_macb08;
   wire            save_edge_macb08;
   wire            restore_edge_macb08;
   wire            pwr1_on_macb08;
   wire            pwr2_on_macb08;
   // ETH18
   wire            rstn_non_srpg_macb18;
   wire            gate_clk_macb18;
   wire            isolate_macb18;
   wire            save_edge_macb18;
   wire            restore_edge_macb18;
   wire            pwr1_on_macb18;
   wire            pwr2_on_macb18;
   // ETH28
   wire            rstn_non_srpg_macb28;
   wire            gate_clk_macb28;
   wire            isolate_macb28;
   wire            save_edge_macb28;
   wire            restore_edge_macb28;
   wire            pwr1_on_macb28;
   wire            pwr2_on_macb28;
   // ETH38
   wire            rstn_non_srpg_macb38;
   wire            gate_clk_macb38;
   wire            isolate_macb38;
   wire            save_edge_macb38;
   wire            restore_edge_macb38;
   wire            pwr1_on_macb38;
   wire            pwr2_on_macb38;


   wire           pclk_SRPG_smc8;
   wire           pclk_SRPG_urt8;
   wire           gate_clk_smc8;
   wire           gate_clk_urt8;
   wire  [31:0]   tie_lo_32bit8; 
   wire  [1:0]	  tie_lo_2bit8;
   wire  	  tie_lo_1bit8;
   wire           pcm_macb_wakeup_int8;
   wire           int_source_h8;
   wire           isolate_mem8;

assign pcm_irq8 = pcm_macb_wakeup_int8;
assign ttc_irq8[2] = TTC_int8[3];
assign ttc_irq8[1] = TTC_int8[2];
assign ttc_irq8[0] = TTC_int8[1];
assign gpio_irq8 = GPIO_int8;
assign uart0_irq8 = UART_int8;
assign uart1_irq8 = UART_int18;
assign spi_irq8 = SPI_int8;

assign n_mo_en8   = 1'b0;
assign n_so_en8   = 1'b1;
assign n_sclk_en8 = 1'b0;
assign n_ss_en8   = 1'b0;

assign smc_hsel_int8 = smc_hsel8;
  assign ext_clk8  = 1'b0;
  assign int_source8 = {macb0_int8,macb1_int8, macb2_int8, macb3_int8,1'b0, pcm_macb_wakeup_int8, 1'b0, 1'b0, 1'b0, 1'b0, TTC_int8, GPIO_int8, UART_int8, UART_int18, SPI_int8, DMA_irq8};

  // interrupt8 even8 detect8 .
  // for sleep8 wake8 up -> any interrupt8 even8 and system not in hibernation8 (isolate_mem8 = 0)
  // for hibernate8 wake8 up -> gpio8 interrupt8 even8 and system in the hibernation8 (isolate_mem8 = 1)
  assign int_source_h8 =  ((|int_source8) && (!isolate_mem8)) || (isolate_mem8 && GPIO_int8) ;

  assign byte_sel8 = 1'b1;
  assign tie_hi_bit8 = 1'b1;

  assign smc_addr8 = smc_addr_int8[15:0];



  assign  n_gpio_bypass_oe8 = {GPIO_WIDTH8{1'b0}};        // bypass8 mode enable 
  assign  gpio_bypass_out8  = {GPIO_WIDTH8{1'b0}};
  assign  tri_state_enable8 = {GPIO_WIDTH8{1'b0}};
  assign  cpu_debug8 = 1'b0;
  assign  tie_lo_32bit8 = 32'b0;
  assign  tie_lo_2bit8  = 2'b0;
  assign  tie_lo_1bit8  = 1'b0;


ahb2apb8 #(
  32'h00800000, // Slave8 0 Address Range8
  32'h0080FFFF,

  32'h00810000, // Slave8 1 Address Range8
  32'h0081FFFF,

  32'h00820000, // Slave8 2 Address Range8 
  32'h0082FFFF,

  32'h00830000, // Slave8 3 Address Range8
  32'h0083FFFF,

  32'h00840000, // Slave8 4 Address Range8
  32'h0084FFFF,

  32'h00850000, // Slave8 5 Address Range8
  32'h0085FFFF,

  32'h00860000, // Slave8 6 Address Range8
  32'h0086FFFF,

  32'h00870000, // Slave8 7 Address Range8
  32'h0087FFFF,

  32'h00880000, // Slave8 8 Address Range8
  32'h0088FFFF
) i_ahb2apb8 (
     // AHB8 interface
    .hclk8(hclk8),         
    .hreset_n8(n_hreset8), 
    .hsel8(hsel8), 
    .haddr8(haddr8),        
    .htrans8(htrans8),       
    .hwrite8(hwrite8),       
    .hwdata8(hwdata8),       
    .hrdata8(hrdata8),   
    .hready8(hready8),   
    .hresp8(hresp8),     
    
     // APB8 interface
    .pclk8(pclk8),         
    .preset_n8(n_preset8),  
    .prdata08(prdata_spi8),
    .prdata18(prdata_uart08), 
    .prdata28(prdata_gpio8),  
    .prdata38(prdata_ttc8),   
    .prdata48(32'h0),   
    .prdata58(prdata_smc8),   
    .prdata68(prdata_pmc8),    
    .prdata78(32'h0),   
    .prdata88(prdata_uart18),  
    .pready08(pready_spi8),     
    .pready18(pready_uart08),   
    .pready28(tie_hi_bit8),     
    .pready38(tie_hi_bit8),     
    .pready48(tie_hi_bit8),     
    .pready58(tie_hi_bit8),     
    .pready68(tie_hi_bit8),     
    .pready78(tie_hi_bit8),     
    .pready88(pready_uart18),  
    .pwdata8(pwdata8),       
    .pwrite8(pwrite8),       
    .paddr8(paddr8),        
    .psel08(psel_spi8),     
    .psel18(psel_uart08),   
    .psel28(psel_gpio8),    
    .psel38(psel_ttc8),     
    .psel48(),     
    .psel58(psel_smc8),     
    .psel68(psel_pmc8),    
    .psel78(psel_apic8),   
    .psel88(psel_uart18),  
    .penable8(penable8)     
);

spi_top8 i_spi8
(
  // Wishbone8 signals8
  .wb_clk_i8(pclk8), 
  .wb_rst_i8(~n_preset8), 
  .wb_adr_i8(paddr8[4:0]), 
  .wb_dat_i8(pwdata8), 
  .wb_dat_o8(prdata_spi8), 
  .wb_sel_i8(4'b1111),    // SPI8 register accesses are always 32-bit
  .wb_we_i8(pwrite8), 
  .wb_stb_i8(psel_spi8), 
  .wb_cyc_i8(psel_spi8), 
  .wb_ack_o8(pready_spi8), 
  .wb_err_o8(), 
  .wb_int_o8(SPI_int8),

  // SPI8 signals8
  .ss_pad_o8(n_ss_out8), 
  .sclk_pad_o8(sclk_out8), 
  .mosi_pad_o8(mo8), 
  .miso_pad_i8(mi8)
);

// Opencores8 UART8 instances8
wire ua_nrts_int8;
wire ua_nrts1_int8;

assign ua_nrts8 = ua_nrts_int8;
assign ua_nrts18 = ua_nrts1_int8;

reg [3:0] uart0_sel_i8;
reg [3:0] uart1_sel_i8;
// UART8 registers are all 8-bit wide8, and their8 addresses8
// are on byte boundaries8. So8 to access them8 on the
// Wishbone8 bus, the CPU8 must do byte accesses to these8
// byte addresses8. Word8 address accesses are not possible8
// because the word8 addresses8 will be unaligned8, and cause
// a fault8.
// So8, Uart8 accesses from the CPU8 will always be 8-bit size
// We8 only have to decide8 which byte of the 4-byte word8 the
// CPU8 is interested8 in.
`ifdef SYSTEM_BIG_ENDIAN8
always @(paddr8) begin
  case (paddr8[1:0])
    2'b00 : uart0_sel_i8 = 4'b1000;
    2'b01 : uart0_sel_i8 = 4'b0100;
    2'b10 : uart0_sel_i8 = 4'b0010;
    2'b11 : uart0_sel_i8 = 4'b0001;
  endcase
end
always @(paddr8) begin
  case (paddr8[1:0])
    2'b00 : uart1_sel_i8 = 4'b1000;
    2'b01 : uart1_sel_i8 = 4'b0100;
    2'b10 : uart1_sel_i8 = 4'b0010;
    2'b11 : uart1_sel_i8 = 4'b0001;
  endcase
end
`else
always @(paddr8) begin
  case (paddr8[1:0])
    2'b00 : uart0_sel_i8 = 4'b0001;
    2'b01 : uart0_sel_i8 = 4'b0010;
    2'b10 : uart0_sel_i8 = 4'b0100;
    2'b11 : uart0_sel_i8 = 4'b1000;
  endcase
end
always @(paddr8) begin
  case (paddr8[1:0])
    2'b00 : uart1_sel_i8 = 4'b0001;
    2'b01 : uart1_sel_i8 = 4'b0010;
    2'b10 : uart1_sel_i8 = 4'b0100;
    2'b11 : uart1_sel_i8 = 4'b1000;
  endcase
end
`endif

uart_top8 i_oc_uart08 (
  .wb_clk_i8(pclk8),
  .wb_rst_i8(~n_preset8),
  .wb_adr_i8(paddr8[4:0]),
  .wb_dat_i8(pwdata8),
  .wb_dat_o8(prdata_uart08),
  .wb_we_i8(pwrite8),
  .wb_stb_i8(psel_uart08),
  .wb_cyc_i8(psel_uart08),
  .wb_ack_o8(pready_uart08),
  .wb_sel_i8(uart0_sel_i8),
  .int_o8(UART_int8),
  .stx_pad_o8(ua_txd8),
  .srx_pad_i8(ua_rxd8),
  .rts_pad_o8(ua_nrts_int8),
  .cts_pad_i8(ua_ncts8),
  .dtr_pad_o8(),
  .dsr_pad_i8(1'b0),
  .ri_pad_i8(1'b0),
  .dcd_pad_i8(1'b0)
);

uart_top8 i_oc_uart18 (
  .wb_clk_i8(pclk8),
  .wb_rst_i8(~n_preset8),
  .wb_adr_i8(paddr8[4:0]),
  .wb_dat_i8(pwdata8),
  .wb_dat_o8(prdata_uart18),
  .wb_we_i8(pwrite8),
  .wb_stb_i8(psel_uart18),
  .wb_cyc_i8(psel_uart18),
  .wb_ack_o8(pready_uart18),
  .wb_sel_i8(uart1_sel_i8),
  .int_o8(UART_int18),
  .stx_pad_o8(ua_txd18),
  .srx_pad_i8(ua_rxd18),
  .rts_pad_o8(ua_nrts1_int8),
  .cts_pad_i8(ua_ncts18),
  .dtr_pad_o8(),
  .dsr_pad_i8(1'b0),
  .ri_pad_i8(1'b0),
  .dcd_pad_i8(1'b0)
);

gpio_veneer8 i_gpio_veneer8 (
        //inputs8

        . n_p_reset8(n_preset8),
        . pclk8(pclk8),
        . psel8(psel_gpio8),
        . penable8(penable8),
        . pwrite8(pwrite8),
        . paddr8(paddr8[5:0]),
        . pwdata8(pwdata8),
        . gpio_pin_in8(gpio_pin_in8),
        . scan_en8(scan_en8),
        . tri_state_enable8(tri_state_enable8),
        . scan_in8(), //added by smarkov8 for dft8

        //outputs8
        . scan_out8(), //added by smarkov8 for dft8
        . prdata8(prdata_gpio8),
        . gpio_int8(GPIO_int8),
        . n_gpio_pin_oe8(n_gpio_pin_oe8),
        . gpio_pin_out8(gpio_pin_out8)
);


ttc_veneer8 i_ttc_veneer8 (

         //inputs8
        . n_p_reset8(n_preset8),
        . pclk8(pclk8),
        . psel8(psel_ttc8),
        . penable8(penable8),
        . pwrite8(pwrite8),
        . pwdata8(pwdata8),
        . paddr8(paddr8[7:0]),
        . scan_in8(),
        . scan_en8(scan_en8),

        //outputs8
        . prdata8(prdata_ttc8),
        . interrupt8(TTC_int8[3:1]),
        . scan_out8()
);


smc_veneer8 i_smc_veneer8 (
        //inputs8
	//apb8 inputs8
        . n_preset8(n_preset8),
        . pclk8(pclk_SRPG_smc8),
        . psel8(psel_smc8),
        . penable8(penable8),
        . pwrite8(pwrite8),
        . paddr8(paddr8[4:0]),
        . pwdata8(pwdata8),
        //ahb8 inputs8
	. hclk8(smc_hclk8),
        . n_sys_reset8(rstn_non_srpg_smc8),
        . haddr8(smc_haddr8),
        . htrans8(smc_htrans8),
        . hsel8(smc_hsel_int8),
        . hwrite8(smc_hwrite8),
	. hsize8(smc_hsize8),
        . hwdata8(smc_hwdata8),
        . hready8(smc_hready_in8),
        . data_smc8(data_smc8),

         //test signal8 inputs8

        . scan_in_18(),
        . scan_in_28(),
        . scan_in_38(),
        . scan_en8(scan_en8),

        //apb8 outputs8
        . prdata8(prdata_smc8),

       //design output

        . smc_hrdata8(smc_hrdata8),
        . smc_hready8(smc_hready8),
        . smc_hresp8(smc_hresp8),
        . smc_valid8(smc_valid8),
        . smc_addr8(smc_addr_int8),
        . smc_data8(smc_data8),
        . smc_n_be8(smc_n_be8),
        . smc_n_cs8(smc_n_cs8),
        . smc_n_wr8(smc_n_wr8),
        . smc_n_we8(smc_n_we8),
        . smc_n_rd8(smc_n_rd8),
        . smc_n_ext_oe8(smc_n_ext_oe8),
        . smc_busy8(smc_busy8),

         //test signal8 output
        . scan_out_18(),
        . scan_out_28(),
        . scan_out_38()
);

power_ctrl_veneer8 i_power_ctrl_veneer8 (
    // -- Clocks8 & Reset8
    	.pclk8(pclk8), 			//  : in  std_logic8;
    	.nprst8(n_preset8), 		//  : in  std_logic8;
    // -- APB8 programming8 interface
    	.paddr8(paddr8), 			//  : in  std_logic_vector8(31 downto8 0);
    	.psel8(psel_pmc8), 			//  : in  std_logic8;
    	.penable8(penable8), 		//  : in  std_logic8;
    	.pwrite8(pwrite8), 		//  : in  std_logic8;
    	.pwdata8(pwdata8), 		//  : in  std_logic_vector8(31 downto8 0);
    	.prdata8(prdata_pmc8), 		//  : out std_logic_vector8(31 downto8 0);
        .macb3_wakeup8(macb3_wakeup8),
        .macb2_wakeup8(macb2_wakeup8),
        .macb1_wakeup8(macb1_wakeup8),
        .macb0_wakeup8(macb0_wakeup8),
    // -- Module8 control8 outputs8
    	.scan_in8(),			//  : in  std_logic8;
    	.scan_en8(scan_en8),             	//  : in  std_logic8;
    	.scan_mode8(scan_mode8),          //  : in  std_logic8;
    	.scan_out8(),            	//  : out std_logic8;
        .int_source_h8(int_source_h8),
     	.rstn_non_srpg_smc8(rstn_non_srpg_smc8), 		//   : out std_logic8;
    	.gate_clk_smc8(gate_clk_smc8), 	//  : out std_logic8;
    	.isolate_smc8(isolate_smc8), 	//  : out std_logic8;
    	.save_edge_smc8(save_edge_smc8), 	//  : out std_logic8;
    	.restore_edge_smc8(restore_edge_smc8), 	//  : out std_logic8;
    	.pwr1_on_smc8(pwr1_on_smc8), 	//  : out std_logic8;
    	.pwr2_on_smc8(pwr2_on_smc8), 	//  : out std_logic8
     	.rstn_non_srpg_urt8(rstn_non_srpg_urt8), 		//   : out std_logic8;
    	.gate_clk_urt8(gate_clk_urt8), 	//  : out std_logic8;
    	.isolate_urt8(isolate_urt8), 	//  : out std_logic8;
    	.save_edge_urt8(save_edge_urt8), 	//  : out std_logic8;
    	.restore_edge_urt8(restore_edge_urt8), 	//  : out std_logic8;
    	.pwr1_on_urt8(pwr1_on_urt8), 	//  : out std_logic8;
    	.pwr2_on_urt8(pwr2_on_urt8),  	//  : out std_logic8
        // ETH08
        .rstn_non_srpg_macb08(rstn_non_srpg_macb08),
        .gate_clk_macb08(gate_clk_macb08),
        .isolate_macb08(isolate_macb08),
        .save_edge_macb08(save_edge_macb08),
        .restore_edge_macb08(restore_edge_macb08),
        .pwr1_on_macb08(pwr1_on_macb08),
        .pwr2_on_macb08(pwr2_on_macb08),
        // ETH18
        .rstn_non_srpg_macb18(rstn_non_srpg_macb18),
        .gate_clk_macb18(gate_clk_macb18),
        .isolate_macb18(isolate_macb18),
        .save_edge_macb18(save_edge_macb18),
        .restore_edge_macb18(restore_edge_macb18),
        .pwr1_on_macb18(pwr1_on_macb18),
        .pwr2_on_macb18(pwr2_on_macb18),
        // ETH28
        .rstn_non_srpg_macb28(rstn_non_srpg_macb28),
        .gate_clk_macb28(gate_clk_macb28),
        .isolate_macb28(isolate_macb28),
        .save_edge_macb28(save_edge_macb28),
        .restore_edge_macb28(restore_edge_macb28),
        .pwr1_on_macb28(pwr1_on_macb28),
        .pwr2_on_macb28(pwr2_on_macb28),
        // ETH38
        .rstn_non_srpg_macb38(rstn_non_srpg_macb38),
        .gate_clk_macb38(gate_clk_macb38),
        .isolate_macb38(isolate_macb38),
        .save_edge_macb38(save_edge_macb38),
        .restore_edge_macb38(restore_edge_macb38),
        .pwr1_on_macb38(pwr1_on_macb38),
        .pwr2_on_macb38(pwr2_on_macb38),
        .core06v8(core06v8),
        .core08v8(core08v8),
        .core10v8(core10v8),
        .core12v8(core12v8),
        .pcm_macb_wakeup_int8(pcm_macb_wakeup_int8),
        .isolate_mem8(isolate_mem8),
        .mte_smc_start8(mte_smc_start8),
        .mte_uart_start8(mte_uart_start8),
        .mte_smc_uart_start8(mte_smc_uart_start8),  
        .mte_pm_smc_to_default_start8(mte_pm_smc_to_default_start8), 
        .mte_pm_uart_to_default_start8(mte_pm_uart_to_default_start8),
        .mte_pm_smc_uart_to_default_start8(mte_pm_smc_uart_to_default_start8)
);

// Clock8 gating8 macro8 to shut8 off8 clocks8 to the SRPG8 flops8 in the SMC8
//CKLNQD18 i_SMC_SRPG_clk_gate8  (
//	.TE8(scan_mode8), 
//	.E8(~gate_clk_smc8), 
//	.CP8(pclk8), 
//	.Q8(pclk_SRPG_smc8)
//	);
// Replace8 gate8 with behavioural8 code8 //
wire 	smc_scan_gate8;
reg 	smc_latched_enable8;
assign smc_scan_gate8 = scan_mode8 ? 1'b1 : ~gate_clk_smc8;

always @ (pclk8 or smc_scan_gate8)
  	if (pclk8 == 1'b0) begin
  		smc_latched_enable8 <= smc_scan_gate8;
  	end  	
	
assign pclk_SRPG_smc8 = smc_latched_enable8 ? pclk8 : 1'b0;


// Clock8 gating8 macro8 to shut8 off8 clocks8 to the SRPG8 flops8 in the URT8
//CKLNQD18 i_URT_SRPG_clk_gate8  (
//	.TE8(scan_mode8), 
//	.E8(~gate_clk_urt8), 
//	.CP8(pclk8), 
//	.Q8(pclk_SRPG_urt8)
//	);
// Replace8 gate8 with behavioural8 code8 //
wire 	urt_scan_gate8;
reg 	urt_latched_enable8;
assign urt_scan_gate8 = scan_mode8 ? 1'b1 : ~gate_clk_urt8;

always @ (pclk8 or urt_scan_gate8)
  	if (pclk8 == 1'b0) begin
  		urt_latched_enable8 <= urt_scan_gate8;
  	end  	
	
assign pclk_SRPG_urt8 = urt_latched_enable8 ? pclk8 : 1'b0;

// ETH08
wire 	macb0_scan_gate8;
reg 	macb0_latched_enable8;
assign macb0_scan_gate8 = scan_mode8 ? 1'b1 : ~gate_clk_macb08;

always @ (pclk8 or macb0_scan_gate8)
  	if (pclk8 == 1'b0) begin
  		macb0_latched_enable8 <= macb0_scan_gate8;
  	end  	
	
assign clk_SRPG_macb0_en8 = macb0_latched_enable8 ? 1'b1 : 1'b0;

// ETH18
wire 	macb1_scan_gate8;
reg 	macb1_latched_enable8;
assign macb1_scan_gate8 = scan_mode8 ? 1'b1 : ~gate_clk_macb18;

always @ (pclk8 or macb1_scan_gate8)
  	if (pclk8 == 1'b0) begin
  		macb1_latched_enable8 <= macb1_scan_gate8;
  	end  	
	
assign clk_SRPG_macb1_en8 = macb1_latched_enable8 ? 1'b1 : 1'b0;

// ETH28
wire 	macb2_scan_gate8;
reg 	macb2_latched_enable8;
assign macb2_scan_gate8 = scan_mode8 ? 1'b1 : ~gate_clk_macb28;

always @ (pclk8 or macb2_scan_gate8)
  	if (pclk8 == 1'b0) begin
  		macb2_latched_enable8 <= macb2_scan_gate8;
  	end  	
	
assign clk_SRPG_macb2_en8 = macb2_latched_enable8 ? 1'b1 : 1'b0;

// ETH38
wire 	macb3_scan_gate8;
reg 	macb3_latched_enable8;
assign macb3_scan_gate8 = scan_mode8 ? 1'b1 : ~gate_clk_macb38;

always @ (pclk8 or macb3_scan_gate8)
  	if (pclk8 == 1'b0) begin
  		macb3_latched_enable8 <= macb3_scan_gate8;
  	end  	
	
assign clk_SRPG_macb3_en8 = macb3_latched_enable8 ? 1'b1 : 1'b0;



`else
//------------------------------------------------------------------------------
// if the APB8 subsystem8 is black8 boxed8 
//------------------------------------------------------------------------------
// wire s ports8
    // system signals8
    wire         hclk8;     // AHB8 Clock8
    wire         n_hreset8;  // AHB8 reset - Active8 low8
    wire         pclk8;     // APB8 Clock8. 
    wire         n_preset8;  // APB8 reset - Active8 low8

    // AHB8 interface
    wire         ahb2apb0_hsel8;     // AHB2APB8 select8
    wire  [31:0] haddr8;    // Address bus
    wire  [1:0]  htrans8;   // Transfer8 type
    wire  [2:0]  hsize8;    // AHB8 Access type - byte, half8-word8, word8
    wire  [31:0] hwdata8;   // Write data
    wire         hwrite8;   // Write signal8/
    wire         hready_in8;// Indicates8 that last master8 has finished8 bus access
    wire [2:0]   hburst8;     // Burst type
    wire [3:0]   hprot8;      // Protection8 control8
    wire [3:0]   hmaster8;    // Master8 select8
    wire         hmastlock8;  // Locked8 transfer8
  // Interrupts8 from the Enet8 MACs8
    wire         macb0_int8;
    wire         macb1_int8;
    wire         macb2_int8;
    wire         macb3_int8;
  // Interrupt8 from the DMA8
    wire         DMA_irq8;
  // Scan8 wire s
    wire         scan_en8;    // Scan8 enable pin8
    wire         scan_in_18;  // Scan8 wire  for first chain8
    wire         scan_in_28;  // Scan8 wire  for second chain8
    wire         scan_mode8;  // test mode pin8
 
  //wire  for smc8 AHB8 interface
    wire         smc_hclk8;
    wire         smc_n_hclk8;
    wire  [31:0] smc_haddr8;
    wire  [1:0]  smc_htrans8;
    wire         smc_hsel8;
    wire         smc_hwrite8;
    wire  [2:0]  smc_hsize8;
    wire  [31:0] smc_hwdata8;
    wire         smc_hready_in8;
    wire  [2:0]  smc_hburst8;     // Burst type
    wire  [3:0]  smc_hprot8;      // Protection8 control8
    wire  [3:0]  smc_hmaster8;    // Master8 select8
    wire         smc_hmastlock8;  // Locked8 transfer8


    wire  [31:0] data_smc8;     // EMI8(External8 memory) read data
    
  //wire s for uart8
    wire         ua_rxd8;       // UART8 receiver8 serial8 wire  pin8
    wire         ua_rxd18;      // UART8 receiver8 serial8 wire  pin8
    wire         ua_ncts8;      // Clear-To8-Send8 flow8 control8
    wire         ua_ncts18;      // Clear-To8-Send8 flow8 control8
   //wire s for spi8
    wire         n_ss_in8;      // select8 wire  to slave8
    wire         mi8;           // data wire  to master8
    wire         si8;           // data wire  to slave8
    wire         sclk_in8;      // clock8 wire  to slave8
  //wire s for GPIO8
   wire  [GPIO_WIDTH8-1:0]  gpio_pin_in8;             // wire  data from pin8

  //reg    ports8
  // Scan8 reg   s
   reg           scan_out_18;   // Scan8 out for chain8 1
   reg           scan_out_28;   // Scan8 out for chain8 2
  //AHB8 interface 
   reg    [31:0] hrdata8;       // Read data provided from target slave8
   reg           hready8;       // Ready8 for new bus cycle from target slave8
   reg    [1:0]  hresp8;       // Response8 from the bridge8

   // SMC8 reg    for AHB8 interface
   reg    [31:0]    smc_hrdata8;
   reg              smc_hready8;
   reg    [1:0]     smc_hresp8;

  //reg   s from smc8
   reg    [15:0]    smc_addr8;      // External8 Memory (EMI8) address
   reg    [3:0]     smc_n_be8;      // EMI8 byte enables8 (Active8 LOW8)
   reg    [7:0]     smc_n_cs8;      // EMI8 Chip8 Selects8 (Active8 LOW8)
   reg    [3:0]     smc_n_we8;      // EMI8 write strobes8 (Active8 LOW8)
   reg              smc_n_wr8;      // EMI8 write enable (Active8 LOW8)
   reg              smc_n_rd8;      // EMI8 read stobe8 (Active8 LOW8)
   reg              smc_n_ext_oe8;  // EMI8 write data reg    enable
   reg    [31:0]    smc_data8;      // EMI8 write data
  //reg   s from uart8
   reg           ua_txd8;       	// UART8 transmitter8 serial8 reg   
   reg           ua_txd18;       // UART8 transmitter8 serial8 reg   
   reg           ua_nrts8;      	// Request8-To8-Send8 flow8 control8
   reg           ua_nrts18;      // Request8-To8-Send8 flow8 control8
   // reg   s from ttc8
  // reg   s from SPI8
   reg       so;                    // data reg    from slave8
   reg       mo8;                    // data reg    from master8
   reg       sclk_out8;              // clock8 reg    from master8
   reg    [P_SIZE8-1:0] n_ss_out8;    // peripheral8 select8 lines8 from master8
   reg       n_so_en8;               // out enable for slave8 data
   reg       n_mo_en8;               // out enable for master8 data
   reg       n_sclk_en8;             // out enable for master8 clock8
   reg       n_ss_en8;               // out enable for master8 peripheral8 lines8
  //reg   s from gpio8
   reg    [GPIO_WIDTH8-1:0]     n_gpio_pin_oe8;           // reg    enable signal8 to pin8
   reg    [GPIO_WIDTH8-1:0]     gpio_pin_out8;            // reg    signal8 to pin8


`endif
//------------------------------------------------------------------------------
// black8 boxed8 defines8 
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// APB8 and AHB8 interface formal8 verification8 monitors8
//------------------------------------------------------------------------------
`ifdef ABV_ON8
apb_assert8 i_apb_assert8 (

        // APB8 signals8
  	.n_preset8(n_preset8),
   	.pclk8(pclk8),
	.penable8(penable8),
	.paddr8(paddr8),
	.pwrite8(pwrite8),
	.pwdata8(pwdata8),

	.psel008(psel_spi8),
	.psel018(psel_uart08),
	.psel028(psel_gpio8),
	.psel038(psel_ttc8),
	.psel048(1'b0),
	.psel058(psel_smc8),
	.psel068(1'b0),
	.psel078(1'b0),
	.psel088(1'b0),
	.psel098(1'b0),
	.psel108(1'b0),
	.psel118(1'b0),
	.psel128(1'b0),
	.psel138(psel_pmc8),
	.psel148(psel_apic8),
	.psel158(psel_uart18),

        .prdata008(prdata_spi8),
        .prdata018(prdata_uart08), // Read Data from peripheral8 UART8 
        .prdata028(prdata_gpio8), // Read Data from peripheral8 GPIO8
        .prdata038(prdata_ttc8), // Read Data from peripheral8 TTC8
        .prdata048(32'b0), // 
        .prdata058(prdata_smc8), // Read Data from peripheral8 SMC8
        .prdata138(prdata_pmc8), // Read Data from peripheral8 Power8 Control8 Block
   	.prdata148(32'b0), // 
        .prdata158(prdata_uart18),


        // AHB8 signals8
        .hclk8(hclk8),         // ahb8 system clock8
        .n_hreset8(n_hreset8), // ahb8 system reset

        // ahb2apb8 signals8
        .hresp8(hresp8),
        .hready8(hready8),
        .hrdata8(hrdata8),
        .hwdata8(hwdata8),
        .hprot8(hprot8),
        .hburst8(hburst8),
        .hsize8(hsize8),
        .hwrite8(hwrite8),
        .htrans8(htrans8),
        .haddr8(haddr8),
        .ahb2apb_hsel8(ahb2apb0_hsel8));



//------------------------------------------------------------------------------
// AHB8 interface formal8 verification8 monitor8
//------------------------------------------------------------------------------
defparam i_ahbSlaveMonitor8.DBUS_WIDTH8 = 32;
defparam i_ahbMasterMonitor8.DBUS_WIDTH8 = 32;


// AHB2APB8 Bridge8

    ahb_liteslave_monitor8 i_ahbSlaveMonitor8 (
        .hclk_i8(hclk8),
        .hresetn_i8(n_hreset8),
        .hresp8(hresp8),
        .hready8(hready8),
        .hready_global_i8(hready8),
        .hrdata8(hrdata8),
        .hwdata_i8(hwdata8),
        .hburst_i8(hburst8),
        .hsize_i8(hsize8),
        .hwrite_i8(hwrite8),
        .htrans_i8(htrans8),
        .haddr_i8(haddr8),
        .hsel_i8(ahb2apb0_hsel8)
    );


  ahb_litemaster_monitor8 i_ahbMasterMonitor8 (
          .hclk_i8(hclk8),
          .hresetn_i8(n_hreset8),
          .hresp_i8(hresp8),
          .hready_i8(hready8),
          .hrdata_i8(hrdata8),
          .hlock8(1'b0),
          .hwdata8(hwdata8),
          .hprot8(hprot8),
          .hburst8(hburst8),
          .hsize8(hsize8),
          .hwrite8(hwrite8),
          .htrans8(htrans8),
          .haddr8(haddr8)
          );







`endif




`ifdef IFV_LP_ABV_ON8
// power8 control8
wire isolate8;

// testbench mirror signals8
wire L1_ctrl_access8;
wire L1_status_access8;

wire [31:0] L1_status_reg8;
wire [31:0] L1_ctrl_reg8;

//wire rstn_non_srpg_urt8;
//wire isolate_urt8;
//wire retain_urt8;
//wire gate_clk_urt8;
//wire pwr1_on_urt8;


// smc8 signals8
wire [31:0] smc_prdata8;
wire lp_clk_smc8;
                    

// uart8 isolation8 register
  wire [15:0] ua_prdata8;
  wire ua_int8;
  assign ua_prdata8          =  i_uart1_veneer8.prdata8;
  assign ua_int8             =  i_uart1_veneer8.ua_int8;


assign lp_clk_smc8          = i_smc_veneer8.pclk8;
assign smc_prdata8          = i_smc_veneer8.prdata8;
lp_chk_smc8 u_lp_chk_smc8 (
    .clk8 (hclk8),
    .rst8 (n_hreset8),
    .iso_smc8 (isolate_smc8),
    .gate_clk8 (gate_clk_smc8),
    .lp_clk8 (pclk_SRPG_smc8),

    // srpg8 outputs8
    .smc_hrdata8 (smc_hrdata8),
    .smc_hready8 (smc_hready8),
    .smc_hresp8  (smc_hresp8),
    .smc_valid8 (smc_valid8),
    .smc_addr_int8 (smc_addr_int8),
    .smc_data8 (smc_data8),
    .smc_n_be8 (smc_n_be8),
    .smc_n_cs8  (smc_n_cs8),
    .smc_n_wr8 (smc_n_wr8),
    .smc_n_we8 (smc_n_we8),
    .smc_n_rd8 (smc_n_rd8),
    .smc_n_ext_oe8 (smc_n_ext_oe8)
   );

// lp8 retention8/isolation8 assertions8
lp_chk_uart8 u_lp_chk_urt8 (

  .clk8         (hclk8),
  .rst8         (n_hreset8),
  .iso_urt8     (isolate_urt8),
  .gate_clk8    (gate_clk_urt8),
  .lp_clk8      (pclk_SRPG_urt8),
  //ports8
  .prdata8 (ua_prdata8),
  .ua_int8 (ua_int8),
  .ua_txd8 (ua_txd18),
  .ua_nrts8 (ua_nrts18)
 );

`endif  //IFV_LP_ABV_ON8




endmodule
