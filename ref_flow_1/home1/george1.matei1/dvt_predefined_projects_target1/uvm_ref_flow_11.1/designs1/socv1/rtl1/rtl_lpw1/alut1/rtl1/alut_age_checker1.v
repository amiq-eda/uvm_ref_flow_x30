//File1 name   : alut_age_checker1.v
//Title1       : 
//Created1     : 1999
//Description1 : 
//Notes1       : 
//----------------------------------------------------------------------
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------

module alut_age_checker1
(   
   // Inputs1
   pclk1,
   n_p_reset1,
   command,          
   div_clk1,          
   mem_read_data_age1,
   check_age1,        
   last_accessed1, 
   best_bfr_age1,   
   add_check_active1,

   // outputs1
   curr_time1,         
   mem_addr_age1,      
   mem_write_age1,     
   mem_write_data_age1,
   lst_inv_addr_cmd1,    
   lst_inv_port_cmd1,  
   age_confirmed1,     
   age_ok1,
   inval_in_prog1,  
   age_check_active1          
);   

   input               pclk1;               // APB1 clock1                           
   input               n_p_reset1;          // Reset1                               
   input [1:0]         command;            // command bus                        
   input [7:0]         div_clk1;            // clock1 divider1 value
   input [82:0]        mem_read_data_age1;  // read data from memory             
   input               check_age1;          // request flag1 for age1 check
   input [31:0]        last_accessed1;      // time field sent1 for age1 check
   input [31:0]        best_bfr_age1;       // best1 before age1
   input               add_check_active1;   // active flag1 from address checker

   output [31:0]       curr_time1;          // current time,for storing1 in mem    
   output [7:0]        mem_addr_age1;       // address for R/W1 to memory     
   output              mem_write_age1;      // R/W1 flag1 (write = high1)            
   output [82:0]       mem_write_data_age1; // write data for memory             
   output [47:0]       lst_inv_addr_cmd1;   // last invalidated1 addr normal1 op    
   output [1:0]        lst_inv_port_cmd1;   // last invalidated1 port normal1 op    
   output              age_confirmed1;      // validates1 age_ok1 result 
   output              age_ok1;             // age1 checker result - set means1 in-date1
   output              inval_in_prog1;      // invalidation1 in progress1
   output              age_check_active1;   // bit 0 of status register           

   reg  [2:0]          age_chk_state1;      // age1 checker FSM1 current state
   reg  [2:0]          nxt_age_chk_state1;  // age1 checker FSM1 next state
   reg  [7:0]          mem_addr_age1;     
   reg                 mem_write_age1;    
   reg                 inval_in_prog1;      // invalidation1 in progress1
   reg  [7:0]          clk_div_cnt1;        // clock1 divider1 counter
   reg  [31:0]         curr_time1;          // current time,for storing1 in mem  
   reg                 age_confirmed1;      // validates1 age_ok1 result 
   reg                 age_ok1;             // age1 checker result - set means1 in-date1
   reg [47:0]          lst_inv_addr_cmd1;   // last invalidated1 addr normal1 op    
   reg [1:0]           lst_inv_port_cmd1;   // last invalidated1 port normal1 op    

   wire  [82:0]        mem_write_data_age1;
   wire  [31:0]        last_accessed_age1;  // read back time by age1 checker
   wire  [31:0]        time_since_lst_acc_age1;  // time since1 last accessed age1
   wire  [31:0]        time_since_lst_acc1; // time since1 last accessed address
   wire                age_check_active1;   // bit 0 of status register           

// Parameters1 for Address Checking1 FSM1 states1
   parameter idle1           = 3'b000;
   parameter inval_aged_rd1  = 3'b001;
   parameter inval_aged_wr1  = 3'b010;
   parameter inval_all1      = 3'b011;
   parameter age_chk1        = 3'b100;

   parameter max_addr       = 8'hff;
   parameter max_cnt1        = 32'hffff_ffff;

