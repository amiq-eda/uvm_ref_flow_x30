//File12 name   : smc_ahb_lite_if12.v
//Title12       : 
//Created12     : 1999
//Description12 : AMBA12 AHB12 Interface12.
//            : Static12 Memory Controller12.
//            : This12 block provides12 the AHB12 interface. 
//            : All AHB12 specific12 signals12 are contained in this
//            : block.
//            : All address decoding12 for the SMC12 module is 
//            : done in
//            : this module and chip12 select12 signals12 generated12
//            : as well12 as an address valid (SMC_valid12) signal12
//            : back to the AHB12 decoder12
//Notes12       : 
//----------------------------------------------------------------------
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------



`include "smc_defs_lite12.v"

//ahb12 interface
  module smc_ahb_lite_if12  (

                      //inputs12

                      hclk12, 
                      n_sys_reset12, 
                      haddr12, 
                      hsel12,
                      htrans12, 
                      hwrite12, 
                      hsize12, 
                      hwdata12,  
                      hready12,  
  
                      //outputs12
  
                      smc_idle12,
                      read_data12, 
                      mac_done12, 
                      smc_done12, 
                      xfer_size12, 
                      n_read12, 
                      new_access12, 
                      addr, 
                      smc_hrdata12, 
                      smc_hready12,
                      smc_hresp12,
                      smc_valid12, 
                      cs, 
                      write_data12 
                      );
  
  
//include files


//----------------------------------------------------------------------


//System12 I12/O12

  input         hclk12;                   // AHB12 System12 clock12
  input         n_sys_reset12;            // AHB12 System12 reset (Active12 LOW12)
 

//AHB12 I12/O12

  input  [31:0]            haddr12;         // AHB12 Address
  input  [1:0]             htrans12;        // AHB12 transfer12 type
  input                    hwrite12;        // AHB12 read/write indication12
  input  [2:0]             hsize12;         // AHB12 transfer12 size
  input  [31:0]            hwdata12;        // AHB12 write data
  input                    hready12;        // AHB12 Muxed12 ready signal12
  output [31:0]            smc_hrdata12;    // smc12 read data back to AHB12
                                             //  master12
  output                   smc_hready12;    // smc12 ready signal12
  output [1:0]             smc_hresp12;     // AHB12 Response12 signal12
  output                   smc_valid12;     // Ack12 to AHB12

//other I12/O12
   
  input                    smc_idle12;      // idle12 state
  input                    smc_done12;      // Asserted12 during 
                                          // last cycle of an access
  input                    mac_done12;      // End12 of all transfers12
  input [31:0]             read_data12;     // Data at internal Bus12
  input               hsel12;          // Chip12 Selects12
   

  output [1:0]             xfer_size12;     // Store12 size for MAC12
  output [31:0]            addr;          // address
  output              cs;          // chip12 selects12 for external12
                                              //  memories
  output [31:0]            write_data12;    // Data to External12 Bus12
  output                   n_read12;        // Active12 low12 read signal12 
  output                   new_access12;    // New12 AHB12 valid access to
                                              //  smc12 detected




// Address Config12







//----------------------------------------------------------------------
// Signal12 declarations12
//----------------------------------------------------------------------

// Output12 register declarations12

// Bus12 Interface12

  reg  [31:0]              smc_hrdata12;  // smc12 read data back to
                                           //  AHB12 master12
  reg                      smc_hready12;  // smc12 ready signal12
  reg  [1:0]               smc_hresp12;   // AHB12 Response12 signal12
  reg                      smc_valid12;   // Ack12 to AHB12

// Internal register declarations12

// Bus12 Interface12

  reg                      new_access12;  // New12 AHB12 valid access
                                           //  to smc12 detected
                                           //  cfg block
  reg  [31:0]              addr;        // Copy12 of address
  reg  [31:0]              write_data12;  // Data to External12 Bus12
  reg  [7:0]               int_cs12;      // Chip12(bank12) Select12 Lines12
  wire                cs;          // Chip12(bank12) Select12 Lines12
  reg  [1:0]               xfer_size12;   // Width12 of current transfer12
  reg                      n_read12;      // Active12 low12 read signal12   
  reg                      r_ready12;     // registered ready signal12   
  reg                      r_hresp12;     // Two12 cycle hresp12 on error
  reg                      mis_err12;     // Misalignment12
  reg                      dis_err12;     // error

// End12 Bus12 Interface12



//----------------------------------------------------------------------
// Beginning12 of main12 code12
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// valid access control12 - AHB12 Interface12 (AHB12 Specific12)
//----------------------------------------------------------------------
// Generates12 the stobes12 required12 to start the smc12 state machine12
// Generates12 all AHB12 responses12.
//----------------------------------------------------------------------

   always @(hsize12)

     begin
     
      xfer_size12 = hsize12[1:0];

     end
   
//----------------------------------------------------------------------
//addr
//----------------------------------------------------------------------

   always @(haddr12)
     
     begin
        
        addr = haddr12;
        
     end
   
//----------------------------------------------------------------------
//chip12 select12 generation12
//----------------------------------------------------------------------

   assign cs = ( hsel12 ) ;
    
//----------------------------------------------------------------------
// detect12 a valid access
//----------------------------------------------------------------------

   always @(cs or hready12 or htrans12 or mis_err12)
     
     begin
             
       if (((htrans12 == `TRN_NONSEQ12) | (htrans12 == `TRN_SEQ12)) &
            (cs != 'd0) & hready12 & ~mis_err12)
          
          begin
             
             smc_valid12 = 1'b1;
             
               
             new_access12 = 1'b1;
             
             
          end
             
       else
          
          begin
             
             smc_valid12 = 1'b0;
             new_access12 = 1'b0;
             
          end
             
     end

//----------------------------------------------------------------------
// Error detection12
//----------------------------------------------------------------------

   always @(haddr12 or hsize12 or htrans12 or cs)
     
     begin
             
        if ((((haddr12[0] != 1'd0) & (hsize12 == `SZ_HALF12))      |
             ((haddr12[1:0] != 2'd0) & (hsize12 == `SZ_WORD12)))    &
            ((htrans12 == `TRN_NONSEQ12) | (htrans12 == `TRN_SEQ12)) &
            (cs != 1'b0) )
          
           mis_err12 = 1'h1;
             
        else
          
           mis_err12 = 1'h0;

     end 
   
//----------------------------------------------------------------------
// Disable12 detection12
//----------------------------------------------------------------------

   always @(htrans12 or cs or smc_idle12 or hready12)
     
     begin
             
           dis_err12 = 1'h0;
             
     end 
   
//----------------------------------------------------------------------
// Response12
//----------------------------------------------------------------------

   always @(posedge hclk12 or negedge n_sys_reset12)
     
     begin
             
        if (~n_sys_reset12)
          
            begin
             
               smc_hresp12 <= `RSP_OKAY12;
               r_hresp12 <= 1'd0;
             
            end
             
        else if (mis_err12 | dis_err12)
          
            begin
             
               r_hresp12 <= 1'd1;
               smc_hresp12 <= `RSP_ERROR12;
             
            end
             
        else if (r_hresp12 == 1'd1)
          
           begin
             
              smc_hresp12 <= `RSP_ERROR12;
              r_hresp12 <= 1'd0;
             
           end
             
        else
          
           begin
             
              smc_hresp12 <= `RSP_OKAY12;
              r_hresp12 <= 1'd0;
             
           end
             
     end
   
//----------------------------------------------------------------------
// assign read access sense
//----------------------------------------------------------------------

   always @(hwrite12)
     
     begin
             
        n_read12 = hwrite12;
             
     end

//----------------------------------------------------------------------
// AHB12 ready signal12
//----------------------------------------------------------------------

   always @(posedge hclk12 or negedge n_sys_reset12)
     
     begin
             
        if (~n_sys_reset12)
          
           r_ready12 <= 1'b1;
             
        else if ((((htrans12 == `TRN_IDLE12) | (htrans12 == `TRN_BUSY12)) & 
                  (cs != 1'b0) & hready12 & ~mis_err12 & 
                  ~dis_err12) | r_hresp12 | (hsel12 == 1'b0) )
          
           r_ready12 <= 1'b1;
             
        else
          
           r_ready12 <= 1'b0;
             
     end
 
//----------------------------------------------------------------------
//smc12 ready
//----------------------------------------------------------------------

   always @(r_ready12 or smc_done12 or mac_done12)
     
     begin
             
        smc_hready12 = r_ready12 | (smc_done12 & mac_done12);
             
     end
   
//----------------------------------------------------------------------
//read data
//----------------------------------------------------------------------
   
   always @(read_data12)
     
      smc_hrdata12 = read_data12;

//----------------------------------------------------------------------
//write data
//----------------------------------------------------------------------

   always @(hwdata12)
     
      write_data12 = hwdata12;
   


endmodule

