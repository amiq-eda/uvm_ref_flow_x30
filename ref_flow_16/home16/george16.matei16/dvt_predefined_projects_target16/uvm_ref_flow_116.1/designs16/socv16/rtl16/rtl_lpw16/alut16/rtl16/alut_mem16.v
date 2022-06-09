//File16 name   : alut_mem16.v
//Title16       : 
//Created16     : 1999
//Description16 : 
//Notes16       : 
//----------------------------------------------------------------------
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------

module alut_mem16
(   
   // Inputs16
   pclk16,
   mem_addr_add16,
   mem_write_add16,
   mem_write_data_add16,
   mem_addr_age16,
   mem_write_age16,
   mem_write_data_age16,

   mem_read_data_add16,   
   mem_read_data_age16
);   

   parameter   DW16 = 83;          // width of data busses16
   parameter   DD16 = 256;         // depth of RAM16

   input              pclk16;               // APB16 clock16                           
   input [7:0]        mem_addr_add16;       // hash16 address for R/W16 to memory     
   input              mem_write_add16;      // R/W16 flag16 (write = high16)            
   input [DW16-1:0]     mem_write_data_add16; // write data for memory             
   input [7:0]        mem_addr_age16;       // hash16 address for R/W16 to memory     
   input              mem_write_age16;      // R/W16 flag16 (write = high16)            
   input [DW16-1:0]     mem_write_data_age16; // write data for memory             

   output [DW16-1:0]    mem_read_data_add16;  // read data from mem                 
   output [DW16-1:0]    mem_read_data_age16;  // read data from mem  

   reg [DW16-1:0]       mem_core_array16[DD16-1:0]; // memory array               

   reg [DW16-1:0]       mem_read_data_add16;  // read data from mem                 
   reg [DW16-1:0]       mem_read_data_age16;  // read data from mem  


// -----------------------------------------------------------------------------
//   read and write control16 for address checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk16)
   begin
   if (~mem_write_add16) // read array
      mem_read_data_add16 <= mem_core_array16[mem_addr_add16];
   else
      mem_core_array16[mem_addr_add16] <= mem_write_data_add16;
   end

// -----------------------------------------------------------------------------
//   read and write control16 for age16 checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk16)
   begin
   if (~mem_write_age16) // read array
      mem_read_data_age16 <= mem_core_array16[mem_addr_age16];
   else
      mem_core_array16[mem_addr_age16] <= mem_write_data_age16;
   end


endmodule
