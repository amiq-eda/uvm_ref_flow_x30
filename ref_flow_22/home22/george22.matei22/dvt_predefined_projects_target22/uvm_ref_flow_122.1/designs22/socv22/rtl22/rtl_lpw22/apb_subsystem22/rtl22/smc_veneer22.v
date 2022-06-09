//File22 name   : smc_veneer22.v
//Title22       : 
//Created22     : 1999
//Description22 : 
//Notes22       : 
//----------------------------------------------------------------------
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------

 `include "smc_defs_lite22.v"

//static memory controller22
module smc_veneer22 (
                    //apb22 inputs22
                    n_preset22, 
                    pclk22, 
                    psel22, 
                    penable22, 
                    pwrite22, 
                    paddr22, 
                    pwdata22,
                    //ahb22 inputs22                    
                    hclk22,
                    n_sys_reset22,
                    haddr22,
                    htrans22,
                    hsel22,
                    hwrite22,
                    hsize22,
                    hwdata22,
                    hready22,
                    data_smc22,
                    
                    //test signal22 inputs22

                    scan_in_122,
                    scan_in_222,
                    scan_in_322,
                    scan_en22,

                    //apb22 outputs22                    
                    prdata22,

                    //design output
                    
                    smc_hrdata22, 
                    smc_hready22,
                    smc_valid22,
                    smc_hresp22,
                    smc_addr22,
                    smc_data22, 
                    smc_n_be22,
                    smc_n_cs22,
                    smc_n_wr22,                    
                    smc_n_we22,
                    smc_n_rd22,
                    smc_n_ext_oe22,
                    smc_busy22,

                    //test signal22 output

                    scan_out_122,
                    scan_out_222,
                    scan_out_322
                   );
// define parameters22
// change using defaparam22 statements22

  // APB22 Inputs22 (use is optional22 on INCLUDE_APB22)
  input        n_preset22;           // APBreset22 
  input        pclk22;               // APB22 clock22
  input        psel22;               // APB22 select22
  input        penable22;            // APB22 enable 
  input        pwrite22;             // APB22 write strobe22 
  input [4:0]  paddr22;              // APB22 address bus
  input [31:0] pwdata22;             // APB22 write data 

  // APB22 Output22 (use is optional22 on INCLUDE_APB22)

  output [31:0] prdata22;        //APB22 output


//System22 I22/O22

  input                    hclk22;          // AHB22 System22 clock22
  input                    n_sys_reset22;   // AHB22 System22 reset (Active22 LOW22)

//AHB22 I22/O22

  input  [31:0]            haddr22;         // AHB22 Address
  input  [1:0]             htrans22;        // AHB22 transfer22 type
  input                    hsel22;          // chip22 selects22
  input                    hwrite22;        // AHB22 read/write indication22
  input  [2:0]             hsize22;         // AHB22 transfer22 size
  input  [31:0]            hwdata22;        // AHB22 write data
  input                    hready22;        // AHB22 Muxed22 ready signal22

  
  output [31:0]            smc_hrdata22;    // smc22 read data back to AHB22 master22
  output                   smc_hready22;    // smc22 ready signal22
  output [1:0]             smc_hresp22;     // AHB22 Response22 signal22
  output                   smc_valid22;     // Ack22 valid address

//External22 memory interface (EMI22)

  output [31:0]            smc_addr22;      // External22 Memory (EMI22) address
  output [31:0]            smc_data22;      // EMI22 write data
  input  [31:0]            data_smc22;      // EMI22 read data
  output [3:0]             smc_n_be22;      // EMI22 byte enables22 (Active22 LOW22)
  output                   smc_n_cs22;      // EMI22 Chip22 Selects22 (Active22 LOW22)
  output [3:0]             smc_n_we22;      // EMI22 write strobes22 (Active22 LOW22)
  output                   smc_n_wr22;      // EMI22 write enable (Active22 LOW22)
  output                   smc_n_rd22;      // EMI22 read stobe22 (Active22 LOW22)
  output 	           smc_n_ext_oe22;  // EMI22 write data output enable

//AHB22 Memory Interface22 Control22

   output                   smc_busy22;      // smc22 busy



//scan22 signals22

   input                  scan_in_122;        //scan22 input
   input                  scan_in_222;        //scan22 input
   input                  scan_en22;         //scan22 enable
   output                 scan_out_122;       //scan22 output
   output                 scan_out_222;       //scan22 output
// third22 scan22 chain22 only used on INCLUDE_APB22
   input                  scan_in_322;        //scan22 input
   output                 scan_out_322;       //scan22 output

smc_lite22 i_smc_lite22(
   //inputs22
   //apb22 inputs22
   .n_preset22(n_preset22),
   .pclk22(pclk22),
   .psel22(psel22),
   .penable22(penable22),
   .pwrite22(pwrite22),
   .paddr22(paddr22),
   .pwdata22(pwdata22),
   //ahb22 inputs22
   .hclk22(hclk22),
   .n_sys_reset22(n_sys_reset22),
   .haddr22(haddr22),
   .htrans22(htrans22),
   .hsel22(hsel22),
   .hwrite22(hwrite22),
   .hsize22(hsize22),
   .hwdata22(hwdata22),
   .hready22(hready22),
   .data_smc22(data_smc22),


         //test signal22 inputs22

   .scan_in_122(),
   .scan_in_222(),
   .scan_in_322(),
   .scan_en22(scan_en22),

   //apb22 outputs22
   .prdata22(prdata22),

   //design output

   .smc_hrdata22(smc_hrdata22),
   .smc_hready22(smc_hready22),
   .smc_hresp22(smc_hresp22),
   .smc_valid22(smc_valid22),
   .smc_addr22(smc_addr22),
   .smc_data22(smc_data22),
   .smc_n_be22(smc_n_be22),
   .smc_n_cs22(smc_n_cs22),
   .smc_n_wr22(smc_n_wr22),
   .smc_n_we22(smc_n_we22),
   .smc_n_rd22(smc_n_rd22),
   .smc_n_ext_oe22(smc_n_ext_oe22),
   .smc_busy22(smc_busy22),

   //test signal22 output
   .scan_out_122(),
   .scan_out_222(),
   .scan_out_322()
);



//------------------------------------------------------------------------------
// AHB22 formal22 verification22 monitor22
//------------------------------------------------------------------------------
  `ifdef SMC_ABV_ON22

// psl22 assume_hready_in22 : assume always (hready22 == smc_hready22) @(posedge hclk22);

    ahb_liteslave_monitor22 i_ahbSlaveMonitor22 (
        .hclk_i22(hclk22),
        .hresetn_i22(n_preset22),
        .hresp22(smc_hresp22),
        .hready22(smc_hready22),
        .hready_global_i22(smc_hready22),
        .hrdata22(smc_hrdata22),
        .hwdata_i22(hwdata22),
        .hburst_i22(3'b0),
        .hsize_i22(hsize22),
        .hwrite_i22(hwrite22),
        .htrans_i22(htrans22),
        .haddr_i22(haddr22),
        .hsel_i22(|hsel22)
    );


  ahb_litemaster_monitor22 i_ahbMasterMonitor22 (
          .hclk_i22(hclk22),
          .hresetn_i22(n_preset22),
          .hresp_i22(smc_hresp22),
          .hready_i22(smc_hready22),
          .hrdata_i22(smc_hrdata22),
          .hlock22(1'b0),
          .hwdata22(hwdata22),
          .hprot22(4'b0),
          .hburst22(3'b0),
          .hsize22(hsize22),
          .hwrite22(hwrite22),
          .htrans22(htrans22),
          .haddr22(haddr22)
          );



  `endif



endmodule
