//File11 name   : apb_subsystem_111.v
//Title11       : 
//Created11     : 1999
//Description11 : 
//Notes11       : 
//----------------------------------------------------------------------
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------

module apb_subsystem_111(
    // AHB11 interface
    hclk11,         
    n_hreset11,     
    hsel11,         
    haddr11,        
    htrans11,       
    hsize11,        
    hwrite11,       
    hwdata11,       
    hready_in11,    
    hburst11,     
    hprot11,      
    hmaster11,    
    hmastlock11,  
    hrdata11,     
    hready11,     
    hresp11,      

    // APB11 interface
    pclk11,       
    n_preset11,  
    paddr11,
    pwrite11,
    penable11,
    pwdata11, 
    
    // MAC011 APB11 ports11
    prdata_mac011,
    psel_mac011,
    pready_mac011,
    
    // MAC111 APB11 ports11
    prdata_mac111,
    psel_mac111,
    pready_mac111,
    
    // MAC211 APB11 ports11
    prdata_mac211,
    psel_mac211,
    pready_mac211,
    
    // MAC311 APB11 ports11
    prdata_mac311,
    psel_mac311,
    pready_mac311
);

// AHB11 interface
input         hclk11;     
input         n_hreset11; 
input         hsel11;     
input [31:0]  haddr11;    
input [1:0]   htrans11;   
input [2:0]   hsize11;    
input [31:0]  hwdata11;   
input         hwrite11;   
input         hready_in11;
input [2:0]   hburst11;   
input [3:0]   hprot11;    
input [3:0]   hmaster11;  
input         hmastlock11;
output [31:0] hrdata11;
output        hready11;
output [1:0]  hresp11; 

// APB11 interface
input         pclk11;     
input         n_preset11; 
output [31:0] paddr11;
output   	    pwrite11;
output   	    penable11;
output [31:0] pwdata11;

// MAC011 APB11 ports11
input [31:0] prdata_mac011;
output	     psel_mac011;
input        pready_mac011;

// MAC111 APB11 ports11
input [31:0] prdata_mac111;
output	     psel_mac111;
input        pready_mac111;

// MAC211 APB11 ports11
input [31:0] prdata_mac211;
output	     psel_mac211;
input        pready_mac211;

// MAC311 APB11 ports11
input [31:0] prdata_mac311;
output	     psel_mac311;
input        pready_mac311;

wire  [31:0] prdata_alut11;

assign tie_hi_bit11 = 1'b1;

