//File3 name   : apb_subsystem_13.v
//Title3       : 
//Created3     : 1999
//Description3 : 
//Notes3       : 
//----------------------------------------------------------------------
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------

module apb_subsystem_13(
    // AHB3 interface
    hclk3,         
    n_hreset3,     
    hsel3,         
    haddr3,        
    htrans3,       
    hsize3,        
    hwrite3,       
    hwdata3,       
    hready_in3,    
    hburst3,     
    hprot3,      
    hmaster3,    
    hmastlock3,  
    hrdata3,     
    hready3,     
    hresp3,      

    // APB3 interface
    pclk3,       
    n_preset3,  
    paddr3,
    pwrite3,
    penable3,
    pwdata3, 
    
    // MAC03 APB3 ports3
    prdata_mac03,
    psel_mac03,
    pready_mac03,
    
    // MAC13 APB3 ports3
    prdata_mac13,
    psel_mac13,
    pready_mac13,
    
    // MAC23 APB3 ports3
    prdata_mac23,
    psel_mac23,
    pready_mac23,
    
    // MAC33 APB3 ports3
    prdata_mac33,
    psel_mac33,
    pready_mac33
);

// AHB3 interface
input         hclk3;     
input         n_hreset3; 
input         hsel3;     
input [31:0]  haddr3;    
input [1:0]   htrans3;   
input [2:0]   hsize3;    
input [31:0]  hwdata3;   
input         hwrite3;   
input         hready_in3;
input [2:0]   hburst3;   
input [3:0]   hprot3;    
input [3:0]   hmaster3;  
input         hmastlock3;
output [31:0] hrdata3;
output        hready3;
output [1:0]  hresp3; 

// APB3 interface
input         pclk3;     
input         n_preset3; 
output [31:0] paddr3;
output   	    pwrite3;
output   	    penable3;
output [31:0] pwdata3;

// MAC03 APB3 ports3
input [31:0] prdata_mac03;
output	     psel_mac03;
input        pready_mac03;

// MAC13 APB3 ports3
input [31:0] prdata_mac13;
output	     psel_mac13;
input        pready_mac13;

// MAC23 APB3 ports3
input [31:0] prdata_mac23;
output	     psel_mac23;
input        pready_mac23;

// MAC33 APB3 ports3
input [31:0] prdata_mac33;
output	     psel_mac33;
input        pready_mac33;

wire  [31:0] prdata_alut3;

assign tie_hi_bit3 = 1'b1;

