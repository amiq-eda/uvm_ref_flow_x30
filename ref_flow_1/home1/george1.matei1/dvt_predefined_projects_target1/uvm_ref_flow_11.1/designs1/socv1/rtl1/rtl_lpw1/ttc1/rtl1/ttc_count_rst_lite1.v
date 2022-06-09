//File1 name   : ttc_count_rst_lite1.v
//Title1       : 
//Created1     : 1999
//Description1 : TTC1 counter reset block
//Notes1       : 
//----------------------------------------------------------------------
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------

module ttc_count_rst_lite1(

  //inputs1
  n_p_reset1,                             
  pclk1, 
  pwdata1,                                                           
  clk_ctrl_reg_sel1,
  restart1,        

  //outputs1
  count_en_out1,
  clk_ctrl_reg_out1

  );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS1
//-----------------------------------------------------------------------------

   // inputs1
   input n_p_reset1;                 // Reset1 signal1
   input pclk1;                    // APB1 System1 clock1
   input [6:0] pwdata1;           // 7-Bit1 pwdata1 from APB1 interface
   input clk_ctrl_reg_sel1;        // Select1 for the clk_ctrl_reg1
   input restart1;                 // Restart1 reset from cntr_ctrl_reg1

   // outputs1
   output count_en_out1;
   output [6:0] clk_ctrl_reg_out1; // Controls1 clock1 selected


//-----------------------------------------------------------------------------
// Internal Signals1 & Registers1
//-----------------------------------------------------------------------------


   
   reg [6:0]    clk_ctrl_reg1;     //7-bit clock1 control1 register.
   
   reg          restart_var1;      //ensures1 prescaler1 reset at start of restart1 
   
   reg          count_en1;         //enable signal1 to counter

   
   wire [6:0]   clk_ctrl_reg_out1; //clock1 control1 output wire
   wire         count_en_out1;     //counter enable output
   
   
//-----------------------------------------------------------------------------
// Logic1 Section1:


//
//    p_clk_ctrl1: Process1 to implement the clk_ctrl_reg1.  
//                When1 select1 line is set then1 the data will be inserted1 to 
//                the clock1 control1 register, otherwise1 it will be equal1 to 
//                the previous value of the register, else it will be zero.
//-----------------------------------------------------------------------------

   assign clk_ctrl_reg_out1  = clk_ctrl_reg1;
   assign count_en_out1      = count_en1;


//    p_ps_counter1: counter for clock1 enable generation1.
   
   always @(posedge pclk1 or negedge n_p_reset1)
   begin: p_ps_counter1
      
      if (!n_p_reset1)
      begin
         restart_var1  <= 1'b0;
         count_en1     <= 1'b0;
      end
      else
      begin
         if (restart1 & ~restart_var1)
         begin
            restart_var1  <= 1'b1;
            count_en1     <= 1'b0;
         end 
         
         else 
           begin
              
              if (~restart1)
                 restart_var1 <= 1'b0;
              else
                 restart_var1 <= restart_var1;
                 
              count_en1     <= 1'b1;        
              
           end
      end // else: !if(!n_p_reset1)      
  
   end  //p_ps_counter1



// p_clk_ctrl1 : Process1 for writing to the clk_ctrl_reg1
   
   always @ (posedge pclk1 or negedge n_p_reset1)
   begin: p_clk_ctrl1
      
      if (!n_p_reset1)
         clk_ctrl_reg1 <= 7'h00;
      else
      begin 

         if (clk_ctrl_reg_sel1)
            clk_ctrl_reg1 <= pwdata1;
         else
            clk_ctrl_reg1 <= clk_ctrl_reg1;

      end 
      
   end  //p_clk_ctrl1

   
endmodule
