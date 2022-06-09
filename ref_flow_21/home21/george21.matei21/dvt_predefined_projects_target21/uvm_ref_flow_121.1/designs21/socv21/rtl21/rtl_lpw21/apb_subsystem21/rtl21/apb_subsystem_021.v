//File21 name   : apb_subsystem_021.v
//Title21       : 
//Created21     : 1999
//Description21 : 
//Notes21       : 
//----------------------------------------------------------------------
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------

module apb_subsystem_021(
    // AHB21 interface
    hclk21,
    n_hreset21,
    hsel21,
    haddr21,
    htrans21,
    hsize21,
    hwrite21,
    hwdata21,
    hready_in21,
    hburst21,
    hprot21,
    hmaster21,
    hmastlock21,
    hrdata21,
    hready21,
    hresp21,
    
    // APB21 system interface
    pclk21,
    n_preset21,
    
    // SPI21 ports21
    n_ss_in21,
    mi21,
    si21,
    sclk_in21,
    so,
    mo21,
    sclk_out21,
    n_ss_out21,
    n_so_en21,
    n_mo_en21,
    n_sclk_en21,
    n_ss_en21,
    
    //UART021 ports21
    ua_rxd21,
    ua_ncts21,
    ua_txd21,
    ua_nrts21,
    
    //UART121 ports21
    ua_rxd121,
    ua_ncts121,
    ua_txd121,
    ua_nrts121,
    
    //GPIO21 ports21
    gpio_pin_in21,
    n_gpio_pin_oe21,
    gpio_pin_out21,
    

    //SMC21 ports21
    smc_hclk21,
    smc_n_hclk21,
    smc_haddr21,
    smc_htrans21,
    smc_hsel21,
    smc_hwrite21,
    smc_hsize21,
    smc_hwdata21,
    smc_hready_in21,
    smc_hburst21,
    smc_hprot21,
    smc_hmaster21,
    smc_hmastlock21,
    smc_hrdata21, 
    smc_hready21,
    smc_hresp21,
    smc_n_ext_oe21,
    smc_data21,
    smc_addr21,
    smc_n_be21,
    smc_n_cs21, 
    smc_n_we21,
    smc_n_wr21,
    smc_n_rd21,
    data_smc21,
    
    //PMC21 ports21
    clk_SRPG_macb0_en21,
    clk_SRPG_macb1_en21,
    clk_SRPG_macb2_en21,
    clk_SRPG_macb3_en21,
    core06v21,
    core08v21,
    core10v21,
    core12v21,
    macb3_wakeup21,
    macb2_wakeup21,
    macb1_wakeup21,
    macb0_wakeup21,
    mte_smc_start21,
    mte_uart_start21,
    mte_smc_uart_start21,  
    mte_pm_smc_to_default_start21, 
    mte_pm_uart_to_default_start21,
    mte_pm_smc_uart_to_default_start21,
    
    
    // Peripheral21 inerrupts21
    pcm_irq21,
    ttc_irq21,
    gpio_irq21,
    uart0_irq21,
    uart1_irq21,
    spi_irq21,
    DMA_irq21,      
    macb0_int21,
    macb1_int21,
    macb2_int21,
    macb3_int21,
   
    // Scan21 ports21
    scan_en21,      // Scan21 enable pin21
    scan_in_121,    // Scan21 input for first chain21
    scan_in_221,    // Scan21 input for second chain21
    scan_mode21,
    scan_out_121,   // Scan21 out for chain21 1
    scan_out_221    // Scan21 out for chain21 2
);

parameter GPIO_WIDTH21 = 16;        // GPIO21 width
parameter P_SIZE21 =   8;              // number21 of peripheral21 select21 lines21
parameter NO_OF_IRQS21  = 17;      //No of irqs21 read by apic21 

// AHB21 interface
input         hclk21;     // AHB21 Clock21
input         n_hreset21;  // AHB21 reset - Active21 low21
input         hsel21;     // AHB2APB21 select21
input [31:0]  haddr21;    // Address bus
input [1:0]   htrans21;   // Transfer21 type
input [2:0]   hsize21;    // AHB21 Access type - byte, half21-word21, word21
input [31:0]  hwdata21;   // Write data
input         hwrite21;   // Write signal21/
input         hready_in21;// Indicates21 that last master21 has finished21 bus access
input [2:0]   hburst21;     // Burst type
input [3:0]   hprot21;      // Protection21 control21
input [3:0]   hmaster21;    // Master21 select21
input         hmastlock21;  // Locked21 transfer21
output [31:0] hrdata21;       // Read data provided from target slave21
output        hready21;       // Ready21 for new bus cycle from target slave21
output [1:0]  hresp21;       // Response21 from the bridge21
    
// APB21 system interface
input         pclk21;     // APB21 Clock21. 
input         n_preset21;  // APB21 reset - Active21 low21
   
// SPI21 ports21
input     n_ss_in21;      // select21 input to slave21
input     mi21;           // data input to master21
input     si21;           // data input to slave21
input     sclk_in21;      // clock21 input to slave21
output    so;                    // data output from slave21
output    mo21;                    // data output from master21
output    sclk_out21;              // clock21 output from master21
output [P_SIZE21-1:0] n_ss_out21;    // peripheral21 select21 lines21 from master21
output    n_so_en21;               // out enable for slave21 data
output    n_mo_en21;               // out enable for master21 data
output    n_sclk_en21;             // out enable for master21 clock21
output    n_ss_en21;               // out enable for master21 peripheral21 lines21

//UART021 ports21
input        ua_rxd21;       // UART21 receiver21 serial21 input pin21
input        ua_ncts21;      // Clear-To21-Send21 flow21 control21
output       ua_txd21;       	// UART21 transmitter21 serial21 output
output       ua_nrts21;      	// Request21-To21-Send21 flow21 control21

// UART121 ports21   
input        ua_rxd121;      // UART21 receiver21 serial21 input pin21
input        ua_ncts121;      // Clear-To21-Send21 flow21 control21
output       ua_txd121;       // UART21 transmitter21 serial21 output
output       ua_nrts121;      // Request21-To21-Send21 flow21 control21

