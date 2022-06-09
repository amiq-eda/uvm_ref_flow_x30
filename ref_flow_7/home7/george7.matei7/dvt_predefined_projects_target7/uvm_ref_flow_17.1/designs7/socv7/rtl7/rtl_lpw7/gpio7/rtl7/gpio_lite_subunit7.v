//File7 name   : gpio_lite_subunit7.v
//Title7       : 
//Created7     : 1999
//Description7 : Parametrised7 GPIO7 pin7 circuits7
//Notes7       : 
//----------------------------------------------------------------------
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


module gpio_lite_subunit7(
  //Inputs7

  n_reset7,
  pclk7,

  read,
  write,
  addr,

  wdata7,
  pin_in7,

  tri_state_enable7,

  //Outputs7
 
  interrupt7,

  rdata7,
  pin_oe_n7,
  pin_out7

);
 
   // Inputs7
   
   // Clocks7   
   input n_reset7;            // asynch7 reset, active low7
   input pclk7;               // Ppclk7

   // Controls7
   input read;               // select7 GPIO7 read
   input write;              // select7 GPIO7 write
   input [5:0] 
         addr;               // address bus of selected master7

   // Dataflow7
   input [15:0]
         wdata7;              // GPIO7 Input7
   input [15:0]
         pin_in7;             // input data from pin7

   //Design7 for Test7 Inputs7
   input [15:0]
         tri_state_enable7;   // disables7 op enable -> Z7




   
   // Outputs7
   
   // Controls7
   output [15:0]
          interrupt7;         // interupt7 for input pin7 change

   // Dataflow7
   output [15:0]
          rdata7;             // GPIO7 Output7
   output [15:0]
          pin_oe_n7;          // output enable signal7 to pin7
   output [15:0]
          pin_out7;           // output signal7 to pin7
   



   
   // Registers7 in module

   //Define7 Physical7 registers in amba_unit7
   reg    [15:0]
          direction_mode7;     // 1=Input7 0=Output7              RW
   reg    [15:0]
          output_enable7;      // Output7 active                 RW
   reg    [15:0]
          output_value7;       // Value outputed7 from reg       RW
   reg    [15:0]
          input_value7;        // Value input from bus          R
   reg    [15:0]
          int_status7;         // Interrupt7 status              R

   // registers to remove metastability7
   reg    [15:0]
          s_synch7;            //stage_two7
   reg    [15:0]
          s_synch_two7;        //stage_one7 - to ext pin7
   
   
    
          
   // Registers7 for outputs7
   reg    [15:0]
          rdata7;              // prdata7 reg
   wire   [15:0]
          pin_oe_n7;           // gpio7 output enable
   wire   [15:0]
          pin_out7;            // gpio7 output value
   wire   [15:0]
          interrupt7;          // gpio7 interrupt7
   wire   [15:0]
          interrupt_trigger7;  // 1 sets7 interrupt7 status
   reg    [15:0]
          status_clear7;       // 1 clears7 interrupt7 status
   wire   [15:0]
          int_event7;          // 1 detects7 an interrupt7 event

   integer ia7;                // loop variable
   


   // address decodes7
   wire   ad_direction_mode7;  // 1=Input7 0=Output7              RW
   wire   ad_output_enable7;   // Output7 active                 RW
   wire   ad_output_value7;    // Value outputed7 from reg       RW
   wire   ad_int_status7;      // Interrupt7 status              R
   
//Register addresses7
//If7 modifying7 the APB7 address (PADDR7) width change the following7 bit widths7
parameter GPR_DIRECTION_MODE7   = 6'h04;       // set pin7 to either7 I7 or O7
parameter GPR_OUTPUT_ENABLE7    = 6'h08;       // contains7 oe7 control7 value
parameter GPR_OUTPUT_VALUE7     = 6'h0C;       // output value to be driven7
parameter GPR_INPUT_VALUE7      = 6'h10;       // gpio7 input value reg
parameter GPR_INT_STATUS7       = 6'h20;       // Interrupt7 status register

