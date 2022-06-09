//File26 name   : apb_subsystem_126.v
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

module apb_subsystem_126(
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

    // APB26 interface
    pclk26,       
    n_preset26,  
    paddr26,
    pwrite26,
    penable26,
    pwdata26, 
    
    // MAC026 APB26 ports26
    prdata_mac026,
    psel_mac026,
    pready_mac026,
    
    // MAC126 APB26 ports26
    prdata_mac126,
    psel_mac126,
    pready_mac126,
    
    // MAC226 APB26 ports26
    prdata_mac226,
    psel_mac226,
    pready_mac226,
    
    // MAC326 APB26 ports26
    prdata_mac326,
    psel_mac326,
    pready_mac326
);

// AHB26 interface
input         hclk26;     
input         n_hreset26; 
input         hsel26;     
input [31:0]  haddr26;    
input [1:0]   htrans26;   
input [2:0]   hsize26;    
input [31:0]  hwdata26;   
input         hwrite26;   
input         hready_in26;
input [2:0]   hburst26;   
input [3:0]   hprot26;    
input [3:0]   hmaster26;  
input         hmastlock26;
output [31:0] hrdata26;
output        hready26;
output [1:0]  hresp26; 

// APB26 interface
input         pclk26;     
input         n_preset26; 
output [31:0] paddr26;
output   	    pwrite26;
output   	    penable26;
output [31:0] pwdata26;

// MAC026 APB26 ports26
input [31:0] prdata_mac026;
output	     psel_mac026;
input        pready_mac026;

// MAC126 APB26 ports26
input [31:0] prdata_mac126;
output	     psel_mac126;
input        pready_mac126;

// MAC226 APB26 ports26
input [31:0] prdata_mac226;
output	     psel_mac226;
input        pready_mac226;

// MAC326 APB26 ports26
input [31:0] prdata_mac326;
output	     psel_mac326;
input        pready_mac326;

wire  [31:0] prdata_alut26;

assign tie_hi_bit26 = 1'b1;

ahb2apb26 #(
  32'h00A00000, // Slave26 0 Address Range26
  32'h00A0FFFF,

  32'h00A10000, // Slave26 1 Address Range26
  32'h00A1FFFF,

  32'h00A20000, // Slave26 2 Address Range26 
  32'h00A2FFFF,

  32'h00A30000, // Slave26 3 Address Range26
  32'h00A3FFFF,

  32'h00A40000, // Slave26 4 Address Range26
  32'h00A4FFFF
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
    .prdata026(prdata_alut26),
    .prdata126(prdata_mac026), 
    .prdata226(prdata_mac126),  
    .prdata326(prdata_mac226),   
    .prdata426(prdata_mac326),   
    .prdata526(32'h0),   
    .prdata626(32'h0),    
    .prdata726(32'h0),   
    .prdata826(32'h0),  
    .pready026(tie_hi_bit26),     
    .pready126(pready_mac026),   
    .pready226(pready_mac126),     
    .pready326(pready_mac226),     
    .pready426(pready_mac326),     
    .pready526(tie_hi_bit26),     
    .pready626(tie_hi_bit26),     
    .pready726(tie_hi_bit26),     
    .pready826(tie_hi_bit26),  
    .pwdata26(pwdata26),       
    .pwrite26(pwrite26),       
    .paddr26(paddr26),        
    .psel026(psel_alut26),     
    .psel126(psel_mac026),   
    .psel226(psel_mac126),    
    .psel326(psel_mac226),     
    .psel426(psel_mac326),     
    .psel526(),     
    .psel626(),    
    .psel726(),   
    .psel826(),  
    .penable26(penable26)     
);

alut_veneer26 i_alut_veneer26 (
        //inputs26
        . n_p_reset26(n_preset26),
        . pclk26(pclk26),
        . psel26(psel_alut26),
        . penable26(penable26),
        . pwrite26(pwrite26),
        . paddr26(paddr26[6:0]),
        . pwdata26(pwdata26),

        //outputs26
        . prdata26(prdata_alut26)
);

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

  .psel0026(psel_alut26),
	.psel0126(psel_mac026),
	.psel0226(psel_mac126),
	.psel0326(psel_mac226),
	.psel0426(psel_mac326),
	.psel0526(psel0526),
	.psel0626(psel0626),
	.psel0726(psel0726),
	.psel0826(psel0826),
	.psel0926(psel0926),
	.psel1026(psel1026),
	.psel1126(psel1126),
	.psel1226(psel1226),
	.psel1326(psel1326),
	.psel1426(psel1426),
	.psel1526(psel1526),

   .prdata0026(prdata_alut26), // Read Data from peripheral26 ALUT26

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
   .ahb2apb_hsel26(ahb2apb1_hsel26));



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
        .hsel_i26(ahb2apb1_hsel26)
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




endmodule
