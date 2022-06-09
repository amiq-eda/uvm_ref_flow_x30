//File22 name   : apb_subsystem_022.v
//Title22       : 
//Created22     : 1999
//Description22 : 
//Notes22       : 
//----------------------------------------------------------------------
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------

module apb_subsystem_022(
    // AHB22 interface
    hclk22,
    n_hreset22,
    hsel22,
    haddr22,
    htrans22,
    hsize22,
    hwrite22,
    hwdata22,
    hready_in22,
    hburst22,
    hprot22,
    hmaster22,
    hmastlock22,
    hrdata22,
    hready22,
    hresp22,
    
    // APB22 system interface
    pclk22,
    n_preset22,
    
    // SPI22 ports22
    n_ss_in22,
    mi22,
    si22,
    sclk_in22,
    so,
    mo22,
    sclk_out22,
    n_ss_out22,
    n_so_en22,
    n_mo_en22,
    n_sclk_en22,
    n_ss_en22,
    
    //UART022 ports22
    ua_rxd22,
    ua_ncts22,
    ua_txd22,
    ua_nrts22,
    
    //UART122 ports22
    ua_rxd122,
    ua_ncts122,
    ua_txd122,
    ua_nrts122,
    
    //GPIO22 ports22
    gpio_pin_in22,
    n_gpio_pin_oe22,
    gpio_pin_out22,
    

    //SMC22 ports22
    smc_hclk22,
    smc_n_hclk22,
    smc_haddr22,
    smc_htrans22,
    smc_hsel22,
    smc_hwrite22,
    smc_hsize22,
    smc_hwdata22,
    smc_hready_in22,
    smc_hburst22,
    smc_hprot22,
    smc_hmaster22,
    smc_hmastlock22,
    smc_hrdata22, 
    smc_hready22,
    smc_hresp22,
    smc_n_ext_oe22,
    smc_data22,
    smc_addr22,
    smc_n_be22,
    smc_n_cs22, 
    smc_n_we22,
    smc_n_wr22,
    smc_n_rd22,
    data_smc22,
    
    //PMC22 ports22
    clk_SRPG_macb0_en22,
    clk_SRPG_macb1_en22,
    clk_SRPG_macb2_en22,
    clk_SRPG_macb3_en22,
    core06v22,
    core08v22,
    core10v22,
    core12v22,
    macb3_wakeup22,
    macb2_wakeup22,
    macb1_wakeup22,
    macb0_wakeup22,
    mte_smc_start22,
    mte_uart_start22,
    mte_smc_uart_start22,  
    mte_pm_smc_to_default_start22, 
    mte_pm_uart_to_default_start22,
    mte_pm_smc_uart_to_default_start22,
    
    
    // Peripheral22 inerrupts22
    pcm_irq22,
    ttc_irq22,
    gpio_irq22,
    uart0_irq22,
    uart1_irq22,
    spi_irq22,
    DMA_irq22,      
    macb0_int22,
    macb1_int22,
    macb2_int22,
    macb3_int22,
   
    // Scan22 ports22
    scan_en22,      // Scan22 enable pin22
    scan_in_122,    // Scan22 input for first chain22
    scan_in_222,    // Scan22 input for second chain22
    scan_mode22,
    scan_out_122,   // Scan22 out for chain22 1
    scan_out_222    // Scan22 out for chain22 2
);

parameter GPIO_WIDTH22 = 16;        // GPIO22 width
parameter P_SIZE22 =   8;              // number22 of peripheral22 select22 lines22
parameter NO_OF_IRQS22  = 17;      //No of irqs22 read by apic22 

// AHB22 interface
input         hclk22;     // AHB22 Clock22
input         n_hreset22;  // AHB22 reset - Active22 low22
input         hsel22;     // AHB2APB22 select22
input [31:0]  haddr22;    // Address bus
input [1:0]   htrans22;   // Transfer22 type
input [2:0]   hsize22;    // AHB22 Access type - byte, half22-word22, word22
input [31:0]  hwdata22;   // Write data
input         hwrite22;   // Write signal22/
input         hready_in22;// Indicates22 that last master22 has finished22 bus access
input [2:0]   hburst22;     // Burst type
input [3:0]   hprot22;      // Protection22 control22
input [3:0]   hmaster22;    // Master22 select22
input         hmastlock22;  // Locked22 transfer22
output [31:0] hrdata22;       // Read data provided from target slave22
output        hready22;       // Ready22 for new bus cycle from target slave22
output [1:0]  hresp22;       // Response22 from the bridge22
    
// APB22 system interface
input         pclk22;     // APB22 Clock22. 
input         n_preset22;  // APB22 reset - Active22 low22
   
// SPI22 ports22
input     n_ss_in22;      // select22 input to slave22
input     mi22;           // data input to master22
input     si22;           // data input to slave22
input     sclk_in22;      // clock22 input to slave22
output    so;                    // data output from slave22
output    mo22;                    // data output from master22
output    sclk_out22;              // clock22 output from master22
output [P_SIZE22-1:0] n_ss_out22;    // peripheral22 select22 lines22 from master22
output    n_so_en22;               // out enable for slave22 data
output    n_mo_en22;               // out enable for master22 data
output    n_sclk_en22;             // out enable for master22 clock22
output    n_ss_en22;               // out enable for master22 peripheral22 lines22

//UART022 ports22
input        ua_rxd22;       // UART22 receiver22 serial22 input pin22
input        ua_ncts22;      // Clear-To22-Send22 flow22 control22
output       ua_txd22;       	// UART22 transmitter22 serial22 output
output       ua_nrts22;      	// Request22-To22-Send22 flow22 control22

// UART122 ports22   
input        ua_rxd122;      // UART22 receiver22 serial22 input pin22
input        ua_ncts122;      // Clear-To22-Send22 flow22 control22
output       ua_txd122;       // UART22 transmitter22 serial22 output
output       ua_nrts122;      // Request22-To22-Send22 flow22 control22

//GPIO22 ports22
input [GPIO_WIDTH22-1:0]      gpio_pin_in22;             // input data from pin22
output [GPIO_WIDTH22-1:0]     n_gpio_pin_oe22;           // output enable signal22 to pin22
output [GPIO_WIDTH22-1:0]     gpio_pin_out22;            // output signal22 to pin22
  
