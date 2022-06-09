//File26 name   : gpio_lite26.v
//Title26       : GPIO26 top level
//Created26     : 1999
//Description26 : A gpio26 module for use with amba26 
//                   apb26, with up to 16 io26 pins26 
//Notes26       : 
//----------------------------------------------------------------------
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------

module gpio_lite26( 
              //inputs26 
 
              n_p_reset26, 
              pclk26, 

              psel26, 
              penable26, 
              pwrite26, 
              paddr26, 
              pwdata26, 

              gpio_pin_in26, 

              scan_en26, 
              tri_state_enable26, 

              scan_in26, //added by smarkov26 for dft26
 
              //outputs26
              
              scan_out26, //added by smarkov26 for dft26 
               
              prdata26, 

              gpio_int26, 

              n_gpio_pin_oe26, 
              gpio_pin_out26 
); 
 


   // inputs26 
    
   // pclks26  
   input        n_p_reset26;            // amba26 reset 
   input        pclk26;               // peripherical26 pclk26 bus 

   // AMBA26 Rev26 2
   input        psel26;               // peripheral26 select26 for gpio26 
   input        penable26;            // peripheral26 enable 
   input        pwrite26;             // peripheral26 write strobe26 
   input [5:0] 
                paddr26;              // address bus of selected master26 
   input [31:0] 
                pwdata26;             // write data 

   // gpio26 generic26 inputs26 
   input [15:0] 
                gpio_pin_in26;             // input data from pin26 

   //design for test inputs26 
   input        scan_en26;            // enables26 shifting26 of scans26 
   input [15:0] 
                tri_state_enable26;   // disables26 op enable -> z 
   input        scan_in26;            // scan26 chain26 data input  
       
    
   // outputs26 
 
   //amba26 outputs26 
   output [31:0] 
                prdata26;             // read data 
   // gpio26 generic26 outputs26 
   output       gpio_int26;                // gpio_interupt26 for input pin26 change 
   output [15:0] 
                n_gpio_pin_oe26;           // output enable signal26 to pin26 
   output [15:0] 
                gpio_pin_out26;            // output signal26 to pin26 
                
   // scan26 outputs26
   output      scan_out26;            // scan26 chain26 data output
     
// gpio_internal26 signals26 declarations26
 
   // registers + wires26 for outputs26 
   reg  [31:0] 
                prdata26;             // registered output to apb26
   wire         gpio_int26;                // gpio_interrupt26 to apb26
   wire [15:0] 
                n_gpio_pin_oe26;           // gpio26 output enable
   wire [15:0] 
                gpio_pin_out26;            // gpio26 out
    
   // generic26 gpio26 stuff26 
   wire         write;              // apb26 register write strobe26
   wire         read;               // apb26 register read strobe26
   wire [5:0]
                addr;               // apb26 register address
   wire         n_p_reset26;            // apb26 reset
   wire         pclk26;               // apb26 clock26
   wire [15:0] 
                rdata26;              // registered output to apb26
   wire         sel26;                // apb26 peripheral26 select26
         
   //for gpio_interrupts26 
   wire [15:0] 
                gpio_interrupt_gen26;      // gpio_interrupt26 to apb26

   integer      i;                   // loop variable
                
 
    
   // assignments26 
 
   // generic26 assignments26 for the gpio26 bus 
   // variables26 starting with gpio26 are the 
   // generic26 variables26 used below26. 
   // change these26 variable to use another26 bus protocol26 
   // for the gpio26. 
 
   // inputs26  
   assign write      = pwrite26 & penable26 & psel26; 
    
   assign read       = ~(pwrite26) & ~(penable26) & psel26; 
    
   assign addr       = paddr26; 
  
   assign sel26        = psel26; 

   
   // p_map_prdata26: combinatorial26/ rdata26
   //
   // this process adds26 zeros26 to all the unused26 prdata26 lines26, 
   // according26 to the chosen26 width of the gpio26 module
   
   always @ ( rdata26 )
   begin : p_map_prdata26
      begin
         for ( i = 16; i < 32; i = i + 1 )
           prdata26[i] = 1'b0;
      end

      prdata26[15:0] = rdata26;

   end // p_map_prdata26

   assign gpio_int26 = |gpio_interrupt_gen26;

   gpio_lite_subunit26  // gpio_subunit26 module instance

   
   i_gpio_lite_subunit26 // instance name to take26 the annotated26 parameters26

// pin26 annotation26
   (
       //inputs26

       .n_reset26            (n_p_reset26),         // reset
       .pclk26               (pclk26),              // gpio26 pclk26
       .read               (read),              // select26 for gpio26
       .write              (write),             // gpio26 write
       .addr               (addr),              // address bus
       .wdata26              (pwdata26[15:0]),  
                                                 // gpio26 input
       .pin_in26             (gpio_pin_in26),        // input data from pin26
       .tri_state_enable26   (tri_state_enable26),   // disables26 op enable

       //outputs26
       .rdata26              (rdata26),              // gpio26 output
       .interrupt26          (gpio_interrupt_gen26), // gpio_interupt26
       .pin_oe_n26           (n_gpio_pin_oe26),      // output enable
       .pin_out26            (gpio_pin_out26)        // output signal26
    );

 endmodule
