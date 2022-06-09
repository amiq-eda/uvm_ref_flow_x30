//File5 name   : gpio_lite_subunit5.v
//Title5       : 
//Created5     : 1999
//Description5 : Parametrised5 GPIO5 pin5 circuits5
//Notes5       : 
//----------------------------------------------------------------------
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


module gpio_lite_subunit5(
  //Inputs5

  n_reset5,
  pclk5,

  read,
  write,
  addr,

  wdata5,
  pin_in5,

  tri_state_enable5,

  //Outputs5
 
  interrupt5,

  rdata5,
  pin_oe_n5,
  pin_out5

);
 
   // Inputs5
   
   // Clocks5   
   input n_reset5;            // asynch5 reset, active low5
   input pclk5;               // Ppclk5

   // Controls5
   input read;               // select5 GPIO5 read
   input write;              // select5 GPIO5 write
   input [5:0] 
         addr;               // address bus of selected master5

   // Dataflow5
   input [15:0]
         wdata5;              // GPIO5 Input5
   input [15:0]
         pin_in5;             // input data from pin5

   //Design5 for Test5 Inputs5
   input [15:0]
         tri_state_enable5;   // disables5 op enable -> Z5




   
   // Outputs5
   
   // Controls5
   output [15:0]
          interrupt5;         // interupt5 for input pin5 change

   // Dataflow5
   output [15:0]
          rdata5;             // GPIO5 Output5
   output [15:0]
          pin_oe_n5;          // output enable signal5 to pin5
   output [15:0]
          pin_out5;           // output signal5 to pin5
   



   
   // Registers5 in module

   //Define5 Physical5 registers in amba_unit5
   reg    [15:0]
          direction_mode5;     // 1=Input5 0=Output5              RW
   reg    [15:0]
          output_enable5;      // Output5 active                 RW
   reg    [15:0]
          output_value5;       // Value outputed5 from reg       RW
   reg    [15:0]
          input_value5;        // Value input from bus          R
   reg    [15:0]
          int_status5;         // Interrupt5 status              R

   // registers to remove metastability5
   reg    [15:0]
          s_synch5;            //stage_two5
   reg    [15:0]
          s_synch_two5;        //stage_one5 - to ext pin5
   
   
    
          
   // Registers5 for outputs5
   reg    [15:0]
          rdata5;              // prdata5 reg
   wire   [15:0]
          pin_oe_n5;           // gpio5 output enable
   wire   [15:0]
          pin_out5;            // gpio5 output value
   wire   [15:0]
          interrupt5;          // gpio5 interrupt5
   wire   [15:0]
          interrupt_trigger5;  // 1 sets5 interrupt5 status
   reg    [15:0]
          status_clear5;       // 1 clears5 interrupt5 status
   wire   [15:0]
          int_event5;          // 1 detects5 an interrupt5 event

   integer ia5;                // loop variable
   


   // address decodes5
   wire   ad_direction_mode5;  // 1=Input5 0=Output5              RW
   wire   ad_output_enable5;   // Output5 active                 RW
   wire   ad_output_value5;    // Value outputed5 from reg       RW
   wire   ad_int_status5;      // Interrupt5 status              R
   
//Register addresses5
//If5 modifying5 the APB5 address (PADDR5) width change the following5 bit widths5
parameter GPR_DIRECTION_MODE5   = 6'h04;       // set pin5 to either5 I5 or O5
parameter GPR_OUTPUT_ENABLE5    = 6'h08;       // contains5 oe5 control5 value
parameter GPR_OUTPUT_VALUE5     = 6'h0C;       // output value to be driven5
parameter GPR_INPUT_VALUE5      = 6'h10;       // gpio5 input value reg
parameter GPR_INT_STATUS5       = 6'h20;       // Interrupt5 status register

