//File8 name   : alut_mem8.v
//Title8       : 
//Created8     : 1999
//Description8 : 
//Notes8       : 
//----------------------------------------------------------------------
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------

module alut_mem8
(   
   // Inputs8
   pclk8,
   mem_addr_add8,
   mem_write_add8,
   mem_write_data_add8,
   mem_addr_age8,
   mem_write_age8,
   mem_write_data_age8,

   mem_read_data_add8,   
   mem_read_data_age8
);   

   parameter   DW8 = 83;          // width of data busses8
   parameter   DD8 = 256;         // depth of RAM8

   input              pclk8;               // APB8 clock8                           
   input [7:0]        mem_addr_add8;       // hash8 address for R/W8 to memory     
   input              mem_write_add8;      // R/W8 flag8 (write = high8)            
   input [DW8-1:0]     mem_write_data_add8; // write data for memory             
   input [7:0]        mem_addr_age8;       // hash8 address for R/W8 to memory     
   input              mem_write_age8;      // R/W8 flag8 (write = high8)            
   input [DW8-1:0]     mem_write_data_age8; // write data for memory             

   output [DW8-1:0]    mem_read_data_add8;  // read data from mem                 
   output [DW8-1:0]    mem_read_data_age8;  // read data from mem  

   reg [DW8-1:0]       mem_core_array8[DD8-1:0]; // memory array               

   reg [DW8-1:0]       mem_read_data_add8;  // read data from mem                 
   reg [DW8-1:0]       mem_read_data_age8;  // read data from mem  


// -----------------------------------------------------------------------------
//   read and write control8 for address checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk8)
   begin
   if (~mem_write_add8) // read array
      mem_read_data_add8 <= mem_core_array8[mem_addr_add8];
   else
      mem_core_array8[mem_addr_add8] <= mem_write_data_add8;
   end

// -----------------------------------------------------------------------------
//   read and write control8 for age8 checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk8)
   begin
   if (~mem_write_age8) // read array
      mem_read_data_age8 <= mem_core_array8[mem_addr_age8];
   else
      mem_core_array8[mem_addr_age8] <= mem_write_data_age8;
   end


endmodule
