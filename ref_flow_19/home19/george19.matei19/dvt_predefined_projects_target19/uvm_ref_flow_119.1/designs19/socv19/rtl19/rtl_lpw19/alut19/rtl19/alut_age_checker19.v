//File19 name   : alut_age_checker19.v
//Title19       : 
//Created19     : 1999
//Description19 : 
//Notes19       : 
//----------------------------------------------------------------------
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------

module alut_age_checker19
(   
   // Inputs19
   pclk19,
   n_p_reset19,
   command,          
   div_clk19,          
   mem_read_data_age19,
   check_age19,        
   last_accessed19, 
   best_bfr_age19,   
   add_check_active19,

   // outputs19
   curr_time19,         
   mem_addr_age19,      
   mem_write_age19,     
   mem_write_data_age19,
   lst_inv_addr_cmd19,    
   lst_inv_port_cmd19,  
   age_confirmed19,     
   age_ok19,
   inval_in_prog19,  
   age_check_active19          
);   

   input               pclk19;               // APB19 clock19                           
   input               n_p_reset19;          // Reset19                               
   input [1:0]         command;            // command bus                        
   input [7:0]         div_clk19;            // clock19 divider19 value
   input [82:0]        mem_read_data_age19;  // read data from memory             
   input               check_age19;          // request flag19 for age19 check
   input [31:0]        last_accessed19;      // time field sent19 for age19 check
   input [31:0]        best_bfr_age19;       // best19 before age19
   input               add_check_active19;   // active flag19 from address checker

   output [31:0]       curr_time19;          // current time,for storing19 in mem    
   output [7:0]        mem_addr_age19;       // address for R/W19 to memory     
   output              mem_write_age19;      // R/W19 flag19 (write = high19)            
   output [82:0]       mem_write_data_age19; // write data for memory             
   output [47:0]       lst_inv_addr_cmd19;   // last invalidated19 addr normal19 op    
   output [1:0]        lst_inv_port_cmd19;   // last invalidated19 port normal19 op    
   output              age_confirmed19;      // validates19 age_ok19 result 
   output              age_ok19;             // age19 checker result - set means19 in-date19
   output              inval_in_prog19;      // invalidation19 in progress19
   output              age_check_active19;   // bit 0 of status register           

   reg  [2:0]          age_chk_state19;      // age19 checker FSM19 current state
   reg  [2:0]          nxt_age_chk_state19;  // age19 checker FSM19 next state
   reg  [7:0]          mem_addr_age19;     
   reg                 mem_write_age19;    
   reg                 inval_in_prog19;      // invalidation19 in progress19
   reg  [7:0]          clk_div_cnt19;        // clock19 divider19 counter
   reg  [31:0]         curr_time19;          // current time,for storing19 in mem  
   reg                 age_confirmed19;      // validates19 age_ok19 result 
   reg                 age_ok19;             // age19 checker result - set means19 in-date19
   reg [47:0]          lst_inv_addr_cmd19;   // last invalidated19 addr normal19 op    
   reg [1:0]           lst_inv_port_cmd19;   // last invalidated19 port normal19 op    

   wire  [82:0]        mem_write_data_age19;
   wire  [31:0]        last_accessed_age19;  // read back time by age19 checker
   wire  [31:0]        time_since_lst_acc_age19;  // time since19 last accessed age19
   wire  [31:0]        time_since_lst_acc19; // time since19 last accessed address
   wire                age_check_active19;   // bit 0 of status register           

// Parameters19 for Address Checking19 FSM19 states19
   parameter idle19           = 3'b000;
   parameter inval_aged_rd19  = 3'b001;
   parameter inval_aged_wr19  = 3'b010;
   parameter inval_all19      = 3'b011;
   parameter age_chk19        = 3'b100;

   parameter max_addr       = 8'hff;
   parameter max_cnt19        = 32'hffff_ffff;

