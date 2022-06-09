//File1 name   : gpio_lite_subunit1.v
//Title1       : 
//Created1     : 1999
//Description1 : Parametrised1 GPIO1 pin1 circuits1
//Notes1       : 
//----------------------------------------------------------------------
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


module gpio_lite_subunit1(
  //Inputs1

  n_reset1,
  pclk1,

  read,
  write,
  addr,

  wdata1,
  pin_in1,

  tri_state_enable1,

  //Outputs1
 
  interrupt1,

  rdata1,
  pin_oe_n1,
  pin_out1

);
 
   // Inputs1
   
   // Clocks1   
   input n_reset1;            // asynch1 reset, active low1
   input pclk1;               // Ppclk1

   // Controls1
   input read;               // select1 GPIO1 read
   input write;              // select1 GPIO1 write
   input [5:0] 
         addr;               // address bus of selected master1

   // Dataflow1
   input [15:0]
         wdata1;              // GPIO1 Input1
   input [15:0]
         pin_in1;             // input data from pin1

   //Design1 for Test1 Inputs1
   input [15:0]
         tri_state_enable1;   // disables1 op enable -> Z1




   
   // Outputs1
   
   // Controls1
   output [15:0]
          interrupt1;         // interupt1 for input pin1 change

   // Dataflow1
   output [15:0]
          rdata1;             // GPIO1 Output1
   output [15:0]
          pin_oe_n1;          // output enable signal1 to pin1
   output [15:0]
          pin_out1;           // output signal1 to pin1
   



   
   // Registers1 in module

   //Define1 Physical1 registers in amba_unit1
   reg    [15:0]
          direction_mode1;     // 1=Input1 0=Output1              RW
   reg    [15:0]
          output_enable1;      // Output1 active                 RW
   reg    [15:0]
          output_value1;       // Value outputed1 from reg       RW
   reg    [15:0]
          input_value1;        // Value input from bus          R
   reg    [15:0]
          int_status1;         // Interrupt1 status              R

   // registers to remove metastability1
   reg    [15:0]
          s_synch1;            //stage_two1
   reg    [15:0]
          s_synch_two1;        //stage_one1 - to ext pin1
   
   
    
          
   // Registers1 for outputs1
   reg    [15:0]
          rdata1;              // prdata1 reg
   wire   [15:0]
          pin_oe_n1;           // gpio1 output enable
   wire   [15:0]
          pin_out1;            // gpio1 output value
   wire   [15:0]
          interrupt1;          // gpio1 interrupt1
   wire   [15:0]
          interrupt_trigger1;  // 1 sets1 interrupt1 status
   reg    [15:0]
          status_clear1;       // 1 clears1 interrupt1 status
   wire   [15:0]
          int_event1;          // 1 detects1 an interrupt1 event

   integer ia1;                // loop variable
   


   // address decodes1
   wire   ad_direction_mode1;  // 1=Input1 0=Output1              RW
   wire   ad_output_enable1;   // Output1 active                 RW
   wire   ad_output_value1;    // Value outputed1 from reg       RW
   wire   ad_int_status1;      // Interrupt1 status              R
   
//Register addresses1
//If1 modifying1 the APB1 address (PADDR1) width change the following1 bit widths1
parameter GPR_DIRECTION_MODE1   = 6'h04;       // set pin1 to either1 I1 or O1
parameter GPR_OUTPUT_ENABLE1    = 6'h08;       // contains1 oe1 control1 value
parameter GPR_OUTPUT_VALUE1     = 6'h0C;       // output value to be driven1
parameter GPR_INPUT_VALUE1      = 6'h10;       // gpio1 input value reg
parameter GPR_INT_STATUS1       = 6'h20;       // Interrupt1 status register

