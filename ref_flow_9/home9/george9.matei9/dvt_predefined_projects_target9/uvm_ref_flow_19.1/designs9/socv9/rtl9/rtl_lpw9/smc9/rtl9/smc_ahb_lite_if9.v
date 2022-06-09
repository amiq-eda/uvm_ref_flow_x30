//File9 name   : smc_ahb_lite_if9.v
//Title9       : 
//Created9     : 1999
//Description9 : AMBA9 AHB9 Interface9.
//            : Static9 Memory Controller9.
//            : This9 block provides9 the AHB9 interface. 
//            : All AHB9 specific9 signals9 are contained in this
//            : block.
//            : All address decoding9 for the SMC9 module is 
//            : done in
//            : this module and chip9 select9 signals9 generated9
//            : as well9 as an address valid (SMC_valid9) signal9
//            : back to the AHB9 decoder9
//Notes9       : 
//----------------------------------------------------------------------
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------



`include "smc_defs_lite9.v"

//ahb9 interface
  module smc_ahb_lite_if9  (

                      //inputs9

                      hclk9, 
                      n_sys_reset9, 
                      haddr9, 
                      hsel9,
                      htrans9, 
                      hwrite9, 
                      hsize9, 
                      hwdata9,  
                      hready9,  
  
                      //outputs9
  
                      smc_idle9,
                      read_data9, 
                      mac_done9, 
                      smc_done9, 
                      xfer_size9, 
                      n_read9, 
                      new_access9, 
                      addr, 
                      smc_hrdata9, 
                      smc_hready9,
                      smc_hresp9,
                      smc_valid9, 
                      cs, 
                      write_data9 
                      );
  
  
//include files


//----------------------------------------------------------------------


//System9 I9/O9

  input         hclk9;                   // AHB9 System9 clock9
  input         n_sys_reset9;            // AHB9 System9 reset (Active9 LOW9)
 

//AHB9 I9/O9

  input  [31:0]            haddr9;         // AHB9 Address
  input  [1:0]             htrans9;        // AHB9 transfer9 type
  input                    hwrite9;        // AHB9 read/write indication9
  input  [2:0]             hsize9;         // AHB9 transfer9 size
  input  [31:0]            hwdata9;        // AHB9 write data
  input                    hready9;        // AHB9 Muxed9 ready signal9
  output [31:0]            smc_hrdata9;    // smc9 read data back to AHB9
                                             //  master9
  output                   smc_hready9;    // smc9 ready signal9
  output [1:0]             smc_hresp9;     // AHB9 Response9 signal9
  output                   smc_valid9;     // Ack9 to AHB9

//other I9/O9
   
  input                    smc_idle9;      // idle9 state
  input                    smc_done9;      // Asserted9 during 
                                          // last cycle of an access
  input                    mac_done9;      // End9 of all transfers9
  input [31:0]             read_data9;     // Data at internal Bus9
  input               hsel9;          // Chip9 Selects9
   

  output [1:0]             xfer_size9;     // Store9 size for MAC9
  output [31:0]            addr;          // address
  output              cs;          // chip9 selects9 for external9
                                              //  memories
  output [31:0]            write_data9;    // Data to External9 Bus9
  output                   n_read9;        // Active9 low9 read signal9 
  output                   new_access9;    // New9 AHB9 valid access to
                                              //  smc9 detected




// Address Config9







//----------------------------------------------------------------------
// Signal9 declarations9
//----------------------------------------------------------------------

// Output9 register declarations9

// Bus9 Interface9

  reg  [31:0]              smc_hrdata9;  // smc9 read data back to
                                           //  AHB9 master9
  reg                      smc_hready9;  // smc9 ready signal9
  reg  [1:0]               smc_hresp9;   // AHB9 Response9 signal9
  reg                      smc_valid9;   // Ack9 to AHB9

// Internal register declarations9

// Bus9 Interface9

  reg                      new_access9;  // New9 AHB9 valid access
                                           //  to smc9 detected
                                           //  cfg block
  reg  [31:0]              addr;        // Copy9 of address
  reg  [31:0]              write_data9;  // Data to External9 Bus9
  reg  [7:0]               int_cs9;      // Chip9(bank9) Select9 Lines9
  wire                cs;          // Chip9(bank9) Select9 Lines9
  reg  [1:0]               xfer_size9;   // Width9 of current transfer9
  reg                      n_read9;      // Active9 low9 read signal9   
  reg                      r_ready9;     // registered ready signal9   
  reg                      r_hresp9;     // Two9 cycle hresp9 on error
  reg                      mis_err9;     // Misalignment9
  reg                      dis_err9;     // error

// End9 Bus9 Interface9



//----------------------------------------------------------------------
// Beginning9 of main9 code9
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// valid access control9 - AHB9 Interface9 (AHB9 Specific9)
//----------------------------------------------------------------------
// Generates9 the stobes9 required9 to start the smc9 state machine9
// Generates9 all AHB9 responses9.
//----------------------------------------------------------------------

   always @(hsize9)

     begin
     
      xfer_size9 = hsize9[1:0];

     end
   
//----------------------------------------------------------------------
//addr
//----------------------------------------------------------------------

   always @(haddr9)
     
     begin
        
        addr = haddr9;
        
     end
   
//----------------------------------------------------------------------
//chip9 select9 generation9
//----------------------------------------------------------------------

   assign cs = ( hsel9 ) ;
    
//----------------------------------------------------------------------
// detect9 a valid access
//----------------------------------------------------------------------

   always @(cs or hready9 or htrans9 or mis_err9)
     
     begin
             
       if (((htrans9 == `TRN_NONSEQ9) | (htrans9 == `TRN_SEQ9)) &
            (cs != 'd0) & hready9 & ~mis_err9)
          
          begin
             
             smc_valid9 = 1'b1;
             
               
             new_access9 = 1'b1;
             
             
          end
             
       else
          
          begin
             
             smc_valid9 = 1'b0;
             new_access9 = 1'b0;
             
          end
             
     end

//----------------------------------------------------------------------
// Error detection9
//----------------------------------------------------------------------

   always @(haddr9 or hsize9 or htrans9 or cs)
     
     begin
             
        if ((((haddr9[0] != 1'd0) & (hsize9 == `SZ_HALF9))      |
             ((haddr9[1:0] != 2'd0) & (hsize9 == `SZ_WORD9)))    &
            ((htrans9 == `TRN_NONSEQ9) | (htrans9 == `TRN_SEQ9)) &
            (cs != 1'b0) )
          
           mis_err9 = 1'h1;
             
        else
          
           mis_err9 = 1'h0;

     end 
   
//----------------------------------------------------------------------
// Disable9 detection9
//----------------------------------------------------------------------

   always @(htrans9 or cs or smc_idle9 or hready9)
     
     begin
             
           dis_err9 = 1'h0;
             
     end 
   
//----------------------------------------------------------------------
// Response9
//----------------------------------------------------------------------

   always @(posedge hclk9 or negedge n_sys_reset9)
     
     begin
             
        if (~n_sys_reset9)
          
            begin
             
               smc_hresp9 <= `RSP_OKAY9;
               r_hresp9 <= 1'd0;
             
            end
             
        else if (mis_err9 | dis_err9)
          
            begin
             
               r_hresp9 <= 1'd1;
               smc_hresp9 <= `RSP_ERROR9;
             
            end
             
        else if (r_hresp9 == 1'd1)
          
           begin
             
              smc_hresp9 <= `RSP_ERROR9;
              r_hresp9 <= 1'd0;
             
           end
             
        else
          
           begin
             
              smc_hresp9 <= `RSP_OKAY9;
              r_hresp9 <= 1'd0;
             
           end
             
     end
   
//----------------------------------------------------------------------
// assign read access sense
//----------------------------------------------------------------------

   always @(hwrite9)
     
     begin
             
        n_read9 = hwrite9;
             
     end

//----------------------------------------------------------------------
// AHB9 ready signal9
//----------------------------------------------------------------------

   always @(posedge hclk9 or negedge n_sys_reset9)
     
     begin
             
        if (~n_sys_reset9)
          
           r_ready9 <= 1'b1;
             
        else if ((((htrans9 == `TRN_IDLE9) | (htrans9 == `TRN_BUSY9)) & 
                  (cs != 1'b0) & hready9 & ~mis_err9 & 
                  ~dis_err9) | r_hresp9 | (hsel9 == 1'b0) )
          
           r_ready9 <= 1'b1;
             
        else
          
           r_ready9 <= 1'b0;
             
     end
 
//----------------------------------------------------------------------
//smc9 ready
//----------------------------------------------------------------------

   always @(r_ready9 or smc_done9 or mac_done9)
     
     begin
             
        smc_hready9 = r_ready9 | (smc_done9 & mac_done9);
             
     end
   
//----------------------------------------------------------------------
//read data
//----------------------------------------------------------------------
   
   always @(read_data9)
     
      smc_hrdata9 = read_data9;

//----------------------------------------------------------------------
//write data
//----------------------------------------------------------------------

   always @(hwdata9)
     
      write_data9 = hwdata9;
   


endmodule

