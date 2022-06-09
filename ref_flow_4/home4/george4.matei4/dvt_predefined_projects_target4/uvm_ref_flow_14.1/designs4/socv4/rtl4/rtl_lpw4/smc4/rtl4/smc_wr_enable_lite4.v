//File4 name   : smc_wr_enable_lite4.v
//Title4       : 
//Created4     : 1999
//Description4 : 
//Notes4       : 
//----------------------------------------------------------------------
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


  module smc_wr_enable_lite4 (

                      //inputs4                      

                      n_sys_reset4,
                      r_full4,
                      n_r_we4,
                      n_r_wr4,

                      //outputs4

                      smc_n_we4,
                      smc_n_wr4);

//I4/O4
   
   input             n_sys_reset4;   //system reset
   input             r_full4;    // Full cycle write strobe4
   input [3:0]       n_r_we4;    //write enable from smc_strobe4
   input             n_r_wr4;    //write strobe4 from smc_strobe4
   output [3:0]      smc_n_we4;  // write enable (active low4)
   output            smc_n_wr4;  // write strobe4 (active low4)
   
   
//output reg declaration4.
   
   reg [3:0]          smc_n_we4;
   reg                smc_n_wr4;

//----------------------------------------------------------------------
// negedge strobes4 with clock4.
//----------------------------------------------------------------------
      

//----------------------------------------------------------------------
      
//--------------------------------------------------------------------
// Gate4 Write strobes4 with clock4.
//--------------------------------------------------------------------

  always @(r_full4 or n_r_we4)
  
  begin
  
     smc_n_we4[0] = ((~r_full4  ) | n_r_we4[0] );

     smc_n_we4[1] = ((~r_full4  ) | n_r_we4[1] );

     smc_n_we4[2] = ((~r_full4  ) | n_r_we4[2] );

     smc_n_we4[3] = ((~r_full4  ) | n_r_we4[3] );

  
  end

//--------------------------------------------------------------------   
//write strobe4 generation4
//--------------------------------------------------------------------   

  always @(n_r_wr4 or r_full4 )
  
     begin
  
        smc_n_wr4 = ((~r_full4 ) | n_r_wr4 );
       
     end

endmodule // smc_wr_enable4

