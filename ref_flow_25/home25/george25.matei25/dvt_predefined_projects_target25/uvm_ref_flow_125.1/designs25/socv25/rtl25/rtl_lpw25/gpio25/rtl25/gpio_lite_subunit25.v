//File25 name   : gpio_lite_subunit25.v
//Title25       : 
//Created25     : 1999
//Description25 : Parametrised25 GPIO25 pin25 circuits25
//Notes25       : 
//----------------------------------------------------------------------
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------


module gpio_lite_subunit25(
  //Inputs25

  n_reset25,
  pclk25,

  read,
  write,
  addr,

  wdata25,
  pin_in25,

  tri_state_enable25,

  //Outputs25
 
  interrupt25,

  rdata25,
  pin_oe_n25,
  pin_out25

);
 
   // Inputs25
   
   // Clocks25   
   input n_reset25;            // asynch25 reset, active low25
   input pclk25;               // Ppclk25

   // Controls25
   input read;               // select25 GPIO25 read
   input write;              // select25 GPIO25 write
   input [5:0] 
         addr;               // address bus of selected master25

   // Dataflow25
   input [15:0]
         wdata25;              // GPIO25 Input25
   input [15:0]
         pin_in25;             // input data from pin25

   //Design25 for Test25 Inputs25
   input [15:0]
         tri_state_enable25;   // disables25 op enable -> Z25




   
   // Outputs25
   
   // Controls25
   output [15:0]
          interrupt25;         // interupt25 for input pin25 change

   // Dataflow25
   output [15:0]
          rdata25;             // GPIO25 Output25
   output [15:0]
          pin_oe_n25;          // output enable signal25 to pin25
   output [15:0]
          pin_out25;           // output signal25 to pin25
   



   
   // Registers25 in module

   //Define25 Physical25 registers in amba_unit25
   reg    [15:0]
          direction_mode25;     // 1=Input25 0=Output25              RW
   reg    [15:0]
          output_enable25;      // Output25 active                 RW
   reg    [15:0]
          output_value25;       // Value outputed25 from reg       RW
   reg    [15:0]
          input_value25;        // Value input from bus          R
   reg    [15:0]
          int_status25;         // Interrupt25 status              R

   // registers to remove metastability25
   reg    [15:0]
          s_synch25;            //stage_two25
   reg    [15:0]
          s_synch_two25;        //stage_one25 - to ext pin25
   
   
    
          
   // Registers25 for outputs25
   reg    [15:0]
          rdata25;              // prdata25 reg
   wire   [15:0]
          pin_oe_n25;           // gpio25 output enable
   wire   [15:0]
          pin_out25;            // gpio25 output value
   wire   [15:0]
          interrupt25;          // gpio25 interrupt25
   wire   [15:0]
          interrupt_trigger25;  // 1 sets25 interrupt25 status
   reg    [15:0]
          status_clear25;       // 1 clears25 interrupt25 status
   wire   [15:0]
          int_event25;          // 1 detects25 an interrupt25 event

   integer ia25;                // loop variable
   


   // address decodes25
   wire   ad_direction_mode25;  // 1=Input25 0=Output25              RW
   wire   ad_output_enable25;   // Output25 active                 RW
   wire   ad_output_value25;    // Value outputed25 from reg       RW
   wire   ad_int_status25;      // Interrupt25 status              R
   
//Register addresses25
//If25 modifying25 the APB25 address (PADDR25) width change the following25 bit widths25
parameter GPR_DIRECTION_MODE25   = 6'h04;       // set pin25 to either25 I25 or O25
parameter GPR_OUTPUT_ENABLE25    = 6'h08;       // contains25 oe25 control25 value
parameter GPR_OUTPUT_VALUE25     = 6'h0C;       // output value to be driven25
parameter GPR_INPUT_VALUE25      = 6'h10;       // gpio25 input value reg
parameter GPR_INT_STATUS25       = 6'h20;       // Interrupt25 status register

