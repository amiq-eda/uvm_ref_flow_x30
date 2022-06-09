//File23 name   : smc_wr_enable_lite23.v
//Title23       : 
//Created23     : 1999
//Description23 : 
//Notes23       : 
//----------------------------------------------------------------------
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


  module smc_wr_enable_lite23 (

                      //inputs23                      

                      n_sys_reset23,
                      r_full23,
                      n_r_we23,
                      n_r_wr23,

                      //outputs23

                      smc_n_we23,
                      smc_n_wr23);

//I23/O23
   
   input             n_sys_reset23;   //system reset
   input             r_full23;    // Full cycle write strobe23
   input [3:0]       n_r_we23;    //write enable from smc_strobe23
   input             n_r_wr23;    //write strobe23 from smc_strobe23
   output [3:0]      smc_n_we23;  // write enable (active low23)
   output            smc_n_wr23;  // write strobe23 (active low23)
   
   
//output reg declaration23.
   
   reg [3:0]          smc_n_we23;
   reg                smc_n_wr23;

//----------------------------------------------------------------------
// negedge strobes23 with clock23.
//----------------------------------------------------------------------
      

//----------------------------------------------------------------------
      
//--------------------------------------------------------------------
// Gate23 Write strobes23 with clock23.
//--------------------------------------------------------------------

  always @(r_full23 or n_r_we23)
  
  begin
  
     smc_n_we23[0] = ((~r_full23  ) | n_r_we23[0] );

     smc_n_we23[1] = ((~r_full23  ) | n_r_we23[1] );

     smc_n_we23[2] = ((~r_full23  ) | n_r_we23[2] );

     smc_n_we23[3] = ((~r_full23  ) | n_r_we23[3] );

  
  end

//--------------------------------------------------------------------   
//write strobe23 generation23
//--------------------------------------------------------------------   

  always @(n_r_wr23 or r_full23 )
  
     begin
  
        smc_n_wr23 = ((~r_full23 ) | n_r_wr23 );
       
     end

endmodule // smc_wr_enable23

