//File19 name   : apb_subsystem_019.v
//Title19       : 
//Created19     : 1999
//Description19 : 
//Notes19       : 
//----------------------------------------------------------------------
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------

module apb_subsystem_019(
    // AHB19 interface
    hclk19,
    n_hreset19,
    hsel19,
    haddr19,
    htrans19,
    hsize19,
    hwrite19,
    hwdata19,
    hready_in19,
    hburst19,
    hprot19,
    hmaster19,
    hmastlock19,
    hrdata19,
    hready19,
    hresp19,
    
    // APB19 system interface
    pclk19,
    n_preset19,
    
    // SPI19 ports19
    n_ss_in19,
    mi19,
    si19,
    sclk_in19,
    so,
    mo19,
    sclk_out19,
    n_ss_out19,
    n_so_en19,
    n_mo_en19,
    n_sclk_en19,
    n_ss_en19,
    
    //UART019 ports19
    ua_rxd19,
    ua_ncts19,
    ua_txd19,
    ua_nrts19,
    
    //UART119 ports19
    ua_rxd119,
    ua_ncts119,
    ua_txd119,
    ua_nrts119,
    
    //GPIO19 ports19
    gpio_pin_in19,
    n_gpio_pin_oe19,
    gpio_pin_out19,
    

    //SMC19 ports19
    smc_hclk19,
    smc_n_hclk19,
    smc_haddr19,
    smc_htrans19,
    smc_hsel19,
    smc_hwrite19,
    smc_hsize19,
    smc_hwdata19,
    smc_hready_in19,
    smc_hburst19,
    smc_hprot19,
    smc_hmaster19,
    smc_hmastlock19,
    smc_hrdata19, 
    smc_hready19,
    smc_hresp19,
    smc_n_ext_oe19,
    smc_data19,
    smc_addr19,
    smc_n_be19,
    smc_n_cs19, 
    smc_n_we19,
    smc_n_wr19,
    smc_n_rd19,
    data_smc19,
    
    //PMC19 ports19
    clk_SRPG_macb0_en19,
    clk_SRPG_macb1_en19,
    clk_SRPG_macb2_en19,
    clk_SRPG_macb3_en19,
    core06v19,
    core08v19,
    core10v19,
    core12v19,
    macb3_wakeup19,
    macb2_wakeup19,
    macb1_wakeup19,
    macb0_wakeup19,
    mte_smc_start19,
    mte_uart_start19,
    mte_smc_uart_start19,  
    mte_pm_smc_to_default_start19, 
    mte_pm_uart_to_default_start19,
    mte_pm_smc_uart_to_default_start19,
    
    
    // Peripheral19 inerrupts19
    pcm_irq19,
    ttc_irq19,
    gpio_irq19,
    uart0_irq19,
    uart1_irq19,
    spi_irq19,
    DMA_irq19,      
    macb0_int19,
    macb1_int19,
    macb2_int19,
    macb3_int19,
   
    // Scan19 ports19
    scan_en19,      // Scan19 enable pin19
    scan_in_119,    // Scan19 input for first chain19
    scan_in_219,    // Scan19 input for second chain19
    scan_mode19,
    scan_out_119,   // Scan19 out for chain19 1
    scan_out_219    // Scan19 out for chain19 2
);

parameter GPIO_WIDTH19 = 16;        // GPIO19 width
parameter P_SIZE19 =   8;              // number19 of peripheral19 select19 lines19
parameter NO_OF_IRQS19  = 17;      //No of irqs19 read by apic19 

// AHB19 interface
input         hclk19;     // AHB19 Clock19
input         n_hreset19;  // AHB19 reset - Active19 low19
input         hsel19;     // AHB2APB19 select19
input [31:0]  haddr19;    // Address bus
input [1:0]   htrans19;   // Transfer19 type
input [2:0]   hsize19;    // AHB19 Access type - byte, half19-word19, word19
input [31:0]  hwdata19;   // Write data
input         hwrite19;   // Write signal19/
input         hready_in19;// Indicates19 that last master19 has finished19 bus access
input [2:0]   hburst19;     // Burst type
input [3:0]   hprot19;      // Protection19 control19
input [3:0]   hmaster19;    // Master19 select19
input         hmastlock19;  // Locked19 transfer19
output [31:0] hrdata19;       // Read data provided from target slave19
output        hready19;       // Ready19 for new bus cycle from target slave19
output [1:0]  hresp19;       // Response19 from the bridge19
    
// APB19 system interface
input         pclk19;     // APB19 Clock19. 
input         n_preset19;  // APB19 reset - Active19 low19
   
// SPI19 ports19
input     n_ss_in19;      // select19 input to slave19
input     mi19;           // data input to master19
input     si19;           // data input to slave19
input     sclk_in19;      // clock19 input to slave19
output    so;                    // data output from slave19
output    mo19;                    // data output from master19
output    sclk_out19;              // clock19 output from master19
output [P_SIZE19-1:0] n_ss_out19;    // peripheral19 select19 lines19 from master19
output    n_so_en19;               // out enable for slave19 data
output    n_mo_en19;               // out enable for master19 data
output    n_sclk_en19;             // out enable for master19 clock19
output    n_ss_en19;               // out enable for master19 peripheral19 lines19

//UART019 ports19
input        ua_rxd19;       // UART19 receiver19 serial19 input pin19
input        ua_ncts19;      // Clear-To19-Send19 flow19 control19
output       ua_txd19;       	// UART19 transmitter19 serial19 output
output       ua_nrts19;      	// Request19-To19-Send19 flow19 control19

// UART119 ports19   
input        ua_rxd119;      // UART19 receiver19 serial19 input pin19
input        ua_ncts119;      // Clear-To19-Send19 flow19 control19
output       ua_txd119;       // UART19 transmitter19 serial19 output
output       ua_nrts119;      // Request19-To19-Send19 flow19 control19

//GPIO19 ports19
input [GPIO_WIDTH19-1:0]      gpio_pin_in19;             // input data from pin19
output [GPIO_WIDTH19-1:0]     n_gpio_pin_oe19;           // output enable signal19 to pin19
output [GPIO_WIDTH19-1:0]     gpio_pin_out19;            // output signal19 to pin19
  
