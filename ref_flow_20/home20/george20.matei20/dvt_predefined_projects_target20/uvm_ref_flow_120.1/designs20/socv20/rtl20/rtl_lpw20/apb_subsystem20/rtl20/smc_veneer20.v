//File20 name   : smc_veneer20.v
//Title20       : 
//Created20     : 1999
//Description20 : 
//Notes20       : 
//----------------------------------------------------------------------
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------

 `include "smc_defs_lite20.v"

//static memory controller20
module smc_veneer20 (
                    //apb20 inputs20
                    n_preset20, 
                    pclk20, 
                    psel20, 
                    penable20, 
                    pwrite20, 
                    paddr20, 
                    pwdata20,
                    //ahb20 inputs20                    
                    hclk20,
                    n_sys_reset20,
                    haddr20,
                    htrans20,
                    hsel20,
                    hwrite20,
                    hsize20,
                    hwdata20,
                    hready20,
                    data_smc20,
                    
                    //test signal20 inputs20

                    scan_in_120,
                    scan_in_220,
                    scan_in_320,
                    scan_en20,

                    //apb20 outputs20                    
                    prdata20,

                    //design output
                    
                    smc_hrdata20, 
                    smc_hready20,
                    smc_valid20,
                    smc_hresp20,
                    smc_addr20,
                    smc_data20, 
                    smc_n_be20,
                    smc_n_cs20,
                    smc_n_wr20,                    
                    smc_n_we20,
                    smc_n_rd20,
                    smc_n_ext_oe20,
                    smc_busy20,

                    //test signal20 output

                    scan_out_120,
                    scan_out_220,
                    scan_out_320
                   );
// define parameters20
// change using defaparam20 statements20

  // APB20 Inputs20 (use is optional20 on INCLUDE_APB20)
  input        n_preset20;           // APBreset20 
  input        pclk20;               // APB20 clock20
  input        psel20;               // APB20 select20
  input        penable20;            // APB20 enable 
  input        pwrite20;             // APB20 write strobe20 
  input [4:0]  paddr20;              // APB20 address bus
  input [31:0] pwdata20;             // APB20 write data 

  // APB20 Output20 (use is optional20 on INCLUDE_APB20)

  output [31:0] prdata20;        //APB20 output


//System20 I20/O20

  input                    hclk20;          // AHB20 System20 clock20
  input                    n_sys_reset20;   // AHB20 System20 reset (Active20 LOW20)

//AHB20 I20/O20

  input  [31:0]            haddr20;         // AHB20 Address
  input  [1:0]             htrans20;        // AHB20 transfer20 type
  input                    hsel20;          // chip20 selects20
  input                    hwrite20;        // AHB20 read/write indication20
  input  [2:0]             hsize20;         // AHB20 transfer20 size
  input  [31:0]            hwdata20;        // AHB20 write data
  input                    hready20;        // AHB20 Muxed20 ready signal20

  
  output [31:0]            smc_hrdata20;    // smc20 read data back to AHB20 master20
  output                   smc_hready20;    // smc20 ready signal20
  output [1:0]             smc_hresp20;     // AHB20 Response20 signal20
  output                   smc_valid20;     // Ack20 valid address

//External20 memory interface (EMI20)

  output [31:0]            smc_addr20;      // External20 Memory (EMI20) address
  output [31:0]            smc_data20;      // EMI20 write data
  input  [31:0]            data_smc20;      // EMI20 read data
  output [3:0]             smc_n_be20;      // EMI20 byte enables20 (Active20 LOW20)
  output                   smc_n_cs20;      // EMI20 Chip20 Selects20 (Active20 LOW20)
  output [3:0]             smc_n_we20;      // EMI20 write strobes20 (Active20 LOW20)
  output                   smc_n_wr20;      // EMI20 write enable (Active20 LOW20)
  output                   smc_n_rd20;      // EMI20 read stobe20 (Active20 LOW20)
  output 	           smc_n_ext_oe20;  // EMI20 write data output enable

//AHB20 Memory Interface20 Control20

   output                   smc_busy20;      // smc20 busy



//scan20 signals20

   input                  scan_in_120;        //scan20 input
   input                  scan_in_220;        //scan20 input
   input                  scan_en20;         //scan20 enable
   output                 scan_out_120;       //scan20 output
   output                 scan_out_220;       //scan20 output
// third20 scan20 chain20 only used on INCLUDE_APB20
   input                  scan_in_320;        //scan20 input
   output                 scan_out_320;       //scan20 output

smc_lite20 i_smc_lite20(
   //inputs20
   //apb20 inputs20
   .n_preset20(n_preset20),
   .pclk20(pclk20),
   .psel20(psel20),
   .penable20(penable20),
   .pwrite20(pwrite20),
   .paddr20(paddr20),
   .pwdata20(pwdata20),
   //ahb20 inputs20
   .hclk20(hclk20),
   .n_sys_reset20(n_sys_reset20),
   .haddr20(haddr20),
   .htrans20(htrans20),
   .hsel20(hsel20),
   .hwrite20(hwrite20),
   .hsize20(hsize20),
   .hwdata20(hwdata20),
   .hready20(hready20),
   .data_smc20(data_smc20),


         //test signal20 inputs20

   .scan_in_120(),
   .scan_in_220(),
   .scan_in_320(),
   .scan_en20(scan_en20),

   //apb20 outputs20
   .prdata20(prdata20),

   //design output

   .smc_hrdata20(smc_hrdata20),
   .smc_hready20(smc_hready20),
   .smc_hresp20(smc_hresp20),
   .smc_valid20(smc_valid20),
   .smc_addr20(smc_addr20),
   .smc_data20(smc_data20),
   .smc_n_be20(smc_n_be20),
   .smc_n_cs20(smc_n_cs20),
   .smc_n_wr20(smc_n_wr20),
   .smc_n_we20(smc_n_we20),
   .smc_n_rd20(smc_n_rd20),
   .smc_n_ext_oe20(smc_n_ext_oe20),
   .smc_busy20(smc_busy20),

   //test signal20 output
   .scan_out_120(),
   .scan_out_220(),
   .scan_out_320()
);



//------------------------------------------------------------------------------
// AHB20 formal20 verification20 monitor20
//------------------------------------------------------------------------------
  `ifdef SMC_ABV_ON20

// psl20 assume_hready_in20 : assume always (hready20 == smc_hready20) @(posedge hclk20);

    ahb_liteslave_monitor20 i_ahbSlaveMonitor20 (
        .hclk_i20(hclk20),
        .hresetn_i20(n_preset20),
        .hresp20(smc_hresp20),
        .hready20(smc_hready20),
        .hready_global_i20(smc_hready20),
        .hrdata20(smc_hrdata20),
        .hwdata_i20(hwdata20),
        .hburst_i20(3'b0),
        .hsize_i20(hsize20),
        .hwrite_i20(hwrite20),
        .htrans_i20(htrans20),
        .haddr_i20(haddr20),
        .hsel_i20(|hsel20)
    );


  ahb_litemaster_monitor20 i_ahbMasterMonitor20 (
          .hclk_i20(hclk20),
          .hresetn_i20(n_preset20),
          .hresp_i20(smc_hresp20),
          .hready_i20(smc_hready20),
          .hrdata_i20(smc_hrdata20),
          .hlock20(1'b0),
          .hwdata20(hwdata20),
          .hprot20(4'b0),
          .hburst20(3'b0),
          .hsize20(hsize20),
          .hwrite20(hwrite20),
          .htrans20(htrans20),
          .haddr20(haddr20)
          );



  `endif



endmodule
