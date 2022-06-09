//File7 name   : gpio_lite7.v
//Title7       : GPIO7 top level
//Created7     : 1999
//Description7 : A gpio7 module for use with amba7 
//                   apb7, with up to 16 io7 pins7 
//Notes7       : 
//----------------------------------------------------------------------
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------

module gpio_lite7( 
              //inputs7 
 
              n_p_reset7, 
              pclk7, 

              psel7, 
              penable7, 
              pwrite7, 
              paddr7, 
              pwdata7, 

              gpio_pin_in7, 

              scan_en7, 
              tri_state_enable7, 

              scan_in7, //added by smarkov7 for dft7
 
              //outputs7
              
              scan_out7, //added by smarkov7 for dft7 
               
              prdata7, 

              gpio_int7, 

              n_gpio_pin_oe7, 
              gpio_pin_out7 
); 
 


   // inputs7 
    
   // pclks7  
   input        n_p_reset7;            // amba7 reset 
   input        pclk7;               // peripherical7 pclk7 bus 

   // AMBA7 Rev7 2
   input        psel7;               // peripheral7 select7 for gpio7 
   input        penable7;            // peripheral7 enable 
   input        pwrite7;             // peripheral7 write strobe7 
   input [5:0] 
                paddr7;              // address bus of selected master7 
   input [31:0] 
                pwdata7;             // write data 

   // gpio7 generic7 inputs7 
   input [15:0] 
                gpio_pin_in7;             // input data from pin7 

   //design for test inputs7 
   input        scan_en7;            // enables7 shifting7 of scans7 
   input [15:0] 
                tri_state_enable7;   // disables7 op enable -> z 
   input        scan_in7;            // scan7 chain7 data input  
       
    
   // outputs7 
 
   //amba7 outputs7 
   output [31:0] 
                prdata7;             // read data 
   // gpio7 generic7 outputs7 
   output       gpio_int7;                // gpio_interupt7 for input pin7 change 
   output [15:0] 
                n_gpio_pin_oe7;           // output enable signal7 to pin7 
   output [15:0] 
                gpio_pin_out7;            // output signal7 to pin7 
                
   // scan7 outputs7
   output      scan_out7;            // scan7 chain7 data output
     
// gpio_internal7 signals7 declarations7
 
   // registers + wires7 for outputs7 
   reg  [31:0] 
                prdata7;             // registered output to apb7
   wire         gpio_int7;                // gpio_interrupt7 to apb7
   wire [15:0] 
                n_gpio_pin_oe7;           // gpio7 output enable
   wire [15:0] 
                gpio_pin_out7;            // gpio7 out
    
   // generic7 gpio7 stuff7 
   wire         write;              // apb7 register write strobe7
   wire         read;               // apb7 register read strobe7
   wire [5:0]
                addr;               // apb7 register address
   wire         n_p_reset7;            // apb7 reset
   wire         pclk7;               // apb7 clock7
   wire [15:0] 
                rdata7;              // registered output to apb7
   wire         sel7;                // apb7 peripheral7 select7
         
   //for gpio_interrupts7 
   wire [15:0] 
                gpio_interrupt_gen7;      // gpio_interrupt7 to apb7

   integer      i;                   // loop variable
                
 
    
   // assignments7 
 
   // generic7 assignments7 for the gpio7 bus 
   // variables7 starting with gpio7 are the 
   // generic7 variables7 used below7. 
   // change these7 variable to use another7 bus protocol7 
   // for the gpio7. 
 
   // inputs7  
   assign write      = pwrite7 & penable7 & psel7; 
    
   assign read       = ~(pwrite7) & ~(penable7) & psel7; 
    
   assign addr       = paddr7; 
  
   assign sel7        = psel7; 

   
   // p_map_prdata7: combinatorial7/ rdata7
   //
   // this process adds7 zeros7 to all the unused7 prdata7 lines7, 
   // according7 to the chosen7 width of the gpio7 module
   
   always @ ( rdata7 )
   begin : p_map_prdata7
      begin
         for ( i = 16; i < 32; i = i + 1 )
           prdata7[i] = 1'b0;
      end

      prdata7[15:0] = rdata7;

   end // p_map_prdata7

   assign gpio_int7 = |gpio_interrupt_gen7;

   gpio_lite_subunit7  // gpio_subunit7 module instance

   
   i_gpio_lite_subunit7 // instance name to take7 the annotated7 parameters7

// pin7 annotation7
   (
       //inputs7

       .n_reset7            (n_p_reset7),         // reset
       .pclk7               (pclk7),              // gpio7 pclk7
       .read               (read),              // select7 for gpio7
       .write              (write),             // gpio7 write
       .addr               (addr),              // address bus
       .wdata7              (pwdata7[15:0]),  
                                                 // gpio7 input
       .pin_in7             (gpio_pin_in7),        // input data from pin7
       .tri_state_enable7   (tri_state_enable7),   // disables7 op enable

       //outputs7
       .rdata7              (rdata7),              // gpio7 output
       .interrupt7          (gpio_interrupt_gen7), // gpio_interupt7
       .pin_oe_n7           (n_gpio_pin_oe7),      // output enable
       .pin_out7            (gpio_pin_out7)        // output signal7
    );

 endmodule
