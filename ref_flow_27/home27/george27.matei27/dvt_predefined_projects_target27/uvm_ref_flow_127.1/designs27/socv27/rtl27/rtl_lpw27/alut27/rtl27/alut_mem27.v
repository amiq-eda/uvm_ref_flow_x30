//File27 name   : alut_mem27.v
//Title27       : 
//Created27     : 1999
//Description27 : 
//Notes27       : 
//----------------------------------------------------------------------
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------

module alut_mem27
(   
   // Inputs27
   pclk27,
   mem_addr_add27,
   mem_write_add27,
   mem_write_data_add27,
   mem_addr_age27,
   mem_write_age27,
   mem_write_data_age27,

   mem_read_data_add27,   
   mem_read_data_age27
);   

   parameter   DW27 = 83;          // width of data busses27
   parameter   DD27 = 256;         // depth of RAM27

   input              pclk27;               // APB27 clock27                           
   input [7:0]        mem_addr_add27;       // hash27 address for R/W27 to memory     
   input              mem_write_add27;      // R/W27 flag27 (write = high27)            
   input [DW27-1:0]     mem_write_data_add27; // write data for memory             
   input [7:0]        mem_addr_age27;       // hash27 address for R/W27 to memory     
   input              mem_write_age27;      // R/W27 flag27 (write = high27)            
   input [DW27-1:0]     mem_write_data_age27; // write data for memory             

   output [DW27-1:0]    mem_read_data_add27;  // read data from mem                 
   output [DW27-1:0]    mem_read_data_age27;  // read data from mem  

   reg [DW27-1:0]       mem_core_array27[DD27-1:0]; // memory array               

   reg [DW27-1:0]       mem_read_data_add27;  // read data from mem                 
   reg [DW27-1:0]       mem_read_data_age27;  // read data from mem  


// -----------------------------------------------------------------------------
//   read and write control27 for address checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk27)
   begin
   if (~mem_write_add27) // read array
      mem_read_data_add27 <= mem_core_array27[mem_addr_add27];
   else
      mem_core_array27[mem_addr_add27] <= mem_write_data_add27;
   end

// -----------------------------------------------------------------------------
//   read and write control27 for age27 checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk27)
   begin
   if (~mem_write_age27) // read array
      mem_read_data_age27 <= mem_core_array27[mem_addr_age27];
   else
      mem_core_array27[mem_addr_age27] <= mem_write_data_age27;
   end


endmodule
