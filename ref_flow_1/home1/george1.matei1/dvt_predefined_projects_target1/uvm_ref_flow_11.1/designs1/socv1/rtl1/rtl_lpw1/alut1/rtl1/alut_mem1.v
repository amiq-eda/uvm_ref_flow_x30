//File1 name   : alut_mem1.v
//Title1       : 
//Created1     : 1999
//Description1 : 
//Notes1       : 
//----------------------------------------------------------------------
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------

module alut_mem1
(   
   // Inputs1
   pclk1,
   mem_addr_add1,
   mem_write_add1,
   mem_write_data_add1,
   mem_addr_age1,
   mem_write_age1,
   mem_write_data_age1,

   mem_read_data_add1,   
   mem_read_data_age1
);   

   parameter   DW1 = 83;          // width of data busses1
   parameter   DD1 = 256;         // depth of RAM1

   input              pclk1;               // APB1 clock1                           
   input [7:0]        mem_addr_add1;       // hash1 address for R/W1 to memory     
   input              mem_write_add1;      // R/W1 flag1 (write = high1)            
   input [DW1-1:0]     mem_write_data_add1; // write data for memory             
   input [7:0]        mem_addr_age1;       // hash1 address for R/W1 to memory     
   input              mem_write_age1;      // R/W1 flag1 (write = high1)            
   input [DW1-1:0]     mem_write_data_age1; // write data for memory             

   output [DW1-1:0]    mem_read_data_add1;  // read data from mem                 
   output [DW1-1:0]    mem_read_data_age1;  // read data from mem  

   reg [DW1-1:0]       mem_core_array1[DD1-1:0]; // memory array               

   reg [DW1-1:0]       mem_read_data_add1;  // read data from mem                 
   reg [DW1-1:0]       mem_read_data_age1;  // read data from mem  


// -----------------------------------------------------------------------------
//   read and write control1 for address checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk1)
   begin
   if (~mem_write_add1) // read array
      mem_read_data_add1 <= mem_core_array1[mem_addr_add1];
   else
      mem_core_array1[mem_addr_add1] <= mem_write_data_add1;
   end

// -----------------------------------------------------------------------------
//   read and write control1 for age1 checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk1)
   begin
   if (~mem_write_age1) // read array
      mem_read_data_age1 <= mem_core_array1[mem_addr_age1];
   else
      mem_core_array1[mem_addr_age1] <= mem_write_data_age1;
   end


endmodule
