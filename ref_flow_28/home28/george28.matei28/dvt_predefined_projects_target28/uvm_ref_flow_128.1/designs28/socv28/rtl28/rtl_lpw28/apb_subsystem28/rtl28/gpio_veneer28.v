//File28 name   : gpio_veneer28.v
//Title28       : 
//Created28     : 1999
//Description28 : 
//Notes28       : 
//----------------------------------------------------------------------
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------

module gpio_veneer28 ( 
              //inputs28 
 
              n_p_reset28, 
              pclk28, 

              psel28, 
              penable28, 
              pwrite28, 
              paddr28, 
              pwdata28, 

              gpio_pin_in28, 

              scan_en28, 
              tri_state_enable28, 

              scan_in28, //added by smarkov28 for dft28
 
              //outputs28
              
              scan_out28, //added by smarkov28 for dft28 
               
              prdata28, 

              gpio_int28, 

              n_gpio_pin_oe28, 
              gpio_pin_out28 
); 
 
//Numeric28 constants28


   // inputs28 
    
   // pclks28  
   input        n_p_reset28;            // amba28 reset 
   input        pclk28;               // peripherical28 pclk28 bus 

   // AMBA28 Rev28 2
   input        psel28;               // peripheral28 select28 for gpio28 
   input        penable28;            // peripheral28 enable 
   input        pwrite28;             // peripheral28 write strobe28 
   input [5:0] 
                paddr28;              // address bus of selected master28 
   input [31:0] 
                pwdata28;             // write data 

   // gpio28 generic28 inputs28 
   input [15:0] 
                gpio_pin_in28;             // input data from pin28 

   //design for test inputs28 
   input        scan_en28;            // enables28 shifting28 of scans28 
   input [15:0] 
                tri_state_enable28;   // disables28 op enable -> z 
   input        scan_in28;            // scan28 chain28 data input  
       
    
   // outputs28 
 
   //amba28 outputs28 
   output [31:0] 
                prdata28;             // read data 
   // gpio28 generic28 outputs28 
   output       gpio_int28;                // gpio_interupt28 for input pin28 change 
   output [15:0] 
                n_gpio_pin_oe28;           // output enable signal28 to pin28 
   output [15:0] 
                gpio_pin_out28;            // output signal28 to pin28 
                
   // scan28 outputs28
   output      scan_out28;            // scan28 chain28 data output

//##############################################################################
// if the GPIO28 is NOT28 black28 boxed28 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_GPIO28

gpio_lite28 i_gpio_lite28(
   //inputs28
   .n_p_reset28(n_p_reset28),
   .pclk28(pclk28),
   .psel28(psel28),
   .penable28(penable28),
   .pwrite28(pwrite28),
   .paddr28(paddr28),
   .pwdata28(pwdata28),
   .gpio_pin_in28(gpio_pin_in28),
   .scan_en28(scan_en28),
   .tri_state_enable28(tri_state_enable28),
   .scan_in28(), //added by smarkov28 for dft28

   //outputs28
   .scan_out28(), //added by smarkov28 for dft28
   .prdata28(prdata28),
   .gpio_int28(gpio_int28),
   .n_gpio_pin_oe28(n_gpio_pin_oe28),
   .gpio_pin_out28(gpio_pin_out28)
);
 
`else 
//##############################################################################
// if the GPIO28 is black28 boxed28 
//##############################################################################

   // inputs28 
    
   // pclks28  
   wire         n_p_reset28;            // amba28 reset 
   wire         pclk28;               // peripherical28 pclk28 bus 

   // AMBA28 Rev28 2
   wire         psel28;               // peripheral28 select28 for gpio28 
   wire         penable28;            // peripheral28 enable 
   wire         pwrite28;             // peripheral28 write strobe28 
   wire  [5:0] 
                paddr28;              // address bus of selected master28 
   wire  [31:0] 
                pwdata28;             // write data 

   // gpio28 generic28 inputs28 
   wire  [15:0] 
                gpio_pin_in28;             // wire  data from pin28 

   //design for test inputs28 
   wire         scan_en28;            // enables28 shifting28 of scans28 
   wire  [15:0] 
                tri_state_enable28;   // disables28 op enable -> z 
   wire         scan_in28;            // scan28 chain28 data wire   
       
    
   // outputs28 
 
   //amba28 outputs28 
   reg    [31:0] 
                prdata28;             // read data 
   // gpio28 generic28 outputs28 
   reg          gpio_int28 =0;                // gpio_interupt28 for wire  pin28 change 
   reg    [15:0] 
                n_gpio_pin_oe28;           // reg    enable signal28 to pin28 
   reg    [15:0] 
                gpio_pin_out28;            // reg    signal28 to pin28 
                
   // scan28 outputs28
   reg         scan_out28;            // scan28 chain28 data output

`endif
//##############################################################################
// black28 boxed28 defines28 
//##############################################################################

endmodule
