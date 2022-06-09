//File25 name   : alut_age_checker25.v
//Title25       : 
//Created25     : 1999
//Description25 : 
//Notes25       : 
//----------------------------------------------------------------------
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------

module alut_age_checker25
(   
   // Inputs25
   pclk25,
   n_p_reset25,
   command,          
   div_clk25,          
   mem_read_data_age25,
   check_age25,        
   last_accessed25, 
   best_bfr_age25,   
   add_check_active25,

   // outputs25
   curr_time25,         
   mem_addr_age25,      
   mem_write_age25,     
   mem_write_data_age25,
   lst_inv_addr_cmd25,    
   lst_inv_port_cmd25,  
   age_confirmed25,     
   age_ok25,
   inval_in_prog25,  
   age_check_active25          
);   

   input               pclk25;               // APB25 clock25                           
   input               n_p_reset25;          // Reset25                               
   input [1:0]         command;            // command bus                        
   input [7:0]         div_clk25;            // clock25 divider25 value
   input [82:0]        mem_read_data_age25;  // read data from memory             
   input               check_age25;          // request flag25 for age25 check
   input [31:0]        last_accessed25;      // time field sent25 for age25 check
   input [31:0]        best_bfr_age25;       // best25 before age25
   input               add_check_active25;   // active flag25 from address checker

   output [31:0]       curr_time25;          // current time,for storing25 in mem    
   output [7:0]        mem_addr_age25;       // address for R/W25 to memory     
   output              mem_write_age25;      // R/W25 flag25 (write = high25)            
   output [82:0]       mem_write_data_age25; // write data for memory             
   output [47:0]       lst_inv_addr_cmd25;   // last invalidated25 addr normal25 op    
   output [1:0]        lst_inv_port_cmd25;   // last invalidated25 port normal25 op    
   output              age_confirmed25;      // validates25 age_ok25 result 
   output              age_ok25;             // age25 checker result - set means25 in-date25
   output              inval_in_prog25;      // invalidation25 in progress25
   output              age_check_active25;   // bit 0 of status register           

   reg  [2:0]          age_chk_state25;      // age25 checker FSM25 current state
   reg  [2:0]          nxt_age_chk_state25;  // age25 checker FSM25 next state
   reg  [7:0]          mem_addr_age25;     
   reg                 mem_write_age25;    
   reg                 inval_in_prog25;      // invalidation25 in progress25
   reg  [7:0]          clk_div_cnt25;        // clock25 divider25 counter
   reg  [31:0]         curr_time25;          // current time,for storing25 in mem  
   reg                 age_confirmed25;      // validates25 age_ok25 result 
   reg                 age_ok25;             // age25 checker result - set means25 in-date25
   reg [47:0]          lst_inv_addr_cmd25;   // last invalidated25 addr normal25 op    
   reg [1:0]           lst_inv_port_cmd25;   // last invalidated25 port normal25 op    

   wire  [82:0]        mem_write_data_age25;
   wire  [31:0]        last_accessed_age25;  // read back time by age25 checker
   wire  [31:0]        time_since_lst_acc_age25;  // time since25 last accessed age25
   wire  [31:0]        time_since_lst_acc25; // time since25 last accessed address
   wire                age_check_active25;   // bit 0 of status register           

// Parameters25 for Address Checking25 FSM25 states25
   parameter idle25           = 3'b000;
   parameter inval_aged_rd25  = 3'b001;
   parameter inval_aged_wr25  = 3'b010;
   parameter inval_all25      = 3'b011;
   parameter age_chk25        = 3'b100;

   parameter max_addr       = 8'hff;
   parameter max_cnt25        = 32'hffff_ffff;

