//File26 name   : gpio_lite_subunit26.v
//Title26       : 
//Created26     : 1999
//Description26 : Parametrised26 GPIO26 pin26 circuits26
//Notes26       : 
//----------------------------------------------------------------------
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


module gpio_lite_subunit26(
  //Inputs26

  n_reset26,
  pclk26,

  read,
  write,
  addr,

  wdata26,
  pin_in26,

  tri_state_enable26,

  //Outputs26
 
  interrupt26,

  rdata26,
  pin_oe_n26,
  pin_out26

);
 
   // Inputs26
   
   // Clocks26   
   input n_reset26;            // asynch26 reset, active low26
   input pclk26;               // Ppclk26

   // Controls26
   input read;               // select26 GPIO26 read
   input write;              // select26 GPIO26 write
   input [5:0] 
         addr;               // address bus of selected master26

   // Dataflow26
   input [15:0]
         wdata26;              // GPIO26 Input26
   input [15:0]
         pin_in26;             // input data from pin26

   //Design26 for Test26 Inputs26
   input [15:0]
         tri_state_enable26;   // disables26 op enable -> Z26




   
   // Outputs26
   
   // Controls26
   output [15:0]
          interrupt26;         // interupt26 for input pin26 change

   // Dataflow26
   output [15:0]
          rdata26;             // GPIO26 Output26
   output [15:0]
          pin_oe_n26;          // output enable signal26 to pin26
   output [15:0]
          pin_out26;           // output signal26 to pin26
   



   
   // Registers26 in module

   //Define26 Physical26 registers in amba_unit26
   reg    [15:0]
          direction_mode26;     // 1=Input26 0=Output26              RW
   reg    [15:0]
          output_enable26;      // Output26 active                 RW
   reg    [15:0]
          output_value26;       // Value outputed26 from reg       RW
   reg    [15:0]
          input_value26;        // Value input from bus          R
   reg    [15:0]
          int_status26;         // Interrupt26 status              R

   // registers to remove metastability26
   reg    [15:0]
          s_synch26;            //stage_two26
   reg    [15:0]
          s_synch_two26;        //stage_one26 - to ext pin26
   
   
    
          
   // Registers26 for outputs26
   reg    [15:0]
          rdata26;              // prdata26 reg
   wire   [15:0]
          pin_oe_n26;           // gpio26 output enable
   wire   [15:0]
          pin_out26;            // gpio26 output value
   wire   [15:0]
          interrupt26;          // gpio26 interrupt26
   wire   [15:0]
          interrupt_trigger26;  // 1 sets26 interrupt26 status
   reg    [15:0]
          status_clear26;       // 1 clears26 interrupt26 status
   wire   [15:0]
          int_event26;          // 1 detects26 an interrupt26 event

   integer ia26;                // loop variable
   


   // address decodes26
   wire   ad_direction_mode26;  // 1=Input26 0=Output26              RW
   wire   ad_output_enable26;   // Output26 active                 RW
   wire   ad_output_value26;    // Value outputed26 from reg       RW
   wire   ad_int_status26;      // Interrupt26 status              R
   
//Register addresses26
//If26 modifying26 the APB26 address (PADDR26) width change the following26 bit widths26
parameter GPR_DIRECTION_MODE26   = 6'h04;       // set pin26 to either26 I26 or O26
parameter GPR_OUTPUT_ENABLE26    = 6'h08;       // contains26 oe26 control26 value
parameter GPR_OUTPUT_VALUE26     = 6'h0C;       // output value to be driven26
parameter GPR_INPUT_VALUE26      = 6'h10;       // gpio26 input value reg
parameter GPR_INT_STATUS26       = 6'h20;       // Interrupt26 status register

