//File7 name   : alut_age_checker7.v
//Title7       : 
//Created7     : 1999
//Description7 : 
//Notes7       : 
//----------------------------------------------------------------------
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------

module alut_age_checker7
(   
   // Inputs7
   pclk7,
   n_p_reset7,
   command,          
   div_clk7,          
   mem_read_data_age7,
   check_age7,        
   last_accessed7, 
   best_bfr_age7,   
   add_check_active7,

   // outputs7
   curr_time7,         
   mem_addr_age7,      
   mem_write_age7,     
   mem_write_data_age7,
   lst_inv_addr_cmd7,    
   lst_inv_port_cmd7,  
   age_confirmed7,     
   age_ok7,
   inval_in_prog7,  
   age_check_active7          
);   

   input               pclk7;               // APB7 clock7                           
   input               n_p_reset7;          // Reset7                               
   input [1:0]         command;            // command bus                        
   input [7:0]         div_clk7;            // clock7 divider7 value
   input [82:0]        mem_read_data_age7;  // read data from memory             
   input               check_age7;          // request flag7 for age7 check
   input [31:0]        last_accessed7;      // time field sent7 for age7 check
   input [31:0]        best_bfr_age7;       // best7 before age7
   input               add_check_active7;   // active flag7 from address checker

   output [31:0]       curr_time7;          // current time,for storing7 in mem    
   output [7:0]        mem_addr_age7;       // address for R/W7 to memory     
   output              mem_write_age7;      // R/W7 flag7 (write = high7)            
   output [82:0]       mem_write_data_age7; // write data for memory             
   output [47:0]       lst_inv_addr_cmd7;   // last invalidated7 addr normal7 op    
   output [1:0]        lst_inv_port_cmd7;   // last invalidated7 port normal7 op    
   output              age_confirmed7;      // validates7 age_ok7 result 
   output              age_ok7;             // age7 checker result - set means7 in-date7
   output              inval_in_prog7;      // invalidation7 in progress7
   output              age_check_active7;   // bit 0 of status register           

   reg  [2:0]          age_chk_state7;      // age7 checker FSM7 current state
   reg  [2:0]          nxt_age_chk_state7;  // age7 checker FSM7 next state
   reg  [7:0]          mem_addr_age7;     
   reg                 mem_write_age7;    
   reg                 inval_in_prog7;      // invalidation7 in progress7
   reg  [7:0]          clk_div_cnt7;        // clock7 divider7 counter
   reg  [31:0]         curr_time7;          // current time,for storing7 in mem  
   reg                 age_confirmed7;      // validates7 age_ok7 result 
   reg                 age_ok7;             // age7 checker result - set means7 in-date7
   reg [47:0]          lst_inv_addr_cmd7;   // last invalidated7 addr normal7 op    
   reg [1:0]           lst_inv_port_cmd7;   // last invalidated7 port normal7 op    

   wire  [82:0]        mem_write_data_age7;
   wire  [31:0]        last_accessed_age7;  // read back time by age7 checker
   wire  [31:0]        time_since_lst_acc_age7;  // time since7 last accessed age7
   wire  [31:0]        time_since_lst_acc7; // time since7 last accessed address
   wire                age_check_active7;   // bit 0 of status register           

// Parameters7 for Address Checking7 FSM7 states7
   parameter idle7           = 3'b000;
   parameter inval_aged_rd7  = 3'b001;
   parameter inval_aged_wr7  = 3'b010;
   parameter inval_all7      = 3'b011;
   parameter age_chk7        = 3'b100;

   parameter max_addr       = 8'hff;
   parameter max_cnt7        = 32'hffff_ffff;

// -----------------------------------------------------------------------------
//   Generate7 current time counter
// -----------------------------------------------------------------------------
always @ (posedge pclk7 or negedge n_p_reset7)
   begin
   if (~n_p_reset7)
      clk_div_cnt7 <= 8'd0;
   else if (clk_div_cnt7 == div_clk7)
      clk_div_cnt7 <= 8'd0; 
   else 
      clk_div_cnt7 <= clk_div_cnt7 + 1'd1;
   end


always @ (posedge pclk7 or negedge n_p_reset7)
   begin
   if (~n_p_reset7)
      curr_time7 <= 32'd0;
   else if (clk_div_cnt7 == div_clk7)
      curr_time7 <= curr_time7 + 1'd1;
   end


