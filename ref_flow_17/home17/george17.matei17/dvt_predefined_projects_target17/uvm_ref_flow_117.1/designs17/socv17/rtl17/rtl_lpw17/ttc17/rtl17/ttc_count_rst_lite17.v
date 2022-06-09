//File17 name   : ttc_count_rst_lite17.v
//Title17       : 
//Created17     : 1999
//Description17 : TTC17 counter reset block
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

module ttc_count_rst_lite17(

  //inputs17
  n_p_reset17,                             
  pclk17, 
  pwdata17,                                                           
  clk_ctrl_reg_sel17,
  restart17,        

  //outputs17
  count_en_out17,
  clk_ctrl_reg_out17

  );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS17
//-----------------------------------------------------------------------------

   // inputs17
   input n_p_reset17;                 // Reset17 signal17
   input pclk17;                    // APB17 System17 clock17
   input [6:0] pwdata17;           // 7-Bit17 pwdata17 from APB17 interface
   input clk_ctrl_reg_sel17;        // Select17 for the clk_ctrl_reg17
   input restart17;                 // Restart17 reset from cntr_ctrl_reg17

   // outputs17
   output count_en_out17;
   output [6:0] clk_ctrl_reg_out17; // Controls17 clock17 selected


//-----------------------------------------------------------------------------
// Internal Signals17 & Registers17
//-----------------------------------------------------------------------------


   
   reg [6:0]    clk_ctrl_reg17;     //7-bit clock17 control17 register.
   
   reg          restart_var17;      //ensures17 prescaler17 reset at start of restart17 
   
   reg          count_en17;         //enable signal17 to counter

   
   wire [6:0]   clk_ctrl_reg_out17; //clock17 control17 output wire
   wire         count_en_out17;     //counter enable output
   
   
//-----------------------------------------------------------------------------
// Logic17 Section17:


//
//    p_clk_ctrl17: Process17 to implement the clk_ctrl_reg17.  
//                When17 select17 line is set then17 the data will be inserted17 to 
//                the clock17 control17 register, otherwise17 it will be equal17 to 
//                the previous value of the register, else it will be zero.
//-----------------------------------------------------------------------------

   assign clk_ctrl_reg_out17  = clk_ctrl_reg17;
   assign count_en_out17      = count_en17;


//    p_ps_counter17: counter for clock17 enable generation17.
   
   always @(posedge pclk17 or negedge n_p_reset17)
   begin: p_ps_counter17
      
      if (!n_p_reset17)
      begin
         restart_var17  <= 1'b0;
         count_en17     <= 1'b0;
      end
      else
      begin
         if (restart17 & ~restart_var17)
         begin
            restart_var17  <= 1'b1;
            count_en17     <= 1'b0;
         end 
         
         else 
           begin
              
              if (~restart17)
                 restart_var17 <= 1'b0;
              else
                 restart_var17 <= restart_var17;
                 
              count_en17     <= 1'b1;        
              
           end
      end // else: !if(!n_p_reset17)      
  
   end  //p_ps_counter17



// p_clk_ctrl17 : Process17 for writing to the clk_ctrl_reg17
   
   always @ (posedge pclk17 or negedge n_p_reset17)
   begin: p_clk_ctrl17
      
      if (!n_p_reset17)
         clk_ctrl_reg17 <= 7'h00;
      else
      begin 

         if (clk_ctrl_reg_sel17)
            clk_ctrl_reg17 <= pwdata17;
         else
            clk_ctrl_reg17 <= clk_ctrl_reg17;

      end 
      
   end  //p_clk_ctrl17

   
endmodule
