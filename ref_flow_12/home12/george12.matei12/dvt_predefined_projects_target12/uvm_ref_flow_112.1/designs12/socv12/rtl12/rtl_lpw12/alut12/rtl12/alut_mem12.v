//File12 name   : alut_mem12.v
//Title12       : 
//Created12     : 1999
//Description12 : 
//Notes12       : 
//----------------------------------------------------------------------
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------

module alut_mem12
(   
   // Inputs12
   pclk12,
   mem_addr_add12,
   mem_write_add12,
   mem_write_data_add12,
   mem_addr_age12,
   mem_write_age12,
   mem_write_data_age12,

   mem_read_data_add12,   
   mem_read_data_age12
);   

   parameter   DW12 = 83;          // width of data busses12
   parameter   DD12 = 256;         // depth of RAM12

   input              pclk12;               // APB12 clock12                           
   input [7:0]        mem_addr_add12;       // hash12 address for R/W12 to memory     
   input              mem_write_add12;      // R/W12 flag12 (write = high12)            
   input [DW12-1:0]     mem_write_data_add12; // write data for memory             
   input [7:0]        mem_addr_age12;       // hash12 address for R/W12 to memory     
   input              mem_write_age12;      // R/W12 flag12 (write = high12)            
   input [DW12-1:0]     mem_write_data_age12; // write data for memory             

   output [DW12-1:0]    mem_read_data_add12;  // read data from mem                 
   output [DW12-1:0]    mem_read_data_age12;  // read data from mem  

   reg [DW12-1:0]       mem_core_array12[DD12-1:0]; // memory array               

   reg [DW12-1:0]       mem_read_data_add12;  // read data from mem                 
   reg [DW12-1:0]       mem_read_data_age12;  // read data from mem  


// -----------------------------------------------------------------------------
//   read and write control12 for address checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk12)
   begin
   if (~mem_write_add12) // read array
      mem_read_data_add12 <= mem_core_array12[mem_addr_add12];
   else
      mem_core_array12[mem_addr_add12] <= mem_write_data_add12;
   end

// -----------------------------------------------------------------------------
//   read and write control12 for age12 checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk12)
   begin
   if (~mem_write_age12) // read array
      mem_read_data_age12 <= mem_core_array12[mem_addr_age12];
   else
      mem_core_array12[mem_addr_age12] <= mem_write_data_age12;
   end


endmodule
