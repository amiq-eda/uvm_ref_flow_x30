//File4 name   : alut_reg_bank4.v
//Title4       : 
//Created4     : 1999
//Description4 : 
//Notes4       : 
//----------------------------------------------------------------------
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------

// compiler4 directives4
`include "alut_defines4.v"


module alut_reg_bank4
(   
   // Inputs4
   pclk4,
   n_p_reset4,
   psel4,            
   penable4,       
   pwrite4,         
   paddr4,           
   pwdata4,          

   curr_time4,
   add_check_active4,
   age_check_active4,
   inval_in_prog4,
   reused4,
   d_port4,
   lst_inv_addr_nrm4,
   lst_inv_port_nrm4,
   lst_inv_addr_cmd4,
   lst_inv_port_cmd4,

   // Outputs4
   mac_addr4,    
   d_addr4,   
   s_addr4,    
   s_port4,    
   best_bfr_age4,
   div_clk4,     
   command, 
   prdata4,  
   clear_reused4           
);


   // APB4 Inputs4
   input                 pclk4;             // APB4 clock4
   input                 n_p_reset4;        // Reset4
   input                 psel4;             // Module4 select4 signal4
   input                 penable4;          // Enable4 signal4 
   input                 pwrite4;           // Write when HIGH4 and read when LOW4
   input [6:0]           paddr4;            // Address bus for read write
   input [31:0]          pwdata4;           // APB4 write bus

   // Inputs4 from other ALUT4 blocks
   input [31:0]          curr_time4;        // current time
   input                 add_check_active4; // used to calculate4 status[0]
   input                 age_check_active4; // used to calculate4 status[0]
   input                 inval_in_prog4;    // status[1]
   input                 reused4;           // status[2]
   input [4:0]           d_port4;           // calculated4 destination4 port for tx4
   input [47:0]          lst_inv_addr_nrm4; // last invalidated4 addr normal4 op
   input [1:0]           lst_inv_port_nrm4; // last invalidated4 port normal4 op
   input [47:0]          lst_inv_addr_cmd4; // last invalidated4 addr via cmd4
   input [1:0]           lst_inv_port_cmd4; // last invalidated4 port via cmd4
   

   output [47:0]         mac_addr4;         // address of the switch4
   output [47:0]         d_addr4;           // address of frame4 to be checked4
   output [47:0]         s_addr4;           // address of frame4 to be stored4
   output [1:0]          s_port4;           // source4 port of current frame4
   output [31:0]         best_bfr_age4;     // best4 before age4
   output [7:0]          div_clk4;          // programmed4 clock4 divider4 value
   output [1:0]          command;          // command bus
   output [31:0]         prdata4;           // APB4 read bus
   output                clear_reused4;     // indicates4 status reg read 

   reg    [31:0]         prdata4;           //APB4 read bus   
   reg    [31:0]         frm_d_addr_l4;     
   reg    [15:0]         frm_d_addr_u4;     
   reg    [31:0]         frm_s_addr_l4;     
   reg    [15:0]         frm_s_addr_u4;     
   reg    [1:0]          s_port4;           
   reg    [31:0]         mac_addr_l4;       
   reg    [15:0]         mac_addr_u4;       
   reg    [31:0]         best_bfr_age4;     
   reg    [7:0]          div_clk4;          
   reg    [1:0]          command;          
   reg    [31:0]         lst_inv_addr_l4;   
   reg    [15:0]         lst_inv_addr_u4;   
   reg    [1:0]          lst_inv_port4;     


   // Internal Signal4 Declarations4
   wire                  read_enable4;      //APB4 read enable
   wire                  write_enable4;     //APB4 write enable
   wire   [47:0]         mac_addr4;        
   wire   [47:0]         d_addr4;          
   wire   [47:0]         src_addr4;        
   wire                  clear_reused4;    
   wire                  active;

   // ----------------------------
   // General4 Assignments4
   // ----------------------------

   assign read_enable4    = (psel4 & ~penable4 & ~pwrite4);
   assign write_enable4   = (psel4 & penable4 & pwrite4);

   assign mac_addr4  = {mac_addr_u4, mac_addr_l4}; 
   assign d_addr4 =    {frm_d_addr_u4, frm_d_addr_l4};
   assign s_addr4    = {frm_s_addr_u4, frm_s_addr_l4}; 

   assign clear_reused4 = read_enable4 & (paddr4 == `AL_STATUS4) & ~active;

   assign active = (add_check_active4 | age_check_active4);

