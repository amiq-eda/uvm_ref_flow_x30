//File2 name   : apb_subsystem_02.v
//Title2       : 
//Created2     : 1999
//Description2 : 
//Notes2       : 
//----------------------------------------------------------------------
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------

module apb_subsystem_02(
    // AHB2 interface
    hclk2,
    n_hreset2,
    hsel2,
    haddr2,
    htrans2,
    hsize2,
    hwrite2,
    hwdata2,
    hready_in2,
    hburst2,
    hprot2,
    hmaster2,
    hmastlock2,
    hrdata2,
    hready2,
    hresp2,
    
    // APB2 system interface
    pclk2,
    n_preset2,
    
    // SPI2 ports2
    n_ss_in2,
    mi2,
    si2,
    sclk_in2,
    so,
    mo2,
    sclk_out2,
    n_ss_out2,
    n_so_en2,
    n_mo_en2,
    n_sclk_en2,
    n_ss_en2,
    
    //UART02 ports2
    ua_rxd2,
    ua_ncts2,
    ua_txd2,
    ua_nrts2,
    
    //UART12 ports2
    ua_rxd12,
    ua_ncts12,
    ua_txd12,
    ua_nrts12,
    
    //GPIO2 ports2
    gpio_pin_in2,
    n_gpio_pin_oe2,
    gpio_pin_out2,
    

    //SMC2 ports2
    smc_hclk2,
    smc_n_hclk2,
    smc_haddr2,
    smc_htrans2,
    smc_hsel2,
    smc_hwrite2,
    smc_hsize2,
    smc_hwdata2,
    smc_hready_in2,
    smc_hburst2,
    smc_hprot2,
    smc_hmaster2,
    smc_hmastlock2,
    smc_hrdata2, 
    smc_hready2,
    smc_hresp2,
    smc_n_ext_oe2,
    smc_data2,
    smc_addr2,
    smc_n_be2,
    smc_n_cs2, 
    smc_n_we2,
    smc_n_wr2,
    smc_n_rd2,
    data_smc2,
    
    //PMC2 ports2
    clk_SRPG_macb0_en2,
    clk_SRPG_macb1_en2,
    clk_SRPG_macb2_en2,
    clk_SRPG_macb3_en2,
    core06v2,
    core08v2,
    core10v2,
    core12v2,
    macb3_wakeup2,
    macb2_wakeup2,
    macb1_wakeup2,
    macb0_wakeup2,
    mte_smc_start2,
    mte_uart_start2,
    mte_smc_uart_start2,  
    mte_pm_smc_to_default_start2, 
    mte_pm_uart_to_default_start2,
    mte_pm_smc_uart_to_default_start2,
    
    
    // Peripheral2 inerrupts2
    pcm_irq2,
    ttc_irq2,
    gpio_irq2,
    uart0_irq2,
    uart1_irq2,
    spi_irq2,
    DMA_irq2,      
    macb0_int2,
    macb1_int2,
    macb2_int2,
    macb3_int2,
   
    // Scan2 ports2
    scan_en2,      // Scan2 enable pin2
    scan_in_12,    // Scan2 input for first chain2
    scan_in_22,    // Scan2 input for second chain2
    scan_mode2,
    scan_out_12,   // Scan2 out for chain2 1
    scan_out_22    // Scan2 out for chain2 2
);

parameter GPIO_WIDTH2 = 16;        // GPIO2 width
parameter P_SIZE2 =   8;              // number2 of peripheral2 select2 lines2
parameter NO_OF_IRQS2  = 17;      //No of irqs2 read by apic2 

// AHB2 interface
input         hclk2;     // AHB2 Clock2
input         n_hreset2;  // AHB2 reset - Active2 low2
input         hsel2;     // AHB2APB2 select2
input [31:0]  haddr2;    // Address bus
input [1:0]   htrans2;   // Transfer2 type
input [2:0]   hsize2;    // AHB2 Access type - byte, half2-word2, word2
input [31:0]  hwdata2;   // Write data
input         hwrite2;   // Write signal2/
input         hready_in2;// Indicates2 that last master2 has finished2 bus access
input [2:0]   hburst2;     // Burst type
input [3:0]   hprot2;      // Protection2 control2
input [3:0]   hmaster2;    // Master2 select2
input         hmastlock2;  // Locked2 transfer2
output [31:0] hrdata2;       // Read data provided from target slave2
output        hready2;       // Ready2 for new bus cycle from target slave2
output [1:0]  hresp2;       // Response2 from the bridge2
    
// APB2 system interface
input         pclk2;     // APB2 Clock2. 
input         n_preset2;  // APB2 reset - Active2 low2
   
// SPI2 ports2
input     n_ss_in2;      // select2 input to slave2
input     mi2;           // data input to master2
input     si2;           // data input to slave2
input     sclk_in2;      // clock2 input to slave2
output    so;                    // data output from slave2
output    mo2;                    // data output from master2
output    sclk_out2;              // clock2 output from master2
output [P_SIZE2-1:0] n_ss_out2;    // peripheral2 select2 lines2 from master2
output    n_so_en2;               // out enable for slave2 data
output    n_mo_en2;               // out enable for master2 data
output    n_sclk_en2;             // out enable for master2 clock2
output    n_ss_en2;               // out enable for master2 peripheral2 lines2

//UART02 ports2
input        ua_rxd2;       // UART2 receiver2 serial2 input pin2
input        ua_ncts2;      // Clear-To2-Send2 flow2 control2
output       ua_txd2;       	// UART2 transmitter2 serial2 output
output       ua_nrts2;      	// Request2-To2-Send2 flow2 control2

// UART12 ports2   
input        ua_rxd12;      // UART2 receiver2 serial2 input pin2
input        ua_ncts12;      // Clear-To2-Send2 flow2 control2
output       ua_txd12;       // UART2 transmitter2 serial2 output
output       ua_nrts12;      // Request2-To2-Send2 flow2 control2

//GPIO2 ports2
input [GPIO_WIDTH2-1:0]      gpio_pin_in2;             // input data from pin2
output [GPIO_WIDTH2-1:0]     n_gpio_pin_oe2;           // output enable signal2 to pin2
output [GPIO_WIDTH2-1:0]     gpio_pin_out2;            // output signal2 to pin2
  
