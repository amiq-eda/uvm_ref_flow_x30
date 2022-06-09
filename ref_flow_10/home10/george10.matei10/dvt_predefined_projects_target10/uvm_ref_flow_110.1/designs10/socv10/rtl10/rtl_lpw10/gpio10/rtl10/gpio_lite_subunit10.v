//File10 name   : gpio_lite_subunit10.v
//Title10       : 
//Created10     : 1999
//Description10 : Parametrised10 GPIO10 pin10 circuits10
//Notes10       : 
//----------------------------------------------------------------------
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


module gpio_lite_subunit10(
  //Inputs10

  n_reset10,
  pclk10,

  read,
  write,
  addr,

  wdata10,
  pin_in10,

  tri_state_enable10,

  //Outputs10
 
  interrupt10,

  rdata10,
  pin_oe_n10,
  pin_out10

);
 
   // Inputs10
   
   // Clocks10   
   input n_reset10;            // asynch10 reset, active low10
   input pclk10;               // Ppclk10

   // Controls10
   input read;               // select10 GPIO10 read
   input write;              // select10 GPIO10 write
   input [5:0] 
         addr;               // address bus of selected master10

   // Dataflow10
   input [15:0]
         wdata10;              // GPIO10 Input10
   input [15:0]
         pin_in10;             // input data from pin10

   //Design10 for Test10 Inputs10
   input [15:0]
         tri_state_enable10;   // disables10 op enable -> Z10




   
   // Outputs10
   
   // Controls10
   output [15:0]
          interrupt10;         // interupt10 for input pin10 change

   // Dataflow10
   output [15:0]
          rdata10;             // GPIO10 Output10
   output [15:0]
          pin_oe_n10;          // output enable signal10 to pin10
   output [15:0]
          pin_out10;           // output signal10 to pin10
   



   
   // Registers10 in module

   //Define10 Physical10 registers in amba_unit10
   reg    [15:0]
          direction_mode10;     // 1=Input10 0=Output10              RW
   reg    [15:0]
          output_enable10;      // Output10 active                 RW
   reg    [15:0]
          output_value10;       // Value outputed10 from reg       RW
   reg    [15:0]
          input_value10;        // Value input from bus          R
   reg    [15:0]
          int_status10;         // Interrupt10 status              R

   // registers to remove metastability10
   reg    [15:0]
          s_synch10;            //stage_two10
   reg    [15:0]
          s_synch_two10;        //stage_one10 - to ext pin10
   
   
    
          
   // Registers10 for outputs10
   reg    [15:0]
          rdata10;              // prdata10 reg
   wire   [15:0]
          pin_oe_n10;           // gpio10 output enable
   wire   [15:0]
          pin_out10;            // gpio10 output value
   wire   [15:0]
          interrupt10;          // gpio10 interrupt10
   wire   [15:0]
          interrupt_trigger10;  // 1 sets10 interrupt10 status
   reg    [15:0]
          status_clear10;       // 1 clears10 interrupt10 status
   wire   [15:0]
          int_event10;          // 1 detects10 an interrupt10 event

   integer ia10;                // loop variable
   


   // address decodes10
   wire   ad_direction_mode10;  // 1=Input10 0=Output10              RW
   wire   ad_output_enable10;   // Output10 active                 RW
   wire   ad_output_value10;    // Value outputed10 from reg       RW
   wire   ad_int_status10;      // Interrupt10 status              R
   
//Register addresses10
//If10 modifying10 the APB10 address (PADDR10) width change the following10 bit widths10
parameter GPR_DIRECTION_MODE10   = 6'h04;       // set pin10 to either10 I10 or O10
parameter GPR_OUTPUT_ENABLE10    = 6'h08;       // contains10 oe10 control10 value
parameter GPR_OUTPUT_VALUE10     = 6'h0C;       // output value to be driven10
parameter GPR_INPUT_VALUE10      = 6'h10;       // gpio10 input value reg
parameter GPR_INT_STATUS10       = 6'h20;       // Interrupt10 status register

