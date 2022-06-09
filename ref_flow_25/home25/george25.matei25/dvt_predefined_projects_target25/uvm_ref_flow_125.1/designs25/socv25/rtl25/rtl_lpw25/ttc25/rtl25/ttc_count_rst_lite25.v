//File25 name   : ttc_count_rst_lite25.v
//Title25       : 
//Created25     : 1999
//Description25 : TTC25 counter reset block
//Notes25       : 
//----------------------------------------------------------------------
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------

module ttc_count_rst_lite25(

  //inputs25
  n_p_reset25,                             
  pclk25, 
  pwdata25,                                                           
  clk_ctrl_reg_sel25,
  restart25,        

  //outputs25
  count_en_out25,
  clk_ctrl_reg_out25

  );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS25
//-----------------------------------------------------------------------------

   // inputs25
   input n_p_reset25;                 // Reset25 signal25
   input pclk25;                    // APB25 System25 clock25
   input [6:0] pwdata25;           // 7-Bit25 pwdata25 from APB25 interface
   input clk_ctrl_reg_sel25;        // Select25 for the clk_ctrl_reg25
   input restart25;                 // Restart25 reset from cntr_ctrl_reg25

   // outputs25
   output count_en_out25;
   output [6:0] clk_ctrl_reg_out25; // Controls25 clock25 selected


//-----------------------------------------------------------------------------
// Internal Signals25 & Registers25
//-----------------------------------------------------------------------------


   
   reg [6:0]    clk_ctrl_reg25;     //7-bit clock25 control25 register.
   
   reg          restart_var25;      //ensures25 prescaler25 reset at start of restart25 
   
   reg          count_en25;         //enable signal25 to counter

   
   wire [6:0]   clk_ctrl_reg_out25; //clock25 control25 output wire
   wire         count_en_out25;     //counter enable output
   
   
//-----------------------------------------------------------------------------
// Logic25 Section25:


//
//    p_clk_ctrl25: Process25 to implement the clk_ctrl_reg25.  
//                When25 select25 line is set then25 the data will be inserted25 to 
//                the clock25 control25 register, otherwise25 it will be equal25 to 
//                the previous value of the register, else it will be zero.
//-----------------------------------------------------------------------------

   assign clk_ctrl_reg_out25  = clk_ctrl_reg25;
   assign count_en_out25      = count_en25;


//    p_ps_counter25: counter for clock25 enable generation25.
   
   always @(posedge pclk25 or negedge n_p_reset25)
   begin: p_ps_counter25
      
      if (!n_p_reset25)
      begin
         restart_var25  <= 1'b0;
         count_en25     <= 1'b0;
      end
      else
      begin
         if (restart25 & ~restart_var25)
         begin
            restart_var25  <= 1'b1;
            count_en25     <= 1'b0;
         end 
         
         else 
           begin
              
              if (~restart25)
                 restart_var25 <= 1'b0;
              else
                 restart_var25 <= restart_var25;
                 
              count_en25     <= 1'b1;        
              
           end
      end // else: !if(!n_p_reset25)      
  
   end  //p_ps_counter25



// p_clk_ctrl25 : Process25 for writing to the clk_ctrl_reg25
   
   always @ (posedge pclk25 or negedge n_p_reset25)
   begin: p_clk_ctrl25
      
      if (!n_p_reset25)
         clk_ctrl_reg25 <= 7'h00;
      else
      begin 

         if (clk_ctrl_reg_sel25)
            clk_ctrl_reg25 <= pwdata25;
         else
            clk_ctrl_reg25 <= clk_ctrl_reg25;

      end 
      
   end  //p_clk_ctrl25

   
endmodule