//SMC2 ports2
input        smc_hclk2;
input        smc_n_hclk2;
input [31:0] smc_haddr2;
input [1:0]  smc_htrans2;
input        smc_hsel2;
input        smc_hwrite2;
input [2:0]  smc_hsize2;
input [31:0] smc_hwdata2;
input        smc_hready_in2;
input [2:0]  smc_hburst2;     // Burst type
input [3:0]  smc_hprot2;      // Protection2 control2
input [3:0]  smc_hmaster2;    // Master2 select2
input        smc_hmastlock2;  // Locked2 transfer2
input [31:0] data_smc2;     // EMI2(External2 memory) read data
output [31:0]    smc_hrdata2;
output           smc_hready2;
output [1:0]     smc_hresp2;
output [15:0]    smc_addr2;      // External2 Memory (EMI2) address
output [3:0]     smc_n_be2;      // EMI2 byte enables2 (Active2 LOW2)
output           smc_n_cs2;      // EMI2 Chip2 Selects2 (Active2 LOW2)
output [3:0]     smc_n_we2;      // EMI2 write strobes2 (Active2 LOW2)
output           smc_n_wr2;      // EMI2 write enable (Active2 LOW2)
output           smc_n_rd2;      // EMI2 read stobe2 (Active2 LOW2)
output           smc_n_ext_oe2;  // EMI2 write data output enable
output [31:0]    smc_data2;      // EMI2 write data
       
//PMC2 ports2
output clk_SRPG_macb0_en2;
output clk_SRPG_macb1_en2;
output clk_SRPG_macb2_en2;
output clk_SRPG_macb3_en2;
output core06v2;
output core08v2;
output core10v2;
output core12v2;
output mte_smc_start2;
output mte_uart_start2;
output mte_smc_uart_start2;  
output mte_pm_smc_to_default_start2; 
output mte_pm_uart_to_default_start2;
output mte_pm_smc_uart_to_default_start2;
input macb3_wakeup2;
input macb2_wakeup2;
input macb1_wakeup2;
input macb0_wakeup2;
    

// Peripheral2 interrupts2
output pcm_irq2;
output [2:0] ttc_irq2;
output gpio_irq2;
output uart0_irq2;
output uart1_irq2;
output spi_irq2;
input        macb0_int2;
input        macb1_int2;
input        macb2_int2;
input        macb3_int2;
input        DMA_irq2;
  
//Scan2 ports2
input        scan_en2;    // Scan2 enable pin2
input        scan_in_12;  // Scan2 input for first chain2
input        scan_in_22;  // Scan2 input for second chain2
input        scan_mode2;  // test mode pin2
 output        scan_out_12;   // Scan2 out for chain2 1
 output        scan_out_22;   // Scan2 out for chain2 2  

