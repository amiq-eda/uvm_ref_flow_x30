//File28 name   : alut_veneer28.v
//Title28       : 
//Created28     : 1999
//Description28 : 
//Notes28       : 
//----------------------------------------------------------------------
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------
module alut_veneer28
(   
   // Inputs28
   pclk28,
   n_p_reset28,
   psel28,            
   penable28,       
   pwrite28,         
   paddr28,           
   pwdata28,          

   // Outputs28
   prdata28  
);

   // APB28 Inputs28
   input             pclk28;               // APB28 clock28                          
   input             n_p_reset28;          // Reset28                              
   input             psel28;               // Module28 select28 signal28               
   input             penable28;            // Enable28 signal28                      
   input             pwrite28;             // Write when HIGH28 and read when LOW28  
   input [6:0]       paddr28;              // Address bus for read write         
   input [31:0]      pwdata28;             // APB28 write bus                      

   output [31:0]     prdata28;             // APB28 read bus                       


//-----------------------------------------------------------------------
//##############################################################################
// if the ALUT28 is NOT28 black28 boxed28 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_LUT28 


alut28 i_alut28 (
        //inputs28
        . n_p_reset28(n_p_reset28),
        . pclk28(pclk28),
        . psel28(psel28),
        . penable28(penable28),
        . pwrite28(pwrite28),
        . paddr28(paddr28[6:0]),
        . pwdata28(pwdata28),

        //outputs28
        . prdata28(prdata28)
);


`else 
//##############################################################################
// if the <module> is black28 boxed28 
//##############################################################################

   // APB28 Inputs28
   wire              pclk28;               // APB28 clock28                          
   wire              n_p_reset28;          // Reset28                              
   wire              psel28;               // Module28 select28 signal28               
   wire              penable28;            // Enable28 signal28                      
   wire              pwrite28;             // Write when HIGH28 and read when LOW28  
   wire  [6:0]       paddr28;              // Address bus for read write         
   wire  [31:0]      pwdata28;             // APB28 write bus                      

   reg   [31:0]      prdata28;             // APB28 read bus                       


`endif

endmodule
