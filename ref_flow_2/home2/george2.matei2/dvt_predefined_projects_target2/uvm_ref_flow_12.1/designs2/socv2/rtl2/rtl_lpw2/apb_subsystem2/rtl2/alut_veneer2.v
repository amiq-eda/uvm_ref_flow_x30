//File2 name   : alut_veneer2.v
//Title2       : 
//Created2     : 1999
//Description2 : 
//Notes2       : 
//----------------------------------------------------------------------
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------
module alut_veneer2
(   
   // Inputs2
   pclk2,
   n_p_reset2,
   psel2,            
   penable2,       
   pwrite2,         
   paddr2,           
   pwdata2,          

   // Outputs2
   prdata2  
);

   // APB2 Inputs2
   input             pclk2;               // APB2 clock2                          
   input             n_p_reset2;          // Reset2                              
   input             psel2;               // Module2 select2 signal2               
   input             penable2;            // Enable2 signal2                      
   input             pwrite2;             // Write when HIGH2 and read when LOW2  
   input [6:0]       paddr2;              // Address bus for read write         
   input [31:0]      pwdata2;             // APB2 write bus                      

   output [31:0]     prdata2;             // APB2 read bus                       


//-----------------------------------------------------------------------
//##############################################################################
// if the ALUT2 is NOT2 black2 boxed2 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_LUT2 


alut2 i_alut2 (
        //inputs2
        . n_p_reset2(n_p_reset2),
        . pclk2(pclk2),
        . psel2(psel2),
        . penable2(penable2),
        . pwrite2(pwrite2),
        . paddr2(paddr2[6:0]),
        . pwdata2(pwdata2),

        //outputs2
        . prdata2(prdata2)
);


`else 
//##############################################################################
// if the <module> is black2 boxed2 
//##############################################################################

   // APB2 Inputs2
   wire              pclk2;               // APB2 clock2                          
   wire              n_p_reset2;          // Reset2                              
   wire              psel2;               // Module2 select2 signal2               
   wire              penable2;            // Enable2 signal2                      
   wire              pwrite2;             // Write when HIGH2 and read when LOW2  
   wire  [6:0]       paddr2;              // Address bus for read write         
   wire  [31:0]      pwdata2;             // APB2 write bus                      

   reg   [31:0]      prdata2;             // APB2 read bus                       


`endif

endmodule
