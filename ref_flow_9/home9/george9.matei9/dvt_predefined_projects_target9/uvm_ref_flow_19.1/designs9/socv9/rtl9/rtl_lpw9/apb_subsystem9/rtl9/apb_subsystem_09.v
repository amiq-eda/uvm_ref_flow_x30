//File9 name   : apb_subsystem_09.v
//Title9       : 
//Created9     : 1999
//Description9 : 
//Notes9       : 
//----------------------------------------------------------------------
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------

module apb_subsystem_09(
    // AHB9 interface
    hclk9,
    n_hreset9,
    hsel9,
    haddr9,
    htrans9,
    hsize9,
    hwrite9,
    hwdata9,
    hready_in9,
    hburst9,
    hprot9,
    hmaster9,
    hmastlock9,
    hrdata9,
    hready9,
    hresp9,
    
    // APB9 system interface
    pclk9,
    n_preset9,
    
    // SPI9 ports9
    n_ss_in9,
    mi9,
    si9,
    sclk_in9,
    so,
    mo9,
    sclk_out9,
    n_ss_out9,
    n_so_en9,
    n_mo_en9,
    n_sclk_en9,
    n_ss_en9,
    
    //UART09 ports9
    ua_rxd9,
    ua_ncts9,
    ua_txd9,
    ua_nrts9,
    
    //UART19 ports9
    ua_rxd19,
    ua_ncts19,
    ua_txd19,
    ua_nrts19,
    
    //GPIO9 ports9
    gpio_pin_in9,
    n_gpio_pin_oe9,
    gpio_pin_out9,
    

    //SMC9 ports9
    smc_hclk9,
    smc_n_hclk9,
    smc_haddr9,
    smc_htrans9,
    smc_hsel9,
    smc_hwrite9,
    smc_hsize9,
    smc_hwdata9,
    smc_hready_in9,
    smc_hburst9,
    smc_hprot9,
    smc_hmaster9,
    smc_hmastlock9,
    smc_hrdata9, 
    smc_hready9,
    smc_hresp9,
    smc_n_ext_oe9,
    smc_data9,
    smc_addr9,
    smc_n_be9,
    smc_n_cs9, 
    smc_n_we9,
    smc_n_wr9,
    smc_n_rd9,
    data_smc9,
    
    //PMC9 ports9
    clk_SRPG_macb0_en9,
    clk_SRPG_macb1_en9,
    clk_SRPG_macb2_en9,
    clk_SRPG_macb3_en9,
    core06v9,
    core08v9,
    core10v9,
    core12v9,
    macb3_wakeup9,
    macb2_wakeup9,
    macb1_wakeup9,
    macb0_wakeup9,
    mte_smc_start9,
    mte_uart_start9,
    mte_smc_uart_start9,  
    mte_pm_smc_to_default_start9, 
    mte_pm_uart_to_default_start9,
    mte_pm_smc_uart_to_default_start9,
    
    
    // Peripheral9 inerrupts9
    pcm_irq9,
    ttc_irq9,
    gpio_irq9,
    uart0_irq9,
    uart1_irq9,
    spi_irq9,
    DMA_irq9,      
    macb0_int9,
    macb1_int9,
    macb2_int9,
    macb3_int9,
   
    // Scan9 ports9
    scan_en9,      // Scan9 enable pin9
    scan_in_19,    // Scan9 input for first chain9
    scan_in_29,    // Scan9 input for second chain9
    scan_mode9,
    scan_out_19,   // Scan9 out for chain9 1
    scan_out_29    // Scan9 out for chain9 2
);

parameter GPIO_WIDTH9 = 16;        // GPIO9 width
parameter P_SIZE9 =   8;              // number9 of peripheral9 select9 lines9
parameter NO_OF_IRQS9  = 17;      //No of irqs9 read by apic9 

// AHB9 interface
input         hclk9;     // AHB9 Clock9
input         n_hreset9;  // AHB9 reset - Active9 low9
input         hsel9;     // AHB2APB9 select9
input [31:0]  haddr9;    // Address bus
input [1:0]   htrans9;   // Transfer9 type
input [2:0]   hsize9;    // AHB9 Access type - byte, half9-word9, word9
input [31:0]  hwdata9;   // Write data
input         hwrite9;   // Write signal9/
input         hready_in9;// Indicates9 that last master9 has finished9 bus access
input [2:0]   hburst9;     // Burst type
input [3:0]   hprot9;      // Protection9 control9
input [3:0]   hmaster9;    // Master9 select9
input         hmastlock9;  // Locked9 transfer9
output [31:0] hrdata9;       // Read data provided from target slave9
output        hready9;       // Ready9 for new bus cycle from target slave9
output [1:0]  hresp9;       // Response9 from the bridge9
    
// APB9 system interface
input         pclk9;     // APB9 Clock9. 
input         n_preset9;  // APB9 reset - Active9 low9
   
// SPI9 ports9
input     n_ss_in9;      // select9 input to slave9
input     mi9;           // data input to master9
input     si9;           // data input to slave9
input     sclk_in9;      // clock9 input to slave9
output    so;                    // data output from slave9
output    mo9;                    // data output from master9
output    sclk_out9;              // clock9 output from master9
output [P_SIZE9-1:0] n_ss_out9;    // peripheral9 select9 lines9 from master9
output    n_so_en9;               // out enable for slave9 data
output    n_mo_en9;               // out enable for master9 data
output    n_sclk_en9;             // out enable for master9 clock9
output    n_ss_en9;               // out enable for master9 peripheral9 lines9

//UART09 ports9
input        ua_rxd9;       // UART9 receiver9 serial9 input pin9
input        ua_ncts9;      // Clear-To9-Send9 flow9 control9
output       ua_txd9;       	// UART9 transmitter9 serial9 output
output       ua_nrts9;      	// Request9-To9-Send9 flow9 control9

// UART19 ports9   
input        ua_rxd19;      // UART9 receiver9 serial9 input pin9
input        ua_ncts19;      // Clear-To9-Send9 flow9 control9
output       ua_txd19;       // UART9 transmitter9 serial9 output
output       ua_nrts19;      // Request9-To9-Send9 flow9 control9

