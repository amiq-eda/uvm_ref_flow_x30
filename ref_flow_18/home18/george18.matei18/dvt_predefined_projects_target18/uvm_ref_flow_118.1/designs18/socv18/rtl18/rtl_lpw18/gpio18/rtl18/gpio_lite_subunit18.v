//File18 name   : gpio_lite_subunit18.v
//Title18       : 
//Created18     : 1999
//Description18 : Parametrised18 GPIO18 pin18 circuits18
//Notes18       : 
//----------------------------------------------------------------------
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


module gpio_lite_subunit18(
  //Inputs18

  n_reset18,
  pclk18,

  read,
  write,
  addr,

  wdata18,
  pin_in18,

  tri_state_enable18,

  //Outputs18
 
  interrupt18,

  rdata18,
  pin_oe_n18,
  pin_out18

);
 
   // Inputs18
   
   // Clocks18   
   input n_reset18;            // asynch18 reset, active low18
   input pclk18;               // Ppclk18

   // Controls18
   input read;               // select18 GPIO18 read
   input write;              // select18 GPIO18 write
   input [5:0] 
         addr;               // address bus of selected master18

   // Dataflow18
   input [15:0]
         wdata18;              // GPIO18 Input18
   input [15:0]
         pin_in18;             // input data from pin18

   //Design18 for Test18 Inputs18
   input [15:0]
         tri_state_enable18;   // disables18 op enable -> Z18




   
   // Outputs18
   
   // Controls18
   output [15:0]
          interrupt18;         // interupt18 for input pin18 change

   // Dataflow18
   output [15:0]
          rdata18;             // GPIO18 Output18
   output [15:0]
          pin_oe_n18;          // output enable signal18 to pin18
   output [15:0]
          pin_out18;           // output signal18 to pin18
   



   
   // Registers18 in module

   //Define18 Physical18 registers in amba_unit18
   reg    [15:0]
          direction_mode18;     // 1=Input18 0=Output18              RW
   reg    [15:0]
          output_enable18;      // Output18 active                 RW
   reg    [15:0]
          output_value18;       // Value outputed18 from reg       RW
   reg    [15:0]
          input_value18;        // Value input from bus          R
   reg    [15:0]
          int_status18;         // Interrupt18 status              R

   // registers to remove metastability18
   reg    [15:0]
          s_synch18;            //stage_two18
   reg    [15:0]
          s_synch_two18;        //stage_one18 - to ext pin18
   
   
    
          
   // Registers18 for outputs18
   reg    [15:0]
          rdata18;              // prdata18 reg
   wire   [15:0]
          pin_oe_n18;           // gpio18 output enable
   wire   [15:0]
          pin_out18;            // gpio18 output value
   wire   [15:0]
          interrupt18;          // gpio18 interrupt18
   wire   [15:0]
          interrupt_trigger18;  // 1 sets18 interrupt18 status
   reg    [15:0]
          status_clear18;       // 1 clears18 interrupt18 status
   wire   [15:0]
          int_event18;          // 1 detects18 an interrupt18 event

   integer ia18;                // loop variable
   


   // address decodes18
   wire   ad_direction_mode18;  // 1=Input18 0=Output18              RW
   wire   ad_output_enable18;   // Output18 active                 RW
   wire   ad_output_value18;    // Value outputed18 from reg       RW
   wire   ad_int_status18;      // Interrupt18 status              R
   
//Register addresses18
//If18 modifying18 the APB18 address (PADDR18) width change the following18 bit widths18
parameter GPR_DIRECTION_MODE18   = 6'h04;       // set pin18 to either18 I18 or O18
parameter GPR_OUTPUT_ENABLE18    = 6'h08;       // contains18 oe18 control18 value
parameter GPR_OUTPUT_VALUE18     = 6'h0C;       // output value to be driven18
parameter GPR_INPUT_VALUE18      = 6'h10;       // gpio18 input value reg
parameter GPR_INT_STATUS18       = 6'h20;       // Interrupt18 status register

