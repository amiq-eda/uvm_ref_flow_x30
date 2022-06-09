//File4 name   : apb_subsystem_14.v
//Title4       : 
//Created4     : 1999
//Description4 : 
//Notes4       : 
//----------------------------------------------------------------------
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------

module apb_subsystem_14(
    // AHB4 interface
    hclk4,         
    n_hreset4,     
    hsel4,         
    haddr4,        
    htrans4,       
    hsize4,        
    hwrite4,       
    hwdata4,       
    hready_in4,    
    hburst4,     
    hprot4,      
    hmaster4,    
    hmastlock4,  
    hrdata4,     
    hready4,     
    hresp4,      

    // APB4 interface
    pclk4,       
    n_preset4,  
    paddr4,
    pwrite4,
    penable4,
    pwdata4, 
    
    // MAC04 APB4 ports4
    prdata_mac04,
    psel_mac04,
    pready_mac04,
    
    // MAC14 APB4 ports4
    prdata_mac14,
    psel_mac14,
    pready_mac14,
    
    // MAC24 APB4 ports4
    prdata_mac24,
    psel_mac24,
    pready_mac24,
    
    // MAC34 APB4 ports4
    prdata_mac34,
    psel_mac34,
    pready_mac34
);

// AHB4 interface
input         hclk4;     
input         n_hreset4; 
input         hsel4;     
input [31:0]  haddr4;    
input [1:0]   htrans4;   
input [2:0]   hsize4;    
input [31:0]  hwdata4;   
input         hwrite4;   
input         hready_in4;
input [2:0]   hburst4;   
input [3:0]   hprot4;    
input [3:0]   hmaster4;  
input         hmastlock4;
output [31:0] hrdata4;
output        hready4;
output [1:0]  hresp4; 

// APB4 interface
input         pclk4;     
input         n_preset4; 
output [31:0] paddr4;
output   	    pwrite4;
output   	    penable4;
output [31:0] pwdata4;

// MAC04 APB4 ports4
input [31:0] prdata_mac04;
output	     psel_mac04;
input        pready_mac04;

// MAC14 APB4 ports4
input [31:0] prdata_mac14;
output	     psel_mac14;
input        pready_mac14;

// MAC24 APB4 ports4
input [31:0] prdata_mac24;
output	     psel_mac24;
input        pready_mac24;

// MAC34 APB4 ports4
input [31:0] prdata_mac34;
output	     psel_mac34;
input        pready_mac34;

wire  [31:0] prdata_alut4;

assign tie_hi_bit4 = 1'b1;