//SMC19 ports19
input        smc_hclk19;
input        smc_n_hclk19;
input [31:0] smc_haddr19;
input [1:0]  smc_htrans19;
input        smc_hsel19;
input        smc_hwrite19;
input [2:0]  smc_hsize19;
input [31:0] smc_hwdata19;
input        smc_hready_in19;
input [2:0]  smc_hburst19;     // Burst type
input [3:0]  smc_hprot19;      // Protection19 control19
input [3:0]  smc_hmaster19;    // Master19 select19
input        smc_hmastlock19;  // Locked19 transfer19
input [31:0] data_smc19;     // EMI19(External19 memory) read data
output [31:0]    smc_hrdata19;
output           smc_hready19;
output [1:0]     smc_hresp19;
output [15:0]    smc_addr19;      // External19 Memory (EMI19) address
output [3:0]     smc_n_be19;      // EMI19 byte enables19 (Active19 LOW19)
output           smc_n_cs19;      // EMI19 Chip19 Selects19 (Active19 LOW19)
output [3:0]     smc_n_we19;      // EMI19 write strobes19 (Active19 LOW19)
output           smc_n_wr19;      // EMI19 write enable (Active19 LOW19)
output           smc_n_rd19;      // EMI19 read stobe19 (Active19 LOW19)
output           smc_n_ext_oe19;  // EMI19 write data output enable
output [31:0]    smc_data19;      // EMI19 write data
       
//PMC19 ports19
output clk_SRPG_macb0_en19;
output clk_SRPG_macb1_en19;
output clk_SRPG_macb2_en19;
output clk_SRPG_macb3_en19;
output core06v19;
output core08v19;
output core10v19;
output core12v19;
output mte_smc_start19;
output mte_uart_start19;
output mte_smc_uart_start19;  
output mte_pm_smc_to_default_start19; 
output mte_pm_uart_to_default_start19;
output mte_pm_smc_uart_to_default_start19;
input macb3_wakeup19;
input macb2_wakeup19;
input macb1_wakeup19;
input macb0_wakeup19;
    

// Peripheral19 interrupts19
output pcm_irq19;
output [2:0] ttc_irq19;
output gpio_irq19;
output uart0_irq19;
output uart1_irq19;
output spi_irq19;
input        macb0_int19;
input        macb1_int19;
input        macb2_int19;
input        macb3_int19;
input        DMA_irq19;
  
//Scan19 ports19
input        scan_en19;    // Scan19 enable pin19
input        scan_in_119;  // Scan19 input for first chain19
input        scan_in_219;  // Scan19 input for second chain19
input        scan_mode19;  // test mode pin19
 output        scan_out_119;   // Scan19 out for chain19 1
 output        scan_out_219;   // Scan19 out for chain19 2  

