//File6 name   : gpio_lite_subunit6.v
//Title6       : 
//Created6     : 1999
//Description6 : Parametrised6 GPIO6 pin6 circuits6
//Notes6       : 
//----------------------------------------------------------------------
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


module gpio_lite_subunit6(
  //Inputs6

  n_reset6,
  pclk6,

  read,
  write,
  addr,

  wdata6,
  pin_in6,

  tri_state_enable6,

  //Outputs6
 
  interrupt6,

  rdata6,
  pin_oe_n6,
  pin_out6

);
 
   // Inputs6
   
   // Clocks6   
   input n_reset6;            // asynch6 reset, active low6
   input pclk6;               // Ppclk6

   // Controls6
   input read;               // select6 GPIO6 read
   input write;              // select6 GPIO6 write
   input [5:0] 
         addr;               // address bus of selected master6

   // Dataflow6
   input [15:0]
         wdata6;              // GPIO6 Input6
   input [15:0]
         pin_in6;             // input data from pin6

   //Design6 for Test6 Inputs6
   input [15:0]
         tri_state_enable6;   // disables6 op enable -> Z6




   
   // Outputs6
   
   // Controls6
   output [15:0]
          interrupt6;         // interupt6 for input pin6 change

   // Dataflow6
   output [15:0]
          rdata6;             // GPIO6 Output6
   output [15:0]
          pin_oe_n6;          // output enable signal6 to pin6
   output [15:0]
          pin_out6;           // output signal6 to pin6
   



   
   // Registers6 in module

   //Define6 Physical6 registers in amba_unit6
   reg    [15:0]
          direction_mode6;     // 1=Input6 0=Output6              RW
   reg    [15:0]
          output_enable6;      // Output6 active                 RW
   reg    [15:0]
          output_value6;       // Value outputed6 from reg       RW
   reg    [15:0]
          input_value6;        // Value input from bus          R
   reg    [15:0]
          int_status6;         // Interrupt6 status              R

   // registers to remove metastability6
   reg    [15:0]
          s_synch6;            //stage_two6
   reg    [15:0]
          s_synch_two6;        //stage_one6 - to ext pin6
   
   
    
          
   // Registers6 for outputs6
   reg    [15:0]
          rdata6;              // prdata6 reg
   wire   [15:0]
          pin_oe_n6;           // gpio6 output enable
   wire   [15:0]
          pin_out6;            // gpio6 output value
   wire   [15:0]
          interrupt6;          // gpio6 interrupt6
   wire   [15:0]
          interrupt_trigger6;  // 1 sets6 interrupt6 status
   reg    [15:0]
          status_clear6;       // 1 clears6 interrupt6 status
   wire   [15:0]
          int_event6;          // 1 detects6 an interrupt6 event

   integer ia6;                // loop variable
   


   // address decodes6
   wire   ad_direction_mode6;  // 1=Input6 0=Output6              RW
   wire   ad_output_enable6;   // Output6 active                 RW
   wire   ad_output_value6;    // Value outputed6 from reg       RW
   wire   ad_int_status6;      // Interrupt6 status              R
   
//Register addresses6
//If6 modifying6 the APB6 address (PADDR6) width change the following6 bit widths6
parameter GPR_DIRECTION_MODE6   = 6'h04;       // set pin6 to either6 I6 or O6
parameter GPR_OUTPUT_ENABLE6    = 6'h08;       // contains6 oe6 control6 value
parameter GPR_OUTPUT_VALUE6     = 6'h0C;       // output value to be driven6
parameter GPR_INPUT_VALUE6      = 6'h10;       // gpio6 input value reg
parameter GPR_INT_STATUS6       = 6'h20;       // Interrupt6 status register

