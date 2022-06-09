//File27 name   : apb_subsystem_127.v
//Title27       : 
//Created27     : 1999
//Description27 : 
//Notes27       : 
//----------------------------------------------------------------------
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------

module apb_subsystem_127(
    // AHB27 interface
    hclk27,         
    n_hreset27,     
    hsel27,         
    haddr27,        
    htrans27,       
    hsize27,        
    hwrite27,       
    hwdata27,       
    hready_in27,    
    hburst27,     
    hprot27,      
    hmaster27,    
    hmastlock27,  
    hrdata27,     
    hready27,     
    hresp27,      

    // APB27 interface
    pclk27,       
    n_preset27,  
    paddr27,
    pwrite27,
    penable27,
    pwdata27, 
    
    // MAC027 APB27 ports27
    prdata_mac027,
    psel_mac027,
    pready_mac027,
    
    // MAC127 APB27 ports27
    prdata_mac127,
    psel_mac127,
    pready_mac127,
    
    // MAC227 APB27 ports27
    prdata_mac227,
    psel_mac227,
    pready_mac227,
    
    // MAC327 APB27 ports27
    prdata_mac327,
    psel_mac327,
    pready_mac327
);

// AHB27 interface
input         hclk27;     
input         n_hreset27; 
input         hsel27;     
input [31:0]  haddr27;    
input [1:0]   htrans27;   
input [2:0]   hsize27;    
input [31:0]  hwdata27;   
input         hwrite27;   
input         hready_in27;
input [2:0]   hburst27;   
input [3:0]   hprot27;    
input [3:0]   hmaster27;  
input         hmastlock27;
output [31:0] hrdata27;
output        hready27;
output [1:0]  hresp27; 

// APB27 interface
input         pclk27;     
input         n_preset27; 
output [31:0] paddr27;
output   	    pwrite27;
output   	    penable27;
output [31:0] pwdata27;

// MAC027 APB27 ports27
input [31:0] prdata_mac027;
output	     psel_mac027;
input        pready_mac027;

// MAC127 APB27 ports27
input [31:0] prdata_mac127;
output	     psel_mac127;
input        pready_mac127;

// MAC227 APB27 ports27
input [31:0] prdata_mac227;
output	     psel_mac227;
input        pready_mac227;

// MAC327 APB27 ports27
input [31:0] prdata_mac327;
output	     psel_mac327;
input        pready_mac327;

wire  [31:0] prdata_alut27;

assign tie_hi_bit27 = 1'b1;

