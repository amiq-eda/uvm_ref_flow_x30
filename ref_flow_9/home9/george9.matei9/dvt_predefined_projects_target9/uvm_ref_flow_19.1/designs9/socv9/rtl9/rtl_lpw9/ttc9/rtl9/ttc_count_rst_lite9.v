//File9 name   : ttc_count_rst_lite9.v
//Title9       : 
//Created9     : 1999
//Description9 : TTC9 counter reset block
//Notes9       : 
//----------------------------------------------------------------------
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------

module ttc_count_rst_lite9(

  //inputs9
  n_p_reset9,                             
  pclk9, 
  pwdata9,                                                           
  clk_ctrl_reg_sel9,
  restart9,        

  //outputs9
  count_en_out9,
  clk_ctrl_reg_out9

  );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS9
//-----------------------------------------------------------------------------

   // inputs9
   input n_p_reset9;                 // Reset9 signal9
   input pclk9;                    // APB9 System9 clock9
   input [6:0] pwdata9;           // 7-Bit9 pwdata9 from APB9 interface
   input clk_ctrl_reg_sel9;        // Select9 for the clk_ctrl_reg9
   input restart9;                 // Restart9 reset from cntr_ctrl_reg9

   // outputs9
   output count_en_out9;
   output [6:0] clk_ctrl_reg_out9; // Controls9 clock9 selected


//-----------------------------------------------------------------------------
// Internal Signals9 & Registers9
//-----------------------------------------------------------------------------


   
   reg [6:0]    clk_ctrl_reg9;     //7-bit clock9 control9 register.
   
   reg          restart_var9;      //ensures9 prescaler9 reset at start of restart9 
   
   reg          count_en9;         //enable signal9 to counter

   
   wire [6:0]   clk_ctrl_reg_out9; //clock9 control9 output wire
   wire         count_en_out9;     //counter enable output
   
   
//-----------------------------------------------------------------------------
// Logic9 Section9:


//
//    p_clk_ctrl9: Process9 to implement the clk_ctrl_reg9.  
//                When9 select9 line is set then9 the data will be inserted9 to 
//                the clock9 control9 register, otherwise9 it will be equal9 to 
//                the previous value of the register, else it will be zero.
//-----------------------------------------------------------------------------

   assign clk_ctrl_reg_out9  = clk_ctrl_reg9;
   assign count_en_out9      = count_en9;


//    p_ps_counter9: counter for clock9 enable generation9.
   
   always @(posedge pclk9 or negedge n_p_reset9)
   begin: p_ps_counter9
      
      if (!n_p_reset9)
      begin
         restart_var9  <= 1'b0;
         count_en9     <= 1'b0;
      end
      else
      begin
         if (restart9 & ~restart_var9)
         begin
            restart_var9  <= 1'b1;
            count_en9     <= 1'b0;
         end 
         
         else 
           begin
              
              if (~restart9)
                 restart_var9 <= 1'b0;
              else
                 restart_var9 <= restart_var9;
                 
              count_en9     <= 1'b1;        
              
           end
      end // else: !if(!n_p_reset9)      
  
   end  //p_ps_counter9



// p_clk_ctrl9 : Process9 for writing to the clk_ctrl_reg9
   
   always @ (posedge pclk9 or negedge n_p_reset9)
   begin: p_clk_ctrl9
      
      if (!n_p_reset9)
         clk_ctrl_reg9 <= 7'h00;
      else
      begin 

         if (clk_ctrl_reg_sel9)
            clk_ctrl_reg9 <= pwdata9;
         else
            clk_ctrl_reg9 <= clk_ctrl_reg9;

      end 
      
   end  //p_clk_ctrl9

   
endmodule
