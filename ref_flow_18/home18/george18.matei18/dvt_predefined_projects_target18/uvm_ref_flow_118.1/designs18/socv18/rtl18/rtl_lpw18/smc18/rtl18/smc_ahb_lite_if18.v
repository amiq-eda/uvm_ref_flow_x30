//File18 name   : smc_ahb_lite_if18.v
//Title18       : 
//Created18     : 1999
//Description18 : AMBA18 AHB18 Interface18.
//            : Static18 Memory Controller18.
//            : This18 block provides18 the AHB18 interface. 
//            : All AHB18 specific18 signals18 are contained in this
//            : block.
//            : All address decoding18 for the SMC18 module is 
//            : done in
//            : this module and chip18 select18 signals18 generated18
//            : as well18 as an address valid (SMC_valid18) signal18
//            : back to the AHB18 decoder18
//Notes18       : 
//----------------------------------------------------------------------
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------



`include "smc_defs_lite18.v"

//ahb18 interface
  module smc_ahb_lite_if18  (

                      //inputs18

                      hclk18, 
                      n_sys_reset18, 
                      haddr18, 
                      hsel18,
                      htrans18, 
                      hwrite18, 
                      hsize18, 
                      hwdata18,  
                      hready18,  
  
                      //outputs18
  
                      smc_idle18,
                      read_data18, 
                      mac_done18, 
                      smc_done18, 
                      xfer_size18, 
                      n_read18, 
                      new_access18, 
                      addr, 
                      smc_hrdata18, 
                      smc_hready18,
                      smc_hresp18,
                      smc_valid18, 
                      cs, 
                      write_data18 
                      );
  
  
//include files


//----------------------------------------------------------------------


//System18 I18/O18

  input         hclk18;                   // AHB18 System18 clock18
  input         n_sys_reset18;            // AHB18 System18 reset (Active18 LOW18)
 

//AHB18 I18/O18

  input  [31:0]            haddr18;         // AHB18 Address
  input  [1:0]             htrans18;        // AHB18 transfer18 type
  input                    hwrite18;        // AHB18 read/write indication18
  input  [2:0]             hsize18;         // AHB18 transfer18 size
  input  [31:0]            hwdata18;        // AHB18 write data
  input                    hready18;        // AHB18 Muxed18 ready signal18
  output [31:0]            smc_hrdata18;    // smc18 read data back to AHB18
                                             //  master18
  output                   smc_hready18;    // smc18 ready signal18
  output [1:0]             smc_hresp18;     // AHB18 Response18 signal18
  output                   smc_valid18;     // Ack18 to AHB18

//other I18/O18
   
  input                    smc_idle18;      // idle18 state
  input                    smc_done18;      // Asserted18 during 
                                          // last cycle of an access
  input                    mac_done18;      // End18 of all transfers18
  input [31:0]             read_data18;     // Data at internal Bus18
  input               hsel18;          // Chip18 Selects18
   

  output [1:0]             xfer_size18;     // Store18 size for MAC18
  output [31:0]            addr;          // address
  output              cs;          // chip18 selects18 for external18
                                              //  memories
  output [31:0]            write_data18;    // Data to External18 Bus18
  output                   n_read18;        // Active18 low18 read signal18 
  output                   new_access18;    // New18 AHB18 valid access to
                                              //  smc18 detected




// Address Config18







//----------------------------------------------------------------------
// Signal18 declarations18
//----------------------------------------------------------------------

// Output18 register declarations18

// Bus18 Interface18

  reg  [31:0]              smc_hrdata18;  // smc18 read data back to
                                           //  AHB18 master18
  reg                      smc_hready18;  // smc18 ready signal18
  reg  [1:0]               smc_hresp18;   // AHB18 Response18 signal18
  reg                      smc_valid18;   // Ack18 to AHB18

// Internal register declarations18

// Bus18 Interface18

  reg                      new_access18;  // New18 AHB18 valid access
                                           //  to smc18 detected
                                           //  cfg block
  reg  [31:0]              addr;        // Copy18 of address
  reg  [31:0]              write_data18;  // Data to External18 Bus18
  reg  [7:0]               int_cs18;      // Chip18(bank18) Select18 Lines18
  wire                cs;          // Chip18(bank18) Select18 Lines18
  reg  [1:0]               xfer_size18;   // Width18 of current transfer18
  reg                      n_read18;      // Active18 low18 read signal18   
  reg                      r_ready18;     // registered ready signal18   
  reg                      r_hresp18;     // Two18 cycle hresp18 on error
  reg                      mis_err18;     // Misalignment18
  reg                      dis_err18;     // error

// End18 Bus18 Interface18



//----------------------------------------------------------------------
// Beginning18 of main18 code18
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// valid access control18 - AHB18 Interface18 (AHB18 Specific18)
//----------------------------------------------------------------------
// Generates18 the stobes18 required18 to start the smc18 state machine18
// Generates18 all AHB18 responses18.
//----------------------------------------------------------------------

   always @(hsize18)

     begin
     
      xfer_size18 = hsize18[1:0];

     end
   
//----------------------------------------------------------------------
//addr
//----------------------------------------------------------------------

   always @(haddr18)
     
     begin
        
        addr = haddr18;
        
     end
   
//----------------------------------------------------------------------
//chip18 select18 generation18
//----------------------------------------------------------------------

   assign cs = ( hsel18 ) ;
    
//----------------------------------------------------------------------
// detect18 a valid access
//----------------------------------------------------------------------

   always @(cs or hready18 or htrans18 or mis_err18)
     
     begin
             
       if (((htrans18 == `TRN_NONSEQ18) | (htrans18 == `TRN_SEQ18)) &
            (cs != 'd0) & hready18 & ~mis_err18)
          
          begin
             
             smc_valid18 = 1'b1;
             
               
             new_access18 = 1'b1;
             
             
          end
             
       else
          
          begin
             
             smc_valid18 = 1'b0;
             new_access18 = 1'b0;
             
          end
             
     end

//----------------------------------------------------------------------
// Error detection18
//----------------------------------------------------------------------

   always @(haddr18 or hsize18 or htrans18 or cs)
     
     begin
             
        if ((((haddr18[0] != 1'd0) & (hsize18 == `SZ_HALF18))      |
             ((haddr18[1:0] != 2'd0) & (hsize18 == `SZ_WORD18)))    &
            ((htrans18 == `TRN_NONSEQ18) | (htrans18 == `TRN_SEQ18)) &
            (cs != 1'b0) )
          
           mis_err18 = 1'h1;
             
        else
          
           mis_err18 = 1'h0;

     end 
   
//----------------------------------------------------------------------
// Disable18 detection18
//----------------------------------------------------------------------

   always @(htrans18 or cs or smc_idle18 or hready18)
     
     begin
             
           dis_err18 = 1'h0;
             
     end 
   
//----------------------------------------------------------------------
// Response18
//----------------------------------------------------------------------

   always @(posedge hclk18 or negedge n_sys_reset18)
     
     begin
             
        if (~n_sys_reset18)
          
            begin
             
               smc_hresp18 <= `RSP_OKAY18;
               r_hresp18 <= 1'd0;
             
            end
             
        else if (mis_err18 | dis_err18)
          
            begin
             
               r_hresp18 <= 1'd1;
               smc_hresp18 <= `RSP_ERROR18;
             
            end
             
        else if (r_hresp18 == 1'd1)
          
           begin
             
              smc_hresp18 <= `RSP_ERROR18;
              r_hresp18 <= 1'd0;
             
           end
             
        else
          
           begin
             
              smc_hresp18 <= `RSP_OKAY18;
              r_hresp18 <= 1'd0;
             
           end
             
     end
   
//----------------------------------------------------------------------
// assign read access sense
//----------------------------------------------------------------------

   always @(hwrite18)
     
     begin
             
        n_read18 = hwrite18;
             
     end

//----------------------------------------------------------------------
// AHB18 ready signal18
//----------------------------------------------------------------------

   always @(posedge hclk18 or negedge n_sys_reset18)
     
     begin
             
        if (~n_sys_reset18)
          
           r_ready18 <= 1'b1;
             
        else if ((((htrans18 == `TRN_IDLE18) | (htrans18 == `TRN_BUSY18)) & 
                  (cs != 1'b0) & hready18 & ~mis_err18 & 
                  ~dis_err18) | r_hresp18 | (hsel18 == 1'b0) )
          
           r_ready18 <= 1'b1;
             
        else
          
           r_ready18 <= 1'b0;
             
     end
 
//----------------------------------------------------------------------
//smc18 ready
//----------------------------------------------------------------------

   always @(r_ready18 or smc_done18 or mac_done18)
     
     begin
             
        smc_hready18 = r_ready18 | (smc_done18 & mac_done18);
             
     end
   
//----------------------------------------------------------------------
//read data
//----------------------------------------------------------------------
   
   always @(read_data18)
     
      smc_hrdata18 = read_data18;

//----------------------------------------------------------------------
//write data
//----------------------------------------------------------------------

   always @(hwdata18)
     
      write_data18 = hwdata18;
   


endmodule

