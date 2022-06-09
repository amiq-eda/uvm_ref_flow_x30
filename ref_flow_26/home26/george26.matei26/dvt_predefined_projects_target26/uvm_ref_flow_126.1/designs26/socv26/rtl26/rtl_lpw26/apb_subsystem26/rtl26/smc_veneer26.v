//File26 name   : smc_veneer26.v
//Title26       : 
//Created26     : 1999
//Description26 : 
//Notes26       : 
//----------------------------------------------------------------------
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------

 `include "smc_defs_lite26.v"

//static memory controller26
module smc_veneer26 (
                    //apb26 inputs26
                    n_preset26, 
                    pclk26, 
                    psel26, 
                    penable26, 
                    pwrite26, 
                    paddr26, 
                    pwdata26,
                    //ahb26 inputs26                    
                    hclk26,
                    n_sys_reset26,
                    haddr26,
                    htrans26,
                    hsel26,
                    hwrite26,
                    hsize26,
                    hwdata26,
                    hready26,
                    data_smc26,
                    
                    //test signal26 inputs26

                    scan_in_126,
                    scan_in_226,
                    scan_in_326,
                    scan_en26,

                    //apb26 outputs26                    
                    prdata26,

                    //design output
                    
                    smc_hrdata26, 
                    smc_hready26,
                    smc_valid26,
                    smc_hresp26,
                    smc_addr26,
                    smc_data26, 
                    smc_n_be26,
                    smc_n_cs26,
                    smc_n_wr26,                    
                    smc_n_we26,
                    smc_n_rd26,
                    smc_n_ext_oe26,
                    smc_busy26,

                    //test signal26 output

                    scan_out_126,
                    scan_out_226,
                    scan_out_326
                   );
// define parameters26
// change using defaparam26 statements26

  // APB26 Inputs26 (use is optional26 on INCLUDE_APB26)
  input        n_preset26;           // APBreset26 
  input        pclk26;               // APB26 clock26
  input        psel26;               // APB26 select26
  input        penable26;            // APB26 enable 
  input        pwrite26;             // APB26 write strobe26 
  input [4:0]  paddr26;              // APB26 address bus
  input [31:0] pwdata26;             // APB26 write data 

  // APB26 Output26 (use is optional26 on INCLUDE_APB26)

  output [31:0] prdata26;        //APB26 output


//System26 I26/O26

  input                    hclk26;          // AHB26 System26 clock26
  input                    n_sys_reset26;   // AHB26 System26 reset (Active26 LOW26)

//AHB26 I26/O26

  input  [31:0]            haddr26;         // AHB26 Address
  input  [1:0]             htrans26;        // AHB26 transfer26 type
  input                    hsel26;          // chip26 selects26
  input                    hwrite26;        // AHB26 read/write indication26
  input  [2:0]             hsize26;         // AHB26 transfer26 size
  input  [31:0]            hwdata26;        // AHB26 write data
  input                    hready26;        // AHB26 Muxed26 ready signal26

  
  output [31:0]            smc_hrdata26;    // smc26 read data back to AHB26 master26
  output                   smc_hready26;    // smc26 ready signal26
  output [1:0]             smc_hresp26;     // AHB26 Response26 signal26
  output                   smc_valid26;     // Ack26 valid address

//External26 memory interface (EMI26)

  output [31:0]            smc_addr26;      // External26 Memory (EMI26) address
  output [31:0]            smc_data26;      // EMI26 write data
  input  [31:0]            data_smc26;      // EMI26 read data
  output [3:0]             smc_n_be26;      // EMI26 byte enables26 (Active26 LOW26)
  output                   smc_n_cs26;      // EMI26 Chip26 Selects26 (Active26 LOW26)
  output [3:0]             smc_n_we26;      // EMI26 write strobes26 (Active26 LOW26)
  output                   smc_n_wr26;      // EMI26 write enable (Active26 LOW26)
  output                   smc_n_rd26;      // EMI26 read stobe26 (Active26 LOW26)
  output 	           smc_n_ext_oe26;  // EMI26 write data output enable

//AHB26 Memory Interface26 Control26

   output                   smc_busy26;      // smc26 busy



//scan26 signals26

   input                  scan_in_126;        //scan26 input
   input                  scan_in_226;        //scan26 input
   input                  scan_en26;         //scan26 enable
   output                 scan_out_126;       //scan26 output
   output                 scan_out_226;       //scan26 output
// third26 scan26 chain26 only used on INCLUDE_APB26
   input                  scan_in_326;        //scan26 input
   output                 scan_out_326;       //scan26 output

smc_lite26 i_smc_lite26(
   //inputs26
   //apb26 inputs26
   .n_preset26(n_preset26),
   .pclk26(pclk26),
   .psel26(psel26),
   .penable26(penable26),
   .pwrite26(pwrite26),
   .paddr26(paddr26),
   .pwdata26(pwdata26),
   //ahb26 inputs26
   .hclk26(hclk26),
   .n_sys_reset26(n_sys_reset26),
   .haddr26(haddr26),
   .htrans26(htrans26),
   .hsel26(hsel26),
   .hwrite26(hwrite26),
   .hsize26(hsize26),
   .hwdata26(hwdata26),
   .hready26(hready26),
   .data_smc26(data_smc26),


         //test signal26 inputs26

   .scan_in_126(),
   .scan_in_226(),
   .scan_in_326(),
   .scan_en26(scan_en26),

   //apb26 outputs26
   .prdata26(prdata26),

   //design output

   .smc_hrdata26(smc_hrdata26),
   .smc_hready26(smc_hready26),
   .smc_hresp26(smc_hresp26),
   .smc_valid26(smc_valid26),
   .smc_addr26(smc_addr26),
   .smc_data26(smc_data26),
   .smc_n_be26(smc_n_be26),
   .smc_n_cs26(smc_n_cs26),
   .smc_n_wr26(smc_n_wr26),
   .smc_n_we26(smc_n_we26),
   .smc_n_rd26(smc_n_rd26),
   .smc_n_ext_oe26(smc_n_ext_oe26),
   .smc_busy26(smc_busy26),

   //test signal26 output
   .scan_out_126(),
   .scan_out_226(),
   .scan_out_326()
);



//------------------------------------------------------------------------------
// AHB26 formal26 verification26 monitor26
//------------------------------------------------------------------------------
  `ifdef SMC_ABV_ON26

// psl26 assume_hready_in26 : assume always (hready26 == smc_hready26) @(posedge hclk26);

    ahb_liteslave_monitor26 i_ahbSlaveMonitor26 (
        .hclk_i26(hclk26),
        .hresetn_i26(n_preset26),
        .hresp26(smc_hresp26),
        .hready26(smc_hready26),
        .hready_global_i26(smc_hready26),
        .hrdata26(smc_hrdata26),
        .hwdata_i26(hwdata26),
        .hburst_i26(3'b0),
        .hsize_i26(hsize26),
        .hwrite_i26(hwrite26),
        .htrans_i26(htrans26),
        .haddr_i26(haddr26),
        .hsel_i26(|hsel26)
    );


  ahb_litemaster_monitor26 i_ahbMasterMonitor26 (
          .hclk_i26(hclk26),
          .hresetn_i26(n_preset26),
          .hresp_i26(smc_hresp26),
          .hready_i26(smc_hready26),
          .hrdata_i26(smc_hrdata26),
          .hlock26(1'b0),
          .hwdata26(hwdata26),
          .hprot26(4'b0),
          .hburst26(3'b0),
          .hsize26(hsize26),
          .hwrite26(hwrite26),
          .htrans26(htrans26),
          .haddr26(haddr26)
          );



  `endif



endmodule
