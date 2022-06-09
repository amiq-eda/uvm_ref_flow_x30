//File20 name   : gpio_veneer20.v
//Title20       : 
//Created20     : 1999
//Description20 : 
//Notes20       : 
//----------------------------------------------------------------------
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------

module gpio_veneer20 ( 
              //inputs20 
 
              n_p_reset20, 
              pclk20, 

              psel20, 
              penable20, 
              pwrite20, 
              paddr20, 
              pwdata20, 

              gpio_pin_in20, 

              scan_en20, 
              tri_state_enable20, 

              scan_in20, //added by smarkov20 for dft20
 
              //outputs20
              
              scan_out20, //added by smarkov20 for dft20 
               
              prdata20, 

              gpio_int20, 

              n_gpio_pin_oe20, 
              gpio_pin_out20 
); 
 
//Numeric20 constants20


   // inputs20 
    
   // pclks20  
   input        n_p_reset20;            // amba20 reset 
   input        pclk20;               // peripherical20 pclk20 bus 

   // AMBA20 Rev20 2
   input        psel20;               // peripheral20 select20 for gpio20 
   input        penable20;            // peripheral20 enable 
   input        pwrite20;             // peripheral20 write strobe20 
   input [5:0] 
                paddr20;              // address bus of selected master20 
   input [31:0] 
                pwdata20;             // write data 

   // gpio20 generic20 inputs20 
   input [15:0] 
                gpio_pin_in20;             // input data from pin20 

   //design for test inputs20 
   input        scan_en20;            // enables20 shifting20 of scans20 
   input [15:0] 
                tri_state_enable20;   // disables20 op enable -> z 
   input        scan_in20;            // scan20 chain20 data input  
       
    
   // outputs20 
 
   //amba20 outputs20 
   output [31:0] 
                prdata20;             // read data 
   // gpio20 generic20 outputs20 
   output       gpio_int20;                // gpio_interupt20 for input pin20 change 
   output [15:0] 
                n_gpio_pin_oe20;           // output enable signal20 to pin20 
   output [15:0] 
                gpio_pin_out20;            // output signal20 to pin20 
                
   // scan20 outputs20
   output      scan_out20;            // scan20 chain20 data output

//##############################################################################
// if the GPIO20 is NOT20 black20 boxed20 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_GPIO20

gpio_lite20 i_gpio_lite20(
   //inputs20
   .n_p_reset20(n_p_reset20),
   .pclk20(pclk20),
   .psel20(psel20),
   .penable20(penable20),
   .pwrite20(pwrite20),
   .paddr20(paddr20),
   .pwdata20(pwdata20),
   .gpio_pin_in20(gpio_pin_in20),
   .scan_en20(scan_en20),
   .tri_state_enable20(tri_state_enable20),
   .scan_in20(), //added by smarkov20 for dft20

   //outputs20
   .scan_out20(), //added by smarkov20 for dft20
   .prdata20(prdata20),
   .gpio_int20(gpio_int20),
   .n_gpio_pin_oe20(n_gpio_pin_oe20),
   .gpio_pin_out20(gpio_pin_out20)
);
 
`else 
//##############################################################################
// if the GPIO20 is black20 boxed20 
//##############################################################################

   // inputs20 
    
   // pclks20  
   wire         n_p_reset20;            // amba20 reset 
   wire         pclk20;               // peripherical20 pclk20 bus 

   // AMBA20 Rev20 2
   wire         psel20;               // peripheral20 select20 for gpio20 
   wire         penable20;            // peripheral20 enable 
   wire         pwrite20;             // peripheral20 write strobe20 
   wire  [5:0] 
                paddr20;              // address bus of selected master20 
   wire  [31:0] 
                pwdata20;             // write data 

   // gpio20 generic20 inputs20 
   wire  [15:0] 
                gpio_pin_in20;             // wire  data from pin20 

   //design for test inputs20 
   wire         scan_en20;            // enables20 shifting20 of scans20 
   wire  [15:0] 
                tri_state_enable20;   // disables20 op enable -> z 
   wire         scan_in20;            // scan20 chain20 data wire   
       
    
   // outputs20 
 
   //amba20 outputs20 
   reg    [31:0] 
                prdata20;             // read data 
   // gpio20 generic20 outputs20 
   reg          gpio_int20 =0;                // gpio_interupt20 for wire  pin20 change 
   reg    [15:0] 
                n_gpio_pin_oe20;           // reg    enable signal20 to pin20 
   reg    [15:0] 
                gpio_pin_out20;            // reg    signal20 to pin20 
                
   // scan20 outputs20
   reg         scan_out20;            // scan20 chain20 data output

`endif
//##############################################################################
// black20 boxed20 defines20 
//##############################################################################

endmodule
