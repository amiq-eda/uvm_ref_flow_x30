//File19 name   : apb_subsystem_119.v
//Title19       : 
//Created19     : 1999
//Description19 : 
//Notes19       : 
//----------------------------------------------------------------------
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------

module apb_subsystem_119(
    // AHB19 interface
    hclk19,         
    n_hreset19,     
    hsel19,         
    haddr19,        
    htrans19,       
    hsize19,        
    hwrite19,       
    hwdata19,       
    hready_in19,    
    hburst19,     
    hprot19,      
    hmaster19,    
    hmastlock19,  
    hrdata19,     
    hready19,     
    hresp19,      

    // APB19 interface
    pclk19,       
    n_preset19,  
    paddr19,
    pwrite19,
    penable19,
    pwdata19, 
    
    // MAC019 APB19 ports19
    prdata_mac019,
    psel_mac019,
    pready_mac019,
    
    // MAC119 APB19 ports19
    prdata_mac119,
    psel_mac119,
    pready_mac119,
    
    // MAC219 APB19 ports19
    prdata_mac219,
    psel_mac219,
    pready_mac219,
    
    // MAC319 APB19 ports19
    prdata_mac319,
    psel_mac319,
    pready_mac319
);

// AHB19 interface
input         hclk19;     
input         n_hreset19; 
input         hsel19;     
input [31:0]  haddr19;    
input [1:0]   htrans19;   
input [2:0]   hsize19;    
input [31:0]  hwdata19;   
input         hwrite19;   
input         hready_in19;
input [2:0]   hburst19;   
input [3:0]   hprot19;    
input [3:0]   hmaster19;  
input         hmastlock19;
output [31:0] hrdata19;
output        hready19;
output [1:0]  hresp19; 

// APB19 interface
input         pclk19;     
input         n_preset19; 
output [31:0] paddr19;
output   	    pwrite19;
output   	    penable19;
output [31:0] pwdata19;

// MAC019 APB19 ports19
input [31:0] prdata_mac019;
output	     psel_mac019;
input        pready_mac019;

// MAC119 APB19 ports19
input [31:0] prdata_mac119;
output	     psel_mac119;
input        pready_mac119;

// MAC219 APB19 ports19
input [31:0] prdata_mac219;
output	     psel_mac219;
input        pready_mac219;

// MAC319 APB19 ports19
input [31:0] prdata_mac319;
output	     psel_mac319;
input        pready_mac319;

wire  [31:0] prdata_alut19;

assign tie_hi_bit19 = 1'b1;

