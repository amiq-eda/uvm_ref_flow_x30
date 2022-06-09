//File16 name   : smc_wr_enable_lite16.v
//Title16       : 
//Created16     : 1999
//Description16 : 
//Notes16       : 
//----------------------------------------------------------------------
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


  module smc_wr_enable_lite16 (

                      //inputs16                      

                      n_sys_reset16,
                      r_full16,
                      n_r_we16,
                      n_r_wr16,

                      //outputs16

                      smc_n_we16,
                      smc_n_wr16);

//I16/O16
   
   input             n_sys_reset16;   //system reset
   input             r_full16;    // Full cycle write strobe16
   input [3:0]       n_r_we16;    //write enable from smc_strobe16
   input             n_r_wr16;    //write strobe16 from smc_strobe16
   output [3:0]      smc_n_we16;  // write enable (active low16)
   output            smc_n_wr16;  // write strobe16 (active low16)
   
   
//output reg declaration16.
   
   reg [3:0]          smc_n_we16;
   reg                smc_n_wr16;

//----------------------------------------------------------------------
// negedge strobes16 with clock16.
//----------------------------------------------------------------------
      

//----------------------------------------------------------------------
      
//--------------------------------------------------------------------
// Gate16 Write strobes16 with clock16.
//--------------------------------------------------------------------

  always @(r_full16 or n_r_we16)
  
  begin
  
     smc_n_we16[0] = ((~r_full16  ) | n_r_we16[0] );

     smc_n_we16[1] = ((~r_full16  ) | n_r_we16[1] );

     smc_n_we16[2] = ((~r_full16  ) | n_r_we16[2] );

     smc_n_we16[3] = ((~r_full16  ) | n_r_we16[3] );

  
  end

//--------------------------------------------------------------------   
//write strobe16 generation16
//--------------------------------------------------------------------   

  always @(n_r_wr16 or r_full16 )
  
     begin
  
        smc_n_wr16 = ((~r_full16 ) | n_r_wr16 );
       
     end

endmodule // smc_wr_enable16

