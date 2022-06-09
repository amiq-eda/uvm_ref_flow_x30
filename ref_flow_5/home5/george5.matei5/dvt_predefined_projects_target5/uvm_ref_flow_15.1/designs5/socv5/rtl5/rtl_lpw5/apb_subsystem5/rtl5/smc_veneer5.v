//File5 name   : smc_veneer5.v
//Title5       : 
//Created5     : 1999
//Description5 : 
//Notes5       : 
//----------------------------------------------------------------------
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------

 `include "smc_defs_lite5.v"

//static memory controller5
module smc_veneer5 (
                    //apb5 inputs5
                    n_preset5, 
                    pclk5, 
                    psel5, 
                    penable5, 
                    pwrite5, 
                    paddr5, 
                    pwdata5,
                    //ahb5 inputs5                    
                    hclk5,
                    n_sys_reset5,
                    haddr5,
                    htrans5,
                    hsel5,
                    hwrite5,
                    hsize5,
                    hwdata5,
                    hready5,
                    data_smc5,
                    
                    //test signal5 inputs5

                    scan_in_15,
                    scan_in_25,
                    scan_in_35,
                    scan_en5,

                    //apb5 outputs5                    
                    prdata5,

                    //design output
                    
                    smc_hrdata5, 
                    smc_hready5,
                    smc_valid5,
                    smc_hresp5,
                    smc_addr5,
                    smc_data5, 
                    smc_n_be5,
                    smc_n_cs5,
                    smc_n_wr5,                    
                    smc_n_we5,
                    smc_n_rd5,
                    smc_n_ext_oe5,
                    smc_busy5,

                    //test signal5 output

                    scan_out_15,
                    scan_out_25,
                    scan_out_35
                   );
// define parameters5
// change using defaparam5 statements5

  // APB5 Inputs5 (use is optional5 on INCLUDE_APB5)
  input        n_preset5;           // APBreset5 
  input        pclk5;               // APB5 clock5
  input        psel5;               // APB5 select5
  input        penable5;            // APB5 enable 
  input        pwrite5;             // APB5 write strobe5 
  input [4:0]  paddr5;              // APB5 address bus
  input [31:0] pwdata5;             // APB5 write data 

  // APB5 Output5 (use is optional5 on INCLUDE_APB5)

  output [31:0] prdata5;        //APB5 output


//System5 I5/O5

  input                    hclk5;          // AHB5 System5 clock5
  input                    n_sys_reset5;   // AHB5 System5 reset (Active5 LOW5)

//AHB5 I5/O5

  input  [31:0]            haddr5;         // AHB5 Address
  input  [1:0]             htrans5;        // AHB5 transfer5 type
  input                    hsel5;          // chip5 selects5
  input                    hwrite5;        // AHB5 read/write indication5
  input  [2:0]             hsize5;         // AHB5 transfer5 size
  input  [31:0]            hwdata5;        // AHB5 write data
  input                    hready5;        // AHB5 Muxed5 ready signal5

  
  output [31:0]            smc_hrdata5;    // smc5 read data back to AHB5 master5
  output                   smc_hready5;    // smc5 ready signal5
  output [1:0]             smc_hresp5;     // AHB5 Response5 signal5
  output                   smc_valid5;     // Ack5 valid address

//External5 memory interface (EMI5)

  output [31:0]            smc_addr5;      // External5 Memory (EMI5) address
  output [31:0]            smc_data5;      // EMI5 write data
  input  [31:0]            data_smc5;      // EMI5 read data
  output [3:0]             smc_n_be5;      // EMI5 byte enables5 (Active5 LOW5)
  output                   smc_n_cs5;      // EMI5 Chip5 Selects5 (Active5 LOW5)
  output [3:0]             smc_n_we5;      // EMI5 write strobes5 (Active5 LOW5)
  output                   smc_n_wr5;      // EMI5 write enable (Active5 LOW5)
  output                   smc_n_rd5;      // EMI5 read stobe5 (Active5 LOW5)
  output 	           smc_n_ext_oe5;  // EMI5 write data output enable

//AHB5 Memory Interface5 Control5

   output                   smc_busy5;      // smc5 busy



//scan5 signals5

   input                  scan_in_15;        //scan5 input
   input                  scan_in_25;        //scan5 input
   input                  scan_en5;         //scan5 enable
   output                 scan_out_15;       //scan5 output
   output                 scan_out_25;       //scan5 output
// third5 scan5 chain5 only used on INCLUDE_APB5
   input                  scan_in_35;        //scan5 input
   output                 scan_out_35;       //scan5 output

smc_lite5 i_smc_lite5(
   //inputs5
   //apb5 inputs5
   .n_preset5(n_preset5),
   .pclk5(pclk5),
   .psel5(psel5),
   .penable5(penable5),
   .pwrite5(pwrite5),
   .paddr5(paddr5),
   .pwdata5(pwdata5),
   //ahb5 inputs5
   .hclk5(hclk5),
   .n_sys_reset5(n_sys_reset5),
   .haddr5(haddr5),
   .htrans5(htrans5),
   .hsel5(hsel5),
   .hwrite5(hwrite5),
   .hsize5(hsize5),
   .hwdata5(hwdata5),
   .hready5(hready5),
   .data_smc5(data_smc5),


         //test signal5 inputs5

   .scan_in_15(),
   .scan_in_25(),
   .scan_in_35(),
   .scan_en5(scan_en5),

   //apb5 outputs5
   .prdata5(prdata5),

   //design output

   .smc_hrdata5(smc_hrdata5),
   .smc_hready5(smc_hready5),
   .smc_hresp5(smc_hresp5),
   .smc_valid5(smc_valid5),
   .smc_addr5(smc_addr5),
   .smc_data5(smc_data5),
   .smc_n_be5(smc_n_be5),
   .smc_n_cs5(smc_n_cs5),
   .smc_n_wr5(smc_n_wr5),
   .smc_n_we5(smc_n_we5),
   .smc_n_rd5(smc_n_rd5),
   .smc_n_ext_oe5(smc_n_ext_oe5),
   .smc_busy5(smc_busy5),

   //test signal5 output
   .scan_out_15(),
   .scan_out_25(),
   .scan_out_35()
);



//------------------------------------------------------------------------------
// AHB5 formal5 verification5 monitor5
//------------------------------------------------------------------------------
  `ifdef SMC_ABV_ON5

// psl5 assume_hready_in5 : assume always (hready5 == smc_hready5) @(posedge hclk5);

    ahb_liteslave_monitor5 i_ahbSlaveMonitor5 (
        .hclk_i5(hclk5),
        .hresetn_i5(n_preset5),
        .hresp5(smc_hresp5),
        .hready5(smc_hready5),
        .hready_global_i5(smc_hready5),
        .hrdata5(smc_hrdata5),
        .hwdata_i5(hwdata5),
        .hburst_i5(3'b0),
        .hsize_i5(hsize5),
        .hwrite_i5(hwrite5),
        .htrans_i5(htrans5),
        .haddr_i5(haddr5),
        .hsel_i5(|hsel5)
    );


  ahb_litemaster_monitor5 i_ahbMasterMonitor5 (
          .hclk_i5(hclk5),
          .hresetn_i5(n_preset5),
          .hresp_i5(smc_hresp5),
          .hready_i5(smc_hready5),
          .hrdata_i5(smc_hrdata5),
          .hlock5(1'b0),
          .hwdata5(hwdata5),
          .hprot5(4'b0),
          .hburst5(3'b0),
          .hsize5(hsize5),
          .hwrite5(hwrite5),
          .htrans5(htrans5),
          .haddr5(haddr5)
          );



  `endif



endmodule
