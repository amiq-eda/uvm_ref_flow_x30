//File3 name   : gpio_lite_subunit3.v
//Title3       : 
//Created3     : 1999
//Description3 : Parametrised3 GPIO3 pin3 circuits3
//Notes3       : 
//----------------------------------------------------------------------
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


module gpio_lite_subunit3(
  //Inputs3

  n_reset3,
  pclk3,

  read,
  write,
  addr,

  wdata3,
  pin_in3,

  tri_state_enable3,

  //Outputs3
 
  interrupt3,

  rdata3,
  pin_oe_n3,
  pin_out3

);
 
   // Inputs3
   
   // Clocks3   
   input n_reset3;            // asynch3 reset, active low3
   input pclk3;               // Ppclk3

   // Controls3
   input read;               // select3 GPIO3 read
   input write;              // select3 GPIO3 write
   input [5:0] 
         addr;               // address bus of selected master3

   // Dataflow3
   input [15:0]
         wdata3;              // GPIO3 Input3
   input [15:0]
         pin_in3;             // input data from pin3

   //Design3 for Test3 Inputs3
   input [15:0]
         tri_state_enable3;   // disables3 op enable -> Z3




   
   // Outputs3
   
   // Controls3
   output [15:0]
          interrupt3;         // interupt3 for input pin3 change

   // Dataflow3
   output [15:0]
          rdata3;             // GPIO3 Output3
   output [15:0]
          pin_oe_n3;          // output enable signal3 to pin3
   output [15:0]
          pin_out3;           // output signal3 to pin3
   



   
   // Registers3 in module

   //Define3 Physical3 registers in amba_unit3
   reg    [15:0]
          direction_mode3;     // 1=Input3 0=Output3              RW
   reg    [15:0]
          output_enable3;      // Output3 active                 RW
   reg    [15:0]
          output_value3;       // Value outputed3 from reg       RW
   reg    [15:0]
          input_value3;        // Value input from bus          R
   reg    [15:0]
          int_status3;         // Interrupt3 status              R

   // registers to remove metastability3
   reg    [15:0]
          s_synch3;            //stage_two3
   reg    [15:0]
          s_synch_two3;        //stage_one3 - to ext pin3
   
   
    
          
   // Registers3 for outputs3
   reg    [15:0]
          rdata3;              // prdata3 reg
   wire   [15:0]
          pin_oe_n3;           // gpio3 output enable
   wire   [15:0]
          pin_out3;            // gpio3 output value
   wire   [15:0]
          interrupt3;          // gpio3 interrupt3
   wire   [15:0]
          interrupt_trigger3;  // 1 sets3 interrupt3 status
   reg    [15:0]
          status_clear3;       // 1 clears3 interrupt3 status
   wire   [15:0]
          int_event3;          // 1 detects3 an interrupt3 event

   integer ia3;                // loop variable
   


   // address decodes3
   wire   ad_direction_mode3;  // 1=Input3 0=Output3              RW
   wire   ad_output_enable3;   // Output3 active                 RW
   wire   ad_output_value3;    // Value outputed3 from reg       RW
   wire   ad_int_status3;      // Interrupt3 status              R
   
//Register addresses3
//If3 modifying3 the APB3 address (PADDR3) width change the following3 bit widths3
parameter GPR_DIRECTION_MODE3   = 6'h04;       // set pin3 to either3 I3 or O3
parameter GPR_OUTPUT_ENABLE3    = 6'h08;       // contains3 oe3 control3 value
parameter GPR_OUTPUT_VALUE3     = 6'h0C;       // output value to be driven3
parameter GPR_INPUT_VALUE3      = 6'h10;       // gpio3 input value reg
parameter GPR_INT_STATUS3       = 6'h20;       // Interrupt3 status register

