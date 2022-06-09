//File5 name   : apb_subsystem_05.v
//Title5       : 
//Created5     : 1999
//Description5 : 
//Notes5       : 
//----------------------------------------------------------------------
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------

module apb_subsystem_05(
    // AHB5 interface
    hclk5,
    n_hreset5,
    hsel5,
    haddr5,
    htrans5,
    hsize5,
    hwrite5,
    hwdata5,
    hready_in5,
    hburst5,
    hprot5,
    hmaster5,
    hmastlock5,
    hrdata5,
    hready5,
    hresp5,
    
    // APB5 system interface
    pclk5,
    n_preset5,
    
    // SPI5 ports5
    n_ss_in5,
    mi5,
    si5,
    sclk_in5,
    so,
    mo5,
    sclk_out5,
    n_ss_out5,
    n_so_en5,
    n_mo_en5,
    n_sclk_en5,
    n_ss_en5,
    
    //UART05 ports5
    ua_rxd5,
    ua_ncts5,
    ua_txd5,
    ua_nrts5,
    
    //UART15 ports5
    ua_rxd15,
    ua_ncts15,
    ua_txd15,
    ua_nrts15,
    
    //GPIO5 ports5
    gpio_pin_in5,
    n_gpio_pin_oe5,
    gpio_pin_out5,
    

    //SMC5 ports5
    smc_hclk5,
    smc_n_hclk5,
    smc_haddr5,
    smc_htrans5,
    smc_hsel5,
    smc_hwrite5,
    smc_hsize5,
    smc_hwdata5,
    smc_hready_in5,
    smc_hburst5,
    smc_hprot5,
    smc_hmaster5,
    smc_hmastlock5,
    smc_hrdata5, 
    smc_hready5,
    smc_hresp5,
    smc_n_ext_oe5,
    smc_data5,
    smc_addr5,
    smc_n_be5,
    smc_n_cs5, 
    smc_n_we5,
    smc_n_wr5,
    smc_n_rd5,
    data_smc5,
    
    //PMC5 ports5
    clk_SRPG_macb0_en5,
    clk_SRPG_macb1_en5,
    clk_SRPG_macb2_en5,
    clk_SRPG_macb3_en5,
    core06v5,
    core08v5,
    core10v5,
    core12v5,
    macb3_wakeup5,
    macb2_wakeup5,
    macb1_wakeup5,
    macb0_wakeup5,
    mte_smc_start5,
    mte_uart_start5,
    mte_smc_uart_start5,  
    mte_pm_smc_to_default_start5, 
    mte_pm_uart_to_default_start5,
    mte_pm_smc_uart_to_default_start5,
    
    
    // Peripheral5 inerrupts5
    pcm_irq5,
    ttc_irq5,
    gpio_irq5,
    uart0_irq5,
    uart1_irq5,
    spi_irq5,
    DMA_irq5,      
    macb0_int5,
    macb1_int5,
    macb2_int5,
    macb3_int5,
   
    // Scan5 ports5
    scan_en5,      // Scan5 enable pin5
    scan_in_15,    // Scan5 input for first chain5
    scan_in_25,    // Scan5 input for second chain5
    scan_mode5,
    scan_out_15,   // Scan5 out for chain5 1
    scan_out_25    // Scan5 out for chain5 2
);

parameter GPIO_WIDTH5 = 16;        // GPIO5 width
parameter P_SIZE5 =   8;              // number5 of peripheral5 select5 lines5
parameter NO_OF_IRQS5  = 17;      //No of irqs5 read by apic5 

// AHB5 interface
input         hclk5;     // AHB5 Clock5
input         n_hreset5;  // AHB5 reset - Active5 low5
input         hsel5;     // AHB2APB5 select5
input [31:0]  haddr5;    // Address bus
input [1:0]   htrans5;   // Transfer5 type
input [2:0]   hsize5;    // AHB5 Access type - byte, half5-word5, word5
input [31:0]  hwdata5;   // Write data
input         hwrite5;   // Write signal5/
input         hready_in5;// Indicates5 that last master5 has finished5 bus access
input [2:0]   hburst5;     // Burst type
input [3:0]   hprot5;      // Protection5 control5
input [3:0]   hmaster5;    // Master5 select5
input         hmastlock5;  // Locked5 transfer5
output [31:0] hrdata5;       // Read data provided from target slave5
output        hready5;       // Ready5 for new bus cycle from target slave5
output [1:0]  hresp5;       // Response5 from the bridge5
    
// APB5 system interface
input         pclk5;     // APB5 Clock5. 
input         n_preset5;  // APB5 reset - Active5 low5
   
// SPI5 ports5
input     n_ss_in5;      // select5 input to slave5
input     mi5;           // data input to master5
input     si5;           // data input to slave5
input     sclk_in5;      // clock5 input to slave5
output    so;                    // data output from slave5
output    mo5;                    // data output from master5
output    sclk_out5;              // clock5 output from master5
output [P_SIZE5-1:0] n_ss_out5;    // peripheral5 select5 lines5 from master5
output    n_so_en5;               // out enable for slave5 data
output    n_mo_en5;               // out enable for master5 data
output    n_sclk_en5;             // out enable for master5 clock5
output    n_ss_en5;               // out enable for master5 peripheral5 lines5

//UART05 ports5
input        ua_rxd5;       // UART5 receiver5 serial5 input pin5
input        ua_ncts5;      // Clear-To5-Send5 flow5 control5
output       ua_txd5;       	// UART5 transmitter5 serial5 output
output       ua_nrts5;      	// Request5-To5-Send5 flow5 control5

// UART15 ports5   
input        ua_rxd15;      // UART5 receiver5 serial5 input pin5
input        ua_ncts15;      // Clear-To5-Send5 flow5 control5
output       ua_txd15;       // UART5 transmitter5 serial5 output
output       ua_nrts15;      // Request5-To5-Send5 flow5 control5

//GPIO5 ports5
input [GPIO_WIDTH5-1:0]      gpio_pin_in5;             // input data from pin5
output [GPIO_WIDTH5-1:0]     n_gpio_pin_oe5;           // output enable signal5 to pin5
output [GPIO_WIDTH5-1:0]     gpio_pin_out5;            // output signal5 to pin5
  
