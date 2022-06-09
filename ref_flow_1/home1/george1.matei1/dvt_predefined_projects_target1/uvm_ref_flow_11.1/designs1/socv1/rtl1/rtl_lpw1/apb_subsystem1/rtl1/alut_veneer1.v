//File1 name   : alut_veneer1.v
//Title1       : 
//Created1     : 1999
//Description1 : 
//Notes1       : 
//----------------------------------------------------------------------
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------
module alut_veneer1
(   
   // Inputs1
   pclk1,
   n_p_reset1,
   psel1,            
   penable1,       
   pwrite1,         
   paddr1,           
   pwdata1,          

   // Outputs1
   prdata1  
);

   // APB1 Inputs1
   input             pclk1;               // APB1 clock1                          
   input             n_p_reset1;          // Reset1                              
   input             psel1;               // Module1 select1 signal1               
   input             penable1;            // Enable1 signal1                      
   input             pwrite1;             // Write when HIGH1 and read when LOW1  
   input [6:0]       paddr1;              // Address bus for read write         
   input [31:0]      pwdata1;             // APB1 write bus                      

   output [31:0]     prdata1;             // APB1 read bus                       


//-----------------------------------------------------------------------
//##############################################################################
// if the ALUT1 is NOT1 black1 boxed1 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_LUT1 


alut1 i_alut1 (
        //inputs1
        . n_p_reset1(n_p_reset1),
        . pclk1(pclk1),
        . psel1(psel1),
        . penable1(penable1),
        . pwrite1(pwrite1),
        . paddr1(paddr1[6:0]),
        . pwdata1(pwdata1),

        //outputs1
        . prdata1(prdata1)
);


`else 
//##############################################################################
// if the <module> is black1 boxed1 
//##############################################################################

   // APB1 Inputs1
   wire              pclk1;               // APB1 clock1                          
   wire              n_p_reset1;          // Reset1                              
   wire              psel1;               // Module1 select1 signal1               
   wire              penable1;            // Enable1 signal1                      
   wire              pwrite1;             // Write when HIGH1 and read when LOW1  
   wire  [6:0]       paddr1;              // Address bus for read write         
   wire  [31:0]      pwdata1;             // APB1 write bus                      

   reg   [31:0]      prdata1;             // APB1 read bus                       


`endif

endmodule
