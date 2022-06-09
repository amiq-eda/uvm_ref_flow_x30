//File7 name   : apb_subsystem_07.v
//Title7       : 
//Created7     : 1999
//Description7 : 
//Notes7       : 
//----------------------------------------------------------------------
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------

module apb_subsystem_07(
    // AHB7 interface
    hclk7,
    n_hreset7,
    hsel7,
    haddr7,
    htrans7,
    hsize7,
    hwrite7,
    hwdata7,
    hready_in7,
    hburst7,
    hprot7,
    hmaster7,
    hmastlock7,
    hrdata7,
    hready7,
    hresp7,
    
    // APB7 system interface
    pclk7,
    n_preset7,
    
    // SPI7 ports7
    n_ss_in7,
    mi7,
    si7,
    sclk_in7,
    so,
    mo7,
    sclk_out7,
    n_ss_out7,
    n_so_en7,
    n_mo_en7,
    n_sclk_en7,
    n_ss_en7,
    
    //UART07 ports7
    ua_rxd7,
    ua_ncts7,
    ua_txd7,
    ua_nrts7,
    
    //UART17 ports7
    ua_rxd17,
    ua_ncts17,
    ua_txd17,
    ua_nrts17,
    
    //GPIO7 ports7
    gpio_pin_in7,
    n_gpio_pin_oe7,
    gpio_pin_out7,
    

    //SMC7 ports7
    smc_hclk7,
    smc_n_hclk7,
    smc_haddr7,
    smc_htrans7,
    smc_hsel7,
    smc_hwrite7,
    smc_hsize7,
    smc_hwdata7,
    smc_hready_in7,
    smc_hburst7,
    smc_hprot7,
    smc_hmaster7,
    smc_hmastlock7,
    smc_hrdata7, 
    smc_hready7,
    smc_hresp7,
    smc_n_ext_oe7,
    smc_data7,
    smc_addr7,
    smc_n_be7,
    smc_n_cs7, 
    smc_n_we7,
    smc_n_wr7,
    smc_n_rd7,
    data_smc7,
    
    //PMC7 ports7
    clk_SRPG_macb0_en7,
    clk_SRPG_macb1_en7,
    clk_SRPG_macb2_en7,
    clk_SRPG_macb3_en7,
    core06v7,
    core08v7,
    core10v7,
    core12v7,
    macb3_wakeup7,
    macb2_wakeup7,
    macb1_wakeup7,
    macb0_wakeup7,
    mte_smc_start7,
    mte_uart_start7,
    mte_smc_uart_start7,  
    mte_pm_smc_to_default_start7, 
    mte_pm_uart_to_default_start7,
    mte_pm_smc_uart_to_default_start7,
    
    
    // Peripheral7 inerrupts7
    pcm_irq7,
    ttc_irq7,
    gpio_irq7,
    uart0_irq7,
    uart1_irq7,
    spi_irq7,
    DMA_irq7,      
    macb0_int7,
    macb1_int7,
    macb2_int7,
    macb3_int7,
   
    // Scan7 ports7
    scan_en7,      // Scan7 enable pin7
    scan_in_17,    // Scan7 input for first chain7
    scan_in_27,    // Scan7 input for second chain7
    scan_mode7,
    scan_out_17,   // Scan7 out for chain7 1
    scan_out_27    // Scan7 out for chain7 2
);

parameter GPIO_WIDTH7 = 16;        // GPIO7 width
parameter P_SIZE7 =   8;              // number7 of peripheral7 select7 lines7
parameter NO_OF_IRQS7  = 17;      //No of irqs7 read by apic7 

// AHB7 interface
input         hclk7;     // AHB7 Clock7
input         n_hreset7;  // AHB7 reset - Active7 low7
input         hsel7;     // AHB2APB7 select7
input [31:0]  haddr7;    // Address bus
input [1:0]   htrans7;   // Transfer7 type
input [2:0]   hsize7;    // AHB7 Access type - byte, half7-word7, word7
input [31:0]  hwdata7;   // Write data
input         hwrite7;   // Write signal7/
input         hready_in7;// Indicates7 that last master7 has finished7 bus access
input [2:0]   hburst7;     // Burst type
input [3:0]   hprot7;      // Protection7 control7
input [3:0]   hmaster7;    // Master7 select7
input         hmastlock7;  // Locked7 transfer7
output [31:0] hrdata7;       // Read data provided from target slave7
output        hready7;       // Ready7 for new bus cycle from target slave7
output [1:0]  hresp7;       // Response7 from the bridge7
    
// APB7 system interface
input         pclk7;     // APB7 Clock7. 
input         n_preset7;  // APB7 reset - Active7 low7
   
// SPI7 ports7
input     n_ss_in7;      // select7 input to slave7
input     mi7;           // data input to master7
input     si7;           // data input to slave7
input     sclk_in7;      // clock7 input to slave7
output    so;                    // data output from slave7
output    mo7;                    // data output from master7
output    sclk_out7;              // clock7 output from master7
output [P_SIZE7-1:0] n_ss_out7;    // peripheral7 select7 lines7 from master7
output    n_so_en7;               // out enable for slave7 data
output    n_mo_en7;               // out enable for master7 data
output    n_sclk_en7;             // out enable for master7 clock7
output    n_ss_en7;               // out enable for master7 peripheral7 lines7

//UART07 ports7
input        ua_rxd7;       // UART7 receiver7 serial7 input pin7
input        ua_ncts7;      // Clear-To7-Send7 flow7 control7
output       ua_txd7;       	// UART7 transmitter7 serial7 output
output       ua_nrts7;      	// Request7-To7-Send7 flow7 control7

// UART17 ports7   
input        ua_rxd17;      // UART7 receiver7 serial7 input pin7
input        ua_ncts17;      // Clear-To7-Send7 flow7 control7
output       ua_txd17;       // UART7 transmitter7 serial7 output
output       ua_nrts17;      // Request7-To7-Send7 flow7 control7

