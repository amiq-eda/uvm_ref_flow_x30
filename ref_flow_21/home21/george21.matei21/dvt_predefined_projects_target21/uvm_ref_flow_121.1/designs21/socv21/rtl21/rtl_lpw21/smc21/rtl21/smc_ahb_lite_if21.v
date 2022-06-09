//File21 name   : smc_ahb_lite_if21.v
//Title21       : 
//Created21     : 1999
//Description21 : AMBA21 AHB21 Interface21.
//            : Static21 Memory Controller21.
//            : This21 block provides21 the AHB21 interface. 
//            : All AHB21 specific21 signals21 are contained in this
//            : block.
//            : All address decoding21 for the SMC21 module is 
//            : done in
//            : this module and chip21 select21 signals21 generated21
//            : as well21 as an address valid (SMC_valid21) signal21
//            : back to the AHB21 decoder21
//Notes21       : 
//----------------------------------------------------------------------
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------



`include "smc_defs_lite21.v"

//ahb21 interface
  module smc_ahb_lite_if21  (

                      //inputs21

                      hclk21, 
                      n_sys_reset21, 
                      haddr21, 
                      hsel21,
                      htrans21, 
                      hwrite21, 
                      hsize21, 
                      hwdata21,  
                      hready21,  
  
                      //outputs21
  
                      smc_idle21,
                      read_data21, 
                      mac_done21, 
                      smc_done21, 
                      xfer_size21, 
                      n_read21, 
                      new_access21, 
                      addr, 
                      smc_hrdata21, 
                      smc_hready21,
                      smc_hresp21,
                      smc_valid21, 
                      cs, 
                      write_data21 
                      );
  
  
//include files


//----------------------------------------------------------------------


//System21 I21/O21

  input         hclk21;                   // AHB21 System21 clock21
  input         n_sys_reset21;            // AHB21 System21 reset (Active21 LOW21)
 

//AHB21 I21/O21

  input  [31:0]            haddr21;         // AHB21 Address
  input  [1:0]             htrans21;        // AHB21 transfer21 type
  input                    hwrite21;        // AHB21 read/write indication21
  input  [2:0]             hsize21;         // AHB21 transfer21 size
  input  [31:0]            hwdata21;        // AHB21 write data
  input                    hready21;        // AHB21 Muxed21 ready signal21
  output [31:0]            smc_hrdata21;    // smc21 read data back to AHB21
                                             //  master21
  output                   smc_hready21;    // smc21 ready signal21
  output [1:0]             smc_hresp21;     // AHB21 Response21 signal21
  output                   smc_valid21;     // Ack21 to AHB21

//other I21/O21
   
  input                    smc_idle21;      // idle21 state
  input                    smc_done21;      // Asserted21 during 
                                          // last cycle of an access
  input                    mac_done21;      // End21 of all transfers21
  input [31:0]             read_data21;     // Data at internal Bus21
  input               hsel21;          // Chip21 Selects21
   

  output [1:0]             xfer_size21;     // Store21 size for MAC21
  output [31:0]            addr;          // address
  output              cs;          // chip21 selects21 for external21
                                              //  memories
  output [31:0]            write_data21;    // Data to External21 Bus21
  output                   n_read21;        // Active21 low21 read signal21 
  output                   new_access21;    // New21 AHB21 valid access to
                                              //  smc21 detected




// Address Config21







//----------------------------------------------------------------------
// Signal21 declarations21
//----------------------------------------------------------------------

// Output21 register declarations21

// Bus21 Interface21

  reg  [31:0]              smc_hrdata21;  // smc21 read data back to
                                           //  AHB21 master21
  reg                      smc_hready21;  // smc21 ready signal21
  reg  [1:0]               smc_hresp21;   // AHB21 Response21 signal21
  reg                      smc_valid21;   // Ack21 to AHB21

// Internal register declarations21

// Bus21 Interface21

  reg                      new_access21;  // New21 AHB21 valid access
                                           //  to smc21 detected
                                           //  cfg block
  reg  [31:0]              addr;        // Copy21 of address
  reg  [31:0]              write_data21;  // Data to External21 Bus21
  reg  [7:0]               int_cs21;      // Chip21(bank21) Select21 Lines21
  wire                cs;          // Chip21(bank21) Select21 Lines21
  reg  [1:0]               xfer_size21;   // Width21 of current transfer21
  reg                      n_read21;      // Active21 low21 read signal21   
  reg                      r_ready21;     // registered ready signal21   
  reg                      r_hresp21;     // Two21 cycle hresp21 on error
  reg                      mis_err21;     // Misalignment21
  reg                      dis_err21;     // error

// End21 Bus21 Interface21



//----------------------------------------------------------------------
// Beginning21 of main21 code21
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// valid access control21 - AHB21 Interface21 (AHB21 Specific21)
//----------------------------------------------------------------------
// Generates21 the stobes21 required21 to start the smc21 state machine21
// Generates21 all AHB21 responses21.
//----------------------------------------------------------------------

   always @(hsize21)

     begin
     
      xfer_size21 = hsize21[1:0];

     end
   
//----------------------------------------------------------------------
//addr
//----------------------------------------------------------------------

   always @(haddr21)
     
     begin
        
        addr = haddr21;
        
     end
   
//----------------------------------------------------------------------
//chip21 select21 generation21
//----------------------------------------------------------------------

   assign cs = ( hsel21 ) ;
    
//----------------------------------------------------------------------
// detect21 a valid access
//----------------------------------------------------------------------

   always @(cs or hready21 or htrans21 or mis_err21)
     
     begin
             
       if (((htrans21 == `TRN_NONSEQ21) | (htrans21 == `TRN_SEQ21)) &
            (cs != 'd0) & hready21 & ~mis_err21)
          
          begin
             
             smc_valid21 = 1'b1;
             
               
             new_access21 = 1'b1;
             
             
          end
             
       else
          
          begin
             
             smc_valid21 = 1'b0;
             new_access21 = 1'b0;
             
          end
             
     end

//----------------------------------------------------------------------
// Error detection21
//----------------------------------------------------------------------

   always @(haddr21 or hsize21 or htrans21 or cs)
     
     begin
             
        if ((((haddr21[0] != 1'd0) & (hsize21 == `SZ_HALF21))      |
             ((haddr21[1:0] != 2'd0) & (hsize21 == `SZ_WORD21)))    &
            ((htrans21 == `TRN_NONSEQ21) | (htrans21 == `TRN_SEQ21)) &
            (cs != 1'b0) )
          
           mis_err21 = 1'h1;
             
        else
          
           mis_err21 = 1'h0;

     end 
   
//----------------------------------------------------------------------
// Disable21 detection21
//----------------------------------------------------------------------

   always @(htrans21 or cs or smc_idle21 or hready21)
     
     begin
             
           dis_err21 = 1'h0;
             
     end 
   
//----------------------------------------------------------------------
// Response21
//----------------------------------------------------------------------

   always @(posedge hclk21 or negedge n_sys_reset21)
     
     begin
             
        if (~n_sys_reset21)
          
            begin
             
               smc_hresp21 <= `RSP_OKAY21;
               r_hresp21 <= 1'd0;
             
            end
             
        else if (mis_err21 | dis_err21)
          
            begin
             
               r_hresp21 <= 1'd1;
               smc_hresp21 <= `RSP_ERROR21;
             
            end
             
        else if (r_hresp21 == 1'd1)
          
           begin
             
              smc_hresp21 <= `RSP_ERROR21;
              r_hresp21 <= 1'd0;
             
           end
             
        else
          
           begin
             
              smc_hresp21 <= `RSP_OKAY21;
              r_hresp21 <= 1'd0;
             
           end
             
     end
   
//----------------------------------------------------------------------
// assign read access sense
//----------------------------------------------------------------------

   always @(hwrite21)
     
     begin
             
        n_read21 = hwrite21;
             
     end

//----------------------------------------------------------------------
// AHB21 ready signal21
//----------------------------------------------------------------------

   always @(posedge hclk21 or negedge n_sys_reset21)
     
     begin
             
        if (~n_sys_reset21)
          
           r_ready21 <= 1'b1;
             
        else if ((((htrans21 == `TRN_IDLE21) | (htrans21 == `TRN_BUSY21)) & 
                  (cs != 1'b0) & hready21 & ~mis_err21 & 
                  ~dis_err21) | r_hresp21 | (hsel21 == 1'b0) )
          
           r_ready21 <= 1'b1;
             
        else
          
           r_ready21 <= 1'b0;
             
     end
 
//----------------------------------------------------------------------
//smc21 ready
//----------------------------------------------------------------------

   always @(r_ready21 or smc_done21 or mac_done21)
     
     begin
             
        smc_hready21 = r_ready21 | (smc_done21 & mac_done21);
             
     end
   
//----------------------------------------------------------------------
//read data
//----------------------------------------------------------------------
   
   always @(read_data21)
     
      smc_hrdata21 = read_data21;

//----------------------------------------------------------------------
//write data
//----------------------------------------------------------------------

   always @(hwdata21)
     
      write_data21 = hwdata21;
   


endmodule

