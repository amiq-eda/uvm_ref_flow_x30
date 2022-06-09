//File9 name   : alut_veneer9.v
//Title9       : 
//Created9     : 1999
//Description9 : 
//Notes9       : 
//----------------------------------------------------------------------
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------
module alut_veneer9
(   
   // Inputs9
   pclk9,
   n_p_reset9,
   psel9,            
   penable9,       
   pwrite9,         
   paddr9,           
   pwdata9,          

   // Outputs9
   prdata9  
);

   // APB9 Inputs9
   input             pclk9;               // APB9 clock9                          
   input             n_p_reset9;          // Reset9                              
   input             psel9;               // Module9 select9 signal9               
   input             penable9;            // Enable9 signal9                      
   input             pwrite9;             // Write when HIGH9 and read when LOW9  
   input [6:0]       paddr9;              // Address bus for read write         
   input [31:0]      pwdata9;             // APB9 write bus                      

   output [31:0]     prdata9;             // APB9 read bus                       


//-----------------------------------------------------------------------
//##############################################################################
// if the ALUT9 is NOT9 black9 boxed9 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_LUT9 


alut9 i_alut9 (
        //inputs9
        . n_p_reset9(n_p_reset9),
        . pclk9(pclk9),
        . psel9(psel9),
        . penable9(penable9),
        . pwrite9(pwrite9),
        . paddr9(paddr9[6:0]),
        . pwdata9(pwdata9),

        //outputs9
        . prdata9(prdata9)
);


`else 
//##############################################################################
// if the <module> is black9 boxed9 
//##############################################################################

   // APB9 Inputs9
   wire              pclk9;               // APB9 clock9                          
   wire              n_p_reset9;          // Reset9                              
   wire              psel9;               // Module9 select9 signal9               
   wire              penable9;            // Enable9 signal9                      
   wire              pwrite9;             // Write when HIGH9 and read when LOW9  
   wire  [6:0]       paddr9;              // Address bus for read write         
   wire  [31:0]      pwdata9;             // APB9 write bus                      

   reg   [31:0]      prdata9;             // APB9 read bus                       


`endif

endmodule
