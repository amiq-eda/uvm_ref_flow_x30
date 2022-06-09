//File11 name   : alut_age_checker11.v
//Title11       : 
//Created11     : 1999
//Description11 : 
//Notes11       : 
//----------------------------------------------------------------------
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------

module alut_age_checker11
(   
   // Inputs11
   pclk11,
   n_p_reset11,
   command,          
   div_clk11,          
   mem_read_data_age11,
   check_age11,        
   last_accessed11, 
   best_bfr_age11,   
   add_check_active11,

   // outputs11
   curr_time11,         
   mem_addr_age11,      
   mem_write_age11,     
   mem_write_data_age11,
   lst_inv_addr_cmd11,    
   lst_inv_port_cmd11,  
   age_confirmed11,     
   age_ok11,
   inval_in_prog11,  
   age_check_active11          
);   

   input               pclk11;               // APB11 clock11                           
   input               n_p_reset11;          // Reset11                               
   input [1:0]         command;            // command bus                        
   input [7:0]         div_clk11;            // clock11 divider11 value
   input [82:0]        mem_read_data_age11;  // read data from memory             
   input               check_age11;          // request flag11 for age11 check
   input [31:0]        last_accessed11;      // time field sent11 for age11 check
   input [31:0]        best_bfr_age11;       // best11 before age11
   input               add_check_active11;   // active flag11 from address checker

   output [31:0]       curr_time11;          // current time,for storing11 in mem    
   output [7:0]        mem_addr_age11;       // address for R/W11 to memory     
   output              mem_write_age11;      // R/W11 flag11 (write = high11)            
   output [82:0]       mem_write_data_age11; // write data for memory             
   output [47:0]       lst_inv_addr_cmd11;   // last invalidated11 addr normal11 op    
   output [1:0]        lst_inv_port_cmd11;   // last invalidated11 port normal11 op    
   output              age_confirmed11;      // validates11 age_ok11 result 
   output              age_ok11;             // age11 checker result - set means11 in-date11
   output              inval_in_prog11;      // invalidation11 in progress11
   output              age_check_active11;   // bit 0 of status register           

   reg  [2:0]          age_chk_state11;      // age11 checker FSM11 current state
   reg  [2:0]          nxt_age_chk_state11;  // age11 checker FSM11 next state
   reg  [7:0]          mem_addr_age11;     
   reg                 mem_write_age11;    
   reg                 inval_in_prog11;      // invalidation11 in progress11
   reg  [7:0]          clk_div_cnt11;        // clock11 divider11 counter
   reg  [31:0]         curr_time11;          // current time,for storing11 in mem  
   reg                 age_confirmed11;      // validates11 age_ok11 result 
   reg                 age_ok11;             // age11 checker result - set means11 in-date11
   reg [47:0]          lst_inv_addr_cmd11;   // last invalidated11 addr normal11 op    
   reg [1:0]           lst_inv_port_cmd11;   // last invalidated11 port normal11 op    

   wire  [82:0]        mem_write_data_age11;
   wire  [31:0]        last_accessed_age11;  // read back time by age11 checker
   wire  [31:0]        time_since_lst_acc_age11;  // time since11 last accessed age11
   wire  [31:0]        time_since_lst_acc11; // time since11 last accessed address
   wire                age_check_active11;   // bit 0 of status register           

// Parameters11 for Address Checking11 FSM11 states11
   parameter idle11           = 3'b000;
   parameter inval_aged_rd11  = 3'b001;
   parameter inval_aged_wr11  = 3'b010;
   parameter inval_all11      = 3'b011;
   parameter age_chk11        = 3'b100;

   parameter max_addr       = 8'hff;
   parameter max_cnt11        = 32'hffff_ffff;

