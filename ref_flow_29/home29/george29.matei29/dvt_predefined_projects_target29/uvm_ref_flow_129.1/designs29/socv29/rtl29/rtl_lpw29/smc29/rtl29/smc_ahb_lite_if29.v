//File29 name   : smc_ahb_lite_if29.v
//Title29       : 
//Created29     : 1999
//Description29 : AMBA29 AHB29 Interface29.
//            : Static29 Memory Controller29.
//            : This29 block provides29 the AHB29 interface. 
//            : All AHB29 specific29 signals29 are contained in this
//            : block.
//            : All address decoding29 for the SMC29 module is 
//            : done in
//            : this module and chip29 select29 signals29 generated29
//            : as well29 as an address valid (SMC_valid29) signal29
//            : back to the AHB29 decoder29
//Notes29       : 
//----------------------------------------------------------------------
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------



`include "smc_defs_lite29.v"

//ahb29 interface
  module smc_ahb_lite_if29  (

                      //inputs29

                      hclk29, 
                      n_sys_reset29, 
                      haddr29, 
                      hsel29,
                      htrans29, 
                      hwrite29, 
                      hsize29, 
                      hwdata29,  
                      hready29,  
  
                      //outputs29
  
                      smc_idle29,
                      read_data29, 
                      mac_done29, 
                      smc_done29, 
                      xfer_size29, 
                      n_read29, 
                      new_access29, 
                      addr, 
                      smc_hrdata29, 
                      smc_hready29,
                      smc_hresp29,
                      smc_valid29, 
                      cs, 
                      write_data29 
                      );
  
  
//include files


//----------------------------------------------------------------------


//System29 I29/O29

  input         hclk29;                   // AHB29 System29 clock29
  input         n_sys_reset29;            // AHB29 System29 reset (Active29 LOW29)
 

//AHB29 I29/O29

  input  [31:0]            haddr29;         // AHB29 Address
  input  [1:0]             htrans29;        // AHB29 transfer29 type
  input                    hwrite29;        // AHB29 read/write indication29
  input  [2:0]             hsize29;         // AHB29 transfer29 size
  input  [31:0]            hwdata29;        // AHB29 write data
  input                    hready29;        // AHB29 Muxed29 ready signal29
  output [31:0]            smc_hrdata29;    // smc29 read data back to AHB29
                                             //  master29
  output                   smc_hready29;    // smc29 ready signal29
  output [1:0]             smc_hresp29;     // AHB29 Response29 signal29
  output                   smc_valid29;     // Ack29 to AHB29

//other I29/O29
   
  input                    smc_idle29;      // idle29 state
  input                    smc_done29;      // Asserted29 during 
                                          // last cycle of an access
  input                    mac_done29;      // End29 of all transfers29
  input [31:0]             read_data29;     // Data at internal Bus29
  input               hsel29;          // Chip29 Selects29
   

  output [1:0]             xfer_size29;     // Store29 size for MAC29
  output [31:0]            addr;          // address
  output              cs;          // chip29 selects29 for external29
                                              //  memories
  output [31:0]            write_data29;    // Data to External29 Bus29
  output                   n_read29;        // Active29 low29 read signal29 
  output                   new_access29;    // New29 AHB29 valid access to
                                              //  smc29 detected




// Address Config29







//----------------------------------------------------------------------
// Signal29 declarations29
//----------------------------------------------------------------------

// Output29 register declarations29

// Bus29 Interface29

  reg  [31:0]              smc_hrdata29;  // smc29 read data back to
                                           //  AHB29 master29
  reg                      smc_hready29;  // smc29 ready signal29
  reg  [1:0]               smc_hresp29;   // AHB29 Response29 signal29
  reg                      smc_valid29;   // Ack29 to AHB29

// Internal register declarations29

// Bus29 Interface29

  reg                      new_access29;  // New29 AHB29 valid access
                                           //  to smc29 detected
                                           //  cfg block
  reg  [31:0]              addr;        // Copy29 of address
  reg  [31:0]              write_data29;  // Data to External29 Bus29
  reg  [7:0]               int_cs29;      // Chip29(bank29) Select29 Lines29
  wire                cs;          // Chip29(bank29) Select29 Lines29
  reg  [1:0]               xfer_size29;   // Width29 of current transfer29
  reg                      n_read29;      // Active29 low29 read signal29   
  reg                      r_ready29;     // registered ready signal29   
  reg                      r_hresp29;     // Two29 cycle hresp29 on error
  reg                      mis_err29;     // Misalignment29
  reg                      dis_err29;     // error

// End29 Bus29 Interface29



//----------------------------------------------------------------------
// Beginning29 of main29 code29
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// valid access control29 - AHB29 Interface29 (AHB29 Specific29)
//----------------------------------------------------------------------
// Generates29 the stobes29 required29 to start the smc29 state machine29
// Generates29 all AHB29 responses29.
//----------------------------------------------------------------------

   always @(hsize29)

     begin
     
      xfer_size29 = hsize29[1:0];

     end
   
//----------------------------------------------------------------------
//addr
//----------------------------------------------------------------------

   always @(haddr29)
     
     begin
        
        addr = haddr29;
        
     end
   
//----------------------------------------------------------------------
//chip29 select29 generation29
//----------------------------------------------------------------------

   assign cs = ( hsel29 ) ;
    
//----------------------------------------------------------------------
// detect29 a valid access
//----------------------------------------------------------------------

   always @(cs or hready29 or htrans29 or mis_err29)
     
     begin
             
       if (((htrans29 == `TRN_NONSEQ29) | (htrans29 == `TRN_SEQ29)) &
            (cs != 'd0) & hready29 & ~mis_err29)
          
          begin
             
             smc_valid29 = 1'b1;
             
               
             new_access29 = 1'b1;
             
             
          end
             
       else
          
          begin
             
             smc_valid29 = 1'b0;
             new_access29 = 1'b0;
             
          end
             
     end

//----------------------------------------------------------------------
// Error detection29
//----------------------------------------------------------------------

   always @(haddr29 or hsize29 or htrans29 or cs)
     
     begin
             
        if ((((haddr29[0] != 1'd0) & (hsize29 == `SZ_HALF29))      |
             ((haddr29[1:0] != 2'd0) & (hsize29 == `SZ_WORD29)))    &
            ((htrans29 == `TRN_NONSEQ29) | (htrans29 == `TRN_SEQ29)) &
            (cs != 1'b0) )
          
           mis_err29 = 1'h1;
             
        else
          
           mis_err29 = 1'h0;

     end 
   
//----------------------------------------------------------------------
// Disable29 detection29
//----------------------------------------------------------------------

   always @(htrans29 or cs or smc_idle29 or hready29)
     
     begin
             
           dis_err29 = 1'h0;
             
     end 
   
//----------------------------------------------------------------------
// Response29
//----------------------------------------------------------------------

   always @(posedge hclk29 or negedge n_sys_reset29)
     
     begin
             
        if (~n_sys_reset29)
          
            begin
             
               smc_hresp29 <= `RSP_OKAY29;
               r_hresp29 <= 1'd0;
             
            end
             
        else if (mis_err29 | dis_err29)
          
            begin
             
               r_hresp29 <= 1'd1;
               smc_hresp29 <= `RSP_ERROR29;
             
            end
             
        else if (r_hresp29 == 1'd1)
          
           begin
             
              smc_hresp29 <= `RSP_ERROR29;
              r_hresp29 <= 1'd0;
             
           end
             
        else
          
           begin
             
              smc_hresp29 <= `RSP_OKAY29;
              r_hresp29 <= 1'd0;
             
           end
             
     end
   
//----------------------------------------------------------------------
// assign read access sense
//----------------------------------------------------------------------

   always @(hwrite29)
     
     begin
             
        n_read29 = hwrite29;
             
     end

//----------------------------------------------------------------------
// AHB29 ready signal29
//----------------------------------------------------------------------

   always @(posedge hclk29 or negedge n_sys_reset29)
     
     begin
             
        if (~n_sys_reset29)
          
           r_ready29 <= 1'b1;
             
        else if ((((htrans29 == `TRN_IDLE29) | (htrans29 == `TRN_BUSY29)) & 
                  (cs != 1'b0) & hready29 & ~mis_err29 & 
                  ~dis_err29) | r_hresp29 | (hsel29 == 1'b0) )
          
           r_ready29 <= 1'b1;
             
        else
          
           r_ready29 <= 1'b0;
             
     end
 
//----------------------------------------------------------------------
//smc29 ready
//----------------------------------------------------------------------

   always @(r_ready29 or smc_done29 or mac_done29)
     
     begin
             
        smc_hready29 = r_ready29 | (smc_done29 & mac_done29);
             
     end
   
//----------------------------------------------------------------------
//read data
//----------------------------------------------------------------------
   
   always @(read_data29)
     
      smc_hrdata29 = read_data29;

//----------------------------------------------------------------------
//write data
//----------------------------------------------------------------------

   always @(hwdata29)
     
      write_data29 = hwdata29;
   


endmodule

