//File28 name   : gpio_lite28.v
//Title28       : GPIO28 top level
//Created28     : 1999
//Description28 : A gpio28 module for use with amba28 
//                   apb28, with up to 16 io28 pins28 
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

module gpio_lite28( 
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
     
// gpio_internal28 signals28 declarations28
 
   // registers + wires28 for outputs28 
   reg  [31:0] 
                prdata28;             // registered output to apb28
   wire         gpio_int28;                // gpio_interrupt28 to apb28
   wire [15:0] 
                n_gpio_pin_oe28;           // gpio28 output enable
   wire [15:0] 
                gpio_pin_out28;            // gpio28 out
    
   // generic28 gpio28 stuff28 
   wire         write;              // apb28 register write strobe28
   wire         read;               // apb28 register read strobe28
   wire [5:0]
                addr;               // apb28 register address
   wire         n_p_reset28;            // apb28 reset
   wire         pclk28;               // apb28 clock28
   wire [15:0] 
                rdata28;              // registered output to apb28
   wire         sel28;                // apb28 peripheral28 select28
         
   //for gpio_interrupts28 
   wire [15:0] 
                gpio_interrupt_gen28;      // gpio_interrupt28 to apb28

   integer      i;                   // loop variable
                
 
    
   // assignments28 
 
   // generic28 assignments28 for the gpio28 bus 
   // variables28 starting with gpio28 are the 
   // generic28 variables28 used below28. 
   // change these28 variable to use another28 bus protocol28 
   // for the gpio28. 
 
   // inputs28  
   assign write      = pwrite28 & penable28 & psel28; 
    
   assign read       = ~(pwrite28) & ~(penable28) & psel28; 
    
   assign addr       = paddr28; 
  
   assign sel28        = psel28; 

   
   // p_map_prdata28: combinatorial28/ rdata28
   //
   // this process adds28 zeros28 to all the unused28 prdata28 lines28, 
   // according28 to the chosen28 width of the gpio28 module
   
   always @ ( rdata28 )
   begin : p_map_prdata28
      begin
         for ( i = 16; i < 32; i = i + 1 )
           prdata28[i] = 1'b0;
      end

      prdata28[15:0] = rdata28;

   end // p_map_prdata28

   assign gpio_int28 = |gpio_interrupt_gen28;

   gpio_lite_subunit28  // gpio_subunit28 module instance

   
   i_gpio_lite_subunit28 // instance name to take28 the annotated28 parameters28

// pin28 annotation28
   (
       //inputs28

       .n_reset28            (n_p_reset28),         // reset
       .pclk28               (pclk28),              // gpio28 pclk28
       .read               (read),              // select28 for gpio28
       .write              (write),             // gpio28 write
       .addr               (addr),              // address bus
       .wdata28              (pwdata28[15:0]),  
                                                 // gpio28 input
       .pin_in28             (gpio_pin_in28),        // input data from pin28
       .tri_state_enable28   (tri_state_enable28),   // disables28 op enable

       //outputs28
       .rdata28              (rdata28),              // gpio28 output
       .interrupt28          (gpio_interrupt_gen28), // gpio_interupt28
       .pin_oe_n28           (n_gpio_pin_oe28),      // output enable
       .pin_out28            (gpio_pin_out28)        // output signal28
    );

 endmodule