//GPIO7 ports7
input [GPIO_WIDTH7-1:0]      gpio_pin_in7;             // input data from pin7
output [GPIO_WIDTH7-1:0]     n_gpio_pin_oe7;           // output enable signal7 to pin7
output [GPIO_WIDTH7-1:0]     gpio_pin_out7;            // output signal7 to pin7
  
//SMC7 ports7
input        smc_hclk7;
input        smc_n_hclk7;
input [31:0] smc_haddr7;
input [1:0]  smc_htrans7;
input        smc_hsel7;
input        smc_hwrite7;
input [2:0]  smc_hsize7;
input [31:0] smc_hwdata7;
input        smc_hready_in7;
input [2:0]  smc_hburst7;     // Burst type
input [3:0]  smc_hprot7;      // Protection7 control7
input [3:0]  smc_hmaster7;    // Master7 select7
input        smc_hmastlock7;  // Locked7 transfer7
input [31:0] data_smc7;     // EMI7(External7 memory) read data
output [31:0]    smc_hrdata7;
output           smc_hready7;
output [1:0]     smc_hresp7;
output [15:0]    smc_addr7;      // External7 Memory (EMI7) address
output [3:0]     smc_n_be7;      // EMI7 byte enables7 (Active7 LOW7)
output           smc_n_cs7;      // EMI7 Chip7 Selects7 (Active7 LOW7)
output [3:0]     smc_n_we7;      // EMI7 write strobes7 (Active7 LOW7)
output           smc_n_wr7;      // EMI7 write enable (Active7 LOW7)
output           smc_n_rd7;      // EMI7 read stobe7 (Active7 LOW7)
output           smc_n_ext_oe7;  // EMI7 write data output enable
output [31:0]    smc_data7;      // EMI7 write data
       
//PMC7 ports7
output clk_SRPG_macb0_en7;
output clk_SRPG_macb1_en7;
output clk_SRPG_macb2_en7;
output clk_SRPG_macb3_en7;
output core06v7;
output core08v7;
output core10v7;
output core12v7;
output mte_smc_start7;
output mte_uart_start7;
output mte_smc_uart_start7;  
output mte_pm_smc_to_default_start7; 
output mte_pm_uart_to_default_start7;
output mte_pm_smc_uart_to_default_start7;
input macb3_wakeup7;
input macb2_wakeup7;
input macb1_wakeup7;
input macb0_wakeup7;
    

// Peripheral7 interrupts7
output pcm_irq7;
output [2:0] ttc_irq7;
output gpio_irq7;
output uart0_irq7;
output uart1_irq7;
output spi_irq7;
input        macb0_int7;
input        macb1_int7;
input        macb2_int7;
input        macb3_int7;
input        DMA_irq7;
  
//Scan7 ports7
input        scan_en7;    // Scan7 enable pin7
input        scan_in_17;  // Scan7 input for first chain7
input        scan_in_27;  // Scan7 input for second chain7
input        scan_mode7;  // test mode pin7
 output        scan_out_17;   // Scan7 out for chain7 1
 output        scan_out_27;   // Scan7 out for chain7 2  

