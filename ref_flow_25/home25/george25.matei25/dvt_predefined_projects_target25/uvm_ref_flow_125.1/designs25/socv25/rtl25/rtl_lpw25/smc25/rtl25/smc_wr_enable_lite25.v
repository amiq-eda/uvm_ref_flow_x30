//File25 name   : smc_wr_enable_lite25.v
//Title25       : 
//Created25     : 1999
//Description25 : 
//Notes25       : 
//----------------------------------------------------------------------
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


  module smc_wr_enable_lite25 (

                      //inputs25                      

                      n_sys_reset25,
                      r_full25,
                      n_r_we25,
                      n_r_wr25,

                      //outputs25

                      smc_n_we25,
                      smc_n_wr25);

//I25/O25
   
   input             n_sys_reset25;   //system reset
   input             r_full25;    // Full cycle write strobe25
   input [3:0]       n_r_we25;    //write enable from smc_strobe25
   input             n_r_wr25;    //write strobe25 from smc_strobe25
   output [3:0]      smc_n_we25;  // write enable (active low25)
   output            smc_n_wr25;  // write strobe25 (active low25)
   
   
//output reg declaration25.
   
   reg [3:0]          smc_n_we25;
   reg                smc_n_wr25;

//----------------------------------------------------------------------
// negedge strobes25 with clock25.
//----------------------------------------------------------------------
      

//----------------------------------------------------------------------
      
//--------------------------------------------------------------------
// Gate25 Write strobes25 with clock25.
//--------------------------------------------------------------------

  always @(r_full25 or n_r_we25)
  
  begin
  
     smc_n_we25[0] = ((~r_full25  ) | n_r_we25[0] );

     smc_n_we25[1] = ((~r_full25  ) | n_r_we25[1] );

     smc_n_we25[2] = ((~r_full25  ) | n_r_we25[2] );

     smc_n_we25[3] = ((~r_full25  ) | n_r_we25[3] );

  
  end

//--------------------------------------------------------------------   
//write strobe25 generation25
//--------------------------------------------------------------------   

  always @(n_r_wr25 or r_full25 )
  
     begin
  
        smc_n_wr25 = ((~r_full25 ) | n_r_wr25 );
       
     end

endmodule // smc_wr_enable25

