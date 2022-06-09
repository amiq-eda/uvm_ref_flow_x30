//File27 name   : smc_veneer27.v
//Title27       : 
//Created27     : 1999
//Description27 : 
//Notes27       : 
//----------------------------------------------------------------------
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------

 `include "smc_defs_lite27.v"

//static memory controller27
module smc_veneer27 (
                    //apb27 inputs27
                    n_preset27, 
                    pclk27, 
                    psel27, 
                    penable27, 
                    pwrite27, 
                    paddr27, 
                    pwdata27,
                    //ahb27 inputs27                    
                    hclk27,
                    n_sys_reset27,
                    haddr27,
                    htrans27,
                    hsel27,
                    hwrite27,
                    hsize27,
                    hwdata27,
                    hready27,
                    data_smc27,
                    
                    //test signal27 inputs27

                    scan_in_127,
                    scan_in_227,
                    scan_in_327,
                    scan_en27,

                    //apb27 outputs27                    
                    prdata27,

                    //design output
                    
                    smc_hrdata27, 
                    smc_hready27,
                    smc_valid27,
                    smc_hresp27,
                    smc_addr27,
                    smc_data27, 
                    smc_n_be27,
                    smc_n_cs27,
                    smc_n_wr27,                    
                    smc_n_we27,
                    smc_n_rd27,
                    smc_n_ext_oe27,
                    smc_busy27,

                    //test signal27 output

                    scan_out_127,
                    scan_out_227,
                    scan_out_327
                   );
// define parameters27
// change using defaparam27 statements27

  // APB27 Inputs27 (use is optional27 on INCLUDE_APB27)
  input        n_preset27;           // APBreset27 
  input        pclk27;               // APB27 clock27
  input        psel27;               // APB27 select27
  input        penable27;            // APB27 enable 
  input        pwrite27;             // APB27 write strobe27 
  input [4:0]  paddr27;              // APB27 address bus
  input [31:0] pwdata27;             // APB27 write data 

  // APB27 Output27 (use is optional27 on INCLUDE_APB27)

  output [31:0] prdata27;        //APB27 output


//System27 I27/O27

  input                    hclk27;          // AHB27 System27 clock27
  input                    n_sys_reset27;   // AHB27 System27 reset (Active27 LOW27)

//AHB27 I27/O27

  input  [31:0]            haddr27;         // AHB27 Address
  input  [1:0]             htrans27;        // AHB27 transfer27 type
  input                    hsel27;          // chip27 selects27
  input                    hwrite27;        // AHB27 read/write indication27
  input  [2:0]             hsize27;         // AHB27 transfer27 size
  input  [31:0]            hwdata27;        // AHB27 write data
  input                    hready27;        // AHB27 Muxed27 ready signal27

  
  output [31:0]            smc_hrdata27;    // smc27 read data back to AHB27 master27
  output                   smc_hready27;    // smc27 ready signal27
  output [1:0]             smc_hresp27;     // AHB27 Response27 signal27
  output                   smc_valid27;     // Ack27 valid address

//External27 memory interface (EMI27)

  output [31:0]            smc_addr27;      // External27 Memory (EMI27) address
  output [31:0]            smc_data27;      // EMI27 write data
  input  [31:0]            data_smc27;      // EMI27 read data
  output [3:0]             smc_n_be27;      // EMI27 byte enables27 (Active27 LOW27)
  output                   smc_n_cs27;      // EMI27 Chip27 Selects27 (Active27 LOW27)
  output [3:0]             smc_n_we27;      // EMI27 write strobes27 (Active27 LOW27)
  output                   smc_n_wr27;      // EMI27 write enable (Active27 LOW27)
  output                   smc_n_rd27;      // EMI27 read stobe27 (Active27 LOW27)
  output 	           smc_n_ext_oe27;  // EMI27 write data output enable

//AHB27 Memory Interface27 Control27

   output                   smc_busy27;      // smc27 busy



//scan27 signals27

   input                  scan_in_127;        //scan27 input
   input                  scan_in_227;        //scan27 input
   input                  scan_en27;         //scan27 enable
   output                 scan_out_127;       //scan27 output
   output                 scan_out_227;       //scan27 output
// third27 scan27 chain27 only used on INCLUDE_APB27
   input                  scan_in_327;        //scan27 input
   output                 scan_out_327;       //scan27 output

smc_lite27 i_smc_lite27(
   //inputs27
   //apb27 inputs27
   .n_preset27(n_preset27),
   .pclk27(pclk27),
   .psel27(psel27),
   .penable27(penable27),
   .pwrite27(pwrite27),
   .paddr27(paddr27),
   .pwdata27(pwdata27),
   //ahb27 inputs27
   .hclk27(hclk27),
   .n_sys_reset27(n_sys_reset27),
   .haddr27(haddr27),
   .htrans27(htrans27),
   .hsel27(hsel27),
   .hwrite27(hwrite27),
   .hsize27(hsize27),
   .hwdata27(hwdata27),
   .hready27(hready27),
   .data_smc27(data_smc27),


         //test signal27 inputs27

   .scan_in_127(),
   .scan_in_227(),
   .scan_in_327(),
   .scan_en27(scan_en27),

   //apb27 outputs27
   .prdata27(prdata27),

   //design output

   .smc_hrdata27(smc_hrdata27),
   .smc_hready27(smc_hready27),
   .smc_hresp27(smc_hresp27),
   .smc_valid27(smc_valid27),
   .smc_addr27(smc_addr27),
   .smc_data27(smc_data27),
   .smc_n_be27(smc_n_be27),
   .smc_n_cs27(smc_n_cs27),
   .smc_n_wr27(smc_n_wr27),
   .smc_n_we27(smc_n_we27),
   .smc_n_rd27(smc_n_rd27),
   .smc_n_ext_oe27(smc_n_ext_oe27),
   .smc_busy27(smc_busy27),

   //test signal27 output
   .scan_out_127(),
   .scan_out_227(),
   .scan_out_327()
);



//------------------------------------------------------------------------------
// AHB27 formal27 verification27 monitor27
//------------------------------------------------------------------------------
  `ifdef SMC_ABV_ON27

// psl27 assume_hready_in27 : assume always (hready27 == smc_hready27) @(posedge hclk27);

    ahb_liteslave_monitor27 i_ahbSlaveMonitor27 (
        .hclk_i27(hclk27),
        .hresetn_i27(n_preset27),
        .hresp27(smc_hresp27),
        .hready27(smc_hready27),
        .hready_global_i27(smc_hready27),
        .hrdata27(smc_hrdata27),
        .hwdata_i27(hwdata27),
        .hburst_i27(3'b0),
        .hsize_i27(hsize27),
        .hwrite_i27(hwrite27),
        .htrans_i27(htrans27),
        .haddr_i27(haddr27),
        .hsel_i27(|hsel27)
    );


  ahb_litemaster_monitor27 i_ahbMasterMonitor27 (
          .hclk_i27(hclk27),
          .hresetn_i27(n_preset27),
          .hresp_i27(smc_hresp27),
          .hready_i27(smc_hready27),
          .hrdata_i27(smc_hrdata27),
          .hlock27(1'b0),
          .hwdata27(hwdata27),
          .hprot27(4'b0),
          .hburst27(3'b0),
          .hsize27(hsize27),
          .hwrite27(hwrite27),
          .htrans27(htrans27),
          .haddr27(haddr27)
          );



  `endif



endmodule
