//File11 name   : smc_veneer11.v
//Title11       : 
//Created11     : 1999
//Description11 : 
//Notes11       : 
//----------------------------------------------------------------------
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------

 `include "smc_defs_lite11.v"

//static memory controller11
module smc_veneer11 (
                    //apb11 inputs11
                    n_preset11, 
                    pclk11, 
                    psel11, 
                    penable11, 
                    pwrite11, 
                    paddr11, 
                    pwdata11,
                    //ahb11 inputs11                    
                    hclk11,
                    n_sys_reset11,
                    haddr11,
                    htrans11,
                    hsel11,
                    hwrite11,
                    hsize11,
                    hwdata11,
                    hready11,
                    data_smc11,
                    
                    //test signal11 inputs11

                    scan_in_111,
                    scan_in_211,
                    scan_in_311,
                    scan_en11,

                    //apb11 outputs11                    
                    prdata11,

                    //design output
                    
                    smc_hrdata11, 
                    smc_hready11,
                    smc_valid11,
                    smc_hresp11,
                    smc_addr11,
                    smc_data11, 
                    smc_n_be11,
                    smc_n_cs11,
                    smc_n_wr11,                    
                    smc_n_we11,
                    smc_n_rd11,
                    smc_n_ext_oe11,
                    smc_busy11,

                    //test signal11 output

                    scan_out_111,
                    scan_out_211,
                    scan_out_311
                   );
// define parameters11
// change using defaparam11 statements11

  // APB11 Inputs11 (use is optional11 on INCLUDE_APB11)
  input        n_preset11;           // APBreset11 
  input        pclk11;               // APB11 clock11
  input        psel11;               // APB11 select11
  input        penable11;            // APB11 enable 
  input        pwrite11;             // APB11 write strobe11 
  input [4:0]  paddr11;              // APB11 address bus
  input [31:0] pwdata11;             // APB11 write data 

  // APB11 Output11 (use is optional11 on INCLUDE_APB11)

  output [31:0] prdata11;        //APB11 output


//System11 I11/O11

  input                    hclk11;          // AHB11 System11 clock11
  input                    n_sys_reset11;   // AHB11 System11 reset (Active11 LOW11)

//AHB11 I11/O11

  input  [31:0]            haddr11;         // AHB11 Address
  input  [1:0]             htrans11;        // AHB11 transfer11 type
  input                    hsel11;          // chip11 selects11
  input                    hwrite11;        // AHB11 read/write indication11
  input  [2:0]             hsize11;         // AHB11 transfer11 size
  input  [31:0]            hwdata11;        // AHB11 write data
  input                    hready11;        // AHB11 Muxed11 ready signal11

  
  output [31:0]            smc_hrdata11;    // smc11 read data back to AHB11 master11
  output                   smc_hready11;    // smc11 ready signal11
  output [1:0]             smc_hresp11;     // AHB11 Response11 signal11
  output                   smc_valid11;     // Ack11 valid address

//External11 memory interface (EMI11)

  output [31:0]            smc_addr11;      // External11 Memory (EMI11) address
  output [31:0]            smc_data11;      // EMI11 write data
  input  [31:0]            data_smc11;      // EMI11 read data
  output [3:0]             smc_n_be11;      // EMI11 byte enables11 (Active11 LOW11)
  output                   smc_n_cs11;      // EMI11 Chip11 Selects11 (Active11 LOW11)
  output [3:0]             smc_n_we11;      // EMI11 write strobes11 (Active11 LOW11)
  output                   smc_n_wr11;      // EMI11 write enable (Active11 LOW11)
  output                   smc_n_rd11;      // EMI11 read stobe11 (Active11 LOW11)
  output 	           smc_n_ext_oe11;  // EMI11 write data output enable

//AHB11 Memory Interface11 Control11

   output                   smc_busy11;      // smc11 busy



//scan11 signals11

   input                  scan_in_111;        //scan11 input
   input                  scan_in_211;        //scan11 input
   input                  scan_en11;         //scan11 enable
   output                 scan_out_111;       //scan11 output
   output                 scan_out_211;       //scan11 output
// third11 scan11 chain11 only used on INCLUDE_APB11
   input                  scan_in_311;        //scan11 input
   output                 scan_out_311;       //scan11 output

smc_lite11 i_smc_lite11(
   //inputs11
   //apb11 inputs11
   .n_preset11(n_preset11),
   .pclk11(pclk11),
   .psel11(psel11),
   .penable11(penable11),
   .pwrite11(pwrite11),
   .paddr11(paddr11),
   .pwdata11(pwdata11),
   //ahb11 inputs11
   .hclk11(hclk11),
   .n_sys_reset11(n_sys_reset11),
   .haddr11(haddr11),
   .htrans11(htrans11),
   .hsel11(hsel11),
   .hwrite11(hwrite11),
   .hsize11(hsize11),
   .hwdata11(hwdata11),
   .hready11(hready11),
   .data_smc11(data_smc11),


         //test signal11 inputs11

   .scan_in_111(),
   .scan_in_211(),
   .scan_in_311(),
   .scan_en11(scan_en11),

   //apb11 outputs11
   .prdata11(prdata11),

   //design output

   .smc_hrdata11(smc_hrdata11),
   .smc_hready11(smc_hready11),
   .smc_hresp11(smc_hresp11),
   .smc_valid11(smc_valid11),
   .smc_addr11(smc_addr11),
   .smc_data11(smc_data11),
   .smc_n_be11(smc_n_be11),
   .smc_n_cs11(smc_n_cs11),
   .smc_n_wr11(smc_n_wr11),
   .smc_n_we11(smc_n_we11),
   .smc_n_rd11(smc_n_rd11),
   .smc_n_ext_oe11(smc_n_ext_oe11),
   .smc_busy11(smc_busy11),

   //test signal11 output
   .scan_out_111(),
   .scan_out_211(),
   .scan_out_311()
);



//------------------------------------------------------------------------------
// AHB11 formal11 verification11 monitor11
//------------------------------------------------------------------------------
  `ifdef SMC_ABV_ON11

// psl11 assume_hready_in11 : assume always (hready11 == smc_hready11) @(posedge hclk11);

    ahb_liteslave_monitor11 i_ahbSlaveMonitor11 (
        .hclk_i11(hclk11),
        .hresetn_i11(n_preset11),
        .hresp11(smc_hresp11),
        .hready11(smc_hready11),
        .hready_global_i11(smc_hready11),
        .hrdata11(smc_hrdata11),
        .hwdata_i11(hwdata11),
        .hburst_i11(3'b0),
        .hsize_i11(hsize11),
        .hwrite_i11(hwrite11),
        .htrans_i11(htrans11),
        .haddr_i11(haddr11),
        .hsel_i11(|hsel11)
    );


  ahb_litemaster_monitor11 i_ahbMasterMonitor11 (
          .hclk_i11(hclk11),
          .hresetn_i11(n_preset11),
          .hresp_i11(smc_hresp11),
          .hready_i11(smc_hready11),
          .hrdata_i11(smc_hrdata11),
          .hlock11(1'b0),
          .hwdata11(hwdata11),
          .hprot11(4'b0),
          .hburst11(3'b0),
          .hsize11(hsize11),
          .hwrite11(hwrite11),
          .htrans11(htrans11),
          .haddr11(haddr11)
          );



  `endif



endmodule
