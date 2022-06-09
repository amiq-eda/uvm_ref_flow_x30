//File28 name   : alut_mem28.v
//Title28       : 
//Created28     : 1999
//Description28 : 
//Notes28       : 
//----------------------------------------------------------------------
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------

module alut_mem28
(   
   // Inputs28
   pclk28,
   mem_addr_add28,
   mem_write_add28,
   mem_write_data_add28,
   mem_addr_age28,
   mem_write_age28,
   mem_write_data_age28,

   mem_read_data_add28,   
   mem_read_data_age28
);   

   parameter   DW28 = 83;          // width of data busses28
   parameter   DD28 = 256;         // depth of RAM28

   input              pclk28;               // APB28 clock28                           
   input [7:0]        mem_addr_add28;       // hash28 address for R/W28 to memory     
   input              mem_write_add28;      // R/W28 flag28 (write = high28)            
   input [DW28-1:0]     mem_write_data_add28; // write data for memory             
   input [7:0]        mem_addr_age28;       // hash28 address for R/W28 to memory     
   input              mem_write_age28;      // R/W28 flag28 (write = high28)            
   input [DW28-1:0]     mem_write_data_age28; // write data for memory             

   output [DW28-1:0]    mem_read_data_add28;  // read data from mem                 
   output [DW28-1:0]    mem_read_data_age28;  // read data from mem  

   reg [DW28-1:0]       mem_core_array28[DD28-1:0]; // memory array               

   reg [DW28-1:0]       mem_read_data_add28;  // read data from mem                 
   reg [DW28-1:0]       mem_read_data_age28;  // read data from mem  


// -----------------------------------------------------------------------------
//   read and write control28 for address checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk28)
   begin
   if (~mem_write_add28) // read array
      mem_read_data_add28 <= mem_core_array28[mem_addr_add28];
   else
      mem_core_array28[mem_addr_add28] <= mem_write_data_add28;
   end

// -----------------------------------------------------------------------------
//   read and write control28 for age28 checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk28)
   begin
   if (~mem_write_age28) // read array
      mem_read_data_age28 <= mem_core_array28[mem_addr_age28];
   else
      mem_core_array28[mem_addr_age28] <= mem_write_data_age28;
   end


endmodule
