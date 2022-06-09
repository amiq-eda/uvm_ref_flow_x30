//File3 name   : alut_mem3.v
//Title3       : 
//Created3     : 1999
//Description3 : 
//Notes3       : 
//----------------------------------------------------------------------
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------

module alut_mem3
(   
   // Inputs3
   pclk3,
   mem_addr_add3,
   mem_write_add3,
   mem_write_data_add3,
   mem_addr_age3,
   mem_write_age3,
   mem_write_data_age3,

   mem_read_data_add3,   
   mem_read_data_age3
);   

   parameter   DW3 = 83;          // width of data busses3
   parameter   DD3 = 256;         // depth of RAM3

   input              pclk3;               // APB3 clock3                           
   input [7:0]        mem_addr_add3;       // hash3 address for R/W3 to memory     
   input              mem_write_add3;      // R/W3 flag3 (write = high3)            
   input [DW3-1:0]     mem_write_data_add3; // write data for memory             
   input [7:0]        mem_addr_age3;       // hash3 address for R/W3 to memory     
   input              mem_write_age3;      // R/W3 flag3 (write = high3)            
   input [DW3-1:0]     mem_write_data_age3; // write data for memory             

   output [DW3-1:0]    mem_read_data_add3;  // read data from mem                 
   output [DW3-1:0]    mem_read_data_age3;  // read data from mem  

   reg [DW3-1:0]       mem_core_array3[DD3-1:0]; // memory array               

   reg [DW3-1:0]       mem_read_data_add3;  // read data from mem                 
   reg [DW3-1:0]       mem_read_data_age3;  // read data from mem  


// -----------------------------------------------------------------------------
//   read and write control3 for address checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk3)
   begin
   if (~mem_write_add3) // read array
      mem_read_data_add3 <= mem_core_array3[mem_addr_add3];
   else
      mem_core_array3[mem_addr_add3] <= mem_write_data_add3;
   end

// -----------------------------------------------------------------------------
//   read and write control3 for age3 checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk3)
   begin
   if (~mem_write_age3) // read array
      mem_read_data_age3 <= mem_core_array3[mem_addr_age3];
   else
      mem_core_array3[mem_addr_age3] <= mem_write_data_age3;
   end


endmodule
