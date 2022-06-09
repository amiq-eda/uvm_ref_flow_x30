//File19 name   : smc_wr_enable_lite19.v
//Title19       : 
//Created19     : 1999
//Description19 : 
//Notes19       : 
//----------------------------------------------------------------------
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


  module smc_wr_enable_lite19 (

                      //inputs19                      

                      n_sys_reset19,
                      r_full19,
                      n_r_we19,
                      n_r_wr19,

                      //outputs19

                      smc_n_we19,
                      smc_n_wr19);

//I19/O19
   
   input             n_sys_reset19;   //system reset
   input             r_full19;    // Full cycle write strobe19
   input [3:0]       n_r_we19;    //write enable from smc_strobe19
   input             n_r_wr19;    //write strobe19 from smc_strobe19
   output [3:0]      smc_n_we19;  // write enable (active low19)
   output            smc_n_wr19;  // write strobe19 (active low19)
   
   
//output reg declaration19.
   
   reg [3:0]          smc_n_we19;
   reg                smc_n_wr19;

//----------------------------------------------------------------------
// negedge strobes19 with clock19.
//----------------------------------------------------------------------
      

//----------------------------------------------------------------------
      
//--------------------------------------------------------------------
// Gate19 Write strobes19 with clock19.
//--------------------------------------------------------------------

  always @(r_full19 or n_r_we19)
  
  begin
  
     smc_n_we19[0] = ((~r_full19  ) | n_r_we19[0] );

     smc_n_we19[1] = ((~r_full19  ) | n_r_we19[1] );

     smc_n_we19[2] = ((~r_full19  ) | n_r_we19[2] );

     smc_n_we19[3] = ((~r_full19  ) | n_r_we19[3] );

  
  end

//--------------------------------------------------------------------   
//write strobe19 generation19
//--------------------------------------------------------------------   

  always @(n_r_wr19 or r_full19 )
  
     begin
  
        smc_n_wr19 = ((~r_full19 ) | n_r_wr19 );
       
     end

endmodule // smc_wr_enable19