//Reset5 Values5
//If5 modifying5 the GPIO5 width change the following5 bit widths5
//parameter GPRV_RSRVD5            = 32'h0000_0000; // Reserved5
parameter GPRV_DIRECTION_MODE5  = 32'h00000000; // Default to output mode
parameter GPRV_OUTPUT_ENABLE5   = 32'h00000000; // Default 3 stated5 outs5
parameter GPRV_OUTPUT_VALUE5    = 32'h00000000; // Default to be driven5
parameter GPRV_INPUT_VALUE5     = 32'h00000000; // Read defaults5 to zero
parameter GPRV_INT_STATUS5      = 32'h00000000; // Int5 status cleared5



   //assign ad_bypass_mode5    = ( addr == GPR_BYPASS_MODE5 );   
   assign ad_direction_mode5 = ( addr == GPR_DIRECTION_MODE5 );   
   assign ad_output_enable5  = ( addr == GPR_OUTPUT_ENABLE5 );   
   assign ad_output_value5   = ( addr == GPR_OUTPUT_VALUE5 );   
   assign ad_int_status5     = ( addr == GPR_INT_STATUS5 );   

   // assignments5
   
   assign interrupt5         = ( int_status5);

   assign interrupt_trigger5 = ( direction_mode5 & int_event5 ); 

   assign int_event5 = ((s_synch5 ^ input_value5) & ((s_synch5)));

   always @( ad_int_status5 or read )
   begin : p_status_clear5

     for ( ia5 = 0; ia5 < 16; ia5 = ia5 + 1 )
     begin

       status_clear5[ia5] = ( ad_int_status5 & read );

     end // for ia5

   end // p_status_clear5

   // p_write_register5 : clocked5 / asynchronous5
   //
   // this section5 contains5 all the code5 to write registers

   always @(posedge pclk5 or negedge n_reset5)
   begin : p_write_register5

      if (~n_reset5)
      
       begin
         direction_mode5  <= GPRV_DIRECTION_MODE5;
         output_enable5   <= GPRV_OUTPUT_ENABLE5;
         output_value5    <= GPRV_OUTPUT_VALUE5;
       end
      
      else 
      
       begin
      
         if (write == 1'b1) // Write value to registers
      
          begin
              
            // Write Mode5
         
            if ( ad_direction_mode5 ) 
               direction_mode5 <= wdata5;
 
            if ( ad_output_enable5 ) 
               output_enable5  <= wdata5;
     
            if ( ad_output_value5 )
               output_value5   <= wdata5;

              

           end // if write
         
       end // else: ~if(~n_reset5)
      
   end // block: p_write_register5



   // p_metastable5 : clocked5 / asynchronous5 
   //
   // This5 process  acts5 to remove  metastability5 propagation
   // Only5 for input to GPIO5
   // In Bypass5 mode pin_in5 passes5 straight5 through

   always @(posedge pclk5 or negedge n_reset5)
      
   begin : p_metastable5
      
      if (~n_reset5)
        begin
         
         s_synch5       <= {16 {1'b0}};
         s_synch_two5   <= {16 {1'b0}};
         input_value5   <= GPRV_INPUT_VALUE5;
         
        end // if (~n_reset5)
      
      else         
        begin
         
         input_value5   <= s_synch5;
         s_synch5       <= s_synch_two5;
         s_synch_two5   <= pin_in5;

        end // else: ~if(~n_reset5)
      
   end // block: p_metastable5


   // p_interrupt5 : clocked5 / asynchronous5 
   //
   // These5 lines5 set and clear the interrupt5 status

   always @(posedge pclk5 or negedge n_reset5)
   begin : p_interrupt5
      
      if (~n_reset5)
         int_status5      <= GPRV_INT_STATUS5;
      
      else 
         int_status5      <= ( int_status5 & ~(status_clear5) // read & clear
                            ) |
                            interrupt_trigger5;             // new interrupt5
        
   end // block: p_interrupt5
   
   
   // p_read_register5  : clocked5 / asynchronous5 
   //
   // this process registers the output values

   always @(posedge pclk5 or negedge n_reset5)

      begin : p_read_register5
         
         if (~n_reset5)
         
           begin

            rdata5 <= {16 {1'b0}};

           end
           
         else //if not reset
         
           begin
         
            if (read == 1'b1)
            
              begin
            
               case (addr)
            
                  
                  GPR_DIRECTION_MODE5:
                     rdata5 <= direction_mode5;
                  
                  GPR_OUTPUT_ENABLE5:
                     rdata5 <= output_enable5;
                  
                  GPR_OUTPUT_VALUE5:
                     rdata5 <= output_value5;
                  
                  GPR_INT_STATUS5:
                     rdata5 <= int_status5;
                  
                  default: // if GPR_INPUT_VALUE5 or unmapped reg addr
                     rdata5 <= input_value5;
            
               endcase
            
              end //end if read
            
            else //in not read
            
              begin // if not a valid read access, keep5 '0'-s 
              
               rdata5 <= {16 {1'b0}};
              
              end //end if not read
              
           end //end else if not reset

      end // p_read_register5


   assign pin_out5 = 
        ( output_value5 ) ;
     
   assign pin_oe_n5 = 
      ( ( ~(output_enable5 & ~(direction_mode5)) ) |
        tri_state_enable5 ) ;

                
  
endmodule // gpio_subunit5



   
   



   
