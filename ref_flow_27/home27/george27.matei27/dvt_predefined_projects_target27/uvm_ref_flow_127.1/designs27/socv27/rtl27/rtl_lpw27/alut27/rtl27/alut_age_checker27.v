//File27 name   : alut_age_checker27.v
//Title27       : 
//Created27     : 1999
//Description27 : 
//Notes27       : 
//----------------------------------------------------------------------
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------

module alut_age_checker27
(   
   // Inputs27
   pclk27,
   n_p_reset27,
   command,          
   div_clk27,          
   mem_read_data_age27,
   check_age27,        
   last_accessed27, 
   best_bfr_age27,   
   add_check_active27,

   // outputs27
   curr_time27,         
   mem_addr_age27,      
   mem_write_age27,     
   mem_write_data_age27,
   lst_inv_addr_cmd27,    
   lst_inv_port_cmd27,  
   age_confirmed27,     
   age_ok27,
   inval_in_prog27,  
   age_check_active27          
);   

   input               pclk27;               // APB27 clock27                           
   input               n_p_reset27;          // Reset27                               
   input [1:0]         command;            // command bus                        
   input [7:0]         div_clk27;            // clock27 divider27 value
   input [82:0]        mem_read_data_age27;  // read data from memory             
   input               check_age27;          // request flag27 for age27 check
   input [31:0]        last_accessed27;      // time field sent27 for age27 check
   input [31:0]        best_bfr_age27;       // best27 before age27
   input               add_check_active27;   // active flag27 from address checker

   output [31:0]       curr_time27;          // current time,for storing27 in mem    
   output [7:0]        mem_addr_age27;       // address for R/W27 to memory     
   output              mem_write_age27;      // R/W27 flag27 (write = high27)            
   output [82:0]       mem_write_data_age27; // write data for memory             
   output [47:0]       lst_inv_addr_cmd27;   // last invalidated27 addr normal27 op    
   output [1:0]        lst_inv_port_cmd27;   // last invalidated27 port normal27 op    
   output              age_confirmed27;      // validates27 age_ok27 result 
   output              age_ok27;             // age27 checker result - set means27 in-date27
   output              inval_in_prog27;      // invalidation27 in progress27
   output              age_check_active27;   // bit 0 of status register           

   reg  [2:0]          age_chk_state27;      // age27 checker FSM27 current state
   reg  [2:0]          nxt_age_chk_state27;  // age27 checker FSM27 next state
   reg  [7:0]          mem_addr_age27;     
   reg                 mem_write_age27;    
   reg                 inval_in_prog27;      // invalidation27 in progress27
   reg  [7:0]          clk_div_cnt27;        // clock27 divider27 counter
   reg  [31:0]         curr_time27;          // current time,for storing27 in mem  
   reg                 age_confirmed27;      // validates27 age_ok27 result 
   reg                 age_ok27;             // age27 checker result - set means27 in-date27
   reg [47:0]          lst_inv_addr_cmd27;   // last invalidated27 addr normal27 op    
   reg [1:0]           lst_inv_port_cmd27;   // last invalidated27 port normal27 op    

   wire  [82:0]        mem_write_data_age27;
   wire  [31:0]        last_accessed_age27;  // read back time by age27 checker
   wire  [31:0]        time_since_lst_acc_age27;  // time since27 last accessed age27
   wire  [31:0]        time_since_lst_acc27; // time since27 last accessed address
   wire                age_check_active27;   // bit 0 of status register           

// Parameters27 for Address Checking27 FSM27 states27
   parameter idle27           = 3'b000;
   parameter inval_aged_rd27  = 3'b001;
   parameter inval_aged_wr27  = 3'b010;
   parameter inval_all27      = 3'b011;
   parameter age_chk27        = 3'b100;

   parameter max_addr       = 8'hff;
   parameter max_cnt27        = 32'hffff_ffff;

