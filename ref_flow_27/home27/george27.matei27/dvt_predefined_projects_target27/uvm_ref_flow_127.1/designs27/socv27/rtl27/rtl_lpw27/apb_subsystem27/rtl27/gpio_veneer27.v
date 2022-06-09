//File27 name   : gpio_veneer27.v
//Title27       : 
//Created27     : 1999
//Description27 : 
//Notes27       : 
//----------------------------------------------------------------------
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------

module gpio_veneer27 ( 
              //inputs27 
 
              n_p_reset27, 
              pclk27, 

              psel27, 
              penable27, 
              pwrite27, 
              paddr27, 
              pwdata27, 

              gpio_pin_in27, 

              scan_en27, 
              tri_state_enable27, 

              scan_in27, //added by smarkov27 for dft27
 
              //outputs27
              
              scan_out27, //added by smarkov27 for dft27 
               
              prdata27, 

              gpio_int27, 

              n_gpio_pin_oe27, 
              gpio_pin_out27 
); 
 
//Numeric27 constants27


   // inputs27 
    
   // pclks27  
   input        n_p_reset27;            // amba27 reset 
   input        pclk27;               // peripherical27 pclk27 bus 

   // AMBA27 Rev27 2
   input        psel27;               // peripheral27 select27 for gpio27 
   input        penable27;            // peripheral27 enable 
   input        pwrite27;             // peripheral27 write strobe27 
   input [5:0] 
                paddr27;              // address bus of selected master27 
   input [31:0] 
                pwdata27;             // write data 

   // gpio27 generic27 inputs27 
   input [15:0] 
                gpio_pin_in27;             // input data from pin27 

   //design for test inputs27 
   input        scan_en27;            // enables27 shifting27 of scans27 
   input [15:0] 
                tri_state_enable27;   // disables27 op enable -> z 
   input        scan_in27;            // scan27 chain27 data input  
       
    
   // outputs27 
 
   //amba27 outputs27 
   output [31:0] 
                prdata27;             // read data 
   // gpio27 generic27 outputs27 
   output       gpio_int27;                // gpio_interupt27 for input pin27 change 
   output [15:0] 
                n_gpio_pin_oe27;           // output enable signal27 to pin27 
   output [15:0] 
                gpio_pin_out27;            // output signal27 to pin27 
                
   // scan27 outputs27
   output      scan_out27;            // scan27 chain27 data output

//##############################################################################
// if the GPIO27 is NOT27 black27 boxed27 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_GPIO27

gpio_lite27 i_gpio_lite27(
   //inputs27
   .n_p_reset27(n_p_reset27),
   .pclk27(pclk27),
   .psel27(psel27),
   .penable27(penable27),
   .pwrite27(pwrite27),
   .paddr27(paddr27),
   .pwdata27(pwdata27),
   .gpio_pin_in27(gpio_pin_in27),
   .scan_en27(scan_en27),
   .tri_state_enable27(tri_state_enable27),
   .scan_in27(), //added by smarkov27 for dft27

   //outputs27
   .scan_out27(), //added by smarkov27 for dft27
   .prdata27(prdata27),
   .gpio_int27(gpio_int27),
   .n_gpio_pin_oe27(n_gpio_pin_oe27),
   .gpio_pin_out27(gpio_pin_out27)
);
 
`else 
//##############################################################################
// if the GPIO27 is black27 boxed27 
//##############################################################################

   // inputs27 
    
   // pclks27  
   wire         n_p_reset27;            // amba27 reset 
   wire         pclk27;               // peripherical27 pclk27 bus 

   // AMBA27 Rev27 2
   wire         psel27;               // peripheral27 select27 for gpio27 
   wire         penable27;            // peripheral27 enable 
   wire         pwrite27;             // peripheral27 write strobe27 
   wire  [5:0] 
                paddr27;              // address bus of selected master27 
   wire  [31:0] 
                pwdata27;             // write data 

   // gpio27 generic27 inputs27 
   wire  [15:0] 
                gpio_pin_in27;             // wire  data from pin27 

   //design for test inputs27 
   wire         scan_en27;            // enables27 shifting27 of scans27 
   wire  [15:0] 
                tri_state_enable27;   // disables27 op enable -> z 
   wire         scan_in27;            // scan27 chain27 data wire   
       
    
   // outputs27 
 
   //amba27 outputs27 
   reg    [31:0] 
                prdata27;             // read data 
   // gpio27 generic27 outputs27 
   reg          gpio_int27 =0;                // gpio_interupt27 for wire  pin27 change 
   reg    [15:0] 
                n_gpio_pin_oe27;           // reg    enable signal27 to pin27 
   reg    [15:0] 
                gpio_pin_out27;            // reg    signal27 to pin27 
                
   // scan27 outputs27
   reg         scan_out27;            // scan27 chain27 data output

`endif
//##############################################################################
// black27 boxed27 defines27 
//##############################################################################

endmodule
