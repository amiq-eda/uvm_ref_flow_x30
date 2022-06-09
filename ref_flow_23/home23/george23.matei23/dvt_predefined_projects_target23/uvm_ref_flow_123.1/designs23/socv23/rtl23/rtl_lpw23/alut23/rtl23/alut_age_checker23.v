//File23 name   : alut_age_checker23.v
//Title23       : 
//Created23     : 1999
//Description23 : 
//Notes23       : 
//----------------------------------------------------------------------
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------

module alut_age_checker23
(   
   // Inputs23
   pclk23,
   n_p_reset23,
   command,          
   div_clk23,          
   mem_read_data_age23,
   check_age23,        
   last_accessed23, 
   best_bfr_age23,   
   add_check_active23,

   // outputs23
   curr_time23,         
   mem_addr_age23,      
   mem_write_age23,     
   mem_write_data_age23,
   lst_inv_addr_cmd23,    
   lst_inv_port_cmd23,  
   age_confirmed23,     
   age_ok23,
   inval_in_prog23,  
   age_check_active23          
);   

   input               pclk23;               // APB23 clock23                           
   input               n_p_reset23;          // Reset23                               
   input [1:0]         command;            // command bus                        
   input [7:0]         div_clk23;            // clock23 divider23 value
   input [82:0]        mem_read_data_age23;  // read data from memory             
   input               check_age23;          // request flag23 for age23 check
   input [31:0]        last_accessed23;      // time field sent23 for age23 check
   input [31:0]        best_bfr_age23;       // best23 before age23
   input               add_check_active23;   // active flag23 from address checker

   output [31:0]       curr_time23;          // current time,for storing23 in mem    
   output [7:0]        mem_addr_age23;       // address for R/W23 to memory     
   output              mem_write_age23;      // R/W23 flag23 (write = high23)            
   output [82:0]       mem_write_data_age23; // write data for memory             
   output [47:0]       lst_inv_addr_cmd23;   // last invalidated23 addr normal23 op    
   output [1:0]        lst_inv_port_cmd23;   // last invalidated23 port normal23 op    
   output              age_confirmed23;      // validates23 age_ok23 result 
   output              age_ok23;             // age23 checker result - set means23 in-date23
   output              inval_in_prog23;      // invalidation23 in progress23
   output              age_check_active23;   // bit 0 of status register           

   reg  [2:0]          age_chk_state23;      // age23 checker FSM23 current state
   reg  [2:0]          nxt_age_chk_state23;  // age23 checker FSM23 next state
   reg  [7:0]          mem_addr_age23;     
   reg                 mem_write_age23;    
   reg                 inval_in_prog23;      // invalidation23 in progress23
   reg  [7:0]          clk_div_cnt23;        // clock23 divider23 counter
   reg  [31:0]         curr_time23;          // current time,for storing23 in mem  
   reg                 age_confirmed23;      // validates23 age_ok23 result 
   reg                 age_ok23;             // age23 checker result - set means23 in-date23
   reg [47:0]          lst_inv_addr_cmd23;   // last invalidated23 addr normal23 op    
   reg [1:0]           lst_inv_port_cmd23;   // last invalidated23 port normal23 op    

   wire  [82:0]        mem_write_data_age23;
   wire  [31:0]        last_accessed_age23;  // read back time by age23 checker
   wire  [31:0]        time_since_lst_acc_age23;  // time since23 last accessed age23
   wire  [31:0]        time_since_lst_acc23; // time since23 last accessed address
   wire                age_check_active23;   // bit 0 of status register           

// Parameters23 for Address Checking23 FSM23 states23
   parameter idle23           = 3'b000;
   parameter inval_aged_rd23  = 3'b001;
   parameter inval_aged_wr23  = 3'b010;
   parameter inval_all23      = 3'b011;
   parameter age_chk23        = 3'b100;

   parameter max_addr       = 8'hff;
   parameter max_cnt23        = 32'hffff_ffff;

