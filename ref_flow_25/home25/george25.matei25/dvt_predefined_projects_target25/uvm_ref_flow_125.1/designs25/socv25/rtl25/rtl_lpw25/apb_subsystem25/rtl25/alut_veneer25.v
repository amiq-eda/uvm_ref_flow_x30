//File25 name   : alut_veneer25.v
//Title25       : 
//Created25     : 1999
//Description25 : 
//Notes25       : 
//----------------------------------------------------------------------
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------
module alut_veneer25
(   
   // Inputs25
   pclk25,
   n_p_reset25,
   psel25,            
   penable25,       
   pwrite25,         
   paddr25,           
   pwdata25,          

   // Outputs25
   prdata25  
);

   // APB25 Inputs25
   input             pclk25;               // APB25 clock25                          
   input             n_p_reset25;          // Reset25                              
   input             psel25;               // Module25 select25 signal25               
   input             penable25;            // Enable25 signal25                      
   input             pwrite25;             // Write when HIGH25 and read when LOW25  
   input [6:0]       paddr25;              // Address bus for read write         
   input [31:0]      pwdata25;             // APB25 write bus                      

   output [31:0]     prdata25;             // APB25 read bus                       


//-----------------------------------------------------------------------
//##############################################################################
// if the ALUT25 is NOT25 black25 boxed25 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_LUT25 


alut25 i_alut25 (
        //inputs25
        . n_p_reset25(n_p_reset25),
        . pclk25(pclk25),
        . psel25(psel25),
        . penable25(penable25),
        . pwrite25(pwrite25),
        . paddr25(paddr25[6:0]),
        . pwdata25(pwdata25),

        //outputs25
        . prdata25(prdata25)
);


`else 
//##############################################################################
// if the <module> is black25 boxed25 
//##############################################################################

   // APB25 Inputs25
   wire              pclk25;               // APB25 clock25                          
   wire              n_p_reset25;          // Reset25                              
   wire              psel25;               // Module25 select25 signal25               
   wire              penable25;            // Enable25 signal25                      
   wire              pwrite25;             // Write when HIGH25 and read when LOW25  
   wire  [6:0]       paddr25;              // Address bus for read write         
   wire  [31:0]      pwdata25;             // APB25 write bus                      

   reg   [31:0]      prdata25;             // APB25 read bus                       


`endif

endmodule
