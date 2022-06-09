//File27 name   : smc_wr_enable_lite27.v
//Title27       : 
//Created27     : 1999
//Description27 : 
//Notes27       : 
//----------------------------------------------------------------------
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


  module smc_wr_enable_lite27 (

                      //inputs27                      

                      n_sys_reset27,
                      r_full27,
                      n_r_we27,
                      n_r_wr27,

                      //outputs27

                      smc_n_we27,
                      smc_n_wr27);

//I27/O27
   
   input             n_sys_reset27;   //system reset
   input             r_full27;    // Full cycle write strobe27
   input [3:0]       n_r_we27;    //write enable from smc_strobe27
   input             n_r_wr27;    //write strobe27 from smc_strobe27
   output [3:0]      smc_n_we27;  // write enable (active low27)
   output            smc_n_wr27;  // write strobe27 (active low27)
   
   
//output reg declaration27.
   
   reg [3:0]          smc_n_we27;
   reg                smc_n_wr27;

//----------------------------------------------------------------------
// negedge strobes27 with clock27.
//----------------------------------------------------------------------
      

//----------------------------------------------------------------------
      
//--------------------------------------------------------------------
// Gate27 Write strobes27 with clock27.
//--------------------------------------------------------------------

  always @(r_full27 or n_r_we27)
  
  begin
  
     smc_n_we27[0] = ((~r_full27  ) | n_r_we27[0] );

     smc_n_we27[1] = ((~r_full27  ) | n_r_we27[1] );

     smc_n_we27[2] = ((~r_full27  ) | n_r_we27[2] );

     smc_n_we27[3] = ((~r_full27  ) | n_r_we27[3] );

  
  end

//--------------------------------------------------------------------   
//write strobe27 generation27
//--------------------------------------------------------------------   

  always @(n_r_wr27 or r_full27 )
  
     begin
  
        smc_n_wr27 = ((~r_full27 ) | n_r_wr27 );
       
     end

endmodule // smc_wr_enable27

