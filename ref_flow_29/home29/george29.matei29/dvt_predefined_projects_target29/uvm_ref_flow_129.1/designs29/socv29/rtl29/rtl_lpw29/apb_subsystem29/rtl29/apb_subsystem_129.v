//File29 name   : apb_subsystem_129.v
//Title29       : 
//Created29     : 1999
//Description29 : 
//Notes29       : 
//----------------------------------------------------------------------
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------

module apb_subsystem_129(
    // AHB29 interface
    hclk29,         
    n_hreset29,     
    hsel29,         
    haddr29,        
    htrans29,       
    hsize29,        
    hwrite29,       
    hwdata29,       
    hready_in29,    
    hburst29,     
    hprot29,      
    hmaster29,    
    hmastlock29,  
    hrdata29,     
    hready29,     
    hresp29,      

    // APB29 interface
    pclk29,       
    n_preset29,  
    paddr29,
    pwrite29,
    penable29,
    pwdata29, 
    
    // MAC029 APB29 ports29
    prdata_mac029,
    psel_mac029,
    pready_mac029,
    
    // MAC129 APB29 ports29
    prdata_mac129,
    psel_mac129,
    pready_mac129,
    
    // MAC229 APB29 ports29
    prdata_mac229,
    psel_mac229,
    pready_mac229,
    
    // MAC329 APB29 ports29
    prdata_mac329,
    psel_mac329,
    pready_mac329
);

// AHB29 interface
input         hclk29;     
input         n_hreset29; 
input         hsel29;     
input [31:0]  haddr29;    
input [1:0]   htrans29;   
input [2:0]   hsize29;    
input [31:0]  hwdata29;   
input         hwrite29;   
input         hready_in29;
input [2:0]   hburst29;   
input [3:0]   hprot29;    
input [3:0]   hmaster29;  
input         hmastlock29;
output [31:0] hrdata29;
output        hready29;
output [1:0]  hresp29; 

// APB29 interface
input         pclk29;     
input         n_preset29; 
output [31:0] paddr29;
output   	    pwrite29;
output   	    penable29;
output [31:0] pwdata29;

// MAC029 APB29 ports29
input [31:0] prdata_mac029;
output	     psel_mac029;
input        pready_mac029;

// MAC129 APB29 ports29
input [31:0] prdata_mac129;
output	     psel_mac129;
input        pready_mac129;

// MAC229 APB29 ports29
input [31:0] prdata_mac229;
output	     psel_mac229;
input        pready_mac229;

// MAC329 APB29 ports29
input [31:0] prdata_mac329;
output	     psel_mac329;
input        pready_mac329;

wire  [31:0] prdata_alut29;

assign tie_hi_bit29 = 1'b1;

