//File11 name   : apb_subsystem_011.v
//Title11       : 
//Created11     : 1999
//Description11 : 
//Notes11       : 
//----------------------------------------------------------------------
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------

module apb_subsystem_011(
    // AHB11 interface
    hclk11,
    n_hreset11,
    hsel11,
    haddr11,
    htrans11,
    hsize11,
    hwrite11,
    hwdata11,
    hready_in11,
    hburst11,
    hprot11,
    hmaster11,
    hmastlock11,
    hrdata11,
    hready11,
    hresp11,
    
    // APB11 system interface
    pclk11,
    n_preset11,
    
    // SPI11 ports11
    n_ss_in11,
    mi11,
    si11,
    sclk_in11,
    so,
    mo11,
    sclk_out11,
    n_ss_out11,
    n_so_en11,
    n_mo_en11,
    n_sclk_en11,
    n_ss_en11,
    
    //UART011 ports11
    ua_rxd11,
    ua_ncts11,
    ua_txd11,
    ua_nrts11,
    
    //UART111 ports11
    ua_rxd111,
    ua_ncts111,
    ua_txd111,
    ua_nrts111,
    
    //GPIO11 ports11
    gpio_pin_in11,
    n_gpio_pin_oe11,
    gpio_pin_out11,
    

    //SMC11 ports11
    smc_hclk11,
    smc_n_hclk11,
    smc_haddr11,
    smc_htrans11,
    smc_hsel11,
    smc_hwrite11,
    smc_hsize11,
    smc_hwdata11,
    smc_hready_in11,
    smc_hburst11,
    smc_hprot11,
    smc_hmaster11,
    smc_hmastlock11,
    smc_hrdata11, 
    smc_hready11,
    smc_hresp11,
    smc_n_ext_oe11,
    smc_data11,
    smc_addr11,
    smc_n_be11,
    smc_n_cs11, 
    smc_n_we11,
    smc_n_wr11,
    smc_n_rd11,
    data_smc11,
    
    //PMC11 ports11
    clk_SRPG_macb0_en11,
    clk_SRPG_macb1_en11,
    clk_SRPG_macb2_en11,
    clk_SRPG_macb3_en11,
    core06v11,
    core08v11,
    core10v11,
    core12v11,
    macb3_wakeup11,
    macb2_wakeup11,
    macb1_wakeup11,
    macb0_wakeup11,
    mte_smc_start11,
    mte_uart_start11,
    mte_smc_uart_start11,  
    mte_pm_smc_to_default_start11, 
    mte_pm_uart_to_default_start11,
    mte_pm_smc_uart_to_default_start11,
    
    
    // Peripheral11 inerrupts11
    pcm_irq11,
    ttc_irq11,
    gpio_irq11,
    uart0_irq11,
    uart1_irq11,
    spi_irq11,
    DMA_irq11,      
    macb0_int11,
    macb1_int11,
    macb2_int11,
    macb3_int11,
   
    // Scan11 ports11
    scan_en11,      // Scan11 enable pin11
    scan_in_111,    // Scan11 input for first chain11
    scan_in_211,    // Scan11 input for second chain11
    scan_mode11,
    scan_out_111,   // Scan11 out for chain11 1
    scan_out_211    // Scan11 out for chain11 2
);

parameter GPIO_WIDTH11 = 16;        // GPIO11 width
parameter P_SIZE11 =   8;              // number11 of peripheral11 select11 lines11
parameter NO_OF_IRQS11  = 17;      //No of irqs11 read by apic11 

// AHB11 interface
input         hclk11;     // AHB11 Clock11
input         n_hreset11;  // AHB11 reset - Active11 low11
input         hsel11;     // AHB2APB11 select11
input [31:0]  haddr11;    // Address bus
input [1:0]   htrans11;   // Transfer11 type
input [2:0]   hsize11;    // AHB11 Access type - byte, half11-word11, word11
input [31:0]  hwdata11;   // Write data
input         hwrite11;   // Write signal11/
input         hready_in11;// Indicates11 that last master11 has finished11 bus access
input [2:0]   hburst11;     // Burst type
input [3:0]   hprot11;      // Protection11 control11
input [3:0]   hmaster11;    // Master11 select11
input         hmastlock11;  // Locked11 transfer11
output [31:0] hrdata11;       // Read data provided from target slave11
output        hready11;       // Ready11 for new bus cycle from target slave11
output [1:0]  hresp11;       // Response11 from the bridge11
    
// APB11 system interface
input         pclk11;     // APB11 Clock11. 
input         n_preset11;  // APB11 reset - Active11 low11
   
// SPI11 ports11
input     n_ss_in11;      // select11 input to slave11
input     mi11;           // data input to master11
input     si11;           // data input to slave11
input     sclk_in11;      // clock11 input to slave11
output    so;                    // data output from slave11
output    mo11;                    // data output from master11
output    sclk_out11;              // clock11 output from master11
output [P_SIZE11-1:0] n_ss_out11;    // peripheral11 select11 lines11 from master11
output    n_so_en11;               // out enable for slave11 data
output    n_mo_en11;               // out enable for master11 data
output    n_sclk_en11;             // out enable for master11 clock11
output    n_ss_en11;               // out enable for master11 peripheral11 lines11

//UART011 ports11
input        ua_rxd11;       // UART11 receiver11 serial11 input pin11
input        ua_ncts11;      // Clear-To11-Send11 flow11 control11
output       ua_txd11;       	// UART11 transmitter11 serial11 output
output       ua_nrts11;      	// Request11-To11-Send11 flow11 control11

// UART111 ports11   
input        ua_rxd111;      // UART11 receiver11 serial11 input pin11
input        ua_ncts111;      // Clear-To11-Send11 flow11 control11
output       ua_txd111;       // UART11 transmitter11 serial11 output
output       ua_nrts111;      // Request11-To11-Send11 flow11 control11

//GPIO11 ports11
input [GPIO_WIDTH11-1:0]      gpio_pin_in11;             // input data from pin11
output [GPIO_WIDTH11-1:0]     n_gpio_pin_oe11;           // output enable signal11 to pin11
output [GPIO_WIDTH11-1:0]     gpio_pin_out11;            // output signal11 to pin11
  