// -----------------------------------------------------------------------------
//   Generate1 current time counter
// -----------------------------------------------------------------------------
always @ (posedge pclk1 or negedge n_p_reset1)
   begin
   if (~n_p_reset1)
      clk_div_cnt1 <= 8'd0;
   else if (clk_div_cnt1 == div_clk1)
      clk_div_cnt1 <= 8'd0; 
   else 
      clk_div_cnt1 <= clk_div_cnt1 + 1'd1;
   end


always @ (posedge pclk1 or negedge n_p_reset1)
   begin
   if (~n_p_reset1)
      curr_time1 <= 32'd0;
   else if (clk_div_cnt1 == div_clk1)
      curr_time1 <= curr_time1 + 1'd1;
   end


// -----------------------------------------------------------------------------
//   Age1 checker State1 Machine1 
// -----------------------------------------------------------------------------
always @ (command or check_age1 or age_chk_state1 or age_confirmed1 or age_ok1 or
          mem_addr_age1 or mem_read_data_age1[82])
   begin
      case (age_chk_state1)
      
      idle1:
         if (command == 2'b10)
            nxt_age_chk_state1 = inval_aged_rd1;
         else if (command == 2'b11)
            nxt_age_chk_state1 = inval_all1;
         else if (check_age1)
            nxt_age_chk_state1 = age_chk1;
         else
            nxt_age_chk_state1 = idle1;

      inval_aged_rd1:
            nxt_age_chk_state1 = age_chk1;

      inval_aged_wr1:
            nxt_age_chk_state1 = idle1;

      inval_all1:
         if (mem_addr_age1 != max_addr)
            nxt_age_chk_state1 = inval_all1;  // move1 onto1 next address
         else
            nxt_age_chk_state1 = idle1;

      age_chk1:
         if (age_confirmed1)
            begin
            if (add_check_active1)                     // age1 check for addr chkr1
               nxt_age_chk_state1 = idle1;
            else if (~mem_read_data_age1[82])      // invalid, check next location1
               nxt_age_chk_state1 = inval_aged_rd1; 
            else if (~age_ok1 & mem_read_data_age1[82]) // out of date1, clear 
               nxt_age_chk_state1 = inval_aged_wr1;
            else if (mem_addr_age1 == max_addr)    // full check completed
               nxt_age_chk_state1 = idle1;     
            else 
               nxt_age_chk_state1 = inval_aged_rd1; // age1 ok, check next location1 
            end       
         else
            nxt_age_chk_state1 = age_chk1;

      default:
            nxt_age_chk_state1 = idle1;
      endcase
   end



always @ (posedge pclk1 or negedge n_p_reset1)
   begin
   if (~n_p_reset1)
      age_chk_state1 <= idle1;
   else
      age_chk_state1 <= nxt_age_chk_state1;
   end


// -----------------------------------------------------------------------------
//   Generate1 memory RW bus for accessing array when requested1 to invalidate1 all
//   aged1 addresses1 and all addresses1.
// -----------------------------------------------------------------------------
always @ (posedge pclk1 or negedge n_p_reset1)
   begin
   if (~n_p_reset1)
   begin
      mem_addr_age1 <= 8'd0;     
      mem_write_age1 <= 1'd0;    
   end
   else if (age_chk_state1 == inval_aged_rd1)  // invalidate1 aged1 read
   begin
      mem_addr_age1 <= mem_addr_age1 + 1'd1;     
      mem_write_age1 <= 1'd0;    
   end
   else if (age_chk_state1 == inval_aged_wr1)  // invalidate1 aged1 read
   begin
      mem_addr_age1 <= mem_addr_age1;     
      mem_write_age1 <= 1'd1;    
   end
   else if (age_chk_state1 == inval_all1)  // invalidate1 all
   begin
      mem_addr_age1 <= mem_addr_age1 + 1'd1;     
      mem_write_age1 <= 1'd1;    
   end
   else if (age_chk_state1 == age_chk1)
   begin
      mem_addr_age1 <= mem_addr_age1;     
      mem_write_age1 <= mem_write_age1;    
   end
   else 
   begin
      mem_addr_age1 <= mem_addr_age1;     
      mem_write_age1 <= 1'd0;    
   end
   end

// age1 checker will only ever1 write zero values to ALUT1 mem
assign mem_write_data_age1 = 83'd0;



// -----------------------------------------------------------------------------
//   Generate1 invalidate1 in progress1 flag1 (bit 1 of status register)
// -----------------------------------------------------------------------------
always @ (posedge pclk1 or negedge n_p_reset1)
   begin
   if (~n_p_reset1)
      inval_in_prog1 <= 1'd0;
   else if (age_chk_state1 == inval_aged_wr1) 
      inval_in_prog1 <= 1'd1;
   else if ((age_chk_state1 == age_chk1) & (mem_addr_age1 == max_addr))
      inval_in_prog1 <= 1'd0;
   else
      inval_in_prog1 <= inval_in_prog1;
   end


// -----------------------------------------------------------------------------
//   Calculate1 whether1 data is still in date1.  Need1 to work1 out the real time
//   gap1 between current time and last accessed.  If1 this gap1 is greater than
//   the best1 before age1, then1 the data is out of date1. 
// -----------------------------------------------------------------------------
assign time_since_lst_acc1 = (curr_time1 > last_accessed1) ? 
                            (curr_time1 - last_accessed1) :  // no cnt wrapping1
                            (curr_time1 + (max_cnt1 - last_accessed1));

assign time_since_lst_acc_age1 = (curr_time1 > last_accessed_age1) ? 
                                (curr_time1 - last_accessed_age1) : // no wrapping1
                                (curr_time1 + (max_cnt1 - last_accessed_age1));


always @ (posedge pclk1 or negedge n_p_reset1)
   begin
   if (~n_p_reset1)
      begin
      age_ok1 <= 1'b0;
      age_confirmed1 <= 1'b0;
      end
   else if ((age_chk_state1 == age_chk1) & add_check_active1) 
      begin                                       // age1 checking for addr chkr1
      if (best_bfr_age1 > time_since_lst_acc1)      // still in date1
         begin
         age_ok1 <= 1'b1;
         age_confirmed1 <= 1'b1;
         end
      else   // out of date1
         begin
         age_ok1 <= 1'b0;
         age_confirmed1 <= 1'b1;
         end
      end
   else if ((age_chk_state1 == age_chk1) & ~add_check_active1)
      begin                                      // age1 checking for inval1 aged1
      if (best_bfr_age1 > time_since_lst_acc_age1) // still in date1
         begin
         age_ok1 <= 1'b1;
         age_confirmed1 <= 1'b1;
         end
      else   // out of date1
         begin
         age_ok1 <= 1'b0;
         age_confirmed1 <= 1'b1;
         end
      end
   else
      begin
      age_ok1 <= 1'b0;
      age_confirmed1 <= 1'b0;
      end
   end



// -----------------------------------------------------------------------------
//   Generate1 last address and port that was cleared1 in the invalid aged1 process
// -----------------------------------------------------------------------------
always @ (posedge pclk1 or negedge n_p_reset1)
   begin
   if (~n_p_reset1)
      begin
      lst_inv_addr_cmd1 <= 48'd0;
      lst_inv_port_cmd1 <= 2'd0;
      end
   else if (age_chk_state1 == inval_aged_wr1)
      begin
      lst_inv_addr_cmd1 <= mem_read_data_age1[47:0];
      lst_inv_port_cmd1 <= mem_read_data_age1[49:48];
      end
   else 
      begin
      lst_inv_addr_cmd1 <= lst_inv_addr_cmd1;
      lst_inv_port_cmd1 <= lst_inv_port_cmd1;
      end
   end


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded1 off1 age_chk_state1
// -----------------------------------------------------------------------------
assign age_check_active1 = (age_chk_state1 != 3'b000);

endmodule

