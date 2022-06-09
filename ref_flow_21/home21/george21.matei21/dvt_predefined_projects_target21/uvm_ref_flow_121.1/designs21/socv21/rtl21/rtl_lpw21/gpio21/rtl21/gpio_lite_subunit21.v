//File21 name   : gpio_lite_subunit21.v
//Title21       : 
//Created21     : 1999
//Description21 : Parametrised21 GPIO21 pin21 circuits21
//Notes21       : 
//----------------------------------------------------------------------
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


module gpio_lite_subunit21(
  //Inputs21

  n_reset21,
  pclk21,

  read,
  write,
  addr,

  wdata21,
  pin_in21,

  tri_state_enable21,

  //Outputs21
 
  interrupt21,

  rdata21,
  pin_oe_n21,
  pin_out21

);
 
   // Inputs21
   
   // Clocks21   
   input n_reset21;            // asynch21 reset, active low21
   input pclk21;               // Ppclk21

   // Controls21
   input read;               // select21 GPIO21 read
   input write;              // select21 GPIO21 write
   input [5:0] 
         addr;               // address bus of selected master21

   // Dataflow21
   input [15:0]
         wdata21;              // GPIO21 Input21
   input [15:0]
         pin_in21;             // input data from pin21

   //Design21 for Test21 Inputs21
   input [15:0]
         tri_state_enable21;   // disables21 op enable -> Z21




   
   // Outputs21
   
   // Controls21
   output [15:0]
          interrupt21;         // interupt21 for input pin21 change

   // Dataflow21
   output [15:0]
          rdata21;             // GPIO21 Output21
   output [15:0]
          pin_oe_n21;          // output enable signal21 to pin21
   output [15:0]
          pin_out21;           // output signal21 to pin21
   



   
   // Registers21 in module

   //Define21 Physical21 registers in amba_unit21
   reg    [15:0]
          direction_mode21;     // 1=Input21 0=Output21              RW
   reg    [15:0]
          output_enable21;      // Output21 active                 RW
   reg    [15:0]
          output_value21;       // Value outputed21 from reg       RW
   reg    [15:0]
          input_value21;        // Value input from bus          R
   reg    [15:0]
          int_status21;         // Interrupt21 status              R

   // registers to remove metastability21
   reg    [15:0]
          s_synch21;            //stage_two21
   reg    [15:0]
          s_synch_two21;        //stage_one21 - to ext pin21
   
   
    
          
   // Registers21 for outputs21
   reg    [15:0]
          rdata21;              // prdata21 reg
   wire   [15:0]
          pin_oe_n21;           // gpio21 output enable
   wire   [15:0]
          pin_out21;            // gpio21 output value
   wire   [15:0]
          interrupt21;          // gpio21 interrupt21
   wire   [15:0]
          interrupt_trigger21;  // 1 sets21 interrupt21 status
   reg    [15:0]
          status_clear21;       // 1 clears21 interrupt21 status
   wire   [15:0]
          int_event21;          // 1 detects21 an interrupt21 event

   integer ia21;                // loop variable
   


   // address decodes21
   wire   ad_direction_mode21;  // 1=Input21 0=Output21              RW
   wire   ad_output_enable21;   // Output21 active                 RW
   wire   ad_output_value21;    // Value outputed21 from reg       RW
   wire   ad_int_status21;      // Interrupt21 status              R
   
//Register addresses21
//If21 modifying21 the APB21 address (PADDR21) width change the following21 bit widths21
parameter GPR_DIRECTION_MODE21   = 6'h04;       // set pin21 to either21 I21 or O21
parameter GPR_OUTPUT_ENABLE21    = 6'h08;       // contains21 oe21 control21 value
parameter GPR_OUTPUT_VALUE21     = 6'h0C;       // output value to be driven21
parameter GPR_INPUT_VALUE21      = 6'h10;       // gpio21 input value reg
parameter GPR_INT_STATUS21       = 6'h20;       // Interrupt21 status register

