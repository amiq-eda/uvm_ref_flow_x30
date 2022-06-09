//File26 name   : ttc_count_rst_lite26.v
//Title26       : 
//Created26     : 1999
//Description26 : TTC26 counter reset block
//Notes26       : 
//----------------------------------------------------------------------
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------

module ttc_count_rst_lite26(

  //inputs26
  n_p_reset26,                             
  pclk26, 
  pwdata26,                                                           
  clk_ctrl_reg_sel26,
  restart26,        

  //outputs26
  count_en_out26,
  clk_ctrl_reg_out26

  );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS26
//-----------------------------------------------------------------------------

   // inputs26
   input n_p_reset26;                 // Reset26 signal26
   input pclk26;                    // APB26 System26 clock26
   input [6:0] pwdata26;           // 7-Bit26 pwdata26 from APB26 interface
   input clk_ctrl_reg_sel26;        // Select26 for the clk_ctrl_reg26
   input restart26;                 // Restart26 reset from cntr_ctrl_reg26

   // outputs26
   output count_en_out26;
   output [6:0] clk_ctrl_reg_out26; // Controls26 clock26 selected


//-----------------------------------------------------------------------------
// Internal Signals26 & Registers26
//-----------------------------------------------------------------------------


   
   reg [6:0]    clk_ctrl_reg26;     //7-bit clock26 control26 register.
   
   reg          restart_var26;      //ensures26 prescaler26 reset at start of restart26 
   
   reg          count_en26;         //enable signal26 to counter

   
   wire [6:0]   clk_ctrl_reg_out26; //clock26 control26 output wire
   wire         count_en_out26;     //counter enable output
   
   
//-----------------------------------------------------------------------------
// Logic26 Section26:


//
//    p_clk_ctrl26: Process26 to implement the clk_ctrl_reg26.  
//                When26 select26 line is set then26 the data will be inserted26 to 
//                the clock26 control26 register, otherwise26 it will be equal26 to 
//                the previous value of the register, else it will be zero.
//-----------------------------------------------------------------------------

   assign clk_ctrl_reg_out26  = clk_ctrl_reg26;
   assign count_en_out26      = count_en26;


//    p_ps_counter26: counter for clock26 enable generation26.
   
   always @(posedge pclk26 or negedge n_p_reset26)
   begin: p_ps_counter26
      
      if (!n_p_reset26)
      begin
         restart_var26  <= 1'b0;
         count_en26     <= 1'b0;
      end
      else
      begin
         if (restart26 & ~restart_var26)
         begin
            restart_var26  <= 1'b1;
            count_en26     <= 1'b0;
         end 
         
         else 
           begin
              
              if (~restart26)
                 restart_var26 <= 1'b0;
              else
                 restart_var26 <= restart_var26;
                 
              count_en26     <= 1'b1;        
              
           end
      end // else: !if(!n_p_reset26)      
  
   end  //p_ps_counter26



// p_clk_ctrl26 : Process26 for writing to the clk_ctrl_reg26
   
   always @ (posedge pclk26 or negedge n_p_reset26)
   begin: p_clk_ctrl26
      
      if (!n_p_reset26)
         clk_ctrl_reg26 <= 7'h00;
      else
      begin 

         if (clk_ctrl_reg_sel26)
            clk_ctrl_reg26 <= pwdata26;
         else
            clk_ctrl_reg26 <= clk_ctrl_reg26;

      end 
      
   end  //p_clk_ctrl26

   
endmodule
