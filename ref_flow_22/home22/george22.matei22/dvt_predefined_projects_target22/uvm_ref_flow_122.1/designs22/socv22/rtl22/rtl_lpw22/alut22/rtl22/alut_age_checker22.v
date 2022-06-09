//File22 name   : alut_age_checker22.v
//Title22       : 
//Created22     : 1999
//Description22 : 
//Notes22       : 
//----------------------------------------------------------------------
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------

module alut_age_checker22
(   
   // Inputs22
   pclk22,
   n_p_reset22,
   command,          
   div_clk22,          
   mem_read_data_age22,
   check_age22,        
   last_accessed22, 
   best_bfr_age22,   
   add_check_active22,

   // outputs22
   curr_time22,         
   mem_addr_age22,      
   mem_write_age22,     
   mem_write_data_age22,
   lst_inv_addr_cmd22,    
   lst_inv_port_cmd22,  
   age_confirmed22,     
   age_ok22,
   inval_in_prog22,  
   age_check_active22          
);   

   input               pclk22;               // APB22 clock22                           
   input               n_p_reset22;          // Reset22                               
   input [1:0]         command;            // command bus                        
   input [7:0]         div_clk22;            // clock22 divider22 value
   input [82:0]        mem_read_data_age22;  // read data from memory             
   input               check_age22;          // request flag22 for age22 check
   input [31:0]        last_accessed22;      // time field sent22 for age22 check
   input [31:0]        best_bfr_age22;       // best22 before age22
   input               add_check_active22;   // active flag22 from address checker

   output [31:0]       curr_time22;          // current time,for storing22 in mem    
   output [7:0]        mem_addr_age22;       // address for R/W22 to memory     
   output              mem_write_age22;      // R/W22 flag22 (write = high22)            
   output [82:0]       mem_write_data_age22; // write data for memory             
   output [47:0]       lst_inv_addr_cmd22;   // last invalidated22 addr normal22 op    
   output [1:0]        lst_inv_port_cmd22;   // last invalidated22 port normal22 op    
   output              age_confirmed22;      // validates22 age_ok22 result 
   output              age_ok22;             // age22 checker result - set means22 in-date22
   output              inval_in_prog22;      // invalidation22 in progress22
   output              age_check_active22;   // bit 0 of status register           

   reg  [2:0]          age_chk_state22;      // age22 checker FSM22 current state
   reg  [2:0]          nxt_age_chk_state22;  // age22 checker FSM22 next state
   reg  [7:0]          mem_addr_age22;     
   reg                 mem_write_age22;    
   reg                 inval_in_prog22;      // invalidation22 in progress22
   reg  [7:0]          clk_div_cnt22;        // clock22 divider22 counter
   reg  [31:0]         curr_time22;          // current time,for storing22 in mem  
   reg                 age_confirmed22;      // validates22 age_ok22 result 
   reg                 age_ok22;             // age22 checker result - set means22 in-date22
   reg [47:0]          lst_inv_addr_cmd22;   // last invalidated22 addr normal22 op    
   reg [1:0]           lst_inv_port_cmd22;   // last invalidated22 port normal22 op    

   wire  [82:0]        mem_write_data_age22;
   wire  [31:0]        last_accessed_age22;  // read back time by age22 checker
   wire  [31:0]        time_since_lst_acc_age22;  // time since22 last accessed age22
   wire  [31:0]        time_since_lst_acc22; // time since22 last accessed address
   wire                age_check_active22;   // bit 0 of status register           

// Parameters22 for Address Checking22 FSM22 states22
   parameter idle22           = 3'b000;
   parameter inval_aged_rd22  = 3'b001;
   parameter inval_aged_wr22  = 3'b010;
   parameter inval_all22      = 3'b011;
   parameter age_chk22        = 3'b100;

   parameter max_addr       = 8'hff;
   parameter max_cnt22        = 32'hffff_ffff;

