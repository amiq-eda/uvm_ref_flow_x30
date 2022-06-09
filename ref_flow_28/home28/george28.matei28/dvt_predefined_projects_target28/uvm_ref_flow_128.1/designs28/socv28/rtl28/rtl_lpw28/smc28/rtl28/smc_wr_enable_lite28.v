//File28 name   : smc_wr_enable_lite28.v
//Title28       : 
//Created28     : 1999
//Description28 : 
//Notes28       : 
//----------------------------------------------------------------------
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


  module smc_wr_enable_lite28 (

                      //inputs28                      

                      n_sys_reset28,
                      r_full28,
                      n_r_we28,
                      n_r_wr28,

                      //outputs28

                      smc_n_we28,
                      smc_n_wr28);

//I28/O28
   
   input             n_sys_reset28;   //system reset
   input             r_full28;    // Full cycle write strobe28
   input [3:0]       n_r_we28;    //write enable from smc_strobe28
   input             n_r_wr28;    //write strobe28 from smc_strobe28
   output [3:0]      smc_n_we28;  // write enable (active low28)
   output            smc_n_wr28;  // write strobe28 (active low28)
   
   
//output reg declaration28.
   
   reg [3:0]          smc_n_we28;
   reg                smc_n_wr28;

//----------------------------------------------------------------------
// negedge strobes28 with clock28.
//----------------------------------------------------------------------
      

//----------------------------------------------------------------------
      
//--------------------------------------------------------------------
// Gate28 Write strobes28 with clock28.
//--------------------------------------------------------------------

  always @(r_full28 or n_r_we28)
  
  begin
  
     smc_n_we28[0] = ((~r_full28  ) | n_r_we28[0] );

     smc_n_we28[1] = ((~r_full28  ) | n_r_we28[1] );

     smc_n_we28[2] = ((~r_full28  ) | n_r_we28[2] );

     smc_n_we28[3] = ((~r_full28  ) | n_r_we28[3] );

  
  end

//--------------------------------------------------------------------   
//write strobe28 generation28
//--------------------------------------------------------------------   

  always @(n_r_wr28 or r_full28 )
  
     begin
  
        smc_n_wr28 = ((~r_full28 ) | n_r_wr28 );
       
     end

endmodule // smc_wr_enable28

