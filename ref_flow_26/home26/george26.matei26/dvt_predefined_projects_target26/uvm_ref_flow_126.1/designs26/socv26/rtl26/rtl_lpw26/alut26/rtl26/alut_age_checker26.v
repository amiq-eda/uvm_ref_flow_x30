//File26 name   : alut_age_checker26.v
//Title26       : 
//Created26     : 1999
//Description26 : 
//Notes26       : 
//----------------------------------------------------------------------
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------

module alut_age_checker26
(   
   // Inputs26
   pclk26,
   n_p_reset26,
   command,          
   div_clk26,          
   mem_read_data_age26,
   check_age26,        
   last_accessed26, 
   best_bfr_age26,   
   add_check_active26,

   // outputs26
   curr_time26,         
   mem_addr_age26,      
   mem_write_age26,     
   mem_write_data_age26,
   lst_inv_addr_cmd26,    
   lst_inv_port_cmd26,  
   age_confirmed26,     
   age_ok26,
   inval_in_prog26,  
   age_check_active26          
);   

   input               pclk26;               // APB26 clock26                           
   input               n_p_reset26;          // Reset26                               
   input [1:0]         command;            // command bus                        
   input [7:0]         div_clk26;            // clock26 divider26 value
   input [82:0]        mem_read_data_age26;  // read data from memory             
   input               check_age26;          // request flag26 for age26 check
   input [31:0]        last_accessed26;      // time field sent26 for age26 check
   input [31:0]        best_bfr_age26;       // best26 before age26
   input               add_check_active26;   // active flag26 from address checker

   output [31:0]       curr_time26;          // current time,for storing26 in mem    
   output [7:0]        mem_addr_age26;       // address for R/W26 to memory     
   output              mem_write_age26;      // R/W26 flag26 (write = high26)            
   output [82:0]       mem_write_data_age26; // write data for memory             
   output [47:0]       lst_inv_addr_cmd26;   // last invalidated26 addr normal26 op    
   output [1:0]        lst_inv_port_cmd26;   // last invalidated26 port normal26 op    
   output              age_confirmed26;      // validates26 age_ok26 result 
   output              age_ok26;             // age26 checker result - set means26 in-date26
   output              inval_in_prog26;      // invalidation26 in progress26
   output              age_check_active26;   // bit 0 of status register           

   reg  [2:0]          age_chk_state26;      // age26 checker FSM26 current state
   reg  [2:0]          nxt_age_chk_state26;  // age26 checker FSM26 next state
   reg  [7:0]          mem_addr_age26;     
   reg                 mem_write_age26;    
   reg                 inval_in_prog26;      // invalidation26 in progress26
   reg  [7:0]          clk_div_cnt26;        // clock26 divider26 counter
   reg  [31:0]         curr_time26;          // current time,for storing26 in mem  
   reg                 age_confirmed26;      // validates26 age_ok26 result 
   reg                 age_ok26;             // age26 checker result - set means26 in-date26
   reg [47:0]          lst_inv_addr_cmd26;   // last invalidated26 addr normal26 op    
   reg [1:0]           lst_inv_port_cmd26;   // last invalidated26 port normal26 op    

   wire  [82:0]        mem_write_data_age26;
   wire  [31:0]        last_accessed_age26;  // read back time by age26 checker
   wire  [31:0]        time_since_lst_acc_age26;  // time since26 last accessed age26
   wire  [31:0]        time_since_lst_acc26; // time since26 last accessed address
   wire                age_check_active26;   // bit 0 of status register           

// Parameters26 for Address Checking26 FSM26 states26
   parameter idle26           = 3'b000;
   parameter inval_aged_rd26  = 3'b001;
   parameter inval_aged_wr26  = 3'b010;
   parameter inval_all26      = 3'b011;
   parameter age_chk26        = 3'b100;

   parameter max_addr       = 8'hff;
   parameter max_cnt26        = 32'hffff_ffff;

