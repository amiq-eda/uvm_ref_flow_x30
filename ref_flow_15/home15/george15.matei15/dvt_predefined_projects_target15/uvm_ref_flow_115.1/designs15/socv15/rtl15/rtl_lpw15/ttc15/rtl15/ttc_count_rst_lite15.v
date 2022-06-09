//File15 name   : ttc_count_rst_lite15.v
//Title15       : 
//Created15     : 1999
//Description15 : TTC15 counter reset block
//Notes15       : 
//----------------------------------------------------------------------
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------

module ttc_count_rst_lite15(

  //inputs15
  n_p_reset15,                             
  pclk15, 
  pwdata15,                                                           
  clk_ctrl_reg_sel15,
  restart15,        

  //outputs15
  count_en_out15,
  clk_ctrl_reg_out15

  );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS15
//-----------------------------------------------------------------------------

   // inputs15
   input n_p_reset15;                 // Reset15 signal15
   input pclk15;                    // APB15 System15 clock15
   input [6:0] pwdata15;           // 7-Bit15 pwdata15 from APB15 interface
   input clk_ctrl_reg_sel15;        // Select15 for the clk_ctrl_reg15
   input restart15;                 // Restart15 reset from cntr_ctrl_reg15

   // outputs15
   output count_en_out15;
   output [6:0] clk_ctrl_reg_out15; // Controls15 clock15 selected


//-----------------------------------------------------------------------------
// Internal Signals15 & Registers15
//-----------------------------------------------------------------------------


   
   reg [6:0]    clk_ctrl_reg15;     //7-bit clock15 control15 register.
   
   reg          restart_var15;      //ensures15 prescaler15 reset at start of restart15 
   
   reg          count_en15;         //enable signal15 to counter

   
   wire [6:0]   clk_ctrl_reg_out15; //clock15 control15 output wire
   wire         count_en_out15;     //counter enable output
   
   
//-----------------------------------------------------------------------------
// Logic15 Section15:


//
//    p_clk_ctrl15: Process15 to implement the clk_ctrl_reg15.  
//                When15 select15 line is set then15 the data will be inserted15 to 
//                the clock15 control15 register, otherwise15 it will be equal15 to 
//                the previous value of the register, else it will be zero.
//-----------------------------------------------------------------------------

   assign clk_ctrl_reg_out15  = clk_ctrl_reg15;
   assign count_en_out15      = count_en15;


//    p_ps_counter15: counter for clock15 enable generation15.
   
   always @(posedge pclk15 or negedge n_p_reset15)
   begin: p_ps_counter15
      
      if (!n_p_reset15)
      begin
         restart_var15  <= 1'b0;
         count_en15     <= 1'b0;
      end
      else
      begin
         if (restart15 & ~restart_var15)
         begin
            restart_var15  <= 1'b1;
            count_en15     <= 1'b0;
         end 
         
         else 
           begin
              
              if (~restart15)
                 restart_var15 <= 1'b0;
              else
                 restart_var15 <= restart_var15;
                 
              count_en15     <= 1'b1;        
              
           end
      end // else: !if(!n_p_reset15)      
  
   end  //p_ps_counter15



// p_clk_ctrl15 : Process15 for writing to the clk_ctrl_reg15
   
   always @ (posedge pclk15 or negedge n_p_reset15)
   begin: p_clk_ctrl15
      
      if (!n_p_reset15)
         clk_ctrl_reg15 <= 7'h00;
      else
      begin 

         if (clk_ctrl_reg_sel15)
            clk_ctrl_reg15 <= pwdata15;
         else
            clk_ctrl_reg15 <= clk_ctrl_reg15;

      end 
      
   end  //p_clk_ctrl15

   
endmodule
