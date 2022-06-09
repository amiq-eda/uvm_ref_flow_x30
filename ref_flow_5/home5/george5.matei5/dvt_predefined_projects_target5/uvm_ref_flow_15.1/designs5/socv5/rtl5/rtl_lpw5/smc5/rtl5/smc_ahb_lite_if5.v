//File5 name   : smc_ahb_lite_if5.v
//Title5       : 
//Created5     : 1999
//Description5 : AMBA5 AHB5 Interface5.
//            : Static5 Memory Controller5.
//            : This5 block provides5 the AHB5 interface. 
//            : All AHB5 specific5 signals5 are contained in this
//            : block.
//            : All address decoding5 for the SMC5 module is 
//            : done in
//            : this module and chip5 select5 signals5 generated5
//            : as well5 as an address valid (SMC_valid5) signal5
//            : back to the AHB5 decoder5
//Notes5       : 
//----------------------------------------------------------------------
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------



`include "smc_defs_lite5.v"

//ahb5 interface
  module smc_ahb_lite_if5  (

                      //inputs5

                      hclk5, 
                      n_sys_reset5, 
                      haddr5, 
                      hsel5,
                      htrans5, 
                      hwrite5, 
                      hsize5, 
                      hwdata5,  
                      hready5,  
  
                      //outputs5
  
                      smc_idle5,
                      read_data5, 
                      mac_done5, 
                      smc_done5, 
                      xfer_size5, 
                      n_read5, 
                      new_access5, 
                      addr, 
                      smc_hrdata5, 
                      smc_hready5,
                      smc_hresp5,
                      smc_valid5, 
                      cs, 
                      write_data5 
                      );
  
  
//include files


//----------------------------------------------------------------------


//System5 I5/O5

  input         hclk5;                   // AHB5 System5 clock5
  input         n_sys_reset5;            // AHB5 System5 reset (Active5 LOW5)
 

//AHB5 I5/O5

  input  [31:0]            haddr5;         // AHB5 Address
  input  [1:0]             htrans5;        // AHB5 transfer5 type
  input                    hwrite5;        // AHB5 read/write indication5
  input  [2:0]             hsize5;         // AHB5 transfer5 size
  input  [31:0]            hwdata5;        // AHB5 write data
  input                    hready5;        // AHB5 Muxed5 ready signal5
  output [31:0]            smc_hrdata5;    // smc5 read data back to AHB5
                                             //  master5
  output                   smc_hready5;    // smc5 ready signal5
  output [1:0]             smc_hresp5;     // AHB5 Response5 signal5
  output                   smc_valid5;     // Ack5 to AHB5

//other I5/O5
   
  input                    smc_idle5;      // idle5 state
  input                    smc_done5;      // Asserted5 during 
                                          // last cycle of an access
  input                    mac_done5;      // End5 of all transfers5
  input [31:0]             read_data5;     // Data at internal Bus5
  input               hsel5;          // Chip5 Selects5
   

  output [1:0]             xfer_size5;     // Store5 size for MAC5
  output [31:0]            addr;          // address
  output              cs;          // chip5 selects5 for external5
                                              //  memories
  output [31:0]            write_data5;    // Data to External5 Bus5
  output                   n_read5;        // Active5 low5 read signal5 
  output                   new_access5;    // New5 AHB5 valid access to
                                              //  smc5 detected




// Address Config5







//----------------------------------------------------------------------
// Signal5 declarations5
//----------------------------------------------------------------------

// Output5 register declarations5

// Bus5 Interface5

  reg  [31:0]              smc_hrdata5;  // smc5 read data back to
                                           //  AHB5 master5
  reg                      smc_hready5;  // smc5 ready signal5
  reg  [1:0]               smc_hresp5;   // AHB5 Response5 signal5
  reg                      smc_valid5;   // Ack5 to AHB5

// Internal register declarations5

// Bus5 Interface5

  reg                      new_access5;  // New5 AHB5 valid access
                                           //  to smc5 detected
                                           //  cfg block
  reg  [31:0]              addr;        // Copy5 of address
  reg  [31:0]              write_data5;  // Data to External5 Bus5
  reg  [7:0]               int_cs5;      // Chip5(bank5) Select5 Lines5
  wire                cs;          // Chip5(bank5) Select5 Lines5
  reg  [1:0]               xfer_size5;   // Width5 of current transfer5
  reg                      n_read5;      // Active5 low5 read signal5   
  reg                      r_ready5;     // registered ready signal5   
  reg                      r_hresp5;     // Two5 cycle hresp5 on error
  reg                      mis_err5;     // Misalignment5
  reg                      dis_err5;     // error

// End5 Bus5 Interface5



//----------------------------------------------------------------------
// Beginning5 of main5 code5
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// valid access control5 - AHB5 Interface5 (AHB5 Specific5)
//----------------------------------------------------------------------
// Generates5 the stobes5 required5 to start the smc5 state machine5
// Generates5 all AHB5 responses5.
//----------------------------------------------------------------------

   always @(hsize5)

     begin
     
      xfer_size5 = hsize5[1:0];

     end
   
//----------------------------------------------------------------------
//addr
//----------------------------------------------------------------------

   always @(haddr5)
     
     begin
        
        addr = haddr5;
        
     end
   
//----------------------------------------------------------------------
//chip5 select5 generation5
//----------------------------------------------------------------------

   assign cs = ( hsel5 ) ;
    
//----------------------------------------------------------------------
// detect5 a valid access
//----------------------------------------------------------------------

   always @(cs or hready5 or htrans5 or mis_err5)
     
     begin
             
       if (((htrans5 == `TRN_NONSEQ5) | (htrans5 == `TRN_SEQ5)) &
            (cs != 'd0) & hready5 & ~mis_err5)
          
          begin
             
             smc_valid5 = 1'b1;
             
               
             new_access5 = 1'b1;
             
             
          end
             
       else
          
          begin
             
             smc_valid5 = 1'b0;
             new_access5 = 1'b0;
             
          end
             
     end

//----------------------------------------------------------------------
// Error detection5
//----------------------------------------------------------------------

   always @(haddr5 or hsize5 or htrans5 or cs)
     
     begin
             
        if ((((haddr5[0] != 1'd0) & (hsize5 == `SZ_HALF5))      |
             ((haddr5[1:0] != 2'd0) & (hsize5 == `SZ_WORD5)))    &
            ((htrans5 == `TRN_NONSEQ5) | (htrans5 == `TRN_SEQ5)) &
            (cs != 1'b0) )
          
           mis_err5 = 1'h1;
             
        else
          
           mis_err5 = 1'h0;

     end 
   
//----------------------------------------------------------------------
// Disable5 detection5
//----------------------------------------------------------------------

   always @(htrans5 or cs or smc_idle5 or hready5)
     
     begin
             
           dis_err5 = 1'h0;
             
     end 
   
//----------------------------------------------------------------------
// Response5
//----------------------------------------------------------------------

   always @(posedge hclk5 or negedge n_sys_reset5)
     
     begin
             
        if (~n_sys_reset5)
          
            begin
             
               smc_hresp5 <= `RSP_OKAY5;
               r_hresp5 <= 1'd0;
             
            end
             
        else if (mis_err5 | dis_err5)
          
            begin
             
               r_hresp5 <= 1'd1;
               smc_hresp5 <= `RSP_ERROR5;
             
            end
             
        else if (r_hresp5 == 1'd1)
          
           begin
             
              smc_hresp5 <= `RSP_ERROR5;
              r_hresp5 <= 1'd0;
             
           end
             
        else
          
           begin
             
              smc_hresp5 <= `RSP_OKAY5;
              r_hresp5 <= 1'd0;
             
           end
             
     end
   
//----------------------------------------------------------------------
// assign read access sense
//----------------------------------------------------------------------

   always @(hwrite5)
     
     begin
             
        n_read5 = hwrite5;
             
     end

//----------------------------------------------------------------------
// AHB5 ready signal5
//----------------------------------------------------------------------

   always @(posedge hclk5 or negedge n_sys_reset5)
     
     begin
             
        if (~n_sys_reset5)
          
           r_ready5 <= 1'b1;
             
        else if ((((htrans5 == `TRN_IDLE5) | (htrans5 == `TRN_BUSY5)) & 
                  (cs != 1'b0) & hready5 & ~mis_err5 & 
                  ~dis_err5) | r_hresp5 | (hsel5 == 1'b0) )
          
           r_ready5 <= 1'b1;
             
        else
          
           r_ready5 <= 1'b0;
             
     end
 
//----------------------------------------------------------------------
//smc5 ready
//----------------------------------------------------------------------

   always @(r_ready5 or smc_done5 or mac_done5)
     
     begin
             
        smc_hready5 = r_ready5 | (smc_done5 & mac_done5);
             
     end
   
//----------------------------------------------------------------------
//read data
//----------------------------------------------------------------------
   
   always @(read_data5)
     
      smc_hrdata5 = read_data5;

//----------------------------------------------------------------------
//write data
//----------------------------------------------------------------------

   always @(hwdata5)
     
      write_data5 = hwdata5;
   


endmodule