//Reset7 Values7
//If7 modifying7 the GPIO7 width change the following7 bit widths7
//parameter GPRV_RSRVD7            = 32'h0000_0000; // Reserved7
parameter GPRV_DIRECTION_MODE7  = 32'h00000000; // Default to output mode
parameter GPRV_OUTPUT_ENABLE7   = 32'h00000000; // Default 3 stated7 outs7
parameter GPRV_OUTPUT_VALUE7    = 32'h00000000; // Default to be driven7
parameter GPRV_INPUT_VALUE7     = 32'h00000000; // Read defaults7 to zero
parameter GPRV_INT_STATUS7      = 32'h00000000; // Int7 status cleared7



   //assign ad_bypass_mode7    = ( addr == GPR_BYPASS_MODE7 );   
   assign ad_direction_mode7 = ( addr == GPR_DIRECTION_MODE7 );   
   assign ad_output_enable7  = ( addr == GPR_OUTPUT_ENABLE7 );   
   assign ad_output_value7   = ( addr == GPR_OUTPUT_VALUE7 );   
   assign ad_int_status7     = ( addr == GPR_INT_STATUS7 );   

   // assignments7
   
   assign interrupt7         = ( int_status7);

   assign interrupt_trigger7 = ( direction_mode7 & int_event7 ); 

   assign int_event7 = ((s_synch7 ^ input_value7) & ((s_synch7)));

   always @( ad_int_status7 or read )
   begin : p_status_clear7

     for ( ia7 = 0; ia7 < 16; ia7 = ia7 + 1 )
     begin

       status_clear7[ia7] = ( ad_int_status7 & read );

     end // for ia7

   end // p_status_clear7

   // p_write_register7 : clocked7 / asynchronous7
   //
   // this section7 contains7 all the code7 to write registers

   always @(posedge pclk7 or negedge n_reset7)
   begin : p_write_register7

      if (~n_reset7)
      
       begin
         direction_mode7  <= GPRV_DIRECTION_MODE7;
         output_enable7   <= GPRV_OUTPUT_ENABLE7;
         output_value7    <= GPRV_OUTPUT_VALUE7;
       end
      
      else 
      
       begin
      
         if (write == 1'b1) // Write value to registers
      
          begin
              
            // Write Mode7
         
            if ( ad_direction_mode7 ) 
               direction_mode7 <= wdata7;
 
            if ( ad_output_enable7 ) 
               output_enable7  <= wdata7;
     
            if ( ad_output_value7 )
               output_value7   <= wdata7;

              

           end // if write
         
       end // else: ~if(~n_reset7)
      
   end // block: p_write_register7



   // p_metastable7 : clocked7 / asynchronous7 
   //
   // This7 process  acts7 to remove  metastability7 propagation
   // Only7 for input to GPIO7
   // In Bypass7 mode pin_in7 passes7 straight7 through

   always @(posedge pclk7 or negedge n_reset7)
      
   begin : p_metastable7
      
      if (~n_reset7)
        begin
         
         s_synch7       <= {16 {1'b0}};
         s_synch_two7   <= {16 {1'b0}};
         input_value7   <= GPRV_INPUT_VALUE7;
         
        end // if (~n_reset7)
      
      else         
        begin
         
         input_value7   <= s_synch7;
         s_synch7       <= s_synch_two7;
         s_synch_two7   <= pin_in7;

        end // else: ~if(~n_reset7)
      
   end // block: p_metastable7


   // p_interrupt7 : clocked7 / asynchronous7 
   //
   // These7 lines7 set and clear the interrupt7 status

   always @(posedge pclk7 or negedge n_reset7)
   begin : p_interrupt7
      
      if (~n_reset7)
         int_status7      <= GPRV_INT_STATUS7;
      
      else 
         int_status7      <= ( int_status7 & ~(status_clear7) // read & clear
                            ) |
                            interrupt_trigger7;             // new interrupt7
        
   end // block: p_interrupt7
   
   
   // p_read_register7  : clocked7 / asynchronous7 
   //
   // this process registers the output values

   always @(posedge pclk7 or negedge n_reset7)

      begin : p_read_register7
         
         if (~n_reset7)
         
           begin

            rdata7 <= {16 {1'b0}};

           end
           
         else //if not reset
         
           begin
         
            if (read == 1'b1)
            
              begin
            
               case (addr)
            
                  
                  GPR_DIRECTION_MODE7:
                     rdata7 <= direction_mode7;
                  
                  GPR_OUTPUT_ENABLE7:
                     rdata7 <= output_enable7;
                  
                  GPR_OUTPUT_VALUE7:
                     rdata7 <= output_value7;
                  
                  GPR_INT_STATUS7:
                     rdata7 <= int_status7;
                  
                  default: // if GPR_INPUT_VALUE7 or unmapped reg addr
                     rdata7 <= input_value7;
            
               endcase
            
              end //end if read
            
            else //in not read
            
              begin // if not a valid read access, keep7 '0'-s 
              
               rdata7 <= {16 {1'b0}};
              
              end //end if not read
              
           end //end else if not reset

      end // p_read_register7


   assign pin_out7 = 
        ( output_value7 ) ;
     
   assign pin_oe_n7 = 
      ( ( ~(output_enable7 & ~(direction_mode7)) ) |
        tri_state_enable7 ) ;

                
  
endmodule // gpio_subunit7



   
   



   