//------------------------------------------------------------------------------
// if the ROM19 subsystem19 is NOT19 black19 boxed19 
//------------------------------------------------------------------------------
`ifndef FV_KIT_BLACK_BOX_APB_SUBSYSTEM19
   
   wire        hsel19; 
   wire        pclk19;
   wire        n_preset19;
   wire [31:0] prdata_spi19;
   wire [31:0] prdata_uart019;
   wire [31:0] prdata_gpio19;
   wire [31:0] prdata_ttc19;
   wire [31:0] prdata_smc19;
   wire [31:0] prdata_pmc19;
   wire [31:0] prdata_uart119;
   wire        pready_spi19;
   wire        pready_uart019;
   wire        pready_uart119;
   wire        tie_hi_bit19;
   wire  [31:0] hrdata19; 
   wire         hready19;
   wire         hready_in19;
   wire  [1:0]  hresp19;   
   wire  [31:0] pwdata19;  
   wire         pwrite19;
   wire  [31:0] paddr19;  
   wire   psel_spi19;
   wire   psel_uart019;
   wire   psel_gpio19;
   wire   psel_ttc19;
   wire   psel_smc19;
   wire   psel0719;
   wire   psel0819;
   wire   psel0919;
   wire   psel1019;
   wire   psel1119;
   wire   psel1219;
   wire   psel_pmc19;
   wire   psel_uart119;
   wire   penable19;
   wire   [NO_OF_IRQS19:0] int_source19;     // System19 Interrupt19 Sources19
   wire [1:0]             smc_hresp19;     // AHB19 Response19 signal19
   wire                   smc_valid19;     // Ack19 valid address

  //External19 memory interface (EMI19)
  wire [31:0]            smc_addr_int19;  // External19 Memory (EMI19) address
  wire [3:0]             smc_n_be19;      // EMI19 byte enables19 (Active19 LOW19)
  wire                   smc_n_cs19;      // EMI19 Chip19 Selects19 (Active19 LOW19)
  wire [3:0]             smc_n_we19;      // EMI19 write strobes19 (Active19 LOW19)
  wire                   smc_n_wr19;      // EMI19 write enable (Active19 LOW19)
  wire                   smc_n_rd19;      // EMI19 read stobe19 (Active19 LOW19)
 
  //AHB19 Memory Interface19 Control19
  wire                   smc_hsel_int19;
  wire                   smc_busy19;      // smc19 busy
   

//scan19 signals19

   wire                scan_in_119;        //scan19 input
   wire                scan_in_219;        //scan19 input
   wire                scan_en19;         //scan19 enable
   wire                scan_out_119;       //scan19 output
   wire                scan_out_219;       //scan19 output
   wire                byte_sel19;     // byte select19 from bridge19 1=byte, 0=2byte
   wire                UART_int19;     // UART19 module interrupt19 
   wire                ua_uclken19;    // Soft19 control19 of clock19
   wire                UART_int119;     // UART19 module interrupt19 
   wire                ua_uclken119;    // Soft19 control19 of clock19
   wire  [3:1]         TTC_int19;            //Interrupt19 from PCI19 
  // inputs19 to SPI19 
   wire    ext_clk19;                // external19 clock19
   wire    SPI_int19;             // interrupt19 request
  // outputs19 from SPI19
   wire    slave_out_clk19;         // modified slave19 clock19 output
 // gpio19 generic19 inputs19 
   wire  [GPIO_WIDTH19-1:0]   n_gpio_bypass_oe19;        // bypass19 mode enable 
   wire  [GPIO_WIDTH19-1:0]   gpio_bypass_out19;         // bypass19 mode output value 
   wire  [GPIO_WIDTH19-1:0]   tri_state_enable19;   // disables19 op enable -> z 
 // outputs19 
   //amba19 outputs19 
   // gpio19 generic19 outputs19 
   wire       GPIO_int19;                // gpio_interupt19 for input pin19 change 
   wire [GPIO_WIDTH19-1:0]     gpio_bypass_in19;          // bypass19 mode input data value  
                
   wire           cpu_debug19;        // Inhibits19 watchdog19 counter 
   wire            ex_wdz_n19;         // External19 Watchdog19 zero indication19
   wire           rstn_non_srpg_smc19; 
   wire           rstn_non_srpg_urt19;
   wire           isolate_smc19;
   wire           save_edge_smc19;
   wire           restore_edge_smc19;
   wire           save_edge_urt19;
   wire           restore_edge_urt19;
   wire           pwr1_on_smc19;
   wire           pwr2_on_smc19;
   wire           pwr1_on_urt19;
   wire           pwr2_on_urt19;
   // ETH019
   wire            rstn_non_srpg_macb019;
   wire            gate_clk_macb019;
   wire            isolate_macb019;
   wire            save_edge_macb019;
   wire            restore_edge_macb019;
   wire            pwr1_on_macb019;
   wire            pwr2_on_macb019;
   // ETH119
   wire            rstn_non_srpg_macb119;
   wire            gate_clk_macb119;
   wire            isolate_macb119;
   wire            save_edge_macb119;
   wire            restore_edge_macb119;
   wire            pwr1_on_macb119;
   wire            pwr2_on_macb119;
   // ETH219
   wire            rstn_non_srpg_macb219;
   wire            gate_clk_macb219;
   wire            isolate_macb219;
   wire            save_edge_macb219;
   wire            restore_edge_macb219;
   wire            pwr1_on_macb219;
   wire            pwr2_on_macb219;
   // ETH319
   wire            rstn_non_srpg_macb319;
   wire            gate_clk_macb319;
   wire            isolate_macb319;
   wire            save_edge_macb319;
   wire            restore_edge_macb319;
   wire            pwr1_on_macb319;
   wire            pwr2_on_macb319;


   wire           pclk_SRPG_smc19;
   wire           pclk_SRPG_urt19;
   wire           gate_clk_smc19;
   wire           gate_clk_urt19;
   wire  [31:0]   tie_lo_32bit19; 
   wire  [1:0]	  tie_lo_2bit19;
   wire  	  tie_lo_1bit19;
   wire           pcm_macb_wakeup_int19;
   wire           int_source_h19;
   wire           isolate_mem19;

assign pcm_irq19 = pcm_macb_wakeup_int19;
assign ttc_irq19[2] = TTC_int19[3];
assign ttc_irq19[1] = TTC_int19[2];
assign ttc_irq19[0] = TTC_int19[1];
assign gpio_irq19 = GPIO_int19;
assign uart0_irq19 = UART_int19;
assign uart1_irq19 = UART_int119;
assign spi_irq19 = SPI_int19;

assign n_mo_en19   = 1'b0;
assign n_so_en19   = 1'b1;
assign n_sclk_en19 = 1'b0;
assign n_ss_en19   = 1'b0;

assign smc_hsel_int19 = smc_hsel19;
  assign ext_clk19  = 1'b0;
  assign int_source19 = {macb0_int19,macb1_int19, macb2_int19, macb3_int19,1'b0, pcm_macb_wakeup_int19, 1'b0, 1'b0, 1'b0, 1'b0, TTC_int19, GPIO_int19, UART_int19, UART_int119, SPI_int19, DMA_irq19};

  // interrupt19 even19 detect19 .
  // for sleep19 wake19 up -> any interrupt19 even19 and system not in hibernation19 (isolate_mem19 = 0)
  // for hibernate19 wake19 up -> gpio19 interrupt19 even19 and system in the hibernation19 (isolate_mem19 = 1)
  assign int_source_h19 =  ((|int_source19) && (!isolate_mem19)) || (isolate_mem19 && GPIO_int19) ;

  assign byte_sel19 = 1'b1;
  assign tie_hi_bit19 = 1'b1;

  assign smc_addr19 = smc_addr_int19[15:0];



  assign  n_gpio_bypass_oe19 = {GPIO_WIDTH19{1'b0}};        // bypass19 mode enable 
  assign  gpio_bypass_out19  = {GPIO_WIDTH19{1'b0}};
  assign  tri_state_enable19 = {GPIO_WIDTH19{1'b0}};
  assign  cpu_debug19 = 1'b0;
  assign  tie_lo_32bit19 = 32'b0;
  assign  tie_lo_2bit19  = 2'b0;
  assign  tie_lo_1bit19  = 1'b0;


ahb2apb19 #(
  32'h00800000, // Slave19 0 Address Range19
  32'h0080FFFF,

  32'h00810000, // Slave19 1 Address Range19
  32'h0081FFFF,

  32'h00820000, // Slave19 2 Address Range19 
  32'h0082FFFF,

  32'h00830000, // Slave19 3 Address Range19
  32'h0083FFFF,

  32'h00840000, // Slave19 4 Address Range19
  32'h0084FFFF,

  32'h00850000, // Slave19 5 Address Range19
  32'h0085FFFF,

  32'h00860000, // Slave19 6 Address Range19
  32'h0086FFFF,

  32'h00870000, // Slave19 7 Address Range19
  32'h0087FFFF,

  32'h00880000, // Slave19 8 Address Range19
  32'h0088FFFF
) i_ahb2apb19 (
     // AHB19 interface
    .hclk19(hclk19),         
    .hreset_n19(n_hreset19), 
    .hsel19(hsel19), 
    .haddr19(haddr19),        
    .htrans19(htrans19),       
    .hwrite19(hwrite19),       
    .hwdata19(hwdata19),       
    .hrdata19(hrdata19),   
    .hready19(hready19),   
    .hresp19(hresp19),     
    
     // APB19 interface
    .pclk19(pclk19),         
    .preset_n19(n_preset19),  
    .prdata019(prdata_spi19),
    .prdata119(prdata_uart019), 
    .prdata219(prdata_gpio19),  
    .prdata319(prdata_ttc19),   
    .prdata419(32'h0),   
    .prdata519(prdata_smc19),   
    .prdata619(prdata_pmc19),    
    .prdata719(32'h0),   
    .prdata819(prdata_uart119),  
    .pready019(pready_spi19),     
    .pready119(pready_uart019),   
    .pready219(tie_hi_bit19),     
    .pready319(tie_hi_bit19),     
    .pready419(tie_hi_bit19),     
    .pready519(tie_hi_bit19),     
    .pready619(tie_hi_bit19),     
    .pready719(tie_hi_bit19),     
    .pready819(pready_uart119),  
    .pwdata19(pwdata19),       
    .pwrite19(pwrite19),       
    .paddr19(paddr19),        
    .psel019(psel_spi19),     
    .psel119(psel_uart019),   
    .psel219(psel_gpio19),    
    .psel319(psel_ttc19),     
    .psel419(),     
    .psel519(psel_smc19),     
    .psel619(psel_pmc19),    
    .psel719(psel_apic19),   
    .psel819(psel_uart119),  
    .penable19(penable19)     
);

spi_top19 i_spi19
(
  // Wishbone19 signals19
  .wb_clk_i19(pclk19), 
  .wb_rst_i19(~n_preset19), 
  .wb_adr_i19(paddr19[4:0]), 
  .wb_dat_i19(pwdata19), 
  .wb_dat_o19(prdata_spi19), 
  .wb_sel_i19(4'b1111),    // SPI19 register accesses are always 32-bit
  .wb_we_i19(pwrite19), 
  .wb_stb_i19(psel_spi19), 
  .wb_cyc_i19(psel_spi19), 
  .wb_ack_o19(pready_spi19), 
  .wb_err_o19(), 
  .wb_int_o19(SPI_int19),

  // SPI19 signals19
  .ss_pad_o19(n_ss_out19), 
  .sclk_pad_o19(sclk_out19), 
  .mosi_pad_o19(mo19), 
  .miso_pad_i19(mi19)
);

// Opencores19 UART19 instances19
wire ua_nrts_int19;
wire ua_nrts1_int19;

assign ua_nrts19 = ua_nrts_int19;
assign ua_nrts119 = ua_nrts1_int19;

reg [3:0] uart0_sel_i19;
reg [3:0] uart1_sel_i19;
// UART19 registers are all 8-bit wide19, and their19 addresses19
// are on byte boundaries19. So19 to access them19 on the
// Wishbone19 bus, the CPU19 must do byte accesses to these19
// byte addresses19. Word19 address accesses are not possible19
// because the word19 addresses19 will be unaligned19, and cause
// a fault19.
// So19, Uart19 accesses from the CPU19 will always be 8-bit size
// We19 only have to decide19 which byte of the 4-byte word19 the
// CPU19 is interested19 in.
`ifdef SYSTEM_BIG_ENDIAN19
always @(paddr19) begin
  case (paddr19[1:0])
    2'b00 : uart0_sel_i19 = 4'b1000;
    2'b01 : uart0_sel_i19 = 4'b0100;
    2'b10 : uart0_sel_i19 = 4'b0010;
    2'b11 : uart0_sel_i19 = 4'b0001;
  endcase
