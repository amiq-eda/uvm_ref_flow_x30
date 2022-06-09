//File20 name   : gpio_lite_subunit20.v
//Title20       : 
//Created20     : 1999
//Description20 : Parametrised20 GPIO20 pin20 circuits20
//Notes20       : 
//----------------------------------------------------------------------
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------


module gpio_lite_subunit20(
  //Inputs20

  n_reset20,
  pclk20,

  read,
  write,
  addr,

  wdata20,
  pin_in20,

  tri_state_enable20,

  //Outputs20
 
  interrupt20,

  rdata20,
  pin_oe_n20,
  pin_out20

);
 
   // Inputs20
   
   // Clocks20   
   input n_reset20;            // asynch20 reset, active low20
   input pclk20;               // Ppclk20

   // Controls20
   input read;               // select20 GPIO20 read
   input write;              // select20 GPIO20 write
   input [5:0] 
         addr;               // address bus of selected master20

   // Dataflow20
   input [15:0]
         wdata20;              // GPIO20 Input20
   input [15:0]
         pin_in20;             // input data from pin20

   //Design20 for Test20 Inputs20
   input [15:0]
         tri_state_enable20;   // disables20 op enable -> Z20




   
   // Outputs20
   
   // Controls20
   output [15:0]
          interrupt20;         // interupt20 for input pin20 change

   // Dataflow20
   output [15:0]
          rdata20;             // GPIO20 Output20
   output [15:0]
          pin_oe_n20;          // output enable signal20 to pin20
   output [15:0]
          pin_out20;           // output signal20 to pin20
   



   
   // Registers20 in module

   //Define20 Physical20 registers in amba_unit20
   reg    [15:0]
          direction_mode20;     // 1=Input20 0=Output20              RW
   reg    [15:0]
          output_enable20;      // Output20 active                 RW
   reg    [15:0]
          output_value20;       // Value outputed20 from reg       RW
   reg    [15:0]
          input_value20;        // Value input from bus          R
   reg    [15:0]
          int_status20;         // Interrupt20 status              R

   // registers to remove metastability20
   reg    [15:0]
          s_synch20;            //stage_two20
   reg    [15:0]
          s_synch_two20;        //stage_one20 - to ext pin20
   
   
    
          
   // Registers20 for outputs20
   reg    [15:0]
          rdata20;              // prdata20 reg
   wire   [15:0]
          pin_oe_n20;           // gpio20 output enable
   wire   [15:0]
          pin_out20;            // gpio20 output value
   wire   [15:0]
          interrupt20;          // gpio20 interrupt20
   wire   [15:0]
          interrupt_trigger20;  // 1 sets20 interrupt20 status
   reg    [15:0]
          status_clear20;       // 1 clears20 interrupt20 status
   wire   [15:0]
          int_event20;          // 1 detects20 an interrupt20 event

   integer ia20;                // loop variable
   


   // address decodes20
   wire   ad_direction_mode20;  // 1=Input20 0=Output20              RW
   wire   ad_output_enable20;   // Output20 active                 RW
   wire   ad_output_value20;    // Value outputed20 from reg       RW
   wire   ad_int_status20;      // Interrupt20 status              R
   
//Register addresses20
//If20 modifying20 the APB20 address (PADDR20) width change the following20 bit widths20
parameter GPR_DIRECTION_MODE20   = 6'h04;       // set pin20 to either20 I20 or O20
parameter GPR_OUTPUT_ENABLE20    = 6'h08;       // contains20 oe20 control20 value
parameter GPR_OUTPUT_VALUE20     = 6'h0C;       // output value to be driven20
parameter GPR_INPUT_VALUE20      = 6'h10;       // gpio20 input value reg
parameter GPR_INT_STATUS20       = 6'h20;       // Interrupt20 status register

