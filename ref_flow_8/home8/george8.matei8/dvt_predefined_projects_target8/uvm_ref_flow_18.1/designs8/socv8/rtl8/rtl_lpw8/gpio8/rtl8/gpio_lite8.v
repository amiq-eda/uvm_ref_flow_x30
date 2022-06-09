//File8 name   : gpio_lite8.v
//Title8       : GPIO8 top level
//Created8     : 1999
//Description8 : A gpio8 module for use with amba8 
//                   apb8, with up to 16 io8 pins8 
//Notes8       : 
//----------------------------------------------------------------------
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------

module gpio_lite8( 
              //inputs8 
 
              n_p_reset8, 
              pclk8, 

              psel8, 
              penable8, 
              pwrite8, 
              paddr8, 
              pwdata8, 

              gpio_pin_in8, 

              scan_en8, 
              tri_state_enable8, 

              scan_in8, //added by smarkov8 for dft8
 
              //outputs8
              
              scan_out8, //added by smarkov8 for dft8 
               
              prdata8, 

              gpio_int8, 

              n_gpio_pin_oe8, 
              gpio_pin_out8 
); 
 


   // inputs8 
    
   // pclks8  
   input        n_p_reset8;            // amba8 reset 
   input        pclk8;               // peripherical8 pclk8 bus 

   // AMBA8 Rev8 2
   input        psel8;               // peripheral8 select8 for gpio8 
   input        penable8;            // peripheral8 enable 
   input        pwrite8;             // peripheral8 write strobe8 
   input [5:0] 
                paddr8;              // address bus of selected master8 
   input [31:0] 
                pwdata8;             // write data 

   // gpio8 generic8 inputs8 
   input [15:0] 
                gpio_pin_in8;             // input data from pin8 

   //design for test inputs8 
   input        scan_en8;            // enables8 shifting8 of scans8 
   input [15:0] 
                tri_state_enable8;   // disables8 op enable -> z 
   input        scan_in8;            // scan8 chain8 data input  
       
    
   // outputs8 
 
   //amba8 outputs8 
   output [31:0] 
                prdata8;             // read data 
   // gpio8 generic8 outputs8 
   output       gpio_int8;                // gpio_interupt8 for input pin8 change 
   output [15:0] 
                n_gpio_pin_oe8;           // output enable signal8 to pin8 
   output [15:0] 
                gpio_pin_out8;            // output signal8 to pin8 
                
   // scan8 outputs8
   output      scan_out8;            // scan8 chain8 data output
     
// gpio_internal8 signals8 declarations8
 
   // registers + wires8 for outputs8 
   reg  [31:0] 
                prdata8;             // registered output to apb8
   wire         gpio_int8;                // gpio_interrupt8 to apb8
   wire [15:0] 
                n_gpio_pin_oe8;           // gpio8 output enable
   wire [15:0] 
                gpio_pin_out8;            // gpio8 out
    
   // generic8 gpio8 stuff8 
   wire         write;              // apb8 register write strobe8
   wire         read;               // apb8 register read strobe8
   wire [5:0]
                addr;               // apb8 register address
   wire         n_p_reset8;            // apb8 reset
   wire         pclk8;               // apb8 clock8
   wire [15:0] 
                rdata8;              // registered output to apb8
   wire         sel8;                // apb8 peripheral8 select8
         
   //for gpio_interrupts8 
   wire [15:0] 
                gpio_interrupt_gen8;      // gpio_interrupt8 to apb8

   integer      i;                   // loop variable
                
 
    
   // assignments8 
 
   // generic8 assignments8 for the gpio8 bus 
   // variables8 starting with gpio8 are the 
   // generic8 variables8 used below8. 
   // change these8 variable to use another8 bus protocol8 
   // for the gpio8. 
 
   // inputs8  
   assign write      = pwrite8 & penable8 & psel8; 
    
   assign read       = ~(pwrite8) & ~(penable8) & psel8; 
    
   assign addr       = paddr8; 
  
   assign sel8        = psel8; 

   
   // p_map_prdata8: combinatorial8/ rdata8
   //
   // this process adds8 zeros8 to all the unused8 prdata8 lines8, 
   // according8 to the chosen8 width of the gpio8 module
   
   always @ ( rdata8 )
   begin : p_map_prdata8
      begin
         for ( i = 16; i < 32; i = i + 1 )
           prdata8[i] = 1'b0;
      end

      prdata8[15:0] = rdata8;

   end // p_map_prdata8

   assign gpio_int8 = |gpio_interrupt_gen8;

   gpio_lite_subunit8  // gpio_subunit8 module instance

   
   i_gpio_lite_subunit8 // instance name to take8 the annotated8 parameters8

// pin8 annotation8
   (
       //inputs8

       .n_reset8            (n_p_reset8),         // reset
       .pclk8               (pclk8),              // gpio8 pclk8
       .read               (read),              // select8 for gpio8
       .write              (write),             // gpio8 write
       .addr               (addr),              // address bus
       .wdata8              (pwdata8[15:0]),  
                                                 // gpio8 input
       .pin_in8             (gpio_pin_in8),        // input data from pin8
       .tri_state_enable8   (tri_state_enable8),   // disables8 op enable

       //outputs8
       .rdata8              (rdata8),              // gpio8 output
       .interrupt8          (gpio_interrupt_gen8), // gpio_interupt8
       .pin_oe_n8           (n_gpio_pin_oe8),      // output enable
       .pin_out8            (gpio_pin_out8)        // output signal8
    );

 endmodule
