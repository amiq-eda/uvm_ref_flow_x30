//File10 name   : gpio_lite10.v
//Title10       : GPIO10 top level
//Created10     : 1999
//Description10 : A gpio10 module for use with amba10 
//                   apb10, with up to 16 io10 pins10 
//Notes10       : 
//----------------------------------------------------------------------
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------

module gpio_lite10( 
              //inputs10 
 
              n_p_reset10, 
              pclk10, 

              psel10, 
              penable10, 
              pwrite10, 
              paddr10, 
              pwdata10, 

              gpio_pin_in10, 

              scan_en10, 
              tri_state_enable10, 

              scan_in10, //added by smarkov10 for dft10
 
              //outputs10
              
              scan_out10, //added by smarkov10 for dft10 
               
              prdata10, 

              gpio_int10, 

              n_gpio_pin_oe10, 
              gpio_pin_out10 
); 
 


   // inputs10 
    
   // pclks10  
   input        n_p_reset10;            // amba10 reset 
   input        pclk10;               // peripherical10 pclk10 bus 

   // AMBA10 Rev10 2
   input        psel10;               // peripheral10 select10 for gpio10 
   input        penable10;            // peripheral10 enable 
   input        pwrite10;             // peripheral10 write strobe10 
   input [5:0] 
                paddr10;              // address bus of selected master10 
   input [31:0] 
                pwdata10;             // write data 

   // gpio10 generic10 inputs10 
   input [15:0] 
                gpio_pin_in10;             // input data from pin10 

   //design for test inputs10 
   input        scan_en10;            // enables10 shifting10 of scans10 
   input [15:0] 
                tri_state_enable10;   // disables10 op enable -> z 
   input        scan_in10;            // scan10 chain10 data input  
       
    
   // outputs10 
 
   //amba10 outputs10 
   output [31:0] 
                prdata10;             // read data 
   // gpio10 generic10 outputs10 
   output       gpio_int10;                // gpio_interupt10 for input pin10 change 
   output [15:0] 
                n_gpio_pin_oe10;           // output enable signal10 to pin10 
   output [15:0] 
                gpio_pin_out10;            // output signal10 to pin10 
                
   // scan10 outputs10
   output      scan_out10;            // scan10 chain10 data output
     
// gpio_internal10 signals10 declarations10
 
   // registers + wires10 for outputs10 
   reg  [31:0] 
                prdata10;             // registered output to apb10
   wire         gpio_int10;                // gpio_interrupt10 to apb10
   wire [15:0] 
                n_gpio_pin_oe10;           // gpio10 output enable
   wire [15:0] 
                gpio_pin_out10;            // gpio10 out
    
   // generic10 gpio10 stuff10 
   wire         write;              // apb10 register write strobe10
   wire         read;               // apb10 register read strobe10
   wire [5:0]
                addr;               // apb10 register address
   wire         n_p_reset10;            // apb10 reset
   wire         pclk10;               // apb10 clock10
   wire [15:0] 
                rdata10;              // registered output to apb10
   wire         sel10;                // apb10 peripheral10 select10
         
   //for gpio_interrupts10 
   wire [15:0] 
                gpio_interrupt_gen10;      // gpio_interrupt10 to apb10

   integer      i;                   // loop variable
                
 
    
   // assignments10 
 
   // generic10 assignments10 for the gpio10 bus 
   // variables10 starting with gpio10 are the 
   // generic10 variables10 used below10. 
   // change these10 variable to use another10 bus protocol10 
   // for the gpio10. 
 
   // inputs10  
   assign write      = pwrite10 & penable10 & psel10; 
    
   assign read       = ~(pwrite10) & ~(penable10) & psel10; 
    
   assign addr       = paddr10; 
  
   assign sel10        = psel10; 

   
   // p_map_prdata10: combinatorial10/ rdata10
   //
   // this process adds10 zeros10 to all the unused10 prdata10 lines10, 
   // according10 to the chosen10 width of the gpio10 module
   
   always @ ( rdata10 )
   begin : p_map_prdata10
      begin
         for ( i = 16; i < 32; i = i + 1 )
           prdata10[i] = 1'b0;
      end

      prdata10[15:0] = rdata10;

   end // p_map_prdata10

   assign gpio_int10 = |gpio_interrupt_gen10;

   gpio_lite_subunit10  // gpio_subunit10 module instance

   
   i_gpio_lite_subunit10 // instance name to take10 the annotated10 parameters10

// pin10 annotation10
   (
       //inputs10

       .n_reset10            (n_p_reset10),         // reset
       .pclk10               (pclk10),              // gpio10 pclk10
       .read               (read),              // select10 for gpio10
       .write              (write),             // gpio10 write
       .addr               (addr),              // address bus
       .wdata10              (pwdata10[15:0]),  
                                                 // gpio10 input
       .pin_in10             (gpio_pin_in10),        // input data from pin10
       .tri_state_enable10   (tri_state_enable10),   // disables10 op enable

       //outputs10
       .rdata10              (rdata10),              // gpio10 output
       .interrupt10          (gpio_interrupt_gen10), // gpio_interupt10
       .pin_oe_n10           (n_gpio_pin_oe10),      // output enable
       .pin_out10            (gpio_pin_out10)        // output signal10
    );

 endmodule
