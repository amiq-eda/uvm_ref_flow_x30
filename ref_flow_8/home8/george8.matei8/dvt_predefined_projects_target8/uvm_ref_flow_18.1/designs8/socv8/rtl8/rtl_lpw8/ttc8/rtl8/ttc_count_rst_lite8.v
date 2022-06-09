//File8 name   : ttc_count_rst_lite8.v
//Title8       : 
//Created8     : 1999
//Description8 : TTC8 counter reset block
//Notes8       : 
//----------------------------------------------------------------------
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------

module ttc_count_rst_lite8(

  //inputs8
  n_p_reset8,                             
  pclk8, 
  pwdata8,                                                           
  clk_ctrl_reg_sel8,
  restart8,        

  //outputs8
  count_en_out8,
  clk_ctrl_reg_out8

  );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS8
//-----------------------------------------------------------------------------

   // inputs8
   input n_p_reset8;                 // Reset8 signal8
   input pclk8;                    // APB8 System8 clock8
   input [6:0] pwdata8;           // 7-Bit8 pwdata8 from APB8 interface
   input clk_ctrl_reg_sel8;        // Select8 for the clk_ctrl_reg8
   input restart8;                 // Restart8 reset from cntr_ctrl_reg8

   // outputs8
   output count_en_out8;
   output [6:0] clk_ctrl_reg_out8; // Controls8 clock8 selected


//-----------------------------------------------------------------------------
// Internal Signals8 & Registers8
//-----------------------------------------------------------------------------


   
   reg [6:0]    clk_ctrl_reg8;     //7-bit clock8 control8 register.
   
   reg          restart_var8;      //ensures8 prescaler8 reset at start of restart8 
   
   reg          count_en8;         //enable signal8 to counter

   
   wire [6:0]   clk_ctrl_reg_out8; //clock8 control8 output wire
   wire         count_en_out8;     //counter enable output
   
   
//-----------------------------------------------------------------------------
// Logic8 Section8:


//
//    p_clk_ctrl8: Process8 to implement the clk_ctrl_reg8.  
//                When8 select8 line is set then8 the data will be inserted8 to 
//                the clock8 control8 register, otherwise8 it will be equal8 to 
//                the previous value of the register, else it will be zero.
//-----------------------------------------------------------------------------

   assign clk_ctrl_reg_out8  = clk_ctrl_reg8;
   assign count_en_out8      = count_en8;


//    p_ps_counter8: counter for clock8 enable generation8.
   
   always @(posedge pclk8 or negedge n_p_reset8)
   begin: p_ps_counter8
      
      if (!n_p_reset8)
      begin
         restart_var8  <= 1'b0;
         count_en8     <= 1'b0;
      end
      else
      begin
         if (restart8 & ~restart_var8)
         begin
            restart_var8  <= 1'b1;
            count_en8     <= 1'b0;
         end 
         
         else 
           begin
              
              if (~restart8)
                 restart_var8 <= 1'b0;
              else
                 restart_var8 <= restart_var8;
                 
              count_en8     <= 1'b1;        
              
           end
      end // else: !if(!n_p_reset8)      
  
   end  //p_ps_counter8



// p_clk_ctrl8 : Process8 for writing to the clk_ctrl_reg8
   
   always @ (posedge pclk8 or negedge n_p_reset8)
   begin: p_clk_ctrl8
      
      if (!n_p_reset8)
         clk_ctrl_reg8 <= 7'h00;
      else
      begin 

         if (clk_ctrl_reg_sel8)
            clk_ctrl_reg8 <= pwdata8;
         else
            clk_ctrl_reg8 <= clk_ctrl_reg8;

      end 
      
   end  //p_clk_ctrl8

   
endmodule
