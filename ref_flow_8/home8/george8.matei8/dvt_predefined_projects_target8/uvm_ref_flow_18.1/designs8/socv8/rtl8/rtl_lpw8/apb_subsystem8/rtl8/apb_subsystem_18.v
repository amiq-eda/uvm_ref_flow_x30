//File8 name   : apb_subsystem_18.v
//Title8       : 
//Created8     : 1999
//Description8 : 
//Notes8       : 
//----------------------------------------------------------------------
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------

module apb_subsystem_18(
    // AHB8 interface
    hclk8,         
    n_hreset8,     
    hsel8,         
    haddr8,        
    htrans8,       
    hsize8,        
    hwrite8,       
    hwdata8,       
    hready_in8,    
    hburst8,     
    hprot8,      
    hmaster8,    
    hmastlock8,  
    hrdata8,     
    hready8,     
    hresp8,      

    // APB8 interface
    pclk8,       
    n_preset8,  
    paddr8,
    pwrite8,
    penable8,
    pwdata8, 
    
    // MAC08 APB8 ports8
    prdata_mac08,
    psel_mac08,
    pready_mac08,
    
    // MAC18 APB8 ports8
    prdata_mac18,
    psel_mac18,
    pready_mac18,
    
    // MAC28 APB8 ports8
    prdata_mac28,
    psel_mac28,
    pready_mac28,
    
    // MAC38 APB8 ports8
    prdata_mac38,
    psel_mac38,
    pready_mac38
);

// AHB8 interface
input         hclk8;     
input         n_hreset8; 
input         hsel8;     
input [31:0]  haddr8;    
input [1:0]   htrans8;   
input [2:0]   hsize8;    
input [31:0]  hwdata8;   
input         hwrite8;   
input         hready_in8;
input [2:0]   hburst8;   
input [3:0]   hprot8;    
input [3:0]   hmaster8;  
input         hmastlock8;
output [31:0] hrdata8;
output        hready8;
output [1:0]  hresp8; 

// APB8 interface
input         pclk8;     
input         n_preset8; 
output [31:0] paddr8;
output   	    pwrite8;
output   	    penable8;
output [31:0] pwdata8;

// MAC08 APB8 ports8
input [31:0] prdata_mac08;
output	     psel_mac08;
input        pready_mac08;

// MAC18 APB8 ports8
input [31:0] prdata_mac18;
output	     psel_mac18;
input        pready_mac18;

// MAC28 APB8 ports8
input [31:0] prdata_mac28;
output	     psel_mac28;
input        pready_mac28;

// MAC38 APB8 ports8
input [31:0] prdata_mac38;
output	     psel_mac38;
input        pready_mac38;

wire  [31:0] prdata_alut8;

assign tie_hi_bit8 = 1'b1;

