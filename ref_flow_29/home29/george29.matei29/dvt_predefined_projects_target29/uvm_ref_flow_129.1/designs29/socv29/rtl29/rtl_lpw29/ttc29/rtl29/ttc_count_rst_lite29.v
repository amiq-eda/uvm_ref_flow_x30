//File29 name   : ttc_count_rst_lite29.v
//Title29       : 
//Created29     : 1999
//Description29 : TTC29 counter reset block
//Notes29       : 
//----------------------------------------------------------------------
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------

module ttc_count_rst_lite29(

  //inputs29
  n_p_reset29,                             
  pclk29, 
  pwdata29,                                                           
  clk_ctrl_reg_sel29,
  restart29,        

  //outputs29
  count_en_out29,
  clk_ctrl_reg_out29

  );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS29
//-----------------------------------------------------------------------------

   // inputs29
   input n_p_reset29;                 // Reset29 signal29
   input pclk29;                    // APB29 System29 clock29
   input [6:0] pwdata29;           // 7-Bit29 pwdata29 from APB29 interface
   input clk_ctrl_reg_sel29;        // Select29 for the clk_ctrl_reg29
   input restart29;                 // Restart29 reset from cntr_ctrl_reg29

   // outputs29
   output count_en_out29;
   output [6:0] clk_ctrl_reg_out29; // Controls29 clock29 selected


//-----------------------------------------------------------------------------
// Internal Signals29 & Registers29
//-----------------------------------------------------------------------------


   
   reg [6:0]    clk_ctrl_reg29;     //7-bit clock29 control29 register.
   
   reg          restart_var29;      //ensures29 prescaler29 reset at start of restart29 
   
   reg          count_en29;         //enable signal29 to counter

   
   wire [6:0]   clk_ctrl_reg_out29; //clock29 control29 output wire
   wire         count_en_out29;     //counter enable output
   
   
//-----------------------------------------------------------------------------
// Logic29 Section29:


//
//    p_clk_ctrl29: Process29 to implement the clk_ctrl_reg29.  
//                When29 select29 line is set then29 the data will be inserted29 to 
//                the clock29 control29 register, otherwise29 it will be equal29 to 
//                the previous value of the register, else it will be zero.
//-----------------------------------------------------------------------------

   assign clk_ctrl_reg_out29  = clk_ctrl_reg29;
   assign count_en_out29      = count_en29;


//    p_ps_counter29: counter for clock29 enable generation29.
   
   always @(posedge pclk29 or negedge n_p_reset29)
   begin: p_ps_counter29
      
      if (!n_p_reset29)
      begin
         restart_var29  <= 1'b0;
         count_en29     <= 1'b0;
      end
      else
      begin
         if (restart29 & ~restart_var29)
         begin
            restart_var29  <= 1'b1;
            count_en29     <= 1'b0;
         end 
         
         else 
           begin
              
              if (~restart29)
                 restart_var29 <= 1'b0;
              else
                 restart_var29 <= restart_var29;
                 
              count_en29     <= 1'b1;        
              
           end
      end // else: !if(!n_p_reset29)      
  
   end  //p_ps_counter29



// p_clk_ctrl29 : Process29 for writing to the clk_ctrl_reg29
   
   always @ (posedge pclk29 or negedge n_p_reset29)
   begin: p_clk_ctrl29
      
      if (!n_p_reset29)
         clk_ctrl_reg29 <= 7'h00;
      else
      begin 

         if (clk_ctrl_reg_sel29)
            clk_ctrl_reg29 <= pwdata29;
         else
            clk_ctrl_reg29 <= clk_ctrl_reg29;

      end 
      
   end  //p_clk_ctrl29

   
endmodule
