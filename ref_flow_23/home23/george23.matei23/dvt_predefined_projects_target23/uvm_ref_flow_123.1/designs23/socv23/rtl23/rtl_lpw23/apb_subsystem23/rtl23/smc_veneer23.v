//File23 name   : smc_veneer23.v
//Title23       : 
//Created23     : 1999
//Description23 : 
//Notes23       : 
//----------------------------------------------------------------------
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------

 `include "smc_defs_lite23.v"

//static memory controller23
module smc_veneer23 (
                    //apb23 inputs23
                    n_preset23, 
                    pclk23, 
                    psel23, 
                    penable23, 
                    pwrite23, 
                    paddr23, 
                    pwdata23,
                    //ahb23 inputs23                    
                    hclk23,
                    n_sys_reset23,
                    haddr23,
                    htrans23,
                    hsel23,
                    hwrite23,
                    hsize23,
                    hwdata23,
                    hready23,
                    data_smc23,
                    
                    //test signal23 inputs23

                    scan_in_123,
                    scan_in_223,
                    scan_in_323,
                    scan_en23,

                    //apb23 outputs23                    
                    prdata23,

                    //design output
                    
                    smc_hrdata23, 
                    smc_hready23,
                    smc_valid23,
                    smc_hresp23,
                    smc_addr23,
                    smc_data23, 
                    smc_n_be23,
                    smc_n_cs23,
                    smc_n_wr23,                    
                    smc_n_we23,
                    smc_n_rd23,
                    smc_n_ext_oe23,
                    smc_busy23,

                    //test signal23 output

                    scan_out_123,
                    scan_out_223,
                    scan_out_323
                   );
// define parameters23
// change using defaparam23 statements23

  // APB23 Inputs23 (use is optional23 on INCLUDE_APB23)
  input        n_preset23;           // APBreset23 
  input        pclk23;               // APB23 clock23
  input        psel23;               // APB23 select23
  input        penable23;            // APB23 enable 
  input        pwrite23;             // APB23 write strobe23 
  input [4:0]  paddr23;              // APB23 address bus
  input [31:0] pwdata23;             // APB23 write data 

  // APB23 Output23 (use is optional23 on INCLUDE_APB23)

  output [31:0] prdata23;        //APB23 output


//System23 I23/O23

  input                    hclk23;          // AHB23 System23 clock23
  input                    n_sys_reset23;   // AHB23 System23 reset (Active23 LOW23)

//AHB23 I23/O23

  input  [31:0]            haddr23;         // AHB23 Address
  input  [1:0]             htrans23;        // AHB23 transfer23 type
  input                    hsel23;          // chip23 selects23
  input                    hwrite23;        // AHB23 read/write indication23
  input  [2:0]             hsize23;         // AHB23 transfer23 size
  input  [31:0]            hwdata23;        // AHB23 write data
  input                    hready23;        // AHB23 Muxed23 ready signal23

  
  output [31:0]            smc_hrdata23;    // smc23 read data back to AHB23 master23
  output                   smc_hready23;    // smc23 ready signal23
  output [1:0]             smc_hresp23;     // AHB23 Response23 signal23
  output                   smc_valid23;     // Ack23 valid address

//External23 memory interface (EMI23)

  output [31:0]            smc_addr23;      // External23 Memory (EMI23) address
  output [31:0]            smc_data23;      // EMI23 write data
  input  [31:0]            data_smc23;      // EMI23 read data
  output [3:0]             smc_n_be23;      // EMI23 byte enables23 (Active23 LOW23)
  output                   smc_n_cs23;      // EMI23 Chip23 Selects23 (Active23 LOW23)
  output [3:0]             smc_n_we23;      // EMI23 write strobes23 (Active23 LOW23)
  output                   smc_n_wr23;      // EMI23 write enable (Active23 LOW23)
  output                   smc_n_rd23;      // EMI23 read stobe23 (Active23 LOW23)
  output 	           smc_n_ext_oe23;  // EMI23 write data output enable

//AHB23 Memory Interface23 Control23

   output                   smc_busy23;      // smc23 busy



//scan23 signals23

   input                  scan_in_123;        //scan23 input
   input                  scan_in_223;        //scan23 input
   input                  scan_en23;         //scan23 enable
   output                 scan_out_123;       //scan23 output
   output                 scan_out_223;       //scan23 output
// third23 scan23 chain23 only used on INCLUDE_APB23
   input                  scan_in_323;        //scan23 input
   output                 scan_out_323;       //scan23 output

smc_lite23 i_smc_lite23(
   //inputs23
   //apb23 inputs23
   .n_preset23(n_preset23),
   .pclk23(pclk23),
   .psel23(psel23),
   .penable23(penable23),
   .pwrite23(pwrite23),
   .paddr23(paddr23),
   .pwdata23(pwdata23),
   //ahb23 inputs23
   .hclk23(hclk23),
   .n_sys_reset23(n_sys_reset23),
   .haddr23(haddr23),
   .htrans23(htrans23),
   .hsel23(hsel23),
   .hwrite23(hwrite23),
   .hsize23(hsize23),
   .hwdata23(hwdata23),
   .hready23(hready23),
   .data_smc23(data_smc23),


         //test signal23 inputs23

   .scan_in_123(),
   .scan_in_223(),
   .scan_in_323(),
   .scan_en23(scan_en23),

   //apb23 outputs23
   .prdata23(prdata23),

   //design output

   .smc_hrdata23(smc_hrdata23),
   .smc_hready23(smc_hready23),
   .smc_hresp23(smc_hresp23),
   .smc_valid23(smc_valid23),
   .smc_addr23(smc_addr23),
   .smc_data23(smc_data23),
   .smc_n_be23(smc_n_be23),
   .smc_n_cs23(smc_n_cs23),
   .smc_n_wr23(smc_n_wr23),
   .smc_n_we23(smc_n_we23),
   .smc_n_rd23(smc_n_rd23),
   .smc_n_ext_oe23(smc_n_ext_oe23),
   .smc_busy23(smc_busy23),

   //test signal23 output
   .scan_out_123(),
   .scan_out_223(),
   .scan_out_323()
);



//------------------------------------------------------------------------------
// AHB23 formal23 verification23 monitor23
//------------------------------------------------------------------------------
  `ifdef SMC_ABV_ON23

// psl23 assume_hready_in23 : assume always (hready23 == smc_hready23) @(posedge hclk23);

    ahb_liteslave_monitor23 i_ahbSlaveMonitor23 (
        .hclk_i23(hclk23),
        .hresetn_i23(n_preset23),
        .hresp23(smc_hresp23),
        .hready23(smc_hready23),
        .hready_global_i23(smc_hready23),
        .hrdata23(smc_hrdata23),
        .hwdata_i23(hwdata23),
        .hburst_i23(3'b0),
        .hsize_i23(hsize23),
        .hwrite_i23(hwrite23),
        .htrans_i23(htrans23),
        .haddr_i23(haddr23),
        .hsel_i23(|hsel23)
    );


  ahb_litemaster_monitor23 i_ahbMasterMonitor23 (
          .hclk_i23(hclk23),
          .hresetn_i23(n_preset23),
          .hresp_i23(smc_hresp23),
          .hready_i23(smc_hready23),
          .hrdata_i23(smc_hrdata23),
          .hlock23(1'b0),
          .hwdata23(hwdata23),
          .hprot23(4'b0),
          .hburst23(3'b0),
          .hsize23(hsize23),
          .hwrite23(hwrite23),
          .htrans23(htrans23),
          .haddr23(haddr23)
          );



  `endif



endmodule
