//File1 name   : apb_subsystem_01.v
//Title1       : 
//Created1     : 1999
//Description1 : 
//Notes1       : 
//----------------------------------------------------------------------
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------

module apb_subsystem_01(
    // AHB1 interface
    hclk1,
    n_hreset1,
    hsel1,
    haddr1,
    htrans1,
    hsize1,
    hwrite1,
    hwdata1,
    hready_in1,
    hburst1,
    hprot1,
    hmaster1,
    hmastlock1,
    hrdata1,
    hready1,
    hresp1,
    
    // APB1 system interface
    pclk1,
    n_preset1,
    
    // SPI1 ports1
    n_ss_in1,
    mi1,
    si1,
    sclk_in1,
    so,
    mo1,
    sclk_out1,
    n_ss_out1,
    n_so_en1,
    n_mo_en1,
    n_sclk_en1,
    n_ss_en1,
    
    //UART01 ports1
    ua_rxd1,
    ua_ncts1,
    ua_txd1,
    ua_nrts1,
    
    //UART11 ports1
    ua_rxd11,
    ua_ncts11,
    ua_txd11,
    ua_nrts11,
    
    //GPIO1 ports1
    gpio_pin_in1,
    n_gpio_pin_oe1,
    gpio_pin_out1,
    

    //SMC1 ports1
    smc_hclk1,
    smc_n_hclk1,
    smc_haddr1,
    smc_htrans1,
    smc_hsel1,
    smc_hwrite1,
    smc_hsize1,
    smc_hwdata1,
    smc_hready_in1,
    smc_hburst1,
    smc_hprot1,
    smc_hmaster1,
    smc_hmastlock1,
    smc_hrdata1, 
    smc_hready1,
    smc_hresp1,
    smc_n_ext_oe1,
    smc_data1,
    smc_addr1,
    smc_n_be1,
    smc_n_cs1, 
    smc_n_we1,
    smc_n_wr1,
    smc_n_rd1,
    data_smc1,
    
    //PMC1 ports1
    clk_SRPG_macb0_en1,
    clk_SRPG_macb1_en1,
    clk_SRPG_macb2_en1,
    clk_SRPG_macb3_en1,
    core06v1,
    core08v1,
    core10v1,
    core12v1,
    macb3_wakeup1,
    macb2_wakeup1,
    macb1_wakeup1,
    macb0_wakeup1,
    mte_smc_start1,
    mte_uart_start1,
    mte_smc_uart_start1,  
    mte_pm_smc_to_default_start1, 
    mte_pm_uart_to_default_start1,
    mte_pm_smc_uart_to_default_start1,
    
    
    // Peripheral1 inerrupts1
    pcm_irq1,
    ttc_irq1,
    gpio_irq1,
    uart0_irq1,
    uart1_irq1,
    spi_irq1,
    DMA_irq1,      
    macb0_int1,
    macb1_int1,
    macb2_int1,
    macb3_int1,
   
    // Scan1 ports1
    scan_en1,      // Scan1 enable pin1
    scan_in_11,    // Scan1 input for first chain1
    scan_in_21,    // Scan1 input for second chain1
    scan_mode1,
    scan_out_11,   // Scan1 out for chain1 1
    scan_out_21    // Scan1 out for chain1 2
);

parameter GPIO_WIDTH1 = 16;        // GPIO1 width
parameter P_SIZE1 =   8;              // number1 of peripheral1 select1 lines1
parameter NO_OF_IRQS1  = 17;      //No of irqs1 read by apic1 

// AHB1 interface
input         hclk1;     // AHB1 Clock1
input         n_hreset1;  // AHB1 reset - Active1 low1
input         hsel1;     // AHB2APB1 select1
input [31:0]  haddr1;    // Address bus
input [1:0]   htrans1;   // Transfer1 type
input [2:0]   hsize1;    // AHB1 Access type - byte, half1-word1, word1
input [31:0]  hwdata1;   // Write data
input         hwrite1;   // Write signal1/
input         hready_in1;// Indicates1 that last master1 has finished1 bus access
input [2:0]   hburst1;     // Burst type
input [3:0]   hprot1;      // Protection1 control1
input [3:0]   hmaster1;    // Master1 select1
input         hmastlock1;  // Locked1 transfer1
output [31:0] hrdata1;       // Read data provided from target slave1
output        hready1;       // Ready1 for new bus cycle from target slave1
output [1:0]  hresp1;       // Response1 from the bridge1
    
// APB1 system interface
input         pclk1;     // APB1 Clock1. 
input         n_preset1;  // APB1 reset - Active1 low1
   
// SPI1 ports1
input     n_ss_in1;      // select1 input to slave1
input     mi1;           // data input to master1
input     si1;           // data input to slave1
input     sclk_in1;      // clock1 input to slave1
output    so;                    // data output from slave1
output    mo1;                    // data output from master1
output    sclk_out1;              // clock1 output from master1
output [P_SIZE1-1:0] n_ss_out1;    // peripheral1 select1 lines1 from master1
output    n_so_en1;               // out enable for slave1 data
output    n_mo_en1;               // out enable for master1 data
output    n_sclk_en1;             // out enable for master1 clock1
output    n_ss_en1;               // out enable for master1 peripheral1 lines1

//UART01 ports1
input        ua_rxd1;       // UART1 receiver1 serial1 input pin1
input        ua_ncts1;      // Clear-To1-Send1 flow1 control1
output       ua_txd1;       	// UART1 transmitter1 serial1 output
output       ua_nrts1;      	// Request1-To1-Send1 flow1 control1

// UART11 ports1   
input        ua_rxd11;      // UART1 receiver1 serial1 input pin1
input        ua_ncts11;      // Clear-To1-Send1 flow1 control1
output       ua_txd11;       // UART1 transmitter1 serial1 output
output       ua_nrts11;      // Request1-To1-Send1 flow1 control1

//GPIO1 ports1
input [GPIO_WIDTH1-1:0]      gpio_pin_in1;             // input data from pin1
output [GPIO_WIDTH1-1:0]     n_gpio_pin_oe1;           // output enable signal1 to pin1
output [GPIO_WIDTH1-1:0]     gpio_pin_out1;            // output signal1 to pin1
  