// -----------------------------------------------------------------------------
//   Generate11 current time counter
// -----------------------------------------------------------------------------
always @ (posedge pclk11 or negedge n_p_reset11)
   begin
   if (~n_p_reset11)
      clk_div_cnt11 <= 8'd0;
   else if (clk_div_cnt11 == div_clk11)
      clk_div_cnt11 <= 8'd0; 
   else 
      clk_div_cnt11 <= clk_div_cnt11 + 1'd1;
   end


always @ (posedge pclk11 or negedge n_p_reset11)
   begin
   if (~n_p_reset11)
      curr_time11 <= 32'd0;
   else if (clk_div_cnt11 == div_clk11)
      curr_time11 <= curr_time11 + 1'd1;
   end


// -----------------------------------------------------------------------------
//   Age11 checker State11 Machine11 
// -----------------------------------------------------------------------------
always @ (command or check_age11 or age_chk_state11 or age_confirmed11 or age_ok11 or
          mem_addr_age11 or mem_read_data_age11[82])
   begin
      case (age_chk_state11)
      
      idle11:
         if (command == 2'b10)
            nxt_age_chk_state11 = inval_aged_rd11;
         else if (command == 2'b11)
            nxt_age_chk_state11 = inval_all11;
         else if (check_age11)
            nxt_age_chk_state11 = age_chk11;
         else
            nxt_age_chk_state11 = idle11;

      inval_aged_rd11:
            nxt_age_chk_state11 = age_chk11;

      inval_aged_wr11:
            nxt_age_chk_state11 = idle11;

      inval_all11:
         if (mem_addr_age11 != max_addr)
            nxt_age_chk_state11 = inval_all11;  // move11 onto11 next address
         else
            nxt_age_chk_state11 = idle11;

      age_chk11:
         if (age_confirmed11)
            begin
            if (add_check_active11)                     // age11 check for addr chkr11
               nxt_age_chk_state11 = idle11;
            else if (~mem_read_data_age11[82])      // invalid, check next location11
               nxt_age_chk_state11 = inval_aged_rd11; 
            else if (~age_ok11 & mem_read_data_age11[82]) // out of date11, clear 
               nxt_age_chk_state11 = inval_aged_wr11;
            else if (mem_addr_age11 == max_addr)    // full check completed
               nxt_age_chk_state11 = idle11;     
            else 
               nxt_age_chk_state11 = inval_aged_rd11; // age11 ok, check next location11 
            end       
         else
            nxt_age_chk_state11 = age_chk11;

      default:
            nxt_age_chk_state11 = idle11;
      endcase
   end



always @ (posedge pclk11 or negedge n_p_reset11)
   begin
   if (~n_p_reset11)
      age_chk_state11 <= idle11;
   else
      age_chk_state11 <= nxt_age_chk_state11;
   end


// -----------------------------------------------------------------------------
//   Generate11 memory RW bus for accessing array when requested11 to invalidate11 all
//   aged11 addresses11 and all addresses11.
// -----------------------------------------------------------------------------
always @ (posedge pclk11 or negedge n_p_reset11)
   begin
   if (~n_p_reset11)
   begin
      mem_addr_age11 <= 8'd0;     
      mem_write_age11 <= 1'd0;    
   end
   else if (age_chk_state11 == inval_aged_rd11)  // invalidate11 aged11 read
   begin
      mem_addr_age11 <= mem_addr_age11 + 1'd1;     
      mem_write_age11 <= 1'd0;    
   end
   else if (age_chk_state11 == inval_aged_wr11)  // invalidate11 aged11 read
   begin
      mem_addr_age11 <= mem_addr_age11;     
      mem_write_age11 <= 1'd1;    
   end
   else if (age_chk_state11 == inval_all11)  // invalidate11 all
   begin
      mem_addr_age11 <= mem_addr_age11 + 1'd1;     
      mem_write_age11 <= 1'd1;    
   end
   else if (age_chk_state11 == age_chk11)
   begin
      mem_addr_age11 <= mem_addr_age11;     
      mem_write_age11 <= mem_write_age11;    
   end
   else 
   begin
      mem_addr_age11 <= mem_addr_age11;     
      mem_write_age11 <= 1'd0;    
   end
   end

// age11 checker will only ever11 write zero values to ALUT11 mem
assign mem_write_data_age11 = 83'd0;



// -----------------------------------------------------------------------------
//   Generate11 invalidate11 in progress11 flag11 (bit 1 of status register)
// -----------------------------------------------------------------------------
always @ (posedge pclk11 or negedge n_p_reset11)
   begin
   if (~n_p_reset11)
      inval_in_prog11 <= 1'd0;
   else if (age_chk_state11 == inval_aged_wr11) 
      inval_in_prog11 <= 1'd1;
   else if ((age_chk_state11 == age_chk11) & (mem_addr_age11 == max_addr))
      inval_in_prog11 <= 1'd0;
   else
      inval_in_prog11 <= inval_in_prog11;
   end


// -----------------------------------------------------------------------------
//   Calculate11 whether11 data is still in date11.  Need11 to work11 out the real time
//   gap11 between current time and last accessed.  If11 this gap11 is greater than
//   the best11 before age11, then11 the data is out of date11. 
// -----------------------------------------------------------------------------
assign time_since_lst_acc11 = (curr_time11 > last_accessed11) ? 
                            (curr_time11 - last_accessed11) :  // no cnt wrapping11
                            (curr_time11 + (max_cnt11 - last_accessed11));

assign time_since_lst_acc_age11 = (curr_time11 > last_accessed_age11) ? 
                                (curr_time11 - last_accessed_age11) : // no wrapping11
                                (curr_time11 + (max_cnt11 - last_accessed_age11));


always @ (posedge pclk11 or negedge n_p_reset11)
   begin
   if (~n_p_reset11)
      begin
      age_ok11 <= 1'b0;
      age_confirmed11 <= 1'b0;
      end
   else if ((age_chk_state11 == age_chk11) & add_check_active11) 
      begin                                       // age11 checking for addr chkr11
      if (best_bfr_age11 > time_since_lst_acc11)      // still in date11
         begin
         age_ok11 <= 1'b1;
         age_confirmed11 <= 1'b1;
         end
      else   // out of date11
         begin
         age_ok11 <= 1'b0;
         age_confirmed11 <= 1'b1;
         end
      end
   else if ((age_chk_state11 == age_chk11) & ~add_check_active11)
      begin                                      // age11 checking for inval11 aged11
      if (best_bfr_age11 > time_since_lst_acc_age11) // still in date11
         begin
         age_ok11 <= 1'b1;
         age_confirmed11 <= 1'b1;
         end
      else   // out of date11
         begin
         age_ok11 <= 1'b0;
         age_confirmed11 <= 1'b1;
         end
      end
   else
      begin
      age_ok11 <= 1'b0;
      age_confirmed11 <= 1'b0;
      end
   end



// -----------------------------------------------------------------------------
//   Generate11 last address and port that was cleared11 in the invalid aged11 process
// -----------------------------------------------------------------------------
always @ (posedge pclk11 or negedge n_p_reset11)
   begin
   if (~n_p_reset11)
      begin
      lst_inv_addr_cmd11 <= 48'd0;
      lst_inv_port_cmd11 <= 2'd0;
      end
   else if (age_chk_state11 == inval_aged_wr11)
      begin
      lst_inv_addr_cmd11 <= mem_read_data_age11[47:0];
      lst_inv_port_cmd11 <= mem_read_data_age11[49:48];
      end
   else 
      begin
      lst_inv_addr_cmd11 <= lst_inv_addr_cmd11;
      lst_inv_port_cmd11 <= lst_inv_port_cmd11;
      end
   end


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded11 off11 age_chk_state11
// -----------------------------------------------------------------------------
assign age_check_active11 = (age_chk_state11 != 3'b000);

endmodule

