//File16 name   : apb_subsystem_116.v
//Title16       : 
//Created16     : 1999
//Description16 : 
//Notes16       : 
//----------------------------------------------------------------------
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------

module apb_subsystem_116(
    // AHB16 interface
    hclk16,         
    n_hreset16,     
    hsel16,         
    haddr16,        
    htrans16,       
    hsize16,        
    hwrite16,       
    hwdata16,       
    hready_in16,    
    hburst16,     
    hprot16,      
    hmaster16,    
    hmastlock16,  
    hrdata16,     
    hready16,     
    hresp16,      

    // APB16 interface
    pclk16,       
    n_preset16,  
    paddr16,
    pwrite16,
    penable16,
    pwdata16, 
    
    // MAC016 APB16 ports16
    prdata_mac016,
    psel_mac016,
    pready_mac016,
    
    // MAC116 APB16 ports16
    prdata_mac116,
    psel_mac116,
    pready_mac116,
    
    // MAC216 APB16 ports16
    prdata_mac216,
    psel_mac216,
    pready_mac216,
    
    // MAC316 APB16 ports16
    prdata_mac316,
    psel_mac316,
    pready_mac316
);

// AHB16 interface
input         hclk16;     
input         n_hreset16; 
input         hsel16;     
input [31:0]  haddr16;    
input [1:0]   htrans16;   
input [2:0]   hsize16;    
input [31:0]  hwdata16;   
input         hwrite16;   
input         hready_in16;
input [2:0]   hburst16;   
input [3:0]   hprot16;    
input [3:0]   hmaster16;  
input         hmastlock16;
output [31:0] hrdata16;
output        hready16;
output [1:0]  hresp16; 

// APB16 interface
input         pclk16;     
input         n_preset16; 
output [31:0] paddr16;
output   	    pwrite16;
output   	    penable16;
output [31:0] pwdata16;

// MAC016 APB16 ports16
input [31:0] prdata_mac016;
output	     psel_mac016;
input        pready_mac016;

// MAC116 APB16 ports16
input [31:0] prdata_mac116;
output	     psel_mac116;
input        pready_mac116;

// MAC216 APB16 ports16
input [31:0] prdata_mac216;
output	     psel_mac216;
input        pready_mac216;

// MAC316 APB16 ports16
input [31:0] prdata_mac316;
output	     psel_mac316;
input        pready_mac316;

wire  [31:0] prdata_alut16;

assign tie_hi_bit16 = 1'b1;

