//File7 name   : alut_veneer7.v
//Title7       : 
//Created7     : 1999
//Description7 : 
//Notes7       : 
//----------------------------------------------------------------------
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------
module alut_veneer7
(   
   // Inputs7
   pclk7,
   n_p_reset7,
   psel7,            
   penable7,       
   pwrite7,         
   paddr7,           
   pwdata7,          

   // Outputs7
   prdata7  
);

   // APB7 Inputs7
   input             pclk7;               // APB7 clock7                          
   input             n_p_reset7;          // Reset7                              
   input             psel7;               // Module7 select7 signal7               
   input             penable7;            // Enable7 signal7                      
   input             pwrite7;             // Write when HIGH7 and read when LOW7  
   input [6:0]       paddr7;              // Address bus for read write         
   input [31:0]      pwdata7;             // APB7 write bus                      

   output [31:0]     prdata7;             // APB7 read bus                       


//-----------------------------------------------------------------------
//##############################################################################
// if the ALUT7 is NOT7 black7 boxed7 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_LUT7 


alut7 i_alut7 (
        //inputs7
        . n_p_reset7(n_p_reset7),
        . pclk7(pclk7),
        . psel7(psel7),
        . penable7(penable7),
        . pwrite7(pwrite7),
        . paddr7(paddr7[6:0]),
        . pwdata7(pwdata7),

        //outputs7
        . prdata7(prdata7)
);


`else 
//##############################################################################
// if the <module> is black7 boxed7 
//##############################################################################

   // APB7 Inputs7
   wire              pclk7;               // APB7 clock7                          
   wire              n_p_reset7;          // Reset7                              
   wire              psel7;               // Module7 select7 signal7               
   wire              penable7;            // Enable7 signal7                      
   wire              pwrite7;             // Write when HIGH7 and read when LOW7  
   wire  [6:0]       paddr7;              // Address bus for read write         
   wire  [31:0]      pwdata7;             // APB7 write bus                      

   reg   [31:0]      prdata7;             // APB7 read bus                       


`endif

endmodule
