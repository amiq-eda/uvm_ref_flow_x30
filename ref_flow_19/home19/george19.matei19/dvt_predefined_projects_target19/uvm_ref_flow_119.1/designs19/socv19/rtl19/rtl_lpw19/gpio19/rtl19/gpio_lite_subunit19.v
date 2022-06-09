//File19 name   : gpio_lite_subunit19.v
//Title19       : 
//Created19     : 1999
//Description19 : Parametrised19 GPIO19 pin19 circuits19
//Notes19       : 
//----------------------------------------------------------------------
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


module gpio_lite_subunit19(
  //Inputs19

  n_reset19,
  pclk19,

  read,
  write,
  addr,

  wdata19,
  pin_in19,

  tri_state_enable19,

  //Outputs19
 
  interrupt19,

  rdata19,
  pin_oe_n19,
  pin_out19

);
 
   // Inputs19
   
   // Clocks19   
   input n_reset19;            // asynch19 reset, active low19
   input pclk19;               // Ppclk19

   // Controls19
   input read;               // select19 GPIO19 read
   input write;              // select19 GPIO19 write
   input [5:0] 
         addr;               // address bus of selected master19

   // Dataflow19
   input [15:0]
         wdata19;              // GPIO19 Input19
   input [15:0]
         pin_in19;             // input data from pin19

   //Design19 for Test19 Inputs19
   input [15:0]
         tri_state_enable19;   // disables19 op enable -> Z19




   
   // Outputs19
   
   // Controls19
   output [15:0]
          interrupt19;         // interupt19 for input pin19 change

   // Dataflow19
   output [15:0]
          rdata19;             // GPIO19 Output19
   output [15:0]
          pin_oe_n19;          // output enable signal19 to pin19
   output [15:0]
          pin_out19;           // output signal19 to pin19
   



   
   // Registers19 in module

   //Define19 Physical19 registers in amba_unit19
   reg    [15:0]
          direction_mode19;     // 1=Input19 0=Output19              RW
   reg    [15:0]
          output_enable19;      // Output19 active                 RW
   reg    [15:0]
          output_value19;       // Value outputed19 from reg       RW
   reg    [15:0]
          input_value19;        // Value input from bus          R
   reg    [15:0]
          int_status19;         // Interrupt19 status              R

   // registers to remove metastability19
   reg    [15:0]
          s_synch19;            //stage_two19
   reg    [15:0]
          s_synch_two19;        //stage_one19 - to ext pin19
   
   
    
          
   // Registers19 for outputs19
   reg    [15:0]
          rdata19;              // prdata19 reg
   wire   [15:0]
          pin_oe_n19;           // gpio19 output enable
   wire   [15:0]
          pin_out19;            // gpio19 output value
   wire   [15:0]
          interrupt19;          // gpio19 interrupt19
   wire   [15:0]
          interrupt_trigger19;  // 1 sets19 interrupt19 status
   reg    [15:0]
          status_clear19;       // 1 clears19 interrupt19 status
   wire   [15:0]
          int_event19;          // 1 detects19 an interrupt19 event

   integer ia19;                // loop variable
   


   // address decodes19
   wire   ad_direction_mode19;  // 1=Input19 0=Output19              RW
   wire   ad_output_enable19;   // Output19 active                 RW
   wire   ad_output_value19;    // Value outputed19 from reg       RW
   wire   ad_int_status19;      // Interrupt19 status              R
   
//Register addresses19
//If19 modifying19 the APB19 address (PADDR19) width change the following19 bit widths19
parameter GPR_DIRECTION_MODE19   = 6'h04;       // set pin19 to either19 I19 or O19
parameter GPR_OUTPUT_ENABLE19    = 6'h08;       // contains19 oe19 control19 value
parameter GPR_OUTPUT_VALUE19     = 6'h0C;       // output value to be driven19
parameter GPR_INPUT_VALUE19      = 6'h10;       // gpio19 input value reg
parameter GPR_INT_STATUS19       = 6'h20;       // Interrupt19 status register

