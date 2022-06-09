//File13 name   : gpio_lite_subunit13.v
//Title13       : 
//Created13     : 1999
//Description13 : Parametrised13 GPIO13 pin13 circuits13
//Notes13       : 
//----------------------------------------------------------------------
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


module gpio_lite_subunit13(
  //Inputs13

  n_reset13,
  pclk13,

  read,
  write,
  addr,

  wdata13,
  pin_in13,

  tri_state_enable13,

  //Outputs13
 
  interrupt13,

  rdata13,
  pin_oe_n13,
  pin_out13

);
 
   // Inputs13
   
   // Clocks13   
   input n_reset13;            // asynch13 reset, active low13
   input pclk13;               // Ppclk13

   // Controls13
   input read;               // select13 GPIO13 read
   input write;              // select13 GPIO13 write
   input [5:0] 
         addr;               // address bus of selected master13

   // Dataflow13
   input [15:0]
         wdata13;              // GPIO13 Input13
   input [15:0]
         pin_in13;             // input data from pin13

   //Design13 for Test13 Inputs13
   input [15:0]
         tri_state_enable13;   // disables13 op enable -> Z13




   
   // Outputs13
   
   // Controls13
   output [15:0]
          interrupt13;         // interupt13 for input pin13 change

   // Dataflow13
   output [15:0]
          rdata13;             // GPIO13 Output13
   output [15:0]
          pin_oe_n13;          // output enable signal13 to pin13
   output [15:0]
          pin_out13;           // output signal13 to pin13
   



   
   // Registers13 in module

   //Define13 Physical13 registers in amba_unit13
   reg    [15:0]
          direction_mode13;     // 1=Input13 0=Output13              RW
   reg    [15:0]
          output_enable13;      // Output13 active                 RW
   reg    [15:0]
          output_value13;       // Value outputed13 from reg       RW
   reg    [15:0]
          input_value13;        // Value input from bus          R
   reg    [15:0]
          int_status13;         // Interrupt13 status              R

   // registers to remove metastability13
   reg    [15:0]
          s_synch13;            //stage_two13
   reg    [15:0]
          s_synch_two13;        //stage_one13 - to ext pin13
   
   
    
          
   // Registers13 for outputs13
   reg    [15:0]
          rdata13;              // prdata13 reg
   wire   [15:0]
          pin_oe_n13;           // gpio13 output enable
   wire   [15:0]
          pin_out13;            // gpio13 output value
   wire   [15:0]
          interrupt13;          // gpio13 interrupt13
   wire   [15:0]
          interrupt_trigger13;  // 1 sets13 interrupt13 status
   reg    [15:0]
          status_clear13;       // 1 clears13 interrupt13 status
   wire   [15:0]
          int_event13;          // 1 detects13 an interrupt13 event

   integer ia13;                // loop variable
   


   // address decodes13
   wire   ad_direction_mode13;  // 1=Input13 0=Output13              RW
   wire   ad_output_enable13;   // Output13 active                 RW
   wire   ad_output_value13;    // Value outputed13 from reg       RW
   wire   ad_int_status13;      // Interrupt13 status              R
   
//Register addresses13
//If13 modifying13 the APB13 address (PADDR13) width change the following13 bit widths13
parameter GPR_DIRECTION_MODE13   = 6'h04;       // set pin13 to either13 I13 or O13
parameter GPR_OUTPUT_ENABLE13    = 6'h08;       // contains13 oe13 control13 value
parameter GPR_OUTPUT_VALUE13     = 6'h0C;       // output value to be driven13
parameter GPR_INPUT_VALUE13      = 6'h10;       // gpio13 input value reg
parameter GPR_INT_STATUS13       = 6'h20;       // Interrupt13 status register

