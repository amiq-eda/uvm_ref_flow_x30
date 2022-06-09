//File29 name   : gpio_lite_subunit29.v
//Title29       : 
//Created29     : 1999
//Description29 : Parametrised29 GPIO29 pin29 circuits29
//Notes29       : 
//----------------------------------------------------------------------
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


module gpio_lite_subunit29(
  //Inputs29

  n_reset29,
  pclk29,

  read,
  write,
  addr,

  wdata29,
  pin_in29,

  tri_state_enable29,

  //Outputs29
 
  interrupt29,

  rdata29,
  pin_oe_n29,
  pin_out29

);
 
   // Inputs29
   
   // Clocks29   
   input n_reset29;            // asynch29 reset, active low29
   input pclk29;               // Ppclk29

   // Controls29
   input read;               // select29 GPIO29 read
   input write;              // select29 GPIO29 write
   input [5:0] 
         addr;               // address bus of selected master29

   // Dataflow29
   input [15:0]
         wdata29;              // GPIO29 Input29
   input [15:0]
         pin_in29;             // input data from pin29

   //Design29 for Test29 Inputs29
   input [15:0]
         tri_state_enable29;   // disables29 op enable -> Z29




   
   // Outputs29
   
   // Controls29
   output [15:0]
          interrupt29;         // interupt29 for input pin29 change

   // Dataflow29
   output [15:0]
          rdata29;             // GPIO29 Output29
   output [15:0]
          pin_oe_n29;          // output enable signal29 to pin29
   output [15:0]
          pin_out29;           // output signal29 to pin29
   



   
   // Registers29 in module

   //Define29 Physical29 registers in amba_unit29
   reg    [15:0]
          direction_mode29;     // 1=Input29 0=Output29              RW
   reg    [15:0]
          output_enable29;      // Output29 active                 RW
   reg    [15:0]
          output_value29;       // Value outputed29 from reg       RW
   reg    [15:0]
          input_value29;        // Value input from bus          R
   reg    [15:0]
          int_status29;         // Interrupt29 status              R

   // registers to remove metastability29
   reg    [15:0]
          s_synch29;            //stage_two29
   reg    [15:0]
          s_synch_two29;        //stage_one29 - to ext pin29
   
   
    
          
   // Registers29 for outputs29
   reg    [15:0]
          rdata29;              // prdata29 reg
   wire   [15:0]
          pin_oe_n29;           // gpio29 output enable
   wire   [15:0]
          pin_out29;            // gpio29 output value
   wire   [15:0]
          interrupt29;          // gpio29 interrupt29
   wire   [15:0]
          interrupt_trigger29;  // 1 sets29 interrupt29 status
   reg    [15:0]
          status_clear29;       // 1 clears29 interrupt29 status
   wire   [15:0]
          int_event29;          // 1 detects29 an interrupt29 event

   integer ia29;                // loop variable
   


   // address decodes29
   wire   ad_direction_mode29;  // 1=Input29 0=Output29              RW
   wire   ad_output_enable29;   // Output29 active                 RW
   wire   ad_output_value29;    // Value outputed29 from reg       RW
   wire   ad_int_status29;      // Interrupt29 status              R
   
//Register addresses29
//If29 modifying29 the APB29 address (PADDR29) width change the following29 bit widths29
parameter GPR_DIRECTION_MODE29   = 6'h04;       // set pin29 to either29 I29 or O29
parameter GPR_OUTPUT_ENABLE29    = 6'h08;       // contains29 oe29 control29 value
parameter GPR_OUTPUT_VALUE29     = 6'h0C;       // output value to be driven29
parameter GPR_INPUT_VALUE29      = 6'h10;       // gpio29 input value reg
parameter GPR_INT_STATUS29       = 6'h20;       // Interrupt29 status register