// -----------------------------------------------------------------------------
//   Generate22 current time counter
// -----------------------------------------------------------------------------
always @ (posedge pclk22 or negedge n_p_reset22)
   begin
   if (~n_p_reset22)
      clk_div_cnt22 <= 8'd0;
   else if (clk_div_cnt22 == div_clk22)
      clk_div_cnt22 <= 8'd0; 
   else 
      clk_div_cnt22 <= clk_div_cnt22 + 1'd1;
   end


always @ (posedge pclk22 or negedge n_p_reset22)
   begin
   if (~n_p_reset22)
      curr_time22 <= 32'd0;
   else if (clk_div_cnt22 == div_clk22)
      curr_time22 <= curr_time22 + 1'd1;
   end


// -----------------------------------------------------------------------------
//   Age22 checker State22 Machine22 
// -----------------------------------------------------------------------------
always @ (command or check_age22 or age_chk_state22 or age_confirmed22 or age_ok22 or
          mem_addr_age22 or mem_read_data_age22[82])
   begin
      case (age_chk_state22)
      
      idle22:
         if (command == 2'b10)
            nxt_age_chk_state22 = inval_aged_rd22;
         else if (command == 2'b11)
            nxt_age_chk_state22 = inval_all22;
         else if (check_age22)
            nxt_age_chk_state22 = age_chk22;
         else
            nxt_age_chk_state22 = idle22;

      inval_aged_rd22:
            nxt_age_chk_state22 = age_chk22;

      inval_aged_wr22:
            nxt_age_chk_state22 = idle22;

      inval_all22:
         if (mem_addr_age22 != max_addr)
            nxt_age_chk_state22 = inval_all22;  // move22 onto22 next address
         else
            nxt_age_chk_state22 = idle22;

      age_chk22:
         if (age_confirmed22)
            begin
            if (add_check_active22)                     // age22 check for addr chkr22
               nxt_age_chk_state22 = idle22;
            else if (~mem_read_data_age22[82])      // invalid, check next location22
               nxt_age_chk_state22 = inval_aged_rd22; 
            else if (~age_ok22 & mem_read_data_age22[82]) // out of date22, clear 
               nxt_age_chk_state22 = inval_aged_wr22;
            else if (mem_addr_age22 == max_addr)    // full check completed
               nxt_age_chk_state22 = idle22;     
            else 
               nxt_age_chk_state22 = inval_aged_rd22; // age22 ok, check next location22 
            end       
         else
            nxt_age_chk_state22 = age_chk22;

      default:
            nxt_age_chk_state22 = idle22;
      endcase
   end



always @ (posedge pclk22 or negedge n_p_reset22)
   begin
   if (~n_p_reset22)
      age_chk_state22 <= idle22;
   else
      age_chk_state22 <= nxt_age_chk_state22;
   end


// -----------------------------------------------------------------------------
//   Generate22 memory RW bus for accessing array when requested22 to invalidate22 all
//   aged22 addresses22 and all addresses22.
// -----------------------------------------------------------------------------
always @ (posedge pclk22 or negedge n_p_reset22)
   begin
   if (~n_p_reset22)
   begin
      mem_addr_age22 <= 8'd0;     
      mem_write_age22 <= 1'd0;    
   end
   else if (age_chk_state22 == inval_aged_rd22)  // invalidate22 aged22 read
   begin
      mem_addr_age22 <= mem_addr_age22 + 1'd1;     
      mem_write_age22 <= 1'd0;    
   end
   else if (age_chk_state22 == inval_aged_wr22)  // invalidate22 aged22 read
   begin
      mem_addr_age22 <= mem_addr_age22;     
      mem_write_age22 <= 1'd1;    
   end
   else if (age_chk_state22 == inval_all22)  // invalidate22 all
   begin
      mem_addr_age22 <= mem_addr_age22 + 1'd1;     
      mem_write_age22 <= 1'd1;    
   end
   else if (age_chk_state22 == age_chk22)
   begin
      mem_addr_age22 <= mem_addr_age22;     
      mem_write_age22 <= mem_write_age22;    
   end
   else 
   begin
      mem_addr_age22 <= mem_addr_age22;     
      mem_write_age22 <= 1'd0;    
   end
   end

// age22 checker will only ever22 write zero values to ALUT22 mem
assign mem_write_data_age22 = 83'd0;



// -----------------------------------------------------------------------------
//   Generate22 invalidate22 in progress22 flag22 (bit 1 of status register)
// -----------------------------------------------------------------------------
always @ (posedge pclk22 or negedge n_p_reset22)
   begin
   if (~n_p_reset22)
      inval_in_prog22 <= 1'd0;
   else if (age_chk_state22 == inval_aged_wr22) 
      inval_in_prog22 <= 1'd1;
   else if ((age_chk_state22 == age_chk22) & (mem_addr_age22 == max_addr))
      inval_in_prog22 <= 1'd0;
   else
      inval_in_prog22 <= inval_in_prog22;
   end


// -----------------------------------------------------------------------------
//   Calculate22 whether22 data is still in date22.  Need22 to work22 out the real time
//   gap22 between current time and last accessed.  If22 this gap22 is greater than
//   the best22 before age22, then22 the data is out of date22. 
// -----------------------------------------------------------------------------
assign time_since_lst_acc22 = (curr_time22 > last_accessed22) ? 
                            (curr_time22 - last_accessed22) :  // no cnt wrapping22
                            (curr_time22 + (max_cnt22 - last_accessed22));

assign time_since_lst_acc_age22 = (curr_time22 > last_accessed_age22) ? 
                                (curr_time22 - last_accessed_age22) : // no wrapping22
                                (curr_time22 + (max_cnt22 - last_accessed_age22));


always @ (posedge pclk22 or negedge n_p_reset22)
   begin
   if (~n_p_reset22)
      begin
      age_ok22 <= 1'b0;
      age_confirmed22 <= 1'b0;
      end
   else if ((age_chk_state22 == age_chk22) & add_check_active22) 
      begin                                       // age22 checking for addr chkr22
      if (best_bfr_age22 > time_since_lst_acc22)      // still in date22
         begin
         age_ok22 <= 1'b1;
         age_confirmed22 <= 1'b1;
         end
      else   // out of date22
         begin
         age_ok22 <= 1'b0;
         age_confirmed22 <= 1'b1;
         end
      end
   else if ((age_chk_state22 == age_chk22) & ~add_check_active22)
      begin                                      // age22 checking for inval22 aged22
      if (best_bfr_age22 > time_since_lst_acc_age22) // still in date22
         begin
         age_ok22 <= 1'b1;
         age_confirmed22 <= 1'b1;
         end
      else   // out of date22
         begin
         age_ok22 <= 1'b0;
         age_confirmed22 <= 1'b1;
         end
      end
   else
      begin
      age_ok22 <= 1'b0;
      age_confirmed22 <= 1'b0;
      end
   end



// -----------------------------------------------------------------------------
//   Generate22 last address and port that was cleared22 in the invalid aged22 process
// -----------------------------------------------------------------------------
always @ (posedge pclk22 or negedge n_p_reset22)
   begin
   if (~n_p_reset22)
      begin
      lst_inv_addr_cmd22 <= 48'd0;
      lst_inv_port_cmd22 <= 2'd0;
      end
   else if (age_chk_state22 == inval_aged_wr22)
      begin
      lst_inv_addr_cmd22 <= mem_read_data_age22[47:0];
      lst_inv_port_cmd22 <= mem_read_data_age22[49:48];
      end
   else 
      begin
      lst_inv_addr_cmd22 <= lst_inv_addr_cmd22;
      lst_inv_port_cmd22 <= lst_inv_port_cmd22;
      end
   end


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded22 off22 age_chk_state22
// -----------------------------------------------------------------------------
assign age_check_active22 = (age_chk_state22 != 3'b000);

endmodule

