//File4 name   : apb_subsystem_04.v
//Title4       : 
//Created4     : 1999
//Description4 : 
//Notes4       : 
//----------------------------------------------------------------------
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------

module apb_subsystem_04(
    // AHB4 interface
    hclk4,
    n_hreset4,
    hsel4,
    haddr4,
    htrans4,
    hsize4,
    hwrite4,
    hwdata4,
    hready_in4,
    hburst4,
    hprot4,
    hmaster4,
    hmastlock4,
    hrdata4,
    hready4,
    hresp4,
    
    // APB4 system interface
    pclk4,
    n_preset4,
    
    // SPI4 ports4
    n_ss_in4,
    mi4,
    si4,
    sclk_in4,
    so,
    mo4,
    sclk_out4,
    n_ss_out4,
    n_so_en4,
    n_mo_en4,
    n_sclk_en4,
    n_ss_en4,
    
    //UART04 ports4
    ua_rxd4,
    ua_ncts4,
    ua_txd4,
    ua_nrts4,
    
    //UART14 ports4
    ua_rxd14,
    ua_ncts14,
    ua_txd14,
    ua_nrts14,
    
    //GPIO4 ports4
    gpio_pin_in4,
    n_gpio_pin_oe4,
    gpio_pin_out4,
    

    //SMC4 ports4
    smc_hclk4,
    smc_n_hclk4,
    smc_haddr4,
    smc_htrans4,
    smc_hsel4,
    smc_hwrite4,
    smc_hsize4,
    smc_hwdata4,
    smc_hready_in4,
    smc_hburst4,
    smc_hprot4,
    smc_hmaster4,
    smc_hmastlock4,
    smc_hrdata4, 
    smc_hready4,
    smc_hresp4,
    smc_n_ext_oe4,
    smc_data4,
    smc_addr4,
    smc_n_be4,
    smc_n_cs4, 
    smc_n_we4,
    smc_n_wr4,
    smc_n_rd4,
    data_smc4,
    
    //PMC4 ports4
    clk_SRPG_macb0_en4,
    clk_SRPG_macb1_en4,
    clk_SRPG_macb2_en4,
    clk_SRPG_macb3_en4,
    core06v4,
    core08v4,
    core10v4,
    core12v4,
    macb3_wakeup4,
    macb2_wakeup4,
    macb1_wakeup4,
    macb0_wakeup4,
    mte_smc_start4,
    mte_uart_start4,
    mte_smc_uart_start4,  
    mte_pm_smc_to_default_start4, 
    mte_pm_uart_to_default_start4,
    mte_pm_smc_uart_to_default_start4,
    
    
    // Peripheral4 inerrupts4
    pcm_irq4,
    ttc_irq4,
    gpio_irq4,
    uart0_irq4,
    uart1_irq4,
    spi_irq4,
    DMA_irq4,      
    macb0_int4,
    macb1_int4,
    macb2_int4,
    macb3_int4,
   
    // Scan4 ports4
    scan_en4,      // Scan4 enable pin4
    scan_in_14,    // Scan4 input for first chain4
    scan_in_24,    // Scan4 input for second chain4
    scan_mode4,
    scan_out_14,   // Scan4 out for chain4 1
    scan_out_24    // Scan4 out for chain4 2
);

parameter GPIO_WIDTH4 = 16;        // GPIO4 width
parameter P_SIZE4 =   8;              // number4 of peripheral4 select4 lines4
parameter NO_OF_IRQS4  = 17;      //No of irqs4 read by apic4 

// AHB4 interface
input         hclk4;     // AHB4 Clock4
input         n_hreset4;  // AHB4 reset - Active4 low4
input         hsel4;     // AHB2APB4 select4
input [31:0]  haddr4;    // Address bus
input [1:0]   htrans4;   // Transfer4 type
input [2:0]   hsize4;    // AHB4 Access type - byte, half4-word4, word4
input [31:0]  hwdata4;   // Write data
input         hwrite4;   // Write signal4/
input         hready_in4;// Indicates4 that last master4 has finished4 bus access
input [2:0]   hburst4;     // Burst type
input [3:0]   hprot4;      // Protection4 control4
input [3:0]   hmaster4;    // Master4 select4
input         hmastlock4;  // Locked4 transfer4
output [31:0] hrdata4;       // Read data provided from target slave4
output        hready4;       // Ready4 for new bus cycle from target slave4
output [1:0]  hresp4;       // Response4 from the bridge4
    
// APB4 system interface
input         pclk4;     // APB4 Clock4. 
input         n_preset4;  // APB4 reset - Active4 low4
   
// SPI4 ports4
input     n_ss_in4;      // select4 input to slave4
input     mi4;           // data input to master4
input     si4;           // data input to slave4
input     sclk_in4;      // clock4 input to slave4
output    so;                    // data output from slave4
output    mo4;                    // data output from master4
output    sclk_out4;              // clock4 output from master4
output [P_SIZE4-1:0] n_ss_out4;    // peripheral4 select4 lines4 from master4
output    n_so_en4;               // out enable for slave4 data
output    n_mo_en4;               // out enable for master4 data
output    n_sclk_en4;             // out enable for master4 clock4
output    n_ss_en4;               // out enable for master4 peripheral4 lines4

//UART04 ports4
input        ua_rxd4;       // UART4 receiver4 serial4 input pin4
input        ua_ncts4;      // Clear-To4-Send4 flow4 control4
output       ua_txd4;       	// UART4 transmitter4 serial4 output
output       ua_nrts4;      	// Request4-To4-Send4 flow4 control4

// UART14 ports4   
input        ua_rxd14;      // UART4 receiver4 serial4 input pin4
input        ua_ncts14;      // Clear-To4-Send4 flow4 control4
output       ua_txd14;       // UART4 transmitter4 serial4 output
output       ua_nrts14;      // Request4-To4-Send4 flow4 control4

//GPIO4 ports4
input [GPIO_WIDTH4-1:0]      gpio_pin_in4;             // input data from pin4
output [GPIO_WIDTH4-1:0]     n_gpio_pin_oe4;           // output enable signal4 to pin4
output [GPIO_WIDTH4-1:0]     gpio_pin_out4;            // output signal4 to pin4
  
