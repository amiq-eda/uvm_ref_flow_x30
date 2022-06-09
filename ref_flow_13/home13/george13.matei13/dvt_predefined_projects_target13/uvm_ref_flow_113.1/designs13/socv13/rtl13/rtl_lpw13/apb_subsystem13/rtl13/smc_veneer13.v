//File13 name   : smc_veneer13.v
//Title13       : 
//Created13     : 1999
//Description13 : 
//Notes13       : 
//----------------------------------------------------------------------
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------

 `include "smc_defs_lite13.v"

//static memory controller13
module smc_veneer13 (
                    //apb13 inputs13
                    n_preset13, 
                    pclk13, 
                    psel13, 
                    penable13, 
                    pwrite13, 
                    paddr13, 
                    pwdata13,
                    //ahb13 inputs13                    
                    hclk13,
                    n_sys_reset13,
                    haddr13,
                    htrans13,
                    hsel13,
                    hwrite13,
                    hsize13,
                    hwdata13,
                    hready13,
                    data_smc13,
                    
                    //test signal13 inputs13

                    scan_in_113,
                    scan_in_213,
                    scan_in_313,
                    scan_en13,

                    //apb13 outputs13                    
                    prdata13,

                    //design output
                    
                    smc_hrdata13, 
                    smc_hready13,
                    smc_valid13,
                    smc_hresp13,
                    smc_addr13,
                    smc_data13, 
                    smc_n_be13,
                    smc_n_cs13,
                    smc_n_wr13,                    
                    smc_n_we13,
                    smc_n_rd13,
                    smc_n_ext_oe13,
                    smc_busy13,

                    //test signal13 output

                    scan_out_113,
                    scan_out_213,
                    scan_out_313
                   );
// define parameters13
// change using defaparam13 statements13

  // APB13 Inputs13 (use is optional13 on INCLUDE_APB13)
  input        n_preset13;           // APBreset13 
  input        pclk13;               // APB13 clock13
  input        psel13;               // APB13 select13
  input        penable13;            // APB13 enable 
  input        pwrite13;             // APB13 write strobe13 
  input [4:0]  paddr13;              // APB13 address bus
  input [31:0] pwdata13;             // APB13 write data 

  // APB13 Output13 (use is optional13 on INCLUDE_APB13)

  output [31:0] prdata13;        //APB13 output


//System13 I13/O13

  input                    hclk13;          // AHB13 System13 clock13
  input                    n_sys_reset13;   // AHB13 System13 reset (Active13 LOW13)

//AHB13 I13/O13

  input  [31:0]            haddr13;         // AHB13 Address
  input  [1:0]             htrans13;        // AHB13 transfer13 type
  input                    hsel13;          // chip13 selects13
  input                    hwrite13;        // AHB13 read/write indication13
  input  [2:0]             hsize13;         // AHB13 transfer13 size
  input  [31:0]            hwdata13;        // AHB13 write data
  input                    hready13;        // AHB13 Muxed13 ready signal13

  
  output [31:0]            smc_hrdata13;    // smc13 read data back to AHB13 master13
  output                   smc_hready13;    // smc13 ready signal13
  output [1:0]             smc_hresp13;     // AHB13 Response13 signal13
  output                   smc_valid13;     // Ack13 valid address

//External13 memory interface (EMI13)

  output [31:0]            smc_addr13;      // External13 Memory (EMI13) address
  output [31:0]            smc_data13;      // EMI13 write data
  input  [31:0]            data_smc13;      // EMI13 read data
  output [3:0]             smc_n_be13;      // EMI13 byte enables13 (Active13 LOW13)
  output                   smc_n_cs13;      // EMI13 Chip13 Selects13 (Active13 LOW13)
  output [3:0]             smc_n_we13;      // EMI13 write strobes13 (Active13 LOW13)
  output                   smc_n_wr13;      // EMI13 write enable (Active13 LOW13)
  output                   smc_n_rd13;      // EMI13 read stobe13 (Active13 LOW13)
  output 	           smc_n_ext_oe13;  // EMI13 write data output enable

//AHB13 Memory Interface13 Control13

   output                   smc_busy13;      // smc13 busy



//scan13 signals13

   input                  scan_in_113;        //scan13 input
   input                  scan_in_213;        //scan13 input
   input                  scan_en13;         //scan13 enable
   output                 scan_out_113;       //scan13 output
   output                 scan_out_213;       //scan13 output
// third13 scan13 chain13 only used on INCLUDE_APB13
   input                  scan_in_313;        //scan13 input
   output                 scan_out_313;       //scan13 output

smc_lite13 i_smc_lite13(
   //inputs13
   //apb13 inputs13
   .n_preset13(n_preset13),
   .pclk13(pclk13),
   .psel13(psel13),
   .penable13(penable13),
   .pwrite13(pwrite13),
   .paddr13(paddr13),
   .pwdata13(pwdata13),
   //ahb13 inputs13
   .hclk13(hclk13),
   .n_sys_reset13(n_sys_reset13),
   .haddr13(haddr13),
   .htrans13(htrans13),
   .hsel13(hsel13),
   .hwrite13(hwrite13),
   .hsize13(hsize13),
   .hwdata13(hwdata13),
   .hready13(hready13),
   .data_smc13(data_smc13),


         //test signal13 inputs13

   .scan_in_113(),
   .scan_in_213(),
   .scan_in_313(),
   .scan_en13(scan_en13),

   //apb13 outputs13
   .prdata13(prdata13),

   //design output

   .smc_hrdata13(smc_hrdata13),
   .smc_hready13(smc_hready13),
   .smc_hresp13(smc_hresp13),
   .smc_valid13(smc_valid13),
   .smc_addr13(smc_addr13),
   .smc_data13(smc_data13),
   .smc_n_be13(smc_n_be13),
   .smc_n_cs13(smc_n_cs13),
   .smc_n_wr13(smc_n_wr13),
   .smc_n_we13(smc_n_we13),
   .smc_n_rd13(smc_n_rd13),
   .smc_n_ext_oe13(smc_n_ext_oe13),
   .smc_busy13(smc_busy13),

   //test signal13 output
   .scan_out_113(),
   .scan_out_213(),
   .scan_out_313()
);



//------------------------------------------------------------------------------
// AHB13 formal13 verification13 monitor13
//------------------------------------------------------------------------------
  `ifdef SMC_ABV_ON13

// psl13 assume_hready_in13 : assume always (hready13 == smc_hready13) @(posedge hclk13);

    ahb_liteslave_monitor13 i_ahbSlaveMonitor13 (
        .hclk_i13(hclk13),
        .hresetn_i13(n_preset13),
        .hresp13(smc_hresp13),
        .hready13(smc_hready13),
        .hready_global_i13(smc_hready13),
        .hrdata13(smc_hrdata13),
        .hwdata_i13(hwdata13),
        .hburst_i13(3'b0),
        .hsize_i13(hsize13),
        .hwrite_i13(hwrite13),
        .htrans_i13(htrans13),
        .haddr_i13(haddr13),
        .hsel_i13(|hsel13)
    );


  ahb_litemaster_monitor13 i_ahbMasterMonitor13 (
          .hclk_i13(hclk13),
          .hresetn_i13(n_preset13),
          .hresp_i13(smc_hresp13),
          .hready_i13(smc_hready13),
          .hrdata_i13(smc_hrdata13),
          .hlock13(1'b0),
          .hwdata13(hwdata13),
          .hprot13(4'b0),
          .hburst13(3'b0),
          .hsize13(hsize13),
          .hwrite13(hwrite13),
          .htrans13(htrans13),
          .haddr13(haddr13)
          );



  `endif



endmodule
