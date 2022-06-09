//File23 name   : alut_veneer23.v
//Title23       : 
//Created23     : 1999
//Description23 : 
//Notes23       : 
//----------------------------------------------------------------------
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------
module alut_veneer23
(   
   // Inputs23
   pclk23,
   n_p_reset23,
   psel23,            
   penable23,       
   pwrite23,         
   paddr23,           
   pwdata23,          

   // Outputs23
   prdata23  
);

   // APB23 Inputs23
   input             pclk23;               // APB23 clock23                          
   input             n_p_reset23;          // Reset23                              
   input             psel23;               // Module23 select23 signal23               
   input             penable23;            // Enable23 signal23                      
   input             pwrite23;             // Write when HIGH23 and read when LOW23  
   input [6:0]       paddr23;              // Address bus for read write         
   input [31:0]      pwdata23;             // APB23 write bus                      

   output [31:0]     prdata23;             // APB23 read bus                       


//-----------------------------------------------------------------------
//##############################################################################
// if the ALUT23 is NOT23 black23 boxed23 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_LUT23 


alut23 i_alut23 (
        //inputs23
        . n_p_reset23(n_p_reset23),
        . pclk23(pclk23),
        . psel23(psel23),
        . penable23(penable23),
        . pwrite23(pwrite23),
        . paddr23(paddr23[6:0]),
        . pwdata23(pwdata23),

        //outputs23
        . prdata23(prdata23)
);


`else 
//##############################################################################
// if the <module> is black23 boxed23 
//##############################################################################

   // APB23 Inputs23
   wire              pclk23;               // APB23 clock23                          
   wire              n_p_reset23;          // Reset23                              
   wire              psel23;               // Module23 select23 signal23               
   wire              penable23;            // Enable23 signal23                      
   wire              pwrite23;             // Write when HIGH23 and read when LOW23  
   wire  [6:0]       paddr23;              // Address bus for read write         
   wire  [31:0]      pwdata23;             // APB23 write bus                      

   reg   [31:0]      prdata23;             // APB23 read bus                       


`endif

endmodule
