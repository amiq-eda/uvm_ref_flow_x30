//File13 name   : apb_subsystem_013.v
//Title13       : 
//Created13     : 1999
//Description13 : 
//Notes13       : 
//----------------------------------------------------------------------
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------

module apb_subsystem_013(
    // AHB13 interface
    hclk13,
    n_hreset13,
    hsel13,
    haddr13,
    htrans13,
    hsize13,
    hwrite13,
    hwdata13,
    hready_in13,
    hburst13,
    hprot13,
    hmaster13,
    hmastlock13,
    hrdata13,
    hready13,
    hresp13,
    
    // APB13 system interface
    pclk13,
    n_preset13,
    
    // SPI13 ports13
    n_ss_in13,
    mi13,
    si13,
    sclk_in13,
    so,
    mo13,
    sclk_out13,
    n_ss_out13,
    n_so_en13,
    n_mo_en13,
    n_sclk_en13,
    n_ss_en13,
    
    //UART013 ports13
    ua_rxd13,
    ua_ncts13,
    ua_txd13,
    ua_nrts13,
    
    //UART113 ports13
    ua_rxd113,
    ua_ncts113,
    ua_txd113,
    ua_nrts113,
    
    //GPIO13 ports13
    gpio_pin_in13,
    n_gpio_pin_oe13,
    gpio_pin_out13,
    

    //SMC13 ports13
    smc_hclk13,
    smc_n_hclk13,
    smc_haddr13,
    smc_htrans13,
    smc_hsel13,
    smc_hwrite13,
    smc_hsize13,
    smc_hwdata13,
    smc_hready_in13,
    smc_hburst13,
    smc_hprot13,
    smc_hmaster13,
    smc_hmastlock13,
    smc_hrdata13, 
    smc_hready13,
    smc_hresp13,
    smc_n_ext_oe13,
    smc_data13,
    smc_addr13,
    smc_n_be13,
    smc_n_cs13, 
    smc_n_we13,
    smc_n_wr13,
    smc_n_rd13,
    data_smc13,
    
    //PMC13 ports13
    clk_SRPG_macb0_en13,
    clk_SRPG_macb1_en13,
    clk_SRPG_macb2_en13,
    clk_SRPG_macb3_en13,
    core06v13,
    core08v13,
    core10v13,
    core12v13,
    macb3_wakeup13,
    macb2_wakeup13,
    macb1_wakeup13,
    macb0_wakeup13,
    mte_smc_start13,
    mte_uart_start13,
    mte_smc_uart_start13,  
    mte_pm_smc_to_default_start13, 
    mte_pm_uart_to_default_start13,
    mte_pm_smc_uart_to_default_start13,
    
    
    // Peripheral13 inerrupts13
    pcm_irq13,
    ttc_irq13,
    gpio_irq13,
    uart0_irq13,
    uart1_irq13,
    spi_irq13,
    DMA_irq13,      
    macb0_int13,
    macb1_int13,
    macb2_int13,
    macb3_int13,
   
    // Scan13 ports13
    scan_en13,      // Scan13 enable pin13
    scan_in_113,    // Scan13 input for first chain13
    scan_in_213,    // Scan13 input for second chain13
    scan_mode13,
    scan_out_113,   // Scan13 out for chain13 1
    scan_out_213    // Scan13 out for chain13 2
);

parameter GPIO_WIDTH13 = 16;        // GPIO13 width
parameter P_SIZE13 =   8;              // number13 of peripheral13 select13 lines13
parameter NO_OF_IRQS13  = 17;      //No of irqs13 read by apic13 

// AHB13 interface
input         hclk13;     // AHB13 Clock13
input         n_hreset13;  // AHB13 reset - Active13 low13
input         hsel13;     // AHB2APB13 select13
input [31:0]  haddr13;    // Address bus
input [1:0]   htrans13;   // Transfer13 type
input [2:0]   hsize13;    // AHB13 Access type - byte, half13-word13, word13
input [31:0]  hwdata13;   // Write data
input         hwrite13;   // Write signal13/
input         hready_in13;// Indicates13 that last master13 has finished13 bus access
input [2:0]   hburst13;     // Burst type
input [3:0]   hprot13;      // Protection13 control13
input [3:0]   hmaster13;    // Master13 select13
input         hmastlock13;  // Locked13 transfer13
output [31:0] hrdata13;       // Read data provided from target slave13
output        hready13;       // Ready13 for new bus cycle from target slave13
output [1:0]  hresp13;       // Response13 from the bridge13
    
// APB13 system interface
input         pclk13;     // APB13 Clock13. 
input         n_preset13;  // APB13 reset - Active13 low13
   
// SPI13 ports13
input     n_ss_in13;      // select13 input to slave13
input     mi13;           // data input to master13
input     si13;           // data input to slave13
input     sclk_in13;      // clock13 input to slave13
output    so;                    // data output from slave13
output    mo13;                    // data output from master13
output    sclk_out13;              // clock13 output from master13
output [P_SIZE13-1:0] n_ss_out13;    // peripheral13 select13 lines13 from master13
output    n_so_en13;               // out enable for slave13 data
output    n_mo_en13;               // out enable for master13 data
output    n_sclk_en13;             // out enable for master13 clock13
output    n_ss_en13;               // out enable for master13 peripheral13 lines13

//UART013 ports13
input        ua_rxd13;       // UART13 receiver13 serial13 input pin13
input        ua_ncts13;      // Clear-To13-Send13 flow13 control13
output       ua_txd13;       	// UART13 transmitter13 serial13 output
output       ua_nrts13;      	// Request13-To13-Send13 flow13 control13

// UART113 ports13   
input        ua_rxd113;      // UART13 receiver13 serial13 input pin13
input        ua_ncts113;      // Clear-To13-Send13 flow13 control13
output       ua_txd113;       // UART13 transmitter13 serial13 output
output       ua_nrts113;      // Request13-To13-Send13 flow13 control13

//GPIO13 ports13
input [GPIO_WIDTH13-1:0]      gpio_pin_in13;             // input data from pin13
output [GPIO_WIDTH13-1:0]     n_gpio_pin_oe13;           // output enable signal13 to pin13
output [GPIO_WIDTH13-1:0]     gpio_pin_out13;            // output signal13 to pin13
  
