//File10 name   : smc_wr_enable_lite10.v
//Title10       : 
//Created10     : 1999
//Description10 : 
//Notes10       : 
//----------------------------------------------------------------------
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


  module smc_wr_enable_lite10 (

                      //inputs10                      

                      n_sys_reset10,
                      r_full10,
                      n_r_we10,
                      n_r_wr10,

                      //outputs10

                      smc_n_we10,
                      smc_n_wr10);

//I10/O10
   
   input             n_sys_reset10;   //system reset
   input             r_full10;    // Full cycle write strobe10
   input [3:0]       n_r_we10;    //write enable from smc_strobe10
   input             n_r_wr10;    //write strobe10 from smc_strobe10
   output [3:0]      smc_n_we10;  // write enable (active low10)
   output            smc_n_wr10;  // write strobe10 (active low10)
   
   
//output reg declaration10.
   
   reg [3:0]          smc_n_we10;
   reg                smc_n_wr10;

//----------------------------------------------------------------------
// negedge strobes10 with clock10.
//----------------------------------------------------------------------
      

//----------------------------------------------------------------------
      
//--------------------------------------------------------------------
// Gate10 Write strobes10 with clock10.
//--------------------------------------------------------------------

  always @(r_full10 or n_r_we10)
  
  begin
  
     smc_n_we10[0] = ((~r_full10  ) | n_r_we10[0] );

     smc_n_we10[1] = ((~r_full10  ) | n_r_we10[1] );

     smc_n_we10[2] = ((~r_full10  ) | n_r_we10[2] );

     smc_n_we10[3] = ((~r_full10  ) | n_r_we10[3] );

  
  end

//--------------------------------------------------------------------   
//write strobe10 generation10
//--------------------------------------------------------------------   

  always @(n_r_wr10 or r_full10 )
  
     begin
  
        smc_n_wr10 = ((~r_full10 ) | n_r_wr10 );
       
     end

endmodule // smc_wr_enable10

