//File30 name   : apb_subsystem_130.v
//Title30       : 
//Created30     : 1999
//Description30 : 
//Notes30       : 
//----------------------------------------------------------------------
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------

module apb_subsystem_130(
    // AHB30 interface
    hclk30,         
    n_hreset30,     
    hsel30,         
    haddr30,        
    htrans30,       
    hsize30,        
    hwrite30,       
    hwdata30,       
    hready_in30,    
    hburst30,     
    hprot30,      
    hmaster30,    
    hmastlock30,  
    hrdata30,     
    hready30,     
    hresp30,      

    // APB30 interface
    pclk30,       
    n_preset30,  
    paddr30,
    pwrite30,
    penable30,
    pwdata30, 
    
    // MAC030 APB30 ports30
    prdata_mac030,
    psel_mac030,
    pready_mac030,
    
    // MAC130 APB30 ports30
    prdata_mac130,
    psel_mac130,
    pready_mac130,
    
    // MAC230 APB30 ports30
    prdata_mac230,
    psel_mac230,
    pready_mac230,
    
    // MAC330 APB30 ports30
    prdata_mac330,
    psel_mac330,
    pready_mac330
);

// AHB30 interface
input         hclk30;     
input         n_hreset30; 
input         hsel30;     
input [31:0]  haddr30;    
input [1:0]   htrans30;   
input [2:0]   hsize30;    
input [31:0]  hwdata30;   
input         hwrite30;   
input         hready_in30;
input [2:0]   hburst30;   
input [3:0]   hprot30;    
input [3:0]   hmaster30;  
input         hmastlock30;
output [31:0] hrdata30;
output        hready30;
output [1:0]  hresp30; 

// APB30 interface
input         pclk30;     
input         n_preset30; 
output [31:0] paddr30;
output   	    pwrite30;
output   	    penable30;
output [31:0] pwdata30;

// MAC030 APB30 ports30
input [31:0] prdata_mac030;
output	     psel_mac030;
input        pready_mac030;

// MAC130 APB30 ports30
input [31:0] prdata_mac130;
output	     psel_mac130;
input        pready_mac130;

// MAC230 APB30 ports30
input [31:0] prdata_mac230;
output	     psel_mac230;
input        pready_mac230;

// MAC330 APB30 ports30
input [31:0] prdata_mac330;
output	     psel_mac330;
input        pready_mac330;

wire  [31:0] prdata_alut30;

assign tie_hi_bit30 = 1'b1;

