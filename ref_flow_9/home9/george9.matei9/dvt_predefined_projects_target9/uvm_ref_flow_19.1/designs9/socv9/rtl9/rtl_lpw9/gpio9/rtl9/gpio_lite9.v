//File9 name   : gpio_lite9.v
//Title9       : GPIO9 top level
//Created9     : 1999
//Description9 : A gpio9 module for use with amba9 
//                   apb9, with up to 16 io9 pins9 
//Notes9       : 
//----------------------------------------------------------------------
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------

module gpio_lite9( 
              //inputs9 
 
              n_p_reset9, 
              pclk9, 

              psel9, 
              penable9, 
              pwrite9, 
              paddr9, 
              pwdata9, 

              gpio_pin_in9, 

              scan_en9, 
              tri_state_enable9, 

              scan_in9, //added by smarkov9 for dft9
 
              //outputs9
              
              scan_out9, //added by smarkov9 for dft9 
               
              prdata9, 

              gpio_int9, 

              n_gpio_pin_oe9, 
              gpio_pin_out9 
); 
 


   // inputs9 
    
   // pclks9  
   input        n_p_reset9;            // amba9 reset 
   input        pclk9;               // peripherical9 pclk9 bus 

   // AMBA9 Rev9 2
   input        psel9;               // peripheral9 select9 for gpio9 
   input        penable9;            // peripheral9 enable 
   input        pwrite9;             // peripheral9 write strobe9 
   input [5:0] 
                paddr9;              // address bus of selected master9 
   input [31:0] 
                pwdata9;             // write data 

   // gpio9 generic9 inputs9 
   input [15:0] 
                gpio_pin_in9;             // input data from pin9 

   //design for test inputs9 
   input        scan_en9;            // enables9 shifting9 of scans9 
   input [15:0] 
                tri_state_enable9;   // disables9 op enable -> z 
   input        scan_in9;            // scan9 chain9 data input  
       
    
   // outputs9 
 
   //amba9 outputs9 
   output [31:0] 
                prdata9;             // read data 
   // gpio9 generic9 outputs9 
   output       gpio_int9;                // gpio_interupt9 for input pin9 change 
   output [15:0] 
                n_gpio_pin_oe9;           // output enable signal9 to pin9 
   output [15:0] 
                gpio_pin_out9;            // output signal9 to pin9 
                
   // scan9 outputs9
   output      scan_out9;            // scan9 chain9 data output
     
// gpio_internal9 signals9 declarations9
 
   // registers + wires9 for outputs9 
   reg  [31:0] 
                prdata9;             // registered output to apb9
   wire         gpio_int9;                // gpio_interrupt9 to apb9
   wire [15:0] 
                n_gpio_pin_oe9;           // gpio9 output enable
   wire [15:0] 
                gpio_pin_out9;            // gpio9 out
    
   // generic9 gpio9 stuff9 
   wire         write;              // apb9 register write strobe9
   wire         read;               // apb9 register read strobe9
   wire [5:0]
                addr;               // apb9 register address
   wire         n_p_reset9;            // apb9 reset
   wire         pclk9;               // apb9 clock9
   wire [15:0] 
                rdata9;              // registered output to apb9
   wire         sel9;                // apb9 peripheral9 select9
         
   //for gpio_interrupts9 
   wire [15:0] 
                gpio_interrupt_gen9;      // gpio_interrupt9 to apb9

   integer      i;                   // loop variable
                
 
    
   // assignments9 
 
   // generic9 assignments9 for the gpio9 bus 
   // variables9 starting with gpio9 are the 
   // generic9 variables9 used below9. 
   // change these9 variable to use another9 bus protocol9 
   // for the gpio9. 
 
   // inputs9  
   assign write      = pwrite9 & penable9 & psel9; 
    
   assign read       = ~(pwrite9) & ~(penable9) & psel9; 
    
   assign addr       = paddr9; 
  
   assign sel9        = psel9; 

   
   // p_map_prdata9: combinatorial9/ rdata9
   //
   // this process adds9 zeros9 to all the unused9 prdata9 lines9, 
   // according9 to the chosen9 width of the gpio9 module
   
   always @ ( rdata9 )
   begin : p_map_prdata9
      begin
         for ( i = 16; i < 32; i = i + 1 )
           prdata9[i] = 1'b0;
      end

      prdata9[15:0] = rdata9;

   end // p_map_prdata9

   assign gpio_int9 = |gpio_interrupt_gen9;

   gpio_lite_subunit9  // gpio_subunit9 module instance

   
   i_gpio_lite_subunit9 // instance name to take9 the annotated9 parameters9

// pin9 annotation9
   (
       //inputs9

       .n_reset9            (n_p_reset9),         // reset
       .pclk9               (pclk9),              // gpio9 pclk9
       .read               (read),              // select9 for gpio9
       .write              (write),             // gpio9 write
       .addr               (addr),              // address bus
       .wdata9              (pwdata9[15:0]),  
                                                 // gpio9 input
       .pin_in9             (gpio_pin_in9),        // input data from pin9
       .tri_state_enable9   (tri_state_enable9),   // disables9 op enable

       //outputs9
       .rdata9              (rdata9),              // gpio9 output
       .interrupt9          (gpio_interrupt_gen9), // gpio_interupt9
       .pin_oe_n9           (n_gpio_pin_oe9),      // output enable
       .pin_out9            (gpio_pin_out9)        // output signal9
    );

 endmodule
