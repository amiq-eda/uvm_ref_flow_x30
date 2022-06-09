//File20 name   : smc_ahb_lite_if20.v
//Title20       : 
//Created20     : 1999
//Description20 : AMBA20 AHB20 Interface20.
//            : Static20 Memory Controller20.
//            : This20 block provides20 the AHB20 interface. 
//            : All AHB20 specific20 signals20 are contained in this
//            : block.
//            : All address decoding20 for the SMC20 module is 
//            : done in
//            : this module and chip20 select20 signals20 generated20
//            : as well20 as an address valid (SMC_valid20) signal20
//            : back to the AHB20 decoder20
//Notes20       : 
//----------------------------------------------------------------------
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------



`include "smc_defs_lite20.v"

//ahb20 interface
  module smc_ahb_lite_if20  (

                      //inputs20

                      hclk20, 
                      n_sys_reset20, 
                      haddr20, 
                      hsel20,
                      htrans20, 
                      hwrite20, 
                      hsize20, 
                      hwdata20,  
                      hready20,  
  
                      //outputs20
  
                      smc_idle20,
                      read_data20, 
                      mac_done20, 
                      smc_done20, 
                      xfer_size20, 
                      n_read20, 
                      new_access20, 
                      addr, 
                      smc_hrdata20, 
                      smc_hready20,
                      smc_hresp20,
                      smc_valid20, 
                      cs, 
                      write_data20 
                      );
  
  
//include files


//----------------------------------------------------------------------


//System20 I20/O20

  input         hclk20;                   // AHB20 System20 clock20
  input         n_sys_reset20;            // AHB20 System20 reset (Active20 LOW20)
 

//AHB20 I20/O20

  input  [31:0]            haddr20;         // AHB20 Address
  input  [1:0]             htrans20;        // AHB20 transfer20 type
  input                    hwrite20;        // AHB20 read/write indication20
  input  [2:0]             hsize20;         // AHB20 transfer20 size
  input  [31:0]            hwdata20;        // AHB20 write data
  input                    hready20;        // AHB20 Muxed20 ready signal20
  output [31:0]            smc_hrdata20;    // smc20 read data back to AHB20
                                             //  master20
  output                   smc_hready20;    // smc20 ready signal20
  output [1:0]             smc_hresp20;     // AHB20 Response20 signal20
  output                   smc_valid20;     // Ack20 to AHB20

//other I20/O20
   
  input                    smc_idle20;      // idle20 state
  input                    smc_done20;      // Asserted20 during 
                                          // last cycle of an access
  input                    mac_done20;      // End20 of all transfers20
  input [31:0]             read_data20;     // Data at internal Bus20
  input               hsel20;          // Chip20 Selects20
   

  output [1:0]             xfer_size20;     // Store20 size for MAC20
  output [31:0]            addr;          // address
  output              cs;          // chip20 selects20 for external20
                                              //  memories
  output [31:0]            write_data20;    // Data to External20 Bus20
  output                   n_read20;        // Active20 low20 read signal20 
  output                   new_access20;    // New20 AHB20 valid access to
                                              //  smc20 detected




// Address Config20







//----------------------------------------------------------------------
// Signal20 declarations20
//----------------------------------------------------------------------

// Output20 register declarations20

// Bus20 Interface20

  reg  [31:0]              smc_hrdata20;  // smc20 read data back to
                                           //  AHB20 master20
  reg                      smc_hready20;  // smc20 ready signal20
  reg  [1:0]               smc_hresp20;   // AHB20 Response20 signal20
  reg                      smc_valid20;   // Ack20 to AHB20

// Internal register declarations20

// Bus20 Interface20

  reg                      new_access20;  // New20 AHB20 valid access
                                           //  to smc20 detected
                                           //  cfg block
  reg  [31:0]              addr;        // Copy20 of address
  reg  [31:0]              write_data20;  // Data to External20 Bus20
  reg  [7:0]               int_cs20;      // Chip20(bank20) Select20 Lines20
  wire                cs;          // Chip20(bank20) Select20 Lines20
  reg  [1:0]               xfer_size20;   // Width20 of current transfer20
  reg                      n_read20;      // Active20 low20 read signal20   
  reg                      r_ready20;     // registered ready signal20   
  reg                      r_hresp20;     // Two20 cycle hresp20 on error
  reg                      mis_err20;     // Misalignment20
  reg                      dis_err20;     // error

// End20 Bus20 Interface20



//----------------------------------------------------------------------
// Beginning20 of main20 code20
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// valid access control20 - AHB20 Interface20 (AHB20 Specific20)
//----------------------------------------------------------------------
// Generates20 the stobes20 required20 to start the smc20 state machine20
// Generates20 all AHB20 responses20.
//----------------------------------------------------------------------

   always @(hsize20)

     begin
     
      xfer_size20 = hsize20[1:0];

     end
   
//----------------------------------------------------------------------
//addr
//----------------------------------------------------------------------

   always @(haddr20)
     
     begin
        
        addr = haddr20;
        
     end
   
//----------------------------------------------------------------------
//chip20 select20 generation20
//----------------------------------------------------------------------

   assign cs = ( hsel20 ) ;
    
//----------------------------------------------------------------------
// detect20 a valid access
//----------------------------------------------------------------------

   always @(cs or hready20 or htrans20 or mis_err20)
     
     begin
             
       if (((htrans20 == `TRN_NONSEQ20) | (htrans20 == `TRN_SEQ20)) &
            (cs != 'd0) & hready20 & ~mis_err20)
          
          begin
             
             smc_valid20 = 1'b1;
             
               
             new_access20 = 1'b1;
             
             
          end
             
       else
          
          begin
             
             smc_valid20 = 1'b0;
             new_access20 = 1'b0;
             
          end
             
     end

//----------------------------------------------------------------------
// Error detection20
//----------------------------------------------------------------------

   always @(haddr20 or hsize20 or htrans20 or cs)
     
     begin
             
        if ((((haddr20[0] != 1'd0) & (hsize20 == `SZ_HALF20))      |
             ((haddr20[1:0] != 2'd0) & (hsize20 == `SZ_WORD20)))    &
            ((htrans20 == `TRN_NONSEQ20) | (htrans20 == `TRN_SEQ20)) &
            (cs != 1'b0) )
          
           mis_err20 = 1'h1;
             
        else
          
           mis_err20 = 1'h0;

     end 
   
//----------------------------------------------------------------------
// Disable20 detection20
//----------------------------------------------------------------------

   always @(htrans20 or cs or smc_idle20 or hready20)
     
     begin
             
           dis_err20 = 1'h0;
             
     end 
   
//----------------------------------------------------------------------
// Response20
//----------------------------------------------------------------------

   always @(posedge hclk20 or negedge n_sys_reset20)
     
     begin
             
        if (~n_sys_reset20)
          
            begin
             
               smc_hresp20 <= `RSP_OKAY20;
               r_hresp20 <= 1'd0;
             
            end
             
        else if (mis_err20 | dis_err20)
          
            begin
             
               r_hresp20 <= 1'd1;
               smc_hresp20 <= `RSP_ERROR20;
             
            end
             
        else if (r_hresp20 == 1'd1)
          
           begin
             
              smc_hresp20 <= `RSP_ERROR20;
              r_hresp20 <= 1'd0;
             
           end
             
        else
          
           begin
             
              smc_hresp20 <= `RSP_OKAY20;
              r_hresp20 <= 1'd0;
             
           end
             
     end
   
//----------------------------------------------------------------------
// assign read access sense
//----------------------------------------------------------------------

   always @(hwrite20)
     
     begin
             
        n_read20 = hwrite20;
             
     end

//----------------------------------------------------------------------
// AHB20 ready signal20
//----------------------------------------------------------------------

   always @(posedge hclk20 or negedge n_sys_reset20)
     
     begin
             
        if (~n_sys_reset20)
          
           r_ready20 <= 1'b1;
             
        else if ((((htrans20 == `TRN_IDLE20) | (htrans20 == `TRN_BUSY20)) & 
                  (cs != 1'b0) & hready20 & ~mis_err20 & 
                  ~dis_err20) | r_hresp20 | (hsel20 == 1'b0) )
          
           r_ready20 <= 1'b1;
             
        else
          
           r_ready20 <= 1'b0;
             
     end
 
//----------------------------------------------------------------------
//smc20 ready
//----------------------------------------------------------------------

   always @(r_ready20 or smc_done20 or mac_done20)
     
     begin
             
        smc_hready20 = r_ready20 | (smc_done20 & mac_done20);
             
     end
   
//----------------------------------------------------------------------
//read data
//----------------------------------------------------------------------
   
   always @(read_data20)
     
      smc_hrdata20 = read_data20;

//----------------------------------------------------------------------
//write data
//----------------------------------------------------------------------

   always @(hwdata20)
     
      write_data20 = hwdata20;
   


endmodule

