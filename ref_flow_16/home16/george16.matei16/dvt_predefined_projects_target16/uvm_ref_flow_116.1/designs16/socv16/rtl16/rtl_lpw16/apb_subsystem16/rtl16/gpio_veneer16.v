//File16 name   : gpio_veneer16.v
//Title16       : 
//Created16     : 1999
//Description16 : 
//Notes16       : 
//----------------------------------------------------------------------
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------

module gpio_veneer16 ( 
              //inputs16 
 
              n_p_reset16, 
              pclk16, 

              psel16, 
              penable16, 
              pwrite16, 
              paddr16, 
              pwdata16, 

              gpio_pin_in16, 

              scan_en16, 
              tri_state_enable16, 

              scan_in16, //added by smarkov16 for dft16
 
              //outputs16
              
              scan_out16, //added by smarkov16 for dft16 
               
              prdata16, 

              gpio_int16, 

              n_gpio_pin_oe16, 
              gpio_pin_out16 
); 
 
//Numeric16 constants16


   // inputs16 
    
   // pclks16  
   input        n_p_reset16;            // amba16 reset 
   input        pclk16;               // peripherical16 pclk16 bus 

   // AMBA16 Rev16 2
   input        psel16;               // peripheral16 select16 for gpio16 
   input        penable16;            // peripheral16 enable 
   input        pwrite16;             // peripheral16 write strobe16 
   input [5:0] 
                paddr16;              // address bus of selected master16 
   input [31:0] 
                pwdata16;             // write data 

   // gpio16 generic16 inputs16 
   input [15:0] 
                gpio_pin_in16;             // input data from pin16 

   //design for test inputs16 
   input        scan_en16;            // enables16 shifting16 of scans16 
   input [15:0] 
                tri_state_enable16;   // disables16 op enable -> z 
   input        scan_in16;            // scan16 chain16 data input  
       
    
   // outputs16 
 
   //amba16 outputs16 
   output [31:0] 
                prdata16;             // read data 
   // gpio16 generic16 outputs16 
   output       gpio_int16;                // gpio_interupt16 for input pin16 change 
   output [15:0] 
                n_gpio_pin_oe16;           // output enable signal16 to pin16 
   output [15:0] 
                gpio_pin_out16;            // output signal16 to pin16 
                
   // scan16 outputs16
   output      scan_out16;            // scan16 chain16 data output

//##############################################################################
// if the GPIO16 is NOT16 black16 boxed16 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_GPIO16

gpio_lite16 i_gpio_lite16(
   //inputs16
   .n_p_reset16(n_p_reset16),
   .pclk16(pclk16),
   .psel16(psel16),
   .penable16(penable16),
   .pwrite16(pwrite16),
   .paddr16(paddr16),
   .pwdata16(pwdata16),
   .gpio_pin_in16(gpio_pin_in16),
   .scan_en16(scan_en16),
   .tri_state_enable16(tri_state_enable16),
   .scan_in16(), //added by smarkov16 for dft16

   //outputs16
   .scan_out16(), //added by smarkov16 for dft16
   .prdata16(prdata16),
   .gpio_int16(gpio_int16),
   .n_gpio_pin_oe16(n_gpio_pin_oe16),
   .gpio_pin_out16(gpio_pin_out16)
);
 
`else 
//##############################################################################
// if the GPIO16 is black16 boxed16 
//##############################################################################

   // inputs16 
    
   // pclks16  
   wire         n_p_reset16;            // amba16 reset 
   wire         pclk16;               // peripherical16 pclk16 bus 

   // AMBA16 Rev16 2
   wire         psel16;               // peripheral16 select16 for gpio16 
   wire         penable16;            // peripheral16 enable 
   wire         pwrite16;             // peripheral16 write strobe16 
   wire  [5:0] 
                paddr16;              // address bus of selected master16 
   wire  [31:0] 
                pwdata16;             // write data 

   // gpio16 generic16 inputs16 
   wire  [15:0] 
                gpio_pin_in16;             // wire  data from pin16 

   //design for test inputs16 
   wire         scan_en16;            // enables16 shifting16 of scans16 
   wire  [15:0] 
                tri_state_enable16;   // disables16 op enable -> z 
   wire         scan_in16;            // scan16 chain16 data wire   
       
    
   // outputs16 
 
   //amba16 outputs16 
   reg    [31:0] 
                prdata16;             // read data 
   // gpio16 generic16 outputs16 
   reg          gpio_int16 =0;                // gpio_interupt16 for wire  pin16 change 
   reg    [15:0] 
                n_gpio_pin_oe16;           // reg    enable signal16 to pin16 
   reg    [15:0] 
                gpio_pin_out16;            // reg    signal16 to pin16 
                
   // scan16 outputs16
   reg         scan_out16;            // scan16 chain16 data output

`endif
//##############################################################################
// black16 boxed16 defines16 
//##############################################################################

endmodule
