//File18 name   : alut_age_checker18.v
//Title18       : 
//Created18     : 1999
//Description18 : 
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

module alut_age_checker18
(   
   // Inputs18
   pclk18,
   n_p_reset18,
   command,          
   div_clk18,          
   mem_read_data_age18,
   check_age18,        
   last_accessed18, 
   best_bfr_age18,   
   add_check_active18,

   // outputs18
   curr_time18,         
   mem_addr_age18,      
   mem_write_age18,     
   mem_write_data_age18,
   lst_inv_addr_cmd18,    
   lst_inv_port_cmd18,  
   age_confirmed18,     
   age_ok18,
   inval_in_prog18,  
   age_check_active18          
);   

   input               pclk18;               // APB18 clock18                           
   input               n_p_reset18;          // Reset18                               
   input [1:0]         command;            // command bus                        
   input [7:0]         div_clk18;            // clock18 divider18 value
   input [82:0]        mem_read_data_age18;  // read data from memory             
   input               check_age18;          // request flag18 for age18 check
   input [31:0]        last_accessed18;      // time field sent18 for age18 check
   input [31:0]        best_bfr_age18;       // best18 before age18
   input               add_check_active18;   // active flag18 from address checker

   output [31:0]       curr_time18;          // current time,for storing18 in mem    
   output [7:0]        mem_addr_age18;       // address for R/W18 to memory     
   output              mem_write_age18;      // R/W18 flag18 (write = high18)            
   output [82:0]       mem_write_data_age18; // write data for memory             
   output [47:0]       lst_inv_addr_cmd18;   // last invalidated18 addr normal18 op    
   output [1:0]        lst_inv_port_cmd18;   // last invalidated18 port normal18 op    
   output              age_confirmed18;      // validates18 age_ok18 result 
   output              age_ok18;             // age18 checker result - set means18 in-date18
   output              inval_in_prog18;      // invalidation18 in progress18
   output              age_check_active18;   // bit 0 of status register           

   reg  [2:0]          age_chk_state18;      // age18 checker FSM18 current state
   reg  [2:0]          nxt_age_chk_state18;  // age18 checker FSM18 next state
   reg  [7:0]          mem_addr_age18;     
   reg                 mem_write_age18;    
   reg                 inval_in_prog18;      // invalidation18 in progress18
   reg  [7:0]          clk_div_cnt18;        // clock18 divider18 counter
   reg  [31:0]         curr_time18;          // current time,for storing18 in mem  
   reg                 age_confirmed18;      // validates18 age_ok18 result 
   reg                 age_ok18;             // age18 checker result - set means18 in-date18
   reg [47:0]          lst_inv_addr_cmd18;   // last invalidated18 addr normal18 op    
   reg [1:0]           lst_inv_port_cmd18;   // last invalidated18 port normal18 op    

   wire  [82:0]        mem_write_data_age18;
   wire  [31:0]        last_accessed_age18;  // read back time by age18 checker
   wire  [31:0]        time_since_lst_acc_age18;  // time since18 last accessed age18
   wire  [31:0]        time_since_lst_acc18; // time since18 last accessed address
   wire                age_check_active18;   // bit 0 of status register           

// Parameters18 for Address Checking18 FSM18 states18
   parameter idle18           = 3'b000;
   parameter inval_aged_rd18  = 3'b001;
   parameter inval_aged_wr18  = 3'b010;
   parameter inval_all18      = 3'b011;
   parameter age_chk18        = 3'b100;

   parameter max_addr       = 8'hff;
   parameter max_cnt18        = 32'hffff_ffff;

// -----------------------------------------------------------------------------
//   Generate18 current time counter
// -----------------------------------------------------------------------------
always @ (posedge pclk18 or negedge n_p_reset18)
   begin
   if (~n_p_reset18)
      clk_div_cnt18 <= 8'd0;
   else if (clk_div_cnt18 == div_clk18)
      clk_div_cnt18 <= 8'd0; 
   else 
      clk_div_cnt18 <= clk_div_cnt18 + 1'd1;
   end


always @ (posedge pclk18 or negedge n_p_reset18)
   begin
   if (~n_p_reset18)
      curr_time18 <= 32'd0;
   else if (clk_div_cnt18 == div_clk18)
      curr_time18 <= curr_time18 + 1'd1;
   end


