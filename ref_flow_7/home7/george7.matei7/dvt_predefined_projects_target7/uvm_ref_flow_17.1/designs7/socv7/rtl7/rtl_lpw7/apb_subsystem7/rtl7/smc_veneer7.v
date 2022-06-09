//File7 name   : smc_veneer7.v
//Title7       : 
//Created7     : 1999
//Description7 : 
//Notes7       : 
//----------------------------------------------------------------------
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------

 `include "smc_defs_lite7.v"

//static memory controller7
module smc_veneer7 (
                    //apb7 inputs7
                    n_preset7, 
                    pclk7, 
                    psel7, 
                    penable7, 
                    pwrite7, 
                    paddr7, 
                    pwdata7,
                    //ahb7 inputs7                    
                    hclk7,
                    n_sys_reset7,
                    haddr7,
                    htrans7,
                    hsel7,
                    hwrite7,
                    hsize7,
                    hwdata7,
                    hready7,
                    data_smc7,
                    
                    //test signal7 inputs7

                    scan_in_17,
                    scan_in_27,
                    scan_in_37,
                    scan_en7,

                    //apb7 outputs7                    
                    prdata7,

                    //design output
                    
                    smc_hrdata7, 
                    smc_hready7,
                    smc_valid7,
                    smc_hresp7,
                    smc_addr7,
                    smc_data7, 
                    smc_n_be7,
                    smc_n_cs7,
                    smc_n_wr7,                    
                    smc_n_we7,
                    smc_n_rd7,
                    smc_n_ext_oe7,
                    smc_busy7,

                    //test signal7 output

                    scan_out_17,
                    scan_out_27,
                    scan_out_37
                   );
// define parameters7
// change using defaparam7 statements7

  // APB7 Inputs7 (use is optional7 on INCLUDE_APB7)
  input        n_preset7;           // APBreset7 
  input        pclk7;               // APB7 clock7
  input        psel7;               // APB7 select7
  input        penable7;            // APB7 enable 
  input        pwrite7;             // APB7 write strobe7 
  input [4:0]  paddr7;              // APB7 address bus
  input [31:0] pwdata7;             // APB7 write data 

  // APB7 Output7 (use is optional7 on INCLUDE_APB7)

  output [31:0] prdata7;        //APB7 output


//System7 I7/O7

  input                    hclk7;          // AHB7 System7 clock7
  input                    n_sys_reset7;   // AHB7 System7 reset (Active7 LOW7)

//AHB7 I7/O7

  input  [31:0]            haddr7;         // AHB7 Address
  input  [1:0]             htrans7;        // AHB7 transfer7 type
  input                    hsel7;          // chip7 selects7
  input                    hwrite7;        // AHB7 read/write indication7
  input  [2:0]             hsize7;         // AHB7 transfer7 size
  input  [31:0]            hwdata7;        // AHB7 write data
  input                    hready7;        // AHB7 Muxed7 ready signal7

  
  output [31:0]            smc_hrdata7;    // smc7 read data back to AHB7 master7
  output                   smc_hready7;    // smc7 ready signal7
  output [1:0]             smc_hresp7;     // AHB7 Response7 signal7
  output                   smc_valid7;     // Ack7 valid address

//External7 memory interface (EMI7)

  output [31:0]            smc_addr7;      // External7 Memory (EMI7) address
  output [31:0]            smc_data7;      // EMI7 write data
  input  [31:0]            data_smc7;      // EMI7 read data
  output [3:0]             smc_n_be7;      // EMI7 byte enables7 (Active7 LOW7)
  output                   smc_n_cs7;      // EMI7 Chip7 Selects7 (Active7 LOW7)
  output [3:0]             smc_n_we7;      // EMI7 write strobes7 (Active7 LOW7)
  output                   smc_n_wr7;      // EMI7 write enable (Active7 LOW7)
  output                   smc_n_rd7;      // EMI7 read stobe7 (Active7 LOW7)
  output 	           smc_n_ext_oe7;  // EMI7 write data output enable

//AHB7 Memory Interface7 Control7

   output                   smc_busy7;      // smc7 busy



//scan7 signals7

   input                  scan_in_17;        //scan7 input
   input                  scan_in_27;        //scan7 input
   input                  scan_en7;         //scan7 enable
   output                 scan_out_17;       //scan7 output
   output                 scan_out_27;       //scan7 output
// third7 scan7 chain7 only used on INCLUDE_APB7
   input                  scan_in_37;        //scan7 input
   output                 scan_out_37;       //scan7 output

smc_lite7 i_smc_lite7(
   //inputs7
   //apb7 inputs7
   .n_preset7(n_preset7),
   .pclk7(pclk7),
   .psel7(psel7),
   .penable7(penable7),
   .pwrite7(pwrite7),
   .paddr7(paddr7),
   .pwdata7(pwdata7),
   //ahb7 inputs7
   .hclk7(hclk7),
   .n_sys_reset7(n_sys_reset7),
   .haddr7(haddr7),
   .htrans7(htrans7),
   .hsel7(hsel7),
   .hwrite7(hwrite7),
   .hsize7(hsize7),
   .hwdata7(hwdata7),
   .hready7(hready7),
   .data_smc7(data_smc7),


         //test signal7 inputs7

   .scan_in_17(),
   .scan_in_27(),
   .scan_in_37(),
   .scan_en7(scan_en7),

   //apb7 outputs7
   .prdata7(prdata7),

   //design output

   .smc_hrdata7(smc_hrdata7),
   .smc_hready7(smc_hready7),
   .smc_hresp7(smc_hresp7),
   .smc_valid7(smc_valid7),
   .smc_addr7(smc_addr7),
   .smc_data7(smc_data7),
   .smc_n_be7(smc_n_be7),
   .smc_n_cs7(smc_n_cs7),
   .smc_n_wr7(smc_n_wr7),
   .smc_n_we7(smc_n_we7),
   .smc_n_rd7(smc_n_rd7),
   .smc_n_ext_oe7(smc_n_ext_oe7),
   .smc_busy7(smc_busy7),

   //test signal7 output
   .scan_out_17(),
   .scan_out_27(),
   .scan_out_37()
);



//------------------------------------------------------------------------------
// AHB7 formal7 verification7 monitor7
//------------------------------------------------------------------------------
  `ifdef SMC_ABV_ON7

// psl7 assume_hready_in7 : assume always (hready7 == smc_hready7) @(posedge hclk7);

    ahb_liteslave_monitor7 i_ahbSlaveMonitor7 (
        .hclk_i7(hclk7),
        .hresetn_i7(n_preset7),
        .hresp7(smc_hresp7),
        .hready7(smc_hready7),
        .hready_global_i7(smc_hready7),
        .hrdata7(smc_hrdata7),
        .hwdata_i7(hwdata7),
        .hburst_i7(3'b0),
        .hsize_i7(hsize7),
        .hwrite_i7(hwrite7),
        .htrans_i7(htrans7),
        .haddr_i7(haddr7),
        .hsel_i7(|hsel7)
    );


  ahb_litemaster_monitor7 i_ahbMasterMonitor7 (
          .hclk_i7(hclk7),
          .hresetn_i7(n_preset7),
          .hresp_i7(smc_hresp7),
          .hready_i7(smc_hready7),
          .hrdata_i7(smc_hrdata7),
          .hlock7(1'b0),
          .hwdata7(hwdata7),
          .hprot7(4'b0),
          .hburst7(3'b0),
          .hsize7(hsize7),
          .hwrite7(hwrite7),
          .htrans7(htrans7),
          .haddr7(haddr7)
          );



  `endif



endmodule
