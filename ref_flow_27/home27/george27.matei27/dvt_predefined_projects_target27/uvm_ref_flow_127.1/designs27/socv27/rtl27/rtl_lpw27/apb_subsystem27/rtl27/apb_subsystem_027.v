//File27 name   : apb_subsystem_027.v
//Title27       : 
//Created27     : 1999
//Description27 : 
//Notes27       : 
//----------------------------------------------------------------------
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------

module apb_subsystem_027(
    // AHB27 interface
    hclk27,
    n_hreset27,
    hsel27,
    haddr27,
    htrans27,
    hsize27,
    hwrite27,
    hwdata27,
    hready_in27,
    hburst27,
    hprot27,
    hmaster27,
    hmastlock27,
    hrdata27,
    hready27,
    hresp27,
    
    // APB27 system interface
    pclk27,
    n_preset27,
    
    // SPI27 ports27
    n_ss_in27,
    mi27,
    si27,
    sclk_in27,
    so,
    mo27,
    sclk_out27,
    n_ss_out27,
    n_so_en27,
    n_mo_en27,
    n_sclk_en27,
    n_ss_en27,
    
    //UART027 ports27
    ua_rxd27,
    ua_ncts27,
    ua_txd27,
    ua_nrts27,
    
    //UART127 ports27
    ua_rxd127,
    ua_ncts127,
    ua_txd127,
    ua_nrts127,
    
    //GPIO27 ports27
    gpio_pin_in27,
    n_gpio_pin_oe27,
    gpio_pin_out27,
    

    //SMC27 ports27
    smc_hclk27,
    smc_n_hclk27,
    smc_haddr27,
    smc_htrans27,
    smc_hsel27,
    smc_hwrite27,
    smc_hsize27,
    smc_hwdata27,
    smc_hready_in27,
    smc_hburst27,
    smc_hprot27,
    smc_hmaster27,
    smc_hmastlock27,
    smc_hrdata27, 
    smc_hready27,
    smc_hresp27,
    smc_n_ext_oe27,
    smc_data27,
    smc_addr27,
    smc_n_be27,
    smc_n_cs27, 
    smc_n_we27,
    smc_n_wr27,
    smc_n_rd27,
    data_smc27,
    
    //PMC27 ports27
    clk_SRPG_macb0_en27,
    clk_SRPG_macb1_en27,
    clk_SRPG_macb2_en27,
    clk_SRPG_macb3_en27,
    core06v27,
    core08v27,
    core10v27,
    core12v27,
    macb3_wakeup27,
    macb2_wakeup27,
    macb1_wakeup27,
    macb0_wakeup27,
    mte_smc_start27,
    mte_uart_start27,
    mte_smc_uart_start27,  
    mte_pm_smc_to_default_start27, 
    mte_pm_uart_to_default_start27,
    mte_pm_smc_uart_to_default_start27,
    
    
    // Peripheral27 inerrupts27
    pcm_irq27,
    ttc_irq27,
    gpio_irq27,
    uart0_irq27,
    uart1_irq27,
    spi_irq27,
    DMA_irq27,      
    macb0_int27,
    macb1_int27,
    macb2_int27,
    macb3_int27,
   
    // Scan27 ports27
    scan_en27,      // Scan27 enable pin27
    scan_in_127,    // Scan27 input for first chain27
    scan_in_227,    // Scan27 input for second chain27
    scan_mode27,
    scan_out_127,   // Scan27 out for chain27 1
    scan_out_227    // Scan27 out for chain27 2
);

parameter GPIO_WIDTH27 = 16;        // GPIO27 width
parameter P_SIZE27 =   8;              // number27 of peripheral27 select27 lines27
parameter NO_OF_IRQS27  = 17;      //No of irqs27 read by apic27 

// AHB27 interface
input         hclk27;     // AHB27 Clock27
input         n_hreset27;  // AHB27 reset - Active27 low27
input         hsel27;     // AHB2APB27 select27
input [31:0]  haddr27;    // Address bus
input [1:0]   htrans27;   // Transfer27 type
input [2:0]   hsize27;    // AHB27 Access type - byte, half27-word27, word27
input [31:0]  hwdata27;   // Write data
input         hwrite27;   // Write signal27/
input         hready_in27;// Indicates27 that last master27 has finished27 bus access
input [2:0]   hburst27;     // Burst type
input [3:0]   hprot27;      // Protection27 control27
input [3:0]   hmaster27;    // Master27 select27
input         hmastlock27;  // Locked27 transfer27
output [31:0] hrdata27;       // Read data provided from target slave27
output        hready27;       // Ready27 for new bus cycle from target slave27
output [1:0]  hresp27;       // Response27 from the bridge27
    
// APB27 system interface
input         pclk27;     // APB27 Clock27. 
input         n_preset27;  // APB27 reset - Active27 low27
   
// SPI27 ports27
input     n_ss_in27;      // select27 input to slave27
input     mi27;           // data input to master27
input     si27;           // data input to slave27
input     sclk_in27;      // clock27 input to slave27
output    so;                    // data output from slave27
output    mo27;                    // data output from master27
output    sclk_out27;              // clock27 output from master27
output [P_SIZE27-1:0] n_ss_out27;    // peripheral27 select27 lines27 from master27
output    n_so_en27;               // out enable for slave27 data
output    n_mo_en27;               // out enable for master27 data
output    n_sclk_en27;             // out enable for master27 clock27
output    n_ss_en27;               // out enable for master27 peripheral27 lines27

//UART027 ports27
input        ua_rxd27;       // UART27 receiver27 serial27 input pin27
input        ua_ncts27;      // Clear-To27-Send27 flow27 control27
output       ua_txd27;       	// UART27 transmitter27 serial27 output
output       ua_nrts27;      	// Request27-To27-Send27 flow27 control27

// UART127 ports27   
input        ua_rxd127;      // UART27 receiver27 serial27 input pin27
input        ua_ncts127;      // Clear-To27-Send27 flow27 control27
output       ua_txd127;       // UART27 transmitter27 serial27 output
output       ua_nrts127;      // Request27-To27-Send27 flow27 control27

