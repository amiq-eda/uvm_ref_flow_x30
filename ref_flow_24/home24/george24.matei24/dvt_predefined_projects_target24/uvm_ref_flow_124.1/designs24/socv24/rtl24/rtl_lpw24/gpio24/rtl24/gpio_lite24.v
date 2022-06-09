//File24 name   : gpio_lite24.v
//Title24       : GPIO24 top level
//Created24     : 1999
//Description24 : A gpio24 module for use with amba24 
//                   apb24, with up to 16 io24 pins24 
//Notes24       : 
//----------------------------------------------------------------------
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------

module gpio_lite24( 
              //inputs24 
 
              n_p_reset24, 
              pclk24, 

              psel24, 
              penable24, 
              pwrite24, 
              paddr24, 
              pwdata24, 

              gpio_pin_in24, 

              scan_en24, 
              tri_state_enable24, 

              scan_in24, //added by smarkov24 for dft24
 
              //outputs24
              
              scan_out24, //added by smarkov24 for dft24 
               
              prdata24, 

              gpio_int24, 

              n_gpio_pin_oe24, 
              gpio_pin_out24 
); 
 


   // inputs24 
    
   // pclks24  
   input        n_p_reset24;            // amba24 reset 
   input        pclk24;               // peripherical24 pclk24 bus 

   // AMBA24 Rev24 2
   input        psel24;               // peripheral24 select24 for gpio24 
   input        penable24;            // peripheral24 enable 
   input        pwrite24;             // peripheral24 write strobe24 
   input [5:0] 
                paddr24;              // address bus of selected master24 
   input [31:0] 
                pwdata24;             // write data 

   // gpio24 generic24 inputs24 
   input [15:0] 
                gpio_pin_in24;             // input data from pin24 

   //design for test inputs24 
   input        scan_en24;            // enables24 shifting24 of scans24 
   input [15:0] 
                tri_state_enable24;   // disables24 op enable -> z 
   input        scan_in24;            // scan24 chain24 data input  
       
    
   // outputs24 
 
   //amba24 outputs24 
   output [31:0] 
                prdata24;             // read data 
   // gpio24 generic24 outputs24 
   output       gpio_int24;                // gpio_interupt24 for input pin24 change 
   output [15:0] 
                n_gpio_pin_oe24;           // output enable signal24 to pin24 
   output [15:0] 
                gpio_pin_out24;            // output signal24 to pin24 
                
   // scan24 outputs24
   output      scan_out24;            // scan24 chain24 data output
     
// gpio_internal24 signals24 declarations24
 
   // registers + wires24 for outputs24 
   reg  [31:0] 
                prdata24;             // registered output to apb24
   wire         gpio_int24;                // gpio_interrupt24 to apb24
   wire [15:0] 
                n_gpio_pin_oe24;           // gpio24 output enable
   wire [15:0] 
                gpio_pin_out24;            // gpio24 out
    
   // generic24 gpio24 stuff24 
   wire         write;              // apb24 register write strobe24
   wire         read;               // apb24 register read strobe24
   wire [5:0]
                addr;               // apb24 register address
   wire         n_p_reset24;            // apb24 reset
   wire         pclk24;               // apb24 clock24
   wire [15:0] 
                rdata24;              // registered output to apb24
   wire         sel24;                // apb24 peripheral24 select24
         
   //for gpio_interrupts24 
   wire [15:0] 
                gpio_interrupt_gen24;      // gpio_interrupt24 to apb24

   integer      i;                   // loop variable
                
 
    
   // assignments24 
 
   // generic24 assignments24 for the gpio24 bus 
   // variables24 starting with gpio24 are the 
   // generic24 variables24 used below24. 
   // change these24 variable to use another24 bus protocol24 
   // for the gpio24. 
 
   // inputs24  
   assign write      = pwrite24 & penable24 & psel24; 
    
   assign read       = ~(pwrite24) & ~(penable24) & psel24; 
    
   assign addr       = paddr24; 
  
   assign sel24        = psel24; 

   
   // p_map_prdata24: combinatorial24/ rdata24
   //
   // this process adds24 zeros24 to all the unused24 prdata24 lines24, 
   // according24 to the chosen24 width of the gpio24 module
   
   always @ ( rdata24 )
   begin : p_map_prdata24
      begin
         for ( i = 16; i < 32; i = i + 1 )
           prdata24[i] = 1'b0;
      end

      prdata24[15:0] = rdata24;

   end // p_map_prdata24

   assign gpio_int24 = |gpio_interrupt_gen24;

   gpio_lite_subunit24  // gpio_subunit24 module instance

   
   i_gpio_lite_subunit24 // instance name to take24 the annotated24 parameters24

// pin24 annotation24
   (
       //inputs24

       .n_reset24            (n_p_reset24),         // reset
       .pclk24               (pclk24),              // gpio24 pclk24
       .read               (read),              // select24 for gpio24
       .write              (write),             // gpio24 write
       .addr               (addr),              // address bus
       .wdata24              (pwdata24[15:0]),  
                                                 // gpio24 input
       .pin_in24             (gpio_pin_in24),        // input data from pin24
       .tri_state_enable24   (tri_state_enable24),   // disables24 op enable

       //outputs24
       .rdata24              (rdata24),              // gpio24 output
       .interrupt24          (gpio_interrupt_gen24), // gpio_interupt24
       .pin_oe_n24           (n_gpio_pin_oe24),      // output enable
       .pin_out24            (gpio_pin_out24)        // output signal24
    );

 endmodule
