//File6 name   : smc_ahb_lite_if6.v
//Title6       : 
//Created6     : 1999
//Description6 : AMBA6 AHB6 Interface6.
//            : Static6 Memory Controller6.
//            : This6 block provides6 the AHB6 interface. 
//            : All AHB6 specific6 signals6 are contained in this
//            : block.
//            : All address decoding6 for the SMC6 module is 
//            : done in
//            : this module and chip6 select6 signals6 generated6
//            : as well6 as an address valid (SMC_valid6) signal6
//            : back to the AHB6 decoder6
//Notes6       : 
//----------------------------------------------------------------------
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------



`include "smc_defs_lite6.v"

//ahb6 interface
  module smc_ahb_lite_if6  (

                      //inputs6

                      hclk6, 
                      n_sys_reset6, 
                      haddr6, 
                      hsel6,
                      htrans6, 
                      hwrite6, 
                      hsize6, 
                      hwdata6,  
                      hready6,  
  
                      //outputs6
  
                      smc_idle6,
                      read_data6, 
                      mac_done6, 
                      smc_done6, 
                      xfer_size6, 
                      n_read6, 
                      new_access6, 
                      addr, 
                      smc_hrdata6, 
                      smc_hready6,
                      smc_hresp6,
                      smc_valid6, 
                      cs, 
                      write_data6 
                      );
  
  
//include files


//----------------------------------------------------------------------


//System6 I6/O6

  input         hclk6;                   // AHB6 System6 clock6
  input         n_sys_reset6;            // AHB6 System6 reset (Active6 LOW6)
 

//AHB6 I6/O6

  input  [31:0]            haddr6;         // AHB6 Address
  input  [1:0]             htrans6;        // AHB6 transfer6 type
  input                    hwrite6;        // AHB6 read/write indication6
  input  [2:0]             hsize6;         // AHB6 transfer6 size
  input  [31:0]            hwdata6;        // AHB6 write data
  input                    hready6;        // AHB6 Muxed6 ready signal6
  output [31:0]            smc_hrdata6;    // smc6 read data back to AHB6
                                             //  master6
  output                   smc_hready6;    // smc6 ready signal6
  output [1:0]             smc_hresp6;     // AHB6 Response6 signal6
  output                   smc_valid6;     // Ack6 to AHB6

//other I6/O6
   
  input                    smc_idle6;      // idle6 state
  input                    smc_done6;      // Asserted6 during 
                                          // last cycle of an access
  input                    mac_done6;      // End6 of all transfers6
  input [31:0]             read_data6;     // Data at internal Bus6
  input               hsel6;          // Chip6 Selects6
   

  output [1:0]             xfer_size6;     // Store6 size for MAC6
  output [31:0]            addr;          // address
  output              cs;          // chip6 selects6 for external6
                                              //  memories
  output [31:0]            write_data6;    // Data to External6 Bus6
  output                   n_read6;        // Active6 low6 read signal6 
  output                   new_access6;    // New6 AHB6 valid access to
                                              //  smc6 detected




// Address Config6







//----------------------------------------------------------------------
// Signal6 declarations6
//----------------------------------------------------------------------

// Output6 register declarations6

// Bus6 Interface6

  reg  [31:0]              smc_hrdata6;  // smc6 read data back to
                                           //  AHB6 master6
  reg                      smc_hready6;  // smc6 ready signal6
  reg  [1:0]               smc_hresp6;   // AHB6 Response6 signal6
  reg                      smc_valid6;   // Ack6 to AHB6

// Internal register declarations6

// Bus6 Interface6

  reg                      new_access6;  // New6 AHB6 valid access
                                           //  to smc6 detected
                                           //  cfg block
  reg  [31:0]              addr;        // Copy6 of address
  reg  [31:0]              write_data6;  // Data to External6 Bus6
  reg  [7:0]               int_cs6;      // Chip6(bank6) Select6 Lines6
  wire                cs;          // Chip6(bank6) Select6 Lines6
  reg  [1:0]               xfer_size6;   // Width6 of current transfer6
  reg                      n_read6;      // Active6 low6 read signal6   
  reg                      r_ready6;     // registered ready signal6   
  reg                      r_hresp6;     // Two6 cycle hresp6 on error
  reg                      mis_err6;     // Misalignment6
  reg                      dis_err6;     // error

// End6 Bus6 Interface6



//----------------------------------------------------------------------
// Beginning6 of main6 code6
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// valid access control6 - AHB6 Interface6 (AHB6 Specific6)
//----------------------------------------------------------------------
// Generates6 the stobes6 required6 to start the smc6 state machine6
// Generates6 all AHB6 responses6.
//----------------------------------------------------------------------

   always @(hsize6)

     begin
     
      xfer_size6 = hsize6[1:0];

     end
   
//----------------------------------------------------------------------
//addr
//----------------------------------------------------------------------

   always @(haddr6)
     
     begin
        
        addr = haddr6;
        
     end
   
//----------------------------------------------------------------------
//chip6 select6 generation6
//----------------------------------------------------------------------

   assign cs = ( hsel6 ) ;
    
//----------------------------------------------------------------------
// detect6 a valid access
//----------------------------------------------------------------------

   always @(cs or hready6 or htrans6 or mis_err6)
     
     begin
             
       if (((htrans6 == `TRN_NONSEQ6) | (htrans6 == `TRN_SEQ6)) &
            (cs != 'd0) & hready6 & ~mis_err6)
          
          begin
             
             smc_valid6 = 1'b1;
             
               
             new_access6 = 1'b1;
             
             
          end
             
       else
          
          begin
             
             smc_valid6 = 1'b0;
             new_access6 = 1'b0;
             
          end
             
     end

//----------------------------------------------------------------------
// Error detection6
//----------------------------------------------------------------------

   always @(haddr6 or hsize6 or htrans6 or cs)
     
     begin
             
        if ((((haddr6[0] != 1'd0) & (hsize6 == `SZ_HALF6))      |
             ((haddr6[1:0] != 2'd0) & (hsize6 == `SZ_WORD6)))    &
            ((htrans6 == `TRN_NONSEQ6) | (htrans6 == `TRN_SEQ6)) &
            (cs != 1'b0) )
          
           mis_err6 = 1'h1;
             
        else
          
           mis_err6 = 1'h0;

     end 
   
//----------------------------------------------------------------------
// Disable6 detection6
//----------------------------------------------------------------------

   always @(htrans6 or cs or smc_idle6 or hready6)
     
     begin
             
           dis_err6 = 1'h0;
             
     end 
   
//----------------------------------------------------------------------
// Response6
//----------------------------------------------------------------------

   always @(posedge hclk6 or negedge n_sys_reset6)
     
     begin
             
        if (~n_sys_reset6)
          
            begin
             
               smc_hresp6 <= `RSP_OKAY6;
               r_hresp6 <= 1'd0;
             
            end
             
        else if (mis_err6 | dis_err6)
          
            begin
             
               r_hresp6 <= 1'd1;
               smc_hresp6 <= `RSP_ERROR6;
             
            end
             
        else if (r_hresp6 == 1'd1)
          
           begin
             
              smc_hresp6 <= `RSP_ERROR6;
              r_hresp6 <= 1'd0;
             
           end
             
        else
          
           begin
             
              smc_hresp6 <= `RSP_OKAY6;
              r_hresp6 <= 1'd0;
             
           end
             
     end
   
//----------------------------------------------------------------------
// assign read access sense
//----------------------------------------------------------------------

   always @(hwrite6)
     
     begin
             
        n_read6 = hwrite6;
             
     end

//----------------------------------------------------------------------
// AHB6 ready signal6
//----------------------------------------------------------------------

   always @(posedge hclk6 or negedge n_sys_reset6)
     
     begin
             
        if (~n_sys_reset6)
          
           r_ready6 <= 1'b1;
             
        else if ((((htrans6 == `TRN_IDLE6) | (htrans6 == `TRN_BUSY6)) & 
                  (cs != 1'b0) & hready6 & ~mis_err6 & 
                  ~dis_err6) | r_hresp6 | (hsel6 == 1'b0) )
          
           r_ready6 <= 1'b1;
             
        else
          
           r_ready6 <= 1'b0;
             
     end
 
//----------------------------------------------------------------------
//smc6 ready
//----------------------------------------------------------------------

   always @(r_ready6 or smc_done6 or mac_done6)
     
     begin
             
        smc_hready6 = r_ready6 | (smc_done6 & mac_done6);
             
     end
   
//----------------------------------------------------------------------
//read data
//----------------------------------------------------------------------
   
   always @(read_data6)
     
      smc_hrdata6 = read_data6;

//----------------------------------------------------------------------
//write data
//----------------------------------------------------------------------

   always @(hwdata6)
     
      write_data6 = hwdata6;
   


endmodule

