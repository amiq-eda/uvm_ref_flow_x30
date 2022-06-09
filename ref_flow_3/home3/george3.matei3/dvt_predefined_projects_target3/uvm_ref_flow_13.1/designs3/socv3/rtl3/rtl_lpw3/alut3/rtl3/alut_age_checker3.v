//File3 name   : alut_age_checker3.v
//Title3       : 
//Created3     : 1999
//Description3 : 
//Notes3       : 
//----------------------------------------------------------------------
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------

module alut_age_checker3
(   
   // Inputs3
   pclk3,
   n_p_reset3,
   command,          
   div_clk3,          
   mem_read_data_age3,
   check_age3,        
   last_accessed3, 
   best_bfr_age3,   
   add_check_active3,

   // outputs3
   curr_time3,         
   mem_addr_age3,      
   mem_write_age3,     
   mem_write_data_age3,
   lst_inv_addr_cmd3,    
   lst_inv_port_cmd3,  
   age_confirmed3,     
   age_ok3,
   inval_in_prog3,  
   age_check_active3          
);   

   input               pclk3;               // APB3 clock3                           
   input               n_p_reset3;          // Reset3                               
   input [1:0]         command;            // command bus                        
   input [7:0]         div_clk3;            // clock3 divider3 value
   input [82:0]        mem_read_data_age3;  // read data from memory             
   input               check_age3;          // request flag3 for age3 check
   input [31:0]        last_accessed3;      // time field sent3 for age3 check
   input [31:0]        best_bfr_age3;       // best3 before age3
   input               add_check_active3;   // active flag3 from address checker

   output [31:0]       curr_time3;          // current time,for storing3 in mem    
   output [7:0]        mem_addr_age3;       // address for R/W3 to memory     
   output              mem_write_age3;      // R/W3 flag3 (write = high3)            
   output [82:0]       mem_write_data_age3; // write data for memory             
   output [47:0]       lst_inv_addr_cmd3;   // last invalidated3 addr normal3 op    
   output [1:0]        lst_inv_port_cmd3;   // last invalidated3 port normal3 op    
   output              age_confirmed3;      // validates3 age_ok3 result 
   output              age_ok3;             // age3 checker result - set means3 in-date3
   output              inval_in_prog3;      // invalidation3 in progress3
   output              age_check_active3;   // bit 0 of status register           

   reg  [2:0]          age_chk_state3;      // age3 checker FSM3 current state
   reg  [2:0]          nxt_age_chk_state3;  // age3 checker FSM3 next state
   reg  [7:0]          mem_addr_age3;     
   reg                 mem_write_age3;    
   reg                 inval_in_prog3;      // invalidation3 in progress3
   reg  [7:0]          clk_div_cnt3;        // clock3 divider3 counter
   reg  [31:0]         curr_time3;          // current time,for storing3 in mem  
   reg                 age_confirmed3;      // validates3 age_ok3 result 
   reg                 age_ok3;             // age3 checker result - set means3 in-date3
   reg [47:0]          lst_inv_addr_cmd3;   // last invalidated3 addr normal3 op    
   reg [1:0]           lst_inv_port_cmd3;   // last invalidated3 port normal3 op    

   wire  [82:0]        mem_write_data_age3;
   wire  [31:0]        last_accessed_age3;  // read back time by age3 checker
   wire  [31:0]        time_since_lst_acc_age3;  // time since3 last accessed age3
   wire  [31:0]        time_since_lst_acc3; // time since3 last accessed address
   wire                age_check_active3;   // bit 0 of status register           

// Parameters3 for Address Checking3 FSM3 states3
   parameter idle3           = 3'b000;
   parameter inval_aged_rd3  = 3'b001;
   parameter inval_aged_wr3  = 3'b010;
   parameter inval_all3      = 3'b011;
   parameter age_chk3        = 3'b100;

   parameter max_addr       = 8'hff;
   parameter max_cnt3        = 32'hffff_ffff;