//GPIO27 ports27
input [GPIO_WIDTH27-1:0]      gpio_pin_in27;             // input data from pin27
output [GPIO_WIDTH27-1:0]     n_gpio_pin_oe27;           // output enable signal27 to pin27
output [GPIO_WIDTH27-1:0]     gpio_pin_out27;            // output signal27 to pin27
  
//SMC27 ports27
input        smc_hclk27;
input        smc_n_hclk27;
input [31:0] smc_haddr27;
input [1:0]  smc_htrans27;
input        smc_hsel27;
input        smc_hwrite27;
input [2:0]  smc_hsize27;
input [31:0] smc_hwdata27;
input        smc_hready_in27;
input [2:0]  smc_hburst27;     // Burst type
input [3:0]  smc_hprot27;      // Protection27 control27
input [3:0]  smc_hmaster27;    // Master27 select27
input        smc_hmastlock27;  // Locked27 transfer27
input [31:0] data_smc27;     // EMI27(External27 memory) read data
output [31:0]    smc_hrdata27;
output           smc_hready27;
output [1:0]     smc_hresp27;
output [15:0]    smc_addr27;      // External27 Memory (EMI27) address
output [3:0]     smc_n_be27;      // EMI27 byte enables27 (Active27 LOW27)
output           smc_n_cs27;      // EMI27 Chip27 Selects27 (Active27 LOW27)
output [3:0]     smc_n_we27;      // EMI27 write strobes27 (Active27 LOW27)
output           smc_n_wr27;      // EMI27 write enable (Active27 LOW27)
output           smc_n_rd27;      // EMI27 read stobe27 (Active27 LOW27)
output           smc_n_ext_oe27;  // EMI27 write data output enable
output [31:0]    smc_data27;      // EMI27 write data
       
//PMC27 ports27
output clk_SRPG_macb0_en27;
output clk_SRPG_macb1_en27;
output clk_SRPG_macb2_en27;
output clk_SRPG_macb3_en27;
output core06v27;
output core08v27;
output core10v27;
output core12v27;
output mte_smc_start27;
output mte_uart_start27;
output mte_smc_uart_start27;  
output mte_pm_smc_to_default_start27; 
output mte_pm_uart_to_default_start27;
output mte_pm_smc_uart_to_default_start27;
input macb3_wakeup27;
input macb2_wakeup27;
input macb1_wakeup27;
input macb0_wakeup27;
    

// Peripheral27 interrupts27
output pcm_irq27;
output [2:0] ttc_irq27;
output gpio_irq27;
output uart0_irq27;
output uart1_irq27;
output spi_irq27;
input        macb0_int27;
input        macb1_int27;
input        macb2_int27;
input        macb3_int27;
input        DMA_irq27;
  
//Scan27 ports27
input        scan_en27;    // Scan27 enable pin27
input        scan_in_127;  // Scan27 input for first chain27
input        scan_in_227;  // Scan27 input for second chain27
input        scan_mode27;  // test mode pin27
 output        scan_out_127;   // Scan27 out for chain27 1
 output        scan_out_227;   // Scan27 out for chain27 2  

