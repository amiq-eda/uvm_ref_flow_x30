//File10 name   : smc_ahb_lite_if10.v
//Title10       : 
//Created10     : 1999
//Description10 : AMBA10 AHB10 Interface10.
//            : Static10 Memory Controller10.
//            : This10 block provides10 the AHB10 interface. 
//            : All AHB10 specific10 signals10 are contained in this
//            : block.
//            : All address decoding10 for the SMC10 module is 
//            : done in
//            : this module and chip10 select10 signals10 generated10
//            : as well10 as an address valid (SMC_valid10) signal10
//            : back to the AHB10 decoder10
//Notes10       : 
//----------------------------------------------------------------------
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------



`include "smc_defs_lite10.v"

//ahb10 interface
  module smc_ahb_lite_if10  (

                      //inputs10

                      hclk10, 
                      n_sys_reset10, 
                      haddr10, 
                      hsel10,
                      htrans10, 
                      hwrite10, 
                      hsize10, 
                      hwdata10,  
                      hready10,  
  
                      //outputs10
  
                      smc_idle10,
                      read_data10, 
                      mac_done10, 
                      smc_done10, 
                      xfer_size10, 
                      n_read10, 
                      new_access10, 
                      addr, 
                      smc_hrdata10, 
                      smc_hready10,
                      smc_hresp10,
                      smc_valid10, 
                      cs, 
                      write_data10 
                      );
  
  
//include files


//----------------------------------------------------------------------


//System10 I10/O10

  input         hclk10;                   // AHB10 System10 clock10
  input         n_sys_reset10;            // AHB10 System10 reset (Active10 LOW10)
 

//AHB10 I10/O10

  input  [31:0]            haddr10;         // AHB10 Address
  input  [1:0]             htrans10;        // AHB10 transfer10 type
  input                    hwrite10;        // AHB10 read/write indication10
  input  [2:0]             hsize10;         // AHB10 transfer10 size
  input  [31:0]            hwdata10;        // AHB10 write data
  input                    hready10;        // AHB10 Muxed10 ready signal10
  output [31:0]            smc_hrdata10;    // smc10 read data back to AHB10
                                             //  master10
  output                   smc_hready10;    // smc10 ready signal10
  output [1:0]             smc_hresp10;     // AHB10 Response10 signal10
  output                   smc_valid10;     // Ack10 to AHB10

//other I10/O10
   
  input                    smc_idle10;      // idle10 state
  input                    smc_done10;      // Asserted10 during 
                                          // last cycle of an access
  input                    mac_done10;      // End10 of all transfers10
  input [31:0]             read_data10;     // Data at internal Bus10
  input               hsel10;          // Chip10 Selects10
   

  output [1:0]             xfer_size10;     // Store10 size for MAC10
  output [31:0]            addr;          // address
  output              cs;          // chip10 selects10 for external10
                                              //  memories
  output [31:0]            write_data10;    // Data to External10 Bus10
  output                   n_read10;        // Active10 low10 read signal10 
  output                   new_access10;    // New10 AHB10 valid access to
                                              //  smc10 detected




// Address Config10







//----------------------------------------------------------------------
// Signal10 declarations10
//----------------------------------------------------------------------

// Output10 register declarations10

// Bus10 Interface10

  reg  [31:0]              smc_hrdata10;  // smc10 read data back to
                                           //  AHB10 master10
  reg                      smc_hready10;  // smc10 ready signal10
  reg  [1:0]               smc_hresp10;   // AHB10 Response10 signal10
  reg                      smc_valid10;   // Ack10 to AHB10

// Internal register declarations10

// Bus10 Interface10

  reg                      new_access10;  // New10 AHB10 valid access
                                           //  to smc10 detected
                                           //  cfg block
  reg  [31:0]              addr;        // Copy10 of address
  reg  [31:0]              write_data10;  // Data to External10 Bus10
  reg  [7:0]               int_cs10;      // Chip10(bank10) Select10 Lines10
  wire                cs;          // Chip10(bank10) Select10 Lines10
  reg  [1:0]               xfer_size10;   // Width10 of current transfer10
  reg                      n_read10;      // Active10 low10 read signal10   
  reg                      r_ready10;     // registered ready signal10   
  reg                      r_hresp10;     // Two10 cycle hresp10 on error
  reg                      mis_err10;     // Misalignment10
  reg                      dis_err10;     // error

// End10 Bus10 Interface10



//----------------------------------------------------------------------
// Beginning10 of main10 code10
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// valid access control10 - AHB10 Interface10 (AHB10 Specific10)
//----------------------------------------------------------------------
// Generates10 the stobes10 required10 to start the smc10 state machine10
// Generates10 all AHB10 responses10.
//----------------------------------------------------------------------

   always @(hsize10)

     begin
     
      xfer_size10 = hsize10[1:0];

     end
   
//----------------------------------------------------------------------
//addr
//----------------------------------------------------------------------

   always @(haddr10)
     
     begin
        
        addr = haddr10;
        
     end
   
//----------------------------------------------------------------------
//chip10 select10 generation10
//----------------------------------------------------------------------

   assign cs = ( hsel10 ) ;
    
//----------------------------------------------------------------------
// detect10 a valid access
//----------------------------------------------------------------------

   always @(cs or hready10 or htrans10 or mis_err10)
     
     begin
             
       if (((htrans10 == `TRN_NONSEQ10) | (htrans10 == `TRN_SEQ10)) &
            (cs != 'd0) & hready10 & ~mis_err10)
          
          begin
             
             smc_valid10 = 1'b1;
             
               
             new_access10 = 1'b1;
             
             
          end
             
       else
          
          begin
             
             smc_valid10 = 1'b0;
             new_access10 = 1'b0;
             
          end
             
     end

//----------------------------------------------------------------------
// Error detection10
//----------------------------------------------------------------------

   always @(haddr10 or hsize10 or htrans10 or cs)
     
     begin
             
        if ((((haddr10[0] != 1'd0) & (hsize10 == `SZ_HALF10))      |
             ((haddr10[1:0] != 2'd0) & (hsize10 == `SZ_WORD10)))    &
            ((htrans10 == `TRN_NONSEQ10) | (htrans10 == `TRN_SEQ10)) &
            (cs != 1'b0) )
          
           mis_err10 = 1'h1;
             
        else
          
           mis_err10 = 1'h0;

     end 
   
//----------------------------------------------------------------------
// Disable10 detection10
//----------------------------------------------------------------------

   always @(htrans10 or cs or smc_idle10 or hready10)
     
     begin
             
           dis_err10 = 1'h0;
             
     end 
   
//----------------------------------------------------------------------
// Response10
//----------------------------------------------------------------------

   always @(posedge hclk10 or negedge n_sys_reset10)
     
     begin
             
        if (~n_sys_reset10)
          
            begin
             
               smc_hresp10 <= `RSP_OKAY10;
               r_hresp10 <= 1'd0;
             
            end
             
        else if (mis_err10 | dis_err10)
          
            begin
             
               r_hresp10 <= 1'd1;
               smc_hresp10 <= `RSP_ERROR10;
             
            end
             
        else if (r_hresp10 == 1'd1)
          
           begin
             
              smc_hresp10 <= `RSP_ERROR10;
              r_hresp10 <= 1'd0;
             
           end
             
        else
          
           begin
             
              smc_hresp10 <= `RSP_OKAY10;
              r_hresp10 <= 1'd0;
             
           end
             
     end
   
//----------------------------------------------------------------------
// assign read access sense
//----------------------------------------------------------------------

   always @(hwrite10)
     
     begin
             
        n_read10 = hwrite10;
             
     end

//----------------------------------------------------------------------
// AHB10 ready signal10
//----------------------------------------------------------------------

   always @(posedge hclk10 or negedge n_sys_reset10)
     
     begin
             
        if (~n_sys_reset10)
          
           r_ready10 <= 1'b1;
             
        else if ((((htrans10 == `TRN_IDLE10) | (htrans10 == `TRN_BUSY10)) & 
                  (cs != 1'b0) & hready10 & ~mis_err10 & 
                  ~dis_err10) | r_hresp10 | (hsel10 == 1'b0) )
          
           r_ready10 <= 1'b1;
             
        else
          
           r_ready10 <= 1'b0;
             
     end
 
//----------------------------------------------------------------------
//smc10 ready
//----------------------------------------------------------------------

   always @(r_ready10 or smc_done10 or mac_done10)
     
     begin
             
        smc_hready10 = r_ready10 | (smc_done10 & mac_done10);
             
     end
   
//----------------------------------------------------------------------
//read data
//----------------------------------------------------------------------
   
   always @(read_data10)
     
      smc_hrdata10 = read_data10;

//----------------------------------------------------------------------
//write data
//----------------------------------------------------------------------

   always @(hwdata10)
     
      write_data10 = hwdata10;
   


endmodule