ahb2apb16 #(
  32'h00A00000, // Slave16 0 Address Range16
  32'h00A0FFFF,

  32'h00A10000, // Slave16 1 Address Range16
  32'h00A1FFFF,

  32'h00A20000, // Slave16 2 Address Range16 
  32'h00A2FFFF,

  32'h00A30000, // Slave16 3 Address Range16
  32'h00A3FFFF,

  32'h00A40000, // Slave16 4 Address Range16
  32'h00A4FFFF
) i_ahb2apb16 (
     // AHB16 interface
    .hclk16(hclk16),         
    .hreset_n16(n_hreset16), 
    .hsel16(hsel16), 
    .haddr16(haddr16),        
    .htrans16(htrans16),       
    .hwrite16(hwrite16),       
    .hwdata16(hwdata16),       
    .hrdata16(hrdata16),   
    .hready16(hready16),   
    .hresp16(hresp16),     
    
     // APB16 interface
    .pclk16(pclk16),         
    .preset_n16(n_preset16),  
    .prdata016(prdata_alut16),
    .prdata116(prdata_mac016), 
    .prdata216(prdata_mac116),  
    .prdata316(prdata_mac216),   
    .prdata416(prdata_mac316),   
    .prdata516(32'h0),   
    .prdata616(32'h0),    
    .prdata716(32'h0),   
    .prdata816(32'h0),  
    .pready016(tie_hi_bit16),     
    .pready116(pready_mac016),   
    .pready216(pready_mac116),     
    .pready316(pready_mac216),     
    .pready416(pready_mac316),     
    .pready516(tie_hi_bit16),     
    .pready616(tie_hi_bit16),     
    .pready716(tie_hi_bit16),     
    .pready816(tie_hi_bit16),  
    .pwdata16(pwdata16),       
    .pwrite16(pwrite16),       
    .paddr16(paddr16),        
    .psel016(psel_alut16),     
    .psel116(psel_mac016),   
    .psel216(psel_mac116),    
    .psel316(psel_mac216),     
    .psel416(psel_mac316),     
    .psel516(),     
    .psel616(),    
    .psel716(),   
    .psel816(),  
    .penable16(penable16)     
);

alut_veneer16 i_alut_veneer16 (
        //inputs16
        . n_p_reset16(n_preset16),
        . pclk16(pclk16),
        . psel16(psel_alut16),
        . penable16(penable16),
        . pwrite16(pwrite16),
        . paddr16(paddr16[6:0]),
        . pwdata16(pwdata16),

        //outputs16
        . prdata16(prdata_alut16)
);

//------------------------------------------------------------------------------
// APB16 and AHB16 interface formal16 verification16 monitors16
//------------------------------------------------------------------------------
`ifdef ABV_ON16
apb_assert16 i_apb_assert16 (

   // APB16 signals16
  	.n_preset16(n_preset16),
  	.pclk16(pclk16),
	.penable16(penable16),
	.paddr16(paddr16),
	.pwrite16(pwrite16),
	.pwdata16(pwdata16),

  .psel0016(psel_alut16),
	.psel0116(psel_mac016),
	.psel0216(psel_mac116),
	.psel0316(psel_mac216),
	.psel0416(psel_mac316),
	.psel0516(psel0516),
	.psel0616(psel0616),
	.psel0716(psel0716),
	.psel0816(psel0816),
	.psel0916(psel0916),
	.psel1016(psel1016),
	.psel1116(psel1116),
	.psel1216(psel1216),
	.psel1316(psel1316),
	.psel1416(psel1416),
	.psel1516(psel1516),

   .prdata0016(prdata_alut16), // Read Data from peripheral16 ALUT16

   // AHB16 signals16
   .hclk16(hclk16),         // ahb16 system clock16
   .n_hreset16(n_hreset16), // ahb16 system reset

   // ahb2apb16 signals16
   .hresp16(hresp16),
   .hready16(hready16),
   .hrdata16(hrdata16),
   .hwdata16(hwdata16),
   .hprot16(hprot16),
   .hburst16(hburst16),
   .hsize16(hsize16),
   .hwrite16(hwrite16),
   .htrans16(htrans16),
   .haddr16(haddr16),
   .ahb2apb_hsel16(ahb2apb1_hsel16));



//------------------------------------------------------------------------------
// AHB16 interface formal16 verification16 monitor16
//------------------------------------------------------------------------------

defparam i_ahbSlaveMonitor16.DBUS_WIDTH16 = 32;
defparam i_ahbMasterMonitor16.DBUS_WIDTH16 = 32;


// AHB2APB16 Bridge16

    ahb_liteslave_monitor16 i_ahbSlaveMonitor16 (
        .hclk_i16(hclk16),
        .hresetn_i16(n_hreset16),
        .hresp16(hresp16),
        .hready16(hready16),
        .hready_global_i16(hready16),
        .hrdata16(hrdata16),
        .hwdata_i16(hwdata16),
        .hburst_i16(hburst16),
        .hsize_i16(hsize16),
        .hwrite_i16(hwrite16),
        .htrans_i16(htrans16),
        .haddr_i16(haddr16),
        .hsel_i16(ahb2apb1_hsel16)
    );


  ahb_litemaster_monitor16 i_ahbMasterMonitor16 (
          .hclk_i16(hclk16),
          .hresetn_i16(n_hreset16),
          .hresp_i16(hresp16),
          .hready_i16(hready16),
          .hrdata_i16(hrdata16),
          .hlock16(1'b0),
          .hwdata16(hwdata16),
          .hprot16(hprot16),
          .hburst16(hburst16),
          .hsize16(hsize16),
          .hwrite16(hwrite16),
          .htrans16(htrans16),
          .haddr16(haddr16)
          );






`endif




endmodule
