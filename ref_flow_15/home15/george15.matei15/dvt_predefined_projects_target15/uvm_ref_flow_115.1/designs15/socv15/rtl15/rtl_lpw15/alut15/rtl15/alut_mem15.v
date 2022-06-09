//File15 name   : alut_mem15.v
//Title15       : 
//Created15     : 1999
//Description15 : 
//Notes15       : 
//----------------------------------------------------------------------
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------

module alut_mem15
(   
   // Inputs15
   pclk15,
   mem_addr_add15,
   mem_write_add15,
   mem_write_data_add15,
   mem_addr_age15,
   mem_write_age15,
   mem_write_data_age15,

   mem_read_data_add15,   
   mem_read_data_age15
);   

   parameter   DW15 = 83;          // width of data busses15
   parameter   DD15 = 256;         // depth of RAM15

   input              pclk15;               // APB15 clock15                           
   input [7:0]        mem_addr_add15;       // hash15 address for R/W15 to memory     
   input              mem_write_add15;      // R/W15 flag15 (write = high15)            
   input [DW15-1:0]     mem_write_data_add15; // write data for memory             
   input [7:0]        mem_addr_age15;       // hash15 address for R/W15 to memory     
   input              mem_write_age15;      // R/W15 flag15 (write = high15)            
   input [DW15-1:0]     mem_write_data_age15; // write data for memory             

   output [DW15-1:0]    mem_read_data_add15;  // read data from mem                 
   output [DW15-1:0]    mem_read_data_age15;  // read data from mem  

   reg [DW15-1:0]       mem_core_array15[DD15-1:0]; // memory array               

   reg [DW15-1:0]       mem_read_data_add15;  // read data from mem                 
   reg [DW15-1:0]       mem_read_data_age15;  // read data from mem  


// -----------------------------------------------------------------------------
//   read and write control15 for address checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk15)
   begin
   if (~mem_write_add15) // read array
      mem_read_data_add15 <= mem_core_array15[mem_addr_add15];
   else
      mem_core_array15[mem_addr_add15] <= mem_write_data_add15;
   end

// -----------------------------------------------------------------------------
//   read and write control15 for age15 checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk15)
   begin
   if (~mem_write_age15) // read array
      mem_read_data_age15 <= mem_core_array15[mem_addr_age15];
   else
      mem_core_array15[mem_addr_age15] <= mem_write_data_age15;
   end


endmodule
