//File10 name   : apb_subsystem_010.v
//Title10       : 
//Created10     : 1999
//Description10 : 
//Notes10       : 
//----------------------------------------------------------------------
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------

module apb_subsystem_010(
    // AHB10 interface
    hclk10,
    n_hreset10,
    hsel10,
    haddr10,
    htrans10,
    hsize10,
    hwrite10,
    hwdata10,
    hready_in10,
    hburst10,
    hprot10,
    hmaster10,
    hmastlock10,
    hrdata10,
    hready10,
    hresp10,
    
    // APB10 system interface
    pclk10,
    n_preset10,
    
    // SPI10 ports10
    n_ss_in10,
    mi10,
    si10,
    sclk_in10,
    so,
    mo10,
    sclk_out10,
    n_ss_out10,
    n_so_en10,
    n_mo_en10,
    n_sclk_en10,
    n_ss_en10,
    
    //UART010 ports10
    ua_rxd10,
    ua_ncts10,
    ua_txd10,
    ua_nrts10,
    
    //UART110 ports10
    ua_rxd110,
    ua_ncts110,
    ua_txd110,
    ua_nrts110,
    
    //GPIO10 ports10
    gpio_pin_in10,
    n_gpio_pin_oe10,
    gpio_pin_out10,
    

    //SMC10 ports10
    smc_hclk10,
    smc_n_hclk10,
    smc_haddr10,
    smc_htrans10,
    smc_hsel10,
    smc_hwrite10,
    smc_hsize10,
    smc_hwdata10,
    smc_hready_in10,
    smc_hburst10,
    smc_hprot10,
    smc_hmaster10,
    smc_hmastlock10,
    smc_hrdata10, 
    smc_hready10,
    smc_hresp10,
    smc_n_ext_oe10,
    smc_data10,
    smc_addr10,
    smc_n_be10,
    smc_n_cs10, 
    smc_n_we10,
    smc_n_wr10,
    smc_n_rd10,
    data_smc10,
    
    //PMC10 ports10
    clk_SRPG_macb0_en10,
    clk_SRPG_macb1_en10,
    clk_SRPG_macb2_en10,
    clk_SRPG_macb3_en10,
    core06v10,
    core08v10,
    core10v10,
    core12v10,
    macb3_wakeup10,
    macb2_wakeup10,
    macb1_wakeup10,
    macb0_wakeup10,
    mte_smc_start10,
    mte_uart_start10,
    mte_smc_uart_start10,  
    mte_pm_smc_to_default_start10, 
    mte_pm_uart_to_default_start10,
    mte_pm_smc_uart_to_default_start10,
    
    
    // Peripheral10 inerrupts10
    pcm_irq10,
    ttc_irq10,
    gpio_irq10,
    uart0_irq10,
    uart1_irq10,
    spi_irq10,
    DMA_irq10,      
    macb0_int10,
    macb1_int10,
    macb2_int10,
    macb3_int10,
   
    // Scan10 ports10
    scan_en10,      // Scan10 enable pin10
    scan_in_110,    // Scan10 input for first chain10
    scan_in_210,    // Scan10 input for second chain10
    scan_mode10,
    scan_out_110,   // Scan10 out for chain10 1
    scan_out_210    // Scan10 out for chain10 2
);

parameter GPIO_WIDTH10 = 16;        // GPIO10 width
parameter P_SIZE10 =   8;              // number10 of peripheral10 select10 lines10
parameter NO_OF_IRQS10  = 17;      //No of irqs10 read by apic10 

// AHB10 interface
input         hclk10;     // AHB10 Clock10
input         n_hreset10;  // AHB10 reset - Active10 low10
input         hsel10;     // AHB2APB10 select10
input [31:0]  haddr10;    // Address bus
input [1:0]   htrans10;   // Transfer10 type
input [2:0]   hsize10;    // AHB10 Access type - byte, half10-word10, word10
input [31:0]  hwdata10;   // Write data
input         hwrite10;   // Write signal10/
input         hready_in10;// Indicates10 that last master10 has finished10 bus access
input [2:0]   hburst10;     // Burst type
input [3:0]   hprot10;      // Protection10 control10
input [3:0]   hmaster10;    // Master10 select10
input         hmastlock10;  // Locked10 transfer10
output [31:0] hrdata10;       // Read data provided from target slave10
output        hready10;       // Ready10 for new bus cycle from target slave10
output [1:0]  hresp10;       // Response10 from the bridge10
    
// APB10 system interface
input         pclk10;     // APB10 Clock10. 
input         n_preset10;  // APB10 reset - Active10 low10
   
// SPI10 ports10
input     n_ss_in10;      // select10 input to slave10
input     mi10;           // data input to master10
input     si10;           // data input to slave10
input     sclk_in10;      // clock10 input to slave10
output    so;                    // data output from slave10
output    mo10;                    // data output from master10
output    sclk_out10;              // clock10 output from master10
output [P_SIZE10-1:0] n_ss_out10;    // peripheral10 select10 lines10 from master10
output    n_so_en10;               // out enable for slave10 data
output    n_mo_en10;               // out enable for master10 data
output    n_sclk_en10;             // out enable for master10 clock10
output    n_ss_en10;               // out enable for master10 peripheral10 lines10

//UART010 ports10
input        ua_rxd10;       // UART10 receiver10 serial10 input pin10
input        ua_ncts10;      // Clear-To10-Send10 flow10 control10
output       ua_txd10;       	// UART10 transmitter10 serial10 output
output       ua_nrts10;      	// Request10-To10-Send10 flow10 control10

// UART110 ports10   
input        ua_rxd110;      // UART10 receiver10 serial10 input pin10
input        ua_ncts110;      // Clear-To10-Send10 flow10 control10
output       ua_txd110;       // UART10 transmitter10 serial10 output
output       ua_nrts110;      // Request10-To10-Send10 flow10 control10

//GPIO10 ports10
input [GPIO_WIDTH10-1:0]      gpio_pin_in10;             // input data from pin10
output [GPIO_WIDTH10-1:0]     n_gpio_pin_oe10;           // output enable signal10 to pin10
output [GPIO_WIDTH10-1:0]     gpio_pin_out10;            // output signal10 to pin10
  
