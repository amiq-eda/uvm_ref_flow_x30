//File24 name   : alut_age_checker24.v
//Title24       : 
//Created24     : 1999
//Description24 : 
//Notes24       : 
//----------------------------------------------------------------------
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------

module alut_age_checker24
(   
   // Inputs24
   pclk24,
   n_p_reset24,
   command,          
   div_clk24,          
   mem_read_data_age24,
   check_age24,        
   last_accessed24, 
   best_bfr_age24,   
   add_check_active24,

   // outputs24
   curr_time24,         
   mem_addr_age24,      
   mem_write_age24,     
   mem_write_data_age24,
   lst_inv_addr_cmd24,    
   lst_inv_port_cmd24,  
   age_confirmed24,     
   age_ok24,
   inval_in_prog24,  
   age_check_active24          
);   

   input               pclk24;               // APB24 clock24                           
   input               n_p_reset24;          // Reset24                               
   input [1:0]         command;            // command bus                        
   input [7:0]         div_clk24;            // clock24 divider24 value
   input [82:0]        mem_read_data_age24;  // read data from memory             
   input               check_age24;          // request flag24 for age24 check
   input [31:0]        last_accessed24;      // time field sent24 for age24 check
   input [31:0]        best_bfr_age24;       // best24 before age24
   input               add_check_active24;   // active flag24 from address checker

   output [31:0]       curr_time24;          // current time,for storing24 in mem    
   output [7:0]        mem_addr_age24;       // address for R/W24 to memory     
   output              mem_write_age24;      // R/W24 flag24 (write = high24)            
   output [82:0]       mem_write_data_age24; // write data for memory             
   output [47:0]       lst_inv_addr_cmd24;   // last invalidated24 addr normal24 op    
   output [1:0]        lst_inv_port_cmd24;   // last invalidated24 port normal24 op    
   output              age_confirmed24;      // validates24 age_ok24 result 
   output              age_ok24;             // age24 checker result - set means24 in-date24
   output              inval_in_prog24;      // invalidation24 in progress24
   output              age_check_active24;   // bit 0 of status register           

   reg  [2:0]          age_chk_state24;      // age24 checker FSM24 current state
   reg  [2:0]          nxt_age_chk_state24;  // age24 checker FSM24 next state
   reg  [7:0]          mem_addr_age24;     
   reg                 mem_write_age24;    
   reg                 inval_in_prog24;      // invalidation24 in progress24
   reg  [7:0]          clk_div_cnt24;        // clock24 divider24 counter
   reg  [31:0]         curr_time24;          // current time,for storing24 in mem  
   reg                 age_confirmed24;      // validates24 age_ok24 result 
   reg                 age_ok24;             // age24 checker result - set means24 in-date24
   reg [47:0]          lst_inv_addr_cmd24;   // last invalidated24 addr normal24 op    
   reg [1:0]           lst_inv_port_cmd24;   // last invalidated24 port normal24 op    

   wire  [82:0]        mem_write_data_age24;
   wire  [31:0]        last_accessed_age24;  // read back time by age24 checker
   wire  [31:0]        time_since_lst_acc_age24;  // time since24 last accessed age24
   wire  [31:0]        time_since_lst_acc24; // time since24 last accessed address
   wire                age_check_active24;   // bit 0 of status register           

// Parameters24 for Address Checking24 FSM24 states24
   parameter idle24           = 3'b000;
   parameter inval_aged_rd24  = 3'b001;
   parameter inval_aged_wr24  = 3'b010;
   parameter inval_all24      = 3'b011;
   parameter age_chk24        = 3'b100;

   parameter max_addr       = 8'hff;
   parameter max_cnt24        = 32'hffff_ffff;

