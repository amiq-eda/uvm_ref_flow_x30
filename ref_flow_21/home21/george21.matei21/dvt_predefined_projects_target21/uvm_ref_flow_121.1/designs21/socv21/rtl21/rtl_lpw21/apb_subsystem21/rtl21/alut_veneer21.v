//File21 name   : alut_veneer21.v
//Title21       : 
//Created21     : 1999
//Description21 : 
//Notes21       : 
//----------------------------------------------------------------------
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------
module alut_veneer21
(   
   // Inputs21
   pclk21,
   n_p_reset21,
   psel21,            
   penable21,       
   pwrite21,         
   paddr21,           
   pwdata21,          

   // Outputs21
   prdata21  
);

   // APB21 Inputs21
   input             pclk21;               // APB21 clock21                          
   input             n_p_reset21;          // Reset21                              
   input             psel21;               // Module21 select21 signal21               
   input             penable21;            // Enable21 signal21                      
   input             pwrite21;             // Write when HIGH21 and read when LOW21  
   input [6:0]       paddr21;              // Address bus for read write         
   input [31:0]      pwdata21;             // APB21 write bus                      

   output [31:0]     prdata21;             // APB21 read bus                       


//-----------------------------------------------------------------------
//##############################################################################
// if the ALUT21 is NOT21 black21 boxed21 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_LUT21 


alut21 i_alut21 (
        //inputs21
        . n_p_reset21(n_p_reset21),
        . pclk21(pclk21),
        . psel21(psel21),
        . penable21(penable21),
        . pwrite21(pwrite21),
        . paddr21(paddr21[6:0]),
        . pwdata21(pwdata21),

        //outputs21
        . prdata21(prdata21)
);


`else 
//##############################################################################
// if the <module> is black21 boxed21 
//##############################################################################

   // APB21 Inputs21
   wire              pclk21;               // APB21 clock21                          
   wire              n_p_reset21;          // Reset21                              
   wire              psel21;               // Module21 select21 signal21               
   wire              penable21;            // Enable21 signal21                      
   wire              pwrite21;             // Write when HIGH21 and read when LOW21  
   wire  [6:0]       paddr21;              // Address bus for read write         
   wire  [31:0]      pwdata21;             // APB21 write bus                      

   reg   [31:0]      prdata21;             // APB21 read bus                       


`endif

endmodule
