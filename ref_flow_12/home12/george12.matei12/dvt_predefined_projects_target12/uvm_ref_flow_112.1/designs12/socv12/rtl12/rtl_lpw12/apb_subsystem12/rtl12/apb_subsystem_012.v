//File12 name   : apb_subsystem_012.v
//Title12       : 
//Created12     : 1999
//Description12 : 
//Notes12       : 
//----------------------------------------------------------------------
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------

module apb_subsystem_012(
    // AHB12 interface
    hclk12,
    n_hreset12,
    hsel12,
    haddr12,
    htrans12,
    hsize12,
    hwrite12,
    hwdata12,
    hready_in12,
    hburst12,
    hprot12,
    hmaster12,
    hmastlock12,
    hrdata12,
    hready12,
    hresp12,
    
    // APB12 system interface
    pclk12,
    n_preset12,
    
    // SPI12 ports12
    n_ss_in12,
    mi12,
    si12,
    sclk_in12,
    so,
    mo12,
    sclk_out12,
    n_ss_out12,
    n_so_en12,
    n_mo_en12,
    n_sclk_en12,
    n_ss_en12,
    
    //UART012 ports12
    ua_rxd12,
    ua_ncts12,
    ua_txd12,
    ua_nrts12,
    
    //UART112 ports12
    ua_rxd112,
    ua_ncts112,
    ua_txd112,
    ua_nrts112,
    
    //GPIO12 ports12
    gpio_pin_in12,
    n_gpio_pin_oe12,
    gpio_pin_out12,
    

    //SMC12 ports12
    smc_hclk12,
    smc_n_hclk12,
    smc_haddr12,
    smc_htrans12,
    smc_hsel12,
    smc_hwrite12,
    smc_hsize12,
    smc_hwdata12,
    smc_hready_in12,
    smc_hburst12,
    smc_hprot12,
    smc_hmaster12,
    smc_hmastlock12,
    smc_hrdata12, 
    smc_hready12,
    smc_hresp12,
    smc_n_ext_oe12,
    smc_data12,
    smc_addr12,
    smc_n_be12,
    smc_n_cs12, 
    smc_n_we12,
    smc_n_wr12,
    smc_n_rd12,
    data_smc12,
    
    //PMC12 ports12
    clk_SRPG_macb0_en12,
    clk_SRPG_macb1_en12,
    clk_SRPG_macb2_en12,
    clk_SRPG_macb3_en12,
    core06v12,
    core08v12,
    core10v12,
    core12v12,
    macb3_wakeup12,
    macb2_wakeup12,
    macb1_wakeup12,
    macb0_wakeup12,
    mte_smc_start12,
    mte_uart_start12,
    mte_smc_uart_start12,  
    mte_pm_smc_to_default_start12, 
    mte_pm_uart_to_default_start12,
    mte_pm_smc_uart_to_default_start12,
    
    
    // Peripheral12 inerrupts12
    pcm_irq12,
    ttc_irq12,
    gpio_irq12,
    uart0_irq12,
    uart1_irq12,
    spi_irq12,
    DMA_irq12,      
    macb0_int12,
    macb1_int12,
    macb2_int12,
    macb3_int12,
   
    // Scan12 ports12
    scan_en12,      // Scan12 enable pin12
    scan_in_112,    // Scan12 input for first chain12
    scan_in_212,    // Scan12 input for second chain12
    scan_mode12,
    scan_out_112,   // Scan12 out for chain12 1
    scan_out_212    // Scan12 out for chain12 2
);

parameter GPIO_WIDTH12 = 16;        // GPIO12 width
parameter P_SIZE12 =   8;              // number12 of peripheral12 select12 lines12
parameter NO_OF_IRQS12  = 17;      //No of irqs12 read by apic12 

// AHB12 interface
input         hclk12;     // AHB12 Clock12
input         n_hreset12;  // AHB12 reset - Active12 low12
input         hsel12;     // AHB2APB12 select12
input [31:0]  haddr12;    // Address bus
input [1:0]   htrans12;   // Transfer12 type
input [2:0]   hsize12;    // AHB12 Access type - byte, half12-word12, word12
input [31:0]  hwdata12;   // Write data
input         hwrite12;   // Write signal12/
input         hready_in12;// Indicates12 that last master12 has finished12 bus access
input [2:0]   hburst12;     // Burst type
input [3:0]   hprot12;      // Protection12 control12
input [3:0]   hmaster12;    // Master12 select12
input         hmastlock12;  // Locked12 transfer12
output [31:0] hrdata12;       // Read data provided from target slave12
output        hready12;       // Ready12 for new bus cycle from target slave12
output [1:0]  hresp12;       // Response12 from the bridge12
    
// APB12 system interface
input         pclk12;     // APB12 Clock12. 
input         n_preset12;  // APB12 reset - Active12 low12
   
// SPI12 ports12
input     n_ss_in12;      // select12 input to slave12
input     mi12;           // data input to master12
input     si12;           // data input to slave12
input     sclk_in12;      // clock12 input to slave12
output    so;                    // data output from slave12
output    mo12;                    // data output from master12
output    sclk_out12;              // clock12 output from master12
output [P_SIZE12-1:0] n_ss_out12;    // peripheral12 select12 lines12 from master12
output    n_so_en12;               // out enable for slave12 data
output    n_mo_en12;               // out enable for master12 data
output    n_sclk_en12;             // out enable for master12 clock12
output    n_ss_en12;               // out enable for master12 peripheral12 lines12

//UART012 ports12
input        ua_rxd12;       // UART12 receiver12 serial12 input pin12
input        ua_ncts12;      // Clear-To12-Send12 flow12 control12
output       ua_txd12;       	// UART12 transmitter12 serial12 output
output       ua_nrts12;      	// Request12-To12-Send12 flow12 control12

// UART112 ports12   
input        ua_rxd112;      // UART12 receiver12 serial12 input pin12
input        ua_ncts112;      // Clear-To12-Send12 flow12 control12
output       ua_txd112;       // UART12 transmitter12 serial12 output
output       ua_nrts112;      // Request12-To12-Send12 flow12 control12

