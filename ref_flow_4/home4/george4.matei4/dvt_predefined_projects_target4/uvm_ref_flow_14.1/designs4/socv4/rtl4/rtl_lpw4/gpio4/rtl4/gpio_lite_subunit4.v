//File4 name   : gpio_lite_subunit4.v
//Title4       : 
//Created4     : 1999
//Description4 : Parametrised4 GPIO4 pin4 circuits4
//Notes4       : 
//----------------------------------------------------------------------
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


module gpio_lite_subunit4(
  //Inputs4

  n_reset4,
  pclk4,

  read,
  write,
  addr,

  wdata4,
  pin_in4,

  tri_state_enable4,

  //Outputs4
 
  interrupt4,

  rdata4,
  pin_oe_n4,
  pin_out4

);
 
   // Inputs4
   
   // Clocks4   
   input n_reset4;            // asynch4 reset, active low4
   input pclk4;               // Ppclk4

   // Controls4
   input read;               // select4 GPIO4 read
   input write;              // select4 GPIO4 write
   input [5:0] 
         addr;               // address bus of selected master4

   // Dataflow4
   input [15:0]
         wdata4;              // GPIO4 Input4
   input [15:0]
         pin_in4;             // input data from pin4

   //Design4 for Test4 Inputs4
   input [15:0]
         tri_state_enable4;   // disables4 op enable -> Z4




   
   // Outputs4
   
   // Controls4
   output [15:0]
          interrupt4;         // interupt4 for input pin4 change

   // Dataflow4
   output [15:0]
          rdata4;             // GPIO4 Output4
   output [15:0]
          pin_oe_n4;          // output enable signal4 to pin4
   output [15:0]
          pin_out4;           // output signal4 to pin4
   



   
   // Registers4 in module

   //Define4 Physical4 registers in amba_unit4
   reg    [15:0]
          direction_mode4;     // 1=Input4 0=Output4              RW
   reg    [15:0]
          output_enable4;      // Output4 active                 RW
   reg    [15:0]
          output_value4;       // Value outputed4 from reg       RW
   reg    [15:0]
          input_value4;        // Value input from bus          R
   reg    [15:0]
          int_status4;         // Interrupt4 status              R

   // registers to remove metastability4
   reg    [15:0]
          s_synch4;            //stage_two4
   reg    [15:0]
          s_synch_two4;        //stage_one4 - to ext pin4
   
   
    
          
   // Registers4 for outputs4
   reg    [15:0]
          rdata4;              // prdata4 reg
   wire   [15:0]
          pin_oe_n4;           // gpio4 output enable
   wire   [15:0]
          pin_out4;            // gpio4 output value
   wire   [15:0]
          interrupt4;          // gpio4 interrupt4
   wire   [15:0]
          interrupt_trigger4;  // 1 sets4 interrupt4 status
   reg    [15:0]
          status_clear4;       // 1 clears4 interrupt4 status
   wire   [15:0]
          int_event4;          // 1 detects4 an interrupt4 event

   integer ia4;                // loop variable
   


   // address decodes4
   wire   ad_direction_mode4;  // 1=Input4 0=Output4              RW
   wire   ad_output_enable4;   // Output4 active                 RW
   wire   ad_output_value4;    // Value outputed4 from reg       RW
   wire   ad_int_status4;      // Interrupt4 status              R
   
//Register addresses4
//If4 modifying4 the APB4 address (PADDR4) width change the following4 bit widths4
parameter GPR_DIRECTION_MODE4   = 6'h04;       // set pin4 to either4 I4 or O4
parameter GPR_OUTPUT_ENABLE4    = 6'h08;       // contains4 oe4 control4 value
parameter GPR_OUTPUT_VALUE4     = 6'h0C;       // output value to be driven4
parameter GPR_INPUT_VALUE4      = 6'h10;       // gpio4 input value reg
parameter GPR_INT_STATUS4       = 6'h20;       // Interrupt4 status register

