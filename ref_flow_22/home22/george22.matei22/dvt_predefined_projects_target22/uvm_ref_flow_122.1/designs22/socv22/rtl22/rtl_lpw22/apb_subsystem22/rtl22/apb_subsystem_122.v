//File22 name   : apb_subsystem_122.v
//Title22       : 
//Created22     : 1999
//Description22 : 
//Notes22       : 
//----------------------------------------------------------------------
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------

module apb_subsystem_122(
    // AHB22 interface
    hclk22,         
    n_hreset22,     
    hsel22,         
    haddr22,        
    htrans22,       
    hsize22,        
    hwrite22,       
    hwdata22,       
    hready_in22,    
    hburst22,     
    hprot22,      
    hmaster22,    
    hmastlock22,  
    hrdata22,     
    hready22,     
    hresp22,      

    // APB22 interface
    pclk22,       
    n_preset22,  
    paddr22,
    pwrite22,
    penable22,
    pwdata22, 
    
    // MAC022 APB22 ports22
    prdata_mac022,
    psel_mac022,
    pready_mac022,
    
    // MAC122 APB22 ports22
    prdata_mac122,
    psel_mac122,
    pready_mac122,
    
    // MAC222 APB22 ports22
    prdata_mac222,
    psel_mac222,
    pready_mac222,
    
    // MAC322 APB22 ports22
    prdata_mac322,
    psel_mac322,
    pready_mac322
);

// AHB22 interface
input         hclk22;     
input         n_hreset22; 
input         hsel22;     
input [31:0]  haddr22;    
input [1:0]   htrans22;   
input [2:0]   hsize22;    
input [31:0]  hwdata22;   
input         hwrite22;   
input         hready_in22;
input [2:0]   hburst22;   
input [3:0]   hprot22;    
input [3:0]   hmaster22;  
input         hmastlock22;
output [31:0] hrdata22;
output        hready22;
output [1:0]  hresp22; 

// APB22 interface
input         pclk22;     
input         n_preset22; 
output [31:0] paddr22;
output   	    pwrite22;
output   	    penable22;
output [31:0] pwdata22;

// MAC022 APB22 ports22
input [31:0] prdata_mac022;
output	     psel_mac022;
input        pready_mac022;

// MAC122 APB22 ports22
input [31:0] prdata_mac122;
output	     psel_mac122;
input        pready_mac122;

// MAC222 APB22 ports22
input [31:0] prdata_mac222;
output	     psel_mac222;
input        pready_mac222;

// MAC322 APB22 ports22
input [31:0] prdata_mac322;
output	     psel_mac322;
input        pready_mac322;

wire  [31:0] prdata_alut22;

assign tie_hi_bit22 = 1'b1;