//GPIO12 ports12
input [GPIO_WIDTH12-1:0]      gpio_pin_in12;             // input data from pin12
output [GPIO_WIDTH12-1:0]     n_gpio_pin_oe12;           // output enable signal12 to pin12
output [GPIO_WIDTH12-1:0]     gpio_pin_out12;            // output signal12 to pin12
  
//SMC12 ports12
input        smc_hclk12;
input        smc_n_hclk12;
input [31:0] smc_haddr12;
input [1:0]  smc_htrans12;
input        smc_hsel12;
input        smc_hwrite12;
input [2:0]  smc_hsize12;
input [31:0] smc_hwdata12;
input        smc_hready_in12;
input [2:0]  smc_hburst12;     // Burst type
input [3:0]  smc_hprot12;      // Protection12 control12
input [3:0]  smc_hmaster12;    // Master12 select12
input        smc_hmastlock12;  // Locked12 transfer12
input [31:0] data_smc12;     // EMI12(External12 memory) read data
output [31:0]    smc_hrdata12;
output           smc_hready12;
output [1:0]     smc_hresp12;
output [15:0]    smc_addr12;      // External12 Memory (EMI12) address
output [3:0]     smc_n_be12;      // EMI12 byte enables12 (Active12 LOW12)
output           smc_n_cs12;      // EMI12 Chip12 Selects12 (Active12 LOW12)
output [3:0]     smc_n_we12;      // EMI12 write strobes12 (Active12 LOW12)
output           smc_n_wr12;      // EMI12 write enable (Active12 LOW12)
output           smc_n_rd12;      // EMI12 read stobe12 (Active12 LOW12)
output           smc_n_ext_oe12;  // EMI12 write data output enable
output [31:0]    smc_data12;      // EMI12 write data
       
//PMC12 ports12
output clk_SRPG_macb0_en12;
output clk_SRPG_macb1_en12;
output clk_SRPG_macb2_en12;
output clk_SRPG_macb3_en12;
output core06v12;
output core08v12;
output core10v12;
output core12v12;
output mte_smc_start12;
output mte_uart_start12;
output mte_smc_uart_start12;  
output mte_pm_smc_to_default_start12; 
output mte_pm_uart_to_default_start12;
output mte_pm_smc_uart_to_default_start12;
input macb3_wakeup12;
input macb2_wakeup12;
input macb1_wakeup12;
input macb0_wakeup12;
    

// Peripheral12 interrupts12
output pcm_irq12;
output [2:0] ttc_irq12;
output gpio_irq12;
output uart0_irq12;
output uart1_irq12;
output spi_irq12;
input        macb0_int12;
input        macb1_int12;
input        macb2_int12;
input        macb3_int12;
input        DMA_irq12;
  
//Scan12 ports12
input        scan_en12;    // Scan12 enable pin12
input        scan_in_112;  // Scan12 input for first chain12
input        scan_in_212;  // Scan12 input for second chain12
input        scan_mode12;  // test mode pin12
 output        scan_out_112;   // Scan12 out for chain12 1
 output        scan_out_212;   // Scan12 out for chain12 2  

