//File24 name   : apb_subsystem_124.v
//Title24       : 
//Created24     : 1999
//Description24 : 
//Notes24       : 
//----------------------------------------------------------------------
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------

module apb_subsystem_124(
    // AHB24 interface
    hclk24,         
    n_hreset24,     
    hsel24,         
    haddr24,        
    htrans24,       
    hsize24,        
    hwrite24,       
    hwdata24,       
    hready_in24,    
    hburst24,     
    hprot24,      
    hmaster24,    
    hmastlock24,  
    hrdata24,     
    hready24,     
    hresp24,      

    // APB24 interface
    pclk24,       
    n_preset24,  
    paddr24,
    pwrite24,
    penable24,
    pwdata24, 
    
    // MAC024 APB24 ports24
    prdata_mac024,
    psel_mac024,
    pready_mac024,
    
    // MAC124 APB24 ports24
    prdata_mac124,
    psel_mac124,
    pready_mac124,
    
    // MAC224 APB24 ports24
    prdata_mac224,
    psel_mac224,
    pready_mac224,
    
    // MAC324 APB24 ports24
    prdata_mac324,
    psel_mac324,
    pready_mac324
);

// AHB24 interface
input         hclk24;     
input         n_hreset24; 
input         hsel24;     
input [31:0]  haddr24;    
input [1:0]   htrans24;   
input [2:0]   hsize24;    
input [31:0]  hwdata24;   
input         hwrite24;   
input         hready_in24;
input [2:0]   hburst24;   
input [3:0]   hprot24;    
input [3:0]   hmaster24;  
input         hmastlock24;
output [31:0] hrdata24;
output        hready24;
output [1:0]  hresp24; 

// APB24 interface
input         pclk24;     
input         n_preset24; 
output [31:0] paddr24;
output   	    pwrite24;
output   	    penable24;
output [31:0] pwdata24;

// MAC024 APB24 ports24
input [31:0] prdata_mac024;
output	     psel_mac024;
input        pready_mac024;

// MAC124 APB24 ports24
input [31:0] prdata_mac124;
output	     psel_mac124;
input        pready_mac124;

// MAC224 APB24 ports24
input [31:0] prdata_mac224;
output	     psel_mac224;
input        pready_mac224;

// MAC324 APB24 ports24
input [31:0] prdata_mac324;
output	     psel_mac324;
input        pready_mac324;

wire  [31:0] prdata_alut24;

assign tie_hi_bit24 = 1'b1;

