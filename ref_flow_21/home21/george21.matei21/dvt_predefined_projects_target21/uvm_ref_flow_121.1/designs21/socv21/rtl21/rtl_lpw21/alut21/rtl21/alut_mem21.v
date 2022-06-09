//File21 name   : alut_mem21.v
//Title21       : 
//Created21     : 1999
//Description21 : 
//Notes21       : 
//----------------------------------------------------------------------
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------

module alut_mem21
(   
   // Inputs21
   pclk21,
   mem_addr_add21,
   mem_write_add21,
   mem_write_data_add21,
   mem_addr_age21,
   mem_write_age21,
   mem_write_data_age21,

   mem_read_data_add21,   
   mem_read_data_age21
);   

   parameter   DW21 = 83;          // width of data busses21
   parameter   DD21 = 256;         // depth of RAM21

   input              pclk21;               // APB21 clock21                           
   input [7:0]        mem_addr_add21;       // hash21 address for R/W21 to memory     
   input              mem_write_add21;      // R/W21 flag21 (write = high21)            
   input [DW21-1:0]     mem_write_data_add21; // write data for memory             
   input [7:0]        mem_addr_age21;       // hash21 address for R/W21 to memory     
   input              mem_write_age21;      // R/W21 flag21 (write = high21)            
   input [DW21-1:0]     mem_write_data_age21; // write data for memory             

   output [DW21-1:0]    mem_read_data_add21;  // read data from mem                 
   output [DW21-1:0]    mem_read_data_age21;  // read data from mem  

   reg [DW21-1:0]       mem_core_array21[DD21-1:0]; // memory array               

   reg [DW21-1:0]       mem_read_data_add21;  // read data from mem                 
   reg [DW21-1:0]       mem_read_data_age21;  // read data from mem  


// -----------------------------------------------------------------------------
//   read and write control21 for address checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk21)
   begin
   if (~mem_write_add21) // read array
      mem_read_data_add21 <= mem_core_array21[mem_addr_add21];
   else
      mem_core_array21[mem_addr_add21] <= mem_write_data_add21;
   end

// -----------------------------------------------------------------------------
//   read and write control21 for age21 checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk21)
   begin
   if (~mem_write_age21) // read array
      mem_read_data_age21 <= mem_core_array21[mem_addr_age21];
   else
      mem_core_array21[mem_addr_age21] <= mem_write_data_age21;
   end


endmodule