// -----------------------------------------------------------------------------
//   Age7 checker State7 Machine7 
// -----------------------------------------------------------------------------
always @ (command or check_age7 or age_chk_state7 or age_confirmed7 or age_ok7 or
          mem_addr_age7 or mem_read_data_age7[82])
   begin
      case (age_chk_state7)
      
      idle7:
         if (command == 2'b10)
            nxt_age_chk_state7 = inval_aged_rd7;
         else if (command == 2'b11)
            nxt_age_chk_state7 = inval_all7;
         else if (check_age7)
            nxt_age_chk_state7 = age_chk7;
         else
            nxt_age_chk_state7 = idle7;

      inval_aged_rd7:
            nxt_age_chk_state7 = age_chk7;

      inval_aged_wr7:
            nxt_age_chk_state7 = idle7;

      inval_all7:
         if (mem_addr_age7 != max_addr)
            nxt_age_chk_state7 = inval_all7;  // move7 onto7 next address
         else
            nxt_age_chk_state7 = idle7;

      age_chk7:
         if (age_confirmed7)
            begin
            if (add_check_active7)                     // age7 check for addr chkr7
               nxt_age_chk_state7 = idle7;
            else if (~mem_read_data_age7[82])      // invalid, check next location7
               nxt_age_chk_state7 = inval_aged_rd7; 
            else if (~age_ok7 & mem_read_data_age7[82]) // out of date7, clear 
               nxt_age_chk_state7 = inval_aged_wr7;
            else if (mem_addr_age7 == max_addr)    // full check completed
               nxt_age_chk_state7 = idle7;     
            else 
               nxt_age_chk_state7 = inval_aged_rd7; // age7 ok, check next location7 
            end       
         else
            nxt_age_chk_state7 = age_chk7;

      default:
            nxt_age_chk_state7 = idle7;
      endcase
   end



always @ (posedge pclk7 or negedge n_p_reset7)
   begin
   if (~n_p_reset7)
      age_chk_state7 <= idle7;
   else
      age_chk_state7 <= nxt_age_chk_state7;
   end


// -----------------------------------------------------------------------------
//   Generate7 memory RW bus for accessing array when requested7 to invalidate7 all
//   aged7 addresses7 and all addresses7.
// -----------------------------------------------------------------------------
always @ (posedge pclk7 or negedge n_p_reset7)
   begin
   if (~n_p_reset7)
   begin
      mem_addr_age7 <= 8'd0;     
      mem_write_age7 <= 1'd0;    
   end
   else if (age_chk_state7 == inval_aged_rd7)  // invalidate7 aged7 read
   begin
      mem_addr_age7 <= mem_addr_age7 + 1'd1;     
      mem_write_age7 <= 1'd0;    
   end
   else if (age_chk_state7 == inval_aged_wr7)  // invalidate7 aged7 read
   begin
      mem_addr_age7 <= mem_addr_age7;     
      mem_write_age7 <= 1'd1;    
   end
   else if (age_chk_state7 == inval_all7)  // invalidate7 all
   begin
      mem_addr_age7 <= mem_addr_age7 + 1'd1;     
      mem_write_age7 <= 1'd1;    
   end
   else if (age_chk_state7 == age_chk7)
   begin
      mem_addr_age7 <= mem_addr_age7;     
      mem_write_age7 <= mem_write_age7;    
   end
   else 
   begin
      mem_addr_age7 <= mem_addr_age7;     
      mem_write_age7 <= 1'd0;    
   end
   end

// age7 checker will only ever7 write zero values to ALUT7 mem
assign mem_write_data_age7 = 83'd0;



// -----------------------------------------------------------------------------
//   Generate7 invalidate7 in progress7 flag7 (bit 1 of status register)
// -----------------------------------------------------------------------------
always @ (posedge pclk7 or negedge n_p_reset7)
   begin
   if (~n_p_reset7)
      inval_in_prog7 <= 1'd0;
   else if (age_chk_state7 == inval_aged_wr7) 
      inval_in_prog7 <= 1'd1;
   else if ((age_chk_state7 == age_chk7) & (mem_addr_age7 == max_addr))
      inval_in_prog7 <= 1'd0;
   else
      inval_in_prog7 <= inval_in_prog7;
   end


// -----------------------------------------------------------------------------
//   Calculate7 whether7 data is still in date7.  Need7 to work7 out the real time
//   gap7 between current time and last accessed.  If7 this gap7 is greater than
//   the best7 before age7, then7 the data is out of date7. 
// -----------------------------------------------------------------------------
assign time_since_lst_acc7 = (curr_time7 > last_accessed7) ? 
                            (curr_time7 - last_accessed7) :  // no cnt wrapping7
                            (curr_time7 + (max_cnt7 - last_accessed7));

assign time_since_lst_acc_age7 = (curr_time7 > last_accessed_age7) ? 
                                (curr_time7 - last_accessed_age7) : // no wrapping7
                                (curr_time7 + (max_cnt7 - last_accessed_age7));


always @ (posedge pclk7 or negedge n_p_reset7)
   begin
   if (~n_p_reset7)
      begin
      age_ok7 <= 1'b0;
      age_confirmed7 <= 1'b0;
      end
   else if ((age_chk_state7 == age_chk7) & add_check_active7) 
      begin                                       // age7 checking for addr chkr7
      if (best_bfr_age7 > time_since_lst_acc7)      // still in date7
         begin
         age_ok7 <= 1'b1;
         age_confirmed7 <= 1'b1;
         end
      else   // out of date7
         begin
         age_ok7 <= 1'b0;
         age_confirmed7 <= 1'b1;
         end
      end
   else if ((age_chk_state7 == age_chk7) & ~add_check_active7)
      begin                                      // age7 checking for inval7 aged7
      if (best_bfr_age7 > time_since_lst_acc_age7) // still in date7
         begin
         age_ok7 <= 1'b1;
         age_confirmed7 <= 1'b1;
         end
      else   // out of date7
         begin
         age_ok7 <= 1'b0;
         age_confirmed7 <= 1'b1;
         end
      end
   else
      begin
      age_ok7 <= 1'b0;
      age_confirmed7 <= 1'b0;
      end
   end



// -----------------------------------------------------------------------------
//   Generate7 last address and port that was cleared7 in the invalid aged7 process
// -----------------------------------------------------------------------------
always @ (posedge pclk7 or negedge n_p_reset7)
   begin
   if (~n_p_reset7)
      begin
      lst_inv_addr_cmd7 <= 48'd0;
      lst_inv_port_cmd7 <= 2'd0;
      end
   else if (age_chk_state7 == inval_aged_wr7)
      begin
      lst_inv_addr_cmd7 <= mem_read_data_age7[47:0];
      lst_inv_port_cmd7 <= mem_read_data_age7[49:48];
      end
   else 
      begin
      lst_inv_addr_cmd7 <= lst_inv_addr_cmd7;
      lst_inv_port_cmd7 <= lst_inv_port_cmd7;
      end
   end


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded7 off7 age_chk_state7
// -----------------------------------------------------------------------------
assign age_check_active7 = (age_chk_state7 != 3'b000);

endmodule

