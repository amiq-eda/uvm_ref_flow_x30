//File2 name   : smc_wr_enable_lite2.v
//Title2       : 
//Created2     : 1999
//Description2 : 
//Notes2       : 
//----------------------------------------------------------------------
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


  module smc_wr_enable_lite2 (

                      //inputs2                      

                      n_sys_reset2,
                      r_full2,
                      n_r_we2,
                      n_r_wr2,

                      //outputs2

                      smc_n_we2,
                      smc_n_wr2);

//I2/O2
   
   input             n_sys_reset2;   //system reset
   input             r_full2;    // Full cycle write strobe2
   input [3:0]       n_r_we2;    //write enable from smc_strobe2
   input             n_r_wr2;    //write strobe2 from smc_strobe2
   output [3:0]      smc_n_we2;  // write enable (active low2)
   output            smc_n_wr2;  // write strobe2 (active low2)
   
   
//output reg declaration2.
   
   reg [3:0]          smc_n_we2;
   reg                smc_n_wr2;

//----------------------------------------------------------------------
// negedge strobes2 with clock2.
//----------------------------------------------------------------------
      

//----------------------------------------------------------------------
      
//--------------------------------------------------------------------
// Gate2 Write strobes2 with clock2.
//--------------------------------------------------------------------

  always @(r_full2 or n_r_we2)
  
  begin
  
     smc_n_we2[0] = ((~r_full2  ) | n_r_we2[0] );

     smc_n_we2[1] = ((~r_full2  ) | n_r_we2[1] );

     smc_n_we2[2] = ((~r_full2  ) | n_r_we2[2] );

     smc_n_we2[3] = ((~r_full2  ) | n_r_we2[3] );

  
  end

//--------------------------------------------------------------------   
//write strobe2 generation2
//--------------------------------------------------------------------   

  always @(n_r_wr2 or r_full2 )
  
     begin
  
        smc_n_wr2 = ((~r_full2 ) | n_r_wr2 );
       
     end

endmodule // smc_wr_enable2

