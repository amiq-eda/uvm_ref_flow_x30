//File2 name   : gpio_lite_subunit2.v
//Title2       : 
//Created2     : 1999
//Description2 : Parametrised2 GPIO2 pin2 circuits2
//Notes2       : 
//----------------------------------------------------------------------
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


module gpio_lite_subunit2(
  //Inputs2

  n_reset2,
  pclk2,

  read,
  write,
  addr,

  wdata2,
  pin_in2,

  tri_state_enable2,

  //Outputs2
 
  interrupt2,

  rdata2,
  pin_oe_n2,
  pin_out2

);
 
   // Inputs2
   
   // Clocks2   
   input n_reset2;            // asynch2 reset, active low2
   input pclk2;               // Ppclk2

   // Controls2
   input read;               // select2 GPIO2 read
   input write;              // select2 GPIO2 write
   input [5:0] 
         addr;               // address bus of selected master2

   // Dataflow2
   input [15:0]
         wdata2;              // GPIO2 Input2
   input [15:0]
         pin_in2;             // input data from pin2

   //Design2 for Test2 Inputs2
   input [15:0]
         tri_state_enable2;   // disables2 op enable -> Z2




   
   // Outputs2
   
   // Controls2
   output [15:0]
          interrupt2;         // interupt2 for input pin2 change

   // Dataflow2
   output [15:0]
          rdata2;             // GPIO2 Output2
   output [15:0]
          pin_oe_n2;          // output enable signal2 to pin2
   output [15:0]
          pin_out2;           // output signal2 to pin2
   



   
   // Registers2 in module

   //Define2 Physical2 registers in amba_unit2
   reg    [15:0]
          direction_mode2;     // 1=Input2 0=Output2              RW
   reg    [15:0]
          output_enable2;      // Output2 active                 RW
   reg    [15:0]
          output_value2;       // Value outputed2 from reg       RW
   reg    [15:0]
          input_value2;        // Value input from bus          R
   reg    [15:0]
          int_status2;         // Interrupt2 status              R

   // registers to remove metastability2
   reg    [15:0]
          s_synch2;            //stage_two2
   reg    [15:0]
          s_synch_two2;        //stage_one2 - to ext pin2
   
   
    
          
   // Registers2 for outputs2
   reg    [15:0]
          rdata2;              // prdata2 reg
   wire   [15:0]
          pin_oe_n2;           // gpio2 output enable
   wire   [15:0]
          pin_out2;            // gpio2 output value
   wire   [15:0]
          interrupt2;          // gpio2 interrupt2
   wire   [15:0]
          interrupt_trigger2;  // 1 sets2 interrupt2 status
   reg    [15:0]
          status_clear2;       // 1 clears2 interrupt2 status
   wire   [15:0]
          int_event2;          // 1 detects2 an interrupt2 event

   integer ia2;                // loop variable
   


   // address decodes2
   wire   ad_direction_mode2;  // 1=Input2 0=Output2              RW
   wire   ad_output_enable2;   // Output2 active                 RW
   wire   ad_output_value2;    // Value outputed2 from reg       RW
   wire   ad_int_status2;      // Interrupt2 status              R
   
//Register addresses2
//If2 modifying2 the APB2 address (PADDR2) width change the following2 bit widths2
parameter GPR_DIRECTION_MODE2   = 6'h04;       // set pin2 to either2 I2 or O2
parameter GPR_OUTPUT_ENABLE2    = 6'h08;       // contains2 oe2 control2 value
parameter GPR_OUTPUT_VALUE2     = 6'h0C;       // output value to be driven2
parameter GPR_INPUT_VALUE2      = 6'h10;       // gpio2 input value reg
parameter GPR_INT_STATUS2       = 6'h20;       // Interrupt2 status register

