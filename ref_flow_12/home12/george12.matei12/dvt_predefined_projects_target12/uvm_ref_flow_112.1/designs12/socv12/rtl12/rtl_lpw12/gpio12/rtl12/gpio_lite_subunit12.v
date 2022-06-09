//File12 name   : gpio_lite_subunit12.v
//Title12       : 
//Created12     : 1999
//Description12 : Parametrised12 GPIO12 pin12 circuits12
//Notes12       : 
//----------------------------------------------------------------------
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


module gpio_lite_subunit12(
  //Inputs12

  n_reset12,
  pclk12,

  read,
  write,
  addr,

  wdata12,
  pin_in12,

  tri_state_enable12,

  //Outputs12
 
  interrupt12,

  rdata12,
  pin_oe_n12,
  pin_out12

);
 
   // Inputs12
   
   // Clocks12   
   input n_reset12;            // asynch12 reset, active low12
   input pclk12;               // Ppclk12

   // Controls12
   input read;               // select12 GPIO12 read
   input write;              // select12 GPIO12 write
   input [5:0] 
         addr;               // address bus of selected master12

   // Dataflow12
   input [15:0]
         wdata12;              // GPIO12 Input12
   input [15:0]
         pin_in12;             // input data from pin12

   //Design12 for Test12 Inputs12
   input [15:0]
         tri_state_enable12;   // disables12 op enable -> Z12




   
   // Outputs12
   
   // Controls12
   output [15:0]
          interrupt12;         // interupt12 for input pin12 change

   // Dataflow12
   output [15:0]
          rdata12;             // GPIO12 Output12
   output [15:0]
          pin_oe_n12;          // output enable signal12 to pin12
   output [15:0]
          pin_out12;           // output signal12 to pin12
   



   
   // Registers12 in module

   //Define12 Physical12 registers in amba_unit12
   reg    [15:0]
          direction_mode12;     // 1=Input12 0=Output12              RW
   reg    [15:0]
          output_enable12;      // Output12 active                 RW
   reg    [15:0]
          output_value12;       // Value outputed12 from reg       RW
   reg    [15:0]
          input_value12;        // Value input from bus          R
   reg    [15:0]
          int_status12;         // Interrupt12 status              R

   // registers to remove metastability12
   reg    [15:0]
          s_synch12;            //stage_two12
   reg    [15:0]
          s_synch_two12;        //stage_one12 - to ext pin12
   
   
    
          
   // Registers12 for outputs12
   reg    [15:0]
          rdata12;              // prdata12 reg
   wire   [15:0]
          pin_oe_n12;           // gpio12 output enable
   wire   [15:0]
          pin_out12;            // gpio12 output value
   wire   [15:0]
          interrupt12;          // gpio12 interrupt12
   wire   [15:0]
          interrupt_trigger12;  // 1 sets12 interrupt12 status
   reg    [15:0]
          status_clear12;       // 1 clears12 interrupt12 status
   wire   [15:0]
          int_event12;          // 1 detects12 an interrupt12 event

   integer ia12;                // loop variable
   


   // address decodes12
   wire   ad_direction_mode12;  // 1=Input12 0=Output12              RW
   wire   ad_output_enable12;   // Output12 active                 RW
   wire   ad_output_value12;    // Value outputed12 from reg       RW
   wire   ad_int_status12;      // Interrupt12 status              R
   
//Register addresses12
//If12 modifying12 the APB12 address (PADDR12) width change the following12 bit widths12
parameter GPR_DIRECTION_MODE12   = 6'h04;       // set pin12 to either12 I12 or O12
parameter GPR_OUTPUT_ENABLE12    = 6'h08;       // contains12 oe12 control12 value
parameter GPR_OUTPUT_VALUE12     = 6'h0C;       // output value to be driven12
parameter GPR_INPUT_VALUE12      = 6'h10;       // gpio12 input value reg
parameter GPR_INT_STATUS12       = 6'h20;       // Interrupt12 status register

