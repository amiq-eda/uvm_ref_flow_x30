//File10 name   : smc_veneer10.v
//Title10       : 
//Created10     : 1999
//Description10 : 
//Notes10       : 
//----------------------------------------------------------------------
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------

 `include "smc_defs_lite10.v"

//static memory controller10
module smc_veneer10 (
                    //apb10 inputs10
                    n_preset10, 
                    pclk10, 
                    psel10, 
                    penable10, 
                    pwrite10, 
                    paddr10, 
                    pwdata10,
                    //ahb10 inputs10                    
                    hclk10,
                    n_sys_reset10,
                    haddr10,
                    htrans10,
                    hsel10,
                    hwrite10,
                    hsize10,
                    hwdata10,
                    hready10,
                    data_smc10,
                    
                    //test signal10 inputs10

                    scan_in_110,
                    scan_in_210,
                    scan_in_310,
                    scan_en10,

                    //apb10 outputs10                    
                    prdata10,

                    //design output
                    
                    smc_hrdata10, 
                    smc_hready10,
                    smc_valid10,
                    smc_hresp10,
                    smc_addr10,
                    smc_data10, 
                    smc_n_be10,
                    smc_n_cs10,
                    smc_n_wr10,                    
                    smc_n_we10,
                    smc_n_rd10,
                    smc_n_ext_oe10,
                    smc_busy10,

                    //test signal10 output

                    scan_out_110,
                    scan_out_210,
                    scan_out_310
                   );
// define parameters10
// change using defaparam10 statements10

  // APB10 Inputs10 (use is optional10 on INCLUDE_APB10)
  input        n_preset10;           // APBreset10 
  input        pclk10;               // APB10 clock10
  input        psel10;               // APB10 select10
  input        penable10;            // APB10 enable 
  input        pwrite10;             // APB10 write strobe10 
  input [4:0]  paddr10;              // APB10 address bus
  input [31:0] pwdata10;             // APB10 write data 

  // APB10 Output10 (use is optional10 on INCLUDE_APB10)

  output [31:0] prdata10;        //APB10 output


//System10 I10/O10

  input                    hclk10;          // AHB10 System10 clock10
  input                    n_sys_reset10;   // AHB10 System10 reset (Active10 LOW10)

//AHB10 I10/O10

  input  [31:0]            haddr10;         // AHB10 Address
  input  [1:0]             htrans10;        // AHB10 transfer10 type
  input                    hsel10;          // chip10 selects10
  input                    hwrite10;        // AHB10 read/write indication10
  input  [2:0]             hsize10;         // AHB10 transfer10 size
  input  [31:0]            hwdata10;        // AHB10 write data
  input                    hready10;        // AHB10 Muxed10 ready signal10

  
  output [31:0]            smc_hrdata10;    // smc10 read data back to AHB10 master10
  output                   smc_hready10;    // smc10 ready signal10
  output [1:0]             smc_hresp10;     // AHB10 Response10 signal10
  output                   smc_valid10;     // Ack10 valid address

//External10 memory interface (EMI10)

  output [31:0]            smc_addr10;      // External10 Memory (EMI10) address
  output [31:0]            smc_data10;      // EMI10 write data
  input  [31:0]            data_smc10;      // EMI10 read data
  output [3:0]             smc_n_be10;      // EMI10 byte enables10 (Active10 LOW10)
  output                   smc_n_cs10;      // EMI10 Chip10 Selects10 (Active10 LOW10)
  output [3:0]             smc_n_we10;      // EMI10 write strobes10 (Active10 LOW10)
  output                   smc_n_wr10;      // EMI10 write enable (Active10 LOW10)
  output                   smc_n_rd10;      // EMI10 read stobe10 (Active10 LOW10)
  output 	           smc_n_ext_oe10;  // EMI10 write data output enable

//AHB10 Memory Interface10 Control10

   output                   smc_busy10;      // smc10 busy



//scan10 signals10

   input                  scan_in_110;        //scan10 input
   input                  scan_in_210;        //scan10 input
   input                  scan_en10;         //scan10 enable
   output                 scan_out_110;       //scan10 output
   output                 scan_out_210;       //scan10 output
// third10 scan10 chain10 only used on INCLUDE_APB10
   input                  scan_in_310;        //scan10 input
   output                 scan_out_310;       //scan10 output

smc_lite10 i_smc_lite10(
   //inputs10
   //apb10 inputs10
   .n_preset10(n_preset10),
   .pclk10(pclk10),
   .psel10(psel10),
   .penable10(penable10),
   .pwrite10(pwrite10),
   .paddr10(paddr10),
   .pwdata10(pwdata10),
   //ahb10 inputs10
   .hclk10(hclk10),
   .n_sys_reset10(n_sys_reset10),
   .haddr10(haddr10),
   .htrans10(htrans10),
   .hsel10(hsel10),
   .hwrite10(hwrite10),
   .hsize10(hsize10),
   .hwdata10(hwdata10),
   .hready10(hready10),
   .data_smc10(data_smc10),


         //test signal10 inputs10

   .scan_in_110(),
   .scan_in_210(),
   .scan_in_310(),
   .scan_en10(scan_en10),

   //apb10 outputs10
   .prdata10(prdata10),

   //design output

   .smc_hrdata10(smc_hrdata10),
   .smc_hready10(smc_hready10),
   .smc_hresp10(smc_hresp10),
   .smc_valid10(smc_valid10),
   .smc_addr10(smc_addr10),
   .smc_data10(smc_data10),
   .smc_n_be10(smc_n_be10),
   .smc_n_cs10(smc_n_cs10),
   .smc_n_wr10(smc_n_wr10),
   .smc_n_we10(smc_n_we10),
   .smc_n_rd10(smc_n_rd10),
   .smc_n_ext_oe10(smc_n_ext_oe10),
   .smc_busy10(smc_busy10),

   //test signal10 output
   .scan_out_110(),
   .scan_out_210(),
   .scan_out_310()
);



//------------------------------------------------------------------------------
// AHB10 formal10 verification10 monitor10
//------------------------------------------------------------------------------
  `ifdef SMC_ABV_ON10

// psl10 assume_hready_in10 : assume always (hready10 == smc_hready10) @(posedge hclk10);

    ahb_liteslave_monitor10 i_ahbSlaveMonitor10 (
        .hclk_i10(hclk10),
        .hresetn_i10(n_preset10),
        .hresp10(smc_hresp10),
        .hready10(smc_hready10),
        .hready_global_i10(smc_hready10),
        .hrdata10(smc_hrdata10),
        .hwdata_i10(hwdata10),
        .hburst_i10(3'b0),
        .hsize_i10(hsize10),
        .hwrite_i10(hwrite10),
        .htrans_i10(htrans10),
        .haddr_i10(haddr10),
        .hsel_i10(|hsel10)
    );


  ahb_litemaster_monitor10 i_ahbMasterMonitor10 (
          .hclk_i10(hclk10),
          .hresetn_i10(n_preset10),
          .hresp_i10(smc_hresp10),
          .hready_i10(smc_hready10),
          .hrdata_i10(smc_hrdata10),
          .hlock10(1'b0),
          .hwdata10(hwdata10),
          .hprot10(4'b0),
          .hburst10(3'b0),
          .hsize10(hsize10),
          .hwrite10(hwrite10),
          .htrans10(htrans10),
          .haddr10(haddr10)
          );



  `endif



endmodule
