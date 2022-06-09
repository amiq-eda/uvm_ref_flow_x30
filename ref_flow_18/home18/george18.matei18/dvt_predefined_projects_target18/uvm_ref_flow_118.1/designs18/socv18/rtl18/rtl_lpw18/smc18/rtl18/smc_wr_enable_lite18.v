//File18 name   : smc_wr_enable_lite18.v
//Title18       : 
//Created18     : 1999
//Description18 : 
//Notes18       : 
//----------------------------------------------------------------------
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


  module smc_wr_enable_lite18 (

                      //inputs18                      

                      n_sys_reset18,
                      r_full18,
                      n_r_we18,
                      n_r_wr18,

                      //outputs18

                      smc_n_we18,
                      smc_n_wr18);

//I18/O18
   
   input             n_sys_reset18;   //system reset
   input             r_full18;    // Full cycle write strobe18
   input [3:0]       n_r_we18;    //write enable from smc_strobe18
   input             n_r_wr18;    //write strobe18 from smc_strobe18
   output [3:0]      smc_n_we18;  // write enable (active low18)
   output            smc_n_wr18;  // write strobe18 (active low18)
   
   
//output reg declaration18.
   
   reg [3:0]          smc_n_we18;
   reg                smc_n_wr18;

//----------------------------------------------------------------------
// negedge strobes18 with clock18.
//----------------------------------------------------------------------
      

//----------------------------------------------------------------------
      
//--------------------------------------------------------------------
// Gate18 Write strobes18 with clock18.
//--------------------------------------------------------------------

  always @(r_full18 or n_r_we18)
  
  begin
  
     smc_n_we18[0] = ((~r_full18  ) | n_r_we18[0] );

     smc_n_we18[1] = ((~r_full18  ) | n_r_we18[1] );

     smc_n_we18[2] = ((~r_full18  ) | n_r_we18[2] );

     smc_n_we18[3] = ((~r_full18  ) | n_r_we18[3] );

  
  end

//--------------------------------------------------------------------   
//write strobe18 generation18
//--------------------------------------------------------------------   

  always @(n_r_wr18 or r_full18 )
  
     begin
  
        smc_n_wr18 = ((~r_full18 ) | n_r_wr18 );
       
     end

endmodule // smc_wr_enable18

