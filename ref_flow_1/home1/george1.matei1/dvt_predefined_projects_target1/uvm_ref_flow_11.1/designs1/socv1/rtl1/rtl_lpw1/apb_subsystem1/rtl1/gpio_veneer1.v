//File1 name   : gpio_veneer1.v
//Title1       : 
//Created1     : 1999
//Description1 : 
//Notes1       : 
//----------------------------------------------------------------------
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------

module gpio_veneer1 ( 
              //inputs1 
 
              n_p_reset1, 
              pclk1, 

              psel1, 
              penable1, 
              pwrite1, 
              paddr1, 
              pwdata1, 

              gpio_pin_in1, 

              scan_en1, 
              tri_state_enable1, 

              scan_in1, //added by smarkov1 for dft1
 
              //outputs1
              
              scan_out1, //added by smarkov1 for dft1 
               
              prdata1, 

              gpio_int1, 

              n_gpio_pin_oe1, 
              gpio_pin_out1 
); 
 
//Numeric1 constants1


   // inputs1 
    
   // pclks1  
   input        n_p_reset1;            // amba1 reset 
   input        pclk1;               // peripherical1 pclk1 bus 

   // AMBA1 Rev1 2
   input        psel1;               // peripheral1 select1 for gpio1 
   input        penable1;            // peripheral1 enable 
   input        pwrite1;             // peripheral1 write strobe1 
   input [5:0] 
                paddr1;              // address bus of selected master1 
   input [31:0] 
                pwdata1;             // write data 

   // gpio1 generic1 inputs1 
   input [15:0] 
                gpio_pin_in1;             // input data from pin1 

   //design for test inputs1 
   input        scan_en1;            // enables1 shifting1 of scans1 
   input [15:0] 
                tri_state_enable1;   // disables1 op enable -> z 
   input        scan_in1;            // scan1 chain1 data input  
       
    
   // outputs1 
 
   //amba1 outputs1 
   output [31:0] 
                prdata1;             // read data 
   // gpio1 generic1 outputs1 
   output       gpio_int1;                // gpio_interupt1 for input pin1 change 
   output [15:0] 
                n_gpio_pin_oe1;           // output enable signal1 to pin1 
   output [15:0] 
                gpio_pin_out1;            // output signal1 to pin1 
                
   // scan1 outputs1
   output      scan_out1;            // scan1 chain1 data output

//##############################################################################
// if the GPIO1 is NOT1 black1 boxed1 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_GPIO1

gpio_lite1 i_gpio_lite1(
   //inputs1
   .n_p_reset1(n_p_reset1),
   .pclk1(pclk1),
   .psel1(psel1),
   .penable1(penable1),
   .pwrite1(pwrite1),
   .paddr1(paddr1),
   .pwdata1(pwdata1),
   .gpio_pin_in1(gpio_pin_in1),
   .scan_en1(scan_en1),
   .tri_state_enable1(tri_state_enable1),
   .scan_in1(), //added by smarkov1 for dft1

   //outputs1
   .scan_out1(), //added by smarkov1 for dft1
   .prdata1(prdata1),
   .gpio_int1(gpio_int1),
   .n_gpio_pin_oe1(n_gpio_pin_oe1),
   .gpio_pin_out1(gpio_pin_out1)
);
 
`else 
//##############################################################################
// if the GPIO1 is black1 boxed1 
//##############################################################################

   // inputs1 
    
   // pclks1  
   wire         n_p_reset1;            // amba1 reset 
   wire         pclk1;               // peripherical1 pclk1 bus 

   // AMBA1 Rev1 2
   wire         psel1;               // peripheral1 select1 for gpio1 
   wire         penable1;            // peripheral1 enable 
   wire         pwrite1;             // peripheral1 write strobe1 
   wire  [5:0] 
                paddr1;              // address bus of selected master1 
   wire  [31:0] 
                pwdata1;             // write data 

   // gpio1 generic1 inputs1 
   wire  [15:0] 
                gpio_pin_in1;             // wire  data from pin1 

   //design for test inputs1 
   wire         scan_en1;            // enables1 shifting1 of scans1 
   wire  [15:0] 
                tri_state_enable1;   // disables1 op enable -> z 
   wire         scan_in1;            // scan1 chain1 data wire   
       
    
   // outputs1 
 
   //amba1 outputs1 
   reg    [31:0] 
                prdata1;             // read data 
   // gpio1 generic1 outputs1 
   reg          gpio_int1 =0;                // gpio_interupt1 for wire  pin1 change 
   reg    [15:0] 
                n_gpio_pin_oe1;           // reg    enable signal1 to pin1 
   reg    [15:0] 
                gpio_pin_out1;            // reg    signal1 to pin1 
                
   // scan1 outputs1
   reg         scan_out1;            // scan1 chain1 data output

`endif
//##############################################################################
// black1 boxed1 defines1 
//##############################################################################

endmodule
