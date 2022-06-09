//File7 name   : alut_mem7.v
//Title7       : 
//Created7     : 1999
//Description7 : 
//Notes7       : 
//----------------------------------------------------------------------
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------

module alut_mem7
(   
   // Inputs7
   pclk7,
   mem_addr_add7,
   mem_write_add7,
   mem_write_data_add7,
   mem_addr_age7,
   mem_write_age7,
   mem_write_data_age7,

   mem_read_data_add7,   
   mem_read_data_age7
);   

   parameter   DW7 = 83;          // width of data busses7
   parameter   DD7 = 256;         // depth of RAM7

   input              pclk7;               // APB7 clock7                           
   input [7:0]        mem_addr_add7;       // hash7 address for R/W7 to memory     
   input              mem_write_add7;      // R/W7 flag7 (write = high7)            
   input [DW7-1:0]     mem_write_data_add7; // write data for memory             
   input [7:0]        mem_addr_age7;       // hash7 address for R/W7 to memory     
   input              mem_write_age7;      // R/W7 flag7 (write = high7)            
   input [DW7-1:0]     mem_write_data_age7; // write data for memory             

   output [DW7-1:0]    mem_read_data_add7;  // read data from mem                 
   output [DW7-1:0]    mem_read_data_age7;  // read data from mem  

   reg [DW7-1:0]       mem_core_array7[DD7-1:0]; // memory array               

   reg [DW7-1:0]       mem_read_data_add7;  // read data from mem                 
   reg [DW7-1:0]       mem_read_data_age7;  // read data from mem  


// -----------------------------------------------------------------------------
//   read and write control7 for address checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk7)
   begin
   if (~mem_write_add7) // read array
      mem_read_data_add7 <= mem_core_array7[mem_addr_add7];
   else
      mem_core_array7[mem_addr_add7] <= mem_write_data_add7;
   end

// -----------------------------------------------------------------------------
//   read and write control7 for age7 checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk7)
   begin
   if (~mem_write_age7) // read array
      mem_read_data_age7 <= mem_core_array7[mem_addr_age7];
   else
      mem_core_array7[mem_addr_age7] <= mem_write_data_age7;
   end


endmodule
