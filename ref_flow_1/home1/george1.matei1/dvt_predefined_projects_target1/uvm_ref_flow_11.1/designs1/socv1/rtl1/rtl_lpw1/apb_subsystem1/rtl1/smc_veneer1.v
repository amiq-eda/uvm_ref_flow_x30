//File1 name   : smc_veneer1.v
//Title1       : 
//Created1     : 1999
//Description1 : 
//Notes1       : 
//----------------------------------------------------------------------
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------

 `include "smc_defs_lite1.v"

//static memory controller1
module smc_veneer1 (
                    //apb1 inputs1
                    n_preset1, 
                    pclk1, 
                    psel1, 
                    penable1, 
                    pwrite1, 
                    paddr1, 
                    pwdata1,
                    //ahb1 inputs1                    
                    hclk1,
                    n_sys_reset1,
                    haddr1,
                    htrans1,
                    hsel1,
                    hwrite1,
                    hsize1,
                    hwdata1,
                    hready1,
                    data_smc1,
                    
                    //test signal1 inputs1

                    scan_in_11,
                    scan_in_21,
                    scan_in_31,
                    scan_en1,

                    //apb1 outputs1                    
                    prdata1,

                    //design output
                    
                    smc_hrdata1, 
                    smc_hready1,
                    smc_valid1,
                    smc_hresp1,
                    smc_addr1,
                    smc_data1, 
                    smc_n_be1,
                    smc_n_cs1,
                    smc_n_wr1,                    
                    smc_n_we1,
                    smc_n_rd1,
                    smc_n_ext_oe1,
                    smc_busy1,

                    //test signal1 output

                    scan_out_11,
                    scan_out_21,
                    scan_out_31
                   );
// define parameters1
// change using defaparam1 statements1

  // APB1 Inputs1 (use is optional1 on INCLUDE_APB1)
  input        n_preset1;           // APBreset1 
  input        pclk1;               // APB1 clock1
  input        psel1;               // APB1 select1
  input        penable1;            // APB1 enable 
  input        pwrite1;             // APB1 write strobe1 
  input [4:0]  paddr1;              // APB1 address bus
  input [31:0] pwdata1;             // APB1 write data 

  // APB1 Output1 (use is optional1 on INCLUDE_APB1)

  output [31:0] prdata1;        //APB1 output


//System1 I1/O1

  input                    hclk1;          // AHB1 System1 clock1
  input                    n_sys_reset1;   // AHB1 System1 reset (Active1 LOW1)

//AHB1 I1/O1

  input  [31:0]            haddr1;         // AHB1 Address
  input  [1:0]             htrans1;        // AHB1 transfer1 type
  input                    hsel1;          // chip1 selects1
  input                    hwrite1;        // AHB1 read/write indication1
  input  [2:0]             hsize1;         // AHB1 transfer1 size
  input  [31:0]            hwdata1;        // AHB1 write data
  input                    hready1;        // AHB1 Muxed1 ready signal1

  
  output [31:0]            smc_hrdata1;    // smc1 read data back to AHB1 master1
  output                   smc_hready1;    // smc1 ready signal1
  output [1:0]             smc_hresp1;     // AHB1 Response1 signal1
  output                   smc_valid1;     // Ack1 valid address

//External1 memory interface (EMI1)

  output [31:0]            smc_addr1;      // External1 Memory (EMI1) address
  output [31:0]            smc_data1;      // EMI1 write data
  input  [31:0]            data_smc1;      // EMI1 read data
  output [3:0]             smc_n_be1;      // EMI1 byte enables1 (Active1 LOW1)
  output                   smc_n_cs1;      // EMI1 Chip1 Selects1 (Active1 LOW1)
  output [3:0]             smc_n_we1;      // EMI1 write strobes1 (Active1 LOW1)
  output                   smc_n_wr1;      // EMI1 write enable (Active1 LOW1)
  output                   smc_n_rd1;      // EMI1 read stobe1 (Active1 LOW1)
  output 	           smc_n_ext_oe1;  // EMI1 write data output enable

//AHB1 Memory Interface1 Control1

   output                   smc_busy1;      // smc1 busy



//scan1 signals1

   input                  scan_in_11;        //scan1 input
   input                  scan_in_21;        //scan1 input
   input                  scan_en1;         //scan1 enable
   output                 scan_out_11;       //scan1 output
   output                 scan_out_21;       //scan1 output
// third1 scan1 chain1 only used on INCLUDE_APB1
   input                  scan_in_31;        //scan1 input
   output                 scan_out_31;       //scan1 output

smc_lite1 i_smc_lite1(
   //inputs1
   //apb1 inputs1
   .n_preset1(n_preset1),
   .pclk1(pclk1),
   .psel1(psel1),
   .penable1(penable1),
   .pwrite1(pwrite1),
   .paddr1(paddr1),
   .pwdata1(pwdata1),
   //ahb1 inputs1
   .hclk1(hclk1),
   .n_sys_reset1(n_sys_reset1),
   .haddr1(haddr1),
   .htrans1(htrans1),
   .hsel1(hsel1),
   .hwrite1(hwrite1),
   .hsize1(hsize1),
   .hwdata1(hwdata1),
   .hready1(hready1),
   .data_smc1(data_smc1),


         //test signal1 inputs1

   .scan_in_11(),
   .scan_in_21(),
   .scan_in_31(),
   .scan_en1(scan_en1),

   //apb1 outputs1
   .prdata1(prdata1),

   //design output

   .smc_hrdata1(smc_hrdata1),
   .smc_hready1(smc_hready1),
   .smc_hresp1(smc_hresp1),
   .smc_valid1(smc_valid1),
   .smc_addr1(smc_addr1),
   .smc_data1(smc_data1),
   .smc_n_be1(smc_n_be1),
   .smc_n_cs1(smc_n_cs1),
   .smc_n_wr1(smc_n_wr1),
   .smc_n_we1(smc_n_we1),
   .smc_n_rd1(smc_n_rd1),
   .smc_n_ext_oe1(smc_n_ext_oe1),
   .smc_busy1(smc_busy1),

   //test signal1 output
   .scan_out_11(),
   .scan_out_21(),
   .scan_out_31()
);



//------------------------------------------------------------------------------
// AHB1 formal1 verification1 monitor1
//------------------------------------------------------------------------------
  `ifdef SMC_ABV_ON1

// psl1 assume_hready_in1 : assume always (hready1 == smc_hready1) @(posedge hclk1);

    ahb_liteslave_monitor1 i_ahbSlaveMonitor1 (
        .hclk_i1(hclk1),
        .hresetn_i1(n_preset1),
        .hresp1(smc_hresp1),
        .hready1(smc_hready1),
        .hready_global_i1(smc_hready1),
        .hrdata1(smc_hrdata1),
        .hwdata_i1(hwdata1),
        .hburst_i1(3'b0),
        .hsize_i1(hsize1),
        .hwrite_i1(hwrite1),
        .htrans_i1(htrans1),
        .haddr_i1(haddr1),
        .hsel_i1(|hsel1)
    );


  ahb_litemaster_monitor1 i_ahbMasterMonitor1 (
          .hclk_i1(hclk1),
          .hresetn_i1(n_preset1),
          .hresp_i1(smc_hresp1),
          .hready_i1(smc_hready1),
          .hrdata_i1(smc_hrdata1),
          .hlock1(1'b0),
          .hwdata1(hwdata1),
          .hprot1(4'b0),
          .hburst1(3'b0),
          .hsize1(hsize1),
          .hwrite1(hwrite1),
          .htrans1(htrans1),
          .haddr1(haddr1)
          );



  `endif



endmodule
