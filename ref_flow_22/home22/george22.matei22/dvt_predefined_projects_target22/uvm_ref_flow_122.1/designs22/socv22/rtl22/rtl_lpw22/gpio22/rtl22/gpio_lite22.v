//File22 name   : gpio_lite22.v
//Title22       : GPIO22 top level
//Created22     : 1999
//Description22 : A gpio22 module for use with amba22 
//                   apb22, with up to 16 io22 pins22 
//Notes22       : 
//----------------------------------------------------------------------
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------

module gpio_lite22( 
              //inputs22 
 
              n_p_reset22, 
              pclk22, 

              psel22, 
              penable22, 
              pwrite22, 
              paddr22, 
              pwdata22, 

              gpio_pin_in22, 

              scan_en22, 
              tri_state_enable22, 

              scan_in22, //added by smarkov22 for dft22
 
              //outputs22
              
              scan_out22, //added by smarkov22 for dft22 
               
              prdata22, 

              gpio_int22, 

              n_gpio_pin_oe22, 
              gpio_pin_out22 
); 
 


   // inputs22 
    
   // pclks22  
   input        n_p_reset22;            // amba22 reset 
   input        pclk22;               // peripherical22 pclk22 bus 

   // AMBA22 Rev22 2
   input        psel22;               // peripheral22 select22 for gpio22 
   input        penable22;            // peripheral22 enable 
   input        pwrite22;             // peripheral22 write strobe22 
   input [5:0] 
                paddr22;              // address bus of selected master22 
   input [31:0] 
                pwdata22;             // write data 

   // gpio22 generic22 inputs22 
   input [15:0] 
                gpio_pin_in22;             // input data from pin22 

   //design for test inputs22 
   input        scan_en22;            // enables22 shifting22 of scans22 
   input [15:0] 
                tri_state_enable22;   // disables22 op enable -> z 
   input        scan_in22;            // scan22 chain22 data input  
       
    
   // outputs22 
 
   //amba22 outputs22 
   output [31:0] 
                prdata22;             // read data 
   // gpio22 generic22 outputs22 
   output       gpio_int22;                // gpio_interupt22 for input pin22 change 
   output [15:0] 
                n_gpio_pin_oe22;           // output enable signal22 to pin22 
   output [15:0] 
                gpio_pin_out22;            // output signal22 to pin22 
                
   // scan22 outputs22
   output      scan_out22;            // scan22 chain22 data output
     
// gpio_internal22 signals22 declarations22
 
   // registers + wires22 for outputs22 
   reg  [31:0] 
                prdata22;             // registered output to apb22
   wire         gpio_int22;                // gpio_interrupt22 to apb22
   wire [15:0] 
                n_gpio_pin_oe22;           // gpio22 output enable
   wire [15:0] 
                gpio_pin_out22;            // gpio22 out
    
   // generic22 gpio22 stuff22 
   wire         write;              // apb22 register write strobe22
   wire         read;               // apb22 register read strobe22
   wire [5:0]
                addr;               // apb22 register address
   wire         n_p_reset22;            // apb22 reset
   wire         pclk22;               // apb22 clock22
   wire [15:0] 
                rdata22;              // registered output to apb22
   wire         sel22;                // apb22 peripheral22 select22
         
   //for gpio_interrupts22 
   wire [15:0] 
                gpio_interrupt_gen22;      // gpio_interrupt22 to apb22

   integer      i;                   // loop variable
                
 
    
   // assignments22 
 
   // generic22 assignments22 for the gpio22 bus 
   // variables22 starting with gpio22 are the 
   // generic22 variables22 used below22. 
   // change these22 variable to use another22 bus protocol22 
   // for the gpio22. 
 
   // inputs22  
   assign write      = pwrite22 & penable22 & psel22; 
    
   assign read       = ~(pwrite22) & ~(penable22) & psel22; 
    
   assign addr       = paddr22; 
  
   assign sel22        = psel22; 

   
   // p_map_prdata22: combinatorial22/ rdata22
   //
   // this process adds22 zeros22 to all the unused22 prdata22 lines22, 
   // according22 to the chosen22 width of the gpio22 module
   
   always @ ( rdata22 )
   begin : p_map_prdata22
      begin
         for ( i = 16; i < 32; i = i + 1 )
           prdata22[i] = 1'b0;
      end

      prdata22[15:0] = rdata22;

   end // p_map_prdata22

   assign gpio_int22 = |gpio_interrupt_gen22;

   gpio_lite_subunit22  // gpio_subunit22 module instance

   
   i_gpio_lite_subunit22 // instance name to take22 the annotated22 parameters22

// pin22 annotation22
   (
       //inputs22

       .n_reset22            (n_p_reset22),         // reset
       .pclk22               (pclk22),              // gpio22 pclk22
       .read               (read),              // select22 for gpio22
       .write              (write),             // gpio22 write
       .addr               (addr),              // address bus
       .wdata22              (pwdata22[15:0]),  
                                                 // gpio22 input
       .pin_in22             (gpio_pin_in22),        // input data from pin22
       .tri_state_enable22   (tri_state_enable22),   // disables22 op enable

       //outputs22
       .rdata22              (rdata22),              // gpio22 output
       .interrupt22          (gpio_interrupt_gen22), // gpio_interupt22
       .pin_oe_n22           (n_gpio_pin_oe22),      // output enable
       .pin_out22            (gpio_pin_out22)        // output signal22
    );

 endmodule
