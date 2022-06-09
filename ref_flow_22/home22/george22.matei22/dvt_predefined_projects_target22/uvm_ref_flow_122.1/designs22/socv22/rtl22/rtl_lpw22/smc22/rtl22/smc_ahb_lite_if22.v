//File22 name   : smc_ahb_lite_if22.v
//Title22       : 
//Created22     : 1999
//Description22 : AMBA22 AHB22 Interface22.
//            : Static22 Memory Controller22.
//            : This22 block provides22 the AHB22 interface. 
//            : All AHB22 specific22 signals22 are contained in this
//            : block.
//            : All address decoding22 for the SMC22 module is 
//            : done in
//            : this module and chip22 select22 signals22 generated22
//            : as well22 as an address valid (SMC_valid22) signal22
//            : back to the AHB22 decoder22
//Notes22       : 
//----------------------------------------------------------------------
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------



`include "smc_defs_lite22.v"

//ahb22 interface
  module smc_ahb_lite_if22  (

                      //inputs22

                      hclk22, 
                      n_sys_reset22, 
                      haddr22, 
                      hsel22,
                      htrans22, 
                      hwrite22, 
                      hsize22, 
                      hwdata22,  
                      hready22,  
  
                      //outputs22
  
                      smc_idle22,
                      read_data22, 
                      mac_done22, 
                      smc_done22, 
                      xfer_size22, 
                      n_read22, 
                      new_access22, 
                      addr, 
                      smc_hrdata22, 
                      smc_hready22,
                      smc_hresp22,
                      smc_valid22, 
                      cs, 
                      write_data22 
                      );
  
  
//include files


//----------------------------------------------------------------------


//System22 I22/O22

  input         hclk22;                   // AHB22 System22 clock22
  input         n_sys_reset22;            // AHB22 System22 reset (Active22 LOW22)
 

//AHB22 I22/O22

  input  [31:0]            haddr22;         // AHB22 Address
  input  [1:0]             htrans22;        // AHB22 transfer22 type
  input                    hwrite22;        // AHB22 read/write indication22
  input  [2:0]             hsize22;         // AHB22 transfer22 size
  input  [31:0]            hwdata22;        // AHB22 write data
  input                    hready22;        // AHB22 Muxed22 ready signal22
  output [31:0]            smc_hrdata22;    // smc22 read data back to AHB22
                                             //  master22
  output                   smc_hready22;    // smc22 ready signal22
  output [1:0]             smc_hresp22;     // AHB22 Response22 signal22
  output                   smc_valid22;     // Ack22 to AHB22

//other I22/O22
   
  input                    smc_idle22;      // idle22 state
  input                    smc_done22;      // Asserted22 during 
                                          // last cycle of an access
  input                    mac_done22;      // End22 of all transfers22
  input [31:0]             read_data22;     // Data at internal Bus22
  input               hsel22;          // Chip22 Selects22
   

  output [1:0]             xfer_size22;     // Store22 size for MAC22
  output [31:0]            addr;          // address
  output              cs;          // chip22 selects22 for external22
                                              //  memories
  output [31:0]            write_data22;    // Data to External22 Bus22
  output                   n_read22;        // Active22 low22 read signal22 
  output                   new_access22;    // New22 AHB22 valid access to
                                              //  smc22 detected




// Address Config22







//----------------------------------------------------------------------
// Signal22 declarations22
//----------------------------------------------------------------------

// Output22 register declarations22

// Bus22 Interface22

  reg  [31:0]              smc_hrdata22;  // smc22 read data back to
                                           //  AHB22 master22
  reg                      smc_hready22;  // smc22 ready signal22
  reg  [1:0]               smc_hresp22;   // AHB22 Response22 signal22
  reg                      smc_valid22;   // Ack22 to AHB22

// Internal register declarations22

// Bus22 Interface22

  reg                      new_access22;  // New22 AHB22 valid access
                                           //  to smc22 detected
                                           //  cfg block
  reg  [31:0]              addr;        // Copy22 of address
  reg  [31:0]              write_data22;  // Data to External22 Bus22
  reg  [7:0]               int_cs22;      // Chip22(bank22) Select22 Lines22
  wire                cs;          // Chip22(bank22) Select22 Lines22
  reg  [1:0]               xfer_size22;   // Width22 of current transfer22
  reg                      n_read22;      // Active22 low22 read signal22   
  reg                      r_ready22;     // registered ready signal22   
  reg                      r_hresp22;     // Two22 cycle hresp22 on error
  reg                      mis_err22;     // Misalignment22
  reg                      dis_err22;     // error

// End22 Bus22 Interface22



//----------------------------------------------------------------------
// Beginning22 of main22 code22
//----------------------------------------------------------------------

//----------------------------------------------------------------------
// valid access control22 - AHB22 Interface22 (AHB22 Specific22)
//----------------------------------------------------------------------
// Generates22 the stobes22 required22 to start the smc22 state machine22
// Generates22 all AHB22 responses22.
//----------------------------------------------------------------------

   always @(hsize22)

     begin
     
      xfer_size22 = hsize22[1:0];

     end
   
//----------------------------------------------------------------------
//addr
//----------------------------------------------------------------------

   always @(haddr22)
     
     begin
        
        addr = haddr22;
        
     end
   
//----------------------------------------------------------------------
//chip22 select22 generation22
//----------------------------------------------------------------------

   assign cs = ( hsel22 ) ;
    
//----------------------------------------------------------------------
// detect22 a valid access
//----------------------------------------------------------------------

   always @(cs or hready22 or htrans22 or mis_err22)
     
     begin
             
       if (((htrans22 == `TRN_NONSEQ22) | (htrans22 == `TRN_SEQ22)) &
            (cs != 'd0) & hready22 & ~mis_err22)
          
          begin
             
             smc_valid22 = 1'b1;
             
               
             new_access22 = 1'b1;
             
             
          end
             
       else
          
          begin
             
             smc_valid22 = 1'b0;
             new_access22 = 1'b0;
             
          end
             
     end

//----------------------------------------------------------------------
// Error detection22
//----------------------------------------------------------------------

   always @(haddr22 or hsize22 or htrans22 or cs)
     
     begin
             
        if ((((haddr22[0] != 1'd0) & (hsize22 == `SZ_HALF22))      |
             ((haddr22[1:0] != 2'd0) & (hsize22 == `SZ_WORD22)))    &
            ((htrans22 == `TRN_NONSEQ22) | (htrans22 == `TRN_SEQ22)) &
            (cs != 1'b0) )
          
           mis_err22 = 1'h1;
             
        else
          
           mis_err22 = 1'h0;

     end 
   
//----------------------------------------------------------------------
// Disable22 detection22
//----------------------------------------------------------------------

   always @(htrans22 or cs or smc_idle22 or hready22)
     
     begin
             
           dis_err22 = 1'h0;
             
     end 
   
//----------------------------------------------------------------------
// Response22
//----------------------------------------------------------------------

   always @(posedge hclk22 or negedge n_sys_reset22)
     
     begin
             
        if (~n_sys_reset22)
          
            begin
             
               smc_hresp22 <= `RSP_OKAY22;
               r_hresp22 <= 1'd0;
             
            end
             
        else if (mis_err22 | dis_err22)
          
            begin
             
               r_hresp22 <= 1'd1;
               smc_hresp22 <= `RSP_ERROR22;
             
            end
             
        else if (r_hresp22 == 1'd1)
          
           begin
             
              smc_hresp22 <= `RSP_ERROR22;
              r_hresp22 <= 1'd0;
             
           end
             
        else
          
           begin
             
              smc_hresp22 <= `RSP_OKAY22;
              r_hresp22 <= 1'd0;
             
           end
             
     end
   
//----------------------------------------------------------------------
// assign read access sense
//----------------------------------------------------------------------

   always @(hwrite22)
     
     begin
             
        n_read22 = hwrite22;
             
     end

//----------------------------------------------------------------------
// AHB22 ready signal22
//----------------------------------------------------------------------

   always @(posedge hclk22 or negedge n_sys_reset22)
     
     begin
             
        if (~n_sys_reset22)
          
           r_ready22 <= 1'b1;
             
        else if ((((htrans22 == `TRN_IDLE22) | (htrans22 == `TRN_BUSY22)) & 
                  (cs != 1'b0) & hready22 & ~mis_err22 & 
                  ~dis_err22) | r_hresp22 | (hsel22 == 1'b0) )
          
           r_ready22 <= 1'b1;
             
        else
          
           r_ready22 <= 1'b0;
             
     end
 
//----------------------------------------------------------------------
//smc22 ready
//----------------------------------------------------------------------

   always @(r_ready22 or smc_done22 or mac_done22)
     
     begin
             
        smc_hready22 = r_ready22 | (smc_done22 & mac_done22);
             
     end
   
//----------------------------------------------------------------------
//read data
//----------------------------------------------------------------------
   
   always @(read_data22)
     
      smc_hrdata22 = read_data22;

//----------------------------------------------------------------------
//write data
//----------------------------------------------------------------------

   always @(hwdata22)
     
      write_data22 = hwdata22;
   


endmodule

