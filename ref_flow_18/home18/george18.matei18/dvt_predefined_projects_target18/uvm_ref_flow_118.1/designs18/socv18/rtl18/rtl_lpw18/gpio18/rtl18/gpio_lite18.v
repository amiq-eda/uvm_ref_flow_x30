//File18 name   : gpio_lite18.v
//Title18       : GPIO18 top level
//Created18     : 1999
//Description18 : A gpio18 module for use with amba18 
//                   apb18, with up to 16 io18 pins18 
//Notes18       : 
//----------------------------------------------------------------------
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------

module gpio_lite18( 
              //inputs18 
 
              n_p_reset18, 
              pclk18, 

              psel18, 
              penable18, 
              pwrite18, 
              paddr18, 
              pwdata18, 

              gpio_pin_in18, 

              scan_en18, 
              tri_state_enable18, 

              scan_in18, //added by smarkov18 for dft18
 
              //outputs18
              
              scan_out18, //added by smarkov18 for dft18 
               
              prdata18, 

              gpio_int18, 

              n_gpio_pin_oe18, 
              gpio_pin_out18 
); 
 


   // inputs18 
    
   // pclks18  
   input        n_p_reset18;            // amba18 reset 
   input        pclk18;               // peripherical18 pclk18 bus 

   // AMBA18 Rev18 2
   input        psel18;               // peripheral18 select18 for gpio18 
   input        penable18;            // peripheral18 enable 
   input        pwrite18;             // peripheral18 write strobe18 
   input [5:0] 
                paddr18;              // address bus of selected master18 
   input [31:0] 
                pwdata18;             // write data 

   // gpio18 generic18 inputs18 
   input [15:0] 
                gpio_pin_in18;             // input data from pin18 

   //design for test inputs18 
   input        scan_en18;            // enables18 shifting18 of scans18 
   input [15:0] 
                tri_state_enable18;   // disables18 op enable -> z 
   input        scan_in18;            // scan18 chain18 data input  
       
    
   // outputs18 
 
   //amba18 outputs18 
   output [31:0] 
                prdata18;             // read data 
   // gpio18 generic18 outputs18 
   output       gpio_int18;                // gpio_interupt18 for input pin18 change 
   output [15:0] 
                n_gpio_pin_oe18;           // output enable signal18 to pin18 
   output [15:0] 
                gpio_pin_out18;            // output signal18 to pin18 
                
   // scan18 outputs18
   output      scan_out18;            // scan18 chain18 data output
     
// gpio_internal18 signals18 declarations18
 
   // registers + wires18 for outputs18 
   reg  [31:0] 
                prdata18;             // registered output to apb18
   wire         gpio_int18;                // gpio_interrupt18 to apb18
   wire [15:0] 
                n_gpio_pin_oe18;           // gpio18 output enable
   wire [15:0] 
                gpio_pin_out18;            // gpio18 out
    
   // generic18 gpio18 stuff18 
   wire         write;              // apb18 register write strobe18
   wire         read;               // apb18 register read strobe18
   wire [5:0]
                addr;               // apb18 register address
   wire         n_p_reset18;            // apb18 reset
   wire         pclk18;               // apb18 clock18
   wire [15:0] 
                rdata18;              // registered output to apb18
   wire         sel18;                // apb18 peripheral18 select18
         
   //for gpio_interrupts18 
   wire [15:0] 
                gpio_interrupt_gen18;      // gpio_interrupt18 to apb18

   integer      i;                   // loop variable
                
 
    
   // assignments18 
 
   // generic18 assignments18 for the gpio18 bus 
   // variables18 starting with gpio18 are the 
   // generic18 variables18 used below18. 
   // change these18 variable to use another18 bus protocol18 
   // for the gpio18. 
 
   // inputs18  
   assign write      = pwrite18 & penable18 & psel18; 
    
   assign read       = ~(pwrite18) & ~(penable18) & psel18; 
    
   assign addr       = paddr18; 
  
   assign sel18        = psel18; 

   
   // p_map_prdata18: combinatorial18/ rdata18
   //
   // this process adds18 zeros18 to all the unused18 prdata18 lines18, 
   // according18 to the chosen18 width of the gpio18 module
   
   always @ ( rdata18 )
   begin : p_map_prdata18
      begin
         for ( i = 16; i < 32; i = i + 1 )
           prdata18[i] = 1'b0;
      end

      prdata18[15:0] = rdata18;

   end // p_map_prdata18

   assign gpio_int18 = |gpio_interrupt_gen18;

   gpio_lite_subunit18  // gpio_subunit18 module instance

   
   i_gpio_lite_subunit18 // instance name to take18 the annotated18 parameters18

// pin18 annotation18
   (
       //inputs18

       .n_reset18            (n_p_reset18),         // reset
       .pclk18               (pclk18),              // gpio18 pclk18
       .read               (read),              // select18 for gpio18
       .write              (write),             // gpio18 write
       .addr               (addr),              // address bus
       .wdata18              (pwdata18[15:0]),  
                                                 // gpio18 input
       .pin_in18             (gpio_pin_in18),        // input data from pin18
       .tri_state_enable18   (tri_state_enable18),   // disables18 op enable

       //outputs18
       .rdata18              (rdata18),              // gpio18 output
       .interrupt18          (gpio_interrupt_gen18), // gpio_interupt18
       .pin_oe_n18           (n_gpio_pin_oe18),      // output enable
       .pin_out18            (gpio_pin_out18)        // output signal18
    );

 endmodule
