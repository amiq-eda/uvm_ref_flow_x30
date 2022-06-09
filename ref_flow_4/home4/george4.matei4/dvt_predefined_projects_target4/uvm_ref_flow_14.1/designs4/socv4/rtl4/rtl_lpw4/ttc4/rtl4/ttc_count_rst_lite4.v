//File4 name   : ttc_count_rst_lite4.v
//Title4       : 
//Created4     : 1999
//Description4 : TTC4 counter reset block
//Notes4       : 
//----------------------------------------------------------------------
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------

module ttc_count_rst_lite4(

  //inputs4
  n_p_reset4,                             
  pclk4, 
  pwdata4,                                                           
  clk_ctrl_reg_sel4,
  restart4,        

  //outputs4
  count_en_out4,
  clk_ctrl_reg_out4

  );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS4
//-----------------------------------------------------------------------------

   // inputs4
   input n_p_reset4;                 // Reset4 signal4
   input pclk4;                    // APB4 System4 clock4
   input [6:0] pwdata4;           // 7-Bit4 pwdata4 from APB4 interface
   input clk_ctrl_reg_sel4;        // Select4 for the clk_ctrl_reg4
   input restart4;                 // Restart4 reset from cntr_ctrl_reg4

   // outputs4
   output count_en_out4;
   output [6:0] clk_ctrl_reg_out4; // Controls4 clock4 selected


//-----------------------------------------------------------------------------
// Internal Signals4 & Registers4
//-----------------------------------------------------------------------------


   
   reg [6:0]    clk_ctrl_reg4;     //7-bit clock4 control4 register.
   
   reg          restart_var4;      //ensures4 prescaler4 reset at start of restart4 
   
   reg          count_en4;         //enable signal4 to counter

   
   wire [6:0]   clk_ctrl_reg_out4; //clock4 control4 output wire
   wire         count_en_out4;     //counter enable output
   
   
//-----------------------------------------------------------------------------
// Logic4 Section4:


//
//    p_clk_ctrl4: Process4 to implement the clk_ctrl_reg4.  
//                When4 select4 line is set then4 the data will be inserted4 to 
//                the clock4 control4 register, otherwise4 it will be equal4 to 
//                the previous value of the register, else it will be zero.
//-----------------------------------------------------------------------------

   assign clk_ctrl_reg_out4  = clk_ctrl_reg4;
   assign count_en_out4      = count_en4;


//    p_ps_counter4: counter for clock4 enable generation4.
   
   always @(posedge pclk4 or negedge n_p_reset4)
   begin: p_ps_counter4
      
      if (!n_p_reset4)
      begin
         restart_var4  <= 1'b0;
         count_en4     <= 1'b0;
      end
      else
      begin
         if (restart4 & ~restart_var4)
         begin
            restart_var4  <= 1'b1;
            count_en4     <= 1'b0;
         end 
         
         else 
           begin
              
              if (~restart4)
                 restart_var4 <= 1'b0;
              else
                 restart_var4 <= restart_var4;
                 
              count_en4     <= 1'b1;        
              
           end
      end // else: !if(!n_p_reset4)      
  
   end  //p_ps_counter4



// p_clk_ctrl4 : Process4 for writing to the clk_ctrl_reg4
   
   always @ (posedge pclk4 or negedge n_p_reset4)
   begin: p_clk_ctrl4
      
      if (!n_p_reset4)
         clk_ctrl_reg4 <= 7'h00;
      else
      begin 

         if (clk_ctrl_reg_sel4)
            clk_ctrl_reg4 <= pwdata4;
         else
            clk_ctrl_reg4 <= clk_ctrl_reg4;

      end 
      
   end  //p_clk_ctrl4

   
endmodule
