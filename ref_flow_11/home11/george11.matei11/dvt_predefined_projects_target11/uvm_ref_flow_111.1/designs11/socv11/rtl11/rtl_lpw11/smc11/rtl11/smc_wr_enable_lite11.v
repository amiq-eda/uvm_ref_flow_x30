//File11 name   : smc_wr_enable_lite11.v
//Title11       : 
//Created11     : 1999
//Description11 : 
//Notes11       : 
//----------------------------------------------------------------------
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


  module smc_wr_enable_lite11 (

                      //inputs11                      

                      n_sys_reset11,
                      r_full11,
                      n_r_we11,
                      n_r_wr11,

                      //outputs11

                      smc_n_we11,
                      smc_n_wr11);

//I11/O11
   
   input             n_sys_reset11;   //system reset
   input             r_full11;    // Full cycle write strobe11
   input [3:0]       n_r_we11;    //write enable from smc_strobe11
   input             n_r_wr11;    //write strobe11 from smc_strobe11
   output [3:0]      smc_n_we11;  // write enable (active low11)
   output            smc_n_wr11;  // write strobe11 (active low11)
   
   
//output reg declaration11.
   
   reg [3:0]          smc_n_we11;
   reg                smc_n_wr11;

//----------------------------------------------------------------------
// negedge strobes11 with clock11.
//----------------------------------------------------------------------
      

//----------------------------------------------------------------------
      
//--------------------------------------------------------------------
// Gate11 Write strobes11 with clock11.
//--------------------------------------------------------------------

  always @(r_full11 or n_r_we11)
  
  begin
  
     smc_n_we11[0] = ((~r_full11  ) | n_r_we11[0] );

     smc_n_we11[1] = ((~r_full11  ) | n_r_we11[1] );

     smc_n_we11[2] = ((~r_full11  ) | n_r_we11[2] );

     smc_n_we11[3] = ((~r_full11  ) | n_r_we11[3] );

  
  end

//--------------------------------------------------------------------   
//write strobe11 generation11
//--------------------------------------------------------------------   

  always @(n_r_wr11 or r_full11 )
  
     begin
  
        smc_n_wr11 = ((~r_full11 ) | n_r_wr11 );
       
     end

endmodule // smc_wr_enable11