//Reset4 Values4
//If4 modifying4 the GPIO4 width change the following4 bit widths4
//parameter GPRV_RSRVD4            = 32'h0000_0000; // Reserved4
parameter GPRV_DIRECTION_MODE4  = 32'h00000000; // Default to output mode
parameter GPRV_OUTPUT_ENABLE4   = 32'h00000000; // Default 3 stated4 outs4
parameter GPRV_OUTPUT_VALUE4    = 32'h00000000; // Default to be driven4
parameter GPRV_INPUT_VALUE4     = 32'h00000000; // Read defaults4 to zero
parameter GPRV_INT_STATUS4      = 32'h00000000; // Int4 status cleared4



   //assign ad_bypass_mode4    = ( addr == GPR_BYPASS_MODE4 );   
   assign ad_direction_mode4 = ( addr == GPR_DIRECTION_MODE4 );   
   assign ad_output_enable4  = ( addr == GPR_OUTPUT_ENABLE4 );   
   assign ad_output_value4   = ( addr == GPR_OUTPUT_VALUE4 );   
   assign ad_int_status4     = ( addr == GPR_INT_STATUS4 );   

   // assignments4
   
   assign interrupt4         = ( int_status4);

   assign interrupt_trigger4 = ( direction_mode4 & int_event4 ); 

   assign int_event4 = ((s_synch4 ^ input_value4) & ((s_synch4)));

   always @( ad_int_status4 or read )
   begin : p_status_clear4

     for ( ia4 = 0; ia4 < 16; ia4 = ia4 + 1 )
     begin

       status_clear4[ia4] = ( ad_int_status4 & read );

     end // for ia4

   end // p_status_clear4

   // p_write_register4 : clocked4 / asynchronous4
   //
   // this section4 contains4 all the code4 to write registers

   always @(posedge pclk4 or negedge n_reset4)
   begin : p_write_register4

      if (~n_reset4)
      
       begin
         direction_mode4  <= GPRV_DIRECTION_MODE4;
         output_enable4   <= GPRV_OUTPUT_ENABLE4;
         output_value4    <= GPRV_OUTPUT_VALUE4;
       end
      
      else 
      
       begin
      
         if (write == 1'b1) // Write value to registers
      
          begin
              
            // Write Mode4
         
            if ( ad_direction_mode4 ) 
               direction_mode4 <= wdata4;
 
            if ( ad_output_enable4 ) 
               output_enable4  <= wdata4;
     
            if ( ad_output_value4 )
               output_value4   <= wdata4;

              

           end // if write
         
       end // else: ~if(~n_reset4)
      
   end // block: p_write_register4



   // p_metastable4 : clocked4 / asynchronous4 
   //
   // This4 process  acts4 to remove  metastability4 propagation
   // Only4 for input to GPIO4
   // In Bypass4 mode pin_in4 passes4 straight4 through

   always @(posedge pclk4 or negedge n_reset4)
      
   begin : p_metastable4
      
      if (~n_reset4)
        begin
         
         s_synch4       <= {16 {1'b0}};
         s_synch_two4   <= {16 {1'b0}};
         input_value4   <= GPRV_INPUT_VALUE4;
         
        end // if (~n_reset4)
      
      else         
        begin
         
         input_value4   <= s_synch4;
         s_synch4       <= s_synch_two4;
         s_synch_two4   <= pin_in4;

        end // else: ~if(~n_reset4)
      
   end // block: p_metastable4


   // p_interrupt4 : clocked4 / asynchronous4 
   //
   // These4 lines4 set and clear the interrupt4 status

   always @(posedge pclk4 or negedge n_reset4)
   begin : p_interrupt4
      
      if (~n_reset4)
         int_status4      <= GPRV_INT_STATUS4;
      
      else 
         int_status4      <= ( int_status4 & ~(status_clear4) // read & clear
                            ) |
                            interrupt_trigger4;             // new interrupt4
        
   end // block: p_interrupt4
   
   
   // p_read_register4  : clocked4 / asynchronous4 
   //
   // this process registers the output values

   always @(posedge pclk4 or negedge n_reset4)

      begin : p_read_register4
         
         if (~n_reset4)
         
           begin

            rdata4 <= {16 {1'b0}};

           end
           
         else //if not reset
         
           begin
         
            if (read == 1'b1)
            
              begin
            
               case (addr)
            
                  
                  GPR_DIRECTION_MODE4:
                     rdata4 <= direction_mode4;
                  
                  GPR_OUTPUT_ENABLE4:
                     rdata4 <= output_enable4;
                  
                  GPR_OUTPUT_VALUE4:
                     rdata4 <= output_value4;
                  
                  GPR_INT_STATUS4:
                     rdata4 <= int_status4;
                  
                  default: // if GPR_INPUT_VALUE4 or unmapped reg addr
                     rdata4 <= input_value4;
            
               endcase
            
              end //end if read
            
            else //in not read
            
              begin // if not a valid read access, keep4 '0'-s 
              
               rdata4 <= {16 {1'b0}};
              
              end //end if not read
              
           end //end else if not reset

      end // p_read_register4


   assign pin_out4 = 
        ( output_value4 ) ;
     
   assign pin_oe_n4 = 
      ( ( ~(output_enable4 & ~(direction_mode4)) ) |
        tri_state_enable4 ) ;

                
  
endmodule // gpio_subunit4



   
   



   
