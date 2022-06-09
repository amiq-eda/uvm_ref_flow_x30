//File27 name   : gpio_lite_subunit27.v
//Title27       : 
//Created27     : 1999
//Description27 : Parametrised27 GPIO27 pin27 circuits27
//Notes27       : 
//----------------------------------------------------------------------
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


module gpio_lite_subunit27(
  //Inputs27

  n_reset27,
  pclk27,

  read,
  write,
  addr,

  wdata27,
  pin_in27,

  tri_state_enable27,

  //Outputs27
 
  interrupt27,

  rdata27,
  pin_oe_n27,
  pin_out27

);
 
   // Inputs27
   
   // Clocks27   
   input n_reset27;            // asynch27 reset, active low27
   input pclk27;               // Ppclk27

   // Controls27
   input read;               // select27 GPIO27 read
   input write;              // select27 GPIO27 write
   input [5:0] 
         addr;               // address bus of selected master27

   // Dataflow27
   input [15:0]
         wdata27;              // GPIO27 Input27
   input [15:0]
         pin_in27;             // input data from pin27

   //Design27 for Test27 Inputs27
   input [15:0]
         tri_state_enable27;   // disables27 op enable -> Z27




   
   // Outputs27
   
   // Controls27
   output [15:0]
          interrupt27;         // interupt27 for input pin27 change

   // Dataflow27
   output [15:0]
          rdata27;             // GPIO27 Output27
   output [15:0]
          pin_oe_n27;          // output enable signal27 to pin27
   output [15:0]
          pin_out27;           // output signal27 to pin27
   



   
   // Registers27 in module

   //Define27 Physical27 registers in amba_unit27
   reg    [15:0]
          direction_mode27;     // 1=Input27 0=Output27              RW
   reg    [15:0]
          output_enable27;      // Output27 active                 RW
   reg    [15:0]
          output_value27;       // Value outputed27 from reg       RW
   reg    [15:0]
          input_value27;        // Value input from bus          R
   reg    [15:0]
          int_status27;         // Interrupt27 status              R

   // registers to remove metastability27
   reg    [15:0]
          s_synch27;            //stage_two27
   reg    [15:0]
          s_synch_two27;        //stage_one27 - to ext pin27
   
   
    
          
   // Registers27 for outputs27
   reg    [15:0]
          rdata27;              // prdata27 reg
   wire   [15:0]
          pin_oe_n27;           // gpio27 output enable
   wire   [15:0]
          pin_out27;            // gpio27 output value
   wire   [15:0]
          interrupt27;          // gpio27 interrupt27
   wire   [15:0]
          interrupt_trigger27;  // 1 sets27 interrupt27 status
   reg    [15:0]
          status_clear27;       // 1 clears27 interrupt27 status
   wire   [15:0]
          int_event27;          // 1 detects27 an interrupt27 event

   integer ia27;                // loop variable
   


   // address decodes27
   wire   ad_direction_mode27;  // 1=Input27 0=Output27              RW
   wire   ad_output_enable27;   // Output27 active                 RW
   wire   ad_output_value27;    // Value outputed27 from reg       RW
   wire   ad_int_status27;      // Interrupt27 status              R
   
//Register addresses27
//If27 modifying27 the APB27 address (PADDR27) width change the following27 bit widths27
parameter GPR_DIRECTION_MODE27   = 6'h04;       // set pin27 to either27 I27 or O27
parameter GPR_OUTPUT_ENABLE27    = 6'h08;       // contains27 oe27 control27 value
parameter GPR_OUTPUT_VALUE27     = 6'h0C;       // output value to be driven27
parameter GPR_INPUT_VALUE27      = 6'h10;       // gpio27 input value reg
parameter GPR_INT_STATUS27       = 6'h20;       // Interrupt27 status register

