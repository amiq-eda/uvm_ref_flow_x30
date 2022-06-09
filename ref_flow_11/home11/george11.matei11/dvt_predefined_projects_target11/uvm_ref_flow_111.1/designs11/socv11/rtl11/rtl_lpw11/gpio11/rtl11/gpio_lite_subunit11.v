//File11 name   : gpio_lite_subunit11.v
//Title11       : 
//Created11     : 1999
//Description11 : Parametrised11 GPIO11 pin11 circuits11
//Notes11       : 
//----------------------------------------------------------------------
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


module gpio_lite_subunit11(
  //Inputs11

  n_reset11,
  pclk11,

  read,
  write,
  addr,

  wdata11,
  pin_in11,

  tri_state_enable11,

  //Outputs11
 
  interrupt11,

  rdata11,
  pin_oe_n11,
  pin_out11

);
 
   // Inputs11
   
   // Clocks11   
   input n_reset11;            // asynch11 reset, active low11
   input pclk11;               // Ppclk11

   // Controls11
   input read;               // select11 GPIO11 read
   input write;              // select11 GPIO11 write
   input [5:0] 
         addr;               // address bus of selected master11

   // Dataflow11
   input [15:0]
         wdata11;              // GPIO11 Input11
   input [15:0]
         pin_in11;             // input data from pin11

   //Design11 for Test11 Inputs11
   input [15:0]
         tri_state_enable11;   // disables11 op enable -> Z11




   
   // Outputs11
   
   // Controls11
   output [15:0]
          interrupt11;         // interupt11 for input pin11 change

   // Dataflow11
   output [15:0]
          rdata11;             // GPIO11 Output11
   output [15:0]
          pin_oe_n11;          // output enable signal11 to pin11
   output [15:0]
          pin_out11;           // output signal11 to pin11
   



   
   // Registers11 in module

   //Define11 Physical11 registers in amba_unit11
   reg    [15:0]
          direction_mode11;     // 1=Input11 0=Output11              RW
   reg    [15:0]
          output_enable11;      // Output11 active                 RW
   reg    [15:0]
          output_value11;       // Value outputed11 from reg       RW
   reg    [15:0]
          input_value11;        // Value input from bus          R
   reg    [15:0]
          int_status11;         // Interrupt11 status              R

   // registers to remove metastability11
   reg    [15:0]
          s_synch11;            //stage_two11
   reg    [15:0]
          s_synch_two11;        //stage_one11 - to ext pin11
   
   
    
          
   // Registers11 for outputs11
   reg    [15:0]
          rdata11;              // prdata11 reg
   wire   [15:0]
          pin_oe_n11;           // gpio11 output enable
   wire   [15:0]
          pin_out11;            // gpio11 output value
   wire   [15:0]
          interrupt11;          // gpio11 interrupt11
   wire   [15:0]
          interrupt_trigger11;  // 1 sets11 interrupt11 status
   reg    [15:0]
          status_clear11;       // 1 clears11 interrupt11 status
   wire   [15:0]
          int_event11;          // 1 detects11 an interrupt11 event

   integer ia11;                // loop variable
   


   // address decodes11
   wire   ad_direction_mode11;  // 1=Input11 0=Output11              RW
   wire   ad_output_enable11;   // Output11 active                 RW
   wire   ad_output_value11;    // Value outputed11 from reg       RW
   wire   ad_int_status11;      // Interrupt11 status              R
   
//Register addresses11
//If11 modifying11 the APB11 address (PADDR11) width change the following11 bit widths11
parameter GPR_DIRECTION_MODE11   = 6'h04;       // set pin11 to either11 I11 or O11
parameter GPR_OUTPUT_ENABLE11    = 6'h08;       // contains11 oe11 control11 value
parameter GPR_OUTPUT_VALUE11     = 6'h0C;       // output value to be driven11
parameter GPR_INPUT_VALUE11      = 6'h10;       // gpio11 input value reg
parameter GPR_INT_STATUS11       = 6'h20;       // Interrupt11 status register