// -----------------------------------------------------------------------------
//   Generate25 current time counter
// -----------------------------------------------------------------------------
always @ (posedge pclk25 or negedge n_p_reset25)
   begin
   if (~n_p_reset25)
      clk_div_cnt25 <= 8'd0;
   else if (clk_div_cnt25 == div_clk25)
      clk_div_cnt25 <= 8'd0; 
   else 
      clk_div_cnt25 <= clk_div_cnt25 + 1'd1;
   end


always @ (posedge pclk25 or negedge n_p_reset25)
   begin
   if (~n_p_reset25)
      curr_time25 <= 32'd0;
   else if (clk_div_cnt25 == div_clk25)
      curr_time25 <= curr_time25 + 1'd1;
   end


// -----------------------------------------------------------------------------
//   Age25 checker State25 Machine25 
// -----------------------------------------------------------------------------
always @ (command or check_age25 or age_chk_state25 or age_confirmed25 or age_ok25 or
          mem_addr_age25 or mem_read_data_age25[82])
   begin
      case (age_chk_state25)
      
      idle25:
         if (command == 2'b10)
            nxt_age_chk_state25 = inval_aged_rd25;
         else if (command == 2'b11)
            nxt_age_chk_state25 = inval_all25;
         else if (check_age25)
            nxt_age_chk_state25 = age_chk25;
         else
            nxt_age_chk_state25 = idle25;

      inval_aged_rd25:
            nxt_age_chk_state25 = age_chk25;

      inval_aged_wr25:
            nxt_age_chk_state25 = idle25;

      inval_all25:
         if (mem_addr_age25 != max_addr)
            nxt_age_chk_state25 = inval_all25;  // move25 onto25 next address
         else
            nxt_age_chk_state25 = idle25;

      age_chk25:
         if (age_confirmed25)
            begin
            if (add_check_active25)                     // age25 check for addr chkr25
               nxt_age_chk_state25 = idle25;
            else if (~mem_read_data_age25[82])      // invalid, check next location25
               nxt_age_chk_state25 = inval_aged_rd25; 
            else if (~age_ok25 & mem_read_data_age25[82]) // out of date25, clear 
               nxt_age_chk_state25 = inval_aged_wr25;
            else if (mem_addr_age25 == max_addr)    // full check completed
               nxt_age_chk_state25 = idle25;     
            else 
               nxt_age_chk_state25 = inval_aged_rd25; // age25 ok, check next location25 
            end       
         else
            nxt_age_chk_state25 = age_chk25;

      default:
            nxt_age_chk_state25 = idle25;
      endcase
   end



always @ (posedge pclk25 or negedge n_p_reset25)
   begin
   if (~n_p_reset25)
      age_chk_state25 <= idle25;
   else
      age_chk_state25 <= nxt_age_chk_state25;
   end


// -----------------------------------------------------------------------------
//   Generate25 memory RW bus for accessing array when requested25 to invalidate25 all
//   aged25 addresses25 and all addresses25.
// -----------------------------------------------------------------------------
always @ (posedge pclk25 or negedge n_p_reset25)
   begin
   if (~n_p_reset25)
   begin
      mem_addr_age25 <= 8'd0;     
      mem_write_age25 <= 1'd0;    
   end
   else if (age_chk_state25 == inval_aged_rd25)  // invalidate25 aged25 read
   begin
      mem_addr_age25 <= mem_addr_age25 + 1'd1;     
      mem_write_age25 <= 1'd0;    
   end
   else if (age_chk_state25 == inval_aged_wr25)  // invalidate25 aged25 read
   begin
      mem_addr_age25 <= mem_addr_age25;     
      mem_write_age25 <= 1'd1;    
   end
   else if (age_chk_state25 == inval_all25)  // invalidate25 all
   begin
      mem_addr_age25 <= mem_addr_age25 + 1'd1;     
      mem_write_age25 <= 1'd1;    
   end
   else if (age_chk_state25 == age_chk25)
   begin
      mem_addr_age25 <= mem_addr_age25;     
      mem_write_age25 <= mem_write_age25;    
   end
   else 
   begin
      mem_addr_age25 <= mem_addr_age25;     
      mem_write_age25 <= 1'd0;    
   end
   end

// age25 checker will only ever25 write zero values to ALUT25 mem
assign mem_write_data_age25 = 83'd0;



// -----------------------------------------------------------------------------
//   Generate25 invalidate25 in progress25 flag25 (bit 1 of status register)
// -----------------------------------------------------------------------------
always @ (posedge pclk25 or negedge n_p_reset25)
   begin
   if (~n_p_reset25)
      inval_in_prog25 <= 1'd0;
   else if (age_chk_state25 == inval_aged_wr25) 
      inval_in_prog25 <= 1'd1;
   else if ((age_chk_state25 == age_chk25) & (mem_addr_age25 == max_addr))
      inval_in_prog25 <= 1'd0;
   else
      inval_in_prog25 <= inval_in_prog25;
   end


// -----------------------------------------------------------------------------
//   Calculate25 whether25 data is still in date25.  Need25 to work25 out the real time
//   gap25 between current time and last accessed.  If25 this gap25 is greater than
//   the best25 before age25, then25 the data is out of date25. 
// -----------------------------------------------------------------------------
assign time_since_lst_acc25 = (curr_time25 > last_accessed25) ? 
                            (curr_time25 - last_accessed25) :  // no cnt wrapping25
                            (curr_time25 + (max_cnt25 - last_accessed25));

assign time_since_lst_acc_age25 = (curr_time25 > last_accessed_age25) ? 
                                (curr_time25 - last_accessed_age25) : // no wrapping25
                                (curr_time25 + (max_cnt25 - last_accessed_age25));


always @ (posedge pclk25 or negedge n_p_reset25)
   begin
   if (~n_p_reset25)
      begin
      age_ok25 <= 1'b0;
      age_confirmed25 <= 1'b0;
      end
   else if ((age_chk_state25 == age_chk25) & add_check_active25) 
      begin                                       // age25 checking for addr chkr25
      if (best_bfr_age25 > time_since_lst_acc25)      // still in date25
         begin
         age_ok25 <= 1'b1;
         age_confirmed25 <= 1'b1;
         end
      else   // out of date25
         begin
         age_ok25 <= 1'b0;
         age_confirmed25 <= 1'b1;
         end
      end
   else if ((age_chk_state25 == age_chk25) & ~add_check_active25)
      begin                                      // age25 checking for inval25 aged25
      if (best_bfr_age25 > time_since_lst_acc_age25) // still in date25
         begin
         age_ok25 <= 1'b1;
         age_confirmed25 <= 1'b1;
         end
      else   // out of date25
         begin
         age_ok25 <= 1'b0;
         age_confirmed25 <= 1'b1;
         end
      end
   else
      begin
      age_ok25 <= 1'b0;
      age_confirmed25 <= 1'b0;
      end
   end



// -----------------------------------------------------------------------------
//   Generate25 last address and port that was cleared25 in the invalid aged25 process
// -----------------------------------------------------------------------------
always @ (posedge pclk25 or negedge n_p_reset25)
   begin
   if (~n_p_reset25)
      begin
      lst_inv_addr_cmd25 <= 48'd0;
      lst_inv_port_cmd25 <= 2'd0;
      end
   else if (age_chk_state25 == inval_aged_wr25)
      begin
      lst_inv_addr_cmd25 <= mem_read_data_age25[47:0];
      lst_inv_port_cmd25 <= mem_read_data_age25[49:48];
      end
   else 
      begin
      lst_inv_addr_cmd25 <= lst_inv_addr_cmd25;
      lst_inv_port_cmd25 <= lst_inv_port_cmd25;
      end
   end


// -----------------------------------------------------------------------------
//   Set active bit of status, decoded25 off25 age_chk_state25
// -----------------------------------------------------------------------------
assign age_check_active25 = (age_chk_state25 != 3'b000);

endmodule

