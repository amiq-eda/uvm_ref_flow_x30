//File21 name   : alut_age_checker21.v
//Title21       : 
//Created21     : 1999
//Description21 : 
//Notes21       : 
//----------------------------------------------------------------------
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------

module alut_age_checker21
(   
   // Inputs21
   pclk21,
   n_p_reset21,
   command,          
   div_clk21,          
   mem_read_data_age21,
   check_age21,        
   last_accessed21, 
   best_bfr_age21,   
   add_check_active21,

   // outputs21
   curr_time21,         
   mem_addr_age21,      
   mem_write_age21,     
   mem_write_data_age21,
   lst_inv_addr_cmd21,    
   lst_inv_port_cmd21,  
   age_confirmed21,     
   age_ok21,
   inval_in_prog21,  
   age_check_active21          
);   

   input               pclk21;               // APB21 clock21                           
   input               n_p_reset21;          // Reset21                               
   input [1:0]         command;            // command bus                        
   input [7:0]         div_clk21;            // clock21 divider21 value
   input [82:0]        mem_read_data_age21;  // read data from memory             
   input               check_age21;          // request flag21 for age21 check
   input [31:0]        last_accessed21;      // time field sent21 for age21 check
   input [31:0]        best_bfr_age21;       // best21 before age21
   input               add_check_active21;   // active flag21 from address checker

   output [31:0]       curr_time21;          // current time,for storing21 in mem    
   output [7:0]        mem_addr_age21;       // address for R/W21 to memory     
   output              mem_write_age21;      // R/W21 flag21 (write = high21)            
   output [82:0]       mem_write_data_age21; // write data for memory             
   output [47:0]       lst_inv_addr_cmd21;   // last invalidated21 addr normal21 op    
   output [1:0]        lst_inv_port_cmd21;   // last invalidated21 port normal21 op    
   output              age_confirmed21;      // validates21 age_ok21 result 
   output              age_ok21;             // age21 checker result - set means21 in-date21
   output              inval_in_prog21;      // invalidation21 in progress21
   output              age_check_active21;   // bit 0 of status register           

   reg  [2:0]          age_chk_state21;      // age21 checker FSM21 current state
   reg  [2:0]          nxt_age_chk_state21;  // age21 checker FSM21 next state
   reg  [7:0]          mem_addr_age21;     
   reg                 mem_write_age21;    
   reg                 inval_in_prog21;      // invalidation21 in progress21
   reg  [7:0]          clk_div_cnt21;        // clock21 divider21 counter
   reg  [31:0]         curr_time21;          // current time,for storing21 in mem  
   reg                 age_confirmed21;      // validates21 age_ok21 result 
   reg                 age_ok21;             // age21 checker result - set means21 in-date21
   reg [47:0]          lst_inv_addr_cmd21;   // last invalidated21 addr normal21 op    
   reg [1:0]           lst_inv_port_cmd21;   // last invalidated21 port normal21 op    

   wire  [82:0]        mem_write_data_age21;
   wire  [31:0]        last_accessed_age21;  // read back time by age21 checker
   wire  [31:0]        time_since_lst_acc_age21;  // time since21 last accessed age21
   wire  [31:0]        time_since_lst_acc21; // time since21 last accessed address
   wire                age_check_active21;   // bit 0 of status register           

// Parameters21 for Address Checking21 FSM21 states21
   parameter idle21           = 3'b000;
   parameter inval_aged_rd21  = 3'b001;
   parameter inval_aged_wr21  = 3'b010;
   parameter inval_all21      = 3'b011;
   parameter age_chk21        = 3'b100;

   parameter max_addr       = 8'hff;
   parameter max_cnt21        = 32'hffff_ffff;

