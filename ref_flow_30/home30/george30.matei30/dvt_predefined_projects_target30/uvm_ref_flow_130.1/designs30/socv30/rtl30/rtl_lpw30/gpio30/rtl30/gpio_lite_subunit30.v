//File30 name   : gpio_lite_subunit30.v
//Title30       : 
//Created30     : 1999
//Description30 : Parametrised30 GPIO30 pin30 circuits30
//Notes30       : 
//----------------------------------------------------------------------
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


module gpio_lite_subunit30(
  //Inputs30

  n_reset30,
  pclk30,

  read,
  write,
  addr,

  wdata30,
  pin_in30,

  tri_state_enable30,

  //Outputs30
 
  interrupt30,

  rdata30,
  pin_oe_n30,
  pin_out30

);
 
   // Inputs30
   
   // Clocks30   
   input n_reset30;            // asynch30 reset, active low30
   input pclk30;               // Ppclk30

   // Controls30
   input read;               // select30 GPIO30 read
   input write;              // select30 GPIO30 write
   input [5:0] 
         addr;               // address bus of selected master30

   // Dataflow30
   input [15:0]
         wdata30;              // GPIO30 Input30
   input [15:0]
         pin_in30;             // input data from pin30

   //Design30 for Test30 Inputs30
   input [15:0]
         tri_state_enable30;   // disables30 op enable -> Z30




   
   // Outputs30
   
   // Controls30
   output [15:0]
          interrupt30;         // interupt30 for input pin30 change

   // Dataflow30
   output [15:0]
          rdata30;             // GPIO30 Output30
   output [15:0]
          pin_oe_n30;          // output enable signal30 to pin30
   output [15:0]
          pin_out30;           // output signal30 to pin30
   



   
   // Registers30 in module

   //Define30 Physical30 registers in amba_unit30
   reg    [15:0]
          direction_mode30;     // 1=Input30 0=Output30              RW
   reg    [15:0]
          output_enable30;      // Output30 active                 RW
   reg    [15:0]
          output_value30;       // Value outputed30 from reg       RW
   reg    [15:0]
          input_value30;        // Value input from bus          R
   reg    [15:0]
          int_status30;         // Interrupt30 status              R

   // registers to remove metastability30
   reg    [15:0]
          s_synch30;            //stage_two30
   reg    [15:0]
          s_synch_two30;        //stage_one30 - to ext pin30
   
   
    
          
   // Registers30 for outputs30
   reg    [15:0]
          rdata30;              // prdata30 reg
   wire   [15:0]
          pin_oe_n30;           // gpio30 output enable
   wire   [15:0]
          pin_out30;            // gpio30 output value
   wire   [15:0]
          interrupt30;          // gpio30 interrupt30
   wire   [15:0]
          interrupt_trigger30;  // 1 sets30 interrupt30 status
   reg    [15:0]
          status_clear30;       // 1 clears30 interrupt30 status
   wire   [15:0]
          int_event30;          // 1 detects30 an interrupt30 event

   integer ia30;                // loop variable
   


   // address decodes30
   wire   ad_direction_mode30;  // 1=Input30 0=Output30              RW
   wire   ad_output_enable30;   // Output30 active                 RW
   wire   ad_output_value30;    // Value outputed30 from reg       RW
   wire   ad_int_status30;      // Interrupt30 status              R
   
//Register addresses30
//If30 modifying30 the APB30 address (PADDR30) width change the following30 bit widths30
parameter GPR_DIRECTION_MODE30   = 6'h04;       // set pin30 to either30 I30 or O30
parameter GPR_OUTPUT_ENABLE30    = 6'h08;       // contains30 oe30 control30 value
parameter GPR_OUTPUT_VALUE30     = 6'h0C;       // output value to be driven30
parameter GPR_INPUT_VALUE30      = 6'h10;       // gpio30 input value reg
parameter GPR_INT_STATUS30       = 6'h20;       // Interrupt30 status register

