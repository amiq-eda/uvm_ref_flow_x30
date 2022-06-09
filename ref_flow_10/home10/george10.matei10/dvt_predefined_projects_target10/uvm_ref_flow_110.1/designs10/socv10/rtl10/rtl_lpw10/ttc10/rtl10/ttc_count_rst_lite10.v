//File10 name   : ttc_count_rst_lite10.v
//Title10       : 
//Created10     : 1999
//Description10 : TTC10 counter reset block
//Notes10       : 
//----------------------------------------------------------------------
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------

module ttc_count_rst_lite10(

  //inputs10
  n_p_reset10,                             
  pclk10, 
  pwdata10,                                                           
  clk_ctrl_reg_sel10,
  restart10,        

  //outputs10
  count_en_out10,
  clk_ctrl_reg_out10

  );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS10
//-----------------------------------------------------------------------------

   // inputs10
   input n_p_reset10;                 // Reset10 signal10
   input pclk10;                    // APB10 System10 clock10
   input [6:0] pwdata10;           // 7-Bit10 pwdata10 from APB10 interface
   input clk_ctrl_reg_sel10;        // Select10 for the clk_ctrl_reg10
   input restart10;                 // Restart10 reset from cntr_ctrl_reg10

   // outputs10
   output count_en_out10;
   output [6:0] clk_ctrl_reg_out10; // Controls10 clock10 selected


//-----------------------------------------------------------------------------
// Internal Signals10 & Registers10
//-----------------------------------------------------------------------------


   
   reg [6:0]    clk_ctrl_reg10;     //7-bit clock10 control10 register.
   
   reg          restart_var10;      //ensures10 prescaler10 reset at start of restart10 
   
   reg          count_en10;         //enable signal10 to counter

   
   wire [6:0]   clk_ctrl_reg_out10; //clock10 control10 output wire
   wire         count_en_out10;     //counter enable output
   
   
//-----------------------------------------------------------------------------
// Logic10 Section10:


//
//    p_clk_ctrl10: Process10 to implement the clk_ctrl_reg10.  
//                When10 select10 line is set then10 the data will be inserted10 to 
//                the clock10 control10 register, otherwise10 it will be equal10 to 
//                the previous value of the register, else it will be zero.
//-----------------------------------------------------------------------------

   assign clk_ctrl_reg_out10  = clk_ctrl_reg10;
   assign count_en_out10      = count_en10;


//    p_ps_counter10: counter for clock10 enable generation10.
   
   always @(posedge pclk10 or negedge n_p_reset10)
   begin: p_ps_counter10
      
      if (!n_p_reset10)
      begin
         restart_var10  <= 1'b0;
         count_en10     <= 1'b0;
      end
      else
      begin
         if (restart10 & ~restart_var10)
         begin
            restart_var10  <= 1'b1;
            count_en10     <= 1'b0;
         end 
         
         else 
           begin
              
              if (~restart10)
                 restart_var10 <= 1'b0;
              else
                 restart_var10 <= restart_var10;
                 
              count_en10     <= 1'b1;        
              
           end
      end // else: !if(!n_p_reset10)      
  
   end  //p_ps_counter10



// p_clk_ctrl10 : Process10 for writing to the clk_ctrl_reg10
   
   always @ (posedge pclk10 or negedge n_p_reset10)
   begin: p_clk_ctrl10
      
      if (!n_p_reset10)
         clk_ctrl_reg10 <= 7'h00;
      else
      begin 

         if (clk_ctrl_reg_sel10)
            clk_ctrl_reg10 <= pwdata10;
         else
            clk_ctrl_reg10 <= clk_ctrl_reg10;

      end 
      
   end  //p_clk_ctrl10

   
endmodule
