//File20 name   : alut_veneer20.v
//Title20       : 
//Created20     : 1999
//Description20 : 
//Notes20       : 
//----------------------------------------------------------------------
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------
module alut_veneer20
(   
   // Inputs20
   pclk20,
   n_p_reset20,
   psel20,            
   penable20,       
   pwrite20,         
   paddr20,           
   pwdata20,          

   // Outputs20
   prdata20  
);

   // APB20 Inputs20
   input             pclk20;               // APB20 clock20                          
   input             n_p_reset20;          // Reset20                              
   input             psel20;               // Module20 select20 signal20               
   input             penable20;            // Enable20 signal20                      
   input             pwrite20;             // Write when HIGH20 and read when LOW20  
   input [6:0]       paddr20;              // Address bus for read write         
   input [31:0]      pwdata20;             // APB20 write bus                      

   output [31:0]     prdata20;             // APB20 read bus                       


//-----------------------------------------------------------------------
//##############################################################################
// if the ALUT20 is NOT20 black20 boxed20 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_LUT20 


alut20 i_alut20 (
        //inputs20
        . n_p_reset20(n_p_reset20),
        . pclk20(pclk20),
        . psel20(psel20),
        . penable20(penable20),
        . pwrite20(pwrite20),
        . paddr20(paddr20[6:0]),
        . pwdata20(pwdata20),

        //outputs20
        . prdata20(prdata20)
);


`else 
//##############################################################################
// if the <module> is black20 boxed20 
//##############################################################################

   // APB20 Inputs20
   wire              pclk20;               // APB20 clock20                          
   wire              n_p_reset20;          // Reset20                              
   wire              psel20;               // Module20 select20 signal20               
   wire              penable20;            // Enable20 signal20                      
   wire              pwrite20;             // Write when HIGH20 and read when LOW20  
   wire  [6:0]       paddr20;              // Address bus for read write         
   wire  [31:0]      pwdata20;             // APB20 write bus                      

   reg   [31:0]      prdata20;             // APB20 read bus                       


`endif

endmodule
