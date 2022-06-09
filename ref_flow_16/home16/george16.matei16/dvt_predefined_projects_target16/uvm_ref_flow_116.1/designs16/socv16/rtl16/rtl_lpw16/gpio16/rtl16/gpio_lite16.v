//File16 name   : gpio_lite16.v
//Title16       : GPIO16 top level
//Created16     : 1999
//Description16 : A gpio16 module for use with amba16 
//                   apb16, with up to 16 io16 pins16 
//Notes16       : 
//----------------------------------------------------------------------
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------

module gpio_lite16( 
              //inputs16 
 
              n_p_reset16, 
              pclk16, 

              psel16, 
              penable16, 
              pwrite16, 
              paddr16, 
              pwdata16, 

              gpio_pin_in16, 

              scan_en16, 
              tri_state_enable16, 

              scan_in16, //added by smarkov16 for dft16
 
              //outputs16
              
              scan_out16, //added by smarkov16 for dft16 
               
              prdata16, 

              gpio_int16, 

              n_gpio_pin_oe16, 
              gpio_pin_out16 
); 
 


   // inputs16 
    
   // pclks16  
   input        n_p_reset16;            // amba16 reset 
   input        pclk16;               // peripherical16 pclk16 bus 

   // AMBA16 Rev16 2
   input        psel16;               // peripheral16 select16 for gpio16 
   input        penable16;            // peripheral16 enable 
   input        pwrite16;             // peripheral16 write strobe16 
   input [5:0] 
                paddr16;              // address bus of selected master16 
   input [31:0] 
                pwdata16;             // write data 

   // gpio16 generic16 inputs16 
   input [15:0] 
                gpio_pin_in16;             // input data from pin16 

   //design for test inputs16 
   input        scan_en16;            // enables16 shifting16 of scans16 
   input [15:0] 
                tri_state_enable16;   // disables16 op enable -> z 
   input        scan_in16;            // scan16 chain16 data input  
       
    
   // outputs16 
 
   //amba16 outputs16 
   output [31:0] 
                prdata16;             // read data 
   // gpio16 generic16 outputs16 
   output       gpio_int16;                // gpio_interupt16 for input pin16 change 
   output [15:0] 
                n_gpio_pin_oe16;           // output enable signal16 to pin16 
   output [15:0] 
                gpio_pin_out16;            // output signal16 to pin16 
                
   // scan16 outputs16
   output      scan_out16;            // scan16 chain16 data output
     
// gpio_internal16 signals16 declarations16
 
   // registers + wires16 for outputs16 
   reg  [31:0] 
                prdata16;             // registered output to apb16
   wire         gpio_int16;                // gpio_interrupt16 to apb16
   wire [15:0] 
                n_gpio_pin_oe16;           // gpio16 output enable
   wire [15:0] 
                gpio_pin_out16;            // gpio16 out
    
   // generic16 gpio16 stuff16 
   wire         write;              // apb16 register write strobe16
   wire         read;               // apb16 register read strobe16
   wire [5:0]
                addr;               // apb16 register address
   wire         n_p_reset16;            // apb16 reset
   wire         pclk16;               // apb16 clock16
   wire [15:0] 
                rdata16;              // registered output to apb16
   wire         sel16;                // apb16 peripheral16 select16
         
   //for gpio_interrupts16 
   wire [15:0] 
                gpio_interrupt_gen16;      // gpio_interrupt16 to apb16

   integer      i;                   // loop variable
                
 
    
   // assignments16 
 
   // generic16 assignments16 for the gpio16 bus 
   // variables16 starting with gpio16 are the 
   // generic16 variables16 used below16. 
   // change these16 variable to use another16 bus protocol16 
   // for the gpio16. 
 
   // inputs16  
   assign write      = pwrite16 & penable16 & psel16; 
    
   assign read       = ~(pwrite16) & ~(penable16) & psel16; 
    
   assign addr       = paddr16; 
  
   assign sel16        = psel16; 

   
   // p_map_prdata16: combinatorial16/ rdata16
   //
   // this process adds16 zeros16 to all the unused16 prdata16 lines16, 
   // according16 to the chosen16 width of the gpio16 module
   
   always @ ( rdata16 )
   begin : p_map_prdata16
      begin
         for ( i = 16; i < 32; i = i + 1 )
           prdata16[i] = 1'b0;
      end

      prdata16[15:0] = rdata16;

   end // p_map_prdata16

   assign gpio_int16 = |gpio_interrupt_gen16;

   gpio_lite_subunit16  // gpio_subunit16 module instance

   
   i_gpio_lite_subunit16 // instance name to take16 the annotated16 parameters16

// pin16 annotation16
   (
       //inputs16

       .n_reset16            (n_p_reset16),         // reset
       .pclk16               (pclk16),              // gpio16 pclk16
       .read               (read),              // select16 for gpio16
       .write              (write),             // gpio16 write
       .addr               (addr),              // address bus
       .wdata16              (pwdata16[15:0]),  
                                                 // gpio16 input
       .pin_in16             (gpio_pin_in16),        // input data from pin16
       .tri_state_enable16   (tri_state_enable16),   // disables16 op enable

       //outputs16
       .rdata16              (rdata16),              // gpio16 output
       .interrupt16          (gpio_interrupt_gen16), // gpio_interupt16
       .pin_oe_n16           (n_gpio_pin_oe16),      // output enable
       .pin_out16            (gpio_pin_out16)        // output signal16
    );

 endmodule