ahb2apb3 #(
  32'h00A00000, // Slave3 0 Address Range3
  32'h00A0FFFF,

  32'h00A10000, // Slave3 1 Address Range3
  32'h00A1FFFF,

  32'h00A20000, // Slave3 2 Address Range3 
  32'h00A2FFFF,

  32'h00A30000, // Slave3 3 Address Range3
  32'h00A3FFFF,

  32'h00A40000, // Slave3 4 Address Range3
  32'h00A4FFFF
) i_ahb2apb3 (
     // AHB3 interface
    .hclk3(hclk3),         
    .hreset_n3(n_hreset3), 
    .hsel3(hsel3), 
    .haddr3(haddr3),        
    .htrans3(htrans3),       
    .hwrite3(hwrite3),       
    .hwdata3(hwdata3),       
    .hrdata3(hrdata3),   
    .hready3(hready3),   
    .hresp3(hresp3),     
    
     // APB3 interface
    .pclk3(pclk3),         
    .preset_n3(n_preset3),  
    .prdata03(prdata_alut3),
    .prdata13(prdata_mac03), 
    .prdata23(prdata_mac13),  
    .prdata33(prdata_mac23),   
    .prdata43(prdata_mac33),   
    .prdata53(32'h0),   
    .prdata63(32'h0),    
    .prdata73(32'h0),   
    .prdata83(32'h0),  
    .pready03(tie_hi_bit3),     
    .pready13(pready_mac03),   
    .pready23(pready_mac13),     
    .pready33(pready_mac23),     
    .pready43(pready_mac33),     
    .pready53(tie_hi_bit3),     
    .pready63(tie_hi_bit3),     
    .pready73(tie_hi_bit3),     
    .pready83(tie_hi_bit3),  
    .pwdata3(pwdata3),       
    .pwrite3(pwrite3),       
    .paddr3(paddr3),        
    .psel03(psel_alut3),     
    .psel13(psel_mac03),   
    .psel23(psel_mac13),    
    .psel33(psel_mac23),     
    .psel43(psel_mac33),     
    .psel53(),     
    .psel63(),    
    .psel73(),   
    .psel83(),  
    .penable3(penable3)     
);

alut_veneer3 i_alut_veneer3 (
        //inputs3
        . n_p_reset3(n_preset3),
        . pclk3(pclk3),
        . psel3(psel_alut3),
        . penable3(penable3),
        . pwrite3(pwrite3),
        . paddr3(paddr3[6:0]),
        . pwdata3(pwdata3),

        //outputs3
        . prdata3(prdata_alut3)
);

//------------------------------------------------------------------------------
// APB3 and AHB3 interface formal3 verification3 monitors3
//------------------------------------------------------------------------------
`ifdef ABV_ON3
apb_assert3 i_apb_assert3 (

   // APB3 signals3
  	.n_preset3(n_preset3),
  	.pclk3(pclk3),
	.penable3(penable3),
	.paddr3(paddr3),
	.pwrite3(pwrite3),
	.pwdata3(pwdata3),

  .psel003(psel_alut3),
	.psel013(psel_mac03),
	.psel023(psel_mac13),
	.psel033(psel_mac23),
	.psel043(psel_mac33),
	.psel053(psel053),
	.psel063(psel063),
	.psel073(psel073),
	.psel083(psel083),
	.psel093(psel093),
	.psel103(psel103),
	.psel113(psel113),
	.psel123(psel123),
	.psel133(psel133),
	.psel143(psel143),
	.psel153(psel153),

   .prdata003(prdata_alut3), // Read Data from peripheral3 ALUT3

   // AHB3 signals3
   .hclk3(hclk3),         // ahb3 system clock3
   .n_hreset3(n_hreset3), // ahb3 system reset

   // ahb2apb3 signals3
   .hresp3(hresp3),
   .hready3(hready3),
   .hrdata3(hrdata3),
   .hwdata3(hwdata3),
   .hprot3(hprot3),
   .hburst3(hburst3),
   .hsize3(hsize3),
   .hwrite3(hwrite3),
   .htrans3(htrans3),
   .haddr3(haddr3),
   .ahb2apb_hsel3(ahb2apb1_hsel3));



//------------------------------------------------------------------------------
// AHB3 interface formal3 verification3 monitor3
//------------------------------------------------------------------------------

defparam i_ahbSlaveMonitor3.DBUS_WIDTH3 = 32;
defparam i_ahbMasterMonitor3.DBUS_WIDTH3 = 32;


// AHB2APB3 Bridge3

    ahb_liteslave_monitor3 i_ahbSlaveMonitor3 (
        .hclk_i3(hclk3),
        .hresetn_i3(n_hreset3),
        .hresp3(hresp3),
        .hready3(hready3),
        .hready_global_i3(hready3),
        .hrdata3(hrdata3),
        .hwdata_i3(hwdata3),
        .hburst_i3(hburst3),
        .hsize_i3(hsize3),
        .hwrite_i3(hwrite3),
        .htrans_i3(htrans3),
        .haddr_i3(haddr3),
        .hsel_i3(ahb2apb1_hsel3)
    );


  ahb_litemaster_monitor3 i_ahbMasterMonitor3 (
          .hclk_i3(hclk3),
          .hresetn_i3(n_hreset3),
          .hresp_i3(hresp3),
          .hready_i3(hready3),
          .hrdata_i3(hrdata3),
          .hlock3(1'b0),
          .hwdata3(hwdata3),
          .hprot3(hprot3),
          .hburst3(hburst3),
          .hsize3(hsize3),
          .hwrite3(hwrite3),
          .htrans3(htrans3),
          .haddr3(haddr3)
          );






`endif




endmodule
