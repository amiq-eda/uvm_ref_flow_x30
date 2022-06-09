//File23 name   : gpio_lite_subunit23.v
//Title23       : 
//Created23     : 1999
//Description23 : Parametrised23 GPIO23 pin23 circuits23
//Notes23       : 
//----------------------------------------------------------------------
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


module gpio_lite_subunit23(
  //Inputs23

  n_reset23,
  pclk23,

  read,
  write,
  addr,

  wdata23,
  pin_in23,

  tri_state_enable23,

  //Outputs23
 
  interrupt23,

  rdata23,
  pin_oe_n23,
  pin_out23

);
 
   // Inputs23
   
   // Clocks23   
   input n_reset23;            // asynch23 reset, active low23
   input pclk23;               // Ppclk23

   // Controls23
   input read;               // select23 GPIO23 read
   input write;              // select23 GPIO23 write
   input [5:0] 
         addr;               // address bus of selected master23

   // Dataflow23
   input [15:0]
         wdata23;              // GPIO23 Input23
   input [15:0]
         pin_in23;             // input data from pin23

   //Design23 for Test23 Inputs23
   input [15:0]
         tri_state_enable23;   // disables23 op enable -> Z23




   
   // Outputs23
   
   // Controls23
   output [15:0]
          interrupt23;         // interupt23 for input pin23 change

   // Dataflow23
   output [15:0]
          rdata23;             // GPIO23 Output23
   output [15:0]
          pin_oe_n23;          // output enable signal23 to pin23
   output [15:0]
          pin_out23;           // output signal23 to pin23
   



   
   // Registers23 in module

   //Define23 Physical23 registers in amba_unit23
   reg    [15:0]
          direction_mode23;     // 1=Input23 0=Output23              RW
   reg    [15:0]
          output_enable23;      // Output23 active                 RW
   reg    [15:0]
          output_value23;       // Value outputed23 from reg       RW
   reg    [15:0]
          input_value23;        // Value input from bus          R
   reg    [15:0]
          int_status23;         // Interrupt23 status              R

   // registers to remove metastability23
   reg    [15:0]
          s_synch23;            //stage_two23
   reg    [15:0]
          s_synch_two23;        //stage_one23 - to ext pin23
   
   
    
          
   // Registers23 for outputs23
   reg    [15:0]
          rdata23;              // prdata23 reg
   wire   [15:0]
          pin_oe_n23;           // gpio23 output enable
   wire   [15:0]
          pin_out23;            // gpio23 output value
   wire   [15:0]
          interrupt23;          // gpio23 interrupt23
   wire   [15:0]
          interrupt_trigger23;  // 1 sets23 interrupt23 status
   reg    [15:0]
          status_clear23;       // 1 clears23 interrupt23 status
   wire   [15:0]
          int_event23;          // 1 detects23 an interrupt23 event

   integer ia23;                // loop variable
   


   // address decodes23
   wire   ad_direction_mode23;  // 1=Input23 0=Output23              RW
   wire   ad_output_enable23;   // Output23 active                 RW
   wire   ad_output_value23;    // Value outputed23 from reg       RW
   wire   ad_int_status23;      // Interrupt23 status              R
   
//Register addresses23
//If23 modifying23 the APB23 address (PADDR23) width change the following23 bit widths23
parameter GPR_DIRECTION_MODE23   = 6'h04;       // set pin23 to either23 I23 or O23
parameter GPR_OUTPUT_ENABLE23    = 6'h08;       // contains23 oe23 control23 value
parameter GPR_OUTPUT_VALUE23     = 6'h0C;       // output value to be driven23
parameter GPR_INPUT_VALUE23      = 6'h10;       // gpio23 input value reg
parameter GPR_INT_STATUS23       = 6'h20;       // Interrupt23 status register

