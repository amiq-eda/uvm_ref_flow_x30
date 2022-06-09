//File17 name   : alut_age_checker17.v
//Title17       : 
//Created17     : 1999
//Description17 : 
//Notes17       : 
//----------------------------------------------------------------------
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------

module alut_age_checker17
(   
   // Inputs17
   pclk17,
   n_p_reset17,
   command,          
   div_clk17,          
   mem_read_data_age17,
   check_age17,        
   last_accessed17, 
   best_bfr_age17,   
   add_check_active17,

   // outputs17
   curr_time17,         
   mem_addr_age17,      
   mem_write_age17,     
   mem_write_data_age17,
   lst_inv_addr_cmd17,    
   lst_inv_port_cmd17,  
   age_confirmed17,     
   age_ok17,
   inval_in_prog17,  
   age_check_active17          
);   

   input               pclk17;               // APB17 clock17                           
   input               n_p_reset17;          // Reset17                               
   input [1:0]         command;            // command bus                        
   input [7:0]         div_clk17;            // clock17 divider17 value
   input [82:0]        mem_read_data_age17;  // read data from memory             
   input               check_age17;          // request flag17 for age17 check
   input [31:0]        last_accessed17;      // time field sent17 for age17 check
   input [31:0]        best_bfr_age17;       // best17 before age17
   input               add_check_active17;   // active flag17 from address checker

   output [31:0]       curr_time17;          // current time,for storing17 in mem    
   output [7:0]        mem_addr_age17;       // address for R/W17 to memory     
   output              mem_write_age17;      // R/W17 flag17 (write = high17)            
   output [82:0]       mem_write_data_age17; // write data for memory             
   output [47:0]       lst_inv_addr_cmd17;   // last invalidated17 addr normal17 op    
   output [1:0]        lst_inv_port_cmd17;   // last invalidated17 port normal17 op    
   output              age_confirmed17;      // validates17 age_ok17 result 
   output              age_ok17;             // age17 checker result - set means17 in-date17
   output              inval_in_prog17;      // invalidation17 in progress17
   output              age_check_active17;   // bit 0 of status register           

   reg  [2:0]          age_chk_state17;      // age17 checker FSM17 current state
   reg  [2:0]          nxt_age_chk_state17;  // age17 checker FSM17 next state
   reg  [7:0]          mem_addr_age17;     
   reg                 mem_write_age17;    
   reg                 inval_in_prog17;      // invalidation17 in progress17
   reg  [7:0]          clk_div_cnt17;        // clock17 divider17 counter
   reg  [31:0]         curr_time17;          // current time,for storing17 in mem  
   reg                 age_confirmed17;      // validates17 age_ok17 result 
   reg                 age_ok17;             // age17 checker result - set means17 in-date17
   reg [47:0]          lst_inv_addr_cmd17;   // last invalidated17 addr normal17 op    
   reg [1:0]           lst_inv_port_cmd17;   // last invalidated17 port normal17 op    

   wire  [82:0]        mem_write_data_age17;
   wire  [31:0]        last_accessed_age17;  // read back time by age17 checker
   wire  [31:0]        time_since_lst_acc_age17;  // time since17 last accessed age17
   wire  [31:0]        time_since_lst_acc17; // time since17 last accessed address
   wire                age_check_active17;   // bit 0 of status register           

// Parameters17 for Address Checking17 FSM17 states17
   parameter idle17           = 3'b000;
   parameter inval_aged_rd17  = 3'b001;
   parameter inval_aged_wr17  = 3'b010;
   parameter inval_all17      = 3'b011;
   parameter age_chk17        = 3'b100;

   parameter max_addr       = 8'hff;
   parameter max_cnt17        = 32'hffff_ffff;

