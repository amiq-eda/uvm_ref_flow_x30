//File11 name   : gpio_lite11.v
//Title11       : GPIO11 top level
//Created11     : 1999
//Description11 : A gpio11 module for use with amba11 
//                   apb11, with up to 16 io11 pins11 
//Notes11       : 
//----------------------------------------------------------------------
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------

module gpio_lite11( 
              //inputs11 
 
              n_p_reset11, 
              pclk11, 

              psel11, 
              penable11, 
              pwrite11, 
              paddr11, 
              pwdata11, 

              gpio_pin_in11, 

              scan_en11, 
              tri_state_enable11, 

              scan_in11, //added by smarkov11 for dft11
 
              //outputs11
              
              scan_out11, //added by smarkov11 for dft11 
               
              prdata11, 

              gpio_int11, 

              n_gpio_pin_oe11, 
              gpio_pin_out11 
); 
 


   // inputs11 
    
   // pclks11  
   input        n_p_reset11;            // amba11 reset 
   input        pclk11;               // peripherical11 pclk11 bus 

   // AMBA11 Rev11 2
   input        psel11;               // peripheral11 select11 for gpio11 
   input        penable11;            // peripheral11 enable 
   input        pwrite11;             // peripheral11 write strobe11 
   input [5:0] 
                paddr11;              // address bus of selected master11 
   input [31:0] 
                pwdata11;             // write data 

   // gpio11 generic11 inputs11 
   input [15:0] 
                gpio_pin_in11;             // input data from pin11 

   //design for test inputs11 
   input        scan_en11;            // enables11 shifting11 of scans11 
   input [15:0] 
                tri_state_enable11;   // disables11 op enable -> z 
   input        scan_in11;            // scan11 chain11 data input  
       
    
   // outputs11 
 
   //amba11 outputs11 
   output [31:0] 
                prdata11;             // read data 
   // gpio11 generic11 outputs11 
   output       gpio_int11;                // gpio_interupt11 for input pin11 change 
   output [15:0] 
                n_gpio_pin_oe11;           // output enable signal11 to pin11 
   output [15:0] 
                gpio_pin_out11;            // output signal11 to pin11 
                
   // scan11 outputs11
   output      scan_out11;            // scan11 chain11 data output
     
// gpio_internal11 signals11 declarations11
 
   // registers + wires11 for outputs11 
   reg  [31:0] 
                prdata11;             // registered output to apb11
   wire         gpio_int11;                // gpio_interrupt11 to apb11
   wire [15:0] 
                n_gpio_pin_oe11;           // gpio11 output enable
   wire [15:0] 
                gpio_pin_out11;            // gpio11 out
    
   // generic11 gpio11 stuff11 
   wire         write;              // apb11 register write strobe11
   wire         read;               // apb11 register read strobe11
   wire [5:0]
                addr;               // apb11 register address
   wire         n_p_reset11;            // apb11 reset
   wire         pclk11;               // apb11 clock11
   wire [15:0] 
                rdata11;              // registered output to apb11
   wire         sel11;                // apb11 peripheral11 select11
         
   //for gpio_interrupts11 
   wire [15:0] 
                gpio_interrupt_gen11;      // gpio_interrupt11 to apb11

   integer      i;                   // loop variable
                
 
    
   // assignments11 
 
   // generic11 assignments11 for the gpio11 bus 
   // variables11 starting with gpio11 are the 
   // generic11 variables11 used below11. 
   // change these11 variable to use another11 bus protocol11 
   // for the gpio11. 
 
   // inputs11  
   assign write      = pwrite11 & penable11 & psel11; 
    
   assign read       = ~(pwrite11) & ~(penable11) & psel11; 
    
   assign addr       = paddr11; 
  
   assign sel11        = psel11; 

   
   // p_map_prdata11: combinatorial11/ rdata11
   //
   // this process adds11 zeros11 to all the unused11 prdata11 lines11, 
   // according11 to the chosen11 width of the gpio11 module
   
   always @ ( rdata11 )
   begin : p_map_prdata11
      begin
         for ( i = 16; i < 32; i = i + 1 )
           prdata11[i] = 1'b0;
      end

      prdata11[15:0] = rdata11;

   end // p_map_prdata11

   assign gpio_int11 = |gpio_interrupt_gen11;

   gpio_lite_subunit11  // gpio_subunit11 module instance

   
   i_gpio_lite_subunit11 // instance name to take11 the annotated11 parameters11

// pin11 annotation11
   (
       //inputs11

       .n_reset11            (n_p_reset11),         // reset
       .pclk11               (pclk11),              // gpio11 pclk11
       .read               (read),              // select11 for gpio11
       .write              (write),             // gpio11 write
       .addr               (addr),              // address bus
       .wdata11              (pwdata11[15:0]),  
                                                 // gpio11 input
       .pin_in11             (gpio_pin_in11),        // input data from pin11
       .tri_state_enable11   (tri_state_enable11),   // disables11 op enable

       //outputs11
       .rdata11              (rdata11),              // gpio11 output
       .interrupt11          (gpio_interrupt_gen11), // gpio_interupt11
       .pin_oe_n11           (n_gpio_pin_oe11),      // output enable
       .pin_out11            (gpio_pin_out11)        // output signal11
    );

 endmodule
