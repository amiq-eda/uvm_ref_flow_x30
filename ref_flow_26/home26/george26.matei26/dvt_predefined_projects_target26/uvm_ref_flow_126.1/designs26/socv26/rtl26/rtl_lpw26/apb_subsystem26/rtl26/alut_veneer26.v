//File26 name   : alut_veneer26.v
//Title26       : 
//Created26     : 1999
//Description26 : 
//Notes26       : 
//----------------------------------------------------------------------
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------
module alut_veneer26
(   
   // Inputs26
   pclk26,
   n_p_reset26,
   psel26,            
   penable26,       
   pwrite26,         
   paddr26,           
   pwdata26,          

   // Outputs26
   prdata26  
);

   // APB26 Inputs26
   input             pclk26;               // APB26 clock26                          
   input             n_p_reset26;          // Reset26                              
   input             psel26;               // Module26 select26 signal26               
   input             penable26;            // Enable26 signal26                      
   input             pwrite26;             // Write when HIGH26 and read when LOW26  
   input [6:0]       paddr26;              // Address bus for read write         
   input [31:0]      pwdata26;             // APB26 write bus                      

   output [31:0]     prdata26;             // APB26 read bus                       


//-----------------------------------------------------------------------
//##############################################################################
// if the ALUT26 is NOT26 black26 boxed26 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_LUT26 


alut26 i_alut26 (
        //inputs26
        . n_p_reset26(n_p_reset26),
        . pclk26(pclk26),
        . psel26(psel26),
        . penable26(penable26),
        . pwrite26(pwrite26),
        . paddr26(paddr26[6:0]),
        . pwdata26(pwdata26),

        //outputs26
        . prdata26(prdata26)
);


`else 
//##############################################################################
// if the <module> is black26 boxed26 
//##############################################################################

   // APB26 Inputs26
   wire              pclk26;               // APB26 clock26                          
   wire              n_p_reset26;          // Reset26                              
   wire              psel26;               // Module26 select26 signal26               
   wire              penable26;            // Enable26 signal26                      
   wire              pwrite26;             // Write when HIGH26 and read when LOW26  
   wire  [6:0]       paddr26;              // Address bus for read write         
   wire  [31:0]      pwdata26;             // APB26 write bus                      

   reg   [31:0]      prdata26;             // APB26 read bus                       


`endif

endmodule
