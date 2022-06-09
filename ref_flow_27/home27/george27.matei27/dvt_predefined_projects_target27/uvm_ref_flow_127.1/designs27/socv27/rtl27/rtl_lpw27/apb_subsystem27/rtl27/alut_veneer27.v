//File27 name   : alut_veneer27.v
//Title27       : 
//Created27     : 1999
//Description27 : 
//Notes27       : 
//----------------------------------------------------------------------
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------
module alut_veneer27
(   
   // Inputs27
   pclk27,
   n_p_reset27,
   psel27,            
   penable27,       
   pwrite27,         
   paddr27,           
   pwdata27,          

   // Outputs27
   prdata27  
);

   // APB27 Inputs27
   input             pclk27;               // APB27 clock27                          
   input             n_p_reset27;          // Reset27                              
   input             psel27;               // Module27 select27 signal27               
   input             penable27;            // Enable27 signal27                      
   input             pwrite27;             // Write when HIGH27 and read when LOW27  
   input [6:0]       paddr27;              // Address bus for read write         
   input [31:0]      pwdata27;             // APB27 write bus                      

   output [31:0]     prdata27;             // APB27 read bus                       


//-----------------------------------------------------------------------
//##############################################################################
// if the ALUT27 is NOT27 black27 boxed27 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_LUT27 


alut27 i_alut27 (
        //inputs27
        . n_p_reset27(n_p_reset27),
        . pclk27(pclk27),
        . psel27(psel27),
        . penable27(penable27),
        . pwrite27(pwrite27),
        . paddr27(paddr27[6:0]),
        . pwdata27(pwdata27),

        //outputs27
        . prdata27(prdata27)
);


`else 
//##############################################################################
// if the <module> is black27 boxed27 
//##############################################################################

   // APB27 Inputs27
   wire              pclk27;               // APB27 clock27                          
   wire              n_p_reset27;          // Reset27                              
   wire              psel27;               // Module27 select27 signal27               
   wire              penable27;            // Enable27 signal27                      
   wire              pwrite27;             // Write when HIGH27 and read when LOW27  
   wire  [6:0]       paddr27;              // Address bus for read write         
   wire  [31:0]      pwdata27;             // APB27 write bus                      

   reg   [31:0]      prdata27;             // APB27 read bus                       


`endif

endmodule