ahb2apb8 #(
  32'h00A00000, // Slave8 0 Address Range8
  32'h00A0FFFF,

  32'h00A10000, // Slave8 1 Address Range8
  32'h00A1FFFF,

  32'h00A20000, // Slave8 2 Address Range8 
  32'h00A2FFFF,

  32'h00A30000, // Slave8 3 Address Range8
  32'h00A3FFFF,

  32'h00A40000, // Slave8 4 Address Range8
  32'h00A4FFFF
) i_ahb2apb8 (
     // AHB8 interface
    .hclk8(hclk8),         
    .hreset_n8(n_hreset8), 
    .hsel8(hsel8), 
    .haddr8(haddr8),        
    .htrans8(htrans8),       
    .hwrite8(hwrite8),       
    .hwdata8(hwdata8),       
    .hrdata8(hrdata8),   
    .hready8(hready8),   
    .hresp8(hresp8),     
    
     // APB8 interface
    .pclk8(pclk8),         
    .preset_n8(n_preset8),  
    .prdata08(prdata_alut8),
    .prdata18(prdata_mac08), 
    .prdata28(prdata_mac18),  
    .prdata38(prdata_mac28),   
    .prdata48(prdata_mac38),   
    .prdata58(32'h0),   
    .prdata68(32'h0),    
    .prdata78(32'h0),   
    .prdata88(32'h0),  
    .pready08(tie_hi_bit8),     
    .pready18(pready_mac08),   
    .pready28(pready_mac18),     
    .pready38(pready_mac28),     
    .pready48(pready_mac38),     
    .pready58(tie_hi_bit8),     
    .pready68(tie_hi_bit8),     
    .pready78(tie_hi_bit8),     
    .pready88(tie_hi_bit8),  
    .pwdata8(pwdata8),       
    .pwrite8(pwrite8),       
    .paddr8(paddr8),        
    .psel08(psel_alut8),     
    .psel18(psel_mac08),   
    .psel28(psel_mac18),    
    .psel38(psel_mac28),     
    .psel48(psel_mac38),     
    .psel58(),     
    .psel68(),    
    .psel78(),   
    .psel88(),  
    .penable8(penable8)     
);

alut_veneer8 i_alut_veneer8 (
        //inputs8
        . n_p_reset8(n_preset8),
        . pclk8(pclk8),
        . psel8(psel_alut8),
        . penable8(penable8),
        . pwrite8(pwrite8),
        . paddr8(paddr8[6:0]),
        . pwdata8(pwdata8),

        //outputs8
        . prdata8(prdata_alut8)
);

//------------------------------------------------------------------------------
// APB8 and AHB8 interface formal8 verification8 monitors8
//------------------------------------------------------------------------------
`ifdef ABV_ON8
apb_assert8 i_apb_assert8 (

   // APB8 signals8
  	.n_preset8(n_preset8),
  	.pclk8(pclk8),
	.penable8(penable8),
	.paddr8(paddr8),
	.pwrite8(pwrite8),
	.pwdata8(pwdata8),

  .psel008(psel_alut8),
	.psel018(psel_mac08),
	.psel028(psel_mac18),
	.psel038(psel_mac28),
	.psel048(psel_mac38),
	.psel058(psel058),
	.psel068(psel068),
	.psel078(psel078),
	.psel088(psel088),
	.psel098(psel098),
	.psel108(psel108),
	.psel118(psel118),
	.psel128(psel128),
	.psel138(psel138),
	.psel148(psel148),
	.psel158(psel158),

   .prdata008(prdata_alut8), // Read Data from peripheral8 ALUT8

   // AHB8 signals8
   .hclk8(hclk8),         // ahb8 system clock8
   .n_hreset8(n_hreset8), // ahb8 system reset

   // ahb2apb8 signals8
   .hresp8(hresp8),
   .hready8(hready8),
   .hrdata8(hrdata8),
   .hwdata8(hwdata8),
   .hprot8(hprot8),
   .hburst8(hburst8),
   .hsize8(hsize8),
   .hwrite8(hwrite8),
   .htrans8(htrans8),
   .haddr8(haddr8),
   .ahb2apb_hsel8(ahb2apb1_hsel8));



//------------------------------------------------------------------------------
// AHB8 interface formal8 verification8 monitor8
//------------------------------------------------------------------------------

defparam i_ahbSlaveMonitor8.DBUS_WIDTH8 = 32;
defparam i_ahbMasterMonitor8.DBUS_WIDTH8 = 32;


// AHB2APB8 Bridge8

    ahb_liteslave_monitor8 i_ahbSlaveMonitor8 (
        .hclk_i8(hclk8),
        .hresetn_i8(n_hreset8),
        .hresp8(hresp8),
        .hready8(hready8),
        .hready_global_i8(hready8),
        .hrdata8(hrdata8),
        .hwdata_i8(hwdata8),
        .hburst_i8(hburst8),
        .hsize_i8(hsize8),
        .hwrite_i8(hwrite8),
        .htrans_i8(htrans8),
        .haddr_i8(haddr8),
        .hsel_i8(ahb2apb1_hsel8)
    );


  ahb_litemaster_monitor8 i_ahbMasterMonitor8 (
          .hclk_i8(hclk8),
          .hresetn_i8(n_hreset8),
          .hresp_i8(hresp8),
          .hready_i8(hready8),
          .hrdata_i8(hrdata8),
          .hlock8(1'b0),
          .hwdata8(hwdata8),
          .hprot8(hprot8),
          .hburst8(hburst8),
          .hsize8(hsize8),
          .hwrite8(hwrite8),
          .htrans8(htrans8),
          .haddr8(haddr8)
          );






`endif




endmodule
