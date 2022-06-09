//File20 name   : smc_wr_enable_lite20.v
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


  module smc_wr_enable_lite20 (

                      //inputs20                      

                      n_sys_reset20,
                      r_full20,
                      n_r_we20,
                      n_r_wr20,

                      //outputs20

                      smc_n_we20,
                      smc_n_wr20);

//I20/O20
   
   input             n_sys_reset20;   //system reset
   input             r_full20;    // Full cycle write strobe20
   input [3:0]       n_r_we20;    //write enable from smc_strobe20
   input             n_r_wr20;    //write strobe20 from smc_strobe20
   output [3:0]      smc_n_we20;  // write enable (active low20)
   output            smc_n_wr20;  // write strobe20 (active low20)
   
   
//output reg declaration20.
   
   reg [3:0]          smc_n_we20;
   reg                smc_n_wr20;

//----------------------------------------------------------------------
// negedge strobes20 with clock20.
//----------------------------------------------------------------------
      

//----------------------------------------------------------------------
      
//--------------------------------------------------------------------
// Gate20 Write strobes20 with clock20.
//--------------------------------------------------------------------

  always @(r_full20 or n_r_we20)
  
  begin
  
     smc_n_we20[0] = ((~r_full20  ) | n_r_we20[0] );

     smc_n_we20[1] = ((~r_full20  ) | n_r_we20[1] );

     smc_n_we20[2] = ((~r_full20  ) | n_r_we20[2] );

     smc_n_we20[3] = ((~r_full20  ) | n_r_we20[3] );

  
  end

//--------------------------------------------------------------------   
//write strobe20 generation20
//--------------------------------------------------------------------   

  always @(n_r_wr20 or r_full20 )
  
     begin
  
        smc_n_wr20 = ((~r_full20 ) | n_r_wr20 );
       
     end

endmodule // smc_wr_enable20

