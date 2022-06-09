//File28 name   : alut_age_checker28.v
//Title28       : 
//Created28     : 1999
//Description28 : 
//Notes28       : 
//----------------------------------------------------------------------
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------

module alut_age_checker28
(   
   // Inputs28
   pclk28,
   n_p_reset28,
   command,          
   div_clk28,          
   mem_read_data_age28,
   check_age28,        
   last_accessed28, 
   best_bfr_age28,   
   add_check_active28,

   // outputs28
   curr_time28,         
   mem_addr_age28,      
   mem_write_age28,     
   mem_write_data_age28,
   lst_inv_addr_cmd28,    
   lst_inv_port_cmd28,  
   age_confirmed28,     
   age_ok28,
   inval_in_prog28,  
   age_check_active28          
);   

   input               pclk28;               // APB28 clock28                           
   input               n_p_reset28;          // Reset28                               
   input [1:0]         command;            // command bus                        
   input [7:0]         div_clk28;            // clock28 divider28 value
   input [82:0]        mem_read_data_age28;  // read data from memory             
   input               check_age28;          // request flag28 for age28 check
   input [31:0]        last_accessed28;      // time field sent28 for age28 check
   input [31:0]        best_bfr_age28;       // best28 before age28
   input               add_check_active28;   // active flag28 from address checker

   output [31:0]       curr_time28;          // current time,for storing28 in mem    
   output [7:0]        mem_addr_age28;       // address for R/W28 to memory     
   output              mem_write_age28;      // R/W28 flag28 (write = high28)            
   output [82:0]       mem_write_data_age28; // write data for memory             
   output [47:0]       lst_inv_addr_cmd28;   // last invalidated28 addr normal28 op    
   output [1:0]        lst_inv_port_cmd28;   // last invalidated28 port normal28 op    
   output              age_confirmed28;      // validates28 age_ok28 result 
   output              age_ok28;             // age28 checker result - set means28 in-date28
   output              inval_in_prog28;      // invalidation28 in progress28
   output              age_check_active28;   // bit 0 of status register           

   reg  [2:0]          age_chk_state28;      // age28 checker FSM28 current state
   reg  [2:0]          nxt_age_chk_state28;  // age28 checker FSM28 next state
   reg  [7:0]          mem_addr_age28;     
   reg                 mem_write_age28;    
   reg                 inval_in_prog28;      // invalidation28 in progress28
   reg  [7:0]          clk_div_cnt28;        // clock28 divider28 counter
   reg  [31:0]         curr_time28;          // current time,for storing28 in mem  
   reg                 age_confirmed28;      // validates28 age_ok28 result 
   reg                 age_ok28;             // age28 checker result - set means28 in-date28
   reg [47:0]          lst_inv_addr_cmd28;   // last invalidated28 addr normal28 op    
   reg [1:0]           lst_inv_port_cmd28;   // last invalidated28 port normal28 op    

   wire  [82:0]        mem_write_data_age28;
   wire  [31:0]        last_accessed_age28;  // read back time by age28 checker
   wire  [31:0]        time_since_lst_acc_age28;  // time since28 last accessed age28
   wire  [31:0]        time_since_lst_acc28; // time since28 last accessed address
   wire                age_check_active28;   // bit 0 of status register           

// Parameters28 for Address Checking28 FSM28 states28
   parameter idle28           = 3'b000;
   parameter inval_aged_rd28  = 3'b001;
   parameter inval_aged_wr28  = 3'b010;
   parameter inval_all28      = 3'b011;
   parameter age_chk28        = 3'b100;

   parameter max_addr       = 8'hff;
   parameter max_cnt28        = 32'hffff_ffff;

// -----------------------------------------------------------------------------
//   Generate28 current time counter
// -----------------------------------------------------------------------------
always @ (posedge pclk28 or negedge n_p_reset28)
   begin
   if (~n_p_reset28)
      clk_div_cnt28 <= 8'd0;
   else if (clk_div_cnt28 == div_clk28)
      clk_div_cnt28 <= 8'd0; 
   else 
      clk_div_cnt28 <= clk_div_cnt28 + 1'd1;
   end


always @ (posedge pclk28 or negedge n_p_reset28)
   begin
   if (~n_p_reset28)
      curr_time28 <= 32'd0;
   else if (clk_div_cnt28 == div_clk28)
      curr_time28 <= curr_time28 + 1'd1;
   end


