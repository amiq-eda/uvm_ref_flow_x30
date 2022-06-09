//File11 name   : ttc_count_rst_lite11.v
//Title11       : 
//Created11     : 1999
//Description11 : TTC11 counter reset block
//Notes11       : 
//----------------------------------------------------------------------
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------

module ttc_count_rst_lite11(

  //inputs11
  n_p_reset11,                             
  pclk11, 
  pwdata11,                                                           
  clk_ctrl_reg_sel11,
  restart11,        

  //outputs11
  count_en_out11,
  clk_ctrl_reg_out11

  );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS11
//-----------------------------------------------------------------------------

   // inputs11
   input n_p_reset11;                 // Reset11 signal11
   input pclk11;                    // APB11 System11 clock11
   input [6:0] pwdata11;           // 7-Bit11 pwdata11 from APB11 interface
   input clk_ctrl_reg_sel11;        // Select11 for the clk_ctrl_reg11
   input restart11;                 // Restart11 reset from cntr_ctrl_reg11

   // outputs11
   output count_en_out11;
   output [6:0] clk_ctrl_reg_out11; // Controls11 clock11 selected


//-----------------------------------------------------------------------------
// Internal Signals11 & Registers11
//-----------------------------------------------------------------------------


   
   reg [6:0]    clk_ctrl_reg11;     //7-bit clock11 control11 register.
   
   reg          restart_var11;      //ensures11 prescaler11 reset at start of restart11 
   
   reg          count_en11;         //enable signal11 to counter

   
   wire [6:0]   clk_ctrl_reg_out11; //clock11 control11 output wire
   wire         count_en_out11;     //counter enable output
   
   
//-----------------------------------------------------------------------------
// Logic11 Section11:


//
//    p_clk_ctrl11: Process11 to implement the clk_ctrl_reg11.  
//                When11 select11 line is set then11 the data will be inserted11 to 
//                the clock11 control11 register, otherwise11 it will be equal11 to 
//                the previous value of the register, else it will be zero.
//-----------------------------------------------------------------------------

   assign clk_ctrl_reg_out11  = clk_ctrl_reg11;
   assign count_en_out11      = count_en11;


//    p_ps_counter11: counter for clock11 enable generation11.
   
   always @(posedge pclk11 or negedge n_p_reset11)
   begin: p_ps_counter11
      
      if (!n_p_reset11)
      begin
         restart_var11  <= 1'b0;
         count_en11     <= 1'b0;
      end
      else
      begin
         if (restart11 & ~restart_var11)
         begin
            restart_var11  <= 1'b1;
            count_en11     <= 1'b0;
         end 
         
         else 
           begin
              
              if (~restart11)
                 restart_var11 <= 1'b0;
              else
                 restart_var11 <= restart_var11;
                 
              count_en11     <= 1'b1;        
              
           end
      end // else: !if(!n_p_reset11)      
  
   end  //p_ps_counter11



// p_clk_ctrl11 : Process11 for writing to the clk_ctrl_reg11
   
   always @ (posedge pclk11 or negedge n_p_reset11)
   begin: p_clk_ctrl11
      
      if (!n_p_reset11)
         clk_ctrl_reg11 <= 7'h00;
      else
      begin 

         if (clk_ctrl_reg_sel11)
            clk_ctrl_reg11 <= pwdata11;
         else
            clk_ctrl_reg11 <= clk_ctrl_reg11;

      end 
      
   end  //p_clk_ctrl11

   
endmodule
