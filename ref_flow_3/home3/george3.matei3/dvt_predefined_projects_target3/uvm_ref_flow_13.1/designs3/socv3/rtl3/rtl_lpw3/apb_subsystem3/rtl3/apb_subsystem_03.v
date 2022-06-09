//File3 name   : apb_subsystem_03.v
//Title3       : 
//Created3     : 1999
//Description3 : 
//Notes3       : 
//----------------------------------------------------------------------
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------

module apb_subsystem_03(
    // AHB3 interface
    hclk3,
    n_hreset3,
    hsel3,
    haddr3,
    htrans3,
    hsize3,
    hwrite3,
    hwdata3,
    hready_in3,
    hburst3,
    hprot3,
    hmaster3,
    hmastlock3,
    hrdata3,
    hready3,
    hresp3,
    
    // APB3 system interface
    pclk3,
    n_preset3,
    
    // SPI3 ports3
    n_ss_in3,
    mi3,
    si3,
    sclk_in3,
    so,
    mo3,
    sclk_out3,
    n_ss_out3,
    n_so_en3,
    n_mo_en3,
    n_sclk_en3,
    n_ss_en3,
    
    //UART03 ports3
    ua_rxd3,
    ua_ncts3,
    ua_txd3,
    ua_nrts3,
    
    //UART13 ports3
    ua_rxd13,
    ua_ncts13,
    ua_txd13,
    ua_nrts13,
    
    //GPIO3 ports3
    gpio_pin_in3,
    n_gpio_pin_oe3,
    gpio_pin_out3,
    

    //SMC3 ports3
    smc_hclk3,
    smc_n_hclk3,
    smc_haddr3,
    smc_htrans3,
    smc_hsel3,
    smc_hwrite3,
    smc_hsize3,
    smc_hwdata3,
    smc_hready_in3,
    smc_hburst3,
    smc_hprot3,
    smc_hmaster3,
    smc_hmastlock3,
    smc_hrdata3, 
    smc_hready3,
    smc_hresp3,
    smc_n_ext_oe3,
    smc_data3,
    smc_addr3,
    smc_n_be3,
    smc_n_cs3, 
    smc_n_we3,
    smc_n_wr3,
    smc_n_rd3,
    data_smc3,
    
    //PMC3 ports3
    clk_SRPG_macb0_en3,
    clk_SRPG_macb1_en3,
    clk_SRPG_macb2_en3,
    clk_SRPG_macb3_en3,
    core06v3,
    core08v3,
    core10v3,
    core12v3,
    macb3_wakeup3,
    macb2_wakeup3,
    macb1_wakeup3,
    macb0_wakeup3,
    mte_smc_start3,
    mte_uart_start3,
    mte_smc_uart_start3,  
    mte_pm_smc_to_default_start3, 
    mte_pm_uart_to_default_start3,
    mte_pm_smc_uart_to_default_start3,
    
    
    // Peripheral3 inerrupts3
    pcm_irq3,
    ttc_irq3,
    gpio_irq3,
    uart0_irq3,
    uart1_irq3,
    spi_irq3,
    DMA_irq3,      
    macb0_int3,
    macb1_int3,
    macb2_int3,
    macb3_int3,
   
    // Scan3 ports3
    scan_en3,      // Scan3 enable pin3
    scan_in_13,    // Scan3 input for first chain3
    scan_in_23,    // Scan3 input for second chain3
    scan_mode3,
    scan_out_13,   // Scan3 out for chain3 1
    scan_out_23    // Scan3 out for chain3 2
);

parameter GPIO_WIDTH3 = 16;        // GPIO3 width
parameter P_SIZE3 =   8;              // number3 of peripheral3 select3 lines3
parameter NO_OF_IRQS3  = 17;      //No of irqs3 read by apic3 

// AHB3 interface
input         hclk3;     // AHB3 Clock3
input         n_hreset3;  // AHB3 reset - Active3 low3
input         hsel3;     // AHB2APB3 select3
input [31:0]  haddr3;    // Address bus
input [1:0]   htrans3;   // Transfer3 type
input [2:0]   hsize3;    // AHB3 Access type - byte, half3-word3, word3
input [31:0]  hwdata3;   // Write data
input         hwrite3;   // Write signal3/
input         hready_in3;// Indicates3 that last master3 has finished3 bus access
input [2:0]   hburst3;     // Burst type
input [3:0]   hprot3;      // Protection3 control3
input [3:0]   hmaster3;    // Master3 select3
input         hmastlock3;  // Locked3 transfer3
output [31:0] hrdata3;       // Read data provided from target slave3
output        hready3;       // Ready3 for new bus cycle from target slave3
output [1:0]  hresp3;       // Response3 from the bridge3
    
// APB3 system interface
input         pclk3;     // APB3 Clock3. 
input         n_preset3;  // APB3 reset - Active3 low3
   
// SPI3 ports3
input     n_ss_in3;      // select3 input to slave3
input     mi3;           // data input to master3
input     si3;           // data input to slave3
input     sclk_in3;      // clock3 input to slave3
output    so;                    // data output from slave3
output    mo3;                    // data output from master3
output    sclk_out3;              // clock3 output from master3
output [P_SIZE3-1:0] n_ss_out3;    // peripheral3 select3 lines3 from master3
output    n_so_en3;               // out enable for slave3 data
output    n_mo_en3;               // out enable for master3 data
output    n_sclk_en3;             // out enable for master3 clock3
output    n_ss_en3;               // out enable for master3 peripheral3 lines3

//UART03 ports3
input        ua_rxd3;       // UART3 receiver3 serial3 input pin3
input        ua_ncts3;      // Clear-To3-Send3 flow3 control3
output       ua_txd3;       	// UART3 transmitter3 serial3 output
output       ua_nrts3;      	// Request3-To3-Send3 flow3 control3

// UART13 ports3   
input        ua_rxd13;      // UART3 receiver3 serial3 input pin3
input        ua_ncts13;      // Clear-To3-Send3 flow3 control3
output       ua_txd13;       // UART3 transmitter3 serial3 output
output       ua_nrts13;      // Request3-To3-Send3 flow3 control3

