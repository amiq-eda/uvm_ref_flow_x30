//File30 name   : alut_age_checker30.v
//Title30       : 
//Created30     : 1999
//Description30 : 
//Notes30       : 
//----------------------------------------------------------------------
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------

module alut_age_checker30
(   
   // Inputs30
   pclk30,
   n_p_reset30,
   command,          
   div_clk30,          
   mem_read_data_age30,
   check_age30,        
   last_accessed30, 
   best_bfr_age30,   
   add_check_active30,

   // outputs30
   curr_time30,         
   mem_addr_age30,      
   mem_write_age30,     
   mem_write_data_age30,
   lst_inv_addr_cmd30,    
   lst_inv_port_cmd30,  
   age_confirmed30,     
   age_ok30,
   inval_in_prog30,  
   age_check_active30          
);   

   input               pclk30;               // APB30 clock30                           
   input               n_p_reset30;          // Reset30                               
   input [1:0]         command;            // command bus                        
   input [7:0]         div_clk30;            // clock30 divider30 value
   input [82:0]        mem_read_data_age30;  // read data from memory             
   input               check_age30;          // request flag30 for age30 check
   input [31:0]        last_accessed30;      // time field sent30 for age30 check
   input [31:0]        best_bfr_age30;       // best30 before age30
   input               add_check_active30;   // active flag30 from address checker

   output [31:0]       curr_time30;          // current time,for storing30 in mem    
   output [7:0]        mem_addr_age30;       // address for R/W30 to memory     
   output              mem_write_age30;      // R/W30 flag30 (write = high30)            
   output [82:0]       mem_write_data_age30; // write data for memory             
   output [47:0]       lst_inv_addr_cmd30;   // last invalidated30 addr normal30 op    
   output [1:0]        lst_inv_port_cmd30;   // last invalidated30 port normal30 op    
   output              age_confirmed30;      // validates30 age_ok30 result 
   output              age_ok30;             // age30 checker result - set means30 in-date30
   output              inval_in_prog30;      // invalidation30 in progress30
   output              age_check_active30;   // bit 0 of status register           

   reg  [2:0]          age_chk_state30;      // age30 checker FSM30 current state
   reg  [2:0]          nxt_age_chk_state30;  // age30 checker FSM30 next state
   reg  [7:0]          mem_addr_age30;     
   reg                 mem_write_age30;    
   reg                 inval_in_prog30;      // invalidation30 in progress30
   reg  [7:0]          clk_div_cnt30;        // clock30 divider30 counter
   reg  [31:0]         curr_time30;          // current time,for storing30 in mem  
   reg                 age_confirmed30;      // validates30 age_ok30 result 
   reg                 age_ok30;             // age30 checker result - set means30 in-date30
   reg [47:0]          lst_inv_addr_cmd30;   // last invalidated30 addr normal30 op    
   reg [1:0]           lst_inv_port_cmd30;   // last invalidated30 port normal30 op    

   wire  [82:0]        mem_write_data_age30;
   wire  [31:0]        last_accessed_age30;  // read back time by age30 checker
   wire  [31:0]        time_since_lst_acc_age30;  // time since30 last accessed age30
   wire  [31:0]        time_since_lst_acc30; // time since30 last accessed address
   wire                age_check_active30;   // bit 0 of status register           

// Parameters30 for Address Checking30 FSM30 states30
   parameter idle30           = 3'b000;
   parameter inval_aged_rd30  = 3'b001;
   parameter inval_aged_wr30  = 3'b010;
   parameter inval_all30      = 3'b011;
   parameter age_chk30        = 3'b100;

   parameter max_addr       = 8'hff;
   parameter max_cnt30        = 32'hffff_ffff;

