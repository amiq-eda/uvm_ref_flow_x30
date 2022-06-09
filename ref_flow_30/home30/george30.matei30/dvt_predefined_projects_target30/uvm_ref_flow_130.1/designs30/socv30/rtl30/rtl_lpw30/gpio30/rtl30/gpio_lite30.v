//File30 name   : gpio_lite30.v
//Title30       : GPIO30 top level
//Created30     : 1999
//Description30 : A gpio30 module for use with amba30 
//                   apb30, with up to 16 io30 pins30 
//Notes30       : 
//----------------------------------------------------------------------
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------

module gpio_lite30( 
              //inputs30 
 
              n_p_reset30, 
              pclk30, 

              psel30, 
              penable30, 
              pwrite30, 
              paddr30, 
              pwdata30, 

              gpio_pin_in30, 

              scan_en30, 
              tri_state_enable30, 

              scan_in30, //added by smarkov30 for dft30
 
              //outputs30
              
              scan_out30, //added by smarkov30 for dft30 
               
              prdata30, 

              gpio_int30, 

              n_gpio_pin_oe30, 
              gpio_pin_out30 
); 
 


   // inputs30 
    
   // pclks30  
   input        n_p_reset30;            // amba30 reset 
   input        pclk30;               // peripherical30 pclk30 bus 

   // AMBA30 Rev30 2
   input        psel30;               // peripheral30 select30 for gpio30 
   input        penable30;            // peripheral30 enable 
   input        pwrite30;             // peripheral30 write strobe30 
   input [5:0] 
                paddr30;              // address bus of selected master30 
   input [31:0] 
                pwdata30;             // write data 

   // gpio30 generic30 inputs30 
   input [15:0] 
                gpio_pin_in30;             // input data from pin30 

   //design for test inputs30 
   input        scan_en30;            // enables30 shifting30 of scans30 
   input [15:0] 
                tri_state_enable30;   // disables30 op enable -> z 
   input        scan_in30;            // scan30 chain30 data input  
       
    
   // outputs30 
 
   //amba30 outputs30 
   output [31:0] 
                prdata30;             // read data 
   // gpio30 generic30 outputs30 
   output       gpio_int30;                // gpio_interupt30 for input pin30 change 
   output [15:0] 
                n_gpio_pin_oe30;           // output enable signal30 to pin30 
   output [15:0] 
                gpio_pin_out30;            // output signal30 to pin30 
                
   // scan30 outputs30
   output      scan_out30;            // scan30 chain30 data output
     
// gpio_internal30 signals30 declarations30
 
   // registers + wires30 for outputs30 
   reg  [31:0] 
                prdata30;             // registered output to apb30
   wire         gpio_int30;                // gpio_interrupt30 to apb30
   wire [15:0] 
                n_gpio_pin_oe30;           // gpio30 output enable
   wire [15:0] 
                gpio_pin_out30;            // gpio30 out
    
   // generic30 gpio30 stuff30 
   wire         write;              // apb30 register write strobe30
   wire         read;               // apb30 register read strobe30
   wire [5:0]
                addr;               // apb30 register address
   wire         n_p_reset30;            // apb30 reset
   wire         pclk30;               // apb30 clock30
   wire [15:0] 
                rdata30;              // registered output to apb30
   wire         sel30;                // apb30 peripheral30 select30
         
   //for gpio_interrupts30 
   wire [15:0] 
                gpio_interrupt_gen30;      // gpio_interrupt30 to apb30

   integer      i;                   // loop variable
                
 
    
   // assignments30 
 
   // generic30 assignments30 for the gpio30 bus 
   // variables30 starting with gpio30 are the 
   // generic30 variables30 used below30. 
   // change these30 variable to use another30 bus protocol30 
   // for the gpio30. 
 
   // inputs30  
   assign write      = pwrite30 & penable30 & psel30; 
    
   assign read       = ~(pwrite30) & ~(penable30) & psel30; 
    
   assign addr       = paddr30; 
  
   assign sel30        = psel30; 

   
   // p_map_prdata30: combinatorial30/ rdata30
   //
   // this process adds30 zeros30 to all the unused30 prdata30 lines30, 
   // according30 to the chosen30 width of the gpio30 module
   
   always @ ( rdata30 )
   begin : p_map_prdata30
      begin
         for ( i = 16; i < 32; i = i + 1 )
           prdata30[i] = 1'b0;
      end

      prdata30[15:0] = rdata30;

   end // p_map_prdata30

   assign gpio_int30 = |gpio_interrupt_gen30;

   gpio_lite_subunit30  // gpio_subunit30 module instance

   
   i_gpio_lite_subunit30 // instance name to take30 the annotated30 parameters30

// pin30 annotation30
   (
       //inputs30

       .n_reset30            (n_p_reset30),         // reset
       .pclk30               (pclk30),              // gpio30 pclk30
       .read               (read),              // select30 for gpio30
       .write              (write),             // gpio30 write
       .addr               (addr),              // address bus
       .wdata30              (pwdata30[15:0]),  
                                                 // gpio30 input
       .pin_in30             (gpio_pin_in30),        // input data from pin30
       .tri_state_enable30   (tri_state_enable30),   // disables30 op enable

       //outputs30
       .rdata30              (rdata30),              // gpio30 output
       .interrupt30          (gpio_interrupt_gen30), // gpio_interupt30
       .pin_oe_n30           (n_gpio_pin_oe30),      // output enable
       .pin_out30            (gpio_pin_out30)        // output signal30
    );

 endmodule
