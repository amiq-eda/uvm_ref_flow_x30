//File24 name   : smc_wr_enable_lite24.v
//Title24       : 
//Created24     : 1999
//Description24 : 
//Notes24       : 
//----------------------------------------------------------------------
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


  module smc_wr_enable_lite24 (

                      //inputs24                      

                      n_sys_reset24,
                      r_full24,
                      n_r_we24,
                      n_r_wr24,

                      //outputs24

                      smc_n_we24,
                      smc_n_wr24);

//I24/O24
   
   input             n_sys_reset24;   //system reset
   input             r_full24;    // Full cycle write strobe24
   input [3:0]       n_r_we24;    //write enable from smc_strobe24
   input             n_r_wr24;    //write strobe24 from smc_strobe24
   output [3:0]      smc_n_we24;  // write enable (active low24)
   output            smc_n_wr24;  // write strobe24 (active low24)
   
   
//output reg declaration24.
   
   reg [3:0]          smc_n_we24;
   reg                smc_n_wr24;

//----------------------------------------------------------------------
// negedge strobes24 with clock24.
//----------------------------------------------------------------------
      

//----------------------------------------------------------------------
      
//--------------------------------------------------------------------
// Gate24 Write strobes24 with clock24.
//--------------------------------------------------------------------

  always @(r_full24 or n_r_we24)
  
  begin
  
     smc_n_we24[0] = ((~r_full24  ) | n_r_we24[0] );

     smc_n_we24[1] = ((~r_full24  ) | n_r_we24[1] );

     smc_n_we24[2] = ((~r_full24  ) | n_r_we24[2] );

     smc_n_we24[3] = ((~r_full24  ) | n_r_we24[3] );

  
  end

//--------------------------------------------------------------------   
//write strobe24 generation24
//--------------------------------------------------------------------   

  always @(n_r_wr24 or r_full24 )
  
     begin
  
        smc_n_wr24 = ((~r_full24 ) | n_r_wr24 );
       
     end

endmodule // smc_wr_enable24

