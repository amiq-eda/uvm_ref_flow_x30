//File22 name   : alut_mem22.v
//Title22       : 
//Created22     : 1999
//Description22 : 
//Notes22       : 
//----------------------------------------------------------------------
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------

module alut_mem22
(   
   // Inputs22
   pclk22,
   mem_addr_add22,
   mem_write_add22,
   mem_write_data_add22,
   mem_addr_age22,
   mem_write_age22,
   mem_write_data_age22,

   mem_read_data_add22,   
   mem_read_data_age22
);   

   parameter   DW22 = 83;          // width of data busses22
   parameter   DD22 = 256;         // depth of RAM22

   input              pclk22;               // APB22 clock22                           
   input [7:0]        mem_addr_add22;       // hash22 address for R/W22 to memory     
   input              mem_write_add22;      // R/W22 flag22 (write = high22)            
   input [DW22-1:0]     mem_write_data_add22; // write data for memory             
   input [7:0]        mem_addr_age22;       // hash22 address for R/W22 to memory     
   input              mem_write_age22;      // R/W22 flag22 (write = high22)            
   input [DW22-1:0]     mem_write_data_age22; // write data for memory             

   output [DW22-1:0]    mem_read_data_add22;  // read data from mem                 
   output [DW22-1:0]    mem_read_data_age22;  // read data from mem  

   reg [DW22-1:0]       mem_core_array22[DD22-1:0]; // memory array               

   reg [DW22-1:0]       mem_read_data_add22;  // read data from mem                 
   reg [DW22-1:0]       mem_read_data_age22;  // read data from mem  


// -----------------------------------------------------------------------------
//   read and write control22 for address checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk22)
   begin
   if (~mem_write_add22) // read array
      mem_read_data_add22 <= mem_core_array22[mem_addr_add22];
   else
      mem_core_array22[mem_addr_add22] <= mem_write_data_add22;
   end

// -----------------------------------------------------------------------------
//   read and write control22 for age22 checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk22)
   begin
   if (~mem_write_age22) // read array
      mem_read_data_age22 <= mem_core_array22[mem_addr_age22];
   else
      mem_core_array22[mem_addr_age22] <= mem_write_data_age22;
   end


endmodule
