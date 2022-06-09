//File29 name   : smc_veneer29.v
//Title29       : 
//Created29     : 1999
//Description29 : 
//Notes29       : 
//----------------------------------------------------------------------
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------

 `include "smc_defs_lite29.v"

//static memory controller29
module smc_veneer29 (
                    //apb29 inputs29
                    n_preset29, 
                    pclk29, 
                    psel29, 
                    penable29, 
                    pwrite29, 
                    paddr29, 
                    pwdata29,
                    //ahb29 inputs29                    
                    hclk29,
                    n_sys_reset29,
                    haddr29,
                    htrans29,
                    hsel29,
                    hwrite29,
                    hsize29,
                    hwdata29,
                    hready29,
                    data_smc29,
                    
                    //test signal29 inputs29

                    scan_in_129,
                    scan_in_229,
                    scan_in_329,
                    scan_en29,

                    //apb29 outputs29                    
                    prdata29,

                    //design output
                    
                    smc_hrdata29, 
                    smc_hready29,
                    smc_valid29,
                    smc_hresp29,
                    smc_addr29,
                    smc_data29, 
                    smc_n_be29,
                    smc_n_cs29,
                    smc_n_wr29,                    
                    smc_n_we29,
                    smc_n_rd29,
                    smc_n_ext_oe29,
                    smc_busy29,

                    //test signal29 output

                    scan_out_129,
                    scan_out_229,
                    scan_out_329
                   );
// define parameters29
// change using defaparam29 statements29

  // APB29 Inputs29 (use is optional29 on INCLUDE_APB29)
  input        n_preset29;           // APBreset29 
  input        pclk29;               // APB29 clock29
  input        psel29;               // APB29 select29
  input        penable29;            // APB29 enable 
  input        pwrite29;             // APB29 write strobe29 
  input [4:0]  paddr29;              // APB29 address bus
  input [31:0] pwdata29;             // APB29 write data 

  // APB29 Output29 (use is optional29 on INCLUDE_APB29)

  output [31:0] prdata29;        //APB29 output


//System29 I29/O29

  input                    hclk29;          // AHB29 System29 clock29
  input                    n_sys_reset29;   // AHB29 System29 reset (Active29 LOW29)

//AHB29 I29/O29

  input  [31:0]            haddr29;         // AHB29 Address
  input  [1:0]             htrans29;        // AHB29 transfer29 type
  input                    hsel29;          // chip29 selects29
  input                    hwrite29;        // AHB29 read/write indication29
  input  [2:0]             hsize29;         // AHB29 transfer29 size
  input  [31:0]            hwdata29;        // AHB29 write data
  input                    hready29;        // AHB29 Muxed29 ready signal29

  
  output [31:0]            smc_hrdata29;    // smc29 read data back to AHB29 master29
  output                   smc_hready29;    // smc29 ready signal29
  output [1:0]             smc_hresp29;     // AHB29 Response29 signal29
  output                   smc_valid29;     // Ack29 valid address

//External29 memory interface (EMI29)

  output [31:0]            smc_addr29;      // External29 Memory (EMI29) address
  output [31:0]            smc_data29;      // EMI29 write data
  input  [31:0]            data_smc29;      // EMI29 read data
  output [3:0]             smc_n_be29;      // EMI29 byte enables29 (Active29 LOW29)
  output                   smc_n_cs29;      // EMI29 Chip29 Selects29 (Active29 LOW29)
  output [3:0]             smc_n_we29;      // EMI29 write strobes29 (Active29 LOW29)
  output                   smc_n_wr29;      // EMI29 write enable (Active29 LOW29)
  output                   smc_n_rd29;      // EMI29 read stobe29 (Active29 LOW29)
  output 	           smc_n_ext_oe29;  // EMI29 write data output enable

//AHB29 Memory Interface29 Control29

   output                   smc_busy29;      // smc29 busy



//scan29 signals29

   input                  scan_in_129;        //scan29 input
   input                  scan_in_229;        //scan29 input
   input                  scan_en29;         //scan29 enable
   output                 scan_out_129;       //scan29 output
   output                 scan_out_229;       //scan29 output
// third29 scan29 chain29 only used on INCLUDE_APB29
   input                  scan_in_329;        //scan29 input
   output                 scan_out_329;       //scan29 output

smc_lite29 i_smc_lite29(
   //inputs29
   //apb29 inputs29
   .n_preset29(n_preset29),
   .pclk29(pclk29),
   .psel29(psel29),
   .penable29(penable29),
   .pwrite29(pwrite29),
   .paddr29(paddr29),
   .pwdata29(pwdata29),
   //ahb29 inputs29
   .hclk29(hclk29),
   .n_sys_reset29(n_sys_reset29),
   .haddr29(haddr29),
   .htrans29(htrans29),
   .hsel29(hsel29),
   .hwrite29(hwrite29),
   .hsize29(hsize29),
   .hwdata29(hwdata29),
   .hready29(hready29),
   .data_smc29(data_smc29),


         //test signal29 inputs29

   .scan_in_129(),
   .scan_in_229(),
   .scan_in_329(),
   .scan_en29(scan_en29),

   //apb29 outputs29
   .prdata29(prdata29),

   //design output

   .smc_hrdata29(smc_hrdata29),
   .smc_hready29(smc_hready29),
   .smc_hresp29(smc_hresp29),
   .smc_valid29(smc_valid29),
   .smc_addr29(smc_addr29),
   .smc_data29(smc_data29),
   .smc_n_be29(smc_n_be29),
   .smc_n_cs29(smc_n_cs29),
   .smc_n_wr29(smc_n_wr29),
   .smc_n_we29(smc_n_we29),
   .smc_n_rd29(smc_n_rd29),
   .smc_n_ext_oe29(smc_n_ext_oe29),
   .smc_busy29(smc_busy29),

   //test signal29 output
   .scan_out_129(),
   .scan_out_229(),
   .scan_out_329()
);



//------------------------------------------------------------------------------
// AHB29 formal29 verification29 monitor29
//------------------------------------------------------------------------------
  `ifdef SMC_ABV_ON29

// psl29 assume_hready_in29 : assume always (hready29 == smc_hready29) @(posedge hclk29);

    ahb_liteslave_monitor29 i_ahbSlaveMonitor29 (
        .hclk_i29(hclk29),
        .hresetn_i29(n_preset29),
        .hresp29(smc_hresp29),
        .hready29(smc_hready29),
        .hready_global_i29(smc_hready29),
        .hrdata29(smc_hrdata29),
        .hwdata_i29(hwdata29),
        .hburst_i29(3'b0),
        .hsize_i29(hsize29),
        .hwrite_i29(hwrite29),
        .htrans_i29(htrans29),
        .haddr_i29(haddr29),
        .hsel_i29(|hsel29)
    );


  ahb_litemaster_monitor29 i_ahbMasterMonitor29 (
          .hclk_i29(hclk29),
          .hresetn_i29(n_preset29),
          .hresp_i29(smc_hresp29),
          .hready_i29(smc_hready29),
          .hrdata_i29(smc_hrdata29),
          .hlock29(1'b0),
          .hwdata29(hwdata29),
          .hprot29(4'b0),
          .hburst29(3'b0),
          .hsize29(hsize29),
          .hwrite29(hwrite29),
          .htrans29(htrans29),
          .haddr29(haddr29)
          );



  `endif



endmodule
