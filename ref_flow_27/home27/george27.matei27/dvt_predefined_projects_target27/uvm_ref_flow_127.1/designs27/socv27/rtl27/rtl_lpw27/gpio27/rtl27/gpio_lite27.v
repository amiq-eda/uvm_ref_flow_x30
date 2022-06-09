//File27 name   : gpio_lite27.v
//Title27       : GPIO27 top level
//Created27     : 1999
//Description27 : A gpio27 module for use with amba27 
//                   apb27, with up to 16 io27 pins27 
//Notes27       : 
//----------------------------------------------------------------------
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------

module gpio_lite27( 
              //inputs27 
 
              n_p_reset27, 
              pclk27, 

              psel27, 
              penable27, 
              pwrite27, 
              paddr27, 
              pwdata27, 

              gpio_pin_in27, 

              scan_en27, 
              tri_state_enable27, 

              scan_in27, //added by smarkov27 for dft27
 
              //outputs27
              
              scan_out27, //added by smarkov27 for dft27 
               
              prdata27, 

              gpio_int27, 

              n_gpio_pin_oe27, 
              gpio_pin_out27 
); 
 


   // inputs27 
    
   // pclks27  
   input        n_p_reset27;            // amba27 reset 
   input        pclk27;               // peripherical27 pclk27 bus 

   // AMBA27 Rev27 2
   input        psel27;               // peripheral27 select27 for gpio27 
   input        penable27;            // peripheral27 enable 
   input        pwrite27;             // peripheral27 write strobe27 
   input [5:0] 
                paddr27;              // address bus of selected master27 
   input [31:0] 
                pwdata27;             // write data 

   // gpio27 generic27 inputs27 
   input [15:0] 
                gpio_pin_in27;             // input data from pin27 

   //design for test inputs27 
   input        scan_en27;            // enables27 shifting27 of scans27 
   input [15:0] 
                tri_state_enable27;   // disables27 op enable -> z 
   input        scan_in27;            // scan27 chain27 data input  
       
    
   // outputs27 
 
   //amba27 outputs27 
   output [31:0] 
                prdata27;             // read data 
   // gpio27 generic27 outputs27 
   output       gpio_int27;                // gpio_interupt27 for input pin27 change 
   output [15:0] 
                n_gpio_pin_oe27;           // output enable signal27 to pin27 
   output [15:0] 
                gpio_pin_out27;            // output signal27 to pin27 
                
   // scan27 outputs27
   output      scan_out27;            // scan27 chain27 data output
     
// gpio_internal27 signals27 declarations27
 
   // registers + wires27 for outputs27 
   reg  [31:0] 
                prdata27;             // registered output to apb27
   wire         gpio_int27;                // gpio_interrupt27 to apb27
   wire [15:0] 
                n_gpio_pin_oe27;           // gpio27 output enable
   wire [15:0] 
                gpio_pin_out27;            // gpio27 out
    
   // generic27 gpio27 stuff27 
   wire         write;              // apb27 register write strobe27
   wire         read;               // apb27 register read strobe27
   wire [5:0]
                addr;               // apb27 register address
   wire         n_p_reset27;            // apb27 reset
   wire         pclk27;               // apb27 clock27
   wire [15:0] 
                rdata27;              // registered output to apb27
   wire         sel27;                // apb27 peripheral27 select27
         
   //for gpio_interrupts27 
   wire [15:0] 
                gpio_interrupt_gen27;      // gpio_interrupt27 to apb27

   integer      i;                   // loop variable
                
 
    
   // assignments27 
 
   // generic27 assignments27 for the gpio27 bus 
   // variables27 starting with gpio27 are the 
   // generic27 variables27 used below27. 
   // change these27 variable to use another27 bus protocol27 
   // for the gpio27. 
 
   // inputs27  
   assign write      = pwrite27 & penable27 & psel27; 
    
   assign read       = ~(pwrite27) & ~(penable27) & psel27; 
    
   assign addr       = paddr27; 
  
   assign sel27        = psel27; 

   
   // p_map_prdata27: combinatorial27/ rdata27
   //
   // this process adds27 zeros27 to all the unused27 prdata27 lines27, 
   // according27 to the chosen27 width of the gpio27 module
   
   always @ ( rdata27 )
   begin : p_map_prdata27
      begin
         for ( i = 16; i < 32; i = i + 1 )
           prdata27[i] = 1'b0;
      end

      prdata27[15:0] = rdata27;

   end // p_map_prdata27

   assign gpio_int27 = |gpio_interrupt_gen27;

   gpio_lite_subunit27  // gpio_subunit27 module instance

   
   i_gpio_lite_subunit27 // instance name to take27 the annotated27 parameters27

// pin27 annotation27
   (
       //inputs27

       .n_reset27            (n_p_reset27),         // reset
       .pclk27               (pclk27),              // gpio27 pclk27
       .read               (read),              // select27 for gpio27
       .write              (write),             // gpio27 write
       .addr               (addr),              // address bus
       .wdata27              (pwdata27[15:0]),  
                                                 // gpio27 input
       .pin_in27             (gpio_pin_in27),        // input data from pin27
       .tri_state_enable27   (tri_state_enable27),   // disables27 op enable

       //outputs27
       .rdata27              (rdata27),              // gpio27 output
       .interrupt27          (gpio_interrupt_gen27), // gpio_interupt27
       .pin_oe_n27           (n_gpio_pin_oe27),      // output enable
       .pin_out27            (gpio_pin_out27)        // output signal27
    );

 endmodule
