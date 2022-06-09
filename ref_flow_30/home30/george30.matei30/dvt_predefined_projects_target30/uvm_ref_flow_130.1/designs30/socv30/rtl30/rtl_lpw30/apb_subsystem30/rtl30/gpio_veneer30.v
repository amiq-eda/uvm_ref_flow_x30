//File30 name   : gpio_veneer30.v
//Title30       : 
//Created30     : 1999
//Description30 : 
//Notes30       : 
//----------------------------------------------------------------------
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------

module gpio_veneer30 ( 
              //inputs30 
 
              n_p_reset30, 
              pclk30, 

              psel30, 
              penable30, 
              pwrite30, 
              paddr30, 
              pwdata30, 

              gpio_pin_in30, 

              scan_en30, 
              tri_state_enable30, 

              scan_in30, //added by smarkov30 for dft30
 
              //outputs30
              
              scan_out30, //added by smarkov30 for dft30 
               
              prdata30, 

              gpio_int30, 

              n_gpio_pin_oe30, 
              gpio_pin_out30 
); 
 
//Numeric30 constants30


   // inputs30 
    
   // pclks30  
   input        n_p_reset30;            // amba30 reset 
   input        pclk30;               // peripherical30 pclk30 bus 

   // AMBA30 Rev30 2
   input        psel30;               // peripheral30 select30 for gpio30 
   input        penable30;            // peripheral30 enable 
   input        pwrite30;             // peripheral30 write strobe30 
   input [5:0] 
                paddr30;              // address bus of selected master30 
   input [31:0] 
                pwdata30;             // write data 

   // gpio30 generic30 inputs30 
   input [15:0] 
                gpio_pin_in30;             // input data from pin30 

   //design for test inputs30 
   input        scan_en30;            // enables30 shifting30 of scans30 
   input [15:0] 
                tri_state_enable30;   // disables30 op enable -> z 
   input        scan_in30;            // scan30 chain30 data input  
       
    
   // outputs30 
 
   //amba30 outputs30 
   output [31:0] 
                prdata30;             // read data 
   // gpio30 generic30 outputs30 
   output       gpio_int30;                // gpio_interupt30 for input pin30 change 
   output [15:0] 
                n_gpio_pin_oe30;           // output enable signal30 to pin30 
   output [15:0] 
                gpio_pin_out30;            // output signal30 to pin30 
                
   // scan30 outputs30
   output      scan_out30;            // scan30 chain30 data output

//##############################################################################
// if the GPIO30 is NOT30 black30 boxed30 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_GPIO30

gpio_lite30 i_gpio_lite30(
   //inputs30
   .n_p_reset30(n_p_reset30),
   .pclk30(pclk30),
   .psel30(psel30),
   .penable30(penable30),
   .pwrite30(pwrite30),
   .paddr30(paddr30),
   .pwdata30(pwdata30),
   .gpio_pin_in30(gpio_pin_in30),
   .scan_en30(scan_en30),
   .tri_state_enable30(tri_state_enable30),
   .scan_in30(), //added by smarkov30 for dft30

   //outputs30
   .scan_out30(), //added by smarkov30 for dft30
   .prdata30(prdata30),
   .gpio_int30(gpio_int30),
   .n_gpio_pin_oe30(n_gpio_pin_oe30),
   .gpio_pin_out30(gpio_pin_out30)
);
 
`else 
//##############################################################################
// if the GPIO30 is black30 boxed30 
//##############################################################################

   // inputs30 
    
   // pclks30  
   wire         n_p_reset30;            // amba30 reset 
   wire         pclk30;               // peripherical30 pclk30 bus 

   // AMBA30 Rev30 2
   wire         psel30;               // peripheral30 select30 for gpio30 
   wire         penable30;            // peripheral30 enable 
   wire         pwrite30;             // peripheral30 write strobe30 
   wire  [5:0] 
                paddr30;              // address bus of selected master30 
   wire  [31:0] 
                pwdata30;             // write data 

   // gpio30 generic30 inputs30 
   wire  [15:0] 
                gpio_pin_in30;             // wire  data from pin30 

   //design for test inputs30 
   wire         scan_en30;            // enables30 shifting30 of scans30 
   wire  [15:0] 
                tri_state_enable30;   // disables30 op enable -> z 
   wire         scan_in30;            // scan30 chain30 data wire   
       
    
   // outputs30 
 
   //amba30 outputs30 
   reg    [31:0] 
                prdata30;             // read data 
   // gpio30 generic30 outputs30 
   reg          gpio_int30 =0;                // gpio_interupt30 for wire  pin30 change 
   reg    [15:0] 
                n_gpio_pin_oe30;           // reg    enable signal30 to pin30 
   reg    [15:0] 
                gpio_pin_out30;            // reg    signal30 to pin30 
                
   // scan30 outputs30
   reg         scan_out30;            // scan30 chain30 data output

`endif
//##############################################################################
// black30 boxed30 defines30 
//##############################################################################

endmodule
