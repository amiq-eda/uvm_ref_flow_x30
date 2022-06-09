//File17 name   : alut_veneer17.v
//Title17       : 
//Created17     : 1999
//Description17 : 
//Notes17       : 
//----------------------------------------------------------------------
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------
module alut_veneer17
(   
   // Inputs17
   pclk17,
   n_p_reset17,
   psel17,            
   penable17,       
   pwrite17,         
   paddr17,           
   pwdata17,          

   // Outputs17
   prdata17  
);

   // APB17 Inputs17
   input             pclk17;               // APB17 clock17                          
   input             n_p_reset17;          // Reset17                              
   input             psel17;               // Module17 select17 signal17               
   input             penable17;            // Enable17 signal17                      
   input             pwrite17;             // Write when HIGH17 and read when LOW17  
   input [6:0]       paddr17;              // Address bus for read write         
   input [31:0]      pwdata17;             // APB17 write bus                      

   output [31:0]     prdata17;             // APB17 read bus                       


//-----------------------------------------------------------------------
//##############################################################################
// if the ALUT17 is NOT17 black17 boxed17 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_LUT17 


alut17 i_alut17 (
        //inputs17
        . n_p_reset17(n_p_reset17),
        . pclk17(pclk17),
        . psel17(psel17),
        . penable17(penable17),
        . pwrite17(pwrite17),
        . paddr17(paddr17[6:0]),
        . pwdata17(pwdata17),

        //outputs17
        . prdata17(prdata17)
);


`else 
//##############################################################################
// if the <module> is black17 boxed17 
//##############################################################################

   // APB17 Inputs17
   wire              pclk17;               // APB17 clock17                          
   wire              n_p_reset17;          // Reset17                              
   wire              psel17;               // Module17 select17 signal17               
   wire              penable17;            // Enable17 signal17                      
   wire              pwrite17;             // Write when HIGH17 and read when LOW17  
   wire  [6:0]       paddr17;              // Address bus for read write         
   wire  [31:0]      pwdata17;             // APB17 write bus                      

   reg   [31:0]      prdata17;             // APB17 read bus                       


`endif

endmodule
