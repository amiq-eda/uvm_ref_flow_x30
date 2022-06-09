//File24 name   : gpio_lite_subunit24.v
//Title24       : 
//Created24     : 1999
//Description24 : Parametrised24 GPIO24 pin24 circuits24
//Notes24       : 
//----------------------------------------------------------------------
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


module gpio_lite_subunit24(
  //Inputs24

  n_reset24,
  pclk24,

  read,
  write,
  addr,

  wdata24,
  pin_in24,

  tri_state_enable24,

  //Outputs24
 
  interrupt24,

  rdata24,
  pin_oe_n24,
  pin_out24

);
 
   // Inputs24
   
   // Clocks24   
   input n_reset24;            // asynch24 reset, active low24
   input pclk24;               // Ppclk24

   // Controls24
   input read;               // select24 GPIO24 read
   input write;              // select24 GPIO24 write
   input [5:0] 
         addr;               // address bus of selected master24

   // Dataflow24
   input [15:0]
         wdata24;              // GPIO24 Input24
   input [15:0]
         pin_in24;             // input data from pin24

   //Design24 for Test24 Inputs24
   input [15:0]
         tri_state_enable24;   // disables24 op enable -> Z24




   
   // Outputs24
   
   // Controls24
   output [15:0]
          interrupt24;         // interupt24 for input pin24 change

   // Dataflow24
   output [15:0]
          rdata24;             // GPIO24 Output24
   output [15:0]
          pin_oe_n24;          // output enable signal24 to pin24
   output [15:0]
          pin_out24;           // output signal24 to pin24
   



   
   // Registers24 in module

   //Define24 Physical24 registers in amba_unit24
   reg    [15:0]
          direction_mode24;     // 1=Input24 0=Output24              RW
   reg    [15:0]
          output_enable24;      // Output24 active                 RW
   reg    [15:0]
          output_value24;       // Value outputed24 from reg       RW
   reg    [15:0]
          input_value24;        // Value input from bus          R
   reg    [15:0]
          int_status24;         // Interrupt24 status              R

   // registers to remove metastability24
   reg    [15:0]
          s_synch24;            //stage_two24
   reg    [15:0]
          s_synch_two24;        //stage_one24 - to ext pin24
   
   
    
          
   // Registers24 for outputs24
   reg    [15:0]
          rdata24;              // prdata24 reg
   wire   [15:0]
          pin_oe_n24;           // gpio24 output enable
   wire   [15:0]
          pin_out24;            // gpio24 output value
   wire   [15:0]
          interrupt24;          // gpio24 interrupt24
   wire   [15:0]
          interrupt_trigger24;  // 1 sets24 interrupt24 status
   reg    [15:0]
          status_clear24;       // 1 clears24 interrupt24 status
   wire   [15:0]
          int_event24;          // 1 detects24 an interrupt24 event

   integer ia24;                // loop variable
   


   // address decodes24
   wire   ad_direction_mode24;  // 1=Input24 0=Output24              RW
   wire   ad_output_enable24;   // Output24 active                 RW
   wire   ad_output_value24;    // Value outputed24 from reg       RW
   wire   ad_int_status24;      // Interrupt24 status              R
   
//Register addresses24
//If24 modifying24 the APB24 address (PADDR24) width change the following24 bit widths24
parameter GPR_DIRECTION_MODE24   = 6'h04;       // set pin24 to either24 I24 or O24
parameter GPR_OUTPUT_ENABLE24    = 6'h08;       // contains24 oe24 control24 value
parameter GPR_OUTPUT_VALUE24     = 6'h0C;       // output value to be driven24
parameter GPR_INPUT_VALUE24      = 6'h10;       // gpio24 input value reg
parameter GPR_INT_STATUS24       = 6'h20;       // Interrupt24 status register

