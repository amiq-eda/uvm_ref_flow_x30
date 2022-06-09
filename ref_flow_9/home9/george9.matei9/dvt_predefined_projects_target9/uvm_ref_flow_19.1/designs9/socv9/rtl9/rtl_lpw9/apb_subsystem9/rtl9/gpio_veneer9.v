//File9 name   : gpio_veneer9.v
//Title9       : 
//Created9     : 1999
//Description9 : 
//Notes9       : 
//----------------------------------------------------------------------
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------

module gpio_veneer9 ( 
              //inputs9 
 
              n_p_reset9, 
              pclk9, 

              psel9, 
              penable9, 
              pwrite9, 
              paddr9, 
              pwdata9, 

              gpio_pin_in9, 

              scan_en9, 
              tri_state_enable9, 

              scan_in9, //added by smarkov9 for dft9
 
              //outputs9
              
              scan_out9, //added by smarkov9 for dft9 
               
              prdata9, 

              gpio_int9, 

              n_gpio_pin_oe9, 
              gpio_pin_out9 
); 
 
//Numeric9 constants9


   // inputs9 
    
   // pclks9  
   input        n_p_reset9;            // amba9 reset 
   input        pclk9;               // peripherical9 pclk9 bus 

   // AMBA9 Rev9 2
   input        psel9;               // peripheral9 select9 for gpio9 
   input        penable9;            // peripheral9 enable 
   input        pwrite9;             // peripheral9 write strobe9 
   input [5:0] 
                paddr9;              // address bus of selected master9 
   input [31:0] 
                pwdata9;             // write data 

   // gpio9 generic9 inputs9 
   input [15:0] 
                gpio_pin_in9;             // input data from pin9 

   //design for test inputs9 
   input        scan_en9;            // enables9 shifting9 of scans9 
   input [15:0] 
                tri_state_enable9;   // disables9 op enable -> z 
   input        scan_in9;            // scan9 chain9 data input  
       
    
   // outputs9 
 
   //amba9 outputs9 
   output [31:0] 
                prdata9;             // read data 
   // gpio9 generic9 outputs9 
   output       gpio_int9;                // gpio_interupt9 for input pin9 change 
   output [15:0] 
                n_gpio_pin_oe9;           // output enable signal9 to pin9 
   output [15:0] 
                gpio_pin_out9;            // output signal9 to pin9 
                
   // scan9 outputs9
   output      scan_out9;            // scan9 chain9 data output

//##############################################################################
// if the GPIO9 is NOT9 black9 boxed9 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_GPIO9

gpio_lite9 i_gpio_lite9(
   //inputs9
   .n_p_reset9(n_p_reset9),
   .pclk9(pclk9),
   .psel9(psel9),
   .penable9(penable9),
   .pwrite9(pwrite9),
   .paddr9(paddr9),
   .pwdata9(pwdata9),
   .gpio_pin_in9(gpio_pin_in9),
   .scan_en9(scan_en9),
   .tri_state_enable9(tri_state_enable9),
   .scan_in9(), //added by smarkov9 for dft9

   //outputs9
   .scan_out9(), //added by smarkov9 for dft9
   .prdata9(prdata9),
   .gpio_int9(gpio_int9),
   .n_gpio_pin_oe9(n_gpio_pin_oe9),
   .gpio_pin_out9(gpio_pin_out9)
);
 
`else 
//##############################################################################
// if the GPIO9 is black9 boxed9 
//##############################################################################

   // inputs9 
    
   // pclks9  
   wire         n_p_reset9;            // amba9 reset 
   wire         pclk9;               // peripherical9 pclk9 bus 

   // AMBA9 Rev9 2
   wire         psel9;               // peripheral9 select9 for gpio9 
   wire         penable9;            // peripheral9 enable 
   wire         pwrite9;             // peripheral9 write strobe9 
   wire  [5:0] 
                paddr9;              // address bus of selected master9 
   wire  [31:0] 
                pwdata9;             // write data 

   // gpio9 generic9 inputs9 
   wire  [15:0] 
                gpio_pin_in9;             // wire  data from pin9 

   //design for test inputs9 
   wire         scan_en9;            // enables9 shifting9 of scans9 
   wire  [15:0] 
                tri_state_enable9;   // disables9 op enable -> z 
   wire         scan_in9;            // scan9 chain9 data wire   
       
    
   // outputs9 
 
   //amba9 outputs9 
   reg    [31:0] 
                prdata9;             // read data 
   // gpio9 generic9 outputs9 
   reg          gpio_int9 =0;                // gpio_interupt9 for wire  pin9 change 
   reg    [15:0] 
                n_gpio_pin_oe9;           // reg    enable signal9 to pin9 
   reg    [15:0] 
                gpio_pin_out9;            // reg    signal9 to pin9 
                
   // scan9 outputs9
   reg         scan_out9;            // scan9 chain9 data output

`endif
//##############################################################################
// black9 boxed9 defines9 
//##############################################################################

endmodule
