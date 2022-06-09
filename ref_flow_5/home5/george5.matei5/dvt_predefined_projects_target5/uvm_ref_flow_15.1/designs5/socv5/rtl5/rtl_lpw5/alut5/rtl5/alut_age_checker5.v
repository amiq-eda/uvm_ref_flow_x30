//File5 name   : alut_age_checker5.v
//Title5       : 
//Created5     : 1999
//Description5 : 
//Notes5       : 
//----------------------------------------------------------------------
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------

module alut_age_checker5
(   
   // Inputs5
   pclk5,
   n_p_reset5,
   command,          
   div_clk5,          
   mem_read_data_age5,
   check_age5,        
   last_accessed5, 
   best_bfr_age5,   
   add_check_active5,

   // outputs5
   curr_time5,         
   mem_addr_age5,      
   mem_write_age5,     
   mem_write_data_age5,
   lst_inv_addr_cmd5,    
   lst_inv_port_cmd5,  
   age_confirmed5,     
   age_ok5,
   inval_in_prog5,  
   age_check_active5          
);   

   input               pclk5;               // APB5 clock5                           
   input               n_p_reset5;          // Reset5                               
   input [1:0]         command;            // command bus                        
   input [7:0]         div_clk5;            // clock5 divider5 value
   input [82:0]        mem_read_data_age5;  // read data from memory             
   input               check_age5;          // request flag5 for age5 check
   input [31:0]        last_accessed5;      // time field sent5 for age5 check
   input [31:0]        best_bfr_age5;       // best5 before age5
   input               add_check_active5;   // active flag5 from address checker

   output [31:0]       curr_time5;          // current time,for storing5 in mem    
   output [7:0]        mem_addr_age5;       // address for R/W5 to memory     
   output              mem_write_age5;      // R/W5 flag5 (write = high5)            
   output [82:0]       mem_write_data_age5; // write data for memory             
   output [47:0]       lst_inv_addr_cmd5;   // last invalidated5 addr normal5 op    
   output [1:0]        lst_inv_port_cmd5;   // last invalidated5 port normal5 op    
   output              age_confirmed5;      // validates5 age_ok5 result 
   output              age_ok5;             // age5 checker result - set means5 in-date5
   output              inval_in_prog5;      // invalidation5 in progress5
   output              age_check_active5;   // bit 0 of status register           

   reg  [2:0]          age_chk_state5;      // age5 checker FSM5 current state
   reg  [2:0]          nxt_age_chk_state5;  // age5 checker FSM5 next state
   reg  [7:0]          mem_addr_age5;     
   reg                 mem_write_age5;    
   reg                 inval_in_prog5;      // invalidation5 in progress5
   reg  [7:0]          clk_div_cnt5;        // clock5 divider5 counter
   reg  [31:0]         curr_time5;          // current time,for storing5 in mem  
   reg                 age_confirmed5;      // validates5 age_ok5 result 
   reg                 age_ok5;             // age5 checker result - set means5 in-date5
   reg [47:0]          lst_inv_addr_cmd5;   // last invalidated5 addr normal5 op    
   reg [1:0]           lst_inv_port_cmd5;   // last invalidated5 port normal5 op    

   wire  [82:0]        mem_write_data_age5;
   wire  [31:0]        last_accessed_age5;  // read back time by age5 checker
   wire  [31:0]        time_since_lst_acc_age5;  // time since5 last accessed age5
   wire  [31:0]        time_since_lst_acc5; // time since5 last accessed address
   wire                age_check_active5;   // bit 0 of status register           

// Parameters5 for Address Checking5 FSM5 states5
   parameter idle5           = 3'b000;
   parameter inval_aged_rd5  = 3'b001;
   parameter inval_aged_wr5  = 3'b010;
   parameter inval_all5      = 3'b011;
   parameter age_chk5        = 3'b100;

   parameter max_addr       = 8'hff;
   parameter max_cnt5        = 32'hffff_ffff;