//SMC13 ports13
input        smc_hclk13;
input        smc_n_hclk13;
input [31:0] smc_haddr13;
input [1:0]  smc_htrans13;
input        smc_hsel13;
input        smc_hwrite13;
input [2:0]  smc_hsize13;
input [31:0] smc_hwdata13;
input        smc_hready_in13;
input [2:0]  smc_hburst13;     // Burst type
input [3:0]  smc_hprot13;      // Protection13 control13
input [3:0]  smc_hmaster13;    // Master13 select13
input        smc_hmastlock13;  // Locked13 transfer13
input [31:0] data_smc13;     // EMI13(External13 memory) read data
output [31:0]    smc_hrdata13;
output           smc_hready13;
output [1:0]     smc_hresp13;
output [15:0]    smc_addr13;      // External13 Memory (EMI13) address
output [3:0]     smc_n_be13;      // EMI13 byte enables13 (Active13 LOW13)
output           smc_n_cs13;      // EMI13 Chip13 Selects13 (Active13 LOW13)
output [3:0]     smc_n_we13;      // EMI13 write strobes13 (Active13 LOW13)
output           smc_n_wr13;      // EMI13 write enable (Active13 LOW13)
output           smc_n_rd13;      // EMI13 read stobe13 (Active13 LOW13)
output           smc_n_ext_oe13;  // EMI13 write data output enable
output [31:0]    smc_data13;      // EMI13 write data
       
//PMC13 ports13
output clk_SRPG_macb0_en13;
output clk_SRPG_macb1_en13;
output clk_SRPG_macb2_en13;
output clk_SRPG_macb3_en13;
output core06v13;
output core08v13;
output core10v13;
output core12v13;
output mte_smc_start13;
output mte_uart_start13;
output mte_smc_uart_start13;  
output mte_pm_smc_to_default_start13; 
output mte_pm_uart_to_default_start13;
output mte_pm_smc_uart_to_default_start13;
input macb3_wakeup13;
input macb2_wakeup13;
input macb1_wakeup13;
input macb0_wakeup13;
    

// Peripheral13 interrupts13
output pcm_irq13;
output [2:0] ttc_irq13;
output gpio_irq13;
output uart0_irq13;
output uart1_irq13;
output spi_irq13;
input        macb0_int13;
input        macb1_int13;
input        macb2_int13;
input        macb3_int13;
input        DMA_irq13;
  
//Scan13 ports13
input        scan_en13;    // Scan13 enable pin13
input        scan_in_113;  // Scan13 input for first chain13
input        scan_in_213;  // Scan13 input for second chain13
input        scan_mode13;  // test mode pin13
 output        scan_out_113;   // Scan13 out for chain13 1
 output        scan_out_213;   // Scan13 out for chain13 2  