// -----------------------------------------------------------------------------
//   Age18 checker State18 Machine18 
// -----------------------------------------------------------------------------
always @ (command or check_age18 or age_chk_state18 or age_confirmed18 or age_ok18 or
          mem_addr_age18 or mem_read_data_age18[82])
   begin
      case (age_chk_state18)
      
      idle18:
         if (command == 2'b10)
            nxt_age_chk_state18 = inval_aged_rd18;
         else if (command == 2'b11)
            nxt_age_chk_state18 = inval_all18;
         else if (check_age18)
            nxt_age_chk_state18 = age_chk18;
         else
            nxt_age_chk_state18 = idle18;

      inval_aged_rd18:
            nxt_age_chk_state18 = age_chk18;

      inval_aged_wr18:
            nxt_age_chk_state18 = idle18;

      inval_all18:
         if (mem_addr_age18 != max_addr)
            nxt_age_chk_state18 = inval_all18;  // move18 onto18 next address
         else
            nxt_age_chk_state18 = idle18;

      age_chk18:
         if (age_confirmed18)
            begin
            if (add_check_active18)                     // age18 check for addr chkr18
               nxt_age_chk_state18 = idle18;
            else if (~mem_read_data_age18[82])      // invalid, check next location18
               nxt_age_chk_state18 = inval_aged_rd18; 
            else if (~age_ok18 & mem_read_data_age18[82]) // out of date18, clear 
               nxt_age_chk_state18 = inval_aged_wr18;
            else if (mem_addr_age18 == max_addr)    // full check completed
               nxt_age_chk_state18 = idle18;     
            else 
               nxt_age_chk_state18 = inval_aged_rd18; // age18 ok, check next location18 
            end       
         else
            nxt_age_chk_state18 = age_chk18;

      default:
            nxt_age_chk_state18 = idle18;
      endcase
   end



always @ (posedge pclk18 or negedge n_p_reset18)
   begin
   if (~n_p_reset18)
      age_chk_state18 <= idle18;
   else
      age_chk_state18 <= nxt_age_chk_state18;
   end


// -----------------------------------------------------------------------------
//   Generate18 memory RW bus for accessing array when requested18 to invalidate18 all
//   aged18 addresses18 and all addresses18.
// -----------------------------------------------------------------------------
always @ (posedge pclk18 or negedge n_p_reset18)
   begin
   if (~n_p_reset18)
   begin
      mem_addr_age18 <= 8'd0;     
      mem_write_age18 <= 1'd0;    
   end
   else if (age_chk_state18 == inval_aged_rd18)  // invalidate18 aged18 read
   begin
      mem_addr_age18 <= mem_addr_age18 + 1'd1;     
      mem_write_age18 <= 1'd0;    
   end
   else if (age_chk_state18 == inval_aged_wr18)  // invalidate18 aged18 read
   begin
      mem_addr_age18 <= mem_addr_age18;     
      mem_write_age18 <= 1'd1;    
   end
   else if (age_chk_state18 == inval_all18)  // invalidate18 all
   begin
      mem_addr_age18 <= mem_addr_age18 + 1'd1;     
      mem_write_age18 <= 1'd1;    
   end
   else if (age_chk_state18 == age_chk18)
   begin
      mem_addr_age18 <= mem_addr_age18;     
      mem_write_age18 <= mem_write_age18;    
   end
   else 
   begin
      mem_addr_age18 <= mem_addr_age18;     
      mem_write_age18 <= 1'd0;    
   end
   end

// age18 checker will only ever18 write zero values to ALUT18 mem
assign mem_write_data_age18 = 83'd0;



// -----------------------------------------------------------------------------
//   Generate18 invalidate18 in progress18 flag18 (bit 1 of status register)
// -----------------------------------------------------------------------------
always @ (posedge pclk18 or negedge n_p_reset18)
   begin
   if (~n_p_reset18)
      inval_in_prog18 <= 1'd0;
   else if (age_chk_state18 == inval_aged_wr18) 
      inval_in_prog18 <= 1'd1;
   else if ((age_chk_state18 == age_chk18) & (mem_addr_age18 == max_addr))
      inval_in_prog18 <= 1'd0;
   else
      inval_in_prog18 <= inval_in_prog18;
   end


// -----------------------------------------------------------------------------
//   Calculate18 whether18 data is still in date18.  Need18 to work18 out the real time
//   gap18 between current time and last accessed.  If18 this gap18 is greater than
//   the best18 before age18, then18 the data is out of date18. 
// -----------------------------------------------------------------------------
assign time_since_lst_acc18 = (curr_time18 > last_accessed18) ? 
                            (curr_time18 - last_accessed18) :  // no cnt wrapping18
                            (curr_time18 + (max_cnt18 - last_accessed18));

assign time_since_lst_acc_age18 = (curr_time18 > last_accessed_age18) ? 
                                (curr_time18 - last_accessed_age18) : // no wrapping18
                                (curr_time18 + (max_cnt18 - last_accessed_age18));


always @ (posedge pclk18 or negedge n_p_reset18)
   begin
   if (~n_p_reset18)
      begin
      age_ok18 <= 1'b0;
      age_confirmed18 <= 1'b0;
      end
   else if ((age_chk_state18 == age_chk18) & add_check_active18) 
      begin                                       // age18 checking for addr chkr18
      if (best_bfr_age18 > time_since_lst_acc18)      // still in date18
         begin
         age_ok18 <= 1'b1;
         age_confirmed18 <= 1'b1;
         end
      else   // out of date18
         begin
         age_ok18 <= 1'b0;
         age_confirmed18 <= 1'b1;
         end
      end
   else if ((age_chk_state18 == age_chk18) & ~add_check_active18)
      begin                                      // age18 checking for inval18 aged18
      if (best_bfr_age18 > time_since_lst_acc_age18) // still in date18
         begin
         age_ok18 <= 1'b1;
         age_confirmed18 <= 1'b1;
         end
      else   // out of date18
         begin
         age_ok18 <= 1'b0;
         age_confirmed18 <= 1'b1;
         end
      end
   else
      begin
      age_ok18 <= 1'b0;
      age_confirmed18 <= 1'b0;
      end
   end



// -----------------------------------------------------------------------------
//   Generate18 last address and port that was cleared18 in the invalid aged18 process
// -----------------------------------------------------------------------------
always @ (posedge pclk18 or negedge n_p_reset18)
   begin
   if (~n_p_reset18)
      begin
      lst_inv_addr_cmd18 <= 48'd0;
      lst_inv_port_cmd18 <= 2'd0;
      end
   else if (age_chk_state18 == inval_aged_wr18)
      begin
      lst_inv_addr_cmd18 <= mem_read_data_age18[47:0];
      lst_inv_port_cmd18 <= mem_read_data_age18[49:48];
      end
   else 
      begin
      lst_inv_addr_cmd18 <= lst_inv_addr_cmd18;
      lst_inv_port_cmd18 <= lst_inv_port_cmd18;
      end
   end


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded18 off18 age_chk_state18
// -----------------------------------------------------------------------------
assign age_check_active18 = (age_chk_state18 != 3'b000);

endmodule