//SMC11 ports11
input        smc_hclk11;
input        smc_n_hclk11;
input [31:0] smc_haddr11;
input [1:0]  smc_htrans11;
input        smc_hsel11;
input        smc_hwrite11;
input [2:0]  smc_hsize11;
input [31:0] smc_hwdata11;
input        smc_hready_in11;
input [2:0]  smc_hburst11;     // Burst type
input [3:0]  smc_hprot11;      // Protection11 control11
input [3:0]  smc_hmaster11;    // Master11 select11
input        smc_hmastlock11;  // Locked11 transfer11
input [31:0] data_smc11;     // EMI11(External11 memory) read data
output [31:0]    smc_hrdata11;
output           smc_hready11;
output [1:0]     smc_hresp11;
output [15:0]    smc_addr11;      // External11 Memory (EMI11) address
output [3:0]     smc_n_be11;      // EMI11 byte enables11 (Active11 LOW11)
output           smc_n_cs11;      // EMI11 Chip11 Selects11 (Active11 LOW11)
output [3:0]     smc_n_we11;      // EMI11 write strobes11 (Active11 LOW11)
output           smc_n_wr11;      // EMI11 write enable (Active11 LOW11)
output           smc_n_rd11;      // EMI11 read stobe11 (Active11 LOW11)
output           smc_n_ext_oe11;  // EMI11 write data output enable
output [31:0]    smc_data11;      // EMI11 write data
       
//PMC11 ports11
output clk_SRPG_macb0_en11;
output clk_SRPG_macb1_en11;
output clk_SRPG_macb2_en11;
output clk_SRPG_macb3_en11;
output core06v11;
output core08v11;
output core10v11;
output core12v11;
output mte_smc_start11;
output mte_uart_start11;
output mte_smc_uart_start11;  
output mte_pm_smc_to_default_start11; 
output mte_pm_uart_to_default_start11;
output mte_pm_smc_uart_to_default_start11;
input macb3_wakeup11;
input macb2_wakeup11;
input macb1_wakeup11;
input macb0_wakeup11;
    

// Peripheral11 interrupts11
output pcm_irq11;
output [2:0] ttc_irq11;
output gpio_irq11;
output uart0_irq11;
output uart1_irq11;
output spi_irq11;
input        macb0_int11;
input        macb1_int11;
input        macb2_int11;
input        macb3_int11;
input        DMA_irq11;
  
//Scan11 ports11
input        scan_en11;    // Scan11 enable pin11
input        scan_in_111;  // Scan11 input for first chain11
input        scan_in_211;  // Scan11 input for second chain11
input        scan_mode11;  // test mode pin11
 output        scan_out_111;   // Scan11 out for chain11 1
 output        scan_out_211;   // Scan11 out for chain11 2  

