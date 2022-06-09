//File9 name   : alut_age_checker9.v
//Title9       : 
//Created9     : 1999
//Description9 : 
//Notes9       : 
//----------------------------------------------------------------------
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------

module alut_age_checker9
(   
   // Inputs9
   pclk9,
   n_p_reset9,
   command,          
   div_clk9,          
   mem_read_data_age9,
   check_age9,        
   last_accessed9, 
   best_bfr_age9,   
   add_check_active9,

   // outputs9
   curr_time9,         
   mem_addr_age9,      
   mem_write_age9,     
   mem_write_data_age9,
   lst_inv_addr_cmd9,    
   lst_inv_port_cmd9,  
   age_confirmed9,     
   age_ok9,
   inval_in_prog9,  
   age_check_active9          
);   

   input               pclk9;               // APB9 clock9                           
   input               n_p_reset9;          // Reset9                               
   input [1:0]         command;            // command bus                        
   input [7:0]         div_clk9;            // clock9 divider9 value
   input [82:0]        mem_read_data_age9;  // read data from memory             
   input               check_age9;          // request flag9 for age9 check
   input [31:0]        last_accessed9;      // time field sent9 for age9 check
   input [31:0]        best_bfr_age9;       // best9 before age9
   input               add_check_active9;   // active flag9 from address checker

   output [31:0]       curr_time9;          // current time,for storing9 in mem    
   output [7:0]        mem_addr_age9;       // address for R/W9 to memory     
   output              mem_write_age9;      // R/W9 flag9 (write = high9)            
   output [82:0]       mem_write_data_age9; // write data for memory             
   output [47:0]       lst_inv_addr_cmd9;   // last invalidated9 addr normal9 op    
   output [1:0]        lst_inv_port_cmd9;   // last invalidated9 port normal9 op    
   output              age_confirmed9;      // validates9 age_ok9 result 
   output              age_ok9;             // age9 checker result - set means9 in-date9
   output              inval_in_prog9;      // invalidation9 in progress9
   output              age_check_active9;   // bit 0 of status register           

   reg  [2:0]          age_chk_state9;      // age9 checker FSM9 current state
   reg  [2:0]          nxt_age_chk_state9;  // age9 checker FSM9 next state
   reg  [7:0]          mem_addr_age9;     
   reg                 mem_write_age9;    
   reg                 inval_in_prog9;      // invalidation9 in progress9
   reg  [7:0]          clk_div_cnt9;        // clock9 divider9 counter
   reg  [31:0]         curr_time9;          // current time,for storing9 in mem  
   reg                 age_confirmed9;      // validates9 age_ok9 result 
   reg                 age_ok9;             // age9 checker result - set means9 in-date9
   reg [47:0]          lst_inv_addr_cmd9;   // last invalidated9 addr normal9 op    
   reg [1:0]           lst_inv_port_cmd9;   // last invalidated9 port normal9 op    

   wire  [82:0]        mem_write_data_age9;
   wire  [31:0]        last_accessed_age9;  // read back time by age9 checker
   wire  [31:0]        time_since_lst_acc_age9;  // time since9 last accessed age9
   wire  [31:0]        time_since_lst_acc9; // time since9 last accessed address
   wire                age_check_active9;   // bit 0 of status register           

// Parameters9 for Address Checking9 FSM9 states9
   parameter idle9           = 3'b000;
   parameter inval_aged_rd9  = 3'b001;
   parameter inval_aged_wr9  = 3'b010;
   parameter inval_all9      = 3'b011;
   parameter age_chk9        = 3'b100;

   parameter max_addr       = 8'hff;
   parameter max_cnt9        = 32'hffff_ffff;

// -----------------------------------------------------------------------------
//   Generate9 current time counter
// -----------------------------------------------------------------------------
always @ (posedge pclk9 or negedge n_p_reset9)
   begin
   if (~n_p_reset9)
      clk_div_cnt9 <= 8'd0;
   else if (clk_div_cnt9 == div_clk9)
      clk_div_cnt9 <= 8'd0; 
   else 
      clk_div_cnt9 <= clk_div_cnt9 + 1'd1;
   end


always @ (posedge pclk9 or negedge n_p_reset9)
   begin
   if (~n_p_reset9)
      curr_time9 <= 32'd0;
   else if (clk_div_cnt9 == div_clk9)
      curr_time9 <= curr_time9 + 1'd1;
   end


