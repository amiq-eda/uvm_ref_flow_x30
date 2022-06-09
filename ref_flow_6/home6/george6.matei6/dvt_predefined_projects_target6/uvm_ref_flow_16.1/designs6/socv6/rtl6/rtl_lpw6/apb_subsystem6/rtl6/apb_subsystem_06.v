//File6 name   : apb_subsystem_06.v
//Title6       : 
//Created6     : 1999
//Description6 : 
//Notes6       : 
//----------------------------------------------------------------------
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------

module apb_subsystem_06(
    // AHB6 interface
    hclk6,
    n_hreset6,
    hsel6,
    haddr6,
    htrans6,
    hsize6,
    hwrite6,
    hwdata6,
    hready_in6,
    hburst6,
    hprot6,
    hmaster6,
    hmastlock6,
    hrdata6,
    hready6,
    hresp6,
    
    // APB6 system interface
    pclk6,
    n_preset6,
    
    // SPI6 ports6
    n_ss_in6,
    mi6,
    si6,
    sclk_in6,
    so,
    mo6,
    sclk_out6,
    n_ss_out6,
    n_so_en6,
    n_mo_en6,
    n_sclk_en6,
    n_ss_en6,
    
    //UART06 ports6
    ua_rxd6,
    ua_ncts6,
    ua_txd6,
    ua_nrts6,
    
    //UART16 ports6
    ua_rxd16,
    ua_ncts16,
    ua_txd16,
    ua_nrts16,
    
    //GPIO6 ports6
    gpio_pin_in6,
    n_gpio_pin_oe6,
    gpio_pin_out6,
    

    //SMC6 ports6
    smc_hclk6,
    smc_n_hclk6,
    smc_haddr6,
    smc_htrans6,
    smc_hsel6,
    smc_hwrite6,
    smc_hsize6,
    smc_hwdata6,
    smc_hready_in6,
    smc_hburst6,
    smc_hprot6,
    smc_hmaster6,
    smc_hmastlock6,
    smc_hrdata6, 
    smc_hready6,
    smc_hresp6,
    smc_n_ext_oe6,
    smc_data6,
    smc_addr6,
    smc_n_be6,
    smc_n_cs6, 
    smc_n_we6,
    smc_n_wr6,
    smc_n_rd6,
    data_smc6,
    
    //PMC6 ports6
    clk_SRPG_macb0_en6,
    clk_SRPG_macb1_en6,
    clk_SRPG_macb2_en6,
    clk_SRPG_macb3_en6,
    core06v6,
    core08v6,
    core10v6,
    core12v6,
    macb3_wakeup6,
    macb2_wakeup6,
    macb1_wakeup6,
    macb0_wakeup6,
    mte_smc_start6,
    mte_uart_start6,
    mte_smc_uart_start6,  
    mte_pm_smc_to_default_start6, 
    mte_pm_uart_to_default_start6,
    mte_pm_smc_uart_to_default_start6,
    
    
    // Peripheral6 inerrupts6
    pcm_irq6,
    ttc_irq6,
    gpio_irq6,
    uart0_irq6,
    uart1_irq6,
    spi_irq6,
    DMA_irq6,      
    macb0_int6,
    macb1_int6,
    macb2_int6,
    macb3_int6,
   
    // Scan6 ports6
    scan_en6,      // Scan6 enable pin6
    scan_in_16,    // Scan6 input for first chain6
    scan_in_26,    // Scan6 input for second chain6
    scan_mode6,
    scan_out_16,   // Scan6 out for chain6 1
    scan_out_26    // Scan6 out for chain6 2
);

parameter GPIO_WIDTH6 = 16;        // GPIO6 width
parameter P_SIZE6 =   8;              // number6 of peripheral6 select6 lines6
parameter NO_OF_IRQS6  = 17;      //No of irqs6 read by apic6 

// AHB6 interface
input         hclk6;     // AHB6 Clock6
input         n_hreset6;  // AHB6 reset - Active6 low6
input         hsel6;     // AHB2APB6 select6
input [31:0]  haddr6;    // Address bus
input [1:0]   htrans6;   // Transfer6 type
input [2:0]   hsize6;    // AHB6 Access type - byte, half6-word6, word6
input [31:0]  hwdata6;   // Write data
input         hwrite6;   // Write signal6/
input         hready_in6;// Indicates6 that last master6 has finished6 bus access
input [2:0]   hburst6;     // Burst type
input [3:0]   hprot6;      // Protection6 control6
input [3:0]   hmaster6;    // Master6 select6
input         hmastlock6;  // Locked6 transfer6
output [31:0] hrdata6;       // Read data provided from target slave6
output        hready6;       // Ready6 for new bus cycle from target slave6
output [1:0]  hresp6;       // Response6 from the bridge6
    
// APB6 system interface
input         pclk6;     // APB6 Clock6. 
input         n_preset6;  // APB6 reset - Active6 low6
   
// SPI6 ports6
input     n_ss_in6;      // select6 input to slave6
input     mi6;           // data input to master6
input     si6;           // data input to slave6
input     sclk_in6;      // clock6 input to slave6
output    so;                    // data output from slave6
output    mo6;                    // data output from master6
output    sclk_out6;              // clock6 output from master6
output [P_SIZE6-1:0] n_ss_out6;    // peripheral6 select6 lines6 from master6
output    n_so_en6;               // out enable for slave6 data
output    n_mo_en6;               // out enable for master6 data
output    n_sclk_en6;             // out enable for master6 clock6
output    n_ss_en6;               // out enable for master6 peripheral6 lines6

//UART06 ports6
input        ua_rxd6;       // UART6 receiver6 serial6 input pin6
input        ua_ncts6;      // Clear-To6-Send6 flow6 control6
output       ua_txd6;       	// UART6 transmitter6 serial6 output
output       ua_nrts6;      	// Request6-To6-Send6 flow6 control6

// UART16 ports6   
input        ua_rxd16;      // UART6 receiver6 serial6 input pin6
input        ua_ncts16;      // Clear-To6-Send6 flow6 control6
output       ua_txd16;       // UART6 transmitter6 serial6 output
output       ua_nrts16;      // Request6-To6-Send6 flow6 control6

