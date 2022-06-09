//File15 name   : alut_veneer15.v
//Title15       : 
//Created15     : 1999
//Description15 : 
//Notes15       : 
//----------------------------------------------------------------------
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------
module alut_veneer15
(   
   // Inputs15
   pclk15,
   n_p_reset15,
   psel15,            
   penable15,       
   pwrite15,         
   paddr15,           
   pwdata15,          

   // Outputs15
   prdata15  
);

   // APB15 Inputs15
   input             pclk15;               // APB15 clock15                          
   input             n_p_reset15;          // Reset15                              
   input             psel15;               // Module15 select15 signal15               
   input             penable15;            // Enable15 signal15                      
   input             pwrite15;             // Write when HIGH15 and read when LOW15  
   input [6:0]       paddr15;              // Address bus for read write         
   input [31:0]      pwdata15;             // APB15 write bus                      

   output [31:0]     prdata15;             // APB15 read bus                       


//-----------------------------------------------------------------------
//##############################################################################
// if the ALUT15 is NOT15 black15 boxed15 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_LUT15 


alut15 i_alut15 (
        //inputs15
        . n_p_reset15(n_p_reset15),
        . pclk15(pclk15),
        . psel15(psel15),
        . penable15(penable15),
        . pwrite15(pwrite15),
        . paddr15(paddr15[6:0]),
        . pwdata15(pwdata15),

        //outputs15
        . prdata15(prdata15)
);


`else 
//##############################################################################
// if the <module> is black15 boxed15 
//##############################################################################

   // APB15 Inputs15
   wire              pclk15;               // APB15 clock15                          
   wire              n_p_reset15;          // Reset15                              
   wire              psel15;               // Module15 select15 signal15               
   wire              penable15;            // Enable15 signal15                      
   wire              pwrite15;             // Write when HIGH15 and read when LOW15  
   wire  [6:0]       paddr15;              // Address bus for read write         
   wire  [31:0]      pwdata15;             // APB15 write bus                      

   reg   [31:0]      prdata15;             // APB15 read bus                       


`endif

endmodule
