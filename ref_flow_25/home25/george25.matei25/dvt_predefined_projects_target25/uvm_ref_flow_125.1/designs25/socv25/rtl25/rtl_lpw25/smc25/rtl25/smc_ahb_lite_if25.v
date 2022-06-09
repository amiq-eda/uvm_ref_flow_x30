//File25 name   : smc_ahb_lite_if25.v
//Title25       : 
//Created25     : 1999
//Description25 : AMBA25 AHB25 Interface25.
//            : Static25 Memory Controller25.
//            : This25 block provides25 the AHB25 interface. 
//            : All AHB25 specific25 signals25 are contained in this
//            : block.
//            : All address decoding25 for the SMC25 module is 
//            : done in
//            : this module and chip25 select25 signals25 generated25
//            : as well25 as an address valid (SMC_valid25) signal25
//            : back to the AHB25 decoder25
//Notes25       : 
//----------------------------------------------------------------------
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------



`include "smc_defs_lite25.v"

//ahb25 interface
  module smc_ahb_lite_if25  (

                      //inputs25

                      hclk25, 
                      n_sys_reset25, 
                      haddr25, 
                      hsel25,
                      htrans25, 
                      hwrite25, 
                      hsize25, 
                      hwdata25,  
                      hready25,  
  
                      //outputs25
  
                      smc_idle25,
                      read_data25, 
                      mac_done25, 
                      smc_done25, 
                      xfer_size25, 
                      n_read25, 
                      new_access25, 
                      addr, 
                      smc_hrdata25, 
                      smc_hready25,
                      smc_hresp25,
                      smc_valid25, 
                      cs, 
                      write_data25 
                      );
  
  
//include files


//----------------------------------------------------------------------


//System25 I25/O25

  input         hclk25;                   // AHB25 System25 clock25
  input         n_sys_reset25;            // AHB25 System25 reset (Active25 LOW25)
 

//AHB25 I25/O25

  input  [31:0]            haddr25;         // AHB25 Address
  input  [1:0]             htrans25;        // AHB25 transfer25 type
  input                    hwrite25;        // AHB25 read/write indication25
  input  [2:0]             hsize25;         // AHB25 transfer25 size
  input  [31:0]            hwdata25;        // AHB25 write data
  input                    hready25;        // AHB25 Muxed25 ready signal25
  output [31:0]            smc_hrdata25;    // smc25 read data back to AHB25
                                             //  master25
  output                   smc_hready25;    // smc25 ready signal25
  output [1:0]             smc_hresp25;     // AHB25 Response25 signal25
  output                   smc_valid25;     // Ack25 to AHB25

//other I25/O25
   
  input                    smc_idle25;      // idle25 state
  input                    smc_done25;      // Asserted25 during 
                                          // last cycle of an access
  input                    mac_done25;      // End25 of all transfers25
  input [31:0]             read_data25;     // Data at internal Bus25
  input               hsel25;          // Chip25 Selects25
   

  output [1:0]             xfer_size25;     // Store25 size for MAC25
  output [31:0]            addr;          // address
  output              cs;          // chip25 selects25 for external25
                                              //  memories
  output [31:0]            write_data25;    // Data to External25 Bus25
  output                   n_read25;        // Active25 low25 read signal25 
  output                   new_access25;    // New25 AHB25 valid access to
                                              //  smc25 detected




// Address Config25







//----------------------------------------------------------------------
// Signal25 declarations25
//----------------------------------------------------------------------

// Output25 register declarations25

// Bus25 Interface25

  reg  [31:0]              smc_hrdata25;  // smc25 read data back to
                                           //  AHB25 master25
  reg                      smc_hready25;  // smc25 ready signal25
  reg  [1:0]               smc_hresp25;   // AHB25 Response25 signal25
  reg                      smc_valid25;   // Ack25 to AHB25

// Internal register declarations25

// Bus25 Interface25

  reg                      new_access25;  // New25 AHB25 valid access
                                           //  to smc25 detected
                                           //  cfg block
  reg  [31:0]              addr;        // Copy25 of address
  reg  [31:0]              write_data25;  // Data to External25 Bus25
  reg  [7:0]               int_cs25;      // Chip25(bank25) Select25 Lines25
  wire                cs;          // Chip25(bank25) Select25 Lines25
  reg  [1:0]               xfer_size25;   // Width25 of current transfer25
  reg                      n_read25;      // Active25 low25 read signal25   
  reg                      r_ready25;     // registered ready signal25   
  reg                      r_hresp25;     // Two25 cycle hresp25 on error
  reg                      mis_err25;     // Misalignment25
  reg                      dis_err25;     // error

// End25 Bus25 Interface25



//----------------------------------------------------------------------
// Beginning25 of main25 code25
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// valid access control25 - AHB25 Interface25 (AHB25 Specific25)
//----------------------------------------------------------------------
// Generates25 the stobes25 required25 to start the smc25 state machine25
// Generates25 all AHB25 responses25.
//----------------------------------------------------------------------

   always @(hsize25)

     begin
     
      xfer_size25 = hsize25[1:0];

     end
   
//----------------------------------------------------------------------
//addr
//----------------------------------------------------------------------

   always @(haddr25)
     
     begin
        
        addr = haddr25;
        
     end
   
//----------------------------------------------------------------------
//chip25 select25 generation25
//----------------------------------------------------------------------

   assign cs = ( hsel25 ) ;
    
//----------------------------------------------------------------------
// detect25 a valid access
//----------------------------------------------------------------------

   always @(cs or hready25 or htrans25 or mis_err25)
     
     begin
             
       if (((htrans25 == `TRN_NONSEQ25) | (htrans25 == `TRN_SEQ25)) &
            (cs != 'd0) & hready25 & ~mis_err25)
          
          begin
             
             smc_valid25 = 1'b1;
             
               
             new_access25 = 1'b1;
             
             
          end
             
       else
          
          begin
             
             smc_valid25 = 1'b0;
             new_access25 = 1'b0;
             
          end
             
     end

//----------------------------------------------------------------------
// Error detection25
//----------------------------------------------------------------------

   always @(haddr25 or hsize25 or htrans25 or cs)
     
     begin
             
        if ((((haddr25[0] != 1'd0) & (hsize25 == `SZ_HALF25))      |
             ((haddr25[1:0] != 2'd0) & (hsize25 == `SZ_WORD25)))    &
            ((htrans25 == `TRN_NONSEQ25) | (htrans25 == `TRN_SEQ25)) &
            (cs != 1'b0) )
          
           mis_err25 = 1'h1;
             
        else
          
           mis_err25 = 1'h0;

     end 
   
//----------------------------------------------------------------------
// Disable25 detection25
//----------------------------------------------------------------------

   always @(htrans25 or cs or smc_idle25 or hready25)
     
     begin
             
           dis_err25 = 1'h0;
             
     end 
   
//----------------------------------------------------------------------
// Response25
//----------------------------------------------------------------------

   always @(posedge hclk25 or negedge n_sys_reset25)
     
     begin
             
        if (~n_sys_reset25)
          
            begin
             
               smc_hresp25 <= `RSP_OKAY25;
               r_hresp25 <= 1'd0;
             
            end
             
        else if (mis_err25 | dis_err25)
          
            begin
             
               r_hresp25 <= 1'd1;
               smc_hresp25 <= `RSP_ERROR25;
             
            end
             
        else if (r_hresp25 == 1'd1)
          
           begin
             
              smc_hresp25 <= `RSP_ERROR25;
              r_hresp25 <= 1'd0;
             
           end
             
        else
          
           begin
             
              smc_hresp25 <= `RSP_OKAY25;
              r_hresp25 <= 1'd0;
             
           end
             
     end
   
//----------------------------------------------------------------------
// assign read access sense
//----------------------------------------------------------------------

   always @(hwrite25)
     
     begin
             
        n_read25 = hwrite25;
             
     end

//----------------------------------------------------------------------
// AHB25 ready signal25
//----------------------------------------------------------------------

   always @(posedge hclk25 or negedge n_sys_reset25)
     
     begin
             
        if (~n_sys_reset25)
          
           r_ready25 <= 1'b1;
             
        else if ((((htrans25 == `TRN_IDLE25) | (htrans25 == `TRN_BUSY25)) & 
                  (cs != 1'b0) & hready25 & ~mis_err25 & 
                  ~dis_err25) | r_hresp25 | (hsel25 == 1'b0) )
          
           r_ready25 <= 1'b1;
             
        else
          
           r_ready25 <= 1'b0;
             
     end
 
//----------------------------------------------------------------------
//smc25 ready
//----------------------------------------------------------------------

   always @(r_ready25 or smc_done25 or mac_done25)
     
     begin
             
        smc_hready25 = r_ready25 | (smc_done25 & mac_done25);
             
     end
   
//----------------------------------------------------------------------
//read data
//----------------------------------------------------------------------
   
   always @(read_data25)
     
      smc_hrdata25 = read_data25;

//----------------------------------------------------------------------
//write data
//----------------------------------------------------------------------

   always @(hwdata25)
     
      write_data25 = hwdata25;
   


endmodule

