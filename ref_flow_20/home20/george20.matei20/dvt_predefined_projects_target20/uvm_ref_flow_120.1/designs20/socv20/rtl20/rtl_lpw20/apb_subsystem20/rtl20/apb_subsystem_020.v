//File20 name   : apb_subsystem_020.v
//Title20       : 
//Created20     : 1999
//Description20 : 
//Notes20       : 
//----------------------------------------------------------------------
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------

module apb_subsystem_020(
    // AHB20 interface
    hclk20,
    n_hreset20,
    hsel20,
    haddr20,
    htrans20,
    hsize20,
    hwrite20,
    hwdata20,
    hready_in20,
    hburst20,
    hprot20,
    hmaster20,
    hmastlock20,
    hrdata20,
    hready20,
    hresp20,
    
    // APB20 system interface
    pclk20,
    n_preset20,
    
    // SPI20 ports20
    n_ss_in20,
    mi20,
    si20,
    sclk_in20,
    so,
    mo20,
    sclk_out20,
    n_ss_out20,
    n_so_en20,
    n_mo_en20,
    n_sclk_en20,
    n_ss_en20,
    
    //UART020 ports20
    ua_rxd20,
    ua_ncts20,
    ua_txd20,
    ua_nrts20,
    
    //UART120 ports20
    ua_rxd120,
    ua_ncts120,
    ua_txd120,
    ua_nrts120,
    
    //GPIO20 ports20
    gpio_pin_in20,
    n_gpio_pin_oe20,
    gpio_pin_out20,
    

    //SMC20 ports20
    smc_hclk20,
    smc_n_hclk20,
    smc_haddr20,
    smc_htrans20,
    smc_hsel20,
    smc_hwrite20,
    smc_hsize20,
    smc_hwdata20,
    smc_hready_in20,
    smc_hburst20,
    smc_hprot20,
    smc_hmaster20,
    smc_hmastlock20,
    smc_hrdata20, 
    smc_hready20,
    smc_hresp20,
    smc_n_ext_oe20,
    smc_data20,
    smc_addr20,
    smc_n_be20,
    smc_n_cs20, 
    smc_n_we20,
    smc_n_wr20,
    smc_n_rd20,
    data_smc20,
    
    //PMC20 ports20
    clk_SRPG_macb0_en20,
    clk_SRPG_macb1_en20,
    clk_SRPG_macb2_en20,
    clk_SRPG_macb3_en20,
    core06v20,
    core08v20,
    core10v20,
    core12v20,
    macb3_wakeup20,
    macb2_wakeup20,
    macb1_wakeup20,
    macb0_wakeup20,
    mte_smc_start20,
    mte_uart_start20,
    mte_smc_uart_start20,  
    mte_pm_smc_to_default_start20, 
    mte_pm_uart_to_default_start20,
    mte_pm_smc_uart_to_default_start20,
    
    
    // Peripheral20 inerrupts20
    pcm_irq20,
    ttc_irq20,
    gpio_irq20,
    uart0_irq20,
    uart1_irq20,
    spi_irq20,
    DMA_irq20,      
    macb0_int20,
    macb1_int20,
    macb2_int20,
    macb3_int20,
   
    // Scan20 ports20
    scan_en20,      // Scan20 enable pin20
    scan_in_120,    // Scan20 input for first chain20
    scan_in_220,    // Scan20 input for second chain20
    scan_mode20,
    scan_out_120,   // Scan20 out for chain20 1
    scan_out_220    // Scan20 out for chain20 2
);

parameter GPIO_WIDTH20 = 16;        // GPIO20 width
parameter P_SIZE20 =   8;              // number20 of peripheral20 select20 lines20
parameter NO_OF_IRQS20  = 17;      //No of irqs20 read by apic20 

// AHB20 interface
input         hclk20;     // AHB20 Clock20
input         n_hreset20;  // AHB20 reset - Active20 low20
input         hsel20;     // AHB2APB20 select20
input [31:0]  haddr20;    // Address bus
input [1:0]   htrans20;   // Transfer20 type
input [2:0]   hsize20;    // AHB20 Access type - byte, half20-word20, word20
input [31:0]  hwdata20;   // Write data
input         hwrite20;   // Write signal20/
input         hready_in20;// Indicates20 that last master20 has finished20 bus access
input [2:0]   hburst20;     // Burst type
input [3:0]   hprot20;      // Protection20 control20
input [3:0]   hmaster20;    // Master20 select20
input         hmastlock20;  // Locked20 transfer20
output [31:0] hrdata20;       // Read data provided from target slave20
output        hready20;       // Ready20 for new bus cycle from target slave20
output [1:0]  hresp20;       // Response20 from the bridge20
    
// APB20 system interface
input         pclk20;     // APB20 Clock20. 
input         n_preset20;  // APB20 reset - Active20 low20
   
// SPI20 ports20
input     n_ss_in20;      // select20 input to slave20
input     mi20;           // data input to master20
input     si20;           // data input to slave20
input     sclk_in20;      // clock20 input to slave20
output    so;                    // data output from slave20
output    mo20;                    // data output from master20
output    sclk_out20;              // clock20 output from master20
output [P_SIZE20-1:0] n_ss_out20;    // peripheral20 select20 lines20 from master20
output    n_so_en20;               // out enable for slave20 data
output    n_mo_en20;               // out enable for master20 data
output    n_sclk_en20;             // out enable for master20 clock20
output    n_ss_en20;               // out enable for master20 peripheral20 lines20

//UART020 ports20
input        ua_rxd20;       // UART20 receiver20 serial20 input pin20
input        ua_ncts20;      // Clear-To20-Send20 flow20 control20
output       ua_txd20;       	// UART20 transmitter20 serial20 output
output       ua_nrts20;      	// Request20-To20-Send20 flow20 control20

// UART120 ports20   
input        ua_rxd120;      // UART20 receiver20 serial20 input pin20
input        ua_ncts120;      // Clear-To20-Send20 flow20 control20
output       ua_txd120;       // UART20 transmitter20 serial20 output
output       ua_nrts120;      // Request20-To20-Send20 flow20 control20

