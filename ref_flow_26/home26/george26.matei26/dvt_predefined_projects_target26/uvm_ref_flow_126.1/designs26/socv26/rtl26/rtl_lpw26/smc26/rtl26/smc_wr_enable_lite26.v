//File26 name   : smc_wr_enable_lite26.v
//Title26       : 
//Created26     : 1999
//Description26 : 
//Notes26       : 
//----------------------------------------------------------------------
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


  module smc_wr_enable_lite26 (

                      //inputs26                      

                      n_sys_reset26,
                      r_full26,
                      n_r_we26,
                      n_r_wr26,

                      //outputs26

                      smc_n_we26,
                      smc_n_wr26);

//I26/O26
   
   input             n_sys_reset26;   //system reset
   input             r_full26;    // Full cycle write strobe26
   input [3:0]       n_r_we26;    //write enable from smc_strobe26
   input             n_r_wr26;    //write strobe26 from smc_strobe26
   output [3:0]      smc_n_we26;  // write enable (active low26)
   output            smc_n_wr26;  // write strobe26 (active low26)
   
   
//output reg declaration26.
   
   reg [3:0]          smc_n_we26;
   reg                smc_n_wr26;

//----------------------------------------------------------------------
// negedge strobes26 with clock26.
//----------------------------------------------------------------------
      

//----------------------------------------------------------------------
      
//--------------------------------------------------------------------
// Gate26 Write strobes26 with clock26.
//--------------------------------------------------------------------

  always @(r_full26 or n_r_we26)
  
  begin
  
     smc_n_we26[0] = ((~r_full26  ) | n_r_we26[0] );

     smc_n_we26[1] = ((~r_full26  ) | n_r_we26[1] );

     smc_n_we26[2] = ((~r_full26  ) | n_r_we26[2] );

     smc_n_we26[3] = ((~r_full26  ) | n_r_we26[3] );

  
  end

//--------------------------------------------------------------------   
//write strobe26 generation26
//--------------------------------------------------------------------   

  always @(n_r_wr26 or r_full26 )
  
     begin
  
        smc_n_wr26 = ((~r_full26 ) | n_r_wr26 );
       
     end

endmodule // smc_wr_enable26

