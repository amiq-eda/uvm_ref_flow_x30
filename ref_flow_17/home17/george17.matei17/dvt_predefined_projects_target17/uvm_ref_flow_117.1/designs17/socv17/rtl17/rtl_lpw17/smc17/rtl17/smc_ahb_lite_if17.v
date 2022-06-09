//File17 name   : smc_ahb_lite_if17.v
//Title17       : 
//Created17     : 1999
//Description17 : AMBA17 AHB17 Interface17.
//            : Static17 Memory Controller17.
//            : This17 block provides17 the AHB17 interface. 
//            : All AHB17 specific17 signals17 are contained in this
//            : block.
//            : All address decoding17 for the SMC17 module is 
//            : done in
//            : this module and chip17 select17 signals17 generated17
//            : as well17 as an address valid (SMC_valid17) signal17
//            : back to the AHB17 decoder17
//Notes17       : 
//----------------------------------------------------------------------
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------



`include "smc_defs_lite17.v"

//ahb17 interface
  module smc_ahb_lite_if17  (

                      //inputs17

                      hclk17, 
                      n_sys_reset17, 
                      haddr17, 
                      hsel17,
                      htrans17, 
                      hwrite17, 
                      hsize17, 
                      hwdata17,  
                      hready17,  
  
                      //outputs17
  
                      smc_idle17,
                      read_data17, 
                      mac_done17, 
                      smc_done17, 
                      xfer_size17, 
                      n_read17, 
                      new_access17, 
                      addr, 
                      smc_hrdata17, 
                      smc_hready17,
                      smc_hresp17,
                      smc_valid17, 
                      cs, 
                      write_data17 
                      );
  
  
//include files


//----------------------------------------------------------------------


//System17 I17/O17

  input         hclk17;                   // AHB17 System17 clock17
  input         n_sys_reset17;            // AHB17 System17 reset (Active17 LOW17)
 

//AHB17 I17/O17

  input  [31:0]            haddr17;         // AHB17 Address
  input  [1:0]             htrans17;        // AHB17 transfer17 type
  input                    hwrite17;        // AHB17 read/write indication17
  input  [2:0]             hsize17;         // AHB17 transfer17 size
  input  [31:0]            hwdata17;        // AHB17 write data
  input                    hready17;        // AHB17 Muxed17 ready signal17
  output [31:0]            smc_hrdata17;    // smc17 read data back to AHB17
                                             //  master17
  output                   smc_hready17;    // smc17 ready signal17
  output [1:0]             smc_hresp17;     // AHB17 Response17 signal17
  output                   smc_valid17;     // Ack17 to AHB17

//other I17/O17
   
  input                    smc_idle17;      // idle17 state
  input                    smc_done17;      // Asserted17 during 
                                          // last cycle of an access
  input                    mac_done17;      // End17 of all transfers17
  input [31:0]             read_data17;     // Data at internal Bus17
  input               hsel17;          // Chip17 Selects17
   

  output [1:0]             xfer_size17;     // Store17 size for MAC17
  output [31:0]            addr;          // address
  output              cs;          // chip17 selects17 for external17
                                              //  memories
  output [31:0]            write_data17;    // Data to External17 Bus17
  output                   n_read17;        // Active17 low17 read signal17 
  output                   new_access17;    // New17 AHB17 valid access to
                                              //  smc17 detected




// Address Config17







//----------------------------------------------------------------------
// Signal17 declarations17
//----------------------------------------------------------------------

// Output17 register declarations17

// Bus17 Interface17

  reg  [31:0]              smc_hrdata17;  // smc17 read data back to
                                           //  AHB17 master17
  reg                      smc_hready17;  // smc17 ready signal17
  reg  [1:0]               smc_hresp17;   // AHB17 Response17 signal17
  reg                      smc_valid17;   // Ack17 to AHB17

// Internal register declarations17

// Bus17 Interface17

  reg                      new_access17;  // New17 AHB17 valid access
                                           //  to smc17 detected
                                           //  cfg block
  reg  [31:0]              addr;        // Copy17 of address
  reg  [31:0]              write_data17;  // Data to External17 Bus17
  reg  [7:0]               int_cs17;      // Chip17(bank17) Select17 Lines17
  wire                cs;          // Chip17(bank17) Select17 Lines17
  reg  [1:0]               xfer_size17;   // Width17 of current transfer17
  reg                      n_read17;      // Active17 low17 read signal17   
  reg                      r_ready17;     // registered ready signal17   
  reg                      r_hresp17;     // Two17 cycle hresp17 on error
  reg                      mis_err17;     // Misalignment17
  reg                      dis_err17;     // error

// End17 Bus17 Interface17



//----------------------------------------------------------------------
// Beginning17 of main17 code17
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// valid access control17 - AHB17 Interface17 (AHB17 Specific17)
//----------------------------------------------------------------------
// Generates17 the stobes17 required17 to start the smc17 state machine17
// Generates17 all AHB17 responses17.
//----------------------------------------------------------------------

   always @(hsize17)

     begin
     
      xfer_size17 = hsize17[1:0];

     end
   
//----------------------------------------------------------------------
//addr
//----------------------------------------------------------------------

   always @(haddr17)
     
     begin
        
        addr = haddr17;
        
     end
   
//----------------------------------------------------------------------
//chip17 select17 generation17
//----------------------------------------------------------------------

   assign cs = ( hsel17 ) ;
    
//----------------------------------------------------------------------
// detect17 a valid access
//----------------------------------------------------------------------

   always @(cs or hready17 or htrans17 or mis_err17)
     
     begin
             
       if (((htrans17 == `TRN_NONSEQ17) | (htrans17 == `TRN_SEQ17)) &
            (cs != 'd0) & hready17 & ~mis_err17)
          
          begin
             
             smc_valid17 = 1'b1;
             
               
             new_access17 = 1'b1;
             
             
          end
             
       else
          
          begin
             
             smc_valid17 = 1'b0;
             new_access17 = 1'b0;
             
          end
             
     end

//----------------------------------------------------------------------
// Error detection17
//----------------------------------------------------------------------

   always @(haddr17 or hsize17 or htrans17 or cs)
     
     begin
             
        if ((((haddr17[0] != 1'd0) & (hsize17 == `SZ_HALF17))      |
             ((haddr17[1:0] != 2'd0) & (hsize17 == `SZ_WORD17)))    &
            ((htrans17 == `TRN_NONSEQ17) | (htrans17 == `TRN_SEQ17)) &
            (cs != 1'b0) )
          
           mis_err17 = 1'h1;
             
        else
          
           mis_err17 = 1'h0;

     end 
   
//----------------------------------------------------------------------
// Disable17 detection17
//----------------------------------------------------------------------

   always @(htrans17 or cs or smc_idle17 or hready17)
     
     begin
             
           dis_err17 = 1'h0;
             
     end 
   
//----------------------------------------------------------------------
// Response17
//----------------------------------------------------------------------

   always @(posedge hclk17 or negedge n_sys_reset17)
     
     begin
             
        if (~n_sys_reset17)
          
            begin
             
               smc_hresp17 <= `RSP_OKAY17;
               r_hresp17 <= 1'd0;
             
            end
             
        else if (mis_err17 | dis_err17)
          
            begin
             
               r_hresp17 <= 1'd1;
               smc_hresp17 <= `RSP_ERROR17;
             
            end
             
        else if (r_hresp17 == 1'd1)
          
           begin
             
              smc_hresp17 <= `RSP_ERROR17;
              r_hresp17 <= 1'd0;
             
           end
             
        else
          
           begin
             
              smc_hresp17 <= `RSP_OKAY17;
              r_hresp17 <= 1'd0;
             
           end
             
     end
   
//----------------------------------------------------------------------
// assign read access sense
//----------------------------------------------------------------------

   always @(hwrite17)
     
     begin
             
        n_read17 = hwrite17;
             
     end

//----------------------------------------------------------------------
// AHB17 ready signal17
//----------------------------------------------------------------------

   always @(posedge hclk17 or negedge n_sys_reset17)
     
     begin
             
        if (~n_sys_reset17)
          
           r_ready17 <= 1'b1;
             
        else if ((((htrans17 == `TRN_IDLE17) | (htrans17 == `TRN_BUSY17)) & 
                  (cs != 1'b0) & hready17 & ~mis_err17 & 
                  ~dis_err17) | r_hresp17 | (hsel17 == 1'b0) )
          
           r_ready17 <= 1'b1;
             
        else
          
           r_ready17 <= 1'b0;
             
     end
 
//----------------------------------------------------------------------
//smc17 ready
//----------------------------------------------------------------------

   always @(r_ready17 or smc_done17 or mac_done17)
     
     begin
             
        smc_hready17 = r_ready17 | (smc_done17 & mac_done17);
             
     end
   
//----------------------------------------------------------------------
//read data
//----------------------------------------------------------------------
   
   always @(read_data17)
     
      smc_hrdata17 = read_data17;

//----------------------------------------------------------------------
//write data
//----------------------------------------------------------------------

   always @(hwdata17)
     
      write_data17 = hwdata17;
   


endmodule

