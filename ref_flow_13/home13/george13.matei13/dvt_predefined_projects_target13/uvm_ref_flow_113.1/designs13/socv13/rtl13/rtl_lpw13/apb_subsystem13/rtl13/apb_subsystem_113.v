//File13 name   : apb_subsystem_113.v
//Title13       : 
//Created13     : 1999
//Description13 : 
//Notes13       : 
//----------------------------------------------------------------------
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------

module apb_subsystem_113(
    // AHB13 interface
    hclk13,         
    n_hreset13,     
    hsel13,         
    haddr13,        
    htrans13,       
    hsize13,        
    hwrite13,       
    hwdata13,       
    hready_in13,    
    hburst13,     
    hprot13,      
    hmaster13,    
    hmastlock13,  
    hrdata13,     
    hready13,     
    hresp13,      

    // APB13 interface
    pclk13,       
    n_preset13,  
    paddr13,
    pwrite13,
    penable13,
    pwdata13, 
    
    // MAC013 APB13 ports13
    prdata_mac013,
    psel_mac013,
    pready_mac013,
    
    // MAC113 APB13 ports13
    prdata_mac113,
    psel_mac113,
    pready_mac113,
    
    // MAC213 APB13 ports13
    prdata_mac213,
    psel_mac213,
    pready_mac213,
    
    // MAC313 APB13 ports13
    prdata_mac313,
    psel_mac313,
    pready_mac313
);

// AHB13 interface
input         hclk13;     
input         n_hreset13; 
input         hsel13;     
input [31:0]  haddr13;    
input [1:0]   htrans13;   
input [2:0]   hsize13;    
input [31:0]  hwdata13;   
input         hwrite13;   
input         hready_in13;
input [2:0]   hburst13;   
input [3:0]   hprot13;    
input [3:0]   hmaster13;  
input         hmastlock13;
output [31:0] hrdata13;
output        hready13;
output [1:0]  hresp13; 

// APB13 interface
input         pclk13;     
input         n_preset13; 
output [31:0] paddr13;
output   	    pwrite13;
output   	    penable13;
output [31:0] pwdata13;

// MAC013 APB13 ports13
input [31:0] prdata_mac013;
output	     psel_mac013;
input        pready_mac013;

// MAC113 APB13 ports13
input [31:0] prdata_mac113;
output	     psel_mac113;
input        pready_mac113;

// MAC213 APB13 ports13
input [31:0] prdata_mac213;
output	     psel_mac213;
input        pready_mac213;

// MAC313 APB13 ports13
input [31:0] prdata_mac313;
output	     psel_mac313;
input        pready_mac313;

wire  [31:0] prdata_alut13;

assign tie_hi_bit13 = 1'b1;

