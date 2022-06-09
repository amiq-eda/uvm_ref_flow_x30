//File8 name   : smc_veneer8.v
//Title8       : 
//Created8     : 1999
//Description8 : 
//Notes8       : 
//----------------------------------------------------------------------
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------

 `include "smc_defs_lite8.v"

//static memory controller8
module smc_veneer8 (
                    //apb8 inputs8
                    n_preset8, 
                    pclk8, 
                    psel8, 
                    penable8, 
                    pwrite8, 
                    paddr8, 
                    pwdata8,
                    //ahb8 inputs8                    
                    hclk8,
                    n_sys_reset8,
                    haddr8,
                    htrans8,
                    hsel8,
                    hwrite8,
                    hsize8,
                    hwdata8,
                    hready8,
                    data_smc8,
                    
                    //test signal8 inputs8

                    scan_in_18,
                    scan_in_28,
                    scan_in_38,
                    scan_en8,

                    //apb8 outputs8                    
                    prdata8,

                    //design output
                    
                    smc_hrdata8, 
                    smc_hready8,
                    smc_valid8,
                    smc_hresp8,
                    smc_addr8,
                    smc_data8, 
                    smc_n_be8,
                    smc_n_cs8,
                    smc_n_wr8,                    
                    smc_n_we8,
                    smc_n_rd8,
                    smc_n_ext_oe8,
                    smc_busy8,

                    //test signal8 output

                    scan_out_18,
                    scan_out_28,
                    scan_out_38
                   );
// define parameters8
// change using defaparam8 statements8

  // APB8 Inputs8 (use is optional8 on INCLUDE_APB8)
  input        n_preset8;           // APBreset8 
  input        pclk8;               // APB8 clock8
  input        psel8;               // APB8 select8
  input        penable8;            // APB8 enable 
  input        pwrite8;             // APB8 write strobe8 
  input [4:0]  paddr8;              // APB8 address bus
  input [31:0] pwdata8;             // APB8 write data 

  // APB8 Output8 (use is optional8 on INCLUDE_APB8)

  output [31:0] prdata8;        //APB8 output


//System8 I8/O8

  input                    hclk8;          // AHB8 System8 clock8
  input                    n_sys_reset8;   // AHB8 System8 reset (Active8 LOW8)

//AHB8 I8/O8

  input  [31:0]            haddr8;         // AHB8 Address
  input  [1:0]             htrans8;        // AHB8 transfer8 type
  input                    hsel8;          // chip8 selects8
  input                    hwrite8;        // AHB8 read/write indication8
  input  [2:0]             hsize8;         // AHB8 transfer8 size
  input  [31:0]            hwdata8;        // AHB8 write data
  input                    hready8;        // AHB8 Muxed8 ready signal8

  
  output [31:0]            smc_hrdata8;    // smc8 read data back to AHB8 master8
  output                   smc_hready8;    // smc8 ready signal8
  output [1:0]             smc_hresp8;     // AHB8 Response8 signal8
  output                   smc_valid8;     // Ack8 valid address

//External8 memory interface (EMI8)

  output [31:0]            smc_addr8;      // External8 Memory (EMI8) address
  output [31:0]            smc_data8;      // EMI8 write data
  input  [31:0]            data_smc8;      // EMI8 read data
  output [3:0]             smc_n_be8;      // EMI8 byte enables8 (Active8 LOW8)
  output                   smc_n_cs8;      // EMI8 Chip8 Selects8 (Active8 LOW8)
  output [3:0]             smc_n_we8;      // EMI8 write strobes8 (Active8 LOW8)
  output                   smc_n_wr8;      // EMI8 write enable (Active8 LOW8)
  output                   smc_n_rd8;      // EMI8 read stobe8 (Active8 LOW8)
  output 	           smc_n_ext_oe8;  // EMI8 write data output enable

//AHB8 Memory Interface8 Control8

   output                   smc_busy8;      // smc8 busy



//scan8 signals8

   input                  scan_in_18;        //scan8 input
   input                  scan_in_28;        //scan8 input
   input                  scan_en8;         //scan8 enable
   output                 scan_out_18;       //scan8 output
   output                 scan_out_28;       //scan8 output
// third8 scan8 chain8 only used on INCLUDE_APB8
   input                  scan_in_38;        //scan8 input
   output                 scan_out_38;       //scan8 output

smc_lite8 i_smc_lite8(
   //inputs8
   //apb8 inputs8
   .n_preset8(n_preset8),
   .pclk8(pclk8),
   .psel8(psel8),
   .penable8(penable8),
   .pwrite8(pwrite8),
   .paddr8(paddr8),
   .pwdata8(pwdata8),
   //ahb8 inputs8
   .hclk8(hclk8),
   .n_sys_reset8(n_sys_reset8),
   .haddr8(haddr8),
   .htrans8(htrans8),
   .hsel8(hsel8),
   .hwrite8(hwrite8),
   .hsize8(hsize8),
   .hwdata8(hwdata8),
   .hready8(hready8),
   .data_smc8(data_smc8),


         //test signal8 inputs8

   .scan_in_18(),
   .scan_in_28(),
   .scan_in_38(),
   .scan_en8(scan_en8),

   //apb8 outputs8
   .prdata8(prdata8),

   //design output

   .smc_hrdata8(smc_hrdata8),
   .smc_hready8(smc_hready8),
   .smc_hresp8(smc_hresp8),
   .smc_valid8(smc_valid8),
   .smc_addr8(smc_addr8),
   .smc_data8(smc_data8),
   .smc_n_be8(smc_n_be8),
   .smc_n_cs8(smc_n_cs8),
   .smc_n_wr8(smc_n_wr8),
   .smc_n_we8(smc_n_we8),
   .smc_n_rd8(smc_n_rd8),
   .smc_n_ext_oe8(smc_n_ext_oe8),
   .smc_busy8(smc_busy8),

   //test signal8 output
   .scan_out_18(),
   .scan_out_28(),
   .scan_out_38()
);



//------------------------------------------------------------------------------
// AHB8 formal8 verification8 monitor8
//------------------------------------------------------------------------------
  `ifdef SMC_ABV_ON8

// psl8 assume_hready_in8 : assume always (hready8 == smc_hready8) @(posedge hclk8);

    ahb_liteslave_monitor8 i_ahbSlaveMonitor8 (
        .hclk_i8(hclk8),
        .hresetn_i8(n_preset8),
        .hresp8(smc_hresp8),
        .hready8(smc_hready8),
        .hready_global_i8(smc_hready8),
        .hrdata8(smc_hrdata8),
        .hwdata_i8(hwdata8),
        .hburst_i8(3'b0),
        .hsize_i8(hsize8),
        .hwrite_i8(hwrite8),
        .htrans_i8(htrans8),
        .haddr_i8(haddr8),
        .hsel_i8(|hsel8)
    );


  ahb_litemaster_monitor8 i_ahbMasterMonitor8 (
          .hclk_i8(hclk8),
          .hresetn_i8(n_preset8),
          .hresp_i8(smc_hresp8),
          .hready_i8(smc_hready8),
          .hrdata_i8(smc_hrdata8),
          .hlock8(1'b0),
          .hwdata8(hwdata8),
          .hprot8(4'b0),
          .hburst8(3'b0),
          .hsize8(hsize8),
          .hwrite8(hwrite8),
          .htrans8(htrans8),
          .haddr8(haddr8)
          );



  `endif



endmodule