ahb2apb19 #(
  32'h00A00000, // Slave19 0 Address Range19
  32'h00A0FFFF,

  32'h00A10000, // Slave19 1 Address Range19
  32'h00A1FFFF,

  32'h00A20000, // Slave19 2 Address Range19 
  32'h00A2FFFF,

  32'h00A30000, // Slave19 3 Address Range19
  32'h00A3FFFF,

  32'h00A40000, // Slave19 4 Address Range19
  32'h00A4FFFF
) i_ahb2apb19 (
     // AHB19 interface
    .hclk19(hclk19),         
    .hreset_n19(n_hreset19), 
    .hsel19(hsel19), 
    .haddr19(haddr19),        
    .htrans19(htrans19),       
    .hwrite19(hwrite19),       
    .hwdata19(hwdata19),       
    .hrdata19(hrdata19),   
    .hready19(hready19),   
    .hresp19(hresp19),     
    
     // APB19 interface
    .pclk19(pclk19),         
    .preset_n19(n_preset19),  
    .prdata019(prdata_alut19),
    .prdata119(prdata_mac019), 
    .prdata219(prdata_mac119),  
    .prdata319(prdata_mac219),   
    .prdata419(prdata_mac319),   
    .prdata519(32'h0),   
    .prdata619(32'h0),    
    .prdata719(32'h0),   
    .prdata819(32'h0),  
    .pready019(tie_hi_bit19),     
    .pready119(pready_mac019),   
    .pready219(pready_mac119),     
    .pready319(pready_mac219),     
    .pready419(pready_mac319),     
    .pready519(tie_hi_bit19),     
    .pready619(tie_hi_bit19),     
    .pready719(tie_hi_bit19),     
    .pready819(tie_hi_bit19),  
    .pwdata19(pwdata19),       
    .pwrite19(pwrite19),       
    .paddr19(paddr19),        
    .psel019(psel_alut19),     
    .psel119(psel_mac019),   
    .psel219(psel_mac119),    
    .psel319(psel_mac219),     
    .psel419(psel_mac319),     
    .psel519(),     
    .psel619(),    
    .psel719(),   
    .psel819(),  
    .penable19(penable19)     
);

alut_veneer19 i_alut_veneer19 (
        //inputs19
        . n_p_reset19(n_preset19),
        . pclk19(pclk19),
        . psel19(psel_alut19),
        . penable19(penable19),
        . pwrite19(pwrite19),
        . paddr19(paddr19[6:0]),
        . pwdata19(pwdata19),

        //outputs19
        . prdata19(prdata_alut19)
);

//------------------------------------------------------------------------------
// APB19 and AHB19 interface formal19 verification19 monitors19
//------------------------------------------------------------------------------
`ifdef ABV_ON19
apb_assert19 i_apb_assert19 (

   // APB19 signals19
  	.n_preset19(n_preset19),
  	.pclk19(pclk19),
	.penable19(penable19),
	.paddr19(paddr19),
	.pwrite19(pwrite19),
	.pwdata19(pwdata19),

  .psel0019(psel_alut19),
	.psel0119(psel_mac019),
	.psel0219(psel_mac119),
	.psel0319(psel_mac219),
	.psel0419(psel_mac319),
	.psel0519(psel0519),
	.psel0619(psel0619),
	.psel0719(psel0719),
	.psel0819(psel0819),
	.psel0919(psel0919),
	.psel1019(psel1019),
	.psel1119(psel1119),
	.psel1219(psel1219),
	.psel1319(psel1319),
	.psel1419(psel1419),
	.psel1519(psel1519),

   .prdata0019(prdata_alut19), // Read Data from peripheral19 ALUT19

   // AHB19 signals19
   .hclk19(hclk19),         // ahb19 system clock19
   .n_hreset19(n_hreset19), // ahb19 system reset

   // ahb2apb19 signals19
   .hresp19(hresp19),
   .hready19(hready19),
   .hrdata19(hrdata19),
   .hwdata19(hwdata19),
   .hprot19(hprot19),
   .hburst19(hburst19),
   .hsize19(hsize19),
   .hwrite19(hwrite19),
   .htrans19(htrans19),
   .haddr19(haddr19),
   .ahb2apb_hsel19(ahb2apb1_hsel19));



//------------------------------------------------------------------------------
// AHB19 interface formal19 verification19 monitor19
//------------------------------------------------------------------------------

defparam i_ahbSlaveMonitor19.DBUS_WIDTH19 = 32;
defparam i_ahbMasterMonitor19.DBUS_WIDTH19 = 32;


// AHB2APB19 Bridge19

    ahb_liteslave_monitor19 i_ahbSlaveMonitor19 (
        .hclk_i19(hclk19),
        .hresetn_i19(n_hreset19),
        .hresp19(hresp19),
        .hready19(hready19),
        .hready_global_i19(hready19),
        .hrdata19(hrdata19),
        .hwdata_i19(hwdata19),
        .hburst_i19(hburst19),
        .hsize_i19(hsize19),
        .hwrite_i19(hwrite19),
        .htrans_i19(htrans19),
        .haddr_i19(haddr19),
        .hsel_i19(ahb2apb1_hsel19)
    );


  ahb_litemaster_monitor19 i_ahbMasterMonitor19 (
          .hclk_i19(hclk19),
          .hresetn_i19(n_hreset19),
          .hresp_i19(hresp19),
          .hready_i19(hready19),
          .hrdata_i19(hrdata19),
          .hlock19(1'b0),
          .hwdata19(hwdata19),
          .hprot19(hprot19),
          .hburst19(hburst19),
          .hsize19(hsize19),
          .hwrite19(hwrite19),
          .htrans19(htrans19),
          .haddr19(haddr19)
          );






`endif




endmodule