// -----------------------------------------------------------------------------
//   Generate23 current time counter
// -----------------------------------------------------------------------------
always @ (posedge pclk23 or negedge n_p_reset23)
   begin
   if (~n_p_reset23)
      clk_div_cnt23 <= 8'd0;
   else if (clk_div_cnt23 == div_clk23)
      clk_div_cnt23 <= 8'd0; 
   else 
      clk_div_cnt23 <= clk_div_cnt23 + 1'd1;
   end


always @ (posedge pclk23 or negedge n_p_reset23)
   begin
   if (~n_p_reset23)
      curr_time23 <= 32'd0;
   else if (clk_div_cnt23 == div_clk23)
      curr_time23 <= curr_time23 + 1'd1;
   end


// -----------------------------------------------------------------------------
//   Age23 checker State23 Machine23 
// -----------------------------------------------------------------------------
always @ (command or check_age23 or age_chk_state23 or age_confirmed23 or age_ok23 or
          mem_addr_age23 or mem_read_data_age23[82])
   begin
      case (age_chk_state23)
      
      idle23:
         if (command == 2'b10)
            nxt_age_chk_state23 = inval_aged_rd23;
         else if (command == 2'b11)
            nxt_age_chk_state23 = inval_all23;
         else if (check_age23)
            nxt_age_chk_state23 = age_chk23;
         else
            nxt_age_chk_state23 = idle23;

      inval_aged_rd23:
            nxt_age_chk_state23 = age_chk23;

      inval_aged_wr23:
            nxt_age_chk_state23 = idle23;

      inval_all23:
         if (mem_addr_age23 != max_addr)
            nxt_age_chk_state23 = inval_all23;  // move23 onto23 next address
         else
            nxt_age_chk_state23 = idle23;

      age_chk23:
         if (age_confirmed23)
            begin
            if (add_check_active23)                     // age23 check for addr chkr23
               nxt_age_chk_state23 = idle23;
            else if (~mem_read_data_age23[82])      // invalid, check next location23
               nxt_age_chk_state23 = inval_aged_rd23; 
            else if (~age_ok23 & mem_read_data_age23[82]) // out of date23, clear 
               nxt_age_chk_state23 = inval_aged_wr23;
            else if (mem_addr_age23 == max_addr)    // full check completed
               nxt_age_chk_state23 = idle23;     
            else 
               nxt_age_chk_state23 = inval_aged_rd23; // age23 ok, check next location23 
            end       
         else
            nxt_age_chk_state23 = age_chk23;

      default:
            nxt_age_chk_state23 = idle23;
      endcase
   end



always @ (posedge pclk23 or negedge n_p_reset23)
   begin
   if (~n_p_reset23)
      age_chk_state23 <= idle23;
   else
      age_chk_state23 <= nxt_age_chk_state23;
   end


// -----------------------------------------------------------------------------
//   Generate23 memory RW bus for accessing array when requested23 to invalidate23 all
//   aged23 addresses23 and all addresses23.
// -----------------------------------------------------------------------------
always @ (posedge pclk23 or negedge n_p_reset23)
   begin
   if (~n_p_reset23)
   begin
      mem_addr_age23 <= 8'd0;     
      mem_write_age23 <= 1'd0;    
   end
   else if (age_chk_state23 == inval_aged_rd23)  // invalidate23 aged23 read
   begin
      mem_addr_age23 <= mem_addr_age23 + 1'd1;     
      mem_write_age23 <= 1'd0;    
   end
   else if (age_chk_state23 == inval_aged_wr23)  // invalidate23 aged23 read
   begin
      mem_addr_age23 <= mem_addr_age23;     
      mem_write_age23 <= 1'd1;    
   end
   else if (age_chk_state23 == inval_all23)  // invalidate23 all
   begin
      mem_addr_age23 <= mem_addr_age23 + 1'd1;     
      mem_write_age23 <= 1'd1;    
   end
   else if (age_chk_state23 == age_chk23)
   begin
      mem_addr_age23 <= mem_addr_age23;     
      mem_write_age23 <= mem_write_age23;    
   end
   else 
   begin
      mem_addr_age23 <= mem_addr_age23;     
      mem_write_age23 <= 1'd0;    
   end
   end

// age23 checker will only ever23 write zero values to ALUT23 mem
assign mem_write_data_age23 = 83'd0;



// -----------------------------------------------------------------------------
//   Generate23 invalidate23 in progress23 flag23 (bit 1 of status register)
// -----------------------------------------------------------------------------
always @ (posedge pclk23 or negedge n_p_reset23)
   begin
   if (~n_p_reset23)
      inval_in_prog23 <= 1'd0;
   else if (age_chk_state23 == inval_aged_wr23) 
      inval_in_prog23 <= 1'd1;
   else if ((age_chk_state23 == age_chk23) & (mem_addr_age23 == max_addr))
      inval_in_prog23 <= 1'd0;
   else
      inval_in_prog23 <= inval_in_prog23;
   end


// -----------------------------------------------------------------------------
//   Calculate23 whether23 data is still in date23.  Need23 to work23 out the real time
//   gap23 between current time and last accessed.  If23 this gap23 is greater than
//   the best23 before age23, then23 the data is out of date23. 
// -----------------------------------------------------------------------------
assign time_since_lst_acc23 = (curr_time23 > last_accessed23) ? 
                            (curr_time23 - last_accessed23) :  // no cnt wrapping23
                            (curr_time23 + (max_cnt23 - last_accessed23));

assign time_since_lst_acc_age23 = (curr_time23 > last_accessed_age23) ? 
                                (curr_time23 - last_accessed_age23) : // no wrapping23
                                (curr_time23 + (max_cnt23 - last_accessed_age23));


always @ (posedge pclk23 or negedge n_p_reset23)
   begin
   if (~n_p_reset23)
      begin
      age_ok23 <= 1'b0;
      age_confirmed23 <= 1'b0;
      end
   else if ((age_chk_state23 == age_chk23) & add_check_active23) 
      begin                                       // age23 checking for addr chkr23
      if (best_bfr_age23 > time_since_lst_acc23)      // still in date23
         begin
         age_ok23 <= 1'b1;
         age_confirmed23 <= 1'b1;
         end
      else   // out of date23
         begin
         age_ok23 <= 1'b0;
         age_confirmed23 <= 1'b1;
         end
      end
   else if ((age_chk_state23 == age_chk23) & ~add_check_active23)
      begin                                      // age23 checking for inval23 aged23
      if (best_bfr_age23 > time_since_lst_acc_age23) // still in date23
         begin
         age_ok23 <= 1'b1;
         age_confirmed23 <= 1'b1;
         end
      else   // out of date23
         begin
         age_ok23 <= 1'b0;
         age_confirmed23 <= 1'b1;
         end
      end
   else
      begin
      age_ok23 <= 1'b0;
      age_confirmed23 <= 1'b0;
      end
   end



// -----------------------------------------------------------------------------
//   Generate23 last address and port that was cleared23 in the invalid aged23 process
// -----------------------------------------------------------------------------
always @ (posedge pclk23 or negedge n_p_reset23)
   begin
   if (~n_p_reset23)
      begin
      lst_inv_addr_cmd23 <= 48'd0;
      lst_inv_port_cmd23 <= 2'd0;
      end
   else if (age_chk_state23 == inval_aged_wr23)
      begin
      lst_inv_addr_cmd23 <= mem_read_data_age23[47:0];
      lst_inv_port_cmd23 <= mem_read_data_age23[49:48];
      end
   else 
      begin
      lst_inv_addr_cmd23 <= lst_inv_addr_cmd23;
      lst_inv_port_cmd23 <= lst_inv_port_cmd23;
      end
   end


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded23 off23 age_chk_state23
// -----------------------------------------------------------------------------
assign age_check_active23 = (age_chk_state23 != 3'b000);

endmodule

