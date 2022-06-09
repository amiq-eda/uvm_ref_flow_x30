//File9 name   : alut_mem9.v
//Title9       : 
//Created9     : 1999
//Description9 : 
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

module alut_mem9
(   
   // Inputs9
   pclk9,
   mem_addr_add9,
   mem_write_add9,
   mem_write_data_add9,
   mem_addr_age9,
   mem_write_age9,
   mem_write_data_age9,

   mem_read_data_add9,   
   mem_read_data_age9
);   

   parameter   DW9 = 83;          // width of data busses9
   parameter   DD9 = 256;         // depth of RAM9

   input              pclk9;               // APB9 clock9                           
   input [7:0]        mem_addr_add9;       // hash9 address for R/W9 to memory     
   input              mem_write_add9;      // R/W9 flag9 (write = high9)            
   input [DW9-1:0]     mem_write_data_add9; // write data for memory             
   input [7:0]        mem_addr_age9;       // hash9 address for R/W9 to memory     
   input              mem_write_age9;      // R/W9 flag9 (write = high9)            
   input [DW9-1:0]     mem_write_data_age9; // write data for memory             

   output [DW9-1:0]    mem_read_data_add9;  // read data from mem                 
   output [DW9-1:0]    mem_read_data_age9;  // read data from mem  

   reg [DW9-1:0]       mem_core_array9[DD9-1:0]; // memory array               

   reg [DW9-1:0]       mem_read_data_add9;  // read data from mem                 
   reg [DW9-1:0]       mem_read_data_age9;  // read data from mem  


// -----------------------------------------------------------------------------
//   read and write control9 for address checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk9)
   begin
   if (~mem_write_add9) // read array
      mem_read_data_add9 <= mem_core_array9[mem_addr_add9];
   else
      mem_core_array9[mem_addr_add9] <= mem_write_data_add9;
   end

// -----------------------------------------------------------------------------
//   read and write control9 for age9 checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk9)
   begin
   if (~mem_write_age9) // read array
      mem_read_data_age9 <= mem_core_array9[mem_addr_age9];
   else
      mem_core_array9[mem_addr_age9] <= mem_write_data_age9;
   end


endmodule