//GPIO20 ports20
input [GPIO_WIDTH20-1:0]      gpio_pin_in20;             // input data from pin20
output [GPIO_WIDTH20-1:0]     n_gpio_pin_oe20;           // output enable signal20 to pin20
output [GPIO_WIDTH20-1:0]     gpio_pin_out20;            // output signal20 to pin20
  
//SMC20 ports20
input        smc_hclk20;
input        smc_n_hclk20;
input [31:0] smc_haddr20;
input [1:0]  smc_htrans20;
input        smc_hsel20;
input        smc_hwrite20;
input [2:0]  smc_hsize20;
input [31:0] smc_hwdata20;
input        smc_hready_in20;
input [2:0]  smc_hburst20;     // Burst type
input [3:0]  smc_hprot20;      // Protection20 control20
input [3:0]  smc_hmaster20;    // Master20 select20
input        smc_hmastlock20;  // Locked20 transfer20
input [31:0] data_smc20;     // EMI20(External20 memory) read data
output [31:0]    smc_hrdata20;
output           smc_hready20;
output [1:0]     smc_hresp20;
output [15:0]    smc_addr20;      // External20 Memory (EMI20) address
output [3:0]     smc_n_be20;      // EMI20 byte enables20 (Active20 LOW20)
output           smc_n_cs20;      // EMI20 Chip20 Selects20 (Active20 LOW20)
output [3:0]     smc_n_we20;      // EMI20 write strobes20 (Active20 LOW20)
output           smc_n_wr20;      // EMI20 write enable (Active20 LOW20)
output           smc_n_rd20;      // EMI20 read stobe20 (Active20 LOW20)
output           smc_n_ext_oe20;  // EMI20 write data output enable
output [31:0]    smc_data20;      // EMI20 write data
       
//PMC20 ports20
output clk_SRPG_macb0_en20;
output clk_SRPG_macb1_en20;
output clk_SRPG_macb2_en20;
output clk_SRPG_macb3_en20;
output core06v20;
output core08v20;
output core10v20;
output core12v20;
output mte_smc_start20;
output mte_uart_start20;
output mte_smc_uart_start20;  
output mte_pm_smc_to_default_start20; 
output mte_pm_uart_to_default_start20;
output mte_pm_smc_uart_to_default_start20;
input macb3_wakeup20;
input macb2_wakeup20;
input macb1_wakeup20;
input macb0_wakeup20;
    

// Peripheral20 interrupts20
output pcm_irq20;
output [2:0] ttc_irq20;
output gpio_irq20;
output uart0_irq20;
output uart1_irq20;
output spi_irq20;
input        macb0_int20;
input        macb1_int20;
input        macb2_int20;
input        macb3_int20;
input        DMA_irq20;
  
//Scan20 ports20
input        scan_en20;    // Scan20 enable pin20
input        scan_in_120;  // Scan20 input for first chain20
input        scan_in_220;  // Scan20 input for second chain20
input        scan_mode20;  // test mode pin20
 output        scan_out_120;   // Scan20 out for chain20 1
 output        scan_out_220;   // Scan20 out for chain20 2  

