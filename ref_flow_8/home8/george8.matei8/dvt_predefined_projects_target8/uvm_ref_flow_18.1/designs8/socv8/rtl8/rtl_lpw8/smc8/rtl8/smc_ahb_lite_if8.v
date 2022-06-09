//File8 name   : smc_ahb_lite_if8.v
//Title8       : 
//Created8     : 1999
//Description8 : AMBA8 AHB8 Interface8.
//            : Static8 Memory Controller8.
//            : This8 block provides8 the AHB8 interface. 
//            : All AHB8 specific8 signals8 are contained in this
//            : block.
//            : All address decoding8 for the SMC8 module is 
//            : done in
//            : this module and chip8 select8 signals8 generated8
//            : as well8 as an address valid (SMC_valid8) signal8
//            : back to the AHB8 decoder8
//Notes8       : 
//----------------------------------------------------------------------
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------



`include "smc_defs_lite8.v"

//ahb8 interface
  module smc_ahb_lite_if8  (

                      //inputs8

                      hclk8, 
                      n_sys_reset8, 
                      haddr8, 
                      hsel8,
                      htrans8, 
                      hwrite8, 
                      hsize8, 
                      hwdata8,  
                      hready8,  
  
                      //outputs8
  
                      smc_idle8,
                      read_data8, 
                      mac_done8, 
                      smc_done8, 
                      xfer_size8, 
                      n_read8, 
                      new_access8, 
                      addr, 
                      smc_hrdata8, 
                      smc_hready8,
                      smc_hresp8,
                      smc_valid8, 
                      cs, 
                      write_data8 
                      );
  
  
//include files


//----------------------------------------------------------------------


//System8 I8/O8

  input         hclk8;                   // AHB8 System8 clock8
  input         n_sys_reset8;            // AHB8 System8 reset (Active8 LOW8)
 

//AHB8 I8/O8

  input  [31:0]            haddr8;         // AHB8 Address
  input  [1:0]             htrans8;        // AHB8 transfer8 type
  input                    hwrite8;        // AHB8 read/write indication8
  input  [2:0]             hsize8;         // AHB8 transfer8 size
  input  [31:0]            hwdata8;        // AHB8 write data
  input                    hready8;        // AHB8 Muxed8 ready signal8
  output [31:0]            smc_hrdata8;    // smc8 read data back to AHB8
                                             //  master8
  output                   smc_hready8;    // smc8 ready signal8
  output [1:0]             smc_hresp8;     // AHB8 Response8 signal8
  output                   smc_valid8;     // Ack8 to AHB8

//other I8/O8
   
  input                    smc_idle8;      // idle8 state
  input                    smc_done8;      // Asserted8 during 
                                          // last cycle of an access
  input                    mac_done8;      // End8 of all transfers8
  input [31:0]             read_data8;     // Data at internal Bus8
  input               hsel8;          // Chip8 Selects8
   

  output [1:0]             xfer_size8;     // Store8 size for MAC8
  output [31:0]            addr;          // address
  output              cs;          // chip8 selects8 for external8
                                              //  memories
  output [31:0]            write_data8;    // Data to External8 Bus8
  output                   n_read8;        // Active8 low8 read signal8 
  output                   new_access8;    // New8 AHB8 valid access to
                                              //  smc8 detected




// Address Config8







//----------------------------------------------------------------------
// Signal8 declarations8
//----------------------------------------------------------------------

// Output8 register declarations8

// Bus8 Interface8

  reg  [31:0]              smc_hrdata8;  // smc8 read data back to
                                           //  AHB8 master8
  reg                      smc_hready8;  // smc8 ready signal8
  reg  [1:0]               smc_hresp8;   // AHB8 Response8 signal8
  reg                      smc_valid8;   // Ack8 to AHB8

// Internal register declarations8

// Bus8 Interface8

  reg                      new_access8;  // New8 AHB8 valid access
                                           //  to smc8 detected
                                           //  cfg block
  reg  [31:0]              addr;        // Copy8 of address
  reg  [31:0]              write_data8;  // Data to External8 Bus8
  reg  [7:0]               int_cs8;      // Chip8(bank8) Select8 Lines8
  wire                cs;          // Chip8(bank8) Select8 Lines8
  reg  [1:0]               xfer_size8;   // Width8 of current transfer8
  reg                      n_read8;      // Active8 low8 read signal8   
  reg                      r_ready8;     // registered ready signal8   
  reg                      r_hresp8;     // Two8 cycle hresp8 on error
  reg                      mis_err8;     // Misalignment8
  reg                      dis_err8;     // error

// End8 Bus8 Interface8



//----------------------------------------------------------------------
// Beginning8 of main8 code8
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// valid access control8 - AHB8 Interface8 (AHB8 Specific8)
//----------------------------------------------------------------------
// Generates8 the stobes8 required8 to start the smc8 state machine8
// Generates8 all AHB8 responses8.
//----------------------------------------------------------------------

   always @(hsize8)

     begin
     
      xfer_size8 = hsize8[1:0];

     end
   
//----------------------------------------------------------------------
//addr
//----------------------------------------------------------------------

   always @(haddr8)
     
     begin
        
        addr = haddr8;
        
     end
   
//----------------------------------------------------------------------
//chip8 select8 generation8
//----------------------------------------------------------------------

   assign cs = ( hsel8 ) ;
    
//----------------------------------------------------------------------
// detect8 a valid access
//----------------------------------------------------------------------

   always @(cs or hready8 or htrans8 or mis_err8)
     
     begin
             
       if (((htrans8 == `TRN_NONSEQ8) | (htrans8 == `TRN_SEQ8)) &
            (cs != 'd0) & hready8 & ~mis_err8)
          
          begin
             
             smc_valid8 = 1'b1;
             
               
             new_access8 = 1'b1;
             
             
          end
             
       else
          
          begin
             
             smc_valid8 = 1'b0;
             new_access8 = 1'b0;
             
          end
             
     end

//----------------------------------------------------------------------
// Error detection8
//----------------------------------------------------------------------

   always @(haddr8 or hsize8 or htrans8 or cs)
     
     begin
             
        if ((((haddr8[0] != 1'd0) & (hsize8 == `SZ_HALF8))      |
             ((haddr8[1:0] != 2'd0) & (hsize8 == `SZ_WORD8)))    &
            ((htrans8 == `TRN_NONSEQ8) | (htrans8 == `TRN_SEQ8)) &
            (cs != 1'b0) )
          
           mis_err8 = 1'h1;
             
        else
          
           mis_err8 = 1'h0;

     end 
   
//----------------------------------------------------------------------
// Disable8 detection8
//----------------------------------------------------------------------

   always @(htrans8 or cs or smc_idle8 or hready8)
     
     begin
             
           dis_err8 = 1'h0;
             
     end 
   
//----------------------------------------------------------------------
// Response8
//----------------------------------------------------------------------

   always @(posedge hclk8 or negedge n_sys_reset8)
     
     begin
             
        if (~n_sys_reset8)
          
            begin
             
               smc_hresp8 <= `RSP_OKAY8;
               r_hresp8 <= 1'd0;
             
            end
             
        else if (mis_err8 | dis_err8)
          
            begin
             
               r_hresp8 <= 1'd1;
               smc_hresp8 <= `RSP_ERROR8;
             
            end
             
        else if (r_hresp8 == 1'd1)
          
           begin
             
              smc_hresp8 <= `RSP_ERROR8;
              r_hresp8 <= 1'd0;
             
           end
             
        else
          
           begin
             
              smc_hresp8 <= `RSP_OKAY8;
              r_hresp8 <= 1'd0;
             
           end
             
     end
   
//----------------------------------------------------------------------
// assign read access sense
//----------------------------------------------------------------------

   always @(hwrite8)
     
     begin
             
        n_read8 = hwrite8;
             
     end

//----------------------------------------------------------------------
// AHB8 ready signal8
//----------------------------------------------------------------------

   always @(posedge hclk8 or negedge n_sys_reset8)
     
     begin
             
        if (~n_sys_reset8)
          
           r_ready8 <= 1'b1;
             
        else if ((((htrans8 == `TRN_IDLE8) | (htrans8 == `TRN_BUSY8)) & 
                  (cs != 1'b0) & hready8 & ~mis_err8 & 
                  ~dis_err8) | r_hresp8 | (hsel8 == 1'b0) )
          
           r_ready8 <= 1'b1;
             
        else
          
           r_ready8 <= 1'b0;
             
     end
 
//----------------------------------------------------------------------
//smc8 ready
//----------------------------------------------------------------------

   always @(r_ready8 or smc_done8 or mac_done8)
     
     begin
             
        smc_hready8 = r_ready8 | (smc_done8 & mac_done8);
             
     end
   
//----------------------------------------------------------------------
//read data
//----------------------------------------------------------------------
   
   always @(read_data8)
     
      smc_hrdata8 = read_data8;

//----------------------------------------------------------------------
//write data
//----------------------------------------------------------------------

   always @(hwdata8)
     
      write_data8 = hwdata8;
   


endmodule

