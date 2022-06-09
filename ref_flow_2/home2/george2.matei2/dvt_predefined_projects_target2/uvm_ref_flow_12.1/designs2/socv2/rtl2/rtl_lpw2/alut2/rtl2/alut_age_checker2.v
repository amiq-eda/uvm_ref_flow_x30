//File2 name   : alut_age_checker2.v
//Title2       : 
//Created2     : 1999
//Description2 : 
//Notes2       : 
//----------------------------------------------------------------------
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------

module alut_age_checker2
(   
   // Inputs2
   pclk2,
   n_p_reset2,
   command,          
   div_clk2,          
   mem_read_data_age2,
   check_age2,        
   last_accessed2, 
   best_bfr_age2,   
   add_check_active2,

   // outputs2
   curr_time2,         
   mem_addr_age2,      
   mem_write_age2,     
   mem_write_data_age2,
   lst_inv_addr_cmd2,    
   lst_inv_port_cmd2,  
   age_confirmed2,     
   age_ok2,
   inval_in_prog2,  
   age_check_active2          
);   

   input               pclk2;               // APB2 clock2                           
   input               n_p_reset2;          // Reset2                               
   input [1:0]         command;            // command bus                        
   input [7:0]         div_clk2;            // clock2 divider2 value
   input [82:0]        mem_read_data_age2;  // read data from memory             
   input               check_age2;          // request flag2 for age2 check
   input [31:0]        last_accessed2;      // time field sent2 for age2 check
   input [31:0]        best_bfr_age2;       // best2 before age2
   input               add_check_active2;   // active flag2 from address checker

   output [31:0]       curr_time2;          // current time,for storing2 in mem    
   output [7:0]        mem_addr_age2;       // address for R/W2 to memory     
   output              mem_write_age2;      // R/W2 flag2 (write = high2)            
   output [82:0]       mem_write_data_age2; // write data for memory             
   output [47:0]       lst_inv_addr_cmd2;   // last invalidated2 addr normal2 op    
   output [1:0]        lst_inv_port_cmd2;   // last invalidated2 port normal2 op    
   output              age_confirmed2;      // validates2 age_ok2 result 
   output              age_ok2;             // age2 checker result - set means2 in-date2
   output              inval_in_prog2;      // invalidation2 in progress2
   output              age_check_active2;   // bit 0 of status register           

   reg  [2:0]          age_chk_state2;      // age2 checker FSM2 current state
   reg  [2:0]          nxt_age_chk_state2;  // age2 checker FSM2 next state
   reg  [7:0]          mem_addr_age2;     
   reg                 mem_write_age2;    
   reg                 inval_in_prog2;      // invalidation2 in progress2
   reg  [7:0]          clk_div_cnt2;        // clock2 divider2 counter
   reg  [31:0]         curr_time2;          // current time,for storing2 in mem  
   reg                 age_confirmed2;      // validates2 age_ok2 result 
   reg                 age_ok2;             // age2 checker result - set means2 in-date2
   reg [47:0]          lst_inv_addr_cmd2;   // last invalidated2 addr normal2 op    
   reg [1:0]           lst_inv_port_cmd2;   // last invalidated2 port normal2 op    

   wire  [82:0]        mem_write_data_age2;
   wire  [31:0]        last_accessed_age2;  // read back time by age2 checker
   wire  [31:0]        time_since_lst_acc_age2;  // time since2 last accessed age2
   wire  [31:0]        time_since_lst_acc2; // time since2 last accessed address
   wire                age_check_active2;   // bit 0 of status register           

// Parameters2 for Address Checking2 FSM2 states2
   parameter idle2           = 3'b000;
   parameter inval_aged_rd2  = 3'b001;
   parameter inval_aged_wr2  = 3'b010;
   parameter inval_all2      = 3'b011;
   parameter age_chk2        = 3'b100;

   parameter max_addr       = 8'hff;
   parameter max_cnt2        = 32'hffff_ffff;

