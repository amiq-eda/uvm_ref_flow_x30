//File4 name   : alut_age_checker4.v
//Title4       : 
//Created4     : 1999
//Description4 : 
//Notes4       : 
//----------------------------------------------------------------------
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------

module alut_age_checker4
(   
   // Inputs4
   pclk4,
   n_p_reset4,
   command,          
   div_clk4,          
   mem_read_data_age4,
   check_age4,        
   last_accessed4, 
   best_bfr_age4,   
   add_check_active4,

   // outputs4
   curr_time4,         
   mem_addr_age4,      
   mem_write_age4,     
   mem_write_data_age4,
   lst_inv_addr_cmd4,    
   lst_inv_port_cmd4,  
   age_confirmed4,     
   age_ok4,
   inval_in_prog4,  
   age_check_active4          
);   

   input               pclk4;               // APB4 clock4                           
   input               n_p_reset4;          // Reset4                               
   input [1:0]         command;            // command bus                        
   input [7:0]         div_clk4;            // clock4 divider4 value
   input [82:0]        mem_read_data_age4;  // read data from memory             
   input               check_age4;          // request flag4 for age4 check
   input [31:0]        last_accessed4;      // time field sent4 for age4 check
   input [31:0]        best_bfr_age4;       // best4 before age4
   input               add_check_active4;   // active flag4 from address checker

   output [31:0]       curr_time4;          // current time,for storing4 in mem    
   output [7:0]        mem_addr_age4;       // address for R/W4 to memory     
   output              mem_write_age4;      // R/W4 flag4 (write = high4)            
   output [82:0]       mem_write_data_age4; // write data for memory             
   output [47:0]       lst_inv_addr_cmd4;   // last invalidated4 addr normal4 op    
   output [1:0]        lst_inv_port_cmd4;   // last invalidated4 port normal4 op    
   output              age_confirmed4;      // validates4 age_ok4 result 
   output              age_ok4;             // age4 checker result - set means4 in-date4
   output              inval_in_prog4;      // invalidation4 in progress4
   output              age_check_active4;   // bit 0 of status register           

   reg  [2:0]          age_chk_state4;      // age4 checker FSM4 current state
   reg  [2:0]          nxt_age_chk_state4;  // age4 checker FSM4 next state
   reg  [7:0]          mem_addr_age4;     
   reg                 mem_write_age4;    
   reg                 inval_in_prog4;      // invalidation4 in progress4
   reg  [7:0]          clk_div_cnt4;        // clock4 divider4 counter
   reg  [31:0]         curr_time4;          // current time,for storing4 in mem  
   reg                 age_confirmed4;      // validates4 age_ok4 result 
   reg                 age_ok4;             // age4 checker result - set means4 in-date4
   reg [47:0]          lst_inv_addr_cmd4;   // last invalidated4 addr normal4 op    
   reg [1:0]           lst_inv_port_cmd4;   // last invalidated4 port normal4 op    

   wire  [82:0]        mem_write_data_age4;
   wire  [31:0]        last_accessed_age4;  // read back time by age4 checker
   wire  [31:0]        time_since_lst_acc_age4;  // time since4 last accessed age4
   wire  [31:0]        time_since_lst_acc4; // time since4 last accessed address
   wire                age_check_active4;   // bit 0 of status register           

// Parameters4 for Address Checking4 FSM4 states4
   parameter idle4           = 3'b000;
   parameter inval_aged_rd4  = 3'b001;
   parameter inval_aged_wr4  = 3'b010;
   parameter inval_all4      = 3'b011;
   parameter age_chk4        = 3'b100;

   parameter max_addr       = 8'hff;
   parameter max_cnt4        = 32'hffff_ffff;

