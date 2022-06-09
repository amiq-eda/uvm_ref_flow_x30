//File15 name   : alut_age_checker15.v
//Title15       : 
//Created15     : 1999
//Description15 : 
//Notes15       : 
//----------------------------------------------------------------------
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------

module alut_age_checker15
(   
   // Inputs15
   pclk15,
   n_p_reset15,
   command,          
   div_clk15,          
   mem_read_data_age15,
   check_age15,        
   last_accessed15, 
   best_bfr_age15,   
   add_check_active15,

   // outputs15
   curr_time15,         
   mem_addr_age15,      
   mem_write_age15,     
   mem_write_data_age15,
   lst_inv_addr_cmd15,    
   lst_inv_port_cmd15,  
   age_confirmed15,     
   age_ok15,
   inval_in_prog15,  
   age_check_active15          
);   

   input               pclk15;               // APB15 clock15                           
   input               n_p_reset15;          // Reset15                               
   input [1:0]         command;            // command bus                        
   input [7:0]         div_clk15;            // clock15 divider15 value
   input [82:0]        mem_read_data_age15;  // read data from memory             
   input               check_age15;          // request flag15 for age15 check
   input [31:0]        last_accessed15;      // time field sent15 for age15 check
   input [31:0]        best_bfr_age15;       // best15 before age15
   input               add_check_active15;   // active flag15 from address checker

   output [31:0]       curr_time15;          // current time,for storing15 in mem    
   output [7:0]        mem_addr_age15;       // address for R/W15 to memory     
   output              mem_write_age15;      // R/W15 flag15 (write = high15)            
   output [82:0]       mem_write_data_age15; // write data for memory             
   output [47:0]       lst_inv_addr_cmd15;   // last invalidated15 addr normal15 op    
   output [1:0]        lst_inv_port_cmd15;   // last invalidated15 port normal15 op    
   output              age_confirmed15;      // validates15 age_ok15 result 
   output              age_ok15;             // age15 checker result - set means15 in-date15
   output              inval_in_prog15;      // invalidation15 in progress15
   output              age_check_active15;   // bit 0 of status register           

   reg  [2:0]          age_chk_state15;      // age15 checker FSM15 current state
   reg  [2:0]          nxt_age_chk_state15;  // age15 checker FSM15 next state
   reg  [7:0]          mem_addr_age15;     
   reg                 mem_write_age15;    
   reg                 inval_in_prog15;      // invalidation15 in progress15
   reg  [7:0]          clk_div_cnt15;        // clock15 divider15 counter
   reg  [31:0]         curr_time15;          // current time,for storing15 in mem  
   reg                 age_confirmed15;      // validates15 age_ok15 result 
   reg                 age_ok15;             // age15 checker result - set means15 in-date15
   reg [47:0]          lst_inv_addr_cmd15;   // last invalidated15 addr normal15 op    
   reg [1:0]           lst_inv_port_cmd15;   // last invalidated15 port normal15 op    

   wire  [82:0]        mem_write_data_age15;
   wire  [31:0]        last_accessed_age15;  // read back time by age15 checker
   wire  [31:0]        time_since_lst_acc_age15;  // time since15 last accessed age15
   wire  [31:0]        time_since_lst_acc15; // time since15 last accessed address
   wire                age_check_active15;   // bit 0 of status register           

// Parameters15 for Address Checking15 FSM15 states15
   parameter idle15           = 3'b000;
   parameter inval_aged_rd15  = 3'b001;
   parameter inval_aged_wr15  = 3'b010;
   parameter inval_all15      = 3'b011;
   parameter age_chk15        = 3'b100;

   parameter max_addr       = 8'hff;
   parameter max_cnt15        = 32'hffff_ffff;