//SMC4 ports4
input        smc_hclk4;
input        smc_n_hclk4;
input [31:0] smc_haddr4;
input [1:0]  smc_htrans4;
input        smc_hsel4;
input        smc_hwrite4;
input [2:0]  smc_hsize4;
input [31:0] smc_hwdata4;
input        smc_hready_in4;
input [2:0]  smc_hburst4;     // Burst type
input [3:0]  smc_hprot4;      // Protection4 control4
input [3:0]  smc_hmaster4;    // Master4 select4
input        smc_hmastlock4;  // Locked4 transfer4
input [31:0] data_smc4;     // EMI4(External4 memory) read data
output [31:0]    smc_hrdata4;
output           smc_hready4;
output [1:0]     smc_hresp4;
output [15:0]    smc_addr4;      // External4 Memory (EMI4) address
output [3:0]     smc_n_be4;      // EMI4 byte enables4 (Active4 LOW4)
output           smc_n_cs4;      // EMI4 Chip4 Selects4 (Active4 LOW4)
output [3:0]     smc_n_we4;      // EMI4 write strobes4 (Active4 LOW4)
output           smc_n_wr4;      // EMI4 write enable (Active4 LOW4)
output           smc_n_rd4;      // EMI4 read stobe4 (Active4 LOW4)
output           smc_n_ext_oe4;  // EMI4 write data output enable
output [31:0]    smc_data4;      // EMI4 write data
       
//PMC4 ports4
output clk_SRPG_macb0_en4;
output clk_SRPG_macb1_en4;
output clk_SRPG_macb2_en4;
output clk_SRPG_macb3_en4;
output core06v4;
output core08v4;
output core10v4;
output core12v4;
output mte_smc_start4;
output mte_uart_start4;
output mte_smc_uart_start4;  
output mte_pm_smc_to_default_start4; 
output mte_pm_uart_to_default_start4;
output mte_pm_smc_uart_to_default_start4;
input macb3_wakeup4;
input macb2_wakeup4;
input macb1_wakeup4;
input macb0_wakeup4;
    

// Peripheral4 interrupts4
output pcm_irq4;
output [2:0] ttc_irq4;
output gpio_irq4;
output uart0_irq4;
output uart1_irq4;
output spi_irq4;
input        macb0_int4;
input        macb1_int4;
input        macb2_int4;
input        macb3_int4;
input        DMA_irq4;
  
//Scan4 ports4
input        scan_en4;    // Scan4 enable pin4
input        scan_in_14;  // Scan4 input for first chain4
input        scan_in_24;  // Scan4 input for second chain4
input        scan_mode4;  // test mode pin4
 output        scan_out_14;   // Scan4 out for chain4 1
 output        scan_out_24;   // Scan4 out for chain4 2  

