//File26 name   : alut_mem26.v
//Title26       : 
//Created26     : 1999
//Description26 : 
//Notes26       : 
//----------------------------------------------------------------------
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------

module alut_mem26
(   
   // Inputs26
   pclk26,
   mem_addr_add26,
   mem_write_add26,
   mem_write_data_add26,
   mem_addr_age26,
   mem_write_age26,
   mem_write_data_age26,

   mem_read_data_add26,   
   mem_read_data_age26
);   

   parameter   DW26 = 83;          // width of data busses26
   parameter   DD26 = 256;         // depth of RAM26

   input              pclk26;               // APB26 clock26                           
   input [7:0]        mem_addr_add26;       // hash26 address for R/W26 to memory     
   input              mem_write_add26;      // R/W26 flag26 (write = high26)            
   input [DW26-1:0]     mem_write_data_add26; // write data for memory             
   input [7:0]        mem_addr_age26;       // hash26 address for R/W26 to memory     
   input              mem_write_age26;      // R/W26 flag26 (write = high26)            
   input [DW26-1:0]     mem_write_data_age26; // write data for memory             

   output [DW26-1:0]    mem_read_data_add26;  // read data from mem                 
   output [DW26-1:0]    mem_read_data_age26;  // read data from mem  

   reg [DW26-1:0]       mem_core_array26[DD26-1:0]; // memory array               

   reg [DW26-1:0]       mem_read_data_add26;  // read data from mem                 
   reg [DW26-1:0]       mem_read_data_age26;  // read data from mem  


// -----------------------------------------------------------------------------
//   read and write control26 for address checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk26)
   begin
   if (~mem_write_add26) // read array
      mem_read_data_add26 <= mem_core_array26[mem_addr_add26];
   else
      mem_core_array26[mem_addr_add26] <= mem_write_data_add26;
   end

// -----------------------------------------------------------------------------
//   read and write control26 for age26 checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk26)
   begin
   if (~mem_write_age26) // read array
      mem_read_data_age26 <= mem_core_array26[mem_addr_age26];
   else
      mem_core_array26[mem_addr_age26] <= mem_write_data_age26;
   end


endmodule
