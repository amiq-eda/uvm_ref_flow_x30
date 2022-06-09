//File11 name   : gpio_veneer11.v
//Title11       : 
//Created11     : 1999
//Description11 : 
//Notes11       : 
//----------------------------------------------------------------------
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------

module gpio_veneer11 ( 
              //inputs11 
 
              n_p_reset11, 
              pclk11, 

              psel11, 
              penable11, 
              pwrite11, 
              paddr11, 
              pwdata11, 

              gpio_pin_in11, 

              scan_en11, 
              tri_state_enable11, 

              scan_in11, //added by smarkov11 for dft11
 
              //outputs11
              
              scan_out11, //added by smarkov11 for dft11 
               
              prdata11, 

              gpio_int11, 

              n_gpio_pin_oe11, 
              gpio_pin_out11 
); 
 
//Numeric11 constants11


   // inputs11 
    
   // pclks11  
   input        n_p_reset11;            // amba11 reset 
   input        pclk11;               // peripherical11 pclk11 bus 

   // AMBA11 Rev11 2
   input        psel11;               // peripheral11 select11 for gpio11 
   input        penable11;            // peripheral11 enable 
   input        pwrite11;             // peripheral11 write strobe11 
   input [5:0] 
                paddr11;              // address bus of selected master11 
   input [31:0] 
                pwdata11;             // write data 

   // gpio11 generic11 inputs11 
   input [15:0] 
                gpio_pin_in11;             // input data from pin11 

   //design for test inputs11 
   input        scan_en11;            // enables11 shifting11 of scans11 
   input [15:0] 
                tri_state_enable11;   // disables11 op enable -> z 
   input        scan_in11;            // scan11 chain11 data input  
       
    
   // outputs11 
 
   //amba11 outputs11 
   output [31:0] 
                prdata11;             // read data 
   // gpio11 generic11 outputs11 
   output       gpio_int11;                // gpio_interupt11 for input pin11 change 
   output [15:0] 
                n_gpio_pin_oe11;           // output enable signal11 to pin11 
   output [15:0] 
                gpio_pin_out11;            // output signal11 to pin11 
                
   // scan11 outputs11
   output      scan_out11;            // scan11 chain11 data output

//##############################################################################
// if the GPIO11 is NOT11 black11 boxed11 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_GPIO11

gpio_lite11 i_gpio_lite11(
   //inputs11
   .n_p_reset11(n_p_reset11),
   .pclk11(pclk11),
   .psel11(psel11),
   .penable11(penable11),
   .pwrite11(pwrite11),
   .paddr11(paddr11),
   .pwdata11(pwdata11),
   .gpio_pin_in11(gpio_pin_in11),
   .scan_en11(scan_en11),
   .tri_state_enable11(tri_state_enable11),
   .scan_in11(), //added by smarkov11 for dft11

   //outputs11
   .scan_out11(), //added by smarkov11 for dft11
   .prdata11(prdata11),
   .gpio_int11(gpio_int11),
   .n_gpio_pin_oe11(n_gpio_pin_oe11),
   .gpio_pin_out11(gpio_pin_out11)
);
 
`else 
//##############################################################################
// if the GPIO11 is black11 boxed11 
//##############################################################################

   // inputs11 
    
   // pclks11  
   wire         n_p_reset11;            // amba11 reset 
   wire         pclk11;               // peripherical11 pclk11 bus 

   // AMBA11 Rev11 2
   wire         psel11;               // peripheral11 select11 for gpio11 
   wire         penable11;            // peripheral11 enable 
   wire         pwrite11;             // peripheral11 write strobe11 
   wire  [5:0] 
                paddr11;              // address bus of selected master11 
   wire  [31:0] 
                pwdata11;             // write data 

   // gpio11 generic11 inputs11 
   wire  [15:0] 
                gpio_pin_in11;             // wire  data from pin11 

   //design for test inputs11 
   wire         scan_en11;            // enables11 shifting11 of scans11 
   wire  [15:0] 
                tri_state_enable11;   // disables11 op enable -> z 
   wire         scan_in11;            // scan11 chain11 data wire   
       
    
   // outputs11 
 
   //amba11 outputs11 
   reg    [31:0] 
                prdata11;             // read data 
   // gpio11 generic11 outputs11 
   reg          gpio_int11 =0;                // gpio_interupt11 for wire  pin11 change 
   reg    [15:0] 
                n_gpio_pin_oe11;           // reg    enable signal11 to pin11 
   reg    [15:0] 
                gpio_pin_out11;            // reg    signal11 to pin11 
                
   // scan11 outputs11
   reg         scan_out11;            // scan11 chain11 data output

`endif
//##############################################################################
// black11 boxed11 defines11 
//##############################################################################

endmodule
