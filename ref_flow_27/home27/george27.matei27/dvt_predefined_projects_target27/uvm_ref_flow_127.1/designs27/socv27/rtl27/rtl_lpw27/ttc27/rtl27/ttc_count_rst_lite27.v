//File27 name   : ttc_count_rst_lite27.v
//Title27       : 
//Created27     : 1999
//Description27 : TTC27 counter reset block
//Notes27       : 
//----------------------------------------------------------------------
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------

module ttc_count_rst_lite27(

  //inputs27
  n_p_reset27,                             
  pclk27, 
  pwdata27,                                                           
  clk_ctrl_reg_sel27,
  restart27,        

  //outputs27
  count_en_out27,
  clk_ctrl_reg_out27

  );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS27
//-----------------------------------------------------------------------------

   // inputs27
   input n_p_reset27;                 // Reset27 signal27
   input pclk27;                    // APB27 System27 clock27
   input [6:0] pwdata27;           // 7-Bit27 pwdata27 from APB27 interface
   input clk_ctrl_reg_sel27;        // Select27 for the clk_ctrl_reg27
   input restart27;                 // Restart27 reset from cntr_ctrl_reg27

   // outputs27
   output count_en_out27;
   output [6:0] clk_ctrl_reg_out27; // Controls27 clock27 selected


//-----------------------------------------------------------------------------
// Internal Signals27 & Registers27
//-----------------------------------------------------------------------------


   
   reg [6:0]    clk_ctrl_reg27;     //7-bit clock27 control27 register.
   
   reg          restart_var27;      //ensures27 prescaler27 reset at start of restart27 
   
   reg          count_en27;         //enable signal27 to counter

   
   wire [6:0]   clk_ctrl_reg_out27; //clock27 control27 output wire
   wire         count_en_out27;     //counter enable output
   
   
//-----------------------------------------------------------------------------
// Logic27 Section27:


//
//    p_clk_ctrl27: Process27 to implement the clk_ctrl_reg27.  
//                When27 select27 line is set then27 the data will be inserted27 to 
//                the clock27 control27 register, otherwise27 it will be equal27 to 
//                the previous value of the register, else it will be zero.
//-----------------------------------------------------------------------------

   assign clk_ctrl_reg_out27  = clk_ctrl_reg27;
   assign count_en_out27      = count_en27;


//    p_ps_counter27: counter for clock27 enable generation27.
   
   always @(posedge pclk27 or negedge n_p_reset27)
   begin: p_ps_counter27
      
      if (!n_p_reset27)
      begin
         restart_var27  <= 1'b0;
         count_en27     <= 1'b0;
      end
      else
      begin
         if (restart27 & ~restart_var27)
         begin
            restart_var27  <= 1'b1;
            count_en27     <= 1'b0;
         end 
         
         else 
           begin
              
              if (~restart27)
                 restart_var27 <= 1'b0;
              else
                 restart_var27 <= restart_var27;
                 
              count_en27     <= 1'b1;        
              
           end
      end // else: !if(!n_p_reset27)      
  
   end  //p_ps_counter27



// p_clk_ctrl27 : Process27 for writing to the clk_ctrl_reg27
   
   always @ (posedge pclk27 or negedge n_p_reset27)
   begin: p_clk_ctrl27
      
      if (!n_p_reset27)
         clk_ctrl_reg27 <= 7'h00;
      else
      begin 

         if (clk_ctrl_reg_sel27)
            clk_ctrl_reg27 <= pwdata27;
         else
            clk_ctrl_reg27 <= clk_ctrl_reg27;

      end 
      
   end  //p_clk_ctrl27

   
endmodule
