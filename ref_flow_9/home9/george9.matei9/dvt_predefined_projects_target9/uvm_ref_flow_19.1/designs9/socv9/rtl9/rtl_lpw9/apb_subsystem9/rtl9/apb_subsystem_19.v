//File9 name   : apb_subsystem_19.v
//Title9       : 
//Created9     : 1999
//Description9 : 
//Notes9       : 
//----------------------------------------------------------------------
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------

module apb_subsystem_19(
    // AHB9 interface
    hclk9,         
    n_hreset9,     
    hsel9,         
    haddr9,        
    htrans9,       
    hsize9,        
    hwrite9,       
    hwdata9,       
    hready_in9,    
    hburst9,     
    hprot9,      
    hmaster9,    
    hmastlock9,  
    hrdata9,     
    hready9,     
    hresp9,      

    // APB9 interface
    pclk9,       
    n_preset9,  
    paddr9,
    pwrite9,
    penable9,
    pwdata9, 
    
    // MAC09 APB9 ports9
    prdata_mac09,
    psel_mac09,
    pready_mac09,
    
    // MAC19 APB9 ports9
    prdata_mac19,
    psel_mac19,
    pready_mac19,
    
    // MAC29 APB9 ports9
    prdata_mac29,
    psel_mac29,
    pready_mac29,
    
    // MAC39 APB9 ports9
    prdata_mac39,
    psel_mac39,
    pready_mac39
);

// AHB9 interface
input         hclk9;     
input         n_hreset9; 
input         hsel9;     
input [31:0]  haddr9;    
input [1:0]   htrans9;   
input [2:0]   hsize9;    
input [31:0]  hwdata9;   
input         hwrite9;   
input         hready_in9;
input [2:0]   hburst9;   
input [3:0]   hprot9;    
input [3:0]   hmaster9;  
input         hmastlock9;
output [31:0] hrdata9;
output        hready9;
output [1:0]  hresp9; 

// APB9 interface
input         pclk9;     
input         n_preset9; 
output [31:0] paddr9;
output   	    pwrite9;
output   	    penable9;
output [31:0] pwdata9;

// MAC09 APB9 ports9
input [31:0] prdata_mac09;
output	     psel_mac09;
input        pready_mac09;

// MAC19 APB9 ports9
input [31:0] prdata_mac19;
output	     psel_mac19;
input        pready_mac19;

// MAC29 APB9 ports9
input [31:0] prdata_mac29;
output	     psel_mac29;
input        pready_mac29;

// MAC39 APB9 ports9
input [31:0] prdata_mac39;
output	     psel_mac39;
input        pready_mac39;

wire  [31:0] prdata_alut9;

assign tie_hi_bit9 = 1'b1;

