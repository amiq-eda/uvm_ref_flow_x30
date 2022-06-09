//File12 name   : ttc_count_rst_lite12.v
//Title12       : 
//Created12     : 1999
//Description12 : TTC12 counter reset block
//Notes12       : 
//----------------------------------------------------------------------
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------

module ttc_count_rst_lite12(

  //inputs12
  n_p_reset12,                             
  pclk12, 
  pwdata12,                                                           
  clk_ctrl_reg_sel12,
  restart12,        

  //outputs12
  count_en_out12,
  clk_ctrl_reg_out12

  );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS12
//-----------------------------------------------------------------------------

   // inputs12
   input n_p_reset12;                 // Reset12 signal12
   input pclk12;                    // APB12 System12 clock12
   input [6:0] pwdata12;           // 7-Bit12 pwdata12 from APB12 interface
   input clk_ctrl_reg_sel12;        // Select12 for the clk_ctrl_reg12
   input restart12;                 // Restart12 reset from cntr_ctrl_reg12

   // outputs12
   output count_en_out12;
   output [6:0] clk_ctrl_reg_out12; // Controls12 clock12 selected


//-----------------------------------------------------------------------------
// Internal Signals12 & Registers12
//-----------------------------------------------------------------------------


   
   reg [6:0]    clk_ctrl_reg12;     //7-bit clock12 control12 register.
   
   reg          restart_var12;      //ensures12 prescaler12 reset at start of restart12 
   
   reg          count_en12;         //enable signal12 to counter

   
   wire [6:0]   clk_ctrl_reg_out12; //clock12 control12 output wire
   wire         count_en_out12;     //counter enable output
   
   
//-----------------------------------------------------------------------------
// Logic12 Section12:


//
//    p_clk_ctrl12: Process12 to implement the clk_ctrl_reg12.  
//                When12 select12 line is set then12 the data will be inserted12 to 
//                the clock12 control12 register, otherwise12 it will be equal12 to 
//                the previous value of the register, else it will be zero.
//-----------------------------------------------------------------------------

   assign clk_ctrl_reg_out12  = clk_ctrl_reg12;
   assign count_en_out12      = count_en12;


//    p_ps_counter12: counter for clock12 enable generation12.
   
   always @(posedge pclk12 or negedge n_p_reset12)
   begin: p_ps_counter12
      
      if (!n_p_reset12)
      begin
         restart_var12  <= 1'b0;
         count_en12     <= 1'b0;
      end
      else
      begin
         if (restart12 & ~restart_var12)
         begin
            restart_var12  <= 1'b1;
            count_en12     <= 1'b0;
         end 
         
         else 
           begin
              
              if (~restart12)
                 restart_var12 <= 1'b0;
              else
                 restart_var12 <= restart_var12;
                 
              count_en12     <= 1'b1;        
              
           end
      end // else: !if(!n_p_reset12)      
  
   end  //p_ps_counter12



// p_clk_ctrl12 : Process12 for writing to the clk_ctrl_reg12
   
   always @ (posedge pclk12 or negedge n_p_reset12)
   begin: p_clk_ctrl12
      
      if (!n_p_reset12)
         clk_ctrl_reg12 <= 7'h00;
      else
      begin 

         if (clk_ctrl_reg_sel12)
            clk_ctrl_reg12 <= pwdata12;
         else
            clk_ctrl_reg12 <= clk_ctrl_reg12;

      end 
      
   end  //p_clk_ctrl12

   
endmodule
