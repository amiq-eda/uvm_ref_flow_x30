//File21 name   : apb_subsystem_121.v
//Title21       : 
//Created21     : 1999
//Description21 : 
//Notes21       : 
//----------------------------------------------------------------------
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------

module apb_subsystem_121(
    // AHB21 interface
    hclk21,         
    n_hreset21,     
    hsel21,         
    haddr21,        
    htrans21,       
    hsize21,        
    hwrite21,       
    hwdata21,       
    hready_in21,    
    hburst21,     
    hprot21,      
    hmaster21,    
    hmastlock21,  
    hrdata21,     
    hready21,     
    hresp21,      

    // APB21 interface
    pclk21,       
    n_preset21,  
    paddr21,
    pwrite21,
    penable21,
    pwdata21, 
    
    // MAC021 APB21 ports21
    prdata_mac021,
    psel_mac021,
    pready_mac021,
    
    // MAC121 APB21 ports21
    prdata_mac121,
    psel_mac121,
    pready_mac121,
    
    // MAC221 APB21 ports21
    prdata_mac221,
    psel_mac221,
    pready_mac221,
    
    // MAC321 APB21 ports21
    prdata_mac321,
    psel_mac321,
    pready_mac321
);

// AHB21 interface
input         hclk21;     
input         n_hreset21; 
input         hsel21;     
input [31:0]  haddr21;    
input [1:0]   htrans21;   
input [2:0]   hsize21;    
input [31:0]  hwdata21;   
input         hwrite21;   
input         hready_in21;
input [2:0]   hburst21;   
input [3:0]   hprot21;    
input [3:0]   hmaster21;  
input         hmastlock21;
output [31:0] hrdata21;
output        hready21;
output [1:0]  hresp21; 

// APB21 interface
input         pclk21;     
input         n_preset21; 
output [31:0] paddr21;
output   	    pwrite21;
output   	    penable21;
output [31:0] pwdata21;

// MAC021 APB21 ports21
input [31:0] prdata_mac021;
output	     psel_mac021;
input        pready_mac021;

// MAC121 APB21 ports21
input [31:0] prdata_mac121;
output	     psel_mac121;
input        pready_mac121;

// MAC221 APB21 ports21
input [31:0] prdata_mac221;
output	     psel_mac221;
input        pready_mac221;

// MAC321 APB21 ports21
input [31:0] prdata_mac321;
output	     psel_mac321;
input        pready_mac321;

wire  [31:0] prdata_alut21;

assign tie_hi_bit21 = 1'b1;

