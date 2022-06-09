//File28 name   : smc_ahb_lite_if28.v
//Title28       : 
//Created28     : 1999
//Description28 : AMBA28 AHB28 Interface28.
//            : Static28 Memory Controller28.
//            : This28 block provides28 the AHB28 interface. 
//            : All AHB28 specific28 signals28 are contained in this
//            : block.
//            : All address decoding28 for the SMC28 module is 
//            : done in
//            : this module and chip28 select28 signals28 generated28
//            : as well28 as an address valid (SMC_valid28) signal28
//            : back to the AHB28 decoder28
//Notes28       : 
//----------------------------------------------------------------------
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------



`include "smc_defs_lite28.v"

//ahb28 interface
  module smc_ahb_lite_if28  (

                      //inputs28

                      hclk28, 
                      n_sys_reset28, 
                      haddr28, 
                      hsel28,
                      htrans28, 
                      hwrite28, 
                      hsize28, 
                      hwdata28,  
                      hready28,  
  
                      //outputs28
  
                      smc_idle28,
                      read_data28, 
                      mac_done28, 
                      smc_done28, 
                      xfer_size28, 
                      n_read28, 
                      new_access28, 
                      addr, 
                      smc_hrdata28, 
                      smc_hready28,
                      smc_hresp28,
                      smc_valid28, 
                      cs, 
                      write_data28 
                      );
  
  
//include files


//----------------------------------------------------------------------


//System28 I28/O28

  input         hclk28;                   // AHB28 System28 clock28
  input         n_sys_reset28;            // AHB28 System28 reset (Active28 LOW28)
 

//AHB28 I28/O28

  input  [31:0]            haddr28;         // AHB28 Address
  input  [1:0]             htrans28;        // AHB28 transfer28 type
  input                    hwrite28;        // AHB28 read/write indication28
  input  [2:0]             hsize28;         // AHB28 transfer28 size
  input  [31:0]            hwdata28;        // AHB28 write data
  input                    hready28;        // AHB28 Muxed28 ready signal28
  output [31:0]            smc_hrdata28;    // smc28 read data back to AHB28
                                             //  master28
  output                   smc_hready28;    // smc28 ready signal28
  output [1:0]             smc_hresp28;     // AHB28 Response28 signal28
  output                   smc_valid28;     // Ack28 to AHB28

//other I28/O28
   
  input                    smc_idle28;      // idle28 state
  input                    smc_done28;      // Asserted28 during 
                                          // last cycle of an access
  input                    mac_done28;      // End28 of all transfers28
  input [31:0]             read_data28;     // Data at internal Bus28
  input               hsel28;          // Chip28 Selects28
   

  output [1:0]             xfer_size28;     // Store28 size for MAC28
  output [31:0]            addr;          // address
  output              cs;          // chip28 selects28 for external28
                                              //  memories
  output [31:0]            write_data28;    // Data to External28 Bus28
  output                   n_read28;        // Active28 low28 read signal28 
  output                   new_access28;    // New28 AHB28 valid access to
                                              //  smc28 detected




// Address Config28







//----------------------------------------------------------------------
// Signal28 declarations28
//----------------------------------------------------------------------

// Output28 register declarations28

// Bus28 Interface28

  reg  [31:0]              smc_hrdata28;  // smc28 read data back to
                                           //  AHB28 master28
  reg                      smc_hready28;  // smc28 ready signal28
  reg  [1:0]               smc_hresp28;   // AHB28 Response28 signal28
  reg                      smc_valid28;   // Ack28 to AHB28

// Internal register declarations28

// Bus28 Interface28

  reg                      new_access28;  // New28 AHB28 valid access
                                           //  to smc28 detected
                                           //  cfg block
  reg  [31:0]              addr;        // Copy28 of address
  reg  [31:0]              write_data28;  // Data to External28 Bus28
  reg  [7:0]               int_cs28;      // Chip28(bank28) Select28 Lines28
  wire                cs;          // Chip28(bank28) Select28 Lines28
  reg  [1:0]               xfer_size28;   // Width28 of current transfer28
  reg                      n_read28;      // Active28 low28 read signal28   
  reg                      r_ready28;     // registered ready signal28   
  reg                      r_hresp28;     // Two28 cycle hresp28 on error
  reg                      mis_err28;     // Misalignment28
  reg                      dis_err28;     // error

// End28 Bus28 Interface28



//----------------------------------------------------------------------
// Beginning28 of main28 code28
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// valid access control28 - AHB28 Interface28 (AHB28 Specific28)
//----------------------------------------------------------------------
// Generates28 the stobes28 required28 to start the smc28 state machine28
// Generates28 all AHB28 responses28.
//----------------------------------------------------------------------

   always @(hsize28)

     begin
     
      xfer_size28 = hsize28[1:0];

     end
   
//----------------------------------------------------------------------
//addr
//----------------------------------------------------------------------

   always @(haddr28)
     
     begin
        
        addr = haddr28;
        
     end
   
//----------------------------------------------------------------------
//chip28 select28 generation28
//----------------------------------------------------------------------

   assign cs = ( hsel28 ) ;
    
//----------------------------------------------------------------------
// detect28 a valid access
//----------------------------------------------------------------------

   always @(cs or hready28 or htrans28 or mis_err28)
     
     begin
             
       if (((htrans28 == `TRN_NONSEQ28) | (htrans28 == `TRN_SEQ28)) &
            (cs != 'd0) & hready28 & ~mis_err28)
          
          begin
             
             smc_valid28 = 1'b1;
             
               
             new_access28 = 1'b1;
             
             
          end
             
       else
          
          begin
             
             smc_valid28 = 1'b0;
             new_access28 = 1'b0;
             
          end
             
     end

//----------------------------------------------------------------------
// Error detection28
//----------------------------------------------------------------------

   always @(haddr28 or hsize28 or htrans28 or cs)
     
     begin
             
        if ((((haddr28[0] != 1'd0) & (hsize28 == `SZ_HALF28))      |
             ((haddr28[1:0] != 2'd0) & (hsize28 == `SZ_WORD28)))    &
            ((htrans28 == `TRN_NONSEQ28) | (htrans28 == `TRN_SEQ28)) &
            (cs != 1'b0) )
          
           mis_err28 = 1'h1;
             
        else
          
           mis_err28 = 1'h0;

     end 
   
//----------------------------------------------------------------------
// Disable28 detection28
//----------------------------------------------------------------------

   always @(htrans28 or cs or smc_idle28 or hready28)
     
     begin
             
           dis_err28 = 1'h0;
             
     end 
   
//----------------------------------------------------------------------
// Response28
//----------------------------------------------------------------------

   always @(posedge hclk28 or negedge n_sys_reset28)
     
     begin
             
        if (~n_sys_reset28)
          
            begin
             
               smc_hresp28 <= `RSP_OKAY28;
               r_hresp28 <= 1'd0;
             
            end
             
        else if (mis_err28 | dis_err28)
          
            begin
             
               r_hresp28 <= 1'd1;
               smc_hresp28 <= `RSP_ERROR28;
             
            end
             
        else if (r_hresp28 == 1'd1)
          
           begin
             
              smc_hresp28 <= `RSP_ERROR28;
              r_hresp28 <= 1'd0;
             
           end
             
        else
          
           begin
             
              smc_hresp28 <= `RSP_OKAY28;
              r_hresp28 <= 1'd0;
             
           end
             
     end
   
//----------------------------------------------------------------------
// assign read access sense
//----------------------------------------------------------------------

   always @(hwrite28)
     
     begin
             
        n_read28 = hwrite28;
             
     end

//----------------------------------------------------------------------
// AHB28 ready signal28
//----------------------------------------------------------------------

   always @(posedge hclk28 or negedge n_sys_reset28)
     
     begin
             
        if (~n_sys_reset28)
          
           r_ready28 <= 1'b1;
             
        else if ((((htrans28 == `TRN_IDLE28) | (htrans28 == `TRN_BUSY28)) & 
                  (cs != 1'b0) & hready28 & ~mis_err28 & 
                  ~dis_err28) | r_hresp28 | (hsel28 == 1'b0) )
          
           r_ready28 <= 1'b1;
             
        else
          
           r_ready28 <= 1'b0;
             
     end
 
//----------------------------------------------------------------------
//smc28 ready
//----------------------------------------------------------------------

   always @(r_ready28 or smc_done28 or mac_done28)
     
     begin
             
        smc_hready28 = r_ready28 | (smc_done28 & mac_done28);
             
     end
   
//----------------------------------------------------------------------
//read data
//----------------------------------------------------------------------
   
   always @(read_data28)
     
      smc_hrdata28 = read_data28;

//----------------------------------------------------------------------
//write data
//----------------------------------------------------------------------

   always @(hwdata28)
     
      write_data28 = hwdata28;
   


endmodule

