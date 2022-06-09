//File28 name   : gpio_lite_subunit28.v
//Title28       : 
//Created28     : 1999
//Description28 : Parametrised28 GPIO28 pin28 circuits28
//Notes28       : 
//----------------------------------------------------------------------
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


module gpio_lite_subunit28(
  //Inputs28

  n_reset28,
  pclk28,

  read,
  write,
  addr,

  wdata28,
  pin_in28,

  tri_state_enable28,

  //Outputs28
 
  interrupt28,

  rdata28,
  pin_oe_n28,
  pin_out28

);
 
   // Inputs28
   
   // Clocks28   
   input n_reset28;            // asynch28 reset, active low28
   input pclk28;               // Ppclk28

   // Controls28
   input read;               // select28 GPIO28 read
   input write;              // select28 GPIO28 write
   input [5:0] 
         addr;               // address bus of selected master28

   // Dataflow28
   input [15:0]
         wdata28;              // GPIO28 Input28
   input [15:0]
         pin_in28;             // input data from pin28

   //Design28 for Test28 Inputs28
   input [15:0]
         tri_state_enable28;   // disables28 op enable -> Z28




   
   // Outputs28
   
   // Controls28
   output [15:0]
          interrupt28;         // interupt28 for input pin28 change

   // Dataflow28
   output [15:0]
          rdata28;             // GPIO28 Output28
   output [15:0]
          pin_oe_n28;          // output enable signal28 to pin28
   output [15:0]
          pin_out28;           // output signal28 to pin28
   



   
   // Registers28 in module

   //Define28 Physical28 registers in amba_unit28
   reg    [15:0]
          direction_mode28;     // 1=Input28 0=Output28              RW
   reg    [15:0]
          output_enable28;      // Output28 active                 RW
   reg    [15:0]
          output_value28;       // Value outputed28 from reg       RW
   reg    [15:0]
          input_value28;        // Value input from bus          R
   reg    [15:0]
          int_status28;         // Interrupt28 status              R

   // registers to remove metastability28
   reg    [15:0]
          s_synch28;            //stage_two28
   reg    [15:0]
          s_synch_two28;        //stage_one28 - to ext pin28
   
   
    
          
   // Registers28 for outputs28
   reg    [15:0]
          rdata28;              // prdata28 reg
   wire   [15:0]
          pin_oe_n28;           // gpio28 output enable
   wire   [15:0]
          pin_out28;            // gpio28 output value
   wire   [15:0]
          interrupt28;          // gpio28 interrupt28
   wire   [15:0]
          interrupt_trigger28;  // 1 sets28 interrupt28 status
   reg    [15:0]
          status_clear28;       // 1 clears28 interrupt28 status
   wire   [15:0]
          int_event28;          // 1 detects28 an interrupt28 event

   integer ia28;                // loop variable
   


   // address decodes28
   wire   ad_direction_mode28;  // 1=Input28 0=Output28              RW
   wire   ad_output_enable28;   // Output28 active                 RW
   wire   ad_output_value28;    // Value outputed28 from reg       RW
   wire   ad_int_status28;      // Interrupt28 status              R
   
//Register addresses28
//If28 modifying28 the APB28 address (PADDR28) width change the following28 bit widths28
parameter GPR_DIRECTION_MODE28   = 6'h04;       // set pin28 to either28 I28 or O28
parameter GPR_OUTPUT_ENABLE28    = 6'h08;       // contains28 oe28 control28 value
parameter GPR_OUTPUT_VALUE28     = 6'h0C;       // output value to be driven28
parameter GPR_INPUT_VALUE28      = 6'h10;       // gpio28 input value reg
parameter GPR_INT_STATUS28       = 6'h20;       // Interrupt28 status register

