//File14 name   : alut_age_checker14.v
//Title14       : 
//Created14     : 1999
//Description14 : 
//Notes14       : 
//----------------------------------------------------------------------
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------

module alut_age_checker14
(   
   // Inputs14
   pclk14,
   n_p_reset14,
   command,          
   div_clk14,          
   mem_read_data_age14,
   check_age14,        
   last_accessed14, 
   best_bfr_age14,   
   add_check_active14,

   // outputs14
   curr_time14,         
   mem_addr_age14,      
   mem_write_age14,     
   mem_write_data_age14,
   lst_inv_addr_cmd14,    
   lst_inv_port_cmd14,  
   age_confirmed14,     
   age_ok14,
   inval_in_prog14,  
   age_check_active14          
);   

   input               pclk14;               // APB14 clock14                           
   input               n_p_reset14;          // Reset14                               
   input [1:0]         command;            // command bus                        
   input [7:0]         div_clk14;            // clock14 divider14 value
   input [82:0]        mem_read_data_age14;  // read data from memory             
   input               check_age14;          // request flag14 for age14 check
   input [31:0]        last_accessed14;      // time field sent14 for age14 check
   input [31:0]        best_bfr_age14;       // best14 before age14
   input               add_check_active14;   // active flag14 from address checker

   output [31:0]       curr_time14;          // current time,for storing14 in mem    
   output [7:0]        mem_addr_age14;       // address for R/W14 to memory     
   output              mem_write_age14;      // R/W14 flag14 (write = high14)            
   output [82:0]       mem_write_data_age14; // write data for memory             
   output [47:0]       lst_inv_addr_cmd14;   // last invalidated14 addr normal14 op    
   output [1:0]        lst_inv_port_cmd14;   // last invalidated14 port normal14 op    
   output              age_confirmed14;      // validates14 age_ok14 result 
   output              age_ok14;             // age14 checker result - set means14 in-date14
   output              inval_in_prog14;      // invalidation14 in progress14
   output              age_check_active14;   // bit 0 of status register           

   reg  [2:0]          age_chk_state14;      // age14 checker FSM14 current state
   reg  [2:0]          nxt_age_chk_state14;  // age14 checker FSM14 next state
   reg  [7:0]          mem_addr_age14;     
   reg                 mem_write_age14;    
   reg                 inval_in_prog14;      // invalidation14 in progress14
   reg  [7:0]          clk_div_cnt14;        // clock14 divider14 counter
   reg  [31:0]         curr_time14;          // current time,for storing14 in mem  
   reg                 age_confirmed14;      // validates14 age_ok14 result 
   reg                 age_ok14;             // age14 checker result - set means14 in-date14
   reg [47:0]          lst_inv_addr_cmd14;   // last invalidated14 addr normal14 op    
   reg [1:0]           lst_inv_port_cmd14;   // last invalidated14 port normal14 op    

   wire  [82:0]        mem_write_data_age14;
   wire  [31:0]        last_accessed_age14;  // read back time by age14 checker
   wire  [31:0]        time_since_lst_acc_age14;  // time since14 last accessed age14
   wire  [31:0]        time_since_lst_acc14; // time since14 last accessed address
   wire                age_check_active14;   // bit 0 of status register           

// Parameters14 for Address Checking14 FSM14 states14
   parameter idle14           = 3'b000;
   parameter inval_aged_rd14  = 3'b001;
   parameter inval_aged_wr14  = 3'b010;
   parameter inval_all14      = 3'b011;
   parameter age_chk14        = 3'b100;

   parameter max_addr       = 8'hff;
   parameter max_cnt14        = 32'hffff_ffff;

// -----------------------------------------------------------------------------
//   Generate14 current time counter
// -----------------------------------------------------------------------------
always @ (posedge pclk14 or negedge n_p_reset14)
   begin
   if (~n_p_reset14)
      clk_div_cnt14 <= 8'd0;
   else if (clk_div_cnt14 == div_clk14)
      clk_div_cnt14 <= 8'd0; 
   else 
      clk_div_cnt14 <= clk_div_cnt14 + 1'd1;
   end


always @ (posedge pclk14 or negedge n_p_reset14)
   begin
   if (~n_p_reset14)
      curr_time14 <= 32'd0;
   else if (clk_div_cnt14 == div_clk14)
      curr_time14 <= curr_time14 + 1'd1;
   end