//GPIO9 ports9
input [GPIO_WIDTH9-1:0]      gpio_pin_in9;             // input data from pin9
output [GPIO_WIDTH9-1:0]     n_gpio_pin_oe9;           // output enable signal9 to pin9
output [GPIO_WIDTH9-1:0]     gpio_pin_out9;            // output signal9 to pin9
  
//SMC9 ports9
input        smc_hclk9;
input        smc_n_hclk9;
input [31:0] smc_haddr9;
input [1:0]  smc_htrans9;
input        smc_hsel9;
input        smc_hwrite9;
input [2:0]  smc_hsize9;
input [31:0] smc_hwdata9;
input        smc_hready_in9;
input [2:0]  smc_hburst9;     // Burst type
input [3:0]  smc_hprot9;      // Protection9 control9
input [3:0]  smc_hmaster9;    // Master9 select9
input        smc_hmastlock9;  // Locked9 transfer9
input [31:0] data_smc9;     // EMI9(External9 memory) read data
output [31:0]    smc_hrdata9;
output           smc_hready9;
output [1:0]     smc_hresp9;
output [15:0]    smc_addr9;      // External9 Memory (EMI9) address
output [3:0]     smc_n_be9;      // EMI9 byte enables9 (Active9 LOW9)
output           smc_n_cs9;      // EMI9 Chip9 Selects9 (Active9 LOW9)
output [3:0]     smc_n_we9;      // EMI9 write strobes9 (Active9 LOW9)
output           smc_n_wr9;      // EMI9 write enable (Active9 LOW9)
output           smc_n_rd9;      // EMI9 read stobe9 (Active9 LOW9)
output           smc_n_ext_oe9;  // EMI9 write data output enable
output [31:0]    smc_data9;      // EMI9 write data
       
//PMC9 ports9
output clk_SRPG_macb0_en9;
output clk_SRPG_macb1_en9;
output clk_SRPG_macb2_en9;
output clk_SRPG_macb3_en9;
output core06v9;
output core08v9;
output core10v9;
output core12v9;
output mte_smc_start9;
output mte_uart_start9;
output mte_smc_uart_start9;  
output mte_pm_smc_to_default_start9; 
output mte_pm_uart_to_default_start9;
output mte_pm_smc_uart_to_default_start9;
input macb3_wakeup9;
input macb2_wakeup9;
input macb1_wakeup9;
input macb0_wakeup9;
    

// Peripheral9 interrupts9
output pcm_irq9;
output [2:0] ttc_irq9;
output gpio_irq9;
output uart0_irq9;
output uart1_irq9;
output spi_irq9;
input        macb0_int9;
input        macb1_int9;
input        macb2_int9;
input        macb3_int9;
input        DMA_irq9;
  
//Scan9 ports9
input        scan_en9;    // Scan9 enable pin9
input        scan_in_19;  // Scan9 input for first chain9
input        scan_in_29;  // Scan9 input for second chain9
input        scan_mode9;  // test mode pin9
 output        scan_out_19;   // Scan9 out for chain9 1
 output        scan_out_29;   // Scan9 out for chain9 2  

