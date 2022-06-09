//File2 name   : gpio_lite2.v
//Title2       : GPIO2 top level
//Created2     : 1999
//Description2 : A gpio2 module for use with amba2 
//                   apb2, with up to 16 io2 pins2 
//Notes2       : 
//----------------------------------------------------------------------
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------

module gpio_lite2( 
              //inputs2 
 
              n_p_reset2, 
              pclk2, 

              psel2, 
              penable2, 
              pwrite2, 
              paddr2, 
              pwdata2, 

              gpio_pin_in2, 

              scan_en2, 
              tri_state_enable2, 

              scan_in2, //added by smarkov2 for dft2
 
              //outputs2
              
              scan_out2, //added by smarkov2 for dft2 
               
              prdata2, 

              gpio_int2, 

              n_gpio_pin_oe2, 
              gpio_pin_out2 
); 
 


   // inputs2 
    
   // pclks2  
   input        n_p_reset2;            // amba2 reset 
   input        pclk2;               // peripherical2 pclk2 bus 

   // AMBA2 Rev2 2
   input        psel2;               // peripheral2 select2 for gpio2 
   input        penable2;            // peripheral2 enable 
   input        pwrite2;             // peripheral2 write strobe2 
   input [5:0] 
                paddr2;              // address bus of selected master2 
   input [31:0] 
                pwdata2;             // write data 

   // gpio2 generic2 inputs2 
   input [15:0] 
                gpio_pin_in2;             // input data from pin2 

   //design for test inputs2 
   input        scan_en2;            // enables2 shifting2 of scans2 
   input [15:0] 
                tri_state_enable2;   // disables2 op enable -> z 
   input        scan_in2;            // scan2 chain2 data input  
       
    
   // outputs2 
 
   //amba2 outputs2 
   output [31:0] 
                prdata2;             // read data 
   // gpio2 generic2 outputs2 
   output       gpio_int2;                // gpio_interupt2 for input pin2 change 
   output [15:0] 
                n_gpio_pin_oe2;           // output enable signal2 to pin2 
   output [15:0] 
                gpio_pin_out2;            // output signal2 to pin2 
                
   // scan2 outputs2
   output      scan_out2;            // scan2 chain2 data output
     
// gpio_internal2 signals2 declarations2
 
   // registers + wires2 for outputs2 
   reg  [31:0] 
                prdata2;             // registered output to apb2
   wire         gpio_int2;                // gpio_interrupt2 to apb2
   wire [15:0] 
                n_gpio_pin_oe2;           // gpio2 output enable
   wire [15:0] 
                gpio_pin_out2;            // gpio2 out
    
   // generic2 gpio2 stuff2 
   wire         write;              // apb2 register write strobe2
   wire         read;               // apb2 register read strobe2
   wire [5:0]
                addr;               // apb2 register address
   wire         n_p_reset2;            // apb2 reset
   wire         pclk2;               // apb2 clock2
   wire [15:0] 
                rdata2;              // registered output to apb2
   wire         sel2;                // apb2 peripheral2 select2
         
   //for gpio_interrupts2 
   wire [15:0] 
                gpio_interrupt_gen2;      // gpio_interrupt2 to apb2

   integer      i;                   // loop variable
                
 
    
   // assignments2 
 
   // generic2 assignments2 for the gpio2 bus 
   // variables2 starting with gpio2 are the 
   // generic2 variables2 used below2. 
   // change these2 variable to use another2 bus protocol2 
   // for the gpio2. 
 
   // inputs2  
   assign write      = pwrite2 & penable2 & psel2; 
    
   assign read       = ~(pwrite2) & ~(penable2) & psel2; 
    
   assign addr       = paddr2; 
  
   assign sel2        = psel2; 

   
   // p_map_prdata2: combinatorial2/ rdata2
   //
   // this process adds2 zeros2 to all the unused2 prdata2 lines2, 
   // according2 to the chosen2 width of the gpio2 module
   
   always @ ( rdata2 )
   begin : p_map_prdata2
      begin
         for ( i = 16; i < 32; i = i + 1 )
           prdata2[i] = 1'b0;
      end

      prdata2[15:0] = rdata2;

   end // p_map_prdata2

   assign gpio_int2 = |gpio_interrupt_gen2;

   gpio_lite_subunit2  // gpio_subunit2 module instance

   
   i_gpio_lite_subunit2 // instance name to take2 the annotated2 parameters2

// pin2 annotation2
   (
       //inputs2

       .n_reset2            (n_p_reset2),         // reset
       .pclk2               (pclk2),              // gpio2 pclk2
       .read               (read),              // select2 for gpio2
       .write              (write),             // gpio2 write
       .addr               (addr),              // address bus
       .wdata2              (pwdata2[15:0]),  
                                                 // gpio2 input
       .pin_in2             (gpio_pin_in2),        // input data from pin2
       .tri_state_enable2   (tri_state_enable2),   // disables2 op enable

       //outputs2
       .rdata2              (rdata2),              // gpio2 output
       .interrupt2          (gpio_interrupt_gen2), // gpio_interupt2
       .pin_oe_n2           (n_gpio_pin_oe2),      // output enable
       .pin_out2            (gpio_pin_out2)        // output signal2
    );

 endmodule
