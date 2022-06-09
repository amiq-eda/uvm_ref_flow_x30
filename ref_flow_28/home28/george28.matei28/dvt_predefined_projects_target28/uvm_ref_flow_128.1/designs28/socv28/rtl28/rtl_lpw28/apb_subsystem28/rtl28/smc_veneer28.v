//File28 name   : smc_veneer28.v
//Title28       : 
//Created28     : 1999
//Description28 : 
//Notes28       : 
//----------------------------------------------------------------------
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------

 `include "smc_defs_lite28.v"

//static memory controller28
module smc_veneer28 (
                    //apb28 inputs28
                    n_preset28, 
                    pclk28, 
                    psel28, 
                    penable28, 
                    pwrite28, 
                    paddr28, 
                    pwdata28,
                    //ahb28 inputs28                    
                    hclk28,
                    n_sys_reset28,
                    haddr28,
                    htrans28,
                    hsel28,
                    hwrite28,
                    hsize28,
                    hwdata28,
                    hready28,
                    data_smc28,
                    
                    //test signal28 inputs28

                    scan_in_128,
                    scan_in_228,
                    scan_in_328,
                    scan_en28,

                    //apb28 outputs28                    
                    prdata28,

                    //design output
                    
                    smc_hrdata28, 
                    smc_hready28,
                    smc_valid28,
                    smc_hresp28,
                    smc_addr28,
                    smc_data28, 
                    smc_n_be28,
                    smc_n_cs28,
                    smc_n_wr28,                    
                    smc_n_we28,
                    smc_n_rd28,
                    smc_n_ext_oe28,
                    smc_busy28,

                    //test signal28 output

                    scan_out_128,
                    scan_out_228,
                    scan_out_328
                   );
// define parameters28
// change using defaparam28 statements28

  // APB28 Inputs28 (use is optional28 on INCLUDE_APB28)
  input        n_preset28;           // APBreset28 
  input        pclk28;               // APB28 clock28
  input        psel28;               // APB28 select28
  input        penable28;            // APB28 enable 
  input        pwrite28;             // APB28 write strobe28 
  input [4:0]  paddr28;              // APB28 address bus
  input [31:0] pwdata28;             // APB28 write data 

  // APB28 Output28 (use is optional28 on INCLUDE_APB28)

  output [31:0] prdata28;        //APB28 output


//System28 I28/O28

  input                    hclk28;          // AHB28 System28 clock28
  input                    n_sys_reset28;   // AHB28 System28 reset (Active28 LOW28)

//AHB28 I28/O28

  input  [31:0]            haddr28;         // AHB28 Address
  input  [1:0]             htrans28;        // AHB28 transfer28 type
  input                    hsel28;          // chip28 selects28
  input                    hwrite28;        // AHB28 read/write indication28
  input  [2:0]             hsize28;         // AHB28 transfer28 size
  input  [31:0]            hwdata28;        // AHB28 write data
  input                    hready28;        // AHB28 Muxed28 ready signal28

  
  output [31:0]            smc_hrdata28;    // smc28 read data back to AHB28 master28
  output                   smc_hready28;    // smc28 ready signal28
  output [1:0]             smc_hresp28;     // AHB28 Response28 signal28
  output                   smc_valid28;     // Ack28 valid address

//External28 memory interface (EMI28)

  output [31:0]            smc_addr28;      // External28 Memory (EMI28) address
  output [31:0]            smc_data28;      // EMI28 write data
  input  [31:0]            data_smc28;      // EMI28 read data
  output [3:0]             smc_n_be28;      // EMI28 byte enables28 (Active28 LOW28)
  output                   smc_n_cs28;      // EMI28 Chip28 Selects28 (Active28 LOW28)
  output [3:0]             smc_n_we28;      // EMI28 write strobes28 (Active28 LOW28)
  output                   smc_n_wr28;      // EMI28 write enable (Active28 LOW28)
  output                   smc_n_rd28;      // EMI28 read stobe28 (Active28 LOW28)
  output 	           smc_n_ext_oe28;  // EMI28 write data output enable

//AHB28 Memory Interface28 Control28

   output                   smc_busy28;      // smc28 busy



//scan28 signals28

   input                  scan_in_128;        //scan28 input
   input                  scan_in_228;        //scan28 input
   input                  scan_en28;         //scan28 enable
   output                 scan_out_128;       //scan28 output
   output                 scan_out_228;       //scan28 output
// third28 scan28 chain28 only used on INCLUDE_APB28
   input                  scan_in_328;        //scan28 input
   output                 scan_out_328;       //scan28 output

smc_lite28 i_smc_lite28(
   //inputs28
   //apb28 inputs28
   .n_preset28(n_preset28),
   .pclk28(pclk28),
   .psel28(psel28),
   .penable28(penable28),
   .pwrite28(pwrite28),
   .paddr28(paddr28),
   .pwdata28(pwdata28),
   //ahb28 inputs28
   .hclk28(hclk28),
   .n_sys_reset28(n_sys_reset28),
   .haddr28(haddr28),
   .htrans28(htrans28),
   .hsel28(hsel28),
   .hwrite28(hwrite28),
   .hsize28(hsize28),
   .hwdata28(hwdata28),
   .hready28(hready28),
   .data_smc28(data_smc28),


         //test signal28 inputs28

   .scan_in_128(),
   .scan_in_228(),
   .scan_in_328(),
   .scan_en28(scan_en28),

   //apb28 outputs28
   .prdata28(prdata28),

   //design output

   .smc_hrdata28(smc_hrdata28),
   .smc_hready28(smc_hready28),
   .smc_hresp28(smc_hresp28),
   .smc_valid28(smc_valid28),
   .smc_addr28(smc_addr28),
   .smc_data28(smc_data28),
   .smc_n_be28(smc_n_be28),
   .smc_n_cs28(smc_n_cs28),
   .smc_n_wr28(smc_n_wr28),
   .smc_n_we28(smc_n_we28),
   .smc_n_rd28(smc_n_rd28),
   .smc_n_ext_oe28(smc_n_ext_oe28),
   .smc_busy28(smc_busy28),

   //test signal28 output
   .scan_out_128(),
   .scan_out_228(),
   .scan_out_328()
);



//------------------------------------------------------------------------------
// AHB28 formal28 verification28 monitor28
//------------------------------------------------------------------------------
  `ifdef SMC_ABV_ON28

// psl28 assume_hready_in28 : assume always (hready28 == smc_hready28) @(posedge hclk28);

    ahb_liteslave_monitor28 i_ahbSlaveMonitor28 (
        .hclk_i28(hclk28),
        .hresetn_i28(n_preset28),
        .hresp28(smc_hresp28),
        .hready28(smc_hready28),
        .hready_global_i28(smc_hready28),
        .hrdata28(smc_hrdata28),
        .hwdata_i28(hwdata28),
        .hburst_i28(3'b0),
        .hsize_i28(hsize28),
        .hwrite_i28(hwrite28),
        .htrans_i28(htrans28),
        .haddr_i28(haddr28),
        .hsel_i28(|hsel28)
    );


  ahb_litemaster_monitor28 i_ahbMasterMonitor28 (
          .hclk_i28(hclk28),
          .hresetn_i28(n_preset28),
          .hresp_i28(smc_hresp28),
          .hready_i28(smc_hready28),
          .hrdata_i28(smc_hrdata28),
          .hlock28(1'b0),
          .hwdata28(hwdata28),
          .hprot28(4'b0),
          .hburst28(3'b0),
          .hsize28(hsize28),
          .hwrite28(hwrite28),
          .htrans28(htrans28),
          .haddr28(haddr28)
          );



  `endif



endmodule