//------------------------------------------------------------------------------
// if the ROM12 subsystem12 is NOT12 black12 boxed12 
//------------------------------------------------------------------------------
`ifndef FV_KIT_BLACK_BOX_APB_SUBSYSTEM12
   
   wire        hsel12; 
   wire        pclk12;
   wire        n_preset12;
   wire [31:0] prdata_spi12;
   wire [31:0] prdata_uart012;
   wire [31:0] prdata_gpio12;
   wire [31:0] prdata_ttc12;
   wire [31:0] prdata_smc12;
   wire [31:0] prdata_pmc12;
   wire [31:0] prdata_uart112;
   wire        pready_spi12;
   wire        pready_uart012;
   wire        pready_uart112;
   wire        tie_hi_bit12;
   wire  [31:0] hrdata12; 
   wire         hready12;
   wire         hready_in12;
   wire  [1:0]  hresp12;   
   wire  [31:0] pwdata12;  
   wire         pwrite12;
   wire  [31:0] paddr12;  
   wire   psel_spi12;
   wire   psel_uart012;
   wire   psel_gpio12;
   wire   psel_ttc12;
   wire   psel_smc12;
   wire   psel0712;
   wire   psel0812;
   wire   psel0912;
   wire   psel1012;
   wire   psel1112;
   wire   psel1212;
   wire   psel_pmc12;
   wire   psel_uart112;
   wire   penable12;
   wire   [NO_OF_IRQS12:0] int_source12;     // System12 Interrupt12 Sources12
   wire [1:0]             smc_hresp12;     // AHB12 Response12 signal12
   wire                   smc_valid12;     // Ack12 valid address

  //External12 memory interface (EMI12)
  wire [31:0]            smc_addr_int12;  // External12 Memory (EMI12) address
  wire [3:0]             smc_n_be12;      // EMI12 byte enables12 (Active12 LOW12)
  wire                   smc_n_cs12;      // EMI12 Chip12 Selects12 (Active12 LOW12)
  wire [3:0]             smc_n_we12;      // EMI12 write strobes12 (Active12 LOW12)
  wire                   smc_n_wr12;      // EMI12 write enable (Active12 LOW12)
  wire                   smc_n_rd12;      // EMI12 read stobe12 (Active12 LOW12)
 
  //AHB12 Memory Interface12 Control12
  wire                   smc_hsel_int12;
  wire                   smc_busy12;      // smc12 busy
   

//scan12 signals12

   wire                scan_in_112;        //scan12 input
   wire                scan_in_212;        //scan12 input
   wire                scan_en12;         //scan12 enable
   wire                scan_out_112;       //scan12 output
   wire                scan_out_212;       //scan12 output
   wire                byte_sel12;     // byte select12 from bridge12 1=byte, 0=2byte
   wire                UART_int12;     // UART12 module interrupt12 
   wire                ua_uclken12;    // Soft12 control12 of clock12
   wire                UART_int112;     // UART12 module interrupt12 
   wire                ua_uclken112;    // Soft12 control12 of clock12
   wire  [3:1]         TTC_int12;            //Interrupt12 from PCI12 
  // inputs12 to SPI12 
   wire    ext_clk12;                // external12 clock12
   wire    SPI_int12;             // interrupt12 request
  // outputs12 from SPI12
   wire    slave_out_clk12;         // modified slave12 clock12 output
 // gpio12 generic12 inputs12 
   wire  [GPIO_WIDTH12-1:0]   n_gpio_bypass_oe12;        // bypass12 mode enable 
   wire  [GPIO_WIDTH12-1:0]   gpio_bypass_out12;         // bypass12 mode output value 
   wire  [GPIO_WIDTH12-1:0]   tri_state_enable12;   // disables12 op enable -> z 
 // outputs12 
   //amba12 outputs12 
   // gpio12 generic12 outputs12 
   wire       GPIO_int12;                // gpio_interupt12 for input pin12 change 
   wire [GPIO_WIDTH12-1:0]     gpio_bypass_in12;          // bypass12 mode input data value  
                
   wire           cpu_debug12;        // Inhibits12 watchdog12 counter 
   wire            ex_wdz_n12;         // External12 Watchdog12 zero indication12
   wire           rstn_non_srpg_smc12; 
   wire           rstn_non_srpg_urt12;
   wire           isolate_smc12;
   wire           save_edge_smc12;
   wire           restore_edge_smc12;
   wire           save_edge_urt12;
   wire           restore_edge_urt12;
   wire           pwr1_on_smc12;
   wire           pwr2_on_smc12;
   wire           pwr1_on_urt12;
   wire           pwr2_on_urt12;
   // ETH012
   wire            rstn_non_srpg_macb012;
   wire            gate_clk_macb012;
   wire            isolate_macb012;
   wire            save_edge_macb012;
   wire            restore_edge_macb012;
   wire            pwr1_on_macb012;
   wire            pwr2_on_macb012;
   // ETH112
   wire            rstn_non_srpg_macb112;
   wire            gate_clk_macb112;
   wire            isolate_macb112;
   wire            save_edge_macb112;
   wire            restore_edge_macb112;
   wire            pwr1_on_macb112;
   wire            pwr2_on_macb112;
   // ETH212
   wire            rstn_non_srpg_macb212;
   wire            gate_clk_macb212;
   wire            isolate_macb212;
   wire            save_edge_macb212;
   wire            restore_edge_macb212;
   wire            pwr1_on_macb212;
   wire            pwr2_on_macb212;
   // ETH312
   wire            rstn_non_srpg_macb312;
   wire            gate_clk_macb312;
   wire            isolate_macb312;
   wire            save_edge_macb312;
   wire            restore_edge_macb312;
   wire            pwr1_on_macb312;
   wire            pwr2_on_macb312;


   wire           pclk_SRPG_smc12;
   wire           pclk_SRPG_urt12;
   wire           gate_clk_smc12;
   wire           gate_clk_urt12;
   wire  [31:0]   tie_lo_32bit12; 
   wire  [1:0]	  tie_lo_2bit12;
   wire  	  tie_lo_1bit12;
   wire           pcm_macb_wakeup_int12;
   wire           int_source_h12;
   wire           isolate_mem12;

assign pcm_irq12 = pcm_macb_wakeup_int12;
assign ttc_irq12[2] = TTC_int12[3];
assign ttc_irq12[1] = TTC_int12[2];
assign ttc_irq12[0] = TTC_int12[1];
assign gpio_irq12 = GPIO_int12;
assign uart0_irq12 = UART_int12;
assign uart1_irq12 = UART_int112;
assign spi_irq12 = SPI_int12;

assign n_mo_en12   = 1'b0;
assign n_so_en12   = 1'b1;
assign n_sclk_en12 = 1'b0;
assign n_ss_en12   = 1'b0;

assign smc_hsel_int12 = smc_hsel12;
  assign ext_clk12  = 1'b0;
  assign int_source12 = {macb0_int12,macb1_int12, macb2_int12, macb3_int12,1'b0, pcm_macb_wakeup_int12, 1'b0, 1'b0, 1'b0, 1'b0, TTC_int12, GPIO_int12, UART_int12, UART_int112, SPI_int12, DMA_irq12};

  // interrupt12 even12 detect12 .
  // for sleep12 wake12 up -> any interrupt12 even12 and system not in hibernation12 (isolate_mem12 = 0)
  // for hibernate12 wake12 up -> gpio12 interrupt12 even12 and system in the hibernation12 (isolate_mem12 = 1)
  assign int_source_h12 =  ((|int_source12) && (!isolate_mem12)) || (isolate_mem12 && GPIO_int12) ;

  assign byte_sel12 = 1'b1;
  assign tie_hi_bit12 = 1'b1;

  assign smc_addr12 = smc_addr_int12[15:0];



  assign  n_gpio_bypass_oe12 = {GPIO_WIDTH12{1'b0}};        // bypass12 mode enable 
  assign  gpio_bypass_out12  = {GPIO_WIDTH12{1'b0}};
  assign  tri_state_enable12 = {GPIO_WIDTH12{1'b0}};
  assign  cpu_debug12 = 1'b0;
  assign  tie_lo_32bit12 = 32'b0;
  assign  tie_lo_2bit12  = 2'b0;
  assign  tie_lo_1bit12  = 1'b0;


ahb2apb12 #(
  32'h00800000, // Slave12 0 Address Range12
  32'h0080FFFF,

  32'h00810000, // Slave12 1 Address Range12
  32'h0081FFFF,

  32'h00820000, // Slave12 2 Address Range12 
  32'h0082FFFF,

  32'h00830000, // Slave12 3 Address Range12
  32'h0083FFFF,

  32'h00840000, // Slave12 4 Address Range12
  32'h0084FFFF,

  32'h00850000, // Slave12 5 Address Range12
  32'h0085FFFF,

  32'h00860000, // Slave12 6 Address Range12
  32'h0086FFFF,

  32'h00870000, // Slave12 7 Address Range12
  32'h0087FFFF,

  32'h00880000, // Slave12 8 Address Range12
  32'h0088FFFF
) i_ahb2apb12 (
     // AHB12 interface
    .hclk12(hclk12),         
    .hreset_n12(n_hreset12), 
    .hsel12(hsel12), 
    .haddr12(haddr12),        
    .htrans12(htrans12),       
    .hwrite12(hwrite12),       
    .hwdata12(hwdata12),       
    .hrdata12(hrdata12),   
    .hready12(hready12),   
    .hresp12(hresp12),     
    
     // APB12 interface
    .pclk12(pclk12),         
    .preset_n12(n_preset12),  
    .prdata012(prdata_spi12),
    .prdata112(prdata_uart012), 
    .prdata212(prdata_gpio12),  
    .prdata312(prdata_ttc12),   
    .prdata412(32'h0),   
    .prdata512(prdata_smc12),   
    .prdata612(prdata_pmc12),    
    .prdata712(32'h0),   
    .prdata812(prdata_uart112),  
    .pready012(pready_spi12),     
    .pready112(pready_uart012),   
    .pready212(tie_hi_bit12),     
    .pready312(tie_hi_bit12),     
    .pready412(tie_hi_bit12),     
    .pready512(tie_hi_bit12),     
    .pready612(tie_hi_bit12),     
    .pready712(tie_hi_bit12),     
    .pready812(pready_uart112),  
    .pwdata12(pwdata12),       
    .pwrite12(pwrite12),       
    .paddr12(paddr12),        
    .psel012(psel_spi12),     
    .psel112(psel_uart012),   
    .psel212(psel_gpio12),    
    .psel312(psel_ttc12),     
    .psel412(),     
    .psel512(psel_smc12),     
    .psel612(psel_pmc12),    
    .psel712(psel_apic12),   
    .psel812(psel_uart112),  
    .penable12(penable12)     
);

spi_top12 i_spi12
(
  // Wishbone12 signals12
  .wb_clk_i12(pclk12), 
  .wb_rst_i12(~n_preset12), 
  .wb_adr_i12(paddr12[4:0]), 
  .wb_dat_i12(pwdata12), 
  .wb_dat_o12(prdata_spi12), 
  .wb_sel_i12(4'b1111),    // SPI12 register accesses are always 32-bit
  .wb_we_i12(pwrite12), 
  .wb_stb_i12(psel_spi12), 
  .wb_cyc_i12(psel_spi12), 
  .wb_ack_o12(pready_spi12), 
  .wb_err_o12(), 
  .wb_int_o12(SPI_int12),

  // SPI12 signals12
  .ss_pad_o12(n_ss_out12), 
  .sclk_pad_o12(sclk_out12), 
  .mosi_pad_o12(mo12), 
  .miso_pad_i12(mi12)
);

// Opencores12 UART12 instances12
wire ua_nrts_int12;
wire ua_nrts1_int12;

assign ua_nrts12 = ua_nrts_int12;
assign ua_nrts112 = ua_nrts1_int12;

reg [3:0] uart0_sel_i12;
reg [3:0] uart1_sel_i12;
// UART12 registers are all 8-bit wide12, and their12 addresses12
// are on byte boundaries12. So12 to access them12 on the
// Wishbone12 bus, the CPU12 must do byte accesses to these12
// byte addresses12. Word12 address accesses are not possible12
// because the word12 addresses12 will be unaligned12, and cause
// a fault12.
// So12, Uart12 accesses from the CPU12 will always be 8-bit size
// We12 only have to decide12 which byte of the 4-byte word12 the
// CPU12 is interested12 in.
`ifdef SYSTEM_BIG_ENDIAN12
always @(paddr12) begin
  case (paddr12[1:0])
    2'b00 : uart0_sel_i12 = 4'b1000;
    2'b01 : uart0_sel_i12 = 4'b0100;
    2'b10 : uart0_sel_i12 = 4'b0010;
    2'b11 : uart0_sel_i12 = 4'b0001;
  endcase
