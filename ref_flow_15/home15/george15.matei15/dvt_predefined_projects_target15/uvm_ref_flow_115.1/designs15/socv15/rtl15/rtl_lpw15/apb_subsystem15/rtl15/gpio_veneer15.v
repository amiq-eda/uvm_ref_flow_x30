//File15 name   : gpio_veneer15.v
//Title15       : 
//Created15     : 1999
//Description15 : 
//Notes15       : 
//----------------------------------------------------------------------
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------

module gpio_veneer15 ( 
              //inputs15 
 
              n_p_reset15, 
              pclk15, 

              psel15, 
              penable15, 
              pwrite15, 
              paddr15, 
              pwdata15, 

              gpio_pin_in15, 

              scan_en15, 
              tri_state_enable15, 

              scan_in15, //added by smarkov15 for dft15
 
              //outputs15
              
              scan_out15, //added by smarkov15 for dft15 
               
              prdata15, 

              gpio_int15, 

              n_gpio_pin_oe15, 
              gpio_pin_out15 
); 
 
//Numeric15 constants15


   // inputs15 
    
   // pclks15  
   input        n_p_reset15;            // amba15 reset 
   input        pclk15;               // peripherical15 pclk15 bus 

   // AMBA15 Rev15 2
   input        psel15;               // peripheral15 select15 for gpio15 
   input        penable15;            // peripheral15 enable 
   input        pwrite15;             // peripheral15 write strobe15 
   input [5:0] 
                paddr15;              // address bus of selected master15 
   input [31:0] 
                pwdata15;             // write data 

   // gpio15 generic15 inputs15 
   input [15:0] 
                gpio_pin_in15;             // input data from pin15 

   //design for test inputs15 
   input        scan_en15;            // enables15 shifting15 of scans15 
   input [15:0] 
                tri_state_enable15;   // disables15 op enable -> z 
   input        scan_in15;            // scan15 chain15 data input  
       
    
   // outputs15 
 
   //amba15 outputs15 
   output [31:0] 
                prdata15;             // read data 
   // gpio15 generic15 outputs15 
   output       gpio_int15;                // gpio_interupt15 for input pin15 change 
   output [15:0] 
                n_gpio_pin_oe15;           // output enable signal15 to pin15 
   output [15:0] 
                gpio_pin_out15;            // output signal15 to pin15 
                
   // scan15 outputs15
   output      scan_out15;            // scan15 chain15 data output

//##############################################################################
// if the GPIO15 is NOT15 black15 boxed15 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_GPIO15

gpio_lite15 i_gpio_lite15(
   //inputs15
   .n_p_reset15(n_p_reset15),
   .pclk15(pclk15),
   .psel15(psel15),
   .penable15(penable15),
   .pwrite15(pwrite15),
   .paddr15(paddr15),
   .pwdata15(pwdata15),
   .gpio_pin_in15(gpio_pin_in15),
   .scan_en15(scan_en15),
   .tri_state_enable15(tri_state_enable15),
   .scan_in15(), //added by smarkov15 for dft15

   //outputs15
   .scan_out15(), //added by smarkov15 for dft15
   .prdata15(prdata15),
   .gpio_int15(gpio_int15),
   .n_gpio_pin_oe15(n_gpio_pin_oe15),
   .gpio_pin_out15(gpio_pin_out15)
);
 
`else 
//##############################################################################
// if the GPIO15 is black15 boxed15 
//##############################################################################

   // inputs15 
    
   // pclks15  
   wire         n_p_reset15;            // amba15 reset 
   wire         pclk15;               // peripherical15 pclk15 bus 

   // AMBA15 Rev15 2
   wire         psel15;               // peripheral15 select15 for gpio15 
   wire         penable15;            // peripheral15 enable 
   wire         pwrite15;             // peripheral15 write strobe15 
   wire  [5:0] 
                paddr15;              // address bus of selected master15 
   wire  [31:0] 
                pwdata15;             // write data 

   // gpio15 generic15 inputs15 
   wire  [15:0] 
                gpio_pin_in15;             // wire  data from pin15 

   //design for test inputs15 
   wire         scan_en15;            // enables15 shifting15 of scans15 
   wire  [15:0] 
                tri_state_enable15;   // disables15 op enable -> z 
   wire         scan_in15;            // scan15 chain15 data wire   
       
    
   // outputs15 
 
   //amba15 outputs15 
   reg    [31:0] 
                prdata15;             // read data 
   // gpio15 generic15 outputs15 
   reg          gpio_int15 =0;                // gpio_interupt15 for wire  pin15 change 
   reg    [15:0] 
                n_gpio_pin_oe15;           // reg    enable signal15 to pin15 
   reg    [15:0] 
                gpio_pin_out15;            // reg    signal15 to pin15 
                
   // scan15 outputs15
   reg         scan_out15;            // scan15 chain15 data output

`endif
//##############################################################################
// black15 boxed15 defines15 
//##############################################################################

endmodule
