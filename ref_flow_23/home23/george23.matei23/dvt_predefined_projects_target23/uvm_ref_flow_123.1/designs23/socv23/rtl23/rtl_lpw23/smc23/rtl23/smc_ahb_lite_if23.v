//File23 name   : smc_ahb_lite_if23.v
//Title23       : 
//Created23     : 1999
//Description23 : AMBA23 AHB23 Interface23.
//            : Static23 Memory Controller23.
//            : This23 block provides23 the AHB23 interface. 
//            : All AHB23 specific23 signals23 are contained in this
//            : block.
//            : All address decoding23 for the SMC23 module is 
//            : done in
//            : this module and chip23 select23 signals23 generated23
//            : as well23 as an address valid (SMC_valid23) signal23
//            : back to the AHB23 decoder23
//Notes23       : 
//----------------------------------------------------------------------
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------



`include "smc_defs_lite23.v"

//ahb23 interface
  module smc_ahb_lite_if23  (

                      //inputs23

                      hclk23, 
                      n_sys_reset23, 
                      haddr23, 
                      hsel23,
                      htrans23, 
                      hwrite23, 
                      hsize23, 
                      hwdata23,  
                      hready23,  
  
                      //outputs23
  
                      smc_idle23,
                      read_data23, 
                      mac_done23, 
                      smc_done23, 
                      xfer_size23, 
                      n_read23, 
                      new_access23, 
                      addr, 
                      smc_hrdata23, 
                      smc_hready23,
                      smc_hresp23,
                      smc_valid23, 
                      cs, 
                      write_data23 
                      );
  
  
//include files


//----------------------------------------------------------------------


//System23 I23/O23

  input         hclk23;                   // AHB23 System23 clock23
  input         n_sys_reset23;            // AHB23 System23 reset (Active23 LOW23)
 

//AHB23 I23/O23

  input  [31:0]            haddr23;         // AHB23 Address
  input  [1:0]             htrans23;        // AHB23 transfer23 type
  input                    hwrite23;        // AHB23 read/write indication23
  input  [2:0]             hsize23;         // AHB23 transfer23 size
  input  [31:0]            hwdata23;        // AHB23 write data
  input                    hready23;        // AHB23 Muxed23 ready signal23
  output [31:0]            smc_hrdata23;    // smc23 read data back to AHB23
                                             //  master23
  output                   smc_hready23;    // smc23 ready signal23
  output [1:0]             smc_hresp23;     // AHB23 Response23 signal23
  output                   smc_valid23;     // Ack23 to AHB23

//other I23/O23
   
  input                    smc_idle23;      // idle23 state
  input                    smc_done23;      // Asserted23 during 
                                          // last cycle of an access
  input                    mac_done23;      // End23 of all transfers23
  input [31:0]             read_data23;     // Data at internal Bus23
  input               hsel23;          // Chip23 Selects23
   

  output [1:0]             xfer_size23;     // Store23 size for MAC23
  output [31:0]            addr;          // address
  output              cs;          // chip23 selects23 for external23
                                              //  memories
  output [31:0]            write_data23;    // Data to External23 Bus23
  output                   n_read23;        // Active23 low23 read signal23 
  output                   new_access23;    // New23 AHB23 valid access to
                                              //  smc23 detected




// Address Config23







//----------------------------------------------------------------------
// Signal23 declarations23
//----------------------------------------------------------------------

// Output23 register declarations23

// Bus23 Interface23

  reg  [31:0]              smc_hrdata23;  // smc23 read data back to
                                           //  AHB23 master23
  reg                      smc_hready23;  // smc23 ready signal23
  reg  [1:0]               smc_hresp23;   // AHB23 Response23 signal23
  reg                      smc_valid23;   // Ack23 to AHB23

// Internal register declarations23

// Bus23 Interface23

  reg                      new_access23;  // New23 AHB23 valid access
                                           //  to smc23 detected
                                           //  cfg block
  reg  [31:0]              addr;        // Copy23 of address
  reg  [31:0]              write_data23;  // Data to External23 Bus23
  reg  [7:0]               int_cs23;      // Chip23(bank23) Select23 Lines23
  wire                cs;          // Chip23(bank23) Select23 Lines23
  reg  [1:0]               xfer_size23;   // Width23 of current transfer23
  reg                      n_read23;      // Active23 low23 read signal23   
  reg                      r_ready23;     // registered ready signal23   
  reg                      r_hresp23;     // Two23 cycle hresp23 on error
  reg                      mis_err23;     // Misalignment23
  reg                      dis_err23;     // error

// End23 Bus23 Interface23



//----------------------------------------------------------------------
// Beginning23 of main23 code23
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// valid access control23 - AHB23 Interface23 (AHB23 Specific23)
//----------------------------------------------------------------------
// Generates23 the stobes23 required23 to start the smc23 state machine23
// Generates23 all AHB23 responses23.
//----------------------------------------------------------------------

   always @(hsize23)

     begin
     
      xfer_size23 = hsize23[1:0];

     end
   
//----------------------------------------------------------------------
//addr
//----------------------------------------------------------------------

   always @(haddr23)
     
     begin
        
        addr = haddr23;
        
     end
   
//----------------------------------------------------------------------
//chip23 select23 generation23
//----------------------------------------------------------------------

   assign cs = ( hsel23 ) ;
    
//----------------------------------------------------------------------
// detect23 a valid access
//----------------------------------------------------------------------

   always @(cs or hready23 or htrans23 or mis_err23)
     
     begin
             
       if (((htrans23 == `TRN_NONSEQ23) | (htrans23 == `TRN_SEQ23)) &
            (cs != 'd0) & hready23 & ~mis_err23)
          
          begin
             
             smc_valid23 = 1'b1;
             
               
             new_access23 = 1'b1;
             
             
          end
             
       else
          
          begin
             
             smc_valid23 = 1'b0;
             new_access23 = 1'b0;
             
          end
             
     end

//----------------------------------------------------------------------
// Error detection23
//----------------------------------------------------------------------

   always @(haddr23 or hsize23 or htrans23 or cs)
     
     begin
             
        if ((((haddr23[0] != 1'd0) & (hsize23 == `SZ_HALF23))      |
             ((haddr23[1:0] != 2'd0) & (hsize23 == `SZ_WORD23)))    &
            ((htrans23 == `TRN_NONSEQ23) | (htrans23 == `TRN_SEQ23)) &
            (cs != 1'b0) )
          
           mis_err23 = 1'h1;
             
        else
          
           mis_err23 = 1'h0;

     end 
   
//----------------------------------------------------------------------
// Disable23 detection23
//----------------------------------------------------------------------

   always @(htrans23 or cs or smc_idle23 or hready23)
     
     begin
             
           dis_err23 = 1'h0;
             
     end 
   
//----------------------------------------------------------------------
// Response23
//----------------------------------------------------------------------

   always @(posedge hclk23 or negedge n_sys_reset23)
     
     begin
             
        if (~n_sys_reset23)
          
            begin
             
               smc_hresp23 <= `RSP_OKAY23;
               r_hresp23 <= 1'd0;
             
            end
             
        else if (mis_err23 | dis_err23)
          
            begin
             
               r_hresp23 <= 1'd1;
               smc_hresp23 <= `RSP_ERROR23;
             
            end
             
        else if (r_hresp23 == 1'd1)
          
           begin
             
              smc_hresp23 <= `RSP_ERROR23;
              r_hresp23 <= 1'd0;
             
           end
             
        else
          
           begin
             
              smc_hresp23 <= `RSP_OKAY23;
              r_hresp23 <= 1'd0;
             
           end
             
     end
   
//----------------------------------------------------------------------
// assign read access sense
//----------------------------------------------------------------------

   always @(hwrite23)
     
     begin
             
        n_read23 = hwrite23;
             
     end

//----------------------------------------------------------------------
// AHB23 ready signal23
//----------------------------------------------------------------------

   always @(posedge hclk23 or negedge n_sys_reset23)
     
     begin
             
        if (~n_sys_reset23)
          
           r_ready23 <= 1'b1;
             
        else if ((((htrans23 == `TRN_IDLE23) | (htrans23 == `TRN_BUSY23)) & 
                  (cs != 1'b0) & hready23 & ~mis_err23 & 
                  ~dis_err23) | r_hresp23 | (hsel23 == 1'b0) )
          
           r_ready23 <= 1'b1;
             
        else
          
           r_ready23 <= 1'b0;
             
     end
 
//----------------------------------------------------------------------
//smc23 ready
//----------------------------------------------------------------------

   always @(r_ready23 or smc_done23 or mac_done23)
     
     begin
             
        smc_hready23 = r_ready23 | (smc_done23 & mac_done23);
             
     end
   
//----------------------------------------------------------------------
//read data
//----------------------------------------------------------------------
   
   always @(read_data23)
     
      smc_hrdata23 = read_data23;

//----------------------------------------------------------------------
//write data
//----------------------------------------------------------------------

   always @(hwdata23)
     
      write_data23 = hwdata23;
   


endmodule

