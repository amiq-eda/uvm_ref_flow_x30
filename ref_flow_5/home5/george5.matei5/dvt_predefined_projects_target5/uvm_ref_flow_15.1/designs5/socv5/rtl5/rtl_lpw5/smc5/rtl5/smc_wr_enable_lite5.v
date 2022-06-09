//File5 name   : smc_wr_enable_lite5.v
//Title5       : 
//Created5     : 1999
//Description5 : 
//Notes5       : 
//----------------------------------------------------------------------
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


  module smc_wr_enable_lite5 (

                      //inputs5                      

                      n_sys_reset5,
                      r_full5,
                      n_r_we5,
                      n_r_wr5,

                      //outputs5

                      smc_n_we5,
                      smc_n_wr5);

//I5/O5
   
   input             n_sys_reset5;   //system reset
   input             r_full5;    // Full cycle write strobe5
   input [3:0]       n_r_we5;    //write enable from smc_strobe5
   input             n_r_wr5;    //write strobe5 from smc_strobe5
   output [3:0]      smc_n_we5;  // write enable (active low5)
   output            smc_n_wr5;  // write strobe5 (active low5)
   
   
//output reg declaration5.
   
   reg [3:0]          smc_n_we5;
   reg                smc_n_wr5;

//----------------------------------------------------------------------
// negedge strobes5 with clock5.
//----------------------------------------------------------------------
      

//----------------------------------------------------------------------
      
//--------------------------------------------------------------------
// Gate5 Write strobes5 with clock5.
//--------------------------------------------------------------------

  always @(r_full5 or n_r_we5)
  
  begin
  
     smc_n_we5[0] = ((~r_full5  ) | n_r_we5[0] );

     smc_n_we5[1] = ((~r_full5  ) | n_r_we5[1] );

     smc_n_we5[2] = ((~r_full5  ) | n_r_we5[2] );

     smc_n_we5[3] = ((~r_full5  ) | n_r_we5[3] );

  
  end

//--------------------------------------------------------------------   
//write strobe5 generation5
//--------------------------------------------------------------------   

  always @(n_r_wr5 or r_full5 )
  
     begin
  
        smc_n_wr5 = ((~r_full5 ) | n_r_wr5 );
       
     end

endmodule // smc_wr_enable5

