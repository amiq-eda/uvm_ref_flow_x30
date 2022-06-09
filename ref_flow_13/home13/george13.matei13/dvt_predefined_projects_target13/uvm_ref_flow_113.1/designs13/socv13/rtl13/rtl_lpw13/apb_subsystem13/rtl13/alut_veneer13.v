//File13 name   : alut_veneer13.v
//Title13       : 
//Created13     : 1999
//Description13 : 
//Notes13       : 
//----------------------------------------------------------------------
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------
module alut_veneer13
(   
   // Inputs13
   pclk13,
   n_p_reset13,
   psel13,            
   penable13,       
   pwrite13,         
   paddr13,           
   pwdata13,          

   // Outputs13
   prdata13  
);

   // APB13 Inputs13
   input             pclk13;               // APB13 clock13                          
   input             n_p_reset13;          // Reset13                              
   input             psel13;               // Module13 select13 signal13               
   input             penable13;            // Enable13 signal13                      
   input             pwrite13;             // Write when HIGH13 and read when LOW13  
   input [6:0]       paddr13;              // Address bus for read write         
   input [31:0]      pwdata13;             // APB13 write bus                      

   output [31:0]     prdata13;             // APB13 read bus                       


//-----------------------------------------------------------------------
//##############################################################################
// if the ALUT13 is NOT13 black13 boxed13 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_LUT13 


alut13 i_alut13 (
        //inputs13
        . n_p_reset13(n_p_reset13),
        . pclk13(pclk13),
        . psel13(psel13),
        . penable13(penable13),
        . pwrite13(pwrite13),
        . paddr13(paddr13[6:0]),
        . pwdata13(pwdata13),

        //outputs13
        . prdata13(prdata13)
);


`else 
//##############################################################################
// if the <module> is black13 boxed13 
//##############################################################################

   // APB13 Inputs13
   wire              pclk13;               // APB13 clock13                          
   wire              n_p_reset13;          // Reset13                              
   wire              psel13;               // Module13 select13 signal13               
   wire              penable13;            // Enable13 signal13                      
   wire              pwrite13;             // Write when HIGH13 and read when LOW13  
   wire  [6:0]       paddr13;              // Address bus for read write         
   wire  [31:0]      pwdata13;             // APB13 write bus                      

   reg   [31:0]      prdata13;             // APB13 read bus                       


`endif

endmodule
