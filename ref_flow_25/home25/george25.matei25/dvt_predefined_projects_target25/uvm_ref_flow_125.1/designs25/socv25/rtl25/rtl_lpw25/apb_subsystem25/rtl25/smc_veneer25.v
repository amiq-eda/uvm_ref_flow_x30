//File25 name   : smc_veneer25.v
//Title25       : 
//Created25     : 1999
//Description25 : 
//Notes25       : 
//----------------------------------------------------------------------
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------

 `include "smc_defs_lite25.v"

//static memory controller25
module smc_veneer25 (
                    //apb25 inputs25
                    n_preset25, 
                    pclk25, 
                    psel25, 
                    penable25, 
                    pwrite25, 
                    paddr25, 
                    pwdata25,
                    //ahb25 inputs25                    
                    hclk25,
                    n_sys_reset25,
                    haddr25,
                    htrans25,
                    hsel25,
                    hwrite25,
                    hsize25,
                    hwdata25,
                    hready25,
                    data_smc25,
                    
                    //test signal25 inputs25

                    scan_in_125,
                    scan_in_225,
                    scan_in_325,
                    scan_en25,

                    //apb25 outputs25                    
                    prdata25,

                    //design output
                    
                    smc_hrdata25, 
                    smc_hready25,
                    smc_valid25,
                    smc_hresp25,
                    smc_addr25,
                    smc_data25, 
                    smc_n_be25,
                    smc_n_cs25,
                    smc_n_wr25,                    
                    smc_n_we25,
                    smc_n_rd25,
                    smc_n_ext_oe25,
                    smc_busy25,

                    //test signal25 output

                    scan_out_125,
                    scan_out_225,
                    scan_out_325
                   );
// define parameters25
// change using defaparam25 statements25

  // APB25 Inputs25 (use is optional25 on INCLUDE_APB25)
  input        n_preset25;           // APBreset25 
  input        pclk25;               // APB25 clock25
  input        psel25;               // APB25 select25
  input        penable25;            // APB25 enable 
  input        pwrite25;             // APB25 write strobe25 
  input [4:0]  paddr25;              // APB25 address bus
  input [31:0] pwdata25;             // APB25 write data 

  // APB25 Output25 (use is optional25 on INCLUDE_APB25)

  output [31:0] prdata25;        //APB25 output


//System25 I25/O25

  input                    hclk25;          // AHB25 System25 clock25
  input                    n_sys_reset25;   // AHB25 System25 reset (Active25 LOW25)

//AHB25 I25/O25

  input  [31:0]            haddr25;         // AHB25 Address
  input  [1:0]             htrans25;        // AHB25 transfer25 type
  input                    hsel25;          // chip25 selects25
  input                    hwrite25;        // AHB25 read/write indication25
  input  [2:0]             hsize25;         // AHB25 transfer25 size
  input  [31:0]            hwdata25;        // AHB25 write data
  input                    hready25;        // AHB25 Muxed25 ready signal25

  
  output [31:0]            smc_hrdata25;    // smc25 read data back to AHB25 master25
  output                   smc_hready25;    // smc25 ready signal25
  output [1:0]             smc_hresp25;     // AHB25 Response25 signal25
  output                   smc_valid25;     // Ack25 valid address

//External25 memory interface (EMI25)

  output [31:0]            smc_addr25;      // External25 Memory (EMI25) address
  output [31:0]            smc_data25;      // EMI25 write data
  input  [31:0]            data_smc25;      // EMI25 read data
  output [3:0]             smc_n_be25;      // EMI25 byte enables25 (Active25 LOW25)
  output                   smc_n_cs25;      // EMI25 Chip25 Selects25 (Active25 LOW25)
  output [3:0]             smc_n_we25;      // EMI25 write strobes25 (Active25 LOW25)
  output                   smc_n_wr25;      // EMI25 write enable (Active25 LOW25)
  output                   smc_n_rd25;      // EMI25 read stobe25 (Active25 LOW25)
  output 	           smc_n_ext_oe25;  // EMI25 write data output enable

//AHB25 Memory Interface25 Control25

   output                   smc_busy25;      // smc25 busy



//scan25 signals25

   input                  scan_in_125;        //scan25 input
   input                  scan_in_225;        //scan25 input
   input                  scan_en25;         //scan25 enable
   output                 scan_out_125;       //scan25 output
   output                 scan_out_225;       //scan25 output
// third25 scan25 chain25 only used on INCLUDE_APB25
   input                  scan_in_325;        //scan25 input
   output                 scan_out_325;       //scan25 output

smc_lite25 i_smc_lite25(
   //inputs25
   //apb25 inputs25
   .n_preset25(n_preset25),
   .pclk25(pclk25),
   .psel25(psel25),
   .penable25(penable25),
   .pwrite25(pwrite25),
   .paddr25(paddr25),
   .pwdata25(pwdata25),
   //ahb25 inputs25
   .hclk25(hclk25),
   .n_sys_reset25(n_sys_reset25),
   .haddr25(haddr25),
   .htrans25(htrans25),
   .hsel25(hsel25),
   .hwrite25(hwrite25),
   .hsize25(hsize25),
   .hwdata25(hwdata25),
   .hready25(hready25),
   .data_smc25(data_smc25),


         //test signal25 inputs25

   .scan_in_125(),
   .scan_in_225(),
   .scan_in_325(),
   .scan_en25(scan_en25),

   //apb25 outputs25
   .prdata25(prdata25),

   //design output

   .smc_hrdata25(smc_hrdata25),
   .smc_hready25(smc_hready25),
   .smc_hresp25(smc_hresp25),
   .smc_valid25(smc_valid25),
   .smc_addr25(smc_addr25),
   .smc_data25(smc_data25),
   .smc_n_be25(smc_n_be25),
   .smc_n_cs25(smc_n_cs25),
   .smc_n_wr25(smc_n_wr25),
   .smc_n_we25(smc_n_we25),
   .smc_n_rd25(smc_n_rd25),
   .smc_n_ext_oe25(smc_n_ext_oe25),
   .smc_busy25(smc_busy25),

   //test signal25 output
   .scan_out_125(),
   .scan_out_225(),
   .scan_out_325()
);



//------------------------------------------------------------------------------
// AHB25 formal25 verification25 monitor25
//------------------------------------------------------------------------------
  `ifdef SMC_ABV_ON25

// psl25 assume_hready_in25 : assume always (hready25 == smc_hready25) @(posedge hclk25);

    ahb_liteslave_monitor25 i_ahbSlaveMonitor25 (
        .hclk_i25(hclk25),
        .hresetn_i25(n_preset25),
        .hresp25(smc_hresp25),
        .hready25(smc_hready25),
        .hready_global_i25(smc_hready25),
        .hrdata25(smc_hrdata25),
        .hwdata_i25(hwdata25),
        .hburst_i25(3'b0),
        .hsize_i25(hsize25),
        .hwrite_i25(hwrite25),
        .htrans_i25(htrans25),
        .haddr_i25(haddr25),
        .hsel_i25(|hsel25)
    );


  ahb_litemaster_monitor25 i_ahbMasterMonitor25 (
          .hclk_i25(hclk25),
          .hresetn_i25(n_preset25),
          .hresp_i25(smc_hresp25),
          .hready_i25(smc_hready25),
          .hrdata_i25(smc_hrdata25),
          .hlock25(1'b0),
          .hwdata25(hwdata25),
          .hprot25(4'b0),
          .hburst25(3'b0),
          .hsize25(hsize25),
          .hwrite25(hwrite25),
          .htrans25(htrans25),
          .haddr25(haddr25)
          );



  `endif



endmodule
