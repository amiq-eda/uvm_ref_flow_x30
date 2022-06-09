//File20 name   : alut_age_checker20.v
//Title20       : 
//Created20     : 1999
//Description20 : 
//Notes20       : 
//----------------------------------------------------------------------
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------

module alut_age_checker20
(   
   // Inputs20
   pclk20,
   n_p_reset20,
   command,          
   div_clk20,          
   mem_read_data_age20,
   check_age20,        
   last_accessed20, 
   best_bfr_age20,   
   add_check_active20,

   // outputs20
   curr_time20,         
   mem_addr_age20,      
   mem_write_age20,     
   mem_write_data_age20,
   lst_inv_addr_cmd20,    
   lst_inv_port_cmd20,  
   age_confirmed20,     
   age_ok20,
   inval_in_prog20,  
   age_check_active20          
);   

   input               pclk20;               // APB20 clock20                           
   input               n_p_reset20;          // Reset20                               
   input [1:0]         command;            // command bus                        
   input [7:0]         div_clk20;            // clock20 divider20 value
   input [82:0]        mem_read_data_age20;  // read data from memory             
   input               check_age20;          // request flag20 for age20 check
   input [31:0]        last_accessed20;      // time field sent20 for age20 check
   input [31:0]        best_bfr_age20;       // best20 before age20
   input               add_check_active20;   // active flag20 from address checker

   output [31:0]       curr_time20;          // current time,for storing20 in mem    
   output [7:0]        mem_addr_age20;       // address for R/W20 to memory     
   output              mem_write_age20;      // R/W20 flag20 (write = high20)            
   output [82:0]       mem_write_data_age20; // write data for memory             
   output [47:0]       lst_inv_addr_cmd20;   // last invalidated20 addr normal20 op    
   output [1:0]        lst_inv_port_cmd20;   // last invalidated20 port normal20 op    
   output              age_confirmed20;      // validates20 age_ok20 result 
   output              age_ok20;             // age20 checker result - set means20 in-date20
   output              inval_in_prog20;      // invalidation20 in progress20
   output              age_check_active20;   // bit 0 of status register           

   reg  [2:0]          age_chk_state20;      // age20 checker FSM20 current state
   reg  [2:0]          nxt_age_chk_state20;  // age20 checker FSM20 next state
   reg  [7:0]          mem_addr_age20;     
   reg                 mem_write_age20;    
   reg                 inval_in_prog20;      // invalidation20 in progress20
   reg  [7:0]          clk_div_cnt20;        // clock20 divider20 counter
   reg  [31:0]         curr_time20;          // current time,for storing20 in mem  
   reg                 age_confirmed20;      // validates20 age_ok20 result 
   reg                 age_ok20;             // age20 checker result - set means20 in-date20
   reg [47:0]          lst_inv_addr_cmd20;   // last invalidated20 addr normal20 op    
   reg [1:0]           lst_inv_port_cmd20;   // last invalidated20 port normal20 op    

   wire  [82:0]        mem_write_data_age20;
   wire  [31:0]        last_accessed_age20;  // read back time by age20 checker
   wire  [31:0]        time_since_lst_acc_age20;  // time since20 last accessed age20
   wire  [31:0]        time_since_lst_acc20; // time since20 last accessed address
   wire                age_check_active20;   // bit 0 of status register           

// Parameters20 for Address Checking20 FSM20 states20
   parameter idle20           = 3'b000;
   parameter inval_aged_rd20  = 3'b001;
   parameter inval_aged_wr20  = 3'b010;
   parameter inval_all20      = 3'b011;
   parameter age_chk20        = 3'b100;

   parameter max_addr       = 8'hff;
   parameter max_cnt20        = 32'hffff_ffff;

