//File14 name   : apb_subsystem_114.v
//Title14       : 
//Created14     : 1999
//Description14 : 
//Notes14       : 
//----------------------------------------------------------------------
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------

module apb_subsystem_114(
    // AHB14 interface
    hclk14,         
    n_hreset14,     
    hsel14,         
    haddr14,        
    htrans14,       
    hsize14,        
    hwrite14,       
    hwdata14,       
    hready_in14,    
    hburst14,     
    hprot14,      
    hmaster14,    
    hmastlock14,  
    hrdata14,     
    hready14,     
    hresp14,      

    // APB14 interface
    pclk14,       
    n_preset14,  
    paddr14,
    pwrite14,
    penable14,
    pwdata14, 
    
    // MAC014 APB14 ports14
    prdata_mac014,
    psel_mac014,
    pready_mac014,
    
    // MAC114 APB14 ports14
    prdata_mac114,
    psel_mac114,
    pready_mac114,
    
    // MAC214 APB14 ports14
    prdata_mac214,
    psel_mac214,
    pready_mac214,
    
    // MAC314 APB14 ports14
    prdata_mac314,
    psel_mac314,
    pready_mac314
);

// AHB14 interface
input         hclk14;     
input         n_hreset14; 
input         hsel14;     
input [31:0]  haddr14;    
input [1:0]   htrans14;   
input [2:0]   hsize14;    
input [31:0]  hwdata14;   
input         hwrite14;   
input         hready_in14;
input [2:0]   hburst14;   
input [3:0]   hprot14;    
input [3:0]   hmaster14;  
input         hmastlock14;
output [31:0] hrdata14;
output        hready14;
output [1:0]  hresp14; 

// APB14 interface
input         pclk14;     
input         n_preset14; 
output [31:0] paddr14;
output   	    pwrite14;
output   	    penable14;
output [31:0] pwdata14;

// MAC014 APB14 ports14
input [31:0] prdata_mac014;
output	     psel_mac014;
input        pready_mac014;

// MAC114 APB14 ports14
input [31:0] prdata_mac114;
output	     psel_mac114;
input        pready_mac114;

// MAC214 APB14 ports14
input [31:0] prdata_mac214;
output	     psel_mac214;
input        pready_mac214;

// MAC314 APB14 ports14
input [31:0] prdata_mac314;
output	     psel_mac314;
input        pready_mac314;

wire  [31:0] prdata_alut14;

assign tie_hi_bit14 = 1'b1;