ahb2apb13 #(
  32'h00A00000, // Slave13 0 Address Range13
  32'h00A0FFFF,

  32'h00A10000, // Slave13 1 Address Range13
  32'h00A1FFFF,

  32'h00A20000, // Slave13 2 Address Range13 
  32'h00A2FFFF,

  32'h00A30000, // Slave13 3 Address Range13
  32'h00A3FFFF,

  32'h00A40000, // Slave13 4 Address Range13
  32'h00A4FFFF
) i_ahb2apb13 (
     // AHB13 interface
    .hclk13(hclk13),         
    .hreset_n13(n_hreset13), 
    .hsel13(hsel13), 
    .haddr13(haddr13),        
    .htrans13(htrans13),       
    .hwrite13(hwrite13),       
    .hwdata13(hwdata13),       
    .hrdata13(hrdata13),   
    .hready13(hready13),   
    .hresp13(hresp13),     
    
     // APB13 interface
    .pclk13(pclk13),         
    .preset_n13(n_preset13),  
    .prdata013(prdata_alut13),
    .prdata113(prdata_mac013), 
    .prdata213(prdata_mac113),  
    .prdata313(prdata_mac213),   
    .prdata413(prdata_mac313),   
    .prdata513(32'h0),   
    .prdata613(32'h0),    
    .prdata713(32'h0),   
    .prdata813(32'h0),  
    .pready013(tie_hi_bit13),     
    .pready113(pready_mac013),   
    .pready213(pready_mac113),     
    .pready313(pready_mac213),     
    .pready413(pready_mac313),     
    .pready513(tie_hi_bit13),     
    .pready613(tie_hi_bit13),     
    .pready713(tie_hi_bit13),     
    .pready813(tie_hi_bit13),  
    .pwdata13(pwdata13),       
    .pwrite13(pwrite13),       
    .paddr13(paddr13),        
    .psel013(psel_alut13),     
    .psel113(psel_mac013),   
    .psel213(psel_mac113),    
    .psel313(psel_mac213),     
    .psel413(psel_mac313),     
    .psel513(),     
    .psel613(),    
    .psel713(),   
    .psel813(),  
    .penable13(penable13)     
);

alut_veneer13 i_alut_veneer13 (
        //inputs13
        . n_p_reset13(n_preset13),
        . pclk13(pclk13),
        . psel13(psel_alut13),
        . penable13(penable13),
        . pwrite13(pwrite13),
        . paddr13(paddr13[6:0]),
        . pwdata13(pwdata13),

        //outputs13
        . prdata13(prdata_alut13)
);

//------------------------------------------------------------------------------
// APB13 and AHB13 interface formal13 verification13 monitors13
//------------------------------------------------------------------------------
`ifdef ABV_ON13
apb_assert13 i_apb_assert13 (

   // APB13 signals13
  	.n_preset13(n_preset13),
  	.pclk13(pclk13),
	.penable13(penable13),
	.paddr13(paddr13),
	.pwrite13(pwrite13),
	.pwdata13(pwdata13),

  .psel0013(psel_alut13),
	.psel0113(psel_mac013),
	.psel0213(psel_mac113),
	.psel0313(psel_mac213),
	.psel0413(psel_mac313),
	.psel0513(psel0513),
	.psel0613(psel0613),
	.psel0713(psel0713),
	.psel0813(psel0813),
	.psel0913(psel0913),
	.psel1013(psel1013),
	.psel1113(psel1113),
	.psel1213(psel1213),
	.psel1313(psel1313),
	.psel1413(psel1413),
	.psel1513(psel1513),

   .prdata0013(prdata_alut13), // Read Data from peripheral13 ALUT13

   // AHB13 signals13
   .hclk13(hclk13),         // ahb13 system clock13
   .n_hreset13(n_hreset13), // ahb13 system reset

   // ahb2apb13 signals13
   .hresp13(hresp13),
   .hready13(hready13),
   .hrdata13(hrdata13),
   .hwdata13(hwdata13),
   .hprot13(hprot13),
   .hburst13(hburst13),
   .hsize13(hsize13),
   .hwrite13(hwrite13),
   .htrans13(htrans13),
   .haddr13(haddr13),
   .ahb2apb_hsel13(ahb2apb1_hsel13));



//------------------------------------------------------------------------------
// AHB13 interface formal13 verification13 monitor13
//------------------------------------------------------------------------------

defparam i_ahbSlaveMonitor13.DBUS_WIDTH13 = 32;
defparam i_ahbMasterMonitor13.DBUS_WIDTH13 = 32;


// AHB2APB13 Bridge13

    ahb_liteslave_monitor13 i_ahbSlaveMonitor13 (
        .hclk_i13(hclk13),
        .hresetn_i13(n_hreset13),
        .hresp13(hresp13),
        .hready13(hready13),
        .hready_global_i13(hready13),
        .hrdata13(hrdata13),
        .hwdata_i13(hwdata13),
        .hburst_i13(hburst13),
        .hsize_i13(hsize13),
        .hwrite_i13(hwrite13),
        .htrans_i13(htrans13),
        .haddr_i13(haddr13),
        .hsel_i13(ahb2apb1_hsel13)
    );


  ahb_litemaster_monitor13 i_ahbMasterMonitor13 (
          .hclk_i13(hclk13),
          .hresetn_i13(n_hreset13),
          .hresp_i13(hresp13),
          .hready_i13(hready13),
          .hrdata_i13(hrdata13),
          .hlock13(1'b0),
          .hwdata13(hwdata13),
          .hprot13(hprot13),
          .hburst13(hburst13),
          .hsize13(hsize13),
          .hwrite13(hwrite13),
          .htrans13(htrans13),
          .haddr13(haddr13)
          );






`endif




endmodule
