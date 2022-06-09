//File2 name   : gpio_veneer2.v
//Title2       : 
//Created2     : 1999
//Description2 : 
//Notes2       : 
//----------------------------------------------------------------------
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------

module gpio_veneer2 ( 
              //inputs2 
 
              n_p_reset2, 
              pclk2, 

              psel2, 
              penable2, 
              pwrite2, 
              paddr2, 
              pwdata2, 

              gpio_pin_in2, 

              scan_en2, 
              tri_state_enable2, 

              scan_in2, //added by smarkov2 for dft2
 
              //outputs2
              
              scan_out2, //added by smarkov2 for dft2 
               
              prdata2, 

              gpio_int2, 

              n_gpio_pin_oe2, 
              gpio_pin_out2 
); 
 
//Numeric2 constants2


   // inputs2 
    
   // pclks2  
   input        n_p_reset2;            // amba2 reset 
   input        pclk2;               // peripherical2 pclk2 bus 

   // AMBA2 Rev2 2
   input        psel2;               // peripheral2 select2 for gpio2 
   input        penable2;            // peripheral2 enable 
   input        pwrite2;             // peripheral2 write strobe2 
   input [5:0] 
                paddr2;              // address bus of selected master2 
   input [31:0] 
                pwdata2;             // write data 

   // gpio2 generic2 inputs2 
   input [15:0] 
                gpio_pin_in2;             // input data from pin2 

   //design for test inputs2 
   input        scan_en2;            // enables2 shifting2 of scans2 
   input [15:0] 
                tri_state_enable2;   // disables2 op enable -> z 
   input        scan_in2;            // scan2 chain2 data input  
       
    
   // outputs2 
 
   //amba2 outputs2 
   output [31:0] 
                prdata2;             // read data 
   // gpio2 generic2 outputs2 
   output       gpio_int2;                // gpio_interupt2 for input pin2 change 
   output [15:0] 
                n_gpio_pin_oe2;           // output enable signal2 to pin2 
   output [15:0] 
                gpio_pin_out2;            // output signal2 to pin2 
                
   // scan2 outputs2
   output      scan_out2;            // scan2 chain2 data output

//##############################################################################
// if the GPIO2 is NOT2 black2 boxed2 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_GPIO2

gpio_lite2 i_gpio_lite2(
   //inputs2
   .n_p_reset2(n_p_reset2),
   .pclk2(pclk2),
   .psel2(psel2),
   .penable2(penable2),
   .pwrite2(pwrite2),
   .paddr2(paddr2),
   .pwdata2(pwdata2),
   .gpio_pin_in2(gpio_pin_in2),
   .scan_en2(scan_en2),
   .tri_state_enable2(tri_state_enable2),
   .scan_in2(), //added by smarkov2 for dft2

   //outputs2
   .scan_out2(), //added by smarkov2 for dft2
   .prdata2(prdata2),
   .gpio_int2(gpio_int2),
   .n_gpio_pin_oe2(n_gpio_pin_oe2),
   .gpio_pin_out2(gpio_pin_out2)
);
 
`else 
//##############################################################################
// if the GPIO2 is black2 boxed2 
//##############################################################################

   // inputs2 
    
   // pclks2  
   wire         n_p_reset2;            // amba2 reset 
   wire         pclk2;               // peripherical2 pclk2 bus 

   // AMBA2 Rev2 2
   wire         psel2;               // peripheral2 select2 for gpio2 
   wire         penable2;            // peripheral2 enable 
   wire         pwrite2;             // peripheral2 write strobe2 
   wire  [5:0] 
                paddr2;              // address bus of selected master2 
   wire  [31:0] 
                pwdata2;             // write data 

   // gpio2 generic2 inputs2 
   wire  [15:0] 
                gpio_pin_in2;             // wire  data from pin2 

   //design for test inputs2 
   wire         scan_en2;            // enables2 shifting2 of scans2 
   wire  [15:0] 
                tri_state_enable2;   // disables2 op enable -> z 
   wire         scan_in2;            // scan2 chain2 data wire   
       
    
   // outputs2 
 
   //amba2 outputs2 
   reg    [31:0] 
                prdata2;             // read data 
   // gpio2 generic2 outputs2 
   reg          gpio_int2 =0;                // gpio_interupt2 for wire  pin2 change 
   reg    [15:0] 
                n_gpio_pin_oe2;           // reg    enable signal2 to pin2 
   reg    [15:0] 
                gpio_pin_out2;            // reg    signal2 to pin2 
                
   // scan2 outputs2
   reg         scan_out2;            // scan2 chain2 data output

`endif
//##############################################################################
// black2 boxed2 defines2 
//##############################################################################

endmodule