// -----------------------------------------------------------------------------
//   Generate17 current time counter
// -----------------------------------------------------------------------------
always @ (posedge pclk17 or negedge n_p_reset17)
   begin
   if (~n_p_reset17)
      clk_div_cnt17 <= 8'd0;
   else if (clk_div_cnt17 == div_clk17)
      clk_div_cnt17 <= 8'd0; 
   else 
      clk_div_cnt17 <= clk_div_cnt17 + 1'd1;
   end


always @ (posedge pclk17 or negedge n_p_reset17)
   begin
   if (~n_p_reset17)
      curr_time17 <= 32'd0;
   else if (clk_div_cnt17 == div_clk17)
      curr_time17 <= curr_time17 + 1'd1;
   end


// -----------------------------------------------------------------------------
//   Age17 checker State17 Machine17 
// -----------------------------------------------------------------------------
always @ (command or check_age17 or age_chk_state17 or age_confirmed17 or age_ok17 or
          mem_addr_age17 or mem_read_data_age17[82])
   begin
      case (age_chk_state17)
      
      idle17:
         if (command == 2'b10)
            nxt_age_chk_state17 = inval_aged_rd17;
         else if (command == 2'b11)
            nxt_age_chk_state17 = inval_all17;
         else if (check_age17)
            nxt_age_chk_state17 = age_chk17;
         else
            nxt_age_chk_state17 = idle17;

      inval_aged_rd17:
            nxt_age_chk_state17 = age_chk17;

      inval_aged_wr17:
            nxt_age_chk_state17 = idle17;

      inval_all17:
         if (mem_addr_age17 != max_addr)
            nxt_age_chk_state17 = inval_all17;  // move17 onto17 next address
         else
            nxt_age_chk_state17 = idle17;

      age_chk17:
         if (age_confirmed17)
            begin
            if (add_check_active17)                     // age17 check for addr chkr17
               nxt_age_chk_state17 = idle17;
            else if (~mem_read_data_age17[82])      // invalid, check next location17
               nxt_age_chk_state17 = inval_aged_rd17; 
            else if (~age_ok17 & mem_read_data_age17[82]) // out of date17, clear 
               nxt_age_chk_state17 = inval_aged_wr17;
            else if (mem_addr_age17 == max_addr)    // full check completed
               nxt_age_chk_state17 = idle17;     
            else 
               nxt_age_chk_state17 = inval_aged_rd17; // age17 ok, check next location17 
            end       
         else
            nxt_age_chk_state17 = age_chk17;

      default:
            nxt_age_chk_state17 = idle17;
      endcase
   end



always @ (posedge pclk17 or negedge n_p_reset17)
   begin
   if (~n_p_reset17)
      age_chk_state17 <= idle17;
   else
      age_chk_state17 <= nxt_age_chk_state17;
   end


// -----------------------------------------------------------------------------
//   Generate17 memory RW bus for accessing array when requested17 to invalidate17 all
//   aged17 addresses17 and all addresses17.
// -----------------------------------------------------------------------------
always @ (posedge pclk17 or negedge n_p_reset17)
   begin
   if (~n_p_reset17)
   begin
      mem_addr_age17 <= 8'd0;     
      mem_write_age17 <= 1'd0;    
   end
   else if (age_chk_state17 == inval_aged_rd17)  // invalidate17 aged17 read
   begin
      mem_addr_age17 <= mem_addr_age17 + 1'd1;     
      mem_write_age17 <= 1'd0;    
   end
   else if (age_chk_state17 == inval_aged_wr17)  // invalidate17 aged17 read
   begin
      mem_addr_age17 <= mem_addr_age17;     
      mem_write_age17 <= 1'd1;    
   end
   else if (age_chk_state17 == inval_all17)  // invalidate17 all
   begin
      mem_addr_age17 <= mem_addr_age17 + 1'd1;     
      mem_write_age17 <= 1'd1;    
   end
   else if (age_chk_state17 == age_chk17)
   begin
      mem_addr_age17 <= mem_addr_age17;     
      mem_write_age17 <= mem_write_age17;    
   end
   else 
   begin
      mem_addr_age17 <= mem_addr_age17;     
      mem_write_age17 <= 1'd0;    
   end
   end

// age17 checker will only ever17 write zero values to ALUT17 mem
assign mem_write_data_age17 = 83'd0;



// -----------------------------------------------------------------------------
//   Generate17 invalidate17 in progress17 flag17 (bit 1 of status register)
// -----------------------------------------------------------------------------
always @ (posedge pclk17 or negedge n_p_reset17)
   begin
   if (~n_p_reset17)
      inval_in_prog17 <= 1'd0;
   else if (age_chk_state17 == inval_aged_wr17) 
      inval_in_prog17 <= 1'd1;
   else if ((age_chk_state17 == age_chk17) & (mem_addr_age17 == max_addr))
      inval_in_prog17 <= 1'd0;
   else
      inval_in_prog17 <= inval_in_prog17;
   end


// -----------------------------------------------------------------------------
//   Calculate17 whether17 data is still in date17.  Need17 to work17 out the real time
//   gap17 between current time and last accessed.  If17 this gap17 is greater than
//   the best17 before age17, then17 the data is out of date17. 
// -----------------------------------------------------------------------------
assign time_since_lst_acc17 = (curr_time17 > last_accessed17) ? 
                            (curr_time17 - last_accessed17) :  // no cnt wrapping17
                            (curr_time17 + (max_cnt17 - last_accessed17));

assign time_since_lst_acc_age17 = (curr_time17 > last_accessed_age17) ? 
                                (curr_time17 - last_accessed_age17) : // no wrapping17
                                (curr_time17 + (max_cnt17 - last_accessed_age17));


always @ (posedge pclk17 or negedge n_p_reset17)
   begin
   if (~n_p_reset17)
      begin
      age_ok17 <= 1'b0;
      age_confirmed17 <= 1'b0;
      end
   else if ((age_chk_state17 == age_chk17) & add_check_active17) 
      begin                                       // age17 checking for addr chkr17
      if (best_bfr_age17 > time_since_lst_acc17)      // still in date17
         begin
         age_ok17 <= 1'b1;
         age_confirmed17 <= 1'b1;
         end
      else   // out of date17
         begin
         age_ok17 <= 1'b0;
         age_confirmed17 <= 1'b1;
         end
      end
   else if ((age_chk_state17 == age_chk17) & ~add_check_active17)
      begin                                      // age17 checking for inval17 aged17
      if (best_bfr_age17 > time_since_lst_acc_age17) // still in date17
         begin
         age_ok17 <= 1'b1;
         age_confirmed17 <= 1'b1;
         end
      else   // out of date17
         begin
         age_ok17 <= 1'b0;
         age_confirmed17 <= 1'b1;
         end
      end
   else
      begin
      age_ok17 <= 1'b0;
      age_confirmed17 <= 1'b0;
      end
   end



// -----------------------------------------------------------------------------
//   Generate17 last address and port that was cleared17 in the invalid aged17 process
// -----------------------------------------------------------------------------
always @ (posedge pclk17 or negedge n_p_reset17)
   begin
   if (~n_p_reset17)
      begin
      lst_inv_addr_cmd17 <= 48'd0;
      lst_inv_port_cmd17 <= 2'd0;
      end
   else if (age_chk_state17 == inval_aged_wr17)
      begin
      lst_inv_addr_cmd17 <= mem_read_data_age17[47:0];
      lst_inv_port_cmd17 <= mem_read_data_age17[49:48];
      end
   else 
      begin
      lst_inv_addr_cmd17 <= lst_inv_addr_cmd17;
      lst_inv_port_cmd17 <= lst_inv_port_cmd17;
      end
   end


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded17 off17 age_chk_state17
// -----------------------------------------------------------------------------
assign age_check_active17 = (age_chk_state17 != 3'b000);

endmodule