//GPIO6 ports6
input [GPIO_WIDTH6-1:0]      gpio_pin_in6;             // input data from pin6
output [GPIO_WIDTH6-1:0]     n_gpio_pin_oe6;           // output enable signal6 to pin6
output [GPIO_WIDTH6-1:0]     gpio_pin_out6;            // output signal6 to pin6
  
//SMC6 ports6
input        smc_hclk6;
input        smc_n_hclk6;
input [31:0] smc_haddr6;
input [1:0]  smc_htrans6;
input        smc_hsel6;
input        smc_hwrite6;
input [2:0]  smc_hsize6;
input [31:0] smc_hwdata6;
input        smc_hready_in6;
input [2:0]  smc_hburst6;     // Burst type
input [3:0]  smc_hprot6;      // Protection6 control6
input [3:0]  smc_hmaster6;    // Master6 select6
input        smc_hmastlock6;  // Locked6 transfer6
input [31:0] data_smc6;     // EMI6(External6 memory) read data
output [31:0]    smc_hrdata6;
output           smc_hready6;
output [1:0]     smc_hresp6;
output [15:0]    smc_addr6;      // External6 Memory (EMI6) address
output [3:0]     smc_n_be6;      // EMI6 byte enables6 (Active6 LOW6)
output           smc_n_cs6;      // EMI6 Chip6 Selects6 (Active6 LOW6)
output [3:0]     smc_n_we6;      // EMI6 write strobes6 (Active6 LOW6)
output           smc_n_wr6;      // EMI6 write enable (Active6 LOW6)
output           smc_n_rd6;      // EMI6 read stobe6 (Active6 LOW6)
output           smc_n_ext_oe6;  // EMI6 write data output enable
output [31:0]    smc_data6;      // EMI6 write data
       
//PMC6 ports6
output clk_SRPG_macb0_en6;
output clk_SRPG_macb1_en6;
output clk_SRPG_macb2_en6;
output clk_SRPG_macb3_en6;
output core06v6;
output core08v6;
output core10v6;
output core12v6;
output mte_smc_start6;
output mte_uart_start6;
output mte_smc_uart_start6;  
output mte_pm_smc_to_default_start6; 
output mte_pm_uart_to_default_start6;
output mte_pm_smc_uart_to_default_start6;
input macb3_wakeup6;
input macb2_wakeup6;
input macb1_wakeup6;
input macb0_wakeup6;
    

// Peripheral6 interrupts6
output pcm_irq6;
output [2:0] ttc_irq6;
output gpio_irq6;
output uart0_irq6;
output uart1_irq6;
output spi_irq6;
input        macb0_int6;
input        macb1_int6;
input        macb2_int6;
input        macb3_int6;
input        DMA_irq6;
  
//Scan6 ports6
input        scan_en6;    // Scan6 enable pin6
input        scan_in_16;  // Scan6 input for first chain6
input        scan_in_26;  // Scan6 input for second chain6
input        scan_mode6;  // test mode pin6
 output        scan_out_16;   // Scan6 out for chain6 1
 output        scan_out_26;   // Scan6 out for chain6 2  

