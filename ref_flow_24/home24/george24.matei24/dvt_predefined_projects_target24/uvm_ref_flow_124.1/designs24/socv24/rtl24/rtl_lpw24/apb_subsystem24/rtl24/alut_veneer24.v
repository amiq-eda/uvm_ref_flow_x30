//File24 name   : alut_veneer24.v
//Title24       : 
//Created24     : 1999
//Description24 : 
//Notes24       : 
//----------------------------------------------------------------------
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------
module alut_veneer24
(   
   // Inputs24
   pclk24,
   n_p_reset24,
   psel24,            
   penable24,       
   pwrite24,         
   paddr24,           
   pwdata24,          

   // Outputs24
   prdata24  
);

   // APB24 Inputs24
   input             pclk24;               // APB24 clock24                          
   input             n_p_reset24;          // Reset24                              
   input             psel24;               // Module24 select24 signal24               
   input             penable24;            // Enable24 signal24                      
   input             pwrite24;             // Write when HIGH24 and read when LOW24  
   input [6:0]       paddr24;              // Address bus for read write         
   input [31:0]      pwdata24;             // APB24 write bus                      

   output [31:0]     prdata24;             // APB24 read bus                       


//-----------------------------------------------------------------------
//##############################################################################
// if the ALUT24 is NOT24 black24 boxed24 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_LUT24 


alut24 i_alut24 (
        //inputs24
        . n_p_reset24(n_p_reset24),
        . pclk24(pclk24),
        . psel24(psel24),
        . penable24(penable24),
        . pwrite24(pwrite24),
        . paddr24(paddr24[6:0]),
        . pwdata24(pwdata24),

        //outputs24
        . prdata24(prdata24)
);


`else 
//##############################################################################
// if the <module> is black24 boxed24 
//##############################################################################

   // APB24 Inputs24
   wire              pclk24;               // APB24 clock24                          
   wire              n_p_reset24;          // Reset24                              
   wire              psel24;               // Module24 select24 signal24               
   wire              penable24;            // Enable24 signal24                      
   wire              pwrite24;             // Write when HIGH24 and read when LOW24  
   wire  [6:0]       paddr24;              // Address bus for read write         
   wire  [31:0]      pwdata24;             // APB24 write bus                      

   reg   [31:0]      prdata24;             // APB24 read bus                       


`endif

endmodule