//SMC5 ports5
input        smc_hclk5;
input        smc_n_hclk5;
input [31:0] smc_haddr5;
input [1:0]  smc_htrans5;
input        smc_hsel5;
input        smc_hwrite5;
input [2:0]  smc_hsize5;
input [31:0] smc_hwdata5;
input        smc_hready_in5;
input [2:0]  smc_hburst5;     // Burst type
input [3:0]  smc_hprot5;      // Protection5 control5
input [3:0]  smc_hmaster5;    // Master5 select5
input        smc_hmastlock5;  // Locked5 transfer5
input [31:0] data_smc5;     // EMI5(External5 memory) read data
output [31:0]    smc_hrdata5;
output           smc_hready5;
output [1:0]     smc_hresp5;
output [15:0]    smc_addr5;      // External5 Memory (EMI5) address
output [3:0]     smc_n_be5;      // EMI5 byte enables5 (Active5 LOW5)
output           smc_n_cs5;      // EMI5 Chip5 Selects5 (Active5 LOW5)
output [3:0]     smc_n_we5;      // EMI5 write strobes5 (Active5 LOW5)
output           smc_n_wr5;      // EMI5 write enable (Active5 LOW5)
output           smc_n_rd5;      // EMI5 read stobe5 (Active5 LOW5)
output           smc_n_ext_oe5;  // EMI5 write data output enable
output [31:0]    smc_data5;      // EMI5 write data
       
//PMC5 ports5
output clk_SRPG_macb0_en5;
output clk_SRPG_macb1_en5;
output clk_SRPG_macb2_en5;
output clk_SRPG_macb3_en5;
output core06v5;
output core08v5;
output core10v5;
output core12v5;
output mte_smc_start5;
output mte_uart_start5;
output mte_smc_uart_start5;  
output mte_pm_smc_to_default_start5; 
output mte_pm_uart_to_default_start5;
output mte_pm_smc_uart_to_default_start5;
input macb3_wakeup5;
input macb2_wakeup5;
input macb1_wakeup5;
input macb0_wakeup5;
    

// Peripheral5 interrupts5
output pcm_irq5;
output [2:0] ttc_irq5;
output gpio_irq5;
output uart0_irq5;
output uart1_irq5;
output spi_irq5;
input        macb0_int5;
input        macb1_int5;
input        macb2_int5;
input        macb3_int5;
input        DMA_irq5;
  
//Scan5 ports5
input        scan_en5;    // Scan5 enable pin5
input        scan_in_15;  // Scan5 input for first chain5
input        scan_in_25;  // Scan5 input for second chain5
input        scan_mode5;  // test mode pin5
 output        scan_out_15;   // Scan5 out for chain5 1
 output        scan_out_25;   // Scan5 out for chain5 2  

