//File9 name   : gpio_lite_subunit9.v
//Title9       : 
//Created9     : 1999
//Description9 : Parametrised9 GPIO9 pin9 circuits9
//Notes9       : 
//----------------------------------------------------------------------
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


module gpio_lite_subunit9(
  //Inputs9

  n_reset9,
  pclk9,

  read,
  write,
  addr,

  wdata9,
  pin_in9,

  tri_state_enable9,

  //Outputs9
 
  interrupt9,

  rdata9,
  pin_oe_n9,
  pin_out9

);
 
   // Inputs9
   
   // Clocks9   
   input n_reset9;            // asynch9 reset, active low9
   input pclk9;               // Ppclk9

   // Controls9
   input read;               // select9 GPIO9 read
   input write;              // select9 GPIO9 write
   input [5:0] 
         addr;               // address bus of selected master9

   // Dataflow9
   input [15:0]
         wdata9;              // GPIO9 Input9
   input [15:0]
         pin_in9;             // input data from pin9

   //Design9 for Test9 Inputs9
   input [15:0]
         tri_state_enable9;   // disables9 op enable -> Z9




   
   // Outputs9
   
   // Controls9
   output [15:0]
          interrupt9;         // interupt9 for input pin9 change

   // Dataflow9
   output [15:0]
          rdata9;             // GPIO9 Output9
   output [15:0]
          pin_oe_n9;          // output enable signal9 to pin9
   output [15:0]
          pin_out9;           // output signal9 to pin9
   



   
   // Registers9 in module

   //Define9 Physical9 registers in amba_unit9
   reg    [15:0]
          direction_mode9;     // 1=Input9 0=Output9              RW
   reg    [15:0]
          output_enable9;      // Output9 active                 RW
   reg    [15:0]
          output_value9;       // Value outputed9 from reg       RW
   reg    [15:0]
          input_value9;        // Value input from bus          R
   reg    [15:0]
          int_status9;         // Interrupt9 status              R

   // registers to remove metastability9
   reg    [15:0]
          s_synch9;            //stage_two9
   reg    [15:0]
          s_synch_two9;        //stage_one9 - to ext pin9
   
   
    
          
   // Registers9 for outputs9
   reg    [15:0]
          rdata9;              // prdata9 reg
   wire   [15:0]
          pin_oe_n9;           // gpio9 output enable
   wire   [15:0]
          pin_out9;            // gpio9 output value
   wire   [15:0]
          interrupt9;          // gpio9 interrupt9
   wire   [15:0]
          interrupt_trigger9;  // 1 sets9 interrupt9 status
   reg    [15:0]
          status_clear9;       // 1 clears9 interrupt9 status
   wire   [15:0]
          int_event9;          // 1 detects9 an interrupt9 event

   integer ia9;                // loop variable
   


   // address decodes9
   wire   ad_direction_mode9;  // 1=Input9 0=Output9              RW
   wire   ad_output_enable9;   // Output9 active                 RW
   wire   ad_output_value9;    // Value outputed9 from reg       RW
   wire   ad_int_status9;      // Interrupt9 status              R
   
//Register addresses9
//If9 modifying9 the APB9 address (PADDR9) width change the following9 bit widths9
parameter GPR_DIRECTION_MODE9   = 6'h04;       // set pin9 to either9 I9 or O9
parameter GPR_OUTPUT_ENABLE9    = 6'h08;       // contains9 oe9 control9 value
parameter GPR_OUTPUT_VALUE9     = 6'h0C;       // output value to be driven9
parameter GPR_INPUT_VALUE9      = 6'h10;       // gpio9 input value reg
parameter GPR_INT_STATUS9       = 6'h20;       // Interrupt9 status register