//SMC1 ports1
input        smc_hclk1;
input        smc_n_hclk1;
input [31:0] smc_haddr1;
input [1:0]  smc_htrans1;
input        smc_hsel1;
input        smc_hwrite1;
input [2:0]  smc_hsize1;
input [31:0] smc_hwdata1;
input        smc_hready_in1;
input [2:0]  smc_hburst1;     // Burst type
input [3:0]  smc_hprot1;      // Protection1 control1
input [3:0]  smc_hmaster1;    // Master1 select1
input        smc_hmastlock1;  // Locked1 transfer1
input [31:0] data_smc1;     // EMI1(External1 memory) read data
output [31:0]    smc_hrdata1;
output           smc_hready1;
output [1:0]     smc_hresp1;
output [15:0]    smc_addr1;      // External1 Memory (EMI1) address
output [3:0]     smc_n_be1;      // EMI1 byte enables1 (Active1 LOW1)
output           smc_n_cs1;      // EMI1 Chip1 Selects1 (Active1 LOW1)
output [3:0]     smc_n_we1;      // EMI1 write strobes1 (Active1 LOW1)
output           smc_n_wr1;      // EMI1 write enable (Active1 LOW1)
output           smc_n_rd1;      // EMI1 read stobe1 (Active1 LOW1)
output           smc_n_ext_oe1;  // EMI1 write data output enable
output [31:0]    smc_data1;      // EMI1 write data
       
//PMC1 ports1
output clk_SRPG_macb0_en1;
output clk_SRPG_macb1_en1;
output clk_SRPG_macb2_en1;
output clk_SRPG_macb3_en1;
output core06v1;
output core08v1;
output core10v1;
output core12v1;
output mte_smc_start1;
output mte_uart_start1;
output mte_smc_uart_start1;  
output mte_pm_smc_to_default_start1; 
output mte_pm_uart_to_default_start1;
output mte_pm_smc_uart_to_default_start1;
input macb3_wakeup1;
input macb2_wakeup1;
input macb1_wakeup1;
input macb0_wakeup1;
    

// Peripheral1 interrupts1
output pcm_irq1;
output [2:0] ttc_irq1;
output gpio_irq1;
output uart0_irq1;
output uart1_irq1;
output spi_irq1;
input        macb0_int1;
input        macb1_int1;
input        macb2_int1;
input        macb3_int1;
input        DMA_irq1;
  
//Scan1 ports1
input        scan_en1;    // Scan1 enable pin1
input        scan_in_11;  // Scan1 input for first chain1
input        scan_in_21;  // Scan1 input for second chain1
input        scan_mode1;  // test mode pin1
 output        scan_out_11;   // Scan1 out for chain1 1
 output        scan_out_21;   // Scan1 out for chain1 2  

