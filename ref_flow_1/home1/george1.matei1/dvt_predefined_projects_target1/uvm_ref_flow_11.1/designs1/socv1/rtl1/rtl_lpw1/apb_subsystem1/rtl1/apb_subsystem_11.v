//File1 name   : apb_subsystem_11.v
//Title1       : 
//Created1     : 1999
//Description1 : 
//Notes1       : 
//----------------------------------------------------------------------
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------

module apb_subsystem_11(
    // AHB1 interface
    hclk1,         
    n_hreset1,     
    hsel1,         
    haddr1,        
    htrans1,       
    hsize1,        
    hwrite1,       
    hwdata1,       
    hready_in1,    
    hburst1,     
    hprot1,      
    hmaster1,    
    hmastlock1,  
    hrdata1,     
    hready1,     
    hresp1,      

    // APB1 interface
    pclk1,       
    n_preset1,  
    paddr1,
    pwrite1,
    penable1,
    pwdata1, 
    
    // MAC01 APB1 ports1
    prdata_mac01,
    psel_mac01,
    pready_mac01,
    
    // MAC11 APB1 ports1
    prdata_mac11,
    psel_mac11,
    pready_mac11,
    
    // MAC21 APB1 ports1
    prdata_mac21,
    psel_mac21,
    pready_mac21,
    
    // MAC31 APB1 ports1
    prdata_mac31,
    psel_mac31,
    pready_mac31
);

// AHB1 interface
input         hclk1;     
input         n_hreset1; 
input         hsel1;     
input [31:0]  haddr1;    
input [1:0]   htrans1;   
input [2:0]   hsize1;    
input [31:0]  hwdata1;   
input         hwrite1;   
input         hready_in1;
input [2:0]   hburst1;   
input [3:0]   hprot1;    
input [3:0]   hmaster1;  
input         hmastlock1;
output [31:0] hrdata1;
output        hready1;
output [1:0]  hresp1; 

// APB1 interface
input         pclk1;     
input         n_preset1; 
output [31:0] paddr1;
output   	    pwrite1;
output   	    penable1;
output [31:0] pwdata1;

// MAC01 APB1 ports1
input [31:0] prdata_mac01;
output	     psel_mac01;
input        pready_mac01;

// MAC11 APB1 ports1
input [31:0] prdata_mac11;
output	     psel_mac11;
input        pready_mac11;

// MAC21 APB1 ports1
input [31:0] prdata_mac21;
output	     psel_mac21;
input        pready_mac21;

// MAC31 APB1 ports1
input [31:0] prdata_mac31;
output	     psel_mac31;
input        pready_mac31;

wire  [31:0] prdata_alut1;

assign tie_hi_bit1 = 1'b1;

