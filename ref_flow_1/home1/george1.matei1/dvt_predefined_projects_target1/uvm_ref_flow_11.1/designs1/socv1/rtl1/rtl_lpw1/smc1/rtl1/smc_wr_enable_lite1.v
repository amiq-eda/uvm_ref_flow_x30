//File1 name   : smc_wr_enable_lite1.v
//Title1       : 
//Created1     : 1999
//Description1 : 
//Notes1       : 
//----------------------------------------------------------------------
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


  module smc_wr_enable_lite1 (

                      //inputs1                      

                      n_sys_reset1,
                      r_full1,
                      n_r_we1,
                      n_r_wr1,

                      //outputs1

                      smc_n_we1,
                      smc_n_wr1);

//I1/O1
   
   input             n_sys_reset1;   //system reset
   input             r_full1;    // Full cycle write strobe1
   input [3:0]       n_r_we1;    //write enable from smc_strobe1
   input             n_r_wr1;    //write strobe1 from smc_strobe1
   output [3:0]      smc_n_we1;  // write enable (active low1)
   output            smc_n_wr1;  // write strobe1 (active low1)
   
   
//output reg declaration1.
   
   reg [3:0]          smc_n_we1;
   reg                smc_n_wr1;

//----------------------------------------------------------------------
// negedge strobes1 with clock1.
//----------------------------------------------------------------------
      

//----------------------------------------------------------------------
      
//--------------------------------------------------------------------
// Gate1 Write strobes1 with clock1.
//--------------------------------------------------------------------

  always @(r_full1 or n_r_we1)
  
  begin
  
     smc_n_we1[0] = ((~r_full1  ) | n_r_we1[0] );

     smc_n_we1[1] = ((~r_full1  ) | n_r_we1[1] );

     smc_n_we1[2] = ((~r_full1  ) | n_r_we1[2] );

     smc_n_we1[3] = ((~r_full1  ) | n_r_we1[3] );

  
  end

//--------------------------------------------------------------------   
//write strobe1 generation1
//--------------------------------------------------------------------   

  always @(n_r_wr1 or r_full1 )
  
     begin
  
        smc_n_wr1 = ((~r_full1 ) | n_r_wr1 );
       
     end

endmodule // smc_wr_enable1

