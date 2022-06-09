//File21 name   : ttc_count_rst_lite21.v
//Title21       : 
//Created21     : 1999
//Description21 : TTC21 counter reset block
//Notes21       : 
//----------------------------------------------------------------------
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------

module ttc_count_rst_lite21(

  //inputs21
  n_p_reset21,                             
  pclk21, 
  pwdata21,                                                           
  clk_ctrl_reg_sel21,
  restart21,        

  //outputs21
  count_en_out21,
  clk_ctrl_reg_out21

  );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS21
//-----------------------------------------------------------------------------

   // inputs21
   input n_p_reset21;                 // Reset21 signal21
   input pclk21;                    // APB21 System21 clock21
   input [6:0] pwdata21;           // 7-Bit21 pwdata21 from APB21 interface
   input clk_ctrl_reg_sel21;        // Select21 for the clk_ctrl_reg21
   input restart21;                 // Restart21 reset from cntr_ctrl_reg21

   // outputs21
   output count_en_out21;
   output [6:0] clk_ctrl_reg_out21; // Controls21 clock21 selected


//-----------------------------------------------------------------------------
// Internal Signals21 & Registers21
//-----------------------------------------------------------------------------


   
   reg [6:0]    clk_ctrl_reg21;     //7-bit clock21 control21 register.
   
   reg          restart_var21;      //ensures21 prescaler21 reset at start of restart21 
   
   reg          count_en21;         //enable signal21 to counter

   
   wire [6:0]   clk_ctrl_reg_out21; //clock21 control21 output wire
   wire         count_en_out21;     //counter enable output
   
   
//-----------------------------------------------------------------------------
// Logic21 Section21:


//
//    p_clk_ctrl21: Process21 to implement the clk_ctrl_reg21.  
//                When21 select21 line is set then21 the data will be inserted21 to 
//                the clock21 control21 register, otherwise21 it will be equal21 to 
//                the previous value of the register, else it will be zero.
//-----------------------------------------------------------------------------

   assign clk_ctrl_reg_out21  = clk_ctrl_reg21;
   assign count_en_out21      = count_en21;


//    p_ps_counter21: counter for clock21 enable generation21.
   
   always @(posedge pclk21 or negedge n_p_reset21)
   begin: p_ps_counter21
      
      if (!n_p_reset21)
      begin
         restart_var21  <= 1'b0;
         count_en21     <= 1'b0;
      end
      else
      begin
         if (restart21 & ~restart_var21)
         begin
            restart_var21  <= 1'b1;
            count_en21     <= 1'b0;
         end 
         
         else 
           begin
              
              if (~restart21)
                 restart_var21 <= 1'b0;
              else
                 restart_var21 <= restart_var21;
                 
              count_en21     <= 1'b1;        
              
           end
      end // else: !if(!n_p_reset21)      
  
   end  //p_ps_counter21



// p_clk_ctrl21 : Process21 for writing to the clk_ctrl_reg21
   
   always @ (posedge pclk21 or negedge n_p_reset21)
   begin: p_clk_ctrl21
      
      if (!n_p_reset21)
         clk_ctrl_reg21 <= 7'h00;
      else
      begin 

         if (clk_ctrl_reg_sel21)
            clk_ctrl_reg21 <= pwdata21;
         else
            clk_ctrl_reg21 <= clk_ctrl_reg21;

      end 
      
   end  //p_clk_ctrl21

   
endmodule