ahb2apb21 #(
  32'h00A00000, // Slave21 0 Address Range21
  32'h00A0FFFF,

  32'h00A10000, // Slave21 1 Address Range21
  32'h00A1FFFF,

  32'h00A20000, // Slave21 2 Address Range21 
  32'h00A2FFFF,

  32'h00A30000, // Slave21 3 Address Range21
  32'h00A3FFFF,

  32'h00A40000, // Slave21 4 Address Range21
  32'h00A4FFFF
) i_ahb2apb21 (
     // AHB21 interface
    .hclk21(hclk21),         
    .hreset_n21(n_hreset21), 
    .hsel21(hsel21), 
    .haddr21(haddr21),        
    .htrans21(htrans21),       
    .hwrite21(hwrite21),       
    .hwdata21(hwdata21),       
    .hrdata21(hrdata21),   
    .hready21(hready21),   
    .hresp21(hresp21),     
    
     // APB21 interface
    .pclk21(pclk21),         
    .preset_n21(n_preset21),  
    .prdata021(prdata_alut21),
    .prdata121(prdata_mac021), 
    .prdata221(prdata_mac121),  
    .prdata321(prdata_mac221),   
    .prdata421(prdata_mac321),   
    .prdata521(32'h0),   
    .prdata621(32'h0),    
    .prdata721(32'h0),   
    .prdata821(32'h0),  
    .pready021(tie_hi_bit21),     
    .pready121(pready_mac021),   
    .pready221(pready_mac121),     
    .pready321(pready_mac221),     
    .pready421(pready_mac321),     
    .pready521(tie_hi_bit21),     
    .pready621(tie_hi_bit21),     
    .pready721(tie_hi_bit21),     
    .pready821(tie_hi_bit21),  
    .pwdata21(pwdata21),       
    .pwrite21(pwrite21),       
    .paddr21(paddr21),        
    .psel021(psel_alut21),     
    .psel121(psel_mac021),   
    .psel221(psel_mac121),    
    .psel321(psel_mac221),     
    .psel421(psel_mac321),     
    .psel521(),     
    .psel621(),    
    .psel721(),   
    .psel821(),  
    .penable21(penable21)     
);

alut_veneer21 i_alut_veneer21 (
        //inputs21
        . n_p_reset21(n_preset21),
        . pclk21(pclk21),
        . psel21(psel_alut21),
        . penable21(penable21),
        . pwrite21(pwrite21),
        . paddr21(paddr21[6:0]),
        . pwdata21(pwdata21),

        //outputs21
        . prdata21(prdata_alut21)
);

//------------------------------------------------------------------------------
// APB21 and AHB21 interface formal21 verification21 monitors21
//------------------------------------------------------------------------------
`ifdef ABV_ON21
apb_assert21 i_apb_assert21 (

   // APB21 signals21
  	.n_preset21(n_preset21),
  	.pclk21(pclk21),
	.penable21(penable21),
	.paddr21(paddr21),
	.pwrite21(pwrite21),
	.pwdata21(pwdata21),

  .psel0021(psel_alut21),
	.psel0121(psel_mac021),
	.psel0221(psel_mac121),
	.psel0321(psel_mac221),
	.psel0421(psel_mac321),
	.psel0521(psel0521),
	.psel0621(psel0621),
	.psel0721(psel0721),
	.psel0821(psel0821),
	.psel0921(psel0921),
	.psel1021(psel1021),
	.psel1121(psel1121),
	.psel1221(psel1221),
	.psel1321(psel1321),
	.psel1421(psel1421),
	.psel1521(psel1521),

   .prdata0021(prdata_alut21), // Read Data from peripheral21 ALUT21

   // AHB21 signals21
   .hclk21(hclk21),         // ahb21 system clock21
   .n_hreset21(n_hreset21), // ahb21 system reset

   // ahb2apb21 signals21
   .hresp21(hresp21),
   .hready21(hready21),
   .hrdata21(hrdata21),
   .hwdata21(hwdata21),
   .hprot21(hprot21),
   .hburst21(hburst21),
   .hsize21(hsize21),
   .hwrite21(hwrite21),
   .htrans21(htrans21),
   .haddr21(haddr21),
   .ahb2apb_hsel21(ahb2apb1_hsel21));



//------------------------------------------------------------------------------
// AHB21 interface formal21 verification21 monitor21
//------------------------------------------------------------------------------

defparam i_ahbSlaveMonitor21.DBUS_WIDTH21 = 32;
defparam i_ahbMasterMonitor21.DBUS_WIDTH21 = 32;


// AHB2APB21 Bridge21

    ahb_liteslave_monitor21 i_ahbSlaveMonitor21 (
        .hclk_i21(hclk21),
        .hresetn_i21(n_hreset21),
        .hresp21(hresp21),
        .hready21(hready21),
        .hready_global_i21(hready21),
        .hrdata21(hrdata21),
        .hwdata_i21(hwdata21),
        .hburst_i21(hburst21),
        .hsize_i21(hsize21),
        .hwrite_i21(hwrite21),
        .htrans_i21(htrans21),
        .haddr_i21(haddr21),
        .hsel_i21(ahb2apb1_hsel21)
    );


  ahb_litemaster_monitor21 i_ahbMasterMonitor21 (
          .hclk_i21(hclk21),
          .hresetn_i21(n_hreset21),
          .hresp_i21(hresp21),
          .hready_i21(hready21),
          .hrdata_i21(hrdata21),
          .hlock21(1'b0),
          .hwdata21(hwdata21),
          .hprot21(hprot21),
          .hburst21(hburst21),
          .hsize21(hsize21),
          .hwrite21(hwrite21),
          .htrans21(htrans21),
          .haddr21(haddr21)
          );






`endif




endmodule
