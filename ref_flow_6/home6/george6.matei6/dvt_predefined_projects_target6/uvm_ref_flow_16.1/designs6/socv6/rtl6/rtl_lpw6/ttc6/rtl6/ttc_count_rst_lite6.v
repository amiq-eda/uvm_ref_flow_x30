//File6 name   : ttc_count_rst_lite6.v
//Title6       : 
//Created6     : 1999
//Description6 : TTC6 counter reset block
//Notes6       : 
//----------------------------------------------------------------------
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------

module ttc_count_rst_lite6(

  //inputs6
  n_p_reset6,                             
  pclk6, 
  pwdata6,                                                           
  clk_ctrl_reg_sel6,
  restart6,        

  //outputs6
  count_en_out6,
  clk_ctrl_reg_out6

  );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS6
//-----------------------------------------------------------------------------

   // inputs6
   input n_p_reset6;                 // Reset6 signal6
   input pclk6;                    // APB6 System6 clock6
   input [6:0] pwdata6;           // 7-Bit6 pwdata6 from APB6 interface
   input clk_ctrl_reg_sel6;        // Select6 for the clk_ctrl_reg6
   input restart6;                 // Restart6 reset from cntr_ctrl_reg6

   // outputs6
   output count_en_out6;
   output [6:0] clk_ctrl_reg_out6; // Controls6 clock6 selected


//-----------------------------------------------------------------------------
// Internal Signals6 & Registers6
//-----------------------------------------------------------------------------


   
   reg [6:0]    clk_ctrl_reg6;     //7-bit clock6 control6 register.
   
   reg          restart_var6;      //ensures6 prescaler6 reset at start of restart6 
   
   reg          count_en6;         //enable signal6 to counter

   
   wire [6:0]   clk_ctrl_reg_out6; //clock6 control6 output wire
   wire         count_en_out6;     //counter enable output
   
   
//-----------------------------------------------------------------------------
// Logic6 Section6:


//
//    p_clk_ctrl6: Process6 to implement the clk_ctrl_reg6.  
//                When6 select6 line is set then6 the data will be inserted6 to 
//                the clock6 control6 register, otherwise6 it will be equal6 to 
//                the previous value of the register, else it will be zero.
//-----------------------------------------------------------------------------

   assign clk_ctrl_reg_out6  = clk_ctrl_reg6;
   assign count_en_out6      = count_en6;


//    p_ps_counter6: counter for clock6 enable generation6.
   
   always @(posedge pclk6 or negedge n_p_reset6)
   begin: p_ps_counter6
      
      if (!n_p_reset6)
      begin
         restart_var6  <= 1'b0;
         count_en6     <= 1'b0;
      end
      else
      begin
         if (restart6 & ~restart_var6)
         begin
            restart_var6  <= 1'b1;
            count_en6     <= 1'b0;
         end 
         
         else 
           begin
              
              if (~restart6)
                 restart_var6 <= 1'b0;
              else
                 restart_var6 <= restart_var6;
                 
              count_en6     <= 1'b1;        
              
           end
      end // else: !if(!n_p_reset6)      
  
   end  //p_ps_counter6



// p_clk_ctrl6 : Process6 for writing to the clk_ctrl_reg6
   
   always @ (posedge pclk6 or negedge n_p_reset6)
   begin: p_clk_ctrl6
      
      if (!n_p_reset6)
         clk_ctrl_reg6 <= 7'h00;
      else
      begin 

         if (clk_ctrl_reg_sel6)
            clk_ctrl_reg6 <= pwdata6;
         else
            clk_ctrl_reg6 <= clk_ctrl_reg6;

      end 
      
   end  //p_clk_ctrl6

   
endmodule