//Reset29 Values29
//If29 modifying29 the GPIO29 width change the following29 bit widths29
//parameter GPRV_RSRVD29            = 32'h0000_0000; // Reserved29
parameter GPRV_DIRECTION_MODE29  = 32'h00000000; // Default to output mode
parameter GPRV_OUTPUT_ENABLE29   = 32'h00000000; // Default 3 stated29 outs29
parameter GPRV_OUTPUT_VALUE29    = 32'h00000000; // Default to be driven29
parameter GPRV_INPUT_VALUE29     = 32'h00000000; // Read defaults29 to zero
parameter GPRV_INT_STATUS29      = 32'h00000000; // Int29 status cleared29



   //assign ad_bypass_mode29    = ( addr == GPR_BYPASS_MODE29 );   
   assign ad_direction_mode29 = ( addr == GPR_DIRECTION_MODE29 );   
   assign ad_output_enable29  = ( addr == GPR_OUTPUT_ENABLE29 );   
   assign ad_output_value29   = ( addr == GPR_OUTPUT_VALUE29 );   
   assign ad_int_status29     = ( addr == GPR_INT_STATUS29 );   

   // assignments29
   
   assign interrupt29         = ( int_status29);

   assign interrupt_trigger29 = ( direction_mode29 & int_event29 ); 

   assign int_event29 = ((s_synch29 ^ input_value29) & ((s_synch29)));

   always @( ad_int_status29 or read )
   begin : p_status_clear29

     for ( ia29 = 0; ia29 < 16; ia29 = ia29 + 1 )
     begin

       status_clear29[ia29] = ( ad_int_status29 & read );

     end // for ia29

   end // p_status_clear29

   // p_write_register29 : clocked29 / asynchronous29
   //
   // this section29 contains29 all the code29 to write registers

   always @(posedge pclk29 or negedge n_reset29)
   begin : p_write_register29

      if (~n_reset29)
      
       begin
         direction_mode29  <= GPRV_DIRECTION_MODE29;
         output_enable29   <= GPRV_OUTPUT_ENABLE29;
         output_value29    <= GPRV_OUTPUT_VALUE29;
       end
      
      else 
      
       begin
      
         if (write == 1'b1) // Write value to registers
      
          begin
              
            // Write Mode29
         
            if ( ad_direction_mode29 ) 
               direction_mode29 <= wdata29;
 
            if ( ad_output_enable29 ) 
               output_enable29  <= wdata29;
     
            if ( ad_output_value29 )
               output_value29   <= wdata29;

              

           end // if write
         
       end // else: ~if(~n_reset29)
      
   end // block: p_write_register29



   // p_metastable29 : clocked29 / asynchronous29 
   //
   // This29 process  acts29 to remove  metastability29 propagation
   // Only29 for input to GPIO29
   // In Bypass29 mode pin_in29 passes29 straight29 through

   always @(posedge pclk29 or negedge n_reset29)
      
   begin : p_metastable29
      
      if (~n_reset29)
        begin
         
         s_synch29       <= {16 {1'b0}};
         s_synch_two29   <= {16 {1'b0}};
         input_value29   <= GPRV_INPUT_VALUE29;
         
        end // if (~n_reset29)
      
      else         
        begin
         
         input_value29   <= s_synch29;
         s_synch29       <= s_synch_two29;
         s_synch_two29   <= pin_in29;

        end // else: ~if(~n_reset29)
      
   end // block: p_metastable29


   // p_interrupt29 : clocked29 / asynchronous29 
   //
   // These29 lines29 set and clear the interrupt29 status

   always @(posedge pclk29 or negedge n_reset29)
   begin : p_interrupt29
      
      if (~n_reset29)
         int_status29      <= GPRV_INT_STATUS29;
      
      else 
         int_status29      <= ( int_status29 & ~(status_clear29) // read & clear
                            ) |
                            interrupt_trigger29;             // new interrupt29
        
   end // block: p_interrupt29
   
   
   // p_read_register29  : clocked29 / asynchronous29 
   //
   // this process registers the output values

   always @(posedge pclk29 or negedge n_reset29)

      begin : p_read_register29
         
         if (~n_reset29)
         
           begin

            rdata29 <= {16 {1'b0}};

           end
           
         else //if not reset
         
           begin
         
            if (read == 1'b1)
            
              begin
            
               case (addr)
            
                  
                  GPR_DIRECTION_MODE29:
                     rdata29 <= direction_mode29;
                  
                  GPR_OUTPUT_ENABLE29:
                     rdata29 <= output_enable29;
                  
                  GPR_OUTPUT_VALUE29:
                     rdata29 <= output_value29;
                  
                  GPR_INT_STATUS29:
                     rdata29 <= int_status29;
                  
                  default: // if GPR_INPUT_VALUE29 or unmapped reg addr
                     rdata29 <= input_value29;
            
               endcase
            
              end //end if read
            
            else //in not read
            
              begin // if not a valid read access, keep29 '0'-s 
              
               rdata29 <= {16 {1'b0}};
              
              end //end if not read
              
           end //end else if not reset

      end // p_read_register29


   assign pin_out29 = 
        ( output_value29 ) ;
     
   assign pin_oe_n29 = 
      ( ( ~(output_enable29 & ~(direction_mode29)) ) |
        tri_state_enable29 ) ;

                
  
endmodule // gpio_subunit29



   
   



   