//------------------------------------------------------------------------------
// if the ROM2 subsystem2 is NOT2 black2 boxed2 
//------------------------------------------------------------------------------
`ifndef FV_KIT_BLACK_BOX_APB_SUBSYSTEM2
   
   wire        hsel2; 
   wire        pclk2;
   wire        n_preset2;
   wire [31:0] prdata_spi2;
   wire [31:0] prdata_uart02;
   wire [31:0] prdata_gpio2;
   wire [31:0] prdata_ttc2;
   wire [31:0] prdata_smc2;
   wire [31:0] prdata_pmc2;
   wire [31:0] prdata_uart12;
   wire        pready_spi2;
   wire        pready_uart02;
   wire        pready_uart12;
   wire        tie_hi_bit2;
   wire  [31:0] hrdata2; 
   wire         hready2;
   wire         hready_in2;
   wire  [1:0]  hresp2;   
   wire  [31:0] pwdata2;  
   wire         pwrite2;
   wire  [31:0] paddr2;  
   wire   psel_spi2;
   wire   psel_uart02;
   wire   psel_gpio2;
   wire   psel_ttc2;
   wire   psel_smc2;
   wire   psel072;
   wire   psel082;
   wire   psel092;
   wire   psel102;
   wire   psel112;
   wire   psel122;
   wire   psel_pmc2;
   wire   psel_uart12;
   wire   penable2;
   wire   [NO_OF_IRQS2:0] int_source2;     // System2 Interrupt2 Sources2
   wire [1:0]             smc_hresp2;     // AHB2 Response2 signal2
   wire                   smc_valid2;     // Ack2 valid address

  //External2 memory interface (EMI2)
  wire [31:0]            smc_addr_int2;  // External2 Memory (EMI2) address
  wire [3:0]             smc_n_be2;      // EMI2 byte enables2 (Active2 LOW2)
  wire                   smc_n_cs2;      // EMI2 Chip2 Selects2 (Active2 LOW2)
  wire [3:0]             smc_n_we2;      // EMI2 write strobes2 (Active2 LOW2)
  wire                   smc_n_wr2;      // EMI2 write enable (Active2 LOW2)
  wire                   smc_n_rd2;      // EMI2 read stobe2 (Active2 LOW2)
 
  //AHB2 Memory Interface2 Control2
  wire                   smc_hsel_int2;
  wire                   smc_busy2;      // smc2 busy
   

//scan2 signals2

   wire                scan_in_12;        //scan2 input
   wire                scan_in_22;        //scan2 input
   wire                scan_en2;         //scan2 enable
   wire                scan_out_12;       //scan2 output
   wire                scan_out_22;       //scan2 output
   wire                byte_sel2;     // byte select2 from bridge2 1=byte, 0=2byte
   wire                UART_int2;     // UART2 module interrupt2 
   wire                ua_uclken2;    // Soft2 control2 of clock2
   wire                UART_int12;     // UART2 module interrupt2 
   wire                ua_uclken12;    // Soft2 control2 of clock2
   wire  [3:1]         TTC_int2;            //Interrupt2 from PCI2 
  // inputs2 to SPI2 
   wire    ext_clk2;                // external2 clock2
   wire    SPI_int2;             // interrupt2 request
  // outputs2 from SPI2
   wire    slave_out_clk2;         // modified slave2 clock2 output
 // gpio2 generic2 inputs2 
   wire  [GPIO_WIDTH2-1:0]   n_gpio_bypass_oe2;        // bypass2 mode enable 
   wire  [GPIO_WIDTH2-1:0]   gpio_bypass_out2;         // bypass2 mode output value 
   wire  [GPIO_WIDTH2-1:0]   tri_state_enable2;   // disables2 op enable -> z 
 // outputs2 
   //amba2 outputs2 
   // gpio2 generic2 outputs2 
   wire       GPIO_int2;                // gpio_interupt2 for input pin2 change 
   wire [GPIO_WIDTH2-1:0]     gpio_bypass_in2;          // bypass2 mode input data value  
                
   wire           cpu_debug2;        // Inhibits2 watchdog2 counter 
   wire            ex_wdz_n2;         // External2 Watchdog2 zero indication2
   wire           rstn_non_srpg_smc2; 
   wire           rstn_non_srpg_urt2;
   wire           isolate_smc2;
   wire           save_edge_smc2;
   wire           restore_edge_smc2;
   wire           save_edge_urt2;
   wire           restore_edge_urt2;
   wire           pwr1_on_smc2;
   wire           pwr2_on_smc2;
   wire           pwr1_on_urt2;
   wire           pwr2_on_urt2;
   // ETH02
   wire            rstn_non_srpg_macb02;
   wire            gate_clk_macb02;
   wire            isolate_macb02;
   wire            save_edge_macb02;
   wire            restore_edge_macb02;
   wire            pwr1_on_macb02;
   wire            pwr2_on_macb02;
   // ETH12
   wire            rstn_non_srpg_macb12;
   wire            gate_clk_macb12;
   wire            isolate_macb12;
   wire            save_edge_macb12;
   wire            restore_edge_macb12;
   wire            pwr1_on_macb12;
   wire            pwr2_on_macb12;
   // ETH22
   wire            rstn_non_srpg_macb22;
   wire            gate_clk_macb22;
   wire            isolate_macb22;
   wire            save_edge_macb22;
   wire            restore_edge_macb22;
   wire            pwr1_on_macb22;
   wire            pwr2_on_macb22;
   // ETH32
   wire            rstn_non_srpg_macb32;
   wire            gate_clk_macb32;
   wire            isolate_macb32;
   wire            save_edge_macb32;
   wire            restore_edge_macb32;
   wire            pwr1_on_macb32;
   wire            pwr2_on_macb32;


   wire           pclk_SRPG_smc2;
   wire           pclk_SRPG_urt2;
   wire           gate_clk_smc2;
   wire           gate_clk_urt2;
   wire  [31:0]   tie_lo_32bit2; 
   wire  [1:0]	  tie_lo_2bit2;
   wire  	  tie_lo_1bit2;
   wire           pcm_macb_wakeup_int2;
   wire           int_source_h2;
   wire           isolate_mem2;

assign pcm_irq2 = pcm_macb_wakeup_int2;
assign ttc_irq2[2] = TTC_int2[3];
assign ttc_irq2[1] = TTC_int2[2];
assign ttc_irq2[0] = TTC_int2[1];
assign gpio_irq2 = GPIO_int2;
assign uart0_irq2 = UART_int2;
assign uart1_irq2 = UART_int12;
assign spi_irq2 = SPI_int2;

assign n_mo_en2   = 1'b0;
assign n_so_en2   = 1'b1;
assign n_sclk_en2 = 1'b0;
assign n_ss_en2   = 1'b0;

assign smc_hsel_int2 = smc_hsel2;
  assign ext_clk2  = 1'b0;
  assign int_source2 = {macb0_int2,macb1_int2, macb2_int2, macb3_int2,1'b0, pcm_macb_wakeup_int2, 1'b0, 1'b0, 1'b0, 1'b0, TTC_int2, GPIO_int2, UART_int2, UART_int12, SPI_int2, DMA_irq2};

  // interrupt2 even2 detect2 .
  // for sleep2 wake2 up -> any interrupt2 even2 and system not in hibernation2 (isolate_mem2 = 0)
  // for hibernate2 wake2 up -> gpio2 interrupt2 even2 and system in the hibernation2 (isolate_mem2 = 1)
  assign int_source_h2 =  ((|int_source2) && (!isolate_mem2)) || (isolate_mem2 && GPIO_int2) ;

  assign byte_sel2 = 1'b1;
  assign tie_hi_bit2 = 1'b1;

  assign smc_addr2 = smc_addr_int2[15:0];



  assign  n_gpio_bypass_oe2 = {GPIO_WIDTH2{1'b0}};        // bypass2 mode enable 
  assign  gpio_bypass_out2  = {GPIO_WIDTH2{1'b0}};
  assign  tri_state_enable2 = {GPIO_WIDTH2{1'b0}};
  assign  cpu_debug2 = 1'b0;
  assign  tie_lo_32bit2 = 32'b0;
  assign  tie_lo_2bit2  = 2'b0;
  assign  tie_lo_1bit2  = 1'b0;


ahb2apb2 #(
  32'h00800000, // Slave2 0 Address Range2
  32'h0080FFFF,

  32'h00810000, // Slave2 1 Address Range2
  32'h0081FFFF,

  32'h00820000, // Slave2 2 Address Range2 
  32'h0082FFFF,

  32'h00830000, // Slave2 3 Address Range2
  32'h0083FFFF,

  32'h00840000, // Slave2 4 Address Range2
  32'h0084FFFF,

  32'h00850000, // Slave2 5 Address Range2
  32'h0085FFFF,

  32'h00860000, // Slave2 6 Address Range2
  32'h0086FFFF,

  32'h00870000, // Slave2 7 Address Range2
  32'h0087FFFF,

  32'h00880000, // Slave2 8 Address Range2
  32'h0088FFFF
) i_ahb2apb2 (
     // AHB2 interface
    .hclk2(hclk2),         
    .hreset_n2(n_hreset2), 
    .hsel2(hsel2), 
    .haddr2(haddr2),        
    .htrans2(htrans2),       
    .hwrite2(hwrite2),       
    .hwdata2(hwdata2),       
    .hrdata2(hrdata2),   
    .hready2(hready2),   
    .hresp2(hresp2),     
    
     // APB2 interface
    .pclk2(pclk2),         
    .preset_n2(n_preset2),  
    .prdata02(prdata_spi2),
    .prdata12(prdata_uart02), 
    .prdata22(prdata_gpio2),  
    .prdata32(prdata_ttc2),   
    .prdata42(32'h0),   
    .prdata52(prdata_smc2),   
    .prdata62(prdata_pmc2),    
    .prdata72(32'h0),   
    .prdata82(prdata_uart12),  
    .pready02(pready_spi2),     
    .pready12(pready_uart02),   
    .pready22(tie_hi_bit2),     
    .pready32(tie_hi_bit2),     
    .pready42(tie_hi_bit2),     
    .pready52(tie_hi_bit2),     
    .pready62(tie_hi_bit2),     
    .pready72(tie_hi_bit2),     
    .pready82(pready_uart12),  
    .pwdata2(pwdata2),       
    .pwrite2(pwrite2),       
    .paddr2(paddr2),        
    .psel02(psel_spi2),     
    .psel12(psel_uart02),   
    .psel22(psel_gpio2),    
    .psel32(psel_ttc2),     
    .psel42(),     
    .psel52(psel_smc2),     
    .psel62(psel_pmc2),    
    .psel72(psel_apic2),   
    .psel82(psel_uart12),  
    .penable2(penable2)     
);

spi_top2 i_spi2
(
  // Wishbone2 signals2
  .wb_clk_i2(pclk2), 
  .wb_rst_i2(~n_preset2), 
  .wb_adr_i2(paddr2[4:0]), 
  .wb_dat_i2(pwdata2), 
  .wb_dat_o2(prdata_spi2), 
  .wb_sel_i2(4'b1111),    // SPI2 register accesses are always 32-bit
  .wb_we_i2(pwrite2), 
  .wb_stb_i2(psel_spi2), 
  .wb_cyc_i2(psel_spi2), 
  .wb_ack_o2(pready_spi2), 
  .wb_err_o2(), 
  .wb_int_o2(SPI_int2),

  // SPI2 signals2
  .ss_pad_o2(n_ss_out2), 
  .sclk_pad_o2(sclk_out2), 
  .mosi_pad_o2(mo2), 
  .miso_pad_i2(mi2)
);

// Opencores2 UART2 instances2
wire ua_nrts_int2;
wire ua_nrts1_int2;

assign ua_nrts2 = ua_nrts_int2;
assign ua_nrts12 = ua_nrts1_int2;

reg [3:0] uart0_sel_i2;
reg [3:0] uart1_sel_i2;
// UART2 registers are all 8-bit wide2, and their2 addresses2
// are on byte boundaries2. So2 to access them2 on the
// Wishbone2 bus, the CPU2 must do byte accesses to these2
// byte addresses2. Word2 address accesses are not possible2
// because the word2 addresses2 will be unaligned2, and cause
// a fault2.
// So2, Uart2 accesses from the CPU2 will always be 8-bit size
// We2 only have to decide2 which byte of the 4-byte word2 the
// CPU2 is interested2 in.
`ifdef SYSTEM_BIG_ENDIAN2
always @(paddr2) begin
  case (paddr2[1:0])
    2'b00 : uart0_sel_i2 = 4'b1000;
    2'b01 : uart0_sel_i2 = 4'b0100;
    2'b10 : uart0_sel_i2 = 4'b0010;
    2'b11 : uart0_sel_i2 = 4'b0001;
  endcase