//Reset2 Values2
//If2 modifying2 the GPIO2 width change the following2 bit widths2
//parameter GPRV_RSRVD2            = 32'h0000_0000; // Reserved2
parameter GPRV_DIRECTION_MODE2  = 32'h00000000; // Default to output mode
parameter GPRV_OUTPUT_ENABLE2   = 32'h00000000; // Default 3 stated2 outs2
parameter GPRV_OUTPUT_VALUE2    = 32'h00000000; // Default to be driven2
parameter GPRV_INPUT_VALUE2     = 32'h00000000; // Read defaults2 to zero
parameter GPRV_INT_STATUS2      = 32'h00000000; // Int2 status cleared2



   //assign ad_bypass_mode2    = ( addr == GPR_BYPASS_MODE2 );   
   assign ad_direction_mode2 = ( addr == GPR_DIRECTION_MODE2 );   
   assign ad_output_enable2  = ( addr == GPR_OUTPUT_ENABLE2 );   
   assign ad_output_value2   = ( addr == GPR_OUTPUT_VALUE2 );   
   assign ad_int_status2     = ( addr == GPR_INT_STATUS2 );   

   // assignments2
   
   assign interrupt2         = ( int_status2);

   assign interrupt_trigger2 = ( direction_mode2 & int_event2 ); 

   assign int_event2 = ((s_synch2 ^ input_value2) & ((s_synch2)));

   always @( ad_int_status2 or read )
   begin : p_status_clear2

     for ( ia2 = 0; ia2 < 16; ia2 = ia2 + 1 )
     begin

       status_clear2[ia2] = ( ad_int_status2 & read );

     end // for ia2

   end // p_status_clear2

   // p_write_register2 : clocked2 / asynchronous2
   //
   // this section2 contains2 all the code2 to write registers

   always @(posedge pclk2 or negedge n_reset2)
   begin : p_write_register2

      if (~n_reset2)
      
       begin
         direction_mode2  <= GPRV_DIRECTION_MODE2;
         output_enable2   <= GPRV_OUTPUT_ENABLE2;
         output_value2    <= GPRV_OUTPUT_VALUE2;
       end
      
      else 
      
       begin
      
         if (write == 1'b1) // Write value to registers
      
          begin
              
            // Write Mode2
         
            if ( ad_direction_mode2 ) 
               direction_mode2 <= wdata2;
 
            if ( ad_output_enable2 ) 
               output_enable2  <= wdata2;
     
            if ( ad_output_value2 )
               output_value2   <= wdata2;

              

           end // if write
         
       end // else: ~if(~n_reset2)
      
   end // block: p_write_register2



   // p_metastable2 : clocked2 / asynchronous2 
   //
   // This2 process  acts2 to remove  metastability2 propagation
   // Only2 for input to GPIO2
   // In Bypass2 mode pin_in2 passes2 straight2 through

   always @(posedge pclk2 or negedge n_reset2)
      
   begin : p_metastable2
      
      if (~n_reset2)
        begin
         
         s_synch2       <= {16 {1'b0}};
         s_synch_two2   <= {16 {1'b0}};
         input_value2   <= GPRV_INPUT_VALUE2;
         
        end // if (~n_reset2)
      
      else         
        begin
         
         input_value2   <= s_synch2;
         s_synch2       <= s_synch_two2;
         s_synch_two2   <= pin_in2;

        end // else: ~if(~n_reset2)
      
   end // block: p_metastable2


   // p_interrupt2 : clocked2 / asynchronous2 
   //
   // These2 lines2 set and clear the interrupt2 status

   always @(posedge pclk2 or negedge n_reset2)
   begin : p_interrupt2
      
      if (~n_reset2)
         int_status2      <= GPRV_INT_STATUS2;
      
      else 
         int_status2      <= ( int_status2 & ~(status_clear2) // read & clear
                            ) |
                            interrupt_trigger2;             // new interrupt2
        
   end // block: p_interrupt2
   
   
   // p_read_register2  : clocked2 / asynchronous2 
   //
   // this process registers the output values

   always @(posedge pclk2 or negedge n_reset2)

      begin : p_read_register2
         
         if (~n_reset2)
         
           begin

            rdata2 <= {16 {1'b0}};

           end
           
         else //if not reset
         
           begin
         
            if (read == 1'b1)
            
              begin
            
               case (addr)
            
                  
                  GPR_DIRECTION_MODE2:
                     rdata2 <= direction_mode2;
                  
                  GPR_OUTPUT_ENABLE2:
                     rdata2 <= output_enable2;
                  
                  GPR_OUTPUT_VALUE2:
                     rdata2 <= output_value2;
                  
                  GPR_INT_STATUS2:
                     rdata2 <= int_status2;
                  
                  default: // if GPR_INPUT_VALUE2 or unmapped reg addr
                     rdata2 <= input_value2;
            
               endcase
            
              end //end if read
            
            else //in not read
            
              begin // if not a valid read access, keep2 '0'-s 
              
               rdata2 <= {16 {1'b0}};
              
              end //end if not read
              
           end //end else if not reset

      end // p_read_register2


   assign pin_out2 = 
        ( output_value2 ) ;
     
   assign pin_oe_n2 = 
      ( ( ~(output_enable2 & ~(direction_mode2)) ) |
        tri_state_enable2 ) ;

                
  
endmodule // gpio_subunit2



   
   



   