//Reset21 Values21
//If21 modifying21 the GPIO21 width change the following21 bit widths21
//parameter GPRV_RSRVD21            = 32'h0000_0000; // Reserved21
parameter GPRV_DIRECTION_MODE21  = 32'h00000000; // Default to output mode
parameter GPRV_OUTPUT_ENABLE21   = 32'h00000000; // Default 3 stated21 outs21
parameter GPRV_OUTPUT_VALUE21    = 32'h00000000; // Default to be driven21
parameter GPRV_INPUT_VALUE21     = 32'h00000000; // Read defaults21 to zero
parameter GPRV_INT_STATUS21      = 32'h00000000; // Int21 status cleared21



   //assign ad_bypass_mode21    = ( addr == GPR_BYPASS_MODE21 );   
   assign ad_direction_mode21 = ( addr == GPR_DIRECTION_MODE21 );   
   assign ad_output_enable21  = ( addr == GPR_OUTPUT_ENABLE21 );   
   assign ad_output_value21   = ( addr == GPR_OUTPUT_VALUE21 );   
   assign ad_int_status21     = ( addr == GPR_INT_STATUS21 );   

   // assignments21
   
   assign interrupt21         = ( int_status21);

   assign interrupt_trigger21 = ( direction_mode21 & int_event21 ); 

   assign int_event21 = ((s_synch21 ^ input_value21) & ((s_synch21)));

   always @( ad_int_status21 or read )
   begin : p_status_clear21

     for ( ia21 = 0; ia21 < 16; ia21 = ia21 + 1 )
     begin

       status_clear21[ia21] = ( ad_int_status21 & read );

     end // for ia21

   end // p_status_clear21

   // p_write_register21 : clocked21 / asynchronous21
   //
   // this section21 contains21 all the code21 to write registers

   always @(posedge pclk21 or negedge n_reset21)
   begin : p_write_register21

      if (~n_reset21)
      
       begin
         direction_mode21  <= GPRV_DIRECTION_MODE21;
         output_enable21   <= GPRV_OUTPUT_ENABLE21;
         output_value21    <= GPRV_OUTPUT_VALUE21;
       end
      
      else 
      
       begin
      
         if (write == 1'b1) // Write value to registers
      
          begin
              
            // Write Mode21
         
            if ( ad_direction_mode21 ) 
               direction_mode21 <= wdata21;
 
            if ( ad_output_enable21 ) 
               output_enable21  <= wdata21;
     
            if ( ad_output_value21 )
               output_value21   <= wdata21;

              

           end // if write
         
       end // else: ~if(~n_reset21)
      
   end // block: p_write_register21



   // p_metastable21 : clocked21 / asynchronous21 
   //
   // This21 process  acts21 to remove  metastability21 propagation
   // Only21 for input to GPIO21
   // In Bypass21 mode pin_in21 passes21 straight21 through

   always @(posedge pclk21 or negedge n_reset21)
      
   begin : p_metastable21
      
      if (~n_reset21)
        begin
         
         s_synch21       <= {16 {1'b0}};
         s_synch_two21   <= {16 {1'b0}};
         input_value21   <= GPRV_INPUT_VALUE21;
         
        end // if (~n_reset21)
      
      else         
        begin
         
         input_value21   <= s_synch21;
         s_synch21       <= s_synch_two21;
         s_synch_two21   <= pin_in21;

        end // else: ~if(~n_reset21)
      
   end // block: p_metastable21


   // p_interrupt21 : clocked21 / asynchronous21 
   //
   // These21 lines21 set and clear the interrupt21 status

   always @(posedge pclk21 or negedge n_reset21)
   begin : p_interrupt21
      
      if (~n_reset21)
         int_status21      <= GPRV_INT_STATUS21;
      
      else 
         int_status21      <= ( int_status21 & ~(status_clear21) // read & clear
                            ) |
                            interrupt_trigger21;             // new interrupt21
        
   end // block: p_interrupt21
   
   
   // p_read_register21  : clocked21 / asynchronous21 
   //
   // this process registers the output values

   always @(posedge pclk21 or negedge n_reset21)

      begin : p_read_register21
         
         if (~n_reset21)
         
           begin

            rdata21 <= {16 {1'b0}};

           end
           
         else //if not reset
         
           begin
         
            if (read == 1'b1)
            
              begin
            
               case (addr)
            
                  
                  GPR_DIRECTION_MODE21:
                     rdata21 <= direction_mode21;
                  
                  GPR_OUTPUT_ENABLE21:
                     rdata21 <= output_enable21;
                  
                  GPR_OUTPUT_VALUE21:
                     rdata21 <= output_value21;
                  
                  GPR_INT_STATUS21:
                     rdata21 <= int_status21;
                  
                  default: // if GPR_INPUT_VALUE21 or unmapped reg addr
                     rdata21 <= input_value21;
            
               endcase
            
              end //end if read
            
            else //in not read
            
              begin // if not a valid read access, keep21 '0'-s 
              
               rdata21 <= {16 {1'b0}};
              
              end //end if not read
              
           end //end else if not reset

      end // p_read_register21


   assign pin_out21 = 
        ( output_value21 ) ;
     
   assign pin_oe_n21 = 
      ( ( ~(output_enable21 & ~(direction_mode21)) ) |
        tri_state_enable21 ) ;

                
  
endmodule // gpio_subunit21



   
   



   
