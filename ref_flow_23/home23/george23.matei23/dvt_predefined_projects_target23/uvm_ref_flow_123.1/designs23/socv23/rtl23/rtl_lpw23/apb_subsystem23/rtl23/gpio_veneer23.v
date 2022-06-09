//File23 name   : gpio_veneer23.v
//Title23       : 
//Created23     : 1999
//Description23 : 
//Notes23       : 
//----------------------------------------------------------------------
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------

module gpio_veneer23 ( 
              //inputs23 
 
              n_p_reset23, 
              pclk23, 

              psel23, 
              penable23, 
              pwrite23, 
              paddr23, 
              pwdata23, 

              gpio_pin_in23, 

              scan_en23, 
              tri_state_enable23, 

              scan_in23, //added by smarkov23 for dft23
 
              //outputs23
              
              scan_out23, //added by smarkov23 for dft23 
               
              prdata23, 

              gpio_int23, 

              n_gpio_pin_oe23, 
              gpio_pin_out23 
); 
 
//Numeric23 constants23


   // inputs23 
    
   // pclks23  
   input        n_p_reset23;            // amba23 reset 
   input        pclk23;               // peripherical23 pclk23 bus 

   // AMBA23 Rev23 2
   input        psel23;               // peripheral23 select23 for gpio23 
   input        penable23;            // peripheral23 enable 
   input        pwrite23;             // peripheral23 write strobe23 
   input [5:0] 
                paddr23;              // address bus of selected master23 
   input [31:0] 
                pwdata23;             // write data 

   // gpio23 generic23 inputs23 
   input [15:0] 
                gpio_pin_in23;             // input data from pin23 

   //design for test inputs23 
   input        scan_en23;            // enables23 shifting23 of scans23 
   input [15:0] 
                tri_state_enable23;   // disables23 op enable -> z 
   input        scan_in23;            // scan23 chain23 data input  
       
    
   // outputs23 
 
   //amba23 outputs23 
   output [31:0] 
                prdata23;             // read data 
   // gpio23 generic23 outputs23 
   output       gpio_int23;                // gpio_interupt23 for input pin23 change 
   output [15:0] 
                n_gpio_pin_oe23;           // output enable signal23 to pin23 
   output [15:0] 
                gpio_pin_out23;            // output signal23 to pin23 
                
   // scan23 outputs23
   output      scan_out23;            // scan23 chain23 data output

//##############################################################################
// if the GPIO23 is NOT23 black23 boxed23 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_GPIO23

gpio_lite23 i_gpio_lite23(
   //inputs23
   .n_p_reset23(n_p_reset23),
   .pclk23(pclk23),
   .psel23(psel23),
   .penable23(penable23),
   .pwrite23(pwrite23),
   .paddr23(paddr23),
   .pwdata23(pwdata23),
   .gpio_pin_in23(gpio_pin_in23),
   .scan_en23(scan_en23),
   .tri_state_enable23(tri_state_enable23),
   .scan_in23(), //added by smarkov23 for dft23

   //outputs23
   .scan_out23(), //added by smarkov23 for dft23
   .prdata23(prdata23),
   .gpio_int23(gpio_int23),
   .n_gpio_pin_oe23(n_gpio_pin_oe23),
   .gpio_pin_out23(gpio_pin_out23)
);
 
`else 
//##############################################################################
// if the GPIO23 is black23 boxed23 
//##############################################################################

   // inputs23 
    
   // pclks23  
   wire         n_p_reset23;            // amba23 reset 
   wire         pclk23;               // peripherical23 pclk23 bus 

   // AMBA23 Rev23 2
   wire         psel23;               // peripheral23 select23 for gpio23 
   wire         penable23;            // peripheral23 enable 
   wire         pwrite23;             // peripheral23 write strobe23 
   wire  [5:0] 
                paddr23;              // address bus of selected master23 
   wire  [31:0] 
                pwdata23;             // write data 

   // gpio23 generic23 inputs23 
   wire  [15:0] 
                gpio_pin_in23;             // wire  data from pin23 

   //design for test inputs23 
   wire         scan_en23;            // enables23 shifting23 of scans23 
   wire  [15:0] 
                tri_state_enable23;   // disables23 op enable -> z 
   wire         scan_in23;            // scan23 chain23 data wire   
       
    
   // outputs23 
 
   //amba23 outputs23 
   reg    [31:0] 
                prdata23;             // read data 
   // gpio23 generic23 outputs23 
   reg          gpio_int23 =0;                // gpio_interupt23 for wire  pin23 change 
   reg    [15:0] 
                n_gpio_pin_oe23;           // reg    enable signal23 to pin23 
   reg    [15:0] 
                gpio_pin_out23;            // reg    signal23 to pin23 
                
   // scan23 outputs23
   reg         scan_out23;            // scan23 chain23 data output

`endif
//##############################################################################
// black23 boxed23 defines23 
//##############################################################################

endmodule
