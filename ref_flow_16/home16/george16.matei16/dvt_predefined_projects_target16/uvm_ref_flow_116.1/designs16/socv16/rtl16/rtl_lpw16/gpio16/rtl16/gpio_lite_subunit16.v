//File16 name   : gpio_lite_subunit16.v
//Title16       : 
//Created16     : 1999
//Description16 : Parametrised16 GPIO16 pin16 circuits16
//Notes16       : 
//----------------------------------------------------------------------
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


module gpio_lite_subunit16(
  //Inputs16

  n_reset16,
  pclk16,

  read,
  write,
  addr,

  wdata16,
  pin_in16,

  tri_state_enable16,

  //Outputs16
 
  interrupt16,

  rdata16,
  pin_oe_n16,
  pin_out16

);
 
   // Inputs16
   
   // Clocks16   
   input n_reset16;            // asynch16 reset, active low16
   input pclk16;               // Ppclk16

   // Controls16
   input read;               // select16 GPIO16 read
   input write;              // select16 GPIO16 write
   input [5:0] 
         addr;               // address bus of selected master16

   // Dataflow16
   input [15:0]
         wdata16;              // GPIO16 Input16
   input [15:0]
         pin_in16;             // input data from pin16

   //Design16 for Test16 Inputs16
   input [15:0]
         tri_state_enable16;   // disables16 op enable -> Z16




   
   // Outputs16
   
   // Controls16
   output [15:0]
          interrupt16;         // interupt16 for input pin16 change

   // Dataflow16
   output [15:0]
          rdata16;             // GPIO16 Output16
   output [15:0]
          pin_oe_n16;          // output enable signal16 to pin16
   output [15:0]
          pin_out16;           // output signal16 to pin16
   



   
   // Registers16 in module

   //Define16 Physical16 registers in amba_unit16
   reg    [15:0]
          direction_mode16;     // 1=Input16 0=Output16              RW
   reg    [15:0]
          output_enable16;      // Output16 active                 RW
   reg    [15:0]
          output_value16;       // Value outputed16 from reg       RW
   reg    [15:0]
          input_value16;        // Value input from bus          R
   reg    [15:0]
          int_status16;         // Interrupt16 status              R

   // registers to remove metastability16
   reg    [15:0]
          s_synch16;            //stage_two16
   reg    [15:0]
          s_synch_two16;        //stage_one16 - to ext pin16
   
   
    
          
   // Registers16 for outputs16
   reg    [15:0]
          rdata16;              // prdata16 reg
   wire   [15:0]
          pin_oe_n16;           // gpio16 output enable
   wire   [15:0]
          pin_out16;            // gpio16 output value
   wire   [15:0]
          interrupt16;          // gpio16 interrupt16
   wire   [15:0]
          interrupt_trigger16;  // 1 sets16 interrupt16 status
   reg    [15:0]
          status_clear16;       // 1 clears16 interrupt16 status
   wire   [15:0]
          int_event16;          // 1 detects16 an interrupt16 event

   integer ia16;                // loop variable
   


   // address decodes16
   wire   ad_direction_mode16;  // 1=Input16 0=Output16              RW
   wire   ad_output_enable16;   // Output16 active                 RW
   wire   ad_output_value16;    // Value outputed16 from reg       RW
   wire   ad_int_status16;      // Interrupt16 status              R
   
//Register addresses16
//If16 modifying16 the APB16 address (PADDR16) width change the following16 bit widths16
parameter GPR_DIRECTION_MODE16   = 6'h04;       // set pin16 to either16 I16 or O16
parameter GPR_OUTPUT_ENABLE16    = 6'h08;       // contains16 oe16 control16 value
parameter GPR_OUTPUT_VALUE16     = 6'h0C;       // output value to be driven16
parameter GPR_INPUT_VALUE16      = 6'h10;       // gpio16 input value reg
parameter GPR_INT_STATUS16       = 6'h20;       // Interrupt16 status register

