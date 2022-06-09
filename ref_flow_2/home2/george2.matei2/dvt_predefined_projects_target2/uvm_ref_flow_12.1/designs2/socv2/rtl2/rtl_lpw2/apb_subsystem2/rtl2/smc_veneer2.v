//File2 name   : smc_veneer2.v
//Title2       : 
//Created2     : 1999
//Description2 : 
//Notes2       : 
//----------------------------------------------------------------------
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------

 `include "smc_defs_lite2.v"

//static memory controller2
module smc_veneer2 (
                    //apb2 inputs2
                    n_preset2, 
                    pclk2, 
                    psel2, 
                    penable2, 
                    pwrite2, 
                    paddr2, 
                    pwdata2,
                    //ahb2 inputs2                    
                    hclk2,
                    n_sys_reset2,
                    haddr2,
                    htrans2,
                    hsel2,
                    hwrite2,
                    hsize2,
                    hwdata2,
                    hready2,
                    data_smc2,
                    
                    //test signal2 inputs2

                    scan_in_12,
                    scan_in_22,
                    scan_in_32,
                    scan_en2,

                    //apb2 outputs2                    
                    prdata2,

                    //design output
                    
                    smc_hrdata2, 
                    smc_hready2,
                    smc_valid2,
                    smc_hresp2,
                    smc_addr2,
                    smc_data2, 
                    smc_n_be2,
                    smc_n_cs2,
                    smc_n_wr2,                    
                    smc_n_we2,
                    smc_n_rd2,
                    smc_n_ext_oe2,
                    smc_busy2,

                    //test signal2 output

                    scan_out_12,
                    scan_out_22,
                    scan_out_32
                   );
// define parameters2
// change using defaparam2 statements2

  // APB2 Inputs2 (use is optional2 on INCLUDE_APB2)
  input        n_preset2;           // APBreset2 
  input        pclk2;               // APB2 clock2
  input        psel2;               // APB2 select2
  input        penable2;            // APB2 enable 
  input        pwrite2;             // APB2 write strobe2 
  input [4:0]  paddr2;              // APB2 address bus
  input [31:0] pwdata2;             // APB2 write data 

  // APB2 Output2 (use is optional2 on INCLUDE_APB2)

  output [31:0] prdata2;        //APB2 output


//System2 I2/O2

  input                    hclk2;          // AHB2 System2 clock2
  input                    n_sys_reset2;   // AHB2 System2 reset (Active2 LOW2)

//AHB2 I2/O2

  input  [31:0]            haddr2;         // AHB2 Address
  input  [1:0]             htrans2;        // AHB2 transfer2 type
  input                    hsel2;          // chip2 selects2
  input                    hwrite2;        // AHB2 read/write indication2
  input  [2:0]             hsize2;         // AHB2 transfer2 size
  input  [31:0]            hwdata2;        // AHB2 write data
  input                    hready2;        // AHB2 Muxed2 ready signal2

  
  output [31:0]            smc_hrdata2;    // smc2 read data back to AHB2 master2
  output                   smc_hready2;    // smc2 ready signal2
  output [1:0]             smc_hresp2;     // AHB2 Response2 signal2
  output                   smc_valid2;     // Ack2 valid address

//External2 memory interface (EMI2)

  output [31:0]            smc_addr2;      // External2 Memory (EMI2) address
  output [31:0]            smc_data2;      // EMI2 write data
  input  [31:0]            data_smc2;      // EMI2 read data
  output [3:0]             smc_n_be2;      // EMI2 byte enables2 (Active2 LOW2)
  output                   smc_n_cs2;      // EMI2 Chip2 Selects2 (Active2 LOW2)
  output [3:0]             smc_n_we2;      // EMI2 write strobes2 (Active2 LOW2)
  output                   smc_n_wr2;      // EMI2 write enable (Active2 LOW2)
  output                   smc_n_rd2;      // EMI2 read stobe2 (Active2 LOW2)
  output 	           smc_n_ext_oe2;  // EMI2 write data output enable

//AHB2 Memory Interface2 Control2

   output                   smc_busy2;      // smc2 busy



//scan2 signals2

   input                  scan_in_12;        //scan2 input
   input                  scan_in_22;        //scan2 input
   input                  scan_en2;         //scan2 enable
   output                 scan_out_12;       //scan2 output
   output                 scan_out_22;       //scan2 output
// third2 scan2 chain2 only used on INCLUDE_APB2
   input                  scan_in_32;        //scan2 input
   output                 scan_out_32;       //scan2 output

smc_lite2 i_smc_lite2(
   //inputs2
   //apb2 inputs2
   .n_preset2(n_preset2),
   .pclk2(pclk2),
   .psel2(psel2),
   .penable2(penable2),
   .pwrite2(pwrite2),
   .paddr2(paddr2),
   .pwdata2(pwdata2),
   //ahb2 inputs2
   .hclk2(hclk2),
   .n_sys_reset2(n_sys_reset2),
   .haddr2(haddr2),
   .htrans2(htrans2),
   .hsel2(hsel2),
   .hwrite2(hwrite2),
   .hsize2(hsize2),
   .hwdata2(hwdata2),
   .hready2(hready2),
   .data_smc2(data_smc2),


         //test signal2 inputs2

   .scan_in_12(),
   .scan_in_22(),
   .scan_in_32(),
   .scan_en2(scan_en2),

   //apb2 outputs2
   .prdata2(prdata2),

   //design output

   .smc_hrdata2(smc_hrdata2),
   .smc_hready2(smc_hready2),
   .smc_hresp2(smc_hresp2),
   .smc_valid2(smc_valid2),
   .smc_addr2(smc_addr2),
   .smc_data2(smc_data2),
   .smc_n_be2(smc_n_be2),
   .smc_n_cs2(smc_n_cs2),
   .smc_n_wr2(smc_n_wr2),
   .smc_n_we2(smc_n_we2),
   .smc_n_rd2(smc_n_rd2),
   .smc_n_ext_oe2(smc_n_ext_oe2),
   .smc_busy2(smc_busy2),

   //test signal2 output
   .scan_out_12(),
   .scan_out_22(),
   .scan_out_32()
);



//------------------------------------------------------------------------------
// AHB2 formal2 verification2 monitor2
//------------------------------------------------------------------------------
  `ifdef SMC_ABV_ON2

// psl2 assume_hready_in2 : assume always (hready2 == smc_hready2) @(posedge hclk2);

    ahb_liteslave_monitor2 i_ahbSlaveMonitor2 (
        .hclk_i2(hclk2),
        .hresetn_i2(n_preset2),
        .hresp2(smc_hresp2),
        .hready2(smc_hready2),
        .hready_global_i2(smc_hready2),
        .hrdata2(smc_hrdata2),
        .hwdata_i2(hwdata2),
        .hburst_i2(3'b0),
        .hsize_i2(hsize2),
        .hwrite_i2(hwrite2),
        .htrans_i2(htrans2),
        .haddr_i2(haddr2),
        .hsel_i2(|hsel2)
    );


  ahb_litemaster_monitor2 i_ahbMasterMonitor2 (
          .hclk_i2(hclk2),
          .hresetn_i2(n_preset2),
          .hresp_i2(smc_hresp2),
          .hready_i2(smc_hready2),
          .hrdata_i2(smc_hrdata2),
          .hlock2(1'b0),
          .hwdata2(hwdata2),
          .hprot2(4'b0),
          .hburst2(3'b0),
          .hsize2(hsize2),
          .hwrite2(hwrite2),
          .htrans2(htrans2),
          .haddr2(haddr2)
          );



  `endif



endmodule
