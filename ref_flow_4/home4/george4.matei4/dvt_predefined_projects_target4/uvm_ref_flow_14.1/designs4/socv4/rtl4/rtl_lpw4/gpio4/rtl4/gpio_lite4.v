//File4 name   : gpio_lite4.v
//Title4       : GPIO4 top level
//Created4     : 1999
//Description4 : A gpio4 module for use with amba4 
//                   apb4, with up to 16 io4 pins4 
//Notes4       : 
//----------------------------------------------------------------------
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------

module gpio_lite4( 
              //inputs4 
 
              n_p_reset4, 
              pclk4, 

              psel4, 
              penable4, 
              pwrite4, 
              paddr4, 
              pwdata4, 

              gpio_pin_in4, 

              scan_en4, 
              tri_state_enable4, 

              scan_in4, //added by smarkov4 for dft4
 
              //outputs4
              
              scan_out4, //added by smarkov4 for dft4 
               
              prdata4, 

              gpio_int4, 

              n_gpio_pin_oe4, 
              gpio_pin_out4 
); 
 


   // inputs4 
    
   // pclks4  
   input        n_p_reset4;            // amba4 reset 
   input        pclk4;               // peripherical4 pclk4 bus 

   // AMBA4 Rev4 2
   input        psel4;               // peripheral4 select4 for gpio4 
   input        penable4;            // peripheral4 enable 
   input        pwrite4;             // peripheral4 write strobe4 
   input [5:0] 
                paddr4;              // address bus of selected master4 
   input [31:0] 
                pwdata4;             // write data 

   // gpio4 generic4 inputs4 
   input [15:0] 
                gpio_pin_in4;             // input data from pin4 

   //design for test inputs4 
   input        scan_en4;            // enables4 shifting4 of scans4 
   input [15:0] 
                tri_state_enable4;   // disables4 op enable -> z 
   input        scan_in4;            // scan4 chain4 data input  
       
    
   // outputs4 
 
   //amba4 outputs4 
   output [31:0] 
                prdata4;             // read data 
   // gpio4 generic4 outputs4 
   output       gpio_int4;                // gpio_interupt4 for input pin4 change 
   output [15:0] 
                n_gpio_pin_oe4;           // output enable signal4 to pin4 
   output [15:0] 
                gpio_pin_out4;            // output signal4 to pin4 
                
   // scan4 outputs4
   output      scan_out4;            // scan4 chain4 data output
     
// gpio_internal4 signals4 declarations4
 
   // registers + wires4 for outputs4 
   reg  [31:0] 
                prdata4;             // registered output to apb4
   wire         gpio_int4;                // gpio_interrupt4 to apb4
   wire [15:0] 
                n_gpio_pin_oe4;           // gpio4 output enable
   wire [15:0] 
                gpio_pin_out4;            // gpio4 out
    
   // generic4 gpio4 stuff4 
   wire         write;              // apb4 register write strobe4
   wire         read;               // apb4 register read strobe4
   wire [5:0]
                addr;               // apb4 register address
   wire         n_p_reset4;            // apb4 reset
   wire         pclk4;               // apb4 clock4
   wire [15:0] 
                rdata4;              // registered output to apb4
   wire         sel4;                // apb4 peripheral4 select4
         
   //for gpio_interrupts4 
   wire [15:0] 
                gpio_interrupt_gen4;      // gpio_interrupt4 to apb4

   integer      i;                   // loop variable
                
 
    
   // assignments4 
 
   // generic4 assignments4 for the gpio4 bus 
   // variables4 starting with gpio4 are the 
   // generic4 variables4 used below4. 
   // change these4 variable to use another4 bus protocol4 
   // for the gpio4. 
 
   // inputs4  
   assign write      = pwrite4 & penable4 & psel4; 
    
   assign read       = ~(pwrite4) & ~(penable4) & psel4; 
    
   assign addr       = paddr4; 
  
   assign sel4        = psel4; 

   
   // p_map_prdata4: combinatorial4/ rdata4
   //
   // this process adds4 zeros4 to all the unused4 prdata4 lines4, 
   // according4 to the chosen4 width of the gpio4 module
   
   always @ ( rdata4 )
   begin : p_map_prdata4
      begin
         for ( i = 16; i < 32; i = i + 1 )
           prdata4[i] = 1'b0;
      end

      prdata4[15:0] = rdata4;

   end // p_map_prdata4

   assign gpio_int4 = |gpio_interrupt_gen4;

   gpio_lite_subunit4  // gpio_subunit4 module instance

   
   i_gpio_lite_subunit4 // instance name to take4 the annotated4 parameters4

// pin4 annotation4
   (
       //inputs4

       .n_reset4            (n_p_reset4),         // reset
       .pclk4               (pclk4),              // gpio4 pclk4
       .read               (read),              // select4 for gpio4
       .write              (write),             // gpio4 write
       .addr               (addr),              // address bus
       .wdata4              (pwdata4[15:0]),  
                                                 // gpio4 input
       .pin_in4             (gpio_pin_in4),        // input data from pin4
       .tri_state_enable4   (tri_state_enable4),   // disables4 op enable

       //outputs4
       .rdata4              (rdata4),              // gpio4 output
       .interrupt4          (gpio_interrupt_gen4), // gpio_interupt4
       .pin_oe_n4           (n_gpio_pin_oe4),      // output enable
       .pin_out4            (gpio_pin_out4)        // output signal4
    );

 endmodule
