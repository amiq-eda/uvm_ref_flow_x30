//File5 name   : alut_veneer5.v
//Title5       : 
//Created5     : 1999
//Description5 : 
//Notes5       : 
//----------------------------------------------------------------------
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------
module alut_veneer5
(   
   // Inputs5
   pclk5,
   n_p_reset5,
   psel5,            
   penable5,       
   pwrite5,         
   paddr5,           
   pwdata5,          

   // Outputs5
   prdata5  
);

   // APB5 Inputs5
   input             pclk5;               // APB5 clock5                          
   input             n_p_reset5;          // Reset5                              
   input             psel5;               // Module5 select5 signal5               
   input             penable5;            // Enable5 signal5                      
   input             pwrite5;             // Write when HIGH5 and read when LOW5  
   input [6:0]       paddr5;              // Address bus for read write         
   input [31:0]      pwdata5;             // APB5 write bus                      

   output [31:0]     prdata5;             // APB5 read bus                       


//-----------------------------------------------------------------------
//##############################################################################
// if the ALUT5 is NOT5 black5 boxed5 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_LUT5 


alut5 i_alut5 (
        //inputs5
        . n_p_reset5(n_p_reset5),
        . pclk5(pclk5),
        . psel5(psel5),
        . penable5(penable5),
        . pwrite5(pwrite5),
        . paddr5(paddr5[6:0]),
        . pwdata5(pwdata5),

        //outputs5
        . prdata5(prdata5)
);


`else 
//##############################################################################
// if the <module> is black5 boxed5 
//##############################################################################

   // APB5 Inputs5
   wire              pclk5;               // APB5 clock5                          
   wire              n_p_reset5;          // Reset5                              
   wire              psel5;               // Module5 select5 signal5               
   wire              penable5;            // Enable5 signal5                      
   wire              pwrite5;             // Write when HIGH5 and read when LOW5  
   wire  [6:0]       paddr5;              // Address bus for read write         
   wire  [31:0]      pwdata5;             // APB5 write bus                      

   reg   [31:0]      prdata5;             // APB5 read bus                       


`endif

endmodule
