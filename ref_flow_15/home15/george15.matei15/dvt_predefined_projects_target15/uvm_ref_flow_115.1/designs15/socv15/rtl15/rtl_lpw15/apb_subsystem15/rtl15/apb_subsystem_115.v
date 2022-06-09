//File15 name   : apb_subsystem_115.v
//Title15       : 
//Created15     : 1999
//Description15 : 
//Notes15       : 
//----------------------------------------------------------------------
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------

module apb_subsystem_115(
    // AHB15 interface
    hclk15,         
    n_hreset15,     
    hsel15,         
    haddr15,        
    htrans15,       
    hsize15,        
    hwrite15,       
    hwdata15,       
    hready_in15,    
    hburst15,     
    hprot15,      
    hmaster15,    
    hmastlock15,  
    hrdata15,     
    hready15,     
    hresp15,      

    // APB15 interface
    pclk15,       
    n_preset15,  
    paddr15,
    pwrite15,
    penable15,
    pwdata15, 
    
    // MAC015 APB15 ports15
    prdata_mac015,
    psel_mac015,
    pready_mac015,
    
    // MAC115 APB15 ports15
    prdata_mac115,
    psel_mac115,
    pready_mac115,
    
    // MAC215 APB15 ports15
    prdata_mac215,
    psel_mac215,
    pready_mac215,
    
    // MAC315 APB15 ports15
    prdata_mac315,
    psel_mac315,
    pready_mac315
);

// AHB15 interface
input         hclk15;     
input         n_hreset15; 
input         hsel15;     
input [31:0]  haddr15;    
input [1:0]   htrans15;   
input [2:0]   hsize15;    
input [31:0]  hwdata15;   
input         hwrite15;   
input         hready_in15;
input [2:0]   hburst15;   
input [3:0]   hprot15;    
input [3:0]   hmaster15;  
input         hmastlock15;
output [31:0] hrdata15;
output        hready15;
output [1:0]  hresp15; 

// APB15 interface
input         pclk15;     
input         n_preset15; 
output [31:0] paddr15;
output   	    pwrite15;
output   	    penable15;
output [31:0] pwdata15;

// MAC015 APB15 ports15
input [31:0] prdata_mac015;
output	     psel_mac015;
input        pready_mac015;

// MAC115 APB15 ports15
input [31:0] prdata_mac115;
output	     psel_mac115;
input        pready_mac115;

// MAC215 APB15 ports15
input [31:0] prdata_mac215;
output	     psel_mac215;
input        pready_mac215;

// MAC315 APB15 ports15
input [31:0] prdata_mac315;
output	     psel_mac315;
input        pready_mac315;

wire  [31:0] prdata_alut15;

assign tie_hi_bit15 = 1'b1;

