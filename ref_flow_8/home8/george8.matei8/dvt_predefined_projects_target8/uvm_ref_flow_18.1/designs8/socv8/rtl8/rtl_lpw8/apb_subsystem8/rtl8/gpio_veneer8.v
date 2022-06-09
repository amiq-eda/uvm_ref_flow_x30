//File8 name   : gpio_veneer8.v
//Title8       : 
//Created8     : 1999
//Description8 : 
//Notes8       : 
//----------------------------------------------------------------------
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------

module gpio_veneer8 ( 
              //inputs8 
 
              n_p_reset8, 
              pclk8, 

              psel8, 
              penable8, 
              pwrite8, 
              paddr8, 
              pwdata8, 

              gpio_pin_in8, 

              scan_en8, 
              tri_state_enable8, 

              scan_in8, //added by smarkov8 for dft8
 
              //outputs8
              
              scan_out8, //added by smarkov8 for dft8 
               
              prdata8, 

              gpio_int8, 

              n_gpio_pin_oe8, 
              gpio_pin_out8 
); 
 
//Numeric8 constants8


   // inputs8 
    
   // pclks8  
   input        n_p_reset8;            // amba8 reset 
   input        pclk8;               // peripherical8 pclk8 bus 

   // AMBA8 Rev8 2
   input        psel8;               // peripheral8 select8 for gpio8 
   input        penable8;            // peripheral8 enable 
   input        pwrite8;             // peripheral8 write strobe8 
   input [5:0] 
                paddr8;              // address bus of selected master8 
   input [31:0] 
                pwdata8;             // write data 

   // gpio8 generic8 inputs8 
   input [15:0] 
                gpio_pin_in8;             // input data from pin8 

   //design for test inputs8 
   input        scan_en8;            // enables8 shifting8 of scans8 
   input [15:0] 
                tri_state_enable8;   // disables8 op enable -> z 
   input        scan_in8;            // scan8 chain8 data input  
       
    
   // outputs8 
 
   //amba8 outputs8 
   output [31:0] 
                prdata8;             // read data 
   // gpio8 generic8 outputs8 
   output       gpio_int8;                // gpio_interupt8 for input pin8 change 
   output [15:0] 
                n_gpio_pin_oe8;           // output enable signal8 to pin8 
   output [15:0] 
                gpio_pin_out8;            // output signal8 to pin8 
                
   // scan8 outputs8
   output      scan_out8;            // scan8 chain8 data output

//##############################################################################
// if the GPIO8 is NOT8 black8 boxed8 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_GPIO8

gpio_lite8 i_gpio_lite8(
   //inputs8
   .n_p_reset8(n_p_reset8),
   .pclk8(pclk8),
   .psel8(psel8),
   .penable8(penable8),
   .pwrite8(pwrite8),
   .paddr8(paddr8),
   .pwdata8(pwdata8),
   .gpio_pin_in8(gpio_pin_in8),
   .scan_en8(scan_en8),
   .tri_state_enable8(tri_state_enable8),
   .scan_in8(), //added by smarkov8 for dft8

   //outputs8
   .scan_out8(), //added by smarkov8 for dft8
   .prdata8(prdata8),
   .gpio_int8(gpio_int8),
   .n_gpio_pin_oe8(n_gpio_pin_oe8),
   .gpio_pin_out8(gpio_pin_out8)
);
 
`else 
//##############################################################################
// if the GPIO8 is black8 boxed8 
//##############################################################################

   // inputs8 
    
   // pclks8  
   wire         n_p_reset8;            // amba8 reset 
   wire         pclk8;               // peripherical8 pclk8 bus 

   // AMBA8 Rev8 2
   wire         psel8;               // peripheral8 select8 for gpio8 
   wire         penable8;            // peripheral8 enable 
   wire         pwrite8;             // peripheral8 write strobe8 
   wire  [5:0] 
                paddr8;              // address bus of selected master8 
   wire  [31:0] 
                pwdata8;             // write data 

   // gpio8 generic8 inputs8 
   wire  [15:0] 
                gpio_pin_in8;             // wire  data from pin8 

   //design for test inputs8 
   wire         scan_en8;            // enables8 shifting8 of scans8 
   wire  [15:0] 
                tri_state_enable8;   // disables8 op enable -> z 
   wire         scan_in8;            // scan8 chain8 data wire   
       
    
   // outputs8 
 
   //amba8 outputs8 
   reg    [31:0] 
                prdata8;             // read data 
   // gpio8 generic8 outputs8 
   reg          gpio_int8 =0;                // gpio_interupt8 for wire  pin8 change 
   reg    [15:0] 
                n_gpio_pin_oe8;           // reg    enable signal8 to pin8 
   reg    [15:0] 
                gpio_pin_out8;            // reg    signal8 to pin8 
                
   // scan8 outputs8
   reg         scan_out8;            // scan8 chain8 data output

`endif
//##############################################################################
// black8 boxed8 defines8 
//##############################################################################

endmodule
