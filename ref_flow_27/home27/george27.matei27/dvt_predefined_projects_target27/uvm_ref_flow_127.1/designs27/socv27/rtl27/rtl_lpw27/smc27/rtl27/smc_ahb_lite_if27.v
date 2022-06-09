//File27 name   : smc_ahb_lite_if27.v
//Title27       : 
//Created27     : 1999
//Description27 : AMBA27 AHB27 Interface27.
//            : Static27 Memory Controller27.
//            : This27 block provides27 the AHB27 interface. 
//            : All AHB27 specific27 signals27 are contained in this
//            : block.
//            : All address decoding27 for the SMC27 module is 
//            : done in
//            : this module and chip27 select27 signals27 generated27
//            : as well27 as an address valid (SMC_valid27) signal27
//            : back to the AHB27 decoder27
//Notes27       : 
//----------------------------------------------------------------------
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------



`include "smc_defs_lite27.v"

//ahb27 interface
  module smc_ahb_lite_if27  (

                      //inputs27

                      hclk27, 
                      n_sys_reset27, 
                      haddr27, 
                      hsel27,
                      htrans27, 
                      hwrite27, 
                      hsize27, 
                      hwdata27,  
                      hready27,  
  
                      //outputs27
  
                      smc_idle27,
                      read_data27, 
                      mac_done27, 
                      smc_done27, 
                      xfer_size27, 
                      n_read27, 
                      new_access27, 
                      addr, 
                      smc_hrdata27, 
                      smc_hready27,
                      smc_hresp27,
                      smc_valid27, 
                      cs, 
                      write_data27 
                      );
  
  
//include files


//----------------------------------------------------------------------


//System27 I27/O27

  input         hclk27;                   // AHB27 System27 clock27
  input         n_sys_reset27;            // AHB27 System27 reset (Active27 LOW27)
 

//AHB27 I27/O27

  input  [31:0]            haddr27;         // AHB27 Address
  input  [1:0]             htrans27;        // AHB27 transfer27 type
  input                    hwrite27;        // AHB27 read/write indication27
  input  [2:0]             hsize27;         // AHB27 transfer27 size
  input  [31:0]            hwdata27;        // AHB27 write data
  input                    hready27;        // AHB27 Muxed27 ready signal27
  output [31:0]            smc_hrdata27;    // smc27 read data back to AHB27
                                             //  master27
  output                   smc_hready27;    // smc27 ready signal27
  output [1:0]             smc_hresp27;     // AHB27 Response27 signal27
  output                   smc_valid27;     // Ack27 to AHB27

//other I27/O27
   
  input                    smc_idle27;      // idle27 state
  input                    smc_done27;      // Asserted27 during 
                                          // last cycle of an access
  input                    mac_done27;      // End27 of all transfers27
  input [31:0]             read_data27;     // Data at internal Bus27
  input               hsel27;          // Chip27 Selects27
   

  output [1:0]             xfer_size27;     // Store27 size for MAC27
  output [31:0]            addr;          // address
  output              cs;          // chip27 selects27 for external27
                                              //  memories
  output [31:0]            write_data27;    // Data to External27 Bus27
  output                   n_read27;        // Active27 low27 read signal27 
  output                   new_access27;    // New27 AHB27 valid access to
                                              //  smc27 detected




// Address Config27







//----------------------------------------------------------------------
// Signal27 declarations27
//----------------------------------------------------------------------

// Output27 register declarations27

// Bus27 Interface27

  reg  [31:0]              smc_hrdata27;  // smc27 read data back to
                                           //  AHB27 master27
  reg                      smc_hready27;  // smc27 ready signal27
  reg  [1:0]               smc_hresp27;   // AHB27 Response27 signal27
  reg                      smc_valid27;   // Ack27 to AHB27

// Internal register declarations27

// Bus27 Interface27

  reg                      new_access27;  // New27 AHB27 valid access
                                           //  to smc27 detected
                                           //  cfg block
  reg  [31:0]              addr;        // Copy27 of address
  reg  [31:0]              write_data27;  // Data to External27 Bus27
  reg  [7:0]               int_cs27;      // Chip27(bank27) Select27 Lines27
  wire                cs;          // Chip27(bank27) Select27 Lines27
  reg  [1:0]               xfer_size27;   // Width27 of current transfer27
  reg                      n_read27;      // Active27 low27 read signal27   
  reg                      r_ready27;     // registered ready signal27   
  reg                      r_hresp27;     // Two27 cycle hresp27 on error
  reg                      mis_err27;     // Misalignment27
  reg                      dis_err27;     // error

// End27 Bus27 Interface27



//----------------------------------------------------------------------
// Beginning27 of main27 code27
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// valid access control27 - AHB27 Interface27 (AHB27 Specific27)
//----------------------------------------------------------------------
// Generates27 the stobes27 required27 to start the smc27 state machine27
// Generates27 all AHB27 responses27.
//----------------------------------------------------------------------

   always @(hsize27)

     begin
     
      xfer_size27 = hsize27[1:0];

     end
   
//----------------------------------------------------------------------
//addr
//----------------------------------------------------------------------

   always @(haddr27)
     
     begin
        
        addr = haddr27;
        
     end
   
//----------------------------------------------------------------------
//chip27 select27 generation27
//----------------------------------------------------------------------

   assign cs = ( hsel27 ) ;
    
//----------------------------------------------------------------------
// detect27 a valid access
//----------------------------------------------------------------------

   always @(cs or hready27 or htrans27 or mis_err27)
     
     begin
             
       if (((htrans27 == `TRN_NONSEQ27) | (htrans27 == `TRN_SEQ27)) &
            (cs != 'd0) & hready27 & ~mis_err27)
          
          begin
             
             smc_valid27 = 1'b1;
             
               
             new_access27 = 1'b1;
             
             
          end
             
       else
          
          begin
             
             smc_valid27 = 1'b0;
             new_access27 = 1'b0;
             
          end
             
     end

//----------------------------------------------------------------------
// Error detection27
//----------------------------------------------------------------------

   always @(haddr27 or hsize27 or htrans27 or cs)
     
     begin
             
        if ((((haddr27[0] != 1'd0) & (hsize27 == `SZ_HALF27))      |
             ((haddr27[1:0] != 2'd0) & (hsize27 == `SZ_WORD27)))    &
            ((htrans27 == `TRN_NONSEQ27) | (htrans27 == `TRN_SEQ27)) &
            (cs != 1'b0) )
          
           mis_err27 = 1'h1;
             
        else
          
           mis_err27 = 1'h0;

     end 
   
//----------------------------------------------------------------------
// Disable27 detection27
//----------------------------------------------------------------------

   always @(htrans27 or cs or smc_idle27 or hready27)
     
     begin
             
           dis_err27 = 1'h0;
             
     end 
   
//----------------------------------------------------------------------
// Response27
//----------------------------------------------------------------------

   always @(posedge hclk27 or negedge n_sys_reset27)
     
     begin
             
        if (~n_sys_reset27)
          
            begin
             
               smc_hresp27 <= `RSP_OKAY27;
               r_hresp27 <= 1'd0;
             
            end
             
        else if (mis_err27 | dis_err27)
          
            begin
             
               r_hresp27 <= 1'd1;
               smc_hresp27 <= `RSP_ERROR27;
             
            end
             
        else if (r_hresp27 == 1'd1)
          
           begin
             
              smc_hresp27 <= `RSP_ERROR27;
              r_hresp27 <= 1'd0;
             
           end
             
        else
          
           begin
             
              smc_hresp27 <= `RSP_OKAY27;
              r_hresp27 <= 1'd0;
             
           end
             
     end
   
//----------------------------------------------------------------------
// assign read access sense
//----------------------------------------------------------------------

   always @(hwrite27)
     
     begin
             
        n_read27 = hwrite27;
             
     end

//----------------------------------------------------------------------
// AHB27 ready signal27
//----------------------------------------------------------------------

   always @(posedge hclk27 or negedge n_sys_reset27)
     
     begin
             
        if (~n_sys_reset27)
          
           r_ready27 <= 1'b1;
             
        else if ((((htrans27 == `TRN_IDLE27) | (htrans27 == `TRN_BUSY27)) & 
                  (cs != 1'b0) & hready27 & ~mis_err27 & 
                  ~dis_err27) | r_hresp27 | (hsel27 == 1'b0) )
          
           r_ready27 <= 1'b1;
             
        else
          
           r_ready27 <= 1'b0;
             
     end
 
//----------------------------------------------------------------------
//smc27 ready
//----------------------------------------------------------------------

   always @(r_ready27 or smc_done27 or mac_done27)
     
     begin
             
        smc_hready27 = r_ready27 | (smc_done27 & mac_done27);
             
     end
   
//----------------------------------------------------------------------
//read data
//----------------------------------------------------------------------
   
   always @(read_data27)
     
      smc_hrdata27 = read_data27;

//----------------------------------------------------------------------
//write data
//----------------------------------------------------------------------

   always @(hwdata27)
     
      write_data27 = hwdata27;
   


endmodule