//GPIO21 ports21
input [GPIO_WIDTH21-1:0]      gpio_pin_in21;             // input data from pin21
output [GPIO_WIDTH21-1:0]     n_gpio_pin_oe21;           // output enable signal21 to pin21
output [GPIO_WIDTH21-1:0]     gpio_pin_out21;            // output signal21 to pin21
  
//SMC21 ports21
input        smc_hclk21;
input        smc_n_hclk21;
input [31:0] smc_haddr21;
input [1:0]  smc_htrans21;
input        smc_hsel21;
input        smc_hwrite21;
input [2:0]  smc_hsize21;
input [31:0] smc_hwdata21;
input        smc_hready_in21;
input [2:0]  smc_hburst21;     // Burst type
input [3:0]  smc_hprot21;      // Protection21 control21
input [3:0]  smc_hmaster21;    // Master21 select21
input        smc_hmastlock21;  // Locked21 transfer21
input [31:0] data_smc21;     // EMI21(External21 memory) read data
output [31:0]    smc_hrdata21;
output           smc_hready21;
output [1:0]     smc_hresp21;
output [15:0]    smc_addr21;      // External21 Memory (EMI21) address
output [3:0]     smc_n_be21;      // EMI21 byte enables21 (Active21 LOW21)
output           smc_n_cs21;      // EMI21 Chip21 Selects21 (Active21 LOW21)
output [3:0]     smc_n_we21;      // EMI21 write strobes21 (Active21 LOW21)
output           smc_n_wr21;      // EMI21 write enable (Active21 LOW21)
output           smc_n_rd21;      // EMI21 read stobe21 (Active21 LOW21)
output           smc_n_ext_oe21;  // EMI21 write data output enable
output [31:0]    smc_data21;      // EMI21 write data
       
//PMC21 ports21
output clk_SRPG_macb0_en21;
output clk_SRPG_macb1_en21;
output clk_SRPG_macb2_en21;
output clk_SRPG_macb3_en21;
output core06v21;
output core08v21;
output core10v21;
output core12v21;
output mte_smc_start21;
output mte_uart_start21;
output mte_smc_uart_start21;  
output mte_pm_smc_to_default_start21; 
output mte_pm_uart_to_default_start21;
output mte_pm_smc_uart_to_default_start21;
input macb3_wakeup21;
input macb2_wakeup21;
input macb1_wakeup21;
input macb0_wakeup21;
    

// Peripheral21 interrupts21
output pcm_irq21;
output [2:0] ttc_irq21;
output gpio_irq21;
output uart0_irq21;
output uart1_irq21;
output spi_irq21;
input        macb0_int21;
input        macb1_int21;
input        macb2_int21;
input        macb3_int21;
input        DMA_irq21;
  
//Scan21 ports21
input        scan_en21;    // Scan21 enable pin21
input        scan_in_121;  // Scan21 input for first chain21
input        scan_in_221;  // Scan21 input for second chain21
input        scan_mode21;  // test mode pin21
 output        scan_out_121;   // Scan21 out for chain21 1
 output        scan_out_221;   // Scan21 out for chain21 2  