//GPIO3 ports3
input [GPIO_WIDTH3-1:0]      gpio_pin_in3;             // input data from pin3
output [GPIO_WIDTH3-1:0]     n_gpio_pin_oe3;           // output enable signal3 to pin3
output [GPIO_WIDTH3-1:0]     gpio_pin_out3;            // output signal3 to pin3
  
//SMC3 ports3
input        smc_hclk3;
input        smc_n_hclk3;
input [31:0] smc_haddr3;
input [1:0]  smc_htrans3;
input        smc_hsel3;
input        smc_hwrite3;
input [2:0]  smc_hsize3;
input [31:0] smc_hwdata3;
input        smc_hready_in3;
input [2:0]  smc_hburst3;     // Burst type
input [3:0]  smc_hprot3;      // Protection3 control3
input [3:0]  smc_hmaster3;    // Master3 select3
input        smc_hmastlock3;  // Locked3 transfer3
input [31:0] data_smc3;     // EMI3(External3 memory) read data
output [31:0]    smc_hrdata3;
output           smc_hready3;
output [1:0]     smc_hresp3;
output [15:0]    smc_addr3;      // External3 Memory (EMI3) address
output [3:0]     smc_n_be3;      // EMI3 byte enables3 (Active3 LOW3)
output           smc_n_cs3;      // EMI3 Chip3 Selects3 (Active3 LOW3)
output [3:0]     smc_n_we3;      // EMI3 write strobes3 (Active3 LOW3)
output           smc_n_wr3;      // EMI3 write enable (Active3 LOW3)
output           smc_n_rd3;      // EMI3 read stobe3 (Active3 LOW3)
output           smc_n_ext_oe3;  // EMI3 write data output enable
output [31:0]    smc_data3;      // EMI3 write data
       
//PMC3 ports3
output clk_SRPG_macb0_en3;
output clk_SRPG_macb1_en3;
output clk_SRPG_macb2_en3;
output clk_SRPG_macb3_en3;
output core06v3;
output core08v3;
output core10v3;
output core12v3;
output mte_smc_start3;
output mte_uart_start3;
output mte_smc_uart_start3;  
output mte_pm_smc_to_default_start3; 
output mte_pm_uart_to_default_start3;
output mte_pm_smc_uart_to_default_start3;
input macb3_wakeup3;
input macb2_wakeup3;
input macb1_wakeup3;
input macb0_wakeup3;
    

// Peripheral3 interrupts3
output pcm_irq3;
output [2:0] ttc_irq3;
output gpio_irq3;
output uart0_irq3;
output uart1_irq3;
output spi_irq3;
input        macb0_int3;
input        macb1_int3;
input        macb2_int3;
input        macb3_int3;
input        DMA_irq3;
  
//Scan3 ports3
input        scan_en3;    // Scan3 enable pin3
input        scan_in_13;  // Scan3 input for first chain3
input        scan_in_23;  // Scan3 input for second chain3
input        scan_mode3;  // test mode pin3
 output        scan_out_13;   // Scan3 out for chain3 1
 output        scan_out_23;   // Scan3 out for chain3 2  