//------------------------------------------------------------------------------
// if the ROM20 subsystem20 is NOT20 black20 boxed20 
//------------------------------------------------------------------------------
`ifndef FV_KIT_BLACK_BOX_APB_SUBSYSTEM20
   
   wire        hsel20; 
   wire        pclk20;
   wire        n_preset20;
   wire [31:0] prdata_spi20;
   wire [31:0] prdata_uart020;
   wire [31:0] prdata_gpio20;
   wire [31:0] prdata_ttc20;
   wire [31:0] prdata_smc20;
   wire [31:0] prdata_pmc20;
   wire [31:0] prdata_uart120;
   wire        pready_spi20;
   wire        pready_uart020;
   wire        pready_uart120;
   wire        tie_hi_bit20;
   wire  [31:0] hrdata20; 
   wire         hready20;
   wire         hready_in20;
   wire  [1:0]  hresp20;   
   wire  [31:0] pwdata20;  
   wire         pwrite20;
   wire  [31:0] paddr20;  
   wire   psel_spi20;
   wire   psel_uart020;
   wire   psel_gpio20;
   wire   psel_ttc20;
   wire   psel_smc20;
   wire   psel0720;
   wire   psel0820;
   wire   psel0920;
   wire   psel1020;
   wire   psel1120;
   wire   psel1220;
   wire   psel_pmc20;
   wire   psel_uart120;
   wire   penable20;
   wire   [NO_OF_IRQS20:0] int_source20;     // System20 Interrupt20 Sources20
   wire [1:0]             smc_hresp20;     // AHB20 Response20 signal20
   wire                   smc_valid20;     // Ack20 valid address

  //External20 memory interface (EMI20)
  wire [31:0]            smc_addr_int20;  // External20 Memory (EMI20) address
  wire [3:0]             smc_n_be20;      // EMI20 byte enables20 (Active20 LOW20)
  wire                   smc_n_cs20;      // EMI20 Chip20 Selects20 (Active20 LOW20)
  wire [3:0]             smc_n_we20;      // EMI20 write strobes20 (Active20 LOW20)
  wire                   smc_n_wr20;      // EMI20 write enable (Active20 LOW20)
  wire                   smc_n_rd20;      // EMI20 read stobe20 (Active20 LOW20)
 
  //AHB20 Memory Interface20 Control20
  wire                   smc_hsel_int20;
  wire                   smc_busy20;      // smc20 busy
   

//scan20 signals20

   wire                scan_in_120;        //scan20 input
   wire                scan_in_220;        //scan20 input
   wire                scan_en20;         //scan20 enable
   wire                scan_out_120;       //scan20 output
   wire                scan_out_220;       //scan20 output
   wire                byte_sel20;     // byte select20 from bridge20 1=byte, 0=2byte
   wire                UART_int20;     // UART20 module interrupt20 
   wire                ua_uclken20;    // Soft20 control20 of clock20
   wire                UART_int120;     // UART20 module interrupt20 
   wire                ua_uclken120;    // Soft20 control20 of clock20
   wire  [3:1]         TTC_int20;            //Interrupt20 from PCI20 
  // inputs20 to SPI20 
   wire    ext_clk20;                // external20 clock20
   wire    SPI_int20;             // interrupt20 request
  // outputs20 from SPI20
   wire    slave_out_clk20;         // modified slave20 clock20 output
 // gpio20 generic20 inputs20 
   wire  [GPIO_WIDTH20-1:0]   n_gpio_bypass_oe20;        // bypass20 mode enable 
   wire  [GPIO_WIDTH20-1:0]   gpio_bypass_out20;         // bypass20 mode output value 
   wire  [GPIO_WIDTH20-1:0]   tri_state_enable20;   // disables20 op enable -> z 
 // outputs20 
   //amba20 outputs20 
   // gpio20 generic20 outputs20 
   wire       GPIO_int20;                // gpio_interupt20 for input pin20 change 
   wire [GPIO_WIDTH20-1:0]     gpio_bypass_in20;          // bypass20 mode input data value  
                
   wire           cpu_debug20;        // Inhibits20 watchdog20 counter 
   wire            ex_wdz_n20;         // External20 Watchdog20 zero indication20
   wire           rstn_non_srpg_smc20; 
   wire           rstn_non_srpg_urt20;
   wire           isolate_smc20;
   wire           save_edge_smc20;
   wire           restore_edge_smc20;
   wire           save_edge_urt20;
   wire           restore_edge_urt20;
   wire           pwr1_on_smc20;
   wire           pwr2_on_smc20;
   wire           pwr1_on_urt20;
   wire           pwr2_on_urt20;
   // ETH020
   wire            rstn_non_srpg_macb020;
   wire            gate_clk_macb020;
   wire            isolate_macb020;
   wire            save_edge_macb020;
   wire            restore_edge_macb020;
   wire            pwr1_on_macb020;
   wire            pwr2_on_macb020;
   // ETH120
   wire            rstn_non_srpg_macb120;
   wire            gate_clk_macb120;
   wire            isolate_macb120;
   wire            save_edge_macb120;
   wire            restore_edge_macb120;
   wire            pwr1_on_macb120;
   wire            pwr2_on_macb120;
   // ETH220
   wire            rstn_non_srpg_macb220;
   wire            gate_clk_macb220;
   wire            isolate_macb220;
   wire            save_edge_macb220;
   wire            restore_edge_macb220;
   wire            pwr1_on_macb220;
   wire            pwr2_on_macb220;
   // ETH320
   wire            rstn_non_srpg_macb320;
   wire            gate_clk_macb320;
   wire            isolate_macb320;
   wire            save_edge_macb320;
   wire            restore_edge_macb320;
   wire            pwr1_on_macb320;
   wire            pwr2_on_macb320;


   wire           pclk_SRPG_smc20;
   wire           pclk_SRPG_urt20;
   wire           gate_clk_smc20;
   wire           gate_clk_urt20;
   wire  [31:0]   tie_lo_32bit20; 
   wire  [1:0]	  tie_lo_2bit20;
   wire  	  tie_lo_1bit20;
   wire           pcm_macb_wakeup_int20;
   wire           int_source_h20;
   wire           isolate_mem20;

assign pcm_irq20 = pcm_macb_wakeup_int20;
assign ttc_irq20[2] = TTC_int20[3];
assign ttc_irq20[1] = TTC_int20[2];
assign ttc_irq20[0] = TTC_int20[1];
assign gpio_irq20 = GPIO_int20;
assign uart0_irq20 = UART_int20;
assign uart1_irq20 = UART_int120;
assign spi_irq20 = SPI_int20;

assign n_mo_en20   = 1'b0;
assign n_so_en20   = 1'b1;
assign n_sclk_en20 = 1'b0;
assign n_ss_en20   = 1'b0;

assign smc_hsel_int20 = smc_hsel20;
  assign ext_clk20  = 1'b0;
  assign int_source20 = {macb0_int20,macb1_int20, macb2_int20, macb3_int20,1'b0, pcm_macb_wakeup_int20, 1'b0, 1'b0, 1'b0, 1'b0, TTC_int20, GPIO_int20, UART_int20, UART_int120, SPI_int20, DMA_irq20};

  // interrupt20 even20 detect20 .
  // for sleep20 wake20 up -> any interrupt20 even20 and system not in hibernation20 (isolate_mem20 = 0)
  // for hibernate20 wake20 up -> gpio20 interrupt20 even20 and system in the hibernation20 (isolate_mem20 = 1)
  assign int_source_h20 =  ((|int_source20) && (!isolate_mem20)) || (isolate_mem20 && GPIO_int20) ;

  assign byte_sel20 = 1'b1;
  assign tie_hi_bit20 = 1'b1;

  assign smc_addr20 = smc_addr_int20[15:0];



  assign  n_gpio_bypass_oe20 = {GPIO_WIDTH20{1'b0}};        // bypass20 mode enable 
  assign  gpio_bypass_out20  = {GPIO_WIDTH20{1'b0}};
  assign  tri_state_enable20 = {GPIO_WIDTH20{1'b0}};
  assign  cpu_debug20 = 1'b0;
  assign  tie_lo_32bit20 = 32'b0;
  assign  tie_lo_2bit20  = 2'b0;
  assign  tie_lo_1bit20  = 1'b0;


ahb2apb20 #(
  32'h00800000, // Slave20 0 Address Range20
  32'h0080FFFF,

  32'h00810000, // Slave20 1 Address Range20
  32'h0081FFFF,

  32'h00820000, // Slave20 2 Address Range20 
  32'h0082FFFF,

  32'h00830000, // Slave20 3 Address Range20
  32'h0083FFFF,

  32'h00840000, // Slave20 4 Address Range20
  32'h0084FFFF,

  32'h00850000, // Slave20 5 Address Range20
  32'h0085FFFF,

  32'h00860000, // Slave20 6 Address Range20
  32'h0086FFFF,

  32'h00870000, // Slave20 7 Address Range20
  32'h0087FFFF,

  32'h00880000, // Slave20 8 Address Range20
  32'h0088FFFF
) i_ahb2apb20 (
     // AHB20 interface
    .hclk20(hclk20),         
    .hreset_n20(n_hreset20), 
    .hsel20(hsel20), 
    .haddr20(haddr20),        
    .htrans20(htrans20),       
    .hwrite20(hwrite20),       
    .hwdata20(hwdata20),       
    .hrdata20(hrdata20),   
    .hready20(hready20),   
    .hresp20(hresp20),     
    
     // APB20 interface
    .pclk20(pclk20),         
    .preset_n20(n_preset20),  
    .prdata020(prdata_spi20),
    .prdata120(prdata_uart020), 
    .prdata220(prdata_gpio20),  
    .prdata320(prdata_ttc20),   
    .prdata420(32'h0),   
    .prdata520(prdata_smc20),   
    .prdata620(prdata_pmc20),    
    .prdata720(32'h0),   
    .prdata820(prdata_uart120),  
    .pready020(pready_spi20),     
    .pready120(pready_uart020),   
    .pready220(tie_hi_bit20),     
    .pready320(tie_hi_bit20),     
    .pready420(tie_hi_bit20),     
    .pready520(tie_hi_bit20),     
    .pready620(tie_hi_bit20),     
    .pready720(tie_hi_bit20),     
    .pready820(pready_uart120),  
    .pwdata20(pwdata20),       
    .pwrite20(pwrite20),       
    .paddr20(paddr20),        
    .psel020(psel_spi20),     
    .psel120(psel_uart020),   
    .psel220(psel_gpio20),    
    .psel320(psel_ttc20),     
    .psel420(),     
    .psel520(psel_smc20),     
    .psel620(psel_pmc20),    
    .psel720(psel_apic20),   
    .psel820(psel_uart120),  
    .penable20(penable20)     
);

spi_top20 i_spi20
(
  // Wishbone20 signals20
  .wb_clk_i20(pclk20), 
  .wb_rst_i20(~n_preset20), 
  .wb_adr_i20(paddr20[4:0]), 
  .wb_dat_i20(pwdata20), 
  .wb_dat_o20(prdata_spi20), 
  .wb_sel_i20(4'b1111),    // SPI20 register accesses are always 32-bit
  .wb_we_i20(pwrite20), 
  .wb_stb_i20(psel_spi20), 
  .wb_cyc_i20(psel_spi20), 
  .wb_ack_o20(pready_spi20), 
  .wb_err_o20(), 
  .wb_int_o20(SPI_int20),

  // SPI20 signals20
  .ss_pad_o20(n_ss_out20), 
  .sclk_pad_o20(sclk_out20), 
  .mosi_pad_o20(mo20), 
  .miso_pad_i20(mi20)
);

// Opencores20 UART20 instances20
wire ua_nrts_int20;
wire ua_nrts1_int20;

assign ua_nrts20 = ua_nrts_int20;
assign ua_nrts120 = ua_nrts1_int20;

reg [3:0] uart0_sel_i20;
reg [3:0] uart1_sel_i20;
// UART20 registers are all 8-bit wide20, and their20 addresses20
// are on byte boundaries20. So20 to access them20 on the
// Wishbone20 bus, the CPU20 must do byte accesses to these20
// byte addresses20. Word20 address accesses are not possible20
// because the word20 addresses20 will be unaligned20, and cause
// a fault20.
// So20, Uart20 accesses from the CPU20 will always be 8-bit size
// We20 only have to decide20 which byte of the 4-byte word20 the
// CPU20 is interested20 in.
`ifdef SYSTEM_BIG_ENDIAN20
always @(paddr20) begin
  case (paddr20[1:0])
    2'b00 : uart0_sel_i20 = 4'b1000;
    2'b01 : uart0_sel_i20 = 4'b0100;
    2'b10 : uart0_sel_i20 = 4'b0010;
    2'b11 : uart0_sel_i20 = 4'b0001;
  endcase