//------------------------------------------------------------------------------
// if the ROM21 subsystem21 is NOT21 black21 boxed21 
//------------------------------------------------------------------------------
`ifndef FV_KIT_BLACK_BOX_APB_SUBSYSTEM21
   
   wire        hsel21; 
   wire        pclk21;
   wire        n_preset21;
   wire [31:0] prdata_spi21;
   wire [31:0] prdata_uart021;
   wire [31:0] prdata_gpio21;
   wire [31:0] prdata_ttc21;
   wire [31:0] prdata_smc21;
   wire [31:0] prdata_pmc21;
   wire [31:0] prdata_uart121;
   wire        pready_spi21;
   wire        pready_uart021;
   wire        pready_uart121;
   wire        tie_hi_bit21;
   wire  [31:0] hrdata21; 
   wire         hready21;
   wire         hready_in21;
   wire  [1:0]  hresp21;   
   wire  [31:0] pwdata21;  
   wire         pwrite21;
   wire  [31:0] paddr21;  
   wire   psel_spi21;
   wire   psel_uart021;
   wire   psel_gpio21;
   wire   psel_ttc21;
   wire   psel_smc21;
   wire   psel0721;
   wire   psel0821;
   wire   psel0921;
   wire   psel1021;
   wire   psel1121;
   wire   psel1221;
   wire   psel_pmc21;
   wire   psel_uart121;
   wire   penable21;
   wire   [NO_OF_IRQS21:0] int_source21;     // System21 Interrupt21 Sources21
   wire [1:0]             smc_hresp21;     // AHB21 Response21 signal21
   wire                   smc_valid21;     // Ack21 valid address

  //External21 memory interface (EMI21)
  wire [31:0]            smc_addr_int21;  // External21 Memory (EMI21) address
  wire [3:0]             smc_n_be21;      // EMI21 byte enables21 (Active21 LOW21)
  wire                   smc_n_cs21;      // EMI21 Chip21 Selects21 (Active21 LOW21)
  wire [3:0]             smc_n_we21;      // EMI21 write strobes21 (Active21 LOW21)
  wire                   smc_n_wr21;      // EMI21 write enable (Active21 LOW21)
  wire                   smc_n_rd21;      // EMI21 read stobe21 (Active21 LOW21)
 
  //AHB21 Memory Interface21 Control21
  wire                   smc_hsel_int21;
  wire                   smc_busy21;      // smc21 busy
   

//scan21 signals21

   wire                scan_in_121;        //scan21 input
   wire                scan_in_221;        //scan21 input
   wire                scan_en21;         //scan21 enable
   wire                scan_out_121;       //scan21 output
   wire                scan_out_221;       //scan21 output
   wire                byte_sel21;     // byte select21 from bridge21 1=byte, 0=2byte
   wire                UART_int21;     // UART21 module interrupt21 
   wire                ua_uclken21;    // Soft21 control21 of clock21
   wire                UART_int121;     // UART21 module interrupt21 
   wire                ua_uclken121;    // Soft21 control21 of clock21
   wire  [3:1]         TTC_int21;            //Interrupt21 from PCI21 
  // inputs21 to SPI21 
   wire    ext_clk21;                // external21 clock21
   wire    SPI_int21;             // interrupt21 request
  // outputs21 from SPI21
   wire    slave_out_clk21;         // modified slave21 clock21 output
 // gpio21 generic21 inputs21 
   wire  [GPIO_WIDTH21-1:0]   n_gpio_bypass_oe21;        // bypass21 mode enable 
   wire  [GPIO_WIDTH21-1:0]   gpio_bypass_out21;         // bypass21 mode output value 
   wire  [GPIO_WIDTH21-1:0]   tri_state_enable21;   // disables21 op enable -> z 
 // outputs21 
   //amba21 outputs21 
   // gpio21 generic21 outputs21 
   wire       GPIO_int21;                // gpio_interupt21 for input pin21 change 
   wire [GPIO_WIDTH21-1:0]     gpio_bypass_in21;          // bypass21 mode input data value  
                
   wire           cpu_debug21;        // Inhibits21 watchdog21 counter 
   wire            ex_wdz_n21;         // External21 Watchdog21 zero indication21
   wire           rstn_non_srpg_smc21; 
   wire           rstn_non_srpg_urt21;
   wire           isolate_smc21;
   wire           save_edge_smc21;
   wire           restore_edge_smc21;
   wire           save_edge_urt21;
   wire           restore_edge_urt21;
   wire           pwr1_on_smc21;
   wire           pwr2_on_smc21;
   wire           pwr1_on_urt21;
   wire           pwr2_on_urt21;
   // ETH021
   wire            rstn_non_srpg_macb021;
   wire            gate_clk_macb021;
   wire            isolate_macb021;
   wire            save_edge_macb021;
   wire            restore_edge_macb021;
   wire            pwr1_on_macb021;
   wire            pwr2_on_macb021;
   // ETH121
   wire            rstn_non_srpg_macb121;
   wire            gate_clk_macb121;
   wire            isolate_macb121;
   wire            save_edge_macb121;
   wire            restore_edge_macb121;
   wire            pwr1_on_macb121;
   wire            pwr2_on_macb121;
   // ETH221
   wire            rstn_non_srpg_macb221;
   wire            gate_clk_macb221;
   wire            isolate_macb221;
   wire            save_edge_macb221;
   wire            restore_edge_macb221;
   wire            pwr1_on_macb221;
   wire            pwr2_on_macb221;
   // ETH321
   wire            rstn_non_srpg_macb321;
   wire            gate_clk_macb321;
   wire            isolate_macb321;
   wire            save_edge_macb321;
   wire            restore_edge_macb321;
   wire            pwr1_on_macb321;
   wire            pwr2_on_macb321;


   wire           pclk_SRPG_smc21;
   wire           pclk_SRPG_urt21;
   wire           gate_clk_smc21;
   wire           gate_clk_urt21;
   wire  [31:0]   tie_lo_32bit21; 
   wire  [1:0]	  tie_lo_2bit21;
   wire  	  tie_lo_1bit21;
   wire           pcm_macb_wakeup_int21;
   wire           int_source_h21;
   wire           isolate_mem21;

assign pcm_irq21 = pcm_macb_wakeup_int21;
assign ttc_irq21[2] = TTC_int21[3];
assign ttc_irq21[1] = TTC_int21[2];
assign ttc_irq21[0] = TTC_int21[1];
assign gpio_irq21 = GPIO_int21;
assign uart0_irq21 = UART_int21;
assign uart1_irq21 = UART_int121;
assign spi_irq21 = SPI_int21;

assign n_mo_en21   = 1'b0;
assign n_so_en21   = 1'b1;
assign n_sclk_en21 = 1'b0;
assign n_ss_en21   = 1'b0;

assign smc_hsel_int21 = smc_hsel21;
  assign ext_clk21  = 1'b0;
  assign int_source21 = {macb0_int21,macb1_int21, macb2_int21, macb3_int21,1'b0, pcm_macb_wakeup_int21, 1'b0, 1'b0, 1'b0, 1'b0, TTC_int21, GPIO_int21, UART_int21, UART_int121, SPI_int21, DMA_irq21};

  // interrupt21 even21 detect21 .
  // for sleep21 wake21 up -> any interrupt21 even21 and system not in hibernation21 (isolate_mem21 = 0)
  // for hibernate21 wake21 up -> gpio21 interrupt21 even21 and system in the hibernation21 (isolate_mem21 = 1)
  assign int_source_h21 =  ((|int_source21) && (!isolate_mem21)) || (isolate_mem21 && GPIO_int21) ;

  assign byte_sel21 = 1'b1;
  assign tie_hi_bit21 = 1'b1;

  assign smc_addr21 = smc_addr_int21[15:0];



  assign  n_gpio_bypass_oe21 = {GPIO_WIDTH21{1'b0}};        // bypass21 mode enable 
  assign  gpio_bypass_out21  = {GPIO_WIDTH21{1'b0}};
  assign  tri_state_enable21 = {GPIO_WIDTH21{1'b0}};
  assign  cpu_debug21 = 1'b0;
  assign  tie_lo_32bit21 = 32'b0;
  assign  tie_lo_2bit21  = 2'b0;
  assign  tie_lo_1bit21  = 1'b0;


ahb2apb21 #(
  32'h00800000, // Slave21 0 Address Range21
  32'h0080FFFF,

  32'h00810000, // Slave21 1 Address Range21
  32'h0081FFFF,

  32'h00820000, // Slave21 2 Address Range21 
  32'h0082FFFF,

  32'h00830000, // Slave21 3 Address Range21
  32'h0083FFFF,

  32'h00840000, // Slave21 4 Address Range21
  32'h0084FFFF,

  32'h00850000, // Slave21 5 Address Range21
  32'h0085FFFF,

  32'h00860000, // Slave21 6 Address Range21
  32'h0086FFFF,

  32'h00870000, // Slave21 7 Address Range21
  32'h0087FFFF,

  32'h00880000, // Slave21 8 Address Range21
  32'h0088FFFF
) i_ahb2apb21 (
     // AHB21 interface
    .hclk21(hclk21),         
    .hreset_n21(n_hreset21), 
    .hsel21(hsel21), 
    .haddr21(haddr21),        
    .htrans21(htrans21),       
    .hwrite21(hwrite21),       
    .hwdata21(hwdata21),       
    .hrdata21(hrdata21),   
    .hready21(hready21),   
    .hresp21(hresp21),     
    
     // APB21 interface
    .pclk21(pclk21),         
    .preset_n21(n_preset21),  
    .prdata021(prdata_spi21),
    .prdata121(prdata_uart021), 
    .prdata221(prdata_gpio21),  
    .prdata321(prdata_ttc21),   
    .prdata421(32'h0),   
    .prdata521(prdata_smc21),   
    .prdata621(prdata_pmc21),    
    .prdata721(32'h0),   
    .prdata821(prdata_uart121),  
    .pready021(pready_spi21),     
    .pready121(pready_uart021),   
    .pready221(tie_hi_bit21),     
    .pready321(tie_hi_bit21),     
    .pready421(tie_hi_bit21),     
    .pready521(tie_hi_bit21),     
    .pready621(tie_hi_bit21),     
    .pready721(tie_hi_bit21),     
    .pready821(pready_uart121),  
    .pwdata21(pwdata21),       
    .pwrite21(pwrite21),       
    .paddr21(paddr21),        
    .psel021(psel_spi21),     
    .psel121(psel_uart021),   
    .psel221(psel_gpio21),    
    .psel321(psel_ttc21),     
    .psel421(),     
    .psel521(psel_smc21),     
    .psel621(psel_pmc21),    
    .psel721(psel_apic21),   
    .psel821(psel_uart121),  
    .penable21(penable21)     
);

spi_top21 i_spi21
(
  // Wishbone21 signals21
  .wb_clk_i21(pclk21), 
  .wb_rst_i21(~n_preset21), 
  .wb_adr_i21(paddr21[4:0]), 
  .wb_dat_i21(pwdata21), 
  .wb_dat_o21(prdata_spi21), 
  .wb_sel_i21(4'b1111),    // SPI21 register accesses are always 32-bit
  .wb_we_i21(pwrite21), 
  .wb_stb_i21(psel_spi21), 
  .wb_cyc_i21(psel_spi21), 
  .wb_ack_o21(pready_spi21), 
  .wb_err_o21(), 
  .wb_int_o21(SPI_int21),

  // SPI21 signals21
  .ss_pad_o21(n_ss_out21), 
  .sclk_pad_o21(sclk_out21), 
  .mosi_pad_o21(mo21), 
  .miso_pad_i21(mi21)
);

// Opencores21 UART21 instances21
wire ua_nrts_int21;
wire ua_nrts1_int21;

assign ua_nrts21 = ua_nrts_int21;
assign ua_nrts121 = ua_nrts1_int21;

reg [3:0] uart0_sel_i21;
reg [3:0] uart1_sel_i21;
// UART21 registers are all 8-bit wide21, and their21 addresses21
// are on byte boundaries21. So21 to access them21 on the
// Wishbone21 bus, the CPU21 must do byte accesses to these21
// byte addresses21. Word21 address accesses are not possible21
// because the word21 addresses21 will be unaligned21, and cause
// a fault21.
// So21, Uart21 accesses from the CPU21 will always be 8-bit size
// We21 only have to decide21 which byte of the 4-byte word21 the
// CPU21 is interested21 in.
`ifdef SYSTEM_BIG_ENDIAN21
always @(paddr21) begin
  case (paddr21[1:0])
    2'b00 : uart0_sel_i21 = 4'b1000;
    2'b01 : uart0_sel_i21 = 4'b0100;
    2'b10 : uart0_sel_i21 = 4'b0010;
    2'b11 : uart0_sel_i21 = 4'b0001;
  endcase
