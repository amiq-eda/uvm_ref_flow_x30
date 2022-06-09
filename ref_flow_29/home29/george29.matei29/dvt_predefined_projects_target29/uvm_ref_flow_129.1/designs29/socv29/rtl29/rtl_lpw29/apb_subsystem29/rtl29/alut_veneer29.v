//File29 name   : alut_veneer29.v
//Title29       : 
//Created29     : 1999
//Description29 : 
//Notes29       : 
//----------------------------------------------------------------------
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------
module alut_veneer29
(   
   // Inputs29
   pclk29,
   n_p_reset29,
   psel29,            
   penable29,       
   pwrite29,         
   paddr29,           
   pwdata29,          

   // Outputs29
   prdata29  
);

   // APB29 Inputs29
   input             pclk29;               // APB29 clock29                          
   input             n_p_reset29;          // Reset29                              
   input             psel29;               // Module29 select29 signal29               
   input             penable29;            // Enable29 signal29                      
   input             pwrite29;             // Write when HIGH29 and read when LOW29  
   input [6:0]       paddr29;              // Address bus for read write         
   input [31:0]      pwdata29;             // APB29 write bus                      

   output [31:0]     prdata29;             // APB29 read bus                       


//-----------------------------------------------------------------------
//##############################################################################
// if the ALUT29 is NOT29 black29 boxed29 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_LUT29 


alut29 i_alut29 (
        //inputs29
        . n_p_reset29(n_p_reset29),
        . pclk29(pclk29),
        . psel29(psel29),
        . penable29(penable29),
        . pwrite29(pwrite29),
        . paddr29(paddr29[6:0]),
        . pwdata29(pwdata29),

        //outputs29
        . prdata29(prdata29)
);


`else 
//##############################################################################
// if the <module> is black29 boxed29 
//##############################################################################

   // APB29 Inputs29
   wire              pclk29;               // APB29 clock29                          
   wire              n_p_reset29;          // Reset29                              
   wire              psel29;               // Module29 select29 signal29               
   wire              penable29;            // Enable29 signal29                      
   wire              pwrite29;             // Write when HIGH29 and read when LOW29  
   wire  [6:0]       paddr29;              // Address bus for read write         
   wire  [31:0]      pwdata29;             // APB29 write bus                      

   reg   [31:0]      prdata29;             // APB29 read bus                       


`endif

endmodule
