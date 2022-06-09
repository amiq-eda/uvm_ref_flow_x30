//File14 name   : gpio_veneer14.v
//Title14       : 
//Created14     : 1999
//Description14 : 
//Notes14       : 
//----------------------------------------------------------------------
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------

module gpio_veneer14 ( 
              //inputs14 
 
              n_p_reset14, 
              pclk14, 

              psel14, 
              penable14, 
              pwrite14, 
              paddr14, 
              pwdata14, 

              gpio_pin_in14, 

              scan_en14, 
              tri_state_enable14, 

              scan_in14, //added by smarkov14 for dft14
 
              //outputs14
              
              scan_out14, //added by smarkov14 for dft14 
               
              prdata14, 

              gpio_int14, 

              n_gpio_pin_oe14, 
              gpio_pin_out14 
); 
 
//Numeric14 constants14


   // inputs14 
    
   // pclks14  
   input        n_p_reset14;            // amba14 reset 
   input        pclk14;               // peripherical14 pclk14 bus 

   // AMBA14 Rev14 2
   input        psel14;               // peripheral14 select14 for gpio14 
   input        penable14;            // peripheral14 enable 
   input        pwrite14;             // peripheral14 write strobe14 
   input [5:0] 
                paddr14;              // address bus of selected master14 
   input [31:0] 
                pwdata14;             // write data 

   // gpio14 generic14 inputs14 
   input [15:0] 
                gpio_pin_in14;             // input data from pin14 

   //design for test inputs14 
   input        scan_en14;            // enables14 shifting14 of scans14 
   input [15:0] 
                tri_state_enable14;   // disables14 op enable -> z 
   input        scan_in14;            // scan14 chain14 data input  
       
    
   // outputs14 
 
   //amba14 outputs14 
   output [31:0] 
                prdata14;             // read data 
   // gpio14 generic14 outputs14 
   output       gpio_int14;                // gpio_interupt14 for input pin14 change 
   output [15:0] 
                n_gpio_pin_oe14;           // output enable signal14 to pin14 
   output [15:0] 
                gpio_pin_out14;            // output signal14 to pin14 
                
   // scan14 outputs14
   output      scan_out14;            // scan14 chain14 data output

//##############################################################################
// if the GPIO14 is NOT14 black14 boxed14 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_GPIO14

gpio_lite14 i_gpio_lite14(
   //inputs14
   .n_p_reset14(n_p_reset14),
   .pclk14(pclk14),
   .psel14(psel14),
   .penable14(penable14),
   .pwrite14(pwrite14),
   .paddr14(paddr14),
   .pwdata14(pwdata14),
   .gpio_pin_in14(gpio_pin_in14),
   .scan_en14(scan_en14),
   .tri_state_enable14(tri_state_enable14),
   .scan_in14(), //added by smarkov14 for dft14

   //outputs14
   .scan_out14(), //added by smarkov14 for dft14
   .prdata14(prdata14),
   .gpio_int14(gpio_int14),
   .n_gpio_pin_oe14(n_gpio_pin_oe14),
   .gpio_pin_out14(gpio_pin_out14)
);
 
`else 
//##############################################################################
// if the GPIO14 is black14 boxed14 
//##############################################################################

   // inputs14 
    
   // pclks14  
   wire         n_p_reset14;            // amba14 reset 
   wire         pclk14;               // peripherical14 pclk14 bus 

   // AMBA14 Rev14 2
   wire         psel14;               // peripheral14 select14 for gpio14 
   wire         penable14;            // peripheral14 enable 
   wire         pwrite14;             // peripheral14 write strobe14 
   wire  [5:0] 
                paddr14;              // address bus of selected master14 
   wire  [31:0] 
                pwdata14;             // write data 

   // gpio14 generic14 inputs14 
   wire  [15:0] 
                gpio_pin_in14;             // wire  data from pin14 

   //design for test inputs14 
   wire         scan_en14;            // enables14 shifting14 of scans14 
   wire  [15:0] 
                tri_state_enable14;   // disables14 op enable -> z 
   wire         scan_in14;            // scan14 chain14 data wire   
       
    
   // outputs14 
 
   //amba14 outputs14 
   reg    [31:0] 
                prdata14;             // read data 
   // gpio14 generic14 outputs14 
   reg          gpio_int14 =0;                // gpio_interupt14 for wire  pin14 change 
   reg    [15:0] 
                n_gpio_pin_oe14;           // reg    enable signal14 to pin14 
   reg    [15:0] 
                gpio_pin_out14;            // reg    signal14 to pin14 
                
   // scan14 outputs14
   reg         scan_out14;            // scan14 chain14 data output

`endif
//##############################################################################
// black14 boxed14 defines14 
//##############################################################################

endmodule
