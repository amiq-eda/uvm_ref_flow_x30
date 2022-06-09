//File19 name   : gpio_veneer19.v
//Title19       : 
//Created19     : 1999
//Description19 : 
//Notes19       : 
//----------------------------------------------------------------------
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------

module gpio_veneer19 ( 
              //inputs19 
 
              n_p_reset19, 
              pclk19, 

              psel19, 
              penable19, 
              pwrite19, 
              paddr19, 
              pwdata19, 

              gpio_pin_in19, 

              scan_en19, 
              tri_state_enable19, 

              scan_in19, //added by smarkov19 for dft19
 
              //outputs19
              
              scan_out19, //added by smarkov19 for dft19 
               
              prdata19, 

              gpio_int19, 

              n_gpio_pin_oe19, 
              gpio_pin_out19 
); 
 
//Numeric19 constants19


   // inputs19 
    
   // pclks19  
   input        n_p_reset19;            // amba19 reset 
   input        pclk19;               // peripherical19 pclk19 bus 

   // AMBA19 Rev19 2
   input        psel19;               // peripheral19 select19 for gpio19 
   input        penable19;            // peripheral19 enable 
   input        pwrite19;             // peripheral19 write strobe19 
   input [5:0] 
                paddr19;              // address bus of selected master19 
   input [31:0] 
                pwdata19;             // write data 

   // gpio19 generic19 inputs19 
   input [15:0] 
                gpio_pin_in19;             // input data from pin19 

   //design for test inputs19 
   input        scan_en19;            // enables19 shifting19 of scans19 
   input [15:0] 
                tri_state_enable19;   // disables19 op enable -> z 
   input        scan_in19;            // scan19 chain19 data input  
       
    
   // outputs19 
 
   //amba19 outputs19 
   output [31:0] 
                prdata19;             // read data 
   // gpio19 generic19 outputs19 
   output       gpio_int19;                // gpio_interupt19 for input pin19 change 
   output [15:0] 
                n_gpio_pin_oe19;           // output enable signal19 to pin19 
   output [15:0] 
                gpio_pin_out19;            // output signal19 to pin19 
                
   // scan19 outputs19
   output      scan_out19;            // scan19 chain19 data output

//##############################################################################
// if the GPIO19 is NOT19 black19 boxed19 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_GPIO19

gpio_lite19 i_gpio_lite19(
   //inputs19
   .n_p_reset19(n_p_reset19),
   .pclk19(pclk19),
   .psel19(psel19),
   .penable19(penable19),
   .pwrite19(pwrite19),
   .paddr19(paddr19),
   .pwdata19(pwdata19),
   .gpio_pin_in19(gpio_pin_in19),
   .scan_en19(scan_en19),
   .tri_state_enable19(tri_state_enable19),
   .scan_in19(), //added by smarkov19 for dft19

   //outputs19
   .scan_out19(), //added by smarkov19 for dft19
   .prdata19(prdata19),
   .gpio_int19(gpio_int19),
   .n_gpio_pin_oe19(n_gpio_pin_oe19),
   .gpio_pin_out19(gpio_pin_out19)
);
 
`else 
//##############################################################################
// if the GPIO19 is black19 boxed19 
//##############################################################################

   // inputs19 
    
   // pclks19  
   wire         n_p_reset19;            // amba19 reset 
   wire         pclk19;               // peripherical19 pclk19 bus 

   // AMBA19 Rev19 2
   wire         psel19;               // peripheral19 select19 for gpio19 
   wire         penable19;            // peripheral19 enable 
   wire         pwrite19;             // peripheral19 write strobe19 
   wire  [5:0] 
                paddr19;              // address bus of selected master19 
   wire  [31:0] 
                pwdata19;             // write data 

   // gpio19 generic19 inputs19 
   wire  [15:0] 
                gpio_pin_in19;             // wire  data from pin19 

   //design for test inputs19 
   wire         scan_en19;            // enables19 shifting19 of scans19 
   wire  [15:0] 
                tri_state_enable19;   // disables19 op enable -> z 
   wire         scan_in19;            // scan19 chain19 data wire   
       
    
   // outputs19 
 
   //amba19 outputs19 
   reg    [31:0] 
                prdata19;             // read data 
   // gpio19 generic19 outputs19 
   reg          gpio_int19 =0;                // gpio_interupt19 for wire  pin19 change 
   reg    [15:0] 
                n_gpio_pin_oe19;           // reg    enable signal19 to pin19 
   reg    [15:0] 
                gpio_pin_out19;            // reg    signal19 to pin19 
                
   // scan19 outputs19
   reg         scan_out19;            // scan19 chain19 data output

`endif
//##############################################################################
// black19 boxed19 defines19 
//##############################################################################

endmodule
