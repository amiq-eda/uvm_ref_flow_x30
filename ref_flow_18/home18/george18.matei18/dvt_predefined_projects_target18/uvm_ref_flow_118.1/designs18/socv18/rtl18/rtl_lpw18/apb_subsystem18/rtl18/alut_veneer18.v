//File18 name   : alut_veneer18.v
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
module alut_veneer18
(   
   // Inputs18
   pclk18,
   n_p_reset18,
   psel18,            
   penable18,       
   pwrite18,         
   paddr18,           
   pwdata18,          

   // Outputs18
   prdata18  
);

   // APB18 Inputs18
   input             pclk18;               // APB18 clock18                          
   input             n_p_reset18;          // Reset18                              
   input             psel18;               // Module18 select18 signal18               
   input             penable18;            // Enable18 signal18                      
   input             pwrite18;             // Write when HIGH18 and read when LOW18  
   input [6:0]       paddr18;              // Address bus for read write         
   input [31:0]      pwdata18;             // APB18 write bus                      

   output [31:0]     prdata18;             // APB18 read bus                       


//-----------------------------------------------------------------------
//##############################################################################
// if the ALUT18 is NOT18 black18 boxed18 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_LUT18 


alut18 i_alut18 (
        //inputs18
        . n_p_reset18(n_p_reset18),
        . pclk18(pclk18),
        . psel18(psel18),
        . penable18(penable18),
        . pwrite18(pwrite18),
        . paddr18(paddr18[6:0]),
        . pwdata18(pwdata18),

        //outputs18
        . prdata18(prdata18)
);


`else 
//##############################################################################
// if the <module> is black18 boxed18 
//##############################################################################

   // APB18 Inputs18
   wire              pclk18;               // APB18 clock18                          
   wire              n_p_reset18;          // Reset18                              
   wire              psel18;               // Module18 select18 signal18               
   wire              penable18;            // Enable18 signal18                      
   wire              pwrite18;             // Write when HIGH18 and read when LOW18  
   wire  [6:0]       paddr18;              // Address bus for read write         
   wire  [31:0]      pwdata18;             // APB18 write bus                      

   reg   [31:0]      prdata18;             // APB18 read bus                       


`endif

endmodule
