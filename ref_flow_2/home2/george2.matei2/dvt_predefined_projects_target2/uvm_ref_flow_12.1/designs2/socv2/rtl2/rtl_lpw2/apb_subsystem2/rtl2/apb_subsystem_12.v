//File2 name   : apb_subsystem_12.v
//Title2       : 
//Created2     : 1999
//Description2 : 
//Notes2       : 
//----------------------------------------------------------------------
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------

module apb_subsystem_12(
    // AHB2 interface
    hclk2,         
    n_hreset2,     
    hsel2,         
    haddr2,        
    htrans2,       
    hsize2,        
    hwrite2,       
    hwdata2,       
    hready_in2,    
    hburst2,     
    hprot2,      
    hmaster2,    
    hmastlock2,  
    hrdata2,     
    hready2,     
    hresp2,      

    // APB2 interface
    pclk2,       
    n_preset2,  
    paddr2,
    pwrite2,
    penable2,
    pwdata2, 
    
    // MAC02 APB2 ports2
    prdata_mac02,
    psel_mac02,
    pready_mac02,
    
    // MAC12 APB2 ports2
    prdata_mac12,
    psel_mac12,
    pready_mac12,
    
    // MAC22 APB2 ports2
    prdata_mac22,
    psel_mac22,
    pready_mac22,
    
    // MAC32 APB2 ports2
    prdata_mac32,
    psel_mac32,
    pready_mac32
);

// AHB2 interface
input         hclk2;     
input         n_hreset2; 
input         hsel2;     
input [31:0]  haddr2;    
input [1:0]   htrans2;   
input [2:0]   hsize2;    
input [31:0]  hwdata2;   
input         hwrite2;   
input         hready_in2;
input [2:0]   hburst2;   
input [3:0]   hprot2;    
input [3:0]   hmaster2;  
input         hmastlock2;
output [31:0] hrdata2;
output        hready2;
output [1:0]  hresp2; 

// APB2 interface
input         pclk2;     
input         n_preset2; 
output [31:0] paddr2;
output   	    pwrite2;
output   	    penable2;
output [31:0] pwdata2;

// MAC02 APB2 ports2
input [31:0] prdata_mac02;
output	     psel_mac02;
input        pready_mac02;

// MAC12 APB2 ports2
input [31:0] prdata_mac12;
output	     psel_mac12;
input        pready_mac12;

// MAC22 APB2 ports2
input [31:0] prdata_mac22;
output	     psel_mac22;
input        pready_mac22;

// MAC32 APB2 ports2
input [31:0] prdata_mac32;
output	     psel_mac32;
input        pready_mac32;

wire  [31:0] prdata_alut2;

assign tie_hi_bit2 = 1'b1;

