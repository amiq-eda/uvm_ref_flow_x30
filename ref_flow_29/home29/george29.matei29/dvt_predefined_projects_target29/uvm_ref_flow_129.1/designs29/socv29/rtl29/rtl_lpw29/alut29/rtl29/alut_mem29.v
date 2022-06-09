//File29 name   : alut_mem29.v
//Title29       : 
//Created29     : 1999
//Description29 : 
//Notes29       : 
//----------------------------------------------------------------------
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------

module alut_mem29
(   
   // Inputs29
   pclk29,
   mem_addr_add29,
   mem_write_add29,
   mem_write_data_add29,
   mem_addr_age29,
   mem_write_age29,
   mem_write_data_age29,

   mem_read_data_add29,   
   mem_read_data_age29
);   

   parameter   DW29 = 83;          // width of data busses29
   parameter   DD29 = 256;         // depth of RAM29

   input              pclk29;               // APB29 clock29                           
   input [7:0]        mem_addr_add29;       // hash29 address for R/W29 to memory     
   input              mem_write_add29;      // R/W29 flag29 (write = high29)            
   input [DW29-1:0]     mem_write_data_add29; // write data for memory             
   input [7:0]        mem_addr_age29;       // hash29 address for R/W29 to memory     
   input              mem_write_age29;      // R/W29 flag29 (write = high29)            
   input [DW29-1:0]     mem_write_data_age29; // write data for memory             

   output [DW29-1:0]    mem_read_data_add29;  // read data from mem                 
   output [DW29-1:0]    mem_read_data_age29;  // read data from mem  

   reg [DW29-1:0]       mem_core_array29[DD29-1:0]; // memory array               

   reg [DW29-1:0]       mem_read_data_add29;  // read data from mem                 
   reg [DW29-1:0]       mem_read_data_age29;  // read data from mem  


// -----------------------------------------------------------------------------
//   read and write control29 for address checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk29)
   begin
   if (~mem_write_add29) // read array
      mem_read_data_add29 <= mem_core_array29[mem_addr_add29];
   else
      mem_core_array29[mem_addr_add29] <= mem_write_data_add29;
   end

// -----------------------------------------------------------------------------
//   read and write control29 for age29 checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk29)
   begin
   if (~mem_write_age29) // read array
      mem_read_data_age29 <= mem_core_array29[mem_addr_age29];
   else
      mem_core_array29[mem_addr_age29] <= mem_write_data_age29;
   end


endmodule