//SMC22 ports22
input        smc_hclk22;
input        smc_n_hclk22;
input [31:0] smc_haddr22;
input [1:0]  smc_htrans22;
input        smc_hsel22;
input        smc_hwrite22;
input [2:0]  smc_hsize22;
input [31:0] smc_hwdata22;
input        smc_hready_in22;
input [2:0]  smc_hburst22;     // Burst type
input [3:0]  smc_hprot22;      // Protection22 control22
input [3:0]  smc_hmaster22;    // Master22 select22
input        smc_hmastlock22;  // Locked22 transfer22
input [31:0] data_smc22;     // EMI22(External22 memory) read data
output [31:0]    smc_hrdata22;
output           smc_hready22;
output [1:0]     smc_hresp22;
output [15:0]    smc_addr22;      // External22 Memory (EMI22) address
output [3:0]     smc_n_be22;      // EMI22 byte enables22 (Active22 LOW22)
output           smc_n_cs22;      // EMI22 Chip22 Selects22 (Active22 LOW22)
output [3:0]     smc_n_we22;      // EMI22 write strobes22 (Active22 LOW22)
output           smc_n_wr22;      // EMI22 write enable (Active22 LOW22)
output           smc_n_rd22;      // EMI22 read stobe22 (Active22 LOW22)
output           smc_n_ext_oe22;  // EMI22 write data output enable
output [31:0]    smc_data22;      // EMI22 write data
       
//PMC22 ports22
output clk_SRPG_macb0_en22;
output clk_SRPG_macb1_en22;
output clk_SRPG_macb2_en22;
output clk_SRPG_macb3_en22;
output core06v22;
output core08v22;
output core10v22;
output core12v22;
output mte_smc_start22;
output mte_uart_start22;
output mte_smc_uart_start22;  
output mte_pm_smc_to_default_start22; 
output mte_pm_uart_to_default_start22;
output mte_pm_smc_uart_to_default_start22;
input macb3_wakeup22;
input macb2_wakeup22;
input macb1_wakeup22;
input macb0_wakeup22;
    

// Peripheral22 interrupts22
output pcm_irq22;
output [2:0] ttc_irq22;
output gpio_irq22;
output uart0_irq22;
output uart1_irq22;
output spi_irq22;
input        macb0_int22;
input        macb1_int22;
input        macb2_int22;
input        macb3_int22;
input        DMA_irq22;
  
//Scan22 ports22
input        scan_en22;    // Scan22 enable pin22
input        scan_in_122;  // Scan22 input for first chain22
input        scan_in_222;  // Scan22 input for second chain22
input        scan_mode22;  // test mode pin22
 output        scan_out_122;   // Scan22 out for chain22 1
 output        scan_out_222;   // Scan22 out for chain22 2  

