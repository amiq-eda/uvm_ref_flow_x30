//File14 name   : alut_mem14.v
//Title14       : 
//Created14     : 1999
//Description14 : 
//Notes14       : 
//----------------------------------------------------------------------
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------

module alut_mem14
(   
   // Inputs14
   pclk14,
   mem_addr_add14,
   mem_write_add14,
   mem_write_data_add14,
   mem_addr_age14,
   mem_write_age14,
   mem_write_data_age14,

   mem_read_data_add14,   
   mem_read_data_age14
);   

   parameter   DW14 = 83;          // width of data busses14
   parameter   DD14 = 256;         // depth of RAM14

   input              pclk14;               // APB14 clock14                           
   input [7:0]        mem_addr_add14;       // hash14 address for R/W14 to memory     
   input              mem_write_add14;      // R/W14 flag14 (write = high14)            
   input [DW14-1:0]     mem_write_data_add14; // write data for memory             
   input [7:0]        mem_addr_age14;       // hash14 address for R/W14 to memory     
   input              mem_write_age14;      // R/W14 flag14 (write = high14)            
   input [DW14-1:0]     mem_write_data_age14; // write data for memory             

   output [DW14-1:0]    mem_read_data_add14;  // read data from mem                 
   output [DW14-1:0]    mem_read_data_age14;  // read data from mem  

   reg [DW14-1:0]       mem_core_array14[DD14-1:0]; // memory array               

   reg [DW14-1:0]       mem_read_data_add14;  // read data from mem                 
   reg [DW14-1:0]       mem_read_data_age14;  // read data from mem  


// -----------------------------------------------------------------------------
//   read and write control14 for address checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk14)
   begin
   if (~mem_write_add14) // read array
      mem_read_data_add14 <= mem_core_array14[mem_addr_add14];
   else
      mem_core_array14[mem_addr_add14] <= mem_write_data_add14;
   end

// -----------------------------------------------------------------------------
//   read and write control14 for age14 checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk14)
   begin
   if (~mem_write_age14) // read array
      mem_read_data_age14 <= mem_core_array14[mem_addr_age14];
   else
      mem_core_array14[mem_addr_age14] <= mem_write_data_age14;
   end


endmodule
