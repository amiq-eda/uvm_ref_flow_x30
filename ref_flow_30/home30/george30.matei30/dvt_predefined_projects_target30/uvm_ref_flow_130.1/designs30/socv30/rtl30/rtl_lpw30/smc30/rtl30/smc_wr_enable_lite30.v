//File30 name   : smc_wr_enable_lite30.v
//Title30       : 
//Created30     : 1999
//Description30 : 
//Notes30       : 
//----------------------------------------------------------------------
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


  module smc_wr_enable_lite30 (

                      //inputs30                      

                      n_sys_reset30,
                      r_full30,
                      n_r_we30,
                      n_r_wr30,

                      //outputs30

                      smc_n_we30,
                      smc_n_wr30);

//I30/O30
   
   input             n_sys_reset30;   //system reset
   input             r_full30;    // Full cycle write strobe30
   input [3:0]       n_r_we30;    //write enable from smc_strobe30
   input             n_r_wr30;    //write strobe30 from smc_strobe30
   output [3:0]      smc_n_we30;  // write enable (active low30)
   output            smc_n_wr30;  // write strobe30 (active low30)
   
   
//output reg declaration30.
   
   reg [3:0]          smc_n_we30;
   reg                smc_n_wr30;

//----------------------------------------------------------------------
// negedge strobes30 with clock30.
//----------------------------------------------------------------------
      

//----------------------------------------------------------------------
      
//--------------------------------------------------------------------
// Gate30 Write strobes30 with clock30.
//--------------------------------------------------------------------

  always @(r_full30 or n_r_we30)
  
  begin
  
     smc_n_we30[0] = ((~r_full30  ) | n_r_we30[0] );

     smc_n_we30[1] = ((~r_full30  ) | n_r_we30[1] );

     smc_n_we30[2] = ((~r_full30  ) | n_r_we30[2] );

     smc_n_we30[3] = ((~r_full30  ) | n_r_we30[3] );

  
  end

//--------------------------------------------------------------------   
//write strobe30 generation30
//--------------------------------------------------------------------   

  always @(n_r_wr30 or r_full30 )
  
     begin
  
        smc_n_wr30 = ((~r_full30 ) | n_r_wr30 );
       
     end

endmodule // smc_wr_enable30