//Reset10 Values10
//If10 modifying10 the GPIO10 width change the following10 bit widths10
//parameter GPRV_RSRVD10            = 32'h0000_0000; // Reserved10
parameter GPRV_DIRECTION_MODE10  = 32'h00000000; // Default to output mode
parameter GPRV_OUTPUT_ENABLE10   = 32'h00000000; // Default 3 stated10 outs10
parameter GPRV_OUTPUT_VALUE10    = 32'h00000000; // Default to be driven10
parameter GPRV_INPUT_VALUE10     = 32'h00000000; // Read defaults10 to zero
parameter GPRV_INT_STATUS10      = 32'h00000000; // Int10 status cleared10



   //assign ad_bypass_mode10    = ( addr == GPR_BYPASS_MODE10 );   
   assign ad_direction_mode10 = ( addr == GPR_DIRECTION_MODE10 );   
   assign ad_output_enable10  = ( addr == GPR_OUTPUT_ENABLE10 );   
   assign ad_output_value10   = ( addr == GPR_OUTPUT_VALUE10 );   
   assign ad_int_status10     = ( addr == GPR_INT_STATUS10 );   

   // assignments10
   
   assign interrupt10         = ( int_status10);

   assign interrupt_trigger10 = ( direction_mode10 & int_event10 ); 

   assign int_event10 = ((s_synch10 ^ input_value10) & ((s_synch10)));

   always @( ad_int_status10 or read )
   begin : p_status_clear10

     for ( ia10 = 0; ia10 < 16; ia10 = ia10 + 1 )
     begin

       status_clear10[ia10] = ( ad_int_status10 & read );

     end // for ia10

   end // p_status_clear10

   // p_write_register10 : clocked10 / asynchronous10
   //
   // this section10 contains10 all the code10 to write registers

   always @(posedge pclk10 or negedge n_reset10)
   begin : p_write_register10

      if (~n_reset10)
      
       begin
         direction_mode10  <= GPRV_DIRECTION_MODE10;
         output_enable10   <= GPRV_OUTPUT_ENABLE10;
         output_value10    <= GPRV_OUTPUT_VALUE10;
       end
      
      else 
      
       begin
      
         if (write == 1'b1) // Write value to registers
      
          begin
              
            // Write Mode10
         
            if ( ad_direction_mode10 ) 
               direction_mode10 <= wdata10;
 
            if ( ad_output_enable10 ) 
               output_enable10  <= wdata10;
     
            if ( ad_output_value10 )
               output_value10   <= wdata10;

              

           end // if write
         
       end // else: ~if(~n_reset10)
      
   end // block: p_write_register10



   // p_metastable10 : clocked10 / asynchronous10 
   //
   // This10 process  acts10 to remove  metastability10 propagation
   // Only10 for input to GPIO10
   // In Bypass10 mode pin_in10 passes10 straight10 through

   always @(posedge pclk10 or negedge n_reset10)
      
   begin : p_metastable10
      
      if (~n_reset10)
        begin
         
         s_synch10       <= {16 {1'b0}};
         s_synch_two10   <= {16 {1'b0}};
         input_value10   <= GPRV_INPUT_VALUE10;
         
        end // if (~n_reset10)
      
      else         
        begin
         
         input_value10   <= s_synch10;
         s_synch10       <= s_synch_two10;
         s_synch_two10   <= pin_in10;

        end // else: ~if(~n_reset10)
      
   end // block: p_metastable10


   // p_interrupt10 : clocked10 / asynchronous10 
   //
   // These10 lines10 set and clear the interrupt10 status

   always @(posedge pclk10 or negedge n_reset10)
   begin : p_interrupt10
      
      if (~n_reset10)
         int_status10      <= GPRV_INT_STATUS10;
      
      else 
         int_status10      <= ( int_status10 & ~(status_clear10) // read & clear
                            ) |
                            interrupt_trigger10;             // new interrupt10
        
   end // block: p_interrupt10
   
   
   // p_read_register10  : clocked10 / asynchronous10 
   //
   // this process registers the output values

   always @(posedge pclk10 or negedge n_reset10)

      begin : p_read_register10
         
         if (~n_reset10)
         
           begin

            rdata10 <= {16 {1'b0}};

           end
           
         else //if not reset
         
           begin
         
            if (read == 1'b1)
            
              begin
            
               case (addr)
            
                  
                  GPR_DIRECTION_MODE10:
                     rdata10 <= direction_mode10;
                  
                  GPR_OUTPUT_ENABLE10:
                     rdata10 <= output_enable10;
                  
                  GPR_OUTPUT_VALUE10:
                     rdata10 <= output_value10;
                  
                  GPR_INT_STATUS10:
                     rdata10 <= int_status10;
                  
                  default: // if GPR_INPUT_VALUE10 or unmapped reg addr
                     rdata10 <= input_value10;
            
               endcase
            
              end //end if read
            
            else //in not read
            
              begin // if not a valid read access, keep10 '0'-s 
              
               rdata10 <= {16 {1'b0}};
              
              end //end if not read
              
           end //end else if not reset

      end // p_read_register10


   assign pin_out10 = 
        ( output_value10 ) ;
     
   assign pin_oe_n10 = 
      ( ( ~(output_enable10 & ~(direction_mode10)) ) |
        tri_state_enable10 ) ;

                
  
endmodule // gpio_subunit10



   
   



   
