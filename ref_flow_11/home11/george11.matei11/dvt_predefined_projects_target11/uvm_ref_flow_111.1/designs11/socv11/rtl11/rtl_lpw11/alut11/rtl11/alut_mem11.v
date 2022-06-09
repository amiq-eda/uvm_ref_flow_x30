//File11 name   : alut_mem11.v
//Title11       : 
//Created11     : 1999
//Description11 : 
//Notes11       : 
//----------------------------------------------------------------------
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------

module alut_mem11
(   
   // Inputs11
   pclk11,
   mem_addr_add11,
   mem_write_add11,
   mem_write_data_add11,
   mem_addr_age11,
   mem_write_age11,
   mem_write_data_age11,

   mem_read_data_add11,   
   mem_read_data_age11
);   

   parameter   DW11 = 83;          // width of data busses11
   parameter   DD11 = 256;         // depth of RAM11

   input              pclk11;               // APB11 clock11                           
   input [7:0]        mem_addr_add11;       // hash11 address for R/W11 to memory     
   input              mem_write_add11;      // R/W11 flag11 (write = high11)            
   input [DW11-1:0]     mem_write_data_add11; // write data for memory             
   input [7:0]        mem_addr_age11;       // hash11 address for R/W11 to memory     
   input              mem_write_age11;      // R/W11 flag11 (write = high11)            
   input [DW11-1:0]     mem_write_data_age11; // write data for memory             

   output [DW11-1:0]    mem_read_data_add11;  // read data from mem                 
   output [DW11-1:0]    mem_read_data_age11;  // read data from mem  

   reg [DW11-1:0]       mem_core_array11[DD11-1:0]; // memory array               

   reg [DW11-1:0]       mem_read_data_add11;  // read data from mem                 
   reg [DW11-1:0]       mem_read_data_age11;  // read data from mem  


// -----------------------------------------------------------------------------
//   read and write control11 for address checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk11)
   begin
   if (~mem_write_add11) // read array
      mem_read_data_add11 <= mem_core_array11[mem_addr_add11];
   else
      mem_core_array11[mem_addr_add11] <= mem_write_data_add11;
   end

// -----------------------------------------------------------------------------
//   read and write control11 for age11 checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk11)
   begin
   if (~mem_write_age11) // read array
      mem_read_data_age11 <= mem_core_array11[mem_addr_age11];
   else
      mem_core_array11[mem_addr_age11] <= mem_write_data_age11;
   end


endmodule
