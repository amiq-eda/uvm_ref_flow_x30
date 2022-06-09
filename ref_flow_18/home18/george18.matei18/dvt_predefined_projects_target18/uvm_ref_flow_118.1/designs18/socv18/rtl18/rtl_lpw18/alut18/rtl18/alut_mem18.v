//File18 name   : alut_mem18.v
//Title18       : 
//Created18     : 1999
//Description18 : 
//Notes18       : 
//----------------------------------------------------------------------
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------

module alut_mem18
(   
   // Inputs18
   pclk18,
   mem_addr_add18,
   mem_write_add18,
   mem_write_data_add18,
   mem_addr_age18,
   mem_write_age18,
   mem_write_data_age18,

   mem_read_data_add18,   
   mem_read_data_age18
);   

   parameter   DW18 = 83;          // width of data busses18
   parameter   DD18 = 256;         // depth of RAM18

   input              pclk18;               // APB18 clock18                           
   input [7:0]        mem_addr_add18;       // hash18 address for R/W18 to memory     
   input              mem_write_add18;      // R/W18 flag18 (write = high18)            
   input [DW18-1:0]     mem_write_data_add18; // write data for memory             
   input [7:0]        mem_addr_age18;       // hash18 address for R/W18 to memory     
   input              mem_write_age18;      // R/W18 flag18 (write = high18)            
   input [DW18-1:0]     mem_write_data_age18; // write data for memory             

   output [DW18-1:0]    mem_read_data_add18;  // read data from mem                 
   output [DW18-1:0]    mem_read_data_age18;  // read data from mem  

   reg [DW18-1:0]       mem_core_array18[DD18-1:0]; // memory array               

   reg [DW18-1:0]       mem_read_data_add18;  // read data from mem                 
   reg [DW18-1:0]       mem_read_data_age18;  // read data from mem  


// -----------------------------------------------------------------------------
//   read and write control18 for address checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk18)
   begin
   if (~mem_write_add18) // read array
      mem_read_data_add18 <= mem_core_array18[mem_addr_add18];
   else
      mem_core_array18[mem_addr_add18] <= mem_write_data_add18;
   end

// -----------------------------------------------------------------------------
//   read and write control18 for age18 checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk18)
   begin
   if (~mem_write_age18) // read array
      mem_read_data_age18 <= mem_core_array18[mem_addr_age18];
   else
      mem_core_array18[mem_addr_age18] <= mem_write_data_age18;
   end


endmodule
