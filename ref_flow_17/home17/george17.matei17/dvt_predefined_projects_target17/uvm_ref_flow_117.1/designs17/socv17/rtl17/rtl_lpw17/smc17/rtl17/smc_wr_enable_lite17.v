//File17 name   : smc_wr_enable_lite17.v
//Title17       : 
//Created17     : 1999
//Description17 : 
//Notes17       : 
//----------------------------------------------------------------------
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


  module smc_wr_enable_lite17 (

                      //inputs17                      

                      n_sys_reset17,
                      r_full17,
                      n_r_we17,
                      n_r_wr17,

                      //outputs17

                      smc_n_we17,
                      smc_n_wr17);

//I17/O17
   
   input             n_sys_reset17;   //system reset
   input             r_full17;    // Full cycle write strobe17
   input [3:0]       n_r_we17;    //write enable from smc_strobe17
   input             n_r_wr17;    //write strobe17 from smc_strobe17
   output [3:0]      smc_n_we17;  // write enable (active low17)
   output            smc_n_wr17;  // write strobe17 (active low17)
   
   
//output reg declaration17.
   
   reg [3:0]          smc_n_we17;
   reg                smc_n_wr17;

//----------------------------------------------------------------------
// negedge strobes17 with clock17.
//----------------------------------------------------------------------
      

//----------------------------------------------------------------------
      
//--------------------------------------------------------------------
// Gate17 Write strobes17 with clock17.
//--------------------------------------------------------------------

  always @(r_full17 or n_r_we17)
  
  begin
  
     smc_n_we17[0] = ((~r_full17  ) | n_r_we17[0] );

     smc_n_we17[1] = ((~r_full17  ) | n_r_we17[1] );

     smc_n_we17[2] = ((~r_full17  ) | n_r_we17[2] );

     smc_n_we17[3] = ((~r_full17  ) | n_r_we17[3] );

  
  end

//--------------------------------------------------------------------   
//write strobe17 generation17
//--------------------------------------------------------------------   

  always @(n_r_wr17 or r_full17 )
  
     begin
  
        smc_n_wr17 = ((~r_full17 ) | n_r_wr17 );
       
     end

endmodule // smc_wr_enable17

