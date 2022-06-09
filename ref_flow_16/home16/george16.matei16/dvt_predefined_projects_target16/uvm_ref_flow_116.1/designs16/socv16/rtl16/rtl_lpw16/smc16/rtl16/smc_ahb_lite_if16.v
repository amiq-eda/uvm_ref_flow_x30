//File16 name   : smc_ahb_lite_if16.v
//Title16       : 
//Created16     : 1999
//Description16 : AMBA16 AHB16 Interface16.
//            : Static16 Memory Controller16.
//            : This16 block provides16 the AHB16 interface. 
//            : All AHB16 specific16 signals16 are contained in this
//            : block.
//            : All address decoding16 for the SMC16 module is 
//            : done in
//            : this module and chip16 select16 signals16 generated16
//            : as well16 as an address valid (SMC_valid16) signal16
//            : back to the AHB16 decoder16
//Notes16       : 
//----------------------------------------------------------------------
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------



`include "smc_defs_lite16.v"

//ahb16 interface
  module smc_ahb_lite_if16  (

                      //inputs16

                      hclk16, 
                      n_sys_reset16, 
                      haddr16, 
                      hsel16,
                      htrans16, 
                      hwrite16, 
                      hsize16, 
                      hwdata16,  
                      hready16,  
  
                      //outputs16
  
                      smc_idle16,
                      read_data16, 
                      mac_done16, 
                      smc_done16, 
                      xfer_size16, 
                      n_read16, 
                      new_access16, 
                      addr, 
                      smc_hrdata16, 
                      smc_hready16,
                      smc_hresp16,
                      smc_valid16, 
                      cs, 
                      write_data16 
                      );
  
  
//include files


//----------------------------------------------------------------------


//System16 I16/O16

  input         hclk16;                   // AHB16 System16 clock16
  input         n_sys_reset16;            // AHB16 System16 reset (Active16 LOW16)
 

//AHB16 I16/O16

  input  [31:0]            haddr16;         // AHB16 Address
  input  [1:0]             htrans16;        // AHB16 transfer16 type
  input                    hwrite16;        // AHB16 read/write indication16
  input  [2:0]             hsize16;         // AHB16 transfer16 size
  input  [31:0]            hwdata16;        // AHB16 write data
  input                    hready16;        // AHB16 Muxed16 ready signal16
  output [31:0]            smc_hrdata16;    // smc16 read data back to AHB16
                                             //  master16
  output                   smc_hready16;    // smc16 ready signal16
  output [1:0]             smc_hresp16;     // AHB16 Response16 signal16
  output                   smc_valid16;     // Ack16 to AHB16

//other I16/O16
   
  input                    smc_idle16;      // idle16 state
  input                    smc_done16;      // Asserted16 during 
                                          // last cycle of an access
  input                    mac_done16;      // End16 of all transfers16
  input [31:0]             read_data16;     // Data at internal Bus16
  input               hsel16;          // Chip16 Selects16
   

  output [1:0]             xfer_size16;     // Store16 size for MAC16
  output [31:0]            addr;          // address
  output              cs;          // chip16 selects16 for external16
                                              //  memories
  output [31:0]            write_data16;    // Data to External16 Bus16
  output                   n_read16;        // Active16 low16 read signal16 
  output                   new_access16;    // New16 AHB16 valid access to
                                              //  smc16 detected




// Address Config16







//----------------------------------------------------------------------
// Signal16 declarations16
//----------------------------------------------------------------------

// Output16 register declarations16

// Bus16 Interface16

  reg  [31:0]              smc_hrdata16;  // smc16 read data back to
                                           //  AHB16 master16
  reg                      smc_hready16;  // smc16 ready signal16
  reg  [1:0]               smc_hresp16;   // AHB16 Response16 signal16
  reg                      smc_valid16;   // Ack16 to AHB16

// Internal register declarations16

// Bus16 Interface16

  reg                      new_access16;  // New16 AHB16 valid access
                                           //  to smc16 detected
                                           //  cfg block
  reg  [31:0]              addr;        // Copy16 of address
  reg  [31:0]              write_data16;  // Data to External16 Bus16
  reg  [7:0]               int_cs16;      // Chip16(bank16) Select16 Lines16
  wire                cs;          // Chip16(bank16) Select16 Lines16
  reg  [1:0]               xfer_size16;   // Width16 of current transfer16
  reg                      n_read16;      // Active16 low16 read signal16   
  reg                      r_ready16;     // registered ready signal16   
  reg                      r_hresp16;     // Two16 cycle hresp16 on error
  reg                      mis_err16;     // Misalignment16
  reg                      dis_err16;     // error

// End16 Bus16 Interface16



//----------------------------------------------------------------------
// Beginning16 of main16 code16
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// valid access control16 - AHB16 Interface16 (AHB16 Specific16)
//----------------------------------------------------------------------
// Generates16 the stobes16 required16 to start the smc16 state machine16
// Generates16 all AHB16 responses16.
//----------------------------------------------------------------------

   always @(hsize16)

     begin
     
      xfer_size16 = hsize16[1:0];

     end
   
//----------------------------------------------------------------------
//addr
//----------------------------------------------------------------------

   always @(haddr16)
     
     begin
        
        addr = haddr16;
        
     end
   
//----------------------------------------------------------------------
//chip16 select16 generation16
//----------------------------------------------------------------------

   assign cs = ( hsel16 ) ;
    
//----------------------------------------------------------------------
// detect16 a valid access
//----------------------------------------------------------------------

   always @(cs or hready16 or htrans16 or mis_err16)
     
     begin
             
       if (((htrans16 == `TRN_NONSEQ16) | (htrans16 == `TRN_SEQ16)) &
            (cs != 'd0) & hready16 & ~mis_err16)
          
          begin
             
             smc_valid16 = 1'b1;
             
               
             new_access16 = 1'b1;
             
             
          end
             
       else
          
          begin
             
             smc_valid16 = 1'b0;
             new_access16 = 1'b0;
             
          end
             
     end

//----------------------------------------------------------------------
// Error detection16
//----------------------------------------------------------------------

   always @(haddr16 or hsize16 or htrans16 or cs)
     
     begin
             
        if ((((haddr16[0] != 1'd0) & (hsize16 == `SZ_HALF16))      |
             ((haddr16[1:0] != 2'd0) & (hsize16 == `SZ_WORD16)))    &
            ((htrans16 == `TRN_NONSEQ16) | (htrans16 == `TRN_SEQ16)) &
            (cs != 1'b0) )
          
           mis_err16 = 1'h1;
             
        else
          
           mis_err16 = 1'h0;

     end 
   
//----------------------------------------------------------------------
// Disable16 detection16
//----------------------------------------------------------------------

   always @(htrans16 or cs or smc_idle16 or hready16)
     
     begin
             
           dis_err16 = 1'h0;
             
     end 
   
//----------------------------------------------------------------------
// Response16
//----------------------------------------------------------------------

   always @(posedge hclk16 or negedge n_sys_reset16)
     
     begin
             
        if (~n_sys_reset16)
          
            begin
             
               smc_hresp16 <= `RSP_OKAY16;
               r_hresp16 <= 1'd0;
             
            end
             
        else if (mis_err16 | dis_err16)
          
            begin
             
               r_hresp16 <= 1'd1;
               smc_hresp16 <= `RSP_ERROR16;
             
            end
             
        else if (r_hresp16 == 1'd1)
          
           begin
             
              smc_hresp16 <= `RSP_ERROR16;
              r_hresp16 <= 1'd0;
             
           end
             
        else
          
           begin
             
              smc_hresp16 <= `RSP_OKAY16;
              r_hresp16 <= 1'd0;
             
           end
             
     end
   
//----------------------------------------------------------------------
// assign read access sense
//----------------------------------------------------------------------

   always @(hwrite16)
     
     begin
             
        n_read16 = hwrite16;
             
     end

//----------------------------------------------------------------------
// AHB16 ready signal16
//----------------------------------------------------------------------

   always @(posedge hclk16 or negedge n_sys_reset16)
     
     begin
             
        if (~n_sys_reset16)
          
           r_ready16 <= 1'b1;
             
        else if ((((htrans16 == `TRN_IDLE16) | (htrans16 == `TRN_BUSY16)) & 
                  (cs != 1'b0) & hready16 & ~mis_err16 & 
                  ~dis_err16) | r_hresp16 | (hsel16 == 1'b0) )
          
           r_ready16 <= 1'b1;
             
        else
          
           r_ready16 <= 1'b0;
             
     end
 
//----------------------------------------------------------------------
//smc16 ready
//----------------------------------------------------------------------

   always @(r_ready16 or smc_done16 or mac_done16)
     
     begin
             
        smc_hready16 = r_ready16 | (smc_done16 & mac_done16);
             
     end
   
//----------------------------------------------------------------------
//read data
//----------------------------------------------------------------------
   
   always @(read_data16)
     
      smc_hrdata16 = read_data16;

//----------------------------------------------------------------------
//write data
//----------------------------------------------------------------------

   always @(hwdata16)
     
      write_data16 = hwdata16;
   


endmodule

