//File22 name   : gpio_lite_subunit22.v
//Title22       : 
//Created22     : 1999
//Description22 : Parametrised22 GPIO22 pin22 circuits22
//Notes22       : 
//----------------------------------------------------------------------
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


module gpio_lite_subunit22(
  //Inputs22

  n_reset22,
  pclk22,

  read,
  write,
  addr,

  wdata22,
  pin_in22,

  tri_state_enable22,

  //Outputs22
 
  interrupt22,

  rdata22,
  pin_oe_n22,
  pin_out22

);
 
   // Inputs22
   
   // Clocks22   
   input n_reset22;            // asynch22 reset, active low22
   input pclk22;               // Ppclk22

   // Controls22
   input read;               // select22 GPIO22 read
   input write;              // select22 GPIO22 write
   input [5:0] 
         addr;               // address bus of selected master22

   // Dataflow22
   input [15:0]
         wdata22;              // GPIO22 Input22
   input [15:0]
         pin_in22;             // input data from pin22

   //Design22 for Test22 Inputs22
   input [15:0]
         tri_state_enable22;   // disables22 op enable -> Z22




   
   // Outputs22
   
   // Controls22
   output [15:0]
          interrupt22;         // interupt22 for input pin22 change

   // Dataflow22
   output [15:0]
          rdata22;             // GPIO22 Output22
   output [15:0]
          pin_oe_n22;          // output enable signal22 to pin22
   output [15:0]
          pin_out22;           // output signal22 to pin22
   



   
   // Registers22 in module

   //Define22 Physical22 registers in amba_unit22
   reg    [15:0]
          direction_mode22;     // 1=Input22 0=Output22              RW
   reg    [15:0]
          output_enable22;      // Output22 active                 RW
   reg    [15:0]
          output_value22;       // Value outputed22 from reg       RW
   reg    [15:0]
          input_value22;        // Value input from bus          R
   reg    [15:0]
          int_status22;         // Interrupt22 status              R

   // registers to remove metastability22
   reg    [15:0]
          s_synch22;            //stage_two22
   reg    [15:0]
          s_synch_two22;        //stage_one22 - to ext pin22
   
   
    
          
   // Registers22 for outputs22
   reg    [15:0]
          rdata22;              // prdata22 reg
   wire   [15:0]
          pin_oe_n22;           // gpio22 output enable
   wire   [15:0]
          pin_out22;            // gpio22 output value
   wire   [15:0]
          interrupt22;          // gpio22 interrupt22
   wire   [15:0]
          interrupt_trigger22;  // 1 sets22 interrupt22 status
   reg    [15:0]
          status_clear22;       // 1 clears22 interrupt22 status
   wire   [15:0]
          int_event22;          // 1 detects22 an interrupt22 event

   integer ia22;                // loop variable
   


   // address decodes22
   wire   ad_direction_mode22;  // 1=Input22 0=Output22              RW
   wire   ad_output_enable22;   // Output22 active                 RW
   wire   ad_output_value22;    // Value outputed22 from reg       RW
   wire   ad_int_status22;      // Interrupt22 status              R
   
//Register addresses22
//If22 modifying22 the APB22 address (PADDR22) width change the following22 bit widths22
parameter GPR_DIRECTION_MODE22   = 6'h04;       // set pin22 to either22 I22 or O22
parameter GPR_OUTPUT_ENABLE22    = 6'h08;       // contains22 oe22 control22 value
parameter GPR_OUTPUT_VALUE22     = 6'h0C;       // output value to be driven22
parameter GPR_INPUT_VALUE22      = 6'h10;       // gpio22 input value reg
parameter GPR_INT_STATUS22       = 6'h20;       // Interrupt22 status register

