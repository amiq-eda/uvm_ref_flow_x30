//File23 name   : apb_subsystem_123.v
//Title23       : 
//Created23     : 1999
//Description23 : 
//Notes23       : 
//----------------------------------------------------------------------
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------

module apb_subsystem_123(
    // AHB23 interface
    hclk23,         
    n_hreset23,     
    hsel23,         
    haddr23,        
    htrans23,       
    hsize23,        
    hwrite23,       
    hwdata23,       
    hready_in23,    
    hburst23,     
    hprot23,      
    hmaster23,    
    hmastlock23,  
    hrdata23,     
    hready23,     
    hresp23,      

    // APB23 interface
    pclk23,       
    n_preset23,  
    paddr23,
    pwrite23,
    penable23,
    pwdata23, 
    
    // MAC023 APB23 ports23
    prdata_mac023,
    psel_mac023,
    pready_mac023,
    
    // MAC123 APB23 ports23
    prdata_mac123,
    psel_mac123,
    pready_mac123,
    
    // MAC223 APB23 ports23
    prdata_mac223,
    psel_mac223,
    pready_mac223,
    
    // MAC323 APB23 ports23
    prdata_mac323,
    psel_mac323,
    pready_mac323
);

// AHB23 interface
input         hclk23;     
input         n_hreset23; 
input         hsel23;     
input [31:0]  haddr23;    
input [1:0]   htrans23;   
input [2:0]   hsize23;    
input [31:0]  hwdata23;   
input         hwrite23;   
input         hready_in23;
input [2:0]   hburst23;   
input [3:0]   hprot23;    
input [3:0]   hmaster23;  
input         hmastlock23;
output [31:0] hrdata23;
output        hready23;
output [1:0]  hresp23; 

// APB23 interface
input         pclk23;     
input         n_preset23; 
output [31:0] paddr23;
output   	    pwrite23;
output   	    penable23;
output [31:0] pwdata23;

// MAC023 APB23 ports23
input [31:0] prdata_mac023;
output	     psel_mac023;
input        pready_mac023;

// MAC123 APB23 ports23
input [31:0] prdata_mac123;
output	     psel_mac123;
input        pready_mac123;

// MAC223 APB23 ports23
input [31:0] prdata_mac223;
output	     psel_mac223;
input        pready_mac223;

// MAC323 APB23 ports23
input [31:0] prdata_mac323;
output	     psel_mac323;
input        pready_mac323;

wire  [31:0] prdata_alut23;

assign tie_hi_bit23 = 1'b1;

