//File7 name   : ttc_count_rst_lite7.v
//Title7       : 
//Created7     : 1999
//Description7 : TTC7 counter reset block
//Notes7       : 
//----------------------------------------------------------------------
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------

module ttc_count_rst_lite7(

  //inputs7
  n_p_reset7,                             
  pclk7, 
  pwdata7,                                                           
  clk_ctrl_reg_sel7,
  restart7,        

  //outputs7
  count_en_out7,
  clk_ctrl_reg_out7

  );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS7
//-----------------------------------------------------------------------------

   // inputs7
   input n_p_reset7;                 // Reset7 signal7
   input pclk7;                    // APB7 System7 clock7
   input [6:0] pwdata7;           // 7-Bit7 pwdata7 from APB7 interface
   input clk_ctrl_reg_sel7;        // Select7 for the clk_ctrl_reg7
   input restart7;                 // Restart7 reset from cntr_ctrl_reg7

   // outputs7
   output count_en_out7;
   output [6:0] clk_ctrl_reg_out7; // Controls7 clock7 selected


//-----------------------------------------------------------------------------
// Internal Signals7 & Registers7
//-----------------------------------------------------------------------------


   
   reg [6:0]    clk_ctrl_reg7;     //7-bit clock7 control7 register.
   
   reg          restart_var7;      //ensures7 prescaler7 reset at start of restart7 
   
   reg          count_en7;         //enable signal7 to counter

   
   wire [6:0]   clk_ctrl_reg_out7; //clock7 control7 output wire
   wire         count_en_out7;     //counter enable output
   
   
//-----------------------------------------------------------------------------
// Logic7 Section7:


//
//    p_clk_ctrl7: Process7 to implement the clk_ctrl_reg7.  
//                When7 select7 line is set then7 the data will be inserted7 to 
//                the clock7 control7 register, otherwise7 it will be equal7 to 
//                the previous value of the register, else it will be zero.
//-----------------------------------------------------------------------------

   assign clk_ctrl_reg_out7  = clk_ctrl_reg7;
   assign count_en_out7      = count_en7;


//    p_ps_counter7: counter for clock7 enable generation7.
   
   always @(posedge pclk7 or negedge n_p_reset7)
   begin: p_ps_counter7
      
      if (!n_p_reset7)
      begin
         restart_var7  <= 1'b0;
         count_en7     <= 1'b0;
      end
      else
      begin
         if (restart7 & ~restart_var7)
         begin
            restart_var7  <= 1'b1;
            count_en7     <= 1'b0;
         end 
         
         else 
           begin
              
              if (~restart7)
                 restart_var7 <= 1'b0;
              else
                 restart_var7 <= restart_var7;
                 
              count_en7     <= 1'b1;        
              
           end
      end // else: !if(!n_p_reset7)      
  
   end  //p_ps_counter7



// p_clk_ctrl7 : Process7 for writing to the clk_ctrl_reg7
   
   always @ (posedge pclk7 or negedge n_p_reset7)
   begin: p_clk_ctrl7
      
      if (!n_p_reset7)
         clk_ctrl_reg7 <= 7'h00;
      else
      begin 

         if (clk_ctrl_reg_sel7)
            clk_ctrl_reg7 <= pwdata7;
         else
            clk_ctrl_reg7 <= clk_ctrl_reg7;

      end 
      
   end  //p_clk_ctrl7

   
endmodule
