//File25 name   : apb_subsystem_125.v
//Title25       : 
//Created25     : 1999
//Description25 : 
//Notes25       : 
//----------------------------------------------------------------------
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------

module apb_subsystem_125(
    // AHB25 interface
    hclk25,         
    n_hreset25,     
    hsel25,         
    haddr25,        
    htrans25,       
    hsize25,        
    hwrite25,       
    hwdata25,       
    hready_in25,    
    hburst25,     
    hprot25,      
    hmaster25,    
    hmastlock25,  
    hrdata25,     
    hready25,     
    hresp25,      

    // APB25 interface
    pclk25,       
    n_preset25,  
    paddr25,
    pwrite25,
    penable25,
    pwdata25, 
    
    // MAC025 APB25 ports25
    prdata_mac025,
    psel_mac025,
    pready_mac025,
    
    // MAC125 APB25 ports25
    prdata_mac125,
    psel_mac125,
    pready_mac125,
    
    // MAC225 APB25 ports25
    prdata_mac225,
    psel_mac225,
    pready_mac225,
    
    // MAC325 APB25 ports25
    prdata_mac325,
    psel_mac325,
    pready_mac325
);

// AHB25 interface
input         hclk25;     
input         n_hreset25; 
input         hsel25;     
input [31:0]  haddr25;    
input [1:0]   htrans25;   
input [2:0]   hsize25;    
input [31:0]  hwdata25;   
input         hwrite25;   
input         hready_in25;
input [2:0]   hburst25;   
input [3:0]   hprot25;    
input [3:0]   hmaster25;  
input         hmastlock25;
output [31:0] hrdata25;
output        hready25;
output [1:0]  hresp25; 

// APB25 interface
input         pclk25;     
input         n_preset25; 
output [31:0] paddr25;
output   	    pwrite25;
output   	    penable25;
output [31:0] pwdata25;

// MAC025 APB25 ports25
input [31:0] prdata_mac025;
output	     psel_mac025;
input        pready_mac025;

// MAC125 APB25 ports25
input [31:0] prdata_mac125;
output	     psel_mac125;
input        pready_mac125;

// MAC225 APB25 ports25
input [31:0] prdata_mac225;
output	     psel_mac225;
input        pready_mac225;

// MAC325 APB25 ports25
input [31:0] prdata_mac325;
output	     psel_mac325;
input        pready_mac325;

wire  [31:0] prdata_alut25;

assign tie_hi_bit25 = 1'b1;

