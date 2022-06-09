//File15 name   : apb_subsystem_015.v
//Title15       : 
//Created15     : 1999
//Description15 : 
//Notes15       : 
//----------------------------------------------------------------------
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------

module apb_subsystem_015(
    // AHB15 interface
    hclk15,
    n_hreset15,
    hsel15,
    haddr15,
    htrans15,
    hsize15,
    hwrite15,
    hwdata15,
    hready_in15,
    hburst15,
    hprot15,
    hmaster15,
    hmastlock15,
    hrdata15,
    hready15,
    hresp15,
    
    // APB15 system interface
    pclk15,
    n_preset15,
    
    // SPI15 ports15
    n_ss_in15,
    mi15,
    si15,
    sclk_in15,
    so,
    mo15,
    sclk_out15,
    n_ss_out15,
    n_so_en15,
    n_mo_en15,
    n_sclk_en15,
    n_ss_en15,
    
    //UART015 ports15
    ua_rxd15,
    ua_ncts15,
    ua_txd15,
    ua_nrts15,
    
    //UART115 ports15
    ua_rxd115,
    ua_ncts115,
    ua_txd115,
    ua_nrts115,
    
    //GPIO15 ports15
    gpio_pin_in15,
    n_gpio_pin_oe15,
    gpio_pin_out15,
    

    //SMC15 ports15
    smc_hclk15,
    smc_n_hclk15,
    smc_haddr15,
    smc_htrans15,
    smc_hsel15,
    smc_hwrite15,
    smc_hsize15,
    smc_hwdata15,
    smc_hready_in15,
    smc_hburst15,
    smc_hprot15,
    smc_hmaster15,
    smc_hmastlock15,
    smc_hrdata15, 
    smc_hready15,
    smc_hresp15,
    smc_n_ext_oe15,
    smc_data15,
    smc_addr15,
    smc_n_be15,
    smc_n_cs15, 
    smc_n_we15,
    smc_n_wr15,
    smc_n_rd15,
    data_smc15,
    
    //PMC15 ports15
    clk_SRPG_macb0_en15,
    clk_SRPG_macb1_en15,
    clk_SRPG_macb2_en15,
    clk_SRPG_macb3_en15,
    core06v15,
    core08v15,
    core10v15,
    core12v15,
    macb3_wakeup15,
    macb2_wakeup15,
    macb1_wakeup15,
    macb0_wakeup15,
    mte_smc_start15,
    mte_uart_start15,
    mte_smc_uart_start15,  
    mte_pm_smc_to_default_start15, 
    mte_pm_uart_to_default_start15,
    mte_pm_smc_uart_to_default_start15,
    
    
    // Peripheral15 inerrupts15
    pcm_irq15,
    ttc_irq15,
    gpio_irq15,
    uart0_irq15,
    uart1_irq15,
    spi_irq15,
    DMA_irq15,      
    macb0_int15,
    macb1_int15,
    macb2_int15,
    macb3_int15,
   
    // Scan15 ports15
    scan_en15,      // Scan15 enable pin15
    scan_in_115,    // Scan15 input for first chain15
    scan_in_215,    // Scan15 input for second chain15
    scan_mode15,
    scan_out_115,   // Scan15 out for chain15 1
    scan_out_215    // Scan15 out for chain15 2
);

parameter GPIO_WIDTH15 = 16;        // GPIO15 width
parameter P_SIZE15 =   8;              // number15 of peripheral15 select15 lines15
parameter NO_OF_IRQS15  = 17;      //No of irqs15 read by apic15 

// AHB15 interface
input         hclk15;     // AHB15 Clock15
input         n_hreset15;  // AHB15 reset - Active15 low15
input         hsel15;     // AHB2APB15 select15
input [31:0]  haddr15;    // Address bus
input [1:0]   htrans15;   // Transfer15 type
input [2:0]   hsize15;    // AHB15 Access type - byte, half15-word15, word15
input [31:0]  hwdata15;   // Write data
input         hwrite15;   // Write signal15/
input         hready_in15;// Indicates15 that last master15 has finished15 bus access
input [2:0]   hburst15;     // Burst type
input [3:0]   hprot15;      // Protection15 control15
input [3:0]   hmaster15;    // Master15 select15
input         hmastlock15;  // Locked15 transfer15
output [31:0] hrdata15;       // Read data provided from target slave15
output        hready15;       // Ready15 for new bus cycle from target slave15
output [1:0]  hresp15;       // Response15 from the bridge15
    
// APB15 system interface
input         pclk15;     // APB15 Clock15. 
input         n_preset15;  // APB15 reset - Active15 low15
   
// SPI15 ports15
input     n_ss_in15;      // select15 input to slave15
input     mi15;           // data input to master15
input     si15;           // data input to slave15
input     sclk_in15;      // clock15 input to slave15
output    so;                    // data output from slave15
output    mo15;                    // data output from master15
output    sclk_out15;              // clock15 output from master15
output [P_SIZE15-1:0] n_ss_out15;    // peripheral15 select15 lines15 from master15
output    n_so_en15;               // out enable for slave15 data
output    n_mo_en15;               // out enable for master15 data
output    n_sclk_en15;             // out enable for master15 clock15
output    n_ss_en15;               // out enable for master15 peripheral15 lines15

//UART015 ports15
input        ua_rxd15;       // UART15 receiver15 serial15 input pin15
input        ua_ncts15;      // Clear-To15-Send15 flow15 control15
output       ua_txd15;       	// UART15 transmitter15 serial15 output
output       ua_nrts15;      	// Request15-To15-Send15 flow15 control15

// UART115 ports15   
input        ua_rxd115;      // UART15 receiver15 serial15 input pin15
input        ua_ncts115;      // Clear-To15-Send15 flow15 control15
output       ua_txd115;       // UART15 transmitter15 serial15 output
output       ua_nrts115;      // Request15-To15-Send15 flow15 control15

//GPIO15 ports15
input [GPIO_WIDTH15-1:0]      gpio_pin_in15;             // input data from pin15
output [GPIO_WIDTH15-1:0]     n_gpio_pin_oe15;           // output enable signal15 to pin15
output [GPIO_WIDTH15-1:0]     gpio_pin_out15;            // output signal15 to pin15
  
