//File7 name   : smc_wr_enable_lite7.v
//Title7       : 
//Created7     : 1999
//Description7 : 
//Notes7       : 
//----------------------------------------------------------------------
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


  module smc_wr_enable_lite7 (

                      //inputs7                      

                      n_sys_reset7,
                      r_full7,
                      n_r_we7,
                      n_r_wr7,

                      //outputs7

                      smc_n_we7,
                      smc_n_wr7);

//I7/O7
   
   input             n_sys_reset7;   //system reset
   input             r_full7;    // Full cycle write strobe7
   input [3:0]       n_r_we7;    //write enable from smc_strobe7
   input             n_r_wr7;    //write strobe7 from smc_strobe7
   output [3:0]      smc_n_we7;  // write enable (active low7)
   output            smc_n_wr7;  // write strobe7 (active low7)
   
   
//output reg declaration7.
   
   reg [3:0]          smc_n_we7;
   reg                smc_n_wr7;

//----------------------------------------------------------------------
// negedge strobes7 with clock7.
//----------------------------------------------------------------------
      

//----------------------------------------------------------------------
      
//--------------------------------------------------------------------
// Gate7 Write strobes7 with clock7.
//--------------------------------------------------------------------

  always @(r_full7 or n_r_we7)
  
  begin
  
     smc_n_we7[0] = ((~r_full7  ) | n_r_we7[0] );

     smc_n_we7[1] = ((~r_full7  ) | n_r_we7[1] );

     smc_n_we7[2] = ((~r_full7  ) | n_r_we7[2] );

     smc_n_we7[3] = ((~r_full7  ) | n_r_we7[3] );

  
  end

//--------------------------------------------------------------------   
//write strobe7 generation7
//--------------------------------------------------------------------   

  always @(n_r_wr7 or r_full7 )
  
     begin
  
        smc_n_wr7 = ((~r_full7 ) | n_r_wr7 );
       
     end

endmodule // smc_wr_enable7