// -----------------------------------------------------------------------------
//   Generate4 current time counter
// -----------------------------------------------------------------------------
always @ (posedge pclk4 or negedge n_p_reset4)
   begin
   if (~n_p_reset4)
      clk_div_cnt4 <= 8'd0;
   else if (clk_div_cnt4 == div_clk4)
      clk_div_cnt4 <= 8'd0; 
   else 
      clk_div_cnt4 <= clk_div_cnt4 + 1'd1;
   end


always @ (posedge pclk4 or negedge n_p_reset4)
   begin
   if (~n_p_reset4)
      curr_time4 <= 32'd0;
   else if (clk_div_cnt4 == div_clk4)
      curr_time4 <= curr_time4 + 1'd1;
   end


// -----------------------------------------------------------------------------
//   Age4 checker State4 Machine4 
// -----------------------------------------------------------------------------
always @ (command or check_age4 or age_chk_state4 or age_confirmed4 or age_ok4 or
          mem_addr_age4 or mem_read_data_age4[82])
   begin
      case (age_chk_state4)
      
      idle4:
         if (command == 2'b10)
            nxt_age_chk_state4 = inval_aged_rd4;
         else if (command == 2'b11)
            nxt_age_chk_state4 = inval_all4;
         else if (check_age4)
            nxt_age_chk_state4 = age_chk4;
         else
            nxt_age_chk_state4 = idle4;

      inval_aged_rd4:
            nxt_age_chk_state4 = age_chk4;

      inval_aged_wr4:
            nxt_age_chk_state4 = idle4;

      inval_all4:
         if (mem_addr_age4 != max_addr)
            nxt_age_chk_state4 = inval_all4;  // move4 onto4 next address
         else
            nxt_age_chk_state4 = idle4;

      age_chk4:
         if (age_confirmed4)
            begin
            if (add_check_active4)                     // age4 check for addr chkr4
               nxt_age_chk_state4 = idle4;
            else if (~mem_read_data_age4[82])      // invalid, check next location4
               nxt_age_chk_state4 = inval_aged_rd4; 
            else if (~age_ok4 & mem_read_data_age4[82]) // out of date4, clear 
               nxt_age_chk_state4 = inval_aged_wr4;
            else if (mem_addr_age4 == max_addr)    // full check completed
               nxt_age_chk_state4 = idle4;     
            else 
               nxt_age_chk_state4 = inval_aged_rd4; // age4 ok, check next location4 
            end       
         else
            nxt_age_chk_state4 = age_chk4;

      default:
            nxt_age_chk_state4 = idle4;
      endcase
   end



always @ (posedge pclk4 or negedge n_p_reset4)
   begin
   if (~n_p_reset4)
      age_chk_state4 <= idle4;
   else
      age_chk_state4 <= nxt_age_chk_state4;
   end


// -----------------------------------------------------------------------------
//   Generate4 memory RW bus for accessing array when requested4 to invalidate4 all
//   aged4 addresses4 and all addresses4.
// -----------------------------------------------------------------------------
always @ (posedge pclk4 or negedge n_p_reset4)
   begin
   if (~n_p_reset4)
   begin
      mem_addr_age4 <= 8'd0;     
      mem_write_age4 <= 1'd0;    
   end
   else if (age_chk_state4 == inval_aged_rd4)  // invalidate4 aged4 read
   begin
      mem_addr_age4 <= mem_addr_age4 + 1'd1;     
      mem_write_age4 <= 1'd0;    
   end
   else if (age_chk_state4 == inval_aged_wr4)  // invalidate4 aged4 read
   begin
      mem_addr_age4 <= mem_addr_age4;     
      mem_write_age4 <= 1'd1;    
   end
   else if (age_chk_state4 == inval_all4)  // invalidate4 all
   begin
      mem_addr_age4 <= mem_addr_age4 + 1'd1;     
      mem_write_age4 <= 1'd1;    
   end
   else if (age_chk_state4 == age_chk4)
   begin
      mem_addr_age4 <= mem_addr_age4;     
      mem_write_age4 <= mem_write_age4;    
   end
   else 
   begin
      mem_addr_age4 <= mem_addr_age4;     
      mem_write_age4 <= 1'd0;    
   end
   end

// age4 checker will only ever4 write zero values to ALUT4 mem
assign mem_write_data_age4 = 83'd0;



// -----------------------------------------------------------------------------
//   Generate4 invalidate4 in progress4 flag4 (bit 1 of status register)
// -----------------------------------------------------------------------------
always @ (posedge pclk4 or negedge n_p_reset4)
   begin
   if (~n_p_reset4)
      inval_in_prog4 <= 1'd0;
   else if (age_chk_state4 == inval_aged_wr4) 
      inval_in_prog4 <= 1'd1;
   else if ((age_chk_state4 == age_chk4) & (mem_addr_age4 == max_addr))
      inval_in_prog4 <= 1'd0;
   else
      inval_in_prog4 <= inval_in_prog4;
   end


// -----------------------------------------------------------------------------
//   Calculate4 whether4 data is still in date4.  Need4 to work4 out the real time
//   gap4 between current time and last accessed.  If4 this gap4 is greater than
//   the best4 before age4, then4 the data is out of date4. 
// -----------------------------------------------------------------------------
assign time_since_lst_acc4 = (curr_time4 > last_accessed4) ? 
                            (curr_time4 - last_accessed4) :  // no cnt wrapping4
                            (curr_time4 + (max_cnt4 - last_accessed4));

assign time_since_lst_acc_age4 = (curr_time4 > last_accessed_age4) ? 
                                (curr_time4 - last_accessed_age4) : // no wrapping4
                                (curr_time4 + (max_cnt4 - last_accessed_age4));


always @ (posedge pclk4 or negedge n_p_reset4)
   begin
   if (~n_p_reset4)
      begin
      age_ok4 <= 1'b0;
      age_confirmed4 <= 1'b0;
      end
   else if ((age_chk_state4 == age_chk4) & add_check_active4) 
      begin                                       // age4 checking for addr chkr4
      if (best_bfr_age4 > time_since_lst_acc4)      // still in date4
         begin
         age_ok4 <= 1'b1;
         age_confirmed4 <= 1'b1;
         end
      else   // out of date4
         begin
         age_ok4 <= 1'b0;
         age_confirmed4 <= 1'b1;
         end
      end
   else if ((age_chk_state4 == age_chk4) & ~add_check_active4)
      begin                                      // age4 checking for inval4 aged4
      if (best_bfr_age4 > time_since_lst_acc_age4) // still in date4
         begin
         age_ok4 <= 1'b1;
         age_confirmed4 <= 1'b1;
         end
      else   // out of date4
         begin
         age_ok4 <= 1'b0;
         age_confirmed4 <= 1'b1;
         end
      end
   else
      begin
      age_ok4 <= 1'b0;
      age_confirmed4 <= 1'b0;
      end
   end



// -----------------------------------------------------------------------------
//   Generate4 last address and port that was cleared4 in the invalid aged4 process
// -----------------------------------------------------------------------------
always @ (posedge pclk4 or negedge n_p_reset4)
   begin
   if (~n_p_reset4)
      begin
      lst_inv_addr_cmd4 <= 48'd0;
      lst_inv_port_cmd4 <= 2'd0;
      end
   else if (age_chk_state4 == inval_aged_wr4)
      begin
      lst_inv_addr_cmd4 <= mem_read_data_age4[47:0];
      lst_inv_port_cmd4 <= mem_read_data_age4[49:48];
      end
   else 
      begin
      lst_inv_addr_cmd4 <= lst_inv_addr_cmd4;
      lst_inv_port_cmd4 <= lst_inv_port_cmd4;
      end
   end


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded4 off4 age_chk_state4
// -----------------------------------------------------------------------------
assign age_check_active4 = (age_chk_state4 != 3'b000);

endmodule