//------------------------------------------------------------------------------
// if the ROM11 subsystem11 is NOT11 black11 boxed11 
//------------------------------------------------------------------------------
`ifndef FV_KIT_BLACK_BOX_APB_SUBSYSTEM11
   
   wire        hsel11; 
   wire        pclk11;
   wire        n_preset11;
   wire [31:0] prdata_spi11;
   wire [31:0] prdata_uart011;
   wire [31:0] prdata_gpio11;
   wire [31:0] prdata_ttc11;
   wire [31:0] prdata_smc11;
   wire [31:0] prdata_pmc11;
   wire [31:0] prdata_uart111;
   wire        pready_spi11;
   wire        pready_uart011;
   wire        pready_uart111;
   wire        tie_hi_bit11;
   wire  [31:0] hrdata11; 
   wire         hready11;
   wire         hready_in11;
   wire  [1:0]  hresp11;   
   wire  [31:0] pwdata11;  
   wire         pwrite11;
   wire  [31:0] paddr11;  
   wire   psel_spi11;
   wire   psel_uart011;
   wire   psel_gpio11;
   wire   psel_ttc11;
   wire   psel_smc11;
   wire   psel0711;
   wire   psel0811;
   wire   psel0911;
   wire   psel1011;
   wire   psel1111;
   wire   psel1211;
   wire   psel_pmc11;
   wire   psel_uart111;
   wire   penable11;
   wire   [NO_OF_IRQS11:0] int_source11;     // System11 Interrupt11 Sources11
   wire [1:0]             smc_hresp11;     // AHB11 Response11 signal11
   wire                   smc_valid11;     // Ack11 valid address

  //External11 memory interface (EMI11)
  wire [31:0]            smc_addr_int11;  // External11 Memory (EMI11) address
  wire [3:0]             smc_n_be11;      // EMI11 byte enables11 (Active11 LOW11)
  wire                   smc_n_cs11;      // EMI11 Chip11 Selects11 (Active11 LOW11)
  wire [3:0]             smc_n_we11;      // EMI11 write strobes11 (Active11 LOW11)
  wire                   smc_n_wr11;      // EMI11 write enable (Active11 LOW11)
  wire                   smc_n_rd11;      // EMI11 read stobe11 (Active11 LOW11)
 
  //AHB11 Memory Interface11 Control11
  wire                   smc_hsel_int11;
  wire                   smc_busy11;      // smc11 busy
   

//scan11 signals11

   wire                scan_in_111;        //scan11 input
   wire                scan_in_211;        //scan11 input
   wire                scan_en11;         //scan11 enable
   wire                scan_out_111;       //scan11 output
   wire                scan_out_211;       //scan11 output
   wire                byte_sel11;     // byte select11 from bridge11 1=byte, 0=2byte
   wire                UART_int11;     // UART11 module interrupt11 
   wire                ua_uclken11;    // Soft11 control11 of clock11
   wire                UART_int111;     // UART11 module interrupt11 
   wire                ua_uclken111;    // Soft11 control11 of clock11
   wire  [3:1]         TTC_int11;            //Interrupt11 from PCI11 
  // inputs11 to SPI11 
   wire    ext_clk11;                // external11 clock11
   wire    SPI_int11;             // interrupt11 request
  // outputs11 from SPI11
   wire    slave_out_clk11;         // modified slave11 clock11 output
 // gpio11 generic11 inputs11 
   wire  [GPIO_WIDTH11-1:0]   n_gpio_bypass_oe11;        // bypass11 mode enable 
   wire  [GPIO_WIDTH11-1:0]   gpio_bypass_out11;         // bypass11 mode output value 
   wire  [GPIO_WIDTH11-1:0]   tri_state_enable11;   // disables11 op enable -> z 
 // outputs11 
   //amba11 outputs11 
   // gpio11 generic11 outputs11 
   wire       GPIO_int11;                // gpio_interupt11 for input pin11 change 
   wire [GPIO_WIDTH11-1:0]     gpio_bypass_in11;          // bypass11 mode input data value  
                
   wire           cpu_debug11;        // Inhibits11 watchdog11 counter 
   wire            ex_wdz_n11;         // External11 Watchdog11 zero indication11
   wire           rstn_non_srpg_smc11; 
   wire           rstn_non_srpg_urt11;
   wire           isolate_smc11;
   wire           save_edge_smc11;
   wire           restore_edge_smc11;
   wire           save_edge_urt11;
   wire           restore_edge_urt11;
   wire           pwr1_on_smc11;
   wire           pwr2_on_smc11;
   wire           pwr1_on_urt11;
   wire           pwr2_on_urt11;
   // ETH011
   wire            rstn_non_srpg_macb011;
   wire            gate_clk_macb011;
   wire            isolate_macb011;
   wire            save_edge_macb011;
   wire            restore_edge_macb011;
   wire            pwr1_on_macb011;
   wire            pwr2_on_macb011;
   // ETH111
   wire            rstn_non_srpg_macb111;
   wire            gate_clk_macb111;
   wire            isolate_macb111;
   wire            save_edge_macb111;
   wire            restore_edge_macb111;
   wire            pwr1_on_macb111;
   wire            pwr2_on_macb111;
   // ETH211
   wire            rstn_non_srpg_macb211;
   wire            gate_clk_macb211;
   wire            isolate_macb211;
   wire            save_edge_macb211;
   wire            restore_edge_macb211;
   wire            pwr1_on_macb211;
   wire            pwr2_on_macb211;
   // ETH311
   wire            rstn_non_srpg_macb311;
   wire            gate_clk_macb311;
   wire            isolate_macb311;
   wire            save_edge_macb311;
   wire            restore_edge_macb311;
   wire            pwr1_on_macb311;
   wire            pwr2_on_macb311;


   wire           pclk_SRPG_smc11;
   wire           pclk_SRPG_urt11;
   wire           gate_clk_smc11;
   wire           gate_clk_urt11;
   wire  [31:0]   tie_lo_32bit11; 
   wire  [1:0]	  tie_lo_2bit11;
   wire  	  tie_lo_1bit11;
   wire           pcm_macb_wakeup_int11;
   wire           int_source_h11;
   wire           isolate_mem11;

assign pcm_irq11 = pcm_macb_wakeup_int11;
assign ttc_irq11[2] = TTC_int11[3];
assign ttc_irq11[1] = TTC_int11[2];
assign ttc_irq11[0] = TTC_int11[1];
assign gpio_irq11 = GPIO_int11;
assign uart0_irq11 = UART_int11;
assign uart1_irq11 = UART_int111;
assign spi_irq11 = SPI_int11;

assign n_mo_en11   = 1'b0;
assign n_so_en11   = 1'b1;
assign n_sclk_en11 = 1'b0;
assign n_ss_en11   = 1'b0;

assign smc_hsel_int11 = smc_hsel11;
  assign ext_clk11  = 1'b0;
  assign int_source11 = {macb0_int11,macb1_int11, macb2_int11, macb3_int11,1'b0, pcm_macb_wakeup_int11, 1'b0, 1'b0, 1'b0, 1'b0, TTC_int11, GPIO_int11, UART_int11, UART_int111, SPI_int11, DMA_irq11};

  // interrupt11 even11 detect11 .
  // for sleep11 wake11 up -> any interrupt11 even11 and system not in hibernation11 (isolate_mem11 = 0)
  // for hibernate11 wake11 up -> gpio11 interrupt11 even11 and system in the hibernation11 (isolate_mem11 = 1)
  assign int_source_h11 =  ((|int_source11) && (!isolate_mem11)) || (isolate_mem11 && GPIO_int11) ;

  assign byte_sel11 = 1'b1;
  assign tie_hi_bit11 = 1'b1;

  assign smc_addr11 = smc_addr_int11[15:0];



  assign  n_gpio_bypass_oe11 = {GPIO_WIDTH11{1'b0}};        // bypass11 mode enable 
  assign  gpio_bypass_out11  = {GPIO_WIDTH11{1'b0}};
  assign  tri_state_enable11 = {GPIO_WIDTH11{1'b0}};
  assign  cpu_debug11 = 1'b0;
  assign  tie_lo_32bit11 = 32'b0;
  assign  tie_lo_2bit11  = 2'b0;
  assign  tie_lo_1bit11  = 1'b0;


ahb2apb11 #(
  32'h00800000, // Slave11 0 Address Range11
  32'h0080FFFF,

  32'h00810000, // Slave11 1 Address Range11
  32'h0081FFFF,

  32'h00820000, // Slave11 2 Address Range11 
  32'h0082FFFF,

  32'h00830000, // Slave11 3 Address Range11
  32'h0083FFFF,

  32'h00840000, // Slave11 4 Address Range11
  32'h0084FFFF,

  32'h00850000, // Slave11 5 Address Range11
  32'h0085FFFF,

  32'h00860000, // Slave11 6 Address Range11
  32'h0086FFFF,

  32'h00870000, // Slave11 7 Address Range11
  32'h0087FFFF,

  32'h00880000, // Slave11 8 Address Range11
  32'h0088FFFF
) i_ahb2apb11 (
     // AHB11 interface
    .hclk11(hclk11),         
    .hreset_n11(n_hreset11), 
    .hsel11(hsel11), 
    .haddr11(haddr11),        
    .htrans11(htrans11),       
    .hwrite11(hwrite11),       
    .hwdata11(hwdata11),       
    .hrdata11(hrdata11),   
    .hready11(hready11),   
    .hresp11(hresp11),     
    
     // APB11 interface
    .pclk11(pclk11),         
    .preset_n11(n_preset11),  
    .prdata011(prdata_spi11),
    .prdata111(prdata_uart011), 
    .prdata211(prdata_gpio11),  
    .prdata311(prdata_ttc11),   
    .prdata411(32'h0),   
    .prdata511(prdata_smc11),   
    .prdata611(prdata_pmc11),    
    .prdata711(32'h0),   
    .prdata811(prdata_uart111),  
    .pready011(pready_spi11),     
    .pready111(pready_uart011),   
    .pready211(tie_hi_bit11),     
    .pready311(tie_hi_bit11),     
    .pready411(tie_hi_bit11),     
    .pready511(tie_hi_bit11),     
    .pready611(tie_hi_bit11),     
    .pready711(tie_hi_bit11),     
    .pready811(pready_uart111),  
    .pwdata11(pwdata11),       
    .pwrite11(pwrite11),       
    .paddr11(paddr11),        
    .psel011(psel_spi11),     
    .psel111(psel_uart011),   
    .psel211(psel_gpio11),    
    .psel311(psel_ttc11),     
    .psel411(),     
    .psel511(psel_smc11),     
    .psel611(psel_pmc11),    
    .psel711(psel_apic11),   
    .psel811(psel_uart111),  
    .penable11(penable11)     
);

spi_top11 i_spi11
(
  // Wishbone11 signals11
  .wb_clk_i11(pclk11), 
  .wb_rst_i11(~n_preset11), 
  .wb_adr_i11(paddr11[4:0]), 
  .wb_dat_i11(pwdata11), 
  .wb_dat_o11(prdata_spi11), 
  .wb_sel_i11(4'b1111),    // SPI11 register accesses are always 32-bit
  .wb_we_i11(pwrite11), 
  .wb_stb_i11(psel_spi11), 
  .wb_cyc_i11(psel_spi11), 
  .wb_ack_o11(pready_spi11), 
  .wb_err_o11(), 
  .wb_int_o11(SPI_int11),

  // SPI11 signals11
  .ss_pad_o11(n_ss_out11), 
  .sclk_pad_o11(sclk_out11), 
  .mosi_pad_o11(mo11), 
  .miso_pad_i11(mi11)
);

// Opencores11 UART11 instances11
wire ua_nrts_int11;
wire ua_nrts1_int11;

assign ua_nrts11 = ua_nrts_int11;
assign ua_nrts111 = ua_nrts1_int11;

reg [3:0] uart0_sel_i11;
reg [3:0] uart1_sel_i11;
// UART11 registers are all 8-bit wide11, and their11 addresses11
// are on byte boundaries11. So11 to access them11 on the
// Wishbone11 bus, the CPU11 must do byte accesses to these11
// byte addresses11. Word11 address accesses are not possible11
// because the word11 addresses11 will be unaligned11, and cause
// a fault11.
// So11, Uart11 accesses from the CPU11 will always be 8-bit size
// We11 only have to decide11 which byte of the 4-byte word11 the
// CPU11 is interested11 in.
`ifdef SYSTEM_BIG_ENDIAN11
always @(paddr11) begin
  case (paddr11[1:0])
    2'b00 : uart0_sel_i11 = 4'b1000;
    2'b01 : uart0_sel_i11 = 4'b0100;
    2'b10 : uart0_sel_i11 = 4'b0010;
    2'b11 : uart0_sel_i11 = 4'b0001;
  endcase