//------------------------------------------------------------------------------
// if the ROM13 subsystem13 is NOT13 black13 boxed13 
//------------------------------------------------------------------------------
`ifndef FV_KIT_BLACK_BOX_APB_SUBSYSTEM13
   
   wire        hsel13; 
   wire        pclk13;
   wire        n_preset13;
   wire [31:0] prdata_spi13;
   wire [31:0] prdata_uart013;
   wire [31:0] prdata_gpio13;
   wire [31:0] prdata_ttc13;
   wire [31:0] prdata_smc13;
   wire [31:0] prdata_pmc13;
   wire [31:0] prdata_uart113;
   wire        pready_spi13;
   wire        pready_uart013;
   wire        pready_uart113;
   wire        tie_hi_bit13;
   wire  [31:0] hrdata13; 
   wire         hready13;
   wire         hready_in13;
   wire  [1:0]  hresp13;   
   wire  [31:0] pwdata13;  
   wire         pwrite13;
   wire  [31:0] paddr13;  
   wire   psel_spi13;
   wire   psel_uart013;
   wire   psel_gpio13;
   wire   psel_ttc13;
   wire   psel_smc13;
   wire   psel0713;
   wire   psel0813;
   wire   psel0913;
   wire   psel1013;
   wire   psel1113;
   wire   psel1213;
   wire   psel_pmc13;
   wire   psel_uart113;
   wire   penable13;
   wire   [NO_OF_IRQS13:0] int_source13;     // System13 Interrupt13 Sources13
   wire [1:0]             smc_hresp13;     // AHB13 Response13 signal13
   wire                   smc_valid13;     // Ack13 valid address

  //External13 memory interface (EMI13)
  wire [31:0]            smc_addr_int13;  // External13 Memory (EMI13) address
  wire [3:0]             smc_n_be13;      // EMI13 byte enables13 (Active13 LOW13)
  wire                   smc_n_cs13;      // EMI13 Chip13 Selects13 (Active13 LOW13)
  wire [3:0]             smc_n_we13;      // EMI13 write strobes13 (Active13 LOW13)
  wire                   smc_n_wr13;      // EMI13 write enable (Active13 LOW13)
  wire                   smc_n_rd13;      // EMI13 read stobe13 (Active13 LOW13)
 
  //AHB13 Memory Interface13 Control13
  wire                   smc_hsel_int13;
  wire                   smc_busy13;      // smc13 busy
   

//scan13 signals13

   wire                scan_in_113;        //scan13 input
   wire                scan_in_213;        //scan13 input
   wire                scan_en13;         //scan13 enable
   wire                scan_out_113;       //scan13 output
   wire                scan_out_213;       //scan13 output
   wire                byte_sel13;     // byte select13 from bridge13 1=byte, 0=2byte
   wire                UART_int13;     // UART13 module interrupt13 
   wire                ua_uclken13;    // Soft13 control13 of clock13
   wire                UART_int113;     // UART13 module interrupt13 
   wire                ua_uclken113;    // Soft13 control13 of clock13
   wire  [3:1]         TTC_int13;            //Interrupt13 from PCI13 
  // inputs13 to SPI13 
   wire    ext_clk13;                // external13 clock13
   wire    SPI_int13;             // interrupt13 request
  // outputs13 from SPI13
   wire    slave_out_clk13;         // modified slave13 clock13 output
 // gpio13 generic13 inputs13 
   wire  [GPIO_WIDTH13-1:0]   n_gpio_bypass_oe13;        // bypass13 mode enable 
   wire  [GPIO_WIDTH13-1:0]   gpio_bypass_out13;         // bypass13 mode output value 
   wire  [GPIO_WIDTH13-1:0]   tri_state_enable13;   // disables13 op enable -> z 
 // outputs13 
   //amba13 outputs13 
   // gpio13 generic13 outputs13 
   wire       GPIO_int13;                // gpio_interupt13 for input pin13 change 
   wire [GPIO_WIDTH13-1:0]     gpio_bypass_in13;          // bypass13 mode input data value  
                
   wire           cpu_debug13;        // Inhibits13 watchdog13 counter 
   wire            ex_wdz_n13;         // External13 Watchdog13 zero indication13
   wire           rstn_non_srpg_smc13; 
   wire           rstn_non_srpg_urt13;
   wire           isolate_smc13;
   wire           save_edge_smc13;
   wire           restore_edge_smc13;
   wire           save_edge_urt13;
   wire           restore_edge_urt13;
   wire           pwr1_on_smc13;
   wire           pwr2_on_smc13;
   wire           pwr1_on_urt13;
   wire           pwr2_on_urt13;
   // ETH013
   wire            rstn_non_srpg_macb013;
   wire            gate_clk_macb013;
   wire            isolate_macb013;
   wire            save_edge_macb013;
   wire            restore_edge_macb013;
   wire            pwr1_on_macb013;
   wire            pwr2_on_macb013;
   // ETH113
   wire            rstn_non_srpg_macb113;
   wire            gate_clk_macb113;
   wire            isolate_macb113;
   wire            save_edge_macb113;
   wire            restore_edge_macb113;
   wire            pwr1_on_macb113;
   wire            pwr2_on_macb113;
   // ETH213
   wire            rstn_non_srpg_macb213;
   wire            gate_clk_macb213;
   wire            isolate_macb213;
   wire            save_edge_macb213;
   wire            restore_edge_macb213;
   wire            pwr1_on_macb213;
   wire            pwr2_on_macb213;
   // ETH313
   wire            rstn_non_srpg_macb313;
   wire            gate_clk_macb313;
   wire            isolate_macb313;
   wire            save_edge_macb313;
   wire            restore_edge_macb313;
   wire            pwr1_on_macb313;
   wire            pwr2_on_macb313;


   wire           pclk_SRPG_smc13;
   wire           pclk_SRPG_urt13;
   wire           gate_clk_smc13;
   wire           gate_clk_urt13;
   wire  [31:0]   tie_lo_32bit13; 
   wire  [1:0]	  tie_lo_2bit13;
   wire  	  tie_lo_1bit13;
   wire           pcm_macb_wakeup_int13;
   wire           int_source_h13;
   wire           isolate_mem13;

assign pcm_irq13 = pcm_macb_wakeup_int13;
assign ttc_irq13[2] = TTC_int13[3];
assign ttc_irq13[1] = TTC_int13[2];
assign ttc_irq13[0] = TTC_int13[1];
assign gpio_irq13 = GPIO_int13;
assign uart0_irq13 = UART_int13;
assign uart1_irq13 = UART_int113;
assign spi_irq13 = SPI_int13;

assign n_mo_en13   = 1'b0;
assign n_so_en13   = 1'b1;
assign n_sclk_en13 = 1'b0;
assign n_ss_en13   = 1'b0;

assign smc_hsel_int13 = smc_hsel13;
  assign ext_clk13  = 1'b0;
  assign int_source13 = {macb0_int13,macb1_int13, macb2_int13, macb3_int13,1'b0, pcm_macb_wakeup_int13, 1'b0, 1'b0, 1'b0, 1'b0, TTC_int13, GPIO_int13, UART_int13, UART_int113, SPI_int13, DMA_irq13};

  // interrupt13 even13 detect13 .
  // for sleep13 wake13 up -> any interrupt13 even13 and system not in hibernation13 (isolate_mem13 = 0)
  // for hibernate13 wake13 up -> gpio13 interrupt13 even13 and system in the hibernation13 (isolate_mem13 = 1)
  assign int_source_h13 =  ((|int_source13) && (!isolate_mem13)) || (isolate_mem13 && GPIO_int13) ;

  assign byte_sel13 = 1'b1;
  assign tie_hi_bit13 = 1'b1;

  assign smc_addr13 = smc_addr_int13[15:0];



  assign  n_gpio_bypass_oe13 = {GPIO_WIDTH13{1'b0}};        // bypass13 mode enable 
  assign  gpio_bypass_out13  = {GPIO_WIDTH13{1'b0}};
  assign  tri_state_enable13 = {GPIO_WIDTH13{1'b0}};
  assign  cpu_debug13 = 1'b0;
  assign  tie_lo_32bit13 = 32'b0;
  assign  tie_lo_2bit13  = 2'b0;
  assign  tie_lo_1bit13  = 1'b0;


ahb2apb13 #(
  32'h00800000, // Slave13 0 Address Range13
  32'h0080FFFF,

  32'h00810000, // Slave13 1 Address Range13
  32'h0081FFFF,

  32'h00820000, // Slave13 2 Address Range13 
  32'h0082FFFF,

  32'h00830000, // Slave13 3 Address Range13
  32'h0083FFFF,

  32'h00840000, // Slave13 4 Address Range13
  32'h0084FFFF,

  32'h00850000, // Slave13 5 Address Range13
  32'h0085FFFF,

  32'h00860000, // Slave13 6 Address Range13
  32'h0086FFFF,

  32'h00870000, // Slave13 7 Address Range13
  32'h0087FFFF,

  32'h00880000, // Slave13 8 Address Range13
  32'h0088FFFF
) i_ahb2apb13 (
     // AHB13 interface
    .hclk13(hclk13),         
    .hreset_n13(n_hreset13), 
    .hsel13(hsel13), 
    .haddr13(haddr13),        
    .htrans13(htrans13),       
    .hwrite13(hwrite13),       
    .hwdata13(hwdata13),       
    .hrdata13(hrdata13),   
    .hready13(hready13),   
    .hresp13(hresp13),     
    
     // APB13 interface
    .pclk13(pclk13),         
    .preset_n13(n_preset13),  
    .prdata013(prdata_spi13),
    .prdata113(prdata_uart013), 
    .prdata213(prdata_gpio13),  
    .prdata313(prdata_ttc13),   
    .prdata413(32'h0),   
    .prdata513(prdata_smc13),   
    .prdata613(prdata_pmc13),    
    .prdata713(32'h0),   
    .prdata813(prdata_uart113),  
    .pready013(pready_spi13),     
    .pready113(pready_uart013),   
    .pready213(tie_hi_bit13),     
    .pready313(tie_hi_bit13),     
    .pready413(tie_hi_bit13),     
    .pready513(tie_hi_bit13),     
    .pready613(tie_hi_bit13),     
    .pready713(tie_hi_bit13),     
    .pready813(pready_uart113),  
    .pwdata13(pwdata13),       
    .pwrite13(pwrite13),       
    .paddr13(paddr13),        
    .psel013(psel_spi13),     
    .psel113(psel_uart013),   
    .psel213(psel_gpio13),    
    .psel313(psel_ttc13),     
    .psel413(),     
    .psel513(psel_smc13),     
    .psel613(psel_pmc13),    
    .psel713(psel_apic13),   
    .psel813(psel_uart113),  
    .penable13(penable13)     
);

spi_top13 i_spi13
(
  // Wishbone13 signals13
  .wb_clk_i13(pclk13), 
  .wb_rst_i13(~n_preset13), 
  .wb_adr_i13(paddr13[4:0]), 
  .wb_dat_i13(pwdata13), 
  .wb_dat_o13(prdata_spi13), 
  .wb_sel_i13(4'b1111),    // SPI13 register accesses are always 32-bit
  .wb_we_i13(pwrite13), 
  .wb_stb_i13(psel_spi13), 
  .wb_cyc_i13(psel_spi13), 
  .wb_ack_o13(pready_spi13), 
  .wb_err_o13(), 
  .wb_int_o13(SPI_int13),

  // SPI13 signals13
  .ss_pad_o13(n_ss_out13), 
  .sclk_pad_o13(sclk_out13), 
  .mosi_pad_o13(mo13), 
  .miso_pad_i13(mi13)
);

// Opencores13 UART13 instances13
wire ua_nrts_int13;
wire ua_nrts1_int13;

assign ua_nrts13 = ua_nrts_int13;
assign ua_nrts113 = ua_nrts1_int13;

reg [3:0] uart0_sel_i13;
reg [3:0] uart1_sel_i13;
// UART13 registers are all 8-bit wide13, and their13 addresses13
// are on byte boundaries13. So13 to access them13 on the
// Wishbone13 bus, the CPU13 must do byte accesses to these13
// byte addresses13. Word13 address accesses are not possible13
// because the word13 addresses13 will be unaligned13, and cause
// a fault13.
// So13, Uart13 accesses from the CPU13 will always be 8-bit size
// We13 only have to decide13 which byte of the 4-byte word13 the
// CPU13 is interested13 in.
`ifdef SYSTEM_BIG_ENDIAN13
always @(paddr13) begin
  case (paddr13[1:0])
    2'b00 : uart0_sel_i13 = 4'b1000;
    2'b01 : uart0_sel_i13 = 4'b0100;
    2'b10 : uart0_sel_i13 = 4'b0010;
    2'b11 : uart0_sel_i13 = 4'b0001;
  endcase
