//File6 name   : smc_veneer6.v
//Title6       : 
//Created6     : 1999
//Description6 : 
//Notes6       : 
//----------------------------------------------------------------------
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------

 `include "smc_defs_lite6.v"

//static memory controller6
module smc_veneer6 (
                    //apb6 inputs6
                    n_preset6, 
                    pclk6, 
                    psel6, 
                    penable6, 
                    pwrite6, 
                    paddr6, 
                    pwdata6,
                    //ahb6 inputs6                    
                    hclk6,
                    n_sys_reset6,
                    haddr6,
                    htrans6,
                    hsel6,
                    hwrite6,
                    hsize6,
                    hwdata6,
                    hready6,
                    data_smc6,
                    
                    //test signal6 inputs6

                    scan_in_16,
                    scan_in_26,
                    scan_in_36,
                    scan_en6,

                    //apb6 outputs6                    
                    prdata6,

                    //design output
                    
                    smc_hrdata6, 
                    smc_hready6,
                    smc_valid6,
                    smc_hresp6,
                    smc_addr6,
                    smc_data6, 
                    smc_n_be6,
                    smc_n_cs6,
                    smc_n_wr6,                    
                    smc_n_we6,
                    smc_n_rd6,
                    smc_n_ext_oe6,
                    smc_busy6,

                    //test signal6 output

                    scan_out_16,
                    scan_out_26,
                    scan_out_36
                   );
// define parameters6
// change using defaparam6 statements6

  // APB6 Inputs6 (use is optional6 on INCLUDE_APB6)
  input        n_preset6;           // APBreset6 
  input        pclk6;               // APB6 clock6
  input        psel6;               // APB6 select6
  input        penable6;            // APB6 enable 
  input        pwrite6;             // APB6 write strobe6 
  input [4:0]  paddr6;              // APB6 address bus
  input [31:0] pwdata6;             // APB6 write data 

  // APB6 Output6 (use is optional6 on INCLUDE_APB6)

  output [31:0] prdata6;        //APB6 output


//System6 I6/O6

  input                    hclk6;          // AHB6 System6 clock6
  input                    n_sys_reset6;   // AHB6 System6 reset (Active6 LOW6)

//AHB6 I6/O6

  input  [31:0]            haddr6;         // AHB6 Address
  input  [1:0]             htrans6;        // AHB6 transfer6 type
  input                    hsel6;          // chip6 selects6
  input                    hwrite6;        // AHB6 read/write indication6
  input  [2:0]             hsize6;         // AHB6 transfer6 size
  input  [31:0]            hwdata6;        // AHB6 write data
  input                    hready6;        // AHB6 Muxed6 ready signal6

  
  output [31:0]            smc_hrdata6;    // smc6 read data back to AHB6 master6
  output                   smc_hready6;    // smc6 ready signal6
  output [1:0]             smc_hresp6;     // AHB6 Response6 signal6
  output                   smc_valid6;     // Ack6 valid address

//External6 memory interface (EMI6)

  output [31:0]            smc_addr6;      // External6 Memory (EMI6) address
  output [31:0]            smc_data6;      // EMI6 write data
  input  [31:0]            data_smc6;      // EMI6 read data
  output [3:0]             smc_n_be6;      // EMI6 byte enables6 (Active6 LOW6)
  output                   smc_n_cs6;      // EMI6 Chip6 Selects6 (Active6 LOW6)
  output [3:0]             smc_n_we6;      // EMI6 write strobes6 (Active6 LOW6)
  output                   smc_n_wr6;      // EMI6 write enable (Active6 LOW6)
  output                   smc_n_rd6;      // EMI6 read stobe6 (Active6 LOW6)
  output 	           smc_n_ext_oe6;  // EMI6 write data output enable

//AHB6 Memory Interface6 Control6

   output                   smc_busy6;      // smc6 busy



//scan6 signals6

   input                  scan_in_16;        //scan6 input
   input                  scan_in_26;        //scan6 input
   input                  scan_en6;         //scan6 enable
   output                 scan_out_16;       //scan6 output
   output                 scan_out_26;       //scan6 output
// third6 scan6 chain6 only used on INCLUDE_APB6
   input                  scan_in_36;        //scan6 input
   output                 scan_out_36;       //scan6 output

smc_lite6 i_smc_lite6(
   //inputs6
   //apb6 inputs6
   .n_preset6(n_preset6),
   .pclk6(pclk6),
   .psel6(psel6),
   .penable6(penable6),
   .pwrite6(pwrite6),
   .paddr6(paddr6),
   .pwdata6(pwdata6),
   //ahb6 inputs6
   .hclk6(hclk6),
   .n_sys_reset6(n_sys_reset6),
   .haddr6(haddr6),
   .htrans6(htrans6),
   .hsel6(hsel6),
   .hwrite6(hwrite6),
   .hsize6(hsize6),
   .hwdata6(hwdata6),
   .hready6(hready6),
   .data_smc6(data_smc6),


         //test signal6 inputs6

   .scan_in_16(),
   .scan_in_26(),
   .scan_in_36(),
   .scan_en6(scan_en6),

   //apb6 outputs6
   .prdata6(prdata6),

   //design output

   .smc_hrdata6(smc_hrdata6),
   .smc_hready6(smc_hready6),
   .smc_hresp6(smc_hresp6),
   .smc_valid6(smc_valid6),
   .smc_addr6(smc_addr6),
   .smc_data6(smc_data6),
   .smc_n_be6(smc_n_be6),
   .smc_n_cs6(smc_n_cs6),
   .smc_n_wr6(smc_n_wr6),
   .smc_n_we6(smc_n_we6),
   .smc_n_rd6(smc_n_rd6),
   .smc_n_ext_oe6(smc_n_ext_oe6),
   .smc_busy6(smc_busy6),

   //test signal6 output
   .scan_out_16(),
   .scan_out_26(),
   .scan_out_36()
);



//------------------------------------------------------------------------------
// AHB6 formal6 verification6 monitor6
//------------------------------------------------------------------------------
  `ifdef SMC_ABV_ON6

// psl6 assume_hready_in6 : assume always (hready6 == smc_hready6) @(posedge hclk6);

    ahb_liteslave_monitor6 i_ahbSlaveMonitor6 (
        .hclk_i6(hclk6),
        .hresetn_i6(n_preset6),
        .hresp6(smc_hresp6),
        .hready6(smc_hready6),
        .hready_global_i6(smc_hready6),
        .hrdata6(smc_hrdata6),
        .hwdata_i6(hwdata6),
        .hburst_i6(3'b0),
        .hsize_i6(hsize6),
        .hwrite_i6(hwrite6),
        .htrans_i6(htrans6),
        .haddr_i6(haddr6),
        .hsel_i6(|hsel6)
    );


  ahb_litemaster_monitor6 i_ahbMasterMonitor6 (
          .hclk_i6(hclk6),
          .hresetn_i6(n_preset6),
          .hresp_i6(smc_hresp6),
          .hready_i6(smc_hready6),
          .hrdata_i6(smc_hrdata6),
          .hlock6(1'b0),
          .hwdata6(hwdata6),
          .hprot6(4'b0),
          .hburst6(3'b0),
          .hsize6(hsize6),
          .hwrite6(hwrite6),
          .htrans6(htrans6),
          .haddr6(haddr6)
          );



  `endif



endmodule
