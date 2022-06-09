//File3 name   : alut_veneer3.v
//Title3       : 
//Created3     : 1999
//Description3 : 
//Notes3       : 
//----------------------------------------------------------------------
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------
module alut_veneer3
(   
   // Inputs3
   pclk3,
   n_p_reset3,
   psel3,            
   penable3,       
   pwrite3,         
   paddr3,           
   pwdata3,          

   // Outputs3
   prdata3  
);

   // APB3 Inputs3
   input             pclk3;               // APB3 clock3                          
   input             n_p_reset3;          // Reset3                              
   input             psel3;               // Module3 select3 signal3               
   input             penable3;            // Enable3 signal3                      
   input             pwrite3;             // Write when HIGH3 and read when LOW3  
   input [6:0]       paddr3;              // Address bus for read write         
   input [31:0]      pwdata3;             // APB3 write bus                      

   output [31:0]     prdata3;             // APB3 read bus                       


//-----------------------------------------------------------------------
//##############################################################################
// if the ALUT3 is NOT3 black3 boxed3 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_LUT3 


alut3 i_alut3 (
        //inputs3
        . n_p_reset3(n_p_reset3),
        . pclk3(pclk3),
        . psel3(psel3),
        . penable3(penable3),
        . pwrite3(pwrite3),
        . paddr3(paddr3[6:0]),
        . pwdata3(pwdata3),

        //outputs3
        . prdata3(prdata3)
);


`else 
//##############################################################################
// if the <module> is black3 boxed3 
//##############################################################################

   // APB3 Inputs3
   wire              pclk3;               // APB3 clock3                          
   wire              n_p_reset3;          // Reset3                              
   wire              psel3;               // Module3 select3 signal3               
   wire              penable3;            // Enable3 signal3                      
   wire              pwrite3;             // Write when HIGH3 and read when LOW3  
   wire  [6:0]       paddr3;              // Address bus for read write         
   wire  [31:0]      pwdata3;             // APB3 write bus                      

   reg   [31:0]      prdata3;             // APB3 read bus                       


`endif

endmodule
