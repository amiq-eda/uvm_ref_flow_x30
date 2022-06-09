//File2 name   : ttc_count_rst_lite2.v
//Title2       : 
//Created2     : 1999
//Description2 : TTC2 counter reset block
//Notes2       : 
//----------------------------------------------------------------------
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------

module ttc_count_rst_lite2(

  //inputs2
  n_p_reset2,                             
  pclk2, 
  pwdata2,                                                           
  clk_ctrl_reg_sel2,
  restart2,        

  //outputs2
  count_en_out2,
  clk_ctrl_reg_out2

  );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS2
//-----------------------------------------------------------------------------

   // inputs2
   input n_p_reset2;                 // Reset2 signal2
   input pclk2;                    // APB2 System2 clock2
   input [6:0] pwdata2;           // 7-Bit2 pwdata2 from APB2 interface
   input clk_ctrl_reg_sel2;        // Select2 for the clk_ctrl_reg2
   input restart2;                 // Restart2 reset from cntr_ctrl_reg2

   // outputs2
   output count_en_out2;
   output [6:0] clk_ctrl_reg_out2; // Controls2 clock2 selected


//-----------------------------------------------------------------------------
// Internal Signals2 & Registers2
//-----------------------------------------------------------------------------


   
   reg [6:0]    clk_ctrl_reg2;     //7-bit clock2 control2 register.
   
   reg          restart_var2;      //ensures2 prescaler2 reset at start of restart2 
   
   reg          count_en2;         //enable signal2 to counter

   
   wire [6:0]   clk_ctrl_reg_out2; //clock2 control2 output wire
   wire         count_en_out2;     //counter enable output
   
   
//-----------------------------------------------------------------------------
// Logic2 Section2:


//
//    p_clk_ctrl2: Process2 to implement the clk_ctrl_reg2.  
//                When2 select2 line is set then2 the data will be inserted2 to 
//                the clock2 control2 register, otherwise2 it will be equal2 to 
//                the previous value of the register, else it will be zero.
//-----------------------------------------------------------------------------

   assign clk_ctrl_reg_out2  = clk_ctrl_reg2;
   assign count_en_out2      = count_en2;


//    p_ps_counter2: counter for clock2 enable generation2.
   
   always @(posedge pclk2 or negedge n_p_reset2)
   begin: p_ps_counter2
      
      if (!n_p_reset2)
      begin
         restart_var2  <= 1'b0;
         count_en2     <= 1'b0;
      end
      else
      begin
         if (restart2 & ~restart_var2)
         begin
            restart_var2  <= 1'b1;
            count_en2     <= 1'b0;
         end 
         
         else 
           begin
              
              if (~restart2)
                 restart_var2 <= 1'b0;
              else
                 restart_var2 <= restart_var2;
                 
              count_en2     <= 1'b1;        
              
           end
      end // else: !if(!n_p_reset2)      
  
   end  //p_ps_counter2



// p_clk_ctrl2 : Process2 for writing to the clk_ctrl_reg2
   
   always @ (posedge pclk2 or negedge n_p_reset2)
   begin: p_clk_ctrl2
      
      if (!n_p_reset2)
         clk_ctrl_reg2 <= 7'h00;
      else
      begin 

         if (clk_ctrl_reg_sel2)
            clk_ctrl_reg2 <= pwdata2;
         else
            clk_ctrl_reg2 <= clk_ctrl_reg2;

      end 
      
   end  //p_clk_ctrl2

   
endmodule
