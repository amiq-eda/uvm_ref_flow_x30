//File26 name   : apb_subsystem_026.v
//Title26       : 
//Created26     : 1999
//Description26 : 
//Notes26       : 
//----------------------------------------------------------------------
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------

module apb_subsystem_026(
    // AHB26 interface
    hclk26,
    n_hreset26,
    hsel26,
    haddr26,
    htrans26,
    hsize26,
    hwrite26,
    hwdata26,
    hready_in26,
    hburst26,
    hprot26,
    hmaster26,
    hmastlock26,
    hrdata26,
    hready26,
    hresp26,
    
    // APB26 system interface
    pclk26,
    n_preset26,
    
    // SPI26 ports26
    n_ss_in26,
    mi26,
    si26,
    sclk_in26,
    so,
    mo26,
    sclk_out26,
    n_ss_out26,
    n_so_en26,
    n_mo_en26,
    n_sclk_en26,
    n_ss_en26,
    
    //UART026 ports26
    ua_rxd26,
    ua_ncts26,
    ua_txd26,
    ua_nrts26,
    
    //UART126 ports26
    ua_rxd126,
    ua_ncts126,
    ua_txd126,
    ua_nrts126,
    
    //GPIO26 ports26
    gpio_pin_in26,
    n_gpio_pin_oe26,
    gpio_pin_out26,
    

    //SMC26 ports26
    smc_hclk26,
    smc_n_hclk26,
    smc_haddr26,
    smc_htrans26,
    smc_hsel26,
    smc_hwrite26,
    smc_hsize26,
    smc_hwdata26,
    smc_hready_in26,
    smc_hburst26,
    smc_hprot26,
    smc_hmaster26,
    smc_hmastlock26,
    smc_hrdata26, 
    smc_hready26,
    smc_hresp26,
    smc_n_ext_oe26,
    smc_data26,
    smc_addr26,
    smc_n_be26,
    smc_n_cs26, 
    smc_n_we26,
    smc_n_wr26,
    smc_n_rd26,
    data_smc26,
    
    //PMC26 ports26
    clk_SRPG_macb0_en26,
    clk_SRPG_macb1_en26,
    clk_SRPG_macb2_en26,
    clk_SRPG_macb3_en26,
    core06v26,
    core08v26,
    core10v26,
    core12v26,
    macb3_wakeup26,
    macb2_wakeup26,
    macb1_wakeup26,
    macb0_wakeup26,
    mte_smc_start26,
    mte_uart_start26,
    mte_smc_uart_start26,  
    mte_pm_smc_to_default_start26, 
    mte_pm_uart_to_default_start26,
    mte_pm_smc_uart_to_default_start26,
    
    
    // Peripheral26 inerrupts26
    pcm_irq26,
    ttc_irq26,
    gpio_irq26,
    uart0_irq26,
    uart1_irq26,
    spi_irq26,
    DMA_irq26,      
    macb0_int26,
    macb1_int26,
    macb2_int26,
    macb3_int26,
   
    // Scan26 ports26
    scan_en26,      // Scan26 enable pin26
    scan_in_126,    // Scan26 input for first chain26
    scan_in_226,    // Scan26 input for second chain26
    scan_mode26,
    scan_out_126,   // Scan26 out for chain26 1
    scan_out_226    // Scan26 out for chain26 2
);

parameter GPIO_WIDTH26 = 16;        // GPIO26 width
parameter P_SIZE26 =   8;              // number26 of peripheral26 select26 lines26
parameter NO_OF_IRQS26  = 17;      //No of irqs26 read by apic26 

// AHB26 interface
input         hclk26;     // AHB26 Clock26
input         n_hreset26;  // AHB26 reset - Active26 low26
input         hsel26;     // AHB2APB26 select26
input [31:0]  haddr26;    // Address bus
input [1:0]   htrans26;   // Transfer26 type
input [2:0]   hsize26;    // AHB26 Access type - byte, half26-word26, word26
input [31:0]  hwdata26;   // Write data
input         hwrite26;   // Write signal26/
input         hready_in26;// Indicates26 that last master26 has finished26 bus access
input [2:0]   hburst26;     // Burst type
input [3:0]   hprot26;      // Protection26 control26
input [3:0]   hmaster26;    // Master26 select26
input         hmastlock26;  // Locked26 transfer26
output [31:0] hrdata26;       // Read data provided from target slave26
output        hready26;       // Ready26 for new bus cycle from target slave26
output [1:0]  hresp26;       // Response26 from the bridge26
    
// APB26 system interface
input         pclk26;     // APB26 Clock26. 
input         n_preset26;  // APB26 reset - Active26 low26
   
// SPI26 ports26
input     n_ss_in26;      // select26 input to slave26
input     mi26;           // data input to master26
input     si26;           // data input to slave26
input     sclk_in26;      // clock26 input to slave26
output    so;                    // data output from slave26
output    mo26;                    // data output from master26
output    sclk_out26;              // clock26 output from master26
output [P_SIZE26-1:0] n_ss_out26;    // peripheral26 select26 lines26 from master26
output    n_so_en26;               // out enable for slave26 data
output    n_mo_en26;               // out enable for master26 data
output    n_sclk_en26;             // out enable for master26 clock26
output    n_ss_en26;               // out enable for master26 peripheral26 lines26

//UART026 ports26
input        ua_rxd26;       // UART26 receiver26 serial26 input pin26
input        ua_ncts26;      // Clear-To26-Send26 flow26 control26
output       ua_txd26;       	// UART26 transmitter26 serial26 output
output       ua_nrts26;      	// Request26-To26-Send26 flow26 control26

// UART126 ports26   
input        ua_rxd126;      // UART26 receiver26 serial26 input pin26
input        ua_ncts126;      // Clear-To26-Send26 flow26 control26
output       ua_txd126;       // UART26 transmitter26 serial26 output
output       ua_nrts126;      // Request26-To26-Send26 flow26 control26

//GPIO26 ports26
input [GPIO_WIDTH26-1:0]      gpio_pin_in26;             // input data from pin26
output [GPIO_WIDTH26-1:0]     n_gpio_pin_oe26;           // output enable signal26 to pin26
output [GPIO_WIDTH26-1:0]     gpio_pin_out26;            // output signal26 to pin26
  
