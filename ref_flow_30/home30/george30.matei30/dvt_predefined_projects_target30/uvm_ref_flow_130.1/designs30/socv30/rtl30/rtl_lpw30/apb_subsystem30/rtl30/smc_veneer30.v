//File30 name   : smc_veneer30.v
//Title30       : 
//Created30     : 1999
//Description30 : 
//Notes30       : 
//----------------------------------------------------------------------
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------

 `include "smc_defs_lite30.v"

//static memory controller30
module smc_veneer30 (
                    //apb30 inputs30
                    n_preset30, 
                    pclk30, 
                    psel30, 
                    penable30, 
                    pwrite30, 
                    paddr30, 
                    pwdata30,
                    //ahb30 inputs30                    
                    hclk30,
                    n_sys_reset30,
                    haddr30,
                    htrans30,
                    hsel30,
                    hwrite30,
                    hsize30,
                    hwdata30,
                    hready30,
                    data_smc30,
                    
                    //test signal30 inputs30

                    scan_in_130,
                    scan_in_230,
                    scan_in_330,
                    scan_en30,

                    //apb30 outputs30                    
                    prdata30,

                    //design output
                    
                    smc_hrdata30, 
                    smc_hready30,
                    smc_valid30,
                    smc_hresp30,
                    smc_addr30,
                    smc_data30, 
                    smc_n_be30,
                    smc_n_cs30,
                    smc_n_wr30,                    
                    smc_n_we30,
                    smc_n_rd30,
                    smc_n_ext_oe30,
                    smc_busy30,

                    //test signal30 output

                    scan_out_130,
                    scan_out_230,
                    scan_out_330
                   );
// define parameters30
// change using defaparam30 statements30

  // APB30 Inputs30 (use is optional30 on INCLUDE_APB30)
  input        n_preset30;           // APBreset30 
  input        pclk30;               // APB30 clock30
  input        psel30;               // APB30 select30
  input        penable30;            // APB30 enable 
  input        pwrite30;             // APB30 write strobe30 
  input [4:0]  paddr30;              // APB30 address bus
  input [31:0] pwdata30;             // APB30 write data 

  // APB30 Output30 (use is optional30 on INCLUDE_APB30)

  output [31:0] prdata30;        //APB30 output


//System30 I30/O30

  input                    hclk30;          // AHB30 System30 clock30
  input                    n_sys_reset30;   // AHB30 System30 reset (Active30 LOW30)

//AHB30 I30/O30

  input  [31:0]            haddr30;         // AHB30 Address
  input  [1:0]             htrans30;        // AHB30 transfer30 type
  input                    hsel30;          // chip30 selects30
  input                    hwrite30;        // AHB30 read/write indication30
  input  [2:0]             hsize30;         // AHB30 transfer30 size
  input  [31:0]            hwdata30;        // AHB30 write data
  input                    hready30;        // AHB30 Muxed30 ready signal30

  
  output [31:0]            smc_hrdata30;    // smc30 read data back to AHB30 master30
  output                   smc_hready30;    // smc30 ready signal30
  output [1:0]             smc_hresp30;     // AHB30 Response30 signal30
  output                   smc_valid30;     // Ack30 valid address

//External30 memory interface (EMI30)

  output [31:0]            smc_addr30;      // External30 Memory (EMI30) address
  output [31:0]            smc_data30;      // EMI30 write data
  input  [31:0]            data_smc30;      // EMI30 read data
  output [3:0]             smc_n_be30;      // EMI30 byte enables30 (Active30 LOW30)
  output                   smc_n_cs30;      // EMI30 Chip30 Selects30 (Active30 LOW30)
  output [3:0]             smc_n_we30;      // EMI30 write strobes30 (Active30 LOW30)
  output                   smc_n_wr30;      // EMI30 write enable (Active30 LOW30)
  output                   smc_n_rd30;      // EMI30 read stobe30 (Active30 LOW30)
  output 	           smc_n_ext_oe30;  // EMI30 write data output enable

//AHB30 Memory Interface30 Control30

   output                   smc_busy30;      // smc30 busy



//scan30 signals30

   input                  scan_in_130;        //scan30 input
   input                  scan_in_230;        //scan30 input
   input                  scan_en30;         //scan30 enable
   output                 scan_out_130;       //scan30 output
   output                 scan_out_230;       //scan30 output
// third30 scan30 chain30 only used on INCLUDE_APB30
   input                  scan_in_330;        //scan30 input
   output                 scan_out_330;       //scan30 output

smc_lite30 i_smc_lite30(
   //inputs30
   //apb30 inputs30
   .n_preset30(n_preset30),
   .pclk30(pclk30),
   .psel30(psel30),
   .penable30(penable30),
   .pwrite30(pwrite30),
   .paddr30(paddr30),
   .pwdata30(pwdata30),
   //ahb30 inputs30
   .hclk30(hclk30),
   .n_sys_reset30(n_sys_reset30),
   .haddr30(haddr30),
   .htrans30(htrans30),
   .hsel30(hsel30),
   .hwrite30(hwrite30),
   .hsize30(hsize30),
   .hwdata30(hwdata30),
   .hready30(hready30),
   .data_smc30(data_smc30),


         //test signal30 inputs30

   .scan_in_130(),
   .scan_in_230(),
   .scan_in_330(),
   .scan_en30(scan_en30),

   //apb30 outputs30
   .prdata30(prdata30),

   //design output

   .smc_hrdata30(smc_hrdata30),
   .smc_hready30(smc_hready30),
   .smc_hresp30(smc_hresp30),
   .smc_valid30(smc_valid30),
   .smc_addr30(smc_addr30),
   .smc_data30(smc_data30),
   .smc_n_be30(smc_n_be30),
   .smc_n_cs30(smc_n_cs30),
   .smc_n_wr30(smc_n_wr30),
   .smc_n_we30(smc_n_we30),
   .smc_n_rd30(smc_n_rd30),
   .smc_n_ext_oe30(smc_n_ext_oe30),
   .smc_busy30(smc_busy30),

   //test signal30 output
   .scan_out_130(),
   .scan_out_230(),
   .scan_out_330()
);



//------------------------------------------------------------------------------
// AHB30 formal30 verification30 monitor30
//------------------------------------------------------------------------------
  `ifdef SMC_ABV_ON30

// psl30 assume_hready_in30 : assume always (hready30 == smc_hready30) @(posedge hclk30);

    ahb_liteslave_monitor30 i_ahbSlaveMonitor30 (
        .hclk_i30(hclk30),
        .hresetn_i30(n_preset30),
        .hresp30(smc_hresp30),
        .hready30(smc_hready30),
        .hready_global_i30(smc_hready30),
        .hrdata30(smc_hrdata30),
        .hwdata_i30(hwdata30),
        .hburst_i30(3'b0),
        .hsize_i30(hsize30),
        .hwrite_i30(hwrite30),
        .htrans_i30(htrans30),
        .haddr_i30(haddr30),
        .hsel_i30(|hsel30)
    );


  ahb_litemaster_monitor30 i_ahbMasterMonitor30 (
          .hclk_i30(hclk30),
          .hresetn_i30(n_preset30),
          .hresp_i30(smc_hresp30),
          .hready_i30(smc_hready30),
          .hrdata_i30(smc_hrdata30),
          .hlock30(1'b0),
          .hwdata30(hwdata30),
          .hprot30(4'b0),
          .hburst30(3'b0),
          .hsize30(hsize30),
          .hwrite30(hwrite30),
          .htrans30(htrans30),
          .haddr30(haddr30)
          );



  `endif



endmodule
