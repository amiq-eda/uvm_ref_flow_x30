//File19 name   : alut_veneer19.v
//Title19       : 
//Created19     : 1999
//Description19 : 
//Notes19       : 
//----------------------------------------------------------------------
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------
module alut_veneer19
(   
   // Inputs19
   pclk19,
   n_p_reset19,
   psel19,            
   penable19,       
   pwrite19,         
   paddr19,           
   pwdata19,          

   // Outputs19
   prdata19  
);

   // APB19 Inputs19
   input             pclk19;               // APB19 clock19                          
   input             n_p_reset19;          // Reset19                              
   input             psel19;               // Module19 select19 signal19               
   input             penable19;            // Enable19 signal19                      
   input             pwrite19;             // Write when HIGH19 and read when LOW19  
   input [6:0]       paddr19;              // Address bus for read write         
   input [31:0]      pwdata19;             // APB19 write bus                      

   output [31:0]     prdata19;             // APB19 read bus                       


//-----------------------------------------------------------------------
//##############################################################################
// if the ALUT19 is NOT19 black19 boxed19 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_LUT19 


alut19 i_alut19 (
        //inputs19
        . n_p_reset19(n_p_reset19),
        . pclk19(pclk19),
        . psel19(psel19),
        . penable19(penable19),
        . pwrite19(pwrite19),
        . paddr19(paddr19[6:0]),
        . pwdata19(pwdata19),

        //outputs19
        . prdata19(prdata19)
);


`else 
//##############################################################################
// if the <module> is black19 boxed19 
//##############################################################################

   // APB19 Inputs19
   wire              pclk19;               // APB19 clock19                          
   wire              n_p_reset19;          // Reset19                              
   wire              psel19;               // Module19 select19 signal19               
   wire              penable19;            // Enable19 signal19                      
   wire              pwrite19;             // Write when HIGH19 and read when LOW19  
   wire  [6:0]       paddr19;              // Address bus for read write         
   wire  [31:0]      pwdata19;             // APB19 write bus                      

   reg   [31:0]      prdata19;             // APB19 read bus                       


`endif

endmodule