//------------------------------------------------------------------------------
// if the ROM27 subsystem27 is NOT27 black27 boxed27 
//------------------------------------------------------------------------------
`ifndef FV_KIT_BLACK_BOX_APB_SUBSYSTEM27
   
   wire        hsel27; 
   wire        pclk27;
   wire        n_preset27;
   wire [31:0] prdata_spi27;
   wire [31:0] prdata_uart027;
   wire [31:0] prdata_gpio27;
   wire [31:0] prdata_ttc27;
   wire [31:0] prdata_smc27;
   wire [31:0] prdata_pmc27;
   wire [31:0] prdata_uart127;
   wire        pready_spi27;
   wire        pready_uart027;
   wire        pready_uart127;
   wire        tie_hi_bit27;
   wire  [31:0] hrdata27; 
   wire         hready27;
   wire         hready_in27;
   wire  [1:0]  hresp27;   
   wire  [31:0] pwdata27;  
   wire         pwrite27;
   wire  [31:0] paddr27;  
   wire   psel_spi27;
   wire   psel_uart027;
   wire   psel_gpio27;
   wire   psel_ttc27;
   wire   psel_smc27;
   wire   psel0727;
   wire   psel0827;
   wire   psel0927;
   wire   psel1027;
   wire   psel1127;
   wire   psel1227;
   wire   psel_pmc27;
   wire   psel_uart127;
   wire   penable27;
   wire   [NO_OF_IRQS27:0] int_source27;     // System27 Interrupt27 Sources27
   wire [1:0]             smc_hresp27;     // AHB27 Response27 signal27
   wire                   smc_valid27;     // Ack27 valid address

  //External27 memory interface (EMI27)
  wire [31:0]            smc_addr_int27;  // External27 Memory (EMI27) address
  wire [3:0]             smc_n_be27;      // EMI27 byte enables27 (Active27 LOW27)
  wire                   smc_n_cs27;      // EMI27 Chip27 Selects27 (Active27 LOW27)
  wire [3:0]             smc_n_we27;      // EMI27 write strobes27 (Active27 LOW27)
  wire                   smc_n_wr27;      // EMI27 write enable (Active27 LOW27)
  wire                   smc_n_rd27;      // EMI27 read stobe27 (Active27 LOW27)
 
  //AHB27 Memory Interface27 Control27
  wire                   smc_hsel_int27;
  wire                   smc_busy27;      // smc27 busy
   

//scan27 signals27

   wire                scan_in_127;        //scan27 input
   wire                scan_in_227;        //scan27 input
   wire                scan_en27;         //scan27 enable
   wire                scan_out_127;       //scan27 output
   wire                scan_out_227;       //scan27 output
   wire                byte_sel27;     // byte select27 from bridge27 1=byte, 0=2byte
   wire                UART_int27;     // UART27 module interrupt27 
   wire                ua_uclken27;    // Soft27 control27 of clock27
   wire                UART_int127;     // UART27 module interrupt27 
   wire                ua_uclken127;    // Soft27 control27 of clock27
   wire  [3:1]         TTC_int27;            //Interrupt27 from PCI27 
  // inputs27 to SPI27 
   wire    ext_clk27;                // external27 clock27
   wire    SPI_int27;             // interrupt27 request
  // outputs27 from SPI27
   wire    slave_out_clk27;         // modified slave27 clock27 output
 // gpio27 generic27 inputs27 
   wire  [GPIO_WIDTH27-1:0]   n_gpio_bypass_oe27;        // bypass27 mode enable 
   wire  [GPIO_WIDTH27-1:0]   gpio_bypass_out27;         // bypass27 mode output value 
   wire  [GPIO_WIDTH27-1:0]   tri_state_enable27;   // disables27 op enable -> z 
 // outputs27 
   //amba27 outputs27 
   // gpio27 generic27 outputs27 
   wire       GPIO_int27;                // gpio_interupt27 for input pin27 change 
   wire [GPIO_WIDTH27-1:0]     gpio_bypass_in27;          // bypass27 mode input data value  
                
   wire           cpu_debug27;        // Inhibits27 watchdog27 counter 
   wire            ex_wdz_n27;         // External27 Watchdog27 zero indication27
   wire           rstn_non_srpg_smc27; 
   wire           rstn_non_srpg_urt27;
   wire           isolate_smc27;
   wire           save_edge_smc27;
   wire           restore_edge_smc27;
   wire           save_edge_urt27;
   wire           restore_edge_urt27;
   wire           pwr1_on_smc27;
   wire           pwr2_on_smc27;
   wire           pwr1_on_urt27;
   wire           pwr2_on_urt27;
   // ETH027
   wire            rstn_non_srpg_macb027;
   wire            gate_clk_macb027;
   wire            isolate_macb027;
   wire            save_edge_macb027;
   wire            restore_edge_macb027;
   wire            pwr1_on_macb027;
   wire            pwr2_on_macb027;
   // ETH127
   wire            rstn_non_srpg_macb127;
   wire            gate_clk_macb127;
   wire            isolate_macb127;
   wire            save_edge_macb127;
   wire            restore_edge_macb127;
   wire            pwr1_on_macb127;
   wire            pwr2_on_macb127;
   // ETH227
   wire            rstn_non_srpg_macb227;
   wire            gate_clk_macb227;
   wire            isolate_macb227;
   wire            save_edge_macb227;
   wire            restore_edge_macb227;
   wire            pwr1_on_macb227;
   wire            pwr2_on_macb227;
   // ETH327
   wire            rstn_non_srpg_macb327;
   wire            gate_clk_macb327;
   wire            isolate_macb327;
   wire            save_edge_macb327;
   wire            restore_edge_macb327;
   wire            pwr1_on_macb327;
   wire            pwr2_on_macb327;


   wire           pclk_SRPG_smc27;
   wire           pclk_SRPG_urt27;
   wire           gate_clk_smc27;
   wire           gate_clk_urt27;
   wire  [31:0]   tie_lo_32bit27; 
   wire  [1:0]	  tie_lo_2bit27;
   wire  	  tie_lo_1bit27;
   wire           pcm_macb_wakeup_int27;
   wire           int_source_h27;
   wire           isolate_mem27;

assign pcm_irq27 = pcm_macb_wakeup_int27;
assign ttc_irq27[2] = TTC_int27[3];
assign ttc_irq27[1] = TTC_int27[2];
assign ttc_irq27[0] = TTC_int27[1];
assign gpio_irq27 = GPIO_int27;
assign uart0_irq27 = UART_int27;
assign uart1_irq27 = UART_int127;
assign spi_irq27 = SPI_int27;

assign n_mo_en27   = 1'b0;
assign n_so_en27   = 1'b1;
assign n_sclk_en27 = 1'b0;
assign n_ss_en27   = 1'b0;

assign smc_hsel_int27 = smc_hsel27;
  assign ext_clk27  = 1'b0;
  assign int_source27 = {macb0_int27,macb1_int27, macb2_int27, macb3_int27,1'b0, pcm_macb_wakeup_int27, 1'b0, 1'b0, 1'b0, 1'b0, TTC_int27, GPIO_int27, UART_int27, UART_int127, SPI_int27, DMA_irq27};

  // interrupt27 even27 detect27 .
  // for sleep27 wake27 up -> any interrupt27 even27 and system not in hibernation27 (isolate_mem27 = 0)
  // for hibernate27 wake27 up -> gpio27 interrupt27 even27 and system in the hibernation27 (isolate_mem27 = 1)
  assign int_source_h27 =  ((|int_source27) && (!isolate_mem27)) || (isolate_mem27 && GPIO_int27) ;

  assign byte_sel27 = 1'b1;
  assign tie_hi_bit27 = 1'b1;

  assign smc_addr27 = smc_addr_int27[15:0];



  assign  n_gpio_bypass_oe27 = {GPIO_WIDTH27{1'b0}};        // bypass27 mode enable 
  assign  gpio_bypass_out27  = {GPIO_WIDTH27{1'b0}};
  assign  tri_state_enable27 = {GPIO_WIDTH27{1'b0}};
  assign  cpu_debug27 = 1'b0;
  assign  tie_lo_32bit27 = 32'b0;
  assign  tie_lo_2bit27  = 2'b0;
  assign  tie_lo_1bit27  = 1'b0;


ahb2apb27 #(
  32'h00800000, // Slave27 0 Address Range27
  32'h0080FFFF,

  32'h00810000, // Slave27 1 Address Range27
  32'h0081FFFF,

  32'h00820000, // Slave27 2 Address Range27 
  32'h0082FFFF,

  32'h00830000, // Slave27 3 Address Range27
  32'h0083FFFF,

  32'h00840000, // Slave27 4 Address Range27
  32'h0084FFFF,

  32'h00850000, // Slave27 5 Address Range27
  32'h0085FFFF,

  32'h00860000, // Slave27 6 Address Range27
  32'h0086FFFF,

  32'h00870000, // Slave27 7 Address Range27
  32'h0087FFFF,

  32'h00880000, // Slave27 8 Address Range27
  32'h0088FFFF
) i_ahb2apb27 (
     // AHB27 interface
    .hclk27(hclk27),         
    .hreset_n27(n_hreset27), 
    .hsel27(hsel27), 
    .haddr27(haddr27),        
    .htrans27(htrans27),       
    .hwrite27(hwrite27),       
    .hwdata27(hwdata27),       
    .hrdata27(hrdata27),   
    .hready27(hready27),   
    .hresp27(hresp27),     
    
     // APB27 interface
    .pclk27(pclk27),         
    .preset_n27(n_preset27),  
    .prdata027(prdata_spi27),
    .prdata127(prdata_uart027), 
    .prdata227(prdata_gpio27),  
    .prdata327(prdata_ttc27),   
    .prdata427(32'h0),   
    .prdata527(prdata_smc27),   
    .prdata627(prdata_pmc27),    
    .prdata727(32'h0),   
    .prdata827(prdata_uart127),  
    .pready027(pready_spi27),     
    .pready127(pready_uart027),   
    .pready227(tie_hi_bit27),     
    .pready327(tie_hi_bit27),     
    .pready427(tie_hi_bit27),     
    .pready527(tie_hi_bit27),     
    .pready627(tie_hi_bit27),     
    .pready727(tie_hi_bit27),     
    .pready827(pready_uart127),  
    .pwdata27(pwdata27),       
    .pwrite27(pwrite27),       
    .paddr27(paddr27),        
    .psel027(psel_spi27),     
    .psel127(psel_uart027),   
    .psel227(psel_gpio27),    
    .psel327(psel_ttc27),     
    .psel427(),     
    .psel527(psel_smc27),     
    .psel627(psel_pmc27),    
    .psel727(psel_apic27),   
    .psel827(psel_uart127),  
    .penable27(penable27)     
);

spi_top27 i_spi27
(
  // Wishbone27 signals27
  .wb_clk_i27(pclk27), 
  .wb_rst_i27(~n_preset27), 
  .wb_adr_i27(paddr27[4:0]), 
  .wb_dat_i27(pwdata27), 
  .wb_dat_o27(prdata_spi27), 
  .wb_sel_i27(4'b1111),    // SPI27 register accesses are always 32-bit
  .wb_we_i27(pwrite27), 
  .wb_stb_i27(psel_spi27), 
  .wb_cyc_i27(psel_spi27), 
  .wb_ack_o27(pready_spi27), 
  .wb_err_o27(), 
  .wb_int_o27(SPI_int27),

  // SPI27 signals27
  .ss_pad_o27(n_ss_out27), 
  .sclk_pad_o27(sclk_out27), 
  .mosi_pad_o27(mo27), 
  .miso_pad_i27(mi27)
);

// Opencores27 UART27 instances27
wire ua_nrts_int27;
wire ua_nrts1_int27;

assign ua_nrts27 = ua_nrts_int27;
assign ua_nrts127 = ua_nrts1_int27;

reg [3:0] uart0_sel_i27;
reg [3:0] uart1_sel_i27;
// UART27 registers are all 8-bit wide27, and their27 addresses27
// are on byte boundaries27. So27 to access them27 on the
// Wishbone27 bus, the CPU27 must do byte accesses to these27
// byte addresses27. Word27 address accesses are not possible27
// because the word27 addresses27 will be unaligned27, and cause
// a fault27.
// So27, Uart27 accesses from the CPU27 will always be 8-bit size
// We27 only have to decide27 which byte of the 4-byte word27 the
// CPU27 is interested27 in.
`ifdef SYSTEM_BIG_ENDIAN27
always @(paddr27) begin
  case (paddr27[1:0])
    2'b00 : uart0_sel_i27 = 4'b1000;
    2'b01 : uart0_sel_i27 = 4'b0100;
    2'b10 : uart0_sel_i27 = 4'b0010;
    2'b11 : uart0_sel_i27 = 4'b0001;
  endcase
