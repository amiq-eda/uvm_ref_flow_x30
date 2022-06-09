//File23 name   : apb_subsystem_023.v
//Title23       : 
//Created23     : 1999
//Description23 : 
//Notes23       : 
//----------------------------------------------------------------------
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------

module apb_subsystem_023(
    // AHB23 interface
    hclk23,
    n_hreset23,
    hsel23,
    haddr23,
    htrans23,
    hsize23,
    hwrite23,
    hwdata23,
    hready_in23,
    hburst23,
    hprot23,
    hmaster23,
    hmastlock23,
    hrdata23,
    hready23,
    hresp23,
    
    // APB23 system interface
    pclk23,
    n_preset23,
    
    // SPI23 ports23
    n_ss_in23,
    mi23,
    si23,
    sclk_in23,
    so,
    mo23,
    sclk_out23,
    n_ss_out23,
    n_so_en23,
    n_mo_en23,
    n_sclk_en23,
    n_ss_en23,
    
    //UART023 ports23
    ua_rxd23,
    ua_ncts23,
    ua_txd23,
    ua_nrts23,
    
    //UART123 ports23
    ua_rxd123,
    ua_ncts123,
    ua_txd123,
    ua_nrts123,
    
    //GPIO23 ports23
    gpio_pin_in23,
    n_gpio_pin_oe23,
    gpio_pin_out23,
    

    //SMC23 ports23
    smc_hclk23,
    smc_n_hclk23,
    smc_haddr23,
    smc_htrans23,
    smc_hsel23,
    smc_hwrite23,
    smc_hsize23,
    smc_hwdata23,
    smc_hready_in23,
    smc_hburst23,
    smc_hprot23,
    smc_hmaster23,
    smc_hmastlock23,
    smc_hrdata23, 
    smc_hready23,
    smc_hresp23,
    smc_n_ext_oe23,
    smc_data23,
    smc_addr23,
    smc_n_be23,
    smc_n_cs23, 
    smc_n_we23,
    smc_n_wr23,
    smc_n_rd23,
    data_smc23,
    
    //PMC23 ports23
    clk_SRPG_macb0_en23,
    clk_SRPG_macb1_en23,
    clk_SRPG_macb2_en23,
    clk_SRPG_macb3_en23,
    core06v23,
    core08v23,
    core10v23,
    core12v23,
    macb3_wakeup23,
    macb2_wakeup23,
    macb1_wakeup23,
    macb0_wakeup23,
    mte_smc_start23,
    mte_uart_start23,
    mte_smc_uart_start23,  
    mte_pm_smc_to_default_start23, 
    mte_pm_uart_to_default_start23,
    mte_pm_smc_uart_to_default_start23,
    
    
    // Peripheral23 inerrupts23
    pcm_irq23,
    ttc_irq23,
    gpio_irq23,
    uart0_irq23,
    uart1_irq23,
    spi_irq23,
    DMA_irq23,      
    macb0_int23,
    macb1_int23,
    macb2_int23,
    macb3_int23,
   
    // Scan23 ports23
    scan_en23,      // Scan23 enable pin23
    scan_in_123,    // Scan23 input for first chain23
    scan_in_223,    // Scan23 input for second chain23
    scan_mode23,
    scan_out_123,   // Scan23 out for chain23 1
    scan_out_223    // Scan23 out for chain23 2
);

parameter GPIO_WIDTH23 = 16;        // GPIO23 width
parameter P_SIZE23 =   8;              // number23 of peripheral23 select23 lines23
parameter NO_OF_IRQS23  = 17;      //No of irqs23 read by apic23 

// AHB23 interface
input         hclk23;     // AHB23 Clock23
input         n_hreset23;  // AHB23 reset - Active23 low23
input         hsel23;     // AHB2APB23 select23
input [31:0]  haddr23;    // Address bus
input [1:0]   htrans23;   // Transfer23 type
input [2:0]   hsize23;    // AHB23 Access type - byte, half23-word23, word23
input [31:0]  hwdata23;   // Write data
input         hwrite23;   // Write signal23/
input         hready_in23;// Indicates23 that last master23 has finished23 bus access
input [2:0]   hburst23;     // Burst type
input [3:0]   hprot23;      // Protection23 control23
input [3:0]   hmaster23;    // Master23 select23
input         hmastlock23;  // Locked23 transfer23
output [31:0] hrdata23;       // Read data provided from target slave23
output        hready23;       // Ready23 for new bus cycle from target slave23
output [1:0]  hresp23;       // Response23 from the bridge23
    
// APB23 system interface
input         pclk23;     // APB23 Clock23. 
input         n_preset23;  // APB23 reset - Active23 low23
   
// SPI23 ports23
input     n_ss_in23;      // select23 input to slave23
input     mi23;           // data input to master23
input     si23;           // data input to slave23
input     sclk_in23;      // clock23 input to slave23
output    so;                    // data output from slave23
output    mo23;                    // data output from master23
output    sclk_out23;              // clock23 output from master23
output [P_SIZE23-1:0] n_ss_out23;    // peripheral23 select23 lines23 from master23
output    n_so_en23;               // out enable for slave23 data
output    n_mo_en23;               // out enable for master23 data
output    n_sclk_en23;             // out enable for master23 clock23
output    n_ss_en23;               // out enable for master23 peripheral23 lines23

//UART023 ports23
input        ua_rxd23;       // UART23 receiver23 serial23 input pin23
input        ua_ncts23;      // Clear-To23-Send23 flow23 control23
output       ua_txd23;       	// UART23 transmitter23 serial23 output
output       ua_nrts23;      	// Request23-To23-Send23 flow23 control23

// UART123 ports23   
input        ua_rxd123;      // UART23 receiver23 serial23 input pin23
input        ua_ncts123;      // Clear-To23-Send23 flow23 control23
output       ua_txd123;       // UART23 transmitter23 serial23 output
output       ua_nrts123;      // Request23-To23-Send23 flow23 control23

//GPIO23 ports23
input [GPIO_WIDTH23-1:0]      gpio_pin_in23;             // input data from pin23
output [GPIO_WIDTH23-1:0]     n_gpio_pin_oe23;           // output enable signal23 to pin23
output [GPIO_WIDTH23-1:0]     gpio_pin_out23;            // output signal23 to pin23
  
