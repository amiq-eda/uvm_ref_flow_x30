//File6 name   : alut_age_checker6.v
//Title6       : 
//Created6     : 1999
//Description6 : 
//Notes6       : 
//----------------------------------------------------------------------
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------

module alut_age_checker6
(   
   // Inputs6
   pclk6,
   n_p_reset6,
   command,          
   div_clk6,          
   mem_read_data_age6,
   check_age6,        
   last_accessed6, 
   best_bfr_age6,   
   add_check_active6,

   // outputs6
   curr_time6,         
   mem_addr_age6,      
   mem_write_age6,     
   mem_write_data_age6,
   lst_inv_addr_cmd6,    
   lst_inv_port_cmd6,  
   age_confirmed6,     
   age_ok6,
   inval_in_prog6,  
   age_check_active6          
);   

   input               pclk6;               // APB6 clock6                           
   input               n_p_reset6;          // Reset6                               
   input [1:0]         command;            // command bus                        
   input [7:0]         div_clk6;            // clock6 divider6 value
   input [82:0]        mem_read_data_age6;  // read data from memory             
   input               check_age6;          // request flag6 for age6 check
   input [31:0]        last_accessed6;      // time field sent6 for age6 check
   input [31:0]        best_bfr_age6;       // best6 before age6
   input               add_check_active6;   // active flag6 from address checker

   output [31:0]       curr_time6;          // current time,for storing6 in mem    
   output [7:0]        mem_addr_age6;       // address for R/W6 to memory     
   output              mem_write_age6;      // R/W6 flag6 (write = high6)            
   output [82:0]       mem_write_data_age6; // write data for memory             
   output [47:0]       lst_inv_addr_cmd6;   // last invalidated6 addr normal6 op    
   output [1:0]        lst_inv_port_cmd6;   // last invalidated6 port normal6 op    
   output              age_confirmed6;      // validates6 age_ok6 result 
   output              age_ok6;             // age6 checker result - set means6 in-date6
   output              inval_in_prog6;      // invalidation6 in progress6
   output              age_check_active6;   // bit 0 of status register           

   reg  [2:0]          age_chk_state6;      // age6 checker FSM6 current state
   reg  [2:0]          nxt_age_chk_state6;  // age6 checker FSM6 next state
   reg  [7:0]          mem_addr_age6;     
   reg                 mem_write_age6;    
   reg                 inval_in_prog6;      // invalidation6 in progress6
   reg  [7:0]          clk_div_cnt6;        // clock6 divider6 counter
   reg  [31:0]         curr_time6;          // current time,for storing6 in mem  
   reg                 age_confirmed6;      // validates6 age_ok6 result 
   reg                 age_ok6;             // age6 checker result - set means6 in-date6
   reg [47:0]          lst_inv_addr_cmd6;   // last invalidated6 addr normal6 op    
   reg [1:0]           lst_inv_port_cmd6;   // last invalidated6 port normal6 op    

   wire  [82:0]        mem_write_data_age6;
   wire  [31:0]        last_accessed_age6;  // read back time by age6 checker
   wire  [31:0]        time_since_lst_acc_age6;  // time since6 last accessed age6
   wire  [31:0]        time_since_lst_acc6; // time since6 last accessed address
   wire                age_check_active6;   // bit 0 of status register           

// Parameters6 for Address Checking6 FSM6 states6
   parameter idle6           = 3'b000;
   parameter inval_aged_rd6  = 3'b001;
   parameter inval_aged_wr6  = 3'b010;
   parameter inval_all6      = 3'b011;
   parameter age_chk6        = 3'b100;

   parameter max_addr       = 8'hff;
   parameter max_cnt6        = 32'hffff_ffff;