ahb2apb27 #(
  32'h00A00000, // Slave27 0 Address Range27
  32'h00A0FFFF,

  32'h00A10000, // Slave27 1 Address Range27
  32'h00A1FFFF,

  32'h00A20000, // Slave27 2 Address Range27 
  32'h00A2FFFF,

  32'h00A30000, // Slave27 3 Address Range27
  32'h00A3FFFF,

  32'h00A40000, // Slave27 4 Address Range27
  32'h00A4FFFF
) i_ahb2apb27 (
     // AHB27 interface
    .hclk27(hclk27),         
    .hreset_n27(n_hreset27), 
    .hsel27(hsel27), 
    .haddr27(haddr27),        
    .htrans27(htrans27),       
    .hwrite27(hwrite27),       
    .hwdata27(hwdata27),       
    .hrdata27(hrdata27),   
    .hready27(hready27),   
    .hresp27(hresp27),     
    
     // APB27 interface
    .pclk27(pclk27),         
    .preset_n27(n_preset27),  
    .prdata027(prdata_alut27),
    .prdata127(prdata_mac027), 
    .prdata227(prdata_mac127),  
    .prdata327(prdata_mac227),   
    .prdata427(prdata_mac327),   
    .prdata527(32'h0),   
    .prdata627(32'h0),    
    .prdata727(32'h0),   
    .prdata827(32'h0),  
    .pready027(tie_hi_bit27),     
    .pready127(pready_mac027),   
    .pready227(pready_mac127),     
    .pready327(pready_mac227),     
    .pready427(pready_mac327),     
    .pready527(tie_hi_bit27),     
    .pready627(tie_hi_bit27),     
    .pready727(tie_hi_bit27),     
    .pready827(tie_hi_bit27),  
    .pwdata27(pwdata27),       
    .pwrite27(pwrite27),       
    .paddr27(paddr27),        
    .psel027(psel_alut27),     
    .psel127(psel_mac027),   
    .psel227(psel_mac127),    
    .psel327(psel_mac227),     
    .psel427(psel_mac327),     
    .psel527(),     
    .psel627(),    
    .psel727(),   
    .psel827(),  
    .penable27(penable27)     
);

alut_veneer27 i_alut_veneer27 (
        //inputs27
        . n_p_reset27(n_preset27),
        . pclk27(pclk27),
        . psel27(psel_alut27),
        . penable27(penable27),
        . pwrite27(pwrite27),
        . paddr27(paddr27[6:0]),
        . pwdata27(pwdata27),

        //outputs27
        . prdata27(prdata_alut27)
);

//------------------------------------------------------------------------------
// APB27 and AHB27 interface formal27 verification27 monitors27
//------------------------------------------------------------------------------
`ifdef ABV_ON27
apb_assert27 i_apb_assert27 (

   // APB27 signals27
  	.n_preset27(n_preset27),
  	.pclk27(pclk27),
	.penable27(penable27),
	.paddr27(paddr27),
	.pwrite27(pwrite27),
	.pwdata27(pwdata27),

  .psel0027(psel_alut27),
	.psel0127(psel_mac027),
	.psel0227(psel_mac127),
	.psel0327(psel_mac227),
	.psel0427(psel_mac327),
	.psel0527(psel0527),
	.psel0627(psel0627),
	.psel0727(psel0727),
	.psel0827(psel0827),
	.psel0927(psel0927),
	.psel1027(psel1027),
	.psel1127(psel1127),
	.psel1227(psel1227),
	.psel1327(psel1327),
	.psel1427(psel1427),
	.psel1527(psel1527),

   .prdata0027(prdata_alut27), // Read Data from peripheral27 ALUT27

   // AHB27 signals27
   .hclk27(hclk27),         // ahb27 system clock27
   .n_hreset27(n_hreset27), // ahb27 system reset

   // ahb2apb27 signals27
   .hresp27(hresp27),
   .hready27(hready27),
   .hrdata27(hrdata27),
   .hwdata27(hwdata27),
   .hprot27(hprot27),
   .hburst27(hburst27),
   .hsize27(hsize27),
   .hwrite27(hwrite27),
   .htrans27(htrans27),
   .haddr27(haddr27),
   .ahb2apb_hsel27(ahb2apb1_hsel27));



//------------------------------------------------------------------------------
// AHB27 interface formal27 verification27 monitor27
//------------------------------------------------------------------------------

defparam i_ahbSlaveMonitor27.DBUS_WIDTH27 = 32;
defparam i_ahbMasterMonitor27.DBUS_WIDTH27 = 32;


// AHB2APB27 Bridge27

    ahb_liteslave_monitor27 i_ahbSlaveMonitor27 (
        .hclk_i27(hclk27),
        .hresetn_i27(n_hreset27),
        .hresp27(hresp27),
        .hready27(hready27),
        .hready_global_i27(hready27),
        .hrdata27(hrdata27),
        .hwdata_i27(hwdata27),
        .hburst_i27(hburst27),
        .hsize_i27(hsize27),
        .hwrite_i27(hwrite27),
        .htrans_i27(htrans27),
        .haddr_i27(haddr27),
        .hsel_i27(ahb2apb1_hsel27)
    );


  ahb_litemaster_monitor27 i_ahbMasterMonitor27 (
          .hclk_i27(hclk27),
          .hresetn_i27(n_hreset27),
          .hresp_i27(hresp27),
          .hready_i27(hready27),
          .hrdata_i27(hrdata27),
          .hlock27(1'b0),
          .hwdata27(hwdata27),
          .hprot27(hprot27),
          .hburst27(hburst27),
          .hsize27(hsize27),
          .hwrite27(hwrite27),
          .htrans27(htrans27),
          .haddr27(haddr27)
          );






`endif




endmodule
