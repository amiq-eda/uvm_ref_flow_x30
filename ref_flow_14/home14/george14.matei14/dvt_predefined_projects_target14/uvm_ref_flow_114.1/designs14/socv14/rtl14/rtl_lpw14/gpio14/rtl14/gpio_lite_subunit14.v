//File14 name   : gpio_lite_subunit14.v
//Title14       : 
//Created14     : 1999
//Description14 : Parametrised14 GPIO14 pin14 circuits14
//Notes14       : 
//----------------------------------------------------------------------
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


module gpio_lite_subunit14(
  //Inputs14

  n_reset14,
  pclk14,

  read,
  write,
  addr,

  wdata14,
  pin_in14,

  tri_state_enable14,

  //Outputs14
 
  interrupt14,

  rdata14,
  pin_oe_n14,
  pin_out14

);
 
   // Inputs14
   
   // Clocks14   
   input n_reset14;            // asynch14 reset, active low14
   input pclk14;               // Ppclk14

   // Controls14
   input read;               // select14 GPIO14 read
   input write;              // select14 GPIO14 write
   input [5:0] 
         addr;               // address bus of selected master14

   // Dataflow14
   input [15:0]
         wdata14;              // GPIO14 Input14
   input [15:0]
         pin_in14;             // input data from pin14

   //Design14 for Test14 Inputs14
   input [15:0]
         tri_state_enable14;   // disables14 op enable -> Z14




   
   // Outputs14
   
   // Controls14
   output [15:0]
          interrupt14;         // interupt14 for input pin14 change

   // Dataflow14
   output [15:0]
          rdata14;             // GPIO14 Output14
   output [15:0]
          pin_oe_n14;          // output enable signal14 to pin14
   output [15:0]
          pin_out14;           // output signal14 to pin14
   



   
   // Registers14 in module

   //Define14 Physical14 registers in amba_unit14
   reg    [15:0]
          direction_mode14;     // 1=Input14 0=Output14              RW
   reg    [15:0]
          output_enable14;      // Output14 active                 RW
   reg    [15:0]
          output_value14;       // Value outputed14 from reg       RW
   reg    [15:0]
          input_value14;        // Value input from bus          R
   reg    [15:0]
          int_status14;         // Interrupt14 status              R

   // registers to remove metastability14
   reg    [15:0]
          s_synch14;            //stage_two14
   reg    [15:0]
          s_synch_two14;        //stage_one14 - to ext pin14
   
   
    
          
   // Registers14 for outputs14
   reg    [15:0]
          rdata14;              // prdata14 reg
   wire   [15:0]
          pin_oe_n14;           // gpio14 output enable
   wire   [15:0]
          pin_out14;            // gpio14 output value
   wire   [15:0]
          interrupt14;          // gpio14 interrupt14
   wire   [15:0]
          interrupt_trigger14;  // 1 sets14 interrupt14 status
   reg    [15:0]
          status_clear14;       // 1 clears14 interrupt14 status
   wire   [15:0]
          int_event14;          // 1 detects14 an interrupt14 event

   integer ia14;                // loop variable
   


   // address decodes14
   wire   ad_direction_mode14;  // 1=Input14 0=Output14              RW
   wire   ad_output_enable14;   // Output14 active                 RW
   wire   ad_output_value14;    // Value outputed14 from reg       RW
   wire   ad_int_status14;      // Interrupt14 status              R
   
//Register addresses14
//If14 modifying14 the APB14 address (PADDR14) width change the following14 bit widths14
parameter GPR_DIRECTION_MODE14   = 6'h04;       // set pin14 to either14 I14 or O14
parameter GPR_OUTPUT_ENABLE14    = 6'h08;       // contains14 oe14 control14 value
parameter GPR_OUTPUT_VALUE14     = 6'h0C;       // output value to be driven14
parameter GPR_INPUT_VALUE14      = 6'h10;       // gpio14 input value reg
parameter GPR_INT_STATUS14       = 6'h20;       // Interrupt14 status register