//SMC23 ports23
input        smc_hclk23;
input        smc_n_hclk23;
input [31:0] smc_haddr23;
input [1:0]  smc_htrans23;
input        smc_hsel23;
input        smc_hwrite23;
input [2:0]  smc_hsize23;
input [31:0] smc_hwdata23;
input        smc_hready_in23;
input [2:0]  smc_hburst23;     // Burst type
input [3:0]  smc_hprot23;      // Protection23 control23
input [3:0]  smc_hmaster23;    // Master23 select23
input        smc_hmastlock23;  // Locked23 transfer23
input [31:0] data_smc23;     // EMI23(External23 memory) read data
output [31:0]    smc_hrdata23;
output           smc_hready23;
output [1:0]     smc_hresp23;
output [15:0]    smc_addr23;      // External23 Memory (EMI23) address
output [3:0]     smc_n_be23;      // EMI23 byte enables23 (Active23 LOW23)
output           smc_n_cs23;      // EMI23 Chip23 Selects23 (Active23 LOW23)
output [3:0]     smc_n_we23;      // EMI23 write strobes23 (Active23 LOW23)
output           smc_n_wr23;      // EMI23 write enable (Active23 LOW23)
output           smc_n_rd23;      // EMI23 read stobe23 (Active23 LOW23)
output           smc_n_ext_oe23;  // EMI23 write data output enable
output [31:0]    smc_data23;      // EMI23 write data
       
//PMC23 ports23
output clk_SRPG_macb0_en23;
output clk_SRPG_macb1_en23;
output clk_SRPG_macb2_en23;
output clk_SRPG_macb3_en23;
output core06v23;
output core08v23;
output core10v23;
output core12v23;
output mte_smc_start23;
output mte_uart_start23;
output mte_smc_uart_start23;  
output mte_pm_smc_to_default_start23; 
output mte_pm_uart_to_default_start23;
output mte_pm_smc_uart_to_default_start23;
input macb3_wakeup23;
input macb2_wakeup23;
input macb1_wakeup23;
input macb0_wakeup23;
    

// Peripheral23 interrupts23
output pcm_irq23;
output [2:0] ttc_irq23;
output gpio_irq23;
output uart0_irq23;
output uart1_irq23;
output spi_irq23;
input        macb0_int23;
input        macb1_int23;
input        macb2_int23;
input        macb3_int23;
input        DMA_irq23;
  
//Scan23 ports23
input        scan_en23;    // Scan23 enable pin23
input        scan_in_123;  // Scan23 input for first chain23
input        scan_in_223;  // Scan23 input for second chain23
input        scan_mode23;  // test mode pin23
 output        scan_out_123;   // Scan23 out for chain23 1
 output        scan_out_223;   // Scan23 out for chain23 2  