// -----------------------------------------------------------------------------
//   Age9 checker State9 Machine9 
// -----------------------------------------------------------------------------
always @ (command or check_age9 or age_chk_state9 or age_confirmed9 or age_ok9 or
          mem_addr_age9 or mem_read_data_age9[82])
   begin
      case (age_chk_state9)
      
      idle9:
         if (command == 2'b10)
            nxt_age_chk_state9 = inval_aged_rd9;
         else if (command == 2'b11)
            nxt_age_chk_state9 = inval_all9;
         else if (check_age9)
            nxt_age_chk_state9 = age_chk9;
         else
            nxt_age_chk_state9 = idle9;

      inval_aged_rd9:
            nxt_age_chk_state9 = age_chk9;

      inval_aged_wr9:
            nxt_age_chk_state9 = idle9;

      inval_all9:
         if (mem_addr_age9 != max_addr)
            nxt_age_chk_state9 = inval_all9;  // move9 onto9 next address
         else
            nxt_age_chk_state9 = idle9;

      age_chk9:
         if (age_confirmed9)
            begin
            if (add_check_active9)                     // age9 check for addr chkr9
               nxt_age_chk_state9 = idle9;
            else if (~mem_read_data_age9[82])      // invalid, check next location9
               nxt_age_chk_state9 = inval_aged_rd9; 
            else if (~age_ok9 & mem_read_data_age9[82]) // out of date9, clear 
               nxt_age_chk_state9 = inval_aged_wr9;
            else if (mem_addr_age9 == max_addr)    // full check completed
               nxt_age_chk_state9 = idle9;     
            else 
               nxt_age_chk_state9 = inval_aged_rd9; // age9 ok, check next location9 
            end       
         else
            nxt_age_chk_state9 = age_chk9;

      default:
            nxt_age_chk_state9 = idle9;
      endcase
   end



always @ (posedge pclk9 or negedge n_p_reset9)
   begin
   if (~n_p_reset9)
      age_chk_state9 <= idle9;
   else
      age_chk_state9 <= nxt_age_chk_state9;
   end


// -----------------------------------------------------------------------------
//   Generate9 memory RW bus for accessing array when requested9 to invalidate9 all
//   aged9 addresses9 and all addresses9.
// -----------------------------------------------------------------------------
always @ (posedge pclk9 or negedge n_p_reset9)
   begin
   if (~n_p_reset9)
   begin
      mem_addr_age9 <= 8'd0;     
      mem_write_age9 <= 1'd0;    
   end
   else if (age_chk_state9 == inval_aged_rd9)  // invalidate9 aged9 read
   begin
      mem_addr_age9 <= mem_addr_age9 + 1'd1;     
      mem_write_age9 <= 1'd0;    
   end
   else if (age_chk_state9 == inval_aged_wr9)  // invalidate9 aged9 read
   begin
      mem_addr_age9 <= mem_addr_age9;     
      mem_write_age9 <= 1'd1;    
   end
   else if (age_chk_state9 == inval_all9)  // invalidate9 all
   begin
      mem_addr_age9 <= mem_addr_age9 + 1'd1;     
      mem_write_age9 <= 1'd1;    
   end
   else if (age_chk_state9 == age_chk9)
   begin
      mem_addr_age9 <= mem_addr_age9;     
      mem_write_age9 <= mem_write_age9;    
   end
   else 
   begin
      mem_addr_age9 <= mem_addr_age9;     
      mem_write_age9 <= 1'd0;    
   end
   end

// age9 checker will only ever9 write zero values to ALUT9 mem
assign mem_write_data_age9 = 83'd0;



// -----------------------------------------------------------------------------
//   Generate9 invalidate9 in progress9 flag9 (bit 1 of status register)
// -----------------------------------------------------------------------------
always @ (posedge pclk9 or negedge n_p_reset9)
   begin
   if (~n_p_reset9)
      inval_in_prog9 <= 1'd0;
   else if (age_chk_state9 == inval_aged_wr9) 
      inval_in_prog9 <= 1'd1;
   else if ((age_chk_state9 == age_chk9) & (mem_addr_age9 == max_addr))
      inval_in_prog9 <= 1'd0;
   else
      inval_in_prog9 <= inval_in_prog9;
   end


// -----------------------------------------------------------------------------
//   Calculate9 whether9 data is still in date9.  Need9 to work9 out the real time
//   gap9 between current time and last accessed.  If9 this gap9 is greater than
//   the best9 before age9, then9 the data is out of date9. 
// -----------------------------------------------------------------------------
assign time_since_lst_acc9 = (curr_time9 > last_accessed9) ? 
                            (curr_time9 - last_accessed9) :  // no cnt wrapping9
                            (curr_time9 + (max_cnt9 - last_accessed9));

assign time_since_lst_acc_age9 = (curr_time9 > last_accessed_age9) ? 
                                (curr_time9 - last_accessed_age9) : // no wrapping9
                                (curr_time9 + (max_cnt9 - last_accessed_age9));


always @ (posedge pclk9 or negedge n_p_reset9)
   begin
   if (~n_p_reset9)
      begin
      age_ok9 <= 1'b0;
      age_confirmed9 <= 1'b0;
      end
   else if ((age_chk_state9 == age_chk9) & add_check_active9) 
      begin                                       // age9 checking for addr chkr9
      if (best_bfr_age9 > time_since_lst_acc9)      // still in date9
         begin
         age_ok9 <= 1'b1;
         age_confirmed9 <= 1'b1;
         end
      else   // out of date9
         begin
         age_ok9 <= 1'b0;
         age_confirmed9 <= 1'b1;
         end
      end
   else if ((age_chk_state9 == age_chk9) & ~add_check_active9)
      begin                                      // age9 checking for inval9 aged9
      if (best_bfr_age9 > time_since_lst_acc_age9) // still in date9
         begin
         age_ok9 <= 1'b1;
         age_confirmed9 <= 1'b1;
         end
      else   // out of date9
         begin
         age_ok9 <= 1'b0;
         age_confirmed9 <= 1'b1;
         end
      end
   else
      begin
      age_ok9 <= 1'b0;
      age_confirmed9 <= 1'b0;
      end
   end



// -----------------------------------------------------------------------------
//   Generate9 last address and port that was cleared9 in the invalid aged9 process
// -----------------------------------------------------------------------------
always @ (posedge pclk9 or negedge n_p_reset9)
   begin
   if (~n_p_reset9)
      begin
      lst_inv_addr_cmd9 <= 48'd0;
      lst_inv_port_cmd9 <= 2'd0;
      end
   else if (age_chk_state9 == inval_aged_wr9)
      begin
      lst_inv_addr_cmd9 <= mem_read_data_age9[47:0];
      lst_inv_port_cmd9 <= mem_read_data_age9[49:48];
      end
   else 
      begin
      lst_inv_addr_cmd9 <= lst_inv_addr_cmd9;
      lst_inv_port_cmd9 <= lst_inv_port_cmd9;
      end
   end


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded9 off9 age_chk_state9
// -----------------------------------------------------------------------------
assign age_check_active9 = (age_chk_state9 != 3'b000);

endmodule

