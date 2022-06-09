//File12 name   : alut_age_checker12.v
//Title12       : 
//Created12     : 1999
//Description12 : 
//Notes12       : 
//----------------------------------------------------------------------
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------

module alut_age_checker12
(   
   // Inputs12
   pclk12,
   n_p_reset12,
   command,          
   div_clk12,          
   mem_read_data_age12,
   check_age12,        
   last_accessed12, 
   best_bfr_age12,   
   add_check_active12,

   // outputs12
   curr_time12,         
   mem_addr_age12,      
   mem_write_age12,     
   mem_write_data_age12,
   lst_inv_addr_cmd12,    
   lst_inv_port_cmd12,  
   age_confirmed12,     
   age_ok12,
   inval_in_prog12,  
   age_check_active12          
);   

   input               pclk12;               // APB12 clock12                           
   input               n_p_reset12;          // Reset12                               
   input [1:0]         command;            // command bus                        
   input [7:0]         div_clk12;            // clock12 divider12 value
   input [82:0]        mem_read_data_age12;  // read data from memory             
   input               check_age12;          // request flag12 for age12 check
   input [31:0]        last_accessed12;      // time field sent12 for age12 check
   input [31:0]        best_bfr_age12;       // best12 before age12
   input               add_check_active12;   // active flag12 from address checker

   output [31:0]       curr_time12;          // current time,for storing12 in mem    
   output [7:0]        mem_addr_age12;       // address for R/W12 to memory     
   output              mem_write_age12;      // R/W12 flag12 (write = high12)            
   output [82:0]       mem_write_data_age12; // write data for memory             
   output [47:0]       lst_inv_addr_cmd12;   // last invalidated12 addr normal12 op    
   output [1:0]        lst_inv_port_cmd12;   // last invalidated12 port normal12 op    
   output              age_confirmed12;      // validates12 age_ok12 result 
   output              age_ok12;             // age12 checker result - set means12 in-date12
   output              inval_in_prog12;      // invalidation12 in progress12
   output              age_check_active12;   // bit 0 of status register           

   reg  [2:0]          age_chk_state12;      // age12 checker FSM12 current state
   reg  [2:0]          nxt_age_chk_state12;  // age12 checker FSM12 next state
   reg  [7:0]          mem_addr_age12;     
   reg                 mem_write_age12;    
   reg                 inval_in_prog12;      // invalidation12 in progress12
   reg  [7:0]          clk_div_cnt12;        // clock12 divider12 counter
   reg  [31:0]         curr_time12;          // current time,for storing12 in mem  
   reg                 age_confirmed12;      // validates12 age_ok12 result 
   reg                 age_ok12;             // age12 checker result - set means12 in-date12
   reg [47:0]          lst_inv_addr_cmd12;   // last invalidated12 addr normal12 op    
   reg [1:0]           lst_inv_port_cmd12;   // last invalidated12 port normal12 op    

   wire  [82:0]        mem_write_data_age12;
   wire  [31:0]        last_accessed_age12;  // read back time by age12 checker
   wire  [31:0]        time_since_lst_acc_age12;  // time since12 last accessed age12
   wire  [31:0]        time_since_lst_acc12; // time since12 last accessed address
   wire                age_check_active12;   // bit 0 of status register           

// Parameters12 for Address Checking12 FSM12 states12
   parameter idle12           = 3'b000;
   parameter inval_aged_rd12  = 3'b001;
   parameter inval_aged_wr12  = 3'b010;
   parameter inval_all12      = 3'b011;
   parameter age_chk12        = 3'b100;

   parameter max_addr       = 8'hff;
   parameter max_cnt12        = 32'hffff_ffff;

// -----------------------------------------------------------------------------
//   Generate12 current time counter
// -----------------------------------------------------------------------------
always @ (posedge pclk12 or negedge n_p_reset12)
   begin
   if (~n_p_reset12)
      clk_div_cnt12 <= 8'd0;
   else if (clk_div_cnt12 == div_clk12)
      clk_div_cnt12 <= 8'd0; 
   else 
      clk_div_cnt12 <= clk_div_cnt12 + 1'd1;
   end


always @ (posedge pclk12 or negedge n_p_reset12)
   begin
   if (~n_p_reset12)
      curr_time12 <= 32'd0;
   else if (clk_div_cnt12 == div_clk12)
      curr_time12 <= curr_time12 + 1'd1;
   end


