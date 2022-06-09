//File28 name   : apb_subsystem_128.v
//Title28       : 
//Created28     : 1999
//Description28 : 
//Notes28       : 
//----------------------------------------------------------------------
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------

module apb_subsystem_128(
    // AHB28 interface
    hclk28,         
    n_hreset28,     
    hsel28,         
    haddr28,        
    htrans28,       
    hsize28,        
    hwrite28,       
    hwdata28,       
    hready_in28,    
    hburst28,     
    hprot28,      
    hmaster28,    
    hmastlock28,  
    hrdata28,     
    hready28,     
    hresp28,      

    // APB28 interface
    pclk28,       
    n_preset28,  
    paddr28,
    pwrite28,
    penable28,
    pwdata28, 
    
    // MAC028 APB28 ports28
    prdata_mac028,
    psel_mac028,
    pready_mac028,
    
    // MAC128 APB28 ports28
    prdata_mac128,
    psel_mac128,
    pready_mac128,
    
    // MAC228 APB28 ports28
    prdata_mac228,
    psel_mac228,
    pready_mac228,
    
    // MAC328 APB28 ports28
    prdata_mac328,
    psel_mac328,
    pready_mac328
);

// AHB28 interface
input         hclk28;     
input         n_hreset28; 
input         hsel28;     
input [31:0]  haddr28;    
input [1:0]   htrans28;   
input [2:0]   hsize28;    
input [31:0]  hwdata28;   
input         hwrite28;   
input         hready_in28;
input [2:0]   hburst28;   
input [3:0]   hprot28;    
input [3:0]   hmaster28;  
input         hmastlock28;
output [31:0] hrdata28;
output        hready28;
output [1:0]  hresp28; 

// APB28 interface
input         pclk28;     
input         n_preset28; 
output [31:0] paddr28;
output   	    pwrite28;
output   	    penable28;
output [31:0] pwdata28;

// MAC028 APB28 ports28
input [31:0] prdata_mac028;
output	     psel_mac028;
input        pready_mac028;

// MAC128 APB28 ports28
input [31:0] prdata_mac128;
output	     psel_mac128;
input        pready_mac128;

// MAC228 APB28 ports28
input [31:0] prdata_mac228;
output	     psel_mac228;
input        pready_mac228;

// MAC328 APB28 ports28
input [31:0] prdata_mac328;
output	     psel_mac328;
input        pready_mac328;

wire  [31:0] prdata_alut28;

assign tie_hi_bit28 = 1'b1;

