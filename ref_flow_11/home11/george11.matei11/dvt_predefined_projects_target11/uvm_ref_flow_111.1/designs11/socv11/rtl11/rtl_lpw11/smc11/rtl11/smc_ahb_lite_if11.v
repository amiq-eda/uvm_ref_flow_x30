//File11 name   : smc_ahb_lite_if11.v
//Title11       : 
//Created11     : 1999
//Description11 : AMBA11 AHB11 Interface11.
//            : Static11 Memory Controller11.
//            : This11 block provides11 the AHB11 interface. 
//            : All AHB11 specific11 signals11 are contained in this
//            : block.
//            : All address decoding11 for the SMC11 module is 
//            : done in
//            : this module and chip11 select11 signals11 generated11
//            : as well11 as an address valid (SMC_valid11) signal11
//            : back to the AHB11 decoder11
//Notes11       : 
//----------------------------------------------------------------------
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------



`include "smc_defs_lite11.v"

//ahb11 interface
  module smc_ahb_lite_if11  (

                      //inputs11

                      hclk11, 
                      n_sys_reset11, 
                      haddr11, 
                      hsel11,
                      htrans11, 
                      hwrite11, 
                      hsize11, 
                      hwdata11,  
                      hready11,  
  
                      //outputs11
  
                      smc_idle11,
                      read_data11, 
                      mac_done11, 
                      smc_done11, 
                      xfer_size11, 
                      n_read11, 
                      new_access11, 
                      addr, 
                      smc_hrdata11, 
                      smc_hready11,
                      smc_hresp11,
                      smc_valid11, 
                      cs, 
                      write_data11 
                      );
  
  
//include files


//----------------------------------------------------------------------


//System11 I11/O11

  input         hclk11;                   // AHB11 System11 clock11
  input         n_sys_reset11;            // AHB11 System11 reset (Active11 LOW11)
 

//AHB11 I11/O11

  input  [31:0]            haddr11;         // AHB11 Address
  input  [1:0]             htrans11;        // AHB11 transfer11 type
  input                    hwrite11;        // AHB11 read/write indication11
  input  [2:0]             hsize11;         // AHB11 transfer11 size
  input  [31:0]            hwdata11;        // AHB11 write data
  input                    hready11;        // AHB11 Muxed11 ready signal11
  output [31:0]            smc_hrdata11;    // smc11 read data back to AHB11
                                             //  master11
  output                   smc_hready11;    // smc11 ready signal11
  output [1:0]             smc_hresp11;     // AHB11 Response11 signal11
  output                   smc_valid11;     // Ack11 to AHB11

//other I11/O11
   
  input                    smc_idle11;      // idle11 state
  input                    smc_done11;      // Asserted11 during 
                                          // last cycle of an access
  input                    mac_done11;      // End11 of all transfers11
  input [31:0]             read_data11;     // Data at internal Bus11
  input               hsel11;          // Chip11 Selects11
   

  output [1:0]             xfer_size11;     // Store11 size for MAC11
  output [31:0]            addr;          // address
  output              cs;          // chip11 selects11 for external11
                                              //  memories
  output [31:0]            write_data11;    // Data to External11 Bus11
  output                   n_read11;        // Active11 low11 read signal11 
  output                   new_access11;    // New11 AHB11 valid access to
                                              //  smc11 detected




// Address Config11







//----------------------------------------------------------------------
// Signal11 declarations11
//----------------------------------------------------------------------

// Output11 register declarations11

// Bus11 Interface11

  reg  [31:0]              smc_hrdata11;  // smc11 read data back to
                                           //  AHB11 master11
  reg                      smc_hready11;  // smc11 ready signal11
  reg  [1:0]               smc_hresp11;   // AHB11 Response11 signal11
  reg                      smc_valid11;   // Ack11 to AHB11

// Internal register declarations11

// Bus11 Interface11

  reg                      new_access11;  // New11 AHB11 valid access
                                           //  to smc11 detected
                                           //  cfg block
  reg  [31:0]              addr;        // Copy11 of address
  reg  [31:0]              write_data11;  // Data to External11 Bus11
  reg  [7:0]               int_cs11;      // Chip11(bank11) Select11 Lines11
  wire                cs;          // Chip11(bank11) Select11 Lines11
  reg  [1:0]               xfer_size11;   // Width11 of current transfer11
  reg                      n_read11;      // Active11 low11 read signal11   
  reg                      r_ready11;     // registered ready signal11   
  reg                      r_hresp11;     // Two11 cycle hresp11 on error
  reg                      mis_err11;     // Misalignment11
  reg                      dis_err11;     // error

// End11 Bus11 Interface11



//----------------------------------------------------------------------
// Beginning11 of main11 code11
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// valid access control11 - AHB11 Interface11 (AHB11 Specific11)
//----------------------------------------------------------------------
// Generates11 the stobes11 required11 to start the smc11 state machine11
// Generates11 all AHB11 responses11.
//----------------------------------------------------------------------

   always @(hsize11)

     begin
     
      xfer_size11 = hsize11[1:0];

     end
   
//----------------------------------------------------------------------
//addr
//----------------------------------------------------------------------

   always @(haddr11)
     
     begin
        
        addr = haddr11;
        
     end
   
//----------------------------------------------------------------------
//chip11 select11 generation11
//----------------------------------------------------------------------

   assign cs = ( hsel11 ) ;
    
//----------------------------------------------------------------------
// detect11 a valid access
//----------------------------------------------------------------------

   always @(cs or hready11 or htrans11 or mis_err11)
     
     begin
             
       if (((htrans11 == `TRN_NONSEQ11) | (htrans11 == `TRN_SEQ11)) &
            (cs != 'd0) & hready11 & ~mis_err11)
          
          begin
             
             smc_valid11 = 1'b1;
             
               
             new_access11 = 1'b1;
             
             
          end
             
       else
          
          begin
             
             smc_valid11 = 1'b0;
             new_access11 = 1'b0;
             
          end
             
     end

//----------------------------------------------------------------------
// Error detection11
//----------------------------------------------------------------------

   always @(haddr11 or hsize11 or htrans11 or cs)
     
     begin
             
        if ((((haddr11[0] != 1'd0) & (hsize11 == `SZ_HALF11))      |
             ((haddr11[1:0] != 2'd0) & (hsize11 == `SZ_WORD11)))    &
            ((htrans11 == `TRN_NONSEQ11) | (htrans11 == `TRN_SEQ11)) &
            (cs != 1'b0) )
          
           mis_err11 = 1'h1;
             
        else
          
           mis_err11 = 1'h0;

     end 
   
//----------------------------------------------------------------------
// Disable11 detection11
//----------------------------------------------------------------------

   always @(htrans11 or cs or smc_idle11 or hready11)
     
     begin
             
           dis_err11 = 1'h0;
             
     end 
   
//----------------------------------------------------------------------
// Response11
//----------------------------------------------------------------------

   always @(posedge hclk11 or negedge n_sys_reset11)
     
     begin
             
        if (~n_sys_reset11)
          
            begin
             
               smc_hresp11 <= `RSP_OKAY11;
               r_hresp11 <= 1'd0;
             
            end
             
        else if (mis_err11 | dis_err11)
          
            begin
             
               r_hresp11 <= 1'd1;
               smc_hresp11 <= `RSP_ERROR11;
             
            end
             
        else if (r_hresp11 == 1'd1)
          
           begin
             
              smc_hresp11 <= `RSP_ERROR11;
              r_hresp11 <= 1'd0;
             
           end
             
        else
          
           begin
             
              smc_hresp11 <= `RSP_OKAY11;
              r_hresp11 <= 1'd0;
             
           end
             
     end
   
//----------------------------------------------------------------------
// assign read access sense
//----------------------------------------------------------------------

   always @(hwrite11)
     
     begin
             
        n_read11 = hwrite11;
             
     end

//----------------------------------------------------------------------
// AHB11 ready signal11
//----------------------------------------------------------------------

   always @(posedge hclk11 or negedge n_sys_reset11)
     
     begin
             
        if (~n_sys_reset11)
          
           r_ready11 <= 1'b1;
             
        else if ((((htrans11 == `TRN_IDLE11) | (htrans11 == `TRN_BUSY11)) & 
                  (cs != 1'b0) & hready11 & ~mis_err11 & 
                  ~dis_err11) | r_hresp11 | (hsel11 == 1'b0) )
          
           r_ready11 <= 1'b1;
             
        else
          
           r_ready11 <= 1'b0;
             
     end
 
//----------------------------------------------------------------------
//smc11 ready
//----------------------------------------------------------------------

   always @(r_ready11 or smc_done11 or mac_done11)
     
     begin
             
        smc_hready11 = r_ready11 | (smc_done11 & mac_done11);
             
     end
   
//----------------------------------------------------------------------
//read data
//----------------------------------------------------------------------
   
   always @(read_data11)
     
      smc_hrdata11 = read_data11;

//----------------------------------------------------------------------
//write data
//----------------------------------------------------------------------

   always @(hwdata11)
     
      write_data11 = hwdata11;
   


endmodule

