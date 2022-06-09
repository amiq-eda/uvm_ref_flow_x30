//File2 name   : smc_ahb_lite_if2.v
//Title2       : 
//Created2     : 1999
//Description2 : AMBA2 AHB2 Interface2.
//            : Static2 Memory Controller2.
//            : This2 block provides2 the AHB2 interface. 
//            : All AHB2 specific2 signals2 are contained in this
//            : block.
//            : All address decoding2 for the SMC2 module is 
//            : done in
//            : this module and chip2 select2 signals2 generated2
//            : as well2 as an address valid (SMC_valid2) signal2
//            : back to the AHB2 decoder2
//Notes2       : 
//----------------------------------------------------------------------
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------



`include "smc_defs_lite2.v"

//ahb2 interface
  module smc_ahb_lite_if2  (

                      //inputs2

                      hclk2, 
                      n_sys_reset2, 
                      haddr2, 
                      hsel2,
                      htrans2, 
                      hwrite2, 
                      hsize2, 
                      hwdata2,  
                      hready2,  
  
                      //outputs2
  
                      smc_idle2,
                      read_data2, 
                      mac_done2, 
                      smc_done2, 
                      xfer_size2, 
                      n_read2, 
                      new_access2, 
                      addr, 
                      smc_hrdata2, 
                      smc_hready2,
                      smc_hresp2,
                      smc_valid2, 
                      cs, 
                      write_data2 
                      );
  
  
//include files


//----------------------------------------------------------------------


//System2 I2/O2

  input         hclk2;                   // AHB2 System2 clock2
  input         n_sys_reset2;            // AHB2 System2 reset (Active2 LOW2)
 

//AHB2 I2/O2

  input  [31:0]            haddr2;         // AHB2 Address
  input  [1:0]             htrans2;        // AHB2 transfer2 type
  input                    hwrite2;        // AHB2 read/write indication2
  input  [2:0]             hsize2;         // AHB2 transfer2 size
  input  [31:0]            hwdata2;        // AHB2 write data
  input                    hready2;        // AHB2 Muxed2 ready signal2
  output [31:0]            smc_hrdata2;    // smc2 read data back to AHB2
                                             //  master2
  output                   smc_hready2;    // smc2 ready signal2
  output [1:0]             smc_hresp2;     // AHB2 Response2 signal2
  output                   smc_valid2;     // Ack2 to AHB2

//other I2/O2
   
  input                    smc_idle2;      // idle2 state
  input                    smc_done2;      // Asserted2 during 
                                          // last cycle of an access
  input                    mac_done2;      // End2 of all transfers2
  input [31:0]             read_data2;     // Data at internal Bus2
  input               hsel2;          // Chip2 Selects2
   

  output [1:0]             xfer_size2;     // Store2 size for MAC2
  output [31:0]            addr;          // address
  output              cs;          // chip2 selects2 for external2
                                              //  memories
  output [31:0]            write_data2;    // Data to External2 Bus2
  output                   n_read2;        // Active2 low2 read signal2 
  output                   new_access2;    // New2 AHB2 valid access to
                                              //  smc2 detected




// Address Config2







//----------------------------------------------------------------------
// Signal2 declarations2
//----------------------------------------------------------------------

// Output2 register declarations2

// Bus2 Interface2

  reg  [31:0]              smc_hrdata2;  // smc2 read data back to
                                           //  AHB2 master2
  reg                      smc_hready2;  // smc2 ready signal2
  reg  [1:0]               smc_hresp2;   // AHB2 Response2 signal2
  reg                      smc_valid2;   // Ack2 to AHB2

// Internal register declarations2

// Bus2 Interface2

  reg                      new_access2;  // New2 AHB2 valid access
                                           //  to smc2 detected
                                           //  cfg block
  reg  [31:0]              addr;        // Copy2 of address
  reg  [31:0]              write_data2;  // Data to External2 Bus2
  reg  [7:0]               int_cs2;      // Chip2(bank2) Select2 Lines2
  wire                cs;          // Chip2(bank2) Select2 Lines2
  reg  [1:0]               xfer_size2;   // Width2 of current transfer2
  reg                      n_read2;      // Active2 low2 read signal2   
  reg                      r_ready2;     // registered ready signal2   
  reg                      r_hresp2;     // Two2 cycle hresp2 on error
  reg                      mis_err2;     // Misalignment2
  reg                      dis_err2;     // error

// End2 Bus2 Interface2



//----------------------------------------------------------------------
// Beginning2 of main2 code2
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// valid access control2 - AHB2 Interface2 (AHB2 Specific2)
//----------------------------------------------------------------------
// Generates2 the stobes2 required2 to start the smc2 state machine2
// Generates2 all AHB2 responses2.
//----------------------------------------------------------------------

   always @(hsize2)

     begin
     
      xfer_size2 = hsize2[1:0];

     end
   
//----------------------------------------------------------------------
//addr
//----------------------------------------------------------------------

   always @(haddr2)
     
     begin
        
        addr = haddr2;
        
     end
   
//----------------------------------------------------------------------
//chip2 select2 generation2
//----------------------------------------------------------------------

   assign cs = ( hsel2 ) ;
    
//----------------------------------------------------------------------
// detect2 a valid access
//----------------------------------------------------------------------

   always @(cs or hready2 or htrans2 or mis_err2)
     
     begin
             
       if (((htrans2 == `TRN_NONSEQ2) | (htrans2 == `TRN_SEQ2)) &
            (cs != 'd0) & hready2 & ~mis_err2)
          
          begin
             
             smc_valid2 = 1'b1;
             
               
             new_access2 = 1'b1;
             
             
          end
             
       else
          
          begin
             
             smc_valid2 = 1'b0;
             new_access2 = 1'b0;
             
          end
             
     end

//----------------------------------------------------------------------
// Error detection2
//----------------------------------------------------------------------

   always @(haddr2 or hsize2 or htrans2 or cs)
     
     begin
             
        if ((((haddr2[0] != 1'd0) & (hsize2 == `SZ_HALF2))      |
             ((haddr2[1:0] != 2'd0) & (hsize2 == `SZ_WORD2)))    &
            ((htrans2 == `TRN_NONSEQ2) | (htrans2 == `TRN_SEQ2)) &
            (cs != 1'b0) )
          
           mis_err2 = 1'h1;
             
        else
          
           mis_err2 = 1'h0;

     end 
   
//----------------------------------------------------------------------
// Disable2 detection2
//----------------------------------------------------------------------

   always @(htrans2 or cs or smc_idle2 or hready2)
     
     begin
             
           dis_err2 = 1'h0;
             
     end 
   
//----------------------------------------------------------------------
// Response2
//----------------------------------------------------------------------

   always @(posedge hclk2 or negedge n_sys_reset2)
     
     begin
             
        if (~n_sys_reset2)
          
            begin
             
               smc_hresp2 <= `RSP_OKAY2;
               r_hresp2 <= 1'd0;
             
            end
             
        else if (mis_err2 | dis_err2)
          
            begin
             
               r_hresp2 <= 1'd1;
               smc_hresp2 <= `RSP_ERROR2;
             
            end
             
        else if (r_hresp2 == 1'd1)
          
           begin
             
              smc_hresp2 <= `RSP_ERROR2;
              r_hresp2 <= 1'd0;
             
           end
             
        else
          
           begin
             
              smc_hresp2 <= `RSP_OKAY2;
              r_hresp2 <= 1'd0;
             
           end
             
     end
   
//----------------------------------------------------------------------
// assign read access sense
//----------------------------------------------------------------------

   always @(hwrite2)
     
     begin
             
        n_read2 = hwrite2;
             
     end

//----------------------------------------------------------------------
// AHB2 ready signal2
//----------------------------------------------------------------------

   always @(posedge hclk2 or negedge n_sys_reset2)
     
     begin
             
        if (~n_sys_reset2)
          
           r_ready2 <= 1'b1;
             
        else if ((((htrans2 == `TRN_IDLE2) | (htrans2 == `TRN_BUSY2)) & 
                  (cs != 1'b0) & hready2 & ~mis_err2 & 
                  ~dis_err2) | r_hresp2 | (hsel2 == 1'b0) )
          
           r_ready2 <= 1'b1;
             
        else
          
           r_ready2 <= 1'b0;
             
     end
 
//----------------------------------------------------------------------
//smc2 ready
//----------------------------------------------------------------------

   always @(r_ready2 or smc_done2 or mac_done2)
     
     begin
             
        smc_hready2 = r_ready2 | (smc_done2 & mac_done2);
             
     end
   
//----------------------------------------------------------------------
//read data
//----------------------------------------------------------------------
   
   always @(read_data2)
     
      smc_hrdata2 = read_data2;

//----------------------------------------------------------------------
//write data
//----------------------------------------------------------------------

   always @(hwdata2)
     
      write_data2 = hwdata2;
   


endmodule

