//File3 name   : gpio_veneer3.v
//Title3       : 
//Created3     : 1999
//Description3 : 
//Notes3       : 
//----------------------------------------------------------------------
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------

module gpio_veneer3 ( 
              //inputs3 
 
              n_p_reset3, 
              pclk3, 

              psel3, 
              penable3, 
              pwrite3, 
              paddr3, 
              pwdata3, 

              gpio_pin_in3, 

              scan_en3, 
              tri_state_enable3, 

              scan_in3, //added by smarkov3 for dft3
 
              //outputs3
              
              scan_out3, //added by smarkov3 for dft3 
               
              prdata3, 

              gpio_int3, 

              n_gpio_pin_oe3, 
              gpio_pin_out3 
); 
 
//Numeric3 constants3


   // inputs3 
    
   // pclks3  
   input        n_p_reset3;            // amba3 reset 
   input        pclk3;               // peripherical3 pclk3 bus 

   // AMBA3 Rev3 2
   input        psel3;               // peripheral3 select3 for gpio3 
   input        penable3;            // peripheral3 enable 
   input        pwrite3;             // peripheral3 write strobe3 
   input [5:0] 
                paddr3;              // address bus of selected master3 
   input [31:0] 
                pwdata3;             // write data 

   // gpio3 generic3 inputs3 
   input [15:0] 
                gpio_pin_in3;             // input data from pin3 

   //design for test inputs3 
   input        scan_en3;            // enables3 shifting3 of scans3 
   input [15:0] 
                tri_state_enable3;   // disables3 op enable -> z 
   input        scan_in3;            // scan3 chain3 data input  
       
    
   // outputs3 
 
   //amba3 outputs3 
   output [31:0] 
                prdata3;             // read data 
   // gpio3 generic3 outputs3 
   output       gpio_int3;                // gpio_interupt3 for input pin3 change 
   output [15:0] 
                n_gpio_pin_oe3;           // output enable signal3 to pin3 
   output [15:0] 
                gpio_pin_out3;            // output signal3 to pin3 
                
   // scan3 outputs3
   output      scan_out3;            // scan3 chain3 data output

//##############################################################################
// if the GPIO3 is NOT3 black3 boxed3 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_GPIO3

gpio_lite3 i_gpio_lite3(
   //inputs3
   .n_p_reset3(n_p_reset3),
   .pclk3(pclk3),
   .psel3(psel3),
   .penable3(penable3),
   .pwrite3(pwrite3),
   .paddr3(paddr3),
   .pwdata3(pwdata3),
   .gpio_pin_in3(gpio_pin_in3),
   .scan_en3(scan_en3),
   .tri_state_enable3(tri_state_enable3),
   .scan_in3(), //added by smarkov3 for dft3

   //outputs3
   .scan_out3(), //added by smarkov3 for dft3
   .prdata3(prdata3),
   .gpio_int3(gpio_int3),
   .n_gpio_pin_oe3(n_gpio_pin_oe3),
   .gpio_pin_out3(gpio_pin_out3)
);
 
`else 
//##############################################################################
// if the GPIO3 is black3 boxed3 
//##############################################################################

   // inputs3 
    
   // pclks3  
   wire         n_p_reset3;            // amba3 reset 
   wire         pclk3;               // peripherical3 pclk3 bus 

   // AMBA3 Rev3 2
   wire         psel3;               // peripheral3 select3 for gpio3 
   wire         penable3;            // peripheral3 enable 
   wire         pwrite3;             // peripheral3 write strobe3 
   wire  [5:0] 
                paddr3;              // address bus of selected master3 
   wire  [31:0] 
                pwdata3;             // write data 

   // gpio3 generic3 inputs3 
   wire  [15:0] 
                gpio_pin_in3;             // wire  data from pin3 

   //design for test inputs3 
   wire         scan_en3;            // enables3 shifting3 of scans3 
   wire  [15:0] 
                tri_state_enable3;   // disables3 op enable -> z 
   wire         scan_in3;            // scan3 chain3 data wire   
       
    
   // outputs3 
 
   //amba3 outputs3 
   reg    [31:0] 
                prdata3;             // read data 
   // gpio3 generic3 outputs3 
   reg          gpio_int3 =0;                // gpio_interupt3 for wire  pin3 change 
   reg    [15:0] 
                n_gpio_pin_oe3;           // reg    enable signal3 to pin3 
   reg    [15:0] 
                gpio_pin_out3;            // reg    signal3 to pin3 
                
   // scan3 outputs3
   reg         scan_out3;            // scan3 chain3 data output

`endif
//##############################################################################
// black3 boxed3 defines3 
//##############################################################################

endmodule
