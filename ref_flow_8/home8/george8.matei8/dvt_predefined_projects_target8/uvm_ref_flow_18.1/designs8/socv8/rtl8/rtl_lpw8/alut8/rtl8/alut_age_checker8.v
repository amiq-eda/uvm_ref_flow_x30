//File8 name   : alut_age_checker8.v
//Title8       : 
//Created8     : 1999
//Description8 : 
//Notes8       : 
//----------------------------------------------------------------------
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------

module alut_age_checker8
(   
   // Inputs8
   pclk8,
   n_p_reset8,
   command,          
   div_clk8,          
   mem_read_data_age8,
   check_age8,        
   last_accessed8, 
   best_bfr_age8,   
   add_check_active8,

   // outputs8
   curr_time8,         
   mem_addr_age8,      
   mem_write_age8,     
   mem_write_data_age8,
   lst_inv_addr_cmd8,    
   lst_inv_port_cmd8,  
   age_confirmed8,     
   age_ok8,
   inval_in_prog8,  
   age_check_active8          
);   

   input               pclk8;               // APB8 clock8                           
   input               n_p_reset8;          // Reset8                               
   input [1:0]         command;            // command bus                        
   input [7:0]         div_clk8;            // clock8 divider8 value
   input [82:0]        mem_read_data_age8;  // read data from memory             
   input               check_age8;          // request flag8 for age8 check
   input [31:0]        last_accessed8;      // time field sent8 for age8 check
   input [31:0]        best_bfr_age8;       // best8 before age8
   input               add_check_active8;   // active flag8 from address checker

   output [31:0]       curr_time8;          // current time,for storing8 in mem    
   output [7:0]        mem_addr_age8;       // address for R/W8 to memory     
   output              mem_write_age8;      // R/W8 flag8 (write = high8)            
   output [82:0]       mem_write_data_age8; // write data for memory             
   output [47:0]       lst_inv_addr_cmd8;   // last invalidated8 addr normal8 op    
   output [1:0]        lst_inv_port_cmd8;   // last invalidated8 port normal8 op    
   output              age_confirmed8;      // validates8 age_ok8 result 
   output              age_ok8;             // age8 checker result - set means8 in-date8
   output              inval_in_prog8;      // invalidation8 in progress8
   output              age_check_active8;   // bit 0 of status register           

   reg  [2:0]          age_chk_state8;      // age8 checker FSM8 current state
   reg  [2:0]          nxt_age_chk_state8;  // age8 checker FSM8 next state
   reg  [7:0]          mem_addr_age8;     
   reg                 mem_write_age8;    
   reg                 inval_in_prog8;      // invalidation8 in progress8
   reg  [7:0]          clk_div_cnt8;        // clock8 divider8 counter
   reg  [31:0]         curr_time8;          // current time,for storing8 in mem  
   reg                 age_confirmed8;      // validates8 age_ok8 result 
   reg                 age_ok8;             // age8 checker result - set means8 in-date8
   reg [47:0]          lst_inv_addr_cmd8;   // last invalidated8 addr normal8 op    
   reg [1:0]           lst_inv_port_cmd8;   // last invalidated8 port normal8 op    

   wire  [82:0]        mem_write_data_age8;
   wire  [31:0]        last_accessed_age8;  // read back time by age8 checker
   wire  [31:0]        time_since_lst_acc_age8;  // time since8 last accessed age8
   wire  [31:0]        time_since_lst_acc8; // time since8 last accessed address
   wire                age_check_active8;   // bit 0 of status register           

// Parameters8 for Address Checking8 FSM8 states8
   parameter idle8           = 3'b000;
   parameter inval_aged_rd8  = 3'b001;
   parameter inval_aged_wr8  = 3'b010;
   parameter inval_all8      = 3'b011;
   parameter age_chk8        = 3'b100;

   parameter max_addr       = 8'hff;
   parameter max_cnt8        = 32'hffff_ffff;