// -----------------------------------------------------------------------------
//   Age14 checker State14 Machine14 
// -----------------------------------------------------------------------------
always @ (command or check_age14 or age_chk_state14 or age_confirmed14 or age_ok14 or
          mem_addr_age14 or mem_read_data_age14[82])
   begin
      case (age_chk_state14)
      
      idle14:
         if (command == 2'b10)
            nxt_age_chk_state14 = inval_aged_rd14;
         else if (command == 2'b11)
            nxt_age_chk_state14 = inval_all14;
         else if (check_age14)
            nxt_age_chk_state14 = age_chk14;
         else
            nxt_age_chk_state14 = idle14;

      inval_aged_rd14:
            nxt_age_chk_state14 = age_chk14;

      inval_aged_wr14:
            nxt_age_chk_state14 = idle14;

      inval_all14:
         if (mem_addr_age14 != max_addr)
            nxt_age_chk_state14 = inval_all14;  // move14 onto14 next address
         else
            nxt_age_chk_state14 = idle14;

      age_chk14:
         if (age_confirmed14)
            begin
            if (add_check_active14)                     // age14 check for addr chkr14
               nxt_age_chk_state14 = idle14;
            else if (~mem_read_data_age14[82])      // invalid, check next location14
               nxt_age_chk_state14 = inval_aged_rd14; 
            else if (~age_ok14 & mem_read_data_age14[82]) // out of date14, clear 
               nxt_age_chk_state14 = inval_aged_wr14;
            else if (mem_addr_age14 == max_addr)    // full check completed
               nxt_age_chk_state14 = idle14;     
            else 
               nxt_age_chk_state14 = inval_aged_rd14; // age14 ok, check next location14 
            end       
         else
            nxt_age_chk_state14 = age_chk14;

      default:
            nxt_age_chk_state14 = idle14;
      endcase
   end



always @ (posedge pclk14 or negedge n_p_reset14)
   begin
   if (~n_p_reset14)
      age_chk_state14 <= idle14;
   else
      age_chk_state14 <= nxt_age_chk_state14;
   end


// -----------------------------------------------------------------------------
//   Generate14 memory RW bus for accessing array when requested14 to invalidate14 all
//   aged14 addresses14 and all addresses14.
// -----------------------------------------------------------------------------
always @ (posedge pclk14 or negedge n_p_reset14)
   begin
   if (~n_p_reset14)
   begin
      mem_addr_age14 <= 8'd0;     
      mem_write_age14 <= 1'd0;    
   end
   else if (age_chk_state14 == inval_aged_rd14)  // invalidate14 aged14 read
   begin
      mem_addr_age14 <= mem_addr_age14 + 1'd1;     
      mem_write_age14 <= 1'd0;    
   end
   else if (age_chk_state14 == inval_aged_wr14)  // invalidate14 aged14 read
   begin
      mem_addr_age14 <= mem_addr_age14;     
      mem_write_age14 <= 1'd1;    
   end
   else if (age_chk_state14 == inval_all14)  // invalidate14 all
   begin
      mem_addr_age14 <= mem_addr_age14 + 1'd1;     
      mem_write_age14 <= 1'd1;    
   end
   else if (age_chk_state14 == age_chk14)
   begin
      mem_addr_age14 <= mem_addr_age14;     
      mem_write_age14 <= mem_write_age14;    
   end
   else 
   begin
      mem_addr_age14 <= mem_addr_age14;     
      mem_write_age14 <= 1'd0;    
   end
   end

// age14 checker will only ever14 write zero values to ALUT14 mem
assign mem_write_data_age14 = 83'd0;



// -----------------------------------------------------------------------------
//   Generate14 invalidate14 in progress14 flag14 (bit 1 of status register)
// -----------------------------------------------------------------------------
always @ (posedge pclk14 or negedge n_p_reset14)
   begin
   if (~n_p_reset14)
      inval_in_prog14 <= 1'd0;
   else if (age_chk_state14 == inval_aged_wr14) 
      inval_in_prog14 <= 1'd1;
   else if ((age_chk_state14 == age_chk14) & (mem_addr_age14 == max_addr))
      inval_in_prog14 <= 1'd0;
   else
      inval_in_prog14 <= inval_in_prog14;
   end


// -----------------------------------------------------------------------------
//   Calculate14 whether14 data is still in date14.  Need14 to work14 out the real time
//   gap14 between current time and last accessed.  If14 this gap14 is greater than
//   the best14 before age14, then14 the data is out of date14. 
// -----------------------------------------------------------------------------
assign time_since_lst_acc14 = (curr_time14 > last_accessed14) ? 
                            (curr_time14 - last_accessed14) :  // no cnt wrapping14
                            (curr_time14 + (max_cnt14 - last_accessed14));

assign time_since_lst_acc_age14 = (curr_time14 > last_accessed_age14) ? 
                                (curr_time14 - last_accessed_age14) : // no wrapping14
                                (curr_time14 + (max_cnt14 - last_accessed_age14));


always @ (posedge pclk14 or negedge n_p_reset14)
   begin
   if (~n_p_reset14)
      begin
      age_ok14 <= 1'b0;
      age_confirmed14 <= 1'b0;
      end
   else if ((age_chk_state14 == age_chk14) & add_check_active14) 
      begin                                       // age14 checking for addr chkr14
      if (best_bfr_age14 > time_since_lst_acc14)      // still in date14
         begin
         age_ok14 <= 1'b1;
         age_confirmed14 <= 1'b1;
         end
      else   // out of date14
         begin
         age_ok14 <= 1'b0;
         age_confirmed14 <= 1'b1;
         end
      end
   else if ((age_chk_state14 == age_chk14) & ~add_check_active14)
      begin                                      // age14 checking for inval14 aged14
      if (best_bfr_age14 > time_since_lst_acc_age14) // still in date14
         begin
         age_ok14 <= 1'b1;
         age_confirmed14 <= 1'b1;
         end
      else   // out of date14
         begin
         age_ok14 <= 1'b0;
         age_confirmed14 <= 1'b1;
         end
      end
   else
      begin
      age_ok14 <= 1'b0;
      age_confirmed14 <= 1'b0;
      end
   end



// -----------------------------------------------------------------------------
//   Generate14 last address and port that was cleared14 in the invalid aged14 process
// -----------------------------------------------------------------------------
always @ (posedge pclk14 or negedge n_p_reset14)
   begin
   if (~n_p_reset14)
      begin
      lst_inv_addr_cmd14 <= 48'd0;
      lst_inv_port_cmd14 <= 2'd0;
      end
   else if (age_chk_state14 == inval_aged_wr14)
      begin
      lst_inv_addr_cmd14 <= mem_read_data_age14[47:0];
      lst_inv_port_cmd14 <= mem_read_data_age14[49:48];
      end
   else 
      begin
      lst_inv_addr_cmd14 <= lst_inv_addr_cmd14;
      lst_inv_port_cmd14 <= lst_inv_port_cmd14;
      end
   end


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded14 off14 age_chk_state14
// -----------------------------------------------------------------------------
assign age_check_active14 = (age_chk_state14 != 3'b000);

endmodule

