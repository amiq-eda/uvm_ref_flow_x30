//File3 name   : ttc_count_rst_lite3.v
//Title3       : 
//Created3     : 1999
//Description3 : TTC3 counter reset block
//Notes3       : 
//----------------------------------------------------------------------
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------

module ttc_count_rst_lite3(

  //inputs3
  n_p_reset3,                             
  pclk3, 
  pwdata3,                                                           
  clk_ctrl_reg_sel3,
  restart3,        

  //outputs3
  count_en_out3,
  clk_ctrl_reg_out3

  );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS3
//-----------------------------------------------------------------------------

   // inputs3
   input n_p_reset3;                 // Reset3 signal3
   input pclk3;                    // APB3 System3 clock3
   input [6:0] pwdata3;           // 7-Bit3 pwdata3 from APB3 interface
   input clk_ctrl_reg_sel3;        // Select3 for the clk_ctrl_reg3
   input restart3;                 // Restart3 reset from cntr_ctrl_reg3

   // outputs3
   output count_en_out3;
   output [6:0] clk_ctrl_reg_out3; // Controls3 clock3 selected


//-----------------------------------------------------------------------------
// Internal Signals3 & Registers3
//-----------------------------------------------------------------------------


   
   reg [6:0]    clk_ctrl_reg3;     //7-bit clock3 control3 register.
   
   reg          restart_var3;      //ensures3 prescaler3 reset at start of restart3 
   
   reg          count_en3;         //enable signal3 to counter

   
   wire [6:0]   clk_ctrl_reg_out3; //clock3 control3 output wire
   wire         count_en_out3;     //counter enable output
   
   
//-----------------------------------------------------------------------------
// Logic3 Section3:


//
//    p_clk_ctrl3: Process3 to implement the clk_ctrl_reg3.  
//                When3 select3 line is set then3 the data will be inserted3 to 
//                the clock3 control3 register, otherwise3 it will be equal3 to 
//                the previous value of the register, else it will be zero.
//-----------------------------------------------------------------------------

   assign clk_ctrl_reg_out3  = clk_ctrl_reg3;
   assign count_en_out3      = count_en3;


//    p_ps_counter3: counter for clock3 enable generation3.
   
   always @(posedge pclk3 or negedge n_p_reset3)
   begin: p_ps_counter3
      
      if (!n_p_reset3)
      begin
         restart_var3  <= 1'b0;
         count_en3     <= 1'b0;
      end
      else
      begin
         if (restart3 & ~restart_var3)
         begin
            restart_var3  <= 1'b1;
            count_en3     <= 1'b0;
         end 
         
         else 
           begin
              
              if (~restart3)
                 restart_var3 <= 1'b0;
              else
                 restart_var3 <= restart_var3;
                 
              count_en3     <= 1'b1;        
              
           end
      end // else: !if(!n_p_reset3)      
  
   end  //p_ps_counter3



// p_clk_ctrl3 : Process3 for writing to the clk_ctrl_reg3
   
   always @ (posedge pclk3 or negedge n_p_reset3)
   begin: p_clk_ctrl3
      
      if (!n_p_reset3)
         clk_ctrl_reg3 <= 7'h00;
      else
      begin 

         if (clk_ctrl_reg_sel3)
            clk_ctrl_reg3 <= pwdata3;
         else
            clk_ctrl_reg3 <= clk_ctrl_reg3;

      end 
      
   end  //p_clk_ctrl3

   
endmodule