//SMC10 ports10
input        smc_hclk10;
input        smc_n_hclk10;
input [31:0] smc_haddr10;
input [1:0]  smc_htrans10;
input        smc_hsel10;
input        smc_hwrite10;
input [2:0]  smc_hsize10;
input [31:0] smc_hwdata10;
input        smc_hready_in10;
input [2:0]  smc_hburst10;     // Burst type
input [3:0]  smc_hprot10;      // Protection10 control10
input [3:0]  smc_hmaster10;    // Master10 select10
input        smc_hmastlock10;  // Locked10 transfer10
input [31:0] data_smc10;     // EMI10(External10 memory) read data
output [31:0]    smc_hrdata10;
output           smc_hready10;
output [1:0]     smc_hresp10;
output [15:0]    smc_addr10;      // External10 Memory (EMI10) address
output [3:0]     smc_n_be10;      // EMI10 byte enables10 (Active10 LOW10)
output           smc_n_cs10;      // EMI10 Chip10 Selects10 (Active10 LOW10)
output [3:0]     smc_n_we10;      // EMI10 write strobes10 (Active10 LOW10)
output           smc_n_wr10;      // EMI10 write enable (Active10 LOW10)
output           smc_n_rd10;      // EMI10 read stobe10 (Active10 LOW10)
output           smc_n_ext_oe10;  // EMI10 write data output enable
output [31:0]    smc_data10;      // EMI10 write data
       
//PMC10 ports10
output clk_SRPG_macb0_en10;
output clk_SRPG_macb1_en10;
output clk_SRPG_macb2_en10;
output clk_SRPG_macb3_en10;
output core06v10;
output core08v10;
output core10v10;
output core12v10;
output mte_smc_start10;
output mte_uart_start10;
output mte_smc_uart_start10;  
output mte_pm_smc_to_default_start10; 
output mte_pm_uart_to_default_start10;
output mte_pm_smc_uart_to_default_start10;
input macb3_wakeup10;
input macb2_wakeup10;
input macb1_wakeup10;
input macb0_wakeup10;
    

// Peripheral10 interrupts10
output pcm_irq10;
output [2:0] ttc_irq10;
output gpio_irq10;
output uart0_irq10;
output uart1_irq10;
output spi_irq10;
input        macb0_int10;
input        macb1_int10;
input        macb2_int10;
input        macb3_int10;
input        DMA_irq10;
  
//Scan10 ports10
input        scan_en10;    // Scan10 enable pin10
input        scan_in_110;  // Scan10 input for first chain10
input        scan_in_210;  // Scan10 input for second chain10
input        scan_mode10;  // test mode pin10
 output        scan_out_110;   // Scan10 out for chain10 1
 output        scan_out_210;   // Scan10 out for chain10 2  