//------------------------------------------------------------------------------
// if the ROM3 subsystem3 is NOT3 black3 boxed3 
//------------------------------------------------------------------------------
`ifndef FV_KIT_BLACK_BOX_APB_SUBSYSTEM3
   
   wire        hsel3; 
   wire        pclk3;
   wire        n_preset3;
   wire [31:0] prdata_spi3;
   wire [31:0] prdata_uart03;
   wire [31:0] prdata_gpio3;
   wire [31:0] prdata_ttc3;
   wire [31:0] prdata_smc3;
   wire [31:0] prdata_pmc3;
   wire [31:0] prdata_uart13;
   wire        pready_spi3;
   wire        pready_uart03;
   wire        pready_uart13;
   wire        tie_hi_bit3;
   wire  [31:0] hrdata3; 
   wire         hready3;
   wire         hready_in3;
   wire  [1:0]  hresp3;   
   wire  [31:0] pwdata3;  
   wire         pwrite3;
   wire  [31:0] paddr3;  
   wire   psel_spi3;
   wire   psel_uart03;
   wire   psel_gpio3;
   wire   psel_ttc3;
   wire   psel_smc3;
   wire   psel073;
   wire   psel083;
   wire   psel093;
   wire   psel103;
   wire   psel113;
   wire   psel123;
   wire   psel_pmc3;
   wire   psel_uart13;
   wire   penable3;
   wire   [NO_OF_IRQS3:0] int_source3;     // System3 Interrupt3 Sources3
   wire [1:0]             smc_hresp3;     // AHB3 Response3 signal3
   wire                   smc_valid3;     // Ack3 valid address

  //External3 memory interface (EMI3)
  wire [31:0]            smc_addr_int3;  // External3 Memory (EMI3) address
  wire [3:0]             smc_n_be3;      // EMI3 byte enables3 (Active3 LOW3)
  wire                   smc_n_cs3;      // EMI3 Chip3 Selects3 (Active3 LOW3)
  wire [3:0]             smc_n_we3;      // EMI3 write strobes3 (Active3 LOW3)
  wire                   smc_n_wr3;      // EMI3 write enable (Active3 LOW3)
  wire                   smc_n_rd3;      // EMI3 read stobe3 (Active3 LOW3)
 
  //AHB3 Memory Interface3 Control3
  wire                   smc_hsel_int3;
  wire                   smc_busy3;      // smc3 busy
   

//scan3 signals3

   wire                scan_in_13;        //scan3 input
   wire                scan_in_23;        //scan3 input
   wire                scan_en3;         //scan3 enable
   wire                scan_out_13;       //scan3 output
   wire                scan_out_23;       //scan3 output
   wire                byte_sel3;     // byte select3 from bridge3 1=byte, 0=2byte
   wire                UART_int3;     // UART3 module interrupt3 
   wire                ua_uclken3;    // Soft3 control3 of clock3
   wire                UART_int13;     // UART3 module interrupt3 
   wire                ua_uclken13;    // Soft3 control3 of clock3
   wire  [3:1]         TTC_int3;            //Interrupt3 from PCI3 
  // inputs3 to SPI3 
   wire    ext_clk3;                // external3 clock3
   wire    SPI_int3;             // interrupt3 request
  // outputs3 from SPI3
   wire    slave_out_clk3;         // modified slave3 clock3 output
 // gpio3 generic3 inputs3 
   wire  [GPIO_WIDTH3-1:0]   n_gpio_bypass_oe3;        // bypass3 mode enable 
   wire  [GPIO_WIDTH3-1:0]   gpio_bypass_out3;         // bypass3 mode output value 
   wire  [GPIO_WIDTH3-1:0]   tri_state_enable3;   // disables3 op enable -> z 
 // outputs3 
   //amba3 outputs3 
   // gpio3 generic3 outputs3 
   wire       GPIO_int3;                // gpio_interupt3 for input pin3 change 
   wire [GPIO_WIDTH3-1:0]     gpio_bypass_in3;          // bypass3 mode input data value  
                
   wire           cpu_debug3;        // Inhibits3 watchdog3 counter 
   wire            ex_wdz_n3;         // External3 Watchdog3 zero indication3
   wire           rstn_non_srpg_smc3; 
   wire           rstn_non_srpg_urt3;
   wire           isolate_smc3;
   wire           save_edge_smc3;
   wire           restore_edge_smc3;
   wire           save_edge_urt3;
   wire           restore_edge_urt3;
   wire           pwr1_on_smc3;
   wire           pwr2_on_smc3;
   wire           pwr1_on_urt3;
   wire           pwr2_on_urt3;
   // ETH03
   wire            rstn_non_srpg_macb03;
   wire            gate_clk_macb03;
   wire            isolate_macb03;
   wire            save_edge_macb03;
   wire            restore_edge_macb03;
   wire            pwr1_on_macb03;
   wire            pwr2_on_macb03;
   // ETH13
   wire            rstn_non_srpg_macb13;
   wire            gate_clk_macb13;
   wire            isolate_macb13;
   wire            save_edge_macb13;
   wire            restore_edge_macb13;
   wire            pwr1_on_macb13;
   wire            pwr2_on_macb13;
   // ETH23
   wire            rstn_non_srpg_macb23;
   wire            gate_clk_macb23;
   wire            isolate_macb23;
   wire            save_edge_macb23;
   wire            restore_edge_macb23;
   wire            pwr1_on_macb23;
   wire            pwr2_on_macb23;
   // ETH33
   wire            rstn_non_srpg_macb33;
   wire            gate_clk_macb33;
   wire            isolate_macb33;
   wire            save_edge_macb33;
   wire            restore_edge_macb33;
   wire            pwr1_on_macb33;
   wire            pwr2_on_macb33;


   wire           pclk_SRPG_smc3;
   wire           pclk_SRPG_urt3;
   wire           gate_clk_smc3;
   wire           gate_clk_urt3;
   wire  [31:0]   tie_lo_32bit3; 
   wire  [1:0]	  tie_lo_2bit3;
   wire  	  tie_lo_1bit3;
   wire           pcm_macb_wakeup_int3;
   wire           int_source_h3;
   wire           isolate_mem3;

assign pcm_irq3 = pcm_macb_wakeup_int3;
assign ttc_irq3[2] = TTC_int3[3];
assign ttc_irq3[1] = TTC_int3[2];
assign ttc_irq3[0] = TTC_int3[1];
assign gpio_irq3 = GPIO_int3;
assign uart0_irq3 = UART_int3;
assign uart1_irq3 = UART_int13;
assign spi_irq3 = SPI_int3;

assign n_mo_en3   = 1'b0;
assign n_so_en3   = 1'b1;
assign n_sclk_en3 = 1'b0;
assign n_ss_en3   = 1'b0;

assign smc_hsel_int3 = smc_hsel3;
  assign ext_clk3  = 1'b0;
  assign int_source3 = {macb0_int3,macb1_int3, macb2_int3, macb3_int3,1'b0, pcm_macb_wakeup_int3, 1'b0, 1'b0, 1'b0, 1'b0, TTC_int3, GPIO_int3, UART_int3, UART_int13, SPI_int3, DMA_irq3};

  // interrupt3 even3 detect3 .
  // for sleep3 wake3 up -> any interrupt3 even3 and system not in hibernation3 (isolate_mem3 = 0)
  // for hibernate3 wake3 up -> gpio3 interrupt3 even3 and system in the hibernation3 (isolate_mem3 = 1)
  assign int_source_h3 =  ((|int_source3) && (!isolate_mem3)) || (isolate_mem3 && GPIO_int3) ;

  assign byte_sel3 = 1'b1;
  assign tie_hi_bit3 = 1'b1;

  assign smc_addr3 = smc_addr_int3[15:0];



  assign  n_gpio_bypass_oe3 = {GPIO_WIDTH3{1'b0}};        // bypass3 mode enable 
  assign  gpio_bypass_out3  = {GPIO_WIDTH3{1'b0}};
  assign  tri_state_enable3 = {GPIO_WIDTH3{1'b0}};
  assign  cpu_debug3 = 1'b0;
  assign  tie_lo_32bit3 = 32'b0;
  assign  tie_lo_2bit3  = 2'b0;
  assign  tie_lo_1bit3  = 1'b0;


ahb2apb3 #(
  32'h00800000, // Slave3 0 Address Range3
  32'h0080FFFF,

  32'h00810000, // Slave3 1 Address Range3
  32'h0081FFFF,

  32'h00820000, // Slave3 2 Address Range3 
  32'h0082FFFF,

  32'h00830000, // Slave3 3 Address Range3
  32'h0083FFFF,

  32'h00840000, // Slave3 4 Address Range3
  32'h0084FFFF,

  32'h00850000, // Slave3 5 Address Range3
  32'h0085FFFF,

  32'h00860000, // Slave3 6 Address Range3
  32'h0086FFFF,

  32'h00870000, // Slave3 7 Address Range3
  32'h0087FFFF,

  32'h00880000, // Slave3 8 Address Range3
  32'h0088FFFF
) i_ahb2apb3 (
     // AHB3 interface
    .hclk3(hclk3),         
    .hreset_n3(n_hreset3), 
    .hsel3(hsel3), 
    .haddr3(haddr3),        
    .htrans3(htrans3),       
    .hwrite3(hwrite3),       
    .hwdata3(hwdata3),       
    .hrdata3(hrdata3),   
    .hready3(hready3),   
    .hresp3(hresp3),     
    
     // APB3 interface
    .pclk3(pclk3),         
    .preset_n3(n_preset3),  
    .prdata03(prdata_spi3),
    .prdata13(prdata_uart03), 
    .prdata23(prdata_gpio3),  
    .prdata33(prdata_ttc3),   
    .prdata43(32'h0),   
    .prdata53(prdata_smc3),   
    .prdata63(prdata_pmc3),    
    .prdata73(32'h0),   
    .prdata83(prdata_uart13),  
    .pready03(pready_spi3),     
    .pready13(pready_uart03),   
    .pready23(tie_hi_bit3),     
    .pready33(tie_hi_bit3),     
    .pready43(tie_hi_bit3),     
    .pready53(tie_hi_bit3),     
    .pready63(tie_hi_bit3),     
    .pready73(tie_hi_bit3),     
    .pready83(pready_uart13),  
    .pwdata3(pwdata3),       
    .pwrite3(pwrite3),       
    .paddr3(paddr3),        
    .psel03(psel_spi3),     
    .psel13(psel_uart03),   
    .psel23(psel_gpio3),    
    .psel33(psel_ttc3),     
    .psel43(),     
    .psel53(psel_smc3),     
    .psel63(psel_pmc3),    
    .psel73(psel_apic3),   
    .psel83(psel_uart13),  
    .penable3(penable3)     
);

spi_top3 i_spi3
(
  // Wishbone3 signals3
  .wb_clk_i3(pclk3), 
  .wb_rst_i3(~n_preset3), 
  .wb_adr_i3(paddr3[4:0]), 
  .wb_dat_i3(pwdata3), 
  .wb_dat_o3(prdata_spi3), 
  .wb_sel_i3(4'b1111),    // SPI3 register accesses are always 32-bit
  .wb_we_i3(pwrite3), 
  .wb_stb_i3(psel_spi3), 
  .wb_cyc_i3(psel_spi3), 
  .wb_ack_o3(pready_spi3), 
  .wb_err_o3(), 
  .wb_int_o3(SPI_int3),

  // SPI3 signals3
  .ss_pad_o3(n_ss_out3), 
  .sclk_pad_o3(sclk_out3), 
  .mosi_pad_o3(mo3), 
  .miso_pad_i3(mi3)
);

// Opencores3 UART3 instances3
wire ua_nrts_int3;
wire ua_nrts1_int3;

assign ua_nrts3 = ua_nrts_int3;
assign ua_nrts13 = ua_nrts1_int3;

reg [3:0] uart0_sel_i3;
reg [3:0] uart1_sel_i3;
// UART3 registers are all 8-bit wide3, and their3 addresses3
// are on byte boundaries3. So3 to access them3 on the
// Wishbone3 bus, the CPU3 must do byte accesses to these3
// byte addresses3. Word3 address accesses are not possible3
// because the word3 addresses3 will be unaligned3, and cause
// a fault3.
// So3, Uart3 accesses from the CPU3 will always be 8-bit size
// We3 only have to decide3 which byte of the 4-byte word3 the
// CPU3 is interested3 in.
`ifdef SYSTEM_BIG_ENDIAN3
always @(paddr3) begin
  case (paddr3[1:0])
    2'b00 : uart0_sel_i3 = 4'b1000;
    2'b01 : uart0_sel_i3 = 4'b0100;
    2'b10 : uart0_sel_i3 = 4'b0010;
    2'b11 : uart0_sel_i3 = 4'b0001;
  endcase
