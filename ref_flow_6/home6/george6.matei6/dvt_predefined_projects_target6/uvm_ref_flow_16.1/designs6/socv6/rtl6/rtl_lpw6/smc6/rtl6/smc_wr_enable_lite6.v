//File6 name   : smc_wr_enable_lite6.v
//Title6       : 
//Created6     : 1999
//Description6 : 
//Notes6       : 
//----------------------------------------------------------------------
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


  module smc_wr_enable_lite6 (

                      //inputs6                      

                      n_sys_reset6,
                      r_full6,
                      n_r_we6,
                      n_r_wr6,

                      //outputs6

                      smc_n_we6,
                      smc_n_wr6);

//I6/O6
   
   input             n_sys_reset6;   //system reset
   input             r_full6;    // Full cycle write strobe6
   input [3:0]       n_r_we6;    //write enable from smc_strobe6
   input             n_r_wr6;    //write strobe6 from smc_strobe6
   output [3:0]      smc_n_we6;  // write enable (active low6)
   output            smc_n_wr6;  // write strobe6 (active low6)
   
   
//output reg declaration6.
   
   reg [3:0]          smc_n_we6;
   reg                smc_n_wr6;

//----------------------------------------------------------------------
// negedge strobes6 with clock6.
//----------------------------------------------------------------------
      

//----------------------------------------------------------------------
      
//--------------------------------------------------------------------
// Gate6 Write strobes6 with clock6.
//--------------------------------------------------------------------

  always @(r_full6 or n_r_we6)
  
  begin
  
     smc_n_we6[0] = ((~r_full6  ) | n_r_we6[0] );

     smc_n_we6[1] = ((~r_full6  ) | n_r_we6[1] );

     smc_n_we6[2] = ((~r_full6  ) | n_r_we6[2] );

     smc_n_we6[3] = ((~r_full6  ) | n_r_we6[3] );

  
  end

//--------------------------------------------------------------------   
//write strobe6 generation6
//--------------------------------------------------------------------   

  always @(n_r_wr6 or r_full6 )
  
     begin
  
        smc_n_wr6 = ((~r_full6 ) | n_r_wr6 );
       
     end

endmodule // smc_wr_enable6

