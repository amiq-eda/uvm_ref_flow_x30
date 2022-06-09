//File17 name   : apb_subsystem_117.v
//Title17       : 
//Created17     : 1999
//Description17 : 
//Notes17       : 
//----------------------------------------------------------------------
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------

module apb_subsystem_117(
    // AHB17 interface
    hclk17,         
    n_hreset17,     
    hsel17,         
    haddr17,        
    htrans17,       
    hsize17,        
    hwrite17,       
    hwdata17,       
    hready_in17,    
    hburst17,     
    hprot17,      
    hmaster17,    
    hmastlock17,  
    hrdata17,     
    hready17,     
    hresp17,      

    // APB17 interface
    pclk17,       
    n_preset17,  
    paddr17,
    pwrite17,
    penable17,
    pwdata17, 
    
    // MAC017 APB17 ports17
    prdata_mac017,
    psel_mac017,
    pready_mac017,
    
    // MAC117 APB17 ports17
    prdata_mac117,
    psel_mac117,
    pready_mac117,
    
    // MAC217 APB17 ports17
    prdata_mac217,
    psel_mac217,
    pready_mac217,
    
    // MAC317 APB17 ports17
    prdata_mac317,
    psel_mac317,
    pready_mac317
);

// AHB17 interface
input         hclk17;     
input         n_hreset17; 
input         hsel17;     
input [31:0]  haddr17;    
input [1:0]   htrans17;   
input [2:0]   hsize17;    
input [31:0]  hwdata17;   
input         hwrite17;   
input         hready_in17;
input [2:0]   hburst17;   
input [3:0]   hprot17;    
input [3:0]   hmaster17;  
input         hmastlock17;
output [31:0] hrdata17;
output        hready17;
output [1:0]  hresp17; 

// APB17 interface
input         pclk17;     
input         n_preset17; 
output [31:0] paddr17;
output   	    pwrite17;
output   	    penable17;
output [31:0] pwdata17;

// MAC017 APB17 ports17
input [31:0] prdata_mac017;
output	     psel_mac017;
input        pready_mac017;

// MAC117 APB17 ports17
input [31:0] prdata_mac117;
output	     psel_mac117;
input        pready_mac117;

// MAC217 APB17 ports17
input [31:0] prdata_mac217;
output	     psel_mac217;
input        pready_mac217;

// MAC317 APB17 ports17
input [31:0] prdata_mac317;
output	     psel_mac317;
input        pready_mac317;

wire  [31:0] prdata_alut17;

assign tie_hi_bit17 = 1'b1;

