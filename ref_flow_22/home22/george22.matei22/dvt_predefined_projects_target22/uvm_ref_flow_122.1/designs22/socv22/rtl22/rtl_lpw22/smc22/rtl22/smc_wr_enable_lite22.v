//File22 name   : smc_wr_enable_lite22.v
//Title22       : 
//Created22     : 1999
//Description22 : 
//Notes22       : 
//----------------------------------------------------------------------
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


  module smc_wr_enable_lite22 (

                      //inputs22                      

                      n_sys_reset22,
                      r_full22,
                      n_r_we22,
                      n_r_wr22,

                      //outputs22

                      smc_n_we22,
                      smc_n_wr22);

//I22/O22
   
   input             n_sys_reset22;   //system reset
   input             r_full22;    // Full cycle write strobe22
   input [3:0]       n_r_we22;    //write enable from smc_strobe22
   input             n_r_wr22;    //write strobe22 from smc_strobe22
   output [3:0]      smc_n_we22;  // write enable (active low22)
   output            smc_n_wr22;  // write strobe22 (active low22)
   
   
//output reg declaration22.
   
   reg [3:0]          smc_n_we22;
   reg                smc_n_wr22;

//----------------------------------------------------------------------
// negedge strobes22 with clock22.
//----------------------------------------------------------------------
      

//----------------------------------------------------------------------
      
//--------------------------------------------------------------------
// Gate22 Write strobes22 with clock22.
//--------------------------------------------------------------------

  always @(r_full22 or n_r_we22)
  
  begin
  
     smc_n_we22[0] = ((~r_full22  ) | n_r_we22[0] );

     smc_n_we22[1] = ((~r_full22  ) | n_r_we22[1] );

     smc_n_we22[2] = ((~r_full22  ) | n_r_we22[2] );

     smc_n_we22[3] = ((~r_full22  ) | n_r_we22[3] );

  
  end

//--------------------------------------------------------------------   
//write strobe22 generation22
//--------------------------------------------------------------------   

  always @(n_r_wr22 or r_full22 )
  
     begin
  
        smc_n_wr22 = ((~r_full22 ) | n_r_wr22 );
       
     end

endmodule // smc_wr_enable22

