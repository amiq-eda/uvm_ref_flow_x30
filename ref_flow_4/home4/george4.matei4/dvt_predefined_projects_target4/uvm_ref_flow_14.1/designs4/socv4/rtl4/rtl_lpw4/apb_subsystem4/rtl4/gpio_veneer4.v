//File4 name   : gpio_veneer4.v
//Title4       : 
//Created4     : 1999
//Description4 : 
//Notes4       : 
//----------------------------------------------------------------------
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------

module gpio_veneer4 ( 
              //inputs4 
 
              n_p_reset4, 
              pclk4, 

              psel4, 
              penable4, 
              pwrite4, 
              paddr4, 
              pwdata4, 

              gpio_pin_in4, 

              scan_en4, 
              tri_state_enable4, 

              scan_in4, //added by smarkov4 for dft4
 
              //outputs4
              
              scan_out4, //added by smarkov4 for dft4 
               
              prdata4, 

              gpio_int4, 

              n_gpio_pin_oe4, 
              gpio_pin_out4 
); 
 
//Numeric4 constants4


   // inputs4 
    
   // pclks4  
   input        n_p_reset4;            // amba4 reset 
   input        pclk4;               // peripherical4 pclk4 bus 

   // AMBA4 Rev4 2
   input        psel4;               // peripheral4 select4 for gpio4 
   input        penable4;            // peripheral4 enable 
   input        pwrite4;             // peripheral4 write strobe4 
   input [5:0] 
                paddr4;              // address bus of selected master4 
   input [31:0] 
                pwdata4;             // write data 

   // gpio4 generic4 inputs4 
   input [15:0] 
                gpio_pin_in4;             // input data from pin4 

   //design for test inputs4 
   input        scan_en4;            // enables4 shifting4 of scans4 
   input [15:0] 
                tri_state_enable4;   // disables4 op enable -> z 
   input        scan_in4;            // scan4 chain4 data input  
       
    
   // outputs4 
 
   //amba4 outputs4 
   output [31:0] 
                prdata4;             // read data 
   // gpio4 generic4 outputs4 
   output       gpio_int4;                // gpio_interupt4 for input pin4 change 
   output [15:0] 
                n_gpio_pin_oe4;           // output enable signal4 to pin4 
   output [15:0] 
                gpio_pin_out4;            // output signal4 to pin4 
                
   // scan4 outputs4
   output      scan_out4;            // scan4 chain4 data output

//##############################################################################
// if the GPIO4 is NOT4 black4 boxed4 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_GPIO4

gpio_lite4 i_gpio_lite4(
   //inputs4
   .n_p_reset4(n_p_reset4),
   .pclk4(pclk4),
   .psel4(psel4),
   .penable4(penable4),
   .pwrite4(pwrite4),
   .paddr4(paddr4),
   .pwdata4(pwdata4),
   .gpio_pin_in4(gpio_pin_in4),
   .scan_en4(scan_en4),
   .tri_state_enable4(tri_state_enable4),
   .scan_in4(), //added by smarkov4 for dft4

   //outputs4
   .scan_out4(), //added by smarkov4 for dft4
   .prdata4(prdata4),
   .gpio_int4(gpio_int4),
   .n_gpio_pin_oe4(n_gpio_pin_oe4),
   .gpio_pin_out4(gpio_pin_out4)
);
 
`else 
//##############################################################################
// if the GPIO4 is black4 boxed4 
//##############################################################################

   // inputs4 
    
   // pclks4  
   wire         n_p_reset4;            // amba4 reset 
   wire         pclk4;               // peripherical4 pclk4 bus 

   // AMBA4 Rev4 2
   wire         psel4;               // peripheral4 select4 for gpio4 
   wire         penable4;            // peripheral4 enable 
   wire         pwrite4;             // peripheral4 write strobe4 
   wire  [5:0] 
                paddr4;              // address bus of selected master4 
   wire  [31:0] 
                pwdata4;             // write data 

   // gpio4 generic4 inputs4 
   wire  [15:0] 
                gpio_pin_in4;             // wire  data from pin4 

   //design for test inputs4 
   wire         scan_en4;            // enables4 shifting4 of scans4 
   wire  [15:0] 
                tri_state_enable4;   // disables4 op enable -> z 
   wire         scan_in4;            // scan4 chain4 data wire   
       
    
   // outputs4 
 
   //amba4 outputs4 
   reg    [31:0] 
                prdata4;             // read data 
   // gpio4 generic4 outputs4 
   reg          gpio_int4 =0;                // gpio_interupt4 for wire  pin4 change 
   reg    [15:0] 
                n_gpio_pin_oe4;           // reg    enable signal4 to pin4 
   reg    [15:0] 
                gpio_pin_out4;            // reg    signal4 to pin4 
                
   // scan4 outputs4
   reg         scan_out4;            // scan4 chain4 data output

`endif
//##############################################################################
// black4 boxed4 defines4 
//##############################################################################

endmodule
