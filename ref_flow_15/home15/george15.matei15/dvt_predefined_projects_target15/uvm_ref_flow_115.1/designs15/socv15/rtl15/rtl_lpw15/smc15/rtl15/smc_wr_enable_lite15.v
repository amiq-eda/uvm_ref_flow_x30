//File15 name   : smc_wr_enable_lite15.v
//Title15       : 
//Created15     : 1999
//Description15 : 
//Notes15       : 
//----------------------------------------------------------------------
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


  module smc_wr_enable_lite15 (

                      //inputs15                      

                      n_sys_reset15,
                      r_full15,
                      n_r_we15,
                      n_r_wr15,

                      //outputs15

                      smc_n_we15,
                      smc_n_wr15);

//I15/O15
   
   input             n_sys_reset15;   //system reset
   input             r_full15;    // Full cycle write strobe15
   input [3:0]       n_r_we15;    //write enable from smc_strobe15
   input             n_r_wr15;    //write strobe15 from smc_strobe15
   output [3:0]      smc_n_we15;  // write enable (active low15)
   output            smc_n_wr15;  // write strobe15 (active low15)
   
   
//output reg declaration15.
   
   reg [3:0]          smc_n_we15;
   reg                smc_n_wr15;

//----------------------------------------------------------------------
// negedge strobes15 with clock15.
//----------------------------------------------------------------------
      

//----------------------------------------------------------------------
      
//--------------------------------------------------------------------
// Gate15 Write strobes15 with clock15.
//--------------------------------------------------------------------

  always @(r_full15 or n_r_we15)
  
  begin
  
     smc_n_we15[0] = ((~r_full15  ) | n_r_we15[0] );

     smc_n_we15[1] = ((~r_full15  ) | n_r_we15[1] );

     smc_n_we15[2] = ((~r_full15  ) | n_r_we15[2] );

     smc_n_we15[3] = ((~r_full15  ) | n_r_we15[3] );

  
  end

//--------------------------------------------------------------------   
//write strobe15 generation15
//--------------------------------------------------------------------   

  always @(n_r_wr15 or r_full15 )
  
     begin
  
        smc_n_wr15 = ((~r_full15 ) | n_r_wr15 );
       
     end

endmodule // smc_wr_enable15

