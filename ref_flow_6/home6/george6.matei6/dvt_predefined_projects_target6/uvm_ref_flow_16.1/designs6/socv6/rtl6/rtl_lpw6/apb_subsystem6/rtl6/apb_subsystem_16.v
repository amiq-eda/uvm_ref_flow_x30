//File6 name   : apb_subsystem_16.v
//Title6       : 
//Created6     : 1999
//Description6 : 
//Notes6       : 
//----------------------------------------------------------------------
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------

module apb_subsystem_16(
    // AHB6 interface
    hclk6,         
    n_hreset6,     
    hsel6,         
    haddr6,        
    htrans6,       
    hsize6,        
    hwrite6,       
    hwdata6,       
    hready_in6,    
    hburst6,     
    hprot6,      
    hmaster6,    
    hmastlock6,  
    hrdata6,     
    hready6,     
    hresp6,      

    // APB6 interface
    pclk6,       
    n_preset6,  
    paddr6,
    pwrite6,
    penable6,
    pwdata6, 
    
    // MAC06 APB6 ports6
    prdata_mac06,
    psel_mac06,
    pready_mac06,
    
    // MAC16 APB6 ports6
    prdata_mac16,
    psel_mac16,
    pready_mac16,
    
    // MAC26 APB6 ports6
    prdata_mac26,
    psel_mac26,
    pready_mac26,
    
    // MAC36 APB6 ports6
    prdata_mac36,
    psel_mac36,
    pready_mac36
);

// AHB6 interface
input         hclk6;     
input         n_hreset6; 
input         hsel6;     
input [31:0]  haddr6;    
input [1:0]   htrans6;   
input [2:0]   hsize6;    
input [31:0]  hwdata6;   
input         hwrite6;   
input         hready_in6;
input [2:0]   hburst6;   
input [3:0]   hprot6;    
input [3:0]   hmaster6;  
input         hmastlock6;
output [31:0] hrdata6;
output        hready6;
output [1:0]  hresp6; 

// APB6 interface
input         pclk6;     
input         n_preset6; 
output [31:0] paddr6;
output   	    pwrite6;
output   	    penable6;
output [31:0] pwdata6;

// MAC06 APB6 ports6
input [31:0] prdata_mac06;
output	     psel_mac06;
input        pready_mac06;

// MAC16 APB6 ports6
input [31:0] prdata_mac16;
output	     psel_mac16;
input        pready_mac16;

// MAC26 APB6 ports6
input [31:0] prdata_mac26;
output	     psel_mac26;
input        pready_mac26;

// MAC36 APB6 ports6
input [31:0] prdata_mac36;
output	     psel_mac36;
input        pready_mac36;

wire  [31:0] prdata_alut6;

assign tie_hi_bit6 = 1'b1;

