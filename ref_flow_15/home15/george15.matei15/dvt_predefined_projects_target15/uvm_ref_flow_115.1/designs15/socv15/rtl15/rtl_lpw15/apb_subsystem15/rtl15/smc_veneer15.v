//File15 name   : smc_veneer15.v
//Title15       : 
//Created15     : 1999
//Description15 : 
//Notes15       : 
//----------------------------------------------------------------------
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------

 `include "smc_defs_lite15.v"

//static memory controller15
module smc_veneer15 (
                    //apb15 inputs15
                    n_preset15, 
                    pclk15, 
                    psel15, 
                    penable15, 
                    pwrite15, 
                    paddr15, 
                    pwdata15,
                    //ahb15 inputs15                    
                    hclk15,
                    n_sys_reset15,
                    haddr15,
                    htrans15,
                    hsel15,
                    hwrite15,
                    hsize15,
                    hwdata15,
                    hready15,
                    data_smc15,
                    
                    //test signal15 inputs15

                    scan_in_115,
                    scan_in_215,
                    scan_in_315,
                    scan_en15,

                    //apb15 outputs15                    
                    prdata15,

                    //design output
                    
                    smc_hrdata15, 
                    smc_hready15,
                    smc_valid15,
                    smc_hresp15,
                    smc_addr15,
                    smc_data15, 
                    smc_n_be15,
                    smc_n_cs15,
                    smc_n_wr15,                    
                    smc_n_we15,
                    smc_n_rd15,
                    smc_n_ext_oe15,
                    smc_busy15,

                    //test signal15 output

                    scan_out_115,
                    scan_out_215,
                    scan_out_315
                   );
// define parameters15
// change using defaparam15 statements15

  // APB15 Inputs15 (use is optional15 on INCLUDE_APB15)
  input        n_preset15;           // APBreset15 
  input        pclk15;               // APB15 clock15
  input        psel15;               // APB15 select15
  input        penable15;            // APB15 enable 
  input        pwrite15;             // APB15 write strobe15 
  input [4:0]  paddr15;              // APB15 address bus
  input [31:0] pwdata15;             // APB15 write data 

  // APB15 Output15 (use is optional15 on INCLUDE_APB15)

  output [31:0] prdata15;        //APB15 output


//System15 I15/O15

  input                    hclk15;          // AHB15 System15 clock15
  input                    n_sys_reset15;   // AHB15 System15 reset (Active15 LOW15)

//AHB15 I15/O15

  input  [31:0]            haddr15;         // AHB15 Address
  input  [1:0]             htrans15;        // AHB15 transfer15 type
  input                    hsel15;          // chip15 selects15
  input                    hwrite15;        // AHB15 read/write indication15
  input  [2:0]             hsize15;         // AHB15 transfer15 size
  input  [31:0]            hwdata15;        // AHB15 write data
  input                    hready15;        // AHB15 Muxed15 ready signal15

  
  output [31:0]            smc_hrdata15;    // smc15 read data back to AHB15 master15
  output                   smc_hready15;    // smc15 ready signal15
  output [1:0]             smc_hresp15;     // AHB15 Response15 signal15
  output                   smc_valid15;     // Ack15 valid address

//External15 memory interface (EMI15)

  output [31:0]            smc_addr15;      // External15 Memory (EMI15) address
  output [31:0]            smc_data15;      // EMI15 write data
  input  [31:0]            data_smc15;      // EMI15 read data
  output [3:0]             smc_n_be15;      // EMI15 byte enables15 (Active15 LOW15)
  output                   smc_n_cs15;      // EMI15 Chip15 Selects15 (Active15 LOW15)
  output [3:0]             smc_n_we15;      // EMI15 write strobes15 (Active15 LOW15)
  output                   smc_n_wr15;      // EMI15 write enable (Active15 LOW15)
  output                   smc_n_rd15;      // EMI15 read stobe15 (Active15 LOW15)
  output 	           smc_n_ext_oe15;  // EMI15 write data output enable

//AHB15 Memory Interface15 Control15

   output                   smc_busy15;      // smc15 busy



//scan15 signals15

   input                  scan_in_115;        //scan15 input
   input                  scan_in_215;        //scan15 input
   input                  scan_en15;         //scan15 enable
   output                 scan_out_115;       //scan15 output
   output                 scan_out_215;       //scan15 output
// third15 scan15 chain15 only used on INCLUDE_APB15
   input                  scan_in_315;        //scan15 input
   output                 scan_out_315;       //scan15 output

smc_lite15 i_smc_lite15(
   //inputs15
   //apb15 inputs15
   .n_preset15(n_preset15),
   .pclk15(pclk15),
   .psel15(psel15),
   .penable15(penable15),
   .pwrite15(pwrite15),
   .paddr15(paddr15),
   .pwdata15(pwdata15),
   //ahb15 inputs15
   .hclk15(hclk15),
   .n_sys_reset15(n_sys_reset15),
   .haddr15(haddr15),
   .htrans15(htrans15),
   .hsel15(hsel15),
   .hwrite15(hwrite15),
   .hsize15(hsize15),
   .hwdata15(hwdata15),
   .hready15(hready15),
   .data_smc15(data_smc15),


         //test signal15 inputs15

   .scan_in_115(),
   .scan_in_215(),
   .scan_in_315(),
   .scan_en15(scan_en15),

   //apb15 outputs15
   .prdata15(prdata15),

   //design output

   .smc_hrdata15(smc_hrdata15),
   .smc_hready15(smc_hready15),
   .smc_hresp15(smc_hresp15),
   .smc_valid15(smc_valid15),
   .smc_addr15(smc_addr15),
   .smc_data15(smc_data15),
   .smc_n_be15(smc_n_be15),
   .smc_n_cs15(smc_n_cs15),
   .smc_n_wr15(smc_n_wr15),
   .smc_n_we15(smc_n_we15),
   .smc_n_rd15(smc_n_rd15),
   .smc_n_ext_oe15(smc_n_ext_oe15),
   .smc_busy15(smc_busy15),

   //test signal15 output
   .scan_out_115(),
   .scan_out_215(),
   .scan_out_315()
);



//------------------------------------------------------------------------------
// AHB15 formal15 verification15 monitor15
//------------------------------------------------------------------------------
  `ifdef SMC_ABV_ON15

// psl15 assume_hready_in15 : assume always (hready15 == smc_hready15) @(posedge hclk15);

    ahb_liteslave_monitor15 i_ahbSlaveMonitor15 (
        .hclk_i15(hclk15),
        .hresetn_i15(n_preset15),
        .hresp15(smc_hresp15),
        .hready15(smc_hready15),
        .hready_global_i15(smc_hready15),
        .hrdata15(smc_hrdata15),
        .hwdata_i15(hwdata15),
        .hburst_i15(3'b0),
        .hsize_i15(hsize15),
        .hwrite_i15(hwrite15),
        .htrans_i15(htrans15),
        .haddr_i15(haddr15),
        .hsel_i15(|hsel15)
    );


  ahb_litemaster_monitor15 i_ahbMasterMonitor15 (
          .hclk_i15(hclk15),
          .hresetn_i15(n_preset15),
          .hresp_i15(smc_hresp15),
          .hready_i15(smc_hready15),
          .hrdata_i15(smc_hrdata15),
          .hlock15(1'b0),
          .hwdata15(hwdata15),
          .hprot15(4'b0),
          .hburst15(3'b0),
          .hsize15(hsize15),
          .hwrite15(hwrite15),
          .htrans15(htrans15),
          .haddr15(haddr15)
          );



  `endif



endmodule