// -----------------------------------------------------------------------------
//   Generate30 current time counter
// -----------------------------------------------------------------------------
always @ (posedge pclk30 or negedge n_p_reset30)
   begin
   if (~n_p_reset30)
      clk_div_cnt30 <= 8'd0;
   else if (clk_div_cnt30 == div_clk30)
      clk_div_cnt30 <= 8'd0; 
   else 
      clk_div_cnt30 <= clk_div_cnt30 + 1'd1;
   end


always @ (posedge pclk30 or negedge n_p_reset30)
   begin
   if (~n_p_reset30)
      curr_time30 <= 32'd0;
   else if (clk_div_cnt30 == div_clk30)
      curr_time30 <= curr_time30 + 1'd1;
   end


// -----------------------------------------------------------------------------
//   Age30 checker State30 Machine30 
// -----------------------------------------------------------------------------
always @ (command or check_age30 or age_chk_state30 or age_confirmed30 or age_ok30 or
          mem_addr_age30 or mem_read_data_age30[82])
   begin
      case (age_chk_state30)
      
      idle30:
         if (command == 2'b10)
            nxt_age_chk_state30 = inval_aged_rd30;
         else if (command == 2'b11)
            nxt_age_chk_state30 = inval_all30;
         else if (check_age30)
            nxt_age_chk_state30 = age_chk30;
         else
            nxt_age_chk_state30 = idle30;

      inval_aged_rd30:
            nxt_age_chk_state30 = age_chk30;

      inval_aged_wr30:
            nxt_age_chk_state30 = idle30;

      inval_all30:
         if (mem_addr_age30 != max_addr)
            nxt_age_chk_state30 = inval_all30;  // move30 onto30 next address
         else
            nxt_age_chk_state30 = idle30;

      age_chk30:
         if (age_confirmed30)
            begin
            if (add_check_active30)                     // age30 check for addr chkr30
               nxt_age_chk_state30 = idle30;
            else if (~mem_read_data_age30[82])      // invalid, check next location30
               nxt_age_chk_state30 = inval_aged_rd30; 
            else if (~age_ok30 & mem_read_data_age30[82]) // out of date30, clear 
               nxt_age_chk_state30 = inval_aged_wr30;
            else if (mem_addr_age30 == max_addr)    // full check completed
               nxt_age_chk_state30 = idle30;     
            else 
               nxt_age_chk_state30 = inval_aged_rd30; // age30 ok, check next location30 
            end       
         else
            nxt_age_chk_state30 = age_chk30;

      default:
            nxt_age_chk_state30 = idle30;
      endcase
   end



always @ (posedge pclk30 or negedge n_p_reset30)
   begin
   if (~n_p_reset30)
      age_chk_state30 <= idle30;
   else
      age_chk_state30 <= nxt_age_chk_state30;
   end


// -----------------------------------------------------------------------------
//   Generate30 memory RW bus for accessing array when requested30 to invalidate30 all
//   aged30 addresses30 and all addresses30.
// -----------------------------------------------------------------------------
always @ (posedge pclk30 or negedge n_p_reset30)
   begin
   if (~n_p_reset30)
   begin
      mem_addr_age30 <= 8'd0;     
      mem_write_age30 <= 1'd0;    
   end
   else if (age_chk_state30 == inval_aged_rd30)  // invalidate30 aged30 read
   begin
      mem_addr_age30 <= mem_addr_age30 + 1'd1;     
      mem_write_age30 <= 1'd0;    
   end
   else if (age_chk_state30 == inval_aged_wr30)  // invalidate30 aged30 read
   begin
      mem_addr_age30 <= mem_addr_age30;     
      mem_write_age30 <= 1'd1;    
   end
   else if (age_chk_state30 == inval_all30)  // invalidate30 all
   begin
      mem_addr_age30 <= mem_addr_age30 + 1'd1;     
      mem_write_age30 <= 1'd1;    
   end
   else if (age_chk_state30 == age_chk30)
   begin
      mem_addr_age30 <= mem_addr_age30;     
      mem_write_age30 <= mem_write_age30;    
   end
   else 
   begin
      mem_addr_age30 <= mem_addr_age30;     
      mem_write_age30 <= 1'd0;    
   end
   end

// age30 checker will only ever30 write zero values to ALUT30 mem
assign mem_write_data_age30 = 83'd0;



// -----------------------------------------------------------------------------
//   Generate30 invalidate30 in progress30 flag30 (bit 1 of status register)
// -----------------------------------------------------------------------------
always @ (posedge pclk30 or negedge n_p_reset30)
   begin
   if (~n_p_reset30)
      inval_in_prog30 <= 1'd0;
   else if (age_chk_state30 == inval_aged_wr30) 
      inval_in_prog30 <= 1'd1;
   else if ((age_chk_state30 == age_chk30) & (mem_addr_age30 == max_addr))
      inval_in_prog30 <= 1'd0;
   else
      inval_in_prog30 <= inval_in_prog30;
   end


// -----------------------------------------------------------------------------
//   Calculate30 whether30 data is still in date30.  Need30 to work30 out the real time
//   gap30 between current time and last accessed.  If30 this gap30 is greater than
//   the best30 before age30, then30 the data is out of date30. 
// -----------------------------------------------------------------------------
assign time_since_lst_acc30 = (curr_time30 > last_accessed30) ? 
                            (curr_time30 - last_accessed30) :  // no cnt wrapping30
                            (curr_time30 + (max_cnt30 - last_accessed30));

assign time_since_lst_acc_age30 = (curr_time30 > last_accessed_age30) ? 
                                (curr_time30 - last_accessed_age30) : // no wrapping30
                                (curr_time30 + (max_cnt30 - last_accessed_age30));


always @ (posedge pclk30 or negedge n_p_reset30)
   begin
   if (~n_p_reset30)
      begin
      age_ok30 <= 1'b0;
      age_confirmed30 <= 1'b0;
      end
   else if ((age_chk_state30 == age_chk30) & add_check_active30) 
      begin                                       // age30 checking for addr chkr30
      if (best_bfr_age30 > time_since_lst_acc30)      // still in date30
         begin
         age_ok30 <= 1'b1;
         age_confirmed30 <= 1'b1;
         end
      else   // out of date30
         begin
         age_ok30 <= 1'b0;
         age_confirmed30 <= 1'b1;
         end
      end
   else if ((age_chk_state30 == age_chk30) & ~add_check_active30)
      begin                                      // age30 checking for inval30 aged30
      if (best_bfr_age30 > time_since_lst_acc_age30) // still in date30
         begin
         age_ok30 <= 1'b1;
         age_confirmed30 <= 1'b1;
         end
      else   // out of date30
         begin
         age_ok30 <= 1'b0;
         age_confirmed30 <= 1'b1;
         end
      end
   else
      begin
      age_ok30 <= 1'b0;
      age_confirmed30 <= 1'b0;
      end
   end



// -----------------------------------------------------------------------------
//   Generate30 last address and port that was cleared30 in the invalid aged30 process
// -----------------------------------------------------------------------------
always @ (posedge pclk30 or negedge n_p_reset30)
   begin
   if (~n_p_reset30)
      begin
      lst_inv_addr_cmd30 <= 48'd0;
      lst_inv_port_cmd30 <= 2'd0;
      end
   else if (age_chk_state30 == inval_aged_wr30)
      begin
      lst_inv_addr_cmd30 <= mem_read_data_age30[47:0];
      lst_inv_port_cmd30 <= mem_read_data_age30[49:48];
      end
   else 
      begin
      lst_inv_addr_cmd30 <= lst_inv_addr_cmd30;
      lst_inv_port_cmd30 <= lst_inv_port_cmd30;
      end
   end


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded30 off30 age_chk_state30
// -----------------------------------------------------------------------------
assign age_check_active30 = (age_chk_state30 != 3'b000);

endmodule