//Reset9 Values9
//If9 modifying9 the GPIO9 width change the following9 bit widths9
//parameter GPRV_RSRVD9            = 32'h0000_0000; // Reserved9
parameter GPRV_DIRECTION_MODE9  = 32'h00000000; // Default to output mode
parameter GPRV_OUTPUT_ENABLE9   = 32'h00000000; // Default 3 stated9 outs9
parameter GPRV_OUTPUT_VALUE9    = 32'h00000000; // Default to be driven9
parameter GPRV_INPUT_VALUE9     = 32'h00000000; // Read defaults9 to zero
parameter GPRV_INT_STATUS9      = 32'h00000000; // Int9 status cleared9



   //assign ad_bypass_mode9    = ( addr == GPR_BYPASS_MODE9 );   
   assign ad_direction_mode9 = ( addr == GPR_DIRECTION_MODE9 );   
   assign ad_output_enable9  = ( addr == GPR_OUTPUT_ENABLE9 );   
   assign ad_output_value9   = ( addr == GPR_OUTPUT_VALUE9 );   
   assign ad_int_status9     = ( addr == GPR_INT_STATUS9 );   

   // assignments9
   
   assign interrupt9         = ( int_status9);

   assign interrupt_trigger9 = ( direction_mode9 & int_event9 ); 

   assign int_event9 = ((s_synch9 ^ input_value9) & ((s_synch9)));

   always @( ad_int_status9 or read )
   begin : p_status_clear9

     for ( ia9 = 0; ia9 < 16; ia9 = ia9 + 1 )
     begin

       status_clear9[ia9] = ( ad_int_status9 & read );

     end // for ia9

   end // p_status_clear9

   // p_write_register9 : clocked9 / asynchronous9
   //
   // this section9 contains9 all the code9 to write registers

   always @(posedge pclk9 or negedge n_reset9)
   begin : p_write_register9

      if (~n_reset9)
      
       begin
         direction_mode9  <= GPRV_DIRECTION_MODE9;
         output_enable9   <= GPRV_OUTPUT_ENABLE9;
         output_value9    <= GPRV_OUTPUT_VALUE9;
       end
      
      else 
      
       begin
      
         if (write == 1'b1) // Write value to registers
      
          begin
              
            // Write Mode9
         
            if ( ad_direction_mode9 ) 
               direction_mode9 <= wdata9;
 
            if ( ad_output_enable9 ) 
               output_enable9  <= wdata9;
     
            if ( ad_output_value9 )
               output_value9   <= wdata9;

              

           end // if write
         
       end // else: ~if(~n_reset9)
      
   end // block: p_write_register9



   // p_metastable9 : clocked9 / asynchronous9 
   //
   // This9 process  acts9 to remove  metastability9 propagation
   // Only9 for input to GPIO9
   // In Bypass9 mode pin_in9 passes9 straight9 through

   always @(posedge pclk9 or negedge n_reset9)
      
   begin : p_metastable9
      
      if (~n_reset9)
        begin
         
         s_synch9       <= {16 {1'b0}};
         s_synch_two9   <= {16 {1'b0}};
         input_value9   <= GPRV_INPUT_VALUE9;
         
        end // if (~n_reset9)
      
      else         
        begin
         
         input_value9   <= s_synch9;
         s_synch9       <= s_synch_two9;
         s_synch_two9   <= pin_in9;

        end // else: ~if(~n_reset9)
      
   end // block: p_metastable9


   // p_interrupt9 : clocked9 / asynchronous9 
   //
   // These9 lines9 set and clear the interrupt9 status

   always @(posedge pclk9 or negedge n_reset9)
   begin : p_interrupt9
      
      if (~n_reset9)
         int_status9      <= GPRV_INT_STATUS9;
      
      else 
         int_status9      <= ( int_status9 & ~(status_clear9) // read & clear
                            ) |
                            interrupt_trigger9;             // new interrupt9
        
   end // block: p_interrupt9
   
   
   // p_read_register9  : clocked9 / asynchronous9 
   //
   // this process registers the output values

   always @(posedge pclk9 or negedge n_reset9)

      begin : p_read_register9
         
         if (~n_reset9)
         
           begin

            rdata9 <= {16 {1'b0}};

           end
           
         else //if not reset
         
           begin
         
            if (read == 1'b1)
            
              begin
            
               case (addr)
            
                  
                  GPR_DIRECTION_MODE9:
                     rdata9 <= direction_mode9;
                  
                  GPR_OUTPUT_ENABLE9:
                     rdata9 <= output_enable9;
                  
                  GPR_OUTPUT_VALUE9:
                     rdata9 <= output_value9;
                  
                  GPR_INT_STATUS9:
                     rdata9 <= int_status9;
                  
                  default: // if GPR_INPUT_VALUE9 or unmapped reg addr
                     rdata9 <= input_value9;
            
               endcase
            
              end //end if read
            
            else //in not read
            
              begin // if not a valid read access, keep9 '0'-s 
              
               rdata9 <= {16 {1'b0}};
              
              end //end if not read
              
           end //end else if not reset

      end // p_read_register9


   assign pin_out9 = 
        ( output_value9 ) ;
     
   assign pin_oe_n9 = 
      ( ( ~(output_enable9 & ~(direction_mode9)) ) |
        tri_state_enable9 ) ;

                
  
endmodule // gpio_subunit9



   
   



   
