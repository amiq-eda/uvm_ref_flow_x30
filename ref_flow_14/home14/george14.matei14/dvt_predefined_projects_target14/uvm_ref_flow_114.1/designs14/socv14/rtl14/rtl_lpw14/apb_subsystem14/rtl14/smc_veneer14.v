//File14 name   : smc_veneer14.v
//Title14       : 
//Created14     : 1999
//Description14 : 
//Notes14       : 
//----------------------------------------------------------------------
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------

 `include "smc_defs_lite14.v"

//static memory controller14
module smc_veneer14 (
                    //apb14 inputs14
                    n_preset14, 
                    pclk14, 
                    psel14, 
                    penable14, 
                    pwrite14, 
                    paddr14, 
                    pwdata14,
                    //ahb14 inputs14                    
                    hclk14,
                    n_sys_reset14,
                    haddr14,
                    htrans14,
                    hsel14,
                    hwrite14,
                    hsize14,
                    hwdata14,
                    hready14,
                    data_smc14,
                    
                    //test signal14 inputs14

                    scan_in_114,
                    scan_in_214,
                    scan_in_314,
                    scan_en14,

                    //apb14 outputs14                    
                    prdata14,

                    //design output
                    
                    smc_hrdata14, 
                    smc_hready14,
                    smc_valid14,
                    smc_hresp14,
                    smc_addr14,
                    smc_data14, 
                    smc_n_be14,
                    smc_n_cs14,
                    smc_n_wr14,                    
                    smc_n_we14,
                    smc_n_rd14,
                    smc_n_ext_oe14,
                    smc_busy14,

                    //test signal14 output

                    scan_out_114,
                    scan_out_214,
                    scan_out_314
                   );
// define parameters14
// change using defaparam14 statements14

  // APB14 Inputs14 (use is optional14 on INCLUDE_APB14)
  input        n_preset14;           // APBreset14 
  input        pclk14;               // APB14 clock14
  input        psel14;               // APB14 select14
  input        penable14;            // APB14 enable 
  input        pwrite14;             // APB14 write strobe14 
  input [4:0]  paddr14;              // APB14 address bus
  input [31:0] pwdata14;             // APB14 write data 

  // APB14 Output14 (use is optional14 on INCLUDE_APB14)

  output [31:0] prdata14;        //APB14 output


//System14 I14/O14

  input                    hclk14;          // AHB14 System14 clock14
  input                    n_sys_reset14;   // AHB14 System14 reset (Active14 LOW14)

//AHB14 I14/O14

  input  [31:0]            haddr14;         // AHB14 Address
  input  [1:0]             htrans14;        // AHB14 transfer14 type
  input                    hsel14;          // chip14 selects14
  input                    hwrite14;        // AHB14 read/write indication14
  input  [2:0]             hsize14;         // AHB14 transfer14 size
  input  [31:0]            hwdata14;        // AHB14 write data
  input                    hready14;        // AHB14 Muxed14 ready signal14

  
  output [31:0]            smc_hrdata14;    // smc14 read data back to AHB14 master14
  output                   smc_hready14;    // smc14 ready signal14
  output [1:0]             smc_hresp14;     // AHB14 Response14 signal14
  output                   smc_valid14;     // Ack14 valid address

//External14 memory interface (EMI14)

  output [31:0]            smc_addr14;      // External14 Memory (EMI14) address
  output [31:0]            smc_data14;      // EMI14 write data
  input  [31:0]            data_smc14;      // EMI14 read data
  output [3:0]             smc_n_be14;      // EMI14 byte enables14 (Active14 LOW14)
  output                   smc_n_cs14;      // EMI14 Chip14 Selects14 (Active14 LOW14)
  output [3:0]             smc_n_we14;      // EMI14 write strobes14 (Active14 LOW14)
  output                   smc_n_wr14;      // EMI14 write enable (Active14 LOW14)
  output                   smc_n_rd14;      // EMI14 read stobe14 (Active14 LOW14)
  output 	           smc_n_ext_oe14;  // EMI14 write data output enable

//AHB14 Memory Interface14 Control14

   output                   smc_busy14;      // smc14 busy



//scan14 signals14

   input                  scan_in_114;        //scan14 input
   input                  scan_in_214;        //scan14 input
   input                  scan_en14;         //scan14 enable
   output                 scan_out_114;       //scan14 output
   output                 scan_out_214;       //scan14 output
// third14 scan14 chain14 only used on INCLUDE_APB14
   input                  scan_in_314;        //scan14 input
   output                 scan_out_314;       //scan14 output

smc_lite14 i_smc_lite14(
   //inputs14
   //apb14 inputs14
   .n_preset14(n_preset14),
   .pclk14(pclk14),
   .psel14(psel14),
   .penable14(penable14),
   .pwrite14(pwrite14),
   .paddr14(paddr14),
   .pwdata14(pwdata14),
   //ahb14 inputs14
   .hclk14(hclk14),
   .n_sys_reset14(n_sys_reset14),
   .haddr14(haddr14),
   .htrans14(htrans14),
   .hsel14(hsel14),
   .hwrite14(hwrite14),
   .hsize14(hsize14),
   .hwdata14(hwdata14),
   .hready14(hready14),
   .data_smc14(data_smc14),


         //test signal14 inputs14

   .scan_in_114(),
   .scan_in_214(),
   .scan_in_314(),
   .scan_en14(scan_en14),

   //apb14 outputs14
   .prdata14(prdata14),

   //design output

   .smc_hrdata14(smc_hrdata14),
   .smc_hready14(smc_hready14),
   .smc_hresp14(smc_hresp14),
   .smc_valid14(smc_valid14),
   .smc_addr14(smc_addr14),
   .smc_data14(smc_data14),
   .smc_n_be14(smc_n_be14),
   .smc_n_cs14(smc_n_cs14),
   .smc_n_wr14(smc_n_wr14),
   .smc_n_we14(smc_n_we14),
   .smc_n_rd14(smc_n_rd14),
   .smc_n_ext_oe14(smc_n_ext_oe14),
   .smc_busy14(smc_busy14),

   //test signal14 output
   .scan_out_114(),
   .scan_out_214(),
   .scan_out_314()
);



//------------------------------------------------------------------------------
// AHB14 formal14 verification14 monitor14
//------------------------------------------------------------------------------
  `ifdef SMC_ABV_ON14

// psl14 assume_hready_in14 : assume always (hready14 == smc_hready14) @(posedge hclk14);

    ahb_liteslave_monitor14 i_ahbSlaveMonitor14 (
        .hclk_i14(hclk14),
        .hresetn_i14(n_preset14),
        .hresp14(smc_hresp14),
        .hready14(smc_hready14),
        .hready_global_i14(smc_hready14),
        .hrdata14(smc_hrdata14),
        .hwdata_i14(hwdata14),
        .hburst_i14(3'b0),
        .hsize_i14(hsize14),
        .hwrite_i14(hwrite14),
        .htrans_i14(htrans14),
        .haddr_i14(haddr14),
        .hsel_i14(|hsel14)
    );


  ahb_litemaster_monitor14 i_ahbMasterMonitor14 (
          .hclk_i14(hclk14),
          .hresetn_i14(n_preset14),
          .hresp_i14(smc_hresp14),
          .hready_i14(smc_hready14),
          .hrdata_i14(smc_hrdata14),
          .hlock14(1'b0),
          .hwdata14(hwdata14),
          .hprot14(4'b0),
          .hburst14(3'b0),
          .hsize14(hsize14),
          .hwrite14(hwrite14),
          .htrans14(htrans14),
          .haddr14(haddr14)
          );



  `endif



endmodule