// -----------------------------------------------------------------------------
//   Generate2 current time counter
// -----------------------------------------------------------------------------
always @ (posedge pclk2 or negedge n_p_reset2)
   begin
   if (~n_p_reset2)
      clk_div_cnt2 <= 8'd0;
   else if (clk_div_cnt2 == div_clk2)
      clk_div_cnt2 <= 8'd0; 
   else 
      clk_div_cnt2 <= clk_div_cnt2 + 1'd1;
   end


always @ (posedge pclk2 or negedge n_p_reset2)
   begin
   if (~n_p_reset2)
      curr_time2 <= 32'd0;
   else if (clk_div_cnt2 == div_clk2)
      curr_time2 <= curr_time2 + 1'd1;
   end


// -----------------------------------------------------------------------------
//   Age2 checker State2 Machine2 
// -----------------------------------------------------------------------------
always @ (command or check_age2 or age_chk_state2 or age_confirmed2 or age_ok2 or
          mem_addr_age2 or mem_read_data_age2[82])
   begin
      case (age_chk_state2)
      
      idle2:
         if (command == 2'b10)
            nxt_age_chk_state2 = inval_aged_rd2;
         else if (command == 2'b11)
            nxt_age_chk_state2 = inval_all2;
         else if (check_age2)
            nxt_age_chk_state2 = age_chk2;
         else
            nxt_age_chk_state2 = idle2;

      inval_aged_rd2:
            nxt_age_chk_state2 = age_chk2;

      inval_aged_wr2:
            nxt_age_chk_state2 = idle2;

      inval_all2:
         if (mem_addr_age2 != max_addr)
            nxt_age_chk_state2 = inval_all2;  // move2 onto2 next address
         else
            nxt_age_chk_state2 = idle2;

      age_chk2:
         if (age_confirmed2)
            begin
            if (add_check_active2)                     // age2 check for addr chkr2
               nxt_age_chk_state2 = idle2;
            else if (~mem_read_data_age2[82])      // invalid, check next location2
               nxt_age_chk_state2 = inval_aged_rd2; 
            else if (~age_ok2 & mem_read_data_age2[82]) // out of date2, clear 
               nxt_age_chk_state2 = inval_aged_wr2;
            else if (mem_addr_age2 == max_addr)    // full check completed
               nxt_age_chk_state2 = idle2;     
            else 
               nxt_age_chk_state2 = inval_aged_rd2; // age2 ok, check next location2 
            end       
         else
            nxt_age_chk_state2 = age_chk2;

      default:
            nxt_age_chk_state2 = idle2;
      endcase
   end



always @ (posedge pclk2 or negedge n_p_reset2)
   begin
   if (~n_p_reset2)
      age_chk_state2 <= idle2;
   else
      age_chk_state2 <= nxt_age_chk_state2;
   end


// -----------------------------------------------------------------------------
//   Generate2 memory RW bus for accessing array when requested2 to invalidate2 all
//   aged2 addresses2 and all addresses2.
// -----------------------------------------------------------------------------
always @ (posedge pclk2 or negedge n_p_reset2)
   begin
   if (~n_p_reset2)
   begin
      mem_addr_age2 <= 8'd0;     
      mem_write_age2 <= 1'd0;    
   end
   else if (age_chk_state2 == inval_aged_rd2)  // invalidate2 aged2 read
   begin
      mem_addr_age2 <= mem_addr_age2 + 1'd1;     
      mem_write_age2 <= 1'd0;    
   end
   else if (age_chk_state2 == inval_aged_wr2)  // invalidate2 aged2 read
   begin
      mem_addr_age2 <= mem_addr_age2;     
      mem_write_age2 <= 1'd1;    
   end
   else if (age_chk_state2 == inval_all2)  // invalidate2 all
   begin
      mem_addr_age2 <= mem_addr_age2 + 1'd1;     
      mem_write_age2 <= 1'd1;    
   end
   else if (age_chk_state2 == age_chk2)
   begin
      mem_addr_age2 <= mem_addr_age2;     
      mem_write_age2 <= mem_write_age2;    
   end
   else 
   begin
      mem_addr_age2 <= mem_addr_age2;     
      mem_write_age2 <= 1'd0;    
   end
   end

// age2 checker will only ever2 write zero values to ALUT2 mem
assign mem_write_data_age2 = 83'd0;



// -----------------------------------------------------------------------------
//   Generate2 invalidate2 in progress2 flag2 (bit 1 of status register)
// -----------------------------------------------------------------------------
always @ (posedge pclk2 or negedge n_p_reset2)
   begin
   if (~n_p_reset2)
      inval_in_prog2 <= 1'd0;
   else if (age_chk_state2 == inval_aged_wr2) 
      inval_in_prog2 <= 1'd1;
   else if ((age_chk_state2 == age_chk2) & (mem_addr_age2 == max_addr))
      inval_in_prog2 <= 1'd0;
   else
      inval_in_prog2 <= inval_in_prog2;
   end


// -----------------------------------------------------------------------------
//   Calculate2 whether2 data is still in date2.  Need2 to work2 out the real time
//   gap2 between current time and last accessed.  If2 this gap2 is greater than
//   the best2 before age2, then2 the data is out of date2. 
// -----------------------------------------------------------------------------
assign time_since_lst_acc2 = (curr_time2 > last_accessed2) ? 
                            (curr_time2 - last_accessed2) :  // no cnt wrapping2
                            (curr_time2 + (max_cnt2 - last_accessed2));

assign time_since_lst_acc_age2 = (curr_time2 > last_accessed_age2) ? 
                                (curr_time2 - last_accessed_age2) : // no wrapping2
                                (curr_time2 + (max_cnt2 - last_accessed_age2));


always @ (posedge pclk2 or negedge n_p_reset2)
   begin
   if (~n_p_reset2)
      begin
      age_ok2 <= 1'b0;
      age_confirmed2 <= 1'b0;
      end
   else if ((age_chk_state2 == age_chk2) & add_check_active2) 
      begin                                       // age2 checking for addr chkr2
      if (best_bfr_age2 > time_since_lst_acc2)      // still in date2
         begin
         age_ok2 <= 1'b1;
         age_confirmed2 <= 1'b1;
         end
      else   // out of date2
         begin
         age_ok2 <= 1'b0;
         age_confirmed2 <= 1'b1;
         end
      end
   else if ((age_chk_state2 == age_chk2) & ~add_check_active2)
      begin                                      // age2 checking for inval2 aged2
      if (best_bfr_age2 > time_since_lst_acc_age2) // still in date2
         begin
         age_ok2 <= 1'b1;
         age_confirmed2 <= 1'b1;
         end
      else   // out of date2
         begin
         age_ok2 <= 1'b0;
         age_confirmed2 <= 1'b1;
         end
      end
   else
      begin
      age_ok2 <= 1'b0;
      age_confirmed2 <= 1'b0;
      end
   end



// -----------------------------------------------------------------------------
//   Generate2 last address and port that was cleared2 in the invalid aged2 process
// -----------------------------------------------------------------------------
always @ (posedge pclk2 or negedge n_p_reset2)
   begin
   if (~n_p_reset2)
      begin
      lst_inv_addr_cmd2 <= 48'd0;
      lst_inv_port_cmd2 <= 2'd0;
      end
   else if (age_chk_state2 == inval_aged_wr2)
      begin
      lst_inv_addr_cmd2 <= mem_read_data_age2[47:0];
      lst_inv_port_cmd2 <= mem_read_data_age2[49:48];
      end
   else 
      begin
      lst_inv_addr_cmd2 <= lst_inv_addr_cmd2;
      lst_inv_port_cmd2 <= lst_inv_port_cmd2;
      end
   end


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded2 off2 age_chk_state2
// -----------------------------------------------------------------------------
assign age_check_active2 = (age_chk_state2 != 3'b000);

endmodule

