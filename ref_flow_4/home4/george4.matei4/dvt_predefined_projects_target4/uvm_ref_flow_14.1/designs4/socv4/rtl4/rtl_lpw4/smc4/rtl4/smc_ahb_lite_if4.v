//File4 name   : smc_ahb_lite_if4.v
//Title4       : 
//Created4     : 1999
//Description4 : AMBA4 AHB4 Interface4.
//            : Static4 Memory Controller4.
//            : This4 block provides4 the AHB4 interface. 
//            : All AHB4 specific4 signals4 are contained in this
//            : block.
//            : All address decoding4 for the SMC4 module is 
//            : done in
//            : this module and chip4 select4 signals4 generated4
//            : as well4 as an address valid (SMC_valid4) signal4
//            : back to the AHB4 decoder4
//Notes4       : 
//----------------------------------------------------------------------
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------



`include "smc_defs_lite4.v"

//ahb4 interface
  module smc_ahb_lite_if4  (

                      //inputs4

                      hclk4, 
                      n_sys_reset4, 
                      haddr4, 
                      hsel4,
                      htrans4, 
                      hwrite4, 
                      hsize4, 
                      hwdata4,  
                      hready4,  
  
                      //outputs4
  
                      smc_idle4,
                      read_data4, 
                      mac_done4, 
                      smc_done4, 
                      xfer_size4, 
                      n_read4, 
                      new_access4, 
                      addr, 
                      smc_hrdata4, 
                      smc_hready4,
                      smc_hresp4,
                      smc_valid4, 
                      cs, 
                      write_data4 
                      );
  
  
//include files


//----------------------------------------------------------------------


//System4 I4/O4

  input         hclk4;                   // AHB4 System4 clock4
  input         n_sys_reset4;            // AHB4 System4 reset (Active4 LOW4)
 

//AHB4 I4/O4

  input  [31:0]            haddr4;         // AHB4 Address
  input  [1:0]             htrans4;        // AHB4 transfer4 type
  input                    hwrite4;        // AHB4 read/write indication4
  input  [2:0]             hsize4;         // AHB4 transfer4 size
  input  [31:0]            hwdata4;        // AHB4 write data
  input                    hready4;        // AHB4 Muxed4 ready signal4
  output [31:0]            smc_hrdata4;    // smc4 read data back to AHB4
                                             //  master4
  output                   smc_hready4;    // smc4 ready signal4
  output [1:0]             smc_hresp4;     // AHB4 Response4 signal4
  output                   smc_valid4;     // Ack4 to AHB4

//other I4/O4
   
  input                    smc_idle4;      // idle4 state
  input                    smc_done4;      // Asserted4 during 
                                          // last cycle of an access
  input                    mac_done4;      // End4 of all transfers4
  input [31:0]             read_data4;     // Data at internal Bus4
  input               hsel4;          // Chip4 Selects4
   

  output [1:0]             xfer_size4;     // Store4 size for MAC4
  output [31:0]            addr;          // address
  output              cs;          // chip4 selects4 for external4
                                              //  memories
  output [31:0]            write_data4;    // Data to External4 Bus4
  output                   n_read4;        // Active4 low4 read signal4 
  output                   new_access4;    // New4 AHB4 valid access to
                                              //  smc4 detected




// Address Config4







//----------------------------------------------------------------------
// Signal4 declarations4
//----------------------------------------------------------------------

// Output4 register declarations4

// Bus4 Interface4

  reg  [31:0]              smc_hrdata4;  // smc4 read data back to
                                           //  AHB4 master4
  reg                      smc_hready4;  // smc4 ready signal4
  reg  [1:0]               smc_hresp4;   // AHB4 Response4 signal4
  reg                      smc_valid4;   // Ack4 to AHB4

// Internal register declarations4

// Bus4 Interface4

  reg                      new_access4;  // New4 AHB4 valid access
                                           //  to smc4 detected
                                           //  cfg block
  reg  [31:0]              addr;        // Copy4 of address
  reg  [31:0]              write_data4;  // Data to External4 Bus4
  reg  [7:0]               int_cs4;      // Chip4(bank4) Select4 Lines4
  wire                cs;          // Chip4(bank4) Select4 Lines4
  reg  [1:0]               xfer_size4;   // Width4 of current transfer4
  reg                      n_read4;      // Active4 low4 read signal4   
  reg                      r_ready4;     // registered ready signal4   
  reg                      r_hresp4;     // Two4 cycle hresp4 on error
  reg                      mis_err4;     // Misalignment4
  reg                      dis_err4;     // error

// End4 Bus4 Interface4



//----------------------------------------------------------------------
// Beginning4 of main4 code4
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// valid access control4 - AHB4 Interface4 (AHB4 Specific4)
//----------------------------------------------------------------------
// Generates4 the stobes4 required4 to start the smc4 state machine4
// Generates4 all AHB4 responses4.
//----------------------------------------------------------------------

   always @(hsize4)

     begin
     
      xfer_size4 = hsize4[1:0];

     end
   
//----------------------------------------------------------------------
//addr
//----------------------------------------------------------------------

   always @(haddr4)
     
     begin
        
        addr = haddr4;
        
     end
   
//----------------------------------------------------------------------
//chip4 select4 generation4
//----------------------------------------------------------------------

   assign cs = ( hsel4 ) ;
    
//----------------------------------------------------------------------
// detect4 a valid access
//----------------------------------------------------------------------

   always @(cs or hready4 or htrans4 or mis_err4)
     
     begin
             
       if (((htrans4 == `TRN_NONSEQ4) | (htrans4 == `TRN_SEQ4)) &
            (cs != 'd0) & hready4 & ~mis_err4)
          
          begin
             
             smc_valid4 = 1'b1;
             
               
             new_access4 = 1'b1;
             
             
          end
             
       else
          
          begin
             
             smc_valid4 = 1'b0;
             new_access4 = 1'b0;
             
          end
             
     end

//----------------------------------------------------------------------
// Error detection4
//----------------------------------------------------------------------

   always @(haddr4 or hsize4 or htrans4 or cs)
     
     begin
             
        if ((((haddr4[0] != 1'd0) & (hsize4 == `SZ_HALF4))      |
             ((haddr4[1:0] != 2'd0) & (hsize4 == `SZ_WORD4)))    &
            ((htrans4 == `TRN_NONSEQ4) | (htrans4 == `TRN_SEQ4)) &
            (cs != 1'b0) )
          
           mis_err4 = 1'h1;
             
        else
          
           mis_err4 = 1'h0;

     end 
   
//----------------------------------------------------------------------
// Disable4 detection4
//----------------------------------------------------------------------

   always @(htrans4 or cs or smc_idle4 or hready4)
     
     begin
             
           dis_err4 = 1'h0;
             
     end 
   
//----------------------------------------------------------------------
// Response4
//----------------------------------------------------------------------

   always @(posedge hclk4 or negedge n_sys_reset4)
     
     begin
             
        if (~n_sys_reset4)
          
            begin
             
               smc_hresp4 <= `RSP_OKAY4;
               r_hresp4 <= 1'd0;
             
            end
             
        else if (mis_err4 | dis_err4)
          
            begin
             
               r_hresp4 <= 1'd1;
               smc_hresp4 <= `RSP_ERROR4;
             
            end
             
        else if (r_hresp4 == 1'd1)
          
           begin
             
              smc_hresp4 <= `RSP_ERROR4;
              r_hresp4 <= 1'd0;
             
           end
             
        else
          
           begin
             
              smc_hresp4 <= `RSP_OKAY4;
              r_hresp4 <= 1'd0;
             
           end
             
     end
   
//----------------------------------------------------------------------
// assign read access sense
//----------------------------------------------------------------------

   always @(hwrite4)
     
     begin
             
        n_read4 = hwrite4;
             
     end

//----------------------------------------------------------------------
// AHB4 ready signal4
//----------------------------------------------------------------------

   always @(posedge hclk4 or negedge n_sys_reset4)
     
     begin
             
        if (~n_sys_reset4)
          
           r_ready4 <= 1'b1;
             
        else if ((((htrans4 == `TRN_IDLE4) | (htrans4 == `TRN_BUSY4)) & 
                  (cs != 1'b0) & hready4 & ~mis_err4 & 
                  ~dis_err4) | r_hresp4 | (hsel4 == 1'b0) )
          
           r_ready4 <= 1'b1;
             
        else
          
           r_ready4 <= 1'b0;
             
     end
 
//----------------------------------------------------------------------
//smc4 ready
//----------------------------------------------------------------------

   always @(r_ready4 or smc_done4 or mac_done4)
     
     begin
             
        smc_hready4 = r_ready4 | (smc_done4 & mac_done4);
             
     end
   
//----------------------------------------------------------------------
//read data
//----------------------------------------------------------------------
   
   always @(read_data4)
     
      smc_hrdata4 = read_data4;

//----------------------------------------------------------------------
//write data
//----------------------------------------------------------------------

   always @(hwdata4)
     
      write_data4 = hwdata4;
   


endmodule