// -----------------------------------------------------------------------------
//   Generate20 current time counter
// -----------------------------------------------------------------------------
always @ (posedge pclk20 or negedge n_p_reset20)
   begin
   if (~n_p_reset20)
      clk_div_cnt20 <= 8'd0;
   else if (clk_div_cnt20 == div_clk20)
      clk_div_cnt20 <= 8'd0; 
   else 
      clk_div_cnt20 <= clk_div_cnt20 + 1'd1;
   end


always @ (posedge pclk20 or negedge n_p_reset20)
   begin
   if (~n_p_reset20)
      curr_time20 <= 32'd0;
   else if (clk_div_cnt20 == div_clk20)
      curr_time20 <= curr_time20 + 1'd1;
   end


// -----------------------------------------------------------------------------
//   Age20 checker State20 Machine20 
// -----------------------------------------------------------------------------
always @ (command or check_age20 or age_chk_state20 or age_confirmed20 or age_ok20 or
          mem_addr_age20 or mem_read_data_age20[82])
   begin
      case (age_chk_state20)
      
      idle20:
         if (command == 2'b10)
            nxt_age_chk_state20 = inval_aged_rd20;
         else if (command == 2'b11)
            nxt_age_chk_state20 = inval_all20;
         else if (check_age20)
            nxt_age_chk_state20 = age_chk20;
         else
            nxt_age_chk_state20 = idle20;

      inval_aged_rd20:
            nxt_age_chk_state20 = age_chk20;

      inval_aged_wr20:
            nxt_age_chk_state20 = idle20;

      inval_all20:
         if (mem_addr_age20 != max_addr)
            nxt_age_chk_state20 = inval_all20;  // move20 onto20 next address
         else
            nxt_age_chk_state20 = idle20;

      age_chk20:
         if (age_confirmed20)
            begin
            if (add_check_active20)                     // age20 check for addr chkr20
               nxt_age_chk_state20 = idle20;
            else if (~mem_read_data_age20[82])      // invalid, check next location20
               nxt_age_chk_state20 = inval_aged_rd20; 
            else if (~age_ok20 & mem_read_data_age20[82]) // out of date20, clear 
               nxt_age_chk_state20 = inval_aged_wr20;
            else if (mem_addr_age20 == max_addr)    // full check completed
               nxt_age_chk_state20 = idle20;     
            else 
               nxt_age_chk_state20 = inval_aged_rd20; // age20 ok, check next location20 
            end       
         else
            nxt_age_chk_state20 = age_chk20;

      default:
            nxt_age_chk_state20 = idle20;
      endcase
   end



always @ (posedge pclk20 or negedge n_p_reset20)
   begin
   if (~n_p_reset20)
      age_chk_state20 <= idle20;
   else
      age_chk_state20 <= nxt_age_chk_state20;
   end


// -----------------------------------------------------------------------------
//   Generate20 memory RW bus for accessing array when requested20 to invalidate20 all
//   aged20 addresses20 and all addresses20.
// -----------------------------------------------------------------------------
always @ (posedge pclk20 or negedge n_p_reset20)
   begin
   if (~n_p_reset20)
   begin
      mem_addr_age20 <= 8'd0;     
      mem_write_age20 <= 1'd0;    
   end
   else if (age_chk_state20 == inval_aged_rd20)  // invalidate20 aged20 read
   begin
      mem_addr_age20 <= mem_addr_age20 + 1'd1;     
      mem_write_age20 <= 1'd0;    
   end
   else if (age_chk_state20 == inval_aged_wr20)  // invalidate20 aged20 read
   begin
      mem_addr_age20 <= mem_addr_age20;     
      mem_write_age20 <= 1'd1;    
   end
   else if (age_chk_state20 == inval_all20)  // invalidate20 all
   begin
      mem_addr_age20 <= mem_addr_age20 + 1'd1;     
      mem_write_age20 <= 1'd1;    
   end
   else if (age_chk_state20 == age_chk20)
   begin
      mem_addr_age20 <= mem_addr_age20;     
      mem_write_age20 <= mem_write_age20;    
   end
   else 
   begin
      mem_addr_age20 <= mem_addr_age20;     
      mem_write_age20 <= 1'd0;    
   end
   end

// age20 checker will only ever20 write zero values to ALUT20 mem
assign mem_write_data_age20 = 83'd0;



// -----------------------------------------------------------------------------
//   Generate20 invalidate20 in progress20 flag20 (bit 1 of status register)
// -----------------------------------------------------------------------------
always @ (posedge pclk20 or negedge n_p_reset20)
   begin
   if (~n_p_reset20)
      inval_in_prog20 <= 1'd0;
   else if (age_chk_state20 == inval_aged_wr20) 
      inval_in_prog20 <= 1'd1;
   else if ((age_chk_state20 == age_chk20) & (mem_addr_age20 == max_addr))
      inval_in_prog20 <= 1'd0;
   else
      inval_in_prog20 <= inval_in_prog20;
   end


// -----------------------------------------------------------------------------
//   Calculate20 whether20 data is still in date20.  Need20 to work20 out the real time
//   gap20 between current time and last accessed.  If20 this gap20 is greater than
//   the best20 before age20, then20 the data is out of date20. 
// -----------------------------------------------------------------------------
assign time_since_lst_acc20 = (curr_time20 > last_accessed20) ? 
                            (curr_time20 - last_accessed20) :  // no cnt wrapping20
                            (curr_time20 + (max_cnt20 - last_accessed20));

assign time_since_lst_acc_age20 = (curr_time20 > last_accessed_age20) ? 
                                (curr_time20 - last_accessed_age20) : // no wrapping20
                                (curr_time20 + (max_cnt20 - last_accessed_age20));


always @ (posedge pclk20 or negedge n_p_reset20)
   begin
   if (~n_p_reset20)
      begin
      age_ok20 <= 1'b0;
      age_confirmed20 <= 1'b0;
      end
   else if ((age_chk_state20 == age_chk20) & add_check_active20) 
      begin                                       // age20 checking for addr chkr20
      if (best_bfr_age20 > time_since_lst_acc20)      // still in date20
         begin
         age_ok20 <= 1'b1;
         age_confirmed20 <= 1'b1;
         end
      else   // out of date20
         begin
         age_ok20 <= 1'b0;
         age_confirmed20 <= 1'b1;
         end
      end
   else if ((age_chk_state20 == age_chk20) & ~add_check_active20)
      begin                                      // age20 checking for inval20 aged20
      if (best_bfr_age20 > time_since_lst_acc_age20) // still in date20
         begin
         age_ok20 <= 1'b1;
         age_confirmed20 <= 1'b1;
         end
      else   // out of date20
         begin
         age_ok20 <= 1'b0;
         age_confirmed20 <= 1'b1;
         end
      end
   else
      begin
      age_ok20 <= 1'b0;
      age_confirmed20 <= 1'b0;
      end
   end



// -----------------------------------------------------------------------------
//   Generate20 last address and port that was cleared20 in the invalid aged20 process
// -----------------------------------------------------------------------------
always @ (posedge pclk20 or negedge n_p_reset20)
   begin
   if (~n_p_reset20)
      begin
      lst_inv_addr_cmd20 <= 48'd0;
      lst_inv_port_cmd20 <= 2'd0;
      end
   else if (age_chk_state20 == inval_aged_wr20)
      begin
      lst_inv_addr_cmd20 <= mem_read_data_age20[47:0];
      lst_inv_port_cmd20 <= mem_read_data_age20[49:48];
      end
   else 
      begin
      lst_inv_addr_cmd20 <= lst_inv_addr_cmd20;
      lst_inv_port_cmd20 <= lst_inv_port_cmd20;
      end
   end


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded20 off20 age_chk_state20
// -----------------------------------------------------------------------------
assign age_check_active20 = (age_chk_state20 != 3'b000);

endmodule

