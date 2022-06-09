//File7 name   : apb_subsystem_17.v
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

module apb_subsystem_17(
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

    // APB7 interface
    pclk7,       
    n_preset7,  
    paddr7,
    pwrite7,
    penable7,
    pwdata7, 
    
    // MAC07 APB7 ports7
    prdata_mac07,
    psel_mac07,
    pready_mac07,
    
    // MAC17 APB7 ports7
    prdata_mac17,
    psel_mac17,
    pready_mac17,
    
    // MAC27 APB7 ports7
    prdata_mac27,
    psel_mac27,
    pready_mac27,
    
    // MAC37 APB7 ports7
    prdata_mac37,
    psel_mac37,
    pready_mac37
);

// AHB7 interface
input         hclk7;     
input         n_hreset7; 
input         hsel7;     
input [31:0]  haddr7;    
input [1:0]   htrans7;   
input [2:0]   hsize7;    
input [31:0]  hwdata7;   
input         hwrite7;   
input         hready_in7;
input [2:0]   hburst7;   
input [3:0]   hprot7;    
input [3:0]   hmaster7;  
input         hmastlock7;
output [31:0] hrdata7;
output        hready7;
output [1:0]  hresp7; 

// APB7 interface
input         pclk7;     
input         n_preset7; 
output [31:0] paddr7;
output   	    pwrite7;
output   	    penable7;
output [31:0] pwdata7;

// MAC07 APB7 ports7
input [31:0] prdata_mac07;
output	     psel_mac07;
input        pready_mac07;

// MAC17 APB7 ports7
input [31:0] prdata_mac17;
output	     psel_mac17;
input        pready_mac17;

// MAC27 APB7 ports7
input [31:0] prdata_mac27;
output	     psel_mac27;
input        pready_mac27;

// MAC37 APB7 ports7
input [31:0] prdata_mac37;
output	     psel_mac37;
input        pready_mac37;

wire  [31:0] prdata_alut7;

assign tie_hi_bit7 = 1'b1;

ahb2apb7 #(
  32'h00A00000, // Slave7 0 Address Range7
  32'h00A0FFFF,

  32'h00A10000, // Slave7 1 Address Range7
  32'h00A1FFFF,

  32'h00A20000, // Slave7 2 Address Range7 
  32'h00A2FFFF,

  32'h00A30000, // Slave7 3 Address Range7
  32'h00A3FFFF,

  32'h00A40000, // Slave7 4 Address Range7
  32'h00A4FFFF
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
    .prdata07(prdata_alut7),
    .prdata17(prdata_mac07), 
    .prdata27(prdata_mac17),  
    .prdata37(prdata_mac27),   
    .prdata47(prdata_mac37),   
    .prdata57(32'h0),   
    .prdata67(32'h0),    
    .prdata77(32'h0),   
    .prdata87(32'h0),  
    .pready07(tie_hi_bit7),     
    .pready17(pready_mac07),   
    .pready27(pready_mac17),     
    .pready37(pready_mac27),     
    .pready47(pready_mac37),     
    .pready57(tie_hi_bit7),     
    .pready67(tie_hi_bit7),     
    .pready77(tie_hi_bit7),     
    .pready87(tie_hi_bit7),  
    .pwdata7(pwdata7),       
    .pwrite7(pwrite7),       
    .paddr7(paddr7),        
    .psel07(psel_alut7),     
    .psel17(psel_mac07),   
    .psel27(psel_mac17),    
    .psel37(psel_mac27),     
    .psel47(psel_mac37),     
    .psel57(),     
    .psel67(),    
    .psel77(),   
    .psel87(),  
    .penable7(penable7)     
);

alut_veneer7 i_alut_veneer7 (
        //inputs7
        . n_p_reset7(n_preset7),
        . pclk7(pclk7),
        . psel7(psel_alut7),
        . penable7(penable7),
        . pwrite7(pwrite7),
        . paddr7(paddr7[6:0]),
        . pwdata7(pwdata7),

        //outputs7
        . prdata7(prdata_alut7)
);

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

  .psel007(psel_alut7),
	.psel017(psel_mac07),
	.psel027(psel_mac17),
	.psel037(psel_mac27),
	.psel047(psel_mac37),
	.psel057(psel057),
	.psel067(psel067),
	.psel077(psel077),
	.psel087(psel087),
	.psel097(psel097),
	.psel107(psel107),
	.psel117(psel117),
	.psel127(psel127),
	.psel137(psel137),
	.psel147(psel147),
	.psel157(psel157),

   .prdata007(prdata_alut7), // Read Data from peripheral7 ALUT7

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
   .ahb2apb_hsel7(ahb2apb1_hsel7));



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
        .hsel_i7(ahb2apb1_hsel7)
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




endmodule
