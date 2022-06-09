//File25 name   : gpio_veneer25.v
//Title25       : 
//Created25     : 1999
//Description25 : 
//Notes25       : 
//----------------------------------------------------------------------
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------

module gpio_veneer25 ( 
              //inputs25 
 
              n_p_reset25, 
              pclk25, 

              psel25, 
              penable25, 
              pwrite25, 
              paddr25, 
              pwdata25, 

              gpio_pin_in25, 

              scan_en25, 
              tri_state_enable25, 

              scan_in25, //added by smarkov25 for dft25
 
              //outputs25
              
              scan_out25, //added by smarkov25 for dft25 
               
              prdata25, 

              gpio_int25, 

              n_gpio_pin_oe25, 
              gpio_pin_out25 
); 
 
//Numeric25 constants25


   // inputs25 
    
   // pclks25  
   input        n_p_reset25;            // amba25 reset 
   input        pclk25;               // peripherical25 pclk25 bus 

   // AMBA25 Rev25 2
   input        psel25;               // peripheral25 select25 for gpio25 
   input        penable25;            // peripheral25 enable 
   input        pwrite25;             // peripheral25 write strobe25 
   input [5:0] 
                paddr25;              // address bus of selected master25 
   input [31:0] 
                pwdata25;             // write data 

   // gpio25 generic25 inputs25 
   input [15:0] 
                gpio_pin_in25;             // input data from pin25 

   //design for test inputs25 
   input        scan_en25;            // enables25 shifting25 of scans25 
   input [15:0] 
                tri_state_enable25;   // disables25 op enable -> z 
   input        scan_in25;            // scan25 chain25 data input  
       
    
   // outputs25 
 
   //amba25 outputs25 
   output [31:0] 
                prdata25;             // read data 
   // gpio25 generic25 outputs25 
   output       gpio_int25;                // gpio_interupt25 for input pin25 change 
   output [15:0] 
                n_gpio_pin_oe25;           // output enable signal25 to pin25 
   output [15:0] 
                gpio_pin_out25;            // output signal25 to pin25 
                
   // scan25 outputs25
   output      scan_out25;            // scan25 chain25 data output

//##############################################################################
// if the GPIO25 is NOT25 black25 boxed25 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_GPIO25

gpio_lite25 i_gpio_lite25(
   //inputs25
   .n_p_reset25(n_p_reset25),
   .pclk25(pclk25),
   .psel25(psel25),
   .penable25(penable25),
   .pwrite25(pwrite25),
   .paddr25(paddr25),
   .pwdata25(pwdata25),
   .gpio_pin_in25(gpio_pin_in25),
   .scan_en25(scan_en25),
   .tri_state_enable25(tri_state_enable25),
   .scan_in25(), //added by smarkov25 for dft25

   //outputs25
   .scan_out25(), //added by smarkov25 for dft25
   .prdata25(prdata25),
   .gpio_int25(gpio_int25),
   .n_gpio_pin_oe25(n_gpio_pin_oe25),
   .gpio_pin_out25(gpio_pin_out25)
);
 
`else 
//##############################################################################
// if the GPIO25 is black25 boxed25 
//##############################################################################

   // inputs25 
    
   // pclks25  
   wire         n_p_reset25;            // amba25 reset 
   wire         pclk25;               // peripherical25 pclk25 bus 

   // AMBA25 Rev25 2
   wire         psel25;               // peripheral25 select25 for gpio25 
   wire         penable25;            // peripheral25 enable 
   wire         pwrite25;             // peripheral25 write strobe25 
   wire  [5:0] 
                paddr25;              // address bus of selected master25 
   wire  [31:0] 
                pwdata25;             // write data 

   // gpio25 generic25 inputs25 
   wire  [15:0] 
                gpio_pin_in25;             // wire  data from pin25 

   //design for test inputs25 
   wire         scan_en25;            // enables25 shifting25 of scans25 
   wire  [15:0] 
                tri_state_enable25;   // disables25 op enable -> z 
   wire         scan_in25;            // scan25 chain25 data wire   
       
    
   // outputs25 
 
   //amba25 outputs25 
   reg    [31:0] 
                prdata25;             // read data 
   // gpio25 generic25 outputs25 
   reg          gpio_int25 =0;                // gpio_interupt25 for wire  pin25 change 
   reg    [15:0] 
                n_gpio_pin_oe25;           // reg    enable signal25 to pin25 
   reg    [15:0] 
                gpio_pin_out25;            // reg    signal25 to pin25 
                
   // scan25 outputs25
   reg         scan_out25;            // scan25 chain25 data output

`endif
//##############################################################################
// black25 boxed25 defines25 
//##############################################################################

endmodule
