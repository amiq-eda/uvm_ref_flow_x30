//File29 name   : gpio_veneer29.v
//Title29       : 
//Created29     : 1999
//Description29 : 
//Notes29       : 
//----------------------------------------------------------------------
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------

module gpio_veneer29 ( 
              //inputs29 
 
              n_p_reset29, 
              pclk29, 

              psel29, 
              penable29, 
              pwrite29, 
              paddr29, 
              pwdata29, 

              gpio_pin_in29, 

              scan_en29, 
              tri_state_enable29, 

              scan_in29, //added by smarkov29 for dft29
 
              //outputs29
              
              scan_out29, //added by smarkov29 for dft29 
               
              prdata29, 

              gpio_int29, 

              n_gpio_pin_oe29, 
              gpio_pin_out29 
); 
 
//Numeric29 constants29


   // inputs29 
    
   // pclks29  
   input        n_p_reset29;            // amba29 reset 
   input        pclk29;               // peripherical29 pclk29 bus 

   // AMBA29 Rev29 2
   input        psel29;               // peripheral29 select29 for gpio29 
   input        penable29;            // peripheral29 enable 
   input        pwrite29;             // peripheral29 write strobe29 
   input [5:0] 
                paddr29;              // address bus of selected master29 
   input [31:0] 
                pwdata29;             // write data 

   // gpio29 generic29 inputs29 
   input [15:0] 
                gpio_pin_in29;             // input data from pin29 

   //design for test inputs29 
   input        scan_en29;            // enables29 shifting29 of scans29 
   input [15:0] 
                tri_state_enable29;   // disables29 op enable -> z 
   input        scan_in29;            // scan29 chain29 data input  
       
    
   // outputs29 
 
   //amba29 outputs29 
   output [31:0] 
                prdata29;             // read data 
   // gpio29 generic29 outputs29 
   output       gpio_int29;                // gpio_interupt29 for input pin29 change 
   output [15:0] 
                n_gpio_pin_oe29;           // output enable signal29 to pin29 
   output [15:0] 
                gpio_pin_out29;            // output signal29 to pin29 
                
   // scan29 outputs29
   output      scan_out29;            // scan29 chain29 data output

//##############################################################################
// if the GPIO29 is NOT29 black29 boxed29 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_GPIO29

gpio_lite29 i_gpio_lite29(
   //inputs29
   .n_p_reset29(n_p_reset29),
   .pclk29(pclk29),
   .psel29(psel29),
   .penable29(penable29),
   .pwrite29(pwrite29),
   .paddr29(paddr29),
   .pwdata29(pwdata29),
   .gpio_pin_in29(gpio_pin_in29),
   .scan_en29(scan_en29),
   .tri_state_enable29(tri_state_enable29),
   .scan_in29(), //added by smarkov29 for dft29

   //outputs29
   .scan_out29(), //added by smarkov29 for dft29
   .prdata29(prdata29),
   .gpio_int29(gpio_int29),
   .n_gpio_pin_oe29(n_gpio_pin_oe29),
   .gpio_pin_out29(gpio_pin_out29)
);
 
`else 
//##############################################################################
// if the GPIO29 is black29 boxed29 
//##############################################################################

   // inputs29 
    
   // pclks29  
   wire         n_p_reset29;            // amba29 reset 
   wire         pclk29;               // peripherical29 pclk29 bus 

   // AMBA29 Rev29 2
   wire         psel29;               // peripheral29 select29 for gpio29 
   wire         penable29;            // peripheral29 enable 
   wire         pwrite29;             // peripheral29 write strobe29 
   wire  [5:0] 
                paddr29;              // address bus of selected master29 
   wire  [31:0] 
                pwdata29;             // write data 

   // gpio29 generic29 inputs29 
   wire  [15:0] 
                gpio_pin_in29;             // wire  data from pin29 

   //design for test inputs29 
   wire         scan_en29;            // enables29 shifting29 of scans29 
   wire  [15:0] 
                tri_state_enable29;   // disables29 op enable -> z 
   wire         scan_in29;            // scan29 chain29 data wire   
       
    
   // outputs29 
 
   //amba29 outputs29 
   reg    [31:0] 
                prdata29;             // read data 
   // gpio29 generic29 outputs29 
   reg          gpio_int29 =0;                // gpio_interupt29 for wire  pin29 change 
   reg    [15:0] 
                n_gpio_pin_oe29;           // reg    enable signal29 to pin29 
   reg    [15:0] 
                gpio_pin_out29;            // reg    signal29 to pin29 
                
   // scan29 outputs29
   reg         scan_out29;            // scan29 chain29 data output

`endif
//##############################################################################
// black29 boxed29 defines29 
//##############################################################################

endmodule