//Reset19 Values19
//If19 modifying19 the GPIO19 width change the following19 bit widths19
//parameter GPRV_RSRVD19            = 32'h0000_0000; // Reserved19
parameter GPRV_DIRECTION_MODE19  = 32'h00000000; // Default to output mode
parameter GPRV_OUTPUT_ENABLE19   = 32'h00000000; // Default 3 stated19 outs19
parameter GPRV_OUTPUT_VALUE19    = 32'h00000000; // Default to be driven19
parameter GPRV_INPUT_VALUE19     = 32'h00000000; // Read defaults19 to zero
parameter GPRV_INT_STATUS19      = 32'h00000000; // Int19 status cleared19



   //assign ad_bypass_mode19    = ( addr == GPR_BYPASS_MODE19 );   
   assign ad_direction_mode19 = ( addr == GPR_DIRECTION_MODE19 );   
   assign ad_output_enable19  = ( addr == GPR_OUTPUT_ENABLE19 );   
   assign ad_output_value19   = ( addr == GPR_OUTPUT_VALUE19 );   
   assign ad_int_status19     = ( addr == GPR_INT_STATUS19 );   

   // assignments19
   
   assign interrupt19         = ( int_status19);

   assign interrupt_trigger19 = ( direction_mode19 & int_event19 ); 

   assign int_event19 = ((s_synch19 ^ input_value19) & ((s_synch19)));

   always @( ad_int_status19 or read )
   begin : p_status_clear19

     for ( ia19 = 0; ia19 < 16; ia19 = ia19 + 1 )
     begin

       status_clear19[ia19] = ( ad_int_status19 & read );

     end // for ia19

   end // p_status_clear19

   // p_write_register19 : clocked19 / asynchronous19
   //
   // this section19 contains19 all the code19 to write registers

   always @(posedge pclk19 or negedge n_reset19)
   begin : p_write_register19

      if (~n_reset19)
      
       begin
         direction_mode19  <= GPRV_DIRECTION_MODE19;
         output_enable19   <= GPRV_OUTPUT_ENABLE19;
         output_value19    <= GPRV_OUTPUT_VALUE19;
       end
      
      else 
      
       begin
      
         if (write == 1'b1) // Write value to registers
      
          begin
              
            // Write Mode19
         
            if ( ad_direction_mode19 ) 
               direction_mode19 <= wdata19;
 
            if ( ad_output_enable19 ) 
               output_enable19  <= wdata19;
     
            if ( ad_output_value19 )
               output_value19   <= wdata19;

              

           end // if write
         
       end // else: ~if(~n_reset19)
      
   end // block: p_write_register19



   // p_metastable19 : clocked19 / asynchronous19 
   //
   // This19 process  acts19 to remove  metastability19 propagation
   // Only19 for input to GPIO19
   // In Bypass19 mode pin_in19 passes19 straight19 through

   always @(posedge pclk19 or negedge n_reset19)
      
   begin : p_metastable19
      
      if (~n_reset19)
        begin
         
         s_synch19       <= {16 {1'b0}};
         s_synch_two19   <= {16 {1'b0}};
         input_value19   <= GPRV_INPUT_VALUE19;
         
        end // if (~n_reset19)
      
      else         
        begin
         
         input_value19   <= s_synch19;
         s_synch19       <= s_synch_two19;
         s_synch_two19   <= pin_in19;

        end // else: ~if(~n_reset19)
      
   end // block: p_metastable19


   // p_interrupt19 : clocked19 / asynchronous19 
   //
   // These19 lines19 set and clear the interrupt19 status

   always @(posedge pclk19 or negedge n_reset19)
   begin : p_interrupt19
      
      if (~n_reset19)
         int_status19      <= GPRV_INT_STATUS19;
      
      else 
         int_status19      <= ( int_status19 & ~(status_clear19) // read & clear
                            ) |
                            interrupt_trigger19;             // new interrupt19
        
   end // block: p_interrupt19
   
   
   // p_read_register19  : clocked19 / asynchronous19 
   //
   // this process registers the output values

   always @(posedge pclk19 or negedge n_reset19)

      begin : p_read_register19
         
         if (~n_reset19)
         
           begin

            rdata19 <= {16 {1'b0}};

           end
           
         else //if not reset
         
           begin
         
            if (read == 1'b1)
            
              begin
            
               case (addr)
            
                  
                  GPR_DIRECTION_MODE19:
                     rdata19 <= direction_mode19;
                  
                  GPR_OUTPUT_ENABLE19:
                     rdata19 <= output_enable19;
                  
                  GPR_OUTPUT_VALUE19:
                     rdata19 <= output_value19;
                  
                  GPR_INT_STATUS19:
                     rdata19 <= int_status19;
                  
                  default: // if GPR_INPUT_VALUE19 or unmapped reg addr
                     rdata19 <= input_value19;
            
               endcase
            
              end //end if read
            
            else //in not read
            
              begin // if not a valid read access, keep19 '0'-s 
              
               rdata19 <= {16 {1'b0}};
              
              end //end if not read
              
           end //end else if not reset

      end // p_read_register19


   assign pin_out19 = 
        ( output_value19 ) ;
     
   assign pin_oe_n19 = 
      ( ( ~(output_enable19 & ~(direction_mode19)) ) |
        tri_state_enable19 ) ;

                
  
endmodule // gpio_subunit19



   
   



   
