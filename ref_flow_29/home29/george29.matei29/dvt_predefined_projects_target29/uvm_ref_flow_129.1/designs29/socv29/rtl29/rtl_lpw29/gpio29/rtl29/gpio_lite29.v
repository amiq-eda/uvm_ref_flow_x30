//File29 name   : gpio_lite29.v
//Title29       : GPIO29 top level
//Created29     : 1999
//Description29 : A gpio29 module for use with amba29 
//                   apb29, with up to 16 io29 pins29 
//Notes29       : 
//----------------------------------------------------------------------
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------

module gpio_lite29( 
              //inputs29 
 
              n_p_reset29, 
              pclk29, 

              psel29, 
              penable29, 
              pwrite29, 
              paddr29, 
              pwdata29, 

              gpio_pin_in29, 

              scan_en29, 
              tri_state_enable29, 

              scan_in29, //added by smarkov29 for dft29
 
              //outputs29
              
              scan_out29, //added by smarkov29 for dft29 
               
              prdata29, 

              gpio_int29, 

              n_gpio_pin_oe29, 
              gpio_pin_out29 
); 
 


   // inputs29 
    
   // pclks29  
   input        n_p_reset29;            // amba29 reset 
   input        pclk29;               // peripherical29 pclk29 bus 

   // AMBA29 Rev29 2
   input        psel29;               // peripheral29 select29 for gpio29 
   input        penable29;            // peripheral29 enable 
   input        pwrite29;             // peripheral29 write strobe29 
   input [5:0] 
                paddr29;              // address bus of selected master29 
   input [31:0] 
                pwdata29;             // write data 

   // gpio29 generic29 inputs29 
   input [15:0] 
                gpio_pin_in29;             // input data from pin29 

   //design for test inputs29 
   input        scan_en29;            // enables29 shifting29 of scans29 
   input [15:0] 
                tri_state_enable29;   // disables29 op enable -> z 
   input        scan_in29;            // scan29 chain29 data input  
       
    
   // outputs29 
 
   //amba29 outputs29 
   output [31:0] 
                prdata29;             // read data 
   // gpio29 generic29 outputs29 
   output       gpio_int29;                // gpio_interupt29 for input pin29 change 
   output [15:0] 
                n_gpio_pin_oe29;           // output enable signal29 to pin29 
   output [15:0] 
                gpio_pin_out29;            // output signal29 to pin29 
                
   // scan29 outputs29
   output      scan_out29;            // scan29 chain29 data output
     
// gpio_internal29 signals29 declarations29
 
   // registers + wires29 for outputs29 
   reg  [31:0] 
                prdata29;             // registered output to apb29
   wire         gpio_int29;                // gpio_interrupt29 to apb29
   wire [15:0] 
                n_gpio_pin_oe29;           // gpio29 output enable
   wire [15:0] 
                gpio_pin_out29;            // gpio29 out
    
   // generic29 gpio29 stuff29 
   wire         write;              // apb29 register write strobe29
   wire         read;               // apb29 register read strobe29
   wire [5:0]
                addr;               // apb29 register address
   wire         n_p_reset29;            // apb29 reset
   wire         pclk29;               // apb29 clock29
   wire [15:0] 
                rdata29;              // registered output to apb29
   wire         sel29;                // apb29 peripheral29 select29
         
   //for gpio_interrupts29 
   wire [15:0] 
                gpio_interrupt_gen29;      // gpio_interrupt29 to apb29

   integer      i;                   // loop variable
                
 
    
   // assignments29 
 
   // generic29 assignments29 for the gpio29 bus 
   // variables29 starting with gpio29 are the 
   // generic29 variables29 used below29. 
   // change these29 variable to use another29 bus protocol29 
   // for the gpio29. 
 
   // inputs29  
   assign write      = pwrite29 & penable29 & psel29; 
    
   assign read       = ~(pwrite29) & ~(penable29) & psel29; 
    
   assign addr       = paddr29; 
  
   assign sel29        = psel29; 

   
   // p_map_prdata29: combinatorial29/ rdata29
   //
   // this process adds29 zeros29 to all the unused29 prdata29 lines29, 
   // according29 to the chosen29 width of the gpio29 module
   
   always @ ( rdata29 )
   begin : p_map_prdata29
      begin
         for ( i = 16; i < 32; i = i + 1 )
           prdata29[i] = 1'b0;
      end

      prdata29[15:0] = rdata29;

   end // p_map_prdata29

   assign gpio_int29 = |gpio_interrupt_gen29;

   gpio_lite_subunit29  // gpio_subunit29 module instance

   
   i_gpio_lite_subunit29 // instance name to take29 the annotated29 parameters29

// pin29 annotation29
   (
       //inputs29

       .n_reset29            (n_p_reset29),         // reset
       .pclk29               (pclk29),              // gpio29 pclk29
       .read               (read),              // select29 for gpio29
       .write              (write),             // gpio29 write
       .addr               (addr),              // address bus
       .wdata29              (pwdata29[15:0]),  
                                                 // gpio29 input
       .pin_in29             (gpio_pin_in29),        // input data from pin29
       .tri_state_enable29   (tri_state_enable29),   // disables29 op enable

       //outputs29
       .rdata29              (rdata29),              // gpio29 output
       .interrupt29          (gpio_interrupt_gen29), // gpio_interupt29
       .pin_oe_n29           (n_gpio_pin_oe29),      // output enable
       .pin_out29            (gpio_pin_out29)        // output signal29
    );

 endmodule
