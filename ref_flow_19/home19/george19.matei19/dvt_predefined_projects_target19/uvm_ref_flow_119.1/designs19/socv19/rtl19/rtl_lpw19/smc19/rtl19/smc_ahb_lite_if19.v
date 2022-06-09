//File19 name   : smc_ahb_lite_if19.v
//Title19       : 
//Created19     : 1999
//Description19 : AMBA19 AHB19 Interface19.
//            : Static19 Memory Controller19.
//            : This19 block provides19 the AHB19 interface. 
//            : All AHB19 specific19 signals19 are contained in this
//            : block.
//            : All address decoding19 for the SMC19 module is 
//            : done in
//            : this module and chip19 select19 signals19 generated19
//            : as well19 as an address valid (SMC_valid19) signal19
//            : back to the AHB19 decoder19
//Notes19       : 
//----------------------------------------------------------------------
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------



`include "smc_defs_lite19.v"

//ahb19 interface
  module smc_ahb_lite_if19  (

                      //inputs19

                      hclk19, 
                      n_sys_reset19, 
                      haddr19, 
                      hsel19,
                      htrans19, 
                      hwrite19, 
                      hsize19, 
                      hwdata19,  
                      hready19,  
  
                      //outputs19
  
                      smc_idle19,
                      read_data19, 
                      mac_done19, 
                      smc_done19, 
                      xfer_size19, 
                      n_read19, 
                      new_access19, 
                      addr, 
                      smc_hrdata19, 
                      smc_hready19,
                      smc_hresp19,
                      smc_valid19, 
                      cs, 
                      write_data19 
                      );
  
  
//include files


//----------------------------------------------------------------------


//System19 I19/O19

  input         hclk19;                   // AHB19 System19 clock19
  input         n_sys_reset19;            // AHB19 System19 reset (Active19 LOW19)
 

//AHB19 I19/O19

  input  [31:0]            haddr19;         // AHB19 Address
  input  [1:0]             htrans19;        // AHB19 transfer19 type
  input                    hwrite19;        // AHB19 read/write indication19
  input  [2:0]             hsize19;         // AHB19 transfer19 size
  input  [31:0]            hwdata19;        // AHB19 write data
  input                    hready19;        // AHB19 Muxed19 ready signal19
  output [31:0]            smc_hrdata19;    // smc19 read data back to AHB19
                                             //  master19
  output                   smc_hready19;    // smc19 ready signal19
  output [1:0]             smc_hresp19;     // AHB19 Response19 signal19
  output                   smc_valid19;     // Ack19 to AHB19

//other I19/O19
   
  input                    smc_idle19;      // idle19 state
  input                    smc_done19;      // Asserted19 during 
                                          // last cycle of an access
  input                    mac_done19;      // End19 of all transfers19
  input [31:0]             read_data19;     // Data at internal Bus19
  input               hsel19;          // Chip19 Selects19
   

  output [1:0]             xfer_size19;     // Store19 size for MAC19
  output [31:0]            addr;          // address
  output              cs;          // chip19 selects19 for external19
                                              //  memories
  output [31:0]            write_data19;    // Data to External19 Bus19
  output                   n_read19;        // Active19 low19 read signal19 
  output                   new_access19;    // New19 AHB19 valid access to
                                              //  smc19 detected




// Address Config19







//----------------------------------------------------------------------
// Signal19 declarations19
//----------------------------------------------------------------------

// Output19 register declarations19

// Bus19 Interface19

  reg  [31:0]              smc_hrdata19;  // smc19 read data back to
                                           //  AHB19 master19
  reg                      smc_hready19;  // smc19 ready signal19
  reg  [1:0]               smc_hresp19;   // AHB19 Response19 signal19
  reg                      smc_valid19;   // Ack19 to AHB19

// Internal register declarations19

// Bus19 Interface19

  reg                      new_access19;  // New19 AHB19 valid access
                                           //  to smc19 detected
                                           //  cfg block
  reg  [31:0]              addr;        // Copy19 of address
  reg  [31:0]              write_data19;  // Data to External19 Bus19
  reg  [7:0]               int_cs19;      // Chip19(bank19) Select19 Lines19
  wire                cs;          // Chip19(bank19) Select19 Lines19
  reg  [1:0]               xfer_size19;   // Width19 of current transfer19
  reg                      n_read19;      // Active19 low19 read signal19   
  reg                      r_ready19;     // registered ready signal19   
  reg                      r_hresp19;     // Two19 cycle hresp19 on error
  reg                      mis_err19;     // Misalignment19
  reg                      dis_err19;     // error

// End19 Bus19 Interface19



//----------------------------------------------------------------------
// Beginning19 of main19 code19
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// valid access control19 - AHB19 Interface19 (AHB19 Specific19)
//----------------------------------------------------------------------
// Generates19 the stobes19 required19 to start the smc19 state machine19
// Generates19 all AHB19 responses19.
//----------------------------------------------------------------------

   always @(hsize19)

     begin
     
      xfer_size19 = hsize19[1:0];

     end
   
//----------------------------------------------------------------------
//addr
//----------------------------------------------------------------------

   always @(haddr19)
     
     begin
        
        addr = haddr19;
        
     end
   
//----------------------------------------------------------------------
//chip19 select19 generation19
//----------------------------------------------------------------------

   assign cs = ( hsel19 ) ;
    
//----------------------------------------------------------------------
// detect19 a valid access
//----------------------------------------------------------------------

   always @(cs or hready19 or htrans19 or mis_err19)
     
     begin
             
       if (((htrans19 == `TRN_NONSEQ19) | (htrans19 == `TRN_SEQ19)) &
            (cs != 'd0) & hready19 & ~mis_err19)
          
          begin
             
             smc_valid19 = 1'b1;
             
               
             new_access19 = 1'b1;
             
             
          end
             
       else
          
          begin
             
             smc_valid19 = 1'b0;
             new_access19 = 1'b0;
             
          end
             
     end

//----------------------------------------------------------------------
// Error detection19
//----------------------------------------------------------------------

   always @(haddr19 or hsize19 or htrans19 or cs)
     
     begin
             
        if ((((haddr19[0] != 1'd0) & (hsize19 == `SZ_HALF19))      |
             ((haddr19[1:0] != 2'd0) & (hsize19 == `SZ_WORD19)))    &
            ((htrans19 == `TRN_NONSEQ19) | (htrans19 == `TRN_SEQ19)) &
            (cs != 1'b0) )
          
           mis_err19 = 1'h1;
             
        else
          
           mis_err19 = 1'h0;

     end 
   
//----------------------------------------------------------------------
// Disable19 detection19
//----------------------------------------------------------------------

   always @(htrans19 or cs or smc_idle19 or hready19)
     
     begin
             
           dis_err19 = 1'h0;
             
     end 
   
//----------------------------------------------------------------------
// Response19
//----------------------------------------------------------------------

   always @(posedge hclk19 or negedge n_sys_reset19)
     
     begin
             
        if (~n_sys_reset19)
          
            begin
             
               smc_hresp19 <= `RSP_OKAY19;
               r_hresp19 <= 1'd0;
             
            end
             
        else if (mis_err19 | dis_err19)
          
            begin
             
               r_hresp19 <= 1'd1;
               smc_hresp19 <= `RSP_ERROR19;
             
            end
             
        else if (r_hresp19 == 1'd1)
          
           begin
             
              smc_hresp19 <= `RSP_ERROR19;
              r_hresp19 <= 1'd0;
             
           end
             
        else
          
           begin
             
              smc_hresp19 <= `RSP_OKAY19;
              r_hresp19 <= 1'd0;
             
           end
             
     end
   
//----------------------------------------------------------------------
// assign read access sense
//----------------------------------------------------------------------

   always @(hwrite19)
     
     begin
             
        n_read19 = hwrite19;
             
     end

//----------------------------------------------------------------------
// AHB19 ready signal19
//----------------------------------------------------------------------

   always @(posedge hclk19 or negedge n_sys_reset19)
     
     begin
             
        if (~n_sys_reset19)
          
           r_ready19 <= 1'b1;
             
        else if ((((htrans19 == `TRN_IDLE19) | (htrans19 == `TRN_BUSY19)) & 
                  (cs != 1'b0) & hready19 & ~mis_err19 & 
                  ~dis_err19) | r_hresp19 | (hsel19 == 1'b0) )
          
           r_ready19 <= 1'b1;
             
        else
          
           r_ready19 <= 1'b0;
             
     end
 
//----------------------------------------------------------------------
//smc19 ready
//----------------------------------------------------------------------

   always @(r_ready19 or smc_done19 or mac_done19)
     
     begin
             
        smc_hready19 = r_ready19 | (smc_done19 & mac_done19);
             
     end
   
//----------------------------------------------------------------------
//read data
//----------------------------------------------------------------------
   
   always @(read_data19)
     
      smc_hrdata19 = read_data19;

//----------------------------------------------------------------------
//write data
//----------------------------------------------------------------------

   always @(hwdata19)
     
      write_data19 = hwdata19;
   


endmodule

