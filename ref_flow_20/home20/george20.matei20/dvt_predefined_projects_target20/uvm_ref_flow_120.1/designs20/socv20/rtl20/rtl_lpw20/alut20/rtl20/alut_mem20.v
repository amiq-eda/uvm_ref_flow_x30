//File20 name   : alut_mem20.v
//Title20       : 
//Created20     : 1999
//Description20 : 
//Notes20       : 
//----------------------------------------------------------------------
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------

module alut_mem20
(   
   // Inputs20
   pclk20,
   mem_addr_add20,
   mem_write_add20,
   mem_write_data_add20,
   mem_addr_age20,
   mem_write_age20,
   mem_write_data_age20,

   mem_read_data_add20,   
   mem_read_data_age20
);   

   parameter   DW20 = 83;          // width of data busses20
   parameter   DD20 = 256;         // depth of RAM20

   input              pclk20;               // APB20 clock20                           
   input [7:0]        mem_addr_add20;       // hash20 address for R/W20 to memory     
   input              mem_write_add20;      // R/W20 flag20 (write = high20)            
   input [DW20-1:0]     mem_write_data_add20; // write data for memory             
   input [7:0]        mem_addr_age20;       // hash20 address for R/W20 to memory     
   input              mem_write_age20;      // R/W20 flag20 (write = high20)            
   input [DW20-1:0]     mem_write_data_age20; // write data for memory             

   output [DW20-1:0]    mem_read_data_add20;  // read data from mem                 
   output [DW20-1:0]    mem_read_data_age20;  // read data from mem  

   reg [DW20-1:0]       mem_core_array20[DD20-1:0]; // memory array               

   reg [DW20-1:0]       mem_read_data_add20;  // read data from mem                 
   reg [DW20-1:0]       mem_read_data_age20;  // read data from mem  


// -----------------------------------------------------------------------------
//   read and write control20 for address checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk20)
   begin
   if (~mem_write_add20) // read array
      mem_read_data_add20 <= mem_core_array20[mem_addr_add20];
   else
      mem_core_array20[mem_addr_add20] <= mem_write_data_add20;
   end

// -----------------------------------------------------------------------------
//   read and write control20 for age20 checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk20)
   begin
   if (~mem_write_age20) // read array
      mem_read_data_age20 <= mem_core_array20[mem_addr_age20];
   else
      mem_core_array20[mem_addr_age20] <= mem_write_data_age20;
   end


endmodule