//------------------------------------------------------------------------------
// if the ROM22 subsystem22 is NOT22 black22 boxed22 
//------------------------------------------------------------------------------
`ifndef FV_KIT_BLACK_BOX_APB_SUBSYSTEM22
   
   wire        hsel22; 
   wire        pclk22;
   wire        n_preset22;
   wire [31:0] prdata_spi22;
   wire [31:0] prdata_uart022;
   wire [31:0] prdata_gpio22;
   wire [31:0] prdata_ttc22;
   wire [31:0] prdata_smc22;
   wire [31:0] prdata_pmc22;
   wire [31:0] prdata_uart122;
   wire        pready_spi22;
   wire        pready_uart022;
   wire        pready_uart122;
   wire        tie_hi_bit22;
   wire  [31:0] hrdata22; 
   wire         hready22;
   wire         hready_in22;
   wire  [1:0]  hresp22;   
   wire  [31:0] pwdata22;  
   wire         pwrite22;
   wire  [31:0] paddr22;  
   wire   psel_spi22;
   wire   psel_uart022;
   wire   psel_gpio22;
   wire   psel_ttc22;
   wire   psel_smc22;
   wire   psel0722;
   wire   psel0822;
   wire   psel0922;
   wire   psel1022;
   wire   psel1122;
   wire   psel1222;
   wire   psel_pmc22;
   wire   psel_uart122;
   wire   penable22;
   wire   [NO_OF_IRQS22:0] int_source22;     // System22 Interrupt22 Sources22
   wire [1:0]             smc_hresp22;     // AHB22 Response22 signal22
   wire                   smc_valid22;     // Ack22 valid address

  //External22 memory interface (EMI22)
  wire [31:0]            smc_addr_int22;  // External22 Memory (EMI22) address
  wire [3:0]             smc_n_be22;      // EMI22 byte enables22 (Active22 LOW22)
  wire                   smc_n_cs22;      // EMI22 Chip22 Selects22 (Active22 LOW22)
  wire [3:0]             smc_n_we22;      // EMI22 write strobes22 (Active22 LOW22)
  wire                   smc_n_wr22;      // EMI22 write enable (Active22 LOW22)
  wire                   smc_n_rd22;      // EMI22 read stobe22 (Active22 LOW22)
 
  //AHB22 Memory Interface22 Control22
  wire                   smc_hsel_int22;
  wire                   smc_busy22;      // smc22 busy
   

//scan22 signals22

   wire                scan_in_122;        //scan22 input
   wire                scan_in_222;        //scan22 input
   wire                scan_en22;         //scan22 enable
   wire                scan_out_122;       //scan22 output
   wire                scan_out_222;       //scan22 output
   wire                byte_sel22;     // byte select22 from bridge22 1=byte, 0=2byte
   wire                UART_int22;     // UART22 module interrupt22 
   wire                ua_uclken22;    // Soft22 control22 of clock22
   wire                UART_int122;     // UART22 module interrupt22 
   wire                ua_uclken122;    // Soft22 control22 of clock22
   wire  [3:1]         TTC_int22;            //Interrupt22 from PCI22 
  // inputs22 to SPI22 
   wire    ext_clk22;                // external22 clock22
   wire    SPI_int22;             // interrupt22 request
  // outputs22 from SPI22
   wire    slave_out_clk22;         // modified slave22 clock22 output
 // gpio22 generic22 inputs22 
   wire  [GPIO_WIDTH22-1:0]   n_gpio_bypass_oe22;        // bypass22 mode enable 
   wire  [GPIO_WIDTH22-1:0]   gpio_bypass_out22;         // bypass22 mode output value 
   wire  [GPIO_WIDTH22-1:0]   tri_state_enable22;   // disables22 op enable -> z 
 // outputs22 
   //amba22 outputs22 
   // gpio22 generic22 outputs22 
   wire       GPIO_int22;                // gpio_interupt22 for input pin22 change 
   wire [GPIO_WIDTH22-1:0]     gpio_bypass_in22;          // bypass22 mode input data value  
                
   wire           cpu_debug22;        // Inhibits22 watchdog22 counter 
   wire            ex_wdz_n22;         // External22 Watchdog22 zero indication22
   wire           rstn_non_srpg_smc22; 
   wire           rstn_non_srpg_urt22;
   wire           isolate_smc22;
   wire           save_edge_smc22;
   wire           restore_edge_smc22;
   wire           save_edge_urt22;
   wire           restore_edge_urt22;
   wire           pwr1_on_smc22;
   wire           pwr2_on_smc22;
   wire           pwr1_on_urt22;
   wire           pwr2_on_urt22;
   // ETH022
   wire            rstn_non_srpg_macb022;
   wire            gate_clk_macb022;
   wire            isolate_macb022;
   wire            save_edge_macb022;
   wire            restore_edge_macb022;
   wire            pwr1_on_macb022;
   wire            pwr2_on_macb022;
   // ETH122
   wire            rstn_non_srpg_macb122;
   wire            gate_clk_macb122;
   wire            isolate_macb122;
   wire            save_edge_macb122;
   wire            restore_edge_macb122;
   wire            pwr1_on_macb122;
   wire            pwr2_on_macb122;
   // ETH222
   wire            rstn_non_srpg_macb222;
   wire            gate_clk_macb222;
   wire            isolate_macb222;
   wire            save_edge_macb222;
   wire            restore_edge_macb222;
   wire            pwr1_on_macb222;
   wire            pwr2_on_macb222;
   // ETH322
   wire            rstn_non_srpg_macb322;
   wire            gate_clk_macb322;
   wire            isolate_macb322;
   wire            save_edge_macb322;
   wire            restore_edge_macb322;
   wire            pwr1_on_macb322;
   wire            pwr2_on_macb322;


   wire           pclk_SRPG_smc22;
   wire           pclk_SRPG_urt22;
   wire           gate_clk_smc22;
   wire           gate_clk_urt22;
   wire  [31:0]   tie_lo_32bit22; 
   wire  [1:0]	  tie_lo_2bit22;
   wire  	  tie_lo_1bit22;
   wire           pcm_macb_wakeup_int22;
   wire           int_source_h22;
   wire           isolate_mem22;

assign pcm_irq22 = pcm_macb_wakeup_int22;
assign ttc_irq22[2] = TTC_int22[3];
assign ttc_irq22[1] = TTC_int22[2];
assign ttc_irq22[0] = TTC_int22[1];
assign gpio_irq22 = GPIO_int22;
assign uart0_irq22 = UART_int22;
assign uart1_irq22 = UART_int122;
assign spi_irq22 = SPI_int22;

assign n_mo_en22   = 1'b0;
assign n_so_en22   = 1'b1;
assign n_sclk_en22 = 1'b0;
assign n_ss_en22   = 1'b0;

assign smc_hsel_int22 = smc_hsel22;
  assign ext_clk22  = 1'b0;
  assign int_source22 = {macb0_int22,macb1_int22, macb2_int22, macb3_int22,1'b0, pcm_macb_wakeup_int22, 1'b0, 1'b0, 1'b0, 1'b0, TTC_int22, GPIO_int22, UART_int22, UART_int122, SPI_int22, DMA_irq22};

  // interrupt22 even22 detect22 .
  // for sleep22 wake22 up -> any interrupt22 even22 and system not in hibernation22 (isolate_mem22 = 0)
  // for hibernate22 wake22 up -> gpio22 interrupt22 even22 and system in the hibernation22 (isolate_mem22 = 1)
  assign int_source_h22 =  ((|int_source22) && (!isolate_mem22)) || (isolate_mem22 && GPIO_int22) ;

  assign byte_sel22 = 1'b1;
  assign tie_hi_bit22 = 1'b1;

  assign smc_addr22 = smc_addr_int22[15:0];



  assign  n_gpio_bypass_oe22 = {GPIO_WIDTH22{1'b0}};        // bypass22 mode enable 
  assign  gpio_bypass_out22  = {GPIO_WIDTH22{1'b0}};
  assign  tri_state_enable22 = {GPIO_WIDTH22{1'b0}};
  assign  cpu_debug22 = 1'b0;
  assign  tie_lo_32bit22 = 32'b0;
  assign  tie_lo_2bit22  = 2'b0;
  assign  tie_lo_1bit22  = 1'b0;


ahb2apb22 #(
  32'h00800000, // Slave22 0 Address Range22
  32'h0080FFFF,

  32'h00810000, // Slave22 1 Address Range22
  32'h0081FFFF,

  32'h00820000, // Slave22 2 Address Range22 
  32'h0082FFFF,

  32'h00830000, // Slave22 3 Address Range22
  32'h0083FFFF,

  32'h00840000, // Slave22 4 Address Range22
  32'h0084FFFF,

  32'h00850000, // Slave22 5 Address Range22
  32'h0085FFFF,

  32'h00860000, // Slave22 6 Address Range22
  32'h0086FFFF,

  32'h00870000, // Slave22 7 Address Range22
  32'h0087FFFF,

  32'h00880000, // Slave22 8 Address Range22
  32'h0088FFFF
) i_ahb2apb22 (
     // AHB22 interface
    .hclk22(hclk22),         
    .hreset_n22(n_hreset22), 
    .hsel22(hsel22), 
    .haddr22(haddr22),        
    .htrans22(htrans22),       
    .hwrite22(hwrite22),       
    .hwdata22(hwdata22),       
    .hrdata22(hrdata22),   
    .hready22(hready22),   
    .hresp22(hresp22),     
    
     // APB22 interface
    .pclk22(pclk22),         
    .preset_n22(n_preset22),  
    .prdata022(prdata_spi22),
    .prdata122(prdata_uart022), 
    .prdata222(prdata_gpio22),  
    .prdata322(prdata_ttc22),   
    .prdata422(32'h0),   
    .prdata522(prdata_smc22),   
    .prdata622(prdata_pmc22),    
    .prdata722(32'h0),   
    .prdata822(prdata_uart122),  
    .pready022(pready_spi22),     
    .pready122(pready_uart022),   
    .pready222(tie_hi_bit22),     
    .pready322(tie_hi_bit22),     
    .pready422(tie_hi_bit22),     
    .pready522(tie_hi_bit22),     
    .pready622(tie_hi_bit22),     
    .pready722(tie_hi_bit22),     
    .pready822(pready_uart122),  
    .pwdata22(pwdata22),       
    .pwrite22(pwrite22),       
    .paddr22(paddr22),        
    .psel022(psel_spi22),     
    .psel122(psel_uart022),   
    .psel222(psel_gpio22),    
    .psel322(psel_ttc22),     
    .psel422(),     
    .psel522(psel_smc22),     
    .psel622(psel_pmc22),    
    .psel722(psel_apic22),   
    .psel822(psel_uart122),  
    .penable22(penable22)     
);

spi_top22 i_spi22
(
  // Wishbone22 signals22
  .wb_clk_i22(pclk22), 
  .wb_rst_i22(~n_preset22), 
  .wb_adr_i22(paddr22[4:0]), 
  .wb_dat_i22(pwdata22), 
  .wb_dat_o22(prdata_spi22), 
  .wb_sel_i22(4'b1111),    // SPI22 register accesses are always 32-bit
  .wb_we_i22(pwrite22), 
  .wb_stb_i22(psel_spi22), 
  .wb_cyc_i22(psel_spi22), 
  .wb_ack_o22(pready_spi22), 
  .wb_err_o22(), 
  .wb_int_o22(SPI_int22),

  // SPI22 signals22
  .ss_pad_o22(n_ss_out22), 
  .sclk_pad_o22(sclk_out22), 
  .mosi_pad_o22(mo22), 
  .miso_pad_i22(mi22)
);

// Opencores22 UART22 instances22
wire ua_nrts_int22;
wire ua_nrts1_int22;

assign ua_nrts22 = ua_nrts_int22;
assign ua_nrts122 = ua_nrts1_int22;

reg [3:0] uart0_sel_i22;
reg [3:0] uart1_sel_i22;
// UART22 registers are all 8-bit wide22, and their22 addresses22
// are on byte boundaries22. So22 to access them22 on the
// Wishbone22 bus, the CPU22 must do byte accesses to these22
// byte addresses22. Word22 address accesses are not possible22
// because the word22 addresses22 will be unaligned22, and cause
// a fault22.
// So22, Uart22 accesses from the CPU22 will always be 8-bit size
// We22 only have to decide22 which byte of the 4-byte word22 the
// CPU22 is interested22 in.
`ifdef SYSTEM_BIG_ENDIAN22
always @(paddr22) begin
  case (paddr22[1:0])
    2'b00 : uart0_sel_i22 = 4'b1000;
    2'b01 : uart0_sel_i22 = 4'b0100;
    2'b10 : uart0_sel_i22 = 4'b0010;
    2'b11 : uart0_sel_i22 = 4'b0001;
  endcase