//------------------------------------------------------------------------------
// if the ROM6 subsystem6 is NOT6 black6 boxed6 
//------------------------------------------------------------------------------
`ifndef FV_KIT_BLACK_BOX_APB_SUBSYSTEM6
   
   wire        hsel6; 
   wire        pclk6;
   wire        n_preset6;
   wire [31:0] prdata_spi6;
   wire [31:0] prdata_uart06;
   wire [31:0] prdata_gpio6;
   wire [31:0] prdata_ttc6;
   wire [31:0] prdata_smc6;
   wire [31:0] prdata_pmc6;
   wire [31:0] prdata_uart16;
   wire        pready_spi6;
   wire        pready_uart06;
   wire        pready_uart16;
   wire        tie_hi_bit6;
   wire  [31:0] hrdata6; 
   wire         hready6;
   wire         hready_in6;
   wire  [1:0]  hresp6;   
   wire  [31:0] pwdata6;  
   wire         pwrite6;
   wire  [31:0] paddr6;  
   wire   psel_spi6;
   wire   psel_uart06;
   wire   psel_gpio6;
   wire   psel_ttc6;
   wire   psel_smc6;
   wire   psel076;
   wire   psel086;
   wire   psel096;
   wire   psel106;
   wire   psel116;
   wire   psel126;
   wire   psel_pmc6;
   wire   psel_uart16;
   wire   penable6;
   wire   [NO_OF_IRQS6:0] int_source6;     // System6 Interrupt6 Sources6
   wire [1:0]             smc_hresp6;     // AHB6 Response6 signal6
   wire                   smc_valid6;     // Ack6 valid address

  //External6 memory interface (EMI6)
  wire [31:0]            smc_addr_int6;  // External6 Memory (EMI6) address
  wire [3:0]             smc_n_be6;      // EMI6 byte enables6 (Active6 LOW6)
  wire                   smc_n_cs6;      // EMI6 Chip6 Selects6 (Active6 LOW6)
  wire [3:0]             smc_n_we6;      // EMI6 write strobes6 (Active6 LOW6)
  wire                   smc_n_wr6;      // EMI6 write enable (Active6 LOW6)
  wire                   smc_n_rd6;      // EMI6 read stobe6 (Active6 LOW6)
 
  //AHB6 Memory Interface6 Control6
  wire                   smc_hsel_int6;
  wire                   smc_busy6;      // smc6 busy
   

//scan6 signals6

   wire                scan_in_16;        //scan6 input
   wire                scan_in_26;        //scan6 input
   wire                scan_en6;         //scan6 enable
   wire                scan_out_16;       //scan6 output
   wire                scan_out_26;       //scan6 output
   wire                byte_sel6;     // byte select6 from bridge6 1=byte, 0=2byte
   wire                UART_int6;     // UART6 module interrupt6 
   wire                ua_uclken6;    // Soft6 control6 of clock6
   wire                UART_int16;     // UART6 module interrupt6 
   wire                ua_uclken16;    // Soft6 control6 of clock6
   wire  [3:1]         TTC_int6;            //Interrupt6 from PCI6 
  // inputs6 to SPI6 
   wire    ext_clk6;                // external6 clock6
   wire    SPI_int6;             // interrupt6 request
  // outputs6 from SPI6
   wire    slave_out_clk6;         // modified slave6 clock6 output
 // gpio6 generic6 inputs6 
   wire  [GPIO_WIDTH6-1:0]   n_gpio_bypass_oe6;        // bypass6 mode enable 
   wire  [GPIO_WIDTH6-1:0]   gpio_bypass_out6;         // bypass6 mode output value 
   wire  [GPIO_WIDTH6-1:0]   tri_state_enable6;   // disables6 op enable -> z 
 // outputs6 
   //amba6 outputs6 
   // gpio6 generic6 outputs6 
   wire       GPIO_int6;                // gpio_interupt6 for input pin6 change 
   wire [GPIO_WIDTH6-1:0]     gpio_bypass_in6;          // bypass6 mode input data value  
                
   wire           cpu_debug6;        // Inhibits6 watchdog6 counter 
   wire            ex_wdz_n6;         // External6 Watchdog6 zero indication6
   wire           rstn_non_srpg_smc6; 
   wire           rstn_non_srpg_urt6;
   wire           isolate_smc6;
   wire           save_edge_smc6;
   wire           restore_edge_smc6;
   wire           save_edge_urt6;
   wire           restore_edge_urt6;
   wire           pwr1_on_smc6;
   wire           pwr2_on_smc6;
   wire           pwr1_on_urt6;
   wire           pwr2_on_urt6;
   // ETH06
   wire            rstn_non_srpg_macb06;
   wire            gate_clk_macb06;
   wire            isolate_macb06;
   wire            save_edge_macb06;
   wire            restore_edge_macb06;
   wire            pwr1_on_macb06;
   wire            pwr2_on_macb06;
   // ETH16
   wire            rstn_non_srpg_macb16;
   wire            gate_clk_macb16;
   wire            isolate_macb16;
   wire            save_edge_macb16;
   wire            restore_edge_macb16;
   wire            pwr1_on_macb16;
   wire            pwr2_on_macb16;
   // ETH26
   wire            rstn_non_srpg_macb26;
   wire            gate_clk_macb26;
   wire            isolate_macb26;
   wire            save_edge_macb26;
   wire            restore_edge_macb26;
   wire            pwr1_on_macb26;
   wire            pwr2_on_macb26;
   // ETH36
   wire            rstn_non_srpg_macb36;
   wire            gate_clk_macb36;
   wire            isolate_macb36;
   wire            save_edge_macb36;
   wire            restore_edge_macb36;
   wire            pwr1_on_macb36;
   wire            pwr2_on_macb36;


   wire           pclk_SRPG_smc6;
   wire           pclk_SRPG_urt6;
   wire           gate_clk_smc6;
   wire           gate_clk_urt6;
   wire  [31:0]   tie_lo_32bit6; 
   wire  [1:0]	  tie_lo_2bit6;
   wire  	  tie_lo_1bit6;
   wire           pcm_macb_wakeup_int6;
   wire           int_source_h6;
   wire           isolate_mem6;

assign pcm_irq6 = pcm_macb_wakeup_int6;
assign ttc_irq6[2] = TTC_int6[3];
assign ttc_irq6[1] = TTC_int6[2];
assign ttc_irq6[0] = TTC_int6[1];
assign gpio_irq6 = GPIO_int6;
assign uart0_irq6 = UART_int6;
assign uart1_irq6 = UART_int16;
assign spi_irq6 = SPI_int6;

assign n_mo_en6   = 1'b0;
assign n_so_en6   = 1'b1;
assign n_sclk_en6 = 1'b0;
assign n_ss_en6   = 1'b0;

assign smc_hsel_int6 = smc_hsel6;
  assign ext_clk6  = 1'b0;
  assign int_source6 = {macb0_int6,macb1_int6, macb2_int6, macb3_int6,1'b0, pcm_macb_wakeup_int6, 1'b0, 1'b0, 1'b0, 1'b0, TTC_int6, GPIO_int6, UART_int6, UART_int16, SPI_int6, DMA_irq6};

  // interrupt6 even6 detect6 .
  // for sleep6 wake6 up -> any interrupt6 even6 and system not in hibernation6 (isolate_mem6 = 0)
  // for hibernate6 wake6 up -> gpio6 interrupt6 even6 and system in the hibernation6 (isolate_mem6 = 1)
  assign int_source_h6 =  ((|int_source6) && (!isolate_mem6)) || (isolate_mem6 && GPIO_int6) ;

  assign byte_sel6 = 1'b1;
  assign tie_hi_bit6 = 1'b1;

  assign smc_addr6 = smc_addr_int6[15:0];



  assign  n_gpio_bypass_oe6 = {GPIO_WIDTH6{1'b0}};        // bypass6 mode enable 
  assign  gpio_bypass_out6  = {GPIO_WIDTH6{1'b0}};
  assign  tri_state_enable6 = {GPIO_WIDTH6{1'b0}};
  assign  cpu_debug6 = 1'b0;
  assign  tie_lo_32bit6 = 32'b0;
  assign  tie_lo_2bit6  = 2'b0;
  assign  tie_lo_1bit6  = 1'b0;


ahb2apb6 #(
  32'h00800000, // Slave6 0 Address Range6
  32'h0080FFFF,

  32'h00810000, // Slave6 1 Address Range6
  32'h0081FFFF,

  32'h00820000, // Slave6 2 Address Range6 
  32'h0082FFFF,

  32'h00830000, // Slave6 3 Address Range6
  32'h0083FFFF,

  32'h00840000, // Slave6 4 Address Range6
  32'h0084FFFF,

  32'h00850000, // Slave6 5 Address Range6
  32'h0085FFFF,

  32'h00860000, // Slave6 6 Address Range6
  32'h0086FFFF,

  32'h00870000, // Slave6 7 Address Range6
  32'h0087FFFF,

  32'h00880000, // Slave6 8 Address Range6
  32'h0088FFFF
) i_ahb2apb6 (
     // AHB6 interface
    .hclk6(hclk6),         
    .hreset_n6(n_hreset6), 
    .hsel6(hsel6), 
    .haddr6(haddr6),        
    .htrans6(htrans6),       
    .hwrite6(hwrite6),       
    .hwdata6(hwdata6),       
    .hrdata6(hrdata6),   
    .hready6(hready6),   
    .hresp6(hresp6),     
    
     // APB6 interface
    .pclk6(pclk6),         
    .preset_n6(n_preset6),  
    .prdata06(prdata_spi6),
    .prdata16(prdata_uart06), 
    .prdata26(prdata_gpio6),  
    .prdata36(prdata_ttc6),   
    .prdata46(32'h0),   
    .prdata56(prdata_smc6),   
    .prdata66(prdata_pmc6),    
    .prdata76(32'h0),   
    .prdata86(prdata_uart16),  
    .pready06(pready_spi6),     
    .pready16(pready_uart06),   
    .pready26(tie_hi_bit6),     
    .pready36(tie_hi_bit6),     
    .pready46(tie_hi_bit6),     
    .pready56(tie_hi_bit6),     
    .pready66(tie_hi_bit6),     
    .pready76(tie_hi_bit6),     
    .pready86(pready_uart16),  
    .pwdata6(pwdata6),       
    .pwrite6(pwrite6),       
    .paddr6(paddr6),        
    .psel06(psel_spi6),     
    .psel16(psel_uart06),   
    .psel26(psel_gpio6),    
    .psel36(psel_ttc6),     
    .psel46(),     
    .psel56(psel_smc6),     
    .psel66(psel_pmc6),    
    .psel76(psel_apic6),   
    .psel86(psel_uart16),  
    .penable6(penable6)     
);

spi_top6 i_spi6
(
  // Wishbone6 signals6
  .wb_clk_i6(pclk6), 
  .wb_rst_i6(~n_preset6), 
  .wb_adr_i6(paddr6[4:0]), 
  .wb_dat_i6(pwdata6), 
  .wb_dat_o6(prdata_spi6), 
  .wb_sel_i6(4'b1111),    // SPI6 register accesses are always 32-bit
  .wb_we_i6(pwrite6), 
  .wb_stb_i6(psel_spi6), 
  .wb_cyc_i6(psel_spi6), 
  .wb_ack_o6(pready_spi6), 
  .wb_err_o6(), 
  .wb_int_o6(SPI_int6),

  // SPI6 signals6
  .ss_pad_o6(n_ss_out6), 
  .sclk_pad_o6(sclk_out6), 
  .mosi_pad_o6(mo6), 
  .miso_pad_i6(mi6)
);

// Opencores6 UART6 instances6
wire ua_nrts_int6;
wire ua_nrts1_int6;

assign ua_nrts6 = ua_nrts_int6;
assign ua_nrts16 = ua_nrts1_int6;

reg [3:0] uart0_sel_i6;
reg [3:0] uart1_sel_i6;
// UART6 registers are all 8-bit wide6, and their6 addresses6
// are on byte boundaries6. So6 to access them6 on the
// Wishbone6 bus, the CPU6 must do byte accesses to these6
// byte addresses6. Word6 address accesses are not possible6
// because the word6 addresses6 will be unaligned6, and cause
// a fault6.
// So6, Uart6 accesses from the CPU6 will always be 8-bit size
// We6 only have to decide6 which byte of the 4-byte word6 the
// CPU6 is interested6 in.
`ifdef SYSTEM_BIG_ENDIAN6
always @(paddr6) begin
  case (paddr6[1:0])
    2'b00 : uart0_sel_i6 = 4'b1000;
    2'b01 : uart0_sel_i6 = 4'b0100;
    2'b10 : uart0_sel_i6 = 4'b0010;
    2'b11 : uart0_sel_i6 = 4'b0001;
  endcase