// -----------------------------------------------------------------------------
//   Generate15 current time counter
// -----------------------------------------------------------------------------
always @ (posedge pclk15 or negedge n_p_reset15)
   begin
   if (~n_p_reset15)
      clk_div_cnt15 <= 8'd0;
   else if (clk_div_cnt15 == div_clk15)
      clk_div_cnt15 <= 8'd0; 
   else 
      clk_div_cnt15 <= clk_div_cnt15 + 1'd1;
   end


always @ (posedge pclk15 or negedge n_p_reset15)
   begin
   if (~n_p_reset15)
      curr_time15 <= 32'd0;
   else if (clk_div_cnt15 == div_clk15)
      curr_time15 <= curr_time15 + 1'd1;
   end


// -----------------------------------------------------------------------------
//   Age15 checker State15 Machine15 
// -----------------------------------------------------------------------------
always @ (command or check_age15 or age_chk_state15 or age_confirmed15 or age_ok15 or
          mem_addr_age15 or mem_read_data_age15[82])
   begin
      case (age_chk_state15)
      
      idle15:
         if (command == 2'b10)
            nxt_age_chk_state15 = inval_aged_rd15;
         else if (command == 2'b11)
            nxt_age_chk_state15 = inval_all15;
         else if (check_age15)
            nxt_age_chk_state15 = age_chk15;
         else
            nxt_age_chk_state15 = idle15;

      inval_aged_rd15:
            nxt_age_chk_state15 = age_chk15;

      inval_aged_wr15:
            nxt_age_chk_state15 = idle15;

      inval_all15:
         if (mem_addr_age15 != max_addr)
            nxt_age_chk_state15 = inval_all15;  // move15 onto15 next address
         else
            nxt_age_chk_state15 = idle15;

      age_chk15:
         if (age_confirmed15)
            begin
            if (add_check_active15)                     // age15 check for addr chkr15
               nxt_age_chk_state15 = idle15;
            else if (~mem_read_data_age15[82])      // invalid, check next location15
               nxt_age_chk_state15 = inval_aged_rd15; 
            else if (~age_ok15 & mem_read_data_age15[82]) // out of date15, clear 
               nxt_age_chk_state15 = inval_aged_wr15;
            else if (mem_addr_age15 == max_addr)    // full check completed
               nxt_age_chk_state15 = idle15;     
            else 
               nxt_age_chk_state15 = inval_aged_rd15; // age15 ok, check next location15 
            end       
         else
            nxt_age_chk_state15 = age_chk15;

      default:
            nxt_age_chk_state15 = idle15;
      endcase
   end



always @ (posedge pclk15 or negedge n_p_reset15)
   begin
   if (~n_p_reset15)
      age_chk_state15 <= idle15;
   else
      age_chk_state15 <= nxt_age_chk_state15;
   end


// -----------------------------------------------------------------------------
//   Generate15 memory RW bus for accessing array when requested15 to invalidate15 all
//   aged15 addresses15 and all addresses15.
// -----------------------------------------------------------------------------
always @ (posedge pclk15 or negedge n_p_reset15)
   begin
   if (~n_p_reset15)
   begin
      mem_addr_age15 <= 8'd0;     
      mem_write_age15 <= 1'd0;    
   end
   else if (age_chk_state15 == inval_aged_rd15)  // invalidate15 aged15 read
   begin
      mem_addr_age15 <= mem_addr_age15 + 1'd1;     
      mem_write_age15 <= 1'd0;    
   end
   else if (age_chk_state15 == inval_aged_wr15)  // invalidate15 aged15 read
   begin
      mem_addr_age15 <= mem_addr_age15;     
      mem_write_age15 <= 1'd1;    
   end
   else if (age_chk_state15 == inval_all15)  // invalidate15 all
   begin
      mem_addr_age15 <= mem_addr_age15 + 1'd1;     
      mem_write_age15 <= 1'd1;    
   end
   else if (age_chk_state15 == age_chk15)
   begin
      mem_addr_age15 <= mem_addr_age15;     
      mem_write_age15 <= mem_write_age15;    
   end
   else 
   begin
      mem_addr_age15 <= mem_addr_age15;     
      mem_write_age15 <= 1'd0;    
   end
   end

// age15 checker will only ever15 write zero values to ALUT15 mem
assign mem_write_data_age15 = 83'd0;



// -----------------------------------------------------------------------------
//   Generate15 invalidate15 in progress15 flag15 (bit 1 of status register)
// -----------------------------------------------------------------------------
always @ (posedge pclk15 or negedge n_p_reset15)
   begin
   if (~n_p_reset15)
      inval_in_prog15 <= 1'd0;
   else if (age_chk_state15 == inval_aged_wr15) 
      inval_in_prog15 <= 1'd1;
   else if ((age_chk_state15 == age_chk15) & (mem_addr_age15 == max_addr))
      inval_in_prog15 <= 1'd0;
   else
      inval_in_prog15 <= inval_in_prog15;
   end


// -----------------------------------------------------------------------------
//   Calculate15 whether15 data is still in date15.  Need15 to work15 out the real time
//   gap15 between current time and last accessed.  If15 this gap15 is greater than
//   the best15 before age15, then15 the data is out of date15. 
// -----------------------------------------------------------------------------
assign time_since_lst_acc15 = (curr_time15 > last_accessed15) ? 
                            (curr_time15 - last_accessed15) :  // no cnt wrapping15
                            (curr_time15 + (max_cnt15 - last_accessed15));

assign time_since_lst_acc_age15 = (curr_time15 > last_accessed_age15) ? 
                                (curr_time15 - last_accessed_age15) : // no wrapping15
                                (curr_time15 + (max_cnt15 - last_accessed_age15));


always @ (posedge pclk15 or negedge n_p_reset15)
   begin
   if (~n_p_reset15)
      begin
      age_ok15 <= 1'b0;
      age_confirmed15 <= 1'b0;
      end
   else if ((age_chk_state15 == age_chk15) & add_check_active15) 
      begin                                       // age15 checking for addr chkr15
      if (best_bfr_age15 > time_since_lst_acc15)      // still in date15
         begin
         age_ok15 <= 1'b1;
         age_confirmed15 <= 1'b1;
         end
      else   // out of date15
         begin
         age_ok15 <= 1'b0;
         age_confirmed15 <= 1'b1;
         end
      end
   else if ((age_chk_state15 == age_chk15) & ~add_check_active15)
      begin                                      // age15 checking for inval15 aged15
      if (best_bfr_age15 > time_since_lst_acc_age15) // still in date15
         begin
         age_ok15 <= 1'b1;
         age_confirmed15 <= 1'b1;
         end
      else   // out of date15
         begin
         age_ok15 <= 1'b0;
         age_confirmed15 <= 1'b1;
         end
      end
   else
      begin
      age_ok15 <= 1'b0;
      age_confirmed15 <= 1'b0;
      end
   end



// -----------------------------------------------------------------------------
//   Generate15 last address and port that was cleared15 in the invalid aged15 process
// -----------------------------------------------------------------------------
always @ (posedge pclk15 or negedge n_p_reset15)
   begin
   if (~n_p_reset15)
      begin
      lst_inv_addr_cmd15 <= 48'd0;
      lst_inv_port_cmd15 <= 2'd0;
      end
   else if (age_chk_state15 == inval_aged_wr15)
      begin
      lst_inv_addr_cmd15 <= mem_read_data_age15[47:0];
      lst_inv_port_cmd15 <= mem_read_data_age15[49:48];
      end
   else 
      begin
      lst_inv_addr_cmd15 <= lst_inv_addr_cmd15;
      lst_inv_port_cmd15 <= lst_inv_port_cmd15;
      end
   end


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded15 off15 age_chk_state15
// -----------------------------------------------------------------------------
assign age_check_active15 = (age_chk_state15 != 3'b000);

endmodule