ahb2apb17 #(
  32'h00A00000, // Slave17 0 Address Range17
  32'h00A0FFFF,

  32'h00A10000, // Slave17 1 Address Range17
  32'h00A1FFFF,

  32'h00A20000, // Slave17 2 Address Range17 
  32'h00A2FFFF,

  32'h00A30000, // Slave17 3 Address Range17
  32'h00A3FFFF,

  32'h00A40000, // Slave17 4 Address Range17
  32'h00A4FFFF
) i_ahb2apb17 (
     // AHB17 interface
    .hclk17(hclk17),         
    .hreset_n17(n_hreset17), 
    .hsel17(hsel17), 
    .haddr17(haddr17),        
    .htrans17(htrans17),       
    .hwrite17(hwrite17),       
    .hwdata17(hwdata17),       
    .hrdata17(hrdata17),   
    .hready17(hready17),   
    .hresp17(hresp17),     
    
     // APB17 interface
    .pclk17(pclk17),         
    .preset_n17(n_preset17),  
    .prdata017(prdata_alut17),
    .prdata117(prdata_mac017), 
    .prdata217(prdata_mac117),  
    .prdata317(prdata_mac217),   
    .prdata417(prdata_mac317),   
    .prdata517(32'h0),   
    .prdata617(32'h0),    
    .prdata717(32'h0),   
    .prdata817(32'h0),  
    .pready017(tie_hi_bit17),     
    .pready117(pready_mac017),   
    .pready217(pready_mac117),     
    .pready317(pready_mac217),     
    .pready417(pready_mac317),     
    .pready517(tie_hi_bit17),     
    .pready617(tie_hi_bit17),     
    .pready717(tie_hi_bit17),     
    .pready817(tie_hi_bit17),  
    .pwdata17(pwdata17),       
    .pwrite17(pwrite17),       
    .paddr17(paddr17),        
    .psel017(psel_alut17),     
    .psel117(psel_mac017),   
    .psel217(psel_mac117),    
    .psel317(psel_mac217),     
    .psel417(psel_mac317),     
    .psel517(),     
    .psel617(),    
    .psel717(),   
    .psel817(),  
    .penable17(penable17)     
);

alut_veneer17 i_alut_veneer17 (
        //inputs17
        . n_p_reset17(n_preset17),
        . pclk17(pclk17),
        . psel17(psel_alut17),
        . penable17(penable17),
        . pwrite17(pwrite17),
        . paddr17(paddr17[6:0]),
        . pwdata17(pwdata17),

        //outputs17
        . prdata17(prdata_alut17)
);

//------------------------------------------------------------------------------
// APB17 and AHB17 interface formal17 verification17 monitors17
//------------------------------------------------------------------------------
`ifdef ABV_ON17
apb_assert17 i_apb_assert17 (

   // APB17 signals17
  	.n_preset17(n_preset17),
  	.pclk17(pclk17),
	.penable17(penable17),
	.paddr17(paddr17),
	.pwrite17(pwrite17),
	.pwdata17(pwdata17),

  .psel0017(psel_alut17),
	.psel0117(psel_mac017),
	.psel0217(psel_mac117),
	.psel0317(psel_mac217),
	.psel0417(psel_mac317),
	.psel0517(psel0517),
	.psel0617(psel0617),
	.psel0717(psel0717),
	.psel0817(psel0817),
	.psel0917(psel0917),
	.psel1017(psel1017),
	.psel1117(psel1117),
	.psel1217(psel1217),
	.psel1317(psel1317),
	.psel1417(psel1417),
	.psel1517(psel1517),

   .prdata0017(prdata_alut17), // Read Data from peripheral17 ALUT17

   // AHB17 signals17
   .hclk17(hclk17),         // ahb17 system clock17
   .n_hreset17(n_hreset17), // ahb17 system reset

   // ahb2apb17 signals17
   .hresp17(hresp17),
   .hready17(hready17),
   .hrdata17(hrdata17),
   .hwdata17(hwdata17),
   .hprot17(hprot17),
   .hburst17(hburst17),
   .hsize17(hsize17),
   .hwrite17(hwrite17),
   .htrans17(htrans17),
   .haddr17(haddr17),
   .ahb2apb_hsel17(ahb2apb1_hsel17));



//------------------------------------------------------------------------------
// AHB17 interface formal17 verification17 monitor17
//------------------------------------------------------------------------------

defparam i_ahbSlaveMonitor17.DBUS_WIDTH17 = 32;
defparam i_ahbMasterMonitor17.DBUS_WIDTH17 = 32;


// AHB2APB17 Bridge17

    ahb_liteslave_monitor17 i_ahbSlaveMonitor17 (
        .hclk_i17(hclk17),
        .hresetn_i17(n_hreset17),
        .hresp17(hresp17),
        .hready17(hready17),
        .hready_global_i17(hready17),
        .hrdata17(hrdata17),
        .hwdata_i17(hwdata17),
        .hburst_i17(hburst17),
        .hsize_i17(hsize17),
        .hwrite_i17(hwrite17),
        .htrans_i17(htrans17),
        .haddr_i17(haddr17),
        .hsel_i17(ahb2apb1_hsel17)
    );


  ahb_litemaster_monitor17 i_ahbMasterMonitor17 (
          .hclk_i17(hclk17),
          .hresetn_i17(n_hreset17),
          .hresp_i17(hresp17),
          .hready_i17(hready17),
          .hrdata_i17(hrdata17),
          .hlock17(1'b0),
          .hwdata17(hwdata17),
          .hprot17(hprot17),
          .hburst17(hburst17),
          .hsize17(hsize17),
          .hwrite17(hwrite17),
          .htrans17(htrans17),
          .haddr17(haddr17)
          );






`endif




endmodule
