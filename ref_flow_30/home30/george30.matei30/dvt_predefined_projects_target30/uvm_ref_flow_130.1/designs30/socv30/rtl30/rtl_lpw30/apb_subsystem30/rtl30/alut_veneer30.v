//File30 name   : alut_veneer30.v
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
module alut_veneer30
(   
   // Inputs30
   pclk30,
   n_p_reset30,
   psel30,            
   penable30,       
   pwrite30,         
   paddr30,           
   pwdata30,          

   // Outputs30
   prdata30  
);

   // APB30 Inputs30
   input             pclk30;               // APB30 clock30                          
   input             n_p_reset30;          // Reset30                              
   input             psel30;               // Module30 select30 signal30               
   input             penable30;            // Enable30 signal30                      
   input             pwrite30;             // Write when HIGH30 and read when LOW30  
   input [6:0]       paddr30;              // Address bus for read write         
   input [31:0]      pwdata30;             // APB30 write bus                      

   output [31:0]     prdata30;             // APB30 read bus                       


//-----------------------------------------------------------------------
//##############################################################################
// if the ALUT30 is NOT30 black30 boxed30 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_LUT30 


alut30 i_alut30 (
        //inputs30
        . n_p_reset30(n_p_reset30),
        . pclk30(pclk30),
        . psel30(psel30),
        . penable30(penable30),
        . pwrite30(pwrite30),
        . paddr30(paddr30[6:0]),
        . pwdata30(pwdata30),

        //outputs30
        . prdata30(prdata30)
);


`else 
//##############################################################################
// if the <module> is black30 boxed30 
//##############################################################################

   // APB30 Inputs30
   wire              pclk30;               // APB30 clock30                          
   wire              n_p_reset30;          // Reset30                              
   wire              psel30;               // Module30 select30 signal30               
   wire              penable30;            // Enable30 signal30                      
   wire              pwrite30;             // Write when HIGH30 and read when LOW30  
   wire  [6:0]       paddr30;              // Address bus for read write         
   wire  [31:0]      pwdata30;             // APB30 write bus                      

   reg   [31:0]      prdata30;             // APB30 read bus                       


`endif

endmodule
