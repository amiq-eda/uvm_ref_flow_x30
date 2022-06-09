//File4 name   : alut_veneer4.v
//Title4       : 
//Created4     : 1999
//Description4 : 
//Notes4       : 
//----------------------------------------------------------------------
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------
module alut_veneer4
(   
   // Inputs4
   pclk4,
   n_p_reset4,
   psel4,            
   penable4,       
   pwrite4,         
   paddr4,           
   pwdata4,          

   // Outputs4
   prdata4  
);

   // APB4 Inputs4
   input             pclk4;               // APB4 clock4                          
   input             n_p_reset4;          // Reset4                              
   input             psel4;               // Module4 select4 signal4               
   input             penable4;            // Enable4 signal4                      
   input             pwrite4;             // Write when HIGH4 and read when LOW4  
   input [6:0]       paddr4;              // Address bus for read write         
   input [31:0]      pwdata4;             // APB4 write bus                      

   output [31:0]     prdata4;             // APB4 read bus                       


//-----------------------------------------------------------------------
//##############################################################################
// if the ALUT4 is NOT4 black4 boxed4 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_LUT4 


alut4 i_alut4 (
        //inputs4
        . n_p_reset4(n_p_reset4),
        . pclk4(pclk4),
        . psel4(psel4),
        . penable4(penable4),
        . pwrite4(pwrite4),
        . paddr4(paddr4[6:0]),
        . pwdata4(pwdata4),

        //outputs4
        . prdata4(prdata4)
);


`else 
//##############################################################################
// if the <module> is black4 boxed4 
//##############################################################################

   // APB4 Inputs4
   wire              pclk4;               // APB4 clock4                          
   wire              n_p_reset4;          // Reset4                              
   wire              psel4;               // Module4 select4 signal4               
   wire              penable4;            // Enable4 signal4                      
   wire              pwrite4;             // Write when HIGH4 and read when LOW4  
   wire  [6:0]       paddr4;              // Address bus for read write         
   wire  [31:0]      pwdata4;             // APB4 write bus                      

   reg   [31:0]      prdata4;             // APB4 read bus                       


`endif

endmodule
