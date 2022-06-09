//File22 name   : ttc_count_rst_lite22.v
//Title22       : 
//Created22     : 1999
//Description22 : TTC22 counter reset block
//Notes22       : 
//----------------------------------------------------------------------
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------

module ttc_count_rst_lite22(

  //inputs22
  n_p_reset22,                             
  pclk22, 
  pwdata22,                                                           
  clk_ctrl_reg_sel22,
  restart22,        

  //outputs22
  count_en_out22,
  clk_ctrl_reg_out22

  );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS22
//-----------------------------------------------------------------------------

   // inputs22
   input n_p_reset22;                 // Reset22 signal22
   input pclk22;                    // APB22 System22 clock22
   input [6:0] pwdata22;           // 7-Bit22 pwdata22 from APB22 interface
   input clk_ctrl_reg_sel22;        // Select22 for the clk_ctrl_reg22
   input restart22;                 // Restart22 reset from cntr_ctrl_reg22

   // outputs22
   output count_en_out22;
   output [6:0] clk_ctrl_reg_out22; // Controls22 clock22 selected


//-----------------------------------------------------------------------------
// Internal Signals22 & Registers22
//-----------------------------------------------------------------------------


   
   reg [6:0]    clk_ctrl_reg22;     //7-bit clock22 control22 register.
   
   reg          restart_var22;      //ensures22 prescaler22 reset at start of restart22 
   
   reg          count_en22;         //enable signal22 to counter

   
   wire [6:0]   clk_ctrl_reg_out22; //clock22 control22 output wire
   wire         count_en_out22;     //counter enable output
   
   
//-----------------------------------------------------------------------------
// Logic22 Section22:


//
//    p_clk_ctrl22: Process22 to implement the clk_ctrl_reg22.  
//                When22 select22 line is set then22 the data will be inserted22 to 
//                the clock22 control22 register, otherwise22 it will be equal22 to 
//                the previous value of the register, else it will be zero.
//-----------------------------------------------------------------------------

   assign clk_ctrl_reg_out22  = clk_ctrl_reg22;
   assign count_en_out22      = count_en22;


//    p_ps_counter22: counter for clock22 enable generation22.
   
   always @(posedge pclk22 or negedge n_p_reset22)
   begin: p_ps_counter22
      
      if (!n_p_reset22)
      begin
         restart_var22  <= 1'b0;
         count_en22     <= 1'b0;
      end
      else
      begin
         if (restart22 & ~restart_var22)
         begin
            restart_var22  <= 1'b1;
            count_en22     <= 1'b0;
         end 
         
         else 
           begin
              
              if (~restart22)
                 restart_var22 <= 1'b0;
              else
                 restart_var22 <= restart_var22;
                 
              count_en22     <= 1'b1;        
              
           end
      end // else: !if(!n_p_reset22)      
  
   end  //p_ps_counter22



// p_clk_ctrl22 : Process22 for writing to the clk_ctrl_reg22
   
   always @ (posedge pclk22 or negedge n_p_reset22)
   begin: p_clk_ctrl22
      
      if (!n_p_reset22)
         clk_ctrl_reg22 <= 7'h00;
      else
      begin 

         if (clk_ctrl_reg_sel22)
            clk_ctrl_reg22 <= pwdata22;
         else
            clk_ctrl_reg22 <= clk_ctrl_reg22;

      end 
      
   end  //p_clk_ctrl22

   
endmodule
