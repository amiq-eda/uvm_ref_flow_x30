//File18 name   : apb_subsystem_118.v
//Title18       : 
//Created18     : 1999
//Description18 : 
//Notes18       : 
//----------------------------------------------------------------------
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------

module apb_subsystem_118(
    // AHB18 interface
    hclk18,         
    n_hreset18,     
    hsel18,         
    haddr18,        
    htrans18,       
    hsize18,        
    hwrite18,       
    hwdata18,       
    hready_in18,    
    hburst18,     
    hprot18,      
    hmaster18,    
    hmastlock18,  
    hrdata18,     
    hready18,     
    hresp18,      

    // APB18 interface
    pclk18,       
    n_preset18,  
    paddr18,
    pwrite18,
    penable18,
    pwdata18, 
    
    // MAC018 APB18 ports18
    prdata_mac018,
    psel_mac018,
    pready_mac018,
    
    // MAC118 APB18 ports18
    prdata_mac118,
    psel_mac118,
    pready_mac118,
    
    // MAC218 APB18 ports18
    prdata_mac218,
    psel_mac218,
    pready_mac218,
    
    // MAC318 APB18 ports18
    prdata_mac318,
    psel_mac318,
    pready_mac318
);

// AHB18 interface
input         hclk18;     
input         n_hreset18; 
input         hsel18;     
input [31:0]  haddr18;    
input [1:0]   htrans18;   
input [2:0]   hsize18;    
input [31:0]  hwdata18;   
input         hwrite18;   
input         hready_in18;
input [2:0]   hburst18;   
input [3:0]   hprot18;    
input [3:0]   hmaster18;  
input         hmastlock18;
output [31:0] hrdata18;
output        hready18;
output [1:0]  hresp18; 

// APB18 interface
input         pclk18;     
input         n_preset18; 
output [31:0] paddr18;
output   	    pwrite18;
output   	    penable18;
output [31:0] pwdata18;

// MAC018 APB18 ports18
input [31:0] prdata_mac018;
output	     psel_mac018;
input        pready_mac018;

// MAC118 APB18 ports18
input [31:0] prdata_mac118;
output	     psel_mac118;
input        pready_mac118;

// MAC218 APB18 ports18
input [31:0] prdata_mac218;
output	     psel_mac218;
input        pready_mac218;

// MAC318 APB18 ports18
input [31:0] prdata_mac318;
output	     psel_mac318;
input        pready_mac318;

wire  [31:0] prdata_alut18;

assign tie_hi_bit18 = 1'b1;

