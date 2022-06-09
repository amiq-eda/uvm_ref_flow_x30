//File9 name   : smc_wr_enable_lite9.v
//Title9       : 
//Created9     : 1999
//Description9 : 
//Notes9       : 
//----------------------------------------------------------------------
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


  module smc_wr_enable_lite9 (

                      //inputs9                      

                      n_sys_reset9,
                      r_full9,
                      n_r_we9,
                      n_r_wr9,

                      //outputs9

                      smc_n_we9,
                      smc_n_wr9);

//I9/O9
   
   input             n_sys_reset9;   //system reset
   input             r_full9;    // Full cycle write strobe9
   input [3:0]       n_r_we9;    //write enable from smc_strobe9
   input             n_r_wr9;    //write strobe9 from smc_strobe9
   output [3:0]      smc_n_we9;  // write enable (active low9)
   output            smc_n_wr9;  // write strobe9 (active low9)
   
   
//output reg declaration9.
   
   reg [3:0]          smc_n_we9;
   reg                smc_n_wr9;

//----------------------------------------------------------------------
// negedge strobes9 with clock9.
//----------------------------------------------------------------------
      

//----------------------------------------------------------------------
      
//--------------------------------------------------------------------
// Gate9 Write strobes9 with clock9.
//--------------------------------------------------------------------

  always @(r_full9 or n_r_we9)
  
  begin
  
     smc_n_we9[0] = ((~r_full9  ) | n_r_we9[0] );

     smc_n_we9[1] = ((~r_full9  ) | n_r_we9[1] );

     smc_n_we9[2] = ((~r_full9  ) | n_r_we9[2] );

     smc_n_we9[3] = ((~r_full9  ) | n_r_we9[3] );

  
  end

//--------------------------------------------------------------------   
//write strobe9 generation9
//--------------------------------------------------------------------   

  always @(n_r_wr9 or r_full9 )
  
     begin
  
        smc_n_wr9 = ((~r_full9 ) | n_r_wr9 );
       
     end

endmodule // smc_wr_enable9

