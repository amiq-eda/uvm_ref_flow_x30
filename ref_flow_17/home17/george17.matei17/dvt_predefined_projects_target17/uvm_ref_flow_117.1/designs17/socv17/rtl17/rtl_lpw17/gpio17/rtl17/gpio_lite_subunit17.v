//File17 name   : gpio_lite_subunit17.v
//Title17       : 
//Created17     : 1999
//Description17 : Parametrised17 GPIO17 pin17 circuits17
//Notes17       : 
//----------------------------------------------------------------------
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


module gpio_lite_subunit17(
  //Inputs17

  n_reset17,
  pclk17,

  read,
  write,
  addr,

  wdata17,
  pin_in17,

  tri_state_enable17,

  //Outputs17
 
  interrupt17,

  rdata17,
  pin_oe_n17,
  pin_out17

);
 
   // Inputs17
   
   // Clocks17   
   input n_reset17;            // asynch17 reset, active low17
   input pclk17;               // Ppclk17

   // Controls17
   input read;               // select17 GPIO17 read
   input write;              // select17 GPIO17 write
   input [5:0] 
         addr;               // address bus of selected master17

   // Dataflow17
   input [15:0]
         wdata17;              // GPIO17 Input17
   input [15:0]
         pin_in17;             // input data from pin17

   //Design17 for Test17 Inputs17
   input [15:0]
         tri_state_enable17;   // disables17 op enable -> Z17




   
   // Outputs17
   
   // Controls17
   output [15:0]
          interrupt17;         // interupt17 for input pin17 change

   // Dataflow17
   output [15:0]
          rdata17;             // GPIO17 Output17
   output [15:0]
          pin_oe_n17;          // output enable signal17 to pin17
   output [15:0]
          pin_out17;           // output signal17 to pin17
   



   
   // Registers17 in module

   //Define17 Physical17 registers in amba_unit17
   reg    [15:0]
          direction_mode17;     // 1=Input17 0=Output17              RW
   reg    [15:0]
          output_enable17;      // Output17 active                 RW
   reg    [15:0]
          output_value17;       // Value outputed17 from reg       RW
   reg    [15:0]
          input_value17;        // Value input from bus          R
   reg    [15:0]
          int_status17;         // Interrupt17 status              R

   // registers to remove metastability17
   reg    [15:0]
          s_synch17;            //stage_two17
   reg    [15:0]
          s_synch_two17;        //stage_one17 - to ext pin17
   
   
    
          
   // Registers17 for outputs17
   reg    [15:0]
          rdata17;              // prdata17 reg
   wire   [15:0]
          pin_oe_n17;           // gpio17 output enable
   wire   [15:0]
          pin_out17;            // gpio17 output value
   wire   [15:0]
          interrupt17;          // gpio17 interrupt17
   wire   [15:0]
          interrupt_trigger17;  // 1 sets17 interrupt17 status
   reg    [15:0]
          status_clear17;       // 1 clears17 interrupt17 status
   wire   [15:0]
          int_event17;          // 1 detects17 an interrupt17 event

   integer ia17;                // loop variable
   


   // address decodes17
   wire   ad_direction_mode17;  // 1=Input17 0=Output17              RW
   wire   ad_output_enable17;   // Output17 active                 RW
   wire   ad_output_value17;    // Value outputed17 from reg       RW
   wire   ad_int_status17;      // Interrupt17 status              R
   
//Register addresses17
//If17 modifying17 the APB17 address (PADDR17) width change the following17 bit widths17
parameter GPR_DIRECTION_MODE17   = 6'h04;       // set pin17 to either17 I17 or O17
parameter GPR_OUTPUT_ENABLE17    = 6'h08;       // contains17 oe17 control17 value
parameter GPR_OUTPUT_VALUE17     = 6'h0C;       // output value to be driven17
parameter GPR_INPUT_VALUE17      = 6'h10;       // gpio17 input value reg
parameter GPR_INT_STATUS17       = 6'h20;       // Interrupt17 status register

