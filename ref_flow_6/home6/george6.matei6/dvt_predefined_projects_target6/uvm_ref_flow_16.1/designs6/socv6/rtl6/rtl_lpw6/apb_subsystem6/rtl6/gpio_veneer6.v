//File6 name   : gpio_veneer6.v
//Title6       : 
//Created6     : 1999
//Description6 : 
//Notes6       : 
//----------------------------------------------------------------------
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------

module gpio_veneer6 ( 
              //inputs6 
 
              n_p_reset6, 
              pclk6, 

              psel6, 
              penable6, 
              pwrite6, 
              paddr6, 
              pwdata6, 

              gpio_pin_in6, 

              scan_en6, 
              tri_state_enable6, 

              scan_in6, //added by smarkov6 for dft6
 
              //outputs6
              
              scan_out6, //added by smarkov6 for dft6 
               
              prdata6, 

              gpio_int6, 

              n_gpio_pin_oe6, 
              gpio_pin_out6 
); 
 
//Numeric6 constants6


   // inputs6 
    
   // pclks6  
   input        n_p_reset6;            // amba6 reset 
   input        pclk6;               // peripherical6 pclk6 bus 

   // AMBA6 Rev6 2
   input        psel6;               // peripheral6 select6 for gpio6 
   input        penable6;            // peripheral6 enable 
   input        pwrite6;             // peripheral6 write strobe6 
   input [5:0] 
                paddr6;              // address bus of selected master6 
   input [31:0] 
                pwdata6;             // write data 

   // gpio6 generic6 inputs6 
   input [15:0] 
                gpio_pin_in6;             // input data from pin6 

   //design for test inputs6 
   input        scan_en6;            // enables6 shifting6 of scans6 
   input [15:0] 
                tri_state_enable6;   // disables6 op enable -> z 
   input        scan_in6;            // scan6 chain6 data input  
       
    
   // outputs6 
 
   //amba6 outputs6 
   output [31:0] 
                prdata6;             // read data 
   // gpio6 generic6 outputs6 
   output       gpio_int6;                // gpio_interupt6 for input pin6 change 
   output [15:0] 
                n_gpio_pin_oe6;           // output enable signal6 to pin6 
   output [15:0] 
                gpio_pin_out6;            // output signal6 to pin6 
                
   // scan6 outputs6
   output      scan_out6;            // scan6 chain6 data output

//##############################################################################
// if the GPIO6 is NOT6 black6 boxed6 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_GPIO6

gpio_lite6 i_gpio_lite6(
   //inputs6
   .n_p_reset6(n_p_reset6),
   .pclk6(pclk6),
   .psel6(psel6),
   .penable6(penable6),
   .pwrite6(pwrite6),
   .paddr6(paddr6),
   .pwdata6(pwdata6),
   .gpio_pin_in6(gpio_pin_in6),
   .scan_en6(scan_en6),
   .tri_state_enable6(tri_state_enable6),
   .scan_in6(), //added by smarkov6 for dft6

   //outputs6
   .scan_out6(), //added by smarkov6 for dft6
   .prdata6(prdata6),
   .gpio_int6(gpio_int6),
   .n_gpio_pin_oe6(n_gpio_pin_oe6),
   .gpio_pin_out6(gpio_pin_out6)
);
 
`else 
//##############################################################################
// if the GPIO6 is black6 boxed6 
//##############################################################################

   // inputs6 
    
   // pclks6  
   wire         n_p_reset6;            // amba6 reset 
   wire         pclk6;               // peripherical6 pclk6 bus 

   // AMBA6 Rev6 2
   wire         psel6;               // peripheral6 select6 for gpio6 
   wire         penable6;            // peripheral6 enable 
   wire         pwrite6;             // peripheral6 write strobe6 
   wire  [5:0] 
                paddr6;              // address bus of selected master6 
   wire  [31:0] 
                pwdata6;             // write data 

   // gpio6 generic6 inputs6 
   wire  [15:0] 
                gpio_pin_in6;             // wire  data from pin6 

   //design for test inputs6 
   wire         scan_en6;            // enables6 shifting6 of scans6 
   wire  [15:0] 
                tri_state_enable6;   // disables6 op enable -> z 
   wire         scan_in6;            // scan6 chain6 data wire   
       
    
   // outputs6 
 
   //amba6 outputs6 
   reg    [31:0] 
                prdata6;             // read data 
   // gpio6 generic6 outputs6 
   reg          gpio_int6 =0;                // gpio_interupt6 for wire  pin6 change 
   reg    [15:0] 
                n_gpio_pin_oe6;           // reg    enable signal6 to pin6 
   reg    [15:0] 
                gpio_pin_out6;            // reg    signal6 to pin6 
                
   // scan6 outputs6
   reg         scan_out6;            // scan6 chain6 data output

`endif
//##############################################################################
// black6 boxed6 defines6 
//##############################################################################

endmodule
