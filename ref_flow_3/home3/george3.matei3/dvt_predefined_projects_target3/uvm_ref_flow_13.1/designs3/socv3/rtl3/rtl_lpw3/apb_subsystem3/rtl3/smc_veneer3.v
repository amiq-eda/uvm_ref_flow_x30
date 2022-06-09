//File3 name   : smc_veneer3.v
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

 `include "smc_defs_lite3.v"

//static memory controller3
module smc_veneer3 (
                    //apb3 inputs3
                    n_preset3, 
                    pclk3, 
                    psel3, 
                    penable3, 
                    pwrite3, 
                    paddr3, 
                    pwdata3,
                    //ahb3 inputs3                    
                    hclk3,
                    n_sys_reset3,
                    haddr3,
                    htrans3,
                    hsel3,
                    hwrite3,
                    hsize3,
                    hwdata3,
                    hready3,
                    data_smc3,
                    
                    //test signal3 inputs3

                    scan_in_13,
                    scan_in_23,
                    scan_in_33,
                    scan_en3,

                    //apb3 outputs3                    
                    prdata3,

                    //design output
                    
                    smc_hrdata3, 
                    smc_hready3,
                    smc_valid3,
                    smc_hresp3,
                    smc_addr3,
                    smc_data3, 
                    smc_n_be3,
                    smc_n_cs3,
                    smc_n_wr3,                    
                    smc_n_we3,
                    smc_n_rd3,
                    smc_n_ext_oe3,
                    smc_busy3,

                    //test signal3 output

                    scan_out_13,
                    scan_out_23,
                    scan_out_33
                   );
// define parameters3
// change using defaparam3 statements3

  // APB3 Inputs3 (use is optional3 on INCLUDE_APB3)
  input        n_preset3;           // APBreset3 
  input        pclk3;               // APB3 clock3
  input        psel3;               // APB3 select3
  input        penable3;            // APB3 enable 
  input        pwrite3;             // APB3 write strobe3 
  input [4:0]  paddr3;              // APB3 address bus
  input [31:0] pwdata3;             // APB3 write data 

  // APB3 Output3 (use is optional3 on INCLUDE_APB3)

  output [31:0] prdata3;        //APB3 output


//System3 I3/O3

  input                    hclk3;          // AHB3 System3 clock3
  input                    n_sys_reset3;   // AHB3 System3 reset (Active3 LOW3)

//AHB3 I3/O3

  input  [31:0]            haddr3;         // AHB3 Address
  input  [1:0]             htrans3;        // AHB3 transfer3 type
  input                    hsel3;          // chip3 selects3
  input                    hwrite3;        // AHB3 read/write indication3
  input  [2:0]             hsize3;         // AHB3 transfer3 size
  input  [31:0]            hwdata3;        // AHB3 write data
  input                    hready3;        // AHB3 Muxed3 ready signal3

  
  output [31:0]            smc_hrdata3;    // smc3 read data back to AHB3 master3
  output                   smc_hready3;    // smc3 ready signal3
  output [1:0]             smc_hresp3;     // AHB3 Response3 signal3
  output                   smc_valid3;     // Ack3 valid address

//External3 memory interface (EMI3)

  output [31:0]            smc_addr3;      // External3 Memory (EMI3) address
  output [31:0]            smc_data3;      // EMI3 write data
  input  [31:0]            data_smc3;      // EMI3 read data
  output [3:0]             smc_n_be3;      // EMI3 byte enables3 (Active3 LOW3)
  output                   smc_n_cs3;      // EMI3 Chip3 Selects3 (Active3 LOW3)
  output [3:0]             smc_n_we3;      // EMI3 write strobes3 (Active3 LOW3)
  output                   smc_n_wr3;      // EMI3 write enable (Active3 LOW3)
  output                   smc_n_rd3;      // EMI3 read stobe3 (Active3 LOW3)
  output 	           smc_n_ext_oe3;  // EMI3 write data output enable

//AHB3 Memory Interface3 Control3

   output                   smc_busy3;      // smc3 busy



//scan3 signals3

   input                  scan_in_13;        //scan3 input
   input                  scan_in_23;        //scan3 input
   input                  scan_en3;         //scan3 enable
   output                 scan_out_13;       //scan3 output
   output                 scan_out_23;       //scan3 output
// third3 scan3 chain3 only used on INCLUDE_APB3
   input                  scan_in_33;        //scan3 input
   output                 scan_out_33;       //scan3 output

smc_lite3 i_smc_lite3(
   //inputs3
   //apb3 inputs3
   .n_preset3(n_preset3),
   .pclk3(pclk3),
   .psel3(psel3),
   .penable3(penable3),
   .pwrite3(pwrite3),
   .paddr3(paddr3),
   .pwdata3(pwdata3),
   //ahb3 inputs3
   .hclk3(hclk3),
   .n_sys_reset3(n_sys_reset3),
   .haddr3(haddr3),
   .htrans3(htrans3),
   .hsel3(hsel3),
   .hwrite3(hwrite3),
   .hsize3(hsize3),
   .hwdata3(hwdata3),
   .hready3(hready3),
   .data_smc3(data_smc3),


         //test signal3 inputs3

   .scan_in_13(),
   .scan_in_23(),
   .scan_in_33(),
   .scan_en3(scan_en3),

   //apb3 outputs3
   .prdata3(prdata3),

   //design output

   .smc_hrdata3(smc_hrdata3),
   .smc_hready3(smc_hready3),
   .smc_hresp3(smc_hresp3),
   .smc_valid3(smc_valid3),
   .smc_addr3(smc_addr3),
   .smc_data3(smc_data3),
   .smc_n_be3(smc_n_be3),
   .smc_n_cs3(smc_n_cs3),
   .smc_n_wr3(smc_n_wr3),
   .smc_n_we3(smc_n_we3),
   .smc_n_rd3(smc_n_rd3),
   .smc_n_ext_oe3(smc_n_ext_oe3),
   .smc_busy3(smc_busy3),

   //test signal3 output
   .scan_out_13(),
   .scan_out_23(),
   .scan_out_33()
);



//------------------------------------------------------------------------------
// AHB3 formal3 verification3 monitor3
//------------------------------------------------------------------------------
  `ifdef SMC_ABV_ON3

// psl3 assume_hready_in3 : assume always (hready3 == smc_hready3) @(posedge hclk3);

    ahb_liteslave_monitor3 i_ahbSlaveMonitor3 (
        .hclk_i3(hclk3),
        .hresetn_i3(n_preset3),
        .hresp3(smc_hresp3),
        .hready3(smc_hready3),
        .hready_global_i3(smc_hready3),
        .hrdata3(smc_hrdata3),
        .hwdata_i3(hwdata3),
        .hburst_i3(3'b0),
        .hsize_i3(hsize3),
        .hwrite_i3(hwrite3),
        .htrans_i3(htrans3),
        .haddr_i3(haddr3),
        .hsel_i3(|hsel3)
    );


  ahb_litemaster_monitor3 i_ahbMasterMonitor3 (
          .hclk_i3(hclk3),
          .hresetn_i3(n_preset3),
          .hresp_i3(smc_hresp3),
          .hready_i3(smc_hready3),
          .hrdata_i3(smc_hrdata3),
          .hlock3(1'b0),
          .hwdata3(hwdata3),
          .hprot3(4'b0),
          .hburst3(3'b0),
          .hsize3(hsize3),
          .hwrite3(hwrite3),
          .htrans3(htrans3),
          .haddr3(haddr3)
          );



  `endif



endmodule