end
always @(paddr20) begin
  case (paddr20[1:0])
    2'b00 : uart1_sel_i20 = 4'b1000;
    2'b01 : uart1_sel_i20 = 4'b0100;
    2'b10 : uart1_sel_i20 = 4'b0010;
    2'b11 : uart1_sel_i20 = 4'b0001;
  endcase
end
`else
always @(paddr20) begin
  case (paddr20[1:0])
    2'b00 : uart0_sel_i20 = 4'b0001;
    2'b01 : uart0_sel_i20 = 4'b0010;
    2'b10 : uart0_sel_i20 = 4'b0100;
    2'b11 : uart0_sel_i20 = 4'b1000;
  endcase
end
always @(paddr20) begin
  case (paddr20[1:0])
    2'b00 : uart1_sel_i20 = 4'b0001;
    2'b01 : uart1_sel_i20 = 4'b0010;
    2'b10 : uart1_sel_i20 = 4'b0100;
    2'b11 : uart1_sel_i20 = 4'b1000;
  endcase
end
`endif

uart_top20 i_oc_uart020 (
  .wb_clk_i20(pclk20),
  .wb_rst_i20(~n_preset20),
  .wb_adr_i20(paddr20[4:0]),
  .wb_dat_i20(pwdata20),
  .wb_dat_o20(prdata_uart020),
  .wb_we_i20(pwrite20),
  .wb_stb_i20(psel_uart020),
  .wb_cyc_i20(psel_uart020),
  .wb_ack_o20(pready_uart020),
  .wb_sel_i20(uart0_sel_i20),
  .int_o20(UART_int20),
  .stx_pad_o20(ua_txd20),
  .srx_pad_i20(ua_rxd20),
  .rts_pad_o20(ua_nrts_int20),
  .cts_pad_i20(ua_ncts20),
  .dtr_pad_o20(),
  .dsr_pad_i20(1'b0),
  .ri_pad_i20(1'b0),
  .dcd_pad_i20(1'b0)
);

uart_top20 i_oc_uart120 (
  .wb_clk_i20(pclk20),
  .wb_rst_i20(~n_preset20),
  .wb_adr_i20(paddr20[4:0]),
  .wb_dat_i20(pwdata20),
  .wb_dat_o20(prdata_uart120),
  .wb_we_i20(pwrite20),
  .wb_stb_i20(psel_uart120),
  .wb_cyc_i20(psel_uart120),
  .wb_ack_o20(pready_uart120),
  .wb_sel_i20(uart1_sel_i20),
  .int_o20(UART_int120),
  .stx_pad_o20(ua_txd120),
  .srx_pad_i20(ua_rxd120),
  .rts_pad_o20(ua_nrts1_int20),
  .cts_pad_i20(ua_ncts120),
  .dtr_pad_o20(),
  .dsr_pad_i20(1'b0),
  .ri_pad_i20(1'b0),
  .dcd_pad_i20(1'b0)
);

gpio_veneer20 i_gpio_veneer20 (
        //inputs20

        . n_p_reset20(n_preset20),
        . pclk20(pclk20),
        . psel20(psel_gpio20),
        . penable20(penable20),
        . pwrite20(pwrite20),
        . paddr20(paddr20[5:0]),
        . pwdata20(pwdata20),
        . gpio_pin_in20(gpio_pin_in20),
        . scan_en20(scan_en20),
        . tri_state_enable20(tri_state_enable20),
        . scan_in20(), //added by smarkov20 for dft20

        //outputs20
        . scan_out20(), //added by smarkov20 for dft20
        . prdata20(prdata_gpio20),
        . gpio_int20(GPIO_int20),
        . n_gpio_pin_oe20(n_gpio_pin_oe20),
        . gpio_pin_out20(gpio_pin_out20)
);


ttc_veneer20 i_ttc_veneer20 (

         //inputs20
        . n_p_reset20(n_preset20),
        . pclk20(pclk20),
        . psel20(psel_ttc20),
        . penable20(penable20),
        . pwrite20(pwrite20),
        . pwdata20(pwdata20),
        . paddr20(paddr20[7:0]),
        . scan_in20(),
        . scan_en20(scan_en20),

        //outputs20
        . prdata20(prdata_ttc20),
        . interrupt20(TTC_int20[3:1]),
        . scan_out20()
);


smc_veneer20 i_smc_veneer20 (
        //inputs20
	//apb20 inputs20
        . n_preset20(n_preset20),
        . pclk20(pclk_SRPG_smc20),
        . psel20(psel_smc20),
        . penable20(penable20),
        . pwrite20(pwrite20),
        . paddr20(paddr20[4:0]),
        . pwdata20(pwdata20),
        //ahb20 inputs20
	. hclk20(smc_hclk20),
        . n_sys_reset20(rstn_non_srpg_smc20),
        . haddr20(smc_haddr20),
        . htrans20(smc_htrans20),
        . hsel20(smc_hsel_int20),
        . hwrite20(smc_hwrite20),
	. hsize20(smc_hsize20),
        . hwdata20(smc_hwdata20),
        . hready20(smc_hready_in20),
        . data_smc20(data_smc20),

         //test signal20 inputs20

        . scan_in_120(),
        . scan_in_220(),
        . scan_in_320(),
        . scan_en20(scan_en20),

        //apb20 outputs20
        . prdata20(prdata_smc20),

       //design output

        . smc_hrdata20(smc_hrdata20),
        . smc_hready20(smc_hready20),
        . smc_hresp20(smc_hresp20),
        . smc_valid20(smc_valid20),
        . smc_addr20(smc_addr_int20),
        . smc_data20(smc_data20),
        . smc_n_be20(smc_n_be20),
        . smc_n_cs20(smc_n_cs20),
        . smc_n_wr20(smc_n_wr20),
        . smc_n_we20(smc_n_we20),
        . smc_n_rd20(smc_n_rd20),
        . smc_n_ext_oe20(smc_n_ext_oe20),
        . smc_busy20(smc_busy20),

         //test signal20 output
        . scan_out_120(),
        . scan_out_220(),
        . scan_out_320()
);

power_ctrl_veneer20 i_power_ctrl_veneer20 (
    // -- Clocks20 & Reset20
    	.pclk20(pclk20), 			//  : in  std_logic20;
    	.nprst20(n_preset20), 		//  : in  std_logic20;
    // -- APB20 programming20 interface
    	.paddr20(paddr20), 			//  : in  std_logic_vector20(31 downto20 0);
    	.psel20(psel_pmc20), 			//  : in  std_logic20;
    	.penable20(penable20), 		//  : in  std_logic20;
    	.pwrite20(pwrite20), 		//  : in  std_logic20;
    	.pwdata20(pwdata20), 		//  : in  std_logic_vector20(31 downto20 0);
    	.prdata20(prdata_pmc20), 		//  : out std_logic_vector20(31 downto20 0);
        .macb3_wakeup20(macb3_wakeup20),
        .macb2_wakeup20(macb2_wakeup20),
        .macb1_wakeup20(macb1_wakeup20),
        .macb0_wakeup20(macb0_wakeup20),
    // -- Module20 control20 outputs20
    	.scan_in20(),			//  : in  std_logic20;
    	.scan_en20(scan_en20),             	//  : in  std_logic20;
    	.scan_mode20(scan_mode20),          //  : in  std_logic20;
    	.scan_out20(),            	//  : out std_logic20;
        .int_source_h20(int_source_h20),
     	.rstn_non_srpg_smc20(rstn_non_srpg_smc20), 		//   : out std_logic20;
    	.gate_clk_smc20(gate_clk_smc20), 	//  : out std_logic20;
    	.isolate_smc20(isolate_smc20), 	//  : out std_logic20;
    	.save_edge_smc20(save_edge_smc20), 	//  : out std_logic20;
    	.restore_edge_smc20(restore_edge_smc20), 	//  : out std_logic20;
    	.pwr1_on_smc20(pwr1_on_smc20), 	//  : out std_logic20;
    	.pwr2_on_smc20(pwr2_on_smc20), 	//  : out std_logic20
     	.rstn_non_srpg_urt20(rstn_non_srpg_urt20), 		//   : out std_logic20;
    	.gate_clk_urt20(gate_clk_urt20), 	//  : out std_logic20;
    	.isolate_urt20(isolate_urt20), 	//  : out std_logic20;
    	.save_edge_urt20(save_edge_urt20), 	//  : out std_logic20;
    	.restore_edge_urt20(restore_edge_urt20), 	//  : out std_logic20;
    	.pwr1_on_urt20(pwr1_on_urt20), 	//  : out std_logic20;
    	.pwr2_on_urt20(pwr2_on_urt20),  	//  : out std_logic20
        // ETH020
        .rstn_non_srpg_macb020(rstn_non_srpg_macb020),
        .gate_clk_macb020(gate_clk_macb020),
        .isolate_macb020(isolate_macb020),
        .save_edge_macb020(save_edge_macb020),
        .restore_edge_macb020(restore_edge_macb020),
        .pwr1_on_macb020(pwr1_on_macb020),
        .pwr2_on_macb020(pwr2_on_macb020),
        // ETH120
        .rstn_non_srpg_macb120(rstn_non_srpg_macb120),
        .gate_clk_macb120(gate_clk_macb120),
        .isolate_macb120(isolate_macb120),
        .save_edge_macb120(save_edge_macb120),
        .restore_edge_macb120(restore_edge_macb120),
        .pwr1_on_macb120(pwr1_on_macb120),
        .pwr2_on_macb120(pwr2_on_macb120),
        // ETH220
        .rstn_non_srpg_macb220(rstn_non_srpg_macb220),
        .gate_clk_macb220(gate_clk_macb220),
        .isolate_macb220(isolate_macb220),
        .save_edge_macb220(save_edge_macb220),
        .restore_edge_macb220(restore_edge_macb220),
        .pwr1_on_macb220(pwr1_on_macb220),
        .pwr2_on_macb220(pwr2_on_macb220),
        // ETH320
        .rstn_non_srpg_macb320(rstn_non_srpg_macb320),
        .gate_clk_macb320(gate_clk_macb320),
        .isolate_macb320(isolate_macb320),
        .save_edge_macb320(save_edge_macb320),
        .restore_edge_macb320(restore_edge_macb320),
        .pwr1_on_macb320(pwr1_on_macb320),
        .pwr2_on_macb320(pwr2_on_macb320),
        .core06v20(core06v20),
        .core08v20(core08v20),
        .core10v20(core10v20),
        .core12v20(core12v20),
        .pcm_macb_wakeup_int20(pcm_macb_wakeup_int20),
        .isolate_mem20(isolate_mem20),
        .mte_smc_start20(mte_smc_start20),
        .mte_uart_start20(mte_uart_start20),
        .mte_smc_uart_start20(mte_smc_uart_start20),  
        .mte_pm_smc_to_default_start20(mte_pm_smc_to_default_start20), 
        .mte_pm_uart_to_default_start20(mte_pm_uart_to_default_start20),
        .mte_pm_smc_uart_to_default_start20(mte_pm_smc_uart_to_default_start20)
);

// Clock20 gating20 macro20 to shut20 off20 clocks20 to the SRPG20 flops20 in the SMC20
//CKLNQD120 i_SMC_SRPG_clk_gate20  (
//	.TE20(scan_mode20), 
//	.E20(~gate_clk_smc20), 
//	.CP20(pclk20), 
//	.Q20(pclk_SRPG_smc20)
//	);
// Replace20 gate20 with behavioural20 code20 //
wire 	smc_scan_gate20;
reg 	smc_latched_enable20;
assign smc_scan_gate20 = scan_mode20 ? 1'b1 : ~gate_clk_smc20;

always @ (pclk20 or smc_scan_gate20)
  	if (pclk20 == 1'b0) begin
  		smc_latched_enable20 <= smc_scan_gate20;
  	end  	
	
assign pclk_SRPG_smc20 = smc_latched_enable20 ? pclk20 : 1'b0;


// Clock20 gating20 macro20 to shut20 off20 clocks20 to the SRPG20 flops20 in the URT20
//CKLNQD120 i_URT_SRPG_clk_gate20  (
//	.TE20(scan_mode20), 
//	.E20(~gate_clk_urt20), 
//	.CP20(pclk20), 
//	.Q20(pclk_SRPG_urt20)
//	);
// Replace20 gate20 with behavioural20 code20 //
wire 	urt_scan_gate20;
reg 	urt_latched_enable20;
assign urt_scan_gate20 = scan_mode20 ? 1'b1 : ~gate_clk_urt20;

always @ (pclk20 or urt_scan_gate20)
  	if (pclk20 == 1'b0) begin
  		urt_latched_enable20 <= urt_scan_gate20;
  	end  	
	
assign pclk_SRPG_urt20 = urt_latched_enable20 ? pclk20 : 1'b0;

// ETH020
wire 	macb0_scan_gate20;
reg 	macb0_latched_enable20;
assign macb0_scan_gate20 = scan_mode20 ? 1'b1 : ~gate_clk_macb020;

always @ (pclk20 or macb0_scan_gate20)
  	if (pclk20 == 1'b0) begin
  		macb0_latched_enable20 <= macb0_scan_gate20;
  	end  	
	
assign clk_SRPG_macb0_en20 = macb0_latched_enable20 ? 1'b1 : 1'b0;

// ETH120
wire 	macb1_scan_gate20;
reg 	macb1_latched_enable20;
assign macb1_scan_gate20 = scan_mode20 ? 1'b1 : ~gate_clk_macb120;

always @ (pclk20 or macb1_scan_gate20)
  	if (pclk20 == 1'b0) begin
  		macb1_latched_enable20 <= macb1_scan_gate20;
  	end  	
	
assign clk_SRPG_macb1_en20 = macb1_latched_enable20 ? 1'b1 : 1'b0;

// ETH220
wire 	macb2_scan_gate20;
reg 	macb2_latched_enable20;
assign macb2_scan_gate20 = scan_mode20 ? 1'b1 : ~gate_clk_macb220;

always @ (pclk20 or macb2_scan_gate20)
  	if (pclk20 == 1'b0) begin
  		macb2_latched_enable20 <= macb2_scan_gate20;
  	end  	
	
assign clk_SRPG_macb2_en20 = macb2_latched_enable20 ? 1'b1 : 1'b0;

// ETH320
wire 	macb3_scan_gate20;
reg 	macb3_latched_enable20;
assign macb3_scan_gate20 = scan_mode20 ? 1'b1 : ~gate_clk_macb320;

always @ (pclk20 or macb3_scan_gate20)
  	if (pclk20 == 1'b0) begin
  		macb3_latched_enable20 <= macb3_scan_gate20;
  	end  	
	
assign clk_SRPG_macb3_en20 = macb3_latched_enable20 ? 1'b1 : 1'b0;



`else
//------------------------------------------------------------------------------
// if the APB20 subsystem20 is black20 boxed20 
//------------------------------------------------------------------------------
// wire s ports20
    // system signals20
    wire         hclk20;     // AHB20 Clock20
    wire         n_hreset20;  // AHB20 reset - Active20 low20
    wire         pclk20;     // APB20 Clock20. 
    wire         n_preset20;  // APB20 reset - Active20 low20

    // AHB20 interface
    wire         ahb2apb0_hsel20;     // AHB2APB20 select20
    wire  [31:0] haddr20;    // Address bus
    wire  [1:0]  htrans20;   // Transfer20 type
    wire  [2:0]  hsize20;    // AHB20 Access type - byte, half20-word20, word20
    wire  [31:0] hwdata20;   // Write data
    wire         hwrite20;   // Write signal20/
    wire         hready_in20;// Indicates20 that last master20 has finished20 bus access
    wire [2:0]   hburst20;     // Burst type
    wire [3:0]   hprot20;      // Protection20 control20
    wire [3:0]   hmaster20;    // Master20 select20
    wire         hmastlock20;  // Locked20 transfer20
  // Interrupts20 from the Enet20 MACs20
    wire         macb0_int20;
    wire         macb1_int20;
    wire         macb2_int20;
    wire         macb3_int20;
  // Interrupt20 from the DMA20
    wire         DMA_irq20;
  // Scan20 wire s
    wire         scan_en20;    // Scan20 enable pin20
    wire         scan_in_120;  // Scan20 wire  for first chain20
    wire         scan_in_220;  // Scan20 wire  for second chain20
    wire         scan_mode20;  // test mode pin20
 
  //wire  for smc20 AHB20 interface
    wire         smc_hclk20;
    wire         smc_n_hclk20;
    wire  [31:0] smc_haddr20;
    wire  [1:0]  smc_htrans20;
    wire         smc_hsel20;
    wire         smc_hwrite20;
    wire  [2:0]  smc_hsize20;
    wire  [31:0] smc_hwdata20;
    wire         smc_hready_in20;
    wire  [2:0]  smc_hburst20;     // Burst type
    wire  [3:0]  smc_hprot20;      // Protection20 control20
    wire  [3:0]  smc_hmaster20;    // Master20 select20
    wire         smc_hmastlock20;  // Locked20 transfer20


    wire  [31:0] data_smc20;     // EMI20(External20 memory) read data
    
  //wire s for uart20
    wire         ua_rxd20;       // UART20 receiver20 serial20 wire  pin20
    wire         ua_rxd120;      // UART20 receiver20 serial20 wire  pin20
    wire         ua_ncts20;      // Clear-To20-Send20 flow20 control20
    wire         ua_ncts120;      // Clear-To20-Send20 flow20 control20
   //wire s for spi20
    wire         n_ss_in20;      // select20 wire  to slave20
    wire         mi20;           // data wire  to master20
    wire         si20;           // data wire  to slave20
    wire         sclk_in20;      // clock20 wire  to slave20
  //wire s for GPIO20
   wire  [GPIO_WIDTH20-1:0]  gpio_pin_in20;             // wire  data from pin20

  //reg    ports20
  // Scan20 reg   s
   reg           scan_out_120;   // Scan20 out for chain20 1
   reg           scan_out_220;   // Scan20 out for chain20 2
  //AHB20 interface 
   reg    [31:0] hrdata20;       // Read data provided from target slave20
   reg           hready20;       // Ready20 for new bus cycle from target slave20
   reg    [1:0]  hresp20;       // Response20 from the bridge20

   // SMC20 reg    for AHB20 interface
   reg    [31:0]    smc_hrdata20;
   reg              smc_hready20;
   reg    [1:0]     smc_hresp20;

  //reg   s from smc20
   reg    [15:0]    smc_addr20;      // External20 Memory (EMI20) address
   reg    [3:0]     smc_n_be20;      // EMI20 byte enables20 (Active20 LOW20)
   reg    [7:0]     smc_n_cs20;      // EMI20 Chip20 Selects20 (Active20 LOW20)
   reg    [3:0]     smc_n_we20;      // EMI20 write strobes20 (Active20 LOW20)
   reg              smc_n_wr20;      // EMI20 write enable (Active20 LOW20)
   reg              smc_n_rd20;      // EMI20 read stobe20 (Active20 LOW20)
   reg              smc_n_ext_oe20;  // EMI20 write data reg    enable
   reg    [31:0]    smc_data20;      // EMI20 write data
  //reg   s from uart20
   reg           ua_txd20;       	// UART20 transmitter20 serial20 reg   
   reg           ua_txd120;       // UART20 transmitter20 serial20 reg   
   reg           ua_nrts20;      	// Request20-To20-Send20 flow20 control20
   reg           ua_nrts120;      // Request20-To20-Send20 flow20 control20
   // reg   s from ttc20
  // reg   s from SPI20
   reg       so;                    // data reg    from slave20
   reg       mo20;                    // data reg    from master20
   reg       sclk_out20;              // clock20 reg    from master20
   reg    [P_SIZE20-1:0] n_ss_out20;    // peripheral20 select20 lines20 from master20
   reg       n_so_en20;               // out enable for slave20 data
   reg       n_mo_en20;               // out enable for master20 data
   reg       n_sclk_en20;             // out enable for master20 clock20
   reg       n_ss_en20;               // out enable for master20 peripheral20 lines20
  //reg   s from gpio20
   reg    [GPIO_WIDTH20-1:0]     n_gpio_pin_oe20;           // reg    enable signal20 to pin20
   reg    [GPIO_WIDTH20-1:0]     gpio_pin_out20;            // reg    signal20 to pin20


`endif
//------------------------------------------------------------------------------
// black20 boxed20 defines20 
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// APB20 and AHB20 interface formal20 verification20 monitors20
//------------------------------------------------------------------------------
`ifdef ABV_ON20
apb_assert20 i_apb_assert20 (

        // APB20 signals20
  	.n_preset20(n_preset20),
   	.pclk20(pclk20),
	.penable20(penable20),
	.paddr20(paddr20),
	.pwrite20(pwrite20),
	.pwdata20(pwdata20),

	.psel0020(psel_spi20),
	.psel0120(psel_uart020),
	.psel0220(psel_gpio20),
	.psel0320(psel_ttc20),
	.psel0420(1'b0),
	.psel0520(psel_smc20),
	.psel0620(1'b0),
	.psel0720(1'b0),
	.psel0820(1'b0),
	.psel0920(1'b0),
	.psel1020(1'b0),
	.psel1120(1'b0),
	.psel1220(1'b0),
	.psel1320(psel_pmc20),
	.psel1420(psel_apic20),
	.psel1520(psel_uart120),

        .prdata0020(prdata_spi20),
        .prdata0120(prdata_uart020), // Read Data from peripheral20 UART20 
        .prdata0220(prdata_gpio20), // Read Data from peripheral20 GPIO20
        .prdata0320(prdata_ttc20), // Read Data from peripheral20 TTC20
        .prdata0420(32'b0), // 
        .prdata0520(prdata_smc20), // Read Data from peripheral20 SMC20
        .prdata1320(prdata_pmc20), // Read Data from peripheral20 Power20 Control20 Block
   	.prdata1420(32'b0), // 
        .prdata1520(prdata_uart120),


        // AHB20 signals20
        .hclk20(hclk20),         // ahb20 system clock20
        .n_hreset20(n_hreset20), // ahb20 system reset

        // ahb2apb20 signals20
        .hresp20(hresp20),
        .hready20(hready20),
        .hrdata20(hrdata20),
        .hwdata20(hwdata20),
        .hprot20(hprot20),
        .hburst20(hburst20),
        .hsize20(hsize20),
        .hwrite20(hwrite20),
        .htrans20(htrans20),
        .haddr20(haddr20),
        .ahb2apb_hsel20(ahb2apb0_hsel20));



//------------------------------------------------------------------------------
// AHB20 interface formal20 verification20 monitor20
//------------------------------------------------------------------------------
defparam i_ahbSlaveMonitor20.DBUS_WIDTH20 = 32;
defparam i_ahbMasterMonitor20.DBUS_WIDTH20 = 32;


// AHB2APB20 Bridge20

    ahb_liteslave_monitor20 i_ahbSlaveMonitor20 (
        .hclk_i20(hclk20),
        .hresetn_i20(n_hreset20),
        .hresp20(hresp20),
        .hready20(hready20),
        .hready_global_i20(hready20),
        .hrdata20(hrdata20),
        .hwdata_i20(hwdata20),
        .hburst_i20(hburst20),
        .hsize_i20(hsize20),
        .hwrite_i20(hwrite20),
        .htrans_i20(htrans20),
        .haddr_i20(haddr20),
        .hsel_i20(ahb2apb0_hsel20)
    );


  ahb_litemaster_monitor20 i_ahbMasterMonitor20 (
          .hclk_i20(hclk20),
          .hresetn_i20(n_hreset20),
          .hresp_i20(hresp20),
          .hready_i20(hready20),
          .hrdata_i20(hrdata20),
          .hlock20(1'b0),
          .hwdata20(hwdata20),
          .hprot20(hprot20),
          .hburst20(hburst20),
          .hsize20(hsize20),
          .hwrite20(hwrite20),
          .htrans20(htrans20),
          .haddr20(haddr20)
          );







`endif




`ifdef IFV_LP_ABV_ON20
// power20 control20
wire isolate20;

// testbench mirror signals20
wire L1_ctrl_access20;
wire L1_status_access20;

wire [31:0] L1_status_reg20;
wire [31:0] L1_ctrl_reg20;

//wire rstn_non_srpg_urt20;
//wire isolate_urt20;
//wire retain_urt20;
//wire gate_clk_urt20;
//wire pwr1_on_urt20;


// smc20 signals20
wire [31:0] smc_prdata20;
wire lp_clk_smc20;
                    

// uart20 isolation20 register
  wire [15:0] ua_prdata20;
  wire ua_int20;
  assign ua_prdata20          =  i_uart1_veneer20.prdata20;
  assign ua_int20             =  i_uart1_veneer20.ua_int20;


assign lp_clk_smc20          = i_smc_veneer20.pclk20;
assign smc_prdata20          = i_smc_veneer20.prdata20;
lp_chk_smc20 u_lp_chk_smc20 (
    .clk20 (hclk20),
    .rst20 (n_hreset20),
    .iso_smc20 (isolate_smc20),
    .gate_clk20 (gate_clk_smc20),
    .lp_clk20 (pclk_SRPG_smc20),

    // srpg20 outputs20
    .smc_hrdata20 (smc_hrdata20),
    .smc_hready20 (smc_hready20),
    .smc_hresp20  (smc_hresp20),
    .smc_valid20 (smc_valid20),
    .smc_addr_int20 (smc_addr_int20),
    .smc_data20 (smc_data20),
    .smc_n_be20 (smc_n_be20),
    .smc_n_cs20  (smc_n_cs20),
    .smc_n_wr20 (smc_n_wr20),
    .smc_n_we20 (smc_n_we20),
    .smc_n_rd20 (smc_n_rd20),
    .smc_n_ext_oe20 (smc_n_ext_oe20)
   );

// lp20 retention20/isolation20 assertions20
lp_chk_uart20 u_lp_chk_urt20 (

  .clk20         (hclk20),
  .rst20         (n_hreset20),
  .iso_urt20     (isolate_urt20),
  .gate_clk20    (gate_clk_urt20),
  .lp_clk20      (pclk_SRPG_urt20),
  //ports20
  .prdata20 (ua_prdata20),
  .ua_int20 (ua_int20),
  .ua_txd20 (ua_txd120),
  .ua_nrts20 (ua_nrts120)
 );

`endif  //IFV_LP_ABV_ON20




endmodule
