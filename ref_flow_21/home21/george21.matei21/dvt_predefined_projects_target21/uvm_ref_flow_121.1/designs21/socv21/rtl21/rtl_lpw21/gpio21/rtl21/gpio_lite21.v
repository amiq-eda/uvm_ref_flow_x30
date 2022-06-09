//File21 name   : gpio_lite21.v
//Title21       : GPIO21 top level
//Created21     : 1999
//Description21 : A gpio21 module for use with amba21 
//                   apb21, with up to 16 io21 pins21 
//Notes21       : 
//----------------------------------------------------------------------
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------

module gpio_lite21( 
              //inputs21 
 
              n_p_reset21, 
              pclk21, 

              psel21, 
              penable21, 
              pwrite21, 
              paddr21, 
              pwdata21, 

              gpio_pin_in21, 

              scan_en21, 
              tri_state_enable21, 

              scan_in21, //added by smarkov21 for dft21
 
              //outputs21
              
              scan_out21, //added by smarkov21 for dft21 
               
              prdata21, 

              gpio_int21, 

              n_gpio_pin_oe21, 
              gpio_pin_out21 
); 
 


   // inputs21 
    
   // pclks21  
   input        n_p_reset21;            // amba21 reset 
   input        pclk21;               // peripherical21 pclk21 bus 

   // AMBA21 Rev21 2
   input        psel21;               // peripheral21 select21 for gpio21 
   input        penable21;            // peripheral21 enable 
   input        pwrite21;             // peripheral21 write strobe21 
   input [5:0] 
                paddr21;              // address bus of selected master21 
   input [31:0] 
                pwdata21;             // write data 

   // gpio21 generic21 inputs21 
   input [15:0] 
                gpio_pin_in21;             // input data from pin21 

   //design for test inputs21 
   input        scan_en21;            // enables21 shifting21 of scans21 
   input [15:0] 
                tri_state_enable21;   // disables21 op enable -> z 
   input        scan_in21;            // scan21 chain21 data input  
       
    
   // outputs21 
 
   //amba21 outputs21 
   output [31:0] 
                prdata21;             // read data 
   // gpio21 generic21 outputs21 
   output       gpio_int21;                // gpio_interupt21 for input pin21 change 
   output [15:0] 
                n_gpio_pin_oe21;           // output enable signal21 to pin21 
   output [15:0] 
                gpio_pin_out21;            // output signal21 to pin21 
                
   // scan21 outputs21
   output      scan_out21;            // scan21 chain21 data output
     
// gpio_internal21 signals21 declarations21
 
   // registers + wires21 for outputs21 
   reg  [31:0] 
                prdata21;             // registered output to apb21
   wire         gpio_int21;                // gpio_interrupt21 to apb21
   wire [15:0] 
                n_gpio_pin_oe21;           // gpio21 output enable
   wire [15:0] 
                gpio_pin_out21;            // gpio21 out
    
   // generic21 gpio21 stuff21 
   wire         write;              // apb21 register write strobe21
   wire         read;               // apb21 register read strobe21
   wire [5:0]
                addr;               // apb21 register address
   wire         n_p_reset21;            // apb21 reset
   wire         pclk21;               // apb21 clock21
   wire [15:0] 
                rdata21;              // registered output to apb21
   wire         sel21;                // apb21 peripheral21 select21
         
   //for gpio_interrupts21 
   wire [15:0] 
                gpio_interrupt_gen21;      // gpio_interrupt21 to apb21

   integer      i;                   // loop variable
                
 
    
   // assignments21 
 
   // generic21 assignments21 for the gpio21 bus 
   // variables21 starting with gpio21 are the 
   // generic21 variables21 used below21. 
   // change these21 variable to use another21 bus protocol21 
   // for the gpio21. 
 
   // inputs21  
   assign write      = pwrite21 & penable21 & psel21; 
    
   assign read       = ~(pwrite21) & ~(penable21) & psel21; 
    
   assign addr       = paddr21; 
  
   assign sel21        = psel21; 

   
   // p_map_prdata21: combinatorial21/ rdata21
   //
   // this process adds21 zeros21 to all the unused21 prdata21 lines21, 
   // according21 to the chosen21 width of the gpio21 module
   
   always @ ( rdata21 )
   begin : p_map_prdata21
      begin
         for ( i = 16; i < 32; i = i + 1 )
           prdata21[i] = 1'b0;
      end

      prdata21[15:0] = rdata21;

   end // p_map_prdata21

   assign gpio_int21 = |gpio_interrupt_gen21;

   gpio_lite_subunit21  // gpio_subunit21 module instance

   
   i_gpio_lite_subunit21 // instance name to take21 the annotated21 parameters21

// pin21 annotation21
   (
       //inputs21

       .n_reset21            (n_p_reset21),         // reset
       .pclk21               (pclk21),              // gpio21 pclk21
       .read               (read),              // select21 for gpio21
       .write              (write),             // gpio21 write
       .addr               (addr),              // address bus
       .wdata21              (pwdata21[15:0]),  
                                                 // gpio21 input
       .pin_in21             (gpio_pin_in21),        // input data from pin21
       .tri_state_enable21   (tri_state_enable21),   // disables21 op enable

       //outputs21
       .rdata21              (rdata21),              // gpio21 output
       .interrupt21          (gpio_interrupt_gen21), // gpio_interupt21
       .pin_oe_n21           (n_gpio_pin_oe21),      // output enable
       .pin_out21            (gpio_pin_out21)        // output signal21
    );

 endmodule
