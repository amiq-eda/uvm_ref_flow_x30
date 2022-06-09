//File3 name   : smc_ahb_lite_if3.v
//Title3       : 
//Created3     : 1999
//Description3 : AMBA3 AHB3 Interface3.
//            : Static3 Memory Controller3.
//            : This3 block provides3 the AHB3 interface. 
//            : All AHB3 specific3 signals3 are contained in this
//            : block.
//            : All address decoding3 for the SMC3 module is 
//            : done in
//            : this module and chip3 select3 signals3 generated3
//            : as well3 as an address valid (SMC_valid3) signal3
//            : back to the AHB3 decoder3
//Notes3       : 
//----------------------------------------------------------------------
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------



`include "smc_defs_lite3.v"

//ahb3 interface
  module smc_ahb_lite_if3  (

                      //inputs3

                      hclk3, 
                      n_sys_reset3, 
                      haddr3, 
                      hsel3,
                      htrans3, 
                      hwrite3, 
                      hsize3, 
                      hwdata3,  
                      hready3,  
  
                      //outputs3
  
                      smc_idle3,
                      read_data3, 
                      mac_done3, 
                      smc_done3, 
                      xfer_size3, 
                      n_read3, 
                      new_access3, 
                      addr, 
                      smc_hrdata3, 
                      smc_hready3,
                      smc_hresp3,
                      smc_valid3, 
                      cs, 
                      write_data3 
                      );
  
  
//include files


//----------------------------------------------------------------------


//System3 I3/O3

  input         hclk3;                   // AHB3 System3 clock3
  input         n_sys_reset3;            // AHB3 System3 reset (Active3 LOW3)
 

//AHB3 I3/O3

  input  [31:0]            haddr3;         // AHB3 Address
  input  [1:0]             htrans3;        // AHB3 transfer3 type
  input                    hwrite3;        // AHB3 read/write indication3
  input  [2:0]             hsize3;         // AHB3 transfer3 size
  input  [31:0]            hwdata3;        // AHB3 write data
  input                    hready3;        // AHB3 Muxed3 ready signal3
  output [31:0]            smc_hrdata3;    // smc3 read data back to AHB3
                                             //  master3
  output                   smc_hready3;    // smc3 ready signal3
  output [1:0]             smc_hresp3;     // AHB3 Response3 signal3
  output                   smc_valid3;     // Ack3 to AHB3

//other I3/O3
   
  input                    smc_idle3;      // idle3 state
  input                    smc_done3;      // Asserted3 during 
                                          // last cycle of an access
  input                    mac_done3;      // End3 of all transfers3
  input [31:0]             read_data3;     // Data at internal Bus3
  input               hsel3;          // Chip3 Selects3
   

  output [1:0]             xfer_size3;     // Store3 size for MAC3
  output [31:0]            addr;          // address
  output              cs;          // chip3 selects3 for external3
                                              //  memories
  output [31:0]            write_data3;    // Data to External3 Bus3
  output                   n_read3;        // Active3 low3 read signal3 
  output                   new_access3;    // New3 AHB3 valid access to
                                              //  smc3 detected




// Address Config3







//----------------------------------------------------------------------
// Signal3 declarations3
//----------------------------------------------------------------------

// Output3 register declarations3

// Bus3 Interface3

  reg  [31:0]              smc_hrdata3;  // smc3 read data back to
                                           //  AHB3 master3
  reg                      smc_hready3;  // smc3 ready signal3
  reg  [1:0]               smc_hresp3;   // AHB3 Response3 signal3
  reg                      smc_valid3;   // Ack3 to AHB3

// Internal register declarations3

// Bus3 Interface3

  reg                      new_access3;  // New3 AHB3 valid access
                                           //  to smc3 detected
                                           //  cfg block
  reg  [31:0]              addr;        // Copy3 of address
  reg  [31:0]              write_data3;  // Data to External3 Bus3
  reg  [7:0]               int_cs3;      // Chip3(bank3) Select3 Lines3
  wire                cs;          // Chip3(bank3) Select3 Lines3
  reg  [1:0]               xfer_size3;   // Width3 of current transfer3
  reg                      n_read3;      // Active3 low3 read signal3   
  reg                      r_ready3;     // registered ready signal3   
  reg                      r_hresp3;     // Two3 cycle hresp3 on error
  reg                      mis_err3;     // Misalignment3
  reg                      dis_err3;     // error

// End3 Bus3 Interface3



//----------------------------------------------------------------------
// Beginning3 of main3 code3
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// valid access control3 - AHB3 Interface3 (AHB3 Specific3)
//----------------------------------------------------------------------
// Generates3 the stobes3 required3 to start the smc3 state machine3
// Generates3 all AHB3 responses3.
//----------------------------------------------------------------------

   always @(hsize3)

     begin
     
      xfer_size3 = hsize3[1:0];

     end
   
//----------------------------------------------------------------------
//addr
//----------------------------------------------------------------------

   always @(haddr3)
     
     begin
        
        addr = haddr3;
        
     end
   
//----------------------------------------------------------------------
//chip3 select3 generation3
//----------------------------------------------------------------------

   assign cs = ( hsel3 ) ;
    
//----------------------------------------------------------------------
// detect3 a valid access
//----------------------------------------------------------------------

   always @(cs or hready3 or htrans3 or mis_err3)
     
     begin
             
       if (((htrans3 == `TRN_NONSEQ3) | (htrans3 == `TRN_SEQ3)) &
            (cs != 'd0) & hready3 & ~mis_err3)
          
          begin
             
             smc_valid3 = 1'b1;
             
               
             new_access3 = 1'b1;
             
             
          end
             
       else
          
          begin
             
             smc_valid3 = 1'b0;
             new_access3 = 1'b0;
             
          end
             
     end

//----------------------------------------------------------------------
// Error detection3
//----------------------------------------------------------------------

   always @(haddr3 or hsize3 or htrans3 or cs)
     
     begin
             
        if ((((haddr3[0] != 1'd0) & (hsize3 == `SZ_HALF3))      |
             ((haddr3[1:0] != 2'd0) & (hsize3 == `SZ_WORD3)))    &
            ((htrans3 == `TRN_NONSEQ3) | (htrans3 == `TRN_SEQ3)) &
            (cs != 1'b0) )
          
           mis_err3 = 1'h1;
             
        else
          
           mis_err3 = 1'h0;

     end 
   
//----------------------------------------------------------------------
// Disable3 detection3
//----------------------------------------------------------------------

   always @(htrans3 or cs or smc_idle3 or hready3)
     
     begin
             
           dis_err3 = 1'h0;
             
     end 
   
//----------------------------------------------------------------------
// Response3
//----------------------------------------------------------------------

   always @(posedge hclk3 or negedge n_sys_reset3)
     
     begin
             
        if (~n_sys_reset3)
          
            begin
             
               smc_hresp3 <= `RSP_OKAY3;
               r_hresp3 <= 1'd0;
             
            end
             
        else if (mis_err3 | dis_err3)
          
            begin
             
               r_hresp3 <= 1'd1;
               smc_hresp3 <= `RSP_ERROR3;
             
            end
             
        else if (r_hresp3 == 1'd1)
          
           begin
             
              smc_hresp3 <= `RSP_ERROR3;
              r_hresp3 <= 1'd0;
             
           end
             
        else
          
           begin
             
              smc_hresp3 <= `RSP_OKAY3;
              r_hresp3 <= 1'd0;
             
           end
             
     end
   
//----------------------------------------------------------------------
// assign read access sense
//----------------------------------------------------------------------

   always @(hwrite3)
     
     begin
             
        n_read3 = hwrite3;
             
     end

//----------------------------------------------------------------------
// AHB3 ready signal3
//----------------------------------------------------------------------

   always @(posedge hclk3 or negedge n_sys_reset3)
     
     begin
             
        if (~n_sys_reset3)
          
           r_ready3 <= 1'b1;
             
        else if ((((htrans3 == `TRN_IDLE3) | (htrans3 == `TRN_BUSY3)) & 
                  (cs != 1'b0) & hready3 & ~mis_err3 & 
                  ~dis_err3) | r_hresp3 | (hsel3 == 1'b0) )
          
           r_ready3 <= 1'b1;
             
        else
          
           r_ready3 <= 1'b0;
             
     end
 
//----------------------------------------------------------------------
//smc3 ready
//----------------------------------------------------------------------

   always @(r_ready3 or smc_done3 or mac_done3)
     
     begin
             
        smc_hready3 = r_ready3 | (smc_done3 & mac_done3);
             
     end
   
//----------------------------------------------------------------------
//read data
//----------------------------------------------------------------------
   
   always @(read_data3)
     
      smc_hrdata3 = read_data3;

//----------------------------------------------------------------------
//write data
//----------------------------------------------------------------------

   always @(hwdata3)
     
      write_data3 = hwdata3;
   


endmodule