//SMC26 ports26
input        smc_hclk26;
input        smc_n_hclk26;
input [31:0] smc_haddr26;
input [1:0]  smc_htrans26;
input        smc_hsel26;
input        smc_hwrite26;
input [2:0]  smc_hsize26;
input [31:0] smc_hwdata26;
input        smc_hready_in26;
input [2:0]  smc_hburst26;     // Burst type
input [3:0]  smc_hprot26;      // Protection26 control26
input [3:0]  smc_hmaster26;    // Master26 select26
input        smc_hmastlock26;  // Locked26 transfer26
input [31:0] data_smc26;     // EMI26(External26 memory) read data
output [31:0]    smc_hrdata26;
output           smc_hready26;
output [1:0]     smc_hresp26;
output [15:0]    smc_addr26;      // External26 Memory (EMI26) address
output [3:0]     smc_n_be26;      // EMI26 byte enables26 (Active26 LOW26)
output           smc_n_cs26;      // EMI26 Chip26 Selects26 (Active26 LOW26)
output [3:0]     smc_n_we26;      // EMI26 write strobes26 (Active26 LOW26)
output           smc_n_wr26;      // EMI26 write enable (Active26 LOW26)
output           smc_n_rd26;      // EMI26 read stobe26 (Active26 LOW26)
output           smc_n_ext_oe26;  // EMI26 write data output enable
output [31:0]    smc_data26;      // EMI26 write data
       
//PMC26 ports26
output clk_SRPG_macb0_en26;
output clk_SRPG_macb1_en26;
output clk_SRPG_macb2_en26;
output clk_SRPG_macb3_en26;
output core06v26;
output core08v26;
output core10v26;
output core12v26;
output mte_smc_start26;
output mte_uart_start26;
output mte_smc_uart_start26;  
output mte_pm_smc_to_default_start26; 
output mte_pm_uart_to_default_start26;
output mte_pm_smc_uart_to_default_start26;
input macb3_wakeup26;
input macb2_wakeup26;
input macb1_wakeup26;
input macb0_wakeup26;
    

// Peripheral26 interrupts26
output pcm_irq26;
output [2:0] ttc_irq26;
output gpio_irq26;
output uart0_irq26;
output uart1_irq26;
output spi_irq26;
input        macb0_int26;
input        macb1_int26;
input        macb2_int26;
input        macb3_int26;
input        DMA_irq26;
  
//Scan26 ports26
input        scan_en26;    // Scan26 enable pin26
input        scan_in_126;  // Scan26 input for first chain26
input        scan_in_226;  // Scan26 input for second chain26
input        scan_mode26;  // test mode pin26
 output        scan_out_126;   // Scan26 out for chain26 1
 output        scan_out_226;   // Scan26 out for chain26 2  