//Reset27 Values27
//If27 modifying27 the GPIO27 width change the following27 bit widths27
//parameter GPRV_RSRVD27            = 32'h0000_0000; // Reserved27
parameter GPRV_DIRECTION_MODE27  = 32'h00000000; // Default to output mode
parameter GPRV_OUTPUT_ENABLE27   = 32'h00000000; // Default 3 stated27 outs27
parameter GPRV_OUTPUT_VALUE27    = 32'h00000000; // Default to be driven27
parameter GPRV_INPUT_VALUE27     = 32'h00000000; // Read defaults27 to zero
parameter GPRV_INT_STATUS27      = 32'h00000000; // Int27 status cleared27



   //assign ad_bypass_mode27    = ( addr == GPR_BYPASS_MODE27 );   
   assign ad_direction_mode27 = ( addr == GPR_DIRECTION_MODE27 );   
   assign ad_output_enable27  = ( addr == GPR_OUTPUT_ENABLE27 );   
   assign ad_output_value27   = ( addr == GPR_OUTPUT_VALUE27 );   
   assign ad_int_status27     = ( addr == GPR_INT_STATUS27 );   

   // assignments27
   
   assign interrupt27         = ( int_status27);

   assign interrupt_trigger27 = ( direction_mode27 & int_event27 ); 

   assign int_event27 = ((s_synch27 ^ input_value27) & ((s_synch27)));

   always @( ad_int_status27 or read )
   begin : p_status_clear27

     for ( ia27 = 0; ia27 < 16; ia27 = ia27 + 1 )
     begin

       status_clear27[ia27] = ( ad_int_status27 & read );

     end // for ia27

   end // p_status_clear27

   // p_write_register27 : clocked27 / asynchronous27
   //
   // this section27 contains27 all the code27 to write registers

   always @(posedge pclk27 or negedge n_reset27)
   begin : p_write_register27

      if (~n_reset27)
      
       begin
         direction_mode27  <= GPRV_DIRECTION_MODE27;
         output_enable27   <= GPRV_OUTPUT_ENABLE27;
         output_value27    <= GPRV_OUTPUT_VALUE27;
       end
      
      else 
      
       begin
      
         if (write == 1'b1) // Write value to registers
      
          begin
              
            // Write Mode27
         
            if ( ad_direction_mode27 ) 
               direction_mode27 <= wdata27;
 
            if ( ad_output_enable27 ) 
               output_enable27  <= wdata27;
     
            if ( ad_output_value27 )
               output_value27   <= wdata27;

              

           end // if write
         
       end // else: ~if(~n_reset27)
      
   end // block: p_write_register27



   // p_metastable27 : clocked27 / asynchronous27 
   //
   // This27 process  acts27 to remove  metastability27 propagation
   // Only27 for input to GPIO27
   // In Bypass27 mode pin_in27 passes27 straight27 through

   always @(posedge pclk27 or negedge n_reset27)
      
   begin : p_metastable27
      
      if (~n_reset27)
        begin
         
         s_synch27       <= {16 {1'b0}};
         s_synch_two27   <= {16 {1'b0}};
         input_value27   <= GPRV_INPUT_VALUE27;
         
        end // if (~n_reset27)
      
      else         
        begin
         
         input_value27   <= s_synch27;
         s_synch27       <= s_synch_two27;
         s_synch_two27   <= pin_in27;

        end // else: ~if(~n_reset27)
      
   end // block: p_metastable27


   // p_interrupt27 : clocked27 / asynchronous27 
   //
   // These27 lines27 set and clear the interrupt27 status

   always @(posedge pclk27 or negedge n_reset27)
   begin : p_interrupt27
      
      if (~n_reset27)
         int_status27      <= GPRV_INT_STATUS27;
      
      else 
         int_status27      <= ( int_status27 & ~(status_clear27) // read & clear
                            ) |
                            interrupt_trigger27;             // new interrupt27
        
   end // block: p_interrupt27
   
   
   // p_read_register27  : clocked27 / asynchronous27 
   //
   // this process registers the output values

   always @(posedge pclk27 or negedge n_reset27)

      begin : p_read_register27
         
         if (~n_reset27)
         
           begin

            rdata27 <= {16 {1'b0}};

           end
           
         else //if not reset
         
           begin
         
            if (read == 1'b1)
            
              begin
            
               case (addr)
            
                  
                  GPR_DIRECTION_MODE27:
                     rdata27 <= direction_mode27;
                  
                  GPR_OUTPUT_ENABLE27:
                     rdata27 <= output_enable27;
                  
                  GPR_OUTPUT_VALUE27:
                     rdata27 <= output_value27;
                  
                  GPR_INT_STATUS27:
                     rdata27 <= int_status27;
                  
                  default: // if GPR_INPUT_VALUE27 or unmapped reg addr
                     rdata27 <= input_value27;
            
               endcase
            
              end //end if read
            
            else //in not read
            
              begin // if not a valid read access, keep27 '0'-s 
              
               rdata27 <= {16 {1'b0}};
              
              end //end if not read
              
           end //end else if not reset

      end // p_read_register27


   assign pin_out27 = 
        ( output_value27 ) ;
     
   assign pin_oe_n27 = 
      ( ( ~(output_enable27 & ~(direction_mode27)) ) |
        tri_state_enable27 ) ;

                
  
endmodule // gpio_subunit27



   
   



   