//Reset11 Values11
//If11 modifying11 the GPIO11 width change the following11 bit widths11
//parameter GPRV_RSRVD11            = 32'h0000_0000; // Reserved11
parameter GPRV_DIRECTION_MODE11  = 32'h00000000; // Default to output mode
parameter GPRV_OUTPUT_ENABLE11   = 32'h00000000; // Default 3 stated11 outs11
parameter GPRV_OUTPUT_VALUE11    = 32'h00000000; // Default to be driven11
parameter GPRV_INPUT_VALUE11     = 32'h00000000; // Read defaults11 to zero
parameter GPRV_INT_STATUS11      = 32'h00000000; // Int11 status cleared11



   //assign ad_bypass_mode11    = ( addr == GPR_BYPASS_MODE11 );   
   assign ad_direction_mode11 = ( addr == GPR_DIRECTION_MODE11 );   
   assign ad_output_enable11  = ( addr == GPR_OUTPUT_ENABLE11 );   
   assign ad_output_value11   = ( addr == GPR_OUTPUT_VALUE11 );   
   assign ad_int_status11     = ( addr == GPR_INT_STATUS11 );   

   // assignments11
   
   assign interrupt11         = ( int_status11);

   assign interrupt_trigger11 = ( direction_mode11 & int_event11 ); 

   assign int_event11 = ((s_synch11 ^ input_value11) & ((s_synch11)));

   always @( ad_int_status11 or read )
   begin : p_status_clear11

     for ( ia11 = 0; ia11 < 16; ia11 = ia11 + 1 )
     begin

       status_clear11[ia11] = ( ad_int_status11 & read );

     end // for ia11

   end // p_status_clear11

   // p_write_register11 : clocked11 / asynchronous11
   //
   // this section11 contains11 all the code11 to write registers

   always @(posedge pclk11 or negedge n_reset11)
   begin : p_write_register11

      if (~n_reset11)
      
       begin
         direction_mode11  <= GPRV_DIRECTION_MODE11;
         output_enable11   <= GPRV_OUTPUT_ENABLE11;
         output_value11    <= GPRV_OUTPUT_VALUE11;
       end
      
      else 
      
       begin
      
         if (write == 1'b1) // Write value to registers
      
          begin
              
            // Write Mode11
         
            if ( ad_direction_mode11 ) 
               direction_mode11 <= wdata11;
 
            if ( ad_output_enable11 ) 
               output_enable11  <= wdata11;
     
            if ( ad_output_value11 )
               output_value11   <= wdata11;

              

           end // if write
         
       end // else: ~if(~n_reset11)
      
   end // block: p_write_register11



   // p_metastable11 : clocked11 / asynchronous11 
   //
   // This11 process  acts11 to remove  metastability11 propagation
   // Only11 for input to GPIO11
   // In Bypass11 mode pin_in11 passes11 straight11 through

   always @(posedge pclk11 or negedge n_reset11)
      
   begin : p_metastable11
      
      if (~n_reset11)
        begin
         
         s_synch11       <= {16 {1'b0}};
         s_synch_two11   <= {16 {1'b0}};
         input_value11   <= GPRV_INPUT_VALUE11;
         
        end // if (~n_reset11)
      
      else         
        begin
         
         input_value11   <= s_synch11;
         s_synch11       <= s_synch_two11;
         s_synch_two11   <= pin_in11;

        end // else: ~if(~n_reset11)
      
   end // block: p_metastable11


   // p_interrupt11 : clocked11 / asynchronous11 
   //
   // These11 lines11 set and clear the interrupt11 status

   always @(posedge pclk11 or negedge n_reset11)
   begin : p_interrupt11
      
      if (~n_reset11)
         int_status11      <= GPRV_INT_STATUS11;
      
      else 
         int_status11      <= ( int_status11 & ~(status_clear11) // read & clear
                            ) |
                            interrupt_trigger11;             // new interrupt11
        
   end // block: p_interrupt11
   
   
   // p_read_register11  : clocked11 / asynchronous11 
   //
   // this process registers the output values

   always @(posedge pclk11 or negedge n_reset11)

      begin : p_read_register11
         
         if (~n_reset11)
         
           begin

            rdata11 <= {16 {1'b0}};

           end
           
         else //if not reset
         
           begin
         
            if (read == 1'b1)
            
              begin
            
               case (addr)
            
                  
                  GPR_DIRECTION_MODE11:
                     rdata11 <= direction_mode11;
                  
                  GPR_OUTPUT_ENABLE11:
                     rdata11 <= output_enable11;
                  
                  GPR_OUTPUT_VALUE11:
                     rdata11 <= output_value11;
                  
                  GPR_INT_STATUS11:
                     rdata11 <= int_status11;
                  
                  default: // if GPR_INPUT_VALUE11 or unmapped reg addr
                     rdata11 <= input_value11;
            
               endcase
            
              end //end if read
            
            else //in not read
            
              begin // if not a valid read access, keep11 '0'-s 
              
               rdata11 <= {16 {1'b0}};
              
              end //end if not read
              
           end //end else if not reset

      end // p_read_register11


   assign pin_out11 = 
        ( output_value11 ) ;
     
   assign pin_oe_n11 = 
      ( ( ~(output_enable11 & ~(direction_mode11)) ) |
        tri_state_enable11 ) ;

                
  
endmodule // gpio_subunit11



   
   



   
