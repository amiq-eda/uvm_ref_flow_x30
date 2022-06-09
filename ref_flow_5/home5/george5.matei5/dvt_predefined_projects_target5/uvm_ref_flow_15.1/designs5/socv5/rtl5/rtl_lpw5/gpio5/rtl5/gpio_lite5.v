//File5 name   : gpio_lite5.v
//Title5       : GPIO5 top level
//Created5     : 1999
//Description5 : A gpio5 module for use with amba5 
//                   apb5, with up to 16 io5 pins5 
//Notes5       : 
//----------------------------------------------------------------------
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------

module gpio_lite5( 
              //inputs5 
 
              n_p_reset5, 
              pclk5, 

              psel5, 
              penable5, 
              pwrite5, 
              paddr5, 
              pwdata5, 

              gpio_pin_in5, 

              scan_en5, 
              tri_state_enable5, 

              scan_in5, //added by smarkov5 for dft5
 
              //outputs5
              
              scan_out5, //added by smarkov5 for dft5 
               
              prdata5, 

              gpio_int5, 

              n_gpio_pin_oe5, 
              gpio_pin_out5 
); 
 


   // inputs5 
    
   // pclks5  
   input        n_p_reset5;            // amba5 reset 
   input        pclk5;               // peripherical5 pclk5 bus 

   // AMBA5 Rev5 2
   input        psel5;               // peripheral5 select5 for gpio5 
   input        penable5;            // peripheral5 enable 
   input        pwrite5;             // peripheral5 write strobe5 
   input [5:0] 
                paddr5;              // address bus of selected master5 
   input [31:0] 
                pwdata5;             // write data 

   // gpio5 generic5 inputs5 
   input [15:0] 
                gpio_pin_in5;             // input data from pin5 

   //design for test inputs5 
   input        scan_en5;            // enables5 shifting5 of scans5 
   input [15:0] 
                tri_state_enable5;   // disables5 op enable -> z 
   input        scan_in5;            // scan5 chain5 data input  
       
    
   // outputs5 
 
   //amba5 outputs5 
   output [31:0] 
                prdata5;             // read data 
   // gpio5 generic5 outputs5 
   output       gpio_int5;                // gpio_interupt5 for input pin5 change 
   output [15:0] 
                n_gpio_pin_oe5;           // output enable signal5 to pin5 
   output [15:0] 
                gpio_pin_out5;            // output signal5 to pin5 
                
   // scan5 outputs5
   output      scan_out5;            // scan5 chain5 data output
     
// gpio_internal5 signals5 declarations5
 
   // registers + wires5 for outputs5 
   reg  [31:0] 
                prdata5;             // registered output to apb5
   wire         gpio_int5;                // gpio_interrupt5 to apb5
   wire [15:0] 
                n_gpio_pin_oe5;           // gpio5 output enable
   wire [15:0] 
                gpio_pin_out5;            // gpio5 out
    
   // generic5 gpio5 stuff5 
   wire         write;              // apb5 register write strobe5
   wire         read;               // apb5 register read strobe5
   wire [5:0]
                addr;               // apb5 register address
   wire         n_p_reset5;            // apb5 reset
   wire         pclk5;               // apb5 clock5
   wire [15:0] 
                rdata5;              // registered output to apb5
   wire         sel5;                // apb5 peripheral5 select5
         
   //for gpio_interrupts5 
   wire [15:0] 
                gpio_interrupt_gen5;      // gpio_interrupt5 to apb5

   integer      i;                   // loop variable
                
 
    
   // assignments5 
 
   // generic5 assignments5 for the gpio5 bus 
   // variables5 starting with gpio5 are the 
   // generic5 variables5 used below5. 
   // change these5 variable to use another5 bus protocol5 
   // for the gpio5. 
 
   // inputs5  
   assign write      = pwrite5 & penable5 & psel5; 
    
   assign read       = ~(pwrite5) & ~(penable5) & psel5; 
    
   assign addr       = paddr5; 
  
   assign sel5        = psel5; 

   
   // p_map_prdata5: combinatorial5/ rdata5
   //
   // this process adds5 zeros5 to all the unused5 prdata5 lines5, 
   // according5 to the chosen5 width of the gpio5 module
   
   always @ ( rdata5 )
   begin : p_map_prdata5
      begin
         for ( i = 16; i < 32; i = i + 1 )
           prdata5[i] = 1'b0;
      end

      prdata5[15:0] = rdata5;

   end // p_map_prdata5

   assign gpio_int5 = |gpio_interrupt_gen5;

   gpio_lite_subunit5  // gpio_subunit5 module instance

   
   i_gpio_lite_subunit5 // instance name to take5 the annotated5 parameters5

// pin5 annotation5
   (
       //inputs5

       .n_reset5            (n_p_reset5),         // reset
       .pclk5               (pclk5),              // gpio5 pclk5
       .read               (read),              // select5 for gpio5
       .write              (write),             // gpio5 write
       .addr               (addr),              // address bus
       .wdata5              (pwdata5[15:0]),  
                                                 // gpio5 input
       .pin_in5             (gpio_pin_in5),        // input data from pin5
       .tri_state_enable5   (tri_state_enable5),   // disables5 op enable

       //outputs5
       .rdata5              (rdata5),              // gpio5 output
       .interrupt5          (gpio_interrupt_gen5), // gpio_interupt5
       .pin_oe_n5           (n_gpio_pin_oe5),      // output enable
       .pin_out5            (gpio_pin_out5)        // output signal5
    );

 endmodule
