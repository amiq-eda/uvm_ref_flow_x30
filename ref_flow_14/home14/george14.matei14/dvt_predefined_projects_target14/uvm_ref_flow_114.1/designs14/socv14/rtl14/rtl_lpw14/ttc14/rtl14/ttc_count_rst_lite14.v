//File14 name   : ttc_count_rst_lite14.v
//Title14       : 
//Created14     : 1999
//Description14 : TTC14 counter reset block
//Notes14       : 
//----------------------------------------------------------------------
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------

module ttc_count_rst_lite14(

  //inputs14
  n_p_reset14,                             
  pclk14, 
  pwdata14,                                                           
  clk_ctrl_reg_sel14,
  restart14,        

  //outputs14
  count_en_out14,
  clk_ctrl_reg_out14

  );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS14
//-----------------------------------------------------------------------------

   // inputs14
   input n_p_reset14;                 // Reset14 signal14
   input pclk14;                    // APB14 System14 clock14
   input [6:0] pwdata14;           // 7-Bit14 pwdata14 from APB14 interface
   input clk_ctrl_reg_sel14;        // Select14 for the clk_ctrl_reg14
   input restart14;                 // Restart14 reset from cntr_ctrl_reg14

   // outputs14
   output count_en_out14;
   output [6:0] clk_ctrl_reg_out14; // Controls14 clock14 selected


//-----------------------------------------------------------------------------
// Internal Signals14 & Registers14
//-----------------------------------------------------------------------------


   
   reg [6:0]    clk_ctrl_reg14;     //7-bit clock14 control14 register.
   
   reg          restart_var14;      //ensures14 prescaler14 reset at start of restart14 
   
   reg          count_en14;         //enable signal14 to counter

   
   wire [6:0]   clk_ctrl_reg_out14; //clock14 control14 output wire
   wire         count_en_out14;     //counter enable output
   
   
//-----------------------------------------------------------------------------
// Logic14 Section14:


//
//    p_clk_ctrl14: Process14 to implement the clk_ctrl_reg14.  
//                When14 select14 line is set then14 the data will be inserted14 to 
//                the clock14 control14 register, otherwise14 it will be equal14 to 
//                the previous value of the register, else it will be zero.
//-----------------------------------------------------------------------------

   assign clk_ctrl_reg_out14  = clk_ctrl_reg14;
   assign count_en_out14      = count_en14;


//    p_ps_counter14: counter for clock14 enable generation14.
   
   always @(posedge pclk14 or negedge n_p_reset14)
   begin: p_ps_counter14
      
      if (!n_p_reset14)
      begin
         restart_var14  <= 1'b0;
         count_en14     <= 1'b0;
      end
      else
      begin
         if (restart14 & ~restart_var14)
         begin
            restart_var14  <= 1'b1;
            count_en14     <= 1'b0;
         end 
         
         else 
           begin
              
              if (~restart14)
                 restart_var14 <= 1'b0;
              else
                 restart_var14 <= restart_var14;
                 
              count_en14     <= 1'b1;        
              
           end
      end // else: !if(!n_p_reset14)      
  
   end  //p_ps_counter14



// p_clk_ctrl14 : Process14 for writing to the clk_ctrl_reg14
   
   always @ (posedge pclk14 or negedge n_p_reset14)
   begin: p_clk_ctrl14
      
      if (!n_p_reset14)
         clk_ctrl_reg14 <= 7'h00;
      else
      begin 

         if (clk_ctrl_reg_sel14)
            clk_ctrl_reg14 <= pwdata14;
         else
            clk_ctrl_reg14 <= clk_ctrl_reg14;

      end 
      
   end  //p_clk_ctrl14

   
endmodule