end
always @(paddr27) begin
  case (paddr27[1:0])
    2'b00 : uart1_sel_i27 = 4'b1000;
    2'b01 : uart1_sel_i27 = 4'b0100;
    2'b10 : uart1_sel_i27 = 4'b0010;
    2'b11 : uart1_sel_i27 = 4'b0001;
  endcase
end
`else
always @(paddr27) begin
  case (paddr27[1:0])
    2'b00 : uart0_sel_i27 = 4'b0001;
    2'b01 : uart0_sel_i27 = 4'b0010;
    2'b10 : uart0_sel_i27 = 4'b0100;
    2'b11 : uart0_sel_i27 = 4'b1000;
  endcase
end
always @(paddr27) begin
  case (paddr27[1:0])
    2'b00 : uart1_sel_i27 = 4'b0001;
    2'b01 : uart1_sel_i27 = 4'b0010;
    2'b10 : uart1_sel_i27 = 4'b0100;
    2'b11 : uart1_sel_i27 = 4'b1000;
  endcase
end
`endif

uart_top27 i_oc_uart027 (
  .wb_clk_i27(pclk27),
  .wb_rst_i27(~n_preset27),
  .wb_adr_i27(paddr27[4:0]),
  .wb_dat_i27(pwdata27),
  .wb_dat_o27(prdata_uart027),
  .wb_we_i27(pwrite27),
  .wb_stb_i27(psel_uart027),
  .wb_cyc_i27(psel_uart027),
  .wb_ack_o27(pready_uart027),
  .wb_sel_i27(uart0_sel_i27),
  .int_o27(UART_int27),
  .stx_pad_o27(ua_txd27),
  .srx_pad_i27(ua_rxd27),
  .rts_pad_o27(ua_nrts_int27),
  .cts_pad_i27(ua_ncts27),
  .dtr_pad_o27(),
  .dsr_pad_i27(1'b0),
  .ri_pad_i27(1'b0),
  .dcd_pad_i27(1'b0)
);

uart_top27 i_oc_uart127 (
  .wb_clk_i27(pclk27),
  .wb_rst_i27(~n_preset27),
  .wb_adr_i27(paddr27[4:0]),
  .wb_dat_i27(pwdata27),
  .wb_dat_o27(prdata_uart127),
  .wb_we_i27(pwrite27),
  .wb_stb_i27(psel_uart127),
  .wb_cyc_i27(psel_uart127),
  .wb_ack_o27(pready_uart127),
  .wb_sel_i27(uart1_sel_i27),
  .int_o27(UART_int127),
  .stx_pad_o27(ua_txd127),
  .srx_pad_i27(ua_rxd127),
  .rts_pad_o27(ua_nrts1_int27),
  .cts_pad_i27(ua_ncts127),
  .dtr_pad_o27(),
  .dsr_pad_i27(1'b0),
  .ri_pad_i27(1'b0),
  .dcd_pad_i27(1'b0)
);

gpio_veneer27 i_gpio_veneer27 (
        //inputs27

        . n_p_reset27(n_preset27),
        . pclk27(pclk27),
        . psel27(psel_gpio27),
        . penable27(penable27),
        . pwrite27(pwrite27),
        . paddr27(paddr27[5:0]),
        . pwdata27(pwdata27),
        . gpio_pin_in27(gpio_pin_in27),
        . scan_en27(scan_en27),
        . tri_state_enable27(tri_state_enable27),
        . scan_in27(), //added by smarkov27 for dft27

        //outputs27
        . scan_out27(), //added by smarkov27 for dft27
        . prdata27(prdata_gpio27),
        . gpio_int27(GPIO_int27),
        . n_gpio_pin_oe27(n_gpio_pin_oe27),
        . gpio_pin_out27(gpio_pin_out27)
);


ttc_veneer27 i_ttc_veneer27 (

         //inputs27
        . n_p_reset27(n_preset27),
        . pclk27(pclk27),
        . psel27(psel_ttc27),
        . penable27(penable27),
        . pwrite27(pwrite27),
        . pwdata27(pwdata27),
        . paddr27(paddr27[7:0]),
        . scan_in27(),
        . scan_en27(scan_en27),

        //outputs27
        . prdata27(prdata_ttc27),
        . interrupt27(TTC_int27[3:1]),
        . scan_out27()
);


smc_veneer27 i_smc_veneer27 (
        //inputs27
	//apb27 inputs27
        . n_preset27(n_preset27),
        . pclk27(pclk_SRPG_smc27),
        . psel27(psel_smc27),
        . penable27(penable27),
        . pwrite27(pwrite27),
        . paddr27(paddr27[4:0]),
        . pwdata27(pwdata27),
        //ahb27 inputs27
	. hclk27(smc_hclk27),
        . n_sys_reset27(rstn_non_srpg_smc27),
        . haddr27(smc_haddr27),
        . htrans27(smc_htrans27),
        . hsel27(smc_hsel_int27),
        . hwrite27(smc_hwrite27),
	. hsize27(smc_hsize27),
        . hwdata27(smc_hwdata27),
        . hready27(smc_hready_in27),
        . data_smc27(data_smc27),

         //test signal27 inputs27

        . scan_in_127(),
        . scan_in_227(),
        . scan_in_327(),
        . scan_en27(scan_en27),

        //apb27 outputs27
        . prdata27(prdata_smc27),

       //design output

        . smc_hrdata27(smc_hrdata27),
        . smc_hready27(smc_hready27),
        . smc_hresp27(smc_hresp27),
        . smc_valid27(smc_valid27),
        . smc_addr27(smc_addr_int27),
        . smc_data27(smc_data27),
        . smc_n_be27(smc_n_be27),
        . smc_n_cs27(smc_n_cs27),
        . smc_n_wr27(smc_n_wr27),
        . smc_n_we27(smc_n_we27),
        . smc_n_rd27(smc_n_rd27),
        . smc_n_ext_oe27(smc_n_ext_oe27),
        . smc_busy27(smc_busy27),

         //test signal27 output
        . scan_out_127(),
        . scan_out_227(),
        . scan_out_327()
);

power_ctrl_veneer27 i_power_ctrl_veneer27 (
    // -- Clocks27 & Reset27
    	.pclk27(pclk27), 			//  : in  std_logic27;
    	.nprst27(n_preset27), 		//  : in  std_logic27;
    // -- APB27 programming27 interface
    	.paddr27(paddr27), 			//  : in  std_logic_vector27(31 downto27 0);
    	.psel27(psel_pmc27), 			//  : in  std_logic27;
    	.penable27(penable27), 		//  : in  std_logic27;
    	.pwrite27(pwrite27), 		//  : in  std_logic27;
    	.pwdata27(pwdata27), 		//  : in  std_logic_vector27(31 downto27 0);
    	.prdata27(prdata_pmc27), 		//  : out std_logic_vector27(31 downto27 0);
        .macb3_wakeup27(macb3_wakeup27),
        .macb2_wakeup27(macb2_wakeup27),
        .macb1_wakeup27(macb1_wakeup27),
        .macb0_wakeup27(macb0_wakeup27),
    // -- Module27 control27 outputs27
    	.scan_in27(),			//  : in  std_logic27;
    	.scan_en27(scan_en27),             	//  : in  std_logic27;
    	.scan_mode27(scan_mode27),          //  : in  std_logic27;
    	.scan_out27(),            	//  : out std_logic27;
        .int_source_h27(int_source_h27),
     	.rstn_non_srpg_smc27(rstn_non_srpg_smc27), 		//   : out std_logic27;
    	.gate_clk_smc27(gate_clk_smc27), 	//  : out std_logic27;
    	.isolate_smc27(isolate_smc27), 	//  : out std_logic27;
    	.save_edge_smc27(save_edge_smc27), 	//  : out std_logic27;
    	.restore_edge_smc27(restore_edge_smc27), 	//  : out std_logic27;
    	.pwr1_on_smc27(pwr1_on_smc27), 	//  : out std_logic27;
    	.pwr2_on_smc27(pwr2_on_smc27), 	//  : out std_logic27
     	.rstn_non_srpg_urt27(rstn_non_srpg_urt27), 		//   : out std_logic27;
    	.gate_clk_urt27(gate_clk_urt27), 	//  : out std_logic27;
    	.isolate_urt27(isolate_urt27), 	//  : out std_logic27;
    	.save_edge_urt27(save_edge_urt27), 	//  : out std_logic27;
    	.restore_edge_urt27(restore_edge_urt27), 	//  : out std_logic27;
    	.pwr1_on_urt27(pwr1_on_urt27), 	//  : out std_logic27;
    	.pwr2_on_urt27(pwr2_on_urt27),  	//  : out std_logic27
        // ETH027
        .rstn_non_srpg_macb027(rstn_non_srpg_macb027),
        .gate_clk_macb027(gate_clk_macb027),
        .isolate_macb027(isolate_macb027),
        .save_edge_macb027(save_edge_macb027),
        .restore_edge_macb027(restore_edge_macb027),
        .pwr1_on_macb027(pwr1_on_macb027),
        .pwr2_on_macb027(pwr2_on_macb027),
        // ETH127
        .rstn_non_srpg_macb127(rstn_non_srpg_macb127),
        .gate_clk_macb127(gate_clk_macb127),
        .isolate_macb127(isolate_macb127),
        .save_edge_macb127(save_edge_macb127),
        .restore_edge_macb127(restore_edge_macb127),
        .pwr1_on_macb127(pwr1_on_macb127),
        .pwr2_on_macb127(pwr2_on_macb127),
        // ETH227
        .rstn_non_srpg_macb227(rstn_non_srpg_macb227),
        .gate_clk_macb227(gate_clk_macb227),
        .isolate_macb227(isolate_macb227),
        .save_edge_macb227(save_edge_macb227),
        .restore_edge_macb227(restore_edge_macb227),
        .pwr1_on_macb227(pwr1_on_macb227),
        .pwr2_on_macb227(pwr2_on_macb227),
        // ETH327
        .rstn_non_srpg_macb327(rstn_non_srpg_macb327),
        .gate_clk_macb327(gate_clk_macb327),
        .isolate_macb327(isolate_macb327),
        .save_edge_macb327(save_edge_macb327),
        .restore_edge_macb327(restore_edge_macb327),
        .pwr1_on_macb327(pwr1_on_macb327),
        .pwr2_on_macb327(pwr2_on_macb327),
        .core06v27(core06v27),
        .core08v27(core08v27),
        .core10v27(core10v27),
        .core12v27(core12v27),
        .pcm_macb_wakeup_int27(pcm_macb_wakeup_int27),
        .isolate_mem27(isolate_mem27),
        .mte_smc_start27(mte_smc_start27),
        .mte_uart_start27(mte_uart_start27),
        .mte_smc_uart_start27(mte_smc_uart_start27),  
        .mte_pm_smc_to_default_start27(mte_pm_smc_to_default_start27), 
        .mte_pm_uart_to_default_start27(mte_pm_uart_to_default_start27),
        .mte_pm_smc_uart_to_default_start27(mte_pm_smc_uart_to_default_start27)
);

// Clock27 gating27 macro27 to shut27 off27 clocks27 to the SRPG27 flops27 in the SMC27
//CKLNQD127 i_SMC_SRPG_clk_gate27  (
//	.TE27(scan_mode27), 
//	.E27(~gate_clk_smc27), 
//	.CP27(pclk27), 
//	.Q27(pclk_SRPG_smc27)
//	);
// Replace27 gate27 with behavioural27 code27 //
wire 	smc_scan_gate27;
reg 	smc_latched_enable27;
assign smc_scan_gate27 = scan_mode27 ? 1'b1 : ~gate_clk_smc27;

always @ (pclk27 or smc_scan_gate27)
  	if (pclk27 == 1'b0) begin
  		smc_latched_enable27 <= smc_scan_gate27;
  	end  	
	
assign pclk_SRPG_smc27 = smc_latched_enable27 ? pclk27 : 1'b0;


// Clock27 gating27 macro27 to shut27 off27 clocks27 to the SRPG27 flops27 in the URT27
//CKLNQD127 i_URT_SRPG_clk_gate27  (
//	.TE27(scan_mode27), 
//	.E27(~gate_clk_urt27), 
//	.CP27(pclk27), 
//	.Q27(pclk_SRPG_urt27)
//	);
// Replace27 gate27 with behavioural27 code27 //
wire 	urt_scan_gate27;
reg 	urt_latched_enable27;
assign urt_scan_gate27 = scan_mode27 ? 1'b1 : ~gate_clk_urt27;

always @ (pclk27 or urt_scan_gate27)
  	if (pclk27 == 1'b0) begin
  		urt_latched_enable27 <= urt_scan_gate27;
  	end  	
	
assign pclk_SRPG_urt27 = urt_latched_enable27 ? pclk27 : 1'b0;

// ETH027
wire 	macb0_scan_gate27;
reg 	macb0_latched_enable27;
assign macb0_scan_gate27 = scan_mode27 ? 1'b1 : ~gate_clk_macb027;

always @ (pclk27 or macb0_scan_gate27)
  	if (pclk27 == 1'b0) begin
  		macb0_latched_enable27 <= macb0_scan_gate27;
  	end  	
	
assign clk_SRPG_macb0_en27 = macb0_latched_enable27 ? 1'b1 : 1'b0;

// ETH127
wire 	macb1_scan_gate27;
reg 	macb1_latched_enable27;
assign macb1_scan_gate27 = scan_mode27 ? 1'b1 : ~gate_clk_macb127;

always @ (pclk27 or macb1_scan_gate27)
  	if (pclk27 == 1'b0) begin
  		macb1_latched_enable27 <= macb1_scan_gate27;
  	end  	
	
assign clk_SRPG_macb1_en27 = macb1_latched_enable27 ? 1'b1 : 1'b0;

// ETH227
wire 	macb2_scan_gate27;
reg 	macb2_latched_enable27;
assign macb2_scan_gate27 = scan_mode27 ? 1'b1 : ~gate_clk_macb227;

always @ (pclk27 or macb2_scan_gate27)
  	if (pclk27 == 1'b0) begin
  		macb2_latched_enable27 <= macb2_scan_gate27;
  	end  	
	
assign clk_SRPG_macb2_en27 = macb2_latched_enable27 ? 1'b1 : 1'b0;

// ETH327
wire 	macb3_scan_gate27;
reg 	macb3_latched_enable27;
assign macb3_scan_gate27 = scan_mode27 ? 1'b1 : ~gate_clk_macb327;

always @ (pclk27 or macb3_scan_gate27)
  	if (pclk27 == 1'b0) begin
  		macb3_latched_enable27 <= macb3_scan_gate27;
  	end  	
	
assign clk_SRPG_macb3_en27 = macb3_latched_enable27 ? 1'b1 : 1'b0;



`else
//------------------------------------------------------------------------------
// if the APB27 subsystem27 is black27 boxed27 
//------------------------------------------------------------------------------
// wire s ports27
    // system signals27
    wire         hclk27;     // AHB27 Clock27
    wire         n_hreset27;  // AHB27 reset - Active27 low27
    wire         pclk27;     // APB27 Clock27. 
    wire         n_preset27;  // APB27 reset - Active27 low27

    // AHB27 interface
    wire         ahb2apb0_hsel27;     // AHB2APB27 select27
    wire  [31:0] haddr27;    // Address bus
    wire  [1:0]  htrans27;   // Transfer27 type
    wire  [2:0]  hsize27;    // AHB27 Access type - byte, half27-word27, word27
    wire  [31:0] hwdata27;   // Write data
    wire         hwrite27;   // Write signal27/
    wire         hready_in27;// Indicates27 that last master27 has finished27 bus access
    wire [2:0]   hburst27;     // Burst type
    wire [3:0]   hprot27;      // Protection27 control27
    wire [3:0]   hmaster27;    // Master27 select27
    wire         hmastlock27;  // Locked27 transfer27
  // Interrupts27 from the Enet27 MACs27
    wire         macb0_int27;
    wire         macb1_int27;
    wire         macb2_int27;
    wire         macb3_int27;
  // Interrupt27 from the DMA27
    wire         DMA_irq27;
  // Scan27 wire s
    wire         scan_en27;    // Scan27 enable pin27
    wire         scan_in_127;  // Scan27 wire  for first chain27
    wire         scan_in_227;  // Scan27 wire  for second chain27
    wire         scan_mode27;  // test mode pin27
 
  //wire  for smc27 AHB27 interface
    wire         smc_hclk27;
    wire         smc_n_hclk27;
    wire  [31:0] smc_haddr27;
    wire  [1:0]  smc_htrans27;
    wire         smc_hsel27;
    wire         smc_hwrite27;
    wire  [2:0]  smc_hsize27;
    wire  [31:0] smc_hwdata27;
    wire         smc_hready_in27;
    wire  [2:0]  smc_hburst27;     // Burst type
    wire  [3:0]  smc_hprot27;      // Protection27 control27
    wire  [3:0]  smc_hmaster27;    // Master27 select27
    wire         smc_hmastlock27;  // Locked27 transfer27


    wire  [31:0] data_smc27;     // EMI27(External27 memory) read data
    
  //wire s for uart27
    wire         ua_rxd27;       // UART27 receiver27 serial27 wire  pin27
    wire         ua_rxd127;      // UART27 receiver27 serial27 wire  pin27
    wire         ua_ncts27;      // Clear-To27-Send27 flow27 control27
    wire         ua_ncts127;      // Clear-To27-Send27 flow27 control27
   //wire s for spi27
    wire         n_ss_in27;      // select27 wire  to slave27
    wire         mi27;           // data wire  to master27
    wire         si27;           // data wire  to slave27
    wire         sclk_in27;      // clock27 wire  to slave27
  //wire s for GPIO27
   wire  [GPIO_WIDTH27-1:0]  gpio_pin_in27;             // wire  data from pin27

  //reg    ports27
  // Scan27 reg   s
   reg           scan_out_127;   // Scan27 out for chain27 1
   reg           scan_out_227;   // Scan27 out for chain27 2
  //AHB27 interface 
   reg    [31:0] hrdata27;       // Read data provided from target slave27
   reg           hready27;       // Ready27 for new bus cycle from target slave27
   reg    [1:0]  hresp27;       // Response27 from the bridge27

   // SMC27 reg    for AHB27 interface
   reg    [31:0]    smc_hrdata27;
   reg              smc_hready27;
   reg    [1:0]     smc_hresp27;

  //reg   s from smc27
   reg    [15:0]    smc_addr27;      // External27 Memory (EMI27) address
   reg    [3:0]     smc_n_be27;      // EMI27 byte enables27 (Active27 LOW27)
   reg    [7:0]     smc_n_cs27;      // EMI27 Chip27 Selects27 (Active27 LOW27)
   reg    [3:0]     smc_n_we27;      // EMI27 write strobes27 (Active27 LOW27)
   reg              smc_n_wr27;      // EMI27 write enable (Active27 LOW27)
   reg              smc_n_rd27;      // EMI27 read stobe27 (Active27 LOW27)
   reg              smc_n_ext_oe27;  // EMI27 write data reg    enable
   reg    [31:0]    smc_data27;      // EMI27 write data
  //reg   s from uart27
   reg           ua_txd27;       	// UART27 transmitter27 serial27 reg   
   reg           ua_txd127;       // UART27 transmitter27 serial27 reg   
   reg           ua_nrts27;      	// Request27-To27-Send27 flow27 control27
   reg           ua_nrts127;      // Request27-To27-Send27 flow27 control27
   // reg   s from ttc27
  // reg   s from SPI27
   reg       so;                    // data reg    from slave27
   reg       mo27;                    // data reg    from master27
   reg       sclk_out27;              // clock27 reg    from master27
   reg    [P_SIZE27-1:0] n_ss_out27;    // peripheral27 select27 lines27 from master27
   reg       n_so_en27;               // out enable for slave27 data
   reg       n_mo_en27;               // out enable for master27 data
   reg       n_sclk_en27;             // out enable for master27 clock27
   reg       n_ss_en27;               // out enable for master27 peripheral27 lines27
  //reg   s from gpio27
   reg    [GPIO_WIDTH27-1:0]     n_gpio_pin_oe27;           // reg    enable signal27 to pin27
   reg    [GPIO_WIDTH27-1:0]     gpio_pin_out27;            // reg    signal27 to pin27


`endif
//------------------------------------------------------------------------------
// black27 boxed27 defines27 
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// APB27 and AHB27 interface formal27 verification27 monitors27
//------------------------------------------------------------------------------
`ifdef ABV_ON27
apb_assert27 i_apb_assert27 (

        // APB27 signals27
  	.n_preset27(n_preset27),
   	.pclk27(pclk27),
	.penable27(penable27),
	.paddr27(paddr27),
	.pwrite27(pwrite27),
	.pwdata27(pwdata27),

	.psel0027(psel_spi27),
	.psel0127(psel_uart027),
	.psel0227(psel_gpio27),
	.psel0327(psel_ttc27),
	.psel0427(1'b0),
	.psel0527(psel_smc27),
	.psel0627(1'b0),
	.psel0727(1'b0),
	.psel0827(1'b0),
	.psel0927(1'b0),
	.psel1027(1'b0),
	.psel1127(1'b0),
	.psel1227(1'b0),
	.psel1327(psel_pmc27),
	.psel1427(psel_apic27),
	.psel1527(psel_uart127),

        .prdata0027(prdata_spi27),
        .prdata0127(prdata_uart027), // Read Data from peripheral27 UART27 
        .prdata0227(prdata_gpio27), // Read Data from peripheral27 GPIO27
        .prdata0327(prdata_ttc27), // Read Data from peripheral27 TTC27
        .prdata0427(32'b0), // 
        .prdata0527(prdata_smc27), // Read Data from peripheral27 SMC27
        .prdata1327(prdata_pmc27), // Read Data from peripheral27 Power27 Control27 Block
   	.prdata1427(32'b0), // 
        .prdata1527(prdata_uart127),


        // AHB27 signals27
        .hclk27(hclk27),         // ahb27 system clock27
        .n_hreset27(n_hreset27), // ahb27 system reset

        // ahb2apb27 signals27
        .hresp27(hresp27),
        .hready27(hready27),
        .hrdata27(hrdata27),
        .hwdata27(hwdata27),
        .hprot27(hprot27),
        .hburst27(hburst27),
        .hsize27(hsize27),
        .hwrite27(hwrite27),
        .htrans27(htrans27),
        .haddr27(haddr27),
        .ahb2apb_hsel27(ahb2apb0_hsel27));



//------------------------------------------------------------------------------
// AHB27 interface formal27 verification27 monitor27
//------------------------------------------------------------------------------
defparam i_ahbSlaveMonitor27.DBUS_WIDTH27 = 32;
defparam i_ahbMasterMonitor27.DBUS_WIDTH27 = 32;


// AHB2APB27 Bridge27

    ahb_liteslave_monitor27 i_ahbSlaveMonitor27 (
        .hclk_i27(hclk27),
        .hresetn_i27(n_hreset27),
        .hresp27(hresp27),
        .hready27(hready27),
        .hready_global_i27(hready27),
        .hrdata27(hrdata27),
        .hwdata_i27(hwdata27),
        .hburst_i27(hburst27),
        .hsize_i27(hsize27),
        .hwrite_i27(hwrite27),
        .htrans_i27(htrans27),
        .haddr_i27(haddr27),
        .hsel_i27(ahb2apb0_hsel27)
    );


  ahb_litemaster_monitor27 i_ahbMasterMonitor27 (
          .hclk_i27(hclk27),
          .hresetn_i27(n_hreset27),
          .hresp_i27(hresp27),
          .hready_i27(hready27),
          .hrdata_i27(hrdata27),
          .hlock27(1'b0),
          .hwdata27(hwdata27),
          .hprot27(hprot27),
          .hburst27(hburst27),
          .hsize27(hsize27),
          .hwrite27(hwrite27),
          .htrans27(htrans27),
          .haddr27(haddr27)
          );







`endif




`ifdef IFV_LP_ABV_ON27
// power27 control27
wire isolate27;

// testbench mirror signals27
wire L1_ctrl_access27;
wire L1_status_access27;

wire [31:0] L1_status_reg27;
wire [31:0] L1_ctrl_reg27;

//wire rstn_non_srpg_urt27;
//wire isolate_urt27;
//wire retain_urt27;
//wire gate_clk_urt27;
//wire pwr1_on_urt27;


// smc27 signals27
wire [31:0] smc_prdata27;
wire lp_clk_smc27;
                    

// uart27 isolation27 register
  wire [15:0] ua_prdata27;
  wire ua_int27;
  assign ua_prdata27          =  i_uart1_veneer27.prdata27;
  assign ua_int27             =  i_uart1_veneer27.ua_int27;


assign lp_clk_smc27          = i_smc_veneer27.pclk27;
assign smc_prdata27          = i_smc_veneer27.prdata27;
lp_chk_smc27 u_lp_chk_smc27 (
    .clk27 (hclk27),
    .rst27 (n_hreset27),
    .iso_smc27 (isolate_smc27),
    .gate_clk27 (gate_clk_smc27),
    .lp_clk27 (pclk_SRPG_smc27),

    // srpg27 outputs27
    .smc_hrdata27 (smc_hrdata27),
    .smc_hready27 (smc_hready27),
    .smc_hresp27  (smc_hresp27),
    .smc_valid27 (smc_valid27),
    .smc_addr_int27 (smc_addr_int27),
    .smc_data27 (smc_data27),
    .smc_n_be27 (smc_n_be27),
    .smc_n_cs27  (smc_n_cs27),
    .smc_n_wr27 (smc_n_wr27),
    .smc_n_we27 (smc_n_we27),
    .smc_n_rd27 (smc_n_rd27),
    .smc_n_ext_oe27 (smc_n_ext_oe27)
   );

// lp27 retention27/isolation27 assertions27
lp_chk_uart27 u_lp_chk_urt27 (

  .clk27         (hclk27),
  .rst27         (n_hreset27),
  .iso_urt27     (isolate_urt27),
  .gate_clk27    (gate_clk_urt27),
  .lp_clk27      (pclk_SRPG_urt27),
  //ports27
  .prdata27 (ua_prdata27),
  .ua_int27 (ua_int27),
  .ua_txd27 (ua_txd127),
  .ua_nrts27 (ua_nrts127)
 );

`endif  //IFV_LP_ABV_ON27




endmodule
