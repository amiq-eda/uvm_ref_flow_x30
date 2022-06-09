//File29 name   : smc_wr_enable_lite29.v
//Title29       : 
//Created29     : 1999
//Description29 : 
//Notes29       : 
//----------------------------------------------------------------------
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


  module smc_wr_enable_lite29 (

                      //inputs29                      

                      n_sys_reset29,
                      r_full29,
                      n_r_we29,
                      n_r_wr29,

                      //outputs29

                      smc_n_we29,
                      smc_n_wr29);

//I29/O29
   
   input             n_sys_reset29;   //system reset
   input             r_full29;    // Full cycle write strobe29
   input [3:0]       n_r_we29;    //write enable from smc_strobe29
   input             n_r_wr29;    //write strobe29 from smc_strobe29
   output [3:0]      smc_n_we29;  // write enable (active low29)
   output            smc_n_wr29;  // write strobe29 (active low29)
   
   
//output reg declaration29.
   
   reg [3:0]          smc_n_we29;
   reg                smc_n_wr29;

//----------------------------------------------------------------------
// negedge strobes29 with clock29.
//----------------------------------------------------------------------
      

//----------------------------------------------------------------------
      
//--------------------------------------------------------------------
// Gate29 Write strobes29 with clock29.
//--------------------------------------------------------------------

  always @(r_full29 or n_r_we29)
  
  begin
  
     smc_n_we29[0] = ((~r_full29  ) | n_r_we29[0] );

     smc_n_we29[1] = ((~r_full29  ) | n_r_we29[1] );

     smc_n_we29[2] = ((~r_full29  ) | n_r_we29[2] );

     smc_n_we29[3] = ((~r_full29  ) | n_r_we29[3] );

  
  end

//--------------------------------------------------------------------   
//write strobe29 generation29
//--------------------------------------------------------------------   

  always @(n_r_wr29 or r_full29 )
  
     begin
  
        smc_n_wr29 = ((~r_full29 ) | n_r_wr29 );
       
     end

endmodule // smc_wr_enable29

