//File29 name   : alut_age_checker29.v
//Title29       : 
//Created29     : 1999
//Description29 : 
//Notes29       : 
//----------------------------------------------------------------------
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------

module alut_age_checker29
(   
   // Inputs29
   pclk29,
   n_p_reset29,
   command,          
   div_clk29,          
   mem_read_data_age29,
   check_age29,        
   last_accessed29, 
   best_bfr_age29,   
   add_check_active29,

   // outputs29
   curr_time29,         
   mem_addr_age29,      
   mem_write_age29,     
   mem_write_data_age29,
   lst_inv_addr_cmd29,    
   lst_inv_port_cmd29,  
   age_confirmed29,     
   age_ok29,
   inval_in_prog29,  
   age_check_active29          
);   

   input               pclk29;               // APB29 clock29                           
   input               n_p_reset29;          // Reset29                               
   input [1:0]         command;            // command bus                        
   input [7:0]         div_clk29;            // clock29 divider29 value
   input [82:0]        mem_read_data_age29;  // read data from memory             
   input               check_age29;          // request flag29 for age29 check
   input [31:0]        last_accessed29;      // time field sent29 for age29 check
   input [31:0]        best_bfr_age29;       // best29 before age29
   input               add_check_active29;   // active flag29 from address checker

   output [31:0]       curr_time29;          // current time,for storing29 in mem    
   output [7:0]        mem_addr_age29;       // address for R/W29 to memory     
   output              mem_write_age29;      // R/W29 flag29 (write = high29)            
   output [82:0]       mem_write_data_age29; // write data for memory             
   output [47:0]       lst_inv_addr_cmd29;   // last invalidated29 addr normal29 op    
   output [1:0]        lst_inv_port_cmd29;   // last invalidated29 port normal29 op    
   output              age_confirmed29;      // validates29 age_ok29 result 
   output              age_ok29;             // age29 checker result - set means29 in-date29
   output              inval_in_prog29;      // invalidation29 in progress29
   output              age_check_active29;   // bit 0 of status register           

   reg  [2:0]          age_chk_state29;      // age29 checker FSM29 current state
   reg  [2:0]          nxt_age_chk_state29;  // age29 checker FSM29 next state
   reg  [7:0]          mem_addr_age29;     
   reg                 mem_write_age29;    
   reg                 inval_in_prog29;      // invalidation29 in progress29
   reg  [7:0]          clk_div_cnt29;        // clock29 divider29 counter
   reg  [31:0]         curr_time29;          // current time,for storing29 in mem  
   reg                 age_confirmed29;      // validates29 age_ok29 result 
   reg                 age_ok29;             // age29 checker result - set means29 in-date29
   reg [47:0]          lst_inv_addr_cmd29;   // last invalidated29 addr normal29 op    
   reg [1:0]           lst_inv_port_cmd29;   // last invalidated29 port normal29 op    

   wire  [82:0]        mem_write_data_age29;
   wire  [31:0]        last_accessed_age29;  // read back time by age29 checker
   wire  [31:0]        time_since_lst_acc_age29;  // time since29 last accessed age29
   wire  [31:0]        time_since_lst_acc29; // time since29 last accessed address
   wire                age_check_active29;   // bit 0 of status register           

// Parameters29 for Address Checking29 FSM29 states29
   parameter idle29           = 3'b000;
   parameter inval_aged_rd29  = 3'b001;
   parameter inval_aged_wr29  = 3'b010;
   parameter inval_all29      = 3'b011;
   parameter age_chk29        = 3'b100;

   parameter max_addr       = 8'hff;
   parameter max_cnt29        = 32'hffff_ffff;

// -----------------------------------------------------------------------------
//   Generate29 current time counter
// -----------------------------------------------------------------------------
always @ (posedge pclk29 or negedge n_p_reset29)
   begin
   if (~n_p_reset29)
      clk_div_cnt29 <= 8'd0;
   else if (clk_div_cnt29 == div_clk29)
      clk_div_cnt29 <= 8'd0; 
   else 
      clk_div_cnt29 <= clk_div_cnt29 + 1'd1;
   end


always @ (posedge pclk29 or negedge n_p_reset29)
   begin
   if (~n_p_reset29)
      curr_time29 <= 32'd0;
   else if (clk_div_cnt29 == div_clk29)
      curr_time29 <= curr_time29 + 1'd1;
   end


