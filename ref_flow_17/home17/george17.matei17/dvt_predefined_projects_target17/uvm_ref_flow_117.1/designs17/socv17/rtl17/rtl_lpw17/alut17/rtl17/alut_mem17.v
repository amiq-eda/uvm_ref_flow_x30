//File17 name   : alut_mem17.v
//Title17       : 
//Created17     : 1999
//Description17 : 
//Notes17       : 
//----------------------------------------------------------------------
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------

module alut_mem17
(   
   // Inputs17
   pclk17,
   mem_addr_add17,
   mem_write_add17,
   mem_write_data_add17,
   mem_addr_age17,
   mem_write_age17,
   mem_write_data_age17,

   mem_read_data_add17,   
   mem_read_data_age17
);   

   parameter   DW17 = 83;          // width of data busses17
   parameter   DD17 = 256;         // depth of RAM17

   input              pclk17;               // APB17 clock17                           
   input [7:0]        mem_addr_add17;       // hash17 address for R/W17 to memory     
   input              mem_write_add17;      // R/W17 flag17 (write = high17)            
   input [DW17-1:0]     mem_write_data_add17; // write data for memory             
   input [7:0]        mem_addr_age17;       // hash17 address for R/W17 to memory     
   input              mem_write_age17;      // R/W17 flag17 (write = high17)            
   input [DW17-1:0]     mem_write_data_age17; // write data for memory             

   output [DW17-1:0]    mem_read_data_add17;  // read data from mem                 
   output [DW17-1:0]    mem_read_data_age17;  // read data from mem  

   reg [DW17-1:0]       mem_core_array17[DD17-1:0]; // memory array               

   reg [DW17-1:0]       mem_read_data_add17;  // read data from mem                 
   reg [DW17-1:0]       mem_read_data_age17;  // read data from mem  


// -----------------------------------------------------------------------------
//   read and write control17 for address checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk17)
   begin
   if (~mem_write_add17) // read array
      mem_read_data_add17 <= mem_core_array17[mem_addr_add17];
   else
      mem_core_array17[mem_addr_add17] <= mem_write_data_add17;
   end

// -----------------------------------------------------------------------------
//   read and write control17 for age17 checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk17)
   begin
   if (~mem_write_age17) // read array
      mem_read_data_age17 <= mem_core_array17[mem_addr_age17];
   else
      mem_core_array17[mem_addr_age17] <= mem_write_data_age17;
   end


endmodule