//Reset22 Values22
//If22 modifying22 the GPIO22 width change the following22 bit widths22
//parameter GPRV_RSRVD22            = 32'h0000_0000; // Reserved22
parameter GPRV_DIRECTION_MODE22  = 32'h00000000; // Default to output mode
parameter GPRV_OUTPUT_ENABLE22   = 32'h00000000; // Default 3 stated22 outs22
parameter GPRV_OUTPUT_VALUE22    = 32'h00000000; // Default to be driven22
parameter GPRV_INPUT_VALUE22     = 32'h00000000; // Read defaults22 to zero
parameter GPRV_INT_STATUS22      = 32'h00000000; // Int22 status cleared22



   //assign ad_bypass_mode22    = ( addr == GPR_BYPASS_MODE22 );   
   assign ad_direction_mode22 = ( addr == GPR_DIRECTION_MODE22 );   
   assign ad_output_enable22  = ( addr == GPR_OUTPUT_ENABLE22 );   
   assign ad_output_value22   = ( addr == GPR_OUTPUT_VALUE22 );   
   assign ad_int_status22     = ( addr == GPR_INT_STATUS22 );   

   // assignments22
   
   assign interrupt22         = ( int_status22);

   assign interrupt_trigger22 = ( direction_mode22 & int_event22 ); 

   assign int_event22 = ((s_synch22 ^ input_value22) & ((s_synch22)));

   always @( ad_int_status22 or read )
   begin : p_status_clear22

     for ( ia22 = 0; ia22 < 16; ia22 = ia22 + 1 )
     begin

       status_clear22[ia22] = ( ad_int_status22 & read );

     end // for ia22

   end // p_status_clear22

   // p_write_register22 : clocked22 / asynchronous22
   //
   // this section22 contains22 all the code22 to write registers

   always @(posedge pclk22 or negedge n_reset22)
   begin : p_write_register22

      if (~n_reset22)
      
       begin
         direction_mode22  <= GPRV_DIRECTION_MODE22;
         output_enable22   <= GPRV_OUTPUT_ENABLE22;
         output_value22    <= GPRV_OUTPUT_VALUE22;
       end
      
      else 
      
       begin
      
         if (write == 1'b1) // Write value to registers
      
          begin
              
            // Write Mode22
         
            if ( ad_direction_mode22 ) 
               direction_mode22 <= wdata22;
 
            if ( ad_output_enable22 ) 
               output_enable22  <= wdata22;
     
            if ( ad_output_value22 )
               output_value22   <= wdata22;

              

           end // if write
         
       end // else: ~if(~n_reset22)
      
   end // block: p_write_register22



   // p_metastable22 : clocked22 / asynchronous22 
   //
   // This22 process  acts22 to remove  metastability22 propagation
   // Only22 for input to GPIO22
   // In Bypass22 mode pin_in22 passes22 straight22 through

   always @(posedge pclk22 or negedge n_reset22)
      
   begin : p_metastable22
      
      if (~n_reset22)
        begin
         
         s_synch22       <= {16 {1'b0}};
         s_synch_two22   <= {16 {1'b0}};
         input_value22   <= GPRV_INPUT_VALUE22;
         
        end // if (~n_reset22)
      
      else         
        begin
         
         input_value22   <= s_synch22;
         s_synch22       <= s_synch_two22;
         s_synch_two22   <= pin_in22;

        end // else: ~if(~n_reset22)
      
   end // block: p_metastable22


   // p_interrupt22 : clocked22 / asynchronous22 
   //
   // These22 lines22 set and clear the interrupt22 status

   always @(posedge pclk22 or negedge n_reset22)
   begin : p_interrupt22
      
      if (~n_reset22)
         int_status22      <= GPRV_INT_STATUS22;
      
      else 
         int_status22      <= ( int_status22 & ~(status_clear22) // read & clear
                            ) |
                            interrupt_trigger22;             // new interrupt22
        
   end // block: p_interrupt22
   
   
   // p_read_register22  : clocked22 / asynchronous22 
   //
   // this process registers the output values

   always @(posedge pclk22 or negedge n_reset22)

      begin : p_read_register22
         
         if (~n_reset22)
         
           begin

            rdata22 <= {16 {1'b0}};

           end
           
         else //if not reset
         
           begin
         
            if (read == 1'b1)
            
              begin
            
               case (addr)
            
                  
                  GPR_DIRECTION_MODE22:
                     rdata22 <= direction_mode22;
                  
                  GPR_OUTPUT_ENABLE22:
                     rdata22 <= output_enable22;
                  
                  GPR_OUTPUT_VALUE22:
                     rdata22 <= output_value22;
                  
                  GPR_INT_STATUS22:
                     rdata22 <= int_status22;
                  
                  default: // if GPR_INPUT_VALUE22 or unmapped reg addr
                     rdata22 <= input_value22;
            
               endcase
            
              end //end if read
            
            else //in not read
            
              begin // if not a valid read access, keep22 '0'-s 
              
               rdata22 <= {16 {1'b0}};
              
              end //end if not read
              
           end //end else if not reset

      end // p_read_register22


   assign pin_out22 = 
        ( output_value22 ) ;
     
   assign pin_oe_n22 = 
      ( ( ~(output_enable22 & ~(direction_mode22)) ) |
        tri_state_enable22 ) ;

                
  
endmodule // gpio_subunit22



   
   



   
