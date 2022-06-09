//File8 name   : gpio_lite_subunit8.v
//Title8       : 
//Created8     : 1999
//Description8 : Parametrised8 GPIO8 pin8 circuits8
//Notes8       : 
//----------------------------------------------------------------------
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


module gpio_lite_subunit8(
  //Inputs8

  n_reset8,
  pclk8,

  read,
  write,
  addr,

  wdata8,
  pin_in8,

  tri_state_enable8,

  //Outputs8
 
  interrupt8,

  rdata8,
  pin_oe_n8,
  pin_out8

);
 
   // Inputs8
   
   // Clocks8   
   input n_reset8;            // asynch8 reset, active low8
   input pclk8;               // Ppclk8

   // Controls8
   input read;               // select8 GPIO8 read
   input write;              // select8 GPIO8 write
   input [5:0] 
         addr;               // address bus of selected master8

   // Dataflow8
   input [15:0]
         wdata8;              // GPIO8 Input8
   input [15:0]
         pin_in8;             // input data from pin8

   //Design8 for Test8 Inputs8
   input [15:0]
         tri_state_enable8;   // disables8 op enable -> Z8




   
   // Outputs8
   
   // Controls8
   output [15:0]
          interrupt8;         // interupt8 for input pin8 change

   // Dataflow8
   output [15:0]
          rdata8;             // GPIO8 Output8
   output [15:0]
          pin_oe_n8;          // output enable signal8 to pin8
   output [15:0]
          pin_out8;           // output signal8 to pin8
   



   
   // Registers8 in module

   //Define8 Physical8 registers in amba_unit8
   reg    [15:0]
          direction_mode8;     // 1=Input8 0=Output8              RW
   reg    [15:0]
          output_enable8;      // Output8 active                 RW
   reg    [15:0]
          output_value8;       // Value outputed8 from reg       RW
   reg    [15:0]
          input_value8;        // Value input from bus          R
   reg    [15:0]
          int_status8;         // Interrupt8 status              R

   // registers to remove metastability8
   reg    [15:0]
          s_synch8;            //stage_two8
   reg    [15:0]
          s_synch_two8;        //stage_one8 - to ext pin8
   
   
    
          
   // Registers8 for outputs8
   reg    [15:0]
          rdata8;              // prdata8 reg
   wire   [15:0]
          pin_oe_n8;           // gpio8 output enable
   wire   [15:0]
          pin_out8;            // gpio8 output value
   wire   [15:0]
          interrupt8;          // gpio8 interrupt8
   wire   [15:0]
          interrupt_trigger8;  // 1 sets8 interrupt8 status
   reg    [15:0]
          status_clear8;       // 1 clears8 interrupt8 status
   wire   [15:0]
          int_event8;          // 1 detects8 an interrupt8 event

   integer ia8;                // loop variable
   


   // address decodes8
   wire   ad_direction_mode8;  // 1=Input8 0=Output8              RW
   wire   ad_output_enable8;   // Output8 active                 RW
   wire   ad_output_value8;    // Value outputed8 from reg       RW
   wire   ad_int_status8;      // Interrupt8 status              R
   
//Register addresses8
//If8 modifying8 the APB8 address (PADDR8) width change the following8 bit widths8
parameter GPR_DIRECTION_MODE8   = 6'h04;       // set pin8 to either8 I8 or O8
parameter GPR_OUTPUT_ENABLE8    = 6'h08;       // contains8 oe8 control8 value
parameter GPR_OUTPUT_VALUE8     = 6'h0C;       // output value to be driven8
parameter GPR_INPUT_VALUE8      = 6'h10;       // gpio8 input value reg
parameter GPR_INT_STATUS8       = 6'h20;       // Interrupt8 status register

