//File3 name   : smc_wr_enable_lite3.v
//Title3       : 
//Created3     : 1999
//Description3 : 
//Notes3       : 
//----------------------------------------------------------------------
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


  module smc_wr_enable_lite3 (

                      //inputs3                      

                      n_sys_reset3,
                      r_full3,
                      n_r_we3,
                      n_r_wr3,

                      //outputs3

                      smc_n_we3,
                      smc_n_wr3);

//I3/O3
   
   input             n_sys_reset3;   //system reset
   input             r_full3;    // Full cycle write strobe3
   input [3:0]       n_r_we3;    //write enable from smc_strobe3
   input             n_r_wr3;    //write strobe3 from smc_strobe3
   output [3:0]      smc_n_we3;  // write enable (active low3)
   output            smc_n_wr3;  // write strobe3 (active low3)
   
   
//output reg declaration3.
   
   reg [3:0]          smc_n_we3;
   reg                smc_n_wr3;

//----------------------------------------------------------------------
// negedge strobes3 with clock3.
//----------------------------------------------------------------------
      

//----------------------------------------------------------------------
      
//--------------------------------------------------------------------
// Gate3 Write strobes3 with clock3.
//--------------------------------------------------------------------

  always @(r_full3 or n_r_we3)
  
  begin
  
     smc_n_we3[0] = ((~r_full3  ) | n_r_we3[0] );

     smc_n_we3[1] = ((~r_full3  ) | n_r_we3[1] );

     smc_n_we3[2] = ((~r_full3  ) | n_r_we3[2] );

     smc_n_we3[3] = ((~r_full3  ) | n_r_we3[3] );

  
  end

//--------------------------------------------------------------------   
//write strobe3 generation3
//--------------------------------------------------------------------   

  always @(n_r_wr3 or r_full3 )
  
     begin
  
        smc_n_wr3 = ((~r_full3 ) | n_r_wr3 );
       
     end

endmodule // smc_wr_enable3