//Reset17 Values17
//If17 modifying17 the GPIO17 width change the following17 bit widths17
//parameter GPRV_RSRVD17            = 32'h0000_0000; // Reserved17
parameter GPRV_DIRECTION_MODE17  = 32'h00000000; // Default to output mode
parameter GPRV_OUTPUT_ENABLE17   = 32'h00000000; // Default 3 stated17 outs17
parameter GPRV_OUTPUT_VALUE17    = 32'h00000000; // Default to be driven17
parameter GPRV_INPUT_VALUE17     = 32'h00000000; // Read defaults17 to zero
parameter GPRV_INT_STATUS17      = 32'h00000000; // Int17 status cleared17



   //assign ad_bypass_mode17    = ( addr == GPR_BYPASS_MODE17 );   
   assign ad_direction_mode17 = ( addr == GPR_DIRECTION_MODE17 );   
   assign ad_output_enable17  = ( addr == GPR_OUTPUT_ENABLE17 );   
   assign ad_output_value17   = ( addr == GPR_OUTPUT_VALUE17 );   
   assign ad_int_status17     = ( addr == GPR_INT_STATUS17 );   

   // assignments17
   
   assign interrupt17         = ( int_status17);

   assign interrupt_trigger17 = ( direction_mode17 & int_event17 ); 

   assign int_event17 = ((s_synch17 ^ input_value17) & ((s_synch17)));

   always @( ad_int_status17 or read )
   begin : p_status_clear17

     for ( ia17 = 0; ia17 < 16; ia17 = ia17 + 1 )
     begin

       status_clear17[ia17] = ( ad_int_status17 & read );

     end // for ia17

   end // p_status_clear17

   // p_write_register17 : clocked17 / asynchronous17
   //
   // this section17 contains17 all the code17 to write registers

   always @(posedge pclk17 or negedge n_reset17)
   begin : p_write_register17

      if (~n_reset17)
      
       begin
         direction_mode17  <= GPRV_DIRECTION_MODE17;
         output_enable17   <= GPRV_OUTPUT_ENABLE17;
         output_value17    <= GPRV_OUTPUT_VALUE17;
       end
      
      else 
      
       begin
      
         if (write == 1'b1) // Write value to registers
      
          begin
              
            // Write Mode17
         
            if ( ad_direction_mode17 ) 
               direction_mode17 <= wdata17;
 
            if ( ad_output_enable17 ) 
               output_enable17  <= wdata17;
     
            if ( ad_output_value17 )
               output_value17   <= wdata17;

              

           end // if write
         
       end // else: ~if(~n_reset17)
      
   end // block: p_write_register17



   // p_metastable17 : clocked17 / asynchronous17 
   //
   // This17 process  acts17 to remove  metastability17 propagation
   // Only17 for input to GPIO17
   // In Bypass17 mode pin_in17 passes17 straight17 through

   always @(posedge pclk17 or negedge n_reset17)
      
   begin : p_metastable17
      
      if (~n_reset17)
        begin
         
         s_synch17       <= {16 {1'b0}};
         s_synch_two17   <= {16 {1'b0}};
         input_value17   <= GPRV_INPUT_VALUE17;
         
        end // if (~n_reset17)
      
      else         
        begin
         
         input_value17   <= s_synch17;
         s_synch17       <= s_synch_two17;
         s_synch_two17   <= pin_in17;

        end // else: ~if(~n_reset17)
      
   end // block: p_metastable17


   // p_interrupt17 : clocked17 / asynchronous17 
   //
   // These17 lines17 set and clear the interrupt17 status

   always @(posedge pclk17 or negedge n_reset17)
   begin : p_interrupt17
      
      if (~n_reset17)
         int_status17      <= GPRV_INT_STATUS17;
      
      else 
         int_status17      <= ( int_status17 & ~(status_clear17) // read & clear
                            ) |
                            interrupt_trigger17;             // new interrupt17
        
   end // block: p_interrupt17
   
   
   // p_read_register17  : clocked17 / asynchronous17 
   //
   // this process registers the output values

   always @(posedge pclk17 or negedge n_reset17)

      begin : p_read_register17
         
         if (~n_reset17)
         
           begin

            rdata17 <= {16 {1'b0}};

           end
           
         else //if not reset
         
           begin
         
            if (read == 1'b1)
            
              begin
            
               case (addr)
            
                  
                  GPR_DIRECTION_MODE17:
                     rdata17 <= direction_mode17;
                  
                  GPR_OUTPUT_ENABLE17:
                     rdata17 <= output_enable17;
                  
                  GPR_OUTPUT_VALUE17:
                     rdata17 <= output_value17;
                  
                  GPR_INT_STATUS17:
                     rdata17 <= int_status17;
                  
                  default: // if GPR_INPUT_VALUE17 or unmapped reg addr
                     rdata17 <= input_value17;
            
               endcase
            
              end //end if read
            
            else //in not read
            
              begin // if not a valid read access, keep17 '0'-s 
              
               rdata17 <= {16 {1'b0}};
              
              end //end if not read
              
           end //end else if not reset

      end // p_read_register17


   assign pin_out17 = 
        ( output_value17 ) ;
     
   assign pin_oe_n17 = 
      ( ( ~(output_enable17 & ~(direction_mode17)) ) |
        tri_state_enable17 ) ;

                
  
endmodule // gpio_subunit17



   
   



   