end
always @(paddr22) begin
  case (paddr22[1:0])
    2'b00 : uart1_sel_i22 = 4'b1000;
    2'b01 : uart1_sel_i22 = 4'b0100;
    2'b10 : uart1_sel_i22 = 4'b0010;
    2'b11 : uart1_sel_i22 = 4'b0001;
  endcase
end
`else
always @(paddr22) begin
  case (paddr22[1:0])
    2'b00 : uart0_sel_i22 = 4'b0001;
    2'b01 : uart0_sel_i22 = 4'b0010;
    2'b10 : uart0_sel_i22 = 4'b0100;
    2'b11 : uart0_sel_i22 = 4'b1000;
  endcase
end
always @(paddr22) begin
  case (paddr22[1:0])
    2'b00 : uart1_sel_i22 = 4'b0001;
    2'b01 : uart1_sel_i22 = 4'b0010;
    2'b10 : uart1_sel_i22 = 4'b0100;
    2'b11 : uart1_sel_i22 = 4'b1000;
  endcase
end
`endif

uart_top22 i_oc_uart022 (
  .wb_clk_i22(pclk22),
  .wb_rst_i22(~n_preset22),
  .wb_adr_i22(paddr22[4:0]),
  .wb_dat_i22(pwdata22),
  .wb_dat_o22(prdata_uart022),
  .wb_we_i22(pwrite22),
  .wb_stb_i22(psel_uart022),
  .wb_cyc_i22(psel_uart022),
  .wb_ack_o22(pready_uart022),
  .wb_sel_i22(uart0_sel_i22),
  .int_o22(UART_int22),
  .stx_pad_o22(ua_txd22),
  .srx_pad_i22(ua_rxd22),
  .rts_pad_o22(ua_nrts_int22),
  .cts_pad_i22(ua_ncts22),
  .dtr_pad_o22(),
  .dsr_pad_i22(1'b0),
  .ri_pad_i22(1'b0),
  .dcd_pad_i22(1'b0)
);

uart_top22 i_oc_uart122 (
  .wb_clk_i22(pclk22),
  .wb_rst_i22(~n_preset22),
  .wb_adr_i22(paddr22[4:0]),
  .wb_dat_i22(pwdata22),
  .wb_dat_o22(prdata_uart122),
  .wb_we_i22(pwrite22),
  .wb_stb_i22(psel_uart122),
  .wb_cyc_i22(psel_uart122),
  .wb_ack_o22(pready_uart122),
  .wb_sel_i22(uart1_sel_i22),
  .int_o22(UART_int122),
  .stx_pad_o22(ua_txd122),
  .srx_pad_i22(ua_rxd122),
  .rts_pad_o22(ua_nrts1_int22),
  .cts_pad_i22(ua_ncts122),
  .dtr_pad_o22(),
  .dsr_pad_i22(1'b0),
  .ri_pad_i22(1'b0),
  .dcd_pad_i22(1'b0)
);

gpio_veneer22 i_gpio_veneer22 (
        //inputs22

        . n_p_reset22(n_preset22),
        . pclk22(pclk22),
        . psel22(psel_gpio22),
        . penable22(penable22),
        . pwrite22(pwrite22),
        . paddr22(paddr22[5:0]),
        . pwdata22(pwdata22),
        . gpio_pin_in22(gpio_pin_in22),
        . scan_en22(scan_en22),
        . tri_state_enable22(tri_state_enable22),
        . scan_in22(), //added by smarkov22 for dft22

        //outputs22
        . scan_out22(), //added by smarkov22 for dft22
        . prdata22(prdata_gpio22),
        . gpio_int22(GPIO_int22),
        . n_gpio_pin_oe22(n_gpio_pin_oe22),
        . gpio_pin_out22(gpio_pin_out22)
);


ttc_veneer22 i_ttc_veneer22 (

         //inputs22
        . n_p_reset22(n_preset22),
        . pclk22(pclk22),
        . psel22(psel_ttc22),
        . penable22(penable22),
        . pwrite22(pwrite22),
        . pwdata22(pwdata22),
        . paddr22(paddr22[7:0]),
        . scan_in22(),
        . scan_en22(scan_en22),

        //outputs22
        . prdata22(prdata_ttc22),
        . interrupt22(TTC_int22[3:1]),
        . scan_out22()
);


smc_veneer22 i_smc_veneer22 (
        //inputs22
	//apb22 inputs22
        . n_preset22(n_preset22),
        . pclk22(pclk_SRPG_smc22),
        . psel22(psel_smc22),
        . penable22(penable22),
        . pwrite22(pwrite22),
        . paddr22(paddr22[4:0]),
        . pwdata22(pwdata22),
        //ahb22 inputs22
	. hclk22(smc_hclk22),
        . n_sys_reset22(rstn_non_srpg_smc22),
        . haddr22(smc_haddr22),
        . htrans22(smc_htrans22),
        . hsel22(smc_hsel_int22),
        . hwrite22(smc_hwrite22),
	. hsize22(smc_hsize22),
        . hwdata22(smc_hwdata22),
        . hready22(smc_hready_in22),
        . data_smc22(data_smc22),

         //test signal22 inputs22

        . scan_in_122(),
        . scan_in_222(),
        . scan_in_322(),
        . scan_en22(scan_en22),

        //apb22 outputs22
        . prdata22(prdata_smc22),

       //design output

        . smc_hrdata22(smc_hrdata22),
        . smc_hready22(smc_hready22),
        . smc_hresp22(smc_hresp22),
        . smc_valid22(smc_valid22),
        . smc_addr22(smc_addr_int22),
        . smc_data22(smc_data22),
        . smc_n_be22(smc_n_be22),
        . smc_n_cs22(smc_n_cs22),
        . smc_n_wr22(smc_n_wr22),
        . smc_n_we22(smc_n_we22),
        . smc_n_rd22(smc_n_rd22),
        . smc_n_ext_oe22(smc_n_ext_oe22),
        . smc_busy22(smc_busy22),

         //test signal22 output
        . scan_out_122(),
        . scan_out_222(),
        . scan_out_322()
);

power_ctrl_veneer22 i_power_ctrl_veneer22 (
    // -- Clocks22 & Reset22
    	.pclk22(pclk22), 			//  : in  std_logic22;
    	.nprst22(n_preset22), 		//  : in  std_logic22;
    // -- APB22 programming22 interface
    	.paddr22(paddr22), 			//  : in  std_logic_vector22(31 downto22 0);
    	.psel22(psel_pmc22), 			//  : in  std_logic22;
    	.penable22(penable22), 		//  : in  std_logic22;
    	.pwrite22(pwrite22), 		//  : in  std_logic22;
    	.pwdata22(pwdata22), 		//  : in  std_logic_vector22(31 downto22 0);
    	.prdata22(prdata_pmc22), 		//  : out std_logic_vector22(31 downto22 0);
        .macb3_wakeup22(macb3_wakeup22),
        .macb2_wakeup22(macb2_wakeup22),
        .macb1_wakeup22(macb1_wakeup22),
        .macb0_wakeup22(macb0_wakeup22),
    // -- Module22 control22 outputs22
    	.scan_in22(),			//  : in  std_logic22;
    	.scan_en22(scan_en22),             	//  : in  std_logic22;
    	.scan_mode22(scan_mode22),          //  : in  std_logic22;
    	.scan_out22(),            	//  : out std_logic22;
        .int_source_h22(int_source_h22),
     	.rstn_non_srpg_smc22(rstn_non_srpg_smc22), 		//   : out std_logic22;
    	.gate_clk_smc22(gate_clk_smc22), 	//  : out std_logic22;
    	.isolate_smc22(isolate_smc22), 	//  : out std_logic22;
    	.save_edge_smc22(save_edge_smc22), 	//  : out std_logic22;
    	.restore_edge_smc22(restore_edge_smc22), 	//  : out std_logic22;
    	.pwr1_on_smc22(pwr1_on_smc22), 	//  : out std_logic22;
    	.pwr2_on_smc22(pwr2_on_smc22), 	//  : out std_logic22
     	.rstn_non_srpg_urt22(rstn_non_srpg_urt22), 		//   : out std_logic22;
    	.gate_clk_urt22(gate_clk_urt22), 	//  : out std_logic22;
    	.isolate_urt22(isolate_urt22), 	//  : out std_logic22;
    	.save_edge_urt22(save_edge_urt22), 	//  : out std_logic22;
    	.restore_edge_urt22(restore_edge_urt22), 	//  : out std_logic22;
    	.pwr1_on_urt22(pwr1_on_urt22), 	//  : out std_logic22;
    	.pwr2_on_urt22(pwr2_on_urt22),  	//  : out std_logic22
        // ETH022
        .rstn_non_srpg_macb022(rstn_non_srpg_macb022),
        .gate_clk_macb022(gate_clk_macb022),
        .isolate_macb022(isolate_macb022),
        .save_edge_macb022(save_edge_macb022),
        .restore_edge_macb022(restore_edge_macb022),
        .pwr1_on_macb022(pwr1_on_macb022),
        .pwr2_on_macb022(pwr2_on_macb022),
        // ETH122
        .rstn_non_srpg_macb122(rstn_non_srpg_macb122),
        .gate_clk_macb122(gate_clk_macb122),
        .isolate_macb122(isolate_macb122),
        .save_edge_macb122(save_edge_macb122),
        .restore_edge_macb122(restore_edge_macb122),
        .pwr1_on_macb122(pwr1_on_macb122),
        .pwr2_on_macb122(pwr2_on_macb122),
        // ETH222
        .rstn_non_srpg_macb222(rstn_non_srpg_macb222),
        .gate_clk_macb222(gate_clk_macb222),
        .isolate_macb222(isolate_macb222),
        .save_edge_macb222(save_edge_macb222),
        .restore_edge_macb222(restore_edge_macb222),
        .pwr1_on_macb222(pwr1_on_macb222),
        .pwr2_on_macb222(pwr2_on_macb222),
        // ETH322
        .rstn_non_srpg_macb322(rstn_non_srpg_macb322),
        .gate_clk_macb322(gate_clk_macb322),
        .isolate_macb322(isolate_macb322),
        .save_edge_macb322(save_edge_macb322),
        .restore_edge_macb322(restore_edge_macb322),
        .pwr1_on_macb322(pwr1_on_macb322),
        .pwr2_on_macb322(pwr2_on_macb322),
        .core06v22(core06v22),
        .core08v22(core08v22),
        .core10v22(core10v22),
        .core12v22(core12v22),
        .pcm_macb_wakeup_int22(pcm_macb_wakeup_int22),
        .isolate_mem22(isolate_mem22),
        .mte_smc_start22(mte_smc_start22),
        .mte_uart_start22(mte_uart_start22),
        .mte_smc_uart_start22(mte_smc_uart_start22),  
        .mte_pm_smc_to_default_start22(mte_pm_smc_to_default_start22), 
        .mte_pm_uart_to_default_start22(mte_pm_uart_to_default_start22),
        .mte_pm_smc_uart_to_default_start22(mte_pm_smc_uart_to_default_start22)
);

// Clock22 gating22 macro22 to shut22 off22 clocks22 to the SRPG22 flops22 in the SMC22
//CKLNQD122 i_SMC_SRPG_clk_gate22  (
//	.TE22(scan_mode22), 
//	.E22(~gate_clk_smc22), 
//	.CP22(pclk22), 
//	.Q22(pclk_SRPG_smc22)
//	);
// Replace22 gate22 with behavioural22 code22 //
wire 	smc_scan_gate22;
reg 	smc_latched_enable22;
assign smc_scan_gate22 = scan_mode22 ? 1'b1 : ~gate_clk_smc22;

always @ (pclk22 or smc_scan_gate22)
  	if (pclk22 == 1'b0) begin
  		smc_latched_enable22 <= smc_scan_gate22;
  	end  	
	
assign pclk_SRPG_smc22 = smc_latched_enable22 ? pclk22 : 1'b0;


// Clock22 gating22 macro22 to shut22 off22 clocks22 to the SRPG22 flops22 in the URT22
//CKLNQD122 i_URT_SRPG_clk_gate22  (
//	.TE22(scan_mode22), 
//	.E22(~gate_clk_urt22), 
//	.CP22(pclk22), 
//	.Q22(pclk_SRPG_urt22)
//	);
// Replace22 gate22 with behavioural22 code22 //
wire 	urt_scan_gate22;
reg 	urt_latched_enable22;
assign urt_scan_gate22 = scan_mode22 ? 1'b1 : ~gate_clk_urt22;

always @ (pclk22 or urt_scan_gate22)
  	if (pclk22 == 1'b0) begin
  		urt_latched_enable22 <= urt_scan_gate22;
  	end  	
	
assign pclk_SRPG_urt22 = urt_latched_enable22 ? pclk22 : 1'b0;

// ETH022
wire 	macb0_scan_gate22;
reg 	macb0_latched_enable22;
assign macb0_scan_gate22 = scan_mode22 ? 1'b1 : ~gate_clk_macb022;

always @ (pclk22 or macb0_scan_gate22)
  	if (pclk22 == 1'b0) begin
  		macb0_latched_enable22 <= macb0_scan_gate22;
  	end  	
	
assign clk_SRPG_macb0_en22 = macb0_latched_enable22 ? 1'b1 : 1'b0;

// ETH122
wire 	macb1_scan_gate22;
reg 	macb1_latched_enable22;
assign macb1_scan_gate22 = scan_mode22 ? 1'b1 : ~gate_clk_macb122;

always @ (pclk22 or macb1_scan_gate22)
  	if (pclk22 == 1'b0) begin
  		macb1_latched_enable22 <= macb1_scan_gate22;
  	end  	
	
assign clk_SRPG_macb1_en22 = macb1_latched_enable22 ? 1'b1 : 1'b0;

// ETH222
wire 	macb2_scan_gate22;
reg 	macb2_latched_enable22;
assign macb2_scan_gate22 = scan_mode22 ? 1'b1 : ~gate_clk_macb222;

always @ (pclk22 or macb2_scan_gate22)
  	if (pclk22 == 1'b0) begin
  		macb2_latched_enable22 <= macb2_scan_gate22;
  	end  	
	
assign clk_SRPG_macb2_en22 = macb2_latched_enable22 ? 1'b1 : 1'b0;

// ETH322
wire 	macb3_scan_gate22;
reg 	macb3_latched_enable22;
assign macb3_scan_gate22 = scan_mode22 ? 1'b1 : ~gate_clk_macb322;

always @ (pclk22 or macb3_scan_gate22)
  	if (pclk22 == 1'b0) begin
  		macb3_latched_enable22 <= macb3_scan_gate22;
  	end  	
	
assign clk_SRPG_macb3_en22 = macb3_latched_enable22 ? 1'b1 : 1'b0;



`else
//------------------------------------------------------------------------------
// if the APB22 subsystem22 is black22 boxed22 
//------------------------------------------------------------------------------
// wire s ports22
    // system signals22
    wire         hclk22;     // AHB22 Clock22
    wire         n_hreset22;  // AHB22 reset - Active22 low22
    wire         pclk22;     // APB22 Clock22. 
    wire         n_preset22;  // APB22 reset - Active22 low22

    // AHB22 interface
    wire         ahb2apb0_hsel22;     // AHB2APB22 select22
    wire  [31:0] haddr22;    // Address bus
    wire  [1:0]  htrans22;   // Transfer22 type
    wire  [2:0]  hsize22;    // AHB22 Access type - byte, half22-word22, word22
    wire  [31:0] hwdata22;   // Write data
    wire         hwrite22;   // Write signal22/
    wire         hready_in22;// Indicates22 that last master22 has finished22 bus access
    wire [2:0]   hburst22;     // Burst type
    wire [3:0]   hprot22;      // Protection22 control22
    wire [3:0]   hmaster22;    // Master22 select22
    wire         hmastlock22;  // Locked22 transfer22
  // Interrupts22 from the Enet22 MACs22
    wire         macb0_int22;
    wire         macb1_int22;
    wire         macb2_int22;
    wire         macb3_int22;
  // Interrupt22 from the DMA22
    wire         DMA_irq22;
  // Scan22 wire s
    wire         scan_en22;    // Scan22 enable pin22
    wire         scan_in_122;  // Scan22 wire  for first chain22
    wire         scan_in_222;  // Scan22 wire  for second chain22
    wire         scan_mode22;  // test mode pin22
 
  //wire  for smc22 AHB22 interface
    wire         smc_hclk22;
    wire         smc_n_hclk22;
    wire  [31:0] smc_haddr22;
    wire  [1:0]  smc_htrans22;
    wire         smc_hsel22;
    wire         smc_hwrite22;
    wire  [2:0]  smc_hsize22;
    wire  [31:0] smc_hwdata22;
    wire         smc_hready_in22;
    wire  [2:0]  smc_hburst22;     // Burst type
    wire  [3:0]  smc_hprot22;      // Protection22 control22
    wire  [3:0]  smc_hmaster22;    // Master22 select22
    wire         smc_hmastlock22;  // Locked22 transfer22


    wire  [31:0] data_smc22;     // EMI22(External22 memory) read data
    
  //wire s for uart22
    wire         ua_rxd22;       // UART22 receiver22 serial22 wire  pin22
    wire         ua_rxd122;      // UART22 receiver22 serial22 wire  pin22
    wire         ua_ncts22;      // Clear-To22-Send22 flow22 control22
    wire         ua_ncts122;      // Clear-To22-Send22 flow22 control22
   //wire s for spi22
    wire         n_ss_in22;      // select22 wire  to slave22
    wire         mi22;           // data wire  to master22
    wire         si22;           // data wire  to slave22
    wire         sclk_in22;      // clock22 wire  to slave22
  //wire s for GPIO22
   wire  [GPIO_WIDTH22-1:0]  gpio_pin_in22;             // wire  data from pin22

  //reg    ports22
  // Scan22 reg   s
   reg           scan_out_122;   // Scan22 out for chain22 1
   reg           scan_out_222;   // Scan22 out for chain22 2
  //AHB22 interface 
   reg    [31:0] hrdata22;       // Read data provided from target slave22
   reg           hready22;       // Ready22 for new bus cycle from target slave22
   reg    [1:0]  hresp22;       // Response22 from the bridge22

   // SMC22 reg    for AHB22 interface
   reg    [31:0]    smc_hrdata22;
   reg              smc_hready22;
   reg    [1:0]     smc_hresp22;

  //reg   s from smc22
   reg    [15:0]    smc_addr22;      // External22 Memory (EMI22) address
   reg    [3:0]     smc_n_be22;      // EMI22 byte enables22 (Active22 LOW22)
   reg    [7:0]     smc_n_cs22;      // EMI22 Chip22 Selects22 (Active22 LOW22)
   reg    [3:0]     smc_n_we22;      // EMI22 write strobes22 (Active22 LOW22)
   reg              smc_n_wr22;      // EMI22 write enable (Active22 LOW22)
   reg              smc_n_rd22;      // EMI22 read stobe22 (Active22 LOW22)
   reg              smc_n_ext_oe22;  // EMI22 write data reg    enable
   reg    [31:0]    smc_data22;      // EMI22 write data
  //reg   s from uart22
   reg           ua_txd22;       	// UART22 transmitter22 serial22 reg   
   reg           ua_txd122;       // UART22 transmitter22 serial22 reg   
   reg           ua_nrts22;      	// Request22-To22-Send22 flow22 control22
   reg           ua_nrts122;      // Request22-To22-Send22 flow22 control22
   // reg   s from ttc22
  // reg   s from SPI22
   reg       so;                    // data reg    from slave22
   reg       mo22;                    // data reg    from master22
   reg       sclk_out22;              // clock22 reg    from master22
   reg    [P_SIZE22-1:0] n_ss_out22;    // peripheral22 select22 lines22 from master22
   reg       n_so_en22;               // out enable for slave22 data
   reg       n_mo_en22;               // out enable for master22 data
   reg       n_sclk_en22;             // out enable for master22 clock22
   reg       n_ss_en22;               // out enable for master22 peripheral22 lines22
  //reg   s from gpio22
   reg    [GPIO_WIDTH22-1:0]     n_gpio_pin_oe22;           // reg    enable signal22 to pin22
   reg    [GPIO_WIDTH22-1:0]     gpio_pin_out22;            // reg    signal22 to pin22


`endif
//------------------------------------------------------------------------------
// black22 boxed22 defines22 
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// APB22 and AHB22 interface formal22 verification22 monitors22
//------------------------------------------------------------------------------
`ifdef ABV_ON22
apb_assert22 i_apb_assert22 (

        // APB22 signals22
  	.n_preset22(n_preset22),
   	.pclk22(pclk22),
	.penable22(penable22),
	.paddr22(paddr22),
	.pwrite22(pwrite22),
	.pwdata22(pwdata22),

	.psel0022(psel_spi22),
	.psel0122(psel_uart022),
	.psel0222(psel_gpio22),
	.psel0322(psel_ttc22),
	.psel0422(1'b0),
	.psel0522(psel_smc22),
	.psel0622(1'b0),
	.psel0722(1'b0),
	.psel0822(1'b0),
	.psel0922(1'b0),
	.psel1022(1'b0),
	.psel1122(1'b0),
	.psel1222(1'b0),
	.psel1322(psel_pmc22),
	.psel1422(psel_apic22),
	.psel1522(psel_uart122),

        .prdata0022(prdata_spi22),
        .prdata0122(prdata_uart022), // Read Data from peripheral22 UART22 
        .prdata0222(prdata_gpio22), // Read Data from peripheral22 GPIO22
        .prdata0322(prdata_ttc22), // Read Data from peripheral22 TTC22
        .prdata0422(32'b0), // 
        .prdata0522(prdata_smc22), // Read Data from peripheral22 SMC22
        .prdata1322(prdata_pmc22), // Read Data from peripheral22 Power22 Control22 Block
   	.prdata1422(32'b0), // 
        .prdata1522(prdata_uart122),


        // AHB22 signals22
        .hclk22(hclk22),         // ahb22 system clock22
        .n_hreset22(n_hreset22), // ahb22 system reset

        // ahb2apb22 signals22
        .hresp22(hresp22),
        .hready22(hready22),
        .hrdata22(hrdata22),
        .hwdata22(hwdata22),
        .hprot22(hprot22),
        .hburst22(hburst22),
        .hsize22(hsize22),
        .hwrite22(hwrite22),
        .htrans22(htrans22),
        .haddr22(haddr22),
        .ahb2apb_hsel22(ahb2apb0_hsel22));



//------------------------------------------------------------------------------
// AHB22 interface formal22 verification22 monitor22
//------------------------------------------------------------------------------
defparam i_ahbSlaveMonitor22.DBUS_WIDTH22 = 32;
defparam i_ahbMasterMonitor22.DBUS_WIDTH22 = 32;


// AHB2APB22 Bridge22

    ahb_liteslave_monitor22 i_ahbSlaveMonitor22 (
        .hclk_i22(hclk22),
        .hresetn_i22(n_hreset22),
        .hresp22(hresp22),
        .hready22(hready22),
        .hready_global_i22(hready22),
        .hrdata22(hrdata22),
        .hwdata_i22(hwdata22),
        .hburst_i22(hburst22),
        .hsize_i22(hsize22),
        .hwrite_i22(hwrite22),
        .htrans_i22(htrans22),
        .haddr_i22(haddr22),
        .hsel_i22(ahb2apb0_hsel22)
    );


  ahb_litemaster_monitor22 i_ahbMasterMonitor22 (
          .hclk_i22(hclk22),
          .hresetn_i22(n_hreset22),
          .hresp_i22(hresp22),
          .hready_i22(hready22),
          .hrdata_i22(hrdata22),
          .hlock22(1'b0),
          .hwdata22(hwdata22),
          .hprot22(hprot22),
          .hburst22(hburst22),
          .hsize22(hsize22),
          .hwrite22(hwrite22),
          .htrans22(htrans22),
          .haddr22(haddr22)
          );







`endif




`ifdef IFV_LP_ABV_ON22
// power22 control22
wire isolate22;

// testbench mirror signals22
wire L1_ctrl_access22;
wire L1_status_access22;

wire [31:0] L1_status_reg22;
wire [31:0] L1_ctrl_reg22;

//wire rstn_non_srpg_urt22;
//wire isolate_urt22;
//wire retain_urt22;
//wire gate_clk_urt22;
//wire pwr1_on_urt22;


// smc22 signals22
wire [31:0] smc_prdata22;
wire lp_clk_smc22;
                    

// uart22 isolation22 register
  wire [15:0] ua_prdata22;
  wire ua_int22;
  assign ua_prdata22          =  i_uart1_veneer22.prdata22;
  assign ua_int22             =  i_uart1_veneer22.ua_int22;


assign lp_clk_smc22          = i_smc_veneer22.pclk22;
assign smc_prdata22          = i_smc_veneer22.prdata22;
lp_chk_smc22 u_lp_chk_smc22 (
    .clk22 (hclk22),
    .rst22 (n_hreset22),
    .iso_smc22 (isolate_smc22),
    .gate_clk22 (gate_clk_smc22),
    .lp_clk22 (pclk_SRPG_smc22),

    // srpg22 outputs22
    .smc_hrdata22 (smc_hrdata22),
    .smc_hready22 (smc_hready22),
    .smc_hresp22  (smc_hresp22),
    .smc_valid22 (smc_valid22),
    .smc_addr_int22 (smc_addr_int22),
    .smc_data22 (smc_data22),
    .smc_n_be22 (smc_n_be22),
    .smc_n_cs22  (smc_n_cs22),
    .smc_n_wr22 (smc_n_wr22),
    .smc_n_we22 (smc_n_we22),
    .smc_n_rd22 (smc_n_rd22),
    .smc_n_ext_oe22 (smc_n_ext_oe22)
   );

// lp22 retention22/isolation22 assertions22
lp_chk_uart22 u_lp_chk_urt22 (

  .clk22         (hclk22),
  .rst22         (n_hreset22),
  .iso_urt22     (isolate_urt22),
  .gate_clk22    (gate_clk_urt22),
  .lp_clk22      (pclk_SRPG_urt22),
  //ports22
  .prdata22 (ua_prdata22),
  .ua_int22 (ua_int22),
  .ua_txd22 (ua_txd122),
  .ua_nrts22 (ua_nrts122)
 );

`endif  //IFV_LP_ABV_ON22




endmodule
