//File5 name   : apb_subsystem_15.v
//Title5       : 
//Created5     : 1999
//Description5 : 
//Notes5       : 
//----------------------------------------------------------------------
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------

module apb_subsystem_15(
    // AHB5 interface
    hclk5,         
    n_hreset5,     
    hsel5,         
    haddr5,        
    htrans5,       
    hsize5,        
    hwrite5,       
    hwdata5,       
    hready_in5,    
    hburst5,     
    hprot5,      
    hmaster5,    
    hmastlock5,  
    hrdata5,     
    hready5,     
    hresp5,      

    // APB5 interface
    pclk5,       
    n_preset5,  
    paddr5,
    pwrite5,
    penable5,
    pwdata5, 
    
    // MAC05 APB5 ports5
    prdata_mac05,
    psel_mac05,
    pready_mac05,
    
    // MAC15 APB5 ports5
    prdata_mac15,
    psel_mac15,
    pready_mac15,
    
    // MAC25 APB5 ports5
    prdata_mac25,
    psel_mac25,
    pready_mac25,
    
    // MAC35 APB5 ports5
    prdata_mac35,
    psel_mac35,
    pready_mac35
);

// AHB5 interface
input         hclk5;     
input         n_hreset5; 
input         hsel5;     
input [31:0]  haddr5;    
input [1:0]   htrans5;   
input [2:0]   hsize5;    
input [31:0]  hwdata5;   
input         hwrite5;   
input         hready_in5;
input [2:0]   hburst5;   
input [3:0]   hprot5;    
input [3:0]   hmaster5;  
input         hmastlock5;
output [31:0] hrdata5;
output        hready5;
output [1:0]  hresp5; 

// APB5 interface
input         pclk5;     
input         n_preset5; 
output [31:0] paddr5;
output   	    pwrite5;
output   	    penable5;
output [31:0] pwdata5;

// MAC05 APB5 ports5
input [31:0] prdata_mac05;
output	     psel_mac05;
input        pready_mac05;

// MAC15 APB5 ports5
input [31:0] prdata_mac15;
output	     psel_mac15;
input        pready_mac15;

// MAC25 APB5 ports5
input [31:0] prdata_mac25;
output	     psel_mac25;
input        pready_mac25;

// MAC35 APB5 ports5
input [31:0] prdata_mac35;
output	     psel_mac35;
input        pready_mac35;

wire  [31:0] prdata_alut5;

assign tie_hi_bit5 = 1'b1;