//------------------------------------------------------------------------------
// if the ROM23 subsystem23 is NOT23 black23 boxed23 
//------------------------------------------------------------------------------
`ifndef FV_KIT_BLACK_BOX_APB_SUBSYSTEM23
   
   wire        hsel23; 
   wire        pclk23;
   wire        n_preset23;
   wire [31:0] prdata_spi23;
   wire [31:0] prdata_uart023;
   wire [31:0] prdata_gpio23;
   wire [31:0] prdata_ttc23;
   wire [31:0] prdata_smc23;
   wire [31:0] prdata_pmc23;
   wire [31:0] prdata_uart123;
   wire        pready_spi23;
   wire        pready_uart023;
   wire        pready_uart123;
   wire        tie_hi_bit23;
   wire  [31:0] hrdata23; 
   wire         hready23;
   wire         hready_in23;
   wire  [1:0]  hresp23;   
   wire  [31:0] pwdata23;  
   wire         pwrite23;
   wire  [31:0] paddr23;  
   wire   psel_spi23;
   wire   psel_uart023;
   wire   psel_gpio23;
   wire   psel_ttc23;
   wire   psel_smc23;
   wire   psel0723;
   wire   psel0823;
   wire   psel0923;
   wire   psel1023;
   wire   psel1123;
   wire   psel1223;
   wire   psel_pmc23;
   wire   psel_uart123;
   wire   penable23;
   wire   [NO_OF_IRQS23:0] int_source23;     // System23 Interrupt23 Sources23
   wire [1:0]             smc_hresp23;     // AHB23 Response23 signal23
   wire                   smc_valid23;     // Ack23 valid address

  //External23 memory interface (EMI23)
  wire [31:0]            smc_addr_int23;  // External23 Memory (EMI23) address
  wire [3:0]             smc_n_be23;      // EMI23 byte enables23 (Active23 LOW23)
  wire                   smc_n_cs23;      // EMI23 Chip23 Selects23 (Active23 LOW23)
  wire [3:0]             smc_n_we23;      // EMI23 write strobes23 (Active23 LOW23)
  wire                   smc_n_wr23;      // EMI23 write enable (Active23 LOW23)
  wire                   smc_n_rd23;      // EMI23 read stobe23 (Active23 LOW23)
 
  //AHB23 Memory Interface23 Control23
  wire                   smc_hsel_int23;
  wire                   smc_busy23;      // smc23 busy
   

//scan23 signals23

   wire                scan_in_123;        //scan23 input
   wire                scan_in_223;        //scan23 input
   wire                scan_en23;         //scan23 enable
   wire                scan_out_123;       //scan23 output
   wire                scan_out_223;       //scan23 output
   wire                byte_sel23;     // byte select23 from bridge23 1=byte, 0=2byte
   wire                UART_int23;     // UART23 module interrupt23 
   wire                ua_uclken23;    // Soft23 control23 of clock23
   wire                UART_int123;     // UART23 module interrupt23 
   wire                ua_uclken123;    // Soft23 control23 of clock23
   wire  [3:1]         TTC_int23;            //Interrupt23 from PCI23 
  // inputs23 to SPI23 
   wire    ext_clk23;                // external23 clock23
   wire    SPI_int23;             // interrupt23 request
  // outputs23 from SPI23
   wire    slave_out_clk23;         // modified slave23 clock23 output
 // gpio23 generic23 inputs23 
   wire  [GPIO_WIDTH23-1:0]   n_gpio_bypass_oe23;        // bypass23 mode enable 
   wire  [GPIO_WIDTH23-1:0]   gpio_bypass_out23;         // bypass23 mode output value 
   wire  [GPIO_WIDTH23-1:0]   tri_state_enable23;   // disables23 op enable -> z 
 // outputs23 
   //amba23 outputs23 
   // gpio23 generic23 outputs23 
   wire       GPIO_int23;                // gpio_interupt23 for input pin23 change 
   wire [GPIO_WIDTH23-1:0]     gpio_bypass_in23;          // bypass23 mode input data value  
                
   wire           cpu_debug23;        // Inhibits23 watchdog23 counter 
   wire            ex_wdz_n23;         // External23 Watchdog23 zero indication23
   wire           rstn_non_srpg_smc23; 
   wire           rstn_non_srpg_urt23;
   wire           isolate_smc23;
   wire           save_edge_smc23;
   wire           restore_edge_smc23;
   wire           save_edge_urt23;
   wire           restore_edge_urt23;
   wire           pwr1_on_smc23;
   wire           pwr2_on_smc23;
   wire           pwr1_on_urt23;
   wire           pwr2_on_urt23;
   // ETH023
   wire            rstn_non_srpg_macb023;
   wire            gate_clk_macb023;
   wire            isolate_macb023;
   wire            save_edge_macb023;
   wire            restore_edge_macb023;
   wire            pwr1_on_macb023;
   wire            pwr2_on_macb023;
   // ETH123
   wire            rstn_non_srpg_macb123;
   wire            gate_clk_macb123;
   wire            isolate_macb123;
   wire            save_edge_macb123;
   wire            restore_edge_macb123;
   wire            pwr1_on_macb123;
   wire            pwr2_on_macb123;
   // ETH223
   wire            rstn_non_srpg_macb223;
   wire            gate_clk_macb223;
   wire            isolate_macb223;
   wire            save_edge_macb223;
   wire            restore_edge_macb223;
   wire            pwr1_on_macb223;
   wire            pwr2_on_macb223;
   // ETH323
   wire            rstn_non_srpg_macb323;
   wire            gate_clk_macb323;
   wire            isolate_macb323;
   wire            save_edge_macb323;
   wire            restore_edge_macb323;
   wire            pwr1_on_macb323;
   wire            pwr2_on_macb323;


   wire           pclk_SRPG_smc23;
   wire           pclk_SRPG_urt23;
   wire           gate_clk_smc23;
   wire           gate_clk_urt23;
   wire  [31:0]   tie_lo_32bit23; 
   wire  [1:0]	  tie_lo_2bit23;
   wire  	  tie_lo_1bit23;
   wire           pcm_macb_wakeup_int23;
   wire           int_source_h23;
   wire           isolate_mem23;

assign pcm_irq23 = pcm_macb_wakeup_int23;
assign ttc_irq23[2] = TTC_int23[3];
assign ttc_irq23[1] = TTC_int23[2];
assign ttc_irq23[0] = TTC_int23[1];
assign gpio_irq23 = GPIO_int23;
assign uart0_irq23 = UART_int23;
assign uart1_irq23 = UART_int123;
assign spi_irq23 = SPI_int23;

assign n_mo_en23   = 1'b0;
assign n_so_en23   = 1'b1;
assign n_sclk_en23 = 1'b0;
assign n_ss_en23   = 1'b0;

assign smc_hsel_int23 = smc_hsel23;
  assign ext_clk23  = 1'b0;
  assign int_source23 = {macb0_int23,macb1_int23, macb2_int23, macb3_int23,1'b0, pcm_macb_wakeup_int23, 1'b0, 1'b0, 1'b0, 1'b0, TTC_int23, GPIO_int23, UART_int23, UART_int123, SPI_int23, DMA_irq23};

  // interrupt23 even23 detect23 .
  // for sleep23 wake23 up -> any interrupt23 even23 and system not in hibernation23 (isolate_mem23 = 0)
  // for hibernate23 wake23 up -> gpio23 interrupt23 even23 and system in the hibernation23 (isolate_mem23 = 1)
  assign int_source_h23 =  ((|int_source23) && (!isolate_mem23)) || (isolate_mem23 && GPIO_int23) ;

  assign byte_sel23 = 1'b1;
  assign tie_hi_bit23 = 1'b1;

  assign smc_addr23 = smc_addr_int23[15:0];



  assign  n_gpio_bypass_oe23 = {GPIO_WIDTH23{1'b0}};        // bypass23 mode enable 
  assign  gpio_bypass_out23  = {GPIO_WIDTH23{1'b0}};
  assign  tri_state_enable23 = {GPIO_WIDTH23{1'b0}};
  assign  cpu_debug23 = 1'b0;
  assign  tie_lo_32bit23 = 32'b0;
  assign  tie_lo_2bit23  = 2'b0;
  assign  tie_lo_1bit23  = 1'b0;


ahb2apb23 #(
  32'h00800000, // Slave23 0 Address Range23
  32'h0080FFFF,

  32'h00810000, // Slave23 1 Address Range23
  32'h0081FFFF,

  32'h00820000, // Slave23 2 Address Range23 
  32'h0082FFFF,

  32'h00830000, // Slave23 3 Address Range23
  32'h0083FFFF,

  32'h00840000, // Slave23 4 Address Range23
  32'h0084FFFF,

  32'h00850000, // Slave23 5 Address Range23
  32'h0085FFFF,

  32'h00860000, // Slave23 6 Address Range23
  32'h0086FFFF,

  32'h00870000, // Slave23 7 Address Range23
  32'h0087FFFF,

  32'h00880000, // Slave23 8 Address Range23
  32'h0088FFFF
) i_ahb2apb23 (
     // AHB23 interface
    .hclk23(hclk23),         
    .hreset_n23(n_hreset23), 
    .hsel23(hsel23), 
    .haddr23(haddr23),        
    .htrans23(htrans23),       
    .hwrite23(hwrite23),       
    .hwdata23(hwdata23),       
    .hrdata23(hrdata23),   
    .hready23(hready23),   
    .hresp23(hresp23),     
    
     // APB23 interface
    .pclk23(pclk23),         
    .preset_n23(n_preset23),  
    .prdata023(prdata_spi23),
    .prdata123(prdata_uart023), 
    .prdata223(prdata_gpio23),  
    .prdata323(prdata_ttc23),   
    .prdata423(32'h0),   
    .prdata523(prdata_smc23),   
    .prdata623(prdata_pmc23),    
    .prdata723(32'h0),   
    .prdata823(prdata_uart123),  
    .pready023(pready_spi23),     
    .pready123(pready_uart023),   
    .pready223(tie_hi_bit23),     
    .pready323(tie_hi_bit23),     
    .pready423(tie_hi_bit23),     
    .pready523(tie_hi_bit23),     
    .pready623(tie_hi_bit23),     
    .pready723(tie_hi_bit23),     
    .pready823(pready_uart123),  
    .pwdata23(pwdata23),       
    .pwrite23(pwrite23),       
    .paddr23(paddr23),        
    .psel023(psel_spi23),     
    .psel123(psel_uart023),   
    .psel223(psel_gpio23),    
    .psel323(psel_ttc23),     
    .psel423(),     
    .psel523(psel_smc23),     
    .psel623(psel_pmc23),    
    .psel723(psel_apic23),   
    .psel823(psel_uart123),  
    .penable23(penable23)     
);

spi_top23 i_spi23
(
  // Wishbone23 signals23
  .wb_clk_i23(pclk23), 
  .wb_rst_i23(~n_preset23), 
  .wb_adr_i23(paddr23[4:0]), 
  .wb_dat_i23(pwdata23), 
  .wb_dat_o23(prdata_spi23), 
  .wb_sel_i23(4'b1111),    // SPI23 register accesses are always 32-bit
  .wb_we_i23(pwrite23), 
  .wb_stb_i23(psel_spi23), 
  .wb_cyc_i23(psel_spi23), 
  .wb_ack_o23(pready_spi23), 
  .wb_err_o23(), 
  .wb_int_o23(SPI_int23),

  // SPI23 signals23
  .ss_pad_o23(n_ss_out23), 
  .sclk_pad_o23(sclk_out23), 
  .mosi_pad_o23(mo23), 
  .miso_pad_i23(mi23)
);

// Opencores23 UART23 instances23
wire ua_nrts_int23;
wire ua_nrts1_int23;

assign ua_nrts23 = ua_nrts_int23;
assign ua_nrts123 = ua_nrts1_int23;

reg [3:0] uart0_sel_i23;
reg [3:0] uart1_sel_i23;
// UART23 registers are all 8-bit wide23, and their23 addresses23
// are on byte boundaries23. So23 to access them23 on the
// Wishbone23 bus, the CPU23 must do byte accesses to these23
// byte addresses23. Word23 address accesses are not possible23
// because the word23 addresses23 will be unaligned23, and cause
// a fault23.
// So23, Uart23 accesses from the CPU23 will always be 8-bit size
// We23 only have to decide23 which byte of the 4-byte word23 the
// CPU23 is interested23 in.
`ifdef SYSTEM_BIG_ENDIAN23
always @(paddr23) begin
  case (paddr23[1:0])
    2'b00 : uart0_sel_i23 = 4'b1000;
    2'b01 : uart0_sel_i23 = 4'b0100;
    2'b10 : uart0_sel_i23 = 4'b0010;
    2'b11 : uart0_sel_i23 = 4'b0001;
  endcase