//Reset1 Values1
//If1 modifying1 the GPIO1 width change the following1 bit widths1
//parameter GPRV_RSRVD1            = 32'h0000_0000; // Reserved1
parameter GPRV_DIRECTION_MODE1  = 32'h00000000; // Default to output mode
parameter GPRV_OUTPUT_ENABLE1   = 32'h00000000; // Default 3 stated1 outs1
parameter GPRV_OUTPUT_VALUE1    = 32'h00000000; // Default to be driven1
parameter GPRV_INPUT_VALUE1     = 32'h00000000; // Read defaults1 to zero
parameter GPRV_INT_STATUS1      = 32'h00000000; // Int1 status cleared1



   //assign ad_bypass_mode1    = ( addr == GPR_BYPASS_MODE1 );   
   assign ad_direction_mode1 = ( addr == GPR_DIRECTION_MODE1 );   
   assign ad_output_enable1  = ( addr == GPR_OUTPUT_ENABLE1 );   
   assign ad_output_value1   = ( addr == GPR_OUTPUT_VALUE1 );   
   assign ad_int_status1     = ( addr == GPR_INT_STATUS1 );   

   // assignments1
   
   assign interrupt1         = ( int_status1);

   assign interrupt_trigger1 = ( direction_mode1 & int_event1 ); 

   assign int_event1 = ((s_synch1 ^ input_value1) & ((s_synch1)));

   always @( ad_int_status1 or read )
   begin : p_status_clear1

     for ( ia1 = 0; ia1 < 16; ia1 = ia1 + 1 )
     begin

       status_clear1[ia1] = ( ad_int_status1 & read );

     end // for ia1

   end // p_status_clear1

   // p_write_register1 : clocked1 / asynchronous1
   //
   // this section1 contains1 all the code1 to write registers

   always @(posedge pclk1 or negedge n_reset1)
   begin : p_write_register1

      if (~n_reset1)
      
       begin
         direction_mode1  <= GPRV_DIRECTION_MODE1;
         output_enable1   <= GPRV_OUTPUT_ENABLE1;
         output_value1    <= GPRV_OUTPUT_VALUE1;
       end
      
      else 
      
       begin
      
         if (write == 1'b1) // Write value to registers
      
          begin
              
            // Write Mode1
         
            if ( ad_direction_mode1 ) 
               direction_mode1 <= wdata1;
 
            if ( ad_output_enable1 ) 
               output_enable1  <= wdata1;
     
            if ( ad_output_value1 )
               output_value1   <= wdata1;

              

           end // if write
         
       end // else: ~if(~n_reset1)
      
   end // block: p_write_register1



   // p_metastable1 : clocked1 / asynchronous1 
   //
   // This1 process  acts1 to remove  metastability1 propagation
   // Only1 for input to GPIO1
   // In Bypass1 mode pin_in1 passes1 straight1 through

   always @(posedge pclk1 or negedge n_reset1)
      
   begin : p_metastable1
      
      if (~n_reset1)
        begin
         
         s_synch1       <= {16 {1'b0}};
         s_synch_two1   <= {16 {1'b0}};
         input_value1   <= GPRV_INPUT_VALUE1;
         
        end // if (~n_reset1)
      
      else         
        begin
         
         input_value1   <= s_synch1;
         s_synch1       <= s_synch_two1;
         s_synch_two1   <= pin_in1;

        end // else: ~if(~n_reset1)
      
   end // block: p_metastable1


   // p_interrupt1 : clocked1 / asynchronous1 
   //
   // These1 lines1 set and clear the interrupt1 status

   always @(posedge pclk1 or negedge n_reset1)
   begin : p_interrupt1
      
      if (~n_reset1)
         int_status1      <= GPRV_INT_STATUS1;
      
      else 
         int_status1      <= ( int_status1 & ~(status_clear1) // read & clear
                            ) |
                            interrupt_trigger1;             // new interrupt1
        
   end // block: p_interrupt1
   
   
   // p_read_register1  : clocked1 / asynchronous1 
   //
   // this process registers the output values

   always @(posedge pclk1 or negedge n_reset1)

      begin : p_read_register1
         
         if (~n_reset1)
         
           begin

            rdata1 <= {16 {1'b0}};

           end
           
         else //if not reset
         
           begin
         
            if (read == 1'b1)
            
              begin
            
               case (addr)
            
                  
                  GPR_DIRECTION_MODE1:
                     rdata1 <= direction_mode1;
                  
                  GPR_OUTPUT_ENABLE1:
                     rdata1 <= output_enable1;
                  
                  GPR_OUTPUT_VALUE1:
                     rdata1 <= output_value1;
                  
                  GPR_INT_STATUS1:
                     rdata1 <= int_status1;
                  
                  default: // if GPR_INPUT_VALUE1 or unmapped reg addr
                     rdata1 <= input_value1;
            
               endcase
            
              end //end if read
            
            else //in not read
            
              begin // if not a valid read access, keep1 '0'-s 
              
               rdata1 <= {16 {1'b0}};
              
              end //end if not read
              
           end //end else if not reset

      end // p_read_register1


   assign pin_out1 = 
        ( output_value1 ) ;
     
   assign pin_oe_n1 = 
      ( ( ~(output_enable1 & ~(direction_mode1)) ) |
        tri_state_enable1 ) ;

                
  
endmodule // gpio_subunit1



   
   



   