end
always @(paddr6) begin
  case (paddr6[1:0])
    2'b00 : uart1_sel_i6 = 4'b1000;
    2'b01 : uart1_sel_i6 = 4'b0100;
    2'b10 : uart1_sel_i6 = 4'b0010;
    2'b11 : uart1_sel_i6 = 4'b0001;
  endcase
end
`else
always @(paddr6) begin
  case (paddr6[1:0])
    2'b00 : uart0_sel_i6 = 4'b0001;
    2'b01 : uart0_sel_i6 = 4'b0010;
    2'b10 : uart0_sel_i6 = 4'b0100;
    2'b11 : uart0_sel_i6 = 4'b1000;
  endcase
end
always @(paddr6) begin
  case (paddr6[1:0])
    2'b00 : uart1_sel_i6 = 4'b0001;
    2'b01 : uart1_sel_i6 = 4'b0010;
    2'b10 : uart1_sel_i6 = 4'b0100;
    2'b11 : uart1_sel_i6 = 4'b1000;
  endcase
end
`endif

uart_top6 i_oc_uart06 (
  .wb_clk_i6(pclk6),
  .wb_rst_i6(~n_preset6),
  .wb_adr_i6(paddr6[4:0]),
  .wb_dat_i6(pwdata6),
  .wb_dat_o6(prdata_uart06),
  .wb_we_i6(pwrite6),
  .wb_stb_i6(psel_uart06),
  .wb_cyc_i6(psel_uart06),
  .wb_ack_o6(pready_uart06),
  .wb_sel_i6(uart0_sel_i6),
  .int_o6(UART_int6),
  .stx_pad_o6(ua_txd6),
  .srx_pad_i6(ua_rxd6),
  .rts_pad_o6(ua_nrts_int6),
  .cts_pad_i6(ua_ncts6),
  .dtr_pad_o6(),
  .dsr_pad_i6(1'b0),
  .ri_pad_i6(1'b0),
  .dcd_pad_i6(1'b0)
);

uart_top6 i_oc_uart16 (
  .wb_clk_i6(pclk6),
  .wb_rst_i6(~n_preset6),
  .wb_adr_i6(paddr6[4:0]),
  .wb_dat_i6(pwdata6),
  .wb_dat_o6(prdata_uart16),
  .wb_we_i6(pwrite6),
  .wb_stb_i6(psel_uart16),
  .wb_cyc_i6(psel_uart16),
  .wb_ack_o6(pready_uart16),
  .wb_sel_i6(uart1_sel_i6),
  .int_o6(UART_int16),
  .stx_pad_o6(ua_txd16),
  .srx_pad_i6(ua_rxd16),
  .rts_pad_o6(ua_nrts1_int6),
  .cts_pad_i6(ua_ncts16),
  .dtr_pad_o6(),
  .dsr_pad_i6(1'b0),
  .ri_pad_i6(1'b0),
  .dcd_pad_i6(1'b0)
);

gpio_veneer6 i_gpio_veneer6 (
        //inputs6

        . n_p_reset6(n_preset6),
        . pclk6(pclk6),
        . psel6(psel_gpio6),
        . penable6(penable6),
        . pwrite6(pwrite6),
        . paddr6(paddr6[5:0]),
        . pwdata6(pwdata6),
        . gpio_pin_in6(gpio_pin_in6),
        . scan_en6(scan_en6),
        . tri_state_enable6(tri_state_enable6),
        . scan_in6(), //added by smarkov6 for dft6

        //outputs6
        . scan_out6(), //added by smarkov6 for dft6
        . prdata6(prdata_gpio6),
        . gpio_int6(GPIO_int6),
        . n_gpio_pin_oe6(n_gpio_pin_oe6),
        . gpio_pin_out6(gpio_pin_out6)
);


ttc_veneer6 i_ttc_veneer6 (

         //inputs6
        . n_p_reset6(n_preset6),
        . pclk6(pclk6),
        . psel6(psel_ttc6),
        . penable6(penable6),
        . pwrite6(pwrite6),
        . pwdata6(pwdata6),
        . paddr6(paddr6[7:0]),
        . scan_in6(),
        . scan_en6(scan_en6),

        //outputs6
        . prdata6(prdata_ttc6),
        . interrupt6(TTC_int6[3:1]),
        . scan_out6()
);


smc_veneer6 i_smc_veneer6 (
        //inputs6
	//apb6 inputs6
        . n_preset6(n_preset6),
        . pclk6(pclk_SRPG_smc6),
        . psel6(psel_smc6),
        . penable6(penable6),
        . pwrite6(pwrite6),
        . paddr6(paddr6[4:0]),
        . pwdata6(pwdata6),
        //ahb6 inputs6
	. hclk6(smc_hclk6),
        . n_sys_reset6(rstn_non_srpg_smc6),
        . haddr6(smc_haddr6),
        . htrans6(smc_htrans6),
        . hsel6(smc_hsel_int6),
        . hwrite6(smc_hwrite6),
	. hsize6(smc_hsize6),
        . hwdata6(smc_hwdata6),
        . hready6(smc_hready_in6),
        . data_smc6(data_smc6),

         //test signal6 inputs6

        . scan_in_16(),
        . scan_in_26(),
        . scan_in_36(),
        . scan_en6(scan_en6),

        //apb6 outputs6
        . prdata6(prdata_smc6),

       //design output

        . smc_hrdata6(smc_hrdata6),
        . smc_hready6(smc_hready6),
        . smc_hresp6(smc_hresp6),
        . smc_valid6(smc_valid6),
        . smc_addr6(smc_addr_int6),
        . smc_data6(smc_data6),
        . smc_n_be6(smc_n_be6),
        . smc_n_cs6(smc_n_cs6),
        . smc_n_wr6(smc_n_wr6),
        . smc_n_we6(smc_n_we6),
        . smc_n_rd6(smc_n_rd6),
        . smc_n_ext_oe6(smc_n_ext_oe6),
        . smc_busy6(smc_busy6),

         //test signal6 output
        . scan_out_16(),
        . scan_out_26(),
        . scan_out_36()
);

power_ctrl_veneer6 i_power_ctrl_veneer6 (
    // -- Clocks6 & Reset6
    	.pclk6(pclk6), 			//  : in  std_logic6;
    	.nprst6(n_preset6), 		//  : in  std_logic6;
    // -- APB6 programming6 interface
    	.paddr6(paddr6), 			//  : in  std_logic_vector6(31 downto6 0);
    	.psel6(psel_pmc6), 			//  : in  std_logic6;
    	.penable6(penable6), 		//  : in  std_logic6;
    	.pwrite6(pwrite6), 		//  : in  std_logic6;
    	.pwdata6(pwdata6), 		//  : in  std_logic_vector6(31 downto6 0);
    	.prdata6(prdata_pmc6), 		//  : out std_logic_vector6(31 downto6 0);
        .macb3_wakeup6(macb3_wakeup6),
        .macb2_wakeup6(macb2_wakeup6),
        .macb1_wakeup6(macb1_wakeup6),
        .macb0_wakeup6(macb0_wakeup6),
    // -- Module6 control6 outputs6
    	.scan_in6(),			//  : in  std_logic6;
    	.scan_en6(scan_en6),             	//  : in  std_logic6;
    	.scan_mode6(scan_mode6),          //  : in  std_logic6;
    	.scan_out6(),            	//  : out std_logic6;
        .int_source_h6(int_source_h6),
     	.rstn_non_srpg_smc6(rstn_non_srpg_smc6), 		//   : out std_logic6;
    	.gate_clk_smc6(gate_clk_smc6), 	//  : out std_logic6;
    	.isolate_smc6(isolate_smc6), 	//  : out std_logic6;
    	.save_edge_smc6(save_edge_smc6), 	//  : out std_logic6;
    	.restore_edge_smc6(restore_edge_smc6), 	//  : out std_logic6;
    	.pwr1_on_smc6(pwr1_on_smc6), 	//  : out std_logic6;
    	.pwr2_on_smc6(pwr2_on_smc6), 	//  : out std_logic6
     	.rstn_non_srpg_urt6(rstn_non_srpg_urt6), 		//   : out std_logic6;
    	.gate_clk_urt6(gate_clk_urt6), 	//  : out std_logic6;
    	.isolate_urt6(isolate_urt6), 	//  : out std_logic6;
    	.save_edge_urt6(save_edge_urt6), 	//  : out std_logic6;
    	.restore_edge_urt6(restore_edge_urt6), 	//  : out std_logic6;
    	.pwr1_on_urt6(pwr1_on_urt6), 	//  : out std_logic6;
    	.pwr2_on_urt6(pwr2_on_urt6),  	//  : out std_logic6
        // ETH06
        .rstn_non_srpg_macb06(rstn_non_srpg_macb06),
        .gate_clk_macb06(gate_clk_macb06),
        .isolate_macb06(isolate_macb06),
        .save_edge_macb06(save_edge_macb06),
        .restore_edge_macb06(restore_edge_macb06),
        .pwr1_on_macb06(pwr1_on_macb06),
        .pwr2_on_macb06(pwr2_on_macb06),
        // ETH16
        .rstn_non_srpg_macb16(rstn_non_srpg_macb16),
        .gate_clk_macb16(gate_clk_macb16),
        .isolate_macb16(isolate_macb16),
        .save_edge_macb16(save_edge_macb16),
        .restore_edge_macb16(restore_edge_macb16),
        .pwr1_on_macb16(pwr1_on_macb16),
        .pwr2_on_macb16(pwr2_on_macb16),
        // ETH26
        .rstn_non_srpg_macb26(rstn_non_srpg_macb26),
        .gate_clk_macb26(gate_clk_macb26),
        .isolate_macb26(isolate_macb26),
        .save_edge_macb26(save_edge_macb26),
        .restore_edge_macb26(restore_edge_macb26),
        .pwr1_on_macb26(pwr1_on_macb26),
        .pwr2_on_macb26(pwr2_on_macb26),
        // ETH36
        .rstn_non_srpg_macb36(rstn_non_srpg_macb36),
        .gate_clk_macb36(gate_clk_macb36),
        .isolate_macb36(isolate_macb36),
        .save_edge_macb36(save_edge_macb36),
        .restore_edge_macb36(restore_edge_macb36),
        .pwr1_on_macb36(pwr1_on_macb36),
        .pwr2_on_macb36(pwr2_on_macb36),
        .core06v6(core06v6),
        .core08v6(core08v6),
        .core10v6(core10v6),
        .core12v6(core12v6),
        .pcm_macb_wakeup_int6(pcm_macb_wakeup_int6),
        .isolate_mem6(isolate_mem6),
        .mte_smc_start6(mte_smc_start6),
        .mte_uart_start6(mte_uart_start6),
        .mte_smc_uart_start6(mte_smc_uart_start6),  
        .mte_pm_smc_to_default_start6(mte_pm_smc_to_default_start6), 
        .mte_pm_uart_to_default_start6(mte_pm_uart_to_default_start6),
        .mte_pm_smc_uart_to_default_start6(mte_pm_smc_uart_to_default_start6)
);

// Clock6 gating6 macro6 to shut6 off6 clocks6 to the SRPG6 flops6 in the SMC6
//CKLNQD16 i_SMC_SRPG_clk_gate6  (
//	.TE6(scan_mode6), 
//	.E6(~gate_clk_smc6), 
//	.CP6(pclk6), 
//	.Q6(pclk_SRPG_smc6)
//	);
// Replace6 gate6 with behavioural6 code6 //
wire 	smc_scan_gate6;
reg 	smc_latched_enable6;
assign smc_scan_gate6 = scan_mode6 ? 1'b1 : ~gate_clk_smc6;

always @ (pclk6 or smc_scan_gate6)
  	if (pclk6 == 1'b0) begin
  		smc_latched_enable6 <= smc_scan_gate6;
  	end  	
	
assign pclk_SRPG_smc6 = smc_latched_enable6 ? pclk6 : 1'b0;


// Clock6 gating6 macro6 to shut6 off6 clocks6 to the SRPG6 flops6 in the URT6
//CKLNQD16 i_URT_SRPG_clk_gate6  (
//	.TE6(scan_mode6), 
//	.E6(~gate_clk_urt6), 
//	.CP6(pclk6), 
//	.Q6(pclk_SRPG_urt6)
//	);
// Replace6 gate6 with behavioural6 code6 //
wire 	urt_scan_gate6;
reg 	urt_latched_enable6;
assign urt_scan_gate6 = scan_mode6 ? 1'b1 : ~gate_clk_urt6;

always @ (pclk6 or urt_scan_gate6)
  	if (pclk6 == 1'b0) begin
  		urt_latched_enable6 <= urt_scan_gate6;
  	end  	
	
assign pclk_SRPG_urt6 = urt_latched_enable6 ? pclk6 : 1'b0;

// ETH06
wire 	macb0_scan_gate6;
reg 	macb0_latched_enable6;
assign macb0_scan_gate6 = scan_mode6 ? 1'b1 : ~gate_clk_macb06;

always @ (pclk6 or macb0_scan_gate6)
  	if (pclk6 == 1'b0) begin
  		macb0_latched_enable6 <= macb0_scan_gate6;
  	end  	
	
assign clk_SRPG_macb0_en6 = macb0_latched_enable6 ? 1'b1 : 1'b0;

// ETH16
wire 	macb1_scan_gate6;
reg 	macb1_latched_enable6;
assign macb1_scan_gate6 = scan_mode6 ? 1'b1 : ~gate_clk_macb16;

always @ (pclk6 or macb1_scan_gate6)
  	if (pclk6 == 1'b0) begin
  		macb1_latched_enable6 <= macb1_scan_gate6;
  	end  	
	
assign clk_SRPG_macb1_en6 = macb1_latched_enable6 ? 1'b1 : 1'b0;

// ETH26
wire 	macb2_scan_gate6;
reg 	macb2_latched_enable6;
assign macb2_scan_gate6 = scan_mode6 ? 1'b1 : ~gate_clk_macb26;

always @ (pclk6 or macb2_scan_gate6)
  	if (pclk6 == 1'b0) begin
  		macb2_latched_enable6 <= macb2_scan_gate6;
  	end  	
	
assign clk_SRPG_macb2_en6 = macb2_latched_enable6 ? 1'b1 : 1'b0;

// ETH36
wire 	macb3_scan_gate6;
reg 	macb3_latched_enable6;
assign macb3_scan_gate6 = scan_mode6 ? 1'b1 : ~gate_clk_macb36;

always @ (pclk6 or macb3_scan_gate6)
  	if (pclk6 == 1'b0) begin
  		macb3_latched_enable6 <= macb3_scan_gate6;
  	end  	
	
assign clk_SRPG_macb3_en6 = macb3_latched_enable6 ? 1'b1 : 1'b0;



`else
//------------------------------------------------------------------------------
// if the APB6 subsystem6 is black6 boxed6 
//------------------------------------------------------------------------------
// wire s ports6
    // system signals6
    wire         hclk6;     // AHB6 Clock6
    wire         n_hreset6;  // AHB6 reset - Active6 low6
    wire         pclk6;     // APB6 Clock6. 
    wire         n_preset6;  // APB6 reset - Active6 low6

    // AHB6 interface
    wire         ahb2apb0_hsel6;     // AHB2APB6 select6
    wire  [31:0] haddr6;    // Address bus
    wire  [1:0]  htrans6;   // Transfer6 type
    wire  [2:0]  hsize6;    // AHB6 Access type - byte, half6-word6, word6
    wire  [31:0] hwdata6;   // Write data
    wire         hwrite6;   // Write signal6/
    wire         hready_in6;// Indicates6 that last master6 has finished6 bus access
    wire [2:0]   hburst6;     // Burst type
    wire [3:0]   hprot6;      // Protection6 control6
    wire [3:0]   hmaster6;    // Master6 select6
    wire         hmastlock6;  // Locked6 transfer6
  // Interrupts6 from the Enet6 MACs6
    wire         macb0_int6;
    wire         macb1_int6;
    wire         macb2_int6;
    wire         macb3_int6;
  // Interrupt6 from the DMA6
    wire         DMA_irq6;
  // Scan6 wire s
    wire         scan_en6;    // Scan6 enable pin6
    wire         scan_in_16;  // Scan6 wire  for first chain6
    wire         scan_in_26;  // Scan6 wire  for second chain6
    wire         scan_mode6;  // test mode pin6
 
  //wire  for smc6 AHB6 interface
    wire         smc_hclk6;
    wire         smc_n_hclk6;
    wire  [31:0] smc_haddr6;
    wire  [1:0]  smc_htrans6;
    wire         smc_hsel6;
    wire         smc_hwrite6;
    wire  [2:0]  smc_hsize6;
    wire  [31:0] smc_hwdata6;
    wire         smc_hready_in6;
    wire  [2:0]  smc_hburst6;     // Burst type
    wire  [3:0]  smc_hprot6;      // Protection6 control6
    wire  [3:0]  smc_hmaster6;    // Master6 select6
    wire         smc_hmastlock6;  // Locked6 transfer6


    wire  [31:0] data_smc6;     // EMI6(External6 memory) read data
    
  //wire s for uart6
    wire         ua_rxd6;       // UART6 receiver6 serial6 wire  pin6
    wire         ua_rxd16;      // UART6 receiver6 serial6 wire  pin6
    wire         ua_ncts6;      // Clear-To6-Send6 flow6 control6
    wire         ua_ncts16;      // Clear-To6-Send6 flow6 control6
   //wire s for spi6
    wire         n_ss_in6;      // select6 wire  to slave6
    wire         mi6;           // data wire  to master6
    wire         si6;           // data wire  to slave6
    wire         sclk_in6;      // clock6 wire  to slave6
  //wire s for GPIO6
   wire  [GPIO_WIDTH6-1:0]  gpio_pin_in6;             // wire  data from pin6

  //reg    ports6
  // Scan6 reg   s
   reg           scan_out_16;   // Scan6 out for chain6 1
   reg           scan_out_26;   // Scan6 out for chain6 2
  //AHB6 interface 
   reg    [31:0] hrdata6;       // Read data provided from target slave6
   reg           hready6;       // Ready6 for new bus cycle from target slave6
   reg    [1:0]  hresp6;       // Response6 from the bridge6

   // SMC6 reg    for AHB6 interface
   reg    [31:0]    smc_hrdata6;
   reg              smc_hready6;
   reg    [1:0]     smc_hresp6;

  //reg   s from smc6
   reg    [15:0]    smc_addr6;      // External6 Memory (EMI6) address
   reg    [3:0]     smc_n_be6;      // EMI6 byte enables6 (Active6 LOW6)
   reg    [7:0]     smc_n_cs6;      // EMI6 Chip6 Selects6 (Active6 LOW6)
   reg    [3:0]     smc_n_we6;      // EMI6 write strobes6 (Active6 LOW6)
   reg              smc_n_wr6;      // EMI6 write enable (Active6 LOW6)
   reg              smc_n_rd6;      // EMI6 read stobe6 (Active6 LOW6)
   reg              smc_n_ext_oe6;  // EMI6 write data reg    enable
   reg    [31:0]    smc_data6;      // EMI6 write data
  //reg   s from uart6
   reg           ua_txd6;       	// UART6 transmitter6 serial6 reg   
   reg           ua_txd16;       // UART6 transmitter6 serial6 reg   
   reg           ua_nrts6;      	// Request6-To6-Send6 flow6 control6
   reg           ua_nrts16;      // Request6-To6-Send6 flow6 control6
   // reg   s from ttc6
  // reg   s from SPI6
   reg       so;                    // data reg    from slave6
   reg       mo6;                    // data reg    from master6
   reg       sclk_out6;              // clock6 reg    from master6
   reg    [P_SIZE6-1:0] n_ss_out6;    // peripheral6 select6 lines6 from master6
   reg       n_so_en6;               // out enable for slave6 data
   reg       n_mo_en6;               // out enable for master6 data
   reg       n_sclk_en6;             // out enable for master6 clock6
   reg       n_ss_en6;               // out enable for master6 peripheral6 lines6
  //reg   s from gpio6
   reg    [GPIO_WIDTH6-1:0]     n_gpio_pin_oe6;           // reg    enable signal6 to pin6
   reg    [GPIO_WIDTH6-1:0]     gpio_pin_out6;            // reg    signal6 to pin6


`endif
//------------------------------------------------------------------------------
// black6 boxed6 defines6 
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// APB6 and AHB6 interface formal6 verification6 monitors6
//------------------------------------------------------------------------------
`ifdef ABV_ON6
apb_assert6 i_apb_assert6 (

        // APB6 signals6
  	.n_preset6(n_preset6),
   	.pclk6(pclk6),
	.penable6(penable6),
	.paddr6(paddr6),
	.pwrite6(pwrite6),
	.pwdata6(pwdata6),

	.psel006(psel_spi6),
	.psel016(psel_uart06),
	.psel026(psel_gpio6),
	.psel036(psel_ttc6),
	.psel046(1'b0),
	.psel056(psel_smc6),
	.psel066(1'b0),
	.psel076(1'b0),
	.psel086(1'b0),
	.psel096(1'b0),
	.psel106(1'b0),
	.psel116(1'b0),
	.psel126(1'b0),
	.psel136(psel_pmc6),
	.psel146(psel_apic6),
	.psel156(psel_uart16),

        .prdata006(prdata_spi6),
        .prdata016(prdata_uart06), // Read Data from peripheral6 UART6 
        .prdata026(prdata_gpio6), // Read Data from peripheral6 GPIO6
        .prdata036(prdata_ttc6), // Read Data from peripheral6 TTC6
        .prdata046(32'b0), // 
        .prdata056(prdata_smc6), // Read Data from peripheral6 SMC6
        .prdata136(prdata_pmc6), // Read Data from peripheral6 Power6 Control6 Block
   	.prdata146(32'b0), // 
        .prdata156(prdata_uart16),


        // AHB6 signals6
        .hclk6(hclk6),         // ahb6 system clock6
        .n_hreset6(n_hreset6), // ahb6 system reset

        // ahb2apb6 signals6
        .hresp6(hresp6),
        .hready6(hready6),
        .hrdata6(hrdata6),
        .hwdata6(hwdata6),
        .hprot6(hprot6),
        .hburst6(hburst6),
        .hsize6(hsize6),
        .hwrite6(hwrite6),
        .htrans6(htrans6),
        .haddr6(haddr6),
        .ahb2apb_hsel6(ahb2apb0_hsel6));



//------------------------------------------------------------------------------
// AHB6 interface formal6 verification6 monitor6
//------------------------------------------------------------------------------
defparam i_ahbSlaveMonitor6.DBUS_WIDTH6 = 32;
defparam i_ahbMasterMonitor6.DBUS_WIDTH6 = 32;


// AHB2APB6 Bridge6

    ahb_liteslave_monitor6 i_ahbSlaveMonitor6 (
        .hclk_i6(hclk6),
        .hresetn_i6(n_hreset6),
        .hresp6(hresp6),
        .hready6(hready6),
        .hready_global_i6(hready6),
        .hrdata6(hrdata6),
        .hwdata_i6(hwdata6),
        .hburst_i6(hburst6),
        .hsize_i6(hsize6),
        .hwrite_i6(hwrite6),
        .htrans_i6(htrans6),
        .haddr_i6(haddr6),
        .hsel_i6(ahb2apb0_hsel6)
    );


  ahb_litemaster_monitor6 i_ahbMasterMonitor6 (
          .hclk_i6(hclk6),
          .hresetn_i6(n_hreset6),
          .hresp_i6(hresp6),
          .hready_i6(hready6),
          .hrdata_i6(hrdata6),
          .hlock6(1'b0),
          .hwdata6(hwdata6),
          .hprot6(hprot6),
          .hburst6(hburst6),
          .hsize6(hsize6),
          .hwrite6(hwrite6),
          .htrans6(htrans6),
          .haddr6(haddr6)
          );







`endif




`ifdef IFV_LP_ABV_ON6
// power6 control6
wire isolate6;

// testbench mirror signals6
wire L1_ctrl_access6;
wire L1_status_access6;

wire [31:0] L1_status_reg6;
wire [31:0] L1_ctrl_reg6;

//wire rstn_non_srpg_urt6;
//wire isolate_urt6;
//wire retain_urt6;
//wire gate_clk_urt6;
//wire pwr1_on_urt6;


// smc6 signals6
wire [31:0] smc_prdata6;
wire lp_clk_smc6;
                    

// uart6 isolation6 register
  wire [15:0] ua_prdata6;
  wire ua_int6;
  assign ua_prdata6          =  i_uart1_veneer6.prdata6;
  assign ua_int6             =  i_uart1_veneer6.ua_int6;


assign lp_clk_smc6          = i_smc_veneer6.pclk6;
assign smc_prdata6          = i_smc_veneer6.prdata6;
lp_chk_smc6 u_lp_chk_smc6 (
    .clk6 (hclk6),
    .rst6 (n_hreset6),
    .iso_smc6 (isolate_smc6),
    .gate_clk6 (gate_clk_smc6),
    .lp_clk6 (pclk_SRPG_smc6),

    // srpg6 outputs6
    .smc_hrdata6 (smc_hrdata6),
    .smc_hready6 (smc_hready6),
    .smc_hresp6  (smc_hresp6),
    .smc_valid6 (smc_valid6),
    .smc_addr_int6 (smc_addr_int6),
    .smc_data6 (smc_data6),
    .smc_n_be6 (smc_n_be6),
    .smc_n_cs6  (smc_n_cs6),
    .smc_n_wr6 (smc_n_wr6),
    .smc_n_we6 (smc_n_we6),
    .smc_n_rd6 (smc_n_rd6),
    .smc_n_ext_oe6 (smc_n_ext_oe6)
   );

// lp6 retention6/isolation6 assertions6
lp_chk_uart6 u_lp_chk_urt6 (

  .clk6         (hclk6),
  .rst6         (n_hreset6),
  .iso_urt6     (isolate_urt6),
  .gate_clk6    (gate_clk_urt6),
  .lp_clk6      (pclk_SRPG_urt6),
  //ports6
  .prdata6 (ua_prdata6),
  .ua_int6 (ua_int6),
  .ua_txd6 (ua_txd16),
  .ua_nrts6 (ua_nrts16)
 );

`endif  //IFV_LP_ABV_ON6




endmodule