//Reset14 Values14
//If14 modifying14 the GPIO14 width change the following14 bit widths14
//parameter GPRV_RSRVD14            = 32'h0000_0000; // Reserved14
parameter GPRV_DIRECTION_MODE14  = 32'h00000000; // Default to output mode
parameter GPRV_OUTPUT_ENABLE14   = 32'h00000000; // Default 3 stated14 outs14
parameter GPRV_OUTPUT_VALUE14    = 32'h00000000; // Default to be driven14
parameter GPRV_INPUT_VALUE14     = 32'h00000000; // Read defaults14 to zero
parameter GPRV_INT_STATUS14      = 32'h00000000; // Int14 status cleared14



   //assign ad_bypass_mode14    = ( addr == GPR_BYPASS_MODE14 );   
   assign ad_direction_mode14 = ( addr == GPR_DIRECTION_MODE14 );   
   assign ad_output_enable14  = ( addr == GPR_OUTPUT_ENABLE14 );   
   assign ad_output_value14   = ( addr == GPR_OUTPUT_VALUE14 );   
   assign ad_int_status14     = ( addr == GPR_INT_STATUS14 );   

   // assignments14
   
   assign interrupt14         = ( int_status14);

   assign interrupt_trigger14 = ( direction_mode14 & int_event14 ); 

   assign int_event14 = ((s_synch14 ^ input_value14) & ((s_synch14)));

   always @( ad_int_status14 or read )
   begin : p_status_clear14

     for ( ia14 = 0; ia14 < 16; ia14 = ia14 + 1 )
     begin

       status_clear14[ia14] = ( ad_int_status14 & read );

     end // for ia14

   end // p_status_clear14

   // p_write_register14 : clocked14 / asynchronous14
   //
   // this section14 contains14 all the code14 to write registers

   always @(posedge pclk14 or negedge n_reset14)
   begin : p_write_register14

      if (~n_reset14)
      
       begin
         direction_mode14  <= GPRV_DIRECTION_MODE14;
         output_enable14   <= GPRV_OUTPUT_ENABLE14;
         output_value14    <= GPRV_OUTPUT_VALUE14;
       end
      
      else 
      
       begin
      
         if (write == 1'b1) // Write value to registers
      
          begin
              
            // Write Mode14
         
            if ( ad_direction_mode14 ) 
               direction_mode14 <= wdata14;
 
            if ( ad_output_enable14 ) 
               output_enable14  <= wdata14;
     
            if ( ad_output_value14 )
               output_value14   <= wdata14;

              

           end // if write
         
       end // else: ~if(~n_reset14)
      
   end // block: p_write_register14



   // p_metastable14 : clocked14 / asynchronous14 
   //
   // This14 process  acts14 to remove  metastability14 propagation
   // Only14 for input to GPIO14
   // In Bypass14 mode pin_in14 passes14 straight14 through

   always @(posedge pclk14 or negedge n_reset14)
      
   begin : p_metastable14
      
      if (~n_reset14)
        begin
         
         s_synch14       <= {16 {1'b0}};
         s_synch_two14   <= {16 {1'b0}};
         input_value14   <= GPRV_INPUT_VALUE14;
         
        end // if (~n_reset14)
      
      else         
        begin
         
         input_value14   <= s_synch14;
         s_synch14       <= s_synch_two14;
         s_synch_two14   <= pin_in14;

        end // else: ~if(~n_reset14)
      
   end // block: p_metastable14


   // p_interrupt14 : clocked14 / asynchronous14 
   //
   // These14 lines14 set and clear the interrupt14 status

   always @(posedge pclk14 or negedge n_reset14)
   begin : p_interrupt14
      
      if (~n_reset14)
         int_status14      <= GPRV_INT_STATUS14;
      
      else 
         int_status14      <= ( int_status14 & ~(status_clear14) // read & clear
                            ) |
                            interrupt_trigger14;             // new interrupt14
        
   end // block: p_interrupt14
   
   
   // p_read_register14  : clocked14 / asynchronous14 
   //
   // this process registers the output values

   always @(posedge pclk14 or negedge n_reset14)

      begin : p_read_register14
         
         if (~n_reset14)
         
           begin

            rdata14 <= {16 {1'b0}};

           end
           
         else //if not reset
         
           begin
         
            if (read == 1'b1)
            
              begin
            
               case (addr)
            
                  
                  GPR_DIRECTION_MODE14:
                     rdata14 <= direction_mode14;
                  
                  GPR_OUTPUT_ENABLE14:
                     rdata14 <= output_enable14;
                  
                  GPR_OUTPUT_VALUE14:
                     rdata14 <= output_value14;
                  
                  GPR_INT_STATUS14:
                     rdata14 <= int_status14;
                  
                  default: // if GPR_INPUT_VALUE14 or unmapped reg addr
                     rdata14 <= input_value14;
            
               endcase
            
              end //end if read
            
            else //in not read
            
              begin // if not a valid read access, keep14 '0'-s 
              
               rdata14 <= {16 {1'b0}};
              
              end //end if not read
              
           end //end else if not reset

      end // p_read_register14


   assign pin_out14 = 
        ( output_value14 ) ;
     
   assign pin_oe_n14 = 
      ( ( ~(output_enable14 & ~(direction_mode14)) ) |
        tri_state_enable14 ) ;

                
  
endmodule // gpio_subunit14



   
   



   
