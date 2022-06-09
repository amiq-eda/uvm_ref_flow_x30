//File16 name   : alut_age_checker16.v
//Title16       : 
//Created16     : 1999
//Description16 : 
//Notes16       : 
//----------------------------------------------------------------------
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------

module alut_age_checker16
(   
   // Inputs16
   pclk16,
   n_p_reset16,
   command,          
   div_clk16,          
   mem_read_data_age16,
   check_age16,        
   last_accessed16, 
   best_bfr_age16,   
   add_check_active16,

   // outputs16
   curr_time16,         
   mem_addr_age16,      
   mem_write_age16,     
   mem_write_data_age16,
   lst_inv_addr_cmd16,    
   lst_inv_port_cmd16,  
   age_confirmed16,     
   age_ok16,
   inval_in_prog16,  
   age_check_active16          
);   

   input               pclk16;               // APB16 clock16                           
   input               n_p_reset16;          // Reset16                               
   input [1:0]         command;            // command bus                        
   input [7:0]         div_clk16;            // clock16 divider16 value
   input [82:0]        mem_read_data_age16;  // read data from memory             
   input               check_age16;          // request flag16 for age16 check
   input [31:0]        last_accessed16;      // time field sent16 for age16 check
   input [31:0]        best_bfr_age16;       // best16 before age16
   input               add_check_active16;   // active flag16 from address checker

   output [31:0]       curr_time16;          // current time,for storing16 in mem    
   output [7:0]        mem_addr_age16;       // address for R/W16 to memory     
   output              mem_write_age16;      // R/W16 flag16 (write = high16)            
   output [82:0]       mem_write_data_age16; // write data for memory             
   output [47:0]       lst_inv_addr_cmd16;   // last invalidated16 addr normal16 op    
   output [1:0]        lst_inv_port_cmd16;   // last invalidated16 port normal16 op    
   output              age_confirmed16;      // validates16 age_ok16 result 
   output              age_ok16;             // age16 checker result - set means16 in-date16
   output              inval_in_prog16;      // invalidation16 in progress16
   output              age_check_active16;   // bit 0 of status register           

   reg  [2:0]          age_chk_state16;      // age16 checker FSM16 current state
   reg  [2:0]          nxt_age_chk_state16;  // age16 checker FSM16 next state
   reg  [7:0]          mem_addr_age16;     
   reg                 mem_write_age16;    
   reg                 inval_in_prog16;      // invalidation16 in progress16
   reg  [7:0]          clk_div_cnt16;        // clock16 divider16 counter
   reg  [31:0]         curr_time16;          // current time,for storing16 in mem  
   reg                 age_confirmed16;      // validates16 age_ok16 result 
   reg                 age_ok16;             // age16 checker result - set means16 in-date16
   reg [47:0]          lst_inv_addr_cmd16;   // last invalidated16 addr normal16 op    
   reg [1:0]           lst_inv_port_cmd16;   // last invalidated16 port normal16 op    

   wire  [82:0]        mem_write_data_age16;
   wire  [31:0]        last_accessed_age16;  // read back time by age16 checker
   wire  [31:0]        time_since_lst_acc_age16;  // time since16 last accessed age16
   wire  [31:0]        time_since_lst_acc16; // time since16 last accessed address
   wire                age_check_active16;   // bit 0 of status register           

// Parameters16 for Address Checking16 FSM16 states16
   parameter idle16           = 3'b000;
   parameter inval_aged_rd16  = 3'b001;
   parameter inval_aged_wr16  = 3'b010;
   parameter inval_all16      = 3'b011;
   parameter age_chk16        = 3'b100;

   parameter max_addr       = 8'hff;
   parameter max_cnt16        = 32'hffff_ffff;

