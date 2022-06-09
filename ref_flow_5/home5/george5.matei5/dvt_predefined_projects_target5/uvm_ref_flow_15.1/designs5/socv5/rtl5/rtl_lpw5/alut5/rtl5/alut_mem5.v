//File5 name   : alut_mem5.v
//Title5       : 
//Created5     : 1999
//Description5 : 
//Notes5       : 
//----------------------------------------------------------------------
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------

module alut_mem5
(   
   // Inputs5
   pclk5,
   mem_addr_add5,
   mem_write_add5,
   mem_write_data_add5,
   mem_addr_age5,
   mem_write_age5,
   mem_write_data_age5,

   mem_read_data_add5,   
   mem_read_data_age5
);   

   parameter   DW5 = 83;          // width of data busses5
   parameter   DD5 = 256;         // depth of RAM5

   input              pclk5;               // APB5 clock5                           
   input [7:0]        mem_addr_add5;       // hash5 address for R/W5 to memory     
   input              mem_write_add5;      // R/W5 flag5 (write = high5)            
   input [DW5-1:0]     mem_write_data_add5; // write data for memory             
   input [7:0]        mem_addr_age5;       // hash5 address for R/W5 to memory     
   input              mem_write_age5;      // R/W5 flag5 (write = high5)            
   input [DW5-1:0]     mem_write_data_age5; // write data for memory             

   output [DW5-1:0]    mem_read_data_add5;  // read data from mem                 
   output [DW5-1:0]    mem_read_data_age5;  // read data from mem  

   reg [DW5-1:0]       mem_core_array5[DD5-1:0]; // memory array               

   reg [DW5-1:0]       mem_read_data_add5;  // read data from mem                 
   reg [DW5-1:0]       mem_read_data_age5;  // read data from mem  


// -----------------------------------------------------------------------------
//   read and write control5 for address checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk5)
   begin
   if (~mem_write_add5) // read array
      mem_read_data_add5 <= mem_core_array5[mem_addr_add5];
   else
      mem_core_array5[mem_addr_add5] <= mem_write_data_add5;
   end

// -----------------------------------------------------------------------------
//   read and write control5 for age5 checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk5)
   begin
   if (~mem_write_age5) // read array
      mem_read_data_age5 <= mem_core_array5[mem_addr_age5];
   else
      mem_core_array5[mem_addr_age5] <= mem_write_data_age5;
   end


endmodule
