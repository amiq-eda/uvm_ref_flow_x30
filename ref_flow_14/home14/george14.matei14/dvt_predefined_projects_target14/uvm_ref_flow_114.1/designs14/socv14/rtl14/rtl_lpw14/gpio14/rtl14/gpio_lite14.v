//File14 name   : gpio_lite14.v
//Title14       : GPIO14 top level
//Created14     : 1999
//Description14 : A gpio14 module for use with amba14 
//                   apb14, with up to 16 io14 pins14 
//Notes14       : 
//----------------------------------------------------------------------
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------

module gpio_lite14( 
              //inputs14 
 
              n_p_reset14, 
              pclk14, 

              psel14, 
              penable14, 
              pwrite14, 
              paddr14, 
              pwdata14, 

              gpio_pin_in14, 

              scan_en14, 
              tri_state_enable14, 

              scan_in14, //added by smarkov14 for dft14
 
              //outputs14
              
              scan_out14, //added by smarkov14 for dft14 
               
              prdata14, 

              gpio_int14, 

              n_gpio_pin_oe14, 
              gpio_pin_out14 
); 
 


   // inputs14 
    
   // pclks14  
   input        n_p_reset14;            // amba14 reset 
   input        pclk14;               // peripherical14 pclk14 bus 

   // AMBA14 Rev14 2
   input        psel14;               // peripheral14 select14 for gpio14 
   input        penable14;            // peripheral14 enable 
   input        pwrite14;             // peripheral14 write strobe14 
   input [5:0] 
                paddr14;              // address bus of selected master14 
   input [31:0] 
                pwdata14;             // write data 

   // gpio14 generic14 inputs14 
   input [15:0] 
                gpio_pin_in14;             // input data from pin14 

   //design for test inputs14 
   input        scan_en14;            // enables14 shifting14 of scans14 
   input [15:0] 
                tri_state_enable14;   // disables14 op enable -> z 
   input        scan_in14;            // scan14 chain14 data input  
       
    
   // outputs14 
 
   //amba14 outputs14 
   output [31:0] 
                prdata14;             // read data 
   // gpio14 generic14 outputs14 
   output       gpio_int14;                // gpio_interupt14 for input pin14 change 
   output [15:0] 
                n_gpio_pin_oe14;           // output enable signal14 to pin14 
   output [15:0] 
                gpio_pin_out14;            // output signal14 to pin14 
                
   // scan14 outputs14
   output      scan_out14;            // scan14 chain14 data output
     
// gpio_internal14 signals14 declarations14
 
   // registers + wires14 for outputs14 
   reg  [31:0] 
                prdata14;             // registered output to apb14
   wire         gpio_int14;                // gpio_interrupt14 to apb14
   wire [15:0] 
                n_gpio_pin_oe14;           // gpio14 output enable
   wire [15:0] 
                gpio_pin_out14;            // gpio14 out
    
   // generic14 gpio14 stuff14 
   wire         write;              // apb14 register write strobe14
   wire         read;               // apb14 register read strobe14
   wire [5:0]
                addr;               // apb14 register address
   wire         n_p_reset14;            // apb14 reset
   wire         pclk14;               // apb14 clock14
   wire [15:0] 
                rdata14;              // registered output to apb14
   wire         sel14;                // apb14 peripheral14 select14
         
   //for gpio_interrupts14 
   wire [15:0] 
                gpio_interrupt_gen14;      // gpio_interrupt14 to apb14

   integer      i;                   // loop variable
                
 
    
   // assignments14 
 
   // generic14 assignments14 for the gpio14 bus 
   // variables14 starting with gpio14 are the 
   // generic14 variables14 used below14. 
   // change these14 variable to use another14 bus protocol14 
   // for the gpio14. 
 
   // inputs14  
   assign write      = pwrite14 & penable14 & psel14; 
    
   assign read       = ~(pwrite14) & ~(penable14) & psel14; 
    
   assign addr       = paddr14; 
  
   assign sel14        = psel14; 

   
   // p_map_prdata14: combinatorial14/ rdata14
   //
   // this process adds14 zeros14 to all the unused14 prdata14 lines14, 
   // according14 to the chosen14 width of the gpio14 module
   
   always @ ( rdata14 )
   begin : p_map_prdata14
      begin
         for ( i = 16; i < 32; i = i + 1 )
           prdata14[i] = 1'b0;
      end

      prdata14[15:0] = rdata14;

   end // p_map_prdata14

   assign gpio_int14 = |gpio_interrupt_gen14;

   gpio_lite_subunit14  // gpio_subunit14 module instance

   
   i_gpio_lite_subunit14 // instance name to take14 the annotated14 parameters14

// pin14 annotation14
   (
       //inputs14

       .n_reset14            (n_p_reset14),         // reset
       .pclk14               (pclk14),              // gpio14 pclk14
       .read               (read),              // select14 for gpio14
       .write              (write),             // gpio14 write
       .addr               (addr),              // address bus
       .wdata14              (pwdata14[15:0]),  
                                                 // gpio14 input
       .pin_in14             (gpio_pin_in14),        // input data from pin14
       .tri_state_enable14   (tri_state_enable14),   // disables14 op enable

       //outputs14
       .rdata14              (rdata14),              // gpio14 output
       .interrupt14          (gpio_interrupt_gen14), // gpio_interupt14
       .pin_oe_n14           (n_gpio_pin_oe14),      // output enable
       .pin_out14            (gpio_pin_out14)        // output signal14
    );

 endmodule
