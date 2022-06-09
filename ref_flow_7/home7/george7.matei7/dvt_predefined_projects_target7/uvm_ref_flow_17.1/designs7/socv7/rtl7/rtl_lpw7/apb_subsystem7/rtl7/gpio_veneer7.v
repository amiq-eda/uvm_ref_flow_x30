//File7 name   : gpio_veneer7.v
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

module gpio_veneer7 ( 
              //inputs7 
 
              n_p_reset7, 
              pclk7, 

              psel7, 
              penable7, 
              pwrite7, 
              paddr7, 
              pwdata7, 

              gpio_pin_in7, 

              scan_en7, 
              tri_state_enable7, 

              scan_in7, //added by smarkov7 for dft7
 
              //outputs7
              
              scan_out7, //added by smarkov7 for dft7 
               
              prdata7, 

              gpio_int7, 

              n_gpio_pin_oe7, 
              gpio_pin_out7 
); 
 
//Numeric7 constants7


   // inputs7 
    
   // pclks7  
   input        n_p_reset7;            // amba7 reset 
   input        pclk7;               // peripherical7 pclk7 bus 

   // AMBA7 Rev7 2
   input        psel7;               // peripheral7 select7 for gpio7 
   input        penable7;            // peripheral7 enable 
   input        pwrite7;             // peripheral7 write strobe7 
   input [5:0] 
                paddr7;              // address bus of selected master7 
   input [31:0] 
                pwdata7;             // write data 

   // gpio7 generic7 inputs7 
   input [15:0] 
                gpio_pin_in7;             // input data from pin7 

   //design for test inputs7 
   input        scan_en7;            // enables7 shifting7 of scans7 
   input [15:0] 
                tri_state_enable7;   // disables7 op enable -> z 
   input        scan_in7;            // scan7 chain7 data input  
       
    
   // outputs7 
 
   //amba7 outputs7 
   output [31:0] 
                prdata7;             // read data 
   // gpio7 generic7 outputs7 
   output       gpio_int7;                // gpio_interupt7 for input pin7 change 
   output [15:0] 
                n_gpio_pin_oe7;           // output enable signal7 to pin7 
   output [15:0] 
                gpio_pin_out7;            // output signal7 to pin7 
                
   // scan7 outputs7
   output      scan_out7;            // scan7 chain7 data output

//##############################################################################
// if the GPIO7 is NOT7 black7 boxed7 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_GPIO7

gpio_lite7 i_gpio_lite7(
   //inputs7
   .n_p_reset7(n_p_reset7),
   .pclk7(pclk7),
   .psel7(psel7),
   .penable7(penable7),
   .pwrite7(pwrite7),
   .paddr7(paddr7),
   .pwdata7(pwdata7),
   .gpio_pin_in7(gpio_pin_in7),
   .scan_en7(scan_en7),
   .tri_state_enable7(tri_state_enable7),
   .scan_in7(), //added by smarkov7 for dft7

   //outputs7
   .scan_out7(), //added by smarkov7 for dft7
   .prdata7(prdata7),
   .gpio_int7(gpio_int7),
   .n_gpio_pin_oe7(n_gpio_pin_oe7),
   .gpio_pin_out7(gpio_pin_out7)
);
 
`else 
//##############################################################################
// if the GPIO7 is black7 boxed7 
//##############################################################################

   // inputs7 
    
   // pclks7  
   wire         n_p_reset7;            // amba7 reset 
   wire         pclk7;               // peripherical7 pclk7 bus 

   // AMBA7 Rev7 2
   wire         psel7;               // peripheral7 select7 for gpio7 
   wire         penable7;            // peripheral7 enable 
   wire         pwrite7;             // peripheral7 write strobe7 
   wire  [5:0] 
                paddr7;              // address bus of selected master7 
   wire  [31:0] 
                pwdata7;             // write data 

   // gpio7 generic7 inputs7 
   wire  [15:0] 
                gpio_pin_in7;             // wire  data from pin7 

   //design for test inputs7 
   wire         scan_en7;            // enables7 shifting7 of scans7 
   wire  [15:0] 
                tri_state_enable7;   // disables7 op enable -> z 
   wire         scan_in7;            // scan7 chain7 data wire   
       
    
   // outputs7 
 
   //amba7 outputs7 
   reg    [31:0] 
                prdata7;             // read data 
   // gpio7 generic7 outputs7 
   reg          gpio_int7 =0;                // gpio_interupt7 for wire  pin7 change 
   reg    [15:0] 
                n_gpio_pin_oe7;           // reg    enable signal7 to pin7 
   reg    [15:0] 
                gpio_pin_out7;            // reg    signal7 to pin7 
                
   // scan7 outputs7
   reg         scan_out7;            // scan7 chain7 data output

`endif
//##############################################################################
// black7 boxed7 defines7 
//##############################################################################

endmodule
