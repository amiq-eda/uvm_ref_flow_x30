//File10 name   : alut_age_checker10.v
//Title10       : 
//Created10     : 1999
//Description10 : 
//Notes10       : 
//----------------------------------------------------------------------
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------

module alut_age_checker10
(   
   // Inputs10
   pclk10,
   n_p_reset10,
   command,          
   div_clk10,          
   mem_read_data_age10,
   check_age10,        
   last_accessed10, 
   best_bfr_age10,   
   add_check_active10,

   // outputs10
   curr_time10,         
   mem_addr_age10,      
   mem_write_age10,     
   mem_write_data_age10,
   lst_inv_addr_cmd10,    
   lst_inv_port_cmd10,  
   age_confirmed10,     
   age_ok10,
   inval_in_prog10,  
   age_check_active10          
);   

   input               pclk10;               // APB10 clock10                           
   input               n_p_reset10;          // Reset10                               
   input [1:0]         command;            // command bus                        
   input [7:0]         div_clk10;            // clock10 divider10 value
   input [82:0]        mem_read_data_age10;  // read data from memory             
   input               check_age10;          // request flag10 for age10 check
   input [31:0]        last_accessed10;      // time field sent10 for age10 check
   input [31:0]        best_bfr_age10;       // best10 before age10
   input               add_check_active10;   // active flag10 from address checker

   output [31:0]       curr_time10;          // current time,for storing10 in mem    
   output [7:0]        mem_addr_age10;       // address for R/W10 to memory     
   output              mem_write_age10;      // R/W10 flag10 (write = high10)            
   output [82:0]       mem_write_data_age10; // write data for memory             
   output [47:0]       lst_inv_addr_cmd10;   // last invalidated10 addr normal10 op    
   output [1:0]        lst_inv_port_cmd10;   // last invalidated10 port normal10 op    
   output              age_confirmed10;      // validates10 age_ok10 result 
   output              age_ok10;             // age10 checker result - set means10 in-date10
   output              inval_in_prog10;      // invalidation10 in progress10
   output              age_check_active10;   // bit 0 of status register           

   reg  [2:0]          age_chk_state10;      // age10 checker FSM10 current state
   reg  [2:0]          nxt_age_chk_state10;  // age10 checker FSM10 next state
   reg  [7:0]          mem_addr_age10;     
   reg                 mem_write_age10;    
   reg                 inval_in_prog10;      // invalidation10 in progress10
   reg  [7:0]          clk_div_cnt10;        // clock10 divider10 counter
   reg  [31:0]         curr_time10;          // current time,for storing10 in mem  
   reg                 age_confirmed10;      // validates10 age_ok10 result 
   reg                 age_ok10;             // age10 checker result - set means10 in-date10
   reg [47:0]          lst_inv_addr_cmd10;   // last invalidated10 addr normal10 op    
   reg [1:0]           lst_inv_port_cmd10;   // last invalidated10 port normal10 op    

   wire  [82:0]        mem_write_data_age10;
   wire  [31:0]        last_accessed_age10;  // read back time by age10 checker
   wire  [31:0]        time_since_lst_acc_age10;  // time since10 last accessed age10
   wire  [31:0]        time_since_lst_acc10; // time since10 last accessed address
   wire                age_check_active10;   // bit 0 of status register           

// Parameters10 for Address Checking10 FSM10 states10
   parameter idle10           = 3'b000;
   parameter inval_aged_rd10  = 3'b001;
   parameter inval_aged_wr10  = 3'b010;
   parameter inval_all10      = 3'b011;
   parameter age_chk10        = 3'b100;

   parameter max_addr       = 8'hff;
   parameter max_cnt10        = 32'hffff_ffff;