ahb2apb23 #(
  32'h00A00000, // Slave23 0 Address Range23
  32'h00A0FFFF,

  32'h00A10000, // Slave23 1 Address Range23
  32'h00A1FFFF,

  32'h00A20000, // Slave23 2 Address Range23 
  32'h00A2FFFF,

  32'h00A30000, // Slave23 3 Address Range23
  32'h00A3FFFF,

  32'h00A40000, // Slave23 4 Address Range23
  32'h00A4FFFF
) i_ahb2apb23 (
     // AHB23 interface
    .hclk23(hclk23),         
    .hreset_n23(n_hreset23), 
    .hsel23(hsel23), 
    .haddr23(haddr23),        
    .htrans23(htrans23),       
    .hwrite23(hwrite23),       
    .hwdata23(hwdata23),       
    .hrdata23(hrdata23),   
    .hready23(hready23),   
    .hresp23(hresp23),     
    
     // APB23 interface
    .pclk23(pclk23),         
    .preset_n23(n_preset23),  
    .prdata023(prdata_alut23),
    .prdata123(prdata_mac023), 
    .prdata223(prdata_mac123),  
    .prdata323(prdata_mac223),   
    .prdata423(prdata_mac323),   
    .prdata523(32'h0),   
    .prdata623(32'h0),    
    .prdata723(32'h0),   
    .prdata823(32'h0),  
    .pready023(tie_hi_bit23),     
    .pready123(pready_mac023),   
    .pready223(pready_mac123),     
    .pready323(pready_mac223),     
    .pready423(pready_mac323),     
    .pready523(tie_hi_bit23),     
    .pready623(tie_hi_bit23),     
    .pready723(tie_hi_bit23),     
    .pready823(tie_hi_bit23),  
    .pwdata23(pwdata23),       
    .pwrite23(pwrite23),       
    .paddr23(paddr23),        
    .psel023(psel_alut23),     
    .psel123(psel_mac023),   
    .psel223(psel_mac123),    
    .psel323(psel_mac223),     
    .psel423(psel_mac323),     
    .psel523(),     
    .psel623(),    
    .psel723(),   
    .psel823(),  
    .penable23(penable23)     
);

alut_veneer23 i_alut_veneer23 (
        //inputs23
        . n_p_reset23(n_preset23),
        . pclk23(pclk23),
        . psel23(psel_alut23),
        . penable23(penable23),
        . pwrite23(pwrite23),
        . paddr23(paddr23[6:0]),
        . pwdata23(pwdata23),

        //outputs23
        . prdata23(prdata_alut23)
);

//------------------------------------------------------------------------------
// APB23 and AHB23 interface formal23 verification23 monitors23
//------------------------------------------------------------------------------
`ifdef ABV_ON23
apb_assert23 i_apb_assert23 (

   // APB23 signals23
  	.n_preset23(n_preset23),
  	.pclk23(pclk23),
	.penable23(penable23),
	.paddr23(paddr23),
	.pwrite23(pwrite23),
	.pwdata23(pwdata23),

  .psel0023(psel_alut23),
	.psel0123(psel_mac023),
	.psel0223(psel_mac123),
	.psel0323(psel_mac223),
	.psel0423(psel_mac323),
	.psel0523(psel0523),
	.psel0623(psel0623),
	.psel0723(psel0723),
	.psel0823(psel0823),
	.psel0923(psel0923),
	.psel1023(psel1023),
	.psel1123(psel1123),
	.psel1223(psel1223),
	.psel1323(psel1323),
	.psel1423(psel1423),
	.psel1523(psel1523),

   .prdata0023(prdata_alut23), // Read Data from peripheral23 ALUT23

   // AHB23 signals23
   .hclk23(hclk23),         // ahb23 system clock23
   .n_hreset23(n_hreset23), // ahb23 system reset

   // ahb2apb23 signals23
   .hresp23(hresp23),
   .hready23(hready23),
   .hrdata23(hrdata23),
   .hwdata23(hwdata23),
   .hprot23(hprot23),
   .hburst23(hburst23),
   .hsize23(hsize23),
   .hwrite23(hwrite23),
   .htrans23(htrans23),
   .haddr23(haddr23),
   .ahb2apb_hsel23(ahb2apb1_hsel23));



//------------------------------------------------------------------------------
// AHB23 interface formal23 verification23 monitor23
//------------------------------------------------------------------------------

defparam i_ahbSlaveMonitor23.DBUS_WIDTH23 = 32;
defparam i_ahbMasterMonitor23.DBUS_WIDTH23 = 32;


// AHB2APB23 Bridge23

    ahb_liteslave_monitor23 i_ahbSlaveMonitor23 (
        .hclk_i23(hclk23),
        .hresetn_i23(n_hreset23),
        .hresp23(hresp23),
        .hready23(hready23),
        .hready_global_i23(hready23),
        .hrdata23(hrdata23),
        .hwdata_i23(hwdata23),
        .hburst_i23(hburst23),
        .hsize_i23(hsize23),
        .hwrite_i23(hwrite23),
        .htrans_i23(htrans23),
        .haddr_i23(haddr23),
        .hsel_i23(ahb2apb1_hsel23)
    );


  ahb_litemaster_monitor23 i_ahbMasterMonitor23 (
          .hclk_i23(hclk23),
          .hresetn_i23(n_hreset23),
          .hresp_i23(hresp23),
          .hready_i23(hready23),
          .hrdata_i23(hrdata23),
          .hlock23(1'b0),
          .hwdata23(hwdata23),
          .hprot23(hprot23),
          .hburst23(hburst23),
          .hsize23(hsize23),
          .hwrite23(hwrite23),
          .htrans23(htrans23),
          .haddr23(haddr23)
          );






`endif




endmodule