// -----------------------------------------------------------------------------
//   Generate26 current time counter
// -----------------------------------------------------------------------------
always @ (posedge pclk26 or negedge n_p_reset26)
   begin
   if (~n_p_reset26)
      clk_div_cnt26 <= 8'd0;
   else if (clk_div_cnt26 == div_clk26)
      clk_div_cnt26 <= 8'd0; 
   else 
      clk_div_cnt26 <= clk_div_cnt26 + 1'd1;
   end


always @ (posedge pclk26 or negedge n_p_reset26)
   begin
   if (~n_p_reset26)
      curr_time26 <= 32'd0;
   else if (clk_div_cnt26 == div_clk26)
      curr_time26 <= curr_time26 + 1'd1;
   end


// -----------------------------------------------------------------------------
//   Age26 checker State26 Machine26 
// -----------------------------------------------------------------------------
always @ (command or check_age26 or age_chk_state26 or age_confirmed26 or age_ok26 or
          mem_addr_age26 or mem_read_data_age26[82])
   begin
      case (age_chk_state26)
      
      idle26:
         if (command == 2'b10)
            nxt_age_chk_state26 = inval_aged_rd26;
         else if (command == 2'b11)
            nxt_age_chk_state26 = inval_all26;
         else if (check_age26)
            nxt_age_chk_state26 = age_chk26;
         else
            nxt_age_chk_state26 = idle26;

      inval_aged_rd26:
            nxt_age_chk_state26 = age_chk26;

      inval_aged_wr26:
            nxt_age_chk_state26 = idle26;

      inval_all26:
         if (mem_addr_age26 != max_addr)
            nxt_age_chk_state26 = inval_all26;  // move26 onto26 next address
         else
            nxt_age_chk_state26 = idle26;

      age_chk26:
         if (age_confirmed26)
            begin
            if (add_check_active26)                     // age26 check for addr chkr26
               nxt_age_chk_state26 = idle26;
            else if (~mem_read_data_age26[82])      // invalid, check next location26
               nxt_age_chk_state26 = inval_aged_rd26; 
            else if (~age_ok26 & mem_read_data_age26[82]) // out of date26, clear 
               nxt_age_chk_state26 = inval_aged_wr26;
            else if (mem_addr_age26 == max_addr)    // full check completed
               nxt_age_chk_state26 = idle26;     
            else 
               nxt_age_chk_state26 = inval_aged_rd26; // age26 ok, check next location26 
            end       
         else
            nxt_age_chk_state26 = age_chk26;

      default:
            nxt_age_chk_state26 = idle26;
      endcase
   end



always @ (posedge pclk26 or negedge n_p_reset26)
   begin
   if (~n_p_reset26)
      age_chk_state26 <= idle26;
   else
      age_chk_state26 <= nxt_age_chk_state26;
   end


// -----------------------------------------------------------------------------
//   Generate26 memory RW bus for accessing array when requested26 to invalidate26 all
//   aged26 addresses26 and all addresses26.
// -----------------------------------------------------------------------------
always @ (posedge pclk26 or negedge n_p_reset26)
   begin
   if (~n_p_reset26)
   begin
      mem_addr_age26 <= 8'd0;     
      mem_write_age26 <= 1'd0;    
   end
   else if (age_chk_state26 == inval_aged_rd26)  // invalidate26 aged26 read
   begin
      mem_addr_age26 <= mem_addr_age26 + 1'd1;     
      mem_write_age26 <= 1'd0;    
   end
   else if (age_chk_state26 == inval_aged_wr26)  // invalidate26 aged26 read
   begin
      mem_addr_age26 <= mem_addr_age26;     
      mem_write_age26 <= 1'd1;    
   end
   else if (age_chk_state26 == inval_all26)  // invalidate26 all
   begin
      mem_addr_age26 <= mem_addr_age26 + 1'd1;     
      mem_write_age26 <= 1'd1;    
   end
   else if (age_chk_state26 == age_chk26)
   begin
      mem_addr_age26 <= mem_addr_age26;     
      mem_write_age26 <= mem_write_age26;    
   end
   else 
   begin
      mem_addr_age26 <= mem_addr_age26;     
      mem_write_age26 <= 1'd0;    
   end
   end

// age26 checker will only ever26 write zero values to ALUT26 mem
assign mem_write_data_age26 = 83'd0;



// -----------------------------------------------------------------------------
//   Generate26 invalidate26 in progress26 flag26 (bit 1 of status register)
// -----------------------------------------------------------------------------
always @ (posedge pclk26 or negedge n_p_reset26)
   begin
   if (~n_p_reset26)
      inval_in_prog26 <= 1'd0;
   else if (age_chk_state26 == inval_aged_wr26) 
      inval_in_prog26 <= 1'd1;
   else if ((age_chk_state26 == age_chk26) & (mem_addr_age26 == max_addr))
      inval_in_prog26 <= 1'd0;
   else
      inval_in_prog26 <= inval_in_prog26;
   end


// -----------------------------------------------------------------------------
//   Calculate26 whether26 data is still in date26.  Need26 to work26 out the real time
//   gap26 between current time and last accessed.  If26 this gap26 is greater than
//   the best26 before age26, then26 the data is out of date26. 
// -----------------------------------------------------------------------------
assign time_since_lst_acc26 = (curr_time26 > last_accessed26) ? 
                            (curr_time26 - last_accessed26) :  // no cnt wrapping26
                            (curr_time26 + (max_cnt26 - last_accessed26));

assign time_since_lst_acc_age26 = (curr_time26 > last_accessed_age26) ? 
                                (curr_time26 - last_accessed_age26) : // no wrapping26
                                (curr_time26 + (max_cnt26 - last_accessed_age26));


always @ (posedge pclk26 or negedge n_p_reset26)
   begin
   if (~n_p_reset26)
      begin
      age_ok26 <= 1'b0;
      age_confirmed26 <= 1'b0;
      end
   else if ((age_chk_state26 == age_chk26) & add_check_active26) 
      begin                                       // age26 checking for addr chkr26
      if (best_bfr_age26 > time_since_lst_acc26)      // still in date26
         begin
         age_ok26 <= 1'b1;
         age_confirmed26 <= 1'b1;
         end
      else   // out of date26
         begin
         age_ok26 <= 1'b0;
         age_confirmed26 <= 1'b1;
         end
      end
   else if ((age_chk_state26 == age_chk26) & ~add_check_active26)
      begin                                      // age26 checking for inval26 aged26
      if (best_bfr_age26 > time_since_lst_acc_age26) // still in date26
         begin
         age_ok26 <= 1'b1;
         age_confirmed26 <= 1'b1;
         end
      else   // out of date26
         begin
         age_ok26 <= 1'b0;
         age_confirmed26 <= 1'b1;
         end
      end
   else
      begin
      age_ok26 <= 1'b0;
      age_confirmed26 <= 1'b0;
      end
   end



// -----------------------------------------------------------------------------
//   Generate26 last address and port that was cleared26 in the invalid aged26 process
// -----------------------------------------------------------------------------
always @ (posedge pclk26 or negedge n_p_reset26)
   begin
   if (~n_p_reset26)
      begin
      lst_inv_addr_cmd26 <= 48'd0;
      lst_inv_port_cmd26 <= 2'd0;
      end
   else if (age_chk_state26 == inval_aged_wr26)
      begin
      lst_inv_addr_cmd26 <= mem_read_data_age26[47:0];
      lst_inv_port_cmd26 <= mem_read_data_age26[49:48];
      end
   else 
      begin
      lst_inv_addr_cmd26 <= lst_inv_addr_cmd26;
      lst_inv_port_cmd26 <= lst_inv_port_cmd26;
      end
   end


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded26 off26 age_chk_state26
// -----------------------------------------------------------------------------
assign age_check_active26 = (age_chk_state26 != 3'b000);

endmodule

