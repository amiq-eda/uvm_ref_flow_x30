//File3 name   : gpio_lite3.v
//Title3       : GPIO3 top level
//Created3     : 1999
//Description3 : A gpio3 module for use with amba3 
//                   apb3, with up to 16 io3 pins3 
//Notes3       : 
//----------------------------------------------------------------------
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------

module gpio_lite3( 
              //inputs3 
 
              n_p_reset3, 
              pclk3, 

              psel3, 
              penable3, 
              pwrite3, 
              paddr3, 
              pwdata3, 

              gpio_pin_in3, 

              scan_en3, 
              tri_state_enable3, 

              scan_in3, //added by smarkov3 for dft3
 
              //outputs3
              
              scan_out3, //added by smarkov3 for dft3 
               
              prdata3, 

              gpio_int3, 

              n_gpio_pin_oe3, 
              gpio_pin_out3 
); 
 


   // inputs3 
    
   // pclks3  
   input        n_p_reset3;            // amba3 reset 
   input        pclk3;               // peripherical3 pclk3 bus 

   // AMBA3 Rev3 2
   input        psel3;               // peripheral3 select3 for gpio3 
   input        penable3;            // peripheral3 enable 
   input        pwrite3;             // peripheral3 write strobe3 
   input [5:0] 
                paddr3;              // address bus of selected master3 
   input [31:0] 
                pwdata3;             // write data 

   // gpio3 generic3 inputs3 
   input [15:0] 
                gpio_pin_in3;             // input data from pin3 

   //design for test inputs3 
   input        scan_en3;            // enables3 shifting3 of scans3 
   input [15:0] 
                tri_state_enable3;   // disables3 op enable -> z 
   input        scan_in3;            // scan3 chain3 data input  
       
    
   // outputs3 
 
   //amba3 outputs3 
   output [31:0] 
                prdata3;             // read data 
   // gpio3 generic3 outputs3 
   output       gpio_int3;                // gpio_interupt3 for input pin3 change 
   output [15:0] 
                n_gpio_pin_oe3;           // output enable signal3 to pin3 
   output [15:0] 
                gpio_pin_out3;            // output signal3 to pin3 
                
   // scan3 outputs3
   output      scan_out3;            // scan3 chain3 data output
     
// gpio_internal3 signals3 declarations3
 
   // registers + wires3 for outputs3 
   reg  [31:0] 
                prdata3;             // registered output to apb3
   wire         gpio_int3;                // gpio_interrupt3 to apb3
   wire [15:0] 
                n_gpio_pin_oe3;           // gpio3 output enable
   wire [15:0] 
                gpio_pin_out3;            // gpio3 out
    
   // generic3 gpio3 stuff3 
   wire         write;              // apb3 register write strobe3
   wire         read;               // apb3 register read strobe3
   wire [5:0]
                addr;               // apb3 register address
   wire         n_p_reset3;            // apb3 reset
   wire         pclk3;               // apb3 clock3
   wire [15:0] 
                rdata3;              // registered output to apb3
   wire         sel3;                // apb3 peripheral3 select3
         
   //for gpio_interrupts3 
   wire [15:0] 
                gpio_interrupt_gen3;      // gpio_interrupt3 to apb3

   integer      i;                   // loop variable
                
 
    
   // assignments3 
 
   // generic3 assignments3 for the gpio3 bus 
   // variables3 starting with gpio3 are the 
   // generic3 variables3 used below3. 
   // change these3 variable to use another3 bus protocol3 
   // for the gpio3. 
 
   // inputs3  
   assign write      = pwrite3 & penable3 & psel3; 
    
   assign read       = ~(pwrite3) & ~(penable3) & psel3; 
    
   assign addr       = paddr3; 
  
   assign sel3        = psel3; 

   
   // p_map_prdata3: combinatorial3/ rdata3
   //
   // this process adds3 zeros3 to all the unused3 prdata3 lines3, 
   // according3 to the chosen3 width of the gpio3 module
   
   always @ ( rdata3 )
   begin : p_map_prdata3
      begin
         for ( i = 16; i < 32; i = i + 1 )
           prdata3[i] = 1'b0;
      end

      prdata3[15:0] = rdata3;

   end // p_map_prdata3

   assign gpio_int3 = |gpio_interrupt_gen3;

   gpio_lite_subunit3  // gpio_subunit3 module instance

   
   i_gpio_lite_subunit3 // instance name to take3 the annotated3 parameters3

// pin3 annotation3
   (
       //inputs3

       .n_reset3            (n_p_reset3),         // reset
       .pclk3               (pclk3),              // gpio3 pclk3
       .read               (read),              // select3 for gpio3
       .write              (write),             // gpio3 write
       .addr               (addr),              // address bus
       .wdata3              (pwdata3[15:0]),  
                                                 // gpio3 input
       .pin_in3             (gpio_pin_in3),        // input data from pin3
       .tri_state_enable3   (tri_state_enable3),   // disables3 op enable

       //outputs3
       .rdata3              (rdata3),              // gpio3 output
       .interrupt3          (gpio_interrupt_gen3), // gpio_interupt3
       .pin_oe_n3           (n_gpio_pin_oe3),      // output enable
       .pin_out3            (gpio_pin_out3)        // output signal3
    );

 endmodule