//Reset24 Values24
//If24 modifying24 the GPIO24 width change the following24 bit widths24
//parameter GPRV_RSRVD24            = 32'h0000_0000; // Reserved24
parameter GPRV_DIRECTION_MODE24  = 32'h00000000; // Default to output mode
parameter GPRV_OUTPUT_ENABLE24   = 32'h00000000; // Default 3 stated24 outs24
parameter GPRV_OUTPUT_VALUE24    = 32'h00000000; // Default to be driven24
parameter GPRV_INPUT_VALUE24     = 32'h00000000; // Read defaults24 to zero
parameter GPRV_INT_STATUS24      = 32'h00000000; // Int24 status cleared24



   //assign ad_bypass_mode24    = ( addr == GPR_BYPASS_MODE24 );   
   assign ad_direction_mode24 = ( addr == GPR_DIRECTION_MODE24 );   
   assign ad_output_enable24  = ( addr == GPR_OUTPUT_ENABLE24 );   
   assign ad_output_value24   = ( addr == GPR_OUTPUT_VALUE24 );   
   assign ad_int_status24     = ( addr == GPR_INT_STATUS24 );   

   // assignments24
   
   assign interrupt24         = ( int_status24);

   assign interrupt_trigger24 = ( direction_mode24 & int_event24 ); 

   assign int_event24 = ((s_synch24 ^ input_value24) & ((s_synch24)));

   always @( ad_int_status24 or read )
   begin : p_status_clear24

     for ( ia24 = 0; ia24 < 16; ia24 = ia24 + 1 )
     begin

       status_clear24[ia24] = ( ad_int_status24 & read );

     end // for ia24

   end // p_status_clear24

   // p_write_register24 : clocked24 / asynchronous24
   //
   // this section24 contains24 all the code24 to write registers

   always @(posedge pclk24 or negedge n_reset24)
   begin : p_write_register24

      if (~n_reset24)
      
       begin
         direction_mode24  <= GPRV_DIRECTION_MODE24;
         output_enable24   <= GPRV_OUTPUT_ENABLE24;
         output_value24    <= GPRV_OUTPUT_VALUE24;
       end
      
      else 
      
       begin
      
         if (write == 1'b1) // Write value to registers
      
          begin
              
            // Write Mode24
         
            if ( ad_direction_mode24 ) 
               direction_mode24 <= wdata24;
 
            if ( ad_output_enable24 ) 
               output_enable24  <= wdata24;
     
            if ( ad_output_value24 )
               output_value24   <= wdata24;

              

           end // if write
         
       end // else: ~if(~n_reset24)
      
   end // block: p_write_register24



   // p_metastable24 : clocked24 / asynchronous24 
   //
   // This24 process  acts24 to remove  metastability24 propagation
   // Only24 for input to GPIO24
   // In Bypass24 mode pin_in24 passes24 straight24 through

   always @(posedge pclk24 or negedge n_reset24)
      
   begin : p_metastable24
      
      if (~n_reset24)
        begin
         
         s_synch24       <= {16 {1'b0}};
         s_synch_two24   <= {16 {1'b0}};
         input_value24   <= GPRV_INPUT_VALUE24;
         
        end // if (~n_reset24)
      
      else         
        begin
         
         input_value24   <= s_synch24;
         s_synch24       <= s_synch_two24;
         s_synch_two24   <= pin_in24;

        end // else: ~if(~n_reset24)
      
   end // block: p_metastable24


   // p_interrupt24 : clocked24 / asynchronous24 
   //
   // These24 lines24 set and clear the interrupt24 status

   always @(posedge pclk24 or negedge n_reset24)
   begin : p_interrupt24
      
      if (~n_reset24)
         int_status24      <= GPRV_INT_STATUS24;
      
      else 
         int_status24      <= ( int_status24 & ~(status_clear24) // read & clear
                            ) |
                            interrupt_trigger24;             // new interrupt24
        
   end // block: p_interrupt24
   
   
   // p_read_register24  : clocked24 / asynchronous24 
   //
   // this process registers the output values

   always @(posedge pclk24 or negedge n_reset24)

      begin : p_read_register24
         
         if (~n_reset24)
         
           begin

            rdata24 <= {16 {1'b0}};

           end
           
         else //if not reset
         
           begin
         
            if (read == 1'b1)
            
              begin
            
               case (addr)
            
                  
                  GPR_DIRECTION_MODE24:
                     rdata24 <= direction_mode24;
                  
                  GPR_OUTPUT_ENABLE24:
                     rdata24 <= output_enable24;
                  
                  GPR_OUTPUT_VALUE24:
                     rdata24 <= output_value24;
                  
                  GPR_INT_STATUS24:
                     rdata24 <= int_status24;
                  
                  default: // if GPR_INPUT_VALUE24 or unmapped reg addr
                     rdata24 <= input_value24;
            
               endcase
            
              end //end if read
            
            else //in not read
            
              begin // if not a valid read access, keep24 '0'-s 
              
               rdata24 <= {16 {1'b0}};
              
              end //end if not read
              
           end //end else if not reset

      end // p_read_register24


   assign pin_out24 = 
        ( output_value24 ) ;
     
   assign pin_oe_n24 = 
      ( ( ~(output_enable24 & ~(direction_mode24)) ) |
        tri_state_enable24 ) ;

                
  
endmodule // gpio_subunit24



   
   



   
