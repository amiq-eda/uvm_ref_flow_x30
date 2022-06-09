//File13 name   : ttc_count_rst_lite13.v
//Title13       : 
//Created13     : 1999
//Description13 : TTC13 counter reset block
//Notes13       : 
//----------------------------------------------------------------------
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------

module ttc_count_rst_lite13(

  //inputs13
  n_p_reset13,                             
  pclk13, 
  pwdata13,                                                           
  clk_ctrl_reg_sel13,
  restart13,        

  //outputs13
  count_en_out13,
  clk_ctrl_reg_out13

  );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS13
//-----------------------------------------------------------------------------

   // inputs13
   input n_p_reset13;                 // Reset13 signal13
   input pclk13;                    // APB13 System13 clock13
   input [6:0] pwdata13;           // 7-Bit13 pwdata13 from APB13 interface
   input clk_ctrl_reg_sel13;        // Select13 for the clk_ctrl_reg13
   input restart13;                 // Restart13 reset from cntr_ctrl_reg13

   // outputs13
   output count_en_out13;
   output [6:0] clk_ctrl_reg_out13; // Controls13 clock13 selected


//-----------------------------------------------------------------------------
// Internal Signals13 & Registers13
//-----------------------------------------------------------------------------


   
   reg [6:0]    clk_ctrl_reg13;     //7-bit clock13 control13 register.
   
   reg          restart_var13;      //ensures13 prescaler13 reset at start of restart13 
   
   reg          count_en13;         //enable signal13 to counter

   
   wire [6:0]   clk_ctrl_reg_out13; //clock13 control13 output wire
   wire         count_en_out13;     //counter enable output
   
   
//-----------------------------------------------------------------------------
// Logic13 Section13:


//
//    p_clk_ctrl13: Process13 to implement the clk_ctrl_reg13.  
//                When13 select13 line is set then13 the data will be inserted13 to 
//                the clock13 control13 register, otherwise13 it will be equal13 to 
//                the previous value of the register, else it will be zero.
//-----------------------------------------------------------------------------

   assign clk_ctrl_reg_out13  = clk_ctrl_reg13;
   assign count_en_out13      = count_en13;


//    p_ps_counter13: counter for clock13 enable generation13.
   
   always @(posedge pclk13 or negedge n_p_reset13)
   begin: p_ps_counter13
      
      if (!n_p_reset13)
      begin
         restart_var13  <= 1'b0;
         count_en13     <= 1'b0;
      end
      else
      begin
         if (restart13 & ~restart_var13)
         begin
            restart_var13  <= 1'b1;
            count_en13     <= 1'b0;
         end 
         
         else 
           begin
              
              if (~restart13)
                 restart_var13 <= 1'b0;
              else
                 restart_var13 <= restart_var13;
                 
              count_en13     <= 1'b1;        
              
           end
      end // else: !if(!n_p_reset13)      
  
   end  //p_ps_counter13



// p_clk_ctrl13 : Process13 for writing to the clk_ctrl_reg13
   
   always @ (posedge pclk13 or negedge n_p_reset13)
   begin: p_clk_ctrl13
      
      if (!n_p_reset13)
         clk_ctrl_reg13 <= 7'h00;
      else
      begin 

         if (clk_ctrl_reg_sel13)
            clk_ctrl_reg13 <= pwdata13;
         else
            clk_ctrl_reg13 <= clk_ctrl_reg13;

      end 
      
   end  //p_clk_ctrl13

   
endmodule