ahb2apb30 #(
  32'h00A00000, // Slave30 0 Address Range30
  32'h00A0FFFF,

  32'h00A10000, // Slave30 1 Address Range30
  32'h00A1FFFF,

  32'h00A20000, // Slave30 2 Address Range30 
  32'h00A2FFFF,

  32'h00A30000, // Slave30 3 Address Range30
  32'h00A3FFFF,

  32'h00A40000, // Slave30 4 Address Range30
  32'h00A4FFFF
) i_ahb2apb30 (
     // AHB30 interface
    .hclk30(hclk30),         
    .hreset_n30(n_hreset30), 
    .hsel30(hsel30), 
    .haddr30(haddr30),        
    .htrans30(htrans30),       
    .hwrite30(hwrite30),       
    .hwdata30(hwdata30),       
    .hrdata30(hrdata30),   
    .hready30(hready30),   
    .hresp30(hresp30),     
    
     // APB30 interface
    .pclk30(pclk30),         
    .preset_n30(n_preset30),  
    .prdata030(prdata_alut30),
    .prdata130(prdata_mac030), 
    .prdata230(prdata_mac130),  
    .prdata330(prdata_mac230),   
    .prdata430(prdata_mac330),   
    .prdata530(32'h0),   
    .prdata630(32'h0),    
    .prdata730(32'h0),   
    .prdata830(32'h0),  
    .pready030(tie_hi_bit30),     
    .pready130(pready_mac030),   
    .pready230(pready_mac130),     
    .pready330(pready_mac230),     
    .pready430(pready_mac330),     
    .pready530(tie_hi_bit30),     
    .pready630(tie_hi_bit30),     
    .pready730(tie_hi_bit30),     
    .pready830(tie_hi_bit30),  
    .pwdata30(pwdata30),       
    .pwrite30(pwrite30),       
    .paddr30(paddr30),        
    .psel030(psel_alut30),     
    .psel130(psel_mac030),   
    .psel230(psel_mac130),    
    .psel330(psel_mac230),     
    .psel430(psel_mac330),     
    .psel530(),     
    .psel630(),    
    .psel730(),   
    .psel830(),  
    .penable30(penable30)     
);

alut_veneer30 i_alut_veneer30 (
        //inputs30
        . n_p_reset30(n_preset30),
        . pclk30(pclk30),
        . psel30(psel_alut30),
        . penable30(penable30),
        . pwrite30(pwrite30),
        . paddr30(paddr30[6:0]),
        . pwdata30(pwdata30),

        //outputs30
        . prdata30(prdata_alut30)
);

//------------------------------------------------------------------------------
// APB30 and AHB30 interface formal30 verification30 monitors30
//------------------------------------------------------------------------------
`ifdef ABV_ON30
apb_assert30 i_apb_assert30 (

   // APB30 signals30
  	.n_preset30(n_preset30),
  	.pclk30(pclk30),
	.penable30(penable30),
	.paddr30(paddr30),
	.pwrite30(pwrite30),
	.pwdata30(pwdata30),

  .psel0030(psel_alut30),
	.psel0130(psel_mac030),
	.psel0230(psel_mac130),
	.psel0330(psel_mac230),
	.psel0430(psel_mac330),
	.psel0530(psel0530),
	.psel0630(psel0630),
	.psel0730(psel0730),
	.psel0830(psel0830),
	.psel0930(psel0930),
	.psel1030(psel1030),
	.psel1130(psel1130),
	.psel1230(psel1230),
	.psel1330(psel1330),
	.psel1430(psel1430),
	.psel1530(psel1530),

   .prdata0030(prdata_alut30), // Read Data from peripheral30 ALUT30

   // AHB30 signals30
   .hclk30(hclk30),         // ahb30 system clock30
   .n_hreset30(n_hreset30), // ahb30 system reset

   // ahb2apb30 signals30
   .hresp30(hresp30),
   .hready30(hready30),
   .hrdata30(hrdata30),
   .hwdata30(hwdata30),
   .hprot30(hprot30),
   .hburst30(hburst30),
   .hsize30(hsize30),
   .hwrite30(hwrite30),
   .htrans30(htrans30),
   .haddr30(haddr30),
   .ahb2apb_hsel30(ahb2apb1_hsel30));



//------------------------------------------------------------------------------
// AHB30 interface formal30 verification30 monitor30
//------------------------------------------------------------------------------

defparam i_ahbSlaveMonitor30.DBUS_WIDTH30 = 32;
defparam i_ahbMasterMonitor30.DBUS_WIDTH30 = 32;


// AHB2APB30 Bridge30

    ahb_liteslave_monitor30 i_ahbSlaveMonitor30 (
        .hclk_i30(hclk30),
        .hresetn_i30(n_hreset30),
        .hresp30(hresp30),
        .hready30(hready30),
        .hready_global_i30(hready30),
        .hrdata30(hrdata30),
        .hwdata_i30(hwdata30),
        .hburst_i30(hburst30),
        .hsize_i30(hsize30),
        .hwrite_i30(hwrite30),
        .htrans_i30(htrans30),
        .haddr_i30(haddr30),
        .hsel_i30(ahb2apb1_hsel30)
    );


  ahb_litemaster_monitor30 i_ahbMasterMonitor30 (
          .hclk_i30(hclk30),
          .hresetn_i30(n_hreset30),
          .hresp_i30(hresp30),
          .hready_i30(hready30),
          .hrdata_i30(hrdata30),
          .hlock30(1'b0),
          .hwdata30(hwdata30),
          .hprot30(hprot30),
          .hburst30(hburst30),
          .hsize30(hsize30),
          .hwrite30(hwrite30),
          .htrans30(htrans30),
          .haddr30(haddr30)
          );






`endif




endmodule
