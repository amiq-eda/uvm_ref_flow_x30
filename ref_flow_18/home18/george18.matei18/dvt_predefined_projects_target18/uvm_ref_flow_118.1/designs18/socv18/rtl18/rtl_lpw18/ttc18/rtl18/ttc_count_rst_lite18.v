//File18 name   : ttc_count_rst_lite18.v
//Title18       : 
//Created18     : 1999
//Description18 : TTC18 counter reset block
//Notes18       : 
//----------------------------------------------------------------------
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------

module ttc_count_rst_lite18(

  //inputs18
  n_p_reset18,                             
  pclk18, 
  pwdata18,                                                           
  clk_ctrl_reg_sel18,
  restart18,        

  //outputs18
  count_en_out18,
  clk_ctrl_reg_out18

  );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS18
//-----------------------------------------------------------------------------

   // inputs18
   input n_p_reset18;                 // Reset18 signal18
   input pclk18;                    // APB18 System18 clock18
   input [6:0] pwdata18;           // 7-Bit18 pwdata18 from APB18 interface
   input clk_ctrl_reg_sel18;        // Select18 for the clk_ctrl_reg18
   input restart18;                 // Restart18 reset from cntr_ctrl_reg18

   // outputs18
   output count_en_out18;
   output [6:0] clk_ctrl_reg_out18; // Controls18 clock18 selected


//-----------------------------------------------------------------------------
// Internal Signals18 & Registers18
//-----------------------------------------------------------------------------


   
   reg [6:0]    clk_ctrl_reg18;     //7-bit clock18 control18 register.
   
   reg          restart_var18;      //ensures18 prescaler18 reset at start of restart18 
   
   reg          count_en18;         //enable signal18 to counter

   
   wire [6:0]   clk_ctrl_reg_out18; //clock18 control18 output wire
   wire         count_en_out18;     //counter enable output
   
   
//-----------------------------------------------------------------------------
// Logic18 Section18:


//
//    p_clk_ctrl18: Process18 to implement the clk_ctrl_reg18.  
//                When18 select18 line is set then18 the data will be inserted18 to 
//                the clock18 control18 register, otherwise18 it will be equal18 to 
//                the previous value of the register, else it will be zero.
//-----------------------------------------------------------------------------

   assign clk_ctrl_reg_out18  = clk_ctrl_reg18;
   assign count_en_out18      = count_en18;


//    p_ps_counter18: counter for clock18 enable generation18.
   
   always @(posedge pclk18 or negedge n_p_reset18)
   begin: p_ps_counter18
      
      if (!n_p_reset18)
      begin
         restart_var18  <= 1'b0;
         count_en18     <= 1'b0;
      end
      else
      begin
         if (restart18 & ~restart_var18)
         begin
            restart_var18  <= 1'b1;
            count_en18     <= 1'b0;
         end 
         
         else 
           begin
              
              if (~restart18)
                 restart_var18 <= 1'b0;
              else
                 restart_var18 <= restart_var18;
                 
              count_en18     <= 1'b1;        
              
           end
      end // else: !if(!n_p_reset18)      
  
   end  //p_ps_counter18



// p_clk_ctrl18 : Process18 for writing to the clk_ctrl_reg18
   
   always @ (posedge pclk18 or negedge n_p_reset18)
   begin: p_clk_ctrl18
      
      if (!n_p_reset18)
         clk_ctrl_reg18 <= 7'h00;
      else
      begin 

         if (clk_ctrl_reg_sel18)
            clk_ctrl_reg18 <= pwdata18;
         else
            clk_ctrl_reg18 <= clk_ctrl_reg18;

      end 
      
   end  //p_clk_ctrl18

   
endmodule