//------------------------------------------------------------------------------
// if the ROM9 subsystem9 is NOT9 black9 boxed9 
//------------------------------------------------------------------------------
`ifndef FV_KIT_BLACK_BOX_APB_SUBSYSTEM9
   
   wire        hsel9; 
   wire        pclk9;
   wire        n_preset9;
   wire [31:0] prdata_spi9;
   wire [31:0] prdata_uart09;
   wire [31:0] prdata_gpio9;
   wire [31:0] prdata_ttc9;
   wire [31:0] prdata_smc9;
   wire [31:0] prdata_pmc9;
   wire [31:0] prdata_uart19;
   wire        pready_spi9;
   wire        pready_uart09;
   wire        pready_uart19;
   wire        tie_hi_bit9;
   wire  [31:0] hrdata9; 
   wire         hready9;
   wire         hready_in9;
   wire  [1:0]  hresp9;   
   wire  [31:0] pwdata9;  
   wire         pwrite9;
   wire  [31:0] paddr9;  
   wire   psel_spi9;
   wire   psel_uart09;
   wire   psel_gpio9;
   wire   psel_ttc9;
   wire   psel_smc9;
   wire   psel079;
   wire   psel089;
   wire   psel099;
   wire   psel109;
   wire   psel119;
   wire   psel129;
   wire   psel_pmc9;
   wire   psel_uart19;
   wire   penable9;
   wire   [NO_OF_IRQS9:0] int_source9;     // System9 Interrupt9 Sources9
   wire [1:0]             smc_hresp9;     // AHB9 Response9 signal9
   wire                   smc_valid9;     // Ack9 valid address

  //External9 memory interface (EMI9)
  wire [31:0]            smc_addr_int9;  // External9 Memory (EMI9) address
  wire [3:0]             smc_n_be9;      // EMI9 byte enables9 (Active9 LOW9)
  wire                   smc_n_cs9;      // EMI9 Chip9 Selects9 (Active9 LOW9)
  wire [3:0]             smc_n_we9;      // EMI9 write strobes9 (Active9 LOW9)
  wire                   smc_n_wr9;      // EMI9 write enable (Active9 LOW9)
  wire                   smc_n_rd9;      // EMI9 read stobe9 (Active9 LOW9)
 
  //AHB9 Memory Interface9 Control9
  wire                   smc_hsel_int9;
  wire                   smc_busy9;      // smc9 busy
   

//scan9 signals9

   wire                scan_in_19;        //scan9 input
   wire                scan_in_29;        //scan9 input
   wire                scan_en9;         //scan9 enable
   wire                scan_out_19;       //scan9 output
   wire                scan_out_29;       //scan9 output
   wire                byte_sel9;     // byte select9 from bridge9 1=byte, 0=2byte
   wire                UART_int9;     // UART9 module interrupt9 
   wire                ua_uclken9;    // Soft9 control9 of clock9
   wire                UART_int19;     // UART9 module interrupt9 
   wire                ua_uclken19;    // Soft9 control9 of clock9
   wire  [3:1]         TTC_int9;            //Interrupt9 from PCI9 
  // inputs9 to SPI9 
   wire    ext_clk9;                // external9 clock9
   wire    SPI_int9;             // interrupt9 request
  // outputs9 from SPI9
   wire    slave_out_clk9;         // modified slave9 clock9 output
 // gpio9 generic9 inputs9 
   wire  [GPIO_WIDTH9-1:0]   n_gpio_bypass_oe9;        // bypass9 mode enable 
   wire  [GPIO_WIDTH9-1:0]   gpio_bypass_out9;         // bypass9 mode output value 
   wire  [GPIO_WIDTH9-1:0]   tri_state_enable9;   // disables9 op enable -> z 
 // outputs9 
   //amba9 outputs9 
   // gpio9 generic9 outputs9 
   wire       GPIO_int9;                // gpio_interupt9 for input pin9 change 
   wire [GPIO_WIDTH9-1:0]     gpio_bypass_in9;          // bypass9 mode input data value  
                
   wire           cpu_debug9;        // Inhibits9 watchdog9 counter 
   wire            ex_wdz_n9;         // External9 Watchdog9 zero indication9
   wire           rstn_non_srpg_smc9; 
   wire           rstn_non_srpg_urt9;
   wire           isolate_smc9;
   wire           save_edge_smc9;
   wire           restore_edge_smc9;
   wire           save_edge_urt9;
   wire           restore_edge_urt9;
   wire           pwr1_on_smc9;
   wire           pwr2_on_smc9;
   wire           pwr1_on_urt9;
   wire           pwr2_on_urt9;
   // ETH09
   wire            rstn_non_srpg_macb09;
   wire            gate_clk_macb09;
   wire            isolate_macb09;
   wire            save_edge_macb09;
   wire            restore_edge_macb09;
   wire            pwr1_on_macb09;
   wire            pwr2_on_macb09;
   // ETH19
   wire            rstn_non_srpg_macb19;
   wire            gate_clk_macb19;
   wire            isolate_macb19;
   wire            save_edge_macb19;
   wire            restore_edge_macb19;
   wire            pwr1_on_macb19;
   wire            pwr2_on_macb19;
   // ETH29
   wire            rstn_non_srpg_macb29;
   wire            gate_clk_macb29;
   wire            isolate_macb29;
   wire            save_edge_macb29;
   wire            restore_edge_macb29;
   wire            pwr1_on_macb29;
   wire            pwr2_on_macb29;
   // ETH39
   wire            rstn_non_srpg_macb39;
   wire            gate_clk_macb39;
   wire            isolate_macb39;
   wire            save_edge_macb39;
   wire            restore_edge_macb39;
   wire            pwr1_on_macb39;
   wire            pwr2_on_macb39;


   wire           pclk_SRPG_smc9;
   wire           pclk_SRPG_urt9;
   wire           gate_clk_smc9;
   wire           gate_clk_urt9;
   wire  [31:0]   tie_lo_32bit9; 
   wire  [1:0]	  tie_lo_2bit9;
   wire  	  tie_lo_1bit9;
   wire           pcm_macb_wakeup_int9;
   wire           int_source_h9;
   wire           isolate_mem9;

assign pcm_irq9 = pcm_macb_wakeup_int9;
assign ttc_irq9[2] = TTC_int9[3];
assign ttc_irq9[1] = TTC_int9[2];
assign ttc_irq9[0] = TTC_int9[1];
assign gpio_irq9 = GPIO_int9;
assign uart0_irq9 = UART_int9;
assign uart1_irq9 = UART_int19;
assign spi_irq9 = SPI_int9;

assign n_mo_en9   = 1'b0;
assign n_so_en9   = 1'b1;
assign n_sclk_en9 = 1'b0;
assign n_ss_en9   = 1'b0;

assign smc_hsel_int9 = smc_hsel9;
  assign ext_clk9  = 1'b0;
  assign int_source9 = {macb0_int9,macb1_int9, macb2_int9, macb3_int9,1'b0, pcm_macb_wakeup_int9, 1'b0, 1'b0, 1'b0, 1'b0, TTC_int9, GPIO_int9, UART_int9, UART_int19, SPI_int9, DMA_irq9};

  // interrupt9 even9 detect9 .
  // for sleep9 wake9 up -> any interrupt9 even9 and system not in hibernation9 (isolate_mem9 = 0)
  // for hibernate9 wake9 up -> gpio9 interrupt9 even9 and system in the hibernation9 (isolate_mem9 = 1)
  assign int_source_h9 =  ((|int_source9) && (!isolate_mem9)) || (isolate_mem9 && GPIO_int9) ;

  assign byte_sel9 = 1'b1;
  assign tie_hi_bit9 = 1'b1;

  assign smc_addr9 = smc_addr_int9[15:0];



  assign  n_gpio_bypass_oe9 = {GPIO_WIDTH9{1'b0}};        // bypass9 mode enable 
  assign  gpio_bypass_out9  = {GPIO_WIDTH9{1'b0}};
  assign  tri_state_enable9 = {GPIO_WIDTH9{1'b0}};
  assign  cpu_debug9 = 1'b0;
  assign  tie_lo_32bit9 = 32'b0;
  assign  tie_lo_2bit9  = 2'b0;
  assign  tie_lo_1bit9  = 1'b0;


ahb2apb9 #(
  32'h00800000, // Slave9 0 Address Range9
  32'h0080FFFF,

  32'h00810000, // Slave9 1 Address Range9
  32'h0081FFFF,

  32'h00820000, // Slave9 2 Address Range9 
  32'h0082FFFF,

  32'h00830000, // Slave9 3 Address Range9
  32'h0083FFFF,

  32'h00840000, // Slave9 4 Address Range9
  32'h0084FFFF,

  32'h00850000, // Slave9 5 Address Range9
  32'h0085FFFF,

  32'h00860000, // Slave9 6 Address Range9
  32'h0086FFFF,

  32'h00870000, // Slave9 7 Address Range9
  32'h0087FFFF,

  32'h00880000, // Slave9 8 Address Range9
  32'h0088FFFF
) i_ahb2apb9 (
     // AHB9 interface
    .hclk9(hclk9),         
    .hreset_n9(n_hreset9), 
    .hsel9(hsel9), 
    .haddr9(haddr9),        
    .htrans9(htrans9),       
    .hwrite9(hwrite9),       
    .hwdata9(hwdata9),       
    .hrdata9(hrdata9),   
    .hready9(hready9),   
    .hresp9(hresp9),     
    
     // APB9 interface
    .pclk9(pclk9),         
    .preset_n9(n_preset9),  
    .prdata09(prdata_spi9),
    .prdata19(prdata_uart09), 
    .prdata29(prdata_gpio9),  
    .prdata39(prdata_ttc9),   
    .prdata49(32'h0),   
    .prdata59(prdata_smc9),   
    .prdata69(prdata_pmc9),    
    .prdata79(32'h0),   
    .prdata89(prdata_uart19),  
    .pready09(pready_spi9),     
    .pready19(pready_uart09),   
    .pready29(tie_hi_bit9),     
    .pready39(tie_hi_bit9),     
    .pready49(tie_hi_bit9),     
    .pready59(tie_hi_bit9),     
    .pready69(tie_hi_bit9),     
    .pready79(tie_hi_bit9),     
    .pready89(pready_uart19),  
    .pwdata9(pwdata9),       
    .pwrite9(pwrite9),       
    .paddr9(paddr9),        
    .psel09(psel_spi9),     
    .psel19(psel_uart09),   
    .psel29(psel_gpio9),    
    .psel39(psel_ttc9),     
    .psel49(),     
    .psel59(psel_smc9),     
    .psel69(psel_pmc9),    
    .psel79(psel_apic9),   
    .psel89(psel_uart19),  
    .penable9(penable9)     
);

spi_top9 i_spi9
(
  // Wishbone9 signals9
  .wb_clk_i9(pclk9), 
  .wb_rst_i9(~n_preset9), 
  .wb_adr_i9(paddr9[4:0]), 
  .wb_dat_i9(pwdata9), 
  .wb_dat_o9(prdata_spi9), 
  .wb_sel_i9(4'b1111),    // SPI9 register accesses are always 32-bit
  .wb_we_i9(pwrite9), 
  .wb_stb_i9(psel_spi9), 
  .wb_cyc_i9(psel_spi9), 
  .wb_ack_o9(pready_spi9), 
  .wb_err_o9(), 
  .wb_int_o9(SPI_int9),

  // SPI9 signals9
  .ss_pad_o9(n_ss_out9), 
  .sclk_pad_o9(sclk_out9), 
  .mosi_pad_o9(mo9), 
  .miso_pad_i9(mi9)
);

// Opencores9 UART9 instances9
wire ua_nrts_int9;
wire ua_nrts1_int9;

assign ua_nrts9 = ua_nrts_int9;
assign ua_nrts19 = ua_nrts1_int9;

reg [3:0] uart0_sel_i9;
reg [3:0] uart1_sel_i9;
// UART9 registers are all 8-bit wide9, and their9 addresses9
// are on byte boundaries9. So9 to access them9 on the
// Wishbone9 bus, the CPU9 must do byte accesses to these9
// byte addresses9. Word9 address accesses are not possible9
// because the word9 addresses9 will be unaligned9, and cause
// a fault9.
// So9, Uart9 accesses from the CPU9 will always be 8-bit size
// We9 only have to decide9 which byte of the 4-byte word9 the
// CPU9 is interested9 in.
`ifdef SYSTEM_BIG_ENDIAN9
always @(paddr9) begin
  case (paddr9[1:0])
    2'b00 : uart0_sel_i9 = 4'b1000;
    2'b01 : uart0_sel_i9 = 4'b0100;
    2'b10 : uart0_sel_i9 = 4'b0010;
    2'b11 : uart0_sel_i9 = 4'b0001;
  endcase
