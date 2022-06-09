//File8 name   : smc_wr_enable_lite8.v
//Title8       : 
//Created8     : 1999
//Description8 : 
//Notes8       : 
//----------------------------------------------------------------------
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


  module smc_wr_enable_lite8 (

                      //inputs8                      

                      n_sys_reset8,
                      r_full8,
                      n_r_we8,
                      n_r_wr8,

                      //outputs8

                      smc_n_we8,
                      smc_n_wr8);

//I8/O8
   
   input             n_sys_reset8;   //system reset
   input             r_full8;    // Full cycle write strobe8
   input [3:0]       n_r_we8;    //write enable from smc_strobe8
   input             n_r_wr8;    //write strobe8 from smc_strobe8
   output [3:0]      smc_n_we8;  // write enable (active low8)
   output            smc_n_wr8;  // write strobe8 (active low8)
   
   
//output reg declaration8.
   
   reg [3:0]          smc_n_we8;
   reg                smc_n_wr8;

//----------------------------------------------------------------------
// negedge strobes8 with clock8.
//----------------------------------------------------------------------
      

//----------------------------------------------------------------------
      
//--------------------------------------------------------------------
// Gate8 Write strobes8 with clock8.
//--------------------------------------------------------------------

  always @(r_full8 or n_r_we8)
  
  begin
  
     smc_n_we8[0] = ((~r_full8  ) | n_r_we8[0] );

     smc_n_we8[1] = ((~r_full8  ) | n_r_we8[1] );

     smc_n_we8[2] = ((~r_full8  ) | n_r_we8[2] );

     smc_n_we8[3] = ((~r_full8  ) | n_r_we8[3] );

  
  end

//--------------------------------------------------------------------   
//write strobe8 generation8
//--------------------------------------------------------------------   

  always @(n_r_wr8 or r_full8 )
  
     begin
  
        smc_n_wr8 = ((~r_full8 ) | n_r_wr8 );
       
     end

endmodule // smc_wr_enable8