//------------------------------------------------------------------------------
// if the ROM10 subsystem10 is NOT10 black10 boxed10 
//------------------------------------------------------------------------------
`ifndef FV_KIT_BLACK_BOX_APB_SUBSYSTEM10
   
   wire        hsel10; 
   wire        pclk10;
   wire        n_preset10;
   wire [31:0] prdata_spi10;
   wire [31:0] prdata_uart010;
   wire [31:0] prdata_gpio10;
   wire [31:0] prdata_ttc10;
   wire [31:0] prdata_smc10;
   wire [31:0] prdata_pmc10;
   wire [31:0] prdata_uart110;
   wire        pready_spi10;
   wire        pready_uart010;
   wire        pready_uart110;
   wire        tie_hi_bit10;
   wire  [31:0] hrdata10; 
   wire         hready10;
   wire         hready_in10;
   wire  [1:0]  hresp10;   
   wire  [31:0] pwdata10;  
   wire         pwrite10;
   wire  [31:0] paddr10;  
   wire   psel_spi10;
   wire   psel_uart010;
   wire   psel_gpio10;
   wire   psel_ttc10;
   wire   psel_smc10;
   wire   psel0710;
   wire   psel0810;
   wire   psel0910;
   wire   psel1010;
   wire   psel1110;
   wire   psel1210;
   wire   psel_pmc10;
   wire   psel_uart110;
   wire   penable10;
   wire   [NO_OF_IRQS10:0] int_source10;     // System10 Interrupt10 Sources10
   wire [1:0]             smc_hresp10;     // AHB10 Response10 signal10
   wire                   smc_valid10;     // Ack10 valid address

  //External10 memory interface (EMI10)
  wire [31:0]            smc_addr_int10;  // External10 Memory (EMI10) address
  wire [3:0]             smc_n_be10;      // EMI10 byte enables10 (Active10 LOW10)
  wire                   smc_n_cs10;      // EMI10 Chip10 Selects10 (Active10 LOW10)
  wire [3:0]             smc_n_we10;      // EMI10 write strobes10 (Active10 LOW10)
  wire                   smc_n_wr10;      // EMI10 write enable (Active10 LOW10)
  wire                   smc_n_rd10;      // EMI10 read stobe10 (Active10 LOW10)
 
  //AHB10 Memory Interface10 Control10
  wire                   smc_hsel_int10;
  wire                   smc_busy10;      // smc10 busy
   

//scan10 signals10

   wire                scan_in_110;        //scan10 input
   wire                scan_in_210;        //scan10 input
   wire                scan_en10;         //scan10 enable
   wire                scan_out_110;       //scan10 output
   wire                scan_out_210;       //scan10 output
   wire                byte_sel10;     // byte select10 from bridge10 1=byte, 0=2byte
   wire                UART_int10;     // UART10 module interrupt10 
   wire                ua_uclken10;    // Soft10 control10 of clock10
   wire                UART_int110;     // UART10 module interrupt10 
   wire                ua_uclken110;    // Soft10 control10 of clock10
   wire  [3:1]         TTC_int10;            //Interrupt10 from PCI10 
  // inputs10 to SPI10 
   wire    ext_clk10;                // external10 clock10
   wire    SPI_int10;             // interrupt10 request
  // outputs10 from SPI10
   wire    slave_out_clk10;         // modified slave10 clock10 output
 // gpio10 generic10 inputs10 
   wire  [GPIO_WIDTH10-1:0]   n_gpio_bypass_oe10;        // bypass10 mode enable 
   wire  [GPIO_WIDTH10-1:0]   gpio_bypass_out10;         // bypass10 mode output value 
   wire  [GPIO_WIDTH10-1:0]   tri_state_enable10;   // disables10 op enable -> z 
 // outputs10 
   //amba10 outputs10 
   // gpio10 generic10 outputs10 
   wire       GPIO_int10;                // gpio_interupt10 for input pin10 change 
   wire [GPIO_WIDTH10-1:0]     gpio_bypass_in10;          // bypass10 mode input data value  
                
   wire           cpu_debug10;        // Inhibits10 watchdog10 counter 
   wire            ex_wdz_n10;         // External10 Watchdog10 zero indication10
   wire           rstn_non_srpg_smc10; 
   wire           rstn_non_srpg_urt10;
   wire           isolate_smc10;
   wire           save_edge_smc10;
   wire           restore_edge_smc10;
   wire           save_edge_urt10;
   wire           restore_edge_urt10;
   wire           pwr1_on_smc10;
   wire           pwr2_on_smc10;
   wire           pwr1_on_urt10;
   wire           pwr2_on_urt10;
   // ETH010
   wire            rstn_non_srpg_macb010;
   wire            gate_clk_macb010;
   wire            isolate_macb010;
   wire            save_edge_macb010;
   wire            restore_edge_macb010;
   wire            pwr1_on_macb010;
   wire            pwr2_on_macb010;
   // ETH110
   wire            rstn_non_srpg_macb110;
   wire            gate_clk_macb110;
   wire            isolate_macb110;
   wire            save_edge_macb110;
   wire            restore_edge_macb110;
   wire            pwr1_on_macb110;
   wire            pwr2_on_macb110;
   // ETH210
   wire            rstn_non_srpg_macb210;
   wire            gate_clk_macb210;
   wire            isolate_macb210;
   wire            save_edge_macb210;
   wire            restore_edge_macb210;
   wire            pwr1_on_macb210;
   wire            pwr2_on_macb210;
   // ETH310
   wire            rstn_non_srpg_macb310;
   wire            gate_clk_macb310;
   wire            isolate_macb310;
   wire            save_edge_macb310;
   wire            restore_edge_macb310;
   wire            pwr1_on_macb310;
   wire            pwr2_on_macb310;


   wire           pclk_SRPG_smc10;
   wire           pclk_SRPG_urt10;
   wire           gate_clk_smc10;
   wire           gate_clk_urt10;
   wire  [31:0]   tie_lo_32bit10; 
   wire  [1:0]	  tie_lo_2bit10;
   wire  	  tie_lo_1bit10;
   wire           pcm_macb_wakeup_int10;
   wire           int_source_h10;
   wire           isolate_mem10;

assign pcm_irq10 = pcm_macb_wakeup_int10;
assign ttc_irq10[2] = TTC_int10[3];
assign ttc_irq10[1] = TTC_int10[2];
assign ttc_irq10[0] = TTC_int10[1];
assign gpio_irq10 = GPIO_int10;
assign uart0_irq10 = UART_int10;
assign uart1_irq10 = UART_int110;
assign spi_irq10 = SPI_int10;

assign n_mo_en10   = 1'b0;
assign n_so_en10   = 1'b1;
assign n_sclk_en10 = 1'b0;
assign n_ss_en10   = 1'b0;

assign smc_hsel_int10 = smc_hsel10;
  assign ext_clk10  = 1'b0;
  assign int_source10 = {macb0_int10,macb1_int10, macb2_int10, macb3_int10,1'b0, pcm_macb_wakeup_int10, 1'b0, 1'b0, 1'b0, 1'b0, TTC_int10, GPIO_int10, UART_int10, UART_int110, SPI_int10, DMA_irq10};

  // interrupt10 even10 detect10 .
  // for sleep10 wake10 up -> any interrupt10 even10 and system not in hibernation10 (isolate_mem10 = 0)
  // for hibernate10 wake10 up -> gpio10 interrupt10 even10 and system in the hibernation10 (isolate_mem10 = 1)
  assign int_source_h10 =  ((|int_source10) && (!isolate_mem10)) || (isolate_mem10 && GPIO_int10) ;

  assign byte_sel10 = 1'b1;
  assign tie_hi_bit10 = 1'b1;

  assign smc_addr10 = smc_addr_int10[15:0];



  assign  n_gpio_bypass_oe10 = {GPIO_WIDTH10{1'b0}};        // bypass10 mode enable 
  assign  gpio_bypass_out10  = {GPIO_WIDTH10{1'b0}};
  assign  tri_state_enable10 = {GPIO_WIDTH10{1'b0}};
  assign  cpu_debug10 = 1'b0;
  assign  tie_lo_32bit10 = 32'b0;
  assign  tie_lo_2bit10  = 2'b0;
  assign  tie_lo_1bit10  = 1'b0;


ahb2apb10 #(
  32'h00800000, // Slave10 0 Address Range10
  32'h0080FFFF,

  32'h00810000, // Slave10 1 Address Range10
  32'h0081FFFF,

  32'h00820000, // Slave10 2 Address Range10 
  32'h0082FFFF,

  32'h00830000, // Slave10 3 Address Range10
  32'h0083FFFF,

  32'h00840000, // Slave10 4 Address Range10
  32'h0084FFFF,

  32'h00850000, // Slave10 5 Address Range10
  32'h0085FFFF,

  32'h00860000, // Slave10 6 Address Range10
  32'h0086FFFF,

  32'h00870000, // Slave10 7 Address Range10
  32'h0087FFFF,

  32'h00880000, // Slave10 8 Address Range10
  32'h0088FFFF
) i_ahb2apb10 (
     // AHB10 interface
    .hclk10(hclk10),         
    .hreset_n10(n_hreset10), 
    .hsel10(hsel10), 
    .haddr10(haddr10),        
    .htrans10(htrans10),       
    .hwrite10(hwrite10),       
    .hwdata10(hwdata10),       
    .hrdata10(hrdata10),   
    .hready10(hready10),   
    .hresp10(hresp10),     
    
     // APB10 interface
    .pclk10(pclk10),         
    .preset_n10(n_preset10),  
    .prdata010(prdata_spi10),
    .prdata110(prdata_uart010), 
    .prdata210(prdata_gpio10),  
    .prdata310(prdata_ttc10),   
    .prdata410(32'h0),   
    .prdata510(prdata_smc10),   
    .prdata610(prdata_pmc10),    
    .prdata710(32'h0),   
    .prdata810(prdata_uart110),  
    .pready010(pready_spi10),     
    .pready110(pready_uart010),   
    .pready210(tie_hi_bit10),     
    .pready310(tie_hi_bit10),     
    .pready410(tie_hi_bit10),     
    .pready510(tie_hi_bit10),     
    .pready610(tie_hi_bit10),     
    .pready710(tie_hi_bit10),     
    .pready810(pready_uart110),  
    .pwdata10(pwdata10),       
    .pwrite10(pwrite10),       
    .paddr10(paddr10),        
    .psel010(psel_spi10),     
    .psel110(psel_uart010),   
    .psel210(psel_gpio10),    
    .psel310(psel_ttc10),     
    .psel410(),     
    .psel510(psel_smc10),     
    .psel610(psel_pmc10),    
    .psel710(psel_apic10),   
    .psel810(psel_uart110),  
    .penable10(penable10)     
);

spi_top10 i_spi10
(
  // Wishbone10 signals10
  .wb_clk_i10(pclk10), 
  .wb_rst_i10(~n_preset10), 
  .wb_adr_i10(paddr10[4:0]), 
  .wb_dat_i10(pwdata10), 
  .wb_dat_o10(prdata_spi10), 
  .wb_sel_i10(4'b1111),    // SPI10 register accesses are always 32-bit
  .wb_we_i10(pwrite10), 
  .wb_stb_i10(psel_spi10), 
  .wb_cyc_i10(psel_spi10), 
  .wb_ack_o10(pready_spi10), 
  .wb_err_o10(), 
  .wb_int_o10(SPI_int10),

  // SPI10 signals10
  .ss_pad_o10(n_ss_out10), 
  .sclk_pad_o10(sclk_out10), 
  .mosi_pad_o10(mo10), 
  .miso_pad_i10(mi10)
);

// Opencores10 UART10 instances10
wire ua_nrts_int10;
wire ua_nrts1_int10;

assign ua_nrts10 = ua_nrts_int10;
assign ua_nrts110 = ua_nrts1_int10;

reg [3:0] uart0_sel_i10;
reg [3:0] uart1_sel_i10;
// UART10 registers are all 8-bit wide10, and their10 addresses10
// are on byte boundaries10. So10 to access them10 on the
// Wishbone10 bus, the CPU10 must do byte accesses to these10
// byte addresses10. Word10 address accesses are not possible10
// because the word10 addresses10 will be unaligned10, and cause
// a fault10.
// So10, Uart10 accesses from the CPU10 will always be 8-bit size
// We10 only have to decide10 which byte of the 4-byte word10 the
// CPU10 is interested10 in.
`ifdef SYSTEM_BIG_ENDIAN10
always @(paddr10) begin
  case (paddr10[1:0])
    2'b00 : uart0_sel_i10 = 4'b1000;
    2'b01 : uart0_sel_i10 = 4'b0100;
    2'b10 : uart0_sel_i10 = 4'b0010;
    2'b11 : uart0_sel_i10 = 4'b0001;
  endcase
