//File12 name   : smc_wr_enable_lite12.v
//Title12       : 
//Created12     : 1999
//Description12 : 
//Notes12       : 
//----------------------------------------------------------------------
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


  module smc_wr_enable_lite12 (

                      //inputs12                      

                      n_sys_reset12,
                      r_full12,
                      n_r_we12,
                      n_r_wr12,

                      //outputs12

                      smc_n_we12,
                      smc_n_wr12);

//I12/O12
   
   input             n_sys_reset12;   //system reset
   input             r_full12;    // Full cycle write strobe12
   input [3:0]       n_r_we12;    //write enable from smc_strobe12
   input             n_r_wr12;    //write strobe12 from smc_strobe12
   output [3:0]      smc_n_we12;  // write enable (active low12)
   output            smc_n_wr12;  // write strobe12 (active low12)
   
   
//output reg declaration12.
   
   reg [3:0]          smc_n_we12;
   reg                smc_n_wr12;

//----------------------------------------------------------------------
// negedge strobes12 with clock12.
//----------------------------------------------------------------------
      

//----------------------------------------------------------------------
      
//--------------------------------------------------------------------
// Gate12 Write strobes12 with clock12.
//--------------------------------------------------------------------

  always @(r_full12 or n_r_we12)
  
  begin
  
     smc_n_we12[0] = ((~r_full12  ) | n_r_we12[0] );

     smc_n_we12[1] = ((~r_full12  ) | n_r_we12[1] );

     smc_n_we12[2] = ((~r_full12  ) | n_r_we12[2] );

     smc_n_we12[3] = ((~r_full12  ) | n_r_we12[3] );

  
  end

//--------------------------------------------------------------------   
//write strobe12 generation12
//--------------------------------------------------------------------   

  always @(n_r_wr12 or r_full12 )
  
     begin
  
        smc_n_wr12 = ((~r_full12 ) | n_r_wr12 );
       
     end

endmodule // smc_wr_enable12

