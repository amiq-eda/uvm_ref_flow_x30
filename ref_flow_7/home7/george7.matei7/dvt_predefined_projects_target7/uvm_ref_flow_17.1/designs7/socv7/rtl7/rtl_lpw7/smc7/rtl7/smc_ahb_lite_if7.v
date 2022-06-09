//File7 name   : smc_ahb_lite_if7.v
//Title7       : 
//Created7     : 1999
//Description7 : AMBA7 AHB7 Interface7.
//            : Static7 Memory Controller7.
//            : This7 block provides7 the AHB7 interface. 
//            : All AHB7 specific7 signals7 are contained in this
//            : block.
//            : All address decoding7 for the SMC7 module is 
//            : done in
//            : this module and chip7 select7 signals7 generated7
//            : as well7 as an address valid (SMC_valid7) signal7
//            : back to the AHB7 decoder7
//Notes7       : 
//----------------------------------------------------------------------
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------



`include "smc_defs_lite7.v"

//ahb7 interface
  module smc_ahb_lite_if7  (

                      //inputs7

                      hclk7, 
                      n_sys_reset7, 
                      haddr7, 
                      hsel7,
                      htrans7, 
                      hwrite7, 
                      hsize7, 
                      hwdata7,  
                      hready7,  
  
                      //outputs7
  
                      smc_idle7,
                      read_data7, 
                      mac_done7, 
                      smc_done7, 
                      xfer_size7, 
                      n_read7, 
                      new_access7, 
                      addr, 
                      smc_hrdata7, 
                      smc_hready7,
                      smc_hresp7,
                      smc_valid7, 
                      cs, 
                      write_data7 
                      );
  
  
//include files


//----------------------------------------------------------------------


//System7 I7/O7

  input         hclk7;                   // AHB7 System7 clock7
  input         n_sys_reset7;            // AHB7 System7 reset (Active7 LOW7)
 

//AHB7 I7/O7

  input  [31:0]            haddr7;         // AHB7 Address
  input  [1:0]             htrans7;        // AHB7 transfer7 type
  input                    hwrite7;        // AHB7 read/write indication7
  input  [2:0]             hsize7;         // AHB7 transfer7 size
  input  [31:0]            hwdata7;        // AHB7 write data
  input                    hready7;        // AHB7 Muxed7 ready signal7
  output [31:0]            smc_hrdata7;    // smc7 read data back to AHB7
                                             //  master7
  output                   smc_hready7;    // smc7 ready signal7
  output [1:0]             smc_hresp7;     // AHB7 Response7 signal7
  output                   smc_valid7;     // Ack7 to AHB7

//other I7/O7
   
  input                    smc_idle7;      // idle7 state
  input                    smc_done7;      // Asserted7 during 
                                          // last cycle of an access
  input                    mac_done7;      // End7 of all transfers7
  input [31:0]             read_data7;     // Data at internal Bus7
  input               hsel7;          // Chip7 Selects7
   

  output [1:0]             xfer_size7;     // Store7 size for MAC7
  output [31:0]            addr;          // address
  output              cs;          // chip7 selects7 for external7
                                              //  memories
  output [31:0]            write_data7;    // Data to External7 Bus7
  output                   n_read7;        // Active7 low7 read signal7 
  output                   new_access7;    // New7 AHB7 valid access to
                                              //  smc7 detected




// Address Config7







//----------------------------------------------------------------------
// Signal7 declarations7
//----------------------------------------------------------------------

// Output7 register declarations7

// Bus7 Interface7

  reg  [31:0]              smc_hrdata7;  // smc7 read data back to
                                           //  AHB7 master7
  reg                      smc_hready7;  // smc7 ready signal7
  reg  [1:0]               smc_hresp7;   // AHB7 Response7 signal7
  reg                      smc_valid7;   // Ack7 to AHB7

// Internal register declarations7

// Bus7 Interface7

  reg                      new_access7;  // New7 AHB7 valid access
                                           //  to smc7 detected
                                           //  cfg block
  reg  [31:0]              addr;        // Copy7 of address
  reg  [31:0]              write_data7;  // Data to External7 Bus7
  reg  [7:0]               int_cs7;      // Chip7(bank7) Select7 Lines7
  wire                cs;          // Chip7(bank7) Select7 Lines7
  reg  [1:0]               xfer_size7;   // Width7 of current transfer7
  reg                      n_read7;      // Active7 low7 read signal7   
  reg                      r_ready7;     // registered ready signal7   
  reg                      r_hresp7;     // Two7 cycle hresp7 on error
  reg                      mis_err7;     // Misalignment7
  reg                      dis_err7;     // error

// End7 Bus7 Interface7



//----------------------------------------------------------------------
// Beginning7 of main7 code7
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// valid access control7 - AHB7 Interface7 (AHB7 Specific7)
//----------------------------------------------------------------------
// Generates7 the stobes7 required7 to start the smc7 state machine7
// Generates7 all AHB7 responses7.
//----------------------------------------------------------------------

   always @(hsize7)

     begin
     
      xfer_size7 = hsize7[1:0];

     end
   
//----------------------------------------------------------------------
//addr
//----------------------------------------------------------------------

   always @(haddr7)
     
     begin
        
        addr = haddr7;
        
     end
   
//----------------------------------------------------------------------
//chip7 select7 generation7
//----------------------------------------------------------------------

   assign cs = ( hsel7 ) ;
    
//----------------------------------------------------------------------
// detect7 a valid access
//----------------------------------------------------------------------

   always @(cs or hready7 or htrans7 or mis_err7)
     
     begin
             
       if (((htrans7 == `TRN_NONSEQ7) | (htrans7 == `TRN_SEQ7)) &
            (cs != 'd0) & hready7 & ~mis_err7)
          
          begin
             
             smc_valid7 = 1'b1;
             
               
             new_access7 = 1'b1;
             
             
          end
             
       else
          
          begin
             
             smc_valid7 = 1'b0;
             new_access7 = 1'b0;
             
          end
             
     end

//----------------------------------------------------------------------
// Error detection7
//----------------------------------------------------------------------

   always @(haddr7 or hsize7 or htrans7 or cs)
     
     begin
             
        if ((((haddr7[0] != 1'd0) & (hsize7 == `SZ_HALF7))      |
             ((haddr7[1:0] != 2'd0) & (hsize7 == `SZ_WORD7)))    &
            ((htrans7 == `TRN_NONSEQ7) | (htrans7 == `TRN_SEQ7)) &
            (cs != 1'b0) )
          
           mis_err7 = 1'h1;
             
        else
          
           mis_err7 = 1'h0;

     end 
   
//----------------------------------------------------------------------
// Disable7 detection7
//----------------------------------------------------------------------

   always @(htrans7 or cs or smc_idle7 or hready7)
     
     begin
             
           dis_err7 = 1'h0;
             
     end 
   
//----------------------------------------------------------------------
// Response7
//----------------------------------------------------------------------

   always @(posedge hclk7 or negedge n_sys_reset7)
     
     begin
             
        if (~n_sys_reset7)
          
            begin
             
               smc_hresp7 <= `RSP_OKAY7;
               r_hresp7 <= 1'd0;
             
            end
             
        else if (mis_err7 | dis_err7)
          
            begin
             
               r_hresp7 <= 1'd1;
               smc_hresp7 <= `RSP_ERROR7;
             
            end
             
        else if (r_hresp7 == 1'd1)
          
           begin
             
              smc_hresp7 <= `RSP_ERROR7;
              r_hresp7 <= 1'd0;
             
           end
             
        else
          
           begin
             
              smc_hresp7 <= `RSP_OKAY7;
              r_hresp7 <= 1'd0;
             
           end
             
     end
   
//----------------------------------------------------------------------
// assign read access sense
//----------------------------------------------------------------------

   always @(hwrite7)
     
     begin
             
        n_read7 = hwrite7;
             
     end

//----------------------------------------------------------------------
// AHB7 ready signal7
//----------------------------------------------------------------------

   always @(posedge hclk7 or negedge n_sys_reset7)
     
     begin
             
        if (~n_sys_reset7)
          
           r_ready7 <= 1'b1;
             
        else if ((((htrans7 == `TRN_IDLE7) | (htrans7 == `TRN_BUSY7)) & 
                  (cs != 1'b0) & hready7 & ~mis_err7 & 
                  ~dis_err7) | r_hresp7 | (hsel7 == 1'b0) )
          
           r_ready7 <= 1'b1;
             
        else
          
           r_ready7 <= 1'b0;
             
     end
 
//----------------------------------------------------------------------
//smc7 ready
//----------------------------------------------------------------------

   always @(r_ready7 or smc_done7 or mac_done7)
     
     begin
             
        smc_hready7 = r_ready7 | (smc_done7 & mac_done7);
             
     end
   
//----------------------------------------------------------------------
//read data
//----------------------------------------------------------------------
   
   always @(read_data7)
     
      smc_hrdata7 = read_data7;

//----------------------------------------------------------------------
//write data
//----------------------------------------------------------------------

   always @(hwdata7)
     
      write_data7 = hwdata7;
   


endmodule