end
always @(paddr10) begin
  case (paddr10[1:0])
    2'b00 : uart1_sel_i10 = 4'b1000;
    2'b01 : uart1_sel_i10 = 4'b0100;
    2'b10 : uart1_sel_i10 = 4'b0010;
    2'b11 : uart1_sel_i10 = 4'b0001;
  endcase
end
`else
always @(paddr10) begin
  case (paddr10[1:0])
    2'b00 : uart0_sel_i10 = 4'b0001;
    2'b01 : uart0_sel_i10 = 4'b0010;
    2'b10 : uart0_sel_i10 = 4'b0100;
    2'b11 : uart0_sel_i10 = 4'b1000;
  endcase
end
always @(paddr10) begin
  case (paddr10[1:0])
    2'b00 : uart1_sel_i10 = 4'b0001;
    2'b01 : uart1_sel_i10 = 4'b0010;
    2'b10 : uart1_sel_i10 = 4'b0100;
    2'b11 : uart1_sel_i10 = 4'b1000;
  endcase
end
`endif

uart_top10 i_oc_uart010 (
  .wb_clk_i10(pclk10),
  .wb_rst_i10(~n_preset10),
  .wb_adr_i10(paddr10[4:0]),
  .wb_dat_i10(pwdata10),
  .wb_dat_o10(prdata_uart010),
  .wb_we_i10(pwrite10),
  .wb_stb_i10(psel_uart010),
  .wb_cyc_i10(psel_uart010),
  .wb_ack_o10(pready_uart010),
  .wb_sel_i10(uart0_sel_i10),
  .int_o10(UART_int10),
  .stx_pad_o10(ua_txd10),
  .srx_pad_i10(ua_rxd10),
  .rts_pad_o10(ua_nrts_int10),
  .cts_pad_i10(ua_ncts10),
  .dtr_pad_o10(),
  .dsr_pad_i10(1'b0),
  .ri_pad_i10(1'b0),
  .dcd_pad_i10(1'b0)
);

uart_top10 i_oc_uart110 (
  .wb_clk_i10(pclk10),
  .wb_rst_i10(~n_preset10),
  .wb_adr_i10(paddr10[4:0]),
  .wb_dat_i10(pwdata10),
  .wb_dat_o10(prdata_uart110),
  .wb_we_i10(pwrite10),
  .wb_stb_i10(psel_uart110),
  .wb_cyc_i10(psel_uart110),
  .wb_ack_o10(pready_uart110),
  .wb_sel_i10(uart1_sel_i10),
  .int_o10(UART_int110),
  .stx_pad_o10(ua_txd110),
  .srx_pad_i10(ua_rxd110),
  .rts_pad_o10(ua_nrts1_int10),
  .cts_pad_i10(ua_ncts110),
  .dtr_pad_o10(),
  .dsr_pad_i10(1'b0),
  .ri_pad_i10(1'b0),
  .dcd_pad_i10(1'b0)
);

gpio_veneer10 i_gpio_veneer10 (
        //inputs10

        . n_p_reset10(n_preset10),
        . pclk10(pclk10),
        . psel10(psel_gpio10),
        . penable10(penable10),
        . pwrite10(pwrite10),
        . paddr10(paddr10[5:0]),
        . pwdata10(pwdata10),
        . gpio_pin_in10(gpio_pin_in10),
        . scan_en10(scan_en10),
        . tri_state_enable10(tri_state_enable10),
        . scan_in10(), //added by smarkov10 for dft10

        //outputs10
        . scan_out10(), //added by smarkov10 for dft10
        . prdata10(prdata_gpio10),
        . gpio_int10(GPIO_int10),
        . n_gpio_pin_oe10(n_gpio_pin_oe10),
        . gpio_pin_out10(gpio_pin_out10)
);


ttc_veneer10 i_ttc_veneer10 (

         //inputs10
        . n_p_reset10(n_preset10),
        . pclk10(pclk10),
        . psel10(psel_ttc10),
        . penable10(penable10),
        . pwrite10(pwrite10),
        . pwdata10(pwdata10),
        . paddr10(paddr10[7:0]),
        . scan_in10(),
        . scan_en10(scan_en10),

        //outputs10
        . prdata10(prdata_ttc10),
        . interrupt10(TTC_int10[3:1]),
        . scan_out10()
);


smc_veneer10 i_smc_veneer10 (
        //inputs10
	//apb10 inputs10
        . n_preset10(n_preset10),
        . pclk10(pclk_SRPG_smc10),
        . psel10(psel_smc10),
        . penable10(penable10),
        . pwrite10(pwrite10),
        . paddr10(paddr10[4:0]),
        . pwdata10(pwdata10),
        //ahb10 inputs10
	. hclk10(smc_hclk10),
        . n_sys_reset10(rstn_non_srpg_smc10),
        . haddr10(smc_haddr10),
        . htrans10(smc_htrans10),
        . hsel10(smc_hsel_int10),
        . hwrite10(smc_hwrite10),
	. hsize10(smc_hsize10),
        . hwdata10(smc_hwdata10),
        . hready10(smc_hready_in10),
        . data_smc10(data_smc10),

         //test signal10 inputs10

        . scan_in_110(),
        . scan_in_210(),
        . scan_in_310(),
        . scan_en10(scan_en10),

        //apb10 outputs10
        . prdata10(prdata_smc10),

       //design output

        . smc_hrdata10(smc_hrdata10),
        . smc_hready10(smc_hready10),
        . smc_hresp10(smc_hresp10),
        . smc_valid10(smc_valid10),
        . smc_addr10(smc_addr_int10),
        . smc_data10(smc_data10),
        . smc_n_be10(smc_n_be10),
        . smc_n_cs10(smc_n_cs10),
        . smc_n_wr10(smc_n_wr10),
        . smc_n_we10(smc_n_we10),
        . smc_n_rd10(smc_n_rd10),
        . smc_n_ext_oe10(smc_n_ext_oe10),
        . smc_busy10(smc_busy10),

         //test signal10 output
        . scan_out_110(),
        . scan_out_210(),
        . scan_out_310()
);

power_ctrl_veneer10 i_power_ctrl_veneer10 (
    // -- Clocks10 & Reset10
    	.pclk10(pclk10), 			//  : in  std_logic10;
    	.nprst10(n_preset10), 		//  : in  std_logic10;
    // -- APB10 programming10 interface
    	.paddr10(paddr10), 			//  : in  std_logic_vector10(31 downto10 0);
    	.psel10(psel_pmc10), 			//  : in  std_logic10;
    	.penable10(penable10), 		//  : in  std_logic10;
    	.pwrite10(pwrite10), 		//  : in  std_logic10;
    	.pwdata10(pwdata10), 		//  : in  std_logic_vector10(31 downto10 0);
    	.prdata10(prdata_pmc10), 		//  : out std_logic_vector10(31 downto10 0);
        .macb3_wakeup10(macb3_wakeup10),
        .macb2_wakeup10(macb2_wakeup10),
        .macb1_wakeup10(macb1_wakeup10),
        .macb0_wakeup10(macb0_wakeup10),
    // -- Module10 control10 outputs10
    	.scan_in10(),			//  : in  std_logic10;
    	.scan_en10(scan_en10),             	//  : in  std_logic10;
    	.scan_mode10(scan_mode10),          //  : in  std_logic10;
    	.scan_out10(),            	//  : out std_logic10;
        .int_source_h10(int_source_h10),
     	.rstn_non_srpg_smc10(rstn_non_srpg_smc10), 		//   : out std_logic10;
    	.gate_clk_smc10(gate_clk_smc10), 	//  : out std_logic10;
    	.isolate_smc10(isolate_smc10), 	//  : out std_logic10;
    	.save_edge_smc10(save_edge_smc10), 	//  : out std_logic10;
    	.restore_edge_smc10(restore_edge_smc10), 	//  : out std_logic10;
    	.pwr1_on_smc10(pwr1_on_smc10), 	//  : out std_logic10;
    	.pwr2_on_smc10(pwr2_on_smc10), 	//  : out std_logic10
     	.rstn_non_srpg_urt10(rstn_non_srpg_urt10), 		//   : out std_logic10;
    	.gate_clk_urt10(gate_clk_urt10), 	//  : out std_logic10;
    	.isolate_urt10(isolate_urt10), 	//  : out std_logic10;
    	.save_edge_urt10(save_edge_urt10), 	//  : out std_logic10;
    	.restore_edge_urt10(restore_edge_urt10), 	//  : out std_logic10;
    	.pwr1_on_urt10(pwr1_on_urt10), 	//  : out std_logic10;
    	.pwr2_on_urt10(pwr2_on_urt10),  	//  : out std_logic10
        // ETH010
        .rstn_non_srpg_macb010(rstn_non_srpg_macb010),
        .gate_clk_macb010(gate_clk_macb010),
        .isolate_macb010(isolate_macb010),
        .save_edge_macb010(save_edge_macb010),
        .restore_edge_macb010(restore_edge_macb010),
        .pwr1_on_macb010(pwr1_on_macb010),
        .pwr2_on_macb010(pwr2_on_macb010),
        // ETH110
        .rstn_non_srpg_macb110(rstn_non_srpg_macb110),
        .gate_clk_macb110(gate_clk_macb110),
        .isolate_macb110(isolate_macb110),
        .save_edge_macb110(save_edge_macb110),
        .restore_edge_macb110(restore_edge_macb110),
        .pwr1_on_macb110(pwr1_on_macb110),
        .pwr2_on_macb110(pwr2_on_macb110),
        // ETH210
        .rstn_non_srpg_macb210(rstn_non_srpg_macb210),
        .gate_clk_macb210(gate_clk_macb210),
        .isolate_macb210(isolate_macb210),
        .save_edge_macb210(save_edge_macb210),
        .restore_edge_macb210(restore_edge_macb210),
        .pwr1_on_macb210(pwr1_on_macb210),
        .pwr2_on_macb210(pwr2_on_macb210),
        // ETH310
        .rstn_non_srpg_macb310(rstn_non_srpg_macb310),
        .gate_clk_macb310(gate_clk_macb310),
        .isolate_macb310(isolate_macb310),
        .save_edge_macb310(save_edge_macb310),
        .restore_edge_macb310(restore_edge_macb310),
        .pwr1_on_macb310(pwr1_on_macb310),
        .pwr2_on_macb310(pwr2_on_macb310),
        .core06v10(core06v10),
        .core08v10(core08v10),
        .core10v10(core10v10),
        .core12v10(core12v10),
        .pcm_macb_wakeup_int10(pcm_macb_wakeup_int10),
        .isolate_mem10(isolate_mem10),
        .mte_smc_start10(mte_smc_start10),
        .mte_uart_start10(mte_uart_start10),
        .mte_smc_uart_start10(mte_smc_uart_start10),  
        .mte_pm_smc_to_default_start10(mte_pm_smc_to_default_start10), 
        .mte_pm_uart_to_default_start10(mte_pm_uart_to_default_start10),
        .mte_pm_smc_uart_to_default_start10(mte_pm_smc_uart_to_default_start10)
);

// Clock10 gating10 macro10 to shut10 off10 clocks10 to the SRPG10 flops10 in the SMC10
//CKLNQD110 i_SMC_SRPG_clk_gate10  (
//	.TE10(scan_mode10), 
//	.E10(~gate_clk_smc10), 
//	.CP10(pclk10), 
//	.Q10(pclk_SRPG_smc10)
//	);
// Replace10 gate10 with behavioural10 code10 //
wire 	smc_scan_gate10;
reg 	smc_latched_enable10;
assign smc_scan_gate10 = scan_mode10 ? 1'b1 : ~gate_clk_smc10;

always @ (pclk10 or smc_scan_gate10)
  	if (pclk10 == 1'b0) begin
  		smc_latched_enable10 <= smc_scan_gate10;
  	end  	
	
assign pclk_SRPG_smc10 = smc_latched_enable10 ? pclk10 : 1'b0;


// Clock10 gating10 macro10 to shut10 off10 clocks10 to the SRPG10 flops10 in the URT10
//CKLNQD110 i_URT_SRPG_clk_gate10  (
//	.TE10(scan_mode10), 
//	.E10(~gate_clk_urt10), 
//	.CP10(pclk10), 
//	.Q10(pclk_SRPG_urt10)
//	);
// Replace10 gate10 with behavioural10 code10 //
wire 	urt_scan_gate10;
reg 	urt_latched_enable10;
assign urt_scan_gate10 = scan_mode10 ? 1'b1 : ~gate_clk_urt10;

always @ (pclk10 or urt_scan_gate10)
  	if (pclk10 == 1'b0) begin
  		urt_latched_enable10 <= urt_scan_gate10;
  	end  	
	
assign pclk_SRPG_urt10 = urt_latched_enable10 ? pclk10 : 1'b0;

// ETH010
wire 	macb0_scan_gate10;
reg 	macb0_latched_enable10;
assign macb0_scan_gate10 = scan_mode10 ? 1'b1 : ~gate_clk_macb010;

always @ (pclk10 or macb0_scan_gate10)
  	if (pclk10 == 1'b0) begin
  		macb0_latched_enable10 <= macb0_scan_gate10;
  	end  	
	
assign clk_SRPG_macb0_en10 = macb0_latched_enable10 ? 1'b1 : 1'b0;

// ETH110
wire 	macb1_scan_gate10;
reg 	macb1_latched_enable10;
assign macb1_scan_gate10 = scan_mode10 ? 1'b1 : ~gate_clk_macb110;

always @ (pclk10 or macb1_scan_gate10)
  	if (pclk10 == 1'b0) begin
  		macb1_latched_enable10 <= macb1_scan_gate10;
  	end  	
	
assign clk_SRPG_macb1_en10 = macb1_latched_enable10 ? 1'b1 : 1'b0;

// ETH210
wire 	macb2_scan_gate10;
reg 	macb2_latched_enable10;
assign macb2_scan_gate10 = scan_mode10 ? 1'b1 : ~gate_clk_macb210;

always @ (pclk10 or macb2_scan_gate10)
  	if (pclk10 == 1'b0) begin
  		macb2_latched_enable10 <= macb2_scan_gate10;
  	end  	
	
assign clk_SRPG_macb2_en10 = macb2_latched_enable10 ? 1'b1 : 1'b0;

// ETH310
wire 	macb3_scan_gate10;
reg 	macb3_latched_enable10;
assign macb3_scan_gate10 = scan_mode10 ? 1'b1 : ~gate_clk_macb310;

always @ (pclk10 or macb3_scan_gate10)
  	if (pclk10 == 1'b0) begin
  		macb3_latched_enable10 <= macb3_scan_gate10;
  	end  	
	
assign clk_SRPG_macb3_en10 = macb3_latched_enable10 ? 1'b1 : 1'b0;



`else
//------------------------------------------------------------------------------
// if the APB10 subsystem10 is black10 boxed10 
//------------------------------------------------------------------------------
// wire s ports10
    // system signals10
    wire         hclk10;     // AHB10 Clock10
    wire         n_hreset10;  // AHB10 reset - Active10 low10
    wire         pclk10;     // APB10 Clock10. 
    wire         n_preset10;  // APB10 reset - Active10 low10

    // AHB10 interface
    wire         ahb2apb0_hsel10;     // AHB2APB10 select10
    wire  [31:0] haddr10;    // Address bus
    wire  [1:0]  htrans10;   // Transfer10 type
    wire  [2:0]  hsize10;    // AHB10 Access type - byte, half10-word10, word10
    wire  [31:0] hwdata10;   // Write data
    wire         hwrite10;   // Write signal10/
    wire         hready_in10;// Indicates10 that last master10 has finished10 bus access
    wire [2:0]   hburst10;     // Burst type
    wire [3:0]   hprot10;      // Protection10 control10
    wire [3:0]   hmaster10;    // Master10 select10
    wire         hmastlock10;  // Locked10 transfer10
  // Interrupts10 from the Enet10 MACs10
    wire         macb0_int10;
    wire         macb1_int10;
    wire         macb2_int10;
    wire         macb3_int10;
  // Interrupt10 from the DMA10
    wire         DMA_irq10;
  // Scan10 wire s
    wire         scan_en10;    // Scan10 enable pin10
    wire         scan_in_110;  // Scan10 wire  for first chain10
    wire         scan_in_210;  // Scan10 wire  for second chain10
    wire         scan_mode10;  // test mode pin10
 
  //wire  for smc10 AHB10 interface
    wire         smc_hclk10;
    wire         smc_n_hclk10;
    wire  [31:0] smc_haddr10;
    wire  [1:0]  smc_htrans10;
    wire         smc_hsel10;
    wire         smc_hwrite10;
    wire  [2:0]  smc_hsize10;
    wire  [31:0] smc_hwdata10;
    wire         smc_hready_in10;
    wire  [2:0]  smc_hburst10;     // Burst type
    wire  [3:0]  smc_hprot10;      // Protection10 control10
    wire  [3:0]  smc_hmaster10;    // Master10 select10
    wire         smc_hmastlock10;  // Locked10 transfer10


    wire  [31:0] data_smc10;     // EMI10(External10 memory) read data
    
  //wire s for uart10
    wire         ua_rxd10;       // UART10 receiver10 serial10 wire  pin10
    wire         ua_rxd110;      // UART10 receiver10 serial10 wire  pin10
    wire         ua_ncts10;      // Clear-To10-Send10 flow10 control10
    wire         ua_ncts110;      // Clear-To10-Send10 flow10 control10
   //wire s for spi10
    wire         n_ss_in10;      // select10 wire  to slave10
    wire         mi10;           // data wire  to master10
    wire         si10;           // data wire  to slave10
    wire         sclk_in10;      // clock10 wire  to slave10
  //wire s for GPIO10
   wire  [GPIO_WIDTH10-1:0]  gpio_pin_in10;             // wire  data from pin10

  //reg    ports10
  // Scan10 reg   s
   reg           scan_out_110;   // Scan10 out for chain10 1
   reg           scan_out_210;   // Scan10 out for chain10 2
  //AHB10 interface 
   reg    [31:0] hrdata10;       // Read data provided from target slave10
   reg           hready10;       // Ready10 for new bus cycle from target slave10
   reg    [1:0]  hresp10;       // Response10 from the bridge10

   // SMC10 reg    for AHB10 interface
   reg    [31:0]    smc_hrdata10;
   reg              smc_hready10;
   reg    [1:0]     smc_hresp10;

  //reg   s from smc10
   reg    [15:0]    smc_addr10;      // External10 Memory (EMI10) address
   reg    [3:0]     smc_n_be10;      // EMI10 byte enables10 (Active10 LOW10)
   reg    [7:0]     smc_n_cs10;      // EMI10 Chip10 Selects10 (Active10 LOW10)
   reg    [3:0]     smc_n_we10;      // EMI10 write strobes10 (Active10 LOW10)
   reg              smc_n_wr10;      // EMI10 write enable (Active10 LOW10)
   reg              smc_n_rd10;      // EMI10 read stobe10 (Active10 LOW10)
   reg              smc_n_ext_oe10;  // EMI10 write data reg    enable
   reg    [31:0]    smc_data10;      // EMI10 write data
  //reg   s from uart10
   reg           ua_txd10;       	// UART10 transmitter10 serial10 reg   
   reg           ua_txd110;       // UART10 transmitter10 serial10 reg   
   reg           ua_nrts10;      	// Request10-To10-Send10 flow10 control10
   reg           ua_nrts110;      // Request10-To10-Send10 flow10 control10
   // reg   s from ttc10
  // reg   s from SPI10
   reg       so;                    // data reg    from slave10
   reg       mo10;                    // data reg    from master10
   reg       sclk_out10;              // clock10 reg    from master10
   reg    [P_SIZE10-1:0] n_ss_out10;    // peripheral10 select10 lines10 from master10
   reg       n_so_en10;               // out enable for slave10 data
   reg       n_mo_en10;               // out enable for master10 data
   reg       n_sclk_en10;             // out enable for master10 clock10
   reg       n_ss_en10;               // out enable for master10 peripheral10 lines10
  //reg   s from gpio10
   reg    [GPIO_WIDTH10-1:0]     n_gpio_pin_oe10;           // reg    enable signal10 to pin10
   reg    [GPIO_WIDTH10-1:0]     gpio_pin_out10;            // reg    signal10 to pin10


`endif
//------------------------------------------------------------------------------
// black10 boxed10 defines10 
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// APB10 and AHB10 interface formal10 verification10 monitors10
//------------------------------------------------------------------------------
`ifdef ABV_ON10
apb_assert10 i_apb_assert10 (

        // APB10 signals10
  	.n_preset10(n_preset10),
   	.pclk10(pclk10),
	.penable10(penable10),
	.paddr10(paddr10),
	.pwrite10(pwrite10),
	.pwdata10(pwdata10),

	.psel0010(psel_spi10),
	.psel0110(psel_uart010),
	.psel0210(psel_gpio10),
	.psel0310(psel_ttc10),
	.psel0410(1'b0),
	.psel0510(psel_smc10),
	.psel0610(1'b0),
	.psel0710(1'b0),
	.psel0810(1'b0),
	.psel0910(1'b0),
	.psel1010(1'b0),
	.psel1110(1'b0),
	.psel1210(1'b0),
	.psel1310(psel_pmc10),
	.psel1410(psel_apic10),
	.psel1510(psel_uart110),

        .prdata0010(prdata_spi10),
        .prdata0110(prdata_uart010), // Read Data from peripheral10 UART10 
        .prdata0210(prdata_gpio10), // Read Data from peripheral10 GPIO10
        .prdata0310(prdata_ttc10), // Read Data from peripheral10 TTC10
        .prdata0410(32'b0), // 
        .prdata0510(prdata_smc10), // Read Data from peripheral10 SMC10
        .prdata1310(prdata_pmc10), // Read Data from peripheral10 Power10 Control10 Block
   	.prdata1410(32'b0), // 
        .prdata1510(prdata_uart110),


        // AHB10 signals10
        .hclk10(hclk10),         // ahb10 system clock10
        .n_hreset10(n_hreset10), // ahb10 system reset

        // ahb2apb10 signals10
        .hresp10(hresp10),
        .hready10(hready10),
        .hrdata10(hrdata10),
        .hwdata10(hwdata10),
        .hprot10(hprot10),
        .hburst10(hburst10),
        .hsize10(hsize10),
        .hwrite10(hwrite10),
        .htrans10(htrans10),
        .haddr10(haddr10),
        .ahb2apb_hsel10(ahb2apb0_hsel10));



//------------------------------------------------------------------------------
// AHB10 interface formal10 verification10 monitor10
//------------------------------------------------------------------------------
defparam i_ahbSlaveMonitor10.DBUS_WIDTH10 = 32;
defparam i_ahbMasterMonitor10.DBUS_WIDTH10 = 32;


// AHB2APB10 Bridge10

    ahb_liteslave_monitor10 i_ahbSlaveMonitor10 (
        .hclk_i10(hclk10),
        .hresetn_i10(n_hreset10),
        .hresp10(hresp10),
        .hready10(hready10),
        .hready_global_i10(hready10),
        .hrdata10(hrdata10),
        .hwdata_i10(hwdata10),
        .hburst_i10(hburst10),
        .hsize_i10(hsize10),
        .hwrite_i10(hwrite10),
        .htrans_i10(htrans10),
        .haddr_i10(haddr10),
        .hsel_i10(ahb2apb0_hsel10)
    );


  ahb_litemaster_monitor10 i_ahbMasterMonitor10 (
          .hclk_i10(hclk10),
          .hresetn_i10(n_hreset10),
          .hresp_i10(hresp10),
          .hready_i10(hready10),
          .hrdata_i10(hrdata10),
          .hlock10(1'b0),
          .hwdata10(hwdata10),
          .hprot10(hprot10),
          .hburst10(hburst10),
          .hsize10(hsize10),
          .hwrite10(hwrite10),
          .htrans10(htrans10),
          .haddr10(haddr10)
          );







`endif




`ifdef IFV_LP_ABV_ON10
// power10 control10
wire isolate10;

// testbench mirror signals10
wire L1_ctrl_access10;
wire L1_status_access10;

wire [31:0] L1_status_reg10;
wire [31:0] L1_ctrl_reg10;

//wire rstn_non_srpg_urt10;
//wire isolate_urt10;
//wire retain_urt10;
//wire gate_clk_urt10;
//wire pwr1_on_urt10;


// smc10 signals10
wire [31:0] smc_prdata10;
wire lp_clk_smc10;
                    

// uart10 isolation10 register
  wire [15:0] ua_prdata10;
  wire ua_int10;
  assign ua_prdata10          =  i_uart1_veneer10.prdata10;
  assign ua_int10             =  i_uart1_veneer10.ua_int10;


assign lp_clk_smc10          = i_smc_veneer10.pclk10;
assign smc_prdata10          = i_smc_veneer10.prdata10;
lp_chk_smc10 u_lp_chk_smc10 (
    .clk10 (hclk10),
    .rst10 (n_hreset10),
    .iso_smc10 (isolate_smc10),
    .gate_clk10 (gate_clk_smc10),
    .lp_clk10 (pclk_SRPG_smc10),

    // srpg10 outputs10
    .smc_hrdata10 (smc_hrdata10),
    .smc_hready10 (smc_hready10),
    .smc_hresp10  (smc_hresp10),
    .smc_valid10 (smc_valid10),
    .smc_addr_int10 (smc_addr_int10),
    .smc_data10 (smc_data10),
    .smc_n_be10 (smc_n_be10),
    .smc_n_cs10  (smc_n_cs10),
    .smc_n_wr10 (smc_n_wr10),
    .smc_n_we10 (smc_n_we10),
    .smc_n_rd10 (smc_n_rd10),
    .smc_n_ext_oe10 (smc_n_ext_oe10)
   );

// lp10 retention10/isolation10 assertions10
lp_chk_uart10 u_lp_chk_urt10 (

  .clk10         (hclk10),
  .rst10         (n_hreset10),
  .iso_urt10     (isolate_urt10),
  .gate_clk10    (gate_clk_urt10),
  .lp_clk10      (pclk_SRPG_urt10),
  //ports10
  .prdata10 (ua_prdata10),
  .ua_int10 (ua_int10),
  .ua_txd10 (ua_txd110),
  .ua_nrts10 (ua_nrts110)
 );

`endif  //IFV_LP_ABV_ON10




endmodule
