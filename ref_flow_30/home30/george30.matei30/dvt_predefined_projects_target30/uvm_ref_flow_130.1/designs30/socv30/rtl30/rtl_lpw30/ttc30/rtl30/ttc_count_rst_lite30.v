//File30 name   : ttc_count_rst_lite30.v
//Title30       : 
//Created30     : 1999
//Description30 : TTC30 counter reset block
//Notes30       : 
//----------------------------------------------------------------------
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------

module ttc_count_rst_lite30(

  //inputs30
  n_p_reset30,                             
  pclk30, 
  pwdata30,                                                           
  clk_ctrl_reg_sel30,
  restart30,        

  //outputs30
  count_en_out30,
  clk_ctrl_reg_out30

  );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS30
//-----------------------------------------------------------------------------

   // inputs30
   input n_p_reset30;                 // Reset30 signal30
   input pclk30;                    // APB30 System30 clock30
   input [6:0] pwdata30;           // 7-Bit30 pwdata30 from APB30 interface
   input clk_ctrl_reg_sel30;        // Select30 for the clk_ctrl_reg30
   input restart30;                 // Restart30 reset from cntr_ctrl_reg30

   // outputs30
   output count_en_out30;
   output [6:0] clk_ctrl_reg_out30; // Controls30 clock30 selected


//-----------------------------------------------------------------------------
// Internal Signals30 & Registers30
//-----------------------------------------------------------------------------


   
   reg [6:0]    clk_ctrl_reg30;     //7-bit clock30 control30 register.
   
   reg          restart_var30;      //ensures30 prescaler30 reset at start of restart30 
   
   reg          count_en30;         //enable signal30 to counter

   
   wire [6:0]   clk_ctrl_reg_out30; //clock30 control30 output wire
   wire         count_en_out30;     //counter enable output
   
   
//-----------------------------------------------------------------------------
// Logic30 Section30:


//
//    p_clk_ctrl30: Process30 to implement the clk_ctrl_reg30.  
//                When30 select30 line is set then30 the data will be inserted30 to 
//                the clock30 control30 register, otherwise30 it will be equal30 to 
//                the previous value of the register, else it will be zero.
//-----------------------------------------------------------------------------

   assign clk_ctrl_reg_out30  = clk_ctrl_reg30;
   assign count_en_out30      = count_en30;


//    p_ps_counter30: counter for clock30 enable generation30.
   
   always @(posedge pclk30 or negedge n_p_reset30)
   begin: p_ps_counter30
      
      if (!n_p_reset30)
      begin
         restart_var30  <= 1'b0;
         count_en30     <= 1'b0;
      end
      else
      begin
         if (restart30 & ~restart_var30)
         begin
            restart_var30  <= 1'b1;
            count_en30     <= 1'b0;
         end 
         
         else 
           begin
              
              if (~restart30)
                 restart_var30 <= 1'b0;
              else
                 restart_var30 <= restart_var30;
                 
              count_en30     <= 1'b1;        
              
           end
      end // else: !if(!n_p_reset30)      
  
   end  //p_ps_counter30



// p_clk_ctrl30 : Process30 for writing to the clk_ctrl_reg30
   
   always @ (posedge pclk30 or negedge n_p_reset30)
   begin: p_clk_ctrl30
      
      if (!n_p_reset30)
         clk_ctrl_reg30 <= 7'h00;
      else
      begin 

         if (clk_ctrl_reg_sel30)
            clk_ctrl_reg30 <= pwdata30;
         else
            clk_ctrl_reg30 <= clk_ctrl_reg30;

      end 
      
   end  //p_clk_ctrl30

   
endmodule
