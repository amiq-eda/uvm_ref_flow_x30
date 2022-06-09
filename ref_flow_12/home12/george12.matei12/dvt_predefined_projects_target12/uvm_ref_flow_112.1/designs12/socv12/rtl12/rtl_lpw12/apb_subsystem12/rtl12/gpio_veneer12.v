//File12 name   : gpio_veneer12.v
//Title12       : 
//Created12     : 1999
//Description12 : 
//Notes12       : 
//----------------------------------------------------------------------
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------

module gpio_veneer12 ( 
              //inputs12 
 
              n_p_reset12, 
              pclk12, 

              psel12, 
              penable12, 
              pwrite12, 
              paddr12, 
              pwdata12, 

              gpio_pin_in12, 

              scan_en12, 
              tri_state_enable12, 

              scan_in12, //added by smarkov12 for dft12
 
              //outputs12
              
              scan_out12, //added by smarkov12 for dft12 
               
              prdata12, 

              gpio_int12, 

              n_gpio_pin_oe12, 
              gpio_pin_out12 
); 
 
//Numeric12 constants12


   // inputs12 
    
   // pclks12  
   input        n_p_reset12;            // amba12 reset 
   input        pclk12;               // peripherical12 pclk12 bus 

   // AMBA12 Rev12 2
   input        psel12;               // peripheral12 select12 for gpio12 
   input        penable12;            // peripheral12 enable 
   input        pwrite12;             // peripheral12 write strobe12 
   input [5:0] 
                paddr12;              // address bus of selected master12 
   input [31:0] 
                pwdata12;             // write data 

   // gpio12 generic12 inputs12 
   input [15:0] 
                gpio_pin_in12;             // input data from pin12 

   //design for test inputs12 
   input        scan_en12;            // enables12 shifting12 of scans12 
   input [15:0] 
                tri_state_enable12;   // disables12 op enable -> z 
   input        scan_in12;            // scan12 chain12 data input  
       
    
   // outputs12 
 
   //amba12 outputs12 
   output [31:0] 
                prdata12;             // read data 
   // gpio12 generic12 outputs12 
   output       gpio_int12;                // gpio_interupt12 for input pin12 change 
   output [15:0] 
                n_gpio_pin_oe12;           // output enable signal12 to pin12 
   output [15:0] 
                gpio_pin_out12;            // output signal12 to pin12 
                
   // scan12 outputs12
   output      scan_out12;            // scan12 chain12 data output

//##############################################################################
// if the GPIO12 is NOT12 black12 boxed12 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_GPIO12

gpio_lite12 i_gpio_lite12(
   //inputs12
   .n_p_reset12(n_p_reset12),
   .pclk12(pclk12),
   .psel12(psel12),
   .penable12(penable12),
   .pwrite12(pwrite12),
   .paddr12(paddr12),
   .pwdata12(pwdata12),
   .gpio_pin_in12(gpio_pin_in12),
   .scan_en12(scan_en12),
   .tri_state_enable12(tri_state_enable12),
   .scan_in12(), //added by smarkov12 for dft12

   //outputs12
   .scan_out12(), //added by smarkov12 for dft12
   .prdata12(prdata12),
   .gpio_int12(gpio_int12),
   .n_gpio_pin_oe12(n_gpio_pin_oe12),
   .gpio_pin_out12(gpio_pin_out12)
);
 
`else 
//##############################################################################
// if the GPIO12 is black12 boxed12 
//##############################################################################

   // inputs12 
    
   // pclks12  
   wire         n_p_reset12;            // amba12 reset 
   wire         pclk12;               // peripherical12 pclk12 bus 

   // AMBA12 Rev12 2
   wire         psel12;               // peripheral12 select12 for gpio12 
   wire         penable12;            // peripheral12 enable 
   wire         pwrite12;             // peripheral12 write strobe12 
   wire  [5:0] 
                paddr12;              // address bus of selected master12 
   wire  [31:0] 
                pwdata12;             // write data 

   // gpio12 generic12 inputs12 
   wire  [15:0] 
                gpio_pin_in12;             // wire  data from pin12 

   //design for test inputs12 
   wire         scan_en12;            // enables12 shifting12 of scans12 
   wire  [15:0] 
                tri_state_enable12;   // disables12 op enable -> z 
   wire         scan_in12;            // scan12 chain12 data wire   
       
    
   // outputs12 
 
   //amba12 outputs12 
   reg    [31:0] 
                prdata12;             // read data 
   // gpio12 generic12 outputs12 
   reg          gpio_int12 =0;                // gpio_interupt12 for wire  pin12 change 
   reg    [15:0] 
                n_gpio_pin_oe12;           // reg    enable signal12 to pin12 
   reg    [15:0] 
                gpio_pin_out12;            // reg    signal12 to pin12 
                
   // scan12 outputs12
   reg         scan_out12;            // scan12 chain12 data output

`endif
//##############################################################################
// black12 boxed12 defines12 
//##############################################################################

endmodule