ahb2apb29 #(
  32'h00A00000, // Slave29 0 Address Range29
  32'h00A0FFFF,

  32'h00A10000, // Slave29 1 Address Range29
  32'h00A1FFFF,

  32'h00A20000, // Slave29 2 Address Range29 
  32'h00A2FFFF,

  32'h00A30000, // Slave29 3 Address Range29
  32'h00A3FFFF,

  32'h00A40000, // Slave29 4 Address Range29
  32'h00A4FFFF
) i_ahb2apb29 (
     // AHB29 interface
    .hclk29(hclk29),         
    .hreset_n29(n_hreset29), 
    .hsel29(hsel29), 
    .haddr29(haddr29),        
    .htrans29(htrans29),       
    .hwrite29(hwrite29),       
    .hwdata29(hwdata29),       
    .hrdata29(hrdata29),   
    .hready29(hready29),   
    .hresp29(hresp29),     
    
     // APB29 interface
    .pclk29(pclk29),         
    .preset_n29(n_preset29),  
    .prdata029(prdata_alut29),
    .prdata129(prdata_mac029), 
    .prdata229(prdata_mac129),  
    .prdata329(prdata_mac229),   
    .prdata429(prdata_mac329),   
    .prdata529(32'h0),   
    .prdata629(32'h0),    
    .prdata729(32'h0),   
    .prdata829(32'h0),  
    .pready029(tie_hi_bit29),     
    .pready129(pready_mac029),   
    .pready229(pready_mac129),     
    .pready329(pready_mac229),     
    .pready429(pready_mac329),     
    .pready529(tie_hi_bit29),     
    .pready629(tie_hi_bit29),     
    .pready729(tie_hi_bit29),     
    .pready829(tie_hi_bit29),  
    .pwdata29(pwdata29),       
    .pwrite29(pwrite29),       
    .paddr29(paddr29),        
    .psel029(psel_alut29),     
    .psel129(psel_mac029),   
    .psel229(psel_mac129),    
    .psel329(psel_mac229),     
    .psel429(psel_mac329),     
    .psel529(),     
    .psel629(),    
    .psel729(),   
    .psel829(),  
    .penable29(penable29)     
);

alut_veneer29 i_alut_veneer29 (
        //inputs29
        . n_p_reset29(n_preset29),
        . pclk29(pclk29),
        . psel29(psel_alut29),
        . penable29(penable29),
        . pwrite29(pwrite29),
        . paddr29(paddr29[6:0]),
        . pwdata29(pwdata29),

        //outputs29
        . prdata29(prdata_alut29)
);

//------------------------------------------------------------------------------
// APB29 and AHB29 interface formal29 verification29 monitors29
//------------------------------------------------------------------------------
`ifdef ABV_ON29
apb_assert29 i_apb_assert29 (

   // APB29 signals29
  	.n_preset29(n_preset29),
  	.pclk29(pclk29),
	.penable29(penable29),
	.paddr29(paddr29),
	.pwrite29(pwrite29),
	.pwdata29(pwdata29),

  .psel0029(psel_alut29),
	.psel0129(psel_mac029),
	.psel0229(psel_mac129),
	.psel0329(psel_mac229),
	.psel0429(psel_mac329),
	.psel0529(psel0529),
	.psel0629(psel0629),
	.psel0729(psel0729),
	.psel0829(psel0829),
	.psel0929(psel0929),
	.psel1029(psel1029),
	.psel1129(psel1129),
	.psel1229(psel1229),
	.psel1329(psel1329),
	.psel1429(psel1429),
	.psel1529(psel1529),

   .prdata0029(prdata_alut29), // Read Data from peripheral29 ALUT29

   // AHB29 signals29
   .hclk29(hclk29),         // ahb29 system clock29
   .n_hreset29(n_hreset29), // ahb29 system reset

   // ahb2apb29 signals29
   .hresp29(hresp29),
   .hready29(hready29),
   .hrdata29(hrdata29),
   .hwdata29(hwdata29),
   .hprot29(hprot29),
   .hburst29(hburst29),
   .hsize29(hsize29),
   .hwrite29(hwrite29),
   .htrans29(htrans29),
   .haddr29(haddr29),
   .ahb2apb_hsel29(ahb2apb1_hsel29));



//------------------------------------------------------------------------------
// AHB29 interface formal29 verification29 monitor29
//------------------------------------------------------------------------------

defparam i_ahbSlaveMonitor29.DBUS_WIDTH29 = 32;
defparam i_ahbMasterMonitor29.DBUS_WIDTH29 = 32;


// AHB2APB29 Bridge29

    ahb_liteslave_monitor29 i_ahbSlaveMonitor29 (
        .hclk_i29(hclk29),
        .hresetn_i29(n_hreset29),
        .hresp29(hresp29),
        .hready29(hready29),
        .hready_global_i29(hready29),
        .hrdata29(hrdata29),
        .hwdata_i29(hwdata29),
        .hburst_i29(hburst29),
        .hsize_i29(hsize29),
        .hwrite_i29(hwrite29),
        .htrans_i29(htrans29),
        .haddr_i29(haddr29),
        .hsel_i29(ahb2apb1_hsel29)
    );


  ahb_litemaster_monitor29 i_ahbMasterMonitor29 (
          .hclk_i29(hclk29),
          .hresetn_i29(n_hreset29),
          .hresp_i29(hresp29),
          .hready_i29(hready29),
          .hrdata_i29(hrdata29),
          .hlock29(1'b0),
          .hwdata29(hwdata29),
          .hprot29(hprot29),
          .hburst29(hburst29),
          .hsize29(hsize29),
          .hwrite29(hwrite29),
          .htrans29(htrans29),
          .haddr29(haddr29)
          );






`endif




endmodule