//SMC15 ports15
input        smc_hclk15;
input        smc_n_hclk15;
input [31:0] smc_haddr15;
input [1:0]  smc_htrans15;
input        smc_hsel15;
input        smc_hwrite15;
input [2:0]  smc_hsize15;
input [31:0] smc_hwdata15;
input        smc_hready_in15;
input [2:0]  smc_hburst15;     // Burst type
input [3:0]  smc_hprot15;      // Protection15 control15
input [3:0]  smc_hmaster15;    // Master15 select15
input        smc_hmastlock15;  // Locked15 transfer15
input [31:0] data_smc15;     // EMI15(External15 memory) read data
output [31:0]    smc_hrdata15;
output           smc_hready15;
output [1:0]     smc_hresp15;
output [15:0]    smc_addr15;      // External15 Memory (EMI15) address
output [3:0]     smc_n_be15;      // EMI15 byte enables15 (Active15 LOW15)
output           smc_n_cs15;      // EMI15 Chip15 Selects15 (Active15 LOW15)
output [3:0]     smc_n_we15;      // EMI15 write strobes15 (Active15 LOW15)
output           smc_n_wr15;      // EMI15 write enable (Active15 LOW15)
output           smc_n_rd15;      // EMI15 read stobe15 (Active15 LOW15)
output           smc_n_ext_oe15;  // EMI15 write data output enable
output [31:0]    smc_data15;      // EMI15 write data
       
//PMC15 ports15
output clk_SRPG_macb0_en15;
output clk_SRPG_macb1_en15;
output clk_SRPG_macb2_en15;
output clk_SRPG_macb3_en15;
output core06v15;
output core08v15;
output core10v15;
output core12v15;
output mte_smc_start15;
output mte_uart_start15;
output mte_smc_uart_start15;  
output mte_pm_smc_to_default_start15; 
output mte_pm_uart_to_default_start15;
output mte_pm_smc_uart_to_default_start15;
input macb3_wakeup15;
input macb2_wakeup15;
input macb1_wakeup15;
input macb0_wakeup15;
    

// Peripheral15 interrupts15
output pcm_irq15;
output [2:0] ttc_irq15;
output gpio_irq15;
output uart0_irq15;
output uart1_irq15;
output spi_irq15;
input        macb0_int15;
input        macb1_int15;
input        macb2_int15;
input        macb3_int15;
input        DMA_irq15;
  
//Scan15 ports15
input        scan_en15;    // Scan15 enable pin15
input        scan_in_115;  // Scan15 input for first chain15
input        scan_in_215;  // Scan15 input for second chain15
input        scan_mode15;  // test mode pin15
 output        scan_out_115;   // Scan15 out for chain15 1
 output        scan_out_215;   // Scan15 out for chain15 2  

