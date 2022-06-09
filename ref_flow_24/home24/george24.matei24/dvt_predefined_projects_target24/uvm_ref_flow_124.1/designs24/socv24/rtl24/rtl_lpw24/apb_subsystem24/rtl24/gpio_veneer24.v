//File24 name   : gpio_veneer24.v
//Title24       : 
//Created24     : 1999
//Description24 : 
//Notes24       : 
//----------------------------------------------------------------------
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------

module gpio_veneer24 ( 
              //inputs24 
 
              n_p_reset24, 
              pclk24, 

              psel24, 
              penable24, 
              pwrite24, 
              paddr24, 
              pwdata24, 

              gpio_pin_in24, 

              scan_en24, 
              tri_state_enable24, 

              scan_in24, //added by smarkov24 for dft24
 
              //outputs24
              
              scan_out24, //added by smarkov24 for dft24 
               
              prdata24, 

              gpio_int24, 

              n_gpio_pin_oe24, 
              gpio_pin_out24 
); 
 
//Numeric24 constants24


   // inputs24 
    
   // pclks24  
   input        n_p_reset24;            // amba24 reset 
   input        pclk24;               // peripherical24 pclk24 bus 

   // AMBA24 Rev24 2
   input        psel24;               // peripheral24 select24 for gpio24 
   input        penable24;            // peripheral24 enable 
   input        pwrite24;             // peripheral24 write strobe24 
   input [5:0] 
                paddr24;              // address bus of selected master24 
   input [31:0] 
                pwdata24;             // write data 

   // gpio24 generic24 inputs24 
   input [15:0] 
                gpio_pin_in24;             // input data from pin24 

   //design for test inputs24 
   input        scan_en24;            // enables24 shifting24 of scans24 
   input [15:0] 
                tri_state_enable24;   // disables24 op enable -> z 
   input        scan_in24;            // scan24 chain24 data input  
       
    
   // outputs24 
 
   //amba24 outputs24 
   output [31:0] 
                prdata24;             // read data 
   // gpio24 generic24 outputs24 
   output       gpio_int24;                // gpio_interupt24 for input pin24 change 
   output [15:0] 
                n_gpio_pin_oe24;           // output enable signal24 to pin24 
   output [15:0] 
                gpio_pin_out24;            // output signal24 to pin24 
                
   // scan24 outputs24
   output      scan_out24;            // scan24 chain24 data output

//##############################################################################
// if the GPIO24 is NOT24 black24 boxed24 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_GPIO24

gpio_lite24 i_gpio_lite24(
   //inputs24
   .n_p_reset24(n_p_reset24),
   .pclk24(pclk24),
   .psel24(psel24),
   .penable24(penable24),
   .pwrite24(pwrite24),
   .paddr24(paddr24),
   .pwdata24(pwdata24),
   .gpio_pin_in24(gpio_pin_in24),
   .scan_en24(scan_en24),
   .tri_state_enable24(tri_state_enable24),
   .scan_in24(), //added by smarkov24 for dft24

   //outputs24
   .scan_out24(), //added by smarkov24 for dft24
   .prdata24(prdata24),
   .gpio_int24(gpio_int24),
   .n_gpio_pin_oe24(n_gpio_pin_oe24),
   .gpio_pin_out24(gpio_pin_out24)
);
 
`else 
//##############################################################################
// if the GPIO24 is black24 boxed24 
//##############################################################################

   // inputs24 
    
   // pclks24  
   wire         n_p_reset24;            // amba24 reset 
   wire         pclk24;               // peripherical24 pclk24 bus 

   // AMBA24 Rev24 2
   wire         psel24;               // peripheral24 select24 for gpio24 
   wire         penable24;            // peripheral24 enable 
   wire         pwrite24;             // peripheral24 write strobe24 
   wire  [5:0] 
                paddr24;              // address bus of selected master24 
   wire  [31:0] 
                pwdata24;             // write data 

   // gpio24 generic24 inputs24 
   wire  [15:0] 
                gpio_pin_in24;             // wire  data from pin24 

   //design for test inputs24 
   wire         scan_en24;            // enables24 shifting24 of scans24 
   wire  [15:0] 
                tri_state_enable24;   // disables24 op enable -> z 
   wire         scan_in24;            // scan24 chain24 data wire   
       
    
   // outputs24 
 
   //amba24 outputs24 
   reg    [31:0] 
                prdata24;             // read data 
   // gpio24 generic24 outputs24 
   reg          gpio_int24 =0;                // gpio_interupt24 for wire  pin24 change 
   reg    [15:0] 
                n_gpio_pin_oe24;           // reg    enable signal24 to pin24 
   reg    [15:0] 
                gpio_pin_out24;            // reg    signal24 to pin24 
                
   // scan24 outputs24
   reg         scan_out24;            // scan24 chain24 data output

`endif
//##############################################################################
// black24 boxed24 defines24 
//##############################################################################

endmodule