//Reset18 Values18
//If18 modifying18 the GPIO18 width change the following18 bit widths18
//parameter GPRV_RSRVD18            = 32'h0000_0000; // Reserved18
parameter GPRV_DIRECTION_MODE18  = 32'h00000000; // Default to output mode
parameter GPRV_OUTPUT_ENABLE18   = 32'h00000000; // Default 3 stated18 outs18
parameter GPRV_OUTPUT_VALUE18    = 32'h00000000; // Default to be driven18
parameter GPRV_INPUT_VALUE18     = 32'h00000000; // Read defaults18 to zero
parameter GPRV_INT_STATUS18      = 32'h00000000; // Int18 status cleared18



   //assign ad_bypass_mode18    = ( addr == GPR_BYPASS_MODE18 );   
   assign ad_direction_mode18 = ( addr == GPR_DIRECTION_MODE18 );   
   assign ad_output_enable18  = ( addr == GPR_OUTPUT_ENABLE18 );   
   assign ad_output_value18   = ( addr == GPR_OUTPUT_VALUE18 );   
   assign ad_int_status18     = ( addr == GPR_INT_STATUS18 );   

   // assignments18
   
   assign interrupt18         = ( int_status18);

   assign interrupt_trigger18 = ( direction_mode18 & int_event18 ); 

   assign int_event18 = ((s_synch18 ^ input_value18) & ((s_synch18)));

   always @( ad_int_status18 or read )
   begin : p_status_clear18

     for ( ia18 = 0; ia18 < 16; ia18 = ia18 + 1 )
     begin

       status_clear18[ia18] = ( ad_int_status18 & read );

     end // for ia18

   end // p_status_clear18

   // p_write_register18 : clocked18 / asynchronous18
   //
   // this section18 contains18 all the code18 to write registers

   always @(posedge pclk18 or negedge n_reset18)
   begin : p_write_register18

      if (~n_reset18)
      
       begin
         direction_mode18  <= GPRV_DIRECTION_MODE18;
         output_enable18   <= GPRV_OUTPUT_ENABLE18;
         output_value18    <= GPRV_OUTPUT_VALUE18;
       end
      
      else 
      
       begin
      
         if (write == 1'b1) // Write value to registers
      
          begin
              
            // Write Mode18
         
            if ( ad_direction_mode18 ) 
               direction_mode18 <= wdata18;
 
            if ( ad_output_enable18 ) 
               output_enable18  <= wdata18;
     
            if ( ad_output_value18 )
               output_value18   <= wdata18;

              

           end // if write
         
       end // else: ~if(~n_reset18)
      
   end // block: p_write_register18



   // p_metastable18 : clocked18 / asynchronous18 
   //
   // This18 process  acts18 to remove  metastability18 propagation
   // Only18 for input to GPIO18
   // In Bypass18 mode pin_in18 passes18 straight18 through

   always @(posedge pclk18 or negedge n_reset18)
      
   begin : p_metastable18
      
      if (~n_reset18)
        begin
         
         s_synch18       <= {16 {1'b0}};
         s_synch_two18   <= {16 {1'b0}};
         input_value18   <= GPRV_INPUT_VALUE18;
         
        end // if (~n_reset18)
      
      else         
        begin
         
         input_value18   <= s_synch18;
         s_synch18       <= s_synch_two18;
         s_synch_two18   <= pin_in18;

        end // else: ~if(~n_reset18)
      
   end // block: p_metastable18


   // p_interrupt18 : clocked18 / asynchronous18 
   //
   // These18 lines18 set and clear the interrupt18 status

   always @(posedge pclk18 or negedge n_reset18)
   begin : p_interrupt18
      
      if (~n_reset18)
         int_status18      <= GPRV_INT_STATUS18;
      
      else 
         int_status18      <= ( int_status18 & ~(status_clear18) // read & clear
                            ) |
                            interrupt_trigger18;             // new interrupt18
        
   end // block: p_interrupt18
   
   
   // p_read_register18  : clocked18 / asynchronous18 
   //
   // this process registers the output values

   always @(posedge pclk18 or negedge n_reset18)

      begin : p_read_register18
         
         if (~n_reset18)
         
           begin

            rdata18 <= {16 {1'b0}};

           end
           
         else //if not reset
         
           begin
         
            if (read == 1'b1)
            
              begin
            
               case (addr)
            
                  
                  GPR_DIRECTION_MODE18:
                     rdata18 <= direction_mode18;
                  
                  GPR_OUTPUT_ENABLE18:
                     rdata18 <= output_enable18;
                  
                  GPR_OUTPUT_VALUE18:
                     rdata18 <= output_value18;
                  
                  GPR_INT_STATUS18:
                     rdata18 <= int_status18;
                  
                  default: // if GPR_INPUT_VALUE18 or unmapped reg addr
                     rdata18 <= input_value18;
            
               endcase
            
              end //end if read
            
            else //in not read
            
              begin // if not a valid read access, keep18 '0'-s 
              
               rdata18 <= {16 {1'b0}};
              
              end //end if not read
              
           end //end else if not reset

      end // p_read_register18


   assign pin_out18 = 
        ( output_value18 ) ;
     
   assign pin_oe_n18 = 
      ( ( ~(output_enable18 & ~(direction_mode18)) ) |
        tri_state_enable18 ) ;

                
  
endmodule // gpio_subunit18



   
   



   