// -----------------------------------------------------------------------------
//   Generate19 current time counter
// -----------------------------------------------------------------------------
always @ (posedge pclk19 or negedge n_p_reset19)
   begin
   if (~n_p_reset19)
      clk_div_cnt19 <= 8'd0;
   else if (clk_div_cnt19 == div_clk19)
      clk_div_cnt19 <= 8'd0; 
   else 
      clk_div_cnt19 <= clk_div_cnt19 + 1'd1;
   end


always @ (posedge pclk19 or negedge n_p_reset19)
   begin
   if (~n_p_reset19)
      curr_time19 <= 32'd0;
   else if (clk_div_cnt19 == div_clk19)
      curr_time19 <= curr_time19 + 1'd1;
   end


// -----------------------------------------------------------------------------
//   Age19 checker State19 Machine19 
// -----------------------------------------------------------------------------
always @ (command or check_age19 or age_chk_state19 or age_confirmed19 or age_ok19 or
          mem_addr_age19 or mem_read_data_age19[82])
   begin
      case (age_chk_state19)
      
      idle19:
         if (command == 2'b10)
            nxt_age_chk_state19 = inval_aged_rd19;
         else if (command == 2'b11)
            nxt_age_chk_state19 = inval_all19;
         else if (check_age19)
            nxt_age_chk_state19 = age_chk19;
         else
            nxt_age_chk_state19 = idle19;

      inval_aged_rd19:
            nxt_age_chk_state19 = age_chk19;

      inval_aged_wr19:
            nxt_age_chk_state19 = idle19;

      inval_all19:
         if (mem_addr_age19 != max_addr)
            nxt_age_chk_state19 = inval_all19;  // move19 onto19 next address
         else
            nxt_age_chk_state19 = idle19;

      age_chk19:
         if (age_confirmed19)
            begin
            if (add_check_active19)                     // age19 check for addr chkr19
               nxt_age_chk_state19 = idle19;
            else if (~mem_read_data_age19[82])      // invalid, check next location19
               nxt_age_chk_state19 = inval_aged_rd19; 
            else if (~age_ok19 & mem_read_data_age19[82]) // out of date19, clear 
               nxt_age_chk_state19 = inval_aged_wr19;
            else if (mem_addr_age19 == max_addr)    // full check completed
               nxt_age_chk_state19 = idle19;     
            else 
               nxt_age_chk_state19 = inval_aged_rd19; // age19 ok, check next location19 
            end       
         else
            nxt_age_chk_state19 = age_chk19;

      default:
            nxt_age_chk_state19 = idle19;
      endcase
   end



always @ (posedge pclk19 or negedge n_p_reset19)
   begin
   if (~n_p_reset19)
      age_chk_state19 <= idle19;
   else
      age_chk_state19 <= nxt_age_chk_state19;
   end


// -----------------------------------------------------------------------------
//   Generate19 memory RW bus for accessing array when requested19 to invalidate19 all
//   aged19 addresses19 and all addresses19.
// -----------------------------------------------------------------------------
always @ (posedge pclk19 or negedge n_p_reset19)
   begin
   if (~n_p_reset19)
   begin
      mem_addr_age19 <= 8'd0;     
      mem_write_age19 <= 1'd0;    
   end
   else if (age_chk_state19 == inval_aged_rd19)  // invalidate19 aged19 read
   begin
      mem_addr_age19 <= mem_addr_age19 + 1'd1;     
      mem_write_age19 <= 1'd0;    
   end
   else if (age_chk_state19 == inval_aged_wr19)  // invalidate19 aged19 read
   begin
      mem_addr_age19 <= mem_addr_age19;     
      mem_write_age19 <= 1'd1;    
   end
   else if (age_chk_state19 == inval_all19)  // invalidate19 all
   begin
      mem_addr_age19 <= mem_addr_age19 + 1'd1;     
      mem_write_age19 <= 1'd1;    
   end
   else if (age_chk_state19 == age_chk19)
   begin
      mem_addr_age19 <= mem_addr_age19;     
      mem_write_age19 <= mem_write_age19;    
   end
   else 
   begin
      mem_addr_age19 <= mem_addr_age19;     
      mem_write_age19 <= 1'd0;    
   end
   end

// age19 checker will only ever19 write zero values to ALUT19 mem
assign mem_write_data_age19 = 83'd0;



// -----------------------------------------------------------------------------
//   Generate19 invalidate19 in progress19 flag19 (bit 1 of status register)
// -----------------------------------------------------------------------------
always @ (posedge pclk19 or negedge n_p_reset19)
   begin
   if (~n_p_reset19)
      inval_in_prog19 <= 1'd0;
   else if (age_chk_state19 == inval_aged_wr19) 
      inval_in_prog19 <= 1'd1;
   else if ((age_chk_state19 == age_chk19) & (mem_addr_age19 == max_addr))
      inval_in_prog19 <= 1'd0;
   else
      inval_in_prog19 <= inval_in_prog19;
   end


// -----------------------------------------------------------------------------
//   Calculate19 whether19 data is still in date19.  Need19 to work19 out the real time
//   gap19 between current time and last accessed.  If19 this gap19 is greater than
//   the best19 before age19, then19 the data is out of date19. 
// -----------------------------------------------------------------------------
assign time_since_lst_acc19 = (curr_time19 > last_accessed19) ? 
                            (curr_time19 - last_accessed19) :  // no cnt wrapping19
                            (curr_time19 + (max_cnt19 - last_accessed19));

assign time_since_lst_acc_age19 = (curr_time19 > last_accessed_age19) ? 
                                (curr_time19 - last_accessed_age19) : // no wrapping19
                                (curr_time19 + (max_cnt19 - last_accessed_age19));


always @ (posedge pclk19 or negedge n_p_reset19)
   begin
   if (~n_p_reset19)
      begin
      age_ok19 <= 1'b0;
      age_confirmed19 <= 1'b0;
      end
   else if ((age_chk_state19 == age_chk19) & add_check_active19) 
      begin                                       // age19 checking for addr chkr19
      if (best_bfr_age19 > time_since_lst_acc19)      // still in date19
         begin
         age_ok19 <= 1'b1;
         age_confirmed19 <= 1'b1;
         end
      else   // out of date19
         begin
         age_ok19 <= 1'b0;
         age_confirmed19 <= 1'b1;
         end
      end
   else if ((age_chk_state19 == age_chk19) & ~add_check_active19)
      begin                                      // age19 checking for inval19 aged19
      if (best_bfr_age19 > time_since_lst_acc_age19) // still in date19
         begin
         age_ok19 <= 1'b1;
         age_confirmed19 <= 1'b1;
         end
      else   // out of date19
         begin
         age_ok19 <= 1'b0;
         age_confirmed19 <= 1'b1;
         end
      end
   else
      begin
      age_ok19 <= 1'b0;
      age_confirmed19 <= 1'b0;
      end
   end



// -----------------------------------------------------------------------------
//   Generate19 last address and port that was cleared19 in the invalid aged19 process
// -----------------------------------------------------------------------------
always @ (posedge pclk19 or negedge n_p_reset19)
   begin
   if (~n_p_reset19)
      begin
      lst_inv_addr_cmd19 <= 48'd0;
      lst_inv_port_cmd19 <= 2'd0;
      end
   else if (age_chk_state19 == inval_aged_wr19)
      begin
      lst_inv_addr_cmd19 <= mem_read_data_age19[47:0];
      lst_inv_port_cmd19 <= mem_read_data_age19[49:48];
      end
   else 
      begin
      lst_inv_addr_cmd19 <= lst_inv_addr_cmd19;
      lst_inv_port_cmd19 <= lst_inv_port_cmd19;
      end
   end


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded19 off19 age_chk_state19
// -----------------------------------------------------------------------------
assign age_check_active19 = (age_chk_state19 != 3'b000);

endmodule

