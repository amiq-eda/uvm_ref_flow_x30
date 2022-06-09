//File21 name   : smc_wr_enable_lite21.v
//Title21       : 
//Created21     : 1999
//Description21 : 
//Notes21       : 
//----------------------------------------------------------------------
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


  module smc_wr_enable_lite21 (

                      //inputs21                      

                      n_sys_reset21,
                      r_full21,
                      n_r_we21,
                      n_r_wr21,

                      //outputs21

                      smc_n_we21,
                      smc_n_wr21);

//I21/O21
   
   input             n_sys_reset21;   //system reset
   input             r_full21;    // Full cycle write strobe21
   input [3:0]       n_r_we21;    //write enable from smc_strobe21
   input             n_r_wr21;    //write strobe21 from smc_strobe21
   output [3:0]      smc_n_we21;  // write enable (active low21)
   output            smc_n_wr21;  // write strobe21 (active low21)
   
   
//output reg declaration21.
   
   reg [3:0]          smc_n_we21;
   reg                smc_n_wr21;

//----------------------------------------------------------------------
// negedge strobes21 with clock21.
//----------------------------------------------------------------------
      

//----------------------------------------------------------------------
      
//--------------------------------------------------------------------
// Gate21 Write strobes21 with clock21.
//--------------------------------------------------------------------

  always @(r_full21 or n_r_we21)
  
  begin
  
     smc_n_we21[0] = ((~r_full21  ) | n_r_we21[0] );

     smc_n_we21[1] = ((~r_full21  ) | n_r_we21[1] );

     smc_n_we21[2] = ((~r_full21  ) | n_r_we21[2] );

     smc_n_we21[3] = ((~r_full21  ) | n_r_we21[3] );

  
  end

//--------------------------------------------------------------------   
//write strobe21 generation21
//--------------------------------------------------------------------   

  always @(n_r_wr21 or r_full21 )
  
     begin
  
        smc_n_wr21 = ((~r_full21 ) | n_r_wr21 );
       
     end

endmodule // smc_wr_enable21