end
always @(paddr13) begin
  case (paddr13[1:0])
    2'b00 : uart1_sel_i13 = 4'b1000;
    2'b01 : uart1_sel_i13 = 4'b0100;
    2'b10 : uart1_sel_i13 = 4'b0010;
    2'b11 : uart1_sel_i13 = 4'b0001;
  endcase
end
`else
always @(paddr13) begin
  case (paddr13[1:0])
    2'b00 : uart0_sel_i13 = 4'b0001;
    2'b01 : uart0_sel_i13 = 4'b0010;
    2'b10 : uart0_sel_i13 = 4'b0100;
    2'b11 : uart0_sel_i13 = 4'b1000;
  endcase
end
always @(paddr13) begin
  case (paddr13[1:0])
    2'b00 : uart1_sel_i13 = 4'b0001;
    2'b01 : uart1_sel_i13 = 4'b0010;
    2'b10 : uart1_sel_i13 = 4'b0100;
    2'b11 : uart1_sel_i13 = 4'b1000;
  endcase
end
`endif

uart_top13 i_oc_uart013 (
  .wb_clk_i13(pclk13),
  .wb_rst_i13(~n_preset13),
  .wb_adr_i13(paddr13[4:0]),
  .wb_dat_i13(pwdata13),
  .wb_dat_o13(prdata_uart013),
  .wb_we_i13(pwrite13),
  .wb_stb_i13(psel_uart013),
  .wb_cyc_i13(psel_uart013),
  .wb_ack_o13(pready_uart013),
  .wb_sel_i13(uart0_sel_i13),
  .int_o13(UART_int13),
  .stx_pad_o13(ua_txd13),
  .srx_pad_i13(ua_rxd13),
  .rts_pad_o13(ua_nrts_int13),
  .cts_pad_i13(ua_ncts13),
  .dtr_pad_o13(),
  .dsr_pad_i13(1'b0),
  .ri_pad_i13(1'b0),
  .dcd_pad_i13(1'b0)
);

uart_top13 i_oc_uart113 (
  .wb_clk_i13(pclk13),
  .wb_rst_i13(~n_preset13),
  .wb_adr_i13(paddr13[4:0]),
  .wb_dat_i13(pwdata13),
  .wb_dat_o13(prdata_uart113),
  .wb_we_i13(pwrite13),
  .wb_stb_i13(psel_uart113),
  .wb_cyc_i13(psel_uart113),
  .wb_ack_o13(pready_uart113),
  .wb_sel_i13(uart1_sel_i13),
  .int_o13(UART_int113),
  .stx_pad_o13(ua_txd113),
  .srx_pad_i13(ua_rxd113),
  .rts_pad_o13(ua_nrts1_int13),
  .cts_pad_i13(ua_ncts113),
  .dtr_pad_o13(),
  .dsr_pad_i13(1'b0),
  .ri_pad_i13(1'b0),
  .dcd_pad_i13(1'b0)
);

gpio_veneer13 i_gpio_veneer13 (
        //inputs13

        . n_p_reset13(n_preset13),
        . pclk13(pclk13),
        . psel13(psel_gpio13),
        . penable13(penable13),
        . pwrite13(pwrite13),
        . paddr13(paddr13[5:0]),
        . pwdata13(pwdata13),
        . gpio_pin_in13(gpio_pin_in13),
        . scan_en13(scan_en13),
        . tri_state_enable13(tri_state_enable13),
        . scan_in13(), //added by smarkov13 for dft13

        //outputs13
        . scan_out13(), //added by smarkov13 for dft13
        . prdata13(prdata_gpio13),
        . gpio_int13(GPIO_int13),
        . n_gpio_pin_oe13(n_gpio_pin_oe13),
        . gpio_pin_out13(gpio_pin_out13)
);


ttc_veneer13 i_ttc_veneer13 (

         //inputs13
        . n_p_reset13(n_preset13),
        . pclk13(pclk13),
        . psel13(psel_ttc13),
        . penable13(penable13),
        . pwrite13(pwrite13),
        . pwdata13(pwdata13),
        . paddr13(paddr13[7:0]),
        . scan_in13(),
        . scan_en13(scan_en13),

        //outputs13
        . prdata13(prdata_ttc13),
        . interrupt13(TTC_int13[3:1]),
        . scan_out13()
);


smc_veneer13 i_smc_veneer13 (
        //inputs13
	//apb13 inputs13
        . n_preset13(n_preset13),
        . pclk13(pclk_SRPG_smc13),
        . psel13(psel_smc13),
        . penable13(penable13),
        . pwrite13(pwrite13),
        . paddr13(paddr13[4:0]),
        . pwdata13(pwdata13),
        //ahb13 inputs13
	. hclk13(smc_hclk13),
        . n_sys_reset13(rstn_non_srpg_smc13),
        . haddr13(smc_haddr13),
        . htrans13(smc_htrans13),
        . hsel13(smc_hsel_int13),
        . hwrite13(smc_hwrite13),
	. hsize13(smc_hsize13),
        . hwdata13(smc_hwdata13),
        . hready13(smc_hready_in13),
        . data_smc13(data_smc13),

         //test signal13 inputs13

        . scan_in_113(),
        . scan_in_213(),
        . scan_in_313(),
        . scan_en13(scan_en13),

        //apb13 outputs13
        . prdata13(prdata_smc13),

       //design output

        . smc_hrdata13(smc_hrdata13),
        . smc_hready13(smc_hready13),
        . smc_hresp13(smc_hresp13),
        . smc_valid13(smc_valid13),
        . smc_addr13(smc_addr_int13),
        . smc_data13(smc_data13),
        . smc_n_be13(smc_n_be13),
        . smc_n_cs13(smc_n_cs13),
        . smc_n_wr13(smc_n_wr13),
        . smc_n_we13(smc_n_we13),
        . smc_n_rd13(smc_n_rd13),
        . smc_n_ext_oe13(smc_n_ext_oe13),
        . smc_busy13(smc_busy13),

         //test signal13 output
        . scan_out_113(),
        . scan_out_213(),
        . scan_out_313()
);

power_ctrl_veneer13 i_power_ctrl_veneer13 (
    // -- Clocks13 & Reset13
    	.pclk13(pclk13), 			//  : in  std_logic13;
    	.nprst13(n_preset13), 		//  : in  std_logic13;
    // -- APB13 programming13 interface
    	.paddr13(paddr13), 			//  : in  std_logic_vector13(31 downto13 0);
    	.psel13(psel_pmc13), 			//  : in  std_logic13;
    	.penable13(penable13), 		//  : in  std_logic13;
    	.pwrite13(pwrite13), 		//  : in  std_logic13;
    	.pwdata13(pwdata13), 		//  : in  std_logic_vector13(31 downto13 0);
    	.prdata13(prdata_pmc13), 		//  : out std_logic_vector13(31 downto13 0);
        .macb3_wakeup13(macb3_wakeup13),
        .macb2_wakeup13(macb2_wakeup13),
        .macb1_wakeup13(macb1_wakeup13),
        .macb0_wakeup13(macb0_wakeup13),
    // -- Module13 control13 outputs13
    	.scan_in13(),			//  : in  std_logic13;
    	.scan_en13(scan_en13),             	//  : in  std_logic13;
    	.scan_mode13(scan_mode13),          //  : in  std_logic13;
    	.scan_out13(),            	//  : out std_logic13;
        .int_source_h13(int_source_h13),
     	.rstn_non_srpg_smc13(rstn_non_srpg_smc13), 		//   : out std_logic13;
    	.gate_clk_smc13(gate_clk_smc13), 	//  : out std_logic13;
    	.isolate_smc13(isolate_smc13), 	//  : out std_logic13;
    	.save_edge_smc13(save_edge_smc13), 	//  : out std_logic13;
    	.restore_edge_smc13(restore_edge_smc13), 	//  : out std_logic13;
    	.pwr1_on_smc13(pwr1_on_smc13), 	//  : out std_logic13;
    	.pwr2_on_smc13(pwr2_on_smc13), 	//  : out std_logic13
     	.rstn_non_srpg_urt13(rstn_non_srpg_urt13), 		//   : out std_logic13;
    	.gate_clk_urt13(gate_clk_urt13), 	//  : out std_logic13;
    	.isolate_urt13(isolate_urt13), 	//  : out std_logic13;
    	.save_edge_urt13(save_edge_urt13), 	//  : out std_logic13;
    	.restore_edge_urt13(restore_edge_urt13), 	//  : out std_logic13;
    	.pwr1_on_urt13(pwr1_on_urt13), 	//  : out std_logic13;
    	.pwr2_on_urt13(pwr2_on_urt13),  	//  : out std_logic13
        // ETH013
        .rstn_non_srpg_macb013(rstn_non_srpg_macb013),
        .gate_clk_macb013(gate_clk_macb013),
        .isolate_macb013(isolate_macb013),
        .save_edge_macb013(save_edge_macb013),
        .restore_edge_macb013(restore_edge_macb013),
        .pwr1_on_macb013(pwr1_on_macb013),
        .pwr2_on_macb013(pwr2_on_macb013),
        // ETH113
        .rstn_non_srpg_macb113(rstn_non_srpg_macb113),
        .gate_clk_macb113(gate_clk_macb113),
        .isolate_macb113(isolate_macb113),
        .save_edge_macb113(save_edge_macb113),
        .restore_edge_macb113(restore_edge_macb113),
        .pwr1_on_macb113(pwr1_on_macb113),
        .pwr2_on_macb113(pwr2_on_macb113),
        // ETH213
        .rstn_non_srpg_macb213(rstn_non_srpg_macb213),
        .gate_clk_macb213(gate_clk_macb213),
        .isolate_macb213(isolate_macb213),
        .save_edge_macb213(save_edge_macb213),
        .restore_edge_macb213(restore_edge_macb213),
        .pwr1_on_macb213(pwr1_on_macb213),
        .pwr2_on_macb213(pwr2_on_macb213),
        // ETH313
        .rstn_non_srpg_macb313(rstn_non_srpg_macb313),
        .gate_clk_macb313(gate_clk_macb313),
        .isolate_macb313(isolate_macb313),
        .save_edge_macb313(save_edge_macb313),
        .restore_edge_macb313(restore_edge_macb313),
        .pwr1_on_macb313(pwr1_on_macb313),
        .pwr2_on_macb313(pwr2_on_macb313),
        .core06v13(core06v13),
        .core08v13(core08v13),
        .core10v13(core10v13),
        .core12v13(core12v13),
        .pcm_macb_wakeup_int13(pcm_macb_wakeup_int13),
        .isolate_mem13(isolate_mem13),
        .mte_smc_start13(mte_smc_start13),
        .mte_uart_start13(mte_uart_start13),
        .mte_smc_uart_start13(mte_smc_uart_start13),  
        .mte_pm_smc_to_default_start13(mte_pm_smc_to_default_start13), 
        .mte_pm_uart_to_default_start13(mte_pm_uart_to_default_start13),
        .mte_pm_smc_uart_to_default_start13(mte_pm_smc_uart_to_default_start13)
);

// Clock13 gating13 macro13 to shut13 off13 clocks13 to the SRPG13 flops13 in the SMC13
//CKLNQD113 i_SMC_SRPG_clk_gate13  (
//	.TE13(scan_mode13), 
//	.E13(~gate_clk_smc13), 
//	.CP13(pclk13), 
//	.Q13(pclk_SRPG_smc13)
//	);
// Replace13 gate13 with behavioural13 code13 //
wire 	smc_scan_gate13;
reg 	smc_latched_enable13;
assign smc_scan_gate13 = scan_mode13 ? 1'b1 : ~gate_clk_smc13;

always @ (pclk13 or smc_scan_gate13)
  	if (pclk13 == 1'b0) begin
  		smc_latched_enable13 <= smc_scan_gate13;
  	end  	
	
assign pclk_SRPG_smc13 = smc_latched_enable13 ? pclk13 : 1'b0;


// Clock13 gating13 macro13 to shut13 off13 clocks13 to the SRPG13 flops13 in the URT13
//CKLNQD113 i_URT_SRPG_clk_gate13  (
//	.TE13(scan_mode13), 
//	.E13(~gate_clk_urt13), 
//	.CP13(pclk13), 
//	.Q13(pclk_SRPG_urt13)
//	);
// Replace13 gate13 with behavioural13 code13 //
wire 	urt_scan_gate13;
reg 	urt_latched_enable13;
assign urt_scan_gate13 = scan_mode13 ? 1'b1 : ~gate_clk_urt13;

always @ (pclk13 or urt_scan_gate13)
  	if (pclk13 == 1'b0) begin
  		urt_latched_enable13 <= urt_scan_gate13;
  	end  	
	
assign pclk_SRPG_urt13 = urt_latched_enable13 ? pclk13 : 1'b0;

// ETH013
wire 	macb0_scan_gate13;
reg 	macb0_latched_enable13;
assign macb0_scan_gate13 = scan_mode13 ? 1'b1 : ~gate_clk_macb013;

always @ (pclk13 or macb0_scan_gate13)
  	if (pclk13 == 1'b0) begin
  		macb0_latched_enable13 <= macb0_scan_gate13;
  	end  	
	
assign clk_SRPG_macb0_en13 = macb0_latched_enable13 ? 1'b1 : 1'b0;

// ETH113
wire 	macb1_scan_gate13;
reg 	macb1_latched_enable13;
assign macb1_scan_gate13 = scan_mode13 ? 1'b1 : ~gate_clk_macb113;

always @ (pclk13 or macb1_scan_gate13)
  	if (pclk13 == 1'b0) begin
  		macb1_latched_enable13 <= macb1_scan_gate13;
  	end  	
	
assign clk_SRPG_macb1_en13 = macb1_latched_enable13 ? 1'b1 : 1'b0;

// ETH213
wire 	macb2_scan_gate13;
reg 	macb2_latched_enable13;
assign macb2_scan_gate13 = scan_mode13 ? 1'b1 : ~gate_clk_macb213;

always @ (pclk13 or macb2_scan_gate13)
  	if (pclk13 == 1'b0) begin
  		macb2_latched_enable13 <= macb2_scan_gate13;
  	end  	
	
assign clk_SRPG_macb2_en13 = macb2_latched_enable13 ? 1'b1 : 1'b0;

// ETH313
wire 	macb3_scan_gate13;
reg 	macb3_latched_enable13;
assign macb3_scan_gate13 = scan_mode13 ? 1'b1 : ~gate_clk_macb313;

always @ (pclk13 or macb3_scan_gate13)
  	if (pclk13 == 1'b0) begin
  		macb3_latched_enable13 <= macb3_scan_gate13;
  	end  	
	
assign clk_SRPG_macb3_en13 = macb3_latched_enable13 ? 1'b1 : 1'b0;



`else
//------------------------------------------------------------------------------
// if the APB13 subsystem13 is black13 boxed13 
//------------------------------------------------------------------------------
// wire s ports13
    // system signals13
    wire         hclk13;     // AHB13 Clock13
    wire         n_hreset13;  // AHB13 reset - Active13 low13
    wire         pclk13;     // APB13 Clock13. 
    wire         n_preset13;  // APB13 reset - Active13 low13

    // AHB13 interface
    wire         ahb2apb0_hsel13;     // AHB2APB13 select13
    wire  [31:0] haddr13;    // Address bus
    wire  [1:0]  htrans13;   // Transfer13 type
    wire  [2:0]  hsize13;    // AHB13 Access type - byte, half13-word13, word13
    wire  [31:0] hwdata13;   // Write data
    wire         hwrite13;   // Write signal13/
    wire         hready_in13;// Indicates13 that last master13 has finished13 bus access
    wire [2:0]   hburst13;     // Burst type
    wire [3:0]   hprot13;      // Protection13 control13
    wire [3:0]   hmaster13;    // Master13 select13
    wire         hmastlock13;  // Locked13 transfer13
  // Interrupts13 from the Enet13 MACs13
    wire         macb0_int13;
    wire         macb1_int13;
    wire         macb2_int13;
    wire         macb3_int13;
  // Interrupt13 from the DMA13
    wire         DMA_irq13;
  // Scan13 wire s
    wire         scan_en13;    // Scan13 enable pin13
    wire         scan_in_113;  // Scan13 wire  for first chain13
    wire         scan_in_213;  // Scan13 wire  for second chain13
    wire         scan_mode13;  // test mode pin13
 
  //wire  for smc13 AHB13 interface
    wire         smc_hclk13;
    wire         smc_n_hclk13;
    wire  [31:0] smc_haddr13;
    wire  [1:0]  smc_htrans13;
    wire         smc_hsel13;
    wire         smc_hwrite13;
    wire  [2:0]  smc_hsize13;
    wire  [31:0] smc_hwdata13;
    wire         smc_hready_in13;
    wire  [2:0]  smc_hburst13;     // Burst type
    wire  [3:0]  smc_hprot13;      // Protection13 control13
    wire  [3:0]  smc_hmaster13;    // Master13 select13
    wire         smc_hmastlock13;  // Locked13 transfer13


    wire  [31:0] data_smc13;     // EMI13(External13 memory) read data
    
  //wire s for uart13
    wire         ua_rxd13;       // UART13 receiver13 serial13 wire  pin13
    wire         ua_rxd113;      // UART13 receiver13 serial13 wire  pin13
    wire         ua_ncts13;      // Clear-To13-Send13 flow13 control13
    wire         ua_ncts113;      // Clear-To13-Send13 flow13 control13
   //wire s for spi13
    wire         n_ss_in13;      // select13 wire  to slave13
    wire         mi13;           // data wire  to master13
    wire         si13;           // data wire  to slave13
    wire         sclk_in13;      // clock13 wire  to slave13
  //wire s for GPIO13
   wire  [GPIO_WIDTH13-1:0]  gpio_pin_in13;             // wire  data from pin13

  //reg    ports13
  // Scan13 reg   s
   reg           scan_out_113;   // Scan13 out for chain13 1
   reg           scan_out_213;   // Scan13 out for chain13 2
  //AHB13 interface 
   reg    [31:0] hrdata13;       // Read data provided from target slave13
   reg           hready13;       // Ready13 for new bus cycle from target slave13
   reg    [1:0]  hresp13;       // Response13 from the bridge13

   // SMC13 reg    for AHB13 interface
   reg    [31:0]    smc_hrdata13;
   reg              smc_hready13;
   reg    [1:0]     smc_hresp13;

  //reg   s from smc13
   reg    [15:0]    smc_addr13;      // External13 Memory (EMI13) address
   reg    [3:0]     smc_n_be13;      // EMI13 byte enables13 (Active13 LOW13)
   reg    [7:0]     smc_n_cs13;      // EMI13 Chip13 Selects13 (Active13 LOW13)
   reg    [3:0]     smc_n_we13;      // EMI13 write strobes13 (Active13 LOW13)
   reg              smc_n_wr13;      // EMI13 write enable (Active13 LOW13)
   reg              smc_n_rd13;      // EMI13 read stobe13 (Active13 LOW13)
   reg              smc_n_ext_oe13;  // EMI13 write data reg    enable
   reg    [31:0]    smc_data13;      // EMI13 write data
  //reg   s from uart13
   reg           ua_txd13;       	// UART13 transmitter13 serial13 reg   
   reg           ua_txd113;       // UART13 transmitter13 serial13 reg   
   reg           ua_nrts13;      	// Request13-To13-Send13 flow13 control13
   reg           ua_nrts113;      // Request13-To13-Send13 flow13 control13
   // reg   s from ttc13
  // reg   s from SPI13
   reg       so;                    // data reg    from slave13
   reg       mo13;                    // data reg    from master13
   reg       sclk_out13;              // clock13 reg    from master13
   reg    [P_SIZE13-1:0] n_ss_out13;    // peripheral13 select13 lines13 from master13
   reg       n_so_en13;               // out enable for slave13 data
   reg       n_mo_en13;               // out enable for master13 data
   reg       n_sclk_en13;             // out enable for master13 clock13
   reg       n_ss_en13;               // out enable for master13 peripheral13 lines13
  //reg   s from gpio13
   reg    [GPIO_WIDTH13-1:0]     n_gpio_pin_oe13;           // reg    enable signal13 to pin13
   reg    [GPIO_WIDTH13-1:0]     gpio_pin_out13;            // reg    signal13 to pin13


`endif
//------------------------------------------------------------------------------
// black13 boxed13 defines13 
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// APB13 and AHB13 interface formal13 verification13 monitors13
//------------------------------------------------------------------------------
`ifdef ABV_ON13
apb_assert13 i_apb_assert13 (

        // APB13 signals13
  	.n_preset13(n_preset13),
   	.pclk13(pclk13),
	.penable13(penable13),
	.paddr13(paddr13),
	.pwrite13(pwrite13),
	.pwdata13(pwdata13),

	.psel0013(psel_spi13),
	.psel0113(psel_uart013),
	.psel0213(psel_gpio13),
	.psel0313(psel_ttc13),
	.psel0413(1'b0),
	.psel0513(psel_smc13),
	.psel0613(1'b0),
	.psel0713(1'b0),
	.psel0813(1'b0),
	.psel0913(1'b0),
	.psel1013(1'b0),
	.psel1113(1'b0),
	.psel1213(1'b0),
	.psel1313(psel_pmc13),
	.psel1413(psel_apic13),
	.psel1513(psel_uart113),

        .prdata0013(prdata_spi13),
        .prdata0113(prdata_uart013), // Read Data from peripheral13 UART13 
        .prdata0213(prdata_gpio13), // Read Data from peripheral13 GPIO13
        .prdata0313(prdata_ttc13), // Read Data from peripheral13 TTC13
        .prdata0413(32'b0), // 
        .prdata0513(prdata_smc13), // Read Data from peripheral13 SMC13
        .prdata1313(prdata_pmc13), // Read Data from peripheral13 Power13 Control13 Block
   	.prdata1413(32'b0), // 
        .prdata1513(prdata_uart113),


        // AHB13 signals13
        .hclk13(hclk13),         // ahb13 system clock13
        .n_hreset13(n_hreset13), // ahb13 system reset

        // ahb2apb13 signals13
        .hresp13(hresp13),
        .hready13(hready13),
        .hrdata13(hrdata13),
        .hwdata13(hwdata13),
        .hprot13(hprot13),
        .hburst13(hburst13),
        .hsize13(hsize13),
        .hwrite13(hwrite13),
        .htrans13(htrans13),
        .haddr13(haddr13),
        .ahb2apb_hsel13(ahb2apb0_hsel13));



//------------------------------------------------------------------------------
// AHB13 interface formal13 verification13 monitor13
//------------------------------------------------------------------------------
defparam i_ahbSlaveMonitor13.DBUS_WIDTH13 = 32;
defparam i_ahbMasterMonitor13.DBUS_WIDTH13 = 32;


// AHB2APB13 Bridge13

    ahb_liteslave_monitor13 i_ahbSlaveMonitor13 (
        .hclk_i13(hclk13),
        .hresetn_i13(n_hreset13),
        .hresp13(hresp13),
        .hready13(hready13),
        .hready_global_i13(hready13),
        .hrdata13(hrdata13),
        .hwdata_i13(hwdata13),
        .hburst_i13(hburst13),
        .hsize_i13(hsize13),
        .hwrite_i13(hwrite13),
        .htrans_i13(htrans13),
        .haddr_i13(haddr13),
        .hsel_i13(ahb2apb0_hsel13)
    );


  ahb_litemaster_monitor13 i_ahbMasterMonitor13 (
          .hclk_i13(hclk13),
          .hresetn_i13(n_hreset13),
          .hresp_i13(hresp13),
          .hready_i13(hready13),
          .hrdata_i13(hrdata13),
          .hlock13(1'b0),
          .hwdata13(hwdata13),
          .hprot13(hprot13),
          .hburst13(hburst13),
          .hsize13(hsize13),
          .hwrite13(hwrite13),
          .htrans13(htrans13),
          .haddr13(haddr13)
          );







`endif




`ifdef IFV_LP_ABV_ON13
// power13 control13
wire isolate13;

// testbench mirror signals13
wire L1_ctrl_access13;
wire L1_status_access13;

wire [31:0] L1_status_reg13;
wire [31:0] L1_ctrl_reg13;

//wire rstn_non_srpg_urt13;
//wire isolate_urt13;
//wire retain_urt13;
//wire gate_clk_urt13;
//wire pwr1_on_urt13;


// smc13 signals13
wire [31:0] smc_prdata13;
wire lp_clk_smc13;
                    

// uart13 isolation13 register
  wire [15:0] ua_prdata13;
  wire ua_int13;
  assign ua_prdata13          =  i_uart1_veneer13.prdata13;
  assign ua_int13             =  i_uart1_veneer13.ua_int13;


assign lp_clk_smc13          = i_smc_veneer13.pclk13;
assign smc_prdata13          = i_smc_veneer13.prdata13;
lp_chk_smc13 u_lp_chk_smc13 (
    .clk13 (hclk13),
    .rst13 (n_hreset13),
    .iso_smc13 (isolate_smc13),
    .gate_clk13 (gate_clk_smc13),
    .lp_clk13 (pclk_SRPG_smc13),

    // srpg13 outputs13
    .smc_hrdata13 (smc_hrdata13),
    .smc_hready13 (smc_hready13),
    .smc_hresp13  (smc_hresp13),
    .smc_valid13 (smc_valid13),
    .smc_addr_int13 (smc_addr_int13),
    .smc_data13 (smc_data13),
    .smc_n_be13 (smc_n_be13),
    .smc_n_cs13  (smc_n_cs13),
    .smc_n_wr13 (smc_n_wr13),
    .smc_n_we13 (smc_n_we13),
    .smc_n_rd13 (smc_n_rd13),
    .smc_n_ext_oe13 (smc_n_ext_oe13)
   );

// lp13 retention13/isolation13 assertions13
lp_chk_uart13 u_lp_chk_urt13 (

  .clk13         (hclk13),
  .rst13         (n_hreset13),
  .iso_urt13     (isolate_urt13),
  .gate_clk13    (gate_clk_urt13),
  .lp_clk13      (pclk_SRPG_urt13),
  //ports13
  .prdata13 (ua_prdata13),
  .ua_int13 (ua_int13),
  .ua_txd13 (ua_txd113),
  .ua_nrts13 (ua_nrts113)
 );

`endif  //IFV_LP_ABV_ON13




endmodule