// ------------------------------------------------------------------------
//   Read Mux4 Control4 Block
// ------------------------------------------------------------------------

   always @ (posedge pclk4 or negedge n_p_reset4)
      begin 
      if (~n_p_reset4)
         prdata4 <= 32'h0000_0000;
      else if (read_enable4)
         begin
         case (paddr4)
            `AL_FRM_D_ADDR_L4   : prdata4 <= frm_d_addr_l4;
            `AL_FRM_D_ADDR_U4   : prdata4 <= {16'd0, frm_d_addr_u4};    
            `AL_FRM_S_ADDR_L4   : prdata4 <= frm_s_addr_l4; 
            `AL_FRM_S_ADDR_U4   : prdata4 <= {16'd0, frm_s_addr_u4}; 
            `AL_S_PORT4         : prdata4 <= {30'd0, s_port4}; 
            `AL_D_PORT4         : prdata4 <= {27'd0, d_port4}; 
            `AL_MAC_ADDR_L4     : prdata4 <= mac_addr_l4;
            `AL_MAC_ADDR_U4     : prdata4 <= {16'd0, mac_addr_u4};   
            `AL_CUR_TIME4       : prdata4 <= curr_time4; 
            `AL_BB_AGE4         : prdata4 <= best_bfr_age4;
            `AL_DIV_CLK4        : prdata4 <= {24'd0, div_clk4}; 
            `AL_STATUS4         : prdata4 <= {29'd0, reused4, inval_in_prog4,
                                           active};
            `AL_LST_INV_ADDR_L4 : prdata4 <= lst_inv_addr_l4; 
            `AL_LST_INV_ADDR_U4 : prdata4 <= {16'd0, lst_inv_addr_u4};
            `AL_LST_INV_PORT4   : prdata4 <= {30'd0, lst_inv_port4};

            default:   prdata4 <= 32'h0000_0000;
         endcase
         end
      else
         prdata4 <= 32'h0000_0000;
      end 



// ------------------------------------------------------------------------
//   APB4 writable4 registers
// ------------------------------------------------------------------------
// Lower4 destination4 frame4 address register  
   always @ (posedge pclk4 or negedge n_p_reset4)
      begin 
      if (~n_p_reset4)
         frm_d_addr_l4 <= 32'h0000_0000;         
      else if (write_enable4 & (paddr4 == `AL_FRM_D_ADDR_L4))
         frm_d_addr_l4 <= pwdata4;
      else
         frm_d_addr_l4 <= frm_d_addr_l4;
      end   


// Upper4 destination4 frame4 address register  
   always @ (posedge pclk4 or negedge n_p_reset4)
      begin 
      if (~n_p_reset4)
         frm_d_addr_u4 <= 16'h0000;         
      else if (write_enable4 & (paddr4 == `AL_FRM_D_ADDR_U4))
         frm_d_addr_u4 <= pwdata4[15:0];
      else
         frm_d_addr_u4 <= frm_d_addr_u4;
      end   


// Lower4 source4 frame4 address register  
   always @ (posedge pclk4 or negedge n_p_reset4)
      begin 
      if (~n_p_reset4)
         frm_s_addr_l4 <= 32'h0000_0000;         
      else if (write_enable4 & (paddr4 == `AL_FRM_S_ADDR_L4))
         frm_s_addr_l4 <= pwdata4;
      else
         frm_s_addr_l4 <= frm_s_addr_l4;
      end   


// Upper4 source4 frame4 address register  
   always @ (posedge pclk4 or negedge n_p_reset4)
      begin 
      if (~n_p_reset4)
         frm_s_addr_u4 <= 16'h0000;         
      else if (write_enable4 & (paddr4 == `AL_FRM_S_ADDR_U4))
         frm_s_addr_u4 <= pwdata4[15:0];
      else
         frm_s_addr_u4 <= frm_s_addr_u4;
      end   


// Source4 port  
   always @ (posedge pclk4 or negedge n_p_reset4)
      begin 
      if (~n_p_reset4)
         s_port4 <= 2'b00;         
      else if (write_enable4 & (paddr4 == `AL_S_PORT4))
         s_port4 <= pwdata4[1:0];
      else
         s_port4 <= s_port4;
      end   


// Lower4 switch4 MAC4 address
   always @ (posedge pclk4 or negedge n_p_reset4)
      begin 
      if (~n_p_reset4)
         mac_addr_l4 <= 32'h0000_0000;         
      else if (write_enable4 & (paddr4 == `AL_MAC_ADDR_L4))
         mac_addr_l4 <= pwdata4;
      else
         mac_addr_l4 <= mac_addr_l4;
      end   


// Upper4 switch4 MAC4 address 
   always @ (posedge pclk4 or negedge n_p_reset4)
      begin 
      if (~n_p_reset4)
         mac_addr_u4 <= 16'h0000;         
      else if (write_enable4 & (paddr4 == `AL_MAC_ADDR_U4))
         mac_addr_u4 <= pwdata4[15:0];
      else
         mac_addr_u4 <= mac_addr_u4;
      end   


// Best4 before age4 
   always @ (posedge pclk4 or negedge n_p_reset4)
      begin 
      if (~n_p_reset4)
         best_bfr_age4 <= 32'hffff_ffff;         
      else if (write_enable4 & (paddr4 == `AL_BB_AGE4))
         best_bfr_age4 <= pwdata4;
      else
         best_bfr_age4 <= best_bfr_age4;
      end   


// clock4 divider4
   always @ (posedge pclk4 or negedge n_p_reset4)
      begin 
      if (~n_p_reset4)
         div_clk4 <= 8'h00;         
      else if (write_enable4 & (paddr4 == `AL_DIV_CLK4))
         div_clk4 <= pwdata4[7:0];
      else
         div_clk4 <= div_clk4;
      end   


// command.  Needs to be automatically4 cleared4 on following4 cycle
   always @ (posedge pclk4 or negedge n_p_reset4)
      begin 
      if (~n_p_reset4)
         command <= 2'b00; 
      else if (command != 2'b00)
         command <= 2'b00; 
      else if (write_enable4 & (paddr4 == `AL_COMMAND4))
         command <= pwdata4[1:0];
      else
         command <= command;
      end   


// ------------------------------------------------------------------------
//   Last4 invalidated4 port and address values.  These4 can either4 be updated
//   by normal4 operation4 of address checker overwriting4 existing values or
//   by the age4 checker being commanded4 to invalidate4 out of date4 values.
// ------------------------------------------------------------------------
   always @ (posedge pclk4 or negedge n_p_reset4)
      begin 
      if (~n_p_reset4)
      begin
         lst_inv_addr_l4 <= 32'd0;
         lst_inv_addr_u4 <= 16'd0;
         lst_inv_port4   <= 2'd0;
      end
      else if (reused4)        // reused4 flag4 from address checker
      begin
         lst_inv_addr_l4 <= lst_inv_addr_nrm4[31:0];
         lst_inv_addr_u4 <= lst_inv_addr_nrm4[47:32];
         lst_inv_port4   <= lst_inv_port_nrm4;
      end
//      else if (command == 2'b01)  // invalidate4 aged4 from age4 checker
      else if (inval_in_prog4)  // invalidate4 aged4 from age4 checker
      begin
         lst_inv_addr_l4 <= lst_inv_addr_cmd4[31:0];
         lst_inv_addr_u4 <= lst_inv_addr_cmd4[47:32];
         lst_inv_port4   <= lst_inv_port_cmd4;
      end
      else
      begin
         lst_inv_addr_l4 <= lst_inv_addr_l4;
         lst_inv_addr_u4 <= lst_inv_addr_u4;
         lst_inv_port4   <= lst_inv_port4;
      end
      end
 


`ifdef ABV_ON4

defparam i_apb_monitor4.ABUS_WIDTH4 = 7;

// APB4 ASSERTION4 VIP4
apb_monitor4 i_apb_monitor4(.pclk_i4(pclk4), 
                          .presetn_i4(n_p_reset4),
                          .penable_i4(penable4),
                          .psel_i4(psel4),
                          .paddr_i4(paddr4),
                          .pwrite_i4(pwrite4),
                          .pwdata_i4(pwdata4),
                          .prdata_i4(prdata4)); 

// psl4 default clock4 = (posedge pclk4);

// ASSUMPTIONS4
//// active (set by address checker) and invalidation4 in progress4 should never both be set
//// psl4 assume_never_active_inval_aged4 : assume never (active & inval_in_prog4);


// ASSERTION4 CHECKS4
// never read and write at the same time
// psl4 assert_never_rd_wr4 : assert never (read_enable4 & write_enable4);

// check apb4 writes, pick4 command reqister4 as arbitary4 example4
// psl4 assert_cmd_wr4 : assert always ((paddr4 == `AL_COMMAND4) & write_enable4) -> 
//                                    next(command == prev(pwdata4[1:0])) abort4(~n_p_reset4);


// check rw writes, pick4 clock4 divider4 reqister4 as arbitary4 example4.  It takes4 2 cycles4 to write
// then4 read back data, therefore4 need to store4 original write data for use in assertion4 check
reg [31:0] pwdata_d4;  // 1 cycle delayed4 
always @ (posedge pclk4) pwdata_d4 <= pwdata4;

// psl4 assert_rw_div_clk4 : 
// assert always {((paddr4 == `AL_DIV_CLK4) & write_enable4) ; ((paddr4 == `AL_DIV_CLK4) & read_enable4)} |=>
// {prev(pwdata_d4[7:0]) == prdata4[7:0]};



// COVER4 SANITY4 CHECKS4
// sanity4 read
// psl4 output_for_div_clk4 : cover {((paddr4 == `AL_DIV_CLK4) & read_enable4); prdata4[7:0] == 8'h55};


`endif


endmodule 