end
always @(paddr2) begin
  case (paddr2[1:0])
    2'b00 : uart1_sel_i2 = 4'b1000;
    2'b01 : uart1_sel_i2 = 4'b0100;
    2'b10 : uart1_sel_i2 = 4'b0010;
    2'b11 : uart1_sel_i2 = 4'b0001;
  endcase
end
`else
always @(paddr2) begin
  case (paddr2[1:0])
    2'b00 : uart0_sel_i2 = 4'b0001;
    2'b01 : uart0_sel_i2 = 4'b0010;
    2'b10 : uart0_sel_i2 = 4'b0100;
    2'b11 : uart0_sel_i2 = 4'b1000;
  endcase
end
always @(paddr2) begin
  case (paddr2[1:0])
    2'b00 : uart1_sel_i2 = 4'b0001;
    2'b01 : uart1_sel_i2 = 4'b0010;
    2'b10 : uart1_sel_i2 = 4'b0100;
    2'b11 : uart1_sel_i2 = 4'b1000;
  endcase
end
`endif

uart_top2 i_oc_uart02 (
  .wb_clk_i2(pclk2),
  .wb_rst_i2(~n_preset2),
  .wb_adr_i2(paddr2[4:0]),
  .wb_dat_i2(pwdata2),
  .wb_dat_o2(prdata_uart02),
  .wb_we_i2(pwrite2),
  .wb_stb_i2(psel_uart02),
  .wb_cyc_i2(psel_uart02),
  .wb_ack_o2(pready_uart02),
  .wb_sel_i2(uart0_sel_i2),
  .int_o2(UART_int2),
  .stx_pad_o2(ua_txd2),
  .srx_pad_i2(ua_rxd2),
  .rts_pad_o2(ua_nrts_int2),
  .cts_pad_i2(ua_ncts2),
  .dtr_pad_o2(),
  .dsr_pad_i2(1'b0),
  .ri_pad_i2(1'b0),
  .dcd_pad_i2(1'b0)
);

uart_top2 i_oc_uart12 (
  .wb_clk_i2(pclk2),
  .wb_rst_i2(~n_preset2),
  .wb_adr_i2(paddr2[4:0]),
  .wb_dat_i2(pwdata2),
  .wb_dat_o2(prdata_uart12),
  .wb_we_i2(pwrite2),
  .wb_stb_i2(psel_uart12),
  .wb_cyc_i2(psel_uart12),
  .wb_ack_o2(pready_uart12),
  .wb_sel_i2(uart1_sel_i2),
  .int_o2(UART_int12),
  .stx_pad_o2(ua_txd12),
  .srx_pad_i2(ua_rxd12),
  .rts_pad_o2(ua_nrts1_int2),
  .cts_pad_i2(ua_ncts12),
  .dtr_pad_o2(),
  .dsr_pad_i2(1'b0),
  .ri_pad_i2(1'b0),
  .dcd_pad_i2(1'b0)
);

gpio_veneer2 i_gpio_veneer2 (
        //inputs2

        . n_p_reset2(n_preset2),
        . pclk2(pclk2),
        . psel2(psel_gpio2),
        . penable2(penable2),
        . pwrite2(pwrite2),
        . paddr2(paddr2[5:0]),
        . pwdata2(pwdata2),
        . gpio_pin_in2(gpio_pin_in2),
        . scan_en2(scan_en2),
        . tri_state_enable2(tri_state_enable2),
        . scan_in2(), //added by smarkov2 for dft2

        //outputs2
        . scan_out2(), //added by smarkov2 for dft2
        . prdata2(prdata_gpio2),
        . gpio_int2(GPIO_int2),
        . n_gpio_pin_oe2(n_gpio_pin_oe2),
        . gpio_pin_out2(gpio_pin_out2)
);


ttc_veneer2 i_ttc_veneer2 (

         //inputs2
        . n_p_reset2(n_preset2),
        . pclk2(pclk2),
        . psel2(psel_ttc2),
        . penable2(penable2),
        . pwrite2(pwrite2),
        . pwdata2(pwdata2),
        . paddr2(paddr2[7:0]),
        . scan_in2(),
        . scan_en2(scan_en2),

        //outputs2
        . prdata2(prdata_ttc2),
        . interrupt2(TTC_int2[3:1]),
        . scan_out2()
);


smc_veneer2 i_smc_veneer2 (
        //inputs2
	//apb2 inputs2
        . n_preset2(n_preset2),
        . pclk2(pclk_SRPG_smc2),
        . psel2(psel_smc2),
        . penable2(penable2),
        . pwrite2(pwrite2),
        . paddr2(paddr2[4:0]),
        . pwdata2(pwdata2),
        //ahb2 inputs2
	. hclk2(smc_hclk2),
        . n_sys_reset2(rstn_non_srpg_smc2),
        . haddr2(smc_haddr2),
        . htrans2(smc_htrans2),
        . hsel2(smc_hsel_int2),
        . hwrite2(smc_hwrite2),
	. hsize2(smc_hsize2),
        . hwdata2(smc_hwdata2),
        . hready2(smc_hready_in2),
        . data_smc2(data_smc2),

         //test signal2 inputs2

        . scan_in_12(),
        . scan_in_22(),
        . scan_in_32(),
        . scan_en2(scan_en2),

        //apb2 outputs2
        . prdata2(prdata_smc2),

       //design output

        . smc_hrdata2(smc_hrdata2),
        . smc_hready2(smc_hready2),
        . smc_hresp2(smc_hresp2),
        . smc_valid2(smc_valid2),
        . smc_addr2(smc_addr_int2),
        . smc_data2(smc_data2),
        . smc_n_be2(smc_n_be2),
        . smc_n_cs2(smc_n_cs2),
        . smc_n_wr2(smc_n_wr2),
        . smc_n_we2(smc_n_we2),
        . smc_n_rd2(smc_n_rd2),
        . smc_n_ext_oe2(smc_n_ext_oe2),
        . smc_busy2(smc_busy2),

         //test signal2 output
        . scan_out_12(),
        . scan_out_22(),
        . scan_out_32()
);

power_ctrl_veneer2 i_power_ctrl_veneer2 (
    // -- Clocks2 & Reset2
    	.pclk2(pclk2), 			//  : in  std_logic2;
    	.nprst2(n_preset2), 		//  : in  std_logic2;
    // -- APB2 programming2 interface
    	.paddr2(paddr2), 			//  : in  std_logic_vector2(31 downto2 0);
    	.psel2(psel_pmc2), 			//  : in  std_logic2;
    	.penable2(penable2), 		//  : in  std_logic2;
    	.pwrite2(pwrite2), 		//  : in  std_logic2;
    	.pwdata2(pwdata2), 		//  : in  std_logic_vector2(31 downto2 0);
    	.prdata2(prdata_pmc2), 		//  : out std_logic_vector2(31 downto2 0);
        .macb3_wakeup2(macb3_wakeup2),
        .macb2_wakeup2(macb2_wakeup2),
        .macb1_wakeup2(macb1_wakeup2),
        .macb0_wakeup2(macb0_wakeup2),
    // -- Module2 control2 outputs2
    	.scan_in2(),			//  : in  std_logic2;
    	.scan_en2(scan_en2),             	//  : in  std_logic2;
    	.scan_mode2(scan_mode2),          //  : in  std_logic2;
    	.scan_out2(),            	//  : out std_logic2;
        .int_source_h2(int_source_h2),
     	.rstn_non_srpg_smc2(rstn_non_srpg_smc2), 		//   : out std_logic2;
    	.gate_clk_smc2(gate_clk_smc2), 	//  : out std_logic2;
    	.isolate_smc2(isolate_smc2), 	//  : out std_logic2;
    	.save_edge_smc2(save_edge_smc2), 	//  : out std_logic2;
    	.restore_edge_smc2(restore_edge_smc2), 	//  : out std_logic2;
    	.pwr1_on_smc2(pwr1_on_smc2), 	//  : out std_logic2;
    	.pwr2_on_smc2(pwr2_on_smc2), 	//  : out std_logic2
     	.rstn_non_srpg_urt2(rstn_non_srpg_urt2), 		//   : out std_logic2;
    	.gate_clk_urt2(gate_clk_urt2), 	//  : out std_logic2;
    	.isolate_urt2(isolate_urt2), 	//  : out std_logic2;
    	.save_edge_urt2(save_edge_urt2), 	//  : out std_logic2;
    	.restore_edge_urt2(restore_edge_urt2), 	//  : out std_logic2;
    	.pwr1_on_urt2(pwr1_on_urt2), 	//  : out std_logic2;
    	.pwr2_on_urt2(pwr2_on_urt2),  	//  : out std_logic2
        // ETH02
        .rstn_non_srpg_macb02(rstn_non_srpg_macb02),
        .gate_clk_macb02(gate_clk_macb02),
        .isolate_macb02(isolate_macb02),
        .save_edge_macb02(save_edge_macb02),
        .restore_edge_macb02(restore_edge_macb02),
        .pwr1_on_macb02(pwr1_on_macb02),
        .pwr2_on_macb02(pwr2_on_macb02),
        // ETH12
        .rstn_non_srpg_macb12(rstn_non_srpg_macb12),
        .gate_clk_macb12(gate_clk_macb12),
        .isolate_macb12(isolate_macb12),
        .save_edge_macb12(save_edge_macb12),
        .restore_edge_macb12(restore_edge_macb12),
        .pwr1_on_macb12(pwr1_on_macb12),
        .pwr2_on_macb12(pwr2_on_macb12),
        // ETH22
        .rstn_non_srpg_macb22(rstn_non_srpg_macb22),
        .gate_clk_macb22(gate_clk_macb22),
        .isolate_macb22(isolate_macb22),
        .save_edge_macb22(save_edge_macb22),
        .restore_edge_macb22(restore_edge_macb22),
        .pwr1_on_macb22(pwr1_on_macb22),
        .pwr2_on_macb22(pwr2_on_macb22),
        // ETH32
        .rstn_non_srpg_macb32(rstn_non_srpg_macb32),
        .gate_clk_macb32(gate_clk_macb32),
        .isolate_macb32(isolate_macb32),
        .save_edge_macb32(save_edge_macb32),
        .restore_edge_macb32(restore_edge_macb32),
        .pwr1_on_macb32(pwr1_on_macb32),
        .pwr2_on_macb32(pwr2_on_macb32),
        .core06v2(core06v2),
        .core08v2(core08v2),
        .core10v2(core10v2),
        .core12v2(core12v2),
        .pcm_macb_wakeup_int2(pcm_macb_wakeup_int2),
        .isolate_mem2(isolate_mem2),
        .mte_smc_start2(mte_smc_start2),
        .mte_uart_start2(mte_uart_start2),
        .mte_smc_uart_start2(mte_smc_uart_start2),  
        .mte_pm_smc_to_default_start2(mte_pm_smc_to_default_start2), 
        .mte_pm_uart_to_default_start2(mte_pm_uart_to_default_start2),
        .mte_pm_smc_uart_to_default_start2(mte_pm_smc_uart_to_default_start2)
);

// Clock2 gating2 macro2 to shut2 off2 clocks2 to the SRPG2 flops2 in the SMC2
//CKLNQD12 i_SMC_SRPG_clk_gate2  (
//	.TE2(scan_mode2), 
//	.E2(~gate_clk_smc2), 
//	.CP2(pclk2), 
//	.Q2(pclk_SRPG_smc2)
//	);
// Replace2 gate2 with behavioural2 code2 //
wire 	smc_scan_gate2;
reg 	smc_latched_enable2;
assign smc_scan_gate2 = scan_mode2 ? 1'b1 : ~gate_clk_smc2;

always @ (pclk2 or smc_scan_gate2)
  	if (pclk2 == 1'b0) begin
  		smc_latched_enable2 <= smc_scan_gate2;
  	end  	
	
assign pclk_SRPG_smc2 = smc_latched_enable2 ? pclk2 : 1'b0;


// Clock2 gating2 macro2 to shut2 off2 clocks2 to the SRPG2 flops2 in the URT2
//CKLNQD12 i_URT_SRPG_clk_gate2  (
//	.TE2(scan_mode2), 
//	.E2(~gate_clk_urt2), 
//	.CP2(pclk2), 
//	.Q2(pclk_SRPG_urt2)
//	);
// Replace2 gate2 with behavioural2 code2 //
wire 	urt_scan_gate2;
reg 	urt_latched_enable2;
assign urt_scan_gate2 = scan_mode2 ? 1'b1 : ~gate_clk_urt2;

always @ (pclk2 or urt_scan_gate2)
  	if (pclk2 == 1'b0) begin
  		urt_latched_enable2 <= urt_scan_gate2;
  	end  	
	
assign pclk_SRPG_urt2 = urt_latched_enable2 ? pclk2 : 1'b0;

// ETH02
wire 	macb0_scan_gate2;
reg 	macb0_latched_enable2;
assign macb0_scan_gate2 = scan_mode2 ? 1'b1 : ~gate_clk_macb02;

always @ (pclk2 or macb0_scan_gate2)
  	if (pclk2 == 1'b0) begin
  		macb0_latched_enable2 <= macb0_scan_gate2;
  	end  	
	
assign clk_SRPG_macb0_en2 = macb0_latched_enable2 ? 1'b1 : 1'b0;

// ETH12
wire 	macb1_scan_gate2;
reg 	macb1_latched_enable2;
assign macb1_scan_gate2 = scan_mode2 ? 1'b1 : ~gate_clk_macb12;

always @ (pclk2 or macb1_scan_gate2)
  	if (pclk2 == 1'b0) begin
  		macb1_latched_enable2 <= macb1_scan_gate2;
  	end  	
	
assign clk_SRPG_macb1_en2 = macb1_latched_enable2 ? 1'b1 : 1'b0;

// ETH22
wire 	macb2_scan_gate2;
reg 	macb2_latched_enable2;
assign macb2_scan_gate2 = scan_mode2 ? 1'b1 : ~gate_clk_macb22;

always @ (pclk2 or macb2_scan_gate2)
  	if (pclk2 == 1'b0) begin
  		macb2_latched_enable2 <= macb2_scan_gate2;
  	end  	
	
assign clk_SRPG_macb2_en2 = macb2_latched_enable2 ? 1'b1 : 1'b0;

// ETH32
wire 	macb3_scan_gate2;
reg 	macb3_latched_enable2;
assign macb3_scan_gate2 = scan_mode2 ? 1'b1 : ~gate_clk_macb32;

always @ (pclk2 or macb3_scan_gate2)
  	if (pclk2 == 1'b0) begin
  		macb3_latched_enable2 <= macb3_scan_gate2;
  	end  	
	
assign clk_SRPG_macb3_en2 = macb3_latched_enable2 ? 1'b1 : 1'b0;



`else
//------------------------------------------------------------------------------
// if the APB2 subsystem2 is black2 boxed2 
//------------------------------------------------------------------------------
// wire s ports2
    // system signals2
    wire         hclk2;     // AHB2 Clock2
    wire         n_hreset2;  // AHB2 reset - Active2 low2
    wire         pclk2;     // APB2 Clock2. 
    wire         n_preset2;  // APB2 reset - Active2 low2

    // AHB2 interface
    wire         ahb2apb0_hsel2;     // AHB2APB2 select2
    wire  [31:0] haddr2;    // Address bus
    wire  [1:0]  htrans2;   // Transfer2 type
    wire  [2:0]  hsize2;    // AHB2 Access type - byte, half2-word2, word2
    wire  [31:0] hwdata2;   // Write data
    wire         hwrite2;   // Write signal2/
    wire         hready_in2;// Indicates2 that last master2 has finished2 bus access
    wire [2:0]   hburst2;     // Burst type
    wire [3:0]   hprot2;      // Protection2 control2
    wire [3:0]   hmaster2;    // Master2 select2
    wire         hmastlock2;  // Locked2 transfer2
  // Interrupts2 from the Enet2 MACs2
    wire         macb0_int2;
    wire         macb1_int2;
    wire         macb2_int2;
    wire         macb3_int2;
  // Interrupt2 from the DMA2
    wire         DMA_irq2;
  // Scan2 wire s
    wire         scan_en2;    // Scan2 enable pin2
    wire         scan_in_12;  // Scan2 wire  for first chain2
    wire         scan_in_22;  // Scan2 wire  for second chain2
    wire         scan_mode2;  // test mode pin2
 
  //wire  for smc2 AHB2 interface
    wire         smc_hclk2;
    wire         smc_n_hclk2;
    wire  [31:0] smc_haddr2;
    wire  [1:0]  smc_htrans2;
    wire         smc_hsel2;
    wire         smc_hwrite2;
    wire  [2:0]  smc_hsize2;
    wire  [31:0] smc_hwdata2;
    wire         smc_hready_in2;
    wire  [2:0]  smc_hburst2;     // Burst type
    wire  [3:0]  smc_hprot2;      // Protection2 control2
    wire  [3:0]  smc_hmaster2;    // Master2 select2
    wire         smc_hmastlock2;  // Locked2 transfer2


    wire  [31:0] data_smc2;     // EMI2(External2 memory) read data
    
  //wire s for uart2
    wire         ua_rxd2;       // UART2 receiver2 serial2 wire  pin2
    wire         ua_rxd12;      // UART2 receiver2 serial2 wire  pin2
    wire         ua_ncts2;      // Clear-To2-Send2 flow2 control2
    wire         ua_ncts12;      // Clear-To2-Send2 flow2 control2
   //wire s for spi2
    wire         n_ss_in2;      // select2 wire  to slave2
    wire         mi2;           // data wire  to master2
    wire         si2;           // data wire  to slave2
    wire         sclk_in2;      // clock2 wire  to slave2
  //wire s for GPIO2
   wire  [GPIO_WIDTH2-1:0]  gpio_pin_in2;             // wire  data from pin2

  //reg    ports2
  // Scan2 reg   s
   reg           scan_out_12;   // Scan2 out for chain2 1
   reg           scan_out_22;   // Scan2 out for chain2 2
  //AHB2 interface 
   reg    [31:0] hrdata2;       // Read data provided from target slave2
   reg           hready2;       // Ready2 for new bus cycle from target slave2
   reg    [1:0]  hresp2;       // Response2 from the bridge2

   // SMC2 reg    for AHB2 interface
   reg    [31:0]    smc_hrdata2;
   reg              smc_hready2;
   reg    [1:0]     smc_hresp2;

  //reg   s from smc2
   reg    [15:0]    smc_addr2;      // External2 Memory (EMI2) address
   reg    [3:0]     smc_n_be2;      // EMI2 byte enables2 (Active2 LOW2)
   reg    [7:0]     smc_n_cs2;      // EMI2 Chip2 Selects2 (Active2 LOW2)
   reg    [3:0]     smc_n_we2;      // EMI2 write strobes2 (Active2 LOW2)
   reg              smc_n_wr2;      // EMI2 write enable (Active2 LOW2)
   reg              smc_n_rd2;      // EMI2 read stobe2 (Active2 LOW2)
   reg              smc_n_ext_oe2;  // EMI2 write data reg    enable
   reg    [31:0]    smc_data2;      // EMI2 write data
  //reg   s from uart2
   reg           ua_txd2;       	// UART2 transmitter2 serial2 reg   
   reg           ua_txd12;       // UART2 transmitter2 serial2 reg   
   reg           ua_nrts2;      	// Request2-To2-Send2 flow2 control2
   reg           ua_nrts12;      // Request2-To2-Send2 flow2 control2
   // reg   s from ttc2
  // reg   s from SPI2
   reg       so;                    // data reg    from slave2
   reg       mo2;                    // data reg    from master2
   reg       sclk_out2;              // clock2 reg    from master2
   reg    [P_SIZE2-1:0] n_ss_out2;    // peripheral2 select2 lines2 from master2
   reg       n_so_en2;               // out enable for slave2 data
   reg       n_mo_en2;               // out enable for master2 data
   reg       n_sclk_en2;             // out enable for master2 clock2
   reg       n_ss_en2;               // out enable for master2 peripheral2 lines2
  //reg   s from gpio2
   reg    [GPIO_WIDTH2-1:0]     n_gpio_pin_oe2;           // reg    enable signal2 to pin2
   reg    [GPIO_WIDTH2-1:0]     gpio_pin_out2;            // reg    signal2 to pin2


`endif
//------------------------------------------------------------------------------
// black2 boxed2 defines2 
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// APB2 and AHB2 interface formal2 verification2 monitors2
//------------------------------------------------------------------------------
`ifdef ABV_ON2
apb_assert2 i_apb_assert2 (

        // APB2 signals2
  	.n_preset2(n_preset2),
   	.pclk2(pclk2),
	.penable2(penable2),
	.paddr2(paddr2),
	.pwrite2(pwrite2),
	.pwdata2(pwdata2),

	.psel002(psel_spi2),
	.psel012(psel_uart02),
	.psel022(psel_gpio2),
	.psel032(psel_ttc2),
	.psel042(1'b0),
	.psel052(psel_smc2),
	.psel062(1'b0),
	.psel072(1'b0),
	.psel082(1'b0),
	.psel092(1'b0),
	.psel102(1'b0),
	.psel112(1'b0),
	.psel122(1'b0),
	.psel132(psel_pmc2),
	.psel142(psel_apic2),
	.psel152(psel_uart12),

        .prdata002(prdata_spi2),
        .prdata012(prdata_uart02), // Read Data from peripheral2 UART2 
        .prdata022(prdata_gpio2), // Read Data from peripheral2 GPIO2
        .prdata032(prdata_ttc2), // Read Data from peripheral2 TTC2
        .prdata042(32'b0), // 
        .prdata052(prdata_smc2), // Read Data from peripheral2 SMC2
        .prdata132(prdata_pmc2), // Read Data from peripheral2 Power2 Control2 Block
   	.prdata142(32'b0), // 
        .prdata152(prdata_uart12),


        // AHB2 signals2
        .hclk2(hclk2),         // ahb2 system clock2
        .n_hreset2(n_hreset2), // ahb2 system reset

        // ahb2apb2 signals2
        .hresp2(hresp2),
        .hready2(hready2),
        .hrdata2(hrdata2),
        .hwdata2(hwdata2),
        .hprot2(hprot2),
        .hburst2(hburst2),
        .hsize2(hsize2),
        .hwrite2(hwrite2),
        .htrans2(htrans2),
        .haddr2(haddr2),
        .ahb2apb_hsel2(ahb2apb0_hsel2));



//------------------------------------------------------------------------------
// AHB2 interface formal2 verification2 monitor2
//------------------------------------------------------------------------------
defparam i_ahbSlaveMonitor2.DBUS_WIDTH2 = 32;
defparam i_ahbMasterMonitor2.DBUS_WIDTH2 = 32;


// AHB2APB2 Bridge2

    ahb_liteslave_monitor2 i_ahbSlaveMonitor2 (
        .hclk_i2(hclk2),
        .hresetn_i2(n_hreset2),
        .hresp2(hresp2),
        .hready2(hready2),
        .hready_global_i2(hready2),
        .hrdata2(hrdata2),
        .hwdata_i2(hwdata2),
        .hburst_i2(hburst2),
        .hsize_i2(hsize2),
        .hwrite_i2(hwrite2),
        .htrans_i2(htrans2),
        .haddr_i2(haddr2),
        .hsel_i2(ahb2apb0_hsel2)
    );


  ahb_litemaster_monitor2 i_ahbMasterMonitor2 (
          .hclk_i2(hclk2),
          .hresetn_i2(n_hreset2),
          .hresp_i2(hresp2),
          .hready_i2(hready2),
          .hrdata_i2(hrdata2),
          .hlock2(1'b0),
          .hwdata2(hwdata2),
          .hprot2(hprot2),
          .hburst2(hburst2),
          .hsize2(hsize2),
          .hwrite2(hwrite2),
          .htrans2(htrans2),
          .haddr2(haddr2)
          );







`endif




`ifdef IFV_LP_ABV_ON2
// power2 control2
wire isolate2;

// testbench mirror signals2
wire L1_ctrl_access2;
wire L1_status_access2;

wire [31:0] L1_status_reg2;
wire [31:0] L1_ctrl_reg2;

//wire rstn_non_srpg_urt2;
//wire isolate_urt2;
//wire retain_urt2;
//wire gate_clk_urt2;
//wire pwr1_on_urt2;


// smc2 signals2
wire [31:0] smc_prdata2;
wire lp_clk_smc2;
                    

// uart2 isolation2 register
  wire [15:0] ua_prdata2;
  wire ua_int2;
  assign ua_prdata2          =  i_uart1_veneer2.prdata2;
  assign ua_int2             =  i_uart1_veneer2.ua_int2;


assign lp_clk_smc2          = i_smc_veneer2.pclk2;
assign smc_prdata2          = i_smc_veneer2.prdata2;
lp_chk_smc2 u_lp_chk_smc2 (
    .clk2 (hclk2),
    .rst2 (n_hreset2),
    .iso_smc2 (isolate_smc2),
    .gate_clk2 (gate_clk_smc2),
    .lp_clk2 (pclk_SRPG_smc2),

    // srpg2 outputs2
    .smc_hrdata2 (smc_hrdata2),
    .smc_hready2 (smc_hready2),
    .smc_hresp2  (smc_hresp2),
    .smc_valid2 (smc_valid2),
    .smc_addr_int2 (smc_addr_int2),
    .smc_data2 (smc_data2),
    .smc_n_be2 (smc_n_be2),
    .smc_n_cs2  (smc_n_cs2),
    .smc_n_wr2 (smc_n_wr2),
    .smc_n_we2 (smc_n_we2),
    .smc_n_rd2 (smc_n_rd2),
    .smc_n_ext_oe2 (smc_n_ext_oe2)
   );

// lp2 retention2/isolation2 assertions2
lp_chk_uart2 u_lp_chk_urt2 (

  .clk2         (hclk2),
  .rst2         (n_hreset2),
  .iso_urt2     (isolate_urt2),
  .gate_clk2    (gate_clk_urt2),
  .lp_clk2      (pclk_SRPG_urt2),
  //ports2
  .prdata2 (ua_prdata2),
  .ua_int2 (ua_int2),
  .ua_txd2 (ua_txd12),
  .ua_nrts2 (ua_nrts12)
 );

`endif  //IFV_LP_ABV_ON2




endmodule