ahb2apb6 #(
  32'h00A00000, // Slave6 0 Address Range6
  32'h00A0FFFF,

  32'h00A10000, // Slave6 1 Address Range6
  32'h00A1FFFF,

  32'h00A20000, // Slave6 2 Address Range6 
  32'h00A2FFFF,

  32'h00A30000, // Slave6 3 Address Range6
  32'h00A3FFFF,

  32'h00A40000, // Slave6 4 Address Range6
  32'h00A4FFFF
) i_ahb2apb6 (
     // AHB6 interface
    .hclk6(hclk6),         
    .hreset_n6(n_hreset6), 
    .hsel6(hsel6), 
    .haddr6(haddr6),        
    .htrans6(htrans6),       
    .hwrite6(hwrite6),       
    .hwdata6(hwdata6),       
    .hrdata6(hrdata6),   
    .hready6(hready6),   
    .hresp6(hresp6),     
    
     // APB6 interface
    .pclk6(pclk6),         
    .preset_n6(n_preset6),  
    .prdata06(prdata_alut6),
    .prdata16(prdata_mac06), 
    .prdata26(prdata_mac16),  
    .prdata36(prdata_mac26),   
    .prdata46(prdata_mac36),   
    .prdata56(32'h0),   
    .prdata66(32'h0),    
    .prdata76(32'h0),   
    .prdata86(32'h0),  
    .pready06(tie_hi_bit6),     
    .pready16(pready_mac06),   
    .pready26(pready_mac16),     
    .pready36(pready_mac26),     
    .pready46(pready_mac36),     
    .pready56(tie_hi_bit6),     
    .pready66(tie_hi_bit6),     
    .pready76(tie_hi_bit6),     
    .pready86(tie_hi_bit6),  
    .pwdata6(pwdata6),       
    .pwrite6(pwrite6),       
    .paddr6(paddr6),        
    .psel06(psel_alut6),     
    .psel16(psel_mac06),   
    .psel26(psel_mac16),    
    .psel36(psel_mac26),     
    .psel46(psel_mac36),     
    .psel56(),     
    .psel66(),    
    .psel76(),   
    .psel86(),  
    .penable6(penable6)     
);

alut_veneer6 i_alut_veneer6 (
        //inputs6
        . n_p_reset6(n_preset6),
        . pclk6(pclk6),
        . psel6(psel_alut6),
        . penable6(penable6),
        . pwrite6(pwrite6),
        . paddr6(paddr6[6:0]),
        . pwdata6(pwdata6),

        //outputs6
        . prdata6(prdata_alut6)
);

//------------------------------------------------------------------------------
// APB6 and AHB6 interface formal6 verification6 monitors6
//------------------------------------------------------------------------------
`ifdef ABV_ON6
apb_assert6 i_apb_assert6 (

   // APB6 signals6
  	.n_preset6(n_preset6),
  	.pclk6(pclk6),
	.penable6(penable6),
	.paddr6(paddr6),
	.pwrite6(pwrite6),
	.pwdata6(pwdata6),

  .psel006(psel_alut6),
	.psel016(psel_mac06),
	.psel026(psel_mac16),
	.psel036(psel_mac26),
	.psel046(psel_mac36),
	.psel056(psel056),
	.psel066(psel066),
	.psel076(psel076),
	.psel086(psel086),
	.psel096(psel096),
	.psel106(psel106),
	.psel116(psel116),
	.psel126(psel126),
	.psel136(psel136),
	.psel146(psel146),
	.psel156(psel156),

   .prdata006(prdata_alut6), // Read Data from peripheral6 ALUT6

   // AHB6 signals6
   .hclk6(hclk6),         // ahb6 system clock6
   .n_hreset6(n_hreset6), // ahb6 system reset

   // ahb2apb6 signals6
   .hresp6(hresp6),
   .hready6(hready6),
   .hrdata6(hrdata6),
   .hwdata6(hwdata6),
   .hprot6(hprot6),
   .hburst6(hburst6),
   .hsize6(hsize6),
   .hwrite6(hwrite6),
   .htrans6(htrans6),
   .haddr6(haddr6),
   .ahb2apb_hsel6(ahb2apb1_hsel6));



//------------------------------------------------------------------------------
// AHB6 interface formal6 verification6 monitor6
//------------------------------------------------------------------------------

defparam i_ahbSlaveMonitor6.DBUS_WIDTH6 = 32;
defparam i_ahbMasterMonitor6.DBUS_WIDTH6 = 32;


// AHB2APB6 Bridge6

    ahb_liteslave_monitor6 i_ahbSlaveMonitor6 (
        .hclk_i6(hclk6),
        .hresetn_i6(n_hreset6),
        .hresp6(hresp6),
        .hready6(hready6),
        .hready_global_i6(hready6),
        .hrdata6(hrdata6),
        .hwdata_i6(hwdata6),
        .hburst_i6(hburst6),
        .hsize_i6(hsize6),
        .hwrite_i6(hwrite6),
        .htrans_i6(htrans6),
        .haddr_i6(haddr6),
        .hsel_i6(ahb2apb1_hsel6)
    );


  ahb_litemaster_monitor6 i_ahbMasterMonitor6 (
          .hclk_i6(hclk6),
          .hresetn_i6(n_hreset6),
          .hresp_i6(hresp6),
          .hready_i6(hready6),
          .hrdata_i6(hrdata6),
          .hlock6(1'b0),
          .hwdata6(hwdata6),
          .hprot6(hprot6),
          .hburst6(hburst6),
          .hsize6(hsize6),
          .hwrite6(hwrite6),
          .htrans6(htrans6),
          .haddr6(haddr6)
          );






`endif




endmodule