//------------------------------------------------------------------------------
// if the ROM1 subsystem1 is NOT1 black1 boxed1 
//------------------------------------------------------------------------------
`ifndef FV_KIT_BLACK_BOX_APB_SUBSYSTEM1
   
   wire        hsel1; 
   wire        pclk1;
   wire        n_preset1;
   wire [31:0] prdata_spi1;
   wire [31:0] prdata_uart01;
   wire [31:0] prdata_gpio1;
   wire [31:0] prdata_ttc1;
   wire [31:0] prdata_smc1;
   wire [31:0] prdata_pmc1;
   wire [31:0] prdata_uart11;
   wire        pready_spi1;
   wire        pready_uart01;
   wire        pready_uart11;
   wire        tie_hi_bit1;
   wire  [31:0] hrdata1; 
   wire         hready1;
   wire         hready_in1;
   wire  [1:0]  hresp1;   
   wire  [31:0] pwdata1;  
   wire         pwrite1;
   wire  [31:0] paddr1;  
   wire   psel_spi1;
   wire   psel_uart01;
   wire   psel_gpio1;
   wire   psel_ttc1;
   wire   psel_smc1;
   wire   psel071;
   wire   psel081;
   wire   psel091;
   wire   psel101;
   wire   psel111;
   wire   psel121;
   wire   psel_pmc1;
   wire   psel_uart11;
   wire   penable1;
   wire   [NO_OF_IRQS1:0] int_source1;     // System1 Interrupt1 Sources1
   wire [1:0]             smc_hresp1;     // AHB1 Response1 signal1
   wire                   smc_valid1;     // Ack1 valid address

  //External1 memory interface (EMI1)
  wire [31:0]            smc_addr_int1;  // External1 Memory (EMI1) address
  wire [3:0]             smc_n_be1;      // EMI1 byte enables1 (Active1 LOW1)
  wire                   smc_n_cs1;      // EMI1 Chip1 Selects1 (Active1 LOW1)
  wire [3:0]             smc_n_we1;      // EMI1 write strobes1 (Active1 LOW1)
  wire                   smc_n_wr1;      // EMI1 write enable (Active1 LOW1)
  wire                   smc_n_rd1;      // EMI1 read stobe1 (Active1 LOW1)
 
  //AHB1 Memory Interface1 Control1
  wire                   smc_hsel_int1;
  wire                   smc_busy1;      // smc1 busy
   

//scan1 signals1

   wire                scan_in_11;        //scan1 input
   wire                scan_in_21;        //scan1 input
   wire                scan_en1;         //scan1 enable
   wire                scan_out_11;       //scan1 output
   wire                scan_out_21;       //scan1 output
   wire                byte_sel1;     // byte select1 from bridge1 1=byte, 0=2byte
   wire                UART_int1;     // UART1 module interrupt1 
   wire                ua_uclken1;    // Soft1 control1 of clock1
   wire                UART_int11;     // UART1 module interrupt1 
   wire                ua_uclken11;    // Soft1 control1 of clock1
   wire  [3:1]         TTC_int1;            //Interrupt1 from PCI1 
  // inputs1 to SPI1 
   wire    ext_clk1;                // external1 clock1
   wire    SPI_int1;             // interrupt1 request
  // outputs1 from SPI1
   wire    slave_out_clk1;         // modified slave1 clock1 output
 // gpio1 generic1 inputs1 
   wire  [GPIO_WIDTH1-1:0]   n_gpio_bypass_oe1;        // bypass1 mode enable 
   wire  [GPIO_WIDTH1-1:0]   gpio_bypass_out1;         // bypass1 mode output value 
   wire  [GPIO_WIDTH1-1:0]   tri_state_enable1;   // disables1 op enable -> z 
 // outputs1 
   //amba1 outputs1 
   // gpio1 generic1 outputs1 
   wire       GPIO_int1;                // gpio_interupt1 for input pin1 change 
   wire [GPIO_WIDTH1-1:0]     gpio_bypass_in1;          // bypass1 mode input data value  
                
   wire           cpu_debug1;        // Inhibits1 watchdog1 counter 
   wire            ex_wdz_n1;         // External1 Watchdog1 zero indication1
   wire           rstn_non_srpg_smc1; 
   wire           rstn_non_srpg_urt1;
   wire           isolate_smc1;
   wire           save_edge_smc1;
   wire           restore_edge_smc1;
   wire           save_edge_urt1;
   wire           restore_edge_urt1;
   wire           pwr1_on_smc1;
   wire           pwr2_on_smc1;
   wire           pwr1_on_urt1;
   wire           pwr2_on_urt1;
   // ETH01
   wire            rstn_non_srpg_macb01;
   wire            gate_clk_macb01;
   wire            isolate_macb01;
   wire            save_edge_macb01;
   wire            restore_edge_macb01;
   wire            pwr1_on_macb01;
   wire            pwr2_on_macb01;
   // ETH11
   wire            rstn_non_srpg_macb11;
   wire            gate_clk_macb11;
   wire            isolate_macb11;
   wire            save_edge_macb11;
   wire            restore_edge_macb11;
   wire            pwr1_on_macb11;
   wire            pwr2_on_macb11;
   // ETH21
   wire            rstn_non_srpg_macb21;
   wire            gate_clk_macb21;
   wire            isolate_macb21;
   wire            save_edge_macb21;
   wire            restore_edge_macb21;
   wire            pwr1_on_macb21;
   wire            pwr2_on_macb21;
   // ETH31
   wire            rstn_non_srpg_macb31;
   wire            gate_clk_macb31;
   wire            isolate_macb31;
   wire            save_edge_macb31;
   wire            restore_edge_macb31;
   wire            pwr1_on_macb31;
   wire            pwr2_on_macb31;


   wire           pclk_SRPG_smc1;
   wire           pclk_SRPG_urt1;
   wire           gate_clk_smc1;
   wire           gate_clk_urt1;
   wire  [31:0]   tie_lo_32bit1; 
   wire  [1:0]	  tie_lo_2bit1;
   wire  	  tie_lo_1bit1;
   wire           pcm_macb_wakeup_int1;
   wire           int_source_h1;
   wire           isolate_mem1;

assign pcm_irq1 = pcm_macb_wakeup_int1;
assign ttc_irq1[2] = TTC_int1[3];
assign ttc_irq1[1] = TTC_int1[2];
assign ttc_irq1[0] = TTC_int1[1];
assign gpio_irq1 = GPIO_int1;
assign uart0_irq1 = UART_int1;
assign uart1_irq1 = UART_int11;
assign spi_irq1 = SPI_int1;

assign n_mo_en1   = 1'b0;
assign n_so_en1   = 1'b1;
assign n_sclk_en1 = 1'b0;
assign n_ss_en1   = 1'b0;

assign smc_hsel_int1 = smc_hsel1;
  assign ext_clk1  = 1'b0;
  assign int_source1 = {macb0_int1,macb1_int1, macb2_int1, macb3_int1,1'b0, pcm_macb_wakeup_int1, 1'b0, 1'b0, 1'b0, 1'b0, TTC_int1, GPIO_int1, UART_int1, UART_int11, SPI_int1, DMA_irq1};

  // interrupt1 even1 detect1 .
  // for sleep1 wake1 up -> any interrupt1 even1 and system not in hibernation1 (isolate_mem1 = 0)
  // for hibernate1 wake1 up -> gpio1 interrupt1 even1 and system in the hibernation1 (isolate_mem1 = 1)
  assign int_source_h1 =  ((|int_source1) && (!isolate_mem1)) || (isolate_mem1 && GPIO_int1) ;

  assign byte_sel1 = 1'b1;
  assign tie_hi_bit1 = 1'b1;

  assign smc_addr1 = smc_addr_int1[15:0];



  assign  n_gpio_bypass_oe1 = {GPIO_WIDTH1{1'b0}};        // bypass1 mode enable 
  assign  gpio_bypass_out1  = {GPIO_WIDTH1{1'b0}};
  assign  tri_state_enable1 = {GPIO_WIDTH1{1'b0}};
  assign  cpu_debug1 = 1'b0;
  assign  tie_lo_32bit1 = 32'b0;
  assign  tie_lo_2bit1  = 2'b0;
  assign  tie_lo_1bit1  = 1'b0;


ahb2apb1 #(
  32'h00800000, // Slave1 0 Address Range1
  32'h0080FFFF,

  32'h00810000, // Slave1 1 Address Range1
  32'h0081FFFF,

  32'h00820000, // Slave1 2 Address Range1 
  32'h0082FFFF,

  32'h00830000, // Slave1 3 Address Range1
  32'h0083FFFF,

  32'h00840000, // Slave1 4 Address Range1
  32'h0084FFFF,

  32'h00850000, // Slave1 5 Address Range1
  32'h0085FFFF,

  32'h00860000, // Slave1 6 Address Range1
  32'h0086FFFF,

  32'h00870000, // Slave1 7 Address Range1
  32'h0087FFFF,

  32'h00880000, // Slave1 8 Address Range1
  32'h0088FFFF
) i_ahb2apb1 (
     // AHB1 interface
    .hclk1(hclk1),         
    .hreset_n1(n_hreset1), 
    .hsel1(hsel1), 
    .haddr1(haddr1),        
    .htrans1(htrans1),       
    .hwrite1(hwrite1),       
    .hwdata1(hwdata1),       
    .hrdata1(hrdata1),   
    .hready1(hready1),   
    .hresp1(hresp1),     
    
     // APB1 interface
    .pclk1(pclk1),         
    .preset_n1(n_preset1),  
    .prdata01(prdata_spi1),
    .prdata11(prdata_uart01), 
    .prdata21(prdata_gpio1),  
    .prdata31(prdata_ttc1),   
    .prdata41(32'h0),   
    .prdata51(prdata_smc1),   
    .prdata61(prdata_pmc1),    
    .prdata71(32'h0),   
    .prdata81(prdata_uart11),  
    .pready01(pready_spi1),     
    .pready11(pready_uart01),   
    .pready21(tie_hi_bit1),     
    .pready31(tie_hi_bit1),     
    .pready41(tie_hi_bit1),     
    .pready51(tie_hi_bit1),     
    .pready61(tie_hi_bit1),     
    .pready71(tie_hi_bit1),     
    .pready81(pready_uart11),  
    .pwdata1(pwdata1),       
    .pwrite1(pwrite1),       
    .paddr1(paddr1),        
    .psel01(psel_spi1),     
    .psel11(psel_uart01),   
    .psel21(psel_gpio1),    
    .psel31(psel_ttc1),     
    .psel41(),     
    .psel51(psel_smc1),     
    .psel61(psel_pmc1),    
    .psel71(psel_apic1),   
    .psel81(psel_uart11),  
    .penable1(penable1)     
);

spi_top1 i_spi1
(
  // Wishbone1 signals1
  .wb_clk_i1(pclk1), 
  .wb_rst_i1(~n_preset1), 
  .wb_adr_i1(paddr1[4:0]), 
  .wb_dat_i1(pwdata1), 
  .wb_dat_o1(prdata_spi1), 
  .wb_sel_i1(4'b1111),    // SPI1 register accesses are always 32-bit
  .wb_we_i1(pwrite1), 
  .wb_stb_i1(psel_spi1), 
  .wb_cyc_i1(psel_spi1), 
  .wb_ack_o1(pready_spi1), 
  .wb_err_o1(), 
  .wb_int_o1(SPI_int1),

  // SPI1 signals1
  .ss_pad_o1(n_ss_out1), 
  .sclk_pad_o1(sclk_out1), 
  .mosi_pad_o1(mo1), 
  .miso_pad_i1(mi1)
);

// Opencores1 UART1 instances1
wire ua_nrts_int1;
wire ua_nrts1_int1;

assign ua_nrts1 = ua_nrts_int1;
assign ua_nrts11 = ua_nrts1_int1;

reg [3:0] uart0_sel_i1;
reg [3:0] uart1_sel_i1;
// UART1 registers are all 8-bit wide1, and their1 addresses1
// are on byte boundaries1. So1 to access them1 on the
// Wishbone1 bus, the CPU1 must do byte accesses to these1
// byte addresses1. Word1 address accesses are not possible1
// because the word1 addresses1 will be unaligned1, and cause
// a fault1.
// So1, Uart1 accesses from the CPU1 will always be 8-bit size
// We1 only have to decide1 which byte of the 4-byte word1 the
// CPU1 is interested1 in.
`ifdef SYSTEM_BIG_ENDIAN1
always @(paddr1) begin
  case (paddr1[1:0])
    2'b00 : uart0_sel_i1 = 4'b1000;
    2'b01 : uart0_sel_i1 = 4'b0100;
    2'b10 : uart0_sel_i1 = 4'b0010;
    2'b11 : uart0_sel_i1 = 4'b0001;
  endcase
