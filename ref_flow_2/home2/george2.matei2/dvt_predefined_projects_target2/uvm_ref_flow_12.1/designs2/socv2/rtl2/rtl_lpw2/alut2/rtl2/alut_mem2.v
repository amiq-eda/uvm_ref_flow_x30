//File2 name   : alut_mem2.v
//Title2       : 
//Created2     : 1999
//Description2 : 
//Notes2       : 
//----------------------------------------------------------------------
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------

module alut_mem2
(   
   // Inputs2
   pclk2,
   mem_addr_add2,
   mem_write_add2,
   mem_write_data_add2,
   mem_addr_age2,
   mem_write_age2,
   mem_write_data_age2,

   mem_read_data_add2,   
   mem_read_data_age2
);   

   parameter   DW2 = 83;          // width of data busses2
   parameter   DD2 = 256;         // depth of RAM2

   input              pclk2;               // APB2 clock2                           
   input [7:0]        mem_addr_add2;       // hash2 address for R/W2 to memory     
   input              mem_write_add2;      // R/W2 flag2 (write = high2)            
   input [DW2-1:0]     mem_write_data_add2; // write data for memory             
   input [7:0]        mem_addr_age2;       // hash2 address for R/W2 to memory     
   input              mem_write_age2;      // R/W2 flag2 (write = high2)            
   input [DW2-1:0]     mem_write_data_age2; // write data for memory             

   output [DW2-1:0]    mem_read_data_add2;  // read data from mem                 
   output [DW2-1:0]    mem_read_data_age2;  // read data from mem  

   reg [DW2-1:0]       mem_core_array2[DD2-1:0]; // memory array               

   reg [DW2-1:0]       mem_read_data_add2;  // read data from mem                 
   reg [DW2-1:0]       mem_read_data_age2;  // read data from mem  


// -----------------------------------------------------------------------------
//   read and write control2 for address checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk2)
   begin
   if (~mem_write_add2) // read array
      mem_read_data_add2 <= mem_core_array2[mem_addr_add2];
   else
      mem_core_array2[mem_addr_add2] <= mem_write_data_add2;
   end

// -----------------------------------------------------------------------------
//   read and write control2 for age2 checker access
// -----------------------------------------------------------------------------
always @ (posedge pclk2)
   begin
   if (~mem_write_age2) // read array
      mem_read_data_age2 <= mem_core_array2[mem_addr_age2];
   else
      mem_core_array2[mem_addr_age2] <= mem_write_data_age2;
   end


endmodule