ahb2apb1 #(
  32'h00A00000, // Slave1 0 Address Range1
  32'h00A0FFFF,

  32'h00A10000, // Slave1 1 Address Range1
  32'h00A1FFFF,

  32'h00A20000, // Slave1 2 Address Range1 
  32'h00A2FFFF,

  32'h00A30000, // Slave1 3 Address Range1
  32'h00A3FFFF,

  32'h00A40000, // Slave1 4 Address Range1
  32'h00A4FFFF
) i_ahb2apb1 (
     // AHB1 interface
    .hclk1(hclk1),         
    .hreset_n1(n_hreset1), 
    .hsel1(hsel1), 
    .haddr1(haddr1),        
    .htrans1(htrans1),       
    .hwrite1(hwrite1),       
    .hwdata1(hwdata1),       
    .hrdata1(hrdata1),   
    .hready1(hready1),   
    .hresp1(hresp1),     
    
     // APB1 interface
    .pclk1(pclk1),         
    .preset_n1(n_preset1),  
    .prdata01(prdata_alut1),
    .prdata11(prdata_mac01), 
    .prdata21(prdata_mac11),  
    .prdata31(prdata_mac21),   
    .prdata41(prdata_mac31),   
    .prdata51(32'h0),   
    .prdata61(32'h0),    
    .prdata71(32'h0),   
    .prdata81(32'h0),  
    .pready01(tie_hi_bit1),     
    .pready11(pready_mac01),   
    .pready21(pready_mac11),     
    .pready31(pready_mac21),     
    .pready41(pready_mac31),     
    .pready51(tie_hi_bit1),     
    .pready61(tie_hi_bit1),     
    .pready71(tie_hi_bit1),     
    .pready81(tie_hi_bit1),  
    .pwdata1(pwdata1),       
    .pwrite1(pwrite1),       
    .paddr1(paddr1),        
    .psel01(psel_alut1),     
    .psel11(psel_mac01),   
    .psel21(psel_mac11),    
    .psel31(psel_mac21),     
    .psel41(psel_mac31),     
    .psel51(),     
    .psel61(),    
    .psel71(),   
    .psel81(),  
    .penable1(penable1)     
);

alut_veneer1 i_alut_veneer1 (
        //inputs1
        . n_p_reset1(n_preset1),
        . pclk1(pclk1),
        . psel1(psel_alut1),
        . penable1(penable1),
        . pwrite1(pwrite1),
        . paddr1(paddr1[6:0]),
        . pwdata1(pwdata1),

        //outputs1
        . prdata1(prdata_alut1)
);

//------------------------------------------------------------------------------
// APB1 and AHB1 interface formal1 verification1 monitors1
//------------------------------------------------------------------------------
`ifdef ABV_ON1
apb_assert1 i_apb_assert1 (

   // APB1 signals1
  	.n_preset1(n_preset1),
  	.pclk1(pclk1),
	.penable1(penable1),
	.paddr1(paddr1),
	.pwrite1(pwrite1),
	.pwdata1(pwdata1),

  .psel001(psel_alut1),
	.psel011(psel_mac01),
	.psel021(psel_mac11),
	.psel031(psel_mac21),
	.psel041(psel_mac31),
	.psel051(psel051),
	.psel061(psel061),
	.psel071(psel071),
	.psel081(psel081),
	.psel091(psel091),
	.psel101(psel101),
	.psel111(psel111),
	.psel121(psel121),
	.psel131(psel131),
	.psel141(psel141),
	.psel151(psel151),

   .prdata001(prdata_alut1), // Read Data from peripheral1 ALUT1

   // AHB1 signals1
   .hclk1(hclk1),         // ahb1 system clock1
   .n_hreset1(n_hreset1), // ahb1 system reset

   // ahb2apb1 signals1
   .hresp1(hresp1),
   .hready1(hready1),
   .hrdata1(hrdata1),
   .hwdata1(hwdata1),
   .hprot1(hprot1),
   .hburst1(hburst1),
   .hsize1(hsize1),
   .hwrite1(hwrite1),
   .htrans1(htrans1),
   .haddr1(haddr1),
   .ahb2apb_hsel1(ahb2apb1_hsel1));



//------------------------------------------------------------------------------
// AHB1 interface formal1 verification1 monitor1
//------------------------------------------------------------------------------

defparam i_ahbSlaveMonitor1.DBUS_WIDTH1 = 32;
defparam i_ahbMasterMonitor1.DBUS_WIDTH1 = 32;


// AHB2APB1 Bridge1

    ahb_liteslave_monitor1 i_ahbSlaveMonitor1 (
        .hclk_i1(hclk1),
        .hresetn_i1(n_hreset1),
        .hresp1(hresp1),
        .hready1(hready1),
        .hready_global_i1(hready1),
        .hrdata1(hrdata1),
        .hwdata_i1(hwdata1),
        .hburst_i1(hburst1),
        .hsize_i1(hsize1),
        .hwrite_i1(hwrite1),
        .htrans_i1(htrans1),
        .haddr_i1(haddr1),
        .hsel_i1(ahb2apb1_hsel1)
    );


  ahb_litemaster_monitor1 i_ahbMasterMonitor1 (
          .hclk_i1(hclk1),
          .hresetn_i1(n_hreset1),
          .hresp_i1(hresp1),
          .hready_i1(hready1),
          .hrdata_i1(hrdata1),
          .hlock1(1'b0),
          .hwdata1(hwdata1),
          .hprot1(hprot1),
          .hburst1(hburst1),
          .hsize1(hsize1),
          .hwrite1(hwrite1),
          .htrans1(htrans1),
          .haddr1(haddr1)
          );






`endif




endmodule