//------------------------------------------------------------------------------
// if the ROM7 subsystem7 is NOT7 black7 boxed7 
//------------------------------------------------------------------------------
`ifndef FV_KIT_BLACK_BOX_APB_SUBSYSTEM7
   
   wire        hsel7; 
   wire        pclk7;
   wire        n_preset7;
   wire [31:0] prdata_spi7;
   wire [31:0] prdata_uart07;
   wire [31:0] prdata_gpio7;
   wire [31:0] prdata_ttc7;
   wire [31:0] prdata_smc7;
   wire [31:0] prdata_pmc7;
   wire [31:0] prdata_uart17;
   wire        pready_spi7;
   wire        pready_uart07;
   wire        pready_uart17;
   wire        tie_hi_bit7;
   wire  [31:0] hrdata7; 
   wire         hready7;
   wire         hready_in7;
   wire  [1:0]  hresp7;   
   wire  [31:0] pwdata7;  
   wire         pwrite7;
   wire  [31:0] paddr7;  
   wire   psel_spi7;
   wire   psel_uart07;
   wire   psel_gpio7;
   wire   psel_ttc7;
   wire   psel_smc7;
   wire   psel077;
   wire   psel087;
   wire   psel097;
   wire   psel107;
   wire   psel117;
   wire   psel127;
   wire   psel_pmc7;
   wire   psel_uart17;
   wire   penable7;
   wire   [NO_OF_IRQS7:0] int_source7;     // System7 Interrupt7 Sources7
   wire [1:0]             smc_hresp7;     // AHB7 Response7 signal7
   wire                   smc_valid7;     // Ack7 valid address

  //External7 memory interface (EMI7)
  wire [31:0]            smc_addr_int7;  // External7 Memory (EMI7) address
  wire [3:0]             smc_n_be7;      // EMI7 byte enables7 (Active7 LOW7)
  wire                   smc_n_cs7;      // EMI7 Chip7 Selects7 (Active7 LOW7)
  wire [3:0]             smc_n_we7;      // EMI7 write strobes7 (Active7 LOW7)
  wire                   smc_n_wr7;      // EMI7 write enable (Active7 LOW7)
  wire                   smc_n_rd7;      // EMI7 read stobe7 (Active7 LOW7)
 
  //AHB7 Memory Interface7 Control7
  wire                   smc_hsel_int7;
  wire                   smc_busy7;      // smc7 busy
   

//scan7 signals7

   wire                scan_in_17;        //scan7 input
   wire                scan_in_27;        //scan7 input
   wire                scan_en7;         //scan7 enable
   wire                scan_out_17;       //scan7 output
   wire                scan_out_27;       //scan7 output
   wire                byte_sel7;     // byte select7 from bridge7 1=byte, 0=2byte
   wire                UART_int7;     // UART7 module interrupt7 
   wire                ua_uclken7;    // Soft7 control7 of clock7
   wire                UART_int17;     // UART7 module interrupt7 
   wire                ua_uclken17;    // Soft7 control7 of clock7
   wire  [3:1]         TTC_int7;            //Interrupt7 from PCI7 
  // inputs7 to SPI7 
   wire    ext_clk7;                // external7 clock7
   wire    SPI_int7;             // interrupt7 request
  // outputs7 from SPI7
   wire    slave_out_clk7;         // modified slave7 clock7 output
 // gpio7 generic7 inputs7 
   wire  [GPIO_WIDTH7-1:0]   n_gpio_bypass_oe7;        // bypass7 mode enable 
   wire  [GPIO_WIDTH7-1:0]   gpio_bypass_out7;         // bypass7 mode output value 
   wire  [GPIO_WIDTH7-1:0]   tri_state_enable7;   // disables7 op enable -> z 
 // outputs7 
   //amba7 outputs7 
   // gpio7 generic7 outputs7 
   wire       GPIO_int7;                // gpio_interupt7 for input pin7 change 
   wire [GPIO_WIDTH7-1:0]     gpio_bypass_in7;          // bypass7 mode input data value  
                
   wire           cpu_debug7;        // Inhibits7 watchdog7 counter 
   wire            ex_wdz_n7;         // External7 Watchdog7 zero indication7
   wire           rstn_non_srpg_smc7; 
   wire           rstn_non_srpg_urt7;
   wire           isolate_smc7;
   wire           save_edge_smc7;
   wire           restore_edge_smc7;
   wire           save_edge_urt7;
   wire           restore_edge_urt7;
   wire           pwr1_on_smc7;
   wire           pwr2_on_smc7;
   wire           pwr1_on_urt7;
   wire           pwr2_on_urt7;
   // ETH07
   wire            rstn_non_srpg_macb07;
   wire            gate_clk_macb07;
   wire            isolate_macb07;
   wire            save_edge_macb07;
   wire            restore_edge_macb07;
   wire            pwr1_on_macb07;
   wire            pwr2_on_macb07;
   // ETH17
   wire            rstn_non_srpg_macb17;
   wire            gate_clk_macb17;
   wire            isolate_macb17;
   wire            save_edge_macb17;
   wire            restore_edge_macb17;
   wire            pwr1_on_macb17;
   wire            pwr2_on_macb17;
   // ETH27
   wire            rstn_non_srpg_macb27;
   wire            gate_clk_macb27;
   wire            isolate_macb27;
   wire            save_edge_macb27;
   wire            restore_edge_macb27;
   wire            pwr1_on_macb27;
   wire            pwr2_on_macb27;
   // ETH37
   wire            rstn_non_srpg_macb37;
   wire            gate_clk_macb37;
   wire            isolate_macb37;
   wire            save_edge_macb37;
   wire            restore_edge_macb37;
   wire            pwr1_on_macb37;
   wire            pwr2_on_macb37;


   wire           pclk_SRPG_smc7;
   wire           pclk_SRPG_urt7;
   wire           gate_clk_smc7;
   wire           gate_clk_urt7;
   wire  [31:0]   tie_lo_32bit7; 
   wire  [1:0]	  tie_lo_2bit7;
   wire  	  tie_lo_1bit7;
   wire           pcm_macb_wakeup_int7;
   wire           int_source_h7;
   wire           isolate_mem7;

assign pcm_irq7 = pcm_macb_wakeup_int7;
assign ttc_irq7[2] = TTC_int7[3];
assign ttc_irq7[1] = TTC_int7[2];
assign ttc_irq7[0] = TTC_int7[1];
assign gpio_irq7 = GPIO_int7;
assign uart0_irq7 = UART_int7;
assign uart1_irq7 = UART_int17;
assign spi_irq7 = SPI_int7;

assign n_mo_en7   = 1'b0;
assign n_so_en7   = 1'b1;
assign n_sclk_en7 = 1'b0;
assign n_ss_en7   = 1'b0;

assign smc_hsel_int7 = smc_hsel7;
  assign ext_clk7  = 1'b0;
  assign int_source7 = {macb0_int7,macb1_int7, macb2_int7, macb3_int7,1'b0, pcm_macb_wakeup_int7, 1'b0, 1'b0, 1'b0, 1'b0, TTC_int7, GPIO_int7, UART_int7, UART_int17, SPI_int7, DMA_irq7};

  // interrupt7 even7 detect7 .
  // for sleep7 wake7 up -> any interrupt7 even7 and system not in hibernation7 (isolate_mem7 = 0)
  // for hibernate7 wake7 up -> gpio7 interrupt7 even7 and system in the hibernation7 (isolate_mem7 = 1)
  assign int_source_h7 =  ((|int_source7) && (!isolate_mem7)) || (isolate_mem7 && GPIO_int7) ;

  assign byte_sel7 = 1'b1;
  assign tie_hi_bit7 = 1'b1;

  assign smc_addr7 = smc_addr_int7[15:0];



  assign  n_gpio_bypass_oe7 = {GPIO_WIDTH7{1'b0}};        // bypass7 mode enable 
  assign  gpio_bypass_out7  = {GPIO_WIDTH7{1'b0}};
  assign  tri_state_enable7 = {GPIO_WIDTH7{1'b0}};
  assign  cpu_debug7 = 1'b0;
  assign  tie_lo_32bit7 = 32'b0;
  assign  tie_lo_2bit7  = 2'b0;
  assign  tie_lo_1bit7  = 1'b0;


ahb2apb7 #(
  32'h00800000, // Slave7 0 Address Range7
  32'h0080FFFF,

  32'h00810000, // Slave7 1 Address Range7
  32'h0081FFFF,

  32'h00820000, // Slave7 2 Address Range7 
  32'h0082FFFF,

  32'h00830000, // Slave7 3 Address Range7
  32'h0083FFFF,

  32'h00840000, // Slave7 4 Address Range7
  32'h0084FFFF,

  32'h00850000, // Slave7 5 Address Range7
  32'h0085FFFF,

  32'h00860000, // Slave7 6 Address Range7
  32'h0086FFFF,

  32'h00870000, // Slave7 7 Address Range7
  32'h0087FFFF,

  32'h00880000, // Slave7 8 Address Range7
  32'h0088FFFF
) i_ahb2apb7 (
     // AHB7 interface
    .hclk7(hclk7),         
    .hreset_n7(n_hreset7), 
    .hsel7(hsel7), 
    .haddr7(haddr7),        
    .htrans7(htrans7),       
    .hwrite7(hwrite7),       
    .hwdata7(hwdata7),       
    .hrdata7(hrdata7),   
    .hready7(hready7),   
    .hresp7(hresp7),     
    
     // APB7 interface
    .pclk7(pclk7),         
    .preset_n7(n_preset7),  
    .prdata07(prdata_spi7),
    .prdata17(prdata_uart07), 
    .prdata27(prdata_gpio7),  
    .prdata37(prdata_ttc7),   
    .prdata47(32'h0),   
    .prdata57(prdata_smc7),   
    .prdata67(prdata_pmc7),    
    .prdata77(32'h0),   
    .prdata87(prdata_uart17),  
    .pready07(pready_spi7),     
    .pready17(pready_uart07),   
    .pready27(tie_hi_bit7),     
    .pready37(tie_hi_bit7),     
    .pready47(tie_hi_bit7),     
    .pready57(tie_hi_bit7),     
    .pready67(tie_hi_bit7),     
    .pready77(tie_hi_bit7),     
    .pready87(pready_uart17),  
    .pwdata7(pwdata7),       
    .pwrite7(pwrite7),       
    .paddr7(paddr7),        
    .psel07(psel_spi7),     
    .psel17(psel_uart07),   
    .psel27(psel_gpio7),    
    .psel37(psel_ttc7),     
    .psel47(),     
    .psel57(psel_smc7),     
    .psel67(psel_pmc7),    
    .psel77(psel_apic7),   
    .psel87(psel_uart17),  
    .penable7(penable7)     
);

spi_top7 i_spi7
(
  // Wishbone7 signals7
  .wb_clk_i7(pclk7), 
  .wb_rst_i7(~n_preset7), 
  .wb_adr_i7(paddr7[4:0]), 
  .wb_dat_i7(pwdata7), 
  .wb_dat_o7(prdata_spi7), 
  .wb_sel_i7(4'b1111),    // SPI7 register accesses are always 32-bit
  .wb_we_i7(pwrite7), 
  .wb_stb_i7(psel_spi7), 
  .wb_cyc_i7(psel_spi7), 
  .wb_ack_o7(pready_spi7), 
  .wb_err_o7(), 
  .wb_int_o7(SPI_int7),

  // SPI7 signals7
  .ss_pad_o7(n_ss_out7), 
  .sclk_pad_o7(sclk_out7), 
  .mosi_pad_o7(mo7), 
  .miso_pad_i7(mi7)
);

// Opencores7 UART7 instances7
wire ua_nrts_int7;
wire ua_nrts1_int7;

assign ua_nrts7 = ua_nrts_int7;
assign ua_nrts17 = ua_nrts1_int7;

reg [3:0] uart0_sel_i7;
reg [3:0] uart1_sel_i7;
// UART7 registers are all 8-bit wide7, and their7 addresses7
// are on byte boundaries7. So7 to access them7 on the
// Wishbone7 bus, the CPU7 must do byte accesses to these7
// byte addresses7. Word7 address accesses are not possible7
// because the word7 addresses7 will be unaligned7, and cause
// a fault7.
// So7, Uart7 accesses from the CPU7 will always be 8-bit size
// We7 only have to decide7 which byte of the 4-byte word7 the
// CPU7 is interested7 in.
`ifdef SYSTEM_BIG_ENDIAN7
always @(paddr7) begin
  case (paddr7[1:0])
    2'b00 : uart0_sel_i7 = 4'b1000;
    2'b01 : uart0_sel_i7 = 4'b0100;
    2'b10 : uart0_sel_i7 = 4'b0010;
    2'b11 : uart0_sel_i7 = 4'b0001;
  endcase
