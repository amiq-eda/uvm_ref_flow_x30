//File15 name   : smc_ahb_lite_if15.v
//Title15       : 
//Created15     : 1999
//Description15 : AMBA15 AHB15 Interface15.
//            : Static15 Memory Controller15.
//            : This15 block provides15 the AHB15 interface. 
//            : All AHB15 specific15 signals15 are contained in this
//            : block.
//            : All address decoding15 for the SMC15 module is 
//            : done in
//            : this module and chip15 select15 signals15 generated15
//            : as well15 as an address valid (SMC_valid15) signal15
//            : back to the AHB15 decoder15
//Notes15       : 
//----------------------------------------------------------------------
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------



`include "smc_defs_lite15.v"

//ahb15 interface
  module smc_ahb_lite_if15  (

                      //inputs15

                      hclk15, 
                      n_sys_reset15, 
                      haddr15, 
                      hsel15,
                      htrans15, 
                      hwrite15, 
                      hsize15, 
                      hwdata15,  
                      hready15,  
  
                      //outputs15
  
                      smc_idle15,
                      read_data15, 
                      mac_done15, 
                      smc_done15, 
                      xfer_size15, 
                      n_read15, 
                      new_access15, 
                      addr, 
                      smc_hrdata15, 
                      smc_hready15,
                      smc_hresp15,
                      smc_valid15, 
                      cs, 
                      write_data15 
                      );
  
  
//include files


//----------------------------------------------------------------------


//System15 I15/O15

  input         hclk15;                   // AHB15 System15 clock15
  input         n_sys_reset15;            // AHB15 System15 reset (Active15 LOW15)
 

//AHB15 I15/O15

  input  [31:0]            haddr15;         // AHB15 Address
  input  [1:0]             htrans15;        // AHB15 transfer15 type
  input                    hwrite15;        // AHB15 read/write indication15
  input  [2:0]             hsize15;         // AHB15 transfer15 size
  input  [31:0]            hwdata15;        // AHB15 write data
  input                    hready15;        // AHB15 Muxed15 ready signal15
  output [31:0]            smc_hrdata15;    // smc15 read data back to AHB15
                                             //  master15
  output                   smc_hready15;    // smc15 ready signal15
  output [1:0]             smc_hresp15;     // AHB15 Response15 signal15
  output                   smc_valid15;     // Ack15 to AHB15

//other I15/O15
   
  input                    smc_idle15;      // idle15 state
  input                    smc_done15;      // Asserted15 during 
                                          // last cycle of an access
  input                    mac_done15;      // End15 of all transfers15
  input [31:0]             read_data15;     // Data at internal Bus15
  input               hsel15;          // Chip15 Selects15
   

  output [1:0]             xfer_size15;     // Store15 size for MAC15
  output [31:0]            addr;          // address
  output              cs;          // chip15 selects15 for external15
                                              //  memories
  output [31:0]            write_data15;    // Data to External15 Bus15
  output                   n_read15;        // Active15 low15 read signal15 
  output                   new_access15;    // New15 AHB15 valid access to
                                              //  smc15 detected




// Address Config15







//----------------------------------------------------------------------
// Signal15 declarations15
//----------------------------------------------------------------------

// Output15 register declarations15

// Bus15 Interface15

  reg  [31:0]              smc_hrdata15;  // smc15 read data back to
                                           //  AHB15 master15
  reg                      smc_hready15;  // smc15 ready signal15
  reg  [1:0]               smc_hresp15;   // AHB15 Response15 signal15
  reg                      smc_valid15;   // Ack15 to AHB15

// Internal register declarations15

// Bus15 Interface15

  reg                      new_access15;  // New15 AHB15 valid access
                                           //  to smc15 detected
                                           //  cfg block
  reg  [31:0]              addr;        // Copy15 of address
  reg  [31:0]              write_data15;  // Data to External15 Bus15
  reg  [7:0]               int_cs15;      // Chip15(bank15) Select15 Lines15
  wire                cs;          // Chip15(bank15) Select15 Lines15
  reg  [1:0]               xfer_size15;   // Width15 of current transfer15
  reg                      n_read15;      // Active15 low15 read signal15   
  reg                      r_ready15;     // registered ready signal15   
  reg                      r_hresp15;     // Two15 cycle hresp15 on error
  reg                      mis_err15;     // Misalignment15
  reg                      dis_err15;     // error

// End15 Bus15 Interface15



//----------------------------------------------------------------------
// Beginning15 of main15 code15
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// valid access control15 - AHB15 Interface15 (AHB15 Specific15)
//----------------------------------------------------------------------
// Generates15 the stobes15 required15 to start the smc15 state machine15
// Generates15 all AHB15 responses15.
//----------------------------------------------------------------------

   always @(hsize15)

     begin
     
      xfer_size15 = hsize15[1:0];

     end
   
//----------------------------------------------------------------------
//addr
//----------------------------------------------------------------------

   always @(haddr15)
     
     begin
        
        addr = haddr15;
        
     end
   
//----------------------------------------------------------------------
//chip15 select15 generation15
//----------------------------------------------------------------------

   assign cs = ( hsel15 ) ;
    
//----------------------------------------------------------------------
// detect15 a valid access
//----------------------------------------------------------------------

   always @(cs or hready15 or htrans15 or mis_err15)
     
     begin
             
       if (((htrans15 == `TRN_NONSEQ15) | (htrans15 == `TRN_SEQ15)) &
            (cs != 'd0) & hready15 & ~mis_err15)
          
          begin
             
             smc_valid15 = 1'b1;
             
               
             new_access15 = 1'b1;
             
             
          end
             
       else
          
          begin
             
             smc_valid15 = 1'b0;
             new_access15 = 1'b0;
             
          end
             
     end

//----------------------------------------------------------------------
// Error detection15
//----------------------------------------------------------------------

   always @(haddr15 or hsize15 or htrans15 or cs)
     
     begin
             
        if ((((haddr15[0] != 1'd0) & (hsize15 == `SZ_HALF15))      |
             ((haddr15[1:0] != 2'd0) & (hsize15 == `SZ_WORD15)))    &
            ((htrans15 == `TRN_NONSEQ15) | (htrans15 == `TRN_SEQ15)) &
            (cs != 1'b0) )
          
           mis_err15 = 1'h1;
             
        else
          
           mis_err15 = 1'h0;

     end 
   
//----------------------------------------------------------------------
// Disable15 detection15
//----------------------------------------------------------------------

   always @(htrans15 or cs or smc_idle15 or hready15)
     
     begin
             
           dis_err15 = 1'h0;
             
     end 
   
//----------------------------------------------------------------------
// Response15
//----------------------------------------------------------------------

   always @(posedge hclk15 or negedge n_sys_reset15)
     
     begin
             
        if (~n_sys_reset15)
          
            begin
             
               smc_hresp15 <= `RSP_OKAY15;
               r_hresp15 <= 1'd0;
             
            end
             
        else if (mis_err15 | dis_err15)
          
            begin
             
               r_hresp15 <= 1'd1;
               smc_hresp15 <= `RSP_ERROR15;
             
            end
             
        else if (r_hresp15 == 1'd1)
          
           begin
             
              smc_hresp15 <= `RSP_ERROR15;
              r_hresp15 <= 1'd0;
             
           end
             
        else
          
           begin
             
              smc_hresp15 <= `RSP_OKAY15;
              r_hresp15 <= 1'd0;
             
           end
             
     end
   
//----------------------------------------------------------------------
// assign read access sense
//----------------------------------------------------------------------

   always @(hwrite15)
     
     begin
             
        n_read15 = hwrite15;
             
     end

//----------------------------------------------------------------------
// AHB15 ready signal15
//----------------------------------------------------------------------

   always @(posedge hclk15 or negedge n_sys_reset15)
     
     begin
             
        if (~n_sys_reset15)
          
           r_ready15 <= 1'b1;
             
        else if ((((htrans15 == `TRN_IDLE15) | (htrans15 == `TRN_BUSY15)) & 
                  (cs != 1'b0) & hready15 & ~mis_err15 & 
                  ~dis_err15) | r_hresp15 | (hsel15 == 1'b0) )
          
           r_ready15 <= 1'b1;
             
        else
          
           r_ready15 <= 1'b0;
             
     end
 
//----------------------------------------------------------------------
//smc15 ready
//----------------------------------------------------------------------

   always @(r_ready15 or smc_done15 or mac_done15)
     
     begin
             
        smc_hready15 = r_ready15 | (smc_done15 & mac_done15);
             
     end
   
//----------------------------------------------------------------------
//read data
//----------------------------------------------------------------------
   
   always @(read_data15)
     
      smc_hrdata15 = read_data15;

//----------------------------------------------------------------------
//write data
//----------------------------------------------------------------------

   always @(hwdata15)
     
      write_data15 = hwdata15;
   


endmodule

