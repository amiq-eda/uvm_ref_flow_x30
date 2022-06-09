//File19 name   : gpio_lite19.v
//Title19       : GPIO19 top level
//Created19     : 1999
//Description19 : A gpio19 module for use with amba19 
//                   apb19, with up to 16 io19 pins19 
//Notes19       : 
//----------------------------------------------------------------------
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------

module gpio_lite19( 
              //inputs19 
 
              n_p_reset19, 
              pclk19, 

              psel19, 
              penable19, 
              pwrite19, 
              paddr19, 
              pwdata19, 

              gpio_pin_in19, 

              scan_en19, 
              tri_state_enable19, 

              scan_in19, //added by smarkov19 for dft19
 
              //outputs19
              
              scan_out19, //added by smarkov19 for dft19 
               
              prdata19, 

              gpio_int19, 

              n_gpio_pin_oe19, 
              gpio_pin_out19 
); 
 


   // inputs19 
    
   // pclks19  
   input        n_p_reset19;            // amba19 reset 
   input        pclk19;               // peripherical19 pclk19 bus 

   // AMBA19 Rev19 2
   input        psel19;               // peripheral19 select19 for gpio19 
   input        penable19;            // peripheral19 enable 
   input        pwrite19;             // peripheral19 write strobe19 
   input [5:0] 
                paddr19;              // address bus of selected master19 
   input [31:0] 
                pwdata19;             // write data 

   // gpio19 generic19 inputs19 
   input [15:0] 
                gpio_pin_in19;             // input data from pin19 

   //design for test inputs19 
   input        scan_en19;            // enables19 shifting19 of scans19 
   input [15:0] 
                tri_state_enable19;   // disables19 op enable -> z 
   input        scan_in19;            // scan19 chain19 data input  
       
    
   // outputs19 
 
   //amba19 outputs19 
   output [31:0] 
                prdata19;             // read data 
   // gpio19 generic19 outputs19 
   output       gpio_int19;                // gpio_interupt19 for input pin19 change 
   output [15:0] 
                n_gpio_pin_oe19;           // output enable signal19 to pin19 
   output [15:0] 
                gpio_pin_out19;            // output signal19 to pin19 
                
   // scan19 outputs19
   output      scan_out19;            // scan19 chain19 data output
     
// gpio_internal19 signals19 declarations19
 
   // registers + wires19 for outputs19 
   reg  [31:0] 
                prdata19;             // registered output to apb19
   wire         gpio_int19;                // gpio_interrupt19 to apb19
   wire [15:0] 
                n_gpio_pin_oe19;           // gpio19 output enable
   wire [15:0] 
                gpio_pin_out19;            // gpio19 out
    
   // generic19 gpio19 stuff19 
   wire         write;              // apb19 register write strobe19
   wire         read;               // apb19 register read strobe19
   wire [5:0]
                addr;               // apb19 register address
   wire         n_p_reset19;            // apb19 reset
   wire         pclk19;               // apb19 clock19
   wire [15:0] 
                rdata19;              // registered output to apb19
   wire         sel19;                // apb19 peripheral19 select19
         
   //for gpio_interrupts19 
   wire [15:0] 
                gpio_interrupt_gen19;      // gpio_interrupt19 to apb19

   integer      i;                   // loop variable
                
 
    
   // assignments19 
 
   // generic19 assignments19 for the gpio19 bus 
   // variables19 starting with gpio19 are the 
   // generic19 variables19 used below19. 
   // change these19 variable to use another19 bus protocol19 
   // for the gpio19. 
 
   // inputs19  
   assign write      = pwrite19 & penable19 & psel19; 
    
   assign read       = ~(pwrite19) & ~(penable19) & psel19; 
    
   assign addr       = paddr19; 
  
   assign sel19        = psel19; 

   
   // p_map_prdata19: combinatorial19/ rdata19
   //
   // this process adds19 zeros19 to all the unused19 prdata19 lines19, 
   // according19 to the chosen19 width of the gpio19 module
   
   always @ ( rdata19 )
   begin : p_map_prdata19
      begin
         for ( i = 16; i < 32; i = i + 1 )
           prdata19[i] = 1'b0;
      end

      prdata19[15:0] = rdata19;

   end // p_map_prdata19

   assign gpio_int19 = |gpio_interrupt_gen19;

   gpio_lite_subunit19  // gpio_subunit19 module instance

   
   i_gpio_lite_subunit19 // instance name to take19 the annotated19 parameters19

// pin19 annotation19
   (
       //inputs19

       .n_reset19            (n_p_reset19),         // reset
       .pclk19               (pclk19),              // gpio19 pclk19
       .read               (read),              // select19 for gpio19
       .write              (write),             // gpio19 write
       .addr               (addr),              // address bus
       .wdata19              (pwdata19[15:0]),  
                                                 // gpio19 input
       .pin_in19             (gpio_pin_in19),        // input data from pin19
       .tri_state_enable19   (tri_state_enable19),   // disables19 op enable

       //outputs19
       .rdata19              (rdata19),              // gpio19 output
       .interrupt19          (gpio_interrupt_gen19), // gpio_interupt19
       .pin_oe_n19           (n_gpio_pin_oe19),      // output enable
       .pin_out19            (gpio_pin_out19)        // output signal19
    );

 endmodule
