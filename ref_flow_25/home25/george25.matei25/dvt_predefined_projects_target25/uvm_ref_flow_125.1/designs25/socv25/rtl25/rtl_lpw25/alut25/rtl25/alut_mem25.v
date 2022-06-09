//File25 name   : alut_mem25.v
//Title25       : 
//Created25     : 1999
//Description25 : 
//Notes25       : 
//----------------------------------------------------------------------
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------

module alut_mem25
(   
   // Inputs25
   pclk25,
   mem_addr_add25,
   mem_write_add25,
   mem_write_data_add25,
   mem_addr_age25,
   mem_write_age25,
   mem_write_data_age25,

   mem_read_data_add25,   
   mem_read_data_age25
);   

   parameter   DW25 = 83;          // width of data busses25
   parameter   DD25 = 256;         // depth of RAM25

   input              pclk25;               // APB25 clock25                           
   input [7:0]        mem_addr_add25;       // hash25 address for R/W25 to memory     
   input              mem_write_add25;      // R/W25 flag25 (write = high25)            
   input [DW25-1:0]     mem_write_data_add25; // write data for memory             
   input [7:0]        mem_addr_age25;       // hash25 address for R/W25 to memory     
   input              mem_write_age25;      // R/W25 flag25 (write = high25)            
   input [DW25-1:0]     mem_write_data_age25; // write data for memory             

   output [DW25-1:0]    mem_read_data_add25;  // read data from mem                 
   output [DW25-1:0]    mem_read_data_age25;  // read data from mem  

   reg [DW25-1:0]       mem_core_array25[DD25-1:0]; // memory array               

   reg [DW25-1:0]       mem_read_data_add25;  // read data from mem                 
   reg [DW25-1:0]       mem_read_data_age25;  // read data from mem  


// -----------------------------------------------------------------------------
//   read and write control25 for address checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk25)
   begin
   if (~mem_write_add25) // read array
      mem_read_data_add25 <= mem_core_array25[mem_addr_add25];
   else
      mem_core_array25[mem_addr_add25] <= mem_write_data_add25;
   end

// -----------------------------------------------------------------------------
//   read and write control25 for age25 checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk25)
   begin
   if (~mem_write_age25) // read array
      mem_read_data_age25 <= mem_core_array25[mem_addr_age25];
   else
      mem_core_array25[mem_addr_age25] <= mem_write_data_age25;
   end


endmodule
