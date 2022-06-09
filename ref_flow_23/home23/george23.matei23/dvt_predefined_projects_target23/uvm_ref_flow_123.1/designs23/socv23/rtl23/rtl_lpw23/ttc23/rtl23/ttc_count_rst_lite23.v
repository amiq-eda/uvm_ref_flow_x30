//File23 name   : ttc_count_rst_lite23.v
//Title23       : 
//Created23     : 1999
//Description23 : TTC23 counter reset block
//Notes23       : 
//----------------------------------------------------------------------
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------

module ttc_count_rst_lite23(

  //inputs23
  n_p_reset23,                             
  pclk23, 
  pwdata23,                                                           
  clk_ctrl_reg_sel23,
  restart23,        

  //outputs23
  count_en_out23,
  clk_ctrl_reg_out23

  );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS23
//-----------------------------------------------------------------------------

   // inputs23
   input n_p_reset23;                 // Reset23 signal23
   input pclk23;                    // APB23 System23 clock23
   input [6:0] pwdata23;           // 7-Bit23 pwdata23 from APB23 interface
   input clk_ctrl_reg_sel23;        // Select23 for the clk_ctrl_reg23
   input restart23;                 // Restart23 reset from cntr_ctrl_reg23

   // outputs23
   output count_en_out23;
   output [6:0] clk_ctrl_reg_out23; // Controls23 clock23 selected


//-----------------------------------------------------------------------------
// Internal Signals23 & Registers23
//-----------------------------------------------------------------------------


   
   reg [6:0]    clk_ctrl_reg23;     //7-bit clock23 control23 register.
   
   reg          restart_var23;      //ensures23 prescaler23 reset at start of restart23 
   
   reg          count_en23;         //enable signal23 to counter

   
   wire [6:0]   clk_ctrl_reg_out23; //clock23 control23 output wire
   wire         count_en_out23;     //counter enable output
   
   
//-----------------------------------------------------------------------------
// Logic23 Section23:


//
//    p_clk_ctrl23: Process23 to implement the clk_ctrl_reg23.  
//                When23 select23 line is set then23 the data will be inserted23 to 
//                the clock23 control23 register, otherwise23 it will be equal23 to 
//                the previous value of the register, else it will be zero.
//-----------------------------------------------------------------------------

   assign clk_ctrl_reg_out23  = clk_ctrl_reg23;
   assign count_en_out23      = count_en23;


//    p_ps_counter23: counter for clock23 enable generation23.
   
   always @(posedge pclk23 or negedge n_p_reset23)
   begin: p_ps_counter23
      
      if (!n_p_reset23)
      begin
         restart_var23  <= 1'b0;
         count_en23     <= 1'b0;
      end
      else
      begin
         if (restart23 & ~restart_var23)
         begin
            restart_var23  <= 1'b1;
            count_en23     <= 1'b0;
         end 
         
         else 
           begin
              
              if (~restart23)
                 restart_var23 <= 1'b0;
              else
                 restart_var23 <= restart_var23;
                 
              count_en23     <= 1'b1;        
              
           end
      end // else: !if(!n_p_reset23)      
  
   end  //p_ps_counter23



// p_clk_ctrl23 : Process23 for writing to the clk_ctrl_reg23
   
   always @ (posedge pclk23 or negedge n_p_reset23)
   begin: p_clk_ctrl23
      
      if (!n_p_reset23)
         clk_ctrl_reg23 <= 7'h00;
      else
      begin 

         if (clk_ctrl_reg_sel23)
            clk_ctrl_reg23 <= pwdata23;
         else
            clk_ctrl_reg23 <= clk_ctrl_reg23;

      end 
      
   end  //p_clk_ctrl23

   
endmodule
