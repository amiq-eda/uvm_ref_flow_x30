//File12 name   : gpio_lite12.v
//Title12       : GPIO12 top level
//Created12     : 1999
//Description12 : A gpio12 module for use with amba12 
//                   apb12, with up to 16 io12 pins12 
//Notes12       : 
//----------------------------------------------------------------------
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------

module gpio_lite12( 
              //inputs12 
 
              n_p_reset12, 
              pclk12, 

              psel12, 
              penable12, 
              pwrite12, 
              paddr12, 
              pwdata12, 

              gpio_pin_in12, 

              scan_en12, 
              tri_state_enable12, 

              scan_in12, //added by smarkov12 for dft12
 
              //outputs12
              
              scan_out12, //added by smarkov12 for dft12 
               
              prdata12, 

              gpio_int12, 

              n_gpio_pin_oe12, 
              gpio_pin_out12 
); 
 


   // inputs12 
    
   // pclks12  
   input        n_p_reset12;            // amba12 reset 
   input        pclk12;               // peripherical12 pclk12 bus 

   // AMBA12 Rev12 2
   input        psel12;               // peripheral12 select12 for gpio12 
   input        penable12;            // peripheral12 enable 
   input        pwrite12;             // peripheral12 write strobe12 
   input [5:0] 
                paddr12;              // address bus of selected master12 
   input [31:0] 
                pwdata12;             // write data 

   // gpio12 generic12 inputs12 
   input [15:0] 
                gpio_pin_in12;             // input data from pin12 

   //design for test inputs12 
   input        scan_en12;            // enables12 shifting12 of scans12 
   input [15:0] 
                tri_state_enable12;   // disables12 op enable -> z 
   input        scan_in12;            // scan12 chain12 data input  
       
    
   // outputs12 
 
   //amba12 outputs12 
   output [31:0] 
                prdata12;             // read data 
   // gpio12 generic12 outputs12 
   output       gpio_int12;                // gpio_interupt12 for input pin12 change 
   output [15:0] 
                n_gpio_pin_oe12;           // output enable signal12 to pin12 
   output [15:0] 
                gpio_pin_out12;            // output signal12 to pin12 
                
   // scan12 outputs12
   output      scan_out12;            // scan12 chain12 data output
     
// gpio_internal12 signals12 declarations12
 
   // registers + wires12 for outputs12 
   reg  [31:0] 
                prdata12;             // registered output to apb12
   wire         gpio_int12;                // gpio_interrupt12 to apb12
   wire [15:0] 
                n_gpio_pin_oe12;           // gpio12 output enable
   wire [15:0] 
                gpio_pin_out12;            // gpio12 out
    
   // generic12 gpio12 stuff12 
   wire         write;              // apb12 register write strobe12
   wire         read;               // apb12 register read strobe12
   wire [5:0]
                addr;               // apb12 register address
   wire         n_p_reset12;            // apb12 reset
   wire         pclk12;               // apb12 clock12
   wire [15:0] 
                rdata12;              // registered output to apb12
   wire         sel12;                // apb12 peripheral12 select12
         
   //for gpio_interrupts12 
   wire [15:0] 
                gpio_interrupt_gen12;      // gpio_interrupt12 to apb12

   integer      i;                   // loop variable
                
 
    
   // assignments12 
 
   // generic12 assignments12 for the gpio12 bus 
   // variables12 starting with gpio12 are the 
   // generic12 variables12 used below12. 
   // change these12 variable to use another12 bus protocol12 
   // for the gpio12. 
 
   // inputs12  
   assign write      = pwrite12 & penable12 & psel12; 
    
   assign read       = ~(pwrite12) & ~(penable12) & psel12; 
    
   assign addr       = paddr12; 
  
   assign sel12        = psel12; 

   
   // p_map_prdata12: combinatorial12/ rdata12
   //
   // this process adds12 zeros12 to all the unused12 prdata12 lines12, 
   // according12 to the chosen12 width of the gpio12 module
   
   always @ ( rdata12 )
   begin : p_map_prdata12
      begin
         for ( i = 16; i < 32; i = i + 1 )
           prdata12[i] = 1'b0;
      end

      prdata12[15:0] = rdata12;

   end // p_map_prdata12

   assign gpio_int12 = |gpio_interrupt_gen12;

   gpio_lite_subunit12  // gpio_subunit12 module instance

   
   i_gpio_lite_subunit12 // instance name to take12 the annotated12 parameters12

// pin12 annotation12
   (
       //inputs12

       .n_reset12            (n_p_reset12),         // reset
       .pclk12               (pclk12),              // gpio12 pclk12
       .read               (read),              // select12 for gpio12
       .write              (write),             // gpio12 write
       .addr               (addr),              // address bus
       .wdata12              (pwdata12[15:0]),  
                                                 // gpio12 input
       .pin_in12             (gpio_pin_in12),        // input data from pin12
       .tri_state_enable12   (tri_state_enable12),   // disables12 op enable

       //outputs12
       .rdata12              (rdata12),              // gpio12 output
       .interrupt12          (gpio_interrupt_gen12), // gpio_interupt12
       .pin_oe_n12           (n_gpio_pin_oe12),      // output enable
       .pin_out12            (gpio_pin_out12)        // output signal12
    );

 endmodule