//------------------------------------------------------------------------------
// if the ROM5 subsystem5 is NOT5 black5 boxed5 
//------------------------------------------------------------------------------
`ifndef FV_KIT_BLACK_BOX_APB_SUBSYSTEM5
   
   wire        hsel5; 
   wire        pclk5;
   wire        n_preset5;
   wire [31:0] prdata_spi5;
   wire [31:0] prdata_uart05;
   wire [31:0] prdata_gpio5;
   wire [31:0] prdata_ttc5;
   wire [31:0] prdata_smc5;
   wire [31:0] prdata_pmc5;
   wire [31:0] prdata_uart15;
   wire        pready_spi5;
   wire        pready_uart05;
   wire        pready_uart15;
   wire        tie_hi_bit5;
   wire  [31:0] hrdata5; 
   wire         hready5;
   wire         hready_in5;
   wire  [1:0]  hresp5;   
   wire  [31:0] pwdata5;  
   wire         pwrite5;
   wire  [31:0] paddr5;  
   wire   psel_spi5;
   wire   psel_uart05;
   wire   psel_gpio5;
   wire   psel_ttc5;
   wire   psel_smc5;
   wire   psel075;
   wire   psel085;
   wire   psel095;
   wire   psel105;
   wire   psel115;
   wire   psel125;
   wire   psel_pmc5;
   wire   psel_uart15;
   wire   penable5;
   wire   [NO_OF_IRQS5:0] int_source5;     // System5 Interrupt5 Sources5
   wire [1:0]             smc_hresp5;     // AHB5 Response5 signal5
   wire                   smc_valid5;     // Ack5 valid address

  //External5 memory interface (EMI5)
  wire [31:0]            smc_addr_int5;  // External5 Memory (EMI5) address
  wire [3:0]             smc_n_be5;      // EMI5 byte enables5 (Active5 LOW5)
  wire                   smc_n_cs5;      // EMI5 Chip5 Selects5 (Active5 LOW5)
  wire [3:0]             smc_n_we5;      // EMI5 write strobes5 (Active5 LOW5)
  wire                   smc_n_wr5;      // EMI5 write enable (Active5 LOW5)
  wire                   smc_n_rd5;      // EMI5 read stobe5 (Active5 LOW5)
 
  //AHB5 Memory Interface5 Control5
  wire                   smc_hsel_int5;
  wire                   smc_busy5;      // smc5 busy
   

//scan5 signals5

   wire                scan_in_15;        //scan5 input
   wire                scan_in_25;        //scan5 input
   wire                scan_en5;         //scan5 enable
   wire                scan_out_15;       //scan5 output
   wire                scan_out_25;       //scan5 output
   wire                byte_sel5;     // byte select5 from bridge5 1=byte, 0=2byte
   wire                UART_int5;     // UART5 module interrupt5 
   wire                ua_uclken5;    // Soft5 control5 of clock5
   wire                UART_int15;     // UART5 module interrupt5 
   wire                ua_uclken15;    // Soft5 control5 of clock5
   wire  [3:1]         TTC_int5;            //Interrupt5 from PCI5 
  // inputs5 to SPI5 
   wire    ext_clk5;                // external5 clock5
   wire    SPI_int5;             // interrupt5 request
  // outputs5 from SPI5
   wire    slave_out_clk5;         // modified slave5 clock5 output
 // gpio5 generic5 inputs5 
   wire  [GPIO_WIDTH5-1:0]   n_gpio_bypass_oe5;        // bypass5 mode enable 
   wire  [GPIO_WIDTH5-1:0]   gpio_bypass_out5;         // bypass5 mode output value 
   wire  [GPIO_WIDTH5-1:0]   tri_state_enable5;   // disables5 op enable -> z 
 // outputs5 
   //amba5 outputs5 
   // gpio5 generic5 outputs5 
   wire       GPIO_int5;                // gpio_interupt5 for input pin5 change 
   wire [GPIO_WIDTH5-1:0]     gpio_bypass_in5;          // bypass5 mode input data value  
                
   wire           cpu_debug5;        // Inhibits5 watchdog5 counter 
   wire            ex_wdz_n5;         // External5 Watchdog5 zero indication5
   wire           rstn_non_srpg_smc5; 
   wire           rstn_non_srpg_urt5;
   wire           isolate_smc5;
   wire           save_edge_smc5;
   wire           restore_edge_smc5;
   wire           save_edge_urt5;
   wire           restore_edge_urt5;
   wire           pwr1_on_smc5;
   wire           pwr2_on_smc5;
   wire           pwr1_on_urt5;
   wire           pwr2_on_urt5;
   // ETH05
   wire            rstn_non_srpg_macb05;
   wire            gate_clk_macb05;
   wire            isolate_macb05;
   wire            save_edge_macb05;
   wire            restore_edge_macb05;
   wire            pwr1_on_macb05;
   wire            pwr2_on_macb05;
   // ETH15
   wire            rstn_non_srpg_macb15;
   wire            gate_clk_macb15;
   wire            isolate_macb15;
   wire            save_edge_macb15;
   wire            restore_edge_macb15;
   wire            pwr1_on_macb15;
   wire            pwr2_on_macb15;
   // ETH25
   wire            rstn_non_srpg_macb25;
   wire            gate_clk_macb25;
   wire            isolate_macb25;
   wire            save_edge_macb25;
   wire            restore_edge_macb25;
   wire            pwr1_on_macb25;
   wire            pwr2_on_macb25;
   // ETH35
   wire            rstn_non_srpg_macb35;
   wire            gate_clk_macb35;
   wire            isolate_macb35;
   wire            save_edge_macb35;
   wire            restore_edge_macb35;
   wire            pwr1_on_macb35;
   wire            pwr2_on_macb35;


   wire           pclk_SRPG_smc5;
   wire           pclk_SRPG_urt5;
   wire           gate_clk_smc5;
   wire           gate_clk_urt5;
   wire  [31:0]   tie_lo_32bit5; 
   wire  [1:0]	  tie_lo_2bit5;
   wire  	  tie_lo_1bit5;
   wire           pcm_macb_wakeup_int5;
   wire           int_source_h5;
   wire           isolate_mem5;

assign pcm_irq5 = pcm_macb_wakeup_int5;
assign ttc_irq5[2] = TTC_int5[3];
assign ttc_irq5[1] = TTC_int5[2];
assign ttc_irq5[0] = TTC_int5[1];
assign gpio_irq5 = GPIO_int5;
assign uart0_irq5 = UART_int5;
assign uart1_irq5 = UART_int15;
assign spi_irq5 = SPI_int5;

assign n_mo_en5   = 1'b0;
assign n_so_en5   = 1'b1;
assign n_sclk_en5 = 1'b0;
assign n_ss_en5   = 1'b0;

assign smc_hsel_int5 = smc_hsel5;
  assign ext_clk5  = 1'b0;
  assign int_source5 = {macb0_int5,macb1_int5, macb2_int5, macb3_int5,1'b0, pcm_macb_wakeup_int5, 1'b0, 1'b0, 1'b0, 1'b0, TTC_int5, GPIO_int5, UART_int5, UART_int15, SPI_int5, DMA_irq5};

  // interrupt5 even5 detect5 .
  // for sleep5 wake5 up -> any interrupt5 even5 and system not in hibernation5 (isolate_mem5 = 0)
  // for hibernate5 wake5 up -> gpio5 interrupt5 even5 and system in the hibernation5 (isolate_mem5 = 1)
  assign int_source_h5 =  ((|int_source5) && (!isolate_mem5)) || (isolate_mem5 && GPIO_int5) ;

  assign byte_sel5 = 1'b1;
  assign tie_hi_bit5 = 1'b1;

  assign smc_addr5 = smc_addr_int5[15:0];



  assign  n_gpio_bypass_oe5 = {GPIO_WIDTH5{1'b0}};        // bypass5 mode enable 
  assign  gpio_bypass_out5  = {GPIO_WIDTH5{1'b0}};
  assign  tri_state_enable5 = {GPIO_WIDTH5{1'b0}};
  assign  cpu_debug5 = 1'b0;
  assign  tie_lo_32bit5 = 32'b0;
  assign  tie_lo_2bit5  = 2'b0;
  assign  tie_lo_1bit5  = 1'b0;


ahb2apb5 #(
  32'h00800000, // Slave5 0 Address Range5
  32'h0080FFFF,

  32'h00810000, // Slave5 1 Address Range5
  32'h0081FFFF,

  32'h00820000, // Slave5 2 Address Range5 
  32'h0082FFFF,

  32'h00830000, // Slave5 3 Address Range5
  32'h0083FFFF,

  32'h00840000, // Slave5 4 Address Range5
  32'h0084FFFF,

  32'h00850000, // Slave5 5 Address Range5
  32'h0085FFFF,

  32'h00860000, // Slave5 6 Address Range5
  32'h0086FFFF,

  32'h00870000, // Slave5 7 Address Range5
  32'h0087FFFF,

  32'h00880000, // Slave5 8 Address Range5
  32'h0088FFFF
) i_ahb2apb5 (
     // AHB5 interface
    .hclk5(hclk5),         
    .hreset_n5(n_hreset5), 
    .hsel5(hsel5), 
    .haddr5(haddr5),        
    .htrans5(htrans5),       
    .hwrite5(hwrite5),       
    .hwdata5(hwdata5),       
    .hrdata5(hrdata5),   
    .hready5(hready5),   
    .hresp5(hresp5),     
    
     // APB5 interface
    .pclk5(pclk5),         
    .preset_n5(n_preset5),  
    .prdata05(prdata_spi5),
    .prdata15(prdata_uart05), 
    .prdata25(prdata_gpio5),  
    .prdata35(prdata_ttc5),   
    .prdata45(32'h0),   
    .prdata55(prdata_smc5),   
    .prdata65(prdata_pmc5),    
    .prdata75(32'h0),   
    .prdata85(prdata_uart15),  
    .pready05(pready_spi5),     
    .pready15(pready_uart05),   
    .pready25(tie_hi_bit5),     
    .pready35(tie_hi_bit5),     
    .pready45(tie_hi_bit5),     
    .pready55(tie_hi_bit5),     
    .pready65(tie_hi_bit5),     
    .pready75(tie_hi_bit5),     
    .pready85(pready_uart15),  
    .pwdata5(pwdata5),       
    .pwrite5(pwrite5),       
    .paddr5(paddr5),        
    .psel05(psel_spi5),     
    .psel15(psel_uart05),   
    .psel25(psel_gpio5),    
    .psel35(psel_ttc5),     
    .psel45(),     
    .psel55(psel_smc5),     
    .psel65(psel_pmc5),    
    .psel75(psel_apic5),   
    .psel85(psel_uart15),  
    .penable5(penable5)     
);

spi_top5 i_spi5
(
  // Wishbone5 signals5
  .wb_clk_i5(pclk5), 
  .wb_rst_i5(~n_preset5), 
  .wb_adr_i5(paddr5[4:0]), 
  .wb_dat_i5(pwdata5), 
  .wb_dat_o5(prdata_spi5), 
  .wb_sel_i5(4'b1111),    // SPI5 register accesses are always 32-bit
  .wb_we_i5(pwrite5), 
  .wb_stb_i5(psel_spi5), 
  .wb_cyc_i5(psel_spi5), 
  .wb_ack_o5(pready_spi5), 
  .wb_err_o5(), 
  .wb_int_o5(SPI_int5),

  // SPI5 signals5
  .ss_pad_o5(n_ss_out5), 
  .sclk_pad_o5(sclk_out5), 
  .mosi_pad_o5(mo5), 
  .miso_pad_i5(mi5)
);

// Opencores5 UART5 instances5
wire ua_nrts_int5;
wire ua_nrts1_int5;

assign ua_nrts5 = ua_nrts_int5;
assign ua_nrts15 = ua_nrts1_int5;

reg [3:0] uart0_sel_i5;
reg [3:0] uart1_sel_i5;
// UART5 registers are all 8-bit wide5, and their5 addresses5
// are on byte boundaries5. So5 to access them5 on the
// Wishbone5 bus, the CPU5 must do byte accesses to these5
// byte addresses5. Word5 address accesses are not possible5
// because the word5 addresses5 will be unaligned5, and cause
// a fault5.
// So5, Uart5 accesses from the CPU5 will always be 8-bit size
// We5 only have to decide5 which byte of the 4-byte word5 the
// CPU5 is interested5 in.
`ifdef SYSTEM_BIG_ENDIAN5
always @(paddr5) begin
  case (paddr5[1:0])
    2'b00 : uart0_sel_i5 = 4'b1000;
    2'b01 : uart0_sel_i5 = 4'b0100;
    2'b10 : uart0_sel_i5 = 4'b0010;
    2'b11 : uart0_sel_i5 = 4'b0001;
  endcase