ahb2apb4 #(
  32'h00A00000, // Slave4 0 Address Range4
  32'h00A0FFFF,

  32'h00A10000, // Slave4 1 Address Range4
  32'h00A1FFFF,

  32'h00A20000, // Slave4 2 Address Range4 
  32'h00A2FFFF,

  32'h00A30000, // Slave4 3 Address Range4
  32'h00A3FFFF,

  32'h00A40000, // Slave4 4 Address Range4
  32'h00A4FFFF
) i_ahb2apb4 (
     // AHB4 interface
    .hclk4(hclk4),         
    .hreset_n4(n_hreset4), 
    .hsel4(hsel4), 
    .haddr4(haddr4),        
    .htrans4(htrans4),       
    .hwrite4(hwrite4),       
    .hwdata4(hwdata4),       
    .hrdata4(hrdata4),   
    .hready4(hready4),   
    .hresp4(hresp4),     
    
     // APB4 interface
    .pclk4(pclk4),         
    .preset_n4(n_preset4),  
    .prdata04(prdata_alut4),
    .prdata14(prdata_mac04), 
    .prdata24(prdata_mac14),  
    .prdata34(prdata_mac24),   
    .prdata44(prdata_mac34),   
    .prdata54(32'h0),   
    .prdata64(32'h0),    
    .prdata74(32'h0),   
    .prdata84(32'h0),  
    .pready04(tie_hi_bit4),     
    .pready14(pready_mac04),   
    .pready24(pready_mac14),     
    .pready34(pready_mac24),     
    .pready44(pready_mac34),     
    .pready54(tie_hi_bit4),     
    .pready64(tie_hi_bit4),     
    .pready74(tie_hi_bit4),     
    .pready84(tie_hi_bit4),  
    .pwdata4(pwdata4),       
    .pwrite4(pwrite4),       
    .paddr4(paddr4),        
    .psel04(psel_alut4),     
    .psel14(psel_mac04),   
    .psel24(psel_mac14),    
    .psel34(psel_mac24),     
    .psel44(psel_mac34),     
    .psel54(),     
    .psel64(),    
    .psel74(),   
    .psel84(),  
    .penable4(penable4)     
);

alut_veneer4 i_alut_veneer4 (
        //inputs4
        . n_p_reset4(n_preset4),
        . pclk4(pclk4),
        . psel4(psel_alut4),
        . penable4(penable4),
        . pwrite4(pwrite4),
        . paddr4(paddr4[6:0]),
        . pwdata4(pwdata4),

        //outputs4
        . prdata4(prdata_alut4)
);

//------------------------------------------------------------------------------
// APB4 and AHB4 interface formal4 verification4 monitors4
//------------------------------------------------------------------------------
`ifdef ABV_ON4
apb_assert4 i_apb_assert4 (

   // APB4 signals4
  	.n_preset4(n_preset4),
  	.pclk4(pclk4),
	.penable4(penable4),
	.paddr4(paddr4),
	.pwrite4(pwrite4),
	.pwdata4(pwdata4),

  .psel004(psel_alut4),
	.psel014(psel_mac04),
	.psel024(psel_mac14),
	.psel034(psel_mac24),
	.psel044(psel_mac34),
	.psel054(psel054),
	.psel064(psel064),
	.psel074(psel074),
	.psel084(psel084),
	.psel094(psel094),
	.psel104(psel104),
	.psel114(psel114),
	.psel124(psel124),
	.psel134(psel134),
	.psel144(psel144),
	.psel154(psel154),

   .prdata004(prdata_alut4), // Read Data from peripheral4 ALUT4

   // AHB4 signals4
   .hclk4(hclk4),         // ahb4 system clock4
   .n_hreset4(n_hreset4), // ahb4 system reset

   // ahb2apb4 signals4
   .hresp4(hresp4),
   .hready4(hready4),
   .hrdata4(hrdata4),
   .hwdata4(hwdata4),
   .hprot4(hprot4),
   .hburst4(hburst4),
   .hsize4(hsize4),
   .hwrite4(hwrite4),
   .htrans4(htrans4),
   .haddr4(haddr4),
   .ahb2apb_hsel4(ahb2apb1_hsel4));



//------------------------------------------------------------------------------
// AHB4 interface formal4 verification4 monitor4
//------------------------------------------------------------------------------

defparam i_ahbSlaveMonitor4.DBUS_WIDTH4 = 32;
defparam i_ahbMasterMonitor4.DBUS_WIDTH4 = 32;


// AHB2APB4 Bridge4

    ahb_liteslave_monitor4 i_ahbSlaveMonitor4 (
        .hclk_i4(hclk4),
        .hresetn_i4(n_hreset4),
        .hresp4(hresp4),
        .hready4(hready4),
        .hready_global_i4(hready4),
        .hrdata4(hrdata4),
        .hwdata_i4(hwdata4),
        .hburst_i4(hburst4),
        .hsize_i4(hsize4),
        .hwrite_i4(hwrite4),
        .htrans_i4(htrans4),
        .haddr_i4(haddr4),
        .hsel_i4(ahb2apb1_hsel4)
    );


  ahb_litemaster_monitor4 i_ahbMasterMonitor4 (
          .hclk_i4(hclk4),
          .hresetn_i4(n_hreset4),
          .hresp_i4(hresp4),
          .hready_i4(hready4),
          .hrdata_i4(hrdata4),
          .hlock4(1'b0),
          .hwdata4(hwdata4),
          .hprot4(hprot4),
          .hburst4(hburst4),
          .hsize4(hsize4),
          .hwrite4(hwrite4),
          .htrans4(htrans4),
          .haddr4(haddr4)
          );






`endif




endmodule