end
always @(paddr12) begin
  case (paddr12[1:0])
    2'b00 : uart1_sel_i12 = 4'b1000;
    2'b01 : uart1_sel_i12 = 4'b0100;
    2'b10 : uart1_sel_i12 = 4'b0010;
    2'b11 : uart1_sel_i12 = 4'b0001;
  endcase
end
`else
always @(paddr12) begin
  case (paddr12[1:0])
    2'b00 : uart0_sel_i12 = 4'b0001;
    2'b01 : uart0_sel_i12 = 4'b0010;
    2'b10 : uart0_sel_i12 = 4'b0100;
    2'b11 : uart0_sel_i12 = 4'b1000;
  endcase
end
always @(paddr12) begin
  case (paddr12[1:0])
    2'b00 : uart1_sel_i12 = 4'b0001;
    2'b01 : uart1_sel_i12 = 4'b0010;
    2'b10 : uart1_sel_i12 = 4'b0100;
    2'b11 : uart1_sel_i12 = 4'b1000;
  endcase
end
`endif

uart_top12 i_oc_uart012 (
  .wb_clk_i12(pclk12),
  .wb_rst_i12(~n_preset12),
  .wb_adr_i12(paddr12[4:0]),
  .wb_dat_i12(pwdata12),
  .wb_dat_o12(prdata_uart012),
  .wb_we_i12(pwrite12),
  .wb_stb_i12(psel_uart012),
  .wb_cyc_i12(psel_uart012),
  .wb_ack_o12(pready_uart012),
  .wb_sel_i12(uart0_sel_i12),
  .int_o12(UART_int12),
  .stx_pad_o12(ua_txd12),
  .srx_pad_i12(ua_rxd12),
  .rts_pad_o12(ua_nrts_int12),
  .cts_pad_i12(ua_ncts12),
  .dtr_pad_o12(),
  .dsr_pad_i12(1'b0),
  .ri_pad_i12(1'b0),
  .dcd_pad_i12(1'b0)
);

uart_top12 i_oc_uart112 (
  .wb_clk_i12(pclk12),
  .wb_rst_i12(~n_preset12),
  .wb_adr_i12(paddr12[4:0]),
  .wb_dat_i12(pwdata12),
  .wb_dat_o12(prdata_uart112),
  .wb_we_i12(pwrite12),
  .wb_stb_i12(psel_uart112),
  .wb_cyc_i12(psel_uart112),
  .wb_ack_o12(pready_uart112),
  .wb_sel_i12(uart1_sel_i12),
  .int_o12(UART_int112),
  .stx_pad_o12(ua_txd112),
  .srx_pad_i12(ua_rxd112),
  .rts_pad_o12(ua_nrts1_int12),
  .cts_pad_i12(ua_ncts112),
  .dtr_pad_o12(),
  .dsr_pad_i12(1'b0),
  .ri_pad_i12(1'b0),
  .dcd_pad_i12(1'b0)
);

gpio_veneer12 i_gpio_veneer12 (
        //inputs12

        . n_p_reset12(n_preset12),
        . pclk12(pclk12),
        . psel12(psel_gpio12),
        . penable12(penable12),
        . pwrite12(pwrite12),
        . paddr12(paddr12[5:0]),
        . pwdata12(pwdata12),
        . gpio_pin_in12(gpio_pin_in12),
        . scan_en12(scan_en12),
        . tri_state_enable12(tri_state_enable12),
        . scan_in12(), //added by smarkov12 for dft12

        //outputs12
        . scan_out12(), //added by smarkov12 for dft12
        . prdata12(prdata_gpio12),
        . gpio_int12(GPIO_int12),
        . n_gpio_pin_oe12(n_gpio_pin_oe12),
        . gpio_pin_out12(gpio_pin_out12)
);


ttc_veneer12 i_ttc_veneer12 (

         //inputs12
        . n_p_reset12(n_preset12),
        . pclk12(pclk12),
        . psel12(psel_ttc12),
        . penable12(penable12),
        . pwrite12(pwrite12),
        . pwdata12(pwdata12),
        . paddr12(paddr12[7:0]),
        . scan_in12(),
        . scan_en12(scan_en12),

        //outputs12
        . prdata12(prdata_ttc12),
        . interrupt12(TTC_int12[3:1]),
        . scan_out12()
);


smc_veneer12 i_smc_veneer12 (
        //inputs12
	//apb12 inputs12
        . n_preset12(n_preset12),
        . pclk12(pclk_SRPG_smc12),
        . psel12(psel_smc12),
        . penable12(penable12),
        . pwrite12(pwrite12),
        . paddr12(paddr12[4:0]),
        . pwdata12(pwdata12),
        //ahb12 inputs12
	. hclk12(smc_hclk12),
        . n_sys_reset12(rstn_non_srpg_smc12),
        . haddr12(smc_haddr12),
        . htrans12(smc_htrans12),
        . hsel12(smc_hsel_int12),
        . hwrite12(smc_hwrite12),
	. hsize12(smc_hsize12),
        . hwdata12(smc_hwdata12),
        . hready12(smc_hready_in12),
        . data_smc12(data_smc12),

         //test signal12 inputs12

        . scan_in_112(),
        . scan_in_212(),
        . scan_in_312(),
        . scan_en12(scan_en12),

        //apb12 outputs12
        . prdata12(prdata_smc12),

       //design output

        . smc_hrdata12(smc_hrdata12),
        . smc_hready12(smc_hready12),
        . smc_hresp12(smc_hresp12),
        . smc_valid12(smc_valid12),
        . smc_addr12(smc_addr_int12),
        . smc_data12(smc_data12),
        . smc_n_be12(smc_n_be12),
        . smc_n_cs12(smc_n_cs12),
        . smc_n_wr12(smc_n_wr12),
        . smc_n_we12(smc_n_we12),
        . smc_n_rd12(smc_n_rd12),
        . smc_n_ext_oe12(smc_n_ext_oe12),
        . smc_busy12(smc_busy12),

         //test signal12 output
        . scan_out_112(),
        . scan_out_212(),
        . scan_out_312()
);

power_ctrl_veneer12 i_power_ctrl_veneer12 (
    // -- Clocks12 & Reset12
    	.pclk12(pclk12), 			//  : in  std_logic12;
    	.nprst12(n_preset12), 		//  : in  std_logic12;
    // -- APB12 programming12 interface
    	.paddr12(paddr12), 			//  : in  std_logic_vector12(31 downto12 0);
    	.psel12(psel_pmc12), 			//  : in  std_logic12;
    	.penable12(penable12), 		//  : in  std_logic12;
    	.pwrite12(pwrite12), 		//  : in  std_logic12;
    	.pwdata12(pwdata12), 		//  : in  std_logic_vector12(31 downto12 0);
    	.prdata12(prdata_pmc12), 		//  : out std_logic_vector12(31 downto12 0);
        .macb3_wakeup12(macb3_wakeup12),
        .macb2_wakeup12(macb2_wakeup12),
        .macb1_wakeup12(macb1_wakeup12),
        .macb0_wakeup12(macb0_wakeup12),
    // -- Module12 control12 outputs12
    	.scan_in12(),			//  : in  std_logic12;
    	.scan_en12(scan_en12),             	//  : in  std_logic12;
    	.scan_mode12(scan_mode12),          //  : in  std_logic12;
    	.scan_out12(),            	//  : out std_logic12;
        .int_source_h12(int_source_h12),
     	.rstn_non_srpg_smc12(rstn_non_srpg_smc12), 		//   : out std_logic12;
    	.gate_clk_smc12(gate_clk_smc12), 	//  : out std_logic12;
    	.isolate_smc12(isolate_smc12), 	//  : out std_logic12;
    	.save_edge_smc12(save_edge_smc12), 	//  : out std_logic12;
    	.restore_edge_smc12(restore_edge_smc12), 	//  : out std_logic12;
    	.pwr1_on_smc12(pwr1_on_smc12), 	//  : out std_logic12;
    	.pwr2_on_smc12(pwr2_on_smc12), 	//  : out std_logic12
     	.rstn_non_srpg_urt12(rstn_non_srpg_urt12), 		//   : out std_logic12;
    	.gate_clk_urt12(gate_clk_urt12), 	//  : out std_logic12;
    	.isolate_urt12(isolate_urt12), 	//  : out std_logic12;
    	.save_edge_urt12(save_edge_urt12), 	//  : out std_logic12;
    	.restore_edge_urt12(restore_edge_urt12), 	//  : out std_logic12;
    	.pwr1_on_urt12(pwr1_on_urt12), 	//  : out std_logic12;
    	.pwr2_on_urt12(pwr2_on_urt12),  	//  : out std_logic12
        // ETH012
        .rstn_non_srpg_macb012(rstn_non_srpg_macb012),
        .gate_clk_macb012(gate_clk_macb012),
        .isolate_macb012(isolate_macb012),
        .save_edge_macb012(save_edge_macb012),
        .restore_edge_macb012(restore_edge_macb012),
        .pwr1_on_macb012(pwr1_on_macb012),
        .pwr2_on_macb012(pwr2_on_macb012),
        // ETH112
        .rstn_non_srpg_macb112(rstn_non_srpg_macb112),
        .gate_clk_macb112(gate_clk_macb112),
        .isolate_macb112(isolate_macb112),
        .save_edge_macb112(save_edge_macb112),
        .restore_edge_macb112(restore_edge_macb112),
        .pwr1_on_macb112(pwr1_on_macb112),
        .pwr2_on_macb112(pwr2_on_macb112),
        // ETH212
        .rstn_non_srpg_macb212(rstn_non_srpg_macb212),
        .gate_clk_macb212(gate_clk_macb212),
        .isolate_macb212(isolate_macb212),
        .save_edge_macb212(save_edge_macb212),
        .restore_edge_macb212(restore_edge_macb212),
        .pwr1_on_macb212(pwr1_on_macb212),
        .pwr2_on_macb212(pwr2_on_macb212),
        // ETH312
        .rstn_non_srpg_macb312(rstn_non_srpg_macb312),
        .gate_clk_macb312(gate_clk_macb312),
        .isolate_macb312(isolate_macb312),
        .save_edge_macb312(save_edge_macb312),
        .restore_edge_macb312(restore_edge_macb312),
        .pwr1_on_macb312(pwr1_on_macb312),
        .pwr2_on_macb312(pwr2_on_macb312),
        .core06v12(core06v12),
        .core08v12(core08v12),
        .core10v12(core10v12),
        .core12v12(core12v12),
        .pcm_macb_wakeup_int12(pcm_macb_wakeup_int12),
        .isolate_mem12(isolate_mem12),
        .mte_smc_start12(mte_smc_start12),
        .mte_uart_start12(mte_uart_start12),
        .mte_smc_uart_start12(mte_smc_uart_start12),  
        .mte_pm_smc_to_default_start12(mte_pm_smc_to_default_start12), 
        .mte_pm_uart_to_default_start12(mte_pm_uart_to_default_start12),
        .mte_pm_smc_uart_to_default_start12(mte_pm_smc_uart_to_default_start12)
);

// Clock12 gating12 macro12 to shut12 off12 clocks12 to the SRPG12 flops12 in the SMC12
//CKLNQD112 i_SMC_SRPG_clk_gate12  (
//	.TE12(scan_mode12), 
//	.E12(~gate_clk_smc12), 
//	.CP12(pclk12), 
//	.Q12(pclk_SRPG_smc12)
//	);
// Replace12 gate12 with behavioural12 code12 //
wire 	smc_scan_gate12;
reg 	smc_latched_enable12;
assign smc_scan_gate12 = scan_mode12 ? 1'b1 : ~gate_clk_smc12;

always @ (pclk12 or smc_scan_gate12)
  	if (pclk12 == 1'b0) begin
  		smc_latched_enable12 <= smc_scan_gate12;
  	end  	
	
assign pclk_SRPG_smc12 = smc_latched_enable12 ? pclk12 : 1'b0;


// Clock12 gating12 macro12 to shut12 off12 clocks12 to the SRPG12 flops12 in the URT12
//CKLNQD112 i_URT_SRPG_clk_gate12  (
//	.TE12(scan_mode12), 
//	.E12(~gate_clk_urt12), 
//	.CP12(pclk12), 
//	.Q12(pclk_SRPG_urt12)
//	);
// Replace12 gate12 with behavioural12 code12 //
wire 	urt_scan_gate12;
reg 	urt_latched_enable12;
assign urt_scan_gate12 = scan_mode12 ? 1'b1 : ~gate_clk_urt12;

always @ (pclk12 or urt_scan_gate12)
  	if (pclk12 == 1'b0) begin
  		urt_latched_enable12 <= urt_scan_gate12;
  	end  	
	
assign pclk_SRPG_urt12 = urt_latched_enable12 ? pclk12 : 1'b0;

// ETH012
wire 	macb0_scan_gate12;
reg 	macb0_latched_enable12;
assign macb0_scan_gate12 = scan_mode12 ? 1'b1 : ~gate_clk_macb012;

always @ (pclk12 or macb0_scan_gate12)
  	if (pclk12 == 1'b0) begin
  		macb0_latched_enable12 <= macb0_scan_gate12;
  	end  	
	
assign clk_SRPG_macb0_en12 = macb0_latched_enable12 ? 1'b1 : 1'b0;

// ETH112
wire 	macb1_scan_gate12;
reg 	macb1_latched_enable12;
assign macb1_scan_gate12 = scan_mode12 ? 1'b1 : ~gate_clk_macb112;

always @ (pclk12 or macb1_scan_gate12)
  	if (pclk12 == 1'b0) begin
  		macb1_latched_enable12 <= macb1_scan_gate12;
  	end  	
	
assign clk_SRPG_macb1_en12 = macb1_latched_enable12 ? 1'b1 : 1'b0;

// ETH212
wire 	macb2_scan_gate12;
reg 	macb2_latched_enable12;
assign macb2_scan_gate12 = scan_mode12 ? 1'b1 : ~gate_clk_macb212;

always @ (pclk12 or macb2_scan_gate12)
  	if (pclk12 == 1'b0) begin
  		macb2_latched_enable12 <= macb2_scan_gate12;
  	end  	
	
assign clk_SRPG_macb2_en12 = macb2_latched_enable12 ? 1'b1 : 1'b0;

// ETH312
wire 	macb3_scan_gate12;
reg 	macb3_latched_enable12;
assign macb3_scan_gate12 = scan_mode12 ? 1'b1 : ~gate_clk_macb312;

always @ (pclk12 or macb3_scan_gate12)
  	if (pclk12 == 1'b0) begin
  		macb3_latched_enable12 <= macb3_scan_gate12;
  	end  	
	
assign clk_SRPG_macb3_en12 = macb3_latched_enable12 ? 1'b1 : 1'b0;



`else
//------------------------------------------------------------------------------
// if the APB12 subsystem12 is black12 boxed12 
//------------------------------------------------------------------------------
// wire s ports12
    // system signals12
    wire         hclk12;     // AHB12 Clock12
    wire         n_hreset12;  // AHB12 reset - Active12 low12
    wire         pclk12;     // APB12 Clock12. 
    wire         n_preset12;  // APB12 reset - Active12 low12

    // AHB12 interface
    wire         ahb2apb0_hsel12;     // AHB2APB12 select12
    wire  [31:0] haddr12;    // Address bus
    wire  [1:0]  htrans12;   // Transfer12 type
    wire  [2:0]  hsize12;    // AHB12 Access type - byte, half12-word12, word12
    wire  [31:0] hwdata12;   // Write data
    wire         hwrite12;   // Write signal12/
    wire         hready_in12;// Indicates12 that last master12 has finished12 bus access
    wire [2:0]   hburst12;     // Burst type
    wire [3:0]   hprot12;      // Protection12 control12
    wire [3:0]   hmaster12;    // Master12 select12
    wire         hmastlock12;  // Locked12 transfer12
  // Interrupts12 from the Enet12 MACs12
    wire         macb0_int12;
    wire         macb1_int12;
    wire         macb2_int12;
    wire         macb3_int12;
  // Interrupt12 from the DMA12
    wire         DMA_irq12;
  // Scan12 wire s
    wire         scan_en12;    // Scan12 enable pin12
    wire         scan_in_112;  // Scan12 wire  for first chain12
    wire         scan_in_212;  // Scan12 wire  for second chain12
    wire         scan_mode12;  // test mode pin12
 
  //wire  for smc12 AHB12 interface
    wire         smc_hclk12;
    wire         smc_n_hclk12;
    wire  [31:0] smc_haddr12;
    wire  [1:0]  smc_htrans12;
    wire         smc_hsel12;
    wire         smc_hwrite12;
    wire  [2:0]  smc_hsize12;
    wire  [31:0] smc_hwdata12;
    wire         smc_hready_in12;
    wire  [2:0]  smc_hburst12;     // Burst type
    wire  [3:0]  smc_hprot12;      // Protection12 control12
    wire  [3:0]  smc_hmaster12;    // Master12 select12
    wire         smc_hmastlock12;  // Locked12 transfer12


    wire  [31:0] data_smc12;     // EMI12(External12 memory) read data
    
  //wire s for uart12
    wire         ua_rxd12;       // UART12 receiver12 serial12 wire  pin12
    wire         ua_rxd112;      // UART12 receiver12 serial12 wire  pin12
    wire         ua_ncts12;      // Clear-To12-Send12 flow12 control12
    wire         ua_ncts112;      // Clear-To12-Send12 flow12 control12
   //wire s for spi12
    wire         n_ss_in12;      // select12 wire  to slave12
    wire         mi12;           // data wire  to master12
    wire         si12;           // data wire  to slave12
    wire         sclk_in12;      // clock12 wire  to slave12
  //wire s for GPIO12
   wire  [GPIO_WIDTH12-1:0]  gpio_pin_in12;             // wire  data from pin12

  //reg    ports12
  // Scan12 reg   s
   reg           scan_out_112;   // Scan12 out for chain12 1
   reg           scan_out_212;   // Scan12 out for chain12 2
  //AHB12 interface 
   reg    [31:0] hrdata12;       // Read data provided from target slave12
   reg           hready12;       // Ready12 for new bus cycle from target slave12
   reg    [1:0]  hresp12;       // Response12 from the bridge12

   // SMC12 reg    for AHB12 interface
   reg    [31:0]    smc_hrdata12;
   reg              smc_hready12;
   reg    [1:0]     smc_hresp12;

  //reg   s from smc12
   reg    [15:0]    smc_addr12;      // External12 Memory (EMI12) address
   reg    [3:0]     smc_n_be12;      // EMI12 byte enables12 (Active12 LOW12)
   reg    [7:0]     smc_n_cs12;      // EMI12 Chip12 Selects12 (Active12 LOW12)
   reg    [3:0]     smc_n_we12;      // EMI12 write strobes12 (Active12 LOW12)
   reg              smc_n_wr12;      // EMI12 write enable (Active12 LOW12)
   reg              smc_n_rd12;      // EMI12 read stobe12 (Active12 LOW12)
   reg              smc_n_ext_oe12;  // EMI12 write data reg    enable
   reg    [31:0]    smc_data12;      // EMI12 write data
  //reg   s from uart12
   reg           ua_txd12;       	// UART12 transmitter12 serial12 reg   
   reg           ua_txd112;       // UART12 transmitter12 serial12 reg   
   reg           ua_nrts12;      	// Request12-To12-Send12 flow12 control12
   reg           ua_nrts112;      // Request12-To12-Send12 flow12 control12
   // reg   s from ttc12
  // reg   s from SPI12
   reg       so;                    // data reg    from slave12
   reg       mo12;                    // data reg    from master12
   reg       sclk_out12;              // clock12 reg    from master12
   reg    [P_SIZE12-1:0] n_ss_out12;    // peripheral12 select12 lines12 from master12
   reg       n_so_en12;               // out enable for slave12 data
   reg       n_mo_en12;               // out enable for master12 data
   reg       n_sclk_en12;             // out enable for master12 clock12
   reg       n_ss_en12;               // out enable for master12 peripheral12 lines12
  //reg   s from gpio12
   reg    [GPIO_WIDTH12-1:0]     n_gpio_pin_oe12;           // reg    enable signal12 to pin12
   reg    [GPIO_WIDTH12-1:0]     gpio_pin_out12;            // reg    signal12 to pin12


`endif
//------------------------------------------------------------------------------
// black12 boxed12 defines12 
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// APB12 and AHB12 interface formal12 verification12 monitors12
//------------------------------------------------------------------------------
`ifdef ABV_ON12
apb_assert12 i_apb_assert12 (

        // APB12 signals12
  	.n_preset12(n_preset12),
   	.pclk12(pclk12),
	.penable12(penable12),
	.paddr12(paddr12),
	.pwrite12(pwrite12),
	.pwdata12(pwdata12),

	.psel0012(psel_spi12),
	.psel0112(psel_uart012),
	.psel0212(psel_gpio12),
	.psel0312(psel_ttc12),
	.psel0412(1'b0),
	.psel0512(psel_smc12),
	.psel0612(1'b0),
	.psel0712(1'b0),
	.psel0812(1'b0),
	.psel0912(1'b0),
	.psel1012(1'b0),
	.psel1112(1'b0),
	.psel1212(1'b0),
	.psel1312(psel_pmc12),
	.psel1412(psel_apic12),
	.psel1512(psel_uart112),

        .prdata0012(prdata_spi12),
        .prdata0112(prdata_uart012), // Read Data from peripheral12 UART12 
        .prdata0212(prdata_gpio12), // Read Data from peripheral12 GPIO12
        .prdata0312(prdata_ttc12), // Read Data from peripheral12 TTC12
        .prdata0412(32'b0), // 
        .prdata0512(prdata_smc12), // Read Data from peripheral12 SMC12
        .prdata1312(prdata_pmc12), // Read Data from peripheral12 Power12 Control12 Block
   	.prdata1412(32'b0), // 
        .prdata1512(prdata_uart112),


        // AHB12 signals12
        .hclk12(hclk12),         // ahb12 system clock12
        .n_hreset12(n_hreset12), // ahb12 system reset

        // ahb2apb12 signals12
        .hresp12(hresp12),
        .hready12(hready12),
        .hrdata12(hrdata12),
        .hwdata12(hwdata12),
        .hprot12(hprot12),
        .hburst12(hburst12),
        .hsize12(hsize12),
        .hwrite12(hwrite12),
        .htrans12(htrans12),
        .haddr12(haddr12),
        .ahb2apb_hsel12(ahb2apb0_hsel12));



//------------------------------------------------------------------------------
// AHB12 interface formal12 verification12 monitor12
//------------------------------------------------------------------------------
defparam i_ahbSlaveMonitor12.DBUS_WIDTH12 = 32;
defparam i_ahbMasterMonitor12.DBUS_WIDTH12 = 32;


// AHB2APB12 Bridge12

    ahb_liteslave_monitor12 i_ahbSlaveMonitor12 (
        .hclk_i12(hclk12),
        .hresetn_i12(n_hreset12),
        .hresp12(hresp12),
        .hready12(hready12),
        .hready_global_i12(hready12),
        .hrdata12(hrdata12),
        .hwdata_i12(hwdata12),
        .hburst_i12(hburst12),
        .hsize_i12(hsize12),
        .hwrite_i12(hwrite12),
        .htrans_i12(htrans12),
        .haddr_i12(haddr12),
        .hsel_i12(ahb2apb0_hsel12)
    );


  ahb_litemaster_monitor12 i_ahbMasterMonitor12 (
          .hclk_i12(hclk12),
          .hresetn_i12(n_hreset12),
          .hresp_i12(hresp12),
          .hready_i12(hready12),
          .hrdata_i12(hrdata12),
          .hlock12(1'b0),
          .hwdata12(hwdata12),
          .hprot12(hprot12),
          .hburst12(hburst12),
          .hsize12(hsize12),
          .hwrite12(hwrite12),
          .htrans12(htrans12),
          .haddr12(haddr12)
          );







`endif




`ifdef IFV_LP_ABV_ON12
// power12 control12
wire isolate12;

// testbench mirror signals12
wire L1_ctrl_access12;
wire L1_status_access12;

wire [31:0] L1_status_reg12;
wire [31:0] L1_ctrl_reg12;

//wire rstn_non_srpg_urt12;
//wire isolate_urt12;
//wire retain_urt12;
//wire gate_clk_urt12;
//wire pwr1_on_urt12;


// smc12 signals12
wire [31:0] smc_prdata12;
wire lp_clk_smc12;
                    

// uart12 isolation12 register
  wire [15:0] ua_prdata12;
  wire ua_int12;
  assign ua_prdata12          =  i_uart1_veneer12.prdata12;
  assign ua_int12             =  i_uart1_veneer12.ua_int12;


assign lp_clk_smc12          = i_smc_veneer12.pclk12;
assign smc_prdata12          = i_smc_veneer12.prdata12;
lp_chk_smc12 u_lp_chk_smc12 (
    .clk12 (hclk12),
    .rst12 (n_hreset12),
    .iso_smc12 (isolate_smc12),
    .gate_clk12 (gate_clk_smc12),
    .lp_clk12 (pclk_SRPG_smc12),

    // srpg12 outputs12
    .smc_hrdata12 (smc_hrdata12),
    .smc_hready12 (smc_hready12),
    .smc_hresp12  (smc_hresp12),
    .smc_valid12 (smc_valid12),
    .smc_addr_int12 (smc_addr_int12),
    .smc_data12 (smc_data12),
    .smc_n_be12 (smc_n_be12),
    .smc_n_cs12  (smc_n_cs12),
    .smc_n_wr12 (smc_n_wr12),
    .smc_n_we12 (smc_n_we12),
    .smc_n_rd12 (smc_n_rd12),
    .smc_n_ext_oe12 (smc_n_ext_oe12)
   );

// lp12 retention12/isolation12 assertions12
lp_chk_uart12 u_lp_chk_urt12 (

  .clk12         (hclk12),
  .rst12         (n_hreset12),
  .iso_urt12     (isolate_urt12),
  .gate_clk12    (gate_clk_urt12),
  .lp_clk12      (pclk_SRPG_urt12),
  //ports12
  .prdata12 (ua_prdata12),
  .ua_int12 (ua_int12),
  .ua_txd12 (ua_txd112),
  .ua_nrts12 (ua_nrts112)
 );

`endif  //IFV_LP_ABV_ON12




endmodule