end
always @(paddr5) begin
  case (paddr5[1:0])
    2'b00 : uart1_sel_i5 = 4'b1000;
    2'b01 : uart1_sel_i5 = 4'b0100;
    2'b10 : uart1_sel_i5 = 4'b0010;
    2'b11 : uart1_sel_i5 = 4'b0001;
  endcase
end
`else
always @(paddr5) begin
  case (paddr5[1:0])
    2'b00 : uart0_sel_i5 = 4'b0001;
    2'b01 : uart0_sel_i5 = 4'b0010;
    2'b10 : uart0_sel_i5 = 4'b0100;
    2'b11 : uart0_sel_i5 = 4'b1000;
  endcase
end
always @(paddr5) begin
  case (paddr5[1:0])
    2'b00 : uart1_sel_i5 = 4'b0001;
    2'b01 : uart1_sel_i5 = 4'b0010;
    2'b10 : uart1_sel_i5 = 4'b0100;
    2'b11 : uart1_sel_i5 = 4'b1000;
  endcase
end
`endif

uart_top5 i_oc_uart05 (
  .wb_clk_i5(pclk5),
  .wb_rst_i5(~n_preset5),
  .wb_adr_i5(paddr5[4:0]),
  .wb_dat_i5(pwdata5),
  .wb_dat_o5(prdata_uart05),
  .wb_we_i5(pwrite5),
  .wb_stb_i5(psel_uart05),
  .wb_cyc_i5(psel_uart05),
  .wb_ack_o5(pready_uart05),
  .wb_sel_i5(uart0_sel_i5),
  .int_o5(UART_int5),
  .stx_pad_o5(ua_txd5),
  .srx_pad_i5(ua_rxd5),
  .rts_pad_o5(ua_nrts_int5),
  .cts_pad_i5(ua_ncts5),
  .dtr_pad_o5(),
  .dsr_pad_i5(1'b0),
  .ri_pad_i5(1'b0),
  .dcd_pad_i5(1'b0)
);

uart_top5 i_oc_uart15 (
  .wb_clk_i5(pclk5),
  .wb_rst_i5(~n_preset5),
  .wb_adr_i5(paddr5[4:0]),
  .wb_dat_i5(pwdata5),
  .wb_dat_o5(prdata_uart15),
  .wb_we_i5(pwrite5),
  .wb_stb_i5(psel_uart15),
  .wb_cyc_i5(psel_uart15),
  .wb_ack_o5(pready_uart15),
  .wb_sel_i5(uart1_sel_i5),
  .int_o5(UART_int15),
  .stx_pad_o5(ua_txd15),
  .srx_pad_i5(ua_rxd15),
  .rts_pad_o5(ua_nrts1_int5),
  .cts_pad_i5(ua_ncts15),
  .dtr_pad_o5(),
  .dsr_pad_i5(1'b0),
  .ri_pad_i5(1'b0),
  .dcd_pad_i5(1'b0)
);

gpio_veneer5 i_gpio_veneer5 (
        //inputs5

        . n_p_reset5(n_preset5),
        . pclk5(pclk5),
        . psel5(psel_gpio5),
        . penable5(penable5),
        . pwrite5(pwrite5),
        . paddr5(paddr5[5:0]),
        . pwdata5(pwdata5),
        . gpio_pin_in5(gpio_pin_in5),
        . scan_en5(scan_en5),
        . tri_state_enable5(tri_state_enable5),
        . scan_in5(), //added by smarkov5 for dft5

        //outputs5
        . scan_out5(), //added by smarkov5 for dft5
        . prdata5(prdata_gpio5),
        . gpio_int5(GPIO_int5),
        . n_gpio_pin_oe5(n_gpio_pin_oe5),
        . gpio_pin_out5(gpio_pin_out5)
);


ttc_veneer5 i_ttc_veneer5 (

         //inputs5
        . n_p_reset5(n_preset5),
        . pclk5(pclk5),
        . psel5(psel_ttc5),
        . penable5(penable5),
        . pwrite5(pwrite5),
        . pwdata5(pwdata5),
        . paddr5(paddr5[7:0]),
        . scan_in5(),
        . scan_en5(scan_en5),

        //outputs5
        . prdata5(prdata_ttc5),
        . interrupt5(TTC_int5[3:1]),
        . scan_out5()
);


smc_veneer5 i_smc_veneer5 (
        //inputs5
	//apb5 inputs5
        . n_preset5(n_preset5),
        . pclk5(pclk_SRPG_smc5),
        . psel5(psel_smc5),
        . penable5(penable5),
        . pwrite5(pwrite5),
        . paddr5(paddr5[4:0]),
        . pwdata5(pwdata5),
        //ahb5 inputs5
	. hclk5(smc_hclk5),
        . n_sys_reset5(rstn_non_srpg_smc5),
        . haddr5(smc_haddr5),
        . htrans5(smc_htrans5),
        . hsel5(smc_hsel_int5),
        . hwrite5(smc_hwrite5),
	. hsize5(smc_hsize5),
        . hwdata5(smc_hwdata5),
        . hready5(smc_hready_in5),
        . data_smc5(data_smc5),

         //test signal5 inputs5

        . scan_in_15(),
        . scan_in_25(),
        . scan_in_35(),
        . scan_en5(scan_en5),

        //apb5 outputs5
        . prdata5(prdata_smc5),

       //design output

        . smc_hrdata5(smc_hrdata5),
        . smc_hready5(smc_hready5),
        . smc_hresp5(smc_hresp5),
        . smc_valid5(smc_valid5),
        . smc_addr5(smc_addr_int5),
        . smc_data5(smc_data5),
        . smc_n_be5(smc_n_be5),
        . smc_n_cs5(smc_n_cs5),
        . smc_n_wr5(smc_n_wr5),
        . smc_n_we5(smc_n_we5),
        . smc_n_rd5(smc_n_rd5),
        . smc_n_ext_oe5(smc_n_ext_oe5),
        . smc_busy5(smc_busy5),

         //test signal5 output
        . scan_out_15(),
        . scan_out_25(),
        . scan_out_35()
);

power_ctrl_veneer5 i_power_ctrl_veneer5 (
    // -- Clocks5 & Reset5
    	.pclk5(pclk5), 			//  : in  std_logic5;
    	.nprst5(n_preset5), 		//  : in  std_logic5;
    // -- APB5 programming5 interface
    	.paddr5(paddr5), 			//  : in  std_logic_vector5(31 downto5 0);
    	.psel5(psel_pmc5), 			//  : in  std_logic5;
    	.penable5(penable5), 		//  : in  std_logic5;
    	.pwrite5(pwrite5), 		//  : in  std_logic5;
    	.pwdata5(pwdata5), 		//  : in  std_logic_vector5(31 downto5 0);
    	.prdata5(prdata_pmc5), 		//  : out std_logic_vector5(31 downto5 0);
        .macb3_wakeup5(macb3_wakeup5),
        .macb2_wakeup5(macb2_wakeup5),
        .macb1_wakeup5(macb1_wakeup5),
        .macb0_wakeup5(macb0_wakeup5),
    // -- Module5 control5 outputs5
    	.scan_in5(),			//  : in  std_logic5;
    	.scan_en5(scan_en5),             	//  : in  std_logic5;
    	.scan_mode5(scan_mode5),          //  : in  std_logic5;
    	.scan_out5(),            	//  : out std_logic5;
        .int_source_h5(int_source_h5),
     	.rstn_non_srpg_smc5(rstn_non_srpg_smc5), 		//   : out std_logic5;
    	.gate_clk_smc5(gate_clk_smc5), 	//  : out std_logic5;
    	.isolate_smc5(isolate_smc5), 	//  : out std_logic5;
    	.save_edge_smc5(save_edge_smc5), 	//  : out std_logic5;
    	.restore_edge_smc5(restore_edge_smc5), 	//  : out std_logic5;
    	.pwr1_on_smc5(pwr1_on_smc5), 	//  : out std_logic5;
    	.pwr2_on_smc5(pwr2_on_smc5), 	//  : out std_logic5
     	.rstn_non_srpg_urt5(rstn_non_srpg_urt5), 		//   : out std_logic5;
    	.gate_clk_urt5(gate_clk_urt5), 	//  : out std_logic5;
    	.isolate_urt5(isolate_urt5), 	//  : out std_logic5;
    	.save_edge_urt5(save_edge_urt5), 	//  : out std_logic5;
    	.restore_edge_urt5(restore_edge_urt5), 	//  : out std_logic5;
    	.pwr1_on_urt5(pwr1_on_urt5), 	//  : out std_logic5;
    	.pwr2_on_urt5(pwr2_on_urt5),  	//  : out std_logic5
        // ETH05
        .rstn_non_srpg_macb05(rstn_non_srpg_macb05),
        .gate_clk_macb05(gate_clk_macb05),
        .isolate_macb05(isolate_macb05),
        .save_edge_macb05(save_edge_macb05),
        .restore_edge_macb05(restore_edge_macb05),
        .pwr1_on_macb05(pwr1_on_macb05),
        .pwr2_on_macb05(pwr2_on_macb05),
        // ETH15
        .rstn_non_srpg_macb15(rstn_non_srpg_macb15),
        .gate_clk_macb15(gate_clk_macb15),
        .isolate_macb15(isolate_macb15),
        .save_edge_macb15(save_edge_macb15),
        .restore_edge_macb15(restore_edge_macb15),
        .pwr1_on_macb15(pwr1_on_macb15),
        .pwr2_on_macb15(pwr2_on_macb15),
        // ETH25
        .rstn_non_srpg_macb25(rstn_non_srpg_macb25),
        .gate_clk_macb25(gate_clk_macb25),
        .isolate_macb25(isolate_macb25),
        .save_edge_macb25(save_edge_macb25),
        .restore_edge_macb25(restore_edge_macb25),
        .pwr1_on_macb25(pwr1_on_macb25),
        .pwr2_on_macb25(pwr2_on_macb25),
        // ETH35
        .rstn_non_srpg_macb35(rstn_non_srpg_macb35),
        .gate_clk_macb35(gate_clk_macb35),
        .isolate_macb35(isolate_macb35),
        .save_edge_macb35(save_edge_macb35),
        .restore_edge_macb35(restore_edge_macb35),
        .pwr1_on_macb35(pwr1_on_macb35),
        .pwr2_on_macb35(pwr2_on_macb35),
        .core06v5(core06v5),
        .core08v5(core08v5),
        .core10v5(core10v5),
        .core12v5(core12v5),
        .pcm_macb_wakeup_int5(pcm_macb_wakeup_int5),
        .isolate_mem5(isolate_mem5),
        .mte_smc_start5(mte_smc_start5),
        .mte_uart_start5(mte_uart_start5),
        .mte_smc_uart_start5(mte_smc_uart_start5),  
        .mte_pm_smc_to_default_start5(mte_pm_smc_to_default_start5), 
        .mte_pm_uart_to_default_start5(mte_pm_uart_to_default_start5),
        .mte_pm_smc_uart_to_default_start5(mte_pm_smc_uart_to_default_start5)
);

// Clock5 gating5 macro5 to shut5 off5 clocks5 to the SRPG5 flops5 in the SMC5
//CKLNQD15 i_SMC_SRPG_clk_gate5  (
//	.TE5(scan_mode5), 
//	.E5(~gate_clk_smc5), 
//	.CP5(pclk5), 
//	.Q5(pclk_SRPG_smc5)
//	);
// Replace5 gate5 with behavioural5 code5 //
wire 	smc_scan_gate5;
reg 	smc_latched_enable5;
assign smc_scan_gate5 = scan_mode5 ? 1'b1 : ~gate_clk_smc5;

always @ (pclk5 or smc_scan_gate5)
  	if (pclk5 == 1'b0) begin
  		smc_latched_enable5 <= smc_scan_gate5;
  	end  	
	
assign pclk_SRPG_smc5 = smc_latched_enable5 ? pclk5 : 1'b0;


// Clock5 gating5 macro5 to shut5 off5 clocks5 to the SRPG5 flops5 in the URT5
//CKLNQD15 i_URT_SRPG_clk_gate5  (
//	.TE5(scan_mode5), 
//	.E5(~gate_clk_urt5), 
//	.CP5(pclk5), 
//	.Q5(pclk_SRPG_urt5)
//	);
// Replace5 gate5 with behavioural5 code5 //
wire 	urt_scan_gate5;
reg 	urt_latched_enable5;
assign urt_scan_gate5 = scan_mode5 ? 1'b1 : ~gate_clk_urt5;

always @ (pclk5 or urt_scan_gate5)
  	if (pclk5 == 1'b0) begin
  		urt_latched_enable5 <= urt_scan_gate5;
  	end  	
	
assign pclk_SRPG_urt5 = urt_latched_enable5 ? pclk5 : 1'b0;

// ETH05
wire 	macb0_scan_gate5;
reg 	macb0_latched_enable5;
assign macb0_scan_gate5 = scan_mode5 ? 1'b1 : ~gate_clk_macb05;

always @ (pclk5 or macb0_scan_gate5)
  	if (pclk5 == 1'b0) begin
  		macb0_latched_enable5 <= macb0_scan_gate5;
  	end  	
	
assign clk_SRPG_macb0_en5 = macb0_latched_enable5 ? 1'b1 : 1'b0;

// ETH15
wire 	macb1_scan_gate5;
reg 	macb1_latched_enable5;
assign macb1_scan_gate5 = scan_mode5 ? 1'b1 : ~gate_clk_macb15;

always @ (pclk5 or macb1_scan_gate5)
  	if (pclk5 == 1'b0) begin
  		macb1_latched_enable5 <= macb1_scan_gate5;
  	end  	
	
assign clk_SRPG_macb1_en5 = macb1_latched_enable5 ? 1'b1 : 1'b0;

// ETH25
wire 	macb2_scan_gate5;
reg 	macb2_latched_enable5;
assign macb2_scan_gate5 = scan_mode5 ? 1'b1 : ~gate_clk_macb25;

always @ (pclk5 or macb2_scan_gate5)
  	if (pclk5 == 1'b0) begin
  		macb2_latched_enable5 <= macb2_scan_gate5;
  	end  	
	
assign clk_SRPG_macb2_en5 = macb2_latched_enable5 ? 1'b1 : 1'b0;

// ETH35
wire 	macb3_scan_gate5;
reg 	macb3_latched_enable5;
assign macb3_scan_gate5 = scan_mode5 ? 1'b1 : ~gate_clk_macb35;

always @ (pclk5 or macb3_scan_gate5)
  	if (pclk5 == 1'b0) begin
  		macb3_latched_enable5 <= macb3_scan_gate5;
  	end  	
	
assign clk_SRPG_macb3_en5 = macb3_latched_enable5 ? 1'b1 : 1'b0;



`else
//------------------------------------------------------------------------------
// if the APB5 subsystem5 is black5 boxed5 
//------------------------------------------------------------------------------
// wire s ports5
    // system signals5
    wire         hclk5;     // AHB5 Clock5
    wire         n_hreset5;  // AHB5 reset - Active5 low5
    wire         pclk5;     // APB5 Clock5. 
    wire         n_preset5;  // APB5 reset - Active5 low5

    // AHB5 interface
    wire         ahb2apb0_hsel5;     // AHB2APB5 select5
    wire  [31:0] haddr5;    // Address bus
    wire  [1:0]  htrans5;   // Transfer5 type
    wire  [2:0]  hsize5;    // AHB5 Access type - byte, half5-word5, word5
    wire  [31:0] hwdata5;   // Write data
    wire         hwrite5;   // Write signal5/
    wire         hready_in5;// Indicates5 that last master5 has finished5 bus access
    wire [2:0]   hburst5;     // Burst type
    wire [3:0]   hprot5;      // Protection5 control5
    wire [3:0]   hmaster5;    // Master5 select5
    wire         hmastlock5;  // Locked5 transfer5
  // Interrupts5 from the Enet5 MACs5
    wire         macb0_int5;
    wire         macb1_int5;
    wire         macb2_int5;
    wire         macb3_int5;
  // Interrupt5 from the DMA5
    wire         DMA_irq5;
  // Scan5 wire s
    wire         scan_en5;    // Scan5 enable pin5
    wire         scan_in_15;  // Scan5 wire  for first chain5
    wire         scan_in_25;  // Scan5 wire  for second chain5
    wire         scan_mode5;  // test mode pin5
 
  //wire  for smc5 AHB5 interface
    wire         smc_hclk5;
    wire         smc_n_hclk5;
    wire  [31:0] smc_haddr5;
    wire  [1:0]  smc_htrans5;
    wire         smc_hsel5;
    wire         smc_hwrite5;
    wire  [2:0]  smc_hsize5;
    wire  [31:0] smc_hwdata5;
    wire         smc_hready_in5;
    wire  [2:0]  smc_hburst5;     // Burst type
    wire  [3:0]  smc_hprot5;      // Protection5 control5
    wire  [3:0]  smc_hmaster5;    // Master5 select5
    wire         smc_hmastlock5;  // Locked5 transfer5


    wire  [31:0] data_smc5;     // EMI5(External5 memory) read data
    
  //wire s for uart5
    wire         ua_rxd5;       // UART5 receiver5 serial5 wire  pin5
    wire         ua_rxd15;      // UART5 receiver5 serial5 wire  pin5
    wire         ua_ncts5;      // Clear-To5-Send5 flow5 control5
    wire         ua_ncts15;      // Clear-To5-Send5 flow5 control5
   //wire s for spi5
    wire         n_ss_in5;      // select5 wire  to slave5
    wire         mi5;           // data wire  to master5
    wire         si5;           // data wire  to slave5
    wire         sclk_in5;      // clock5 wire  to slave5
  //wire s for GPIO5
   wire  [GPIO_WIDTH5-1:0]  gpio_pin_in5;             // wire  data from pin5

  //reg    ports5
  // Scan5 reg   s
   reg           scan_out_15;   // Scan5 out for chain5 1
   reg           scan_out_25;   // Scan5 out for chain5 2
  //AHB5 interface 
   reg    [31:0] hrdata5;       // Read data provided from target slave5
   reg           hready5;       // Ready5 for new bus cycle from target slave5
   reg    [1:0]  hresp5;       // Response5 from the bridge5

   // SMC5 reg    for AHB5 interface
   reg    [31:0]    smc_hrdata5;
   reg              smc_hready5;
   reg    [1:0]     smc_hresp5;

  //reg   s from smc5
   reg    [15:0]    smc_addr5;      // External5 Memory (EMI5) address
   reg    [3:0]     smc_n_be5;      // EMI5 byte enables5 (Active5 LOW5)
   reg    [7:0]     smc_n_cs5;      // EMI5 Chip5 Selects5 (Active5 LOW5)
   reg    [3:0]     smc_n_we5;      // EMI5 write strobes5 (Active5 LOW5)
   reg              smc_n_wr5;      // EMI5 write enable (Active5 LOW5)
   reg              smc_n_rd5;      // EMI5 read stobe5 (Active5 LOW5)
   reg              smc_n_ext_oe5;  // EMI5 write data reg    enable
   reg    [31:0]    smc_data5;      // EMI5 write data
  //reg   s from uart5
   reg           ua_txd5;       	// UART5 transmitter5 serial5 reg   
   reg           ua_txd15;       // UART5 transmitter5 serial5 reg   
   reg           ua_nrts5;      	// Request5-To5-Send5 flow5 control5
   reg           ua_nrts15;      // Request5-To5-Send5 flow5 control5
   // reg   s from ttc5
  // reg   s from SPI5
   reg       so;                    // data reg    from slave5
   reg       mo5;                    // data reg    from master5
   reg       sclk_out5;              // clock5 reg    from master5
   reg    [P_SIZE5-1:0] n_ss_out5;    // peripheral5 select5 lines5 from master5
   reg       n_so_en5;               // out enable for slave5 data
   reg       n_mo_en5;               // out enable for master5 data
   reg       n_sclk_en5;             // out enable for master5 clock5
   reg       n_ss_en5;               // out enable for master5 peripheral5 lines5
  //reg   s from gpio5
   reg    [GPIO_WIDTH5-1:0]     n_gpio_pin_oe5;           // reg    enable signal5 to pin5
   reg    [GPIO_WIDTH5-1:0]     gpio_pin_out5;            // reg    signal5 to pin5


`endif
//------------------------------------------------------------------------------
// black5 boxed5 defines5 
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// APB5 and AHB5 interface formal5 verification5 monitors5
//------------------------------------------------------------------------------
`ifdef ABV_ON5
apb_assert5 i_apb_assert5 (

        // APB5 signals5
  	.n_preset5(n_preset5),
   	.pclk5(pclk5),
	.penable5(penable5),
	.paddr5(paddr5),
	.pwrite5(pwrite5),
	.pwdata5(pwdata5),

	.psel005(psel_spi5),
	.psel015(psel_uart05),
	.psel025(psel_gpio5),
	.psel035(psel_ttc5),
	.psel045(1'b0),
	.psel055(psel_smc5),
	.psel065(1'b0),
	.psel075(1'b0),
	.psel085(1'b0),
	.psel095(1'b0),
	.psel105(1'b0),
	.psel115(1'b0),
	.psel125(1'b0),
	.psel135(psel_pmc5),
	.psel145(psel_apic5),
	.psel155(psel_uart15),

        .prdata005(prdata_spi5),
        .prdata015(prdata_uart05), // Read Data from peripheral5 UART5 
        .prdata025(prdata_gpio5), // Read Data from peripheral5 GPIO5
        .prdata035(prdata_ttc5), // Read Data from peripheral5 TTC5
        .prdata045(32'b0), // 
        .prdata055(prdata_smc5), // Read Data from peripheral5 SMC5
        .prdata135(prdata_pmc5), // Read Data from peripheral5 Power5 Control5 Block
   	.prdata145(32'b0), // 
        .prdata155(prdata_uart15),


        // AHB5 signals5
        .hclk5(hclk5),         // ahb5 system clock5
        .n_hreset5(n_hreset5), // ahb5 system reset

        // ahb2apb5 signals5
        .hresp5(hresp5),
        .hready5(hready5),
        .hrdata5(hrdata5),
        .hwdata5(hwdata5),
        .hprot5(hprot5),
        .hburst5(hburst5),
        .hsize5(hsize5),
        .hwrite5(hwrite5),
        .htrans5(htrans5),
        .haddr5(haddr5),
        .ahb2apb_hsel5(ahb2apb0_hsel5));



//------------------------------------------------------------------------------
// AHB5 interface formal5 verification5 monitor5
//------------------------------------------------------------------------------
defparam i_ahbSlaveMonitor5.DBUS_WIDTH5 = 32;
defparam i_ahbMasterMonitor5.DBUS_WIDTH5 = 32;


// AHB2APB5 Bridge5

    ahb_liteslave_monitor5 i_ahbSlaveMonitor5 (
        .hclk_i5(hclk5),
        .hresetn_i5(n_hreset5),
        .hresp5(hresp5),
        .hready5(hready5),
        .hready_global_i5(hready5),
        .hrdata5(hrdata5),
        .hwdata_i5(hwdata5),
        .hburst_i5(hburst5),
        .hsize_i5(hsize5),
        .hwrite_i5(hwrite5),
        .htrans_i5(htrans5),
        .haddr_i5(haddr5),
        .hsel_i5(ahb2apb0_hsel5)
    );


  ahb_litemaster_monitor5 i_ahbMasterMonitor5 (
          .hclk_i5(hclk5),
          .hresetn_i5(n_hreset5),
          .hresp_i5(hresp5),
          .hready_i5(hready5),
          .hrdata_i5(hrdata5),
          .hlock5(1'b0),
          .hwdata5(hwdata5),
          .hprot5(hprot5),
          .hburst5(hburst5),
          .hsize5(hsize5),
          .hwrite5(hwrite5),
          .htrans5(htrans5),
          .haddr5(haddr5)
          );







`endif




`ifdef IFV_LP_ABV_ON5
// power5 control5
wire isolate5;

// testbench mirror signals5
wire L1_ctrl_access5;
wire L1_status_access5;

wire [31:0] L1_status_reg5;
wire [31:0] L1_ctrl_reg5;

//wire rstn_non_srpg_urt5;
//wire isolate_urt5;
//wire retain_urt5;
//wire gate_clk_urt5;
//wire pwr1_on_urt5;


// smc5 signals5
wire [31:0] smc_prdata5;
wire lp_clk_smc5;
                    

// uart5 isolation5 register
  wire [15:0] ua_prdata5;
  wire ua_int5;
  assign ua_prdata5          =  i_uart1_veneer5.prdata5;
  assign ua_int5             =  i_uart1_veneer5.ua_int5;


assign lp_clk_smc5          = i_smc_veneer5.pclk5;
assign smc_prdata5          = i_smc_veneer5.prdata5;
lp_chk_smc5 u_lp_chk_smc5 (
    .clk5 (hclk5),
    .rst5 (n_hreset5),
    .iso_smc5 (isolate_smc5),
    .gate_clk5 (gate_clk_smc5),
    .lp_clk5 (pclk_SRPG_smc5),

    // srpg5 outputs5
    .smc_hrdata5 (smc_hrdata5),
    .smc_hready5 (smc_hready5),
    .smc_hresp5  (smc_hresp5),
    .smc_valid5 (smc_valid5),
    .smc_addr_int5 (smc_addr_int5),
    .smc_data5 (smc_data5),
    .smc_n_be5 (smc_n_be5),
    .smc_n_cs5  (smc_n_cs5),
    .smc_n_wr5 (smc_n_wr5),
    .smc_n_we5 (smc_n_we5),
    .smc_n_rd5 (smc_n_rd5),
    .smc_n_ext_oe5 (smc_n_ext_oe5)
   );

// lp5 retention5/isolation5 assertions5
lp_chk_uart5 u_lp_chk_urt5 (

  .clk5         (hclk5),
  .rst5         (n_hreset5),
  .iso_urt5     (isolate_urt5),
  .gate_clk5    (gate_clk_urt5),
  .lp_clk5      (pclk_SRPG_urt5),
  //ports5
  .prdata5 (ua_prdata5),
  .ua_int5 (ua_int5),
  .ua_txd5 (ua_txd15),
  .ua_nrts5 (ua_nrts15)
 );

`endif  //IFV_LP_ABV_ON5




endmodule
