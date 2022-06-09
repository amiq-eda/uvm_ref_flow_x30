//File24 name   : smc_ahb_lite_if24.v
//Title24       : 
//Created24     : 1999
//Description24 : AMBA24 AHB24 Interface24.
//            : Static24 Memory Controller24.
//            : This24 block provides24 the AHB24 interface. 
//            : All AHB24 specific24 signals24 are contained in this
//            : block.
//            : All address decoding24 for the SMC24 module is 
//            : done in
//            : this module and chip24 select24 signals24 generated24
//            : as well24 as an address valid (SMC_valid24) signal24
//            : back to the AHB24 decoder24
//Notes24       : 
//----------------------------------------------------------------------
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------



`include "smc_defs_lite24.v"

//ahb24 interface
  module smc_ahb_lite_if24  (

                      //inputs24

                      hclk24, 
                      n_sys_reset24, 
                      haddr24, 
                      hsel24,
                      htrans24, 
                      hwrite24, 
                      hsize24, 
                      hwdata24,  
                      hready24,  
  
                      //outputs24
  
                      smc_idle24,
                      read_data24, 
                      mac_done24, 
                      smc_done24, 
                      xfer_size24, 
                      n_read24, 
                      new_access24, 
                      addr, 
                      smc_hrdata24, 
                      smc_hready24,
                      smc_hresp24,
                      smc_valid24, 
                      cs, 
                      write_data24 
                      );
  
  
//include files


//----------------------------------------------------------------------


//System24 I24/O24

  input         hclk24;                   // AHB24 System24 clock24
  input         n_sys_reset24;            // AHB24 System24 reset (Active24 LOW24)
 

//AHB24 I24/O24

  input  [31:0]            haddr24;         // AHB24 Address
  input  [1:0]             htrans24;        // AHB24 transfer24 type
  input                    hwrite24;        // AHB24 read/write indication24
  input  [2:0]             hsize24;         // AHB24 transfer24 size
  input  [31:0]            hwdata24;        // AHB24 write data
  input                    hready24;        // AHB24 Muxed24 ready signal24
  output [31:0]            smc_hrdata24;    // smc24 read data back to AHB24
                                             //  master24
  output                   smc_hready24;    // smc24 ready signal24
  output [1:0]             smc_hresp24;     // AHB24 Response24 signal24
  output                   smc_valid24;     // Ack24 to AHB24

//other I24/O24
   
  input                    smc_idle24;      // idle24 state
  input                    smc_done24;      // Asserted24 during 
                                          // last cycle of an access
  input                    mac_done24;      // End24 of all transfers24
  input [31:0]             read_data24;     // Data at internal Bus24
  input               hsel24;          // Chip24 Selects24
   

  output [1:0]             xfer_size24;     // Store24 size for MAC24
  output [31:0]            addr;          // address
  output              cs;          // chip24 selects24 for external24
                                              //  memories
  output [31:0]            write_data24;    // Data to External24 Bus24
  output                   n_read24;        // Active24 low24 read signal24 
  output                   new_access24;    // New24 AHB24 valid access to
                                              //  smc24 detected




// Address Config24







//----------------------------------------------------------------------
// Signal24 declarations24
//----------------------------------------------------------------------

// Output24 register declarations24

// Bus24 Interface24

  reg  [31:0]              smc_hrdata24;  // smc24 read data back to
                                           //  AHB24 master24
  reg                      smc_hready24;  // smc24 ready signal24
  reg  [1:0]               smc_hresp24;   // AHB24 Response24 signal24
  reg                      smc_valid24;   // Ack24 to AHB24

// Internal register declarations24

// Bus24 Interface24

  reg                      new_access24;  // New24 AHB24 valid access
                                           //  to smc24 detected
                                           //  cfg block
  reg  [31:0]              addr;        // Copy24 of address
  reg  [31:0]              write_data24;  // Data to External24 Bus24
  reg  [7:0]               int_cs24;      // Chip24(bank24) Select24 Lines24
  wire                cs;          // Chip24(bank24) Select24 Lines24
  reg  [1:0]               xfer_size24;   // Width24 of current transfer24
  reg                      n_read24;      // Active24 low24 read signal24   
  reg                      r_ready24;     // registered ready signal24   
  reg                      r_hresp24;     // Two24 cycle hresp24 on error
  reg                      mis_err24;     // Misalignment24
  reg                      dis_err24;     // error

// End24 Bus24 Interface24



//----------------------------------------------------------------------
// Beginning24 of main24 code24
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// valid access control24 - AHB24 Interface24 (AHB24 Specific24)
//----------------------------------------------------------------------
// Generates24 the stobes24 required24 to start the smc24 state machine24
// Generates24 all AHB24 responses24.
//----------------------------------------------------------------------

   always @(hsize24)

     begin
     
      xfer_size24 = hsize24[1:0];

     end
   
//----------------------------------------------------------------------
//addr
//----------------------------------------------------------------------

   always @(haddr24)
     
     begin
        
        addr = haddr24;
        
     end
   
//----------------------------------------------------------------------
//chip24 select24 generation24
//----------------------------------------------------------------------

   assign cs = ( hsel24 ) ;
    
//----------------------------------------------------------------------
// detect24 a valid access
//----------------------------------------------------------------------

   always @(cs or hready24 or htrans24 or mis_err24)
     
     begin
             
       if (((htrans24 == `TRN_NONSEQ24) | (htrans24 == `TRN_SEQ24)) &
            (cs != 'd0) & hready24 & ~mis_err24)
          
          begin
             
             smc_valid24 = 1'b1;
             
               
             new_access24 = 1'b1;
             
             
          end
             
       else
          
          begin
             
             smc_valid24 = 1'b0;
             new_access24 = 1'b0;
             
          end
             
     end

//----------------------------------------------------------------------
// Error detection24
//----------------------------------------------------------------------

   always @(haddr24 or hsize24 or htrans24 or cs)
     
     begin
             
        if ((((haddr24[0] != 1'd0) & (hsize24 == `SZ_HALF24))      |
             ((haddr24[1:0] != 2'd0) & (hsize24 == `SZ_WORD24)))    &
            ((htrans24 == `TRN_NONSEQ24) | (htrans24 == `TRN_SEQ24)) &
            (cs != 1'b0) )
          
           mis_err24 = 1'h1;
             
        else
          
           mis_err24 = 1'h0;

     end 
   
//----------------------------------------------------------------------
// Disable24 detection24
//----------------------------------------------------------------------

   always @(htrans24 or cs or smc_idle24 or hready24)
     
     begin
             
           dis_err24 = 1'h0;
             
     end 
   
//----------------------------------------------------------------------
// Response24
//----------------------------------------------------------------------

   always @(posedge hclk24 or negedge n_sys_reset24)
     
     begin
             
        if (~n_sys_reset24)
          
            begin
             
               smc_hresp24 <= `RSP_OKAY24;
               r_hresp24 <= 1'd0;
             
            end
             
        else if (mis_err24 | dis_err24)
          
            begin
             
               r_hresp24 <= 1'd1;
               smc_hresp24 <= `RSP_ERROR24;
             
            end
             
        else if (r_hresp24 == 1'd1)
          
           begin
             
              smc_hresp24 <= `RSP_ERROR24;
              r_hresp24 <= 1'd0;
             
           end
             
        else
          
           begin
             
              smc_hresp24 <= `RSP_OKAY24;
              r_hresp24 <= 1'd0;
             
           end
             
     end
   
//----------------------------------------------------------------------
// assign read access sense
//----------------------------------------------------------------------

   always @(hwrite24)
     
     begin
             
        n_read24 = hwrite24;
             
     end

//----------------------------------------------------------------------
// AHB24 ready signal24
//----------------------------------------------------------------------

   always @(posedge hclk24 or negedge n_sys_reset24)
     
     begin
             
        if (~n_sys_reset24)
          
           r_ready24 <= 1'b1;
             
        else if ((((htrans24 == `TRN_IDLE24) | (htrans24 == `TRN_BUSY24)) & 
                  (cs != 1'b0) & hready24 & ~mis_err24 & 
                  ~dis_err24) | r_hresp24 | (hsel24 == 1'b0) )
          
           r_ready24 <= 1'b1;
             
        else
          
           r_ready24 <= 1'b0;
             
     end
 
//----------------------------------------------------------------------
//smc24 ready
//----------------------------------------------------------------------

   always @(r_ready24 or smc_done24 or mac_done24)
     
     begin
             
        smc_hready24 = r_ready24 | (smc_done24 & mac_done24);
             
     end
   
//----------------------------------------------------------------------
//read data
//----------------------------------------------------------------------
   
   always @(read_data24)
     
      smc_hrdata24 = read_data24;

//----------------------------------------------------------------------
//write data
//----------------------------------------------------------------------

   always @(hwdata24)
     
      write_data24 = hwdata24;
   


endmodule

