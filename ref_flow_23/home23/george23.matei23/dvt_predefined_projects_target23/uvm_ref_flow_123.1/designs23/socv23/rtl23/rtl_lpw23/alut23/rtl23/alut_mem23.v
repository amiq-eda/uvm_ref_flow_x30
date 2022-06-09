//File23 name   : alut_mem23.v
//Title23       : 
//Created23     : 1999
//Description23 : 
//Notes23       : 
//----------------------------------------------------------------------
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------

module alut_mem23
(   
   // Inputs23
   pclk23,
   mem_addr_add23,
   mem_write_add23,
   mem_write_data_add23,
   mem_addr_age23,
   mem_write_age23,
   mem_write_data_age23,

   mem_read_data_add23,   
   mem_read_data_age23
);   

   parameter   DW23 = 83;          // width of data busses23
   parameter   DD23 = 256;         // depth of RAM23

   input              pclk23;               // APB23 clock23                           
   input [7:0]        mem_addr_add23;       // hash23 address for R/W23 to memory     
   input              mem_write_add23;      // R/W23 flag23 (write = high23)            
   input [DW23-1:0]     mem_write_data_add23; // write data for memory             
   input [7:0]        mem_addr_age23;       // hash23 address for R/W23 to memory     
   input              mem_write_age23;      // R/W23 flag23 (write = high23)            
   input [DW23-1:0]     mem_write_data_age23; // write data for memory             

   output [DW23-1:0]    mem_read_data_add23;  // read data from mem                 
   output [DW23-1:0]    mem_read_data_age23;  // read data from mem  

   reg [DW23-1:0]       mem_core_array23[DD23-1:0]; // memory array               

   reg [DW23-1:0]       mem_read_data_add23;  // read data from mem                 
   reg [DW23-1:0]       mem_read_data_age23;  // read data from mem  


// -----------------------------------------------------------------------------
//   read and write control23 for address checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk23)
   begin
   if (~mem_write_add23) // read array
      mem_read_data_add23 <= mem_core_array23[mem_addr_add23];
   else
      mem_core_array23[mem_addr_add23] <= mem_write_data_add23;
   end

// -----------------------------------------------------------------------------
//   read and write control23 for age23 checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk23)
   begin
   if (~mem_write_age23) // read array
      mem_read_data_age23 <= mem_core_array23[mem_addr_age23];
   else
      mem_core_array23[mem_addr_age23] <= mem_write_data_age23;
   end


endmodule
