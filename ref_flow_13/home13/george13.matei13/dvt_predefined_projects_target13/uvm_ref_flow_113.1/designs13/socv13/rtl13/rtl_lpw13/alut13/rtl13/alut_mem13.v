//File13 name   : alut_mem13.v
//Title13       : 
//Created13     : 1999
//Description13 : 
//Notes13       : 
//----------------------------------------------------------------------
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------

module alut_mem13
(   
   // Inputs13
   pclk13,
   mem_addr_add13,
   mem_write_add13,
   mem_write_data_add13,
   mem_addr_age13,
   mem_write_age13,
   mem_write_data_age13,

   mem_read_data_add13,   
   mem_read_data_age13
);   

   parameter   DW13 = 83;          // width of data busses13
   parameter   DD13 = 256;         // depth of RAM13

   input              pclk13;               // APB13 clock13                           
   input [7:0]        mem_addr_add13;       // hash13 address for R/W13 to memory     
   input              mem_write_add13;      // R/W13 flag13 (write = high13)            
   input [DW13-1:0]     mem_write_data_add13; // write data for memory             
   input [7:0]        mem_addr_age13;       // hash13 address for R/W13 to memory     
   input              mem_write_age13;      // R/W13 flag13 (write = high13)            
   input [DW13-1:0]     mem_write_data_age13; // write data for memory             

   output [DW13-1:0]    mem_read_data_add13;  // read data from mem                 
   output [DW13-1:0]    mem_read_data_age13;  // read data from mem  

   reg [DW13-1:0]       mem_core_array13[DD13-1:0]; // memory array               

   reg [DW13-1:0]       mem_read_data_add13;  // read data from mem                 
   reg [DW13-1:0]       mem_read_data_age13;  // read data from mem  


// -----------------------------------------------------------------------------
//   read and write control13 for address checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk13)
   begin
   if (~mem_write_add13) // read array
      mem_read_data_add13 <= mem_core_array13[mem_addr_add13];
   else
      mem_core_array13[mem_addr_add13] <= mem_write_data_add13;
   end

// -----------------------------------------------------------------------------
//   read and write control13 for age13 checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk13)
   begin
   if (~mem_write_age13) // read array
      mem_read_data_age13 <= mem_core_array13[mem_addr_age13];
   else
      mem_core_array13[mem_addr_age13] <= mem_write_data_age13;
   end


endmodule