//------------------------------------------------------------------------------
// if the ROM4 subsystem4 is NOT4 black4 boxed4 
//------------------------------------------------------------------------------
`ifndef FV_KIT_BLACK_BOX_APB_SUBSYSTEM4
   
   wire        hsel4; 
   wire        pclk4;
   wire        n_preset4;
   wire [31:0] prdata_spi4;
   wire [31:0] prdata_uart04;
   wire [31:0] prdata_gpio4;
   wire [31:0] prdata_ttc4;
   wire [31:0] prdata_smc4;
   wire [31:0] prdata_pmc4;
   wire [31:0] prdata_uart14;
   wire        pready_spi4;
   wire        pready_uart04;
   wire        pready_uart14;
   wire        tie_hi_bit4;
   wire  [31:0] hrdata4; 
   wire         hready4;
   wire         hready_in4;
   wire  [1:0]  hresp4;   
   wire  [31:0] pwdata4;  
   wire         pwrite4;
   wire  [31:0] paddr4;  
   wire   psel_spi4;
   wire   psel_uart04;
   wire   psel_gpio4;
   wire   psel_ttc4;
   wire   psel_smc4;
   wire   psel074;
   wire   psel084;
   wire   psel094;
   wire   psel104;
   wire   psel114;
   wire   psel124;
   wire   psel_pmc4;
   wire   psel_uart14;
   wire   penable4;
   wire   [NO_OF_IRQS4:0] int_source4;     // System4 Interrupt4 Sources4
   wire [1:0]             smc_hresp4;     // AHB4 Response4 signal4
   wire                   smc_valid4;     // Ack4 valid address

  //External4 memory interface (EMI4)
  wire [31:0]            smc_addr_int4;  // External4 Memory (EMI4) address
  wire [3:0]             smc_n_be4;      // EMI4 byte enables4 (Active4 LOW4)
  wire                   smc_n_cs4;      // EMI4 Chip4 Selects4 (Active4 LOW4)
  wire [3:0]             smc_n_we4;      // EMI4 write strobes4 (Active4 LOW4)
  wire                   smc_n_wr4;      // EMI4 write enable (Active4 LOW4)
  wire                   smc_n_rd4;      // EMI4 read stobe4 (Active4 LOW4)
 
  //AHB4 Memory Interface4 Control4
  wire                   smc_hsel_int4;
  wire                   smc_busy4;      // smc4 busy
   

//scan4 signals4

   wire                scan_in_14;        //scan4 input
   wire                scan_in_24;        //scan4 input
   wire                scan_en4;         //scan4 enable
   wire                scan_out_14;       //scan4 output
   wire                scan_out_24;       //scan4 output
   wire                byte_sel4;     // byte select4 from bridge4 1=byte, 0=2byte
   wire                UART_int4;     // UART4 module interrupt4 
   wire                ua_uclken4;    // Soft4 control4 of clock4
   wire                UART_int14;     // UART4 module interrupt4 
   wire                ua_uclken14;    // Soft4 control4 of clock4
   wire  [3:1]         TTC_int4;            //Interrupt4 from PCI4 
  // inputs4 to SPI4 
   wire    ext_clk4;                // external4 clock4
   wire    SPI_int4;             // interrupt4 request
  // outputs4 from SPI4
   wire    slave_out_clk4;         // modified slave4 clock4 output
 // gpio4 generic4 inputs4 
   wire  [GPIO_WIDTH4-1:0]   n_gpio_bypass_oe4;        // bypass4 mode enable 
   wire  [GPIO_WIDTH4-1:0]   gpio_bypass_out4;         // bypass4 mode output value 
   wire  [GPIO_WIDTH4-1:0]   tri_state_enable4;   // disables4 op enable -> z 
 // outputs4 
   //amba4 outputs4 
   // gpio4 generic4 outputs4 
   wire       GPIO_int4;                // gpio_interupt4 for input pin4 change 
   wire [GPIO_WIDTH4-1:0]     gpio_bypass_in4;          // bypass4 mode input data value  
                
   wire           cpu_debug4;        // Inhibits4 watchdog4 counter 
   wire            ex_wdz_n4;         // External4 Watchdog4 zero indication4
   wire           rstn_non_srpg_smc4; 
   wire           rstn_non_srpg_urt4;
   wire           isolate_smc4;
   wire           save_edge_smc4;
   wire           restore_edge_smc4;
   wire           save_edge_urt4;
   wire           restore_edge_urt4;
   wire           pwr1_on_smc4;
   wire           pwr2_on_smc4;
   wire           pwr1_on_urt4;
   wire           pwr2_on_urt4;
   // ETH04
   wire            rstn_non_srpg_macb04;
   wire            gate_clk_macb04;
   wire            isolate_macb04;
   wire            save_edge_macb04;
   wire            restore_edge_macb04;
   wire            pwr1_on_macb04;
   wire            pwr2_on_macb04;
   // ETH14
   wire            rstn_non_srpg_macb14;
   wire            gate_clk_macb14;
   wire            isolate_macb14;
   wire            save_edge_macb14;
   wire            restore_edge_macb14;
   wire            pwr1_on_macb14;
   wire            pwr2_on_macb14;
   // ETH24
   wire            rstn_non_srpg_macb24;
   wire            gate_clk_macb24;
   wire            isolate_macb24;
   wire            save_edge_macb24;
   wire            restore_edge_macb24;
   wire            pwr1_on_macb24;
   wire            pwr2_on_macb24;
   // ETH34
   wire            rstn_non_srpg_macb34;
   wire            gate_clk_macb34;
   wire            isolate_macb34;
   wire            save_edge_macb34;
   wire            restore_edge_macb34;
   wire            pwr1_on_macb34;
   wire            pwr2_on_macb34;


   wire           pclk_SRPG_smc4;
   wire           pclk_SRPG_urt4;
   wire           gate_clk_smc4;
   wire           gate_clk_urt4;
   wire  [31:0]   tie_lo_32bit4; 
   wire  [1:0]	  tie_lo_2bit4;
   wire  	  tie_lo_1bit4;
   wire           pcm_macb_wakeup_int4;
   wire           int_source_h4;
   wire           isolate_mem4;

assign pcm_irq4 = pcm_macb_wakeup_int4;
assign ttc_irq4[2] = TTC_int4[3];
assign ttc_irq4[1] = TTC_int4[2];
assign ttc_irq4[0] = TTC_int4[1];
assign gpio_irq4 = GPIO_int4;
assign uart0_irq4 = UART_int4;
assign uart1_irq4 = UART_int14;
assign spi_irq4 = SPI_int4;

assign n_mo_en4   = 1'b0;
assign n_so_en4   = 1'b1;
assign n_sclk_en4 = 1'b0;
assign n_ss_en4   = 1'b0;

assign smc_hsel_int4 = smc_hsel4;
  assign ext_clk4  = 1'b0;
  assign int_source4 = {macb0_int4,macb1_int4, macb2_int4, macb3_int4,1'b0, pcm_macb_wakeup_int4, 1'b0, 1'b0, 1'b0, 1'b0, TTC_int4, GPIO_int4, UART_int4, UART_int14, SPI_int4, DMA_irq4};

  // interrupt4 even4 detect4 .
  // for sleep4 wake4 up -> any interrupt4 even4 and system not in hibernation4 (isolate_mem4 = 0)
  // for hibernate4 wake4 up -> gpio4 interrupt4 even4 and system in the hibernation4 (isolate_mem4 = 1)
  assign int_source_h4 =  ((|int_source4) && (!isolate_mem4)) || (isolate_mem4 && GPIO_int4) ;

  assign byte_sel4 = 1'b1;
  assign tie_hi_bit4 = 1'b1;

  assign smc_addr4 = smc_addr_int4[15:0];



  assign  n_gpio_bypass_oe4 = {GPIO_WIDTH4{1'b0}};        // bypass4 mode enable 
  assign  gpio_bypass_out4  = {GPIO_WIDTH4{1'b0}};
  assign  tri_state_enable4 = {GPIO_WIDTH4{1'b0}};
  assign  cpu_debug4 = 1'b0;
  assign  tie_lo_32bit4 = 32'b0;
  assign  tie_lo_2bit4  = 2'b0;
  assign  tie_lo_1bit4  = 1'b0;


ahb2apb4 #(
  32'h00800000, // Slave4 0 Address Range4
  32'h0080FFFF,

  32'h00810000, // Slave4 1 Address Range4
  32'h0081FFFF,

  32'h00820000, // Slave4 2 Address Range4 
  32'h0082FFFF,

  32'h00830000, // Slave4 3 Address Range4
  32'h0083FFFF,

  32'h00840000, // Slave4 4 Address Range4
  32'h0084FFFF,

  32'h00850000, // Slave4 5 Address Range4
  32'h0085FFFF,

  32'h00860000, // Slave4 6 Address Range4
  32'h0086FFFF,

  32'h00870000, // Slave4 7 Address Range4
  32'h0087FFFF,

  32'h00880000, // Slave4 8 Address Range4
  32'h0088FFFF
) i_ahb2apb4 (
     // AHB4 interface
    .hclk4(hclk4),         
    .hreset_n4(n_hreset4), 
    .hsel4(hsel4), 
    .haddr4(haddr4),        
    .htrans4(htrans4),       
    .hwrite4(hwrite4),       
    .hwdata4(hwdata4),       
    .hrdata4(hrdata4),   
    .hready4(hready4),   
    .hresp4(hresp4),     
    
     // APB4 interface
    .pclk4(pclk4),         
    .preset_n4(n_preset4),  
    .prdata04(prdata_spi4),
    .prdata14(prdata_uart04), 
    .prdata24(prdata_gpio4),  
    .prdata34(prdata_ttc4),   
    .prdata44(32'h0),   
    .prdata54(prdata_smc4),   
    .prdata64(prdata_pmc4),    
    .prdata74(32'h0),   
    .prdata84(prdata_uart14),  
    .pready04(pready_spi4),     
    .pready14(pready_uart04),   
    .pready24(tie_hi_bit4),     
    .pready34(tie_hi_bit4),     
    .pready44(tie_hi_bit4),     
    .pready54(tie_hi_bit4),     
    .pready64(tie_hi_bit4),     
    .pready74(tie_hi_bit4),     
    .pready84(pready_uart14),  
    .pwdata4(pwdata4),       
    .pwrite4(pwrite4),       
    .paddr4(paddr4),        
    .psel04(psel_spi4),     
    .psel14(psel_uart04),   
    .psel24(psel_gpio4),    
    .psel34(psel_ttc4),     
    .psel44(),     
    .psel54(psel_smc4),     
    .psel64(psel_pmc4),    
    .psel74(psel_apic4),   
    .psel84(psel_uart14),  
    .penable4(penable4)     
);

spi_top4 i_spi4
(
  // Wishbone4 signals4
  .wb_clk_i4(pclk4), 
  .wb_rst_i4(~n_preset4), 
  .wb_adr_i4(paddr4[4:0]), 
  .wb_dat_i4(pwdata4), 
  .wb_dat_o4(prdata_spi4), 
  .wb_sel_i4(4'b1111),    // SPI4 register accesses are always 32-bit
  .wb_we_i4(pwrite4), 
  .wb_stb_i4(psel_spi4), 
  .wb_cyc_i4(psel_spi4), 
  .wb_ack_o4(pready_spi4), 
  .wb_err_o4(), 
  .wb_int_o4(SPI_int4),

  // SPI4 signals4
  .ss_pad_o4(n_ss_out4), 
  .sclk_pad_o4(sclk_out4), 
  .mosi_pad_o4(mo4), 
  .miso_pad_i4(mi4)
);

// Opencores4 UART4 instances4
wire ua_nrts_int4;
wire ua_nrts1_int4;

assign ua_nrts4 = ua_nrts_int4;
assign ua_nrts14 = ua_nrts1_int4;

reg [3:0] uart0_sel_i4;
reg [3:0] uart1_sel_i4;
// UART4 registers are all 8-bit wide4, and their4 addresses4
// are on byte boundaries4. So4 to access them4 on the
// Wishbone4 bus, the CPU4 must do byte accesses to these4
// byte addresses4. Word4 address accesses are not possible4
// because the word4 addresses4 will be unaligned4, and cause
// a fault4.
// So4, Uart4 accesses from the CPU4 will always be 8-bit size
// We4 only have to decide4 which byte of the 4-byte word4 the
// CPU4 is interested4 in.
`ifdef SYSTEM_BIG_ENDIAN4
always @(paddr4) begin
  case (paddr4[1:0])
    2'b00 : uart0_sel_i4 = 4'b1000;
    2'b01 : uart0_sel_i4 = 4'b0100;
    2'b10 : uart0_sel_i4 = 4'b0010;
    2'b11 : uart0_sel_i4 = 4'b0001;
  endcase
