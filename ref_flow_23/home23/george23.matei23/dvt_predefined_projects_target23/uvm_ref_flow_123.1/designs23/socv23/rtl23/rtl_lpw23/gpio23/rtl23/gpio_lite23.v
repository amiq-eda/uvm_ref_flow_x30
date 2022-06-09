//File23 name   : gpio_lite23.v
//Title23       : GPIO23 top level
//Created23     : 1999
//Description23 : A gpio23 module for use with amba23 
//                   apb23, with up to 16 io23 pins23 
//Notes23       : 
//----------------------------------------------------------------------
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------

module gpio_lite23( 
              //inputs23 
 
              n_p_reset23, 
              pclk23, 

              psel23, 
              penable23, 
              pwrite23, 
              paddr23, 
              pwdata23, 

              gpio_pin_in23, 

              scan_en23, 
              tri_state_enable23, 

              scan_in23, //added by smarkov23 for dft23
 
              //outputs23
              
              scan_out23, //added by smarkov23 for dft23 
               
              prdata23, 

              gpio_int23, 

              n_gpio_pin_oe23, 
              gpio_pin_out23 
); 
 


   // inputs23 
    
   // pclks23  
   input        n_p_reset23;            // amba23 reset 
   input        pclk23;               // peripherical23 pclk23 bus 

   // AMBA23 Rev23 2
   input        psel23;               // peripheral23 select23 for gpio23 
   input        penable23;            // peripheral23 enable 
   input        pwrite23;             // peripheral23 write strobe23 
   input [5:0] 
                paddr23;              // address bus of selected master23 
   input [31:0] 
                pwdata23;             // write data 

   // gpio23 generic23 inputs23 
   input [15:0] 
                gpio_pin_in23;             // input data from pin23 

   //design for test inputs23 
   input        scan_en23;            // enables23 shifting23 of scans23 
   input [15:0] 
                tri_state_enable23;   // disables23 op enable -> z 
   input        scan_in23;            // scan23 chain23 data input  
       
    
   // outputs23 
 
   //amba23 outputs23 
   output [31:0] 
                prdata23;             // read data 
   // gpio23 generic23 outputs23 
   output       gpio_int23;                // gpio_interupt23 for input pin23 change 
   output [15:0] 
                n_gpio_pin_oe23;           // output enable signal23 to pin23 
   output [15:0] 
                gpio_pin_out23;            // output signal23 to pin23 
                
   // scan23 outputs23
   output      scan_out23;            // scan23 chain23 data output
     
// gpio_internal23 signals23 declarations23
 
   // registers + wires23 for outputs23 
   reg  [31:0] 
                prdata23;             // registered output to apb23
   wire         gpio_int23;                // gpio_interrupt23 to apb23
   wire [15:0] 
                n_gpio_pin_oe23;           // gpio23 output enable
   wire [15:0] 
                gpio_pin_out23;            // gpio23 out
    
   // generic23 gpio23 stuff23 
   wire         write;              // apb23 register write strobe23
   wire         read;               // apb23 register read strobe23
   wire [5:0]
                addr;               // apb23 register address
   wire         n_p_reset23;            // apb23 reset
   wire         pclk23;               // apb23 clock23
   wire [15:0] 
                rdata23;              // registered output to apb23
   wire         sel23;                // apb23 peripheral23 select23
         
   //for gpio_interrupts23 
   wire [15:0] 
                gpio_interrupt_gen23;      // gpio_interrupt23 to apb23

   integer      i;                   // loop variable
                
 
    
   // assignments23 
 
   // generic23 assignments23 for the gpio23 bus 
   // variables23 starting with gpio23 are the 
   // generic23 variables23 used below23. 
   // change these23 variable to use another23 bus protocol23 
   // for the gpio23. 
 
   // inputs23  
   assign write      = pwrite23 & penable23 & psel23; 
    
   assign read       = ~(pwrite23) & ~(penable23) & psel23; 
    
   assign addr       = paddr23; 
  
   assign sel23        = psel23; 

   
   // p_map_prdata23: combinatorial23/ rdata23
   //
   // this process adds23 zeros23 to all the unused23 prdata23 lines23, 
   // according23 to the chosen23 width of the gpio23 module
   
   always @ ( rdata23 )
   begin : p_map_prdata23
      begin
         for ( i = 16; i < 32; i = i + 1 )
           prdata23[i] = 1'b0;
      end

      prdata23[15:0] = rdata23;

   end // p_map_prdata23

   assign gpio_int23 = |gpio_interrupt_gen23;

   gpio_lite_subunit23  // gpio_subunit23 module instance

   
   i_gpio_lite_subunit23 // instance name to take23 the annotated23 parameters23

// pin23 annotation23
   (
       //inputs23

       .n_reset23            (n_p_reset23),         // reset
       .pclk23               (pclk23),              // gpio23 pclk23
       .read               (read),              // select23 for gpio23
       .write              (write),             // gpio23 write
       .addr               (addr),              // address bus
       .wdata23              (pwdata23[15:0]),  
                                                 // gpio23 input
       .pin_in23             (gpio_pin_in23),        // input data from pin23
       .tri_state_enable23   (tri_state_enable23),   // disables23 op enable

       //outputs23
       .rdata23              (rdata23),              // gpio23 output
       .interrupt23          (gpio_interrupt_gen23), // gpio_interupt23
       .pin_oe_n23           (n_gpio_pin_oe23),      // output enable
       .pin_out23            (gpio_pin_out23)        // output signal23
    );

 endmodule
