//File24 name   : alut_mem24.v
//Title24       : 
//Created24     : 1999
//Description24 : 
//Notes24       : 
//----------------------------------------------------------------------
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------

module alut_mem24
(   
   // Inputs24
   pclk24,
   mem_addr_add24,
   mem_write_add24,
   mem_write_data_add24,
   mem_addr_age24,
   mem_write_age24,
   mem_write_data_age24,

   mem_read_data_add24,   
   mem_read_data_age24
);   

   parameter   DW24 = 83;          // width of data busses24
   parameter   DD24 = 256;         // depth of RAM24

   input              pclk24;               // APB24 clock24                           
   input [7:0]        mem_addr_add24;       // hash24 address for R/W24 to memory     
   input              mem_write_add24;      // R/W24 flag24 (write = high24)            
   input [DW24-1:0]     mem_write_data_add24; // write data for memory             
   input [7:0]        mem_addr_age24;       // hash24 address for R/W24 to memory     
   input              mem_write_age24;      // R/W24 flag24 (write = high24)            
   input [DW24-1:0]     mem_write_data_age24; // write data for memory             

   output [DW24-1:0]    mem_read_data_add24;  // read data from mem                 
   output [DW24-1:0]    mem_read_data_age24;  // read data from mem  

   reg [DW24-1:0]       mem_core_array24[DD24-1:0]; // memory array               

   reg [DW24-1:0]       mem_read_data_add24;  // read data from mem                 
   reg [DW24-1:0]       mem_read_data_age24;  // read data from mem  


// -----------------------------------------------------------------------------
//   read and write control24 for address checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk24)
   begin
   if (~mem_write_add24) // read array
      mem_read_data_add24 <= mem_core_array24[mem_addr_add24];
   else
      mem_core_array24[mem_addr_add24] <= mem_write_data_add24;
   end

// -----------------------------------------------------------------------------
//   read and write control24 for age24 checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk24)
   begin
   if (~mem_write_age24) // read array
      mem_read_data_age24 <= mem_core_array24[mem_addr_age24];
   else
      mem_core_array24[mem_addr_age24] <= mem_write_data_age24;
   end


endmodule