ahb2apb15 #(
  32'h00A00000, // Slave15 0 Address Range15
  32'h00A0FFFF,

  32'h00A10000, // Slave15 1 Address Range15
  32'h00A1FFFF,

  32'h00A20000, // Slave15 2 Address Range15 
  32'h00A2FFFF,

  32'h00A30000, // Slave15 3 Address Range15
  32'h00A3FFFF,

  32'h00A40000, // Slave15 4 Address Range15
  32'h00A4FFFF
) i_ahb2apb15 (
     // AHB15 interface
    .hclk15(hclk15),         
    .hreset_n15(n_hreset15), 
    .hsel15(hsel15), 
    .haddr15(haddr15),        
    .htrans15(htrans15),       
    .hwrite15(hwrite15),       
    .hwdata15(hwdata15),       
    .hrdata15(hrdata15),   
    .hready15(hready15),   
    .hresp15(hresp15),     
    
     // APB15 interface
    .pclk15(pclk15),         
    .preset_n15(n_preset15),  
    .prdata015(prdata_alut15),
    .prdata115(prdata_mac015), 
    .prdata215(prdata_mac115),  
    .prdata315(prdata_mac215),   
    .prdata415(prdata_mac315),   
    .prdata515(32'h0),   
    .prdata615(32'h0),    
    .prdata715(32'h0),   
    .prdata815(32'h0),  
    .pready015(tie_hi_bit15),     
    .pready115(pready_mac015),   
    .pready215(pready_mac115),     
    .pready315(pready_mac215),     
    .pready415(pready_mac315),     
    .pready515(tie_hi_bit15),     
    .pready615(tie_hi_bit15),     
    .pready715(tie_hi_bit15),     
    .pready815(tie_hi_bit15),  
    .pwdata15(pwdata15),       
    .pwrite15(pwrite15),       
    .paddr15(paddr15),        
    .psel015(psel_alut15),     
    .psel115(psel_mac015),   
    .psel215(psel_mac115),    
    .psel315(psel_mac215),     
    .psel415(psel_mac315),     
    .psel515(),     
    .psel615(),    
    .psel715(),   
    .psel815(),  
    .penable15(penable15)     
);

alut_veneer15 i_alut_veneer15 (
        //inputs15
        . n_p_reset15(n_preset15),
        . pclk15(pclk15),
        . psel15(psel_alut15),
        . penable15(penable15),
        . pwrite15(pwrite15),
        . paddr15(paddr15[6:0]),
        . pwdata15(pwdata15),

        //outputs15
        . prdata15(prdata_alut15)
);

//------------------------------------------------------------------------------
// APB15 and AHB15 interface formal15 verification15 monitors15
//------------------------------------------------------------------------------
`ifdef ABV_ON15
apb_assert15 i_apb_assert15 (

   // APB15 signals15
  	.n_preset15(n_preset15),
  	.pclk15(pclk15),
	.penable15(penable15),
	.paddr15(paddr15),
	.pwrite15(pwrite15),
	.pwdata15(pwdata15),

  .psel0015(psel_alut15),
	.psel0115(psel_mac015),
	.psel0215(psel_mac115),
	.psel0315(psel_mac215),
	.psel0415(psel_mac315),
	.psel0515(psel0515),
	.psel0615(psel0615),
	.psel0715(psel0715),
	.psel0815(psel0815),
	.psel0915(psel0915),
	.psel1015(psel1015),
	.psel1115(psel1115),
	.psel1215(psel1215),
	.psel1315(psel1315),
	.psel1415(psel1415),
	.psel1515(psel1515),

   .prdata0015(prdata_alut15), // Read Data from peripheral15 ALUT15

   // AHB15 signals15
   .hclk15(hclk15),         // ahb15 system clock15
   .n_hreset15(n_hreset15), // ahb15 system reset

   // ahb2apb15 signals15
   .hresp15(hresp15),
   .hready15(hready15),
   .hrdata15(hrdata15),
   .hwdata15(hwdata15),
   .hprot15(hprot15),
   .hburst15(hburst15),
   .hsize15(hsize15),
   .hwrite15(hwrite15),
   .htrans15(htrans15),
   .haddr15(haddr15),
   .ahb2apb_hsel15(ahb2apb1_hsel15));



//------------------------------------------------------------------------------
// AHB15 interface formal15 verification15 monitor15
//------------------------------------------------------------------------------

defparam i_ahbSlaveMonitor15.DBUS_WIDTH15 = 32;
defparam i_ahbMasterMonitor15.DBUS_WIDTH15 = 32;


// AHB2APB15 Bridge15

    ahb_liteslave_monitor15 i_ahbSlaveMonitor15 (
        .hclk_i15(hclk15),
        .hresetn_i15(n_hreset15),
        .hresp15(hresp15),
        .hready15(hready15),
        .hready_global_i15(hready15),
        .hrdata15(hrdata15),
        .hwdata_i15(hwdata15),
        .hburst_i15(hburst15),
        .hsize_i15(hsize15),
        .hwrite_i15(hwrite15),
        .htrans_i15(htrans15),
        .haddr_i15(haddr15),
        .hsel_i15(ahb2apb1_hsel15)
    );


  ahb_litemaster_monitor15 i_ahbMasterMonitor15 (
          .hclk_i15(hclk15),
          .hresetn_i15(n_hreset15),
          .hresp_i15(hresp15),
          .hready_i15(hready15),
          .hrdata_i15(hrdata15),
          .hlock15(1'b0),
          .hwdata15(hwdata15),
          .hprot15(hprot15),
          .hburst15(hburst15),
          .hsize15(hsize15),
          .hwrite15(hwrite15),
          .htrans15(htrans15),
          .haddr15(haddr15)
          );






`endif




endmodule
