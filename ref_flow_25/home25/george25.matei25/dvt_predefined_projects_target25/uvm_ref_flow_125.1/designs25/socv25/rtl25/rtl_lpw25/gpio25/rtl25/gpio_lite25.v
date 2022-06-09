//File25 name   : gpio_lite25.v
//Title25       : GPIO25 top level
//Created25     : 1999
//Description25 : A gpio25 module for use with amba25 
//                   apb25, with up to 16 io25 pins25 
//Notes25       : 
//----------------------------------------------------------------------
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------

module gpio_lite25( 
              //inputs25 
 
              n_p_reset25, 
              pclk25, 

              psel25, 
              penable25, 
              pwrite25, 
              paddr25, 
              pwdata25, 

              gpio_pin_in25, 

              scan_en25, 
              tri_state_enable25, 

              scan_in25, //added by smarkov25 for dft25
 
              //outputs25
              
              scan_out25, //added by smarkov25 for dft25 
               
              prdata25, 

              gpio_int25, 

              n_gpio_pin_oe25, 
              gpio_pin_out25 
); 
 


   // inputs25 
    
   // pclks25  
   input        n_p_reset25;            // amba25 reset 
   input        pclk25;               // peripherical25 pclk25 bus 

   // AMBA25 Rev25 2
   input        psel25;               // peripheral25 select25 for gpio25 
   input        penable25;            // peripheral25 enable 
   input        pwrite25;             // peripheral25 write strobe25 
   input [5:0] 
                paddr25;              // address bus of selected master25 
   input [31:0] 
                pwdata25;             // write data 

   // gpio25 generic25 inputs25 
   input [15:0] 
                gpio_pin_in25;             // input data from pin25 

   //design for test inputs25 
   input        scan_en25;            // enables25 shifting25 of scans25 
   input [15:0] 
                tri_state_enable25;   // disables25 op enable -> z 
   input        scan_in25;            // scan25 chain25 data input  
       
    
   // outputs25 
 
   //amba25 outputs25 
   output [31:0] 
                prdata25;             // read data 
   // gpio25 generic25 outputs25 
   output       gpio_int25;                // gpio_interupt25 for input pin25 change 
   output [15:0] 
                n_gpio_pin_oe25;           // output enable signal25 to pin25 
   output [15:0] 
                gpio_pin_out25;            // output signal25 to pin25 
                
   // scan25 outputs25
   output      scan_out25;            // scan25 chain25 data output
     
// gpio_internal25 signals25 declarations25
 
   // registers + wires25 for outputs25 
   reg  [31:0] 
                prdata25;             // registered output to apb25
   wire         gpio_int25;                // gpio_interrupt25 to apb25
   wire [15:0] 
                n_gpio_pin_oe25;           // gpio25 output enable
   wire [15:0] 
                gpio_pin_out25;            // gpio25 out
    
   // generic25 gpio25 stuff25 
   wire         write;              // apb25 register write strobe25
   wire         read;               // apb25 register read strobe25
   wire [5:0]
                addr;               // apb25 register address
   wire         n_p_reset25;            // apb25 reset
   wire         pclk25;               // apb25 clock25
   wire [15:0] 
                rdata25;              // registered output to apb25
   wire         sel25;                // apb25 peripheral25 select25
         
   //for gpio_interrupts25 
   wire [15:0] 
                gpio_interrupt_gen25;      // gpio_interrupt25 to apb25

   integer      i;                   // loop variable
                
 
    
   // assignments25 
 
   // generic25 assignments25 for the gpio25 bus 
   // variables25 starting with gpio25 are the 
   // generic25 variables25 used below25. 
   // change these25 variable to use another25 bus protocol25 
   // for the gpio25. 
 
   // inputs25  
   assign write      = pwrite25 & penable25 & psel25; 
    
   assign read       = ~(pwrite25) & ~(penable25) & psel25; 
    
   assign addr       = paddr25; 
  
   assign sel25        = psel25; 

   
   // p_map_prdata25: combinatorial25/ rdata25
   //
   // this process adds25 zeros25 to all the unused25 prdata25 lines25, 
   // according25 to the chosen25 width of the gpio25 module
   
   always @ ( rdata25 )
   begin : p_map_prdata25
      begin
         for ( i = 16; i < 32; i = i + 1 )
           prdata25[i] = 1'b0;
      end

      prdata25[15:0] = rdata25;

   end // p_map_prdata25

   assign gpio_int25 = |gpio_interrupt_gen25;

   gpio_lite_subunit25  // gpio_subunit25 module instance

   
   i_gpio_lite_subunit25 // instance name to take25 the annotated25 parameters25

// pin25 annotation25
   (
       //inputs25

       .n_reset25            (n_p_reset25),         // reset
       .pclk25               (pclk25),              // gpio25 pclk25
       .read               (read),              // select25 for gpio25
       .write              (write),             // gpio25 write
       .addr               (addr),              // address bus
       .wdata25              (pwdata25[15:0]),  
                                                 // gpio25 input
       .pin_in25             (gpio_pin_in25),        // input data from pin25
       .tri_state_enable25   (tri_state_enable25),   // disables25 op enable

       //outputs25
       .rdata25              (rdata25),              // gpio25 output
       .interrupt25          (gpio_interrupt_gen25), // gpio_interupt25
       .pin_oe_n25           (n_gpio_pin_oe25),      // output enable
       .pin_out25            (gpio_pin_out25)        // output signal25
    );

 endmodule
