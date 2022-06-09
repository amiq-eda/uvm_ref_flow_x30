//File13 name   : gpio_lite13.v
//Title13       : GPIO13 top level
//Created13     : 1999
//Description13 : A gpio13 module for use with amba13 
//                   apb13, with up to 16 io13 pins13 
//Notes13       : 
//----------------------------------------------------------------------
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------

module gpio_lite13( 
              //inputs13 
 
              n_p_reset13, 
              pclk13, 

              psel13, 
              penable13, 
              pwrite13, 
              paddr13, 
              pwdata13, 

              gpio_pin_in13, 

              scan_en13, 
              tri_state_enable13, 

              scan_in13, //added by smarkov13 for dft13
 
              //outputs13
              
              scan_out13, //added by smarkov13 for dft13 
               
              prdata13, 

              gpio_int13, 

              n_gpio_pin_oe13, 
              gpio_pin_out13 
); 
 


   // inputs13 
    
   // pclks13  
   input        n_p_reset13;            // amba13 reset 
   input        pclk13;               // peripherical13 pclk13 bus 

   // AMBA13 Rev13 2
   input        psel13;               // peripheral13 select13 for gpio13 
   input        penable13;            // peripheral13 enable 
   input        pwrite13;             // peripheral13 write strobe13 
   input [5:0] 
                paddr13;              // address bus of selected master13 
   input [31:0] 
                pwdata13;             // write data 

   // gpio13 generic13 inputs13 
   input [15:0] 
                gpio_pin_in13;             // input data from pin13 

   //design for test inputs13 
   input        scan_en13;            // enables13 shifting13 of scans13 
   input [15:0] 
                tri_state_enable13;   // disables13 op enable -> z 
   input        scan_in13;            // scan13 chain13 data input  
       
    
   // outputs13 
 
   //amba13 outputs13 
   output [31:0] 
                prdata13;             // read data 
   // gpio13 generic13 outputs13 
   output       gpio_int13;                // gpio_interupt13 for input pin13 change 
   output [15:0] 
                n_gpio_pin_oe13;           // output enable signal13 to pin13 
   output [15:0] 
                gpio_pin_out13;            // output signal13 to pin13 
                
   // scan13 outputs13
   output      scan_out13;            // scan13 chain13 data output
     
// gpio_internal13 signals13 declarations13
 
   // registers + wires13 for outputs13 
   reg  [31:0] 
                prdata13;             // registered output to apb13
   wire         gpio_int13;                // gpio_interrupt13 to apb13
   wire [15:0] 
                n_gpio_pin_oe13;           // gpio13 output enable
   wire [15:0] 
                gpio_pin_out13;            // gpio13 out
    
   // generic13 gpio13 stuff13 
   wire         write;              // apb13 register write strobe13
   wire         read;               // apb13 register read strobe13
   wire [5:0]
                addr;               // apb13 register address
   wire         n_p_reset13;            // apb13 reset
   wire         pclk13;               // apb13 clock13
   wire [15:0] 
                rdata13;              // registered output to apb13
   wire         sel13;                // apb13 peripheral13 select13
         
   //for gpio_interrupts13 
   wire [15:0] 
                gpio_interrupt_gen13;      // gpio_interrupt13 to apb13

   integer      i;                   // loop variable
                
 
    
   // assignments13 
 
   // generic13 assignments13 for the gpio13 bus 
   // variables13 starting with gpio13 are the 
   // generic13 variables13 used below13. 
   // change these13 variable to use another13 bus protocol13 
   // for the gpio13. 
 
   // inputs13  
   assign write      = pwrite13 & penable13 & psel13; 
    
   assign read       = ~(pwrite13) & ~(penable13) & psel13; 
    
   assign addr       = paddr13; 
  
   assign sel13        = psel13; 

   
   // p_map_prdata13: combinatorial13/ rdata13
   //
   // this process adds13 zeros13 to all the unused13 prdata13 lines13, 
   // according13 to the chosen13 width of the gpio13 module
   
   always @ ( rdata13 )
   begin : p_map_prdata13
      begin
         for ( i = 16; i < 32; i = i + 1 )
           prdata13[i] = 1'b0;
      end

      prdata13[15:0] = rdata13;

   end // p_map_prdata13

   assign gpio_int13 = |gpio_interrupt_gen13;

   gpio_lite_subunit13  // gpio_subunit13 module instance

   
   i_gpio_lite_subunit13 // instance name to take13 the annotated13 parameters13

// pin13 annotation13
   (
       //inputs13

       .n_reset13            (n_p_reset13),         // reset
       .pclk13               (pclk13),              // gpio13 pclk13
       .read               (read),              // select13 for gpio13
       .write              (write),             // gpio13 write
       .addr               (addr),              // address bus
       .wdata13              (pwdata13[15:0]),  
                                                 // gpio13 input
       .pin_in13             (gpio_pin_in13),        // input data from pin13
       .tri_state_enable13   (tri_state_enable13),   // disables13 op enable

       //outputs13
       .rdata13              (rdata13),              // gpio13 output
       .interrupt13          (gpio_interrupt_gen13), // gpio_interupt13
       .pin_oe_n13           (n_gpio_pin_oe13),      // output enable
       .pin_out13            (gpio_pin_out13)        // output signal13
    );

 endmodule
