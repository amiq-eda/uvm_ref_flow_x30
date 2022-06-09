//File6 name   : alut_mem6.v
//Title6       : 
//Created6     : 1999
//Description6 : 
//Notes6       : 
//----------------------------------------------------------------------
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------

module alut_mem6
(   
   // Inputs6
   pclk6,
   mem_addr_add6,
   mem_write_add6,
   mem_write_data_add6,
   mem_addr_age6,
   mem_write_age6,
   mem_write_data_age6,

   mem_read_data_add6,   
   mem_read_data_age6
);   

   parameter   DW6 = 83;          // width of data busses6
   parameter   DD6 = 256;         // depth of RAM6

   input              pclk6;               // APB6 clock6                           
   input [7:0]        mem_addr_add6;       // hash6 address for R/W6 to memory     
   input              mem_write_add6;      // R/W6 flag6 (write = high6)            
   input [DW6-1:0]     mem_write_data_add6; // write data for memory             
   input [7:0]        mem_addr_age6;       // hash6 address for R/W6 to memory     
   input              mem_write_age6;      // R/W6 flag6 (write = high6)            
   input [DW6-1:0]     mem_write_data_age6; // write data for memory             

   output [DW6-1:0]    mem_read_data_add6;  // read data from mem                 
   output [DW6-1:0]    mem_read_data_age6;  // read data from mem  

   reg [DW6-1:0]       mem_core_array6[DD6-1:0]; // memory array               

   reg [DW6-1:0]       mem_read_data_add6;  // read data from mem                 
   reg [DW6-1:0]       mem_read_data_age6;  // read data from mem  


// -----------------------------------------------------------------------------
//   read and write control6 for address checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk6)
   begin
   if (~mem_write_add6) // read array
      mem_read_data_add6 <= mem_core_array6[mem_addr_add6];
   else
      mem_core_array6[mem_addr_add6] <= mem_write_data_add6;
   end

// -----------------------------------------------------------------------------
//   read and write control6 for age6 checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk6)
   begin
   if (~mem_write_age6) // read array
      mem_read_data_age6 <= mem_core_array6[mem_addr_age6];
   else
      mem_core_array6[mem_addr_age6] <= mem_write_data_age6;
   end


endmodule