end
always @(paddr7) begin
  case (paddr7[1:0])
    2'b00 : uart1_sel_i7 = 4'b1000;
    2'b01 : uart1_sel_i7 = 4'b0100;
    2'b10 : uart1_sel_i7 = 4'b0010;
    2'b11 : uart1_sel_i7 = 4'b0001;
  endcase
end
`else
always @(paddr7) begin
  case (paddr7[1:0])
    2'b00 : uart0_sel_i7 = 4'b0001;
    2'b01 : uart0_sel_i7 = 4'b0010;
    2'b10 : uart0_sel_i7 = 4'b0100;
    2'b11 : uart0_sel_i7 = 4'b1000;
  endcase
end
always @(paddr7) begin
  case (paddr7[1:0])
    2'b00 : uart1_sel_i7 = 4'b0001;
    2'b01 : uart1_sel_i7 = 4'b0010;
    2'b10 : uart1_sel_i7 = 4'b0100;
    2'b11 : uart1_sel_i7 = 4'b1000;
  endcase
end
`endif

uart_top7 i_oc_uart07 (
  .wb_clk_i7(pclk7),
  .wb_rst_i7(~n_preset7),
  .wb_adr_i7(paddr7[4:0]),
  .wb_dat_i7(pwdata7),
  .wb_dat_o7(prdata_uart07),
  .wb_we_i7(pwrite7),
  .wb_stb_i7(psel_uart07),
  .wb_cyc_i7(psel_uart07),
  .wb_ack_o7(pready_uart07),
  .wb_sel_i7(uart0_sel_i7),
  .int_o7(UART_int7),
  .stx_pad_o7(ua_txd7),
  .srx_pad_i7(ua_rxd7),
  .rts_pad_o7(ua_nrts_int7),
  .cts_pad_i7(ua_ncts7),
  .dtr_pad_o7(),
  .dsr_pad_i7(1'b0),
  .ri_pad_i7(1'b0),
  .dcd_pad_i7(1'b0)
);

uart_top7 i_oc_uart17 (
  .wb_clk_i7(pclk7),
  .wb_rst_i7(~n_preset7),
  .wb_adr_i7(paddr7[4:0]),
  .wb_dat_i7(pwdata7),
  .wb_dat_o7(prdata_uart17),
  .wb_we_i7(pwrite7),
  .wb_stb_i7(psel_uart17),
  .wb_cyc_i7(psel_uart17),
  .wb_ack_o7(pready_uart17),
  .wb_sel_i7(uart1_sel_i7),
  .int_o7(UART_int17),
  .stx_pad_o7(ua_txd17),
  .srx_pad_i7(ua_rxd17),
  .rts_pad_o7(ua_nrts1_int7),
  .cts_pad_i7(ua_ncts17),
  .dtr_pad_o7(),
  .dsr_pad_i7(1'b0),
  .ri_pad_i7(1'b0),
  .dcd_pad_i7(1'b0)
);

gpio_veneer7 i_gpio_veneer7 (
        //inputs7

        . n_p_reset7(n_preset7),
        . pclk7(pclk7),
        . psel7(psel_gpio7),
        . penable7(penable7),
        . pwrite7(pwrite7),
        . paddr7(paddr7[5:0]),
        . pwdata7(pwdata7),
        . gpio_pin_in7(gpio_pin_in7),
        . scan_en7(scan_en7),
        . tri_state_enable7(tri_state_enable7),
        . scan_in7(), //added by smarkov7 for dft7

        //outputs7
        . scan_out7(), //added by smarkov7 for dft7
        . prdata7(prdata_gpio7),
        . gpio_int7(GPIO_int7),
        . n_gpio_pin_oe7(n_gpio_pin_oe7),
        . gpio_pin_out7(gpio_pin_out7)
);


ttc_veneer7 i_ttc_veneer7 (

         //inputs7
        . n_p_reset7(n_preset7),
        . pclk7(pclk7),
        . psel7(psel_ttc7),
        . penable7(penable7),
        . pwrite7(pwrite7),
        . pwdata7(pwdata7),
        . paddr7(paddr7[7:0]),
        . scan_in7(),
        . scan_en7(scan_en7),

        //outputs7
        . prdata7(prdata_ttc7),
        . interrupt7(TTC_int7[3:1]),
        . scan_out7()
);


smc_veneer7 i_smc_veneer7 (
        //inputs7
	//apb7 inputs7
        . n_preset7(n_preset7),
        . pclk7(pclk_SRPG_smc7),
        . psel7(psel_smc7),
        . penable7(penable7),
        . pwrite7(pwrite7),
        . paddr7(paddr7[4:0]),
        . pwdata7(pwdata7),
        //ahb7 inputs7
	. hclk7(smc_hclk7),
        . n_sys_reset7(rstn_non_srpg_smc7),
        . haddr7(smc_haddr7),
        . htrans7(smc_htrans7),
        . hsel7(smc_hsel_int7),
        . hwrite7(smc_hwrite7),
	. hsize7(smc_hsize7),
        . hwdata7(smc_hwdata7),
        . hready7(smc_hready_in7),
        . data_smc7(data_smc7),

         //test signal7 inputs7

        . scan_in_17(),
        . scan_in_27(),
        . scan_in_37(),
        . scan_en7(scan_en7),

        //apb7 outputs7
        . prdata7(prdata_smc7),

       //design output

        . smc_hrdata7(smc_hrdata7),
        . smc_hready7(smc_hready7),
        . smc_hresp7(smc_hresp7),
        . smc_valid7(smc_valid7),
        . smc_addr7(smc_addr_int7),
        . smc_data7(smc_data7),
        . smc_n_be7(smc_n_be7),
        . smc_n_cs7(smc_n_cs7),
        . smc_n_wr7(smc_n_wr7),
        . smc_n_we7(smc_n_we7),
        . smc_n_rd7(smc_n_rd7),
        . smc_n_ext_oe7(smc_n_ext_oe7),
        . smc_busy7(smc_busy7),

         //test signal7 output
        . scan_out_17(),
        . scan_out_27(),
        . scan_out_37()
);

power_ctrl_veneer7 i_power_ctrl_veneer7 (
    // -- Clocks7 & Reset7
    	.pclk7(pclk7), 			//  : in  std_logic7;
    	.nprst7(n_preset7), 		//  : in  std_logic7;
    // -- APB7 programming7 interface
    	.paddr7(paddr7), 			//  : in  std_logic_vector7(31 downto7 0);
    	.psel7(psel_pmc7), 			//  : in  std_logic7;
    	.penable7(penable7), 		//  : in  std_logic7;
    	.pwrite7(pwrite7), 		//  : in  std_logic7;
    	.pwdata7(pwdata7), 		//  : in  std_logic_vector7(31 downto7 0);
    	.prdata7(prdata_pmc7), 		//  : out std_logic_vector7(31 downto7 0);
        .macb3_wakeup7(macb3_wakeup7),
        .macb2_wakeup7(macb2_wakeup7),
        .macb1_wakeup7(macb1_wakeup7),
        .macb0_wakeup7(macb0_wakeup7),
    // -- Module7 control7 outputs7
    	.scan_in7(),			//  : in  std_logic7;
    	.scan_en7(scan_en7),             	//  : in  std_logic7;
    	.scan_mode7(scan_mode7),          //  : in  std_logic7;
    	.scan_out7(),            	//  : out std_logic7;
        .int_source_h7(int_source_h7),
     	.rstn_non_srpg_smc7(rstn_non_srpg_smc7), 		//   : out std_logic7;
    	.gate_clk_smc7(gate_clk_smc7), 	//  : out std_logic7;
    	.isolate_smc7(isolate_smc7), 	//  : out std_logic7;
    	.save_edge_smc7(save_edge_smc7), 	//  : out std_logic7;
    	.restore_edge_smc7(restore_edge_smc7), 	//  : out std_logic7;
    	.pwr1_on_smc7(pwr1_on_smc7), 	//  : out std_logic7;
    	.pwr2_on_smc7(pwr2_on_smc7), 	//  : out std_logic7
     	.rstn_non_srpg_urt7(rstn_non_srpg_urt7), 		//   : out std_logic7;
    	.gate_clk_urt7(gate_clk_urt7), 	//  : out std_logic7;
    	.isolate_urt7(isolate_urt7), 	//  : out std_logic7;
    	.save_edge_urt7(save_edge_urt7), 	//  : out std_logic7;
    	.restore_edge_urt7(restore_edge_urt7), 	//  : out std_logic7;
    	.pwr1_on_urt7(pwr1_on_urt7), 	//  : out std_logic7;
    	.pwr2_on_urt7(pwr2_on_urt7),  	//  : out std_logic7
        // ETH07
        .rstn_non_srpg_macb07(rstn_non_srpg_macb07),
        .gate_clk_macb07(gate_clk_macb07),
        .isolate_macb07(isolate_macb07),
        .save_edge_macb07(save_edge_macb07),
        .restore_edge_macb07(restore_edge_macb07),
        .pwr1_on_macb07(pwr1_on_macb07),
        .pwr2_on_macb07(pwr2_on_macb07),
        // ETH17
        .rstn_non_srpg_macb17(rstn_non_srpg_macb17),
        .gate_clk_macb17(gate_clk_macb17),
        .isolate_macb17(isolate_macb17),
        .save_edge_macb17(save_edge_macb17),
        .restore_edge_macb17(restore_edge_macb17),
        .pwr1_on_macb17(pwr1_on_macb17),
        .pwr2_on_macb17(pwr2_on_macb17),
        // ETH27
        .rstn_non_srpg_macb27(rstn_non_srpg_macb27),
        .gate_clk_macb27(gate_clk_macb27),
        .isolate_macb27(isolate_macb27),
        .save_edge_macb27(save_edge_macb27),
        .restore_edge_macb27(restore_edge_macb27),
        .pwr1_on_macb27(pwr1_on_macb27),
        .pwr2_on_macb27(pwr2_on_macb27),
        // ETH37
        .rstn_non_srpg_macb37(rstn_non_srpg_macb37),
        .gate_clk_macb37(gate_clk_macb37),
        .isolate_macb37(isolate_macb37),
        .save_edge_macb37(save_edge_macb37),
        .restore_edge_macb37(restore_edge_macb37),
        .pwr1_on_macb37(pwr1_on_macb37),
        .pwr2_on_macb37(pwr2_on_macb37),
        .core06v7(core06v7),
        .core08v7(core08v7),
        .core10v7(core10v7),
        .core12v7(core12v7),
        .pcm_macb_wakeup_int7(pcm_macb_wakeup_int7),
        .isolate_mem7(isolate_mem7),
        .mte_smc_start7(mte_smc_start7),
        .mte_uart_start7(mte_uart_start7),
        .mte_smc_uart_start7(mte_smc_uart_start7),  
        .mte_pm_smc_to_default_start7(mte_pm_smc_to_default_start7), 
        .mte_pm_uart_to_default_start7(mte_pm_uart_to_default_start7),
        .mte_pm_smc_uart_to_default_start7(mte_pm_smc_uart_to_default_start7)
);

// Clock7 gating7 macro7 to shut7 off7 clocks7 to the SRPG7 flops7 in the SMC7
//CKLNQD17 i_SMC_SRPG_clk_gate7  (
//	.TE7(scan_mode7), 
//	.E7(~gate_clk_smc7), 
//	.CP7(pclk7), 
//	.Q7(pclk_SRPG_smc7)
//	);
// Replace7 gate7 with behavioural7 code7 //
wire 	smc_scan_gate7;
reg 	smc_latched_enable7;
assign smc_scan_gate7 = scan_mode7 ? 1'b1 : ~gate_clk_smc7;

always @ (pclk7 or smc_scan_gate7)
  	if (pclk7 == 1'b0) begin
  		smc_latched_enable7 <= smc_scan_gate7;
  	end  	
	
assign pclk_SRPG_smc7 = smc_latched_enable7 ? pclk7 : 1'b0;


// Clock7 gating7 macro7 to shut7 off7 clocks7 to the SRPG7 flops7 in the URT7
//CKLNQD17 i_URT_SRPG_clk_gate7  (
//	.TE7(scan_mode7), 
//	.E7(~gate_clk_urt7), 
//	.CP7(pclk7), 
//	.Q7(pclk_SRPG_urt7)
//	);
// Replace7 gate7 with behavioural7 code7 //
wire 	urt_scan_gate7;
reg 	urt_latched_enable7;
assign urt_scan_gate7 = scan_mode7 ? 1'b1 : ~gate_clk_urt7;

always @ (pclk7 or urt_scan_gate7)
  	if (pclk7 == 1'b0) begin
  		urt_latched_enable7 <= urt_scan_gate7;
  	end  	
	
assign pclk_SRPG_urt7 = urt_latched_enable7 ? pclk7 : 1'b0;

// ETH07
wire 	macb0_scan_gate7;
reg 	macb0_latched_enable7;
assign macb0_scan_gate7 = scan_mode7 ? 1'b1 : ~gate_clk_macb07;

always @ (pclk7 or macb0_scan_gate7)
  	if (pclk7 == 1'b0) begin
  		macb0_latched_enable7 <= macb0_scan_gate7;
  	end  	
	
assign clk_SRPG_macb0_en7 = macb0_latched_enable7 ? 1'b1 : 1'b0;

// ETH17
wire 	macb1_scan_gate7;
reg 	macb1_latched_enable7;
assign macb1_scan_gate7 = scan_mode7 ? 1'b1 : ~gate_clk_macb17;

always @ (pclk7 or macb1_scan_gate7)
  	if (pclk7 == 1'b0) begin
  		macb1_latched_enable7 <= macb1_scan_gate7;
  	end  	
	
assign clk_SRPG_macb1_en7 = macb1_latched_enable7 ? 1'b1 : 1'b0;

// ETH27
wire 	macb2_scan_gate7;
reg 	macb2_latched_enable7;
assign macb2_scan_gate7 = scan_mode7 ? 1'b1 : ~gate_clk_macb27;

always @ (pclk7 or macb2_scan_gate7)
  	if (pclk7 == 1'b0) begin
  		macb2_latched_enable7 <= macb2_scan_gate7;
  	end  	
	
assign clk_SRPG_macb2_en7 = macb2_latched_enable7 ? 1'b1 : 1'b0;

// ETH37
wire 	macb3_scan_gate7;
reg 	macb3_latched_enable7;
assign macb3_scan_gate7 = scan_mode7 ? 1'b1 : ~gate_clk_macb37;

always @ (pclk7 or macb3_scan_gate7)
  	if (pclk7 == 1'b0) begin
  		macb3_latched_enable7 <= macb3_scan_gate7;
  	end  	
	
assign clk_SRPG_macb3_en7 = macb3_latched_enable7 ? 1'b1 : 1'b0;



`else
//------------------------------------------------------------------------------
// if the APB7 subsystem7 is black7 boxed7 
//------------------------------------------------------------------------------
// wire s ports7
    // system signals7
    wire         hclk7;     // AHB7 Clock7
    wire         n_hreset7;  // AHB7 reset - Active7 low7
    wire         pclk7;     // APB7 Clock7. 
    wire         n_preset7;  // APB7 reset - Active7 low7

    // AHB7 interface
    wire         ahb2apb0_hsel7;     // AHB2APB7 select7
    wire  [31:0] haddr7;    // Address bus
    wire  [1:0]  htrans7;   // Transfer7 type
    wire  [2:0]  hsize7;    // AHB7 Access type - byte, half7-word7, word7
    wire  [31:0] hwdata7;   // Write data
    wire         hwrite7;   // Write signal7/
    wire         hready_in7;// Indicates7 that last master7 has finished7 bus access
    wire [2:0]   hburst7;     // Burst type
    wire [3:0]   hprot7;      // Protection7 control7
    wire [3:0]   hmaster7;    // Master7 select7
    wire         hmastlock7;  // Locked7 transfer7
  // Interrupts7 from the Enet7 MACs7
    wire         macb0_int7;
    wire         macb1_int7;
    wire         macb2_int7;
    wire         macb3_int7;
  // Interrupt7 from the DMA7
    wire         DMA_irq7;
  // Scan7 wire s
    wire         scan_en7;    // Scan7 enable pin7
    wire         scan_in_17;  // Scan7 wire  for first chain7
    wire         scan_in_27;  // Scan7 wire  for second chain7
    wire         scan_mode7;  // test mode pin7
 
  //wire  for smc7 AHB7 interface
    wire         smc_hclk7;
    wire         smc_n_hclk7;
    wire  [31:0] smc_haddr7;
    wire  [1:0]  smc_htrans7;
    wire         smc_hsel7;
    wire         smc_hwrite7;
    wire  [2:0]  smc_hsize7;
    wire  [31:0] smc_hwdata7;
    wire         smc_hready_in7;
    wire  [2:0]  smc_hburst7;     // Burst type
    wire  [3:0]  smc_hprot7;      // Protection7 control7
    wire  [3:0]  smc_hmaster7;    // Master7 select7
    wire         smc_hmastlock7;  // Locked7 transfer7


    wire  [31:0] data_smc7;     // EMI7(External7 memory) read data
    
  //wire s for uart7
    wire         ua_rxd7;       // UART7 receiver7 serial7 wire  pin7
    wire         ua_rxd17;      // UART7 receiver7 serial7 wire  pin7
    wire         ua_ncts7;      // Clear-To7-Send7 flow7 control7
    wire         ua_ncts17;      // Clear-To7-Send7 flow7 control7
   //wire s for spi7
    wire         n_ss_in7;      // select7 wire  to slave7
    wire         mi7;           // data wire  to master7
    wire         si7;           // data wire  to slave7
    wire         sclk_in7;      // clock7 wire  to slave7
  //wire s for GPIO7
   wire  [GPIO_WIDTH7-1:0]  gpio_pin_in7;             // wire  data from pin7

  //reg    ports7
  // Scan7 reg   s
   reg           scan_out_17;   // Scan7 out for chain7 1
   reg           scan_out_27;   // Scan7 out for chain7 2
  //AHB7 interface 
   reg    [31:0] hrdata7;       // Read data provided from target slave7
   reg           hready7;       // Ready7 for new bus cycle from target slave7
   reg    [1:0]  hresp7;       // Response7 from the bridge7

   // SMC7 reg    for AHB7 interface
   reg    [31:0]    smc_hrdata7;
   reg              smc_hready7;
   reg    [1:0]     smc_hresp7;

  //reg   s from smc7
   reg    [15:0]    smc_addr7;      // External7 Memory (EMI7) address
   reg    [3:0]     smc_n_be7;      // EMI7 byte enables7 (Active7 LOW7)
   reg    [7:0]     smc_n_cs7;      // EMI7 Chip7 Selects7 (Active7 LOW7)
   reg    [3:0]     smc_n_we7;      // EMI7 write strobes7 (Active7 LOW7)
   reg              smc_n_wr7;      // EMI7 write enable (Active7 LOW7)
   reg              smc_n_rd7;      // EMI7 read stobe7 (Active7 LOW7)
   reg              smc_n_ext_oe7;  // EMI7 write data reg    enable
   reg    [31:0]    smc_data7;      // EMI7 write data
  //reg   s from uart7
   reg           ua_txd7;       	// UART7 transmitter7 serial7 reg   
   reg           ua_txd17;       // UART7 transmitter7 serial7 reg   
   reg           ua_nrts7;      	// Request7-To7-Send7 flow7 control7
   reg           ua_nrts17;      // Request7-To7-Send7 flow7 control7
   // reg   s from ttc7
  // reg   s from SPI7
   reg       so;                    // data reg    from slave7
   reg       mo7;                    // data reg    from master7
   reg       sclk_out7;              // clock7 reg    from master7
   reg    [P_SIZE7-1:0] n_ss_out7;    // peripheral7 select7 lines7 from master7
   reg       n_so_en7;               // out enable for slave7 data
   reg       n_mo_en7;               // out enable for master7 data
   reg       n_sclk_en7;             // out enable for master7 clock7
   reg       n_ss_en7;               // out enable for master7 peripheral7 lines7
  //reg   s from gpio7
   reg    [GPIO_WIDTH7-1:0]     n_gpio_pin_oe7;           // reg    enable signal7 to pin7
   reg    [GPIO_WIDTH7-1:0]     gpio_pin_out7;            // reg    signal7 to pin7


`endif
//------------------------------------------------------------------------------
// black7 boxed7 defines7 
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// APB7 and AHB7 interface formal7 verification7 monitors7
//------------------------------------------------------------------------------
`ifdef ABV_ON7
apb_assert7 i_apb_assert7 (

        // APB7 signals7
  	.n_preset7(n_preset7),
   	.pclk7(pclk7),
	.penable7(penable7),
	.paddr7(paddr7),
	.pwrite7(pwrite7),
	.pwdata7(pwdata7),

	.psel007(psel_spi7),
	.psel017(psel_uart07),
	.psel027(psel_gpio7),
	.psel037(psel_ttc7),
	.psel047(1'b0),
	.psel057(psel_smc7),
	.psel067(1'b0),
	.psel077(1'b0),
	.psel087(1'b0),
	.psel097(1'b0),
	.psel107(1'b0),
	.psel117(1'b0),
	.psel127(1'b0),
	.psel137(psel_pmc7),
	.psel147(psel_apic7),
	.psel157(psel_uart17),

        .prdata007(prdata_spi7),
        .prdata017(prdata_uart07), // Read Data from peripheral7 UART7 
        .prdata027(prdata_gpio7), // Read Data from peripheral7 GPIO7
        .prdata037(prdata_ttc7), // Read Data from peripheral7 TTC7
        .prdata047(32'b0), // 
        .prdata057(prdata_smc7), // Read Data from peripheral7 SMC7
        .prdata137(prdata_pmc7), // Read Data from peripheral7 Power7 Control7 Block
   	.prdata147(32'b0), // 
        .prdata157(prdata_uart17),


        // AHB7 signals7
        .hclk7(hclk7),         // ahb7 system clock7
        .n_hreset7(n_hreset7), // ahb7 system reset

        // ahb2apb7 signals7
        .hresp7(hresp7),
        .hready7(hready7),
        .hrdata7(hrdata7),
        .hwdata7(hwdata7),
        .hprot7(hprot7),
        .hburst7(hburst7),
        .hsize7(hsize7),
        .hwrite7(hwrite7),
        .htrans7(htrans7),
        .haddr7(haddr7),
        .ahb2apb_hsel7(ahb2apb0_hsel7));



//------------------------------------------------------------------------------
// AHB7 interface formal7 verification7 monitor7
//------------------------------------------------------------------------------
defparam i_ahbSlaveMonitor7.DBUS_WIDTH7 = 32;
defparam i_ahbMasterMonitor7.DBUS_WIDTH7 = 32;


// AHB2APB7 Bridge7

    ahb_liteslave_monitor7 i_ahbSlaveMonitor7 (
        .hclk_i7(hclk7),
        .hresetn_i7(n_hreset7),
        .hresp7(hresp7),
        .hready7(hready7),
        .hready_global_i7(hready7),
        .hrdata7(hrdata7),
        .hwdata_i7(hwdata7),
        .hburst_i7(hburst7),
        .hsize_i7(hsize7),
        .hwrite_i7(hwrite7),
        .htrans_i7(htrans7),
        .haddr_i7(haddr7),
        .hsel_i7(ahb2apb0_hsel7)
    );


  ahb_litemaster_monitor7 i_ahbMasterMonitor7 (
          .hclk_i7(hclk7),
          .hresetn_i7(n_hreset7),
          .hresp_i7(hresp7),
          .hready_i7(hready7),
          .hrdata_i7(hrdata7),
          .hlock7(1'b0),
          .hwdata7(hwdata7),
          .hprot7(hprot7),
          .hburst7(hburst7),
          .hsize7(hsize7),
          .hwrite7(hwrite7),
          .htrans7(htrans7),
          .haddr7(haddr7)
          );







`endif




`ifdef IFV_LP_ABV_ON7
// power7 control7
wire isolate7;

// testbench mirror signals7
wire L1_ctrl_access7;
wire L1_status_access7;

wire [31:0] L1_status_reg7;
wire [31:0] L1_ctrl_reg7;

//wire rstn_non_srpg_urt7;
//wire isolate_urt7;
//wire retain_urt7;
//wire gate_clk_urt7;
//wire pwr1_on_urt7;


// smc7 signals7
wire [31:0] smc_prdata7;
wire lp_clk_smc7;
                    

// uart7 isolation7 register
  wire [15:0] ua_prdata7;
  wire ua_int7;
  assign ua_prdata7          =  i_uart1_veneer7.prdata7;
  assign ua_int7             =  i_uart1_veneer7.ua_int7;


assign lp_clk_smc7          = i_smc_veneer7.pclk7;
assign smc_prdata7          = i_smc_veneer7.prdata7;
lp_chk_smc7 u_lp_chk_smc7 (
    .clk7 (hclk7),
    .rst7 (n_hreset7),
    .iso_smc7 (isolate_smc7),
    .gate_clk7 (gate_clk_smc7),
    .lp_clk7 (pclk_SRPG_smc7),

    // srpg7 outputs7
    .smc_hrdata7 (smc_hrdata7),
    .smc_hready7 (smc_hready7),
    .smc_hresp7  (smc_hresp7),
    .smc_valid7 (smc_valid7),
    .smc_addr_int7 (smc_addr_int7),
    .smc_data7 (smc_data7),
    .smc_n_be7 (smc_n_be7),
    .smc_n_cs7  (smc_n_cs7),
    .smc_n_wr7 (smc_n_wr7),
    .smc_n_we7 (smc_n_we7),
    .smc_n_rd7 (smc_n_rd7),
    .smc_n_ext_oe7 (smc_n_ext_oe7)
   );

// lp7 retention7/isolation7 assertions7
lp_chk_uart7 u_lp_chk_urt7 (

  .clk7         (hclk7),
  .rst7         (n_hreset7),
  .iso_urt7     (isolate_urt7),
  .gate_clk7    (gate_clk_urt7),
  .lp_clk7      (pclk_SRPG_urt7),
  //ports7
  .prdata7 (ua_prdata7),
  .ua_int7 (ua_int7),
  .ua_txd7 (ua_txd17),
  .ua_nrts7 (ua_nrts17)
 );

`endif  //IFV_LP_ABV_ON7




endmodule