// -----------------------------------------------------------------------------
//   Age12 checker State12 Machine12 
// -----------------------------------------------------------------------------
always @ (command or check_age12 or age_chk_state12 or age_confirmed12 or age_ok12 or
          mem_addr_age12 or mem_read_data_age12[82])
   begin
      case (age_chk_state12)
      
      idle12:
         if (command == 2'b10)
            nxt_age_chk_state12 = inval_aged_rd12;
         else if (command == 2'b11)
            nxt_age_chk_state12 = inval_all12;
         else if (check_age12)
            nxt_age_chk_state12 = age_chk12;
         else
            nxt_age_chk_state12 = idle12;

      inval_aged_rd12:
            nxt_age_chk_state12 = age_chk12;

      inval_aged_wr12:
            nxt_age_chk_state12 = idle12;

      inval_all12:
         if (mem_addr_age12 != max_addr)
            nxt_age_chk_state12 = inval_all12;  // move12 onto12 next address
         else
            nxt_age_chk_state12 = idle12;

      age_chk12:
         if (age_confirmed12)
            begin
            if (add_check_active12)                     // age12 check for addr chkr12
               nxt_age_chk_state12 = idle12;
            else if (~mem_read_data_age12[82])      // invalid, check next location12
               nxt_age_chk_state12 = inval_aged_rd12; 
            else if (~age_ok12 & mem_read_data_age12[82]) // out of date12, clear 
               nxt_age_chk_state12 = inval_aged_wr12;
            else if (mem_addr_age12 == max_addr)    // full check completed
               nxt_age_chk_state12 = idle12;     
            else 
               nxt_age_chk_state12 = inval_aged_rd12; // age12 ok, check next location12 
            end       
         else
            nxt_age_chk_state12 = age_chk12;

      default:
            nxt_age_chk_state12 = idle12;
      endcase
   end



always @ (posedge pclk12 or negedge n_p_reset12)
   begin
   if (~n_p_reset12)
      age_chk_state12 <= idle12;
   else
      age_chk_state12 <= nxt_age_chk_state12;
   end


// -----------------------------------------------------------------------------
//   Generate12 memory RW bus for accessing array when requested12 to invalidate12 all
//   aged12 addresses12 and all addresses12.
// -----------------------------------------------------------------------------
always @ (posedge pclk12 or negedge n_p_reset12)
   begin
   if (~n_p_reset12)
   begin
      mem_addr_age12 <= 8'd0;     
      mem_write_age12 <= 1'd0;    
   end
   else if (age_chk_state12 == inval_aged_rd12)  // invalidate12 aged12 read
   begin
      mem_addr_age12 <= mem_addr_age12 + 1'd1;     
      mem_write_age12 <= 1'd0;    
   end
   else if (age_chk_state12 == inval_aged_wr12)  // invalidate12 aged12 read
   begin
      mem_addr_age12 <= mem_addr_age12;     
      mem_write_age12 <= 1'd1;    
   end
   else if (age_chk_state12 == inval_all12)  // invalidate12 all
   begin
      mem_addr_age12 <= mem_addr_age12 + 1'd1;     
      mem_write_age12 <= 1'd1;    
   end
   else if (age_chk_state12 == age_chk12)
   begin
      mem_addr_age12 <= mem_addr_age12;     
      mem_write_age12 <= mem_write_age12;    
   end
   else 
   begin
      mem_addr_age12 <= mem_addr_age12;     
      mem_write_age12 <= 1'd0;    
   end
   end

// age12 checker will only ever12 write zero values to ALUT12 mem
assign mem_write_data_age12 = 83'd0;



// -----------------------------------------------------------------------------
//   Generate12 invalidate12 in progress12 flag12 (bit 1 of status register)
// -----------------------------------------------------------------------------
always @ (posedge pclk12 or negedge n_p_reset12)
   begin
   if (~n_p_reset12)
      inval_in_prog12 <= 1'd0;
   else if (age_chk_state12 == inval_aged_wr12) 
      inval_in_prog12 <= 1'd1;
   else if ((age_chk_state12 == age_chk12) & (mem_addr_age12 == max_addr))
      inval_in_prog12 <= 1'd0;
   else
      inval_in_prog12 <= inval_in_prog12;
   end


// -----------------------------------------------------------------------------
//   Calculate12 whether12 data is still in date12.  Need12 to work12 out the real time
//   gap12 between current time and last accessed.  If12 this gap12 is greater than
//   the best12 before age12, then12 the data is out of date12. 
// -----------------------------------------------------------------------------
assign time_since_lst_acc12 = (curr_time12 > last_accessed12) ? 
                            (curr_time12 - last_accessed12) :  // no cnt wrapping12
                            (curr_time12 + (max_cnt12 - last_accessed12));

assign time_since_lst_acc_age12 = (curr_time12 > last_accessed_age12) ? 
                                (curr_time12 - last_accessed_age12) : // no wrapping12
                                (curr_time12 + (max_cnt12 - last_accessed_age12));


always @ (posedge pclk12 or negedge n_p_reset12)
   begin
   if (~n_p_reset12)
      begin
      age_ok12 <= 1'b0;
      age_confirmed12 <= 1'b0;
      end
   else if ((age_chk_state12 == age_chk12) & add_check_active12) 
      begin                                       // age12 checking for addr chkr12
      if (best_bfr_age12 > time_since_lst_acc12)      // still in date12
         begin
         age_ok12 <= 1'b1;
         age_confirmed12 <= 1'b1;
         end
      else   // out of date12
         begin
         age_ok12 <= 1'b0;
         age_confirmed12 <= 1'b1;
         end
      end
   else if ((age_chk_state12 == age_chk12) & ~add_check_active12)
      begin                                      // age12 checking for inval12 aged12
      if (best_bfr_age12 > time_since_lst_acc_age12) // still in date12
         begin
         age_ok12 <= 1'b1;
         age_confirmed12 <= 1'b1;
         end
      else   // out of date12
         begin
         age_ok12 <= 1'b0;
         age_confirmed12 <= 1'b1;
         end
      end
   else
      begin
      age_ok12 <= 1'b0;
      age_confirmed12 <= 1'b0;
      end
   end



// -----------------------------------------------------------------------------
//   Generate12 last address and port that was cleared12 in the invalid aged12 process
// -----------------------------------------------------------------------------
always @ (posedge pclk12 or negedge n_p_reset12)
   begin
   if (~n_p_reset12)
      begin
      lst_inv_addr_cmd12 <= 48'd0;
      lst_inv_port_cmd12 <= 2'd0;
      end
   else if (age_chk_state12 == inval_aged_wr12)
      begin
      lst_inv_addr_cmd12 <= mem_read_data_age12[47:0];
      lst_inv_port_cmd12 <= mem_read_data_age12[49:48];
      end
   else 
      begin
      lst_inv_addr_cmd12 <= lst_inv_addr_cmd12;
      lst_inv_port_cmd12 <= lst_inv_port_cmd12;
      end
   end


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded12 off12 age_chk_state12
// -----------------------------------------------------------------------------
assign age_check_active12 = (age_chk_state12 != 3'b000);

endmodule