// -----------------------------------------------------------------------------
//   Generate24 current time counter
// -----------------------------------------------------------------------------
always @ (posedge pclk24 or negedge n_p_reset24)
   begin
   if (~n_p_reset24)
      clk_div_cnt24 <= 8'd0;
   else if (clk_div_cnt24 == div_clk24)
      clk_div_cnt24 <= 8'd0; 
   else 
      clk_div_cnt24 <= clk_div_cnt24 + 1'd1;
   end


always @ (posedge pclk24 or negedge n_p_reset24)
   begin
   if (~n_p_reset24)
      curr_time24 <= 32'd0;
   else if (clk_div_cnt24 == div_clk24)
      curr_time24 <= curr_time24 + 1'd1;
   end


// -----------------------------------------------------------------------------
//   Age24 checker State24 Machine24 
// -----------------------------------------------------------------------------
always @ (command or check_age24 or age_chk_state24 or age_confirmed24 or age_ok24 or
          mem_addr_age24 or mem_read_data_age24[82])
   begin
      case (age_chk_state24)
      
      idle24:
         if (command == 2'b10)
            nxt_age_chk_state24 = inval_aged_rd24;
         else if (command == 2'b11)
            nxt_age_chk_state24 = inval_all24;
         else if (check_age24)
            nxt_age_chk_state24 = age_chk24;
         else
            nxt_age_chk_state24 = idle24;

      inval_aged_rd24:
            nxt_age_chk_state24 = age_chk24;

      inval_aged_wr24:
            nxt_age_chk_state24 = idle24;

      inval_all24:
         if (mem_addr_age24 != max_addr)
            nxt_age_chk_state24 = inval_all24;  // move24 onto24 next address
         else
            nxt_age_chk_state24 = idle24;

      age_chk24:
         if (age_confirmed24)
            begin
            if (add_check_active24)                     // age24 check for addr chkr24
               nxt_age_chk_state24 = idle24;
            else if (~mem_read_data_age24[82])      // invalid, check next location24
               nxt_age_chk_state24 = inval_aged_rd24; 
            else if (~age_ok24 & mem_read_data_age24[82]) // out of date24, clear 
               nxt_age_chk_state24 = inval_aged_wr24;
            else if (mem_addr_age24 == max_addr)    // full check completed
               nxt_age_chk_state24 = idle24;     
            else 
               nxt_age_chk_state24 = inval_aged_rd24; // age24 ok, check next location24 
            end       
         else
            nxt_age_chk_state24 = age_chk24;

      default:
            nxt_age_chk_state24 = idle24;
      endcase
   end



always @ (posedge pclk24 or negedge n_p_reset24)
   begin
   if (~n_p_reset24)
      age_chk_state24 <= idle24;
   else
      age_chk_state24 <= nxt_age_chk_state24;
   end


// -----------------------------------------------------------------------------
//   Generate24 memory RW bus for accessing array when requested24 to invalidate24 all
//   aged24 addresses24 and all addresses24.
// -----------------------------------------------------------------------------
always @ (posedge pclk24 or negedge n_p_reset24)
   begin
   if (~n_p_reset24)
   begin
      mem_addr_age24 <= 8'd0;     
      mem_write_age24 <= 1'd0;    
   end
   else if (age_chk_state24 == inval_aged_rd24)  // invalidate24 aged24 read
   begin
      mem_addr_age24 <= mem_addr_age24 + 1'd1;     
      mem_write_age24 <= 1'd0;    
   end
   else if (age_chk_state24 == inval_aged_wr24)  // invalidate24 aged24 read
   begin
      mem_addr_age24 <= mem_addr_age24;     
      mem_write_age24 <= 1'd1;    
   end
   else if (age_chk_state24 == inval_all24)  // invalidate24 all
   begin
      mem_addr_age24 <= mem_addr_age24 + 1'd1;     
      mem_write_age24 <= 1'd1;    
   end
   else if (age_chk_state24 == age_chk24)
   begin
      mem_addr_age24 <= mem_addr_age24;     
      mem_write_age24 <= mem_write_age24;    
   end
   else 
   begin
      mem_addr_age24 <= mem_addr_age24;     
      mem_write_age24 <= 1'd0;    
   end
   end

// age24 checker will only ever24 write zero values to ALUT24 mem
assign mem_write_data_age24 = 83'd0;



// -----------------------------------------------------------------------------
//   Generate24 invalidate24 in progress24 flag24 (bit 1 of status register)
// -----------------------------------------------------------------------------
always @ (posedge pclk24 or negedge n_p_reset24)
   begin
   if (~n_p_reset24)
      inval_in_prog24 <= 1'd0;
   else if (age_chk_state24 == inval_aged_wr24) 
      inval_in_prog24 <= 1'd1;
   else if ((age_chk_state24 == age_chk24) & (mem_addr_age24 == max_addr))
      inval_in_prog24 <= 1'd0;
   else
      inval_in_prog24 <= inval_in_prog24;
   end


// -----------------------------------------------------------------------------
//   Calculate24 whether24 data is still in date24.  Need24 to work24 out the real time
//   gap24 between current time and last accessed.  If24 this gap24 is greater than
//   the best24 before age24, then24 the data is out of date24. 
// -----------------------------------------------------------------------------
assign time_since_lst_acc24 = (curr_time24 > last_accessed24) ? 
                            (curr_time24 - last_accessed24) :  // no cnt wrapping24
                            (curr_time24 + (max_cnt24 - last_accessed24));

assign time_since_lst_acc_age24 = (curr_time24 > last_accessed_age24) ? 
                                (curr_time24 - last_accessed_age24) : // no wrapping24
                                (curr_time24 + (max_cnt24 - last_accessed_age24));


always @ (posedge pclk24 or negedge n_p_reset24)
   begin
   if (~n_p_reset24)
      begin
      age_ok24 <= 1'b0;
      age_confirmed24 <= 1'b0;
      end
   else if ((age_chk_state24 == age_chk24) & add_check_active24) 
      begin                                       // age24 checking for addr chkr24
      if (best_bfr_age24 > time_since_lst_acc24)      // still in date24
         begin
         age_ok24 <= 1'b1;
         age_confirmed24 <= 1'b1;
         end
      else   // out of date24
         begin
         age_ok24 <= 1'b0;
         age_confirmed24 <= 1'b1;
         end
      end
   else if ((age_chk_state24 == age_chk24) & ~add_check_active24)
      begin                                      // age24 checking for inval24 aged24
      if (best_bfr_age24 > time_since_lst_acc_age24) // still in date24
         begin
         age_ok24 <= 1'b1;
         age_confirmed24 <= 1'b1;
         end
      else   // out of date24
         begin
         age_ok24 <= 1'b0;
         age_confirmed24 <= 1'b1;
         end
      end
   else
      begin
      age_ok24 <= 1'b0;
      age_confirmed24 <= 1'b0;
      end
   end



// -----------------------------------------------------------------------------
//   Generate24 last address and port that was cleared24 in the invalid aged24 process
// -----------------------------------------------------------------------------
always @ (posedge pclk24 or negedge n_p_reset24)
   begin
   if (~n_p_reset24)
      begin
      lst_inv_addr_cmd24 <= 48'd0;
      lst_inv_port_cmd24 <= 2'd0;
      end
   else if (age_chk_state24 == inval_aged_wr24)
      begin
      lst_inv_addr_cmd24 <= mem_read_data_age24[47:0];
      lst_inv_port_cmd24 <= mem_read_data_age24[49:48];
      end
   else 
      begin
      lst_inv_addr_cmd24 <= lst_inv_addr_cmd24;
      lst_inv_port_cmd24 <= lst_inv_port_cmd24;
      end
   end


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded24 off24 age_chk_state24
// -----------------------------------------------------------------------------
assign age_check_active24 = (age_chk_state24 != 3'b000);

endmodule

