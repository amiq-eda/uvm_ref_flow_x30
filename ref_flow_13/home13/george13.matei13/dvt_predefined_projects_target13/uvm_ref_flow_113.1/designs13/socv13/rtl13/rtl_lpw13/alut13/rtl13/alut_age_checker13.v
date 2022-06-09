//File13 name   : alut_age_checker13.v
//Title13       : 
//Created13     : 1999
//Description13 : 
//Notes13       : 
//----------------------------------------------------------------------
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------

module alut_age_checker13
(   
   // Inputs13
   pclk13,
   n_p_reset13,
   command,          
   div_clk13,          
   mem_read_data_age13,
   check_age13,        
   last_accessed13, 
   best_bfr_age13,   
   add_check_active13,

   // outputs13
   curr_time13,         
   mem_addr_age13,      
   mem_write_age13,     
   mem_write_data_age13,
   lst_inv_addr_cmd13,    
   lst_inv_port_cmd13,  
   age_confirmed13,     
   age_ok13,
   inval_in_prog13,  
   age_check_active13          
);   

   input               pclk13;               // APB13 clock13                           
   input               n_p_reset13;          // Reset13                               
   input [1:0]         command;            // command bus                        
   input [7:0]         div_clk13;            // clock13 divider13 value
   input [82:0]        mem_read_data_age13;  // read data from memory             
   input               check_age13;          // request flag13 for age13 check
   input [31:0]        last_accessed13;      // time field sent13 for age13 check
   input [31:0]        best_bfr_age13;       // best13 before age13
   input               add_check_active13;   // active flag13 from address checker

   output [31:0]       curr_time13;          // current time,for storing13 in mem    
   output [7:0]        mem_addr_age13;       // address for R/W13 to memory     
   output              mem_write_age13;      // R/W13 flag13 (write = high13)            
   output [82:0]       mem_write_data_age13; // write data for memory             
   output [47:0]       lst_inv_addr_cmd13;   // last invalidated13 addr normal13 op    
   output [1:0]        lst_inv_port_cmd13;   // last invalidated13 port normal13 op    
   output              age_confirmed13;      // validates13 age_ok13 result 
   output              age_ok13;             // age13 checker result - set means13 in-date13
   output              inval_in_prog13;      // invalidation13 in progress13
   output              age_check_active13;   // bit 0 of status register           

   reg  [2:0]          age_chk_state13;      // age13 checker FSM13 current state
   reg  [2:0]          nxt_age_chk_state13;  // age13 checker FSM13 next state
   reg  [7:0]          mem_addr_age13;     
   reg                 mem_write_age13;    
   reg                 inval_in_prog13;      // invalidation13 in progress13
   reg  [7:0]          clk_div_cnt13;        // clock13 divider13 counter
   reg  [31:0]         curr_time13;          // current time,for storing13 in mem  
   reg                 age_confirmed13;      // validates13 age_ok13 result 
   reg                 age_ok13;             // age13 checker result - set means13 in-date13
   reg [47:0]          lst_inv_addr_cmd13;   // last invalidated13 addr normal13 op    
   reg [1:0]           lst_inv_port_cmd13;   // last invalidated13 port normal13 op    

   wire  [82:0]        mem_write_data_age13;
   wire  [31:0]        last_accessed_age13;  // read back time by age13 checker
   wire  [31:0]        time_since_lst_acc_age13;  // time since13 last accessed age13
   wire  [31:0]        time_since_lst_acc13; // time since13 last accessed address
   wire                age_check_active13;   // bit 0 of status register           

// Parameters13 for Address Checking13 FSM13 states13
   parameter idle13           = 3'b000;
   parameter inval_aged_rd13  = 3'b001;
   parameter inval_aged_wr13  = 3'b010;
   parameter inval_all13      = 3'b011;
   parameter age_chk13        = 3'b100;

   parameter max_addr       = 8'hff;
   parameter max_cnt13        = 32'hffff_ffff;

