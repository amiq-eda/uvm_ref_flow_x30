//File30 name   : smc_ahb_lite_if30.v
//Title30       : 
//Created30     : 1999
//Description30 : AMBA30 AHB30 Interface30.
//            : Static30 Memory Controller30.
//            : This30 block provides30 the AHB30 interface. 
//            : All AHB30 specific30 signals30 are contained in this
//            : block.
//            : All address decoding30 for the SMC30 module is 
//            : done in
//            : this module and chip30 select30 signals30 generated30
//            : as well30 as an address valid (SMC_valid30) signal30
//            : back to the AHB30 decoder30
//Notes30       : 
//----------------------------------------------------------------------
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------



`include "smc_defs_lite30.v"

//ahb30 interface
  module smc_ahb_lite_if30  (

                      //inputs30

                      hclk30, 
                      n_sys_reset30, 
                      haddr30, 
                      hsel30,
                      htrans30, 
                      hwrite30, 
                      hsize30, 
                      hwdata30,  
                      hready30,  
  
                      //outputs30
  
                      smc_idle30,
                      read_data30, 
                      mac_done30, 
                      smc_done30, 
                      xfer_size30, 
                      n_read30, 
                      new_access30, 
                      addr, 
                      smc_hrdata30, 
                      smc_hready30,
                      smc_hresp30,
                      smc_valid30, 
                      cs, 
                      write_data30 
                      );
  
  
//include files


//----------------------------------------------------------------------


//System30 I30/O30

  input         hclk30;                   // AHB30 System30 clock30
  input         n_sys_reset30;            // AHB30 System30 reset (Active30 LOW30)
 

//AHB30 I30/O30

  input  [31:0]            haddr30;         // AHB30 Address
  input  [1:0]             htrans30;        // AHB30 transfer30 type
  input                    hwrite30;        // AHB30 read/write indication30
  input  [2:0]             hsize30;         // AHB30 transfer30 size
  input  [31:0]            hwdata30;        // AHB30 write data
  input                    hready30;        // AHB30 Muxed30 ready signal30
  output [31:0]            smc_hrdata30;    // smc30 read data back to AHB30
                                             //  master30
  output                   smc_hready30;    // smc30 ready signal30
  output [1:0]             smc_hresp30;     // AHB30 Response30 signal30
  output                   smc_valid30;     // Ack30 to AHB30

//other I30/O30
   
  input                    smc_idle30;      // idle30 state
  input                    smc_done30;      // Asserted30 during 
                                          // last cycle of an access
  input                    mac_done30;      // End30 of all transfers30
  input [31:0]             read_data30;     // Data at internal Bus30
  input               hsel30;          // Chip30 Selects30
   

  output [1:0]             xfer_size30;     // Store30 size for MAC30
  output [31:0]            addr;          // address
  output              cs;          // chip30 selects30 for external30
                                              //  memories
  output [31:0]            write_data30;    // Data to External30 Bus30
  output                   n_read30;        // Active30 low30 read signal30 
  output                   new_access30;    // New30 AHB30 valid access to
                                              //  smc30 detected




// Address Config30







//----------------------------------------------------------------------
// Signal30 declarations30
//----------------------------------------------------------------------

// Output30 register declarations30

// Bus30 Interface30

  reg  [31:0]              smc_hrdata30;  // smc30 read data back to
                                           //  AHB30 master30
  reg                      smc_hready30;  // smc30 ready signal30
  reg  [1:0]               smc_hresp30;   // AHB30 Response30 signal30
  reg                      smc_valid30;   // Ack30 to AHB30

// Internal register declarations30

// Bus30 Interface30

  reg                      new_access30;  // New30 AHB30 valid access
                                           //  to smc30 detected
                                           //  cfg block
  reg  [31:0]              addr;        // Copy30 of address
  reg  [31:0]              write_data30;  // Data to External30 Bus30
  reg  [7:0]               int_cs30;      // Chip30(bank30) Select30 Lines30
  wire                cs;          // Chip30(bank30) Select30 Lines30
  reg  [1:0]               xfer_size30;   // Width30 of current transfer30
  reg                      n_read30;      // Active30 low30 read signal30   
  reg                      r_ready30;     // registered ready signal30   
  reg                      r_hresp30;     // Two30 cycle hresp30 on error
  reg                      mis_err30;     // Misalignment30
  reg                      dis_err30;     // error

// End30 Bus30 Interface30



//----------------------------------------------------------------------
// Beginning30 of main30 code30
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// valid access control30 - AHB30 Interface30 (AHB30 Specific30)
//----------------------------------------------------------------------
// Generates30 the stobes30 required30 to start the smc30 state machine30
// Generates30 all AHB30 responses30.
//----------------------------------------------------------------------

   always @(hsize30)

     begin
     
      xfer_size30 = hsize30[1:0];

     end
   
//----------------------------------------------------------------------
//addr
//----------------------------------------------------------------------

   always @(haddr30)
     
     begin
        
        addr = haddr30;
        
     end
   
//----------------------------------------------------------------------
//chip30 select30 generation30
//----------------------------------------------------------------------

   assign cs = ( hsel30 ) ;
    
//----------------------------------------------------------------------
// detect30 a valid access
//----------------------------------------------------------------------

   always @(cs or hready30 or htrans30 or mis_err30)
     
     begin
             
       if (((htrans30 == `TRN_NONSEQ30) | (htrans30 == `TRN_SEQ30)) &
            (cs != 'd0) & hready30 & ~mis_err30)
          
          begin
             
             smc_valid30 = 1'b1;
             
               
             new_access30 = 1'b1;
             
             
          end
             
       else
          
          begin
             
             smc_valid30 = 1'b0;
             new_access30 = 1'b0;
             
          end
             
     end

//----------------------------------------------------------------------
// Error detection30
//----------------------------------------------------------------------

   always @(haddr30 or hsize30 or htrans30 or cs)
     
     begin
             
        if ((((haddr30[0] != 1'd0) & (hsize30 == `SZ_HALF30))      |
             ((haddr30[1:0] != 2'd0) & (hsize30 == `SZ_WORD30)))    &
            ((htrans30 == `TRN_NONSEQ30) | (htrans30 == `TRN_SEQ30)) &
            (cs != 1'b0) )
          
           mis_err30 = 1'h1;
             
        else
          
           mis_err30 = 1'h0;

     end 
   
//----------------------------------------------------------------------
// Disable30 detection30
//----------------------------------------------------------------------

   always @(htrans30 or cs or smc_idle30 or hready30)
     
     begin
             
           dis_err30 = 1'h0;
             
     end 
   
//----------------------------------------------------------------------
// Response30
//----------------------------------------------------------------------

   always @(posedge hclk30 or negedge n_sys_reset30)
     
     begin
             
        if (~n_sys_reset30)
          
            begin
             
               smc_hresp30 <= `RSP_OKAY30;
               r_hresp30 <= 1'd0;
             
            end
             
        else if (mis_err30 | dis_err30)
          
            begin
             
               r_hresp30 <= 1'd1;
               smc_hresp30 <= `RSP_ERROR30;
             
            end
             
        else if (r_hresp30 == 1'd1)
          
           begin
             
              smc_hresp30 <= `RSP_ERROR30;
              r_hresp30 <= 1'd0;
             
           end
             
        else
          
           begin
             
              smc_hresp30 <= `RSP_OKAY30;
              r_hresp30 <= 1'd0;
             
           end
             
     end
   
//----------------------------------------------------------------------
// assign read access sense
//----------------------------------------------------------------------

   always @(hwrite30)
     
     begin
             
        n_read30 = hwrite30;
             
     end

//----------------------------------------------------------------------
// AHB30 ready signal30
//----------------------------------------------------------------------

   always @(posedge hclk30 or negedge n_sys_reset30)
     
     begin
             
        if (~n_sys_reset30)
          
           r_ready30 <= 1'b1;
             
        else if ((((htrans30 == `TRN_IDLE30) | (htrans30 == `TRN_BUSY30)) & 
                  (cs != 1'b0) & hready30 & ~mis_err30 & 
                  ~dis_err30) | r_hresp30 | (hsel30 == 1'b0) )
          
           r_ready30 <= 1'b1;
             
        else
          
           r_ready30 <= 1'b0;
             
     end
 
//----------------------------------------------------------------------
//smc30 ready
//----------------------------------------------------------------------

   always @(r_ready30 or smc_done30 or mac_done30)
     
     begin
             
        smc_hready30 = r_ready30 | (smc_done30 & mac_done30);
             
     end
   
//----------------------------------------------------------------------
//read data
//----------------------------------------------------------------------
   
   always @(read_data30)
     
      smc_hrdata30 = read_data30;

//----------------------------------------------------------------------
//write data
//----------------------------------------------------------------------

   always @(hwdata30)
     
      write_data30 = hwdata30;
   


endmodule

