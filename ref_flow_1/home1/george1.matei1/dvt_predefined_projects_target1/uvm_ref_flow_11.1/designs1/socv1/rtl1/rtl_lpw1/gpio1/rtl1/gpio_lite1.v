//File1 name   : gpio_lite1.v
//Title1       : GPIO1 top level
//Created1     : 1999
//Description1 : A gpio1 module for use with amba1 
//                   apb1, with up to 16 io1 pins1 
//Notes1       : 
//----------------------------------------------------------------------
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------

module gpio_lite1( 
              //inputs1 
 
              n_p_reset1, 
              pclk1, 

              psel1, 
              penable1, 
              pwrite1, 
              paddr1, 
              pwdata1, 

              gpio_pin_in1, 

              scan_en1, 
              tri_state_enable1, 

              scan_in1, //added by smarkov1 for dft1
 
              //outputs1
              
              scan_out1, //added by smarkov1 for dft1 
               
              prdata1, 

              gpio_int1, 

              n_gpio_pin_oe1, 
              gpio_pin_out1 
); 
 


   // inputs1 
    
   // pclks1  
   input        n_p_reset1;            // amba1 reset 
   input        pclk1;               // peripherical1 pclk1 bus 

   // AMBA1 Rev1 2
   input        psel1;               // peripheral1 select1 for gpio1 
   input        penable1;            // peripheral1 enable 
   input        pwrite1;             // peripheral1 write strobe1 
   input [5:0] 
                paddr1;              // address bus of selected master1 
   input [31:0] 
                pwdata1;             // write data 

   // gpio1 generic1 inputs1 
   input [15:0] 
                gpio_pin_in1;             // input data from pin1 

   //design for test inputs1 
   input        scan_en1;            // enables1 shifting1 of scans1 
   input [15:0] 
                tri_state_enable1;   // disables1 op enable -> z 
   input        scan_in1;            // scan1 chain1 data input  
       
    
   // outputs1 
 
   //amba1 outputs1 
   output [31:0] 
                prdata1;             // read data 
   // gpio1 generic1 outputs1 
   output       gpio_int1;                // gpio_interupt1 for input pin1 change 
   output [15:0] 
                n_gpio_pin_oe1;           // output enable signal1 to pin1 
   output [15:0] 
                gpio_pin_out1;            // output signal1 to pin1 
                
   // scan1 outputs1
   output      scan_out1;            // scan1 chain1 data output
     
// gpio_internal1 signals1 declarations1
 
   // registers + wires1 for outputs1 
   reg  [31:0] 
                prdata1;             // registered output to apb1
   wire         gpio_int1;                // gpio_interrupt1 to apb1
   wire [15:0] 
                n_gpio_pin_oe1;           // gpio1 output enable
   wire [15:0] 
                gpio_pin_out1;            // gpio1 out
    
   // generic1 gpio1 stuff1 
   wire         write;              // apb1 register write strobe1
   wire         read;               // apb1 register read strobe1
   wire [5:0]
                addr;               // apb1 register address
   wire         n_p_reset1;            // apb1 reset
   wire         pclk1;               // apb1 clock1
   wire [15:0] 
                rdata1;              // registered output to apb1
   wire         sel1;                // apb1 peripheral1 select1
         
   //for gpio_interrupts1 
   wire [15:0] 
                gpio_interrupt_gen1;      // gpio_interrupt1 to apb1

   integer      i;                   // loop variable
                
 
    
   // assignments1 
 
   // generic1 assignments1 for the gpio1 bus 
   // variables1 starting with gpio1 are the 
   // generic1 variables1 used below1. 
   // change these1 variable to use another1 bus protocol1 
   // for the gpio1. 
 
   // inputs1  
   assign write      = pwrite1 & penable1 & psel1; 
    
   assign read       = ~(pwrite1) & ~(penable1) & psel1; 
    
   assign addr       = paddr1; 
  
   assign sel1        = psel1; 

   
   // p_map_prdata1: combinatorial1/ rdata1
   //
   // this process adds1 zeros1 to all the unused1 prdata1 lines1, 
   // according1 to the chosen1 width of the gpio1 module
   
   always @ ( rdata1 )
   begin : p_map_prdata1
      begin
         for ( i = 16; i < 32; i = i + 1 )
           prdata1[i] = 1'b0;
      end

      prdata1[15:0] = rdata1;

   end // p_map_prdata1

   assign gpio_int1 = |gpio_interrupt_gen1;

   gpio_lite_subunit1  // gpio_subunit1 module instance

   
   i_gpio_lite_subunit1 // instance name to take1 the annotated1 parameters1

// pin1 annotation1
   (
       //inputs1

       .n_reset1            (n_p_reset1),         // reset
       .pclk1               (pclk1),              // gpio1 pclk1
       .read               (read),              // select1 for gpio1
       .write              (write),             // gpio1 write
       .addr               (addr),              // address bus
       .wdata1              (pwdata1[15:0]),  
                                                 // gpio1 input
       .pin_in1             (gpio_pin_in1),        // input data from pin1
       .tri_state_enable1   (tri_state_enable1),   // disables1 op enable

       //outputs1
       .rdata1              (rdata1),              // gpio1 output
       .interrupt1          (gpio_interrupt_gen1), // gpio_interupt1
       .pin_oe_n1           (n_gpio_pin_oe1),      // output enable
       .pin_out1            (gpio_pin_out1)        // output signal1
    );

 endmodule
