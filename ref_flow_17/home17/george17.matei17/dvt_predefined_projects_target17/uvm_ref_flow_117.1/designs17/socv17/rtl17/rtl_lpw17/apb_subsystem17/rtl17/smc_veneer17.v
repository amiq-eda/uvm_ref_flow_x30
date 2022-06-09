//File17 name   : smc_veneer17.v
//Title17       : 
//Created17     : 1999
//Description17 : 
//Notes17       : 
//----------------------------------------------------------------------
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------

 `include "smc_defs_lite17.v"

//static memory controller17
module smc_veneer17 (
                    //apb17 inputs17
                    n_preset17, 
                    pclk17, 
                    psel17, 
                    penable17, 
                    pwrite17, 
                    paddr17, 
                    pwdata17,
                    //ahb17 inputs17                    
                    hclk17,
                    n_sys_reset17,
                    haddr17,
                    htrans17,
                    hsel17,
                    hwrite17,
                    hsize17,
                    hwdata17,
                    hready17,
                    data_smc17,
                    
                    //test signal17 inputs17

                    scan_in_117,
                    scan_in_217,
                    scan_in_317,
                    scan_en17,

                    //apb17 outputs17                    
                    prdata17,

                    //design output
                    
                    smc_hrdata17, 
                    smc_hready17,
                    smc_valid17,
                    smc_hresp17,
                    smc_addr17,
                    smc_data17, 
                    smc_n_be17,
                    smc_n_cs17,
                    smc_n_wr17,                    
                    smc_n_we17,
                    smc_n_rd17,
                    smc_n_ext_oe17,
                    smc_busy17,

                    //test signal17 output

                    scan_out_117,
                    scan_out_217,
                    scan_out_317
                   );
// define parameters17
// change using defaparam17 statements17

  // APB17 Inputs17 (use is optional17 on INCLUDE_APB17)
  input        n_preset17;           // APBreset17 
  input        pclk17;               // APB17 clock17
  input        psel17;               // APB17 select17
  input        penable17;            // APB17 enable 
  input        pwrite17;             // APB17 write strobe17 
  input [4:0]  paddr17;              // APB17 address bus
  input [31:0] pwdata17;             // APB17 write data 

  // APB17 Output17 (use is optional17 on INCLUDE_APB17)

  output [31:0] prdata17;        //APB17 output


//System17 I17/O17

  input                    hclk17;          // AHB17 System17 clock17
  input                    n_sys_reset17;   // AHB17 System17 reset (Active17 LOW17)

//AHB17 I17/O17

  input  [31:0]            haddr17;         // AHB17 Address
  input  [1:0]             htrans17;        // AHB17 transfer17 type
  input                    hsel17;          // chip17 selects17
  input                    hwrite17;        // AHB17 read/write indication17
  input  [2:0]             hsize17;         // AHB17 transfer17 size
  input  [31:0]            hwdata17;        // AHB17 write data
  input                    hready17;        // AHB17 Muxed17 ready signal17

  
  output [31:0]            smc_hrdata17;    // smc17 read data back to AHB17 master17
  output                   smc_hready17;    // smc17 ready signal17
  output [1:0]             smc_hresp17;     // AHB17 Response17 signal17
  output                   smc_valid17;     // Ack17 valid address

//External17 memory interface (EMI17)

  output [31:0]            smc_addr17;      // External17 Memory (EMI17) address
  output [31:0]            smc_data17;      // EMI17 write data
  input  [31:0]            data_smc17;      // EMI17 read data
  output [3:0]             smc_n_be17;      // EMI17 byte enables17 (Active17 LOW17)
  output                   smc_n_cs17;      // EMI17 Chip17 Selects17 (Active17 LOW17)
  output [3:0]             smc_n_we17;      // EMI17 write strobes17 (Active17 LOW17)
  output                   smc_n_wr17;      // EMI17 write enable (Active17 LOW17)
  output                   smc_n_rd17;      // EMI17 read stobe17 (Active17 LOW17)
  output 	           smc_n_ext_oe17;  // EMI17 write data output enable

//AHB17 Memory Interface17 Control17

   output                   smc_busy17;      // smc17 busy



//scan17 signals17

   input                  scan_in_117;        //scan17 input
   input                  scan_in_217;        //scan17 input
   input                  scan_en17;         //scan17 enable
   output                 scan_out_117;       //scan17 output
   output                 scan_out_217;       //scan17 output
// third17 scan17 chain17 only used on INCLUDE_APB17
   input                  scan_in_317;        //scan17 input
   output                 scan_out_317;       //scan17 output

smc_lite17 i_smc_lite17(
   //inputs17
   //apb17 inputs17
   .n_preset17(n_preset17),
   .pclk17(pclk17),
   .psel17(psel17),
   .penable17(penable17),
   .pwrite17(pwrite17),
   .paddr17(paddr17),
   .pwdata17(pwdata17),
   //ahb17 inputs17
   .hclk17(hclk17),
   .n_sys_reset17(n_sys_reset17),
   .haddr17(haddr17),
   .htrans17(htrans17),
   .hsel17(hsel17),
   .hwrite17(hwrite17),
   .hsize17(hsize17),
   .hwdata17(hwdata17),
   .hready17(hready17),
   .data_smc17(data_smc17),


         //test signal17 inputs17

   .scan_in_117(),
   .scan_in_217(),
   .scan_in_317(),
   .scan_en17(scan_en17),

   //apb17 outputs17
   .prdata17(prdata17),

   //design output

   .smc_hrdata17(smc_hrdata17),
   .smc_hready17(smc_hready17),
   .smc_hresp17(smc_hresp17),
   .smc_valid17(smc_valid17),
   .smc_addr17(smc_addr17),
   .smc_data17(smc_data17),
   .smc_n_be17(smc_n_be17),
   .smc_n_cs17(smc_n_cs17),
   .smc_n_wr17(smc_n_wr17),
   .smc_n_we17(smc_n_we17),
   .smc_n_rd17(smc_n_rd17),
   .smc_n_ext_oe17(smc_n_ext_oe17),
   .smc_busy17(smc_busy17),

   //test signal17 output
   .scan_out_117(),
   .scan_out_217(),
   .scan_out_317()
);



//------------------------------------------------------------------------------
// AHB17 formal17 verification17 monitor17
//------------------------------------------------------------------------------
  `ifdef SMC_ABV_ON17

// psl17 assume_hready_in17 : assume always (hready17 == smc_hready17) @(posedge hclk17);

    ahb_liteslave_monitor17 i_ahbSlaveMonitor17 (
        .hclk_i17(hclk17),
        .hresetn_i17(n_preset17),
        .hresp17(smc_hresp17),
        .hready17(smc_hready17),
        .hready_global_i17(smc_hready17),
        .hrdata17(smc_hrdata17),
        .hwdata_i17(hwdata17),
        .hburst_i17(3'b0),
        .hsize_i17(hsize17),
        .hwrite_i17(hwrite17),
        .htrans_i17(htrans17),
        .haddr_i17(haddr17),
        .hsel_i17(|hsel17)
    );


  ahb_litemaster_monitor17 i_ahbMasterMonitor17 (
          .hclk_i17(hclk17),
          .hresetn_i17(n_preset17),
          .hresp_i17(smc_hresp17),
          .hready_i17(smc_hready17),
          .hrdata_i17(smc_hrdata17),
          .hlock17(1'b0),
          .hwdata17(hwdata17),
          .hprot17(4'b0),
          .hburst17(3'b0),
          .hsize17(hsize17),
          .hwrite17(hwrite17),
          .htrans17(htrans17),
          .haddr17(haddr17)
          );



  `endif



endmodule
