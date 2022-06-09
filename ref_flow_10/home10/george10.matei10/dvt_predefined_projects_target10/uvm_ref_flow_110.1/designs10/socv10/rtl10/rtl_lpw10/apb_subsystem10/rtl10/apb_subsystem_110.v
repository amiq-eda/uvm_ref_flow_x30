//File10 name   : apb_subsystem_110.v
//Title10       : 
//Created10     : 1999
//Description10 : 
//Notes10       : 
//----------------------------------------------------------------------
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------

module apb_subsystem_110(
    // AHB10 interface
    hclk10,         
    n_hreset10,     
    hsel10,         
    haddr10,        
    htrans10,       
    hsize10,        
    hwrite10,       
    hwdata10,       
    hready_in10,    
    hburst10,     
    hprot10,      
    hmaster10,    
    hmastlock10,  
    hrdata10,     
    hready10,     
    hresp10,      

    // APB10 interface
    pclk10,       
    n_preset10,  
    paddr10,
    pwrite10,
    penable10,
    pwdata10, 
    
    // MAC010 APB10 ports10
    prdata_mac010,
    psel_mac010,
    pready_mac010,
    
    // MAC110 APB10 ports10
    prdata_mac110,
    psel_mac110,
    pready_mac110,
    
    // MAC210 APB10 ports10
    prdata_mac210,
    psel_mac210,
    pready_mac210,
    
    // MAC310 APB10 ports10
    prdata_mac310,
    psel_mac310,
    pready_mac310
);

// AHB10 interface
input         hclk10;     
input         n_hreset10; 
input         hsel10;     
input [31:0]  haddr10;    
input [1:0]   htrans10;   
input [2:0]   hsize10;    
input [31:0]  hwdata10;   
input         hwrite10;   
input         hready_in10;
input [2:0]   hburst10;   
input [3:0]   hprot10;    
input [3:0]   hmaster10;  
input         hmastlock10;
output [31:0] hrdata10;
output        hready10;
output [1:0]  hresp10; 

// APB10 interface
input         pclk10;     
input         n_preset10; 
output [31:0] paddr10;
output   	    pwrite10;
output   	    penable10;
output [31:0] pwdata10;

// MAC010 APB10 ports10
input [31:0] prdata_mac010;
output	     psel_mac010;
input        pready_mac010;

// MAC110 APB10 ports10
input [31:0] prdata_mac110;
output	     psel_mac110;
input        pready_mac110;

// MAC210 APB10 ports10
input [31:0] prdata_mac210;
output	     psel_mac210;
input        pready_mac210;

// MAC310 APB10 ports10
input [31:0] prdata_mac310;
output	     psel_mac310;
input        pready_mac310;

wire  [31:0] prdata_alut10;

assign tie_hi_bit10 = 1'b1;