// -----------------------------------------------------------------------------
//   Generate10 current time counter
// -----------------------------------------------------------------------------
always @ (posedge pclk10 or negedge n_p_reset10)
   begin
   if (~n_p_reset10)
      clk_div_cnt10 <= 8'd0;
   else if (clk_div_cnt10 == div_clk10)
      clk_div_cnt10 <= 8'd0; 
   else 
      clk_div_cnt10 <= clk_div_cnt10 + 1'd1;
   end


always @ (posedge pclk10 or negedge n_p_reset10)
   begin
   if (~n_p_reset10)
      curr_time10 <= 32'd0;
   else if (clk_div_cnt10 == div_clk10)
      curr_time10 <= curr_time10 + 1'd1;
   end


// -----------------------------------------------------------------------------
//   Age10 checker State10 Machine10 
// -----------------------------------------------------------------------------
always @ (command or check_age10 or age_chk_state10 or age_confirmed10 or age_ok10 or
          mem_addr_age10 or mem_read_data_age10[82])
   begin
      case (age_chk_state10)
      
      idle10:
         if (command == 2'b10)
            nxt_age_chk_state10 = inval_aged_rd10;
         else if (command == 2'b11)
            nxt_age_chk_state10 = inval_all10;
         else if (check_age10)
            nxt_age_chk_state10 = age_chk10;
         else
            nxt_age_chk_state10 = idle10;

      inval_aged_rd10:
            nxt_age_chk_state10 = age_chk10;

      inval_aged_wr10:
            nxt_age_chk_state10 = idle10;

      inval_all10:
         if (mem_addr_age10 != max_addr)
            nxt_age_chk_state10 = inval_all10;  // move10 onto10 next address
         else
            nxt_age_chk_state10 = idle10;

      age_chk10:
         if (age_confirmed10)
            begin
            if (add_check_active10)                     // age10 check for addr chkr10
               nxt_age_chk_state10 = idle10;
            else if (~mem_read_data_age10[82])      // invalid, check next location10
               nxt_age_chk_state10 = inval_aged_rd10; 
            else if (~age_ok10 & mem_read_data_age10[82]) // out of date10, clear 
               nxt_age_chk_state10 = inval_aged_wr10;
            else if (mem_addr_age10 == max_addr)    // full check completed
               nxt_age_chk_state10 = idle10;     
            else 
               nxt_age_chk_state10 = inval_aged_rd10; // age10 ok, check next location10 
            end       
         else
            nxt_age_chk_state10 = age_chk10;

      default:
            nxt_age_chk_state10 = idle10;
      endcase
   end



always @ (posedge pclk10 or negedge n_p_reset10)
   begin
   if (~n_p_reset10)
      age_chk_state10 <= idle10;
   else
      age_chk_state10 <= nxt_age_chk_state10;
   end


// -----------------------------------------------------------------------------
//   Generate10 memory RW bus for accessing array when requested10 to invalidate10 all
//   aged10 addresses10 and all addresses10.
// -----------------------------------------------------------------------------
always @ (posedge pclk10 or negedge n_p_reset10)
   begin
   if (~n_p_reset10)
   begin
      mem_addr_age10 <= 8'd0;     
      mem_write_age10 <= 1'd0;    
   end
   else if (age_chk_state10 == inval_aged_rd10)  // invalidate10 aged10 read
   begin
      mem_addr_age10 <= mem_addr_age10 + 1'd1;     
      mem_write_age10 <= 1'd0;    
   end
   else if (age_chk_state10 == inval_aged_wr10)  // invalidate10 aged10 read
   begin
      mem_addr_age10 <= mem_addr_age10;     
      mem_write_age10 <= 1'd1;    
   end
   else if (age_chk_state10 == inval_all10)  // invalidate10 all
   begin
      mem_addr_age10 <= mem_addr_age10 + 1'd1;     
      mem_write_age10 <= 1'd1;    
   end
   else if (age_chk_state10 == age_chk10)
   begin
      mem_addr_age10 <= mem_addr_age10;     
      mem_write_age10 <= mem_write_age10;    
   end
   else 
   begin
      mem_addr_age10 <= mem_addr_age10;     
      mem_write_age10 <= 1'd0;    
   end
   end

// age10 checker will only ever10 write zero values to ALUT10 mem
assign mem_write_data_age10 = 83'd0;



// -----------------------------------------------------------------------------
//   Generate10 invalidate10 in progress10 flag10 (bit 1 of status register)
// -----------------------------------------------------------------------------
always @ (posedge pclk10 or negedge n_p_reset10)
   begin
   if (~n_p_reset10)
      inval_in_prog10 <= 1'd0;
   else if (age_chk_state10 == inval_aged_wr10) 
      inval_in_prog10 <= 1'd1;
   else if ((age_chk_state10 == age_chk10) & (mem_addr_age10 == max_addr))
      inval_in_prog10 <= 1'd0;
   else
      inval_in_prog10 <= inval_in_prog10;
   end


// -----------------------------------------------------------------------------
//   Calculate10 whether10 data is still in date10.  Need10 to work10 out the real time
//   gap10 between current time and last accessed.  If10 this gap10 is greater than
//   the best10 before age10, then10 the data is out of date10. 
// -----------------------------------------------------------------------------
assign time_since_lst_acc10 = (curr_time10 > last_accessed10) ? 
                            (curr_time10 - last_accessed10) :  // no cnt wrapping10
                            (curr_time10 + (max_cnt10 - last_accessed10));

assign time_since_lst_acc_age10 = (curr_time10 > last_accessed_age10) ? 
                                (curr_time10 - last_accessed_age10) : // no wrapping10
                                (curr_time10 + (max_cnt10 - last_accessed_age10));


always @ (posedge pclk10 or negedge n_p_reset10)
   begin
   if (~n_p_reset10)
      begin
      age_ok10 <= 1'b0;
      age_confirmed10 <= 1'b0;
      end
   else if ((age_chk_state10 == age_chk10) & add_check_active10) 
      begin                                       // age10 checking for addr chkr10
      if (best_bfr_age10 > time_since_lst_acc10)      // still in date10
         begin
         age_ok10 <= 1'b1;
         age_confirmed10 <= 1'b1;
         end
      else   // out of date10
         begin
         age_ok10 <= 1'b0;
         age_confirmed10 <= 1'b1;
         end
      end
   else if ((age_chk_state10 == age_chk10) & ~add_check_active10)
      begin                                      // age10 checking for inval10 aged10
      if (best_bfr_age10 > time_since_lst_acc_age10) // still in date10
         begin
         age_ok10 <= 1'b1;
         age_confirmed10 <= 1'b1;
         end
      else   // out of date10
         begin
         age_ok10 <= 1'b0;
         age_confirmed10 <= 1'b1;
         end
      end
   else
      begin
      age_ok10 <= 1'b0;
      age_confirmed10 <= 1'b0;
      end
   end



// -----------------------------------------------------------------------------
//   Generate10 last address and port that was cleared10 in the invalid aged10 process
// -----------------------------------------------------------------------------
always @ (posedge pclk10 or negedge n_p_reset10)
   begin
   if (~n_p_reset10)
      begin
      lst_inv_addr_cmd10 <= 48'd0;
      lst_inv_port_cmd10 <= 2'd0;
      end
   else if (age_chk_state10 == inval_aged_wr10)
      begin
      lst_inv_addr_cmd10 <= mem_read_data_age10[47:0];
      lst_inv_port_cmd10 <= mem_read_data_age10[49:48];
      end
   else 
      begin
      lst_inv_addr_cmd10 <= lst_inv_addr_cmd10;
      lst_inv_port_cmd10 <= lst_inv_port_cmd10;
      end
   end


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded10 off10 age_chk_state10
// -----------------------------------------------------------------------------
assign age_check_active10 = (age_chk_state10 != 3'b000);

endmodule

