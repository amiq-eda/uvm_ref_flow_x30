//File16 name   : ttc_count_rst_lite16.v
//Title16       : 
//Created16     : 1999
//Description16 : TTC16 counter reset block
//Notes16       : 
//----------------------------------------------------------------------
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------

module ttc_count_rst_lite16(

  //inputs16
  n_p_reset16,                             
  pclk16, 
  pwdata16,                                                           
  clk_ctrl_reg_sel16,
  restart16,        

  //outputs16
  count_en_out16,
  clk_ctrl_reg_out16

  );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS16
//-----------------------------------------------------------------------------

   // inputs16
   input n_p_reset16;                 // Reset16 signal16
   input pclk16;                    // APB16 System16 clock16
   input [6:0] pwdata16;           // 7-Bit16 pwdata16 from APB16 interface
   input clk_ctrl_reg_sel16;        // Select16 for the clk_ctrl_reg16
   input restart16;                 // Restart16 reset from cntr_ctrl_reg16

   // outputs16
   output count_en_out16;
   output [6:0] clk_ctrl_reg_out16; // Controls16 clock16 selected


//-----------------------------------------------------------------------------
// Internal Signals16 & Registers16
//-----------------------------------------------------------------------------


   
   reg [6:0]    clk_ctrl_reg16;     //7-bit clock16 control16 register.
   
   reg          restart_var16;      //ensures16 prescaler16 reset at start of restart16 
   
   reg          count_en16;         //enable signal16 to counter

   
   wire [6:0]   clk_ctrl_reg_out16; //clock16 control16 output wire
   wire         count_en_out16;     //counter enable output
   
   
//-----------------------------------------------------------------------------
// Logic16 Section16:


//
//    p_clk_ctrl16: Process16 to implement the clk_ctrl_reg16.  
//                When16 select16 line is set then16 the data will be inserted16 to 
//                the clock16 control16 register, otherwise16 it will be equal16 to 
//                the previous value of the register, else it will be zero.
//-----------------------------------------------------------------------------

   assign clk_ctrl_reg_out16  = clk_ctrl_reg16;
   assign count_en_out16      = count_en16;


//    p_ps_counter16: counter for clock16 enable generation16.
   
   always @(posedge pclk16 or negedge n_p_reset16)
   begin: p_ps_counter16
      
      if (!n_p_reset16)
      begin
         restart_var16  <= 1'b0;
         count_en16     <= 1'b0;
      end
      else
      begin
         if (restart16 & ~restart_var16)
         begin
            restart_var16  <= 1'b1;
            count_en16     <= 1'b0;
         end 
         
         else 
           begin
              
              if (~restart16)
                 restart_var16 <= 1'b0;
              else
                 restart_var16 <= restart_var16;
                 
              count_en16     <= 1'b1;        
              
           end
      end // else: !if(!n_p_reset16)      
  
   end  //p_ps_counter16



// p_clk_ctrl16 : Process16 for writing to the clk_ctrl_reg16
   
   always @ (posedge pclk16 or negedge n_p_reset16)
   begin: p_clk_ctrl16
      
      if (!n_p_reset16)
         clk_ctrl_reg16 <= 7'h00;
      else
      begin 

         if (clk_ctrl_reg_sel16)
            clk_ctrl_reg16 <= pwdata16;
         else
            clk_ctrl_reg16 <= clk_ctrl_reg16;

      end 
      
   end  //p_clk_ctrl16

   
endmodule