// -----------------------------------------------------------------------------
//   Age29 checker State29 Machine29 
// -----------------------------------------------------------------------------
always @ (command or check_age29 or age_chk_state29 or age_confirmed29 or age_ok29 or
          mem_addr_age29 or mem_read_data_age29[82])
   begin
      case (age_chk_state29)
      
      idle29:
         if (command == 2'b10)
            nxt_age_chk_state29 = inval_aged_rd29;
         else if (command == 2'b11)
            nxt_age_chk_state29 = inval_all29;
         else if (check_age29)
            nxt_age_chk_state29 = age_chk29;
         else
            nxt_age_chk_state29 = idle29;

      inval_aged_rd29:
            nxt_age_chk_state29 = age_chk29;

      inval_aged_wr29:
            nxt_age_chk_state29 = idle29;

      inval_all29:
         if (mem_addr_age29 != max_addr)
            nxt_age_chk_state29 = inval_all29;  // move29 onto29 next address
         else
            nxt_age_chk_state29 = idle29;

      age_chk29:
         if (age_confirmed29)
            begin
            if (add_check_active29)                     // age29 check for addr chkr29
               nxt_age_chk_state29 = idle29;
            else if (~mem_read_data_age29[82])      // invalid, check next location29
               nxt_age_chk_state29 = inval_aged_rd29; 
            else if (~age_ok29 & mem_read_data_age29[82]) // out of date29, clear 
               nxt_age_chk_state29 = inval_aged_wr29;
            else if (mem_addr_age29 == max_addr)    // full check completed
               nxt_age_chk_state29 = idle29;     
            else 
               nxt_age_chk_state29 = inval_aged_rd29; // age29 ok, check next location29 
            end       
         else
            nxt_age_chk_state29 = age_chk29;

      default:
            nxt_age_chk_state29 = idle29;
      endcase
   end



always @ (posedge pclk29 or negedge n_p_reset29)
   begin
   if (~n_p_reset29)
      age_chk_state29 <= idle29;
   else
      age_chk_state29 <= nxt_age_chk_state29;
   end


// -----------------------------------------------------------------------------
//   Generate29 memory RW bus for accessing array when requested29 to invalidate29 all
//   aged29 addresses29 and all addresses29.
// -----------------------------------------------------------------------------
always @ (posedge pclk29 or negedge n_p_reset29)
   begin
   if (~n_p_reset29)
   begin
      mem_addr_age29 <= 8'd0;     
      mem_write_age29 <= 1'd0;    
   end
   else if (age_chk_state29 == inval_aged_rd29)  // invalidate29 aged29 read
   begin
      mem_addr_age29 <= mem_addr_age29 + 1'd1;     
      mem_write_age29 <= 1'd0;    
   end
   else if (age_chk_state29 == inval_aged_wr29)  // invalidate29 aged29 read
   begin
      mem_addr_age29 <= mem_addr_age29;     
      mem_write_age29 <= 1'd1;    
   end
   else if (age_chk_state29 == inval_all29)  // invalidate29 all
   begin
      mem_addr_age29 <= mem_addr_age29 + 1'd1;     
      mem_write_age29 <= 1'd1;    
   end
   else if (age_chk_state29 == age_chk29)
   begin
      mem_addr_age29 <= mem_addr_age29;     
      mem_write_age29 <= mem_write_age29;    
   end
   else 
   begin
      mem_addr_age29 <= mem_addr_age29;     
      mem_write_age29 <= 1'd0;    
   end
   end

// age29 checker will only ever29 write zero values to ALUT29 mem
assign mem_write_data_age29 = 83'd0;



// -----------------------------------------------------------------------------
//   Generate29 invalidate29 in progress29 flag29 (bit 1 of status register)
// -----------------------------------------------------------------------------
always @ (posedge pclk29 or negedge n_p_reset29)
   begin
   if (~n_p_reset29)
      inval_in_prog29 <= 1'd0;
   else if (age_chk_state29 == inval_aged_wr29) 
      inval_in_prog29 <= 1'd1;
   else if ((age_chk_state29 == age_chk29) & (mem_addr_age29 == max_addr))
      inval_in_prog29 <= 1'd0;
   else
      inval_in_prog29 <= inval_in_prog29;
   end


// -----------------------------------------------------------------------------
//   Calculate29 whether29 data is still in date29.  Need29 to work29 out the real time
//   gap29 between current time and last accessed.  If29 this gap29 is greater than
//   the best29 before age29, then29 the data is out of date29. 
// -----------------------------------------------------------------------------
assign time_since_lst_acc29 = (curr_time29 > last_accessed29) ? 
                            (curr_time29 - last_accessed29) :  // no cnt wrapping29
                            (curr_time29 + (max_cnt29 - last_accessed29));

assign time_since_lst_acc_age29 = (curr_time29 > last_accessed_age29) ? 
                                (curr_time29 - last_accessed_age29) : // no wrapping29
                                (curr_time29 + (max_cnt29 - last_accessed_age29));


always @ (posedge pclk29 or negedge n_p_reset29)
   begin
   if (~n_p_reset29)
      begin
      age_ok29 <= 1'b0;
      age_confirmed29 <= 1'b0;
      end
   else if ((age_chk_state29 == age_chk29) & add_check_active29) 
      begin                                       // age29 checking for addr chkr29
      if (best_bfr_age29 > time_since_lst_acc29)      // still in date29
         begin
         age_ok29 <= 1'b1;
         age_confirmed29 <= 1'b1;
         end
      else   // out of date29
         begin
         age_ok29 <= 1'b0;
         age_confirmed29 <= 1'b1;
         end
      end
   else if ((age_chk_state29 == age_chk29) & ~add_check_active29)
      begin                                      // age29 checking for inval29 aged29
      if (best_bfr_age29 > time_since_lst_acc_age29) // still in date29
         begin
         age_ok29 <= 1'b1;
         age_confirmed29 <= 1'b1;
         end
      else   // out of date29
         begin
         age_ok29 <= 1'b0;
         age_confirmed29 <= 1'b1;
         end
      end
   else
      begin
      age_ok29 <= 1'b0;
      age_confirmed29 <= 1'b0;
      end
   end



// -----------------------------------------------------------------------------
//   Generate29 last address and port that was cleared29 in the invalid aged29 process
// -----------------------------------------------------------------------------
always @ (posedge pclk29 or negedge n_p_reset29)
   begin
   if (~n_p_reset29)
      begin
      lst_inv_addr_cmd29 <= 48'd0;
      lst_inv_port_cmd29 <= 2'd0;
      end
   else if (age_chk_state29 == inval_aged_wr29)
      begin
      lst_inv_addr_cmd29 <= mem_read_data_age29[47:0];
      lst_inv_port_cmd29 <= mem_read_data_age29[49:48];
      end
   else 
      begin
      lst_inv_addr_cmd29 <= lst_inv_addr_cmd29;
      lst_inv_port_cmd29 <= lst_inv_port_cmd29;
      end
   end


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded29 off29 age_chk_state29
// -----------------------------------------------------------------------------
assign age_check_active29 = (age_chk_state29 != 3'b000);

endmodule