//Reset30 Values30
//If30 modifying30 the GPIO30 width change the following30 bit widths30
//parameter GPRV_RSRVD30            = 32'h0000_0000; // Reserved30
parameter GPRV_DIRECTION_MODE30  = 32'h00000000; // Default to output mode
parameter GPRV_OUTPUT_ENABLE30   = 32'h00000000; // Default 3 stated30 outs30
parameter GPRV_OUTPUT_VALUE30    = 32'h00000000; // Default to be driven30
parameter GPRV_INPUT_VALUE30     = 32'h00000000; // Read defaults30 to zero
parameter GPRV_INT_STATUS30      = 32'h00000000; // Int30 status cleared30



   //assign ad_bypass_mode30    = ( addr == GPR_BYPASS_MODE30 );   
   assign ad_direction_mode30 = ( addr == GPR_DIRECTION_MODE30 );   
   assign ad_output_enable30  = ( addr == GPR_OUTPUT_ENABLE30 );   
   assign ad_output_value30   = ( addr == GPR_OUTPUT_VALUE30 );   
   assign ad_int_status30     = ( addr == GPR_INT_STATUS30 );   

   // assignments30
   
   assign interrupt30         = ( int_status30);

   assign interrupt_trigger30 = ( direction_mode30 & int_event30 ); 

   assign int_event30 = ((s_synch30 ^ input_value30) & ((s_synch30)));

   always @( ad_int_status30 or read )
   begin : p_status_clear30

     for ( ia30 = 0; ia30 < 16; ia30 = ia30 + 1 )
     begin

       status_clear30[ia30] = ( ad_int_status30 & read );

     end // for ia30

   end // p_status_clear30

   // p_write_register30 : clocked30 / asynchronous30
   //
   // this section30 contains30 all the code30 to write registers

   always @(posedge pclk30 or negedge n_reset30)
   begin : p_write_register30

      if (~n_reset30)
      
       begin
         direction_mode30  <= GPRV_DIRECTION_MODE30;
         output_enable30   <= GPRV_OUTPUT_ENABLE30;
         output_value30    <= GPRV_OUTPUT_VALUE30;
       end
      
      else 
      
       begin
      
         if (write == 1'b1) // Write value to registers
      
          begin
              
            // Write Mode30
         
            if ( ad_direction_mode30 ) 
               direction_mode30 <= wdata30;
 
            if ( ad_output_enable30 ) 
               output_enable30  <= wdata30;
     
            if ( ad_output_value30 )
               output_value30   <= wdata30;

              

           end // if write
         
       end // else: ~if(~n_reset30)
      
   end // block: p_write_register30



   // p_metastable30 : clocked30 / asynchronous30 
   //
   // This30 process  acts30 to remove  metastability30 propagation
   // Only30 for input to GPIO30
   // In Bypass30 mode pin_in30 passes30 straight30 through

   always @(posedge pclk30 or negedge n_reset30)
      
   begin : p_metastable30
      
      if (~n_reset30)
        begin
         
         s_synch30       <= {16 {1'b0}};
         s_synch_two30   <= {16 {1'b0}};
         input_value30   <= GPRV_INPUT_VALUE30;
         
        end // if (~n_reset30)
      
      else         
        begin
         
         input_value30   <= s_synch30;
         s_synch30       <= s_synch_two30;
         s_synch_two30   <= pin_in30;

        end // else: ~if(~n_reset30)
      
   end // block: p_metastable30


   // p_interrupt30 : clocked30 / asynchronous30 
   //
   // These30 lines30 set and clear the interrupt30 status

   always @(posedge pclk30 or negedge n_reset30)
   begin : p_interrupt30
      
      if (~n_reset30)
         int_status30      <= GPRV_INT_STATUS30;
      
      else 
         int_status30      <= ( int_status30 & ~(status_clear30) // read & clear
                            ) |
                            interrupt_trigger30;             // new interrupt30
        
   end // block: p_interrupt30
   
   
   // p_read_register30  : clocked30 / asynchronous30 
   //
   // this process registers the output values

   always @(posedge pclk30 or negedge n_reset30)

      begin : p_read_register30
         
         if (~n_reset30)
         
           begin

            rdata30 <= {16 {1'b0}};

           end
           
         else //if not reset
         
           begin
         
            if (read == 1'b1)
            
              begin
            
               case (addr)
            
                  
                  GPR_DIRECTION_MODE30:
                     rdata30 <= direction_mode30;
                  
                  GPR_OUTPUT_ENABLE30:
                     rdata30 <= output_enable30;
                  
                  GPR_OUTPUT_VALUE30:
                     rdata30 <= output_value30;
                  
                  GPR_INT_STATUS30:
                     rdata30 <= int_status30;
                  
                  default: // if GPR_INPUT_VALUE30 or unmapped reg addr
                     rdata30 <= input_value30;
            
               endcase
            
              end //end if read
            
            else //in not read
            
              begin // if not a valid read access, keep30 '0'-s 
              
               rdata30 <= {16 {1'b0}};
              
              end //end if not read
              
           end //end else if not reset

      end // p_read_register30


   assign pin_out30 = 
        ( output_value30 ) ;
     
   assign pin_oe_n30 = 
      ( ( ~(output_enable30 & ~(direction_mode30)) ) |
        tri_state_enable30 ) ;

                
  
endmodule // gpio_subunit30



   
   



   
