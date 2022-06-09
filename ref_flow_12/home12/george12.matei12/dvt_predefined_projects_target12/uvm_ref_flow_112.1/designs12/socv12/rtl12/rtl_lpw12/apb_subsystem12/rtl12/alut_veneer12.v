//File12 name   : alut_veneer12.v
//Title12       : 
//Created12     : 1999
//Description12 : 
//Notes12       : 
//----------------------------------------------------------------------
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------
module alut_veneer12
(   
   // Inputs12
   pclk12,
   n_p_reset12,
   psel12,            
   penable12,       
   pwrite12,         
   paddr12,           
   pwdata12,          

   // Outputs12
   prdata12  
);

   // APB12 Inputs12
   input             pclk12;               // APB12 clock12                          
   input             n_p_reset12;          // Reset12                              
   input             psel12;               // Module12 select12 signal12               
   input             penable12;            // Enable12 signal12                      
   input             pwrite12;             // Write when HIGH12 and read when LOW12  
   input [6:0]       paddr12;              // Address bus for read write         
   input [31:0]      pwdata12;             // APB12 write bus                      

   output [31:0]     prdata12;             // APB12 read bus                       


//-----------------------------------------------------------------------
//##############################################################################
// if the ALUT12 is NOT12 black12 boxed12 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_LUT12 


alut12 i_alut12 (
        //inputs12
        . n_p_reset12(n_p_reset12),
        . pclk12(pclk12),
        . psel12(psel12),
        . penable12(penable12),
        . pwrite12(pwrite12),
        . paddr12(paddr12[6:0]),
        . pwdata12(pwdata12),

        //outputs12
        . prdata12(prdata12)
);


`else 
//##############################################################################
// if the <module> is black12 boxed12 
//##############################################################################

   // APB12 Inputs12
   wire              pclk12;               // APB12 clock12                          
   wire              n_p_reset12;          // Reset12                              
   wire              psel12;               // Module12 select12 signal12               
   wire              penable12;            // Enable12 signal12                      
   wire              pwrite12;             // Write when HIGH12 and read when LOW12  
   wire  [6:0]       paddr12;              // Address bus for read write         
   wire  [31:0]      pwdata12;             // APB12 write bus                      

   reg   [31:0]      prdata12;             // APB12 read bus                       


`endif

endmodule
