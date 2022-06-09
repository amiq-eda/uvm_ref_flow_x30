//File12 name   : apb_subsystem_112.v
//Title12       : 
//Created12     : 1999
//Description12 : 
//Notes12       : 
//----------------------------------------------------------------------
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------

module apb_subsystem_112(
    // AHB12 interface
    hclk12,         
    n_hreset12,     
    hsel12,         
    haddr12,        
    htrans12,       
    hsize12,        
    hwrite12,       
    hwdata12,       
    hready_in12,    
    hburst12,     
    hprot12,      
    hmaster12,    
    hmastlock12,  
    hrdata12,     
    hready12,     
    hresp12,      

    // APB12 interface
    pclk12,       
    n_preset12,  
    paddr12,
    pwrite12,
    penable12,
    pwdata12, 
    
    // MAC012 APB12 ports12
    prdata_mac012,
    psel_mac012,
    pready_mac012,
    
    // MAC112 APB12 ports12
    prdata_mac112,
    psel_mac112,
    pready_mac112,
    
    // MAC212 APB12 ports12
    prdata_mac212,
    psel_mac212,
    pready_mac212,
    
    // MAC312 APB12 ports12
    prdata_mac312,
    psel_mac312,
    pready_mac312
);

// AHB12 interface
input         hclk12;     
input         n_hreset12; 
input         hsel12;     
input [31:0]  haddr12;    
input [1:0]   htrans12;   
input [2:0]   hsize12;    
input [31:0]  hwdata12;   
input         hwrite12;   
input         hready_in12;
input [2:0]   hburst12;   
input [3:0]   hprot12;    
input [3:0]   hmaster12;  
input         hmastlock12;
output [31:0] hrdata12;
output        hready12;
output [1:0]  hresp12; 

// APB12 interface
input         pclk12;     
input         n_preset12; 
output [31:0] paddr12;
output   	    pwrite12;
output   	    penable12;
output [31:0] pwdata12;

// MAC012 APB12 ports12
input [31:0] prdata_mac012;
output	     psel_mac012;
input        pready_mac012;

// MAC112 APB12 ports12
input [31:0] prdata_mac112;
output	     psel_mac112;
input        pready_mac112;

// MAC212 APB12 ports12
input [31:0] prdata_mac212;
output	     psel_mac212;
input        pready_mac212;

// MAC312 APB12 ports12
input [31:0] prdata_mac312;
output	     psel_mac312;
input        pready_mac312;

wire  [31:0] prdata_alut12;

assign tie_hi_bit12 = 1'b1;

