//File12 name   : smc_veneer12.v
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

 `include "smc_defs_lite12.v"

//static memory controller12
module smc_veneer12 (
                    //apb12 inputs12
                    n_preset12, 
                    pclk12, 
                    psel12, 
                    penable12, 
                    pwrite12, 
                    paddr12, 
                    pwdata12,
                    //ahb12 inputs12                    
                    hclk12,
                    n_sys_reset12,
                    haddr12,
                    htrans12,
                    hsel12,
                    hwrite12,
                    hsize12,
                    hwdata12,
                    hready12,
                    data_smc12,
                    
                    //test signal12 inputs12

                    scan_in_112,
                    scan_in_212,
                    scan_in_312,
                    scan_en12,

                    //apb12 outputs12                    
                    prdata12,

                    //design output
                    
                    smc_hrdata12, 
                    smc_hready12,
                    smc_valid12,
                    smc_hresp12,
                    smc_addr12,
                    smc_data12, 
                    smc_n_be12,
                    smc_n_cs12,
                    smc_n_wr12,                    
                    smc_n_we12,
                    smc_n_rd12,
                    smc_n_ext_oe12,
                    smc_busy12,

                    //test signal12 output

                    scan_out_112,
                    scan_out_212,
                    scan_out_312
                   );
// define parameters12
// change using defaparam12 statements12

  // APB12 Inputs12 (use is optional12 on INCLUDE_APB12)
  input        n_preset12;           // APBreset12 
  input        pclk12;               // APB12 clock12
  input        psel12;               // APB12 select12
  input        penable12;            // APB12 enable 
  input        pwrite12;             // APB12 write strobe12 
  input [4:0]  paddr12;              // APB12 address bus
  input [31:0] pwdata12;             // APB12 write data 

  // APB12 Output12 (use is optional12 on INCLUDE_APB12)

  output [31:0] prdata12;        //APB12 output


//System12 I12/O12

  input                    hclk12;          // AHB12 System12 clock12
  input                    n_sys_reset12;   // AHB12 System12 reset (Active12 LOW12)

//AHB12 I12/O12

  input  [31:0]            haddr12;         // AHB12 Address
  input  [1:0]             htrans12;        // AHB12 transfer12 type
  input                    hsel12;          // chip12 selects12
  input                    hwrite12;        // AHB12 read/write indication12
  input  [2:0]             hsize12;         // AHB12 transfer12 size
  input  [31:0]            hwdata12;        // AHB12 write data
  input                    hready12;        // AHB12 Muxed12 ready signal12

  
  output [31:0]            smc_hrdata12;    // smc12 read data back to AHB12 master12
  output                   smc_hready12;    // smc12 ready signal12
  output [1:0]             smc_hresp12;     // AHB12 Response12 signal12
  output                   smc_valid12;     // Ack12 valid address

//External12 memory interface (EMI12)

  output [31:0]            smc_addr12;      // External12 Memory (EMI12) address
  output [31:0]            smc_data12;      // EMI12 write data
  input  [31:0]            data_smc12;      // EMI12 read data
  output [3:0]             smc_n_be12;      // EMI12 byte enables12 (Active12 LOW12)
  output                   smc_n_cs12;      // EMI12 Chip12 Selects12 (Active12 LOW12)
  output [3:0]             smc_n_we12;      // EMI12 write strobes12 (Active12 LOW12)
  output                   smc_n_wr12;      // EMI12 write enable (Active12 LOW12)
  output                   smc_n_rd12;      // EMI12 read stobe12 (Active12 LOW12)
  output 	           smc_n_ext_oe12;  // EMI12 write data output enable

//AHB12 Memory Interface12 Control12

   output                   smc_busy12;      // smc12 busy



//scan12 signals12

   input                  scan_in_112;        //scan12 input
   input                  scan_in_212;        //scan12 input
   input                  scan_en12;         //scan12 enable
   output                 scan_out_112;       //scan12 output
   output                 scan_out_212;       //scan12 output
// third12 scan12 chain12 only used on INCLUDE_APB12
   input                  scan_in_312;        //scan12 input
   output                 scan_out_312;       //scan12 output

smc_lite12 i_smc_lite12(
   //inputs12
   //apb12 inputs12
   .n_preset12(n_preset12),
   .pclk12(pclk12),
   .psel12(psel12),
   .penable12(penable12),
   .pwrite12(pwrite12),
   .paddr12(paddr12),
   .pwdata12(pwdata12),
   //ahb12 inputs12
   .hclk12(hclk12),
   .n_sys_reset12(n_sys_reset12),
   .haddr12(haddr12),
   .htrans12(htrans12),
   .hsel12(hsel12),
   .hwrite12(hwrite12),
   .hsize12(hsize12),
   .hwdata12(hwdata12),
   .hready12(hready12),
   .data_smc12(data_smc12),


         //test signal12 inputs12

   .scan_in_112(),
   .scan_in_212(),
   .scan_in_312(),
   .scan_en12(scan_en12),

   //apb12 outputs12
   .prdata12(prdata12),

   //design output

   .smc_hrdata12(smc_hrdata12),
   .smc_hready12(smc_hready12),
   .smc_hresp12(smc_hresp12),
   .smc_valid12(smc_valid12),
   .smc_addr12(smc_addr12),
   .smc_data12(smc_data12),
   .smc_n_be12(smc_n_be12),
   .smc_n_cs12(smc_n_cs12),
   .smc_n_wr12(smc_n_wr12),
   .smc_n_we12(smc_n_we12),
   .smc_n_rd12(smc_n_rd12),
   .smc_n_ext_oe12(smc_n_ext_oe12),
   .smc_busy12(smc_busy12),

   //test signal12 output
   .scan_out_112(),
   .scan_out_212(),
   .scan_out_312()
);



//------------------------------------------------------------------------------
// AHB12 formal12 verification12 monitor12
//------------------------------------------------------------------------------
  `ifdef SMC_ABV_ON12

// psl12 assume_hready_in12 : assume always (hready12 == smc_hready12) @(posedge hclk12);

    ahb_liteslave_monitor12 i_ahbSlaveMonitor12 (
        .hclk_i12(hclk12),
        .hresetn_i12(n_preset12),
        .hresp12(smc_hresp12),
        .hready12(smc_hready12),
        .hready_global_i12(smc_hready12),
        .hrdata12(smc_hrdata12),
        .hwdata_i12(hwdata12),
        .hburst_i12(3'b0),
        .hsize_i12(hsize12),
        .hwrite_i12(hwrite12),
        .htrans_i12(htrans12),
        .haddr_i12(haddr12),
        .hsel_i12(|hsel12)
    );


  ahb_litemaster_monitor12 i_ahbMasterMonitor12 (
          .hclk_i12(hclk12),
          .hresetn_i12(n_preset12),
          .hresp_i12(smc_hresp12),
          .hready_i12(smc_hready12),
          .hrdata_i12(smc_hrdata12),
          .hlock12(1'b0),
          .hwdata12(hwdata12),
          .hprot12(4'b0),
          .hburst12(3'b0),
          .hsize12(hsize12),
          .hwrite12(hwrite12),
          .htrans12(htrans12),
          .haddr12(haddr12)
          );



  `endif



endmodule
