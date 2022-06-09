//File17 name   : gpio_lite17.v
//Title17       : GPIO17 top level
//Created17     : 1999
//Description17 : A gpio17 module for use with amba17 
//                   apb17, with up to 16 io17 pins17 
//Notes17       : 
//----------------------------------------------------------------------
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------

module gpio_lite17( 
              //inputs17 
 
              n_p_reset17, 
              pclk17, 

              psel17, 
              penable17, 
              pwrite17, 
              paddr17, 
              pwdata17, 

              gpio_pin_in17, 

              scan_en17, 
              tri_state_enable17, 

              scan_in17, //added by smarkov17 for dft17
 
              //outputs17
              
              scan_out17, //added by smarkov17 for dft17 
               
              prdata17, 

              gpio_int17, 

              n_gpio_pin_oe17, 
              gpio_pin_out17 
); 
 


   // inputs17 
    
   // pclks17  
   input        n_p_reset17;            // amba17 reset 
   input        pclk17;               // peripherical17 pclk17 bus 

   // AMBA17 Rev17 2
   input        psel17;               // peripheral17 select17 for gpio17 
   input        penable17;            // peripheral17 enable 
   input        pwrite17;             // peripheral17 write strobe17 
   input [5:0] 
                paddr17;              // address bus of selected master17 
   input [31:0] 
                pwdata17;             // write data 

   // gpio17 generic17 inputs17 
   input [15:0] 
                gpio_pin_in17;             // input data from pin17 

   //design for test inputs17 
   input        scan_en17;            // enables17 shifting17 of scans17 
   input [15:0] 
                tri_state_enable17;   // disables17 op enable -> z 
   input        scan_in17;            // scan17 chain17 data input  
       
    
   // outputs17 
 
   //amba17 outputs17 
   output [31:0] 
                prdata17;             // read data 
   // gpio17 generic17 outputs17 
   output       gpio_int17;                // gpio_interupt17 for input pin17 change 
   output [15:0] 
                n_gpio_pin_oe17;           // output enable signal17 to pin17 
   output [15:0] 
                gpio_pin_out17;            // output signal17 to pin17 
                
   // scan17 outputs17
   output      scan_out17;            // scan17 chain17 data output
     
// gpio_internal17 signals17 declarations17
 
   // registers + wires17 for outputs17 
   reg  [31:0] 
                prdata17;             // registered output to apb17
   wire         gpio_int17;                // gpio_interrupt17 to apb17
   wire [15:0] 
                n_gpio_pin_oe17;           // gpio17 output enable
   wire [15:0] 
                gpio_pin_out17;            // gpio17 out
    
   // generic17 gpio17 stuff17 
   wire         write;              // apb17 register write strobe17
   wire         read;               // apb17 register read strobe17
   wire [5:0]
                addr;               // apb17 register address
   wire         n_p_reset17;            // apb17 reset
   wire         pclk17;               // apb17 clock17
   wire [15:0] 
                rdata17;              // registered output to apb17
   wire         sel17;                // apb17 peripheral17 select17
         
   //for gpio_interrupts17 
   wire [15:0] 
                gpio_interrupt_gen17;      // gpio_interrupt17 to apb17

   integer      i;                   // loop variable
                
 
    
   // assignments17 
 
   // generic17 assignments17 for the gpio17 bus 
   // variables17 starting with gpio17 are the 
   // generic17 variables17 used below17. 
   // change these17 variable to use another17 bus protocol17 
   // for the gpio17. 
 
   // inputs17  
   assign write      = pwrite17 & penable17 & psel17; 
    
   assign read       = ~(pwrite17) & ~(penable17) & psel17; 
    
   assign addr       = paddr17; 
  
   assign sel17        = psel17; 

   
   // p_map_prdata17: combinatorial17/ rdata17
   //
   // this process adds17 zeros17 to all the unused17 prdata17 lines17, 
   // according17 to the chosen17 width of the gpio17 module
   
   always @ ( rdata17 )
   begin : p_map_prdata17
      begin
         for ( i = 16; i < 32; i = i + 1 )
           prdata17[i] = 1'b0;
      end

      prdata17[15:0] = rdata17;

   end // p_map_prdata17

   assign gpio_int17 = |gpio_interrupt_gen17;

   gpio_lite_subunit17  // gpio_subunit17 module instance

   
   i_gpio_lite_subunit17 // instance name to take17 the annotated17 parameters17

// pin17 annotation17
   (
       //inputs17

       .n_reset17            (n_p_reset17),         // reset
       .pclk17               (pclk17),              // gpio17 pclk17
       .read               (read),              // select17 for gpio17
       .write              (write),             // gpio17 write
       .addr               (addr),              // address bus
       .wdata17              (pwdata17[15:0]),  
                                                 // gpio17 input
       .pin_in17             (gpio_pin_in17),        // input data from pin17
       .tri_state_enable17   (tri_state_enable17),   // disables17 op enable

       //outputs17
       .rdata17              (rdata17),              // gpio17 output
       .interrupt17          (gpio_interrupt_gen17), // gpio_interupt17
       .pin_oe_n17           (n_gpio_pin_oe17),      // output enable
       .pin_out17            (gpio_pin_out17)        // output signal17
    );

 endmodule
