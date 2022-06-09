//File8 name   : alut_veneer8.v
//Title8       : 
//Created8     : 1999
//Description8 : 
//Notes8       : 
//----------------------------------------------------------------------
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------
module alut_veneer8
(   
   // Inputs8
   pclk8,
   n_p_reset8,
   psel8,            
   penable8,       
   pwrite8,         
   paddr8,           
   pwdata8,          

   // Outputs8
   prdata8  
);

   // APB8 Inputs8
   input             pclk8;               // APB8 clock8                          
   input             n_p_reset8;          // Reset8                              
   input             psel8;               // Module8 select8 signal8               
   input             penable8;            // Enable8 signal8                      
   input             pwrite8;             // Write when HIGH8 and read when LOW8  
   input [6:0]       paddr8;              // Address bus for read write         
   input [31:0]      pwdata8;             // APB8 write bus                      

   output [31:0]     prdata8;             // APB8 read bus                       


//-----------------------------------------------------------------------
//##############################################################################
// if the ALUT8 is NOT8 black8 boxed8 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_LUT8 


alut8 i_alut8 (
        //inputs8
        . n_p_reset8(n_p_reset8),
        . pclk8(pclk8),
        . psel8(psel8),
        . penable8(penable8),
        . pwrite8(pwrite8),
        . paddr8(paddr8[6:0]),
        . pwdata8(pwdata8),

        //outputs8
        . prdata8(prdata8)
);


`else 
//##############################################################################
// if the <module> is black8 boxed8 
//##############################################################################

   // APB8 Inputs8
   wire              pclk8;               // APB8 clock8                          
   wire              n_p_reset8;          // Reset8                              
   wire              psel8;               // Module8 select8 signal8               
   wire              penable8;            // Enable8 signal8                      
   wire              pwrite8;             // Write when HIGH8 and read when LOW8  
   wire  [6:0]       paddr8;              // Address bus for read write         
   wire  [31:0]      pwdata8;             // APB8 write bus                      

   reg   [31:0]      prdata8;             // APB8 read bus                       


`endif

endmodule