ahb2apb12 #(
  32'h00A00000, // Slave12 0 Address Range12
  32'h00A0FFFF,

  32'h00A10000, // Slave12 1 Address Range12
  32'h00A1FFFF,

  32'h00A20000, // Slave12 2 Address Range12 
  32'h00A2FFFF,

  32'h00A30000, // Slave12 3 Address Range12
  32'h00A3FFFF,

  32'h00A40000, // Slave12 4 Address Range12
  32'h00A4FFFF
) i_ahb2apb12 (
     // AHB12 interface
    .hclk12(hclk12),         
    .hreset_n12(n_hreset12), 
    .hsel12(hsel12), 
    .haddr12(haddr12),        
    .htrans12(htrans12),       
    .hwrite12(hwrite12),       
    .hwdata12(hwdata12),       
    .hrdata12(hrdata12),   
    .hready12(hready12),   
    .hresp12(hresp12),     
    
     // APB12 interface
    .pclk12(pclk12),         
    .preset_n12(n_preset12),  
    .prdata012(prdata_alut12),
    .prdata112(prdata_mac012), 
    .prdata212(prdata_mac112),  
    .prdata312(prdata_mac212),   
    .prdata412(prdata_mac312),   
    .prdata512(32'h0),   
    .prdata612(32'h0),    
    .prdata712(32'h0),   
    .prdata812(32'h0),  
    .pready012(tie_hi_bit12),     
    .pready112(pready_mac012),   
    .pready212(pready_mac112),     
    .pready312(pready_mac212),     
    .pready412(pready_mac312),     
    .pready512(tie_hi_bit12),     
    .pready612(tie_hi_bit12),     
    .pready712(tie_hi_bit12),     
    .pready812(tie_hi_bit12),  
    .pwdata12(pwdata12),       
    .pwrite12(pwrite12),       
    .paddr12(paddr12),        
    .psel012(psel_alut12),     
    .psel112(psel_mac012),   
    .psel212(psel_mac112),    
    .psel312(psel_mac212),     
    .psel412(psel_mac312),     
    .psel512(),     
    .psel612(),    
    .psel712(),   
    .psel812(),  
    .penable12(penable12)     
);

alut_veneer12 i_alut_veneer12 (
        //inputs12
        . n_p_reset12(n_preset12),
        . pclk12(pclk12),
        . psel12(psel_alut12),
        . penable12(penable12),
        . pwrite12(pwrite12),
        . paddr12(paddr12[6:0]),
        . pwdata12(pwdata12),

        //outputs12
        . prdata12(prdata_alut12)
);

//------------------------------------------------------------------------------
// APB12 and AHB12 interface formal12 verification12 monitors12
//------------------------------------------------------------------------------
`ifdef ABV_ON12
apb_assert12 i_apb_assert12 (

   // APB12 signals12
  	.n_preset12(n_preset12),
  	.pclk12(pclk12),
	.penable12(penable12),
	.paddr12(paddr12),
	.pwrite12(pwrite12),
	.pwdata12(pwdata12),

  .psel0012(psel_alut12),
	.psel0112(psel_mac012),
	.psel0212(psel_mac112),
	.psel0312(psel_mac212),
	.psel0412(psel_mac312),
	.psel0512(psel0512),
	.psel0612(psel0612),
	.psel0712(psel0712),
	.psel0812(psel0812),
	.psel0912(psel0912),
	.psel1012(psel1012),
	.psel1112(psel1112),
	.psel1212(psel1212),
	.psel1312(psel1312),
	.psel1412(psel1412),
	.psel1512(psel1512),

   .prdata0012(prdata_alut12), // Read Data from peripheral12 ALUT12

   // AHB12 signals12
   .hclk12(hclk12),         // ahb12 system clock12
   .n_hreset12(n_hreset12), // ahb12 system reset

   // ahb2apb12 signals12
   .hresp12(hresp12),
   .hready12(hready12),
   .hrdata12(hrdata12),
   .hwdata12(hwdata12),
   .hprot12(hprot12),
   .hburst12(hburst12),
   .hsize12(hsize12),
   .hwrite12(hwrite12),
   .htrans12(htrans12),
   .haddr12(haddr12),
   .ahb2apb_hsel12(ahb2apb1_hsel12));



//------------------------------------------------------------------------------
// AHB12 interface formal12 verification12 monitor12
//------------------------------------------------------------------------------

defparam i_ahbSlaveMonitor12.DBUS_WIDTH12 = 32;
defparam i_ahbMasterMonitor12.DBUS_WIDTH12 = 32;


// AHB2APB12 Bridge12

    ahb_liteslave_monitor12 i_ahbSlaveMonitor12 (
        .hclk_i12(hclk12),
        .hresetn_i12(n_hreset12),
        .hresp12(hresp12),
        .hready12(hready12),
        .hready_global_i12(hready12),
        .hrdata12(hrdata12),
        .hwdata_i12(hwdata12),
        .hburst_i12(hburst12),
        .hsize_i12(hsize12),
        .hwrite_i12(hwrite12),
        .htrans_i12(htrans12),
        .haddr_i12(haddr12),
        .hsel_i12(ahb2apb1_hsel12)
    );


  ahb_litemaster_monitor12 i_ahbMasterMonitor12 (
          .hclk_i12(hclk12),
          .hresetn_i12(n_hreset12),
          .hresp_i12(hresp12),
          .hready_i12(hready12),
          .hrdata_i12(hrdata12),
          .hlock12(1'b0),
          .hwdata12(hwdata12),
          .hprot12(hprot12),
          .hburst12(hburst12),
          .hsize12(hsize12),
          .hwrite12(hwrite12),
          .htrans12(htrans12),
          .haddr12(haddr12)
          );






`endif




endmodule
