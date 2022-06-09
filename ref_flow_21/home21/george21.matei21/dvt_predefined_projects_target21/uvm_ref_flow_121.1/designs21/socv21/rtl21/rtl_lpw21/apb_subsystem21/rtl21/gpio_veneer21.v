//File21 name   : gpio_veneer21.v
//Title21       : 
//Created21     : 1999
//Description21 : 
//Notes21       : 
//----------------------------------------------------------------------
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------

module gpio_veneer21 ( 
              //inputs21 
 
              n_p_reset21, 
              pclk21, 

              psel21, 
              penable21, 
              pwrite21, 
              paddr21, 
              pwdata21, 

              gpio_pin_in21, 

              scan_en21, 
              tri_state_enable21, 

              scan_in21, //added by smarkov21 for dft21
 
              //outputs21
              
              scan_out21, //added by smarkov21 for dft21 
               
              prdata21, 

              gpio_int21, 

              n_gpio_pin_oe21, 
              gpio_pin_out21 
); 
 
//Numeric21 constants21


   // inputs21 
    
   // pclks21  
   input        n_p_reset21;            // amba21 reset 
   input        pclk21;               // peripherical21 pclk21 bus 

   // AMBA21 Rev21 2
   input        psel21;               // peripheral21 select21 for gpio21 
   input        penable21;            // peripheral21 enable 
   input        pwrite21;             // peripheral21 write strobe21 
   input [5:0] 
                paddr21;              // address bus of selected master21 
   input [31:0] 
                pwdata21;             // write data 

   // gpio21 generic21 inputs21 
   input [15:0] 
                gpio_pin_in21;             // input data from pin21 

   //design for test inputs21 
   input        scan_en21;            // enables21 shifting21 of scans21 
   input [15:0] 
                tri_state_enable21;   // disables21 op enable -> z 
   input        scan_in21;            // scan21 chain21 data input  
       
    
   // outputs21 
 
   //amba21 outputs21 
   output [31:0] 
                prdata21;             // read data 
   // gpio21 generic21 outputs21 
   output       gpio_int21;                // gpio_interupt21 for input pin21 change 
   output [15:0] 
                n_gpio_pin_oe21;           // output enable signal21 to pin21 
   output [15:0] 
                gpio_pin_out21;            // output signal21 to pin21 
                
   // scan21 outputs21
   output      scan_out21;            // scan21 chain21 data output

//##############################################################################
// if the GPIO21 is NOT21 black21 boxed21 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_GPIO21

gpio_lite21 i_gpio_lite21(
   //inputs21
   .n_p_reset21(n_p_reset21),
   .pclk21(pclk21),
   .psel21(psel21),
   .penable21(penable21),
   .pwrite21(pwrite21),
   .paddr21(paddr21),
   .pwdata21(pwdata21),
   .gpio_pin_in21(gpio_pin_in21),
   .scan_en21(scan_en21),
   .tri_state_enable21(tri_state_enable21),
   .scan_in21(), //added by smarkov21 for dft21

   //outputs21
   .scan_out21(), //added by smarkov21 for dft21
   .prdata21(prdata21),
   .gpio_int21(gpio_int21),
   .n_gpio_pin_oe21(n_gpio_pin_oe21),
   .gpio_pin_out21(gpio_pin_out21)
);
 
`else 
//##############################################################################
// if the GPIO21 is black21 boxed21 
//##############################################################################

   // inputs21 
    
   // pclks21  
   wire         n_p_reset21;            // amba21 reset 
   wire         pclk21;               // peripherical21 pclk21 bus 

   // AMBA21 Rev21 2
   wire         psel21;               // peripheral21 select21 for gpio21 
   wire         penable21;            // peripheral21 enable 
   wire         pwrite21;             // peripheral21 write strobe21 
   wire  [5:0] 
                paddr21;              // address bus of selected master21 
   wire  [31:0] 
                pwdata21;             // write data 

   // gpio21 generic21 inputs21 
   wire  [15:0] 
                gpio_pin_in21;             // wire  data from pin21 

   //design for test inputs21 
   wire         scan_en21;            // enables21 shifting21 of scans21 
   wire  [15:0] 
                tri_state_enable21;   // disables21 op enable -> z 
   wire         scan_in21;            // scan21 chain21 data wire   
       
    
   // outputs21 
 
   //amba21 outputs21 
   reg    [31:0] 
                prdata21;             // read data 
   // gpio21 generic21 outputs21 
   reg          gpio_int21 =0;                // gpio_interupt21 for wire  pin21 change 
   reg    [15:0] 
                n_gpio_pin_oe21;           // reg    enable signal21 to pin21 
   reg    [15:0] 
                gpio_pin_out21;            // reg    signal21 to pin21 
                
   // scan21 outputs21
   reg         scan_out21;            // scan21 chain21 data output

`endif
//##############################################################################
// black21 boxed21 defines21 
//##############################################################################

endmodule