//Reset28 Values28
//If28 modifying28 the GPIO28 width change the following28 bit widths28
//parameter GPRV_RSRVD28            = 32'h0000_0000; // Reserved28
parameter GPRV_DIRECTION_MODE28  = 32'h00000000; // Default to output mode
parameter GPRV_OUTPUT_ENABLE28   = 32'h00000000; // Default 3 stated28 outs28
parameter GPRV_OUTPUT_VALUE28    = 32'h00000000; // Default to be driven28
parameter GPRV_INPUT_VALUE28     = 32'h00000000; // Read defaults28 to zero
parameter GPRV_INT_STATUS28      = 32'h00000000; // Int28 status cleared28



   //assign ad_bypass_mode28    = ( addr == GPR_BYPASS_MODE28 );   
   assign ad_direction_mode28 = ( addr == GPR_DIRECTION_MODE28 );   
   assign ad_output_enable28  = ( addr == GPR_OUTPUT_ENABLE28 );   
   assign ad_output_value28   = ( addr == GPR_OUTPUT_VALUE28 );   
   assign ad_int_status28     = ( addr == GPR_INT_STATUS28 );   

   // assignments28
   
   assign interrupt28         = ( int_status28);

   assign interrupt_trigger28 = ( direction_mode28 & int_event28 ); 

   assign int_event28 = ((s_synch28 ^ input_value28) & ((s_synch28)));

   always @( ad_int_status28 or read )
   begin : p_status_clear28

     for ( ia28 = 0; ia28 < 16; ia28 = ia28 + 1 )
     begin

       status_clear28[ia28] = ( ad_int_status28 & read );

     end // for ia28

   end // p_status_clear28

   // p_write_register28 : clocked28 / asynchronous28
   //
   // this section28 contains28 all the code28 to write registers

   always @(posedge pclk28 or negedge n_reset28)
   begin : p_write_register28

      if (~n_reset28)
      
       begin
         direction_mode28  <= GPRV_DIRECTION_MODE28;
         output_enable28   <= GPRV_OUTPUT_ENABLE28;
         output_value28    <= GPRV_OUTPUT_VALUE28;
       end
      
      else 
      
       begin
      
         if (write == 1'b1) // Write value to registers
      
          begin
              
            // Write Mode28
         
            if ( ad_direction_mode28 ) 
               direction_mode28 <= wdata28;
 
            if ( ad_output_enable28 ) 
               output_enable28  <= wdata28;
     
            if ( ad_output_value28 )
               output_value28   <= wdata28;

              

           end // if write
         
       end // else: ~if(~n_reset28)
      
   end // block: p_write_register28



   // p_metastable28 : clocked28 / asynchronous28 
   //
   // This28 process  acts28 to remove  metastability28 propagation
   // Only28 for input to GPIO28
   // In Bypass28 mode pin_in28 passes28 straight28 through

   always @(posedge pclk28 or negedge n_reset28)
      
   begin : p_metastable28
      
      if (~n_reset28)
        begin
         
         s_synch28       <= {16 {1'b0}};
         s_synch_two28   <= {16 {1'b0}};
         input_value28   <= GPRV_INPUT_VALUE28;
         
        end // if (~n_reset28)
      
      else         
        begin
         
         input_value28   <= s_synch28;
         s_synch28       <= s_synch_two28;
         s_synch_two28   <= pin_in28;

        end // else: ~if(~n_reset28)
      
   end // block: p_metastable28


   // p_interrupt28 : clocked28 / asynchronous28 
   //
   // These28 lines28 set and clear the interrupt28 status

   always @(posedge pclk28 or negedge n_reset28)
   begin : p_interrupt28
      
      if (~n_reset28)
         int_status28      <= GPRV_INT_STATUS28;
      
      else 
         int_status28      <= ( int_status28 & ~(status_clear28) // read & clear
                            ) |
                            interrupt_trigger28;             // new interrupt28
        
   end // block: p_interrupt28
   
   
   // p_read_register28  : clocked28 / asynchronous28 
   //
   // this process registers the output values

   always @(posedge pclk28 or negedge n_reset28)

      begin : p_read_register28
         
         if (~n_reset28)
         
           begin

            rdata28 <= {16 {1'b0}};

           end
           
         else //if not reset
         
           begin
         
            if (read == 1'b1)
            
              begin
            
               case (addr)
            
                  
                  GPR_DIRECTION_MODE28:
                     rdata28 <= direction_mode28;
                  
                  GPR_OUTPUT_ENABLE28:
                     rdata28 <= output_enable28;
                  
                  GPR_OUTPUT_VALUE28:
                     rdata28 <= output_value28;
                  
                  GPR_INT_STATUS28:
                     rdata28 <= int_status28;
                  
                  default: // if GPR_INPUT_VALUE28 or unmapped reg addr
                     rdata28 <= input_value28;
            
               endcase
            
              end //end if read
            
            else //in not read
            
              begin // if not a valid read access, keep28 '0'-s 
              
               rdata28 <= {16 {1'b0}};
              
              end //end if not read
              
           end //end else if not reset

      end // p_read_register28


   assign pin_out28 = 
        ( output_value28 ) ;
     
   assign pin_oe_n28 = 
      ( ( ~(output_enable28 & ~(direction_mode28)) ) |
        tri_state_enable28 ) ;

                
  
endmodule // gpio_subunit28



   
   



   
