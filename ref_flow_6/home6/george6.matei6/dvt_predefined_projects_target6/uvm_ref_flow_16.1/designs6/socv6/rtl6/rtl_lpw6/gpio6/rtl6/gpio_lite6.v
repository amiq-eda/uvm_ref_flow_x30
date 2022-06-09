//File6 name   : gpio_lite6.v
//Title6       : GPIO6 top level
//Created6     : 1999
//Description6 : A gpio6 module for use with amba6 
//                   apb6, with up to 16 io6 pins6 
//Notes6       : 
//----------------------------------------------------------------------
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------

module gpio_lite6( 
              //inputs6 
 
              n_p_reset6, 
              pclk6, 

              psel6, 
              penable6, 
              pwrite6, 
              paddr6, 
              pwdata6, 

              gpio_pin_in6, 

              scan_en6, 
              tri_state_enable6, 

              scan_in6, //added by smarkov6 for dft6
 
              //outputs6
              
              scan_out6, //added by smarkov6 for dft6 
               
              prdata6, 

              gpio_int6, 

              n_gpio_pin_oe6, 
              gpio_pin_out6 
); 
 


   // inputs6 
    
   // pclks6  
   input        n_p_reset6;            // amba6 reset 
   input        pclk6;               // peripherical6 pclk6 bus 

   // AMBA6 Rev6 2
   input        psel6;               // peripheral6 select6 for gpio6 
   input        penable6;            // peripheral6 enable 
   input        pwrite6;             // peripheral6 write strobe6 
   input [5:0] 
                paddr6;              // address bus of selected master6 
   input [31:0] 
                pwdata6;             // write data 

   // gpio6 generic6 inputs6 
   input [15:0] 
                gpio_pin_in6;             // input data from pin6 

   //design for test inputs6 
   input        scan_en6;            // enables6 shifting6 of scans6 
   input [15:0] 
                tri_state_enable6;   // disables6 op enable -> z 
   input        scan_in6;            // scan6 chain6 data input  
       
    
   // outputs6 
 
   //amba6 outputs6 
   output [31:0] 
                prdata6;             // read data 
   // gpio6 generic6 outputs6 
   output       gpio_int6;                // gpio_interupt6 for input pin6 change 
   output [15:0] 
                n_gpio_pin_oe6;           // output enable signal6 to pin6 
   output [15:0] 
                gpio_pin_out6;            // output signal6 to pin6 
                
   // scan6 outputs6
   output      scan_out6;            // scan6 chain6 data output
     
// gpio_internal6 signals6 declarations6
 
   // registers + wires6 for outputs6 
   reg  [31:0] 
                prdata6;             // registered output to apb6
   wire         gpio_int6;                // gpio_interrupt6 to apb6
   wire [15:0] 
                n_gpio_pin_oe6;           // gpio6 output enable
   wire [15:0] 
                gpio_pin_out6;            // gpio6 out
    
   // generic6 gpio6 stuff6 
   wire         write;              // apb6 register write strobe6
   wire         read;               // apb6 register read strobe6
   wire [5:0]
                addr;               // apb6 register address
   wire         n_p_reset6;            // apb6 reset
   wire         pclk6;               // apb6 clock6
   wire [15:0] 
                rdata6;              // registered output to apb6
   wire         sel6;                // apb6 peripheral6 select6
         
   //for gpio_interrupts6 
   wire [15:0] 
                gpio_interrupt_gen6;      // gpio_interrupt6 to apb6

   integer      i;                   // loop variable
                
 
    
   // assignments6 
 
   // generic6 assignments6 for the gpio6 bus 
   // variables6 starting with gpio6 are the 
   // generic6 variables6 used below6. 
   // change these6 variable to use another6 bus protocol6 
   // for the gpio6. 
 
   // inputs6  
   assign write      = pwrite6 & penable6 & psel6; 
    
   assign read       = ~(pwrite6) & ~(penable6) & psel6; 
    
   assign addr       = paddr6; 
  
   assign sel6        = psel6; 

   
   // p_map_prdata6: combinatorial6/ rdata6
   //
   // this process adds6 zeros6 to all the unused6 prdata6 lines6, 
   // according6 to the chosen6 width of the gpio6 module
   
   always @ ( rdata6 )
   begin : p_map_prdata6
      begin
         for ( i = 16; i < 32; i = i + 1 )
           prdata6[i] = 1'b0;
      end

      prdata6[15:0] = rdata6;

   end // p_map_prdata6

   assign gpio_int6 = |gpio_interrupt_gen6;

   gpio_lite_subunit6  // gpio_subunit6 module instance

   
   i_gpio_lite_subunit6 // instance name to take6 the annotated6 parameters6

// pin6 annotation6
   (
       //inputs6

       .n_reset6            (n_p_reset6),         // reset
       .pclk6               (pclk6),              // gpio6 pclk6
       .read               (read),              // select6 for gpio6
       .write              (write),             // gpio6 write
       .addr               (addr),              // address bus
       .wdata6              (pwdata6[15:0]),  
                                                 // gpio6 input
       .pin_in6             (gpio_pin_in6),        // input data from pin6
       .tri_state_enable6   (tri_state_enable6),   // disables6 op enable

       //outputs6
       .rdata6              (rdata6),              // gpio6 output
       .interrupt6          (gpio_interrupt_gen6), // gpio_interupt6
       .pin_oe_n6           (n_gpio_pin_oe6),      // output enable
       .pin_out6            (gpio_pin_out6)        // output signal6
    );

 endmodule
