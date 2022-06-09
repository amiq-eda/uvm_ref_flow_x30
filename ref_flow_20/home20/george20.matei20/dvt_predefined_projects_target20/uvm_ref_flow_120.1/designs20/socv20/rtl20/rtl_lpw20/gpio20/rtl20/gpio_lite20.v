//File20 name   : gpio_lite20.v
//Title20       : GPIO20 top level
//Created20     : 1999
//Description20 : A gpio20 module for use with amba20 
//                   apb20, with up to 16 io20 pins20 
//Notes20       : 
//----------------------------------------------------------------------
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------

module gpio_lite20( 
              //inputs20 
 
              n_p_reset20, 
              pclk20, 

              psel20, 
              penable20, 
              pwrite20, 
              paddr20, 
              pwdata20, 

              gpio_pin_in20, 

              scan_en20, 
              tri_state_enable20, 

              scan_in20, //added by smarkov20 for dft20
 
              //outputs20
              
              scan_out20, //added by smarkov20 for dft20 
               
              prdata20, 

              gpio_int20, 

              n_gpio_pin_oe20, 
              gpio_pin_out20 
); 
 


   // inputs20 
    
   // pclks20  
   input        n_p_reset20;            // amba20 reset 
   input        pclk20;               // peripherical20 pclk20 bus 

   // AMBA20 Rev20 2
   input        psel20;               // peripheral20 select20 for gpio20 
   input        penable20;            // peripheral20 enable 
   input        pwrite20;             // peripheral20 write strobe20 
   input [5:0] 
                paddr20;              // address bus of selected master20 
   input [31:0] 
                pwdata20;             // write data 

   // gpio20 generic20 inputs20 
   input [15:0] 
                gpio_pin_in20;             // input data from pin20 

   //design for test inputs20 
   input        scan_en20;            // enables20 shifting20 of scans20 
   input [15:0] 
                tri_state_enable20;   // disables20 op enable -> z 
   input        scan_in20;            // scan20 chain20 data input  
       
    
   // outputs20 
 
   //amba20 outputs20 
   output [31:0] 
                prdata20;             // read data 
   // gpio20 generic20 outputs20 
   output       gpio_int20;                // gpio_interupt20 for input pin20 change 
   output [15:0] 
                n_gpio_pin_oe20;           // output enable signal20 to pin20 
   output [15:0] 
                gpio_pin_out20;            // output signal20 to pin20 
                
   // scan20 outputs20
   output      scan_out20;            // scan20 chain20 data output
     
// gpio_internal20 signals20 declarations20
 
   // registers + wires20 for outputs20 
   reg  [31:0] 
                prdata20;             // registered output to apb20
   wire         gpio_int20;                // gpio_interrupt20 to apb20
   wire [15:0] 
                n_gpio_pin_oe20;           // gpio20 output enable
   wire [15:0] 
                gpio_pin_out20;            // gpio20 out
    
   // generic20 gpio20 stuff20 
   wire         write;              // apb20 register write strobe20
   wire         read;               // apb20 register read strobe20
   wire [5:0]
                addr;               // apb20 register address
   wire         n_p_reset20;            // apb20 reset
   wire         pclk20;               // apb20 clock20
   wire [15:0] 
                rdata20;              // registered output to apb20
   wire         sel20;                // apb20 peripheral20 select20
         
   //for gpio_interrupts20 
   wire [15:0] 
                gpio_interrupt_gen20;      // gpio_interrupt20 to apb20

   integer      i;                   // loop variable
                
 
    
   // assignments20 
 
   // generic20 assignments20 for the gpio20 bus 
   // variables20 starting with gpio20 are the 
   // generic20 variables20 used below20. 
   // change these20 variable to use another20 bus protocol20 
   // for the gpio20. 
 
   // inputs20  
   assign write      = pwrite20 & penable20 & psel20; 
    
   assign read       = ~(pwrite20) & ~(penable20) & psel20; 
    
   assign addr       = paddr20; 
  
   assign sel20        = psel20; 

   
   // p_map_prdata20: combinatorial20/ rdata20
   //
   // this process adds20 zeros20 to all the unused20 prdata20 lines20, 
   // according20 to the chosen20 width of the gpio20 module
   
   always @ ( rdata20 )
   begin : p_map_prdata20
      begin
         for ( i = 16; i < 32; i = i + 1 )
           prdata20[i] = 1'b0;
      end

      prdata20[15:0] = rdata20;

   end // p_map_prdata20

   assign gpio_int20 = |gpio_interrupt_gen20;

   gpio_lite_subunit20  // gpio_subunit20 module instance

   
   i_gpio_lite_subunit20 // instance name to take20 the annotated20 parameters20

// pin20 annotation20
   (
       //inputs20

       .n_reset20            (n_p_reset20),         // reset
       .pclk20               (pclk20),              // gpio20 pclk20
       .read               (read),              // select20 for gpio20
       .write              (write),             // gpio20 write
       .addr               (addr),              // address bus
       .wdata20              (pwdata20[15:0]),  
                                                 // gpio20 input
       .pin_in20             (gpio_pin_in20),        // input data from pin20
       .tri_state_enable20   (tri_state_enable20),   // disables20 op enable

       //outputs20
       .rdata20              (rdata20),              // gpio20 output
       .interrupt20          (gpio_interrupt_gen20), // gpio_interupt20
       .pin_oe_n20           (n_gpio_pin_oe20),      // output enable
       .pin_out20            (gpio_pin_out20)        // output signal20
    );

 endmodule
