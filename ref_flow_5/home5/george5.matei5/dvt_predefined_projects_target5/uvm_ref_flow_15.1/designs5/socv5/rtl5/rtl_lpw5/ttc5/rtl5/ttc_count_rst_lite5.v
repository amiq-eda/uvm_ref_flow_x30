//File5 name   : ttc_count_rst_lite5.v
//Title5       : 
//Created5     : 1999
//Description5 : TTC5 counter reset block
//Notes5       : 
//----------------------------------------------------------------------
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------

module ttc_count_rst_lite5(

  //inputs5
  n_p_reset5,                             
  pclk5, 
  pwdata5,                                                           
  clk_ctrl_reg_sel5,
  restart5,        

  //outputs5
  count_en_out5,
  clk_ctrl_reg_out5

  );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS5
//-----------------------------------------------------------------------------

   // inputs5
   input n_p_reset5;                 // Reset5 signal5
   input pclk5;                    // APB5 System5 clock5
   input [6:0] pwdata5;           // 7-Bit5 pwdata5 from APB5 interface
   input clk_ctrl_reg_sel5;        // Select5 for the clk_ctrl_reg5
   input restart5;                 // Restart5 reset from cntr_ctrl_reg5

   // outputs5
   output count_en_out5;
   output [6:0] clk_ctrl_reg_out5; // Controls5 clock5 selected


//-----------------------------------------------------------------------------
// Internal Signals5 & Registers5
//-----------------------------------------------------------------------------


   
   reg [6:0]    clk_ctrl_reg5;     //7-bit clock5 control5 register.
   
   reg          restart_var5;      //ensures5 prescaler5 reset at start of restart5 
   
   reg          count_en5;         //enable signal5 to counter

   
   wire [6:0]   clk_ctrl_reg_out5; //clock5 control5 output wire
   wire         count_en_out5;     //counter enable output
   
   
//-----------------------------------------------------------------------------
// Logic5 Section5:


//
//    p_clk_ctrl5: Process5 to implement the clk_ctrl_reg5.  
//                When5 select5 line is set then5 the data will be inserted5 to 
//                the clock5 control5 register, otherwise5 it will be equal5 to 
//                the previous value of the register, else it will be zero.
//-----------------------------------------------------------------------------

   assign clk_ctrl_reg_out5  = clk_ctrl_reg5;
   assign count_en_out5      = count_en5;


//    p_ps_counter5: counter for clock5 enable generation5.
   
   always @(posedge pclk5 or negedge n_p_reset5)
   begin: p_ps_counter5
      
      if (!n_p_reset5)
      begin
         restart_var5  <= 1'b0;
         count_en5     <= 1'b0;
      end
      else
      begin
         if (restart5 & ~restart_var5)
         begin
            restart_var5  <= 1'b1;
            count_en5     <= 1'b0;
         end 
         
         else 
           begin
              
              if (~restart5)
                 restart_var5 <= 1'b0;
              else
                 restart_var5 <= restart_var5;
                 
              count_en5     <= 1'b1;        
              
           end
      end // else: !if(!n_p_reset5)      
  
   end  //p_ps_counter5



// p_clk_ctrl5 : Process5 for writing to the clk_ctrl_reg5
   
   always @ (posedge pclk5 or negedge n_p_reset5)
   begin: p_clk_ctrl5
      
      if (!n_p_reset5)
         clk_ctrl_reg5 <= 7'h00;
      else
      begin 

         if (clk_ctrl_reg_sel5)
            clk_ctrl_reg5 <= pwdata5;
         else
            clk_ctrl_reg5 <= clk_ctrl_reg5;

      end 
      
   end  //p_clk_ctrl5

   
endmodule
