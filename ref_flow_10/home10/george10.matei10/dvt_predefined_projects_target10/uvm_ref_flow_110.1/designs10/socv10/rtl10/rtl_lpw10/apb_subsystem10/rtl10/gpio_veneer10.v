//File10 name   : gpio_veneer10.v
//Title10       : 
//Created10     : 1999
//Description10 : 
//Notes10       : 
//----------------------------------------------------------------------
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------

module gpio_veneer10 ( 
              //inputs10 
 
              n_p_reset10, 
              pclk10, 

              psel10, 
              penable10, 
              pwrite10, 
              paddr10, 
              pwdata10, 

              gpio_pin_in10, 

              scan_en10, 
              tri_state_enable10, 

              scan_in10, //added by smarkov10 for dft10
 
              //outputs10
              
              scan_out10, //added by smarkov10 for dft10 
               
              prdata10, 

              gpio_int10, 

              n_gpio_pin_oe10, 
              gpio_pin_out10 
); 
 
//Numeric10 constants10


   // inputs10 
    
   // pclks10  
   input        n_p_reset10;            // amba10 reset 
   input        pclk10;               // peripherical10 pclk10 bus 

   // AMBA10 Rev10 2
   input        psel10;               // peripheral10 select10 for gpio10 
   input        penable10;            // peripheral10 enable 
   input        pwrite10;             // peripheral10 write strobe10 
   input [5:0] 
                paddr10;              // address bus of selected master10 
   input [31:0] 
                pwdata10;             // write data 

   // gpio10 generic10 inputs10 
   input [15:0] 
                gpio_pin_in10;             // input data from pin10 

   //design for test inputs10 
   input        scan_en10;            // enables10 shifting10 of scans10 
   input [15:0] 
                tri_state_enable10;   // disables10 op enable -> z 
   input        scan_in10;            // scan10 chain10 data input  
       
    
   // outputs10 
 
   //amba10 outputs10 
   output [31:0] 
                prdata10;             // read data 
   // gpio10 generic10 outputs10 
   output       gpio_int10;                // gpio_interupt10 for input pin10 change 
   output [15:0] 
                n_gpio_pin_oe10;           // output enable signal10 to pin10 
   output [15:0] 
                gpio_pin_out10;            // output signal10 to pin10 
                
   // scan10 outputs10
   output      scan_out10;            // scan10 chain10 data output

//##############################################################################
// if the GPIO10 is NOT10 black10 boxed10 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_GPIO10

gpio_lite10 i_gpio_lite10(
   //inputs10
   .n_p_reset10(n_p_reset10),
   .pclk10(pclk10),
   .psel10(psel10),
   .penable10(penable10),
   .pwrite10(pwrite10),
   .paddr10(paddr10),
   .pwdata10(pwdata10),
   .gpio_pin_in10(gpio_pin_in10),
   .scan_en10(scan_en10),
   .tri_state_enable10(tri_state_enable10),
   .scan_in10(), //added by smarkov10 for dft10

   //outputs10
   .scan_out10(), //added by smarkov10 for dft10
   .prdata10(prdata10),
   .gpio_int10(gpio_int10),
   .n_gpio_pin_oe10(n_gpio_pin_oe10),
   .gpio_pin_out10(gpio_pin_out10)
);
 
`else 
//##############################################################################
// if the GPIO10 is black10 boxed10 
//##############################################################################

   // inputs10 
    
   // pclks10  
   wire         n_p_reset10;            // amba10 reset 
   wire         pclk10;               // peripherical10 pclk10 bus 

   // AMBA10 Rev10 2
   wire         psel10;               // peripheral10 select10 for gpio10 
   wire         penable10;            // peripheral10 enable 
   wire         pwrite10;             // peripheral10 write strobe10 
   wire  [5:0] 
                paddr10;              // address bus of selected master10 
   wire  [31:0] 
                pwdata10;             // write data 

   // gpio10 generic10 inputs10 
   wire  [15:0] 
                gpio_pin_in10;             // wire  data from pin10 

   //design for test inputs10 
   wire         scan_en10;            // enables10 shifting10 of scans10 
   wire  [15:0] 
                tri_state_enable10;   // disables10 op enable -> z 
   wire         scan_in10;            // scan10 chain10 data wire   
       
    
   // outputs10 
 
   //amba10 outputs10 
   reg    [31:0] 
                prdata10;             // read data 
   // gpio10 generic10 outputs10 
   reg          gpio_int10 =0;                // gpio_interupt10 for wire  pin10 change 
   reg    [15:0] 
                n_gpio_pin_oe10;           // reg    enable signal10 to pin10 
   reg    [15:0] 
                gpio_pin_out10;            // reg    signal10 to pin10 
                
   // scan10 outputs10
   reg         scan_out10;            // scan10 chain10 data output

`endif
//##############################################################################
// black10 boxed10 defines10 
//##############################################################################

endmodule
