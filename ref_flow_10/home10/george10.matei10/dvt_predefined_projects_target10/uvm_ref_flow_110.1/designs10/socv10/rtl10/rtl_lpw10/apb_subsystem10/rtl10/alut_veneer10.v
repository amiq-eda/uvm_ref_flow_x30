//File10 name   : alut_veneer10.v
//Title10       : 
//Created10     : 1999
//Description10 : 
//Notes10       : 
//----------------------------------------------------------------------
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------
module alut_veneer10
(   
   // Inputs10
   pclk10,
   n_p_reset10,
   psel10,            
   penable10,       
   pwrite10,         
   paddr10,           
   pwdata10,          

   // Outputs10
   prdata10  
);

   // APB10 Inputs10
   input             pclk10;               // APB10 clock10                          
   input             n_p_reset10;          // Reset10                              
   input             psel10;               // Module10 select10 signal10               
   input             penable10;            // Enable10 signal10                      
   input             pwrite10;             // Write when HIGH10 and read when LOW10  
   input [6:0]       paddr10;              // Address bus for read write         
   input [31:0]      pwdata10;             // APB10 write bus                      

   output [31:0]     prdata10;             // APB10 read bus                       


//-----------------------------------------------------------------------
//##############################################################################
// if the ALUT10 is NOT10 black10 boxed10 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_LUT10 


alut10 i_alut10 (
        //inputs10
        . n_p_reset10(n_p_reset10),
        . pclk10(pclk10),
        . psel10(psel10),
        . penable10(penable10),
        . pwrite10(pwrite10),
        . paddr10(paddr10[6:0]),
        . pwdata10(pwdata10),

        //outputs10
        . prdata10(prdata10)
);


`else 
//##############################################################################
// if the <module> is black10 boxed10 
//##############################################################################

   // APB10 Inputs10
   wire              pclk10;               // APB10 clock10                          
   wire              n_p_reset10;          // Reset10                              
   wire              psel10;               // Module10 select10 signal10               
   wire              penable10;            // Enable10 signal10                      
   wire              pwrite10;             // Write when HIGH10 and read when LOW10  
   wire  [6:0]       paddr10;              // Address bus for read write         
   wire  [31:0]      pwdata10;             // APB10 write bus                      

   reg   [31:0]      prdata10;             // APB10 read bus                       


`endif

endmodule