ahb2apb11 #(
  32'h00A00000, // Slave11 0 Address Range11
  32'h00A0FFFF,

  32'h00A10000, // Slave11 1 Address Range11
  32'h00A1FFFF,

  32'h00A20000, // Slave11 2 Address Range11 
  32'h00A2FFFF,

  32'h00A30000, // Slave11 3 Address Range11
  32'h00A3FFFF,

  32'h00A40000, // Slave11 4 Address Range11
  32'h00A4FFFF
) i_ahb2apb11 (
     // AHB11 interface
    .hclk11(hclk11),         
    .hreset_n11(n_hreset11), 
    .hsel11(hsel11), 
    .haddr11(haddr11),        
    .htrans11(htrans11),       
    .hwrite11(hwrite11),       
    .hwdata11(hwdata11),       
    .hrdata11(hrdata11),   
    .hready11(hready11),   
    .hresp11(hresp11),     
    
     // APB11 interface
    .pclk11(pclk11),         
    .preset_n11(n_preset11),  
    .prdata011(prdata_alut11),
    .prdata111(prdata_mac011), 
    .prdata211(prdata_mac111),  
    .prdata311(prdata_mac211),   
    .prdata411(prdata_mac311),   
    .prdata511(32'h0),   
    .prdata611(32'h0),    
    .prdata711(32'h0),   
    .prdata811(32'h0),  
    .pready011(tie_hi_bit11),     
    .pready111(pready_mac011),   
    .pready211(pready_mac111),     
    .pready311(pready_mac211),     
    .pready411(pready_mac311),     
    .pready511(tie_hi_bit11),     
    .pready611(tie_hi_bit11),     
    .pready711(tie_hi_bit11),     
    .pready811(tie_hi_bit11),  
    .pwdata11(pwdata11),       
    .pwrite11(pwrite11),       
    .paddr11(paddr11),        
    .psel011(psel_alut11),     
    .psel111(psel_mac011),   
    .psel211(psel_mac111),    
    .psel311(psel_mac211),     
    .psel411(psel_mac311),     
    .psel511(),     
    .psel611(),    
    .psel711(),   
    .psel811(),  
    .penable11(penable11)     
);

alut_veneer11 i_alut_veneer11 (
        //inputs11
        . n_p_reset11(n_preset11),
        . pclk11(pclk11),
        . psel11(psel_alut11),
        . penable11(penable11),
        . pwrite11(pwrite11),
        . paddr11(paddr11[6:0]),
        . pwdata11(pwdata11),

        //outputs11
        . prdata11(prdata_alut11)
);

//------------------------------------------------------------------------------
// APB11 and AHB11 interface formal11 verification11 monitors11
//------------------------------------------------------------------------------
`ifdef ABV_ON11
apb_assert11 i_apb_assert11 (

   // APB11 signals11
  	.n_preset11(n_preset11),
  	.pclk11(pclk11),
	.penable11(penable11),
	.paddr11(paddr11),
	.pwrite11(pwrite11),
	.pwdata11(pwdata11),

  .psel0011(psel_alut11),
	.psel0111(psel_mac011),
	.psel0211(psel_mac111),
	.psel0311(psel_mac211),
	.psel0411(psel_mac311),
	.psel0511(psel0511),
	.psel0611(psel0611),
	.psel0711(psel0711),
	.psel0811(psel0811),
	.psel0911(psel0911),
	.psel1011(psel1011),
	.psel1111(psel1111),
	.psel1211(psel1211),
	.psel1311(psel1311),
	.psel1411(psel1411),
	.psel1511(psel1511),

   .prdata0011(prdata_alut11), // Read Data from peripheral11 ALUT11

   // AHB11 signals11
   .hclk11(hclk11),         // ahb11 system clock11
   .n_hreset11(n_hreset11), // ahb11 system reset

   // ahb2apb11 signals11
   .hresp11(hresp11),
   .hready11(hready11),
   .hrdata11(hrdata11),
   .hwdata11(hwdata11),
   .hprot11(hprot11),
   .hburst11(hburst11),
   .hsize11(hsize11),
   .hwrite11(hwrite11),
   .htrans11(htrans11),
   .haddr11(haddr11),
   .ahb2apb_hsel11(ahb2apb1_hsel11));



//------------------------------------------------------------------------------
// AHB11 interface formal11 verification11 monitor11
//------------------------------------------------------------------------------

defparam i_ahbSlaveMonitor11.DBUS_WIDTH11 = 32;
defparam i_ahbMasterMonitor11.DBUS_WIDTH11 = 32;


// AHB2APB11 Bridge11

    ahb_liteslave_monitor11 i_ahbSlaveMonitor11 (
        .hclk_i11(hclk11),
        .hresetn_i11(n_hreset11),
        .hresp11(hresp11),
        .hready11(hready11),
        .hready_global_i11(hready11),
        .hrdata11(hrdata11),
        .hwdata_i11(hwdata11),
        .hburst_i11(hburst11),
        .hsize_i11(hsize11),
        .hwrite_i11(hwrite11),
        .htrans_i11(htrans11),
        .haddr_i11(haddr11),
        .hsel_i11(ahb2apb1_hsel11)
    );


  ahb_litemaster_monitor11 i_ahbMasterMonitor11 (
          .hclk_i11(hclk11),
          .hresetn_i11(n_hreset11),
          .hresp_i11(hresp11),
          .hready_i11(hready11),
          .hrdata_i11(hrdata11),
          .hlock11(1'b0),
          .hwdata11(hwdata11),
          .hprot11(hprot11),
          .hburst11(hburst11),
          .hsize11(hsize11),
          .hwrite11(hwrite11),
          .htrans11(htrans11),
          .haddr11(haddr11)
          );






`endif




endmodule