//------------------------------------------------------------------------------
// if the ROM15 subsystem15 is NOT15 black15 boxed15 
//------------------------------------------------------------------------------
`ifndef FV_KIT_BLACK_BOX_APB_SUBSYSTEM15
   
   wire        hsel15; 
   wire        pclk15;
   wire        n_preset15;
   wire [31:0] prdata_spi15;
   wire [31:0] prdata_uart015;
   wire [31:0] prdata_gpio15;
   wire [31:0] prdata_ttc15;
   wire [31:0] prdata_smc15;
   wire [31:0] prdata_pmc15;
   wire [31:0] prdata_uart115;
   wire        pready_spi15;
   wire        pready_uart015;
   wire        pready_uart115;
   wire        tie_hi_bit15;
   wire  [31:0] hrdata15; 
   wire         hready15;
   wire         hready_in15;
   wire  [1:0]  hresp15;   
   wire  [31:0] pwdata15;  
   wire         pwrite15;
   wire  [31:0] paddr15;  
   wire   psel_spi15;
   wire   psel_uart015;
   wire   psel_gpio15;
   wire   psel_ttc15;
   wire   psel_smc15;
   wire   psel0715;
   wire   psel0815;
   wire   psel0915;
   wire   psel1015;
   wire   psel1115;
   wire   psel1215;
   wire   psel_pmc15;
   wire   psel_uart115;
   wire   penable15;
   wire   [NO_OF_IRQS15:0] int_source15;     // System15 Interrupt15 Sources15
   wire [1:0]             smc_hresp15;     // AHB15 Response15 signal15
   wire                   smc_valid15;     // Ack15 valid address

  //External15 memory interface (EMI15)
  wire [31:0]            smc_addr_int15;  // External15 Memory (EMI15) address
  wire [3:0]             smc_n_be15;      // EMI15 byte enables15 (Active15 LOW15)
  wire                   smc_n_cs15;      // EMI15 Chip15 Selects15 (Active15 LOW15)
  wire [3:0]             smc_n_we15;      // EMI15 write strobes15 (Active15 LOW15)
  wire                   smc_n_wr15;      // EMI15 write enable (Active15 LOW15)
  wire                   smc_n_rd15;      // EMI15 read stobe15 (Active15 LOW15)
 
  //AHB15 Memory Interface15 Control15
  wire                   smc_hsel_int15;
  wire                   smc_busy15;      // smc15 busy
   

//scan15 signals15

   wire                scan_in_115;        //scan15 input
   wire                scan_in_215;        //scan15 input
   wire                scan_en15;         //scan15 enable
   wire                scan_out_115;       //scan15 output
   wire                scan_out_215;       //scan15 output
   wire                byte_sel15;     // byte select15 from bridge15 1=byte, 0=2byte
   wire                UART_int15;     // UART15 module interrupt15 
   wire                ua_uclken15;    // Soft15 control15 of clock15
   wire                UART_int115;     // UART15 module interrupt15 
   wire                ua_uclken115;    // Soft15 control15 of clock15
   wire  [3:1]         TTC_int15;            //Interrupt15 from PCI15 
  // inputs15 to SPI15 
   wire    ext_clk15;                // external15 clock15
   wire    SPI_int15;             // interrupt15 request
  // outputs15 from SPI15
   wire    slave_out_clk15;         // modified slave15 clock15 output
 // gpio15 generic15 inputs15 
   wire  [GPIO_WIDTH15-1:0]   n_gpio_bypass_oe15;        // bypass15 mode enable 
   wire  [GPIO_WIDTH15-1:0]   gpio_bypass_out15;         // bypass15 mode output value 
   wire  [GPIO_WIDTH15-1:0]   tri_state_enable15;   // disables15 op enable -> z 
 // outputs15 
   //amba15 outputs15 
   // gpio15 generic15 outputs15 
   wire       GPIO_int15;                // gpio_interupt15 for input pin15 change 
   wire [GPIO_WIDTH15-1:0]     gpio_bypass_in15;          // bypass15 mode input data value  
                
   wire           cpu_debug15;        // Inhibits15 watchdog15 counter 
   wire            ex_wdz_n15;         // External15 Watchdog15 zero indication15
   wire           rstn_non_srpg_smc15; 
   wire           rstn_non_srpg_urt15;
   wire           isolate_smc15;
   wire           save_edge_smc15;
   wire           restore_edge_smc15;
   wire           save_edge_urt15;
   wire           restore_edge_urt15;
   wire           pwr1_on_smc15;
   wire           pwr2_on_smc15;
   wire           pwr1_on_urt15;
   wire           pwr2_on_urt15;
   // ETH015
   wire            rstn_non_srpg_macb015;
   wire            gate_clk_macb015;
   wire            isolate_macb015;
   wire            save_edge_macb015;
   wire            restore_edge_macb015;
   wire            pwr1_on_macb015;
   wire            pwr2_on_macb015;
   // ETH115
   wire            rstn_non_srpg_macb115;
   wire            gate_clk_macb115;
   wire            isolate_macb115;
   wire            save_edge_macb115;
   wire            restore_edge_macb115;
   wire            pwr1_on_macb115;
   wire            pwr2_on_macb115;
   // ETH215
   wire            rstn_non_srpg_macb215;
   wire            gate_clk_macb215;
   wire            isolate_macb215;
   wire            save_edge_macb215;
   wire            restore_edge_macb215;
   wire            pwr1_on_macb215;
   wire            pwr2_on_macb215;
   // ETH315
   wire            rstn_non_srpg_macb315;
   wire            gate_clk_macb315;
   wire            isolate_macb315;
   wire            save_edge_macb315;
   wire            restore_edge_macb315;
   wire            pwr1_on_macb315;
   wire            pwr2_on_macb315;


   wire           pclk_SRPG_smc15;
   wire           pclk_SRPG_urt15;
   wire           gate_clk_smc15;
   wire           gate_clk_urt15;
   wire  [31:0]   tie_lo_32bit15; 
   wire  [1:0]	  tie_lo_2bit15;
   wire  	  tie_lo_1bit15;
   wire           pcm_macb_wakeup_int15;
   wire           int_source_h15;
   wire           isolate_mem15;

assign pcm_irq15 = pcm_macb_wakeup_int15;
assign ttc_irq15[2] = TTC_int15[3];
assign ttc_irq15[1] = TTC_int15[2];
assign ttc_irq15[0] = TTC_int15[1];
assign gpio_irq15 = GPIO_int15;
assign uart0_irq15 = UART_int15;
assign uart1_irq15 = UART_int115;
assign spi_irq15 = SPI_int15;

assign n_mo_en15   = 1'b0;
assign n_so_en15   = 1'b1;
assign n_sclk_en15 = 1'b0;
assign n_ss_en15   = 1'b0;

assign smc_hsel_int15 = smc_hsel15;
  assign ext_clk15  = 1'b0;
  assign int_source15 = {macb0_int15,macb1_int15, macb2_int15, macb3_int15,1'b0, pcm_macb_wakeup_int15, 1'b0, 1'b0, 1'b0, 1'b0, TTC_int15, GPIO_int15, UART_int15, UART_int115, SPI_int15, DMA_irq15};

  // interrupt15 even15 detect15 .
  // for sleep15 wake15 up -> any interrupt15 even15 and system not in hibernation15 (isolate_mem15 = 0)
  // for hibernate15 wake15 up -> gpio15 interrupt15 even15 and system in the hibernation15 (isolate_mem15 = 1)
  assign int_source_h15 =  ((|int_source15) && (!isolate_mem15)) || (isolate_mem15 && GPIO_int15) ;

  assign byte_sel15 = 1'b1;
  assign tie_hi_bit15 = 1'b1;

  assign smc_addr15 = smc_addr_int15[15:0];



  assign  n_gpio_bypass_oe15 = {GPIO_WIDTH15{1'b0}};        // bypass15 mode enable 
  assign  gpio_bypass_out15  = {GPIO_WIDTH15{1'b0}};
  assign  tri_state_enable15 = {GPIO_WIDTH15{1'b0}};
  assign  cpu_debug15 = 1'b0;
  assign  tie_lo_32bit15 = 32'b0;
  assign  tie_lo_2bit15  = 2'b0;
  assign  tie_lo_1bit15  = 1'b0;


ahb2apb15 #(
  32'h00800000, // Slave15 0 Address Range15
  32'h0080FFFF,

  32'h00810000, // Slave15 1 Address Range15
  32'h0081FFFF,

  32'h00820000, // Slave15 2 Address Range15 
  32'h0082FFFF,

  32'h00830000, // Slave15 3 Address Range15
  32'h0083FFFF,

  32'h00840000, // Slave15 4 Address Range15
  32'h0084FFFF,

  32'h00850000, // Slave15 5 Address Range15
  32'h0085FFFF,

  32'h00860000, // Slave15 6 Address Range15
  32'h0086FFFF,

  32'h00870000, // Slave15 7 Address Range15
  32'h0087FFFF,

  32'h00880000, // Slave15 8 Address Range15
  32'h0088FFFF
) i_ahb2apb15 (
     // AHB15 interface
    .hclk15(hclk15),         
    .hreset_n15(n_hreset15), 
    .hsel15(hsel15), 
    .haddr15(haddr15),        
    .htrans15(htrans15),       
    .hwrite15(hwrite15),       
    .hwdata15(hwdata15),       
    .hrdata15(hrdata15),   
    .hready15(hready15),   
    .hresp15(hresp15),     
    
     // APB15 interface
    .pclk15(pclk15),         
    .preset_n15(n_preset15),  
    .prdata015(prdata_spi15),
    .prdata115(prdata_uart015), 
    .prdata215(prdata_gpio15),  
    .prdata315(prdata_ttc15),   
    .prdata415(32'h0),   
    .prdata515(prdata_smc15),   
    .prdata615(prdata_pmc15),    
    .prdata715(32'h0),   
    .prdata815(prdata_uart115),  
    .pready015(pready_spi15),     
    .pready115(pready_uart015),   
    .pready215(tie_hi_bit15),     
    .pready315(tie_hi_bit15),     
    .pready415(tie_hi_bit15),     
    .pready515(tie_hi_bit15),     
    .pready615(tie_hi_bit15),     
    .pready715(tie_hi_bit15),     
    .pready815(pready_uart115),  
    .pwdata15(pwdata15),       
    .pwrite15(pwrite15),       
    .paddr15(paddr15),        
    .psel015(psel_spi15),     
    .psel115(psel_uart015),   
    .psel215(psel_gpio15),    
    .psel315(psel_ttc15),     
    .psel415(),     
    .psel515(psel_smc15),     
    .psel615(psel_pmc15),    
    .psel715(psel_apic15),   
    .psel815(psel_uart115),  
    .penable15(penable15)     
);

spi_top15 i_spi15
(
  // Wishbone15 signals15
  .wb_clk_i15(pclk15), 
  .wb_rst_i15(~n_preset15), 
  .wb_adr_i15(paddr15[4:0]), 
  .wb_dat_i15(pwdata15), 
  .wb_dat_o15(prdata_spi15), 
  .wb_sel_i15(4'b1111),    // SPI15 register accesses are always 32-bit
  .wb_we_i15(pwrite15), 
  .wb_stb_i15(psel_spi15), 
  .wb_cyc_i15(psel_spi15), 
  .wb_ack_o15(pready_spi15), 
  .wb_err_o15(), 
  .wb_int_o15(SPI_int15),

  // SPI15 signals15
  .ss_pad_o15(n_ss_out15), 
  .sclk_pad_o15(sclk_out15), 
  .mosi_pad_o15(mo15), 
  .miso_pad_i15(mi15)
);

// Opencores15 UART15 instances15
wire ua_nrts_int15;
wire ua_nrts1_int15;

assign ua_nrts15 = ua_nrts_int15;
assign ua_nrts115 = ua_nrts1_int15;

reg [3:0] uart0_sel_i15;
reg [3:0] uart1_sel_i15;
// UART15 registers are all 8-bit wide15, and their15 addresses15
// are on byte boundaries15. So15 to access them15 on the
// Wishbone15 bus, the CPU15 must do byte accesses to these15
// byte addresses15. Word15 address accesses are not possible15
// because the word15 addresses15 will be unaligned15, and cause
// a fault15.
// So15, Uart15 accesses from the CPU15 will always be 8-bit size
// We15 only have to decide15 which byte of the 4-byte word15 the
// CPU15 is interested15 in.
`ifdef SYSTEM_BIG_ENDIAN15
always @(paddr15) begin
  case (paddr15[1:0])
    2'b00 : uart0_sel_i15 = 4'b1000;
    2'b01 : uart0_sel_i15 = 4'b0100;
    2'b10 : uart0_sel_i15 = 4'b0010;
    2'b11 : uart0_sel_i15 = 4'b0001;
  endcase
