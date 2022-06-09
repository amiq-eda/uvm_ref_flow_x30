//File22 name   : alut_veneer22.v
//Title22       : 
//Created22     : 1999
//Description22 : 
//Notes22       : 
//----------------------------------------------------------------------
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------
module alut_veneer22
(   
   // Inputs22
   pclk22,
   n_p_reset22,
   psel22,            
   penable22,       
   pwrite22,         
   paddr22,           
   pwdata22,          

   // Outputs22
   prdata22  
);

   // APB22 Inputs22
   input             pclk22;               // APB22 clock22                          
   input             n_p_reset22;          // Reset22                              
   input             psel22;               // Module22 select22 signal22               
   input             penable22;            // Enable22 signal22                      
   input             pwrite22;             // Write when HIGH22 and read when LOW22  
   input [6:0]       paddr22;              // Address bus for read write         
   input [31:0]      pwdata22;             // APB22 write bus                      

   output [31:0]     prdata22;             // APB22 read bus                       


//-----------------------------------------------------------------------
//##############################################################################
// if the ALUT22 is NOT22 black22 boxed22 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_LUT22 


alut22 i_alut22 (
        //inputs22
        . n_p_reset22(n_p_reset22),
        . pclk22(pclk22),
        . psel22(psel22),
        . penable22(penable22),
        . pwrite22(pwrite22),
        . paddr22(paddr22[6:0]),
        . pwdata22(pwdata22),

        //outputs22
        . prdata22(prdata22)
);


`else 
//##############################################################################
// if the <module> is black22 boxed22 
//##############################################################################

   // APB22 Inputs22
   wire              pclk22;               // APB22 clock22                          
   wire              n_p_reset22;          // Reset22                              
   wire              psel22;               // Module22 select22 signal22               
   wire              penable22;            // Enable22 signal22                      
   wire              pwrite22;             // Write when HIGH22 and read when LOW22  
   wire  [6:0]       paddr22;              // Address bus for read write         
   wire  [31:0]      pwdata22;             // APB22 write bus                      

   reg   [31:0]      prdata22;             // APB22 read bus                       


`endif

endmodule
