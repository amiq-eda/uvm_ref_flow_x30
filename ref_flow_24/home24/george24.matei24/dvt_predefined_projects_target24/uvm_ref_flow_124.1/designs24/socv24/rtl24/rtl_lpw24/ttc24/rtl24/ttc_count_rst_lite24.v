//File24 name   : ttc_count_rst_lite24.v
//Title24       : 
//Created24     : 1999
//Description24 : TTC24 counter reset block
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

module ttc_count_rst_lite24(

  //inputs24
  n_p_reset24,                             
  pclk24, 
  pwdata24,                                                           
  clk_ctrl_reg_sel24,
  restart24,        

  //outputs24
  count_en_out24,
  clk_ctrl_reg_out24

  );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS24
//-----------------------------------------------------------------------------

   // inputs24
   input n_p_reset24;                 // Reset24 signal24
   input pclk24;                    // APB24 System24 clock24
   input [6:0] pwdata24;           // 7-Bit24 pwdata24 from APB24 interface
   input clk_ctrl_reg_sel24;        // Select24 for the clk_ctrl_reg24
   input restart24;                 // Restart24 reset from cntr_ctrl_reg24

   // outputs24
   output count_en_out24;
   output [6:0] clk_ctrl_reg_out24; // Controls24 clock24 selected


//-----------------------------------------------------------------------------
// Internal Signals24 & Registers24
//-----------------------------------------------------------------------------


   
   reg [6:0]    clk_ctrl_reg24;     //7-bit clock24 control24 register.
   
   reg          restart_var24;      //ensures24 prescaler24 reset at start of restart24 
   
   reg          count_en24;         //enable signal24 to counter

   
   wire [6:0]   clk_ctrl_reg_out24; //clock24 control24 output wire
   wire         count_en_out24;     //counter enable output
   
   
//-----------------------------------------------------------------------------
// Logic24 Section24:


//
//    p_clk_ctrl24: Process24 to implement the clk_ctrl_reg24.  
//                When24 select24 line is set then24 the data will be inserted24 to 
//                the clock24 control24 register, otherwise24 it will be equal24 to 
//                the previous value of the register, else it will be zero.
//-----------------------------------------------------------------------------

   assign clk_ctrl_reg_out24  = clk_ctrl_reg24;
   assign count_en_out24      = count_en24;


//    p_ps_counter24: counter for clock24 enable generation24.
   
   always @(posedge pclk24 or negedge n_p_reset24)
   begin: p_ps_counter24
      
      if (!n_p_reset24)
      begin
         restart_var24  <= 1'b0;
         count_en24     <= 1'b0;
      end
      else
      begin
         if (restart24 & ~restart_var24)
         begin
            restart_var24  <= 1'b1;
            count_en24     <= 1'b0;
         end 
         
         else 
           begin
              
              if (~restart24)
                 restart_var24 <= 1'b0;
              else
                 restart_var24 <= restart_var24;
                 
              count_en24     <= 1'b1;        
              
           end
      end // else: !if(!n_p_reset24)      
  
   end  //p_ps_counter24



// p_clk_ctrl24 : Process24 for writing to the clk_ctrl_reg24
   
   always @ (posedge pclk24 or negedge n_p_reset24)
   begin: p_clk_ctrl24
      
      if (!n_p_reset24)
         clk_ctrl_reg24 <= 7'h00;
      else
      begin 

         if (clk_ctrl_reg_sel24)
            clk_ctrl_reg24 <= pwdata24;
         else
            clk_ctrl_reg24 <= clk_ctrl_reg24;

      end 
      
   end  //p_clk_ctrl24

   
endmodule
