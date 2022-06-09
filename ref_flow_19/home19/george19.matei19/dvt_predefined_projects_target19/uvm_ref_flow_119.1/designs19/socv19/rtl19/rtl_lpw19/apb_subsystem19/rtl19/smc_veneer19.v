//File19 name   : smc_veneer19.v
//Title19       : 
//Created19     : 1999
//Description19 : 
//Notes19       : 
//----------------------------------------------------------------------
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------

 `include "smc_defs_lite19.v"

//static memory controller19
module smc_veneer19 (
                    //apb19 inputs19
                    n_preset19, 
                    pclk19, 
                    psel19, 
                    penable19, 
                    pwrite19, 
                    paddr19, 
                    pwdata19,
                    //ahb19 inputs19                    
                    hclk19,
                    n_sys_reset19,
                    haddr19,
                    htrans19,
                    hsel19,
                    hwrite19,
                    hsize19,
                    hwdata19,
                    hready19,
                    data_smc19,
                    
                    //test signal19 inputs19

                    scan_in_119,
                    scan_in_219,
                    scan_in_319,
                    scan_en19,

                    //apb19 outputs19                    
                    prdata19,

                    //design output
                    
                    smc_hrdata19, 
                    smc_hready19,
                    smc_valid19,
                    smc_hresp19,
                    smc_addr19,
                    smc_data19, 
                    smc_n_be19,
                    smc_n_cs19,
                    smc_n_wr19,                    
                    smc_n_we19,
                    smc_n_rd19,
                    smc_n_ext_oe19,
                    smc_busy19,

                    //test signal19 output

                    scan_out_119,
                    scan_out_219,
                    scan_out_319
                   );
// define parameters19
// change using defaparam19 statements19

  // APB19 Inputs19 (use is optional19 on INCLUDE_APB19)
  input        n_preset19;           // APBreset19 
  input        pclk19;               // APB19 clock19
  input        psel19;               // APB19 select19
  input        penable19;            // APB19 enable 
  input        pwrite19;             // APB19 write strobe19 
  input [4:0]  paddr19;              // APB19 address bus
  input [31:0] pwdata19;             // APB19 write data 

  // APB19 Output19 (use is optional19 on INCLUDE_APB19)

  output [31:0] prdata19;        //APB19 output


//System19 I19/O19

  input                    hclk19;          // AHB19 System19 clock19
  input                    n_sys_reset19;   // AHB19 System19 reset (Active19 LOW19)

//AHB19 I19/O19

  input  [31:0]            haddr19;         // AHB19 Address
  input  [1:0]             htrans19;        // AHB19 transfer19 type
  input                    hsel19;          // chip19 selects19
  input                    hwrite19;        // AHB19 read/write indication19
  input  [2:0]             hsize19;         // AHB19 transfer19 size
  input  [31:0]            hwdata19;        // AHB19 write data
  input                    hready19;        // AHB19 Muxed19 ready signal19

  
  output [31:0]            smc_hrdata19;    // smc19 read data back to AHB19 master19
  output                   smc_hready19;    // smc19 ready signal19
  output [1:0]             smc_hresp19;     // AHB19 Response19 signal19
  output                   smc_valid19;     // Ack19 valid address

//External19 memory interface (EMI19)

  output [31:0]            smc_addr19;      // External19 Memory (EMI19) address
  output [31:0]            smc_data19;      // EMI19 write data
  input  [31:0]            data_smc19;      // EMI19 read data
  output [3:0]             smc_n_be19;      // EMI19 byte enables19 (Active19 LOW19)
  output                   smc_n_cs19;      // EMI19 Chip19 Selects19 (Active19 LOW19)
  output [3:0]             smc_n_we19;      // EMI19 write strobes19 (Active19 LOW19)
  output                   smc_n_wr19;      // EMI19 write enable (Active19 LOW19)
  output                   smc_n_rd19;      // EMI19 read stobe19 (Active19 LOW19)
  output 	           smc_n_ext_oe19;  // EMI19 write data output enable

//AHB19 Memory Interface19 Control19

   output                   smc_busy19;      // smc19 busy



//scan19 signals19

   input                  scan_in_119;        //scan19 input
   input                  scan_in_219;        //scan19 input
   input                  scan_en19;         //scan19 enable
   output                 scan_out_119;       //scan19 output
   output                 scan_out_219;       //scan19 output
// third19 scan19 chain19 only used on INCLUDE_APB19
   input                  scan_in_319;        //scan19 input
   output                 scan_out_319;       //scan19 output

smc_lite19 i_smc_lite19(
   //inputs19
   //apb19 inputs19
   .n_preset19(n_preset19),
   .pclk19(pclk19),
   .psel19(psel19),
   .penable19(penable19),
   .pwrite19(pwrite19),
   .paddr19(paddr19),
   .pwdata19(pwdata19),
   //ahb19 inputs19
   .hclk19(hclk19),
   .n_sys_reset19(n_sys_reset19),
   .haddr19(haddr19),
   .htrans19(htrans19),
   .hsel19(hsel19),
   .hwrite19(hwrite19),
   .hsize19(hsize19),
   .hwdata19(hwdata19),
   .hready19(hready19),
   .data_smc19(data_smc19),


         //test signal19 inputs19

   .scan_in_119(),
   .scan_in_219(),
   .scan_in_319(),
   .scan_en19(scan_en19),

   //apb19 outputs19
   .prdata19(prdata19),

   //design output

   .smc_hrdata19(smc_hrdata19),
   .smc_hready19(smc_hready19),
   .smc_hresp19(smc_hresp19),
   .smc_valid19(smc_valid19),
   .smc_addr19(smc_addr19),
   .smc_data19(smc_data19),
   .smc_n_be19(smc_n_be19),
   .smc_n_cs19(smc_n_cs19),
   .smc_n_wr19(smc_n_wr19),
   .smc_n_we19(smc_n_we19),
   .smc_n_rd19(smc_n_rd19),
   .smc_n_ext_oe19(smc_n_ext_oe19),
   .smc_busy19(smc_busy19),

   //test signal19 output
   .scan_out_119(),
   .scan_out_219(),
   .scan_out_319()
);



//------------------------------------------------------------------------------
// AHB19 formal19 verification19 monitor19
//------------------------------------------------------------------------------
  `ifdef SMC_ABV_ON19

// psl19 assume_hready_in19 : assume always (hready19 == smc_hready19) @(posedge hclk19);

    ahb_liteslave_monitor19 i_ahbSlaveMonitor19 (
        .hclk_i19(hclk19),
        .hresetn_i19(n_preset19),
        .hresp19(smc_hresp19),
        .hready19(smc_hready19),
        .hready_global_i19(smc_hready19),
        .hrdata19(smc_hrdata19),
        .hwdata_i19(hwdata19),
        .hburst_i19(3'b0),
        .hsize_i19(hsize19),
        .hwrite_i19(hwrite19),
        .htrans_i19(htrans19),
        .haddr_i19(haddr19),
        .hsel_i19(|hsel19)
    );


  ahb_litemaster_monitor19 i_ahbMasterMonitor19 (
          .hclk_i19(hclk19),
          .hresetn_i19(n_preset19),
          .hresp_i19(smc_hresp19),
          .hready_i19(smc_hready19),
          .hrdata_i19(smc_hrdata19),
          .hlock19(1'b0),
          .hwdata19(hwdata19),
          .hprot19(4'b0),
          .hburst19(3'b0),
          .hsize19(hsize19),
          .hwrite19(hwrite19),
          .htrans19(htrans19),
          .haddr19(haddr19)
          );



  `endif



endmodule
