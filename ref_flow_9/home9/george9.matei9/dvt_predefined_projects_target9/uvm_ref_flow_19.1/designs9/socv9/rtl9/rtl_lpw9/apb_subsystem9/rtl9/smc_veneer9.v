//File9 name   : smc_veneer9.v
//Title9       : 
//Created9     : 1999
//Description9 : 
//Notes9       : 
//----------------------------------------------------------------------
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------

 `include "smc_defs_lite9.v"

//static memory controller9
module smc_veneer9 (
                    //apb9 inputs9
                    n_preset9, 
                    pclk9, 
                    psel9, 
                    penable9, 
                    pwrite9, 
                    paddr9, 
                    pwdata9,
                    //ahb9 inputs9                    
                    hclk9,
                    n_sys_reset9,
                    haddr9,
                    htrans9,
                    hsel9,
                    hwrite9,
                    hsize9,
                    hwdata9,
                    hready9,
                    data_smc9,
                    
                    //test signal9 inputs9

                    scan_in_19,
                    scan_in_29,
                    scan_in_39,
                    scan_en9,

                    //apb9 outputs9                    
                    prdata9,

                    //design output
                    
                    smc_hrdata9, 
                    smc_hready9,
                    smc_valid9,
                    smc_hresp9,
                    smc_addr9,
                    smc_data9, 
                    smc_n_be9,
                    smc_n_cs9,
                    smc_n_wr9,                    
                    smc_n_we9,
                    smc_n_rd9,
                    smc_n_ext_oe9,
                    smc_busy9,

                    //test signal9 output

                    scan_out_19,
                    scan_out_29,
                    scan_out_39
                   );
// define parameters9
// change using defaparam9 statements9

  // APB9 Inputs9 (use is optional9 on INCLUDE_APB9)
  input        n_preset9;           // APBreset9 
  input        pclk9;               // APB9 clock9
  input        psel9;               // APB9 select9
  input        penable9;            // APB9 enable 
  input        pwrite9;             // APB9 write strobe9 
  input [4:0]  paddr9;              // APB9 address bus
  input [31:0] pwdata9;             // APB9 write data 

  // APB9 Output9 (use is optional9 on INCLUDE_APB9)

  output [31:0] prdata9;        //APB9 output


//System9 I9/O9

  input                    hclk9;          // AHB9 System9 clock9
  input                    n_sys_reset9;   // AHB9 System9 reset (Active9 LOW9)

//AHB9 I9/O9

  input  [31:0]            haddr9;         // AHB9 Address
  input  [1:0]             htrans9;        // AHB9 transfer9 type
  input                    hsel9;          // chip9 selects9
  input                    hwrite9;        // AHB9 read/write indication9
  input  [2:0]             hsize9;         // AHB9 transfer9 size
  input  [31:0]            hwdata9;        // AHB9 write data
  input                    hready9;        // AHB9 Muxed9 ready signal9

  
  output [31:0]            smc_hrdata9;    // smc9 read data back to AHB9 master9
  output                   smc_hready9;    // smc9 ready signal9
  output [1:0]             smc_hresp9;     // AHB9 Response9 signal9
  output                   smc_valid9;     // Ack9 valid address

//External9 memory interface (EMI9)

  output [31:0]            smc_addr9;      // External9 Memory (EMI9) address
  output [31:0]            smc_data9;      // EMI9 write data
  input  [31:0]            data_smc9;      // EMI9 read data
  output [3:0]             smc_n_be9;      // EMI9 byte enables9 (Active9 LOW9)
  output                   smc_n_cs9;      // EMI9 Chip9 Selects9 (Active9 LOW9)
  output [3:0]             smc_n_we9;      // EMI9 write strobes9 (Active9 LOW9)
  output                   smc_n_wr9;      // EMI9 write enable (Active9 LOW9)
  output                   smc_n_rd9;      // EMI9 read stobe9 (Active9 LOW9)
  output 	           smc_n_ext_oe9;  // EMI9 write data output enable

//AHB9 Memory Interface9 Control9

   output                   smc_busy9;      // smc9 busy



//scan9 signals9

   input                  scan_in_19;        //scan9 input
   input                  scan_in_29;        //scan9 input
   input                  scan_en9;         //scan9 enable
   output                 scan_out_19;       //scan9 output
   output                 scan_out_29;       //scan9 output
// third9 scan9 chain9 only used on INCLUDE_APB9
   input                  scan_in_39;        //scan9 input
   output                 scan_out_39;       //scan9 output

smc_lite9 i_smc_lite9(
   //inputs9
   //apb9 inputs9
   .n_preset9(n_preset9),
   .pclk9(pclk9),
   .psel9(psel9),
   .penable9(penable9),
   .pwrite9(pwrite9),
   .paddr9(paddr9),
   .pwdata9(pwdata9),
   //ahb9 inputs9
   .hclk9(hclk9),
   .n_sys_reset9(n_sys_reset9),
   .haddr9(haddr9),
   .htrans9(htrans9),
   .hsel9(hsel9),
   .hwrite9(hwrite9),
   .hsize9(hsize9),
   .hwdata9(hwdata9),
   .hready9(hready9),
   .data_smc9(data_smc9),


         //test signal9 inputs9

   .scan_in_19(),
   .scan_in_29(),
   .scan_in_39(),
   .scan_en9(scan_en9),

   //apb9 outputs9
   .prdata9(prdata9),

   //design output

   .smc_hrdata9(smc_hrdata9),
   .smc_hready9(smc_hready9),
   .smc_hresp9(smc_hresp9),
   .smc_valid9(smc_valid9),
   .smc_addr9(smc_addr9),
   .smc_data9(smc_data9),
   .smc_n_be9(smc_n_be9),
   .smc_n_cs9(smc_n_cs9),
   .smc_n_wr9(smc_n_wr9),
   .smc_n_we9(smc_n_we9),
   .smc_n_rd9(smc_n_rd9),
   .smc_n_ext_oe9(smc_n_ext_oe9),
   .smc_busy9(smc_busy9),

   //test signal9 output
   .scan_out_19(),
   .scan_out_29(),
   .scan_out_39()
);



//------------------------------------------------------------------------------
// AHB9 formal9 verification9 monitor9
//------------------------------------------------------------------------------
  `ifdef SMC_ABV_ON9

// psl9 assume_hready_in9 : assume always (hready9 == smc_hready9) @(posedge hclk9);

    ahb_liteslave_monitor9 i_ahbSlaveMonitor9 (
        .hclk_i9(hclk9),
        .hresetn_i9(n_preset9),
        .hresp9(smc_hresp9),
        .hready9(smc_hready9),
        .hready_global_i9(smc_hready9),
        .hrdata9(smc_hrdata9),
        .hwdata_i9(hwdata9),
        .hburst_i9(3'b0),
        .hsize_i9(hsize9),
        .hwrite_i9(hwrite9),
        .htrans_i9(htrans9),
        .haddr_i9(haddr9),
        .hsel_i9(|hsel9)
    );


  ahb_litemaster_monitor9 i_ahbMasterMonitor9 (
          .hclk_i9(hclk9),
          .hresetn_i9(n_preset9),
          .hresp_i9(smc_hresp9),
          .hready_i9(smc_hready9),
          .hrdata_i9(smc_hrdata9),
          .hlock9(1'b0),
          .hwdata9(hwdata9),
          .hprot9(4'b0),
          .hburst9(3'b0),
          .hsize9(hsize9),
          .hwrite9(hwrite9),
          .htrans9(htrans9),
          .haddr9(haddr9)
          );



  `endif



endmodule