// -----------------------------------------------------------------------------
//   Generate6 current time counter
// -----------------------------------------------------------------------------
always @ (posedge pclk6 or negedge n_p_reset6)
   begin
   if (~n_p_reset6)
      clk_div_cnt6 <= 8'd0;
   else if (clk_div_cnt6 == div_clk6)
      clk_div_cnt6 <= 8'd0; 
   else 
      clk_div_cnt6 <= clk_div_cnt6 + 1'd1;
   end


always @ (posedge pclk6 or negedge n_p_reset6)
   begin
   if (~n_p_reset6)
      curr_time6 <= 32'd0;
   else if (clk_div_cnt6 == div_clk6)
      curr_time6 <= curr_time6 + 1'd1;
   end


// -----------------------------------------------------------------------------
//   Age6 checker State6 Machine6 
// -----------------------------------------------------------------------------
always @ (command or check_age6 or age_chk_state6 or age_confirmed6 or age_ok6 or
          mem_addr_age6 or mem_read_data_age6[82])
   begin
      case (age_chk_state6)
      
      idle6:
         if (command == 2'b10)
            nxt_age_chk_state6 = inval_aged_rd6;
         else if (command == 2'b11)
            nxt_age_chk_state6 = inval_all6;
         else if (check_age6)
            nxt_age_chk_state6 = age_chk6;
         else
            nxt_age_chk_state6 = idle6;

      inval_aged_rd6:
            nxt_age_chk_state6 = age_chk6;

      inval_aged_wr6:
            nxt_age_chk_state6 = idle6;

      inval_all6:
         if (mem_addr_age6 != max_addr)
            nxt_age_chk_state6 = inval_all6;  // move6 onto6 next address
         else
            nxt_age_chk_state6 = idle6;

      age_chk6:
         if (age_confirmed6)
            begin
            if (add_check_active6)                     // age6 check for addr chkr6
               nxt_age_chk_state6 = idle6;
            else if (~mem_read_data_age6[82])      // invalid, check next location6
               nxt_age_chk_state6 = inval_aged_rd6; 
            else if (~age_ok6 & mem_read_data_age6[82]) // out of date6, clear 
               nxt_age_chk_state6 = inval_aged_wr6;
            else if (mem_addr_age6 == max_addr)    // full check completed
               nxt_age_chk_state6 = idle6;     
            else 
               nxt_age_chk_state6 = inval_aged_rd6; // age6 ok, check next location6 
            end       
         else
            nxt_age_chk_state6 = age_chk6;

      default:
            nxt_age_chk_state6 = idle6;
      endcase
   end



always @ (posedge pclk6 or negedge n_p_reset6)
   begin
   if (~n_p_reset6)
      age_chk_state6 <= idle6;
   else
      age_chk_state6 <= nxt_age_chk_state6;
   end


// -----------------------------------------------------------------------------
//   Generate6 memory RW bus for accessing array when requested6 to invalidate6 all
//   aged6 addresses6 and all addresses6.
// -----------------------------------------------------------------------------
always @ (posedge pclk6 or negedge n_p_reset6)
   begin
   if (~n_p_reset6)
   begin
      mem_addr_age6 <= 8'd0;     
      mem_write_age6 <= 1'd0;    
   end
   else if (age_chk_state6 == inval_aged_rd6)  // invalidate6 aged6 read
   begin
      mem_addr_age6 <= mem_addr_age6 + 1'd1;     
      mem_write_age6 <= 1'd0;    
   end
   else if (age_chk_state6 == inval_aged_wr6)  // invalidate6 aged6 read
   begin
      mem_addr_age6 <= mem_addr_age6;     
      mem_write_age6 <= 1'd1;    
   end
   else if (age_chk_state6 == inval_all6)  // invalidate6 all
   begin
      mem_addr_age6 <= mem_addr_age6 + 1'd1;     
      mem_write_age6 <= 1'd1;    
   end
   else if (age_chk_state6 == age_chk6)
   begin
      mem_addr_age6 <= mem_addr_age6;     
      mem_write_age6 <= mem_write_age6;    
   end
   else 
   begin
      mem_addr_age6 <= mem_addr_age6;     
      mem_write_age6 <= 1'd0;    
   end
   end

// age6 checker will only ever6 write zero values to ALUT6 mem
assign mem_write_data_age6 = 83'd0;



// -----------------------------------------------------------------------------
//   Generate6 invalidate6 in progress6 flag6 (bit 1 of status register)
// -----------------------------------------------------------------------------
always @ (posedge pclk6 or negedge n_p_reset6)
   begin
   if (~n_p_reset6)
      inval_in_prog6 <= 1'd0;
   else if (age_chk_state6 == inval_aged_wr6) 
      inval_in_prog6 <= 1'd1;
   else if ((age_chk_state6 == age_chk6) & (mem_addr_age6 == max_addr))
      inval_in_prog6 <= 1'd0;
   else
      inval_in_prog6 <= inval_in_prog6;
   end


// -----------------------------------------------------------------------------
//   Calculate6 whether6 data is still in date6.  Need6 to work6 out the real time
//   gap6 between current time and last accessed.  If6 this gap6 is greater than
//   the best6 before age6, then6 the data is out of date6. 
// -----------------------------------------------------------------------------
assign time_since_lst_acc6 = (curr_time6 > last_accessed6) ? 
                            (curr_time6 - last_accessed6) :  // no cnt wrapping6
                            (curr_time6 + (max_cnt6 - last_accessed6));

assign time_since_lst_acc_age6 = (curr_time6 > last_accessed_age6) ? 
                                (curr_time6 - last_accessed_age6) : // no wrapping6
                                (curr_time6 + (max_cnt6 - last_accessed_age6));


always @ (posedge pclk6 or negedge n_p_reset6)
   begin
   if (~n_p_reset6)
      begin
      age_ok6 <= 1'b0;
      age_confirmed6 <= 1'b0;
      end
   else if ((age_chk_state6 == age_chk6) & add_check_active6) 
      begin                                       // age6 checking for addr chkr6
      if (best_bfr_age6 > time_since_lst_acc6)      // still in date6
         begin
         age_ok6 <= 1'b1;
         age_confirmed6 <= 1'b1;
         end
      else   // out of date6
         begin
         age_ok6 <= 1'b0;
         age_confirmed6 <= 1'b1;
         end
      end
   else if ((age_chk_state6 == age_chk6) & ~add_check_active6)
      begin                                      // age6 checking for inval6 aged6
      if (best_bfr_age6 > time_since_lst_acc_age6) // still in date6
         begin
         age_ok6 <= 1'b1;
         age_confirmed6 <= 1'b1;
         end
      else   // out of date6
         begin
         age_ok6 <= 1'b0;
         age_confirmed6 <= 1'b1;
         end
      end
   else
      begin
      age_ok6 <= 1'b0;
      age_confirmed6 <= 1'b0;
      end
   end



// -----------------------------------------------------------------------------
//   Generate6 last address and port that was cleared6 in the invalid aged6 process
// -----------------------------------------------------------------------------
always @ (posedge pclk6 or negedge n_p_reset6)
   begin
   if (~n_p_reset6)
      begin
      lst_inv_addr_cmd6 <= 48'd0;
      lst_inv_port_cmd6 <= 2'd0;
      end
   else if (age_chk_state6 == inval_aged_wr6)
      begin
      lst_inv_addr_cmd6 <= mem_read_data_age6[47:0];
      lst_inv_port_cmd6 <= mem_read_data_age6[49:48];
      end
   else 
      begin
      lst_inv_addr_cmd6 <= lst_inv_addr_cmd6;
      lst_inv_port_cmd6 <= lst_inv_port_cmd6;
      end
   end


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded6 off6 age_chk_state6
// -----------------------------------------------------------------------------
assign age_check_active6 = (age_chk_state6 != 3'b000);

endmodule

