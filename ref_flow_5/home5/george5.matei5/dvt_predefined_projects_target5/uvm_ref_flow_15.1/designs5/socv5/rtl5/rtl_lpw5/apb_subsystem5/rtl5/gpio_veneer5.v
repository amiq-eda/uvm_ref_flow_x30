//File5 name   : gpio_veneer5.v
//Title5       : 
//Created5     : 1999
//Description5 : 
//Notes5       : 
//----------------------------------------------------------------------
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------

module gpio_veneer5 ( 
              //inputs5 
 
              n_p_reset5, 
              pclk5, 

              psel5, 
              penable5, 
              pwrite5, 
              paddr5, 
              pwdata5, 

              gpio_pin_in5, 

              scan_en5, 
              tri_state_enable5, 

              scan_in5, //added by smarkov5 for dft5
 
              //outputs5
              
              scan_out5, //added by smarkov5 for dft5 
               
              prdata5, 

              gpio_int5, 

              n_gpio_pin_oe5, 
              gpio_pin_out5 
); 
 
//Numeric5 constants5


   // inputs5 
    
   // pclks5  
   input        n_p_reset5;            // amba5 reset 
   input        pclk5;               // peripherical5 pclk5 bus 

   // AMBA5 Rev5 2
   input        psel5;               // peripheral5 select5 for gpio5 
   input        penable5;            // peripheral5 enable 
   input        pwrite5;             // peripheral5 write strobe5 
   input [5:0] 
                paddr5;              // address bus of selected master5 
   input [31:0] 
                pwdata5;             // write data 

   // gpio5 generic5 inputs5 
   input [15:0] 
                gpio_pin_in5;             // input data from pin5 

   //design for test inputs5 
   input        scan_en5;            // enables5 shifting5 of scans5 
   input [15:0] 
                tri_state_enable5;   // disables5 op enable -> z 
   input        scan_in5;            // scan5 chain5 data input  
       
    
   // outputs5 
 
   //amba5 outputs5 
   output [31:0] 
                prdata5;             // read data 
   // gpio5 generic5 outputs5 
   output       gpio_int5;                // gpio_interupt5 for input pin5 change 
   output [15:0] 
                n_gpio_pin_oe5;           // output enable signal5 to pin5 
   output [15:0] 
                gpio_pin_out5;            // output signal5 to pin5 
                
   // scan5 outputs5
   output      scan_out5;            // scan5 chain5 data output

//##############################################################################
// if the GPIO5 is NOT5 black5 boxed5 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_GPIO5

gpio_lite5 i_gpio_lite5(
   //inputs5
   .n_p_reset5(n_p_reset5),
   .pclk5(pclk5),
   .psel5(psel5),
   .penable5(penable5),
   .pwrite5(pwrite5),
   .paddr5(paddr5),
   .pwdata5(pwdata5),
   .gpio_pin_in5(gpio_pin_in5),
   .scan_en5(scan_en5),
   .tri_state_enable5(tri_state_enable5),
   .scan_in5(), //added by smarkov5 for dft5

   //outputs5
   .scan_out5(), //added by smarkov5 for dft5
   .prdata5(prdata5),
   .gpio_int5(gpio_int5),
   .n_gpio_pin_oe5(n_gpio_pin_oe5),
   .gpio_pin_out5(gpio_pin_out5)
);
 
`else 
//##############################################################################
// if the GPIO5 is black5 boxed5 
//##############################################################################

   // inputs5 
    
   // pclks5  
   wire         n_p_reset5;            // amba5 reset 
   wire         pclk5;               // peripherical5 pclk5 bus 

   // AMBA5 Rev5 2
   wire         psel5;               // peripheral5 select5 for gpio5 
   wire         penable5;            // peripheral5 enable 
   wire         pwrite5;             // peripheral5 write strobe5 
   wire  [5:0] 
                paddr5;              // address bus of selected master5 
   wire  [31:0] 
                pwdata5;             // write data 

   // gpio5 generic5 inputs5 
   wire  [15:0] 
                gpio_pin_in5;             // wire  data from pin5 

   //design for test inputs5 
   wire         scan_en5;            // enables5 shifting5 of scans5 
   wire  [15:0] 
                tri_state_enable5;   // disables5 op enable -> z 
   wire         scan_in5;            // scan5 chain5 data wire   
       
    
   // outputs5 
 
   //amba5 outputs5 
   reg    [31:0] 
                prdata5;             // read data 
   // gpio5 generic5 outputs5 
   reg          gpio_int5 =0;                // gpio_interupt5 for wire  pin5 change 
   reg    [15:0] 
                n_gpio_pin_oe5;           // reg    enable signal5 to pin5 
   reg    [15:0] 
                gpio_pin_out5;            // reg    signal5 to pin5 
                
   // scan5 outputs5
   reg         scan_out5;            // scan5 chain5 data output

`endif
//##############################################################################
// black5 boxed5 defines5 
//##############################################################################

endmodule
