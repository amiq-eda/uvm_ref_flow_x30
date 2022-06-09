//File6 name   : alut_veneer6.v
//Title6       : 
//Created6     : 1999
//Description6 : 
//Notes6       : 
//----------------------------------------------------------------------
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------
module alut_veneer6
(   
   // Inputs6
   pclk6,
   n_p_reset6,
   psel6,            
   penable6,       
   pwrite6,         
   paddr6,           
   pwdata6,          

   // Outputs6
   prdata6  
);

   // APB6 Inputs6
   input             pclk6;               // APB6 clock6                          
   input             n_p_reset6;          // Reset6                              
   input             psel6;               // Module6 select6 signal6               
   input             penable6;            // Enable6 signal6                      
   input             pwrite6;             // Write when HIGH6 and read when LOW6  
   input [6:0]       paddr6;              // Address bus for read write         
   input [31:0]      pwdata6;             // APB6 write bus                      

   output [31:0]     prdata6;             // APB6 read bus                       


//-----------------------------------------------------------------------
//##############################################################################
// if the ALUT6 is NOT6 black6 boxed6 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_LUT6 


alut6 i_alut6 (
        //inputs6
        . n_p_reset6(n_p_reset6),
        . pclk6(pclk6),
        . psel6(psel6),
        . penable6(penable6),
        . pwrite6(pwrite6),
        . paddr6(paddr6[6:0]),
        . pwdata6(pwdata6),

        //outputs6
        . prdata6(prdata6)
);


`else 
//##############################################################################
// if the <module> is black6 boxed6 
//##############################################################################

   // APB6 Inputs6
   wire              pclk6;               // APB6 clock6                          
   wire              n_p_reset6;          // Reset6                              
   wire              psel6;               // Module6 select6 signal6               
   wire              penable6;            // Enable6 signal6                      
   wire              pwrite6;             // Write when HIGH6 and read when LOW6  
   wire  [6:0]       paddr6;              // Address bus for read write         
   wire  [31:0]      pwdata6;             // APB6 write bus                      

   reg   [31:0]      prdata6;             // APB6 read bus                       


`endif

endmodule