// -----------------------------------------------------------------------------
//   Generate13 current time counter
// -----------------------------------------------------------------------------
always @ (posedge pclk13 or negedge n_p_reset13)
   begin
   if (~n_p_reset13)
      clk_div_cnt13 <= 8'd0;
   else if (clk_div_cnt13 == div_clk13)
      clk_div_cnt13 <= 8'd0; 
   else 
      clk_div_cnt13 <= clk_div_cnt13 + 1'd1;
   end


always @ (posedge pclk13 or negedge n_p_reset13)
   begin
   if (~n_p_reset13)
      curr_time13 <= 32'd0;
   else if (clk_div_cnt13 == div_clk13)
      curr_time13 <= curr_time13 + 1'd1;
   end


// -----------------------------------------------------------------------------
//   Age13 checker State13 Machine13 
// -----------------------------------------------------------------------------
always @ (command or check_age13 or age_chk_state13 or age_confirmed13 or age_ok13 or
          mem_addr_age13 or mem_read_data_age13[82])
   begin
      case (age_chk_state13)
      
      idle13:
         if (command == 2'b10)
            nxt_age_chk_state13 = inval_aged_rd13;
         else if (command == 2'b11)
            nxt_age_chk_state13 = inval_all13;
         else if (check_age13)
            nxt_age_chk_state13 = age_chk13;
         else
            nxt_age_chk_state13 = idle13;

      inval_aged_rd13:
            nxt_age_chk_state13 = age_chk13;

      inval_aged_wr13:
            nxt_age_chk_state13 = idle13;

      inval_all13:
         if (mem_addr_age13 != max_addr)
            nxt_age_chk_state13 = inval_all13;  // move13 onto13 next address
         else
            nxt_age_chk_state13 = idle13;

      age_chk13:
         if (age_confirmed13)
            begin
            if (add_check_active13)                     // age13 check for addr chkr13
               nxt_age_chk_state13 = idle13;
            else if (~mem_read_data_age13[82])      // invalid, check next location13
               nxt_age_chk_state13 = inval_aged_rd13; 
            else if (~age_ok13 & mem_read_data_age13[82]) // out of date13, clear 
               nxt_age_chk_state13 = inval_aged_wr13;
            else if (mem_addr_age13 == max_addr)    // full check completed
               nxt_age_chk_state13 = idle13;     
            else 
               nxt_age_chk_state13 = inval_aged_rd13; // age13 ok, check next location13 
            end       
         else
            nxt_age_chk_state13 = age_chk13;

      default:
            nxt_age_chk_state13 = idle13;
      endcase
   end



always @ (posedge pclk13 or negedge n_p_reset13)
   begin
   if (~n_p_reset13)
      age_chk_state13 <= idle13;
   else
      age_chk_state13 <= nxt_age_chk_state13;
   end


// -----------------------------------------------------------------------------
//   Generate13 memory RW bus for accessing array when requested13 to invalidate13 all
//   aged13 addresses13 and all addresses13.
// -----------------------------------------------------------------------------
always @ (posedge pclk13 or negedge n_p_reset13)
   begin
   if (~n_p_reset13)
   begin
      mem_addr_age13 <= 8'd0;     
      mem_write_age13 <= 1'd0;    
   end
   else if (age_chk_state13 == inval_aged_rd13)  // invalidate13 aged13 read
   begin
      mem_addr_age13 <= mem_addr_age13 + 1'd1;     
      mem_write_age13 <= 1'd0;    
   end
   else if (age_chk_state13 == inval_aged_wr13)  // invalidate13 aged13 read
   begin
      mem_addr_age13 <= mem_addr_age13;     
      mem_write_age13 <= 1'd1;    
   end
   else if (age_chk_state13 == inval_all13)  // invalidate13 all
   begin
      mem_addr_age13 <= mem_addr_age13 + 1'd1;     
      mem_write_age13 <= 1'd1;    
   end
   else if (age_chk_state13 == age_chk13)
   begin
      mem_addr_age13 <= mem_addr_age13;     
      mem_write_age13 <= mem_write_age13;    
   end
   else 
   begin
      mem_addr_age13 <= mem_addr_age13;     
      mem_write_age13 <= 1'd0;    
   end
   end

// age13 checker will only ever13 write zero values to ALUT13 mem
assign mem_write_data_age13 = 83'd0;



// -----------------------------------------------------------------------------
//   Generate13 invalidate13 in progress13 flag13 (bit 1 of status register)
// -----------------------------------------------------------------------------
always @ (posedge pclk13 or negedge n_p_reset13)
   begin
   if (~n_p_reset13)
      inval_in_prog13 <= 1'd0;
   else if (age_chk_state13 == inval_aged_wr13) 
      inval_in_prog13 <= 1'd1;
   else if ((age_chk_state13 == age_chk13) & (mem_addr_age13 == max_addr))
      inval_in_prog13 <= 1'd0;
   else
      inval_in_prog13 <= inval_in_prog13;
   end


// -----------------------------------------------------------------------------
//   Calculate13 whether13 data is still in date13.  Need13 to work13 out the real time
//   gap13 between current time and last accessed.  If13 this gap13 is greater than
//   the best13 before age13, then13 the data is out of date13. 
// -----------------------------------------------------------------------------
assign time_since_lst_acc13 = (curr_time13 > last_accessed13) ? 
                            (curr_time13 - last_accessed13) :  // no cnt wrapping13
                            (curr_time13 + (max_cnt13 - last_accessed13));

assign time_since_lst_acc_age13 = (curr_time13 > last_accessed_age13) ? 
                                (curr_time13 - last_accessed_age13) : // no wrapping13
                                (curr_time13 + (max_cnt13 - last_accessed_age13));


always @ (posedge pclk13 or negedge n_p_reset13)
   begin
   if (~n_p_reset13)
      begin
      age_ok13 <= 1'b0;
      age_confirmed13 <= 1'b0;
      end
   else if ((age_chk_state13 == age_chk13) & add_check_active13) 
      begin                                       // age13 checking for addr chkr13
      if (best_bfr_age13 > time_since_lst_acc13)      // still in date13
         begin
         age_ok13 <= 1'b1;
         age_confirmed13 <= 1'b1;
         end
      else   // out of date13
         begin
         age_ok13 <= 1'b0;
         age_confirmed13 <= 1'b1;
         end
      end
   else if ((age_chk_state13 == age_chk13) & ~add_check_active13)
      begin                                      // age13 checking for inval13 aged13
      if (best_bfr_age13 > time_since_lst_acc_age13) // still in date13
         begin
         age_ok13 <= 1'b1;
         age_confirmed13 <= 1'b1;
         end
      else   // out of date13
         begin
         age_ok13 <= 1'b0;
         age_confirmed13 <= 1'b1;
         end
      end
   else
      begin
      age_ok13 <= 1'b0;
      age_confirmed13 <= 1'b0;
      end
   end



// -----------------------------------------------------------------------------
//   Generate13 last address and port that was cleared13 in the invalid aged13 process
// -----------------------------------------------------------------------------
always @ (posedge pclk13 or negedge n_p_reset13)
   begin
   if (~n_p_reset13)
      begin
      lst_inv_addr_cmd13 <= 48'd0;
      lst_inv_port_cmd13 <= 2'd0;
      end
   else if (age_chk_state13 == inval_aged_wr13)
      begin
      lst_inv_addr_cmd13 <= mem_read_data_age13[47:0];
      lst_inv_port_cmd13 <= mem_read_data_age13[49:48];
      end
   else 
      begin
      lst_inv_addr_cmd13 <= lst_inv_addr_cmd13;
      lst_inv_port_cmd13 <= lst_inv_port_cmd13;
      end
   end


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded13 off13 age_chk_state13
// -----------------------------------------------------------------------------
assign age_check_active13 = (age_chk_state13 != 3'b000);

endmodule