//Reset23 Values23
//If23 modifying23 the GPIO23 width change the following23 bit widths23
//parameter GPRV_RSRVD23            = 32'h0000_0000; // Reserved23
parameter GPRV_DIRECTION_MODE23  = 32'h00000000; // Default to output mode
parameter GPRV_OUTPUT_ENABLE23   = 32'h00000000; // Default 3 stated23 outs23
parameter GPRV_OUTPUT_VALUE23    = 32'h00000000; // Default to be driven23
parameter GPRV_INPUT_VALUE23     = 32'h00000000; // Read defaults23 to zero
parameter GPRV_INT_STATUS23      = 32'h00000000; // Int23 status cleared23



   //assign ad_bypass_mode23    = ( addr == GPR_BYPASS_MODE23 );   
   assign ad_direction_mode23 = ( addr == GPR_DIRECTION_MODE23 );   
   assign ad_output_enable23  = ( addr == GPR_OUTPUT_ENABLE23 );   
   assign ad_output_value23   = ( addr == GPR_OUTPUT_VALUE23 );   
   assign ad_int_status23     = ( addr == GPR_INT_STATUS23 );   

   // assignments23
   
   assign interrupt23         = ( int_status23);

   assign interrupt_trigger23 = ( direction_mode23 & int_event23 ); 

   assign int_event23 = ((s_synch23 ^ input_value23) & ((s_synch23)));

   always @( ad_int_status23 or read )
   begin : p_status_clear23

     for ( ia23 = 0; ia23 < 16; ia23 = ia23 + 1 )
     begin

       status_clear23[ia23] = ( ad_int_status23 & read );

     end // for ia23

   end // p_status_clear23

   // p_write_register23 : clocked23 / asynchronous23
   //
   // this section23 contains23 all the code23 to write registers

   always @(posedge pclk23 or negedge n_reset23)
   begin : p_write_register23

      if (~n_reset23)
      
       begin
         direction_mode23  <= GPRV_DIRECTION_MODE23;
         output_enable23   <= GPRV_OUTPUT_ENABLE23;
         output_value23    <= GPRV_OUTPUT_VALUE23;
       end
      
      else 
      
       begin
      
         if (write == 1'b1) // Write value to registers
      
          begin
              
            // Write Mode23
         
            if ( ad_direction_mode23 ) 
               direction_mode23 <= wdata23;
 
            if ( ad_output_enable23 ) 
               output_enable23  <= wdata23;
     
            if ( ad_output_value23 )
               output_value23   <= wdata23;

              

           end // if write
         
       end // else: ~if(~n_reset23)
      
   end // block: p_write_register23



   // p_metastable23 : clocked23 / asynchronous23 
   //
   // This23 process  acts23 to remove  metastability23 propagation
   // Only23 for input to GPIO23
   // In Bypass23 mode pin_in23 passes23 straight23 through

   always @(posedge pclk23 or negedge n_reset23)
      
   begin : p_metastable23
      
      if (~n_reset23)
        begin
         
         s_synch23       <= {16 {1'b0}};
         s_synch_two23   <= {16 {1'b0}};
         input_value23   <= GPRV_INPUT_VALUE23;
         
        end // if (~n_reset23)
      
      else         
        begin
         
         input_value23   <= s_synch23;
         s_synch23       <= s_synch_two23;
         s_synch_two23   <= pin_in23;

        end // else: ~if(~n_reset23)
      
   end // block: p_metastable23


   // p_interrupt23 : clocked23 / asynchronous23 
   //
   // These23 lines23 set and clear the interrupt23 status

   always @(posedge pclk23 or negedge n_reset23)
   begin : p_interrupt23
      
      if (~n_reset23)
         int_status23      <= GPRV_INT_STATUS23;
      
      else 
         int_status23      <= ( int_status23 & ~(status_clear23) // read & clear
                            ) |
                            interrupt_trigger23;             // new interrupt23
        
   end // block: p_interrupt23
   
   
   // p_read_register23  : clocked23 / asynchronous23 
   //
   // this process registers the output values

   always @(posedge pclk23 or negedge n_reset23)

      begin : p_read_register23
         
         if (~n_reset23)
         
           begin

            rdata23 <= {16 {1'b0}};

           end
           
         else //if not reset
         
           begin
         
            if (read == 1'b1)
            
              begin
            
               case (addr)
            
                  
                  GPR_DIRECTION_MODE23:
                     rdata23 <= direction_mode23;
                  
                  GPR_OUTPUT_ENABLE23:
                     rdata23 <= output_enable23;
                  
                  GPR_OUTPUT_VALUE23:
                     rdata23 <= output_value23;
                  
                  GPR_INT_STATUS23:
                     rdata23 <= int_status23;
                  
                  default: // if GPR_INPUT_VALUE23 or unmapped reg addr
                     rdata23 <= input_value23;
            
               endcase
            
              end //end if read
            
            else //in not read
            
              begin // if not a valid read access, keep23 '0'-s 
              
               rdata23 <= {16 {1'b0}};
              
              end //end if not read
              
           end //end else if not reset

      end // p_read_register23


   assign pin_out23 = 
        ( output_value23 ) ;
     
   assign pin_oe_n23 = 
      ( ( ~(output_enable23 & ~(direction_mode23)) ) |
        tri_state_enable23 ) ;

                
  
endmodule // gpio_subunit23



   
   



   