//Reset20 Values20
//If20 modifying20 the GPIO20 width change the following20 bit widths20
//parameter GPRV_RSRVD20            = 32'h0000_0000; // Reserved20
parameter GPRV_DIRECTION_MODE20  = 32'h00000000; // Default to output mode
parameter GPRV_OUTPUT_ENABLE20   = 32'h00000000; // Default 3 stated20 outs20
parameter GPRV_OUTPUT_VALUE20    = 32'h00000000; // Default to be driven20
parameter GPRV_INPUT_VALUE20     = 32'h00000000; // Read defaults20 to zero
parameter GPRV_INT_STATUS20      = 32'h00000000; // Int20 status cleared20



   //assign ad_bypass_mode20    = ( addr == GPR_BYPASS_MODE20 );   
   assign ad_direction_mode20 = ( addr == GPR_DIRECTION_MODE20 );   
   assign ad_output_enable20  = ( addr == GPR_OUTPUT_ENABLE20 );   
   assign ad_output_value20   = ( addr == GPR_OUTPUT_VALUE20 );   
   assign ad_int_status20     = ( addr == GPR_INT_STATUS20 );   

   // assignments20
   
   assign interrupt20         = ( int_status20);

   assign interrupt_trigger20 = ( direction_mode20 & int_event20 ); 

   assign int_event20 = ((s_synch20 ^ input_value20) & ((s_synch20)));

   always @( ad_int_status20 or read )
   begin : p_status_clear20

     for ( ia20 = 0; ia20 < 16; ia20 = ia20 + 1 )
     begin

       status_clear20[ia20] = ( ad_int_status20 & read );

     end // for ia20

   end // p_status_clear20

   // p_write_register20 : clocked20 / asynchronous20
   //
   // this section20 contains20 all the code20 to write registers

   always @(posedge pclk20 or negedge n_reset20)
   begin : p_write_register20

      if (~n_reset20)
      
       begin
         direction_mode20  <= GPRV_DIRECTION_MODE20;
         output_enable20   <= GPRV_OUTPUT_ENABLE20;
         output_value20    <= GPRV_OUTPUT_VALUE20;
       end
      
      else 
      
       begin
      
         if (write == 1'b1) // Write value to registers
      
          begin
              
            // Write Mode20
         
            if ( ad_direction_mode20 ) 
               direction_mode20 <= wdata20;
 
            if ( ad_output_enable20 ) 
               output_enable20  <= wdata20;
     
            if ( ad_output_value20 )
               output_value20   <= wdata20;

              

           end // if write
         
       end // else: ~if(~n_reset20)
      
   end // block: p_write_register20



   // p_metastable20 : clocked20 / asynchronous20 
   //
   // This20 process  acts20 to remove  metastability20 propagation
   // Only20 for input to GPIO20
   // In Bypass20 mode pin_in20 passes20 straight20 through

   always @(posedge pclk20 or negedge n_reset20)
      
   begin : p_metastable20
      
      if (~n_reset20)
        begin
         
         s_synch20       <= {16 {1'b0}};
         s_synch_two20   <= {16 {1'b0}};
         input_value20   <= GPRV_INPUT_VALUE20;
         
        end // if (~n_reset20)
      
      else         
        begin
         
         input_value20   <= s_synch20;
         s_synch20       <= s_synch_two20;
         s_synch_two20   <= pin_in20;

        end // else: ~if(~n_reset20)
      
   end // block: p_metastable20


   // p_interrupt20 : clocked20 / asynchronous20 
   //
   // These20 lines20 set and clear the interrupt20 status

   always @(posedge pclk20 or negedge n_reset20)
   begin : p_interrupt20
      
      if (~n_reset20)
         int_status20      <= GPRV_INT_STATUS20;
      
      else 
         int_status20      <= ( int_status20 & ~(status_clear20) // read & clear
                            ) |
                            interrupt_trigger20;             // new interrupt20
        
   end // block: p_interrupt20
   
   
   // p_read_register20  : clocked20 / asynchronous20 
   //
   // this process registers the output values

   always @(posedge pclk20 or negedge n_reset20)

      begin : p_read_register20
         
         if (~n_reset20)
         
           begin

            rdata20 <= {16 {1'b0}};

           end
           
         else //if not reset
         
           begin
         
            if (read == 1'b1)
            
              begin
            
               case (addr)
            
                  
                  GPR_DIRECTION_MODE20:
                     rdata20 <= direction_mode20;
                  
                  GPR_OUTPUT_ENABLE20:
                     rdata20 <= output_enable20;
                  
                  GPR_OUTPUT_VALUE20:
                     rdata20 <= output_value20;
                  
                  GPR_INT_STATUS20:
                     rdata20 <= int_status20;
                  
                  default: // if GPR_INPUT_VALUE20 or unmapped reg addr
                     rdata20 <= input_value20;
            
               endcase
            
              end //end if read
            
            else //in not read
            
              begin // if not a valid read access, keep20 '0'-s 
              
               rdata20 <= {16 {1'b0}};
              
              end //end if not read
              
           end //end else if not reset

      end // p_read_register20


   assign pin_out20 = 
        ( output_value20 ) ;
     
   assign pin_oe_n20 = 
      ( ( ~(output_enable20 & ~(direction_mode20)) ) |
        tri_state_enable20 ) ;

                
  
endmodule // gpio_subunit20



   
   



   
