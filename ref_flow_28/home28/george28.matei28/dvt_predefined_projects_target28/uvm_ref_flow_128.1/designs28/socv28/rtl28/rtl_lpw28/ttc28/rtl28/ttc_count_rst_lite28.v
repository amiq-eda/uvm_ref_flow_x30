//File28 name   : ttc_count_rst_lite28.v
//Title28       : 
//Created28     : 1999
//Description28 : TTC28 counter reset block
//Notes28       : 
//----------------------------------------------------------------------
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------

module ttc_count_rst_lite28(

  //inputs28
  n_p_reset28,                             
  pclk28, 
  pwdata28,                                                           
  clk_ctrl_reg_sel28,
  restart28,        

  //outputs28
  count_en_out28,
  clk_ctrl_reg_out28

  );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS28
//-----------------------------------------------------------------------------

   // inputs28
   input n_p_reset28;                 // Reset28 signal28
   input pclk28;                    // APB28 System28 clock28
   input [6:0] pwdata28;           // 7-Bit28 pwdata28 from APB28 interface
   input clk_ctrl_reg_sel28;        // Select28 for the clk_ctrl_reg28
   input restart28;                 // Restart28 reset from cntr_ctrl_reg28

   // outputs28
   output count_en_out28;
   output [6:0] clk_ctrl_reg_out28; // Controls28 clock28 selected


//-----------------------------------------------------------------------------
// Internal Signals28 & Registers28
//-----------------------------------------------------------------------------


   
   reg [6:0]    clk_ctrl_reg28;     //7-bit clock28 control28 register.
   
   reg          restart_var28;      //ensures28 prescaler28 reset at start of restart28 
   
   reg          count_en28;         //enable signal28 to counter

   
   wire [6:0]   clk_ctrl_reg_out28; //clock28 control28 output wire
   wire         count_en_out28;     //counter enable output
   
   
//-----------------------------------------------------------------------------
// Logic28 Section28:


//
//    p_clk_ctrl28: Process28 to implement the clk_ctrl_reg28.  
//                When28 select28 line is set then28 the data will be inserted28 to 
//                the clock28 control28 register, otherwise28 it will be equal28 to 
//                the previous value of the register, else it will be zero.
//-----------------------------------------------------------------------------

   assign clk_ctrl_reg_out28  = clk_ctrl_reg28;
   assign count_en_out28      = count_en28;


//    p_ps_counter28: counter for clock28 enable generation28.
   
   always @(posedge pclk28 or negedge n_p_reset28)
   begin: p_ps_counter28
      
      if (!n_p_reset28)
      begin
         restart_var28  <= 1'b0;
         count_en28     <= 1'b0;
      end
      else
      begin
         if (restart28 & ~restart_var28)
         begin
            restart_var28  <= 1'b1;
            count_en28     <= 1'b0;
         end 
         
         else 
           begin
              
              if (~restart28)
                 restart_var28 <= 1'b0;
              else
                 restart_var28 <= restart_var28;
                 
              count_en28     <= 1'b1;        
              
           end
      end // else: !if(!n_p_reset28)      
  
   end  //p_ps_counter28



// p_clk_ctrl28 : Process28 for writing to the clk_ctrl_reg28
   
   always @ (posedge pclk28 or negedge n_p_reset28)
   begin: p_clk_ctrl28
      
      if (!n_p_reset28)
         clk_ctrl_reg28 <= 7'h00;
      else
      begin 

         if (clk_ctrl_reg_sel28)
            clk_ctrl_reg28 <= pwdata28;
         else
            clk_ctrl_reg28 <= clk_ctrl_reg28;

      end 
      
   end  //p_clk_ctrl28

   
endmodule
