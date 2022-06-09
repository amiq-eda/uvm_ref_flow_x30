//File16 name   : alut_veneer16.v
//Title16       : 
//Created16     : 1999
//Description16 : 
//Notes16       : 
//----------------------------------------------------------------------
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------
module alut_veneer16
(   
   // Inputs16
   pclk16,
   n_p_reset16,
   psel16,            
   penable16,       
   pwrite16,         
   paddr16,           
   pwdata16,          

   // Outputs16
   prdata16  
);

   // APB16 Inputs16
   input             pclk16;               // APB16 clock16                          
   input             n_p_reset16;          // Reset16                              
   input             psel16;               // Module16 select16 signal16               
   input             penable16;            // Enable16 signal16                      
   input             pwrite16;             // Write when HIGH16 and read when LOW16  
   input [6:0]       paddr16;              // Address bus for read write         
   input [31:0]      pwdata16;             // APB16 write bus                      

   output [31:0]     prdata16;             // APB16 read bus                       


//-----------------------------------------------------------------------
//##############################################################################
// if the ALUT16 is NOT16 black16 boxed16 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_LUT16 


alut16 i_alut16 (
        //inputs16
        . n_p_reset16(n_p_reset16),
        . pclk16(pclk16),
        . psel16(psel16),
        . penable16(penable16),
        . pwrite16(pwrite16),
        . paddr16(paddr16[6:0]),
        . pwdata16(pwdata16),

        //outputs16
        . prdata16(prdata16)
);


`else 
//##############################################################################
// if the <module> is black16 boxed16 
//##############################################################################

   // APB16 Inputs16
   wire              pclk16;               // APB16 clock16                          
   wire              n_p_reset16;          // Reset16                              
   wire              psel16;               // Module16 select16 signal16               
   wire              penable16;            // Enable16 signal16                      
   wire              pwrite16;             // Write when HIGH16 and read when LOW16  
   wire  [6:0]       paddr16;              // Address bus for read write         
   wire  [31:0]      pwdata16;             // APB16 write bus                      

   reg   [31:0]      prdata16;             // APB16 read bus                       


`endif

endmodule
