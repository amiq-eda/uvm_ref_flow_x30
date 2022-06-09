//File26 name   : smc_ahb_lite_if26.v
//Title26       : 
//Created26     : 1999
//Description26 : AMBA26 AHB26 Interface26.
//            : Static26 Memory Controller26.
//            : This26 block provides26 the AHB26 interface. 
//            : All AHB26 specific26 signals26 are contained in this
//            : block.
//            : All address decoding26 for the SMC26 module is 
//            : done in
//            : this module and chip26 select26 signals26 generated26
//            : as well26 as an address valid (SMC_valid26) signal26
//            : back to the AHB26 decoder26
//Notes26       : 
//----------------------------------------------------------------------
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------



`include "smc_defs_lite26.v"

//ahb26 interface
  module smc_ahb_lite_if26  (

                      //inputs26

                      hclk26, 
                      n_sys_reset26, 
                      haddr26, 
                      hsel26,
                      htrans26, 
                      hwrite26, 
                      hsize26, 
                      hwdata26,  
                      hready26,  
  
                      //outputs26
  
                      smc_idle26,
                      read_data26, 
                      mac_done26, 
                      smc_done26, 
                      xfer_size26, 
                      n_read26, 
                      new_access26, 
                      addr, 
                      smc_hrdata26, 
                      smc_hready26,
                      smc_hresp26,
                      smc_valid26, 
                      cs, 
                      write_data26 
                      );
  
  
//include files


//----------------------------------------------------------------------


//System26 I26/O26

  input         hclk26;                   // AHB26 System26 clock26
  input         n_sys_reset26;            // AHB26 System26 reset (Active26 LOW26)
 

//AHB26 I26/O26

  input  [31:0]            haddr26;         // AHB26 Address
  input  [1:0]             htrans26;        // AHB26 transfer26 type
  input                    hwrite26;        // AHB26 read/write indication26
  input  [2:0]             hsize26;         // AHB26 transfer26 size
  input  [31:0]            hwdata26;        // AHB26 write data
  input                    hready26;        // AHB26 Muxed26 ready signal26
  output [31:0]            smc_hrdata26;    // smc26 read data back to AHB26
                                             //  master26
  output                   smc_hready26;    // smc26 ready signal26
  output [1:0]             smc_hresp26;     // AHB26 Response26 signal26
  output                   smc_valid26;     // Ack26 to AHB26

//other I26/O26
   
  input                    smc_idle26;      // idle26 state
  input                    smc_done26;      // Asserted26 during 
                                          // last cycle of an access
  input                    mac_done26;      // End26 of all transfers26
  input [31:0]             read_data26;     // Data at internal Bus26
  input               hsel26;          // Chip26 Selects26
   

  output [1:0]             xfer_size26;     // Store26 size for MAC26
  output [31:0]            addr;          // address
  output              cs;          // chip26 selects26 for external26
                                              //  memories
  output [31:0]            write_data26;    // Data to External26 Bus26
  output                   n_read26;        // Active26 low26 read signal26 
  output                   new_access26;    // New26 AHB26 valid access to
                                              //  smc26 detected




// Address Config26







//----------------------------------------------------------------------
// Signal26 declarations26
//----------------------------------------------------------------------

// Output26 register declarations26

// Bus26 Interface26

  reg  [31:0]              smc_hrdata26;  // smc26 read data back to
                                           //  AHB26 master26
  reg                      smc_hready26;  // smc26 ready signal26
  reg  [1:0]               smc_hresp26;   // AHB26 Response26 signal26
  reg                      smc_valid26;   // Ack26 to AHB26

// Internal register declarations26

// Bus26 Interface26

  reg                      new_access26;  // New26 AHB26 valid access
                                           //  to smc26 detected
                                           //  cfg block
  reg  [31:0]              addr;        // Copy26 of address
  reg  [31:0]              write_data26;  // Data to External26 Bus26
  reg  [7:0]               int_cs26;      // Chip26(bank26) Select26 Lines26
  wire                cs;          // Chip26(bank26) Select26 Lines26
  reg  [1:0]               xfer_size26;   // Width26 of current transfer26
  reg                      n_read26;      // Active26 low26 read signal26   
  reg                      r_ready26;     // registered ready signal26   
  reg                      r_hresp26;     // Two26 cycle hresp26 on error
  reg                      mis_err26;     // Misalignment26
  reg                      dis_err26;     // error

// End26 Bus26 Interface26



//----------------------------------------------------------------------
// Beginning26 of main26 code26
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// valid access control26 - AHB26 Interface26 (AHB26 Specific26)
//----------------------------------------------------------------------
// Generates26 the stobes26 required26 to start the smc26 state machine26
// Generates26 all AHB26 responses26.
//----------------------------------------------------------------------

   always @(hsize26)

     begin
     
      xfer_size26 = hsize26[1:0];

     end
   
//----------------------------------------------------------------------
//addr
//----------------------------------------------------------------------

   always @(haddr26)
     
     begin
        
        addr = haddr26;
        
     end
   
//----------------------------------------------------------------------
//chip26 select26 generation26
//----------------------------------------------------------------------

   assign cs = ( hsel26 ) ;
    
//----------------------------------------------------------------------
// detect26 a valid access
//----------------------------------------------------------------------

   always @(cs or hready26 or htrans26 or mis_err26)
     
     begin
             
       if (((htrans26 == `TRN_NONSEQ26) | (htrans26 == `TRN_SEQ26)) &
            (cs != 'd0) & hready26 & ~mis_err26)
          
          begin
             
             smc_valid26 = 1'b1;
             
               
             new_access26 = 1'b1;
             
             
          end
             
       else
          
          begin
             
             smc_valid26 = 1'b0;
             new_access26 = 1'b0;
             
          end
             
     end

//----------------------------------------------------------------------
// Error detection26
//----------------------------------------------------------------------

   always @(haddr26 or hsize26 or htrans26 or cs)
     
     begin
             
        if ((((haddr26[0] != 1'd0) & (hsize26 == `SZ_HALF26))      |
             ((haddr26[1:0] != 2'd0) & (hsize26 == `SZ_WORD26)))    &
            ((htrans26 == `TRN_NONSEQ26) | (htrans26 == `TRN_SEQ26)) &
            (cs != 1'b0) )
          
           mis_err26 = 1'h1;
             
        else
          
           mis_err26 = 1'h0;

     end 
   
//----------------------------------------------------------------------
// Disable26 detection26
//----------------------------------------------------------------------

   always @(htrans26 or cs or smc_idle26 or hready26)
     
     begin
             
           dis_err26 = 1'h0;
             
     end 
   
//----------------------------------------------------------------------
// Response26
//----------------------------------------------------------------------

   always @(posedge hclk26 or negedge n_sys_reset26)
     
     begin
             
        if (~n_sys_reset26)
          
            begin
             
               smc_hresp26 <= `RSP_OKAY26;
               r_hresp26 <= 1'd0;
             
            end
             
        else if (mis_err26 | dis_err26)
          
            begin
             
               r_hresp26 <= 1'd1;
               smc_hresp26 <= `RSP_ERROR26;
             
            end
             
        else if (r_hresp26 == 1'd1)
          
           begin
             
              smc_hresp26 <= `RSP_ERROR26;
              r_hresp26 <= 1'd0;
             
           end
             
        else
          
           begin
             
              smc_hresp26 <= `RSP_OKAY26;
              r_hresp26 <= 1'd0;
             
           end
             
     end
   
//----------------------------------------------------------------------
// assign read access sense
//----------------------------------------------------------------------

   always @(hwrite26)
     
     begin
             
        n_read26 = hwrite26;
             
     end

//----------------------------------------------------------------------
// AHB26 ready signal26
//----------------------------------------------------------------------

   always @(posedge hclk26 or negedge n_sys_reset26)
     
     begin
             
        if (~n_sys_reset26)
          
           r_ready26 <= 1'b1;
             
        else if ((((htrans26 == `TRN_IDLE26) | (htrans26 == `TRN_BUSY26)) & 
                  (cs != 1'b0) & hready26 & ~mis_err26 & 
                  ~dis_err26) | r_hresp26 | (hsel26 == 1'b0) )
          
           r_ready26 <= 1'b1;
             
        else
          
           r_ready26 <= 1'b0;
             
     end
 
//----------------------------------------------------------------------
//smc26 ready
//----------------------------------------------------------------------

   always @(r_ready26 or smc_done26 or mac_done26)
     
     begin
             
        smc_hready26 = r_ready26 | (smc_done26 & mac_done26);
             
     end
   
//----------------------------------------------------------------------
//read data
//----------------------------------------------------------------------
   
   always @(read_data26)
     
      smc_hrdata26 = read_data26;

//----------------------------------------------------------------------
//write data
//----------------------------------------------------------------------

   always @(hwdata26)
     
      write_data26 = hwdata26;
   


endmodule

