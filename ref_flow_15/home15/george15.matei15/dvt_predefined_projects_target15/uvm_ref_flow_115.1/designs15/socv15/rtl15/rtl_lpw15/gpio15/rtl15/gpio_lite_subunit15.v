//File15 name   : gpio_lite_subunit15.v
//Title15       : 
//Created15     : 1999
//Description15 : Parametrised15 GPIO15 pin15 circuits15
//Notes15       : 
//----------------------------------------------------------------------
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


module gpio_lite_subunit15(
  //Inputs15

  n_reset15,
  pclk15,

  read,
  write,
  addr,

  wdata15,
  pin_in15,

  tri_state_enable15,

  //Outputs15
 
  interrupt15,

  rdata15,
  pin_oe_n15,
  pin_out15

);
 
   // Inputs15
   
   // Clocks15   
   input n_reset15;            // asynch15 reset, active low15
   input pclk15;               // Ppclk15

   // Controls15
   input read;               // select15 GPIO15 read
   input write;              // select15 GPIO15 write
   input [5:0] 
         addr;               // address bus of selected master15

   // Dataflow15
   input [15:0]
         wdata15;              // GPIO15 Input15
   input [15:0]
         pin_in15;             // input data from pin15

   //Design15 for Test15 Inputs15
   input [15:0]
         tri_state_enable15;   // disables15 op enable -> Z15




   
   // Outputs15
   
   // Controls15
   output [15:0]
          interrupt15;         // interupt15 for input pin15 change

   // Dataflow15
   output [15:0]
          rdata15;             // GPIO15 Output15
   output [15:0]
          pin_oe_n15;          // output enable signal15 to pin15
   output [15:0]
          pin_out15;           // output signal15 to pin15
   



   
   // Registers15 in module

   //Define15 Physical15 registers in amba_unit15
   reg    [15:0]
          direction_mode15;     // 1=Input15 0=Output15              RW
   reg    [15:0]
          output_enable15;      // Output15 active                 RW
   reg    [15:0]
          output_value15;       // Value outputed15 from reg       RW
   reg    [15:0]
          input_value15;        // Value input from bus          R
   reg    [15:0]
          int_status15;         // Interrupt15 status              R

   // registers to remove metastability15
   reg    [15:0]
          s_synch15;            //stage_two15
   reg    [15:0]
          s_synch_two15;        //stage_one15 - to ext pin15
   
   
    
          
   // Registers15 for outputs15
   reg    [15:0]
          rdata15;              // prdata15 reg
   wire   [15:0]
          pin_oe_n15;           // gpio15 output enable
   wire   [15:0]
          pin_out15;            // gpio15 output value
   wire   [15:0]
          interrupt15;          // gpio15 interrupt15
   wire   [15:0]
          interrupt_trigger15;  // 1 sets15 interrupt15 status
   reg    [15:0]
          status_clear15;       // 1 clears15 interrupt15 status
   wire   [15:0]
          int_event15;          // 1 detects15 an interrupt15 event

   integer ia15;                // loop variable
   


   // address decodes15
   wire   ad_direction_mode15;  // 1=Input15 0=Output15              RW
   wire   ad_output_enable15;   // Output15 active                 RW
   wire   ad_output_value15;    // Value outputed15 from reg       RW
   wire   ad_int_status15;      // Interrupt15 status              R
   
//Register addresses15
//If15 modifying15 the APB15 address (PADDR15) width change the following15 bit widths15
parameter GPR_DIRECTION_MODE15   = 6'h04;       // set pin15 to either15 I15 or O15
parameter GPR_OUTPUT_ENABLE15    = 6'h08;       // contains15 oe15 control15 value
parameter GPR_OUTPUT_VALUE15     = 6'h0C;       // output value to be driven15
parameter GPR_INPUT_VALUE15      = 6'h10;       // gpio15 input value reg
parameter GPR_INT_STATUS15       = 6'h20;       // Interrupt15 status register