// -----------------------------------------------------------------------------
//   Generate21 current time counter
// -----------------------------------------------------------------------------
always @ (posedge pclk21 or negedge n_p_reset21)
   begin
   if (~n_p_reset21)
      clk_div_cnt21 <= 8'd0;
   else if (clk_div_cnt21 == div_clk21)
      clk_div_cnt21 <= 8'd0; 
   else 
      clk_div_cnt21 <= clk_div_cnt21 + 1'd1;
   end


always @ (posedge pclk21 or negedge n_p_reset21)
   begin
   if (~n_p_reset21)
      curr_time21 <= 32'd0;
   else if (clk_div_cnt21 == div_clk21)
      curr_time21 <= curr_time21 + 1'd1;
   end


// -----------------------------------------------------------------------------
//   Age21 checker State21 Machine21 
// -----------------------------------------------------------------------------
always @ (command or check_age21 or age_chk_state21 or age_confirmed21 or age_ok21 or
          mem_addr_age21 or mem_read_data_age21[82])
   begin
      case (age_chk_state21)
      
      idle21:
         if (command == 2'b10)
            nxt_age_chk_state21 = inval_aged_rd21;
         else if (command == 2'b11)
            nxt_age_chk_state21 = inval_all21;
         else if (check_age21)
            nxt_age_chk_state21 = age_chk21;
         else
            nxt_age_chk_state21 = idle21;

      inval_aged_rd21:
            nxt_age_chk_state21 = age_chk21;

      inval_aged_wr21:
            nxt_age_chk_state21 = idle21;

      inval_all21:
         if (mem_addr_age21 != max_addr)
            nxt_age_chk_state21 = inval_all21;  // move21 onto21 next address
         else
            nxt_age_chk_state21 = idle21;

      age_chk21:
         if (age_confirmed21)
            begin
            if (add_check_active21)                     // age21 check for addr chkr21
               nxt_age_chk_state21 = idle21;
            else if (~mem_read_data_age21[82])      // invalid, check next location21
               nxt_age_chk_state21 = inval_aged_rd21; 
            else if (~age_ok21 & mem_read_data_age21[82]) // out of date21, clear 
               nxt_age_chk_state21 = inval_aged_wr21;
            else if (mem_addr_age21 == max_addr)    // full check completed
               nxt_age_chk_state21 = idle21;     
            else 
               nxt_age_chk_state21 = inval_aged_rd21; // age21 ok, check next location21 
            end       
         else
            nxt_age_chk_state21 = age_chk21;

      default:
            nxt_age_chk_state21 = idle21;
      endcase
   end



always @ (posedge pclk21 or negedge n_p_reset21)
   begin
   if (~n_p_reset21)
      age_chk_state21 <= idle21;
   else
      age_chk_state21 <= nxt_age_chk_state21;
   end


// -----------------------------------------------------------------------------
//   Generate21 memory RW bus for accessing array when requested21 to invalidate21 all
//   aged21 addresses21 and all addresses21.
// -----------------------------------------------------------------------------
always @ (posedge pclk21 or negedge n_p_reset21)
   begin
   if (~n_p_reset21)
   begin
      mem_addr_age21 <= 8'd0;     
      mem_write_age21 <= 1'd0;    
   end
   else if (age_chk_state21 == inval_aged_rd21)  // invalidate21 aged21 read
   begin
      mem_addr_age21 <= mem_addr_age21 + 1'd1;     
      mem_write_age21 <= 1'd0;    
   end
   else if (age_chk_state21 == inval_aged_wr21)  // invalidate21 aged21 read
   begin
      mem_addr_age21 <= mem_addr_age21;     
      mem_write_age21 <= 1'd1;    
   end
   else if (age_chk_state21 == inval_all21)  // invalidate21 all
   begin
      mem_addr_age21 <= mem_addr_age21 + 1'd1;     
      mem_write_age21 <= 1'd1;    
   end
   else if (age_chk_state21 == age_chk21)
   begin
      mem_addr_age21 <= mem_addr_age21;     
      mem_write_age21 <= mem_write_age21;    
   end
   else 
   begin
      mem_addr_age21 <= mem_addr_age21;     
      mem_write_age21 <= 1'd0;    
   end
   end

// age21 checker will only ever21 write zero values to ALUT21 mem
assign mem_write_data_age21 = 83'd0;



// -----------------------------------------------------------------------------
//   Generate21 invalidate21 in progress21 flag21 (bit 1 of status register)
// -----------------------------------------------------------------------------
always @ (posedge pclk21 or negedge n_p_reset21)
   begin
   if (~n_p_reset21)
      inval_in_prog21 <= 1'd0;
   else if (age_chk_state21 == inval_aged_wr21) 
      inval_in_prog21 <= 1'd1;
   else if ((age_chk_state21 == age_chk21) & (mem_addr_age21 == max_addr))
      inval_in_prog21 <= 1'd0;
   else
      inval_in_prog21 <= inval_in_prog21;
   end


// -----------------------------------------------------------------------------
//   Calculate21 whether21 data is still in date21.  Need21 to work21 out the real time
//   gap21 between current time and last accessed.  If21 this gap21 is greater than
//   the best21 before age21, then21 the data is out of date21. 
// -----------------------------------------------------------------------------
assign time_since_lst_acc21 = (curr_time21 > last_accessed21) ? 
                            (curr_time21 - last_accessed21) :  // no cnt wrapping21
                            (curr_time21 + (max_cnt21 - last_accessed21));

assign time_since_lst_acc_age21 = (curr_time21 > last_accessed_age21) ? 
                                (curr_time21 - last_accessed_age21) : // no wrapping21
                                (curr_time21 + (max_cnt21 - last_accessed_age21));


always @ (posedge pclk21 or negedge n_p_reset21)
   begin
   if (~n_p_reset21)
      begin
      age_ok21 <= 1'b0;
      age_confirmed21 <= 1'b0;
      end
   else if ((age_chk_state21 == age_chk21) & add_check_active21) 
      begin                                       // age21 checking for addr chkr21
      if (best_bfr_age21 > time_since_lst_acc21)      // still in date21
         begin
         age_ok21 <= 1'b1;
         age_confirmed21 <= 1'b1;
         end
      else   // out of date21
         begin
         age_ok21 <= 1'b0;
         age_confirmed21 <= 1'b1;
         end
      end
   else if ((age_chk_state21 == age_chk21) & ~add_check_active21)
      begin                                      // age21 checking for inval21 aged21
      if (best_bfr_age21 > time_since_lst_acc_age21) // still in date21
         begin
         age_ok21 <= 1'b1;
         age_confirmed21 <= 1'b1;
         end
      else   // out of date21
         begin
         age_ok21 <= 1'b0;
         age_confirmed21 <= 1'b1;
         end
      end
   else
      begin
      age_ok21 <= 1'b0;
      age_confirmed21 <= 1'b0;
      end
   end



// -----------------------------------------------------------------------------
//   Generate21 last address and port that was cleared21 in the invalid aged21 process
// -----------------------------------------------------------------------------
always @ (posedge pclk21 or negedge n_p_reset21)
   begin
   if (~n_p_reset21)
      begin
      lst_inv_addr_cmd21 <= 48'd0;
      lst_inv_port_cmd21 <= 2'd0;
      end
   else if (age_chk_state21 == inval_aged_wr21)
      begin
      lst_inv_addr_cmd21 <= mem_read_data_age21[47:0];
      lst_inv_port_cmd21 <= mem_read_data_age21[49:48];
      end
   else 
      begin
      lst_inv_addr_cmd21 <= lst_inv_addr_cmd21;
      lst_inv_port_cmd21 <= lst_inv_port_cmd21;
      end
   end


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded21 off21 age_chk_state21
// -----------------------------------------------------------------------------
assign age_check_active21 = (age_chk_state21 != 3'b000);

endmodule

