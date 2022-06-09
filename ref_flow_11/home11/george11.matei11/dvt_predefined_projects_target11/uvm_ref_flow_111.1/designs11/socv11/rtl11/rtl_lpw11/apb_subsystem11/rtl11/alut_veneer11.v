//File11 name   : alut_veneer11.v
//Title11       : 
//Created11     : 1999
//Description11 : 
//Notes11       : 
//----------------------------------------------------------------------
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------
module alut_veneer11
(   
   // Inputs11
   pclk11,
   n_p_reset11,
   psel11,            
   penable11,       
   pwrite11,         
   paddr11,           
   pwdata11,          

   // Outputs11
   prdata11  
);

   // APB11 Inputs11
   input             pclk11;               // APB11 clock11                          
   input             n_p_reset11;          // Reset11                              
   input             psel11;               // Module11 select11 signal11               
   input             penable11;            // Enable11 signal11                      
   input             pwrite11;             // Write when HIGH11 and read when LOW11  
   input [6:0]       paddr11;              // Address bus for read write         
   input [31:0]      pwdata11;             // APB11 write bus                      

   output [31:0]     prdata11;             // APB11 read bus                       


//-----------------------------------------------------------------------
//##############################################################################
// if the ALUT11 is NOT11 black11 boxed11 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_LUT11 


alut11 i_alut11 (
        //inputs11
        . n_p_reset11(n_p_reset11),
        . pclk11(pclk11),
        . psel11(psel11),
        . penable11(penable11),
        . pwrite11(pwrite11),
        . paddr11(paddr11[6:0]),
        . pwdata11(pwdata11),

        //outputs11
        . prdata11(prdata11)
);


`else 
//##############################################################################
// if the <module> is black11 boxed11 
//##############################################################################

   // APB11 Inputs11
   wire              pclk11;               // APB11 clock11                          
   wire              n_p_reset11;          // Reset11                              
   wire              psel11;               // Module11 select11 signal11               
   wire              penable11;            // Enable11 signal11                      
   wire              pwrite11;             // Write when HIGH11 and read when LOW11  
   wire  [6:0]       paddr11;              // Address bus for read write         
   wire  [31:0]      pwdata11;             // APB11 write bus                      

   reg   [31:0]      prdata11;             // APB11 read bus                       


`endif

endmodule