ahb2apb22 #(
  32'h00A00000, // Slave22 0 Address Range22
  32'h00A0FFFF,

  32'h00A10000, // Slave22 1 Address Range22
  32'h00A1FFFF,

  32'h00A20000, // Slave22 2 Address Range22 
  32'h00A2FFFF,

  32'h00A30000, // Slave22 3 Address Range22
  32'h00A3FFFF,

  32'h00A40000, // Slave22 4 Address Range22
  32'h00A4FFFF
) i_ahb2apb22 (
     // AHB22 interface
    .hclk22(hclk22),         
    .hreset_n22(n_hreset22), 
    .hsel22(hsel22), 
    .haddr22(haddr22),        
    .htrans22(htrans22),       
    .hwrite22(hwrite22),       
    .hwdata22(hwdata22),       
    .hrdata22(hrdata22),   
    .hready22(hready22),   
    .hresp22(hresp22),     
    
     // APB22 interface
    .pclk22(pclk22),         
    .preset_n22(n_preset22),  
    .prdata022(prdata_alut22),
    .prdata122(prdata_mac022), 
    .prdata222(prdata_mac122),  
    .prdata322(prdata_mac222),   
    .prdata422(prdata_mac322),   
    .prdata522(32'h0),   
    .prdata622(32'h0),    
    .prdata722(32'h0),   
    .prdata822(32'h0),  
    .pready022(tie_hi_bit22),     
    .pready122(pready_mac022),   
    .pready222(pready_mac122),     
    .pready322(pready_mac222),     
    .pready422(pready_mac322),     
    .pready522(tie_hi_bit22),     
    .pready622(tie_hi_bit22),     
    .pready722(tie_hi_bit22),     
    .pready822(tie_hi_bit22),  
    .pwdata22(pwdata22),       
    .pwrite22(pwrite22),       
    .paddr22(paddr22),        
    .psel022(psel_alut22),     
    .psel122(psel_mac022),   
    .psel222(psel_mac122),    
    .psel322(psel_mac222),     
    .psel422(psel_mac322),     
    .psel522(),     
    .psel622(),    
    .psel722(),   
    .psel822(),  
    .penable22(penable22)     
);

alut_veneer22 i_alut_veneer22 (
        //inputs22
        . n_p_reset22(n_preset22),
        . pclk22(pclk22),
        . psel22(psel_alut22),
        . penable22(penable22),
        . pwrite22(pwrite22),
        . paddr22(paddr22[6:0]),
        . pwdata22(pwdata22),

        //outputs22
        . prdata22(prdata_alut22)
);

//------------------------------------------------------------------------------
// APB22 and AHB22 interface formal22 verification22 monitors22
//------------------------------------------------------------------------------
`ifdef ABV_ON22
apb_assert22 i_apb_assert22 (

   // APB22 signals22
  	.n_preset22(n_preset22),
  	.pclk22(pclk22),
	.penable22(penable22),
	.paddr22(paddr22),
	.pwrite22(pwrite22),
	.pwdata22(pwdata22),

  .psel0022(psel_alut22),
	.psel0122(psel_mac022),
	.psel0222(psel_mac122),
	.psel0322(psel_mac222),
	.psel0422(psel_mac322),
	.psel0522(psel0522),
	.psel0622(psel0622),
	.psel0722(psel0722),
	.psel0822(psel0822),
	.psel0922(psel0922),
	.psel1022(psel1022),
	.psel1122(psel1122),
	.psel1222(psel1222),
	.psel1322(psel1322),
	.psel1422(psel1422),
	.psel1522(psel1522),

   .prdata0022(prdata_alut22), // Read Data from peripheral22 ALUT22

   // AHB22 signals22
   .hclk22(hclk22),         // ahb22 system clock22
   .n_hreset22(n_hreset22), // ahb22 system reset

   // ahb2apb22 signals22
   .hresp22(hresp22),
   .hready22(hready22),
   .hrdata22(hrdata22),
   .hwdata22(hwdata22),
   .hprot22(hprot22),
   .hburst22(hburst22),
   .hsize22(hsize22),
   .hwrite22(hwrite22),
   .htrans22(htrans22),
   .haddr22(haddr22),
   .ahb2apb_hsel22(ahb2apb1_hsel22));



//------------------------------------------------------------------------------
// AHB22 interface formal22 verification22 monitor22
//------------------------------------------------------------------------------

defparam i_ahbSlaveMonitor22.DBUS_WIDTH22 = 32;
defparam i_ahbMasterMonitor22.DBUS_WIDTH22 = 32;


// AHB2APB22 Bridge22

    ahb_liteslave_monitor22 i_ahbSlaveMonitor22 (
        .hclk_i22(hclk22),
        .hresetn_i22(n_hreset22),
        .hresp22(hresp22),
        .hready22(hready22),
        .hready_global_i22(hready22),
        .hrdata22(hrdata22),
        .hwdata_i22(hwdata22),
        .hburst_i22(hburst22),
        .hsize_i22(hsize22),
        .hwrite_i22(hwrite22),
        .htrans_i22(htrans22),
        .haddr_i22(haddr22),
        .hsel_i22(ahb2apb1_hsel22)
    );


  ahb_litemaster_monitor22 i_ahbMasterMonitor22 (
          .hclk_i22(hclk22),
          .hresetn_i22(n_hreset22),
          .hresp_i22(hresp22),
          .hready_i22(hready22),
          .hrdata_i22(hrdata22),
          .hlock22(1'b0),
          .hwdata22(hwdata22),
          .hprot22(hprot22),
          .hburst22(hburst22),
          .hsize22(hsize22),
          .hwrite22(hwrite22),
          .htrans22(htrans22),
          .haddr22(haddr22)
          );






`endif




endmodule