//Reset12 Values12
//If12 modifying12 the GPIO12 width change the following12 bit widths12
//parameter GPRV_RSRVD12            = 32'h0000_0000; // Reserved12
parameter GPRV_DIRECTION_MODE12  = 32'h00000000; // Default to output mode
parameter GPRV_OUTPUT_ENABLE12   = 32'h00000000; // Default 3 stated12 outs12
parameter GPRV_OUTPUT_VALUE12    = 32'h00000000; // Default to be driven12
parameter GPRV_INPUT_VALUE12     = 32'h00000000; // Read defaults12 to zero
parameter GPRV_INT_STATUS12      = 32'h00000000; // Int12 status cleared12



   //assign ad_bypass_mode12    = ( addr == GPR_BYPASS_MODE12 );   
   assign ad_direction_mode12 = ( addr == GPR_DIRECTION_MODE12 );   
   assign ad_output_enable12  = ( addr == GPR_OUTPUT_ENABLE12 );   
   assign ad_output_value12   = ( addr == GPR_OUTPUT_VALUE12 );   
   assign ad_int_status12     = ( addr == GPR_INT_STATUS12 );   

   // assignments12
   
   assign interrupt12         = ( int_status12);

   assign interrupt_trigger12 = ( direction_mode12 & int_event12 ); 

   assign int_event12 = ((s_synch12 ^ input_value12) & ((s_synch12)));

   always @( ad_int_status12 or read )
   begin : p_status_clear12

     for ( ia12 = 0; ia12 < 16; ia12 = ia12 + 1 )
     begin

       status_clear12[ia12] = ( ad_int_status12 & read );

     end // for ia12

   end // p_status_clear12

   // p_write_register12 : clocked12 / asynchronous12
   //
   // this section12 contains12 all the code12 to write registers

   always @(posedge pclk12 or negedge n_reset12)
   begin : p_write_register12

      if (~n_reset12)
      
       begin
         direction_mode12  <= GPRV_DIRECTION_MODE12;
         output_enable12   <= GPRV_OUTPUT_ENABLE12;
         output_value12    <= GPRV_OUTPUT_VALUE12;
       end
      
      else 
      
       begin
      
         if (write == 1'b1) // Write value to registers
      
          begin
              
            // Write Mode12
         
            if ( ad_direction_mode12 ) 
               direction_mode12 <= wdata12;
 
            if ( ad_output_enable12 ) 
               output_enable12  <= wdata12;
     
            if ( ad_output_value12 )
               output_value12   <= wdata12;

              

           end // if write
         
       end // else: ~if(~n_reset12)
      
   end // block: p_write_register12



   // p_metastable12 : clocked12 / asynchronous12 
   //
   // This12 process  acts12 to remove  metastability12 propagation
   // Only12 for input to GPIO12
   // In Bypass12 mode pin_in12 passes12 straight12 through

   always @(posedge pclk12 or negedge n_reset12)
      
   begin : p_metastable12
      
      if (~n_reset12)
        begin
         
         s_synch12       <= {16 {1'b0}};
         s_synch_two12   <= {16 {1'b0}};
         input_value12   <= GPRV_INPUT_VALUE12;
         
        end // if (~n_reset12)
      
      else         
        begin
         
         input_value12   <= s_synch12;
         s_synch12       <= s_synch_two12;
         s_synch_two12   <= pin_in12;

        end // else: ~if(~n_reset12)
      
   end // block: p_metastable12


   // p_interrupt12 : clocked12 / asynchronous12 
   //
   // These12 lines12 set and clear the interrupt12 status

   always @(posedge pclk12 or negedge n_reset12)
   begin : p_interrupt12
      
      if (~n_reset12)
         int_status12      <= GPRV_INT_STATUS12;
      
      else 
         int_status12      <= ( int_status12 & ~(status_clear12) // read & clear
                            ) |
                            interrupt_trigger12;             // new interrupt12
        
   end // block: p_interrupt12
   
   
   // p_read_register12  : clocked12 / asynchronous12 
   //
   // this process registers the output values

   always @(posedge pclk12 or negedge n_reset12)

      begin : p_read_register12
         
         if (~n_reset12)
         
           begin

            rdata12 <= {16 {1'b0}};

           end
           
         else //if not reset
         
           begin
         
            if (read == 1'b1)
            
              begin
            
               case (addr)
            
                  
                  GPR_DIRECTION_MODE12:
                     rdata12 <= direction_mode12;
                  
                  GPR_OUTPUT_ENABLE12:
                     rdata12 <= output_enable12;
                  
                  GPR_OUTPUT_VALUE12:
                     rdata12 <= output_value12;
                  
                  GPR_INT_STATUS12:
                     rdata12 <= int_status12;
                  
                  default: // if GPR_INPUT_VALUE12 or unmapped reg addr
                     rdata12 <= input_value12;
            
               endcase
            
              end //end if read
            
            else //in not read
            
              begin // if not a valid read access, keep12 '0'-s 
              
               rdata12 <= {16 {1'b0}};
              
              end //end if not read
              
           end //end else if not reset

      end // p_read_register12


   assign pin_out12 = 
        ( output_value12 ) ;
     
   assign pin_oe_n12 = 
      ( ( ~(output_enable12 & ~(direction_mode12)) ) |
        tri_state_enable12 ) ;

                
  
endmodule // gpio_subunit12



   
   



   