// -----------------------------------------------------------------------------
//   Generate8 current time counter
// -----------------------------------------------------------------------------
always @ (posedge pclk8 or negedge n_p_reset8)
   begin
   if (~n_p_reset8)
      clk_div_cnt8 <= 8'd0;
   else if (clk_div_cnt8 == div_clk8)
      clk_div_cnt8 <= 8'd0; 
   else 
      clk_div_cnt8 <= clk_div_cnt8 + 1'd1;
   end


always @ (posedge pclk8 or negedge n_p_reset8)
   begin
   if (~n_p_reset8)
      curr_time8 <= 32'd0;
   else if (clk_div_cnt8 == div_clk8)
      curr_time8 <= curr_time8 + 1'd1;
   end


// -----------------------------------------------------------------------------
//   Age8 checker State8 Machine8 
// -----------------------------------------------------------------------------
always @ (command or check_age8 or age_chk_state8 or age_confirmed8 or age_ok8 or
          mem_addr_age8 or mem_read_data_age8[82])
   begin
      case (age_chk_state8)
      
      idle8:
         if (command == 2'b10)
            nxt_age_chk_state8 = inval_aged_rd8;
         else if (command == 2'b11)
            nxt_age_chk_state8 = inval_all8;
         else if (check_age8)
            nxt_age_chk_state8 = age_chk8;
         else
            nxt_age_chk_state8 = idle8;

      inval_aged_rd8:
            nxt_age_chk_state8 = age_chk8;

      inval_aged_wr8:
            nxt_age_chk_state8 = idle8;

      inval_all8:
         if (mem_addr_age8 != max_addr)
            nxt_age_chk_state8 = inval_all8;  // move8 onto8 next address
         else
            nxt_age_chk_state8 = idle8;

      age_chk8:
         if (age_confirmed8)
            begin
            if (add_check_active8)                     // age8 check for addr chkr8
               nxt_age_chk_state8 = idle8;
            else if (~mem_read_data_age8[82])      // invalid, check next location8
               nxt_age_chk_state8 = inval_aged_rd8; 
            else if (~age_ok8 & mem_read_data_age8[82]) // out of date8, clear 
               nxt_age_chk_state8 = inval_aged_wr8;
            else if (mem_addr_age8 == max_addr)    // full check completed
               nxt_age_chk_state8 = idle8;     
            else 
               nxt_age_chk_state8 = inval_aged_rd8; // age8 ok, check next location8 
            end       
         else
            nxt_age_chk_state8 = age_chk8;

      default:
            nxt_age_chk_state8 = idle8;
      endcase
   end



always @ (posedge pclk8 or negedge n_p_reset8)
   begin
   if (~n_p_reset8)
      age_chk_state8 <= idle8;
   else
      age_chk_state8 <= nxt_age_chk_state8;
   end


// -----------------------------------------------------------------------------
//   Generate8 memory RW bus for accessing array when requested8 to invalidate8 all
//   aged8 addresses8 and all addresses8.
// -----------------------------------------------------------------------------
always @ (posedge pclk8 or negedge n_p_reset8)
   begin
   if (~n_p_reset8)
   begin
      mem_addr_age8 <= 8'd0;     
      mem_write_age8 <= 1'd0;    
   end
   else if (age_chk_state8 == inval_aged_rd8)  // invalidate8 aged8 read
   begin
      mem_addr_age8 <= mem_addr_age8 + 1'd1;     
      mem_write_age8 <= 1'd0;    
   end
   else if (age_chk_state8 == inval_aged_wr8)  // invalidate8 aged8 read
   begin
      mem_addr_age8 <= mem_addr_age8;     
      mem_write_age8 <= 1'd1;    
   end
   else if (age_chk_state8 == inval_all8)  // invalidate8 all
   begin
      mem_addr_age8 <= mem_addr_age8 + 1'd1;     
      mem_write_age8 <= 1'd1;    
   end
   else if (age_chk_state8 == age_chk8)
   begin
      mem_addr_age8 <= mem_addr_age8;     
      mem_write_age8 <= mem_write_age8;    
   end
   else 
   begin
      mem_addr_age8 <= mem_addr_age8;     
      mem_write_age8 <= 1'd0;    
   end
   end

// age8 checker will only ever8 write zero values to ALUT8 mem
assign mem_write_data_age8 = 83'd0;



// -----------------------------------------------------------------------------
//   Generate8 invalidate8 in progress8 flag8 (bit 1 of status register)
// -----------------------------------------------------------------------------
always @ (posedge pclk8 or negedge n_p_reset8)
   begin
   if (~n_p_reset8)
      inval_in_prog8 <= 1'd0;
   else if (age_chk_state8 == inval_aged_wr8) 
      inval_in_prog8 <= 1'd1;
   else if ((age_chk_state8 == age_chk8) & (mem_addr_age8 == max_addr))
      inval_in_prog8 <= 1'd0;
   else
      inval_in_prog8 <= inval_in_prog8;
   end


// -----------------------------------------------------------------------------
//   Calculate8 whether8 data is still in date8.  Need8 to work8 out the real time
//   gap8 between current time and last accessed.  If8 this gap8 is greater than
//   the best8 before age8, then8 the data is out of date8. 
// -----------------------------------------------------------------------------
assign time_since_lst_acc8 = (curr_time8 > last_accessed8) ? 
                            (curr_time8 - last_accessed8) :  // no cnt wrapping8
                            (curr_time8 + (max_cnt8 - last_accessed8));

assign time_since_lst_acc_age8 = (curr_time8 > last_accessed_age8) ? 
                                (curr_time8 - last_accessed_age8) : // no wrapping8
                                (curr_time8 + (max_cnt8 - last_accessed_age8));


always @ (posedge pclk8 or negedge n_p_reset8)
   begin
   if (~n_p_reset8)
      begin
      age_ok8 <= 1'b0;
      age_confirmed8 <= 1'b0;
      end
   else if ((age_chk_state8 == age_chk8) & add_check_active8) 
      begin                                       // age8 checking for addr chkr8
      if (best_bfr_age8 > time_since_lst_acc8)      // still in date8
         begin
         age_ok8 <= 1'b1;
         age_confirmed8 <= 1'b1;
         end
      else   // out of date8
         begin
         age_ok8 <= 1'b0;
         age_confirmed8 <= 1'b1;
         end
      end
   else if ((age_chk_state8 == age_chk8) & ~add_check_active8)
      begin                                      // age8 checking for inval8 aged8
      if (best_bfr_age8 > time_since_lst_acc_age8) // still in date8
         begin
         age_ok8 <= 1'b1;
         age_confirmed8 <= 1'b1;
         end
      else   // out of date8
         begin
         age_ok8 <= 1'b0;
         age_confirmed8 <= 1'b1;
         end
      end
   else
      begin
      age_ok8 <= 1'b0;
      age_confirmed8 <= 1'b0;
      end
   end



// -----------------------------------------------------------------------------
//   Generate8 last address and port that was cleared8 in the invalid aged8 process
// -----------------------------------------------------------------------------
always @ (posedge pclk8 or negedge n_p_reset8)
   begin
   if (~n_p_reset8)
      begin
      lst_inv_addr_cmd8 <= 48'd0;
      lst_inv_port_cmd8 <= 2'd0;
      end
   else if (age_chk_state8 == inval_aged_wr8)
      begin
      lst_inv_addr_cmd8 <= mem_read_data_age8[47:0];
      lst_inv_port_cmd8 <= mem_read_data_age8[49:48];
      end
   else 
      begin
      lst_inv_addr_cmd8 <= lst_inv_addr_cmd8;
      lst_inv_port_cmd8 <= lst_inv_port_cmd8;
      end
   end


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded8 off8 age_chk_state8
// -----------------------------------------------------------------------------
assign age_check_active8 = (age_chk_state8 != 3'b000);

endmodule

