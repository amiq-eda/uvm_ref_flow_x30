//File21 name   : smc_veneer21.v
//Title21       : 
//Created21     : 1999
//Description21 : 
//Notes21       : 
//----------------------------------------------------------------------
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------

 `include "smc_defs_lite21.v"

//static memory controller21
module smc_veneer21 (
                    //apb21 inputs21
                    n_preset21, 
                    pclk21, 
                    psel21, 
                    penable21, 
                    pwrite21, 
                    paddr21, 
                    pwdata21,
                    //ahb21 inputs21                    
                    hclk21,
                    n_sys_reset21,
                    haddr21,
                    htrans21,
                    hsel21,
                    hwrite21,
                    hsize21,
                    hwdata21,
                    hready21,
                    data_smc21,
                    
                    //test signal21 inputs21

                    scan_in_121,
                    scan_in_221,
                    scan_in_321,
                    scan_en21,

                    //apb21 outputs21                    
                    prdata21,

                    //design output
                    
                    smc_hrdata21, 
                    smc_hready21,
                    smc_valid21,
                    smc_hresp21,
                    smc_addr21,
                    smc_data21, 
                    smc_n_be21,
                    smc_n_cs21,
                    smc_n_wr21,                    
                    smc_n_we21,
                    smc_n_rd21,
                    smc_n_ext_oe21,
                    smc_busy21,

                    //test signal21 output

                    scan_out_121,
                    scan_out_221,
                    scan_out_321
                   );
// define parameters21
// change using defaparam21 statements21

  // APB21 Inputs21 (use is optional21 on INCLUDE_APB21)
  input        n_preset21;           // APBreset21 
  input        pclk21;               // APB21 clock21
  input        psel21;               // APB21 select21
  input        penable21;            // APB21 enable 
  input        pwrite21;             // APB21 write strobe21 
  input [4:0]  paddr21;              // APB21 address bus
  input [31:0] pwdata21;             // APB21 write data 

  // APB21 Output21 (use is optional21 on INCLUDE_APB21)

  output [31:0] prdata21;        //APB21 output


//System21 I21/O21

  input                    hclk21;          // AHB21 System21 clock21
  input                    n_sys_reset21;   // AHB21 System21 reset (Active21 LOW21)

//AHB21 I21/O21

  input  [31:0]            haddr21;         // AHB21 Address
  input  [1:0]             htrans21;        // AHB21 transfer21 type
  input                    hsel21;          // chip21 selects21
  input                    hwrite21;        // AHB21 read/write indication21
  input  [2:0]             hsize21;         // AHB21 transfer21 size
  input  [31:0]            hwdata21;        // AHB21 write data
  input                    hready21;        // AHB21 Muxed21 ready signal21

  
  output [31:0]            smc_hrdata21;    // smc21 read data back to AHB21 master21
  output                   smc_hready21;    // smc21 ready signal21
  output [1:0]             smc_hresp21;     // AHB21 Response21 signal21
  output                   smc_valid21;     // Ack21 valid address

//External21 memory interface (EMI21)

  output [31:0]            smc_addr21;      // External21 Memory (EMI21) address
  output [31:0]            smc_data21;      // EMI21 write data
  input  [31:0]            data_smc21;      // EMI21 read data
  output [3:0]             smc_n_be21;      // EMI21 byte enables21 (Active21 LOW21)
  output                   smc_n_cs21;      // EMI21 Chip21 Selects21 (Active21 LOW21)
  output [3:0]             smc_n_we21;      // EMI21 write strobes21 (Active21 LOW21)
  output                   smc_n_wr21;      // EMI21 write enable (Active21 LOW21)
  output                   smc_n_rd21;      // EMI21 read stobe21 (Active21 LOW21)
  output 	           smc_n_ext_oe21;  // EMI21 write data output enable

//AHB21 Memory Interface21 Control21

   output                   smc_busy21;      // smc21 busy



//scan21 signals21

   input                  scan_in_121;        //scan21 input
   input                  scan_in_221;        //scan21 input
   input                  scan_en21;         //scan21 enable
   output                 scan_out_121;       //scan21 output
   output                 scan_out_221;       //scan21 output
// third21 scan21 chain21 only used on INCLUDE_APB21
   input                  scan_in_321;        //scan21 input
   output                 scan_out_321;       //scan21 output

smc_lite21 i_smc_lite21(
   //inputs21
   //apb21 inputs21
   .n_preset21(n_preset21),
   .pclk21(pclk21),
   .psel21(psel21),
   .penable21(penable21),
   .pwrite21(pwrite21),
   .paddr21(paddr21),
   .pwdata21(pwdata21),
   //ahb21 inputs21
   .hclk21(hclk21),
   .n_sys_reset21(n_sys_reset21),
   .haddr21(haddr21),
   .htrans21(htrans21),
   .hsel21(hsel21),
   .hwrite21(hwrite21),
   .hsize21(hsize21),
   .hwdata21(hwdata21),
   .hready21(hready21),
   .data_smc21(data_smc21),


         //test signal21 inputs21

   .scan_in_121(),
   .scan_in_221(),
   .scan_in_321(),
   .scan_en21(scan_en21),

   //apb21 outputs21
   .prdata21(prdata21),

   //design output

   .smc_hrdata21(smc_hrdata21),
   .smc_hready21(smc_hready21),
   .smc_hresp21(smc_hresp21),
   .smc_valid21(smc_valid21),
   .smc_addr21(smc_addr21),
   .smc_data21(smc_data21),
   .smc_n_be21(smc_n_be21),
   .smc_n_cs21(smc_n_cs21),
   .smc_n_wr21(smc_n_wr21),
   .smc_n_we21(smc_n_we21),
   .smc_n_rd21(smc_n_rd21),
   .smc_n_ext_oe21(smc_n_ext_oe21),
   .smc_busy21(smc_busy21),

   //test signal21 output
   .scan_out_121(),
   .scan_out_221(),
   .scan_out_321()
);



//------------------------------------------------------------------------------
// AHB21 formal21 verification21 monitor21
//------------------------------------------------------------------------------
  `ifdef SMC_ABV_ON21

// psl21 assume_hready_in21 : assume always (hready21 == smc_hready21) @(posedge hclk21);

    ahb_liteslave_monitor21 i_ahbSlaveMonitor21 (
        .hclk_i21(hclk21),
        .hresetn_i21(n_preset21),
        .hresp21(smc_hresp21),
        .hready21(smc_hready21),
        .hready_global_i21(smc_hready21),
        .hrdata21(smc_hrdata21),
        .hwdata_i21(hwdata21),
        .hburst_i21(3'b0),
        .hsize_i21(hsize21),
        .hwrite_i21(hwrite21),
        .htrans_i21(htrans21),
        .haddr_i21(haddr21),
        .hsel_i21(|hsel21)
    );


  ahb_litemaster_monitor21 i_ahbMasterMonitor21 (
          .hclk_i21(hclk21),
          .hresetn_i21(n_preset21),
          .hresp_i21(smc_hresp21),
          .hready_i21(smc_hready21),
          .hrdata_i21(smc_hrdata21),
          .hlock21(1'b0),
          .hwdata21(hwdata21),
          .hprot21(4'b0),
          .hburst21(3'b0),
          .hsize21(hsize21),
          .hwrite21(hwrite21),
          .htrans21(htrans21),
          .haddr21(haddr21)
          );



  `endif



endmodule
