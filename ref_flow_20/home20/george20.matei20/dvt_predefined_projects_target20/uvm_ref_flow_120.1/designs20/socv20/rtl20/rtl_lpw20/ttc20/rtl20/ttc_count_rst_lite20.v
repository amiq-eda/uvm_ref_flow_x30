//File20 name   : ttc_count_rst_lite20.v
//Title20       : 
//Created20     : 1999
//Description20 : TTC20 counter reset block
//Notes20       : 
//----------------------------------------------------------------------
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------

module ttc_count_rst_lite20(

  //inputs20
  n_p_reset20,                             
  pclk20, 
  pwdata20,                                                           
  clk_ctrl_reg_sel20,
  restart20,        

  //outputs20
  count_en_out20,
  clk_ctrl_reg_out20

  );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS20
//-----------------------------------------------------------------------------

   // inputs20
   input n_p_reset20;                 // Reset20 signal20
   input pclk20;                    // APB20 System20 clock20
   input [6:0] pwdata20;           // 7-Bit20 pwdata20 from APB20 interface
   input clk_ctrl_reg_sel20;        // Select20 for the clk_ctrl_reg20
   input restart20;                 // Restart20 reset from cntr_ctrl_reg20

   // outputs20
   output count_en_out20;
   output [6:0] clk_ctrl_reg_out20; // Controls20 clock20 selected


//-----------------------------------------------------------------------------
// Internal Signals20 & Registers20
//-----------------------------------------------------------------------------


   
   reg [6:0]    clk_ctrl_reg20;     //7-bit clock20 control20 register.
   
   reg          restart_var20;      //ensures20 prescaler20 reset at start of restart20 
   
   reg          count_en20;         //enable signal20 to counter

   
   wire [6:0]   clk_ctrl_reg_out20; //clock20 control20 output wire
   wire         count_en_out20;     //counter enable output
   
   
//-----------------------------------------------------------------------------
// Logic20 Section20:


//
//    p_clk_ctrl20: Process20 to implement the clk_ctrl_reg20.  
//                When20 select20 line is set then20 the data will be inserted20 to 
//                the clock20 control20 register, otherwise20 it will be equal20 to 
//                the previous value of the register, else it will be zero.
//-----------------------------------------------------------------------------

   assign clk_ctrl_reg_out20  = clk_ctrl_reg20;
   assign count_en_out20      = count_en20;


//    p_ps_counter20: counter for clock20 enable generation20.
   
   always @(posedge pclk20 or negedge n_p_reset20)
   begin: p_ps_counter20
      
      if (!n_p_reset20)
      begin
         restart_var20  <= 1'b0;
         count_en20     <= 1'b0;
      end
      else
      begin
         if (restart20 & ~restart_var20)
         begin
            restart_var20  <= 1'b1;
            count_en20     <= 1'b0;
         end 
         
         else 
           begin
              
              if (~restart20)
                 restart_var20 <= 1'b0;
              else
                 restart_var20 <= restart_var20;
                 
              count_en20     <= 1'b1;        
              
           end
      end // else: !if(!n_p_reset20)      
  
   end  //p_ps_counter20



// p_clk_ctrl20 : Process20 for writing to the clk_ctrl_reg20
   
   always @ (posedge pclk20 or negedge n_p_reset20)
   begin: p_clk_ctrl20
      
      if (!n_p_reset20)
         clk_ctrl_reg20 <= 7'h00;
      else
      begin 

         if (clk_ctrl_reg_sel20)
            clk_ctrl_reg20 <= pwdata20;
         else
            clk_ctrl_reg20 <= clk_ctrl_reg20;

      end 
      
   end  //p_clk_ctrl20

   
endmodule
