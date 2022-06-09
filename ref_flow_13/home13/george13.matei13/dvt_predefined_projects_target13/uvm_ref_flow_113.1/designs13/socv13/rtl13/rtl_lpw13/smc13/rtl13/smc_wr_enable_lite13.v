//File13 name   : smc_wr_enable_lite13.v
//Title13       : 
//Created13     : 1999
//Description13 : 
//Notes13       : 
//----------------------------------------------------------------------
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


  module smc_wr_enable_lite13 (

                      //inputs13                      

                      n_sys_reset13,
                      r_full13,
                      n_r_we13,
                      n_r_wr13,

                      //outputs13

                      smc_n_we13,
                      smc_n_wr13);

//I13/O13
   
   input             n_sys_reset13;   //system reset
   input             r_full13;    // Full cycle write strobe13
   input [3:0]       n_r_we13;    //write enable from smc_strobe13
   input             n_r_wr13;    //write strobe13 from smc_strobe13
   output [3:0]      smc_n_we13;  // write enable (active low13)
   output            smc_n_wr13;  // write strobe13 (active low13)
   
   
//output reg declaration13.
   
   reg [3:0]          smc_n_we13;
   reg                smc_n_wr13;

//----------------------------------------------------------------------
// negedge strobes13 with clock13.
//----------------------------------------------------------------------
      

//----------------------------------------------------------------------
      
//--------------------------------------------------------------------
// Gate13 Write strobes13 with clock13.
//--------------------------------------------------------------------

  always @(r_full13 or n_r_we13)
  
  begin
  
     smc_n_we13[0] = ((~r_full13  ) | n_r_we13[0] );

     smc_n_we13[1] = ((~r_full13  ) | n_r_we13[1] );

     smc_n_we13[2] = ((~r_full13  ) | n_r_we13[2] );

     smc_n_we13[3] = ((~r_full13  ) | n_r_we13[3] );

  
  end

//--------------------------------------------------------------------   
//write strobe13 generation13
//--------------------------------------------------------------------   

  always @(n_r_wr13 or r_full13 )
  
     begin
  
        smc_n_wr13 = ((~r_full13 ) | n_r_wr13 );
       
     end

endmodule // smc_wr_enable13