// -----------------------------------------------------------------------------
//   Generate3 current time counter
// -----------------------------------------------------------------------------
always @ (posedge pclk3 or negedge n_p_reset3)
   begin
   if (~n_p_reset3)
      clk_div_cnt3 <= 8'd0;
   else if (clk_div_cnt3 == div_clk3)
      clk_div_cnt3 <= 8'd0; 
   else 
      clk_div_cnt3 <= clk_div_cnt3 + 1'd1;
   end


always @ (posedge pclk3 or negedge n_p_reset3)
   begin
   if (~n_p_reset3)
      curr_time3 <= 32'd0;
   else if (clk_div_cnt3 == div_clk3)
      curr_time3 <= curr_time3 + 1'd1;
   end


// -----------------------------------------------------------------------------
//   Age3 checker State3 Machine3 
// -----------------------------------------------------------------------------
always @ (command or check_age3 or age_chk_state3 or age_confirmed3 or age_ok3 or
          mem_addr_age3 or mem_read_data_age3[82])
   begin
      case (age_chk_state3)
      
      idle3:
         if (command == 2'b10)
            nxt_age_chk_state3 = inval_aged_rd3;
         else if (command == 2'b11)
            nxt_age_chk_state3 = inval_all3;
         else if (check_age3)
            nxt_age_chk_state3 = age_chk3;
         else
            nxt_age_chk_state3 = idle3;

      inval_aged_rd3:
            nxt_age_chk_state3 = age_chk3;

      inval_aged_wr3:
            nxt_age_chk_state3 = idle3;

      inval_all3:
         if (mem_addr_age3 != max_addr)
            nxt_age_chk_state3 = inval_all3;  // move3 onto3 next address
         else
            nxt_age_chk_state3 = idle3;

      age_chk3:
         if (age_confirmed3)
            begin
            if (add_check_active3)                     // age3 check for addr chkr3
               nxt_age_chk_state3 = idle3;
            else if (~mem_read_data_age3[82])      // invalid, check next location3
               nxt_age_chk_state3 = inval_aged_rd3; 
            else if (~age_ok3 & mem_read_data_age3[82]) // out of date3, clear 
               nxt_age_chk_state3 = inval_aged_wr3;
            else if (mem_addr_age3 == max_addr)    // full check completed
               nxt_age_chk_state3 = idle3;     
            else 
               nxt_age_chk_state3 = inval_aged_rd3; // age3 ok, check next location3 
            end       
         else
            nxt_age_chk_state3 = age_chk3;

      default:
            nxt_age_chk_state3 = idle3;
      endcase
   end



always @ (posedge pclk3 or negedge n_p_reset3)
   begin
   if (~n_p_reset3)
      age_chk_state3 <= idle3;
   else
      age_chk_state3 <= nxt_age_chk_state3;
   end


// -----------------------------------------------------------------------------
//   Generate3 memory RW bus for accessing array when requested3 to invalidate3 all
//   aged3 addresses3 and all addresses3.
// -----------------------------------------------------------------------------
always @ (posedge pclk3 or negedge n_p_reset3)
   begin
   if (~n_p_reset3)
   begin
      mem_addr_age3 <= 8'd0;     
      mem_write_age3 <= 1'd0;    
   end
   else if (age_chk_state3 == inval_aged_rd3)  // invalidate3 aged3 read
   begin
      mem_addr_age3 <= mem_addr_age3 + 1'd1;     
      mem_write_age3 <= 1'd0;    
   end
   else if (age_chk_state3 == inval_aged_wr3)  // invalidate3 aged3 read
   begin
      mem_addr_age3 <= mem_addr_age3;     
      mem_write_age3 <= 1'd1;    
   end
   else if (age_chk_state3 == inval_all3)  // invalidate3 all
   begin
      mem_addr_age3 <= mem_addr_age3 + 1'd1;     
      mem_write_age3 <= 1'd1;    
   end
   else if (age_chk_state3 == age_chk3)
   begin
      mem_addr_age3 <= mem_addr_age3;     
      mem_write_age3 <= mem_write_age3;    
   end
   else 
   begin
      mem_addr_age3 <= mem_addr_age3;     
      mem_write_age3 <= 1'd0;    
   end
   end

// age3 checker will only ever3 write zero values to ALUT3 mem
assign mem_write_data_age3 = 83'd0;



// -----------------------------------------------------------------------------
//   Generate3 invalidate3 in progress3 flag3 (bit 1 of status register)
// -----------------------------------------------------------------------------
always @ (posedge pclk3 or negedge n_p_reset3)
   begin
   if (~n_p_reset3)
      inval_in_prog3 <= 1'd0;
   else if (age_chk_state3 == inval_aged_wr3) 
      inval_in_prog3 <= 1'd1;
   else if ((age_chk_state3 == age_chk3) & (mem_addr_age3 == max_addr))
      inval_in_prog3 <= 1'd0;
   else
      inval_in_prog3 <= inval_in_prog3;
   end


// -----------------------------------------------------------------------------
//   Calculate3 whether3 data is still in date3.  Need3 to work3 out the real time
//   gap3 between current time and last accessed.  If3 this gap3 is greater than
//   the best3 before age3, then3 the data is out of date3. 
// -----------------------------------------------------------------------------
assign time_since_lst_acc3 = (curr_time3 > last_accessed3) ? 
                            (curr_time3 - last_accessed3) :  // no cnt wrapping3
                            (curr_time3 + (max_cnt3 - last_accessed3));

assign time_since_lst_acc_age3 = (curr_time3 > last_accessed_age3) ? 
                                (curr_time3 - last_accessed_age3) : // no wrapping3
                                (curr_time3 + (max_cnt3 - last_accessed_age3));


always @ (posedge pclk3 or negedge n_p_reset3)
   begin
   if (~n_p_reset3)
      begin
      age_ok3 <= 1'b0;
      age_confirmed3 <= 1'b0;
      end
   else if ((age_chk_state3 == age_chk3) & add_check_active3) 
      begin                                       // age3 checking for addr chkr3
      if (best_bfr_age3 > time_since_lst_acc3)      // still in date3
         begin
         age_ok3 <= 1'b1;
         age_confirmed3 <= 1'b1;
         end
      else   // out of date3
         begin
         age_ok3 <= 1'b0;
         age_confirmed3 <= 1'b1;
         end
      end
   else if ((age_chk_state3 == age_chk3) & ~add_check_active3)
      begin                                      // age3 checking for inval3 aged3
      if (best_bfr_age3 > time_since_lst_acc_age3) // still in date3
         begin
         age_ok3 <= 1'b1;
         age_confirmed3 <= 1'b1;
         end
      else   // out of date3
         begin
         age_ok3 <= 1'b0;
         age_confirmed3 <= 1'b1;
         end
      end
   else
      begin
      age_ok3 <= 1'b0;
      age_confirmed3 <= 1'b0;
      end
   end



// -----------------------------------------------------------------------------
//   Generate3 last address and port that was cleared3 in the invalid aged3 process
// -----------------------------------------------------------------------------
always @ (posedge pclk3 or negedge n_p_reset3)
   begin
   if (~n_p_reset3)
      begin
      lst_inv_addr_cmd3 <= 48'd0;
      lst_inv_port_cmd3 <= 2'd0;
      end
   else if (age_chk_state3 == inval_aged_wr3)
      begin
      lst_inv_addr_cmd3 <= mem_read_data_age3[47:0];
      lst_inv_port_cmd3 <= mem_read_data_age3[49:48];
      end
   else 
      begin
      lst_inv_addr_cmd3 <= lst_inv_addr_cmd3;
      lst_inv_port_cmd3 <= lst_inv_port_cmd3;
      end
   end


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded3 off3 age_chk_state3
// -----------------------------------------------------------------------------
assign age_check_active3 = (age_chk_state3 != 3'b000);

endmodule

