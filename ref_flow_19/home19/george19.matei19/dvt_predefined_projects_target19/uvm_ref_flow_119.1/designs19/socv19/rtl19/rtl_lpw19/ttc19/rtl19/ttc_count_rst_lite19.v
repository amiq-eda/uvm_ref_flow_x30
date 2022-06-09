//File19 name   : ttc_count_rst_lite19.v
//Title19       : 
//Created19     : 1999
//Description19 : TTC19 counter reset block
//Notes19       : 
//----------------------------------------------------------------------
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------

module ttc_count_rst_lite19(

  //inputs19
  n_p_reset19,                             
  pclk19, 
  pwdata19,                                                           
  clk_ctrl_reg_sel19,
  restart19,        

  //outputs19
  count_en_out19,
  clk_ctrl_reg_out19

  );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS19
//-----------------------------------------------------------------------------

   // inputs19
   input n_p_reset19;                 // Reset19 signal19
   input pclk19;                    // APB19 System19 clock19
   input [6:0] pwdata19;           // 7-Bit19 pwdata19 from APB19 interface
   input clk_ctrl_reg_sel19;        // Select19 for the clk_ctrl_reg19
   input restart19;                 // Restart19 reset from cntr_ctrl_reg19

   // outputs19
   output count_en_out19;
   output [6:0] clk_ctrl_reg_out19; // Controls19 clock19 selected


//-----------------------------------------------------------------------------
// Internal Signals19 & Registers19
//-----------------------------------------------------------------------------


   
   reg [6:0]    clk_ctrl_reg19;     //7-bit clock19 control19 register.
   
   reg          restart_var19;      //ensures19 prescaler19 reset at start of restart19 
   
   reg          count_en19;         //enable signal19 to counter

   
   wire [6:0]   clk_ctrl_reg_out19; //clock19 control19 output wire
   wire         count_en_out19;     //counter enable output
   
   
//-----------------------------------------------------------------------------
// Logic19 Section19:


//
//    p_clk_ctrl19: Process19 to implement the clk_ctrl_reg19.  
//                When19 select19 line is set then19 the data will be inserted19 to 
//                the clock19 control19 register, otherwise19 it will be equal19 to 
//                the previous value of the register, else it will be zero.
//-----------------------------------------------------------------------------

   assign clk_ctrl_reg_out19  = clk_ctrl_reg19;
   assign count_en_out19      = count_en19;


//    p_ps_counter19: counter for clock19 enable generation19.
   
   always @(posedge pclk19 or negedge n_p_reset19)
   begin: p_ps_counter19
      
      if (!n_p_reset19)
      begin
         restart_var19  <= 1'b0;
         count_en19     <= 1'b0;
      end
      else
      begin
         if (restart19 & ~restart_var19)
         begin
            restart_var19  <= 1'b1;
            count_en19     <= 1'b0;
         end 
         
         else 
           begin
              
              if (~restart19)
                 restart_var19 <= 1'b0;
              else
                 restart_var19 <= restart_var19;
                 
              count_en19     <= 1'b1;        
              
           end
      end // else: !if(!n_p_reset19)      
  
   end  //p_ps_counter19



// p_clk_ctrl19 : Process19 for writing to the clk_ctrl_reg19
   
   always @ (posedge pclk19 or negedge n_p_reset19)
   begin: p_clk_ctrl19
      
      if (!n_p_reset19)
         clk_ctrl_reg19 <= 7'h00;
      else
      begin 

         if (clk_ctrl_reg_sel19)
            clk_ctrl_reg19 <= pwdata19;
         else
            clk_ctrl_reg19 <= clk_ctrl_reg19;

      end 
      
   end  //p_clk_ctrl19

   
endmodule
