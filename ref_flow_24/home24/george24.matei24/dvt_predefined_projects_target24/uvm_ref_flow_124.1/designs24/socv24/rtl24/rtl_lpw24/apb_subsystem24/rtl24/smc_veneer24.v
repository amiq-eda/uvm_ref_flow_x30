//File24 name   : smc_veneer24.v
//Title24       : 
//Created24     : 1999
//Description24 : 
//Notes24       : 
//----------------------------------------------------------------------
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------

 `include "smc_defs_lite24.v"

//static memory controller24
module smc_veneer24 (
                    //apb24 inputs24
                    n_preset24, 
                    pclk24, 
                    psel24, 
                    penable24, 
                    pwrite24, 
                    paddr24, 
                    pwdata24,
                    //ahb24 inputs24                    
                    hclk24,
                    n_sys_reset24,
                    haddr24,
                    htrans24,
                    hsel24,
                    hwrite24,
                    hsize24,
                    hwdata24,
                    hready24,
                    data_smc24,
                    
                    //test signal24 inputs24

                    scan_in_124,
                    scan_in_224,
                    scan_in_324,
                    scan_en24,

                    //apb24 outputs24                    
                    prdata24,

                    //design output
                    
                    smc_hrdata24, 
                    smc_hready24,
                    smc_valid24,
                    smc_hresp24,
                    smc_addr24,
                    smc_data24, 
                    smc_n_be24,
                    smc_n_cs24,
                    smc_n_wr24,                    
                    smc_n_we24,
                    smc_n_rd24,
                    smc_n_ext_oe24,
                    smc_busy24,

                    //test signal24 output

                    scan_out_124,
                    scan_out_224,
                    scan_out_324
                   );
// define parameters24
// change using defaparam24 statements24

  // APB24 Inputs24 (use is optional24 on INCLUDE_APB24)
  input        n_preset24;           // APBreset24 
  input        pclk24;               // APB24 clock24
  input        psel24;               // APB24 select24
  input        penable24;            // APB24 enable 
  input        pwrite24;             // APB24 write strobe24 
  input [4:0]  paddr24;              // APB24 address bus
  input [31:0] pwdata24;             // APB24 write data 

  // APB24 Output24 (use is optional24 on INCLUDE_APB24)

  output [31:0] prdata24;        //APB24 output


//System24 I24/O24

  input                    hclk24;          // AHB24 System24 clock24
  input                    n_sys_reset24;   // AHB24 System24 reset (Active24 LOW24)

//AHB24 I24/O24

  input  [31:0]            haddr24;         // AHB24 Address
  input  [1:0]             htrans24;        // AHB24 transfer24 type
  input                    hsel24;          // chip24 selects24
  input                    hwrite24;        // AHB24 read/write indication24
  input  [2:0]             hsize24;         // AHB24 transfer24 size
  input  [31:0]            hwdata24;        // AHB24 write data
  input                    hready24;        // AHB24 Muxed24 ready signal24

  
  output [31:0]            smc_hrdata24;    // smc24 read data back to AHB24 master24
  output                   smc_hready24;    // smc24 ready signal24
  output [1:0]             smc_hresp24;     // AHB24 Response24 signal24
  output                   smc_valid24;     // Ack24 valid address

//External24 memory interface (EMI24)

  output [31:0]            smc_addr24;      // External24 Memory (EMI24) address
  output [31:0]            smc_data24;      // EMI24 write data
  input  [31:0]            data_smc24;      // EMI24 read data
  output [3:0]             smc_n_be24;      // EMI24 byte enables24 (Active24 LOW24)
  output                   smc_n_cs24;      // EMI24 Chip24 Selects24 (Active24 LOW24)
  output [3:0]             smc_n_we24;      // EMI24 write strobes24 (Active24 LOW24)
  output                   smc_n_wr24;      // EMI24 write enable (Active24 LOW24)
  output                   smc_n_rd24;      // EMI24 read stobe24 (Active24 LOW24)
  output 	           smc_n_ext_oe24;  // EMI24 write data output enable

//AHB24 Memory Interface24 Control24

   output                   smc_busy24;      // smc24 busy



//scan24 signals24

   input                  scan_in_124;        //scan24 input
   input                  scan_in_224;        //scan24 input
   input                  scan_en24;         //scan24 enable
   output                 scan_out_124;       //scan24 output
   output                 scan_out_224;       //scan24 output
// third24 scan24 chain24 only used on INCLUDE_APB24
   input                  scan_in_324;        //scan24 input
   output                 scan_out_324;       //scan24 output

smc_lite24 i_smc_lite24(
   //inputs24
   //apb24 inputs24
   .n_preset24(n_preset24),
   .pclk24(pclk24),
   .psel24(psel24),
   .penable24(penable24),
   .pwrite24(pwrite24),
   .paddr24(paddr24),
   .pwdata24(pwdata24),
   //ahb24 inputs24
   .hclk24(hclk24),
   .n_sys_reset24(n_sys_reset24),
   .haddr24(haddr24),
   .htrans24(htrans24),
   .hsel24(hsel24),
   .hwrite24(hwrite24),
   .hsize24(hsize24),
   .hwdata24(hwdata24),
   .hready24(hready24),
   .data_smc24(data_smc24),


         //test signal24 inputs24

   .scan_in_124(),
   .scan_in_224(),
   .scan_in_324(),
   .scan_en24(scan_en24),

   //apb24 outputs24
   .prdata24(prdata24),

   //design output

   .smc_hrdata24(smc_hrdata24),
   .smc_hready24(smc_hready24),
   .smc_hresp24(smc_hresp24),
   .smc_valid24(smc_valid24),
   .smc_addr24(smc_addr24),
   .smc_data24(smc_data24),
   .smc_n_be24(smc_n_be24),
   .smc_n_cs24(smc_n_cs24),
   .smc_n_wr24(smc_n_wr24),
   .smc_n_we24(smc_n_we24),
   .smc_n_rd24(smc_n_rd24),
   .smc_n_ext_oe24(smc_n_ext_oe24),
   .smc_busy24(smc_busy24),

   //test signal24 output
   .scan_out_124(),
   .scan_out_224(),
   .scan_out_324()
);



//------------------------------------------------------------------------------
// AHB24 formal24 verification24 monitor24
//------------------------------------------------------------------------------
  `ifdef SMC_ABV_ON24

// psl24 assume_hready_in24 : assume always (hready24 == smc_hready24) @(posedge hclk24);

    ahb_liteslave_monitor24 i_ahbSlaveMonitor24 (
        .hclk_i24(hclk24),
        .hresetn_i24(n_preset24),
        .hresp24(smc_hresp24),
        .hready24(smc_hready24),
        .hready_global_i24(smc_hready24),
        .hrdata24(smc_hrdata24),
        .hwdata_i24(hwdata24),
        .hburst_i24(3'b0),
        .hsize_i24(hsize24),
        .hwrite_i24(hwrite24),
        .htrans_i24(htrans24),
        .haddr_i24(haddr24),
        .hsel_i24(|hsel24)
    );


  ahb_litemaster_monitor24 i_ahbMasterMonitor24 (
          .hclk_i24(hclk24),
          .hresetn_i24(n_preset24),
          .hresp_i24(smc_hresp24),
          .hready_i24(smc_hready24),
          .hrdata_i24(smc_hrdata24),
          .hlock24(1'b0),
          .hwdata24(hwdata24),
          .hprot24(4'b0),
          .hburst24(3'b0),
          .hsize24(hsize24),
          .hwrite24(hwrite24),
          .htrans24(htrans24),
          .haddr24(haddr24)
          );



  `endif



endmodule
