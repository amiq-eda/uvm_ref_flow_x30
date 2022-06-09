//File14 name   : alut_veneer14.v
//Title14       : 
//Created14     : 1999
//Description14 : 
//Notes14       : 
//----------------------------------------------------------------------
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------
module alut_veneer14
(   
   // Inputs14
   pclk14,
   n_p_reset14,
   psel14,            
   penable14,       
   pwrite14,         
   paddr14,           
   pwdata14,          

   // Outputs14
   prdata14  
);

   // APB14 Inputs14
   input             pclk14;               // APB14 clock14                          
   input             n_p_reset14;          // Reset14                              
   input             psel14;               // Module14 select14 signal14               
   input             penable14;            // Enable14 signal14                      
   input             pwrite14;             // Write when HIGH14 and read when LOW14  
   input [6:0]       paddr14;              // Address bus for read write         
   input [31:0]      pwdata14;             // APB14 write bus                      

   output [31:0]     prdata14;             // APB14 read bus                       


//-----------------------------------------------------------------------
//##############################################################################
// if the ALUT14 is NOT14 black14 boxed14 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_LUT14 


alut14 i_alut14 (
        //inputs14
        . n_p_reset14(n_p_reset14),
        . pclk14(pclk14),
        . psel14(psel14),
        . penable14(penable14),
        . pwrite14(pwrite14),
        . paddr14(paddr14[6:0]),
        . pwdata14(pwdata14),

        //outputs14
        . prdata14(prdata14)
);


`else 
//##############################################################################
// if the <module> is black14 boxed14 
//##############################################################################

   // APB14 Inputs14
   wire              pclk14;               // APB14 clock14                          
   wire              n_p_reset14;          // Reset14                              
   wire              psel14;               // Module14 select14 signal14               
   wire              penable14;            // Enable14 signal14                      
   wire              pwrite14;             // Write when HIGH14 and read when LOW14  
   wire  [6:0]       paddr14;              // Address bus for read write         
   wire  [31:0]      pwdata14;             // APB14 write bus                      

   reg   [31:0]      prdata14;             // APB14 read bus                       


`endif

endmodule
