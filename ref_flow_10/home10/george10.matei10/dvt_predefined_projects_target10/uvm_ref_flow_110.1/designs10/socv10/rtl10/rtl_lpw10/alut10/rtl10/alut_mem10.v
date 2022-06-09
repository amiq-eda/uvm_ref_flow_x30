//File10 name   : alut_mem10.v
//Title10       : 
//Created10     : 1999
//Description10 : 
//Notes10       : 
//----------------------------------------------------------------------
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------

module alut_mem10
(   
   // Inputs10
   pclk10,
   mem_addr_add10,
   mem_write_add10,
   mem_write_data_add10,
   mem_addr_age10,
   mem_write_age10,
   mem_write_data_age10,

   mem_read_data_add10,   
   mem_read_data_age10
);   

   parameter   DW10 = 83;          // width of data busses10
   parameter   DD10 = 256;         // depth of RAM10

   input              pclk10;               // APB10 clock10                           
   input [7:0]        mem_addr_add10;       // hash10 address for R/W10 to memory     
   input              mem_write_add10;      // R/W10 flag10 (write = high10)            
   input [DW10-1:0]     mem_write_data_add10; // write data for memory             
   input [7:0]        mem_addr_age10;       // hash10 address for R/W10 to memory     
   input              mem_write_age10;      // R/W10 flag10 (write = high10)            
   input [DW10-1:0]     mem_write_data_age10; // write data for memory             

   output [DW10-1:0]    mem_read_data_add10;  // read data from mem                 
   output [DW10-1:0]    mem_read_data_age10;  // read data from mem  

   reg [DW10-1:0]       mem_core_array10[DD10-1:0]; // memory array               

   reg [DW10-1:0]       mem_read_data_add10;  // read data from mem                 
   reg [DW10-1:0]       mem_read_data_age10;  // read data from mem  


// -----------------------------------------------------------------------------
//   read and write control10 for address checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk10)
   begin
   if (~mem_write_add10) // read array
      mem_read_data_add10 <= mem_core_array10[mem_addr_add10];
   else
      mem_core_array10[mem_addr_add10] <= mem_write_data_add10;
   end

// -----------------------------------------------------------------------------
//   read and write control10 for age10 checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk10)
   begin
   if (~mem_write_age10) // read array
      mem_read_data_age10 <= mem_core_array10[mem_addr_age10];
   else
      mem_core_array10[mem_addr_age10] <= mem_write_data_age10;
   end


endmodule