// -----------------------------------------------------------------------------
//   Generate27 current time counter
// -----------------------------------------------------------------------------
always @ (posedge pclk27 or negedge n_p_reset27)
   begin
   if (~n_p_reset27)
      clk_div_cnt27 <= 8'd0;
   else if (clk_div_cnt27 == div_clk27)
      clk_div_cnt27 <= 8'd0; 
   else 
      clk_div_cnt27 <= clk_div_cnt27 + 1'd1;
   end


always @ (posedge pclk27 or negedge n_p_reset27)
   begin
   if (~n_p_reset27)
      curr_time27 <= 32'd0;
   else if (clk_div_cnt27 == div_clk27)
      curr_time27 <= curr_time27 + 1'd1;
   end


// -----------------------------------------------------------------------------
//   Age27 checker State27 Machine27 
// -----------------------------------------------------------------------------
always @ (command or check_age27 or age_chk_state27 or age_confirmed27 or age_ok27 or
          mem_addr_age27 or mem_read_data_age27[82])
   begin
      case (age_chk_state27)
      
      idle27:
         if (command == 2'b10)
            nxt_age_chk_state27 = inval_aged_rd27;
         else if (command == 2'b11)
            nxt_age_chk_state27 = inval_all27;
         else if (check_age27)
            nxt_age_chk_state27 = age_chk27;
         else
            nxt_age_chk_state27 = idle27;

      inval_aged_rd27:
            nxt_age_chk_state27 = age_chk27;

      inval_aged_wr27:
            nxt_age_chk_state27 = idle27;

      inval_all27:
         if (mem_addr_age27 != max_addr)
            nxt_age_chk_state27 = inval_all27;  // move27 onto27 next address
         else
            nxt_age_chk_state27 = idle27;

      age_chk27:
         if (age_confirmed27)
            begin
            if (add_check_active27)                     // age27 check for addr chkr27
               nxt_age_chk_state27 = idle27;
            else if (~mem_read_data_age27[82])      // invalid, check next location27
               nxt_age_chk_state27 = inval_aged_rd27; 
            else if (~age_ok27 & mem_read_data_age27[82]) // out of date27, clear 
               nxt_age_chk_state27 = inval_aged_wr27;
            else if (mem_addr_age27 == max_addr)    // full check completed
               nxt_age_chk_state27 = idle27;     
            else 
               nxt_age_chk_state27 = inval_aged_rd27; // age27 ok, check next location27 
            end       
         else
            nxt_age_chk_state27 = age_chk27;

      default:
            nxt_age_chk_state27 = idle27;
      endcase
   end



always @ (posedge pclk27 or negedge n_p_reset27)
   begin
   if (~n_p_reset27)
      age_chk_state27 <= idle27;
   else
      age_chk_state27 <= nxt_age_chk_state27;
   end


// -----------------------------------------------------------------------------
//   Generate27 memory RW bus for accessing array when requested27 to invalidate27 all
//   aged27 addresses27 and all addresses27.
// -----------------------------------------------------------------------------
always @ (posedge pclk27 or negedge n_p_reset27)
   begin
   if (~n_p_reset27)
   begin
      mem_addr_age27 <= 8'd0;     
      mem_write_age27 <= 1'd0;    
   end
   else if (age_chk_state27 == inval_aged_rd27)  // invalidate27 aged27 read
   begin
      mem_addr_age27 <= mem_addr_age27 + 1'd1;     
      mem_write_age27 <= 1'd0;    
   end
   else if (age_chk_state27 == inval_aged_wr27)  // invalidate27 aged27 read
   begin
      mem_addr_age27 <= mem_addr_age27;     
      mem_write_age27 <= 1'd1;    
   end
   else if (age_chk_state27 == inval_all27)  // invalidate27 all
   begin
      mem_addr_age27 <= mem_addr_age27 + 1'd1;     
      mem_write_age27 <= 1'd1;    
   end
   else if (age_chk_state27 == age_chk27)
   begin
      mem_addr_age27 <= mem_addr_age27;     
      mem_write_age27 <= mem_write_age27;    
   end
   else 
   begin
      mem_addr_age27 <= mem_addr_age27;     
      mem_write_age27 <= 1'd0;    
   end
   end

// age27 checker will only ever27 write zero values to ALUT27 mem
assign mem_write_data_age27 = 83'd0;



// -----------------------------------------------------------------------------
//   Generate27 invalidate27 in progress27 flag27 (bit 1 of status register)
// -----------------------------------------------------------------------------
always @ (posedge pclk27 or negedge n_p_reset27)
   begin
   if (~n_p_reset27)
      inval_in_prog27 <= 1'd0;
   else if (age_chk_state27 == inval_aged_wr27) 
      inval_in_prog27 <= 1'd1;
   else if ((age_chk_state27 == age_chk27) & (mem_addr_age27 == max_addr))
      inval_in_prog27 <= 1'd0;
   else
      inval_in_prog27 <= inval_in_prog27;
   end


// -----------------------------------------------------------------------------
//   Calculate27 whether27 data is still in date27.  Need27 to work27 out the real time
//   gap27 between current time and last accessed.  If27 this gap27 is greater than
//   the best27 before age27, then27 the data is out of date27. 
// -----------------------------------------------------------------------------
assign time_since_lst_acc27 = (curr_time27 > last_accessed27) ? 
                            (curr_time27 - last_accessed27) :  // no cnt wrapping27
                            (curr_time27 + (max_cnt27 - last_accessed27));

assign time_since_lst_acc_age27 = (curr_time27 > last_accessed_age27) ? 
                                (curr_time27 - last_accessed_age27) : // no wrapping27
                                (curr_time27 + (max_cnt27 - last_accessed_age27));


always @ (posedge pclk27 or negedge n_p_reset27)
   begin
   if (~n_p_reset27)
      begin
      age_ok27 <= 1'b0;
      age_confirmed27 <= 1'b0;
      end
   else if ((age_chk_state27 == age_chk27) & add_check_active27) 
      begin                                       // age27 checking for addr chkr27
      if (best_bfr_age27 > time_since_lst_acc27)      // still in date27
         begin
         age_ok27 <= 1'b1;
         age_confirmed27 <= 1'b1;
         end
      else   // out of date27
         begin
         age_ok27 <= 1'b0;
         age_confirmed27 <= 1'b1;
         end
      end
   else if ((age_chk_state27 == age_chk27) & ~add_check_active27)
      begin                                      // age27 checking for inval27 aged27
      if (best_bfr_age27 > time_since_lst_acc_age27) // still in date27
         begin
         age_ok27 <= 1'b1;
         age_confirmed27 <= 1'b1;
         end
      else   // out of date27
         begin
         age_ok27 <= 1'b0;
         age_confirmed27 <= 1'b1;
         end
      end
   else
      begin
      age_ok27 <= 1'b0;
      age_confirmed27 <= 1'b0;
      end
   end



// -----------------------------------------------------------------------------
//   Generate27 last address and port that was cleared27 in the invalid aged27 process
// -----------------------------------------------------------------------------
always @ (posedge pclk27 or negedge n_p_reset27)
   begin
   if (~n_p_reset27)
      begin
      lst_inv_addr_cmd27 <= 48'd0;
      lst_inv_port_cmd27 <= 2'd0;
      end
   else if (age_chk_state27 == inval_aged_wr27)
      begin
      lst_inv_addr_cmd27 <= mem_read_data_age27[47:0];
      lst_inv_port_cmd27 <= mem_read_data_age27[49:48];
      end
   else 
      begin
      lst_inv_addr_cmd27 <= lst_inv_addr_cmd27;
      lst_inv_port_cmd27 <= lst_inv_port_cmd27;
      end
   end


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded27 off27 age_chk_state27
// -----------------------------------------------------------------------------
assign age_check_active27 = (age_chk_state27 != 3'b000);

endmodule