//------------------------------------------------------------------------------
// if the ROM26 subsystem26 is NOT26 black26 boxed26 
//------------------------------------------------------------------------------
`ifndef FV_KIT_BLACK_BOX_APB_SUBSYSTEM26
   
   wire        hsel26; 
   wire        pclk26;
   wire        n_preset26;
   wire [31:0] prdata_spi26;
   wire [31:0] prdata_uart026;
   wire [31:0] prdata_gpio26;
   wire [31:0] prdata_ttc26;
   wire [31:0] prdata_smc26;
   wire [31:0] prdata_pmc26;
   wire [31:0] prdata_uart126;
   wire        pready_spi26;
   wire        pready_uart026;
   wire        pready_uart126;
   wire        tie_hi_bit26;
   wire  [31:0] hrdata26; 
   wire         hready26;
   wire         hready_in26;
   wire  [1:0]  hresp26;   
   wire  [31:0] pwdata26;  
   wire         pwrite26;
   wire  [31:0] paddr26;  
   wire   psel_spi26;
   wire   psel_uart026;
   wire   psel_gpio26;
   wire   psel_ttc26;
   wire   psel_smc26;
   wire   psel0726;
   wire   psel0826;
   wire   psel0926;
   wire   psel1026;
   wire   psel1126;
   wire   psel1226;
   wire   psel_pmc26;
   wire   psel_uart126;
   wire   penable26;
   wire   [NO_OF_IRQS26:0] int_source26;     // System26 Interrupt26 Sources26
   wire [1:0]             smc_hresp26;     // AHB26 Response26 signal26
   wire                   smc_valid26;     // Ack26 valid address

  //External26 memory interface (EMI26)
  wire [31:0]            smc_addr_int26;  // External26 Memory (EMI26) address
  wire [3:0]             smc_n_be26;      // EMI26 byte enables26 (Active26 LOW26)
  wire                   smc_n_cs26;      // EMI26 Chip26 Selects26 (Active26 LOW26)
  wire [3:0]             smc_n_we26;      // EMI26 write strobes26 (Active26 LOW26)
  wire                   smc_n_wr26;      // EMI26 write enable (Active26 LOW26)
  wire                   smc_n_rd26;      // EMI26 read stobe26 (Active26 LOW26)
 
  //AHB26 Memory Interface26 Control26
  wire                   smc_hsel_int26;
  wire                   smc_busy26;      // smc26 busy
   

//scan26 signals26

   wire                scan_in_126;        //scan26 input
   wire                scan_in_226;        //scan26 input
   wire                scan_en26;         //scan26 enable
   wire                scan_out_126;       //scan26 output
   wire                scan_out_226;       //scan26 output
   wire                byte_sel26;     // byte select26 from bridge26 1=byte, 0=2byte
   wire                UART_int26;     // UART26 module interrupt26 
   wire                ua_uclken26;    // Soft26 control26 of clock26
   wire                UART_int126;     // UART26 module interrupt26 
   wire                ua_uclken126;    // Soft26 control26 of clock26
   wire  [3:1]         TTC_int26;            //Interrupt26 from PCI26 
  // inputs26 to SPI26 
   wire    ext_clk26;                // external26 clock26
   wire    SPI_int26;             // interrupt26 request
  // outputs26 from SPI26
   wire    slave_out_clk26;         // modified slave26 clock26 output
 // gpio26 generic26 inputs26 
   wire  [GPIO_WIDTH26-1:0]   n_gpio_bypass_oe26;        // bypass26 mode enable 
   wire  [GPIO_WIDTH26-1:0]   gpio_bypass_out26;         // bypass26 mode output value 
   wire  [GPIO_WIDTH26-1:0]   tri_state_enable26;   // disables26 op enable -> z 
 // outputs26 
   //amba26 outputs26 
   // gpio26 generic26 outputs26 
   wire       GPIO_int26;                // gpio_interupt26 for input pin26 change 
   wire [GPIO_WIDTH26-1:0]     gpio_bypass_in26;          // bypass26 mode input data value  
                
   wire           cpu_debug26;        // Inhibits26 watchdog26 counter 
   wire            ex_wdz_n26;         // External26 Watchdog26 zero indication26
   wire           rstn_non_srpg_smc26; 
   wire           rstn_non_srpg_urt26;
   wire           isolate_smc26;
   wire           save_edge_smc26;
   wire           restore_edge_smc26;
   wire           save_edge_urt26;
   wire           restore_edge_urt26;
   wire           pwr1_on_smc26;
   wire           pwr2_on_smc26;
   wire           pwr1_on_urt26;
   wire           pwr2_on_urt26;
   // ETH026
   wire            rstn_non_srpg_macb026;
   wire            gate_clk_macb026;
   wire            isolate_macb026;
   wire            save_edge_macb026;
   wire            restore_edge_macb026;
   wire            pwr1_on_macb026;
   wire            pwr2_on_macb026;
   // ETH126
   wire            rstn_non_srpg_macb126;
   wire            gate_clk_macb126;
   wire            isolate_macb126;
   wire            save_edge_macb126;
   wire            restore_edge_macb126;
   wire            pwr1_on_macb126;
   wire            pwr2_on_macb126;
   // ETH226
   wire            rstn_non_srpg_macb226;
   wire            gate_clk_macb226;
   wire            isolate_macb226;
   wire            save_edge_macb226;
   wire            restore_edge_macb226;
   wire            pwr1_on_macb226;
   wire            pwr2_on_macb226;
   // ETH326
   wire            rstn_non_srpg_macb326;
   wire            gate_clk_macb326;
   wire            isolate_macb326;
   wire            save_edge_macb326;
   wire            restore_edge_macb326;
   wire            pwr1_on_macb326;
   wire            pwr2_on_macb326;


   wire           pclk_SRPG_smc26;
   wire           pclk_SRPG_urt26;
   wire           gate_clk_smc26;
   wire           gate_clk_urt26;
   wire  [31:0]   tie_lo_32bit26; 
   wire  [1:0]	  tie_lo_2bit26;
   wire  	  tie_lo_1bit26;
   wire           pcm_macb_wakeup_int26;
   wire           int_source_h26;
   wire           isolate_mem26;

assign pcm_irq26 = pcm_macb_wakeup_int26;
assign ttc_irq26[2] = TTC_int26[3];
assign ttc_irq26[1] = TTC_int26[2];
assign ttc_irq26[0] = TTC_int26[1];
assign gpio_irq26 = GPIO_int26;
assign uart0_irq26 = UART_int26;
assign uart1_irq26 = UART_int126;
assign spi_irq26 = SPI_int26;

assign n_mo_en26   = 1'b0;
assign n_so_en26   = 1'b1;
assign n_sclk_en26 = 1'b0;
assign n_ss_en26   = 1'b0;

assign smc_hsel_int26 = smc_hsel26;
  assign ext_clk26  = 1'b0;
  assign int_source26 = {macb0_int26,macb1_int26, macb2_int26, macb3_int26,1'b0, pcm_macb_wakeup_int26, 1'b0, 1'b0, 1'b0, 1'b0, TTC_int26, GPIO_int26, UART_int26, UART_int126, SPI_int26, DMA_irq26};

  // interrupt26 even26 detect26 .
  // for sleep26 wake26 up -> any interrupt26 even26 and system not in hibernation26 (isolate_mem26 = 0)
  // for hibernate26 wake26 up -> gpio26 interrupt26 even26 and system in the hibernation26 (isolate_mem26 = 1)
  assign int_source_h26 =  ((|int_source26) && (!isolate_mem26)) || (isolate_mem26 && GPIO_int26) ;

  assign byte_sel26 = 1'b1;
  assign tie_hi_bit26 = 1'b1;

  assign smc_addr26 = smc_addr_int26[15:0];



  assign  n_gpio_bypass_oe26 = {GPIO_WIDTH26{1'b0}};        // bypass26 mode enable 
  assign  gpio_bypass_out26  = {GPIO_WIDTH26{1'b0}};
  assign  tri_state_enable26 = {GPIO_WIDTH26{1'b0}};
  assign  cpu_debug26 = 1'b0;
  assign  tie_lo_32bit26 = 32'b0;
  assign  tie_lo_2bit26  = 2'b0;
  assign  tie_lo_1bit26  = 1'b0;


ahb2apb26 #(
  32'h00800000, // Slave26 0 Address Range26
  32'h0080FFFF,

  32'h00810000, // Slave26 1 Address Range26
  32'h0081FFFF,

  32'h00820000, // Slave26 2 Address Range26 
  32'h0082FFFF,

  32'h00830000, // Slave26 3 Address Range26
  32'h0083FFFF,

  32'h00840000, // Slave26 4 Address Range26
  32'h0084FFFF,

  32'h00850000, // Slave26 5 Address Range26
  32'h0085FFFF,

  32'h00860000, // Slave26 6 Address Range26
  32'h0086FFFF,

  32'h00870000, // Slave26 7 Address Range26
  32'h0087FFFF,

  32'h00880000, // Slave26 8 Address Range26
  32'h0088FFFF
) i_ahb2apb26 (
     // AHB26 interface
    .hclk26(hclk26),         
    .hreset_n26(n_hreset26), 
    .hsel26(hsel26), 
    .haddr26(haddr26),        
    .htrans26(htrans26),       
    .hwrite26(hwrite26),       
    .hwdata26(hwdata26),       
    .hrdata26(hrdata26),   
    .hready26(hready26),   
    .hresp26(hresp26),     
    
     // APB26 interface
    .pclk26(pclk26),         
    .preset_n26(n_preset26),  
    .prdata026(prdata_spi26),
    .prdata126(prdata_uart026), 
    .prdata226(prdata_gpio26),  
    .prdata326(prdata_ttc26),   
    .prdata426(32'h0),   
    .prdata526(prdata_smc26),   
    .prdata626(prdata_pmc26),    
    .prdata726(32'h0),   
    .prdata826(prdata_uart126),  
    .pready026(pready_spi26),     
    .pready126(pready_uart026),   
    .pready226(tie_hi_bit26),     
    .pready326(tie_hi_bit26),     
    .pready426(tie_hi_bit26),     
    .pready526(tie_hi_bit26),     
    .pready626(tie_hi_bit26),     
    .pready726(tie_hi_bit26),     
    .pready826(pready_uart126),  
    .pwdata26(pwdata26),       
    .pwrite26(pwrite26),       
    .paddr26(paddr26),        
    .psel026(psel_spi26),     
    .psel126(psel_uart026),   
    .psel226(psel_gpio26),    
    .psel326(psel_ttc26),     
    .psel426(),     
    .psel526(psel_smc26),     
    .psel626(psel_pmc26),    
    .psel726(psel_apic26),   
    .psel826(psel_uart126),  
    .penable26(penable26)     
);

spi_top26 i_spi26
(
  // Wishbone26 signals26
  .wb_clk_i26(pclk26), 
  .wb_rst_i26(~n_preset26), 
  .wb_adr_i26(paddr26[4:0]), 
  .wb_dat_i26(pwdata26), 
  .wb_dat_o26(prdata_spi26), 
  .wb_sel_i26(4'b1111),    // SPI26 register accesses are always 32-bit
  .wb_we_i26(pwrite26), 
  .wb_stb_i26(psel_spi26), 
  .wb_cyc_i26(psel_spi26), 
  .wb_ack_o26(pready_spi26), 
  .wb_err_o26(), 
  .wb_int_o26(SPI_int26),

  // SPI26 signals26
  .ss_pad_o26(n_ss_out26), 
  .sclk_pad_o26(sclk_out26), 
  .mosi_pad_o26(mo26), 
  .miso_pad_i26(mi26)
);

// Opencores26 UART26 instances26
wire ua_nrts_int26;
wire ua_nrts1_int26;

assign ua_nrts26 = ua_nrts_int26;
assign ua_nrts126 = ua_nrts1_int26;

reg [3:0] uart0_sel_i26;
reg [3:0] uart1_sel_i26;
// UART26 registers are all 8-bit wide26, and their26 addresses26
// are on byte boundaries26. So26 to access them26 on the
// Wishbone26 bus, the CPU26 must do byte accesses to these26
// byte addresses26. Word26 address accesses are not possible26
// because the word26 addresses26 will be unaligned26, and cause
// a fault26.
// So26, Uart26 accesses from the CPU26 will always be 8-bit size
// We26 only have to decide26 which byte of the 4-byte word26 the
// CPU26 is interested26 in.
`ifdef SYSTEM_BIG_ENDIAN26
always @(paddr26) begin
  case (paddr26[1:0])
    2'b00 : uart0_sel_i26 = 4'b1000;
    2'b01 : uart0_sel_i26 = 4'b0100;
    2'b10 : uart0_sel_i26 = 4'b0010;
    2'b11 : uart0_sel_i26 = 4'b0001;
  endcase