ahb2apb9 #(
  32'h00A00000, // Slave9 0 Address Range9
  32'h00A0FFFF,

  32'h00A10000, // Slave9 1 Address Range9
  32'h00A1FFFF,

  32'h00A20000, // Slave9 2 Address Range9 
  32'h00A2FFFF,

  32'h00A30000, // Slave9 3 Address Range9
  32'h00A3FFFF,

  32'h00A40000, // Slave9 4 Address Range9
  32'h00A4FFFF
) i_ahb2apb9 (
     // AHB9 interface
    .hclk9(hclk9),         
    .hreset_n9(n_hreset9), 
    .hsel9(hsel9), 
    .haddr9(haddr9),        
    .htrans9(htrans9),       
    .hwrite9(hwrite9),       
    .hwdata9(hwdata9),       
    .hrdata9(hrdata9),   
    .hready9(hready9),   
    .hresp9(hresp9),     
    
     // APB9 interface
    .pclk9(pclk9),         
    .preset_n9(n_preset9),  
    .prdata09(prdata_alut9),
    .prdata19(prdata_mac09), 
    .prdata29(prdata_mac19),  
    .prdata39(prdata_mac29),   
    .prdata49(prdata_mac39),   
    .prdata59(32'h0),   
    .prdata69(32'h0),    
    .prdata79(32'h0),   
    .prdata89(32'h0),  
    .pready09(tie_hi_bit9),     
    .pready19(pready_mac09),   
    .pready29(pready_mac19),     
    .pready39(pready_mac29),     
    .pready49(pready_mac39),     
    .pready59(tie_hi_bit9),     
    .pready69(tie_hi_bit9),     
    .pready79(tie_hi_bit9),     
    .pready89(tie_hi_bit9),  
    .pwdata9(pwdata9),       
    .pwrite9(pwrite9),       
    .paddr9(paddr9),        
    .psel09(psel_alut9),     
    .psel19(psel_mac09),   
    .psel29(psel_mac19),    
    .psel39(psel_mac29),     
    .psel49(psel_mac39),     
    .psel59(),     
    .psel69(),    
    .psel79(),   
    .psel89(),  
    .penable9(penable9)     
);

alut_veneer9 i_alut_veneer9 (
        //inputs9
        . n_p_reset9(n_preset9),
        . pclk9(pclk9),
        . psel9(psel_alut9),
        . penable9(penable9),
        . pwrite9(pwrite9),
        . paddr9(paddr9[6:0]),
        . pwdata9(pwdata9),

        //outputs9
        . prdata9(prdata_alut9)
);

//------------------------------------------------------------------------------
// APB9 and AHB9 interface formal9 verification9 monitors9
//------------------------------------------------------------------------------
`ifdef ABV_ON9
apb_assert9 i_apb_assert9 (

   // APB9 signals9
  	.n_preset9(n_preset9),
  	.pclk9(pclk9),
	.penable9(penable9),
	.paddr9(paddr9),
	.pwrite9(pwrite9),
	.pwdata9(pwdata9),

  .psel009(psel_alut9),
	.psel019(psel_mac09),
	.psel029(psel_mac19),
	.psel039(psel_mac29),
	.psel049(psel_mac39),
	.psel059(psel059),
	.psel069(psel069),
	.psel079(psel079),
	.psel089(psel089),
	.psel099(psel099),
	.psel109(psel109),
	.psel119(psel119),
	.psel129(psel129),
	.psel139(psel139),
	.psel149(psel149),
	.psel159(psel159),

   .prdata009(prdata_alut9), // Read Data from peripheral9 ALUT9

   // AHB9 signals9
   .hclk9(hclk9),         // ahb9 system clock9
   .n_hreset9(n_hreset9), // ahb9 system reset

   // ahb2apb9 signals9
   .hresp9(hresp9),
   .hready9(hready9),
   .hrdata9(hrdata9),
   .hwdata9(hwdata9),
   .hprot9(hprot9),
   .hburst9(hburst9),
   .hsize9(hsize9),
   .hwrite9(hwrite9),
   .htrans9(htrans9),
   .haddr9(haddr9),
   .ahb2apb_hsel9(ahb2apb1_hsel9));



//------------------------------------------------------------------------------
// AHB9 interface formal9 verification9 monitor9
//------------------------------------------------------------------------------

defparam i_ahbSlaveMonitor9.DBUS_WIDTH9 = 32;
defparam i_ahbMasterMonitor9.DBUS_WIDTH9 = 32;


// AHB2APB9 Bridge9

    ahb_liteslave_monitor9 i_ahbSlaveMonitor9 (
        .hclk_i9(hclk9),
        .hresetn_i9(n_hreset9),
        .hresp9(hresp9),
        .hready9(hready9),
        .hready_global_i9(hready9),
        .hrdata9(hrdata9),
        .hwdata_i9(hwdata9),
        .hburst_i9(hburst9),
        .hsize_i9(hsize9),
        .hwrite_i9(hwrite9),
        .htrans_i9(htrans9),
        .haddr_i9(haddr9),
        .hsel_i9(ahb2apb1_hsel9)
    );


  ahb_litemaster_monitor9 i_ahbMasterMonitor9 (
          .hclk_i9(hclk9),
          .hresetn_i9(n_hreset9),
          .hresp_i9(hresp9),
          .hready_i9(hready9),
          .hrdata_i9(hrdata9),
          .hlock9(1'b0),
          .hwdata9(hwdata9),
          .hprot9(hprot9),
          .hburst9(hburst9),
          .hsize9(hsize9),
          .hwrite9(hwrite9),
          .htrans9(htrans9),
          .haddr9(haddr9)
          );






`endif




endmodule