//Reset8 Values8
//If8 modifying8 the GPIO8 width change the following8 bit widths8
//parameter GPRV_RSRVD8            = 32'h0000_0000; // Reserved8
parameter GPRV_DIRECTION_MODE8  = 32'h00000000; // Default to output mode
parameter GPRV_OUTPUT_ENABLE8   = 32'h00000000; // Default 3 stated8 outs8
parameter GPRV_OUTPUT_VALUE8    = 32'h00000000; // Default to be driven8
parameter GPRV_INPUT_VALUE8     = 32'h00000000; // Read defaults8 to zero
parameter GPRV_INT_STATUS8      = 32'h00000000; // Int8 status cleared8



   //assign ad_bypass_mode8    = ( addr == GPR_BYPASS_MODE8 );   
   assign ad_direction_mode8 = ( addr == GPR_DIRECTION_MODE8 );   
   assign ad_output_enable8  = ( addr == GPR_OUTPUT_ENABLE8 );   
   assign ad_output_value8   = ( addr == GPR_OUTPUT_VALUE8 );   
   assign ad_int_status8     = ( addr == GPR_INT_STATUS8 );   

   // assignments8
   
   assign interrupt8         = ( int_status8);

   assign interrupt_trigger8 = ( direction_mode8 & int_event8 ); 

   assign int_event8 = ((s_synch8 ^ input_value8) & ((s_synch8)));

   always @( ad_int_status8 or read )
   begin : p_status_clear8

     for ( ia8 = 0; ia8 < 16; ia8 = ia8 + 1 )
     begin

       status_clear8[ia8] = ( ad_int_status8 & read );

     end // for ia8

   end // p_status_clear8

   // p_write_register8 : clocked8 / asynchronous8
   //
   // this section8 contains8 all the code8 to write registers

   always @(posedge pclk8 or negedge n_reset8)
   begin : p_write_register8

      if (~n_reset8)
      
       begin
         direction_mode8  <= GPRV_DIRECTION_MODE8;
         output_enable8   <= GPRV_OUTPUT_ENABLE8;
         output_value8    <= GPRV_OUTPUT_VALUE8;
       end
      
      else 
      
       begin
      
         if (write == 1'b1) // Write value to registers
      
          begin
              
            // Write Mode8
         
            if ( ad_direction_mode8 ) 
               direction_mode8 <= wdata8;
 
            if ( ad_output_enable8 ) 
               output_enable8  <= wdata8;
     
            if ( ad_output_value8 )
               output_value8   <= wdata8;

              

           end // if write
         
       end // else: ~if(~n_reset8)
      
   end // block: p_write_register8



   // p_metastable8 : clocked8 / asynchronous8 
   //
   // This8 process  acts8 to remove  metastability8 propagation
   // Only8 for input to GPIO8
   // In Bypass8 mode pin_in8 passes8 straight8 through

   always @(posedge pclk8 or negedge n_reset8)
      
   begin : p_metastable8
      
      if (~n_reset8)
        begin
         
         s_synch8       <= {16 {1'b0}};
         s_synch_two8   <= {16 {1'b0}};
         input_value8   <= GPRV_INPUT_VALUE8;
         
        end // if (~n_reset8)
      
      else         
        begin
         
         input_value8   <= s_synch8;
         s_synch8       <= s_synch_two8;
         s_synch_two8   <= pin_in8;

        end // else: ~if(~n_reset8)
      
   end // block: p_metastable8


   // p_interrupt8 : clocked8 / asynchronous8 
   //
   // These8 lines8 set and clear the interrupt8 status

   always @(posedge pclk8 or negedge n_reset8)
   begin : p_interrupt8
      
      if (~n_reset8)
         int_status8      <= GPRV_INT_STATUS8;
      
      else 
         int_status8      <= ( int_status8 & ~(status_clear8) // read & clear
                            ) |
                            interrupt_trigger8;             // new interrupt8
        
   end // block: p_interrupt8
   
   
   // p_read_register8  : clocked8 / asynchronous8 
   //
   // this process registers the output values

   always @(posedge pclk8 or negedge n_reset8)

      begin : p_read_register8
         
         if (~n_reset8)
         
           begin

            rdata8 <= {16 {1'b0}};

           end
           
         else //if not reset
         
           begin
         
            if (read == 1'b1)
            
              begin
            
               case (addr)
            
                  
                  GPR_DIRECTION_MODE8:
                     rdata8 <= direction_mode8;
                  
                  GPR_OUTPUT_ENABLE8:
                     rdata8 <= output_enable8;
                  
                  GPR_OUTPUT_VALUE8:
                     rdata8 <= output_value8;
                  
                  GPR_INT_STATUS8:
                     rdata8 <= int_status8;
                  
                  default: // if GPR_INPUT_VALUE8 or unmapped reg addr
                     rdata8 <= input_value8;
            
               endcase
            
              end //end if read
            
            else //in not read
            
              begin // if not a valid read access, keep8 '0'-s 
              
               rdata8 <= {16 {1'b0}};
              
              end //end if not read
              
           end //end else if not reset

      end // p_read_register8


   assign pin_out8 = 
        ( output_value8 ) ;
     
   assign pin_oe_n8 = 
      ( ( ~(output_enable8 & ~(direction_mode8)) ) |
        tri_state_enable8 ) ;

                
  
endmodule // gpio_subunit8



   
   



   