// -----------------------------------------------------------------------------
//   Generate16 current time counter
// -----------------------------------------------------------------------------
always @ (posedge pclk16 or negedge n_p_reset16)
   begin
   if (~n_p_reset16)
      clk_div_cnt16 <= 8'd0;
   else if (clk_div_cnt16 == div_clk16)
      clk_div_cnt16 <= 8'd0; 
   else 
      clk_div_cnt16 <= clk_div_cnt16 + 1'd1;
   end


always @ (posedge pclk16 or negedge n_p_reset16)
   begin
   if (~n_p_reset16)
      curr_time16 <= 32'd0;
   else if (clk_div_cnt16 == div_clk16)
      curr_time16 <= curr_time16 + 1'd1;
   end


// -----------------------------------------------------------------------------
//   Age16 checker State16 Machine16 
// -----------------------------------------------------------------------------
always @ (command or check_age16 or age_chk_state16 or age_confirmed16 or age_ok16 or
          mem_addr_age16 or mem_read_data_age16[82])
   begin
      case (age_chk_state16)
      
      idle16:
         if (command == 2'b10)
            nxt_age_chk_state16 = inval_aged_rd16;
         else if (command == 2'b11)
            nxt_age_chk_state16 = inval_all16;
         else if (check_age16)
            nxt_age_chk_state16 = age_chk16;
         else
            nxt_age_chk_state16 = idle16;

      inval_aged_rd16:
            nxt_age_chk_state16 = age_chk16;

      inval_aged_wr16:
            nxt_age_chk_state16 = idle16;

      inval_all16:
         if (mem_addr_age16 != max_addr)
            nxt_age_chk_state16 = inval_all16;  // move16 onto16 next address
         else
            nxt_age_chk_state16 = idle16;

      age_chk16:
         if (age_confirmed16)
            begin
            if (add_check_active16)                     // age16 check for addr chkr16
               nxt_age_chk_state16 = idle16;
            else if (~mem_read_data_age16[82])      // invalid, check next location16
               nxt_age_chk_state16 = inval_aged_rd16; 
            else if (~age_ok16 & mem_read_data_age16[82]) // out of date16, clear 
               nxt_age_chk_state16 = inval_aged_wr16;
            else if (mem_addr_age16 == max_addr)    // full check completed
               nxt_age_chk_state16 = idle16;     
            else 
               nxt_age_chk_state16 = inval_aged_rd16; // age16 ok, check next location16 
            end       
         else
            nxt_age_chk_state16 = age_chk16;

      default:
            nxt_age_chk_state16 = idle16;
      endcase
   end



always @ (posedge pclk16 or negedge n_p_reset16)
   begin
   if (~n_p_reset16)
      age_chk_state16 <= idle16;
   else
      age_chk_state16 <= nxt_age_chk_state16;
   end


// -----------------------------------------------------------------------------
//   Generate16 memory RW bus for accessing array when requested16 to invalidate16 all
//   aged16 addresses16 and all addresses16.
// -----------------------------------------------------------------------------
always @ (posedge pclk16 or negedge n_p_reset16)
   begin
   if (~n_p_reset16)
   begin
      mem_addr_age16 <= 8'd0;     
      mem_write_age16 <= 1'd0;    
   end
   else if (age_chk_state16 == inval_aged_rd16)  // invalidate16 aged16 read
   begin
      mem_addr_age16 <= mem_addr_age16 + 1'd1;     
      mem_write_age16 <= 1'd0;    
   end
   else if (age_chk_state16 == inval_aged_wr16)  // invalidate16 aged16 read
   begin
      mem_addr_age16 <= mem_addr_age16;     
      mem_write_age16 <= 1'd1;    
   end
   else if (age_chk_state16 == inval_all16)  // invalidate16 all
   begin
      mem_addr_age16 <= mem_addr_age16 + 1'd1;     
      mem_write_age16 <= 1'd1;    
   end
   else if (age_chk_state16 == age_chk16)
   begin
      mem_addr_age16 <= mem_addr_age16;     
      mem_write_age16 <= mem_write_age16;    
   end
   else 
   begin
      mem_addr_age16 <= mem_addr_age16;     
      mem_write_age16 <= 1'd0;    
   end
   end

// age16 checker will only ever16 write zero values to ALUT16 mem
assign mem_write_data_age16 = 83'd0;



// -----------------------------------------------------------------------------
//   Generate16 invalidate16 in progress16 flag16 (bit 1 of status register)
// -----------------------------------------------------------------------------
always @ (posedge pclk16 or negedge n_p_reset16)
   begin
   if (~n_p_reset16)
      inval_in_prog16 <= 1'd0;
   else if (age_chk_state16 == inval_aged_wr16) 
      inval_in_prog16 <= 1'd1;
   else if ((age_chk_state16 == age_chk16) & (mem_addr_age16 == max_addr))
      inval_in_prog16 <= 1'd0;
   else
      inval_in_prog16 <= inval_in_prog16;
   end


// -----------------------------------------------------------------------------
//   Calculate16 whether16 data is still in date16.  Need16 to work16 out the real time
//   gap16 between current time and last accessed.  If16 this gap16 is greater than
//   the best16 before age16, then16 the data is out of date16. 
// -----------------------------------------------------------------------------
assign time_since_lst_acc16 = (curr_time16 > last_accessed16) ? 
                            (curr_time16 - last_accessed16) :  // no cnt wrapping16
                            (curr_time16 + (max_cnt16 - last_accessed16));

assign time_since_lst_acc_age16 = (curr_time16 > last_accessed_age16) ? 
                                (curr_time16 - last_accessed_age16) : // no wrapping16
                                (curr_time16 + (max_cnt16 - last_accessed_age16));


always @ (posedge pclk16 or negedge n_p_reset16)
   begin
   if (~n_p_reset16)
      begin
      age_ok16 <= 1'b0;
      age_confirmed16 <= 1'b0;
      end
   else if ((age_chk_state16 == age_chk16) & add_check_active16) 
      begin                                       // age16 checking for addr chkr16
      if (best_bfr_age16 > time_since_lst_acc16)      // still in date16
         begin
         age_ok16 <= 1'b1;
         age_confirmed16 <= 1'b1;
         end
      else   // out of date16
         begin
         age_ok16 <= 1'b0;
         age_confirmed16 <= 1'b1;
         end
      end
   else if ((age_chk_state16 == age_chk16) & ~add_check_active16)
      begin                                      // age16 checking for inval16 aged16
      if (best_bfr_age16 > time_since_lst_acc_age16) // still in date16
         begin
         age_ok16 <= 1'b1;
         age_confirmed16 <= 1'b1;
         end
      else   // out of date16
         begin
         age_ok16 <= 1'b0;
         age_confirmed16 <= 1'b1;
         end
      end
   else
      begin
      age_ok16 <= 1'b0;
      age_confirmed16 <= 1'b0;
      end
   end



// -----------------------------------------------------------------------------
//   Generate16 last address and port that was cleared16 in the invalid aged16 process
// -----------------------------------------------------------------------------
always @ (posedge pclk16 or negedge n_p_reset16)
   begin
   if (~n_p_reset16)
      begin
      lst_inv_addr_cmd16 <= 48'd0;
      lst_inv_port_cmd16 <= 2'd0;
      end
   else if (age_chk_state16 == inval_aged_wr16)
      begin
      lst_inv_addr_cmd16 <= mem_read_data_age16[47:0];
      lst_inv_port_cmd16 <= mem_read_data_age16[49:48];
      end
   else 
      begin
      lst_inv_addr_cmd16 <= lst_inv_addr_cmd16;
      lst_inv_port_cmd16 <= lst_inv_port_cmd16;
      end
   end


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded16 off16 age_chk_state16
// -----------------------------------------------------------------------------
assign age_check_active16 = (age_chk_state16 != 3'b000);

endmodule

