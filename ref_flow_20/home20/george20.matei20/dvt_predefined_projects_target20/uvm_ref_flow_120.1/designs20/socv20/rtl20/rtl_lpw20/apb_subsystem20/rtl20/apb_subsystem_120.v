//File20 name   : apb_subsystem_120.v
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

module apb_subsystem_120(
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

    // APB20 interface
    pclk20,       
    n_preset20,  
    paddr20,
    pwrite20,
    penable20,
    pwdata20, 
    
    // MAC020 APB20 ports20
    prdata_mac020,
    psel_mac020,
    pready_mac020,
    
    // MAC120 APB20 ports20
    prdata_mac120,
    psel_mac120,
    pready_mac120,
    
    // MAC220 APB20 ports20
    prdata_mac220,
    psel_mac220,
    pready_mac220,
    
    // MAC320 APB20 ports20
    prdata_mac320,
    psel_mac320,
    pready_mac320
);

// AHB20 interface
input         hclk20;     
input         n_hreset20; 
input         hsel20;     
input [31:0]  haddr20;    
input [1:0]   htrans20;   
input [2:0]   hsize20;    
input [31:0]  hwdata20;   
input         hwrite20;   
input         hready_in20;
input [2:0]   hburst20;   
input [3:0]   hprot20;    
input [3:0]   hmaster20;  
input         hmastlock20;
output [31:0] hrdata20;
output        hready20;
output [1:0]  hresp20; 

// APB20 interface
input         pclk20;     
input         n_preset20; 
output [31:0] paddr20;
output   	    pwrite20;
output   	    penable20;
output [31:0] pwdata20;

// MAC020 APB20 ports20
input [31:0] prdata_mac020;
output	     psel_mac020;
input        pready_mac020;

// MAC120 APB20 ports20
input [31:0] prdata_mac120;
output	     psel_mac120;
input        pready_mac120;

// MAC220 APB20 ports20
input [31:0] prdata_mac220;
output	     psel_mac220;
input        pready_mac220;

// MAC320 APB20 ports20
input [31:0] prdata_mac320;
output	     psel_mac320;
input        pready_mac320;

wire  [31:0] prdata_alut20;

assign tie_hi_bit20 = 1'b1;

ahb2apb20 #(
  32'h00A00000, // Slave20 0 Address Range20
  32'h00A0FFFF,

  32'h00A10000, // Slave20 1 Address Range20
  32'h00A1FFFF,

  32'h00A20000, // Slave20 2 Address Range20 
  32'h00A2FFFF,

  32'h00A30000, // Slave20 3 Address Range20
  32'h00A3FFFF,

  32'h00A40000, // Slave20 4 Address Range20
  32'h00A4FFFF
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
    .prdata020(prdata_alut20),
    .prdata120(prdata_mac020), 
    .prdata220(prdata_mac120),  
    .prdata320(prdata_mac220),   
    .prdata420(prdata_mac320),   
    .prdata520(32'h0),   
    .prdata620(32'h0),    
    .prdata720(32'h0),   
    .prdata820(32'h0),  
    .pready020(tie_hi_bit20),     
    .pready120(pready_mac020),   
    .pready220(pready_mac120),     
    .pready320(pready_mac220),     
    .pready420(pready_mac320),     
    .pready520(tie_hi_bit20),     
    .pready620(tie_hi_bit20),     
    .pready720(tie_hi_bit20),     
    .pready820(tie_hi_bit20),  
    .pwdata20(pwdata20),       
    .pwrite20(pwrite20),       
    .paddr20(paddr20),        
    .psel020(psel_alut20),     
    .psel120(psel_mac020),   
    .psel220(psel_mac120),    
    .psel320(psel_mac220),     
    .psel420(psel_mac320),     
    .psel520(),     
    .psel620(),    
    .psel720(),   
    .psel820(),  
    .penable20(penable20)     
);

alut_veneer20 i_alut_veneer20 (
        //inputs20
        . n_p_reset20(n_preset20),
        . pclk20(pclk20),
        . psel20(psel_alut20),
        . penable20(penable20),
        . pwrite20(pwrite20),
        . paddr20(paddr20[6:0]),
        . pwdata20(pwdata20),

        //outputs20
        . prdata20(prdata_alut20)
);

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

  .psel0020(psel_alut20),
	.psel0120(psel_mac020),
	.psel0220(psel_mac120),
	.psel0320(psel_mac220),
	.psel0420(psel_mac320),
	.psel0520(psel0520),
	.psel0620(psel0620),
	.psel0720(psel0720),
	.psel0820(psel0820),
	.psel0920(psel0920),
	.psel1020(psel1020),
	.psel1120(psel1120),
	.psel1220(psel1220),
	.psel1320(psel1320),
	.psel1420(psel1420),
	.psel1520(psel1520),

   .prdata0020(prdata_alut20), // Read Data from peripheral20 ALUT20

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
   .ahb2apb_hsel20(ahb2apb1_hsel20));



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
        .hsel_i20(ahb2apb1_hsel20)
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




endmodule