ahb2apb18 #(
  32'h00A00000, // Slave18 0 Address Range18
  32'h00A0FFFF,

  32'h00A10000, // Slave18 1 Address Range18
  32'h00A1FFFF,

  32'h00A20000, // Slave18 2 Address Range18 
  32'h00A2FFFF,

  32'h00A30000, // Slave18 3 Address Range18
  32'h00A3FFFF,

  32'h00A40000, // Slave18 4 Address Range18
  32'h00A4FFFF
) i_ahb2apb18 (
     // AHB18 interface
    .hclk18(hclk18),         
    .hreset_n18(n_hreset18), 
    .hsel18(hsel18), 
    .haddr18(haddr18),        
    .htrans18(htrans18),       
    .hwrite18(hwrite18),       
    .hwdata18(hwdata18),       
    .hrdata18(hrdata18),   
    .hready18(hready18),   
    .hresp18(hresp18),     
    
     // APB18 interface
    .pclk18(pclk18),         
    .preset_n18(n_preset18),  
    .prdata018(prdata_alut18),
    .prdata118(prdata_mac018), 
    .prdata218(prdata_mac118),  
    .prdata318(prdata_mac218),   
    .prdata418(prdata_mac318),   
    .prdata518(32'h0),   
    .prdata618(32'h0),    
    .prdata718(32'h0),   
    .prdata818(32'h0),  
    .pready018(tie_hi_bit18),     
    .pready118(pready_mac018),   
    .pready218(pready_mac118),     
    .pready318(pready_mac218),     
    .pready418(pready_mac318),     
    .pready518(tie_hi_bit18),     
    .pready618(tie_hi_bit18),     
    .pready718(tie_hi_bit18),     
    .pready818(tie_hi_bit18),  
    .pwdata18(pwdata18),       
    .pwrite18(pwrite18),       
    .paddr18(paddr18),        
    .psel018(psel_alut18),     
    .psel118(psel_mac018),   
    .psel218(psel_mac118),    
    .psel318(psel_mac218),     
    .psel418(psel_mac318),     
    .psel518(),     
    .psel618(),    
    .psel718(),   
    .psel818(),  
    .penable18(penable18)     
);

alut_veneer18 i_alut_veneer18 (
        //inputs18
        . n_p_reset18(n_preset18),
        . pclk18(pclk18),
        . psel18(psel_alut18),
        . penable18(penable18),
        . pwrite18(pwrite18),
        . paddr18(paddr18[6:0]),
        . pwdata18(pwdata18),

        //outputs18
        . prdata18(prdata_alut18)
);

//------------------------------------------------------------------------------
// APB18 and AHB18 interface formal18 verification18 monitors18
//------------------------------------------------------------------------------
`ifdef ABV_ON18
apb_assert18 i_apb_assert18 (

   // APB18 signals18
  	.n_preset18(n_preset18),
  	.pclk18(pclk18),
	.penable18(penable18),
	.paddr18(paddr18),
	.pwrite18(pwrite18),
	.pwdata18(pwdata18),

  .psel0018(psel_alut18),
	.psel0118(psel_mac018),
	.psel0218(psel_mac118),
	.psel0318(psel_mac218),
	.psel0418(psel_mac318),
	.psel0518(psel0518),
	.psel0618(psel0618),
	.psel0718(psel0718),
	.psel0818(psel0818),
	.psel0918(psel0918),
	.psel1018(psel1018),
	.psel1118(psel1118),
	.psel1218(psel1218),
	.psel1318(psel1318),
	.psel1418(psel1418),
	.psel1518(psel1518),

   .prdata0018(prdata_alut18), // Read Data from peripheral18 ALUT18

   // AHB18 signals18
   .hclk18(hclk18),         // ahb18 system clock18
   .n_hreset18(n_hreset18), // ahb18 system reset

   // ahb2apb18 signals18
   .hresp18(hresp18),
   .hready18(hready18),
   .hrdata18(hrdata18),
   .hwdata18(hwdata18),
   .hprot18(hprot18),
   .hburst18(hburst18),
   .hsize18(hsize18),
   .hwrite18(hwrite18),
   .htrans18(htrans18),
   .haddr18(haddr18),
   .ahb2apb_hsel18(ahb2apb1_hsel18));



//------------------------------------------------------------------------------
// AHB18 interface formal18 verification18 monitor18
//------------------------------------------------------------------------------

defparam i_ahbSlaveMonitor18.DBUS_WIDTH18 = 32;
defparam i_ahbMasterMonitor18.DBUS_WIDTH18 = 32;


// AHB2APB18 Bridge18

    ahb_liteslave_monitor18 i_ahbSlaveMonitor18 (
        .hclk_i18(hclk18),
        .hresetn_i18(n_hreset18),
        .hresp18(hresp18),
        .hready18(hready18),
        .hready_global_i18(hready18),
        .hrdata18(hrdata18),
        .hwdata_i18(hwdata18),
        .hburst_i18(hburst18),
        .hsize_i18(hsize18),
        .hwrite_i18(hwrite18),
        .htrans_i18(htrans18),
        .haddr_i18(haddr18),
        .hsel_i18(ahb2apb1_hsel18)
    );


  ahb_litemaster_monitor18 i_ahbMasterMonitor18 (
          .hclk_i18(hclk18),
          .hresetn_i18(n_hreset18),
          .hresp_i18(hresp18),
          .hready_i18(hready18),
          .hrdata_i18(hrdata18),
          .hlock18(1'b0),
          .hwdata18(hwdata18),
          .hprot18(hprot18),
          .hburst18(hburst18),
          .hsize18(hsize18),
          .hwrite18(hwrite18),
          .htrans18(htrans18),
          .haddr18(haddr18)
          );






`endif




endmodule
