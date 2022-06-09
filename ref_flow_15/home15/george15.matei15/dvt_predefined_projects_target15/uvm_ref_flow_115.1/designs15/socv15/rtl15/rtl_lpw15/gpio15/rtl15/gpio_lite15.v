//File15 name   : gpio_lite15.v
//Title15       : GPIO15 top level
//Created15     : 1999
//Description15 : A gpio15 module for use with amba15 
//                   apb15, with up to 16 io15 pins15 
//Notes15       : 
//----------------------------------------------------------------------
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------

module gpio_lite15( 
              //inputs15 
 
              n_p_reset15, 
              pclk15, 

              psel15, 
              penable15, 
              pwrite15, 
              paddr15, 
              pwdata15, 

              gpio_pin_in15, 

              scan_en15, 
              tri_state_enable15, 

              scan_in15, //added by smarkov15 for dft15
 
              //outputs15
              
              scan_out15, //added by smarkov15 for dft15 
               
              prdata15, 

              gpio_int15, 

              n_gpio_pin_oe15, 
              gpio_pin_out15 
); 
 


   // inputs15 
    
   // pclks15  
   input        n_p_reset15;            // amba15 reset 
   input        pclk15;               // peripherical15 pclk15 bus 

   // AMBA15 Rev15 2
   input        psel15;               // peripheral15 select15 for gpio15 
   input        penable15;            // peripheral15 enable 
   input        pwrite15;             // peripheral15 write strobe15 
   input [5:0] 
                paddr15;              // address bus of selected master15 
   input [31:0] 
                pwdata15;             // write data 

   // gpio15 generic15 inputs15 
   input [15:0] 
                gpio_pin_in15;             // input data from pin15 

   //design for test inputs15 
   input        scan_en15;            // enables15 shifting15 of scans15 
   input [15:0] 
                tri_state_enable15;   // disables15 op enable -> z 
   input        scan_in15;            // scan15 chain15 data input  
       
    
   // outputs15 
 
   //amba15 outputs15 
   output [31:0] 
                prdata15;             // read data 
   // gpio15 generic15 outputs15 
   output       gpio_int15;                // gpio_interupt15 for input pin15 change 
   output [15:0] 
                n_gpio_pin_oe15;           // output enable signal15 to pin15 
   output [15:0] 
                gpio_pin_out15;            // output signal15 to pin15 
                
   // scan15 outputs15
   output      scan_out15;            // scan15 chain15 data output
     
// gpio_internal15 signals15 declarations15
 
   // registers + wires15 for outputs15 
   reg  [31:0] 
                prdata15;             // registered output to apb15
   wire         gpio_int15;                // gpio_interrupt15 to apb15
   wire [15:0] 
                n_gpio_pin_oe15;           // gpio15 output enable
   wire [15:0] 
                gpio_pin_out15;            // gpio15 out
    
   // generic15 gpio15 stuff15 
   wire         write;              // apb15 register write strobe15
   wire         read;               // apb15 register read strobe15
   wire [5:0]
                addr;               // apb15 register address
   wire         n_p_reset15;            // apb15 reset
   wire         pclk15;               // apb15 clock15
   wire [15:0] 
                rdata15;              // registered output to apb15
   wire         sel15;                // apb15 peripheral15 select15
         
   //for gpio_interrupts15 
   wire [15:0] 
                gpio_interrupt_gen15;      // gpio_interrupt15 to apb15

   integer      i;                   // loop variable
                
 
    
   // assignments15 
 
   // generic15 assignments15 for the gpio15 bus 
   // variables15 starting with gpio15 are the 
   // generic15 variables15 used below15. 
   // change these15 variable to use another15 bus protocol15 
   // for the gpio15. 
 
   // inputs15  
   assign write      = pwrite15 & penable15 & psel15; 
    
   assign read       = ~(pwrite15) & ~(penable15) & psel15; 
    
   assign addr       = paddr15; 
  
   assign sel15        = psel15; 

   
   // p_map_prdata15: combinatorial15/ rdata15
   //
   // this process adds15 zeros15 to all the unused15 prdata15 lines15, 
   // according15 to the chosen15 width of the gpio15 module
   
   always @ ( rdata15 )
   begin : p_map_prdata15
      begin
         for ( i = 16; i < 32; i = i + 1 )
           prdata15[i] = 1'b0;
      end

      prdata15[15:0] = rdata15;

   end // p_map_prdata15

   assign gpio_int15 = |gpio_interrupt_gen15;

   gpio_lite_subunit15  // gpio_subunit15 module instance

   
   i_gpio_lite_subunit15 // instance name to take15 the annotated15 parameters15

// pin15 annotation15
   (
       //inputs15

       .n_reset15            (n_p_reset15),         // reset
       .pclk15               (pclk15),              // gpio15 pclk15
       .read               (read),              // select15 for gpio15
       .write              (write),             // gpio15 write
       .addr               (addr),              // address bus
       .wdata15              (pwdata15[15:0]),  
                                                 // gpio15 input
       .pin_in15             (gpio_pin_in15),        // input data from pin15
       .tri_state_enable15   (tri_state_enable15),   // disables15 op enable

       //outputs15
       .rdata15              (rdata15),              // gpio15 output
       .interrupt15          (gpio_interrupt_gen15), // gpio_interupt15
       .pin_oe_n15           (n_gpio_pin_oe15),      // output enable
       .pin_out15            (gpio_pin_out15)        // output signal15
    );

 endmodule
