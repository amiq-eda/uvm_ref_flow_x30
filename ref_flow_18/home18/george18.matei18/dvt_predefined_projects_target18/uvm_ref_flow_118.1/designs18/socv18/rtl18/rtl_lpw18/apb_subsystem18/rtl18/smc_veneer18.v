//File18 name   : smc_veneer18.v
//Title18       : 
//Created18     : 1999
//Description18 : 
//Notes18       : 
//----------------------------------------------------------------------
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------

 `include "smc_defs_lite18.v"

//static memory controller18
module smc_veneer18 (
                    //apb18 inputs18
                    n_preset18, 
                    pclk18, 
                    psel18, 
                    penable18, 
                    pwrite18, 
                    paddr18, 
                    pwdata18,
                    //ahb18 inputs18                    
                    hclk18,
                    n_sys_reset18,
                    haddr18,
                    htrans18,
                    hsel18,
                    hwrite18,
                    hsize18,
                    hwdata18,
                    hready18,
                    data_smc18,
                    
                    //test signal18 inputs18

                    scan_in_118,
                    scan_in_218,
                    scan_in_318,
                    scan_en18,

                    //apb18 outputs18                    
                    prdata18,

                    //design output
                    
                    smc_hrdata18, 
                    smc_hready18,
                    smc_valid18,
                    smc_hresp18,
                    smc_addr18,
                    smc_data18, 
                    smc_n_be18,
                    smc_n_cs18,
                    smc_n_wr18,                    
                    smc_n_we18,
                    smc_n_rd18,
                    smc_n_ext_oe18,
                    smc_busy18,

                    //test signal18 output

                    scan_out_118,
                    scan_out_218,
                    scan_out_318
                   );
// define parameters18
// change using defaparam18 statements18

  // APB18 Inputs18 (use is optional18 on INCLUDE_APB18)
  input        n_preset18;           // APBreset18 
  input        pclk18;               // APB18 clock18
  input        psel18;               // APB18 select18
  input        penable18;            // APB18 enable 
  input        pwrite18;             // APB18 write strobe18 
  input [4:0]  paddr18;              // APB18 address bus
  input [31:0] pwdata18;             // APB18 write data 

  // APB18 Output18 (use is optional18 on INCLUDE_APB18)

  output [31:0] prdata18;        //APB18 output


//System18 I18/O18

  input                    hclk18;          // AHB18 System18 clock18
  input                    n_sys_reset18;   // AHB18 System18 reset (Active18 LOW18)

//AHB18 I18/O18

  input  [31:0]            haddr18;         // AHB18 Address
  input  [1:0]             htrans18;        // AHB18 transfer18 type
  input                    hsel18;          // chip18 selects18
  input                    hwrite18;        // AHB18 read/write indication18
  input  [2:0]             hsize18;         // AHB18 transfer18 size
  input  [31:0]            hwdata18;        // AHB18 write data
  input                    hready18;        // AHB18 Muxed18 ready signal18

  
  output [31:0]            smc_hrdata18;    // smc18 read data back to AHB18 master18
  output                   smc_hready18;    // smc18 ready signal18
  output [1:0]             smc_hresp18;     // AHB18 Response18 signal18
  output                   smc_valid18;     // Ack18 valid address

//External18 memory interface (EMI18)

  output [31:0]            smc_addr18;      // External18 Memory (EMI18) address
  output [31:0]            smc_data18;      // EMI18 write data
  input  [31:0]            data_smc18;      // EMI18 read data
  output [3:0]             smc_n_be18;      // EMI18 byte enables18 (Active18 LOW18)
  output                   smc_n_cs18;      // EMI18 Chip18 Selects18 (Active18 LOW18)
  output [3:0]             smc_n_we18;      // EMI18 write strobes18 (Active18 LOW18)
  output                   smc_n_wr18;      // EMI18 write enable (Active18 LOW18)
  output                   smc_n_rd18;      // EMI18 read stobe18 (Active18 LOW18)
  output 	           smc_n_ext_oe18;  // EMI18 write data output enable

//AHB18 Memory Interface18 Control18

   output                   smc_busy18;      // smc18 busy



//scan18 signals18

   input                  scan_in_118;        //scan18 input
   input                  scan_in_218;        //scan18 input
   input                  scan_en18;         //scan18 enable
   output                 scan_out_118;       //scan18 output
   output                 scan_out_218;       //scan18 output
// third18 scan18 chain18 only used on INCLUDE_APB18
   input                  scan_in_318;        //scan18 input
   output                 scan_out_318;       //scan18 output

smc_lite18 i_smc_lite18(
   //inputs18
   //apb18 inputs18
   .n_preset18(n_preset18),
   .pclk18(pclk18),
   .psel18(psel18),
   .penable18(penable18),
   .pwrite18(pwrite18),
   .paddr18(paddr18),
   .pwdata18(pwdata18),
   //ahb18 inputs18
   .hclk18(hclk18),
   .n_sys_reset18(n_sys_reset18),
   .haddr18(haddr18),
   .htrans18(htrans18),
   .hsel18(hsel18),
   .hwrite18(hwrite18),
   .hsize18(hsize18),
   .hwdata18(hwdata18),
   .hready18(hready18),
   .data_smc18(data_smc18),


         //test signal18 inputs18

   .scan_in_118(),
   .scan_in_218(),
   .scan_in_318(),
   .scan_en18(scan_en18),

   //apb18 outputs18
   .prdata18(prdata18),

   //design output

   .smc_hrdata18(smc_hrdata18),
   .smc_hready18(smc_hready18),
   .smc_hresp18(smc_hresp18),
   .smc_valid18(smc_valid18),
   .smc_addr18(smc_addr18),
   .smc_data18(smc_data18),
   .smc_n_be18(smc_n_be18),
   .smc_n_cs18(smc_n_cs18),
   .smc_n_wr18(smc_n_wr18),
   .smc_n_we18(smc_n_we18),
   .smc_n_rd18(smc_n_rd18),
   .smc_n_ext_oe18(smc_n_ext_oe18),
   .smc_busy18(smc_busy18),

   //test signal18 output
   .scan_out_118(),
   .scan_out_218(),
   .scan_out_318()
);



//------------------------------------------------------------------------------
// AHB18 formal18 verification18 monitor18
//------------------------------------------------------------------------------
  `ifdef SMC_ABV_ON18

// psl18 assume_hready_in18 : assume always (hready18 == smc_hready18) @(posedge hclk18);

    ahb_liteslave_monitor18 i_ahbSlaveMonitor18 (
        .hclk_i18(hclk18),
        .hresetn_i18(n_preset18),
        .hresp18(smc_hresp18),
        .hready18(smc_hready18),
        .hready_global_i18(smc_hready18),
        .hrdata18(smc_hrdata18),
        .hwdata_i18(hwdata18),
        .hburst_i18(3'b0),
        .hsize_i18(hsize18),
        .hwrite_i18(hwrite18),
        .htrans_i18(htrans18),
        .haddr_i18(haddr18),
        .hsel_i18(|hsel18)
    );


  ahb_litemaster_monitor18 i_ahbMasterMonitor18 (
          .hclk_i18(hclk18),
          .hresetn_i18(n_preset18),
          .hresp_i18(smc_hresp18),
          .hready_i18(smc_hready18),
          .hrdata_i18(smc_hrdata18),
          .hlock18(1'b0),
          .hwdata18(hwdata18),
          .hprot18(4'b0),
          .hburst18(3'b0),
          .hsize18(hsize18),
          .hwrite18(hwrite18),
          .htrans18(htrans18),
          .haddr18(haddr18)
          );



  `endif



endmodule