ahb2apb25 #(
  32'h00A00000, // Slave25 0 Address Range25
  32'h00A0FFFF,

  32'h00A10000, // Slave25 1 Address Range25
  32'h00A1FFFF,

  32'h00A20000, // Slave25 2 Address Range25 
  32'h00A2FFFF,

  32'h00A30000, // Slave25 3 Address Range25
  32'h00A3FFFF,

  32'h00A40000, // Slave25 4 Address Range25
  32'h00A4FFFF
) i_ahb2apb25 (
     // AHB25 interface
    .hclk25(hclk25),         
    .hreset_n25(n_hreset25), 
    .hsel25(hsel25), 
    .haddr25(haddr25),        
    .htrans25(htrans25),       
    .hwrite25(hwrite25),       
    .hwdata25(hwdata25),       
    .hrdata25(hrdata25),   
    .hready25(hready25),   
    .hresp25(hresp25),     
    
     // APB25 interface
    .pclk25(pclk25),         
    .preset_n25(n_preset25),  
    .prdata025(prdata_alut25),
    .prdata125(prdata_mac025), 
    .prdata225(prdata_mac125),  
    .prdata325(prdata_mac225),   
    .prdata425(prdata_mac325),   
    .prdata525(32'h0),   
    .prdata625(32'h0),    
    .prdata725(32'h0),   
    .prdata825(32'h0),  
    .pready025(tie_hi_bit25),     
    .pready125(pready_mac025),   
    .pready225(pready_mac125),     
    .pready325(pready_mac225),     
    .pready425(pready_mac325),     
    .pready525(tie_hi_bit25),     
    .pready625(tie_hi_bit25),     
    .pready725(tie_hi_bit25),     
    .pready825(tie_hi_bit25),  
    .pwdata25(pwdata25),       
    .pwrite25(pwrite25),       
    .paddr25(paddr25),        
    .psel025(psel_alut25),     
    .psel125(psel_mac025),   
    .psel225(psel_mac125),    
    .psel325(psel_mac225),     
    .psel425(psel_mac325),     
    .psel525(),     
    .psel625(),    
    .psel725(),   
    .psel825(),  
    .penable25(penable25)     
);

alut_veneer25 i_alut_veneer25 (
        //inputs25
        . n_p_reset25(n_preset25),
        . pclk25(pclk25),
        . psel25(psel_alut25),
        . penable25(penable25),
        . pwrite25(pwrite25),
        . paddr25(paddr25[6:0]),
        . pwdata25(pwdata25),

        //outputs25
        . prdata25(prdata_alut25)
);

//------------------------------------------------------------------------------
// APB25 and AHB25 interface formal25 verification25 monitors25
//------------------------------------------------------------------------------
`ifdef ABV_ON25
apb_assert25 i_apb_assert25 (

   // APB25 signals25
  	.n_preset25(n_preset25),
  	.pclk25(pclk25),
	.penable25(penable25),
	.paddr25(paddr25),
	.pwrite25(pwrite25),
	.pwdata25(pwdata25),

  .psel0025(psel_alut25),
	.psel0125(psel_mac025),
	.psel0225(psel_mac125),
	.psel0325(psel_mac225),
	.psel0425(psel_mac325),
	.psel0525(psel0525),
	.psel0625(psel0625),
	.psel0725(psel0725),
	.psel0825(psel0825),
	.psel0925(psel0925),
	.psel1025(psel1025),
	.psel1125(psel1125),
	.psel1225(psel1225),
	.psel1325(psel1325),
	.psel1425(psel1425),
	.psel1525(psel1525),

   .prdata0025(prdata_alut25), // Read Data from peripheral25 ALUT25

   // AHB25 signals25
   .hclk25(hclk25),         // ahb25 system clock25
   .n_hreset25(n_hreset25), // ahb25 system reset

   // ahb2apb25 signals25
   .hresp25(hresp25),
   .hready25(hready25),
   .hrdata25(hrdata25),
   .hwdata25(hwdata25),
   .hprot25(hprot25),
   .hburst25(hburst25),
   .hsize25(hsize25),
   .hwrite25(hwrite25),
   .htrans25(htrans25),
   .haddr25(haddr25),
   .ahb2apb_hsel25(ahb2apb1_hsel25));



//------------------------------------------------------------------------------
// AHB25 interface formal25 verification25 monitor25
//------------------------------------------------------------------------------

defparam i_ahbSlaveMonitor25.DBUS_WIDTH25 = 32;
defparam i_ahbMasterMonitor25.DBUS_WIDTH25 = 32;


// AHB2APB25 Bridge25

    ahb_liteslave_monitor25 i_ahbSlaveMonitor25 (
        .hclk_i25(hclk25),
        .hresetn_i25(n_hreset25),
        .hresp25(hresp25),
        .hready25(hready25),
        .hready_global_i25(hready25),
        .hrdata25(hrdata25),
        .hwdata_i25(hwdata25),
        .hburst_i25(hburst25),
        .hsize_i25(hsize25),
        .hwrite_i25(hwrite25),
        .htrans_i25(htrans25),
        .haddr_i25(haddr25),
        .hsel_i25(ahb2apb1_hsel25)
    );


  ahb_litemaster_monitor25 i_ahbMasterMonitor25 (
          .hclk_i25(hclk25),
          .hresetn_i25(n_hreset25),
          .hresp_i25(hresp25),
          .hready_i25(hready25),
          .hrdata_i25(hrdata25),
          .hlock25(1'b0),
          .hwdata25(hwdata25),
          .hprot25(hprot25),
          .hburst25(hburst25),
          .hsize25(hsize25),
          .hwrite25(hwrite25),
          .htrans25(htrans25),
          .haddr25(haddr25)
          );






`endif




endmodule