//Reset26 Values26
//If26 modifying26 the GPIO26 width change the following26 bit widths26
//parameter GPRV_RSRVD26            = 32'h0000_0000; // Reserved26
parameter GPRV_DIRECTION_MODE26  = 32'h00000000; // Default to output mode
parameter GPRV_OUTPUT_ENABLE26   = 32'h00000000; // Default 3 stated26 outs26
parameter GPRV_OUTPUT_VALUE26    = 32'h00000000; // Default to be driven26
parameter GPRV_INPUT_VALUE26     = 32'h00000000; // Read defaults26 to zero
parameter GPRV_INT_STATUS26      = 32'h00000000; // Int26 status cleared26



   //assign ad_bypass_mode26    = ( addr == GPR_BYPASS_MODE26 );   
   assign ad_direction_mode26 = ( addr == GPR_DIRECTION_MODE26 );   
   assign ad_output_enable26  = ( addr == GPR_OUTPUT_ENABLE26 );   
   assign ad_output_value26   = ( addr == GPR_OUTPUT_VALUE26 );   
   assign ad_int_status26     = ( addr == GPR_INT_STATUS26 );   

   // assignments26
   
   assign interrupt26         = ( int_status26);

   assign interrupt_trigger26 = ( direction_mode26 & int_event26 ); 

   assign int_event26 = ((s_synch26 ^ input_value26) & ((s_synch26)));

   always @( ad_int_status26 or read )
   begin : p_status_clear26

     for ( ia26 = 0; ia26 < 16; ia26 = ia26 + 1 )
     begin

       status_clear26[ia26] = ( ad_int_status26 & read );

     end // for ia26

   end // p_status_clear26

   // p_write_register26 : clocked26 / asynchronous26
   //
   // this section26 contains26 all the code26 to write registers

   always @(posedge pclk26 or negedge n_reset26)
   begin : p_write_register26

      if (~n_reset26)
      
       begin
         direction_mode26  <= GPRV_DIRECTION_MODE26;
         output_enable26   <= GPRV_OUTPUT_ENABLE26;
         output_value26    <= GPRV_OUTPUT_VALUE26;
       end
      
      else 
      
       begin
      
         if (write == 1'b1) // Write value to registers
      
          begin
              
            // Write Mode26
         
            if ( ad_direction_mode26 ) 
               direction_mode26 <= wdata26;
 
            if ( ad_output_enable26 ) 
               output_enable26  <= wdata26;
     
            if ( ad_output_value26 )
               output_value26   <= wdata26;

              

           end // if write
         
       end // else: ~if(~n_reset26)
      
   end // block: p_write_register26



   // p_metastable26 : clocked26 / asynchronous26 
   //
   // This26 process  acts26 to remove  metastability26 propagation
   // Only26 for input to GPIO26
   // In Bypass26 mode pin_in26 passes26 straight26 through

   always @(posedge pclk26 or negedge n_reset26)
      
   begin : p_metastable26
      
      if (~n_reset26)
        begin
         
         s_synch26       <= {16 {1'b0}};
         s_synch_two26   <= {16 {1'b0}};
         input_value26   <= GPRV_INPUT_VALUE26;
         
        end // if (~n_reset26)
      
      else         
        begin
         
         input_value26   <= s_synch26;
         s_synch26       <= s_synch_two26;
         s_synch_two26   <= pin_in26;

        end // else: ~if(~n_reset26)
      
   end // block: p_metastable26


   // p_interrupt26 : clocked26 / asynchronous26 
   //
   // These26 lines26 set and clear the interrupt26 status

   always @(posedge pclk26 or negedge n_reset26)
   begin : p_interrupt26
      
      if (~n_reset26)
         int_status26      <= GPRV_INT_STATUS26;
      
      else 
         int_status26      <= ( int_status26 & ~(status_clear26) // read & clear
                            ) |
                            interrupt_trigger26;             // new interrupt26
        
   end // block: p_interrupt26
   
   
   // p_read_register26  : clocked26 / asynchronous26 
   //
   // this process registers the output values

   always @(posedge pclk26 or negedge n_reset26)

      begin : p_read_register26
         
         if (~n_reset26)
         
           begin

            rdata26 <= {16 {1'b0}};

           end
           
         else //if not reset
         
           begin
         
            if (read == 1'b1)
            
              begin
            
               case (addr)
            
                  
                  GPR_DIRECTION_MODE26:
                     rdata26 <= direction_mode26;
                  
                  GPR_OUTPUT_ENABLE26:
                     rdata26 <= output_enable26;
                  
                  GPR_OUTPUT_VALUE26:
                     rdata26 <= output_value26;
                  
                  GPR_INT_STATUS26:
                     rdata26 <= int_status26;
                  
                  default: // if GPR_INPUT_VALUE26 or unmapped reg addr
                     rdata26 <= input_value26;
            
               endcase
            
              end //end if read
            
            else //in not read
            
              begin // if not a valid read access, keep26 '0'-s 
              
               rdata26 <= {16 {1'b0}};
              
              end //end if not read
              
           end //end else if not reset

      end // p_read_register26


   assign pin_out26 = 
        ( output_value26 ) ;
     
   assign pin_oe_n26 = 
      ( ( ~(output_enable26 & ~(direction_mode26)) ) |
        tri_state_enable26 ) ;

                
  
endmodule // gpio_subunit26



   
   



   