end
always @(paddr1) begin
  case (paddr1[1:0])
    2'b00 : uart1_sel_i1 = 4'b1000;
    2'b01 : uart1_sel_i1 = 4'b0100;
    2'b10 : uart1_sel_i1 = 4'b0010;
    2'b11 : uart1_sel_i1 = 4'b0001;
  endcase
end
`else
always @(paddr1) begin
  case (paddr1[1:0])
    2'b00 : uart0_sel_i1 = 4'b0001;
    2'b01 : uart0_sel_i1 = 4'b0010;
    2'b10 : uart0_sel_i1 = 4'b0100;
    2'b11 : uart0_sel_i1 = 4'b1000;
  endcase
end
always @(paddr1) begin
  case (paddr1[1:0])
    2'b00 : uart1_sel_i1 = 4'b0001;
    2'b01 : uart1_sel_i1 = 4'b0010;
    2'b10 : uart1_sel_i1 = 4'b0100;
    2'b11 : uart1_sel_i1 = 4'b1000;
  endcase
end
`endif

uart_top1 i_oc_uart01 (
  .wb_clk_i1(pclk1),
  .wb_rst_i1(~n_preset1),
  .wb_adr_i1(paddr1[4:0]),
  .wb_dat_i1(pwdata1),
  .wb_dat_o1(prdata_uart01),
  .wb_we_i1(pwrite1),
  .wb_stb_i1(psel_uart01),
  .wb_cyc_i1(psel_uart01),
  .wb_ack_o1(pready_uart01),
  .wb_sel_i1(uart0_sel_i1),
  .int_o1(UART_int1),
  .stx_pad_o1(ua_txd1),
  .srx_pad_i1(ua_rxd1),
  .rts_pad_o1(ua_nrts_int1),
  .cts_pad_i1(ua_ncts1),
  .dtr_pad_o1(),
  .dsr_pad_i1(1'b0),
  .ri_pad_i1(1'b0),
  .dcd_pad_i1(1'b0)
);

uart_top1 i_oc_uart11 (
  .wb_clk_i1(pclk1),
  .wb_rst_i1(~n_preset1),
  .wb_adr_i1(paddr1[4:0]),
  .wb_dat_i1(pwdata1),
  .wb_dat_o1(prdata_uart11),
  .wb_we_i1(pwrite1),
  .wb_stb_i1(psel_uart11),
  .wb_cyc_i1(psel_uart11),
  .wb_ack_o1(pready_uart11),
  .wb_sel_i1(uart1_sel_i1),
  .int_o1(UART_int11),
  .stx_pad_o1(ua_txd11),
  .srx_pad_i1(ua_rxd11),
  .rts_pad_o1(ua_nrts1_int1),
  .cts_pad_i1(ua_ncts11),
  .dtr_pad_o1(),
  .dsr_pad_i1(1'b0),
  .ri_pad_i1(1'b0),
  .dcd_pad_i1(1'b0)
);

gpio_veneer1 i_gpio_veneer1 (
        //inputs1

        . n_p_reset1(n_preset1),
        . pclk1(pclk1),
        . psel1(psel_gpio1),
        . penable1(penable1),
        . pwrite1(pwrite1),
        . paddr1(paddr1[5:0]),
        . pwdata1(pwdata1),
        . gpio_pin_in1(gpio_pin_in1),
        . scan_en1(scan_en1),
        . tri_state_enable1(tri_state_enable1),
        . scan_in1(), //added by smarkov1 for dft1

        //outputs1
        . scan_out1(), //added by smarkov1 for dft1
        . prdata1(prdata_gpio1),
        . gpio_int1(GPIO_int1),
        . n_gpio_pin_oe1(n_gpio_pin_oe1),
        . gpio_pin_out1(gpio_pin_out1)
);


ttc_veneer1 i_ttc_veneer1 (

         //inputs1
        . n_p_reset1(n_preset1),
        . pclk1(pclk1),
        . psel1(psel_ttc1),
        . penable1(penable1),
        . pwrite1(pwrite1),
        . pwdata1(pwdata1),
        . paddr1(paddr1[7:0]),
        . scan_in1(),
        . scan_en1(scan_en1),

        //outputs1
        . prdata1(prdata_ttc1),
        . interrupt1(TTC_int1[3:1]),
        . scan_out1()
);


smc_veneer1 i_smc_veneer1 (
        //inputs1
	//apb1 inputs1
        . n_preset1(n_preset1),
        . pclk1(pclk_SRPG_smc1),
        . psel1(psel_smc1),
        . penable1(penable1),
        . pwrite1(pwrite1),
        . paddr1(paddr1[4:0]),
        . pwdata1(pwdata1),
        //ahb1 inputs1
	. hclk1(smc_hclk1),
        . n_sys_reset1(rstn_non_srpg_smc1),
        . haddr1(smc_haddr1),
        . htrans1(smc_htrans1),
        . hsel1(smc_hsel_int1),
        . hwrite1(smc_hwrite1),
	. hsize1(smc_hsize1),
        . hwdata1(smc_hwdata1),
        . hready1(smc_hready_in1),
        . data_smc1(data_smc1),

         //test signal1 inputs1

        . scan_in_11(),
        . scan_in_21(),
        . scan_in_31(),
        . scan_en1(scan_en1),

        //apb1 outputs1
        . prdata1(prdata_smc1),

       //design output

        . smc_hrdata1(smc_hrdata1),
        . smc_hready1(smc_hready1),
        . smc_hresp1(smc_hresp1),
        . smc_valid1(smc_valid1),
        . smc_addr1(smc_addr_int1),
        . smc_data1(smc_data1),
        . smc_n_be1(smc_n_be1),
        . smc_n_cs1(smc_n_cs1),
        . smc_n_wr1(smc_n_wr1),
        . smc_n_we1(smc_n_we1),
        . smc_n_rd1(smc_n_rd1),
        . smc_n_ext_oe1(smc_n_ext_oe1),
        . smc_busy1(smc_busy1),

         //test signal1 output
        . scan_out_11(),
        . scan_out_21(),
        . scan_out_31()
);

power_ctrl_veneer1 i_power_ctrl_veneer1 (
    // -- Clocks1 & Reset1
    	.pclk1(pclk1), 			//  : in  std_logic1;
    	.nprst1(n_preset1), 		//  : in  std_logic1;
    // -- APB1 programming1 interface
    	.paddr1(paddr1), 			//  : in  std_logic_vector1(31 downto1 0);
    	.psel1(psel_pmc1), 			//  : in  std_logic1;
    	.penable1(penable1), 		//  : in  std_logic1;
    	.pwrite1(pwrite1), 		//  : in  std_logic1;
    	.pwdata1(pwdata1), 		//  : in  std_logic_vector1(31 downto1 0);
    	.prdata1(prdata_pmc1), 		//  : out std_logic_vector1(31 downto1 0);
        .macb3_wakeup1(macb3_wakeup1),
        .macb2_wakeup1(macb2_wakeup1),
        .macb1_wakeup1(macb1_wakeup1),
        .macb0_wakeup1(macb0_wakeup1),
    // -- Module1 control1 outputs1
    	.scan_in1(),			//  : in  std_logic1;
    	.scan_en1(scan_en1),             	//  : in  std_logic1;
    	.scan_mode1(scan_mode1),          //  : in  std_logic1;
    	.scan_out1(),            	//  : out std_logic1;
        .int_source_h1(int_source_h1),
     	.rstn_non_srpg_smc1(rstn_non_srpg_smc1), 		//   : out std_logic1;
    	.gate_clk_smc1(gate_clk_smc1), 	//  : out std_logic1;
    	.isolate_smc1(isolate_smc1), 	//  : out std_logic1;
    	.save_edge_smc1(save_edge_smc1), 	//  : out std_logic1;
    	.restore_edge_smc1(restore_edge_smc1), 	//  : out std_logic1;
    	.pwr1_on_smc1(pwr1_on_smc1), 	//  : out std_logic1;
    	.pwr2_on_smc1(pwr2_on_smc1), 	//  : out std_logic1
     	.rstn_non_srpg_urt1(rstn_non_srpg_urt1), 		//   : out std_logic1;
    	.gate_clk_urt1(gate_clk_urt1), 	//  : out std_logic1;
    	.isolate_urt1(isolate_urt1), 	//  : out std_logic1;
    	.save_edge_urt1(save_edge_urt1), 	//  : out std_logic1;
    	.restore_edge_urt1(restore_edge_urt1), 	//  : out std_logic1;
    	.pwr1_on_urt1(pwr1_on_urt1), 	//  : out std_logic1;
    	.pwr2_on_urt1(pwr2_on_urt1),  	//  : out std_logic1
        // ETH01
        .rstn_non_srpg_macb01(rstn_non_srpg_macb01),
        .gate_clk_macb01(gate_clk_macb01),
        .isolate_macb01(isolate_macb01),
        .save_edge_macb01(save_edge_macb01),
        .restore_edge_macb01(restore_edge_macb01),
        .pwr1_on_macb01(pwr1_on_macb01),
        .pwr2_on_macb01(pwr2_on_macb01),
        // ETH11
        .rstn_non_srpg_macb11(rstn_non_srpg_macb11),
        .gate_clk_macb11(gate_clk_macb11),
        .isolate_macb11(isolate_macb11),
        .save_edge_macb11(save_edge_macb11),
        .restore_edge_macb11(restore_edge_macb11),
        .pwr1_on_macb11(pwr1_on_macb11),
        .pwr2_on_macb11(pwr2_on_macb11),
        // ETH21
        .rstn_non_srpg_macb21(rstn_non_srpg_macb21),
        .gate_clk_macb21(gate_clk_macb21),
        .isolate_macb21(isolate_macb21),
        .save_edge_macb21(save_edge_macb21),
        .restore_edge_macb21(restore_edge_macb21),
        .pwr1_on_macb21(pwr1_on_macb21),
        .pwr2_on_macb21(pwr2_on_macb21),
        // ETH31
        .rstn_non_srpg_macb31(rstn_non_srpg_macb31),
        .gate_clk_macb31(gate_clk_macb31),
        .isolate_macb31(isolate_macb31),
        .save_edge_macb31(save_edge_macb31),
        .restore_edge_macb31(restore_edge_macb31),
        .pwr1_on_macb31(pwr1_on_macb31),
        .pwr2_on_macb31(pwr2_on_macb31),
        .core06v1(core06v1),
        .core08v1(core08v1),
        .core10v1(core10v1),
        .core12v1(core12v1),
        .pcm_macb_wakeup_int1(pcm_macb_wakeup_int1),
        .isolate_mem1(isolate_mem1),
        .mte_smc_start1(mte_smc_start1),
        .mte_uart_start1(mte_uart_start1),
        .mte_smc_uart_start1(mte_smc_uart_start1),  
        .mte_pm_smc_to_default_start1(mte_pm_smc_to_default_start1), 
        .mte_pm_uart_to_default_start1(mte_pm_uart_to_default_start1),
        .mte_pm_smc_uart_to_default_start1(mte_pm_smc_uart_to_default_start1)
);

// Clock1 gating1 macro1 to shut1 off1 clocks1 to the SRPG1 flops1 in the SMC1
//CKLNQD11 i_SMC_SRPG_clk_gate1  (
//	.TE1(scan_mode1), 
//	.E1(~gate_clk_smc1), 
//	.CP1(pclk1), 
//	.Q1(pclk_SRPG_smc1)
//	);
// Replace1 gate1 with behavioural1 code1 //
wire 	smc_scan_gate1;
reg 	smc_latched_enable1;
assign smc_scan_gate1 = scan_mode1 ? 1'b1 : ~gate_clk_smc1;

always @ (pclk1 or smc_scan_gate1)
  	if (pclk1 == 1'b0) begin
  		smc_latched_enable1 <= smc_scan_gate1;
  	end  	
	
assign pclk_SRPG_smc1 = smc_latched_enable1 ? pclk1 : 1'b0;


// Clock1 gating1 macro1 to shut1 off1 clocks1 to the SRPG1 flops1 in the URT1
//CKLNQD11 i_URT_SRPG_clk_gate1  (
//	.TE1(scan_mode1), 
//	.E1(~gate_clk_urt1), 
//	.CP1(pclk1), 
//	.Q1(pclk_SRPG_urt1)
//	);
// Replace1 gate1 with behavioural1 code1 //
wire 	urt_scan_gate1;
reg 	urt_latched_enable1;
assign urt_scan_gate1 = scan_mode1 ? 1'b1 : ~gate_clk_urt1;

always @ (pclk1 or urt_scan_gate1)
  	if (pclk1 == 1'b0) begin
  		urt_latched_enable1 <= urt_scan_gate1;
  	end  	
	
assign pclk_SRPG_urt1 = urt_latched_enable1 ? pclk1 : 1'b0;

// ETH01
wire 	macb0_scan_gate1;
reg 	macb0_latched_enable1;
assign macb0_scan_gate1 = scan_mode1 ? 1'b1 : ~gate_clk_macb01;

always @ (pclk1 or macb0_scan_gate1)
  	if (pclk1 == 1'b0) begin
  		macb0_latched_enable1 <= macb0_scan_gate1;
  	end  	
	
assign clk_SRPG_macb0_en1 = macb0_latched_enable1 ? 1'b1 : 1'b0;

// ETH11
wire 	macb1_scan_gate1;
reg 	macb1_latched_enable1;
assign macb1_scan_gate1 = scan_mode1 ? 1'b1 : ~gate_clk_macb11;

always @ (pclk1 or macb1_scan_gate1)
  	if (pclk1 == 1'b0) begin
  		macb1_latched_enable1 <= macb1_scan_gate1;
  	end  	
	
assign clk_SRPG_macb1_en1 = macb1_latched_enable1 ? 1'b1 : 1'b0;

// ETH21
wire 	macb2_scan_gate1;
reg 	macb2_latched_enable1;
assign macb2_scan_gate1 = scan_mode1 ? 1'b1 : ~gate_clk_macb21;

always @ (pclk1 or macb2_scan_gate1)
  	if (pclk1 == 1'b0) begin
  		macb2_latched_enable1 <= macb2_scan_gate1;
  	end  	
	
assign clk_SRPG_macb2_en1 = macb2_latched_enable1 ? 1'b1 : 1'b0;

// ETH31
wire 	macb3_scan_gate1;
reg 	macb3_latched_enable1;
assign macb3_scan_gate1 = scan_mode1 ? 1'b1 : ~gate_clk_macb31;

always @ (pclk1 or macb3_scan_gate1)
  	if (pclk1 == 1'b0) begin
  		macb3_latched_enable1 <= macb3_scan_gate1;
  	end  	
	
assign clk_SRPG_macb3_en1 = macb3_latched_enable1 ? 1'b1 : 1'b0;



`else
//------------------------------------------------------------------------------
// if the APB1 subsystem1 is black1 boxed1 
//------------------------------------------------------------------------------
// wire s ports1
    // system signals1
    wire         hclk1;     // AHB1 Clock1
    wire         n_hreset1;  // AHB1 reset - Active1 low1
    wire         pclk1;     // APB1 Clock1. 
    wire         n_preset1;  // APB1 reset - Active1 low1

    // AHB1 interface
    wire         ahb2apb0_hsel1;     // AHB2APB1 select1
    wire  [31:0] haddr1;    // Address bus
    wire  [1:0]  htrans1;   // Transfer1 type
    wire  [2:0]  hsize1;    // AHB1 Access type - byte, half1-word1, word1
    wire  [31:0] hwdata1;   // Write data
    wire         hwrite1;   // Write signal1/
    wire         hready_in1;// Indicates1 that last master1 has finished1 bus access
    wire [2:0]   hburst1;     // Burst type
    wire [3:0]   hprot1;      // Protection1 control1
    wire [3:0]   hmaster1;    // Master1 select1
    wire         hmastlock1;  // Locked1 transfer1
  // Interrupts1 from the Enet1 MACs1
    wire         macb0_int1;
    wire         macb1_int1;
    wire         macb2_int1;
    wire         macb3_int1;
  // Interrupt1 from the DMA1
    wire         DMA_irq1;
  // Scan1 wire s
    wire         scan_en1;    // Scan1 enable pin1
    wire         scan_in_11;  // Scan1 wire  for first chain1
    wire         scan_in_21;  // Scan1 wire  for second chain1
    wire         scan_mode1;  // test mode pin1
 
  //wire  for smc1 AHB1 interface
    wire         smc_hclk1;
    wire         smc_n_hclk1;
    wire  [31:0] smc_haddr1;
    wire  [1:0]  smc_htrans1;
    wire         smc_hsel1;
    wire         smc_hwrite1;
    wire  [2:0]  smc_hsize1;
    wire  [31:0] smc_hwdata1;
    wire         smc_hready_in1;
    wire  [2:0]  smc_hburst1;     // Burst type
    wire  [3:0]  smc_hprot1;      // Protection1 control1
    wire  [3:0]  smc_hmaster1;    // Master1 select1
    wire         smc_hmastlock1;  // Locked1 transfer1


    wire  [31:0] data_smc1;     // EMI1(External1 memory) read data
    
  //wire s for uart1
    wire         ua_rxd1;       // UART1 receiver1 serial1 wire  pin1
    wire         ua_rxd11;      // UART1 receiver1 serial1 wire  pin1
    wire         ua_ncts1;      // Clear-To1-Send1 flow1 control1
    wire         ua_ncts11;      // Clear-To1-Send1 flow1 control1
   //wire s for spi1
    wire         n_ss_in1;      // select1 wire  to slave1
    wire         mi1;           // data wire  to master1
    wire         si1;           // data wire  to slave1
    wire         sclk_in1;      // clock1 wire  to slave1
  //wire s for GPIO1
   wire  [GPIO_WIDTH1-1:0]  gpio_pin_in1;             // wire  data from pin1

  //reg    ports1
  // Scan1 reg   s
   reg           scan_out_11;   // Scan1 out for chain1 1
   reg           scan_out_21;   // Scan1 out for chain1 2
  //AHB1 interface 
   reg    [31:0] hrdata1;       // Read data provided from target slave1
   reg           hready1;       // Ready1 for new bus cycle from target slave1
   reg    [1:0]  hresp1;       // Response1 from the bridge1

   // SMC1 reg    for AHB1 interface
   reg    [31:0]    smc_hrdata1;
   reg              smc_hready1;
   reg    [1:0]     smc_hresp1;

  //reg   s from smc1
   reg    [15:0]    smc_addr1;      // External1 Memory (EMI1) address
   reg    [3:0]     smc_n_be1;      // EMI1 byte enables1 (Active1 LOW1)
   reg    [7:0]     smc_n_cs1;      // EMI1 Chip1 Selects1 (Active1 LOW1)
   reg    [3:0]     smc_n_we1;      // EMI1 write strobes1 (Active1 LOW1)
   reg              smc_n_wr1;      // EMI1 write enable (Active1 LOW1)
   reg              smc_n_rd1;      // EMI1 read stobe1 (Active1 LOW1)
   reg              smc_n_ext_oe1;  // EMI1 write data reg    enable
   reg    [31:0]    smc_data1;      // EMI1 write data
  //reg   s from uart1
   reg           ua_txd1;       	// UART1 transmitter1 serial1 reg   
   reg           ua_txd11;       // UART1 transmitter1 serial1 reg   
   reg           ua_nrts1;      	// Request1-To1-Send1 flow1 control1
   reg           ua_nrts11;      // Request1-To1-Send1 flow1 control1
   // reg   s from ttc1
  // reg   s from SPI1
   reg       so;                    // data reg    from slave1
   reg       mo1;                    // data reg    from master1
   reg       sclk_out1;              // clock1 reg    from master1
   reg    [P_SIZE1-1:0] n_ss_out1;    // peripheral1 select1 lines1 from master1
   reg       n_so_en1;               // out enable for slave1 data
   reg       n_mo_en1;               // out enable for master1 data
   reg       n_sclk_en1;             // out enable for master1 clock1
   reg       n_ss_en1;               // out enable for master1 peripheral1 lines1
  //reg   s from gpio1
   reg    [GPIO_WIDTH1-1:0]     n_gpio_pin_oe1;           // reg    enable signal1 to pin1
   reg    [GPIO_WIDTH1-1:0]     gpio_pin_out1;            // reg    signal1 to pin1


`endif
//------------------------------------------------------------------------------
// black1 boxed1 defines1 
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// APB1 and AHB1 interface formal1 verification1 monitors1
//------------------------------------------------------------------------------
`ifdef ABV_ON1
apb_assert1 i_apb_assert1 (

        // APB1 signals1
  	.n_preset1(n_preset1),
   	.pclk1(pclk1),
	.penable1(penable1),
	.paddr1(paddr1),
	.pwrite1(pwrite1),
	.pwdata1(pwdata1),

	.psel001(psel_spi1),
	.psel011(psel_uart01),
	.psel021(psel_gpio1),
	.psel031(psel_ttc1),
	.psel041(1'b0),
	.psel051(psel_smc1),
	.psel061(1'b0),
	.psel071(1'b0),
	.psel081(1'b0),
	.psel091(1'b0),
	.psel101(1'b0),
	.psel111(1'b0),
	.psel121(1'b0),
	.psel131(psel_pmc1),
	.psel141(psel_apic1),
	.psel151(psel_uart11),

        .prdata001(prdata_spi1),
        .prdata011(prdata_uart01), // Read Data from peripheral1 UART1 
        .prdata021(prdata_gpio1), // Read Data from peripheral1 GPIO1
        .prdata031(prdata_ttc1), // Read Data from peripheral1 TTC1
        .prdata041(32'b0), // 
        .prdata051(prdata_smc1), // Read Data from peripheral1 SMC1
        .prdata131(prdata_pmc1), // Read Data from peripheral1 Power1 Control1 Block
   	.prdata141(32'b0), // 
        .prdata151(prdata_uart11),


        // AHB1 signals1
        .hclk1(hclk1),         // ahb1 system clock1
        .n_hreset1(n_hreset1), // ahb1 system reset

        // ahb2apb1 signals1
        .hresp1(hresp1),
        .hready1(hready1),
        .hrdata1(hrdata1),
        .hwdata1(hwdata1),
        .hprot1(hprot1),
        .hburst1(hburst1),
        .hsize1(hsize1),
        .hwrite1(hwrite1),
        .htrans1(htrans1),
        .haddr1(haddr1),
        .ahb2apb_hsel1(ahb2apb0_hsel1));



//------------------------------------------------------------------------------
// AHB1 interface formal1 verification1 monitor1
//------------------------------------------------------------------------------
defparam i_ahbSlaveMonitor1.DBUS_WIDTH1 = 32;
defparam i_ahbMasterMonitor1.DBUS_WIDTH1 = 32;


// AHB2APB1 Bridge1

    ahb_liteslave_monitor1 i_ahbSlaveMonitor1 (
        .hclk_i1(hclk1),
        .hresetn_i1(n_hreset1),
        .hresp1(hresp1),
        .hready1(hready1),
        .hready_global_i1(hready1),
        .hrdata1(hrdata1),
        .hwdata_i1(hwdata1),
        .hburst_i1(hburst1),
        .hsize_i1(hsize1),
        .hwrite_i1(hwrite1),
        .htrans_i1(htrans1),
        .haddr_i1(haddr1),
        .hsel_i1(ahb2apb0_hsel1)
    );


  ahb_litemaster_monitor1 i_ahbMasterMonitor1 (
          .hclk_i1(hclk1),
          .hresetn_i1(n_hreset1),
          .hresp_i1(hresp1),
          .hready_i1(hready1),
          .hrdata_i1(hrdata1),
          .hlock1(1'b0),
          .hwdata1(hwdata1),
          .hprot1(hprot1),
          .hburst1(hburst1),
          .hsize1(hsize1),
          .hwrite1(hwrite1),
          .htrans1(htrans1),
          .haddr1(haddr1)
          );







`endif




`ifdef IFV_LP_ABV_ON1
// power1 control1
wire isolate1;

// testbench mirror signals1
wire L1_ctrl_access1;
wire L1_status_access1;

wire [31:0] L1_status_reg1;
wire [31:0] L1_ctrl_reg1;

//wire rstn_non_srpg_urt1;
//wire isolate_urt1;
//wire retain_urt1;
//wire gate_clk_urt1;
//wire pwr1_on_urt1;


// smc1 signals1
wire [31:0] smc_prdata1;
wire lp_clk_smc1;
                    

// uart1 isolation1 register
  wire [15:0] ua_prdata1;
  wire ua_int1;
  assign ua_prdata1          =  i_uart1_veneer1.prdata1;
  assign ua_int1             =  i_uart1_veneer1.ua_int1;


assign lp_clk_smc1          = i_smc_veneer1.pclk1;
assign smc_prdata1          = i_smc_veneer1.prdata1;
lp_chk_smc1 u_lp_chk_smc1 (
    .clk1 (hclk1),
    .rst1 (n_hreset1),
    .iso_smc1 (isolate_smc1),
    .gate_clk1 (gate_clk_smc1),
    .lp_clk1 (pclk_SRPG_smc1),

    // srpg1 outputs1
    .smc_hrdata1 (smc_hrdata1),
    .smc_hready1 (smc_hready1),
    .smc_hresp1  (smc_hresp1),
    .smc_valid1 (smc_valid1),
    .smc_addr_int1 (smc_addr_int1),
    .smc_data1 (smc_data1),
    .smc_n_be1 (smc_n_be1),
    .smc_n_cs1  (smc_n_cs1),
    .smc_n_wr1 (smc_n_wr1),
    .smc_n_we1 (smc_n_we1),
    .smc_n_rd1 (smc_n_rd1),
    .smc_n_ext_oe1 (smc_n_ext_oe1)
   );

// lp1 retention1/isolation1 assertions1
lp_chk_uart1 u_lp_chk_urt1 (

  .clk1         (hclk1),
  .rst1         (n_hreset1),
  .iso_urt1     (isolate_urt1),
  .gate_clk1    (gate_clk_urt1),
  .lp_clk1      (pclk_SRPG_urt1),
  //ports1
  .prdata1 (ua_prdata1),
  .ua_int1 (ua_int1),
  .ua_txd1 (ua_txd11),
  .ua_nrts1 (ua_nrts11)
 );

`endif  //IFV_LP_ABV_ON1




endmodule
