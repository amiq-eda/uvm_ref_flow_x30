//File17 name   : gpio_veneer17.v
//Title17       : 
//Created17     : 1999
//Description17 : 
//Notes17       : 
//----------------------------------------------------------------------
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------

module gpio_veneer17 ( 
              //inputs17 
 
              n_p_reset17, 
              pclk17, 

              psel17, 
              penable17, 
              pwrite17, 
              paddr17, 
              pwdata17, 

              gpio_pin_in17, 

              scan_en17, 
              tri_state_enable17, 

              scan_in17, //added by smarkov17 for dft17
 
              //outputs17
              
              scan_out17, //added by smarkov17 for dft17 
               
              prdata17, 

              gpio_int17, 

              n_gpio_pin_oe17, 
              gpio_pin_out17 
); 
 
//Numeric17 constants17


   // inputs17 
    
   // pclks17  
   input        n_p_reset17;            // amba17 reset 
   input        pclk17;               // peripherical17 pclk17 bus 

   // AMBA17 Rev17 2
   input        psel17;               // peripheral17 select17 for gpio17 
   input        penable17;            // peripheral17 enable 
   input        pwrite17;             // peripheral17 write strobe17 
   input [5:0] 
                paddr17;              // address bus of selected master17 
   input [31:0] 
                pwdata17;             // write data 

   // gpio17 generic17 inputs17 
   input [15:0] 
                gpio_pin_in17;             // input data from pin17 

   //design for test inputs17 
   input        scan_en17;            // enables17 shifting17 of scans17 
   input [15:0] 
                tri_state_enable17;   // disables17 op enable -> z 
   input        scan_in17;            // scan17 chain17 data input  
       
    
   // outputs17 
 
   //amba17 outputs17 
   output [31:0] 
                prdata17;             // read data 
   // gpio17 generic17 outputs17 
   output       gpio_int17;                // gpio_interupt17 for input pin17 change 
   output [15:0] 
                n_gpio_pin_oe17;           // output enable signal17 to pin17 
   output [15:0] 
                gpio_pin_out17;            // output signal17 to pin17 
                
   // scan17 outputs17
   output      scan_out17;            // scan17 chain17 data output

//##############################################################################
// if the GPIO17 is NOT17 black17 boxed17 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_GPIO17

gpio_lite17 i_gpio_lite17(
   //inputs17
   .n_p_reset17(n_p_reset17),
   .pclk17(pclk17),
   .psel17(psel17),
   .penable17(penable17),
   .pwrite17(pwrite17),
   .paddr17(paddr17),
   .pwdata17(pwdata17),
   .gpio_pin_in17(gpio_pin_in17),
   .scan_en17(scan_en17),
   .tri_state_enable17(tri_state_enable17),
   .scan_in17(), //added by smarkov17 for dft17

   //outputs17
   .scan_out17(), //added by smarkov17 for dft17
   .prdata17(prdata17),
   .gpio_int17(gpio_int17),
   .n_gpio_pin_oe17(n_gpio_pin_oe17),
   .gpio_pin_out17(gpio_pin_out17)
);
 
`else 
//##############################################################################
// if the GPIO17 is black17 boxed17 
//##############################################################################

   // inputs17 
    
   // pclks17  
   wire         n_p_reset17;            // amba17 reset 
   wire         pclk17;               // peripherical17 pclk17 bus 

   // AMBA17 Rev17 2
   wire         psel17;               // peripheral17 select17 for gpio17 
   wire         penable17;            // peripheral17 enable 
   wire         pwrite17;             // peripheral17 write strobe17 
   wire  [5:0] 
                paddr17;              // address bus of selected master17 
   wire  [31:0] 
                pwdata17;             // write data 

   // gpio17 generic17 inputs17 
   wire  [15:0] 
                gpio_pin_in17;             // wire  data from pin17 

   //design for test inputs17 
   wire         scan_en17;            // enables17 shifting17 of scans17 
   wire  [15:0] 
                tri_state_enable17;   // disables17 op enable -> z 
   wire         scan_in17;            // scan17 chain17 data wire   
       
    
   // outputs17 
 
   //amba17 outputs17 
   reg    [31:0] 
                prdata17;             // read data 
   // gpio17 generic17 outputs17 
   reg          gpio_int17 =0;                // gpio_interupt17 for wire  pin17 change 
   reg    [15:0] 
                n_gpio_pin_oe17;           // reg    enable signal17 to pin17 
   reg    [15:0] 
                gpio_pin_out17;            // reg    signal17 to pin17 
                
   // scan17 outputs17
   reg         scan_out17;            // scan17 chain17 data output

`endif
//##############################################################################
// black17 boxed17 defines17 
//##############################################################################

endmodule