end
always @(paddr11) begin
  case (paddr11[1:0])
    2'b00 : uart1_sel_i11 = 4'b1000;
    2'b01 : uart1_sel_i11 = 4'b0100;
    2'b10 : uart1_sel_i11 = 4'b0010;
    2'b11 : uart1_sel_i11 = 4'b0001;
  endcase
end
`else
always @(paddr11) begin
  case (paddr11[1:0])
    2'b00 : uart0_sel_i11 = 4'b0001;
    2'b01 : uart0_sel_i11 = 4'b0010;
    2'b10 : uart0_sel_i11 = 4'b0100;
    2'b11 : uart0_sel_i11 = 4'b1000;
  endcase
end
always @(paddr11) begin
  case (paddr11[1:0])
    2'b00 : uart1_sel_i11 = 4'b0001;
    2'b01 : uart1_sel_i11 = 4'b0010;
    2'b10 : uart1_sel_i11 = 4'b0100;
    2'b11 : uart1_sel_i11 = 4'b1000;
  endcase
end
`endif

uart_top11 i_oc_uart011 (
  .wb_clk_i11(pclk11),
  .wb_rst_i11(~n_preset11),
  .wb_adr_i11(paddr11[4:0]),
  .wb_dat_i11(pwdata11),
  .wb_dat_o11(prdata_uart011),
  .wb_we_i11(pwrite11),
  .wb_stb_i11(psel_uart011),
  .wb_cyc_i11(psel_uart011),
  .wb_ack_o11(pready_uart011),
  .wb_sel_i11(uart0_sel_i11),
  .int_o11(UART_int11),
  .stx_pad_o11(ua_txd11),
  .srx_pad_i11(ua_rxd11),
  .rts_pad_o11(ua_nrts_int11),
  .cts_pad_i11(ua_ncts11),
  .dtr_pad_o11(),
  .dsr_pad_i11(1'b0),
  .ri_pad_i11(1'b0),
  .dcd_pad_i11(1'b0)
);

uart_top11 i_oc_uart111 (
  .wb_clk_i11(pclk11),
  .wb_rst_i11(~n_preset11),
  .wb_adr_i11(paddr11[4:0]),
  .wb_dat_i11(pwdata11),
  .wb_dat_o11(prdata_uart111),
  .wb_we_i11(pwrite11),
  .wb_stb_i11(psel_uart111),
  .wb_cyc_i11(psel_uart111),
  .wb_ack_o11(pready_uart111),
  .wb_sel_i11(uart1_sel_i11),
  .int_o11(UART_int111),
  .stx_pad_o11(ua_txd111),
  .srx_pad_i11(ua_rxd111),
  .rts_pad_o11(ua_nrts1_int11),
  .cts_pad_i11(ua_ncts111),
  .dtr_pad_o11(),
  .dsr_pad_i11(1'b0),
  .ri_pad_i11(1'b0),
  .dcd_pad_i11(1'b0)
);

gpio_veneer11 i_gpio_veneer11 (
        //inputs11

        . n_p_reset11(n_preset11),
        . pclk11(pclk11),
        . psel11(psel_gpio11),
        . penable11(penable11),
        . pwrite11(pwrite11),
        . paddr11(paddr11[5:0]),
        . pwdata11(pwdata11),
        . gpio_pin_in11(gpio_pin_in11),
        . scan_en11(scan_en11),
        . tri_state_enable11(tri_state_enable11),
        . scan_in11(), //added by smarkov11 for dft11

        //outputs11
        . scan_out11(), //added by smarkov11 for dft11
        . prdata11(prdata_gpio11),
        . gpio_int11(GPIO_int11),
        . n_gpio_pin_oe11(n_gpio_pin_oe11),
        . gpio_pin_out11(gpio_pin_out11)
);


ttc_veneer11 i_ttc_veneer11 (

         //inputs11
        . n_p_reset11(n_preset11),
        . pclk11(pclk11),
        . psel11(psel_ttc11),
        . penable11(penable11),
        . pwrite11(pwrite11),
        . pwdata11(pwdata11),
        . paddr11(paddr11[7:0]),
        . scan_in11(),
        . scan_en11(scan_en11),

        //outputs11
        . prdata11(prdata_ttc11),
        . interrupt11(TTC_int11[3:1]),
        . scan_out11()
);


smc_veneer11 i_smc_veneer11 (
        //inputs11
	//apb11 inputs11
        . n_preset11(n_preset11),
        . pclk11(pclk_SRPG_smc11),
        . psel11(psel_smc11),
        . penable11(penable11),
        . pwrite11(pwrite11),
        . paddr11(paddr11[4:0]),
        . pwdata11(pwdata11),
        //ahb11 inputs11
	. hclk11(smc_hclk11),
        . n_sys_reset11(rstn_non_srpg_smc11),
        . haddr11(smc_haddr11),
        . htrans11(smc_htrans11),
        . hsel11(smc_hsel_int11),
        . hwrite11(smc_hwrite11),
	. hsize11(smc_hsize11),
        . hwdata11(smc_hwdata11),
        . hready11(smc_hready_in11),
        . data_smc11(data_smc11),

         //test signal11 inputs11

        . scan_in_111(),
        . scan_in_211(),
        . scan_in_311(),
        . scan_en11(scan_en11),

        //apb11 outputs11
        . prdata11(prdata_smc11),

       //design output

        . smc_hrdata11(smc_hrdata11),
        . smc_hready11(smc_hready11),
        . smc_hresp11(smc_hresp11),
        . smc_valid11(smc_valid11),
        . smc_addr11(smc_addr_int11),
        . smc_data11(smc_data11),
        . smc_n_be11(smc_n_be11),
        . smc_n_cs11(smc_n_cs11),
        . smc_n_wr11(smc_n_wr11),
        . smc_n_we11(smc_n_we11),
        . smc_n_rd11(smc_n_rd11),
        . smc_n_ext_oe11(smc_n_ext_oe11),
        . smc_busy11(smc_busy11),

         //test signal11 output
        . scan_out_111(),
        . scan_out_211(),
        . scan_out_311()
);

power_ctrl_veneer11 i_power_ctrl_veneer11 (
    // -- Clocks11 & Reset11
    	.pclk11(pclk11), 			//  : in  std_logic11;
    	.nprst11(n_preset11), 		//  : in  std_logic11;
    // -- APB11 programming11 interface
    	.paddr11(paddr11), 			//  : in  std_logic_vector11(31 downto11 0);
    	.psel11(psel_pmc11), 			//  : in  std_logic11;
    	.penable11(penable11), 		//  : in  std_logic11;
    	.pwrite11(pwrite11), 		//  : in  std_logic11;
    	.pwdata11(pwdata11), 		//  : in  std_logic_vector11(31 downto11 0);
    	.prdata11(prdata_pmc11), 		//  : out std_logic_vector11(31 downto11 0);
        .macb3_wakeup11(macb3_wakeup11),
        .macb2_wakeup11(macb2_wakeup11),
        .macb1_wakeup11(macb1_wakeup11),
        .macb0_wakeup11(macb0_wakeup11),
    // -- Module11 control11 outputs11
    	.scan_in11(),			//  : in  std_logic11;
    	.scan_en11(scan_en11),             	//  : in  std_logic11;
    	.scan_mode11(scan_mode11),          //  : in  std_logic11;
    	.scan_out11(),            	//  : out std_logic11;
        .int_source_h11(int_source_h11),
     	.rstn_non_srpg_smc11(rstn_non_srpg_smc11), 		//   : out std_logic11;
    	.gate_clk_smc11(gate_clk_smc11), 	//  : out std_logic11;
    	.isolate_smc11(isolate_smc11), 	//  : out std_logic11;
    	.save_edge_smc11(save_edge_smc11), 	//  : out std_logic11;
    	.restore_edge_smc11(restore_edge_smc11), 	//  : out std_logic11;
    	.pwr1_on_smc11(pwr1_on_smc11), 	//  : out std_logic11;
    	.pwr2_on_smc11(pwr2_on_smc11), 	//  : out std_logic11
     	.rstn_non_srpg_urt11(rstn_non_srpg_urt11), 		//   : out std_logic11;
    	.gate_clk_urt11(gate_clk_urt11), 	//  : out std_logic11;
    	.isolate_urt11(isolate_urt11), 	//  : out std_logic11;
    	.save_edge_urt11(save_edge_urt11), 	//  : out std_logic11;
    	.restore_edge_urt11(restore_edge_urt11), 	//  : out std_logic11;
    	.pwr1_on_urt11(pwr1_on_urt11), 	//  : out std_logic11;
    	.pwr2_on_urt11(pwr2_on_urt11),  	//  : out std_logic11
        // ETH011
        .rstn_non_srpg_macb011(rstn_non_srpg_macb011),
        .gate_clk_macb011(gate_clk_macb011),
        .isolate_macb011(isolate_macb011),
        .save_edge_macb011(save_edge_macb011),
        .restore_edge_macb011(restore_edge_macb011),
        .pwr1_on_macb011(pwr1_on_macb011),
        .pwr2_on_macb011(pwr2_on_macb011),
        // ETH111
        .rstn_non_srpg_macb111(rstn_non_srpg_macb111),
        .gate_clk_macb111(gate_clk_macb111),
        .isolate_macb111(isolate_macb111),
        .save_edge_macb111(save_edge_macb111),
        .restore_edge_macb111(restore_edge_macb111),
        .pwr1_on_macb111(pwr1_on_macb111),
        .pwr2_on_macb111(pwr2_on_macb111),
        // ETH211
        .rstn_non_srpg_macb211(rstn_non_srpg_macb211),
        .gate_clk_macb211(gate_clk_macb211),
        .isolate_macb211(isolate_macb211),
        .save_edge_macb211(save_edge_macb211),
        .restore_edge_macb211(restore_edge_macb211),
        .pwr1_on_macb211(pwr1_on_macb211),
        .pwr2_on_macb211(pwr2_on_macb211),
        // ETH311
        .rstn_non_srpg_macb311(rstn_non_srpg_macb311),
        .gate_clk_macb311(gate_clk_macb311),
        .isolate_macb311(isolate_macb311),
        .save_edge_macb311(save_edge_macb311),
        .restore_edge_macb311(restore_edge_macb311),
        .pwr1_on_macb311(pwr1_on_macb311),
        .pwr2_on_macb311(pwr2_on_macb311),
        .core06v11(core06v11),
        .core08v11(core08v11),
        .core10v11(core10v11),
        .core12v11(core12v11),
        .pcm_macb_wakeup_int11(pcm_macb_wakeup_int11),
        .isolate_mem11(isolate_mem11),
        .mte_smc_start11(mte_smc_start11),
        .mte_uart_start11(mte_uart_start11),
        .mte_smc_uart_start11(mte_smc_uart_start11),  
        .mte_pm_smc_to_default_start11(mte_pm_smc_to_default_start11), 
        .mte_pm_uart_to_default_start11(mte_pm_uart_to_default_start11),
        .mte_pm_smc_uart_to_default_start11(mte_pm_smc_uart_to_default_start11)
);

// Clock11 gating11 macro11 to shut11 off11 clocks11 to the SRPG11 flops11 in the SMC11
//CKLNQD111 i_SMC_SRPG_clk_gate11  (
//	.TE11(scan_mode11), 
//	.E11(~gate_clk_smc11), 
//	.CP11(pclk11), 
//	.Q11(pclk_SRPG_smc11)
//	);
// Replace11 gate11 with behavioural11 code11 //
wire 	smc_scan_gate11;
reg 	smc_latched_enable11;
assign smc_scan_gate11 = scan_mode11 ? 1'b1 : ~gate_clk_smc11;

always @ (pclk11 or smc_scan_gate11)
  	if (pclk11 == 1'b0) begin
  		smc_latched_enable11 <= smc_scan_gate11;
  	end  	
	
assign pclk_SRPG_smc11 = smc_latched_enable11 ? pclk11 : 1'b0;


// Clock11 gating11 macro11 to shut11 off11 clocks11 to the SRPG11 flops11 in the URT11
//CKLNQD111 i_URT_SRPG_clk_gate11  (
//	.TE11(scan_mode11), 
//	.E11(~gate_clk_urt11), 
//	.CP11(pclk11), 
//	.Q11(pclk_SRPG_urt11)
//	);
// Replace11 gate11 with behavioural11 code11 //
wire 	urt_scan_gate11;
reg 	urt_latched_enable11;
assign urt_scan_gate11 = scan_mode11 ? 1'b1 : ~gate_clk_urt11;

always @ (pclk11 or urt_scan_gate11)
  	if (pclk11 == 1'b0) begin
  		urt_latched_enable11 <= urt_scan_gate11;
  	end  	
	
assign pclk_SRPG_urt11 = urt_latched_enable11 ? pclk11 : 1'b0;

// ETH011
wire 	macb0_scan_gate11;
reg 	macb0_latched_enable11;
assign macb0_scan_gate11 = scan_mode11 ? 1'b1 : ~gate_clk_macb011;

always @ (pclk11 or macb0_scan_gate11)
  	if (pclk11 == 1'b0) begin
  		macb0_latched_enable11 <= macb0_scan_gate11;
  	end  	
	
assign clk_SRPG_macb0_en11 = macb0_latched_enable11 ? 1'b1 : 1'b0;

// ETH111
wire 	macb1_scan_gate11;
reg 	macb1_latched_enable11;
assign macb1_scan_gate11 = scan_mode11 ? 1'b1 : ~gate_clk_macb111;

always @ (pclk11 or macb1_scan_gate11)
  	if (pclk11 == 1'b0) begin
  		macb1_latched_enable11 <= macb1_scan_gate11;
  	end  	
	
assign clk_SRPG_macb1_en11 = macb1_latched_enable11 ? 1'b1 : 1'b0;

// ETH211
wire 	macb2_scan_gate11;
reg 	macb2_latched_enable11;
assign macb2_scan_gate11 = scan_mode11 ? 1'b1 : ~gate_clk_macb211;

always @ (pclk11 or macb2_scan_gate11)
  	if (pclk11 == 1'b0) begin
  		macb2_latched_enable11 <= macb2_scan_gate11;
  	end  	
	
assign clk_SRPG_macb2_en11 = macb2_latched_enable11 ? 1'b1 : 1'b0;

// ETH311
wire 	macb3_scan_gate11;
reg 	macb3_latched_enable11;
assign macb3_scan_gate11 = scan_mode11 ? 1'b1 : ~gate_clk_macb311;

always @ (pclk11 or macb3_scan_gate11)
  	if (pclk11 == 1'b0) begin
  		macb3_latched_enable11 <= macb3_scan_gate11;
  	end  	
	
assign clk_SRPG_macb3_en11 = macb3_latched_enable11 ? 1'b1 : 1'b0;



`else
//------------------------------------------------------------------------------
// if the APB11 subsystem11 is black11 boxed11 
//------------------------------------------------------------------------------
// wire s ports11
    // system signals11
    wire         hclk11;     // AHB11 Clock11
    wire         n_hreset11;  // AHB11 reset - Active11 low11
    wire         pclk11;     // APB11 Clock11. 
    wire         n_preset11;  // APB11 reset - Active11 low11

    // AHB11 interface
    wire         ahb2apb0_hsel11;     // AHB2APB11 select11
    wire  [31:0] haddr11;    // Address bus
    wire  [1:0]  htrans11;   // Transfer11 type
    wire  [2:0]  hsize11;    // AHB11 Access type - byte, half11-word11, word11
    wire  [31:0] hwdata11;   // Write data
    wire         hwrite11;   // Write signal11/
    wire         hready_in11;// Indicates11 that last master11 has finished11 bus access
    wire [2:0]   hburst11;     // Burst type
    wire [3:0]   hprot11;      // Protection11 control11
    wire [3:0]   hmaster11;    // Master11 select11
    wire         hmastlock11;  // Locked11 transfer11
  // Interrupts11 from the Enet11 MACs11
    wire         macb0_int11;
    wire         macb1_int11;
    wire         macb2_int11;
    wire         macb3_int11;
  // Interrupt11 from the DMA11
    wire         DMA_irq11;
  // Scan11 wire s
    wire         scan_en11;    // Scan11 enable pin11
    wire         scan_in_111;  // Scan11 wire  for first chain11
    wire         scan_in_211;  // Scan11 wire  for second chain11
    wire         scan_mode11;  // test mode pin11
 
  //wire  for smc11 AHB11 interface
    wire         smc_hclk11;
    wire         smc_n_hclk11;
    wire  [31:0] smc_haddr11;
    wire  [1:0]  smc_htrans11;
    wire         smc_hsel11;
    wire         smc_hwrite11;
    wire  [2:0]  smc_hsize11;
    wire  [31:0] smc_hwdata11;
    wire         smc_hready_in11;
    wire  [2:0]  smc_hburst11;     // Burst type
    wire  [3:0]  smc_hprot11;      // Protection11 control11
    wire  [3:0]  smc_hmaster11;    // Master11 select11
    wire         smc_hmastlock11;  // Locked11 transfer11


    wire  [31:0] data_smc11;     // EMI11(External11 memory) read data
    
  //wire s for uart11
    wire         ua_rxd11;       // UART11 receiver11 serial11 wire  pin11
    wire         ua_rxd111;      // UART11 receiver11 serial11 wire  pin11
    wire         ua_ncts11;      // Clear-To11-Send11 flow11 control11
    wire         ua_ncts111;      // Clear-To11-Send11 flow11 control11
   //wire s for spi11
    wire         n_ss_in11;      // select11 wire  to slave11
    wire         mi11;           // data wire  to master11
    wire         si11;           // data wire  to slave11
    wire         sclk_in11;      // clock11 wire  to slave11
  //wire s for GPIO11
   wire  [GPIO_WIDTH11-1:0]  gpio_pin_in11;             // wire  data from pin11

  //reg    ports11
  // Scan11 reg   s
   reg           scan_out_111;   // Scan11 out for chain11 1
   reg           scan_out_211;   // Scan11 out for chain11 2
  //AHB11 interface 
   reg    [31:0] hrdata11;       // Read data provided from target slave11
   reg           hready11;       // Ready11 for new bus cycle from target slave11
   reg    [1:0]  hresp11;       // Response11 from the bridge11

   // SMC11 reg    for AHB11 interface
   reg    [31:0]    smc_hrdata11;
   reg              smc_hready11;
   reg    [1:0]     smc_hresp11;

  //reg   s from smc11
   reg    [15:0]    smc_addr11;      // External11 Memory (EMI11) address
   reg    [3:0]     smc_n_be11;      // EMI11 byte enables11 (Active11 LOW11)
   reg    [7:0]     smc_n_cs11;      // EMI11 Chip11 Selects11 (Active11 LOW11)
   reg    [3:0]     smc_n_we11;      // EMI11 write strobes11 (Active11 LOW11)
   reg              smc_n_wr11;      // EMI11 write enable (Active11 LOW11)
   reg              smc_n_rd11;      // EMI11 read stobe11 (Active11 LOW11)
   reg              smc_n_ext_oe11;  // EMI11 write data reg    enable
   reg    [31:0]    smc_data11;      // EMI11 write data
  //reg   s from uart11
   reg           ua_txd11;       	// UART11 transmitter11 serial11 reg   
   reg           ua_txd111;       // UART11 transmitter11 serial11 reg   
   reg           ua_nrts11;      	// Request11-To11-Send11 flow11 control11
   reg           ua_nrts111;      // Request11-To11-Send11 flow11 control11
   // reg   s from ttc11
  // reg   s from SPI11
   reg       so;                    // data reg    from slave11
   reg       mo11;                    // data reg    from master11
   reg       sclk_out11;              // clock11 reg    from master11
   reg    [P_SIZE11-1:0] n_ss_out11;    // peripheral11 select11 lines11 from master11
   reg       n_so_en11;               // out enable for slave11 data
   reg       n_mo_en11;               // out enable for master11 data
   reg       n_sclk_en11;             // out enable for master11 clock11
   reg       n_ss_en11;               // out enable for master11 peripheral11 lines11
  //reg   s from gpio11
   reg    [GPIO_WIDTH11-1:0]     n_gpio_pin_oe11;           // reg    enable signal11 to pin11
   reg    [GPIO_WIDTH11-1:0]     gpio_pin_out11;            // reg    signal11 to pin11


`endif
//------------------------------------------------------------------------------
// black11 boxed11 defines11 
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// APB11 and AHB11 interface formal11 verification11 monitors11
//------------------------------------------------------------------------------
`ifdef ABV_ON11
apb_assert11 i_apb_assert11 (

        // APB11 signals11
  	.n_preset11(n_preset11),
   	.pclk11(pclk11),
	.penable11(penable11),
	.paddr11(paddr11),
	.pwrite11(pwrite11),
	.pwdata11(pwdata11),

	.psel0011(psel_spi11),
	.psel0111(psel_uart011),
	.psel0211(psel_gpio11),
	.psel0311(psel_ttc11),
	.psel0411(1'b0),
	.psel0511(psel_smc11),
	.psel0611(1'b0),
	.psel0711(1'b0),
	.psel0811(1'b0),
	.psel0911(1'b0),
	.psel1011(1'b0),
	.psel1111(1'b0),
	.psel1211(1'b0),
	.psel1311(psel_pmc11),
	.psel1411(psel_apic11),
	.psel1511(psel_uart111),

        .prdata0011(prdata_spi11),
        .prdata0111(prdata_uart011), // Read Data from peripheral11 UART11 
        .prdata0211(prdata_gpio11), // Read Data from peripheral11 GPIO11
        .prdata0311(prdata_ttc11), // Read Data from peripheral11 TTC11
        .prdata0411(32'b0), // 
        .prdata0511(prdata_smc11), // Read Data from peripheral11 SMC11
        .prdata1311(prdata_pmc11), // Read Data from peripheral11 Power11 Control11 Block
   	.prdata1411(32'b0), // 
        .prdata1511(prdata_uart111),


        // AHB11 signals11
        .hclk11(hclk11),         // ahb11 system clock11
        .n_hreset11(n_hreset11), // ahb11 system reset

        // ahb2apb11 signals11
        .hresp11(hresp11),
        .hready11(hready11),
        .hrdata11(hrdata11),
        .hwdata11(hwdata11),
        .hprot11(hprot11),
        .hburst11(hburst11),
        .hsize11(hsize11),
        .hwrite11(hwrite11),
        .htrans11(htrans11),
        .haddr11(haddr11),
        .ahb2apb_hsel11(ahb2apb0_hsel11));



//------------------------------------------------------------------------------
// AHB11 interface formal11 verification11 monitor11
//------------------------------------------------------------------------------
defparam i_ahbSlaveMonitor11.DBUS_WIDTH11 = 32;
defparam i_ahbMasterMonitor11.DBUS_WIDTH11 = 32;


// AHB2APB11 Bridge11

    ahb_liteslave_monitor11 i_ahbSlaveMonitor11 (
        .hclk_i11(hclk11),
        .hresetn_i11(n_hreset11),
        .hresp11(hresp11),
        .hready11(hready11),
        .hready_global_i11(hready11),
        .hrdata11(hrdata11),
        .hwdata_i11(hwdata11),
        .hburst_i11(hburst11),
        .hsize_i11(hsize11),
        .hwrite_i11(hwrite11),
        .htrans_i11(htrans11),
        .haddr_i11(haddr11),
        .hsel_i11(ahb2apb0_hsel11)
    );


  ahb_litemaster_monitor11 i_ahbMasterMonitor11 (
          .hclk_i11(hclk11),
          .hresetn_i11(n_hreset11),
          .hresp_i11(hresp11),
          .hready_i11(hready11),
          .hrdata_i11(hrdata11),
          .hlock11(1'b0),
          .hwdata11(hwdata11),
          .hprot11(hprot11),
          .hburst11(hburst11),
          .hsize11(hsize11),
          .hwrite11(hwrite11),
          .htrans11(htrans11),
          .haddr11(haddr11)
          );







`endif




`ifdef IFV_LP_ABV_ON11
// power11 control11
wire isolate11;

// testbench mirror signals11
wire L1_ctrl_access11;
wire L1_status_access11;

wire [31:0] L1_status_reg11;
wire [31:0] L1_ctrl_reg11;

//wire rstn_non_srpg_urt11;
//wire isolate_urt11;
//wire retain_urt11;
//wire gate_clk_urt11;
//wire pwr1_on_urt11;


// smc11 signals11
wire [31:0] smc_prdata11;
wire lp_clk_smc11;
                    

// uart11 isolation11 register
  wire [15:0] ua_prdata11;
  wire ua_int11;
  assign ua_prdata11          =  i_uart1_veneer11.prdata11;
  assign ua_int11             =  i_uart1_veneer11.ua_int11;


assign lp_clk_smc11          = i_smc_veneer11.pclk11;
assign smc_prdata11          = i_smc_veneer11.prdata11;
lp_chk_smc11 u_lp_chk_smc11 (
    .clk11 (hclk11),
    .rst11 (n_hreset11),
    .iso_smc11 (isolate_smc11),
    .gate_clk11 (gate_clk_smc11),
    .lp_clk11 (pclk_SRPG_smc11),

    // srpg11 outputs11
    .smc_hrdata11 (smc_hrdata11),
    .smc_hready11 (smc_hready11),
    .smc_hresp11  (smc_hresp11),
    .smc_valid11 (smc_valid11),
    .smc_addr_int11 (smc_addr_int11),
    .smc_data11 (smc_data11),
    .smc_n_be11 (smc_n_be11),
    .smc_n_cs11  (smc_n_cs11),
    .smc_n_wr11 (smc_n_wr11),
    .smc_n_we11 (smc_n_we11),
    .smc_n_rd11 (smc_n_rd11),
    .smc_n_ext_oe11 (smc_n_ext_oe11)
   );

// lp11 retention11/isolation11 assertions11
lp_chk_uart11 u_lp_chk_urt11 (

  .clk11         (hclk11),
  .rst11         (n_hreset11),
  .iso_urt11     (isolate_urt11),
  .gate_clk11    (gate_clk_urt11),
  .lp_clk11      (pclk_SRPG_urt11),
  //ports11
  .prdata11 (ua_prdata11),
  .ua_int11 (ua_int11),
  .ua_txd11 (ua_txd111),
  .ua_nrts11 (ua_nrts111)
 );

`endif  //IFV_LP_ABV_ON11




endmodule
