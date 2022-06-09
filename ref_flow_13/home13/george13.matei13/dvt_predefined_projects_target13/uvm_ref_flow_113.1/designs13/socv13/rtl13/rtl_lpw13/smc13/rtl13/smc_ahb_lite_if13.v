//File13 name   : smc_ahb_lite_if13.v
//Title13       : 
//Created13     : 1999
//Description13 : AMBA13 AHB13 Interface13.
//            : Static13 Memory Controller13.
//            : This13 block provides13 the AHB13 interface. 
//            : All AHB13 specific13 signals13 are contained in this
//            : block.
//            : All address decoding13 for the SMC13 module is 
//            : done in
//            : this module and chip13 select13 signals13 generated13
//            : as well13 as an address valid (SMC_valid13) signal13
//            : back to the AHB13 decoder13
//Notes13       : 
//----------------------------------------------------------------------
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------



`include "smc_defs_lite13.v"

//ahb13 interface
  module smc_ahb_lite_if13  (

                      //inputs13

                      hclk13, 
                      n_sys_reset13, 
                      haddr13, 
                      hsel13,
                      htrans13, 
                      hwrite13, 
                      hsize13, 
                      hwdata13,  
                      hready13,  
  
                      //outputs13
  
                      smc_idle13,
                      read_data13, 
                      mac_done13, 
                      smc_done13, 
                      xfer_size13, 
                      n_read13, 
                      new_access13, 
                      addr, 
                      smc_hrdata13, 
                      smc_hready13,
                      smc_hresp13,
                      smc_valid13, 
                      cs, 
                      write_data13 
                      );
  
  
//include files


//----------------------------------------------------------------------


//System13 I13/O13

  input         hclk13;                   // AHB13 System13 clock13
  input         n_sys_reset13;            // AHB13 System13 reset (Active13 LOW13)
 

//AHB13 I13/O13

  input  [31:0]            haddr13;         // AHB13 Address
  input  [1:0]             htrans13;        // AHB13 transfer13 type
  input                    hwrite13;        // AHB13 read/write indication13
  input  [2:0]             hsize13;         // AHB13 transfer13 size
  input  [31:0]            hwdata13;        // AHB13 write data
  input                    hready13;        // AHB13 Muxed13 ready signal13
  output [31:0]            smc_hrdata13;    // smc13 read data back to AHB13
                                             //  master13
  output                   smc_hready13;    // smc13 ready signal13
  output [1:0]             smc_hresp13;     // AHB13 Response13 signal13
  output                   smc_valid13;     // Ack13 to AHB13

//other I13/O13
   
  input                    smc_idle13;      // idle13 state
  input                    smc_done13;      // Asserted13 during 
                                          // last cycle of an access
  input                    mac_done13;      // End13 of all transfers13
  input [31:0]             read_data13;     // Data at internal Bus13
  input               hsel13;          // Chip13 Selects13
   

  output [1:0]             xfer_size13;     // Store13 size for MAC13
  output [31:0]            addr;          // address
  output              cs;          // chip13 selects13 for external13
                                              //  memories
  output [31:0]            write_data13;    // Data to External13 Bus13
  output                   n_read13;        // Active13 low13 read signal13 
  output                   new_access13;    // New13 AHB13 valid access to
                                              //  smc13 detected




// Address Config13







//----------------------------------------------------------------------
// Signal13 declarations13
//----------------------------------------------------------------------

// Output13 register declarations13

// Bus13 Interface13

  reg  [31:0]              smc_hrdata13;  // smc13 read data back to
                                           //  AHB13 master13
  reg                      smc_hready13;  // smc13 ready signal13
  reg  [1:0]               smc_hresp13;   // AHB13 Response13 signal13
  reg                      smc_valid13;   // Ack13 to AHB13

// Internal register declarations13

// Bus13 Interface13

  reg                      new_access13;  // New13 AHB13 valid access
                                           //  to smc13 detected
                                           //  cfg block
  reg  [31:0]              addr;        // Copy13 of address
  reg  [31:0]              write_data13;  // Data to External13 Bus13
  reg  [7:0]               int_cs13;      // Chip13(bank13) Select13 Lines13
  wire                cs;          // Chip13(bank13) Select13 Lines13
  reg  [1:0]               xfer_size13;   // Width13 of current transfer13
  reg                      n_read13;      // Active13 low13 read signal13   
  reg                      r_ready13;     // registered ready signal13   
  reg                      r_hresp13;     // Two13 cycle hresp13 on error
  reg                      mis_err13;     // Misalignment13
  reg                      dis_err13;     // error

// End13 Bus13 Interface13



//----------------------------------------------------------------------
// Beginning13 of main13 code13
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// valid access control13 - AHB13 Interface13 (AHB13 Specific13)
//----------------------------------------------------------------------
// Generates13 the stobes13 required13 to start the smc13 state machine13
// Generates13 all AHB13 responses13.
//----------------------------------------------------------------------

   always @(hsize13)

     begin
     
      xfer_size13 = hsize13[1:0];

     end
   
//----------------------------------------------------------------------
//addr
//----------------------------------------------------------------------

   always @(haddr13)
     
     begin
        
        addr = haddr13;
        
     end
   
//----------------------------------------------------------------------
//chip13 select13 generation13
//----------------------------------------------------------------------

   assign cs = ( hsel13 ) ;
    
//----------------------------------------------------------------------
// detect13 a valid access
//----------------------------------------------------------------------

   always @(cs or hready13 or htrans13 or mis_err13)
     
     begin
             
       if (((htrans13 == `TRN_NONSEQ13) | (htrans13 == `TRN_SEQ13)) &
            (cs != 'd0) & hready13 & ~mis_err13)
          
          begin
             
             smc_valid13 = 1'b1;
             
               
             new_access13 = 1'b1;
             
             
          end
             
       else
          
          begin
             
             smc_valid13 = 1'b0;
             new_access13 = 1'b0;
             
          end
             
     end

//----------------------------------------------------------------------
// Error detection13
//----------------------------------------------------------------------

   always @(haddr13 or hsize13 or htrans13 or cs)
     
     begin
             
        if ((((haddr13[0] != 1'd0) & (hsize13 == `SZ_HALF13))      |
             ((haddr13[1:0] != 2'd0) & (hsize13 == `SZ_WORD13)))    &
            ((htrans13 == `TRN_NONSEQ13) | (htrans13 == `TRN_SEQ13)) &
            (cs != 1'b0) )
          
           mis_err13 = 1'h1;
             
        else
          
           mis_err13 = 1'h0;

     end 
   
//----------------------------------------------------------------------
// Disable13 detection13
//----------------------------------------------------------------------

   always @(htrans13 or cs or smc_idle13 or hready13)
     
     begin
             
           dis_err13 = 1'h0;
             
     end 
   
//----------------------------------------------------------------------
// Response13
//----------------------------------------------------------------------

   always @(posedge hclk13 or negedge n_sys_reset13)
     
     begin
             
        if (~n_sys_reset13)
          
            begin
             
               smc_hresp13 <= `RSP_OKAY13;
               r_hresp13 <= 1'd0;
             
            end
             
        else if (mis_err13 | dis_err13)
          
            begin
             
               r_hresp13 <= 1'd1;
               smc_hresp13 <= `RSP_ERROR13;
             
            end
             
        else if (r_hresp13 == 1'd1)
          
           begin
             
              smc_hresp13 <= `RSP_ERROR13;
              r_hresp13 <= 1'd0;
             
           end
             
        else
          
           begin
             
              smc_hresp13 <= `RSP_OKAY13;
              r_hresp13 <= 1'd0;
             
           end
             
     end
   
//----------------------------------------------------------------------
// assign read access sense
//----------------------------------------------------------------------

   always @(hwrite13)
     
     begin
             
        n_read13 = hwrite13;
             
     end

//----------------------------------------------------------------------
// AHB13 ready signal13
//----------------------------------------------------------------------

   always @(posedge hclk13 or negedge n_sys_reset13)
     
     begin
             
        if (~n_sys_reset13)
          
           r_ready13 <= 1'b1;
             
        else if ((((htrans13 == `TRN_IDLE13) | (htrans13 == `TRN_BUSY13)) & 
                  (cs != 1'b0) & hready13 & ~mis_err13 & 
                  ~dis_err13) | r_hresp13 | (hsel13 == 1'b0) )
          
           r_ready13 <= 1'b1;
             
        else
          
           r_ready13 <= 1'b0;
             
     end
 
//----------------------------------------------------------------------
//smc13 ready
//----------------------------------------------------------------------

   always @(r_ready13 or smc_done13 or mac_done13)
     
     begin
             
        smc_hready13 = r_ready13 | (smc_done13 & mac_done13);
             
     end
   
//----------------------------------------------------------------------
//read data
//----------------------------------------------------------------------
   
   always @(read_data13)
     
      smc_hrdata13 = read_data13;

//----------------------------------------------------------------------
//write data
//----------------------------------------------------------------------

   always @(hwdata13)
     
      write_data13 = hwdata13;
   


endmodule

