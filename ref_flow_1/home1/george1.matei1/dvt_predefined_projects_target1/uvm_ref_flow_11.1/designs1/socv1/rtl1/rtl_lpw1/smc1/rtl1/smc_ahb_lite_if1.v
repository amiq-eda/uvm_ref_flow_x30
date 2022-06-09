//File1 name   : smc_ahb_lite_if1.v
//Title1       : 
//Created1     : 1999
//Description1 : AMBA1 AHB1 Interface1.
//            : Static1 Memory Controller1.
//            : This1 block provides1 the AHB1 interface. 
//            : All AHB1 specific1 signals1 are contained in this
//            : block.
//            : All address decoding1 for the SMC1 module is 
//            : done in
//            : this module and chip1 select1 signals1 generated1
//            : as well1 as an address valid (SMC_valid1) signal1
//            : back to the AHB1 decoder1
//Notes1       : 
//----------------------------------------------------------------------
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------



`include "smc_defs_lite1.v"

//ahb1 interface
  module smc_ahb_lite_if1  (

                      //inputs1

                      hclk1, 
                      n_sys_reset1, 
                      haddr1, 
                      hsel1,
                      htrans1, 
                      hwrite1, 
                      hsize1, 
                      hwdata1,  
                      hready1,  
  
                      //outputs1
  
                      smc_idle1,
                      read_data1, 
                      mac_done1, 
                      smc_done1, 
                      xfer_size1, 
                      n_read1, 
                      new_access1, 
                      addr, 
                      smc_hrdata1, 
                      smc_hready1,
                      smc_hresp1,
                      smc_valid1, 
                      cs, 
                      write_data1 
                      );
  
  
//include files


//----------------------------------------------------------------------


//System1 I1/O1

  input         hclk1;                   // AHB1 System1 clock1
  input         n_sys_reset1;            // AHB1 System1 reset (Active1 LOW1)
 

//AHB1 I1/O1

  input  [31:0]            haddr1;         // AHB1 Address
  input  [1:0]             htrans1;        // AHB1 transfer1 type
  input                    hwrite1;        // AHB1 read/write indication1
  input  [2:0]             hsize1;         // AHB1 transfer1 size
  input  [31:0]            hwdata1;        // AHB1 write data
  input                    hready1;        // AHB1 Muxed1 ready signal1
  output [31:0]            smc_hrdata1;    // smc1 read data back to AHB1
                                             //  master1
  output                   smc_hready1;    // smc1 ready signal1
  output [1:0]             smc_hresp1;     // AHB1 Response1 signal1
  output                   smc_valid1;     // Ack1 to AHB1

//other I1/O1
   
  input                    smc_idle1;      // idle1 state
  input                    smc_done1;      // Asserted1 during 
                                          // last cycle of an access
  input                    mac_done1;      // End1 of all transfers1
  input [31:0]             read_data1;     // Data at internal Bus1
  input               hsel1;          // Chip1 Selects1
   

  output [1:0]             xfer_size1;     // Store1 size for MAC1
  output [31:0]            addr;          // address
  output              cs;          // chip1 selects1 for external1
                                              //  memories
  output [31:0]            write_data1;    // Data to External1 Bus1
  output                   n_read1;        // Active1 low1 read signal1 
  output                   new_access1;    // New1 AHB1 valid access to
                                              //  smc1 detected




// Address Config1







//----------------------------------------------------------------------
// Signal1 declarations1
//----------------------------------------------------------------------

// Output1 register declarations1

// Bus1 Interface1

  reg  [31:0]              smc_hrdata1;  // smc1 read data back to
                                           //  AHB1 master1
  reg                      smc_hready1;  // smc1 ready signal1
  reg  [1:0]               smc_hresp1;   // AHB1 Response1 signal1
  reg                      smc_valid1;   // Ack1 to AHB1

// Internal register declarations1

// Bus1 Interface1

  reg                      new_access1;  // New1 AHB1 valid access
                                           //  to smc1 detected
                                           //  cfg block
  reg  [31:0]              addr;        // Copy1 of address
  reg  [31:0]              write_data1;  // Data to External1 Bus1
  reg  [7:0]               int_cs1;      // Chip1(bank1) Select1 Lines1
  wire                cs;          // Chip1(bank1) Select1 Lines1
  reg  [1:0]               xfer_size1;   // Width1 of current transfer1
  reg                      n_read1;      // Active1 low1 read signal1   
  reg                      r_ready1;     // registered ready signal1   
  reg                      r_hresp1;     // Two1 cycle hresp1 on error
  reg                      mis_err1;     // Misalignment1
  reg                      dis_err1;     // error

// End1 Bus1 Interface1



//----------------------------------------------------------------------
// Beginning1 of main1 code1
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// valid access control1 - AHB1 Interface1 (AHB1 Specific1)
//----------------------------------------------------------------------
// Generates1 the stobes1 required1 to start the smc1 state machine1
// Generates1 all AHB1 responses1.
//----------------------------------------------------------------------

   always @(hsize1)

     begin
     
      xfer_size1 = hsize1[1:0];

     end
   
//----------------------------------------------------------------------
//addr
//----------------------------------------------------------------------

   always @(haddr1)
     
     begin
        
        addr = haddr1;
        
     end
   
//----------------------------------------------------------------------
//chip1 select1 generation1
//----------------------------------------------------------------------

   assign cs = ( hsel1 ) ;
    
//----------------------------------------------------------------------
// detect1 a valid access
//----------------------------------------------------------------------

   always @(cs or hready1 or htrans1 or mis_err1)
     
     begin
             
       if (((htrans1 == `TRN_NONSEQ1) | (htrans1 == `TRN_SEQ1)) &
            (cs != 'd0) & hready1 & ~mis_err1)
          
          begin
             
             smc_valid1 = 1'b1;
             
               
             new_access1 = 1'b1;
             
             
          end
             
       else
          
          begin
             
             smc_valid1 = 1'b0;
             new_access1 = 1'b0;
             
          end
             
     end

//----------------------------------------------------------------------
// Error detection1
//----------------------------------------------------------------------

   always @(haddr1 or hsize1 or htrans1 or cs)
     
     begin
             
        if ((((haddr1[0] != 1'd0) & (hsize1 == `SZ_HALF1))      |
             ((haddr1[1:0] != 2'd0) & (hsize1 == `SZ_WORD1)))    &
            ((htrans1 == `TRN_NONSEQ1) | (htrans1 == `TRN_SEQ1)) &
            (cs != 1'b0) )
          
           mis_err1 = 1'h1;
             
        else
          
           mis_err1 = 1'h0;

     end 
   
//----------------------------------------------------------------------
// Disable1 detection1
//----------------------------------------------------------------------

   always @(htrans1 or cs or smc_idle1 or hready1)
     
     begin
             
           dis_err1 = 1'h0;
             
     end 
   
//----------------------------------------------------------------------
// Response1
//----------------------------------------------------------------------

   always @(posedge hclk1 or negedge n_sys_reset1)
     
     begin
             
        if (~n_sys_reset1)
          
            begin
             
               smc_hresp1 <= `RSP_OKAY1;
               r_hresp1 <= 1'd0;
             
            end
             
        else if (mis_err1 | dis_err1)
          
            begin
             
               r_hresp1 <= 1'd1;
               smc_hresp1 <= `RSP_ERROR1;
             
            end
             
        else if (r_hresp1 == 1'd1)
          
           begin
             
              smc_hresp1 <= `RSP_ERROR1;
              r_hresp1 <= 1'd0;
             
           end
             
        else
          
           begin
             
              smc_hresp1 <= `RSP_OKAY1;
              r_hresp1 <= 1'd0;
             
           end
             
     end
   
//----------------------------------------------------------------------
// assign read access sense
//----------------------------------------------------------------------

   always @(hwrite1)
     
     begin
             
        n_read1 = hwrite1;
             
     end

//----------------------------------------------------------------------
// AHB1 ready signal1
//----------------------------------------------------------------------

   always @(posedge hclk1 or negedge n_sys_reset1)
     
     begin
             
        if (~n_sys_reset1)
          
           r_ready1 <= 1'b1;
             
        else if ((((htrans1 == `TRN_IDLE1) | (htrans1 == `TRN_BUSY1)) & 
                  (cs != 1'b0) & hready1 & ~mis_err1 & 
                  ~dis_err1) | r_hresp1 | (hsel1 == 1'b0) )
          
           r_ready1 <= 1'b1;
             
        else
          
           r_ready1 <= 1'b0;
             
     end
 
//----------------------------------------------------------------------
//smc1 ready
//----------------------------------------------------------------------

   always @(r_ready1 or smc_done1 or mac_done1)
     
     begin
             
        smc_hready1 = r_ready1 | (smc_done1 & mac_done1);
             
     end
   
//----------------------------------------------------------------------
//read data
//----------------------------------------------------------------------
   
   always @(read_data1)
     
      smc_hrdata1 = read_data1;

//----------------------------------------------------------------------
//write data
//----------------------------------------------------------------------

   always @(hwdata1)
     
      write_data1 = hwdata1;
   


endmodule

