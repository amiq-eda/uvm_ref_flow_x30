//File4 name   : smc_veneer4.v
//Title4       : 
//Created4     : 1999
//Description4 : 
//Notes4       : 
//----------------------------------------------------------------------
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------

 `include "smc_defs_lite4.v"

//static memory controller4
module smc_veneer4 (
                    //apb4 inputs4
                    n_preset4, 
                    pclk4, 
                    psel4, 
                    penable4, 
                    pwrite4, 
                    paddr4, 
                    pwdata4,
                    //ahb4 inputs4                    
                    hclk4,
                    n_sys_reset4,
                    haddr4,
                    htrans4,
                    hsel4,
                    hwrite4,
                    hsize4,
                    hwdata4,
                    hready4,
                    data_smc4,
                    
                    //test signal4 inputs4

                    scan_in_14,
                    scan_in_24,
                    scan_in_34,
                    scan_en4,

                    //apb4 outputs4                    
                    prdata4,

                    //design output
                    
                    smc_hrdata4, 
                    smc_hready4,
                    smc_valid4,
                    smc_hresp4,
                    smc_addr4,
                    smc_data4, 
                    smc_n_be4,
                    smc_n_cs4,
                    smc_n_wr4,                    
                    smc_n_we4,
                    smc_n_rd4,
                    smc_n_ext_oe4,
                    smc_busy4,

                    //test signal4 output

                    scan_out_14,
                    scan_out_24,
                    scan_out_34
                   );
// define parameters4
// change using defaparam4 statements4

  // APB4 Inputs4 (use is optional4 on INCLUDE_APB4)
  input        n_preset4;           // APBreset4 
  input        pclk4;               // APB4 clock4
  input        psel4;               // APB4 select4
  input        penable4;            // APB4 enable 
  input        pwrite4;             // APB4 write strobe4 
  input [4:0]  paddr4;              // APB4 address bus
  input [31:0] pwdata4;             // APB4 write data 

  // APB4 Output4 (use is optional4 on INCLUDE_APB4)

  output [31:0] prdata4;        //APB4 output


//System4 I4/O4

  input                    hclk4;          // AHB4 System4 clock4
  input                    n_sys_reset4;   // AHB4 System4 reset (Active4 LOW4)

//AHB4 I4/O4

  input  [31:0]            haddr4;         // AHB4 Address
  input  [1:0]             htrans4;        // AHB4 transfer4 type
  input                    hsel4;          // chip4 selects4
  input                    hwrite4;        // AHB4 read/write indication4
  input  [2:0]             hsize4;         // AHB4 transfer4 size
  input  [31:0]            hwdata4;        // AHB4 write data
  input                    hready4;        // AHB4 Muxed4 ready signal4

  
  output [31:0]            smc_hrdata4;    // smc4 read data back to AHB4 master4
  output                   smc_hready4;    // smc4 ready signal4
  output [1:0]             smc_hresp4;     // AHB4 Response4 signal4
  output                   smc_valid4;     // Ack4 valid address

//External4 memory interface (EMI4)

  output [31:0]            smc_addr4;      // External4 Memory (EMI4) address
  output [31:0]            smc_data4;      // EMI4 write data
  input  [31:0]            data_smc4;      // EMI4 read data
  output [3:0]             smc_n_be4;      // EMI4 byte enables4 (Active4 LOW4)
  output                   smc_n_cs4;      // EMI4 Chip4 Selects4 (Active4 LOW4)
  output [3:0]             smc_n_we4;      // EMI4 write strobes4 (Active4 LOW4)
  output                   smc_n_wr4;      // EMI4 write enable (Active4 LOW4)
  output                   smc_n_rd4;      // EMI4 read stobe4 (Active4 LOW4)
  output 	           smc_n_ext_oe4;  // EMI4 write data output enable

//AHB4 Memory Interface4 Control4

   output                   smc_busy4;      // smc4 busy



//scan4 signals4

   input                  scan_in_14;        //scan4 input
   input                  scan_in_24;        //scan4 input
   input                  scan_en4;         //scan4 enable
   output                 scan_out_14;       //scan4 output
   output                 scan_out_24;       //scan4 output
// third4 scan4 chain4 only used on INCLUDE_APB4
   input                  scan_in_34;        //scan4 input
   output                 scan_out_34;       //scan4 output

smc_lite4 i_smc_lite4(
   //inputs4
   //apb4 inputs4
   .n_preset4(n_preset4),
   .pclk4(pclk4),
   .psel4(psel4),
   .penable4(penable4),
   .pwrite4(pwrite4),
   .paddr4(paddr4),
   .pwdata4(pwdata4),
   //ahb4 inputs4
   .hclk4(hclk4),
   .n_sys_reset4(n_sys_reset4),
   .haddr4(haddr4),
   .htrans4(htrans4),
   .hsel4(hsel4),
   .hwrite4(hwrite4),
   .hsize4(hsize4),
   .hwdata4(hwdata4),
   .hready4(hready4),
   .data_smc4(data_smc4),


         //test signal4 inputs4

   .scan_in_14(),
   .scan_in_24(),
   .scan_in_34(),
   .scan_en4(scan_en4),

   //apb4 outputs4
   .prdata4(prdata4),

   //design output

   .smc_hrdata4(smc_hrdata4),
   .smc_hready4(smc_hready4),
   .smc_hresp4(smc_hresp4),
   .smc_valid4(smc_valid4),
   .smc_addr4(smc_addr4),
   .smc_data4(smc_data4),
   .smc_n_be4(smc_n_be4),
   .smc_n_cs4(smc_n_cs4),
   .smc_n_wr4(smc_n_wr4),
   .smc_n_we4(smc_n_we4),
   .smc_n_rd4(smc_n_rd4),
   .smc_n_ext_oe4(smc_n_ext_oe4),
   .smc_busy4(smc_busy4),

   //test signal4 output
   .scan_out_14(),
   .scan_out_24(),
   .scan_out_34()
);



//------------------------------------------------------------------------------
// AHB4 formal4 verification4 monitor4
//------------------------------------------------------------------------------
  `ifdef SMC_ABV_ON4

// psl4 assume_hready_in4 : assume always (hready4 == smc_hready4) @(posedge hclk4);

    ahb_liteslave_monitor4 i_ahbSlaveMonitor4 (
        .hclk_i4(hclk4),
        .hresetn_i4(n_preset4),
        .hresp4(smc_hresp4),
        .hready4(smc_hready4),
        .hready_global_i4(smc_hready4),
        .hrdata4(smc_hrdata4),
        .hwdata_i4(hwdata4),
        .hburst_i4(3'b0),
        .hsize_i4(hsize4),
        .hwrite_i4(hwrite4),
        .htrans_i4(htrans4),
        .haddr_i4(haddr4),
        .hsel_i4(|hsel4)
    );


  ahb_litemaster_monitor4 i_ahbMasterMonitor4 (
          .hclk_i4(hclk4),
          .hresetn_i4(n_preset4),
          .hresp_i4(smc_hresp4),
          .hready_i4(smc_hready4),
          .hrdata_i4(smc_hrdata4),
          .hlock4(1'b0),
          .hwdata4(hwdata4),
          .hprot4(4'b0),
          .hburst4(3'b0),
          .hsize4(hsize4),
          .hwrite4(hwrite4),
          .htrans4(htrans4),
          .haddr4(haddr4)
          );



  `endif



endmodule
