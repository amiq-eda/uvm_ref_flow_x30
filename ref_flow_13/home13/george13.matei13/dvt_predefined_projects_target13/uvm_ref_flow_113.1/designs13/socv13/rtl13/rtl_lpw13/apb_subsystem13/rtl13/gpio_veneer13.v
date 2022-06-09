//File13 name   : gpio_veneer13.v
//Title13       : 
//Created13     : 1999
//Description13 : 
//Notes13       : 
//----------------------------------------------------------------------
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------

module gpio_veneer13 ( 
              //inputs13 
 
              n_p_reset13, 
              pclk13, 

              psel13, 
              penable13, 
              pwrite13, 
              paddr13, 
              pwdata13, 

              gpio_pin_in13, 

              scan_en13, 
              tri_state_enable13, 

              scan_in13, //added by smarkov13 for dft13
 
              //outputs13
              
              scan_out13, //added by smarkov13 for dft13 
               
              prdata13, 

              gpio_int13, 

              n_gpio_pin_oe13, 
              gpio_pin_out13 
); 
 
//Numeric13 constants13


   // inputs13 
    
   // pclks13  
   input        n_p_reset13;            // amba13 reset 
   input        pclk13;               // peripherical13 pclk13 bus 

   // AMBA13 Rev13 2
   input        psel13;               // peripheral13 select13 for gpio13 
   input        penable13;            // peripheral13 enable 
   input        pwrite13;             // peripheral13 write strobe13 
   input [5:0] 
                paddr13;              // address bus of selected master13 
   input [31:0] 
                pwdata13;             // write data 

   // gpio13 generic13 inputs13 
   input [15:0] 
                gpio_pin_in13;             // input data from pin13 

   //design for test inputs13 
   input        scan_en13;            // enables13 shifting13 of scans13 
   input [15:0] 
                tri_state_enable13;   // disables13 op enable -> z 
   input        scan_in13;            // scan13 chain13 data input  
       
    
   // outputs13 
 
   //amba13 outputs13 
   output [31:0] 
                prdata13;             // read data 
   // gpio13 generic13 outputs13 
   output       gpio_int13;                // gpio_interupt13 for input pin13 change 
   output [15:0] 
                n_gpio_pin_oe13;           // output enable signal13 to pin13 
   output [15:0] 
                gpio_pin_out13;            // output signal13 to pin13 
                
   // scan13 outputs13
   output      scan_out13;            // scan13 chain13 data output

//##############################################################################
// if the GPIO13 is NOT13 black13 boxed13 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_GPIO13

gpio_lite13 i_gpio_lite13(
   //inputs13
   .n_p_reset13(n_p_reset13),
   .pclk13(pclk13),
   .psel13(psel13),
   .penable13(penable13),
   .pwrite13(pwrite13),
   .paddr13(paddr13),
   .pwdata13(pwdata13),
   .gpio_pin_in13(gpio_pin_in13),
   .scan_en13(scan_en13),
   .tri_state_enable13(tri_state_enable13),
   .scan_in13(), //added by smarkov13 for dft13

   //outputs13
   .scan_out13(), //added by smarkov13 for dft13
   .prdata13(prdata13),
   .gpio_int13(gpio_int13),
   .n_gpio_pin_oe13(n_gpio_pin_oe13),
   .gpio_pin_out13(gpio_pin_out13)
);
 
`else 
//##############################################################################
// if the GPIO13 is black13 boxed13 
//##############################################################################

   // inputs13 
    
   // pclks13  
   wire         n_p_reset13;            // amba13 reset 
   wire         pclk13;               // peripherical13 pclk13 bus 

   // AMBA13 Rev13 2
   wire         psel13;               // peripheral13 select13 for gpio13 
   wire         penable13;            // peripheral13 enable 
   wire         pwrite13;             // peripheral13 write strobe13 
   wire  [5:0] 
                paddr13;              // address bus of selected master13 
   wire  [31:0] 
                pwdata13;             // write data 

   // gpio13 generic13 inputs13 
   wire  [15:0] 
                gpio_pin_in13;             // wire  data from pin13 

   //design for test inputs13 
   wire         scan_en13;            // enables13 shifting13 of scans13 
   wire  [15:0] 
                tri_state_enable13;   // disables13 op enable -> z 
   wire         scan_in13;            // scan13 chain13 data wire   
       
    
   // outputs13 
 
   //amba13 outputs13 
   reg    [31:0] 
                prdata13;             // read data 
   // gpio13 generic13 outputs13 
   reg          gpio_int13 =0;                // gpio_interupt13 for wire  pin13 change 
   reg    [15:0] 
                n_gpio_pin_oe13;           // reg    enable signal13 to pin13 
   reg    [15:0] 
                gpio_pin_out13;            // reg    signal13 to pin13 
                
   // scan13 outputs13
   reg         scan_out13;            // scan13 chain13 data output

`endif
//##############################################################################
// black13 boxed13 defines13 
//##############################################################################

endmodule
