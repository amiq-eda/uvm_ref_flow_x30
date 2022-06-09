//File26 name   : gpio_veneer26.v
//Title26       : 
//Created26     : 1999
//Description26 : 
//Notes26       : 
//----------------------------------------------------------------------
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------

module gpio_veneer26 ( 
              //inputs26 
 
              n_p_reset26, 
              pclk26, 

              psel26, 
              penable26, 
              pwrite26, 
              paddr26, 
              pwdata26, 

              gpio_pin_in26, 

              scan_en26, 
              tri_state_enable26, 

              scan_in26, //added by smarkov26 for dft26
 
              //outputs26
              
              scan_out26, //added by smarkov26 for dft26 
               
              prdata26, 

              gpio_int26, 

              n_gpio_pin_oe26, 
              gpio_pin_out26 
); 
 
//Numeric26 constants26


   // inputs26 
    
   // pclks26  
   input        n_p_reset26;            // amba26 reset 
   input        pclk26;               // peripherical26 pclk26 bus 

   // AMBA26 Rev26 2
   input        psel26;               // peripheral26 select26 for gpio26 
   input        penable26;            // peripheral26 enable 
   input        pwrite26;             // peripheral26 write strobe26 
   input [5:0] 
                paddr26;              // address bus of selected master26 
   input [31:0] 
                pwdata26;             // write data 

   // gpio26 generic26 inputs26 
   input [15:0] 
                gpio_pin_in26;             // input data from pin26 

   //design for test inputs26 
   input        scan_en26;            // enables26 shifting26 of scans26 
   input [15:0] 
                tri_state_enable26;   // disables26 op enable -> z 
   input        scan_in26;            // scan26 chain26 data input  
       
    
   // outputs26 
 
   //amba26 outputs26 
   output [31:0] 
                prdata26;             // read data 
   // gpio26 generic26 outputs26 
   output       gpio_int26;                // gpio_interupt26 for input pin26 change 
   output [15:0] 
                n_gpio_pin_oe26;           // output enable signal26 to pin26 
   output [15:0] 
                gpio_pin_out26;            // output signal26 to pin26 
                
   // scan26 outputs26
   output      scan_out26;            // scan26 chain26 data output

//##############################################################################
// if the GPIO26 is NOT26 black26 boxed26 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_GPIO26

gpio_lite26 i_gpio_lite26(
   //inputs26
   .n_p_reset26(n_p_reset26),
   .pclk26(pclk26),
   .psel26(psel26),
   .penable26(penable26),
   .pwrite26(pwrite26),
   .paddr26(paddr26),
   .pwdata26(pwdata26),
   .gpio_pin_in26(gpio_pin_in26),
   .scan_en26(scan_en26),
   .tri_state_enable26(tri_state_enable26),
   .scan_in26(), //added by smarkov26 for dft26

   //outputs26
   .scan_out26(), //added by smarkov26 for dft26
   .prdata26(prdata26),
   .gpio_int26(gpio_int26),
   .n_gpio_pin_oe26(n_gpio_pin_oe26),
   .gpio_pin_out26(gpio_pin_out26)
);
 
`else 
//##############################################################################
// if the GPIO26 is black26 boxed26 
//##############################################################################

   // inputs26 
    
   // pclks26  
   wire         n_p_reset26;            // amba26 reset 
   wire         pclk26;               // peripherical26 pclk26 bus 

   // AMBA26 Rev26 2
   wire         psel26;               // peripheral26 select26 for gpio26 
   wire         penable26;            // peripheral26 enable 
   wire         pwrite26;             // peripheral26 write strobe26 
   wire  [5:0] 
                paddr26;              // address bus of selected master26 
   wire  [31:0] 
                pwdata26;             // write data 

   // gpio26 generic26 inputs26 
   wire  [15:0] 
                gpio_pin_in26;             // wire  data from pin26 

   //design for test inputs26 
   wire         scan_en26;            // enables26 shifting26 of scans26 
   wire  [15:0] 
                tri_state_enable26;   // disables26 op enable -> z 
   wire         scan_in26;            // scan26 chain26 data wire   
       
    
   // outputs26 
 
   //amba26 outputs26 
   reg    [31:0] 
                prdata26;             // read data 
   // gpio26 generic26 outputs26 
   reg          gpio_int26 =0;                // gpio_interupt26 for wire  pin26 change 
   reg    [15:0] 
                n_gpio_pin_oe26;           // reg    enable signal26 to pin26 
   reg    [15:0] 
                gpio_pin_out26;            // reg    signal26 to pin26 
                
   // scan26 outputs26
   reg         scan_out26;            // scan26 chain26 data output

`endif
//##############################################################################
// black26 boxed26 defines26 
//##############################################################################

endmodule