end
always @(paddr3) begin
  case (paddr3[1:0])
    2'b00 : uart1_sel_i3 = 4'b1000;
    2'b01 : uart1_sel_i3 = 4'b0100;
    2'b10 : uart1_sel_i3 = 4'b0010;
    2'b11 : uart1_sel_i3 = 4'b0001;
  endcase
end
`else
always @(paddr3) begin
  case (paddr3[1:0])
    2'b00 : uart0_sel_i3 = 4'b0001;
    2'b01 : uart0_sel_i3 = 4'b0010;
    2'b10 : uart0_sel_i3 = 4'b0100;
    2'b11 : uart0_sel_i3 = 4'b1000;
  endcase
end
always @(paddr3) begin
  case (paddr3[1:0])
    2'b00 : uart1_sel_i3 = 4'b0001;
    2'b01 : uart1_sel_i3 = 4'b0010;
    2'b10 : uart1_sel_i3 = 4'b0100;
    2'b11 : uart1_sel_i3 = 4'b1000;
  endcase
end
`endif

uart_top3 i_oc_uart03 (
  .wb_clk_i3(pclk3),
  .wb_rst_i3(~n_preset3),
  .wb_adr_i3(paddr3[4:0]),
  .wb_dat_i3(pwdata3),
  .wb_dat_o3(prdata_uart03),
  .wb_we_i3(pwrite3),
  .wb_stb_i3(psel_uart03),
  .wb_cyc_i3(psel_uart03),
  .wb_ack_o3(pready_uart03),
  .wb_sel_i3(uart0_sel_i3),
  .int_o3(UART_int3),
  .stx_pad_o3(ua_txd3),
  .srx_pad_i3(ua_rxd3),
  .rts_pad_o3(ua_nrts_int3),
  .cts_pad_i3(ua_ncts3),
  .dtr_pad_o3(),
  .dsr_pad_i3(1'b0),
  .ri_pad_i3(1'b0),
  .dcd_pad_i3(1'b0)
);

uart_top3 i_oc_uart13 (
  .wb_clk_i3(pclk3),
  .wb_rst_i3(~n_preset3),
  .wb_adr_i3(paddr3[4:0]),
  .wb_dat_i3(pwdata3),
  .wb_dat_o3(prdata_uart13),
  .wb_we_i3(pwrite3),
  .wb_stb_i3(psel_uart13),
  .wb_cyc_i3(psel_uart13),
  .wb_ack_o3(pready_uart13),
  .wb_sel_i3(uart1_sel_i3),
  .int_o3(UART_int13),
  .stx_pad_o3(ua_txd13),
  .srx_pad_i3(ua_rxd13),
  .rts_pad_o3(ua_nrts1_int3),
  .cts_pad_i3(ua_ncts13),
  .dtr_pad_o3(),
  .dsr_pad_i3(1'b0),
  .ri_pad_i3(1'b0),
  .dcd_pad_i3(1'b0)
);

gpio_veneer3 i_gpio_veneer3 (
        //inputs3

        . n_p_reset3(n_preset3),
        . pclk3(pclk3),
        . psel3(psel_gpio3),
        . penable3(penable3),
        . pwrite3(pwrite3),
        . paddr3(paddr3[5:0]),
        . pwdata3(pwdata3),
        . gpio_pin_in3(gpio_pin_in3),
        . scan_en3(scan_en3),
        . tri_state_enable3(tri_state_enable3),
        . scan_in3(), //added by smarkov3 for dft3

        //outputs3
        . scan_out3(), //added by smarkov3 for dft3
        . prdata3(prdata_gpio3),
        . gpio_int3(GPIO_int3),
        . n_gpio_pin_oe3(n_gpio_pin_oe3),
        . gpio_pin_out3(gpio_pin_out3)
);


ttc_veneer3 i_ttc_veneer3 (

         //inputs3
        . n_p_reset3(n_preset3),
        . pclk3(pclk3),
        . psel3(psel_ttc3),
        . penable3(penable3),
        . pwrite3(pwrite3),
        . pwdata3(pwdata3),
        . paddr3(paddr3[7:0]),
        . scan_in3(),
        . scan_en3(scan_en3),

        //outputs3
        . prdata3(prdata_ttc3),
        . interrupt3(TTC_int3[3:1]),
        . scan_out3()
);


smc_veneer3 i_smc_veneer3 (
        //inputs3
	//apb3 inputs3
        . n_preset3(n_preset3),
        . pclk3(pclk_SRPG_smc3),
        . psel3(psel_smc3),
        . penable3(penable3),
        . pwrite3(pwrite3),
        . paddr3(paddr3[4:0]),
        . pwdata3(pwdata3),
        //ahb3 inputs3
	. hclk3(smc_hclk3),
        . n_sys_reset3(rstn_non_srpg_smc3),
        . haddr3(smc_haddr3),
        . htrans3(smc_htrans3),
        . hsel3(smc_hsel_int3),
        . hwrite3(smc_hwrite3),
	. hsize3(smc_hsize3),
        . hwdata3(smc_hwdata3),
        . hready3(smc_hready_in3),
        . data_smc3(data_smc3),

         //test signal3 inputs3

        . scan_in_13(),
        . scan_in_23(),
        . scan_in_33(),
        . scan_en3(scan_en3),

        //apb3 outputs3
        . prdata3(prdata_smc3),

       //design output

        . smc_hrdata3(smc_hrdata3),
        . smc_hready3(smc_hready3),
        . smc_hresp3(smc_hresp3),
        . smc_valid3(smc_valid3),
        . smc_addr3(smc_addr_int3),
        . smc_data3(smc_data3),
        . smc_n_be3(smc_n_be3),
        . smc_n_cs3(smc_n_cs3),
        . smc_n_wr3(smc_n_wr3),
        . smc_n_we3(smc_n_we3),
        . smc_n_rd3(smc_n_rd3),
        . smc_n_ext_oe3(smc_n_ext_oe3),
        . smc_busy3(smc_busy3),

         //test signal3 output
        . scan_out_13(),
        . scan_out_23(),
        . scan_out_33()
);

power_ctrl_veneer3 i_power_ctrl_veneer3 (
    // -- Clocks3 & Reset3
    	.pclk3(pclk3), 			//  : in  std_logic3;
    	.nprst3(n_preset3), 		//  : in  std_logic3;
    // -- APB3 programming3 interface
    	.paddr3(paddr3), 			//  : in  std_logic_vector3(31 downto3 0);
    	.psel3(psel_pmc3), 			//  : in  std_logic3;
    	.penable3(penable3), 		//  : in  std_logic3;
    	.pwrite3(pwrite3), 		//  : in  std_logic3;
    	.pwdata3(pwdata3), 		//  : in  std_logic_vector3(31 downto3 0);
    	.prdata3(prdata_pmc3), 		//  : out std_logic_vector3(31 downto3 0);
        .macb3_wakeup3(macb3_wakeup3),
        .macb2_wakeup3(macb2_wakeup3),
        .macb1_wakeup3(macb1_wakeup3),
        .macb0_wakeup3(macb0_wakeup3),
    // -- Module3 control3 outputs3
    	.scan_in3(),			//  : in  std_logic3;
    	.scan_en3(scan_en3),             	//  : in  std_logic3;
    	.scan_mode3(scan_mode3),          //  : in  std_logic3;
    	.scan_out3(),            	//  : out std_logic3;
        .int_source_h3(int_source_h3),
     	.rstn_non_srpg_smc3(rstn_non_srpg_smc3), 		//   : out std_logic3;
    	.gate_clk_smc3(gate_clk_smc3), 	//  : out std_logic3;
    	.isolate_smc3(isolate_smc3), 	//  : out std_logic3;
    	.save_edge_smc3(save_edge_smc3), 	//  : out std_logic3;
    	.restore_edge_smc3(restore_edge_smc3), 	//  : out std_logic3;
    	.pwr1_on_smc3(pwr1_on_smc3), 	//  : out std_logic3;
    	.pwr2_on_smc3(pwr2_on_smc3), 	//  : out std_logic3
     	.rstn_non_srpg_urt3(rstn_non_srpg_urt3), 		//   : out std_logic3;
    	.gate_clk_urt3(gate_clk_urt3), 	//  : out std_logic3;
    	.isolate_urt3(isolate_urt3), 	//  : out std_logic3;
    	.save_edge_urt3(save_edge_urt3), 	//  : out std_logic3;
    	.restore_edge_urt3(restore_edge_urt3), 	//  : out std_logic3;
    	.pwr1_on_urt3(pwr1_on_urt3), 	//  : out std_logic3;
    	.pwr2_on_urt3(pwr2_on_urt3),  	//  : out std_logic3
        // ETH03
        .rstn_non_srpg_macb03(rstn_non_srpg_macb03),
        .gate_clk_macb03(gate_clk_macb03),
        .isolate_macb03(isolate_macb03),
        .save_edge_macb03(save_edge_macb03),
        .restore_edge_macb03(restore_edge_macb03),
        .pwr1_on_macb03(pwr1_on_macb03),
        .pwr2_on_macb03(pwr2_on_macb03),
        // ETH13
        .rstn_non_srpg_macb13(rstn_non_srpg_macb13),
        .gate_clk_macb13(gate_clk_macb13),
        .isolate_macb13(isolate_macb13),
        .save_edge_macb13(save_edge_macb13),
        .restore_edge_macb13(restore_edge_macb13),
        .pwr1_on_macb13(pwr1_on_macb13),
        .pwr2_on_macb13(pwr2_on_macb13),
        // ETH23
        .rstn_non_srpg_macb23(rstn_non_srpg_macb23),
        .gate_clk_macb23(gate_clk_macb23),
        .isolate_macb23(isolate_macb23),
        .save_edge_macb23(save_edge_macb23),
        .restore_edge_macb23(restore_edge_macb23),
        .pwr1_on_macb23(pwr1_on_macb23),
        .pwr2_on_macb23(pwr2_on_macb23),
        // ETH33
        .rstn_non_srpg_macb33(rstn_non_srpg_macb33),
        .gate_clk_macb33(gate_clk_macb33),
        .isolate_macb33(isolate_macb33),
        .save_edge_macb33(save_edge_macb33),
        .restore_edge_macb33(restore_edge_macb33),
        .pwr1_on_macb33(pwr1_on_macb33),
        .pwr2_on_macb33(pwr2_on_macb33),
        .core06v3(core06v3),
        .core08v3(core08v3),
        .core10v3(core10v3),
        .core12v3(core12v3),
        .pcm_macb_wakeup_int3(pcm_macb_wakeup_int3),
        .isolate_mem3(isolate_mem3),
        .mte_smc_start3(mte_smc_start3),
        .mte_uart_start3(mte_uart_start3),
        .mte_smc_uart_start3(mte_smc_uart_start3),  
        .mte_pm_smc_to_default_start3(mte_pm_smc_to_default_start3), 
        .mte_pm_uart_to_default_start3(mte_pm_uart_to_default_start3),
        .mte_pm_smc_uart_to_default_start3(mte_pm_smc_uart_to_default_start3)
);

// Clock3 gating3 macro3 to shut3 off3 clocks3 to the SRPG3 flops3 in the SMC3
//CKLNQD13 i_SMC_SRPG_clk_gate3  (
//	.TE3(scan_mode3), 
//	.E3(~gate_clk_smc3), 
//	.CP3(pclk3), 
//	.Q3(pclk_SRPG_smc3)
//	);
// Replace3 gate3 with behavioural3 code3 //
wire 	smc_scan_gate3;
reg 	smc_latched_enable3;
assign smc_scan_gate3 = scan_mode3 ? 1'b1 : ~gate_clk_smc3;

always @ (pclk3 or smc_scan_gate3)
  	if (pclk3 == 1'b0) begin
  		smc_latched_enable3 <= smc_scan_gate3;
  	end  	
	
assign pclk_SRPG_smc3 = smc_latched_enable3 ? pclk3 : 1'b0;


// Clock3 gating3 macro3 to shut3 off3 clocks3 to the SRPG3 flops3 in the URT3
//CKLNQD13 i_URT_SRPG_clk_gate3  (
//	.TE3(scan_mode3), 
//	.E3(~gate_clk_urt3), 
//	.CP3(pclk3), 
//	.Q3(pclk_SRPG_urt3)
//	);
// Replace3 gate3 with behavioural3 code3 //
wire 	urt_scan_gate3;
reg 	urt_latched_enable3;
assign urt_scan_gate3 = scan_mode3 ? 1'b1 : ~gate_clk_urt3;

always @ (pclk3 or urt_scan_gate3)
  	if (pclk3 == 1'b0) begin
  		urt_latched_enable3 <= urt_scan_gate3;
  	end  	
	
assign pclk_SRPG_urt3 = urt_latched_enable3 ? pclk3 : 1'b0;

// ETH03
wire 	macb0_scan_gate3;
reg 	macb0_latched_enable3;
assign macb0_scan_gate3 = scan_mode3 ? 1'b1 : ~gate_clk_macb03;

always @ (pclk3 or macb0_scan_gate3)
  	if (pclk3 == 1'b0) begin
  		macb0_latched_enable3 <= macb0_scan_gate3;
  	end  	
	
assign clk_SRPG_macb0_en3 = macb0_latched_enable3 ? 1'b1 : 1'b0;

// ETH13
wire 	macb1_scan_gate3;
reg 	macb1_latched_enable3;
assign macb1_scan_gate3 = scan_mode3 ? 1'b1 : ~gate_clk_macb13;

always @ (pclk3 or macb1_scan_gate3)
  	if (pclk3 == 1'b0) begin
  		macb1_latched_enable3 <= macb1_scan_gate3;
  	end  	
	
assign clk_SRPG_macb1_en3 = macb1_latched_enable3 ? 1'b1 : 1'b0;

// ETH23
wire 	macb2_scan_gate3;
reg 	macb2_latched_enable3;
assign macb2_scan_gate3 = scan_mode3 ? 1'b1 : ~gate_clk_macb23;

always @ (pclk3 or macb2_scan_gate3)
  	if (pclk3 == 1'b0) begin
  		macb2_latched_enable3 <= macb2_scan_gate3;
  	end  	
	
assign clk_SRPG_macb2_en3 = macb2_latched_enable3 ? 1'b1 : 1'b0;

// ETH33
wire 	macb3_scan_gate3;
reg 	macb3_latched_enable3;
assign macb3_scan_gate3 = scan_mode3 ? 1'b1 : ~gate_clk_macb33;

always @ (pclk3 or macb3_scan_gate3)
  	if (pclk3 == 1'b0) begin
  		macb3_latched_enable3 <= macb3_scan_gate3;
  	end  	
	
assign clk_SRPG_macb3_en3 = macb3_latched_enable3 ? 1'b1 : 1'b0;



`else
//------------------------------------------------------------------------------
// if the APB3 subsystem3 is black3 boxed3 
//------------------------------------------------------------------------------
// wire s ports3
    // system signals3
    wire         hclk3;     // AHB3 Clock3
    wire         n_hreset3;  // AHB3 reset - Active3 low3
    wire         pclk3;     // APB3 Clock3. 
    wire         n_preset3;  // APB3 reset - Active3 low3

    // AHB3 interface
    wire         ahb2apb0_hsel3;     // AHB2APB3 select3
    wire  [31:0] haddr3;    // Address bus
    wire  [1:0]  htrans3;   // Transfer3 type
    wire  [2:0]  hsize3;    // AHB3 Access type - byte, half3-word3, word3
    wire  [31:0] hwdata3;   // Write data
    wire         hwrite3;   // Write signal3/
    wire         hready_in3;// Indicates3 that last master3 has finished3 bus access
    wire [2:0]   hburst3;     // Burst type
    wire [3:0]   hprot3;      // Protection3 control3
    wire [3:0]   hmaster3;    // Master3 select3
    wire         hmastlock3;  // Locked3 transfer3
  // Interrupts3 from the Enet3 MACs3
    wire         macb0_int3;
    wire         macb1_int3;
    wire         macb2_int3;
    wire         macb3_int3;
  // Interrupt3 from the DMA3
    wire         DMA_irq3;
  // Scan3 wire s
    wire         scan_en3;    // Scan3 enable pin3
    wire         scan_in_13;  // Scan3 wire  for first chain3
    wire         scan_in_23;  // Scan3 wire  for second chain3
    wire         scan_mode3;  // test mode pin3
 
  //wire  for smc3 AHB3 interface
    wire         smc_hclk3;
    wire         smc_n_hclk3;
    wire  [31:0] smc_haddr3;
    wire  [1:0]  smc_htrans3;
    wire         smc_hsel3;
    wire         smc_hwrite3;
    wire  [2:0]  smc_hsize3;
    wire  [31:0] smc_hwdata3;
    wire         smc_hready_in3;
    wire  [2:0]  smc_hburst3;     // Burst type
    wire  [3:0]  smc_hprot3;      // Protection3 control3
    wire  [3:0]  smc_hmaster3;    // Master3 select3
    wire         smc_hmastlock3;  // Locked3 transfer3


    wire  [31:0] data_smc3;     // EMI3(External3 memory) read data
    
  //wire s for uart3
    wire         ua_rxd3;       // UART3 receiver3 serial3 wire  pin3
    wire         ua_rxd13;      // UART3 receiver3 serial3 wire  pin3
    wire         ua_ncts3;      // Clear-To3-Send3 flow3 control3
    wire         ua_ncts13;      // Clear-To3-Send3 flow3 control3
   //wire s for spi3
    wire         n_ss_in3;      // select3 wire  to slave3
    wire         mi3;           // data wire  to master3
    wire         si3;           // data wire  to slave3
    wire         sclk_in3;      // clock3 wire  to slave3
  //wire s for GPIO3
   wire  [GPIO_WIDTH3-1:0]  gpio_pin_in3;             // wire  data from pin3

  //reg    ports3
  // Scan3 reg   s
   reg           scan_out_13;   // Scan3 out for chain3 1
   reg           scan_out_23;   // Scan3 out for chain3 2
  //AHB3 interface 
   reg    [31:0] hrdata3;       // Read data provided from target slave3
   reg           hready3;       // Ready3 for new bus cycle from target slave3
   reg    [1:0]  hresp3;       // Response3 from the bridge3

   // SMC3 reg    for AHB3 interface
   reg    [31:0]    smc_hrdata3;
   reg              smc_hready3;
   reg    [1:0]     smc_hresp3;

  //reg   s from smc3
   reg    [15:0]    smc_addr3;      // External3 Memory (EMI3) address
   reg    [3:0]     smc_n_be3;      // EMI3 byte enables3 (Active3 LOW3)
   reg    [7:0]     smc_n_cs3;      // EMI3 Chip3 Selects3 (Active3 LOW3)
   reg    [3:0]     smc_n_we3;      // EMI3 write strobes3 (Active3 LOW3)
   reg              smc_n_wr3;      // EMI3 write enable (Active3 LOW3)
   reg              smc_n_rd3;      // EMI3 read stobe3 (Active3 LOW3)
   reg              smc_n_ext_oe3;  // EMI3 write data reg    enable
   reg    [31:0]    smc_data3;      // EMI3 write data
  //reg   s from uart3
   reg           ua_txd3;       	// UART3 transmitter3 serial3 reg   
   reg           ua_txd13;       // UART3 transmitter3 serial3 reg   
   reg           ua_nrts3;      	// Request3-To3-Send3 flow3 control3
   reg           ua_nrts13;      // Request3-To3-Send3 flow3 control3
   // reg   s from ttc3
  // reg   s from SPI3
   reg       so;                    // data reg    from slave3
   reg       mo3;                    // data reg    from master3
   reg       sclk_out3;              // clock3 reg    from master3
   reg    [P_SIZE3-1:0] n_ss_out3;    // peripheral3 select3 lines3 from master3
   reg       n_so_en3;               // out enable for slave3 data
   reg       n_mo_en3;               // out enable for master3 data
   reg       n_sclk_en3;             // out enable for master3 clock3
   reg       n_ss_en3;               // out enable for master3 peripheral3 lines3
  //reg   s from gpio3
   reg    [GPIO_WIDTH3-1:0]     n_gpio_pin_oe3;           // reg    enable signal3 to pin3
   reg    [GPIO_WIDTH3-1:0]     gpio_pin_out3;            // reg    signal3 to pin3


`endif
//------------------------------------------------------------------------------
// black3 boxed3 defines3 
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// APB3 and AHB3 interface formal3 verification3 monitors3
//------------------------------------------------------------------------------
`ifdef ABV_ON3
apb_assert3 i_apb_assert3 (

        // APB3 signals3
  	.n_preset3(n_preset3),
   	.pclk3(pclk3),
	.penable3(penable3),
	.paddr3(paddr3),
	.pwrite3(pwrite3),
	.pwdata3(pwdata3),

	.psel003(psel_spi3),
	.psel013(psel_uart03),
	.psel023(psel_gpio3),
	.psel033(psel_ttc3),
	.psel043(1'b0),
	.psel053(psel_smc3),
	.psel063(1'b0),
	.psel073(1'b0),
	.psel083(1'b0),
	.psel093(1'b0),
	.psel103(1'b0),
	.psel113(1'b0),
	.psel123(1'b0),
	.psel133(psel_pmc3),
	.psel143(psel_apic3),
	.psel153(psel_uart13),

        .prdata003(prdata_spi3),
        .prdata013(prdata_uart03), // Read Data from peripheral3 UART3 
        .prdata023(prdata_gpio3), // Read Data from peripheral3 GPIO3
        .prdata033(prdata_ttc3), // Read Data from peripheral3 TTC3
        .prdata043(32'b0), // 
        .prdata053(prdata_smc3), // Read Data from peripheral3 SMC3
        .prdata133(prdata_pmc3), // Read Data from peripheral3 Power3 Control3 Block
   	.prdata143(32'b0), // 
        .prdata153(prdata_uart13),


        // AHB3 signals3
        .hclk3(hclk3),         // ahb3 system clock3
        .n_hreset3(n_hreset3), // ahb3 system reset

        // ahb2apb3 signals3
        .hresp3(hresp3),
        .hready3(hready3),
        .hrdata3(hrdata3),
        .hwdata3(hwdata3),
        .hprot3(hprot3),
        .hburst3(hburst3),
        .hsize3(hsize3),
        .hwrite3(hwrite3),
        .htrans3(htrans3),
        .haddr3(haddr3),
        .ahb2apb_hsel3(ahb2apb0_hsel3));



//------------------------------------------------------------------------------
// AHB3 interface formal3 verification3 monitor3
//------------------------------------------------------------------------------
defparam i_ahbSlaveMonitor3.DBUS_WIDTH3 = 32;
defparam i_ahbMasterMonitor3.DBUS_WIDTH3 = 32;


// AHB2APB3 Bridge3

    ahb_liteslave_monitor3 i_ahbSlaveMonitor3 (
        .hclk_i3(hclk3),
        .hresetn_i3(n_hreset3),
        .hresp3(hresp3),
        .hready3(hready3),
        .hready_global_i3(hready3),
        .hrdata3(hrdata3),
        .hwdata_i3(hwdata3),
        .hburst_i3(hburst3),
        .hsize_i3(hsize3),
        .hwrite_i3(hwrite3),
        .htrans_i3(htrans3),
        .haddr_i3(haddr3),
        .hsel_i3(ahb2apb0_hsel3)
    );


  ahb_litemaster_monitor3 i_ahbMasterMonitor3 (
          .hclk_i3(hclk3),
          .hresetn_i3(n_hreset3),
          .hresp_i3(hresp3),
          .hready_i3(hready3),
          .hrdata_i3(hrdata3),
          .hlock3(1'b0),
          .hwdata3(hwdata3),
          .hprot3(hprot3),
          .hburst3(hburst3),
          .hsize3(hsize3),
          .hwrite3(hwrite3),
          .htrans3(htrans3),
          .haddr3(haddr3)
          );







`endif




`ifdef IFV_LP_ABV_ON3
// power3 control3
wire isolate3;

// testbench mirror signals3
wire L1_ctrl_access3;
wire L1_status_access3;

wire [31:0] L1_status_reg3;
wire [31:0] L1_ctrl_reg3;

//wire rstn_non_srpg_urt3;
//wire isolate_urt3;
//wire retain_urt3;
//wire gate_clk_urt3;
//wire pwr1_on_urt3;


// smc3 signals3
wire [31:0] smc_prdata3;
wire lp_clk_smc3;
                    

// uart3 isolation3 register
  wire [15:0] ua_prdata3;
  wire ua_int3;
  assign ua_prdata3          =  i_uart1_veneer3.prdata3;
  assign ua_int3             =  i_uart1_veneer3.ua_int3;


assign lp_clk_smc3          = i_smc_veneer3.pclk3;
assign smc_prdata3          = i_smc_veneer3.prdata3;
lp_chk_smc3 u_lp_chk_smc3 (
    .clk3 (hclk3),
    .rst3 (n_hreset3),
    .iso_smc3 (isolate_smc3),
    .gate_clk3 (gate_clk_smc3),
    .lp_clk3 (pclk_SRPG_smc3),

    // srpg3 outputs3
    .smc_hrdata3 (smc_hrdata3),
    .smc_hready3 (smc_hready3),
    .smc_hresp3  (smc_hresp3),
    .smc_valid3 (smc_valid3),
    .smc_addr_int3 (smc_addr_int3),
    .smc_data3 (smc_data3),
    .smc_n_be3 (smc_n_be3),
    .smc_n_cs3  (smc_n_cs3),
    .smc_n_wr3 (smc_n_wr3),
    .smc_n_we3 (smc_n_we3),
    .smc_n_rd3 (smc_n_rd3),
    .smc_n_ext_oe3 (smc_n_ext_oe3)
   );

// lp3 retention3/isolation3 assertions3
lp_chk_uart3 u_lp_chk_urt3 (

  .clk3         (hclk3),
  .rst3         (n_hreset3),
  .iso_urt3     (isolate_urt3),
  .gate_clk3    (gate_clk_urt3),
  .lp_clk3      (pclk_SRPG_urt3),
  //ports3
  .prdata3 (ua_prdata3),
  .ua_int3 (ua_int3),
  .ua_txd3 (ua_txd13),
  .ua_nrts3 (ua_nrts13)
 );

`endif  //IFV_LP_ABV_ON3




endmodule
