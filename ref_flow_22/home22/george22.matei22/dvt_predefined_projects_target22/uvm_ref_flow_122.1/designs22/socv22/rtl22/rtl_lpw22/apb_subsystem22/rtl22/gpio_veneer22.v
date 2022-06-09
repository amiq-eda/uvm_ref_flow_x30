//File22 name   : gpio_veneer22.v
//Title22       : 
//Created22     : 1999
//Description22 : 
//Notes22       : 
//----------------------------------------------------------------------
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------

module gpio_veneer22 ( 
              //inputs22 
 
              n_p_reset22, 
              pclk22, 

              psel22, 
              penable22, 
              pwrite22, 
              paddr22, 
              pwdata22, 

              gpio_pin_in22, 

              scan_en22, 
              tri_state_enable22, 

              scan_in22, //added by smarkov22 for dft22
 
              //outputs22
              
              scan_out22, //added by smarkov22 for dft22 
               
              prdata22, 

              gpio_int22, 

              n_gpio_pin_oe22, 
              gpio_pin_out22 
); 
 
//Numeric22 constants22


   // inputs22 
    
   // pclks22  
   input        n_p_reset22;            // amba22 reset 
   input        pclk22;               // peripherical22 pclk22 bus 

   // AMBA22 Rev22 2
   input        psel22;               // peripheral22 select22 for gpio22 
   input        penable22;            // peripheral22 enable 
   input        pwrite22;             // peripheral22 write strobe22 
   input [5:0] 
                paddr22;              // address bus of selected master22 
   input [31:0] 
                pwdata22;             // write data 

   // gpio22 generic22 inputs22 
   input [15:0] 
                gpio_pin_in22;             // input data from pin22 

   //design for test inputs22 
   input        scan_en22;            // enables22 shifting22 of scans22 
   input [15:0] 
                tri_state_enable22;   // disables22 op enable -> z 
   input        scan_in22;            // scan22 chain22 data input  
       
    
   // outputs22 
 
   //amba22 outputs22 
   output [31:0] 
                prdata22;             // read data 
   // gpio22 generic22 outputs22 
   output       gpio_int22;                // gpio_interupt22 for input pin22 change 
   output [15:0] 
                n_gpio_pin_oe22;           // output enable signal22 to pin22 
   output [15:0] 
                gpio_pin_out22;            // output signal22 to pin22 
                
   // scan22 outputs22
   output      scan_out22;            // scan22 chain22 data output

//##############################################################################
// if the GPIO22 is NOT22 black22 boxed22 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_GPIO22

gpio_lite22 i_gpio_lite22(
   //inputs22
   .n_p_reset22(n_p_reset22),
   .pclk22(pclk22),
   .psel22(psel22),
   .penable22(penable22),
   .pwrite22(pwrite22),
   .paddr22(paddr22),
   .pwdata22(pwdata22),
   .gpio_pin_in22(gpio_pin_in22),
   .scan_en22(scan_en22),
   .tri_state_enable22(tri_state_enable22),
   .scan_in22(), //added by smarkov22 for dft22

   //outputs22
   .scan_out22(), //added by smarkov22 for dft22
   .prdata22(prdata22),
   .gpio_int22(gpio_int22),
   .n_gpio_pin_oe22(n_gpio_pin_oe22),
   .gpio_pin_out22(gpio_pin_out22)
);
 
`else 
//##############################################################################
// if the GPIO22 is black22 boxed22 
//##############################################################################

   // inputs22 
    
   // pclks22  
   wire         n_p_reset22;            // amba22 reset 
   wire         pclk22;               // peripherical22 pclk22 bus 

   // AMBA22 Rev22 2
   wire         psel22;               // peripheral22 select22 for gpio22 
   wire         penable22;            // peripheral22 enable 
   wire         pwrite22;             // peripheral22 write strobe22 
   wire  [5:0] 
                paddr22;              // address bus of selected master22 
   wire  [31:0] 
                pwdata22;             // write data 

   // gpio22 generic22 inputs22 
   wire  [15:0] 
                gpio_pin_in22;             // wire  data from pin22 

   //design for test inputs22 
   wire         scan_en22;            // enables22 shifting22 of scans22 
   wire  [15:0] 
                tri_state_enable22;   // disables22 op enable -> z 
   wire         scan_in22;            // scan22 chain22 data wire   
       
    
   // outputs22 
 
   //amba22 outputs22 
   reg    [31:0] 
                prdata22;             // read data 
   // gpio22 generic22 outputs22 
   reg          gpio_int22 =0;                // gpio_interupt22 for wire  pin22 change 
   reg    [15:0] 
                n_gpio_pin_oe22;           // reg    enable signal22 to pin22 
   reg    [15:0] 
                gpio_pin_out22;            // reg    signal22 to pin22 
                
   // scan22 outputs22
   reg         scan_out22;            // scan22 chain22 data output

`endif
//##############################################################################
// black22 boxed22 defines22 
//##############################################################################

endmodule