//Reset16 Values16
//If16 modifying16 the GPIO16 width change the following16 bit widths16
//parameter GPRV_RSRVD16            = 32'h0000_0000; // Reserved16
parameter GPRV_DIRECTION_MODE16  = 32'h00000000; // Default to output mode
parameter GPRV_OUTPUT_ENABLE16   = 32'h00000000; // Default 3 stated16 outs16
parameter GPRV_OUTPUT_VALUE16    = 32'h00000000; // Default to be driven16
parameter GPRV_INPUT_VALUE16     = 32'h00000000; // Read defaults16 to zero
parameter GPRV_INT_STATUS16      = 32'h00000000; // Int16 status cleared16



   //assign ad_bypass_mode16    = ( addr == GPR_BYPASS_MODE16 );   
   assign ad_direction_mode16 = ( addr == GPR_DIRECTION_MODE16 );   
   assign ad_output_enable16  = ( addr == GPR_OUTPUT_ENABLE16 );   
   assign ad_output_value16   = ( addr == GPR_OUTPUT_VALUE16 );   
   assign ad_int_status16     = ( addr == GPR_INT_STATUS16 );   

   // assignments16
   
   assign interrupt16         = ( int_status16);

   assign interrupt_trigger16 = ( direction_mode16 & int_event16 ); 

   assign int_event16 = ((s_synch16 ^ input_value16) & ((s_synch16)));

   always @( ad_int_status16 or read )
   begin : p_status_clear16

     for ( ia16 = 0; ia16 < 16; ia16 = ia16 + 1 )
     begin

       status_clear16[ia16] = ( ad_int_status16 & read );

     end // for ia16

   end // p_status_clear16

   // p_write_register16 : clocked16 / asynchronous16
   //
   // this section16 contains16 all the code16 to write registers

   always @(posedge pclk16 or negedge n_reset16)
   begin : p_write_register16

      if (~n_reset16)
      
       begin
         direction_mode16  <= GPRV_DIRECTION_MODE16;
         output_enable16   <= GPRV_OUTPUT_ENABLE16;
         output_value16    <= GPRV_OUTPUT_VALUE16;
       end
      
      else 
      
       begin
      
         if (write == 1'b1) // Write value to registers
      
          begin
              
            // Write Mode16
         
            if ( ad_direction_mode16 ) 
               direction_mode16 <= wdata16;
 
            if ( ad_output_enable16 ) 
               output_enable16  <= wdata16;
     
            if ( ad_output_value16 )
               output_value16   <= wdata16;

              

           end // if write
         
       end // else: ~if(~n_reset16)
      
   end // block: p_write_register16



   // p_metastable16 : clocked16 / asynchronous16 
   //
   // This16 process  acts16 to remove  metastability16 propagation
   // Only16 for input to GPIO16
   // In Bypass16 mode pin_in16 passes16 straight16 through

   always @(posedge pclk16 or negedge n_reset16)
      
   begin : p_metastable16
      
      if (~n_reset16)
        begin
         
         s_synch16       <= {16 {1'b0}};
         s_synch_two16   <= {16 {1'b0}};
         input_value16   <= GPRV_INPUT_VALUE16;
         
        end // if (~n_reset16)
      
      else         
        begin
         
         input_value16   <= s_synch16;
         s_synch16       <= s_synch_two16;
         s_synch_two16   <= pin_in16;

        end // else: ~if(~n_reset16)
      
   end // block: p_metastable16


   // p_interrupt16 : clocked16 / asynchronous16 
   //
   // These16 lines16 set and clear the interrupt16 status

   always @(posedge pclk16 or negedge n_reset16)
   begin : p_interrupt16
      
      if (~n_reset16)
         int_status16      <= GPRV_INT_STATUS16;
      
      else 
         int_status16      <= ( int_status16 & ~(status_clear16) // read & clear
                            ) |
                            interrupt_trigger16;             // new interrupt16
        
   end // block: p_interrupt16
   
   
   // p_read_register16  : clocked16 / asynchronous16 
   //
   // this process registers the output values

   always @(posedge pclk16 or negedge n_reset16)

      begin : p_read_register16
         
         if (~n_reset16)
         
           begin

            rdata16 <= {16 {1'b0}};

           end
           
         else //if not reset
         
           begin
         
            if (read == 1'b1)
            
              begin
            
               case (addr)
            
                  
                  GPR_DIRECTION_MODE16:
                     rdata16 <= direction_mode16;
                  
                  GPR_OUTPUT_ENABLE16:
                     rdata16 <= output_enable16;
                  
                  GPR_OUTPUT_VALUE16:
                     rdata16 <= output_value16;
                  
                  GPR_INT_STATUS16:
                     rdata16 <= int_status16;
                  
                  default: // if GPR_INPUT_VALUE16 or unmapped reg addr
                     rdata16 <= input_value16;
            
               endcase
            
              end //end if read
            
            else //in not read
            
              begin // if not a valid read access, keep16 '0'-s 
              
               rdata16 <= {16 {1'b0}};
              
              end //end if not read
              
           end //end else if not reset

      end // p_read_register16


   assign pin_out16 = 
        ( output_value16 ) ;
     
   assign pin_oe_n16 = 
      ( ( ~(output_enable16 & ~(direction_mode16)) ) |
        tri_state_enable16 ) ;

                
  
endmodule // gpio_subunit16



   
   



   