// -----------------------------------------------------------------------------
//   Age28 checker State28 Machine28 
// -----------------------------------------------------------------------------
always @ (command or check_age28 or age_chk_state28 or age_confirmed28 or age_ok28 or
          mem_addr_age28 or mem_read_data_age28[82])
   begin
      case (age_chk_state28)
      
      idle28:
         if (command == 2'b10)
            nxt_age_chk_state28 = inval_aged_rd28;
         else if (command == 2'b11)
            nxt_age_chk_state28 = inval_all28;
         else if (check_age28)
            nxt_age_chk_state28 = age_chk28;
         else
            nxt_age_chk_state28 = idle28;

      inval_aged_rd28:
            nxt_age_chk_state28 = age_chk28;

      inval_aged_wr28:
            nxt_age_chk_state28 = idle28;

      inval_all28:
         if (mem_addr_age28 != max_addr)
            nxt_age_chk_state28 = inval_all28;  // move28 onto28 next address
         else
            nxt_age_chk_state28 = idle28;

      age_chk28:
         if (age_confirmed28)
            begin
            if (add_check_active28)                     // age28 check for addr chkr28
               nxt_age_chk_state28 = idle28;
            else if (~mem_read_data_age28[82])      // invalid, check next location28
               nxt_age_chk_state28 = inval_aged_rd28; 
            else if (~age_ok28 & mem_read_data_age28[82]) // out of date28, clear 
               nxt_age_chk_state28 = inval_aged_wr28;
            else if (mem_addr_age28 == max_addr)    // full check completed
               nxt_age_chk_state28 = idle28;     
            else 
               nxt_age_chk_state28 = inval_aged_rd28; // age28 ok, check next location28 
            end       
         else
            nxt_age_chk_state28 = age_chk28;

      default:
            nxt_age_chk_state28 = idle28;
      endcase
   end



always @ (posedge pclk28 or negedge n_p_reset28)
   begin
   if (~n_p_reset28)
      age_chk_state28 <= idle28;
   else
      age_chk_state28 <= nxt_age_chk_state28;
   end


// -----------------------------------------------------------------------------
//   Generate28 memory RW bus for accessing array when requested28 to invalidate28 all
//   aged28 addresses28 and all addresses28.
// -----------------------------------------------------------------------------
always @ (posedge pclk28 or negedge n_p_reset28)
   begin
   if (~n_p_reset28)
   begin
      mem_addr_age28 <= 8'd0;     
      mem_write_age28 <= 1'd0;    
   end
   else if (age_chk_state28 == inval_aged_rd28)  // invalidate28 aged28 read
   begin
      mem_addr_age28 <= mem_addr_age28 + 1'd1;     
      mem_write_age28 <= 1'd0;    
   end
   else if (age_chk_state28 == inval_aged_wr28)  // invalidate28 aged28 read
   begin
      mem_addr_age28 <= mem_addr_age28;     
      mem_write_age28 <= 1'd1;    
   end
   else if (age_chk_state28 == inval_all28)  // invalidate28 all
   begin
      mem_addr_age28 <= mem_addr_age28 + 1'd1;     
      mem_write_age28 <= 1'd1;    
   end
   else if (age_chk_state28 == age_chk28)
   begin
      mem_addr_age28 <= mem_addr_age28;     
      mem_write_age28 <= mem_write_age28;    
   end
   else 
   begin
      mem_addr_age28 <= mem_addr_age28;     
      mem_write_age28 <= 1'd0;    
   end
   end

// age28 checker will only ever28 write zero values to ALUT28 mem
assign mem_write_data_age28 = 83'd0;



// -----------------------------------------------------------------------------
//   Generate28 invalidate28 in progress28 flag28 (bit 1 of status register)
// -----------------------------------------------------------------------------
always @ (posedge pclk28 or negedge n_p_reset28)
   begin
   if (~n_p_reset28)
      inval_in_prog28 <= 1'd0;
   else if (age_chk_state28 == inval_aged_wr28) 
      inval_in_prog28 <= 1'd1;
   else if ((age_chk_state28 == age_chk28) & (mem_addr_age28 == max_addr))
      inval_in_prog28 <= 1'd0;
   else
      inval_in_prog28 <= inval_in_prog28;
   end


// -----------------------------------------------------------------------------
//   Calculate28 whether28 data is still in date28.  Need28 to work28 out the real time
//   gap28 between current time and last accessed.  If28 this gap28 is greater than
//   the best28 before age28, then28 the data is out of date28. 
// -----------------------------------------------------------------------------
assign time_since_lst_acc28 = (curr_time28 > last_accessed28) ? 
                            (curr_time28 - last_accessed28) :  // no cnt wrapping28
                            (curr_time28 + (max_cnt28 - last_accessed28));

assign time_since_lst_acc_age28 = (curr_time28 > last_accessed_age28) ? 
                                (curr_time28 - last_accessed_age28) : // no wrapping28
                                (curr_time28 + (max_cnt28 - last_accessed_age28));


always @ (posedge pclk28 or negedge n_p_reset28)
   begin
   if (~n_p_reset28)
      begin
      age_ok28 <= 1'b0;
      age_confirmed28 <= 1'b0;
      end
   else if ((age_chk_state28 == age_chk28) & add_check_active28) 
      begin                                       // age28 checking for addr chkr28
      if (best_bfr_age28 > time_since_lst_acc28)      // still in date28
         begin
         age_ok28 <= 1'b1;
         age_confirmed28 <= 1'b1;
         end
      else   // out of date28
         begin
         age_ok28 <= 1'b0;
         age_confirmed28 <= 1'b1;
         end
      end
   else if ((age_chk_state28 == age_chk28) & ~add_check_active28)
      begin                                      // age28 checking for inval28 aged28
      if (best_bfr_age28 > time_since_lst_acc_age28) // still in date28
         begin
         age_ok28 <= 1'b1;
         age_confirmed28 <= 1'b1;
         end
      else   // out of date28
         begin
         age_ok28 <= 1'b0;
         age_confirmed28 <= 1'b1;
         end
      end
   else
      begin
      age_ok28 <= 1'b0;
      age_confirmed28 <= 1'b0;
      end
   end



// -----------------------------------------------------------------------------
//   Generate28 last address and port that was cleared28 in the invalid aged28 process
// -----------------------------------------------------------------------------
always @ (posedge pclk28 or negedge n_p_reset28)
   begin
   if (~n_p_reset28)
      begin
      lst_inv_addr_cmd28 <= 48'd0;
      lst_inv_port_cmd28 <= 2'd0;
      end
   else if (age_chk_state28 == inval_aged_wr28)
      begin
      lst_inv_addr_cmd28 <= mem_read_data_age28[47:0];
      lst_inv_port_cmd28 <= mem_read_data_age28[49:48];
      end
   else 
      begin
      lst_inv_addr_cmd28 <= lst_inv_addr_cmd28;
      lst_inv_port_cmd28 <= lst_inv_port_cmd28;
      end
   end


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded28 off28 age_chk_state28
// -----------------------------------------------------------------------------
assign age_check_active28 = (age_chk_state28 != 3'b000);

endmodule