ahb2apb28 #(
  32'h00A00000, // Slave28 0 Address Range28
  32'h00A0FFFF,

  32'h00A10000, // Slave28 1 Address Range28
  32'h00A1FFFF,

  32'h00A20000, // Slave28 2 Address Range28 
  32'h00A2FFFF,

  32'h00A30000, // Slave28 3 Address Range28
  32'h00A3FFFF,

  32'h00A40000, // Slave28 4 Address Range28
  32'h00A4FFFF
) i_ahb2apb28 (
     // AHB28 interface
    .hclk28(hclk28),         
    .hreset_n28(n_hreset28), 
    .hsel28(hsel28), 
    .haddr28(haddr28),        
    .htrans28(htrans28),       
    .hwrite28(hwrite28),       
    .hwdata28(hwdata28),       
    .hrdata28(hrdata28),   
    .hready28(hready28),   
    .hresp28(hresp28),     
    
     // APB28 interface
    .pclk28(pclk28),         
    .preset_n28(n_preset28),  
    .prdata028(prdata_alut28),
    .prdata128(prdata_mac028), 
    .prdata228(prdata_mac128),  
    .prdata328(prdata_mac228),   
    .prdata428(prdata_mac328),   
    .prdata528(32'h0),   
    .prdata628(32'h0),    
    .prdata728(32'h0),   
    .prdata828(32'h0),  
    .pready028(tie_hi_bit28),     
    .pready128(pready_mac028),   
    .pready228(pready_mac128),     
    .pready328(pready_mac228),     
    .pready428(pready_mac328),     
    .pready528(tie_hi_bit28),     
    .pready628(tie_hi_bit28),     
    .pready728(tie_hi_bit28),     
    .pready828(tie_hi_bit28),  
    .pwdata28(pwdata28),       
    .pwrite28(pwrite28),       
    .paddr28(paddr28),        
    .psel028(psel_alut28),     
    .psel128(psel_mac028),   
    .psel228(psel_mac128),    
    .psel328(psel_mac228),     
    .psel428(psel_mac328),     
    .psel528(),     
    .psel628(),    
    .psel728(),   
    .psel828(),  
    .penable28(penable28)     
);

alut_veneer28 i_alut_veneer28 (
        //inputs28
        . n_p_reset28(n_preset28),
        . pclk28(pclk28),
        . psel28(psel_alut28),
        . penable28(penable28),
        . pwrite28(pwrite28),
        . paddr28(paddr28[6:0]),
        . pwdata28(pwdata28),

        //outputs28
        . prdata28(prdata_alut28)
);

//------------------------------------------------------------------------------
// APB28 and AHB28 interface formal28 verification28 monitors28
//------------------------------------------------------------------------------
`ifdef ABV_ON28
apb_assert28 i_apb_assert28 (

   // APB28 signals28
  	.n_preset28(n_preset28),
  	.pclk28(pclk28),
	.penable28(penable28),
	.paddr28(paddr28),
	.pwrite28(pwrite28),
	.pwdata28(pwdata28),

  .psel0028(psel_alut28),
	.psel0128(psel_mac028),
	.psel0228(psel_mac128),
	.psel0328(psel_mac228),
	.psel0428(psel_mac328),
	.psel0528(psel0528),
	.psel0628(psel0628),
	.psel0728(psel0728),
	.psel0828(psel0828),
	.psel0928(psel0928),
	.psel1028(psel1028),
	.psel1128(psel1128),
	.psel1228(psel1228),
	.psel1328(psel1328),
	.psel1428(psel1428),
	.psel1528(psel1528),

   .prdata0028(prdata_alut28), // Read Data from peripheral28 ALUT28

   // AHB28 signals28
   .hclk28(hclk28),         // ahb28 system clock28
   .n_hreset28(n_hreset28), // ahb28 system reset

   // ahb2apb28 signals28
   .hresp28(hresp28),
   .hready28(hready28),
   .hrdata28(hrdata28),
   .hwdata28(hwdata28),
   .hprot28(hprot28),
   .hburst28(hburst28),
   .hsize28(hsize28),
   .hwrite28(hwrite28),
   .htrans28(htrans28),
   .haddr28(haddr28),
   .ahb2apb_hsel28(ahb2apb1_hsel28));



//------------------------------------------------------------------------------
// AHB28 interface formal28 verification28 monitor28
//------------------------------------------------------------------------------

defparam i_ahbSlaveMonitor28.DBUS_WIDTH28 = 32;
defparam i_ahbMasterMonitor28.DBUS_WIDTH28 = 32;


// AHB2APB28 Bridge28

    ahb_liteslave_monitor28 i_ahbSlaveMonitor28 (
        .hclk_i28(hclk28),
        .hresetn_i28(n_hreset28),
        .hresp28(hresp28),
        .hready28(hready28),
        .hready_global_i28(hready28),
        .hrdata28(hrdata28),
        .hwdata_i28(hwdata28),
        .hburst_i28(hburst28),
        .hsize_i28(hsize28),
        .hwrite_i28(hwrite28),
        .htrans_i28(htrans28),
        .haddr_i28(haddr28),
        .hsel_i28(ahb2apb1_hsel28)
    );


  ahb_litemaster_monitor28 i_ahbMasterMonitor28 (
          .hclk_i28(hclk28),
          .hresetn_i28(n_hreset28),
          .hresp_i28(hresp28),
          .hready_i28(hready28),
          .hrdata_i28(hrdata28),
          .hlock28(1'b0),
          .hwdata28(hwdata28),
          .hprot28(hprot28),
          .hburst28(hburst28),
          .hsize28(hsize28),
          .hwrite28(hwrite28),
          .htrans28(htrans28),
          .haddr28(haddr28)
          );






`endif




endmodule