//Reset6 Values6
//If6 modifying6 the GPIO6 width change the following6 bit widths6
//parameter GPRV_RSRVD6            = 32'h0000_0000; // Reserved6
parameter GPRV_DIRECTION_MODE6  = 32'h00000000; // Default to output mode
parameter GPRV_OUTPUT_ENABLE6   = 32'h00000000; // Default 3 stated6 outs6
parameter GPRV_OUTPUT_VALUE6    = 32'h00000000; // Default to be driven6
parameter GPRV_INPUT_VALUE6     = 32'h00000000; // Read defaults6 to zero
parameter GPRV_INT_STATUS6      = 32'h00000000; // Int6 status cleared6



   //assign ad_bypass_mode6    = ( addr == GPR_BYPASS_MODE6 );   
   assign ad_direction_mode6 = ( addr == GPR_DIRECTION_MODE6 );   
   assign ad_output_enable6  = ( addr == GPR_OUTPUT_ENABLE6 );   
   assign ad_output_value6   = ( addr == GPR_OUTPUT_VALUE6 );   
   assign ad_int_status6     = ( addr == GPR_INT_STATUS6 );   

   // assignments6
   
   assign interrupt6         = ( int_status6);

   assign interrupt_trigger6 = ( direction_mode6 & int_event6 ); 

   assign int_event6 = ((s_synch6 ^ input_value6) & ((s_synch6)));

   always @( ad_int_status6 or read )
   begin : p_status_clear6

     for ( ia6 = 0; ia6 < 16; ia6 = ia6 + 1 )
     begin

       status_clear6[ia6] = ( ad_int_status6 & read );

     end // for ia6

   end // p_status_clear6

   // p_write_register6 : clocked6 / asynchronous6
   //
   // this section6 contains6 all the code6 to write registers

   always @(posedge pclk6 or negedge n_reset6)
   begin : p_write_register6

      if (~n_reset6)
      
       begin
         direction_mode6  <= GPRV_DIRECTION_MODE6;
         output_enable6   <= GPRV_OUTPUT_ENABLE6;
         output_value6    <= GPRV_OUTPUT_VALUE6;
       end
      
      else 
      
       begin
      
         if (write == 1'b1) // Write value to registers
      
          begin
              
            // Write Mode6
         
            if ( ad_direction_mode6 ) 
               direction_mode6 <= wdata6;
 
            if ( ad_output_enable6 ) 
               output_enable6  <= wdata6;
     
            if ( ad_output_value6 )
               output_value6   <= wdata6;

              

           end // if write
         
       end // else: ~if(~n_reset6)
      
   end // block: p_write_register6



   // p_metastable6 : clocked6 / asynchronous6 
   //
   // This6 process  acts6 to remove  metastability6 propagation
   // Only6 for input to GPIO6
   // In Bypass6 mode pin_in6 passes6 straight6 through

   always @(posedge pclk6 or negedge n_reset6)
      
   begin : p_metastable6
      
      if (~n_reset6)
        begin
         
         s_synch6       <= {16 {1'b0}};
         s_synch_two6   <= {16 {1'b0}};
         input_value6   <= GPRV_INPUT_VALUE6;
         
        end // if (~n_reset6)
      
      else         
        begin
         
         input_value6   <= s_synch6;
         s_synch6       <= s_synch_two6;
         s_synch_two6   <= pin_in6;

        end // else: ~if(~n_reset6)
      
   end // block: p_metastable6


   // p_interrupt6 : clocked6 / asynchronous6 
   //
   // These6 lines6 set and clear the interrupt6 status

   always @(posedge pclk6 or negedge n_reset6)
   begin : p_interrupt6
      
      if (~n_reset6)
         int_status6      <= GPRV_INT_STATUS6;
      
      else 
         int_status6      <= ( int_status6 & ~(status_clear6) // read & clear
                            ) |
                            interrupt_trigger6;             // new interrupt6
        
   end // block: p_interrupt6
   
   
   // p_read_register6  : clocked6 / asynchronous6 
   //
   // this process registers the output values

   always @(posedge pclk6 or negedge n_reset6)

      begin : p_read_register6
         
         if (~n_reset6)
         
           begin

            rdata6 <= {16 {1'b0}};

           end
           
         else //if not reset
         
           begin
         
            if (read == 1'b1)
            
              begin
            
               case (addr)
            
                  
                  GPR_DIRECTION_MODE6:
                     rdata6 <= direction_mode6;
                  
                  GPR_OUTPUT_ENABLE6:
                     rdata6 <= output_enable6;
                  
                  GPR_OUTPUT_VALUE6:
                     rdata6 <= output_value6;
                  
                  GPR_INT_STATUS6:
                     rdata6 <= int_status6;
                  
                  default: // if GPR_INPUT_VALUE6 or unmapped reg addr
                     rdata6 <= input_value6;
            
               endcase
            
              end //end if read
            
            else //in not read
            
              begin // if not a valid read access, keep6 '0'-s 
              
               rdata6 <= {16 {1'b0}};
              
              end //end if not read
              
           end //end else if not reset

      end // p_read_register6


   assign pin_out6 = 
        ( output_value6 ) ;
     
   assign pin_oe_n6 = 
      ( ( ~(output_enable6 & ~(direction_mode6)) ) |
        tri_state_enable6 ) ;

                
  
endmodule // gpio_subunit6



   
   



   
