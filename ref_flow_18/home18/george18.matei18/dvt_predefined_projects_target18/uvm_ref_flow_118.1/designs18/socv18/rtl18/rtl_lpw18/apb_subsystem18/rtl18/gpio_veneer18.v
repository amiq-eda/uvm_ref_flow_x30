//File18 name   : gpio_veneer18.v
//Title18       : 
//Created18     : 1999
//Description18 : 
//Notes18       : 
//----------------------------------------------------------------------
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------

module gpio_veneer18 ( 
              //inputs18 
 
              n_p_reset18, 
              pclk18, 

              psel18, 
              penable18, 
              pwrite18, 
              paddr18, 
              pwdata18, 

              gpio_pin_in18, 

              scan_en18, 
              tri_state_enable18, 

              scan_in18, //added by smarkov18 for dft18
 
              //outputs18
              
              scan_out18, //added by smarkov18 for dft18 
               
              prdata18, 

              gpio_int18, 

              n_gpio_pin_oe18, 
              gpio_pin_out18 
); 
 
//Numeric18 constants18


   // inputs18 
    
   // pclks18  
   input        n_p_reset18;            // amba18 reset 
   input        pclk18;               // peripherical18 pclk18 bus 

   // AMBA18 Rev18 2
   input        psel18;               // peripheral18 select18 for gpio18 
   input        penable18;            // peripheral18 enable 
   input        pwrite18;             // peripheral18 write strobe18 
   input [5:0] 
                paddr18;              // address bus of selected master18 
   input [31:0] 
                pwdata18;             // write data 

   // gpio18 generic18 inputs18 
   input [15:0] 
                gpio_pin_in18;             // input data from pin18 

   //design for test inputs18 
   input        scan_en18;            // enables18 shifting18 of scans18 
   input [15:0] 
                tri_state_enable18;   // disables18 op enable -> z 
   input        scan_in18;            // scan18 chain18 data input  
       
    
   // outputs18 
 
   //amba18 outputs18 
   output [31:0] 
                prdata18;             // read data 
   // gpio18 generic18 outputs18 
   output       gpio_int18;                // gpio_interupt18 for input pin18 change 
   output [15:0] 
                n_gpio_pin_oe18;           // output enable signal18 to pin18 
   output [15:0] 
                gpio_pin_out18;            // output signal18 to pin18 
                
   // scan18 outputs18
   output      scan_out18;            // scan18 chain18 data output

//##############################################################################
// if the GPIO18 is NOT18 black18 boxed18 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_GPIO18

gpio_lite18 i_gpio_lite18(
   //inputs18
   .n_p_reset18(n_p_reset18),
   .pclk18(pclk18),
   .psel18(psel18),
   .penable18(penable18),
   .pwrite18(pwrite18),
   .paddr18(paddr18),
   .pwdata18(pwdata18),
   .gpio_pin_in18(gpio_pin_in18),
   .scan_en18(scan_en18),
   .tri_state_enable18(tri_state_enable18),
   .scan_in18(), //added by smarkov18 for dft18

   //outputs18
   .scan_out18(), //added by smarkov18 for dft18
   .prdata18(prdata18),
   .gpio_int18(gpio_int18),
   .n_gpio_pin_oe18(n_gpio_pin_oe18),
   .gpio_pin_out18(gpio_pin_out18)
);
 
`else 
//##############################################################################
// if the GPIO18 is black18 boxed18 
//##############################################################################

   // inputs18 
    
   // pclks18  
   wire         n_p_reset18;            // amba18 reset 
   wire         pclk18;               // peripherical18 pclk18 bus 

   // AMBA18 Rev18 2
   wire         psel18;               // peripheral18 select18 for gpio18 
   wire         penable18;            // peripheral18 enable 
   wire         pwrite18;             // peripheral18 write strobe18 
   wire  [5:0] 
                paddr18;              // address bus of selected master18 
   wire  [31:0] 
                pwdata18;             // write data 

   // gpio18 generic18 inputs18 
   wire  [15:0] 
                gpio_pin_in18;             // wire  data from pin18 

   //design for test inputs18 
   wire         scan_en18;            // enables18 shifting18 of scans18 
   wire  [15:0] 
                tri_state_enable18;   // disables18 op enable -> z 
   wire         scan_in18;            // scan18 chain18 data wire   
       
    
   // outputs18 
 
   //amba18 outputs18 
   reg    [31:0] 
                prdata18;             // read data 
   // gpio18 generic18 outputs18 
   reg          gpio_int18 =0;                // gpio_interupt18 for wire  pin18 change 
   reg    [15:0] 
                n_gpio_pin_oe18;           // reg    enable signal18 to pin18 
   reg    [15:0] 
                gpio_pin_out18;            // reg    signal18 to pin18 
                
   // scan18 outputs18
   reg         scan_out18;            // scan18 chain18 data output

`endif
//##############################################################################
// black18 boxed18 defines18 
//##############################################################################

endmodule