end
always @(paddr21) begin
  case (paddr21[1:0])
    2'b00 : uart1_sel_i21 = 4'b1000;
    2'b01 : uart1_sel_i21 = 4'b0100;
    2'b10 : uart1_sel_i21 = 4'b0010;
    2'b11 : uart1_sel_i21 = 4'b0001;
  endcase
end
`else
always @(paddr21) begin
  case (paddr21[1:0])
    2'b00 : uart0_sel_i21 = 4'b0001;
    2'b01 : uart0_sel_i21 = 4'b0010;
    2'b10 : uart0_sel_i21 = 4'b0100;
    2'b11 : uart0_sel_i21 = 4'b1000;
  endcase
end
always @(paddr21) begin
  case (paddr21[1:0])
    2'b00 : uart1_sel_i21 = 4'b0001;
    2'b01 : uart1_sel_i21 = 4'b0010;
    2'b10 : uart1_sel_i21 = 4'b0100;
    2'b11 : uart1_sel_i21 = 4'b1000;
  endcase
end
`endif

uart_top21 i_oc_uart021 (
  .wb_clk_i21(pclk21),
  .wb_rst_i21(~n_preset21),
  .wb_adr_i21(paddr21[4:0]),
  .wb_dat_i21(pwdata21),
  .wb_dat_o21(prdata_uart021),
  .wb_we_i21(pwrite21),
  .wb_stb_i21(psel_uart021),
  .wb_cyc_i21(psel_uart021),
  .wb_ack_o21(pready_uart021),
  .wb_sel_i21(uart0_sel_i21),
  .int_o21(UART_int21),
  .stx_pad_o21(ua_txd21),
  .srx_pad_i21(ua_rxd21),
  .rts_pad_o21(ua_nrts_int21),
  .cts_pad_i21(ua_ncts21),
  .dtr_pad_o21(),
  .dsr_pad_i21(1'b0),
  .ri_pad_i21(1'b0),
  .dcd_pad_i21(1'b0)
);

uart_top21 i_oc_uart121 (
  .wb_clk_i21(pclk21),
  .wb_rst_i21(~n_preset21),
  .wb_adr_i21(paddr21[4:0]),
  .wb_dat_i21(pwdata21),
  .wb_dat_o21(prdata_uart121),
  .wb_we_i21(pwrite21),
  .wb_stb_i21(psel_uart121),
  .wb_cyc_i21(psel_uart121),
  .wb_ack_o21(pready_uart121),
  .wb_sel_i21(uart1_sel_i21),
  .int_o21(UART_int121),
  .stx_pad_o21(ua_txd121),
  .srx_pad_i21(ua_rxd121),
  .rts_pad_o21(ua_nrts1_int21),
  .cts_pad_i21(ua_ncts121),
  .dtr_pad_o21(),
  .dsr_pad_i21(1'b0),
  .ri_pad_i21(1'b0),
  .dcd_pad_i21(1'b0)
);

gpio_veneer21 i_gpio_veneer21 (
        //inputs21

        . n_p_reset21(n_preset21),
        . pclk21(pclk21),
        . psel21(psel_gpio21),
        . penable21(penable21),
        . pwrite21(pwrite21),
        . paddr21(paddr21[5:0]),
        . pwdata21(pwdata21),
        . gpio_pin_in21(gpio_pin_in21),
        . scan_en21(scan_en21),
        . tri_state_enable21(tri_state_enable21),
        . scan_in21(), //added by smarkov21 for dft21

        //outputs21
        . scan_out21(), //added by smarkov21 for dft21
        . prdata21(prdata_gpio21),
        . gpio_int21(GPIO_int21),
        . n_gpio_pin_oe21(n_gpio_pin_oe21),
        . gpio_pin_out21(gpio_pin_out21)
);


ttc_veneer21 i_ttc_veneer21 (

         //inputs21
        . n_p_reset21(n_preset21),
        . pclk21(pclk21),
        . psel21(psel_ttc21),
        . penable21(penable21),
        . pwrite21(pwrite21),
        . pwdata21(pwdata21),
        . paddr21(paddr21[7:0]),
        . scan_in21(),
        . scan_en21(scan_en21),

        //outputs21
        . prdata21(prdata_ttc21),
        . interrupt21(TTC_int21[3:1]),
        . scan_out21()
);


smc_veneer21 i_smc_veneer21 (
        //inputs21
	//apb21 inputs21
        . n_preset21(n_preset21),
        . pclk21(pclk_SRPG_smc21),
        . psel21(psel_smc21),
        . penable21(penable21),
        . pwrite21(pwrite21),
        . paddr21(paddr21[4:0]),
        . pwdata21(pwdata21),
        //ahb21 inputs21
	. hclk21(smc_hclk21),
        . n_sys_reset21(rstn_non_srpg_smc21),
        . haddr21(smc_haddr21),
        . htrans21(smc_htrans21),
        . hsel21(smc_hsel_int21),
        . hwrite21(smc_hwrite21),
	. hsize21(smc_hsize21),
        . hwdata21(smc_hwdata21),
        . hready21(smc_hready_in21),
        . data_smc21(data_smc21),

         //test signal21 inputs21

        . scan_in_121(),
        . scan_in_221(),
        . scan_in_321(),
        . scan_en21(scan_en21),

        //apb21 outputs21
        . prdata21(prdata_smc21),

       //design output

        . smc_hrdata21(smc_hrdata21),
        . smc_hready21(smc_hready21),
        . smc_hresp21(smc_hresp21),
        . smc_valid21(smc_valid21),
        . smc_addr21(smc_addr_int21),
        . smc_data21(smc_data21),
        . smc_n_be21(smc_n_be21),
        . smc_n_cs21(smc_n_cs21),
        . smc_n_wr21(smc_n_wr21),
        . smc_n_we21(smc_n_we21),
        . smc_n_rd21(smc_n_rd21),
        . smc_n_ext_oe21(smc_n_ext_oe21),
        . smc_busy21(smc_busy21),

         //test signal21 output
        . scan_out_121(),
        . scan_out_221(),
        . scan_out_321()
);

power_ctrl_veneer21 i_power_ctrl_veneer21 (
    // -- Clocks21 & Reset21
    	.pclk21(pclk21), 			//  : in  std_logic21;
    	.nprst21(n_preset21), 		//  : in  std_logic21;
    // -- APB21 programming21 interface
    	.paddr21(paddr21), 			//  : in  std_logic_vector21(31 downto21 0);
    	.psel21(psel_pmc21), 			//  : in  std_logic21;
    	.penable21(penable21), 		//  : in  std_logic21;
    	.pwrite21(pwrite21), 		//  : in  std_logic21;
    	.pwdata21(pwdata21), 		//  : in  std_logic_vector21(31 downto21 0);
    	.prdata21(prdata_pmc21), 		//  : out std_logic_vector21(31 downto21 0);
        .macb3_wakeup21(macb3_wakeup21),
        .macb2_wakeup21(macb2_wakeup21),
        .macb1_wakeup21(macb1_wakeup21),
        .macb0_wakeup21(macb0_wakeup21),
    // -- Module21 control21 outputs21
    	.scan_in21(),			//  : in  std_logic21;
    	.scan_en21(scan_en21),             	//  : in  std_logic21;
    	.scan_mode21(scan_mode21),          //  : in  std_logic21;
    	.scan_out21(),            	//  : out std_logic21;
        .int_source_h21(int_source_h21),
     	.rstn_non_srpg_smc21(rstn_non_srpg_smc21), 		//   : out std_logic21;
    	.gate_clk_smc21(gate_clk_smc21), 	//  : out std_logic21;
    	.isolate_smc21(isolate_smc21), 	//  : out std_logic21;
    	.save_edge_smc21(save_edge_smc21), 	//  : out std_logic21;
    	.restore_edge_smc21(restore_edge_smc21), 	//  : out std_logic21;
    	.pwr1_on_smc21(pwr1_on_smc21), 	//  : out std_logic21;
    	.pwr2_on_smc21(pwr2_on_smc21), 	//  : out std_logic21
     	.rstn_non_srpg_urt21(rstn_non_srpg_urt21), 		//   : out std_logic21;
    	.gate_clk_urt21(gate_clk_urt21), 	//  : out std_logic21;
    	.isolate_urt21(isolate_urt21), 	//  : out std_logic21;
    	.save_edge_urt21(save_edge_urt21), 	//  : out std_logic21;
    	.restore_edge_urt21(restore_edge_urt21), 	//  : out std_logic21;
    	.pwr1_on_urt21(pwr1_on_urt21), 	//  : out std_logic21;
    	.pwr2_on_urt21(pwr2_on_urt21),  	//  : out std_logic21
        // ETH021
        .rstn_non_srpg_macb021(rstn_non_srpg_macb021),
        .gate_clk_macb021(gate_clk_macb021),
        .isolate_macb021(isolate_macb021),
        .save_edge_macb021(save_edge_macb021),
        .restore_edge_macb021(restore_edge_macb021),
        .pwr1_on_macb021(pwr1_on_macb021),
        .pwr2_on_macb021(pwr2_on_macb021),
        // ETH121
        .rstn_non_srpg_macb121(rstn_non_srpg_macb121),
        .gate_clk_macb121(gate_clk_macb121),
        .isolate_macb121(isolate_macb121),
        .save_edge_macb121(save_edge_macb121),
        .restore_edge_macb121(restore_edge_macb121),
        .pwr1_on_macb121(pwr1_on_macb121),
        .pwr2_on_macb121(pwr2_on_macb121),
        // ETH221
        .rstn_non_srpg_macb221(rstn_non_srpg_macb221),
        .gate_clk_macb221(gate_clk_macb221),
        .isolate_macb221(isolate_macb221),
        .save_edge_macb221(save_edge_macb221),
        .restore_edge_macb221(restore_edge_macb221),
        .pwr1_on_macb221(pwr1_on_macb221),
        .pwr2_on_macb221(pwr2_on_macb221),
        // ETH321
        .rstn_non_srpg_macb321(rstn_non_srpg_macb321),
        .gate_clk_macb321(gate_clk_macb321),
        .isolate_macb321(isolate_macb321),
        .save_edge_macb321(save_edge_macb321),
        .restore_edge_macb321(restore_edge_macb321),
        .pwr1_on_macb321(pwr1_on_macb321),
        .pwr2_on_macb321(pwr2_on_macb321),
        .core06v21(core06v21),
        .core08v21(core08v21),
        .core10v21(core10v21),
        .core12v21(core12v21),
        .pcm_macb_wakeup_int21(pcm_macb_wakeup_int21),
        .isolate_mem21(isolate_mem21),
        .mte_smc_start21(mte_smc_start21),
        .mte_uart_start21(mte_uart_start21),
        .mte_smc_uart_start21(mte_smc_uart_start21),  
        .mte_pm_smc_to_default_start21(mte_pm_smc_to_default_start21), 
        .mte_pm_uart_to_default_start21(mte_pm_uart_to_default_start21),
        .mte_pm_smc_uart_to_default_start21(mte_pm_smc_uart_to_default_start21)
);

// Clock21 gating21 macro21 to shut21 off21 clocks21 to the SRPG21 flops21 in the SMC21
//CKLNQD121 i_SMC_SRPG_clk_gate21  (
//	.TE21(scan_mode21), 
//	.E21(~gate_clk_smc21), 
//	.CP21(pclk21), 
//	.Q21(pclk_SRPG_smc21)
//	);
// Replace21 gate21 with behavioural21 code21 //
wire 	smc_scan_gate21;
reg 	smc_latched_enable21;
assign smc_scan_gate21 = scan_mode21 ? 1'b1 : ~gate_clk_smc21;

always @ (pclk21 or smc_scan_gate21)
  	if (pclk21 == 1'b0) begin
  		smc_latched_enable21 <= smc_scan_gate21;
  	end  	
	
assign pclk_SRPG_smc21 = smc_latched_enable21 ? pclk21 : 1'b0;


// Clock21 gating21 macro21 to shut21 off21 clocks21 to the SRPG21 flops21 in the URT21
//CKLNQD121 i_URT_SRPG_clk_gate21  (
//	.TE21(scan_mode21), 
//	.E21(~gate_clk_urt21), 
//	.CP21(pclk21), 
//	.Q21(pclk_SRPG_urt21)
//	);
// Replace21 gate21 with behavioural21 code21 //
wire 	urt_scan_gate21;
reg 	urt_latched_enable21;
assign urt_scan_gate21 = scan_mode21 ? 1'b1 : ~gate_clk_urt21;

always @ (pclk21 or urt_scan_gate21)
  	if (pclk21 == 1'b0) begin
  		urt_latched_enable21 <= urt_scan_gate21;
  	end  	
	
assign pclk_SRPG_urt21 = urt_latched_enable21 ? pclk21 : 1'b0;

// ETH021
wire 	macb0_scan_gate21;
reg 	macb0_latched_enable21;
assign macb0_scan_gate21 = scan_mode21 ? 1'b1 : ~gate_clk_macb021;

always @ (pclk21 or macb0_scan_gate21)
  	if (pclk21 == 1'b0) begin
  		macb0_latched_enable21 <= macb0_scan_gate21;
  	end  	
	
assign clk_SRPG_macb0_en21 = macb0_latched_enable21 ? 1'b1 : 1'b0;

// ETH121
wire 	macb1_scan_gate21;
reg 	macb1_latched_enable21;
assign macb1_scan_gate21 = scan_mode21 ? 1'b1 : ~gate_clk_macb121;

always @ (pclk21 or macb1_scan_gate21)
  	if (pclk21 == 1'b0) begin
  		macb1_latched_enable21 <= macb1_scan_gate21;
  	end  	
	
assign clk_SRPG_macb1_en21 = macb1_latched_enable21 ? 1'b1 : 1'b0;

// ETH221
wire 	macb2_scan_gate21;
reg 	macb2_latched_enable21;
assign macb2_scan_gate21 = scan_mode21 ? 1'b1 : ~gate_clk_macb221;

always @ (pclk21 or macb2_scan_gate21)
  	if (pclk21 == 1'b0) begin
  		macb2_latched_enable21 <= macb2_scan_gate21;
  	end  	
	
assign clk_SRPG_macb2_en21 = macb2_latched_enable21 ? 1'b1 : 1'b0;

// ETH321
wire 	macb3_scan_gate21;
reg 	macb3_latched_enable21;
assign macb3_scan_gate21 = scan_mode21 ? 1'b1 : ~gate_clk_macb321;

always @ (pclk21 or macb3_scan_gate21)
  	if (pclk21 == 1'b0) begin
  		macb3_latched_enable21 <= macb3_scan_gate21;
  	end  	
	
assign clk_SRPG_macb3_en21 = macb3_latched_enable21 ? 1'b1 : 1'b0;



`else
//------------------------------------------------------------------------------
// if the APB21 subsystem21 is black21 boxed21 
//------------------------------------------------------------------------------
// wire s ports21
    // system signals21
    wire         hclk21;     // AHB21 Clock21
    wire         n_hreset21;  // AHB21 reset - Active21 low21
    wire         pclk21;     // APB21 Clock21. 
    wire         n_preset21;  // APB21 reset - Active21 low21

    // AHB21 interface
    wire         ahb2apb0_hsel21;     // AHB2APB21 select21
    wire  [31:0] haddr21;    // Address bus
    wire  [1:0]  htrans21;   // Transfer21 type
    wire  [2:0]  hsize21;    // AHB21 Access type - byte, half21-word21, word21
    wire  [31:0] hwdata21;   // Write data
    wire         hwrite21;   // Write signal21/
    wire         hready_in21;// Indicates21 that last master21 has finished21 bus access
    wire [2:0]   hburst21;     // Burst type
    wire [3:0]   hprot21;      // Protection21 control21
    wire [3:0]   hmaster21;    // Master21 select21
    wire         hmastlock21;  // Locked21 transfer21
  // Interrupts21 from the Enet21 MACs21
    wire         macb0_int21;
    wire         macb1_int21;
    wire         macb2_int21;
    wire         macb3_int21;
  // Interrupt21 from the DMA21
    wire         DMA_irq21;
  // Scan21 wire s
    wire         scan_en21;    // Scan21 enable pin21
    wire         scan_in_121;  // Scan21 wire  for first chain21
    wire         scan_in_221;  // Scan21 wire  for second chain21
    wire         scan_mode21;  // test mode pin21
 
  //wire  for smc21 AHB21 interface
    wire         smc_hclk21;
    wire         smc_n_hclk21;
    wire  [31:0] smc_haddr21;
    wire  [1:0]  smc_htrans21;
    wire         smc_hsel21;
    wire         smc_hwrite21;
    wire  [2:0]  smc_hsize21;
    wire  [31:0] smc_hwdata21;
    wire         smc_hready_in21;
    wire  [2:0]  smc_hburst21;     // Burst type
    wire  [3:0]  smc_hprot21;      // Protection21 control21
    wire  [3:0]  smc_hmaster21;    // Master21 select21
    wire         smc_hmastlock21;  // Locked21 transfer21


    wire  [31:0] data_smc21;     // EMI21(External21 memory) read data
    
  //wire s for uart21
    wire         ua_rxd21;       // UART21 receiver21 serial21 wire  pin21
    wire         ua_rxd121;      // UART21 receiver21 serial21 wire  pin21
    wire         ua_ncts21;      // Clear-To21-Send21 flow21 control21
    wire         ua_ncts121;      // Clear-To21-Send21 flow21 control21
   //wire s for spi21
    wire         n_ss_in21;      // select21 wire  to slave21
    wire         mi21;           // data wire  to master21
    wire         si21;           // data wire  to slave21
    wire         sclk_in21;      // clock21 wire  to slave21
  //wire s for GPIO21
   wire  [GPIO_WIDTH21-1:0]  gpio_pin_in21;             // wire  data from pin21

  //reg    ports21
  // Scan21 reg   s
   reg           scan_out_121;   // Scan21 out for chain21 1
   reg           scan_out_221;   // Scan21 out for chain21 2
  //AHB21 interface 
   reg    [31:0] hrdata21;       // Read data provided from target slave21
   reg           hready21;       // Ready21 for new bus cycle from target slave21
   reg    [1:0]  hresp21;       // Response21 from the bridge21

   // SMC21 reg    for AHB21 interface
   reg    [31:0]    smc_hrdata21;
   reg              smc_hready21;
   reg    [1:0]     smc_hresp21;

  //reg   s from smc21
   reg    [15:0]    smc_addr21;      // External21 Memory (EMI21) address
   reg    [3:0]     smc_n_be21;      // EMI21 byte enables21 (Active21 LOW21)
   reg    [7:0]     smc_n_cs21;      // EMI21 Chip21 Selects21 (Active21 LOW21)
   reg    [3:0]     smc_n_we21;      // EMI21 write strobes21 (Active21 LOW21)
   reg              smc_n_wr21;      // EMI21 write enable (Active21 LOW21)
   reg              smc_n_rd21;      // EMI21 read stobe21 (Active21 LOW21)
   reg              smc_n_ext_oe21;  // EMI21 write data reg    enable
   reg    [31:0]    smc_data21;      // EMI21 write data
  //reg   s from uart21
   reg           ua_txd21;       	// UART21 transmitter21 serial21 reg   
   reg           ua_txd121;       // UART21 transmitter21 serial21 reg   
   reg           ua_nrts21;      	// Request21-To21-Send21 flow21 control21
   reg           ua_nrts121;      // Request21-To21-Send21 flow21 control21
   // reg   s from ttc21
  // reg   s from SPI21
   reg       so;                    // data reg    from slave21
   reg       mo21;                    // data reg    from master21
   reg       sclk_out21;              // clock21 reg    from master21
   reg    [P_SIZE21-1:0] n_ss_out21;    // peripheral21 select21 lines21 from master21
   reg       n_so_en21;               // out enable for slave21 data
   reg       n_mo_en21;               // out enable for master21 data
   reg       n_sclk_en21;             // out enable for master21 clock21
   reg       n_ss_en21;               // out enable for master21 peripheral21 lines21
  //reg   s from gpio21
   reg    [GPIO_WIDTH21-1:0]     n_gpio_pin_oe21;           // reg    enable signal21 to pin21
   reg    [GPIO_WIDTH21-1:0]     gpio_pin_out21;            // reg    signal21 to pin21


`endif
//------------------------------------------------------------------------------
// black21 boxed21 defines21 
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// APB21 and AHB21 interface formal21 verification21 monitors21
//------------------------------------------------------------------------------
`ifdef ABV_ON21
apb_assert21 i_apb_assert21 (

        // APB21 signals21
  	.n_preset21(n_preset21),
   	.pclk21(pclk21),
	.penable21(penable21),
	.paddr21(paddr21),
	.pwrite21(pwrite21),
	.pwdata21(pwdata21),

	.psel0021(psel_spi21),
	.psel0121(psel_uart021),
	.psel0221(psel_gpio21),
	.psel0321(psel_ttc21),
	.psel0421(1'b0),
	.psel0521(psel_smc21),
	.psel0621(1'b0),
	.psel0721(1'b0),
	.psel0821(1'b0),
	.psel0921(1'b0),
	.psel1021(1'b0),
	.psel1121(1'b0),
	.psel1221(1'b0),
	.psel1321(psel_pmc21),
	.psel1421(psel_apic21),
	.psel1521(psel_uart121),

        .prdata0021(prdata_spi21),
        .prdata0121(prdata_uart021), // Read Data from peripheral21 UART21 
        .prdata0221(prdata_gpio21), // Read Data from peripheral21 GPIO21
        .prdata0321(prdata_ttc21), // Read Data from peripheral21 TTC21
        .prdata0421(32'b0), // 
        .prdata0521(prdata_smc21), // Read Data from peripheral21 SMC21
        .prdata1321(prdata_pmc21), // Read Data from peripheral21 Power21 Control21 Block
   	.prdata1421(32'b0), // 
        .prdata1521(prdata_uart121),


        // AHB21 signals21
        .hclk21(hclk21),         // ahb21 system clock21
        .n_hreset21(n_hreset21), // ahb21 system reset

        // ahb2apb21 signals21
        .hresp21(hresp21),
        .hready21(hready21),
        .hrdata21(hrdata21),
        .hwdata21(hwdata21),
        .hprot21(hprot21),
        .hburst21(hburst21),
        .hsize21(hsize21),
        .hwrite21(hwrite21),
        .htrans21(htrans21),
        .haddr21(haddr21),
        .ahb2apb_hsel21(ahb2apb0_hsel21));



//------------------------------------------------------------------------------
// AHB21 interface formal21 verification21 monitor21
//------------------------------------------------------------------------------
defparam i_ahbSlaveMonitor21.DBUS_WIDTH21 = 32;
defparam i_ahbMasterMonitor21.DBUS_WIDTH21 = 32;


// AHB2APB21 Bridge21

    ahb_liteslave_monitor21 i_ahbSlaveMonitor21 (
        .hclk_i21(hclk21),
        .hresetn_i21(n_hreset21),
        .hresp21(hresp21),
        .hready21(hready21),
        .hready_global_i21(hready21),
        .hrdata21(hrdata21),
        .hwdata_i21(hwdata21),
        .hburst_i21(hburst21),
        .hsize_i21(hsize21),
        .hwrite_i21(hwrite21),
        .htrans_i21(htrans21),
        .haddr_i21(haddr21),
        .hsel_i21(ahb2apb0_hsel21)
    );


  ahb_litemaster_monitor21 i_ahbMasterMonitor21 (
          .hclk_i21(hclk21),
          .hresetn_i21(n_hreset21),
          .hresp_i21(hresp21),
          .hready_i21(hready21),
          .hrdata_i21(hrdata21),
          .hlock21(1'b0),
          .hwdata21(hwdata21),
          .hprot21(hprot21),
          .hburst21(hburst21),
          .hsize21(hsize21),
          .hwrite21(hwrite21),
          .htrans21(htrans21),
          .haddr21(haddr21)
          );







`endif




`ifdef IFV_LP_ABV_ON21
// power21 control21
wire isolate21;

// testbench mirror signals21
wire L1_ctrl_access21;
wire L1_status_access21;

wire [31:0] L1_status_reg21;
wire [31:0] L1_ctrl_reg21;

//wire rstn_non_srpg_urt21;
//wire isolate_urt21;
//wire retain_urt21;
//wire gate_clk_urt21;
//wire pwr1_on_urt21;


// smc21 signals21
wire [31:0] smc_prdata21;
wire lp_clk_smc21;
                    

// uart21 isolation21 register
  wire [15:0] ua_prdata21;
  wire ua_int21;
  assign ua_prdata21          =  i_uart1_veneer21.prdata21;
  assign ua_int21             =  i_uart1_veneer21.ua_int21;


assign lp_clk_smc21          = i_smc_veneer21.pclk21;
assign smc_prdata21          = i_smc_veneer21.prdata21;
lp_chk_smc21 u_lp_chk_smc21 (
    .clk21 (hclk21),
    .rst21 (n_hreset21),
    .iso_smc21 (isolate_smc21),
    .gate_clk21 (gate_clk_smc21),
    .lp_clk21 (pclk_SRPG_smc21),

    // srpg21 outputs21
    .smc_hrdata21 (smc_hrdata21),
    .smc_hready21 (smc_hready21),
    .smc_hresp21  (smc_hresp21),
    .smc_valid21 (smc_valid21),
    .smc_addr_int21 (smc_addr_int21),
    .smc_data21 (smc_data21),
    .smc_n_be21 (smc_n_be21),
    .smc_n_cs21  (smc_n_cs21),
    .smc_n_wr21 (smc_n_wr21),
    .smc_n_we21 (smc_n_we21),
    .smc_n_rd21 (smc_n_rd21),
    .smc_n_ext_oe21 (smc_n_ext_oe21)
   );

// lp21 retention21/isolation21 assertions21
lp_chk_uart21 u_lp_chk_urt21 (

  .clk21         (hclk21),
  .rst21         (n_hreset21),
  .iso_urt21     (isolate_urt21),
  .gate_clk21    (gate_clk_urt21),
  .lp_clk21      (pclk_SRPG_urt21),
  //ports21
  .prdata21 (ua_prdata21),
  .ua_int21 (ua_int21),
  .ua_txd21 (ua_txd121),
  .ua_nrts21 (ua_nrts121)
 );

`endif  //IFV_LP_ABV_ON21




endmodule
