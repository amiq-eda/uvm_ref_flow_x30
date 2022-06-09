//File30 name   : alut_mem30.v
//Title30       : 
//Created30     : 1999
//Description30 : 
//Notes30       : 
//----------------------------------------------------------------------
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------

module alut_mem30
(   
   // Inputs30
   pclk30,
   mem_addr_add30,
   mem_write_add30,
   mem_write_data_add30,
   mem_addr_age30,
   mem_write_age30,
   mem_write_data_age30,

   mem_read_data_add30,   
   mem_read_data_age30
);   

   parameter   DW30 = 83;          // width of data busses30
   parameter   DD30 = 256;         // depth of RAM30

   input              pclk30;               // APB30 clock30                           
   input [7:0]        mem_addr_add30;       // hash30 address for R/W30 to memory     
   input              mem_write_add30;      // R/W30 flag30 (write = high30)            
   input [DW30-1:0]     mem_write_data_add30; // write data for memory             
   input [7:0]        mem_addr_age30;       // hash30 address for R/W30 to memory     
   input              mem_write_age30;      // R/W30 flag30 (write = high30)            
   input [DW30-1:0]     mem_write_data_age30; // write data for memory             

   output [DW30-1:0]    mem_read_data_add30;  // read data from mem                 
   output [DW30-1:0]    mem_read_data_age30;  // read data from mem  

   reg [DW30-1:0]       mem_core_array30[DD30-1:0]; // memory array               

   reg [DW30-1:0]       mem_read_data_add30;  // read data from mem                 
   reg [DW30-1:0]       mem_read_data_age30;  // read data from mem  


// -----------------------------------------------------------------------------
//   read and write control30 for address checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk30)
   begin
   if (~mem_write_add30) // read array
      mem_read_data_add30 <= mem_core_array30[mem_addr_add30];
   else
      mem_core_array30[mem_addr_add30] <= mem_write_data_add30;
   end

// -----------------------------------------------------------------------------
//   read and write control30 for age30 checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk30)
   begin
   if (~mem_write_age30) // read array
      mem_read_data_age30 <= mem_core_array30[mem_addr_age30];
   else
      mem_core_array30[mem_addr_age30] <= mem_write_data_age30;
   end


endmodule