end
always @(paddr9) begin
  case (paddr9[1:0])
    2'b00 : uart1_sel_i9 = 4'b1000;
    2'b01 : uart1_sel_i9 = 4'b0100;
    2'b10 : uart1_sel_i9 = 4'b0010;
    2'b11 : uart1_sel_i9 = 4'b0001;
  endcase
end
`else
always @(paddr9) begin
  case (paddr9[1:0])
    2'b00 : uart0_sel_i9 = 4'b0001;
    2'b01 : uart0_sel_i9 = 4'b0010;
    2'b10 : uart0_sel_i9 = 4'b0100;
    2'b11 : uart0_sel_i9 = 4'b1000;
  endcase
end
always @(paddr9) begin
  case (paddr9[1:0])
    2'b00 : uart1_sel_i9 = 4'b0001;
    2'b01 : uart1_sel_i9 = 4'b0010;
    2'b10 : uart1_sel_i9 = 4'b0100;
    2'b11 : uart1_sel_i9 = 4'b1000;
  endcase
end
`endif

uart_top9 i_oc_uart09 (
  .wb_clk_i9(pclk9),
  .wb_rst_i9(~n_preset9),
  .wb_adr_i9(paddr9[4:0]),
  .wb_dat_i9(pwdata9),
  .wb_dat_o9(prdata_uart09),
  .wb_we_i9(pwrite9),
  .wb_stb_i9(psel_uart09),
  .wb_cyc_i9(psel_uart09),
  .wb_ack_o9(pready_uart09),
  .wb_sel_i9(uart0_sel_i9),
  .int_o9(UART_int9),
  .stx_pad_o9(ua_txd9),
  .srx_pad_i9(ua_rxd9),
  .rts_pad_o9(ua_nrts_int9),
  .cts_pad_i9(ua_ncts9),
  .dtr_pad_o9(),
  .dsr_pad_i9(1'b0),
  .ri_pad_i9(1'b0),
  .dcd_pad_i9(1'b0)
);

uart_top9 i_oc_uart19 (
  .wb_clk_i9(pclk9),
  .wb_rst_i9(~n_preset9),
  .wb_adr_i9(paddr9[4:0]),
  .wb_dat_i9(pwdata9),
  .wb_dat_o9(prdata_uart19),
  .wb_we_i9(pwrite9),
  .wb_stb_i9(psel_uart19),
  .wb_cyc_i9(psel_uart19),
  .wb_ack_o9(pready_uart19),
  .wb_sel_i9(uart1_sel_i9),
  .int_o9(UART_int19),
  .stx_pad_o9(ua_txd19),
  .srx_pad_i9(ua_rxd19),
  .rts_pad_o9(ua_nrts1_int9),
  .cts_pad_i9(ua_ncts19),
  .dtr_pad_o9(),
  .dsr_pad_i9(1'b0),
  .ri_pad_i9(1'b0),
  .dcd_pad_i9(1'b0)
);

gpio_veneer9 i_gpio_veneer9 (
        //inputs9

        . n_p_reset9(n_preset9),
        . pclk9(pclk9),
        . psel9(psel_gpio9),
        . penable9(penable9),
        . pwrite9(pwrite9),
        . paddr9(paddr9[5:0]),
        . pwdata9(pwdata9),
        . gpio_pin_in9(gpio_pin_in9),
        . scan_en9(scan_en9),
        . tri_state_enable9(tri_state_enable9),
        . scan_in9(), //added by smarkov9 for dft9

        //outputs9
        . scan_out9(), //added by smarkov9 for dft9
        . prdata9(prdata_gpio9),
        . gpio_int9(GPIO_int9),
        . n_gpio_pin_oe9(n_gpio_pin_oe9),
        . gpio_pin_out9(gpio_pin_out9)
);


ttc_veneer9 i_ttc_veneer9 (

         //inputs9
        . n_p_reset9(n_preset9),
        . pclk9(pclk9),
        . psel9(psel_ttc9),
        . penable9(penable9),
        . pwrite9(pwrite9),
        . pwdata9(pwdata9),
        . paddr9(paddr9[7:0]),
        . scan_in9(),
        . scan_en9(scan_en9),

        //outputs9
        . prdata9(prdata_ttc9),
        . interrupt9(TTC_int9[3:1]),
        . scan_out9()
);


smc_veneer9 i_smc_veneer9 (
        //inputs9
	//apb9 inputs9
        . n_preset9(n_preset9),
        . pclk9(pclk_SRPG_smc9),
        . psel9(psel_smc9),
        . penable9(penable9),
        . pwrite9(pwrite9),
        . paddr9(paddr9[4:0]),
        . pwdata9(pwdata9),
        //ahb9 inputs9
	. hclk9(smc_hclk9),
        . n_sys_reset9(rstn_non_srpg_smc9),
        . haddr9(smc_haddr9),
        . htrans9(smc_htrans9),
        . hsel9(smc_hsel_int9),
        . hwrite9(smc_hwrite9),
	. hsize9(smc_hsize9),
        . hwdata9(smc_hwdata9),
        . hready9(smc_hready_in9),
        . data_smc9(data_smc9),

         //test signal9 inputs9

        . scan_in_19(),
        . scan_in_29(),
        . scan_in_39(),
        . scan_en9(scan_en9),

        //apb9 outputs9
        . prdata9(prdata_smc9),

       //design output

        . smc_hrdata9(smc_hrdata9),
        . smc_hready9(smc_hready9),
        . smc_hresp9(smc_hresp9),
        . smc_valid9(smc_valid9),
        . smc_addr9(smc_addr_int9),
        . smc_data9(smc_data9),
        . smc_n_be9(smc_n_be9),
        . smc_n_cs9(smc_n_cs9),
        . smc_n_wr9(smc_n_wr9),
        . smc_n_we9(smc_n_we9),
        . smc_n_rd9(smc_n_rd9),
        . smc_n_ext_oe9(smc_n_ext_oe9),
        . smc_busy9(smc_busy9),

         //test signal9 output
        . scan_out_19(),
        . scan_out_29(),
        . scan_out_39()
);

power_ctrl_veneer9 i_power_ctrl_veneer9 (
    // -- Clocks9 & Reset9
    	.pclk9(pclk9), 			//  : in  std_logic9;
    	.nprst9(n_preset9), 		//  : in  std_logic9;
    // -- APB9 programming9 interface
    	.paddr9(paddr9), 			//  : in  std_logic_vector9(31 downto9 0);
    	.psel9(psel_pmc9), 			//  : in  std_logic9;
    	.penable9(penable9), 		//  : in  std_logic9;
    	.pwrite9(pwrite9), 		//  : in  std_logic9;
    	.pwdata9(pwdata9), 		//  : in  std_logic_vector9(31 downto9 0);
    	.prdata9(prdata_pmc9), 		//  : out std_logic_vector9(31 downto9 0);
        .macb3_wakeup9(macb3_wakeup9),
        .macb2_wakeup9(macb2_wakeup9),
        .macb1_wakeup9(macb1_wakeup9),
        .macb0_wakeup9(macb0_wakeup9),
    // -- Module9 control9 outputs9
    	.scan_in9(),			//  : in  std_logic9;
    	.scan_en9(scan_en9),             	//  : in  std_logic9;
    	.scan_mode9(scan_mode9),          //  : in  std_logic9;
    	.scan_out9(),            	//  : out std_logic9;
        .int_source_h9(int_source_h9),
     	.rstn_non_srpg_smc9(rstn_non_srpg_smc9), 		//   : out std_logic9;
    	.gate_clk_smc9(gate_clk_smc9), 	//  : out std_logic9;
    	.isolate_smc9(isolate_smc9), 	//  : out std_logic9;
    	.save_edge_smc9(save_edge_smc9), 	//  : out std_logic9;
    	.restore_edge_smc9(restore_edge_smc9), 	//  : out std_logic9;
    	.pwr1_on_smc9(pwr1_on_smc9), 	//  : out std_logic9;
    	.pwr2_on_smc9(pwr2_on_smc9), 	//  : out std_logic9
     	.rstn_non_srpg_urt9(rstn_non_srpg_urt9), 		//   : out std_logic9;
    	.gate_clk_urt9(gate_clk_urt9), 	//  : out std_logic9;
    	.isolate_urt9(isolate_urt9), 	//  : out std_logic9;
    	.save_edge_urt9(save_edge_urt9), 	//  : out std_logic9;
    	.restore_edge_urt9(restore_edge_urt9), 	//  : out std_logic9;
    	.pwr1_on_urt9(pwr1_on_urt9), 	//  : out std_logic9;
    	.pwr2_on_urt9(pwr2_on_urt9),  	//  : out std_logic9
        // ETH09
        .rstn_non_srpg_macb09(rstn_non_srpg_macb09),
        .gate_clk_macb09(gate_clk_macb09),
        .isolate_macb09(isolate_macb09),
        .save_edge_macb09(save_edge_macb09),
        .restore_edge_macb09(restore_edge_macb09),
        .pwr1_on_macb09(pwr1_on_macb09),
        .pwr2_on_macb09(pwr2_on_macb09),
        // ETH19
        .rstn_non_srpg_macb19(rstn_non_srpg_macb19),
        .gate_clk_macb19(gate_clk_macb19),
        .isolate_macb19(isolate_macb19),
        .save_edge_macb19(save_edge_macb19),
        .restore_edge_macb19(restore_edge_macb19),
        .pwr1_on_macb19(pwr1_on_macb19),
        .pwr2_on_macb19(pwr2_on_macb19),
        // ETH29
        .rstn_non_srpg_macb29(rstn_non_srpg_macb29),
        .gate_clk_macb29(gate_clk_macb29),
        .isolate_macb29(isolate_macb29),
        .save_edge_macb29(save_edge_macb29),
        .restore_edge_macb29(restore_edge_macb29),
        .pwr1_on_macb29(pwr1_on_macb29),
        .pwr2_on_macb29(pwr2_on_macb29),
        // ETH39
        .rstn_non_srpg_macb39(rstn_non_srpg_macb39),
        .gate_clk_macb39(gate_clk_macb39),
        .isolate_macb39(isolate_macb39),
        .save_edge_macb39(save_edge_macb39),
        .restore_edge_macb39(restore_edge_macb39),
        .pwr1_on_macb39(pwr1_on_macb39),
        .pwr2_on_macb39(pwr2_on_macb39),
        .core06v9(core06v9),
        .core08v9(core08v9),
        .core10v9(core10v9),
        .core12v9(core12v9),
        .pcm_macb_wakeup_int9(pcm_macb_wakeup_int9),
        .isolate_mem9(isolate_mem9),
        .mte_smc_start9(mte_smc_start9),
        .mte_uart_start9(mte_uart_start9),
        .mte_smc_uart_start9(mte_smc_uart_start9),  
        .mte_pm_smc_to_default_start9(mte_pm_smc_to_default_start9), 
        .mte_pm_uart_to_default_start9(mte_pm_uart_to_default_start9),
        .mte_pm_smc_uart_to_default_start9(mte_pm_smc_uart_to_default_start9)
);

// Clock9 gating9 macro9 to shut9 off9 clocks9 to the SRPG9 flops9 in the SMC9
//CKLNQD19 i_SMC_SRPG_clk_gate9  (
//	.TE9(scan_mode9), 
//	.E9(~gate_clk_smc9), 
//	.CP9(pclk9), 
//	.Q9(pclk_SRPG_smc9)
//	);
// Replace9 gate9 with behavioural9 code9 //
wire 	smc_scan_gate9;
reg 	smc_latched_enable9;
assign smc_scan_gate9 = scan_mode9 ? 1'b1 : ~gate_clk_smc9;

always @ (pclk9 or smc_scan_gate9)
  	if (pclk9 == 1'b0) begin
  		smc_latched_enable9 <= smc_scan_gate9;
  	end  	
	
assign pclk_SRPG_smc9 = smc_latched_enable9 ? pclk9 : 1'b0;


// Clock9 gating9 macro9 to shut9 off9 clocks9 to the SRPG9 flops9 in the URT9
//CKLNQD19 i_URT_SRPG_clk_gate9  (
//	.TE9(scan_mode9), 
//	.E9(~gate_clk_urt9), 
//	.CP9(pclk9), 
//	.Q9(pclk_SRPG_urt9)
//	);
// Replace9 gate9 with behavioural9 code9 //
wire 	urt_scan_gate9;
reg 	urt_latched_enable9;
assign urt_scan_gate9 = scan_mode9 ? 1'b1 : ~gate_clk_urt9;

always @ (pclk9 or urt_scan_gate9)
  	if (pclk9 == 1'b0) begin
  		urt_latched_enable9 <= urt_scan_gate9;
  	end  	
	
assign pclk_SRPG_urt9 = urt_latched_enable9 ? pclk9 : 1'b0;

// ETH09
wire 	macb0_scan_gate9;
reg 	macb0_latched_enable9;
assign macb0_scan_gate9 = scan_mode9 ? 1'b1 : ~gate_clk_macb09;

always @ (pclk9 or macb0_scan_gate9)
  	if (pclk9 == 1'b0) begin
  		macb0_latched_enable9 <= macb0_scan_gate9;
  	end  	
	
assign clk_SRPG_macb0_en9 = macb0_latched_enable9 ? 1'b1 : 1'b0;

// ETH19
wire 	macb1_scan_gate9;
reg 	macb1_latched_enable9;
assign macb1_scan_gate9 = scan_mode9 ? 1'b1 : ~gate_clk_macb19;

always @ (pclk9 or macb1_scan_gate9)
  	if (pclk9 == 1'b0) begin
  		macb1_latched_enable9 <= macb1_scan_gate9;
  	end  	
	
assign clk_SRPG_macb1_en9 = macb1_latched_enable9 ? 1'b1 : 1'b0;

// ETH29
wire 	macb2_scan_gate9;
reg 	macb2_latched_enable9;
assign macb2_scan_gate9 = scan_mode9 ? 1'b1 : ~gate_clk_macb29;

always @ (pclk9 or macb2_scan_gate9)
  	if (pclk9 == 1'b0) begin
  		macb2_latched_enable9 <= macb2_scan_gate9;
  	end  	
	
assign clk_SRPG_macb2_en9 = macb2_latched_enable9 ? 1'b1 : 1'b0;

// ETH39
wire 	macb3_scan_gate9;
reg 	macb3_latched_enable9;
assign macb3_scan_gate9 = scan_mode9 ? 1'b1 : ~gate_clk_macb39;

always @ (pclk9 or macb3_scan_gate9)
  	if (pclk9 == 1'b0) begin
  		macb3_latched_enable9 <= macb3_scan_gate9;
  	end  	
	
assign clk_SRPG_macb3_en9 = macb3_latched_enable9 ? 1'b1 : 1'b0;



`else
//------------------------------------------------------------------------------
// if the APB9 subsystem9 is black9 boxed9 
//------------------------------------------------------------------------------
// wire s ports9
    // system signals9
    wire         hclk9;     // AHB9 Clock9
    wire         n_hreset9;  // AHB9 reset - Active9 low9
    wire         pclk9;     // APB9 Clock9. 
    wire         n_preset9;  // APB9 reset - Active9 low9

    // AHB9 interface
    wire         ahb2apb0_hsel9;     // AHB2APB9 select9
    wire  [31:0] haddr9;    // Address bus
    wire  [1:0]  htrans9;   // Transfer9 type
    wire  [2:0]  hsize9;    // AHB9 Access type - byte, half9-word9, word9
    wire  [31:0] hwdata9;   // Write data
    wire         hwrite9;   // Write signal9/
    wire         hready_in9;// Indicates9 that last master9 has finished9 bus access
    wire [2:0]   hburst9;     // Burst type
    wire [3:0]   hprot9;      // Protection9 control9
    wire [3:0]   hmaster9;    // Master9 select9
    wire         hmastlock9;  // Locked9 transfer9
  // Interrupts9 from the Enet9 MACs9
    wire         macb0_int9;
    wire         macb1_int9;
    wire         macb2_int9;
    wire         macb3_int9;
  // Interrupt9 from the DMA9
    wire         DMA_irq9;
  // Scan9 wire s
    wire         scan_en9;    // Scan9 enable pin9
    wire         scan_in_19;  // Scan9 wire  for first chain9
    wire         scan_in_29;  // Scan9 wire  for second chain9
    wire         scan_mode9;  // test mode pin9
 
  //wire  for smc9 AHB9 interface
    wire         smc_hclk9;
    wire         smc_n_hclk9;
    wire  [31:0] smc_haddr9;
    wire  [1:0]  smc_htrans9;
    wire         smc_hsel9;
    wire         smc_hwrite9;
    wire  [2:0]  smc_hsize9;
    wire  [31:0] smc_hwdata9;
    wire         smc_hready_in9;
    wire  [2:0]  smc_hburst9;     // Burst type
    wire  [3:0]  smc_hprot9;      // Protection9 control9
    wire  [3:0]  smc_hmaster9;    // Master9 select9
    wire         smc_hmastlock9;  // Locked9 transfer9


    wire  [31:0] data_smc9;     // EMI9(External9 memory) read data
    
  //wire s for uart9
    wire         ua_rxd9;       // UART9 receiver9 serial9 wire  pin9
    wire         ua_rxd19;      // UART9 receiver9 serial9 wire  pin9
    wire         ua_ncts9;      // Clear-To9-Send9 flow9 control9
    wire         ua_ncts19;      // Clear-To9-Send9 flow9 control9
   //wire s for spi9
    wire         n_ss_in9;      // select9 wire  to slave9
    wire         mi9;           // data wire  to master9
    wire         si9;           // data wire  to slave9
    wire         sclk_in9;      // clock9 wire  to slave9
  //wire s for GPIO9
   wire  [GPIO_WIDTH9-1:0]  gpio_pin_in9;             // wire  data from pin9

  //reg    ports9
  // Scan9 reg   s
   reg           scan_out_19;   // Scan9 out for chain9 1
   reg           scan_out_29;   // Scan9 out for chain9 2
  //AHB9 interface 
   reg    [31:0] hrdata9;       // Read data provided from target slave9
   reg           hready9;       // Ready9 for new bus cycle from target slave9
   reg    [1:0]  hresp9;       // Response9 from the bridge9

   // SMC9 reg    for AHB9 interface
   reg    [31:0]    smc_hrdata9;
   reg              smc_hready9;
   reg    [1:0]     smc_hresp9;

  //reg   s from smc9
   reg    [15:0]    smc_addr9;      // External9 Memory (EMI9) address
   reg    [3:0]     smc_n_be9;      // EMI9 byte enables9 (Active9 LOW9)
   reg    [7:0]     smc_n_cs9;      // EMI9 Chip9 Selects9 (Active9 LOW9)
   reg    [3:0]     smc_n_we9;      // EMI9 write strobes9 (Active9 LOW9)
   reg              smc_n_wr9;      // EMI9 write enable (Active9 LOW9)
   reg              smc_n_rd9;      // EMI9 read stobe9 (Active9 LOW9)
   reg              smc_n_ext_oe9;  // EMI9 write data reg    enable
   reg    [31:0]    smc_data9;      // EMI9 write data
  //reg   s from uart9
   reg           ua_txd9;       	// UART9 transmitter9 serial9 reg   
   reg           ua_txd19;       // UART9 transmitter9 serial9 reg   
   reg           ua_nrts9;      	// Request9-To9-Send9 flow9 control9
   reg           ua_nrts19;      // Request9-To9-Send9 flow9 control9
   // reg   s from ttc9
  // reg   s from SPI9
   reg       so;                    // data reg    from slave9
   reg       mo9;                    // data reg    from master9
   reg       sclk_out9;              // clock9 reg    from master9
   reg    [P_SIZE9-1:0] n_ss_out9;    // peripheral9 select9 lines9 from master9
   reg       n_so_en9;               // out enable for slave9 data
   reg       n_mo_en9;               // out enable for master9 data
   reg       n_sclk_en9;             // out enable for master9 clock9
   reg       n_ss_en9;               // out enable for master9 peripheral9 lines9
  //reg   s from gpio9
   reg    [GPIO_WIDTH9-1:0]     n_gpio_pin_oe9;           // reg    enable signal9 to pin9
   reg    [GPIO_WIDTH9-1:0]     gpio_pin_out9;            // reg    signal9 to pin9


`endif
//------------------------------------------------------------------------------
// black9 boxed9 defines9 
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// APB9 and AHB9 interface formal9 verification9 monitors9
//------------------------------------------------------------------------------
`ifdef ABV_ON9
apb_assert9 i_apb_assert9 (

        // APB9 signals9
  	.n_preset9(n_preset9),
   	.pclk9(pclk9),
	.penable9(penable9),
	.paddr9(paddr9),
	.pwrite9(pwrite9),
	.pwdata9(pwdata9),

	.psel009(psel_spi9),
	.psel019(psel_uart09),
	.psel029(psel_gpio9),
	.psel039(psel_ttc9),
	.psel049(1'b0),
	.psel059(psel_smc9),
	.psel069(1'b0),
	.psel079(1'b0),
	.psel089(1'b0),
	.psel099(1'b0),
	.psel109(1'b0),
	.psel119(1'b0),
	.psel129(1'b0),
	.psel139(psel_pmc9),
	.psel149(psel_apic9),
	.psel159(psel_uart19),

        .prdata009(prdata_spi9),
        .prdata019(prdata_uart09), // Read Data from peripheral9 UART9 
        .prdata029(prdata_gpio9), // Read Data from peripheral9 GPIO9
        .prdata039(prdata_ttc9), // Read Data from peripheral9 TTC9
        .prdata049(32'b0), // 
        .prdata059(prdata_smc9), // Read Data from peripheral9 SMC9
        .prdata139(prdata_pmc9), // Read Data from peripheral9 Power9 Control9 Block
   	.prdata149(32'b0), // 
        .prdata159(prdata_uart19),


        // AHB9 signals9
        .hclk9(hclk9),         // ahb9 system clock9
        .n_hreset9(n_hreset9), // ahb9 system reset

        // ahb2apb9 signals9
        .hresp9(hresp9),
        .hready9(hready9),
        .hrdata9(hrdata9),
        .hwdata9(hwdata9),
        .hprot9(hprot9),
        .hburst9(hburst9),
        .hsize9(hsize9),
        .hwrite9(hwrite9),
        .htrans9(htrans9),
        .haddr9(haddr9),
        .ahb2apb_hsel9(ahb2apb0_hsel9));



//------------------------------------------------------------------------------
// AHB9 interface formal9 verification9 monitor9
//------------------------------------------------------------------------------
defparam i_ahbSlaveMonitor9.DBUS_WIDTH9 = 32;
defparam i_ahbMasterMonitor9.DBUS_WIDTH9 = 32;


// AHB2APB9 Bridge9

    ahb_liteslave_monitor9 i_ahbSlaveMonitor9 (
        .hclk_i9(hclk9),
        .hresetn_i9(n_hreset9),
        .hresp9(hresp9),
        .hready9(hready9),
        .hready_global_i9(hready9),
        .hrdata9(hrdata9),
        .hwdata_i9(hwdata9),
        .hburst_i9(hburst9),
        .hsize_i9(hsize9),
        .hwrite_i9(hwrite9),
        .htrans_i9(htrans9),
        .haddr_i9(haddr9),
        .hsel_i9(ahb2apb0_hsel9)
    );


  ahb_litemaster_monitor9 i_ahbMasterMonitor9 (
          .hclk_i9(hclk9),
          .hresetn_i9(n_hreset9),
          .hresp_i9(hresp9),
          .hready_i9(hready9),
          .hrdata_i9(hrdata9),
          .hlock9(1'b0),
          .hwdata9(hwdata9),
          .hprot9(hprot9),
          .hburst9(hburst9),
          .hsize9(hsize9),
          .hwrite9(hwrite9),
          .htrans9(htrans9),
          .haddr9(haddr9)
          );







`endif




`ifdef IFV_LP_ABV_ON9
// power9 control9
wire isolate9;

// testbench mirror signals9
wire L1_ctrl_access9;
wire L1_status_access9;

wire [31:0] L1_status_reg9;
wire [31:0] L1_ctrl_reg9;

//wire rstn_non_srpg_urt9;
//wire isolate_urt9;
//wire retain_urt9;
//wire gate_clk_urt9;
//wire pwr1_on_urt9;


// smc9 signals9
wire [31:0] smc_prdata9;
wire lp_clk_smc9;
                    

// uart9 isolation9 register
  wire [15:0] ua_prdata9;
  wire ua_int9;
  assign ua_prdata9          =  i_uart1_veneer9.prdata9;
  assign ua_int9             =  i_uart1_veneer9.ua_int9;


assign lp_clk_smc9          = i_smc_veneer9.pclk9;
assign smc_prdata9          = i_smc_veneer9.prdata9;
lp_chk_smc9 u_lp_chk_smc9 (
    .clk9 (hclk9),
    .rst9 (n_hreset9),
    .iso_smc9 (isolate_smc9),
    .gate_clk9 (gate_clk_smc9),
    .lp_clk9 (pclk_SRPG_smc9),

    // srpg9 outputs9
    .smc_hrdata9 (smc_hrdata9),
    .smc_hready9 (smc_hready9),
    .smc_hresp9  (smc_hresp9),
    .smc_valid9 (smc_valid9),
    .smc_addr_int9 (smc_addr_int9),
    .smc_data9 (smc_data9),
    .smc_n_be9 (smc_n_be9),
    .smc_n_cs9  (smc_n_cs9),
    .smc_n_wr9 (smc_n_wr9),
    .smc_n_we9 (smc_n_we9),
    .smc_n_rd9 (smc_n_rd9),
    .smc_n_ext_oe9 (smc_n_ext_oe9)
   );

// lp9 retention9/isolation9 assertions9
lp_chk_uart9 u_lp_chk_urt9 (

  .clk9         (hclk9),
  .rst9         (n_hreset9),
  .iso_urt9     (isolate_urt9),
  .gate_clk9    (gate_clk_urt9),
  .lp_clk9      (pclk_SRPG_urt9),
  //ports9
  .prdata9 (ua_prdata9),
  .ua_int9 (ua_int9),
  .ua_txd9 (ua_txd19),
  .ua_nrts9 (ua_nrts19)
 );

`endif  //IFV_LP_ABV_ON9




endmodule