ahb2apb14 #(
  32'h00A00000, // Slave14 0 Address Range14
  32'h00A0FFFF,

  32'h00A10000, // Slave14 1 Address Range14
  32'h00A1FFFF,

  32'h00A20000, // Slave14 2 Address Range14 
  32'h00A2FFFF,

  32'h00A30000, // Slave14 3 Address Range14
  32'h00A3FFFF,

  32'h00A40000, // Slave14 4 Address Range14
  32'h00A4FFFF
) i_ahb2apb14 (
     // AHB14 interface
    .hclk14(hclk14),         
    .hreset_n14(n_hreset14), 
    .hsel14(hsel14), 
    .haddr14(haddr14),        
    .htrans14(htrans14),       
    .hwrite14(hwrite14),       
    .hwdata14(hwdata14),       
    .hrdata14(hrdata14),   
    .hready14(hready14),   
    .hresp14(hresp14),     
    
     // APB14 interface
    .pclk14(pclk14),         
    .preset_n14(n_preset14),  
    .prdata014(prdata_alut14),
    .prdata114(prdata_mac014), 
    .prdata214(prdata_mac114),  
    .prdata314(prdata_mac214),   
    .prdata414(prdata_mac314),   
    .prdata514(32'h0),   
    .prdata614(32'h0),    
    .prdata714(32'h0),   
    .prdata814(32'h0),  
    .pready014(tie_hi_bit14),     
    .pready114(pready_mac014),   
    .pready214(pready_mac114),     
    .pready314(pready_mac214),     
    .pready414(pready_mac314),     
    .pready514(tie_hi_bit14),     
    .pready614(tie_hi_bit14),     
    .pready714(tie_hi_bit14),     
    .pready814(tie_hi_bit14),  
    .pwdata14(pwdata14),       
    .pwrite14(pwrite14),       
    .paddr14(paddr14),        
    .psel014(psel_alut14),     
    .psel114(psel_mac014),   
    .psel214(psel_mac114),    
    .psel314(psel_mac214),     
    .psel414(psel_mac314),     
    .psel514(),     
    .psel614(),    
    .psel714(),   
    .psel814(),  
    .penable14(penable14)     
);

alut_veneer14 i_alut_veneer14 (
        //inputs14
        . n_p_reset14(n_preset14),
        . pclk14(pclk14),
        . psel14(psel_alut14),
        . penable14(penable14),
        . pwrite14(pwrite14),
        . paddr14(paddr14[6:0]),
        . pwdata14(pwdata14),

        //outputs14
        . prdata14(prdata_alut14)
);

//------------------------------------------------------------------------------
// APB14 and AHB14 interface formal14 verification14 monitors14
//------------------------------------------------------------------------------
`ifdef ABV_ON14
apb_assert14 i_apb_assert14 (

   // APB14 signals14
  	.n_preset14(n_preset14),
  	.pclk14(pclk14),
	.penable14(penable14),
	.paddr14(paddr14),
	.pwrite14(pwrite14),
	.pwdata14(pwdata14),

  .psel0014(psel_alut14),
	.psel0114(psel_mac014),
	.psel0214(psel_mac114),
	.psel0314(psel_mac214),
	.psel0414(psel_mac314),
	.psel0514(psel0514),
	.psel0614(psel0614),
	.psel0714(psel0714),
	.psel0814(psel0814),
	.psel0914(psel0914),
	.psel1014(psel1014),
	.psel1114(psel1114),
	.psel1214(psel1214),
	.psel1314(psel1314),
	.psel1414(psel1414),
	.psel1514(psel1514),

   .prdata0014(prdata_alut14), // Read Data from peripheral14 ALUT14

   // AHB14 signals14
   .hclk14(hclk14),         // ahb14 system clock14
   .n_hreset14(n_hreset14), // ahb14 system reset

   // ahb2apb14 signals14
   .hresp14(hresp14),
   .hready14(hready14),
   .hrdata14(hrdata14),
   .hwdata14(hwdata14),
   .hprot14(hprot14),
   .hburst14(hburst14),
   .hsize14(hsize14),
   .hwrite14(hwrite14),
   .htrans14(htrans14),
   .haddr14(haddr14),
   .ahb2apb_hsel14(ahb2apb1_hsel14));



//------------------------------------------------------------------------------
// AHB14 interface formal14 verification14 monitor14
//------------------------------------------------------------------------------

defparam i_ahbSlaveMonitor14.DBUS_WIDTH14 = 32;
defparam i_ahbMasterMonitor14.DBUS_WIDTH14 = 32;


// AHB2APB14 Bridge14

    ahb_liteslave_monitor14 i_ahbSlaveMonitor14 (
        .hclk_i14(hclk14),
        .hresetn_i14(n_hreset14),
        .hresp14(hresp14),
        .hready14(hready14),
        .hready_global_i14(hready14),
        .hrdata14(hrdata14),
        .hwdata_i14(hwdata14),
        .hburst_i14(hburst14),
        .hsize_i14(hsize14),
        .hwrite_i14(hwrite14),
        .htrans_i14(htrans14),
        .haddr_i14(haddr14),
        .hsel_i14(ahb2apb1_hsel14)
    );


  ahb_litemaster_monitor14 i_ahbMasterMonitor14 (
          .hclk_i14(hclk14),
          .hresetn_i14(n_hreset14),
          .hresp_i14(hresp14),
          .hready_i14(hready14),
          .hrdata_i14(hrdata14),
          .hlock14(1'b0),
          .hwdata14(hwdata14),
          .hprot14(hprot14),
          .hburst14(hburst14),
          .hsize14(hsize14),
          .hwrite14(hwrite14),
          .htrans14(htrans14),
          .haddr14(haddr14)
          );






`endif




endmodule