end
always @(paddr4) begin
  case (paddr4[1:0])
    2'b00 : uart1_sel_i4 = 4'b1000;
    2'b01 : uart1_sel_i4 = 4'b0100;
    2'b10 : uart1_sel_i4 = 4'b0010;
    2'b11 : uart1_sel_i4 = 4'b0001;
  endcase
end
`else
always @(paddr4) begin
  case (paddr4[1:0])
    2'b00 : uart0_sel_i4 = 4'b0001;
    2'b01 : uart0_sel_i4 = 4'b0010;
    2'b10 : uart0_sel_i4 = 4'b0100;
    2'b11 : uart0_sel_i4 = 4'b1000;
  endcase
end
always @(paddr4) begin
  case (paddr4[1:0])
    2'b00 : uart1_sel_i4 = 4'b0001;
    2'b01 : uart1_sel_i4 = 4'b0010;
    2'b10 : uart1_sel_i4 = 4'b0100;
    2'b11 : uart1_sel_i4 = 4'b1000;
  endcase
end
`endif

uart_top4 i_oc_uart04 (
  .wb_clk_i4(pclk4),
  .wb_rst_i4(~n_preset4),
  .wb_adr_i4(paddr4[4:0]),
  .wb_dat_i4(pwdata4),
  .wb_dat_o4(prdata_uart04),
  .wb_we_i4(pwrite4),
  .wb_stb_i4(psel_uart04),
  .wb_cyc_i4(psel_uart04),
  .wb_ack_o4(pready_uart04),
  .wb_sel_i4(uart0_sel_i4),
  .int_o4(UART_int4),
  .stx_pad_o4(ua_txd4),
  .srx_pad_i4(ua_rxd4),
  .rts_pad_o4(ua_nrts_int4),
  .cts_pad_i4(ua_ncts4),
  .dtr_pad_o4(),
  .dsr_pad_i4(1'b0),
  .ri_pad_i4(1'b0),
  .dcd_pad_i4(1'b0)
);

uart_top4 i_oc_uart14 (
  .wb_clk_i4(pclk4),
  .wb_rst_i4(~n_preset4),
  .wb_adr_i4(paddr4[4:0]),
  .wb_dat_i4(pwdata4),
  .wb_dat_o4(prdata_uart14),
  .wb_we_i4(pwrite4),
  .wb_stb_i4(psel_uart14),
  .wb_cyc_i4(psel_uart14),
  .wb_ack_o4(pready_uart14),
  .wb_sel_i4(uart1_sel_i4),
  .int_o4(UART_int14),
  .stx_pad_o4(ua_txd14),
  .srx_pad_i4(ua_rxd14),
  .rts_pad_o4(ua_nrts1_int4),
  .cts_pad_i4(ua_ncts14),
  .dtr_pad_o4(),
  .dsr_pad_i4(1'b0),
  .ri_pad_i4(1'b0),
  .dcd_pad_i4(1'b0)
);

gpio_veneer4 i_gpio_veneer4 (
        //inputs4

        . n_p_reset4(n_preset4),
        . pclk4(pclk4),
        . psel4(psel_gpio4),
        . penable4(penable4),
        . pwrite4(pwrite4),
        . paddr4(paddr4[5:0]),
        . pwdata4(pwdata4),
        . gpio_pin_in4(gpio_pin_in4),
        . scan_en4(scan_en4),
        . tri_state_enable4(tri_state_enable4),
        . scan_in4(), //added by smarkov4 for dft4

        //outputs4
        . scan_out4(), //added by smarkov4 for dft4
        . prdata4(prdata_gpio4),
        . gpio_int4(GPIO_int4),
        . n_gpio_pin_oe4(n_gpio_pin_oe4),
        . gpio_pin_out4(gpio_pin_out4)
);


ttc_veneer4 i_ttc_veneer4 (

         //inputs4
        . n_p_reset4(n_preset4),
        . pclk4(pclk4),
        . psel4(psel_ttc4),
        . penable4(penable4),
        . pwrite4(pwrite4),
        . pwdata4(pwdata4),
        . paddr4(paddr4[7:0]),
        . scan_in4(),
        . scan_en4(scan_en4),

        //outputs4
        . prdata4(prdata_ttc4),
        . interrupt4(TTC_int4[3:1]),
        . scan_out4()
);


smc_veneer4 i_smc_veneer4 (
        //inputs4
	//apb4 inputs4
        . n_preset4(n_preset4),
        . pclk4(pclk_SRPG_smc4),
        . psel4(psel_smc4),
        . penable4(penable4),
        . pwrite4(pwrite4),
        . paddr4(paddr4[4:0]),
        . pwdata4(pwdata4),
        //ahb4 inputs4
	. hclk4(smc_hclk4),
        . n_sys_reset4(rstn_non_srpg_smc4),
        . haddr4(smc_haddr4),
        . htrans4(smc_htrans4),
        . hsel4(smc_hsel_int4),
        . hwrite4(smc_hwrite4),
	. hsize4(smc_hsize4),
        . hwdata4(smc_hwdata4),
        . hready4(smc_hready_in4),
        . data_smc4(data_smc4),

         //test signal4 inputs4

        . scan_in_14(),
        . scan_in_24(),
        . scan_in_34(),
        . scan_en4(scan_en4),

        //apb4 outputs4
        . prdata4(prdata_smc4),

       //design output

        . smc_hrdata4(smc_hrdata4),
        . smc_hready4(smc_hready4),
        . smc_hresp4(smc_hresp4),
        . smc_valid4(smc_valid4),
        . smc_addr4(smc_addr_int4),
        . smc_data4(smc_data4),
        . smc_n_be4(smc_n_be4),
        . smc_n_cs4(smc_n_cs4),
        . smc_n_wr4(smc_n_wr4),
        . smc_n_we4(smc_n_we4),
        . smc_n_rd4(smc_n_rd4),
        . smc_n_ext_oe4(smc_n_ext_oe4),
        . smc_busy4(smc_busy4),

         //test signal4 output
        . scan_out_14(),
        . scan_out_24(),
        . scan_out_34()
);

power_ctrl_veneer4 i_power_ctrl_veneer4 (
    // -- Clocks4 & Reset4
    	.pclk4(pclk4), 			//  : in  std_logic4;
    	.nprst4(n_preset4), 		//  : in  std_logic4;
    // -- APB4 programming4 interface
    	.paddr4(paddr4), 			//  : in  std_logic_vector4(31 downto4 0);
    	.psel4(psel_pmc4), 			//  : in  std_logic4;
    	.penable4(penable4), 		//  : in  std_logic4;
    	.pwrite4(pwrite4), 		//  : in  std_logic4;
    	.pwdata4(pwdata4), 		//  : in  std_logic_vector4(31 downto4 0);
    	.prdata4(prdata_pmc4), 		//  : out std_logic_vector4(31 downto4 0);
        .macb3_wakeup4(macb3_wakeup4),
        .macb2_wakeup4(macb2_wakeup4),
        .macb1_wakeup4(macb1_wakeup4),
        .macb0_wakeup4(macb0_wakeup4),
    // -- Module4 control4 outputs4
    	.scan_in4(),			//  : in  std_logic4;
    	.scan_en4(scan_en4),             	//  : in  std_logic4;
    	.scan_mode4(scan_mode4),          //  : in  std_logic4;
    	.scan_out4(),            	//  : out std_logic4;
        .int_source_h4(int_source_h4),
     	.rstn_non_srpg_smc4(rstn_non_srpg_smc4), 		//   : out std_logic4;
    	.gate_clk_smc4(gate_clk_smc4), 	//  : out std_logic4;
    	.isolate_smc4(isolate_smc4), 	//  : out std_logic4;
    	.save_edge_smc4(save_edge_smc4), 	//  : out std_logic4;
    	.restore_edge_smc4(restore_edge_smc4), 	//  : out std_logic4;
    	.pwr1_on_smc4(pwr1_on_smc4), 	//  : out std_logic4;
    	.pwr2_on_smc4(pwr2_on_smc4), 	//  : out std_logic4
     	.rstn_non_srpg_urt4(rstn_non_srpg_urt4), 		//   : out std_logic4;
    	.gate_clk_urt4(gate_clk_urt4), 	//  : out std_logic4;
    	.isolate_urt4(isolate_urt4), 	//  : out std_logic4;
    	.save_edge_urt4(save_edge_urt4), 	//  : out std_logic4;
    	.restore_edge_urt4(restore_edge_urt4), 	//  : out std_logic4;
    	.pwr1_on_urt4(pwr1_on_urt4), 	//  : out std_logic4;
    	.pwr2_on_urt4(pwr2_on_urt4),  	//  : out std_logic4
        // ETH04
        .rstn_non_srpg_macb04(rstn_non_srpg_macb04),
        .gate_clk_macb04(gate_clk_macb04),
        .isolate_macb04(isolate_macb04),
        .save_edge_macb04(save_edge_macb04),
        .restore_edge_macb04(restore_edge_macb04),
        .pwr1_on_macb04(pwr1_on_macb04),
        .pwr2_on_macb04(pwr2_on_macb04),
        // ETH14
        .rstn_non_srpg_macb14(rstn_non_srpg_macb14),
        .gate_clk_macb14(gate_clk_macb14),
        .isolate_macb14(isolate_macb14),
        .save_edge_macb14(save_edge_macb14),
        .restore_edge_macb14(restore_edge_macb14),
        .pwr1_on_macb14(pwr1_on_macb14),
        .pwr2_on_macb14(pwr2_on_macb14),
        // ETH24
        .rstn_non_srpg_macb24(rstn_non_srpg_macb24),
        .gate_clk_macb24(gate_clk_macb24),
        .isolate_macb24(isolate_macb24),
        .save_edge_macb24(save_edge_macb24),
        .restore_edge_macb24(restore_edge_macb24),
        .pwr1_on_macb24(pwr1_on_macb24),
        .pwr2_on_macb24(pwr2_on_macb24),
        // ETH34
        .rstn_non_srpg_macb34(rstn_non_srpg_macb34),
        .gate_clk_macb34(gate_clk_macb34),
        .isolate_macb34(isolate_macb34),
        .save_edge_macb34(save_edge_macb34),
        .restore_edge_macb34(restore_edge_macb34),
        .pwr1_on_macb34(pwr1_on_macb34),
        .pwr2_on_macb34(pwr2_on_macb34),
        .core06v4(core06v4),
        .core08v4(core08v4),
        .core10v4(core10v4),
        .core12v4(core12v4),
        .pcm_macb_wakeup_int4(pcm_macb_wakeup_int4),
        .isolate_mem4(isolate_mem4),
        .mte_smc_start4(mte_smc_start4),
        .mte_uart_start4(mte_uart_start4),
        .mte_smc_uart_start4(mte_smc_uart_start4),  
        .mte_pm_smc_to_default_start4(mte_pm_smc_to_default_start4), 
        .mte_pm_uart_to_default_start4(mte_pm_uart_to_default_start4),
        .mte_pm_smc_uart_to_default_start4(mte_pm_smc_uart_to_default_start4)
);

// Clock4 gating4 macro4 to shut4 off4 clocks4 to the SRPG4 flops4 in the SMC4
//CKLNQD14 i_SMC_SRPG_clk_gate4  (
//	.TE4(scan_mode4), 
//	.E4(~gate_clk_smc4), 
//	.CP4(pclk4), 
//	.Q4(pclk_SRPG_smc4)
//	);
// Replace4 gate4 with behavioural4 code4 //
wire 	smc_scan_gate4;
reg 	smc_latched_enable4;
assign smc_scan_gate4 = scan_mode4 ? 1'b1 : ~gate_clk_smc4;

always @ (pclk4 or smc_scan_gate4)
  	if (pclk4 == 1'b0) begin
  		smc_latched_enable4 <= smc_scan_gate4;
  	end  	
	
assign pclk_SRPG_smc4 = smc_latched_enable4 ? pclk4 : 1'b0;


// Clock4 gating4 macro4 to shut4 off4 clocks4 to the SRPG4 flops4 in the URT4
//CKLNQD14 i_URT_SRPG_clk_gate4  (
//	.TE4(scan_mode4), 
//	.E4(~gate_clk_urt4), 
//	.CP4(pclk4), 
//	.Q4(pclk_SRPG_urt4)
//	);
// Replace4 gate4 with behavioural4 code4 //
wire 	urt_scan_gate4;
reg 	urt_latched_enable4;
assign urt_scan_gate4 = scan_mode4 ? 1'b1 : ~gate_clk_urt4;

always @ (pclk4 or urt_scan_gate4)
  	if (pclk4 == 1'b0) begin
  		urt_latched_enable4 <= urt_scan_gate4;
  	end  	
	
assign pclk_SRPG_urt4 = urt_latched_enable4 ? pclk4 : 1'b0;

// ETH04
wire 	macb0_scan_gate4;
reg 	macb0_latched_enable4;
assign macb0_scan_gate4 = scan_mode4 ? 1'b1 : ~gate_clk_macb04;

always @ (pclk4 or macb0_scan_gate4)
  	if (pclk4 == 1'b0) begin
  		macb0_latched_enable4 <= macb0_scan_gate4;
  	end  	
	
assign clk_SRPG_macb0_en4 = macb0_latched_enable4 ? 1'b1 : 1'b0;

// ETH14
wire 	macb1_scan_gate4;
reg 	macb1_latched_enable4;
assign macb1_scan_gate4 = scan_mode4 ? 1'b1 : ~gate_clk_macb14;

always @ (pclk4 or macb1_scan_gate4)
  	if (pclk4 == 1'b0) begin
  		macb1_latched_enable4 <= macb1_scan_gate4;
  	end  	
	
assign clk_SRPG_macb1_en4 = macb1_latched_enable4 ? 1'b1 : 1'b0;

// ETH24
wire 	macb2_scan_gate4;
reg 	macb2_latched_enable4;
assign macb2_scan_gate4 = scan_mode4 ? 1'b1 : ~gate_clk_macb24;

always @ (pclk4 or macb2_scan_gate4)
  	if (pclk4 == 1'b0) begin
  		macb2_latched_enable4 <= macb2_scan_gate4;
  	end  	
	
assign clk_SRPG_macb2_en4 = macb2_latched_enable4 ? 1'b1 : 1'b0;

// ETH34
wire 	macb3_scan_gate4;
reg 	macb3_latched_enable4;
assign macb3_scan_gate4 = scan_mode4 ? 1'b1 : ~gate_clk_macb34;

always @ (pclk4 or macb3_scan_gate4)
  	if (pclk4 == 1'b0) begin
  		macb3_latched_enable4 <= macb3_scan_gate4;
  	end  	
	
assign clk_SRPG_macb3_en4 = macb3_latched_enable4 ? 1'b1 : 1'b0;



`else
//------------------------------------------------------------------------------
// if the APB4 subsystem4 is black4 boxed4 
//------------------------------------------------------------------------------
// wire s ports4
    // system signals4
    wire         hclk4;     // AHB4 Clock4
    wire         n_hreset4;  // AHB4 reset - Active4 low4
    wire         pclk4;     // APB4 Clock4. 
    wire         n_preset4;  // APB4 reset - Active4 low4

    // AHB4 interface
    wire         ahb2apb0_hsel4;     // AHB2APB4 select4
    wire  [31:0] haddr4;    // Address bus
    wire  [1:0]  htrans4;   // Transfer4 type
    wire  [2:0]  hsize4;    // AHB4 Access type - byte, half4-word4, word4
    wire  [31:0] hwdata4;   // Write data
    wire         hwrite4;   // Write signal4/
    wire         hready_in4;// Indicates4 that last master4 has finished4 bus access
    wire [2:0]   hburst4;     // Burst type
    wire [3:0]   hprot4;      // Protection4 control4
    wire [3:0]   hmaster4;    // Master4 select4
    wire         hmastlock4;  // Locked4 transfer4
  // Interrupts4 from the Enet4 MACs4
    wire         macb0_int4;
    wire         macb1_int4;
    wire         macb2_int4;
    wire         macb3_int4;
  // Interrupt4 from the DMA4
    wire         DMA_irq4;
  // Scan4 wire s
    wire         scan_en4;    // Scan4 enable pin4
    wire         scan_in_14;  // Scan4 wire  for first chain4
    wire         scan_in_24;  // Scan4 wire  for second chain4
    wire         scan_mode4;  // test mode pin4
 
  //wire  for smc4 AHB4 interface
    wire         smc_hclk4;
    wire         smc_n_hclk4;
    wire  [31:0] smc_haddr4;
    wire  [1:0]  smc_htrans4;
    wire         smc_hsel4;
    wire         smc_hwrite4;
    wire  [2:0]  smc_hsize4;
    wire  [31:0] smc_hwdata4;
    wire         smc_hready_in4;
    wire  [2:0]  smc_hburst4;     // Burst type
    wire  [3:0]  smc_hprot4;      // Protection4 control4
    wire  [3:0]  smc_hmaster4;    // Master4 select4
    wire         smc_hmastlock4;  // Locked4 transfer4


    wire  [31:0] data_smc4;     // EMI4(External4 memory) read data
    
  //wire s for uart4
    wire         ua_rxd4;       // UART4 receiver4 serial4 wire  pin4
    wire         ua_rxd14;      // UART4 receiver4 serial4 wire  pin4
    wire         ua_ncts4;      // Clear-To4-Send4 flow4 control4
    wire         ua_ncts14;      // Clear-To4-Send4 flow4 control4
   //wire s for spi4
    wire         n_ss_in4;      // select4 wire  to slave4
    wire         mi4;           // data wire  to master4
    wire         si4;           // data wire  to slave4
    wire         sclk_in4;      // clock4 wire  to slave4
  //wire s for GPIO4
   wire  [GPIO_WIDTH4-1:0]  gpio_pin_in4;             // wire  data from pin4

  //reg    ports4
  // Scan4 reg   s
   reg           scan_out_14;   // Scan4 out for chain4 1
   reg           scan_out_24;   // Scan4 out for chain4 2
  //AHB4 interface 
   reg    [31:0] hrdata4;       // Read data provided from target slave4
   reg           hready4;       // Ready4 for new bus cycle from target slave4
   reg    [1:0]  hresp4;       // Response4 from the bridge4

   // SMC4 reg    for AHB4 interface
   reg    [31:0]    smc_hrdata4;
   reg              smc_hready4;
   reg    [1:0]     smc_hresp4;

  //reg   s from smc4
   reg    [15:0]    smc_addr4;      // External4 Memory (EMI4) address
   reg    [3:0]     smc_n_be4;      // EMI4 byte enables4 (Active4 LOW4)
   reg    [7:0]     smc_n_cs4;      // EMI4 Chip4 Selects4 (Active4 LOW4)
   reg    [3:0]     smc_n_we4;      // EMI4 write strobes4 (Active4 LOW4)
   reg              smc_n_wr4;      // EMI4 write enable (Active4 LOW4)
   reg              smc_n_rd4;      // EMI4 read stobe4 (Active4 LOW4)
   reg              smc_n_ext_oe4;  // EMI4 write data reg    enable
   reg    [31:0]    smc_data4;      // EMI4 write data
  //reg   s from uart4
   reg           ua_txd4;       	// UART4 transmitter4 serial4 reg   
   reg           ua_txd14;       // UART4 transmitter4 serial4 reg   
   reg           ua_nrts4;      	// Request4-To4-Send4 flow4 control4
   reg           ua_nrts14;      // Request4-To4-Send4 flow4 control4
   // reg   s from ttc4
  // reg   s from SPI4
   reg       so;                    // data reg    from slave4
   reg       mo4;                    // data reg    from master4
   reg       sclk_out4;              // clock4 reg    from master4
   reg    [P_SIZE4-1:0] n_ss_out4;    // peripheral4 select4 lines4 from master4
   reg       n_so_en4;               // out enable for slave4 data
   reg       n_mo_en4;               // out enable for master4 data
   reg       n_sclk_en4;             // out enable for master4 clock4
   reg       n_ss_en4;               // out enable for master4 peripheral4 lines4
  //reg   s from gpio4
   reg    [GPIO_WIDTH4-1:0]     n_gpio_pin_oe4;           // reg    enable signal4 to pin4
   reg    [GPIO_WIDTH4-1:0]     gpio_pin_out4;            // reg    signal4 to pin4


`endif
//------------------------------------------------------------------------------
// black4 boxed4 defines4 
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// APB4 and AHB4 interface formal4 verification4 monitors4
//------------------------------------------------------------------------------
`ifdef ABV_ON4
apb_assert4 i_apb_assert4 (

        // APB4 signals4
  	.n_preset4(n_preset4),
   	.pclk4(pclk4),
	.penable4(penable4),
	.paddr4(paddr4),
	.pwrite4(pwrite4),
	.pwdata4(pwdata4),

	.psel004(psel_spi4),
	.psel014(psel_uart04),
	.psel024(psel_gpio4),
	.psel034(psel_ttc4),
	.psel044(1'b0),
	.psel054(psel_smc4),
	.psel064(1'b0),
	.psel074(1'b0),
	.psel084(1'b0),
	.psel094(1'b0),
	.psel104(1'b0),
	.psel114(1'b0),
	.psel124(1'b0),
	.psel134(psel_pmc4),
	.psel144(psel_apic4),
	.psel154(psel_uart14),

        .prdata004(prdata_spi4),
        .prdata014(prdata_uart04), // Read Data from peripheral4 UART4 
        .prdata024(prdata_gpio4), // Read Data from peripheral4 GPIO4
        .prdata034(prdata_ttc4), // Read Data from peripheral4 TTC4
        .prdata044(32'b0), // 
        .prdata054(prdata_smc4), // Read Data from peripheral4 SMC4
        .prdata134(prdata_pmc4), // Read Data from peripheral4 Power4 Control4 Block
   	.prdata144(32'b0), // 
        .prdata154(prdata_uart14),


        // AHB4 signals4
        .hclk4(hclk4),         // ahb4 system clock4
        .n_hreset4(n_hreset4), // ahb4 system reset

        // ahb2apb4 signals4
        .hresp4(hresp4),
        .hready4(hready4),
        .hrdata4(hrdata4),
        .hwdata4(hwdata4),
        .hprot4(hprot4),
        .hburst4(hburst4),
        .hsize4(hsize4),
        .hwrite4(hwrite4),
        .htrans4(htrans4),
        .haddr4(haddr4),
        .ahb2apb_hsel4(ahb2apb0_hsel4));



//------------------------------------------------------------------------------
// AHB4 interface formal4 verification4 monitor4
//------------------------------------------------------------------------------
defparam i_ahbSlaveMonitor4.DBUS_WIDTH4 = 32;
defparam i_ahbMasterMonitor4.DBUS_WIDTH4 = 32;


// AHB2APB4 Bridge4

    ahb_liteslave_monitor4 i_ahbSlaveMonitor4 (
        .hclk_i4(hclk4),
        .hresetn_i4(n_hreset4),
        .hresp4(hresp4),
        .hready4(hready4),
        .hready_global_i4(hready4),
        .hrdata4(hrdata4),
        .hwdata_i4(hwdata4),
        .hburst_i4(hburst4),
        .hsize_i4(hsize4),
        .hwrite_i4(hwrite4),
        .htrans_i4(htrans4),
        .haddr_i4(haddr4),
        .hsel_i4(ahb2apb0_hsel4)
    );


  ahb_litemaster_monitor4 i_ahbMasterMonitor4 (
          .hclk_i4(hclk4),
          .hresetn_i4(n_hreset4),
          .hresp_i4(hresp4),
          .hready_i4(hready4),
          .hrdata_i4(hrdata4),
          .hlock4(1'b0),
          .hwdata4(hwdata4),
          .hprot4(hprot4),
          .hburst4(hburst4),
          .hsize4(hsize4),
          .hwrite4(hwrite4),
          .htrans4(htrans4),
          .haddr4(haddr4)
          );







`endif




`ifdef IFV_LP_ABV_ON4
// power4 control4
wire isolate4;

// testbench mirror signals4
wire L1_ctrl_access4;
wire L1_status_access4;

wire [31:0] L1_status_reg4;
wire [31:0] L1_ctrl_reg4;

//wire rstn_non_srpg_urt4;
//wire isolate_urt4;
//wire retain_urt4;
//wire gate_clk_urt4;
//wire pwr1_on_urt4;


// smc4 signals4
wire [31:0] smc_prdata4;
wire lp_clk_smc4;
                    

// uart4 isolation4 register
  wire [15:0] ua_prdata4;
  wire ua_int4;
  assign ua_prdata4          =  i_uart1_veneer4.prdata4;
  assign ua_int4             =  i_uart1_veneer4.ua_int4;


assign lp_clk_smc4          = i_smc_veneer4.pclk4;
assign smc_prdata4          = i_smc_veneer4.prdata4;
lp_chk_smc4 u_lp_chk_smc4 (
    .clk4 (hclk4),
    .rst4 (n_hreset4),
    .iso_smc4 (isolate_smc4),
    .gate_clk4 (gate_clk_smc4),
    .lp_clk4 (pclk_SRPG_smc4),

    // srpg4 outputs4
    .smc_hrdata4 (smc_hrdata4),
    .smc_hready4 (smc_hready4),
    .smc_hresp4  (smc_hresp4),
    .smc_valid4 (smc_valid4),
    .smc_addr_int4 (smc_addr_int4),
    .smc_data4 (smc_data4),
    .smc_n_be4 (smc_n_be4),
    .smc_n_cs4  (smc_n_cs4),
    .smc_n_wr4 (smc_n_wr4),
    .smc_n_we4 (smc_n_we4),
    .smc_n_rd4 (smc_n_rd4),
    .smc_n_ext_oe4 (smc_n_ext_oe4)
   );

// lp4 retention4/isolation4 assertions4
lp_chk_uart4 u_lp_chk_urt4 (

  .clk4         (hclk4),
  .rst4         (n_hreset4),
  .iso_urt4     (isolate_urt4),
  .gate_clk4    (gate_clk_urt4),
  .lp_clk4      (pclk_SRPG_urt4),
  //ports4
  .prdata4 (ua_prdata4),
  .ua_int4 (ua_int4),
  .ua_txd4 (ua_txd14),
  .ua_nrts4 (ua_nrts14)
 );

`endif  //IFV_LP_ABV_ON4




endmodule