//Reset3 Values3
//If3 modifying3 the GPIO3 width change the following3 bit widths3
//parameter GPRV_RSRVD3            = 32'h0000_0000; // Reserved3
parameter GPRV_DIRECTION_MODE3  = 32'h00000000; // Default to output mode
parameter GPRV_OUTPUT_ENABLE3   = 32'h00000000; // Default 3 stated3 outs3
parameter GPRV_OUTPUT_VALUE3    = 32'h00000000; // Default to be driven3
parameter GPRV_INPUT_VALUE3     = 32'h00000000; // Read defaults3 to zero
parameter GPRV_INT_STATUS3      = 32'h00000000; // Int3 status cleared3



   //assign ad_bypass_mode3    = ( addr == GPR_BYPASS_MODE3 );   
   assign ad_direction_mode3 = ( addr == GPR_DIRECTION_MODE3 );   
   assign ad_output_enable3  = ( addr == GPR_OUTPUT_ENABLE3 );   
   assign ad_output_value3   = ( addr == GPR_OUTPUT_VALUE3 );   
   assign ad_int_status3     = ( addr == GPR_INT_STATUS3 );   

   // assignments3
   
   assign interrupt3         = ( int_status3);

   assign interrupt_trigger3 = ( direction_mode3 & int_event3 ); 

   assign int_event3 = ((s_synch3 ^ input_value3) & ((s_synch3)));

   always @( ad_int_status3 or read )
   begin : p_status_clear3

     for ( ia3 = 0; ia3 < 16; ia3 = ia3 + 1 )
     begin

       status_clear3[ia3] = ( ad_int_status3 & read );

     end // for ia3

   end // p_status_clear3

   // p_write_register3 : clocked3 / asynchronous3
   //
   // this section3 contains3 all the code3 to write registers

   always @(posedge pclk3 or negedge n_reset3)
   begin : p_write_register3

      if (~n_reset3)
      
       begin
         direction_mode3  <= GPRV_DIRECTION_MODE3;
         output_enable3   <= GPRV_OUTPUT_ENABLE3;
         output_value3    <= GPRV_OUTPUT_VALUE3;
       end
      
      else 
      
       begin
      
         if (write == 1'b1) // Write value to registers
      
          begin
              
            // Write Mode3
         
            if ( ad_direction_mode3 ) 
               direction_mode3 <= wdata3;
 
            if ( ad_output_enable3 ) 
               output_enable3  <= wdata3;
     
            if ( ad_output_value3 )
               output_value3   <= wdata3;

              

           end // if write
         
       end // else: ~if(~n_reset3)
      
   end // block: p_write_register3



   // p_metastable3 : clocked3 / asynchronous3 
   //
   // This3 process  acts3 to remove  metastability3 propagation
   // Only3 for input to GPIO3
   // In Bypass3 mode pin_in3 passes3 straight3 through

   always @(posedge pclk3 or negedge n_reset3)
      
   begin : p_metastable3
      
      if (~n_reset3)
        begin
         
         s_synch3       <= {16 {1'b0}};
         s_synch_two3   <= {16 {1'b0}};
         input_value3   <= GPRV_INPUT_VALUE3;
         
        end // if (~n_reset3)
      
      else         
        begin
         
         input_value3   <= s_synch3;
         s_synch3       <= s_synch_two3;
         s_synch_two3   <= pin_in3;

        end // else: ~if(~n_reset3)
      
   end // block: p_metastable3


   // p_interrupt3 : clocked3 / asynchronous3 
   //
   // These3 lines3 set and clear the interrupt3 status

   always @(posedge pclk3 or negedge n_reset3)
   begin : p_interrupt3
      
      if (~n_reset3)
         int_status3      <= GPRV_INT_STATUS3;
      
      else 
         int_status3      <= ( int_status3 & ~(status_clear3) // read & clear
                            ) |
                            interrupt_trigger3;             // new interrupt3
        
   end // block: p_interrupt3
   
   
   // p_read_register3  : clocked3 / asynchronous3 
   //
   // this process registers the output values

   always @(posedge pclk3 or negedge n_reset3)

      begin : p_read_register3
         
         if (~n_reset3)
         
           begin

            rdata3 <= {16 {1'b0}};

           end
           
         else //if not reset
         
           begin
         
            if (read == 1'b1)
            
              begin
            
               case (addr)
            
                  
                  GPR_DIRECTION_MODE3:
                     rdata3 <= direction_mode3;
                  
                  GPR_OUTPUT_ENABLE3:
                     rdata3 <= output_enable3;
                  
                  GPR_OUTPUT_VALUE3:
                     rdata3 <= output_value3;
                  
                  GPR_INT_STATUS3:
                     rdata3 <= int_status3;
                  
                  default: // if GPR_INPUT_VALUE3 or unmapped reg addr
                     rdata3 <= input_value3;
            
               endcase
            
              end //end if read
            
            else //in not read
            
              begin // if not a valid read access, keep3 '0'-s 
              
               rdata3 <= {16 {1'b0}};
              
              end //end if not read
              
           end //end else if not reset

      end // p_read_register3


   assign pin_out3 = 
        ( output_value3 ) ;
     
   assign pin_oe_n3 = 
      ( ( ~(output_enable3 & ~(direction_mode3)) ) |
        tri_state_enable3 ) ;

                
  
endmodule // gpio_subunit3



   
   



   