end
always @(paddr15) begin
  case (paddr15[1:0])
    2'b00 : uart1_sel_i15 = 4'b1000;
    2'b01 : uart1_sel_i15 = 4'b0100;
    2'b10 : uart1_sel_i15 = 4'b0010;
    2'b11 : uart1_sel_i15 = 4'b0001;
  endcase
end
`else
always @(paddr15) begin
  case (paddr15[1:0])
    2'b00 : uart0_sel_i15 = 4'b0001;
    2'b01 : uart0_sel_i15 = 4'b0010;
    2'b10 : uart0_sel_i15 = 4'b0100;
    2'b11 : uart0_sel_i15 = 4'b1000;
  endcase
end
always @(paddr15) begin
  case (paddr15[1:0])
    2'b00 : uart1_sel_i15 = 4'b0001;
    2'b01 : uart1_sel_i15 = 4'b0010;
    2'b10 : uart1_sel_i15 = 4'b0100;
    2'b11 : uart1_sel_i15 = 4'b1000;
  endcase
end
`endif

uart_top15 i_oc_uart015 (
  .wb_clk_i15(pclk15),
  .wb_rst_i15(~n_preset15),
  .wb_adr_i15(paddr15[4:0]),
  .wb_dat_i15(pwdata15),
  .wb_dat_o15(prdata_uart015),
  .wb_we_i15(pwrite15),
  .wb_stb_i15(psel_uart015),
  .wb_cyc_i15(psel_uart015),
  .wb_ack_o15(pready_uart015),
  .wb_sel_i15(uart0_sel_i15),
  .int_o15(UART_int15),
  .stx_pad_o15(ua_txd15),
  .srx_pad_i15(ua_rxd15),
  .rts_pad_o15(ua_nrts_int15),
  .cts_pad_i15(ua_ncts15),
  .dtr_pad_o15(),
  .dsr_pad_i15(1'b0),
  .ri_pad_i15(1'b0),
  .dcd_pad_i15(1'b0)
);

uart_top15 i_oc_uart115 (
  .wb_clk_i15(pclk15),
  .wb_rst_i15(~n_preset15),
  .wb_adr_i15(paddr15[4:0]),
  .wb_dat_i15(pwdata15),
  .wb_dat_o15(prdata_uart115),
  .wb_we_i15(pwrite15),
  .wb_stb_i15(psel_uart115),
  .wb_cyc_i15(psel_uart115),
  .wb_ack_o15(pready_uart115),
  .wb_sel_i15(uart1_sel_i15),
  .int_o15(UART_int115),
  .stx_pad_o15(ua_txd115),
  .srx_pad_i15(ua_rxd115),
  .rts_pad_o15(ua_nrts1_int15),
  .cts_pad_i15(ua_ncts115),
  .dtr_pad_o15(),
  .dsr_pad_i15(1'b0),
  .ri_pad_i15(1'b0),
  .dcd_pad_i15(1'b0)
);

gpio_veneer15 i_gpio_veneer15 (
        //inputs15

        . n_p_reset15(n_preset15),
        . pclk15(pclk15),
        . psel15(psel_gpio15),
        . penable15(penable15),
        . pwrite15(pwrite15),
        . paddr15(paddr15[5:0]),
        . pwdata15(pwdata15),
        . gpio_pin_in15(gpio_pin_in15),
        . scan_en15(scan_en15),
        . tri_state_enable15(tri_state_enable15),
        . scan_in15(), //added by smarkov15 for dft15

        //outputs15
        . scan_out15(), //added by smarkov15 for dft15
        . prdata15(prdata_gpio15),
        . gpio_int15(GPIO_int15),
        . n_gpio_pin_oe15(n_gpio_pin_oe15),
        . gpio_pin_out15(gpio_pin_out15)
);


ttc_veneer15 i_ttc_veneer15 (

         //inputs15
        . n_p_reset15(n_preset15),
        . pclk15(pclk15),
        . psel15(psel_ttc15),
        . penable15(penable15),
        . pwrite15(pwrite15),
        . pwdata15(pwdata15),
        . paddr15(paddr15[7:0]),
        . scan_in15(),
        . scan_en15(scan_en15),

        //outputs15
        . prdata15(prdata_ttc15),
        . interrupt15(TTC_int15[3:1]),
        . scan_out15()
);


smc_veneer15 i_smc_veneer15 (
        //inputs15
	//apb15 inputs15
        . n_preset15(n_preset15),
        . pclk15(pclk_SRPG_smc15),
        . psel15(psel_smc15),
        . penable15(penable15),
        . pwrite15(pwrite15),
        . paddr15(paddr15[4:0]),
        . pwdata15(pwdata15),
        //ahb15 inputs15
	. hclk15(smc_hclk15),
        . n_sys_reset15(rstn_non_srpg_smc15),
        . haddr15(smc_haddr15),
        . htrans15(smc_htrans15),
        . hsel15(smc_hsel_int15),
        . hwrite15(smc_hwrite15),
	. hsize15(smc_hsize15),
        . hwdata15(smc_hwdata15),
        . hready15(smc_hready_in15),
        . data_smc15(data_smc15),

         //test signal15 inputs15

        . scan_in_115(),
        . scan_in_215(),
        . scan_in_315(),
        . scan_en15(scan_en15),

        //apb15 outputs15
        . prdata15(prdata_smc15),

       //design output

        . smc_hrdata15(smc_hrdata15),
        . smc_hready15(smc_hready15),
        . smc_hresp15(smc_hresp15),
        . smc_valid15(smc_valid15),
        . smc_addr15(smc_addr_int15),
        . smc_data15(smc_data15),
        . smc_n_be15(smc_n_be15),
        . smc_n_cs15(smc_n_cs15),
        . smc_n_wr15(smc_n_wr15),
        . smc_n_we15(smc_n_we15),
        . smc_n_rd15(smc_n_rd15),
        . smc_n_ext_oe15(smc_n_ext_oe15),
        . smc_busy15(smc_busy15),

         //test signal15 output
        . scan_out_115(),
        . scan_out_215(),
        . scan_out_315()
);

power_ctrl_veneer15 i_power_ctrl_veneer15 (
    // -- Clocks15 & Reset15
    	.pclk15(pclk15), 			//  : in  std_logic15;
    	.nprst15(n_preset15), 		//  : in  std_logic15;
    // -- APB15 programming15 interface
    	.paddr15(paddr15), 			//  : in  std_logic_vector15(31 downto15 0);
    	.psel15(psel_pmc15), 			//  : in  std_logic15;
    	.penable15(penable15), 		//  : in  std_logic15;
    	.pwrite15(pwrite15), 		//  : in  std_logic15;
    	.pwdata15(pwdata15), 		//  : in  std_logic_vector15(31 downto15 0);
    	.prdata15(prdata_pmc15), 		//  : out std_logic_vector15(31 downto15 0);
        .macb3_wakeup15(macb3_wakeup15),
        .macb2_wakeup15(macb2_wakeup15),
        .macb1_wakeup15(macb1_wakeup15),
        .macb0_wakeup15(macb0_wakeup15),
    // -- Module15 control15 outputs15
    	.scan_in15(),			//  : in  std_logic15;
    	.scan_en15(scan_en15),             	//  : in  std_logic15;
    	.scan_mode15(scan_mode15),          //  : in  std_logic15;
    	.scan_out15(),            	//  : out std_logic15;
        .int_source_h15(int_source_h15),
     	.rstn_non_srpg_smc15(rstn_non_srpg_smc15), 		//   : out std_logic15;
    	.gate_clk_smc15(gate_clk_smc15), 	//  : out std_logic15;
    	.isolate_smc15(isolate_smc15), 	//  : out std_logic15;
    	.save_edge_smc15(save_edge_smc15), 	//  : out std_logic15;
    	.restore_edge_smc15(restore_edge_smc15), 	//  : out std_logic15;
    	.pwr1_on_smc15(pwr1_on_smc15), 	//  : out std_logic15;
    	.pwr2_on_smc15(pwr2_on_smc15), 	//  : out std_logic15
     	.rstn_non_srpg_urt15(rstn_non_srpg_urt15), 		//   : out std_logic15;
    	.gate_clk_urt15(gate_clk_urt15), 	//  : out std_logic15;
    	.isolate_urt15(isolate_urt15), 	//  : out std_logic15;
    	.save_edge_urt15(save_edge_urt15), 	//  : out std_logic15;
    	.restore_edge_urt15(restore_edge_urt15), 	//  : out std_logic15;
    	.pwr1_on_urt15(pwr1_on_urt15), 	//  : out std_logic15;
    	.pwr2_on_urt15(pwr2_on_urt15),  	//  : out std_logic15
        // ETH015
        .rstn_non_srpg_macb015(rstn_non_srpg_macb015),
        .gate_clk_macb015(gate_clk_macb015),
        .isolate_macb015(isolate_macb015),
        .save_edge_macb015(save_edge_macb015),
        .restore_edge_macb015(restore_edge_macb015),
        .pwr1_on_macb015(pwr1_on_macb015),
        .pwr2_on_macb015(pwr2_on_macb015),
        // ETH115
        .rstn_non_srpg_macb115(rstn_non_srpg_macb115),
        .gate_clk_macb115(gate_clk_macb115),
        .isolate_macb115(isolate_macb115),
        .save_edge_macb115(save_edge_macb115),
        .restore_edge_macb115(restore_edge_macb115),
        .pwr1_on_macb115(pwr1_on_macb115),
        .pwr2_on_macb115(pwr2_on_macb115),
        // ETH215
        .rstn_non_srpg_macb215(rstn_non_srpg_macb215),
        .gate_clk_macb215(gate_clk_macb215),
        .isolate_macb215(isolate_macb215),
        .save_edge_macb215(save_edge_macb215),
        .restore_edge_macb215(restore_edge_macb215),
        .pwr1_on_macb215(pwr1_on_macb215),
        .pwr2_on_macb215(pwr2_on_macb215),
        // ETH315
        .rstn_non_srpg_macb315(rstn_non_srpg_macb315),
        .gate_clk_macb315(gate_clk_macb315),
        .isolate_macb315(isolate_macb315),
        .save_edge_macb315(save_edge_macb315),
        .restore_edge_macb315(restore_edge_macb315),
        .pwr1_on_macb315(pwr1_on_macb315),
        .pwr2_on_macb315(pwr2_on_macb315),
        .core06v15(core06v15),
        .core08v15(core08v15),
        .core10v15(core10v15),
        .core12v15(core12v15),
        .pcm_macb_wakeup_int15(pcm_macb_wakeup_int15),
        .isolate_mem15(isolate_mem15),
        .mte_smc_start15(mte_smc_start15),
        .mte_uart_start15(mte_uart_start15),
        .mte_smc_uart_start15(mte_smc_uart_start15),  
        .mte_pm_smc_to_default_start15(mte_pm_smc_to_default_start15), 
        .mte_pm_uart_to_default_start15(mte_pm_uart_to_default_start15),
        .mte_pm_smc_uart_to_default_start15(mte_pm_smc_uart_to_default_start15)
);

// Clock15 gating15 macro15 to shut15 off15 clocks15 to the SRPG15 flops15 in the SMC15
//CKLNQD115 i_SMC_SRPG_clk_gate15  (
//	.TE15(scan_mode15), 
//	.E15(~gate_clk_smc15), 
//	.CP15(pclk15), 
//	.Q15(pclk_SRPG_smc15)
//	);
// Replace15 gate15 with behavioural15 code15 //
wire 	smc_scan_gate15;
reg 	smc_latched_enable15;
assign smc_scan_gate15 = scan_mode15 ? 1'b1 : ~gate_clk_smc15;

always @ (pclk15 or smc_scan_gate15)
  	if (pclk15 == 1'b0) begin
  		smc_latched_enable15 <= smc_scan_gate15;
  	end  	
	
assign pclk_SRPG_smc15 = smc_latched_enable15 ? pclk15 : 1'b0;


// Clock15 gating15 macro15 to shut15 off15 clocks15 to the SRPG15 flops15 in the URT15
//CKLNQD115 i_URT_SRPG_clk_gate15  (
//	.TE15(scan_mode15), 
//	.E15(~gate_clk_urt15), 
//	.CP15(pclk15), 
//	.Q15(pclk_SRPG_urt15)
//	);
// Replace15 gate15 with behavioural15 code15 //
wire 	urt_scan_gate15;
reg 	urt_latched_enable15;
assign urt_scan_gate15 = scan_mode15 ? 1'b1 : ~gate_clk_urt15;

always @ (pclk15 or urt_scan_gate15)
  	if (pclk15 == 1'b0) begin
  		urt_latched_enable15 <= urt_scan_gate15;
  	end  	
	
assign pclk_SRPG_urt15 = urt_latched_enable15 ? pclk15 : 1'b0;

// ETH015
wire 	macb0_scan_gate15;
reg 	macb0_latched_enable15;
assign macb0_scan_gate15 = scan_mode15 ? 1'b1 : ~gate_clk_macb015;

always @ (pclk15 or macb0_scan_gate15)
  	if (pclk15 == 1'b0) begin
  		macb0_latched_enable15 <= macb0_scan_gate15;
  	end  	
	
assign clk_SRPG_macb0_en15 = macb0_latched_enable15 ? 1'b1 : 1'b0;

// ETH115
wire 	macb1_scan_gate15;
reg 	macb1_latched_enable15;
assign macb1_scan_gate15 = scan_mode15 ? 1'b1 : ~gate_clk_macb115;

always @ (pclk15 or macb1_scan_gate15)
  	if (pclk15 == 1'b0) begin
  		macb1_latched_enable15 <= macb1_scan_gate15;
  	end  	
	
assign clk_SRPG_macb1_en15 = macb1_latched_enable15 ? 1'b1 : 1'b0;

// ETH215
wire 	macb2_scan_gate15;
reg 	macb2_latched_enable15;
assign macb2_scan_gate15 = scan_mode15 ? 1'b1 : ~gate_clk_macb215;

always @ (pclk15 or macb2_scan_gate15)
  	if (pclk15 == 1'b0) begin
  		macb2_latched_enable15 <= macb2_scan_gate15;
  	end  	
	
assign clk_SRPG_macb2_en15 = macb2_latched_enable15 ? 1'b1 : 1'b0;

// ETH315
wire 	macb3_scan_gate15;
reg 	macb3_latched_enable15;
assign macb3_scan_gate15 = scan_mode15 ? 1'b1 : ~gate_clk_macb315;

always @ (pclk15 or macb3_scan_gate15)
  	if (pclk15 == 1'b0) begin
  		macb3_latched_enable15 <= macb3_scan_gate15;
  	end  	
	
assign clk_SRPG_macb3_en15 = macb3_latched_enable15 ? 1'b1 : 1'b0;



`else
//------------------------------------------------------------------------------
// if the APB15 subsystem15 is black15 boxed15 
//------------------------------------------------------------------------------
// wire s ports15
    // system signals15
    wire         hclk15;     // AHB15 Clock15
    wire         n_hreset15;  // AHB15 reset - Active15 low15
    wire         pclk15;     // APB15 Clock15. 
    wire         n_preset15;  // APB15 reset - Active15 low15

    // AHB15 interface
    wire         ahb2apb0_hsel15;     // AHB2APB15 select15
    wire  [31:0] haddr15;    // Address bus
    wire  [1:0]  htrans15;   // Transfer15 type
    wire  [2:0]  hsize15;    // AHB15 Access type - byte, half15-word15, word15
    wire  [31:0] hwdata15;   // Write data
    wire         hwrite15;   // Write signal15/
    wire         hready_in15;// Indicates15 that last master15 has finished15 bus access
    wire [2:0]   hburst15;     // Burst type
    wire [3:0]   hprot15;      // Protection15 control15
    wire [3:0]   hmaster15;    // Master15 select15
    wire         hmastlock15;  // Locked15 transfer15
  // Interrupts15 from the Enet15 MACs15
    wire         macb0_int15;
    wire         macb1_int15;
    wire         macb2_int15;
    wire         macb3_int15;
  // Interrupt15 from the DMA15
    wire         DMA_irq15;
  // Scan15 wire s
    wire         scan_en15;    // Scan15 enable pin15
    wire         scan_in_115;  // Scan15 wire  for first chain15
    wire         scan_in_215;  // Scan15 wire  for second chain15
    wire         scan_mode15;  // test mode pin15
 
  //wire  for smc15 AHB15 interface
    wire         smc_hclk15;
    wire         smc_n_hclk15;
    wire  [31:0] smc_haddr15;
    wire  [1:0]  smc_htrans15;
    wire         smc_hsel15;
    wire         smc_hwrite15;
    wire  [2:0]  smc_hsize15;
    wire  [31:0] smc_hwdata15;
    wire         smc_hready_in15;
    wire  [2:0]  smc_hburst15;     // Burst type
    wire  [3:0]  smc_hprot15;      // Protection15 control15
    wire  [3:0]  smc_hmaster15;    // Master15 select15
    wire         smc_hmastlock15;  // Locked15 transfer15


    wire  [31:0] data_smc15;     // EMI15(External15 memory) read data
    
  //wire s for uart15
    wire         ua_rxd15;       // UART15 receiver15 serial15 wire  pin15
    wire         ua_rxd115;      // UART15 receiver15 serial15 wire  pin15
    wire         ua_ncts15;      // Clear-To15-Send15 flow15 control15
    wire         ua_ncts115;      // Clear-To15-Send15 flow15 control15
   //wire s for spi15
    wire         n_ss_in15;      // select15 wire  to slave15
    wire         mi15;           // data wire  to master15
    wire         si15;           // data wire  to slave15
    wire         sclk_in15;      // clock15 wire  to slave15
  //wire s for GPIO15
   wire  [GPIO_WIDTH15-1:0]  gpio_pin_in15;             // wire  data from pin15

  //reg    ports15
  // Scan15 reg   s
   reg           scan_out_115;   // Scan15 out for chain15 1
   reg           scan_out_215;   // Scan15 out for chain15 2
  //AHB15 interface 
   reg    [31:0] hrdata15;       // Read data provided from target slave15
   reg           hready15;       // Ready15 for new bus cycle from target slave15
   reg    [1:0]  hresp15;       // Response15 from the bridge15

   // SMC15 reg    for AHB15 interface
   reg    [31:0]    smc_hrdata15;
   reg              smc_hready15;
   reg    [1:0]     smc_hresp15;

  //reg   s from smc15
   reg    [15:0]    smc_addr15;      // External15 Memory (EMI15) address
   reg    [3:0]     smc_n_be15;      // EMI15 byte enables15 (Active15 LOW15)
   reg    [7:0]     smc_n_cs15;      // EMI15 Chip15 Selects15 (Active15 LOW15)
   reg    [3:0]     smc_n_we15;      // EMI15 write strobes15 (Active15 LOW15)
   reg              smc_n_wr15;      // EMI15 write enable (Active15 LOW15)
   reg              smc_n_rd15;      // EMI15 read stobe15 (Active15 LOW15)
   reg              smc_n_ext_oe15;  // EMI15 write data reg    enable
   reg    [31:0]    smc_data15;      // EMI15 write data
  //reg   s from uart15
   reg           ua_txd15;       	// UART15 transmitter15 serial15 reg   
   reg           ua_txd115;       // UART15 transmitter15 serial15 reg   
   reg           ua_nrts15;      	// Request15-To15-Send15 flow15 control15
   reg           ua_nrts115;      // Request15-To15-Send15 flow15 control15
   // reg   s from ttc15
  // reg   s from SPI15
   reg       so;                    // data reg    from slave15
   reg       mo15;                    // data reg    from master15
   reg       sclk_out15;              // clock15 reg    from master15
   reg    [P_SIZE15-1:0] n_ss_out15;    // peripheral15 select15 lines15 from master15
   reg       n_so_en15;               // out enable for slave15 data
   reg       n_mo_en15;               // out enable for master15 data
   reg       n_sclk_en15;             // out enable for master15 clock15
   reg       n_ss_en15;               // out enable for master15 peripheral15 lines15
  //reg   s from gpio15
   reg    [GPIO_WIDTH15-1:0]     n_gpio_pin_oe15;           // reg    enable signal15 to pin15
   reg    [GPIO_WIDTH15-1:0]     gpio_pin_out15;            // reg    signal15 to pin15


`endif
//------------------------------------------------------------------------------
// black15 boxed15 defines15 
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// APB15 and AHB15 interface formal15 verification15 monitors15
//------------------------------------------------------------------------------
`ifdef ABV_ON15
apb_assert15 i_apb_assert15 (

        // APB15 signals15
  	.n_preset15(n_preset15),
   	.pclk15(pclk15),
	.penable15(penable15),
	.paddr15(paddr15),
	.pwrite15(pwrite15),
	.pwdata15(pwdata15),

	.psel0015(psel_spi15),
	.psel0115(psel_uart015),
	.psel0215(psel_gpio15),
	.psel0315(psel_ttc15),
	.psel0415(1'b0),
	.psel0515(psel_smc15),
	.psel0615(1'b0),
	.psel0715(1'b0),
	.psel0815(1'b0),
	.psel0915(1'b0),
	.psel1015(1'b0),
	.psel1115(1'b0),
	.psel1215(1'b0),
	.psel1315(psel_pmc15),
	.psel1415(psel_apic15),
	.psel1515(psel_uart115),

        .prdata0015(prdata_spi15),
        .prdata0115(prdata_uart015), // Read Data from peripheral15 UART15 
        .prdata0215(prdata_gpio15), // Read Data from peripheral15 GPIO15
        .prdata0315(prdata_ttc15), // Read Data from peripheral15 TTC15
        .prdata0415(32'b0), // 
        .prdata0515(prdata_smc15), // Read Data from peripheral15 SMC15
        .prdata1315(prdata_pmc15), // Read Data from peripheral15 Power15 Control15 Block
   	.prdata1415(32'b0), // 
        .prdata1515(prdata_uart115),


        // AHB15 signals15
        .hclk15(hclk15),         // ahb15 system clock15
        .n_hreset15(n_hreset15), // ahb15 system reset

        // ahb2apb15 signals15
        .hresp15(hresp15),
        .hready15(hready15),
        .hrdata15(hrdata15),
        .hwdata15(hwdata15),
        .hprot15(hprot15),
        .hburst15(hburst15),
        .hsize15(hsize15),
        .hwrite15(hwrite15),
        .htrans15(htrans15),
        .haddr15(haddr15),
        .ahb2apb_hsel15(ahb2apb0_hsel15));



//------------------------------------------------------------------------------
// AHB15 interface formal15 verification15 monitor15
//------------------------------------------------------------------------------
defparam i_ahbSlaveMonitor15.DBUS_WIDTH15 = 32;
defparam i_ahbMasterMonitor15.DBUS_WIDTH15 = 32;


// AHB2APB15 Bridge15

    ahb_liteslave_monitor15 i_ahbSlaveMonitor15 (
        .hclk_i15(hclk15),
        .hresetn_i15(n_hreset15),
        .hresp15(hresp15),
        .hready15(hready15),
        .hready_global_i15(hready15),
        .hrdata15(hrdata15),
        .hwdata_i15(hwdata15),
        .hburst_i15(hburst15),
        .hsize_i15(hsize15),
        .hwrite_i15(hwrite15),
        .htrans_i15(htrans15),
        .haddr_i15(haddr15),
        .hsel_i15(ahb2apb0_hsel15)
    );


  ahb_litemaster_monitor15 i_ahbMasterMonitor15 (
          .hclk_i15(hclk15),
          .hresetn_i15(n_hreset15),
          .hresp_i15(hresp15),
          .hready_i15(hready15),
          .hrdata_i15(hrdata15),
          .hlock15(1'b0),
          .hwdata15(hwdata15),
          .hprot15(hprot15),
          .hburst15(hburst15),
          .hsize15(hsize15),
          .hwrite15(hwrite15),
          .htrans15(htrans15),
          .haddr15(haddr15)
          );







`endif




`ifdef IFV_LP_ABV_ON15
// power15 control15
wire isolate15;

// testbench mirror signals15
wire L1_ctrl_access15;
wire L1_status_access15;

wire [31:0] L1_status_reg15;
wire [31:0] L1_ctrl_reg15;

//wire rstn_non_srpg_urt15;
//wire isolate_urt15;
//wire retain_urt15;
//wire gate_clk_urt15;
//wire pwr1_on_urt15;


// smc15 signals15
wire [31:0] smc_prdata15;
wire lp_clk_smc15;
                    

// uart15 isolation15 register
  wire [15:0] ua_prdata15;
  wire ua_int15;
  assign ua_prdata15          =  i_uart1_veneer15.prdata15;
  assign ua_int15             =  i_uart1_veneer15.ua_int15;


assign lp_clk_smc15          = i_smc_veneer15.pclk15;
assign smc_prdata15          = i_smc_veneer15.prdata15;
lp_chk_smc15 u_lp_chk_smc15 (
    .clk15 (hclk15),
    .rst15 (n_hreset15),
    .iso_smc15 (isolate_smc15),
    .gate_clk15 (gate_clk_smc15),
    .lp_clk15 (pclk_SRPG_smc15),

    // srpg15 outputs15
    .smc_hrdata15 (smc_hrdata15),
    .smc_hready15 (smc_hready15),
    .smc_hresp15  (smc_hresp15),
    .smc_valid15 (smc_valid15),
    .smc_addr_int15 (smc_addr_int15),
    .smc_data15 (smc_data15),
    .smc_n_be15 (smc_n_be15),
    .smc_n_cs15  (smc_n_cs15),
    .smc_n_wr15 (smc_n_wr15),
    .smc_n_we15 (smc_n_we15),
    .smc_n_rd15 (smc_n_rd15),
    .smc_n_ext_oe15 (smc_n_ext_oe15)
   );

// lp15 retention15/isolation15 assertions15
lp_chk_uart15 u_lp_chk_urt15 (

  .clk15         (hclk15),
  .rst15         (n_hreset15),
  .iso_urt15     (isolate_urt15),
  .gate_clk15    (gate_clk_urt15),
  .lp_clk15      (pclk_SRPG_urt15),
  //ports15
  .prdata15 (ua_prdata15),
  .ua_int15 (ua_int15),
  .ua_txd15 (ua_txd115),
  .ua_nrts15 (ua_nrts115)
 );

`endif  //IFV_LP_ABV_ON15




endmodule
