//File14 name   : smc_wr_enable_lite14.v
//Title14       : 
//Created14     : 1999
//Description14 : 
//Notes14       : 
//----------------------------------------------------------------------
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


  module smc_wr_enable_lite14 (

                      //inputs14                      

                      n_sys_reset14,
                      r_full14,
                      n_r_we14,
                      n_r_wr14,

                      //outputs14

                      smc_n_we14,
                      smc_n_wr14);

//I14/O14
   
   input             n_sys_reset14;   //system reset
   input             r_full14;    // Full cycle write strobe14
   input [3:0]       n_r_we14;    //write enable from smc_strobe14
   input             n_r_wr14;    //write strobe14 from smc_strobe14
   output [3:0]      smc_n_we14;  // write enable (active low14)
   output            smc_n_wr14;  // write strobe14 (active low14)
   
   
//output reg declaration14.
   
   reg [3:0]          smc_n_we14;
   reg                smc_n_wr14;

//----------------------------------------------------------------------
// negedge strobes14 with clock14.
//----------------------------------------------------------------------
      

//----------------------------------------------------------------------
      
//--------------------------------------------------------------------
// Gate14 Write strobes14 with clock14.
//--------------------------------------------------------------------

  always @(r_full14 or n_r_we14)
  
  begin
  
     smc_n_we14[0] = ((~r_full14  ) | n_r_we14[0] );

     smc_n_we14[1] = ((~r_full14  ) | n_r_we14[1] );

     smc_n_we14[2] = ((~r_full14  ) | n_r_we14[2] );

     smc_n_we14[3] = ((~r_full14  ) | n_r_we14[3] );

  
  end

//--------------------------------------------------------------------   
//write strobe14 generation14
//--------------------------------------------------------------------   

  always @(n_r_wr14 or r_full14 )
  
     begin
  
        smc_n_wr14 = ((~r_full14 ) | n_r_wr14 );
       
     end

endmodule // smc_wr_enable14