ahb2apb24 #(
  32'h00A00000, // Slave24 0 Address Range24
  32'h00A0FFFF,

  32'h00A10000, // Slave24 1 Address Range24
  32'h00A1FFFF,

  32'h00A20000, // Slave24 2 Address Range24 
  32'h00A2FFFF,

  32'h00A30000, // Slave24 3 Address Range24
  32'h00A3FFFF,

  32'h00A40000, // Slave24 4 Address Range24
  32'h00A4FFFF
) i_ahb2apb24 (
     // AHB24 interface
    .hclk24(hclk24),         
    .hreset_n24(n_hreset24), 
    .hsel24(hsel24), 
    .haddr24(haddr24),        
    .htrans24(htrans24),       
    .hwrite24(hwrite24),       
    .hwdata24(hwdata24),       
    .hrdata24(hrdata24),   
    .hready24(hready24),   
    .hresp24(hresp24),     
    
     // APB24 interface
    .pclk24(pclk24),         
    .preset_n24(n_preset24),  
    .prdata024(prdata_alut24),
    .prdata124(prdata_mac024), 
    .prdata224(prdata_mac124),  
    .prdata324(prdata_mac224),   
    .prdata424(prdata_mac324),   
    .prdata524(32'h0),   
    .prdata624(32'h0),    
    .prdata724(32'h0),   
    .prdata824(32'h0),  
    .pready024(tie_hi_bit24),     
    .pready124(pready_mac024),   
    .pready224(pready_mac124),     
    .pready324(pready_mac224),     
    .pready424(pready_mac324),     
    .pready524(tie_hi_bit24),     
    .pready624(tie_hi_bit24),     
    .pready724(tie_hi_bit24),     
    .pready824(tie_hi_bit24),  
    .pwdata24(pwdata24),       
    .pwrite24(pwrite24),       
    .paddr24(paddr24),        
    .psel024(psel_alut24),     
    .psel124(psel_mac024),   
    .psel224(psel_mac124),    
    .psel324(psel_mac224),     
    .psel424(psel_mac324),     
    .psel524(),     
    .psel624(),    
    .psel724(),   
    .psel824(),  
    .penable24(penable24)     
);

alut_veneer24 i_alut_veneer24 (
        //inputs24
        . n_p_reset24(n_preset24),
        . pclk24(pclk24),
        . psel24(psel_alut24),
        . penable24(penable24),
        . pwrite24(pwrite24),
        . paddr24(paddr24[6:0]),
        . pwdata24(pwdata24),

        //outputs24
        . prdata24(prdata_alut24)
);

//------------------------------------------------------------------------------
// APB24 and AHB24 interface formal24 verification24 monitors24
//------------------------------------------------------------------------------
`ifdef ABV_ON24
apb_assert24 i_apb_assert24 (

   // APB24 signals24
  	.n_preset24(n_preset24),
  	.pclk24(pclk24),
	.penable24(penable24),
	.paddr24(paddr24),
	.pwrite24(pwrite24),
	.pwdata24(pwdata24),

  .psel0024(psel_alut24),
	.psel0124(psel_mac024),
	.psel0224(psel_mac124),
	.psel0324(psel_mac224),
	.psel0424(psel_mac324),
	.psel0524(psel0524),
	.psel0624(psel0624),
	.psel0724(psel0724),
	.psel0824(psel0824),
	.psel0924(psel0924),
	.psel1024(psel1024),
	.psel1124(psel1124),
	.psel1224(psel1224),
	.psel1324(psel1324),
	.psel1424(psel1424),
	.psel1524(psel1524),

   .prdata0024(prdata_alut24), // Read Data from peripheral24 ALUT24

   // AHB24 signals24
   .hclk24(hclk24),         // ahb24 system clock24
   .n_hreset24(n_hreset24), // ahb24 system reset

   // ahb2apb24 signals24
   .hresp24(hresp24),
   .hready24(hready24),
   .hrdata24(hrdata24),
   .hwdata24(hwdata24),
   .hprot24(hprot24),
   .hburst24(hburst24),
   .hsize24(hsize24),
   .hwrite24(hwrite24),
   .htrans24(htrans24),
   .haddr24(haddr24),
   .ahb2apb_hsel24(ahb2apb1_hsel24));



//------------------------------------------------------------------------------
// AHB24 interface formal24 verification24 monitor24
//------------------------------------------------------------------------------

defparam i_ahbSlaveMonitor24.DBUS_WIDTH24 = 32;
defparam i_ahbMasterMonitor24.DBUS_WIDTH24 = 32;


// AHB2APB24 Bridge24

    ahb_liteslave_monitor24 i_ahbSlaveMonitor24 (
        .hclk_i24(hclk24),
        .hresetn_i24(n_hreset24),
        .hresp24(hresp24),
        .hready24(hready24),
        .hready_global_i24(hready24),
        .hrdata24(hrdata24),
        .hwdata_i24(hwdata24),
        .hburst_i24(hburst24),
        .hsize_i24(hsize24),
        .hwrite_i24(hwrite24),
        .htrans_i24(htrans24),
        .haddr_i24(haddr24),
        .hsel_i24(ahb2apb1_hsel24)
    );


  ahb_litemaster_monitor24 i_ahbMasterMonitor24 (
          .hclk_i24(hclk24),
          .hresetn_i24(n_hreset24),
          .hresp_i24(hresp24),
          .hready_i24(hready24),
          .hrdata_i24(hrdata24),
          .hlock24(1'b0),
          .hwdata24(hwdata24),
          .hprot24(hprot24),
          .hburst24(hburst24),
          .hsize24(hsize24),
          .hwrite24(hwrite24),
          .htrans24(htrans24),
          .haddr24(haddr24)
          );






`endif




endmodule