end
always @(paddr19) begin
  case (paddr19[1:0])
    2'b00 : uart1_sel_i19 = 4'b1000;
    2'b01 : uart1_sel_i19 = 4'b0100;
    2'b10 : uart1_sel_i19 = 4'b0010;
    2'b11 : uart1_sel_i19 = 4'b0001;
  endcase
end
`else
always @(paddr19) begin
  case (paddr19[1:0])
    2'b00 : uart0_sel_i19 = 4'b0001;
    2'b01 : uart0_sel_i19 = 4'b0010;
    2'b10 : uart0_sel_i19 = 4'b0100;
    2'b11 : uart0_sel_i19 = 4'b1000;
  endcase
end
always @(paddr19) begin
  case (paddr19[1:0])
    2'b00 : uart1_sel_i19 = 4'b0001;
    2'b01 : uart1_sel_i19 = 4'b0010;
    2'b10 : uart1_sel_i19 = 4'b0100;
    2'b11 : uart1_sel_i19 = 4'b1000;
  endcase
end
`endif

uart_top19 i_oc_uart019 (
  .wb_clk_i19(pclk19),
  .wb_rst_i19(~n_preset19),
  .wb_adr_i19(paddr19[4:0]),
  .wb_dat_i19(pwdata19),
  .wb_dat_o19(prdata_uart019),
  .wb_we_i19(pwrite19),
  .wb_stb_i19(psel_uart019),
  .wb_cyc_i19(psel_uart019),
  .wb_ack_o19(pready_uart019),
  .wb_sel_i19(uart0_sel_i19),
  .int_o19(UART_int19),
  .stx_pad_o19(ua_txd19),
  .srx_pad_i19(ua_rxd19),
  .rts_pad_o19(ua_nrts_int19),
  .cts_pad_i19(ua_ncts19),
  .dtr_pad_o19(),
  .dsr_pad_i19(1'b0),
  .ri_pad_i19(1'b0),
  .dcd_pad_i19(1'b0)
);

uart_top19 i_oc_uart119 (
  .wb_clk_i19(pclk19),
  .wb_rst_i19(~n_preset19),
  .wb_adr_i19(paddr19[4:0]),
  .wb_dat_i19(pwdata19),
  .wb_dat_o19(prdata_uart119),
  .wb_we_i19(pwrite19),
  .wb_stb_i19(psel_uart119),
  .wb_cyc_i19(psel_uart119),
  .wb_ack_o19(pready_uart119),
  .wb_sel_i19(uart1_sel_i19),
  .int_o19(UART_int119),
  .stx_pad_o19(ua_txd119),
  .srx_pad_i19(ua_rxd119),
  .rts_pad_o19(ua_nrts1_int19),
  .cts_pad_i19(ua_ncts119),
  .dtr_pad_o19(),
  .dsr_pad_i19(1'b0),
  .ri_pad_i19(1'b0),
  .dcd_pad_i19(1'b0)
);

gpio_veneer19 i_gpio_veneer19 (
        //inputs19

        . n_p_reset19(n_preset19),
        . pclk19(pclk19),
        . psel19(psel_gpio19),
        . penable19(penable19),
        . pwrite19(pwrite19),
        . paddr19(paddr19[5:0]),
        . pwdata19(pwdata19),
        . gpio_pin_in19(gpio_pin_in19),
        . scan_en19(scan_en19),
        . tri_state_enable19(tri_state_enable19),
        . scan_in19(), //added by smarkov19 for dft19

        //outputs19
        . scan_out19(), //added by smarkov19 for dft19
        . prdata19(prdata_gpio19),
        . gpio_int19(GPIO_int19),
        . n_gpio_pin_oe19(n_gpio_pin_oe19),
        . gpio_pin_out19(gpio_pin_out19)
);


ttc_veneer19 i_ttc_veneer19 (

         //inputs19
        . n_p_reset19(n_preset19),
        . pclk19(pclk19),
        . psel19(psel_ttc19),
        . penable19(penable19),
        . pwrite19(pwrite19),
        . pwdata19(pwdata19),
        . paddr19(paddr19[7:0]),
        . scan_in19(),
        . scan_en19(scan_en19),

        //outputs19
        . prdata19(prdata_ttc19),
        . interrupt19(TTC_int19[3:1]),
        . scan_out19()
);


smc_veneer19 i_smc_veneer19 (
        //inputs19
	//apb19 inputs19
        . n_preset19(n_preset19),
        . pclk19(pclk_SRPG_smc19),
        . psel19(psel_smc19),
        . penable19(penable19),
        . pwrite19(pwrite19),
        . paddr19(paddr19[4:0]),
        . pwdata19(pwdata19),
        //ahb19 inputs19
	. hclk19(smc_hclk19),
        . n_sys_reset19(rstn_non_srpg_smc19),
        . haddr19(smc_haddr19),
        . htrans19(smc_htrans19),
        . hsel19(smc_hsel_int19),
        . hwrite19(smc_hwrite19),
	. hsize19(smc_hsize19),
        . hwdata19(smc_hwdata19),
        . hready19(smc_hready_in19),
        . data_smc19(data_smc19),

         //test signal19 inputs19

        . scan_in_119(),
        . scan_in_219(),
        . scan_in_319(),
        . scan_en19(scan_en19),

        //apb19 outputs19
        . prdata19(prdata_smc19),

       //design output

        . smc_hrdata19(smc_hrdata19),
        . smc_hready19(smc_hready19),
        . smc_hresp19(smc_hresp19),
        . smc_valid19(smc_valid19),
        . smc_addr19(smc_addr_int19),
        . smc_data19(smc_data19),
        . smc_n_be19(smc_n_be19),
        . smc_n_cs19(smc_n_cs19),
        . smc_n_wr19(smc_n_wr19),
        . smc_n_we19(smc_n_we19),
        . smc_n_rd19(smc_n_rd19),
        . smc_n_ext_oe19(smc_n_ext_oe19),
        . smc_busy19(smc_busy19),

         //test signal19 output
        . scan_out_119(),
        . scan_out_219(),
        . scan_out_319()
);

power_ctrl_veneer19 i_power_ctrl_veneer19 (
    // -- Clocks19 & Reset19
    	.pclk19(pclk19), 			//  : in  std_logic19;
    	.nprst19(n_preset19), 		//  : in  std_logic19;
    // -- APB19 programming19 interface
    	.paddr19(paddr19), 			//  : in  std_logic_vector19(31 downto19 0);
    	.psel19(psel_pmc19), 			//  : in  std_logic19;
    	.penable19(penable19), 		//  : in  std_logic19;
    	.pwrite19(pwrite19), 		//  : in  std_logic19;
    	.pwdata19(pwdata19), 		//  : in  std_logic_vector19(31 downto19 0);
    	.prdata19(prdata_pmc19), 		//  : out std_logic_vector19(31 downto19 0);
        .macb3_wakeup19(macb3_wakeup19),
        .macb2_wakeup19(macb2_wakeup19),
        .macb1_wakeup19(macb1_wakeup19),
        .macb0_wakeup19(macb0_wakeup19),
    // -- Module19 control19 outputs19
    	.scan_in19(),			//  : in  std_logic19;
    	.scan_en19(scan_en19),             	//  : in  std_logic19;
    	.scan_mode19(scan_mode19),          //  : in  std_logic19;
    	.scan_out19(),            	//  : out std_logic19;
        .int_source_h19(int_source_h19),
     	.rstn_non_srpg_smc19(rstn_non_srpg_smc19), 		//   : out std_logic19;
    	.gate_clk_smc19(gate_clk_smc19), 	//  : out std_logic19;
    	.isolate_smc19(isolate_smc19), 	//  : out std_logic19;
    	.save_edge_smc19(save_edge_smc19), 	//  : out std_logic19;
    	.restore_edge_smc19(restore_edge_smc19), 	//  : out std_logic19;
    	.pwr1_on_smc19(pwr1_on_smc19), 	//  : out std_logic19;
    	.pwr2_on_smc19(pwr2_on_smc19), 	//  : out std_logic19
     	.rstn_non_srpg_urt19(rstn_non_srpg_urt19), 		//   : out std_logic19;
    	.gate_clk_urt19(gate_clk_urt19), 	//  : out std_logic19;
    	.isolate_urt19(isolate_urt19), 	//  : out std_logic19;
    	.save_edge_urt19(save_edge_urt19), 	//  : out std_logic19;
    	.restore_edge_urt19(restore_edge_urt19), 	//  : out std_logic19;
    	.pwr1_on_urt19(pwr1_on_urt19), 	//  : out std_logic19;
    	.pwr2_on_urt19(pwr2_on_urt19),  	//  : out std_logic19
        // ETH019
        .rstn_non_srpg_macb019(rstn_non_srpg_macb019),
        .gate_clk_macb019(gate_clk_macb019),
        .isolate_macb019(isolate_macb019),
        .save_edge_macb019(save_edge_macb019),
        .restore_edge_macb019(restore_edge_macb019),
        .pwr1_on_macb019(pwr1_on_macb019),
        .pwr2_on_macb019(pwr2_on_macb019),
        // ETH119
        .rstn_non_srpg_macb119(rstn_non_srpg_macb119),
        .gate_clk_macb119(gate_clk_macb119),
        .isolate_macb119(isolate_macb119),
        .save_edge_macb119(save_edge_macb119),
        .restore_edge_macb119(restore_edge_macb119),
        .pwr1_on_macb119(pwr1_on_macb119),
        .pwr2_on_macb119(pwr2_on_macb119),
        // ETH219
        .rstn_non_srpg_macb219(rstn_non_srpg_macb219),
        .gate_clk_macb219(gate_clk_macb219),
        .isolate_macb219(isolate_macb219),
        .save_edge_macb219(save_edge_macb219),
        .restore_edge_macb219(restore_edge_macb219),
        .pwr1_on_macb219(pwr1_on_macb219),
        .pwr2_on_macb219(pwr2_on_macb219),
        // ETH319
        .rstn_non_srpg_macb319(rstn_non_srpg_macb319),
        .gate_clk_macb319(gate_clk_macb319),
        .isolate_macb319(isolate_macb319),
        .save_edge_macb319(save_edge_macb319),
        .restore_edge_macb319(restore_edge_macb319),
        .pwr1_on_macb319(pwr1_on_macb319),
        .pwr2_on_macb319(pwr2_on_macb319),
        .core06v19(core06v19),
        .core08v19(core08v19),
        .core10v19(core10v19),
        .core12v19(core12v19),
        .pcm_macb_wakeup_int19(pcm_macb_wakeup_int19),
        .isolate_mem19(isolate_mem19),
        .mte_smc_start19(mte_smc_start19),
        .mte_uart_start19(mte_uart_start19),
        .mte_smc_uart_start19(mte_smc_uart_start19),  
        .mte_pm_smc_to_default_start19(mte_pm_smc_to_default_start19), 
        .mte_pm_uart_to_default_start19(mte_pm_uart_to_default_start19),
        .mte_pm_smc_uart_to_default_start19(mte_pm_smc_uart_to_default_start19)
);

// Clock19 gating19 macro19 to shut19 off19 clocks19 to the SRPG19 flops19 in the SMC19
//CKLNQD119 i_SMC_SRPG_clk_gate19  (
//	.TE19(scan_mode19), 
//	.E19(~gate_clk_smc19), 
//	.CP19(pclk19), 
//	.Q19(pclk_SRPG_smc19)
//	);
// Replace19 gate19 with behavioural19 code19 //
wire 	smc_scan_gate19;
reg 	smc_latched_enable19;
assign smc_scan_gate19 = scan_mode19 ? 1'b1 : ~gate_clk_smc19;

always @ (pclk19 or smc_scan_gate19)
  	if (pclk19 == 1'b0) begin
  		smc_latched_enable19 <= smc_scan_gate19;
  	end  	
	
assign pclk_SRPG_smc19 = smc_latched_enable19 ? pclk19 : 1'b0;


// Clock19 gating19 macro19 to shut19 off19 clocks19 to the SRPG19 flops19 in the URT19
//CKLNQD119 i_URT_SRPG_clk_gate19  (
//	.TE19(scan_mode19), 
//	.E19(~gate_clk_urt19), 
//	.CP19(pclk19), 
//	.Q19(pclk_SRPG_urt19)
//	);
// Replace19 gate19 with behavioural19 code19 //
wire 	urt_scan_gate19;
reg 	urt_latched_enable19;
assign urt_scan_gate19 = scan_mode19 ? 1'b1 : ~gate_clk_urt19;

always @ (pclk19 or urt_scan_gate19)
  	if (pclk19 == 1'b0) begin
  		urt_latched_enable19 <= urt_scan_gate19;
  	end  	
	
assign pclk_SRPG_urt19 = urt_latched_enable19 ? pclk19 : 1'b0;

// ETH019
wire 	macb0_scan_gate19;
reg 	macb0_latched_enable19;
assign macb0_scan_gate19 = scan_mode19 ? 1'b1 : ~gate_clk_macb019;

always @ (pclk19 or macb0_scan_gate19)
  	if (pclk19 == 1'b0) begin
  		macb0_latched_enable19 <= macb0_scan_gate19;
  	end  	
	
assign clk_SRPG_macb0_en19 = macb0_latched_enable19 ? 1'b1 : 1'b0;

// ETH119
wire 	macb1_scan_gate19;
reg 	macb1_latched_enable19;
assign macb1_scan_gate19 = scan_mode19 ? 1'b1 : ~gate_clk_macb119;

always @ (pclk19 or macb1_scan_gate19)
  	if (pclk19 == 1'b0) begin
  		macb1_latched_enable19 <= macb1_scan_gate19;
  	end  	
	
assign clk_SRPG_macb1_en19 = macb1_latched_enable19 ? 1'b1 : 1'b0;

// ETH219
wire 	macb2_scan_gate19;
reg 	macb2_latched_enable19;
assign macb2_scan_gate19 = scan_mode19 ? 1'b1 : ~gate_clk_macb219;

always @ (pclk19 or macb2_scan_gate19)
  	if (pclk19 == 1'b0) begin
  		macb2_latched_enable19 <= macb2_scan_gate19;
  	end  	
	
assign clk_SRPG_macb2_en19 = macb2_latched_enable19 ? 1'b1 : 1'b0;

// ETH319
wire 	macb3_scan_gate19;
reg 	macb3_latched_enable19;
assign macb3_scan_gate19 = scan_mode19 ? 1'b1 : ~gate_clk_macb319;

always @ (pclk19 or macb3_scan_gate19)
  	if (pclk19 == 1'b0) begin
  		macb3_latched_enable19 <= macb3_scan_gate19;
  	end  	
	
assign clk_SRPG_macb3_en19 = macb3_latched_enable19 ? 1'b1 : 1'b0;



`else
//------------------------------------------------------------------------------
// if the APB19 subsystem19 is black19 boxed19 
//------------------------------------------------------------------------------
// wire s ports19
    // system signals19
    wire         hclk19;     // AHB19 Clock19
    wire         n_hreset19;  // AHB19 reset - Active19 low19
    wire         pclk19;     // APB19 Clock19. 
    wire         n_preset19;  // APB19 reset - Active19 low19

    // AHB19 interface
    wire         ahb2apb0_hsel19;     // AHB2APB19 select19
    wire  [31:0] haddr19;    // Address bus
    wire  [1:0]  htrans19;   // Transfer19 type
    wire  [2:0]  hsize19;    // AHB19 Access type - byte, half19-word19, word19
    wire  [31:0] hwdata19;   // Write data
    wire         hwrite19;   // Write signal19/
    wire         hready_in19;// Indicates19 that last master19 has finished19 bus access
    wire [2:0]   hburst19;     // Burst type
    wire [3:0]   hprot19;      // Protection19 control19
    wire [3:0]   hmaster19;    // Master19 select19
    wire         hmastlock19;  // Locked19 transfer19
  // Interrupts19 from the Enet19 MACs19
    wire         macb0_int19;
    wire         macb1_int19;
    wire         macb2_int19;
    wire         macb3_int19;
  // Interrupt19 from the DMA19
    wire         DMA_irq19;
  // Scan19 wire s
    wire         scan_en19;    // Scan19 enable pin19
    wire         scan_in_119;  // Scan19 wire  for first chain19
    wire         scan_in_219;  // Scan19 wire  for second chain19
    wire         scan_mode19;  // test mode pin19
 
  //wire  for smc19 AHB19 interface
    wire         smc_hclk19;
    wire         smc_n_hclk19;
    wire  [31:0] smc_haddr19;
    wire  [1:0]  smc_htrans19;
    wire         smc_hsel19;
    wire         smc_hwrite19;
    wire  [2:0]  smc_hsize19;
    wire  [31:0] smc_hwdata19;
    wire         smc_hready_in19;
    wire  [2:0]  smc_hburst19;     // Burst type
    wire  [3:0]  smc_hprot19;      // Protection19 control19
    wire  [3:0]  smc_hmaster19;    // Master19 select19
    wire         smc_hmastlock19;  // Locked19 transfer19


    wire  [31:0] data_smc19;     // EMI19(External19 memory) read data
    
  //wire s for uart19
    wire         ua_rxd19;       // UART19 receiver19 serial19 wire  pin19
    wire         ua_rxd119;      // UART19 receiver19 serial19 wire  pin19
    wire         ua_ncts19;      // Clear-To19-Send19 flow19 control19
    wire         ua_ncts119;      // Clear-To19-Send19 flow19 control19
   //wire s for spi19
    wire         n_ss_in19;      // select19 wire  to slave19
    wire         mi19;           // data wire  to master19
    wire         si19;           // data wire  to slave19
    wire         sclk_in19;      // clock19 wire  to slave19
  //wire s for GPIO19
   wire  [GPIO_WIDTH19-1:0]  gpio_pin_in19;             // wire  data from pin19

  //reg    ports19
  // Scan19 reg   s
   reg           scan_out_119;   // Scan19 out for chain19 1
   reg           scan_out_219;   // Scan19 out for chain19 2
  //AHB19 interface 
   reg    [31:0] hrdata19;       // Read data provided from target slave19
   reg           hready19;       // Ready19 for new bus cycle from target slave19
   reg    [1:0]  hresp19;       // Response19 from the bridge19

   // SMC19 reg    for AHB19 interface
   reg    [31:0]    smc_hrdata19;
   reg              smc_hready19;
   reg    [1:0]     smc_hresp19;

  //reg   s from smc19
   reg    [15:0]    smc_addr19;      // External19 Memory (EMI19) address
   reg    [3:0]     smc_n_be19;      // EMI19 byte enables19 (Active19 LOW19)
   reg    [7:0]     smc_n_cs19;      // EMI19 Chip19 Selects19 (Active19 LOW19)
   reg    [3:0]     smc_n_we19;      // EMI19 write strobes19 (Active19 LOW19)
   reg              smc_n_wr19;      // EMI19 write enable (Active19 LOW19)
   reg              smc_n_rd19;      // EMI19 read stobe19 (Active19 LOW19)
   reg              smc_n_ext_oe19;  // EMI19 write data reg    enable
   reg    [31:0]    smc_data19;      // EMI19 write data
  //reg   s from uart19
   reg           ua_txd19;       	// UART19 transmitter19 serial19 reg   
   reg           ua_txd119;       // UART19 transmitter19 serial19 reg   
   reg           ua_nrts19;      	// Request19-To19-Send19 flow19 control19
   reg           ua_nrts119;      // Request19-To19-Send19 flow19 control19
   // reg   s from ttc19
  // reg   s from SPI19
   reg       so;                    // data reg    from slave19
   reg       mo19;                    // data reg    from master19
   reg       sclk_out19;              // clock19 reg    from master19
   reg    [P_SIZE19-1:0] n_ss_out19;    // peripheral19 select19 lines19 from master19
   reg       n_so_en19;               // out enable for slave19 data
   reg       n_mo_en19;               // out enable for master19 data
   reg       n_sclk_en19;             // out enable for master19 clock19
   reg       n_ss_en19;               // out enable for master19 peripheral19 lines19
  //reg   s from gpio19
   reg    [GPIO_WIDTH19-1:0]     n_gpio_pin_oe19;           // reg    enable signal19 to pin19
   reg    [GPIO_WIDTH19-1:0]     gpio_pin_out19;            // reg    signal19 to pin19


`endif
//------------------------------------------------------------------------------
// black19 boxed19 defines19 
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// APB19 and AHB19 interface formal19 verification19 monitors19
//------------------------------------------------------------------------------
`ifdef ABV_ON19
apb_assert19 i_apb_assert19 (

        // APB19 signals19
  	.n_preset19(n_preset19),
   	.pclk19(pclk19),
	.penable19(penable19),
	.paddr19(paddr19),
	.pwrite19(pwrite19),
	.pwdata19(pwdata19),

	.psel0019(psel_spi19),
	.psel0119(psel_uart019),
	.psel0219(psel_gpio19),
	.psel0319(psel_ttc19),
	.psel0419(1'b0),
	.psel0519(psel_smc19),
	.psel0619(1'b0),
	.psel0719(1'b0),
	.psel0819(1'b0),
	.psel0919(1'b0),
	.psel1019(1'b0),
	.psel1119(1'b0),
	.psel1219(1'b0),
	.psel1319(psel_pmc19),
	.psel1419(psel_apic19),
	.psel1519(psel_uart119),

        .prdata0019(prdata_spi19),
        .prdata0119(prdata_uart019), // Read Data from peripheral19 UART19 
        .prdata0219(prdata_gpio19), // Read Data from peripheral19 GPIO19
        .prdata0319(prdata_ttc19), // Read Data from peripheral19 TTC19
        .prdata0419(32'b0), // 
        .prdata0519(prdata_smc19), // Read Data from peripheral19 SMC19
        .prdata1319(prdata_pmc19), // Read Data from peripheral19 Power19 Control19 Block
   	.prdata1419(32'b0), // 
        .prdata1519(prdata_uart119),


        // AHB19 signals19
        .hclk19(hclk19),         // ahb19 system clock19
        .n_hreset19(n_hreset19), // ahb19 system reset

        // ahb2apb19 signals19
        .hresp19(hresp19),
        .hready19(hready19),
        .hrdata19(hrdata19),
        .hwdata19(hwdata19),
        .hprot19(hprot19),
        .hburst19(hburst19),
        .hsize19(hsize19),
        .hwrite19(hwrite19),
        .htrans19(htrans19),
        .haddr19(haddr19),
        .ahb2apb_hsel19(ahb2apb0_hsel19));



//------------------------------------------------------------------------------
// AHB19 interface formal19 verification19 monitor19
//------------------------------------------------------------------------------
defparam i_ahbSlaveMonitor19.DBUS_WIDTH19 = 32;
defparam i_ahbMasterMonitor19.DBUS_WIDTH19 = 32;


// AHB2APB19 Bridge19

    ahb_liteslave_monitor19 i_ahbSlaveMonitor19 (
        .hclk_i19(hclk19),
        .hresetn_i19(n_hreset19),
        .hresp19(hresp19),
        .hready19(hready19),
        .hready_global_i19(hready19),
        .hrdata19(hrdata19),
        .hwdata_i19(hwdata19),
        .hburst_i19(hburst19),
        .hsize_i19(hsize19),
        .hwrite_i19(hwrite19),
        .htrans_i19(htrans19),
        .haddr_i19(haddr19),
        .hsel_i19(ahb2apb0_hsel19)
    );


  ahb_litemaster_monitor19 i_ahbMasterMonitor19 (
          .hclk_i19(hclk19),
          .hresetn_i19(n_hreset19),
          .hresp_i19(hresp19),
          .hready_i19(hready19),
          .hrdata_i19(hrdata19),
          .hlock19(1'b0),
          .hwdata19(hwdata19),
          .hprot19(hprot19),
          .hburst19(hburst19),
          .hsize19(hsize19),
          .hwrite19(hwrite19),
          .htrans19(htrans19),
          .haddr19(haddr19)
          );







`endif




`ifdef IFV_LP_ABV_ON19
// power19 control19
wire isolate19;

// testbench mirror signals19
wire L1_ctrl_access19;
wire L1_status_access19;

wire [31:0] L1_status_reg19;
wire [31:0] L1_ctrl_reg19;

//wire rstn_non_srpg_urt19;
//wire isolate_urt19;
//wire retain_urt19;
//wire gate_clk_urt19;
//wire pwr1_on_urt19;


// smc19 signals19
wire [31:0] smc_prdata19;
wire lp_clk_smc19;
                    

// uart19 isolation19 register
  wire [15:0] ua_prdata19;
  wire ua_int19;
  assign ua_prdata19          =  i_uart1_veneer19.prdata19;
  assign ua_int19             =  i_uart1_veneer19.ua_int19;


assign lp_clk_smc19          = i_smc_veneer19.pclk19;
assign smc_prdata19          = i_smc_veneer19.prdata19;
lp_chk_smc19 u_lp_chk_smc19 (
    .clk19 (hclk19),
    .rst19 (n_hreset19),
    .iso_smc19 (isolate_smc19),
    .gate_clk19 (gate_clk_smc19),
    .lp_clk19 (pclk_SRPG_smc19),

    // srpg19 outputs19
    .smc_hrdata19 (smc_hrdata19),
    .smc_hready19 (smc_hready19),
    .smc_hresp19  (smc_hresp19),
    .smc_valid19 (smc_valid19),
    .smc_addr_int19 (smc_addr_int19),
    .smc_data19 (smc_data19),
    .smc_n_be19 (smc_n_be19),
    .smc_n_cs19  (smc_n_cs19),
    .smc_n_wr19 (smc_n_wr19),
    .smc_n_we19 (smc_n_we19),
    .smc_n_rd19 (smc_n_rd19),
    .smc_n_ext_oe19 (smc_n_ext_oe19)
   );

// lp19 retention19/isolation19 assertions19
lp_chk_uart19 u_lp_chk_urt19 (

  .clk19         (hclk19),
  .rst19         (n_hreset19),
  .iso_urt19     (isolate_urt19),
  .gate_clk19    (gate_clk_urt19),
  .lp_clk19      (pclk_SRPG_urt19),
  //ports19
  .prdata19 (ua_prdata19),
  .ua_int19 (ua_int19),
  .ua_txd19 (ua_txd119),
  .ua_nrts19 (ua_nrts119)
 );

`endif  //IFV_LP_ABV_ON19




endmodule
