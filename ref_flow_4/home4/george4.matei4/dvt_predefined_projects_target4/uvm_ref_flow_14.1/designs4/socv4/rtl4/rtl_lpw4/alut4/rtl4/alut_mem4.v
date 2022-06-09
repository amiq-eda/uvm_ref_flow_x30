//File4 name   : alut_mem4.v
//Title4       : 
//Created4     : 1999
//Description4 : 
//Notes4       : 
//----------------------------------------------------------------------
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------

module alut_mem4
(   
   // Inputs4
   pclk4,
   mem_addr_add4,
   mem_write_add4,
   mem_write_data_add4,
   mem_addr_age4,
   mem_write_age4,
   mem_write_data_age4,

   mem_read_data_add4,   
   mem_read_data_age4
);   

   parameter   DW4 = 83;          // width of data busses4
   parameter   DD4 = 256;         // depth of RAM4

   input              pclk4;               // APB4 clock4                           
   input [7:0]        mem_addr_add4;       // hash4 address for R/W4 to memory     
   input              mem_write_add4;      // R/W4 flag4 (write = high4)            
   input [DW4-1:0]     mem_write_data_add4; // write data for memory             
   input [7:0]        mem_addr_age4;       // hash4 address for R/W4 to memory     
   input              mem_write_age4;      // R/W4 flag4 (write = high4)            
   input [DW4-1:0]     mem_write_data_age4; // write data for memory             

   output [DW4-1:0]    mem_read_data_add4;  // read data from mem                 
   output [DW4-1:0]    mem_read_data_age4;  // read data from mem  

   reg [DW4-1:0]       mem_core_array4[DD4-1:0]; // memory array               

   reg [DW4-1:0]       mem_read_data_add4;  // read data from mem                 
   reg [DW4-1:0]       mem_read_data_age4;  // read data from mem  


// -----------------------------------------------------------------------------
//   read and write control4 for address checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk4)
   begin
   if (~mem_write_add4) // read array
      mem_read_data_add4 <= mem_core_array4[mem_addr_add4];
   else
      mem_core_array4[mem_addr_add4] <= mem_write_data_add4;
   end

// -----------------------------------------------------------------------------
//   read and write control4 for age4 checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk4)
   begin
   if (~mem_write_age4) // read array
      mem_read_data_age4 <= mem_core_array4[mem_addr_age4];
   else
      mem_core_array4[mem_addr_age4] <= mem_write_data_age4;
   end


endmodule
