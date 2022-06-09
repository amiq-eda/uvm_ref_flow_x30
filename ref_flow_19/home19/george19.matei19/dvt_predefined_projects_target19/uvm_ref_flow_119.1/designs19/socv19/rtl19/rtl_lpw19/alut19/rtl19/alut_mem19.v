//File19 name   : alut_mem19.v
//Title19       : 
//Created19     : 1999
//Description19 : 
//Notes19       : 
//----------------------------------------------------------------------
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------

module alut_mem19
(   
   // Inputs19
   pclk19,
   mem_addr_add19,
   mem_write_add19,
   mem_write_data_add19,
   mem_addr_age19,
   mem_write_age19,
   mem_write_data_age19,

   mem_read_data_add19,   
   mem_read_data_age19
);   

   parameter   DW19 = 83;          // width of data busses19
   parameter   DD19 = 256;         // depth of RAM19

   input              pclk19;               // APB19 clock19                           
   input [7:0]        mem_addr_add19;       // hash19 address for R/W19 to memory     
   input              mem_write_add19;      // R/W19 flag19 (write = high19)            
   input [DW19-1:0]     mem_write_data_add19; // write data for memory             
   input [7:0]        mem_addr_age19;       // hash19 address for R/W19 to memory     
   input              mem_write_age19;      // R/W19 flag19 (write = high19)            
   input [DW19-1:0]     mem_write_data_age19; // write data for memory             

   output [DW19-1:0]    mem_read_data_add19;  // read data from mem                 
   output [DW19-1:0]    mem_read_data_age19;  // read data from mem  

   reg [DW19-1:0]       mem_core_array19[DD19-1:0]; // memory array               

   reg [DW19-1:0]       mem_read_data_add19;  // read data from mem                 
   reg [DW19-1:0]       mem_read_data_age19;  // read data from mem  


// -----------------------------------------------------------------------------
//   read and write control19 for address checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk19)
   begin
   if (~mem_write_add19) // read array
      mem_read_data_add19 <= mem_core_array19[mem_addr_add19];
   else
      mem_core_array19[mem_addr_add19] <= mem_write_data_add19;
   end

// -----------------------------------------------------------------------------
//   read and write control19 for age19 checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk19)
   begin
   if (~mem_write_age19) // read array
      mem_read_data_age19 <= mem_core_array19[mem_addr_age19];
   else
      mem_core_array19[mem_addr_age19] <= mem_write_data_age19;
   end


endmodule