// -----------------------------------------------------------------------------
//   Generate5 current time counter
// -----------------------------------------------------------------------------
always @ (posedge pclk5 or negedge n_p_reset5)
   begin
   if (~n_p_reset5)
      clk_div_cnt5 <= 8'd0;
   else if (clk_div_cnt5 == div_clk5)
      clk_div_cnt5 <= 8'd0; 
   else 
      clk_div_cnt5 <= clk_div_cnt5 + 1'd1;
   end


always @ (posedge pclk5 or negedge n_p_reset5)
   begin
   if (~n_p_reset5)
      curr_time5 <= 32'd0;
   else if (clk_div_cnt5 == div_clk5)
      curr_time5 <= curr_time5 + 1'd1;
   end


// -----------------------------------------------------------------------------
//   Age5 checker State5 Machine5 
// -----------------------------------------------------------------------------
always @ (command or check_age5 or age_chk_state5 or age_confirmed5 or age_ok5 or
          mem_addr_age5 or mem_read_data_age5[82])
   begin
      case (age_chk_state5)
      
      idle5:
         if (command == 2'b10)
            nxt_age_chk_state5 = inval_aged_rd5;
         else if (command == 2'b11)
            nxt_age_chk_state5 = inval_all5;
         else if (check_age5)
            nxt_age_chk_state5 = age_chk5;
         else
            nxt_age_chk_state5 = idle5;

      inval_aged_rd5:
            nxt_age_chk_state5 = age_chk5;

      inval_aged_wr5:
            nxt_age_chk_state5 = idle5;

      inval_all5:
         if (mem_addr_age5 != max_addr)
            nxt_age_chk_state5 = inval_all5;  // move5 onto5 next address
         else
            nxt_age_chk_state5 = idle5;

      age_chk5:
         if (age_confirmed5)
            begin
            if (add_check_active5)                     // age5 check for addr chkr5
               nxt_age_chk_state5 = idle5;
            else if (~mem_read_data_age5[82])      // invalid, check next location5
               nxt_age_chk_state5 = inval_aged_rd5; 
            else if (~age_ok5 & mem_read_data_age5[82]) // out of date5, clear 
               nxt_age_chk_state5 = inval_aged_wr5;
            else if (mem_addr_age5 == max_addr)    // full check completed
               nxt_age_chk_state5 = idle5;     
            else 
               nxt_age_chk_state5 = inval_aged_rd5; // age5 ok, check next location5 
            end       
         else
            nxt_age_chk_state5 = age_chk5;

      default:
            nxt_age_chk_state5 = idle5;
      endcase
   end



always @ (posedge pclk5 or negedge n_p_reset5)
   begin
   if (~n_p_reset5)
      age_chk_state5 <= idle5;
   else
      age_chk_state5 <= nxt_age_chk_state5;
   end


// -----------------------------------------------------------------------------
//   Generate5 memory RW bus for accessing array when requested5 to invalidate5 all
//   aged5 addresses5 and all addresses5.
// -----------------------------------------------------------------------------
always @ (posedge pclk5 or negedge n_p_reset5)
   begin
   if (~n_p_reset5)
   begin
      mem_addr_age5 <= 8'd0;     
      mem_write_age5 <= 1'd0;    
   end
   else if (age_chk_state5 == inval_aged_rd5)  // invalidate5 aged5 read
   begin
      mem_addr_age5 <= mem_addr_age5 + 1'd1;     
      mem_write_age5 <= 1'd0;    
   end
   else if (age_chk_state5 == inval_aged_wr5)  // invalidate5 aged5 read
   begin
      mem_addr_age5 <= mem_addr_age5;     
      mem_write_age5 <= 1'd1;    
   end
   else if (age_chk_state5 == inval_all5)  // invalidate5 all
   begin
      mem_addr_age5 <= mem_addr_age5 + 1'd1;     
      mem_write_age5 <= 1'd1;    
   end
   else if (age_chk_state5 == age_chk5)
   begin
      mem_addr_age5 <= mem_addr_age5;     
      mem_write_age5 <= mem_write_age5;    
   end
   else 
   begin
      mem_addr_age5 <= mem_addr_age5;     
      mem_write_age5 <= 1'd0;    
   end
   end

// age5 checker will only ever5 write zero values to ALUT5 mem
assign mem_write_data_age5 = 83'd0;



// -----------------------------------------------------------------------------
//   Generate5 invalidate5 in progress5 flag5 (bit 1 of status register)
// -----------------------------------------------------------------------------
always @ (posedge pclk5 or negedge n_p_reset5)
   begin
   if (~n_p_reset5)
      inval_in_prog5 <= 1'd0;
   else if (age_chk_state5 == inval_aged_wr5) 
      inval_in_prog5 <= 1'd1;
   else if ((age_chk_state5 == age_chk5) & (mem_addr_age5 == max_addr))
      inval_in_prog5 <= 1'd0;
   else
      inval_in_prog5 <= inval_in_prog5;
   end


// -----------------------------------------------------------------------------
//   Calculate5 whether5 data is still in date5.  Need5 to work5 out the real time
//   gap5 between current time and last accessed.  If5 this gap5 is greater than
//   the best5 before age5, then5 the data is out of date5. 
// -----------------------------------------------------------------------------
assign time_since_lst_acc5 = (curr_time5 > last_accessed5) ? 
                            (curr_time5 - last_accessed5) :  // no cnt wrapping5
                            (curr_time5 + (max_cnt5 - last_accessed5));

assign time_since_lst_acc_age5 = (curr_time5 > last_accessed_age5) ? 
                                (curr_time5 - last_accessed_age5) : // no wrapping5
                                (curr_time5 + (max_cnt5 - last_accessed_age5));


always @ (posedge pclk5 or negedge n_p_reset5)
   begin
   if (~n_p_reset5)
      begin
      age_ok5 <= 1'b0;
      age_confirmed5 <= 1'b0;
      end
   else if ((age_chk_state5 == age_chk5) & add_check_active5) 
      begin                                       // age5 checking for addr chkr5
      if (best_bfr_age5 > time_since_lst_acc5)      // still in date5
         begin
         age_ok5 <= 1'b1;
         age_confirmed5 <= 1'b1;
         end
      else   // out of date5
         begin
         age_ok5 <= 1'b0;
         age_confirmed5 <= 1'b1;
         end
      end
   else if ((age_chk_state5 == age_chk5) & ~add_check_active5)
      begin                                      // age5 checking for inval5 aged5
      if (best_bfr_age5 > time_since_lst_acc_age5) // still in date5
         begin
         age_ok5 <= 1'b1;
         age_confirmed5 <= 1'b1;
         end
      else   // out of date5
         begin
         age_ok5 <= 1'b0;
         age_confirmed5 <= 1'b1;
         end
      end
   else
      begin
      age_ok5 <= 1'b0;
      age_confirmed5 <= 1'b0;
      end
   end



// -----------------------------------------------------------------------------
//   Generate5 last address and port that was cleared5 in the invalid aged5 process
// -----------------------------------------------------------------------------
always @ (posedge pclk5 or negedge n_p_reset5)
   begin
   if (~n_p_reset5)
      begin
      lst_inv_addr_cmd5 <= 48'd0;
      lst_inv_port_cmd5 <= 2'd0;
      end
   else if (age_chk_state5 == inval_aged_wr5)
      begin
      lst_inv_addr_cmd5 <= mem_read_data_age5[47:0];
      lst_inv_port_cmd5 <= mem_read_data_age5[49:48];
      end
   else 
      begin
      lst_inv_addr_cmd5 <= lst_inv_addr_cmd5;
      lst_inv_port_cmd5 <= lst_inv_port_cmd5;
      end
   end


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded5 off5 age_chk_state5
// -----------------------------------------------------------------------------
assign age_check_active5 = (age_chk_state5 != 3'b000);

endmodule