//Reset13 Values13
//If13 modifying13 the GPIO13 width change the following13 bit widths13
//parameter GPRV_RSRVD13            = 32'h0000_0000; // Reserved13
parameter GPRV_DIRECTION_MODE13  = 32'h00000000; // Default to output mode
parameter GPRV_OUTPUT_ENABLE13   = 32'h00000000; // Default 3 stated13 outs13
parameter GPRV_OUTPUT_VALUE13    = 32'h00000000; // Default to be driven13
parameter GPRV_INPUT_VALUE13     = 32'h00000000; // Read defaults13 to zero
parameter GPRV_INT_STATUS13      = 32'h00000000; // Int13 status cleared13



   //assign ad_bypass_mode13    = ( addr == GPR_BYPASS_MODE13 );   
   assign ad_direction_mode13 = ( addr == GPR_DIRECTION_MODE13 );   
   assign ad_output_enable13  = ( addr == GPR_OUTPUT_ENABLE13 );   
   assign ad_output_value13   = ( addr == GPR_OUTPUT_VALUE13 );   
   assign ad_int_status13     = ( addr == GPR_INT_STATUS13 );   

   // assignments13
   
   assign interrupt13         = ( int_status13);

   assign interrupt_trigger13 = ( direction_mode13 & int_event13 ); 

   assign int_event13 = ((s_synch13 ^ input_value13) & ((s_synch13)));

   always @( ad_int_status13 or read )
   begin : p_status_clear13

     for ( ia13 = 0; ia13 < 16; ia13 = ia13 + 1 )
     begin

       status_clear13[ia13] = ( ad_int_status13 & read );

     end // for ia13

   end // p_status_clear13

   // p_write_register13 : clocked13 / asynchronous13
   //
   // this section13 contains13 all the code13 to write registers

   always @(posedge pclk13 or negedge n_reset13)
   begin : p_write_register13

      if (~n_reset13)
      
       begin
         direction_mode13  <= GPRV_DIRECTION_MODE13;
         output_enable13   <= GPRV_OUTPUT_ENABLE13;
         output_value13    <= GPRV_OUTPUT_VALUE13;
       end
      
      else 
      
       begin
      
         if (write == 1'b1) // Write value to registers
      
          begin
              
            // Write Mode13
         
            if ( ad_direction_mode13 ) 
               direction_mode13 <= wdata13;
 
            if ( ad_output_enable13 ) 
               output_enable13  <= wdata13;
     
            if ( ad_output_value13 )
               output_value13   <= wdata13;

              

           end // if write
         
       end // else: ~if(~n_reset13)
      
   end // block: p_write_register13



   // p_metastable13 : clocked13 / asynchronous13 
   //
   // This13 process  acts13 to remove  metastability13 propagation
   // Only13 for input to GPIO13
   // In Bypass13 mode pin_in13 passes13 straight13 through

   always @(posedge pclk13 or negedge n_reset13)
      
   begin : p_metastable13
      
      if (~n_reset13)
        begin
         
         s_synch13       <= {16 {1'b0}};
         s_synch_two13   <= {16 {1'b0}};
         input_value13   <= GPRV_INPUT_VALUE13;
         
        end // if (~n_reset13)
      
      else         
        begin
         
         input_value13   <= s_synch13;
         s_synch13       <= s_synch_two13;
         s_synch_two13   <= pin_in13;

        end // else: ~if(~n_reset13)
      
   end // block: p_metastable13


   // p_interrupt13 : clocked13 / asynchronous13 
   //
   // These13 lines13 set and clear the interrupt13 status

   always @(posedge pclk13 or negedge n_reset13)
   begin : p_interrupt13
      
      if (~n_reset13)
         int_status13      <= GPRV_INT_STATUS13;
      
      else 
         int_status13      <= ( int_status13 & ~(status_clear13) // read & clear
                            ) |
                            interrupt_trigger13;             // new interrupt13
        
   end // block: p_interrupt13
   
   
   // p_read_register13  : clocked13 / asynchronous13 
   //
   // this process registers the output values

   always @(posedge pclk13 or negedge n_reset13)

      begin : p_read_register13
         
         if (~n_reset13)
         
           begin

            rdata13 <= {16 {1'b0}};

           end
           
         else //if not reset
         
           begin
         
            if (read == 1'b1)
            
              begin
            
               case (addr)
            
                  
                  GPR_DIRECTION_MODE13:
                     rdata13 <= direction_mode13;
                  
                  GPR_OUTPUT_ENABLE13:
                     rdata13 <= output_enable13;
                  
                  GPR_OUTPUT_VALUE13:
                     rdata13 <= output_value13;
                  
                  GPR_INT_STATUS13:
                     rdata13 <= int_status13;
                  
                  default: // if GPR_INPUT_VALUE13 or unmapped reg addr
                     rdata13 <= input_value13;
            
               endcase
            
              end //end if read
            
            else //in not read
            
              begin // if not a valid read access, keep13 '0'-s 
              
               rdata13 <= {16 {1'b0}};
              
              end //end if not read
              
           end //end else if not reset

      end // p_read_register13


   assign pin_out13 = 
        ( output_value13 ) ;
     
   assign pin_oe_n13 = 
      ( ( ~(output_enable13 & ~(direction_mode13)) ) |
        tri_state_enable13 ) ;

                
  
endmodule // gpio_subunit13



   
   



   