ahb2apb5 #(
  32'h00A00000, // Slave5 0 Address Range5
  32'h00A0FFFF,

  32'h00A10000, // Slave5 1 Address Range5
  32'h00A1FFFF,

  32'h00A20000, // Slave5 2 Address Range5 
  32'h00A2FFFF,

  32'h00A30000, // Slave5 3 Address Range5
  32'h00A3FFFF,

  32'h00A40000, // Slave5 4 Address Range5
  32'h00A4FFFF
) i_ahb2apb5 (
     // AHB5 interface
    .hclk5(hclk5),         
    .hreset_n5(n_hreset5), 
    .hsel5(hsel5), 
    .haddr5(haddr5),        
    .htrans5(htrans5),       
    .hwrite5(hwrite5),       
    .hwdata5(hwdata5),       
    .hrdata5(hrdata5),   
    .hready5(hready5),   
    .hresp5(hresp5),     
    
     // APB5 interface
    .pclk5(pclk5),         
    .preset_n5(n_preset5),  
    .prdata05(prdata_alut5),
    .prdata15(prdata_mac05), 
    .prdata25(prdata_mac15),  
    .prdata35(prdata_mac25),   
    .prdata45(prdata_mac35),   
    .prdata55(32'h0),   
    .prdata65(32'h0),    
    .prdata75(32'h0),   
    .prdata85(32'h0),  
    .pready05(tie_hi_bit5),     
    .pready15(pready_mac05),   
    .pready25(pready_mac15),     
    .pready35(pready_mac25),     
    .pready45(pready_mac35),     
    .pready55(tie_hi_bit5),     
    .pready65(tie_hi_bit5),     
    .pready75(tie_hi_bit5),     
    .pready85(tie_hi_bit5),  
    .pwdata5(pwdata5),       
    .pwrite5(pwrite5),       
    .paddr5(paddr5),        
    .psel05(psel_alut5),     
    .psel15(psel_mac05),   
    .psel25(psel_mac15),    
    .psel35(psel_mac25),     
    .psel45(psel_mac35),     
    .psel55(),     
    .psel65(),    
    .psel75(),   
    .psel85(),  
    .penable5(penable5)     
);

alut_veneer5 i_alut_veneer5 (
        //inputs5
        . n_p_reset5(n_preset5),
        . pclk5(pclk5),
        . psel5(psel_alut5),
        . penable5(penable5),
        . pwrite5(pwrite5),
        . paddr5(paddr5[6:0]),
        . pwdata5(pwdata5),

        //outputs5
        . prdata5(prdata_alut5)
);

//------------------------------------------------------------------------------
// APB5 and AHB5 interface formal5 verification5 monitors5
//------------------------------------------------------------------------------
`ifdef ABV_ON5
apb_assert5 i_apb_assert5 (

   // APB5 signals5
  	.n_preset5(n_preset5),
  	.pclk5(pclk5),
	.penable5(penable5),
	.paddr5(paddr5),
	.pwrite5(pwrite5),
	.pwdata5(pwdata5),

  .psel005(psel_alut5),
	.psel015(psel_mac05),
	.psel025(psel_mac15),
	.psel035(psel_mac25),
	.psel045(psel_mac35),
	.psel055(psel055),
	.psel065(psel065),
	.psel075(psel075),
	.psel085(psel085),
	.psel095(psel095),
	.psel105(psel105),
	.psel115(psel115),
	.psel125(psel125),
	.psel135(psel135),
	.psel145(psel145),
	.psel155(psel155),

   .prdata005(prdata_alut5), // Read Data from peripheral5 ALUT5

   // AHB5 signals5
   .hclk5(hclk5),         // ahb5 system clock5
   .n_hreset5(n_hreset5), // ahb5 system reset

   // ahb2apb5 signals5
   .hresp5(hresp5),
   .hready5(hready5),
   .hrdata5(hrdata5),
   .hwdata5(hwdata5),
   .hprot5(hprot5),
   .hburst5(hburst5),
   .hsize5(hsize5),
   .hwrite5(hwrite5),
   .htrans5(htrans5),
   .haddr5(haddr5),
   .ahb2apb_hsel5(ahb2apb1_hsel5));



//------------------------------------------------------------------------------
// AHB5 interface formal5 verification5 monitor5
//------------------------------------------------------------------------------

defparam i_ahbSlaveMonitor5.DBUS_WIDTH5 = 32;
defparam i_ahbMasterMonitor5.DBUS_WIDTH5 = 32;


// AHB2APB5 Bridge5

    ahb_liteslave_monitor5 i_ahbSlaveMonitor5 (
        .hclk_i5(hclk5),
        .hresetn_i5(n_hreset5),
        .hresp5(hresp5),
        .hready5(hready5),
        .hready_global_i5(hready5),
        .hrdata5(hrdata5),
        .hwdata_i5(hwdata5),
        .hburst_i5(hburst5),
        .hsize_i5(hsize5),
        .hwrite_i5(hwrite5),
        .htrans_i5(htrans5),
        .haddr_i5(haddr5),
        .hsel_i5(ahb2apb1_hsel5)
    );


  ahb_litemaster_monitor5 i_ahbMasterMonitor5 (
          .hclk_i5(hclk5),
          .hresetn_i5(n_hreset5),
          .hresp_i5(hresp5),
          .hready_i5(hready5),
          .hrdata_i5(hrdata5),
          .hlock5(1'b0),
          .hwdata5(hwdata5),
          .hprot5(hprot5),
          .hburst5(hburst5),
          .hsize5(hsize5),
          .hwrite5(hwrite5),
          .htrans5(htrans5),
          .haddr5(haddr5)
          );






`endif




endmodule
