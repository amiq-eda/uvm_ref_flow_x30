//File14 name   : smc_ahb_lite_if14.v
//Title14       : 
//Created14     : 1999
//Description14 : AMBA14 AHB14 Interface14.
//            : Static14 Memory Controller14.
//            : This14 block provides14 the AHB14 interface. 
//            : All AHB14 specific14 signals14 are contained in this
//            : block.
//            : All address decoding14 for the SMC14 module is 
//            : done in
//            : this module and chip14 select14 signals14 generated14
//            : as well14 as an address valid (SMC_valid14) signal14
//            : back to the AHB14 decoder14
//Notes14       : 
//----------------------------------------------------------------------
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------



`include "smc_defs_lite14.v"

//ahb14 interface
  module smc_ahb_lite_if14  (

                      //inputs14

                      hclk14, 
                      n_sys_reset14, 
                      haddr14, 
                      hsel14,
                      htrans14, 
                      hwrite14, 
                      hsize14, 
                      hwdata14,  
                      hready14,  
  
                      //outputs14
  
                      smc_idle14,
                      read_data14, 
                      mac_done14, 
                      smc_done14, 
                      xfer_size14, 
                      n_read14, 
                      new_access14, 
                      addr, 
                      smc_hrdata14, 
                      smc_hready14,
                      smc_hresp14,
                      smc_valid14, 
                      cs, 
                      write_data14 
                      );
  
  
//include files


//----------------------------------------------------------------------


//System14 I14/O14

  input         hclk14;                   // AHB14 System14 clock14
  input         n_sys_reset14;            // AHB14 System14 reset (Active14 LOW14)
 

//AHB14 I14/O14

  input  [31:0]            haddr14;         // AHB14 Address
  input  [1:0]             htrans14;        // AHB14 transfer14 type
  input                    hwrite14;        // AHB14 read/write indication14
  input  [2:0]             hsize14;         // AHB14 transfer14 size
  input  [31:0]            hwdata14;        // AHB14 write data
  input                    hready14;        // AHB14 Muxed14 ready signal14
  output [31:0]            smc_hrdata14;    // smc14 read data back to AHB14
                                             //  master14
  output                   smc_hready14;    // smc14 ready signal14
  output [1:0]             smc_hresp14;     // AHB14 Response14 signal14
  output                   smc_valid14;     // Ack14 to AHB14

//other I14/O14
   
  input                    smc_idle14;      // idle14 state
  input                    smc_done14;      // Asserted14 during 
                                          // last cycle of an access
  input                    mac_done14;      // End14 of all transfers14
  input [31:0]             read_data14;     // Data at internal Bus14
  input               hsel14;          // Chip14 Selects14
   

  output [1:0]             xfer_size14;     // Store14 size for MAC14
  output [31:0]            addr;          // address
  output              cs;          // chip14 selects14 for external14
                                              //  memories
  output [31:0]            write_data14;    // Data to External14 Bus14
  output                   n_read14;        // Active14 low14 read signal14 
  output                   new_access14;    // New14 AHB14 valid access to
                                              //  smc14 detected




// Address Config14







//----------------------------------------------------------------------
// Signal14 declarations14
//----------------------------------------------------------------------

// Output14 register declarations14

// Bus14 Interface14

  reg  [31:0]              smc_hrdata14;  // smc14 read data back to
                                           //  AHB14 master14
  reg                      smc_hready14;  // smc14 ready signal14
  reg  [1:0]               smc_hresp14;   // AHB14 Response14 signal14
  reg                      smc_valid14;   // Ack14 to AHB14

// Internal register declarations14

// Bus14 Interface14

  reg                      new_access14;  // New14 AHB14 valid access
                                           //  to smc14 detected
                                           //  cfg block
  reg  [31:0]              addr;        // Copy14 of address
  reg  [31:0]              write_data14;  // Data to External14 Bus14
  reg  [7:0]               int_cs14;      // Chip14(bank14) Select14 Lines14
  wire                cs;          // Chip14(bank14) Select14 Lines14
  reg  [1:0]               xfer_size14;   // Width14 of current transfer14
  reg                      n_read14;      // Active14 low14 read signal14   
  reg                      r_ready14;     // registered ready signal14   
  reg                      r_hresp14;     // Two14 cycle hresp14 on error
  reg                      mis_err14;     // Misalignment14
  reg                      dis_err14;     // error

// End14 Bus14 Interface14



//----------------------------------------------------------------------
// Beginning14 of main14 code14
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// valid access control14 - AHB14 Interface14 (AHB14 Specific14)
//----------------------------------------------------------------------
// Generates14 the stobes14 required14 to start the smc14 state machine14
// Generates14 all AHB14 responses14.
//----------------------------------------------------------------------

   always @(hsize14)

     begin
     
      xfer_size14 = hsize14[1:0];

     end
   
//----------------------------------------------------------------------
//addr
//----------------------------------------------------------------------

   always @(haddr14)
     
     begin
        
        addr = haddr14;
        
     end
   
//----------------------------------------------------------------------
//chip14 select14 generation14
//----------------------------------------------------------------------

   assign cs = ( hsel14 ) ;
    
//----------------------------------------------------------------------
// detect14 a valid access
//----------------------------------------------------------------------

   always @(cs or hready14 or htrans14 or mis_err14)
     
     begin
             
       if (((htrans14 == `TRN_NONSEQ14) | (htrans14 == `TRN_SEQ14)) &
            (cs != 'd0) & hready14 & ~mis_err14)
          
          begin
             
             smc_valid14 = 1'b1;
             
               
             new_access14 = 1'b1;
             
             
          end
             
       else
          
          begin
             
             smc_valid14 = 1'b0;
             new_access14 = 1'b0;
             
          end
             
     end

//----------------------------------------------------------------------
// Error detection14
//----------------------------------------------------------------------

   always @(haddr14 or hsize14 or htrans14 or cs)
     
     begin
             
        if ((((haddr14[0] != 1'd0) & (hsize14 == `SZ_HALF14))      |
             ((haddr14[1:0] != 2'd0) & (hsize14 == `SZ_WORD14)))    &
            ((htrans14 == `TRN_NONSEQ14) | (htrans14 == `TRN_SEQ14)) &
            (cs != 1'b0) )
          
           mis_err14 = 1'h1;
             
        else
          
           mis_err14 = 1'h0;

     end 
   
//----------------------------------------------------------------------
// Disable14 detection14
//----------------------------------------------------------------------

   always @(htrans14 or cs or smc_idle14 or hready14)
     
     begin
             
           dis_err14 = 1'h0;
             
     end 
   
//----------------------------------------------------------------------
// Response14
//----------------------------------------------------------------------

   always @(posedge hclk14 or negedge n_sys_reset14)
     
     begin
             
        if (~n_sys_reset14)
          
            begin
             
               smc_hresp14 <= `RSP_OKAY14;
               r_hresp14 <= 1'd0;
             
            end
             
        else if (mis_err14 | dis_err14)
          
            begin
             
               r_hresp14 <= 1'd1;
               smc_hresp14 <= `RSP_ERROR14;
             
            end
             
        else if (r_hresp14 == 1'd1)
          
           begin
             
              smc_hresp14 <= `RSP_ERROR14;
              r_hresp14 <= 1'd0;
             
           end
             
        else
          
           begin
             
              smc_hresp14 <= `RSP_OKAY14;
              r_hresp14 <= 1'd0;
             
           end
             
     end
   
//----------------------------------------------------------------------
// assign read access sense
//----------------------------------------------------------------------

   always @(hwrite14)
     
     begin
             
        n_read14 = hwrite14;
             
     end

//----------------------------------------------------------------------
// AHB14 ready signal14
//----------------------------------------------------------------------

   always @(posedge hclk14 or negedge n_sys_reset14)
     
     begin
             
        if (~n_sys_reset14)
          
           r_ready14 <= 1'b1;
             
        else if ((((htrans14 == `TRN_IDLE14) | (htrans14 == `TRN_BUSY14)) & 
                  (cs != 1'b0) & hready14 & ~mis_err14 & 
                  ~dis_err14) | r_hresp14 | (hsel14 == 1'b0) )
          
           r_ready14 <= 1'b1;
             
        else
          
           r_ready14 <= 1'b0;
             
     end
 
//----------------------------------------------------------------------
//smc14 ready
//----------------------------------------------------------------------

   always @(r_ready14 or smc_done14 or mac_done14)
     
     begin
             
        smc_hready14 = r_ready14 | (smc_done14 & mac_done14);
             
     end
   
//----------------------------------------------------------------------
//read data
//----------------------------------------------------------------------
   
   always @(read_data14)
     
      smc_hrdata14 = read_data14;

//----------------------------------------------------------------------
//write data
//----------------------------------------------------------------------

   always @(hwdata14)
     
      write_data14 = hwdata14;
   


endmodule