end
always @(paddr23) begin
  case (paddr23[1:0])
    2'b00 : uart1_sel_i23 = 4'b1000;
    2'b01 : uart1_sel_i23 = 4'b0100;
    2'b10 : uart1_sel_i23 = 4'b0010;
    2'b11 : uart1_sel_i23 = 4'b0001;
  endcase
end
`else
always @(paddr23) begin
  case (paddr23[1:0])
    2'b00 : uart0_sel_i23 = 4'b0001;
    2'b01 : uart0_sel_i23 = 4'b0010;
    2'b10 : uart0_sel_i23 = 4'b0100;
    2'b11 : uart0_sel_i23 = 4'b1000;
  endcase
end
always @(paddr23) begin
  case (paddr23[1:0])
    2'b00 : uart1_sel_i23 = 4'b0001;
    2'b01 : uart1_sel_i23 = 4'b0010;
    2'b10 : uart1_sel_i23 = 4'b0100;
    2'b11 : uart1_sel_i23 = 4'b1000;
  endcase
end
`endif

uart_top23 i_oc_uart023 (
  .wb_clk_i23(pclk23),
  .wb_rst_i23(~n_preset23),
  .wb_adr_i23(paddr23[4:0]),
  .wb_dat_i23(pwdata23),
  .wb_dat_o23(prdata_uart023),
  .wb_we_i23(pwrite23),
  .wb_stb_i23(psel_uart023),
  .wb_cyc_i23(psel_uart023),
  .wb_ack_o23(pready_uart023),
  .wb_sel_i23(uart0_sel_i23),
  .int_o23(UART_int23),
  .stx_pad_o23(ua_txd23),
  .srx_pad_i23(ua_rxd23),
  .rts_pad_o23(ua_nrts_int23),
  .cts_pad_i23(ua_ncts23),
  .dtr_pad_o23(),
  .dsr_pad_i23(1'b0),
  .ri_pad_i23(1'b0),
  .dcd_pad_i23(1'b0)
);

uart_top23 i_oc_uart123 (
  .wb_clk_i23(pclk23),
  .wb_rst_i23(~n_preset23),
  .wb_adr_i23(paddr23[4:0]),
  .wb_dat_i23(pwdata23),
  .wb_dat_o23(prdata_uart123),
  .wb_we_i23(pwrite23),
  .wb_stb_i23(psel_uart123),
  .wb_cyc_i23(psel_uart123),
  .wb_ack_o23(pready_uart123),
  .wb_sel_i23(uart1_sel_i23),
  .int_o23(UART_int123),
  .stx_pad_o23(ua_txd123),
  .srx_pad_i23(ua_rxd123),
  .rts_pad_o23(ua_nrts1_int23),
  .cts_pad_i23(ua_ncts123),
  .dtr_pad_o23(),
  .dsr_pad_i23(1'b0),
  .ri_pad_i23(1'b0),
  .dcd_pad_i23(1'b0)
);

gpio_veneer23 i_gpio_veneer23 (
        //inputs23

        . n_p_reset23(n_preset23),
        . pclk23(pclk23),
        . psel23(psel_gpio23),
        . penable23(penable23),
        . pwrite23(pwrite23),
        . paddr23(paddr23[5:0]),
        . pwdata23(pwdata23),
        . gpio_pin_in23(gpio_pin_in23),
        . scan_en23(scan_en23),
        . tri_state_enable23(tri_state_enable23),
        . scan_in23(), //added by smarkov23 for dft23

        //outputs23
        . scan_out23(), //added by smarkov23 for dft23
        . prdata23(prdata_gpio23),
        . gpio_int23(GPIO_int23),
        . n_gpio_pin_oe23(n_gpio_pin_oe23),
        . gpio_pin_out23(gpio_pin_out23)
);


ttc_veneer23 i_ttc_veneer23 (

         //inputs23
        . n_p_reset23(n_preset23),
        . pclk23(pclk23),
        . psel23(psel_ttc23),
        . penable23(penable23),
        . pwrite23(pwrite23),
        . pwdata23(pwdata23),
        . paddr23(paddr23[7:0]),
        . scan_in23(),
        . scan_en23(scan_en23),

        //outputs23
        . prdata23(prdata_ttc23),
        . interrupt23(TTC_int23[3:1]),
        . scan_out23()
);


smc_veneer23 i_smc_veneer23 (
        //inputs23
	//apb23 inputs23
        . n_preset23(n_preset23),
        . pclk23(pclk_SRPG_smc23),
        . psel23(psel_smc23),
        . penable23(penable23),
        . pwrite23(pwrite23),
        . paddr23(paddr23[4:0]),
        . pwdata23(pwdata23),
        //ahb23 inputs23
	. hclk23(smc_hclk23),
        . n_sys_reset23(rstn_non_srpg_smc23),
        . haddr23(smc_haddr23),
        . htrans23(smc_htrans23),
        . hsel23(smc_hsel_int23),
        . hwrite23(smc_hwrite23),
	. hsize23(smc_hsize23),
        . hwdata23(smc_hwdata23),
        . hready23(smc_hready_in23),
        . data_smc23(data_smc23),

         //test signal23 inputs23

        . scan_in_123(),
        . scan_in_223(),
        . scan_in_323(),
        . scan_en23(scan_en23),

        //apb23 outputs23
        . prdata23(prdata_smc23),

       //design output

        . smc_hrdata23(smc_hrdata23),
        . smc_hready23(smc_hready23),
        . smc_hresp23(smc_hresp23),
        . smc_valid23(smc_valid23),
        . smc_addr23(smc_addr_int23),
        . smc_data23(smc_data23),
        . smc_n_be23(smc_n_be23),
        . smc_n_cs23(smc_n_cs23),
        . smc_n_wr23(smc_n_wr23),
        . smc_n_we23(smc_n_we23),
        . smc_n_rd23(smc_n_rd23),
        . smc_n_ext_oe23(smc_n_ext_oe23),
        . smc_busy23(smc_busy23),

         //test signal23 output
        . scan_out_123(),
        . scan_out_223(),
        . scan_out_323()
);

power_ctrl_veneer23 i_power_ctrl_veneer23 (
    // -- Clocks23 & Reset23
    	.pclk23(pclk23), 			//  : in  std_logic23;
    	.nprst23(n_preset23), 		//  : in  std_logic23;
    // -- APB23 programming23 interface
    	.paddr23(paddr23), 			//  : in  std_logic_vector23(31 downto23 0);
    	.psel23(psel_pmc23), 			//  : in  std_logic23;
    	.penable23(penable23), 		//  : in  std_logic23;
    	.pwrite23(pwrite23), 		//  : in  std_logic23;
    	.pwdata23(pwdata23), 		//  : in  std_logic_vector23(31 downto23 0);
    	.prdata23(prdata_pmc23), 		//  : out std_logic_vector23(31 downto23 0);
        .macb3_wakeup23(macb3_wakeup23),
        .macb2_wakeup23(macb2_wakeup23),
        .macb1_wakeup23(macb1_wakeup23),
        .macb0_wakeup23(macb0_wakeup23),
    // -- Module23 control23 outputs23
    	.scan_in23(),			//  : in  std_logic23;
    	.scan_en23(scan_en23),             	//  : in  std_logic23;
    	.scan_mode23(scan_mode23),          //  : in  std_logic23;
    	.scan_out23(),            	//  : out std_logic23;
        .int_source_h23(int_source_h23),
     	.rstn_non_srpg_smc23(rstn_non_srpg_smc23), 		//   : out std_logic23;
    	.gate_clk_smc23(gate_clk_smc23), 	//  : out std_logic23;
    	.isolate_smc23(isolate_smc23), 	//  : out std_logic23;
    	.save_edge_smc23(save_edge_smc23), 	//  : out std_logic23;
    	.restore_edge_smc23(restore_edge_smc23), 	//  : out std_logic23;
    	.pwr1_on_smc23(pwr1_on_smc23), 	//  : out std_logic23;
    	.pwr2_on_smc23(pwr2_on_smc23), 	//  : out std_logic23
     	.rstn_non_srpg_urt23(rstn_non_srpg_urt23), 		//   : out std_logic23;
    	.gate_clk_urt23(gate_clk_urt23), 	//  : out std_logic23;
    	.isolate_urt23(isolate_urt23), 	//  : out std_logic23;
    	.save_edge_urt23(save_edge_urt23), 	//  : out std_logic23;
    	.restore_edge_urt23(restore_edge_urt23), 	//  : out std_logic23;
    	.pwr1_on_urt23(pwr1_on_urt23), 	//  : out std_logic23;
    	.pwr2_on_urt23(pwr2_on_urt23),  	//  : out std_logic23
        // ETH023
        .rstn_non_srpg_macb023(rstn_non_srpg_macb023),
        .gate_clk_macb023(gate_clk_macb023),
        .isolate_macb023(isolate_macb023),
        .save_edge_macb023(save_edge_macb023),
        .restore_edge_macb023(restore_edge_macb023),
        .pwr1_on_macb023(pwr1_on_macb023),
        .pwr2_on_macb023(pwr2_on_macb023),
        // ETH123
        .rstn_non_srpg_macb123(rstn_non_srpg_macb123),
        .gate_clk_macb123(gate_clk_macb123),
        .isolate_macb123(isolate_macb123),
        .save_edge_macb123(save_edge_macb123),
        .restore_edge_macb123(restore_edge_macb123),
        .pwr1_on_macb123(pwr1_on_macb123),
        .pwr2_on_macb123(pwr2_on_macb123),
        // ETH223
        .rstn_non_srpg_macb223(rstn_non_srpg_macb223),
        .gate_clk_macb223(gate_clk_macb223),
        .isolate_macb223(isolate_macb223),
        .save_edge_macb223(save_edge_macb223),
        .restore_edge_macb223(restore_edge_macb223),
        .pwr1_on_macb223(pwr1_on_macb223),
        .pwr2_on_macb223(pwr2_on_macb223),
        // ETH323
        .rstn_non_srpg_macb323(rstn_non_srpg_macb323),
        .gate_clk_macb323(gate_clk_macb323),
        .isolate_macb323(isolate_macb323),
        .save_edge_macb323(save_edge_macb323),
        .restore_edge_macb323(restore_edge_macb323),
        .pwr1_on_macb323(pwr1_on_macb323),
        .pwr2_on_macb323(pwr2_on_macb323),
        .core06v23(core06v23),
        .core08v23(core08v23),
        .core10v23(core10v23),
        .core12v23(core12v23),
        .pcm_macb_wakeup_int23(pcm_macb_wakeup_int23),
        .isolate_mem23(isolate_mem23),
        .mte_smc_start23(mte_smc_start23),
        .mte_uart_start23(mte_uart_start23),
        .mte_smc_uart_start23(mte_smc_uart_start23),  
        .mte_pm_smc_to_default_start23(mte_pm_smc_to_default_start23), 
        .mte_pm_uart_to_default_start23(mte_pm_uart_to_default_start23),
        .mte_pm_smc_uart_to_default_start23(mte_pm_smc_uart_to_default_start23)
);

// Clock23 gating23 macro23 to shut23 off23 clocks23 to the SRPG23 flops23 in the SMC23
//CKLNQD123 i_SMC_SRPG_clk_gate23  (
//	.TE23(scan_mode23), 
//	.E23(~gate_clk_smc23), 
//	.CP23(pclk23), 
//	.Q23(pclk_SRPG_smc23)
//	);
// Replace23 gate23 with behavioural23 code23 //
wire 	smc_scan_gate23;
reg 	smc_latched_enable23;
assign smc_scan_gate23 = scan_mode23 ? 1'b1 : ~gate_clk_smc23;

always @ (pclk23 or smc_scan_gate23)
  	if (pclk23 == 1'b0) begin
  		smc_latched_enable23 <= smc_scan_gate23;
  	end  	
	
assign pclk_SRPG_smc23 = smc_latched_enable23 ? pclk23 : 1'b0;


// Clock23 gating23 macro23 to shut23 off23 clocks23 to the SRPG23 flops23 in the URT23
//CKLNQD123 i_URT_SRPG_clk_gate23  (
//	.TE23(scan_mode23), 
//	.E23(~gate_clk_urt23), 
//	.CP23(pclk23), 
//	.Q23(pclk_SRPG_urt23)
//	);
// Replace23 gate23 with behavioural23 code23 //
wire 	urt_scan_gate23;
reg 	urt_latched_enable23;
assign urt_scan_gate23 = scan_mode23 ? 1'b1 : ~gate_clk_urt23;

always @ (pclk23 or urt_scan_gate23)
  	if (pclk23 == 1'b0) begin
  		urt_latched_enable23 <= urt_scan_gate23;
  	end  	
	
assign pclk_SRPG_urt23 = urt_latched_enable23 ? pclk23 : 1'b0;

// ETH023
wire 	macb0_scan_gate23;
reg 	macb0_latched_enable23;
assign macb0_scan_gate23 = scan_mode23 ? 1'b1 : ~gate_clk_macb023;

always @ (pclk23 or macb0_scan_gate23)
  	if (pclk23 == 1'b0) begin
  		macb0_latched_enable23 <= macb0_scan_gate23;
  	end  	
	
assign clk_SRPG_macb0_en23 = macb0_latched_enable23 ? 1'b1 : 1'b0;

// ETH123
wire 	macb1_scan_gate23;
reg 	macb1_latched_enable23;
assign macb1_scan_gate23 = scan_mode23 ? 1'b1 : ~gate_clk_macb123;

always @ (pclk23 or macb1_scan_gate23)
  	if (pclk23 == 1'b0) begin
  		macb1_latched_enable23 <= macb1_scan_gate23;
  	end  	
	
assign clk_SRPG_macb1_en23 = macb1_latched_enable23 ? 1'b1 : 1'b0;

// ETH223
wire 	macb2_scan_gate23;
reg 	macb2_latched_enable23;
assign macb2_scan_gate23 = scan_mode23 ? 1'b1 : ~gate_clk_macb223;

always @ (pclk23 or macb2_scan_gate23)
  	if (pclk23 == 1'b0) begin
  		macb2_latched_enable23 <= macb2_scan_gate23;
  	end  	
	
assign clk_SRPG_macb2_en23 = macb2_latched_enable23 ? 1'b1 : 1'b0;

// ETH323
wire 	macb3_scan_gate23;
reg 	macb3_latched_enable23;
assign macb3_scan_gate23 = scan_mode23 ? 1'b1 : ~gate_clk_macb323;

always @ (pclk23 or macb3_scan_gate23)
  	if (pclk23 == 1'b0) begin
  		macb3_latched_enable23 <= macb3_scan_gate23;
  	end  	
	
assign clk_SRPG_macb3_en23 = macb3_latched_enable23 ? 1'b1 : 1'b0;



`else
//------------------------------------------------------------------------------
// if the APB23 subsystem23 is black23 boxed23 
//------------------------------------------------------------------------------
// wire s ports23
    // system signals23
    wire         hclk23;     // AHB23 Clock23
    wire         n_hreset23;  // AHB23 reset - Active23 low23
    wire         pclk23;     // APB23 Clock23. 
    wire         n_preset23;  // APB23 reset - Active23 low23

    // AHB23 interface
    wire         ahb2apb0_hsel23;     // AHB2APB23 select23
    wire  [31:0] haddr23;    // Address bus
    wire  [1:0]  htrans23;   // Transfer23 type
    wire  [2:0]  hsize23;    // AHB23 Access type - byte, half23-word23, word23
    wire  [31:0] hwdata23;   // Write data
    wire         hwrite23;   // Write signal23/
    wire         hready_in23;// Indicates23 that last master23 has finished23 bus access
    wire [2:0]   hburst23;     // Burst type
    wire [3:0]   hprot23;      // Protection23 control23
    wire [3:0]   hmaster23;    // Master23 select23
    wire         hmastlock23;  // Locked23 transfer23
  // Interrupts23 from the Enet23 MACs23
    wire         macb0_int23;
    wire         macb1_int23;
    wire         macb2_int23;
    wire         macb3_int23;
  // Interrupt23 from the DMA23
    wire         DMA_irq23;
  // Scan23 wire s
    wire         scan_en23;    // Scan23 enable pin23
    wire         scan_in_123;  // Scan23 wire  for first chain23
    wire         scan_in_223;  // Scan23 wire  for second chain23
    wire         scan_mode23;  // test mode pin23
 
  //wire  for smc23 AHB23 interface
    wire         smc_hclk23;
    wire         smc_n_hclk23;
    wire  [31:0] smc_haddr23;
    wire  [1:0]  smc_htrans23;
    wire         smc_hsel23;
    wire         smc_hwrite23;
    wire  [2:0]  smc_hsize23;
    wire  [31:0] smc_hwdata23;
    wire         smc_hready_in23;
    wire  [2:0]  smc_hburst23;     // Burst type
    wire  [3:0]  smc_hprot23;      // Protection23 control23
    wire  [3:0]  smc_hmaster23;    // Master23 select23
    wire         smc_hmastlock23;  // Locked23 transfer23


    wire  [31:0] data_smc23;     // EMI23(External23 memory) read data
    
  //wire s for uart23
    wire         ua_rxd23;       // UART23 receiver23 serial23 wire  pin23
    wire         ua_rxd123;      // UART23 receiver23 serial23 wire  pin23
    wire         ua_ncts23;      // Clear-To23-Send23 flow23 control23
    wire         ua_ncts123;      // Clear-To23-Send23 flow23 control23
   //wire s for spi23
    wire         n_ss_in23;      // select23 wire  to slave23
    wire         mi23;           // data wire  to master23
    wire         si23;           // data wire  to slave23
    wire         sclk_in23;      // clock23 wire  to slave23
  //wire s for GPIO23
   wire  [GPIO_WIDTH23-1:0]  gpio_pin_in23;             // wire  data from pin23

  //reg    ports23
  // Scan23 reg   s
   reg           scan_out_123;   // Scan23 out for chain23 1
   reg           scan_out_223;   // Scan23 out for chain23 2
  //AHB23 interface 
   reg    [31:0] hrdata23;       // Read data provided from target slave23
   reg           hready23;       // Ready23 for new bus cycle from target slave23
   reg    [1:0]  hresp23;       // Response23 from the bridge23

   // SMC23 reg    for AHB23 interface
   reg    [31:0]    smc_hrdata23;
   reg              smc_hready23;
   reg    [1:0]     smc_hresp23;

  //reg   s from smc23
   reg    [15:0]    smc_addr23;      // External23 Memory (EMI23) address
   reg    [3:0]     smc_n_be23;      // EMI23 byte enables23 (Active23 LOW23)
   reg    [7:0]     smc_n_cs23;      // EMI23 Chip23 Selects23 (Active23 LOW23)
   reg    [3:0]     smc_n_we23;      // EMI23 write strobes23 (Active23 LOW23)
   reg              smc_n_wr23;      // EMI23 write enable (Active23 LOW23)
   reg              smc_n_rd23;      // EMI23 read stobe23 (Active23 LOW23)
   reg              smc_n_ext_oe23;  // EMI23 write data reg    enable
   reg    [31:0]    smc_data23;      // EMI23 write data
  //reg   s from uart23
   reg           ua_txd23;       	// UART23 transmitter23 serial23 reg   
   reg           ua_txd123;       // UART23 transmitter23 serial23 reg   
   reg           ua_nrts23;      	// Request23-To23-Send23 flow23 control23
   reg           ua_nrts123;      // Request23-To23-Send23 flow23 control23
   // reg   s from ttc23
  // reg   s from SPI23
   reg       so;                    // data reg    from slave23
   reg       mo23;                    // data reg    from master23
   reg       sclk_out23;              // clock23 reg    from master23
   reg    [P_SIZE23-1:0] n_ss_out23;    // peripheral23 select23 lines23 from master23
   reg       n_so_en23;               // out enable for slave23 data
   reg       n_mo_en23;               // out enable for master23 data
   reg       n_sclk_en23;             // out enable for master23 clock23
   reg       n_ss_en23;               // out enable for master23 peripheral23 lines23
  //reg   s from gpio23
   reg    [GPIO_WIDTH23-1:0]     n_gpio_pin_oe23;           // reg    enable signal23 to pin23
   reg    [GPIO_WIDTH23-1:0]     gpio_pin_out23;            // reg    signal23 to pin23


`endif
//------------------------------------------------------------------------------
// black23 boxed23 defines23 
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// APB23 and AHB23 interface formal23 verification23 monitors23
//------------------------------------------------------------------------------
`ifdef ABV_ON23
apb_assert23 i_apb_assert23 (

        // APB23 signals23
  	.n_preset23(n_preset23),
   	.pclk23(pclk23),
	.penable23(penable23),
	.paddr23(paddr23),
	.pwrite23(pwrite23),
	.pwdata23(pwdata23),

	.psel0023(psel_spi23),
	.psel0123(psel_uart023),
	.psel0223(psel_gpio23),
	.psel0323(psel_ttc23),
	.psel0423(1'b0),
	.psel0523(psel_smc23),
	.psel0623(1'b0),
	.psel0723(1'b0),
	.psel0823(1'b0),
	.psel0923(1'b0),
	.psel1023(1'b0),
	.psel1123(1'b0),
	.psel1223(1'b0),
	.psel1323(psel_pmc23),
	.psel1423(psel_apic23),
	.psel1523(psel_uart123),

        .prdata0023(prdata_spi23),
        .prdata0123(prdata_uart023), // Read Data from peripheral23 UART23 
        .prdata0223(prdata_gpio23), // Read Data from peripheral23 GPIO23
        .prdata0323(prdata_ttc23), // Read Data from peripheral23 TTC23
        .prdata0423(32'b0), // 
        .prdata0523(prdata_smc23), // Read Data from peripheral23 SMC23
        .prdata1323(prdata_pmc23), // Read Data from peripheral23 Power23 Control23 Block
   	.prdata1423(32'b0), // 
        .prdata1523(prdata_uart123),


        // AHB23 signals23
        .hclk23(hclk23),         // ahb23 system clock23
        .n_hreset23(n_hreset23), // ahb23 system reset

        // ahb2apb23 signals23
        .hresp23(hresp23),
        .hready23(hready23),
        .hrdata23(hrdata23),
        .hwdata23(hwdata23),
        .hprot23(hprot23),
        .hburst23(hburst23),
        .hsize23(hsize23),
        .hwrite23(hwrite23),
        .htrans23(htrans23),
        .haddr23(haddr23),
        .ahb2apb_hsel23(ahb2apb0_hsel23));



//------------------------------------------------------------------------------
// AHB23 interface formal23 verification23 monitor23
//------------------------------------------------------------------------------
defparam i_ahbSlaveMonitor23.DBUS_WIDTH23 = 32;
defparam i_ahbMasterMonitor23.DBUS_WIDTH23 = 32;


// AHB2APB23 Bridge23

    ahb_liteslave_monitor23 i_ahbSlaveMonitor23 (
        .hclk_i23(hclk23),
        .hresetn_i23(n_hreset23),
        .hresp23(hresp23),
        .hready23(hready23),
        .hready_global_i23(hready23),
        .hrdata23(hrdata23),
        .hwdata_i23(hwdata23),
        .hburst_i23(hburst23),
        .hsize_i23(hsize23),
        .hwrite_i23(hwrite23),
        .htrans_i23(htrans23),
        .haddr_i23(haddr23),
        .hsel_i23(ahb2apb0_hsel23)
    );


  ahb_litemaster_monitor23 i_ahbMasterMonitor23 (
          .hclk_i23(hclk23),
          .hresetn_i23(n_hreset23),
          .hresp_i23(hresp23),
          .hready_i23(hready23),
          .hrdata_i23(hrdata23),
          .hlock23(1'b0),
          .hwdata23(hwdata23),
          .hprot23(hprot23),
          .hburst23(hburst23),
          .hsize23(hsize23),
          .hwrite23(hwrite23),
          .htrans23(htrans23),
          .haddr23(haddr23)
          );







`endif




`ifdef IFV_LP_ABV_ON23
// power23 control23
wire isolate23;

// testbench mirror signals23
wire L1_ctrl_access23;
wire L1_status_access23;

wire [31:0] L1_status_reg23;
wire [31:0] L1_ctrl_reg23;

//wire rstn_non_srpg_urt23;
//wire isolate_urt23;
//wire retain_urt23;
//wire gate_clk_urt23;
//wire pwr1_on_urt23;


// smc23 signals23
wire [31:0] smc_prdata23;
wire lp_clk_smc23;
                    

// uart23 isolation23 register
  wire [15:0] ua_prdata23;
  wire ua_int23;
  assign ua_prdata23          =  i_uart1_veneer23.prdata23;
  assign ua_int23             =  i_uart1_veneer23.ua_int23;


assign lp_clk_smc23          = i_smc_veneer23.pclk23;
assign smc_prdata23          = i_smc_veneer23.prdata23;
lp_chk_smc23 u_lp_chk_smc23 (
    .clk23 (hclk23),
    .rst23 (n_hreset23),
    .iso_smc23 (isolate_smc23),
    .gate_clk23 (gate_clk_smc23),
    .lp_clk23 (pclk_SRPG_smc23),

    // srpg23 outputs23
    .smc_hrdata23 (smc_hrdata23),
    .smc_hready23 (smc_hready23),
    .smc_hresp23  (smc_hresp23),
    .smc_valid23 (smc_valid23),
    .smc_addr_int23 (smc_addr_int23),
    .smc_data23 (smc_data23),
    .smc_n_be23 (smc_n_be23),
    .smc_n_cs23  (smc_n_cs23),
    .smc_n_wr23 (smc_n_wr23),
    .smc_n_we23 (smc_n_we23),
    .smc_n_rd23 (smc_n_rd23),
    .smc_n_ext_oe23 (smc_n_ext_oe23)
   );

// lp23 retention23/isolation23 assertions23
lp_chk_uart23 u_lp_chk_urt23 (

  .clk23         (hclk23),
  .rst23         (n_hreset23),
  .iso_urt23     (isolate_urt23),
  .gate_clk23    (gate_clk_urt23),
  .lp_clk23      (pclk_SRPG_urt23),
  //ports23
  .prdata23 (ua_prdata23),
  .ua_int23 (ua_int23),
  .ua_txd23 (ua_txd123),
  .ua_nrts23 (ua_nrts123)
 );

`endif  //IFV_LP_ABV_ON23




endmodule