ahb2apb2 #(
  32'h00A00000, // Slave2 0 Address Range2
  32'h00A0FFFF,

  32'h00A10000, // Slave2 1 Address Range2
  32'h00A1FFFF,

  32'h00A20000, // Slave2 2 Address Range2 
  32'h00A2FFFF,

  32'h00A30000, // Slave2 3 Address Range2
  32'h00A3FFFF,

  32'h00A40000, // Slave2 4 Address Range2
  32'h00A4FFFF
) i_ahb2apb2 (
     // AHB2 interface
    .hclk2(hclk2),         
    .hreset_n2(n_hreset2), 
    .hsel2(hsel2), 
    .haddr2(haddr2),        
    .htrans2(htrans2),       
    .hwrite2(hwrite2),       
    .hwdata2(hwdata2),       
    .hrdata2(hrdata2),   
    .hready2(hready2),   
    .hresp2(hresp2),     
    
     // APB2 interface
    .pclk2(pclk2),         
    .preset_n2(n_preset2),  
    .prdata02(prdata_alut2),
    .prdata12(prdata_mac02), 
    .prdata22(prdata_mac12),  
    .prdata32(prdata_mac22),   
    .prdata42(prdata_mac32),   
    .prdata52(32'h0),   
    .prdata62(32'h0),    
    .prdata72(32'h0),   
    .prdata82(32'h0),  
    .pready02(tie_hi_bit2),     
    .pready12(pready_mac02),   
    .pready22(pready_mac12),     
    .pready32(pready_mac22),     
    .pready42(pready_mac32),     
    .pready52(tie_hi_bit2),     
    .pready62(tie_hi_bit2),     
    .pready72(tie_hi_bit2),     
    .pready82(tie_hi_bit2),  
    .pwdata2(pwdata2),       
    .pwrite2(pwrite2),       
    .paddr2(paddr2),        
    .psel02(psel_alut2),     
    .psel12(psel_mac02),   
    .psel22(psel_mac12),    
    .psel32(psel_mac22),     
    .psel42(psel_mac32),     
    .psel52(),     
    .psel62(),    
    .psel72(),   
    .psel82(),  
    .penable2(penable2)     
);

alut_veneer2 i_alut_veneer2 (
        //inputs2
        . n_p_reset2(n_preset2),
        . pclk2(pclk2),
        . psel2(psel_alut2),
        . penable2(penable2),
        . pwrite2(pwrite2),
        . paddr2(paddr2[6:0]),
        . pwdata2(pwdata2),

        //outputs2
        . prdata2(prdata_alut2)
);

//------------------------------------------------------------------------------
// APB2 and AHB2 interface formal2 verification2 monitors2
//------------------------------------------------------------------------------
`ifdef ABV_ON2
apb_assert2 i_apb_assert2 (

   // APB2 signals2
  	.n_preset2(n_preset2),
  	.pclk2(pclk2),
	.penable2(penable2),
	.paddr2(paddr2),
	.pwrite2(pwrite2),
	.pwdata2(pwdata2),

  .psel002(psel_alut2),
	.psel012(psel_mac02),
	.psel022(psel_mac12),
	.psel032(psel_mac22),
	.psel042(psel_mac32),
	.psel052(psel052),
	.psel062(psel062),
	.psel072(psel072),
	.psel082(psel082),
	.psel092(psel092),
	.psel102(psel102),
	.psel112(psel112),
	.psel122(psel122),
	.psel132(psel132),
	.psel142(psel142),
	.psel152(psel152),

   .prdata002(prdata_alut2), // Read Data from peripheral2 ALUT2

   // AHB2 signals2
   .hclk2(hclk2),         // ahb2 system clock2
   .n_hreset2(n_hreset2), // ahb2 system reset

   // ahb2apb2 signals2
   .hresp2(hresp2),
   .hready2(hready2),
   .hrdata2(hrdata2),
   .hwdata2(hwdata2),
   .hprot2(hprot2),
   .hburst2(hburst2),
   .hsize2(hsize2),
   .hwrite2(hwrite2),
   .htrans2(htrans2),
   .haddr2(haddr2),
   .ahb2apb_hsel2(ahb2apb1_hsel2));



//------------------------------------------------------------------------------
// AHB2 interface formal2 verification2 monitor2
//------------------------------------------------------------------------------

defparam i_ahbSlaveMonitor2.DBUS_WIDTH2 = 32;
defparam i_ahbMasterMonitor2.DBUS_WIDTH2 = 32;


// AHB2APB2 Bridge2

    ahb_liteslave_monitor2 i_ahbSlaveMonitor2 (
        .hclk_i2(hclk2),
        .hresetn_i2(n_hreset2),
        .hresp2(hresp2),
        .hready2(hready2),
        .hready_global_i2(hready2),
        .hrdata2(hrdata2),
        .hwdata_i2(hwdata2),
        .hburst_i2(hburst2),
        .hsize_i2(hsize2),
        .hwrite_i2(hwrite2),
        .htrans_i2(htrans2),
        .haddr_i2(haddr2),
        .hsel_i2(ahb2apb1_hsel2)
    );


  ahb_litemaster_monitor2 i_ahbMasterMonitor2 (
          .hclk_i2(hclk2),
          .hresetn_i2(n_hreset2),
          .hresp_i2(hresp2),
          .hready_i2(hready2),
          .hrdata_i2(hrdata2),
          .hlock2(1'b0),
          .hwdata2(hwdata2),
          .hprot2(hprot2),
          .hburst2(hburst2),
          .hsize2(hsize2),
          .hwrite2(hwrite2),
          .htrans2(htrans2),
          .haddr2(haddr2)
          );






`endif




endmodule