//Reset25 Values25
//If25 modifying25 the GPIO25 width change the following25 bit widths25
//parameter GPRV_RSRVD25            = 32'h0000_0000; // Reserved25
parameter GPRV_DIRECTION_MODE25  = 32'h00000000; // Default to output mode
parameter GPRV_OUTPUT_ENABLE25   = 32'h00000000; // Default 3 stated25 outs25
parameter GPRV_OUTPUT_VALUE25    = 32'h00000000; // Default to be driven25
parameter GPRV_INPUT_VALUE25     = 32'h00000000; // Read defaults25 to zero
parameter GPRV_INT_STATUS25      = 32'h00000000; // Int25 status cleared25



   //assign ad_bypass_mode25    = ( addr == GPR_BYPASS_MODE25 );   
   assign ad_direction_mode25 = ( addr == GPR_DIRECTION_MODE25 );   
   assign ad_output_enable25  = ( addr == GPR_OUTPUT_ENABLE25 );   
   assign ad_output_value25   = ( addr == GPR_OUTPUT_VALUE25 );   
   assign ad_int_status25     = ( addr == GPR_INT_STATUS25 );   

   // assignments25
   
   assign interrupt25         = ( int_status25);

   assign interrupt_trigger25 = ( direction_mode25 & int_event25 ); 

   assign int_event25 = ((s_synch25 ^ input_value25) & ((s_synch25)));

   always @( ad_int_status25 or read )
   begin : p_status_clear25

     for ( ia25 = 0; ia25 < 16; ia25 = ia25 + 1 )
     begin

       status_clear25[ia25] = ( ad_int_status25 & read );

     end // for ia25

   end // p_status_clear25

   // p_write_register25 : clocked25 / asynchronous25
   //
   // this section25 contains25 all the code25 to write registers

   always @(posedge pclk25 or negedge n_reset25)
   begin : p_write_register25

      if (~n_reset25)
      
       begin
         direction_mode25  <= GPRV_DIRECTION_MODE25;
         output_enable25   <= GPRV_OUTPUT_ENABLE25;
         output_value25    <= GPRV_OUTPUT_VALUE25;
       end
      
      else 
      
       begin
      
         if (write == 1'b1) // Write value to registers
      
          begin
              
            // Write Mode25
         
            if ( ad_direction_mode25 ) 
               direction_mode25 <= wdata25;
 
            if ( ad_output_enable25 ) 
               output_enable25  <= wdata25;
     
            if ( ad_output_value25 )
               output_value25   <= wdata25;

              

           end // if write
         
       end // else: ~if(~n_reset25)
      
   end // block: p_write_register25



   // p_metastable25 : clocked25 / asynchronous25 
   //
   // This25 process  acts25 to remove  metastability25 propagation
   // Only25 for input to GPIO25
   // In Bypass25 mode pin_in25 passes25 straight25 through

   always @(posedge pclk25 or negedge n_reset25)
      
   begin : p_metastable25
      
      if (~n_reset25)
        begin
         
         s_synch25       <= {16 {1'b0}};
         s_synch_two25   <= {16 {1'b0}};
         input_value25   <= GPRV_INPUT_VALUE25;
         
        end // if (~n_reset25)
      
      else         
        begin
         
         input_value25   <= s_synch25;
         s_synch25       <= s_synch_two25;
         s_synch_two25   <= pin_in25;

        end // else: ~if(~n_reset25)
      
   end // block: p_metastable25


   // p_interrupt25 : clocked25 / asynchronous25 
   //
   // These25 lines25 set and clear the interrupt25 status

   always @(posedge pclk25 or negedge n_reset25)
   begin : p_interrupt25
      
      if (~n_reset25)
         int_status25      <= GPRV_INT_STATUS25;
      
      else 
         int_status25      <= ( int_status25 & ~(status_clear25) // read & clear
                            ) |
                            interrupt_trigger25;             // new interrupt25
        
   end // block: p_interrupt25
   
   
   // p_read_register25  : clocked25 / asynchronous25 
   //
   // this process registers the output values

   always @(posedge pclk25 or negedge n_reset25)

      begin : p_read_register25
         
         if (~n_reset25)
         
           begin

            rdata25 <= {16 {1'b0}};

           end
           
         else //if not reset
         
           begin
         
            if (read == 1'b1)
            
              begin
            
               case (addr)
            
                  
                  GPR_DIRECTION_MODE25:
                     rdata25 <= direction_mode25;
                  
                  GPR_OUTPUT_ENABLE25:
                     rdata25 <= output_enable25;
                  
                  GPR_OUTPUT_VALUE25:
                     rdata25 <= output_value25;
                  
                  GPR_INT_STATUS25:
                     rdata25 <= int_status25;
                  
                  default: // if GPR_INPUT_VALUE25 or unmapped reg addr
                     rdata25 <= input_value25;
            
               endcase
            
              end //end if read
            
            else //in not read
            
              begin // if not a valid read access, keep25 '0'-s 
              
               rdata25 <= {16 {1'b0}};
              
              end //end if not read
              
           end //end else if not reset

      end // p_read_register25


   assign pin_out25 = 
        ( output_value25 ) ;
     
   assign pin_oe_n25 = 
      ( ( ~(output_enable25 & ~(direction_mode25)) ) |
        tri_state_enable25 ) ;

                
  
endmodule // gpio_subunit25



   
   



   