end
always @(paddr26) begin
  case (paddr26[1:0])
    2'b00 : uart1_sel_i26 = 4'b1000;
    2'b01 : uart1_sel_i26 = 4'b0100;
    2'b10 : uart1_sel_i26 = 4'b0010;
    2'b11 : uart1_sel_i26 = 4'b0001;
  endcase
end
`else
always @(paddr26) begin
  case (paddr26[1:0])
    2'b00 : uart0_sel_i26 = 4'b0001;
    2'b01 : uart0_sel_i26 = 4'b0010;
    2'b10 : uart0_sel_i26 = 4'b0100;
    2'b11 : uart0_sel_i26 = 4'b1000;
  endcase
end
always @(paddr26) begin
  case (paddr26[1:0])
    2'b00 : uart1_sel_i26 = 4'b0001;
    2'b01 : uart1_sel_i26 = 4'b0010;
    2'b10 : uart1_sel_i26 = 4'b0100;
    2'b11 : uart1_sel_i26 = 4'b1000;
  endcase
end
`endif

uart_top26 i_oc_uart026 (
  .wb_clk_i26(pclk26),
  .wb_rst_i26(~n_preset26),
  .wb_adr_i26(paddr26[4:0]),
  .wb_dat_i26(pwdata26),
  .wb_dat_o26(prdata_uart026),
  .wb_we_i26(pwrite26),
  .wb_stb_i26(psel_uart026),
  .wb_cyc_i26(psel_uart026),
  .wb_ack_o26(pready_uart026),
  .wb_sel_i26(uart0_sel_i26),
  .int_o26(UART_int26),
  .stx_pad_o26(ua_txd26),
  .srx_pad_i26(ua_rxd26),
  .rts_pad_o26(ua_nrts_int26),
  .cts_pad_i26(ua_ncts26),
  .dtr_pad_o26(),
  .dsr_pad_i26(1'b0),
  .ri_pad_i26(1'b0),
  .dcd_pad_i26(1'b0)
);

uart_top26 i_oc_uart126 (
  .wb_clk_i26(pclk26),
  .wb_rst_i26(~n_preset26),
  .wb_adr_i26(paddr26[4:0]),
  .wb_dat_i26(pwdata26),
  .wb_dat_o26(prdata_uart126),
  .wb_we_i26(pwrite26),
  .wb_stb_i26(psel_uart126),
  .wb_cyc_i26(psel_uart126),
  .wb_ack_o26(pready_uart126),
  .wb_sel_i26(uart1_sel_i26),
  .int_o26(UART_int126),
  .stx_pad_o26(ua_txd126),
  .srx_pad_i26(ua_rxd126),
  .rts_pad_o26(ua_nrts1_int26),
  .cts_pad_i26(ua_ncts126),
  .dtr_pad_o26(),
  .dsr_pad_i26(1'b0),
  .ri_pad_i26(1'b0),
  .dcd_pad_i26(1'b0)
);

gpio_veneer26 i_gpio_veneer26 (
        //inputs26

        . n_p_reset26(n_preset26),
        . pclk26(pclk26),
        . psel26(psel_gpio26),
        . penable26(penable26),
        . pwrite26(pwrite26),
        . paddr26(paddr26[5:0]),
        . pwdata26(pwdata26),
        . gpio_pin_in26(gpio_pin_in26),
        . scan_en26(scan_en26),
        . tri_state_enable26(tri_state_enable26),
        . scan_in26(), //added by smarkov26 for dft26

        //outputs26
        . scan_out26(), //added by smarkov26 for dft26
        . prdata26(prdata_gpio26),
        . gpio_int26(GPIO_int26),
        . n_gpio_pin_oe26(n_gpio_pin_oe26),
        . gpio_pin_out26(gpio_pin_out26)
);


ttc_veneer26 i_ttc_veneer26 (

         //inputs26
        . n_p_reset26(n_preset26),
        . pclk26(pclk26),
        . psel26(psel_ttc26),
        . penable26(penable26),
        . pwrite26(pwrite26),
        . pwdata26(pwdata26),
        . paddr26(paddr26[7:0]),
        . scan_in26(),
        . scan_en26(scan_en26),

        //outputs26
        . prdata26(prdata_ttc26),
        . interrupt26(TTC_int26[3:1]),
        . scan_out26()
);


smc_veneer26 i_smc_veneer26 (
        //inputs26
	//apb26 inputs26
        . n_preset26(n_preset26),
        . pclk26(pclk_SRPG_smc26),
        . psel26(psel_smc26),
        . penable26(penable26),
        . pwrite26(pwrite26),
        . paddr26(paddr26[4:0]),
        . pwdata26(pwdata26),
        //ahb26 inputs26
	. hclk26(smc_hclk26),
        . n_sys_reset26(rstn_non_srpg_smc26),
        . haddr26(smc_haddr26),
        . htrans26(smc_htrans26),
        . hsel26(smc_hsel_int26),
        . hwrite26(smc_hwrite26),
	. hsize26(smc_hsize26),
        . hwdata26(smc_hwdata26),
        . hready26(smc_hready_in26),
        . data_smc26(data_smc26),

         //test signal26 inputs26

        . scan_in_126(),
        . scan_in_226(),
        . scan_in_326(),
        . scan_en26(scan_en26),

        //apb26 outputs26
        . prdata26(prdata_smc26),

       //design output

        . smc_hrdata26(smc_hrdata26),
        . smc_hready26(smc_hready26),
        . smc_hresp26(smc_hresp26),
        . smc_valid26(smc_valid26),
        . smc_addr26(smc_addr_int26),
        . smc_data26(smc_data26),
        . smc_n_be26(smc_n_be26),
        . smc_n_cs26(smc_n_cs26),
        . smc_n_wr26(smc_n_wr26),
        . smc_n_we26(smc_n_we26),
        . smc_n_rd26(smc_n_rd26),
        . smc_n_ext_oe26(smc_n_ext_oe26),
        . smc_busy26(smc_busy26),

         //test signal26 output
        . scan_out_126(),
        . scan_out_226(),
        . scan_out_326()
);

power_ctrl_veneer26 i_power_ctrl_veneer26 (
    // -- Clocks26 & Reset26
    	.pclk26(pclk26), 			//  : in  std_logic26;
    	.nprst26(n_preset26), 		//  : in  std_logic26;
    // -- APB26 programming26 interface
    	.paddr26(paddr26), 			//  : in  std_logic_vector26(31 downto26 0);
    	.psel26(psel_pmc26), 			//  : in  std_logic26;
    	.penable26(penable26), 		//  : in  std_logic26;
    	.pwrite26(pwrite26), 		//  : in  std_logic26;
    	.pwdata26(pwdata26), 		//  : in  std_logic_vector26(31 downto26 0);
    	.prdata26(prdata_pmc26), 		//  : out std_logic_vector26(31 downto26 0);
        .macb3_wakeup26(macb3_wakeup26),
        .macb2_wakeup26(macb2_wakeup26),
        .macb1_wakeup26(macb1_wakeup26),
        .macb0_wakeup26(macb0_wakeup26),
    // -- Module26 control26 outputs26
    	.scan_in26(),			//  : in  std_logic26;
    	.scan_en26(scan_en26),             	//  : in  std_logic26;
    	.scan_mode26(scan_mode26),          //  : in  std_logic26;
    	.scan_out26(),            	//  : out std_logic26;
        .int_source_h26(int_source_h26),
     	.rstn_non_srpg_smc26(rstn_non_srpg_smc26), 		//   : out std_logic26;
    	.gate_clk_smc26(gate_clk_smc26), 	//  : out std_logic26;
    	.isolate_smc26(isolate_smc26), 	//  : out std_logic26;
    	.save_edge_smc26(save_edge_smc26), 	//  : out std_logic26;
    	.restore_edge_smc26(restore_edge_smc26), 	//  : out std_logic26;
    	.pwr1_on_smc26(pwr1_on_smc26), 	//  : out std_logic26;
    	.pwr2_on_smc26(pwr2_on_smc26), 	//  : out std_logic26
     	.rstn_non_srpg_urt26(rstn_non_srpg_urt26), 		//   : out std_logic26;
    	.gate_clk_urt26(gate_clk_urt26), 	//  : out std_logic26;
    	.isolate_urt26(isolate_urt26), 	//  : out std_logic26;
    	.save_edge_urt26(save_edge_urt26), 	//  : out std_logic26;
    	.restore_edge_urt26(restore_edge_urt26), 	//  : out std_logic26;
    	.pwr1_on_urt26(pwr1_on_urt26), 	//  : out std_logic26;
    	.pwr2_on_urt26(pwr2_on_urt26),  	//  : out std_logic26
        // ETH026
        .rstn_non_srpg_macb026(rstn_non_srpg_macb026),
        .gate_clk_macb026(gate_clk_macb026),
        .isolate_macb026(isolate_macb026),
        .save_edge_macb026(save_edge_macb026),
        .restore_edge_macb026(restore_edge_macb026),
        .pwr1_on_macb026(pwr1_on_macb026),
        .pwr2_on_macb026(pwr2_on_macb026),
        // ETH126
        .rstn_non_srpg_macb126(rstn_non_srpg_macb126),
        .gate_clk_macb126(gate_clk_macb126),
        .isolate_macb126(isolate_macb126),
        .save_edge_macb126(save_edge_macb126),
        .restore_edge_macb126(restore_edge_macb126),
        .pwr1_on_macb126(pwr1_on_macb126),
        .pwr2_on_macb126(pwr2_on_macb126),
        // ETH226
        .rstn_non_srpg_macb226(rstn_non_srpg_macb226),
        .gate_clk_macb226(gate_clk_macb226),
        .isolate_macb226(isolate_macb226),
        .save_edge_macb226(save_edge_macb226),
        .restore_edge_macb226(restore_edge_macb226),
        .pwr1_on_macb226(pwr1_on_macb226),
        .pwr2_on_macb226(pwr2_on_macb226),
        // ETH326
        .rstn_non_srpg_macb326(rstn_non_srpg_macb326),
        .gate_clk_macb326(gate_clk_macb326),
        .isolate_macb326(isolate_macb326),
        .save_edge_macb326(save_edge_macb326),
        .restore_edge_macb326(restore_edge_macb326),
        .pwr1_on_macb326(pwr1_on_macb326),
        .pwr2_on_macb326(pwr2_on_macb326),
        .core06v26(core06v26),
        .core08v26(core08v26),
        .core10v26(core10v26),
        .core12v26(core12v26),
        .pcm_macb_wakeup_int26(pcm_macb_wakeup_int26),
        .isolate_mem26(isolate_mem26),
        .mte_smc_start26(mte_smc_start26),
        .mte_uart_start26(mte_uart_start26),
        .mte_smc_uart_start26(mte_smc_uart_start26),  
        .mte_pm_smc_to_default_start26(mte_pm_smc_to_default_start26), 
        .mte_pm_uart_to_default_start26(mte_pm_uart_to_default_start26),
        .mte_pm_smc_uart_to_default_start26(mte_pm_smc_uart_to_default_start26)
);

// Clock26 gating26 macro26 to shut26 off26 clocks26 to the SRPG26 flops26 in the SMC26
//CKLNQD126 i_SMC_SRPG_clk_gate26  (
//	.TE26(scan_mode26), 
//	.E26(~gate_clk_smc26), 
//	.CP26(pclk26), 
//	.Q26(pclk_SRPG_smc26)
//	);
// Replace26 gate26 with behavioural26 code26 //
wire 	smc_scan_gate26;
reg 	smc_latched_enable26;
assign smc_scan_gate26 = scan_mode26 ? 1'b1 : ~gate_clk_smc26;

always @ (pclk26 or smc_scan_gate26)
  	if (pclk26 == 1'b0) begin
  		smc_latched_enable26 <= smc_scan_gate26;
  	end  	
	
assign pclk_SRPG_smc26 = smc_latched_enable26 ? pclk26 : 1'b0;


// Clock26 gating26 macro26 to shut26 off26 clocks26 to the SRPG26 flops26 in the URT26
//CKLNQD126 i_URT_SRPG_clk_gate26  (
//	.TE26(scan_mode26), 
//	.E26(~gate_clk_urt26), 
//	.CP26(pclk26), 
//	.Q26(pclk_SRPG_urt26)
//	);
// Replace26 gate26 with behavioural26 code26 //
wire 	urt_scan_gate26;
reg 	urt_latched_enable26;
assign urt_scan_gate26 = scan_mode26 ? 1'b1 : ~gate_clk_urt26;

always @ (pclk26 or urt_scan_gate26)
  	if (pclk26 == 1'b0) begin
  		urt_latched_enable26 <= urt_scan_gate26;
  	end  	
	
assign pclk_SRPG_urt26 = urt_latched_enable26 ? pclk26 : 1'b0;

// ETH026
wire 	macb0_scan_gate26;
reg 	macb0_latched_enable26;
assign macb0_scan_gate26 = scan_mode26 ? 1'b1 : ~gate_clk_macb026;

always @ (pclk26 or macb0_scan_gate26)
  	if (pclk26 == 1'b0) begin
  		macb0_latched_enable26 <= macb0_scan_gate26;
  	end  	
	
assign clk_SRPG_macb0_en26 = macb0_latched_enable26 ? 1'b1 : 1'b0;

// ETH126
wire 	macb1_scan_gate26;
reg 	macb1_latched_enable26;
assign macb1_scan_gate26 = scan_mode26 ? 1'b1 : ~gate_clk_macb126;

always @ (pclk26 or macb1_scan_gate26)
  	if (pclk26 == 1'b0) begin
  		macb1_latched_enable26 <= macb1_scan_gate26;
  	end  	
	
assign clk_SRPG_macb1_en26 = macb1_latched_enable26 ? 1'b1 : 1'b0;

// ETH226
wire 	macb2_scan_gate26;
reg 	macb2_latched_enable26;
assign macb2_scan_gate26 = scan_mode26 ? 1'b1 : ~gate_clk_macb226;

always @ (pclk26 or macb2_scan_gate26)
  	if (pclk26 == 1'b0) begin
  		macb2_latched_enable26 <= macb2_scan_gate26;
  	end  	
	
assign clk_SRPG_macb2_en26 = macb2_latched_enable26 ? 1'b1 : 1'b0;

// ETH326
wire 	macb3_scan_gate26;
reg 	macb3_latched_enable26;
assign macb3_scan_gate26 = scan_mode26 ? 1'b1 : ~gate_clk_macb326;

always @ (pclk26 or macb3_scan_gate26)
  	if (pclk26 == 1'b0) begin
  		macb3_latched_enable26 <= macb3_scan_gate26;
  	end  	
	
assign clk_SRPG_macb3_en26 = macb3_latched_enable26 ? 1'b1 : 1'b0;



`else
//------------------------------------------------------------------------------
// if the APB26 subsystem26 is black26 boxed26 
//------------------------------------------------------------------------------
// wire s ports26
    // system signals26
    wire         hclk26;     // AHB26 Clock26
    wire         n_hreset26;  // AHB26 reset - Active26 low26
    wire         pclk26;     // APB26 Clock26. 
    wire         n_preset26;  // APB26 reset - Active26 low26

    // AHB26 interface
    wire         ahb2apb0_hsel26;     // AHB2APB26 select26
    wire  [31:0] haddr26;    // Address bus
    wire  [1:0]  htrans26;   // Transfer26 type
    wire  [2:0]  hsize26;    // AHB26 Access type - byte, half26-word26, word26
    wire  [31:0] hwdata26;   // Write data
    wire         hwrite26;   // Write signal26/
    wire         hready_in26;// Indicates26 that last master26 has finished26 bus access
    wire [2:0]   hburst26;     // Burst type
    wire [3:0]   hprot26;      // Protection26 control26
    wire [3:0]   hmaster26;    // Master26 select26
    wire         hmastlock26;  // Locked26 transfer26
  // Interrupts26 from the Enet26 MACs26
    wire         macb0_int26;
    wire         macb1_int26;
    wire         macb2_int26;
    wire         macb3_int26;
  // Interrupt26 from the DMA26
    wire         DMA_irq26;
  // Scan26 wire s
    wire         scan_en26;    // Scan26 enable pin26
    wire         scan_in_126;  // Scan26 wire  for first chain26
    wire         scan_in_226;  // Scan26 wire  for second chain26
    wire         scan_mode26;  // test mode pin26
 
  //wire  for smc26 AHB26 interface
    wire         smc_hclk26;
    wire         smc_n_hclk26;
    wire  [31:0] smc_haddr26;
    wire  [1:0]  smc_htrans26;
    wire         smc_hsel26;
    wire         smc_hwrite26;
    wire  [2:0]  smc_hsize26;
    wire  [31:0] smc_hwdata26;
    wire         smc_hready_in26;
    wire  [2:0]  smc_hburst26;     // Burst type
    wire  [3:0]  smc_hprot26;      // Protection26 control26
    wire  [3:0]  smc_hmaster26;    // Master26 select26
    wire         smc_hmastlock26;  // Locked26 transfer26


    wire  [31:0] data_smc26;     // EMI26(External26 memory) read data
    
  //wire s for uart26
    wire         ua_rxd26;       // UART26 receiver26 serial26 wire  pin26
    wire         ua_rxd126;      // UART26 receiver26 serial26 wire  pin26
    wire         ua_ncts26;      // Clear-To26-Send26 flow26 control26
    wire         ua_ncts126;      // Clear-To26-Send26 flow26 control26
   //wire s for spi26
    wire         n_ss_in26;      // select26 wire  to slave26
    wire         mi26;           // data wire  to master26
    wire         si26;           // data wire  to slave26
    wire         sclk_in26;      // clock26 wire  to slave26
  //wire s for GPIO26
   wire  [GPIO_WIDTH26-1:0]  gpio_pin_in26;             // wire  data from pin26

  //reg    ports26
  // Scan26 reg   s
   reg           scan_out_126;   // Scan26 out for chain26 1
   reg           scan_out_226;   // Scan26 out for chain26 2
  //AHB26 interface 
   reg    [31:0] hrdata26;       // Read data provided from target slave26
   reg           hready26;       // Ready26 for new bus cycle from target slave26
   reg    [1:0]  hresp26;       // Response26 from the bridge26

   // SMC26 reg    for AHB26 interface
   reg    [31:0]    smc_hrdata26;
   reg              smc_hready26;
   reg    [1:0]     smc_hresp26;

  //reg   s from smc26
   reg    [15:0]    smc_addr26;      // External26 Memory (EMI26) address
   reg    [3:0]     smc_n_be26;      // EMI26 byte enables26 (Active26 LOW26)
   reg    [7:0]     smc_n_cs26;      // EMI26 Chip26 Selects26 (Active26 LOW26)
   reg    [3:0]     smc_n_we26;      // EMI26 write strobes26 (Active26 LOW26)
   reg              smc_n_wr26;      // EMI26 write enable (Active26 LOW26)
   reg              smc_n_rd26;      // EMI26 read stobe26 (Active26 LOW26)
   reg              smc_n_ext_oe26;  // EMI26 write data reg    enable
   reg    [31:0]    smc_data26;      // EMI26 write data
  //reg   s from uart26
   reg           ua_txd26;       	// UART26 transmitter26 serial26 reg   
   reg           ua_txd126;       // UART26 transmitter26 serial26 reg   
   reg           ua_nrts26;      	// Request26-To26-Send26 flow26 control26
   reg           ua_nrts126;      // Request26-To26-Send26 flow26 control26
   // reg   s from ttc26
  // reg   s from SPI26
   reg       so;                    // data reg    from slave26
   reg       mo26;                    // data reg    from master26
   reg       sclk_out26;              // clock26 reg    from master26
   reg    [P_SIZE26-1:0] n_ss_out26;    // peripheral26 select26 lines26 from master26
   reg       n_so_en26;               // out enable for slave26 data
   reg       n_mo_en26;               // out enable for master26 data
   reg       n_sclk_en26;             // out enable for master26 clock26
   reg       n_ss_en26;               // out enable for master26 peripheral26 lines26
  //reg   s from gpio26
   reg    [GPIO_WIDTH26-1:0]     n_gpio_pin_oe26;           // reg    enable signal26 to pin26
   reg    [GPIO_WIDTH26-1:0]     gpio_pin_out26;            // reg    signal26 to pin26


`endif
//------------------------------------------------------------------------------
// black26 boxed26 defines26 
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// APB26 and AHB26 interface formal26 verification26 monitors26
//------------------------------------------------------------------------------
`ifdef ABV_ON26
apb_assert26 i_apb_assert26 (

        // APB26 signals26
  	.n_preset26(n_preset26),
   	.pclk26(pclk26),
	.penable26(penable26),
	.paddr26(paddr26),
	.pwrite26(pwrite26),
	.pwdata26(pwdata26),

	.psel0026(psel_spi26),
	.psel0126(psel_uart026),
	.psel0226(psel_gpio26),
	.psel0326(psel_ttc26),
	.psel0426(1'b0),
	.psel0526(psel_smc26),
	.psel0626(1'b0),
	.psel0726(1'b0),
	.psel0826(1'b0),
	.psel0926(1'b0),
	.psel1026(1'b0),
	.psel1126(1'b0),
	.psel1226(1'b0),
	.psel1326(psel_pmc26),
	.psel1426(psel_apic26),
	.psel1526(psel_uart126),

        .prdata0026(prdata_spi26),
        .prdata0126(prdata_uart026), // Read Data from peripheral26 UART26 
        .prdata0226(prdata_gpio26), // Read Data from peripheral26 GPIO26
        .prdata0326(prdata_ttc26), // Read Data from peripheral26 TTC26
        .prdata0426(32'b0), // 
        .prdata0526(prdata_smc26), // Read Data from peripheral26 SMC26
        .prdata1326(prdata_pmc26), // Read Data from peripheral26 Power26 Control26 Block
   	.prdata1426(32'b0), // 
        .prdata1526(prdata_uart126),


        // AHB26 signals26
        .hclk26(hclk26),         // ahb26 system clock26
        .n_hreset26(n_hreset26), // ahb26 system reset

        // ahb2apb26 signals26
        .hresp26(hresp26),
        .hready26(hready26),
        .hrdata26(hrdata26),
        .hwdata26(hwdata26),
        .hprot26(hprot26),
        .hburst26(hburst26),
        .hsize26(hsize26),
        .hwrite26(hwrite26),
        .htrans26(htrans26),
        .haddr26(haddr26),
        .ahb2apb_hsel26(ahb2apb0_hsel26));



//------------------------------------------------------------------------------
// AHB26 interface formal26 verification26 monitor26
//------------------------------------------------------------------------------
defparam i_ahbSlaveMonitor26.DBUS_WIDTH26 = 32;
defparam i_ahbMasterMonitor26.DBUS_WIDTH26 = 32;


// AHB2APB26 Bridge26

    ahb_liteslave_monitor26 i_ahbSlaveMonitor26 (
        .hclk_i26(hclk26),
        .hresetn_i26(n_hreset26),
        .hresp26(hresp26),
        .hready26(hready26),
        .hready_global_i26(hready26),
        .hrdata26(hrdata26),
        .hwdata_i26(hwdata26),
        .hburst_i26(hburst26),
        .hsize_i26(hsize26),
        .hwrite_i26(hwrite26),
        .htrans_i26(htrans26),
        .haddr_i26(haddr26),
        .hsel_i26(ahb2apb0_hsel26)
    );


  ahb_litemaster_monitor26 i_ahbMasterMonitor26 (
          .hclk_i26(hclk26),
          .hresetn_i26(n_hreset26),
          .hresp_i26(hresp26),
          .hready_i26(hready26),
          .hrdata_i26(hrdata26),
          .hlock26(1'b0),
          .hwdata26(hwdata26),
          .hprot26(hprot26),
          .hburst26(hburst26),
          .hsize26(hsize26),
          .hwrite26(hwrite26),
          .htrans26(htrans26),
          .haddr26(haddr26)
          );







`endif




`ifdef IFV_LP_ABV_ON26
// power26 control26
wire isolate26;

// testbench mirror signals26
wire L1_ctrl_access26;
wire L1_status_access26;

wire [31:0] L1_status_reg26;
wire [31:0] L1_ctrl_reg26;

//wire rstn_non_srpg_urt26;
//wire isolate_urt26;
//wire retain_urt26;
//wire gate_clk_urt26;
//wire pwr1_on_urt26;


// smc26 signals26
wire [31:0] smc_prdata26;
wire lp_clk_smc26;
                    

// uart26 isolation26 register
  wire [15:0] ua_prdata26;
  wire ua_int26;
  assign ua_prdata26          =  i_uart1_veneer26.prdata26;
  assign ua_int26             =  i_uart1_veneer26.ua_int26;


assign lp_clk_smc26          = i_smc_veneer26.pclk26;
assign smc_prdata26          = i_smc_veneer26.prdata26;
lp_chk_smc26 u_lp_chk_smc26 (
    .clk26 (hclk26),
    .rst26 (n_hreset26),
    .iso_smc26 (isolate_smc26),
    .gate_clk26 (gate_clk_smc26),
    .lp_clk26 (pclk_SRPG_smc26),

    // srpg26 outputs26
    .smc_hrdata26 (smc_hrdata26),
    .smc_hready26 (smc_hready26),
    .smc_hresp26  (smc_hresp26),
    .smc_valid26 (smc_valid26),
    .smc_addr_int26 (smc_addr_int26),
    .smc_data26 (smc_data26),
    .smc_n_be26 (smc_n_be26),
    .smc_n_cs26  (smc_n_cs26),
    .smc_n_wr26 (smc_n_wr26),
    .smc_n_we26 (smc_n_we26),
    .smc_n_rd26 (smc_n_rd26),
    .smc_n_ext_oe26 (smc_n_ext_oe26)
   );

// lp26 retention26/isolation26 assertions26
lp_chk_uart26 u_lp_chk_urt26 (

  .clk26         (hclk26),
  .rst26         (n_hreset26),
  .iso_urt26     (isolate_urt26),
  .gate_clk26    (gate_clk_urt26),
  .lp_clk26      (pclk_SRPG_urt26),
  //ports26
  .prdata26 (ua_prdata26),
  .ua_int26 (ua_int26),
  .ua_txd26 (ua_txd126),
  .ua_nrts26 (ua_nrts126)
 );

`endif  //IFV_LP_ABV_ON26




endmodule
