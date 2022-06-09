//File16 name   : smc_veneer16.v
//Title16       : 
//Created16     : 1999
//Description16 : 
//Notes16       : 
//----------------------------------------------------------------------
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------

 `include "smc_defs_lite16.v"

//static memory controller16
module smc_veneer16 (
                    //apb16 inputs16
                    n_preset16, 
                    pclk16, 
                    psel16, 
                    penable16, 
                    pwrite16, 
                    paddr16, 
                    pwdata16,
                    //ahb16 inputs16                    
                    hclk16,
                    n_sys_reset16,
                    haddr16,
                    htrans16,
                    hsel16,
                    hwrite16,
                    hsize16,
                    hwdata16,
                    hready16,
                    data_smc16,
                    
                    //test signal16 inputs16

                    scan_in_116,
                    scan_in_216,
                    scan_in_316,
                    scan_en16,

                    //apb16 outputs16                    
                    prdata16,

                    //design output
                    
                    smc_hrdata16, 
                    smc_hready16,
                    smc_valid16,
                    smc_hresp16,
                    smc_addr16,
                    smc_data16, 
                    smc_n_be16,
                    smc_n_cs16,
                    smc_n_wr16,                    
                    smc_n_we16,
                    smc_n_rd16,
                    smc_n_ext_oe16,
                    smc_busy16,

                    //test signal16 output

                    scan_out_116,
                    scan_out_216,
                    scan_out_316
                   );
// define parameters16
// change using defaparam16 statements16

  // APB16 Inputs16 (use is optional16 on INCLUDE_APB16)
  input        n_preset16;           // APBreset16 
  input        pclk16;               // APB16 clock16
  input        psel16;               // APB16 select16
  input        penable16;            // APB16 enable 
  input        pwrite16;             // APB16 write strobe16 
  input [4:0]  paddr16;              // APB16 address bus
  input [31:0] pwdata16;             // APB16 write data 

  // APB16 Output16 (use is optional16 on INCLUDE_APB16)

  output [31:0] prdata16;        //APB16 output


//System16 I16/O16

  input                    hclk16;          // AHB16 System16 clock16
  input                    n_sys_reset16;   // AHB16 System16 reset (Active16 LOW16)

//AHB16 I16/O16

  input  [31:0]            haddr16;         // AHB16 Address
  input  [1:0]             htrans16;        // AHB16 transfer16 type
  input                    hsel16;          // chip16 selects16
  input                    hwrite16;        // AHB16 read/write indication16
  input  [2:0]             hsize16;         // AHB16 transfer16 size
  input  [31:0]            hwdata16;        // AHB16 write data
  input                    hready16;        // AHB16 Muxed16 ready signal16

  
  output [31:0]            smc_hrdata16;    // smc16 read data back to AHB16 master16
  output                   smc_hready16;    // smc16 ready signal16
  output [1:0]             smc_hresp16;     // AHB16 Response16 signal16
  output                   smc_valid16;     // Ack16 valid address

//External16 memory interface (EMI16)

  output [31:0]            smc_addr16;      // External16 Memory (EMI16) address
  output [31:0]            smc_data16;      // EMI16 write data
  input  [31:0]            data_smc16;      // EMI16 read data
  output [3:0]             smc_n_be16;      // EMI16 byte enables16 (Active16 LOW16)
  output                   smc_n_cs16;      // EMI16 Chip16 Selects16 (Active16 LOW16)
  output [3:0]             smc_n_we16;      // EMI16 write strobes16 (Active16 LOW16)
  output                   smc_n_wr16;      // EMI16 write enable (Active16 LOW16)
  output                   smc_n_rd16;      // EMI16 read stobe16 (Active16 LOW16)
  output 	           smc_n_ext_oe16;  // EMI16 write data output enable

//AHB16 Memory Interface16 Control16

   output                   smc_busy16;      // smc16 busy



//scan16 signals16

   input                  scan_in_116;        //scan16 input
   input                  scan_in_216;        //scan16 input
   input                  scan_en16;         //scan16 enable
   output                 scan_out_116;       //scan16 output
   output                 scan_out_216;       //scan16 output
// third16 scan16 chain16 only used on INCLUDE_APB16
   input                  scan_in_316;        //scan16 input
   output                 scan_out_316;       //scan16 output

smc_lite16 i_smc_lite16(
   //inputs16
   //apb16 inputs16
   .n_preset16(n_preset16),
   .pclk16(pclk16),
   .psel16(psel16),
   .penable16(penable16),
   .pwrite16(pwrite16),
   .paddr16(paddr16),
   .pwdata16(pwdata16),
   //ahb16 inputs16
   .hclk16(hclk16),
   .n_sys_reset16(n_sys_reset16),
   .haddr16(haddr16),
   .htrans16(htrans16),
   .hsel16(hsel16),
   .hwrite16(hwrite16),
   .hsize16(hsize16),
   .hwdata16(hwdata16),
   .hready16(hready16),
   .data_smc16(data_smc16),


         //test signal16 inputs16

   .scan_in_116(),
   .scan_in_216(),
   .scan_in_316(),
   .scan_en16(scan_en16),

   //apb16 outputs16
   .prdata16(prdata16),

   //design output

   .smc_hrdata16(smc_hrdata16),
   .smc_hready16(smc_hready16),
   .smc_hresp16(smc_hresp16),
   .smc_valid16(smc_valid16),
   .smc_addr16(smc_addr16),
   .smc_data16(smc_data16),
   .smc_n_be16(smc_n_be16),
   .smc_n_cs16(smc_n_cs16),
   .smc_n_wr16(smc_n_wr16),
   .smc_n_we16(smc_n_we16),
   .smc_n_rd16(smc_n_rd16),
   .smc_n_ext_oe16(smc_n_ext_oe16),
   .smc_busy16(smc_busy16),

   //test signal16 output
   .scan_out_116(),
   .scan_out_216(),
   .scan_out_316()
);



//------------------------------------------------------------------------------
// AHB16 formal16 verification16 monitor16
//------------------------------------------------------------------------------
  `ifdef SMC_ABV_ON16

// psl16 assume_hready_in16 : assume always (hready16 == smc_hready16) @(posedge hclk16);

    ahb_liteslave_monitor16 i_ahbSlaveMonitor16 (
        .hclk_i16(hclk16),
        .hresetn_i16(n_preset16),
        .hresp16(smc_hresp16),
        .hready16(smc_hready16),
        .hready_global_i16(smc_hready16),
        .hrdata16(smc_hrdata16),
        .hwdata_i16(hwdata16),
        .hburst_i16(3'b0),
        .hsize_i16(hsize16),
        .hwrite_i16(hwrite16),
        .htrans_i16(htrans16),
        .haddr_i16(haddr16),
        .hsel_i16(|hsel16)
    );


  ahb_litemaster_monitor16 i_ahbMasterMonitor16 (
          .hclk_i16(hclk16),
          .hresetn_i16(n_preset16),
          .hresp_i16(smc_hresp16),
          .hready_i16(smc_hready16),
          .hrdata_i16(smc_hrdata16),
          .hlock16(1'b0),
          .hwdata16(hwdata16),
          .hprot16(4'b0),
          .hburst16(3'b0),
          .hsize16(hsize16),
          .hwrite16(hwrite16),
          .htrans16(htrans16),
          .haddr16(haddr16)
          );



  `endif



endmodule