ahb2apb10 #(
  32'h00A00000, // Slave10 0 Address Range10
  32'h00A0FFFF,

  32'h00A10000, // Slave10 1 Address Range10
  32'h00A1FFFF,

  32'h00A20000, // Slave10 2 Address Range10 
  32'h00A2FFFF,

  32'h00A30000, // Slave10 3 Address Range10
  32'h00A3FFFF,

  32'h00A40000, // Slave10 4 Address Range10
  32'h00A4FFFF
) i_ahb2apb10 (
     // AHB10 interface
    .hclk10(hclk10),         
    .hreset_n10(n_hreset10), 
    .hsel10(hsel10), 
    .haddr10(haddr10),        
    .htrans10(htrans10),       
    .hwrite10(hwrite10),       
    .hwdata10(hwdata10),       
    .hrdata10(hrdata10),   
    .hready10(hready10),   
    .hresp10(hresp10),     
    
     // APB10 interface
    .pclk10(pclk10),         
    .preset_n10(n_preset10),  
    .prdata010(prdata_alut10),
    .prdata110(prdata_mac010), 
    .prdata210(prdata_mac110),  
    .prdata310(prdata_mac210),   
    .prdata410(prdata_mac310),   
    .prdata510(32'h0),   
    .prdata610(32'h0),    
    .prdata710(32'h0),   
    .prdata810(32'h0),  
    .pready010(tie_hi_bit10),     
    .pready110(pready_mac010),   
    .pready210(pready_mac110),     
    .pready310(pready_mac210),     
    .pready410(pready_mac310),     
    .pready510(tie_hi_bit10),     
    .pready610(tie_hi_bit10),     
    .pready710(tie_hi_bit10),     
    .pready810(tie_hi_bit10),  
    .pwdata10(pwdata10),       
    .pwrite10(pwrite10),       
    .paddr10(paddr10),        
    .psel010(psel_alut10),     
    .psel110(psel_mac010),   
    .psel210(psel_mac110),    
    .psel310(psel_mac210),     
    .psel410(psel_mac310),     
    .psel510(),     
    .psel610(),    
    .psel710(),   
    .psel810(),  
    .penable10(penable10)     
);

alut_veneer10 i_alut_veneer10 (
        //inputs10
        . n_p_reset10(n_preset10),
        . pclk10(pclk10),
        . psel10(psel_alut10),
        . penable10(penable10),
        . pwrite10(pwrite10),
        . paddr10(paddr10[6:0]),
        . pwdata10(pwdata10),

        //outputs10
        . prdata10(prdata_alut10)
);

//------------------------------------------------------------------------------
// APB10 and AHB10 interface formal10 verification10 monitors10
//------------------------------------------------------------------------------
`ifdef ABV_ON10
apb_assert10 i_apb_assert10 (

   // APB10 signals10
  	.n_preset10(n_preset10),
  	.pclk10(pclk10),
	.penable10(penable10),
	.paddr10(paddr10),
	.pwrite10(pwrite10),
	.pwdata10(pwdata10),

  .psel0010(psel_alut10),
	.psel0110(psel_mac010),
	.psel0210(psel_mac110),
	.psel0310(psel_mac210),
	.psel0410(psel_mac310),
	.psel0510(psel0510),
	.psel0610(psel0610),
	.psel0710(psel0710),
	.psel0810(psel0810),
	.psel0910(psel0910),
	.psel1010(psel1010),
	.psel1110(psel1110),
	.psel1210(psel1210),
	.psel1310(psel1310),
	.psel1410(psel1410),
	.psel1510(psel1510),

   .prdata0010(prdata_alut10), // Read Data from peripheral10 ALUT10

   // AHB10 signals10
   .hclk10(hclk10),         // ahb10 system clock10
   .n_hreset10(n_hreset10), // ahb10 system reset

   // ahb2apb10 signals10
   .hresp10(hresp10),
   .hready10(hready10),
   .hrdata10(hrdata10),
   .hwdata10(hwdata10),
   .hprot10(hprot10),
   .hburst10(hburst10),
   .hsize10(hsize10),
   .hwrite10(hwrite10),
   .htrans10(htrans10),
   .haddr10(haddr10),
   .ahb2apb_hsel10(ahb2apb1_hsel10));



//------------------------------------------------------------------------------
// AHB10 interface formal10 verification10 monitor10
//------------------------------------------------------------------------------

defparam i_ahbSlaveMonitor10.DBUS_WIDTH10 = 32;
defparam i_ahbMasterMonitor10.DBUS_WIDTH10 = 32;


// AHB2APB10 Bridge10

    ahb_liteslave_monitor10 i_ahbSlaveMonitor10 (
        .hclk_i10(hclk10),
        .hresetn_i10(n_hreset10),
        .hresp10(hresp10),
        .hready10(hready10),
        .hready_global_i10(hready10),
        .hrdata10(hrdata10),
        .hwdata_i10(hwdata10),
        .hburst_i10(hburst10),
        .hsize_i10(hsize10),
        .hwrite_i10(hwrite10),
        .htrans_i10(htrans10),
        .haddr_i10(haddr10),
        .hsel_i10(ahb2apb1_hsel10)
    );


  ahb_litemaster_monitor10 i_ahbMasterMonitor10 (
          .hclk_i10(hclk10),
          .hresetn_i10(n_hreset10),
          .hresp_i10(hresp10),
          .hready_i10(hready10),
          .hrdata_i10(hrdata10),
          .hlock10(1'b0),
          .hwdata10(hwdata10),
          .hprot10(hprot10),
          .hburst10(hburst10),
          .hsize10(hsize10),
          .hwrite10(hwrite10),
          .htrans10(htrans10),
          .haddr10(haddr10)
          );






`endif




endmodule