//Reset15 Values15
//If15 modifying15 the GPIO15 width change the following15 bit widths15
//parameter GPRV_RSRVD15            = 32'h0000_0000; // Reserved15
parameter GPRV_DIRECTION_MODE15  = 32'h00000000; // Default to output mode
parameter GPRV_OUTPUT_ENABLE15   = 32'h00000000; // Default 3 stated15 outs15
parameter GPRV_OUTPUT_VALUE15    = 32'h00000000; // Default to be driven15
parameter GPRV_INPUT_VALUE15     = 32'h00000000; // Read defaults15 to zero
parameter GPRV_INT_STATUS15      = 32'h00000000; // Int15 status cleared15



   //assign ad_bypass_mode15    = ( addr == GPR_BYPASS_MODE15 );   
   assign ad_direction_mode15 = ( addr == GPR_DIRECTION_MODE15 );   
   assign ad_output_enable15  = ( addr == GPR_OUTPUT_ENABLE15 );   
   assign ad_output_value15   = ( addr == GPR_OUTPUT_VALUE15 );   
   assign ad_int_status15     = ( addr == GPR_INT_STATUS15 );   

   // assignments15
   
   assign interrupt15         = ( int_status15);

   assign interrupt_trigger15 = ( direction_mode15 & int_event15 ); 

   assign int_event15 = ((s_synch15 ^ input_value15) & ((s_synch15)));

   always @( ad_int_status15 or read )
   begin : p_status_clear15

     for ( ia15 = 0; ia15 < 16; ia15 = ia15 + 1 )
     begin

       status_clear15[ia15] = ( ad_int_status15 & read );

     end // for ia15

   end // p_status_clear15

   // p_write_register15 : clocked15 / asynchronous15
   //
   // this section15 contains15 all the code15 to write registers

   always @(posedge pclk15 or negedge n_reset15)
   begin : p_write_register15

      if (~n_reset15)
      
       begin
         direction_mode15  <= GPRV_DIRECTION_MODE15;
         output_enable15   <= GPRV_OUTPUT_ENABLE15;
         output_value15    <= GPRV_OUTPUT_VALUE15;
       end
      
      else 
      
       begin
      
         if (write == 1'b1) // Write value to registers
      
          begin
              
            // Write Mode15
         
            if ( ad_direction_mode15 ) 
               direction_mode15 <= wdata15;
 
            if ( ad_output_enable15 ) 
               output_enable15  <= wdata15;
     
            if ( ad_output_value15 )
               output_value15   <= wdata15;

              

           end // if write
         
       end // else: ~if(~n_reset15)
      
   end // block: p_write_register15



   // p_metastable15 : clocked15 / asynchronous15 
   //
   // This15 process  acts15 to remove  metastability15 propagation
   // Only15 for input to GPIO15
   // In Bypass15 mode pin_in15 passes15 straight15 through

   always @(posedge pclk15 or negedge n_reset15)
      
   begin : p_metastable15
      
      if (~n_reset15)
        begin
         
         s_synch15       <= {16 {1'b0}};
         s_synch_two15   <= {16 {1'b0}};
         input_value15   <= GPRV_INPUT_VALUE15;
         
        end // if (~n_reset15)
      
      else         
        begin
         
         input_value15   <= s_synch15;
         s_synch15       <= s_synch_two15;
         s_synch_two15   <= pin_in15;

        end // else: ~if(~n_reset15)
      
   end // block: p_metastable15


   // p_interrupt15 : clocked15 / asynchronous15 
   //
   // These15 lines15 set and clear the interrupt15 status

   always @(posedge pclk15 or negedge n_reset15)
   begin : p_interrupt15
      
      if (~n_reset15)
         int_status15      <= GPRV_INT_STATUS15;
      
      else 
         int_status15      <= ( int_status15 & ~(status_clear15) // read & clear
                            ) |
                            interrupt_trigger15;             // new interrupt15
        
   end // block: p_interrupt15
   
   
   // p_read_register15  : clocked15 / asynchronous15 
   //
   // this process registers the output values

   always @(posedge pclk15 or negedge n_reset15)

      begin : p_read_register15
         
         if (~n_reset15)
         
           begin

            rdata15 <= {16 {1'b0}};

           end
           
         else //if not reset
         
           begin
         
            if (read == 1'b1)
            
              begin
            
               case (addr)
            
                  
                  GPR_DIRECTION_MODE15:
                     rdata15 <= direction_mode15;
                  
                  GPR_OUTPUT_ENABLE15:
                     rdata15 <= output_enable15;
                  
                  GPR_OUTPUT_VALUE15:
                     rdata15 <= output_value15;
                  
                  GPR_INT_STATUS15:
                     rdata15 <= int_status15;
                  
                  default: // if GPR_INPUT_VALUE15 or unmapped reg addr
                     rdata15 <= input_value15;
            
               endcase
            
              end //end if read
            
            else //in not read
            
              begin // if not a valid read access, keep15 '0'-s 
              
               rdata15 <= {16 {1'b0}};
              
              end //end if not read
              
           end //end else if not reset

      end // p_read_register15


   assign pin_out15 = 
        ( output_value15 ) ;
     
   assign pin_oe_n15 = 
      ( ( ~(output_enable15 & ~(direction_mode15)) ) |
        tri_state_enable15 ) ;

                
  
endmodule // gpio_subunit15



   
   



   
